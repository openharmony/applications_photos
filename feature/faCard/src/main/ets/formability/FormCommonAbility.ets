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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy formBindingData from '@ohos.app.form.formBindingData';
import lazy FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import lazy { formInfo, formProvider } from '@kit.FormKit';
import lazy TaskService from '@ohos/dataprovider/src/main/ets/database/service/TaskService';
import lazy { TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { JSON } from '@kit.ArkTS';
import lazy FaCardService from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import lazy { appManager } from '@kit.AbilityKit';
import lazy { LightGlimpseUtil } from '@ohos/common/src/main/ets/default/utils/LightGlimpseUtil';
import lazy { FaCardAlbumUtils } from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import lazy { AlbumType, FaCardTable } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';
import lazy FormAbilityStub from './FormAbilityStub';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { osAccount } from '@kit.BasicServicesKit';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'FormAbilityPhone';

const MAX_PUBLISHED_FORM_COUNT: number = 20;

const REFRESH_TYPE: string = "ohos.extra.param.key.refresh_type";
/**
 *  三方FA卡片组件, 配置于 src/main/module.json5
 */
export default class FormCommonAbility extends FormExtensionAbility {
  private deletedFormHandler = new DeletedFormHandler();

  onAddForm(want: Want): formBindingData.FormBindingData {
    Log.info(TAG, `onAddForm context = ${JSON.stringify(this.context)}`);
    const recordStartTime: number = Date.now();
    const param: Record<string, Object> = want.parameters as Record<string, Object>;
    const formId: string = param['ohos.extra.param.key.form_identity'] as string;
    const formName: string = param['ohos.extra.param.key.form_name'] as string;
    const moduleName: string = param['moduleName'] as string;
    const formDimension: number = param['ohos.extra.param.key.form_dimension'] as number;
    const formLocation: number = param['ohos.extra.param.key.form_location'] as number;

    Log.info(TAG,
      `onAddForm formId: ${formId} moduleName: ${moduleName} formDimension: ${formDimension} formLocation ${formLocation}`);
    if (moduleName != 'phone_photos') {
      Log.info(TAG, `onAddForm form onCreate skip id: ${formId}`);
      const formData: Record<string, Object> = {};
      return formBindingData.createFormBindingData(formData);
    }

    if (formLocation === formInfo.FormLocation.DESKTOP) {
      // 桌面卡片重启 0
      Log.info(TAG, `onAddForm formId = ${formId} isPublished`);
      this.refreshDataShare(formLocation, formId);
    } else if (formLocation === formInfo.FormLocation.NEGATIVE_SCREEN) {
      // 添加到-1屏或-1屏卡片重启 3
      this.refreshDataShare(formLocation, formId);
      this.getPublishedFormCount(async ()=> {
        await this.sendCreateTask(formId, recordStartTime, formDimension);
      });
    } else {
      // 卡片创建界面 2、卡片中心 1
      this.getPublishedFormCount(async ()=> {
        await FormAbilityStub.updateAlbumCardFirstImage(formId, this.context);
      });
    }

    const formData: Record<string, Object> = {};
    formData.formId = formId;
    const formBinding: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    const proxies: formBindingData.ProxyData[] = [
      {
        'key': 'datashareproxy://com.ohos.photos/facard_metadata',
        'subscriberId': formId
      }
    ];
    Log.info(TAG, `onAddForm end formId: ${formId}`);
    formBinding.proxies = proxies;
    return formBinding;
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation) {
    Log.info(TAG,
      `onFormLocationChanged ${formId} newFormLocation = ${StringUtil.getAnonymizeString(String(newFormLocation))}`);
    const recordStartTime: number = Date.now();
    this.sendCreateTask(formId, recordStartTime);
  }

  onConfigurationUpdate(config: Configuration) {
    Log.info(TAG, `onConfigurationUpdate`);
    this.checkLanguageChanged(config);
  }

  async checkLanguageChanged(config: Configuration): Promise<void> {
    const isVerified: boolean = await this.isOsAccountUnlocked();
    // 锁屏状态下不作处理
    if (!isVerified) {
      return;
    }
    try {
      const dataStoreUtil = DataStoreUtil.getInstance();
      await dataStoreUtil.init();
      const preConfig: Configuration = await dataStoreUtil.getData<Configuration>(Constants.FORM_PRE_CONFIGURATION, {});
      await dataStoreUtil.putData<Configuration>(Constants.FORM_PRE_CONFIGURATION, config);
      await dataStoreUtil.flush();
      Log.info(TAG, `pre language ${preConfig.language}, new language ${config.language}`);
      if (preConfig.language === config.language) {
        Log.info(TAG, `language did not change, do nothing`);
        return;
      }
      await this.updateAlbumName();
    } catch (err) {
      Log.error(TAG, `checkLanguageChanged error: ${err}`);
    }
  }

  async updateAlbumName(): Promise<void> {
    const faCardService = new FaCardService(this.context);
    try {
      const formInfos: DataShareResultSet | undefined = await faCardService.queryAllForm();
      if (!formInfos) {
        Log.info(TAG, `no form existed, do not need update`);
        return;
      }
      const formIdIndex: number = formInfos.getColumnIndex(FaCardTable.FORM_ID);
      const albumUriIndex: number = formInfos.getColumnIndex(FaCardTable.ALBUM_URI);
      while (formInfos?.goToNextRow()) {
        const formId = formInfos.getString(formIdIndex);
        const albumUri = formInfos.getString(albumUriIndex);
        Log.info(TAG, `formId: ${formId} will updateAlbumName`);
        faCardService.updateAlbumName(formId, albumUri);
      }
    } catch (err) {
      Log.error(TAG, `updateAlbumName error: ${err}`);
    }
  }

  async isOsAccountUnlocked(): Promise<boolean> {
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    let isVerified: boolean = false;
    try {
      isVerified = await accountManager.isOsAccountUnlocked();
      Log.info(TAG, 'isOsAccountUnlocked successfully, isVerified: ' + isVerified);
    } catch (err) {
      Log.info(TAG, 'isOsAccountUnlocked failed, error: ' + JSON.stringify(err));
    }
    return isVerified;
  }

  async updateForm(formId: string): Promise<void> {
    Log.info(TAG, `Task facard ${formId} update`);
    const isVerified = await this.isOsAccountUnlocked();
    if (!isVerified) {
      return;
    }
    TaskService.getInstance(this.context).insertTask(formId, TaskUri.TASK_UPDATE_FACARD_URI);
  }

  // 0 使用方主动刷新；1 定时刷新；2，定点刷新；3下次刷新；4 网络变化刷新；
  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    Log.info(TAG, `onUpdateForm ${JSON.stringify(wantParams)}`)
    if (wantParams && wantParams[REFRESH_TYPE] === 0) {
      return;
    }
    this.updateForm(formId);
  }

  async removeForm(formId: string): Promise<void> {
    Log.info(TAG, `Task facard ${formId} delete`);
    const isVerified = await this.isOsAccountUnlocked();
    if (!isVerified) {
      await this.deletedFormHandler.push(formId);
      return;
    }
    TaskService.getInstance(this.context).insertTask(formId, TaskUri.TASK_DELETE_FACARD_URI);
    ReportToBigDataUtil.report(BigDataConstants.DELETE_FA_CARD_ID, undefined);
  }

  onRemoveForm(formId: string): void {
    this.removeForm(formId);
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    Log.info(TAG, `onVisibilityChange, newStatus: ${JSON.stringify(newStatus)}`);
  }

  private async sendCreateTask(formId: string, recordStartTime: number, formDimension: number = -1) {
    if (formDimension === -1) {
      try {
        const publishedFormInfo: formInfo.FormInfo = await formProvider.getPublishedFormInfoById(formId);
        Log.info(TAG, `publishForm ${formId} publishedFormInfo = ${JSON.stringify(publishedFormInfo)}`);
        formDimension = publishedFormInfo.dimension ?? -1;
      } catch (err) {
        Log.error(TAG, `publishForm catch ${err.message}`);
      }
    }

    const value: ValuesBucket = {
      recordStartTime,
      formDimension,
      formId,
    }
    TaskService.getInstance(this.context).insertTask(formId, TaskUri.TASK_CREATE_FACARD_URI, value);
  }

  async getPublishedFormCount(callback: () => Promise<void>): Promise<void> {
    // 接口异常导致的undefined不影响创卡逻辑
    let publishedFormCount: number | undefined = undefined;
    try {
      Log.info(TAG, `getPublishedFormCount begin`);
      const formInfos: formInfo.FormInfo[] = await formProvider.getPublishedFormInfos();
      const publishedFormInfos = formInfos.filter(formInfo => this.isPublished(formInfo?.formLocation));
      Log.info(TAG, `getPublishedFormCount end, total: ${formInfos.length}, published: ${publishedFormInfos.length}`);

      publishedFormCount = publishedFormInfos.length;
    } catch (err) {
      Log.error(TAG, `getPublishedFormInfos catch ${err.message}`);
    }
    Log.info(TAG, `getPublishedFormCount count = ${publishedFormCount}`);
    if (publishedFormCount && publishedFormCount >= MAX_PUBLISHED_FORM_COUNT) {
      return;
    }
    await callback();
  }

  private isPublished(formLocation: number | undefined): boolean {
    return formLocation === formInfo.FormLocation.DESKTOP || formLocation === formInfo.FormLocation.NEGATIVE_SCREEN;
  }

  private async refreshDataShare(formLocation: number, formId: string) {
    Log.info(TAG, `refreshDataShare start ${formId} ${formLocation}`);
    // 在桌面或者负一屏刷新
    if (this.isPublished(formLocation)) {
      const faCardService = new FaCardService(this.context);
      const faCardInfo = await faCardService.queryFaCard(formId);
      Log.info(TAG, `refreshDataShare faCardInfo ${formId} ${faCardInfo.albumType}`);
      if (faCardInfo.albumType === AlbumType.SINGLE || faCardInfo.albumType === AlbumType.ALBUM) {
        FaCardAlbumUtils.updateScheduler(faCardInfo.formId, faCardInfo.playbackInterval, true, this.context);
        Log.info(TAG, 'refreshDataShare updateScheduler success');
      } else if (faCardInfo.albumType === AlbumType.HIGHLIGHT_ALBUM) {
        FaCardAlbumUtils.updateHighlightScheduler(faCardInfo.formId, faCardInfo.playbackInterval, true);
        Log.info(TAG, 'refreshDataShare updateHighlightScheduler success');
      } else if (faCardInfo.albumType === AlbumType.PORTRAIT_ALBUM) {
        FaCardAlbumUtils.updatePortraitScheduler(
          faCardInfo.formId, faCardInfo.playbackInterval, true, this.context);
        Log.info(TAG, 'refreshDataShare updatePortraitScheduler success');
      }
    }
  }

  private async checkGlimpseState(formId: string): Promise<void> {
    appManager.getRunningProcessInformation(async (error, data) => {
      let isProcessRunning = false;
      if (error) {
        Log.info(TAG, `getRunningProcessInformation fail, error: ${JSON.stringify(error)}`);
        return;
      }

      Log.info(TAG, `getRunningProcessInformation success, data: ${JSON.stringify(data)}`);
      for (let i = 0; i < data.length; i++) {
        let processInformation = data[i];
        Log.info(TAG, `getRunningProcessInformation processInformation: ${processInformation.processName}`);
        if (processInformation.processName === 'com.ohos.photos:liveForm' &&
          processInformation.state <= appManager.ProcessState.STATE_ACTIVE) {
          isProcessRunning = true;
          break;
        }
      }

      if (!isProcessRunning) {
        return;
      }
    });
  }

  async onFormEvent(formId: string, message: string): Promise<void> {
    try {
      let node: object | null = JSON.parse(message);
      if (!node || !LightGlimpseUtil.getSystemLightGlimpse()) {
        return;
      }
      Log.info(TAG, `onFormEvent formId ${formId} message ${message}`);
      if (node['message'] === 'checkLightGlimpseState') {
        this.checkGlimpseState(formId);
      }
    } catch (err) {
      Log.error(TAG, `onFormEvent parse message failed. message: ${err.message}`);
    }
  }

  onStop() {
    Log.info(TAG, `onStop`);
  }
}

class DeletedFormHandler {
  private deleteFormIds: string[] = [];
  private isProcessing: boolean = false;

  public async push(formId: string) {
    this.deleteFormIds.push(formId);
    if (!this.isProcessing) {
      await this.process();
    }
  }

  public async process(): Promise<void> {
    if (!this.deleteFormIds.length) {
      Log.info(TAG, `deleteFormIds is empty`);
      return;
    }
    this.isProcessing = true;

    const formIds = this.deleteFormIds;
    this.deleteFormIds = [];

    try {
      await DataStoreUtil.getInstance().init();
      let deleted: string[] = await DataStoreUtil.getInstance().getData(Constants.DELETED_FORM_IDS, []);
      deleted = deleted.concat(formIds);
      Log.info(TAG, `process deleted = ${deleted}`);

      await DataStoreUtil.getInstance().putData(Constants.DELETED_FORM_IDS, deleted);
      await DataStoreUtil.getInstance().flush();
    } catch (err) {
      Log.error(TAG,  `process error = ${err?.message}`);
    }

    if (this.deleteFormIds.length) {
      await this.process();
    }
    this.isProcessing = false;
  }
}