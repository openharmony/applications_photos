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

import { MediaDataManager } from '../data/MediaDataManager'
import { Logger } from '../common/Logger'
import formBindingData from '@ohos.application.formBindingData';
import { Constants } from '../common/Constants'
import { DataStoreUtil } from '../../common/utils/DataStoreUtil'
import formProvider from '@ohos.application.formProvider';
import { MediaLibraryAccess } from '../../common/access/MediaLibraryAccess'
import { Constants as commonConstants } from '../../common/model/common/Constants'

export class FormController {
    private context: any;
    private formId: string;
    private operationMode: number = Constants.PHOTOS_FORM_OPERATION_MODE_NONE;
    private logger: Logger = new Logger('FormController');
    private callback: Function = null;
    private static readonly MSG_ROUTER_PHOTOS = 'routerPhotos'
    mediaDataManager: MediaDataManager;

    constructor(context: any, formId: string, operationMode: number, callback?: Function) {
        this.context = context;
        this.formId = formId;
        this.operationMode = operationMode;
        this.callback = callback;
        this.mediaDataManager = new MediaDataManager(context, formId, operationMode, this);
    }

    bindFormData(formId: string): any {
        this.logger.info(`bindFormData start formId: ${formId}`)
        let fd = this.mediaDataManager.getCurrentFd();
        let image: string = "image_" + fd + "_formId_" + this.mediaDataManager.getMediaData().formId;
        let dataObj1: any = {
            "fd": fd == -1 ? false : true,
            "image1": "memory://" + image,
            "albumName": this.mediaDataManager.getCurrentAlbumName(),
            "currentIndex": this.mediaDataManager.getCurrentIndex(),
            "isShow": this.mediaDataManager.getIsShowAlbumName(),
            "formImages": JSON.parse(`{ "${image}": ${fd} }`)
        };
        this.logger.debug(`bindFormData, createFormBindingData dataObj2.data: ${JSON.stringify(dataObj1)}`);
        let obj = formBindingData.createFormBindingData(JSON.stringify(dataObj1));
        this.logger.debug(`bindFormData, createFormBindingData obj2.data: ${JSON.stringify(obj.data)}`);
        return obj;
    }

    updateFormData(formId: string, vars: string[]): void {
        this.logger.debug(`updateFormData formId: ${JSON.stringify(formId)}`);
        let obj3 = this.bindFormData(formId);
        this.logger.debug(`updateFormData obj: ${JSON.stringify(obj3)}`);
        formProvider.updateForm(formId, obj3)
            .then((data) => {
                this.logger.info(`updateFormData, data: ${JSON.stringify(data)}`);
                if (this.mediaDataManager.getIsShowAlbumName()) {
                    formProvider.setFormNextRefreshTime(formId, this.mediaDataManager.getIntervalTime()).then(() => {
                        this.logger.error(`setFormNextRefreshTime successfully!`);
                        if (this.callback != null) {
                            this.callback.call(this.callback);
                        }
                        this.onDestroy();
                    }).catch((err) => {
                        this.logger.error(`init err ${err}`);
                    })
                } else {
                    if (this.callback != null) {
                        this.callback.call(this.callback);
                    }
                    this.onDestroy();
                }
            }).catch((error) => {
            this.logger.error(`updateForm failed. Cause: ${JSON.stringify(error)}`);
            this.mediaDataManager.closeFd();
        });
    }

    onDestroy() {
        this.logger.info('onDestroy start!');
        this.mediaDataManager.closeFd();
        MediaLibraryAccess.getInstance().onDestroy();
        this.callback = null;
        this.logger.info('onDestroy done end!');
    }

    onUpdateFormData(formId: string): void {
        this.logger.debug(`onUpdateFormData formId: ${formId}`);
        this.mediaDataManager.setNextIndex();
    }

    routerPhotoBrowser() {
        this.logger.debug('routerPhotoBrowser start!');
        let param = {
            'bundleName': 'com.ohos.photos',
            'abilityName': 'com.ohos.photos.MainAbility',
            'parameters': {
                'uri': (
                           this.mediaDataManager.getMediaData()
                           .currentUri != '') ? commonConstants.ACTION_URI_FORM_ABILITY : commonConstants.ACTION_URI_FORM_ABILITY_NONE,
                'albumId': `${this.mediaDataManager.getMediaData().albumId}`,
                'currentIndex': this.mediaDataManager.getMediaData().currentIndex
            }
        };
        this.logger.debug(`routerPhotoBrowser parm ${JSON.stringify(param)}`);
        this.context.startAbility(param).then(() => {
            this.logger.info(`raul startAbility complete`);
            AppStorage.Delete(Constants.FROM_CONTROLLER_MANAGER);
        });
        this.onDestroy();
        this.logger.debug('routerPhotoBrowser end!');
    }

    onTriggerFormEvent(formId: string, message): void {
        this.logger.debug(`onTriggerFormEvent ${formId} ${message}`);
        let msgObj = JSON.parse(message);
        let param = msgObj["params"];
        let msg = param["message"];
        this.logger.debug(`onTriggerFormEvent ${param} ${msg}`);
        if (msg == FormController.MSG_ROUTER_PHOTOS) {
            this.routerPhotoBrowser();
        }
    }

    onEvent(formId: string): void {
        this.logger.debug('onEvent start!');
        if (this.callback != null) {
            if (this.mediaDataManager.getUpdateTag()) {
                this.mediaDataManager.setUpdateTag(false)
                this.logger.debug(`updateFormData formId: ${JSON.stringify(formId)}`);
                let obj3 = this.bindFormData(formId);
                this.logger.debug(`updateFormData obj: ${JSON.stringify(obj3)}`);
                formProvider.updateForm(formId, obj3).then((data) => {
                    this.logger.info(`updateFormData, data: ${JSON.stringify(data)}`);
                    this.onTriggerFormEvent(formId, this.callback.call(this.callback));
                }).catch((error) => {
                    this.onTriggerFormEvent(formId, this.callback.call(this.callback));
                });
            } else {
                this.onTriggerFormEvent(formId, this.callback.call(this.callback));
            }
        }
        this.logger.debug('onEvent end!');
    }

    onCallback(): void {
        this.logger.debug('onCallback start!');
        if (this.callback != null) {
            this.callback.call(this.callback);
        }
        this.logger.debug('onCallback end!');
    }

    onDeleteForm(formId: string): void {
        this.mediaDataManager.storageDelete();
    }
}