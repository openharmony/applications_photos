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
import lazy { PhotoDataSource } from './PhotoDataSource';
import lazy { MediaItem } from './MediaItem';
import lazy { MediaResult } from './MediaResult';
import lazy { Thumbnail } from './Thumbnail';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { ResultsData } from '../../ResultsData';
import lazy { BroadCast } from '../../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import lazy { BroadCastManager } from '../../common/BroadCastManager';
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from '../../browser/dataObserver/MediaObserverCallback';
import lazy { Constants as PhotoConstants } from './Constants';
import { MediaLibraryData } from './data/MediaData';

import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
/* instrument ignore file */
const MEDIA_ABILITY = 'dataability';
const TAG: string = 'common_UriDataSource';

class InnerMediaItem extends MediaItem {
  isHttp: boolean;

  constructor(uri: string, mediaType: number, width?: number, height?: number) {
    super(undefined);
    this.uri = uri;
    this.width = 0;
    this.imgWidth = 0;
    if (width) {
      this.width = width;
      this.imgWidth = width;
    }
    this.height = 0;
    this.imgHeight = 0;
    if (height) {
      this.height = height;
      this.imgHeight = height;
    }
    this.mediaType = mediaType;
    this.isHttp = !uri.startsWith(MEDIA_ABILITY);
  }
}

// 搜索的dataSource
export class UriDataSource extends PhotoDataSource {
  private mItems: MediaItem[] = [];
  private listeners: DataChangeListener[] = [];
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private currentDeleteIDFunc: Function = (uniqueId: string): void => this.currentDeleteIDChange(uniqueId);
  private mUriArr: string[] = [];

  constructor(stateMachine: PhotoBrowserStateMachine, uriArr: string[], mediaType: number,
    width?: number, height?: number, isAllMediaData?: boolean) {
    super(stateMachine);
    Log.error(TAG, `UriDataSource constructor isAllMediaData : ${isAllMediaData}`);
    this.mUriArr = uriArr;
    if (isAllMediaData) {
      this.requestData();
    } else {
      this.mItems = uriArr.map((uri) => {
        let item = new InnerMediaItem(uri, mediaType, width, height);
        if (uri.startsWith(MEDIA_ABILITY)) {
          item.setThumbnail(this.photoDataImpl.getThumbnail(item.uri, item.path, item.getDateModified(), {
            height: item.height,
            width: item.width,
          }));
        } else {
          item.setThumbnail(item.uri);
        }
        return item;
      });
    }
    Log.debug(TAG, `create items: ${JSON.stringify(this.mItems)}`);
    this.appBroadCast.on(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
  }

  private requestData(): void {
    let fetchColumns: string[] = UserFileManagerAccess.getInstance().getAllFetchColumns();
    UserFileManagerAccess.getInstance()
      .getPhotoAssetByUriArray(this.mUriArr, fetchColumns)
      .then((photoAssets: photoAccessHelper.PhotoAsset[]) => {
        this.mItems = photoAssets.map((photoAsset: photoAccessHelper.PhotoAsset, index: number) => {
          let item: MediaItem = new MediaItem(photoAsset);
          item.setThumbnail(ImageUtil.getLCDUri(item.uri, item.path, item.getDateModified()));
          return item;
        });
        Log.info(TAG, `UriDataSource mediaSource item : ${this.mItems.length}`);
        this.onDataReloaded();
        this.broadCast?.emit(PhotoConstants.DATA_CONTENT_CHANGED, []);
      });
  }

  public initData(): void {
  }

  public totalCount(): number {
    return this.mItems.length;
  }

  public getData(index: number): MediaResult | undefined {
    if (index < 0 || index >= this.mItems.length) {
      Log.error(TAG, `getData, index out of the total size, index: ${index}, total size: ${this.mItems.length}`);
      return undefined;
    }
    let mediaResult: MediaResult;
    if (MediaLibraryData.isMediaLibraryUri(this.mUriArr[index])) {
      let mediaItem: MediaItem = this.mItems[index];
      let path: string = mediaItem.path;
      let mediaResultTemp = this.mediaResultCache.get(path);
      if (mediaResultTemp) {
        mediaResult = mediaResultTemp;
        mediaResult.update(mediaItem);
        mediaResult.setItemThumbnail(new Thumbnail(this.mItems[index].thumbnail));
        mediaResult.setItemPos(index);
      } else {
        mediaResult = new MediaResult(mediaItem);
        mediaResult.setItemThumbnail(new Thumbnail(this.mItems[index].thumbnail));
        mediaResult.setItemPos(index);
        this.mediaResultCache.set(path, mediaResult);
        Log.info(TAG, `Create MediaResult map length = ${this.mediaResultCache.size}`);
      }
    } else {
      mediaResult = new MediaResult(this.mItems[index]);
      mediaResult.setItemPos(index);
      mediaResult.setItemThumbnail(new Thumbnail(this.mItems[index].thumbnail));
    }
    return mediaResult;
  }

  getDataWithoutCache(index: number): MediaResult | undefined {
    return this.getData(index);
  }

  public getRawData(index: number): ResultsData {
    return {
      data: index < this.mItems.length ? this.mItems[index] : new MediaItem(),
      pos: index,
    };
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  private currentDeleteIDChange(uniqueId: string): void {
    Log.info(TAG, `currentDeleteIDChange uniqueId: ${uniqueId}`);

  }

  private deleteItemByUri(uri: string): void {
    Log.info(TAG, `deleteItemByUri uri: ${uri}`);
    let index: number | undefined = this.mItems.findIndex((item: MediaItem) => {
      return item.uri === uri;
    })
    if (index >= 0) {
      this.mUriArr.splice(index, 1);
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [0]);
      this.onSizeLoadingFinished(this.mUriArr.length);
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    Log.info(TAG, `onNotify :  ${JSON.stringify(nfyInfo)}`);
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', false);
    switch (nfyInfo.type) {
      case MediaObserverNfyType.PHOTO_REMOVE: {
        if (nfyInfo.albumUris?.length === 0) {
          nfyInfo.uris?.forEach((uri: string): void => {
            this.deleteItemByUri(uri);
          })
          this.requestData();
        }
        break;
      }
      case MediaObserverNfyType.PHOTO_UPDATE: {
        this.requestData();
        break;
      }
    }
  }

  public onDataReloaded(): void {
    Log.debug(TAG, `onDataReloaded listeners size ${this.listeners.length}`);
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  deleteData(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      Log.info(TAG, 'onDataDeleted');
      listener.onDataDelete(index);
    });
  }

  public async getDataByUri(uri: string): Promise<PhotoAsset> {
    let tmp: PhotoAsset = await this.photoDataImpl.getDataByUri(uri) as PhotoAsset;
    return tmp;
  }

  public getMediaItemByUri(uri: string, itemNotifyCallback: Function): void {
    let mediaItem: MediaItem | undefined = this.mItems.find((item: MediaItem) => {
      return item.uri === uri;
    })
    itemNotifyCallback?.(mediaItem);
  }

  public getItemByUri(uri?: string): MediaItem | undefined {
    let mediaItem: MediaItem | undefined = this.mItems.find((item: MediaItem) => {
      return item.uri === uri;
    })
    return mediaItem;
  }

  public getItemByPath(path: string): MediaItem | undefined {
    let mediaItem: MediaItem | undefined = this.mItems.find((item: MediaItem) => {
      return item.path === path;
    })
    return mediaItem;
  }

  public getDataIndexByUri(uri?: string): number {
    let index: number | undefined = this.mItems.findIndex((item: MediaItem) => {
      return item.uri === uri;
    })
    return index ?? -1;
  }
}