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

import { Constants } from '../common/Constants';
import { FormController } from './FormController';
import { BigDataConstants, DataStoreUtil, Log, ReportToBigDataUtil } from '@ohos/common';

const TAG: string = 'formA_FormControllerManager';

export class FormControllerManager {
  private formControllerMap = new Map();
  private dataStore = DataStoreUtil.getInstance();

  private constructor() {
    Log.info(TAG, 'new FormControllerManager');
  }

  public static getInstance(): FormControllerManager {
    if (AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER) == null) {
      AppStorage.setOrCreate(Constants.FROM_CONTROLLER_MANAGER, new FormControllerManager());
    }
    return AppStorage.Get(Constants.FROM_CONTROLLER_MANAGER);
  }

  public createFormController(formId: string, operationMode: number, callback?: Function): FormController {
    Log.debug(TAG, 'createFormController start!');
    if (formId == '0') {
      Log.info(TAG, 'formId is 0 or formName is null!');
      return null;
    }
    let controller = new FormController(formId, operationMode, callback);

    if (controller == null || controller == undefined) {
      Log.error(TAG, 'It is failed to create FormController!');
      return null;
    }
    this.formControllerMap.set(formId, controller);
    Log.debug(TAG, 'createFormController end!');
    return controller;
  }

  async initData(formId: string, operationMode: number, callback?: Function): Promise<void> {
    Log.debug(TAG, `initData start! operationMode: ${operationMode} formId: ${formId}`);
    try {
      await this.dataStore.init();
      let formIdKey: string = 'formId_' + formId;
      let hasFormId = await this.dataStore.hasData(formIdKey);
      Log.debug(TAG, `FormControllerManager initData of hasFormId ${formId} is ${hasFormId}`);
      if (hasFormId) {
        this.createFormController(formId, operationMode, callback);
      }
    } catch (err) {
      Log.error(TAG, `init err ${err}`);
      let msg = {
        'CatchError': JSON.stringify(err)
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.FA_CARD_ERROR, msg);
    }
    Log.debug(TAG, 'initData end!');
  }

  public destroyController(formId: string): void {
    this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY);
  }

  public updateController(formId: string, callback?: Function): void {
    this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_UPDATE, callback);
  }

  public onEvent(formId: string, message: string): void {
    this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_EVENT, function (): string {
      return message;
    })
  }

  public onCallback(formId: string, callback: Function): void {
    this.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_CALLBACK, callback);
  }

  public getController(formId: string): FormController {
    Log.debug(TAG, 'getController start!');
    let controller: FormController = this.formControllerMap.get(formId);
    if (controller == null || controller == undefined) {
      Log.info(TAG, `has no controller with formid ${formId}`);
      return null;
    }
    Log.debug(TAG, 'getController end!');
    return controller;
  }

  public deleteFormController(formId: string): void {
    Log.debug(TAG, 'deleteFormController start!')
    if (this.formControllerMap.has(formId)) {
      let ret = this.formControllerMap.delete(formId);
      if (ret) {
        Log.info(TAG, 'It is successful to delete FormController');
      } else {
        Log.error(TAG, 'It is failed to delete FormController');
      }
    } else {
      Log.info(TAG, `deleteFormController, It has no controller with formid ${formId}`);
    }

    Log.debug(TAG, 'deleteFormController end!');
  }
}