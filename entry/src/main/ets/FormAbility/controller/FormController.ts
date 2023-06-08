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
import Want from '@ohos.application.Want';
import { MediaDataManager } from '../data/MediaDataManager';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { startAbility } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import formBindingData from '@ohos.application.formBindingData';
import { Constants } from '../common/Constants';
import formProvider from '@ohos.application.formProvider';
import { Constants as commonConstants } from '../../common/model/common/Constants';

const TAG = "FormController"

export class FormController {
    private formId: string;
    private operationMode: number = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
    private callback: Function = null;
    private static readonly MSG_ROUTER_PHOTOS = 'routerPhotos';
    mediaDataManager: MediaDataManager;

    constructor(formId: string, operationMode: number, callback?: Function) {
        this.formId = formId;
        this.operationMode = operationMode;
        this.callback = callback;
        this.mediaDataManager = new MediaDataManager(formId, operationMode, this);
    }

    bindFormData(formId: string): formBindingData.FormBindingData {
        Log.info(TAG, "bindFormData start formId: " + formId)
        let fd = this.mediaDataManager.getCurrentFd();
        let mediaData = this.mediaDataManager.getMediaData();
        let image: string = "image_" + fd + "_formId_" + formId + "_uri_" + mediaData.currentUri;
        let dataObj1: Object = {
            fd: fd == -1 ? false : true,
            image1: "memory://" + image,
            albumName: this.mediaDataManager.getCurrentAlbumName(),
            currentIndex: this.mediaDataManager.getCurrentIndex(),
            isShow: this.mediaDataManager.getIsShowAlbumName(),
            formImages: JSON.parse("{ \"" + image + "\": " + fd + " }"),
            uri: (mediaData.currentUri !== '') ? commonConstants.ACTION_URI_FORM_ABILITY : commonConstants.ACTION_URI_FORM_ABILITY_NONE,
            albumId: mediaData.albumId,
            currentUri: mediaData.currentUri
        };
        Log.debug(TAG, "bindFormData, createFormBindingData dataObj2.data: " + JSON.stringify(dataObj1));
        let obj = formBindingData.createFormBindingData(JSON.stringify(dataObj1));
        Log.debug(TAG, "bindFormData, createFormBindingData obj2.data: " + JSON.stringify(obj.data));
        return obj as formBindingData.FormBindingData;
    }

    updateFormData(formId: string, vars: string[]): void {
        Log.debug(TAG, "updateFormData formId: " + JSON.stringify(formId));
        let obj3 = this.bindFormData(formId);
        Log.debug(TAG, "updateFormData obj: " + JSON.stringify(obj3));
        formProvider.updateForm(formId, obj3)
            .then((data: void): void => {
                Log.info(TAG, "updateFormData, data: " + JSON.stringify(data));
                if (this.mediaDataManager.getIsShowAlbumName()) {
                    formProvider.setFormNextRefreshTime(formId, this.mediaDataManager.getIntervalTime()).then((): void => {
                         Log.error(TAG, "setFormNextRefreshTime successfully!");
                        if (this.callback != null) {
                            this.callback.call(this.callback);
                        }
                        this.onDestroy();
                    }).catch((err: Error): void => {
                         Log.error(TAG, "init err " + err);
                    })
                } else {
                    if (this.callback != null) {
                        this.callback.call(this.callback);
                    }
                    this.onDestroy();
                }
            }).catch((error: Error): void => {
             Log.error(TAG, "updateForm failed. Cause: " + JSON.stringify(error));
            this.mediaDataManager.closeFd();
        });
    }

    onDestroy(): void {
        Log.info(TAG, 'onDestroy start!');
        this.mediaDataManager.closeFd();
        this.callback = null;
        Log.info(TAG, 'onDestroy done end!');
    }

    onUpdateFormData(formId: string): void {
        Log.debug(TAG, "onUpdateFormData formId: " + formId);
        this.mediaDataManager.setNextIndex();
    }

    routerPhotoBrowser(): void {
        Log.debug(TAG, 'routerPhotoBrowser start!');
        let wantParameters: Object = {
            uri: (
                       this.mediaDataManager.getMediaData()
                       .currentUri != '') ? commonConstants.ACTION_URI_FORM_ABILITY : commonConstants.ACTION_URI_FORM_ABILITY_NONE,
            albumId: this.mediaDataManager.getMediaData().albumId,
            currentIndex: this.mediaDataManager.getMediaData().currentIndex
        };
        let param: Want = {
            'bundleName': 'com.ohos.photos',
            'abilityName': 'com.ohos.photos.MainAbility',
            'parameters': wantParameters

        };
        Log.debug(TAG, "routerPhotoBrowser parm " + JSON.stringify(param));
        startAbility(param).then((): void => {
            AppStorage.Delete(Constants.FROM_CONTROLLER_MANAGER);
        })
        this.onDestroy();
        Log.debug(TAG, 'routerPhotoBrowser end!');
    }

    onTriggerFormEvent(formId: string, message): void {
        Log.debug(TAG, "onTriggerFormEvent " + formId + " " + message);
        let msgObj: Map<string, object> = JSON.parse(message);
        let param: Map<string, object> = new Map(Object.entries(msgObj.get("params")));
        let msg: string = param.get("message").toString();
        Log.debug(TAG, "onTriggerFormEvent " + param + " " + msg);
        if (msg == FormController.MSG_ROUTER_PHOTOS) {
            this.routerPhotoBrowser();
        }
    }

    onEvent(formId: string): void {
        Log.debug(TAG, 'onEvent start!');
        if (this.callback != null) {
            if (this.mediaDataManager.getUpdateTag()) {
                this.mediaDataManager.setUpdateTag(false)
                Log.debug(TAG, "updateFormData formId: " + JSON.stringify(formId));
                let obj3 = this.bindFormData(formId);
                Log.debug(TAG, "updateFormData obj: " + JSON.stringify(obj3));
                formProvider.updateForm(formId, obj3).then((data: void): void => {
                    Log.info(TAG, "updateFormData, data: " + JSON.stringify(data));
                    this.onTriggerFormEvent(formId, this.callback.call(this.callback));
                }).catch((error: Error): void => {
                    this.onTriggerFormEvent(formId, this.callback.call(this.callback));
                });
            } else {
                this.onTriggerFormEvent(formId, this.callback.call(this.callback));
            }
        }
        Log.debug(TAG, 'onEvent end!');
    }

    onCallback(formId: string): void {
        Log.debug(TAG, 'onCallback start!');
        if (this.callback != null) {
            this.callback.call(this.callback);
        }
        Log.debug(TAG, 'onCallback end!');
    }

    onDeleteForm(formId: string): void {
        this.mediaDataManager.storageDelete();
    }
}
