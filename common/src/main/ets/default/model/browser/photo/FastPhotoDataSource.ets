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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { CaptureState, MediaItem } from './MediaItem';
import lazy { Log } from '../../../utils/Log';
import lazy { ResultsData } from '../../ResultsData';
import lazy { MediaResult } from './MediaResult';
import lazy { Constants } from '../../common/Constants';
import lazy { Constants as PhotoConstants } from './Constants';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import { PhotoDataSource } from './PhotoDataSource';
import { LogUtils } from '../../../utils/LogUtils';

const TAG: string = 'FastPhotoDataSource';
const TMP_THUMBNAIL_COUNT_LIMIT = 5;
const THUMBNAIL_CACHE_TIMEOUT_MILLIS = 15 * 1000; // 缩略图缓存超时时间
const CHECK_CACHE_TIMEOUT_INTERVAL_MILLIS = 1500; // 检查缓存失效间隔
const THUMBNAIL_RELEASE_TIMEOUT_MILLIS = 1000; // 临时缩略图释放时延

// DataSource
export class FastPhotoDataSource extends PhotoDataSource {
  // 用于缓存未落盘的缩略图信息的内存队列
  private readonly thumbnails: MediaItem[] = [];
  // 定时清理任务的超时ID
  private delayClearTimeoutId: number = 0;
  // 用于记录待删除的缩略图内存缓存队列
  private readonly tmpThumbnails: Set<MediaItem> = new Set();

  public hasThumbnail(): boolean {
    return this.thumbnails.length > 0;
  }

  public onSizeLoadingFinished(size: number): void {
    Log.info(TAG, `onSizeLoadingFinished, current size: ${size}, thumbnails length: ${this.thumbnails.length}`);
    this.broadCast?.emit(PhotoConstants.DATA_SIZE_CHANGED, [this.thumbnails.length + size]);
  }

  /**
   * 增加缩略图（注：相机需保证按序调用此接口新增缩略图）
   *
   * @param captureId 缩略图ID
   * @param pixmap 真正的缩略图
   * @param isLivePhoto 是否为动态照片
   */
  public addThumbnail(captureId: string, pixmap: image.PixelMap, isLivePhoto: boolean): void {
    Log.debug(TAG, `addThumbnail, ${captureId}`);
    // xxx外屏需要显示图片总数，使用thumbnails缓存会导致totalcount不准
    if (DeviceInfo.isSmallFoldState()) {
      Log.info(TAG, 'DeviceInfo is smallFoldState');
      return;
    }
    let media = new MediaItem();
    media.initThumbnailPixmap(captureId, pixmap, isLivePhoto);
    this.thumbnails.unshift(media);
    this.tmpThumbnails.add(media);
    this.delayDeleteThumbnails();
    if (this.thumbnails.length > TMP_THUMBNAIL_COUNT_LIMIT) {
      let deleteMediaItem = this.thumbnails[this.thumbnails.length - 1];
      this.tmpThumbnails.delete(deleteMediaItem);
      this.releaseThumbnail(deleteMediaItem);
    }
  }

  /**
   * 更新缩略图
   *
   * @param captureId 缩略图ID
   * @param photoAsset 图片基本信息
   */
  public updateThumbnail(captureId: string, photoAsset: photoAccessHelper.PhotoAsset): void {
    Log.debug(TAG, `updateThumbnail, ${captureId}, uri: ${photoAsset?.uri}`);
    for (let mediaItem of this.thumbnails) {
      if (mediaItem.captureId === captureId) {
        if (mediaItem.captureState === CaptureState.PIXMAP) {
          mediaItem.updateThumbnail(photoAsset);
        }
        break;
      }
    }
  }

  /**
   * 删除缩略图（用于连拍场景的删除）
   *
   * @param captureId 缩略图ID
   */
  public removeThumbnail(captureId: string): void {
    Log.debug(TAG, `removeThumbnail, ${captureId}`);
    for (let thumbnailItem of this.thumbnails) {
      if (thumbnailItem.captureId === captureId) {
        this.tmpThumbnails.delete(thumbnailItem);
        this.releaseThumbnail(thumbnailItem);
        break;
      }
    }
  }

  public getUriByCaptureId(captureId: string): string {
    let uri: string = '';
    this.thumbnails.forEach((item, index) => {
      if (!!captureId && item.captureId === captureId) {
        uri = item.thumbnailUri;
      }
    })
    return uri;
  }

  public lockThumbnail(): void {
    if (this.delayClearTimeoutId === 0) {
      return;
    }
    clearTimeout(this.delayClearTimeoutId);
    this.delayClearTimeoutId = 0;
  }

  public unlockThumbnail(): void {
    this.delayDeleteThumbnails();
  }

  /**
   * 清除缓存的缩略图
   *
   * @param mediaItem 媒体项
   * @param index 索引项
   */
  public removeCachedThumbnail(mediaItem?: MediaItem): void {
    Log.debug(TAG, `removeCachedThumbnail, mediaItem: ${mediaItem}`);
    let deleteMediaItem: MediaItem | null = this.getCachedThumbnail(mediaItem);
    Log.debug(TAG, `removeCachedThumbnail, deleteMediaItem: ${deleteMediaItem}`);
    if (mediaItem && deleteMediaItem) {
      this.removeCachedThumbnailInner(deleteMediaItem, mediaItem);
      // 此处知会界面缩略图消失
      this.mediaResultCache.get(mediaItem.path)?.update(mediaItem);
    }
  }

  private removeCachedThumbnailInner(thumbnailItem: MediaItem, mediaItem?: MediaItem): void {
    Log.debug(TAG, `removeCachedThumbnailInner, thumbnailItem: ${thumbnailItem}`);
    this.releaseThumbnail(thumbnailItem);
    if (this.tmpThumbnails.has(thumbnailItem)) {
      let media = mediaItem ?? this.getItemByUriHeif(thumbnailItem.thumbnailUri);
      if (media) {
        let mediaResult = this.mediaResultCache.get(media.path);
        if (mediaResult) {
          // 此处变更为形态三，隐藏缩略图，只显示大图
          mediaResult.isShowPhoto = true;
          mediaResult.isShowThumbnail = false;
        }
        media.isShowThumbnail = false;
        media.captureState = CaptureState.NONE;
        media.thumbnailPixmap = undefined;
      }
      this.tmpThumbnails.delete(thumbnailItem);
      thumbnailItem?.releaseThumbnail();
    }
  }

  private isSamePhotoAsset(uri: string, compareUri: string): boolean {
    let splitStr: string | undefined = uri?.toString()?.split('file://media/Photo/')?.pop();
    const mediaLibraryFildId: string | undefined = splitStr?.toString()?.slice(0, splitStr.indexOf('/'));
    splitStr = compareUri?.toString()?.split('file://media/Photo/')?.pop();
    const lastCaptureFildId: string | undefined = splitStr?.toString()?.slice(0, splitStr.indexOf('/'))
    if (mediaLibraryFildId && lastCaptureFildId && mediaLibraryFildId === lastCaptureFildId) {
      return true;
    }
    return false;
  }

  private getCachedThumbnail(mediaItem?: MediaItem): MediaItem | null {
    if (!mediaItem || this.tmpThumbnails.size <= 0) {
      return null;
    }

    let cachedMediaItem: MediaItem | null = null;
    if (this.tmpThumbnails.has(mediaItem)) {
      cachedMediaItem = mediaItem;
    } else {
      for (let media of this.tmpThumbnails) {
        if (media.captureState === CaptureState.PHOTO_ASSET_STATE &&
        this.isSamePhotoAsset(media.thumbnailUri, media.uri)) {
          cachedMediaItem = media;
          break;
        }
      }
    }
    return cachedMediaItem;
  }

  /**
   * 删除已从媒体库加载的缩略图
   */
  private deleteLoadedThumbnails(): void {
    if (this.thumbnails.length <= 0) {
      return;
    }

    // 收集待删除项
    let waitDeleteThumbnails: Set<MediaItem> = new Set();
    Log.info(TAG, `deleteLoadedThumbnails thumbnails length = ${this.thumbnails.length}`);
    for (let index = this.thumbnails.length;
      index < Math.min(this.totalCount(), this.thumbnails.length + TMP_THUMBNAIL_COUNT_LIMIT); index++) {
      this.collectLoadedThumbnail(waitDeleteThumbnails, super.getRawData(this.getMediaIndex(index))?.data?.uri);
      if (waitDeleteThumbnails.size === this.thumbnails.length) {
        break;
      }
    }

    // 删除待删除项
    if (waitDeleteThumbnails.size > 0) {
      Log.info(TAG, `deleteLoadedThumbnails waitDeleteThumbnails size: ${waitDeleteThumbnails.size}`);
      for (let thumbnailMedia of waitDeleteThumbnails) {
        this.deleteLoadedThumbnail(thumbnailMedia);
      }
      Log.debug(TAG, `fast mediaCount: ${super.totalCount()}, thumbnailCount: ${this.thumbnails.length}`);
    }
  }

  private delayDeleteThumbnails(): void {
    if (this.delayClearTimeoutId !== 0) {
      // 避免重复设置timeout
      return;
    }
    this.delayClearTimeoutId = setTimeout(() => {
      this.delayClearTimeoutId = 0;
      if (!this.deleteCacheTimeoutThumbnails()) {
        this.delayDeleteThumbnails();
      }
    }, CHECK_CACHE_TIMEOUT_INTERVAL_MILLIS);
  }

  /**
   * 删除缓存的超时缩略图
   *
   * @returns 是否全部删除
   */
  private deleteCacheTimeoutThumbnails(): boolean {
    if (this.thumbnails.length <= 0 && this.tmpThumbnails.size <= 0) {
      return true;
    }
    // 收集待删除项
    let waitDeleteThumbnails: Set<MediaItem> = new Set();
    for (let media of this.thumbnails) {
      if (media.isThumbnailCacheTimeout(THUMBNAIL_CACHE_TIMEOUT_MILLIS)) {
        waitDeleteThumbnails.add(media);
        Log.warn(TAG, `deleteCacheTimeoutThumbnail captureId: ${media.captureId}`);
      }
    }
    for (let media of this.tmpThumbnails) {
      if (media.isThumbnailCacheTimeout(THUMBNAIL_CACHE_TIMEOUT_MILLIS)) {
        waitDeleteThumbnails.add(media);
      }
    }
    // 删除待删除项
    if (waitDeleteThumbnails.size > 0) {
      Log.info(TAG, `deleteCacheTimeoutThumbnails waitDeleteThumbnails size: ${waitDeleteThumbnails.size}`);
      for (let media of waitDeleteThumbnails) {
        this.removeCachedThumbnailInner(media);
      }
    }
    return this.thumbnails.length <= 0 && this.tmpThumbnails.size <= 0;
  }

  private collectLoadedThumbnail(waitDeleteThumbnails: Set<MediaItem>, mediaUri?: string): void {
    if (!mediaUri) {
      Log.warn(TAG, `collectLoadedThumbnail mediaUri: ${mediaUri}`);
      return;
    }
    for (let index = 0; index < this.thumbnails.length; index++) {
      let tmpThumbnail = this.thumbnails[index];
      if (!tmpThumbnail.thumbnailUri) {
        Log.debug(TAG, `collectLoadedThumbnail captureId: ${tmpThumbnail.captureId} thumbnailUri is null`);
      }
      if (tmpThumbnail.captureState === CaptureState.PHOTO_ASSET_STATE &&
      this.isSamePhotoAsset(tmpThumbnail.thumbnailUri, mediaUri)) {
        Log.info(TAG, `find deleteThumbnail, ${mediaUri}`);
        waitDeleteThumbnails.add(tmpThumbnail);
        break;
      }
    }
  }

  private getItemByUriHeif(uri: string): MediaItem | undefined {
    let item = super.getItemByUri(uri);
    if (!item?.uri) {
      item = super.getItemByUri(uri.replace('jpg', 'heic'));
    }
    return item;
  }

  private deleteLoadedThumbnail(thumbnailItem: MediaItem): void {
    let thumbnailIndex = this.getDataIndex(thumbnailItem);
    if (thumbnailIndex < 0) {
      return;
    }
    let media = this.getItemByUriHeif(thumbnailItem.thumbnailUri);
    if (media && this.tmpThumbnails.has(thumbnailItem)) {
      media.captureId = thumbnailItem.captureId;
      media.thumbnailUri = thumbnailItem.thumbnailUri;
      media.thumbnailPixmap = thumbnailItem.thumbnailPixmap;
      media.createTime = thumbnailItem.createTime;
      media.captureState = CaptureState.NONE;
      media.isShowThumbnail = false;
      let thumbnailResult = this.mediaResultCache.get(thumbnailItem.captureId);
      let mediaResult = super.packData(thumbnailIndex, media);
      if (thumbnailResult && mediaResult) {
        // 此处变更为形态二，同时显示缩略图和大图
        thumbnailResult.isShowThumbnail = true;
        thumbnailResult.isShowPhoto = true;
        thumbnailResult.updateAll(mediaResult);
        Log.info(TAG, `deleteLoadedThumbnail updateAll: ${thumbnailResult}`);
        this.mediaResultCache.set(media.path, thumbnailResult);
        this.mediaResultCache.delete(media.captureId);
      } else {
        Log.info(TAG, `deleteLoadedThumbnail remove from tmpThumbnails: ${thumbnailItem}`);
        this.tmpThumbnails.delete(thumbnailItem);
      }
    }
    // 释放缩略图项
    this.releaseThumbnail(thumbnailItem);
  }

  private releaseThumbnail(deleteMediaItem: MediaItem): void {
    let deleteMediaIndex = this.thumbnails.indexOf(deleteMediaItem);
    if (this.isThumbnailIndex(deleteMediaIndex)) {
      this.thumbnails.splice(deleteMediaIndex, 1);
      if (deleteMediaItem && !this.tmpThumbnails.has(deleteMediaItem)) {
        // 规避相机80分还未存图成功把相机pixmap释放导致拉起大图相机不传pixmap，放大动效有响应时延问题
        setTimeout(() => {
          deleteMediaItem.releaseThumbnail();
        }, THUMBNAIL_RELEASE_TIMEOUT_MILLIS);
        Log.info(TAG, `deleteMediaItem.releaseThumbnail ${deleteMediaItem}`);
      }
      Log.info(TAG, `releaseThumbnail item: ${deleteMediaItem}`);
    }
  }

  private isThumbnailIndex(index: number): boolean {
    return index >= 0 && index < this.thumbnails.length;
  }

  private getMediaIndex(index: number): number {
    return this.thumbnails.length > 0 ? Math.max(index - this.thumbnails.length, 0) : index;
  }

  private getIndexFromMediaIndex(mediaIndex: number): number {
    return mediaIndex + this.thumbnails.length;
  }

  private getMediaResultForMedia(index: number, mediaItem: MediaItem, withCache: boolean = true): MediaResult {
    let mediaResult: MediaResult | undefined = undefined;
    if (withCache) {
      mediaResult = this.mediaResultCache.get(mediaItem.captureId);
      if (mediaResult) {
        mediaResult.update(mediaItem);
      }
    }
    if (!mediaResult) {
      mediaResult = new MediaResult(mediaItem);
    }
    if (withCache) {
      this.mediaResultCache.set(mediaItem.captureId, mediaResult);
    }
    mediaResult.setItemPos(index);
    return mediaResult;
  }

  public mediaTotalCount(): number {
    return Math.max(super.totalCount(), 0);
  }

  /******************/
  /** 以下为继承接口 **/
  /******************/
  protected getThumbnailsSize(): number {
    return this.thumbnails.length;
  }

  public totalCount(): number {
    return Math.max(super.totalCount(), 0) + this.thumbnails.length;
  }

  public realTotalCount(): number {
    return super.realTotalCount() + this.thumbnails.length;
  }

  public getDataIndex(item: MediaItem): number {
    let index = this.thumbnails.indexOf(item);
    if (index >= 0) {
      return index;
    }
    return super.getDataIndex(item) + this.thumbnails.length;
  }

  public getItemIndexByUri(uri: string, indexNotifyCallback: Function): void {
    for (let index = 0; index < this.thumbnails.length; index++) {
      if (this.thumbnails[index].captureId === uri || this.isSamePhotoAsset(this.thumbnails[index].thumbnailUri, uri)) {
        indexNotifyCallback(index);
        return;
      }
    }
    if (super.isUriInCache(uri, (index: number): void =>
    indexNotifyCallback(index + this.thumbnails.length))) {
      return;
    }
    super.getItemIndexByUri(uri, (index: number): void => {
      indexNotifyCallback(index + this.thumbnails.length);
    });
  }

  public initData(isReservedListeners: boolean = false): void {
    super.initData(isReservedListeners);
    let mediaDataSource = this.getAlbumDataSource();
    if (mediaDataSource) {
      mediaDataSource.itemChangeListener = (): void => {
        // 此处监听数据加载完成，然后删掉符合条件内存数据
        Log.debug(TAG, `onItemChange to deleteLoadedThumbnails`);
        this.deleteLoadedThumbnails();
      };
    }
  }

  // LazyForEach call
  public getData(index: number): MediaResult | undefined {
    LogUtils.info(TAG, "getData: " + index);
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    let result: MediaResult | undefined = undefined;
    if (this.isThumbnailIndex(index)) {
      result = this.packDataWithCache(index, this.thumbnails[index]);
    } else {
      result = super.getData(this.getMediaIndex(index));
    }

    // thumbnailPixmap异常时，清除thumbnailPixmap
    if (result?.item?.thumbnailPixmap) {
      let info = result.item.thumbnailPixmap.getImageInfoSync();
      if (!info || !info.size || info.size.height <= 0 || info.size.width <= 0) {
        result.item.thumbnailPixmap = undefined;
        result.thumbnailPixmap = undefined;
      }
    }

    Log.debug(TAG, `fast getData ${index}, result: ${result}`);
    return result;
  }

  public getDataWithoutCache(index: number): MediaResult | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    Log.debug(TAG, `fast getDataWithoutCache from index ${index}`);
    if (this.isThumbnailIndex(index)) {
      return this.getMediaResultForMedia(index, this.thumbnails[index], false);
    } else {
      return super.getDataWithoutCache(this.getMediaIndex(index));
    }
  }

  public getMediaItemWithoutCache(index: number): MediaItem | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    Log.debug(TAG, `fast getMediaItemWithoutCache from index ${index}`);
    if (this.isThumbnailIndex(index)) {
      return this.thumbnails[index];
    } else {
      return super.getMediaItemWithoutCache(this.getMediaIndex(index));
    }
  }

  public packDataWithCache(index: number, mediaItem: MediaItem): MediaResult {
    Log.debug(TAG, `fast uri = ${mediaItem?.uri}&width = ${mediaItem?.width}&height = ${mediaItem?.height}`);
    if (this.isThumbnailIndex(index)) {
      return this.getMediaResultForMedia(index, mediaItem);
    } else {
      return super.packDataWithCache(this.getMediaIndex(index), mediaItem);
    }
  }

  public packData(index: number, mediaItem?: MediaItem): MediaResult | undefined {
    if (!mediaItem) {
      return undefined;
    }
    if (this.isThumbnailIndex(index)) {
      return this.getMediaResultForMedia(index, mediaItem, false);
    } else {
      return super.packData(this.getMediaIndex(index), mediaItem);
    }
  }

  public releaseCachedMediaResult(mediaResult: MediaResult | undefined): void {
    if (!!this.getCachedThumbnail(mediaResult?.item)) {
      // 当内存缓存队列存在此MediaResult时，不清理
      Log.info(TAG, `releaseCachedMediaResult encount cached mediaResult ${mediaResult}.`);
      return;
    }
    super.releaseCachedMediaResult(mediaResult);
  }

  public updatePixMapDataSource(index: number, isAnimating: boolean): void {
    super.updatePixMapDataSource(index - this.thumbnails.length, isAnimating);
  }

  public getRawData(index: number): ResultsData {
    if (this.isThumbnailIndex(index)) {
      return {
        data: this.thumbnails[index],
        pos: index,
      };
    } else {
      return super.getRawData(this.getMediaIndex(index), index);
    }
  }

  public getDataIndexByUri(uri?: string): number {
    if (!uri) {
      return Constants.NOT_FOUND;
    }
    for (let index = 0; index < this.thumbnails.length; index++) {
      if (this.thumbnails[index].captureId === uri || this.isSamePhotoAsset(this.thumbnails[index].thumbnailUri, uri)) {
        return index;
      }
    }
    return this.getIndexFromMediaIndex(super.getDataIndexByUri(uri));
  }

  public getValidStartIndex(): number {
    return this.getIndexFromMediaIndex(super.getValidStartIndex());
  }

  public getValidEndIndex(): number {
    return this.getIndexFromMediaIndex(super.getValidEndIndex());
  }

  public release(): void {
    super.release();
    if (this.delayClearTimeoutId !== 0) {
      clearTimeout(this.delayClearTimeoutId);
      this.delayClearTimeoutId = 0;
    }

    this.thumbnails.forEach((thumbnail: MediaItem) => {
      thumbnail.releaseThumbnail();
    });

    if (this.thumbnails.length > 0) {
      this.thumbnails.splice(0, this.thumbnails.length);
    }
    this.tmpThumbnails.clear();
  }

  public getPositionByIndex(index: number): number | undefined {
    if (this.isThumbnailIndex(index)) {
      return index;
    } else {
      return super.getPositionByIndex(this.getMediaIndex(index));
    }
  }

  public getCurrentIndex(): number {
    return super.getCurrentIndex();
  }

  public updateSlidingWindow(dataIndex: number): void {
    if (this.isThumbnailIndex(dataIndex)) {
      Log.debug(TAG, `fast updateSlidingWindow not support index:${dataIndex}`);
    } else {
      super.updateSlidingWindow(this.getMediaIndex(dataIndex));
    }
  }
}