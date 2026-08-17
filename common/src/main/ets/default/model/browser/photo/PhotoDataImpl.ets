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
import lazy { FilterConditions } from '../../../model/FilterConditions';
import lazy { FetchType } from '../../../interface/BrowserDataInterface';
import lazy { BrowserDataImpl } from '../BrowserDataImpl';
import lazy { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { MediaItem } from './MediaItem';
import type { FetchOptions, PhotoAlbum, PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { BroadCastManager } from '../../common/BroadCastManager';
import lazy { Constants } from '../../common/Constants';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { QueryAlbumParams } from '../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy { PositionFilter } from '../../PositionFilter';
import lazy { UserFileData } from '../../UserFileData';
import lazy { ImageUtil } from '../../../utils/ImageUtil';

/* instrument ignore file */
const TAG: string = 'PhotoDataImpl';
interface TimeLineManagerLike {
  isOpenYearMonthTimeLine?: () => boolean;
}

export class PhotoDataImpl extends BrowserDataImpl {
  public name?: Resource;
  public broadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  /**
   * 过滤位置
   */
  protected _positionFilter: PositionFilter | undefined;

  constructor() {
    super();
  }

  public async getDataByUri(uri: string): Promise<PhotoAsset | undefined> {
    this.debug(TAG, 'getDataByUri');
    try {
      let result = await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(uri), TAG);
      return result.obj as PhotoAsset;
    } catch (error) {
      this.error(TAG, 'getDataByUri error');
      return undefined;
    }
  }

  public async getDataByBurstKey(burstKey: string, start: number, count: number, isDesc: boolean, isTrash?: boolean):
    Promise<MediaItem[]> {
    if (!burstKey) {
      Log.info(TAG, 'burstKey is empty');
      return [];
    }
    try {
      let result: PhotoAsset[] = [];
      const fetchOpt: FetchOptions = AlbumDefine.getBurstPhotosFetchOpt(start, count, isDesc, isTrash);
      result = await UserFileManagerAccess.getInstance().getBurstPhotosObject(burstKey, fetchOpt);
      return result.map(item => new MediaItem(item));
      return [];
    } catch (error) {
      this.error(TAG, 'getDataByBurstKey error');
      return [];
    }
  }

  protected addItemIntoArray(item: PhotoAsset, mediaItemList: MediaItem[], fetchType?: FetchType): void {
    if (!item || !mediaItemList) {
      this.error(TAG, 'addItemIntoArray, item or mediaItemList is undefined');
      return;
    }
    if (fetchType === FetchType.EMPTY) {
      let mediaItem: MediaItem = new MediaItem(item, fetchType);
      mediaItemList.push(mediaItem);
    } else if (fetchType === FetchType.DATE_INFO) {
      let mediaItem: MediaItem = new MediaItem(item, fetchType);
      let dateAddedLen: number = 13;
      let fileIdLen: number = 10;
      let dateAdded: string = String(item.get(photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      dateAdded = dateAdded.padStart(dateAddedLen, '0');
      mediaItem.timeId = dateAdded + (Array(fileIdLen).join('0') + item.get('file_id')).slice(-fileIdLen);
      mediaItemList.push(mediaItem);
    } else {
      let mediaItem: MediaItem = new MediaItem(item);
      // 这里不直接依赖 TimeLineModelManager 类型，避免引入额外耦合。
      const timeLineManager = AppStorage.get('TimeLineModelManager') as TimeLineManagerLike | undefined;
      mediaItem.setThumbnail(this.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
        mediaItem.getThumbnailReady()));
      mediaItem.setDetailTimeString(String(item.get(photoAccessHelper.PhotoKeys.DETAIL_TIME.toString()))) ;
      mediaItemList.push(mediaItem);
    }
    return;
  }

  public getData(callback?: AsyncCallback<MediaItem[]>, param?: QueryParam | undefined): void {
    this.info(TAG, `getMediaItem start ${JSON.stringify(param)}`);
    if (!callback || !param) {
      this.error(TAG, 'getMediaItem, param or callback is undefined, return!');
      return;
    }

    // Querying MediaLibrary data
    let mediaItemList: MediaItem[] = [];
    param.needThumbnailReady = param.needThumbnailReady ?? false;
    let startTime = Date.now();
    this.getItems(param)
      .then((dataList: PhotoAsset[] | undefined): void => {
        this.info(TAG, `getMediaItem item spend time: ${Date.now() - startTime}`);
        if (!dataList) {
          this.info(TAG, 'PhotoDataImpl getData getItems, dataList is empty');
          return;
        }
        this.info(TAG, `getMediaItem coming ${dataList.length}`);
        let index: number = 0;
        for (let item of dataList) {
          if (!item?.uri) {
            Log.warn(TAG, `photoAsset's uri:${item?.uri} is invalid, start:${param?.start}, index:${index}`);
          }
          try {
            this.addItemIntoArray(item, mediaItemList, param?.fetchType);
          } catch (err) {
            this.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
          }
          index++;
        }
        this.info(TAG, `getMediaItem item size: ${mediaItemList.length}.
          album:${param?.albumUri}, start:${param?.start}, count:${param?.count}`);
        this.info(TAG, 'call callback directly');
        callback.callback(mediaItemList, param?.albumUri);
      });
  }

  public async getItemsCount(albumUri?: string, filterMediaType?: string, needThumbnailReady?: boolean,
    storage?: LocalStorage, filterConditions?: FilterConditions): Promise<number> {
    return super.getItemsCount(albumUri, filterMediaType, needThumbnailReady, storage,
      this.applyFilterConditions(filterConditions));
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    if (!callback || !param) {
      return;
    }
    this.info(TAG, `getMediaItemCount: ${JSON.stringify(param)}`);
    this.getItemsCount(param.albumUri, param?.filterMediaType, param.needThumbnailReady).then((count): void => {
      this.info(TAG, `getMediaItemCount callback: ${count}. album:${param?.albumUri}`);
      callback.callback(count, param.albumUri);
    });
  }

  protected applyFilterConditions(conditions?: FilterConditions): FilterConditions | undefined {
    if (this.positionFilter === undefined || this.positionFilter === PositionFilter.NONE ||
      conditions?.position !== undefined || conditions?.positionFilter !== undefined) {
      return conditions;
    }
    if (conditions) {
      conditions.positionFilter = this.positionFilter;
      return conditions;
    } else {
      return {
        positionFilter: this.positionFilter,
      };
    }
  }

  public getDataIndexByUri(callback: AsyncCallback<number>, param: QueryParam, uri: string,
    isFromCard: boolean = false): void {
    this.debug(TAG, `getDataIndexByUri: ${uri}, ${JSON.stringify(param)}`);
    this.getItemIndexByUri(uri, param.albumUri, param.filterMediaType, undefined, isFromCard).then((index): void => {
      this.debug(TAG, `getItemIndexByUri callback: ${index}`);
      callback.callback(index);
    });
  }

  public getMediaItemByUri(callback: AsyncCallback<MediaItem>, uri: string): void {
    this.debug(TAG, `getMediaItemByUri: ${uri}`);

    try {
      UserFileManagerAccess.getPhotoByUri(uri).then((result): void => {
        let mediaItem: MediaItem = new MediaItem(result);
        mediaItem.setThumbnail(this.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
          mediaItem.getThumbnailReady()));
        callback.callback(mediaItem);
      });
    } catch (error) {
      this.error(TAG, 'getItemIndexByUri error');
    }
  }

  public getThumbnail(sourceUri: string, path: string, modifiedDate: number, size?: Size): string {
    return this.getThumbnailSafe(sourceUri, path, modifiedDate, size);
  }

  public async getDataByName(name: string, albumUri: string): Promise<PhotoAsset | undefined | PhotoAlbum> {
    this.debug(TAG, 'getDataByName name:' + name + `-${albumUri}`);
    let dataList: PhotoAsset[] | undefined;
    if (albumUri) {
      dataList =
        await UserFileManagerAccess.getInstance().getUserAlbumObject(AlbumDefine.getAlbumFetchOptByUri(albumUri),
          AlbumDefine.getFileFetchOptByName(name));
    } else {
      dataList = await UserFileManagerAccess.getInstance().getAllObject(AlbumDefine.getFileFetchOptByName(name), TAG);
    }

    if (dataList?.length > 0) {
      return dataList[0];
    }
    this.info(TAG, 'fileAsset is undefined');
    return undefined;
  }

  public getIsNewApiQuery(): boolean {
    return false;
  }

  public async getUnFavorCount(albumUri?: string): Promise<number> {
    const userFileMgr = UserFileManagerAccess.getInstance();
    let count: number = 0;
    if (albumUri) {
      const album: photoAccessHelper.Album | undefined = await this.getCurrentAlbum(albumUri);
      if (!album) {
        Log.warn(TAG, 'album undefined');
        return count;
      }
      count = await userFileMgr.getAlbumUnFavorAssetCount(album);
      return count;
    }
    count = await userFileMgr.getAlbumUnFavorAssetCount();
    return count;
  }

  /**
   * 设置位置过滤
   *
   * @param positionFilter PositionFilter
   * @returns
   */
  public set positionFilter(positionFilter: PositionFilter | undefined) {
    Log.info(TAG, `filterPosition ${this.positionFilter} -> ${positionFilter}`);
    this._positionFilter = positionFilter;
  }

  /**
   * 获取过滤位置配置
   * @returns 过滤位置
   */
  public get positionFilter(): PositionFilter | undefined {
    return this._positionFilter;
  }

  public getFetchOpt(query: QueryParam): FetchOptions {
    let options: FetchOptions = super.getFetchOpt(query);
    if (this.positionFilter !== undefined && query?.filterConditions?.position === undefined &&
      query.filterConditions?.positionFilter == undefined) {
      UserFileData.convertPosition(options.predicates, this.positionFilter);
    }
    return options;
  }
}