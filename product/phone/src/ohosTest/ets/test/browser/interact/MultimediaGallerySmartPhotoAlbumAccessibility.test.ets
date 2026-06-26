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

export default function MultimediaGallerySmartPhotoAlbumAccessibility(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerySmartPhotoAlbumAccessibilityTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerySmartPhotoAlbumAccessibility').init();
      dt.log.i('beforeAll MultimediaGallerySmartPhotoAlbumAccessibility start');
      dt.log.i('beforeAll MultimediaGallerySmartPhotoAlbumAccessibility finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerySmartPhotoAlbumAccessibility', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [【屏幕朗读】图库相册内宫格控件检测适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_001
      await Multimedia_Gallery_SmartphotoalbumAccessibility_001(dt);
    });
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【屏幕朗读】人像相册页控件适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_002
      await Multimedia_Gallery_SmartphotoalbumAccessibility_002(dt);
    });
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【屏幕朗读】地点相册地图模式适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_003
      await Multimedia_Gallery_SmartphotoalbumAccessibility_003(dt);
    });
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【屏幕朗读】地点相册城市模式适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_004
      await Multimedia_Gallery_SmartphotoalbumAccessibility_004(dt);
    });
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [【屏幕朗读】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_005
      await Multimedia_Gallery_SmartphotoalbumAccessibility_005(dt);
    });
    run('Multimedia_Gallery_SmartphotoalbumAccessibility_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [【屏幕朗读】来源相册页控件适配无障碍] TID: Multimedia_Gallery_SmartphotoalbumAccessibility_006
      await Multimedia_Gallery_SmartphotoalbumAccessibility_006(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerySmartPhotoAlbumAccessibility').init();
      dt.log.i('afterEach MultimediaGallerySmartPhotoAlbumAccessibility start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerySmartPhotoAlbumAccessibility finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerySmartPhotoAlbumAccessibility').init();
      dt.log.i('afterAll MultimediaGallerySmartPhotoAlbumAccessibility start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerySmartPhotoAlbumAccessibility finish');
    });
  });
}

// DT步骤
/**
 * 宫格-大图: [【屏幕朗读】图库相册内宫格控件检测适配无障碍]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_SmartphotoalbumAccessibility_001
 * 前置条件
 * 打开屏幕朗读功能
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_001(dt: Dt) {
  dt.log.i('【屏幕朗读】图库相册内宫格控件检测适配无障碍 start');
  dt.log.i('STEP 1、进入人像相册，分类相册，地点相册和来源相册宫格页面，大图页面点击多选控件');

  await dt.sleep();
  dt.log.i('预期结果1、点击选择控件后可以正常播报 多选，双击可正常执行，进入多选页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左滑屏幕');

  await dt.sleep();
  dt.log.i('预期结果2、移动下一项进行语音播报');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双击屏幕');

  await dt.sleep();
  dt.log.i('预期结果3、可以正常执行');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在界面上单指不抬手触摸浏览');

  await dt.sleep();
  dt.log.i('预期结果4、依次播报界面控件信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');

  await dt.sleep();
  dt.log.i('预期结果5、聚焦到下一个元素进行播放控件信息关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】图库相册内宫格控件检测适配无障碍 end');
}

/**
 * 宫格-: [【屏幕朗读】人像相册页控件适配无障碍]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SmartphotoalbumAccessibility_002
 * 前置条件
 * 打开屏幕朗读功能
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_002(dt: Dt) {
  dt.log.i('【屏幕朗读】人像相册页控件适配无障碍 start');
  dt.log.i('STEP 1、打开图库，点击人像相册控件3、点击添加人像控件4、点击更多控件5、点击移除控件6、点击合并控件7、在界面上单指不抬手触摸浏览8、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');

  await dt.sleep();
  dt.log.i('预期结果1、点击选择控件后可以正常播报，双击可正常执行，进入人像相册');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、点击选择控件后可以正常播报，双击可正常执行，切换到添加人像界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击添加人像控件');

  await dt.sleep();
  dt.log.i('预期结果3、点击选择控件后可以正常播报，双击可正常执行，切换到更多界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击更多控件');

  await dt.sleep();
  dt.log.i('预期结果4、点击选择控件后可以正常播报，双击可正常执行，拉起移除相册弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击移除控件');

  await dt.sleep();
  dt.log.i('预期结果5、点击选择控件后可以正常播报，双击可正常执行，拉起合并相册弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击合并控件');

  await dt.sleep();
  dt.log.i('预期结果6、在界面上单指不抬手触摸浏览');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、在界面上单指不抬手触摸浏览');

  await dt.sleep();
  dt.log.i('预期结果7、聚焦页面首个元素后，抬手单指向右扫动，循环扫动关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】人像相册页控件适配无障碍 end');
}

/**
 * 宫格-: [【屏幕朗读】地点相册地图模式适配无障碍]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SmartphotoalbumAccessibility_003
 * 前置条件
 * 1.打开屏幕朗读功能
 2.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_003(dt: Dt) {
  dt.log.i('【屏幕朗读】地点相册地图模式适配无障碍 start');
  dt.log.i('STEP 1、点击进入地点相册地图模式');

  await dt.sleep();
  dt.log.i('预期结果1、点击选择控件后可以正常播报，双击可正常执行，进入地图相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在界面上单指不抬手触摸浏览');

  await dt.sleep();
  dt.log.i('预期结果2、依次播报界面控件信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');

  await dt.sleep();
  dt.log.i('预期结果3、聚焦到下一个元素进行播放控件信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、地图模式下，点击地图某地点相册缩略图');

  await dt.sleep();
  dt.log.i('预期结果4、点击选择控件后可以正常播报，双击可正常执行，跳转至地点相册照片宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击任一照片查看');

  await dt.sleep();
  dt.log.i('预期结果5、点击选择控件后可以正常播报，双击可正常执行，照片查看正常关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】地点相册地图模式适配无障碍 end');
}

/**
 * 宫格-: [【屏幕朗读】地点相册城市模式适配无障碍]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SmartphotoalbumAccessibility_004
 * 前置条件
 * 1.打开屏幕朗读功能
 2.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 3.地点相册存在2城市照片数目相同；
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_004(dt: Dt) {
  dt.log.i('【屏幕朗读】地点相册城市模式适配无障碍 start');
  dt.log.i('STEP 1、点击进入地点相册；');

  await dt.sleep();
  dt.log.i('预期结果1、点击选择控件后可以正常播报，双击可正常执行，进入地图相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到城市模式；');

  await dt.sleep();
  dt.log.i('预期结果2、点击选择控件后可以正常播报，双击可正常执行，跳转至城市模式宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在界面上单指不抬手触摸浏览');

  await dt.sleep();
  dt.log.i('预期结果3、在界面上单指不抬手触摸浏览');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');

  await dt.sleep();
  dt.log.i('预期结果4、聚焦页面首个元素后，抬手单指向右扫动，循环扫动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击任一城市查看');

  await dt.sleep();
  dt.log.i('预期结果5、点击选择控件后可以正常播报，双击可正常执行，进入城市相册宫格界面关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】地点相册城市模式适配无障碍 end');
}

/**
 * 宫格-详情: [【屏幕朗读】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配无障碍]
 * GROUP: 宫格 MODULE: 详情TID: Multimedia_Gallery_SmartphotoalbumAccessibility_005
 * 前置条件
 * 1、打开屏幕朗读功能
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_005(dt: Dt) {
  dt.log.i('【屏幕朗读】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配无障碍 start');
  dt.log.i('STEP 1、进入某分类相册宫格图大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果1、某分类相册宫格图大图浏览，点击选择控件后可以正常播报，双击可正常执行，进入依次进行常规操作（收藏、分享、删除，编辑，移动，详情）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入某分类相册宫格视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果2、进入某分类相册宫格视频大图浏览，点击选择控件后可以正常播报，双击可正常执行，依次进行常规操作（收藏、分享、删除，编辑，移动，详情）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入某分类相册宫格云图片云视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果3、进入某分类相册宫格云图片云视频大图浏览，点击选择控件后可以正常播报，双击可正常执行，依次进行常规操作（收藏、分享、删除，编辑，移动，详情）关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配无障碍 end');
}

/**
 * 宫格-滑动: [【屏幕朗读】来源相册页控件适配无障碍]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_SmartphotoalbumAccessibility_006
 * 前置条件
 * 1.打开屏幕朗读功能
 2.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 3.地点相册存在2城市照片数目相同；
 */
async function Multimedia_Gallery_SmartphotoalbumAccessibility_006(dt: Dt) {
  dt.log.i('【屏幕朗读】来源相册页控件适配无障碍 start');
  dt.log.i('STEP 1.进入图库相册列表；');

  await dt.sleep();
  dt.log.i('预期结果1、点击选择控件后可以正常播报，双击可正常执行，进入相册页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.多次点击来源相册展开收起按钮，查看页面及动效；');

  await dt.sleep();
  dt.log.i('预期结果2、点击选择控件后可以正常播报，双击可正常执行，展开收起正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.重复进入返回来源相册照片列表页；');

  await dt.sleep();
  dt.log.i('预期结果3、界面存在焦点，焦点正常播报');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.来源相册照片列表页反复上下滑动；');

  await dt.sleep();
  dt.log.i('预期结果4、上下滑动丝滑，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.点击照片视频进行大图/沉浸式浏览；');

  await dt.sleep();
  dt.log.i('预期结果5、点击选择控件后可以正常播报，双击可正常执行浏览关注点：无障碍朗读适配正常，不会出现朗读错误、朗读缺失、朗读冗余、播报中断、朗读优化、朗读清晰度等问题无障碍焦点点击正常，不会出现焦点缺失、存在底层焦点、焦点陷阱、焦点冗余、焦点被重置、焦点位置不精确、大焦点覆盖、焦点拆分过细、焦点顺序、焦点记忆、焦点停留位置不当、焦点跳变等问题。无障碍控件显示正常，不会出现未加标签、控件类型缺失、控件状态缺失、操作提示缺失、控件标签错误、控件类型错误、控件状态错误、控件操作提示错误、标签内容冗余、控件类型冗余、控件状态冗余、操作提示冗余、控件响应结果无法感知、控件未响应读屏手势、控件状态发生变化时，需主动播报状态变化信息等问题。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【屏幕朗读】来源相册页控件适配无障碍 end');
}


