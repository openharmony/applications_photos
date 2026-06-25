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
import { UiComponentId } from '../utils/UiComponentId';
import { swipeSearch } from '../imageEditor/tools/steps';
import { ON } from '@ohos.UiTest';

const RETRIES = 20;

export default function PhotoPropertiesTest(): void {
  describe('PhotoPropertiesTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPhotoPropertiesTest').init();
      dt.log.i('beforeAll PhotoPropertiesTest start');
      dt.log.i('beforeAll PhotoPropertiesTest finish');
    });

    it('allPhotoProperties', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.albumList();
    });

    it('dragonFruitProperties', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dragonFruitPropertiesTest(dt);
    });

    it('xMageStyleProperties', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await xMagePropertiesTest(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterPhotoPropertiesTest').init();
      // 执行单个用例完成之后, 保持在相册页面
      dt.log.i('afterEach PhotoPropertiesTest');
      await dt.sleep();
      await dt.assertComponent('TabAlbums', true);
      dt.log.i('afterEach PhotoPropertiesTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotoPropertiesTest').init();
      await Exit.browser();
      dt.log.i('afterAll PhotoProperties finish');
    });
  });
}

/**
 * XXX大图详情
 * 预制条件:
 * 有XXX图片的相册, 放在相册"dragon fruit pic"
 * @param dt
 */
async function dragonFruitPropertiesTest(dt: Dt) {
  dt.log.i('有XXX图片的相册, 放在相册"dragon fruit pic"');
  await swipeSearch(ON.id("AlumSetContent"),ON.text('dragon fruit pic'),'bottom', RETRIES)
  await dt.assertTextClick('dragon fruit pic');
  dt.log.i('click the first image on the grid page');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('pull up the properties');
  await dt.swipeScreen?.top();
  dt.log.i('check the DragonFruitInfo comp id');
  await dt.assertComponent('DragonFruitInfo');
  dt.log.i('click photo to exit properties');
  await dt.clickIfExist('browserFocusColumn');
  dt.log.i('click photo browser back');
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
  // 回到第一个相册
  await swipeSearch(ON.id("AlumSetContent"),ON.id('Album_0'),'top', RETRIES)
  await dt.assertComponent('Album_0');
  dt.log.i('回到第一个相册');
}

/**
 * xMAGE风格大图详情
 * 预制条件:
 * 有xMAGE风格图片的相册, 放在相册"xMAGE pic"
 * @param dt
 */
async function xMagePropertiesTest(dt: Dt) {
  dt.log.i('有xMAGE风格图片的相册, 放在相册"xMage pic"');
  await swipeSearch(ON.id("AlumSetContent"),ON.text('xMage pic'),'bottom', RETRIES)
  await dt.assertTextClick('xMage pic');
  dt.log.i('click the first image on the grid page');
  await dt.clickIfExist('photoGridView_gird_0');
  dt.log.i('pull up the properties');
  await dt.swipeScreen?.top();
  dt.log.i('check the DragonFruitInfo comp id');
  await dt.assertComponent('XMageColorMode');
  dt.log.i('click photo to exit properties');
  await dt.clickIfExist('browserFocusColumn');
  dt.log.i('click photo browser back');
  await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('返回当前相册');
  await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
  dt.log.i('返回相册页');
}
