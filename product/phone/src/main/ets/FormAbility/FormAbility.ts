/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import type Want from '@ohos.app.ability.Want';
import {
  BigDataConstants,
  DataStoreUtil,
  Log,
  UserFileManagerAccess,
  ReportToBigDataUtil
} from '@ohos/common';
import { Constants, FormController, FormControllerManager } from '@ohos/formAbility';
import type formBindingData from '@ohos.app.form.formBindingData';

const TAG: string = 'photo_FormAbility';

type FormVisibilityArray = { [key: string]: number };

export default class FormAbility extends FormExtension {
  onAddForm(want: Want): formBindingData.FormBindingData {
    Log.debug(TAG, `form onCreate. want ${JSON.stringify(want)}`);
    this.init();

    let param: { [key: string]: Object } = want.parameters;
    let formId: string = param['ohos.extra.param.key.form_identity'] as string;
    Log.info(TAG, `form onCreate formId: ${formId}`);
    let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
    formControllerManager.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE).then(() => {
      let formController: FormController = formControllerManager.getController(formId);
      if (!formController) {
        Log.debug(TAG, `formControllerManager do not has id ${formId}`);
        formController = formControllerManager.createFormController(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE);
      } else {
        Log.debug(TAG, `formControllerManager has id ${formId}`);
      }
      if (!formController) {
        Log.error(TAG, `Get null controller. formId: ${formId}`);
        return null;
      }
      ReportToBigDataUtil.report(BigDataConstants.CREATE_FA_CARD_ID, null);
      return formController.bindFormData(formId);
    }).catch((err) => {
      Log.error(TAG, `FA onAddForm id ${formId} init err ${err}`);
      let msg = {
        'err': JSON.stringify(err)
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.CREATE_FA_CARD_ERROR, msg);
    })
    return null;
  }

  onCastToNormalForm(formId: string): void {
    Log.info(TAG, `onCastToNormal, formId: ${formId}`);
  }

  onUpdateForm(formId: string): void {
  }

  onChangeFormVisibility(newStatus: FormVisibilityArray): void {
    Log.info(TAG, `onVisibilityChange, newStatus: ${JSON.stringify(newStatus)}`);

    // 经常起来后可能直接走onVisibilityChange， 所以要初始化一下
    this.init();
    this.clearCache(newStatus);
  }

  onFormEvent(formId: string, message: string): void {
    Log.debug(TAG, `onEvent, formId: ${formId}, message: ${message}`);

    // 经常起来后可能直接走onEvent， 所以要初始化一下
    this.init();
    let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
    formControllerManager.onEvent(formId, message);
  }

  onRemoveForm(formId: string): void {
    Log.info(TAG, `onDestroy, formId: ${formId}`);
    ReportToBigDataUtil.report(BigDataConstants.DELETE_FA_CARD_ID, null);

    // 经常起来后可能直接走onDestroy， 所以要初始化一下
    this.init();
    let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
    formControllerManager.destroyController(formId);
  }

  private init(): void {
    UserFileManagerAccess.getInstance().onCreate(this.context);

    // Init system album information
    UserFileManagerAccess.getInstance().prepareSystemAlbums();
    AppStorage.setOrCreate('formContext', this.context);
  }

  private async clearCache(newStatus: FormVisibilityArray): Promise<void> {
    try {
      let dataStore = DataStoreUtil.getInstance();
      await dataStore.removeCache();
      await dataStore.init();
      let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
      for (let key in newStatus) {
        Log.info(TAG, `onVisibilityChange, key:${key}  value ${newStatus[key]}`);
        let formId = key;
        formControllerManager.initData(formId, Constants.PHOTOS_FORM_OPERATION_MODE_NONE);
      }
    } catch (err) {
      Log.error(TAG, `clearCache err:` + JSON.stringify(err));
    }
  }
};