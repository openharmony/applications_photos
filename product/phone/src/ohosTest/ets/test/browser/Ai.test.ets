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
import { Component, ON } from '@ohos.UiTest';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Comp } from '@ohos/tools/src/ohosTest/ets/Comp';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { deletNewAlbums } from '../imageEditor/tools/steps';
import { UiComponentId } from '../utils/UiComponentId';

const PANEL: string = 'panelBackground';

const SHOW_STACK: string = 'id_show_stack';
const MAX_SHOW_PANEL_DURATION: number = 5500;

export default function AiToolsTest(): void {
  describe('AiToolsTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAiToolsTest').init();
      dt.log.i('beforeAll AiToolsTest start');
      dt.log.i('beforeAll AiToolsTest finish');
    });

    run('deletNewAlbums', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
      await dt.loopUntil('never', async () => {
        await deletNewAlbums();
      }, 10);
    });

    run('analyzer', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await analyzerTest(dt);
    });

    run('textAnalyzer', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await textAnalyzerTest(dt);
    });

    run('analyzerTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.sleep(DELAY.enormous);
      await dt.getScreen().left();
      await dt.sleep();
    });

    run('textAnalyzerTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.sleep(DELAY.enormous);
      await dt.getScreen().left();
      await dt.sleep();
    });

    run('analyzerCopyTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await analyzerCopyTest(dt)
    })

    run('analyzerShareTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await analyzerShareTest(dt)
    })

    run('analyzerImageSearchTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await analyzerImageSearchTest(dt)
    })
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachAiToolsTest').init();
      // 执行单个用例完成之后, 保持在相册页面
      dt.log.i('afterEach AiToolsTest');
      await dt.sleep();
      await dt.assertComponent('TabAlbums', true);
      dt.log.i('afterEach AiToolsTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllAiToolsTest').init();
      await Exit.browser();
      dt.log.i('afterAll AiToolsTest finish');
    });
  });
}

async function browserToExactAlbum(dt: Dt, albumName: string) {
  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.clickIfExist('TabAlbums');
  await dt.sleep(DELAY.double);
  await dt.assertTextClick(albumName);
  await dt.clickIfExist('photoGridView_gird_0');
  await dt.sleep(DELAY.double);
}


/**
 * AI抠图失效拦截
 * 预制条件:
 * 依赖有轮廓的主体图片, 放在相册"ai pic"
 * @param dt
 */
async function analyzerTest(dt: Dt) {
  dt.log.i('依赖有轮廓的主体图片, 放在相册"ai pic"');
  await dt.assertTextClick('ai pic');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('移动到指定图片');
  let btnPlay: Component | undefined = await dt.driver.findComponent(ON.id('VideoPlayButton'));
  let btnMoving: Component | undefined = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  while (btnPlay || btnMoving) {
    await dt.swipeScreen?.left();
    btnPlay = await dt.driver.findComponent(ON.id('VideoPlayButton'));
    btnMoving = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
    dt.log.i('swipeToVideo left');
  }

  dt.log.i('获取组件comp对象');
  const focusId = 'browserFocusColumn';
  const focus = await new Comp(focusId, dt.driver).init();
  await dt.sleep(DELAY.double);
  await focus.comp.longClick();
  dt.log.i('longClick');
  await dt.sleep(DELAY.default);
  await dt.assertLongClickById(focusId, DELAY.double);
  dt.log.i('double');
  //退出沉浸模式
  let analyzer_menu = await dt.driver.findComponent(ON.id("image_analyzer_menu_object"));
  if (analyzer_menu) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  let browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
  if (!browserDate) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');


}


/**
 * 提取图片中的文字
 * 预制条件:
 * 依赖证件图片, 放在相册"文字提取"
 * @param dt
 */
async function textAnalyzerTest(dt: Dt) {
  dt.log.i("========= textAnalyzerTest start =============");
  dt.log.i('依赖证件图片, 放在相册"文字提取');
  await dt.assertTextClick('文字提取');
  await dt.clickIfExist('photoGridView_gird_0');
  await dt.sleep();
  await dt.getScreen().left();
  let browserDate: Component | undefined = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));

  let btnGetTxt: Component | undefined = await dt.driver.findComponent(ON.id("imageAnalyzerOverlay_ai"));

  for (let index = 0; index < 6; index++) {
    browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
    if (!browserDate) {
      await dt.driver.click(700, 500);
      await dt.sleep();
    }
    await dt.swipeScreen?.left();
    await dt.sleep(DELAY.long);
    btnGetTxt = await dt.driver.findComponent(ON.id('imageAnalyzerOverlay_ai'));
    if (btnGetTxt) {
      break;
    }
    await dt.swipeScreen?.left();
  }

  if (btnGetTxt) {
    dt.log.i('Text Extraction found. Test Click button x 2');
    await btnGetTxt.click();
    // 再次点击btnGetTxt回到原始界面
    await dt.sleep(DELAY.double);
    await btnGetTxt.click();
    dt.log.i('Test copy-text button');
    await btnGetTxt.click();
    await dt.sleep(DELAY.long);
    await dt.clickIfExist('image_analyzer_a_bubble_button_0');
  } else {
    dt.log.i('imageAnalyzerOverlay_ai botton not found');
  }

  await dt.sleep(DELAY.double);
  await dt.assertComponent('PhotoBrowserPreviewBar', true);
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');

  dt.log.i("************** textAnalyzerTest end *****************");
}


/**
 * 确认多个组件存在
 * @param dt
 */
async function isAiPanelGroupExits(dt: Dt) {
  await dt.assertComponent(PANEL, true);
  await dt.assertComponent('imageSegmentAnalyzerOverlay', true);
  await dt.assertComponent(SHOW_STACK, true);
  await dt.assertComponent('segment image', true);
  await dt.sleep();
}

/**
 * 移动到指定图片
 * @param dt
 */
async function selectLastPhoto(dt: Dt) {
  const compId = 'PhotoBrowserPreviewBar';
  dt.log.i(compId + 'started');
  for (let i = 0; i < 20; i++) {
    await dt.swipeScreen?.left();
  }

  await dt.sleep(5000);
}

/**
 * 测试长按识别物体后三个选项——复制
 * 预制条件:
 * 依赖证件图片, 放在相册"ai pic"
 * @param dt
 */
async function analyzerCopyTest(dt: Dt) {
  dt.log.i("========= analyzerCopyTest start =============");
  dt.log.i('依赖有轮廓的主体图片, 放在相册"ai pic"');
  await dt.assertTextClick('ai pic');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('移动到指定图片');
  let btnPlay: Component | undefined = await dt.driver.findComponent(ON.id('VideoPlayButton'));
  let btnMoving: Component | undefined = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  while (btnPlay || btnMoving) {
    await dt.swipeScreen?.left();
    btnPlay = await dt.driver.findComponent(ON.id('VideoPlayButton'));
    btnMoving = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
    dt.log.i('swipeToVideo left');
  }
  dt.log.i('获取组件comp对象');
  const focusId = 'browserFocusColumn';
  const focus = await new Comp(focusId, dt.driver).init();
  await focus.comp.longClick();
  dt.log.i('longClick');
  await dt.sleep(DELAY.default);
  await dt.assertLongClickById(focusId, DELAY.double);
  dt.log.i('double');
  await dt.assertTextClick('复制');

  //退出沉浸模式
  let analyzer_menu = await dt.driver.findComponent(ON.id("image_analyzer_menu_object"));
  if (analyzer_menu) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  let browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
  if (!browserDate) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  dt.log.i("************** analyzerCopyTest end *****************");

}


async function analyzerShareTest(dt: Dt) {
  dt.log.i("========= analyzerShareTest start =============");
  dt.log.i('依赖有轮廓的主体图片, 放在相册"ai pic"');
  await dt.assertTextClick('ai pic');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('移动到指定图片');
  let btnPlay: Component | undefined = await dt.driver.findComponent(ON.id('VideoPlayButton'));
  let btnMoving: Component | undefined = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  while (btnPlay || btnMoving) {
    await dt.swipeScreen?.left();
    btnPlay = await dt.driver.findComponent(ON.id('VideoPlayButton'));
    btnMoving = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
    dt.log.i('swipeToVideo left');
  }
  dt.log.i('获取组件comp对象');
  const focusId = 'browserFocusColumn';
  const focus = await new Comp(focusId, dt.driver).init();
  await focus.comp.longClick();
  dt.log.i('longClick');
  await dt.sleep(DELAY.default);
  await dt.assertLongClickById(focusId, DELAY.double);
  dt.log.i('double');
  await dt.assertTextClick('分享');
  await dt.sleep(DELAY.default);
  await dt.assertComponent('share_card', true);
  await dt.pressBack();
  await dt.sleep(DELAY.default);
  //退出沉浸模式
  let analyzer_menu = await dt.driver.findComponent(ON.id("image_analyzer_menu_object"));
  if (analyzer_menu) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  let browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
  if (!browserDate) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  dt.log.i("************** analyzerShareTest end *****************");

}

async function analyzerImageSearchTest(dt: Dt) {
  dt.log.i("========= analyzerImageSearchTest start =============");
  dt.log.i('依赖有轮廓的主体图片, 放在相册"ai pic"');
  await dt.assertTextClick('ai pic');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('移动到指定图片');
  let btnPlay: Component | undefined = await dt.driver.findComponent(ON.id('VideoPlayButton'));
  let btnMoving: Component | undefined = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  while (btnPlay || btnMoving) {
    await dt.swipeScreen?.left();
    btnPlay = await dt.driver.findComponent(ON.id('VideoPlayButton'));
    btnMoving = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
    dt.log.i('swipeToVideo left');
  }
  dt.log.i('获取组件comp对象');
  const focusId = 'browserFocusColumn';
  const focus = await new Comp(focusId, dt.driver).init();
  await focus.comp.longClick();
  dt.log.i('longClick');
  await dt.sleep(DELAY.default);
  await dt.assertLongClickById(focusId, DELAY.double);
  dt.log.i('double');
  await dt.clickIfExistByText('识图搜索');
  await dt.sleep(DELAY.default);
  await dt.assertComponent('objectResultpage', true);
  await dt.pressBack();
  await dt.sleep(DELAY.default);
  //退出沉浸模式
  let analyzer_menu = await dt.driver.findComponent(ON.id("image_analyzer_menu_object"));
  if (analyzer_menu) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  let browserDate = await dt.driver.findComponent(ON.id("PhotoBrowserDateTitle"));
  if (!browserDate) {
    await dt.clickIfExist('browserFocusColumn');
    await dt.sleep();
  }
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  dt.log.i("************** analyzerImageSearchTest end *****************");

}