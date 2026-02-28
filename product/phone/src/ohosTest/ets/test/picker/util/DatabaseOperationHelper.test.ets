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
import {
  describe,
  beforeAll,
  afterAll,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  Level
} from '@ohos/hypium';
import DatabaseOperationHelper from '@ohos/dataprovider/src/main/ets/database/DatabaseOperationHelper';
import DatabaseProxy from '@ohos/dataprovider/src/main/ets/database/DatabaseProxy';
import { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager'
import * as TaskInfo from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';

export default function DatabaseOperationHelperTest() {
  describe('DatabaseOperationHelperTest', () => {
    let DatabaseOperationHelperInstance: DatabaseOperationHelper;
    let mocker: MockKit;

    beforeAll(() => {
      mocker = new MockKit();
      when(mocker.mockFunc(DatabaseProxy, DatabaseProxy.getInstance))(ArgumentMatchers.any).afterReturn({
        init() {
          return true
        }
      })
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getInstance))(ArgumentMatchers.any)
        .afterReturn({
          doTask(task: TaskInfo.Task) {

          }
        })
      when(mocker.mockFunc(TaskInfo, TaskInfo.isTaskUri))(ArgumentMatchers.any).afterReturn(true)
      DatabaseOperationHelperInstance = DatabaseOperationHelper.with();
      DatabaseOperationHelperInstance.tryInitDatabase();
    })

    afterEach(() => {
      mocker.clearAll();
    })
  })
}
