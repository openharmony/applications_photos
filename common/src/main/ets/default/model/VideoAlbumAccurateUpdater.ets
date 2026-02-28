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
import lazy { Log } from '../utils/Log';
import lazy { AlbumAccurateUpdater, OrderStrategy } from './AlbumAccurateUpdater';
import lazy { CachedData } from './AccurateUpdaterUtils';
import lazy { PhotoAssetChangeInfo, PhotoAssetChangeData } from './browser/dataObserver/MediaObserver';
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG: string = 'VideoUpdater';

export class VideoAlbumAccurateUpdater extends AlbumAccurateUpdater {
  protected _tag: string = 'VideoUpdater';

  public handleAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.mediaType !== photoAccessHelper.PhotoType.VIDEO) {
      Log.info(TAG, 'mediaType is not VIDEO, return.');
      return;
    }
    this.handlePhotoAdd(info, cachedData, orderStrategy);
  }

  public handleRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.mediaType !== photoAccessHelper.PhotoType.VIDEO) {
      Log.info(TAG, 'mediaType is not VIDEO, return.');
      return;
    }
    this.handlePhotoRemove(info, cachedData, orderStrategy);
  }

  public handleUpdate(changeData: PhotoAssetChangeData, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (changeData.assetAfterChange === null) {
      return;
    }
    if (changeData.assetAfterChange?.mediaType !== photoAccessHelper.PhotoType.VIDEO) {
      Log.info(TAG, 'handleVideoUpdate mediaType is not VIDEO, return.');
      return;
    }
    this.handlePhotoUpdate(changeData.assetAfterChange, cachedData, orderStrategy);
  }
}