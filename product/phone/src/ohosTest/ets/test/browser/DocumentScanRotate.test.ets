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

const TAG: string = 'DocumentScanRotateTest';

export default function DocumentScanRotateTest(): void {
  describe('DocumentScanRotateTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllDocumentScanRotateTest').init();
      dt.log.i('beforeAllDocumentScanRotateTest start');
      await AppStart.photos();
      dt.log.i('beforeAllDocumentScanRotateTest finish');
    });

    it('beforeDocumentScanRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
      await dt.sleep(DELAY.short);
      await dt.assertClick('Album_0');
      await dt.sleep(DELAY.short);
      await dt.assertClick(UiComponentId.PHOTOS_GRID_VIEW_ITEM);
    }, {
      rotate: true,
    });
    it('DocumentScanRotateSuccessImage', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanRotateSuccessImage(dt);
    }, {
      rotate: true,
    });
    it('DocumentScanRotateSuccessPDF', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanRotateSuccessPDF(dt);
    }, {
      rotate: true,
    });
    it('DocumentScanRotateBack', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DocumentScanRotateBack(dt);
    }, {
      rotate: true,
    });

    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDocumentScanRotateTest').init();
      await dt.mustAtBrowser();
      dt.log.i('afterEach DocumentScanRotateTest finish');
    });
    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDocumentScanRotateTest').init();
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await dt.clickTimeline();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await dt.mustAtTimeline();
      dt.log.i('afterAll DocumentScanRotateTest finish');
    });
  });
}

/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanRotateSuccessImage(dt: Dt) {
  dt.log.i('DocumentScanRotateSuccess start');
  // 测试步骤


  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');
  await dt.sleep(DELAY.short);
  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');
  await dt.sleep(DELAY.short);
  let scanAsDocSave = await dt.driver.findComponent(ON.id(UiComponentId.SCANASDOC_SAVE));
  if (scanAsDocSave) {
    //点击保存
    await dt.assertClick(UiComponentId.SCANASDOC_SAVE, true, TestConstants.DELAY_ONE_SECOND);
    dt.log.i('saveIconButton clicked');

    //点击保存图片
    await dt.assertClick(UiComponentId.SAVE_OPTION_PIC, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('save_option_pic clicked');
  }


  dt.log.i('DocumentScanRotateSuccess end');
}

/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanRotateSuccessPDF(dt: Dt) {
  dt.log.i('DocumentScanRotateSuccess PDF start');
  // 测试步骤
  await dt.sleep();

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');

  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');

  let scanAsDocSave = await dt.driver.findComponent(ON.id(UiComponentId.SCANASDOC_SAVE));
  if (scanAsDocSave) {
    //点击保存
    await dt.assertClick(UiComponentId.SCANASDOC_SAVE, true, TestConstants.DELAY_ONE_SECOND);
    dt.log.i('saveIconButton clicked');

    //点击保存pdf
    await dt.assertClick(UiComponentId.SAVE_OPTION_PDF, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('save_option_pdf clicked');

    //点击确定
    await dt.assertClick(UiComponentId.DIALOG_CONFIRM, true, TestConstants.DELAY_THREE_SECOND);
    dt.log.i('dialog_confirm clicked');
  }

  await dt.showComponentsWithin();

  dt.log.i('DocumentScanRotateSuccess PDF end');
}


/**
 * 大图-文档扫描用例: [点击文档扫描]
 * TAG: 文档扫描
 * 前置条件
 * 1、图库预制图片资源
 */
async function DocumentScanRotateBack(dt: Dt) {
  dt.log.i('DocumentScanRotateBack start');
  // 测试步骤
  await dt.sleep();

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');

  //点击扫描为文档按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANASDOC, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_DocumentScan clicked');

  //点击扫描返回按钮
  await dt.clickIfExist('back_button.build.image', TestConstants.DELAY_THREE_SECOND);
  dt.log.i('back_button.build.image clicked');

  await dt.showComponentsWithin();

  dt.log.i('DocumentScanRotateBack end');
}
