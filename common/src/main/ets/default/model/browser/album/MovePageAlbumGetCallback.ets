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

import type { AsyncCallback } from '../../common/AsyncCallback';
import type { AlbumInfo } from './AlbumInfo';
import lazy { Log } from '../../../utils/Log';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { MovePageAlbumDataSource } from './MovePageAlbumDataSource';

const TAG: string = 'common_MovePageAlbumGetCallback';

export class MovePageAlbumGetCallback implements AsyncCallback<AlbumInfo[]> {
  private source: MovePageAlbumDataSource;
  private requestTime: number;

  constructor(source: MovePageAlbumDataSource) {
    this.source = source;
    this.requestTime = Date.now();
  }

  public callback(albums: AlbumInfo[]): void {
    Log.info(TAG, `took ${Date.now() - this.requestTime} milliseconds to load album data: ${albums.length}`);
    // 根据场景，更新albums数据并且刷新UI
    this.source.updateAlbumInfo(albums);
  }
}
