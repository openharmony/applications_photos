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
/* instrument ignore file*/
import lazy { Log } from '../../../utils/Log';
import lazy { MediaDataSource } from './MediaDataSource';
import lazy { MediaItem } from './MediaItem';
import lazy { Constants } from '../../common/Constants';

import lazy { PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { ResultsData } from '../../ResultsData';
import lazy { MediaResult } from './MediaResult';
import lazy { Thumbnail } from './Thumbnail';
import lazy { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { ImageSizeUtil } from './ImageSizeUtil';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import type { PhotoDataImpl } from './PhotoDataImpl';
import { PhotoDataSource } from './PhotoDataSource';

const TAG: string = 'common_ThumbDataSource';
const smallImgLow: number = (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 20 : 18;
const smallImgHeight: number = (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 40 : 36;

// DataSource
export class ThumbDataSource extends PhotoDataSource {
  private photoDataSource: PhotoDataSource;
  private mediaResultMap: Map<string, MediaResult> = new Map<string, MediaResult>();

  constructor(stateMachine: PhotoBrowserStateMachine, albumUri?: string, photoDataImpl?: PhotoDataImpl) {
    super(stateMachine, albumUri, photoDataImpl);
    this.photoDataSource = new PhotoDataSource(this.stateMachine);
  }

  setPhotoDataSource(photoDataSource?: PhotoDataSource): void {
    /* instrument ignore else*/
    if (photoDataSource) {
      this.photoDataSource = photoDataSource;
    } else {
      this.photoDataSource = new PhotoDataSource(this.stateMachine);
    }
  }

  totalCount(): number {
    return this.photoDataSource.totalCount();
  }

  // LazyForEach call
  getData(index: number): MediaResult | undefined {
    let result: ResultsData = this.photoDataSource.getRawData(index) as ResultsData;
    let mediaItem: MediaItem = result?.data as MediaItem;
    /* instrument ignore if*/
    if (mediaItem === undefined) {
      Log.info(TAG, `get empty data index: ${index}`);
      return undefined;
    }
    let uri: string = mediaItem.path;
    let mediaResult: MediaResult;
    if (this.mediaResultMap.has(uri)) {
      mediaResult = this.mediaResultMap.get(uri) ?? new MediaResult(mediaItem);
      /* instrument ignore if*/
      if (mediaResult.dateModified !== mediaItem.getDateModified?.() || mediaResult.path != mediaItem.path) {
        mediaResult.setItemThumbnail(new Thumbnail(
          this.photoDataImpl.getThumbnail(mediaItem.uri, mediaItem.path, mediaItem.getDateModified?.(),
            ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, false))));
      }
      mediaResult.update(mediaItem);
      mediaResult.setItemPos(result.pos);
      this.mediaResultMap.set(uri, mediaResult);
      this.updateDataSourceMarginAndWidth(index, mediaResult, mediaItem);
    } else {
      mediaResult = new MediaResult(mediaItem);
      mediaResult.setItemThumbnail(new Thumbnail(
        this.photoDataImpl.getThumbnail(mediaItem.uri, mediaItem.path, mediaItem.getDateModified?.(),
          ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, false))));
      mediaResult.setItemPos(result.pos);
      this.updateDataSourceMarginAndWidth(index, mediaResult, mediaItem);
      this.mediaResultMap.set(uri, mediaResult);
    }
    Log.debug(TAG, `getData, index: ${index}, uri: ${uri}, displayName: ${mediaItem.displayName}`);
    return mediaResult;
  }

  private updateDataSourceMarginAndWidth(index: number, mediaResult: MediaResult, mediaItem: MediaItem): void {
    if (index != this.getCurrentIndex()) {
      mediaResult.itemMargin = {
        left: 0,
        right: 0,
        top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
        bottom: 0,
      };
      mediaResult.itemWidth = smallImgLow;
    } else {
      mediaResult.itemMargin = {
        left: Constants.LIST_MID_ITEM_MARGIN,
        right: Constants.LIST_MID_ITEM_MARGIN,
        top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
        bottom: 0,
      };
      let ratio = ImageSizeUtil.getImageRatio(mediaItem.height, mediaItem.width);
      mediaResult.itemWidth = smallImgHeight * ratio;
    }
  }

  /* instrument ignore next */
  realTotalCount(): number {
    return this.photoDataSource.realTotalCount();
  }

  // get DataIndex with item
  /* instrument ignore next */
  getDataIndex(item: MediaItem): number {
    return this.photoDataSource.getDataIndex(item);
  }

  /* instrument ignore next */
  resetAlbumUri(albumUri: string): void {
    return this.photoDataSource.resetAlbumUri(albumUri);
  }

  /* instrument ignore next */
  setAlbumUri(albumUri: string): void {
    return this.photoDataSource.setAlbumUri(albumUri);
  }

  /* instrument ignore next */
  getAlbumUri(): string {
    return this.photoDataSource.getAlbumUri();
  }

  /* instrument ignore next */
  setDeviceId(deviceId: string): void {
    this.photoDataSource.setDeviceId(deviceId);
  }

  /* instrument ignore next */
  releaseCache(key: string): void {
    this.photoDataSource.releaseCache(key);
  }

  /* instrument ignore next */
  getItemIndexByUri(uri: string, indexNotifyCallback: (index: number) => void): void {
    this.photoDataSource.getItemIndexByUri(uri, indexNotifyCallback);
  }

  /* instrument ignore next */
  initData(): void {
    this.photoDataSource.initData();
  }

  /* instrument ignore next */
  enableGetData(flag: boolean): void {
    this.photoDataSource.enableGetData(flag);
  }

  /* instrument ignore next */
  packData(index: number, mediaItem?: MediaItem): MediaResult | undefined {
    return this.photoDataSource.packData(index, mediaItem);
  }

  updatePixMapDataSource(index: number): void {
    return this.photoDataSource.updatePixMapDataSource(index, false);
  }

  getRawData(index: number): ResultsData {
    return this.photoDataSource.getRawData(index);
  }

  /* instrument ignore next */
  registerDataChangeListener(listener: DataChangeListener): void {
    return this.photoDataSource.registerDataChangeListener(listener);
  }

  /* instrument ignore next */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    return this.photoDataSource.unregisterDataChangeListener(listener);
  }

  /* instrument ignore next */
  setAlbumDataSource(albumDataSource: MediaDataSource): void {
    return this.photoDataSource.setAlbumDataSource(albumDataSource);
  }

  /* instrument ignore next */
  getAlbumDataSource(): MediaDataSource | undefined {
    return this.photoDataSource.getAlbumDataSource();
  }

  /* instrument ignore next */
  onDataReloaded(): void {
    this.photoDataSource.onDataReloaded();
  }

  /* instrument ignore next */
  onSizeLoadingFinished(size: number): void {
    this.photoDataSource.onSizeLoadingFinished(size);
  }

  /* instrument ignore next */
  onDataLoadingFinished(): void {
    this.photoDataSource.onDataLoadingFinished();
  }

  /* instrument ignore next */
  onDataChanged(dataIndex: number): void {
    this.photoDataSource.onDataChanged(dataIndex);
  }

  /* instrument ignore next */
  deleteData(index: number): void {
    this.photoDataSource.deleteData(index);
  }

  /* instrument ignore next */
  public async getDataByUri(uri: string): Promise<PhotoAsset> {
    return this.photoDataSource.getDataByUri(uri);
  }

  /* instrument ignore next */
  getMediaItemByUri(uri: string, itemNotifyCallback: Function): void {
    return this.photoDataSource.getMediaItemByUri(uri, itemNotifyCallback);
  }

  /* instrument ignore next */
  getItemByUri(uri?: string): MediaItem | undefined {
    return this.photoDataSource.getItemByUri(uri);
  }

  /* instrument ignore next */
  getItemByPath(path: string): MediaItem | undefined {
    return this.photoDataSource.getItemByPath(path);
  }

  /* instrument ignore next */
  getDataIndexByUri(uri?: string): number {
    return this.photoDataSource.getDataIndexByUri(uri);
  }

  // Search for the index of first valid item in MediaDataSource
  getValidStartIndex(): number {
    return this.photoDataSource.getValidStartIndex();
  }

  // Search for the index of last valid item in MediaDataSource
  /* instrument ignore next */
  getValidEndIndex(): number {
    return this.photoDataSource.getValidEndIndex();
  }

  /* instrument ignore next */
  public release(): void {
    this.photoDataSource.release();
  }

  /* instrument ignore next */
  getPositionByIndex(index: number): number | undefined {
    return this.photoDataSource.getPositionByIndex(index);
  }

  /* instrument ignore next */
  onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    return this.photoDataSource.onNotify(nfyInfo, isForceUpdate);
  }

  onChange(changeType: string, isForceUpdate?: boolean): void {
    return this.photoDataSource.onChange(changeType, isForceUpdate);
  }

  /* instrument ignore next */
  switchRefreshOn(): void {
    return this.photoDataSource.switchRefreshOn();
  };

  /* instrument ignore next */
  getCurrentIndex(): number {
    return this.photoDataSource.getCurrentIndex();
  }

  /* instrument ignore next */
  updateIndexWidthMargin(index1: number,
    shrinkFactor1: number, isTouching1: boolean, startIndex1: number, percent1: number) {
    let index: number = index1;
    let shrinkFactor: number = shrinkFactor1;
    let isTouching: boolean = isTouching1;
    let startIndex: number = startIndex1;
    let percent: number = percent1;
    this.genMargin(index, shrinkFactor, isTouching, startIndex, percent);
    this.genWidth(index, shrinkFactor, isTouching, startIndex, percent);
  }

  /* instrument ignore next */
  private genMargin(centerIndex: number,
    shrinkFactor: number, isTouching: boolean, startIndex: number, percent: number) {
    TraceControllerUtils.startTrace('genMarginStyle');
    this.mediaResultMap.forEach((value, key) => {
      let ret: number = 0;
      let pos = value.pos;
      if (pos != undefined) {
        if ((centerIndex < pos - 1 || centerIndex > pos + 1) && value?.itemMargin?.left === 0) {
          return;
        }
        if (isTouching) {
          if (startIndex === pos + 1) { // 右侧item
            ret = Constants.LIST_MID_ITEM_MARGIN * Math.max(0, percent);
          } else if (startIndex === pos - 1) { // 左侧item
            ret = Constants.LIST_MID_ITEM_MARGIN * Math.max(0, 0 - percent);
          } else if (startIndex === pos) {
            ret = Constants.LIST_MID_ITEM_MARGIN * shrinkFactor * (1 - Math.abs(percent)); // 1 -> 0
          }
        } else if (shrinkFactor === 1 && centerIndex === pos) { // shrinkFactor等于1为停止态，当前图片需设置margin
          Log.info(TAG, `genMargin pos ${pos}`);
          ret = Constants.LIST_MID_ITEM_MARGIN;
        }
        if (!value.itemMargin || value.itemMargin.left !== ret) {
          value.itemMargin = {
            left: ret,
            right: ret,
            top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
            bottom: 0,
          };
        }
      }
    })
    TraceControllerUtils.finishTrace('genMarginStyle');
  }

  /* instrument ignore next */
  private genWidth(centerIndex: number,
    shrinkFactor: number, isTouching: boolean, startIndex: number, percent: number) {
    this.mediaResultMap.forEach((value, key) => {
      let pos = value.pos;
      if (pos != undefined && value.item) {
        if ((centerIndex - 1 > pos || centerIndex + 1 < pos) && value?.itemWidth === smallImgLow) {
          return;
        }
        let ratio = ImageSizeUtil.getImageRatio(value.item.height, value.item.width);
        if (!isTouching) {
          if (shrinkFactor === 1 && centerIndex === pos) { // shrinkFactor等于1为停止态，当前图片需放大
            // 36 ~ 72 dynamic change
            Log.info(TAG, `stop width ${smallImgHeight * ratio}`);
            value.itemWidth = smallImgHeight * ratio;
            return;
          } else {
            value.itemWidth = smallImgLow;
            return;
          }
        }
        if (startIndex === pos + 1) { // 左侧item
          const mediaItem = this.photoDataSource?.getRawData(startIndex).data;
          // 1 -> 2  y = kx + b    x = 1 y = 18 x = 2 y = 36r
          const leftRight = ImageSizeUtil.getImageHeightWidthRatio(mediaItem);
          const k = smallImgHeight * leftRight - smallImgLow;
          const b = smallImgHeight - smallImgHeight * leftRight;
          // judge current width whether or not bigger than source size
          const threshold = k * Math.max(1, 1 + percent) + b;
          if (threshold > smallImgHeight * ratio) {
            value.itemWidth = smallImgHeight * ratio;
            return;
          } else {
            value.itemWidth = threshold;
            return;
          }
        }
        if (startIndex === pos - 1) { // 右侧item
          const mediaItem = this.photoDataSource?.getRawData(startIndex).data;
          const leftRight = ImageSizeUtil.getImageHeightWidthRatio(mediaItem);
          const k = smallImgHeight * leftRight - smallImgLow;
          const b = smallImgHeight - smallImgHeight * leftRight;
          const threshold = k * Math.max(1, 1 - percent) + b;
          // judge current width whether or not bigger than source size
          if (threshold > smallImgHeight * ratio) {
            value.itemWidth = smallImgHeight * ratio;
            return;
          }
          value.itemWidth = threshold;
          return;
        }
        if (startIndex === pos) {
          let k = smallImgHeight * ratio - smallImgLow;
          let b = smallImgHeight - smallImgHeight * ratio;
          Log.info(TAG, `current image width ${k * Math.max(1, 1 + percent) + b} precent ${percent}`);
          value.itemWidth = k * (2 - Math.abs(percent)) + b;
          return;
        }
      }
    });
  }

  /* instrument ignore next */
  getCurrentSmallImgWidth(): number | undefined {
    let index = this.getCurrentIndex();
    let ret: number | undefined = undefined;
    this.mediaResultMap.forEach((value, key) => {
      if (value.pos === index) {
        ret = value.itemWidth;
      }
    });
    return ret;
  }

  /* instrument ignore next */
  setCurrentSmallImgWidth(width: number): void {
    let index = this.getCurrentIndex();
    this.mediaResultMap.forEach((value, key) => {
      if (value.pos === index) {
        value.itemWidth = width;
      }
    });
  }

  /* instrument ignore next */
  addCurrentSmallImgMargin(addedMargin: number): void {
    let index = this.getCurrentIndex();
    this.mediaResultMap.forEach((value, key) => {
      if (value.pos === index) {
        let originMargin = value.itemMargin?.left;
        if (originMargin !== undefined) {
          value.itemMargin = {
            left: originMargin + addedMargin,
            right: originMargin + addedMargin,
            top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
            bottom: 0,
          };
        }
      }
    });
  }

  /**
   * 预览条数据源区间更新
   */
  /* instrument ignore next */
  thumbSourcePartGetData(currentIndex: number, dataIndex: number): void {
    let largerIndex: number = (currentIndex > dataIndex ? currentIndex : dataIndex);
    let partStep: number = Math.abs(currentIndex - dataIndex);
    for (let i = largerIndex + 1; i <= largerIndex + partStep; i++) {
      this.getData(i);
    }
    Log.info(TAG, `thumbsource part index: ${largerIndex + 1}-${largerIndex + partStep} update Complete`);
  }

  /**
   * 删除后全量更新mediaResultMap，防止后续移动导致index图片不在map中
   * 取出删除后当前map的始末index，index更新
   */
  /* instrument ignore next */
  updateMapAfterDataDelete(): void {
    let startIndex: number = Number.MAX_VALUE;
    let endIndex: number = -1;
    this.mediaResultMap.forEach((value, key) => {
      let pos: number | undefined = value.pos;
      if (pos === undefined) {
        Log.error(TAG, 'thumbsource mapData pos not exist!');
        return;
      }
      if (pos < startIndex) {
        startIndex = pos;
      }
      if (pos > endIndex) {
        endIndex = pos;
      }
    })
    if (startIndex === Number.MAX_VALUE || endIndex === -1) {
      Log.error(TAG, 'after photo delete resultMap not update');
      return;
    }

    Log.info(TAG, `updateMapAfterDataDelete startIndex: ${startIndex} endIndex: ${endIndex}`);

    for (let index = startIndex; index <= endIndex; index++) {
      this.onDataChanged(index);
    }
    Log.info(TAG, 'finish updateMapAfterDataDelete');
  }

  /* instrument ignore next */
  indexMediaItemSave(index: number): void {
    let result: ResultsData = this.photoDataSource.getRawData(index) as ResultsData;
    let mediaItem: MediaItem = result?.data as MediaItem;
    if (mediaItem === undefined) {
      Log.info(TAG, `updateMapAfterDataDelete get empty data index: ${index}`);
      return undefined;
    }
    let uri: string = mediaItem.path;
    let mediaResult: MediaResult;
    mediaResult = this.mediaResultMap.get(uri) ?? new MediaResult(mediaItem);
    if (mediaResult.dateModified !== mediaItem.getDateModified() || mediaResult.path != mediaItem.path) {
      mediaResult.setItemThumbnail(new Thumbnail(
        this.photoDataImpl.getThumbnail(mediaItem.uri, mediaItem.path, mediaItem.getDateModified?.(),
          ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, false))));
    }
    mediaResult.update(mediaItem);
    mediaResult.setItemPos(result.pos);
    this.mediaResultMap.set(uri, mediaResult);
  }

  mapDeleteData(path: string): void {
    if (!this.mediaResultMap.has(path)) {
      Log.error(TAG, `thumbsource delete data fail, ${path} not exists`);
      return;
    }
    this.mediaResultMap.delete(path);
    Log.info(TAG, `thumbsource delete data:${path} success`);
  }
}