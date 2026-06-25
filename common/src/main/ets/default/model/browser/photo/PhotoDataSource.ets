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

import lazy image from '@ohos.multimedia.image';
import lazy { Log } from '../../../utils/Log';
import lazy { MediaDataSource } from './MediaDataSource';
import type { LoadingListener } from '../LoadingListener';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { Constants as PhotoConstants } from './Constants';
import lazy { MediaItem } from './MediaItem';
import lazy { Constants } from '../../common/Constants';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { PhotoAsset } from '../../../access/UserFileManagerAccess';
import type { PhotoDataImpl } from './PhotoDataImpl';
import lazy { PhotoDataAdapter } from './PhotoDataAdapter';
import type { ResultsData } from '../../ResultsData';
import lazy { MediaResult } from './MediaResult';
import lazy { Thumbnail } from './Thumbnail';
import lazy { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { ShortCut } from '../../ShortCut';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Throttle } from '../../../utils/Throttle';
import lazy { PhotoConfig } from '../../../config/PhotoConfig';
import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { BroadCastManager } from '../../common/BroadCastManager';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import { DecodeFinishParam } from './PhotoDataAdapter';

const TAG: string = 'PhotoDataSource';
const UPDATE_TIMEOUT_MS: number = 1000;

// DataSource
export class PhotoDataSource implements IDataSource, LoadingListener {
  public static readonly MEDIA_URL_PREFIX_STR = 'datashare:///media/';
  public static readonly ALBUM_URL_PREFIX_STR = 'datashare:///media/album/';
  public static readonly IMAGE_URL_PREFIX_STR = 'datashare:///media/image/';
  public static readonly VIDEO_URL_PREFIX_STR = 'datashare:///media/video/';
  public static readonly IMAGE_URL_PREFIX_STR_V10 = 'file://media/image/';
  public static readonly VIDEO_URL_PREFIX_STR_V10 = 'file://media/video/';
  public static readonly MEDIA_URL_PREFIX_STR_V10 = 'file://media/';
  public static readonly ALBUM_URL_PREFIX_STR_V10 = 'file://media/PhotoAlbum/';
  public static readonly IMAGE_VIDEO_URL_PREFIX_STR_V10 = 'file://media/Photo/';
  public static readonly IMAGE_TYPE_PREFIX_STR = 'image/';
  public static readonly VIDEO_TYPE_PREFIX_STR = 'video/';
  // Data change listener
  public albumUri: string = '';
  public photoDataAdapter: PhotoDataAdapter = new PhotoDataAdapter();
  protected photoDataImpl: PhotoDataImpl;
  private albumDataSource?: MediaDataSource;
  public broadCast?: BroadCast;
  private aBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private deviceId: string = '';
  protected enableGetDataFlag: boolean = true;
  private currentIndexChangedFunc: Function = (index: number, isAnimating: boolean):
    void => this.updatePixMapDataSource(index, isAnimating);
  public mediaResultCache: Map<string, MediaResult> = new Map<string, MediaResult>();
  private isNeedNotify: boolean = true;
  private readonly notifyThrottle: Throttle<Object> =
    new Throttle<Object>(UPDATE_TIMEOUT_MS, TAG);
  protected stateMachine: PhotoBrowserStateMachine;
  /**
   * 解码成功的回调
   */
  private onDeCodeFinishFunc: (dfp: DecodeFinishParam) => void = (dfp: DecodeFinishParam): void => {
    this.onDeCodeFinish(dfp);
  }

  constructor(stateMachine: PhotoBrowserStateMachine, albumUri?: string, photoDataImpl?: PhotoDataImpl) {
    this.stateMachine = stateMachine;
    Log.debug(TAG, 'bind onMessage');
    if (albumUri) {
      this.albumUri = albumUri;
    }

    this.photoDataImpl =
      photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
  }

  /**
   * 返回内存缩略图的长度，仅相机拍照场景生效，FastPhotoDataSource中进行赋值
   *
   * @returns 返回内存缩略图的长度
   */
  protected getThumbnailsSize(): number {
    return 0;
  }

  public totalCount(): number {
    if (this.albumDataSource) {
      return Math.max(this.albumDataSource.totalCount(), 0);
    } else {
      return 0;
    }
  }

  public setIsNeedNotify(isNeedNotify: boolean) {
    this.isNeedNotify = isNeedNotify;
  }

  public realTotalCount(): number {
    let totalCount = 0;
    /* instrument ignore if */
    if (this.albumDataSource) {
      totalCount = this.albumDataSource.realTotalCount();
      Log.debug(TAG, `realTotalCount: ${totalCount}`);
      return totalCount;
    }
    return 0;
  }

  // get DataIndex with item
  public getDataIndex(item: MediaItem): number {
    return this.albumDataSource?.getDataIndex(item) ?? -1;
  }

  public resetAlbumUri(albumUri: string): void {
    this.albumUri = albumUri;
    if (this.albumDataSource) {
      this.albumDataSource.setAlbumUri(this.albumUri);
      this.albumDataSource.resetActiveWindow();
      this.albumDataSource.initData();
      this.albumDataSource.forceUpdate();
    }
  }

  public setAlbumUri(albumUri: string): void {
    this.albumUri = albumUri;
  }

  public getAlbumUri(): string {
    return this.albumUri;
  }

  public setDeviceId(deviceId: string): void {
    this.deviceId = deviceId;
  }

  /* instrument ignore next */
  public releaseCache(key: string): void {
  }

  public isUriInCache(uri: string, indexNotifyCallback: Function): boolean {
    return this.albumDataSource?.isUriInCache(uri, indexNotifyCallback) ?? false;
  }

  /* instrument ignore next */
  public getItemIndexByUri(uri: string, indexNotifyCallback: (index: number) => void,
    isFromCard: boolean = false): void {
    Log.info(TAG, `getItemIndexByUri, ${uri}`);
    this.albumDataSource?.getItemIndexByUri(uri, indexNotifyCallback, isFromCard);
  }

  /* instrument ignore next */
  public initData(isReservedListeners: boolean = false): void {
    let dataSource: MediaDataSource;
    /* instrument ignore next */
    if (!DeviceInfo.isPcOrTablet() && PhotoConfig.isLibrary()) {
      // 手机设备在相机大图组件上滑动窗口减少
      dataSource = new MediaDataSource(Constants.DEFAULT_PHONE_SLIDING_WIN_SIZE, this.photoDataImpl);
    } else if (DeviceInfo.isPcOrTablet()) {
      dataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.photoDataImpl);
    } else {
      // 滑动窗口在手机设备上可以小一些
      dataSource = new MediaDataSource(Constants.DEFAULT_CARD_SLIDING_WIN_SIZE, this.photoDataImpl);
    }
    dataSource.setAlbumUri(this.albumUri as string);
    dataSource.initData();
    if (isReservedListeners && this.albumDataSource?.listeners) {
      dataSource.listeners = this.albumDataSource?.listeners;
    }
    this.setAlbumDataSource(dataSource);
  }

  public enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
    this.albumDataSource?.enableGetData(flag);
  }

  public isGetDataEnabled(): boolean {
    return this.enableGetDataFlag;
  }

  public getSimpleData(index: number): MediaResult | undefined {
    Log.info(TAG, "getSimpleData: " + index);
    TraceControllerUtils.startTrace('PhotoBrowser getData');
    if (!this.enableGetDataFlag) {
      Log.error(TAG, `getSimpleData failed enableGetDataFlag undefined`);
      TraceControllerUtils.finishTrace('PhotoBrowser getData');
      return undefined;
    }
    /* instrument ignore next */
    if (this.albumDataSource) {
      // TODO: 等PCgetdata能获取准确mediaitem后删除
      if (DeviceInfo.isPc()) {
        Log.info(TAG, `getPCData mediaItem`);
        return this.getData(index);
      }
      let mediaItem: MediaItem | undefined = this.albumDataSource.getData(index)?.mediaItem;
      if (mediaItem === undefined || mediaItem.uri === '') {
        Log.warn(TAG, `getSimpleData mediaItem failed ${mediaItem?.uri}`);
        return this.getData(index);
      }
      Log.info(TAG, `getSimpleData mediaItem ${mediaItem?.uri}`);
      if (mediaItem) {
        let result = this.packDataWithCacheInner(index, mediaItem);
        TraceControllerUtils.finishTrace('PhotoBrowser getData');
        return result;
      }
    }
    TraceControllerUtils.finishTrace('PhotoBrowser getData');
    return undefined;
  }

  public getData(index: number): MediaResult | undefined {
    Log.info(TAG, "getData: " + index);
    TraceControllerUtils.startTrace('PhotoBrowser getData');
    if (!this.enableGetDataFlag) {
      TraceControllerUtils.finishTrace('PhotoBrowser getData');
      return undefined;
    }
    /* instrument ignore next */
    if (this.albumDataSource) {
      this.albumDataSource.updateSlidingWindow(index);
      let mediaItem: MediaItem | undefined = this.albumDataSource.getRawData(index) ?? new MediaItem();
      if (mediaItem) {
        let result = this.packDataWithCacheInner(index, mediaItem);
        TraceControllerUtils.finishTrace('PhotoBrowser getData');
        return result;
      }
    }
    Log.error(TAG, `getData failed`);
    TraceControllerUtils.finishTrace('PhotoBrowser getData');
    return undefined;
  }

  public getDataWithoutCache(index: number): MediaResult | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    /* instrument ignore next */
    Log.info(TAG, `getDataWithoutCache from index ${index}`);
    if (this.albumDataSource) {
      this.albumDataSource.updateSlidingWindow(index);
      let mediaItem: MediaItem | undefined = this.albumDataSource.getRawData(index);
      return this.packData(index, mediaItem);
    }
    return undefined;
  }

  /** 探测滑动窗口是否已有可用 MediaItem（不依赖 enableGetDataFlag，供推迟绑定判定）。 */
  public isAlbumWindowItemHydratedForIndex(index: number): boolean {
    if (!this.albumDataSource) {
      return false;
    }
    this.albumDataSource.updateSlidingWindow(index);
    const mediaItem: MediaItem | undefined = this.albumDataSource.getRawData(index);
    if (!mediaItem) {
      return false;
    }
    return String(mediaItem.uri ?? '').length > 0 || String(mediaItem.path ?? '').length > 0;
  }

  public getMediaItemWithoutCache(index: number): MediaItem | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    /* instrument ignore next */
    Log.info(TAG, `getMediaItemWithoutCache from index ${index}`);
    if (this.albumDataSource) {
      this.albumDataSource.updateSlidingWindow(index);
      let mediaItem: MediaItem | undefined = this.albumDataSource.getRawData(index);
      return mediaItem;
    }
    return undefined;
  }

  public packDataWithCache(index: number, mediaItem: MediaItem): MediaResult {
    Log.info(TAG, "packDataWithCache: " + index);
    return this.packDataWithCacheInner(index, mediaItem);
  }

  /* instrument ignore next */
  private packDataWithCacheInner(index: number, mediaItem: MediaItem): MediaResult {
    Log.info(TAG, `uri = ${ImageUtil.encryptThumbnailUri(mediaItem?.uri)}&width = ${mediaItem?.width}&height = ${mediaItem?.height}&index = ${index}`);
    if (mediaItem.height === 0 || mediaItem.width === 0) {
      this.getDataByUri(mediaItem.uri).then((result) => {
        mediaItem = new MediaItem(result);
        if (mediaItem.height === 0 || mediaItem.width === 0) {
          return;
        }
        let index = this.albumDataSource?.getIndexByMediaItem(mediaItem) ?? -1;
        if (index !== Constants.NOT_FOUND) {
          this.albumDataSource?.onDataChanged(index);
        }
        this.onDataChanged(index);
      });
    }

    let path: string = mediaItem.path;
    let thumbnail: Thumbnail = this.photoDataAdapter.getThumbnail(mediaItem) ?? new Thumbnail;
    const media = this.mediaResultCache.get(path);
    if (media) {
      Log.info(TAG, 'Update MediaResult ');
      media.update(mediaItem);
      media.setItemThumbnail(thumbnail);
      media.setItemPos(index + this.getThumbnailsSize());
      return media;
    }
    const mediaResult = new MediaResult(mediaItem);
    mediaResult.setItemThumbnail(thumbnail);
    mediaResult.setItemPos(index + this.getThumbnailsSize());
    this.mediaResultCache.set(path, mediaResult);
    Log.info(TAG, `Create MediaResult and map length = ${this.mediaResultCache.size}`);
    return mediaResult;
  }

  public packData(index: number, mediaItem?: MediaItem): MediaResult | undefined {
    if (!mediaItem) {
      Log.error(TAG, `Get item undefined, index: ${index}`);
      return undefined;
    }
    /* instrument ignore if */
    if (mediaItem.height === 0 || mediaItem.width === 0) {
      this.getDataByUri(mediaItem.uri).then((result) => {
        mediaItem = new MediaItem(result);
        if (mediaItem.height === 0 || mediaItem.width === 0) {
          return;
        }
        let index = this.albumDataSource?.getIndexByMediaItem(mediaItem) ?? -1;
        if (index !== Constants.NOT_FOUND) {
          this.albumDataSource?.onDataChanged(index);
        }
        this.onDataChanged(index);
      });
    }
    /* instrument ignore next */
    let thumbnail: Thumbnail = this.photoDataAdapter.getThumbnail(mediaItem) ?? new Thumbnail;
    let mediaResult: MediaResult = new MediaResult(mediaItem);
    mediaResult.setItemThumbnail(thumbnail);
    mediaResult.setItemPos(index);
    return mediaResult;
  }

  /* instrument ignore next */
  public releaseCachedMediaResult(mediaResult: MediaResult | undefined): void {
    if (mediaResult?.path && this.mediaResultCache.has(mediaResult.path)) {
      Log.info(TAG, `Release MediaResult ${mediaResult.path}: create new one`);
      this.mediaResultCache.delete(mediaResult.path);
    }
  }

  private onDeCodeFinish(dfp: DecodeFinishParam): void {
    // 开启下一个任务
    Log.info(TAG,
      `onDeCodeFinish isMovingPhoto: ${dfp.isMovingPhoto}, uri: ${dfp.uri}, movingPhoto: ${dfp.movingPhoto}`)

    this.broadCast?.emit(PhotoDataAdapter.EVENT_THUMBNAIL_LOADED_PREFIX + dfp.uniqueId, [dfp.thumb]);
    this.photoDataAdapter.pickAndSendRequest();
  }

  /* instrument ignore next */
  public updatePixMapDataSource(index: number, isAnimating: boolean): void {
    Log.info(TAG, `updatePixMapDataSource ${this.stateMachine.getCurrentIndex()} -> ${index} - ${isAnimating}`);
    if (index < 0) {
      return;
    }
    // cache load
    this.photoDataAdapter.updateRequests(this, this.onDeCodeFinishFunc, index, isAnimating);
    ShortCut.tabSelectedMedia = this.getRawData(index).data;
  }

  /**
   * 重启任务，再获取一次动图，用于修改动图播放模式场景
   * */
  public resetPhotoRequest(uri: string) {
    Log.info(TAG, `resetPhotoRequest uri: ${uri}`)
    if (!uri) {
      return;
    }
    this.photoDataAdapter.resetPhotoRequest(uri);
  }

  /* instrument ignore next */
  public updatePixMapByUri(uri: string): void {
    Log.info(TAG, `[request2Phase] updatePixMapByUri uri -> ${uri}`);
    const DEFAULT_SIZE: number = 256;
    let item: MediaItem = new MediaItem();
    item.uri = uri;
    item.width = DEFAULT_SIZE;
    item.height = DEFAULT_SIZE;
    item.mediaType = photoAccessHelper.PhotoType.IMAGE;
    this.photoDataAdapter.updateHighResRequest(this, this.onDeCodeFinishFunc, item);
  }

  public getRawData(index: number, realIndex?: number): ResultsData {
    if (this.albumDataSource) {
      return {
        data: this.albumDataSource.getRawData(index),
        pos: realIndex ?? index,
      };
    }
    /* instrument ignore next */
    Log.warn(TAG, `albumDataSource is undefined for index:${index}`);
    return {
      data: undefined,
      pos: realIndex ?? index,
    };
  }

  // 根据burstKey获取所有连拍照片
  /* instrument ignore next */
  public async getMediaItemsByBurstKey(burstKey: string | undefined, isTrash?: boolean): Promise<MediaItem[]> {
    if (!this.albumDataSource || !burstKey) {
      return [];
    }
    return await this.albumDataSource.getMediaItemsByBurstKey(burstKey, isTrash);
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.albumDataSource) {
      this.albumDataSource.registerObserver();
      if (this.albumDataSource.listeners.indexOf(listener) < 0) {
        this.albumDataSource.listeners.push(listener);
      }
      Log.debug(TAG, `listener size: ${this.albumDataSource.listeners.length}`);
    }

  }

  /* instrument ignore next */
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    if (this.albumDataSource) {
      const pos = this.albumDataSource.listeners.indexOf(listener);
      if (pos >= 0) {
        this.albumDataSource.listeners.splice(pos, 1);
      }
      Log.debug(TAG, `unregisterDataChangeListener listener size: ${this.albumDataSource.listeners.length}`);
    }
  }

  public setAlbumDataSource(albumDataSource: MediaDataSource | undefined): void {
    Log.debug(TAG, 'setAlbumDataSource');
    if (!albumDataSource) {
      Log.error(TAG, 'dataSource undefined');
    }
    this.albumDataSource = albumDataSource;
    this.albumDataSource?.addLoadingListener(this);
  }

  public getAlbumDataSource(): MediaDataSource | undefined {
    if (this.albumDataSource) {
      return this.albumDataSource;
    }
    return undefined;
  }

  public getPhotoDataImpl(): PhotoDataImpl | undefined {
    if (this.photoDataImpl) {
      return this.photoDataImpl;
    }
    return undefined;
  }

  public setBroadCast(broadCastParam: BroadCast): void {
    this.broadCast?.off(PhotoConstants.EVENT_ON_CURRENT_INDEX_CHANGED, this.currentIndexChangedFunc);

    this.broadCast = broadCastParam;
    this.broadCast?.on(PhotoConstants.EVENT_ON_CURRENT_INDEX_CHANGED, this.currentIndexChangedFunc);
  }

  /* instrument ignore next */
  public setBroadCastToAlbum(broadCastParam: BroadCast): void {
    this.albumDataSource?.setPhotoBroadCast(broadCastParam);
  }

  /* instrument ignore next */
  public onDataReloaded(): void {
    Log.info(TAG, 'onDataReloaded start');
    this.albumDataSource?.onDataReloaded();
  }

  /* instrument ignore next */
  public onSizeLoadingFinished(size: number): void {
    Log.info(TAG, `onSizeLoadingFinished, current size: ${size}`);
    this.broadCast?.emit(PhotoConstants.DATA_SIZE_CHANGED, [size]);
  }

  /* instrument ignore next */
  public onDataLoadingFinished(): void {
    // after the mediaLib updates the data, it directly calls onDataReloaded.
    // swiper updates only the five mounted items
    Log.debug(TAG, `onDataLoadingFinished listeners size: ${this.albumDataSource?.listeners.length ?? 0}\
            totalCount: ${this.totalCount()}`);
    this.broadCast?.emit(PhotoConstants.DATA_CONTENT_CHANGED, []);
  }

  /* instrument ignore next */
  public onDataChanged(dataIndex: number): void {
    if (this.albumDataSource) {
      this.albumDataSource.listeners.forEach((listener: DataChangeListener) => {
        listener.onDataChanged(dataIndex);
      });
    }
  }

  /* instrument ignore next */
  public deleteData(index: number): void {
    if (this.albumDataSource) {
      this.albumDataSource.listeners.forEach((listener: DataChangeListener) => {
        Log.debug(TAG, 'onDataDeleted');
        listener.onDataDeleted(index);
      });
    }
  }

  public async getDataByUri(uri: string): Promise<PhotoAsset> {
    let tmp: PhotoAsset = await this.photoDataImpl.getDataByUri(uri) as PhotoAsset;
    return tmp;
  }

  /* instrument ignore next */
  public getMediaItemByUri(uri: string, itemNotifyCallback: Function): void {
    this.albumDataSource?.getMediaItemByUri(uri, itemNotifyCallback);
  }

  public getItemByUri(uri?: string): MediaItem | undefined {
    /* instrument ignore if */
    if (this.albumDataSource && uri) {
      return this.albumDataSource.getItemByUri(uri);
    }
    return undefined;
  }

  // 可根据 uri 和 albumUri 获取 PhotoAsset. 若 albumUri 为空，则不能够获取到 ”最近删除“ 相册内的内容。
  public async fetchItemInAlbumByUri(uri: string, albumUri?: string,
    fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    if (!this.albumDataSource || !uri) {
      return undefined;
    }
    /* instrument ignore if */
    if (!this.albumDataSource.photoDataImpl.getSinglePhotoAsset) {
      Log.error(TAG, 'fetchItemInAlbumByUri: DataImpl not implement getSinglePhotoAsset');
      return undefined;
    }
    /* instrument ignore next */
    return await this.albumDataSource.photoDataImpl.getSinglePhotoAsset(uri, albumUri, fetchColumns);
  }

  public getItemByPath(path: string): MediaItem | undefined {
    /* instrument ignore if */
    if (this.albumDataSource) {
      return this.albumDataSource.getItemByPath(path);
    }
    return undefined;
  }

  public getDataIndexByUri(uri?: string): number {
    /* instrument ignore if */
    if (this.albumDataSource && uri) {
      return this.albumDataSource.getDataIndexByUri(uri);
    }
    return Constants.NOT_FOUND;
  }

  public getDataIndexByDisplayName(displayName?: string): number {
    /* instrument ignore if */
    if (this.albumDataSource && displayName) {
      return this.albumDataSource.getDataIndexByDisplayName(displayName);
    }
    return Constants.NOT_FOUND;
  }

  public getDataIndexByPrefix(uri: string): number {
    if (!this.albumDataSource || !uri) {
      return Constants.NOT_FOUND;
    }
    const uriSplitArr: string[] = uri.split('/');
    uriSplitArr.pop();
    const prefixStr: string = uriSplitArr.join('/');
    /* instrument ignore next */
    for (let i = this.albumDataSource.activeStart; i < this.albumDataSource.activeEnd; i++) {
      let mediaItem: MediaItem = this.albumDataSource.getRawData(i) ?? new MediaItem();
      if (mediaItem.uri) {
        const itemUriSplitArr: string[] = mediaItem.uri.split('/');
        itemUriSplitArr.pop();
        if (itemUriSplitArr.join('/') === prefixStr) {
          return i;
        }
      }
    }
    return Constants.NOT_FOUND;
  }

  public getDataByDisplayName(displayName: string): MediaItem | undefined {
    let res: MediaItem | undefined;
    if (!this.albumDataSource || !displayName) {
      return res;
    }
    /* instrument ignore next */
    let targetName: string = displayName.replace('_enhanced', '');
    for (let i = this.albumDataSource.activeStart; i < this.albumDataSource.activeEnd; i++) {
      let mediaItem: MediaItem = this.albumDataSource.getRawData(i) ?? new MediaItem();
      if (mediaItem.displayName === targetName) {
        return mediaItem;
      }
    }
    return res;
  }

  // Search for the index of first valid item in MediaDataSource
  public getValidStartIndex(): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getValidStartIndex();
    }
    return Constants.NOT_FOUND;
  }

  // Search for the index of last valid item in MediaDataSource
  public getValidEndIndex(): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getValidEndIndex();
    }
    return Constants.NOT_FOUND;
  }

  /* instrument ignore next */
  public release(): void {
    if (this.albumDataSource) {
      this.albumDataSource.releasePhotoBroadCast();
      this.albumDataSource.removeLoadingListener(this);
      // cancel the mediaLibrary listening of albumDataSource when the large image is destroyed.
      // cannot cancel it in unregisterDataChangeListener
      this.albumDataSource?.unregisterObserver();
    }
    this.broadCast?.off(PhotoConstants.EVENT_ON_CURRENT_INDEX_CHANGED, this.currentIndexChangedFunc);
    this.broadCast = undefined;
    this.releaseTempData();
  }

  /* instrument ignore next */
  public unInit(): void {
    this.release();
    if (this.albumDataSource) {
      this.albumDataSource?.releaseBroadCast();
      this.albumDataSource?.pendingUpdateData?.clear();
    }
  }

  public getPositionByIndex(index: number): number | undefined {
    if (this.albumDataSource) {
      return index;
    }
    /* instrument ignore next */
    return undefined;
  }

  /* instrument ignore next */
  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    Log.info(TAG, `onNotify nfyInfo: ${nfyInfo.info()}, isForceUpdate: ${isForceUpdate}`);
    if (!this.isNeedNotify) {
      this.notifyThrottle.execute(() => {
      }, () => {
        this.albumDataSource?.onNotify(nfyInfo, true);
        this.isNeedNotify = true;
      });
      return;
    }
    if (!this.albumDataSource) {
      Log.warn(TAG, `not albumDataSource, skip notify.`);
      return;
    }
    if (!this.albumDataSource.unifyNotify) {
      this.albumDataSource?.onNotify(nfyInfo, isForceUpdate);
    }
  }

  /* instrument ignore next */
  public onChange(changeType: string, isForceUpdate?: boolean): void {
    if (!this.albumDataSource) {
      return;
    }
    if (!this.albumDataSource.unifyNotify) {
      this.albumDataSource?.onChange(changeType, isForceUpdate);
    }
  }

  /* instrument ignore next */
  public switchRefreshOn(): void {
    this.albumDataSource?.switchRefreshOn();
  };

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex() ?? 0;
  }

  public updateCurrent(index: number): void {
    Log.info(TAG, `updateCurrent ${this.stateMachine.getCurrentIndex()} -> ${index}`);
    this.mediaResultCache.forEach((item) => {
      if (item.item) {
        let beforePos = item.pos;
        // 如果添加图片，需要更新mediaResultCache的pos
        item.pos = this.getDataIndex(item.item);
        Log.info(TAG, `updatepos ${beforePos} -> ${item.pos}`);
      }
    });
  }

  public releaseMediaCache(): void {
    this.mediaResultCache?.clear();
    Log.info(TAG, 'releaseMediaCache');
  }

  /* instrument ignore next */
  public releasePhotoDataAdapter(): void {
    this.photoDataAdapter?.clear();
    Log.info(TAG, 'releaseMediaCache');
  }

  /* instrument ignore next */
  public releaseTempData(): void {
    this.releaseMediaCache();
    this.releasePhotoDataAdapter();
  }

  /* instrument ignore next */
  public updateSlidingWindow(dataIndex: number): void {
    this.albumDataSource?.updateSlidingWindow(dataIndex);
  }
}