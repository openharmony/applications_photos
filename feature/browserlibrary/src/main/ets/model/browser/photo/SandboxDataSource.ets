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

import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { PhotoData, SandboxObjectImpl } from './SandboxObjectImpl';
import lazy { FastPhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/FastPhotoDataSource';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';

const MEDIA_ABILITY = 'dataability';
const TAG: string = 'common_SandboxDataSource';

interface Params {
  data: MediaItem,
  pos: number,
};

class InnerMediaItem extends MediaItem {
  constructor(photoData: PhotoData) {
    super(undefined);

    if (!photoData) {
      return;
    }
    this.mediaType = photoData.mediaType ?? Number.NaN;
    this.displayName = photoData.displayName ?? '';
    this.setTitle(photoData.title);
    this.setDateAdded(photoData.dateTaken);
    if (this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.duration = photoData.duration ?? Number.NaN;
    }
    this.size = photoData.size ?? Number.NaN;
    this.width = photoData.width ?? Number.NaN;
    this.height = photoData.height ?? Number.NaN;
    this.coverWidth = this.width;
    this.coverHeight = this.height;
    this.imgOriginWidth = this.width;
    this.imgOriginHeight = this.height;

    this.uri = photoData.uri ?? '';
    this.imgWidth = this.width;
    this.imgHeight = this.height;
    this.path = photoData.path ?? this.uri;
    this.hashCode = `${this.uri}????${this.size}????${this.orientation}`;
    this.isResourceLoading = photoData.isResourceLoading;
  }
}

export class SandboxDataSource extends FastPhotoDataSource {
  private mItems: MediaItem[] = [];
  private listeners: DataChangeListener[] = [];
  private hasInit: boolean = false;

  setData(sandboxInfo: SandboxObjectImpl[]): void {
    Log.info(TAG,
      `photoData.width:${sandboxInfo[0]?.photoData?.width},photoData.height:${sandboxInfo[0]?.photoData?.height}`);
    this.mItems = sandboxInfo.map((data): MediaItem => {
      let item: MediaItem;
      if (!data.photoData) {
        item = new MediaItem(data.fileAsset);
      } else {
        item = new InnerMediaItem(data.photoData);
      }

      if (data.isMediaSource && item.path) {
        item.setThumbnail(this.photoDataImpl.getThumbnail(item.uri, item.path, item.getDateModified(), {
          height: item.height,
          width: item.width,
        }));
      } else {
        item.setThumbnail(data.photoData?.thumbnail ? data.photoData?.thumbnail : item.uri);
      }
      return item;
    });
    if (this.hasInit) {
      this.onDataReloaded();
    } else {
      this.hasInit = true;
    }
    Log.info(TAG, `create items: ${JSON.stringify(this.mItems)}`);
  }

  initData(): void {
  }

  totalCount(): number {
    return this.mItems?.length;
  }

  getData(index: number): MediaResult | undefined {
    if (index < 0 || index >= this.mItems?.length) {
      Log.error(TAG, `getData, index out of the total size, index: ${index}, total size: ${this.mItems.length}`);
      return undefined;
    }

    let mediaItem: MediaItem = this.mItems[index];
    if (!mediaItem) {
      Log.error(TAG, `Get item undefined, index: ${index}`);
      return undefined;
    }
    let path: string = mediaItem.path;
    let mediaResult: MediaResult | undefined = this.mediaResultCache.get(path);
    let thumbnail: Thumbnail = new Thumbnail(this.mItems[index].thumbnail);
    if (mediaResult) {
      Log.info(TAG, `Update MediaResult ${path}`);
      mediaResult.update(mediaItem);
      mediaResult.setItemThumbnail(thumbnail);
      mediaResult.setItemPos(index);
    } else {
      mediaResult = new MediaResult(mediaItem);
      mediaResult.setItemThumbnail(thumbnail);
      mediaResult.setItemPos(index);
      this.mediaResultCache.set(path, mediaResult);
      Log.info(TAG, `Create MediaResult ${path} and map length = ${this.mediaResultCache.size}`);
    }
    return mediaResult;
  }

  getDataWithoutCache(index: number): MediaResult | undefined {
    return this.getData(index);
  }

  getRawData(index: number): Params {
    return {
      data: index < this.mItems?.length ? this.mItems[index] : new MediaItem(),
      pos: index,
    };
  }

  getItemIndexByUri(uri: string, indexNotifyCallback: Function): void {
    Log.info(TAG, `getItemIndexByUri, ${uri}`);
    let index: number = this.mItems?.findIndex(item => uri === item?.uri);
    indexNotifyCallback(index);
  }

  getDataIndexByUri(uri?: string): number {
    Log.info(TAG, `getDataIndexByUri, ${uri}`);
    let index: number = this.mItems?.findIndex(item => uri === item?.uri);
    return index;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  onChange(changeType: string, isForceUpdate?: boolean): void {
    this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [0]);
  }

  onDataReloaded(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  deleteData(index: number): void {
    this.mItems.splice(index, 1);
    this.listeners.forEach((listener: DataChangeListener): void => {
      Log.debug(TAG, 'onDataDeleted');
      listener.onDataDelete(index);
    });
  }

  updateCurrent(index: number): void {
    this.stateMachine?.setCurrentIndex(index);
  }
}

