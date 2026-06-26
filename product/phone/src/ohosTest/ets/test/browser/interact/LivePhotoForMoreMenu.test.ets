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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { UiComponentId } from '../../utils/UiComponentId';
import { ON } from '@ohos.UiTest';

const TAG: string = `${TestConstants.TAG}LivePhotoForMoreMenu`;

export default function LivePhotoForMoreMenu(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('LivePhotoForMoreMenuTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllLivePhotoForMoreMenu').init();
      dt.log.i('beforeAll LivePhotoForMoreMenu start');
      await AppStart.photos();
      dt.log.i('beforeAll LivePhotoForMoreMenu finish');
    });
    /**
     * 打开大图
     */
    it('beforeLivePhotoForMoreMenu', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    it('Bigdata_Photo_start_052', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换] TID: Bigdata_Photo_start_052
      await Bigdata_Photo_start_052(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachLivePhotoForMoreMenu').init();
      dt.log.i('afterEach LivePhotoForMoreMenu start');
      await dt.sleep(DELAY.short);
      await dt.assertComponent('photoItem_Column');
      dt.log.i('afterEach LivePhotoForMoreMenu finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLivePhotoForMoreMenu').init();
      dt.log.i('afterAll LivePhotoForMoreMenu start');
      await Exit.browser();
      dt.log.i('afterAll LivePhotoForMoreMenu finish');
    });
  });
}

/**
 * 大图-动态照片: [动态照片效果切换]
 * GROUP: 大图 MODULE: 动态照片TID: Bigdata_Photo_start_052
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function Bigdata_Photo_start_052(dt: Dt) {
  dt.log.i('动态照片效果切换 start');
  dt.log.i('STEP 1、拍摄一张动态照片');
  await dt.cameraShoot(); //进入相机，进入拍照模式
  await dt.sleep(DELAY.short);
  let LiveButton = await dt.driver.findComponent(ON.id("TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE")); //打开动图按钮
  if (LiveButton) {
    await LiveButton.click();
    await dt.sleep();
  }
  await dt.clickIfExist("COMPONENT_ID_SHUTTER_PHOTO_1"); //点击拍照按钮
  await dt.sleep(DELAY.short);
  await dt.pressBack();
  //返回图库
  await dt.sleep();
  await dt.swipeScreen?.right();
  await dt.loopUntil('ToolBarButtonMotionPicture', async () => {
    await dt.swipeScreen?.left();
    await dt.sleep(DELAY.long);
  }, 50);

  dt.log.i('预期结果1、四种动态照片效果切换正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库，点击进入动态照片');

  dt.log.i('STEP 3、动态照片效果切换为循环播放');
  await dt.sleep(DELAY.long);
  await dt.assertClick('ToolBarButtonMotionPicture');
  await dt.sleep(DELAY.double);
  await dt.clickIfExistByText('循环播放')

  dt.log.i('STEP 4、动态照片效果切换为主角时刻');
  await dt.sleep(DELAY.long);
  await dt.assertClick('ToolBarButtonLoopPlay');
  await dt.sleep(DELAY.double);
  await dt.clickIfExistByText('主角时刻')

  dt.log.i('STEP 5、动态照片效果切换为运动轨迹');
  await dt.sleep(DELAY.long);
  await dt.assertClick('ToolBarButtonLongExposure');
  await dt.sleep(DELAY.double);
  await dt.clickIfExistByText('运动轨迹')

  dt.log.i('STEP 6、动态照片效果切换为动态照片');
  await dt.sleep(DELAY.long);
  await dt.assertClick('ToolBarButtonMultiExposure');
  await dt.sleep(DELAY.double);
  await dt.clickIfExistByText('动态照片')

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.sleep(DELAY.long);
  await dt.assertComponent('ToolBarButtonMotionPicture');
  dt.log.i('动态照片效果切换 end');
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_DELETE, true);
  await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND, true);
}
