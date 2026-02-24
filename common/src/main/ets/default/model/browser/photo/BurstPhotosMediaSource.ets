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

import lazy { MediaDataSource } from './MediaDataSource';
import lazy { MediaResult } from './MediaResult';
import lazy { ViewData } from '../../browser/photo/ViewData';
import lazy { ViewType } from './ViewType';
import lazy { MediaItem } from '../../browser/photo/MediaItem';
import lazy { StringUtil } from '../../../utils/StringUtil';
import type { AsyncCallback } from '../../../model/common/AsyncCallback';
import lazy { BurstPhotosDataImpl } from './BurstPhotosDataImpl';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { Log } from '../../../utils/Log';
import lazy { PhotoAsset } from '../../../access/PhotoAccessHelperAccess';

/* instrument ignore file */
const TAG: string = 'common_BurstPhotosMediaSource';


// DataSource
export class BurstPhotosMediaSource extends MediaDataSource {
  public photoDataImpl: BurstPhotosDataImpl;
  private initCallBack: () => void;
  public mediaResultCache: Map<string, MediaResult> = new Map<string, MediaResult>();

  constructor(windowSize: number, burstKey: string, callBack: () => void) {
    super(windowSize);
    this.photoDataImpl = new BurstPhotosDataImpl(burstKey);
    this.initCallBack = callBack;
  }

  initData(): void {
    let start = 0;
    this.firstPatchDataRequestTime = Date.now();
    this.lastUpdateTime = this.firstPatchDataRequestTime;

    let firstPatchDataCallback: AsyncCallback<MediaItem[]> = {
      callback: (assets: MediaItem[]): void => {
        if (assets?.length > 0) {
          this.updateMediaData(this.firstPatchDataRequestTime, start, assets);
        }
        this.initCallBack();
      }
    };
    this.photoDataImpl.getData(firstPatchDataCallback);
  }

  totalCount(): number {
    return this.photoDataImpl.totalCount;
  }

  getData(index: number): ViewData | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    const wrappedData = this.getWrappedData(index);
    let isThumbnailInvalid: boolean = StringUtil.isEmpty(wrappedData?.mediaItem?.thumbnail ?? '');
    if (wrappedData && isThumbnailInvalid) {
      let simpleMediaItem = this.getSimpleMediaItem(index);
      if (simpleMediaItem) {
        wrappedData.simpleMediaItem = simpleMediaItem;
        wrappedData.mediaItem = new MediaItem();
        wrappedData.mediaItem.thumbnail = simpleMediaItem.getThumbnailUri();
        isThumbnailInvalid = StringUtil.isEmpty(wrappedData.mediaItem.thumbnail);
      }
    }
    if (index !== 0 && isThumbnailInvalid) {
      Log.error(TAG, `getData index: ${index} thumbnail is null`);
    }
    this.updateSlidingWindow(this.layoutToData(index));
    return wrappedData;
  }
}