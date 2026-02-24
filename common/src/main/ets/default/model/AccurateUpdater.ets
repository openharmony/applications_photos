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
import lazy { PhotoAssetChangeInfos, PhotoAssetChangeInfo, MediaChangeListener } from './browser/dataObserver/MediaObserver';
import lazy { MediaObserverCallback, MediaObserverNfyInfo } from './browser/dataObserver/MediaObserverCallback';
import lazy { DataListener, LoadingResult } from './DataSource';
import lazy { PageData } from './PageData';
import lazy { Log } from '../utils/Log';

const TAG: string = 'common_AccurateUpdater';

/**
 * 增量更新器，默认实现下，不作任何精准刷新优化
 */
export class AccurateUpdater<T> implements MediaObserverCallback, DataListener<T>, MediaChangeListener {
  protected isCountDirty: boolean = true;
  private dataInner: PageData<T> | undefined = undefined;

  public shouldQueryCount(): boolean {
    return this.isCountDirty;
  }

  public shouldQueryData(): boolean {
    return this.dataInner === undefined;
  }

  protected set data(data: PageData<T> | undefined) {
    this.dataInner = data;
  }

  public get data(): PageData<T> | undefined {
    return this.dataInner;
  }

  public onChange(mediaType: string): void {
    this.isCountDirty = true;
    this.dataInner = undefined;
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
  }

  public onAccurateNotify(type: string, nfyInfo: PhotoAssetChangeInfos): void {
    Log.info(TAG, '[accurateNotify] base onAccurateNotify');
  }

  public onLoadingFinished(result: LoadingResult<T>): void {
  }

  public checkNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    return true;
  }

  public setIsCountDirty(isCountDirty: boolean): void {
    this.isCountDirty = isCountDirty;
    Log.info(TAG, `this.isCountDirty: ${this.isCountDirty}`);
  }
}