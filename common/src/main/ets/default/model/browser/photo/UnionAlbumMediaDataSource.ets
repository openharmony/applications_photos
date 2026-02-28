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

import lazy { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { Log } from '../../../utils/Log';
import lazy { MediaDataSource } from './MediaDataSource';
import lazy { MediaItem } from './MediaItem';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { UnionAlbumPhotoDataImpl } from './UnionAlbumPhotoDataImpl';
import lazy { GetMediaCountCallback } from './GetMediaCountCallback';
import lazy { PhotoDataImpl } from './PhotoDataImpl';

const TAG: string = 'UnionAlbumMediaDataSource';

export class UnionAlbumMediaDataSource extends MediaDataSource {
  public unionPhotoDataImpl: UnionAlbumPhotoDataImpl;
  private albumUris: string[] = [];
  public isUnionAlbum: boolean = false;

  constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super(windowSize, photoDataImpl);
    this.unionPhotoDataImpl = new UnionAlbumPhotoDataImpl();
  }

  protected getBatchData(callback: AsyncCallback<MediaItem[]>, start: number, count: number,
    needThumbnailReady?: boolean): void {
    if (!callback || start === undefined || start === null || count === undefined || count === null) {
      Log.error(TAG, 'getBatchData, callback or start or count is undefined');
      return;
    }
    if (!this.isUnionAlbum) {
      super.getBatchData(callback, start, count, needThumbnailReady);
      return;
    }
    let query: QueryParam = {
      albumUri: this.albumUri,
      albumUris: this.albumUris,
      start: start,
      count: count,
      needThumbnailReady: needThumbnailReady,
      filterConditions: this.queryParam?.filterConditions,
    };
    if (this.filterMediaType) {
      query.filterMediaType = this.filterMediaType;
    }
    Log.info(TAG, `getBatchData queryparam ${JSON.stringify(query)}`);
    this.unionPhotoDataImpl.getData(callback, query);
  }

  // 数据更新后回调该函数, 更新 mediaCount, 然后根据mediaCount的变化获取数据
  public loadData(): void {
    if (!this.isUnionAlbum) {
      super.loadData();
      return;
    }
    Log.info(TAG, `loadData, ${this.getItemCountFinish}`);
    let initCountCallback: GetMediaCountCallback = new GetMediaCountCallback(this);
    let param: QueryParam = {
      albumUri: this.albumUri,
      albumUris: this.albumUris,
      filterMediaType: this.filterMediaType,
    };
    if (this.filterMediaType) {
      param.filterMediaType = this.filterMediaType;
    }
    this.unionPhotoDataImpl.getDataCount(initCountCallback, param);
  }

  protected checkAlbumUri(albumUri: string): boolean {
    if (!albumUri) {
      Log.error(TAG, 'checkAlbumUri, albumUri is undefined or empty');
      return false;
    }
    if (!this.isUnionAlbum) {
      return super.checkAlbumUri(albumUri);
    }
    return this.albumUris.indexOf(albumUri) !== -1;
  }

  public setAlbumUris(albumUris: string[]): void {
    if (!albumUris || albumUris.length === 0) {
      Log.error(TAG, 'setAlbumUris: empty albumUris')
      return;
    }
    this.albumUris = albumUris.slice();
    this.albumUri = this.albumUris[0];
  }

  public getQueryParam(start: number, count: number): QueryParam {
    if (!this.isUnionAlbum) {
      return super.getQueryParam(start, count);
    }
    return {
      albumUri: this.albumUri,
      albumUris: this.albumUris,
      start: start,
      count: count,
      filterMediaType: this.filterMediaType,
    };
  }
}