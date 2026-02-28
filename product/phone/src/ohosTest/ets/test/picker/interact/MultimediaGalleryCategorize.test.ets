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

export default function MultimediaGalleryCategorize(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryCategorizeTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryCategorize').init();
      dt.log.i('beforeAll MultimediaGalleryCategorize start');
      dt.log.i('beforeAll MultimediaGalleryCategorize finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryCategorize', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryCategorize004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [位置-自建、隐藏、删除、来源、智慧相册先后创建验证] TID: Multimedia_Gallery_Categorize_004
      await multimediaGalleryCategorize004(dt);
    });
    run('MultimediaGalleryCategorize005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [入口封面-大小类封面验证（仅2类、仅3类、仅4类、超4类）大类包含小类（共识别、云图云视频）、重复图依据图库存储数据] TID: Multimedia_Gallery_Categorize_005
      await multimediaGalleryCategorize005(dt);
    });
    run('MultimediaGalleryCategorize006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（隐藏、去隐藏）] TID: Multimedia_Gallery_Categorize_006
      await multimediaGalleryCategorize006(dt);
    });
    run('MultimediaGalleryCategorize007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图常规操作验证（常规、分享）] TID: Multimedia_Gallery_Categorize_007
      await multimediaGalleryCategorize007(dt);
    });
    run('MultimediaGalleryCategorize008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [分类相册动效验证] TID: Multimedia_Gallery_Categorize_008
      await multimediaGalleryCategorize008(dt);
    });
    run('MultimediaGalleryCategorize009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [入口封面-降序封面自适应验证（仅2类、仅3类、仅4类、超4类）（大小类共识别）混合操作] TID: Multimedia_Gallery_Categorize_009
      await multimediaGalleryCategorize009(dt);
    });
    run('MultimediaGalleryCategorize010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [分类相册不上云验证（云同步：隐藏恢复、自适应恢复）] TID: Multimedia_Gallery_Categorize_010
      await multimediaGalleryCategorize010(dt);
    });
    run('MultimediaGalleryCategorize011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [大小类共识别显示验证（4、5、新增、删除、去删除、隐藏、去隐藏、云同步）] TID: Multimedia_Gallery_Categorize_011
      await multimediaGalleryCategorize011(dt);
    });
    run('MultimediaGalleryCategorize012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [5大类23小类识别验证（新增、删除、去删除、隐藏、去隐藏、云同步、视频）] TID: Multimedia_Gallery_Categorize_012
      await multimediaGalleryCategorize012(dt);
    });
    run('MultimediaGalleryCategorize021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [图库分类相册横竖屏切换检查] TID: Multimedia_Gallery_Categorize_021
      await multimediaGalleryCategorize021(dt);
    });
    run('MultimediaGalleryCommondataCrate001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持显示全部相册] TID: Multimedia_Gallery_Commondata_Crate_001
      await multimediaGalleryCommondataCrate001(dt);
    });
    run('MultimediaGalleryCommondataCrate002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页相册名最大长度支持] TID: Multimedia_Gallery_Commondata_Crate_002
      await multimediaGalleryCommondataCrate002(dt);
    });
    run('MultimediaGalleryCommondataCrate003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持新建非空相册且将1个文件移动到相册] TID: Multimedia_Gallery_Commondata_Crate_003
      await multimediaGalleryCommondataCrate003(dt);
    });
    run('MultimediaGalleryCommondataCrate004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持新建非空相册且将10000个文件移动到相册] TID: Multimedia_Gallery_Commondata_Crate_004
      await multimediaGalleryCommondataCrate004(dt);
    });
    run('MultimediaGalleryCommondataCrate005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持新建非空相册且将1个文件复制到相册] TID: Multimedia_Gallery_Commondata_Crate_005
      await multimediaGalleryCommondataCrate005(dt);
    });
    run('MultimediaGalleryCommondataCrate006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持新建非空相册且将10000个文件复制到相册] TID: Multimedia_Gallery_Commondata_Crate_006
      await multimediaGalleryCommondataCrate006(dt);
    });
    run('MultimediaGalleryCommondataCrate007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库相册页支持相册重命名] TID: Multimedia_Gallery_Commondata_Crate_007
      await multimediaGalleryCommondataCrate007(dt);
    });
    run('MultimediaGalleryCommondataCrate008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [批量移动图片可靠性测试] TID: Multimedia_Gallery_Commondata_Crate_008
      await multimediaGalleryCommondataCrate008(dt);
    });
    run('MultimediaGalleryCommondataCrate009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [持续创建相册可靠性测试] TID: Multimedia_Gallery_Commondata_Crate_009
      await multimediaGalleryCommondataCrate009(dt);
    });
    run('MultimediaGalleryCommondataCrate100', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [横屏新建相册] TID: Multimedia_Gallery_Commondata_Crate_100
      await multimediaGalleryCommondataCrate100(dt);
    });
    run('MultimediaGalleryCopy001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图模式复制单个文件到剪贴板] TID: Multimedia_Gallery_Copy_001
      await multimediaGalleryCopy001(dt);
    });
    run('MultimediaGalleryCopy002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [非大图模式下复制单个文件到剪贴板] TID: Multimedia_Gallery_Copy_002
      await multimediaGalleryCopy002(dt);
    });
    run('MultimediaGalleryCopy003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [复制多个文件到剪贴板] TID: Multimedia_Gallery_Copy_003
      await multimediaGalleryCopy003(dt);
    });
    run('MultimediaGalleryCopy004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [PC在多选条件下，右击未勾选内容，复制单个文件到剪贴板] TID: Multimedia_Gallery_Copy_004
      await multimediaGalleryCopy004(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryCategorize').init();
      dt.log.i('afterEach MultimediaGalleryCategorize start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryCategorize finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryCategorize').init();
      dt.log.i('afterAll MultimediaGalleryCategorize start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryCategorize finish');
    });
  });
}

// DT步骤

/**
 * 宫格-删除: [位置-自建、隐藏、删除、来源、智慧相册先后创建验证]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_004
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize004(dt: Dt) {
  dt.log.i('位置-自建、隐藏、删除、来源、智慧相册先后创建验证 start');
  dt.log.i('STEP 1、无自建、无隐藏、无删除、无来源、仅分类相册观察界面显示');

  await dt.sleep();
  dt.log.i('预期结果1、系统相册下显示分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、创建自定义相册拷图，观察界面显示位置，删除自定义相册，观察界面显示位置');

  await dt.sleep();
  dt.log.i('预期结果2、自定义相册下显示分类相册，删除后分类相册上移显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、执行隐藏操作，观察界面显示位置，去隐藏操作，观察界面显示位置');

  await dt.sleep();
  dt.log.i('预期结果3、隐藏相册上显示分类相册，去隐藏后分类相册位置位置不变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、刷新来源相册，观察界面显示位置，删除来源相册图片，观察界面显示位置');

  await dt.sleep();
  dt.log.i('预期结果4、来源相册上方显示分类相册，删除后分类相册上移显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、操作智慧相册人像、地点、拍摄模式，观察界面显示，删除对应照片，观察界面显示');

  await dt.sleep();
  dt.log.i('预期结果5、分类相册随布局填充变化规整');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、组合1-5步骤观察界面分类相册位置');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('位置-自建、隐藏、删除、来源、智慧相册先后创建验证 end');
}

/**
 * 宫格-视频: [入口封面-大小类封面验证（仅2类、仅3类、仅4类、超4类）大类包含小类（共识别、云图云视频）、重复图依据图库存储数据]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Categorize_005
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize005(dt: Dt) {
  dt.log.i('入口封面-大小类封面验证（仅2类、仅3类、仅4类、超4类）大类包含小类（共识别、云图云视频）、重复图依据图库存储数据 start');
  dt.log.i('STEP 1、最新图大类小类均识别数量排名前2、前3、前4、前4后观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果1、封面不同位置可显示共识别图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最新视频大类小类均识别数量排名前2、前3、前4、前4后观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果2、封面不同位置可显示共识别视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、最新云图或者云视频大类小类均识别数量排名前2、前3、前4、前4后观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果3、封面不同位置可显示共识别云图云视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('入口封面-大小类封面验证（仅2类、仅3类、仅4类、超4类）大类包含小类（共识别、云图云视频）、重复图依据图库存储数据 end');
}

/**
 * 宫格-视频: [入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（隐藏、去隐藏）]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Categorize_006
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize006(dt: Dt) {
  dt.log.i('入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（隐藏、去隐藏） start');
  dt.log.i('STEP 1、仅1类场景      隐藏、去隐藏触发数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果1、封面取最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、仅2类场景      隐藏、去隐藏触发12位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果2、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、仅3类场景      隐藏、去隐藏触发123位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果3、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、仅4类场景      隐藏、去隐藏触发1234位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果4、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、超4类场景      隐藏、去隐藏触发数量变化，观察封面触发前4、前4后数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果5、封面顺序符合降序排序，前4后数量变化不影响封面，，缩略图取各类最新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（隐藏、去隐藏） end');
}

/**
 * 宫格-大图: [大图常规操作验证（常规、分享）]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Categorize_007
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize007(dt: Dt) {
  dt.log.i('大图常规操作验证（常规、分享） start');
  dt.log.i('STEP 1、进入某分类相册宫格图大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果1、图片大图浏览、小宫格滑动，常规操作均符合预期');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入某分类相册宫格视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果2、视频大图播放，小宫格滑动，常规操作均符合预期');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入某分类相册宫格云图片云视频大图浏览，依次进行常规操作');

  await dt.sleep();
  dt.log.i('预期结果3、云图云视频常规操作符合预期');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图常规操作验证（常规、分享） end');
}

/**
 * 宫格-竖屏: [分类相册动效验证]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_Categorize_008
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize008(dt: Dt) {
  dt.log.i('分类相册动效验证 start');
  dt.log.i('STEP 1、重复分类列表和分类相册观察相关动效切换、流畅度');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无卡顿，闪跳');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏切换，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果2、切换后布局规整无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分类相册动效验证 end');
}

/**
 * 宫格-删除: [入口封面-降序封面自适应验证（仅2类、仅3类、仅4类、超4类）（大小类共识别）混合操作]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_009
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize009(dt: Dt) {
  dt.log.i('入口封面-降序封面自适应验证（仅2类、仅3类、仅4类、超4类）（大小类共识别）混合操作 start');
  dt.log.i('STEP 1、仅2类场景      新增、删除、云同步、隐藏、去隐藏触发共识别数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果1、共识别不影响，封面缩略图同时显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、仅3类场景     新增、删除、云同步、隐藏、去隐藏触发共识别123位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('STEP 3、仅4类场景      新增、删除、云同步、隐藏、去隐藏触发共识别1234位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('STEP 4、超4类场景      新增、删除、云同步、隐藏、去隐藏触发共识别前4、前4后数量变化，观察封面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('入口封面-降序封面自适应验证（仅2类、仅3类、仅4类、超4类）（大小类共识别）混合操作 end');
}

/**
 * 宫格-删除: [分类相册不上云验证（云同步：隐藏恢复、自适应恢复）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_010
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize010(dt: Dt) {
  dt.log.i('分类相册不上云验证（云同步：隐藏恢复、自适应恢复） start');
  dt.log.i('STEP 1、超4类分类相册进行云同步操作，云端观察');

  await dt.sleep();
  dt.log.i('预期结果1、云端无分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、隐藏前云同步，隐藏后云同步，去隐藏云同步，云端观察');

  await dt.sleep();
  dt.log.i('预期结果2、云端无分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、移除某分类图片云同步，云端观察');

  await dt.sleep();
  dt.log.i('预期结果3、云端无分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、删除某分类图片云同步，新增某分类图片云同步，云端观察');

  await dt.sleep();
  dt.log.i('预期结果4、云端无分类相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分类相册不上云验证（云同步：隐藏恢复、自适应恢复） end');
}

/**
 * 宫格-删除: [大小类共识别显示验证（4、5、新增、删除、去删除、隐藏、去隐藏、云同步）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_011
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 4、已准备共识别图片若干分类
 */
async function multimediaGalleryCategorize011(dt: Dt) {
  dt.log.i('大小类共识别显示验证（4、5、新增、删除、去删除、隐藏、去隐藏、云同步） start');
  dt.log.i('STEP 1、已4张，新增1张共识别图片或视频观察大类小类相册显示');

  await dt.sleep();
  dt.log.i('预期结果1、大类小类同时显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、已5张，删除1张共识别图片或视频观察大类小类相册显示');

  await dt.sleep();
  dt.log.i('预期结果2、大类小类同时消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、已5张，删除1张共识别图片或视频再恢复删除，观察大类小类相册显示');

  await dt.sleep();
  dt.log.i('预期结果3、删除后大类小类同时消失，恢复后同时恢复显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、已5张，隐藏1张共识别图片或视频观察大类小类相册显示');

  await dt.sleep();
  dt.log.i('预期结果4、隐藏后大类小类同时消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、已5张，隐藏1张共识别图片或视频再去隐藏，观察大类小类相册显示');

  await dt.sleep();
  dt.log.i('预期结果5、隐藏后大类小类同时消失，去隐藏后同时恢复显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、批量新增、批量删除、全删除、批量隐藏、批量去隐藏、全隐藏，观察分类相册显示变化');

  await dt.sleep();
  dt.log.i('预期结果6、符合12345预期，全删全隐藏入口消失，恢复后恢复显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、已4张，云同步1张共识别图片或视频、批量云同步，观察分类相册显示变化');

  await dt.sleep();
  dt.log.i('预期结果7、大类小类同时显示，批量同步大小类同时更新显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大小类共识别显示验证（4、5、新增、删除、去删除、隐藏、去隐藏、云同步） end');
}

/**
 * 宫格-删除: [5大类23小类识别验证（新增、删除、去删除、隐藏、去隐藏、云同步、视频）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_012
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 4、已准备共识别图片若干分类
 */
async function multimediaGalleryCategorize012(dt: Dt) {
  dt.log.i('5大类23小类识别验证（新增、删除、去删除、隐藏、去隐藏、云同步、视频） start');
  dt.log.i('STEP 1、依次导入5大类图片识别验证     美食、风景、文档、运动、交通工具');

  await dt.sleep();
  dt.log.i('预期结果1、5大类均可正常显示分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、依次导入23小类图片识别验证      生日蛋糕、高山、花朵、城市俯瞰、夜景、建筑、瀑布、彩虹、喷泉、烟花、自由女神像、埃菲尔铁塔、东方明珠、名片、ppt、身份证、银行卡、毕业照、聚餐、猫咪、大熊猫、飞机、手表');

  await dt.sleep();
  dt.log.i('预期结果2、23小类均可正常显示分类相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、云同步图片识别大类小类验证，重复12验证云图视频');

  await dt.sleep();
  dt.log.i('预期结果3、云图视频均可正常显示分类相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('5大类23小类识别验证（新增、删除、去删除、隐藏、去隐藏、云同步、视频） end');
}

/**
 * 宫格-竖屏: [图库分类相册横竖屏切换检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_Categorize_021
 * 前置条件
 * 1、图库资源预置完成并息屏分析；
 2、形成多种不同的分类相册。
 */
async function multimediaGalleryCategorize021(dt: Dt) {
  dt.log.i('图库分类相册横竖屏切换检查 start');
  dt.log.i('STEP 1.打开图库，相册页面，手机横屏；');

  await dt.sleep();
  dt.log.i('STEP 2、点击进入分类相册，横竖屏切换。');

  await dt.sleep();
  dt.log.i('预期结果2、展示动画、切换场景等正常。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库分类相册横竖屏切换检查 end');
}

/**
 * 宫格-格式: [图库相册页支持显示全部相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate001(dt: Dt) {
  dt.log.i('图库相册页支持显示全部相册 start');
  dt.log.i('STEP 1、进入相册页面');

  await dt.sleep();
  dt.log.i('预期结果1、相册页面能正常显示全部相册列表；包括”图片”，”视频”，”我的收藏”等相册');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('图片'));
  dt.log.i('STEP 2、查看所有相册');

  await dt.sleep();
  dt.log.i('预期结果2、进入文件选择页面时应该进入图片和视频“页面，可切换至“所有相册”页面 ');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('页面，可切换至'));
  dt.log.i('STEP 3、点击右上角新建相册 ');

  await dt.sleep();
  dt.log.i('STEP 4、进入照片选择页面 确认此页面内容 ');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持显示全部相册 end');
}

/**
 * 宫格-格式: [图库相册页相册名最大长度支持]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_002
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate002(dt: Dt) {
  dt.log.i('图库相册页相册名最大长度支持 start');
  dt.log.i('STEP 1、进入相册页面，点击右上角新建相册 ');

  await dt.sleep();
  dt.log.i('预期结果1、1字节相册名创建成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、输入汉字&英文&数字&表情&符号，1字节长度的新建相册名并确认');

  await dt.sleep();
  dt.log.i('预期结果2、82字节相册名创建成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、输入汉字&英文&数字&表情&符号，82字节长度的新建相册名并确认');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页相册名最大长度支持 end');
}

/**
 * 宫格-格式: [图库相册页支持新建非空相册且将1个文件移动到相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_003
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate003(dt: Dt) {
  dt.log.i('图库相册页支持新建非空相册且将1个文件移动到相册 start');
  dt.log.i('STEP 1、进入相册页面');

  await dt.sleep();
  dt.log.i('预期结果1、能成功创建相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角新建相册 ');

  await dt.sleep();
  dt.log.i('预期结果2、支持从其他相册移动文件到新相册。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择1张图片进行移动操作 ');

  await dt.sleep();
  dt.log.i('预期结果3、移动后图片在原位置不存在');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、完成相册创建，并再次新增1张图片到新增相册');

  await dt.sleep();
  dt.log.i('预期结果4、能成功创建相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持新建非空相册且将1个文件移动到相册 end');
}

/**
 * 宫格-格式: [图库相册页支持新建非空相册且将10000个文件移动到相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_004
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate004(dt: Dt) {
  dt.log.i('图库相册页支持新建非空相册且将10000个文件移动到相册 start');
  dt.log.i('STEP 1、进入相册页面');

  await dt.sleep();
  dt.log.i('STEP 2、点击右上角新建相册，完成相册创建');

  await dt.sleep();
  dt.log.i('预期结果2、能成功创建相册2、支持从其他相册移动照片和视频到新相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击相册加号图标，拉起picker选中若干张图片＋视频，点击完成');

  await dt.sleep();
  dt.log.i('预期结果3、移动后图片原位置不存在（除所有照片和视频相册）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、并再次从其他相册移动10000张图片＋视频到新增相册');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持新建非空相册且将10000个文件移动到相册 end');
}

/**
 * 宫格-格式: [图库相册页支持新建非空相册且将1个文件复制到相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_005
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate005(dt: Dt) {
  dt.log.i('图库相册页支持新建非空相册且将1个文件复制到相册 start');
  dt.log.i('STEP 1、进入相册页面');

  await dt.sleep();
  dt.log.i('预期结果1、支持从其他相册，复制文件到新相册。复制操作时，需支持复制出新文件，而非新增相册与图片关联关系。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角新建相册 ');

  await dt.sleep();
  dt.log.i('预期结果2、复制后图片在原位置仍存在 ');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择1张图片进行复制操作 ');

  await dt.sleep();
  dt.log.i('预期结果3、能成功创建相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、完成相册创建，并再次新增复制1张图片到新增相册');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持新建非空相册且将1个文件复制到相册 end');
}

/**
 * 宫格-格式: [图库相册页支持新建非空相册且将10000个文件复制到相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_006
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate006(dt: Dt) {
  dt.log.i('图库相册页支持新建非空相册且将10000个文件复制到相册 start');
  dt.log.i('STEP 1、进入相册页面');

  await dt.sleep();
  dt.log.i('预期结果1、相册长度最高80字节，可支持汉字+英文+数字+表情+符号');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角新建相册 ');

  await dt.sleep();
  dt.log.i('预期结果2、支持从其他相册复制文件到新相册。复制操作时，需支持复制出新文件，而非新增相册与图片关联关系。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择10000张图片＋视频进行复制操作 ');

  await dt.sleep();
  dt.log.i('预期结果3、复制后图片在原位置仍存在 ');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、完成相册创建，并再次新增复制10000张图片＋视频到新增相册');

  await dt.sleep();
  dt.log.i('预期结果4、能成功创建相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持新建非空相册且将10000个文件复制到相册 end');
}

/**
 * 宫格-格式: [图库相册页支持相册重命名]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_007
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate007(dt: Dt) {
  dt.log.i('图库相册页支持相册重命名 start');
  dt.log.i('STEP 1、进入相册页面 ');

  await dt.sleep();
  dt.log.i('STEP 2、显示新建相册');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角按钮选择多选，点击重命名');

  await dt.sleep();
  dt.log.i('预期结果3、能成功重命名相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重命名名称可选择三方应用的名称 ，来源相册不支持重命名');

  await dt.sleep();
  dt.log.i('预期结果4、完成相册重命名后，主动刷新相册页显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、更改后再验证从三方应用存储照片是否会新建相册还是在改名后的相册进行');

  await dt.sleep();
  dt.log.i('预期结果5、三方应用改名后会重建一个三方应用的相册进行保存');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页支持相册重命名 end');
}

/**
 * 宫格-格式: [批量移动图片可靠性测试]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_008
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate008(dt: Dt) {
  dt.log.i('批量移动图片可靠性测试 start');
  dt.log.i('STEP 1、进入相册页');

  await dt.sleep();
  dt.log.i('预期结果1、支持从其他相册，移动图片到新建相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角新建相册');

  await dt.sleep();
  dt.log.i('预期结果2、移动过程中，界面无卡顿、无操作无响应情况，手机运行无死机、重启、crash情况');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择500张图图片进行移动操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('批量移动图片可靠性测试 end');
}

/**
 * 宫格-格式: [持续创建相册可靠性测试]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Commondata_Crate_009
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryCommondataCrate009(dt: Dt) {
  dt.log.i('持续创建相册可靠性测试 start');
  dt.log.i('STEP 1、进入相册页');

  await dt.sleep();
  dt.log.i('预期结果1、持续创建相册成功，过程中界面无卡顿、操作无响应情况，手机运行无司机、重启、crash情况');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角新建相册');

  await dt.sleep();
  dt.log.i('STEP 3、持续创建10个、100个、1000个相册');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('持续创建相册可靠性测试 end');
}

/**
 * 宫格-竖屏: [横屏新建相册]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_Commondata_Crate_100
 * 前置条件
 * 打开横竖屏开关
 */
async function multimediaGalleryCommondataCrate100(dt: Dt) {
  dt.log.i('横屏新建相册 start');
  dt.log.i('STEP 1、横屏进入图库照片页');

  await dt.sleep();
  dt.log.i('预期结果1、横屏图库布局正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击新建相册按钮+，新建相册并添加图片');

  await dt.sleep();
  dt.log.i('预期结果2、相册新建成功，并且图片移动到相机相册，相册宫格显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏新建相册 end');
}

/**
 * 宫格-大图: [大图模式复制单个文件到剪贴板]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Copy_001
 * 前置条件
 * 1、图库中至少有一张图片/视频
 */
async function multimediaGalleryCopy001(dt: Dt) {
  dt.log.i('大图模式复制单个文件到剪贴板 start');
  dt.log.i('STEP 1、打开图库应用，进入照片页/预制相册（图片、视频）选择图片进入大图模式');

  await dt.sleep();
  dt.log.i('预期结果1、进入大图模式成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击更多-点击“复制”');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片粘贴成功，图片/视频正确显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果4、图片粘贴成功，图片/视频正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图模式复制单个文件到剪贴板 end');
}

/**
 * 宫格-大图: [非大图模式下复制单个文件到剪贴板]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Copy_002
 * 前置条件
 * 1、图库中至少有一张图片/视频
 */
async function multimediaGalleryCopy002(dt: Dt) {
  dt.log.i('非大图模式下复制单个文件到剪贴板 start');
  dt.log.i('STEP 1、打开图库应用，进入照片页/预制相册（图片、视频）');

  await dt.sleep();
  dt.log.i('STEP 2、点击分享，选择一张图片，点击复制');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片粘贴成功，图片/视频正确显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果4、图片粘贴成功，图片/视频正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('非大图模式下复制单个文件到剪贴板 end');
}

/**
 * 宫格-格式: [复制多个文件到剪贴板]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Copy_003
 * 前置条件
 * 1、图库中存在不同格式的图片、视频
 */
async function multimediaGalleryCopy003(dt: Dt) {
  dt.log.i('复制多个文件到剪贴板 start');
  dt.log.i('STEP 1、打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、点击更多-点击“多选”-点击“全选”-点击“更多”（或右击图片）-点击“复制”');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC））');

  await dt.sleep();
  dt.log.i('预期结果4、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制多个文件到剪贴板 end');
}

/**
 * 宫格-格式: [PC在多选条件下，右击未勾选内容，复制单个文件到剪贴板]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Copy_004
 * 前置条件
 * 1、图库中存在不同格式的图片、视频
 */
async function multimediaGalleryCopy004(dt: Dt) {
  dt.log.i('PC在多选条件下，右击未勾选内容，复制单个文件到剪贴板 start');
  dt.log.i('STEP 1、PC打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、鼠标右击一张图片-点击“多选”-选择多张图片-在非勾选的图片上右击鼠标-点击“复制”');

  await dt.sleep();
  dt.log.i('STEP 3、打开PC文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片或视频粘贴成功，图片和视频正确显示非勾选的图片或视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果4、图片或视频粘贴成功，图片和视频正确显示非勾选的图片或视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC在多选条件下，右击未勾选内容，复制单个文件到剪贴板 end');
}
















