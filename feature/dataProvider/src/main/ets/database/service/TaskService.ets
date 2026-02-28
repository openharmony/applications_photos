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
import lazy { ValuesBucket } from '@kit.ArkData';
import lazy DBHelper from '../DBHelper';
import lazy { buildUri, TaskUri } from '../databaseconstant/TaskInfo';

const TAG: string = 'TaskService';

export default class TaskService {
  private static sInstance: TaskService;
  protected context: Context;

  constructor(context: Context) {
    this.context = context;
  }

  public static getInstance(context: Context): TaskService {
    Log.info(TAG, `getInstance context: ${context}`);
    if (!TaskService.sInstance) {
      TaskService.sInstance = new TaskService(context);
    }
    return TaskService.sInstance;
  }

  async insertTask(formId: string, taskUri: TaskUri, value?: ValuesBucket): Promise<void> {
    if (!this.context) {
      Log.info(TAG, `mInsert context undefined`);
      return;
    }
    const uri = buildUri(taskUri, formId);
    if (value == undefined) {
      value = { 'formId': formId } as ValuesBucket;
    }
    Log.info(TAG, `Task uri : ${uri}, value: ${JSON.stringify(value)}`);
    try {
      await DBHelper.getInstance(this.context)
        .doInsert(uri, value, this.context);
    } catch (error) {
      Log.error(TAG, `mInsert error ${error}`);
    }
  }
}