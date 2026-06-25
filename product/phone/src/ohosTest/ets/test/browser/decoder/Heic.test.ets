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
// 补充完成后修改为 run as it
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { Component, Driver, MatchPattern, On, ON } from '@ohos.UiTest';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 * heic相关测试用例
 */
export default function Test(): void {
  describe('HeicTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllHeicTest').init();
      dt.log.i('beforeAll HeicTest start');
      dt.log.i('beforeAll HeicTest finish');
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_009
      await Multimedia_Gallery_PhotoBrowser_HEIC_009(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图-一次性全图解码] TID: Multimedia_Gallery_PhotoBrowser_HEIC_006
      await Multimedia_Gallery_PhotoBrowser_HEIC_006(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_008
      await Multimedia_Gallery_PhotoBrowser_HEIC_008(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_007
      await Multimedia_Gallery_PhotoBrowser_HEIC_007(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_011
      await Multimedia_Gallery_PhotoBrowser_HEIC_011(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_003
      await Multimedia_Gallery_PhotoBrowser_HEIC_003(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_005
      await Multimedia_Gallery_PhotoBrowser_HEIC_005(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_004
      await Multimedia_Gallery_PhotoBrowser_HEIC_004(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_013
      await Multimedia_Gallery_PhotoBrowser_HEIC_013(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_016
      await Multimedia_Gallery_PhotoBrowser_HEIC_016(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-不预加载左右图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_015
      await Multimedia_Gallery_PhotoBrowser_HEIC_015(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图-一次性全图解码] TID: Multimedia_Gallery_PhotoBrowser_HEIC_010
      await Multimedia_Gallery_PhotoBrowser_HEIC_010(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-预加载左右图片各一张] TID: Multimedia_Gallery_PhotoBrowser_HEIC_014
      await Multimedia_Gallery_PhotoBrowser_HEIC_014(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_012
      await Multimedia_Gallery_PhotoBrowser_HEIC_012(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_058', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片手机和pc多屏协同] TID: Multimedia_Gallery_PhotoBrowser_HEIC_058
      await Multimedia_Gallery_PhotoBrowser_HEIC_058(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_017', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-宫格进大图-预加载右边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_017
      await Multimedia_Gallery_PhotoBrowser_HEIC_017(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_059', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [2w hefi端云图片下行浏览] TID: Multimedia_Gallery_PhotoBrowser_HEIC_059
      await Multimedia_Gallery_PhotoBrowser_HEIC_059(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_057', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片手机克隆到Verde] TID: Multimedia_Gallery_PhotoBrowser_HEIC_057
      await Multimedia_Gallery_PhotoBrowser_HEIC_057(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_051', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx隔空传送] TID: Multimedia_Gallery_PhotoBrowser_HEIC_051
      await Multimedia_Gallery_PhotoBrowser_HEIC_051(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_053', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片拖拽分享] TID: Multimedia_Gallery_PhotoBrowser_HEIC_053
      await Multimedia_Gallery_PhotoBrowser_HEIC_053(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_054', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片手机分享到PC] TID: Multimedia_Gallery_PhotoBrowser_HEIC_054
      await Multimedia_Gallery_PhotoBrowser_HEIC_054(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_018', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-大图向左滑动-预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_018
      await Multimedia_Gallery_PhotoBrowser_HEIC_018(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_052', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hef格式图片三方应用互通] TID: Multimedia_Gallery_PhotoBrowser_HEIC_052
      await Multimedia_Gallery_PhotoBrowser_HEIC_052(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachHeicTest').init();
      dt.log.i('afterEach HeicTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllHeicTest').init();
      await Exit.browser();
      dt.log.i('afterAll HeicTest finish');
    });
  });
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)]
 * TAG: 610 TID: Multimedia_Gallery_PhotoBrowser_HEIC_009
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积）,最长边超过16（例如：17k*17k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_009(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) start');
  dt.log.i('STEP 1、相机打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图-一次性全图解码]
 * TAG: 611 TID: Multimedia_Gallery_PhotoBrowser_HEIC_006
 * 前置条件
 * 1、预制HEIC图片分辨率(a*b)<=10K*10K(乘积），且最长边不超过16k(例如：16000*6250)
 设备：
 HL设备：KDY、OMJ、PNH、LLS
 cepi设备：PLR、PLA、PLU
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_006(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图-一次性全图解码 start');
  dt.log.i('STEP 1、相机打开大图,图片分辨率为a*b (例如（16000*6250）');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request观察图片分辨率和日志打印的分辨率是否一致');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志： submit high request {”desiredSize”:{”width”:a,”height”:b}备注：此数字为举例，具体数值和图片分辨率保持一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:a,”height”:b, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图-一次性全图解码 end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)]
 * TAG: 613 TID: Multimedia_Gallery_PhotoBrowser_HEIC_008
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积），最长边不超过16（例如：16k*7k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_008(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) start');
  dt.log.i('STEP 1、相机打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)]
 * TAG: 614 TID: Multimedia_Gallery_PhotoBrowser_HEIC_007
 * 前置条件
 * 1、预制HEICHEIC图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k（例如：17K*5K）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_007(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) start');
  dt.log.i('STEP 1、相机打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)]
 * TAG: 615 TID: Multimedia_Gallery_PhotoBrowser_HEIC_011
 * 前置条件
 * 1、预制HEIC图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k（例如：17K*5K）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_011(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) start');
  dt.log.i('STEP 1、picker打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k)]
 * TAG: 616 TID: Multimedia_Gallery_PhotoBrowser_HEIC_003
 * 前置条件
 * 1、预制HEIC图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k（例如：17K*5K）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_003(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) start');
  dt.log.i('STEP 1、宫格打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率(a*b)<=10K*10K（乘积），最长边超过16k) end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)]
 * TAG: 617 TID: Multimedia_Gallery_PhotoBrowser_HEIC_005
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积）,最长边超过16（例如：17k*17k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_005(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) start');
  dt.log.i('STEP 1、宫格打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)]
 * TAG: 618 TID: Multimedia_Gallery_PhotoBrowser_HEIC_004
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积），最长边不超过16（例如：16k*7k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_004(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) start');
  dt.log.i('STEP 1、宫格打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16)]
 * TAG: 620 TID: Multimedia_Gallery_PhotoBrowser_HEIC_013
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积）,最长边超过16（例如：17k*17k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_013(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) start');
  dt.log.i('STEP 1、picker打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积）,最长边超过16) end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-预加载左边图片]
 * TAG: 621 TID: Multimedia_Gallery_PhotoBrowser_HEIC_016
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片b为HEIC格式且<4.5k*4.5k(乘积），右边图片c为HEIC格式且>4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_016(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('STEP 3、宫格打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-不预加载左右图片]
 * TAG: 622 TID: Multimedia_Gallery_PhotoBrowser_HEIC_015
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率>=4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_015(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-不预加载左右图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('STEP 3、宫格打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、无日志打印：submit high request，{');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-不预加载左右图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图-一次性全图解码]
 * TAG: 623 TID: Multimedia_Gallery_PhotoBrowser_HEIC_010
 * 前置条件
 * 1、预制HEIC图片分辨率(a*b)<=10K*10K(乘积），且最长边不超过16k(例如：16000*6250)
 设备：
 HL设备：KDY、OMJ、PNH、LLS
 cepi设备：PLR、PLA、PLU
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_010(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图-一次性全图解码 start');
  dt.log.i('STEP 1、picker打开大图,图片分辨率为a*b (例如（16000*6250）');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request观察图片分辨率和日志打印的分辨率是否一致');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志： submit high request {”desiredSize”:{”width”:a,”height”:b}备注：此数字为举例，具体数值和图片分辨率保持一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:a,”height”:b, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图-一次性全图解码 end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-预加载左右图片各一张]
 * TAG: 624 TID: Multimedia_Gallery_PhotoBrowser_HEIC_014
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_014(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-预加载左右图片各一张 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('STEP 3、宫格打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有3条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左右图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-预加载左右图片各一张 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16)]
 * TAG: 625 TID: Multimedia_Gallery_PhotoBrowser_HEIC_012
 * 前置条件
 * 1、预制HEIC图片分辨率>=10K*10K（乘积），最长边不超过16（例如：16k*7k）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_012(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) start');
  dt.log.i('STEP 1、picker打开大图,图片分辨率为a*b');

  await dt.sleep();
  dt.log.i('预期结果1、检测点;打开大图显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看关键日志:(请求解码：)   hdc shell   hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('预期结果2、有关键日志：submit high request ，{”desiredSize”:{”width”: c,”height”:d },c,d数值范围为<=10K*10K(乘积），且最长边不超过16k，且保持原有比例');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize');
  dt.log.i('STEP 3、图库完成加载日志hilog | grep onThumbnailLoaded isCurrent');

  await dt.sleep();
  dt.log.i('预期结果3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true和”width”:c,”height”:d, ”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('width', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图降分辨率解码(图片分辨率>=10*10（乘积），最长边不超过16) end');
}

/**
 * 大图-格式: [hefi格式图片手机和pc多屏协同]
 * TAG: 626 TID: Multimedia_Gallery_PhotoBrowser_HEIC_058
 * 前置条件
 * 1、准备一部XXX手机A和pc-B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_058(dt: Dt) {
  dt.log.i('hefi格式图片手机和pc多屏协同 start');
  dt.log.i('STEP 1、A、B开启多屏协同');

  await dt.sleep();
  dt.log.i('STEP 2、分别在A、B上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果2、图片可以正常显示，操作，浏览');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片手机和pc多屏协同 end');
}

/**
 * 大图-HEIF: [HEIF图片-宫格进大图-预加载右边图片]
 * TAG: 627 TID: Multimedia_Gallery_PhotoBrowser_HEIC_017
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片为HEIC格式且>4.5k*4.5k(乘积），右边图片为HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_017(dt: Dt) {
  dt.log.i('HEIF图片-宫格进大图-预加载右边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('STEP 3、宫格打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及右边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-宫格进大图-预加载右边图片 end');
}

/**
 * 大图-端云: [2w hefi端云图片下行浏览]
 * TAG: 628 TID: Multimedia_Gallery_PhotoBrowser_HEIC_059
 * 前置条件
 * 端云账号预制不同hefi格式的图片2w加
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_059(dt: Dt) {
  dt.log.i('2w hefi端云图片下行浏览 start');
  dt.log.i('STEP 1、开启端云下行同步');

  await dt.sleep();
  dt.log.i('预期结果1、图片正常下行，无长时间白屏，云同步卡住等现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、照片页正常滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果2、宫格页照片正常滑动浏览，无长时间白块等现象');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('2w hefi端云图片下行浏览 end');
}

/**
 * 大图-格式: [hefi格式图片手机克隆到Verde]
 * TAG: 629 TID: Multimedia_Gallery_PhotoBrowser_HEIC_057
 * 前置条件
 * 1、准备一部XXX手机A和Verde-B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_057(dt: Dt) {
  dt.log.i('hefi格式图片手机克隆到Verde start');
  dt.log.i('STEP 1、A上hefi格式，克隆到B上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B上heif格式图片，克隆到A上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片手机克隆到Verde end');
}

/**
 * 大图-格式: [hefi格式图片xxx隔空传送]
 * TAG: 630 TID: Multimedia_Gallery_PhotoBrowser_HEIC_051
 * 前置条件
 *
 1、准备两台手机，,XXX手机A，B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_051(dt: Dt) {
  dt.log.i('hefi格式图片xxx隔空传送 start');
  dt.log.i('STEP 1、A手机上hefi格式，分享到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，分享到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx隔空传送 end');
}

/**
 * 大图-格式: [hefi格式图片拖拽分享]
 * TAG: 631 TID: Multimedia_Gallery_PhotoBrowser_HEIC_053
 * 前置条件
 * 图片，文件管理，存在hefi格式图片
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_053(dt: Dt) {
  dt.log.i('hefi格式图片拖拽分享 start');
  dt.log.i('STEP 1、从图库将hefi格式图片拖拽到中转站，文件管理，最底部的小艺AIbar');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从文件管理，中转站将hefi格式图片拖拽到图库');

  await dt.sleep();
  dt.log.i('预期结果2、图片显示正常，清晰');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片拖拽分享 end');
}

/**
 * 大图-格式: [hefi格式图片手机分享到PC]
 * TAG: 632 TID: Multimedia_Gallery_PhotoBrowser_HEIC_054
 * 前置条件
 * 1、准备一部XXX手机A和pc-B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_054(dt: Dt) {
  dt.log.i('hefi格式图片手机分享到PC start');
  dt.log.i('STEP 1、A上hefi格式，分享到B上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B上heif格式图片，分享到A上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片手机分享到PC end');
}

/**
 * 大图-HEIF: [HEIF图片-大图向左滑动-预加载左边图片]
 * TAG: 633 TID: Multimedia_Gallery_PhotoBrowser_HEIC_018
 * 前置条件
 * 当前停留在图片为HEIC格式的图片
 左边的左边图片为HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_018(dt: Dt) {
  dt.log.i('HEIF图片-大图向左滑动-预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep submit high request');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向左滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示清晰，无长时间加载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、”3、大图显示清晰,4、有1条日志打印：submit high request，{””desiredSize””:{””width””: c,””height””:d }，显示当前图片左边图片的分辨率”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('3、大图显示清晰,4、有1条日志打印：submit high request，{', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-大图向左滑动-预加载左边图片 end');
}

/**
 * 大图-格式: [hef格式图片三方应用互通]
 * TAG: 634 TID: Multimedia_Gallery_PhotoBrowser_HEIC_052
 * 前置条件
 * 手机下载三方应用：微信，抖音，小红书
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_052(dt: Dt) {
  dt.log.i('hef格式图片三方应用互通 start');
  dt.log.i('STEP 1、选择hefi格式图片分享覆盖top225应用：（微信，抖音，小红书，备忘录）');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片显示正常清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从三方应用（微信，抖音，小红书，备忘录）保存hefi格式图片到图库');

  await dt.sleep();
  dt.log.i('预期结果2、图片保存成功，图片显示正常清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图库内正常滑动浏览，操作');

  await dt.sleep();
  dt.log.i('预期结果3、图片可以正常滑动浏览，操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hef格式图片三方应用互通 end');
}

