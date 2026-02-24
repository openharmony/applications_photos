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

import lazy { Log } from '../utils/Log';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import type common from '@ohos.app.ability.common';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { SendableAssetHelper } from '../utils/SendableAssetHelper';
import lazy { Constants } from '../model/common/Constants';
import lazy { JSON } from '@kit.ArkTS';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { UserFileData } from '../model/UserFileData';
import lazy { AlbumFetchOptionBuilder } from '../model/FetchOption';
import lazy { ImageUtil } from '../utils/ImageUtil';

/* instrument ignore file */
const TAG: string = 'common_SendablePhotoAccessHelper';

export type UserFileManager = photoAccessHelper.PhotoAccessHelper;

const API_RESPONSE_NO_DATA: number = 95271002;

export type FileType = photoAccessHelper.PhotoType;

export type FetchOptions = photoAccessHelper.FetchOptions;

export type SendablePhotoAsset = sendablePhotoAccessHelper.PhotoAsset;

export type ImageVideoKey = photoAccessHelper.PhotoKeys;

export type AlbumKey = photoAccessHelper.AlbumKeys;

export type SendableAlbumType = sendablePhotoAccessHelper.AlbumType;

export type SendableAlbumSubType = sendablePhotoAccessHelper.AlbumSubtype;

export type DefaultChangeUri = photoAccessHelper.DefaultChangeUri;

export type ChangeData = photoAccessHelper.ChangeData;

export type SendablePhotoAlbum = sendablePhotoAccessHelper.Album;

export type SendableSharedPhotoAsset = sendablePhotoAccessHelper.SharedPhotoAsset;

export type MovingPhoto = photoAccessHelper.MovingPhoto;

export class SendablePhotoAccessHelper {
  public static readonly MEDIA_TYPE_IMAGE = sendablePhotoAccessHelper.PhotoType.IMAGE;
  public static readonly MEDIA_TYPE_VIDEO = sendablePhotoAccessHelper.PhotoType.VIDEO;
  public static readonly FILE_KEY_MEDIA_TYPE = photoAccessHelper.PhotoKeys.PHOTO_TYPE;
  public static readonly FILE_KEY_DISPLAY_NAME = photoAccessHelper.PhotoKeys.DISPLAY_NAME;
  public static readonly FILE_KEY_DATE_ADDED = photoAccessHelper.PhotoKeys.DATE_ADDED;
  public static readonly FILE_KEY_DATE_TAKEN = photoAccessHelper.PhotoKeys.DATE_TAKEN;
  public static readonly FILE_KEY_DATE_TRASHED = 'date_trashed'//photoAccessHelper.PhotoKeys.DATE_TRASHED;
  public static readonly FILE_KEY_TITLE = photoAccessHelper.PhotoKeys.TITLE;
  public static readonly FILE_KEY_THUMBNAIL_READY = 'thumbnail_ready';
  public static readonly REGISTER_TYPE_ALL_PHOTOS = 'file://media/Photo';
  public static readonly REGISTER_TYPE_ALL_ALBUMS = 'file://media/PhotoAlbum';
  public static readonly REGISTER_TYPE_ANALYSIS_ALBUMS = 'file://media/AnalysisAlbum';
  public static readonly NOTIFY_ADD = photoAccessHelper.NotifyType.NOTIFY_ADD;
  public static readonly NOTIFY_UPDATE = photoAccessHelper.NotifyType.NOTIFY_UPDATE;
  public static readonly NOTIFY_REMOVE = photoAccessHelper.NotifyType.NOTIFY_REMOVE;
  public static readonly NOTIFY_ALBUM_ADD_ASSET = photoAccessHelper.NotifyType.NOTIFY_ALBUM_ADD_ASSET;
  public static readonly NOTIFY_ALBUM_REMOVE_ASSET = photoAccessHelper.NotifyType.NOTIFY_ALBUM_REMOVE_ASSET;
  public static readonly FILE_LOCATION_LOCAL = photoAccessHelper.PositionType.LOCAL;
  public static readonly FILE_LOCATION_CLOUD = photoAccessHelper.PositionType.CLOUD;
  // 云上和本地都有
  public static readonly FILE_LOCATION_BOTH = 2;
  public static readonly FETCH_COLUMNS_MIME_TYPE = 'mime_type';
  public static readonly FETCH_COLUMNS_SIZE = 'size';
  public static readonly ALL_IMAGE_VIDEO_FETCH_COLUMNS: string[] = [
    photoAccessHelper.PhotoKeys.URI.toString(),
    photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
    photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
    photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
    photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
    photoAccessHelper.PhotoKeys.TITLE.toString(),
    photoAccessHelper.PhotoKeys.DURATION.toString(),
    photoAccessHelper.PhotoKeys.WIDTH.toString(),
    photoAccessHelper.PhotoKeys.HEIGHT.toString(),
    photoAccessHelper.PhotoKeys.DATE_TAKEN.toString(),
    photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
    photoAccessHelper.PhotoKeys.FAVORITE.toString(),
    photoAccessHelper.PhotoKeys.POSITION.toString(),
    photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(),
    photoAccessHelper.PhotoKeys.HIDDEN.toString(),
    'date_trashed_ms',
    'hidden',
    SendablePhotoAccessHelper.FETCH_COLUMNS_SIZE, // Waiting: 等媒体库枚举字段上库
    SendablePhotoAccessHelper.FETCH_COLUMNS_MIME_TYPE,
    UserFileData .FETCH_COLUMNS_LCD_SIZE,
    UserFileData .FETCH_COLUMNS_THM_SIZE,
    UserFileData .FETCH_COLUMNS_PHOTO_QUALITY
  ];
  public static readonly GROUP_BY_KEY: string = 'count(*)';
  public static readonly IMAGE_ALBUM_SUB_TYPE: SendableAlbumSubType = 1031; // Waiting: 等媒体库枚举字段上库
  public static readonly CAMERA_ALBUM_SUB_TYPE: SendableAlbumSubType = 1041//sendablePhotoAccessHelper.AlbumSubtype.CAMERA;
  public static readonly FAVORITE_ALBUM_SUB_TYPE: SendableAlbumSubType =
    sendablePhotoAccessHelper.AlbumSubtype.FAVORITE;
  public static readonly VIDEO_ALBUM_SUB_TYPE: SendableAlbumSubType = sendablePhotoAccessHelper.AlbumSubtype.VIDEO;
  public static readonly TRASH_ALBUM_SUB_TYPE: SendableAlbumSubType = 1042//sendablePhotoAccessHelper.AlbumSubtype.TRASH;
  public static readonly HIDDEN_ALBUM_SUB_TYPE: SendableAlbumSubType = 1043//sendablePhotoAccessHelper.AlbumSubtype.HIDDEN;
  public static readonly SYSTEM_BEFORE_USER_ALBUM_LIST: SendableAlbumSubType[] = [
    SendablePhotoAccessHelper.IMAGE_ALBUM_SUB_TYPE,
    SendablePhotoAccessHelper.VIDEO_ALBUM_SUB_TYPE,
    SendablePhotoAccessHelper.FAVORITE_ALBUM_SUB_TYPE
  ];
  public static readonly SYSTEM_AFTER_USER_ALBUM_LIST: SendableAlbumSubType[] = [
    SendablePhotoAccessHelper.HIDDEN_ALBUM_SUB_TYPE,
    SendablePhotoAccessHelper.TRASH_ALBUM_SUB_TYPE
  ];
  private photoAccessHelper?: sendablePhotoAccessHelper.PhotoAccessHelper;
  private requestTime: number;
  private systemAlbumUriMap: Map<SendableAlbumSubType, string> = new Map<SendableAlbumSubType, string>();
  private isMoreAlbumsVisible: boolean = false;
  private static sendablePhotoAccessHelper: SendablePhotoAccessHelper = new SendablePhotoAccessHelper();
  private userId: number = -1;

  constructor(userId?: number) {
    this.requestTime = Date.now();
    this.userId = userId ?? -1;
  }

  public static getInstance(): SendablePhotoAccessHelper {
    return SendablePhotoAccessHelper.sendablePhotoAccessHelper;
  }

  onCreate(context: common.Context | undefined): void {
    if (!context) {
      return;
    }
    Log.debug(TAG, `Photos_SendablePhotoAccessHelper onCreate ${JSON.stringify(context)}`);
    if (this.photoAccessHelper) {
      Log.debug(TAG, 'Photos_SendablePhotoAccessHelper onCreate already');
      return;
    }
    if (this.userId === -1) {
      this.photoAccessHelper = sendablePhotoAccessHelper.getPhotoAccessHelper(context);
    } else {
      this.photoAccessHelper = sendablePhotoAccessHelper.getPhotoAccessHelper(context);
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'get photoAccessHelper instance failed!');
    }
    Log.info(TAG, `onCreate done userId successfully !`);
  }

  public getAllFetchColumns(): string[] {
    return SendablePhotoAccessHelper.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
  }

  onDestroy(): void {
    try {
      this.photoAccessHelper?.release();
      this.photoAccessHelper = undefined;
      Log.info(TAG, 'onDestroy done');
    } catch (err) {
      Log.error(TAG, `onDestroy error: ${err}, code: ${err?.code}`);
    }
  }

  getSystemAlbumUriMap(): Map<SendableAlbumSubType, string> {
    return this.systemAlbumUriMap;
  }

  public async getObject(fetchOpt: FetchOptions): Promise<SendablePhotoAsset | undefined> {
    Log.info(TAG, `getObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getObject] photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getObject--' + TAG, this.requestTime);
      fetchResult = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined> => {
          if (!this.photoAccessHelper) {
            return undefined;
          }
          return await this.photoAccessHelper.getAssets(fetchOpt);
        }, 'getObject --> getAssets');
      if (!fetchResult) {
        Log.warn(TAG, 'get all Object Data with empty dataList');
        return undefined;
      }
      Log.info(TAG, `get all Object Data raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, `getCount = 0, browserCode = ${API_RESPONSE_NO_DATA}`);
        return undefined;
      }

      let result: SendablePhotoAsset | undefined = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<SendablePhotoAsset | undefined> => {
          return await fetchResult?.getFirstObject();
        }, 'getObject --> getFirstObject');
      return result;
    } catch (error) {
      Log.error(TAG, `getObject error: ${error}, code: ${error?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      TraceControllerUtils.finishTraceWithTaskId('getObject--' + TAG, this.requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getAllObject(fetchOpt: FetchOptions): Promise<SendablePhotoAsset[]> {
    Log.info(TAG, `getAllObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getAllObject] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getAllObject--' + TAG, this.requestTime);
      fetchResult = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined> => {
          if (!this.photoAccessHelper) {
            return undefined;
          }
          return await this.photoAccessHelper.getAssets(fetchOpt);
        }, 'getAllObject --> getAssets');
      if (!fetchResult) {
        Log.warn(TAG, 'get all Object Data with empty dataList');
        return [];
      }
      Log.info(TAG, `get all Object Data raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, `getCount = 0, browserCode = ${API_RESPONSE_NO_DATA}`);
        return [];
      }

      let result: SendablePhotoAsset[] = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<SendablePhotoAsset[]> => {
          return await fetchResult?.getAllObjects() ?? [];
        }, 'getAllObject --> getAllObjects');
      return result;
    } catch (error) {
      Log.error(TAG, `getAllObject error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      TraceControllerUtils.finishTraceWithTaskId('getAllObject--' + TAG, this.requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async prepareSystemAlbums(): Promise<void> {
    Log.info(TAG, 'prepareSystemAlbums start');
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'prepareSystemAlbums photoAccessHelper resource is null!');
      return;
    }
    try {
      await this.prepareSystemAlbumsFn();
    } catch (err) {
      Log.error(TAG, `prepareSystemAlbums Get System Album exception! msg:  ${err}, code: ${err?.code}`);
      return;
    }
  }

  public async prepareSystemAlbumsFn(): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'prepareSystemAlbumsFn photoAccessHelper undefined');
      return;
    }
    let fetchResult: photoAccessHelper.FetchResult<SendablePhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(
        sendablePhotoAccessHelper.AlbumType.SYSTEM, sendablePhotoAccessHelper.AlbumSubtype.ANY) as photoAccessHelper.FetchResult<SendablePhotoAlbum>;
      let systemAlbums = await fetchResult?.getAllObjects();
      this.initSystemAlbumUriMap(systemAlbums);
    } catch (err) {
      Log.error(TAG, `prepareSystemAlbumsFn: ${err}`);
      return;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  private initSystemAlbumUriMap(systemAlbums: SendablePhotoAlbum[]): void {
    for (let i = 0; i < SendablePhotoAccessHelper.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
      let albumSubType = SendablePhotoAccessHelper.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
      for (let j = 0; j < systemAlbums.length; j++) {
        if (albumSubType === systemAlbums[j].albumSubtype) {
          this.systemAlbumUriMap.set(albumSubType, systemAlbums[j].albumUri);
          Log.info(TAG, `prepareSystemAlbums before :${systemAlbums[j].albumUri}, ${albumSubType}`);
        }
      }
    }
    for (let i = 0; i < SendablePhotoAccessHelper.SYSTEM_AFTER_USER_ALBUM_LIST.length; i++) {
      let albumSubType = SendablePhotoAccessHelper.SYSTEM_AFTER_USER_ALBUM_LIST[i];
      for (let j = 0; j < systemAlbums.length; j++) {
        if (albumSubType === systemAlbums[j].albumSubtype) {
          this.systemAlbumUriMap.set(albumSubType, systemAlbums[j].albumUri);
          this.isMoreAlbumsVisible = this.isMoreAlbumsVisible || (systemAlbums[j].count > 0);
          Log.info(TAG, `prepareSystemAlbums after :${systemAlbums[j].albumUri}, ${albumSubType}`);
        }
      }
    }
  }

  public static getLcdSize(data?: SendablePhotoAsset, uri?: string): Size | undefined {
    if (!data) {
      return undefined;
    }

    let lcdWidth: number = 0;
    let lcdHeight: number = 0;
    let lcdSize: string = String(SendableAssetHelper.get(data, UserFileData .FETCH_COLUMNS_LCD_SIZE, ''));
    if (lcdSize.length === 0) {
      Log.warn(TAG, `lcd size is zero, uri:${ImageUtil.encryptThumbnailUri(uri)}`);
      return undefined;
    }

    let lcdSizeArray = lcdSize.split(UserFileData .FETCH_LCD_THM_SPLIT_SYMBOLS);
    if (lcdSizeArray.length !== 2) {
      Log.warn(TAG, 'lcdSizeArray.length not 2');
      return undefined;
    }

    lcdWidth = parseInt(lcdSizeArray[0]);
    lcdHeight = parseInt(lcdSizeArray[1]);
    lcdWidth = !Number.isFinite(lcdWidth) ? 0 : lcdWidth;
    lcdHeight = !Number.isFinite(lcdHeight) ? 0 : lcdHeight;
    return { width: lcdWidth, height: lcdHeight };
  }

  public static getThmSize(data?: SendablePhotoAsset, uri?: string): Size | undefined {
    if (!data) {
      return undefined;
    }

    let thmWidth: number = 0;
    let thmHeight: number = 0;
    let thmSize: string = String(SendableAssetHelper.get(data, UserFileData .FETCH_COLUMNS_THM_SIZE, ''));
    if (thmSize.length === 0) {
      Log.warn(TAG, `thm size is zero, uri:${ImageUtil.encryptThumbnailUri(uri)}`);
      return undefined;
    }

    let thmSizeArray = thmSize.split(UserFileData .FETCH_LCD_THM_SPLIT_SYMBOLS);
    if (thmSizeArray.length !== 2) {
      Log.warn(TAG, 'thmSizeArray.length not 2');
      return undefined;
    }

    thmWidth = parseInt(thmSizeArray[0]);
    thmHeight = parseInt(thmSizeArray[1]);
    thmWidth = !Number.isFinite(thmWidth) ? 0 : thmWidth;
    thmHeight = !Number.isFinite(thmHeight) ? 0 : thmHeight;
    return { width: thmWidth, height: thmHeight };
  }

  private getSystemBeforeAlbums(systemAlbums: SendablePhotoAlbum[]): SendablePhotoAlbum[] {
    let systemAlbumList: SendablePhotoAlbum[] = [];
    for (let i = 0; i < SendablePhotoAccessHelper.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
      let albumSubType = SendablePhotoAccessHelper.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
      for (let j = 0; j < systemAlbums.length; j++) {
        if (albumSubType === systemAlbums[j].albumSubtype) {
          this.systemAlbumUriMap.set(albumSubType, systemAlbums[j].albumUri);
          systemAlbumList.push(systemAlbums[j]);
          Log.info(TAG, `getSystemBeforeAlbums :${systemAlbums[j].albumUri}`);
        }
      }
    }
    return systemAlbumList;
  }

  public async getSystemAlbum(albumSubtype: sendablePhotoAccessHelper.AlbumSubtype):
    Promise<SendablePhotoAlbum | undefined> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getSystemAlbum photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<SendablePhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(
        sendablePhotoAccessHelper.AlbumType.SYSTEM, albumSubtype)as photoAccessHelper.FetchResult<SendablePhotoAlbum>
      let album: SendablePhotoAlbum = await fetchResult.getFirstObject()
      this.systemAlbumUriMap.set(albumSubtype, album.albumUri);
      Log.info(TAG, `getSystemAlbum : ${album.albumUri}`);
      return album;
    } catch (err) {
      Log.error(TAG, `getSystemAlbum Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  /**
   * 根据Uri获取相册，不区分系统相册和用户相册
   * @param albumUri 相册Uri
   * @returns 目标相册
   */
  public async getAlbumByUri(albumUri?: string): Promise<SendablePhotoAlbum | undefined> {
    Log.info(TAG, `getAlbumByUri albumUri is ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getAlbumByUri photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<SendablePhotoAlbum> | undefined = undefined;
    try {
      let albumFetchOpt = new AlbumFetchOptionBuilder().photoAlbumUri(albumUri).build();
      fetchResult = await this.photoAccessHelper.getAlbums(albumFetchOpt) as photoAccessHelper.FetchResult<SendablePhotoAlbum>
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbumByUri return null');
        return undefined;
      }
      Log.info(TAG, `getAlbumByUri return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: SendablePhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getAlbumByUri result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    }
    finally {
      fetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  public async getHiddenAlbum(albumUri?: string,
    isHiddenSubAlbumQuery?: boolean): Promise<SendablePhotoAlbum | undefined> {
    Log.info(TAG, `getHiddenAlbum albumUri is ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getHiddenAlbum photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<SendablePhotoAlbum> | undefined = undefined;
    try {
      let albumFetchOpt = new AlbumFetchOptionBuilder().photoAlbumUri(albumUri).build();
      fetchResult = await this.photoAccessHelper.getAlbums(albumFetchOpt) as photoAccessHelper.FetchResult<SendablePhotoAlbum>
      //   .getHiddenAlbums(isHiddenSubAlbumQuery ?
      // photoAccessHelper.HiddenPhotosDisplayMode.ALBUMS_MODE :
      // photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE, albumFetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getHiddenAlbum return null');
        return undefined;
      }
      Log.info(TAG, `getHiddenAlbum return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: SendablePhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getHiddenAlbum result is null');
      }
      return album;
      // return undefined;
    } catch (err) {
      Log.error(TAG, `getHiddenAlbum Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    }
    finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getMapAlbums(fetchOptions: FetchOptions): Promise<SendablePhotoAlbum[]> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getMapAlbums photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<SendablePhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper
        .getAlbums(/*sendablePhotoAccessHelper.AlbumType.SMART*/1011, Constants.LOCATION_QUERY_SUB_TYPE, fetchOptions) as photoAccessHelper.FetchResult<SendablePhotoAlbum>
      if (!fetchResult) {
        Log.warn(TAG, 'getMapAlbums return null');
        return [];
      }

      Log.info(TAG, `getMapAlbums return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return [];
      }
      let album: SendablePhotoAlbum[] = await fetchResult.getAllObjects();
      if (!album) {
        Log.warn(TAG, 'getMapAlbums result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getMapAlbums exception! msg: ${err}, code: ${err?.code}`);
      return [];
    }
      finally {
      fetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  public async getPhotoAssetsByUriArray(uriArr: string[], fetchColumns?: string[]):
    Promise<sendablePhotoAccessHelper.PhotoAsset[]> {
    let fetchResult: sendablePhotoAccessHelper.FetchResult<sendablePhotoAccessHelper.PhotoAsset> | undefined =
      undefined;
    Log.info(TAG, `uriArr length is : ${uriArr.length}`);
    try {
      if (!this.photoAccessHelper) {
        Log.warn(TAG, 'getPhotoAssetByUriArray photoAccessHelper undefined');
        return [];
      }
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.beginWrap();
      for (let i = 0; i < uriArr.length; i++) {
        predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uriArr[i]);
        if (i < uriArr.length - 1) {
          predicates.or();
        }
      }
      predicates.endWrap();
      if (!fetchColumns) {
        fetchColumns = [photoAccessHelper.PhotoKeys.POSITION];
      }
      let options: photoAccessHelper.FetchOptions = {
        fetchColumns: UserFileData.ALL_IMAGE_VIDEO_FETCH_COLUMNS,
        predicates: predicates,
      };
      fetchResult = await this.photoAccessHelper.getAssets(options);
      if (!fetchResult) {
        Log.warn(TAG, 'getPhotoAssetByUriArray fetchResult undefined');
        return [];
      }
      let result: Promise<sendablePhotoAccessHelper.PhotoAsset[]> = fetchResult.getAllObjects();
      return await result;
    } catch (err) {
      Log.error(TAG, `err_message:${err}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return [];
  }

  getSystemAlbumUri(subType: sendablePhotoAccessHelper.AlbumSubtype): string {
    Log.debug(TAG, `getSystemAlbumUri subType: ${subType}`);
    let uri = this.systemAlbumUriMap.get(subType);
    Log.debug(TAG, `getSystemAlbumUri uri: ${uri}`);
    return uri ?? '';
  }

  public getSharedPhotoAssets(fetchOpt: FetchOptions): SendableSharedPhotoAsset[] | undefined {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'getSharedPhotoAssets failed, photoAccessHelper invalid');
      return undefined;
    }

    return this.photoAccessHelper.getSharedPhotoAssets(fetchOpt);
  }
}