/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import FormExtension from '@ohos.application.FormExtension';
import { Log } from '../../../../../common/base/src/main/ets/utils/Log';
import { FormControllerManager } from './controller/FormControllerManager';
import { FormController } from './controller/FormController';
import { Constants } from './common/Constants';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';

export default class FormAbility extends FormExtension {
    private TAG: string = 'FormAbility';
    onCreate(want) {
        Log.info(this.TAG, `form onCreate. want ${JSON.stringify(want)}`);
        this.init();
        let param = want.parameters;
        let formId = param['ohos.extra.param.key.form_identity'];
        Log.info(this.TAG, `form onCreate formId: ${formId}`);
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE).then(() => {
            let formController: FormController = formControllerManager.getController(formId);
            Log.info(this.TAG, `form onCreate. formController ${formController}`);
            formController = (formController == null) ? formControllerManager.createFormController(formId,
                Constants.PHOTOS_FORM_OPERATION_MODE_NONE) : formController;
            if (formController == null) {
                 Log.error(this.TAG, `Get null controller. formId: ${formId}`);
                return null;
            }
            return formController.bindFormData(formId);
        }).catch((err) => {
             Log.error(this.TAG, `init err ${err}`);
        })
        return null;
    }

    onCastToNormal(formId) {
        Log.info(this.TAG, `onCastToNormal, formId: ${formId}`);
    }

    onUpdate(formId) {
        Log.info(this.TAG, `onUpdate, formId: ${formId} context ${JSON.stringify(this.context)}`);
        // 经常起来后可能直接走onUpdate， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.updateController(formId);
    }

    onVisibilityChange(newStatus) {
        Log.info(this.TAG, `onVisibilityChange, newStatus: ${JSON.stringify(newStatus)}`);
        // 经常起来后可能直接走onVisibilityChange， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        for (let key in newStatus) {
            Log.info(this.TAG, `onVisibilityChange, key:${key}  value ${newStatus[key]}`);
            let formId = key;
            formControllerManager.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE);
        }
    }

    onEvent(formId, message) {
        Log.info(this.TAG, `onEvent, formId: ${formId}, message: ${message}`);
        // 经常起来后可能直接走onEvent， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.onEvent(formId, message);
    }

    onDestroy(formId) {
        Log.info(this.TAG, `onDestroy, formId: ${formId}`);
        // 经常起来后可能直接走onDestroy， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.destroyController(formId);
    }

    private init() {
        mediaModel.onCreate(this.context);
        globalThis.appContext = this.context;
    }
};