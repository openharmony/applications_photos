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

export default function MultimediaGallerySmartPhotoAlbumLargeFont(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerySmartPhotoAlbumLargeFontTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerySmartPhotoAlbumLargeFont').init();
      dt.log.i('beforeAll MultimediaGallerySmartPhotoAlbumLargeFont start');
      dt.log.i('beforeAll MultimediaGallerySmartPhotoAlbumLargeFont finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerySmartPhotoAlbumLargeFont', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Smartphotoalbumlargefont_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [【大字体】来源相册删除，新增，编辑（覆盖，另存为），重命名，展开适配大字体] TID: Multimedia_Gallery_Smartphotoalbumlargefont_001
      await Multimedia_Gallery_Smartphotoalbumlargefont_001(dt);
    });
    run('Multimedia_Gallery_Smartphotoalbumlargefont_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【大字体】人像相册多选合并/移除适配大字体] TID: Multimedia_Gallery_Smartphotoalbumlargefont_002
      await Multimedia_Gallery_Smartphotoalbumlargefont_002(dt);
    });
    run('Multimedia_Gallery_Smartphotoalbumlargefont_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【大字体】人像相册添加人像界面适配大字体] TID: Multimedia_Gallery_Smartphotoalbumlargefont_003
      await Multimedia_Gallery_Smartphotoalbumlargefont_003(dt);
    });
    run('Multimedia_Gallery_Smartphotoalbumlargefont_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [【大字体】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配大字体] TID: Multimedia_Gallery_Smartphotoalbumlargefont_004
      await Multimedia_Gallery_Smartphotoalbumlargefont_004(dt);
    });
    run('Multimedia_Gallery_Smartphotoalbumlargefont_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【大字体】地图相册隐私声明适配大字体] TID: Multimedia_Gallery_Smartphotoalbumlargefont_005
      await Multimedia_Gallery_Smartphotoalbumlargefont_005(dt);
    });
    run('Multimedia_Gallery_Smartphotoalbumlargefont_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [【大字体】地点相册-地图模式缩放、拖动、旋转] TID: Multimedia_Gallery_Smartphotoalbumlargefont_006
      await Multimedia_Gallery_Smartphotoalbumlargefont_006(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerySmartPhotoAlbumLargeFont').init();
      dt.log.i('afterEach MultimediaGallerySmartPhotoAlbumLargeFont start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerySmartPhotoAlbumLargeFont finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerySmartPhotoAlbumLargeFont').init();
      dt.log.i('afterAll MultimediaGallerySmartPhotoAlbumLargeFont start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerySmartPhotoAlbumLargeFont finish');
    });
  });
}

// DT步骤
/**
 * 宫格-删除: [【大字体】来源相册删除，新增，编辑（覆盖，另存为），重命名，展开适配大字体]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Smartphotoalbumlargefont_001
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_001(dt: Dt) {
  dt.log.i('【大字体】来源相册删除，新增，编辑（覆盖，另存为），重命名，展开适配大字体 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、展开与搜索来源相册');

  await dt.sleep();
  dt.log.i('预期结果2、超过三个时，默认收起；展开与收起成功；4、5、删除拉起的弹框，新增，编辑，重命名字体适配正常。字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题6、横屏页面字体适配正常7、结果与预期结果2，3，4，5一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库相册列表，点击应用A来源相册；');

  await dt.sleep();
  dt.log.i('STEP 4、单选删除，新增，编辑（覆盖，另存为），重命名来源相册A中文件；');

  await dt.sleep();
  dt.log.i('预期结果4、5、删除拉起的弹框，新增，编辑，重命名字体适配正常。字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题6、横屏页面字体适配正常7、结果与预期结果2，3，4，5一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、多选删除，新增，编辑（覆盖，另存为），重命名删除来源A中文件；');

  await dt.sleep();
  dt.log.i('STEP 6、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果6、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、切换英文（需熄屏分析）执行操作步骤2，3，4，5');

  await dt.sleep();
  dt.log.i('预期结果7、结果与预期结果2，3，4，5一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】来源相册删除，新增，编辑（覆盖，另存为），重命名，展开适配大字体 end');
}

/**
 * 宫格-: [【大字体】人像相册多选合并/移除适配大字体]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Smartphotoalbumlargefont_002
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_002(dt: Dt) {
  dt.log.i('【大字体】人像相册多选合并/移除适配大字体 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、进入人像首页，点击多选');

  await dt.sleep();
  dt.log.i('STEP 3、选择任意多个个人相册，点击合并操作');

  await dt.sleep();
  dt.log.i('STEP 4、查看是否弹窗“是否合并？合并后将会识别为同一人”');

  await dt.sleep();
  dt.log.i('预期结果4、合并成功，拉起的弹框字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题6、移至更多人像中，拉起的弹框字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题7、横屏页面字体适配正常8、结果与预期结果4，6一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、选择任意多个或单个个人相册，点击移除');

  await dt.sleep();
  dt.log.i('STEP 6、查看弹框“是否移除x个人像？移除后，将不再显示在人像相册中”');

  await dt.sleep();
  dt.log.i('预期结果6、移至更多人像中，拉起的弹框字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果7、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、切换英文（需熄屏分析）执行操作步骤2，3，4，5，6');

  await dt.sleep();
  dt.log.i('预期结果8、结果与预期结果4，6一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】人像相册多选合并/移除适配大字体 end');
}

/**
 * 宫格-: [【大字体】人像相册添加人像界面适配大字体]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Smartphotoalbumlargefont_003
 * 前置条件
 *
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_003(dt: Dt) {
  dt.log.i('【大字体】人像相册添加人像界面适配大字体 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、进入人像相册点击更多相册');

  await dt.sleep();
  dt.log.i('STEP 3、在更多相册中点击头像');

  await dt.sleep();
  dt.log.i('预期结果3、可成功添加到人像首页，字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果4、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、切换英文（需熄屏分析）执行操作步骤2，3，4');

  await dt.sleep();
  dt.log.i('预期结果5、结果与预期结果3一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】人像相册添加人像界面适配大字体 end');
}

/**
 * 宫格-详情: [【大字体】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配大字体]
 * GROUP: 宫格 MODULE: 详情TID: Multimedia_Gallery_Smartphotoalbumlargefont_004
 * 前置条件
 * 1、打开屏幕朗读功能
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_004(dt: Dt) {
  dt.log.i('【大字体】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配大字体 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、进入分类相册');

  await dt.sleep();
  dt.log.i('预期结果2、分类相册页面字体适配正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入某分类相册宫格图大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果3、4、5、某分类相册宫格图大图浏览，视频大图浏览，宫格云图片云视频大图浏览，进入依次进行常规操作（收藏、分享、删除，编辑，移动，详情），拉起的弹框字体适配正常，标题限制放大（最大支持到2倍）无内容截断、内容叠加、丢失、省略过多，超出边界、内容对齐方式不一致、按钮不符合规范等问题6、横屏页面字体适配正常7、结果与预期结果2，3，4，5一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、进入某分类相册宫格视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('STEP 5、进入某分类相册宫格云图片云视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('STEP 6、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果6、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、切换英文（需熄屏分析）执行操作步骤2，3，4，5');

  await dt.sleep();
  dt.log.i('预期结果7、结果与预期结果2，3，4，5一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】分类相册常规操作（收藏、分享、删除，编辑，移动，详情）适配大字体 end');
}

/**
 * 宫格-: [【大字体】地图相册隐私声明适配大字体]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Smartphotoalbumlargefont_005
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_005(dt: Dt) {
  dt.log.i('【大字体】地图相册隐私声明适配大字体 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、点击地点相册，查看跳转；');

  await dt.sleep();
  dt.log.i('预期结果2、第一次进入，弹出隐私申明，界面适配正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果3、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换英文（需熄屏分析）执行操作步骤2，3，4，5');

  await dt.sleep();
  dt.log.i('预期结果4、结果与预期结果2，3一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】地图相册隐私声明适配大字体 end');
}

/**
 * 宫格-: [【大字体】地点相册-地图模式缩放、拖动、旋转]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Smartphotoalbumlargefont_006
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function Multimedia_Gallery_Smartphotoalbumlargefont_006(dt: Dt) {
  dt.log.i('【大字体】地点相册-地图模式缩放、拖动、旋转 start');
  dt.log.i('STEP 1、进入设置—辅助功能—关怀模式开启，字体调节最大');

  await dt.sleep();
  dt.log.i('STEP 2、点击地点相册，');

  await dt.sleep();
  dt.log.i('STEP 3、点击进入地点相册，查看页面显示；');

  await dt.sleep();
  dt.log.i('预期结果3、界面显示字体适配正常，背景地图显示字体适配正常，对应地点的相册字体适配展示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、拖动地图模式页面；');

  await dt.sleep();
  dt.log.i('预期结果4、拖动反馈正常，页面无异常；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、放大缩小地图模式页面；');

  await dt.sleep();
  dt.log.i('预期结果5、放大缩小反馈正常，页面无异常；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、切换至横屏查看');

  await dt.sleep();
  dt.log.i('预期结果6、横屏页面字体适配正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、切换英文（需熄屏分析）执行操作步骤2，3，4，5');

  await dt.sleep();
  dt.log.i('预期结果7、结果与预期结果3，4，5，6一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【大字体】地点相册-地图模式缩放、拖动、旋转 end');
}

