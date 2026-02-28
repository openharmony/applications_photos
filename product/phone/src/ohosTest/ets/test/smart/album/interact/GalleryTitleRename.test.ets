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

export default function GalleryTitleRenameTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryTitleRenameTestTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllGalleryTitleRenameTest').init();
      dt.log.i('beforeAll GalleryTitleRenameTest start');
      await AppStart.photos();
      dt.log.i('beforeAll GalleryTitleRenameTest finish');
    });
    /**
     * 打开大图
     */
    run('beforeGalleryTitleRenameTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    run('Multimedia_Gallery_TitleRename_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻列表首页长按触发重命名] TID: Multimedia_Gallery_TitleRename_001
      await Multimedia_Gallery_TitleRename_001(dt);
    });
    run('Multimedia_Gallery_TitleRename_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名] TID: Multimedia_Gallery_TitleRename_002
      await Multimedia_Gallery_TitleRename_002(dt);
    });
    run('Multimedia_Gallery_TitleRename_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--文本编辑完成后，点击 ""X""] TID: Multimedia_Gallery_TitleRename_003
      await Multimedia_Gallery_TitleRename_003(dt);
    });
    run('Multimedia_Gallery_TitleRename_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--文本编辑完成后，点击 ""√""] TID: Multimedia_Gallery_TitleRename_004
      await Multimedia_Gallery_TitleRename_004(dt);
    });
    run('Multimedia_Gallery_TitleRename_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--修改字数符合数量标准≤7个字数] TID: Multimedia_Gallery_TitleRename_005
      await Multimedia_Gallery_TitleRename_005(dt);
    });
    run('Multimedia_Gallery_TitleRename_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--修改字数不符合数量标准>7个字数] TID: Multimedia_Gallery_TitleRename_006
      await Multimedia_Gallery_TitleRename_006(dt);
    });
    run('Multimedia_Gallery_TitleRename_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-删除用例: [长按触发重命名--修改字数为空] TID: Multimedia_Gallery_TitleRename_007
      await Multimedia_Gallery_TitleRename_007(dt);
    });
    run('Multimedia_Gallery_TitleRename_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--用户输入标题字符数上限---中/英文81个字符] TID: Multimedia_Gallery_TitleRename_008
      await Multimedia_Gallery_TitleRename_008(dt);
    });
    run('Multimedia_Gallery_TitleRename_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--不能包含以下特殊字符] TID: Multimedia_Gallery_TitleRename_009
      await Multimedia_Gallery_TitleRename_009(dt);
    });
    run('Multimedia_Gallery_TitleRename_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [长按触发重命名--不增加敏感词限制，用户自主命名] TID: Multimedia_Gallery_TitleRename_010
      await Multimedia_Gallery_TitleRename_010(dt);
    });
    run('Multimedia_Gallery_TitleRename_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""X""] TID: Multimedia_Gallery_TitleRename_011
      await Multimedia_Gallery_TitleRename_011(dt);
    });
    run('Multimedia_Gallery_TitleRename_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""√""] TID: Multimedia_Gallery_TitleRename_012
      await Multimedia_Gallery_TitleRename_012(dt);
    });
    run('Multimedia_Gallery_TitleRename_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--修改字数符合数量标准≤7个字数] TID: Multimedia_Gallery_TitleRename_013
      await Multimedia_Gallery_TitleRename_013(dt);
    });
    run('Multimedia_Gallery_TitleRename_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--修改字数不符合数量标准>7个字数] TID: Multimedia_Gallery_TitleRename_014
      await Multimedia_Gallery_TitleRename_014(dt);
    });
    run('Multimedia_Gallery_TitleRename_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-删除用例: [时刻播放/宫格页右上角更多触发重命名--修改字数为空] TID: Multimedia_Gallery_TitleRename_015
      await Multimedia_Gallery_TitleRename_015(dt);
    });
    run('Multimedia_Gallery_TitleRename_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--用户输入标题字符数上限---中/英文81个字符] TID: Multimedia_Gallery_TitleRename_016
      await Multimedia_Gallery_TitleRename_016(dt);
    });
    run('Multimedia_Gallery_TitleRename_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--不能包含以下特殊字符] TID: Multimedia_Gallery_TitleRename_017
      await Multimedia_Gallery_TitleRename_017(dt);
    });
    run('Multimedia_Gallery_TitleRename_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻播放/宫格页右上角更多触发重命名--不增加敏感词限制，用户自主命名] TID: Multimedia_Gallery_TitleRename_018
      await Multimedia_Gallery_TitleRename_018(dt);
    });
    run('Multimedia_Gallery_TitleRename_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [时刻克隆-xxx支持重命名] TID: Multimedia_Gallery_TitleRename_019
      await Multimedia_Gallery_TitleRename_019(dt);
    });
    run('Multimedia_Gallery_TitleRename_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [标题重命名编辑完成后，上划返回到桌面] TID: Multimedia_Gallery_TitleRename_020
      await Multimedia_Gallery_TitleRename_020(dt);
    });
    run('Multimedia_Gallery_TitleRename_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [标题重命名编辑完成后，设备重启] TID: Multimedia_Gallery_TitleRename_021
      await Multimedia_Gallery_TitleRename_021(dt);
    });
    run('Multimedia_Gallery_TitleRename_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-深色用例: [深色模式标题重命名编辑] TID: Multimedia_Gallery_TitleRename_022
      await Multimedia_Gallery_TitleRename_022(dt);
    });
    run('Multimedia_Gallery_TitleRename_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-竖屏用例: [横屏标题重命名编辑] TID: Multimedia_Gallery_TitleRename_023
      await Multimedia_Gallery_TitleRename_023(dt);
    });
    run('Multimedia_Gallery_TitleRename_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-竖屏用例: [竖屏标题重命名编辑] TID: Multimedia_Gallery_TitleRename_024
      await Multimedia_Gallery_TitleRename_024(dt);
    });
    run('Multimedia_Gallery_TitleRename_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [无障碍标题重命名编辑] TID: Multimedia_Gallery_TitleRename_025
      await Multimedia_Gallery_TitleRename_025(dt);
    });
    run('Multimedia_Gallery_TitleRename_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [大字体标题重命名编辑] TID: Multimedia_Gallery_TitleRename_026
      await Multimedia_Gallery_TitleRename_026(dt);
    });
    run('Multimedia_Gallery_TitleRename_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [悬浮窗标题重命名编辑] TID: Multimedia_Gallery_TitleRename_027
      await Multimedia_Gallery_TitleRename_027(dt);
    });
    run('Multimedia_Gallery_TitleRename_028', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [分屏标题重命名编辑] TID: Multimedia_Gallery_TitleRename_028
      await Multimedia_Gallery_TitleRename_028(dt);
    });
    run('Multimedia_Gallery_TitleRename_029', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [多语言标题重命名编辑] TID: Multimedia_Gallery_TitleRename_029
      await Multimedia_Gallery_TitleRename_029(dt);
    });
    run('Multimedia_Gallery_TitleRename_030', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [更换封面标题重命名编辑] TID: Multimedia_Gallery_TitleRename_030
      await Multimedia_Gallery_TitleRename_030(dt);
    });
    run('Multimedia_Gallery_TitleRename_031', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-用例: [移除封面标题重命名编辑] TID: Multimedia_Gallery_TitleRename_031
      await Multimedia_Gallery_TitleRename_031(dt);
    });
    run('Multimedia_Gallery_TitleRename_032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  时刻-删除用例: [删除封面标题重命名编辑] TID: Multimedia_Gallery_TitleRename_032
      await Multimedia_Gallery_TitleRename_032(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryTitleRenameTest').init();
      dt.log.i('afterEach GalleryTitleRenameTest start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryTitleRenameTest finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryTitleRenameTest').init();
      dt.log.i('afterAll GalleryTitleRenameTest start');
      await Exit.browser();
      dt.log.i('afterAll GalleryTitleRenameTest finish');
    });
  });
}

// DT步骤
/**
 * 时刻-: [时刻列表首页长按触发重命名]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_001
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_001(dt: Dt) {
  dt.log.i('时刻列表首页长按触发重命名 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发');

  await dt.sleep();
  dt.log.i('预期结果2、弹出封面编辑弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击封面编辑');

  await dt.sleep();
  dt.log.i('预期结果3、拉起封面编辑半模态显示：默认激活主标题编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻列表首页长按触发重命名 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_002
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_002(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('预期结果2、弹出封面编辑弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击右上角更多""::""');

  await dt.sleep();
  dt.log.i('预期结果3、拉起封面编辑半模态显示：默认激活主标题编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击封面编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名 end');
}

/**
 * 时刻-: [长按触发重命名--文本编辑完成后，点击 ""X""]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_003
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_003(dt: Dt) {
  dt.log.i('长按触发重命名--文本编辑完成后，点击 ""X"" start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""X""');

  await dt.sleep();
  dt.log.i('预期结果3、退出半模态页面显示，不保存已修改主标题文本，显示原标题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--文本编辑完成后，点击 ""X"" end');
}

/**
 * 时刻-: [长按触发重命名--文本编辑完成后，点击 ""√""]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_004
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_004(dt: Dt) {
  dt.log.i('长按触发重命名--文本编辑完成后，点击 ""√"" start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果3、退出半模态页面显示，保存已修改主标题文本，显示修改后的标题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--文本编辑完成后，点击 ""√"" end');
}

/**
 * 时刻-: [长按触发重命名--修改字数符合数量标准≤7个字数]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_005
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_005(dt: Dt) {
  dt.log.i('长按触发重命名--修改字数符合数量标准≤7个字数 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本数量≤7个字数，点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，且和原标题显示位置一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--修改字数符合数量标准≤7个字数 end');
}

/**
 * 时刻-: [长按触发重命名--修改字数不符合数量标准>7个字数]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_006
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_006(dt: Dt) {
  dt.log.i('长按触发重命名--修改字数不符合数量标准>7个字数 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本数量＞7个字数，点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果3.1、保存已修改主标题文本，在底部居中显示（最多显示两行，超出部分用”...”代替显示）3.2、副标题位置显示不变');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('...', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--修改字数不符合数量标准>7个字数 end');
}

/**
 * 时刻-删除: [长按触发重命名--修改字数为空]
 * GROUP: 时刻 MODULE: 删除TID: Multimedia_Gallery_TitleRename_007
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_007(dt: Dt) {
  dt.log.i('长按触发重命名--修改字数为空 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑窗');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改（删除已有文本，输入一个空格符），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果3.1、保存已修改主标题文本且为空显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--修改字数为空 end');
}

/**
 * 时刻-: [长按触发重命名--用户输入标题字符数上限---中/英文81个字符]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_008
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_008(dt: Dt) {
  dt.log.i('长按触发重命名--用户输入标题字符数上限---中/英文81个字符 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑窗');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本为81个字符');

  await dt.sleep();
  dt.log.i('预期结果3、可正常输入');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、二次编辑修改主标题文本为82个字符');

  await dt.sleep();
  dt.log.i('预期结果4、最多可输入81个中/英文字符');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--用户输入标题字符数上限---中/英文81个字符 end');
}

/**
 * 时刻-: [长按触发重命名--不能包含以下特殊字符]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_009
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_009(dt: Dt) {
  dt.log.i('长按触发重命名--不能包含以下特殊字符 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑窗');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本特殊字符（包括 ""  `  \ "" . \\  / : * ? <> | [ ] { } ），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果3、不保存已修改主标题文本，提示：不能包含以下（包括 ""  `  \ ” . \\  / : * ? <> | [ ] { } ）特殊字符');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText(' `  \ ', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--不能包含以下特殊字符 end');
}

/**
 * 时刻-: [长按触发重命名--不增加敏感词限制，用户自主命名]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_010
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_010(dt: Dt) {
  dt.log.i('长按触发重命名--不增加敏感词限制，用户自主命名 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑窗');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本涉及敏感词（包括政治、军事等），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本（用户自主命名，不增加敏感词限制且标题内容无限制）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('长按触发重命名--不增加敏感词限制，用户自主命名 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""X""]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_011
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_011(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""X"" start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""X""');

  await dt.sleep();
  dt.log.i('预期结果4、退出半模态页面显示，不保存已修改主标题文本，显示原标题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""X"" end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""√""]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_012
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_012(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""√"" start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、退出半模态页面显示，保存已修改主标题文本，显示修改后的标题');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--文本编辑完成后，点击 ""√"" end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--修改字数符合数量标准≤7个字数]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_013
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_013(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数符合数量标准≤7个字数 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本数量≤7个字数，点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本，且和原标题显示位置一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数符合数量标准≤7个字数 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--修改字数不符合数量标准>7个字数]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_014
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_014(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数不符合数量标准>7个字数 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本数量＞7个字数，点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4.1、保存已修改主标题文本，在底部居中显示（最多显示两行，超出部分用”...”代替显示）4.2、副标题位置显示不变');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('...', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数不符合数量标准>7个字数 end');
}

/**
 * 时刻-删除: [时刻播放/宫格页右上角更多触发重命名--修改字数为空]
 * GROUP: 时刻 MODULE: 删除TID: Multimedia_Gallery_TitleRename_015
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_015(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数为空 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改（删除已有文本，输入一个空格符），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4.1、保存已修改主标题文本且为空显示4.2、副标题顶替主标题显示位置，字体变大（变为主标题文本大小）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--修改字数为空 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--用户输入标题字符数上限---中/英文81个字符]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_016
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_016(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--用户输入标题字符数上限---中/英文81个字符 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本为81个字符');

  await dt.sleep();
  dt.log.i('预期结果4、可正常输入');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、二次编辑修改主标题文本为82个字符');

  await dt.sleep();
  dt.log.i('预期结果5、最多可输入81个中/英文字符');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--用户输入标题字符数上限---中/英文81个字符 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--不能包含以下特殊字符]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_017
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_017(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--不能包含以下特殊字符 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本特殊字符（包括 ""  `  \ "" . \\  / : * ? <> | [ ] { } ），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4、不保存已修改主标题文本，提示：不支持（包括 ""  `  \ ” . \\  / : * ? <> | [ ] { } ）特殊字符');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText(' `  \ ', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--不能包含以下特殊字符 end');
}

/**
 * 时刻-: [时刻播放/宫格页右上角更多触发重命名--不增加敏感词限制，用户自主命名]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_018
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_018(dt: Dt) {
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--不增加敏感词限制，用户自主命名 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，点击进入时刻播放/宫格页');

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角更多""::""，点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本涉及敏感词（包括政治、军事等），点击""√""保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本（用户自主命名，不增加敏感词限制且标题内容无限制）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻播放/宫格页右上角更多触发重命名--不增加敏感词限制，用户自主命名 end');
}

/**
 * 时刻-: [时刻克隆-支持重命名]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_019
 * 前置条件
 * 1、准备一台xxx设备
 * 2、xxx设备图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_019(dt: Dt) {
  dt.log.i('时刻克隆-xxx支持重命名 start');
  dt.log.i('STEP 1、进行双->单克隆图库所有数据');

  await dt.sleep();
  dt.log.i('预期结果1、精彩时刻成功克隆到xxx设备4、保存已修改主标题文本');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 3、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻克隆-xxx支持重命名 end');
}

/**
 * 时刻-: [标题重命名编辑完成后，上划返回到桌面]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_020
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_020(dt: Dt) {
  dt.log.i('标题重命名编辑完成后，上划返回到桌面 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('STEP 4、上滑返回桌面，再次进入图库-精彩时刻查看已修改的时刻标题显示');

  await dt.sleep();
  dt.log.i('预期结果4、主标题文本显示一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('标题重命名编辑完成后，上划返回到桌面 end');
}

/**
 * 时刻-: [标题重命名编辑完成后，设备重启]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_021
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_021(dt: Dt) {
  dt.log.i('标题重命名编辑完成后，设备重启 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('STEP 4、重启设备，再次进入图库-精彩时刻查看已修改的时刻标题显示');

  await dt.sleep();
  dt.log.i('预期结果4、主标题文本显示一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('标题重命名编辑完成后，设备重启 end');
}

/**
 * 时刻-深色: [深色模式标题重命名编辑]
 * GROUP: 时刻 MODULE: 深色TID: Multimedia_Gallery_TitleRename_022
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、打开深色模式
 */
async function Multimedia_Gallery_TitleRename_022(dt: Dt) {
  dt.log.i('深色模式标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，横竖屏切换UX显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式标题重命名编辑 end');
}

/**
 * 时刻-竖屏: [横屏标题重命名编辑]
 * GROUP: 时刻 MODULE: 竖屏TID: Multimedia_Gallery_TitleRename_023
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、手机处于竖屏态
 */
async function Multimedia_Gallery_TitleRename_023(dt: Dt) {
  dt.log.i('横屏标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""，切换横屏显示');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，横竖屏切换UX显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏标题重命名编辑 end');
}

/**
 * 时刻-竖屏: [竖屏标题重命名编辑]
 * GROUP: 时刻 MODULE: 竖屏TID: Multimedia_Gallery_TitleRename_024
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、手机处于横屏态
 */
async function Multimedia_Gallery_TitleRename_024(dt: Dt) {
  dt.log.i('竖屏标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""，切换竖屏显示');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，横竖屏切换UX显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('竖屏标题重命名编辑 end');
}

/**
 * 时刻-: [无障碍标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_025
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、设置->辅助功能->打开屏幕朗读
 */
async function Multimedia_Gallery_TitleRename_025(dt: Dt) {
  dt.log.i('无障碍标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，无障碍模式下语音播报提示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍标题重命名编辑 end');
}

/**
 * 时刻-: [大字体标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_026
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、设置->辅助功能->打开关怀模式（字体显示设置大6档）
 */
async function Multimedia_Gallery_TitleRename_026(dt: Dt) {
  dt.log.i('大字体标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 3、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果3、保存已修改主标题文本，大字体模式下UX正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体标题重命名编辑 end');
}

/**
 * 时刻-: [悬浮窗标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_027
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_027(dt: Dt) {
  dt.log.i('悬浮窗标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、上滑进入悬浮窗模式');

  await dt.sleep();
  dt.log.i('STEP 3、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本，悬浮窗模式下UX正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗标题重命名编辑 end');
}

/**
 * 时刻-: [分屏标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_028
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_028(dt: Dt) {
  dt.log.i('分屏标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、上滑进入分屏模式');

  await dt.sleep();
  dt.log.i('STEP 3、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本，分屏模式下UX正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏标题重命名编辑 end');
}

/**
 * 时刻-: [多语言标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_029
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 * 3、设置->系统->语言和地区
 */
async function Multimedia_Gallery_TitleRename_029(dt: Dt) {
  dt.log.i('多语言标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、切换多语言（繁体中文、英文、藏文、维吾尔文）');

  await dt.sleep();
  dt.log.i('STEP 3、任意选择某一时刻，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、保存已修改主标题文本，多语言模式下UX正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言标题重命名编辑 end');
}

/**
 * 时刻-: [更换封面标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_030
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_030(dt: Dt) {
  dt.log.i('更换封面标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，进入二级宫格页面选择一张图片设置为封面。');

  await dt.sleep();
  dt.log.i('STEP 3、封面更换完成，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、用户更换封面后，修改标题，重新分析后标题正确 ');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('更换封面标题重命名编辑 end');
}

/**
 * 时刻-: [移除封面标题重命名编辑]
 * GROUP: 时刻 MODULE: TID: Multimedia_Gallery_TitleRename_031
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_031(dt: Dt) {
  dt.log.i('移除封面标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，封面照片移除当前时刻');

  await dt.sleep();
  dt.log.i('STEP 3、自动替补后，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、移除封面自动替补后，修改标题，重新分析后标题正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('移除封面标题重命名编辑 end');
}

/**
 * 时刻-删除: [删除封面标题重命名编辑]
 * GROUP: 时刻 MODULE: 删除TID: Multimedia_Gallery_TitleRename_032
 * 前置条件
 * 1、设备已连接网络
 * 2、手机图库已存在精彩时刻
 */
async function Multimedia_Gallery_TitleRename_032(dt: Dt) {
  dt.log.i('删除封面标题重命名编辑 start');
  dt.log.i('STEP 1、打开图库app->点击进入时刻Tab页面');

  await dt.sleep();
  dt.log.i('STEP 2、任意选择某一时刻，删除当前封面');

  await dt.sleep();
  dt.log.i('STEP 3、自动替补后，长按触发并点击封面编辑');

  await dt.sleep();
  dt.log.i('STEP 4、编辑修改主标题文本后，点击""√""');

  await dt.sleep();
  dt.log.i('预期结果4、删除封面，修改标题，重新分析后标题正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除封面标题重命名编辑 end');
}