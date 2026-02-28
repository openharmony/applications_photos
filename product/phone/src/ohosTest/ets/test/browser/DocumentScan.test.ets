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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Component, ON } from '@ohos.UiTest';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Comp } from '@ohos/tools/src/ohosTest/ets/Comp';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { UiComponentId } from '../utils/UiComponentId';

const TAG: string = 'DocumentScanTest';

export default function DocumentScanTest(): void {
  describe('DocumentScanTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAll DocumentScanTest').init();
      dt.log.i('beforeAllDocumentScanTest start');
      await AppStart.photos();
      dt.log.i('beforeAllDocumentScanTest finish');
    });

    it('beforeDocumentScanTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
      await dt.sleep(DELAY.short);
      await dt.assertClick('Album_0');
      await dt.sleep(DELAY.short);
      await dt.assertClick(UiComponentId.PHOTOS_GRID_VIEW_ITEM);
    });
    it('DocumentScanSuccessImage', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanSuccessImage(dt);
    });
    it('DocumentScanSuccessPDF', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanSuccessPDF(dt);
    });
    it('DocumentScanBack', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanBack(dt);
    });

    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDocumentScanTest').init();
      await dt.mustAtBrowser();
      dt.log.i('afterEach DocumentScanTest finish');
    });
    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDocumentScanTest').init();
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await dt.clickTimeline();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await dt.mustAtTimeline();
      dt.log.i('afterAll DocumentScanTest finish');
    });
  });
}

/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanSuccessImage(dt: Dt) {
  dt.log.i('DocumentScanSuccess image start');
  let driver = dt.driver;
  // 测试步骤
  await dt.sleep();

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');

  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');

  let scanAsDocSave = await driver.findComponent(ON.id(UiComponentId.SCANASDOC_SAVE));
  if (scanAsDocSave) {
    //点击保存
    await dt.assertClick(UiComponentId.SCANASDOC_SAVE, true, TestConstants.DELAY_ONE_SECOND);
    dt.log.i('saveIconButton clicked');

    //点击保存图片
    await dt.assertClick(UiComponentId.SAVE_OPTION_PIC, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('save_option_pic clicked');
  }

  await dt.showComponentsWithin();

  dt.log.i('DocumentScanSuccess image end');
}

/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanSuccessPDF(dt: Dt) {
  dt.log.i('DocumentScanSuccess PDF start');
  let driver = dt.driver;
  // 测试步骤
  await dt.sleep();

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');

  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');

  let scanAsDocSave = await driver.findComponent(ON.id(UiComponentId.SCANASDOC_SAVE));
  if (scanAsDocSave) {
    //点击保存
    await dt.assertClick(UiComponentId.SCANASDOC_SAVE, true, TestConstants.DELAY_ONE_SECOND);
    dt.log.i('saveIconButton clicked');

    //点击保存pdf
    await dt.assertClick(UiComponentId.SAVE_OPTION_PDF, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('save_option_pdf clicked');

    //点击确定
    await dt.assertClick(UiComponentId.DIALOG_CONFIRM, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('save_option_pdf clicked');
  }

  await dt.showComponentsWithin();

  dt.log.i('DocumentScanSuccess PDF end');
}

/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanBack(dt: Dt) {
  dt.log.i('DocumentScanBack start');
  // 测试步骤
  await dt.sleep();

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');

  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');

  //点击扫描返回按钮
  await dt.clickIfExist(UiComponentId.SCANASDOC_BACK, TestConstants.DELAY_THREE_SECOND);
  dt.log.i('back_button.build.image clicked');

  await dt.showComponentsWithin();

  dt.log.i('DocumentScanBack end');
}
