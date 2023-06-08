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

import FormExtension from '@ohos.app.form.FormExtensionAbility';
import formBindingData from "@ohos.app.form.formBindingData";
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { FormControllerManager } from './controller/FormControllerManager';
import { FormController } from './controller/FormController';
import { Constants } from './common/Constants';
import { mediaModel } from '@ohos/base/src/main/ets/model/MediaModel';
import { dataStore } from '@ohos/base/src/main/ets/utils/DataStoreUtil';
import Want from '@ohos.app.ability.Want';
import { GlobalContext } from '@ohos/base/src/main/ets/utils/GlobalContext';

export class FormAbility extends FormExtension {
    private TAG: string = 'FormAbility';
    onAddForm(want: Want): formBindingData.FormBindingData | null {
        Log.info(this.TAG, "form onAddForm. want " + JSON.stringify(want));
        this.init();
        let param: Map<string, object> = new Map<string, object>(Object.entries<object>(want.parameters));
        let formId: string = param.get('ohos.extra.param.key.form_identity').toString();
        Log.info(this.TAG, "form onAddForm formId: " + formId);
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        let promise: Promise<void> = formControllerManager.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE);
        promise.then<object, never>((): Object | null => {
            let formController: FormController = formControllerManager.getController(formId);
            Log.info(this.TAG, "form onAddForm. formController " + formController);
            formController = (formController == null) ? formControllerManager.createFormController(formId,
                Constants.PHOTOS_FORM_OPERATION_MODE_NONE) : formController;
            if (formController == null) {
                 Log.error(this.TAG, "Get null controller. formId: " + formId);
                return null;
            }
            return formController.bindFormData(formId);
        }).catch<void>((err: Error): void => {
             Log.error(this.TAG, "init err " + err);
        })
        return null;
    }

    onCastToNormalForm(formId): void {
        Log.info(this.TAG, "onCastToNormalForm, formId: " + formId);
    }

    onUpdateForm(formId): void {
        Log.info(this.TAG, "onUpdateForm, formId: " + formId + " context " + JSON.stringify(this.context));
        // 经常起来后可能直接走onUpdate， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.updateController(formId);
    }

    onChangeFormVisibility(newStatus): void {
        Log.info(this.TAG, "onChangeFormVisibility, newStatus: " + JSON.stringify(newStatus));
        // 经常起来后可能直接走onChangeFormVisibility， 所以要初始化一下
        this.init();
        let ns: Map<string, number> = new Map<string, number>(Object.entries<number>(newStatus));
        this.clearCache(ns);
    }

    private async clearCache(newStatus: Map<string, number>): Promise<void> {
        try {
            let dataStoreInst = dataStore.getInstance();
            await dataStoreInst.removeCache();
            let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
            newStatus.forEach((value: number, key: string):void => {
                Log.info(this.TAG, "onVisibilityChange, key:" + key + "  value " + value);
                formControllerManager.initData(key, Constants.PHOTOS_FORM_OPERATION_MODE_NONE);
            });
        } catch (err) {
            Log.error(this.TAG, "clearCache err:" + JSON.stringify(err));
        }
    }

    onFormEvent(formId, message): void {
        Log.info(this.TAG, "onFormEvent, formId: " + formId + ", message: " + message);
        // 经常起来后可能直接走onEvent， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.onEvent(formId, message);
    }

    onRemoveForm(formId): void {
        Log.info(this.TAG, "onRemoveForm, formId: " + formId);
        // 经常起来后可能直接走onDestroy， 所以要初始化一下
        this.init();
        let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
        formControllerManager.destroyController(formId);
    }

    private init(): void {
        mediaModel.onCreate(this.context);
        GlobalContext.getContext().setObject("appContext", this.context);
    }
}
