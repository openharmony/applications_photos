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

import type Want from '@ohos.app.ability.Want';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Constants } from './common/Constants';
import lazy { FormControllerManager } from './controller/FormControllerManager';
import lazy {
  BigDataConstants,
  IFACardBigDataParams,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy dataShare from '@ohos.data.dataShare';
import lazy { AlbumType as FATableAlbumType } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';

import type { FormController } from './controller/FormController';
import lazy formBindingData from '@ohos.app.form.formBindingData';
import lazy FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import lazy FaCardService, { FaCardInfo } from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import lazy ReminderService from '@ohos/dataprovider/src/main/ets/database/service/ReminderService';
import lazy { FaCardAlbumUtils } from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { formProvider } from '@kit.FormKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { contextConstant } from '@kit.AbilityKit';
import lazy { JSON } from '@kit.ArkTS';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy systemparameter from '@ohos.systemParameterEnhance';
import lazy TaskService from '@ohos/dataprovider/src/main/ets/database/service/TaskService';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo'

/* instrument ignore file */
const TAG: string = 'FormAbilityCommon';
const KEY_SYSTEM_PARAM_TEST_MEMORY: string = 'sys.photo.fa.test.memory.enable';
const VAL_SCHEDULER_DEFAULT: string = '15';
const VAL_SCHEDULER_MEMORY_TEST: string = '1200';

type FormVisibilityArray = Record<string, Object>;

const dsOptions: dataShare.DataShareHelperOptions = {
  isProxy: true,
};

export default class FormAbilityCommon extends FormExtensionAbility {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  onAddForm(want: Want): formBindingData.FormBindingData {
    // 重启 推包1 添加1  所有生命周期
    Log.info(TAG, `onAddForm context = ${JSON.stringify(this.context)}`);
    const recordStartTime: number = Date.now();
    let param: Record<string, Object> = want.parameters as Record<string, Object>;
    let formId: string = param['ohos.extra.param.key.form_identity'] as string;
    let formName: string = param['ohos.extra.param.key.form_name'] as string;
    const isHighlight: boolean = formName.includes('highlight');
    Log.info(TAG, `onAddForm highlightCard isHighlight: ${isHighlight}`);

    let moduleName: string = param['moduleName'] as string;
    Log.info(TAG, `onAddForm formId: ${formId} moduleName: ${moduleName}`);
    if (moduleName != 'phone_photos' && moduleName != 'tv_photos') {
      Log.info(TAG, `onAddForm form onCreate skip id: ${formId}`);
      let formData: Record<string, Object> = {};
      return formBindingData.createFormBindingData(formData);
    }

    formProvider.setFormNextRefreshTime(formId, 30, (error: BusinessError) => {
      if (error) {
        Log.error(TAG,
          `formability onaddform callback error, code: ${error.code}, message: ${error.message}) formId: ${formId}`);
        return;
      }
      Log.info(TAG, `formability onaddform formProvider setFormNextRefreshTime success formId: ${formId}`);
    });

    this.init().then(async (): Promise<void> => {
      const isExistFaCard: boolean = await this.checkIsExistFaCard(formId);
      Log.info(TAG, 'query facard end ' + isExistFaCard);
      if (isExistFaCard) {
        return;
      }

      let formControllerManager: FormControllerManager = FormControllerManager.getInstance();
      this.appBroadCast.on('DATA_READY' + formId, () => {
        Log.info(TAG, 'broadcast receive ' + formId);
        this.createDataShare(formId, this.isNeedPlaybackInterval(formName));
        const formDimension = param['ohos.extra.param.key.form_dimension'] as string;
        const msg: IFACardBigDataParams = {
          formId: formId,
          formType: `${formDimension}`,
          costTime: Date.now() - recordStartTime,
          cardType: isHighlight ? FATableAlbumType.HIGHLIGHT_ALBUM : FATableAlbumType.ALBUM,
        };
        ReportToBigDataUtil.report(BigDataConstants.CARD_CREATE_CARD, msg);
      })
      await this.insertFacard(formId, isHighlight, formControllerManager,
        this.isNeedPlaybackInterval(formName) ? undefined : 0);
      Log.info(TAG, 'onAddForm insertFacard end');
    });

    let formData: Record<string, Object> = {};
    formData['formId'] = formId;
    let formBinding: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    let proxies: formBindingData.ProxyData[] = [
      {
        'key': 'datashareproxy://com.ohos.photos/facard_metadata',
        'subscriberId': formId
      }
    ];
    Log.info(TAG, `onAddForm end formId: ${formId}`);
    formBinding.proxies = proxies;
    return formBinding;
  }

  private isNeedPlaybackInterval(formName: string) {
    if (formName === FormConstants.POLAROID_WIDGET || formName === FormConstants.ROLL_FILM_WIDGET) {
      // 拍立得和胶卷卡片无需定时刷新 当前该卡片仅支持TV
      return false;
    }
    return true;
  }

  private createDataShare(formId: string, isNeedPlaybackInterval: boolean) {
    let refreshCardSql = '';
    if (isNeedPlaybackInterval) {
      let isMemoryTest: boolean = this.getSystemParamOfMemoryTest();
      const timeOffset: string = isMemoryTest ? VAL_SCHEDULER_MEMORY_TEST : VAL_SCHEDULER_DEFAULT;
      refreshCardSql = FormConstants.REFRESH_CARD_SQL.replace(FormConstants.SQL_REPLACE_TIME_OFFSET, timeOffset);
    }
    const template: dataShare.Template = {
      predicates: {
        'agendaObjList': FormConstants.QUERY_VALID_AGENDA_SQL.replace('?', formId)
      },
      scheduler: refreshCardSql?.replace('?', formId),
      update: FormConstants.UPDATE_CARD_SQL.replaceAll('?', formId),
    };
    Log.info(TAG, 'onAddForm createDataShareHelper start. ' + formId);
    const templateUri: string = 'datashareproxy://com.ohos.photos/facard_metadata';
    let oldArea = this.context.area;
    this.context.area = contextConstant.AreaMode.EL1;
    Log.info(TAG, `createDataShare databaseDir = ${this.context.databaseDir} area = ${this.context.area}`);
    dataShare.createDataShareHelper(this.context, 'datashareproxy://com.ohos.photos', dsOptions)
      .then((dataShareHelper) => {
        Log.info(TAG, 'DataShare createDataShareHelper, subscriberId ' + formId);
        dataShareHelper.delTemplate(templateUri, formId); // 先清理，在创建，避免多个template
        dataShareHelper.addTemplate(templateUri, formId, template);
      })
      .catch(() => {
        Log.error(TAG, 'DataShare createDataShareHelper, failed ' + formId);
        const msg: IFACardBigDataParams = {
          formId: formId,
          cardType: FATableAlbumType.ALBUM,
        };
        ReportToBigDataUtil.report(BigDataConstants.CREATE_DATA_SHARE_FAIL, msg);
      })
      .finally(() => {
        this.context.area = oldArea;
      })
    Log.info(TAG, 'onAddForm createDataShareHelper end. ' + formId);
  }

  private async checkIsExistFaCard(formId: string): Promise<boolean> {
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      const faCardService: FaCardService = new FaCardService(this.context as Context);
      queryResult = await faCardService.queryByFormId(formId);
      return Boolean(queryResult && queryResult.rowCount > 0);
    } catch (error) {
      Log.error(TAG, `checkIsExistFaCard error: ${error?.code}, ${error?.msg}`);
      return false;
    } finally {
      queryResult?.close();
    }
  }

  private getSystemParamOfMemoryTest(): boolean {
    let isMemoryTest: boolean = false;
    try {
      // 获取配置项
      let param: string = systemparameter.getSync(KEY_SYSTEM_PARAM_TEST_MEMORY, 'false');
      isMemoryTest = StringUtil.size(param) !== 0 && param === 'true';
      Log.info(TAG, `getSystemParamOfMemoryTest param:${param}, enable: ${isMemoryTest}`);
    } catch (err) {
      Log.info(TAG, `getSystemParamOfMemoryTest unexpected error: ${err?.code},${err?.msg}`);
    }
    return isMemoryTest;
  }

  private async insertFacard(
    formId: string,
    isHighlight: boolean,
    formControllerManager: FormControllerManager,
    playbackInterval?: number
  ): Promise<void> {
    try {
      // 精彩时刻场景 增加时刻album_uri
      if (isHighlight) {
        await this.insertHighlightAlbum(formId, formControllerManager);
      } else {
        await this.insertNormalAlbum(formId, formControllerManager, playbackInterval);
      }
    } catch (err) {
      Log.info(TAG, `insertFacard err: ${err}`)
    }
  }

  private async insertHighlightAlbum(formId: string, formControllerManager: FormControllerManager): Promise<void> {
    Log.info(TAG, `insertHighlightAlbum formId: ${formId}`)
    const highlightAlbums: photoAccessHelper.Album[] = await this.queryHighlightAlbum();
    if (!highlightAlbums || highlightAlbums.length === 0) {
      Log.info(TAG, `insertHighlightAlbum HighlightAlbum null`)
      return;
    }
    // 将第一个相册的uri插入facard表
    const faCardService: FaCardService = new FaCardService(this.context as Context);
    Log.info(TAG, `context insertHighlightAlbum ${JSON.stringify(this.context as Context)}`);
    Log.info(TAG, `insertHighlightAlbum albumUri: ${highlightAlbums[0].albumUri}`)
    await faCardService.insert(formId, 2, 15, highlightAlbums[0]?.albumUri,
      highlightAlbums[0]?.coverUri + '?album_uri:' + highlightAlbums[0]?.albumUri);

    // 将时刻相册封面插入 reminders和image_proxy_data
    let formController: FormController | undefined = formControllerManager.createFormController(formId);
    ReportToBigDataUtil.report(BigDataConstants.CREATE_FA_CARD_ID, undefined);

    if (!formController) {
      Log.error(TAG, 'insertHighlightAlbum createFormController failed');
      return;
    }
    await formController.init();
  }

  private async insertNormalAlbum(formId: string, formControllerManager: FormControllerManager,
    playbackInterval?: number) {
    Log.info(TAG, `insertNormalAlbum formId: ${formId}`)
    // 插入数据库
    let formController: FormController | undefined = formControllerManager.createFormController(formId);
    ReportToBigDataUtil.report(BigDataConstants.CREATE_FA_CARD_ID, undefined);

    if (!formController) {
      Log.error(TAG, 'insertNormalAlbum createFormController failed');
      return;
    }
    await formController.init(playbackInterval);
  }

  private async queryHighlightAlbum(): Promise<Array<photoAccessHelper.Album>> {
    const TASK_ID: number = Date.now();
    let predicates = new dataSharePredicates.DataSharePredicates();
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    predicates.notEqualTo('album_name', 'fake');
    predicates.equalTo('highlight_status', '1');
    predicates.orderByDesc('generate_time');
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    // 查询所有时刻相册
    let fetchResult = await phAccessHelper.getAlbums(
      4096, 4104, fetchOptions);
    let albums = await fetchResult.getAllObjects();
    phAccessHelper?.release();

    // 过滤uri为空的相册
    let resultAlbums: photoAccessHelper.Album[] = [];
    for (let i = 0; i < albums.length; ++i) {
      if (albums[i].coverUri) {
        resultAlbums.push(albums[i]);
      }
    }
    return resultAlbums;
  }

  onCastToNormalForm(formId: string): void {
    Log.info(TAG, `onCastToNormal, formId: ${formId}`);
  }

  onUpdateForm(formId: string): void {
    Log.info(TAG, `onUpdateForm, formId: ${formId}`);
    Log.info(TAG, `Task facard ${formId} update`);
    TaskService.getInstance(this.context).insertTask(formId, TaskUri.TASK_UPDATE_FACARD_URI);
  }

  onChangeFormVisibility(newStatus: FormVisibilityArray): void {
    Log.info(TAG, `onVisibilityChange, newStatus: ${JSON.stringify(newStatus)}`);
  }

  onFormEvent(formId: string, message: string): void {
    Log.info(TAG, `onEvent, formId: ${formId}, message: ${message}`);
    this.processTvCardEvent(formId, message);
  }

  async processTvCardEvent(formId: string, message: string): Promise<void> {
    if (!DeviceInfo.isTv()) {
      return;
    }
    if (message && message.replace(/^"|"$/g, '') === FormConstants.UPDATE_SCHEDULER) {
      Log.info(TAG, `updateScheduler formId: ${formId}`);
      const formContext: Context | undefined = AppStorage.get<Context>('formContext') as Context;
      if (!formContext) {
        Log.info(TAG, `updateScheduler set formContext`);
        AppStorage.setOrCreate('formContext', this.context);
      }
      FaCardAlbumUtils.updateScheduler(formId, 0, true);
    }
  }

  onRemoveForm(formId: string): void {
    const formControllerManager: FormControllerManager = FormControllerManager.getInstance();
    formControllerManager.destroyController(formId);

    Log.info(TAG, `Task facard ${formId} delete`);
    TaskService.getInstance(this.context).insertTask(formId, TaskUri.TASK_DELETE_FACARD_URI);

    formControllerManager.deleteFormController(formId);
    ReportToBigDataUtil.report(BigDataConstants.DELETE_FA_CARD_ID, undefined);
  }

  private async init(): Promise<void> {
    UserFileManagerAccess.getInstance().onCreate(this.context);
    await UserFileManagerAccess.getInstance().prepareSystemAlbums();
    AppStorage.setOrCreate('formContext', this.context);
  }

  onStop() {
    Log.info(TAG, `onStop`);
  }
}

export const HOURS_PER_DAY = 24;

// 一小时分钟数
export const MINUTES_PER_HOUR = 60;

// 一天分钟数
export const MINUTES_PER_DAY = MINUTES_PER_HOUR * HOURS_PER_DAY;

// 一分钟秒数
export const SECONDS_PER_MINUTE = 60;

// 一秒毫秒数
export const MILLS_PER_SECOND = 1000;

// 一分钟毫秒数
export const MILLS_PER_MINUTE = MILLS_PER_SECOND * SECONDS_PER_MINUTE;

// 一小时毫秒数
export const MILLS_PER_HOUR = MILLS_PER_MINUTE * MINUTES_PER_HOUR;

// 一天毫秒数
export const MILLS_PER_DAY = MILLS_PER_HOUR * HOURS_PER_DAY;