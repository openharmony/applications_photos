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
import lazy { collections } from '@kit.ArkTS';
import lazy {
  FetchOptions,
  SendablePhotoAccessHelper,
  SendablePhotoAlbum,
  SendablePhotoAsset
} from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { SendableMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SendableMediaItem';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { UserFileData } from '@ohos/common/src/main/ets/default/model/UserFileData';
import lazy { SelectConstants } from '@ohos/common/src/main/ets/default/model/common/SelectParams';

/* instrument ignore file */
const TAG: string = 'PickerDataManager';

export class PickerDataManager {
  private context: common.Context;
  private queryParam: QueryParam;
  private userId: number = -1;
  private userFileManager: SendablePhotoAccessHelper;

  public constructor(context: common.Context, queryParam: QueryParam, userId: number) {
    this.context = context;
    this.queryParam = queryParam;
    this.userId = userId;
    this.userFileManager = new SendablePhotoAccessHelper(userId);
    this.userFileManager.onCreate(this.context);
  }

  public async getItemsTask(result: collections.Array<SendableMediaItem>): Promise<SendablePhotoAlbum | undefined> {
    let orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_ADDED;
    let album: SendablePhotoAlbum | undefined;
    if (this.queryParam.albumUri) {
      album = await this.userFileManager.getAlbumByUri(this.queryParam.albumUri);
      orderProp = AlbumGridSortHelper.getOrderPropByAlbum(album);
    }
    Log.info(TAG, `getItemsTask: albumUri = ${this.queryParam.albumUri}, orderProp = ${orderProp}`);
    let dataList = await this.getItems(album, orderProp) as SendablePhotoAsset[];
    if (dataList) {
      Log.info(TAG, `addItemIntoArray begin, dataList.length: ${dataList.length}`);
      for (let item of dataList) {
        try {
          this.addItemIntoArray(item, result);
        } catch (err) {
          Log.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
        }
      }
      dataList.splice(0, dataList.length);
    }
    Log.info(TAG, `mediaItemList size: ${result.length}, start:${this.queryParam.start},` +
      `count: ${this.queryParam.count}`
    );
    return album;
  }

  public async getItems(album?: SendablePhotoAlbum | undefined, orderProp?: string): Promise<SendablePhotoAsset[]> {
    let result: SendablePhotoAsset[] = [];
    let isAsc: boolean = false;
    if (!this.queryParam?.albumUri && orderProp === UserFileManagerAccess.FILE_KEY_DATE_ADDED) {
      isAsc = false;
    }
    let fetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOptWithCamera(this.queryParam?.start, this.queryParam?.count,
        this.queryParam?.filterMediaType, undefined, false, orderProp, undefined, isAsc);
    if (this.userId && this.userId > -1) {
      fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
      fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
    }
    if (this.queryParam?.uris) {
      // 媒体库当前不支持对uri做in操作，通过循环操作进行范围筛选
      let uriArr: string[] = this.queryParam.uris;
      fetchOpt.predicates.beginWrap();
      for (let i = 0; i < uriArr.length; i++) {
        fetchOpt.predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uriArr[i]);
        if (i < uriArr.length - 1) {
          fetchOpt.predicates.or();
        }
      }
      fetchOpt.predicates.endWrap();
    }
    if (this.queryParam?.albumUris) {
      AlbumDefine.modifyPredicatesInAlbumUris(fetchOpt.predicates, this.queryParam?.albumUris);
    }

    AlbumDefine.setFilterConditions(fetchOpt, this.queryParam.filterConditions);
    if (this.queryParam?.albumUri) {
      TraceControllerUtils.startTrace('getItemsWithAlbum');
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
      TraceControllerUtils.finishTrace('getItemsWithAlbum');
    } else {
      TraceControllerUtils.startTrace('getItemsOutAlbum');
      if (ImageUtil.isThumbnailReady() && this.queryParam?.needThumbnailReady) {
        fetchOpt.predicates.equalTo(UserFileData.FILE_KEY_THUMBNAIL_VISIBLE, UserFileData.THUMBNAIL_VISIBLE_VALUE);
      }
      result = await this.userFileManager.getAllObject(fetchOpt);
      TraceControllerUtils.finishTrace('getItemsOutAlbum');
    }
    Log.info(TAG, `getItems result : ${result.length},start: ${
      this.queryParam?.start},end: ${this.queryParam?.count}`);
    return result;
  }

  public addItemIntoArray(item: SendablePhotoAsset, mediaItemList: collections.Array<SendableMediaItem>): void {
    let mediaItem: SendableMediaItem = new SendableMediaItem(item);
    mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.dateModified,
      false, mediaItem?.thumbnailReady, true));
    mediaItemList.push(mediaItem);
    return;
  }

  public onDestroy(): void {
    this.userFileManager.onDestroy();
  }
}