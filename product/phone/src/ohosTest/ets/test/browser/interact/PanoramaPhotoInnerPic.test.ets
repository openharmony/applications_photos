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
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { UiComponentId } from '../../utils/UiComponentId';
import { ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { swipeSearch } from '../../imageEditor/tools/steps';

export default function PanoramaPhotoInnerPic(): void {
  describe('PanoramaPhotoInnerPic', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPanoramaPhotoInnerPic').init();
      dt.log.i('beforeAll PanoramaPhotoInnerPic start');
      dt.log.i('beforeAll PanoramaPhotoInnerPic finish');
    });

    it('beforePanoramaPhotoInnerPic', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
      await dt.sleep(DELAY.short);
      await swipeSearch(ON.id("AlumSetContent"), ON.text('panorama pic'), 'bottom');
      await dt.sleep(DELAY.short);
      dt.log.i('全景照片图片, 放在相册"panorama pic"');
      await dt.assertTextClick('panorama pic');
    });

    it('PanoramaPhotoInnerPic', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await PanoramaPhotoInnerPicTest(dt);
    });

    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPanoramaPhotoInnerPic').init();
      await Exit.browser();
      dt.log.i('afterAll PhotoProperties finish');
    });
  });
}

/**
 * 全景照片双击进入画中画模式
 * 预制条件:
 * 有全景图片的相册, 放在相册"panorama pic"
 * @param dt
 */
async function PanoramaPhotoInnerPicTest(dt: Dt) {
  dt.log.i('click the first image on the grid page');
  await dt.clickIfExist('photoGridView_gird_0');

  dt.log.i('double click photo');
  await dt.assertDoubleClickById(UiComponentId.PHOTOS_BROWSER_INFO_FOCUS_COLUMN)
  await dt.driver.delayMs(TestConstants.DELAY_HALF_SECOND);

  dt.log.i('check the ImageToolComponent comp id');
  await dt.assertComponent('ImageToolComponent');

  dt.log.i('image doubleClick exit preview');
  await dt.assertDoubleClickById(UiComponentId.PHOTOS_BROWSER_INFO_FOCUS_COLUMN)
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  dt.log.i('photo clicked exit preview');
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_INFO_FOCUS_COLUMN);
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);

  dt.log.i('click photo browser back');
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);

  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);

  dt.log.i('返回相册页');
}
