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

import { afterAll, afterEach, beforeAll, describe, expect, Level } from '@ohos/hypium';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { ON, WindowMode } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { UiComponentId } from '../utils/UiComponentId';
import { swipeSearch, swipeTo } from '../imageEditor/tools/steps';
import { MatchPattern } from '@kit.TestKit';


const TAG: string = `${TestConstants.TAG}ActionBarButton`;
const RETRIES = 20;
/**
 * action bar测试套
 */
export default function ActionBarButtonTest(): void {
  describe('ActionBarButtonTest', (): void => {
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllActionBarButtonTest').init();
      dt.log.i('beforeAll ActionBarButtonTest start');
      dt.log.i('beforeAll ActionBarButtonTest finish');
    });
    it('beforeActionBarButtonTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('shareTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await shareTest(dt);
    });
    it('favorTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await favorTest(dt);
    });
    // 预置两张云端照片
    it('downloadTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await downloadTest(dt);
    });
    it('shareRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await shareTest(dt);
    }, {
      rotate: true,
    });
    it('favorRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await favorTest(dt);
    }, {
      rotate: true,
    });
    it('ActionBarButtonEditTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await ActionBarButtonEditTest(dt);
    });
    it('ActionBarButtonEditRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await ActionBarButtonEditTest(dt);
    }, {
      rotate: true,
    });
    it('DeleteButtonTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DeleteButtonTest(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachActionBarButtonTest').init();
      dt.log.i('afterEach ActionBarButtonTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      await dt.mustAtBrowser();
      dt.log.i('afterEach ActionBarButtonTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllActionBarButtonTest').init();
      await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
      dt.log.i('返回当前相册');
      await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
      dt.log.i('返回相册页');
      // 回到第一个相册
      await swipeSearch(ON.id("AlumSetContent"),ON.id('Album_0'),'top', RETRIES)
      await dt.assertComponent('Album_0');
      dt.log.i('回到第一个相册');
      dt.log.i('afterAll ActionBarButtonTest finish');
    });
  });
}

// 分享-返回
async function shareTest(dt: Dt) {
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(dt.button.share(), true, DELAY.default);
  await dt.keyBack();
  Log.info(TAG, 'pressBack');
}

/**
 *
 * 1、确保收藏对象存在并点击
 * 2、点击返回
 * 3、点击第三张图片
 * 4、点击取消收藏
 */
async function favorTest(dt: Dt) {
  // 收藏
  await dt.sleep();
  await dt.assertClick(dt.button.favor(), true, DELAY.short);
  dt.log.i('toolBarButtonFavor clicked');
  await dt.assertClick(dt.button.favor(), true, DELAY.short);
  dt.log.i('toolBarButtonUnfavor clicked');
  await dt.assertClick(dt.button.favor());
  await dt.assertClick(dt.button.favor(), true, 0x4);
  await dt.assertClick(dt.button.favor(), true, 0x2);
  await dt.assertClick(dt.button.favor(), true, 0x1);
  await dt.assertClick(dt.button.favor(), true, 0x0);
}

// 编辑-返回
async function ActionBarButtonEditTest(dt: Dt) {
  await dt.sleep();
  await dt.assertClick(dt.button.edit());
  await dt.sleep(DELAY.double);
  await dt.driver.pressBack();
  await dt.sleep();
}

// 删除-返回
async function DeleteButtonTest(dt: Dt) {
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  await dt.assertClick(dt.button.delete());
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  Log.info(TAG, 'pressBack');


  // 删除-取消
  await dt.assertClick(dt.button.delete());
  await dt.assertTextClick('取消');
  await remove(dt);
  await dt.sleep(DELAY.short);
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  await dt.assertClick(UiComponentId.TAB_ALBUMS);
  await dt.sleep(DELAY.double);
  await swipeSearch(ON.id("AlumSetContent"),ON.text('最近删除'),'bottom', RETRIES)
  await dt.clickIfExistByText('最近删除');
  await dt.assertClick('photoGridView_gird_0');
  let recover = await dt.driver.findComponent(ON.id('Recover',MatchPattern.ENDS_WITH));
  if(recover){
    dt.log.i("recover button found")
  }
  await recover.click();
  await dt.sleep(DELAY.short);
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.sleep(DELAY.short);
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回相册页');
  await dt.sleep(DELAY.short);
  // 回到第一个相册
  await swipeSearch(ON.id("AlumSetContent"),ON.id('Album_0'),'top', RETRIES)
  await dt.assertComponent('Album_0');
  await swipeSearch(ON.id("AlumSetContent"),ON.text('ai pic'),'bottom', RETRIES)
  await dt.clickIfExistByText("ai pic");
  await dt.sleep(DELAY.short);
  await dt.assertClick('photoGridView_gird_0');
  Log.info(TAG, 'ActionBarButtonTest_03 end.');
}

/**
 * 删除-确定
 * @param driver
 */
async function remove(dt: Dt) {
  await dt.assertClick(dt.button.delete());
  await dt.assertTextClick('删除');
}

/**
 * ai pic相册中预置两张以上的云端照片，位于前十张照片中
 */

async function downloadTest(dt: Dt) {
  dt.log.i('#############downloadTest start##################');
  await dt.clickIfExist('More_Image_Back');
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  await dt.clickIfExist('TabAlbums');
  await swipeSearch(ON.id("AlumSetContent"),ON.id('Album_0'),'top', RETRIES)
  await dt.assertComponent('Album_0');
  await swipeSearch(ON.id("AlumSetContent"),ON.text('ai pic'),'bottom', RETRIES)
  await swipeTo(ON.id("AlumSetContent"), { dx: 0, dy: -50 });
  dt.log.i('依赖有轮廓的主体图片, 放在相册"ai pic"');
  await dt.clickIfExistByText("ai pic");
  await dt.assertClick('photoGridView_gird_0');

  for (let index = 0; index < 10; index++) {
    let browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
    if (!browserDate) {
      await dt.driver.click(700, 500);
      await dt.sleep();
    }
    await dt.sleep(DELAY.default);
    let btndownload = await dt.driver.findComponent(ON.id(dt.button.download()));
    if (btndownload) {
      break;
    } else if (index === 9) {
      dt.log.e('无云图');
      dt.log.i('#############downloadTest end##################');
      return;
    }
    await dt.swipeScreen?.left();
  }

  dt.log.i('click download button');
  await dt.assertClick(dt.button.download());
  await dt.sleep(DELAY.long);
  const download = await dt.driver.findComponent(ON.id(dt.button.download()));
  expect(Boolean(download)).assertFalse();
  Log.info(TAG, 'press download succeed.');
  await dt.driver.delayMs(DELAY.double);
  await dt.wait();
  Log.info(TAG, 'pressBack');
  dt.log.i('#############downloadTest end##################');
}
