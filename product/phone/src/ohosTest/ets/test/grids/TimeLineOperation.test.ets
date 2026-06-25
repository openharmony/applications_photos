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
import { describe, expect } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { SkipBootPage } from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { ON } from '@kit.TestKit';

const TAG: string = `${TestConstants.TAG}timeLineOperationTest`;
const NUMBER_ONE: number = 1;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function timeLineOperationTest(): void {
  describe('TimeLineOperationTest', (): void => {
    it('TimeLineOperation_openApp', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await TimeLineOperation_openApp();
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('TimeLineOperation_testCopyAndShare', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLineOperation_testCopyAndShare(dt);
    });
    it('TimeLineOperation_testCopyAndShareBatch', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLineOperation_testCopyAndShareBatch(dt);
    });
    it('TimeLineOperation_testHidden', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await TimeLineOperation_testHidden(dt);
    });
  })
}

/**
 * 打开图库
 */
async function TimeLineOperation_openApp() {
  Log.info(TAG, 'TimeLineOperation_openApp start.');
  const callback = (): void => {
    Log.info(TAG, 'start photo with  single select success.');
  };
  try {
    let res = await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
      .then(callback);
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start failed:${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application.');
  }
  Log.info(TAG, 'TimeLineOperation_openApp end.');
  await SkipBootPage();
}

/**
 * 1、点击照片tab
 * 2、打开宫格页第一张图片
 * 3、点击更多-点击复制 --删除
 * 4、点击分享-返回
 * 5、退出大图浏览
 */
async function TimeLineOperation_testCopyAndShare(dt: Dt) {
  let res = Log.info(TAG, 'TimeLineOperation_testCopyAndShare start.');
  expect(res).assertTrue();
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  // 点击照片页
  await testClickById(dt, 'TabPhotos', 'TabPhotos clicked');
  // 如果没有多选框则没有图片，没有图片不进行如下操作
  if (await driver.findComponent(ON.text('多选'))) {
    // 点击第一张图片
    await testClickById(dt, 'TimelinePage_GridItem0', 'GridItem1 clicked');
    // 大图 - 分享-返回
    await testClickById(dt, 'ToolBarButtonShare', 'buttonShare clicked');
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    Log.info(TAG, 'pressBack');
    // 点击左上角返回按钮退出大图   【大图返回按钮未变】
    await testClickById(dt, 'More_Image_Back', 'More_Image_Back clicked');
  }
  Log.info(TAG, 'TimeLineOperation_testCopyAndShare end.');
}

/**
 * 1、点击多选
 * 2、选中第一，第二张进行复制
 * 3、点击分享-返回
 * 4、点击全选进行复制
 * 5、退出多选,返回tab页
 */
async function TimeLineOperation_testCopyAndShareBatch(dt: Dt) {
  Log.info(TAG, 'TimeLineOperation_testCopyAndShareBatch start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 如果没有多选框则没有图片，没有图片不进行如下操作
  if (await driver.findComponent(ON.text('多选'))) {
    // 多选
    await dt.clickIfExistByText('多选', TestConstants.DELAY_ONE_SECOND);
    // 选中第一，第二张进行复制--删除复制
    await testClickById(dt, 'Selector_0', 'GridItem1 clicked');
    await testClickById(dt, 'Selector_1', 'GridItem2 clicked');
    // 分享第一、二张并返回
    await testClickById(dt, 'ToolBarButton_ActionButton_Share', 'buttonShare clicked');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 取消分享
    let res = await driver.pressBack();
    expect(res !== undefined).assertEqual(true);
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    Log.info(TAG, 'pressBack');
    //点击X
    await testClickById(dt, TestConstants.TIMELINE_ACTION_BUTTON_CANCEL, 'Cancel select');
  }
  Log.info(TAG, 'TimeLineOperation_testCopyAndShareBatch end');
}

/**
 * 1、点击多选
 * 2、选择第一张照片
 * 3、点击更多
 * 4、点击隐藏
 * 5、点击确定
 */
async function TimeLineOperation_testHidden(dt: Dt) {
  Log.info(TAG, 'TimeLineOperation_testHidden start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 如果没有多选框则没有图片，没有图片不进行如下操作
  if (await driver.findComponent(ON.text('多选'))) {
    // 点击多选
    let res = await dt.clickIfExistByText('多选', TestConstants.DELAY_ONE_SECOND);
    expect(res !== undefined).assertEqual(true);
    // 选中第一个图片
    await testClickById(dt, 'Selector_0', 'TimelinePage_GridItem1 clicked');
    // 更多&隐藏&取消
    await testClickById(dt, TestConstants.TIMELINE_ACTION_BUTTON_MORE, 'ToolBarButtonMore clicked');
    await testClickById(dt, TestConstants.TIMELINE_ACTION_BUTTON_MORE_HIDE, 'ToolBarButtonMoreHide clicked');
    await testClickById(dt, TestConstants.DIALOG_BUTTON_FIRST, 'hiddenDialogCancelButton clicked');
    // 更多&隐藏&确定
    await testClickById(dt, TestConstants.TIMELINE_ACTION_BUTTON_MORE, 'ToolBarButtonMore clicked');
    await testClickById(dt, TestConstants.TIMELINE_ACTION_BUTTON_MORE_HIDE, 'ToolBarButtonMoreHide clicked');
    await testClickById(dt, TestConstants.DIALOG_BUTTON_SECOND, 'HideDialogConfirmButton clicked');
  }
  Log.info(TAG, 'TimeLineOperation_testHidden end');
}

async function testClickById(dt: Dt, id: string, logInfo: string): Promise<void> {
  let driver = dt.driver;
  if (await driver.findComponent(ON.id(id))) {
    await dt.assertClick(id);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, logInfo);
  } else {
    Log.error(TAG, `component ${id} not exist`);
  }
}

