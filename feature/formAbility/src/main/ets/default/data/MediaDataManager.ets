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

import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { Constants } from '../common/Constants';
import type { FormListener } from '../controller/FormController';
import lazy { MediaData } from './MediaData';
import type common from '@ohos.app.ability.common';
import type resourceManager from '@ohos.resourceManager';
import lazy {
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy DBHelper from '@ohos/dataprovider/src/main/ets/database/DBHelper';
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { image } from '@kit.ImageKit';
import lazy { buffer, HashSet, JSON, util } from '@kit.ArkTS';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy ReminderService from '@ohos/dataprovider/src/main/ets/database/service/ReminderService';
import lazy ImageProxyDataService from '@ohos/dataprovider/src/main/ets/database/service/ImageProxyDataService'
import lazy FaCardService from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumSetCacheManager } from '@ohos/common/src/main/ets/default/model/AlbumSetCacheManager';
import lazy { FaCardDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/FaCardDataImpl';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { SourceTypeAlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/SourceTypeAlbumDataImpl';
import lazy { ImageProxyDataTable } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/ImageProxyDataTable';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper'
import lazy {
  PhotoProcessHandler,
  FAPhotoBound
} from '@ohos/dataprovider/src/main/ets/database/service/PhotoProcessHandler';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { AlbumType } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy {
  insertTask,
  getUriExistInProxyInfo,
  uriExistInProxyInfoI
} from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import lazy TaskService from '@ohos/dataprovider/src/main/ets/database/service/TaskService'
import lazy { TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';

/* instrument ignore file */
const TAG: string = 'formA_MediaDataManager';

/**
 * 媒体数据管理
 */
export class MediaDataManager {
  private mediaData: MediaData | undefined = undefined;
  private items: photoAccessHelper.PhotoAsset[] = [];
  private mediaModel: UserFileManagerAccess | undefined = UserFileManagerAccess.getInstance();
  private startIndex: number = 0;
  private readonly COUNT_LIMIT: number = 120;
  private timerId: number = -1;
  private dbHelper: DBHelper | null = null;
  private playInterval: number = 15;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private isDestroy: boolean = false;

  constructor() {
  }

  /**
   * 初始化数据
   */
  async initData(
    formId: string,
    isHighlight?: boolean,
    highlightAlbums?: Array<photoAccessHelper.Album>
  ): Promise<void> {
    if (isHighlight) {
      await this.initHighlightAlbum(formId, highlightAlbums);
    } else {
      await this.initNormalAlbum(formId);
    }
  }

  public setPlayInterval(playInterval: number = 15) {
    this.playInterval = playInterval;
  }

  private async initHighlightAlbum(formId: string, highlightAlbums?: Array<photoAccessHelper.Album>) {
    Log.info(TAG, `initHighlightAlbum formId ${formId}`);
    if (!highlightAlbums || highlightAlbums.length === 0) {
      Log.info(TAG, `initHighlightAlbum highlightAlbums null return`);
      return;
    }
    let context: Context = AppStorage.get<Context>('formContext') as Context;
    const reminderService: ReminderService = new ReminderService(context);
    Log.info(TAG, `context mediaMgr initHighlightAlbum ${JSON.stringify(context)}`);
    const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(context);
    const resultSet: DataShareResultSet | undefined = await imageProxyDataService.queryImageUri();
    const formPhotoUris: HashSet<string> = new HashSet<string>();
    if (resultSet) {
      const uriIndex: number = resultSet.getColumnIndex('uri');
      while (resultSet.goToNextRow()) {
        const formUri: string = resultSet.getString(uriIndex);
        formPhotoUris.add(formUri);
      }
      resultSet.close();
    }
    for (let i = 0; i < highlightAlbums.length; i++) {
      const uri: string = highlightAlbums[i].coverUri;
      Log.info(TAG, `initHighlightAlbum uri is: ${JSON.stringify(uri)}  length: ` + highlightAlbums.length);
      if (highlightAlbums[i]?.coverUri) {
        Log.info(TAG, `initHighlightAlbum uri: ${uri}`);
        await reminderService.insert(formId, uri, highlightAlbums[i].albumUri);
      }
      if (!formPhotoUris.has(highlightAlbums[i].coverUri)) {
        Log.info(TAG, `need insert HighlightAlbum`);
        let photoAsset: PhotoAsset | undefined =
          await UserFileManagerAccess.getInstance().getPhotoAssetByUri(highlightAlbums[i].coverUri);
        if (photoAsset) {
          await imageProxyDataService.insert(photoAsset, '');
          formPhotoUris.add(highlightAlbums[i].coverUri);
        }
      }

      if (highlightAlbums.length < 2 || i === 2) {
        Log.info(TAG, 'broadcast emit ' + formId);
        this.appBroadCast.emit('DATA_READY' + formId);
      }
    }
  }

  private async getCameraAlbum(): Promise<string> {
    try {
      let albumInfos: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums();
      if (!albumInfos) {
        Log.debug(TAG, `getSourceAlbums, albums is undefined`);
        return '';
      }
      const cameraAlbum = albumInfos.find(item => item.albumName === '相机');
      if (!cameraAlbum) {
        Log.debug(TAG, `getSourceAlbums, cameraAlbum is undefined`);
        return '';
      }
      if (!cameraAlbum.count) {
        Log.error(TAG, 'getSourceAlbums, cameraAlbum count is zero');
        return '';
      }

      return cameraAlbum.albumUri;
    } catch (error) {
      Log.error(TAG, `getSourceAlbums error: ${error}`);
    }
    return ''
  }

  private async getPortraitAlbums(): Promise<Array<PhotoAlbum> | undefined> {
    let predicates = new dataSharePredicates.DataSharePredicates()
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let photoAccessH: photoAccessHelper.PhotoAccessHelper =
      UserFileManagerAccess.getInstance().getMediaLibrary();

    try {
      fetchResult = await photoAccessH.getAlbums(photoAccessHelper.AlbumType.SMART,
        photoAccessHelper.AlbumSubtype.PORTRAIT, fetchOptions)
      let albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      if (albums) {
        return albums;
      } else {
        Log.info(TAG, `getPortraitAlbumAssets without albums`);
      }
    } catch (error) {
      Log.error(TAG, `getPortraitAlbumAssets: ${error}`);
    } finally {
      fetchResult?.close();
    }
    return undefined;
  }

  private async initNormalAlbum(formId: string) {
    Log.info(TAG, `initNormalAlbum formId ${formId}`);

    Log.info(TAG, `initData new MediaData! form ${formId}`);
    let formContext = AppStorage.get<common.FormExtensionContext>('formContext');
    let mgr: resourceManager.ResourceManager = formContext?.resourceManager as resourceManager.ResourceManager;
    let displayName = await mgr.getStringValue($r('app.string.album_photos').id);
    // 更新相册数据查询、写入逻辑
    let albumUri = this.mediaModel?.getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    // 获取来源相册的相机地址
    const cameraUri = await this.getCameraAlbum();
    if (cameraUri) {
      albumUri = cameraUri;
    }

    if (albumUri) {
      this.mediaData = new MediaData(formId, displayName, albumUri, '', 0, 0);
    }
    let context: common.UIAbilityContext =
      AppStorage.get<common.UIAbilityContext>('formContext') as common.UIAbilityContext;
    this.dbHelper = DBHelper.getInstance(context);

    await this.loadData(formId);
    this.updateMediaData();
    this.registerForCloud(formId);

    Log.info(TAG, 'after operationFormController' + formId);
  }

  private async registerForCloud(formId: string): Promise<void> {
    Log.info(TAG, `registerForCloud， ${formId}`);
    let context: Context = AppStorage.get<Context>('formContext') as Context;
    UserFileManagerAccess.getInstance().onCreate(context);
    let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
      UserFileManagerAccess.getInstance().getMediaLibrary();
    if (photoAccessHelper) {
      try {
        const trashAlbum: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
        // updateGalleryFormInfo底层逻辑是先删除后增加，可以防止多个卡片注册导致重复注册。
        await photoAccessHelper.updateGalleryFormInfo({
          formId: FormConstants.ALL_FORM_ID,
          assetUris: trashAlbum ? [FormConstants.CLOUD_URI, trashAlbum.albumUri] : [FormConstants.CLOUD_URI],
        });
      } catch (err) {
        Log.error(TAG, `registerForCloud failed, error message: ${err}`);
      }
    } else {
      Log.error(TAG, 'registerForCloud is null!');
    }
  }

  updateMediaData(): void {
    Log.info(TAG, `updateMediaData currentIndex ${this.mediaData?.currentIndex} items.length ${this.items.length}`);
    const setCurrentUri = (flag?: boolean): void => {
      if (this.mediaData && this.items.length !== 0 && this.mediaData?.currentIndex < this.items.length) {
        this.mediaData.currentUri = this.items?.[this.mediaData?.currentIndex]?.uri;
        return;
      }
      if (this.mediaData) {
        this.mediaData.currentUri = '';
      }
    };
    if (!this.mediaData?.currentUri) {
      setCurrentUri();
      return;
    }
    let isExist = false;
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i].uri === this.mediaData?.currentUri) {
        this.mediaData.currentIndex = i;
        isExist = true;
      }
    }
    !isExist && setCurrentUri(!isExist);
  }

  getMediaData(): MediaData {
    return this.mediaData as MediaData;
  }

  async loadData(formId: string): Promise<void> {
    Log.info(TAG, 'loadData start!');
    this.items = await this.getItems(this.mediaData?.albumUri, this.startIndex, this.COUNT_LIMIT, undefined);
    if (!this.items) {
      this.items = [];
    }
    Log.info(TAG, `get album objects: Name:${this.mediaData?.albumName} length: ${this.items.length}`);
  }

  async getAssetsInAlbum(albumUri: string, count: number,): Promise<PhotoAsset[]> {
    const userFileManagerAccess = UserFileManagerAccess.getInstance();
    let result: photoAccessHelper.PhotoAsset[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let album = (await userFileManagerAccess.getAlbumByUri(albumUri) as photoAccessHelper.Album);
      // 卡片只支持显示图片
      let fetchOpt = AlbumDefine.getFileFetchOptWithDate(count, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, 0);
      fetchResult = await album.getAssets(fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getAssetsInAlbum with empty dataList');
        return [];
      }
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, 'getAssetsInAlbum with empty dataList, fetch result count is 0');
        return [];
      }
      Log.info(TAG, `getAssetsInAlbum raw data size: ${fetchResult.getCount()}`);
      result = await fetchResult.getAllObjects();
      return result;
    } catch (error) {
      Log.error(TAG, `Failed to get assets In album, error: ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }

  }

  async getItems(albumUri?: string, startIndex?: number, count?: number,
    filterMediaType?: string): Promise<Array<photoAccessHelper.PhotoAsset>> {
    let result: photoAccessHelper.PhotoAsset[] = [];
    // Get from target album if albumUri is not undefined, otherwise getAllObject
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      if (albumUri) {
        result = await this.getAssetsInAlbum(albumUri, 1);
        let context: Context = AppStorage.get<Context>('formContext') as Context;
        // 批量插入图片
        const reminderService: ReminderService = new ReminderService(context);
        const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(context);
        proxyResultSet = await imageProxyDataService.queryImageUri();

        const formId: string = this.mediaData?.formId ?? '';
        const firstAsset = result.shift();
        if (this.isDestroy) {
          Log.info(TAG, 'insert facard reject ' + this.isDestroy);
          return result;
        }
        // we should insert the faCard table at first, after that we can insert others.
        Log.info(TAG, 'insert facard on create card ' + formId);
        const faCardService: FaCardService = new FaCardService(context);
        await faCardService.insert(formId, AlbumType.ALBUM, this.playInterval, albumUri, result[0]?.uri);
        // 插入第一张图片
        if (firstAsset) {
          const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
          await insertTask([firstAsset], info.uriExistFlag, albumUri, context, formId);
          this.appBroadCast.emit('DATA_READY' + formId);
        }
        Log.info(TAG, 'broadcast DATA_READY emit ' + formId);
        const value: ValuesBucket = {
          'formId': formId,
          'albumUri': albumUri,
          'count': count ? count : -1
        };
        Log.info(TAG, `Task facard ${formId} add`);
        TaskService.getInstance(context).insertTask(formId, TaskUri.TASK_ADD_FACARD_URI, value);

      } else {
        let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
        Log.debug(TAG, `getMediaItem start ${JSON.stringify(fetchOpt)}`);
        result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
      }
    } catch (err) {
      Log.info(TAG, `userFileManager failed with err: ${err}`);
    } finally {
      proxyResultSet?.close();
      Log.info(TAG, `proxyResultSet is close.`);
    }
    if (result.length === count) {
      this.startIndex = this.startIndex + count;
    } else {
      this.startIndex = 0;
    }
    return result;
  }

  onDestroy(formId: string): void {
    clearInterval(this.timerId);
    this.mediaModel = undefined;
    this.isDestroy = true;
    Log.info(TAG, 'onDestroy ' + formId);
  }
}

class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
  private mCallback: Function;

  constructor(callback: Function) {
    this.mCallback = callback;
  }

  public onDataPrepared(data: ArrayBuffer) {
    if (data === undefined) {
      console.error('Error occurred when preparing data');
      return;
    }
    console.info('image data prepared' + this.mCallback);
    this.mCallback(data);
  }
}