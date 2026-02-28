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
import { ON } from '@ohos.UiTest';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';

export default function PreviewBarTest(): void {
  describe('LocationTabTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllLocationTabTest').init();
      dt.log.i('beforeAll LocationTabTest start');
      dt.log.i('beforeAll LocationTabTest finish');
    });
    run('Multimedia_Gallery_Picture_location_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-相册用例: [未同意地图相册服务-媒体库已有地理位置数据] TID: Multimedia_Gallery_Picture_location_01
      await Multimedia_Gallery_Picture_location_01(dt);
    });
    run('Multimedia_Gallery_Picture_location_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-相册用例: [未同意地图相册服务-媒体库无地理位置数据] TID: Multimedia_Gallery_Picture_location_02
      await Multimedia_Gallery_Picture_location_02(dt);
    });
    run('Multimedia_Gallery_Picture_location_04', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [日视图下-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_04
      await Multimedia_Gallery_Picture_location_04(dt);
    });
    run('Multimedia_Gallery_Picture_location_05', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相册页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_05
      await Multimedia_Gallery_Picture_location_05(dt);
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
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachLocationTabTest').init();
      dt.log.i('afterEach LocationTabTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLocationTabTest').init();
      await Exit.browser();
      dt.log.i('afterAll LocationTabTest finish');
    });
  });
}

/**
 * 大图-相册: [未同意地图相册服务-媒体库已有地理位置数据]
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_01
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
 * 大图-相册: [未同意地图相册服务-媒体库无地理位置数据]
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_02
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
 * 大图-大图: [日视图下-大图左上角地理信息显示]
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_04
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
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_05
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
 * 大图-大图: [地点超长显示-大图地理位置显示]
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_28
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
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_29
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
 * TAG: 大图顶部地点显示 TID: Multimedia_Gallery_Picture_location_30
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
  await dt.assertComponentByText('西安市；雁塔区');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图页地点位置显示 end');
}

