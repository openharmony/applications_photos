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

import lazy { AlbumInfo } from './AlbumInfo';
import lazy { MovePageAlbumDataImpl } from './MovePageAlbumDataImpl';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import lazy { getMovePageAlbumsTask } from './AlbumDataConcurrent';
import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { common } from '@kit.AbilityKit';

const TAG: string = 'common_MovePageAlbumDataImplAsync';


export class MovePageAlbumDataImplAsync extends MovePageAlbumDataImpl {
  private userFileManagerAccess: UserFileManagerAccess | undefined = new UserFileManagerAccess();

  constructor() {
    super();
  }

  public onCreate(context: common.Context | undefined): void {
    this.userFileManagerAccess = UserFileManagerAccess.getInstance();
    this.userFileManagerAccess.onCreate(context);
  }

  public async getMovePageAlbumsAsync(param: QueryAlbumParam): Promise<AlbumInfo[]> {
    Log.info(TAG, 'getMovePageAlbumsAsync start');
    let startTime: number = Date.now();
    // step1: 根据info获取对应数量的相册
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getMovePageAlbums(param);
    Log.info(TAG, `getMovePageAlbumsAsync album count: ${albums.length}`);
    // step2： 转换成albumInfo
    let albumInfos: AlbumInfo[] = await this.buildSortedAlbumInfo(albums);
    Log.info(TAG, `getMovePageAlbumsAsync cost:${Date.now() - startTime}`);
    return albumInfos;
  }

  public async buildMovePageAlbumsAsync(callback: AsyncCallback<AlbumInfo[]>, param: QueryAlbumParam): Promise<void> {
    // 调用taskpool异步执行
    let context: Context = getContext(this) || global.uiAbilityContext();
    let albumInfos = await taskpool.execute(getMovePageAlbumsTask, param, context) as AlbumInfo[];
    callback.callback(albumInfos);
  }
}



