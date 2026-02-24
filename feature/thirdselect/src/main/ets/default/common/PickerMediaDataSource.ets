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
import type { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy {
  UnionAlbumMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/UnionAlbumMediaDataSource';
import lazy { PickerDataImplAsync } from './PickerDataImplAsync';
import lazy {
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

const TAG: string = 'PickerMediaDataSource';

export class PickerMediaDataSource extends UnionAlbumMediaDataSource {
  private static DURATION_RESET_FIRST_LOAD = 3000;
  private count: number = -1;
  private resetFirstLoadTimer: number = 0;
  // picker大图页是否有数据变化
  public isDataChange: boolean = false;

  public constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super(windowSize, photoDataImpl);
    this.initDataTraceName = 'PickerInitData';
  }

  public changeDataImpl(dataImpl: PhotoDataImpl | undefined): void {
    if (dataImpl) {
      this.photoDataImpl = dataImpl;
    }
  }

  public initData(): void {
    super.initData();

    // 如果5s后首屏数据还没查询回来，那么就兜底重置isFirstLoad并且更新一次size
    this.resetFirstLoadTimer = setTimeout((): void => {
      Log.info(TAG, 'picker showRaw timeout');
      if (this.photoDataImpl instanceof PickerDataImplAsync) {
        (this.photoDataImpl as PickerDataImplAsync).resetFirstBatchLoad();
        this.updateSize(0, this.count);
      }
    }, PickerMediaDataSource.DURATION_RESET_FIRST_LOAD);
  }

  public onActive(): void {
    Log.info(this.tag, `onActive, this.isDirtyData() = ${this.isDirtyData()}, this.isActive = ${this.isActive},
      this.isDataChange = ${this.isDataChange}`);
    if (this.isActive) {
      return;
    }
    this.isActive = true;
    if (!this.isDirtyData()) {
      return;
    }
    this.loadData();
    this.isDataChange = false;
  }

  public updateMediaData(requestTime: number, start: number, mediaItems: MediaItem[], onInit?: boolean): void {
    super.updateMediaData(requestTime, start, mediaItems);
    Log.info(TAG, `updateMediaData: mediaItems.size =  ${mediaItems?.length}`);
    if (onInit) {
      clearTimeout(this.resetFirstLoadTimer); // 首屏数据查询回来则移除延时任务
      let isFirstLoad = false;
      if (this.photoDataImpl instanceof PickerDataImplAsync) {
        isFirstLoad = (this.photoDataImpl as PickerDataImplAsync).isFirstBatchLoad();
      }
      Log.info(TAG, `updateMediaData: isFirstLoad = ${isFirstLoad}`);
      if (isFirstLoad) { // 首屏数据查询回来更新size
        this.updateSize(requestTime, this.count === -1 ? mediaItems?.length : this.count);
      }
    }
  }

  public getData(index: number): ViewData | undefined {
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
        wrappedData.mediaItem.uniqueId = simpleMediaItem.getPath();
        wrappedData.mediaItem.thumbnail = simpleMediaItem.getThumbnailUri();
        wrappedData.mediaItem.uri = simpleMediaItem.uri;
        isThumbnailInvalid = StringUtil.isEmpty(wrappedData.mediaItem.thumbnail);
      }
    }
    if (index !== 0 && isThumbnailInvalid) {
      Log.error(TAG, `getData index: ${index} thumbnail is null`);
    }
    if (this.enableDaySlidingWindowFlag) {
      this.updateSlidingWindow(this.layoutToData(index));
    }
    return wrappedData;
  }

  public getSecondPatchData(limit: number): void {
    if (this.photoDataImpl instanceof PickerDataImplAsync) {
      (this.photoDataImpl as PickerDataImplAsync).resetFirstBatchLoad(); // 第二批数据查询不走同步接口，走taskPool
    }
    super.getSecondPatchData(limit);
  }

  public updateSize(requestTime: number, count: number): void {
    this.count = count;
    let isFirstLoad = false;
    if (this.photoDataImpl instanceof PickerDataImplAsync) {
      isFirstLoad = (this.photoDataImpl as PickerDataImplAsync).isFirstBatchLoad();
    }
    Log.info(TAG, `updateSize ${this.count}, isFirstLoad = ${isFirstLoad}`);
    if (isFirstLoad && !this.items[0]) { // 首屏数据查询未回来前不更新size
      Log.info(TAG, `updateSize: the callback of count is earlier than mediItems in first load,
        do not update size untils query mediItems finish`);
      return;
    }
    super.updateSize(requestTime, count);
  }

  public getCount(): number {
    return this.count;
  }

  protected isDirtyData(): boolean {
    return super.isDirtyData() || this.nfyInfoType === MediaObserverNfyType.PHOTO_UPDATE ||
      this.isDataChange || this.hasNewChange;
  }

  public getQueryParam(start: number, count: number): QueryParam {
    let queryParam: QueryParam = super.getQueryParam(start, count);
    queryParam.needThumbnailReady = this.queryParam?.needThumbnailReady ?? false;
    return queryParam;
  }


  updateCountPostProcess(callback = (): void => {
  }): void {
    Log.info(TAG, `updateCountPostProcess hasNewChange: ${this.hasNewChange}`);
    if (this.hasNewChange || this.isCountChanged) {
      this.excludeInitData(callback);
    } else {
      callback();
    }
    this.invalidUris.length === 0 && this.emitCountUpdateCallbacks();
  }

  public getDataIndex(item: MediaItem | undefined): number {
    if (!item) {
      return Constants.NOT_FOUND;
    }
    const index = super.getDataIndex(item);

    if (index !== Constants.NOT_FOUND) {
      return index;
    }
    // 兼容导航条滑动场景，使用uniqueID在simpleMediaItems中查询
    if (!this.simpleMediaItems) {
      return Constants.NOT_FOUND;
    }
    let res = Constants.NOT_FOUND;
    this.simpleMediaItems.keys().some((key: number) => {
      const simplePath = this.simpleMediaItems?.get(key)?.getPath();
      if (simplePath === item.uniqueId) {
        res = key;
        return true;
      }
      return false;
    })
    return res;
  }
}