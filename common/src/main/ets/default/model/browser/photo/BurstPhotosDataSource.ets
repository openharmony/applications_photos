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

import lazy { Log } from '../../../utils/Log';
import lazy { MediaResult } from './MediaResult';
import lazy { Thumbnail } from './Thumbnail';
import lazy { PhotoDataAdapter } from './PhotoDataAdapter';
import lazy { MediaItem } from '../../browser/photo/MediaItem';
import lazy { BurstPhotosDataImpl } from './BurstPhotosDataImpl';
import lazy { Constants } from '../../common/Constants';
import lazy { BurstPhotosMediaSource } from './BurstPhotosMediaSource';

/* instrument ignore file */
const TAG: string = 'common_BurstPhotosDataSource';


// DataSource
export class BurstPhotosDataSource implements IDataSource {
  public photoDataImpl: BurstPhotosDataImpl;
  private photoDataAdapter: PhotoDataAdapter = new PhotoDataAdapter();
  private dataSource?: BurstPhotosMediaSource;
  public mediaResultCache: Map<string, MediaResult> = new Map<string, MediaResult>();
  // 当前图的index
  private currentIndex = 0;

  constructor(burstKey: string) {
    this.photoDataImpl = new BurstPhotosDataImpl(burstKey);
  }

  setDataSource(dataSource: BurstPhotosMediaSource): void {
    if (!dataSource) {
      Log.error(TAG, 'dataSource undefined');
    }
    this.dataSource = dataSource;
  }

  totalCount(): number {
    if (this.dataSource) {
      return this.dataSource.totalCount();
    }
    return 0;
  }

  getData(index: number): MediaResult | undefined {
    if (this.dataSource) {
      this.dataSource.updateSlidingWindow(index);
      let mediaItem: MediaItem | undefined = this.dataSource.getRawData(index);
      let result = this.packDataWithCache(index, mediaItem);
      return result;
    }
    return undefined;
  }

  getRawData(index: number): MediaItem | undefined {
    if (this.dataSource) {
      return this.dataSource.getRawData(index);
    }

    return undefined;
  }

  getAllItems(): MediaResult[] {
    if (this.dataSource && this.totalCount()) {
      const result: MediaResult[] = [];
      for (let i = 0; i < this.totalCount(); i++) {
        const item = this.getData(i);
        if (item) {
          result.push(item);
        }
      }
      return result;
    }
    return []
  }

  getAllAssets(): MediaItem[] {
    if (this.dataSource && this.totalCount()) {
      const result: MediaItem[] = [];
      for (let i = 0; i < this.totalCount(); i++) {
        if (this.dataSource.getRawData(i)) {
          result.push(this.dataSource.getRawData(i) as MediaItem);
        }
      }
      return result;
    }
    return []
  }

  packDataWithCache(index: number, mediaItem?: MediaItem): MediaResult | undefined {
    if (!mediaItem) {
      return undefined;
    }

    let path: string = mediaItem.path;
    let mediaResult: MediaResult;
    let thumbnail: Thumbnail = this.photoDataAdapter.getThumbnail(mediaItem) ?? new Thumbnail;
    if (this.mediaResultCache.get(path)) {
      mediaResult = this.mediaResultCache.get(path) as MediaResult;
      mediaResult.update(mediaItem);
      mediaResult.setItemThumbnail(thumbnail);
      mediaResult.setItemPos(index);
    } else {
      mediaResult = new MediaResult(mediaItem);
      mediaResult.setItemThumbnail(thumbnail);
      mediaResult.setItemPos(index);
      this.mediaResultCache.set(path, mediaResult);
    }
    return mediaResult;
  }

  updateCurrent(index: number): void {
    Log.info(TAG, `updateCurrent ${this.currentIndex} -> ${index}`);
    this.currentIndex = index;
  }

  getCurrentIndex(): number {
    return this.currentIndex;
  }

  getDataIndexByUri(uri?: string): number {
    if (this.dataSource && uri) {
      return this.dataSource.getDataIndexByUri(uri);
    }
    return Constants.NOT_FOUND;
  }

  onDataReloaded(): void {
    this.dataSource?.onDataReloaded();
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.dataSource) {
      this.dataSource.registerObserver();
      if (this.dataSource.listeners.indexOf(listener) < 0) {
        this.dataSource.listeners.push(listener);
      }
    }

  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    if (this.dataSource) {
      const pos = this.dataSource.listeners.indexOf(listener);
      if (pos >= 0) {
        this.dataSource.listeners.splice(pos, 1);
      }
    }
  }

  public release(): void {
    this.mediaResultCache?.clear();
    this.photoDataAdapter?.clear();
  }
}