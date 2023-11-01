/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { AlbumSetCallback } from './AlbumSetCallback';
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import { BroadCast } from '../../../utils/BroadCast';
import { Log } from '../../../utils/Log';
import { AlbumInfo } from './AlbumInfo';
import { AbsDataSource } from '../AbsDataSource';
import { Constants } from '../../common/Constants';
import { AlbumSetDataInfo } from '../../common/AlbumSetDataInfo';
import type { InitAlbumParam } from './AlbumDataImpl';

const TAG: string = 'common_AlbumSetDataSource';

export class AlbumSetDataSource extends AbsDataSource {
  mediaSetList: AlbumInfo[] = [];
  albumDataImpl: BrowserDataInterface;
  isMultiParameter: boolean;
  private broadCast_: BroadCast;
  private filterMediaType: string = undefined;
  private blackListAlbum: Array<string> = [];
  private deviceId = '';
  private filterAlbumsFunction: Function = (mediaSetList: AlbumInfo[]): AlbumInfo[] => {
    return mediaSetList;
  };

  constructor(broadCast: BroadCast, param?: InitAlbumParam) {
    super();

    Log.debug(TAG, `constructor ${JSON.stringify(param)}`);
    if (broadCast) {
      this.broadCast_ = broadCast;
    }
    this.albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM, param);

    if (param && param.deviceId) {
      this.deviceId = param.deviceId;
    }
  }

  initData(): void {
    TraceControllerUtils.startTrace('AlbumSetPageInitData');
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  loadData(): void {
    Log.info(TAG, 'load data');
    if (this.albumDataImpl != null) {
      let callback: AlbumSetCallback = new AlbumSetCallback(this);
      this.albumDataImpl.getData(callback,
        (this.filterMediaType === undefined || this.filterMediaType === null) ?
          null : { filterMediaType: this.filterMediaType });
    }
  }

  totalCount(): number {
    let newTotalCount = this.mediaSetList.length;
    if (this.lastTotalCount != newTotalCount) {
      Log.info(TAG, `totalCount: ${newTotalCount}`);
      this.lastTotalCount = newTotalCount;
    }
    return newTotalCount;
  }

  setMultiParameter(isMultiParameter: boolean): void {
    this.isMultiParameter = isMultiParameter;
  }

  getData(index: number): AlbumSetDataInfo {
    Log.info(TAG, `getData index: ${index}, item: ${JSON.stringify(this.mediaSetList[index])}`);
    if (index < 0 || index >= this.mediaSetList.length) {
      Log.error(TAG, `index out of the total size, index: ${index} total size: ${this.mediaSetList.length}`);
      return undefined;
    }
    return new AlbumSetDataInfo(this.mediaSetList[index], index);
  }

  updateAlbumSetData(requestTime: number, mediaSetList: AlbumInfo[]): void {
    TraceControllerUtils.startTraceWithTaskId('updateAlbumSetData', requestTime);
    Log.info(TAG, `updateMediaItems size: ${mediaSetList.length}`);
    this.lastUpdateTime = requestTime;
    if (this.lastUpdateTime < this.lastChangeTime && this.isActive) {
      // If there is a new media library change callback,
      // the query continues and the current data is updated without return.
      Log.debug(TAG, 'request data expired, request again!');
      this.loadData();
    } else {
      this.hasNewChange = false;
    }
    this.mediaSetList = this.excludeBlackList(mediaSetList);
    this.onDataReloaded();
    TraceControllerUtils.finishTraceWithTaskId('updateAlbumSetData', requestTime);
    this.broadCast_.emit(Constants.ON_LOADING_FINISHED, [this.totalCount()]);
    TraceControllerUtils.finishTrace('AlbumSetPageInitData');
  }

  excludeBlackList(mediaSetList: AlbumInfo[]): Array<AlbumInfo> {
    let res: AlbumInfo[];
    if (0 == this.blackListAlbum.length) {
      Log.debug(TAG, 'BlackListAlbum: no black list.');
      res = mediaSetList;
    } else {
      Log.debug(TAG, `BlackListAlbum: albums name ${JSON.stringify(this.blackListAlbum)}.`);
      res = mediaSetList.filter((item) => {
        return this.blackListAlbum.indexOf(item.uri) < 0; // id 修改为了 uri，保证编译通过，可能发生错误
      });
    }
    res = this.filterAlbumsFunction(res);
    Log.debug(TAG, `BlackListAlbum: old albums length ${mediaSetList.length}, new albums length ${res.length}.`);
    return res;
  }

  onChange(mediaType: string): void {
    if (this.deviceId == '' || this.deviceId == undefined) {
      if (mediaType == 'image' || mediaType == 'video' || mediaType == 'album') {
        super.onChange(mediaType);
      }
    } else {
      if (mediaType == 'remote') {
        super.onChange(mediaType);
      }
    }
  }

  updateAlbumMediaCount(): void {
    for (let album of this.mediaSetList) {
      this.albumDataImpl.getDataCount(null, album);
    }
  }

  setFilterMediaType(filterMediaType: string): void {
    Log.info(TAG, `set filterMediaType: ${filterMediaType}`)
    this.filterMediaType = filterMediaType;
  }

  setBlackList(albums: Array<string>): void {
    this.blackListAlbum = albums;
    Log.debug(TAG, `BlackListAlbum: set blacklistAlbum ${JSON.stringify(this.blackListAlbum)}.`);
  }

  setFilterAlbumsFunction(filterAlbumsFunction: Function): void {
    this.filterAlbumsFunction = filterAlbumsFunction;
  }
}