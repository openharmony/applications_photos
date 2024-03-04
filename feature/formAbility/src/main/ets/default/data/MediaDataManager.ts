/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { MediaData } from './MediaData';
import { Constants } from '../common/Constants';
import { AlbumDefine, DataStoreUtil, Log, MediaConstants, UserFileManagerAccess, } from '@ohos/common';
import resourceManager from '@ohos.resourceManager';
import type { FormListener } from '../controller/FormController';
import userFileManager from '@ohos.filemanagement.userFileManager';
import common from '@ohos.app.ability.common';

const TAG: string = 'formA_MediaDataManager';

let dataStore = DataStoreUtil.getInstance();

export class MediaDataManager {
  private mediaData: MediaData = null;
  private formController: FormListener = null;
  private items: userFileManager.FileAsset[];
  private fd: number = -1;
  private operationMode: number = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
  private isNextFag: boolean = true;
  private isUpdate: boolean = false;
  private mediaModel = UserFileManagerAccess.getInstance();

  constructor(operationMode: number, formController: FormListener) {
    this.formController = formController;
    this.operationMode = operationMode;
  }

  async initData(formId: string): Promise<void> {
    Log.info('getAllObject getFileAssets', `initData formId ${formId}`);
    await this.storageRead(formId);
    await this.initShowName();
    if (this.mediaData == null || this.mediaData == undefined) {
      Log.info(TAG, `initData new MediaData! form ${formId}`);
      let context = AppStorage.get<common.FormExtensionContext>('formContext');
      let mgr: resourceManager.ResourceManager = context.resourceManager as resourceManager.ResourceManager;
      let displayName = await mgr.getStringValue($r('app.string.album_photos').id);
      let albumUri = this.mediaModel.getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      this.mediaData = new MediaData(formId, displayName, displayName, albumUri, '', 0,
        Constants.PHOTOS_FORM_DEFAULT_PERIOD, 1, 0);
      Log.info(TAG, `initData new MediaData! end ${formId}`);
    }
    await this.loadData();
  }

  async initShowName(): Promise<number> {
    let isShowKey = Constants.FROM_PLAYBACK_ISSHOWNAME;
    let isShow = await dataStore.getData(isShowKey, 1) as number;
    AppStorage.setOrCreate(Constants.FROM_PLAYBACK_ISSHOWNAME, isShow);
    Log.debug(TAG, `initShowName dataStoreData:${isShow}` +
      `storageData:${AppStorage.Get(Constants.FROM_PLAYBACK_ISSHOWNAME)}`);
    return isShow;
  }

  async saveData(): Promise<void> {
    Log.debug(TAG, 'saveData');
    this.updateMediaData();
    if (((this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_EVENT)
      && (this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY)
      && (this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE)) || this.isUpdate) {
      try {
        this.fd = await this.openCurrentFd();
      } catch (error) {
        Log.error(TAG, `open Fd failed: ${error}`);
      }
    }
    Log.debug(TAG, `saveData fd: ${this.fd}`);
    await this.storageSet();
    this.operationFormController();
  }

  operationFormController(): void {
    Log.debug(TAG, `operFormControllerOper operationMode ${this.operationMode}`);
    let formId: string = this.mediaData.formId;
    switch (this.operationMode) {
      case Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY:
        this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
        this.formController.onDeleteForm(formId);
        break;
      case Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE:
        this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
        this.formController.onUpdateFormData(formId);
        break;
      case Constants.PHOTOS_FORM_OPERATION_MODE_EVENT:
        this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
        this.formController.onEvent(formId);
        break;
      case Constants.PHOTOS_FORM_OPERATION_MODE_CALLBACK:
        this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
        this.formController.onCallback(formId);
        break;
      case Constants.PHOTOS_FORM_OPERATION_IS_SHOW_AlbumName:
        this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
        this.formController.onShowForm(formId);
        break;
      default:
        this.formController.updateFormData(formId);
        break;
    }
    Log.debug(TAG, 'operationFormController end!');
  }

  async storageRead(formId: string): Promise<void> {
    Log.debug(TAG, 'storageRead start!');
    let formIdKey: string = 'formId_' + formId;
    let hasFormId = await dataStore.hasData(formIdKey);
    Log.debug(TAG, `The value of hasFormId is ${hasFormId}`);
    if (hasFormId) {
      let displayNameKey = 'displayName_' + formId;
      let displayName = await dataStore.getData(displayNameKey, '') as string;
      Log.debug(TAG, `The value of albumName is ${displayName}`);
      let albumNameKey = 'albumName_' + formId;
      let albumName = await dataStore.getData(albumNameKey, '') as string;
      Log.debug(TAG, `The value of albumName is ${albumName}`);
      let albumUriKey = 'albumUri_' + formId;
      let albumUri = await dataStore.getData(albumUriKey, '') as string;
      Log.debug(TAG, `The value of albumUri is ${albumUri}`);
      let currentUriKey = 'currentUri_' + formId;
      let currentUri = await dataStore.getData(currentUriKey, '') as string;
      Log.debug(TAG, `The value of currentUri is ${currentUri}`);
      let currentIndexKey = 'currentIndex_' + formId;
      let currentIndex = await dataStore.getData(currentIndexKey, 0) as number;
      Log.debug(TAG, `The value of currentIndex is ${currentIndex}`);
      let intervalTimeKey = 'intervalTime_' + formId;
      let intervalTime = await dataStore.getData(intervalTimeKey, 0) as number;
      Log.debug(TAG, `The value of intervalTime is ${intervalTime}`);
      let isShowKey = 'isShowAlbums_' + formId;
      let isShow = await dataStore.getData(isShowKey, 0) as number;
      Log.debug(TAG, `The value of isShow is ${isShow}`);
      let arkUriKey = 'arkUri_' + formId;
      let arkUri = await dataStore.getData(arkUriKey, 0) as number;
      Log.debug(TAG, `The value of arkUri is ${arkUri}`);
      if (arkUri == 0) {
        arkUri = 1;
      } else {
        arkUri = 0;
      }
      this.mediaData = new MediaData(formId, displayName, albumName, albumUri,
        currentUri, currentIndex, intervalTime, isShow, arkUri);
    }
    Log.debug(TAG, 'storageRead end!');
  }

  async storageSet(): Promise<void> {
    Log.debug(TAG, 'storageSet start!');
    let formIdKey = 'formId_' + this.mediaData.formId;
    await dataStore.putData(formIdKey, this.mediaData.formId);
    let displayNameKey = 'displayName_' + this.mediaData.formId;
    await dataStore.putData(displayNameKey, this.mediaData.displayName);
    let albumNameKey = 'albumName_' + this.mediaData.formId;
    await dataStore.putData(albumNameKey, this.mediaData.albumName);
    let albumUriKey = 'albumUri_' + this.mediaData.formId;
    await dataStore.putData(albumUriKey, this.mediaData.albumUri);
    let currentUriKey = 'currentUri_' + this.mediaData.formId;
    await dataStore.putData(currentUriKey, this.mediaData.currentUri);
    let currentIndexKey = 'currentIndex_' + this.mediaData.formId;
    await dataStore.putData(currentIndexKey, this.mediaData.currentIndex);
    let intervalTimeKey = 'intervalTime_' + this.mediaData.formId;
    await dataStore.putData(intervalTimeKey, this.mediaData.intervalTime);
    let isShowKey = 'isShowAlbums_' + this.mediaData.formId;
    await dataStore.putData(isShowKey, this.mediaData.isShowAlbum);
    let arkUriKey = 'arkUri_' + this.mediaData.formId;
    await dataStore.putData(arkUriKey, this.mediaData.arkUri);
    await dataStore.flush();
    Log.debug(TAG, 'storageSet end!');
  }

  async storageDelete(): Promise<void> {
    Log.debug(TAG, 'storageDelete start!');
    let formIdKey = 'formId_' + this.mediaData.formId;
    if (await dataStore.hasData(formIdKey)) {
      Log.debug(TAG, 'storageDelete formId');
      await dataStore.delData(formIdKey);
    }
    let displayNameKey = 'displayName_' + this.mediaData.formId;
    if (await dataStore.hasData(displayNameKey)) {
      Log.debug(TAG, 'storageDelete displayName');
      await dataStore.delData(displayNameKey);
    }
    let albumNameKey = 'albumName_' + this.mediaData.formId;
    if (await dataStore.hasData(albumNameKey)) {
      Log.debug(TAG, 'storageDelete albumName');
      await dataStore.delData(albumNameKey);
    }
    let albumUriKey = 'albumUri_' + this.mediaData.formId;
    if (await dataStore.hasData(albumUriKey)) {
      Log.debug(TAG, 'storageDelete albumUri');
      await dataStore.delData(albumUriKey);
    }
    let currentUriKey = 'currentUri_' + this.mediaData.formId;
    if (await dataStore.hasData(currentUriKey)) {
      Log.debug(TAG, 'storageDelete currentUri');
      await dataStore.delData(currentUriKey);
    }
    let currentIndexKey = 'currentIndex_' + this.mediaData.formId;
    if (await dataStore.hasData(currentIndexKey)) {
      Log.debug(TAG, 'storageDelete currentIndex');
      await dataStore.delData(currentIndexKey);
    }
    let intervalTimeKey = 'intervalTime_' + this.mediaData.formId;
    if (await dataStore.hasData(intervalTimeKey)) {
      Log.debug(TAG, 'storageDelete intervalTime');
      await dataStore.delData(intervalTimeKey);
    }
    let isShowKey = 'isShowAlbums_' + this.mediaData.formId;
    if (await dataStore.hasData(isShowKey)) {
      Log.debug(TAG, 'storageDelete isShowAlbumName');
      await dataStore.delData(isShowKey);
    }
    let arkUriKey = 'arkUri_' + this.mediaData.formId;
    if (await dataStore.hasData(arkUriKey)) {
      Log.debug(TAG, 'storageDelete arkUri');
      await dataStore.delData(arkUriKey);
    }
    await dataStore.flush();
    Log.debug(TAG, 'storageDelete end!');
  }

  updateMediaData(): void {
    Log.debug(TAG, `updateMediaData start! index ${this.mediaData.currentIndex}`);
    if (this.mediaData.currentIndex == -1) {
      this.mediaData.currentIndex = 0;
      this.isNextFag = false;
    } else if (this.mediaData.currentIndex >= this.items.length) {
      this.mediaData.currentIndex = 0;
      this.isNextFag = true;
    }
    else {
      this.isNextFag = true;
    }
    Log.debug(TAG, `updateMediaData start uri ${this.mediaData.currentUri} items.length ${this.items.length}
      ${JSON.stringify(this.items)}`);
    if (this.mediaData.currentUri != '') {
      let isExist = false;
      for (let i = 0; i < this.items.length; i++) {
        let uri = this.items[i].uri;
        if (uri == this.mediaData.currentUri) {
          this.mediaData.currentIndex = i;
          isExist = true;
        }
      }
      if (!isExist) {
        if (this.mediaData.isShowAlbum && (this.items.length !== 0) && (this.mediaData.currentIndex < this.items.length)) {
          let item = this.items[this.mediaData.currentIndex];
          this.mediaData.currentUri = item.uri;
          this.isUpdate = true;
        } else {
          this.mediaData.currentUri = '';
        }
        if (this.items.length == 0) {
          this.mediaData.currentUri = '';
        }
      }
    } else {
      if (this.mediaData.isShowAlbum && (this.items.length !== 0) &&
      (this.mediaData.currentIndex < this.items.length)) {
        let item = this.items[this.mediaData.currentIndex];
        this.mediaData.currentUri = item.uri;
      } else {
        this.mediaData.currentUri = '';
      }
    }
    Log.debug(TAG, `updateMediaData end! ${this.mediaData.currentIndex} uri ${this.mediaData.currentUri}`);
  }

  getUpdateTag(): boolean {
    return this.isUpdate;
  }

  setUpdateTag(isUpdate: boolean): void {
    this.isUpdate = isUpdate;
  }

  getCurrentItem(): userFileManager.FileAsset {
    if ((this.mediaData.currentIndex < this.items.length) &&
      (this.mediaData.currentUri != '')) {
      return this.items[this.mediaData.currentIndex];
    } else {
      return null;
    }
  }

  getCurrentAlbumName(): string {
    return this.mediaData.displayName;
  }

  getCurrentIndex(): number {
    return this.mediaData.currentIndex;
  }

  getIsShowAlbumName(): boolean {
    let isShowAlbum: boolean = this.mediaData.isShowAlbum == 1;
    let isShowName: boolean = Boolean(AppStorage.Get(Constants.FROM_PLAYBACK_ISSHOWNAME));
    Log.info(TAG, `getIsShowAlbumName isShowAlbum: ${isShowAlbum}  isShowName: ${isShowName}`);
    return isShowAlbum && isShowName;
  }

  getIntervalTime(): number {
    Log.debug(TAG, `getIntervalTime time ${this.mediaData.intervalTime}`);
    return this.mediaData.intervalTime;
  }

  setNextIndex(): void {
    Log.debug(TAG, `setNextIndex start old index ${this.mediaData.currentIndex} flag ${this.isNextFag}`);
    // this.mediaData.isShowAlbumName == false means select a photo instead of a album
    if (this.isNextFag && this.mediaData.isShowAlbum) {
      let index = this.mediaData.currentIndex;
      if ((this.items.length != 0) && (index < this.items.length - 1)) {
        index = index + 1;
      } else {
        index = 0;
      }
      this.mediaData.currentIndex = index;
      if (this.items.length >= 1) {
        let item = this.items[index];
        this.mediaData.currentUri = item.uri;
      } else {
        this.mediaData.currentUri = '';
      }
    }
    Log.debug(TAG, `setNextIndex index ${this.mediaData.currentIndex} uri ${this.mediaData.currentUri}`);
    this.saveData();
    Log.debug(TAG, 'setNextIndex end!');
  }

  getMediaData(): MediaData {
    return this.mediaData;
  }

  async openCurrentFd(): Promise<number> {
    let fileAsset = this.getCurrentItem();
    Log.info(TAG, `openCurrentFd uri: ${this.mediaData.currentUri}`);
    let fd = (fileAsset != null) ? await  this.mediaModel.openAsset('R', fileAsset) : -1;
    Log.info(TAG, `openCurrentFd the fd: ${fd}`);
    return fd;
  }

  getCurrentFd(): number {
    return this.fd;
  }

  async closeFd(): Promise<void> {
    Log.info(TAG, `close the fd: ${this.fd}`);
    let fileAsset = this.getCurrentItem();
    if (fileAsset != null && this.fd != -1) {
      await this.mediaModel.closeAsset(this.fd, fileAsset);
      this.fd = -1;
    }
  }

  async loadData(): Promise<void> {
    Log.debug(TAG, 'loadData start!');
    this.items = await this.getItems(this.mediaData.albumUri);
    if (this.items == null) {
      this.items = [];
    }
    Log.info(TAG, `get album objects: Name:${this.mediaData.albumName} length: ${this.items.length}`);
    await this.saveData();
    Log.debug(TAG, 'loadData end!');
  }

  async getItems(albumUri?: string, startIndex?: number, count?: number, filterMediaType?: string):
    Promise<Array<userFileManager.FileAsset>> {
    let result: Array<userFileManager.FileAsset> = null;

    // Get from target album if albumUri is not undefined, otherwise getAllObject
    if (albumUri) {
      let album: userFileManager.Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      let fetchResult = await album.getPhotoAssets(fetchOpt);
      result = await fetchResult.getAllObject();
      fetchResult.close();
    } else {
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      Log.debug(TAG, `getMediaItem start ${JSON.stringify(fetchOpt)}`);
      result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    }
    return result;
  }

  private async getSystemAlbumName(id: string): Promise<string> {
    try {
      let album = await this.mediaModel.getAlbumByUri(id);
      let result = await this.mediaModel.getAlbumName(album);
      return result;
    } catch (err) {
      Log.error(TAG, `update the display name failed, form ${id} ` + err);
    }
  }
}