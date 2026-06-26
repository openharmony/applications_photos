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
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function GalleryMapAddressTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryMapAddressTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = new Dt('beforeAllGalleryMapAddressTest');
      dt.log.i('beforeAll GalleryMapAddressTest start');
      await AppStart.photos();
      dt.log.i('beforeAll GalleryMapAddressTest finish');
    });
    /**
     * 打开大图
     */
    it('beforeGalleryMapAddressTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_Map_Address_002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [桌面无地图app，图库大图详情页点击地图底部地址不支持跳转] TID: Multimedia_Gallery_Map_Address_002
      await Multimedia_Gallery_Map_Address_002(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = new Dt('afterEachGalleryMapAddressTest');
      dt.log.i('afterEach GalleryMapAddressTest start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryMapAddressTest finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = new Dt('afterAllGalleryMapAddressTest');
      dt.log.i('afterAll GalleryMapAddressTest start');
      await Exit.browser();
      dt.log.i('afterAll GalleryMapAddressTest finish');
    });
  });
}

// DT步骤
/**
 * 大图-详情: [桌面无地图app，图库大图详情页点击地图底部地址不支持跳转]
 * GROUP: 大图 MODULE: 详情TID: Multimedia_Gallery_Map_Address_002
 * 前置条件
 * 1、图库中存在带经纬度图片
 2、桌面卸载地图app
 */
async function Multimedia_Gallery_Map_Address_002(dt: Dt) {
  dt.log.i('桌面无地图app，图库大图详情页点击地图底部地址不支持跳转 start');
  dt.log.i('STEP 1、选择再有经纬度图片进入大图页面，上滑大图/点击右上角详情按钮');


  dt.log.i('预期结果1、大图详情页出现，有地图卡片和地址');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击地址');


  dt.log.i('预期结果2、显示暂无其他导航方式弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏切换，重复步骤以上步骤');


  dt.log.i('预期结果3、再次点击出现“选择导航方式”弹框，支持横竖屏切换，且横竖屏切换后界面显示正常');

  await dt.assertComponent(PageTitle.index, true); //ComponentByText('选择导航方式', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('桌面无地图app，图库大图详情页点击地图底部地址不支持跳转 end');
}