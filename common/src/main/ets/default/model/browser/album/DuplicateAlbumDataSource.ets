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
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { SmartAlbumBaseDataSource } from './SmartAlbumBaseDataSource';
import lazy { DuplicateAlbumDataImpl } from './DuplicateAlbumDataImpl';

const TAG: string = 'common_DuplicateAlbumDataSource';

export class DuplicateAlbumDataSource extends SmartAlbumBaseDataSource {
  public albumDataImpl: DuplicateAlbumDataImpl;

  public constructor(broadCast: BroadCast) {
    super(broadCast);
    this.albumDataImpl = new DuplicateAlbumDataImpl();
  }

  public initData(): void {
    Log.debug(TAG, 'DuplicateAlbumDataSource initData');
    this.loadData();
  }

  public async loadData(): Promise<void> {
    try {
      Log.info(TAG, 'DuplicateAlbumDataSource load data');
      const duplicateAlbums: AlbumInfo[] = await this.albumDataImpl.getDuplicateAlbums();
      this.updateAlbumSetData(Date.now(), duplicateAlbums);
    } catch (error) {
      Log.error(TAG, `DuplicateAlbumDataSource load data error: ${error}`);
    }
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0 || (this.albums?.[0]?.count === 0) && (this.totalCount() === 1);
  }
}