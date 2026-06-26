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
/* instrument ignore file */
import lazy { Log } from '../utils/Log';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy { AlbumAccurateUpdater, OrderStrategy, DataTakenOrderStrategy } from './AlbumAccurateUpdater';
import lazy { CachedData } from './AccurateUpdaterUtils';
import lazy { PhotoAssetChangeInfo, PhotoAssetChangeData } from './browser/dataObserver/MediaObserver';

const TAG: string = 'TimelineUpdater';

export class TimelineAccurateUpdater extends AlbumAccurateUpdater {
  protected _tag: string = 'TimelineAccurateUpdater';

  public handleAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.thumbnailVisible !== 1 && ImageUtil.isThumbnailReady()) {
      Log.info(TAG, '[accurateNotify] thumbnailVisible is not ready, return.');
      return;
    }
    this.handlePhotoAdd(info, cachedData, orderStrategy);
  }

  public handleRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.thumbnailVisible !== 1 && ImageUtil.isThumbnailReady()) {
      Log.info(TAG, '[accurateNotify] thumbnailVisible is not ready, return.');
      return;
    }
    this.handlePhotoRemove(info, cachedData, orderStrategy);
  }

  public handleUpdate(changeData: PhotoAssetChangeData, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    let isVisibleBefore: boolean = changeData.assetBeforeChange?.thumbnailVisible === 1;
    let isVisibleAfter: boolean = changeData.assetAfterChange?.thumbnailVisible === 1;
    if (ImageUtil.isThumbnailReady() && !isVisibleBefore && isVisibleAfter && changeData.assetAfterChange !== null) {
      Log.info(TAG, '[accurateNotify] handleUpdate as handlePhotoAdd');
      this.handlePhotoAdd(changeData.assetAfterChange, cachedData, orderStrategy);
    } else if (ImageUtil.isThumbnailReady() && isVisibleBefore && !isVisibleAfter &&
      changeData.assetBeforeChange !== null) {
      Log.info(TAG, '[accurateNotify] handleUpdate as handlePhotoRemove');
      this.handlePhotoRemove(changeData.assetBeforeChange, cachedData, orderStrategy);
    } else if (changeData.assetAfterChange !== null) {
      Log.info(TAG, '[accurateNotify] handleUpdate as handlePhotoUpdate');
      this.handlePhotoUpdate(changeData.assetAfterChange, cachedData, orderStrategy);
    }
  }

  public getTargetStrategy(): OrderStrategy {
    let orderStrategy: OrderStrategy = new DataTakenOrderStrategy(true);
    return orderStrategy;
  }
}