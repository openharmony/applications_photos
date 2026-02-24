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

const TAG: string = 'NormalAlbumAccurateUpdater';

/**
 * 增量更新器，最近删除相册宫格实现
 */
export class NormalAlbumAccurateUpdater extends AlbumAccurateUpdater {
  protected _tag: string = 'NormalAlbumAccurateUpdater';

  public handleAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(TAG, '[accurateNotify] handleAddByAlbumUri');
    if (info.albumUri === this.albumUri) {
      Log.info(TAG, '[accurateNotify] handleAddByAlbumUri');
      this.handlePhotoAdd(info, cachedData, orderStrategy);
    }
  }

  public handleRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(TAG, '[accurateNotify] handleRemoveByAlbumUri');
    if (info.albumUri === this.albumUri) {
      Log.info(TAG, '[accurateNotify] handleRemoveByAlbumUri');
      this.handlePhotoRemove(info, cachedData, orderStrategy);
    }
  }

  public handleUpdate(changeData: PhotoAssetChangeData, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(TAG, '[accurateNotify] handleUpdateByAlbumUri');
    let isEqualBefore: boolean = changeData.assetBeforeChange?.albumUri === this.albumUri;
    let isEqualAfter: boolean = changeData.assetAfterChange?.albumUri === this.albumUri;
    Log.info(TAG, `[accurateNotify] handleUpate ${this.albumUri} ${changeData.assetBeforeChange?.albumUri}
      ${changeData.assetAfterChange?.albumUri}`);
    if (isEqualBefore && !isEqualAfter && changeData.assetBeforeChange !== null) {
      Log.info(TAG, '[accurateNotify] handleUpdateByAlbumUri: remove');
      this.handlePhotoRemove(changeData.assetBeforeChange, cachedData, orderStrategy);
    }else if (!isEqualBefore && isEqualAfter && changeData.assetAfterChange !== null) {
      Log.info(TAG, '[accurateNotify] handleUpdateByAlbumUri: add');
      this.handlePhotoAdd(changeData.assetAfterChange, cachedData, orderStrategy);
      return;
    } else if (isEqualBefore && isEqualAfter && changeData.assetAfterChange !== null) {
      this.handlePhotoUpdate(changeData.assetAfterChange, cachedData, orderStrategy);
    }
  }
}