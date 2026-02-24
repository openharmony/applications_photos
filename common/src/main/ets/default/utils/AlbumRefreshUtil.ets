/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Log } from './Log';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { ParamsWrapper } from '../view/actionbar/Menu';
import lazy { MediaObserverNfyInfoForAlbums  } from '../model/browser/dataObserver/MediaObserverCallback';
import lazy { DeviceInfo } from './DeviceInfo';

/* instrument ignore file */
const TAG = 'AlbumRefreshUtil';

export enum DataSourceType {
  User = 'User', // 用户相册区域的 albumSetDataSource，实际上并不一定只包含用户相册
  Source = 'Source',
  Trashed = 'Trashed',
  Hidden = 'Hidden',
}

export enum AlbumRefreshConst {
  EVENT_KEY_APPEAR = 'com.ohos.photos.photo_grid_view.appear',
  EVENT_KEY_DISAPPEAR = 'com.ohos.photos.photo_grid_view.disappear',
  EVENT_KEY_ENTER_ALBUM = 'com.ohos.photos.album_grid_new_style.onclick',
  KEY_OF_ALBUM_NAV_PARAM_LISTENER = 'com.ohos.photos.album_refresh_util.key_of_active',
  KEY_OF_ALBUM_NAV_PARAM_DATASOURCE = 'com.ohos.photos.album_refresh_util.key_of_datasource',
  KEY_OF_ALBUM_NAV_PARAM_IS_NEW_ALBUM = 'com.ohos.photos.album_refresh_util.is_new_album',
}

export interface PageStatusListener {
  onAppear: () => void;
  onDisappear: () => void;
}

export interface OnAlbumClickListener {
  onAlbumClicked: (info: AlbumInfo) => PageStatusListener | undefined;
}

export enum SharedAlbumAssetItems {
  albumId = 'albumUri',
  albumType = 'albumType',
  albumSubtype = 'albumSubtype',
  albumName = 'albumName',
  coverUri = 'coverUri',
  count = 'count',
  imageCount = 'imageCount',
  videoCount = 'videoCount',
  orderSection = 'orderSection',
  albumOrder = 'albumOrder',
  hiddenCount = 'hiddenCount',
  hiddenCoverUri = 'hiddenCoverUri',
}

enum RefreshDFX {
  ignore = -1,
  reset,
  loadDbForSys,
  createUser,
  update,
  delete,
}

export class AlbumRefreshUtil {
  private static isPcOrTablet: boolean = DeviceInfo.isPcOrTablet();
  private static isTv: boolean = DeviceInfo.isTv();
  private static isGRLFoldScreen: boolean = DeviceInfo.isGRLFoldScreen();
  private static hasPreciseInfo: boolean = false;
  // 精准通知的相册的信息：系统相册+用户相册
  private static preciseRefreshGridAlbums: Map<string, ParamsWrapper> = new Map<string, ParamsWrapper>();
  private static albumsAdd: Set<ParamsWrapper> = new Set<ParamsWrapper>();
  private static renameAlbumNewUri: string = '';
  private static dfxInfo: Map<DataSourceType, RefreshDFX[]> = new Map();
  private static hiddenAlbumPreciseInfo: Map<string, ParamsWrapper> = new Map<string, ParamsWrapper>();
  private static hasHiddenPreciseInfo: boolean = false;
  private static trashedAlbumPreciseInfo: Map<string, ParamsWrapper> = new Map<string, ParamsWrapper>();
  private static hasTrashedPreciseInfo: boolean = false;

  public static onDestroy(): void {
    AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.User);
    AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.Hidden);
    AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.Trashed);

    AlbumRefreshUtil.dfxInfo.clear();
  }

  // 侧边栏模式暂未适配精细化通知，忽略精细化通知
  // AlbumRefreshUtil.isGRLFoldScreen 仅初始化一次，减少非grl设备的判断
  public static isIgnorePrecise(): boolean {
    return AlbumRefreshUtil.isPcOrTablet || AlbumRefreshUtil.isTv ||
      (AlbumRefreshUtil.isGRLFoldScreen && DeviceInfo.isGRLFoldExpanded());
  }

  // 侧边栏模式暂未适配精细化通知。并且新接口里，pc上，最近删除DataSource使用albumSetDataSource进行响应，而新接口删除通知与非删除通知隔离
  public static isSupportAccurateNotify(): boolean {
    return !AlbumRefreshUtil.isPcOrTablet && !AlbumRefreshUtil.isTv && !AlbumRefreshUtil.isGRLFoldScreen;
  }

  public static setPreciseAlbumInfo(type: DataSourceType, param: MediaObserverNfyInfoForAlbums): void {
    if (AlbumRefreshUtil.isIgnorePrecise()) {
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    let albumChangeDatas = param?.albumChangeDatas;
    // 通知异常下，走查询逻辑
    if (!albumChangeDatas || albumChangeDatas.length === 0) {
      Log.info(TAG, 'return for param albumChangeDatas does not meet expectations');
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    for (let albumChangeData of albumChangeDatas) {
      // 通知异常下，走查询逻辑
      if (!albumChangeData) {
        Log.info(TAG, '[preciseInfo] return for param sharedAlbumAsset undefined');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      if (!AlbumRefreshUtil.hasPreciseInfo) {
        Log.info(TAG, '[preciseInfo] has precise info will change to true, type user');
        AlbumRefreshUtil.hasPreciseInfo = true;
      }

      /*
       * 单条通知的精细化处理逻辑
       * 新通知包含该相册变化前 before， 与变化后 after 的逻辑，以下逻辑以两个字母表示两个字段的含义
       * 通知为 null记作 f，通知正常包含信息记作 t
       * 1. ff 前后均无有效通知信息，走查询逻辑，resetNeedLoadStatus
       * 2. ft 从通知的角度，判断为新增相册逻辑
       *   2.1 新增用户相册，可以直接显示，存于 albumsAdd
       *   2.2 新增系统、来源相册，由于当前无 orderSection、order 字段用以判断是否经过排序，所以位置不固定，
       *       字段新增后与 count 一起判断，resetNeedLoadStatus
       * 3. tf 相册信息被删除，走删除逻辑，存于 preciseRefreshGridAlbums
       * 4. tt 相册更新
       *   4.1 用户相册，走更新逻辑，存于 preciseRefreshGridAlbums
       *   4.2 系统、来源更新。0 表示count为0，1表示不为0，2表示更新
       *     4.2.1 count 0 -> 1 新增场景，同2.2 无法确认位置，待后续进一步优化，存于 resetNeedLoadStatus
       *     4.2.2 count 1 -> 0 用户体验来说，不显示该相册，走删除逻辑，存于 preciseRefreshGridAlbums
       *     4.2.3 count 1 -> 2 更新逻辑，存于 preciseRefreshGridAlbums
       *
       * resetNeedLoadStatus：清除通知信息，无法精准更新，从而触发查询逻辑
       * preciseRefreshGridAlbums：相册更新：内容存在则更新；内容为空，即new ParamsWrapper()，无法访问则进行删除
       * albumsAdd：相册删除。因 map 的key 只对应一个value，单独处理
       * */

      let albumBeforeUri: string = albumChangeData?.albumBeforeChange?.albumUri ?? '';
      let albumAfterAsset: photoAccessHelper.AlbumChangeInfo | null = albumChangeData?.albumAfterChange;
      let albumParams: ParamsWrapper | undefined = undefined;

      if (albumBeforeUri === '') {
        // ff, 1: resetNeedLoadStatus
        if (albumAfterAsset === null) {
          Log.info(TAG, '[preciseInfo] setPreciseAlbumInfo will load for after is null');
          AlbumRefreshUtil.resetNeedLoadStatus(type);
          AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
          return;
        }

        // 新增用户相册场景: tf, 2.1
        if (albumChangeData?.albumAfterChange?.albumType === photoAccessHelper.AlbumType.USER) {

          // 当前阶段，非按名称排序场景，即未排序与自定义排序场景，新增的用户相册应排最后
          // 注意：后续若相册排序字段上云后，此逻辑需要进行处理
          albumParams = AlbumRefreshUtil.initParam(albumAfterAsset);
          AlbumRefreshUtil.albumsAdd.add(albumParams);
          AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.createUser);
          continue;
        }

        // tf, 2.2
        Log.info(TAG, '[preciseInfo] setPreciseAlbumInfo will load for add sys or source');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      // 刪除相册场景, tf, 3
      // 系统、来源count为0，走下方的逻辑，通知里after不会为null，而是count为0
      if (albumAfterAsset === null) {
        AlbumRefreshUtil.preciseRefreshGridAlbums.set(albumBeforeUri, new ParamsWrapper());
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.delete);
        continue;
      }

      // tt, 4.1
      if (albumChangeData?.albumAfterChange?.albumType === photoAccessHelper.AlbumType.USER) {
        albumParams = AlbumRefreshUtil.initParam(albumAfterAsset);
        AlbumRefreshUtil.preciseRefreshGridAlbums.set(albumBeforeUri, albumParams);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.update);
        continue;
      }

      // tt, 4.2.1 系统、来源 0 -> 1
      if (albumChangeData?.albumBeforeChange?.count === 0) {
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      // tt, 4.2.2 系统、来源 1 -> 0
      if (albumChangeData?.albumAfterChange?.count === 0) {
        AlbumRefreshUtil.preciseRefreshGridAlbums.set(albumBeforeUri, new ParamsWrapper());
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.delete);
        continue;
      }

      // tt, 4.2.3 count 1 -> 2
      albumParams = AlbumRefreshUtil.initParam(albumAfterAsset);
      AlbumRefreshUtil.preciseRefreshGridAlbums.set(albumBeforeUri, albumParams);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.update);
    }
  }

  public static setHiddenAlbumPreciseAlbumInfo(type: DataSourceType, param: MediaObserverNfyInfoForAlbums): void {
    if (AlbumRefreshUtil.isIgnorePrecise()) {
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    let albumChangeDatas = param?.albumChangeDatas;
    // 通知异常下，走查询逻辑
    if (!albumChangeDatas || albumChangeDatas.length === 0) {
      Log.info(TAG, 'return for param albumChangeDatas does not meet expectations');
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    for (let albumChangeData of albumChangeDatas) {
      // 通知异常下，走查询逻辑
      if (!albumChangeData) {
        Log.info(TAG, '[preciseInfo] return for param sharedAlbumAsset undefined');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      /*
       * 单条通知的精细化处理逻辑
       * 隐藏相册内，某一相册 hiddenCount 为0，相册均不显示先走查询
       * */

      let albumBeforeUri: string = albumChangeData?.albumBeforeChange?.albumUri ?? '';
      let albumAfterAsset: photoAccessHelper.AlbumChangeInfo | null = albumChangeData?.albumAfterChange;
      let albumParams: ParamsWrapper | undefined = undefined;

      if (albumBeforeUri === '' || albumAfterAsset === null) {
        Log.info(TAG, '[preciseInfo] setPreciseAlbumInfo will load for add sys or source');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      if (albumChangeData?.albumBeforeChange?.hiddenCount === 0) {
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      if (albumChangeData?.albumAfterChange?.hiddenCount === 0) {
        AlbumRefreshUtil.hiddenAlbumPreciseInfo.set(albumBeforeUri, new ParamsWrapper());
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.delete);
        continue;
      }

      if (!AlbumRefreshUtil.hasHiddenPreciseInfo) {
        Log.info(TAG, '[preciseInfo] has precise info will change to true, type hidden');
        AlbumRefreshUtil.hasHiddenPreciseInfo = true;
      }

      albumParams = AlbumRefreshUtil.initParam(albumAfterAsset);
      AlbumRefreshUtil.hiddenAlbumPreciseInfo.set(albumBeforeUri, albumParams);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.update);
    }
  }

  public static setTrashedAlbumPreciseAlbumInfo(type: DataSourceType, param: MediaObserverNfyInfoForAlbums): void {
    if (AlbumRefreshUtil.isIgnorePrecise()) {
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    let albumChangeDatas = param?.albumChangeDatas;
    // 通知异常下，走查询逻辑
    if (!albumChangeDatas || albumChangeDatas.length === 0) {
      Log.info(TAG, 'return for param albumChangeDatas does not meet expectations');
      AlbumRefreshUtil.resetNeedLoadStatus(type);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
      return;
    }

    for (let albumChangeData of albumChangeDatas) {
      // 通知异常下，走查询逻辑
      if (!albumChangeData) {
        Log.info(TAG, '[preciseInfo] return for param sharedAlbumAsset undefined');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }

      /*
       * 单条通知的精细化处理逻辑
       * 最近删除相册通知，结果目前不止包含最近删除相册，若媒体库优化通知后可优化保存
       * */

      let albumBeforeUri: string = albumChangeData?.albumBeforeChange?.albumUri ?? '';
      let albumAfterAsset: photoAccessHelper.AlbumChangeInfo | null = albumChangeData?.albumAfterChange;
      let albumParams: ParamsWrapper | undefined = undefined;

      if (albumBeforeUri === '' || albumAfterAsset === null) {
        Log.info(TAG, '[preciseInfo] setPreciseAlbumInfo will load for add sys or source');
        AlbumRefreshUtil.resetNeedLoadStatus(type);
        AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.reset);
        return;
      }


      if (!AlbumRefreshUtil.hasTrashedPreciseInfo) {
        Log.info(TAG, '[preciseInfo] has precise info will change to true, type trashed');
        AlbumRefreshUtil.hasTrashedPreciseInfo = true;
      }

      albumParams = AlbumRefreshUtil.initParam(albumAfterAsset);
      AlbumRefreshUtil.trashedAlbumPreciseInfo.set(albumBeforeUri, albumParams);
      AlbumRefreshUtil.albumRefreshDFX(type, RefreshDFX.update);
    }
  }

  private static initParam(albumInfo: photoAccessHelper.AlbumChangeInfo): ParamsWrapper {
    let albumParam = new ParamsWrapper()
      .set(SharedAlbumAssetItems.albumId, albumInfo.albumUri)
      .set(SharedAlbumAssetItems.albumType, albumInfo.albumType)
      .set(SharedAlbumAssetItems.albumSubtype, albumInfo.albumSubtype)
      .set(SharedAlbumAssetItems.albumName, albumInfo.albumName)
      .set(SharedAlbumAssetItems.coverUri, albumInfo.coverUri)
      .set(SharedAlbumAssetItems.count, albumInfo.count)
      .set(SharedAlbumAssetItems.imageCount, albumInfo.imageCount)
      .set(SharedAlbumAssetItems.videoCount, albumInfo.videoCount)
      .set(SharedAlbumAssetItems.hiddenCount, albumInfo.hiddenCount)
      .set(SharedAlbumAssetItems.hiddenCoverUri, albumInfo.hiddenCoverUri)
      // orderSection, albumOrder 字段待媒体库添加后修改
    return albumParam;
  }

  /**
   * 重置需要查询数据库的状态
   * 清空精准通知字典
   * 设置需要查询数据库
   * @returns
   */
  public static resetNeedLoadStatus(type: DataSourceType): void {
    Log.info(TAG, `[preciseInfo] resetNeedLoadStatus with type: ${type}`);
    switch (type) {
      case DataSourceType.User:
        AlbumRefreshUtil.preciseRefreshGridAlbums.clear();
        AlbumRefreshUtil.hasPreciseInfo = false;
        AlbumRefreshUtil.albumsAdd.clear();
        AlbumRefreshUtil.setRenameAlbumInfo('');
        break;
      case DataSourceType.Hidden:
        AlbumRefreshUtil.hiddenAlbumPreciseInfo.clear();
        AlbumRefreshUtil.hasHiddenPreciseInfo = false;
        break;
      case DataSourceType.Trashed:
        AlbumRefreshUtil.trashedAlbumPreciseInfo.clear();
        AlbumRefreshUtil.hasTrashedPreciseInfo = false;
        break;
      default:
        break;
    }
  }

  public static getPreciseInfoMap(type: DataSourceType): Map<string, ParamsWrapper> {
    AlbumRefreshUtil.printAlbumRefreshDFX(type);
    switch (type) {
      case DataSourceType.User:
        return AlbumRefreshUtil.preciseRefreshGridAlbums;
      case DataSourceType.Hidden:
        return AlbumRefreshUtil.hiddenAlbumPreciseInfo;
      case DataSourceType.Trashed:
        return AlbumRefreshUtil.trashedAlbumPreciseInfo;
      default:
        Log.info(TAG, `[preciseInfo] get precise info map with unexpective type: ${type}`);
        return new Map();
    }
  }

  public static getPreciseAlbumsAdd(): Set<ParamsWrapper> {
    return AlbumRefreshUtil.albumsAdd;
  }

  public static getHasPreciseInfo(type: DataSourceType): boolean {
    if (AlbumRefreshUtil.isIgnorePrecise()) {
      return false;
    }
    switch (type) {
      case DataSourceType.User:
        return AlbumRefreshUtil.hasPreciseInfo;
      case DataSourceType.Hidden:
        return AlbumRefreshUtil.hasHiddenPreciseInfo;
      case DataSourceType.Trashed:
        return AlbumRefreshUtil.hasTrashedPreciseInfo;
      default:
        Log.info(TAG, `[preciseInfo] get has precise info with unexpective type ${type}`);
        return false;
    }
  }

  public static setRenameAlbumInfo(newUri: string): void {
    AlbumRefreshUtil.renameAlbumNewUri = newUri;
  }

  private static async albumRefreshDFX(type: DataSourceType, info: RefreshDFX): Promise<void> {
    Log.info(TAG, `[preciseInfo] albumRefreshDFX input type: ${type}, info: ${info}`);
    /* instrument ignore if */
    if (!type || !info) {
      Log.warn(TAG, 'albumRefreshDFX input type or info error');
      return;
    }
    if (!AlbumRefreshUtil.dfxInfo.has(type)) {
      AlbumRefreshUtil.dfxInfo.set(type, []);
    }
    AlbumRefreshUtil.dfxInfo.get(type)?.push(info);
  }

  private static async printAlbumRefreshDFX(type: DataSourceType): Promise<void> {
    Log.info(TAG, `[preciseInfo] album refresh type ${type}, info: ` + JSON.stringify(AlbumRefreshUtil.dfxInfo.get(type)));
    AlbumRefreshUtil.dfxInfo.set(type, []);
  }
}
