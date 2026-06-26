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
import lazy { FaCardAlbumUtils } from '../database/service/FaCardAlbumService';
import lazy FaCardService from '../database/service/FaCardService';
import lazy ImageProxyDataService from '../database/service/ImageProxyDataService';
import lazy ReminderService from '../database/service/ReminderService';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Task, TaskUri } from '../database/databaseconstant/TaskInfo';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { taskpool } from '@kit.ArkTS';
import lazy DataShareResultSet from '@ohos.data.DataShareResultSet';
import lazy { AlbumType, FaCardTable } from '../database/databaseconstant/FaCardTable';
import lazy { BaseFormController } from './BaseFormController';
import lazy { FormController } from './FormController';
import lazy { formProvider } from '@kit.FormKit';
import lazy DatabaseProxy from '../database/DatabaseProxy';
import lazy { PipeStream } from '../promise/PromiseStream';
import DatabaseUtils from '../database/DatabaseUtils';

/* instrument ignore file */
const TAG: string = 'FormControllerManager';

export class FormControllerManager {
  private static instance: FormControllerManager | undefined = undefined;
  private formControllerMap: Map<string, BaseFormController> = new Map<string, BaseFormController>();
  public context: Context;
  public userFileManagerAccess: UserFileManagerAccess;
  public faCardService: FaCardService;
  public imageProxyDataService: ImageProxyDataService;
  public reminderService: ReminderService;
  public faCardAlbumUtils: FaCardAlbumUtils;
  public pipeStreamInstance: PipeStream<void> = new PipeStream(60 * 1000);

  private constructor(context: Context) {
    Log.info(TAG, 'new FormControllerManager');

    this.context = context;
    this.faCardService = new FaCardService(context as Context);
    this.imageProxyDataService = new ImageProxyDataService(context as Context);
    this.reminderService = new ReminderService(context as Context);
    this.faCardAlbumUtils = new FaCardAlbumUtils(context as Context);

    this.userFileManagerAccess = new UserFileManagerAccess();
    this.userFileManagerAccess.onCreate(context);
  }

  public static getInstance(context: Context): FormControllerManager {
    if (!FormControllerManager.instance) {
      FormControllerManager.instance = new FormControllerManager(context);
    }
    return FormControllerManager.instance;
  }

  public static getInstanceV2(): FormControllerManager | undefined {
    return FormControllerManager.instance;
  }

  private async createFormController(formId: string): Promise<BaseFormController | undefined> {
    let controller: BaseFormController;
    try {
      const infoRet = await formProvider.getPublishedFormInfoById(formId);


      let infoStr: string = JSON.stringify(infoRet);
      let info: object | null = JSON.parse(infoStr);
      Log.info(TAG, `createFormController, name = ${JSON.stringify(info)}`);
      controller = new FormController(formId, this);
      this.formControllerMap.set(formId, controller);
      return controller;
    } catch (err) {
      Log.error(TAG, `createFormController formProvider error ${err?.code} ${err?.message}`);
      const info = await this.faCardService.queryFaCard(formId);
      if (info.albumType === AlbumType.NOT_FOUND) {
        Log.error(TAG, `createFormController albumType error ${info.albumType}`);
        return;
      } else {
        controller = new FormController(formId, this);
      }
      Log.info(TAG, `createFormController ${formId} albumType ${info.albumType}`);
      this.formControllerMap.set(formId, controller);
      return controller;
    }
  }

  private async getFormController(formId: string): Promise<BaseFormController | undefined> {
    if (this.formControllerMap.has(formId)) {
      Log.info(TAG, `FormController is exist, formId = ${formId}`);
      return this.formControllerMap.get(formId);
    }

    let controller: BaseFormController | undefined = await this.createFormController(formId);
    if (!controller) {
      Log.error(TAG, `createFormController failed, formId = ${formId}`);
    }

    return controller;
  }

  public deleteFormController(formId: string): void {
    this.formControllerMap.delete(formId);
  }

  /**
   * 场景: 用户没有同意隐私协议时, 只允许添加默认图卡片到桌面，不允许插入数据. 用户同意后才可以插入数据
   * 根据当前faCard表数据，恢复reminders和image_proxy
   * @returns
   */
  public async restore(): Promise<void> {
    let faResultSet: DataShareResultSet | undefined = undefined;
    try {
      faResultSet = await this.faCardService.queryAllForm();
      if (!faResultSet || faResultSet.rowCount <= 0) {
        Log.info(TAG, `restore faResultSet rowCount is ${faResultSet?.rowCount}`);
        return;
      }
      faResultSet.goToFirstRow();
      const albumUriIndex = faResultSet.getColumnIndex(FaCardTable.ALBUM_URI);
      const formIdIndex = faResultSet.getColumnIndex(FaCardTable.FORM_ID);
      for (let i = 0; i < faResultSet.rowCount; i++) {
        Log.info(TAG, `restore total number: ${faResultSet.rowCount}, index: ${i}`);
        const albumUri = faResultSet.getString(albumUriIndex);
        const formId = faResultSet.getString(formIdIndex);
        await this.doTask({ formId, albumUri, taskUri: TaskUri.TASK_RESTORE_FACARD_URI });
        faResultSet.goToNextRow();
      }
    } catch (error) {
      Log.error(TAG, `restore code: ${error.code} error: ${error.message}`);
    } finally {
      faResultSet?.close();
    }
  }

  public async doTask(task: Task): Promise<void> {
    const formController: BaseFormController | undefined = await this.getFormController(task.formId);
    Log.info(TAG, `doTask ${task.taskUri}`);
    /**
     * 创建卡片
     * 删除卡片
     * */

    if (TaskUri.TASK_UPDATE_FACARD_URI === task.taskUri) {
      // 卡片更新单独管理
      await this.doUpdateTask(task, formController);
      return;
    }

    formController?.addTask(task);
    await formController?.executeTask(true);

    if (task.taskUri == TaskUri.TASK_DELETE_FACARD_URI) {
      this.deleteFormController(task.formId);
    }
  }

  /**
   * 卡片更新操作
   * 1. 先执行db清理操作: 删除没有faCard表关联的reminders和iamge_proxy_data
   * 2. 再将update任务插入队列中
   * */
  public async doUpdateTask(task: Task, formController?: BaseFormController) {
    // 放在pipeStream中执行
    Log.info(TAG, `doUpdateTask pipeStream emitAndGetStream: ${task.formId}`);
    await this.pipeStreamInstance.emitAndGetStream(async () => {
      await DatabaseProxy.getInstance().clear();
      Log.info(TAG, `doUpdateTask pipeStream execute task: ${task.formId}`);

      // 这里统一兜底：按 formId 再获取一次（必要时会创建）
      const controller: BaseFormController | undefined =
        formController ?? await this.getFormController(task.formId);
      if (!controller) {
        Log.error(TAG, `doUpdateTask skip, formController is undefined, formId: ${task.formId}`);
        return;
      }

      Log.info(TAG, `doUpdateTask addTask formId: ${task.formId}, taskUri: ${task.taskUri}`);
      controller.addTask(task);
      Log.info(TAG, `doUpdateTask executeTask formId: ${task.formId}`);
      await controller.executeTask(true);
      Log.info(TAG, `doUpdateTask executeTask done, formId: ${task.formId}`);
    }, task.formId);
    Log.info(TAG, `doUpdateTask pipeStream emitAndGetStream done: ${task.formId}`);
  }

  /**
   * 立即执行一次更新任务（不经过 pipeStream 串行队列）
   * 仅用于相册删除这类低频、必须立刻生效的场景，避免与其他更新任务抢占导致本次不执行。
   */
  public async doUpdateTaskImmediately(task: Task, formController?: BaseFormController) {
    Log.info(TAG, `doUpdateTaskImmediately start, formId: ${task.formId}, taskUri: ${task.taskUri}`);
    await DatabaseProxy.getInstance().clear();
    const controller: BaseFormController | undefined =
      formController ?? await this.getFormController(task.formId);
    if (!controller) {
      Log.error(TAG, `doUpdateTaskImmediately skip, formController is undefined, formId: ${task.formId}`);
      return;
    }
    Log.info(TAG, `doUpdateTaskImmediately addTask formId: ${task.formId}, taskUri: ${task.taskUri}`);
    controller.addTask(task);
    Log.info(TAG, `doUpdateTaskImmediately executeTask formId: ${task.formId}`);
    await controller.executeTask(true);
    Log.info(TAG, `doUpdateTaskImmediately executeTask done, formId: ${task.formId}`);
  }

  /**
   * 删除图片后通知使用了该图片的桌面卡片刷新
   * 1. 查询包含这些 imageUri 的卡片 formId
   * 2. 将 Reminders 中对应记录标为隐藏（卡片 SQL 会过滤 is_hidden）
   * 3. 对每个受影响的 formId 触发一次卡片更新任务
   *
   * @param imageUris 被删除的图片 URI 列表
   */
  public async notifyCardsOnPhotoDeleted(imageUris: string[]): Promise<void> {
    if (!imageUris || imageUris.length === 0) {
      return;
    }
    try {
      const formIds: string[] = await this.reminderService.queryFormIdsByImageUris(imageUris);
      if (formIds.length === 0) {
        Log.info(TAG, `notifyCardsOnPhotoDeleted no cards use these uris`);
        return;
      }
      // 使用 image_uri_id 维度进行隐藏，避免 URI 形态差异导致命中失败
      await this.reminderService.hiddenRecordByImageUriIds(
        DatabaseUtils.extractAssetUriPaths(imageUris)
      );
      Log.info(TAG, `notifyCardsOnPhotoDeleted hidden reminders for uris, formIds: ${JSON.stringify(formIds)}`);
      for (const formId of formIds) {
        const formController: BaseFormController | undefined = await this.getFormController(formId);
        await this.doUpdateTask({
          formId,
          taskUri: TaskUri.TASK_UPDATE_FACARD_URI
        }, formController);
      }
    } catch (error) {
      Log.error(TAG, `notifyCardsOnPhotoDeleted error: ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 覆盖编辑图片后通知使用了该图片的桌面卡片刷新
   * 1. 查询包含这些 imageUri 的卡片 formId
   * 2. 不修改 Reminders 记录（仍然使用同一张图片，仅内容更新）
   * 3. 对每个受影响的 formId 触发一次卡片更新任务
   *
   * @param imageUris 被更新的图片 URI 列表
   */
  public async notifyCardsOnPhotoUpdated(imageUris: string[]): Promise<void> {
    if (!imageUris || imageUris.length === 0) {
      return;
    }
    try {
      const formIds: string[] = await this.reminderService.queryFormIdsByImageUris(imageUris);
      if (formIds.length === 0) {
        Log.info(TAG, `notifyCardsOnPhotoUpdated no cards use these uris`);
        return;
      }
      Log.info(TAG, `notifyCardsOnPhotoUpdated formIds: ${JSON.stringify(formIds)}`);
      for (const formId of formIds) {
        const formController: BaseFormController | undefined = await this.getFormController(formId);
        await this.doUpdateTask({
          formId,
          taskUri: TaskUri.TASK_UPDATE_FACARD_URI
        }, formController);
      }
    } catch (error) {
      Log.error(TAG, `notifyCardsOnPhotoUpdated error: ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 删除相册后通知使用了该相册的桌面卡片刷新
   *
   * @param albumUri 被删除的相册 URI
   */
  public async notifyCardsOnAlbumDeleted(albumUri: string): Promise<void> {
    if (!albumUri) {
      return;
    }
    try {
      const faCardInfos = await this.faCardService.queryFaCardsByAlbumUri(albumUri);
      if (!faCardInfos || faCardInfos.length === 0) {
        Log.info(TAG, `notifyCardsOnAlbumDeleted no cards use this album: ${albumUri}`);
        return;
      }
      Log.info(TAG,
        `notifyCardsOnAlbumDeleted albumUri: ${albumUri}, formIds: ${JSON.stringify(faCardInfos.map(f => f.formId))}`);
      for (const info of faCardInfos) {
        const formController: BaseFormController | undefined = await this.getFormController(info.formId);
        // 相册删除场景下，为了保证每次操作都能立即刷新卡片，这里不走 pipeStream 串行队列，直接执行更新任务
        await this.doUpdateTaskImmediately({
          formId: info.formId,
          taskUri: TaskUri.TASK_UPDATE_FACARD_URI
        }, formController);
      }
    } catch (error) {
      Log.error(TAG, `notifyCardsOnAlbumDeleted error: ${error?.code}, ${error?.message}`);
    }
  }

  public async addPoolTask(formId: string, poolTask: taskpool.Task) {
    Log.info(TAG, `addPoolTask: ${poolTask.taskId}`);
    const formController: BaseFormController | undefined = await this.getFormController(formId);

    formController?.setPoolTask(poolTask);
  }

  public static setTaskPreemptedStatus(formId: string): void {
    AppStorage.setOrCreate('taskPreempted' + formId, true);
  }

  public static deleteTaskPreemptedStatus(formId: string): void {
    AppStorage.delete('taskPreempted' + formId);
  }

  public static getTaskPreemptedStatus(formId: string): boolean {
    const taskPreemptedStatus: boolean | undefined = AppStorage.get<boolean>('taskPreempted' + formId);
    if (taskPreemptedStatus == undefined) {
      return false;
    } else {
      Log.info(TAG, `formId: ${formId}, taskPreemptedStatus: ${taskPreemptedStatus}`);
      return taskPreemptedStatus;
    }
  }
}