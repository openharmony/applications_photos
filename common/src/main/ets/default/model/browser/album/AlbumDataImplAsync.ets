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

import lazy { AlbumCallBackParam, AlbumDefine } from '../AlbumDefine';
import lazy { AlbumInfo } from './AlbumInfo';
import type { AsyncCallback } from '../../common/AsyncCallback';
import type { PhotoAlbum } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess, toString } from '../../../access/UserFileManagerAccess';
import lazy { Log } from '../../../utils/Log';
import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { getAlbumsCountTask, getAlbumsTask } from './AlbumDataConcurrent';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AlbumDataImpl } from './AlbumDataImpl';
import lazy { common } from '@kit.AbilityKit';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';

const TAG: string = 'common_AlbumDataImplAsync';

export interface AlbumResult {
  sourceData: AlbumInfo[];
  userAlbumCount: number;
  systemAlbumCount: number;
}

export class AlbumDataImplAsync extends AlbumDataImpl {
  private userFileManagerAccess: UserFileManagerAccess | undefined = new UserFileManagerAccess();

  constructor() {
    super();
  }

  public onCreate(context: common.Context | undefined): void {
    this.userFileManagerAccess = UserFileManagerAccess.getInstance();
    this.userFileManagerAccess.onCreate(context);
  }

  /**
   * 查询相册信息（系统相册和用户相册）
   *
   * @param callback 回调函数
   * @param start 起始下标
   * @param count 查询数量
   * @param filterMediaType 媒体类型
   * @param blackUriList 黑名单
   * @param nameOnly 只查询名称
   * @param hasItemsOnly 是否只查items
   * @returns 返回结果
   */
  /* instrument ignore next */
  protected async getAlbums(callback: AsyncCallback<AlbumInfo[]>, start: number, count: number,
    filterMediaType?: string, blackUriList?: string[], nameOnly?: boolean, hasItemsOnly?: boolean): Promise<void> {
    Log.info(TAG, 'getAlbums, start');
    if (count === 0) {
      Log.error(TAG, `getAlbums end, ${count} album need to query`);
      return;
    }

    // 封装查询参数
    let queryParam: QueryAlbumParam = {
      start: start,
      count: count,
      filterMediaType: filterMediaType,
      blackUriList: blackUriList,
      nameOnly: nameOnly,
      hasItemsOnly: hasItemsOnly,
    }
    Log.info(TAG, `getAlbums, queryParam = ${JSON.stringify(queryParam)}`);

    // 调用taskpool异步执行
    let context: Context = getContext(this) || global.uiAbilityContext();
    let albumResult = await taskpool.execute(getAlbumsTask, queryParam, context) as AlbumResult;

    // 序列化返回的数据丢失了@Observe属性，需要sourceData重新创建赋值
    let sourceData: AlbumInfo[] = [];
    for (let objFromSubThread of albumResult.sourceData) {
      let objOfMainThread = new AlbumInfo();
      objOfMainThread.uri = objFromSubThread.uri;
      objOfMainThread.videoCount = objFromSubThread.videoCount;
      objOfMainThread.coverUri = objFromSubThread.coverUri;
      objOfMainThread.coverUriSource = objFromSubThread.coverUriSource;
      objOfMainThread.count = objFromSubThread.count;
      objOfMainThread.isSystemAlbum = objFromSubThread.isSystemAlbum;
      objOfMainThread.isTrashAlbum = objFromSubThread.isTrashAlbum;
      objOfMainThread.isFavorAlbum = objFromSubThread.isFavorAlbum;
      objOfMainThread.isVideoAlbum = objFromSubThread.isVideoAlbum;
      objOfMainThread.isScreenShotAlbum = objFromSubThread.isScreenShotAlbum;
      objOfMainThread.isPhotoAlbum = objFromSubThread.isPhotoAlbum;
      objOfMainThread.isShootingAlbum = objFromSubThread.isShootingAlbum;
      objOfMainThread.albumName = objFromSubThread.albumName;
      objOfMainThread.isSourceAlbum = objFromSubThread.isSourceAlbum;
      objOfMainThread.albumType = objFromSubThread.albumType;
      objOfMainThread.subType = objFromSubThread.subType;
      objOfMainThread.coverOrientation = objFromSubThread.coverOrientation;
      objOfMainThread.coverPhotoUri = objFromSubThread.coverPhotoUri;
      objOfMainThread.isUserCreatedAlbum = objFromSubThread.isUserCreatedAlbum;
      objOfMainThread.lpath = objFromSubThread.lpath;
      sourceData.push(objOfMainThread);
    }

    for (let i = 0; i < sourceData.length; i++) {
      Log.info(TAG, `sourceData album index: ${i}, uri: ${sourceData[i].uri}, count: ${sourceData[i].count}` +
        `coverUri：${sourceData[i].coverUri}`);
    }

    // 由于sendable子线程打点调用了AppStorage报错，将打点放到子线程外执行
    UserFileManagerAccess.getInstance().userAlbumsCountReport(albumResult.userAlbumCount);

    // 触发回调函数
    let callbackParam: AlbumCallBackParam = {
      userAlbumCount: albumResult.userAlbumCount,
    };
    callback.callback(sourceData, JSON.stringify(callbackParam));
    Log.info(TAG, `getAlbums end, sourceData.length=${sourceData.length}`);
  }

  /**
   * getAlbums异步调用执行查询函数
   *
   * @param queryParam 查询参数
   * @param context 上下文对象
   * @returns 返回结果
   */
  public async getAlbumsAsync(queryParam: QueryAlbumParam): Promise<AlbumResult> {
    Log.info(TAG, `getAlbumsAsync, queryParam=${JSON.stringify(queryParam)}`);
    if (this.userFileManagerAccess === undefined) {
      let result: AlbumResult = { sourceData: [], userAlbumCount: 0, systemAlbumCount: 0 };
      return result;
    }
    let start: number = queryParam.start ?? 0;
    let count: number = queryParam.count ?? 0;
    let filterMediaType: string | undefined = queryParam.filterMediaType;
    let blackUriList: string[] | undefined = queryParam.blackUriList;
    let nameOnly: boolean | undefined = queryParam.nameOnly;
    let hasItemsOnly: boolean | undefined = queryParam.hasItemsOnly;
    let sourceData: AlbumInfo[] = [];
    let leftCount: number = 0;

    // 查询系统相册信息
    let sysAlbums: PhotoAlbum[] = await this.userFileManagerAccess.getSystemAlbums();

    // 系统来源相册：相机、截屏、录屏
    /* instrument ignore next */
    if (!DeviceInfo.isPc()) {
      let photoAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums();
      photoAlbums = photoAlbums.filter(album => album.count > 0);

      if (photoAlbums.length > 1) { // 查询结果2个及以上，按相机、截图、屏幕录制排序
        let lpaths: string[] = UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST;
        photoAlbums.sort((album1: PhotoAlbum, album2: PhotoAlbum) => {
          return lpaths.indexOf(album1.lpath ?? '') - lpaths.indexOf(album2.lpath ?? '');
        });
      }
      sysAlbums.push(...photoAlbums);
    }

    let systemAlbumCount: number = await this.getSystemAlbumsCount(sysAlbums, filterMediaType, blackUriList);

    // 查询用户相册信息
    let userAlbums: PhotoAlbum[] = await this.userFileManagerAccess.getUserAlbums(undefined, true);
    let userAlbumCount: number = await this.getUserAlbumsCount(userAlbums, filterMediaType, blackUriList, hasItemsOnly);

    // 封装系统相册信息
    /* instrument ignore next */
    if (start < systemAlbumCount && count > 0) {
      await this.getSystemAlbumsInfo(sysAlbums, sourceData, start, count, filterMediaType, blackUriList, nameOnly);
    }

    // 封装用户相册信息
    start = Math.max(start - systemAlbumCount, 0);
    leftCount = count - sourceData.length;
    if (start < userAlbumCount && leftCount > 0) {
      await this.getUserAlbumsInfo(userAlbums, sourceData,
        start, leftCount, filterMediaType, blackUriList, nameOnly, hasItemsOnly);
    }
    Log.info(TAG, `getAlbumsAsync end, sourceData.length=${sourceData.length}, sysAlbums=${sysAlbums.length}`);

    // 返回结果
    let result: AlbumResult = {
      sourceData: sourceData,
      userAlbumCount: userAlbumCount,
      systemAlbumCount: systemAlbumCount,
    };
    return result;
  }

  /**
   * 查询系统相册和用户相册的总数量
   *
   * @param param 查询参数
   * @returns 返回结果
   */
  protected async getAlbumsCount(param: QueryAlbumParam): Promise<number> {
    Log.info(TAG, 'genAlbumsCount start');
    let context: Context = getContext(this) || global.uiAbilityContext();
    param.nameOnly = true;

    // 调用taskpool异步执行
    let albumResult = await taskpool.execute(getAlbumsCountTask, param, context) as AlbumResult;
    let albumCount = albumResult.userAlbumCount + albumResult.systemAlbumCount;

    // 由于sendable子线程打点调用了AppStorage报错，将打点放到子线程外执行
    UserFileManagerAccess.getInstance().userAlbumsCountReport(albumResult.userAlbumCount);
    Log.info(TAG, `genAlbumsCount end, albumCount=${albumCount}`);
    return albumCount;
  }

  /**
   * getAlbumsCount异步调用执行查询函数
   *
   * @param queryParam 查询参数
   * @param context 上下文对象
   * @returns 返回结果
   */
  public async getAlbumsCountAsync(param: QueryAlbumParam): Promise<AlbumResult> {
    Log.info(TAG, `getAlbumsCountAsync start ${toString(param)}`);
    if (this.userFileManagerAccess === undefined) {
      let result: AlbumResult = { sourceData: [], userAlbumCount: 0, systemAlbumCount: 0 };
      return result;
    }

    // 系统相册信息
    let sysAlbums: PhotoAlbum[] = await this.userFileManagerAccess.getSystemAlbums();

    // 系统来源相册：相机、截屏、录屏
    let sourceAlbums: PhotoAlbum[] = []
    /* instrument ignore next */
    if (!DeviceInfo.isPc()) {
      let sourceAlbumsTemp: PhotoAlbum[] = await this.userFileManagerAccess.getSystemSourceAlbums();
      sourceAlbums = sourceAlbumsTemp.filter(album => album.count > 0);
    }

    let systemAlbumCount: number =
      await this.getSystemAlbumsCount(sysAlbums, param?.filterMediaType, param?.blackUriList);

    // 用户相册
    let userAlbums: PhotoAlbum[] = await this.userFileManagerAccess.getUserAlbums(undefined, true);
    let userAlbumCount: number =
      await this.getUserAlbumsCount(userAlbums, param?.filterMediaType, param?.blackUriList, param?.hasItemsOnly);

    let result: AlbumResult = {
      sourceData: [], userAlbumCount: userAlbumCount,
      systemAlbumCount: systemAlbumCount + sourceAlbums.length,
    };
    Log.info(TAG,
      `getAlbumsCountAsync end user=${userAlbumCount}, system=${systemAlbumCount}, source=${sourceAlbums.length}`);
    return result;
  }

  /**
   * 获取相册的封面图片，由于在子线程执行时UserFileManagerAccess对象获取方式不同，需要抽出来修改重写
   *
   * @param album 查询到的相册信息
   * @param albumInfo 封装的相册信息
   * @returns 返回信息
   */
  /* instrument ignore next */
  protected async useRetrysetAlbumCover(album: PhotoAlbum, albumInfo: AlbumInfo): Promise<void> {
    try {
      // 如果this.userFileManagerAccess为undefined，说明这里不是在子线程中执行，直接调用父类的函数就行
      if (this.userFileManagerAccess === undefined) {
        await super.useRetrysetAlbumCover(album, albumInfo);
        return;
      }

      // 子线程中执行：需要用到this.userFileManagerAccess替代原函数中的参数
      let hasCoverUri: Boolean = false;
      if (album.coverUri) {
        await this.userFileManagerAccess.getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri), TAG)
          .then((obj) => {
            if (obj?.obj) {
              this.setAlbumCover(albumInfo, obj.obj);
              hasCoverUri = true;
            }
          });
      }
      if (!hasCoverUri) {
        await this.userFileManagerAccess.getAlbumFirstObject(album)
          .then((obj) => {
            if (obj) {
              this.setAlbumCover(albumInfo, obj);
            }
          });
      }
    } catch (err) {
      Log.error(TAG, `Failed to exec useRetrysetAlbumCover. Code is ${err?.code}, message is ${err?.message}`);
    }
  }
}