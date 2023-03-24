/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import dataStore from '@ohos/base/src/main/ets/utils/DataStoreUtil';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { getAlbumDisplayName, getFetchOptions } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { Log } from '@ohos/base/src/main/ets/utils/Log';

const TAG = "MediaDataManager"

export class MediaDataManager {
    private mediaData: MediaData = null;
    private formController: any = null;
    private items: any[];
    private hasNewChange: boolean = false;
    private fd: number = -1;
    private key: string = '';
    private operationMode: number = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
    private isNextFag: boolean = true;
    private isUpdate: boolean = false;

    constructor(formId: string, operationMode: number, formController: any) {
        this.formController = formController;
        this.operationMode = operationMode;
        this.initData(formId);
    }

    async initData(formId: string) {
        Log.info(TAG, `initData formId ${formId}`);
        await this.storageRead(formId);
        if (this.mediaData == null || this.mediaData == undefined) {
            Log.info(TAG, 'initData new MediaData!');
            this.mediaData = new MediaData(formId,
                await getResourceString($r('app.string.album_camera')),
                Constants.PHOTOS_FORM_CAMERA_NAME, MediaConstants.ALBUM_ID_CAMERA, '', 0,
                Constants.PHOTOS_FORM_DEFAULT_PERIOD, 1, 0);
        }
        Log.info(TAG, `initData formId ${this.mediaData.formId}
            albumName ${this.mediaData.albumName} currentIndex ${this.mediaData.currentIndex}`);
        let displayName = await getAlbumDisplayName(this.mediaData.albumId);
        if (displayName != null) {
            this.mediaData.displayName = displayName;
            Log.info(TAG, 'initData displayName' + this.mediaData.displayName)
        }
        await this.loadData();
    }

    async saveData() {
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

    operationFormController() {
        Log.debug(TAG, `operFormControllerOper operationMode ${this.operationMode}`);
        switch (this.operationMode) {
            case Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY:
                this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
                this.formController.onDeleteForm(this.mediaData.formId);
                break;
            case Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE:
                this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
                this.formController.onUpdateFormData(this.mediaData.formId);
                break;
            case Constants.PHOTOS_FORM_OPERATION_MODE_EVENT:
                this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
                this.formController.onEvent(this.mediaData.formId);
                break;
            case Constants.PHOTOS_FORM_OPERATION_MODE_CALLBACK:
                this.operationMode = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
                this.formController.onCallback(this.mediaData.formId);
                break;
            default:
                this.formController.updateFormData(this.mediaData.formId, []);
                break;
        }
        Log.debug(TAG, 'operationFormController end!');
    }

    async storageRead(formId: string) {
        Log.debug(TAG, 'storageRead start!');
        let formIdKey: string = 'formId_' + formId
        let hasFormId = await dataStore.hasData(formIdKey);
        Log.debug(TAG, `The value of hasFormId is ${hasFormId}`)
        if (hasFormId) {
            let displayNameKey = 'displayName_' + formId;
            let displayName = await dataStore.getData(displayNameKey, '') as string;
            Log.debug(TAG, `The value of albumName is ${displayName}`);
            let albumNameKey = 'albumName_' + formId;
            let albumName = await dataStore.getData(albumNameKey, '') as string;
            Log.debug(TAG, `The value of albumName is ${albumName}`);
            let albumIdKey = 'albumId_' + formId;
            let albumId = await dataStore.getData(albumIdKey, '') as string;
            Log.debug(TAG, `The value of albumId is ${albumId}`);
            let currentUriKey = 'currentUri_' + formId;
            let currentUri = await dataStore.getData(currentUriKey, '') as string;
            Log.debug(TAG, `The value of currentUri is ${currentUri}`);
            let currentIndexKey = 'currentIndex_' + formId;
            let currentIndex = await dataStore.getData(currentIndexKey, 0) as number;
            Log.debug(TAG, `The value of currentIndex is ${currentIndex}`);
            let intervalTimeKey = 'intervalTime_' + formId;
            let intervalTime = await dataStore.getData(intervalTimeKey, 0) as number;
            Log.debug(TAG, `The value of intervalTime is ${intervalTime}`);
            let isShowKey = 'isShow_' + formId;
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
            this.mediaData = new MediaData(formId, displayName, albumName, albumId,
                currentUri, currentIndex, intervalTime, isShow, arkUri);
        }
        Log.debug(TAG, 'storageRead end!');
    }

    async storageSet() {
        Log.debug(TAG, 'storageSet start!');
        let formIdKey = 'formId_' + this.mediaData.formId;
        await dataStore.putData(formIdKey, this.mediaData.formId);
        let displayNameKey = 'displayName_' + this.mediaData.formId;
        await dataStore.putData(displayNameKey, this.mediaData.displayName);
        let albumNameKey = 'albumName_' + this.mediaData.formId;
        await dataStore.putData(albumNameKey, this.mediaData.albumName);
        let albumIdKey = 'albumId_' + this.mediaData.formId;
        await dataStore.putData(albumIdKey, this.mediaData.albumId);
        let currentUriKey = 'currentUri_' + this.mediaData.formId;
        await dataStore.putData(currentUriKey, this.mediaData.currentUri);
        let currentIndexKey = 'currentIndex_' + this.mediaData.formId;
        await dataStore.putData(currentIndexKey, this.mediaData.currentIndex);
        let intervalTimeKey = 'intervalTime_' + this.mediaData.formId;
        await dataStore.putData(intervalTimeKey, this.mediaData.intervalTime);
        let isShowKey = 'isShow_' + this.mediaData.formId;
        await dataStore.putData(isShowKey, this.mediaData.isShowAlbumName);
        let arkUriKey = 'arkUri_' + this.mediaData.formId;
        await dataStore.putData(arkUriKey, this.mediaData.arkUri);
        await dataStore.flush();
        Log.debug(TAG, 'storageSet end!');
    }

    async storageDelete() {
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
        let albumIdKey = 'albumId_' + this.mediaData.formId;
        if (await dataStore.hasData(albumIdKey)) {
            Log.debug(TAG, 'storageDelete albumId');
            await dataStore.delData(albumIdKey);
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
        let isShowKey = 'isShow_' + this.mediaData.formId;
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

    updateMediaData() {
        Log.debug(TAG, 'updateMediaData start! index ${this.mediaData.currentIndex}');
        if (this.mediaData.currentIndex == -1) {
            this.mediaData.currentIndex = 0;
            this.isNextFag = false;
        } else {
            this.isNextFag = true;
        }
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
                if ((this.items.length != 0) && (this.mediaData.currentIndex < this.items.length)) {
                    this.mediaData.currentUri = this.items[this.mediaData.currentIndex].uri;
                    this.isUpdate = true;
                }
                if ((this.items.length == 0) || (this.mediaData.isShowAlbumName == 0)) {
                    this.mediaData.currentUri = '';
                }
            }
        } else {
            if ((this.items.length != 0) &&
            (this.mediaData.currentIndex < this.items.length) &&
            (this.mediaData.isShowAlbumName != 0)) {
                this.mediaData.currentUri = this.items[this.mediaData.currentIndex].uri;
            }
        }
        Log.debug(TAG, 'updateMediaData end!');
    }

    getUpdateTag() {
        return this.isUpdate;
    }

    setUpdateTag(isUpdate: boolean) {
        this.isUpdate = isUpdate;
    }

    getCurrentItem(): any {
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
        return this.mediaData.isShowAlbumName == 1 ? true : false;
    }

    getIntervalTime(): number {
        Log.debug(TAG, `getIntervalTime time ${this.mediaData.intervalTime}`);
        return this.mediaData.intervalTime;
    }

    setNextIndex() {
        Log.debug(TAG, `setNextIndex start old index ${this.mediaData.currentIndex} flag ${this.isNextFag}`);
        // this.mediaData.isShowAlbumName == false means select a photo instead of a album
        if (this.isNextFag && this.mediaData.isShowAlbumName) {
            let index = this.mediaData.currentIndex;
            if ((this.items.length != 0) && (index < this.items.length - 1)) {
                index = index + 1;
            } else {
                index = 0;
            }
            this.mediaData.currentIndex = index;
            if (this.items.length >= 1) {
                this.mediaData.currentUri = this.items[index].uri;
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
        let fd = (fileAsset != null) ? await  mediaModel.openAsset('R', fileAsset) : -1;
         Log.info(TAG, `openCurrentFd the fd: ${fd}`);
        return fd;
    }

    getCurrentFd(): number {
        return this.fd;
    }

    async closeFd() {
         Log.info(TAG, `close the fd: ${this.fd}`);
        let fileAsset = this.getCurrentItem();
        if (fileAsset != null && this.fd != -1) {
            await mediaModel.closeAsset(this.fd, fileAsset);
            this.fd = -1;
        }
    }

    async loadData() {
        Log.debug(TAG, 'loadData start!');
        this.items = await this.getItems(this.mediaData.albumId);
        if (this.items == null) {
            this.items = [];
        }
         Log.info(TAG, `get album objects: Name:${this.mediaData.albumName} length: ${this.items.length}`);
        await this.saveData();
        Log.debug(TAG, 'loadData end!');
    }

    async getItems(albumId: string) {
         Log.info(TAG, 'getItems start!');
        let fetchOpt = await getFetchOptions(MediaConstants.SELECT_TYPE_IMAGE, albumId, "")
        if (albumId == MediaConstants.ALBUM_ID_FAVOR) {
            return await mediaModel.getAllFavorMediaItems(fetchOpt)
        } else {
            return await mediaModel.getAllMediaItems(fetchOpt)
        }
    }
}