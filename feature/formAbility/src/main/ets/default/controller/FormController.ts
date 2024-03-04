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

import { MediaDataManager } from '../data/MediaDataManager';
import { BigDataConstants, Constants as commonConstants, DataStoreUtil, Log, ReportToBigDataUtil } from '@ohos/common';
import formBindingData from '@ohos.application.formBindingData';
import { Constants } from '../common/Constants';
import formProvider from '@ohos.application.formProvider';
import type Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

const TAG: string = 'formA_The_FormController';

export interface FormListener {
  onDeleteForm(formId: string): void;

  onUpdateFormData(formId: string): void;

  onEvent(formId: string): void;

  onCallback(formId: string): void;

  onShowForm(formId: string): void;

  updateFormData(formId: string, vars?: string[]): void;
}

export class FormController implements FormListener {
  private static readonly MSG_ROUTER_PHOTOS = 'routerPhotos';
  mediaDataManager: MediaDataManager;
  private formId: string;
  private callback: Function = null;
  private indexValue: number = 0;

  constructor(formId: string, operationMode: number, callback?: Function) {
    this.formId = formId;
    this.callback = callback;
    this.mediaDataManager = new MediaDataManager(operationMode, this);
    if (operationMode === Constants.PHOTOS_FORM_OPERATION_MODE_DESTROY) {
      this.onDeleteForm(formId);
    } else {
      this.mediaDataManager.initData(formId);
    }
  }

  bindFormData(formId: string): formBindingData.FormBindingData {
    let fd: number = this.mediaDataManager.getCurrentFd();
    Log.info(TAG, `bindFormData start formId: ${formId}  fd:${fd}`);
    let image: string = this.imageHashCode(fd, formId);
    let dataObj: object = {
      fd: fd !== -1,
      image0: 'memory://' + image,
      image1: 'memory://' + image,
      indexValue: this.indexValue,
      albumName: this.mediaDataManager.getCurrentAlbumName(),
      currentIndex: this.mediaDataManager.getCurrentIndex(),
      isShow: this.mediaDataManager.getIsShowAlbumName(),
      formImages: JSON.parse(`{ "${image}": ${fd} }`),
      uri: this.mediaDataManager.getMediaData().currentUri !==
        '' ? commonConstants.ACTION_URI_FORM_ABILITY : commonConstants.ACTION_URI_FORM_ABILITY_NONE,
      albumUri: `${this.mediaDataManager.getMediaData().albumUri}`,
      currentUri: this.mediaDataManager.getMediaData().currentUri
    };
    Log.debug(TAG, `bindFormData, createFormBindingData dataObj2.data: ${JSON.stringify(dataObj)}`);
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(JSON.stringify(dataObj));
    Log.debug(TAG, `bindFormData end, createFormBindingData obj2.data: ${JSON.stringify(obj.data)}`);
    return obj;
  }

  imageHashCode(fd: number, formId: string) {
    let mediaData = this.mediaDataManager.getMediaData();
    return 'image_' + fd + '_formId_' + formId + '_uri_' + mediaData.currentUri + '_orientation_' + mediaData.orientation;
  }

  async updateFormData(formId: string, vars: string[]) {
    Log.debug(TAG, `updateFormData formId: ${JSON.stringify(formId)}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    this.indexValue = await dataStore.getData(Constants.FA_INDEX_VALUE, 0);
    let formObj: formBindingData.FormBindingData = this.bindFormData(formId);
    Log.debug(TAG, `updateFormData obj: ${JSON.stringify(formObj)}`);
    formProvider.updateForm(formId, formObj)
      .then(() => {
        this.onCallback();
        this.onDestroy();
      }).catch((error) => {
        Log.error(TAG, `updateForm failed. Cause: ${JSON.stringify(error)}`);
        let msg = { 'err': JSON.stringify(error) };
        ReportToBigDataUtil.errEventReport(BigDataConstants.SET_FA_CARD_IS_NAME_ERROR, msg);
        this.mediaDataManager.closeFd();
      });
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy start!');
    this.mediaDataManager.closeFd();
    this.callback = null;
    Log.info(TAG, 'onDestroy done end!');
  }

  async onUpdateFormData(formId: string) {
    Log.debug(TAG, `onUpdateFormData formId: ${formId}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    let temp = await dataStore.getData(Constants.FA_INDEX_VALUE, 0);
    this.indexValue = (temp + Constants.NUMBER_1) % Constants.NUMBER_2;
    await dataStore.putData(Constants.FA_INDEX_VALUE, this.indexValue);
    await dataStore.flush();
    this.mediaDataManager.setNextIndex();
  }

  routerPhotoBrowser() {
    Log.debug(TAG, 'routerPhotoBrowser start!');
    let param: Want = {
      'bundleName': 'com.ohos.photos',
      'abilityName': 'com.ohos.photos.MainAbility',
      'parameters': {
        'uri': (this.mediaDataManager.getMediaData().currentUri !== '') ?
          commonConstants.ACTION_URI_FORM_ABILITY : commonConstants.ACTION_URI_FORM_ABILITY_NONE,
        'albumUri': `${this.mediaDataManager.getMediaData().albumUri}`,
        'displayName': `${this.mediaDataManager.getMediaData().displayName}`,
        'currentUri': this.mediaDataManager.getMediaData().currentUri
      }
    };
    Log.debug(TAG, `routerPhotoBrowser parm ${JSON.stringify(param)}`);

    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('formContext');
    context.startAbility(param).then((): void => {
      AppStorage.delete(Constants.FROM_CONTROLLER_MANAGER);
    })

    this.onDestroy();
    Log.debug(TAG, 'routerPhotoBrowser end!');
  }

  onTriggerFormEvent(formId: string, message): void {
    Log.debug(TAG, `onTriggerFormEvent ${formId} ${message}`);
    let msgObj = JSON.parse(message);
    let param = msgObj['params'];
    let msg = param['message'];
    Log.debug(TAG, `onTriggerFormEvent ${param} ${msg}`);
    if (msg == FormController.MSG_ROUTER_PHOTOS) {
      this.routerPhotoBrowser();
    }
  }

  onEvent(formId: string): void {
    Log.debug(TAG, 'onEvent start!');
    if (this.callback != null) {
      if (this.mediaDataManager.getUpdateTag()) {
        this.mediaDataManager.setUpdateTag(false)
        Log.debug(TAG, `updateFormData formId: ${JSON.stringify(formId)}`);
        let formObj: formBindingData.FormBindingData = this.bindFormData(formId);
        Log.debug(TAG, `updateFormData obj: ${JSON.stringify(formObj)}`);
        formProvider.updateForm(formId, formObj).then(() => {
          Log.info(TAG, 'updateFormData begin');
          this.onTriggerFormEvent(formId, this.callback.call(this.callback));
        }).catch((error) => {
          this.onTriggerFormEvent(formId, this.callback.call(this.callback));
        });
      } else {
        this.onTriggerFormEvent(formId, this.callback.call(this.callback));
      }
    }
    Log.debug(TAG, 'onEvent end!');
  }

  onCallback(): void {
    Log.debug(TAG, 'onCallback start!');
    if (this.callback != null) {
      this.callback.call(this.callback);
    }
    Log.debug(TAG, 'onCallback end!');
  }

  onDeleteForm(formId: string): void {
    this.mediaDataManager.storageDelete();
  }

  async onShowForm(formId: string) {
    Log.info(TAG, 'onShowForm start!');
    ReportToBigDataUtil.report(BigDataConstants.SET_FA_CARD_IS_NAME_ID, null);
    let isShowName = AppStorage.Get(Constants.FROM_PLAYBACK_ISSHOWNAME);
    let isShowKey = Constants.FROM_PLAYBACK_ISSHOWNAME;
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    await dataStore.putData(isShowKey, isShowName ? 1 : 0);
    await dataStore.flush();
    this.updateFormData(formId, []);
  }
}