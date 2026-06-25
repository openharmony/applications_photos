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
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumSetDataInfo } from '../../common/AlbumSetDataInfo';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import lazy { AbsDataSource } from '../AbsDataSource';
import lazy { CommonObserverCallback } from '../CommonObserverCallback';
import type { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import type { ViewData } from '../photo/ViewData';
import type { AlbumInfo } from './AlbumInfo';
import lazy { Constants } from '../../common/Constants';
import lazy { MediaObserver } from '../dataObserver/MediaObserver';
import lazy { LoadingInfo, LoadingTask } from '../../DataSource';

const TAG: string = 'common_SmartAlbumBaseDataSource';
const NOTIFY_DELAY_TIME: number = 200;


export class SmartAlbumBaseDataSource extends AbsDataSource<AlbumInfo> {
  public albums: AlbumInfo[] = [];
  public broadCast: BroadCast | undefined;
  protected ignoreLocalNotify = false;
  protected dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  public albumInfoItemCache: Map<string, AlbumSetDataInfo> = new Map<string, AlbumSetDataInfo>();

  public initData(): void {
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  // 释放单张相册的AlbumInfo
  public releaseAlbumInfoItemCache(item: AlbumInfo): void {
    if (!item?.uri) {
      Log.error(TAG, 'releaseAlbumInfoItemCache item undefined');
      return;
    }
    this.albumInfoItemCache.delete(item.uri);
  }

  public constructor(broadCast?: BroadCast) {
    super();
    this.tag = TAG;
    this.broadCast = broadCast;
  }

  public loadData(): void {
    throw new Error('Method not implemented.');
  }

  public getData(index: number): AlbumSetDataInfo | ViewData | undefined {
    Log.debug(TAG, `getData index: ${index}`);
    if (index < 0 || index >= this.albums.length) {
      Log.error(TAG, `index out of the total size, index: ${index} total size: ${this.albums.length}`);
      return undefined;
    }
    return this.getWrappedData(index);
  }

  public getWrappedData(index: number): AlbumSetDataInfo {
    let result: AlbumSetDataInfo;
    const albumInfo: AlbumInfo = this.albums[index];
    const tmp: AlbumSetDataInfo | undefined = this.albumInfoItemCache.get(albumInfo?.uri);
    if (tmp) {
      result = tmp;
      result.update(albumInfo, index);
    } else {
      result = new AlbumSetDataInfo(albumInfo, index);
      this.albumInfoItemCache.set(albumInfo?.uri, result);
    }
    return result;
  }

  public totalCount(): number {
    let newTotalCount = this.albums.length;
    if (this.lastTotalCount !== newTotalCount) {
      this.lastTotalCount = newTotalCount;
    }
    Log.debug(TAG, `totalCount: ${newTotalCount}`);
    return newTotalCount;
  }

  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.debug(TAG, `onMediaLibDataNfy skip for albumDataSource: ntyInfoType:
     ${JSON.stringify(nfyInfo.type)},this.ignoreLocalNotify = ${this.ignoreLocalNotify}`);
    if (!this.ignoreLocalNotify) {
      this.onNotify(nfyInfo);
    }
  }

  public onChange(mediaType: string): void {
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album' || mediaType === 'remote') {
      super.onChange(mediaType);
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC) {
      Log.info(TAG, `onNotify drop for MediaObserverNfyType.PHOTO_ADD_ASTC,nfyInfo=${nfyInfo.info()}`);
      return;
    }
    Log.info(TAG, `onNotify for albumDataSource with ${JSON.stringify(nfyInfo.type)}`);
    super.onNotify(nfyInfo);
  }

  public getNotifyDelayTime(nfyInfo: MediaObserverNfyInfo): number {
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE ||
      nfyInfo.type === MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM ||
      nfyInfo.type === MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM) {
      return NOTIFY_DELAY_TIME;
    }
    return 0;
  }

  public onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    if (!this.ignoreLocalNotify) {
      this.onChange(changeType);
    }
  }

  public async updateAlbumSetData(requestTime: number, mediaSetList: AlbumInfo[]): Promise<void> {
    Log.info(TAG, `updateMediaItems size: ${mediaSetList.length}`);
    this.lastUpdateTime = requestTime;
    if (this.lastUpdateTime < this.lastRequestTime && this.isActive) {
      Log.debug(TAG, 'request data expired, request again!');
      this.loadData();
    } else {
      this.hasNewChange = false;
      this.albums = mediaSetList;
      this.onDataReloaded();
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, []);
      this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [this.isEmpty(), this.totalCount()]);
      this.notifySizeLoadingFinished(this.totalCount());
      this.notifyDataLoadingFinished();
    }
  }

  public registerAlbumObserver(): void {
    MediaObserver.getInstance().registerObserver(this.dataObserver);
  }

  public unregisterAlbumObserver(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
  }

  public setIgnoreLocalNotify(flag: boolean): void {
    this.ignoreLocalNotify = flag;
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    return undefined;
  }
}