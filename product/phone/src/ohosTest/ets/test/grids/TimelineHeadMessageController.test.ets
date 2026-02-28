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
import { describe, expect, it, MockKit } from '@ohos/hypium';
import { TimelineHeadMessageController } from '@ohos/common/src/main/ets/default/utils/TimelineHeadMessageController';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

export default function TimelineHeadMessageControllerTest() {
  describe('TimelineHeadMessageControllerTest', () => {
    const TAG: string = 'TimelineHeadMessageController';
    //测试reset
    it('resetTest', 0, async() => {
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.debug);
      const timelineHeadMessageController = TimelineHeadMessageController.getInstance();
      Reflect.set(timelineHeadMessageController, 'isQuerying', true);
      timelineHeadMessageController.updateUploadingCount();
      mocker.verify('debug', [TAG, ' Query is already in progress. Skipping...']).atLeast(1);
      mocker.ignoreMock(Log, Log.debug);
    });

  });
}