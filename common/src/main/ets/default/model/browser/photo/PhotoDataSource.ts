/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { Log } from '../../../utils/Log';
import { MediaDataSource } from './MediaDataSource';
import type { LoadingListener } from '../LoadingListener';
import { BroadCast } from '../../../utils/BroadCast';
import { Constants as PhotoConstants } from './Constants';
import { MediaItem } from './MediaItem';
import { Constants } from '../../common/Constants';
import { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import { AlbumDefine } from '../AlbumDefine';
import { BroadCastConstants } from '../../common/BroadCastConstants';
import { BroadCastManager } from '../../common/BroadCastManager';
import { ImageUtil } from '../../../utils/ImageUtil';
import { ScreenManager } from '../../common/ScreenManager';

import display from '@ohos.display';
import { FileAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

const TAG: string = 'common_PhotoDataSource';

// DataSource
export class PhotoDataSource implements IDataSource, LoadingListener {
  static readonly MEIDA_URL_PREFIX_STR = 'datashare:///media/';
  static readonly ALBUM_URL_PREFIX_STR = 'datashare:///media/album/';
  static readonly IMAGE_URL_PREFIX_STR = 'datashare:///media/image/';
  static readonly VIDEO_URL_PREFIX_STR = 'datashare:///media/video/';
  static readonly IMAGE_URL_PREFIX_STR_V10 = 'file://media/image/';
  static readonly VIDEO_URL_PREFIX_STR_V10 = 'file://media/video/';
  static readonly MEIDA_URL_PREFIX_STR_V10 = 'file://media/';
  static readonly ALBUM_URL_PREFIX_STR_V10 = 'file://media/PhotoAlbum/';
  static readonly IMAGE_VIDEO_URL_PREFIX_STR_V10 = 'file://media/Photo/';

  static readonly IMAGE_TYPE_PREFIX_STR = 'image/';
  static readonly VIDEO_TYPE_PREFIX_STR = 'video/';
  // Data change listener
  albumUri: string = undefined;
  protected photoDataImpl;
  private lastTotalCount = -1;
  private albumDataSource: MediaDataSource;
  private broadCast: BroadCast;
  private currentIndex = 0;
  private deviceId: string = ''
  private enableGetDataFlag: boolean = true;

  constructor(albumUri?: string) {
    Log.debug(TAG, 'bind onMessage');
    if (albumUri) {
      this.albumUri = albumUri;
    }

    this.photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
  }

  totalCount(): number {
    let newTotalCount = 0;
    if (this.albumDataSource) {
      newTotalCount = this.albumDataSource.mediaCount;
      if (this.lastTotalCount != newTotalCount) {
        Log.info(TAG, `totalCount: ${newTotalCount}`);
        this.lastTotalCount = newTotalCount;
      }
      if (newTotalCount > 0 && !this.albumDataSource.getFirstRawData()) {
        return 0;
      }
    }
    return newTotalCount || 0;
  }

  realTotalCount(): number {
    let totalCount = 0;
    if (this.albumDataSource) {
      totalCount = this.albumDataSource.realTotalCount();
      Log.debug(TAG, `realTotalCount: ${totalCount}`);
      return totalCount;
    }
    return 0;
  }

  // get DataIndex with item
  getDataIndex(item: MediaItem): number {
    return this.albumDataSource.getDataIndex(item);
  }

  resetAlbumUri(albumUri: string) {
    this.albumUri = albumUri;
    if (this.albumDataSource) {
      this.albumDataSource.setAlbumUri(this.albumUri);
      this.albumDataSource.resetActiveWindow();
      this.albumDataSource.initData();
      this.albumDataSource.forceUpdate();
    }
  }

  setAlbumUri(albumUri: string) {
    this.albumUri = albumUri;
  }

  getAlbumUri(): string {
    return this.albumUri;
  }

  setDeviceId(deviceId: string) {
    this.deviceId = deviceId;
  }

  releaseCache(key: string): void {
  }

  getItemIndexByUri(uri: string, indexNotifyCallback: Function): void {
    Log.info(TAG, `getItemIndexByUri, ${uri}`);
    this.albumDataSource.getItemIndexByUri(uri, indexNotifyCallback);
  }

  initData() {
    let dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
    dataSource.setAlbumUri(this.albumUri);
    dataSource.initData();
    this.setAlbumDataSource(dataSource);
  }

  enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
    if (this.albumDataSource) {
      this.albumDataSource.enableGetData(flag);
    }
  }

  // LazyForEach call
  getData(index: number): any {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    Log.info(TAG, `getData index ${index}`);
     if (this.albumDataSource) {
       this.albumDataSource.updateSlidingWindow(index);
       let mediaItem: MediaItem = this.albumDataSource.getRawData(index);
       return this.packData(index, mediaItem);
     }
    return undefined;
  }

  packData(index: number, mediaItem: MediaItem) {
    if (!mediaItem) {
      Log.error(TAG, `Get item undefined, index: ${index}`);
      return undefined;
    }
    if (mediaItem.height == 0 || mediaItem.width == 0) {
      this.getDataByUri(mediaItem.uri).then((result) => {
        mediaItem = new MediaItem(result);
        if (mediaItem.height == 0 || mediaItem.width == 0) {
          return;
        }
        let index = this.albumDataSource?.getIndexByMediaItem(mediaItem) ?? -1;
        if (index != -1) {
          this.albumDataSource?.onDataChanged(index);
        }
        this.onDataChanged(index);
      })
    }
    let imgWidth = mediaItem.width;
    let imgHeight = mediaItem.height;
    let scale = this.convertDecodeSize(mediaItem.width, mediaItem.height);
    Log.debug(TAG, `packData imgWidth: ${imgWidth} imgHeight: ${imgHeight} scale: ${scale}`);
    if (scale != 0) {
      const NEAR_PIX: number = 0.01;
      mediaItem.imgWidth = Math.floor(mediaItem.width * scale);
      mediaItem.imgHeight = Math.floor(mediaItem.height * scale);
      imgWidth = Math.floor(imgWidth * scale + NEAR_PIX);
      imgHeight = Math.floor(imgHeight * scale + NEAR_PIX);
    }
    Log.debug(TAG, `packData imgWidth: ${imgWidth} imgHeight: ${imgHeight}}`);

    return {
      data: mediaItem,
      pos: index,
      thumbnail: this.photoDataImpl.getThumbnail(mediaItem.uri, mediaItem.path, { height: imgHeight, width: imgWidth })
    };
  }

  updatePixMapDataSource(index: number): void {
    this.currentIndex = index;
    // cache load.
  }

  getRawData(index: number): any {
    if (this.albumDataSource) {
      return {
        data: this.albumDataSource.getRawData(index),
        pos: index
      };
    }

    Log.warn(TAG, `albumDataSource is undefined for index:${index}`);

    return {
      data: null,
      pos: index
    };
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.albumDataSource) {
      this.albumDataSource.registerObserver();
      if (this.albumDataSource.listeners.indexOf(listener) < 0) {
        this.albumDataSource.listeners.push(listener);
      }
      Log.debug(TAG, `listener size: ${this.albumDataSource.listeners.length}`);
    }

  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    if (this.albumDataSource) {
      const pos = this.albumDataSource.listeners.indexOf(listener);
      if (pos >= 0) {
        this.albumDataSource.listeners.splice(pos, 1);
      }
      Log.debug(TAG, `unregisterDataChangeListener listener size: ${this.albumDataSource.listeners.length}`);
    }
  }

  setAlbumDataSource(albumDataSource: MediaDataSource): void {
    Log.debug(TAG, 'setAlbumDataSource');
    if (!albumDataSource) {
      Log.error(TAG, 'dataSource undefined');
    }
    this.albumDataSource = albumDataSource;
    this.albumDataSource.addLoadingListener(this);
  }

  getAlbumDataSource(): MediaDataSource | undefined {
    if (this.albumDataSource) {
      return this.albumDataSource;
    }
    return undefined;
  }

  setBroadCast(broadCastParam: BroadCast): void {
    this.broadCast = broadCastParam;
  }

  setBroadCastToAlbum(broadCastParam: BroadCast) {
    if (this.albumDataSource) {
      this.albumDataSource.setPhotoBroadCast(broadCastParam);
    }
  }

  onDataReloaded() {
    Log.info(TAG, `onDataReloaded start`);
    if (this.albumDataSource) {
      this.albumDataSource.onDataReloaded();
    }
  }

  onSizeLoadingFinished(size: number): void {
    Log.info(TAG, `onSizeLoadingFinished, current size: ${size}`);
    this.broadCast?.emit(PhotoConstants.DATA_SIZE_CHANGED, [size]);
  }

  onDataLoadingFinished(): void {
    // after the mediaLib updates the data, it directly calls onDataReloaded.
    // swiper updates only the five mounted items
    Log.debug(TAG, `onDataLoadingFinished listeners size: ${this.albumDataSource.listeners.length}\
            totalCount: ${this.totalCount()}`);
    this.broadCast?.emit(PhotoConstants.DATA_CONTENT_CHANGED, []);
  }

  onDataChanged(dataIndex: number): void {
    if (this.albumDataSource) {
      this.albumDataSource.listeners.forEach(listener => {
        listener.onDataChanged(dataIndex);
      })
    }
  }

  deleteData(index: number) {
    if (this.albumDataSource) {
      this.albumDataSource.listeners.forEach(listener => {
        Log.debug(TAG, 'onDataDeleted');
        listener.onDataDeleted(index);
      })
    }
  }

  async getDataByUri(uri: string): Promise<FileAsset> {
    let tmp: FileAsset = await this.photoDataImpl.getDataByUri(uri) as FileAsset;
    return tmp;
  }

  getItemByUri(uri: string): any {
    if (this.albumDataSource) {
      return this.albumDataSource.getItemByUri(uri);
    }
    return null;
  }

  getDataIndexByUri(uri: string): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getDataIndexByUri(uri);
    }
    return Constants.NOT_FOUND;
  }
  // Search for the index of first valid item in MediaDataSource
  getValidStartIndex(): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getValidStartIndex();
    }
    return Constants.NOT_FOUND;
  }
  // Search for the index of last valid item in MediaDataSource
  getValidEndIndex(): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getValidEndIndex();
    }
    return Constants.NOT_FOUND;
  }

  public release(): void {
    if (this.albumDataSource) {
      this.albumDataSource.releasePhotoBroadCast();
      this.albumDataSource.removeLoadingListener(this);
      // cancel the mediaLibrary listening of albumDataSource when the large image is destroyed.
      // cannot cancel it in unregisterDataChangeListener
      this.albumDataSource && this.albumDataSource.unregisterObserver();
    }

    this.broadCast = null;
  }

  getPositionByIndex(index: number): number {
    if (this.albumDataSource) {
      return this.albumDataSource.getPositionByIndex(index);
    }
  }

  onChange(changeType) {
    if (this.albumDataSource) {
      this.albumDataSource.onActive();
      this.albumDataSource.onChange(changeType);
    }
  }

  switchRefreshOn() {
    if (this.albumDataSource) {
      this.albumDataSource.switchRefreshOn();
    }
  };

  private convertDecodeSize(imageWidth: number, imageHeight: number): number {
    const HOLD_SCALE: number = 1.0;
    if (imageWidth <= 0 || imageHeight <= 0) {
      return HOLD_SCALE;
    }
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let screenWidth: number = displayClass.width;
    let screenHeight: number = displayClass.height;
    if (screenWidth <= 0 || screenHeight <= 0) {
      return HOLD_SCALE;
    }
    let scale = HOLD_SCALE;
    let desiredScale = screenHeight / screenWidth;
    let sourceScale = imageHeight / imageWidth;

    if (sourceScale > desiredScale) {
      scale = screenHeight / imageHeight;
    } else {
      scale = screenWidth / imageWidth;
    }
    return scale < HOLD_SCALE ? scale : HOLD_SCALE;
  }

  private generateSampleSize(imageWidth: number, imageHeight: number, index: number): number {
    let width = vp2px(ScreenManager.getInstance().getWinWidth());
    let height = vp2px(ScreenManager.getInstance().getWinHeight());
    width = width == 0 ? ScreenManager.DEFAULT_WIDTH : width;
    height = height == 0 ? ScreenManager.DEFAULT_HEIGHT : height;
    let maxNumOfPixels
    if (this.currentIndex == index) {
      maxNumOfPixels = 2 * width * height;
    } else {
      maxNumOfPixels = width * height;
    }
    let minSide = Math.min(width, height);
    return ImageUtil.computeSampleSize(imageWidth, imageHeight, minSide, maxNumOfPixels);
  }
}