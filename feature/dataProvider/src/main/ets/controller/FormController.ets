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
import lazy {
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Task, TaskUri } from '../database/databaseconstant/TaskInfo';
import lazy {
  FaCardAlbumUtils,
  getUriExistInProxyInfo,
  insertTask,
  uriExistInProxyInfoI
} from '../database/service/FaCardAlbumService';
import lazy FaCardService, { FaCardInfo } from '../database/service/FaCardService';
import lazy ImageProxyDataService from '../database/service/ImageProxyDataService';
import lazy ReminderService, { ReminderInfo } from '../database/service/ReminderService';
import lazy { FormControllerManager } from './FormControllerManager';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { RemindersTable } from '../database/databaseconstant/RemindersTable';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy data_rdb from '@ohos.data.relationalStore';
import lazy DatabaseProxy from '../database/DatabaseProxy';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy systemparameter from '@ohos.systemParameterEnhance';
import lazy { ImageProxyDataTable } from '../database/databaseconstant/ImageProxyDataTable';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy dataShare from '@ohos.data.dataShare';
import lazy { contextConstant, sendableContextManager } from '@kit.AbilityKit';
import lazy {
  BigDataConstants,
  IFACardBigDataParams,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { AlbumType, IsShowAlbumName } from '../database/databaseconstant/FaCardTable';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import lazy DatabaseUtils from '../database/DatabaseUtils';
import lazy { InsertSendableTaskImpl } from './InsertSendableTaskImpl';
import lazy { LightGlimpseUtil } from '@ohos/common/src/main/ets/default/utils/LightGlimpseUtil';
import lazy { BaseFormController } from './BaseFormController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

const TAG: string = 'FormController';

const INVALID_COUNT: number = -1;
const KEY_SYSTEM_PARAM_TEST_MEMORY: string = 'sys.photo.fa.test.memory.enable';
const VAL_SCHEDULER_DEFAULT: string = '15';
const VAL_SCHEDULER_MEMORY_TEST: string = '1200';
const VAL_SCHEDULER_DEFAULT_NUM: number = 15;
const VAL_CARD_DATA_SIZE: number = 120;
const VAL_CARD_DATA_NOT_INSERT: string = 'NOT_INSERT';
const VAL_REFRESH_TIME: number = 10000;

export class FormController extends BaseFormController {
  private faCardService: FaCardService;
  private imageProxyDataService: ImageProxyDataService;
  private reminderService: ReminderService;
  private faCardAlbumUtils: FaCardAlbumUtils;
  // LightGlimpse开关信息条目
  private lastRefreshTime: number = 0;

  constructor(formId: string, formControllerManager: FormControllerManager) {
    super(formId, formControllerManager);

    // LightGlimpse开关信息条目
    this.faCardService = formControllerManager.faCardService;
    this.imageProxyDataService = formControllerManager.imageProxyDataService;
    this.reminderService = formControllerManager.reminderService;
    this.faCardAlbumUtils = formControllerManager.faCardAlbumUtils;
  }

  public async executeTask(isAgreed: boolean) {
    Log.info(TAG, `executeTask formId: ${this.formId}`);

    if (this.runningTask !== undefined) {
      Log.info(TAG, `formId: ${this.formId} already has a task running: ${this.runningTask}`);
      return;
    }

    const task = this.taskQueue?.shift();
    if (task == undefined) {
      return;
    }
    const taskUri = task.taskUri;
    this.runningTask = taskUri;

    switch (taskUri) {
      case TaskUri.TASK_CREATE_FACARD_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardCreateTask`);
        await this.doFaCardCreateTask(task, isAgreed);
        break;
      case TaskUri.TASK_ADD_FACARD_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardAddTask`);
        await this.doFaCardAddTask(task);
        break;
      case TaskUri.TASK_SWITCH_CLOUD:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardSwitchCloud`);
        await this.doFaCardSwitchCloud(task);
        break;
      case TaskUri.TASK_RESTORE_FACARD_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardRestoreTask`);
        await this.doFaCardRestore(task);
        break;
      case TaskUri.TASK_UPDATE_FACARD_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardUpdateTask`);
        await this.doFaCardUpdateTask(task);
        break;
      case TaskUri.TASK_DELETE_FACARD_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doFaCardDeleteTask`);
        await this.doFaCardDeleteTask(task, isAgreed);
        break;
      case TaskUri.TASK_SELECT_ALBUM_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doSelectAlbumTask`);
        await this.doSelectAlbumTask(task);
        break;
      case TaskUri.TASK_SELECT_PHOTO_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doSelectPhotoTask`);
        await this.doSelectPhotoTask(task);
        break;
      case TaskUri.TASK_MEDIA_UPDATE_ALBUM_URI:
        Log.info(TAG, `Task formId: ${this.formId}, doMediaUpdateAlbumTask`);
        await this.doMediaUpdateAlbumTask(task);
        break;
      case TaskUri.TASK_REFRESH_FACARD:
        Log.info(TAG, `Task formId: ${this.formId}, doRefreshFaCardTask`);
        await this.doRefreshFaCardTask(task);
        break;
      default:
        Log.info(TAG, `Invalid Task: ${taskUri}`);
        break;
    }

    this.runningTask = undefined;
    FormControllerManager.deleteTaskPreemptedStatus(this.formId);
    this.poolTask = undefined;
    // 检查是否有后续任务，继续执行
    let taskNumber: number = this.taskQueue.length;
    Log.info(TAG, `formId: ${this.formId}, done task: ${taskUri}, taskNumber: ${taskNumber}`);
    if (taskNumber > 0) {
      Log.info(TAG, `formId: ${this.formId} execute the subsequent tasks`);
      await this.executeTask(isAgreed);
    }
  }

  // 云同步开关切换时更新reminders表
  // 注意: 云图在切换云同步开关之后，地址会发生变化，再次开启云同步无法恢复
  private async doFaCardSwitchCloud(task: Task): Promise<void> {
    if (task.albumUri == undefined || task.faTableAlbumType == undefined || task.playbackInterval == undefined) {
      Log.error(TAG, `doFaCardSwitchCloud: not enough parameters are available to execute the task`);
      return;
    }

    const albumUri = task.albumUri;
    const faTableAlbumType = task.faTableAlbumType;
    const playbackInterval = task.playbackInterval;
    Log.info(TAG,
      `doFaCardSwitchCloud formId: ${this.formId} albumUri: ${albumUri}, albumType: ${faTableAlbumType}, playbackInterval: ${playbackInterval}`);

    if (faTableAlbumType === AlbumType.SINGLE) {
      await this.updateRemindersSingleImage(this.formId);
    } else {
      await this.updateRemindersImage(albumUri, this.formId, playbackInterval);
    }
  }

  private async updateRemindersImage(albumUri: string, formId: string, playbackInterval: number): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      return;
    }
    try {
      let result: Array<PhotoAsset> | undefined;
      let fetchOptions = AlbumDefine.getFileFetchOptWithDate(VAL_CARD_DATA_SIZE,
        AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, 0);
      if (albumUri) {
        let photoAlbum: PhotoAlbum | undefined = await this.userFileManagerAccess.getAlbumByUri(albumUri);
        if (!photoAlbum) {
          await this.reminderService.deletePhotosByFormId(formId, undefined);
          Log.info(TAG, 'updateRemindersImage without album');
          return;
        }
        Log.info(TAG, `updateRemindersImage getAlbum result ${photoAlbum}`);
        let fetchResult = await photoAlbum?.getAssets(fetchOptions);
        result = await fetchResult?.getAllObjects();
        fetchResult?.close();
      } else {
        result = await this.userFileManagerAccess.getAllObject(fetchOptions, TAG);
      }
      Log.info(TAG, `updateRemindersImage getAssets result ${result}`);
      // instrument ignore if
      if (FormControllerManager.getTaskPreemptedStatus(formId)) {
        return;
      }
      // instrument ignore if
      if (result) {
        const deleteNO = await this.reminderService.deletePhotosByFormId(formId, albumUri);
        // instrument ignore next
        if (deleteNO === undefined) {
          Log.error(TAG, `updateRemindersImage, deleteNO: ${deleteNO}`);
          return;
        }
        let proxyResultSet: DataShareResultSet | undefined = undefined;
        try {
          const imageProxyDataService = new ImageProxyDataService(this.context);
          proxyResultSet = await imageProxyDataService.queryImageUri();
          // instrument ignore next
          const firstAsset = result.shift();
          if (firstAsset) {
            const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
            await FormController.insertRemindersAndProxy(formId, albumUri, [firstAsset], info.uriExistFlag,
              this.context);
          }

          FaCardAlbumUtils.updateScheduler(formId, playbackInterval, true);

          if (result.length) {
            const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
            await FormController.insertRemindersAndProxy(formId, albumUri, result, info.uriExistFlag, this.context);
          }
        } catch (error) {
          Log.error(TAG, `insertNewTurnInBlankFACard error code: ${error.code}, message: ${error.message})`);
        } finally {
          proxyResultSet?.close();
        }
      }
    } catch (error) {
      Log.error(TAG, `updateRemindersImage error ${error}`);
    }
  }

  private async updateRemindersSingleImage(formId: string): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      return;
    }
    let reminderResultSet: DataShareResultSet | undefined = undefined;
    try {
      reminderResultSet = await this.reminderService.queryByFormId(formId);
      if (reminderResultSet && reminderResultSet.rowCount > 0) {
        reminderResultSet.goToFirstRow();
        const imageUriIndex: number = reminderResultSet.getColumnIndex('image_uri');
        const imageUri: string = reminderResultSet.getString(imageUriIndex);
        let photoAsset: PhotoAsset | undefined = undefined;
        Log.info(TAG, `updateRemindersSingleImage imageUri: ${imageUri}`);
        photoAsset = await this.userFileManagerAccess.getPhotoAssetByUri(imageUri);
        Log.info(TAG, `updateRemindersSingleImage asset is: ${photoAsset}`);
        if (photoAsset) {
          await this.reminderService.showRecordByImageUris([imageUri], formId);
        } else {
          await this.reminderService.hiddenRecordByImageUris([imageUri], formId);
        }
      }
    } catch (error) {
      Log.error(TAG, `updateRemindersSingleImage error ${error}`);
    } finally {
      reminderResultSet?.close();
    }
  }

  private async doFaCardDeleteTask(task: Task, isAgreed: boolean) {
    Log.info(TAG, `deleteByFormId start, formId: ${task.formId}, task: ${JSON.stringify(task)}`);

    const formId = task.formId;
    try {
      const deletePredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      deletePredicates.equalTo(RemindersTable.FORM_ID, formId);

      // delete facard
      Log.info(TAG, `faCard deleteByFormId start, formId: ${formId}`);
      const faCardDeleteCount =
        await DatabaseProxy.getInstance().deleteWithOutCallback(FormConstants.FACARD_TABLE_URI, deletePredicates);
      Log.info(TAG, `faCard deleteByFormId end, deleteCount: ${faCardDeleteCount}`);
      if (!isAgreed) {
        // 没有同意隐私协议
        return;
      }
      // delete reminder
      Log.info(TAG, `reminder deleteByFormId start, formId: ${formId}`);
      const reminderDeleteCount =
        await DatabaseProxy.getInstance().deleteWithOutCallback(FormConstants.REMINDER_TABLE_URI, deletePredicates);
      Log.info(TAG, `reminder deleteByFormId end, deleteCount: ${reminderDeleteCount}`);

      // query facard remain count
      let remainCount: number = INVALID_COUNT;

      const queryPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['COUNT(1)'];
      const faCardResultSet: data_rdb.ResultSet | undefined = await DatabaseProxy.getInstance()
        .queryWithOutCallback(FormConstants.FACARD_TABLE_URI, queryPredicates, columns);
      // instrument ignore if
      if (faCardResultSet && faCardResultSet.rowCount > 0) {
        faCardResultSet.goToLastRow();
        remainCount = Number(faCardResultSet.getString(0));
      }
      faCardResultSet?.close();

      const photoAccessHelper = this.userFileManagerAccess.getMediaLibrary();
      Log.info(TAG, `doFaCardDeleteTask removeGalleryFormInfo formId = ${formId}`);
      photoAccessHelper.removeGalleryFormInfo({
        formId: formId,
        assetUris: [],
      });
      // 当卡片全部被删除后，取消云同步和回收站监听
      // instrument ignore next
      if (remainCount == 0) {
        Log.info(TAG, `get facard remainCount = 0, removeGalleryFormInfo`);
        photoAccessHelper.removeGalleryFormInfo({
          formId: FormConstants.ALL_FORM_ID,
          assetUris: [],
        })
      }
    } catch (err) {
      Log.error(TAG, `doFaCardDeleteTask failed, code = ${err?.code}, msg = ${err?.message}`);
    }
  }

  private async getCameraAlbum(): Promise<string> {
    try {
      let albumInfos: PhotoAlbum[] = await this.userFileManagerAccess.getSystemSourceAlbums();
      if (!albumInfos) {
        Log.debug(TAG, `getSourceAlbums, albums is undefined`);
        return '';
      }
      const cameraAlbum = albumInfos.find(item => item.lpath === Constants.LPATH_CAMERA);
      if (!cameraAlbum || !cameraAlbum.count) {
        Log.debug(TAG, `getSourceAlbums, cameraAlbum is undefined`);
        return '';
      }
      return cameraAlbum.albumUri;
    } catch (error) {
      Log.error(TAG, `getSourceAlbums error: ${error}`);
      return ''
    }
  }

  private async registerForCloud(formId: string): Promise<void> {
    Log.info(TAG, `registerForCloud， ${formId}`);
    let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
      this.userFileManagerAccess.getMediaLibrary();
    if (photoAccessHelper) {
      try {
        const trashAlbum: PhotoAlbum | undefined = await this.userFileManagerAccess.getTrashAlbum();
        const hiddenAlbum: PhotoAlbum | undefined = await this.userFileManagerAccess.getHiddenAlbum();
        let assetUris = [FormConstants.CLOUD_URI];
        if (trashAlbum) {
          assetUris.push(trashAlbum.albumUri);
        }
        if (hiddenAlbum) {
          assetUris.push(hiddenAlbum.albumUri);
        }
        Log.info(TAG, `assetUri is ${assetUris}`);
        // updateGalleryFormInfo底层逻辑是先删除后增加，可以防止多个卡片注册导致重复注册。
        await photoAccessHelper.updateGalleryFormInfo({
          formId: FormConstants.ALL_FORM_ID,
          assetUris: assetUris,
        });
      } catch (err) {
        Log.error(TAG, `registerForCloud failed, error message: ${err}`);
      }
    } else {
      Log.error(TAG, 'registerForCloud is null!');
    }
  }

  private async getFaAlbumUri(): Promise<string | undefined> {
    const cameraUri = await this.getCameraAlbum();
    if (cameraUri) {
      Log.info(TAG, `getFaAlbumUri from camera`);
      return cameraUri;
    }
    const album = await this.userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    if (album) {
      return album.albumUri;
    }
    return undefined;
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

  private async createDataShare(formId: string): Promise<void> {
    Log.info(TAG, 'onAddForm createDataShareHelper start. ' + formId);
    const templateUri: string = 'datashareproxy://com.ohos.photos/facard_metadata';
    const dsOptions: dataShare.DataShareHelperOptions = {
      isProxy: true,
    };

    Log.info(TAG, `createDataShare databaseDir = ${this.context.databaseDir} area = ${this.context.area}`);
    try {
      const dataShareHelper: dataShare.DataShareHelper = await dataShare.createDataShareHelper(this.context,
        'datashareproxy://com.ohos.photos', dsOptions);
      Log.info(TAG, 'DataShare createDataShareHelper, subscriberId ' + formId);
      dataShareHelper.delTemplate(templateUri, formId); // 先清理，在创建，避免多个template
      dataShareHelper.addTemplate(templateUri, formId, this.generateTemplate(formId));
    } catch (err) {
      Log.error(TAG, `DataShare createDataShareHelper, failed ${formId}, err: ${err?.code} ${err?.message}`);
      const msg: IFACardBigDataParams = {
        formId: formId,
        cardType: AlbumType.ALBUM,
      };
      ReportToBigDataUtil.report(BigDataConstants.CREATE_DATA_SHARE_FAIL, msg);
    } finally {
      Log.info(TAG, 'onAddForm createDataShareHelper end. ' + formId);
    }
  }

  /**
   *
   * @param task
   * @param isAgreed 用户是否同意隐私协议 ,
   * 不同意时,需要插入FaCard表数据,注册云同步监听和注册媒体库监听.
   */
  public async doFaCardCreateTask(task: Task, isAgreed: boolean) {
    if (!isAgreed) {
      await this.faCardService.insert(task.formId, AlbumType.ALBUM, VAL_SCHEDULER_DEFAULT_NUM,
        VAL_CARD_DATA_NOT_INSERT);
      this.reportFaCardCreatedBigData(task);
      return;
    }
    const isExistFaCard: boolean = await this.checkIsExistFaCard(task.formId);
    Log.info(TAG, 'doFaCardCreateTask isExistFaCard: ' + isExistFaCard);
    if (isExistFaCard) {
      return;
    }
    const albumUri: string | undefined = await this.getFaAlbumUri();
    if (!albumUri) {
      await this.faCardService.insert(task.formId, AlbumType.ALBUM, VAL_SCHEDULER_DEFAULT_NUM);
      this.reportFaCardCreatedBigData(task);
      return;
    }
    this.registerForCloud(task.formId);

    const albumName: string = await this.userFileManagerAccess.getAlbumNameByUri(albumUri, this.context);

    let result: photoAccessHelper.PhotoAsset[] = [];
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      result = await this.getAssetsInAlbum(albumUri, VAL_CARD_DATA_SIZE);
      await this.faCardService.insert(task.formId, AlbumType.ALBUM, VAL_SCHEDULER_DEFAULT_NUM, albumUri,
        result[0]?.uri, albumName, IsShowAlbumName.ON);

      const callback = async () => {
        await this.createDataShare(this.formId);
        this.reportFaCardCreatedBigData(task);
        await this.reminderService.registerForPhotosAndAlbums(this.formId, [], albumUri);
      }

      proxyResultSet = await this.imageProxyDataService.queryImageUri();

      const firstAsset = result.shift();
      if (firstAsset) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
        await FormController.insertRemindersAndProxy(this.formId, albumUri, [firstAsset], info.uriExistFlag,
          this.context);
      }

      await callback();

      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        await FormController.insertRemindersAndProxy(this.formId, albumUri, result, info.uriExistFlag, this.context);
      }
      Log.info(TAG, `registeralbum: ${albumUri} length: ${result.length}`);
    } catch (err) {
      Log.info(TAG, `userFileManager failed with err: code = ${err?.code}, msg = ${err?.message}`);
    } finally {
      proxyResultSet?.close();
      Log.info(TAG, `proxyResultSet is close.`);
    }
  }

  private async doFaCardAddTask(task: Task) {
    // 首张图插入在卡片进程做，剩余的发送任务处理
    Log.info(TAG, `doFaCardAddTask formId: ${task.formId}, task: ${JSON.stringify(task)}`);

    if (task.values == undefined) {
      Log.error(TAG, `doFaCardAddTask: not enough parameters are available to execute the task`);
      return;
    }
    const formId = task.formId;
    const values = task.values;
    const albumUri = String(values['albumUri']);
    const count = Number(values['count']);
    if (count == -1) {
      return;
    }

    let result: photoAccessHelper.PhotoAsset[] = [];
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      proxyResultSet = await this.imageProxyDataService.queryImageUri();
      result = await this.getAssetsInAlbum(albumUri, count);
      result.shift();

      if (FormControllerManager.getTaskPreemptedStatus(formId)) {
        return;
      }
      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        await insertTask(result, info.uriExistFlag, albumUri, this.context, formId);
      }
      if (FormControllerManager.getTaskPreemptedStatus(formId)) {
        return;
      }
      Log.info(TAG, `registeralbum: ${albumUri}`);
      await this.reminderService.registerForPhotosAndAlbums(formId, [], albumUri);
    } catch (err) {
      Log.info(TAG, `getAssetsInAlbum err: ${err}`);
    } finally {
      proxyResultSet?.close();
    }
  }

  private async doFaCardRestore(task: Task) {
    if (FormControllerManager.getTaskPreemptedStatus(task.formId)) {
      return;
    }
    Log.info(TAG, `doFaCardRestore formId: ${task.formId} albumUri: ${task.albumUri}`);
    if (task.albumUri !== VAL_CARD_DATA_NOT_INSERT) {
      return;
    }
    this.registerForCloud(task.formId);
    const albumUri: string | undefined = await this.getFaAlbumUri();
    if (!albumUri) {
      return;
    }
    let result: photoAccessHelper.PhotoAsset[] = [];
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      result = await this.getAssetsInAlbum(albumUri, VAL_CARD_DATA_SIZE);
      const albumName: string = await this.userFileManagerAccess.getAlbumNameByUri(albumUri, this.context);
      const value: ValuesBucket = { 'album_uri': albumUri, 'cover_uri': result[0]?.uri ?? '', 'album_name': albumName};
      await this.faCardService.update(task.formId, value);

      const callback = async () => {
        await this.createDataShare(task.formId);
        Log.info(TAG, `doFaCardRestore registeralbum: ${albumUri} length: ${result.length}`);
        await this.reminderService.registerForPhotosAndAlbums(task.formId, [], albumUri);
      }

      proxyResultSet = await this.imageProxyDataService.queryImageUri();

      const firstAsset = result.shift();
      if (firstAsset) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
        await FormController.insertRemindersAndProxy(this.formId, albumUri, [firstAsset], info.uriExistFlag,
          this.context);
      }

      await callback();

      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        await FormController.insertRemindersAndProxy(this.formId, albumUri, result, info.uriExistFlag, this.context);
      }
    } catch (err) {
      Log.info(TAG, `doFaCardRestore userFileManager failed with err: code = ${err?.code}, msg = ${err?.message}`);
    } finally {
      proxyResultSet?.close();
      Log.info(TAG, `doFaCardRestore proxyResultSet is close.`);
    }
  }

  private async doFaCardUpdateTask(task: Task) {
    Log.info(TAG, `doFaCardUpdateTask formId: ${task.formId}, task: ${JSON.stringify(task)}`);

    const formId = task.formId;
    const faCardInfo: FaCardInfo = await this.faCardService.queryFaCard(formId);
    Log.info(TAG, `doFaCardUpdateTask queryFaCard result: ${JSON.stringify(faCardInfo)}`);
    if (faCardInfo.albumType !== AlbumType.NOT_FOUND) {
      Log.info(TAG, `doFaCardUpdateTask will refresh card, albumUri: ${faCardInfo.albumUri}, albumType: ${faCardInfo.albumType}`);
      await this.doRefreshFaCardTask(task);
      await this.faCardAlbumUtils.updateForm(faCardInfo, this.context);
      Log.info(TAG, `doFaCardUpdateTask updateForm done, formId: ${formId}`);
    } else {
      Log.info(TAG, `doFaCardUpdateTask skip, albumType is NOT_FOUND, formId: ${formId}`);
    }

    if (!DatabaseProxy.getInstance().isUpdatingBound()) {
      this.updateImageBoundData(this.imageProxyDataService);
    }
  }

  private async doSelectAlbumTask(task: Task) {
    Log.info(TAG, `doSelectAlbumTask formId: ${task.formId}, task: ${JSON.stringify(task)}`);

    if (task.album == undefined || task.interval == undefined || task.albumType == undefined) {
      Log.error(TAG, `doSelectAlbumTask: not enough parameters are available to execute the task`);
      return;
    }
    const formId = task.formId;
    const album = task.album;
    const interval = task.interval;
    const albumType = task.albumType;
    await this.faCardAlbumUtils.handleClick(album, formId, interval, albumType);
  }

  private async doSelectPhotoTask(task: Task) {
    Log.info(TAG, `doSelectPhotoTask formId: ${task.formId}, task: ${JSON.stringify(task)}`);

    if (task.values == undefined) {
      Log.error(TAG, `doSelectPhotoTask: not enough parameters are available to execute the task`);
      return;
    }
    const formId = task.formId;
    const coverUri = String(task.values['cover_uri']);
    const albumUri = String(task.values['album_uri']);
    const interval = Number(task.values['playback_interval']);
    const isMultiplePhotos = task.photoUris && task.photoUris.length > 1;
    try {
      const deleteNO = await this.reminderService.deletePhotosByFormId(formId, undefined);
      // 删除成功，增加相册数据
      if (deleteNO !== undefined) {
        Log.info(TAG, `savedata deleteByFormId success, deleteNO: ${deleteNO}`);
        let fetchColumns = UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
        
        if (isMultiplePhotos && task.photoUris) {
          Log.info(TAG, `doSelectPhotoTask: inserting multiple photos, count: ${task.photoUris.length}`);
          const photoAssets: PhotoAsset[] = [];
          for (const uri of task.photoUris) {
            const photoAsset: photoAccessHelper.PhotoAsset | undefined =
              await this.userFileManagerAccess.getPhotoAssetByUri(uri, fetchColumns);
            if (photoAsset) {
              photoAssets.push(photoAsset);
            }
          }
          if (photoAssets.length > 0) {
            await FaCardAlbumUtils.insertRemindersAndProxy(photoAssets, albumUri, this.context, formId);
          }
        } else {
          const photoAsset: photoAccessHelper.PhotoAsset | undefined =
            await this.userFileManagerAccess.getPhotoAssetByUri(coverUri, fetchColumns);
          if (photoAsset) {
            await FaCardAlbumUtils.insertSinglePhoto(photoAsset, albumUri, this.context, formId);
          }
        }
      } else {
        Log.error(TAG, `savedata deleteByFormId fail, deleteNO: ${deleteNO}`);
      }
      task.values['album_name'] = '';
      const updateNO = await this.faCardService.insertOrUpdate(formId, task.values);
      FaCardAlbumUtils.terminate();
      if (updateNO !== undefined) {
        FaCardAlbumUtils.updateScheduler(formId, interval, true);
        let proxyResultSet: DataShareResultSet | undefined = undefined;
        try {
          const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(this.context);
          proxyResultSet = await imageProxyDataService.queryImageProxyDataByUri(coverUri);
          if (proxyResultSet && proxyResultSet.rowCount > 0) {
            proxyResultSet.goToFirstRow();
            const uriIdx: number = proxyResultSet.getColumnIndex(ImageProxyDataTable.URI);
            const blobIdx: number = proxyResultSet.getColumnIndex(ImageProxyDataTable.BLOB);
            const boundIdx: number = proxyResultSet.getColumnIndex(ImageProxyDataTable.BOUND);
            const imageValue: ValuesBucket = {
              uri: proxyResultSet.getString(uriIdx),
              photo_blob: proxyResultSet.getString(blobIdx),
              photo_bound: proxyResultSet.getString(boundIdx),
            };
            await FaCardAlbumUtils.updateFormById(formId, imageValue);
          } else {
            Log.info(TAG, `doSelectPhotoTask updateFormById skip, no proxy data for uri: ${coverUri}`);
          }
        } catch (error) {
          Log.error(TAG, `doSelectPhotoTask updateFormById error: ${error}`);
        } finally {
          proxyResultSet?.close();
        }
      }
    } catch (err) {
      Log.info(TAG, `doSelectPhotoTask err: ${err}`)
    }
  }

  private async doMediaUpdateAlbumTask(task: Task) {
    Log.info(TAG, `doMediaUpdateAlbumTask formId: ${task.formId}, task: ${JSON.stringify(task)}`);
    if (task.faCardInfo == undefined) {
      Log.error(TAG, `doMediaUpdateAlbumTask: not enough parameters are available to execute the task`);
      return;
    }
    const faCardInfo = task.faCardInfo;
    await this.faCardAlbumUtils.updateForm(faCardInfo, this.context);
  }

  private async doRefreshFaCardTask(task: Task) {
    if (FormControllerManager.getTaskPreemptedStatus(task.formId)) {
      return;
    }
    const now = new Date().getTime();
    if (now - this.lastRefreshTime < VAL_REFRESH_TIME) {
      return;
    }
    this.lastRefreshTime = now;
    Log.info(TAG, `doRefreshFaCardTask formId: ${task.formId}, ${this.lastRefreshTime}`);
    const faCardInfo: FaCardInfo = await this.faCardService.queryFaCard(task.formId);
    if (faCardInfo.albumType === AlbumType.NOT_FOUND) {
      return;
    }
    // 刷新数据
    const hiddenIds: string[] = [];
    const batchSize: number = 360;
    for (let offset = 0;; offset += batchSize) {
      const reminderInfos: ReminderInfo[] =
        await this.reminderService.getNotHiddenReminderInfos(batchSize, offset, task.formId);
      if (reminderInfos.length == 0) {
        break;
      }
      const reminderUris: string[] = reminderInfos.map(reminderInfo => reminderInfo.imageUri);
      let assets: photoAccessHelper.PhotoAsset[] = [];
      if (faCardInfo.albumUri) {
        assets =
          await this.userFileManagerAccess.getPhotoAssetByAlbumUri(faCardInfo.albumUri,
            reminderUris, [photoAccessHelper.PhotoKeys.URI]);
      } else {
        assets =
          await this.userFileManagerAccess.getPhotoAssetByUriArray(
            reminderUris, [photoAccessHelper.PhotoKeys.URI]);
      }
      Log.info(TAG,
        `getPhotoAssetByUriArray success, ${faCardInfo.albumUri} found ${assets.length} items, offset = ${offset}`);
      const assetUris: Set<string> = new Set(assets.map(asset => asset.uri));
      for (const reminderInfo of reminderInfos) {
        if (!assetUris.has(reminderInfo.imageUri)) {
          hiddenIds.push(reminderInfo.id);
          Log.info(TAG, `hiddenIds size = ${hiddenIds.length} imageUri = ${reminderInfo.imageUri}`);
        }
      }
      if (reminderInfos.length < batchSize) {
        break;
      }
    }
    if (hiddenIds.length) {
      await this.reminderService.hiddenRecordByIds(hiddenIds);
    }
    Log.info(TAG, `doRefreshFaCardTask end formId: ${task.formId} ${hiddenIds.length}`);
  }

  private async getAlbumByUri(albumUri: string): Promise<photoAccessHelper.Album> {
    return await this.userFileManagerAccess.getAlbumByUri(albumUri) as photoAccessHelper.Album;
  }

  private async getAssetsInAlbum(albumUri: string, count: number,): Promise<PhotoAsset[]> {
    let result: photoAccessHelper.PhotoAsset[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      const album = await this.getAlbumByUri(albumUri);
      // 卡片只支持显示图片
      let fetchOpt = AlbumDefine.getFileFetchOptWithDate(count, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, 0);
      fetchResult = await album.getAssets(fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'getAssetsInAlbum with empty dataList');
        return [];
      }
      Log.info(TAG, `getAssetsInAlbum raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, 'getAssetsInAlbum with empty dataList, count is 0');
        return [];
      }
      result = await fetchResult.getAllObjects();
    } catch (err) {
      Log.error(TAG, `get assets in album, error: ${err?.code}, ${err?.message}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return result;
  }

  private async checkIsExistFaCard(formId: string): Promise<boolean> {
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.faCardService.queryByFormId(formId);
      return Boolean(queryResult && queryResult.rowCount > 0);
    } catch (error) {
      Log.error(TAG, `checkIsExistFaCard error: ${error?.code}, ${error?.msg}`);
      return false;
    } finally {
      queryResult?.close();
    }
  }

  private reportFaCardCreatedBigData(task: Task): void {
    const msg: IFACardBigDataParams = {
      formId: task.formId,
      formType: `${task.formDimension}`,
      costTime: Date.now() - (task.recordStartTime ?? 0),
      cardType: AlbumType.ALBUM,
    };
    ReportToBigDataUtil.report(BigDataConstants.CARD_CREATE_CARD, msg);
  }

  // 文件资产插入到数据表中
  public static async insertRemindersAndProxy(formId: string, albumUri: string, assets: PhotoAsset[],
    uriExistFlag: boolean[], context: Context): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      return;
    }
    if (!context || !assets.length || !uriExistFlag.length || !formId.length || !albumUri.length) {
      Log.error(TAG, `insertRemindersAndProxy error with failed params`);
      return;
    }

    if (assets.length !== uriExistFlag.length) {
      Log.error(TAG, `insertRemindersAndProxy error, assets.length != uriExistFlag.length`);
      return;
    }

    Log.info(TAG, `insertRemindersAndProxy start, formId: ${formId}, albumUri: ${
    albumUri}, assets size: ${assets.length}, uriExistFlag: ${uriExistFlag}`);
    try {
      const task: taskpool.Task = new taskpool.Task(insertSendableTask, assets, uriExistFlag, albumUri,
        sendableContextManager.convertFromContext(context), formId);

      Log.info(TAG, `formId: ${formId}, setPoolTask: ${task.taskId}`);
      await FormControllerManager.getInstance(context).addPoolTask(formId, task);
      if (FormControllerManager.getTaskPreemptedStatus(formId)) {
        Log.info(TAG, `formId: ${formId}, give up pool task`);
        return;
      }
      await taskpool.execute(task);
      Log.info(TAG, `insertRemindersAndProxy end`);
    } catch (error) {
      Log.error(TAG, `insertRemindersAndProxy error: ${error}`);
    }
  }

  private generateTemplate(formId: string): dataShare.Template {
    let isMemoryTest: boolean = this.getSystemParamOfMemoryTest();
    const timeOffset: string = isMemoryTest ? VAL_SCHEDULER_MEMORY_TEST : VAL_SCHEDULER_DEFAULT;
    let lightGlimpseFlag: boolean = LightGlimpseUtil.getSystemLightGlimpse();
    let agendaSql: string = lightGlimpseFlag ? FormConstants.QUERY_VALID_AGENDA_SQL_WITH_LIGHT_GLIMPSE :
      FormConstants.QUERY_VALID_AGENDA_SQL;
    let template: dataShare.Template = {
      predicates: {
        'agendaObjList': agendaSql.replace('?', formId)
      },
      scheduler: FormConstants.REFRESH_CARD_SQL.replace(FormConstants.SQL_REPLACE_TIME_OFFSET, timeOffset)
        .replace('?', formId),
      update: FormConstants.UPDATE_CARD_SQL.replaceAll('?', formId),
    };
    return template;
  }
}

@Concurrent
// instrument ignore next
export async function insertSendableTask(result: photoAccessHelper.PhotoAsset[], uriExistFlag: boolean[],
  albumUri: string, sendableContext: sendableContextManager.SendableContext, formId: string) {
  const insertSendableTaskImpl = new InsertSendableTaskImpl(formId, albumUri, sendableContext);
  await insertSendableTaskImpl.process(result, uriExistFlag);
}
