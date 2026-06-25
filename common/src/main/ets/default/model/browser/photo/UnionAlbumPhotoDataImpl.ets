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

/* instrument ignore file */

import lazy {
  FetchOptions,
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '../../../access/UserFileManagerAccess';
import lazy { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { PhotoDataImpl } from './PhotoDataImpl';
import lazy { MediaItem } from './MediaItem';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import lazy { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { Constants } from '../../common/Constants';
import lazy { AssetHelper } from '../../../utils/AssetHelper';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { AlbumGridSortHelper, SortRuleString } from '../../AlbumGridSortHelper';

const TAG: string = 'UnionAlbumPhotoImpl';

export class UnionAlbumPhotoDataImpl extends PhotoDataImpl {
  public getFetchOpt(query: QueryParam): FetchOptions {
    this.info(TAG, 'UnionAlbumPhotoImpl getFetchOpt');
    let uris: string[] | undefined = query?.albumUris;
    if (!uris || uris.length === 0) {
      if (!query?.albumUri) {
        this.error(TAG, 'both albumUri and albumUris is undefined or empty, return super.getFetchOpt');
        return super.getFetchOpt(query);
      }
      this.warn(TAG, 'albumUris is undefined or empty, using query.albumUri');
      uris = [query.albumUri];
    }
    const startIndex: number | undefined = query?.start;
    const count: number | undefined = query?.count;
    const filterMediaType: string | undefined = query?.filterMediaType;
    const needThumbnailReady: boolean | undefined = query?.needThumbnailReady;
    let orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS;
    let isAsc: boolean = false;
    if (uris.length == 1 && query.albumKey && query.albumUri){
      orderProp = AlbumGridSortHelper.getOrderPropByAlbumUri(query.albumUri, query.albumKey);
      isAsc = AlbumGridSortHelper.getInstance().getSortRule('getFetchOpt', query.albumKey).type === SortRuleString.ASC;
      Log.info(TAG, `getFetchOpt from: albumUri ${query.albumUri}, albumkey ${query.albumKey}.`);
    }
    let fetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType, needThumbnailReady, orderProp, undefined, isAsc);
    AlbumDefine.modifyPredicatesInAlbumUris(fetchOpt.predicates, uris);
    AlbumDefine.setFilterConditions(fetchOpt, this.applyFilterConditions(query.filterConditions));
    return fetchOpt;
  }

  public getData(callback: AsyncCallback<MediaItem[]>, query: QueryParam): void {
    if (!callback || !query) {
      this.error(TAG, 'getUnionAlbumData, callback or query is undefined');
      return;
    }
    this.info(TAG, `getMediaItem start ${JSON.stringify(query)}`);
    let mediaItemList: MediaItem[] = [];
    let fetchOpt: FetchOptions = this.getFetchOpt(query);
    UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG).then((dataList: PhotoAsset[] | undefined): void => {
      if (!dataList) {
        return;
      }
      this.info(TAG, `getMediaItem coming dataList.length:${dataList.length}`);
      let index: number = 0;
      for (let item of dataList) {
        if (!item.uri) {
          Log.warn(TAG, `photoAsset's uri:${item.uri} is invalid, start:${query.start}, index:${index}`);
        }
        try {
          this.addItemIntoArray(item, mediaItemList, query.fetchType);
        } catch (err) {
          this.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
        }
        index++;
      }
      this.info(TAG, `getMediaItem item size: ${mediaItemList.length}`);
      callback.callback(mediaItemList, query.albumUri);
    }).catch((error: BusinessError) => {
      Log.error(TAG, `getUnionAlbumData has error: ${error}, code: ${error?.code}`);
    })
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    if (!callback || !param || !param.albumUris) {
      this.error(TAG, 'getUnionAlbumData, callback or param or param.albumUris is undefined');
      return;
    }
    this.info(TAG, `getUnionAlbumDataCount: ${JSON.stringify(param)}`);
    this.getUnionAlbumItemsCount(param)
      .then((count: number): void => {
        this.info(TAG, `getMediaItemCount callback: ${count}`);
        callback.callback(count, param.albumUri);
      })
      .catch((error: BusinessError) => {
        Log.error(TAG, `getUnionAlbumDataCount has error: ${error}, code: ${error?.code}`);
        callback.callback(0);
      });
  }

  private async getUnionAlbumItemsCount(param: QueryParam): Promise<number> {
    let count: number = 0;
    if (!param.filterMediaType && !param.filterConditions) {
      this.info(TAG, 'getUnionAlbumItemsCount start, method: albums');
      let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getAlbumsByUris(param.albumUris);
      try {
        if (albums.length === 0) {
          this.warn(TAG, 'getUnionAlbumItemsCount error: no albums found');
          return count;
        }
        for (let album of albums) {
          count += album.count;
        }
        this.info(TAG, 'getUnionAlbumItemsCount end');
      } catch (err) {
        this.error(TAG, `getUnionAlbumItemsCount error message:${err}`);
      }
    } else {
      this.info(TAG, 'getUnionAlbumItemsCount start, method: count(*)');
      let query: QueryParam = {
        albumUris: param.albumUris,
        filterMediaType: param.filterMediaType,
        needThumbnailReady: param.needThumbnailReady,
      }
      let fetchOpt: FetchOptions = this.getFetchOpt(query);
      count = await UserFileManagerAccess.getInstance().getCount(fetchOpt, TAG);
      this.info(TAG, `getUnionAlbumItemsCount count: ${count}`);
    }
    return count;
  }

  public async getUnFavorCount(albumUri?: string, unionAlbumUris?: string[]): Promise<number> {
    if (!unionAlbumUris || unionAlbumUris.length === 0) {
      return super.getUnFavorCount(albumUri);
    }
    this.info(TAG, 'UnionAlbum getUnFavorAssetCount.');
    let predicates = new dataSharePredicates.DataSharePredicates();
    AlbumDefine.modifyPredicatesInAlbumUris(predicates, unionAlbumUris);
    predicates.groupBy([String(photoAccessHelper.PhotoKeys.FAVORITE)]);
    let fetchOpt: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [photoAccessHelper.PhotoKeys.FAVORITE, UserFileManagerAccess.GROUP_BY_KEY],
    };
    AlbumDefine.setFilterConditions(fetchOpt, this.applyFilterConditions());
    this.info(TAG, 'getUnFavorAssetCount asset start');
    let assets: PhotoAsset[] = [];
    try {
      assets = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
      for (let i = 0; i < assets.length; i++) {
        if (Boolean(assets[i].get(photoAccessHelper.PhotoKeys.FAVORITE)) === false) {
          let count = assets[i].get(UserFileManagerAccess.GROUP_BY_KEY) as number;
          this.info(TAG, `getUnFavorAssetCount finished, count: ${count}.`);
          return count;
        }
      }
      return 0;
    } catch (error) {
      this.error(TAG, `getUnFavorAssetCount failed: ${error}, code: ${error?.code}`);
      return 0;
    }
  }
}