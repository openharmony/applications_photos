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

import lazy { Log } from '../../../utils/Log';
import lazy { AlbumInfo } from './AlbumInfo';
import lazy { Constants } from '../../common/Constants';
import lazy { MediaObserver } from '../dataObserver/MediaObserver';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { ChangeInfo, ChangeType, DataSource, LoadingInfo, LoadingResult, LoadingTask } from '../../DataSource';
import lazy { AlbumSetCacheManager, CacheType } from '../../AlbumSetCacheManager';
import lazy { PageData } from '../../PageData';
import lazy { MediaLibChangeInfo } from '../../MediaLibChangeInfo';
import lazy { MediaLibLoadingInfo } from '../../MediaLibLoadingInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAlbum, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { HashMap } from '@kit.ArkTS';
import type { PhotoAsset } from '../../../access/PhotoAccessHelperAccess';
import lazy { MediaItem } from '../photo/MediaItem';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { DecodeDynamicRange } from '../../../utils/ImageUtil';
import lazy { Region } from '../../common/DataTypes';
import lazy { StringUtil } from '../../../utils/StringUtil';
import lazy { AlbumSetDataInfo } from '../../common/AlbumSetDataInfo';

const TAG: string = 'common_GroupAlbumDataSource';
const ANALYSIS_ALBUM = 'file://media/AnalysisAlbum/';

interface GroupCache {
  albums: AlbumInfo[];
};


export enum GroupColdStartState {
  CACHE = 1,
  FIRST_BATCH,
  DONE
}


interface GroupLoadingTaskParams {
  info: LoadingInfo;
  source: DataSource<AlbumInfo>;
  pageData: PageData<AlbumInfo>;
  coldStartState: GroupColdStartState;
  cacheMgr: AlbumSetCacheManager;
}

interface GroupLoadingResult extends LoadingResult<AlbumInfo> {
  coldStartState: GroupColdStartState;
  fromCache?: boolean;
  albumCounts?: number[];
}

class GroupLoadingTask extends LoadingTask<AlbumInfo> {
  private readonly params: GroupLoadingTaskParams;
  private albumCounts: number[] = [];

  public constructor(params: GroupLoadingTaskParams) {
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
        albumCounts: [],
      } as GroupLoadingResult;
    }

    let msg: string[] = [`AlbumSetLoadingTask.start state: ${this.params.coldStartState}`];
    msg.push(`isEmulator: ${DeviceInfo.isEmulator()}`);
    Log.info(TAG, msg.join(', '));
    switch (this.params.coldStartState) {
      case GroupColdStartState.CACHE:
        return this.loadCache();
      case GroupColdStartState.FIRST_BATCH:
        return this.loadFirstBatch();
      default:
        if (this.loadVersion === this.pageData.version) {
          // 仅滑窗变更
          return this.loadDataWhenSlide();
        } else {
          // 数据刷新
          return this.loadDataWhenRefresh();
        }
    }
  }

  private static loadAlbumFromCache(cache: Object | undefined): AlbumInfo[] {
    Log.info(TAG, 'start load album from cache');
    let albumCache: GroupCache | undefined = cache as GroupCache;
    if (!albumCache) {
      Log.error(TAG, `loadAlbumFromCache, albumCache is invalid`);
      return [];
    }
    if (!albumCache.albums || albumCache.albums.length <= 0) {
      Log.error(TAG, `loadAlbumFromCache, albumCache.albums is invalid`);
      return [];
    }
    Log.info(TAG, `loadAlbumFromCache, data is: ${albumCache.albums}`);
    return albumCache.albums;
  }

  private async loadCache(): Promise<GroupLoadingResult> {
    if (DeviceInfo.isEmulator()) {
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as GroupLoadingResult;
    }
    await this.params.cacheMgr.setCacheData(CacheType.GROUP_ALBUMS);
    let cache: Object | undefined = this.params.cacheMgr.getCache(CacheType.GROUP_ALBUMS);
    let albums: AlbumInfo[] =
      GroupLoadingTask.loadAlbumFromCache(cache);
    Log.info(TAG, `loadCache, albums length: ${albums.length}`);
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, albums, 0, 0),
      coldStartState: this.params.coldStartState,
      fromCache: true,
      albumCounts: [],
    } as GroupLoadingResult;
  }

  private async loadData(start: number, count: number): Promise<AlbumInfo[]> {
    Log.info(TAG, `group load data ${start} ${count}`);
    TraceControllerUtils.startTrace('getGroupAlbums');
    let albumInfo: AlbumInfo[] = [];
    let favorAlbums = await this.loadFavorAlbums(start, count);
    let unFavorStart: number = 0;
    let end = start + count;
    if (end <= favorAlbums.length) {
      return favorAlbums.slice(start, end);
    } else if (start < favorAlbums.length) {
      unFavorStart = favorAlbums.length;
    } else {
      unFavorStart = start;
    }
    albumInfo.push(...favorAlbums.slice(start, favorAlbums.length));
    let unFavorAlbums = await this.loadUnFavorAlbums(unFavorStart, end);
    albumInfo.push(...unFavorAlbums);
    TraceControllerUtils.finishTrace('getGroupAlbums');
    return albumInfo;
  }

  private async loadFavorAlbums(start: number, count: number): Promise<AlbumInfo[]> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('user_display_level', 3);
    let albums: PhotoAlbum[] = await PhotoAccessHelperAccess.getGroupAlbums(getContext(), predicates) ?? [];
    albums = albums.slice(start, count + start);
    return await this.setAlbumInfo(albums, true);
  }

  private async loadUnFavorAlbums(start: number, end: number): Promise<AlbumInfo[]> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.notEqualTo('user_display_level', -1);
    let albums: PhotoAlbum[] = await PhotoAccessHelperAccess.getGroupAlbums(getContext(), predicates) ?? [];
    albums = albums.slice(start, end);
    return await this.setAlbumInfo(albums, false);
  }

  /* instrument ignore next */
  protected async getFirstPhotoAsset(album: PhotoAlbum): Promise<PhotoAsset> {
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    let fetchOpt: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates().limit(1, 0),
      fetchColumns: UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS,
    };
    fetchResult = await album.getAssets(fetchOpt);
    let coverAsset: PhotoAsset = await fetchResult?.getFirstObject();
    return coverAsset;
  }

  // 生成albumInfo
  /* instrument ignore next */
  protected async setAlbumInfo(mediaSetList: PhotoAlbum[], isFavor: boolean): Promise<AlbumInfo[]> {
    if (mediaSetList.length === 0) {
      return [];
    }
    let coverFileIdList: number[] = await Promise.all(mediaSetList.map(async (album: PhotoAlbum) => {
      return AlbumDefine.getFileIdFromUri(album.coverUri ?? '') ?? Number.NaN;
    }));
    let requestTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('BatchQueryGroupCoverAssets', requestTime);
    let fetchOpt = AlbumDefine.getFileFetchOptByUriList(coverFileIdList);
    let assets: PhotoAsset[] = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    let assetsMap: HashMap<number, PhotoAsset> = new HashMap<number, PhotoAsset>();
    assets.map((asset: PhotoAsset) => {
      assetsMap.set(Number(asset.get(AlbumDefine.PHOTO_KEYS_FILE_ID)), asset);
    })
    TraceControllerUtils.finishTraceWithTaskId('BatchQueryGroupCoverAssets', requestTime);
    Log.info(TAG, `setAlbumInfo query coverAssets cost ${Date.now() - requestTime}`);

    let albums: AlbumInfo[] = []
    for (let album of mediaSetList) {
      const albumInfo: AlbumInfo = new AlbumInfo(album);
      albumInfo.setFavoritesAlbum(isFavor);
      const coverAsset: PhotoAsset | undefined = assetsMap.get(AlbumDefine.getFileIdFromUri(album.coverUri ?? ''));
      if (coverAsset) {
        let mediaItem: MediaItem = new MediaItem(coverAsset);
        let size: Size = ImageUtil.resizeThumbnail(mediaItem.width, mediaItem.height);
        mediaItem.setThumbnail(mediaItem.getThumbnailSafe(size));
        albumInfo.setMediaItem(mediaItem);
        albumInfo.setCoverOrientation(mediaItem.orientation);
        let thumbnail: string =
          ImageUtil.getLCDUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(), DecodeDynamicRange.SDR);
        albumInfo.setCoverPhotoUri(thumbnail);
        albumInfo.setCoverUri(thumbnail);
        await this.updateGroupAlbumInfo(coverAsset, album, albumInfo);
      } else {
        let firstCover = await this.getFirstPhotoAsset(album);
        let mediaItem: MediaItem = new MediaItem(firstCover);
        let size: Size = ImageUtil.resizeThumbnail(mediaItem.width, mediaItem.height);
        mediaItem.setThumbnail(mediaItem.getThumbnailSafe(size));
        albumInfo.setMediaItem(mediaItem);
        albumInfo.setCoverOrientation(mediaItem.orientation);
        let thumbnail: string =
          ImageUtil.getLCDUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(), DecodeDynamicRange.SDR);
        albumInfo.setCoverPhotoUri(thumbnail);
        albumInfo.setCoverUri(thumbnail);
        await this.updateGroupAlbumInfo(firstCover, album, albumInfo);
      }
      albums.push(albumInfo);
    }
    Log.info(TAG, `setAlbumInfo succeed ${albums.length}, cost: ${Date.now() - requestTime}`);
    return albums;
  }

  private async updateGroupAlbumInfo(coverAsset: PhotoAsset | undefined, album: PhotoAlbum, albumInfo: AlbumInfo):
    Promise<void> {
    if (!coverAsset) {
      Log.info(TAG, 'coverAsset is invalid');
      return;
    }
    let width: number = Number(coverAsset.get(photoAccessHelper.PhotoKeys.WIDTH) || 0);
    let height: number = Number(coverAsset.get(photoAccessHelper.PhotoKeys.HEIGHT) || 0);
    Log.info(TAG, 'setCoverImgSize' + width + `/${height}`);
    let size: Size = { width, height };
    const orientation = coverAsset?.get(photoAccessHelper.PhotoKeys.ORIENTATION);
    if (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270) {
      // 交换长宽
      size = { width: height, height: width };
    }
    if (width === 0 || height === 0) {
      let lcdSize: Size | undefined = PhotoAccessHelperAccess.getLcdSize(coverAsset);
      let thmSize: Size | undefined = PhotoAccessHelperAccess.getThmSize(coverAsset);
      size = lcdSize || thmSize || size;
    }
    albumInfo.setCoverImgSize(size);
    const faceId: string = await album.getFaceId();
    albumInfo.setTagId(faceId);
    albumInfo.setSubtype(Constants.GROUP_QUERY_SUB_TYPE);
    albumInfo.isGroupAlbum = true;
  }

  private async loadAlbumsCount(): Promise<number> {
    Log.info(TAG, 'start load data count');
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.notEqualTo('user_display_level', -1);
    return PhotoAccessHelperAccess.getGroupAlbumsCount(getContext(), predicates, this.albumCounts);
  }

  private async loadFirstBatch(): Promise<GroupLoadingResult> {
    let msg: string[] = [`loadFirstBatch query: (${this.info.start}, ${this.info.start + this.info.count})`];
    let startTime: number = Date.now();
    let count: number = await this.loadAlbumsCount();
    msg.push(`countCost: ${Date.now() - startTime}`, `count: ${count}`);
    startTime = Date.now();
    let albums: AlbumInfo[] = await this.loadData(0, this.info.count + this.info.start);
    msg.push(`albumsCost: ${Date.now() - startTime}`, `albums: ${albums.length}`);

    Log.info(TAG, msg.join(', '));

    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData<AlbumInfo>(this.loadVersion, albums, 0, count - albums.length),
      coldStartState: this.params.coldStartState,
      albumCounts: this.albumCounts,
    } as GroupLoadingResult;
  }

  private async loadDataWhenSlide(): Promise<GroupLoadingResult> {
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
      albumCounts: [],
    } as GroupLoadingResult;
  }

  private async loadDataWhenRefresh(): Promise<GroupLoadingResult> {
    let msg: string[] = [`loadDataWhenRefresh`];
    let startTime: number = Date.now();
    let newDataCount: number = await this.loadAlbumsCount();
    msg.push(`countCost: ${Date.now() - startTime}`, `count: ${newDataCount}`);

    if (newDataCount === 0) {
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new PageData<AlbumInfo>(this.loadVersion, [], 0, 0),
        coldStartState: this.params.coldStartState,
        albumCounts: [],
      } as GroupLoadingResult;
    }
    // 根据新的数据集范围，调整数据加载位置
    let loadCount: number = Math.min(this.info.count, newDataCount);
    let loadStart: number = Math.min(newDataCount - loadCount, this.info.start);

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
      albumCounts: [],
    } as GroupLoadingResult;
  }
}

export class GroupAlbumDataSource extends DataSource<AlbumInfo> implements IDataSource {
  public static readonly INIT_FIRST_PATCH_LOAD_COUNT: number = 99;
  private albumCount: number = 0;
  private coldStartState: GroupColdStartState = GroupColdStartState.CACHE;
  public albumInfoItemCache: Map<string, AlbumSetDataInfo> = new Map<string, AlbumSetDataInfo>();
  private readonly cacheMgr: AlbumSetCacheManager = new AlbumSetCacheManager(getContext());
  private albumCounts: number[] = [];

  public constructor() {
    super();
    this.tag = TAG;
    Log.info(this.tag, 'constructor');
    this.stepSize = 20;
    this.activeStart = 0;
    this.windowSize = 56;
    this.activeEnd = this.windowSize;
  }

  public getAlbumByIndex(index: number): AlbumInfo | undefined {
    return this.getPageData(index);
  }

  public getAlbumCount(): number {
    return this.albumCount;
  }

  public getData(index: number): AlbumSetDataInfo | undefined {
    Log.info(TAG, `getData index: ${index}`);
    if (index < 0) {
      Log.error(TAG, `index out of the total size, index: ${index}`);
      return undefined;
    }
    let item = this.getWrappedData(index);
    this.updateSlidingWindow(index);
    return item;
  }

  private getWrappedData(index: number): AlbumSetDataInfo | undefined {
    let result: AlbumSetDataInfo;
    const albumInfo: AlbumInfo | undefined = this.pageData.getData(index);
    if (!albumInfo) {
      Log.error(TAG, `invalid album info for index: ${index}`);
      return undefined;
    }
    const tmp: AlbumSetDataInfo | undefined = this.albumInfoItemCache.get(albumInfo.uri);
    if (tmp) {
      result = tmp;
      result.update(albumInfo, index);
    } else {
      result = new AlbumSetDataInfo(albumInfo, index);
      this.albumInfoItemCache.set(albumInfo?.uri, result);
    }
    return result;
  }

  public registerAlbumObserver(): void {
    MediaObserver.getInstance().registerObserver(this);
  }

  public unregisterAlbumObserver(): void {
    MediaObserver.getInstance().unregisterObserver(this);
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE || nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE ||
      nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE_ASTC || nfyInfo.type === MediaObserverNfyType.ALBUM_UPDATE ||
      (nfyInfo.type === MediaObserverNfyType.NONE && nfyInfo.uris?.length > 0)) {
      Log.info(TAG,
        `Group album photo remove or update onNotify: ${JSON.stringify(nfyInfo)}`);
      super.onNotify(nfyInfo);
      return;
    }

    let needRefreshFlag: boolean = false;
    if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD || nfyInfo.albumUris.length === 0) {
      Log.info(TAG, 'Group album onNotify drop');
      return;
    }

    for (let index = 0; index < nfyInfo.albumUris.length; index++) {
      if (StringUtil.isStringStartsWithNumber(nfyInfo.albumUris[index], ANALYSIS_ALBUM)) {
        needRefreshFlag = true;
        break;
      }
    }

    if (needRefreshFlag) {
      Log.info(TAG, `Group album onNotify:${nfyInfo.albumUris?.length}|${JSON.stringify(nfyInfo)}`);
      super.onNotify(nfyInfo);
    }
  }

  public onChange(mediaType: string): void {
    Log.info(TAG, `onChange mediaType: ${mediaType}`);
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
      this.notifyDirty({ changeType: ChangeType.DATA, changeTypes: [mediaType] } as MediaLibChangeInfo);
    }
  }

  /**
   * 更新相册缓存(文件)
   *
   * @param albums 相册信息数组
   */
  private async writeAlbumsCache(albums: (AlbumInfo | undefined)[]): Promise<void> {
    if (!albums || albums.length <= 0) {
      Log.info(TAG, `writeAlbumsCache, album is invalid`);
      this.cacheMgr.writeCache(CacheType.GROUP_ALBUMS, '');
      return;
    }
    Log.info(TAG, `writeAlbumsCache, write content length is: ${albums.length}`);
    this.cacheMgr.writeCache(CacheType.GROUP_ALBUMS, {
      albums: albums,
    } as GroupCache);
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    let loadingInfo: LoadingInfo = super.buildLoadingInfo(changeInfo);
    return {
      start: loadingInfo.start,
      count: loadingInfo.count,
      changeInfo: changeInfo as MediaLibChangeInfo,
    } as MediaLibLoadingInfo;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    let task: GroupLoadingTask = new GroupLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      coldStartState: this.coldStartState,
      cacheMgr: this.cacheMgr,
    } as GroupLoadingTaskParams);
    Log.info(TAG, `start state ${this.coldStartState}`);
    // 当前不支持分批加载
    switch (this.coldStartState) {
      case GroupColdStartState.CACHE:
        this.coldStartState = GroupColdStartState.FIRST_BATCH;
        let delay: number = (AppStorage.get<boolean>(Constants.PORTRAIT_LOAD_FINISH) ?? true) ? 0 : 500;
        Log.info(TAG, `delay is: ${AppStorage.get<boolean>(Constants.PORTRAIT_LOAD_FINISH)}`);
        setTimeout((): void => this.notifyDirty({ changeType: ChangeType.WINDOW }), delay);
        break;
      case GroupColdStartState.FIRST_BATCH:
        this.coldStartState = GroupColdStartState.DONE;
        break;
      default:
        break;
    }
    return task;
  }

  protected dispatchUpdates(result: LoadingResult<AlbumInfo>): void {
    this.albumCount = result.newPageData.size;
    let msg: string[] = [`size: ${result.oldPageData.size}->${result.newPageData.size}`];

    let loadingResult: GroupLoadingResult = result as GroupLoadingResult;
    msg.push(`state: ${loadingResult.coldStartState}`);

    if (loadingResult.oldPageData.version === loadingResult.newPageData.version &&
      loadingResult.coldStartState === GroupColdStartState.DONE) {
      // 非数据集刷新场景，不需要通知数量/分组数据的刷新，只需要通知加载起止范围内的元素刷新
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
    } else {
      // 数据集刷新场景，分别更新分组数据以及items，最后通知界面及相关组件刷新
      this.dispatchWithDataChange(loadingResult);
      this.albumCounts = loadingResult.albumCounts ?? [];
    }

    Log.info(this.tag, msg.join(', '));
    super.dispatchUpdates(result);
  }

  protected dispatchWithDataChange(loadingResult: GroupLoadingResult): void {
    Log.info(TAG, `dispatchWithDataChange`);
    this.dispatchCallbacks(loadingResult);

    this.writeCache(loadingResult);
  }

  private async writeCache(loadingResult: GroupLoadingResult): Promise<void> {
    if (loadingResult.fromCache || loadingResult.newPageData.placeholdersBefore !== 0) {
      Log.error(TAG, `writeCache, fromCache: ${loadingResult.fromCache}`);
      return;
    }
    this.writeAlbumsCache(loadingResult.newPageData.data.slice(0,
      Math.min(GroupAlbumDataSource.INIT_FIRST_PATCH_LOAD_COUNT, this.albumCount)));
  }

  protected dispatchCallbacks(loadingResult: GroupLoadingResult): void {
    this.onDataReloaded();
  }

  public getAlbumsCount(): number[] {
    return this.albumCounts;
  }
}