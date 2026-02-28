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
import lazy { Log } from '../../../utils/Log';
import type { MediaItem } from './MediaItem';

const TAG: string = 'common_SwiperImageDataSource';

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: MediaItem[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): MediaItem {
    return this.originDataArray[index];
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      Log.info(TAG, 'add listener');
      this.listeners.push(listener);
    }
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      Log.info(TAG, 'remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  public notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  public notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  public notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  public notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }
}


export class SwiperImageDataSource extends BasicDataSource {
  public swiperList: MediaItem[] = [];

  public initSwiperList(arr: MediaItem[] | undefined): void {
    if (arr === undefined) {
      return;
    }
    this.swiperList = arr;
    this.notifyDataReload();
  }

  public getData(index: number): MediaItem {
    Log.info(TAG, `data: ${JSON.stringify(this.swiperList[index])}`);
    Log.info(TAG, `index: ${index}`);
    let mediaItem = this.swiperList[index];
    mediaItem.thumbnail = mediaItem.getThumbnailSafe({
      width: 0,
      height: 0,
    });
    return mediaItem;
  }

  public getIndex(uri: string): number {
    let index = this.swiperList.findIndex(item => item.uri === uri);
    return index;
  }

  public totalCount(): number {
    Log.debug(TAG, `totalCount: ${this.swiperList.length}`);
    return this.swiperList.length;
  }

  public deleteData(index: number): void {
    this.swiperList.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public onDataChanged(index: number): void {
    this.notifyDataChange(index);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }
}

export class ComparedImageDataSource extends BasicDataSource {
  public photoList: MediaItem[] = [];

  public initPhotoListList(arr: MediaItem[]): void {
    this.photoList = arr;
    this.notifyDataReload();
  }

  public getData(index: number): MediaItem {
    Log.info(TAG, `data: ${JSON.stringify(this.photoList[index])}`);
    Log.info(TAG, `index: ${index}`);
    let mediaItem = this.photoList[index];
    return mediaItem;
  }

  public totalCount(): number {
    Log.debug(TAG, `totalCount: ${this.photoList.length}`);
    return this.photoList.length;
  }

  public deleteData(index: number): void {
    this.photoList.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public addData(index: number, item: MediaItem): void {
    this.photoList.splice(index, 0, item);
    this.notifyDataAdd(index);
  }

  public onDataChanged(index: number): void {
    this.notifyDataChange(index);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }

  public getIndex(uri: string): number {
    let index = this.photoList.findIndex(item => item.uri === uri);
    return index;
  }
}
