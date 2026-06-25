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

import lazy { Log } from '../../utils/Log';
import lazy { DataSource } from '../DataSource';
import type { MediaObserverNfyInfo } from './dataObserver/MediaObserverCallback';
import type { LoadingListener } from './LoadingListener';

const TAG: string = 'common_AbsDataSource';

// Abs DataSource
export abstract class AbsDataSource<T> extends DataSource<T> implements IDataSource {
  // Last data change time
  public lastRequestTime = 0;
  // Last refresh time
  public lastUpdateTime = 0;
  public lastTotalCount = -1;
  // callbacks
  public mCallbacks = new Map<string, Function>();
  // Is data initialized
  public isInitData: boolean = false;
  // Are there any new data changes
  public hasNewChange = false;
  // Freeze data refresh
  public isFreezeDataUpdate = false;
  // Data loading listener
  private loadingListeners: LoadingListener[] = [];

  public constructor() {
    super();
    this.registerObserver();
    this.tag = TAG;
  }

  abstract initData(): void;

  abstract loadData(): void;

  abstract getData(index: number): Object | undefined;

  public initialize(): void {
    if (!this.isInitData) {
      this.initData();
      this.isInitData = true;
    }
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    super.registerDataChangeListener(listener);
    this.initialize();
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    super.unregisterDataChangeListener(listener);
    this.unregisterObserver();
  }

  /**
   * Overall refresh of notification framework
   */
  public onDataReloaded(): void {
    if (this.isFreezeDataUpdate) {
      return;
    }
    Log.debug(this.tag, `onDataReloaded listeners size ${this.listeners?.length}`);
    super.onDataReloaded();
  }

  /* instrument ignore next */
  public onDataDelete(layoutIndex: number): void {
    if (this.isFreezeDataUpdate) {
      return;
    }
    super.onDataDelete(layoutIndex);
  }

  /* instrument ignore next */
  public onDataAdd(layoutIndex: number): void {
    if (this.isFreezeDataUpdate) {
      return;
    }
    super.onDataAdd(layoutIndex);
  }

  /**
   * Notification frame refresh by index
   *
   * @param layoutIndex index
   */
  public onDataChanged(layoutIndex: number): void {
    if (this.isFreezeDataUpdate) {
      return;
    }
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChanged(layoutIndex);
    });
  }

  /**
   * Notification frame refresh by index
   *
   * @param layoutIndex index
   */
  public onDataChange(layoutIndex: number): void {
    if (this.isFreezeDataUpdate) {
      return;
    }
    super.onDataChange(layoutIndex);
  }

  public registerObserver(): void {
  }

  public unregisterObserver(): void {
  }

  public registerCallback(name: string, cb: Function): void {
    this.mCallbacks.set(name, cb);
  }

  /* instrument ignore next */
  public unregisterCallback(name: string): void {
    this.mCallbacks.delete(name);
  }

  public addLoadingListener(listener: LoadingListener): void {
    if (listener && this.loadingListeners.indexOf(listener) === -1) {
      this.loadingListeners.push(listener);
    }
  }

  public removeLoadingListener(listener: LoadingListener): void {
    if (!listener) {
      Log.error(this.tag, 'listener is null');
      return;
    }
    let index = this.loadingListeners.indexOf(listener);
    if (index > -1) {
      this.loadingListeners.splice(index, 1);
    }
  }

  /* instrument ignore next */
  public notifyDataChanged(dataIndex: number): void {
    Log.debug(this.tag, `notifyDataChanged,loadingListeners size:${this.loadingListeners.length},index:${dataIndex}`);
    for (let listener of this.loadingListeners) {
      listener.onDataChanged(dataIndex);
    }
  }

  public notifyDataLoadingFinished(): void {
    Log.info(this.tag, `notifyDataLoadingFinished, loadingListeners size:${this.loadingListeners.length}`);
    for (let listener of this.loadingListeners) {
      listener.onDataLoadingFinished();
    }
  }

  public notifySizeLoadingFinished(size: number): void {
    Log.debug(this.tag, `notifySizeLoadingFinished, loadingListeners size: ${this.loadingListeners.length}`);
    for (let listener of this.loadingListeners) {
      listener.onSizeLoadingFinished(size);
    }
  }

  public onActive(): void {
    Log.info(this.tag, 'onActive');
    if (!this.isActive) {
      this.isActive = true;
      // Page back to the foreground, if there is a refresh media library reload refresh.
      this.loadData();
    }
  }

  public onInActive(): void {
    Log.info(this.tag, 'onInActive');
    super.pause();
  }

  public freeze(): void {
    Log.info(this.tag, 'freeze');
    this.isFreezeDataUpdate = true;
  }

  public unfreeze(): void {
    Log.info(this.tag, 'unfreeze');
    this.isFreezeDataUpdate = false;
  }

  public onChange(mediaType: string, isForceUpdate?: boolean): void {
    this.lastRequestTime = Date.now();
    Log.info(this.tag, `onChange mediaType: ${mediaType} ${this.hasNewChange} ${this.isActive}`);
    if (!this.hasNewChange) {
      this.hasNewChange = true;
      if (isForceUpdate || this.isActive) {
        this.loadData();
      }
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    Log.info(this.tag, `onNotify nfyInfo: ${nfyInfo.info()}, isForceUpdate: ${isForceUpdate}, \
      hasNewChange: ${this.hasNewChange}, isActive: ${this.isActive}`);
    this.lastRequestTime = Date.now();
    if (!this.hasNewChange) {
      this.hasNewChange = true;
      if (isForceUpdate || this.isActive) {
        Log.info(this.tag, 'onNotify call loadData');
        this.loadData();
      }
    }
  }
}