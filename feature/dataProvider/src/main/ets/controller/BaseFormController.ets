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

import lazy { UserFileManagerAccess, PhotoAsset } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Task, taskPriority, TaskUri } from '../database/databaseconstant/TaskInfo';
import lazy { FormControllerManager } from './FormControllerManager';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy ImageProxyDataService from '../database/service/ImageProxyDataService';
import lazy DatabaseProxy from '../database/DatabaseProxy';
import lazy { DataShareResultSet } from '@kit.ArkData';

const TAG: string = 'BaseFormController';

export abstract class BaseFormController {
  protected formId: string;
  protected taskQueue: Array<Task>;
  protected runningTask: TaskUri | undefined;
  protected poolTask: taskpool.Task | undefined = undefined; // taskpool中的task
  // from FormControllerManager
  protected context: Context;
  protected userFileManagerAccess: UserFileManagerAccess;

  constructor(formId: string, formControllerManager: FormControllerManager) {
    this.taskQueue = [];
    this.runningTask = undefined;
    this.formId = formId;

    this.context = formControllerManager.context;
    this.userFileManagerAccess = formControllerManager.userFileManagerAccess;
  }

  public abstract executeTask(isAgreed: boolean);

  public addTask(task: Task): void {
    Log.info(TAG, `addTask ${JSON.stringify(task)}`);
    // 判断当前formId对应的任务是放弃、抢占，加入任务队列
    const formId = task.formId;

    let taskNumber: number = this.taskQueue.length;
    if (taskNumber > 0) {
      // 判断优先级，进行抢占or放弃
      while (this.taskQueue.length !== 0) {
        const lastTaskUri = this.taskQueue[this.taskQueue.length - 1].taskUri;

        if (this.isHigherPriority(task.taskUri, lastTaskUri)) {
          // 根据优先级放弃当前等待任务，pop的结果可能是undefined，说明任务可能已经被提前取走运行，队列为空
          this.taskQueue.pop();
          Log.info(TAG, `addTask formId: ${formId} give up the pre task:${lastTaskUri} because the
            priority is lower than task:${task.taskUri}`);
        } else {
          // 当前优先级低，当前任务放弃
          Log.info(TAG, `addTask formId: ${formId} give up the now task:${task.
            taskUri} because the priority is lower than task:${lastTaskUri}`);
          return;
        }
      }
    }

    if (this.runningTask == undefined) {
      Log.info(TAG, `addTask formId: ${formId}, add now task ${JSON.stringify(task)}`);
      this.taskQueue.push(task);
    } else {
      if (this.isHigherPriority(task.taskUri, this.runningTask)) {
        Log.info(TAG, `addTask formId: ${formId}, now preemption task:${task.taskUri}, running task:${this.
          runningTask}`);
        // 发送当前运行任务打断信号
        FormControllerManager.setTaskPreemptedStatus(formId);
        // 如果taskpool中存在运行中的任务，进行中止
        // instrument ignore if
        if (this.poolTask !== undefined) {
          Log.info(TAG, `addTask formId: ${formId}, cancel poolTask: ${this.poolTask.taskId}`);
          try {
            taskpool.cancel(this.poolTask);
          } catch (err) {
            Log.error(TAG, `addTask error formId: ${formId}, err: ${err?.code} ${err?.message}`);
          }
        }
        this.taskQueue.push(task);
      } else {
        Log.info(TAG, `addTask formId: ${formId} give up the now task:${task.
          taskUri} because the priority is lower than running task:${this.runningTask}`);
      }
    }
    Log.info(TAG, `addTask formId: ${formId}, taskQueueMap length: ${this.taskQueue.length}`);
  }

  public setPoolTask(poolTask: taskpool.Task): void {
    this.poolTask = poolTask;
  }

  private isHigherPriority(nowTask: TaskUri, preTask: TaskUri): boolean {
    const nowTaskPriority: number | undefined = taskPriority.get(nowTask);
    const preTaskPriority: number | undefined = taskPriority.get(preTask);
    if (nowTaskPriority === undefined || preTaskPriority === undefined) {
      Log.error(TAG, 'taskPriority invalid key');
      return false;
    } else {
      return nowTaskPriority >= preTaskPriority;
    }
  }

  public async updatePhotoBounds(uris: string[], imageProxyDataService: ImageProxyDataService) {
    // 批量查询Asset
    let photoAssets: PhotoAsset[] = [];
    photoAssets = await this.userFileManagerAccess.getPhotoAssetByUriArray(uris);
    if (!photoAssets.length) {
      Log.info(TAG, `updatePhotoBounds: no PhotoAsset data, uris.length ${uris.length}`);
      return;
    }

    Log.info(TAG, `updatePhotoBounds: uris ${uris.length}, photoAssets ${photoAssets.length}`);

    // 更新image_proxy_data表
    let updated: number = 0;
    for (const asset of photoAssets) {
      let ret = await imageProxyDataService.updateImageBoundByAsset(asset);
      if (ret) {
        updated++;
      } else {
        Log.info(TAG, `updatePhotoBounds failed, uri: ${asset.uri}`);
      }
    }

    Log.info(TAG, `updatePhotoBounds: updated ${updated} records`);
  }

  // 媒体库中，图片的最佳呈现详细是一个从无到有的过程，不能实时的同步到
  // image_proxy_data表中。在FA卡片固定的更新周期内去同步可能的数据更新
  public async updateImageBoundData(imageProxyDataService: ImageProxyDataService) {
    Log.info(TAG, `updateImageBoundData: -------------begin------------`);

    // 重置更新flag, 同一个卡片更新周期内只执行一次
    DatabaseProxy.getInstance().setUpdatingBound(true);

    let result: DataShareResultSet | undefined = undefined;

    try {
      // 查询需要更新的图片列表
      result = await imageProxyDataService.queryImageBounds();
      if (result && result.rowCount) {
        const uris: string[] = [];
        const uriIdx: number = result.getColumnIndex('uri');
        const boundIdx: number = result.getColumnIndex('photo_bound');

        while (result.goToNextRow()) {
          // 只更新bound为空的
          const bound = result.getString(boundIdx);
          if (!bound) {
            uris.push(result.getString(uriIdx));
          }
        }

        // 分批次更新
        const batchSize: number = 360;
        for (let i = 0; i < uris.length; i += batchSize) {
          Log.info(TAG, `updateImageBoundData: batch ${i}, uris.length ${uris.length}`);
          const batch = uris.slice(i, i + batchSize);
          await this.updatePhotoBounds(batch, imageProxyDataService);
        }
      } else {
        Log.info(TAG, `updateImageBoundData: no data to be updated`);
      }
    } catch (error) {
      Log.error(TAG, `updateImageBoundData: error: ${error}`);
    } finally {
      result?.close();
    }

    // 重置更新flag
    DatabaseProxy.getInstance().setUpdatingBound(false);

    Log.info(TAG, `updateImageBoundData: -------------end------------`);
  }

}