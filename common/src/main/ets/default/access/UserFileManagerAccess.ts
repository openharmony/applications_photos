/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { Log } from '../utils/Log';
import userFileManager from '@ohos.filemanagement.userFileManager';
import { Constants } from '../model/common/Constants';
import { TraceControllerUtils } from '../utils/TraceControllerUtils';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { UiUtil } from '../utils/UiUtil';
import { AlbumDefine } from '../model/browser/AlbumDefine';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG: string = 'common_UserFileManagerAccess';

export type UserFileManager = userFileManager.UserFileManager;

export type FileType = userFileManager.FileType;

export type FetchOptions = userFileManager.FetchOptions;

export type FileAsset = userFileManager.FileAsset;

export type MediaPeerInfo = userFileManager.PeerInfo;

export type Album = userFileManager.Album;

export type ImageVideoKey = userFileManager.ImageVideoKey;

export type AlbumKey = userFileManager.AlbumKey;

export type AlbumType = userFileManager.AlbumType;

export type AlbumSubType = userFileManager.AlbumSubType;

export type DefaultChangeUri = userFileManager.DefaultChangeUri;

export type ChangeData = userFileManager.ChangeData;

export type FileAssetEx = {
  count: number;
  obj: FileAsset;
};

export class UserFileManagerAccess {
  static readonly REGISTER_TYPE_IMAGE_CHANGE = 'imageChange';
  static readonly REGISTER_TYPE_VIDEO_CHANGE = 'videoChange';
  static readonly REGISTER_TYPE_DEVICE_CHANGE = 'deviceChange';
  static readonly REGISTER_TYPE_ALBUM_CHANGE = 'albumChange';
  static readonly REGISTER_TYPE_REMOTE_FILE_CHANGE = 'remoteFileChange';
  static readonly MEDIA_TYPE_IMAGE = userFileManager.FileType.IMAGE;
  static readonly MEDIA_TYPE_VIDEO = userFileManager.FileType.VIDEO;
  static readonly FILE_KEY_MEDIA_TYPE = userFileManager.ImageVideoKey.FILE_TYPE;
  static readonly FILE_KEY_DISPLAY_NAME = userFileManager.ImageVideoKey.DISPLAY_NAME;
  static readonly FILE_KEY_DATE_TAKEN = userFileManager.ImageVideoKey.DATE_ADDED;
  static readonly FILE_KEY_DATE_TRASHED = userFileManager.ImageVideoKey.DATE_TRASHED;
  static readonly FILE_KEY_TITLE = userFileManager.ImageVideoKey.TITLE;

  static readonly REGISTER_TYPE_ALL_PHOTOS = "file://media/Photo";
  static readonly REGISTER_TYPE_ALL_ALBUMS = "file://media/PhotoAlbum";
  static readonly NOTIFY_ADD = userFileManager.NotifyType.NOTIFY_ADD;
  static readonly NOTIFY_UPDATE = userFileManager.NotifyType.NOTIFY_UPDATE;
  static readonly NOTIFY_REMOVE = userFileManager.NotifyType.NOTIFY_REMOVE;
  static readonly NOTIFY_ALBUM_ADD_ASSET = userFileManager.NotifyType.NOTIFY_ALBUM_ADD_ASSET;
  static readonly NOTIFY_ALBUM_REMOVE_ASSET = userFileManager.NotifyType.NOTIFY_ALBUM_REMOVE_ASSET;

  static readonly ALL_IMAGE_VIDEO_FETCH_COLUMNS: Array<string> = [
    userFileManager.ImageVideoKey.URI.toString(),
    userFileManager.ImageVideoKey.FILE_TYPE.toString(),
    userFileManager.ImageVideoKey.DISPLAY_NAME.toString(),
    userFileManager.ImageVideoKey.DATE_ADDED.toString(),
    userFileManager.ImageVideoKey.DATE_MODIFIED.toString(),
    userFileManager.ImageVideoKey.TITLE.toString(),
    userFileManager.ImageVideoKey.DURATION.toString(),
    userFileManager.ImageVideoKey.WIDTH.toString(),
    userFileManager.ImageVideoKey.HEIGHT.toString(),
    userFileManager.ImageVideoKey.DATE_TAKEN.toString(),
    userFileManager.ImageVideoKey.ORIENTATION.toString(),
    userFileManager.ImageVideoKey.FAVORITE.toString(),
    userFileManager.ImageVideoKey.POSITION.toString(),
    userFileManager.ImageVideoKey.DATE_TRASHED.toString(),
    userFileManager.ImageVideoKey.HIDDEN.toString(),
    "size" // TODO 等媒体库枚举字段上库
  ]

  static readonly GROUP_BY_KEY: string = 'count(*)';

  static readonly IMAGE_ALBUM_SUB_TYPE: AlbumSubType = 1031; // TODO 等媒体库枚举字段上库
  static readonly CAMERA_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.CAMERA;
  static readonly FAVORITE_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.FAVORITE;
  static readonly VIDEO_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.VIDEO;
  static readonly TRASH_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.TRASH;
  static readonly SCREENSHOT_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.SCREENSHOT;
  static readonly HIDDEN_ALBUM_SUB_TYPE: AlbumSubType = userFileManager.AlbumSubType.HIDDEN;

  static readonly ALL_SYSTEM_ALBUM_LIST: Array<AlbumSubType> = [
    UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE,
    UserFileManagerAccess.SCREENSHOT_ALBUM_SUB_TYPE,
    UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE,
    UserFileManagerAccess.HIDDEN_ALBUM_SUB_TYPE,
    UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE,
  ]

  static readonly SYSTEM_BEFORE_USER_ALBUM_LIST: Array<AlbumSubType> = [
    UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE,
    UserFileManagerAccess.SCREENSHOT_ALBUM_SUB_TYPE,
    UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE
  ]

  static readonly SYSTEM_AFTER_USER_ALBUM_LIST: Array<AlbumSubType> = [
    UserFileManagerAccess.HIDDEN_ALBUM_SUB_TYPE,
    UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE
  ]

  private media: userFileManager.UserFileManager = null;
  private photoAccessHelper?: photoAccessHelper.PhotoAccessHelper;
  private requestTime: number;

  private systemAlbumUriMap: Map<AlbumSubType, string> = new Map<AlbumSubType, string>();

  constructor() {
    this.requestTime = Date.now();
  }

  public static getInstance(): UserFileManagerAccess {
    if (AppStorage.get(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS) == null) {
      AppStorage.setOrCreate(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS, new UserFileManagerAccess());
    }
    return AppStorage.get(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS);
  }

  onCreate(context) {
    Log.debug(TAG, `Photos_UserFileManagerAccess onCreate ${context}`);
    if (this.media) {
      Log.debug(TAG, `Photos_UserFileManagerAccess onCreate already`);
      return;
    }
    this.media = userFileManager.getUserFileMgr(context);
    Log.debug(TAG, 'Photos_UserFileManagerAccess onCreate end');
    if (!this.media) {
      Log.error(TAG, 'get media library instance failed!');
    }
    if (this.photoAccessHelper) {
      Log.debug(TAG, 'photoAccessHelper onCreate already');
      return;
    }
    this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'get photoAccessHelper instance failed!');
    }
    Log.info(TAG, 'onCreate done');
  }

  onDestroy() {
    try {
      this.media && this.media.release();
      this.media = null;
      Log.info(TAG, 'onDestroy done');
    } catch (err) {
      Log.error(TAG, `onDestroy error: ${err}`);
    }
  }

  getMediaLibrary(): userFileManager.UserFileManager {
    return this.media;
  }

  getSystemAlbumUriMap() {
    return this.systemAlbumUriMap;
  }

  async getAllObject(fetchOpt: FetchOptions): Promise<Array<FileAsset>> {
    Log.info(TAG, `getAllObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getAllObject] media resource is null!');
      return [];
    }
    try {
      TraceControllerUtils.startTraceWithTaskId('getAllObject', this.requestTime);
      let dataList = await this.media.getPhotoAssets(fetchOpt);
      if (!dataList) {
        Log.warn(TAG, 'get all Object Data with empty dataList');
        return [];
      }
      Log.debug(TAG, `get all Object Data raw data size: ${dataList.getCount()}`);
      if (dataList.getCount() <= 0) {
        dataList.close();
        return [];
      }

      let result = await dataList.getAllObject();
      dataList.close();
      TraceControllerUtils.finishTraceWithTaskId('getAllObject', this.requestTime);
      return result;
    } catch (error) {
      Log.error(TAG, `getAllObject error: ${error}`);
      return [];
    }
  }

  async deleteAlbumByUri(uri: string): Promise<void> {
    if (!this.media) {
      Log.error(TAG, '[deleteAlbum] media resource is null!');
      return;
    }
    try {
      Log.debug(TAG, `deleteAlbumByUri uri is ` + uri);
      let album = await this.getAlbumByUri(uri);
      await this.media.deleteAlbums([album]); // TODO 接口支持批量删除，传参后续整改
    } catch (error) {
      Log.error(TAG, `deleteAlbumByUri error: ${error}`);
      return;
    }
  }

  async getCount(fetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `getCount: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getCount] media resource is null!');
      return 0;
    }
    try {
      TraceControllerUtils.startTraceWithTaskId('getCount', this.requestTime);
      let dataList = await this.media.getPhotoAssets(fetchOpt);
      if (!dataList) {
        Log.warn(TAG, 'get count dataList is 0');
        return 0;
      }
      Log.debug(TAG, `get count raw data size: ${dataList.getCount()}`);
      let result = dataList.getCount();
      dataList.close();
      TraceControllerUtils.finishTraceWithTaskId('getCount', this.requestTime);
      return result;
    } catch (error) {
      Log.error(TAG, `get Count error:  ${error}`);
      return 0;
    }
  }

  async getObject(fetchOpt: FetchOptions): Promise<FileAsset> {
    Log.info(TAG, `getObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getObject] media resource is null!');
      return undefined;
    }
    try {
      TraceControllerUtils.startTraceWithTaskId('getObject', this.requestTime);
      let fileResult = await this.media.getPhotoAssets(fetchOpt);
      if (fileResult) {
        Log.info(TAG, `getObject count is ${fileResult.getCount()}`);
        if (fileResult.getCount() <= 0) {
          fileResult.close();
          return undefined;
        }
        let file = await fileResult.getFirstObject();
        fileResult.close();
        if (file) {
          return file;
        } else {
          Log.error(TAG, 'Failed getObject');
        }
      }
      TraceControllerUtils.finishTraceWithTaskId('getObject', this.requestTime);
      return undefined;
    } catch (error) {
      Log.error(TAG, `getObject loadData error: ${error}`);
      return undefined;
    }
  }

  async getFirstObject(fetchOpt: FetchOptions): Promise<FileAssetEx> {
    let result = {
      count: 0,
      obj: null
    }
    Log.info(TAG, `getFirstObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getFirstObject] media resource is null!');
      return result;
    }
    try {
      TraceControllerUtils.startTraceWithTaskId('getFirstObject', this.requestTime);
      let fileResult = await this.media.getPhotoAssets(fetchOpt);
      if (fileResult) {
        result.count = fileResult.getCount();
        Log.info(TAG, `getFirstObject count is ${result.count}`);
        if (result.count <= 0) {
          fileResult.close();
          return result;
        }
        let file = await fileResult.getFirstObject();
        fileResult.close();
        if (file) {
          result.obj = file;
          return result;
        } else {
          Log.error(TAG, 'Failed getFirstObject');
        }
      }
      TraceControllerUtils.finishTraceWithTaskId('getFirstObject', this.requestTime);
      return result;
    } catch (error) {
      Log.error(TAG, `getFirstObject loadData error: ${error}`);
      return result;
    }
  }

  async deleteAlbumPhotos(uri: String): Promise<void> {
    Log.debug(TAG, `deleteAsset uri: ${uri}`);
    if (!this.media) {
      Log.error(TAG, '[deleteAsset] media resource is null!');
      return;
    }

    // 获取回收站内的文件
    let predicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };

    try {
      const fetchResult = await this.media.getPhotoAssets(fetchOptions);
      var asset = await fetchResult.getFirstObject();
    } catch (err) {
      console.info('fetch failed, message =', err);
    }

    if (asset == undefined) {
      console.error('asset not exist');
      return;
    }
    try {
      await this.media.delete(asset.uri);
      console.info("delete successfully");
    } catch (err) {
      console.error("delete failed with error: " + err);
    }
  }

  async createAsset(mediaType: FileType, displayName: string): Promise<FileAsset> {
    Log.debug(TAG, 'createAsset start');
    if (!this.media) {
      Log.error(TAG, '[createAsset] media resource is null!');
      return null;
    }
    Log.info(TAG, `createAsset ${mediaType} ${displayName} `);
    let fileAsset = await this.media.createPhotoAsset(displayName);
    Log.debug(TAG, `createAsset end. new fileAsset: ${fileAsset}`);
    if (!fileAsset) {
      Log.error(TAG, 'createAsset Fail');
      return null;
    }
    return fileAsset;
  }

  async openAsset(mode: string, fileAsset: FileAsset): Promise<number> {
    Log.debug(TAG, 'openAsset start');
    if (!fileAsset) {
      Log.error(TAG, 'fileAsset is null');
      return;
    }
    let fd = await fileAsset.open(mode);
    Log.info(TAG, `openAsset end. fd: ${fd}`);
    if (fd <= 0) {
      Log.error(TAG, 'openAsset Fail');
      return;
    }
    return fd;
  }

  async closeAsset(fd: number, fileAsset: FileAsset): Promise<void> {
    Log.debug(TAG, 'closeAsset start');
    if (!fileAsset) {
      Log.error(TAG, 'fileAsset is null');
      return;
    }
    try {
      await fileAsset.close(fd);
    } catch (err) {
      Log.error(TAG, 'file asset close error: ' + JSON.stringify(err));
    }
  }

  async deleteToTrash(uris: Array<string>): Promise<void> {
    TraceControllerUtils.startTrace('deleteToTrash');
    Log.info(TAG, 'deleteToTrash() start');
    let startTime: number = Date.now();
    try {
      await this.photoAccessHelper.deleteAssets(uris);
    } catch (error) {
      Log.error(TAG, `photoAccessHelper deleteAssets error: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, 'deleteToTrash() cost: ' + (Date.now() - startTime));
    TraceControllerUtils.finishTrace('deleteToTrash');
  }

  async deleteFromTrash(assets: Array<FileAsset>): Promise<void> {
    TraceControllerUtils.startTrace('deleteFromTrash');
    Log.info(TAG, 'deleteFromTrash() start');
    let startTime: number = Date.now();
    let fetchResult = await (this.media as userFileManager.UserFileManager).getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
    let trashAlbum = await fetchResult.getFirstObject();
    await trashAlbum.deletePhotoAssets(assets);
    fetchResult.close();
    Log.info(TAG, 'deleteFromTrash() cost: ' + (Date.now() - startTime));
    TraceControllerUtils.finishTrace('deleteFromTrash');
  }

  async recoverFromTrash(assets: Array<FileAsset>): Promise<void> {
    let startTime: number = Date.now();
    let fetchResult = await (this.media as userFileManager.UserFileManager).getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
    let trashAlbum = await fetchResult.getFirstObject();
    await trashAlbum.recoverPhotoAssets(assets);
    fetchResult.close();
    Log.info(TAG, 'recoverFromTrash() cost: ' + (Date.now() - startTime));
  }

  async getTrashAssetByUri(assetUri: string): Promise<FileAsset> {
    Log.info(TAG, "getTrashAssetByUri");
    let trashAlbumResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
    let trashAlbum = await trashAlbumResult.getFirstObject();
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(userFileManager.ImageVideoKey.URI.toString(), assetUri);
    let fetchOption: userFileManager.FetchOptions = {
      predicates: predicates,
      fetchColumns: []
    };
    fetchOption.fetchColumns = Array.prototype.slice.call(UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS);
    let fetchResult = await trashAlbum.getPhotoAssets(fetchOption);
    let assets = await fetchResult.getFirstObject();
    fetchResult.close();
    trashAlbumResult.close();
    return assets;
  }

  async getFavoriteObject(fetchOpt: FetchOptions): Promise<Array<FileAsset>> {
    if (!this.media) {
      Log.error(TAG, '[getFavoriteObject] media resource is null!');
      return [];
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.FAVORITE);
      let favoriteAlbum = await fetchResult.getFirstObject();
      let fileFetchResult = await favoriteAlbum.getPhotoAssets(fetchOpt)
      Log.info(TAG, `[getFavoriteObject] get smart albums length:${fileFetchResult.getCount()} name:${favoriteAlbum.albumName}`);
      Log.debug(TAG, `[getFavoriteObject] object count :${fileFetchResult.getCount()}`);
      let objects = await fileFetchResult.getAllObject();
      Log.debug(TAG, `[getFavoriteObject] objects done`);
      fileFetchResult.close();
      fetchResult.close();
      return objects;
    } catch (err) {
      Log.error(TAG, `Get favorite object exception! msg:  ${err}`);
      return [];
    }
  }

  async getTrashObject(fetchOpt: FetchOptions): Promise<Array<FileAsset>> {
    Log.info(TAG, `Get trash object: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getTrashObject] media resource is null!');
      return [];
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
      let trashAlbum = await fetchResult.getFirstObject();
      let fileFetchResult = await trashAlbum.getPhotoAssets(fetchOpt)
      Log.debug(TAG, `[getTrashObject] object count :${fileFetchResult.getCount()}`);
      let objects = await fileFetchResult.getAllObject();
      Log.debug(TAG, `[getTrashObject] get objects done`);
      fileFetchResult.close();
      fetchResult.close();
      return objects;
    } catch (err) {
      Log.error(TAG, `Get Trash Object exception! msg: ${err}`);
      return [];
    }
  }

  async getUserAlbumObject(fetchOpt: FetchOptions, fileFetchOpt: FetchOptions): Promise<Array<FileAsset>> {
    Log.info(TAG, `getEntityAlbumObject opt${JSON.stringify(fetchOpt)} fileOpt${JSON.stringify(fileFetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getEntityAlbumObject] media resource is null!');
      return [];
    }
    try {
      // 按照fetchOpt获取用户指定的相册---游标
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOpt);

      //获取所有的相册的
      let albums = await fetchResult.getAllObject();
      if (albums.length === 0) {
        return [];
      }
      let objects = [];
      for (let i = 0; i < albums.length; i++) {
        let album = albums[i];
        Log.debug(TAG, `[getEntityAlbumObject]Albums name:${album.albumName}  index: ${i}`);
        // 返回一个游标
        let fileResult = await album.getPhotoAssets(fileFetchOpt);
        Log.debug(TAG, `[getEntityAlbumObject]objects count :${fileResult.getCount()}`);
        if (fileResult.getCount() <= 0) {
          fileResult.close();
          continue;
        }
        //获取该album游标下的所有资源
        objects = await fileResult.getAllObject();
        Log.debug(TAG, `[getEntityAlbumObject]Get objects done`);
        fileResult.close();
      }
      fetchResult.close();
      return objects;
    } catch (err) {
      Log.error(TAG, `Get Entity Album Object exception! msg:  ${err}`);
      return [];
    }
  }

  async getFavoriteCount(favoriteFetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `[getFavoriteCount] FetchOptions: ${JSON.stringify(favoriteFetchOpt)}`);
    return await this.getSystemAlbumCount(favoriteFetchOpt, userFileManager.AlbumSubType.FAVORITE);
  }

  async getTrashCount(trashFetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `[getTrashCount] FetchOptions: ${JSON.stringify(trashFetchOpt)}`);
    return await this.getSystemAlbumCount(trashFetchOpt, userFileManager.AlbumSubType.TRASH);
  }

  async getSystemAlbumCount(fetchOpt: FetchOptions, albumSubType: userFileManager.AlbumSubType): Promise<number> {
    Log.info(TAG, `[getTrashCount] FetchOptions: ${JSON.stringify(fetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getTrashCount] media resource is null!');
      return 0;
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, albumSubType);
      let systemAlbum = await fetchResult.getFirstObject();
      let fileFetchResult = await systemAlbum.getPhotoAssets(fetchOpt)
      let count = fileFetchResult.getCount();
      fileFetchResult.close();
      fetchResult.close();
      return count;
    } catch (err) {
      Log.error(TAG, `Get Trash count exception! msg: ${err}`);
      return 0;
    }
  }

  async getAlbumFirstObject(album: Album): Promise<FileAsset> {
    Log.info(TAG, `[getAlbumFirstObject]`);
    if (!this.media) {
      Log.error(TAG, '[getAlbumFirstObject] media resource is null!');
      return undefined;
    }
    try {
      let opt = AlbumDefine.getFileFetchOpt(0, 1);
      let fetchResult = await album.getPhotoAssets(opt);
      if (!fetchResult) {
        Log.error(TAG, 'fetchResult is null');
      }
      let fileAsset = await fetchResult.getFirstObject();
      fetchResult.close();
      Log.info(TAG, `cover uri ${fileAsset.uri}`);
      return fileAsset;
    } catch (err) {
      Log.error(TAG, `Get album first obj exception! msg: ${err}`);
      return undefined;
    }
  }

  async getUserAlbumCount(albumFetchOpt: FetchOptions, fileFetchOpt?: FetchOptions): Promise<number> {
    Log.info(TAG, `getUSerAlbumCount FetchOptions: ${JSON.stringify(albumFetchOpt)}`);
    if (!this.media) {
      Log.error(TAG, '[getTrashCount] media resource is null!');
      return 0;
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, albumFetchOpt);
      let userAlbum = await fetchResult.getFirstObject();
      let fileFetchResult = await userAlbum.getPhotoAssets(fileFetchOpt);
      let count = fileFetchResult.getCount();
      fileFetchResult.close();
      fetchResult.close();
      return count;
    } catch (err) {
      Log.error(TAG, `Get Trash count exception! msg: ${err}`);
      return 0;
    }
  }

  async getUserAlbums(fetchOpt?: FetchOptions): Promise<Array<Album>> {
    Log.info(TAG, `getUserAlbums start}`);
    if (!this.media) {
      Log.error(TAG, '[getUserAlbums] media resource is null!');
      return [];
    }
    try {
      let fetchResult;
      if (fetchOpt) {
        fetchResult = await this.media.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOpt);
      } else {
        fetchResult = await this.media.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC);
      }
      let userAlbums = await fetchResult.getAllObject();
      Log.info(TAG, `[getUserAlbums]length :${userAlbums.length}`);
      fetchResult.close();
      return userAlbums;
    } catch (err) {
      Log.error(TAG, `Get User Album exception! msg:  ${err}`);
      return [];
    }
  }

  async prepareSystemAlbums(): Promise<void> {
    if (!this.media) {
      Log.error(TAG, 'prepareSystemAlbums media resource is null!');
      return;
    }
    try {
      for (let i = 0; i < UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
        let albumSubType = UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
        let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, albumSubType);
        let systemAlbum = await fetchResult.getFirstObject();
        this.systemAlbumUriMap.set(albumSubType, systemAlbum.albumUri);
        Log.info(TAG, `prepareSystemAlbums before :${systemAlbum.albumUri}, ${albumSubType}`);
        fetchResult.close();
      }
      for (let i = 0; i < UserFileManagerAccess.SYSTEM_AFTER_USER_ALBUM_LIST.length; i++) {
        let albumSubType = UserFileManagerAccess.SYSTEM_AFTER_USER_ALBUM_LIST[i];
        let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, albumSubType);
        let systemAlbum = await fetchResult.getFirstObject();
        this.systemAlbumUriMap.set(albumSubType, systemAlbum.albumUri);
        Log.info(TAG, `prepareSystemAlbums after :${systemAlbum.albumUri}, ${albumSubType}`);
        fetchResult.close();
      }
      return;
    } catch (err) {
      Log.error(TAG, `prepareSystemAlbums Get System Album exception! msg:  ${err}`);
      return;
    }
  }

  async getSystemAlbums(): Promise<Array<Album>> {
    if (!this.media) {
      Log.error(TAG, 'getSystemAlbums media resource is null!');
      return undefined;
    }
    try {
      let systemAlbumList: Array<Album> = [];
      for (let i = 0; i < UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
        let albumSubType = UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
        let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, albumSubType);
        let systemAlbum = await fetchResult.getFirstObject();
        this.systemAlbumUriMap.set(albumSubType, systemAlbum.albumUri);
        systemAlbumList.push(systemAlbum);
        Log.info(TAG, `getSystemAlbums :${systemAlbum.albumUri}`);
        fetchResult.close();
      }
      return systemAlbumList;
    } catch (err) {
      Log.error(TAG, `getSystemAlbums Get System Album exception! msg:  ${err}`);
      return undefined;
    }
  }

  async getTrashAlbum(): Promise<Album> {
    if (!this.media) {
      Log.error(TAG, 'getTrashAlbum media resource is null!');
      return undefined;
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
      let trashAlbum: Album = await fetchResult.getFirstObject();
      this.systemAlbumUriMap.set(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE, trashAlbum.albumUri);
      Log.info(TAG, `getTrashAlbum : ${trashAlbum.albumUri}`);
      fetchResult.close();
      return trashAlbum;
    } catch (err) {
      Log.error(TAG, `getTrashAlbum Get Trash Album exception! msg:  ${err}`);
      return undefined;
    }
  }

  async getHiddenAlbum(): Promise<Album> {
    if (!this.media) {
      Log.error(TAG, 'getHiddenAlbum media resource is null!');
      return undefined;
    }
    try {
      let fetchResult = await this.media.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.HIDDEN);
      let hiddenAlbum: Album = await fetchResult.getFirstObject();
      Log.info(TAG, `getHiddenAlbum : ${hiddenAlbum.albumUri}`);
      fetchResult.close();
      return hiddenAlbum;
    } catch (err) {
      Log.error(TAG, `getHiddenAlbum Get Hidden Album exception! msg:  ${err}`);
      return undefined;
    }
  }

  async addFileToAlbum(albumUri: string, sourceAsset: FileAsset) {
    if (!this.media) {
      Log.error(TAG, '[getHiddenAlbum] media resource is null!');
      return undefined;
    }
    Log.debug(TAG, `addFileToAlbum albumUri is ` + albumUri + ` sourceAsset is ` + sourceAsset);
    let album = await this.getAlbumByUri(albumUri);
    await album.addPhotoAssets([sourceAsset]); // TODO 媒体库支持批量添加，传参后续整改
  }

  isImage(fileAsset: FileAsset): boolean {
    return fileAsset.fileType === userFileManager.FileType.IMAGE;
  }

  isSystemAlbum(album: Album): boolean {
    return album.albumType === userFileManager.AlbumType.SYSTEM;
  }

  isTrashAlbum(album: Album): boolean {
    return album.albumSubType === userFileManager.AlbumSubType.TRASH;
  }

  isScreenShotAlbum(album: Album): boolean {
    return album.albumSubType === userFileManager.AlbumSubType.SCREENSHOT;
  }

  isPhotoAlbum(album: Album): boolean {
    return album.albumSubType === UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE;
  }

  isVideoAlbum(album: Album): boolean {
    return album.albumSubType === userFileManager.AlbumSubType.VIDEO;
  }

  isFavorAlbum(album: Album): boolean {
    return album.albumSubType === userFileManager.AlbumSubType.FAVORITE;
  }

  async getAlbumName(album: Album): Promise<string> {
    if (this.isSystemAlbum(album)) {
      // 系统相册，图库自己命名
      switch (album.albumSubType) {
        case UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE:
          return await UiUtil.getResourceString($r('app.string.album_photos'));
        case UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE:
          return await UiUtil.getResourceString($r('app.string.album_favor'));
        case UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE:
          return await UiUtil.getResourceString($r('app.string.album_video'));
        case UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE:
          return await UiUtil.getResourceString($r('app.string.album_recycle'));
        case UserFileManagerAccess.SCREENSHOT_ALBUM_SUB_TYPE:
          return await UiUtil.getResourceString($r('app.string.album_screen_shot'));
        default:
          return '';
      }
    }
    // 用户相册，直接返回
    return album.albumName;
  }

  getAlbumDateModified(album: Album): number {
    return album.dateModified;
  }

  /**
   * 根据Uri获取相册，不区分系统相册和用户相册
   * @param albumUri 相册Uri
   * @returns 目标相册
   */
  async getAlbumByUri(albumUri: string): Promise<Album> {
    Log.debug(TAG, 'getAlbumByUri albumUri is ' + albumUri);
    if (!this.media) {
      Log.error(TAG, 'getAlbumByUri media resource is null!');
      return undefined;
    }
    try {
      let albumFetchOpt = AlbumDefine.getAlbumFetchOptByUri(albumUri);
      // @ts-ignore // TODO 支持不传入type时删掉 ts-ignore
      let fetchResult: userFileManager.FetchResult<Album> = await this.media.getAlbums(albumFetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbumByUri return null');
        return undefined;
      }
      Log.debug(TAG, `getAlbumByUri return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        fetchResult.close();
        return undefined;
      }
      let album = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, `getAlbumByUri result is null`);
      }
      fetchResult.close();
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}`);
      return undefined;
    }
  }

  async getAlbumByName(albumName: string): Promise<Album> {
    if (!this.media) {
      Log.error(TAG, 'getAlbumByName media resource is null!');
      return undefined;
    }
    try {
      Log.info(TAG, `getAlbumByName name: ${albumName}`);
      let albumFetchOpt = AlbumDefine.getAlbumFetchOptByName(albumName);
      // @ts-ignore  // TODO 需要媒体库新开接口，支持仅传入fetchOpt
      let fetchResult: userFileManager.FetchResult<Album> = await this.media.getAlbums(albumFetchOpt);
      if (!fetchResult) {
        Log.error(TAG, 'getAlbumByName fetchResult undefined')
        return undefined;
      }
      if (fetchResult.getCount() <= 0) {
        fetchResult.close();
        return undefined;
      }
      let album = await fetchResult.getFirstObject();
      if (!album) {
        Log.error(TAG, 'getAlbumByName album undefined')
        return undefined;
      }
      Log.info(TAG, `getAlbumByName get album success ${JSON.stringify(album)}`)
      fetchResult.close();
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbumByName exception! msg:  ${err}`);
      return undefined;
    }
  }

  getSystemAlbumUri(subType: userFileManager.AlbumSubType): string {
    Log.debug(TAG, `getSystemAlbumUri subType: ${subType}`);
    let uri = this.systemAlbumUriMap.get(subType);
    Log.debug(TAG, `getSystemAlbumUri uri: ${uri}`);
    return uri;
  }

  async createUserAlbum(albumName: string): Promise<Album> {
    let album: Album = undefined;
    try {
      album = await this.media.createAlbum(albumName);
    } catch (error) {
      Log.error(TAG, `deleteAlbumByUri error: ${error}`);
    }
    return album;
  }

  async renameAlbum(album: Album, name: string): Promise<void> {
    if (!this.media) {
      Log.error(TAG, '[renameAlbum] media resource is null!');
      return;
    }
    try {
      album.albumName = name;
      album.commitModify();
    } catch (err) {
      Log.error(TAG, `Rename Album exception! msg:  ${err}`);
      return;
    }
  }

  // 判断当前图库是否有相同名字的系统相册，跟随多语言变化
  async isAlbumNameExistInSystemAlbums(name: string): Promise<boolean> {
    for (let i = 0; i < UserFileManagerAccess.ALL_SYSTEM_ALBUM_LIST.length; i++) {
      let systemAlbumName: string;
      switch (UserFileManagerAccess.ALL_SYSTEM_ALBUM_LIST[i]) {
        case UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE:
          systemAlbumName = await UiUtil.getResourceString($r('app.string.album_photos'));
          break;
        case UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE:
          systemAlbumName = await UiUtil.getResourceString($r('app.string.album_favor'));
          break;
        case UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE:
          systemAlbumName = await UiUtil.getResourceString($r('app.string.album_video'));
          break;
        case UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE:
          systemAlbumName = await UiUtil.getResourceString($r('app.string.album_recycle'));
          break;
        case UserFileManagerAccess.SCREENSHOT_ALBUM_SUB_TYPE:
          systemAlbumName = await UiUtil.getResourceString($r('app.string.album_screen_shot'));
          break;
        default:
          break;
      }
      if (systemAlbumName === name) {
        return true;
      }
    }
    return false;
  }
}

/**
 * 文件fetchOption
 */
export class FileFetchOptionBuilder {
  private fetchOption: userFileManager.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: []
  };

  constructor(fetchOpt?) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }
    this.fetchOption.fetchColumns = Array.prototype.slice.call(UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS) // 暂时获取所有columns
  }

  build(): FetchOptions {
    return this.fetchOption;
  }

  // 用于timeline分组查询
  groupBy(): FileFetchOptionBuilder {
    this.fetchOption.fetchColumns.push(UserFileManagerAccess.GROUP_BY_KEY);
    return this;
  }

  media(mediaType: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.ImageVideoKey.FILE_TYPE.toString(), mediaType)
    return this;
  }

  uri(uri: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.ImageVideoKey.URI.toString(), uri)
    return this;
  }

  order(key: string, isAsc = true): FileFetchOptionBuilder {
    if (isAsc) {
      //升序
      this.fetchOption.predicates.orderByAsc(key);
    } else {
      //降序
      this.fetchOption.predicates.orderByDesc(key);
    }
    return this;
  }

  logicalAnd(): FileFetchOptionBuilder {
    this.fetchOption.predicates.and();
    return this;
  }

  select(start: number, count: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.limit(count, start);
    return this;
  }

  displayName(name: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.ImageVideoKey.DISPLAY_NAME.toString(), name);
    return this;
  }

  fetchColumns(columns: Array<string>): FileFetchOptionBuilder {
    this.fetchOption.fetchColumns = columns;
    return this;
  }
}

/**
 * 相册fetchOption
 */
export class AlbumFetchOptionBuilder {
  private fetchOption: userFileManager.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: []
  };

  constructor(fetchOpt?) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }
  }

  build(): FetchOptions {
    return this.fetchOption;
  }

  media(mediaType: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.AlbumKey.FILE_TYPE.toString(), mediaType)
    return this;
  }

  logicalAnd(): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.and();
    return this;
  }

  albumName(name: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.AlbumKey.ALBUM_NAME.toString(), name);
    return this;
  }

  albumUri(uri: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(userFileManager.AlbumKey.URI.toString(), uri);
    return this;
  }
}