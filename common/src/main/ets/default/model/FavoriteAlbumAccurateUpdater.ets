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

const TAG: string = 'FavoriteUpdater';

export class FavoriteAlbumAccurateUpdater extends AlbumAccurateUpdater {
  protected _tag: string = 'FavoriteUpdater';

  public handleAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.isFavorite) {
      Log.info(TAG, 'handleFavoriteAdd');
      this.handlePhotoAdd(info, cachedData, orderStrategy);
    }
  }

  public handleRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (info.isFavorite) {
      Log.info(TAG, 'handleFavoriteRemove');
      this.handlePhotoRemove(info, cachedData, orderStrategy);
    }
  }

  public handleUpdate(changeData: PhotoAssetChangeData, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(TAG, '[accurateNotify] handleFavoriteUpdate.');
    let isFavoriteBefore: boolean = changeData.assetBeforeChange?.isFavorite ?? false;
    let isFavoriteAfter: boolean = changeData.assetAfterChange?.isFavorite ?? false;
    if (isFavoriteBefore && !isFavoriteAfter && changeData.assetAfterChange !== null) {
      Log.info(TAG, '[accurateNotify] handleFavoriteUpdate remove');
      this.handlePhotoRemove(changeData.assetAfterChange, cachedData, orderStrategy);
    } else if (!isFavoriteBefore && isFavoriteAfter && changeData.assetAfterChange !== null) {
      Log.info(TAG, '[accurateNotify] handleFavoriteUpdate add');
      this.handlePhotoAdd(changeData.assetAfterChange, cachedData, orderStrategy);
    } else if (isFavoriteBefore && isFavoriteAfter && changeData.assetAfterChange !== null) {
      this.handlePhotoUpdate(changeData.assetAfterChange, cachedData, orderStrategy);
    }
  }
}