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

import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumInfo } from './AlbumInfo';
import lazy { Constants } from '../../common/Constants';
import lazy { AlbumSetDataInfo } from '../../common/AlbumSetDataInfo';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import lazy { MediaObserver } from '../dataObserver/MediaObserver';
import lazy { AlbumDataImpl } from './AlbumDataImpl';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy {
  MediaObserverNfyInfo,
  MediaObserverNfyType,
  MediaObserverNfyInfoForAlbums
} from '../dataObserver/MediaObserverCallback';
import lazy {
  cloudEnhanceAlbumFileCountReport,
  favorAlbumFileCountReport,
  nowOverOneWeek,
  photoAlbumFileCountReport,
  videoAlbumFileCountReport,
} from '../../../utils/StatisticReportUtil';
import lazy { DataStoreUtil } from '../../../utils/DataStoreUtil';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { ChangeInfo, ChangeType, DataSource, LoadingInfo, LoadingResult, LoadingTask } from '../../DataSource';
import lazy { AlbumRefreshUtil, DataSourceType, SharedAlbumAssetItems } from '../../../utils/AlbumRefreshUtil';
import lazy { AlbumSetCacheManager, CacheType } from '../../AlbumSetCacheManager';
import lazy { getScreen, WindowMode } from '../../common/ScreenManager';
import lazy { PageData } from '../../PageData';
import lazy { AlbumDataImplAsync } from './AlbumDataImplAsync';
import lazy { MediaLibChangeInfo } from '../../MediaLibChangeInfo';
import lazy { MediaLibLoadingInfo } from '../../MediaLibLoadingInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Throttle } from '../../../utils/Throttle';
import lazy { NormalAlbumDataImpl } from './NormalAlbumDataImpl';
import lazy { ParamsWrapper } from '../../../view/actionbar/Menu';
import lazy { ImageUtil } from '../../../utils/ImageUtil';

const TAG: string = 'common_AlbumSetDataSource';

export class AlbumAbstractInfo {
  public uri: string;
  public albumName: Resource | string;
  public isSystemAlbum: boolean;
  public isTrashAlbum: boolean;
  public isFavorAlbum: boolean;
  public isCloudEnhanceAlbum: boolean;
  public isVideoAlbum: boolean;
  public isScreenShotAlbum: boolean;
  public isPhotoAlbum: boolean;

  constructor(uri: string, albumName: Resource | string,
    isSystemAlbum: boolean, isTrashAlbum: boolean, isFavorAlbum: boolean, isCloudEnhanceAlbum: boolean,
    isVideoAlbum: boolean, isScreenShotAlbum: boolean, isPhotoAlbum: boolean) {
    this.uri = uri;
    this.albumName = albumName;
    this.isSystemAlbum = isSystemAlbum;
    this.isTrashAlbum = isTrashAlbum;
    this.isFavorAlbum = isFavorAlbum;
    this.isCloudEnhanceAlbum = isCloudEnhanceAlbum;
    this.isVideoAlbum = isVideoAlbum;
    this.isScreenShotAlbum = isScreenShotAlbum;
    this.isPhotoAlbum = isPhotoAlbum;
  }

  public toString(): string {
    return JSON.stringify(this, AlbumDefine.albumNameReplacer);
  }
}

interface AlbumCache {
  readonly albumType: number;
  readonly albumSubType: number;
  readonly albumName: string;
  readonly count: number;
  readonly videoCount: number;
  readonly uri: string;
  readonly coverUri: string;
  readonly lpath: string;
}

interface AlbumSetCache {
  albums: AlbumCache[];
};

export enum AlbumSetColdStartState {
  CACHE = 1,
  FIRST_BATCH,
  SECOND_BATCH,
  DONE
}

interface AlbumSetLoadingTaskParams {
  info: LoadingInfo;
  source: DataSource<AlbumInfo>;
  pageData: PageData<AlbumInfo>;
  coldStartState: AlbumSetColdStartState;
  dataImpl: AlbumDataImpl;
  cacheMgr: AlbumSetCacheManager;
}

interface AlbumSetLoadingInfo extends MediaLibLoadingInfo {
  blackUriList: string[];
  filterMediaType: string,
}

interface AlbumSetLoadingResult extends LoadingResult<AlbumInfo> {
  coldStartState: AlbumSetColdStartState;
  fromCache?: boolean;
  abstracts?: AlbumAbstractInfo[];
  preciseUpdateIndex?: number[];
}

class AlbumSetLoadingTask extends LoadingTask<AlbumInfo> {
  private readonly params: AlbumSetLoadingTaskParams;

  public constructor(params: AlbumSetLoadingTaskParams) {
    super(params.info, params.source, params.pageData);
    this.params = params;
  }

  public async start(): Promise<LoadingResult<AlbumInfo>> {
    if (this.info.start < 0 || this.info.count <= 0) {
      Log.info(TAG, `AlbumSetLoadingTask.start invalid input, start: ${this.info.start}, count: ${this.info.count}`);
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as AlbumSetLoadingResult;
    }

    let msg: string[] = [`AlbumSetLoadingTask.start state: ${this.params.coldStartState}`];
    msg.push(`isEmulator: ${DeviceInfo.isEmulator()}`);
    Log.info(TAG, msg.join(', '));
    switch (this.params.coldStartState) {
      case AlbumSetColdStartState.CACHE:
        return this.loadCache();
      case AlbumSetColdStartState.FIRST_BATCH:
        return this.loadFirstBatch();
      case AlbumSetColdStartState.SECOND_BATCH:
        return this.loadSecondBatch();
      default:
      /* instrument ignore if */
        if (this.loadVersion === this.pageData.version) {
          // 仅滑窗变更
          return this.loadDataWhenSlide();
        } else {
          // 数据刷新
          // return this.loadDataWhenRefresh();
          // TODO 暂时使用loadFirstBatch
          return this.loadFirstBatch();
        }
    }
  }

  private static loadAlbumFromCache(cache: Object | undefined, blackUriList: string[]): AlbumInfo[] {
    let albumCache: AlbumSetCache | undefined = cache as AlbumSetCache;
    if (!albumCache) {
      return [];
    }
    if (!albumCache.albums || albumCache.albums.length <= 0) {
      return [];
    }
    let albums: AlbumInfo[] = [];
    albumCache.albums.forEach((value: AlbumCache) => {
      if (blackUriList && blackUriList.indexOf(value.uri) >= 0) {
        return;
      }
      let info: AlbumInfo = new AlbumInfo();
      info.albumName = value.albumName;
      info.count = value.count;
      info.videoCount = value.videoCount;
      info.uri = value.uri;
      info.coverUri = value.coverUri;
      info.albumType = value.albumType;
      info.subType = value.albumSubType;

      info.isSourceAlbum = AlbumDefine.isSourceAlbum(value.albumSubType);
      info.isSystemAlbum = info.isSourceAlbum || AlbumDefine.isSystemAlbum(value.albumType); // 普通相册区域，系统相册或来源相册
      info.isUserCreatedAlbum = AlbumDefine.isUserAlbum(value.albumType, value.albumSubType);
      info.setSystemAlbumSubType();
      info.lpath = value.lpath;
      albums.push(info);
    });
    return albums;
  }

  private async loadCache(): Promise<AlbumSetLoadingResult> {
    if (DeviceInfo.isEmulator()) {
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as AlbumSetLoadingResult;
    }
    await this.params.cacheMgr.setCacheData(CacheType.ALBUMS);
    let cache: Object | undefined = this.params.cacheMgr.getCache(CacheType.ALBUMS);
    let albums: AlbumInfo[] =
      AlbumSetLoadingTask.loadAlbumFromCache(cache, (this.info as AlbumSetLoadingInfo)?.blackUriList);
    Log.info(TAG, `loadCache albums: ${albums.length}`);
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, albums, 0, 0),
      coldStartState: this.params.coldStartState,
      fromCache: true,
    } as AlbumSetLoadingResult;
  }

  private async loadData(start: number, count: number): Promise<AlbumInfo[]> {
    let loadingInfo: AlbumSetLoadingInfo = this.info as AlbumSetLoadingInfo;
    let param: QueryAlbumParam = {
      start: start,
      count: count,
      orderSection: [
      ],
    };
    if (loadingInfo.filterMediaType) {
      param.filterMediaType = loadingInfo.filterMediaType;
    }

    if (loadingInfo.blackUriList) {
      param.blackUriList = loadingInfo.blackUriList;
    }

    return new Promise<AlbumInfo[]>((resolve) => {
      let asyncCallback: AsyncCallback<AlbumInfo[]> | undefined = {
        callback: (albums: AlbumInfo[]) => {
          asyncCallback = undefined;
          resolve(albums);
        },
      };
      this.params.dataImpl.getData(asyncCallback, param);
    });
  }

  private async loadFirstBatch(): Promise<AlbumSetLoadingResult> {
    const startTime: number = Date.now();
    let albums: AlbumInfo[] = await this.loadData(this.info.start, this.info.count);
    let msg: string[] = [`loadFirstBatch cost: ${Date.now() - startTime}, count: ${albums.length}`];
    msg.push(`query: (${this.info.start}, ${this.info.start + this.info.count})`);
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, albums, 0, 0),
      coldStartState: this.params.coldStartState,
    } as AlbumSetLoadingResult;
  }

  private async loadDataCount(): Promise<number> {
    let loadingInfo: AlbumSetLoadingInfo = this.info as AlbumSetLoadingInfo;
    let param: QueryAlbumParam = {
      orderSection: [
      ]
    };
    if (loadingInfo.filterMediaType) {
      param.filterMediaType = loadingInfo.filterMediaType;
    }
    if (loadingInfo.blackUriList && loadingInfo.blackUriList.length > 0) {
      param.blackUriList = loadingInfo.blackUriList;
    }
    return new Promise<number>((resolve) => {
      let asyncCallback: AsyncCallback<number> | undefined = {
        callback: (count: number) => {
          asyncCallback = undefined;
          resolve(count);
        },
      };
      this.params.dataImpl.getDataCount(asyncCallback, param);
    });
  }

  private async loadSecondBatch(): Promise<AlbumSetLoadingResult> {
    if (this.pageData.size < AlbumSetDataSource.INIT_FIRST_PATCH_LOAD_COUNT &&
      this.loadVersion === this.pageData.version) {
      // 如果数据总量少于首批加载的量，第二批不需要再加载
      Log.info(TAG, 'loadSecondBatch no need to load data');
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as AlbumSetLoadingResult;
    }

    let msg: string[] = [`loadSecondBatch query: (${this.info.start}, ${this.info.start + this.info.count})`];
    let startTime: number = Date.now();
    let count: number = await this.loadDataCount();
    msg.push(`countCost: ${Date.now() - startTime}`, `count: ${count}`);
    startTime = Date.now();
    let albums: AlbumInfo[] = await this.loadData(this.info.start, this.info.count);
    msg.push(`albumsCost: ${Date.now() - startTime}`, `albums: ${albums.length}`);

    // 融合前两批的结果，优先取第二批的查询结果
    let finalData: (AlbumInfo | undefined)[] = [];
    for (let i = 0; i < this.info.start + albums.length; i++) {
      if (i < this.info.start) {
        finalData.push(this.pageData.getData(i));
      } else {
        finalData.push(albums[i - this.info.start]);
      }
    }
    Log.info(TAG, msg.join(', '));

    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, finalData, 0, count - finalData.length),
      coldStartState: this.params.coldStartState,
    } as AlbumSetLoadingResult;
  }

  private async loadDataWhenSlide(): Promise<AlbumSetLoadingResult> {
    let msg: string[] = [`loadDataWhenSlide query: (${this.info.start}, ${this.info.start + this.info.count})`];
    let startTime: number = Date.now();
    let albums: AlbumInfo[] = await this.loadData(this.info.start, this.info.count);
    msg.push(`cost: ${Date.now() - startTime}`, `albums: ${albums.length}`);

    // 数据集不变，增量查询场景，合并旧的滑窗数据得到新的数据
    let newAlbums: (AlbumInfo | undefined)[] = [];
    let end: number = Math.min(this.source.totalCount(), this.source.activeEnd);
    for (let i: number = this.source.activeStart; i < end; i++) {
      if (i >= this.info.start && i < this.info.start + albums.length) {
        // 在新加载的数据范围内，优先取新加载的数据
        newAlbums.push(albums[i - this.info.start]);
      } else {
        newAlbums.push(this.pageData.getData(i));
      }
    }
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, newAlbums, this.source.activeStart,
        this.pageData.size - this.source.activeStart - newAlbums.length).trim(),
      coldStartState: this.params.coldStartState,
    } as AlbumSetLoadingResult;
  }

  private async loadDataWhenRefresh(): Promise<AlbumSetLoadingResult> {
    let loadFromPrecise = AlbumRefreshUtil.getHasPreciseInfo(DataSourceType.User);

    Log.info(TAG, `loadDataWhenRefresh user album load from precise info: ${loadFromPrecise}`);
    // 无精细化通知信息或窗口不一致，则查询数据库
    if (loadFromPrecise) {
      let preciseInfoMap: Map<string, ParamsWrapper> = AlbumRefreshUtil.getPreciseInfoMap(DataSourceType.User);
      let albumsAddSet: Set<ParamsWrapper> = AlbumRefreshUtil.getPreciseAlbumsAdd();

      let albumUris = preciseInfoMap.keys();
      let updateIndex: number[] = [];

      let newPageData: PageData<AlbumInfo> =
        new PageData<AlbumInfo>(this.loadVersion, this.pageData.data, this.pageData.placeholdersBefore,
          this.pageData.placeholdersAfter);

      for (let albumUri of albumUris) {
        let albumParam = preciseInfoMap.get(albumUri);
        let currentIndex = this.setPageData(albumUri, albumParam, newPageData);
        if (currentIndex !== -1) {
          updateIndex.push(currentIndex + this.pageData.placeholdersBefore);
        }
      }

      // placeholdersAfter 不为 0，即当前滑窗未至最后。而新增的相册位于最后，此时忽略
      // 待 媒体库通知 order 字段合入后，放开此逻辑，依据index添加
      /* instrument ignore next */
      try {
        if (albumsAddSet.size > 0 && this.pageData.placeholdersAfter !== 0) {
          newPageData = new PageData<AlbumInfo>(this.loadVersion, newPageData.data, newPageData.placeholdersBefore,
            newPageData.placeholdersAfter + albumsAddSet.size);
          Log.info(TAG, `[preciseInfo] refresh album for type User: add ignore, index: ${this.pageData.size}`);
        } else if (albumsAddSet.size > 0 && this.pageData.placeholdersAfter === 0) {
          let albumsAdd: AlbumInfo[] = [];

        for (let albumParam of albumsAddSet) {
          let info: AlbumInfo = new AlbumInfo();
          info.albumName = albumParam.get(SharedAlbumAssetItems.albumName);
          info.count = albumParam.get(SharedAlbumAssetItems.count);
          info.videoCount = albumParam.get(SharedAlbumAssetItems.videoCount);
          info.uri = albumParam.get(SharedAlbumAssetItems.albumId);

          let albumCoverUri = albumParam.get(SharedAlbumAssetItems.coverUri) as string | undefined;
          if (albumCoverUri) {
            info.setCoverPhotoUri(albumCoverUri);
            // coverUri 需要为astc图，否则为原图，影响性能，且同步过程显示裂图，接口其余参数待分析
            info.setCoverUri(ImageUtil.getThumbnailAstcUri(albumCoverUri, undefined, undefined));
          }
          info.albumType = albumParam.get(SharedAlbumAssetItems.albumType);
          info.subType = albumParam.get(SharedAlbumAssetItems.albumSubtype);

          info.isSourceAlbum = AlbumDefine.isSourceAlbum(info.subType);
          info.isSystemAlbum = info.isSourceAlbum || AlbumDefine.isSystemAlbum(info.albumType); // 普通相册区域，系统相册或来源相册
          info.isUserCreatedAlbum = AlbumDefine.isUserAlbum(info.albumType, info.subType);
          info.setSystemAlbumSubType();
            // lpath字段添加后，添加赋值：info.lpath = value.lpath，目前为查询
            info.lpath = await this.params.dataImpl.getAlbumLpathByUriAsync(info.uri);
          albumsAdd.push(info);
            Log.info(TAG, `[preciseInfo] refresh album for type User: add ` +
              `index ${this.pageData.placeholdersBefore + this.pageData.data.length}, uri: ${info.uri}`);
        }
        newPageData.data.push(...albumsAdd);
        }
      } catch (e) {
        Log.info(TAG, `[preciseInfo] refresh album for type User: add errr, msg: ${e?.message}`);
      }
      AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.User);

      // 确定刷新index之后添加 preciseUpdateIndex: updateIndex
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: newPageData,
        coldStartState: this.params.coldStartState,
      } as AlbumSetLoadingResult;
    }
    AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.User);

    let msg: string[] = [`loadDataWhenRefresh`];
    let startTime: number = Date.now();
    let newDataCount: number = await this.loadDataCount();
    msg.push(`countCost: ${Date.now() - startTime}`, `count: ${newDataCount}`);

    if (newDataCount === 0) {
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new PageData<AlbumInfo>(this.loadVersion, [], 0, 0),
        coldStartState: this.params.coldStartState,
      } as AlbumSetLoadingResult;
    }
    // 根据新的数据集范围，调整数据加载位置
    let loadCount: number = Math.min(this.info.count, newDataCount);
    let loadStart: number = Math.min(newDataCount - loadCount, this.info.start);
    Log.info(TAG, `loadData range change: loadCount ${this.info.count}->${loadCount}, loadStart ${this.info.start}->${newDataCount - loadCount}`);

    // 加载对应范围的数据，这里同样可以根据数据库通知，调整查询策略，比如只更新单条
    startTime = Date.now();
    let albums: (AlbumInfo | undefined)[] = await this.loadData(loadStart, loadCount);
    msg.push(`(start:${loadStart}, end:${loadStart + loadCount})`, `cost: ${Date.now() - startTime}`,
      `albums: ${albums.length}`);
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, albums, loadStart,
        newDataCount - loadStart - albums.length).trim(),
      coldStartState: this.params.coldStartState,
    } as AlbumSetLoadingResult;
  }

  /**
   * 更新DataSource的pageData数组
   * @param albumId 相册的uri
   * @param albumParam 相册的精准通知信息
   * @returns
   */
  private setPageData(albumId: string, albumParam: ParamsWrapper | undefined, pageData: PageData<AlbumInfo>): number {
    if (!albumParam) {
      return -1;
    }
    let dataIndex: number = -1;
    let removeIndex: number = -1;

    for (let i = 0; i < pageData.data.length; i++) {
      let refreshAlbum = pageData.data[i];
      if (refreshAlbum?.uri === albumId) {
        // 相册的albumType albumSubType 不会改变
        // iamgeCount 暂无字段，后续有此字段需求再补齐
        let albumUri = albumParam.get(SharedAlbumAssetItems.albumId) as string;
        if (!albumUri) {
          removeIndex = i;
          break;
        }
        let albumName = albumParam.get(SharedAlbumAssetItems.albumName) as string;
        let coverUri = albumParam.get(SharedAlbumAssetItems.coverUri) as string;
        let count = albumParam.get(SharedAlbumAssetItems.count) as number;
        let videoCount = albumParam.get(SharedAlbumAssetItems.videoCount) as number;

        try {
          refreshAlbum.setUri(albumUri);
          if (refreshAlbum.coverPhotoUri !== coverUri) {
            refreshAlbum.setCoverPhotoUri(coverUri);
            if (coverUri) {
              // coverUri 需要为astc图，否则为原图，影响性能，且同步过程显示裂图，接口其余参数待分析
              refreshAlbum.setCoverUri(ImageUtil.getThumbnailAstcUri(coverUri, undefined, undefined));
            } else {
              refreshAlbum.setCoverUri('');
            }
          }
          // 系统相册传的 albumName 为空，此时直接进行赋值会导致宫格调用 getResourceStringSync 获取名称时异常，从而显示所有的数据
          if (!refreshAlbum.isSystemAlbum) {
            refreshAlbum.setAlbumName(albumName);
          }
          refreshAlbum.setCount(count);
          refreshAlbum.setVideoCount(videoCount);
          dataIndex = i;
          Log.info(TAG, `[preciseInfo] refresh album for type User: update index ${dataIndex}, count: ${count}`);
        } catch (err) {
          dataIndex = -1;
          AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.User);
          Log.error(TAG, `Set albumInfo error, code: ${err?.code}, msg: ${err?.message}`);
        }
        break;
      }
    }
    if (removeIndex !== -1) {
      pageData.data.splice(removeIndex, 1);
      Log.info(TAG, `[preciseInfo] type User, refresh album for type User: remove ` +
        `index ${this.pageData.placeholdersBefore + removeIndex}`);
    }
    return dataIndex;
  }
}


export class AlbumSetDataSource extends DataSource<AlbumInfo> implements IDataSource {
  public static readonly INIT_FIRST_PATCH_LOAD_COUNT_PHONE: number = 16;
  public static readonly INIT_FIRST_PATCH_LOAD_COUNT_PC: number = 72;
  public static readonly INIT_FIRST_PATCH_LOAD_COUNT: number = DeviceInfo.isPhoneUx() ?
    AlbumSetDataSource.INIT_FIRST_PATCH_LOAD_COUNT_PHONE : AlbumSetDataSource.INIT_FIRST_PATCH_LOAD_COUNT_PC;
  public albums: AlbumInfo[] = [];
  public isMultiParameter: boolean = false;
  private broadCast: BroadCast | undefined;
  private filterMediaType: string = '';
  private blackUriList: string[] = [];
  private deviceId: string = '';
  public albumAbstracts: AlbumAbstractInfo[] = [];
  private newCreatedAlbumIndex: number = -1;
  private albumCount: number = 0;
  private lastPhotoAlbumFileCountReportTime: string = '';
  private lastCloudEnhanceAlbumFileCountReportTime: string = '';
  private lastVideoAlbumFileCountReportTime: string = '';
  private lastFavorAlbumFileCountReportTime: string = '';
  public albumInfoItemCache: Map<string, AlbumSetDataInfo> = new Map<string, AlbumSetDataInfo>();
  private readonly cacheMgr: AlbumSetCacheManager = new AlbumSetCacheManager(getContext());
  private albumDataImpl: AlbumDataImpl;
  private coldStartState: AlbumSetColdStartState = AlbumSetColdStartState.CACHE;
  private readonly shouldWriteCache: boolean | undefined = false;
  private readonly loadThrottle: Throttle<void> = new Throttle<void>(0, TAG);
  public albumCoverCache: Map<string, string> = new Map<string, string>();

  public constructor(broadCast?: BroadCast, initData?: PageData<AlbumInfo>, shouldWriteCache?: boolean,
    blackUriList?: string[]) {
    super();
    this.tag = TAG;
    Log.info(this.tag, 'constructor');
    this.isActive = false;
    if (broadCast) {
      this.broadCast = broadCast;
    }
    this.windowSize = DeviceInfo.isPhoneUx() ? Constants.DEFAULT_SLIDING_ALBUM_WIN_SIZE_PHONE :
      (DeviceInfo.isTablet() ?
        Constants.DEFAULT_SLIDING_ALBUM_WIN_SIZE_TABLET : Constants.DEFAULT_SLIDING_ALBUM_WIN_SIZE_PC);
    this.stepSize = DeviceInfo.isPhoneUx() ? Constants.ALBUM_STEP_PHONE :
      (DeviceInfo.isTablet() ? Constants.ALBUM_STEP_TABLET : Constants.ALBUM_STEP_PC);
    this.activeStart = 0;
    this.activeEnd = this.windowSize;
    this.albums = new Array(this.windowSize) as AlbumInfo[];
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
      // 手机端采用排序相册接口进行数据查询
      this.albumDataImpl = new NormalAlbumDataImpl();
    } else {
      this.albumDataImpl = new AlbumDataImplAsync();
    }
    if (initData) {
      // 如果提供有效的初始分页数据则使用初始分页数据，【过滤黑名单场景需要创建者自行删掉initData里的黑名单数据！！！】
      this.pageData = initData;
      this.albumCount = initData.size;
    }
    if (blackUriList) {
      this.blackUriList = blackUriList;
    }
    this.shouldWriteCache = shouldWriteCache;
  }

  public getBroadcast(): BroadCast | undefined {
    return this.broadCast;
  }

  // 释放单张相册的AlbumInfo
  public releaseAlbumInfoItemCache(item: AlbumInfo): void {
    if (!item?.uri) {
      Log.error(TAG, 'releaseAlbumInfoItemCache item undefined');
      return;
    }
    this.albumInfoItemCache.delete(item.uri);
  }

  /*
    为图片移动和向相册中添加图片服务，过滤系统相册和自身相册的URI
  */
  public setBlackUriList(blackUriList: string[]): void {
    this.blackUriList = blackUriList;
    Log.info(TAG, `BlackList: set blackUriList ${JSON.stringify(this.blackUriList)}.`);
    this.notifyDirty();
  }

  public clearBlackUriList(): void {
    this.setBlackUriList([]);
  }

  // get index by album
  /* instrument ignore next */
  public getIndexByAlbum(album: AlbumInfo): number {
    return this.albums.findIndex(item => item?.uri === album?.uri);
  }

  // get album by index
  public getAlbumByIndex(index: number): AlbumInfo | undefined {
    return this.getPageData(index);
  }

  public getAlbumCount(): number {
    return this.albumCount;
  }

  public getData(index: number): AlbumSetDataInfo | undefined {
    this.updateSlidingWindow(index);
    let result = this.getWrappedData(index);
    // 照片相册文件数量
    // 视频相册文件数量
    // 收藏相册文件数量
    if (nowOverOneWeek(this.lastPhotoAlbumFileCountReportTime) && result?.data?.isPhotoAlbum) {
      photoAlbumFileCountReport(result.data.count).then((x) => {
        this.lastPhotoAlbumFileCountReportTime = x;
      });
    }
    if (nowOverOneWeek(this.lastVideoAlbumFileCountReportTime) && result?.data?.isVideoAlbum) {
      videoAlbumFileCountReport(result.data.count).then((x) => {
        this.lastVideoAlbumFileCountReportTime = x;
      });
    }
    if (nowOverOneWeek(this.lastFavorAlbumFileCountReportTime) && result?.data?.isFavorAlbum) {
      favorAlbumFileCountReport(result.data.count).then((x) => {
        this.lastFavorAlbumFileCountReportTime = x;
      });
    }
    Log.info(TAG, `getData, index: ${index}, isNewCreated: ${result?.isNewCreated}, ` +
      `dateModified: ${result?.dateModified}, albumInfo: ${result?.data?.printAlbumInfo()}`);
    if (!result) {
      return undefined;
    }
    return result;
  }

  public resetIsNewCreatedIndex(index?: number): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && index !== undefined) {
      if (index === this.newCreatedAlbumIndex) {
        this.newCreatedAlbumIndex = -1;
      }
    } else {
      this.newCreatedAlbumIndex = -1;
    }
  }

  private getWrappedData(index: number): AlbumSetDataInfo | undefined {
    if (index < 0 || index >= this.albumCount) {
      Log.error(TAG,
        `getWrappedData, index out of the total size, index: ${index}, total size: ${this.albumCount}`);
      return undefined;
    }
    let albumIndex: number = index - this.activeStart;
    if (albumIndex < 0 || albumIndex >= this.albums.length) {
      return undefined;
    }
    let isNewCreated: boolean = false;
    if (index === this.newCreatedAlbumIndex) {
      isNewCreated = true;
    }
    let result: AlbumSetDataInfo | undefined = undefined;
    const albumInfo: AlbumInfo | undefined = this.getAlbumInfoSafely(albumIndex);
    const tmp: AlbumSetDataInfo |
    undefined = albumInfo?.uri ? this.albumInfoItemCache.get(albumInfo?.uri) : undefined;
    if (tmp) {
      result = tmp;
      if (albumInfo) {
        result.update(albumInfo, index, isNewCreated);
      }
    } else if (albumInfo) {
      result = new AlbumSetDataInfo(albumInfo, index, isNewCreated);
      this.albumInfoItemCache.set(albumInfo?.uri, result);
    }
    return result;
  }

  private getAlbumInfoSafely(index: number): AlbumInfo | undefined {
    let album: AlbumInfo = this.albums[index];
    if (!album) {
      Log.error(TAG, `invalid data, index:${index}, active Start:${this.activeStart}, End:${this.activeEnd}`);
      return undefined;
    }
    return album;
  }

  public setNewAlbumIndex(index: number): void {
    this.newCreatedAlbumIndex = index;
  }

  public getNewAlbumIndex(): number {
    return this.newCreatedAlbumIndex;
  }

  protected onSlidingWindowChanged(winStart: number, winEnd: number): void {
    let newData: AlbumInfo[] = new Array<AlbumInfo>(this.windowSize);
    for (let i = winStart; i < winEnd; i++) {
      let albumInfo: AlbumInfo | undefined = this.pageData.getData(i);
      if (albumInfo) {
        newData[i - winStart] = albumInfo;
      }
    }
    this.albums = newData;
  }

  public registerAlbumObserver(): void {
    Log.info(TAG, `AlbumDataSource is newObserver: ${AlbumRefreshUtil.isSupportAccurateNotify()}`);
    if (AlbumRefreshUtil.isSupportAccurateNotify()) {
      MediaObserver.getInstance().registerAlbumObserver(MediaObserver.PHOTO_ALBUM_CHANGE, this);
      return;
    }
    MediaObserver.getInstance().registerObserver(this);
  }

  public unregisterAlbumObserver(): void {
    if (AlbumRefreshUtil.isSupportAccurateNotify()) {
      MediaObserver.getInstance().unregisterAlbumObserver(MediaObserver.PHOTO_ALBUM_CHANGE, this);
      return;
    }
    MediaObserver.getInstance().unregisterObserver(this);
  }

  /* instrument ignore next */
  private updateSingleAlbum(albumIndex: number): void {
    Log.info(TAG, `updateSingleAlbum album: ${albumIndex}, ${this.albums[albumIndex - this.activeStart]?.uri}`);
  }

  private handleNotifyUri(nfyInfo: MediaObserverNfyInfo, album: AlbumInfo, albumIndex: number): void {
    if (!album.coverPhotoUri || album.coverPhotoUri.length === 0) {
      Log.info(TAG, 'invalid album.coverPhotoUri');
      return;
    }
    for (let index = 0; index < nfyInfo.uris.length; index++) {
      const nfyUri = nfyInfo.uris[index];
      if (!nfyUri) {
        continue;
      }
      try {
        if (album.coverPhotoUri === nfyUri) {
          this.updateSingleAlbum(this.activeStart + albumIndex);
        }
      } catch (err) {
        Log.error(TAG, `happen error: ${err}, ` +
          `nfyInfo.uris[index]: ${nfyUri}, album.coverPhotoUri: ${album.coverPhotoUri}`);
      }
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    // 图片变化通知只需更新通知做响应，检查是否是某个相册的封面变化，其他的图片通知不需要响应
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE) {
      Log.info(TAG, `onNotifyForPhotoUpdate nfyInfo: ${JSON.stringify(nfyInfo)}`);
      let isNeedUpdate: boolean = false;
      for (let album of this.pageData.data) {
        if (nfyInfo.uris.includes(album?.coverPhotoUri ?? "")) { // 更新的图片是某个相册封面
          isNeedUpdate = true;
          break;
        }
      }
      if (!isNeedUpdate) {
        return;
      }
    } else if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD) {
      Log.info(TAG, `drop unnecessary notify: ${nfyInfo.type}`);
      return;
    } else {
      Log.info(TAG, `onNotify nfyInfo: ${JSON.stringify(nfyInfo)}`);
    }

    this.loadThrottle.execute(() => this.notifyDirty({
      changeType: ChangeType.DATA,
      nfyInfos: [nfyInfo]
    } as MediaLibChangeInfo));
  }

  public onRefinedNotify(nfyInfo: MediaObserverNfyInfoForAlbums): void {
    Log.info(TAG, `[preciseInfo] onRefinedNotify nfyInfo: ${JSON.stringify(nfyInfo)}`);

    // 前台场景再进行精细化通知
    if (this.isActive) {
      AlbumRefreshUtil.setPreciseAlbumInfo(DataSourceType.User, nfyInfo);
    }

    this.loadThrottle.execute(() => this.notifyDirty({
      changeType: ChangeType.DATA,
      nfyAlbumInfos: [nfyInfo]
    } as MediaLibChangeInfo));
    return;
  }

  public onChange(mediaType: string): void {
    if (!this.deviceId || this.deviceId.length === 0) {
      if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
        this.loadThrottle.execute(() => this.notifyDirty({
          changeType: ChangeType.DATA,
          changeTypes: [mediaType]
        } as MediaLibChangeInfo));
      }
    } else if (mediaType === 'remote') {
      /* instrument ignore next */
      // 这里走不进来
      this.loadThrottle.execute(() => this.notifyDirty({
        changeType: ChangeType.DATA,
        changeTypes: [mediaType]
      } as MediaLibChangeInfo));
    }
  }

  private static async systemAlbumAppearOrDisAppearReport(newAlbumAbstractList: AlbumAbstractInfo[]): Promise<void> {
    const dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    let oldPhotoAlbumShow: boolean =
      assert.asDefault(await dataStore.getData(Constants.OLD_PHOTO_ALBUM_SHOW, false), false, 'oldPhotoAlbumShow');
    let oldCloudEnhanceAlbumShow: boolean =
      assert.asDefault(await dataStore.getData(Constants.OLD_CLOUD_ENHANCE_ALBUM_SHOW, false),
        false, 'oldCLoudEnhanceAlbumShow');
    let oldVideoAlbumShow: boolean =
      assert.asDefault(await dataStore.getData(Constants.OLD_VIDEO_ALBUM_SHOW, false), false, 'oldVideoAlbumShow');
    let oldFavorAlbumShow: boolean =
      assert.asDefault(await dataStore.getData(Constants.OLD_FAVOR_ALBUM_SHOW, false), false, 'oldFavorAlbumShow');
    let newPhotoAlbumShow: boolean = false;
    let newCloudEnhanceAlbumShow: boolean = false;
    let newVideoAlbumShow: boolean = false;
    let newFavorAlbumShow: boolean = false;
    for (let index = 0; index < newAlbumAbstractList.length; index++) {
      if (newAlbumAbstractList[index].isSystemAlbum) {
        newPhotoAlbumShow = newPhotoAlbumShow || newAlbumAbstractList[index].isPhotoAlbum;
        newVideoAlbumShow = newVideoAlbumShow || newAlbumAbstractList[index].isVideoAlbum;
        newFavorAlbumShow = newFavorAlbumShow || newAlbumAbstractList[index].isFavorAlbum;
        newCloudEnhanceAlbumShow = newCloudEnhanceAlbumShow || newAlbumAbstractList[index].isCloudEnhanceAlbum;
      }
    }
    if (oldPhotoAlbumShow !== newPhotoAlbumShow) {
      const msg: Record<string, number | string | boolean> = {
        'name': 'photoAlbum',
        'action': (oldPhotoAlbumShow &&
          !newPhotoAlbumShow) ? BigDataConstants.SYSTEM_ALBUM_DISAPPEAR : BigDataConstants.SYSTEM_ALBUM_APPEAR
      };
      ReportToBigDataUtil.report(BigDataConstants.SYSTEM_ALBUM_IS_SHOW_ID, msg);
      await dataStore.putData(Constants.OLD_PHOTO_ALBUM_SHOW, newPhotoAlbumShow);
    }
    if (oldCloudEnhanceAlbumShow !== newCloudEnhanceAlbumShow) {
      const msg: Record<string, number | string | boolean> = {
        'name': 'cloudEnhanceAlbum',
        'action': (oldCloudEnhanceAlbumShow &&
          !newCloudEnhanceAlbumShow) ? BigDataConstants.SYSTEM_ALBUM_DISAPPEAR : BigDataConstants.SYSTEM_ALBUM_APPEAR
      };
      ReportToBigDataUtil.report(BigDataConstants.SYSTEM_ALBUM_IS_SHOW_ID, msg);
      await dataStore.putData(Constants.OLD_CLOUD_ENHANCE_ALBUM_SHOW, newCloudEnhanceAlbumShow);
    }
    if (oldVideoAlbumShow !== newVideoAlbumShow) {
      const msg: Record<string, number | string | boolean> = {
        'name': 'videoAlbum',
        'action': (oldVideoAlbumShow &&
          !newVideoAlbumShow) ? BigDataConstants.SYSTEM_ALBUM_DISAPPEAR : BigDataConstants.SYSTEM_ALBUM_APPEAR
      };
      ReportToBigDataUtil.report(BigDataConstants.SYSTEM_ALBUM_IS_SHOW_ID, msg);
      await dataStore.putData(Constants.OLD_VIDEO_ALBUM_SHOW, newVideoAlbumShow);
    }
    if (oldFavorAlbumShow !== newFavorAlbumShow) {
      const msg: Record<string, number | string | boolean> = {
        'name': 'favorAlbum',
        'action': (oldFavorAlbumShow &&
          !newFavorAlbumShow) ? BigDataConstants.SYSTEM_ALBUM_DISAPPEAR : BigDataConstants.SYSTEM_ALBUM_APPEAR
      };
      ReportToBigDataUtil.report(BigDataConstants.SYSTEM_ALBUM_IS_SHOW_ID, msg);
      await dataStore.putData(Constants.OLD_FAVOR_ALBUM_SHOW, newFavorAlbumShow);
    }
    await dataStore.flush();
  }

  /**
   * 更新相册缓存(文件)
   *
   * @param albums 相册信息数组
   */
  private async writeAlbumsCache(albums: (AlbumInfo | undefined)[]): Promise<void> {
    if (!albums || albums.length <= 0) {
      this.cacheMgr.writeCache(CacheType.ALBUMS, '');
      return;
    }
    let cacheContent: AlbumCache[] = [];
    Log.info(TAG, `writeAlbumsCache album soureData length: ${albums.length}`);
    albums.forEach((album: AlbumInfo | undefined) => {
      if (album && album.uri && album.uri.length !== 0) {
        Log.debug(TAG, `writeAlbumsCache album soureData: ${album?.printAlbumInfo()}`);
        let albumName = AlbumDefine.getSystemAlbumNameByResource(album);
        cacheContent.push({
          albumType: album?.albumType,
          albumSubType: album?.subType,
          albumName: albumName,
          count: album?.count,
          videoCount: album?.videoCount ?? 0,
          uri: album?.uri,
          coverUri: album?.coverUri,
          lpath: album?.lpath,
        } as AlbumCache);
      }
    });
    Log.info(TAG, `writeAlbumsCache write content length is: ${cacheContent.length}`);
    this.cacheMgr.writeCache(CacheType.ALBUMS, {
      albums: cacheContent,
    } as AlbumSetCache);
  }

  public hasUserAlbum(): boolean {
    for (let i: number = this.activeStart; i < this.activeEnd; i++) {
      let album: AlbumInfo | undefined = this.pageData.getData(i);
      if (Number(album?.subType) === Number(photoAccessHelper.AlbumSubtype.USER_GENERIC)) {
        return true;
      }
    }
    return false;
  }

  /**
   * 检查是否存在相册
   * @returns
   */
  public hasAlbum(): boolean {
    let albumCount: number = 0;
    for (let i: number = this.activeStart; i < this.activeEnd; i++) {
      let album: AlbumInfo | undefined = this.pageData.getData(i);
      if (album) {
        albumCount = albumCount + 1;
        break;
      }
    }
    return albumCount === 0 ? false : true;
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    let loadingInfo: LoadingInfo = super.buildLoadingInfo(changeInfo);
    return {
      start: this.coldStartState === AlbumSetColdStartState.FIRST_BATCH ? 0 : loadingInfo.start,
      count: this.coldStartState === AlbumSetColdStartState.FIRST_BATCH ?
        AlbumSetDataSource.INIT_FIRST_PATCH_LOAD_COUNT : loadingInfo.count,
      changeInfo: changeInfo as MediaLibChangeInfo,
      blackUriList: this.blackUriList,
      filterMediaType: this.filterMediaType,
    } as AlbumSetLoadingInfo;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    let task: AlbumSetLoadingTask = new AlbumSetLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      coldStartState: this.coldStartState,
      dataImpl: this.albumDataImpl,
      cacheMgr: this.cacheMgr,
    } as AlbumSetLoadingTaskParams);
    if (this.coldStartState !== AlbumSetColdStartState.CACHE) {
      ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_START, undefined);
    }
    switch (this.coldStartState) {
      case AlbumSetColdStartState.CACHE:
        this.coldStartState = AlbumSetColdStartState.FIRST_BATCH;
        setTimeout((): void => this.notifyDirty({ changeType: ChangeType.WINDOW }), 0);
        break;
      case AlbumSetColdStartState.FIRST_BATCH:
        this.coldStartState = AlbumSetColdStartState.SECOND_BATCH;
        setTimeout((): void => this.notifyDirty({ changeType: ChangeType.WINDOW }), 0);
        break;
      case AlbumSetColdStartState.SECOND_BATCH:
        this.coldStartState = AlbumSetColdStartState.DONE;
        break;
      default:
        break;
    }
    return task;
  }

  protected dispatchUpdates(result: LoadingResult<AlbumInfo>): void {
    this.albumCount = result.newPageData.size;
    let msg: string[] = [`dispatchUpdates blackUriList: ${this.blackUriList}`];
    msg.push(`size: ${result.oldPageData.size}->${result.newPageData.size}`);
    if (result.oldPageData.size !== result.newPageData.size) {
      this.albumAbstracts = new Array(this.albumCount) as AlbumAbstractInfo[];
    }

    let loadingResult: AlbumSetLoadingResult = result as AlbumSetLoadingResult;
    msg.push(`state: ${loadingResult.coldStartState}`);
    if (loadingResult.coldStartState !== AlbumSetColdStartState.CACHE) {
      ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_FINISH, undefined);
    }

    if (loadingResult.oldPageData.version === loadingResult.newPageData.version &&
      loadingResult.coldStartState === AlbumSetColdStartState.DONE) {
      // 非数据集刷新场景，不需要通知数量/分组数据的刷新，只需要通知加载起止范围内的元素刷新
      this.updateItems(loadingResult);
      for (let i: number = 0; i < loadingResult.info.count; i++) {
        let dataIndex: number = i + loadingResult.info.start;
        if (dataIndex < this.activeStart || dataIndex >= this.activeEnd) {
          continue;
        }
        let albumInfo: AlbumInfo | undefined = loadingResult.newPageData.getData(dataIndex);
        if (!albumInfo) {
          continue;
        }
        this.onDataChange(dataIndex);
      }
      this.broadCast?.emit(BroadCastConstants.UPDATE_SYS_ALBUM_MAP, []);
    } else {
      // 数据集刷新场景，分别更新分组数据以及items，最后通知界面及相关组件刷新
      this.dispatchWithDataChange(loadingResult);
    }

    Log.info(this.tag, msg.join(', '));
    super.dispatchUpdates(result);
  }

  protected updateItems(loadingResult: AlbumSetLoadingResult): void {
    for (let i: number = 0; i < loadingResult.info.count; i++) {
      let dataIndex: number = i + loadingResult.info.start;
      if (dataIndex < this.activeStart || dataIndex >= this.activeEnd) {
        continue;
      }
      let albumInfo: AlbumInfo | undefined = loadingResult.newPageData.getData(dataIndex);
      if (!albumInfo) {
        continue;
      }
      this.albums[dataIndex - this.activeStart] = albumInfo;
    }
  }

  protected dispatchWithDataChange(loadingResult: AlbumSetLoadingResult): void {
    this.adjustSlidingWindow(loadingResult);
    this.updateItems(loadingResult);
    this.dispatchCallbacks(loadingResult);

    AlbumSetDataSource.systemAlbumAppearOrDisAppearReport(this.albumAbstracts);
    this.writeCache(loadingResult);
  }

  private async writeCache(loadingResult: AlbumSetLoadingResult): Promise<void> {
    if (loadingResult.fromCache || loadingResult.newPageData.placeholdersBefore !== 0 || !this.shouldWriteCache) {
      return;
    }
    this.writeAlbumsCache(loadingResult.newPageData.data.slice(0,
      Math.min(AlbumSetDataSource.INIT_FIRST_PATCH_LOAD_COUNT, this.albumCount)));
  }

  private adjustSlidingWindow(loadingResult: AlbumSetLoadingResult): void {
    // 如果数据集发生变化，可能需要调整滑窗位置，比如当前滑窗在数据集最后，但是数据删除导致滑窗位置超出数据总量
    let newDataCount: number = loadingResult.newPageData.size;
    let newStart: number = 0;
    let newEnd: number = 0;
    if (newDataCount <= this.windowSize) {
      newEnd = this.windowSize;
      newStart = 0;
    } else {
      newEnd = Math.min(this.activeEnd, newDataCount);
      newStart = newEnd - this.windowSize;
    }

    // 窗口不变不需要进一步调整
    if (newStart === this.activeStart && newEnd === this.activeEnd) {
      return;
    }

    this.albums = new Array(newEnd - newStart);
  }

  protected dispatchCallbacks(loadingResult: AlbumSetLoadingResult): void {
    this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, []);
    this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [this.albumCount]);
    // preciseUpdateIndex 数组里有数据，则为精细化通知刷新场景，则单独刷新
    let arr: number[] | undefined = loadingResult.preciseUpdateIndex;
    if (arr !== undefined && Array.isArray(arr) && arr.length > 0) {
      Log.info(TAG, `dispatchUpdates for precise, index: ${JSON.stringify(arr)}`);
      for (let index of arr) {
        if (index < this.activeStart || index >= this.activeEnd) {
          continue;
        }
        this.onDataChange(index);
      }
    } else {
      this.onDataReloaded();
    }
  }

  public updateRenamedAlbumInfo(oldUri: string, newUri: string): void {
    for (let i = 0; i < this.pageData.data.length; i++) {
      if (this.pageData.data[i]?.uri === oldUri) {
        AlbumRefreshUtil.setRenameAlbumInfo(newUri);
        Log.info(TAG, `updateRenamedAlbumInfo, oldAlbumUri: ${oldUri}, newAlbumUri:${newUri}`);
        return;
      }
    }
  }

  public setAlbumCoverCache(uri: string, coverUri: string): void {
    if (uri) {
      this.albumCoverCache.set(uri, coverUri);
    }
  }

  public getAlbumCoverCache(uri: string): string {
    if (uri) {
      return this.albumCoverCache.get(uri) ?? '';
    }
    return '';
  }

  public releaseAlbumCoverCache(uri: string): void {
    if (uri) {
      this.albumCoverCache.delete(uri);
    }
  }

  public onDestroy(): void {
    this.albumCoverCache.clear();
  }
}