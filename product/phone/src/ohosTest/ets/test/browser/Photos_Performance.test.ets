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

export default function PhotosPerformanceTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('PhotosPerformanceTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPhotosPerformance').init();
      dt.log.i('beforeAll PhotosPerformance start');
      dt.log.i('beforeAll PhotosPerformance finish');
    });
    /**
     * 打开大图
     */
    run('beforePhotosPerformance', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    run('Multimedia_Photos_Performance_Case001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [冷启动进入照片页] TID: Multimedia_Photos_Performance_Case001
      await Multimedia_Photos_Performance_Case001(dt);
    });
    run('Multimedia_Photos_Performance_Case002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [热启动进入照片页] TID: Multimedia_Photos_Performance_Case002
      await Multimedia_Photos_Performance_Case002(dt);
    });
    run('Multimedia_Photos_Performance_Case003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [冷启动进入相册页] TID: Multimedia_Photos_Performance_Case003
      await Multimedia_Photos_Performance_Case003(dt);
    });
    run('Multimedia_Photos_Performance_Case004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [热启动进入相册页] TID: Multimedia_Photos_Performance_Case004
      await Multimedia_Photos_Performance_Case004(dt);
    });
    run('Multimedia_Photos_Performance_Case005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [图库侧滑退出] TID: Multimedia_Photos_Performance_Case005
      await Multimedia_Photos_Performance_Case005(dt);
    });
    run('Multimedia_Photos_Performance_Case006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [图库上滑退出] TID: Multimedia_Photos_Performance_Case006
      await Multimedia_Photos_Performance_Case006(dt);
    });
    run('Multimedia_Photos_Performance_Case007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-进入大图用例: [照片页宫格进入大图] TID: Multimedia_Photos_Performance_Case007
      await Multimedia_Photos_Performance_Case007(dt);
    });
    run('Multimedia_Photos_Performance_Case008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-进入大图用例: [相册内宫格进入大图] TID: Multimedia_Photos_Performance_Case008
      await Multimedia_Photos_Performance_Case008(dt);
    });
    run('Multimedia_Photos_Performance_Case009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-竖屏用例: [照片页大图左右滑动（竖屏）] TID: Multimedia_Photos_Performance_Case009
      await Multimedia_Photos_Performance_Case009(dt);
    });
    run('Multimedia_Photos_Performance_Case010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [照片页大图左右滑动（横屏）] TID: Multimedia_Photos_Performance_Case010
      await Multimedia_Photos_Performance_Case010(dt);
    });
    run('Multimedia_Photos_Performance_Case011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-大图用例: [照片页大图下拉返回] TID: Multimedia_Photos_Performance_Case011
      await Multimedia_Photos_Performance_Case011(dt);
    });
    run('Multimedia_Photos_Performance_Case012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-大图用例: [照片页大图侧滑返回] TID: Multimedia_Photos_Performance_Case012
      await Multimedia_Photos_Performance_Case012(dt);
    });
    run('Multimedia_Photos_Performance_Case013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [照片页宫格手势滑动（日视图）] TID: Multimedia_Photos_Performance_Case013
      await Multimedia_Photos_Performance_Case013(dt);
    });
    run('Multimedia_Photos_Performance_Case014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [照片页宫格手势滑动（月视图）] TID: Multimedia_Photos_Performance_Case014
      await Multimedia_Photos_Performance_Case014(dt);
    });
    run('Multimedia_Photos_Performance_Case015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [照片页宫格手势滑动（年视图）] TID: Multimedia_Photos_Performance_Case015
      await Multimedia_Photos_Performance_Case015(dt);
    });
    run('Multimedia_Photos_Performance_Case016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [进入相册宫格] TID: Multimedia_Photos_Performance_Case016
      await Multimedia_Photos_Performance_Case016(dt);
    });
    run('Multimedia_Photos_Performance_Case017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [相册宫格上下快滑] TID: Multimedia_Photos_Performance_Case017
      await Multimedia_Photos_Performance_Case017(dt);
    });
    run('Multimedia_Photos_Performance_Case018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [宫格侧滑返回相册] TID: Multimedia_Photos_Performance_Case018
      await Multimedia_Photos_Performance_Case018(dt);
    });
    run('Multimedia_Photos_Performance_Case019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-视频用例: [视频相册宫格点击进入视频大图] TID: Multimedia_Photos_Performance_Case019
      await Multimedia_Photos_Performance_Case019(dt);
    });
    run('Multimedia_Photos_Performance_Case020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-视频用例: [视频点击播放（本地）] TID: Multimedia_Photos_Performance_Case020
      await Multimedia_Photos_Performance_Case020(dt);
    });
    run('Multimedia_Photos_Performance_Case021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-视频用例: [视频大图下拉返回宫格] TID: Multimedia_Photos_Performance_Case021
      await Multimedia_Photos_Performance_Case021(dt);
    });
    run('Multimedia_Photos_Performance_Case022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-删除用例: [图库大图删除] TID: Multimedia_Photos_Performance_Case022
      await Multimedia_Photos_Performance_Case022(dt);
    });
    run('Multimedia_Photos_Performance_Case023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-删除用例: [图库宫格删除] TID: Multimedia_Photos_Performance_Case023
      await Multimedia_Photos_Performance_Case023(dt);
    });
    run('Multimedia_Photos_Performance_Case024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-删除用例: [图库视频删除] TID: Multimedia_Photos_Performance_Case024
      await Multimedia_Photos_Performance_Case024(dt);
    });
    run('Multimedia_Photos_Performance_Case025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-删除用例: [相机连续拍照后查看图片删除] TID: Multimedia_Photos_Performance_Case025
      await Multimedia_Photos_Performance_Case025(dt);
    });
    run('Multimedia_Photos_Performance_Case026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [分享一张图片] TID: Multimedia_Photos_Performance_Case026
      await Multimedia_Photos_Performance_Case026(dt);
    });
    run('Multimedia_Photos_Performance_Case027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [添加至相册] TID: Multimedia_Photos_Performance_Case027
      await Multimedia_Photos_Performance_Case027(dt);
    });
    run('Multimedia_Photos_Performance_Case028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [隐藏一张图片] TID: Multimedia_Photos_Performance_Case028
      await Multimedia_Photos_Performance_Case028(dt);
    });
    run('Multimedia_Photos_Performance_Case029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-用例: [编辑一张图片] TID: Multimedia_Photos_Performance_Case029
      await Multimedia_Photos_Performance_Case029(dt);
    });
    run('Multimedia_Photos_Performance_Case030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-大图用例: [图片编辑返回大图] TID: Multimedia_Photos_Performance_Case030
      await Multimedia_Photos_Performance_Case030(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPhotosPerformance').init();
      dt.log.i('afterEach PhotosPerformance start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach PhotosPerformance finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotosPerformance').init();
      dt.log.i('afterAll PhotosPerformance start');
      await Exit.browser();
      dt.log.i('afterAll PhotosPerformance finish');
    });
  });
}

/**
 * 性能-: [冷启动进入照片页]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case001
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case001(dt: Dt) {
  dt.log.i('冷启动进入照片页 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('冷启动进入照片页 end');
}

/**
 * 性能-: [热启动进入照片页]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case002
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case002(dt: Dt) {
  dt.log.i('热启动进入照片页 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('热启动进入照片页 end');
}

/**
 * 性能-: [冷启动进入相册页]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case003
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case003(dt: Dt) {
  dt.log.i('冷启动进入相册页 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('冷启动进入相册页 end');
}

/**
 * 性能-: [热启动进入相册页]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case004
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case004(dt: Dt) {
  dt.log.i('热启动进入相册页 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('热启动进入相册页 end');
}

/**
 * 性能-: [图库侧滑退出]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case005
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case005(dt: Dt) {
  dt.log.i('图库侧滑退出 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库侧滑退出 end');
}

/**
 * 性能-: [图库上滑退出]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case006
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case006(dt: Dt) {
  dt.log.i('图库上滑退出 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库上滑退出 end');
}

/**
 * 性能-进入大图: [照片页宫格进入大图]
 * GROUP: 性能 MODULE: 进入大图TID: Multimedia_Photos_Performance_Case007
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case007(dt: Dt) {
  dt.log.i('照片页宫格进入大图 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格进入大图 end');
}

/**
 * 性能-进入大图: [相册内宫格进入大图]
 * GROUP: 性能 MODULE: 进入大图TID: Multimedia_Photos_Performance_Case008
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case008(dt: Dt) {
  dt.log.i('相册内宫格进入大图 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册内宫格进入大图 end');
}

/**
 * 性能-竖屏: [照片页大图左右滑动（竖屏）]
 * GROUP: 性能 MODULE: 竖屏TID: Multimedia_Photos_Performance_Case009
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case009(dt: Dt) {
  dt.log.i('照片页大图左右滑动（竖屏） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页大图左右滑动（竖屏） end');
}

/**
 * 性能-滑动: [照片页大图左右滑动（横屏）]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Performance_Case010
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case010(dt: Dt) {
  dt.log.i('照片页大图左右滑动（横屏） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页大图左右滑动（横屏） end');
}

/**
 * 性能-大图: [照片页大图下拉返回]
 * GROUP: 性能 MODULE: 大图TID: Multimedia_Photos_Performance_Case011
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case011(dt: Dt) {
  dt.log.i('照片页大图下拉返回 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页大图下拉返回 end');
}

/**
 * 性能-大图: [照片页大图侧滑返回]
 * GROUP: 性能 MODULE: 大图TID: Multimedia_Photos_Performance_Case012
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case012(dt: Dt) {
  dt.log.i('照片页大图侧滑返回 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页大图侧滑返回 end');
}

/**
 * 性能-滑动: [照片页宫格手势滑动（日视图）]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Performance_Case013
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case013(dt: Dt) {
  dt.log.i('照片页宫格手势滑动（日视图） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格手势滑动（日视图） end');
}

/**
 * 性能-滑动: [照片页宫格手势滑动（月视图）]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Performance_Case014
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case014(dt: Dt) {
  dt.log.i('照片页宫格手势滑动（月视图） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格手势滑动（月视图） end');
}

/**
 * 性能-滑动: [照片页宫格手势滑动（年视图）]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Performance_Case015
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case015(dt: Dt) {
  dt.log.i('照片页宫格手势滑动（年视图） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格手势滑动（年视图） end');
}

/**
 * 性能-: [进入相册宫格]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case016
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case016(dt: Dt) {
  dt.log.i('进入相册宫格 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入相册宫格 end');
}

/**
 * 性能-: [相册宫格上下快滑]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case017
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case017(dt: Dt) {
  dt.log.i('相册宫格上下快滑 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格上下快滑 end');
}

/**
 * 性能-: [宫格侧滑返回相册]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case018
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case018(dt: Dt) {
  dt.log.i('宫格侧滑返回相册 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格侧滑返回相册 end');
}

/**
 * 性能-视频: [视频相册宫格点击进入视频大图]
 * GROUP: 性能 MODULE: 视频TID: Multimedia_Photos_Performance_Case019
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case019(dt: Dt) {
  dt.log.i('视频相册宫格点击进入视频大图 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频相册宫格点击进入视频大图 end');
}

/**
 * 性能-视频: [视频点击播放（本地）]
 * GROUP: 性能 MODULE: 视频TID: Multimedia_Photos_Performance_Case020
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case020(dt: Dt) {
  dt.log.i('视频点击播放（本地） start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频点击播放（本地） end');
}

/**
 * 性能-视频: [视频大图下拉返回宫格]
 * GROUP: 性能 MODULE: 视频TID: Multimedia_Photos_Performance_Case021
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case021(dt: Dt) {
  dt.log.i('视频大图下拉返回宫格 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频大图下拉返回宫格 end');
}

/**
 * 性能-删除: [图库大图删除]
 * GROUP: 性能 MODULE: 删除TID: Multimedia_Photos_Performance_Case022
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case022(dt: Dt) {
  dt.log.i('图库大图删除 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库大图删除 end');
}

/**
 * 性能-删除: [图库宫格删除]
 * GROUP: 性能 MODULE: 删除TID: Multimedia_Photos_Performance_Case023
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case023(dt: Dt) {
  dt.log.i('图库宫格删除 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库宫格删除 end');
}

/**
 * 性能-删除: [图库视频删除]
 * GROUP: 性能 MODULE: 删除TID: Multimedia_Photos_Performance_Case024
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case024(dt: Dt) {
  dt.log.i('图库视频删除 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库视频删除 end');
}

/**
 * 性能-删除: [相机连续拍照后查看图片删除]
 * GROUP: 性能 MODULE: 删除TID: Multimedia_Photos_Performance_Case025
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case025(dt: Dt) {
  dt.log.i('相机连续拍照后查看图片删除 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机连续拍照后查看图片删除 end');
}

/**
 * 性能-: [分享一张图片]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case026
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case026(dt: Dt) {
  dt.log.i('分享一张图片 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享一张图片 end');
}

/**
 * 性能-: [添加至相册]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case027
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case027(dt: Dt) {
  dt.log.i('添加至相册 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加至相册 end');
}

/**
 * 性能-: [隐藏一张图片]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case028
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case028(dt: Dt) {
  dt.log.i('隐藏一张图片 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏一张图片 end');
}

/**
 * 性能-: [编辑一张图片]
 * GROUP: 性能 MODULE: TID: Multimedia_Photos_Performance_Case029
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case029(dt: Dt) {
  dt.log.i('编辑一张图片 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑一张图片 end');
}

/**
 * 性能-大图: [图片编辑返回大图]
 * GROUP: 性能 MODULE: 大图TID: Multimedia_Photos_Performance_Case030
 * 前置条件
 *
 */
async function Multimedia_Photos_Performance_Case030(dt: Dt) {
  dt.log.i('图片编辑返回大图 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑返回大图 end');
}

