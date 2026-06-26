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
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function DemoUi(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('DemoUiTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllDemoUi').init();
      dt.log.i('beforeAll DemoUi start');
      dt.log.i('beforeAll DemoUi finish');
    });
    /**
     * 打开大图
     */
    run('beforeDemoUi', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Specific_PhotoBrowser_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图浏览3072*4096尺寸图片] TID: Multimedia_Gallery_Specific_PhotoBrowser_001
      await Multimedia_Gallery_Specific_PhotoBrowser_001(dt);
    });
    run('Multimedia_Gallery_Specific_PhotoBrowser_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [picker页和三方应用预览3072*4096尺寸大图] TID: Multimedia_Gallery_Specific_PhotoBrowser_002
      await Multimedia_Gallery_Specific_PhotoBrowser_002(dt);
    });
    run('Multimedia_Gallery_Specific_PhotoBrowser_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [3072*4096尺寸图片进入编辑页，观察图片显示] TID: Multimedia_Gallery_Specific_PhotoBrowser_003
      await Multimedia_Gallery_Specific_PhotoBrowser_003(dt);
    });
    run('Multimedia_Gallery_Specific_PhotoBrowser_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [双指捏合缩放浏览3072*4096尺寸图片] TID: Multimedia_Gallery_Specific_PhotoBrowser_004
      await Multimedia_Gallery_Specific_PhotoBrowser_004(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDemoUi').init();
      dt.log.i('afterEach DemoUi start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach DemoUi finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDemoUi').init();
      dt.log.i('afterAll DemoUi start');
      await Exit.browser();
      dt.log.i('afterAll DemoUi finish');
    });
  });
}

// DT步骤
/**
 * 大图-大图: [大图浏览3072*4096尺寸图片]
 * TAG: 192 TID: Multimedia_Gallery_Specific_PhotoBrowser_001
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_001(dt: Dt) {
  dt.log.i('大图浏览3072*4096尺寸图片 start');
  dt.log.i('STEP 1.进入图库，分别在照片页，系统相册：图片、隐藏相册、我的收藏、相机、截屏、录屏相册，自建相册，来源相册：畅连相册、小红书相册，最近删除相册，相机入口进入大图组件，大图预览该3072*4096尺寸照片');

  await dt.sleep();
  dt.log.i('预期结果1.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.连续左右滑动大图预览多张3072*4096尺寸图片');

  await dt.sleep();
  dt.log.i('预期结果2.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.沉浸式大图预览3072*4096尺寸图片');

  await dt.sleep();
  dt.log.i('预期结果3.图片显示正常、右侧无白色竖线');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图浏览3072*4096尺寸图片 end');
}

/**
 * 大图-大图: [picker页和三方应用预览3072*4096尺寸大图]
 * TAG: 188 TID: Multimedia_Gallery_Specific_PhotoBrowser_002
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_002(dt: Dt) {
  dt.log.i('picker页和三方应用预览3072*4096尺寸大图 start');
  dt.log.i('STEP 1.分别从备忘录和畅连应用，选择3072*4096尺寸图片，进行大图预览');

  await dt.sleep();
  dt.log.i('预期结果1.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.使用备忘录完成添加3072*4096尺寸图片后，进行大图预览');

  await dt.sleep();
  dt.log.i('预期结果2.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.使用畅联发送3072*4096尺寸原图后，进行大图预览');

  await dt.sleep();
  dt.log.i('预期结果3.图片显示正常、右侧无白色竖线');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker页和三方应用预览3072*4096尺寸大图 end');
}

/**
 * 大图-大图: [3072*4096尺寸图片进入编辑页，观察图片显示]
 * TAG: 190 TID: Multimedia_Gallery_Specific_PhotoBrowser_003
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_003(dt: Dt) {
  dt.log.i('3072*4096尺寸图片进入编辑页，观察图片显示 start');
  dt.log.i('STEP 1.进入图库，大图预览3072*4096尺寸图片');

  await dt.sleep();
  dt.log.i('预期结果1.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入编辑页面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3072*4096尺寸图片进入编辑页，观察图片显示 end');
}

/**
 * 大图-: [双指捏合缩放浏览3072*4096尺寸图片]
 * TAG: 191 TID: Multimedia_Gallery_Specific_PhotoBrowser_004
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_004(dt: Dt) {
  dt.log.i('双指捏合缩放浏览3072*4096尺寸图片 start');
  dt.log.i('STEP 1.进入图库，双指捏合缩放浏览3072*4096尺寸图片');

  await dt.sleep();
  dt.log.i('预期结果1.图片显示正常、右侧无白色竖线');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('双指捏合缩放浏览3072*4096尺寸图片 end');
}

