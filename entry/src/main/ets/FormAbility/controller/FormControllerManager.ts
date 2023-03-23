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
import { Constants } from '../common/Constants';
import { FormController } from './FormController';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import dataStore from '@ohos/base/src/main/ets/utils/DataStoreUtil';

export class FormControllerManager {
    private TAG: string = 'FormControllerManager';
    private formControllerMap = new Map();

    private constructor() {
        Log.info(this.TAG, 'new FormControllerManager');
    }

    public static getInstance(): FormControllerManager {
        if (AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER) == null) {
            AppStorage.SetOrCreate(Constants.FROM_CONTROLLER_MANAGER, new FormControllerManager());
        }
        return AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER);
    }

    public createFormController(formId: string, operationMode: number, callback?: Function): FormController {
        Log.debug(this.TAG, 'createFormController start!');
        if (formId == '0') {
            Log.info(this.TAG, 'formId is 0 or formName is null!');
            return null;
        }
        let controller = new FormController(formId, operationMode, callback);

        if (controller == null || controller == undefined) {
            Log.error(this.TAG, 'It is failed to create FormController!');
            return null;
        }
        this.formControllerMap.set(formId, controller);
        Log.debug(this.TAG, 'createFormController end!');
        return controller;
    }

    async initData(formId: string, operationMode: number, callback?: Function): Promise<void> {
        Log.debug(this.TAG, `initData start! operationMode: ${operationMode}`);
        try {
            await dataStore.init();
            let formIdKey: string = 'formId_' + formId;
            let hasFormId = await dataStore.hasData(formIdKey);
            Log.debug(this.TAG, `The value of hasFormId is ${hasFormId}`);
            if (hasFormId) {
                this.createFormController(formId, operationMode, callback);
            }
        } catch (err) {
            Log.error(this.TAG, `init err ${err}`);
        }
        Log.debug(this.TAG, 'initData end!');
    }

    public destroyController(formId: string): void {
        this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY);
    }

    public updateController(formId: string, callback?: Function): void {
        this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE, callback);
    }

    public onEvent(formId: string, message: string): void {
        this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_EVENT, function (): any {
            return message;
        })
    }

    public onCallback(formId: string, callback: Function): void {
        this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_CALLBACK, callback);
    }

    public getController(formId: string): FormController {
        Log.debug(this.TAG, 'getController start!');
        let controller: FormController = this.formControllerMap.get(formId);
        if (controller == null || controller == undefined) {
            Log.info(this.TAG, `has no controller with formid ${formId}`);
            return null;
        }
        Log.debug(this.TAG, 'getController end!');
        return controller;
    }

    public deleteFormController(formId: string): void {
        Log.debug(this.TAG, 'deleteFormController start!')
        if (this.formControllerMap.has(formId)) {
            let ret = this.formControllerMap.delete(formId);
            if (ret) {
                Log.info(this.TAG, 'It is successful to delete FormController');
            } else {
                Log.error(this.TAG, 'It is failed to delete FormController');
            }
        } else {
            Log.info(this.TAG, `deleteFormController, It has no controller with formid ${formId}`);
        }

        Log.debug(this.TAG, 'deleteFormController end!');
    }
}