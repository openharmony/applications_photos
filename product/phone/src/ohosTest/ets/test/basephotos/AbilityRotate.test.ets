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
import { describe, beforeAll, afterAll } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver,UiDirection, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Comp } from '@ohos/tools/src/ohosTest/ets/Comp';
import { UiComponentId } from '../utils/UiComponentId';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';

const TAG: string = `${TestConstants.TAG}AbilityRotateTest`;

export default function abilityRotateTest(): void {
  describe('ActsAbilityRotateTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllActsAbilityRotateTest').init();
      dt.log.i('beforeAll ActsAbilityRotateTest start');
      dt.log.i('beforeAll ActsAbilityRotateTest finish');
    });

    /**
     * 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllActsAbilityRotateTest').init();
      dt.log.i('afterAll ActsAbilityRotateTest start');
      await dt.albumList();
      dt.log.i('afterAll ActsAbilityRotateTest finish');
    });

    it('Ability_StartPhoto_Test', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AbilityRotateTest01(dt);
    }, {
      rotate: true,
    });

    it('Ability_Add_Album_Rotate_Test', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AbilityRotateTest02(dt);
    }, {
      rotate: true,
    });

    it('Ability_CloudAccount_Rotate_Test', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await AbilityRotateTest03(dt);
    }, {
      rotate: true,
    });

    it('Ability_ScreenRecorder_Rotate_Test', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await AbilityScreenRecorderRotateTest(dt);
    }, {
      rotate: true,
    });
  });

}

/**
 * 跳过引导页进入图库首页
 */
async function AbilityRotateTest01(dt: Dt) {
  Log.info(TAG, 'Task_001_StartPhoto_Test01 starts ');
  await dt.skipBootPage();
  await dt.tabAlbums();
  Log.info(TAG, 'Task_001_StartPhoto_Test01 end');
}

/**
 * 1、点击相册 TabAlbums
 * 2、新建相册
 * 3、确认
 * 4、选择默认图片
 * 5、选择第1、2、3、4张图片
 * 6、点击确认
 * 7、点击返回
 */
async function AbilityRotateTest02(dt: Dt) {
  dt.log.i('AbilityRotateTest02 start');
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.tabAlbums();
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.swipeScreen?.bottom();
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.swipeScreen?.bottom();
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.assertClick(UiComponentId.GRID_NEW_ALBUM);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  // 键盘可能遮挡弹窗按钮，收起键盘
  await dt.clickIfExist(UiComponentId.KEYBOARD_HIDE_BUTTON, TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.pressBack();
  dt.log.i('AbilityRotateTest02 end');
}

/**
 * 端云账号：点击设置页查看账号详情
 */
async function AbilityRotateTest03(dt: Dt) {
  dt.log.i('AbilityRotateTest03 start');
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.tabAlbums();
  let driver = dt.driver;
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(UiComponentId.GRID_ACTION_MORE);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('moreButton clicked');
  await dt.assertClick(UiComponentId.GRID_MORE_SETTING);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('settingButton clicked');
  await dt.clickIfExistByText("同意");
  await dt.assertClick(UiComponentId.GRID_MORE_SETTING_ACCOUNT);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('account clicked');

  let closeDetailBtn = await driver.findComponent(ON.id('img_hwid_pwd_cancel'));
  if (closeDetailBtn) {
    await closeDetailBtn.click();
  } else {
    const accountTopBar = await (new Comp('row_navigation_title', driver)).init();
    if (accountTopBar) {
      await accountTopBar.horizontal(0.6, 0.7);
    }
    await dt.sleep(TestConstants.DELAY_ONE_SECOND);
    const settingBar = await driver.findComponent(ON.id('singleTitleStack'));
    if (settingBar) {
      await driver.pressBack();
    }
  }

  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('closeDetailBtn clicked');
  await driver.pressBack();
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  dt.log.i('AbilityRotateTest03 end');
}

/*
 * 下滑拉出菜单
 * 进行录屏
 * 录屏完成后删除录屏
 * */
async function AbilityScreenRecorderRotateTest(dt: Dt) {
  Log.info(TAG, 'AbilityScreenRecorderRotateTest start');
  let driver = dt.driver;
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'sleeping:' + TestConstants.DELAY_ONE_SECOND);
  await dt.prepareVideo(TestConstants.DELAY_TWO_SECOND);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.clickIfExist('EnableSyncSplashCancelButton_false');
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await driver.swipe(800, 540, 800, 1200, 800);
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.swipeScreen?.bottomcorner();//唤出底部菜单栏
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(UiComponentId.TAB_ALBUMS);
  await dt.sleep(TestConstants.DELAY_TWO_SECOND);
  await dt.assertClick('Album_1');
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(UiComponentId.PHOTOS_GRID_VIEW_ITEM);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick("PhotoBrowserActionBarButtonDelete");//横屏删除按钮ID
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
  await dt.sleep(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_BACK);
  Log.info(TAG, 'AbilityScreenRecorderRotateTest end');

}
