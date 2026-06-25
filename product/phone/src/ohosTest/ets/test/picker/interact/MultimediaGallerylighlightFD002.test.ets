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

export default function MultimediaGallerylighlightFD002(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerylighlightFD002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerylighlightFD002').init();
      dt.log.i('beforeAll MultimediaGallerylighlightFD002 start');
      dt.log.i('beforeAll MultimediaGallerylighlightFD002 finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerylighlightFD002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明

    run('MultimediaGallerylighlightFD145', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [艺术化布局界面拼图规则] TID: Multimedia_Gallery_lighlight_FD_145
      await multimediaGallerylighlightFD145(dt);
    });
    run('MultimediaGallerylighlightFD147', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [艺术化布局界面宫格图片点击进大图] TID: Multimedia_Gallery_lighlight_FD_147
      await multimediaGallerylighlightFD147(dt);
    });
    run('MultimediaGallerylighlightFD149', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [艺术化布局界面宫格图片删除/隐藏] TID: Multimedia_Gallery_lighlight_FD_149
      await multimediaGallerylighlightFD149(dt);
    });
    run('MultimediaGallerylighlightFD150', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [艺术化布局界面宫格图片分享/收藏/编辑] TID: Multimedia_Gallery_lighlight_FD_150
      await multimediaGallerylighlightFD150(dt);
    });
    run('MultimediaGallerylighlightFD151', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-沉浸用例: [进入轮播后，非沉浸式轮播模式展示分享按钮] TID: Multimedia_Gallery_lighlight_FD_151
      await multimediaGallerylighlightFD151(dt);
    });
    run('MultimediaGallerylighlightFD152', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [进入轮播后，分享视频] TID: Multimedia_Gallery_lighlight_FD_152
      await multimediaGallerylighlightFD152(dt);
    });
    run('MultimediaGallerylighlightFD153', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [进入轮播后，多次分享视频] TID: Multimedia_Gallery_lighlight_FD_153
      await multimediaGallerylighlightFD153(dt);
    });
    run('MultimediaGallerylighlightFD154', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进度条用例: [分享导出视频，进度条进度查看] TID: Multimedia_Gallery_lighlight_FD_154
      await multimediaGallerylighlightFD154(dt);
    });
    run('MultimediaGallerylighlightFD155', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-预览条用例: [进入轮播后，点击/滑动缩略图预览条后分享视频] TID: Multimedia_Gallery_lighlight_FD_155
      await multimediaGallerylighlightFD155(dt);
    });
    run('MultimediaGallerylighlightFD156', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [分享导出视频过程中，切后台/横竖屏/悬浮窗/分屏/结束图库进程] TID: Multimedia_Gallery_lighlight_FD_156
      await multimediaGallerylighlightFD156(dt);
    });
    run('MultimediaGallerylighlightFD157', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [分享导出视频过程中取消分享] TID: Multimedia_Gallery_lighlight_FD_157
      await multimediaGallerylighlightFD157(dt);
    });
    run('MultimediaGallerylighlightFD158', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [艺术化布局界面，分享视频] TID: Multimedia_Gallery_lighlight_FD_158
      await multimediaGallerylighlightFD158(dt);
    });
    run('MultimediaGallerylighlightFD159', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除/隐藏/编辑时刻图片后，分享导出视频] TID: Multimedia_Gallery_lighlight_FD_159
      await multimediaGallerylighlightFD159(dt);
    });
    run('MultimediaGallerylighlightFD160', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [分享导出后的视频查看] TID: Multimedia_Gallery_lighlight_FD_160
      await multimediaGallerylighlightFD160(dt);
    });
    run('MultimediaGallerylighlightFD161', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [精彩时刻轮播图片运镜效果展示] TID: Multimedia_Gallery_lighlight_FD_161
      await multimediaGallerylighlightFD161(dt);
    });
    run('MultimediaGallerylighlightFD162', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [精彩时刻轮播图片情绪识别] TID: Multimedia_Gallery_lighlight_FD_162
      await multimediaGallerylighlightFD162(dt);
    });
    run('MultimediaGallerylighlightFD163', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播运镜速度与照片情绪相符] TID: Multimedia_Gallery_lighlight_FD_163
      await multimediaGallerylighlightFD163(dt);
    });
    run('MultimediaGallerylighlightFD164', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [验证生成的时刻是否过滤掉负面照片] TID: Multimedia_Gallery_lighlight_FD_164
      await multimediaGallerylighlightFD164(dt);
    });
    run('MultimediaGallerylighlightFD165', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播音乐节奏与照片情绪相符] TID: Multimedia_Gallery_lighlight_FD_165
      await multimediaGallerylighlightFD165(dt);
    });
    run('MultimediaGallerylighlightFD166', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [轮播界面支持时刻封面图片分享] TID: Multimedia_Gallery_lighlight_FD_166
      await multimediaGallerylighlightFD166(dt);
    });
    run('MultimediaGallerylighlightFD167', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [二级宫格界面支持时刻封面图片分享] TID: Multimedia_Gallery_lighlight_FD_167
      await multimediaGallerylighlightFD167(dt);
    });
    run('MultimediaGallerylighlightFD168', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除/隐藏当前时刻封面照片，分享刷新后的封面图片] TID: Multimedia_Gallery_lighlight_FD_168
      await multimediaGallerylighlightFD168(dt);
    });
    run('MultimediaGallerylighlightFD169', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面分享到三方应用] TID: Multimedia_Gallery_lighlight_FD_169
      await multimediaGallerylighlightFD169(dt);
    });
    run('MultimediaGallerylighlightFD170', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [时刻封面分享图片查看] TID: Multimedia_Gallery_lighlight_FD_170
      await multimediaGallerylighlightFD170(dt);
    });
    run('MultimediaGallerylighlightFD171', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [多次删除/隐藏时刻封面照片，查看封面图片刷新情况] TID: Multimedia_Gallery_lighlight_FD_171
      await multimediaGallerylighlightFD171(dt);
    });
    run('MultimediaGallerylighlightFD172', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [时刻轮播素材包含视频] TID: Multimedia_Gallery_lighlight_FD_172
      await multimediaGallerylighlightFD172(dt);
    });
    run('MultimediaGallerylighlightFD173', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [时刻轮播素材包含视频-输出视频的规格] TID: Multimedia_Gallery_lighlight_FD_173
      await multimediaGallerylighlightFD173(dt);
    });
    run('MultimediaGallerylighlightFD174', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [时刻轮播素材包含视频-二级宫格界面视频素材展示] TID: Multimedia_Gallery_lighlight_FD_174
      await multimediaGallerylighlightFD174(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerylighlightFD002').init();
      dt.log.i('afterEach MultimediaGallerylighlightFD002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerylighlightFD002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerylighlightFD002').init();
      dt.log.i('afterAll MultimediaGallerylighlightFD002 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerylighlightFD002 finish');
    });
  });
}

// DT步骤

/**
 * 宫格-: [艺术化布局界面拼图规则]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_145
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD145(dt: Dt) {
  dt.log.i('艺术化布局界面拼图规则 start');
  dt.log.i('STEP 1、进入轮播界面后，上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1.艺术化的拼图布局以12张图片为一组，多余的按照ux设计进行组合ux设计稿：');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面拼图规则 end');
}

/**
 * 宫格-大图: [艺术化布局界面宫格图片点击进大图]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_lighlight_FD_147
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD147(dt: Dt) {
  dt.log.i('艺术化布局界面宫格图片点击进大图 start');
  dt.log.i('STEP 1、点击已生成的时刻相册，进入时刻轮播界面上滑屏幕进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、宫格缩略图支持点击进入大图，进入大图动效与照片页一致，在大图界面音乐继续');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滑动下方宫格界面，随机预选一张图片点击');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面宫格图片点击进大图 end');
}

/**
 * 宫格-大图: [艺术化布局界面进大图后返回布局界面]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_lighlight_FD_148
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD148(dt: Dt) {
  dt.log.i('艺术化布局界面进大图后返回布局界面 start');
  dt.log.i('STEP 1、点击已生成的时刻相册，进入时刻轮播界面上滑屏幕进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('STEP 2、滑动下方宫格界面，随机预选一张图片点击');

  await dt.sleep();
  dt.log.i('STEP 3、退出大图');

  await dt.sleep();
  dt.log.i('预期结果3、退出后回到艺术化布局界面，返回动效正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面进大图后返回布局界面 end');
}

run('MultimediaGallerylighlightFD148', Level.LEVEL2, async (dt: Dt): Promise<void> => {
  //  宫格-大图用例: [艺术化布局界面进大图后返回布局界面] TID: Multimedia_Gallery_lighlight_FD_148
  await multimediaGallerylighlightFD148(dt);
});

/**
 * 宫格-删除: [艺术化布局界面宫格图片删除/隐藏]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_149
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD149(dt: Dt) {
  dt.log.i('艺术化布局界面宫格图片删除/隐藏 start');
  dt.log.i('STEP 1、点击已生成的时刻相册，进入时刻轮播界面上滑屏幕进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、成功进入艺术化布局界面，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滑动下方宫格界面，随机预选一张图片删除/隐藏2.2、恢复/取消隐藏该图片');

  await dt.sleep();
  dt.log.i('预期结果2、删除/隐藏后，该图片不在时刻中显示，艺术化布局界面会立刻更新2.2恢复/取消隐藏后，该图回到时刻中，艺术化布局界面回到之前布局');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面宫格图片删除/隐藏 end');
}

/**
 * 宫格-收藏: [艺术化布局界面宫格图片分享/收藏/编辑]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_lighlight_FD_150
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD150(dt: Dt) {
  dt.log.i('艺术化布局界面宫格图片分享/收藏/编辑 start');
  dt.log.i('STEP 1、点击已生成的时刻相册，进入时刻轮播界面上滑屏幕进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1、成功进入艺术化布局界面，流畅无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滑动下方宫格界面，随机预选一张图片分享/收藏/编辑');

  await dt.sleep();
  dt.log.i('预期结果2、分享/收藏功能正常，该图片无任何变化，艺术化布局不变2.2编辑后，该图片更新为编辑后的图片，艺术化布局中刷新为编辑后的图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面宫格图片分享/收藏/编辑 end');
}

/**
 * 宫格-沉浸: [进入轮播后，非沉浸式轮播模式展示分享按钮]
 * GROUP: 宫格 MODULE: 沉浸TID: Multimedia_Gallery_lighlight_FD_151
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD151(dt: Dt) {
  dt.log.i('进入轮播后，非沉浸式轮播模式展示分享按钮 start');
  dt.log.i('STEP 1.进入轮播界面，点击屏幕切换非沉浸式模式');

  await dt.sleep();
  dt.log.i('预期结果1.轮播界面右上角显示分享按钮，可点击');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入轮播后，非沉浸式轮播模式展示分享按钮 end');
}

/**
 * 宫格-视频: [进入轮播后，分享视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_152
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD152(dt: Dt) {
  dt.log.i('进入轮播后，分享视频 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2.1 点击分享图标2.2 暂停精彩时刻播放，点击分享图标');

  await dt.sleep();
  dt.log.i('预期结果2.1.导出过程中音乐、转场、轮播均暂停，图库内存在导出的视频，导出结束轮播处于暂停状态2.2与直接导出的视频一致涉及手机、xxx');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3. 等待视频导出完成');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入轮播后，分享视频 end');
}

/**
 * 宫格-视频: [进入轮播后，多次分享视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_153
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD153(dt: Dt) {
  dt.log.i('进入轮播后，多次分享视频 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2.1 点击分享图标2.2 暂停精彩时刻播放，点击分享图标');

  await dt.sleep();
  dt.log.i('STEP 3. 导出完成后再次分享导出');

  await dt.sleep();
  dt.log.i('预期结果3.多次导出会存在多个视频涉及手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入轮播后，多次分享视频 end');
}

/**
 * 宫格-进度条: [分享导出视频，进度条进度查看]
 * GROUP: 宫格 MODULE: 进度条TID: Multimedia_Gallery_lighlight_FD_154
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD154(dt: Dt) {
  dt.log.i('分享导出视频，进度条进度查看 start');
  dt.log.i('STEP 1.进入轮播界面，点击分享保存视频');

  await dt.sleep();
  dt.log.i('预期结果1.导出时，进度条弹窗弹出，显示“视频导出中”进度正常在增加');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('视频导出中'));
  dt.log.i('STEP 2.取消保存后，再次点击分享保存视频');

  await dt.sleep();
  dt.log.i('预期结果2.取消导出时，弹出“取消导出”弹窗，进度条消失；再次点击保存时，进度条进度从0%开始');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('取消导出'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享导出视频，进度条进度查看 end');
}

/**
 * 宫格-预览条: [进入轮播后，点击/滑动缩略图预览条后分享视频]
 * GROUP: 宫格 MODULE: 预览条TID: Multimedia_Gallery_lighlight_FD_155
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD155(dt: Dt) {
  dt.log.i('进入轮播后，点击/滑动缩略图预览条后分享视频 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2. 点击/滑动缩略图预览条');

  await dt.sleep();
  dt.log.i('STEP 3. 点击分享图标');

  await dt.sleep();
  dt.log.i('STEP 4. 等待视频导出完成');

  await dt.sleep();
  dt.log.i('预期结果5.与直接导出的视频一致涉及手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入轮播后，点击/滑动缩略图预览条后分享视频 end');
}

/**
 * 宫格-竖屏: [分享导出视频过程中，切后台/横竖屏/悬浮窗/分屏/结束图库进程]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_lighlight_FD_156
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD156(dt: Dt) {
  dt.log.i('分享导出视频过程中，切后台/横竖屏/悬浮窗/分屏/结束图库进程 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2. 点击分享图标');

  await dt.sleep();
  dt.log.i('STEP 3. 切后台/横竖屏/悬浮窗/分屏/结束图库进程');

  await dt.sleep();
  dt.log.i('预期结果3.1.切后台/横竖屏/悬浮窗/分屏时，导出进程继续，有完整的视频导出3.2结束图库进程时，导出结束，无视频导出涉及手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享导出视频过程中，切后台/横竖屏/悬浮窗/分屏/结束图库进程 end');
}

/**
 * 宫格-视频: [分享导出视频过程中取消分享]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_157
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD157(dt: Dt) {
  dt.log.i('分享导出视频过程中取消分享 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2. 点击分享图标');

  await dt.sleep();
  dt.log.i('STEP 3. 点击取消/侧滑返回，取消导出视频');

  await dt.sleep();
  dt.log.i('预期结果3.不存在时刻导出的视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享导出视频过程中取消分享 end');
}

/**
 * 宫格-视频: [艺术化布局界面，分享视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_158
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD158(dt: Dt) {
  dt.log.i('艺术化布局界面，分享视频 start');
  dt.log.i('STEP 1.进入轮播界面， 上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('STEP 2.点击分享图标');

  await dt.sleep();
  dt.log.i('预期结果2.与直接导出的视频一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('艺术化布局界面，分享视频 end');
}

/**
 * 宫格-删除: [删除/隐藏/编辑时刻图片后，分享导出视频]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_159
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD159(dt: Dt) {
  dt.log.i('删除/隐藏/编辑时刻图片后，分享导出视频 start');
  dt.log.i('STEP 1. 删除/隐藏、编辑时刻的某张照片');

  await dt.sleep();
  dt.log.i('STEP 2. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 3. 点击分享图标');

  await dt.sleep();
  dt.log.i('预期结果3.1导出视频中没有出现删除/隐藏后的图片3.2导出的视频中显示的是编辑后的图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除/隐藏/编辑时刻图片后，分享导出视频 end');
}

/**
 * 宫格-视频: [分享导出后的视频查看]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_160
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD160(dt: Dt) {
  dt.log.i('分享导出后的视频查看 start');
  dt.log.i('STEP 1. 打开精彩时刻');

  await dt.sleep();
  dt.log.i('STEP 2. 点击分享图标');

  await dt.sleep();
  dt.log.i('STEP 3. 等待视频导出完成');

  await dt.sleep();
  dt.log.i('预期结果3.1导出的视频时长与轮播一遍的时长一致3.2音乐、转场、滤镜等都与轮播时一致3.3在其他三方上可正常播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享导出后的视频查看 end');
}

/**
 * 宫格-: [精彩时刻轮播图片运镜效果展示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_161
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD161(dt: Dt) {
  dt.log.i('精彩时刻轮播图片运镜效果展示 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面');

  await dt.sleep();
  dt.log.i('预期结果1.在视窗移动方向上：根据图片本身的内容，为其选择最佳呈现区域的运镜');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2. 查看运镜效果');

  await dt.sleep();
  dt.log.i('预期结果2.在视窗移动速度上，根据图片本身传递情绪差异和移动方式，选择最佳的运镜速度');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.轮播的图片裁切合适， 无关键主体被裁剪问题');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4.有不同的运镜效果展示');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5.运镜中上下拼接的照片正常无黑边裁剪等体验不好的问题');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻轮播图片运镜效果展示 end');
}

/**
 * 宫格-: [精彩时刻轮播图片情绪识别]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_162
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD162(dt: Dt) {
  dt.log.i('精彩时刻轮播图片情绪识别 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面');

  await dt.sleep();
  dt.log.i('预期结果1.在视窗移动方向上：根据图片本身的内容，为其选择最佳呈现区域的运镜');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2. 查看情绪识别效果');

  await dt.sleep();
  dt.log.i('预期结果2.在视窗移动速度上，根据图片本身传递情绪差异和移动方式，选择最佳的运镜速度');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.负向情绪图片（垃圾、墓地、血腥、惊悚…)不会进入时刻相册3.负向情绪音乐（悬疑、恐怖…)不会运用到时刻相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻轮播图片情绪识别 end');
}

/**
 * 宫格-: [时刻轮播运镜速度与照片情绪相符]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_163
 * 前置条件
 * 1、导入1k张能生成时刻的各种类型的照片
 2、充电熄屏
 */
async function multimediaGallerylighlightFD163(dt: Dt) {
  dt.log.i('时刻轮播运镜速度与照片情绪相符 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.打开图库，查看时刻轮播画面');

  await dt.sleep();
  dt.log.i('预期结果2、情绪激烈的照片运镜速度更快，一般情绪照片的运镜速度相对慢');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播运镜速度与照片情绪相符 end');
}

/**
 * 宫格-: [验证生成的时刻是否过滤掉负面照片]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_164
 * 前置条件
 * 1、导入1k张能生成时刻的各种类型的照片
 2、充电熄屏
 */
async function multimediaGallerylighlightFD164(dt: Dt) {
  dt.log.i('验证生成的时刻是否过滤掉负面照片 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.打开图库，查看时刻');

  await dt.sleep();
  dt.log.i('预期结果2、生成的时刻中没有上述负面照片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证生成的时刻是否过滤掉负面照片 end');
}

/**
 * 宫格-: [时刻轮播音乐节奏与照片情绪相符]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_165
 * 前置条件
 * 1、导入1k张能生成时刻的各种类型的照片
 2、充电熄屏
 */
async function multimediaGallerylighlightFD165(dt: Dt) {
  dt.log.i('时刻轮播音乐节奏与照片情绪相符 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.打开图库，查看时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、含情绪激烈照片的时刻音乐节奏更快，一般情绪照片的音乐节奏相对舒缓');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播音乐节奏与照片情绪相符 end');
}

/**
 * 宫格-视频: [轮播界面支持时刻封面图片分享]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_166
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD166(dt: Dt) {
  dt.log.i('轮播界面支持时刻封面图片分享 start');
  dt.log.i('STEP 1、打开图库进入时刻，点击时刻封面，进入轮播界面');

  await dt.sleep();
  dt.log.i('STEP 2、打开右上角分享菜单');

  await dt.sleep();
  dt.log.i('预期结果2.1、有2项子菜单，分别是视频分享、图片分享2.2、轮播暂停');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择图片分享');

  await dt.sleep();
  dt.log.i('预期结果3.1、正常拉起分享框3.2、分享缩略图与时刻一致，正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('轮播界面支持时刻封面图片分享 end');
}

/**
 * 宫格-视频: [二级宫格界面支持时刻封面图片分享]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_167
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD167(dt: Dt) {
  dt.log.i('二级宫格界面支持时刻封面图片分享 start');
  dt.log.i('STEP 1、点击时刻封面，在轮播界面上滑进入二级宫格界面');

  await dt.sleep();
  dt.log.i('STEP 2、打开右上角分享菜单');

  await dt.sleep();
  dt.log.i('预期结果2.1、有2项子菜单，分别是视频分享、图片分享2.2、轮播暂停');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择图片分享');

  await dt.sleep();
  dt.log.i('预期结果3.1、正常拉起分享框3.2、分享缩略图与时刻一致，正常显示3.3、封面分享功能响应时间正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('二级宫格界面支持时刻封面图片分享 end');
}

/**
 * 宫格-删除: [删除/隐藏当前时刻封面照片，分享刷新后的封面图片]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_168
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD168(dt: Dt) {
  dt.log.i('删除/隐藏当前时刻封面照片，分享刷新后的封面图片 start');
  dt.log.i('STEP 1、点击时刻封面，上滑进入二级宫格界面');

  await dt.sleep();
  dt.log.i('STEP 2、删除/隐藏第一张封面照片');

  await dt.sleep();
  dt.log.i('STEP 3、打开右上角分享菜单，选择图片分享');

  await dt.sleep();
  dt.log.i('预期结果3.1、正常拉起分享框，刷新第二张封面照片3.2、封面分享缩略图与时刻封面一致，正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除/隐藏当前时刻封面照片，分享刷新后的封面图片 end');
}

/**
 * 宫格-: [时刻封面分享到三方应用]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_169
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD169(dt: Dt) {
  dt.log.i('时刻封面分享到三方应用 start');
  dt.log.i('STEP 1、点击时刻封面，进入轮播/宫格界面');

  await dt.sleep();
  dt.log.i('STEP 2、打开右上角分享菜单，选择图片分享');

  await dt.sleep();
  dt.log.i('预期结果2.1、正常拉起分享框2.2、分享缩略图与时刻一致，正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择一个三方应用(如备忘录)，进入应用查看分享的封面图片');

  await dt.sleep();
  dt.log.i('预期结果3、分享的封面图片正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面分享到三方应用 end');
}

/**
 * 宫格-详情: [时刻封面分享图片查看]
 * GROUP: 宫格 MODULE: 详情TID: Multimedia_Gallery_lighlight_FD_170
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD170(dt: Dt) {
  dt.log.i('时刻封面分享图片查看 start');
  dt.log.i('STEP 1、点击时刻封面，进入轮播/宫格界面');

  await dt.sleep();
  dt.log.i('STEP 2、打开右上角分享菜单，选择图片分享，返回');

  await dt.sleep();
  dt.log.i('预期结果2.1、正常拉起分享框2.2、分享缩略图与时刻一致，正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入照片/相册，查看，上滑详情');

  await dt.sleep();
  dt.log.i('预期结果3、分享的封面图片正常显示，详情信息一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面分享图片查看 end');
}

/**
 * 宫格-删除: [多次删除/隐藏时刻封面照片，查看封面图片刷新情况]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_171
 * 前置条件
 * 1.时刻tab页有时刻相册生成
 */
async function multimediaGallerylighlightFD171(dt: Dt) {
  dt.log.i('多次删除/隐藏时刻封面照片，查看封面图片刷新情况 start');
  dt.log.i('STEP 1、点击时刻封面，上滑进入二级宫格界面，删除/隐藏第一张封面照片，退出二级宫格回到时刻tab页');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻相册封面刷新的第二张封面情况');

  await dt.sleep();
  dt.log.i('预期结果2、时刻相册封面正常刷新第二张封面照片，无异常，不会长时间不刷新（超1秒）4、时刻相册封面正常刷新第三张封面照片，无异常，不会长时间不刷新（超1秒）6、封面不会立马刷新，待本时刻成长的时候封面进行刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重复步骤1，删除/隐藏第二张封面照片');

  await dt.sleep();
  dt.log.i('STEP 4、查看时刻相册封面刷新的第三张封面情况');

  await dt.sleep();
  dt.log.i('预期结果4、时刻相册封面正常刷新第三张封面照片，无异常，不会长时间不刷新（超1秒）6、封面不会立马刷新，待本时刻成长的时候封面进行刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、进入相册tab页，从最近删除相册恢复删除/从隐藏相册取消隐藏的第一张封面照片');

  await dt.sleep();
  dt.log.i('STEP 6、回到时刻tab页，查看时刻相册封面刷新情况');

  await dt.sleep();
  dt.log.i('预期结果6、封面不会立马刷新，待本时刻成长的时候封面进行刷新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多次删除/隐藏时刻封面照片，查看封面图片刷新情况 end');
}

/**
 * 宫格-视频: [时刻轮播素材包含视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_172
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD172(dt: Dt) {
  dt.log.i('时刻轮播素材包含视频 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面，查看轮播中是否有视频');

  await dt.sleep();
  dt.log.i('预期结果1.时刻轮播中的素材包含视频,一个时刻最多可包含两个视频，轮播中缩略图展示格式为SDR的静态图片');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.进入时刻的视频符合该时刻的分类，且含有该分类的高光镜头');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播素材包含视频 end');
}

/**
 * 宫格-视频: [时刻轮播素材包含视频-输出视频的规格]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_173
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD173(dt: Dt) {
  dt.log.i('时刻轮播素材包含视频-输出视频的规格 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面，查看轮播中是否有视频时长');

  await dt.sleep();
  dt.log.i('预期结果1.时刻轮播中的素材包含视频，轮播中的视频时长范围为[3秒,5秒]，一个时刻最多可包含两个视频，，轮播中缩略图展示格式为SDR的静态图片');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.进入时刻的视频符合该时刻的分类，且含有该分类的高光镜头');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.视频和图片之间包含转场效果 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播素材包含视频-输出视频的规格 end');
}

/**
 * 宫格-视频: [时刻轮播素材包含视频-二级宫格界面视频素材展示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_174
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD174(dt: Dt) {
  dt.log.i('时刻轮播素材包含视频-二级宫格界面视频素材展示 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面，上滑进入艺术化布局界面');

  await dt.sleep();
  dt.log.i('预期结果1.视频素材同图片在宫格展示， 展示格式为SDR');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播素材包含视频-二级宫格界面视频素材展示 end');
}