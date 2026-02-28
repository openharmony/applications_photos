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
import type { AlbumInfo } from '../../browser/album/AlbumInfo';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { AlbumDataImpl } from './AlbumDataImpl';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { SmartAlbumBaseDataSource } from './SmartAlbumBaseDataSource';
import lazy { Constants } from '../../../model/common/Constants';

const TAG: string = 'common_CleanupAlbumsDataSource';

export class CleanupAlbumsDataSource extends SmartAlbumBaseDataSource {
  public albumDataImpl: BrowserDataInterface;
  public hasLoadCleanupAlbumDataError: boolean = false;
  public albumSizeMap: Map<string, number> = new Map();
  private albumType: string = 'all';
  public photoAlbums: AlbumInfo[] = [];
  public isPhotoAlbumEmpty: boolean = false;

  public constructor(broadCast: BroadCast) {
    super(broadCast);
    this.albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
  }

  public setAlbumType(albumType: string) {
    this.albumType = albumType;
  }

  public initData(): void {
    Log.info(TAG, 'initData');
  }

  public async loadData(): Promise<void> {
    try {
      Log.info(TAG, 'load data');
      let cleanupAlbums: AlbumInfo[] = [];
      if (this.albumType === Constants.DELETE_ALBUM_TYPE_PHOTO) {
        this.photoAlbums = await (this.albumDataImpl as AlbumDataImpl).getAllPhotoAlbum();
        this.isPhotoAlbumEmpty = this.photoAlbums?.[0]?.albumLocalAssetCount === 0;
        cleanupAlbums = await (this.albumDataImpl as AlbumDataImpl).getCleanupPhotoAlbums();
      } else {
        cleanupAlbums = await (this.albumDataImpl as AlbumDataImpl).getCleanupAlbum();
      }
      this.updateAlbumSetData(Date.now(), cleanupAlbums);
      Log.info(TAG, `cleanupAlbums: ${JSON.stringify(cleanupAlbums)} load data end! hasNewChange=${this.hasNewChange}`);
    } catch (error) {
      this.hasLoadCleanupAlbumDataError = true;
      Log.error(TAG, `Get CleanupAlbumsDataSource error: ${error}`);
    }
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0 || (this.totalCount() === 1 && this.albums?.[0]?.albumLocalAssetCount === 0);
  }
}