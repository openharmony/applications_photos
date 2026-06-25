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
import { Component, ON } from '@ohos.UiTest';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function OperateDeleteTest(): void {
  describe('OperateDeleteTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllOperateDeleteTest').init();
      dt.log.i('beforeAll OperateDeleteTest start');
      await dt.browser();
      dt.log.i('beforeAll OperateDeleteTest finish');
    });
    it('Multimedia_Gallery_DeleteScenes_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [照片页滑到最底端，从最后一张图片开始删除] TID: Multimedia_Gallery_DeleteScenes_003
      await Multimedia_Gallery_DeleteScenes_003(dt);
    });
    it('Multimedia_Gallery_DeleteScenes_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [照片页切换到三宫格后，大图/宫格删除图片] TID: Multimedia_Gallery_DeleteScenes_006
      await Multimedia_Gallery_DeleteScenes_006(dt);
    });
    it('Multimedia_Gallery_Files_delete_00001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [图片删除后滑动年视图] TID: Multimedia_Gallery_Files_delete_00001
      await Multimedia_Gallery_Files_delete_00001(dt);
    });
    it('Multimedia_Gallery_Files_delete_000010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [存储空间占满时(系统剩余1G)，大图/宫格删除] TID: Multimedia_Gallery_Files_delete_000010
      await Multimedia_Gallery_Files_delete_000010(dt);
    });
    it('Multimedia_Gallery_Files_delete_00002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [编辑视频后删除再播放] TID: Multimedia_Gallery_Files_delete_00002
      await Multimedia_Gallery_Files_delete_00002(dt);
    });
    it('Multimedia_Gallery_Files_delete_00003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图编辑另存后再删除] TID: Multimedia_Gallery_Files_delete_00003
      await Multimedia_Gallery_Files_delete_00003(dt);
    });
    it('Multimedia_Gallery_Files_delete_00005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-预览条用例: [连续删除大图后滑动预览条再删除] TID: Multimedia_Gallery_Files_delete_00005
      await Multimedia_Gallery_Files_delete_00005(dt);
    });
    it('Multimedia_Gallery_Files_delete_00006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [图片浏览后删除大图/视频] TID: Multimedia_Gallery_Files_delete_00006
      await Multimedia_Gallery_Files_delete_00006(dt);
    });
    it('Multimedia_Gallery_Files_delete_00007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云下行同步过程中浏览后删除大图/视频] TID: Multimedia_Gallery_Files_delete_00007
      await Multimedia_Gallery_Files_delete_00007(dt);
    });
    it('Multimedia_Gallery_Files_delete_00008', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [存储空间占满时(只剩200M)，大图/宫格删除] TID: Multimedia_Gallery_Files_delete_00008
      await Multimedia_Gallery_Files_delete_00008(dt);
    });
    it('Multimedia_Gallery_Files_delete_00009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [相机入口大图删除退出后台再打开继续删除] TID: Multimedia_Gallery_Files_delete_00009
      await Multimedia_Gallery_Files_delete_00009(dt);
    });
    it('Multimedia_Gallery_Files_delete_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [照片页，大图删除图片/视频成功] TID: Multimedia_Gallery_Files_delete_001
      await Multimedia_Gallery_Files_delete_001(dt);
    });
    it('Multimedia_Gallery_Files_delete_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [预制相册（图片、视频、收藏），大图删除图片/视频成功] TID: Multimedia_Gallery_Files_delete_003
      await Multimedia_Gallery_Files_delete_003(dt);
    });
    it('Multimedia_Gallery_Files_delete_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [从相机入口进大图删除成功] TID: Multimedia_Gallery_Files_delete_007
      await Multimedia_Gallery_Files_delete_007(dt);
    });
    it('Multimedia_Gallery_Files_delete_013', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图删除返回宫格] TID: Multimedia_Gallery_Files_delete_013
      await Multimedia_Gallery_Files_delete_013(dt);
    });
    it('Multimedia_Gallery_Files_UX_Menu_check_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [删除菜单入口检查（用户创建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_001
      await Multimedia_Gallery_Files_UX_Menu_check_001(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachOperateDeleteTest').init();
      // 执行用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach OperateDeleteTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach OperateDeleteTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllOperateDeleteTest').init();
      await Exit.browser();
      dt.log.i('afterAll OperateDeleteTest finish');
    });
  });
}

/**
 * 大图-删除: [照片页滑到最底端，从最后一张图片开始删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_DeleteScenes_003
 * 前置条件
 * 图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_DeleteScenes_003(dt: Dt) {
  dt.log.i('照片页滑到最底端，从最后一张图片开始删除 start');
  dt.log.i('STEP 1.照片页滑到最底端， 进入最后一张图片大图， 点击删除');
  // TODO: 从宫格到照片，并且是最后一张照片
  dt.log.i('在大图中删除图片');
  await dt.assertClick('ToolBarButtonDelete');
  dt.log.i('点击dialog中的删除');
  await dt.sleep();
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  let deleteDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  await deleteDialogConfirmButton.click();
  await dt.sleep();
  // TODO:
  dt.log.i('预期结果1.图片删除动效正常，下一张图片切换正常/宫格界面刷新正常');

  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.照片页滑到最底端， 长按最后一张图片宫格， 点击删除');


  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页滑到最底端，从最后一张图片开始删除 end');
}

// 点击隐藏底部缩略图
async function hideOrShowPreviewer(dt: Dt) {
  await dt.driver.click(700, 500);
  await dt.sleep(DELAY.short);
}


/**
 * 大图-删除: [照片页切换到三宫格后，大图/宫格删除图片]
 * TAG: 大图删除 TID: Multimedia_Gallery_DeleteScenes_006
 * 前置条件
 * 图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_DeleteScenes_006(dt: Dt) {
  await dt.browser();
  dt.log.i('照片页切换到三宫格后，大图/宫格删除图片 start');
  dt.log.i('STEP 1.切换照片页成三宫格显示，进入图片大图/长按宫格删除图片');

  await dt.sleep();
  dt.log.i('隐藏工具栏');

  await dt.sleep();
  dt.log.i('显示工具栏');

  await dt.sleep();
  dt.log.i('预期结果1.图片删除动效正常，下一张图片切换正常/宫格界面刷新正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页切换到三宫格后，大图/宫格删除图片 end');
}

/**
 * 大图-滑动: [图片删除后滑动年视图]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00001
 * 前置条件
 *
 手机预存/克隆有超过一屏不同年份的照片
 */
async function Multimedia_Gallery_Files_delete_00001(dt: Dt) {
  dt.log.i('图片删除后滑动年视图 start');
  dt.log.i('STEP 1、照片页年月日视图下滑动浏览图片，观察年份气泡显示');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');

  await dt.sleep();
  dt.log.i('预期结果1、浏览正常，图片无异常，年份气泡正常显示3、浏览正常，图片无异常，年份气泡正常显示4、浏览正常，图片无异常，年份气泡正常显示6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入照片页/相册页删除/添加图片');

  await dt.sleep();
  dt.log.i('STEP 3、返回照片页后，再次在年月日视图下滑动浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页日视图下滑动滚动轴浏览图片，观察年份气泡显示');

  await dt.sleep();
  dt.log.i('预期结果4、浏览正常，图片无异常，年份气泡正常显示6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入照片页/相册页删除/添加图片');

  await dt.sleep();
  dt.log.i('STEP 6、返回照片页后，再次在日视图下滑动滚动轴浏览图片，观察年份气泡显示');

  await dt.sleep();
  dt.log.i('预期结果6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片删除后滑动年视图 end');
}

/**
 * 大图-删除: [存储空间占满时(系统剩余1G)，大图/宫格删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_000010
 * 前置条件
 * 手机资源预制存储空间快占满（系统剩余1G),（方法一：使用命令：1、hdc shell  2、cd storage/cloud/100/data/
 dd if=/dev/zero of=ab.txt bs=1G count=150（需要额外设置新的占用的空间，比如150=设置占用150G空间)
 方法二：下载各种应用占满空间）
 */
async function Multimedia_Gallery_Files_delete_000010(dt: Dt) {
  dt.log.i('存储空间占满时(系统剩余1G)，大图/宫格删除 start');
  dt.log.i('STEP 1、从不同入口打开大图删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('STEP 2、从不同入口宫格多选删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await dt.sleep();
  dt.log.i('预期结果2、大图删除成功，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、宫格删除大图成功，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存储空间占满时(系统剩余1G)，大图/宫格删除 end');
}

/**
 * 大图-删除: [编辑视频后删除再播放]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00002
 * 前置条件
 * 图库中已有多个视频
 */
async function Multimedia_Gallery_Files_delete_00002(dt: Dt) {
  dt.log.i('编辑视频后删除再播放 start');
  dt.log.i('STEP 1.进入图库，打开视频大图');

  await dt.sleep();
  dt.log.i('STEP 2.点击编辑，调整截取视频的时长，点击另存/覆盖原图为新视频');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('STEP 3.删除该视频，滑动大图至下一个可播放视频，点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果3.视频显示播放按钮，可正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑视频后删除再播放 end');
}

/**
 * 大图-删除: [大图编辑另存后再删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00003
 * 前置条件
 * 图库中有多个视频大图
 */
async function Multimedia_Gallery_Files_delete_00003(dt: Dt) {
  dt.log.i('大图编辑另存后再删除 start');
  dt.log.i('STEP 1、打开大图，视频编辑后覆盖原图');

  await dt.sleep();
  dt.log.i('STEP 2、再次删除该大图、视频');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('预期结果2、大图、视频可成功被删除4、原图和新图片正常被删除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开大图、视频编辑后另存为新图片');

  await dt.sleep();
  dt.log.i('STEP 4、删除原图，和新图片');

  await dt.sleep();
  dt.log.i('预期结果4、原图和新图片正常被删除');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图编辑另存后再删除 end');
}

/**
 * 大图-预览条: [连续删除大图后滑动预览条再删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00005
 * 前置条件
 * 图库中有多个视频大图
 */
async function Multimedia_Gallery_Files_delete_00005(dt: Dt) {
  dt.log.i('连续删除大图后滑动预览条再删除 start');
  dt.log.i('STEP 1、连续删除十几张图片');

  await dt.sleep();
  dt.log.i('预期结果1、删除成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击/滑动底部小预览条切换到其它图片');

  await dt.sleep();
  dt.log.i('预期结果2、滑动预览条正常切换无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次连续删除多张照片');

  await dt.sleep();
  dt.log.i('预期结果3、正常删除成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击/滑动底部小缩略图，观察界面显示');

  await dt.sleep();
  dt.log.i('预期结果4、正确切换到对应大图，大图预览条显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连续删除大图后滑动预览条再删除 end');
}

/**
 * 大图-删除: [图片浏览后删除大图/视频]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00006
 * 前置条件
 * 图片存在本地图片和视频，有端云账号有几千张图片
 */
async function Multimedia_Gallery_Files_delete_00006(dt: Dt) {
  dt.log.i('图片浏览后删除大图/视频 start');
  dt.log.i('STEP 1、选择图库首张图片，往后滑动浏览一张图片/视频，再向前滑动浏览一张');

  await dt.sleep();
  dt.log.i('STEP 2、删除本张图片，补位到下一张图片/视频');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');

  await dt.sleep();
  dt.log.i('预期结果2、图片删除成功，界面无异常4、图片删除成功，界面无异常5、视频可以正常播放，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择图库首张视频，往后滑动浏览一张图片/视频，再向前滑动浏览一张');

  await dt.sleep();
  dt.log.i('STEP 4、删除本张视频，补位到下一张图片/视频');

  await dt.sleep();
  dt.log.i('预期结果4、图片删除成功，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、如果是视频删除前后点击播放');

  await dt.sleep();
  dt.log.i('预期结果5、视频可以正常播放，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片浏览后删除大图/视频 end');
}

/**
 * 大图-端云: [端云下行同步过程中浏览后删除大图/视频]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00007
 * 前置条件
 * 图片存在本地图片和视频，有端云账号有几千张图片
 */
async function Multimedia_Gallery_Files_delete_00007(dt: Dt) {
  dt.log.i('端云下行同步过程中浏览后删除大图/视频 start');
  dt.log.i('STEP 1、开启端云同步，端云同步下行过程中');

  await dt.sleep();
  dt.log.i('STEP 2、选择图库首张图片，往后滑动浏览一张，再向前滑动浏览一张');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');

  await dt.sleep();
  dt.log.i('STEP 3、删除本张图片，补位到下一张图片/视频');

  await dt.sleep();
  dt.log.i('预期结果3、图片删除成功，界面无异常5、图片删除成功，界面无异常6、视频可以正常播放，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、选择图库首张视频，往后滑动浏览一张，再向前滑动浏览一张');

  await dt.sleep();
  dt.log.i('STEP 5、删除本张视频，补位到下一张图片/视频');

  await dt.sleep();
  dt.log.i('预期结果5、图片删除成功，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、如果是视频删除前后点击播放');

  await dt.sleep();
  dt.log.i('预期结果6、视频可以正常播放，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云下行同步过程中浏览后删除大图/视频 end');
}

/**
 * 大图-删除: [存储空间占满时(只剩200M)，大图/宫格删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00008
 * 前置条件
 * 手机资源预制存储空间快占满（剩220M),（方法一：使用命令：1、hdc shell  2、cd storage/cloud/100/data/
 dd if=/dev/zero of=ab.txt bs=1G count=150（需要额外设置新的占用的空间，比如150=设置占用150G空间)
 方法二：下载各种应用占满空间）
 */
async function Multimedia_Gallery_Files_delete_00008(dt: Dt) {
  dt.log.i('存储空间占满时(只剩200M)，大图/宫格删除 start');
  dt.log.i('STEP 1、从不同入口打开大图删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await dt.sleep();
  dt.log.i('STEP 2、从不同入口宫格多选删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('预期结果2、大图删除成功，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、宫格删除大图成功，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存储空间占满时(只剩200M)，大图/宫格删除 end');
}

/**
 * 大图-删除: [相机入口大图删除退出后台再打开继续删除]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_00009
 * 前置条件
 * 图片存在本地图片和视频，有端云账号有几千张图片
 */
async function Multimedia_Gallery_Files_delete_00009(dt: Dt) {
  dt.log.i('相机入口大图删除退出后台再打开继续删除 start');
  dt.log.i('STEP 1、相机入口打开大图/视频');

  await dt.sleep();
  dt.log.i('预期结果1、正常打开大图/视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击删除按钮，二次弹窗确认删除，点击时快速上滑退出到桌面');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('预期结果2、推出到桌面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次打开相机进大图，点击删除按钮');

  await dt.sleep();
  dt.log.i('预期结果3、正常弹出删除按钮，删除成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await hideOrShowPreviewer(dt);
  await dt.sleep(DELAY.short);
  await hideOrShowPreviewer(dt);
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口大图删除退出后台再打开继续删除 end');
}

/**
 * 大图-删除: [照片页，大图删除图片/视频成功]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_001
 * 前置条件
 * 1、图库有用户创建相册（非空）
 */
async function Multimedia_Gallery_Files_delete_001(dt: Dt) {
  dt.log.i('照片页，大图删除图片/视频成功 start');
  dt.log.i('STEP 1、照片页，只有1个图片/视频，进入大图-更多-点击删除，确认删除，查看结果；');

  let browserDeleteButton = await dt.driver.findComponent(ON.id('ToolBarButtonDelete'));
  await dt.sleep(DELAY.short);
  await browserDeleteButton.click();
  await dt.sleep(DELAY.short);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  dt.log.i('点击dialog中的删除');
  await dt.sleep();
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  let deleteDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  await deleteDialogConfirmButton.click();
  await dt.sleep();

  await dt.showComponentsWithin();

  dt.log.i('预期结果1、文件删除成功，返回照片页，显示空界面；');

  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、照片页，有多个图片/视频，选择第一个/中间、最后1个图片/视频，分别进入大图-更多-点击删除，确认删除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果2、第一个/中间文件删除成功，自动切到下一个；最后1个文件删除成功，自动切到上一个；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、操作步骤1/2，弹出删除确认弹框-点击取消/删除');

  browserDeleteButton = await dt.driver.findComponent(ON.id('ToolBarButtonDelete'));
  await browserDeleteButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.sleep();
  dt.log.i('预期结果3、弹出删除确认弹框，提示“是否删除此图片？”/“是否删除此视频？”，显示符合UX设计；完成删除操作后，文件从之前全部相册中消失，进入最近删除；');
  await dt.sleep(DELAY.double);
  await assertComponentsByTwoTexts(dt, '是否删除此视频？', '是否删除此图片？');

  dt.log.i('点击dialog中的取消');
  await dt.sleep();
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  let deleteDialogCancelButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  await deleteDialogCancelButton.click();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.sleep(DELAY.double);
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页，大图删除图片/视频成功 end');
}

/**
 * 大图-收藏: [预制相册（图片、视频、收藏），大图删除图片/视频成功]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_003
 * 前置条件
 * 1、图库有预制相册、用户创建相册（非空）等
 */
async function Multimedia_Gallery_Files_delete_003(dt: Dt) {
  dt.log.i('预制相册（图片、视频、收藏），大图删除图片/视频成功 start');
  dt.log.i('STEP 1、宫格页（预制相册、用户创建相册等），只有1个图片/视频，进入大图-更多-点击删除，确认删除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果1、文件删除成功，返回宫格，显示空界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、宫格页（预制相册、用户创建相册等），有多个图片/视频，选择第一个/中间、最后1个图片/视频，分别进入大图-更多-点击删除，确认删除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果2、第一个/中间文件删除成功，自动切到下一个；最后1个文件删除成功，自动切到上一个；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、操作步骤1/2，弹出删除确认弹框-点击取消/删除');

  let browserDeleteButton = await dt.driver.findComponent(ON.id('ToolBarButtonDelete'));
  await dt.sleep(DELAY.short);
  await browserDeleteButton.click();
  await dt.sleep(DELAY.short);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  await dt.sleep();
  dt.log.i('预期结果3、弹出删除确认弹框，提示“是否删除此图片？”/“是否删除此视频？”，显示符合UX设计；完成删除操作后，文件从之前全部相册中消失，进入最近删除；');
  await dt.sleep(DELAY.double);
  await assertComponentsByTwoTexts(dt, '是否删除此视频？', '是否删除此图片？');

  dt.log.i('点击dialog中的取消');
  await dt.sleep();
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  let deleteDialogCancelButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  await deleteDialogCancelButton.click();
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预制相册（图片、视频、收藏），大图删除图片/视频成功 end');
}

async function assertComponentsByTwoTexts(dt: Dt, text1: string, text2: string): Promise<Component> {
  dt.log.i(`finding the component with text: '${text1}'`)
  let identifier = ON.text(text1);
  try {
    await dt.driver.findComponent(identifier);
    await dt.sleep(DELAY.short);
    await dt.driver.assertComponentExist(identifier);
    await dt.sleep(DELAY.short);

  } catch (e) {
    dt.log.i(`text '${text1}' cannot found, try text '${text2}'`);
    identifier = ON.text(text2);
    await dt.driver.findComponent(identifier);
    await dt.sleep(DELAY.short);
    await dt.driver.assertComponentExist(identifier);
    await dt.sleep(DELAY.short);
  }

  return dt.driver.findComponent(identifier);
}

/**
 * 大图-删除: [从相机入口进大图删除成功]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_007
 * 前置条件
 *
 */
async function Multimedia_Gallery_Files_delete_007(dt: Dt) {
  dt.log.i('从相机入口进大图删除成功 start');
  dt.log.i('STEP 1、空图库时，相机拍摄单个/连拍多个照片（图片/视频），点击左下角进入大图，删除连拍3、图库已有多个资源，相机拍摄单个/连拍多个照片（图片/视频），点击左下角进入大图，删除连拍');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('预期结果1、正常删除，刷新到下一个；连拍照片全部删除后，直接返回相机；图库连拍照片进入“最近删除”；3 、正常删除，刷新到下一个；图库连拍照片进入“最近删除”；');
  await dt.sleep(DELAY.double);  // await dt.assertComponentByText('最近删除');
  dt.log.i('STEP 3、图库已有多个资源，相机拍摄单个/连拍多个照片（图片/视频），点击左下角进入大图，删除连拍');

  await dt.sleep();
  dt.log.i('预期结果3 、正常删除，刷新到下一个；图库连拍照片进入“最近删除”；');
  await dt.sleep(DELAY.double);  // await dt.assertComponentByText('最近删除', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('从相机入口进大图删除成功 end');
}

/**
 * 大图-删除: [大图删除返回宫格]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_delete_013
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_Files_delete_013(dt: Dt) {
  dt.log.i('大图删除返回宫格 start');
  dt.log.i('STEP 1、在宫格页面进入大图');

  await dt.sleep();
  dt.log.i('STEP 2、删除图片');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');


  await dt.sleep();
  dt.log.i('预期结果2/5、图片正常切换到下一张，过程中动效流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、返回宫格页面查看');

  await dt.sleep();
  dt.log.i('预期结果3/6、刚才删除的图片已消失，宫格其他图片正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在宫格页面进入大图');

  await dt.sleep();
  dt.log.i('STEP 5、在大图页面重复删除10张图片');

  await dt.sleep();
  dt.log.i('STEP 6、返回宫格页面查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图删除返回宫格 end');
}

/**
 * 大图-删除: [删除菜单入口检查（用户创建相册：大图+宫格）]
 * TAG: 大图删除 TID: Multimedia_Gallery_Files_UX_Menu_check_001
 * 前置条件
 * 1、图库有预置相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等
 */
async function Multimedia_Gallery_Files_UX_Menu_check_001(dt: Dt) {
  dt.log.i('删除菜单入口检查（用户创建相册：大图+宫格） start');
  dt.log.i('STEP 1、进入新建相册，点击任意缩略图，打开大图时，查看底部菜单、更多菜单');

  await hideOrShowPreviewer(dt);
  dt.log.i('隐藏工具栏');

  await hideOrShowPreviewer(dt);
  dt.log.i('显示工具栏');

  await dt.sleep();
  dt.log.i('预期结果1、大图底部删除入口显示正常，点击可恢复；更多菜单-移除菜单显示“从当前相册移除”，符合UX设计');
  await dt.sleep(DELAY.double);  // await dt.assertComponentByText('从当前相册移除');
  dt.log.i('STEP 2、进入新建相册，点击更多多选-进入多选，有勾选/无勾选时，查看底部菜单、更多菜单');

  await dt.sleep();
  dt.log.i('预期结果2、多选底部删除入口、更多-移除菜单显示正常；有勾选时删除入口、移除入口高亮，点击有响应；无勾选时，更多菜单全部置灰，不可点击；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除菜单入口检查（用户创建相册：大图+宫格） end');
}
