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
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { TimelineDataSource } from './TimelineDataSource';

const TAG: string = 'DayDataView';

// TimelineDataSource
export class DayDataView implements IDataSource, DataChangeListener {
  private dataSource?: TimelineDataSource;
  private itemCount: number;
  listeners: DataChangeListener[] = [];

  constructor(dataSource: TimelineDataSource) {
    Log.debug(TAG, 'constructor');
    this.itemCount = 0;
    this.dataSource = dataSource;
    this.dataSource?.registerDataChangeListener(this);
  }

  setBroadCast(broadCastParam: BroadCast): void {
    this.dataSource?.setBroadCast(broadCastParam);
  }

  setItemCountPerRow(itemCountPerRow: number): void {
  }

  setItemCountPerGroup(itemCountPerGroup: number): void {
  }

  /**
   * 获取数据总数
   * @returns
   */
  totalCount(): number {
    this.itemCount = 0;
    if (this.dataSource) {
      this.itemCount = this.dataSource.mediaCount;
    }
    Log.info(TAG, `totalCount = ${this.itemCount}`);
    return this.itemCount;
  }

  releaseCache(key: string): void {
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
  getData(index: number): ViewData | undefined {
    Log.info(TAG, `getData index ${index}`);
    if (this.dataSource) {
      let data: ViewData | undefined = this.dataSource.getData(index);
      if (data) {
        return data;
      }
    }
    return undefined;
  }

  /**
   * 注册监听
   * @param listener
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
      Log.info(TAG, `registerDataChangeListener, add listener, length: ${this.listeners.length}`);
    }
    this.initData();
  }

  /**
   * 取消监听
   * @param listener
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
      Log.info(TAG, `registerDataChangeListener, remove listener, length: ${this.listeners.length}`);
    }
  }

  /**
   * 加载数据
   */
  onDataReloaded(): void {
    Log.info(TAG, 'onDataReloaded');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  /**
   * 数据添加
   * @param index
   */
  onDataAdded(index: number): void {
    Log.error(TAG, 'onDataAdded() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    });
  }

  /**
   * 数据添加
   * @param index
   */
  onDataAdd(index: number): void {
    Log.info(TAG, 'onDataAdd() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    });
  }

  /**
   * 数据移动
   * @param from
   * @param to
   */
  onDataMoved(from: number, to: number): void {
    Log.error(TAG, 'onDataMoved() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    });
  }

  /**
   * 数据移动
   * @param from
   * @param to
   */
  onDataMove(from: number, to: number): void {
    Log.info(TAG, 'onDataMove() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    });
  }

  /**
   * 数据删除
   * @param index
   */
  onDataDeleted(index: number): void {
    Log.info(TAG, 'onDataDeleted');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    });
  }

  /**
   * 数据删除
   * @param index
   */
  onDataDelete(index: number): void {
    Log.info(TAG, 'onDataDelete() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    });
  }

  /**
   * 数据变化
   * @param index
   */
  onDataChanged(index: number): void {
    Log.error(TAG, 'onDataChanged');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    });
  }

  /**
   * 数据变化
   * @param index
   */
  onDataChange(index: number): void {
    Log.info(TAG, 'onDataChange() is called');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    });
  }

  /**
   * 数据集变化
   * @param dataOperations
   */
  public onDatasetChange(dataOperations: DataOperation[]): void {
    Log.info(TAG, 'onDatasetChange');
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDatasetChange(dataOperations);
    });
  }
}
