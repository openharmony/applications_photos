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

export default function PhotosLoadTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('PhotosLoadTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPhotosLoad').init();
      dt.log.i('beforeAll PhotosLoad start');
      dt.log.i('beforeAll PhotosLoad finish');
    });
    /**
     * 打开大图
     */
    run('beforePhotosLoad', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    run('Multimedia_Photos_Load_Case001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [照片页宫格浏览资源占用测试] TID: Multimedia_Photos_Load_Case001
      await Multimedia_Photos_Load_Case001(dt);
    });
    run('Multimedia_Photos_Load_Case002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [大图左右滑动浏览] TID: Multimedia_Photos_Load_Case002
      await Multimedia_Photos_Load_Case002(dt);
    });
    run('Multimedia_Photos_Load_Case003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-大图用例: [大图缩放查看细节] TID: Multimedia_Photos_Load_Case003
      await Multimedia_Photos_Load_Case003(dt);
    });
    run('Multimedia_Photos_Load_Case004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [大图底部缩略图快速滑动] TID: Multimedia_Photos_Load_Case004
      await Multimedia_Photos_Load_Case004(dt);
    });
    run('Multimedia_Photos_Load_Case005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-视频用例: [视频一键调节] TID: Multimedia_Photos_Load_Case005
      await Multimedia_Photos_Load_Case005(dt);
    });
    run('Multimedia_Photos_Load_Case006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-进入大图用例: [图片编辑] TID: Multimedia_Photos_Load_Case006
      await Multimedia_Photos_Load_Case006(dt);
    });
    run('Multimedia_Photos_Load_Case007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-收藏用例: [图片收藏] TID: Multimedia_Photos_Load_Case007
      await Multimedia_Photos_Load_Case007(dt);
    });
    run('Multimedia_Photos_Load_Case008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-进入大图用例: [图片分享] TID: Multimedia_Photos_Load_Case008
      await Multimedia_Photos_Load_Case008(dt);
    });
    run('Multimedia_Photos_Load_Case009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  性能-详情用例: [图片恢复] TID: Multimedia_Photos_Load_Case009
      await Multimedia_Photos_Load_Case009(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPhotosLoad').init();
      dt.log.i('afterEach PhotosLoad start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach PhotosLoad finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotosLoad').init();
      dt.log.i('afterAll PhotosLoad start');
      await Exit.browser();
      dt.log.i('afterAll PhotosLoad finish');
    });
  });
}

/**
 * 性能-滑动: [照片页宫格浏览资源占用测试]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Load_Case001
 * 前置条件
 * 预制图片数量：
 # 1M*5000
 # 3M*2500
 # 5M*1250
 # 8M*750
 # 100M视频*250
 # 200M视频*150
 # 300M视频*100
 # 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试
 */
async function Multimedia_Photos_Load_Case001(dt: Dt) {
  dt.log.i('照片页宫格浏览资源占用测试 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格浏览资源占用测试 end');
}

/**
 * 性能-滑动: [大图左右滑动浏览]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Load_Case002
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case002(dt: Dt) {
  dt.log.i('大图左右滑动浏览 start');
  dt.log.i('STEP 2、点击图片进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、100s内大图左右滑动浏览100次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图左右滑动浏览 end');
}

/**
 * 性能-大图: [大图缩放查看细节]
 * GROUP: 性能 MODULE: 大图TID: Multimedia_Photos_Load_Case003
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case003(dt: Dt) {
  dt.log.i('大图缩放查看细节 start');
  dt.log.i('STEP 2、点击图片进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、30s双击放大缩小算一次大图查看20次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图缩放查看细节 end');
}

/**
 * 性能-滑动: [大图底部缩略图快速滑动]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_Load_Case004
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case004(dt: Dt) {
  dt.log.i('大图底部缩略图快速滑动 start');
  dt.log.i('STEP 2、点击图片进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、30s内快速滑动大图底部缩略图20次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图底部缩略图快速滑动 end');
}

/**
 * 性能-视频: [视频一键调节]
 * GROUP: 性能 MODULE: 视频TID: Multimedia_Photos_Load_Case005
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case005(dt: Dt) {
  dt.log.i('视频一键调节 start');
  dt.log.i('STEP 2、点击视频进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、60s内点击视频大图页面的编辑进入编辑页面，使用一键调节功能编辑视频保存为一次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频一键调节 end');
}

/**
 * 性能-进入大图: [图片编辑]
 * GROUP: 性能 MODULE: 进入大图TID: Multimedia_Photos_Load_Case006
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case006(dt: Dt) {
  dt.log.i('图片编辑 start');
  dt.log.i('STEP 2、点击图片缩略图进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、在60s内操作点击编辑进入编辑页面，点击旋转图标进行90度旋转后，点击退出操作。编辑退出算一次完整操作20次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑 end');
}

/**
 * 性能-收藏: [图片收藏]
 * GROUP: 性能 MODULE: 收藏TID: Multimedia_Photos_Load_Case007
 * 前置条件
 * 1、打开图库,进入照片页，
 2、点击照片进入大图页面
 3、30s内点击收藏图片，收藏20张

 */
async function Multimedia_Photos_Load_Case007(dt: Dt) {
  dt.log.i('图片收藏 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片收藏 end');
}

/**
 * 性能-进入大图: [图片分享]
 * GROUP: 性能 MODULE: 进入大图TID: Multimedia_Photos_Load_Case008
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case008(dt: Dt) {
  dt.log.i('图片分享 start');
  dt.log.i('STEP 2、点击照片进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 3、30s内点击分享图片，分享10次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片分享 end');
}

/**
 * 性能-详情: [图片恢复]
 * GROUP: 性能 MODULE: 详情TID: Multimedia_Photos_Load_Case009
 * 前置条件
 * 预制图片数量：
 1M*5000
 3M*2500
 5M*1250
 8M*750
 10M视频*250
 100M视频*150
 300M视频*100
 预置后，宫格和大图要全部滑动一遍 ，充电灭屏静置一夜，第二天启动性能测试

 */
async function Multimedia_Photos_Load_Case009(dt: Dt) {
  dt.log.i('图片恢复 start');
  dt.log.i('STEP 2、点击最近删除进入详情页');

  await dt.sleep();
  dt.log.i('STEP 3、30s内选中删除图片恢复20次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片恢复 end');
}

