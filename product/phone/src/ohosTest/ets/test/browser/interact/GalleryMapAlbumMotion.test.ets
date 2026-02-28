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

export default function GalleryMapAlbumMotion(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryMapAlbumMotionTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGalleryMapAlbumMotion').init();
      dt.log.i('beforeAll GalleryMapAlbumMotion start');
      dt.log.i('beforeAll GalleryMapAlbumMotion finish');
    });
    /**
     * 打开大图
     */
    it('beforeGalleryMapAlbumMotion', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('ani_GalleryEditorEffec_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [首次进入编辑] TID: ani_GalleryEditorEffec_001
      await ani_GalleryEditorEffec_001(dt);
    });
    it('ani_GalleryEditorEffec_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [左滑退出] TID: ani_GalleryEditorEffec_002
      await ani_GalleryEditorEffec_002(dt);
    });
    it('ani_GalleryEditorEffec_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [保存后退出] TID: ani_GalleryEditorEffec_007
      await ani_GalleryEditorEffec_007(dt);
    });
    it('ani_GalleryEditorEffec_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [复原后退出] TID: ani_GalleryEditorEffec_008
      await ani_GalleryEditorEffec_008(dt);
    });
    it('ani_GalleryEditorEffect_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [截取、裁剪、调节、滤镜菜单切换动效] TID: ani_GalleryEditorEffect_003
      await ani_GalleryEditorEffect_003(dt);
    });
    it('ani_GalleryEditorEffect_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [调节、滤镜二级菜单滑动动效] TID: ani_GalleryEditorEffect_004
      await ani_GalleryEditorEffect_004(dt);
    });
    it('ani_GalleryEditorEffect_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [单指移动、双指放到缩小动效] TID: ani_GalleryEditorEffect_005
      await ani_GalleryEditorEffect_005(dt);
    });
    it('ani_GalleryEditorEffect_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [截取页面滑动滑块，白色指针裁剪动效] TID: ani_GalleryEditorEffect_006
      await ani_GalleryEditorEffect_006(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryMapAlbumMotion').init();
      dt.log.i('afterEach GalleryMapAlbumMotion start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryMapAlbumMotion finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryMapAlbumMotion').init();
      dt.log.i('afterAll GalleryMapAlbumMotion start');
      await Exit.browser();
      dt.log.i('afterAll GalleryMapAlbumMotion finish');
    });
  });
}

// DT步骤
/**
 * 大图-视频: [首次进入编辑]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryEditorEffec_001
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffec_001(dt: Dt) {
  dt.log.i('首次进入编辑 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频，点击编辑按钮');


  dt.log.i('STEP 2、观察首次进入编辑页面动效');

  await dt.sleep();
  dt.log.i('预期结果2.1、有一镜到底动效，无黑化闪跳、拉伸变形，无卡顿丢帧2.2、过渡流畅自然，符合动效规范');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次进入编辑 end');
}

/**
 * 大图-视频: [左滑退出]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryEditorEffec_002
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffec_002(dt: Dt) {
  dt.log.i('左滑退出 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频，点击编辑按钮');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、编辑页面不做任何操作，左滑返回');


  dt.log.i('STEP 3、观察直接返回到图库的动效');


  dt.log.i('预期结果3.1、有一镜到底动效，无黑化闪跳、拉伸变形，无卡顿丢帧3.2、过渡流畅自然，符合动效规范');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('左滑退出 end');
}

/**
 * 大图-视频: [保存后退出]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryEditorEffec_007
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffec_007(dt: Dt) {
  dt.log.i('保存后退出 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频，点击编辑按钮');


  dt.log.i('STEP 2、编辑页面进行截取、裁剪、调节、滤镜操作');


  dt.log.i('STEP 3、点击保存按钮，另存为新视频（图片无另存，视频需要截取才可以另存）');


  dt.log.i('STEP 4、观察直接返回到图库的动效');


  dt.log.i('预期结果4.1、有一镜到底动效，无黑化闪跳、拉伸变形，无卡顿丢帧4.2、过渡流畅自然，符合动效规范');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('保存后退出 end');
}

/**
 * 大图-视频: [复原后退出]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryEditorEffec_008
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffec_008(dt: Dt) {
  dt.log.i('复原后退出 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频，点击编辑按钮');


  dt.log.i('STEP 2、编辑页面进行截取、裁剪、调节、滤镜操作（图片无截取功能）');


  dt.log.i('STEP 3、点击保存按钮，覆盖原图片/视频');


  dt.log.i('STEP 4、覆盖保存成功的视频，点击编辑按钮');


  dt.log.i('STEP 5、编辑页面点击复原按钮');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 6、观察直接返回到图库的动效');


  dt.log.i('预期结果6.1、有一镜到底动效，无黑化闪跳、拉伸变形，无卡顿丢帧6.2、过渡流畅自然，符合动效规范');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复原后退出 end');
}

/**
 * 大图-视频: [截取、裁剪、调节、滤镜菜单切换动效]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryEditorEffect_003
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffect_003(dt: Dt) {
  dt.log.i('截取、裁剪、调节、滤镜菜单切换动效 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频');


  dt.log.i('STEP 2、点击编辑按钮');


  dt.log.i('STEP 3、来回点击“截取”，“裁剪”，“调节”，“滤镜” 切换一级菜单（图片无截取功能）');


  dt.log.i('STEP 4、观察动效');


  dt.log.i('预期结果4.1、选中态有细微的遮罩动画4.2、界面切换平滑，无明显较大帧跳变，毛刺，抖动等4.3、无黑白花屏，视觉闪跳现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截取、裁剪、调节、滤镜菜单切换动效 end');
}

/**
 * 大图-滑动: [调节、滤镜二级菜单滑动动效]
 * GROUP: 大图 MODULE: 滑动TID: ani_GalleryEditorEffect_004
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffect_004(dt: Dt) {
  dt.log.i('调节、滤镜二级菜单滑动动效 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频');


  dt.log.i('预期结果1、移动到边缘时继续拖动受到弹簧力影响快速回弹，离手后有一定的速度，滑动过程中产生移动惯性');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击编辑，切换到调节页面');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2、滑动过程中平滑无抖动、毛刺，无闪跳');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、滑动调节项二级菜单，观察动效');


  dt.log.i('STEP 4、切换到滤镜页面，滑动滤镜项二级菜单，观察动效');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('调节、滤镜二级菜单滑动动效 end');
}

/**
 * 大图-滑动: [单指移动、双指放到缩小动效]
 * GROUP: 大图 MODULE: 滑动TID: ani_GalleryEditorEffect_005
 * 前置条件
 * 1、图库已导入图片和视频素材
 */
async function ani_GalleryEditorEffect_005(dt: Dt) {
  dt.log.i('单指移动、双指放到缩小动效 start');
  dt.log.i('STEP 1、打开图库，选择图片/视频');


  dt.log.i('STEP 2、点击编辑按钮');


  dt.log.i('STEP 3、图片在裁剪界面，视频在截取页面，单指移动（抛滑、拖拽滑）/ 双指缩放预览区，观察动效');


  dt.log.i('预期结果3.1、单指移动不触边，跟手比率1:1，离手后若有初速度，继承手速，产生移动惯性，做匀速运动触边，离手后有弹簧力效果，产生回弹，跟手比例变为2:13.2、双指缩放未缩放到极值，以两个触点的中心点缩放，离手瞬间继承手速缩放，产生惯性效果，离手后做匀减速继续缩放缩放到极值，离手瞬间，继承手速继续缩放，触发惯性效果，离手阶段有弹簧力效果，缩放速度变为0后开始回弹到极值大小3.3、滑动过程中平滑无抖动、毛刺，无闪跳');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('单指移动、双指放到缩小动效 end');
}

/**
 * 大图-滑动: [截取页面滑动滑块，白色指针裁剪动效]
 * GROUP: 大图 MODULE: 滑动TID: ani_GalleryEditorEffect_006
 * 前置条件
 * 1、图库已导入视频素材
 */
async function ani_GalleryEditorEffect_006(dt: Dt) {
  dt.log.i('截取页面滑动滑块，白色指针裁剪动效 start');
  dt.log.i('STEP 1、打开图库，选择视频');


  dt.log.i('STEP 2、点击编辑按钮');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 3、在截取页面，滑动滑块进行截取');


  dt.log.i('预期结果3.1、滑动滑块时，时间指针隐藏，松手后出现在拖动手柄处3.2、长按并拖动、可触发沉浸式、单击不触发沉浸式');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在截取页面，滑动白色指针');


  dt.log.i('预期结果4、滑动过程中平滑无抖动、毛刺，无闪跳');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截取页面滑动滑块，白色指针裁剪动效 end');
}

