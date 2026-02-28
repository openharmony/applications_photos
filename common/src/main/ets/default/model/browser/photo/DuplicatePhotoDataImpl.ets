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

import lazy { AlbumDefine } from '../AlbumDefine';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { Log } from '../../../utils/Log';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { PhotoDataImpl } from './PhotoDataImpl';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Constants } from '../../common/Constants';

const TAG: string = 'DuplicatePhotoDataImpl';

export class DuplicatePhotoDataImpl extends PhotoDataImpl {
  constructor() {
    super();
  }

  public async getItems(query?: QueryParam): Promise<PhotoAsset[]> {
    Log.info(TAG, 'DuplicatePhotoDataImpl getItems begin...');
    let start = Date.now();
    let result: PhotoAsset[];
    let fetchOpt = AlbumDefine.getAlbumFetchOptByUri(Constants.ALL_DUPLICATE_ASSETS);
    fetchOpt.predicates.limit(query?.count, query?.start);
    fetchOpt.predicates.equalTo('limit', query?.count);
    fetchOpt.predicates.equalTo('offset', query?.start);
    fetchOpt.fetchColumns.push(photoAccessHelper.PhotoKeys.DURATION);
    result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
    Log.info(TAG, `DuplicatePhotoDataImpl getItems size=${result.length}, spend time=${Date.now() - start}`);
    return result;
  }

  public async getItemsCount(albumUri?: string): Promise<number> {
    Log.info(TAG, 'DuplicatePhotoDataImpl getItemsCount begin...');
    let start = Date.now();
    let fetchOpt = AlbumDefine.getAlbumFetchOptByUri(albumUri ?? Constants.ALL_DUPLICATE_ASSETS);
    let count = await UserFileManagerAccess.getInstance().getCount(fetchOpt, TAG);
    Log.info(TAG, `DuplicatePhotoDataImpl getItemsCount size=${count}, spend time=${Date.now() - start}`);
    return count;
  }

  public async getNeedDeleteItems(): Promise<PhotoAsset[]> {
    Log.info(TAG, 'DuplicatePhotoDataImpl getNeedDeleteItems begin...');
    let start = Date.now();
    let fetchOpt = AlbumDefine.getAlbumFetchOptByUri(Constants.CAN_DEL_DUPLICATE_ASSETS);
    let result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
    Log.info(TAG, `DuplicatePhotoDataImpl getNeedDeleteItems size=${result.length}, spend time=${Date.now() - start}`);
    return result;
  }
}