// @ts-nocheck
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
import { MediaData } from './MediaData'
import { Constants } from '../common/Constants'
import { Logger } from '../common/Logger'
import { AlbumDefine } from '../../common/model/browser/AlbumDefine'
import { DataStoreUtil } from '../../common/utils/DataStoreUtil'
import { MediaLibraryAccess } from '../../common/access/MediaLibraryAccess'
import resourceManager from '@ohos.resourceManager';

export class MediaDataManager {
    private mediaData: MediaData = null;
    private formController: any = null;
    private items: any[];
    private logger: Logger = new Logger('MediaDataManager');
    private hasNewChange: boolean = false;
    private fd: number = -1;
    private key: string = '';
    private operationMode: number = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
    private context: any;
    private isNextFag: boolean = true;
    private isUpdate: boolean = false;

    constructor(context: any, formId: string, operationMode: number, formController: any) {
        this.formController = formController;
        this.operationMode = operationMode;
        this.context = context;
        this.initData(formId);
    }

    async getResourceString(resource: Resource) {
        try {
            this.logger.info(`getResourceString: ${JSON.stringify(resource)}`);
            let mgr: resourceManager.ResourceManager = await resourceManager.getResourceManager(this.context);
            if (mgr != null || mgr != undefined) {
                return await mgr.getString(resource.id);
            } else {
                this.logger.error(`getResourceManager instance is none`);
                return null;
            }
        } catch (error) {
            this.logger.error(`getResourceString error: ${error}`);
            return null;
        }
    }

    async initData(formId: string) {
        this.logger.info(`initData formId ${formId}`);
        MediaLibraryAccess.getInstance().onCreate(this.context);
        MediaLibraryAccess.getInstance().getPublicDirectory().then(async () => {
            await this.storageRead(formId);
            if (this.mediaData == null || this.mediaData == undefined) {
                this.logger.info('initData new MediaData!');
                this.mediaData = new MediaData(formId,
                    await this.getResourceString($r('app.string.album_camera')),
                    Constants.PHOTOS_FORM_CAMERA_NAME, AlbumDefine.ALBUM_ID_CAMERA, '', 0,
                    Constants.PHOTOS_FORM_DEFAULT_PERIOD, 1, 0);
            }
            this.logger.info(`initData formId ${this.mediaData.formId}
            albumName ${this.mediaData.albumName} currentIndex ${this.mediaData.currentIndex}`);
            let displayName = await this.getAlbumDisplayName(this.mediaData.albumId);
            if (displayName != null) {
                this.mediaData.displayName = displayName;
                this.logger.info('initData displayName' + this.mediaData.displayName)
            }
            await this.loadData();
        });
    }

    private async getAlbumDisplayName(formId) {
        this.logger.debug('getAlbumDisplayName name ' + formId)
        switch (formId) {
            case AlbumDefine.ALBUM_ID_ALL:
                return await this.getResourceString($r('app.string.album_all'));
            case AlbumDefine.ALBUM_ID_CAMERA:
                return await this.getResourceString($r('app.string.album_camera'));
            case AlbumDefine.ALBUM_ID_FAVOR:
                return await this.getResourceString($r('app.string.album_favor'));
            case AlbumDefine.ALBUM_ID_REMOTE:
                return await this.getResourceString($r('app.string.album_remote_device'));
            case AlbumDefine.ALBUM_ID_SNAPSHOT:
                return await this.getResourceString($r('app.string.album_screen_shot'));
            default:
                break;
        }
        return null;
    }

    async saveData() {
        this.logger.debug('saveData');
        this.filterOutVideoMediaData();
        this.updateMediaData();
        if (((this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_EVENT)
        && (this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY)
        && (this.operationMode != Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE)) || this.isUpdate) {
            try {
                this.fd = await this.openCurrentFd();
            } catch (error) {
                this.logger.error(`open Fd failed: ${error}`);
            }
        }
        this.logger.debug(`saveData fd: ${this.fd}`);
        await this.storageSet();
        this.operationFormController();
    }

    operationFormController() {
        this.logger.debug(`operFormControllerOper operationMode ${this.operationMode}`);
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
        this.logger.debug('operationFormController end!');
    }

    async storageRead(formId: string) {
        this.logger.debug('storageRead start!');
        let formIdKey: string = 'formId_' + formId
        let hasFormId = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(formIdKey);
        this.logger.debug(`The value of hasFormId is ${hasFormId}`)
        if (hasFormId) {
            let displayNameKey = 'displayName_' + formId;
            let displayName = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(displayNameKey, '') as string;
            this.logger.debug(`The value of albumName is ${displayName}`);
            let albumNameKey = 'albumName_' + formId;
            let albumName = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(albumNameKey, '') as string;
            this.logger.debug(`The value of albumName is ${albumName}`);
            let albumIdKey = 'albumId_' + formId;
            let albumId = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(albumIdKey, '') as string;
            this.logger.debug(`The value of albumId is ${albumId}`);
            let currentUriKey = 'currentUri_' + formId;
            let currentUri = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(currentUriKey, '') as string;
            this.logger.debug(`The value of currentUri is ${currentUri}`);
            let currentIndexKey = 'currentIndex_' + formId;
            let currentIndex = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(currentIndexKey, 0) as number;
            this.logger.debug(`The value of currentIndex is ${currentIndex}`);
            let intervalTimeKey = 'intervalTime_' + formId;
            let intervalTime = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(intervalTimeKey, 0) as number;
            this.logger.debug(`The value of intervalTime is ${intervalTime}`);
            let isShowKey = 'isShow_' + formId;
            let isShow = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(isShowKey, 0) as number;
            this.logger.debug(`The value of isShow is ${isShow}`);
            let arkUriKey = 'arkUri_' + formId;
            let arkUri = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).getData(arkUriKey, 0) as number;
            this.logger.debug(`The value of arkUri is ${arkUri}`);
            if (arkUri == 0) {
                arkUri = 1;
            } else {
                arkUri = 0;
            }
            this.mediaData = new MediaData(formId, displayName, albumName, albumId,
                currentUri, currentIndex, intervalTime, isShow, arkUri);
        }
        this.logger.debug('storageRead end!');
    }

    async storageSet() {
        this.logger.debug('storageSet start!');
        let formIdKey = 'formId_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(formIdKey, this.mediaData.formId);
        let displayNameKey = 'displayName_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(displayNameKey, this.mediaData.displayName);
        let albumNameKey = 'albumName_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(albumNameKey, this.mediaData.albumName);
        let albumIdKey = 'albumId_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(albumIdKey, this.mediaData.albumId);
        let currentUriKey = 'currentUri_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(currentUriKey, this.mediaData.currentUri);
        let currentIndexKey = 'currentIndex_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(currentIndexKey, this.mediaData.currentIndex);
        let intervalTimeKey = 'intervalTime_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(intervalTimeKey, this.mediaData.intervalTime);
        let isShowKey = 'isShow_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(isShowKey, this.mediaData.isShowAlbumName);
        let arkUriKey = 'arkUri_' + this.mediaData.formId;
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(arkUriKey, this.mediaData.arkUri);
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).flush();
        this.logger.debug('storageSet end!');
    }

    async storageDelete() {
        this.logger.debug('storageDelete start!');
        let formIdKey = 'formId_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(formIdKey)) {
            this.logger.debug('storageDelete formId');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(formIdKey);
        }
        let displayNameKey = 'displayName_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(displayNameKey)) {
            this.logger.debug('storageDelete displayName');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(displayNameKey);
        }
        let albumNameKey = 'albumName_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(albumNameKey)) {
            this.logger.debug('storageDelete albumName');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(albumNameKey);
        }
        let albumIdKey = 'albumId_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(albumIdKey)) {
            this.logger.debug('storageDelete albumId');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(albumIdKey);
        }
        let currentUriKey = 'currentUri_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(currentUriKey)) {
            this.logger.debug('storageDelete currentUri');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(currentUriKey);
        }
        let currentIndexKey = 'currentIndex_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(currentIndexKey)) {
            this.logger.debug('storageDelete currentIndex');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(currentIndexKey);
        }
        let intervalTimeKey = 'intervalTime_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(intervalTimeKey)) {
            this.logger.debug('storageDelete intervalTime');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(intervalTimeKey);
        }
        let isShowKey = 'isShow_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(isShowKey)) {
            this.logger.debug('storageDelete isShowAlbumName');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(isShowKey);
        }
        let arkUriKey = 'arkUri_' + this.mediaData.formId;
        if (await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(arkUriKey)) {
            this.logger.debug('storageDelete arkUri');
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).delData(arkUriKey);
        }
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).flush();
        this.logger.debug('storageDelete end!');
    }

    setMediaData(displayName: string, albumName: string, currentUri: string, intervalTime: number) {
        this.logger.debug('setAlbumNameAndUri start!');
        if (this.mediaData != null) {
            this.mediaData.currentUri = currentUri;
            if (this.mediaData.currentUri == '') {
                this.mediaData.currentIndex = 0;
            }
            this.mediaData.intervalTime = intervalTime;
            if (this.mediaData.albumName != albumName) {
                this.mediaData.albumName = albumName;
                this.loadData();
            } else {
                this.saveData();
            }
        }
        this.logger.debug('setAlbumNameAndUri end!');
    }

    filterOutVideoMediaData() {
        this.logger.debug('filterOutVideoMediaData start!');
        if (this.items.length == 0) {
            return;
        }
        if (this.items[this.mediaData.currentIndex].mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
            return;
        }
        let currentIndex = this.mediaData.currentIndex;
        for (let i = currentIndex; i < this.items.length; i++) {
            let type = this.items[i].mediaType;
            if (type == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
                this.mediaData.currentIndex = i;
                return;
            }
        }
        if (currentIndex != 0) {
            for (let i = 0; i < this.items.length; i++) {
                let type = this.items[i].mediaType;
                if (type == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
                    this.mediaData.currentIndex = i;
                    return;
                }
            }
        }
        this.mediaData.currentIndex = 0;
        this.logger.debug('filterOutVideoMediaData end!');
    }

    updateMediaData() {
        this.logger.debug('updateMediaData start! index ${this.mediaData.currentIndex}');
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
        this.logger.debug('updateMediaData end!');
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
        this.logger.debug(`getIntervalTime time ${this.mediaData.intervalTime}`);
        return this.mediaData.intervalTime;
    }

    setNextIndex() {
        this.logger.debug(`setNextIndex start old index ${this.mediaData.currentIndex} flag ${this.isNextFag}`);
        if (this.isNextFag) {
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
        this.logger.debug(`setNextIndex index ${this.mediaData.currentIndex} uri ${this.mediaData.currentUri}`);
        this.saveData();
        this.logger.debug('setNextIndex end!');
    }

    getMediaData(): MediaData {
        return this.mediaData;
    }

    async openCurrentFd(): Promise<number> {
        let fileAsset = this.getCurrentItem();
        this.logger.info(`openCurrentFd uri: ${this.mediaData.currentUri}`);
        let fd = (fileAsset != null) ? await  MediaLibraryAccess.getInstance().openAsset('R', fileAsset) : -1;
        this.logger.info(`openCurrentFd the fd: ${fd}`);
        return fd;
    }

    getCurrentFd(): number {
        return this.fd;
    }

    async closeFd() {
        this.logger.info(`close the fd: ${this.fd}`);
        let fileAsset = this.getCurrentItem();
        if (fileAsset != null && this.fd != -1) {
            await MediaLibraryAccess.getInstance().closeAsset(this.fd, fileAsset);
            this.fd = -1;
        }
    }

    async loadData() {
        this.logger.debug('loadData start!');
        this.items = await this.getItems(this.mediaData.albumId);
        if (this.items == null) {
            this.items = [];
        }
        this.logger.info(`get album objects: Name:${this.mediaData.albumName} length: ${this.items.length}`);
        await this.saveData();
        this.logger.debug('loadData end!');
    }

    async getItems(albumId: string, startIndex?: number, count?: number, deviceId?) {
        this.logger.info('getItems start!');
        let fetchOpt = AlbumDefine.getFileFetchOpt(albumId, deviceId, startIndex, count);
        switch (albumId) {
            case AlbumDefine.ALBUM_ID_ALL:
                let allObject = await MediaLibraryAccess.getInstance().getAllObject(fetchOpt);
                return allObject;
                break;
            default:
                return await MediaLibraryAccess.getInstance().getEntityAlbumObject(AlbumDefine.getAlbumFetchOpt(
                    albumId, deviceId), fetchOpt);
                break;
        }
    }
}