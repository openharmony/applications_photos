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

export default function DemoUi(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('DemoUiTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllDemoUi').init();
      dt.log.i('beforeAll DemoUi start');
      await AppStart.photos();
      dt.log.i('beforeAll DemoUi finish');
    });
    /**
     * 打开大图
     */
    run('beforeDemoUi', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [原有过滤能力验证] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0001
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0001(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [异常过滤：文件大小过滤] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0002
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0002(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [异常过滤：时长过滤] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0003
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0003(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [异常过滤：非可过滤格式内容] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0004
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0004(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [多选：单一过滤（图片）] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0005
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0005(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [多选：单一过滤（视频）] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0006
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0006(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [多选：单一过滤(image/*,video/*,*/*,image/movingPhoto)] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0007
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0007(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [多选：同时过滤两种] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0008
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0008(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [多选:同时过滤三种] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0009
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0009(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [多选:同时过滤5种] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0010
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0010(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [过滤文件大小验证] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0011
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0011(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [过滤时长验证] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0012
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0012(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [较精准过滤] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0013
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0013(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0014', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [精准过滤（央视号移动生产通用限制、记者号移动生产通用限制）] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0014
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0014(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [性能测试：并发过滤性能（文件格式，文件大小，时间长短）] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0015
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0015(dt);
    });
    run('Multimedia_Gallery_PhotoPickerFilterEnhance_0016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-heif用例: [编辑后，再过滤] TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0016
      await Multimedia_Gallery_PhotoPickerFilterEnhance_0016(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDemoUi').init();
      dt.log.i('afterEach DemoUi start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach DemoUi finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDemoUi').init();
      dt.log.i('afterAll DemoUi start');
      await Exit.browser();
      dt.log.i('afterAll DemoUi finish');
    });
  });
}

// DT步骤
/**
 * picker-heif: [原有过滤能力验证]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0001
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0001(dt: Dt) {
  dt.log.i('原有过滤能力验证 start');
  dt.log.i('STEP 1.过滤的类型选择image/*,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1.正常拉起picker,且只能看到图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.过滤的类型选择video/*,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2.正常拉起picker,且只能看到视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.过滤的类型选择*/*,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.正常拉起picker,可以看到视频和图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.过滤的类型选择image/movingPhoto,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果4.正常拉起picker,且只可以看到动态图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('原有过滤能力验证 end');
}

/**
 * picker-heif: [异常过滤：文件大小过滤]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0002
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0002(dt: Dt) {
  dt.log.i('异常过滤：文件大小过滤 start');
  dt.log.i('STEP 1、demo内选择过滤格式为*/*,文件大小设置为小于0');

  await dt.sleep();
  dt.log.i('STEP 2、demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起picker后无法看到过滤的图片,并有toast提示该操作为无效输入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo内选择过滤格式为*/*,文件大小设置10000000<0<4400000(文件大小默认为byte)');

  await dt.sleep();
  dt.log.i('预期结果3、拉起picker后无法看到过滤的图片，并有toast提示该操作为无效输入');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('异常过滤：文件大小过滤 end');
}

/**
 * picker-heif: [异常过滤：时长过滤]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0003
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0003(dt: Dt) {
  dt.log.i('异常过滤：时长过滤 start');
  dt.log.i('STEP 1、demo内选择过滤格式为*/*,文件时长设置为小于0');

  await dt.sleep();
  dt.log.i('STEP 2、demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起picker后无法看到过滤的图片,并有toast提示该操作为无效输入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo内选择过滤格式为*/*,文件时长设置300000<0<60000(文件时长单位默认为ms)');

  await dt.sleep();
  dt.log.i('预期结果3、拉起picker后无法看到过滤的图片，并有toast提示该操作为无效输入');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('异常过滤：时长过滤 end');
}

/**
 * picker-格式: [异常过滤：非可过滤格式内容]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0004
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0004(dt: Dt) {
  dt.log.i('异常过滤：非可过滤格式内容 start');
  dt.log.i('STEP 1、demo内选择过滤格式输入111');

  await dt.sleep();
  dt.log.i('预期结果1、拉起picker后无法看到过滤的图片,并有toast提示该操作为无效输入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo内选择过滤格式输入dongtaitupian');

  await dt.sleep();
  dt.log.i('预期结果2、拉起picker后无法看到过滤的图片,并有toast提示该操作为无效输入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo内选择过滤格式输入image/ico');

  await dt.sleep();
  dt.log.i('预期结果3、拉起picker后无法看到过滤的图片,并有toast提示该操作为无效输入(如果为‘*/*’过滤，可以查看到ico格式的资源)');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('异常过滤：非可过滤格式内容 end');
}

/**
 * picker-heif: [多选：单一过滤（图片）]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0005
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0005(dt: Dt) {
  dt.log.i('多选：单一过滤（图片） start');
  dt.log.i('STEP 1、demo内选择过滤格式输入image/jpeg或 image/jpg ,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1-7  拉起picker只可看到被过滤的格式的图片（如选择‘image/gif’拉起picker就只可以看到gif的图片）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo内选择过滤格式输入image/gif,demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 3、demo内选择过滤格式输入image/png,demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 4、demo内选择过滤格式输入image/heic 或 image/heif ,demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 5、demo内选择过滤格式输入image/bmp,demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 6、demo内选择过滤格式输入image/webp,demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 7、demo内选择过滤格式输入image/avif,demo拉起picker');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选：单一过滤（图片） end');
}

/**
 * picker-视频: [多选：单一过滤（视频）]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0006
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0006(dt: Dt) {
  dt.log.i('多选：单一过滤（视频） start');
  dt.log.i('STEP 1、demo内选择过滤格式输入video/mp4,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1、2拉起picker只可看到被过滤的格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo内选择过滤格式输入video/mov,demo拉起picker');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选：单一过滤（视频） end');
}

/**
 * picker-heif: [多选：单一过滤(image/*,video/*,image/movingPhoto)]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0007
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3、资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0007(dt: Dt) {
  dt.log.i('多选：单一过滤(image/*,video/*,*/*,image/movingPhoto) start');
  dt.log.i('STEP 1、demo多选选择过滤格式输入video/mp4,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picker可以看到图库中所有MP4格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo多选选择过滤格式输入video/*,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、可以看到图库中所有视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo多选选择过滤格式输入*/*,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3、可以看到图库中所有的图片和视频');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、demo多选选择过滤格式输入image/movingPhoto,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果4、可以看到图库中所有的动态照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选：单一过滤(image/*,video/*,*/*,image/movingPhoto) end');
}

/**
 * picker-heif: [多选：同时过滤两种]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0008
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0008(dt: Dt) {
  dt.log.i('多选：同时过滤两种 start');
  dt.log.i('STEP 1、demo多选选择过滤格式输入image/jpg,image/gif,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picke仅可以看到图库中所有jpg,gif格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo多选选择过滤格式输入image/png,image/heic,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picker仅可以看到图库中所有png,heic格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo多选选择过滤格式输入image/heic,image/heif,demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3、拉起的picker仅可以看到图库中所有heif,heic格式的资源');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选：同时过滤两种 end');
}

/**
 * picker-heif: [多选:同时过滤三种]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0009
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0009(dt: Dt) {
  dt.log.i('多选:同时过滤三种 start');
  dt.log.i('STEP 1、demo多选选择过滤格式输入image/jpg,image/gif,image/pngdemo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picke仅可以看到图库中所有jpg,gif,png格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo多选选择过滤格式输入image/png,image/heic,video/mp4demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picker仅可以看到图库中所有png,heic,mp4格式的资源');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选:同时过滤三种 end');
}

/**
 * picker-heif: [多选:同时过滤5种]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0010
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0010(dt: Dt) {
  dt.log.i('多选:同时过滤5种 start');
  dt.log.i('STEP 1、demo多选选择过滤格式输入image/jpg,image/gif,image/png,image/heic,video/mp4demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picke仅可以看到图库中所有jpg,gif,png,heic,mp4格式的资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo多选选择过滤格式输入image/png,image/heic,image/bmp,image/avif,video/movdemo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picker仅可以看到图库中所有png,heic,bmp,avif,mov格式的资源');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选:同时过滤5种 end');
}

/**
 * picker-heif: [过滤文件大小验证]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0011
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0011(dt: Dt) {
  dt.log.i('过滤文件大小验证 start');
  dt.log.i('STEP 1、demo内选择过滤格式为*/*,文件大小设置为等于0');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picke无法看到图库中任何资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo内选择过滤格式为*/*,文件大小设置为不等于0');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picke可以看到图库中任何资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo内选择过滤格式为*/*,文件大小设置大于等于0');

  await dt.sleep();
  dt.log.i('预期结果3、拉起的picke可以看到图库中任何资源');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、demo内选择过滤格式为*/*,指定范围1000000<X<6000000(x为所过滤的文件大小所在的范围)');

  await dt.sleep();
  dt.log.i('预期结果4、拉起的picke可以看到图库中文件大小在1000000到6000000byte之间的图片和视频');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('过滤文件大小验证 end');
}

/**
 * picker-heif: [过滤时长验证]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0012
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0012(dt: Dt) {
  dt.log.i('过滤时长验证 start');
  dt.log.i('STEP 1、demo内选择过滤格式为*/*,文件时长设置为等于0');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picke无法看到图库中任何资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo内选择过滤格式为*/*,文件时长设置为不等于0');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picke可以看到图库中任何资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo内选择过滤格式为*/*,文件时长设置小于等于300000');

  await dt.sleep();
  dt.log.i('预期结果3、拉起的picke可以看到图库中时长小于300000ms的任何资源');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、demo内选择过滤格式为*/*,指定时长范围3000<X<10000(x为所过滤的文件大小所在的范围)');

  await dt.sleep();
  dt.log.i('预期结果4、拉起的picke可以看到图库中文件大小在3000ms到10000ms之间的图片和视频');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('过滤时长验证 end');
}

/**
 * picker-heif: [较精准过滤]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0013
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0013(dt: Dt) {
  dt.log.i('较精准过滤 start');
  dt.log.i('STEP 1、demo内选择过滤格式为video/mp4,video/mov,且文件大小设置为大于209,715,200byte(200MB)，小于524,288,000byte(500MB),时长大于60000ms(1min)小于3600000ms(1h)');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的picker可以过滤到符合约束条件（测试步骤中所描述的限制）的内容');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、1、demo内选择过滤格式为video/mp4,video/mov,且时长大于60000ms(1min)小于3600000ms(1h)');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picker可以过滤到符合约束条件（测试步骤中所描述的限制）的内容');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('较精准过滤 end');
}

/**
 * picker-heif: [精准过滤（央视号移动生产通用限制、记者号移动生产通用限制）]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0014
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0014(dt: Dt) {
  dt.log.i('精准过滤（央视号移动生产通用限制、记者号移动生产通用限制） start');
  dt.log.i('STEP 1、demo内选择过滤格式为image/jpg,image/jpeg,image/png,image/bmp,image/gif,image/webp,heic,avif，‘video/*’且文件大小设置为大于209,715,200byte(200MB)，小于524,288,000byte(500MB)');

  await dt.sleep();
  dt.log.i('预期结果1.拉起的picker可以过滤出图库中文件大小大于209,715,200byte(200MB)，小于524,288,000byte(500MB)且格式为,jpg,jpeg,png,bmp,gif,webp,heic,avif,以及所有文件大小在该范围内的视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、demo中选择过滤格式为‘image/jpg’,image/jpeg,image/png,image/gif,image/heic,且文件大小为524,288,00（50MB），视频格式为video/mp4,video/mov且文件大小为4,307,550,208‬字节（4G）');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的picker仅过滤出符合过滤条件的内容');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精准过滤（央视号移动生产通用限制、记者号移动生产通用限制） end');
}

/**
 * picker-格式: [性能测试：并发过滤性能（文件格式，文件大小，时间长短）]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerFilterEnhance_0015
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0015(dt: Dt) {
  dt.log.i('性能测试：并发过滤性能（文件格式，文件大小，时间长短） start');
  dt.log.i('STEP 1、demo选择过滤格式video/*,且文件大小大于0，查看拉起性能');

  await dt.sleep();
  dt.log.i('预期结果1、拉取性能符合要求');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('性能测试：并发过滤性能（文件格式，文件大小，时间长短） end');
}

/**
 * picker-heif: [编辑后，再过滤]
 * GROUP: picker MODULE: heifTID: Multimedia_Gallery_PhotoPickerFilterEnhance_0016
 * 前置条件
 * 1、安装demo
 2、图库有各种格式的图片和视频,包含但不限于（movingPhoto,jpeg/jpg,gif,png,heic,heif,bmp,webp,avif,mp4,mov）
 3.资源账号50W
 */
async function Multimedia_Gallery_PhotoPickerFilterEnhance_0016(dt: Dt) {
  dt.log.i('编辑后，再过滤 start');
  dt.log.i('STEP 1、demo选择过滤格式image/heic,拉起picker,查看数量');

  await dt.sleep();
  dt.log.i('STEP 2、图库中选择一张heic编辑后（如涂鸦）另存为，拉起pikcer，查看数量');

  await dt.sleep();
  dt.log.i('预期结果2，中拉起的picker比一中拉起的picker查询的数量多一个');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑后，再过滤 end');
}
