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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy {
  Priority,
  YearMonthQueryParam
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthQueryParam';
import lazy {
  YearMonthMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaDataSource';
import lazy  {
  YearMonthViewData,
  YearMonthViewDataBuilder
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthViewData';
import lazy { YearMonthMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaItem';
import lazy { YearMonthUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthUtil';

const TAG: string = 'YearMonthDataView';

// TimelineDataSource
export class YearMonthDataView implements IDataSource, DataChangeListener {
  private dataSource?: YearMonthMediaDataSource;
  private itemGroupCount: number;
  private itemCountPerRow: number;
  private itemCountPerGroup: number;
  private viewWidth: number;
  private key: string;
  listeners: DataChangeListener[] = [];
  private fillPosition: number = 0;

  constructor(key: string, dataSource: YearMonthMediaDataSource) {
    Log.debug(TAG, 'constructor');
    this.key = key;
    this.itemGroupCount = 0;
    this.itemCountPerRow = 0;
    this.itemCountPerGroup = 0;
    this.viewWidth = 0;
    this.dataSource = dataSource;
    this.dataSource?.registerDataChangeListener(this);
  }

  setBroadCast(broadCastParam: BroadCast): void {
    this.dataSource?.setBroadCast(broadCastParam);
  }

  setItemCountPerRow(itemCountPerRow: number): void {
    this.itemCountPerRow = itemCountPerRow;
  }

  setItemCountPerGroup(itemCountPerGroup: number): void {
    this.itemCountPerGroup = itemCountPerGroup;
  }

  setViewWidth(viewWidth: number): void {
    this.viewWidth = viewWidth;
  }

  public updateFillPosition(fillPosition: number): void {
    this.fillPosition = fillPosition;
  }

  getRowCount(index: number): number {
    if (this.dataSource) {
      let start: number = index * this.itemCountPerGroup;
      let count: number = Math.min(this.itemCountPerGroup, this.dataSource.mediaCount - start);
      return Math.ceil(count / this.itemCountPerRow);
    }
    /* instrument ignore next */
    return 0;
  }

  /**
   * 获取数据总数
   * @returns
   */
  totalCount(): number {
    this.itemGroupCount = 0;
    if (this.dataSource) {
      this.itemGroupCount = Math.ceil((this.dataSource.mediaCount + this.fillPosition) / this.itemCountPerGroup);
    }
    Log.debug(TAG, `totalCount = ${this.itemGroupCount}`);
    return this.itemGroupCount;
  }

  /**
   * 初始化数据
   */
  initData(): void {
    this.dataSource?.setAlbumUri('');
    this.dataSource?.initData();
  }

  /**
   * LazyForEach call
   * @param index
   * @returns
   */
  getData(index: number): YearMonthViewData | undefined {
    // Log.i(TAG,
    //   `getData from index ${index}, itemGroupCount ${this.itemGroupCount}, mediaCount:${this.dataSource?.mediaCount}`);
    // if (index < 0 || index >= this.itemGroupCount) {
    //   Log.e(TAG, `getDataGroup, index out of the total size, index: ${index}, total size: ${this.itemGroupCount}`);
    //   return undefined;
    // }
    // if (this.dataSource) {
    //   if (!this.dataSource.enableGetDataFlag) {
    //     return undefined;
    //   }
    //
    //   let start: number = Math.max(0, index * this.itemCountPerGroup - this.fillPosition);
    //   let count: number = Math.min(this.itemCountPerGroup, this.dataSource.mediaCount - start);
    //   start = this.dataSource.getModifiedStart(start);
    //   let queryParam: YearMonthQueryParam = new YearMonthQueryParam(start, count, Priority.HIGH);
    //   let mediaItems: YearMonthMediaItem[] = this.dataSource.queryMediaItems(queryParam);
    //   let viewKey: string = YearMonthUtil.generateYearMonthViewKey(this.key,
    //     this.itemCountPerGroup, this.itemCountPerRow, index, this.fillPosition);
    //   let viewItem: YearMonthViewData | undefined = this.dataSource
    //     .getYearMonthDataManager().getCachedViewData(viewKey);
    //   /* instrument ignore if */
    //   /* instrument ignore else */
    //   if (viewItem) {
    //     viewItem.updateViewDataIfNeed(this.key, this.viewWidth, mediaItems, count);
    //   } else {
    //     viewItem = new YearMonthViewDataBuilder()
    //       .viewKey(viewKey)
    //       .currentView(this.key)
    //       .viewWidth(this.viewWidth)
    //       .column(this.itemCountPerRow)
    //       .groupIndex(index)
    //       .fillPosition(this.fillPosition)
    //       .build(mediaItems, count);
    //     this.dataSource.getYearMonthDataManager().cacheViewData(viewKey, viewItem);
    //   }
    //   /* instrument ignore next */
    //   return viewItem;
    // }
    /* instrument ignore next */
    return undefined;
  }

  /**
   * 注册监听
   * @param listener
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    Log.i(TAG, 'registerDataChangeListener');
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
      Log.i(TAG, `registerDataChangeListener, add listener, length: ${this.listeners.length}`);
    }
    this.initData();
  }

  /**
   * 取消监听
   * @param listener
   */
  /* instrument ignore next */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.i(TAG, 'unregisterDataChangeListener');
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
      Log.i(TAG, `registerDataChangeListener, remove listener, length: ${this.listeners.length}`);
    }
  }

  /**
   * 加载数据
   */
  /* instrument ignore next */
  onDataReloaded(): void {
    Log.i(TAG, 'onDataReloaded');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  /**
   * 数据添加
   * @param index
   */
  /* instrument ignore next */
  onDataAdded(index: number): void {
    Log.e(TAG, 'onDataAdded() is called');
  }

  /**
   * 数据添加
   * @param index
   */
  /* instrument ignore next */
  onDataAdd(index: number): void {
    Log.i(TAG, 'onDataAdd() is called');
  }

  /**
   * 数据移动
   * @param index
   */
  /* instrument ignore next */
  onDataMoved(start: number, to: number): void {
    Log.e(TAG, 'onDataMoved() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      if (this.itemGroupCount > 0) {
        let newFrom = Math.floor(start / this.itemGroupCount);
        let newTo = Math.ceil(to / this.itemGroupCount);
        listener.onDataMove(newFrom, newTo);
      }
    });
  }

  /**
   * 数据移动
   * @param index
   */
  /* instrument ignore next */
  onDataMove(start: number, to: number): void {
    Log.i(TAG, 'onDataMove() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      if (this.itemGroupCount > 0) {
        let newFrom = Math.floor(start / this.itemGroupCount);
        let newTo = Math.ceil(to / this.itemGroupCount);
        listener.onDataMove(newFrom, newTo);
      }
    });
  }

  /**
   * 数据删除
   * @param index
   */
  /* instrument ignore next */
  onDataDeleted(index: number): void {
    Log.i(TAG, 'onDataDeleted');
  }

  /**
   * 数据删除
   * @param index
   */
  /* instrument ignore next */
  onDataDelete(index: number): void {
    Log.i(TAG, 'onDataDelete() is called');
  }

  /**
   * 数据集变化
   * @param dataOperations
   */
  /* instrument ignore next */
  onDatasetChange(dataOperations: DataOperation[]): void {
    Log.debug(TAG, 'onDatasetChange() is called');
  }

  /**
   * 数据变化
   * @param index
   */
  /* instrument ignore next */
  onDataChanged(index: number): void {
    Log.e(TAG, 'onDataChanged');
    this.listeners.forEach((listener: DataChangeListener) => {
      if (this.itemGroupCount > 0) {
        listener.onDataChange(Math.floor(index / this.itemGroupCount));
      }
    });
  }

  /**
   * 数据变化
   * @param index
   */
  /* instrument ignore next */
  onDataChange(index: number): void {
    Log.i(TAG, 'onDataChange() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      if (this.itemGroupCount > 0) {
        listener.onDataChange(Math.floor(index / this.itemGroupCount));
      }
    });
  }
}
