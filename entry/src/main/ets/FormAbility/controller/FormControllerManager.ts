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
import { Constants } from '../common/Constants'
import { FormController } from './FormController'
import { Logger } from '../common/Logger'
import { DataStoreUtil } from '../../common/utils/DataStoreUtil'

export class FormControllerManager {
    private context: any;
    private formControllerMap = new Map();
    private logger: Logger = new Logger('FormControllerManager');

    private constructor(context) {
        this.logger.info('new FormControllerManager');
        this.context = context;
        DataStoreUtil.getInstance(globalThis.photosGlobalContext);
    }

    public static getInstance(context: any): FormControllerManager {
        if (AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER) == null) {
            AppStorage.SetOrCreate(Constants.FROM_CONTROLLER_MANAGER, new FormControllerManager(context));
        }
        return AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER);
    }

    public createFormController(formId: string, operationMode: number, callback?: Function): FormController {
        this.logger.debug('createFormController start!');
        if (formId == '0') {
            this.logger.info('formId is 0 or formName is null!');
            return null;
        }
        let controller = new FormController(this.context, formId, operationMode, callback);

        if (controller == null || controller == undefined) {
            this.logger.error('It is failed to create FormController!');
            return null;
        }
        this.formControllerMap.set(formId, controller);
        this.logger.debug('createFormController end!');
        return controller;
    }

    async initData(formId: string, operationMode: number, callback?: Function): Promise<void> {
        this.logger.debug(`initData start! operationMode: ${operationMode}`);
        await DataStoreUtil.getInstance(globalThis.photosGlobalContext).init().then(async () => {
            let formIdKey: string = 'formId_' + formId;
            let hasFormId = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(formIdKey);
            this.logger.debug(`The value of hasFormId is ${hasFormId}`);
            if (hasFormId) {
                this.createFormController(formId, operationMode, callback);
            }
        }).catch((err) => {
            this.logger.error(`init err ${err}`);
        })
        this.logger.debug('initData end!');
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
        this.logger.debug('getController start!');
        let controller: FormController = this.formControllerMap.get(formId);
        if (controller == null || controller == undefined) {
            this.logger.info(`has no controller with formid ${formId}`);
            return null;
        }
        this.logger.debug('getController end!');
        return controller;
    }

    public deleteFormController(formId: string): void {
        this.logger.debug('deleteFormController start!')
        if (this.formControllerMap.has(formId)) {
            let ret = this.formControllerMap.delete(formId);
            if (ret) {
                this.logger.info('It is successful to delete FormController');
            } else {
                this.logger.error('It is failed to delete FormController');
            }
        } else {
            this.logger.info(`deleteFormController, It has no controller with formid ${formId}`);
        }

        this.logger.debug('deleteFormController end!');
    }
}