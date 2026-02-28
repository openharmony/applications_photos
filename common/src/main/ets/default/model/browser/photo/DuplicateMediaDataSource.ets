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

import lazy { MediaItem } from './MediaItem';
import lazy { GetItemsCallback } from './GetItemsCallback';
import lazy { GetMediaCountCallback } from './GetMediaCountCallback';
import lazy { Log } from '../../../utils/Log';
import lazy { PendingTask } from './PendingTask';
import type { PendingCondition } from './PendingCondition';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { GetItemCallback } from './GetItemCallback';
import type { PhotoDataImpl } from './PhotoDataImpl';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import lazy { IndexConvertor } from '../../IndexConvertor';
import lazy { PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { MediaDataSource } from './MediaDataSource';
import lazy { DuplicatePhotoDataImpl } from './DuplicatePhotoDataImpl';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { SelectManager } from '../SelectManager';
import lazy { Constants } from '../../common/Constants';

const TAG: string = 'common_DuplicateMediaDataSource';

export class DuplicateMediaDataSource extends MediaDataSource implements IndexConvertor {
  private static readonly FIRST_PATCH_LOAD_COUNT = 72;
  public albumUri: string = Constants.ALL_DUPLICATE_ASSETS;
  public mSelectManager: SelectManager | undefined;

  constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super(windowSize, photoDataImpl);
    this.photoDataImpl = new DuplicatePhotoDataImpl();
  }

  // Initialize the first batch of data
  public initData(): void {
    TraceControllerUtils.startTrace(this.initDataTraceName);
    this.getItemCountFinish = false;
    this.isInInitData = true;
    Log.info(TAG, `initData, ${this.getItemCountFinish}, ${this.isInInitData}`);
    const condition: PendingCondition = {
      shouldPending: () => {
        return this.isPendingUpdateData;
      }
    }
    this.pendingUpdateData = new PendingTask(condition);
    let start: number = 0;
    let limit: number = DuplicateMediaDataSource.FIRST_PATCH_LOAD_COUNT;
    this.firstPatchDataRequestTime = Date.now();
    this.lastUpdateTime = this.firstPatchDataRequestTime;
    let firstPatchDataCallback: AsyncCallback = {
      callback: (assets: MediaItem[], dataAlbumUri: string): void => {
        Log.info(TAG, `took ${(
          Date.now() - this.firstPatchDataRequestTime)} milliseconds to load first batch: ${assets?.length}`);
        if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
          Log.error(TAG, 'initData isInvalidData: this.albumUri:' + this.albumUri + ` dataAlbumUri:${dataAlbumUri}`);
          return;
        }
        if (assets?.length > 0) {
          this.updateMediaData(this.firstPatchDataRequestTime, start, assets, true);
        }
        ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_FINISH);
        if (assets?.length < limit) {
          return;
        }
        this.getSecondPatchData(limit);
      }
    };
    let firstParam: QueryParam = {
      albumUri: this.albumUri as string,
      start: start,
      count: limit,
      needThumbnailReady: this.needThumbnailReady,
    };
    if (this.filterMediaType) {
      firstParam.filterMediaType = this.filterMediaType;
    }
    Log.info(TAG, `queryparam ${JSON.stringify(firstParam)}`);
    this.photoDataImpl.getData(firstPatchDataCallback, firstParam);
    ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_START);
    this.loadData();
  }

  public getSecondPatchData(limit: number): void {
    let secondPatchDataCallback: GetItemsCallback = new GetItemsCallback(this, limit);
    let secondParam: QueryParam = {
      albumUri: this.albumUri as string,
      start: limit,
      count: this.windowSize - limit,
      needThumbnailReady: this.needThumbnailReady,
    };
    if (this.filterMediaType) {
      secondParam.filterMediaType = this.filterMediaType;
    }
    this.photoDataImpl.getData(secondPatchDataCallback, secondParam);
  }

  // Query quantity
  public loadData(): void {
    Log.info(TAG, `loadData, ${this.getItemCountFinish}`);
    let initCountCallback: GetMediaCountCallback = new GetMediaCountCallback(this);
    let data: QueryParam = {
      albumUri: this.albumUri,
      filterMediaType: this.filterMediaType,
    };
    this.photoDataImpl.getDataCount(initCountCallback, this.filterMediaType ? data : { albumUri: this.albumUri });
  }

  public async getNeedDeleteItems(): Promise<PhotoAsset[]> {
    let photoAssets = await (this.photoDataImpl as DuplicatePhotoDataImpl).getNeedDeleteItems();
    return photoAssets;
  }

  public getMediaItemByUriFromAll(uri: string, itemNotifyCallback: Function): MediaItem | undefined {
    Log.info(TAG, `getMediaItemByUriFromAll uri ${uri}`);

    if (this.items.length <= 0 && this.cameraItems.length <= 0) {
      return undefined;
    }

    for (let item of this.items) {
      if (item?.uri === uri) {
        return item;
      }
    }

    for (let item of this.cameraItems) {
      if (item?.uri === uri) {
        return item;
      }
    }

    let selectedValues = this.mSelectManager?.selectedMap?.values();
    if (selectedValues) {
      for (let item of selectedValues) {
        if (item.uri === uri) {
          return item;
        }
      }
    }

    // 若当前数据不存在于当前列表的处理
    Log.info(TAG, `getMediaItemByUriFromAll, ${uri}`);
    let itemIndexCallback: GetItemCallback = new GetItemCallback(this, itemNotifyCallback);
    this.photoDataImpl.getMediaItemByUri(itemIndexCallback, uri);
    return undefined;
  }

  public getMediaItemSafely(index: number): MediaItem {
    let mediaItem: MediaItem = super.getMediaItemSafely(index);
    if (mediaItem.uri && !mediaItem.thumbnail) {
      mediaItem.thumbnail = ImageUtil.getThumbnailAstcUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified());
    }
    return mediaItem;
  }
}