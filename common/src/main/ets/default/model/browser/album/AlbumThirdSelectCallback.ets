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

import type { AlbumThirdSelectDataSource } from './AlbumThirdSelectDataSource';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { AlbumInfo } from './AlbumInfo';
import lazy { Constants } from '../../common/Constants';

/* instrument ignore file */

export class AlbumThirdSelectCallback implements AsyncCallback<AlbumInfo[]> {
  private source: AlbumThirdSelectDataSource;
  private requestTime: number = 0;
  private ntyAlbumMap: Map<string, CacheData> = new Map<string, CacheData>();

  constructor(source: AlbumThirdSelectDataSource) {
    this.source = source;
  }

  callback(mediaSetList: AlbumInfo[]): void {
    TraceControllerUtils.finishTraceWithTaskId('getAlbumSetData', this.requestTime);
    if (this.isNotify(mediaSetList)) {
      this.source.updateAlbumSetData(this.requestTime, mediaSetList);
    }
  }

  updateTime(): void {
    this.requestTime = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getAlbumSetData', this.requestTime);
  }

  private isNotify(mediaSetList: AlbumInfo[]): boolean {
    if (mediaSetList?.length === 0) {
      return true;
    }
    if (this.ntyAlbumMap.size !== mediaSetList.length) {
      this.fillNtyAlbumMap(mediaSetList);
      return true;
    }
    let isNeedNty: boolean = false;
    for (let index = 0; index < mediaSetList.length; index++) {
      if (!mediaSetList[index].uri || mediaSetList[index].uri === Constants.ALBUM_URI_PREF) {
        continue;
      }
      if (!this.ntyAlbumMap.has(mediaSetList[index].uri)) {
        isNeedNty = true;
        break;
      }
      let coverUri: string = mediaSetList[index].coverUri;
      let count: number = mediaSetList[index].count;
      let albumName: string = mediaSetList[index].albumName.toString();
      let cacheCoverUri: string = this.ntyAlbumMap.get(mediaSetList[index].uri)?.coverUri ?? '';
      let cacheCount: number = this.ntyAlbumMap.get(mediaSetList[index].uri)?.count ?? 0;
      let cacheAlbumName: string = this.ntyAlbumMap.get(mediaSetList[index].uri)?.albumName.toString() ?? '';
      if (coverUri !== cacheCoverUri || count !== cacheCount || albumName !== cacheAlbumName) {
        isNeedNty = true;
        break;
      }
    }
    if (isNeedNty) {
      this.fillNtyAlbumMap(mediaSetList);
      return true;
    }
    return false;
  }

  private fillNtyAlbumMap(mediaSetList: AlbumInfo[]): void {
    this.ntyAlbumMap.clear();
    mediaSetList.forEach((albumInfo: AlbumInfo) => {
      if (albumInfo.uri && albumInfo.uri.startsWith(Constants.ALBUM_URI_PREF) &&
        albumInfo.uri.length > Constants.ALBUM_URI_PREF.length) {
        let data: CacheData = {
          coverUri: albumInfo.coverUri,
          albumName: albumInfo.albumName,
          count: albumInfo.count,
        };
        this.ntyAlbumMap.set(albumInfo.uri, data);
      }
    });
  }
}

export interface CacheData {
  coverUri: string;
  albumName: Resource | string;
  count: number;
}