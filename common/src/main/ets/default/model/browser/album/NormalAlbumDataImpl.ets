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
import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumInfo } from './AlbumInfo';
import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import lazy { AlbumDataImpl } from './AlbumDataImpl';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { UserFileManagerAccess, } from '../../../access/UserFileManagerAccess';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { HashMap } from '@kit.ArkTS';

const TAG: string = 'common_NormalAlbumDataImpl';

export class NormalAlbumDataImpl extends AlbumDataImpl {
  constructor() {
    super();
  }

  public getData(callback: AsyncCallback<AlbumInfo[]>, param: QueryAlbumParam): void {
    this.buildSortedNormalAlbums(callback, param);
  }

  protected async buildSortedNormalAlbums(callback: AsyncCallback<AlbumInfo[]>, param: QueryAlbumParam): Promise<void> {
    Log.info(TAG, 'buildSortedNormalAlbums start');
    let startTime: number = Date.now();
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSortedNormalAlbums(param);
    Log.info(TAG, `buildSortedNormalAlbums cost:${Date.now() - startTime}`);
    startTime = Date.now();
    let sourceData: AlbumInfo[] = await this.buildSortedAlbumInfo(albums);
    Log.info(TAG, `buildSortedNormalAlbums buildAlbumsInfo cost:${Date.now() - startTime}`);
    callback.callback(sourceData);
    Log.info(TAG, 'buildSortedNormalAlbums end');
  }


  public getDataCount(callback: AsyncCallback<number>, param: QueryAlbumParam): void {
    this.getSortedNormalAlbumsCount(param).then((count): void => {
      Log.info(TAG, `getSortedAlbumsCount callback: ${count}`);
      callback.callback(count);
    })
  }

  /**
   * 获取相册数量
   * @param param
   * @returns
   */
  protected async getSortedNormalAlbumsCount(param: QueryAlbumParam): Promise<number> {
    Log.debug(TAG, 'getSortedNormalAlbumsCount start');
    let albumsCount: number = 0;
    let albumsCountFilterUnionAlbum: number =
      await UserFileManagerAccess.getInstance().getNormalAlbumCountFilterUnionAlbums();
    Log.debug(TAG, `getSortedNormalAlbumsCount end, count = ${albumsCount}`);
    return albumsCount;
  }
}