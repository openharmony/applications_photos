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
import type common from '@ohos.app.ability.common';
import type { AlbumInfo } from '../../browser/album/AlbumInfo';
import lazy { Log } from '../../../utils/Log';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { SourceTypeAlbumDataImpl } from './SourceTypeAlbumDataImpl';
import lazy { SmartAlbumBaseDataSource } from './SmartAlbumBaseDataSource';
import lazy { LoadingInfo } from '../../DataSource';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback'

const TAG: string = 'common_SourceAlbumDataSource';

const FIRST_LOAD_DATA_NUMBER: number = 30;

export class SourceTypeAlbumDataSource extends SmartAlbumBaseDataSource {
  private lastDoTime: number = 0;
  private needDelay: boolean = false;
  private readonly DELAY_TIME: number = 2000;
  public count: number = 0;
  private albumDataImpl: SourceTypeAlbumDataImpl;
  public hasLoadSourceAlbumDataError: boolean = false;
  private sourceAlbumUri?: string;

  constructor(context: common.Context, count: number, broadCast?: BroadCast) {
    super(broadCast);
    this.count = count;
    this.albumDataImpl = new SourceTypeAlbumDataImpl(context);
  }

  public totalCount(): number {
    // 目前仅侧边栏场景调用此方法，且不需要限制显示个数
    let newTotalCount = this.albums.length;
    if (this.lastTotalCount !== newTotalCount) {
      this.lastTotalCount = newTotalCount;
    }
    Log.debug(TAG, `totalCount:-sourceType ${newTotalCount}`);
    return newTotalCount;
  }

  private getSourceAlbumData(firstInfo: LoadingInfo): void {
    this.albumDataImpl.getSourceAlbumData((sourceTypeAlbums: AlbumInfo[]) => {
      Log.info(TAG, `first loadData-getSourceAlbumData ${sourceTypeAlbums.length}`);
      this.updateAlbumSetData(Date.now(), sourceTypeAlbums);
      if (sourceTypeAlbums && sourceTypeAlbums.length >= (FIRST_LOAD_DATA_NUMBER - 1)) {
        this.albumDataImpl.getSourceAlbumData((sourceTypeAlbums: AlbumInfo[]) => {
          Log.info(TAG, `second loadData-getSourceAlbumData ${sourceTypeAlbums.length}`);
          this.updateAlbumSetData(Date.now(), sourceTypeAlbums);
        }, undefined, this.sourceAlbumUri);
      }
    }, undefined, this.sourceAlbumUri, firstInfo);
  }

  public loadData(): void {
    let startTime = new Date().getTime();
    if (startTime - this.lastDoTime < this.DELAY_TIME && DeviceInfo.isPc()) {
      Log.debug(TAG, `need delay loaddata`);
      if (!this.needDelay) {
        // 加延迟触发
        this.needDelay = true;
        const timer: number = setTimeout(() => {
          this.loadData();
          clearTimeout(timer);
          this.needDelay = false;
          Log.info(TAG, `execute delay loaddata`);
        }, this.DELAY_TIME);
      }
      return;
    }

    try {
      let firstInfo: LoadingInfo = {
        start: 0,
        count: FIRST_LOAD_DATA_NUMBER,
      };
      this.getSourceAlbumData(firstInfo);
    } catch (error) {
      this.hasLoadSourceAlbumDataError = true;
      Log.error(TAG, `getSourceAlbumData error: ${error}`);
    } finally {
      this.lastDoTime = new Date().getTime();
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (!DeviceInfo.isPc()) {
      super.onNotify(nfyInfo);
      return;
    }
    setTimeout((): void => {
      super.onNotify(nfyInfo);
    }, this.getNotifyDelayTime(nfyInfo));
  }

  public async initData(): Promise<void> {
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  public setCount(count: number): void {
    this.count = count;
    this.onDataReloaded();
  }

  public setSourceAlbumUri(sourceAlbumUri: string): void {
    this.sourceAlbumUri = sourceAlbumUri;
  }
}