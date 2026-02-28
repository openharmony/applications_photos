/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Constants } from '../common/Constants';
import lazy { FormController } from './FormController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

/* instrument ignore file */
const TAG: string = 'formA_FormControllerManager';

/**
 * 表单控制管理器
 */
export class FormControllerManager {
  private formControllerMap: Map<string, FormController> = new Map();
  private formRemovedSet: Set<string> = new Set();

  private constructor() {
    Log.info(TAG, 'new FormControllerManager');
  }

  public static getInstance(): FormControllerManager {
    if (!FormControllerManager.instance) {
      FormControllerManager.instance = new FormControllerManager();
    }
    return FormControllerManager.instance;
  }

  public static instance: FormControllerManager | undefined = undefined;

  /**
   * 创建表单控制器
   */
  public createFormController(formId: string): FormController | undefined {
    if (this.formControllerMap.has(formId)) {
      Log.info(TAG, `FormController is exist, formId = ${formId}`);
      return this.formControllerMap.get(formId);
    }

    Log.info(TAG, 'createFormController start!');
    if (formId === '0') {
      Log.info(TAG, 'formId is 0 or formName is null!');
      return undefined;
    }
    if (this.formRemovedSet.has(formId)) {
      this.formRemovedSet.delete(formId);
      Log.info(TAG, `${formId} already destory! formRemovedSet: ${JSON.stringify(Array.from(this.formRemovedSet))}`);
      return undefined;
    }
    let controller: FormController = new FormController(formId);

    if (!controller) {
      Log.error(TAG, 'It is failed to create FormController!');
      return undefined;
    }
    this.formControllerMap.set(formId, controller);
    Log.info(TAG, 'createFormController end!');
    return controller;
  }

  /**
   * 销毁控制器
   */
  public destroyController(formId: string): void {
    const formController: FormController | undefined = this.getController(formId);
    if (!formController) {
      this.formRemovedSet.add(formId);
      Log.info(TAG, `${formId} add to formRemovedSet: ${this.formRemovedSet.size}`);
    }
    formController?.onDeleteForm(formId);
  }

  /**
   * 更新控制器
   */
  public updateController(formId: string, callback?: Function): void {
    let formController: FormController | undefined = this.getController(formId);
    formController?.updateFormData(formId);
  }

  public onEvent(formId: string, message: string): void {
    let formController: FormController | undefined = this.getController(formId);
    formController?.onEvent(formId);
  }

  public onCallback(formId: string): void {
    let formController: FormController | undefined = this.getController(formId);
    formController?.onCallback(formId);
  }

  /**
   * 获取控制器
   */
  public getController(formId: string): FormController | undefined {
    Log.info(TAG, 'getController start!');
    let controller: FormController = this.formControllerMap.get(formId) as FormController;
    if (!controller) {
      Log.info(TAG, `has no controller with formid ${formId}`);
      return undefined;
    }
    Log.info(TAG, 'getController end!');
    return controller;
  }

  /**
   * 删除控制器
   */
  public deleteFormController(formId: string): void {
    Log.info(TAG, 'deleteFormController start!');
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
  }
}