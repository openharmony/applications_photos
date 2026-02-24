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
import lazy { Constants } from '../model/common/Constants';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { AlbumDefine, QueryType } from '../model/browser/AlbumDefine';
import type common from '@ohos.app.ability.common';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { AsyncCallback } from '../model/common/AsyncCallback';
import lazy { nowOverOneWeek, userAlbumsCountReport } from '../utils/StatisticReportUtil';
import lazy { PhotoAccessHelperAccess } from './PhotoAccessHelperAccess';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { fileIo as fs } from '@kit.CoreFileKit';
import lazy { CommonContext } from '../model/browser/photo/TimelineDataManager';
import lazy { HashMap, MessageEvents, util, worker } from '@kit.ArkTS';
import lazy { SelectParams } from '../model/common/SelectParams';
import lazy { QueryParam, QueryAlbumParam } from '../interface/BrowserDataInterface';
import lazy { FilterConditions } from '../model/FilterConditions';
import lazy { systemDateTime } from '@kit.BasicServicesKit';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { findAddressSerialPipe } from '../utils/SerialPipe'
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { AlbumGridSortHelper, SortRuleString } from '../model/AlbumGridSortHelper';
import lazy Global from '../utils/GlobalContext';
import lazy { PickerAlbumsFilterEnhanceBuilder } from '../model/PickerFilterEnhanceBuilder'
import lazy { FileFetchOptionBuilder, AlbumFetchOptionBuilder, } from '../model/FetchOption';
import lazy {
  getMovePageAlbumsCountFilterUnionAlbumsFetchOption,
  getMovePageAlbumsFetchOption,
  getAllSortedAlbumsFetchOption,
  getSortedNormalAlbumsFetchOption,
  getNormalAlbumsFetchOption,
  getNormalAlbumCountFilterUnionAlbumsFetchOption,
  getUnionAlbumsCountFetchOption,
  getListAreaAlbumCountFilterUnionAlbumsFetchOption,
  getPhotoAlbumOrderFetchOption,
  getCheckForUnsortedAlbumsFetchOption,
  getJudgeAlbumSortedByNameFetchOption,
  getMyAlbumCountFilterUnionAlbumsFetchOption,
  getSortedSystemAlbumsFetchOption,
  getSortedMyAlbumsFetchOption,
  getListAreaAlbumsFetchOption,
  getSortedListAreaAlbumsFetchOption,
  getSystemAlbumCountFilterUnionAlbumsFetchOption,
} from './AlbumSortFetchOptions';
import lazy { OrderStyle } from '../model/common/AlbumSortConstants';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AlbumSetDataSourceManager } from '../model/browser/album/AlbumSetDataSourceManager';

/* instrument ignore file */
const TAG: string = 'UserFileManagerAccess';

export type UserFileManager = photoAccessHelper.PhotoAccessHelper;

// 媒体库AnalysisAlbum表中字段
const IS_Me_Key: string = 'is_me';

// 媒体库做了内部处理，图库传2表示查询“是我”的照片
const IS_ME_VALUE: number = 2;
const LOCAL: number = 1;
const LOCAL_AND_CLOUD: number = 3;

const API_RESPONSE_NO_DATA: number = 95271002;

const API_RESPONSE_INDEX_NOT_FOUND: number = 95271003;

const SHOOTING_MODE_TAG: string = 'shooting_mode_tag';
 
const FRONT_CAMERA: string = 'front_camera';

export const START_CREATE_THUMBNAIL_TASK = 'startCreateThumbnailTask';

export const STOP_CREATE_THUMBNAIL_TASK = 'stopCreateThumbnailTask';

const FAVORITE_NUMBER: number = 3;

const MORE_PAGE_NUMBER: number = 2;

const HOME_PAGE_NUMBER: number = 1;

export type FileType = photoAccessHelper.PhotoType;

export type FetchOptions = photoAccessHelper.FetchOptions;

export type PhotoAsset = photoAccessHelper.PhotoAsset;

export type ImageVideoKey = photoAccessHelper.PhotoKeys;

export type AlbumKey = photoAccessHelper.AlbumKeys;

export type AlbumType = photoAccessHelper.AlbumType;

export type AlbumSubType = photoAccessHelper.AlbumSubtype;

export type DefaultChangeUri = photoAccessHelper.DefaultChangeUri;

export type ChangeData = photoAccessHelper.ChangeData;

export type AlbumChangeInfos = photoAccessHelper.AlbumChangeInfos;

export type AlbumChangeData = photoAccessHelper.AlbumChangeData;

export type PhotoAlbum = photoAccessHelper.Album;

export type MovingPhoto = photoAccessHelper.MovingPhoto;

export type FetchAlbumResult = photoAccessHelper.FetchResult<PhotoAlbum>;

export type AlbumOrder = photoAccessHelper.AlbumOrder;

export type FetchAssetResult = photoAccessHelper.FetchResult<PhotoAsset>;

export interface FileAssetEx {
  count: number;
  obj?: PhotoAsset;
}

export interface MediaCount {
  isQueryFail?: boolean,
  imageCount: number;
  videoCount: number;
}

export interface YearMonthGroupInfo {
  count: number;
  startDate: number;
  endDate: number;
}

export interface HighlightAnalyzedProcess {
  highlightProcess: number;
  highlightProcessPct: string;
  totalCount: number;
}

export function toString(obj: Object | undefined): string {
  return JSON.stringify(obj);
}

export class AlbumCountAndPhotoAsset {
  private count: number;
  private coverAsset: photoAccessHelper.PhotoAsset | undefined;

  public constructor(count: number, coverAsset: photoAccessHelper.PhotoAsset | undefined) {
    this.count = count;
    this.coverAsset = coverAsset;
  }

  public getCount(): number {
    return this.count;
  }

  public getAsset(): photoAccessHelper.PhotoAsset | undefined {
    return this.coverAsset;
  }
}

export class UserFileManagerAccess {
  public static readonly MEDIA_TYPE_IMAGE = photoAccessHelper.PhotoType.IMAGE;
  public static readonly MEDIA_TYPE_VIDEO = photoAccessHelper.PhotoType.VIDEO;
  public static readonly SUB_TYPE_DEFAULT = photoAccessHelper.PhotoSubtype.DEFAULT;
  public static readonly SUB_TYPE_SCREENSHOT = 1//photoAccessHelper.PhotoSubtype.SCREENSHOT;
  public static readonly SUB_TYPE_MOVING_PHOTO = photoAccessHelper.PhotoSubtype.MOVING_PHOTO;
  public static readonly SUB_TYPE_BURST = photoAccessHelper.PhotoSubtype.BURST;
  public static readonly FILE_KEY_MEDIA_TYPE = photoAccessHelper.PhotoKeys.PHOTO_TYPE;
  public static readonly FILE_KEY_DISPLAY_NAME = photoAccessHelper.PhotoKeys.DISPLAY_NAME;
  public static readonly FILE_KEY_DATE_ADDED = photoAccessHelper.PhotoKeys.DATE_ADDED;
  public static readonly FILE_KEY_DATE_TAKEN_MS = photoAccessHelper.PhotoKeys.DATE_TAKEN_MS;
  public static readonly FILE_KEY_DATE_ADDED_MS = photoAccessHelper.PhotoKeys.DATE_ADDED_MS;
  public static readonly FILE_KEY_DATE_TRASHED = 'date_trashed'//photoAccessHelper.PhotoKeys.DATE_TRASHED;
  public static readonly FILE_KEY_GROUP_COUNT = 'count';
  public static readonly BUSINESS_ERROR_INVALID_COLUMN = 14000014;
  public static readonly FILE_KEY_DATE_DELETED = 'date_deleted';
  public static readonly FILE_KEY_OWNER_ALBUM_ID = 'owner_album_id';
  public static readonly FILE_KEY_TITLE = photoAccessHelper.PhotoKeys.TITLE;
  public static readonly FILE_KEY_CE_AVAILABLE = 'ce_available'//photoAccessHelper.PhotoKeys.CE_AVAILABLE;
  public static readonly FILE_KEY_THUMBNAIL_READY = 'thumbnail_ready';
  public static readonly FILE_KEY_LAST_VISIT_TIME = 'last_visit_time';
  public static readonly FILE_KEY_THUMBNAIL_VISIBLE = 'thumbnail_visible';
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
  public static readonly FILE_KEY_DATE_DAY = 'date_day'//photoAccessHelper.PhotoKeys.DATE_DAY;
  public static readonly FILE_KEY_FILE_ID = 'file_id';
  public static readonly GET_ASSERT_WITHOUT_CLOUD = 10000;
  public static readonly GET_ASSERT_WITHOUT_LOCAL = 10001;
  public static readonly GET_ASSERT_WITHOUT_BURST_PHOTO = 10004;
  public static readonly FILE_KEY_SIZE = photoAccessHelper.PhotoKeys.SIZE;
  public static readonly FILE_LOCAL_CLOUD_BOTH = 3;
  //无LCD
  public static readonly LCD_VISIT_TIME = 'lcd_visit_time';
  //无缩略图
  public static readonly THUMB_STATUS = 'thumb_status';
  public static readonly LCD_VISIT_TIME_VALUE = 0;
  public static readonly THUMB_STATUS_VALUE = 3;
  // 云上和本地都有
  public static readonly FILE_LOCATION_BOTH = 2;
  //本地图片上云后
  public static readonly FILE_LOCATION_LOCAL_CLOUD = 3;
  public static readonly FETCH_COLUMNS_MIME_TYPE = 'mime_type';
  public static readonly FETCH_COLUMNS_SIZE = 'size';
  public static readonly BURST_KEY = 'burst_key';
  public static readonly SHOOTING_MODE_TAG = 'shooting_mode_tag';
  public static readonly THUMBNAIL_READY_VALUE = '2';
  public static readonly THUMBNAIL_VISIBLE_VALUE = 1;
  public static readonly THUMBNAIL_INVISIBLE_VALUE = 0;
  public static readonly ALL_IMAGE_VIDEO_FETCH_COLUMNS: string[] = [
    UserFileManagerAccess.FILE_KEY_FILE_ID,
    photoAccessHelper.PhotoKeys.URI.toString(),
    // photoAccessHelper.PhotoKeys.DATE_TRASHED,
    'date_trashed',
    photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
    photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
    photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
    photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
    photoAccessHelper.PhotoKeys.TITLE.toString(),
    // photoAccessHelper.PhotoKeys.CE_AVAILABLE.toString(),
    'ce_available',
    photoAccessHelper.PhotoKeys.DURATION.toString(),
    photoAccessHelper.PhotoKeys.WIDTH.toString(),
    photoAccessHelper.PhotoKeys.HEIGHT.toString(),
    photoAccessHelper.PhotoKeys.DATE_TAKEN_MS.toString(),
    photoAccessHelper.PhotoKeys.DETAIL_TIME.toString(),
    photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
    photoAccessHelper.PhotoKeys.FAVORITE.toString(),
    photoAccessHelper.PhotoKeys.POSITION.toString(),
    //photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(),
    'date_trashed_ms',
    // photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE.toString(),
    'moving_photo_effect_mode',
    photoAccessHelper.PhotoKeys.DYNAMIC_RANGE_TYPE.toString(),
    photoAccessHelper.PhotoKeys.COVER_POSITION.toString(),
    // photoAccessHelper.PhotoKeys.HIDDEN.toString(),
    'hidden',
    // photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE.toString(),
    'moving_photo_effect_mode',
    UserFileManagerAccess.FETCH_COLUMNS_SIZE, // Waiting: 等媒体库枚举字段上库
    UserFileManagerAccess.FETCH_COLUMNS_MIME_TYPE,
    UserFileManagerAccess.BURST_KEY, // 连拍关键字
    PhotoAccessHelperAccess.FETCH_COLUMNS_LCD_SIZE,
    PhotoAccessHelperAccess.FETCH_COLUMNS_THM_SIZE,
    UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS,
    PhotoAccessHelperAccess.FETCH_COLUMNS_THM_SIZE,
    UserFileManagerAccess.FILE_KEY_THUMBNAIL_READY.toString(), // 增加缩略图生成时间
    PhotoAccessHelperAccess.FETCH_COLUMNS_PHOTO_QUALITY,
    PhotoAccessHelperAccess.FETCH_COLUMNS_IS_CE_AUTO,
    UserFileManagerAccess.SHOOTING_MODE_TAG,
    'original_subtype',
    SHOOTING_MODE_TAG,
    FRONT_CAMERA
  ];
  public static readonly GROUP_BY_KEY: string = 'count(*)';
  public static readonly IMAGE_ALBUM_SUB_TYPE: AlbumSubType = 1031; // Waiting: 等媒体库枚举字段上库
  public static readonly CAMERA_ALBUM_SUB_TYPE: AlbumSubType = photoAccessHelper.AlbumSubtype.CAMERA;
  public static readonly FAVORITE_ALBUM_SUB_TYPE: AlbumSubType = photoAccessHelper.AlbumSubtype.FAVORITE;
  public static readonly VIDEO_ALBUM_SUB_TYPE: AlbumSubType = photoAccessHelper.AlbumSubtype.VIDEO;
  public static readonly TRASH_ALBUM_SUB_TYPE: AlbumSubType = photoAccessHelper.AlbumSubtype.TRASH;
  public static readonly SOURCE_GENERIC_ALBUM_SUB_TYPE: AlbumSubType = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  public static readonly ALL_SYSTEM_ALBUM_LIST: AlbumSubType[] = [
    UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE,
    UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE,
  ];
  public static readonly SYSTEM_BEFORE_USER_ALBUM_LIST: AlbumSubType[] = [
    UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE,
    UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE,
    UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE,
  ];
  public static readonly SYSTEM_AFTER_USER_ALBUM_LIST: AlbumSubType[] = [
    UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE
  ];
  public static readonly SYSTEM_SOURCE_ALBUM_LPATH_LIST: string[] = [
    Constants.LPATH_CAMERA,
    Constants.LPATH_SCREEN_SHOT,
    Constants.LPATH_SCREEN_RECORDING
  ];
  public static readonly IMAGE_OR_VIDEO_ALBUM_SUBTYPE: AlbumSubType[] =
    [UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE, UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE];
  // 白块查询索引
  public static readonly WHITE_BLOCKS_INDEXED: string = 'idx_query_thumbnail_white_blocks_num';
  private photoAccessHelper?: photoAccessHelper.PhotoAccessHelper;
  private requestTime: number;
  private systemAlbumUriMap: Map<AlbumSubType, string> = new Map<AlbumSubType, string>();
  private systemAlbumUriOfSourceMap: Map<string, string> = new Map<string, string>();
  private isMoreAlbumsVisible: boolean = false;
  private isHiddenAlbumUri: boolean = false;
  private isProcessingReady: boolean = false;
  private static userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
  private count: number = 0;
  private registerCallback: Function [] = [];
  private workerInstance: worker.ThreadWorker | undefined = undefined;
  private userId: number = -1;
  private readonly addressCache: util.LRUCache<string, string> = new util.LRUCache(50);
  private readonly addressReqCache: util.LRUCache<string, Promise<string | undefined>> = new util.LRUCache(50);
  private destroyCallBackList: Set<Function> = new Set();

  constructor(userId?: number) {
    this.requestTime = Date.now();
    if (userId && userId > 0) {
      Log.info(TAG, `constructor userId successfully！`);
      this.userId = userId;
    }
  }

  public static getInstance(storage?: LocalStorage): UserFileManagerAccess {
    if (storage === undefined) {
      // 在loadContent之前调用LocalStorage.getShare()，有可能拿到的是上一个UIAbility的storage，导致相册无数据
      // 此时直接返回UserFileManagerAccess.userFileManagerAccess，防止拿错instance
      let canGetSharedStorage = Global.getBoolean('canGetSharedStorage', true);
      if (!canGetSharedStorage) {
        Log.info(TAG, `brfore loadContent return default instance`);
        return UserFileManagerAccess.userFileManagerAccess;
      }

      try {
        storage = LocalStorage.getShared();
      } catch (err) {
        return UserFileManagerAccess.userFileManagerAccess;
      }
      let manager = storage?.get<UserFileManagerAccess>(Constants.PHOTO_USER_FILE_MANAGER_ACCESS);
      if (manager === undefined) {
        return UserFileManagerAccess.userFileManagerAccess;
      } else {
        return manager;
      }
    } else {
      let manager = storage?.get<UserFileManagerAccess>(Constants.PHOTO_USER_FILE_MANAGER_ACCESS);
      if (manager === undefined) {
        manager = new UserFileManagerAccess(storage.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId);
        storage?.setOrCreate(Constants.PHOTO_USER_FILE_MANAGER_ACCESS, manager);
      }
      return manager;
    }
  }

  public async getLocalMediaAndRecentDeletedSize(): Promise<number> {
    let totalSize = 0;
    try {
      // 本地视频文件
      let localVideoSize: number = await this.getAllLocalVideoSize();
      totalSize += localVideoSize;

      // 截屏相册图片
      let localScreenshotSize: number = await this.getAllLocalScreenshotSize();
      totalSize += localScreenshotSize;

      // 回收站文件
      let localTrashSize: number = await this.getAllTrashSize();
      totalSize += localTrashSize;
    } catch (error) {
      Log.error(TAG, `occur error ${error}`);
      return totalSize;
    } finally {
      Log.info(TAG, `getLocalMediaAndRecentDeletedSize finished! totalSize :${totalSize}`);
    }
    return totalSize;
  }

  public async getAllLocalVideoSize(): Promise<number> {
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getAllLocalVideoSize', startTime);
    let videoAlbum: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
    let localVideoSize: number = 0;
    if (videoAlbum) {
      localVideoSize =
        (await PhotoAccessHelperAccess.getAlbumAssetInfo(videoAlbum, Constants.VIDEO_CLEANUP_PAGE)).albumLocalAssetSize;
    }
    TraceControllerUtils.finishTraceWithTaskId('getAllLocalVideoSize', startTime);
    Log.info(TAG,
      `getAllLocalVideoSize finished, localVideoSize=${localVideoSize}, cost time: ${Date.now() - startTime}`);
    return localVideoSize;
  }

  /**
   * 图片专清目前包含全部图片和截屏图片，全部图片包含了本地所有图片，计算大小时仅计算全部图片大小即可
   * @returns
   */
  public async getAllLocalImageSize(): Promise<number> {
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getAllLocalImageSize', startTime);
    let imageAlbum: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    let localImageSize: number = 0;
    if (imageAlbum) {
      localImageSize =
        (await PhotoAccessHelperAccess.getAlbumAssetInfo(imageAlbum, Constants.GRID_CLEANUP_PAGE)).albumLocalAssetSize;
    }
    TraceControllerUtils.finishTraceWithTaskId('getAllLocalImageSize', startTime);
    Log.info(TAG,
      `getAllLocalImageSize finished, localImageSize=${localImageSize}, cost time: ${Date.now() - startTime}`);
    return localImageSize;
  }

  public async getAllTrashSize(): Promise<number> {
    let startTime: number = Date.now();
    let localTrashSize: number = 0;
    TraceControllerUtils.startTrace('getAllTrashSize');

    let trashAlbum: PhotoAlbum | undefined = await this.getTrashAlbum();
    if (trashAlbum) {
      localTrashSize = (await PhotoAccessHelperAccess.getAlbumAssetInfo(trashAlbum)).albumLocalAssetSize;
    }
    TraceControllerUtils.finishTrace('getAllTrashSize');
    Log.info(TAG, `getTrashAlbumSize finished, localTrashSize=${localTrashSize}, cost time: ${Date.now() - startTime}`);
    return localTrashSize;
  }

  /**
   * 获取截屏相册资产大小
   *
   * @returns
   */
  public async getAllLocalScreenshotSize(): Promise<number> {
    let startTime: number = Date.now();
    TraceControllerUtils.startTrace('getAllLocalScreenshotSize');
    let photoAlbums: PhotoAlbum[] =
      await UserFileManagerAccess.getInstance().getSystemSourceAlbums(Constants.LPATH_SCREEN_SHOT);
    let localScreenshotSize: number = 0;
    if (photoAlbums.length > 0) {
      localScreenshotSize = (await PhotoAccessHelperAccess.getAlbumAssetInfo(photoAlbums[0],
        Constants.IMAGE_CLEANUP_PAGE)).albumLocalAssetSize;
    }
    TraceControllerUtils.finishTrace('getAllLocalScreenshotSize');
    Log.info(TAG,
      `getAllLocalScreenshotSize finished, localScreenshotSize=${localScreenshotSize}, cost time: ${Date.now() -
        startTime}}`);
    return localScreenshotSize;
  }

  // 重试机制，每秒重试一次，最多重试三次
  public getPhotoAccess(context: common.Context | undefined, callback?: Function): void {
    let interValid = setTimeout((): void => {
      this.count++;
      if (this.userId === -1) {
        this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      } else {
        this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      }
      Log.error(TAG, `Failed to get the photoAccessHelper instance for the ${this.count} time!`);
      if (this.photoAccessHelper != undefined || this.count >= Constants.DELAY_RETRY_COUNT) {
        Log.info(TAG, `photoAccessHelper: ${this.photoAccessHelper != undefined}`);
        if (this.photoAccessHelper != undefined) {
          callback?.(true);
        }
        Log.info(TAG, `All Page callback:${this.registerCallback.length}`)
        this.registerCallback.forEach((func: Function): void => {
          func();
        });
        Log.info(TAG, 'clearTimeout')
        this.count = 0;
        interValid && clearTimeout(interValid);
      } else {
        this.getPhotoAccess(context, callback);
      }
    }, Constants.DELAY_RETRY);
  }

  // 获取照片页、相册页数据加载的回调函数
  public registerPhotoAccess(fuc: Function): void {
    this.registerCallback.push(fuc);
  }

  public unregisterPhotoAccess(fuc: Function): void {
    this.registerCallback = this.registerCallback.filter((item: Function) => {
      return item !== fuc;
    });
  }

  public onCreate(context: common.Context | undefined, callback?: Function): void {
    Log.info(TAG, `Photos_UserFileManagerAccess onCreate start`);
    if (!context) {
      Log.error(TAG, 'Storage Context is undefined!');
      // Storage中缓存的Context可能因为CommonAbility被销毁而释放导致传递的是空值
      context = global.uiAbilityContext();
    }
    if (!context) {
      Log.error(TAG, 'context is undefined!');
      return;
    }

    if (this.photoAccessHelper) {
      callback?.();
      Log.warn(TAG, 'Photos_UserFileManagerAccess onCreate already');
      return;
    }
    try {
      if (this.userId === -1) {
        this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      } else {
        this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      }
    } catch (err) {
      Log.error(TAG, `get photoAccessHelper instance failed:  errCode: ${err?.code}, msg: ${err?.message}`);
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'get photoAccessHelper instance failed!');
      this.getPhotoAccess(context, callback);
    } else {
      callback?.();
    }
    Log.info(TAG, `UserFileManagerAccess onCreate done userId successfully !`);
  }

  public release(): void {
    this.photoAccessHelper?.release();
  }

  public async getPhotoAssetByUri(uri: string, fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri);
      if (!fetchColumns) {
        fetchColumns = [photoAccessHelper.PhotoKeys.FAVORITE, photoAccessHelper.PhotoKeys.POSITION];
      }
      let options: photoAccessHelper.FetchOptions = {
        fetchColumns: fetchColumns,
        predicates: predicates,
      };
      fetchResult = await TraceControllerUtils.checkAsyncDelay(async ():
        Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> => {
        if (!this.photoAccessHelper) {
          return undefined;
        }
        return await this.photoAccessHelper.getAssets(options);
      }, 'getPhotoAssetByUri --> getAssets');
      if (fetchResult === undefined) {
        Log.info(TAG, 'fetchResult is undefined');
        return undefined;
      }
      let result: PhotoAsset | undefined;
      Log.info(TAG, `getPhotoAssetByUri uri ${fetchResult.getCount()}`);
      result = await TraceControllerUtils.checkAsyncDelay(async (): Promise<PhotoAsset | undefined> => {
        return await fetchResult?.getFirstObject();
      }, 'getPhotoAssetByUri --> getFirstObject');
      return result;
    } catch (err) {
      Log.error(TAG, `apply setHidden failed with error: ${err.code}, ${err.message}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public async getPhotoAssetByAlbumUri(albumUri: string, uris: string[],
    fetchColumns?: string[]): Promise<photoAccessHelper.PhotoAsset[]> {
    Log.info(TAG, `getPhotoAssetByAlbumUri uri is ${uris}, albumUri is ${albumUri}`);
    if (!uris.length) {
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      const album = await this.getAlbumByUri(albumUri);
      if (!album) {
        Log.info(TAG, `getPhotoAssetByAlbumUri error without album`);
        return [];
      }
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.beginWrap();
      for (let i = 0; i < uris.length; i++) {
        predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uris[i]);
        if (i < uris.length - 1) {
          predicates.or();
        }
      }
      predicates.endWrap();
      const fetchOpt: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      if (fetchColumns) {
        fetchOpt.fetchColumns = fetchColumns;
      }
      fetchResult = await album.getAssets(fetchOpt);
      return await fetchResult.getAllObjects();
    } catch (error) {
      Log.error(TAG, `getPhotoAssetByAlbumUri error ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getPhotoAssetByUriArray(uriArr: string[], fetchColumns?: string[]):
    Promise<photoAccessHelper.PhotoAsset[]> {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
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
          predicates//.or();
        }
      }
      predicates.endWrap();
      if (!fetchColumns) {
        fetchColumns = [photoAccessHelper.PhotoKeys.POSITION];
      }
      let options: photoAccessHelper.FetchOptions = {
        fetchColumns: fetchColumns,
        predicates: predicates,
      };
      fetchResult = await this.photoAccessHelper.getAssets(options);
      if (!fetchResult) {
        Log.warn(TAG, 'getPhotoAssetByUriArray fetchResult undefined');
        return [];
      }
      let result: Promise<photoAccessHelper.PhotoAsset[]> = fetchResult.getAllObjects();
      return await result;
    } catch (err) {
      Log.error(TAG, `err_message:${err}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return [];
  }

  private onMessage(messageEvents: MessageEvents): void {
    if (!messageEvents?.data || (messageEvents.data.isProcessingReady === undefined)) {
      Log.error(TAG, 'onMessage, invalid message!');
      return;
    }

    Log.info(TAG, `onMessage, isProcessingReady: ${messageEvents.data.isProcessingReady}`);
    this.isProcessingReady = messageEvents.data.isProcessingReady;
  }

  private onWorkerExit(code: number): void {
    Log.info(TAG, `onWorkerExit, reason: ${code}`);
    this.workerInstance = undefined;
    this.isProcessingReady = false;
  }

  public startCreateThumbnailTask(orderDesc?: photoAccessHelper.PhotoKeys): void {
    if (!ImageUtil.isThumbnailReady()) {
      return;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'startCreateThumbnailTask photoAccessHelper undefined');
      return;
    }
    if (!this.workerInstance) {
      this.workerInstance = new worker.ThreadWorker('../task/CreateThumbnailWorker.ets');
    }

    let context: CommonContext = getContext(this) as CommonContext;
    this.workerInstance.postMessage({
      message: START_CREATE_THUMBNAIL_TASK,
      context: context,
      orderDesc,
    });
    this.workerInstance.onmessage = (messageEvents: MessageEvents): void => {
      this.onMessage(messageEvents);
    }
    this.workerInstance.onexit = (code: number) => {
      this.onWorkerExit(code);
    }
  }

  public stopCreateThumbnailTask(): void {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'stopCreateThumbnailTask photoAccessHelper undefined');
      return;
    }

    if (this.workerInstance) {
      Log.info(TAG, 'stopCreateThumbnailTask postMessage');
      let context: CommonContext = getContext(this) as CommonContext;
      this.workerInstance.postMessage({ message: STOP_CREATE_THUMBNAIL_TASK, context: context });
    }
  }

  // 是否正在基于ready机制批量生成缩略图
  public isInReadyProcess(): boolean {
    return this.isProcessingReady;
  }

  public getAllFetchColumns(): string[] {
    return UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
  }

  // 隐藏相册获取数据
  public async getHiddenFileAsset(asset: string, fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    if (this.photoAccessHelper === undefined) {
      Log.info(TAG, 'mgr is undefined');
      return undefined;
    }
    Log.info(TAG, 'mgr GetAsset end');
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), asset);
    if (!fetchColumns) {
      fetchColumns = ['owner_package', 'package_name'];
    }
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: fetchColumns,
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fetchPhotoResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult =
        await this.photoAccessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
      if (fetchResult === undefined) {
        Log.info(TAG, 'EditUserComment fetchResult is undefined');
        return undefined;
      }
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.error(TAG, 'getAlbum by getFirstObject undefined');
        return undefined;
      }
      fetchPhotoResult = await album.getAssets(fetchOptions);
      if (!fetchPhotoResult) {
        Log.error(TAG, 'getPhotoResult by getPhotoAssets undefined');
        return undefined;
      }
      let result = await fetchPhotoResult.getFirstObject();
      if (!result) {
        Log.error(TAG, 'getResult undefined');
        return undefined;
      }
      return result;
    } catch (error) {
      Log.error(TAG, `getHiddenFileAsset ${error}`);
      return undefined;
    } finally {
      fetchResult?.close();
      fetchPhotoResult?.close();
      Log.info(TAG, `fetchResult and fetchPhotoResult are close.`);
    }
  }

  public async getFileAssetByUri(assetUri: string, fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'getFileAssetByUri photoAccessHelper is undefined');
      return undefined;
    }
    Log.info(TAG, 'mgr GetAsset start');
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), assetUri);
    if (!fetchColumns) {
      fetchColumns = this.getAllFetchColumns();
    }
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: fetchColumns,
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAssets(fetchOptions);
      if (!fetchResult) {
        Log.warn(TAG, 'getFileAssetByUri fetchResult is undefined');
        return undefined;
      }
      Log.info(TAG, 'getFileAssetByUri fetchResult end');
      let fileAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      Log.info(TAG, 'getFileAssetByUri fileAsset end');
      return fileAsset;
    } catch (err) {
      Log.error(TAG, `getFileAssetByUri: ${err}}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getFileAssetOrigin(assetUri: string): Promise<string> {
    let fetchColumns: string[] = ['owner_package', 'package_name'];
    let fileAsset: photoAccessHelper.PhotoAsset | undefined = await this.getFileAssetByUri(assetUri, fetchColumns);
    if (!fileAsset) {
      Log.info(TAG, 'exif EditUserComment fileAsset is undefined');
      return '';
    }
    return fileAsset.get('package_name').toString();
  }

  public async editUserComment(assetUri: string, photoNote: string, isHiddenAlbum: boolean |
  undefined): Promise<void> {
    try {
      let fetchColumns: string[] = ['user_comment'];
      let fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
      Log.info(TAG, `editUserComment isHiddenAlbum:${isHiddenAlbum}`);
      if (isHiddenAlbum) {
        fileAsset = await this.getHiddenFileAsset(assetUri, fetchColumns);
      } else {
        fileAsset = await this.getFileAssetByUri(assetUri, fetchColumns);
      }
      if (!fileAsset) {
        Log.info(TAG, 'exif EditUserComment fileAsset is undefined');
        return;
      }

      Log.info(TAG, 'exif EditUserComment called !!');
      let userComment: string = fileAsset.get('user_comment').toString();
      if (userComment !== photoNote) {
        if (userComment === '') {
          let msg: Record<string, number | string | boolean> = {
            'uri': fileAsset.uri,
          };
          ReportToBigDataUtil.report(BigDataConstants.PHOTO_NOTE_ADD, msg);
        } else {
          let msg: Record<string, number | string | boolean> = {
            'uri': fileAsset.uri,
          };
          ReportToBigDataUtil.report(BigDataConstants.PHOTO_NOTE_CHANGE, msg);
        }
        await fileAsset.setUserComment(photoNote);
        Log.info(TAG, `exif EditUserComment is success, displayName:${fileAsset?.displayName}`);
      }
    } catch (err) {
      Log.info(TAG, `exif EditUserComment failed with err: ${err}`);
    }
  }

  public async getUserComment(assetUri: string, isHiddenAlbum: boolean | undefined): Promise<string> {
    let fetchColumns: string[] = ['user_comment'];
    let fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
    Log.info(TAG, `getUserComment isHiddenAlbum:${isHiddenAlbum}`);
    if (isHiddenAlbum) {
      fileAsset = await this.getHiddenFileAsset(assetUri, fetchColumns);
    } else {
      fileAsset = await this.getFileAssetByUri(assetUri, fetchColumns);
    }
    if (!fileAsset) {
      Log.info(TAG, 'exif getUserComment fileAsset is undefined');
      return '';
    }
    Log.info(TAG, 'exif getUserComment called !!');
    let userComment: string = fileAsset.get('user_comment').toString();
    Log.info(TAG, `exif getUserComment is success, displayName:${fileAsset?.displayName}`);
    return userComment;
  }

  // 获取视频类型
  public async getVideoType(assetUri: string): Promise<string> {
    let fetchColumns: string[] = ['all_exif', 'dynamic_range_type'];
    let fileAsset: photoAccessHelper.PhotoAsset | undefined = await this.getFileAssetByUri(assetUri, fetchColumns);
    if (!fileAsset) {
      Log.info(TAG, 'dynamic_range_type fileAsset is undefined');
      return '';
    }
    let videoType: string = fileAsset.get('dynamic_range_type').toString();
    Log.info(TAG, `videoType: ${videoType}`);
    return videoType;
  }

  // 获取拍摄模式 shooting_mode
  public async getShootingMode(assetUri: string, isHiddenAlbum: boolean): Promise<string> {
    let fetchColumns: string[] = ['shooting_mode_tag'];
    let fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
    Log.info(TAG, `getShootingMode isHiddenAlbum:${isHiddenAlbum}`);
    if (isHiddenAlbum) {
      fileAsset = await this.getHiddenFileAsset(assetUri, fetchColumns);
    } else {
      fileAsset = await this.getFileAssetByUri(assetUri, fetchColumns);
    }
    if (!fileAsset) {
      Log.info(TAG, 'exif getShootingMode fileAsset is undefined');
      return '';
    }
    let shootingMode: string = fileAsset.get('shooting_mode_tag').toString();
    Log.info(TAG, `exif get ShootingMode:${shootingMode}, displayName:${fileAsset?.displayName}`);
    return shootingMode;
  }

  public onDestroy(): void {
    try {
      this.destroyCallBackList.forEach(callBack => {
        callBack();
      });
      this.destroyCallBackList = new Set();
      this.photoAccessHelper?.release();
      this.photoAccessHelper = undefined;
      Log.info(TAG, 'onDestroy done');
    } catch (err) {
      Log.error(TAG, `onDestroy error: ${err}, code: ${err?.code}`);
    }
  }

  public registerDestroyCallBack(fn: Function) {
    this.destroyCallBackList.add(fn)
  }

  public getMediaLibrary(): photoAccessHelper.PhotoAccessHelper {
    return this.photoAccessHelper as photoAccessHelper.PhotoAccessHelper;
  }

  public getSystemAlbumUriMap(): Map<AlbumSubType, string> {
    return this.systemAlbumUriMap;
  }

  public async getBurstPhotosObject(burstKey: string, fetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    Log.info(TAG, `getBurstPhotosObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getBurstPhotosObject photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getBurstPhotosObject', this.requestTime);

      fetchResult = await this.photoAccessHelper.getBurstAssets(burstKey, fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'get burstPhotos with empty dataList');
        return [];
      }
      Log.info(TAG, `get burstPhotos raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.info(TAG, `count, fetchResult is close.`);
        return [];
      }

      let result = await fetchResult.getAllObjects();
      TraceControllerUtils.finishTraceWithTaskId('getBurstPhotosObject', this.requestTime);
      return result;
    } catch (error) {
      Log.error(TAG, `getAllObject error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getBurstPhotosCoverObject(burstKey: string, fetchOpt: FetchOptions): Promise<PhotoAsset | undefined> {
    Log.info(TAG, `getBurstPhotosCoverObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getBurstPhotosCoverObject photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTrace('getBurstPhotosCoverObject');
      fetchResult = await this.photoAccessHelper.getBurstAssets(burstKey, fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'get burstPhotos with empty dataList');
        return undefined;
      }
      Log.info(TAG, `get burstPhotos raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.info(TAG, `fetchResult is empty, fetchResult is close.`);
        return undefined;
      }
      let result = await fetchResult.getFirstObject();
      TraceControllerUtils.finishTrace('getBurstPhotosCoverObject');
      return result;
    } catch (error) {
      Log.error(TAG, `getFirstObject error: ${error}, code: ${error?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getAllObject(fetchOpt: FetchOptions, tag?: string): Promise<PhotoAsset[]> {
    Log.info(TAG, `getAllObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, `[getAllObject] photoAccessHelper resource is null! TAG: ${tag}`);
      this.photoAccessHelper = photoAccessHelper.getPhotoAccessHelper(global.uiAbilityContext());
      if (!this.photoAccessHelper) {
        Log.error(TAG, `retry get photoAccessHelper resource is null! TAG: ${tag}`);
        return [];
      }
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getAllObject--' + tag, this.requestTime);
      fetchResult = await TraceControllerUtils.checkAsyncDelay(async ():
        Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> => {
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

      let result: PhotoAsset[] = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<PhotoAsset[]> => {
          return await fetchResult?.getAllObjects() ?? [];
        }, 'getAllObject --> getAllObjects');
      return result;
    } catch (error) {
      Log.error(TAG, `getAllObject error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      TraceControllerUtils.finishTraceWithTaskId('getAllObject--' + tag, this.requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /**
   * 根据相册Uri获取相册资源
   *
   * @param albumUri 相册Uri
   * @param fetchOpt fetchOpt
   * @returns 相册资产
   */
  public async getAlbumAssetsCountByAlbumUri(albumUri: string, fetchOpt: FetchOptions): Promise<number> {
    if (!albumUri) {
      Log.error(TAG, 'getAlbumAssetsCountByAlbumUri: albumUri is null!');
      return 0;
    }
    let album: PhotoAlbum | undefined = await this.getAlbumByUri(albumUri);
    Log.info(TAG, `getAlbumAssetsCountByAlbumUri: fetchOpt=${JSON.stringify(fetchOpt)}`);
    let result: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      if (album) {
        let requestTime: number = Date.now();
        TraceControllerUtils.startTraceWithTaskId('getAlbumAssetsCountByAlbumUri', requestTime);
        fetchResult = await album.getAssets(fetchOpt);
        if (!fetchResult || fetchResult.getCount() === 0) {
          fetchResult?.close();
          return 0;
        }
        result = await fetchResult.getCount();
        TraceControllerUtils.finishTraceWithTaskId('getAlbumAssetsCountByAlbumUri', requestTime);
      }
    } catch (error) {
      Log.error(TAG, `getAlbumAssetsCountByAlbumUri error: ${error}, code: ${error?.code}`);
      return 0;
    } finally {
      fetchResult?.close();
    }
    return result;
  }


  public static async getResult(context: CommonContext | undefined, fetchOpt: FetchOptions,
    tag?: string): Promise<PhotoAsset[]> {
    Log.info(TAG, `getResult: ${toString(fetchOpt)}`);
    if (!context || !fetchOpt) {
      Log.error(TAG, '[getResult] invalid input');
      return [];
    }
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = photoAccessHelper.getPhotoAccessHelper(context);
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    const requestTime: number = Date.now();
    try {
      TraceControllerUtils.startTraceWithTaskId('getResult--' + tag, requestTime);
      fetchResult = await TraceControllerUtils.checkAsyncDelay(async ():
        Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> => {
        if (!helper) {
          return undefined;
        }
        return await helper.getAssets(fetchOpt);
      }, 'getResult --> getAssets');
      if (!fetchResult) {
        Log.warn(TAG, 'get all Object Data with empty dataList');
        return [];
      }
      Log.info(TAG, `get all Object Data raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, `getCount = 0, browserCode = ${API_RESPONSE_NO_DATA}`);
        return [];
      }

      let result: PhotoAsset[] = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<PhotoAsset[]> => {
          return await fetchResult?.getAllObjects() ?? [];
        }, 'getResult --> getAllObjects');
      return result;
    } catch (error) {
      Log.error(TAG, `getResult error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      helper?.release();
      TraceControllerUtils.finishTraceWithTaskId('getResult--' + tag, requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async deleteAlbumByUri(uri: string): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[deleteAlbum] photoAccessHelper resource is null!');
      return;
    }
    try {
      Log.info(TAG, ` deleteAlbumByUri uri: ${uri}`);
      let album = await this.getAlbumByUri(uri);
      let context = AppStorage.get('photosGlobalContext') as Context;
      await photoAccessHelper.MediaAlbumChangeRequest.deleteAlbums(context, [album]);
    } catch (error) {
      Log.error(TAG, ` deleteAlbumByUri error: ${error}, code: ${error?.code}`);
      return;
    }
  }

  public async getCount(fetchOpt: FetchOptions, tag?: string): Promise<number> {
    Log.info(TAG, `getCount: ${JSON.stringify(fetchOpt)}`);
    let predicates: dataSharePredicates.DataSharePredicates = fetchOpt.predicates;
    predicates.groupBy([String(photoAccessHelper.PhotoKeys.PHOTO_TYPE)]);
    let options: photoAccessHelper.FetchOptions = {
      fetchColumns: [UserFileManagerAccess.GROUP_BY_KEY],
      predicates: predicates,
    };
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getCount] photoAccessHelper resource is null!');
      return 0;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    TraceControllerUtils.startTraceWithTaskId('getCount--' + tag, this.requestTime);
    try {
      fetchResult = await this.photoAccessHelper.getAssets(options);
      if (!fetchResult) {
        Log.warn(TAG, 'get count dataList is 0');
        return 0;
      }
      let assets: PhotoAsset[] = await fetchResult.getAllObjects();
      let result: number = 0;
      for (let i = 0; i < assets.length; i++) {
        result += assets[i].get(UserFileManagerAccess.GROUP_BY_KEY) as number;
      }
      Log.info(TAG, `get count raw data size: ${result}`);
      return result;
    } catch (error) {
      Log.error(TAG, `get Count error:  ${error}, code: ${error?.code}`);
      return 0;
    } finally {
      fetchResult?.close();
      TraceControllerUtils.finishTraceWithTaskId('getCount--' + tag, this.requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  //从时刻相册移除
  public static async dismissAssets(album: PhotoAlbum, assets: PhotoAsset[]): Promise<void> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTrace('dismissAssetsFromHighlight');
      let context = AppStorage.get('photosGlobalContext') as Context;
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      Log.info(TAG, `highlight dismissAssets, albumUri: ${album.albumUri},
        length: ${assets.length} album count: ${album.count} coverUri: ${album.coverUri}`);

      let changeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(album);
      // changeRequest.dismissAssets(assets);
      // apply之后在数据层已完成变更，之后的处理只针对剩余数据
      await phAccessHelper.applyChanges(changeRequest);

      let isContainCover: boolean = false;
      for (let assetesElement of assets) {
        if (assetesElement.uri === album.coverUri) {
          isContainCover = true;
          break;
        }
      }
      Log.info(TAG, `delete photos contains cover: ${isContainCover}`);
      // 如果移出的照片里有封面，需要更换一张封面，从剩余的照片里选第一张
      if (!isContainCover) {
        Log.info(TAG, `cover not dismiss`);
        return;
      }
      let uriPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      uriPredicates.orderByAsc(photoAccessHelper.PhotoKeys.DATE_TAKEN.toString());
      let uriFetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: uriPredicates,
      };
      fetchResult = await album.getAssets(uriFetchOption);
      if (fetchResult.getCount() === 0) {
        Log.info(TAG, `DismissAssets isLastOne, deleteHighlightAlbums`);
        // photoAccessHelper.HighlightAlbum.deleteHighlightAlbums(context, [album]);
        return;
      }
      let newCover: string = ''

      for (let i = 0; i < fetchResult.getCount(); i++) {
        let getAsset: photoAccessHelper.PhotoAsset = await fetchResult.getNextObject();
        if (getAsset.photoType === photoAccessHelper.PhotoType.IMAGE) {
          newCover = getAsset.uri;
          break;
        }
      }
      if (!newCover) {
        Log.info(TAG, `no image, choose first video`);
        let firstAsset = await fetchResult.getFirstObject();
        let firstCover = firstAsset.uri;
        newCover = firstCover;
      }

      Log.info(TAG, `highlight setCoverUri ${newCover}`);
      // changeRequest.setCoverUri(newCover);
      await phAccessHelper.applyChanges(changeRequest);

      Log.info(TAG, `delete photo success`);
      return;
    } catch (e) {
      Log.error(TAG, `highlight dismissAssets error: ${e}`);
      return;
    } finally {
      TraceControllerUtils.finishTrace('dismissAssetsFromHighlight');
      fetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public static async updateCover(albumUri: string, newCoverUri: string): Promise<void> {
    Log.info(TAG, `albumUri: ${albumUri}`);
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      TraceControllerUtils.startTrace('updateCoverFromHighlight');
      let context = AppStorage.get('photosGlobalContext') as Context;
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let album = await UserFileManagerAccess.getAlbum(getContext(), albumUri);
      if (!album) {
        Log.error(TAG, `album is undefined`);
        return;
      }

      Log.info(TAG, `highlight updateCover, albumUri: ${album.albumUri},
       album count: ${album.count} coverUri: ${album.coverUri}`);

      let changeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(album);
      // changeRequest.setCoverUri(newCoverUri);
      await phAccessHelper.applyChanges(changeRequest);

      Log.info(TAG, `update cover success`);
      return;
    } catch (e) {
      Log.error(TAG, `highlight update error: ${e}`);
      return;
    } finally {
      TraceControllerUtils.finishTrace('updateCoverFromHighlight');
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /**
   * 查询某个相册中，未被收藏的照片个数
   * @param album 相册对象，可选参数，undefined代表照片页
   * @returns 未被收藏的照片个数
   */
  public async getAlbumUnFavorAssetCount(album?: photoAccessHelper.Album): Promise<number> {
    Log.info(TAG, 'getUnFavorAssetCount.');
    let predicates = new dataSharePredicates.DataSharePredicates();
    // predicates.groupBy([String(photoAccessHelper.PhotoKeys.FAVORITE)]);
    let fetchOpt: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [photoAccessHelper.PhotoKeys.FAVORITE, UserFileManagerAccess.GROUP_BY_KEY],
    };
    Log.info(TAG, 'getUnFavorAssetCount asset start');
    let assets: PhotoAsset[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      if (album) {
        fetchResult = await album.getAssets(fetchOpt);
        assets = await fetchResult.getAllObjects();
      } else {
        assets = await this.getAllObject(fetchOpt, 'getUnFavorAssetCount');
      }
      for (let i = 0; i < assets.length; i++) {
        if (Boolean(assets[i].get(photoAccessHelper.PhotoKeys.FAVORITE)) === false) {
          let count = assets[i].get(UserFileManagerAccess.GROUP_BY_KEY) as number;
          return count;
        }
      }
      return 0;
    } catch (error) {
      Log.error(TAG, `get count group by photoAccessHelper type failed: ${error}, code: ${error?.code}`);
      return 0;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /**
   * 获取指定规则下查询的图片/视频总数
   * @param tag 查询的规则描述
   * @param isWhiteBlocksCount 白块数量查询
   * @param isBothCount 非纯本地图数量
   * @param isLocalCount 纯本地图数量
   * @param needThumbnailReady 是否为ready机制
   * @param isToggleOn 云同步开关状态
   * @param isWifiConnect wifi连接状态
   * @returns
   */
  public async getCountGroupByMediaType(tag: string, isWhiteBlocksCount?: boolean, isBothCount?: boolean,
    isLocalCount?: boolean, needThumbnailReady?: boolean,
    isToggleOn?: boolean,
    isWifiConnect?: boolean): Promise<MediaCount> {
    try {
      TraceControllerUtils.startTrace(tag);
      Log.i(TAG, `getCountGroupByMediaType tag:${tag}`);
      let predicates = new dataSharePredicates.DataSharePredicates();
      // predicates.groupBy([String(photoAccessHelper.PhotoKeys.PHOTO_TYPE)]);
      if (isWhiteBlocksCount) {
        // predicates.indexedBy(UserFileManagerAccess.WHITE_BLOCKS_INDEXED);
        predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, UserFileManagerAccess.FILE_LOCATION_CLOUD)
          .and()
          .equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
            UserFileManagerAccess.THUMBNAIL_INVISIBLE_VALUE)
          .and()
          .equalTo(UserFileManagerAccess.LCD_VISIT_TIME, UserFileManagerAccess.LCD_VISIT_TIME_VALUE)
          .and()
          .equalTo(UserFileManagerAccess.THUMB_STATUS, UserFileManagerAccess.THUMB_STATUS_VALUE)
      }
      if (isBothCount) {
        predicates.in(photoAccessHelper.PhotoKeys.POSITION,
          [UserFileManagerAccess.FILE_LOCATION_CLOUD, UserFileManagerAccess.FILE_LOCAL_CLOUD_BOTH]);
      }
      if (isLocalCount) {
        predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, UserFileManagerAccess.FILE_LOCATION_LOCAL)
      }
      if (needThumbnailReady) {
        predicates.equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
          UserFileManagerAccess.THUMBNAIL_VISIBLE_VALUE);
      }
      if (!isToggleOn && !isWifiConnect) {
        predicates.equalTo(
          photoAccessHelper.PhotoKeys.POSITION, UserFileManagerAccess.FILE_LOCATION_CLOUD)
          .and()
          .equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
            UserFileManagerAccess.THUMBNAIL_INVISIBLE_VALUE);
      }
      let fetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [UserFileManagerAccess.GROUP_BY_KEY],
      };
      let assets = await this.getAllObject(fetchOption, tag);
      return this.getCountFromResult(assets, tag);
    } catch (error) {
      Log.error(TAG, `get count group by photoAccessHelper type failed: ${error}, code: ${error?.code}, tag: ${tag}`);
      return {
        isQueryFail: true,
        imageCount: 0,
        videoCount: 0,
      } as MediaCount;
    } finally {
      TraceControllerUtils.finishTrace(tag);
    }
  }

  private getCountFromResult(assets: PhotoAsset[], tag: string): MediaCount {
    let result: MediaCount;
    if (!assets) {
      Log.error(TAG, `getCountFromResult assets empty, tag: ${tag}`);
      result = {
        isQueryFail: true,
        imageCount: 0,
        videoCount: 0,
      } as MediaCount;
      return result;
    }
    let imageCount_: number = 0;
    let videoCount_: number = 0;
    for (let i = 0; i < assets.length; i++) {
      if (assets[i].photoType === photoAccessHelper.PhotoType.IMAGE) {
        imageCount_ = assets[i].get(UserFileManagerAccess.GROUP_BY_KEY) as number;
        Log.info(TAG, `photoAccessHelper_type=image, count: ${imageCount_}, tag: ${tag}`);
      }
      if (assets[i].photoType === photoAccessHelper.PhotoType.VIDEO) {
        videoCount_ = assets[i].get(UserFileManagerAccess.GROUP_BY_KEY) as number;
        Log.info(TAG, `photoAccessHelper_type=video, count: ${videoCount_}, tag: ${tag}`);
      }
    }
    result = {
      imageCount: Number.isFinite(imageCount_) ? imageCount_ : 0,
      videoCount: Number.isFinite(videoCount_) ? videoCount_ : 0,
    } as MediaCount;
    return result;
  }

  public async getAssetsFetchResult(callback: AsyncCallback<FetchAssetResult | undefined>, fetchOpt: FetchOptions,
    album: PhotoAlbum | undefined, isRecoverAlbumOrPor: boolean): Promise<void> {
    Log.info(TAG, `[getAssetsFetchResult] fetchOpt is: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getAssetsFetchResult] photoAccessHelper resource is null!');
      await callback.callback(undefined);
      return;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getAssetsFetchResult', this.requestTime);
      if (isRecoverAlbumOrPor) {
        fetchResult = await album?.getAssets(fetchOpt);
      } else {
        fetchResult = await this.photoAccessHelper.getAssets(fetchOpt);
      }
      await callback.callback(fetchResult);
    } catch (error) {
      Log.error(TAG, `[getAssetsFetchResult] loadData error: ${error}, code: ${error?.code}`);
      await callback.callback(undefined);
    } finally {
      TraceControllerUtils.finishTraceWithTaskId('getAssetsFetchResult', this.requestTime);
      fetchResult?.close();
      Log.info(TAG, `[getAssetsFetchResult] fetchResult is close.`);
    }
  }

  public async getObject(fetchOpt: FetchOptions): Promise<PhotoAsset | undefined> {
    Log.info(TAG, `getObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getObject] photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getObject', this.requestTime);
      fetchResult = await this.photoAccessHelper.getAssets(fetchOpt);
      if (fetchResult) {
        Log.info(TAG, `getObject count is ${fetchResult.getCount()}`);
        if (fetchResult.getCount() <= 0) {
          return undefined;
        }
        let file = await fetchResult.getFirstObject();
        if (file) {
          return file;
        } else {
          Log.error(TAG, 'Failed getObject');
        }
      }
      return undefined;
    } catch (error) {
      Log.error(TAG, `getObject loadData error: ${error}, code: ${error?.code}`);
      return undefined;
    } finally {
      TraceControllerUtils.finishTraceWithTaskId('getObject', this.requestTime);
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getFirstObject(fetchOpt: FetchOptions, tag?: string): Promise<FileAssetEx> {
    let result: FileAssetEx = { count: 0, obj: undefined };
    Log.info(TAG, `getFirstObject: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getFirstObject] photoAccessHelper resource is null!');
      return result;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('getFirstObject--' + tag, this.requestTime);
      fetchResult = await this.photoAccessHelper.getAssets(fetchOpt);
      if (fetchResult) {
        result.count = fetchResult.getCount();
        Log.info(TAG, `getFirstObject count is ${result.count}`);
        if (result.count <= 0) {
          return result;
        }
        let file = await fetchResult.getFirstObject();
        if (file) {
          result.obj = file;
          return result;
        } else {
          Log.error(TAG, 'Failed getFirstObject');
        }
      }
      return result;
    } catch (error) {
      Log.error(TAG, `getFirstObject loadData error: ${error}, code: ${error?.code}`);
      return result;
    } finally {
      fetchResult?.close();
      TraceControllerUtils.finishTraceWithTaskId('getFirstObject--' + tag, this.requestTime);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async createAsset(mediaType: FileType, displayName: string): Promise<PhotoAsset | undefined> {
    Log.debug(TAG, 'createAsset start');
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[createAsset] photoAccessHelper resource is null!');
      return undefined;
    }
    Log.info(TAG, `createAsset ${mediaType} ${displayName} `);
    let fileAsset = await this.photoAccessHelper.createAsset(displayName);
    Log.debug(TAG, `createAsset end. new fileAsset: ${fileAsset}`);
    if (!fileAsset) {
      Log.error(TAG, 'createAsset Fail');
      return undefined;
    }
    return fileAsset;
  }

  public async openAsset(mode: string, fileAsset: PhotoAsset): Promise<number> {
    Log.info(TAG, 'openAsset start');
    if (!fileAsset) {
      Log.error(TAG, 'fileAsset is null');
      return Constants.INVALID;
    }
    let fd: number = await fileAsset.open(mode);
    Log.info(TAG, `openAsset end. fd: ${fd}`);
    if (fd <= 0) {
      Log.error(TAG, 'openAsset Fail');
      return Constants.INVALID;
    }
    return fd;
  }

  public async closeAsset(fd: number, fileAsset: PhotoAsset | undefined): Promise<void> {
    Log.info(TAG, 'closeAsset start');
    if (!fileAsset) {
      Log.error(TAG, 'fileAsset is null');
      return;
    }
    try {
      Log.info(TAG, `[fd flag] closeAsset end. fd: ${fd}`);
      await fileAsset.close(fd);
    } catch (err) {
      Log.error(TAG, 'file asset close error: ' + err + `, code: ${err?.code}`);
    }
  }

  public async deleteToTrash(uris: string[]): Promise<void> {
    TraceControllerUtils.startTrace('deleteToTrash');
    Log.info(TAG, 'deleteToTrash() start');
    let startTime: number = Date.now();
    let context = AppStorage.get('photosGlobalContext') as Context;
    try {
      await photoAccessHelper.MediaAssetChangeRequest.deleteAssets(context, uris);
    } catch (error) {
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', false);
      Log.error(TAG, `photoAccessHelper deleteAssets error: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, 'deleteToTrash cost: ' + (Date.now() - startTime));
    TraceControllerUtils.finishTrace('deleteToTrash');
  }

  /**
   * 回收站彻底删除资源
   *
   * @param assets 资产数组
   * @return void
   */
  public async deleteFromTrash(assets: PhotoAsset[]): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'deleteFromTrash photoAccessHelper undefined');
      return;
    }
    TraceControllerUtils.startTrace('deleteFromTrash');
    Log.info(TAG, ' deleteFromTrash start');
    let startTime: number = Date.now();
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await (this.photoAccessHelper as photoAccessHelper.PhotoAccessHelper)
        .getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
      let trashAlbum = await fetchResult.getFirstObject();
      TraceControllerUtils.startTrace('deleteFromTrash');
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest = new photoAccessHelper
        .MediaAlbumChangeRequest(trashAlbum);
      albumChangeRequest.deleteAssets(assets);
      await this.photoAccessHelper.applyChanges(albumChangeRequest);
      Log.info(TAG, `albumFetchResult is close.`);
      Log.info(TAG, ' recoverFromTrash cost: ' + (Date.now() - startTime));
      TraceControllerUtils.finishTrace('deleteFromTrash');
    } catch (err) {
      Log.error(TAG, ` recoverFromTrash: ${err.message}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  //隐藏
  public async setHidden(assets: PhotoAsset[], isHidden: boolean = true): Promise<void> {
    try {
      let assetChangeRequest: photoAccessHelper.MediaAssetsChangeRequest =
        new photoAccessHelper.MediaAssetsChangeRequest(assets);
      assetChangeRequest.setHidden(isHidden);
      await this.photoAccessHelper?.applyChanges(assetChangeRequest);
      Log.info(TAG, 'apply setHidden successfully');
    } catch (err) {
      Log.error(TAG, `apply setHidden failed with error: ${err?.code}, ${err?.message}`);
    }
  }

  // 连拍照片保存为普通照片
  public async createNewImages(buffer: ArrayBuffer): Promise<void> {
    TraceControllerUtils.startTrace('createNewImages');
    let context = AppStorage.get('photosGlobalContext') as Context;
    try {
      const photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
      const extension: string = 'jpg';
      const assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest = await photoAccessHelper
        .MediaAssetChangeRequest.createAssetRequest(context, photoType, extension);
      assetChangeRequest.addResource(photoAccessHelper.ResourceType.IMAGE_RESOURCE, buffer);
      await this.photoAccessHelper?.applyChanges(assetChangeRequest);
    } catch (error) {
      Log.error(TAG, `photoAccessHelper addResource error: ${error}, code: ${error?.code}`);
    }
    TraceControllerUtils.finishTrace('createNewImages');
  }

  // 连拍照片保存为普通照片（不再使用主线程，直接用uri生成，避免生成arrayBuffer需要使用回调，无法使用taskpool）
  async createNewImage(context: Context, uri: string,
    cameraShotKey: string, isHiddenAlbum: boolean): Promise<photoAccessHelper.PhotoAsset | undefined> {
    TraceControllerUtils.startTrace('createNewImages');
    Log.info(TAG, `createNewImage, isHiddenAlbum: ${isHiddenAlbum}`);
    const photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
    const extension: string = 'jpg';
    let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest | undefined = undefined;
    try {
      assetChangeRequest = await photoAccessHelper
        .MediaAssetChangeRequest.createAssetRequest(context, photoType, extension);
      if (isHiddenAlbum) {
        assetChangeRequest.setHidden(true);
      }
      if (cameraShotKey) {
        assetChangeRequest.setCameraShotKey(cameraShotKey);
      }

      let destFd: number = await assetChangeRequest.getWriteCacheHandler();
      let srcFile: fs.File = await fs.open(uri, fs.OpenMode.READ_ONLY);
      await fs.copyFile(srcFile.fd, destFd);
      Log.info(TAG, `[fd flag] createNewImage fs closeSync destFd: ${destFd}`);
      fs.closeSync(destFd);
      Log.info(TAG, `[fd flag] createNewImage fs closeSync srcFile.fd: ${srcFile?.fd}`);
      fs.closeSync(srcFile);
      await this.photoAccessHelper?.applyChanges(assetChangeRequest);
    } catch (error) {
      Log.error(TAG, `createNewImage error: ${error}, code: ${error?.code}`);
    }
    TraceControllerUtils.finishTrace('createNewImages');
    return assetChangeRequest?.getAsset();
  }

  public async createNewMedia(uri: string, title: string, mediaType: FileType,
    context: Context): Promise<PhotoAsset | undefined> {
    let requestDateTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('createNewMedia', requestDateTime);
    Log.info(TAG, `photoAccessHelper createNewMedia mediaType: ${mediaType}`)
    let resourceType: photoAccessHelper.ResourceType = photoAccessHelper.ResourceType.IMAGE_RESOURCE;
    if (mediaType === photoAccessHelper.PhotoType.VIDEO) {
      resourceType = photoAccessHelper.ResourceType.VIDEO_RESOURCE;
    }
    let options: photoAccessHelper.CreateOptions = {
      title: !title ? new Date().getTime().toString() : decodeURI(title),
    }

    try {
      if (!uri) {
        Log.debug(TAG, 'createNewMedia without uri')
        return;
      }
      const uriArray = uri.split('.');
      const uriSuffix: string = uriArray[uriArray.length - 1];
      if (!uriSuffix) {
        Log.debug(TAG, 'createNewMedia without uriSuffix')
        return;
      }
      // 多屏协同的文件地址会携带 '?networkid='
      const extension: string = uriSuffix.split('?')[0];
      if (!extension) {
        Log.debug(TAG, 'createNewMedia without extension')
        return;
      }
      Log.info(TAG, `createNewMedia mediaType:${mediaType}, extension:${extension}, uri:${uri}`);
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        photoAccessHelper.MediaAssetChangeRequest.createAssetRequest(context, mediaType, extension, options);
      assetChangeRequest.addResource(resourceType, uri);
      await this.photoAccessHelper?.applyChanges(assetChangeRequest);
      return assetChangeRequest.getAsset();
    } catch (error) {
      Log.error(TAG, `photoAccessHelper createNewMedia error: ${error}, code: ${error?.code}`);
      return undefined;
    } finally {
      TraceControllerUtils.finishTraceWithTaskId('createNewMedia', requestDateTime);
    }
  }

  public async recoverFromTrash(assets: PhotoAsset[]): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'recoverFromTrash photoAccessHelper undefined');
      return;
    }
    Log.info(TAG, ` recoverFromTrash start${assets.length}`);
    let startTime: number = Date.now();
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await (this.photoAccessHelper as photoAccessHelper.PhotoAccessHelper)
        .getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
      let trashAlbum = await fetchResult.getFirstObject();
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest = new photoAccessHelper
        .MediaAlbumChangeRequest(trashAlbum);
      await albumChangeRequest.recoverAssets(assets);
      await this.photoAccessHelper.applyChanges(albumChangeRequest);
      Log.info(TAG, ' recoverFromTrash cost: ' + (Date.now() - startTime));
    } catch (err) {
      Log.error(TAG, ` recoverFromTrash: ${err.message}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getTrashAssetByUri(assetUri: string, fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    Log.info(TAG, 'getTrashAssetByUri');
    let trashAlbum: PhotoAlbum | undefined = await this.getTrashAlbum();
    if (!trashAlbum) {
      Log.error(TAG, 'get trashAlbum error');
      return undefined;
    }
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), assetUri);
    if (!fetchColumns) {
      fetchColumns = this.getAllFetchColumns();
    }
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: fetchColumns,
    };
    // Array.prototype.slice.call: 对ALL_IMAGE_VIDEO_FETCH_COLUMNS进行拷贝而非引用
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await trashAlbum.getAssets(fetchOption);
      let assets = await fetchResult.getFirstObject();
      return assets;
    } catch (err) {
      Log.error(TAG, `getTrashAssetByUri: ${err}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getAssetsByUris(album: AlbumInfo, uriArr: string[]): Promise<PhotoAsset[]> {
    if (album.isTrashAlbum) {
      return this.getTrashAssetsByUris(uriArr);
    } else {
      return this.getPhotoAssetByUriArray(uriArr);
    }
  }

  /**
   * 查询最近删除相册的资产
   *
   * @param uriArr 查询资产uris
   * @returns 资产信息
   */
  public async getTrashAssetsByUris(uriArr: string[]): Promise<PhotoAsset[]> {
    Log.info(TAG, 'getTrashAssetsByUris');
    let trashAlbum: PhotoAlbum | undefined = await this.getTrashAlbum();
    if (!trashAlbum) {
      Log.error(TAG, 'get trashAlbum error');
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
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [photoAccessHelper.PhotoKeys.POSITION],
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await trashAlbum.getAssets(fetchOption);
      let assets = await fetchResult.getAllObjects();
      return assets;
    } catch (err) {
      Log.error(TAG, `getTrashAssetsByUris: ${err}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getFavoriteObject(fetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getFavoriteObject] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM,
        photoAccessHelper.AlbumSubtype.FAVORITE);
      let favoriteAlbum = await fetchResult.getFirstObject();
      fileFetchResult = await favoriteAlbum.getAssets(fetchOpt);
      Log.info(TAG, `[getFavoriteObject] get smart albums length:${fileFetchResult.getCount()} ` +
        `name:${AlbumDefine.getAnonymizeAlbumName(favoriteAlbum.albumName)}`);
      Log.debug(TAG, `[getFavoriteObject] object count :${fileFetchResult.getCount()}`);
      let objects = await fileFetchResult.getAllObjects();
      Log.debug(TAG, '[getFavoriteObject] objects done');
      return objects;
    } catch (err) {
      Log.error(TAG, `Get favorite object exception! msg:  ${err}, code: ${err?.code}`);
      return [];
    } finally {
      fileFetchResult?.close();
      fetchResult?.close();
      Log.info(TAG, `fetchResult and fileFetchResult is close.`);
    }
  }

  public async getCloudEnhanceObject(fetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getCloudEnhanceObject] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM,
        photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT);
      let cloudEnhanceAlbum = await fetchResult.getFirstObject();
      fileFetchResult = await cloudEnhanceAlbum.getAssets(fetchOpt);
      Log.info(TAG, `[getCloudEnhanceObject] get smart albums length:${fileFetchResult.getCount()} ` +
        `name:${AlbumDefine.getAnonymizeAlbumName(cloudEnhanceAlbum.albumName)}`);
      Log.debug(TAG, `[getCloudEnhanceObject] object count :${fileFetchResult.getCount()}`);
      let objects = await fileFetchResult.getAllObjects();
      Log.debug(TAG, '[getCloudEnhanceObject] objects done');
      return objects;
    } catch (err) {
      Log.error(TAG, `Get cloud enhance object exception! msg:  ${err}, code: ${err?.code}`);
      return [];
    } finally {
      fileFetchResult?.close();
      fetchResult?.close();
      Log.info(TAG, `fetchResult and fileFetchResult is close.`);
    }
  }

  public async getTrashObject(fetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    Log.info(TAG, `Get trash object: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getTrashObject] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM,
        photoAccessHelper.AlbumSubtype.TRASH);
      let trashAlbum = await fetchResult.getFirstObject();
      fileFetchResult = await trashAlbum.getAssets(fetchOpt);
      Log.debug(TAG, `[getTrashObject] object count :${fileFetchResult.getCount()}`);
      let objects = await fileFetchResult.getAllObjects();
      Log.debug(TAG, '[getTrashObject] get objects done');
      return objects;
    } catch (err) {
      Log.error(TAG, `Get Trash Object exception! msg: ${err}, code: ${err?.code}`);
      return [];
    } finally {
      fileFetchResult?.close();
      fetchResult?.close();
      Log.info(TAG, `fetchResult and fileFetchResult is close.`);
    }
  }

  public async getUserAlbumObject(fetchOpt: FetchOptions, fileFetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    Log.info(TAG, `getEntityAlbumObject opt${JSON.stringify(fetchOpt)} fileOpt${JSON.stringify(fileFetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getEntityAlbumObject] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      // 按照fetchOpt获取用户指定的相册---游标
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER,
        photoAccessHelper.AlbumSubtype.USER_GENERIC, fetchOpt);
      //获取所有的相册的
      let albums = await fetchResult.getAllObjects();
      if (albums.length === 0) {
        return [];
      }
      let objects: PhotoAsset[] = [];
      for (let i = 0; i < albums.length; i++) {
        let album = albums[i];
        Log.debug(TAG,
          `[getEntityAlbumObject]AlbumName:${AlbumDefine.getAnonymizeAlbumName(album.albumName)} index: ${i}`);
        // 返回一个游标
        fileResult = await album.getAssets(fileFetchOpt);
        Log.debug(TAG, `[getEntityAlbumObject]objects count :${fileResult.getCount()}`);
        if (fileResult.getCount() <= 0) {
          continue;
        }
        //获取该album游标下的所有资源
        objects = await fileResult.getAllObjects();
        Log.debug(TAG, '[getEntityAlbumObject]Get objects done');
      }
      return objects;
    } catch (err) {
      Log.error(TAG, `Get Entity Album Object exception! msg:  ${err}, code: ${err?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      fileResult?.close();
      Log.info(TAG, `fetchResult and fileResult is close.`);
    }
  }

  public async getFavoriteCount(favoriteFetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `[getFavoriteCount] FetchOptions: ${JSON.stringify(favoriteFetchOpt)}`);
    let systemAlbumCount: number =
      await this.getSystemAlbumCount(favoriteFetchOpt, photoAccessHelper.AlbumSubtype.FAVORITE);
    return systemAlbumCount;
  }

  public async getCloudEnhanceCount(cloudEnhanceFetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `[getCloudEnhanceCount] FetchOptions: ${JSON.stringify(cloudEnhanceFetchOpt)}`);
    let systemAlbumCount: number = await this.getSystemAlbumCount(cloudEnhanceFetchOpt,
      photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT);
    return systemAlbumCount;
  }

  public async getTrashCount(trashFetchOpt: FetchOptions): Promise<number> {
    Log.info(TAG, `[getTrashCount] FetchOptions: ${JSON.stringify(trashFetchOpt)}`);
    let systemAlbumCount: number = await this.getSystemAlbumCount(trashFetchOpt, photoAccessHelper.AlbumSubtype.TRASH);
    return systemAlbumCount;
  }

  public async getSystemAlbumCount(fetchOpt: FetchOptions, albumSubType: photoAccessHelper.AlbumSubtype):
    Promise<number> {
    Log.info(TAG, `[getTrashCount] FetchOptions: ${JSON.stringify(fetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getTrashCount] photoAccessHelper resource is null!');
      return 0;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubType);
      let systemAlbum = await fetchResult.getFirstObject();
      fileFetchResult = await systemAlbum.getAssets(fetchOpt);
      let count = fileFetchResult.getCount();
      return count;
    } catch (err) {
      Log.error(TAG, `Get Trash count exception! msg: ${err}, code: ${err?.code}`);
      return 0;
    } finally {
      fileFetchResult?.close();
      fetchResult?.close();
      Log.info(TAG, `fetchResult and fileFetchResult is close.`);
    }
  }

  public async getSourceAlbumsCount(albumUris: string[]): Promise<number> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getSourceAlbums photoAccessHelper resource is null!');
      return 0;
    }
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.notEqualTo('count', 0);
      for (let index = 0; index < albumUris.length; index++) {
        let numArray = albumUris[index]?.match(/\d+(\.\d+)?/g);
        let albumId: number = Number(numArray?.pop());
        Log.info(TAG, `getSourceAlbumsCount albumId: ${albumId}`);
        predicates.notEqualTo('album_id', albumId);
      }
      let systemFetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult = await this.photoAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE, systemFetchOption);
      const count: number = fetchResult?.getCount();
      Log.info(TAG, `getSourceAlbumsCount: ${count}`);
      return count;
    } catch (err) {
      Log.error(TAG, `Get Source Object exception! msg: ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return 0;
  }

  /**
   * 获取可移动相册的数量
   * @param sourceAlbumUri
   * @param blackAlbumLpath
   * @returns
   */
  public async getMovableAlbumsCount(sourceAlbumUri: string | null | undefined, blackAlbumLpath?: string[]):
    Promise<number> {
    let count: number = 0;
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getMovableAlbumsCount photoAccessHelper resource is null!');
      return count;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      // 先创建一个外层条件包裹所有逻辑
      predicates.beginWrap();
      // 第一个分支：来源相册
      predicates.beginWrap();
      predicates.equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
      predicates.and().notEqualTo('count', 0)
      predicates.endWrap();
      predicates.or();
      // 第二个分支：用户相册
      predicates.equalTo('album_type', photoAccessHelper.AlbumType.USER)
      predicates.endWrap();
      // 过滤源相册
      if (sourceAlbumUri && sourceAlbumUri.length !== 0) {
        let numArray = sourceAlbumUri?.match(/\d+(\.\d+)?/g);
        let albumId: number = Number(numArray?.pop());
        predicates.and().notEqualTo('album_id', albumId);
      }
      // 过滤黑名单相册
      if (blackAlbumLpath && blackAlbumLpath.length !== 0) {
        for (let index = 0; index < blackAlbumLpath.length; index++) {
          predicates.and().notEqualTo('lpath', blackAlbumLpath[index]);
        }
      }
      let filterFetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult = await this.photoAccessHelper.getPhotoAlbums(filterFetchOption);
      count = fetchResult?.getCount();
      return count;
    } catch (err) {
      Log.error(TAG, `Get Movable Albums Count exception! msg: ${err}, code: ${err?.code}`);
    } finally {
      Log.info(TAG, `getMovableAlbumsCount: ${count}`);
      fetchResult?.close();
    }
    return count;
  }

  public async getAlbumFirstObject(album: PhotoAlbum): Promise<PhotoAsset | undefined> {
    Log.info(TAG, '[getAlbumFirstObject]');
    return this.getAlbumObjectByIndex(album, 0);
  }

  public async getAlbumFirstImageOrVideo(album: PhotoAlbum, fileType: string): Promise<PhotoAsset | undefined> {
    if (!album) {
      Log.error(TAG, 'getAlbumFirstImageOrVideo album null');
    }
    Log.info(TAG, `getAlbumFirstImageOrVideo album: ${album.albumUri}`);
    const builder = new FileFetchOptionBuilder().media(fileType).select(0, 1);
    const fetchOpt: FetchOptions = builder.build();
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      albumFetchResult = await album.getAssets(fetchOpt);
      const assets = await albumFetchResult.getFirstObject();
      Log.info(TAG, 'album getFileAssets successfully');
      return assets;
    } catch (error) {
      Log.error(TAG, `Error in getAlbumFirstImageOrVideo: ${error}`);
      return undefined;
    } finally {
      albumFetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  public async getAlbumCover(album: PhotoAlbum, param?: QueryParam): Promise<PhotoAsset | undefined> {
    if (!album) {
      Log.error(TAG, 'getAlbumFirstImageOrVideo1 album null');
      return undefined;
    }
    Log.info(TAG, `getAlbumFirstImageOrVideo1 album: ${album.albumUri}`);
    const builder = new FileFetchOptionBuilder().select(0, 1);
    if (param?.filterConditions?.mediaType) {
      builder.media(param?.filterConditions?.mediaType.toString());
    }
    if (param?.filterConditions?.position) {
      builder.position(param?.filterConditions?.position.toString());
    }
    if (param?.filterConditions?.subtype) {
      builder.subType(param?.filterConditions?.subtype.toString());
    }
    if (PhotoAccessHelperAccess.isVideoAlbum(album) || PhotoAccessHelperAccess.isPhotoAlbum(album)) {
      builder.order(UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString(), false);
    } else {
      builder.order(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString(), false);
    }
    const fetchOpt: FetchOptions = builder.build();
    AlbumDefine.setFilterConditions(fetchOpt, param?.filterConditions);

    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      albumFetchResult = await album.getAssets(fetchOpt);
      const assets = await albumFetchResult.getFirstObject();
      Log.info(TAG, 'album getFileAssets successfully');
      Log.info(TAG, `getAlbumCover,assets : ${toString(assets)}`);
      Log.info(TAG, `getAlbumCover,uri: ${toString(assets.uri)}`);
      return assets;
    } catch (error) {
      Log.error(TAG, `Error in getAlbumFirstImageOrVideo: ${error}`);
      return undefined;
    } finally {
      albumFetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
  }

  public async buildAllUnionAlbumInfoWithFilter(unionAlbums: PhotoAlbum[][], param?: QueryParam): Promise<AlbumInfo[]> {
    let albumInfos: AlbumInfo[] = [];
    if (!unionAlbums) {
      return [];
    }
    for (let albums of unionAlbums) {
      this.buildUnionAlbumInfoWithFilter(albums, param);
    }
    return albumInfos;
  }

  public async buildUnionAlbumInfoWithFilter(albums: PhotoAlbum[], param?: QueryParam):
    Promise<AlbumInfo | undefined> {
    if (albums.length === 0) {
      return undefined;
    }
    // 处理count, videoCount, cover，特别是 filterMediaType 存在的情况
    let count = 0;
    let albumPhotoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
    let unionAlbumUris: string[] = [];
    for (let album of albums) {
      let result: AlbumCountAndPhotoAsset =
        await UserFileManagerAccess.getInstance().getAlbumAssetCountAndPhotoAsset(album, param);
      let photoCount: number = result.getCount();
      let photoAsset: photoAccessHelper.PhotoAsset | undefined = result.getAsset();
      if (photoCount <= 0 || !photoAsset) {
        continue;
      }
      unionAlbumUris.push(photoAsset.uri)
      if (!albumPhotoAsset) {
        albumPhotoAsset = photoAsset;
      } else
        if (albumPhotoAsset) {
          let albumPhotoAssetTime =
            albumPhotoAsset.get(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()) as number;
          let photoAssetTime = photoAsset.get(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()) as number;
          if (albumPhotoAssetTime < photoAssetTime) {
            albumPhotoAsset = photoAsset;
          }
        }
      count += photoCount;
    }
    let albumInfo: AlbumInfo = new AlbumInfo(albums[0]);
    const videoCount: number = albums.reduce((count: number, album: PhotoAlbum):
      number => count + (album.videoCount ?? 0), 0);
    albumInfo.setCount(count);
    albumInfo.setVideoCount(videoCount);
    albumInfo.setFilterMediaType(param?.filterMediaType ?? '');
    albumInfo.setSubtype(param?.filterConditions?.mediaType ?? 0);
    if (albumPhotoAsset) {
      // let mediaItem: MediaItem = new MediaItem(albumPhotoAsset);
      // mediaItem.setThumbnail(ImageUtil.getThumbnailAstcUri(albumPhotoAsset.uri,
      //   albumPhotoAsset.get(Constants.KEY_FILE_DATA) as string,
      //   mediaItem.getDateModified()));
      // albumInfo.setMediaItem(mediaItem);
      // albumInfo.setCoverOrientation(mediaItem.orientation);
      // albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(albumPhotoAsset.uri,
      //   albumPhotoAsset.get(Constants.KEY_FILE_DATA) as string,
      //   mediaItem.getDateModified()));
      // albumInfo.setCoverPhotoUri(albumPhotoAsset.uri);
    }
    albumInfo.setAlbumCount(albums.length);
    albumInfo.setUnionAlbumUris(unionAlbumUris);
    return albumInfo;
  }

  public async getAlbumInfos(albums: PhotoAlbum[], param?: QueryParam): Promise<AlbumInfo[]> {
    let photoAlbums: AlbumInfo[] = [];
    for (let album of albums) {
      let result: AlbumCountAndPhotoAsset = new AlbumCountAndPhotoAsset(0, undefined);
      try {
        result = await UserFileManagerAccess.getInstance().getAlbumAssetCountAndPhotoAsset(album, param);
      } catch (error) {
        Log.error(TAG, `getSystemAlbumsInfoWithFilter error occured: ${error}, code: ${error?.code}`);
      }
      let count = result.getCount();
      // 系统相册为空时不展示
      if (count <= 0) {
        Log.warn(TAG, 'getSystemAlbumsInfoWithFilter count is 0');
        continue;
      }
      let photoAsset = result.getAsset();
      let albumInfo: AlbumInfo = new AlbumInfo(album, param);
      // 相册的视频数量  当前获取的videoCount没有过滤掉云图  也需要改的
      const videoCount = album.videoCount ?? 0;
      albumInfo.setVideoCount(videoCount);
      // 相册内资源数量
      albumInfo.setCount(count);
      if (photoAsset) {
        // let mediaItem = new MediaItem(photoAsset);
        // mediaItem.setThumbnail(ImageUtil.getThumbnailAstcUri(mediaItem.uri, mediaItem.path,
        //   mediaItem.getDateModified()));
        // albumInfo.setMediaItem(mediaItem);
        // albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(mediaItem.uri, mediaItem.path,
        //   mediaItem.getDateModified()));
        // albumInfo.setCoverPhotoUri(mediaItem.uri);
      }
      photoAlbums.push(albumInfo);
      Log.info(TAG, `getSystemAlbumsInfoWithFilter done, albumInfo : ${albumInfo.toString()}, `);
    }
    Log.info(TAG, 'getSystemAlbumsInfoWithFilter done');
    return photoAlbums;
  }

  public async getAlbumObjectByIndex(album: PhotoAlbum, index?: number): Promise<PhotoAsset | undefined> {
    Log.info(TAG, '[getAlbumObjectByIndex]');
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getAlbumFirstObject] photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let opt: FetchOptions = AlbumDefine.getFileFetchOpt(index, index ? index + 1 : undefined);
      fetchResult = await album.getAssets(opt);
      let fileAsset = await fetchResult?.getFirstObject();
      Log.info(TAG, `cover uri ${fileAsset?.uri}`);
      return fileAsset;
    } catch (err) {
      Log.error(TAG, `Get album first obj exception! msg: ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getAlbumAssetCountAndPhotoAsset(album: PhotoAlbum,
    param?: QueryParam): Promise<AlbumCountAndPhotoAsset> {
    if (!album) {
      Log.error(TAG, 'getAlbumFirstImageOrVideo1 album null');
      return new AlbumCountAndPhotoAsset(0, undefined);
    }

    let fetchOptionBuilder = new PickerAlbumsFilterEnhanceBuilder();
    fetchOptionBuilder.setFilterParam(param)
      .setColumn([UserFileManagerAccess.GROUP_BY_KEY])
      .order(this.getOrderNameByAlbum(album), false)
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      albumFetchResult = await album.getAssets(fetchOptionBuilder.build());
      const assets = await albumFetchResult.getFirstObject();
      let result = assets.get(UserFileManagerAccess.GROUP_BY_KEY) as number;
      Log.info(TAG, 'getAlbumAssetCount result: ' + result);
      return new AlbumCountAndPhotoAsset(result, assets);
    } catch (error) {
      Log.error(TAG, `Error in getAlbumFirstImageOrVideo: ${JSON.stringify(error)}`);
      return new AlbumCountAndPhotoAsset(0, undefined);
    } finally {
      albumFetchResult?.close();
    }
  }

  private getOrderNameByAlbum(album: PhotoAlbum): string {
    return (PhotoAccessHelperAccess.isVideoAlbum(album) || PhotoAccessHelperAccess.isPhotoAlbum(album)) ?
      UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString() :
      UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
  }

  public async getUserAlbumCount(albumFetchOpt: FetchOptions, fileFetchOpt?: FetchOptions): Promise<number> {
    Log.info(TAG, `getUSerAlbumCount FetchOptions: ${JSON.stringify(albumFetchOpt)}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getTrashCount] photoAccessHelper resource is null!');
      return 0;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fileFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER,
        photoAccessHelper.AlbumSubtype.USER_GENERIC, albumFetchOpt);
      let userAlbum = await fetchResult.getFirstObject();
      fileFetchResult = await userAlbum.getAssets(fileFetchOpt as FetchOptions);
      let count: number = fileFetchResult.getCount();
      return count;
    } catch (err) {
      Log.error(TAG, `Get Trash count exception! msg: ${err}, code: ${err?.code}`);
      return 0;
    } finally {
      fileFetchResult?.close();
      fetchResult?.close();
      Log.info(TAG, `fetchResult and fileFetchResult is close.`);
    }
  }

  private lastUserAlbumsCountReportTime: string = '';

  /**
   * 查询用户相册
   * @param fetchOpt 查询参数
   * @param isSkipReport 是否不需要打点（主要针对sendable子线程执行时打点会报错，需要跳过不执行），不传时表示需要打点
   * @returns 用户相册数组
   */
  public async getUserAlbums(fetchOpt?: FetchOptions, isSkipReport?: boolean): Promise<PhotoAlbum[]> {
    const startTime: number = Date.now();
    Log.info(TAG, '[getUserAlbums] start');
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getUserAlbums] photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      if (fetchOpt) {
        fetchResult =
          await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER,
            photoAccessHelper.AlbumSubtype.USER_GENERIC, fetchOpt);
      } else {
        fetchResult =
          await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER,
            photoAccessHelper.AlbumSubtype.USER_GENERIC);
      }
      let userAlbums = await fetchResult.getAllObjects();
      Log.info(TAG, `[getUserAlbums] length: ${userAlbums.length}, isSkipReport: ${isSkipReport}`);
      if (isSkipReport === undefined || isSkipReport === false) {
        this.userAlbumsCountReport(userAlbums.length);
      }
      Log.info(TAG, `getUserAlbums spend time: ${Date.now() - startTime}`);
      return userAlbums;
    } catch (err) {
      Log.error(TAG, `Get User Album exception! msg: ${err}, code: ${err?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /**
   * 用户相册查询到后打点记录用户相册数量
   * @param userAlbumAccount 用于相册数量
   * @returns 返回空void
   */
  public async userAlbumsCountReport(userAlbumAccount: number): Promise<void> {
    Log.info(TAG, `userAlbumsCountReport begin and userAlbumAccount = ${userAlbumAccount}`);
    // 用户创建相册数量
    if (nowOverOneWeek(this.lastUserAlbumsCountReportTime)) {
      userAlbumsCountReport(userAlbumAccount).then((x) => {
        Log.info(TAG, `userAlbumsCountReport exec finished and x = ${x}`);
        this.lastUserAlbumsCountReportTime = x;
      });
    }
  }

  /**
   * 相机查询相册信息
   *
   * @returns 相册信息
   */
  public async getSourceAlbumByCamera(): Promise<AlbumInfo | undefined> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let albumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('lpath', Constants.LPATH_CAMERA);
      let fetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      Log.info(TAG, `getSourceAlbumByCamera ${Constants.SOURCE_QUERY_TYPE} ${
        Constants.SOURCE_QUERY_SUB_TYPE} ${Constants.LPATH_CAMERA}`);
      albumFetchResult =
        await phAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE, Constants.SOURCE_QUERY_SUB_TYPE, fetchOption);
      let album: photoAccessHelper.Album = await albumFetchResult?.getFirstObject();
      return album ? new AlbumInfo(album) : undefined;
    } catch (error) {
      Log.error(TAG, `getSourceAlbumByCamera error: ${error}`);
    } finally {
      albumFetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `albumsFetchResult is close.`)
    }
    return undefined;
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

  public async getVideoAlbumCount(): Promise<number> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'getImageAlbum photoAccessHelper undefined');
      return 0;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult =
        await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM,
          photoAccessHelper.AlbumSubtype.VIDEO);
      let videoAlbum = await fetchResult?.getFirstObject();
      return videoAlbum.videoCount ?? 0;
    } catch (err) {
      Log.error(TAG, `getVideoAlbumCount: ${err}`);
      return 0;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async prepareSystemAlbumsFn(): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'prepareSystemAlbumsFn photoAccessHelper undefined');
      return;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult =
        await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.ANY);
      let systemAlbums = await fetchResult?.getAllObjects();
      this.initSystemAlbumUriMap(systemAlbums);
    } catch (err) {
      Log.error(TAG, `prepareSystemAlbumsFn: ${err}`);
      return;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  private initSystemAlbumUriMap(systemAlbums: PhotoAlbum[]): void {
    for (let i = 0; i < UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
      let albumSubType = UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
      for (let j = 0; j < systemAlbums.length; j++) {
        if (albumSubType === systemAlbums[j].albumSubtype) {
          this.systemAlbumUriMap.set(albumSubType, systemAlbums[j].albumUri);
          Log.info(TAG, `prepareSystemAlbums before :${systemAlbums[j].albumUri}, ${albumSubType}`);
        }
      }
    }
    for (let i = 0; i < UserFileManagerAccess.SYSTEM_AFTER_USER_ALBUM_LIST.length; i++) {
      let albumSubType = UserFileManagerAccess.SYSTEM_AFTER_USER_ALBUM_LIST[i];
      for (let j = 0; j < systemAlbums.length; j++) {
        if (albumSubType === systemAlbums[j].albumSubtype) {
          this.systemAlbumUriMap.set(albumSubType, systemAlbums[j].albumUri);
          this.isMoreAlbumsVisible = this.isMoreAlbumsVisible || (systemAlbums[j].count > 0);
          Log.info(TAG, `prepareSystemAlbums after :${systemAlbums[j].albumUri}, ${albumSubType}`);
        }
      }
    }
  }

  public isMoreAlbumVisible(): boolean {
    return this.isMoreAlbumsVisible;
  }

  public async getSystemAlbums(): Promise<PhotoAlbum[]> {
    const startTime: number = Date.now();
    let systemAlbumList: PhotoAlbum[] = [];
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getSystemAlbums photoAccessHelper resource is null!');
      return systemAlbumList;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM,
        photoAccessHelper.AlbumSubtype.ANY);
      let systemAlbums = await fetchResult.getAllObjects();
      systemAlbumList = this.getSystemBeforeAlbums(systemAlbums);
    } catch (err) {
      Log.error(TAG, `Get System Album exception! msg: ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    Log.info(TAG, `getSystemAlbums spend time: ${Date.now() - startTime}, systemAlbum: ${systemAlbumList.length}`);
    return systemAlbumList;
  }

  private getSystemBeforeAlbums(systemAlbums: PhotoAlbum[]): PhotoAlbum[] {
    let systemAlbumList: PhotoAlbum[] = [];
    for (let i = 0; i < UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST.length; i++) {
      let albumSubType = UserFileManagerAccess.SYSTEM_BEFORE_USER_ALBUM_LIST[i];
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

  public static async getTrashAlbum(helper: photoAccessHelper.PhotoAccessHelper | undefined):
    Promise<photoAccessHelper.Album | undefined> {
    if (!helper) {
      Log.error(TAG, 'getTrashAlbum photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      fetchResult = await helper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
      return fetchResult?.getFirstObject();
    } catch (err) {
      Log.error(TAG, `getTrashAlbum Get Trash Album exception! msg: ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getTrashAlbum(): Promise<PhotoAlbum | undefined> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getTrashAlbum photoAccessHelper resource is null!');
      return undefined;
    }
    try {
      let trashAlbum: PhotoAlbum | undefined = await UserFileManagerAccess.getTrashAlbum(this.photoAccessHelper);
      if (trashAlbum) {
        this.systemAlbumUriMap.set(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE, trashAlbum.albumUri);
      }
      Log.info(TAG, `getTrashAlbum : ${trashAlbum?.albumUri}`);
      return trashAlbum;
    } catch (err) {
      Log.error(TAG, `getTrashAlbum Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    }
  }

  public async getHiddenAlbum(): Promise<PhotoAlbum | undefined> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getTrashAlbum photoAccessHelper resource is null!');
      return undefined;
    }

    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
      let hiddenAlbum: PhotoAlbum | undefined = await fetchResult.getFirstObject();
      Log.info(TAG, `getHiddenAlbum : ${hiddenAlbum?.albumUri}`);
      return hiddenAlbum;
    } catch (err) {
      Log.error(TAG, `getHiddenAlbum Get Hidden Album exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public async getSystemAlbum(albumSubtype: photoAccessHelper.AlbumSubtype): Promise<PhotoAlbum | undefined> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getSystemAlbum photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype);
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      this.systemAlbumUriMap.set(albumSubtype, album.albumUri);
      Log.info(TAG, `getSystemAlbum : ${album.albumUri}`);
      return album;
    } catch (err) {
      Log.error(TAG, `getSystemAlbum Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async getHighlightAlbum(albumName: string): Promise<PhotoAlbum[]> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getHighlightAlbum photoAccessHelper resource is null!');
      return [];
    }
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.notEqualTo('album_name', 'fake');
      predicates.equalTo('highlight_status', '1');
      predicates.contains('album_name', albumName);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      fetchResult = await this.photoAccessHelper.getAlbums(
        Constants.PORTRAIT_QUERY_TYPE, Constants.HIGHLIGHT_QUERY_SUB_TYPE, fetchOptions);
      Log.info(TAG, `Highlight fetchResult.length: ${fetchResult?.getCount()}`);
      if (fetchResult?.getCount()) {
        albums = await fetchResult.getAllObjects();
      }
      return albums;
    } catch (err) {
      Log.error(TAG, `getHighlightAlbum Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
      return albums;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  //获得人像相册
  public async getPortraitAlbums(count?: number): Promise<PhotoAlbum[]> {
    const startTime: number = Date.now();
    let results: PhotoAlbum[] = [];
    let resultHome: PhotoAlbum[] = [];
    let albumNum: number = 0;
    if (!this.photoAccessHelper) {
      return results;
    }
    if (!count || count < 0) {
      count = Constants.PORTRAIT_DISPLAY_MIN_COUNT;
    }
    let fetchResultHomePage: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fetchResultFavorite: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let predicatesFavorite: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicatesFavorite.equalTo('user_display_level', FAVORITE_NUMBER);
      let optionFavorite: photoAccessHelper.FetchOptions = {
        predicates: predicatesFavorite,
        fetchColumns: [],
      };
      fetchResultFavorite = await this.photoAccessHelper.getAlbums(
        Constants.PORTRAIT_QUERY_TYPE, Constants.PORTRAIT_QUERY_SUB_TYPE, optionFavorite);
      albumNum = fetchResultFavorite.getCount();
      if (albumNum > 0) {
        results = await fetchResultFavorite.getAllObjects();
        results = results.filter(item => item.count !== 0);
      }
      Log.info(TAG, `favorite total is ${albumNum}, ${results.length} not empty`);
      if (results.length >= count) {
        results = results.slice(0, count);
        return results;
      }

      let predicatesHomePage: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicatesHomePage.equalTo('user_display_level', HOME_PAGE_NUMBER);
      let optionHome: photoAccessHelper.FetchOptions = {
        predicates: predicatesHomePage,
        fetchColumns: [],
      };
      fetchResultHomePage = await this.photoAccessHelper.getAlbums(
        Constants.PORTRAIT_QUERY_TYPE, Constants.PORTRAIT_QUERY_SUB_TYPE, optionHome);
      albumNum = fetchResultHomePage.getCount();
      if (albumNum > 0) {
        resultHome = await fetchResultHomePage.getAllObjects();
        resultHome = resultHome.filter(item => item.count !== 0);
      }
      Log.info(TAG, `home total is ${albumNum}, ${resultHome.length} not empty`);
      results = results.concat(resultHome);
      results = results.slice(0, count);
      return results;
    } catch (err) {
      Log.error(TAG, `getPortraitAlbums fail, msg: ${err}, code: ${err?.code}`);
      return results;
    } finally {
      fetchResultFavorite?.close();
      fetchResultHomePage?.close();
      Log.info(TAG, `fetchResult is close.`);
      Log.info(TAG, `getPortraitAlbums spend time: ${Date.now() - startTime}, length = ${results.length}`);
    }
  }

  public async isShowPortraitAlbum(albumUri: string): Promise<boolean> {
    const startTime: number = Date.now();
    let results: PhotoAlbum[] = [];
    let isShow: boolean = true;
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'isShowPortraitAlbum photoAccessHelper is undefined');
      return isShow;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('user_display_level', MORE_PAGE_NUMBER);

      let option: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };

      fetchResult = await this.photoAccessHelper.getAlbums(
        Constants.PORTRAIT_QUERY_TYPE, Constants.PORTRAIT_QUERY_SUB_TYPE, option);
      if (fetchResult.getCount() > 0) {
        results = await fetchResult.getAllObjects();
      }
      isShow = results.find((item) => item.albumUri === albumUri) === undefined;
      return isShow;
    } catch (err) {
      Log.error(TAG, `isShowPortraitAlbum fail, msg: ${err}, code: ${err?.code}`);
      return isShow;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `isShowPortraitAlbum fetchResult is close.`);
      Log.info(TAG,
        `isShowPortraitAlbum spend time: ${Date.now() -
          startTime}, albumUri=${albumUri}, isShow = ${isShow}, size = ${results.length}`);
    }
  }

  /**
   * 移动至相册
   * @param sourceAssets 资产数组
   * @param originalAlbum 源相册
   * @param targetAlbum 目标相册
   * @return void
   */
  public async moveFilesToAlbum(sourceAssets: PhotoAsset[], originalAlbum: PhotoAlbum | undefined,
    targetAlbum: PhotoAlbum | undefined): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'moveFilesToAlbum photoAccessHelper undefined');
      return;
    }
    if (!sourceAssets || !sourceAssets.length) {
      Log.warn(TAG, 'sourceAssets is null')
      return;
    }
    if (!originalAlbum) {
      Log.warn(TAG, 'originalAlbum is null')
      return;
    }
    let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
      new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
    try {
      albumChangeRequest.moveAssets(sourceAssets, targetAlbum);
    } catch (err) {
      Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
      return;
    }
    await this.photoAccessHelper.applyChanges(albumChangeRequest);
  }

  private async getNewAssets(sourceAssets: PhotoAsset[], isSameAlbum?: boolean): Promise<PhotoAsset[]> {
    let newAssets: PhotoAsset[] = [];
    /* instrument ignore next */
    if (DeviceInfo.isPc() && isSameAlbum) {
      for (let i = 0; i < sourceAssets.length; i++) {
        const asset: PhotoAsset = sourceAssets[i];
        let title: string = systemDateTime.getTime().toString();
        let newAsset: PhotoAsset = await asset.clone(title);
        newAssets[i] = newAsset;
      }
    } else {
      newAssets = sourceAssets;
    }
    return newAssets;
  }

  /**
   * 添加至相册
   * @param sourceAssets 相册uri
   * @param sourceAssets 资产数组
   * @return void
   */
  public async addFilesToAlbum(albumUri: string, sourceAssets: PhotoAsset[], isSameAlbum?: boolean): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'addFilesToAlbum photoAccessHelper undefined');
      return;
    }
    Log.info(TAG, `addFileToAlbum albumUri: ${albumUri}, sourceAsset: ` + sourceAssets.length);
    let startTime: number = Date.now();
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    let album: PhotoAlbum | undefined = await this.getAlbumByUri(albumUri);
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTrace('addFilesToAlbum');
      Log.info(TAG, ' deleteFromTrash start');
      fetchResult = await this.photoAccessHelper.getAssets(fetchOptions);
      if (album && sourceAssets.length > 0) {
        const newAssets = await this.getNewAssets(sourceAssets, isSameAlbum);
        Log.info(TAG, ` photoAssetList: ${newAssets.length}, ` +
          `albumname ${AlbumDefine.getAnonymizeAlbumName(album?.albumName)}`);
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(album);
        albumChangeRequest.addAssets(newAssets);
        await this.photoAccessHelper.applyChanges(albumChangeRequest);
      } else {
        Log.warn(TAG, ' sourceAssets: is null');
      }
      Log.info(TAG, ' addFilesToAlbum cost: ' + (Date.now() - startTime));
      TraceControllerUtils.finishTrace('addFilesToAlbum');
    } catch (err) {
      Log.error(TAG, ` addFilesToAlbum: ${err.message}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async removeFilesFromAlbum(albumUri: string, sourceAssets: PhotoAsset[]): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getHiddenAlbum] photoAccessHelper resource is null!');
      return;
    }
    let startTime: number = Date.now();
    let album: PhotoAlbum | undefined = await this.getAlbumByUri(albumUri);
    if (album && !this.isSystemAlbum(album)) {
      await album.removeAssets(sourceAssets);
    }
    Log.info(TAG, 'removeFilesFromAlbum() cost: ' + (Date.now() - startTime));
  }

  public isImage(fileAsset: PhotoAsset): boolean {
    return fileAsset.photoType === photoAccessHelper.PhotoType.IMAGE;
  }

  public isSystemAlbum(album: PhotoAlbum): boolean {
    return album.albumType === photoAccessHelper.AlbumType.SYSTEM;
  }

  public isSmartAlbum(album: PhotoAlbum): boolean {
    return album?.albumType === photoAccessHelper.AlbumType.SMART;
  }

  public isTrashAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.TRASH;
  }

  public isVideoAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.VIDEO;
  }

  public isFavorAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.FAVORITE;
  }

  public isCloudEnhanceAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT;
  }

  public isScreenShotAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.SCREENSHOT;
  }

  public isPhotoAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE;
  }

  public isHiddenAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.HIDDEN;
  }

  public async getAlbumNameByUri(albumUri: string, context: common.Context): Promise<string> {
    let albumName: string = '';
    const album: PhotoAlbum | undefined = await this.getAlbumByUri(albumUri);
    if (!album) {
      Log.error(TAG, `getAlbumNameResourceByUri album null`);
      return albumName;
    }
    albumName = await this.getAlbumNameByPhotoAlbum(album, context);
    return albumName;
  }

  public async getAlbumNameByPhotoAlbum(album: PhotoAlbum, context: common.Context): Promise<string> {
    let albumName: string = '';
    if (!album) {
      Log.error(TAG, `getAlbumNameResourceByPhotoAlbum album null`);
      return albumName;
    }
    const albumInfos: AlbumInfo[] = await this.getAlbumInfos([album]);
    if (albumInfos.length <= 0) {
      Log.error(TAG, `getAlbumNameResourceByPhotoAlbum albumInfo null`);
      return albumName;
    }
    const albumInfo = albumInfos[0];
    albumName = await this.getAlbumNameByAlbumInfo(albumInfo, context);
    return albumName;
  }

  public async getAlbumNameByAlbumInfo(albumInfo: AlbumInfo, context: common.Context): Promise<string> {
    let albumName: string | Resource = '';
    if (albumInfo.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY) {
      // 城市相册查询数据库
      const cityAlbums: PhotoAlbum[] | undefined = await PhotoAccessHelperAccess.getInstance().getCityAlbum(context);
      if (!cityAlbums || cityAlbums.length <= 0) {
        Log.error(TAG, `cityAlbums undefined or length is 0`)
        return albumName;
      }
      const res: PhotoAlbum | undefined = cityAlbums.find(cityAlbum => cityAlbum.albumUri === albumInfo.uri);
      if (!res) {
        return albumName;
      }
      albumName = res?.albumName;
    } else if (albumInfo.subType === photoAccessHelper.AlbumSubtype.PORTRAIT) {
      // 普通卡片人像相册不显示相册名
      albumName = '';
    } else {
      // 系统相册及普通相册输出资源或相册名
      albumName = albumInfo?.albumName;
    }
    let res: string = '';
    if (typeof albumName !== 'string') {
      try {
        res = await context.resourceManager.getString(albumName.id);
      } catch (err) {
        res = '';
        Log.error(TAG, `album name resource invalid, ${JSON.stringify(albumName)}`)
      }
    } else {
      res = albumName;
    }
    return res;
  }

  public getAlbumNameResource(album: PhotoAlbum): Resource | string {
    if (this.isSystemAlbum(album)) {
      // 系统相册，图库自己命名
      switch (album.albumSubtype) {
        case UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE:
          return $r('app.string.album_photos');
        case UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE:
          return $r('app.string.album_favor');
        case UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE:
          return $r('app.string.album_video');
        case UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE:
          return $r('app.string.album_recycle');
        default:
          return '';
      }
    }
    // 系统来源相册需要自己命名
    if (album.albumSubtype === UserFileManagerAccess.SOURCE_GENERIC_ALBUM_SUB_TYPE) {
      switch (album.lpath) {
        case Constants.LPATH_CAMERA:
          return $r('app.string.source_camera');
        case Constants.LPATH_SCREEN_SHOT:
          return $r('app.string.source_screenshot');
        case Constants.LPATH_SCREEN_RECORDING:
          return $r('app.string.source_screen_recording')
        default:
          return album.albumName;
      }
    }
    // 用户相册，直接返回
    return album.albumName;
  }

  /**
   * 根据Uri获取相册的lpath
   * @param albumUri 相册Uri
   * @returns 目标相册的lpath
   */
  public async getAlbumLpathByUri(albumUri?: string): Promise<string | undefined> {
    Log.info(TAG, `getAlbumLpathByUri albumUri is ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[getAlbumLpathByUri] photoAccessHelper resource is null!');
      return;
    }
    let startTime: number = Date.now();
    let album: PhotoAlbum | undefined = await this.getAlbumByUri(albumUri);
    Log.info(TAG, 'getAlbumLpathByUri cost: ' + (Date.now() - startTime));
    if (!album) {
      Log.warn(TAG, 'album not exist');
    }
    return album?.lpath;
  }

  /**
   * 根据Uri获取相册，不区分系统相册和用户相册
   * @param albumUri 相册Uri
   * @returns 目标相册
   */
  public async getAlbumByUri(albumUri?: string): Promise<PhotoAlbum | undefined> {
    Log.info(TAG, `getAlbumByUri albumUri is ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getAlbumByUri photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOpt = AlbumDefine.getAlbumFetchOptByUri(albumUri);
      // Waiting: 支持不传入type时删掉
      fetchResult = await this.photoAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE,fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbumByUri return null');
        return undefined;
      }
      Log.info(TAG, `getAlbumByUri return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getAlbumByUri result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public static async getAlbum(context: common.Context, albumUri: string): Promise<PhotoAlbum | undefined> {
    Log.info(TAG, `getAlbum albumUri ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (!helper) {
        return undefined;
      }
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.AlbumKeys.URI.toString(), albumUri);
      let fetchOpt: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult = await helper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE,fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbum return null');
        return undefined;
      }
      Log.info(TAG, `getAlbum return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getAlbum result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbum Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      helper?.release();
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public async getHiddenAlbumByUri(albumUri?: string,
    isHiddenSubAlbumQuery ?: boolean): Promise<PhotoAlbum | undefined> {
    Log.info(TAG, `getHiddenAlbumByUri albumUri is ${albumUri}`);
    if (!albumUri) {
      return undefined;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getHiddenAlbumByUri photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      const albumFetchOpt = new AlbumFetchOptionBuilder().photoAlbumUri(albumUri).build();
      fetchResult = await this.photoAccessHelper.getHiddenAlbums(
        isHiddenSubAlbumQuery ? photoAccessHelper.HiddenPhotosDisplayMode.ALBUMS_MODE :
          photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE, albumFetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getHiddenAlbumByUri return null');
        return undefined;
      }
      Log.info(TAG, `getHiddenAlbumByUri return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getHiddenAlbumByUri result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getHiddenAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  private async getAlbums(fetchOption: FetchOptions): Promise<PhotoAlbum[]> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getAlbums photoAccessHelper resource is null!');
      return [];
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE,fetchOption);
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbums return null');
        return [];
      }
      Log.info(TAG, `getAlbums return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return [];
      }
      let album: PhotoAlbum[] = await fetchResult.getAllObjects();
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbums exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return [];
  }

  public async getAlbumsByUris(albumUris: string[] | undefined): Promise<PhotoAlbum[]> {
    if (!albumUris || albumUris.length === 0) {
      Log.error(TAG, 'getAlbumsByUris: albumUris is undefined or empty!');
      return [];
    }
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('GetAlbumsByUris', startTime);
    let fetchOpt: FetchOptions = AlbumDefine.getAlbumsFetchOptByUris(albumUris);
    let albums: PhotoAlbum[] = await this.getAlbums(fetchOpt);
    TraceControllerUtils.finishTraceWithTaskId('GetAlbumsByUris', startTime);
    Log.info(TAG, `getAlbumsByUris finished, result count ${albums.length}, cost time: ${Date.now() - startTime} ms`);
    return albums;
  }

  public async getPhotoIndexByUri(photoUri: string, albumUri: string, filterMediaType?: string,
    orderProp?: string, isAsc?: boolean, isFromCard: boolean = false,
    filterConditions?: FilterConditions): Promise<number> {
    Log.info(TAG, 'getPhotoIndexByUri albumUri is ' + albumUri + ', photoUri is ' + photoUri +
      ', filterMediaType is ' + filterMediaType + ', orderProp is ' + orderProp);
    let mediaType: string = '';
    try {
      if (!(filterMediaType === '' || filterMediaType === undefined)) {
        mediaType = filterMediaType;
      }
      if (isFromCard) {
        orderProp = albumUri ? AlbumGridSortHelper.getOrderPropByAlbumUri(albumUri, undefined) :
          UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
        isAsc = AlbumGridSortHelper.getInstance().getSortRule('getFetchOpt', '').type === SortRuleString.ASC;
        Log.info(TAG, `set orderProp = date_taken, albumSubtype = ${orderProp} ${albumUri} ${isAsc}`);
      }
      let fileFetchOpt =
        AlbumDefine.getFileFetchOptWithEmptyColumn(Constants.INVALID, Constants.INVALID, mediaType,
          orderProp ?? UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString(), isAsc);
      if (filterConditions) {
        AlbumDefine.setFilterConditions(fileFetchOpt, filterConditions);
      }
      let index: number = await TraceControllerUtils.checkAsyncDelay(async (): Promise<number> => {
        if (!this.photoAccessHelper) {
          Log.error(TAG, 'getPhotoIndexByUri photoAccessHelper resource is null!');
          return 0;
        }
        return await this.photoAccessHelper.getPhotoIndex(photoUri, albumUri, fileFetchOpt);
      }, 'getPhotoIndexByUri --> getPhotoIndex');
      Log.info(TAG, `getPhotoIndex return: ${index}`);
      if (index <= 0) {
        Log.warn(TAG, `index not found, browserCode = ${API_RESPONSE_INDEX_NOT_FOUND}`);
        return Constants.NOT_FOUND;
      }
      return index - 1;
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
      return 0;
    }
  }

  // 使用 albumName 查找 album， 默认查找用户相册和来源相册
  public async getAlbumByName(albumName: string, maybeUserAlbum: boolean = true,
    maybeSourceAlbum: boolean = true): Promise<PhotoAlbum | undefined> {
    if (!albumName) {
      Log.error(TAG, 'getAlbumByName albumName is null or empty!');
      return undefined;
    }
    const albums: PhotoAlbum[] = await this.getAlbums(AlbumDefine.getAlbumFetchOptByName(albumName));
    for (const album of albums) {
      if (maybeUserAlbum && album.albumType === photoAccessHelper.AlbumType.USER &&
        album.albumSubtype === photoAccessHelper.AlbumSubtype.USER_GENERIC) {
        return album;
      }
      if (maybeSourceAlbum && album.albumType === Constants.SOURCE_QUERY_TYPE &&
        album.albumSubtype === Constants.SOURCE_QUERY_SUB_TYPE) {
        return album;
      }
    }
    return undefined;
  }

  public async getAnalysisData(uri: string): Promise<string | undefined> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'getAnalysisData photoAccessHelper undefined');
      return undefined;
    }
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper.getAssets(fetchOptions);
      if (fetchResult !== undefined) {
        let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
        if (photoAsset !== undefined) {
          let analysisMember = await findAddressSerialPipe.pipe(
            () => photoAsset.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_SALIENCY)
          );
          let analysisData = String(analysisMember);
          return analysisData;
        }
      }
      Log.info(TAG, `uri: ${uri} saliency return  undefine`);
    } catch (err) {
      Log.error(TAG, `getAnalysisData: ${err}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  private toPercent(point: number): string {
    let str: string = Number(point * 100).toFixed(0);
    str += '%';
    return str;
  }

  public async getHighLightAnalysisData(): Promise<HighlightAnalyzedProcess> {
    let highlightAnalyzedProcess: HighlightAnalyzedProcess = {
      highlightProcess: 0,
      highlightProcessPct: '0%',
      totalCount: 0,
    }
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'getAnalysisDataAddress photoAccessHelper undefined');
      return highlightAnalyzedProcess;
    }
    try {
      let msg: string =
        await this.photoAccessHelper.getDataAnalysisProgress(photoAccessHelper.AnalysisType.ANALYSIS_FACE);
      Log.info(TAG, `getHighLightAnalysisData msg: ${msg}`);
      let jsonObj: Object = JSON.parse(msg);
      let commObj = (jsonObj as Record<string, Object>);
      let commRecord = (commObj as Record<string, Object>);
      let keyStr = Object.keys(commRecord);

      let hashMapData: HashMap<string, Object> = new HashMap();
      for (let index: number = 0; index < keyStr.length; index++) {
        hashMapData.set(keyStr[index], commRecord[keyStr[index]]);
      }
      let cvFinishedCount: number = Number.parseInt(hashMapData.get('cvFinishedCount').toString());
      let totalCount: number = Number.parseInt(hashMapData.get('totalCount').toString());
      let geoFinishedCount: number = Number.parseInt(hashMapData.get('geoFinishedCount').toString());
      let searchFinishedCount: number = Number.parseInt(hashMapData.get('searchFinishedCount').toString());
      if (totalCount !== 0) {
        let result: number = (cvFinishedCount * 0.935 + searchFinishedCount * 0.005 +
          geoFinishedCount * 0.06) / totalCount;
        Log.info(TAG, `result: ${result} progressNum: ${this.toPercent(result)}`);
        highlightAnalyzedProcess = {
          highlightProcess: Number.parseInt(Number(result * 100).toFixed(0)),
          highlightProcessPct: this.toPercent(result),
          totalCount: totalCount,
        }
        return highlightAnalyzedProcess;
      }
    } catch (err) {
      Log.info(TAG, `parse highLight analysis data error: ${err}`);
    }
    return highlightAnalyzedProcess;
  }

  public clearAddressCache() {
    Log.info(TAG, `clear address cache`);
    this.addressReqCache.clear();
    this.addressCache.clear();
  }

  public getSystemAlbumUri(subType: photoAccessHelper.AlbumSubtype): string {
    Log.info(TAG, `getSystemAlbumUri subType: ${subType}`);
    let uri = this.systemAlbumUriMap.get(subType);
    Log.info(TAG, `getSystemAlbumUri uri: ${uri}`);
    return uri ?? '';
  }

  public async getSystemAlbumUriByMediaType(mediaType: number): Promise<string[]> {
    let albumUris: string[] = [];
    if (mediaType & UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
      let uri: string = await this.getSystemAlbumUriOfSource(Constants.LPATH_SCREEN_RECORDING);
      if (uri.length > 0) {
        albumUris.push(uri);
      }
    }
    if (mediaType & UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      let uri: string = await this.getSystemAlbumUriOfSource(Constants.LPATH_SCREEN_SHOT);
      if (uri.length > 0) {
        albumUris.push(uri);
      }
    }
    return albumUris;
  }

  public async getSystemAlbumUriOfSource(param: string): Promise<string> {
    Log.info(TAG, `getSystemAlbumUriOfSource param: ${param}`);
    await this.prepareSystemAlbumsFnOfSource();
    let uri = this.systemAlbumUriOfSourceMap.get(param);
    Log.info(TAG, `getSystemAlbumUriOfSource uri: ${uri}`);
    return uri ?? '';
  }

  private async prepareSystemAlbumsFnOfSource(): Promise<void> {
    Log.info(TAG, 'prepareSystemAlbumsFnOfSource start');
    if (this.systemAlbumUriOfSourceMap.has(Constants.LPATH_SCREEN_SHOT) &&
    this.systemAlbumUriOfSourceMap.has(Constants.LPATH_SCREEN_RECORDING)) {
      Log.info(TAG, 'prepareSystemAlbumsFnOfSource exists');
      return;
    }
    let screenShot: PhotoAlbum[] =
      await UserFileManagerAccess.getInstance().getSystemSourceAlbums(Constants.LPATH_SCREEN_SHOT);
    let screenRecording: PhotoAlbum[] =
      await UserFileManagerAccess.getInstance().getSystemSourceAlbums(Constants.LPATH_SCREEN_RECORDING);
    if (screenShot.length !== 0) {
      this.systemAlbumUriOfSourceMap.set(Constants.LPATH_SCREEN_SHOT, screenShot[0].albumUri);
    }
    if (screenRecording.length !== 0) {
      this.systemAlbumUriOfSourceMap.set(Constants.LPATH_SCREEN_RECORDING, screenRecording[0].albumUri);
    }
  }

  public setIsHiddenAlbum(isHiddenAlbum: boolean): void {
    this.isHiddenAlbumUri = isHiddenAlbum;
  }

  public getIsHiddenAlbum(): boolean {
    return this.isHiddenAlbumUri;
  }

  public static getRecycleBinUri(): string | undefined {
    return UserFileManagerAccess.getInstance()?.getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE);
  }

  public static isRecycleBin(uri: string | undefined): boolean {
    if (uri === undefined) {
      Log.info(TAG, 'uri is undefined. isRecycleBin: false');
      return false;
    }
    Log.info(TAG, `uri: ${uri}, RecycleBinUri: ${UserFileManagerAccess.getRecycleBinUri()}`);
    return uri === UserFileManagerAccess.getRecycleBinUri();
  }

  public static isVideoAlbumUri(uri: string | undefined): boolean {
    if (uri === undefined) {
      return false;
    }
    return uri === UserFileManagerAccess.getInstance()?.getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
  }

  public static isImageAlbumUri(uri: string | undefined): boolean {
    if (uri === undefined) {
      return false;
    }
    return uri === UserFileManagerAccess.getInstance()?.getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
  }

  public static isFavoriteAlbumSubType(uri: string, albumInfo?: AlbumInfo): boolean {
    return uri ===
    UserFileManagerAccess.getInstance()?.getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);
  }

  public async createUserAlbum(albumName: string): Promise<PhotoAlbum | undefined> {
    let album: PhotoAlbum | undefined = undefined;
    let requestTime: number = Date.now();
    try {
      TraceControllerUtils.startTraceWithTaskId('createUserAlbum', requestTime);
      album = await (this.photoAccessHelper as photoAccessHelper.PhotoAccessHelper).createAlbum(albumName);
    } catch (error) {
      Log.error(TAG, `createUserAlbum error: ${error}, code: ${error?.code}`);
    } finally {
      TraceControllerUtils.finishTraceWithTaskId('createUserAlbum', requestTime);
    }
    return album;
  }

  public async renameAlbum(album: PhotoAlbum | undefined, name: string): Promise<void> {
    if (!album) {
      Log.error(TAG, '[renameAlbum] PhotoAlbum is null!');
      return;
    }
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[renameAlbum] photoAccessHelper resource is null!');
      return;
    }
    try {
      let startTime: number = Date.now();
      album.albumName = name;
      await album.commitModify();
      Log.info(TAG, `[renameAlbum] modify cost: ${Date.now() - startTime}`);
    } catch (err) {
      Log.error(TAG, `[renameAlbum] exception! msg:  ${err}, code: ${err?.code}`);
      return;
    }
  }

  public async getOcrInfoByUri(photoUri: string): Promise<string | undefined> {
    Log.debug(TAG, `getOcrInfoByUri photoUri is ${photoUri}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getOcrInfoByUri photoAccessHelper resource is null!');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let fileFetchOpt: FetchOptions = AlbumDefine.getPhotoFetchOptByUri(photoUri);
      fetchResult = await this.photoAccessHelper.getAssets(fileFetchOpt);
      if (!fetchResult) {
        Log.error(TAG, 'getOcrInfoByUri fetchResult undefined');
        return undefined;
      }
      Log.debug(TAG, `getOcrInfoByUri, count = ${fetchResult.getCount()}`);
      let photo: PhotoAsset = await fetchResult.getFirstObject();
      if (!photo) {
        Log.error(TAG, 'getOcrInfoByUri photo undefined');
        return undefined;
      }
      Log.debug(TAG, `getOcrInfoByUri, uri = ${photo.uri}`);
      let ocrInfo: string =
        await findAddressSerialPipe.pipe(() => photo.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_OCR)) ||
          '[]';
      Log.debug(TAG, `getOcrInfoByUri, ocrInfo.length = ${ocrInfo.length}`);
      return ocrInfo;
    } catch (err) {
      Log.error(TAG, `getOcrInfoByUri exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public getClassificationData(callback: AsyncCallback<photoAccessHelper.Album[]>, count: number): void {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.like(photoAccessHelper.AlbumKeys.ALBUM_NAME.toString(), '100__').orderByDesc('count').limit(count, 0);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    Log.info(TAG, 'classification:' + photoAccessHelper.AlbumType.SMART +
      `  AlbumSubtype: ${photoAccessHelper.AlbumSubtype.CLASSIFY}`);
    if (this.photoAccessHelper === undefined) {
      callback.callback(undefined);
      return;
    }
    this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, photoAccessHelper.AlbumSubtype.CLASSIFY,
      fetchOptions, async (err, fetchResult) => {
        try {
          if (err) {
            Log.error(TAG, `classification getAlbumsCallback failed with err: ${err}`);
            callback.callback(undefined);
            return;
          }
          if (fetchResult === undefined) {
            Log.error(TAG, 'classification getAlbumsCallback fetchResult is undefined');
            callback.callback(undefined);
            return;
          }
          let allAlbums = await fetchResult.getAllObjects();
          callback.callback(allAlbums);
        } catch (error) {
          Log.error(TAG, `Failed to getClassificationData error----: ${error}`);
          callback.callback(undefined);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      });
  }

  public getPeopleData(callback: AsyncCallback<photoAccessHelper.Album[]>, count: number): void {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.greaterThanOrEqualTo('count', Constants.PORTRAIT_DISPLAY_MIN_COUNT);
    predicates.equalTo('user_display_level', FAVORITE_NUMBER);
    predicates.orderByDesc('count').limit(count, 0);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    Log.info(TAG, 'people:' +
    photoAccessHelper.AlbumType.SMART + `  AlbumSubtype: ${photoAccessHelper.AlbumSubtype.PORTRAIT}`);
    if (this.photoAccessHelper === undefined) {
      callback.callback(undefined);
      return;
    }
    this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, 4102,
      fetchOptions, async (err, fetchResult) => {
        try {
          if (err) {
            Log.error(TAG, `people getAlbumsCallback failed with err: ${err}`);
            callback.callback(undefined);
            return;
          }
          if (fetchResult === undefined) {
            Log.error(TAG, 'people getAlbumsCallback fetchResult is undefined');
            callback.callback(undefined);
            return;
          }
          let allAlbums = await fetchResult.getAllObjects();
          let allHomeAlbums: photoAccessHelper.Album[] = await this.getHomePeopleData(count);
          allAlbums = allAlbums.concat(allHomeAlbums);
          allAlbums.sort((firstAlbum, secondAlbum) => {
            return secondAlbum.count - firstAlbum.count;
          });
          allAlbums = allAlbums.slice(0, count);
          for (let item of allAlbums) {
            Log.info(TAG, `people: name  ${AlbumDefine.getAnonymizeAlbumName(item.albumName)}`);
          }
          callback.callback(allAlbums);
        } catch (error) {
          Log.error(TAG, `Failed to getPeopleData error----: ${error}`);
          callback.callback(undefined);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      });
  }

  public async getIsMePeopleData(): Promise<PhotoAlbum[]> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(IS_Me_Key, IS_ME_VALUE);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    if (this.photoAccessHelper === undefined) {
      Log.info(TAG, 'this.photoAccessHelper is undefined, getIsMePeopleData failed!');
      return [];
    }
    try {
      fetchResult =
        await this.photoAccessHelper.getAlbums(Constants.PORTRAIT_QUERY_TYPE,
          Constants.PORTRAIT_QUERY_SUB_TYPE, fetchOptions);
      const count = fetchResult.getCount();
      Log.info(TAG, `getIsMePeopleData album view, album count: ${count}`);
      if (count === 0) {
        return [];
      }
      const albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      return albums;
    } catch (error) {
      Log.error(TAG, `Failed to get albums from portrait album view, error----: ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public getCityLocationData(callback: AsyncCallback<photoAccessHelper.Album[]>, count: number): void {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let language = i18n.System.getSystemLanguage();
    Log.info(TAG, `language is ${language}`);
    predicates.orderByDesc('count').limit(count, 0);
    if (language.startsWith(Constants.CHINESE_LANGUAGE) ||
      language.startsWith(Constants.TRADITIONAL_CHINESE_LANGUAGE)) {
      language = Constants.CHINESE_LANGUAGE;
    } else {
      language = Constants.ENGLISH_LANGUAGE;
    }
    predicates.equalTo('language', language);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    Log.info(TAG,
      'city location:' + photoAccessHelper.AlbumType.SMART + `  AlbumSubtype:${Constants.CITY_QUERY_SUB_TYPE}`);
    if (this.photoAccessHelper === undefined) {
      callback.callback(undefined);
      return;
    }
    this.photoAccessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, Constants.CITY_QUERY_SUB_TYPE,
      fetchOptions, async (err, fetchResult) => {
        try {
          if (err) {
            Log.error(TAG, `getAlbumsCallback failed with err: ${err}`);
            callback.callback(undefined);
            return;
          }
          if (fetchResult === undefined) {
            Log.error(TAG, 'getAlbumsCallback fetchResult is undefined');
            callback.callback(undefined);
            return;
          }
          let allAlbums = await fetchResult.getAllObjects();
          callback.callback(allAlbums);
        } catch (error) {
          Log.error(TAG, `Failed to getCityLocationData error----: ${error}`);
          callback.callback(undefined);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      });
  }

  /**
   * 根据lpath查询系统来源相册-相机、截图、屏幕录制
   *
   * @returns 查询到的来源相册-相机、截图、屏幕录制
   */
  public async getSystemSourceAlbums(lpath?: string): Promise<PhotoAlbum[]> {
    const startTime: number = Date.now();
    let result: PhotoAlbum[] = [];
    if (this.photoAccessHelper === undefined) {
      return result;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined;
    try {
      // 设置查询条件-根据 lpath 查询前三个相册-相机、截图、屏幕录制
      let systemPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      if (lpath) {
        systemPredicates.equalTo('lpath', lpath);
      } else {
        systemPredicates.in('lpath', UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST);
      }
      let systemFetchOption: photoAccessHelper.FetchOptions = {
        predicates: systemPredicates,
        fetchColumns: [],
      };

      // 执行查询并获取查询结果
      fetchResult = await this.photoAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE, systemFetchOption);
      if (fetchResult.getCount() > 0) {
        result = await fetchResult.getAllObjects();
      }
    } catch (err) {
      Log.error(TAG, `getSystemSourceAlbums fail, msg: ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    Log.info(TAG, `getSystemSourceAlbums spend time: ${Date.now() - startTime}, length = ${result.length}`);
    return result;
  }

  public static updateYearMonthGroup(): void {
    UserFileManagerAccess.getInstance().updateYearMonthGroupInfo(photoAccessHelper.PhotoKeys.DATE_YEAR);
    UserFileManagerAccess.getInstance().updateYearMonthGroupInfo(photoAccessHelper.PhotoKeys.DATE_MONTH);
  }

  public async updateYearMonthGroupInfo(photoKey: photoAccessHelper.PhotoKeys): Promise<YearMonthGroupInfo[]> {
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'updateYearMonthGroupInfo photoAccessHelper undefined');
      return [];
    }

    TraceControllerUtils.startTrace(`updateYearMonthGroupInfo ${photoKey}`);
    Log.i(TAG, `updateYearMonthGroupInfo ${photoKey}`);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    if (ImageUtil.isThumbnailReady()) {
      predicates.equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
        UserFileManagerAccess.THUMBNAIL_VISIBLE_VALUE);
    }

    predicates.groupBy([photoKey]);
    predicates.orderByDesc(photoKey);
    let options: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoKey, 'count(*)'],
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await this.photoAccessHelper?.getAssets(options);
      let count = await fetchResult.getAllObjects();
      let groupInfo: YearMonthGroupInfo[] = [];
      let monthLength: number = 2;
      count.forEach((item: PhotoAsset, index: number) => {
        let dateString: string = assert.asString(item.get(photoKey)) ?? '0';
        if (!dateString) {
          Log.error(TAG, `updateYearMonthGroupInfo error: invalid dateString`);
        }
        if (photoKey === photoAccessHelper.PhotoKeys.DATE_MONTH) {
          dateString = dateString.slice(0, dateString.length - monthLength) +
            `-${dateString.slice(dateString.length - monthLength)}`;
        }
        let timeStamp: number = new Date(dateString).getTime();
        groupInfo.push({
          startDate: timeStamp, endDate: timeStamp,
          count: assert.asNumber(item.get('count(*)')) ?? 0,
        });
      });
      if (photoKey === photoAccessHelper.PhotoKeys.DATE_YEAR) {
        AppStorage.setOrCreate('yearGroupInfo', groupInfo);
      } else {
        AppStorage.setOrCreate('yearMonthGroupInfo', groupInfo);
      }
      return groupInfo;
    } catch (e) {
      Log.error(TAG, `updateYearMonthGroupInfo error ${e}`);
      return [];
    } finally {
      TraceControllerUtils.finishTrace(`updateYearMonthGroupInfo ${photoKey}`);
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }

  }

  private async getHomePeopleData(count: number): Promise<photoAccessHelper.Album[]> {
    let allHomeAlbums: photoAccessHelper.Album[] = [];
    let homeFetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    if (!this.photoAccessHelper) {
      return allHomeAlbums;
    }
    try {
      let homePredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      homePredicates.greaterThanOrEqualTo('count', Constants.PORTRAIT_DISPLAY_MIN_COUNT);
      homePredicates.equalTo('user_display_level', HOME_PAGE_NUMBER);
      homePredicates.orderByDesc('count').limit(count, 0);
      let homeFetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: homePredicates,
      };
      homeFetchResult = await this.photoAccessHelper
        .getAlbums(photoAccessHelper.AlbumType.SMART, Constants.PORTRAIT_QUERY_SUB_TYPE, homeFetchOptions);
      if (homeFetchResult) {
        allHomeAlbums = await homeFetchResult.getAllObjects();
      }
      Log.info(TAG, `allHomeAlbums : ${allHomeAlbums.length}`);
      return allHomeAlbums;
    } catch (err) {
      Log.error(TAG, `getHomePeopleData exception! msg:  ${err}, code: ${err?.code}`);
      return allHomeAlbums;
    } finally {
      homeFetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /**
   * 彻底删除相册资源
   *
   * @param assets 资产数组
   * @return void
   */
  public async deleteAlbumAssetsPermanently(assets: PhotoAsset[]): Promise<void> {
    // 先从视频相册中删除进入回收站，然后从回收站中彻底删除
    if (!this.photoAccessHelper || assets.length === 0) {
      Log.warn(TAG, `photoAccessHelper undefined or assets is null! assets=${assets.length}`);
      return;
    }
    let videoUris: string[] = assets.map(item => item.uri);
    Log.info(TAG, `deleteAlbumAssetsPermanently start: assets=${assets.length}`);
    let startTime: number = Date.now();
    try {
      TraceControllerUtils.startTrace('deleteAlbumAssetsPermanently');
      await UserFileManagerAccess.getInstance().deleteToTrash(videoUris);
      await UserFileManagerAccess.getInstance().deleteFromTrash(assets);
      Log.info(TAG, 'deleteAlbumAssetsPermanently cost: ' + (Date.now() - startTime));
      TraceControllerUtils.finishTrace('deleteAlbumAssetsPermanently');
    } catch (err) {
      Log.error(TAG, ` deleteAlbumAssetsPermanently: ${err.message}`);
    }
  }

  public async getPhotoAssetByPath(path: string): Promise<PhotoAsset | undefined> {
    let photoAsset: PhotoAsset | undefined;
    if (path) {
      photoAsset =
        await UserFileManagerAccess.getInstance().getObject(AlbumDefine.getFileFetchOptByPath(path));
    }
    if (photoAsset) {
      return photoAsset;
    }
    Log.info(TAG, 'PhotoAsset is undefined');
    return undefined;
  }

  /**
   * 查询已存在的用户新建相册和来源相册
   *
   * @param context context
   * @returns Promise<AlbumInfo[] | undefined>
   */
  public async getExistedSourceAndUserAlbums(): Promise<PhotoAlbum[] | undefined> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let sourceAlbumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    let userGenericAlbumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let context: CommonContext = getContext(this) as CommonContext;
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      sourceAlbumFetchResult = await phAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE);
      userGenericAlbumFetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER,
        photoAccessHelper.AlbumSubtype.USER_GENERIC);
      let sourceAlbumResult: PhotoAlbum[] | undefined = await sourceAlbumFetchResult.getAllObjects();
      let userGenericAlbumResult: PhotoAlbum[] | undefined = await userGenericAlbumFetchResult.getAllObjects();
      return sourceAlbumResult.concat(userGenericAlbumResult);
    } catch (error) {
      Log.error(TAG, `getExistedSourceAndUserAlbums error: ${error}`);
    } finally {
      sourceAlbumFetchResult?.close();
      userGenericAlbumFetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `sourceAlbumFetchResult and userGenericAlbumFetchResult is close.`);
    }
    return undefined;
  }

  public async getSelectAlbum(param: string): Promise<PhotoAsset[]> {
    Log.info('pmx', 'param = ${param}');
    return [];
  }

  public static async getPhotoByUri(uri: string): Promise<PhotoAsset> {
    let object: PhotoAsset;
    let fetchOpt = AlbumDefine.getFileFetchOptByUri(uri);
    object = await UserFileManagerAccess.getInstance().getObject(fetchOpt) as PhotoAsset;
    return object;
  }

  /**
   * 获取移动到页面所需相册数量
   * @param param
   * @returns
   */
  public async getMovePageAlbumsCountFilterUnionAlbums(param: QueryAlbumParam): Promise<number> {
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.AlbumOrder> | undefined = undefined;
    try {
      let fetchOptions = getMovePageAlbumsCountFilterUnionAlbumsFetchOption();
      fetchResult = await this.photoAccessHelper?.getPhotoAlbumOrder(param?.orderStyle, fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getMovePageAlbumsCountFilterUnionAlbums albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getMovePageAlbumsCountFilterUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getMovePageAlbumsCountFilterUnionAlbums albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }

  /**
   * 获取移动到页面所需相册（主动排序过 + 未排序过），但是过滤系统相册
   * @param param
   * @returns
   */
  public async getMovePageAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getMovePageAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getMovePageAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getMovePageAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getMovePageAlbums albums.length：${albums.length}`);
    }
    return albums;
  }

  /**
   * 相册排序页面获取所有相册（主动排序过 + 未排序过）
   * @param param
   * @returns
   */
  public async getAllSortedAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getAllSortedAlbumsFetchOption(param);
      Log.info(TAG, `getAllSortedAlbums this.photoAccessHelper:${this.photoAccessHelper}`)
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getAllSortedAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getAllSortedAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getAllSortedAlbums albums.length：${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取普通相册（宫格区）区域排序过的相册
   * @param param
   * @returns
   */
  public async getSortedNormalAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    Log.info(TAG, `getSortedNormalAlbums start:${param?.start} count:${param?.count}`);
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getSortedNormalAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getSortedNormalAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getSortedNormalAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getSortedNormalAlbums albums.length:${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取普通相册（宫格区）区域的相册
   * @param param
   * @returns
   */
  public async getNormalAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    Log.info(TAG, `getNormalAlbums  start:${param?.start} count:${param?.count}`);
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getNormalAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getNormalAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getNormalAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getNormalAlbums albums.length:${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取排序过“系统相册”区域的相册
   * @param param
   * @returns
   */
  public async getSortedSystemAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    Log.info(TAG, `getSortedSystemAlbums  start:${param?.start} count:${param?.count}`);
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getSortedSystemAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getSortedSystemAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getSortedSystemAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getSortedSystemAlbums albums.length:${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取排序过“我的相册”区域的相册
   * @param param
   * @returns
   */
  public async getSortedMyAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    Log.info(TAG, `getSortedMyAlbums  start:${param?.start} count:${param?.count} orderSection:${param?.orderSection}`);
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getSortedMyAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getSortedMyAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getSortedMyAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getSortedMyAlbums albums.length:${albums.length}`);
    }
    return albums;
  }


  /**
   * 获取普通相册（宫格区）区域的相册数量（过滤融合相册）
   * @param param
   * @returns
   */
  public async getNormalAlbumCountFilterUnionAlbums(): Promise<number> {
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let fetchOptions = getNormalAlbumCountFilterUnionAlbumsFetchOption();
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getNormalAlbumCountFilterUnionAlbums albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getNormalAlbumCountFilterUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getNormalAlbumCountFilterUnionAlbums albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }

  /**
   * 获取相册排序页面“系统相册”区域的相册数量（过滤融合相册）
   * @param param
   * @returns
   */
  public async getSystemAlbumAreaCountFilterUnionAlbums(): Promise<number> {
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let fetchOptions = getSystemAlbumCountFilterUnionAlbumsFetchOption();
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getSystemAlbumAreaCountFilterUnionAlbums albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getSystemAlbumAreaCountFilterUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getSystemAlbumAreaCountFilterUnionAlbums albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }

  /**
   * 获取相册排序页面“我的相册”区域的相册数量（过滤融合相册）
   * @param param
   * @returns
   */
  public async getMyAlbumAreaCountFilterUnionAlbums(): Promise<number> {
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let fetchOptions = getMyAlbumCountFilterUnionAlbumsFetchOption();
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getMyAlbumAreaCountFilterUnionAlbums albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getMyAlbumAreaCountFilterUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getMyAlbumAreaCountFilterUnionAlbums albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }


  /**
   * 获取融合相册的数量
   * @param param
   * @returns
   */
  public async getUnionAlbumsCount(param: QueryAlbumParam, albumFlag: number): Promise<number> {
    Log.info(TAG, `getUnionAlbumsCount orderSection:${param?.orderSection}`);
    if (!this.photoAccessHelper) {
      Log.error(TAG, 'getUnionAlbumsCount photoAccessHelper resource is null!');
      return 0;
    }
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let fetchOptions = getUnionAlbumsCountFetchOption(param, albumFlag);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getUnionAlbumsCount albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getUnionAlbumsCount exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getUnionAlbumsCount albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }

  /**
   * 获取更多相册（列表区）区域排序过的相册
   * @param param
   * @returns
   */
  public async getSortedListAreaAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getSortedListAreaAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getSortedListAreaAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getSortedListAreaAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getSortedListAreaAlbums albums.length：${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取列表区区域(来源相册)的相册
   * @param param
   * @returns
   */
  public async getListAreaAlbums(param: QueryAlbumParam): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOptions = getListAreaAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getListAreaAlbums fetchResult.getCount():${count}`);
        albums = await fetchResult?.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getListAreaAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `getListAreaAlbums albums.length：${albums.length}`);
    }
    return albums;
  }

  /**
   * 获取更多相册（列表区）区域的相册数量（过滤融合相册）
   * @param param
   * @returns
   */
  public async getListAreaAlbumCountFilterUnionAlbums(): Promise<number> {
    let albumsCount: number = 0;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let fetchOptions = getListAreaAlbumCountFilterUnionAlbumsFetchOption();
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOptions);
      if (fetchResult) {
        albumsCount = fetchResult.getCount();
        Log.info(TAG, `getListAreaAlbumCountFilterUnionAlbums albumsCount:${albumsCount}`);
      }
    } catch (error) {
      Log.error(TAG, `getListAreaAlbumCountFilterUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
      Log.debug(TAG, `getListAreaAlbumCountFilterUnionAlbums albumsCount:${albumsCount}`);
    }
    return albumsCount;
  }

  /**
   * 获取融合相册
   * @returns
   */
  public async getUnionAlbums(lpaths: string[]): Promise<PhotoAlbum[]> {
    let unionAlbums: PhotoAlbum[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let unionAlbumPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      unionAlbumPredicates.in('lpath', lpaths);
      // 使 priority = 1 的相册排在最前面
      unionAlbumPredicates.orderByDesc('priority');
      let unionAlbumFetchOption: photoAccessHelper.FetchOptions = {
        predicates: unionAlbumPredicates,
        fetchColumns: [],
      };
      fetchResult = await this.photoAccessHelper?.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE, unionAlbumFetchOption);
      if (fetchResult) {
        Log.info(TAG, `getUnionAlbums fetchResult.length: ${fetchResult?.getCount()}`);
        if (fetchResult?.getCount()) {
          unionAlbums = await fetchResult.getAllObjects();
        }
      }
    } catch (error) {
      Log.error(TAG, `getUnionAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
    }
    return unionAlbums;
  }

  /**
   * 获取所有的AlbumOrder数据，仅为setPhotoAlbumOrder时使用
   * @param param
   * @returns
   */
  public async getAllPhotoAlbumOrder(param: QueryAlbumParam): Promise<AlbumOrder[]> {
    let albumOrder: AlbumOrder[] = [];
    let fetchResult: photoAccessHelper.FetchResult<AlbumOrder> | undefined = undefined;
    try {
      const predicates = new dataSharePredicates.DataSharePredicates();
      let fetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult = await this.photoAccessHelper?.getPhotoAlbumOrder(OrderStyle.PHONE_AND_PAD, fetchOption);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getAllPhotoAlbumOrder fetchResult.length: ${count}`);
        albumOrder = await fetchResult.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getAllPhotoAlbumOrder exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
    }
    return albumOrder;
  }

  /**
   * 获取对应区域的photoAlbumOrder
   * @param param
   * @returns
   */
  public async getPhotoAlbumOrder(param: QueryAlbumParam): Promise<AlbumOrder[]> {
    let albumOrder: AlbumOrder[] = [];
    let fetchResult: photoAccessHelper.FetchResult<AlbumOrder> | undefined = undefined;
    Log.info(TAG, `getPhotoAlbumOrder orderSection:${param.orderSection}`);
    try {
      let fetchOption: FetchOptions = getPhotoAlbumOrderFetchOption(param);
      fetchResult =
        await this.photoAccessHelper?.getPhotoAlbumOrder(param?.orderStyle ?? OrderStyle.PHONE_AND_PAD, fetchOption);
      let count: number | undefined = fetchResult?.getCount();
      if (fetchResult && count !== 0) {
        Log.info(TAG, `getPhotoAlbumOrder fetchResult.length: ${count}`);
        albumOrder = await fetchResult.getAllObjects();
      }
    } catch (error) {
      Log.error(TAG, `getPhotoAlbumOrder exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
    }
    return albumOrder;
  }

  /**
   * 更新AlbumOrder相关字段
   * @param albumOrder
   * @param param
   * @returns
   */
  public async updateAlbumOrder(albumOrder: AlbumOrder[], param: QueryAlbumParam): Promise<void> {
    Log.debug(TAG, `updateAlbumOrder albumOrder.length:${albumOrder.length}`);

    const batchSize = 1000;
    if (albumOrder.length <= batchSize) {
      await this.photoAccessHelper?.setPhotoAlbumOrder(OrderStyle.PHONE_AND_PAD, albumOrder);
      return;
    }

    const totalBatches = Math.ceil(albumOrder.length / batchSize);
    Log.info(TAG, `updateAlbumOrder splitting into ${totalBatches} batches`);

    for (let batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
      const startIndex = batchIndex * batchSize;
      const endIndex = Math.min(startIndex + batchSize, albumOrder.length);
      const batch = albumOrder.slice(startIndex, endIndex);

      Log.info(TAG, `updateAlbumOrder processing batch ${batchIndex + 1}/${totalBatches}, size=${batch.length}`);
      await this.photoAccessHelper?.setPhotoAlbumOrder(param?.orderStyle, batch);
    }
  }

  /**
   * 判断对应区域是否为按名称排序
   * @param param
   * @returns
   */
  public async judgeAlbumSortedByName(param: QueryAlbumParam): Promise<boolean> {
    Log.info(TAG, `judgeAlbumSortedByName orderSection:${param?.orderSection}`)
    let isSortedByName: boolean = false;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOption = getJudgeAlbumSortedByNameFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOption);
      if (fetchResult) {
        let count: number = fetchResult.getCount();
        Log.info(TAG, `judgeAlbumSortedByName fetchResult.length: ${count}`);
        if (count === 1) {
          isSortedByName = true;
        } else {
          isSortedByName = false;
        }
      } else {
        Log.error(TAG, 'judgeAlbumSortedByName fetchResult is undefined');
      }
    } catch (error) {
      Log.error(TAG, `judgeAlbumSortedByName exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
    }
    return isSortedByName;
  }

  /**
   * 检查是否存在对应区域的未排序相册
   * @param param
   * @returns
   */
  public async checkForUnsortedAlbums(param: QueryAlbumParam): Promise<boolean> {
    let hasUnsortedAlbum: boolean = false;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let fetchOption = getCheckForUnsortedAlbumsFetchOption(param);
      fetchResult = await this.photoAccessHelper?.getPhotoAlbums(fetchOption);
      if (fetchResult) {
        let count: number = fetchResult.getCount();
        Log.info(TAG, `checkForUnsortedAlbums fetchResult.length: ${count}`);
        if (count === 1) {
          hasUnsortedAlbum = true;
        } else {
          hasUnsortedAlbum = false;
        }
      } else {
        Log.error(TAG, 'checkForUnsortedAlbums fetchResult is undefined');
      }
    } catch (error) {
      Log.error(TAG, `checkForUnsortedAlbums exception! msg: ${error}, code: ${error?.code}`);
    } finally {
      fetchResult?.close();
    }
    return hasUnsortedAlbum;
  }

  /**
   * 彻底删除相册资源
   *
   * @param assets 资产数组
   * @return void
   */
  public async deleteAssetsPermanently(assets: PhotoAsset[]): Promise<void> {
    if (!this.photoAccessHelper || assets.length === 0) {
      Log.warn(TAG, `deleteAssetsPermanently photoAccessHelper undefined or assets is null! assets=${assets.length}`);
      return;
    }
    Log.info(TAG, `deleteAssetsPermanently start: assets=${assets.length}`);
    let startTime: number = Date.now();
    try {
      TraceControllerUtils.startTrace('deleteAssetsPermanently');
      const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
      await photoAccessHelper.MediaAssetChangeRequest.deleteLocalAssetsPermanently(context, assets);
      Log.info(TAG, 'deleteAssetsPermanently cost: ' + (Date.now() - startTime));
      TraceControllerUtils.finishTrace('deleteAssetsPermanently');
    } catch (err) {
      Log.error(TAG, ' deleteAssetsPermanently: ' + err.message);
    }
  }

  // 单独相册设置
  public async setAlbumUploadStatus(albumInfo: AlbumInfo, isUpload: boolean): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[setUploadStatusByUri] photoAccessHelper resource is null!');
      return;
    }
    try {
      Log.info(TAG, ` setUploadStatusByUri uri: ${albumInfo?.uri}`);
      let album: PhotoAlbum | undefined;
      if (!albumInfo.uri || albumInfo.lpath === Constants.LPATH_CAMERA) {
        Log.info(TAG, ` setAlbumUploadStatus failed`);
        return;
      }
      Log.info(TAG, ` setAlbumByUri uri: ${albumInfo?.uri}`);
      album = await this.getAlbumByUri(albumInfo.uri);
      let context = AppStorage.get('photosGlobalContext') as Context;
      await photoAccessHelper.MediaAlbumChangeRequest.setUploadStatus(context, [album], isUpload);
    } catch (error) {
      Log.error(TAG, ` setAlbumUploadStatus error: ${error}, code: ${error?.code}`);
      return;
    }
  }

  // 多个相册批量设置
  public async setAlbumsUploadStatus(albumInfos: AlbumInfo[], isUpload: boolean): Promise<void> {
    if (!this.photoAccessHelper) {
      Log.error(TAG, '[setUploadStatusByUri] photoAccessHelper resource is null!');
      return;
    }
    try {
      let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let fetchOpt: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult = await this.photoAccessHelper?.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE,fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'return null');
        return undefined;
      }
      Log.info(TAG, `getAlbum return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let context = AppStorage.get('photosGlobalContext') as Context;
      let albums: photoAccessHelper.Album[] = await fetchResult.getAllObjects();
      const totalBatches = Math.ceil(albums.length / Constants.UPLOAD_ALBUM_BATCH_SIZE);
      for (let batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
        Log.info(TAG, `process batch : ${batchIndex} totalBatches ：${totalBatches}`);
        // 计算当前批次的起始和结束索引
        const start = batchIndex * Constants.UPLOAD_ALBUM_BATCH_SIZE;
        const end = Math.min(start + Constants.UPLOAD_ALBUM_BATCH_SIZE, albums?.length);
        // 获取当前批次的数据
        const currentFilterBatch = albums.slice(start, end).filter((item) => !(item.lpath === Constants.LPATH_CAMERA));
        await photoAccessHelper.MediaAlbumChangeRequest.setUploadStatus(context, currentFilterBatch, isUpload);
      }
    } catch (error) {
      Log.error(TAG, ` setAlbumUploadStatus error: ${error}, code: ${error?.code}`);
      return;
    }
  }

  public async getUploadStatus(albumSetUris: string[], uploadStatusMap: Map<string, boolean>): Promise<number> {
    Log.info(TAG, `getUploadStatus`);
    if (!albumSetUris) {
      return 0;
    }
    let context = AppStorage.get('photosGlobalContext') as Context;
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let countNum = 0;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (!helper) {
        return countNum;
      }
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      albumSetUris.forEach(albumUri => {
        predicates.equalTo(photoAccessHelper.AlbumKeys.URI.toString(), albumUri);
        if (albumUri !== albumSetUris[albumSetUris.length-1]) {
          predicates.or()
        }
      })
      let fetchOpt: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [photoAccessHelper.AlbumKeys.UPLOAD_STATUS],
      };
      fetchResult = await helper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE,fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'return null');
        return countNum;
      }
      Log.info(TAG, `getAlbum return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return countNum;
      }
      let albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      albums.forEach(album => {
        Log.info(TAG, "check " + album?.albumName + "updateStatus : " + album?.uploadStatus)
      })
      Log.info(TAG, `countNum : ${countNum}`);
    } catch (err) {
      Log.error(TAG, `getAlbum Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      helper?.release();
      fetchResult?.close();
      Log.info(TAG, ` fetchResult is close.`);
    }
    return countNum;
  }
}

