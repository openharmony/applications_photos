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

import lazy common from '@ohos.app.ability.common';
import lazy {
  FetchOptions,
  SendablePhotoAccessHelper,
  SendablePhotoAlbum,
  SendablePhotoAsset
} from '../../../access/SendablePhotoAccessHelper';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { FetchType, QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { SendableMediaItem } from './SendableMediaItem';
import lazy { collections } from '@kit.ArkTS';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy { UserFileData } from '../../UserFileData';
import lazy { AlbumGridSortHelper } from '../../AlbumGridSortHelper';
import lazy { toString } from '../../../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'common_PhotoDataManager';

export interface IClassifyFromPhoto { subKey: string, status: boolean;count?:number }

export class PhotoDataManagerParam {
  cameraShotKey?: string;
  isOpenYearMonth?: boolean;
  isHiddenAlbum?: boolean;
  isHiddenSubAlbumQuery?: boolean;
  isClassifyFromPhoto?: boolean;
  classifyFromPhotoKey?: string;
  classifyFromPhotoCount?: number;
}

export class PhotoDataManager {
  private context: common.UIAbilityContext | common.ServiceExtensionContext;
  protected queryParam: QueryParam;
  protected param: PhotoDataManagerParam;
  protected userFileManager: SendablePhotoAccessHelper;
  protected gridSortUtilInstance: AlbumGridSortHelper | undefined;

  constructor(context: common.UIAbilityContext | common.ServiceExtensionContext, queryParam: QueryParam,
    param: PhotoDataManagerParam, gridSortUtilInstance?: AlbumGridSortHelper) {
    this.context = context;
    this.queryParam = queryParam;
    this.param = param;
    this.userFileManager = new SendablePhotoAccessHelper();
    this.userFileManager.onCreate(this.context);
    this.gridSortUtilInstance = gridSortUtilInstance;
  }

  public async getItemsTask(result: collections.Array<SendableMediaItem>, isThumbnailReady?: boolean): Promise<void> {
    let dataList = await this.getItems(this.queryParam.albumUri, this.queryParam.start,
      this.queryParam.count, this.queryParam?.filterMediaType, this.queryParam,
      this.queryParam?.needThumbnailReady && isThumbnailReady) as SendablePhotoAsset[];
    if (dataList) {
      Log.info(TAG, `addItemIntoArray begin, dataList.length: ${dataList.length}`);
      let index: number = 0;
      for (let item of dataList) {
        if (!item?.uri) {
          Log.warn(TAG, `photoAsset's uri:${item?.uri} is invalid, start:${this.queryParam?.start}, index:${index}`);
        }
        try {
          this.addItemIntoArray(item, result, this.queryParam?.fetchType);
        } catch (err) {
          Log.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
        }
        index++;
      }
      dataList.splice(0, dataList.length);
    }
    Log.info(TAG, `mediaItemList size: ${result.length}, start:${this.queryParam.start},` +
      `count: ${this.queryParam.count}`
    );
  }

  public async getItems(albumUri?: string, startIndex?: number, count?: number, filterMediaType?: string,
    queryParam?: QueryParam, needThumbnailReady?: boolean):
    Promise<SendablePhotoAsset[]> {
    let result: SendablePhotoAsset[] = [];
    let fetchType = queryParam?.fetchType;
    let startTime = queryParam?.startTime;
    let isForceOrderByDateTaken = queryParam?.orderBy
      && queryParam?.orderBy === UserFileData.FILE_KEY_DATE_TAKEN_MS.toString();

    // albumUri不为空，则从目标相册中获取；否则默认从所有媒体资源中获取
    if (albumUri) {
      let album: SendablePhotoAlbum | undefined = await this.userFileManager.getAlbumByUri(albumUri);
      let fetchOpt: FetchOptions;
      if (album && PhotoAccessHelperAccess.isTrashAlbum(album)) {
        if (fetchType === FetchType.EMPTY) {
          fetchOpt = AlbumDefine.getTrashFetchOptWithEmptyColumn(startIndex, count, filterMediaType);
        } else if (fetchType === FetchType.DATE_INFO) {
          fetchOpt = AlbumDefine.getTrashFetchOptWithDateColumn(startIndex, count, filterMediaType);
        } else {
          fetchOpt = AlbumDefine.getTrashFetchOpt(startIndex, count, filterMediaType);
        }
      } else {
        /**
         * 相册页“图片”“视频”相册按照保存时间dateAdded倒序显示
         * 非“图片”“视频”相册（不含隐藏相册，最近删除），按照拍摄时间dateTaken倒序显示
         */
        let orderProp: string = AlbumGridSortHelper.getOrderPropByAlbum(album, this.gridSortUtilInstance);
        let isAsc: boolean = AlbumGridSortHelper.isAsc(album, this.gridSortUtilInstance);
        if (isForceOrderByDateTaken) {
          orderProp = UserFileData.FILE_KEY_DATE_TAKEN_MS.toString();
          isAsc = false;
        }
        if (fetchType === FetchType.EMPTY) {
          fetchOpt = AlbumDefine.getFileFetchOptWithEmptyColumn(startIndex, count, filterMediaType, orderProp);
        } else if (fetchType === FetchType.DATE_INFO) {
          fetchOpt = AlbumDefine.getFileFetchOptWithDateColumn(startIndex, count, filterMediaType, orderProp);
        } else {
          fetchOpt = AlbumDefine.getFileFetchOptWithCamera(startIndex, count, filterMediaType, this.param.cameraShotKey,
            needThumbnailReady, orderProp, undefined, isAsc);
          /**
           * 收藏相册采用索引和其他相册不一致
           * 例如：收藏相册的索引是dateAdd ASC, dateTaken DESC，其他相册走的默认索引是dateAdd DESC, dateTaken DESC
           * 这里对收藏相册采用规避方案，按拍摄时间排序的场景，第二个排序字段dateAdded升降序和dateTaken升降序保持一致，其他场景暂不处理
           * 解决问题场景：收藏相册heif图片转码/图片编辑另存后，新图片位置排序在原图之后，其他相册排在原图之前
           */
          if (PhotoAccessHelperAccess.isFavorAlbum(album) &&
            orderProp === UserFileData.FILE_KEY_DATE_TAKEN_MS.toString()) {
            if (isAsc) {
              fetchOpt.predicates.orderByAsc(UserFileData.FILE_KEY_DATE_ADDED.toString());
            } else {
              fetchOpt.predicates.orderByDesc(UserFileData.FILE_KEY_DATE_ADDED.toString());
            }
          }
        }
        Log.info(TAG, `getItems fetchOpt orderProp: ${orderProp}, params: ${toString(queryParam)}`);
      }
      if (queryParam?.filterConditions?.position === undefined &&
        queryParam?.filterConditions?.positionFilter !== undefined) {
        UserFileData.convertPosition(fetchOpt.predicates, queryParam?.filterConditions?.positionFilter);
      }
      Log.info(TAG, `getItems album fetchOpt ${JSON.stringify(fetchOpt)}, album : ${toString(album)}`);
      if (album) {
        let fetchResult: sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined = undefined;
        try {
          fetchResult = await album.getAssets(fetchOpt);
          result = await fetchResult.getAllObjects();
        } catch (err) {
          Log.error(TAG, `getItems error: ${err}, code: ${err?.code}`);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      }
    } else {
      // 宫格页 isOrderByDateTaken === true
      let fetchOpt: FetchOptions;
      const orderProp: string = UserFileData.FILE_KEY_DATE_TAKEN_MS;
      if (fetchType === FetchType.EMPTY) {
        fetchOpt = AlbumDefine.getFileFetchOptWithEmptyColumn(startIndex, count, filterMediaType, orderProp);
      } else if (fetchType === FetchType.DATE_INFO) {
        fetchOpt = AlbumDefine.getFileFetchOptWithDateColumn(startIndex, count, filterMediaType, orderProp);
      } else {
        fetchOpt = AlbumDefine.getFileFetchOptWithCamera(
          startIndex, count, filterMediaType, this.param.cameraShotKey, needThumbnailReady, orderProp,
          this.queryParam.fileIds);
      }
      if(this.param.isClassifyFromPhoto){

        fetchOpt = AlbumDefine.getFileFetchOptWithClassifyFromPhotoDb(
          startIndex, count, this.param.classifyFromPhotoKey, );
      }
      Log.info(TAG, `getItems album null start ${JSON.stringify(fetchOpt)}`);
      result = await this.userFileManager.getAllObject(fetchOpt);
    }
    Log.info(TAG, `getItems result : ${result.length},start: ${startIndex},end: ${count},startTime: ${startTime}`);
    return result;
  }

  public addItemIntoArray(item: SendablePhotoAsset, mediaItemList: collections.Array<SendableMediaItem>,
    fetchType?: FetchType): void {
    if (fetchType === FetchType.EMPTY) {
      let mediaItem: SendableMediaItem = new SendableMediaItem(item, fetchType);
      mediaItemList.push(mediaItem);
    } else if (fetchType === FetchType.DATE_INFO) {
      let mediaItem: SendableMediaItem = new SendableMediaItem(item, fetchType);
      const dateAddedLen: number = 13;
      const fileIdLen: number = 10;
      let dateAdded: string = String(item.get(photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      dateAdded = dateAdded.padStart(dateAddedLen, '0');
      mediaItem.timeId = dateAdded + (Array(fileIdLen).join('0') + item.get('file_id')).slice(-fileIdLen);
      mediaItemList.push(mediaItem);
    } else {
      let mediaItem: SendableMediaItem = new SendableMediaItem(item);
      mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.dateModified,
        this.param.isOpenYearMonth, mediaItem?.thumbnailReady));
      mediaItemList.push(mediaItem);
    }
    return;
  }

  public onDestroy(): void {
    this.userFileManager.onDestroy();
  }
}