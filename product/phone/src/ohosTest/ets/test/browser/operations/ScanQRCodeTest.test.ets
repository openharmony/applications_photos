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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { UiComponentId } from '../../utils/UiComponentId';
import { ON } from '@ohos.UiTest';
import { swipeSearch } from '../../imageEditor/tools/steps';

const TAG: string = 'ScanQRCodeTest';

export default function ScanQRCodeTest(): void {
  describe('ScanQRCodeTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllScanQRCodeTest').init();
      dt.log.i('beforeAllScanQRCodeTest start');
      await AppStart.photos();
      dt.log.i('beforeAllScanQRCodeTest finish');
    });

    it('beforeScanQRCodeTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
      await dt.sleep(DELAY.short);
      await swipeSearch(ON.id("AlumSetContent"), ON.text('二维码'), 'bottom');
      await dt.sleep(DELAY.short);
      await dt.assertTextClick('二维码');
      await dt.sleep(DELAY.short);
      await dt.assertClick(UiComponentId.PHOTOS_GRID_VIEW_ITEM);
    });
    it('ScanQRCodeImage', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.videoRecordStart();
      await ScanQRCodeImage(dt);
    });
    it('ScanQRCodeBurst', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await ScanQRCodeBurst(dt);
    });
    it('ScanQRCodeMovingPhoto', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await ScanQRCodeMovingPhoto(dt);
      await dt.videoRecordEnd();
    });

    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachScanQRCodeTest').init();
      await dt.mustAtBrowser();
      dt.log.i('afterEach ScanQRCodeTest finish');
    });
    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllScanQRCodeTest').init();
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.pressBack();
      await dt.wait();
      await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await dt.clickIfExist('TabPhotos');
      await dt.sleep(DELAY.default);
      await dt.mustAtTimeline();
      dt.log.i('afterAll ScanQRCodeTest finish');
    });
  });
}

/*
 * 大图-图片，扫描图中二维码
 */
async function ScanQRCodeImage(dt:Dt) {
  dt.log.i('ScanQRCodeImage start');
  // 测试步骤

  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');
  await dt.sleep(DELAY.short);
  //点击识别图中二维码
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANQRCODE, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_Scan_QRCode clicked');
  await dt.sleep(DELAY.double);
  await dt.clickIfExist('Paf.Permission.button_confirm');
  await dt.sleep(DELAY.default);
  await dt.clickIfExistByText('允许');
  await dt.sleep(DELAY.double);
  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.mustAtBrowser();

  dt.log.i('ScanQRCodeImage end');
}

/*
 * 大图-连拍图，扫描图中二维码
 */
async function ScanQRCodeBurst(dt:Dt) {
  dt.log.i('ScanQRCodeBurst start');
  // 测试步骤

  // 向左滑动切换下一张图
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.default);
  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');
  await dt.sleep(DELAY.short);
  //点击识别图中二维码
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANQRCODE, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_Scan_QRCode clicked');
  await dt.sleep(DELAY.long);

  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.mustAtBrowser();

  dt.log.i('ScanQRCodeBurst end');
}

/*
 * 大图-动态照片，扫描图中二维码
 */
async function ScanQRCodeMovingPhoto(dt:Dt) {
  dt.log.i('ScanQRCodeMovingPhoto start');
  // 测试步骤

  // 向左滑动切换下一张图
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.default);
  //点击更多按钮
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE, true, TestConstants.DELAY_ONE_SECOND);
  dt.log.i('the More_Image_More clicked');
  await dt.sleep(DELAY.short);
  //点击识别图中二维码
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE_SCANQRCODE, true, TestConstants.DELAY_FIVE_SECOND);
  dt.log.i('ActionBarButton_Text_Scan_QRCode clicked');
  await dt.sleep(DELAY.long);

  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.pressBack();
  await dt.sleep(DELAY.double);
  await dt.mustAtBrowser();

  dt.log.i('ScanQRCodeMovingPhoto end');
}
