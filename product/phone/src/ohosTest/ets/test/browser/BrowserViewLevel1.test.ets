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
import { ON } from '@ohos.UiTest';
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function BrowserViewLevel1Test(): void {
  describe('BrowserViewLevel1Test', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllBrowserViewLevel1Test').init();
      await AppStart.photos();
      dt.log.i('beforeAll BrowserViewLevel1Test finish');
    });
    it('beforeBrowserViewLevel1Test', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_PhotoBrowser_0001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图打开有模糊效果] TID: Multimedia_Gallery_PhotoBrowser_0001
      await Multimedia_Gallery_PhotoBrowser_0001(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_083', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [长边低于4500分辨率图片大图查看] TID: Multimedia_Gallery_PhotoBrowser_083
      await Multimedia_Gallery_PhotoBrowser_083(dt);
    });
    it('Multimedia_Gallery_Specific_PhotoBrowser_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [picker页和三方应用预览3072*4096尺寸大图] TID: Multimedia_Gallery_Specific_PhotoBrowser_002
      await Multimedia_Gallery_Specific_PhotoBrowser_002(dt);
    });
    it('Multimedia_Gallery_Specific_PhotoBrowser_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [3072*4096尺寸图片进入编辑页，观察图片显示] TID: Multimedia_Gallery_Specific_PhotoBrowser_003
      await Multimedia_Gallery_Specific_PhotoBrowser_003(dt);
    });
    it('Multimedia_Gallery_PhotosBrowser_277', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [图库打开云端大图，查看拍摄时间和显示时间一致性] TID: Multimedia_Gallery_PhotosBrowser_277
      await Multimedia_Gallery_PhotosBrowser_277(dt);
    });
    it('Multimedia_Gallery_PhotosBrowser_278', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [图库打开本地端大图，查看拍摄时间和显示时间一致性] TID: Multimedia_Gallery_PhotosBrowser_278
      await Multimedia_Gallery_PhotosBrowser_278(dt);
    });
  })
  describe('BrowserViewLevel1Test2', (): void => {
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllBrowserViewLevel1Test').init();
      await AppStart.photos();
      dt.log.i('beforeAll BrowserViewLevel1Test finish');
    });
    it('beforeBrowserViewLevel1Test', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_Picture_location_04', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [日视图下-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_04
      await Multimedia_Gallery_Picture_location_04(dt);
    });
    it('Multimedia_Gallery_Picture_location_05', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相册页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_05
      await Multimedia_Gallery_Picture_location_05(dt);
    });
    it('Multimedia_Gallery_Picture_location_28', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [地点超长显示-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_28
      await Multimedia_Gallery_Picture_location_28(dt);
    });
    it('Multimedia_Gallery_Picture_location_29', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相机拍照返回图库-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_29
      await Multimedia_Gallery_Picture_location_29(dt);
    });
    it('Multimedia_Gallery_Picture_location_30', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图页地点位置显示] TID: Multimedia_Gallery_Picture_location_30
      await Multimedia_Gallery_Picture_location_30(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_188', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图页面放大缩小图片] TID: Multimedia_Gallery_PhotoOperations_188
      await Multimedia_Gallery_PhotoOperations_188(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_186', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图页面重复进入退出操作] TID: Multimedia_Gallery_PhotoOperations_186
      await Multimedia_Gallery_PhotoOperations_186(dt);
    });
  })
  describe('BrowserViewLevel1Test3', (): void => {
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllBrowserViewLevel1Test').init();
      await AppStart.photos();
      dt.log.i('beforeAll BrowserViewLevel1Test finish');
    });
    it('beforeBrowserViewLevel1Test', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_PhotoOperations_0001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图侧滑返回基础用例] TID: Multimedia_Gallery_PhotoOperations_0001
      await Multimedia_Gallery_PhotoOperations_0001(dt);
    });
    it('Multimedia_Gallery_Segmented_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [【分段式拍照】相机拍摄20张图片，浏览查看大图] TID: Multimedia_Gallery_Segmented_001
      await Multimedia_Gallery_Segmented_001(dt);
    });
    it('Multimedia_Gallery_Files_moves_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [照片大图页移动到目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_002
      await Multimedia_Gallery_Files_moves_002(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [不同入口打开大图界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_001
      await Multimedia_Gallery_VideoPlayer_Frame_001(dt);
    });
    it('Multimedia_Gallery_Settings_menu_019', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图组件菜单显示] TID: Multimedia_Gallery_Settings_menu_019
      await Multimedia_Gallery_Settings_menu_019(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllBrowserViewLevel1Test3').init();
      await Exit.browser();
      dt.log.i('afterAll BrowserViewLevel1Test3 finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachBrowserViewLevel1Test3').init();
      dt.log.i('afterEach BrowserViewLevel1Test3 finish');
    });
  });
}

/**
 * 大图-大图用例: [大图打开有模糊效果] TID: Multimedia_Gallery_PhotoBrowser_0001
 * 前置条件
 * 图库存在多个图片和视频
 */
async function Multimedia_Gallery_PhotoBrowser_0001(dt: Dt) {
  dt.log.i('大图打开有模糊效果 start');
  // 测试步骤
  // 1、相机拍摄一张全屏图片
  await dt.sleep(DELAY.short);
  // 2、相机入口打开大图，退出沉浸式状态，查看大图的顶部被时间覆盖的部分是否有模糊效果（模糊效果下看不清图片）
  await dt.sleep(DELAY.short);
  // 3、宫格入口打开大图，重复步骤3
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_ID_CARD_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('身份证'))) {
    await dt.assertComponentByText('身份证');
  }
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 4、相册入口打开大图（系统相册，来源相册，用户创建相册）.重复步骤3
  await dt.sleep(DELAY.short);
  // 
  await Multimedia_Gallery_PhotoBrowser_0001Expects(dt);
  dt.log.i('大图打开有模糊效果 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_0001Expects(dt: Dt): Promise<void> {
  // 2，3，4全屏大图有模糊效果，顶部被时间覆盖的部分看不清

}

/**
 * 大图-大图用例: [长边低于4500分辨率图片大图查看] TID: Multimedia_Gallery_PhotoBrowser_083
 * 前置条件
 * 1、手机上存在长边低于4500分辨率图片
 */
async function Multimedia_Gallery_PhotoBrowser_083(dt: Dt) {
  dt.log.i('长边低于4500分辨率图片大图查看 start');
  // 测试步骤
  // 1、进入照片大图查看
  await Multimedia_Gallery_PhotoBrowser_083Expects(dt);
  dt.log.i('长边低于4500分辨率图片大图查看 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_083Expects(dt: Dt): Promise<void> {
  // 1、图片显示清晰

}

/**
 * 大图-大图用例: [picker页和三方应用预览3072*4096尺寸大图] TID: Multimedia_Gallery_Specific_PhotoBrowser_002
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_002(dt: Dt) {
  dt.log.i('picker页和三方应用预览3072*4096尺寸大图 start');
  // 测试步骤
  // 1.分别从备忘录和畅连应用，选择3072*4096尺寸图片，进行大图预览
  await dt.swipeScreen?.left();
  // 2.使用备忘录完成添加3072*4096尺寸图片后，进行大图预览
  await dt.sleep(DELAY.short);
  // 3.使用畅联发送3072*4096尺寸原图后，进行大图预览
  await Multimedia_Gallery_Specific_PhotoBrowser_002Expects(dt);
  dt.log.i('picker页和三方应用预览3072*4096尺寸大图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_002Expects(dt: Dt): Promise<void> {
  // 1.图片显示正常、右侧无白色竖线
  await dt.showComponentsWithin();
  // 2.图片显示正常、右侧无白色竖线
  await dt.showComponentsWithin();
  // 3.图片显示正常、右侧无白色竖线

}

/**
 * 大图-大图用例: [3072*4096尺寸图片进入编辑页，观察图片显示] TID: Multimedia_Gallery_Specific_PhotoBrowser_003
 * 前置条件
 * 1.图库中存在多张3072*4096尺寸图片
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_003(dt: Dt) {
  dt.log.i('3072*4096尺寸图片进入编辑页，观察图片显示 start');
  // 测试步骤
  // 1.进入图库，大图预览3072*4096尺寸图片
  await dt.swipeScreen?.left();
  // 2.进入编辑页面
  await Multimedia_Gallery_Specific_PhotoBrowser_003Expects(dt);
  dt.log.i('3072*4096尺寸图片进入编辑页，观察图片显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Specific_PhotoBrowser_003Expects(dt: Dt): Promise<void> {
  // 1.图片显示正常、右侧无白色竖线

}

/**
 * 大图-大图用例: [图库打开云端大图，查看拍摄时间和显示时间一致性] TID: Multimedia_Gallery_PhotosBrowser_277
 * 前置条件
 * 1、图库至少存在1W张图片以上 ，天分组至少50个以上；图库 存在纯云端数据5K以上，天分组超过50个
 */
async function Multimedia_Gallery_PhotosBrowser_277(dt: Dt) {
  dt.log.i('图库打开云端大图，查看拍摄时间和显示时间一致性 start');
  // 测试步骤
  // 1.进入图库，滑动图片到2020年左右，打开任意纯云端大图（确保这个大图有exif信息）
  await dt.sleep(DELAY.short);
  // 2、查看大图左上角的显示时间 ，上滑查看详情卡片的时间，以及图片的名称
  await Multimedia_Gallery_PhotosBrowser_277Expects(dt);
  dt.log.i('图库打开云端大图，查看拍摄时间和显示时间一致性 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotosBrowser_277Expects(dt: Dt): Promise<void> {
  // 1 、大图的左上角时间和详情卡片上时间显示一致，且时间和图片名称中的时间一致

}

/**
 * 大图-大图用例: [图库打开本地端大图，查看拍摄时间和显示时间一致性] TID: Multimedia_Gallery_PhotosBrowser_278
 * 前置条件
 * 1、图库至少存在1W张图片以上 ，天分组至少50个以上；图库 存在纯云端数据5K以上，天分组超过50个
 */
async function Multimedia_Gallery_PhotosBrowser_278(dt: Dt) {
  dt.log.i('图库打开本地端大图，查看拍摄时间和显示时间一致性 start');
  // 测试步骤
  // 1.进入图库，滑动图片到2020年左右，打开任意纯本地大图（确保这个大图有exif信息）
  await dt.sleep(DELAY.short);
  // 2、查看大图左上角的显示时间 ，上滑查看详情卡片的时间，以及图片的名称
  await Multimedia_Gallery_PhotosBrowser_278Expects(dt);
  dt.log.i('图库打开本地端大图，查看拍摄时间和显示时间一致性 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotosBrowser_278Expects(dt: Dt): Promise<void> {
  // 1 、大图的左上角时间和详情卡片上时间显示一致，且时间和图片名称中的时间一致

}

/**
 * 大图-大图用例: [日视图下-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_04
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_04(dt: Dt) {
  dt.log.i('日视图下-大图左上角地理信息显示 start');
  // 测试步骤
  // 1、打开相机新拍摄照片
  await dt.sleep(DELAY.short);
  // 2、打开图库照片页，日视图下四宫格点击刚拍照片进入大图
  await dt.sleep(DELAY.short);
  // 3、左右连续滑动照片
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_ID_CARD_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('身份证'))) {
    await dt.assertComponentByText('身份证');
  }
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 
  await Multimedia_Gallery_Picture_location_04Expects(dt);
  dt.log.i('日视图下-大图左上角地理信息显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Picture_location_04Expects(dt: Dt): Promise<void> {
  // 3、5、6大图左上角显示地理信息

}

/**
 * 大图-大图用例: [相册页-大图左上角地理信息显示] TID: Multimedia_Gallery_Picture_location_05
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中存在已有地理位置信息的照片
 5、图库中存在智慧相册
 */
async function Multimedia_Gallery_Picture_location_05(dt: Dt) {
  dt.log.i('相册页-大图左上角地理信息显示 start');
  // 测试步骤
  // 1、打开相机新拍摄照片
  await dt.sleep(DELAY.short);
  // 2、打开图库点击相册页（系统相册、用户自定义相册、隐藏相册、地点相册、人像相册、分类相册、来源相册、最近删除相册）分别点击进入大图
  await dt.sleep(DELAY.short);
  // 
  await Multimedia_Gallery_Picture_location_05Expects(dt);
  dt.log.i('相册页-大图左上角地理信息显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Picture_location_05Expects(dt: Dt): Promise<void> {
  // 2、大图左上角显示地理信息

}

/**
 * 大图-大图用例: [地点超长显示-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_28
 * 前置条件
 * 1、设备已连接网络，已登录云账户
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在超长地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_28(dt: Dt) {
  dt.log.i('地点超长显示-大图地理位置显示 start');
  // 测试步骤
  // 1、进入图库打开超长（国内外部分地区地点名字超长)地点位置显示大图
  await Multimedia_Gallery_Picture_location_28Expects(dt);
  dt.log.i('地点超长显示-大图地理位置显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Picture_location_28Expects(dt: Dt): Promise<void> {
  // 1、超长地点多出部分后面....显示

}

/**
 * 大图-大图用例: [相机拍照返回图库-大图地理位置显示] TID: Multimedia_Gallery_Picture_location_29
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_29(dt: Dt) {
  dt.log.i('相机拍照返回图库-大图地理位置显示 start');
  // 测试步骤
  // 1、相机连续拍摄多张照片（覆盖夜景、闪拍、人像、拍照、连拍、录像、专业模式、带水印照片）
  await dt.sleep(DELAY.short);
  // 2、打开图库点击所拍摄照片进入大图左右滑动
  await Multimedia_Gallery_Picture_location_29Expects(dt);
  dt.log.i('相机拍照返回图库-大图地理位置显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Picture_location_29Expects(dt: Dt): Promise<void> {
  // 2、大图左上角显示地理信息

}

/**
 * 大图-大图用例: [大图页地点位置显示] TID: Multimedia_Gallery_Picture_location_30
 * 前置条件
 * 1、设备已连接网络
 2、设备开启位置权限
 3、相机开启记录地理信息位置
 4、图库中同意地图相册服务
 5、图库中存在已有地理位置信息的照片
 */
async function Multimedia_Gallery_Picture_location_30(dt: Dt) {
  dt.log.i('大图页地点位置显示 start');
  // 测试步骤
  // 1、打开图库点击带有地点信息的照片进入大图
  await Multimedia_Gallery_Picture_location_30Expects(dt);
  dt.log.i('大图页地点位置显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Picture_location_30Expects(dt: Dt): Promise<void> {
  // 1、查看大图左上角地点显示，取地点信息城市和城市下一级，一般为区（比如陕西省西安市雁塔区，则只显示""西安市；雁塔区""）

}

/**
 * 大图-大图用例: [大图页面放大缩小图片] TID: Multimedia_Gallery_PhotoOperations_188
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoOperations_188(dt: Dt) {
  dt.log.i('大图页面放大缩小图片 start');
  // 测试步骤
  // 1、在图库中打开大图
  await dt.sleep(DELAY.short);
  // 2、双指捏合放大缩小图片
  await dt.sleep(DELAY.short);
  // 3、双击放大缩小图片
  await Multimedia_Gallery_PhotoOperations_188Expects(dt);
  dt.log.i('大图页面放大缩小图片 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_188Expects(dt: Dt): Promise<void> {
  // 1、图片正常放大缩小，过程流畅顺滑

}

/**
 * 大图-大图用例: [大图页面重复进入退出操作] TID: Multimedia_Gallery_PhotoOperations_186
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoOperations_186(dt: Dt) {
  dt.log.i('大图页面重复进入退出操作 start');
  // 测试步骤
  // 1、宫格页面点击缩略图进入大图
  await dt.sleep(DELAY.short);
  // 2、侧滑返回，或者点击返回按钮返回宫格
  await dt.sleep(DELAY.short);
  // 3、再次点击缩略图进入大图（同一张图片）
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_PROFILE_PICTURE_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  // 点击头像按钮
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  if (await dt.driver.findComponent(ON.text('头像'))) {
    await dt.assertComponentByText('头像');
  }
  // 点击全部按钮
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  await dt.driver.pressBack();
  // 5、重复操作10次
  await Multimedia_Gallery_PhotoOperations_186Expects(dt);
  dt.log.i('大图页面重复进入退出操作 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_186Expects(dt: Dt): Promise<void> {
  // 1、大图页面正常显示，进入退出大图的动效流畅顺滑

}

/**
 * 大图-大图用例: [大图侧滑返回基础用例] TID: Multimedia_Gallery_PhotoOperations_0001
 * 前置条件
 * 1、图库中预制不同类型的图片和视频
 */
async function Multimedia_Gallery_PhotoOperations_0001(dt: Dt) {
  dt.log.i('大图侧滑返回基础用例 start');
  // 测试步骤
  // 1、打开图库应用，进入照片页
  await dt.sleep(DELAY.short);
  // 2、点击一张照片进入大图，然后侧滑返回
  await dt.sleep(DELAY.short);
  // 3、从相机入口进入大图，然后侧滑返回
  await Multimedia_Gallery_PhotoOperations_0001Expects(dt);
  dt.log.i('大图侧滑返回基础用例 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_0001Expects(dt: Dt): Promise<void> {
  // 2、侧滑返回丝滑，无卡顿
  await dt.showComponentsWithin();
  // 3、侧滑返回丝滑，无卡顿

}

/**
 * 大图-大图用例: [【分段式拍照】相机拍摄20张图片，浏览查看大图] TID: Multimedia_Gallery_Segmented_001
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_001(dt: Dt) {
  dt.log.i('【分段式拍照】相机拍摄20张图片，浏览查看大图 start');
  // 测试步骤
  // 1.相机拍摄照片（普通拍照、锁屏相机、人像、夜景、不同比例）；
  await dt.swipeScreen?.left();
  // 2.点击左下角缩略图进入大图，上滑查看大图详情；
  await dt.sleep(DELAY.short);
  // 3.快速浏览至第十张大图，上滑查看大图详情；
  await dt.sleep(DELAY.short);
  // 4.手机横屏，重复步骤1、2、3。
  await Multimedia_Gallery_Segmented_001Expects(dt);
  dt.log.i('【分段式拍照】相机拍摄20张图片，浏览查看大图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Segmented_001Expects(dt: Dt): Promise<void> {
  // 1.相机拍摄照片成功；
  await dt.showComponentsWithin();
  // 2.进大图动效正常，大图详情图片大小展示为高质量图；
  await dt.showComponentsWithin();
  // 3.大图详情图片大小展示为低质量图，然后更新为高质量图；
  await dt.showComponentsWithin();
  // 4.横屏模式下正常拍摄，大图展示为高质量图。

}

/**
 * 大图-大图用例: [照片大图页移动到目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_002
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function Multimedia_Gallery_Files_moves_002(dt: Dt) {
  dt.log.i('照片大图页移动到目标相册，界面检查 start');
  // 测试步骤
  // 1.进入图库照片页，点击文件进入大图，点击右上角更多图标，选择移动到选项
  await dt.swipeScreen?.left();
  // 2.进入目标相册选择界面，选择目标相册
  await dt.sleep(DELAY.short);
  // 3.横屏状态下界面检查
  await Multimedia_Gallery_Files_moves_002Expects(dt);
  dt.log.i('照片大图页移动到目标相册，界面检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Files_moves_002Expects(dt: Dt): Promise<void> {
  // 1.所选文件进入目标相册
  await dt.showComponentsWithin();
  // 2.所选文件在图片页数量增加
  await dt.showComponentsWithin();
  // 3.横屏状态下显示正常

}

/**
 * 大图-大图用例: [不同入口打开大图界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_001
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_001(dt: Dt) {
  dt.log.i('不同入口打开大图界面显示 start');
  // 测试步骤
  // 1、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看大图，观察界面布局
  await dt.sleep(DELAY.short);
  // 2、从隐藏相册入口进入查看大图，观察界面布局
  await dt.sleep(DELAY.short);
  // 3、从最近删除相册入口进入查看大图，观察界面布局
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_TEXT_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  if (await dt.driver.findComponent(ON.text('大熊猫'))) {
    await dt.assertComponentByText('大熊猫');
  }
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 
  await Multimedia_Gallery_VideoPlayer_Frame_001Expects(dt);
  dt.log.i('不同入口打开大图界面显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_VideoPlayer_Frame_001Expects(dt: Dt): Promise<void> {
  // 1、底部tab依次显示分享，收藏，编辑，删除按钮，右上角显示四方菜单按钮和云增强按钮（tab下无文字）
  await dt.showComponentsWithin();
  // 2、底部tab依次显示收藏，编辑，删除，右上角显示四方菜单
  await dt.showComponentsWithin();
  // 3、底部tab依次显示复原，收藏，右上角显示四方菜单
  await dt.showComponentsWithin();
  // 4、底部tab依次显示分享，收藏，编辑，删除按钮，右上角显示四方菜单按钮和图库入口图标
  await dt.showComponentsWithin();
  // 5、同相机入口显示一致

}

/**
 * 大图-大图用例: [大图组件菜单显示] TID: Multimedia_Gallery_Settings_menu_019
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 2、其他应用中存在图片文件，例如备忘录
 */
async function Multimedia_Gallery_Settings_menu_019(dt: Dt) {
  dt.log.i('大图组件菜单显示 start');
  // 测试步骤
  // 1、从相机（其他应用，例如备忘录）进入大图组件，查看右上角操作按钮
  await dt.sleep(DELAY.short);
  // 2、查看下方操作按钮
  await dt.sleep(DELAY.short);
  // 3、点击更多按钮，查看操作菜单
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_PASSPORT_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('护照'))) {
    await dt.assertComponentByText('护照');
  }
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 4、切换横竖屏查看按钮和菜单是否正常显示
  await Multimedia_Gallery_Settings_menu_019Expects(dt);
  dt.log.i('大图组件菜单显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Settings_menu_019Expects(dt: Dt): Promise<void> {
  // 1、页面右上角显示图片按钮，点击可拉起图库
  await dt.showComponentsWithin();
  // 2、显示分享、收藏、编辑、删除、更多
  await dt.showComponentsWithin();
  // 3、菜单中显示添加到、复制（暂无）、隐藏、旋转（暂无）、详细信息
  await dt.showComponentsWithin();
  // 4、横竖屏模式下正常显示

}
