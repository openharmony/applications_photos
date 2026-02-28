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

export default function MultimediaGalleryPcPicture(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPcPictureTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPcPicture').init();
      dt.log.i('beforeAll MultimediaGalleryPcPicture start');
      dt.log.i('beforeAll MultimediaGalleryPcPicture finish');
    });
    /**
     * 打开大图
     */
    it('beforeMultimediaGalleryPcPicture', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_PC_picture_026', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图焦点返回操作] TID: Multimedia_Gallery_PC_picture_026
      await Multimedia_Gallery_PC_picture_026(dt);
    });
    it('Multimedia_Gallery_PC_picture_027', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图焦点分享操作] TID: Multimedia_Gallery_PC_picture_027
      await Multimedia_Gallery_PC_picture_027(dt);
    });
    it('Multimedia_Gallery_PC_picture_028', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [PC大图焦点收藏操作] TID: Multimedia_Gallery_PC_picture_028
      await Multimedia_Gallery_PC_picture_028(dt);
    });
    it('Multimedia_Gallery_PC_picture_029', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图焦点编辑操作] TID: Multimedia_Gallery_PC_picture_029
      await Multimedia_Gallery_PC_picture_029(dt);
    });
    it('Multimedia_Gallery_PC_picture_030', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [PC大图焦点删除操作] TID: Multimedia_Gallery_PC_picture_030
      await Multimedia_Gallery_PC_picture_030(dt);
    });
    it('Multimedia_Gallery_PC_picture_031', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图焦点更多操作] TID: Multimedia_Gallery_PC_picture_031
      await Multimedia_Gallery_PC_picture_031(dt);
    });
    it('Multimedia_Gallery_PC_picture_032', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [PC大图焦点详情操作] TID: Multimedia_Gallery_PC_picture_032
      await Multimedia_Gallery_PC_picture_032(dt);
    });
    it('Multimedia_Gallery_PC_picture_033', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC拼图后保存跳转大图] TID: Multimedia_Gallery_PC_picture_033
      await Multimedia_Gallery_PC_picture_033(dt);
    });
    it('Multimedia_Gallery_PC_picture_034', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-沉浸用例: [PC大图进入沉浸式] TID: Multimedia_Gallery_PC_picture_034
      await Multimedia_Gallery_PC_picture_034(dt);
    });
    it('Multimedia_Gallery_PC_picture_035', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [长按拉起菜单] TID: Multimedia_Gallery_PC_picture_035
      await Multimedia_Gallery_PC_picture_035(dt);
    });
    it('Multimedia_Gallery_PC_picture_036', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [展开侧边栏移动窗口大小] TID: Multimedia_Gallery_PC_picture_036
      await Multimedia_Gallery_PC_picture_036(dt);
    });
    it('Multimedia_Gallery_PC_picture_037', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [收起侧边栏移动窗口大小] TID: Multimedia_Gallery_PC_picture_037
      await Multimedia_Gallery_PC_picture_037(dt);
    });
    it('Multimedia_Gallery_PC_picture_038', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [侧边栏展开收起按钮] TID: Multimedia_Gallery_PC_picture_038
      await Multimedia_Gallery_PC_picture_038(dt);
    });
    it('Multimedia_Gallery_PC_picture_36', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC端图库拼图完成保留侧边栏] TID: Multimedia_Gallery_PC_picture_36
      await Multimedia_Gallery_PC_picture_36(dt);
    });
    it('Multimedia_Gallery_PC_picture_37', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库宫格多选进入大图保留侧边栏] TID: Multimedia_Gallery_PC_picture_37
      await Multimedia_Gallery_PC_picture_37(dt);
    });
    it('Multimedia_Gallery_PC_picture_38', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [PC端图库拼图完成左右滑动图片保留侧边栏] TID: Multimedia_Gallery_PC_picture_38
      await Multimedia_Gallery_PC_picture_38(dt);
    });
    it('Multimedia_Gallery_PC_picture_39', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库宫格多选进入大图左右滑动图片保留侧边栏] TID: Multimedia_Gallery_PC_picture_39
      await Multimedia_Gallery_PC_picture_39(dt);
    });
    it('Multimedia_Gallery_PC_picture_44', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC端图库拼图完成点击抽屉按钮正常缩放] TID: Multimedia_Gallery_PC_picture_44
      await Multimedia_Gallery_PC_picture_44(dt);
    });
    it('Multimedia_Gallery_PC_picture_45', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库宫格多选后点击抽屉按钮正常缩放] TID: Multimedia_Gallery_PC_picture_45
      await Multimedia_Gallery_PC_picture_45(dt);
    });
    it('Multimedia_Gallery_PC_picture_46', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC端图库拼图完成下拉图片保留侧边栏] TID: Multimedia_Gallery_PC_picture_46
      await Multimedia_Gallery_PC_picture_46(dt);
    });
    it('Multimedia_Gallery_PC_picture_47', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库宫格多选下拉图片保留侧边栏] TID: Multimedia_Gallery_PC_picture_47
      await Multimedia_Gallery_PC_picture_47(dt);
    });
    it('Multimedia_Gallery_PC_picture_48', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [PC端图库大图界面拼图完成删除大图后走焦] TID: Multimedia_Gallery_PC_picture_48
      await Multimedia_Gallery_PC_picture_48(dt);
    });
    it('Multimedia_Gallery_PC_picture_49', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [PC端图库宫格界面侧边栏切换相册] TID: Multimedia_Gallery_PC_picture_49
      await Multimedia_Gallery_PC_picture_49(dt);
    });
    it('Multimedia_Gallery_PC_picture_50', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [PC端图库分屏拼图完成保留侧边栏] TID: Multimedia_Gallery_PC_picture_50
      await Multimedia_Gallery_PC_picture_50(dt);
    });
    it('Multimedia_Gallery_PC_picture_51', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库分屏宫格多选进入大图保留侧边栏] TID: Multimedia_Gallery_PC_picture_51
      await Multimedia_Gallery_PC_picture_51(dt);
    });
    it('Multimedia_Gallery_PC_picture_52', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [PC端图库分屏宫格多选进入大图沉浸式预览] TID: Multimedia_Gallery_PC_picture_52
      await Multimedia_Gallery_PC_picture_52(dt);
    });
    it('Multimedia_Gallery_PC_picture_53', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-沉浸用例: [PC端图库分屏拼图完成沉浸式预览] TID: Multimedia_Gallery_PC_picture_53
      await Multimedia_Gallery_PC_picture_53(dt);
    });
    it('Multimedia_Gallery_PC_picture_54', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [PC端图库拼图完成横竖屏切换] TID: Multimedia_Gallery_PC_picture_54
      await Multimedia_Gallery_PC_picture_54(dt);
    });
    it('Multimedia_Gallery_PC_picture_55', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [PC端图库宫格多选进入大图横竖屏切换] TID: Multimedia_Gallery_PC_picture_55
      await Multimedia_Gallery_PC_picture_55(dt);
    });
    it('Multimedia_Gallery_PC_picture_56', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [PC端图库拼图完成沉浸式预览横竖屏切换] TID: Multimedia_Gallery_PC_picture_56
      await Multimedia_Gallery_PC_picture_56(dt);
    });
    it('Multimedia_Gallery_PC_picture_57', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [PC端图库宫格多选进入大图沉浸式预览横竖屏切换] TID: Multimedia_Gallery_PC_picture_57
      await Multimedia_Gallery_PC_picture_57(dt);
    });
    it('Multimedia_Gallery_PC_picture_58', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [相机左下角缩略图进入大图沉浸式] TID: Multimedia_Gallery_PC_picture_58
      await Multimedia_Gallery_PC_picture_58(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPcPicture').init();
      dt.log.i('afterEach MultimediaGalleryPcPicture start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPcPicture finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPcPicture').init();
      dt.log.i('afterAll MultimediaGalleryPcPicture start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPcPicture finish');
    });
  });
}

// DT步骤
/**
 * 大图-大图: [PC大图焦点返回操作]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_026
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_026(dt: Dt) {
  dt.log.i('PC大图焦点返回操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在

  dt.log.i('STEP 4、焦点在返回按钮上，点击enter键');


  dt.log.i('预期结果4、从大图返回到宫格');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点返回操作 end');
}

/**
 * 大图-大图: [PC大图焦点分享操作]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_027
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_027(dt: Dt) {
  dt.log.i('PC大图焦点分享操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在

  dt.log.i('STEP 4、焦点移动到分享按钮上，点击enter键');


  dt.log.i('预期结果4、成功拉起分享框');

  // 确认组件存在

  dt.log.i('STEP 5、点击esc按钮');


  dt.log.i('预期结果5、分享框关闭，焦点恢复到分享按钮上');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点分享操作 end');
}

/**
 * 大图-收藏: [PC大图焦点收藏操作]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_picture_028
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_028(dt: Dt) {
  dt.log.i('PC大图焦点收藏操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在

  dt.log.i('STEP 4、焦点移动到收藏按钮上，点击enter键');


  dt.log.i('预期结果4、收藏图标变蓝，收藏相册增加一张图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点收藏操作 end');
}

/**
 * 大图-大图: [PC大图焦点编辑操作]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_029
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_029(dt: Dt) {
  dt.log.i('PC大图焦点编辑操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在

  dt.log.i('STEP 4、焦点移动到编辑按钮上，点击enter键');


  dt.log.i('预期结果4、从大图进入到编辑页面');

  // 确认组件存在
  await dt.swipeScreen?.left();
  dt.log.i('STEP 5、点击esc按钮');


  dt.log.i('预期结果5、返回到大图页面，焦点恢复到编辑按钮上');

  // 确认组件存在

  dt.log.i('STEP 6、再次点击enter键');


  dt.log.i('预期结果6、再次从大图进入到编辑页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点编辑操作 end');
}

/**
 * 大图-删除: [PC大图焦点删除操作]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_picture_030
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_030(dt: Dt) {
  dt.log.i('PC大图焦点删除操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在

  dt.log.i('STEP 4、焦点移动到删除按钮上，点击enter键');


  dt.log.i('预期结果4、拉起删除确认框');

  // 确认组件存在

  dt.log.i('STEP 5.1、点击esc按钮5.2、点击enter键');


  dt.log.i('预期结果5.1、删除确认框消失，焦点恢复到删除按钮上5.2、图片被正常删除移动到下一张图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点删除操作 end');
}

/**
 * 大图-大图: [PC大图焦点更多操作]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_031
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_031(dt: Dt) {
  dt.log.i('PC大图焦点更多操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('STEP 4、焦点移动到更多按钮上（四个点）');


  dt.log.i('STEP 5.1点击enter键');


  dt.log.i('STEP 6、点击上下左右方向键5.2、点击esc按钮');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点更多操作 end');
}

/**
 * 大图-详情: [PC大图焦点详情操作]
 * GROUP: 大图 MODULE: 详情TID: Multimedia_Gallery_PC_picture_032
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_032(dt: Dt) {
  dt.log.i('PC大图焦点详情操作 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点显示在侧边栏的图片与视频相册上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击tab键');


  dt.log.i('预期结果3、焦点移动到大图页面上方的操作按钮上');

  // 确认组件存在
  await dt.swipeScreen?.left();
  dt.log.i('STEP 4、焦点移动到详情按钮上，点击enter键');


  dt.log.i('预期结果4、成功拉起大图详情，焦点保持在详情按钮上');

  // 确认组件存在

  dt.log.i('STEP 5、点击esc按钮');


  dt.log.i('预期结果5、详情页面关闭，焦点保持在详情按钮上');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图焦点详情操作 end');
}

/**
 * 大图-大图: [PC拼图后保存跳转大图]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_033
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_033(dt: Dt) {
  dt.log.i('PC拼图后保存跳转大图 start');
  dt.log.i('STEP 1、宫格多选图片进行拼图');


  dt.log.i('预期结果1、大图页面显示侧边栏');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、拼图后点击保存按钮');


  dt.log.i('STEP 3、跳转到保存后的大图页面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC拼图后保存跳转大图 end');
}

/**
 * 大图-沉浸: [PC大图进入沉浸式]
 * GROUP: 大图 MODULE: 沉浸TID: Multimedia_Gallery_PC_picture_034
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_034(dt: Dt) {
  dt.log.i('PC大图进入沉浸式 start');
  dt.log.i('STEP 1、PC宫格页面打开大图');


  dt.log.i('预期结果1、大图页面保留侧边栏显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击侧边栏展开收起按钮');


  dt.log.i('预期结果2、侧边栏正常被收起');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击图片位置');

  await dt.swipeScreen?.left();
  dt.log.i('预期结果3、图片进入沉浸式，背景色变为黑色');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图进入沉浸式 end');
}

/**
 * 大图-视频: [长按拉起菜单]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_035
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_035(dt: Dt) {
  dt.log.i('长按拉起菜单 start');
  dt.log.i('STEP 1、宫格页面选中图片触屏长按');


  dt.log.i('预期结果1、成功拉起缩略图的右键菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、宫格页面点击空白位置触屏长按');


  dt.log.i('预期结果2、成功拉起粘贴菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图页面触屏长按');


  dt.log.i('预期结果3、成功拉起大图页面右键菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按拉起菜单 end');
}

/**
 * 大图-视频: [展开侧边栏移动窗口大小]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_036
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_036(dt: Dt) {
  dt.log.i('展开侧边栏移动窗口大小 start');
  dt.log.i('STEP 1、侧边栏处于展开状态');


  dt.log.i('STEP 2、拖动窗口缩小窗口宽度至断点位置');


  dt.log.i('预期结果2、侧边栏正常收起且侧边栏展开收起按钮隐藏');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拖动窗口扩大窗口宽度');

  await dt.swipeScreen?.left();
  dt.log.i('预期结果3、侧边栏正常展开侧边栏展开收起按钮出现');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('展开侧边栏移动窗口大小 end');
}

/**
 * 大图-视频: [收起侧边栏移动窗口大小]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_037
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_037(dt: Dt) {
  dt.log.i('收起侧边栏移动窗口大小 start');
  dt.log.i('STEP 1、侧边栏处于收起状态');


  dt.log.i('STEP 2、拖动窗口缩小窗口宽度至断点位置');


  dt.log.i('预期结果2、侧边栏展开收起按钮隐藏');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拖动窗口扩大窗口宽度');


  dt.log.i('预期结果3、侧边栏展开收起按钮出现');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收起侧边栏移动窗口大小 end');
}

/**
 * 大图-视频: [侧边栏展开收起按钮]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_038
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_038(dt: Dt) {
  dt.log.i('侧边栏展开收起按钮 start');
  dt.log.i('STEP 1、宫格页面点击侧边栏展开收起按钮');


  dt.log.i('预期结果1、侧边栏被正常展开和收起，页面布局显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、大图页面点击侧边栏展开收起按钮');


  dt.log.i('STEP 3、人像分类相册页面点击侧边栏展开收起按钮');


  dt.log.i('STEP 4、搜索页面点击侧边栏展开收起按钮');


  dt.log.i('STEP 5、隐藏相册页面点击侧边栏展开收起按钮');

  await dt.sleep();

  await dt.swipeScreen?.left();
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('侧边栏展开收起按钮 end');
}

/**
 * 大图-大图: [PC端图库拼图完成保留侧边栏]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_36
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_36(dt: Dt) {
  dt.log.i('PC端图库拼图完成保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');


  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成保留侧边栏 end');
}

/**
 * 大图-进入大图: [PC端图库宫格多选进入大图保留侧边栏]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_37
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_37(dt: Dt) {
  dt.log.i('PC端图库宫格多选进入大图保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');

  await dt.sleep();
  dt.log.i('预期结果2.侧边栏显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选进入大图保留侧边栏 end');
}

/**
 * 大图-滑动: [PC端图库拼图完成左右滑动图片保留侧边栏]
 * GROUP: 大图 MODULE: 滑动TID: Multimedia_Gallery_PC_picture_38
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_38(dt: Dt) {
  dt.log.i('PC端图库拼图完成左右滑动图片保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');

  await dt.swipeScreen?.left();
  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');


  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');

  // 确认组件存在

  dt.log.i('STEP 4.左右滑动大图');


  dt.log.i('预期结果4.图片滑动正常，侧边栏正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成左右滑动图片保留侧边栏 end');
}

/**
 * 大图-进入大图: [PC端图库宫格多选进入大图左右滑动图片保留侧边栏]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_39
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_39(dt: Dt) {
  dt.log.i('PC端图库宫格多选进入大图左右滑动图片保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');


  dt.log.i('预期结果2.侧边栏显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.左右滑动大图');


  dt.log.i('预期结果3.侧边栏正常切换，无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选进入大图左右滑动图片保留侧边栏 end');
}

/**
 * 大图-大图: [PC端图库拼图完成点击抽屉按钮正常缩放]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_44
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_44(dt: Dt) {
  dt.log.i('PC端图库拼图完成点击抽屉按钮正常缩放 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');

  await dt.swipeScreen?.left();
  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');


  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');

  // 确认组件存在

  dt.log.i('STEP 4.点击抽屉按钮');


  dt.log.i('预期结果4.侧边栏正常缩放，无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成点击抽屉按钮正常缩放 end');
}

/**
 * 大图-进入大图: [PC端图库宫格多选后点击抽屉按钮正常缩放]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_45
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_45(dt: Dt) {
  dt.log.i('PC端图库宫格多选后点击抽屉按钮正常缩放 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');


  dt.log.i('预期结果2.进入大图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击抽屉按钮');


  dt.log.i('预期结果3.侧边栏正常缩放，无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选后点击抽屉按钮正常缩放 end');
}

/**
 * 大图-大图: [PC端图库拼图完成下拉图片保留侧边栏]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_46
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_46(dt: Dt) {
  dt.log.i('PC端图库拼图完成下拉图片保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');

  await dt.swipeScreen?.left();
  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');

  // 确认组件存在

  dt.log.i('STEP 4.下拉图片');


  dt.log.i('预期结果4.退出到宫格页面，侧边栏正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成下拉图片保留侧边栏 end');
}

/**
 * 大图-进入大图: [PC端图库宫格多选下拉图片保留侧边栏]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_47
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_47(dt: Dt) {
  dt.log.i('PC端图库宫格多选下拉图片保留侧边栏 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');


  dt.log.i('预期结果2.进入大图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.下拉图片');


  dt.log.i('预期结果3.退出到宫格页面，侧边栏正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选下拉图片保留侧边栏 end');
}

/**
 * 大图-删除: [PC端图库大图界面拼图完成删除大图后走焦]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_picture_48
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_48(dt: Dt) {
  dt.log.i('PC端图库大图界面拼图完成删除大图后走焦 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存后删除图片');

  await dt.swipeScreen?.left();
  dt.log.i('预期结果3.侧边栏显示正常5.走焦正常');

  // 确认组件存在

  dt.log.i('STEP 4.按tab键走焦');


  dt.log.i('STEP 5.按上下方向键走焦');


  dt.log.i('预期结果5.走焦正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库大图界面拼图完成删除大图后走焦 end');
}

/**
 * 大图-: [PC端图库宫格界面侧边栏切换相册]
 * GROUP: 大图 MODULE: TID: Multimedia_Gallery_PC_picture_49
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_49(dt: Dt) {
  dt.log.i('PC端图库宫格界面侧边栏切换相册 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.侧边栏点击切换相册');

  await dt.sleep();
  dt.log.i('预期结果2.可以正常切换相册，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格界面侧边栏切换相册 end');
}

/**
 * 大图-: [PC端图库分屏拼图完成保留侧边栏]
 * GROUP: 大图 MODULE: TID: Multimedia_Gallery_PC_picture_50
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_50(dt: Dt) {
  dt.log.i('PC端图库分屏拼图完成保留侧边栏 start');
  dt.log.i('STEP 1.打开图库分屏，调节分屏线直至抽屉按钮出现');


  dt.log.i('STEP 2.点击抽屉按钮');


  dt.log.i('预期结果2.侧边栏显示正常4.进入拼图界面5.侧边栏显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入宫格页面');


  dt.log.i('STEP 4.进入多选操作选择2-9张照片进行拼图');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果4.进入拼图界面');

  // 确认组件存在

  dt.log.i('STEP 5.点击保存');


  dt.log.i('预期结果5.侧边栏显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库分屏拼图完成保留侧边栏 end');
}

/**
 * 大图-进入大图: [PC端图库分屏宫格多选进入大图保留侧边栏]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_51
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_51(dt: Dt) {
  dt.log.i('PC端图库分屏宫格多选进入大图保留侧边栏 start');
  dt.log.i('STEP 1.打开图库分屏，调节分屏线直至抽屉按钮出现');


  dt.log.i('STEP 2.点击抽屉按钮');


  dt.log.i('预期结果2.侧边栏显示正常4.侧边栏显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入宫格页面');


  dt.log.i('STEP 4.进入多选操作双击/空格进入大图');


  dt.log.i('预期结果4.侧边栏显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库分屏宫格多选进入大图保留侧边栏 end');
}

/**
 * 大图-进入大图: [PC端图库分屏宫格多选进入大图沉浸式预览]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_52
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_52(dt: Dt) {
  dt.log.i('PC端图库分屏宫格多选进入大图沉浸式预览 start');
  dt.log.i('STEP 1.打开图库分屏');


  dt.log.i('STEP 2.进入宫格页面');

  await dt.swipeScreen?.left();
  dt.log.i('STEP 3.进入多选操作双击/空格进入大图');


  dt.log.i('STEP 4.进入沉浸式预览');


  dt.log.i('预期结果4.沉浸式预览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库分屏宫格多选进入大图沉浸式预览 end');
}

/**
 * 大图-沉浸: [PC端图库分屏拼图完成沉浸式预览]
 * GROUP: 大图 MODULE: 沉浸TID: Multimedia_Gallery_PC_picture_53
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_53(dt: Dt) {
  dt.log.i('PC端图库分屏拼图完成沉浸式预览 start');
  dt.log.i('STEP 1.打开图库分屏');


  dt.log.i('STEP 2.进入宫格页面');


  dt.log.i('STEP 3.进入多选操作选择2-9张照片进行拼图');


  dt.log.i('STEP 4.点击保存');


  dt.log.i('STEP 5.进入沉浸式预览');


  dt.log.i('预期结果5.沉浸式预览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库分屏拼图完成沉浸式预览 end');
}

/**
 * 大图-竖屏: [PC端图库拼图完成横竖屏切换]
 * GROUP: 大图 MODULE: 竖屏TID: Multimedia_Gallery_PC_picture_54
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_54(dt: Dt) {
  dt.log.i('PC端图库拼图完成横竖屏切换 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');


  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');

  // 确认组件存在

  dt.log.i('STEP 4.进入大图横竖屏切换');


  dt.log.i('预期结果4.侧边栏显示正常，抽屉按钮正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成横竖屏切换 end');
}

/**
 * 大图-竖屏: [PC端图库宫格多选进入大图横竖屏切换]
 * GROUP: 大图 MODULE: 竖屏TID: Multimedia_Gallery_PC_picture_55
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_55(dt: Dt) {
  dt.log.i('PC端图库宫格多选进入大图横竖屏切换 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');


  dt.log.i('STEP 3.横竖屏切换');


  dt.log.i('预期结果3.进入到大图页面');

  // 确认组件存在

  dt.log.i('预期结果4.侧边栏显示正常，抽屉按钮正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选进入大图横竖屏切换 end');
}

/**
 * 大图-竖屏: [PC端图库拼图完成沉浸式预览横竖屏切换]
 * GROUP: 大图 MODULE: 竖屏TID: Multimedia_Gallery_PC_picture_56
 * 前置条件
 * 图库中存在照片大于9张
 */
async function Multimedia_Gallery_PC_picture_56(dt: Dt) {
  dt.log.i('PC端图库拼图完成沉浸式预览横竖屏切换 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作选择2-9张照片进行拼图');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2.进入拼图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击保存');


  dt.log.i('预期结果3.退出到大图，侧边栏正常显示');

  // 确认组件存在

  dt.log.i('STEP 4.进入沉浸式浏览大图');


  dt.log.i('预期结果4.侧边栏被收起');

  // 确认组件存在

  dt.log.i('STEP 5.横竖屏切换');


  dt.log.i('预期结果5.依然保持沉浸式预览大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库拼图完成沉浸式预览横竖屏切换 end');
}

/**
 * 大图-竖屏: [PC端图库宫格多选进入大图沉浸式预览横竖屏切换]
 * GROUP: 大图 MODULE: 竖屏TID: Multimedia_Gallery_PC_picture_57
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_57(dt: Dt) {
  dt.log.i('PC端图库宫格多选进入大图沉浸式预览横竖屏切换 start');
  dt.log.i('STEP 1.打开图库，进入宫格页面');


  dt.log.i('STEP 2.进入多选操作双击/空格进入大图');


  dt.log.i('预期结果2.进入到大图页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入沉浸式浏览大图');


  dt.log.i('预期结果3.侧边栏被收起');

  // 确认组件存在

  dt.log.i('STEP 4.横竖屏切换');


  dt.log.i('预期结果4.依然保持沉浸式预览大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端图库宫格多选进入大图沉浸式预览横竖屏切换 end');
}

/**
 * 大图-进入大图: [相机左下角缩略图进入大图沉浸式]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_picture_58
 * 前置条件
 * 图库中存在照片
 */
async function Multimedia_Gallery_PC_picture_58(dt: Dt) {
  dt.log.i('相机左下角缩略图进入大图沉浸式 start');
  dt.log.i('STEP 1.打开相机');


  dt.log.i('STEP 2.点击左下角缩略图进入大图');


  dt.log.i('STEP 3.点击图片/视频位置');


  dt.log.i('预期结果3.进入沉浸式浏览');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机左下角缩略图进入大图沉浸式 end');
}

