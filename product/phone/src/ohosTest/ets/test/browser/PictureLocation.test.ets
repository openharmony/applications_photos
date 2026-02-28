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

export default function PictureLocationTest(): void {
  describe('PictureLocationTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      // 进入图库
      await AppStart.photos()
    });
    run('beforePictureLocationTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 打开大图
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Picture_location_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [未同意地图相册服务-媒体库已有地理位置数据] TID: Multimedia_Gallery_Picture_location_01
      await Multimedia_Gallery_Picture_location_01(dt);
    });
    run('Multimedia_Gallery_Picture_location_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [未同意地图相册服务-媒体库无地理位置数据] TID: Multimedia_Gallery_Picture_location_02
      await Multimedia_Gallery_Picture_location_02(dt);
    });
    run('Multimedia_Gallery_Picture_location_03', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [地图相册服务同意后再取消-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_03
      await Multimedia_Gallery_Picture_location_03(dt);
    });
    run('Multimedia_Gallery_Picture_location_04', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [日视图下-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_04
      await Multimedia_Gallery_Picture_location_04(dt);
    });
    run('Multimedia_Gallery_Picture_location_05', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相册页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_05
      await Multimedia_Gallery_Picture_location_05(dt);
    });
    run('Multimedia_Gallery_Picture_location_06', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [时刻页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_06
      await Multimedia_Gallery_Picture_location_06(dt);
    });
    run('Multimedia_Gallery_Picture_location_07', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [搜索页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_07
      await Multimedia_Gallery_Picture_location_07(dt);
    });
    run('Multimedia_Gallery_Picture_location_08', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相机入口-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_08
      await Multimedia_Gallery_Picture_location_08(dt);
    });
    run('Multimedia_Gallery_Picture_location_09', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [锁屏相机入口-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_09
      await Multimedia_Gallery_Picture_location_09(dt);
    });
    run('Multimedia_Gallery_Picture_location_10', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [前后台切换-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_10
      await Multimedia_Gallery_Picture_location_10(dt);
    });
    run('Multimedia_Gallery_Picture_location_11', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [杀图库进程-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_11
      await Multimedia_Gallery_Picture_location_11(dt);
    });
    run('Multimedia_Gallery_Picture_location_12', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [灭屏亮屏-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_12
      await Multimedia_Gallery_Picture_location_12(dt);
    });
    run('Multimedia_Gallery_Picture_location_13', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-解析用例: [断网恢复网络-现解析大图地理位置显示] TID: Multimedia_Gallery_Picture_location_13
      await Multimedia_Gallery_Picture_location_13(dt);
    });
    run('Multimedia_Gallery_Picture_location_14', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-解析用例: [断网恢复网络-媒体库已解析大图地理位置显示] TID: Multimedia_Gallery_Picture_location_14
      await Multimedia_Gallery_Picture_location_14(dt);
    });
    run('Multimedia_Gallery_Picture_location_15', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图地理位置显示适配悬浮窗] TID: Multimedia_Gallery_Picture_location_15
      await Multimedia_Gallery_Picture_location_15(dt);
    });
    run('Multimedia_Gallery_Picture_location_16', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图地理位置显示适配分屏] TID: Multimedia_Gallery_Picture_location_16
      await Multimedia_Gallery_Picture_location_16(dt);
    });
    run('Multimedia_Gallery_Picture_location_17', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图地理位置显示适配全球化] TID: Multimedia_Gallery_Picture_location_17
      await Multimedia_Gallery_Picture_location_17(dt);
    });
    run('Multimedia_Gallery_Picture_location_18', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [深色模式下大图地理位置显示] TID: Multimedia_Gallery_Picture_location_18
      await Multimedia_Gallery_Picture_location_18(dt);
    });
    run('Multimedia_Gallery_Picture_location_19', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图地理位置显示适配适老化] TID: Multimedia_Gallery_Picture_location_19
      await Multimedia_Gallery_Picture_location_19(dt);
    });
    run('Multimedia_Gallery_Picture_location_20', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云同步-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_20
      await Multimedia_Gallery_Picture_location_20(dt);
    });
    run('Multimedia_Gallery_Picture_location_21', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [数据克隆-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_21
      await Multimedia_Gallery_Picture_location_21(dt);
    });
    run('Multimedia_Gallery_Picture_location_22', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [分享-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_22
      await Multimedia_Gallery_Picture_location_22(dt);
    });
    run('Multimedia_Gallery_Picture_location_23', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [碰一碰-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_23
      await Multimedia_Gallery_Picture_location_23(dt);
    });
    run('Multimedia_Gallery_Picture_location_24', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [隔空传送-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_24
      await Multimedia_Gallery_Picture_location_24(dt);
    });
    run('Multimedia_Gallery_Picture_location_25', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [三方应用保存-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_25
      await Multimedia_Gallery_Picture_location_25(dt);
    });
    run('Multimedia_Gallery_Picture_location_26', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [取消地理位置权限-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_26
      await Multimedia_Gallery_Picture_location_26(dt);
    });
    run('Multimedia_Gallery_Picture_location_27', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-解析用例: [大图地点解析-性能] TID: Multimedia_Gallery_Picture_location_27
      await Multimedia_Gallery_Picture_location_27(dt);
    });
    run('Multimedia_Gallery_Picture_location_28', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [地点超长显示-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_28
      await Multimedia_Gallery_Picture_location_28(dt);
    });
    run('Multimedia_Gallery_Picture_location_29', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相机拍照返回图库-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_29
      await Multimedia_Gallery_Picture_location_29(dt);
    });
    run('Multimedia_Gallery_Picture_location_30', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图页地点位置显示] TID: Multimedia_Gallery_Picture_location_30
      await Multimedia_Gallery_Picture_location_30(dt);
    });


    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => await Exit.browser());
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach PictureLocationTest').init();
      dt.log.i('afterEach PictureLocationTest test');
      dt.log.i('afterEach PictureLocationTest test finish');
    });
  });
}

// DT步骤
/**
 * 大图-进入大图: [未同意地图相册服务-媒体库已有地理位置数据]
 * TAG: 423 TID: Multimedia_Gallery_Picture_location_01
 * 前置条件
 * 1、设备已连接网络
 2、图库中存在已有地理位置信息的照片
 3、图库未同意地图相册服务

 */
async function Multimedia_Gallery_Picture_location_01(dt: Dt) {
  dt.log.i('未同意地图相册服务-媒体库已有地理位置数据 start');
  dt.log.i('STEP 1、打开图库，右上角点击设置-扩展服务-关闭地图相册服务');

  await dt.sleep();
  dt.log.i('预期结果1、地图相册服务开关关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击有地理位置图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角不显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图页上划详情页');

  await dt.sleep();
  dt.log.i('预期结果3、大图详情页不显示地点信息卡片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('未同意地图相册服务-媒体库已有地理位置数据 end');
}

/**
 * 大图-进入大图: [未同意地图相册服务-媒体库无地理位置数据]
 * TAG: 424 TID: Multimedia_Gallery_Picture_location_02
 * 前置条件
 * 1、设备已连接网络
 2、图库中存在无地理位置信息的照片
 3、图库未同意地图相册服务
 */
async function Multimedia_Gallery_Picture_location_02(dt: Dt) {
  dt.log.i('未同意地图相册服务-媒体库无地理位置数据 start');
  dt.log.i('STEP 1、打开图库，右上角点击设置-扩展服务-关闭地图相册服务');

  await dt.sleep();
  dt.log.i('预期结果1、地图相册服务开关关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击无地理位置图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角不显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图页上划详情页');

  await dt.sleep();
  dt.log.i('预期结果3、大图详情页不显示地点信息卡片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('未同意地图相册服务-媒体库无地理位置数据 end');
}

/**
 * 大图-大图: [地图相册服务同意后再取消-大图左上角地理信息显示]
 * TAG: 411 TID: Multimedia_Gallery_Picture_location_03
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_03(dt: Dt) {
  dt.log.i('地图相册服务同意后再取消-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库，右上角点击设置-扩展服务-打开地图相册服务');

  await dt.sleep();
  dt.log.i('预期结果1、地图相册服务开关打开');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击有地理位置图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图页上划详情页');

  await dt.sleep();
  dt.log.i('预期结果3、大图详情页显示地点信息卡片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、图库照片页右上角点击设置-扩展服务-关闭地图相册服务');

  await dt.sleep();
  dt.log.i('预期结果4、地图相册服务开关打开');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、重复2-3');

  await dt.sleep();
  dt.log.i('预期结果5.1、大图左上角不显示地理信息5.2、大图详情页无地点信息卡片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图相册服务同意后再取消-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [日视图下-大图左上角地理信息显示]
 * TAG: 421 TID: Multimedia_Gallery_Picture_location_04
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_04(dt: Dt) {
  dt.log.i('日视图下-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开相机新拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库照片页，日视图下四宫格点击刚拍照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、左右连续滑动照片');

  await dt.sleep();
  dt.log.i('预期结果3、5、6大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、打开图库照片页，日视图下三宫格点击刚拍照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 5、左右连续滑动照片');

  await dt.sleep();
  dt.log.i('STEP 6、横屏下查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('日视图下-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [相册页-大图左上角地理信息显示]
 * TAG: 428 TID: Multimedia_Gallery_Picture_location_05
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 5、图库中存在智慧相册
 */
async function Multimedia_Gallery_Picture_location_05(dt: Dt) {
  dt.log.i('相册页-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开相机新拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库点击相册页（系统相册、用户自定义相册、隐藏相册、地点相册、人像相册、分类相册、来源相册、最近删除相册）分别点击进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角显示地理信息');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [时刻页-大图左上角地理信息显示]
 * TAG: 422 TID: Multimedia_Gallery_Picture_location_06
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 5、图库中生成时刻
 */
async function Multimedia_Gallery_Picture_location_06(dt: Dt) {
  dt.log.i('时刻页-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库，进入时刻页');

  await dt.sleep();
  dt.log.i('STEP 2、点击时刻封面进入轮播，上划进入宫格显示');

  await dt.sleep();
  dt.log.i('STEP 3、点击宫格照片进入大图');

  await dt.sleep();
  dt.log.i('预期结果3、大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻页-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [搜索页-大图左上角地理信息显示]
 * TAG: 418 TID: Multimedia_Gallery_Picture_location_07
 * 前置条件
 * 1、手机保持充电，电量大于50%
 2、连接WLAN
 3、手机中预制能生成标签、时间、人像、地点、事物分类的照片
 4、手机开启位置权限
 5、相机开启记录地理信息位置
 6、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_07(dt: Dt) {
  dt.log.i('搜索页-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库，点击右上角搜索按钮');

  await dt.sleep();
  dt.log.i('预期结果1、进入搜索界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、搜索关键字');

  await dt.sleep();
  dt.log.i('预期结果2、显示搜索结果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、搜索结果点击宫格照片进入大图');

  await dt.sleep();
  dt.log.i('预期结果3、存在地理信息大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索页-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [相机入口-大图左上角地理信息显示]
 * TAG: 429 TID: Multimedia_Gallery_Picture_location_08
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_08(dt: Dt) {
  dt.log.i('相机入口-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开相机拍摄照片（夜景、闪拍、人像、拍照、连拍、录像、专业模式、带水印照片）');

  await dt.sleep();
  dt.log.i('STEP 2、点击左下角缩略图进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、3大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、左右滑动照片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-大图左上角地理信息显示 end');
}

/**
 * 大图-锁屏: [锁屏相机入口-大图左上角地理信息显示]
 * TAG: 433 TID: Multimedia_Gallery_Picture_location_09
 * 前置条件
 * 1、手机设置密码
 2、设备已连接网络
 3、设备开启位置权限
 4、相机开启记录地理信息位置
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_09(dt: Dt) {
  dt.log.i('锁屏相机入口-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、锁屏下打开相机、拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2、点击左下角缩略图进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、3大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、左右滑动照片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('锁屏相机入口-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [前后台切换-大图左上角地理信息显示]
 * TAG: 407 TID: Multimedia_Gallery_Picture_location_10
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_10(dt: Dt) {
  dt.log.i('前后台切换-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库进入照片页');

  await dt.sleep();
  dt.log.i('STEP 2、点击带有地点信息图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、4、5大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换图库到后台');

  await dt.sleep();
  dt.log.i('STEP 4、再次点击图库查看大图显示');

  await dt.sleep();
  dt.log.i('STEP 5、多次重复1-4查看大图显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('前后台切换-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [杀图库进程-大图左上角地理信息显示]
 * TAG: 425 TID: Multimedia_Gallery_Picture_location_11
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_11(dt: Dt) {
  dt.log.i('杀图库进程-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库进入照片页');

  await dt.sleep();
  dt.log.i('STEP 2、点击带有地点信息图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、4、5大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、后台清理图库运行');

  await dt.sleep();
  dt.log.i('STEP 4、再次点击图库查看大图显示');

  await dt.sleep();
  dt.log.i('STEP 5、多次重复1-4查看大图显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('杀图库进程-大图左上角地理信息显示 end');
}

/**
 * 大图-大图: [灭屏亮屏-大图左上角地理信息显示]
 * TAG: 427 TID: Multimedia_Gallery_Picture_location_12
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_12(dt: Dt) {
  dt.log.i('灭屏亮屏-大图左上角地理信息显示 start');
  dt.log.i('STEP 1、打开图库进入照片页');

  await dt.sleep();
  dt.log.i('STEP 2、点击带有地点信息图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、4、5大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击电源键灭屏亮屏');

  await dt.sleep();
  dt.log.i('STEP 4、进入图库查看大图显示');

  await dt.sleep();
  dt.log.i('STEP 5、多次重复1-4查看大图显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('灭屏亮屏-大图左上角地理信息显示 end');
}

/**
 * 大图-解析: [断网恢复网络-现解析大图地理位置显示]
 * TAG: 420 TID: Multimedia_Gallery_Picture_location_13
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 */
async function Multimedia_Gallery_Picture_location_13(dt: Dt) {
  dt.log.i('断网恢复网络-现解析大图地理位置显示 start');
  dt.log.i('STEP 1、设备断开网络打开相机，拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2、点击左下角缩略图，左右滑动查看大图');

  await dt.sleep();
  dt.log.i('预期结果2、3大图左上角不显示地理信息4、大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库点击刚所拍摄的照片，左右滑动查看大图');

  await dt.sleep();
  dt.log.i('STEP 4、恢复网络重复2-3');

  await dt.sleep();
  dt.log.i('预期结果4、大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('断网恢复网络-现解析大图地理位置显示 end');
}

/**
 * 大图-解析: [断网恢复网络-媒体库已解析大图地理位置显示]
 * TAG: 417 TID: Multimedia_Gallery_Picture_location_14
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_14(dt: Dt) {
  dt.log.i('断网恢复网络-媒体库已解析大图地理位置显示 start');
  dt.log.i('STEP 1、设备断开网络，图库点击已有媒体库息屏解析的地理图片');

  await dt.sleep();
  dt.log.i('STEP 2、大图左右连续滑动');

  await dt.sleep();
  dt.log.i('预期结果2、4大图左上角显示地理信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设备连接网络，左右滑动已有媒体库息屏解析的地理图片');

  await dt.sleep();
  dt.log.i('STEP 4、大图左右连续滑动');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('断网恢复网络-媒体库已解析大图地理位置显示 end');
}

/**
 * 大图-大图: [大图地理位置显示适配悬浮窗]
 * TAG: 408 TID: Multimedia_Gallery_Picture_location_15
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_15(dt: Dt) {
  dt.log.i('大图地理位置显示适配悬浮窗 start');
  dt.log.i('STEP 1、图库开启悬浮窗');

  await dt.sleep();
  dt.log.i('STEP 2、照片页、相册页点击带有地理位置的照片进入大图页');

  await dt.sleep();
  dt.log.i('STEP 3、大图左右连续滑动');

  await dt.sleep();
  dt.log.i('预期结果3、大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图地理位置显示适配悬浮窗 end');
}

/**
 * 大图-大图: [大图地理位置显示适配分屏]
 * TAG: 410 TID: Multimedia_Gallery_Picture_location_16
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_16(dt: Dt) {
  dt.log.i('大图地理位置显示适配分屏 start');
  dt.log.i('STEP 1、图库开启分屏');

  await dt.sleep();
  dt.log.i('STEP 2、照片页、相册页点击带有地理位置的照片进入大图页');

  await dt.sleep();
  dt.log.i('STEP 3、大图左右连续滑动');

  await dt.sleep();
  dt.log.i('预期结果3、大图左上角显示地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图地理位置显示适配分屏 end');
}

/**
 * 大图-大图: [大图地理位置显示适配全球化]
 * TAG: 406 TID: Multimedia_Gallery_Picture_location_17
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_17(dt: Dt) {
  dt.log.i('大图地理位置显示适配全球化 start');
  dt.log.i('STEP 1、设置系统语音分别设置为英文、藏文、维吾尔文、繁体中文');

  await dt.sleep();
  dt.log.i('STEP 2、照片页、相册页点击带有地理位置的照片进入大图页');

  await dt.sleep();
  dt.log.i('STEP 3、大图左右连续滑动');

  await dt.sleep();
  dt.log.i('预期结果3、大图左上角显示对应语音的地理信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图地理位置显示适配全球化 end');
}

/**
 * 大图-大图: [深色模式下大图地理位置显示]
 * TAG: 426 TID: Multimedia_Gallery_Picture_location_18
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_18(dt: Dt) {
  dt.log.i('深色模式下大图地理位置显示 start');
  dt.log.i('STEP 1、系统设置为深色模式');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库，点击带有地点信息图片/视频进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、深色模式下大图地点信息正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下大图地理位置显示 end');
}

/**
 * 大图-大图: [大图地理位置显示适配适老化]
 * TAG: 416 TID: Multimedia_Gallery_Picture_location_19
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_19(dt: Dt) {
  dt.log.i('大图地理位置显示适配适老化 start');
  dt.log.i('STEP 1、设置系统字体大小为大-超大-特大，查看大图左上角地点位置显示');

  await dt.sleep();
  dt.log.i('预期结果1、2大字体下，大图左上角地理位置字体显示无溢出、无截断现象，符合UX显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、设置-辅助功能-开启关怀模式-设置字体大小（大1挡-大2挡-大3挡），查看大图左上角地点位置显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图地理位置显示适配适老化 end');
}

/**
 * 大图-端云: [端云同步-大图地理位置显示]
 * TAG: 432 TID: Multimedia_Gallery_Picture_location_20
 * 前置条件
 * 1、设备已连接网络，已登录云账户
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_20(dt: Dt) {
  dt.log.i('端云同步-大图地理位置显示 start');
  dt.log.i('STEP 1、进入图库，点击带有地点信息缩略图进入大图界面');

  await dt.sleep();
  dt.log.i('STEP 2、连续左右滑动，查看大图左上角地点信息显示');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角显示地理信息');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云同步-大图地理位置显示 end');
}

/**
 * 大图-大图: [数据克隆-大图地理位置显示]
 * TAG: 415 TID: Multimedia_Gallery_Picture_location_21
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、图库中同意地图相册服务
 4、图库中存在已有地理位置信息的照片
 5、xxx手机存在照片和视频
 6、xxx手机存在照片和视频
 */
async function Multimedia_Gallery_Picture_location_21(dt: Dt) {
  dt.log.i('数据克隆-大图地理位置显示 start');
  dt.log.i('STEP 1.1、xxx克隆数据1.2、点击缩略图查看大图左上角显示');

  await dt.sleep();
  dt.log.i('预期结果1.2、2.2已有地点信息大图左上角显示，无地点信息不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1、xxx克隆数据2.2、点击缩略图查看大图左上角显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('数据克隆-大图地理位置显示 end');
}

/**
 * 大图-大图: [分享-大图地理位置显示]
 * TAG: 412 TID: Multimedia_Gallery_Picture_location_22
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_22(dt: Dt) {
  dt.log.i('分享-大图地理位置显示 start');
  dt.log.i('STEP 1、进入图库点击带有地理位置的照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 2、点击左下角分享按钮');

  await dt.sleep();
  dt.log.i('预期结果2、分享成功，对端大图左上角显示地点信息');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享-大图地理位置显示 end');
}

/**
 * 大图-大图: [碰一碰-大图地理位置显示]
 * TAG: 431 TID: Multimedia_Gallery_Picture_location_23
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 6、存在两台设备A、B且图库均预置多张图片
 */
async function Multimedia_Gallery_Picture_location_23(dt: Dt) {
  dt.log.i('碰一碰-大图地理位置显示 start');
  dt.log.i('STEP 1、进入图库点击带有地理位置的照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 2、设备A、B对头碰一碰');

  await dt.sleep();
  dt.log.i('预期结果3、分享成功，对端大图左上角显示地点信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('碰一碰-大图地理位置显示 end');
}

/**
 * 大图-大图: [隔空传送-大图地理位置显示]
 * TAG: 434 TID: Multimedia_Gallery_Picture_location_24
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、存在两台设备A、B且图库均预置多张带有地点信息图片
 6、设备A、B均开启隔空传送（设置>系统>快捷启动和手势>隔空传送）
 */
async function Multimedia_Gallery_Picture_location_24(dt: Dt) {
  dt.log.i('隔空传送-大图地理位置显示 start');
  dt.log.i('STEP 1、进入图库点击带有地理位置的照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 2、在设备A据屏幕20~40厘米做握拳手势');

  await dt.sleep();
  dt.log.i('STEP 3、接上步移动到设备B松开恢复手掌');

  await dt.sleep();
  dt.log.i('预期结果3、设备B接受到图片且大图左上角显示地点信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隔空传送-大图地理位置显示 end');
}

/**
 * 大图-大图: [三方应用保存-大图地理位置显示]
 * TAG: 409 TID: Multimedia_Gallery_Picture_location_25
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、设备存在三方应用
 */
async function Multimedia_Gallery_Picture_location_25(dt: Dt) {
  dt.log.i('三方应用保存-大图地理位置显示 start');
  dt.log.i('STEP 1、打开三方应用（微信、微博、小红书、今日头条等）保存图片到图库');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库相册查看已保存的照片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、带有地点信息照片大图左上角显示地点信息、不带地点信息不显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用保存-大图地理位置显示 end');
}

/**
 * 大图-大图: [取消地理位置权限-大图地理位置显示]
 * TAG: 413 TID: Multimedia_Gallery_Picture_location_26
 * 前置条件
 * 1、设备已连接网络
 2、设备关闭位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_26(dt: Dt) {
  dt.log.i('取消地理位置权限-大图地理位置显示 start');
  dt.log.i('STEP 1、打开相机新拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库照片页，点击刚拍照片进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、左右连续滑动照片');

  await dt.sleep();
  dt.log.i('预期结果3、大图左上角不显示地点信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('取消地理位置权限-大图地理位置显示 end');
}

/**
 * 大图-解析: [大图地点解析-性能]
 * TAG: 414 TID: Multimedia_Gallery_Picture_location_27
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 6、准备xxx手机
 */
async function Multimedia_Gallery_Picture_location_27(dt: Dt) {
  dt.log.i('大图地点解析-性能 start');
  dt.log.i('STEP 1、相机连续拍摄多张照片');

  await dt.sleep();
  dt.log.i('STEP 2、返回图库点击进入大图左右滑动');

  await dt.sleep();
  dt.log.i('STEP 3、对比xxx查看大图地点解析');

  await dt.sleep();
  dt.log.i('预期结果3、单个照片解析的端到端时延不劣于xxx');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图地点解析-性能 end');
}

/**
 * 大图-大图: [地点超长显示-大图地理位置显示]
 * TAG: 405 TID: Multimedia_Gallery_Picture_location_28
 * 前置条件
 * 1、设备已连接网络，已登录云账户
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在超长地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_28(dt: Dt) {
  dt.log.i('地点超长显示-大图地理位置显示 start');
  dt.log.i('STEP 1、进入图库打开超长（国内外部分地区地点名字超长)地点位置显示大图');

  await dt.sleep();
  dt.log.i('预期结果1、超长地点多出部分后面....显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点超长显示-大图地理位置显示 end');
}

/**
 * 大图-大图: [相机拍照返回图库-大图地理位置显示]
 * TAG: 430 TID: Multimedia_Gallery_Picture_location_29
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_29(dt: Dt) {
  dt.log.i('相机拍照返回图库-大图地理位置显示 start');
  dt.log.i('STEP 1、相机连续拍摄多张照片（覆盖夜景、闪拍、人像、拍照、连拍、录像、专业模式、带水印照片）');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库点击所拍摄照片进入大图左右滑动');

  await dt.sleep();
  dt.log.i('预期结果2、大图左上角显示地理信息');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍照返回图库-大图地理位置显示 end');
}

/**
 * 大图-大图: [大图页地点位置显示]
 * TAG: 419 TID: Multimedia_Gallery_Picture_location_30
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_30(dt: Dt) {
  dt.log.i('大图页地点位置显示 start');
  dt.log.i('STEP 1、打开图库点击带有地点信息的照片进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图左上角地点显示，取地点信息城市和城市下一级，一般为区（比如陕西省西安市雁塔区，则只显示”西安市；雁塔区”）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('西安市；雁塔区'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图页地点位置显示 end');
}

