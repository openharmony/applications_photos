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
import { describe, it, expect } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { TimelineTool } from '@ohos/timeline/src/main/ets/model/static/TimelineTool';
import RscGetter from '@ohos/tools/src/main/global/RscGetter';
import { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';

/**
 * TimelineTool Unittest
 *
 * @since 2025-07-08
 */
export default function TimelineToolTest() {
  describe('TimelineToolTest', () => {
    it('TimelineToolTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimelineToolTest001();
    });
    it('TimelineToolTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimelineToolTest002();
    });
    it('TimelineToolTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimelineToolTest003();
    });
    it('TimelineToolTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimelineToolTest004();
    });
    it('TimelineToolTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimelineToolTest005();
    });
  })
}

/**
 * setViewFirstIndex
 * 设置viewFirstIndex
 */
async function TimelineToolTest001() {
  TimelineTool.setViewFirstIndex(1);
  let viewFirstIndex: number = TimelineTool.getViewFirstIndex();
  expect(viewFirstIndex).assertEqual(1);
}

/**
 * getViewFirstIndex
 * 获得viewFirstIndex
 */
async function TimelineToolTest002() {
  let viewFirstIndex: number = TimelineTool.getViewFirstIndex();
  expect(viewFirstIndex).assertEqual(1);
}

/**
 * formatTimeStampToLocalizedDate
 * 获得formatTimeStampToLocalizedDate
 */
async function TimelineToolTest003() {
  let milliseconds:number = 100;
  let rsc:RscGetter = new RscGetter(getContext().resourceManager);
  let viewFirstIndex: String = TimelineTool.formatTimeStampToLocalizedDate(milliseconds, rsc);
  expect(viewFirstIndex).assertEqual(DateUtil.getLocalizedDate(milliseconds));
}

async function TimelineToolTest004() {
  let milliseconds:number = Date.now();
  let rsc:RscGetter = new RscGetter(getContext().resourceManager);
  let viewFirstIndex: String = TimelineTool.formatTimeStampToLocalizedDate(milliseconds, rsc);
  expect(viewFirstIndex).assertEqual(rsc.getString($r('app.string.date_today')));
}

async function TimelineToolTest005() {
  let milliseconds:number = Date.now() - DateUtil.MILLISECONDS_OF_ONE_DAY;
  let rsc:RscGetter = new RscGetter(getContext().resourceManager);
  let viewFirstIndex: String = TimelineTool.formatTimeStampToLocalizedDate(milliseconds, rsc);
  expect(viewFirstIndex).assertEqual(rsc.getString($r('app.string.date_yesterday')));
}
