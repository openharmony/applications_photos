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
import lazy { AlbumInfo } from './AlbumInfo';
import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import lazy { AlbumDataImpl } from './AlbumDataImpl';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { HashMap } from '@kit.ArkTS';
import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { buildUnionAlbumInfo } from '../../../utils/UnionAlbumsUtil';

const TAG: string = 'common_MovePageAlbumDataImpl';


export class MovePageAlbumDataImpl extends AlbumDataImpl {
  constructor() {
    super();
  }

  public getData(callback: AsyncCallback<AlbumInfo[]>, param: QueryAlbumParam): void {
    this.buildMovePageAlbums(callback, param)
  }

  public async buildMovePageAlbums(callback: AsyncCallback<AlbumInfo[]>, param: QueryAlbumParam): Promise<void> {
    Log.info(TAG, 'buildMovePageAlbums start');
    let startTime: number = Date.now();
    // step1: 根据info获取对应数量的相册
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getMovePageAlbums(param);
    Log.info(TAG, `buildMovePageAlbums album count: ${albums.length}`);
    // step2: 全部转化为albumInfo类型
    let albumInfos: AlbumInfo[] = await this.buildSortedAlbumInfo(albums);
    Log.info(TAG, `buildMovePageAlbums cost:${Date.now() - startTime}`);
    callback.callback(albumInfos, albums.length);
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryAlbumParam): void {
    this.getMovePageAlbumCount(param).then((count): void => {
      Log.info(TAG, `getMovePageAlbumCount callback albumCount: ${count}`);
      callback.callback(count);
    })
  }

  /**
   * 获取移动到页面相册数量
   * @param param
   * @returns
   */
  public async getMovePageAlbumCount(param: QueryAlbumParam): Promise<number> {
    Log.debug(TAG, 'getMovePageAlbumCount start');
    let startTime: number = Date.now();
    let albumCount: number = await UserFileManagerAccess.getInstance().getMovePageAlbumsCountFilterUnionAlbums({
      orderStyle: param?.orderStyle,
    });
    Log.info(TAG, `getMovePageAlbumCount cost:${Date.now() - startTime} count = ${albumCount}`);
    return albumCount;
  }
}

