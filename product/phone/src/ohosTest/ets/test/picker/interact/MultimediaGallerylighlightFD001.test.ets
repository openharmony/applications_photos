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

export default function MultimediaGallerylighlightFD(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerylighlightFDTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerylighlightFD').init();
      dt.log.i('beforeAll MultimediaGallerylighlightFD start');
      dt.log.i('beforeAll MultimediaGallerylighlightFD finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerylighlightFD', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGallerylighlightFD114', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [时刻一级界面相册封面选择规则] TID: Multimedia_Gallery_lighlight_FD_114
      await multimediaGallerylighlightFD114(dt);
    });
    run('MultimediaGallerylighlightFD115', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [时刻一级界面全屏/深色模式/悬浮窗/分屏多窗/横竖屏状态展示] TID: Multimedia_Gallery_lighlight_FD_115
      await multimediaGallerylighlightFD115(dt);
    });
    run('MultimediaGallerylighlightFD116', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻一级界面相册封面标题展示规则] TID: Multimedia_Gallery_lighlight_FD_116
      await multimediaGallerylighlightFD116(dt);
    });
    run('MultimediaGallerylighlightFD117', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-单人人像] TID: Multimedia_Gallery_lighlight_FD_117
      await multimediaGallerylighlightFD117(dt);
    });
    run('MultimediaGallerylighlightFD118', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-宠物猫] TID: Multimedia_Gallery_lighlight_FD_118
      await multimediaGallerylighlightFD118(dt);
    });
    run('MultimediaGallerylighlightFD119', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-宠物狗] TID: Multimedia_Gallery_lighlight_FD_119
      await multimediaGallerylighlightFD119(dt);
    });
    run('MultimediaGallerylighlightFD120', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-地域美食] TID: Multimedia_Gallery_lighlight_FD_120
      await multimediaGallerylighlightFD120(dt);
    });
    run('MultimediaGallerylighlightFD121', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-生日] TID: Multimedia_Gallery_lighlight_FD_121
      await multimediaGallerylighlightFD121(dt);
    });
    run('MultimediaGallerylighlightFD122', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-毕业] TID: Multimedia_Gallery_lighlight_FD_122
      await multimediaGallerylighlightFD122(dt);
    });
    run('MultimediaGallerylighlightFD123', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-婚礼] TID: Multimedia_Gallery_lighlight_FD_123
      await multimediaGallerylighlightFD123(dt);
    });
    run('MultimediaGallerylighlightFD124', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面标题-5A景区] TID: Multimedia_Gallery_lighlight_FD_124
      await multimediaGallerylighlightFD124(dt);
    });
    run('MultimediaGallerylighlightFD125', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [时刻图片删除后，封面及轮播图片状态查看] TID: Multimedia_Gallery_lighlight_FD_125
      await multimediaGallerylighlightFD125(dt);
    });
    run('MultimediaGallerylighlightFD126', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻图片隐藏后，封面及轮播图片状态查看] TID: Multimedia_Gallery_lighlight_FD_126
      await multimediaGallerylighlightFD126(dt);
    });
    run('MultimediaGallerylighlightFD127', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻图片编辑后，封面及轮播图片状态查看] TID: Multimedia_Gallery_lighlight_FD_127
      await multimediaGallerylighlightFD127(dt);
    });
    run('MultimediaGallerylighlightFD128', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻图片为云图，退出云账号后，封面及轮播图片状态查看] TID: Multimedia_Gallery_lighlight_FD_128
      await multimediaGallerylighlightFD128(dt);
    });
    run('MultimediaGallerylighlightFD129', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播时音乐跟随播放] TID: Multimedia_Gallery_lighlight_FD_129
      await multimediaGallerylighlightFD129(dt);
    });
    run('MultimediaGallerylighlightFD130', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播图片之间的转场动效] TID: Multimedia_Gallery_lighlight_FD_130
      await multimediaGallerylighlightFD130(dt);
    });
    run('MultimediaGallerylighlightFD131', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播图片的滤镜显示] TID: Multimedia_Gallery_lighlight_FD_131
      await multimediaGallerylighlightFD131(dt);
    });
    run('MultimediaGallerylighlightFD132', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-沉浸用例: [时刻轮播界面交互-沉浸式与非沉浸式切换] TID: Multimedia_Gallery_lighlight_FD_132
      await multimediaGallerylighlightFD132(dt);
    });
    run('MultimediaGallerylighlightFD133', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-预览条用例: [时刻轮播界面交互-返回键和播放键] TID: Multimedia_Gallery_lighlight_FD_133
      await multimediaGallerylighlightFD133(dt);
    });
    run('MultimediaGallerylighlightFD134', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播界面交互-暂停轮播] TID: Multimedia_Gallery_lighlight_FD_134
      await multimediaGallerylighlightFD134(dt);
    });
    run('MultimediaGallerylighlightFD135', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播界面交互-暂停后继续播放] TID: Multimedia_Gallery_lighlight_FD_135
      await multimediaGallerylighlightFD135(dt);
    });
    run('MultimediaGallerylighlightFD136', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-预览条用例: [时刻轮播界面交互-滑动/点击缩略图预览条] TID: Multimedia_Gallery_lighlight_FD_136
      await multimediaGallerylighlightFD136(dt);
    });
    run('MultimediaGallerylighlightFD137', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [轮播界面交互-缩略图位置及状态检查，涉及横竖屏/悬浮窗/分屏状态] TID: Multimedia_Gallery_lighlight_FD_137
      await multimediaGallerylighlightFD137(dt);
    });
    run('MultimediaGallerylighlightFD141', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [进入/退出艺术化布局界面一镜到底动效深色模式/悬浮窗/分屏多窗/横竖屏状态下效果检查] TID: Multimedia_Gallery_lighlight_FD_141
      await multimediaGallerylighlightFD141(dt);
    });
    run('MultimediaGallerylighlightFD142', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [上滑进入艺术化布局界面-竖屏] TID: Multimedia_Gallery_lighlight_FD_142
      await multimediaGallerylighlightFD142(dt);
    });
    run('MultimediaGallerylighlightFD143', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [上滑进入艺术化布局界面-横屏] TID: Multimedia_Gallery_lighlight_FD_143
      await multimediaGallerylighlightFD143(dt);
    });
    run('MultimediaGallerylighlightFD144', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [上滑进入艺术化布局界面-悬浮窗/分屏多窗状态] TID: Multimedia_Gallery_lighlight_FD_144
      await multimediaGallerylighlightFD144(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerylighlightFD').init();
      dt.log.i('afterEach MultimediaGallerylighlightFD start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerylighlightFD finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerylighlightFD').init();
      dt.log.i('afterAll MultimediaGallerylighlightFD start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerylighlightFD finish');
    });
  });
}

// DT步骤
/**
 * 宫格-删除: [时刻一级界面相册封面选择规则]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_114
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少6张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD114(dt: Dt) {
  dt.log.i('时刻一级界面相册封面选择规则 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.封面选取为美学评分最高的图片，不能为视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.对封面图片进行编辑后，查看封面图片');

  await dt.sleep();
  dt.log.i('预期结果2.对封面图片进行编辑后，封面刷新展示编辑后的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.对封面图片进行删除后，查看封面图片');

  await dt.sleep();
  dt.log.i('预期结果3.对封面图片进行删除后，封面图片更换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.删除图库中所有的图片，查看时刻相册2/3/4操作后需充电灭屏分析');

  await dt.sleep();
  dt.log.i('预期结果4.时刻相册消失覆盖手机、xxx ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面相册封面选择规则 end');
}

/**
 * 宫格-竖屏: [时刻一级界面全屏/深色模式/悬浮窗/分屏多窗/横竖屏状态展示]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_lighlight_FD_115
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD115(dt: Dt) {
  dt.log.i('时刻一级界面全屏/深色模式/悬浮窗/分屏多窗/横竖屏状态展示 start');
  dt.log.i('STEP 1.切换图库至全屏/深色模式/悬浮窗/分屏多窗/横竖屏状态');

  await dt.sleep();
  dt.log.i('预期结果1.全屏/深色模式/悬浮窗/分屏多窗状态时，显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.竖屏时，生成的时刻相册大小比例为1:1;横屏时，生成的时刻相册大小比例为3:4或者4:3覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面全屏/深色模式/悬浮窗/分屏多窗/横竖屏状态展示 end');
}

/**
 * 宫格-: [时刻一级界面相册封面标题展示规则]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_116
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD116(dt: Dt) {
  dt.log.i('时刻一级界面相册封面标题展示规则 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.标题位置整体放置，根据主体/非主体物选择最佳位置横排或竖排');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.标题和主体物遮挡关系，在重叠5%~15%时主体物对标题进行遮挡，规避人脸');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.标题根据不同时刻类型对应不同字体，字号');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.艺术化封面的标题仅涉及中英文，中英文的字体');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5.封面字体显示和图片颜色不重叠，显示清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果6.时刻中副标题时间段显示与图片的时间段保持一致覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面相册封面标题展示规则 end');
}

/**
 * 宫格-: [时刻封面标题-单人人像]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_117
 * 前置条件
 * 1.图库中存在可生成人像时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD117(dt: Dt) {
  dt.log.i('时刻封面标题-单人人像 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.生成的单人人像时刻中的图片可能会存在双人或多人图片');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.若人像已命名，时刻封面标题命名为人像的命名；人像未命名，时刻封面标题命名为“人像”“身影”“掠影”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('人像'));
  dt.log.i('预期结果3.封面展示的时间为：3.1时刻相册中的图片跨的日期为1天之内或的，显示xx年xx月xx日3.2时刻相册中的图片跨的日期为1天-7天之内的，显示最开始的图片的xx年xx月xx日3.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最新图片的xx年xx月3.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年3.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.人像无艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5.可生成多个人像相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-单人人像 end');
}

/**
 * 宫格-: [时刻封面标题-宠物猫]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_118
 * 前置条件
 * 1.图库中存在可生成宠物猫时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD118(dt: Dt) {
  dt.log.i('时刻封面标题-宠物猫 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“喵星记”或者“萌宠印记”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('喵星记'));
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为1天之内或的，不显示时间2.2时刻相册中的图片跨的日期为1天-7天之内的，不显示时间2.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年xx月2.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.只生成1个相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-宠物猫 end');
}

/**
 * 宫格-: [时刻封面标题-宠物狗]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_119
 * 前置条件
 * 1.图库中存在可生成宠物狗时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD119(dt: Dt) {
  dt.log.i('时刻封面标题-宠物狗 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“汪星记”或者“萌宠印记”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('汪星记'));
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为1天之内或的，不显示时间2.2时刻相册中的图片跨的日期为1天-7天之内的，不显示时间2.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年xx月2.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.只生成1个相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-宠物狗 end');
}

/**
 * 宫格-: [时刻封面标题-地域美食]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_120
 * 前置条件
 * 1.图库中存在可生成地域美食时刻的图片，数量至20张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD120(dt: Dt) {
  dt.log.i('时刻封面标题-地域美食 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“xx味道”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('xx味道'));
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年XX月2.2时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.3时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.可生成多个美食相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-地域美食 end');
}

/**
 * 宫格-: [时刻封面标题-生日]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_121
 * 前置条件
 * 1.图库中存在可生成人像时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD121(dt: Dt) {
  dt.log.i('时刻封面标题-生日 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“生日”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('生日'));
  dt.log.i('预期结果2.时刻封面时间为“xx年xx月xx日”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('xx年xx月xx日'));
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.只生成1个时刻');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-生日 end');
}

/**
 * 宫格-: [时刻封面标题-毕业]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_122
 * 前置条件
 * 1.图库中存在可生成人像时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD122(dt: Dt) {
  dt.log.i('时刻封面标题-毕业 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“毕业了”或“校园年华”或“青春特辑”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('毕业了'));
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为1天之内或的，显示xx年xx月xx日2.2时刻相册中的图片跨的日期为1天-7天之内的，显示最开始的图片的xx年xx月xx日2.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年xx月2.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.可生成多个毕业相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-毕业 end');
}

/**
 * 宫格-: [时刻封面标题-婚礼]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_123
 * 前置条件
 * 1.图库中存在可生成人像时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD123(dt: Dt) {
  dt.log.i('时刻封面标题-婚礼 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名为“从遇见你开始”或“我们的故事”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('从遇见你开始'));
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为1天之内或的，显示xx年xx月xx日2.2时刻相册中的图片跨的日期为1天-7天之内的，显示最开始的图片的xx年xx月xx日2.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年xx月2.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.可生成多个婚礼相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-婚礼 end');
}

/**
 * 宫格-: [时刻封面标题-5A景区]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_124
 * 前置条件
 * 1.图库中存在可生成人像时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD124(dt: Dt) {
  dt.log.i('时刻封面标题-5A景区 start');
  dt.log.i('STEP 1.点击时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.时刻封面标题命名无限制');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.时刻封面时间为：2.1时刻相册中的图片跨的日期为1天之内或的，显示xx年xx月xx日2.2时刻相册中的图片跨的日期为1天-7天之内的，显示最开始的图片的xx年xx月xx日2.3时刻相册中的图片跨的日期为7天-6个月之内的，显示最开始图片的xx年xx月2.4时刻相册中的图片跨的日期为大于6个月但在一年以内的，显示年最开始图片的xx年2.5时刻相册中的图片跨的日期为大于6个月但跨了两个年份的，显示年最开始图片的xx年~xx年');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.艺术化封面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.可生成多个景区相册覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面标题-5A景区 end');
}

/**
 * 宫格-删除: [时刻图片删除后，封面及轮播图片状态查看]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_125
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD125(dt: Dt) {
  dt.log.i('时刻图片删除后，封面及轮播图片状态查看 start');
  dt.log.i('STEP 1.将所有图片移到最近删除相册后恢复所有图片');

  await dt.sleep();
  dt.log.i('预期结果1.移到最近删除相册后生成的时刻相册消失，恢复后时刻相册重新展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.将所有图片彻底删除');

  await dt.sleep();
  dt.log.i('预期结果2.生成的时刻相册消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.仅删除时刻相册的封面图片后恢复图片');

  await dt.sleep();
  dt.log.i('预期结果3.时刻封面的图片被替换，轮播时该图片不展示，恢复后该图片重新进入时刻相册（若时刻是可成长的，会重新分析，可能再次替换回来）覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻图片删除后，封面及轮播图片状态查看 end');
}

/**
 * 宫格-: [时刻图片隐藏后，封面及轮播图片状态查看]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_126
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD126(dt: Dt) {
  dt.log.i('时刻图片隐藏后，封面及轮播图片状态查看 start');
  dt.log.i('STEP 1.对生成的时刻相册非封面图片隐藏后取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果1.时刻相册里的该图片消失，轮播时该图片不展示，取消隐藏后，该图片在时刻相册中展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.对生成的时刻相册封面图片隐藏后取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果2.时刻相册封面相册被替换，轮播时该图片不展示，取消隐藏后该图片重新进入时刻相册（若时刻是可成长的，会重新分析，可能再次替换回来）覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻图片隐藏后，封面及轮播图片状态查看 end');
}

/**
 * 宫格-: [时刻图片编辑后，封面及轮播图片状态查看]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_127
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD127(dt: Dt) {
  dt.log.i('时刻图片编辑后，封面及轮播图片状态查看 start');
  dt.log.i('STEP 1.对生成的时刻相册的封面图片进行编辑（不涉及主体）');

  await dt.sleep();
  dt.log.i('预期结果1.封面和轮播时图片展示编辑后的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.对生成的时刻相册的封面图片进行编辑，对主体物进行消除，覆盖');

  await dt.sleep();
  dt.log.i('预期结果2.若封面主体物被消除，该图片会继续存在在该相册中覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻图片编辑后，封面及轮播图片状态查看 end');
}

/**
 * 宫格-: [时刻图片为云图，退出云账号后，封面及轮播图片状态查看]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_128
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD128(dt: Dt) {
  dt.log.i('时刻图片为云图，退出云账号后，封面及轮播图片状态查看 start');
  dt.log.i('STEP 1.退出云账号，图库中的云图消失');

  await dt.sleep();
  dt.log.i('预期结果1.1若生成的时刻都是云图，封面及时刻相册均不存在1.2若生成的时刻的封面是云图，封面图片被替换，相册中的云图会消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.重新登录账号，同步完成后');

  await dt.sleep();
  dt.log.i('预期结果2.1重新同步的不直接生成时刻相册， 需要重新充电灭屏分析覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻图片为云图，退出云账号后，封面及轮播图片状态查看 end');
}

/**
 * 宫格-: [时刻轮播时音乐跟随播放]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_129
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD129(dt: Dt) {
  dt.log.i('时刻轮播时音乐跟随播放 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入时刻相册，有音乐播放，1个时刻只有1个音乐');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.音乐播放结束会继续从头开始播放');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.音乐和图片转场之间有卡点效果，音乐与主题较匹配，');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播时音乐跟随播放 end');
}

/**
 * 宫格-: [时刻轮播图片之间的转场动效]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_130
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD130(dt: Dt) {
  dt.log.i('时刻轮播图片之间的转场动效 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.轮播中的图片之间有转场动效。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播图片之间的转场动效 end');
}

/**
 * 宫格-: [时刻轮播图片的滤镜显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_131
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD131(dt: Dt) {
  dt.log.i('时刻轮播图片的滤镜显示 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.轮播中的图片有滤镜显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播图片的滤镜显示 end');
}

/**
 * 宫格-沉浸: [时刻轮播界面交互-沉浸式与非沉浸式切换]
 * GROUP: 宫格 MODULE: 沉浸TID: Multimedia_Gallery_lighlight_FD_132
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD132(dt: Dt) {
  dt.log.i('时刻轮播界面交互-沉浸式与非沉浸式切换 start');
  dt.log.i('STEP 1.点击进入已生成的时刻相册');

  await dt.sleep();
  dt.log.i('预期结果1.进入非沉浸式轮播界面，状态栏不显示，时刻界面按钮显示，约2s后消失进入沉浸式轮播界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击屏幕');

  await dt.sleep();
  dt.log.i('预期结果2.切换到非沉浸式轮播界面，缩略图预览条和返回、播放按钮显示，缩略图跟随轮播切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面交互-沉浸式与非沉浸式切换 end');
}

/**
 * 宫格-预览条: [时刻轮播界面交互-返回键和播放键]
 * GROUP: 宫格 MODULE: 预览条TID: Multimedia_Gallery_lighlight_FD_133
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD133(dt: Dt) {
  dt.log.i('时刻轮播界面交互-返回键和播放键 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击非沉浸式界面的返回键和播放键');

  await dt.sleep();
  dt.log.i('预期结果2.1点击播放键时，会暂停和继续轮播，包括音乐、转场、滤镜和缩略图预览条2.2点击返回键时，会退出该时刻相册，回到时刻一级界面覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面交互-返回键和播放键 end');
}

/**
 * 宫格-: [时刻轮播界面交互-暂停轮播]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_134
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD134(dt: Dt) {
  dt.log.i('时刻轮播界面交互-暂停轮播 start');
  dt.log.i('STEP 1.点击已经生成的是时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.在轮播过程中随机点击暂停按钮');

  await dt.sleep();
  dt.log.i('预期结果2.轮播停止播放，并停留在当前预览图的界面，显示正常，图片无扭曲拉伸模糊现象，音乐也随即停止播放覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面交互-暂停轮播 end');
}

/**
 * 宫格-: [时刻轮播界面交互-暂停后继续播放]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_135
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD135(dt: Dt) {
  dt.log.i('时刻轮播界面交互-暂停后继续播放 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.在轮播过程中随机点击暂停按钮后，等待两秒后再点击继续播放');

  await dt.sleep();
  dt.log.i('预期结果2.轮播停止播放现象正常，点击继续播放按钮后，音乐接续播放无延迟无杂音，且从之前停止的部分开始播放不会从头开始播放；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.点击继续播放按钮后，图片显示正常无扭曲拉伸模糊现象，接续播放动效正常无卡顿无延迟，且从停止的那张图片开始接续播放，不会从第一张图片开始重新播放覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面交互-暂停后继续播放 end');
}

/**
 * 宫格-预览条: [时刻轮播界面交互-滑动/点击缩略图预览条]
 * GROUP: 宫格 MODULE: 预览条TID: Multimedia_Gallery_lighlight_FD_136
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD136(dt: Dt) {
  dt.log.i('时刻轮播界面交互-滑动/点击缩略图预览条 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.在轮播过程中滑动/点击任一预览图片');

  await dt.sleep();
  dt.log.i('预期结果2.轮播不会停止，图片切换动效正常，显示清晰，轮播从选中的图片开始播放，音乐播放正常无卡顿杂音，滑动效果流畅无卡顿延迟等现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.在轮播过程中点击暂停后滑动/点击任一预览图片');

  await dt.sleep();
  dt.log.i('预期结果3.轮播停止，画面显示根据滑动停留或点击的图片在当前页显示，滑动效果流畅无卡顿延迟，音乐也停止播放，覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面交互-滑动/点击缩略图预览条 end');
}

/**
 * 宫格-竖屏: [轮播界面交互-缩略图位置及状态检查，涉及横竖屏/悬浮窗/分屏状态]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_lighlight_FD_137
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD137(dt: Dt) {
  dt.log.i('轮播界面交互-缩略图位置及状态检查，涉及横竖屏/悬浮窗/分屏状态 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.竖屏状态下，播放/暂停/滑动/随机点击');

  await dt.sleep();
  dt.log.i('预期结果2.1当前画面显示的缩略图位于画面居中，和播放按钮位置水平齐平2.2当切换到该缩略图时，该缩略图变大，左右两边的缩略图略微变大覆盖手机、xxx');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.横屏状态下，播放/暂停/滑动/随机点击');

  await dt.sleep();
  dt.log.i('STEP 4.悬浮窗状态下，播放/暂停/滑动/随机点击');

  await dt.sleep();
  dt.log.i('STEP 5.分屏多窗状态下，播放/暂停/滑动/随机点击');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('轮播界面交互-缩略图位置及状态检查，涉及横竖屏/悬浮窗/分屏状态 end');
}

/**
 * 宫格-竖屏: [进入/退出艺术化布局界面一镜到底动效深色模式/悬浮窗/分屏多窗/横竖屏状态下效果检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_lighlight_FD_141
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD141(dt: Dt) {
  dt.log.i('进入/退出艺术化布局界面一镜到底动效深色模式/悬浮窗/分屏多窗/横竖屏状态下效果检查 start');
  dt.log.i('STEP 1、点击已生成的时刻相册，进入时刻播放界面');

  await dt.sleep();
  dt.log.i('预期结果1、进入艺术化布局界面，过程动效正常，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在轮播界面上滑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入/退出艺术化布局界面一镜到底动效深色模式/悬浮窗/分屏多窗/横竖屏状态下效果检查 end');
}

/**
 * 宫格-竖屏: [上滑进入艺术化布局界面-竖屏]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_lighlight_FD_142
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD142(dt: Dt) {
  dt.log.i('上滑进入艺术化布局界面-竖屏 start');
  dt.log.i('STEP 1、进入轮播界面后，上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、上半部分是轮播界面，充满屏幕轮播该时刻中的图片，有音乐，左上右上两边分别是返回和分享按钮 ');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、主题日期艺术字显示在中间位置，无缺失重叠等异常，位置正确不影响上下部分的页面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4、 下半部分是艺术化布局界面，拼图形式展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5、拼图中的图片数量与轮播中的数量一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('上滑进入艺术化布局界面-竖屏 end');
}

/**
 * 宫格-: [上滑进入艺术化布局界面-横屏]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_143
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD143(dt: Dt) {
  dt.log.i('上滑进入艺术化布局界面-横屏 start');
  dt.log.i('STEP 1、进入轮播界面后，上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、上半部分左边是轮播界面，充满大半边屏幕轮播该时刻中的图片 ，有音乐；右半部分是标题日期艺术字，铺满全屏，左上右上两边分别是返回和分享按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、 下半部分是艺术化布局界面，拼图形式展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4、拼图中的图片数量与轮播中的数量一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('上滑进入艺术化布局界面-横屏 end');
}

/**
 * 宫格-: [上滑进入艺术化布局界面-悬浮窗/分屏多窗状态]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_144
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD144(dt: Dt) {
  dt.log.i('上滑进入艺术化布局界面-悬浮窗/分屏多窗状态 start');
  dt.log.i('STEP 1、切到悬浮窗/分屏状态后进入轮播界面后，上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、上半部分是轮播界面，充满屏幕轮播该时刻中的图片，有音乐，左上右上两边分别是返回和分享按钮 ');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、主题日期艺术字显示在中间位置，无缺失重叠等异常，位置正确不影响上下部分的页面展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4、 下半部分是艺术化布局界面，拼图形式展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5、拼图中的图片数量与轮播中的数量一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('上滑进入艺术化布局界面-悬浮窗/分屏多窗状态 end');
}













