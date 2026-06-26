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

export default function MultimediaGalleryPCShortcutKeys(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPCShortcutKeysTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPCShortcutKeys').init();
      dt.log.i('beforeAll MultimediaGalleryPCShortcutKeys start');
      dt.log.i('beforeAll MultimediaGalleryPCShortcutKeys finish');
    });
    /**
     * 打开大图
     */
    it('beforeMultimediaGalleryPCShortcutKeys', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_PC_Shortcut_Keys_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图支持Ctrl+C复制图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_001
      await Multimedia_Gallery_PC_Shortcut_Keys_001(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [宫格支持Ctrl+C复制图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_002
      await Multimedia_Gallery_PC_Shortcut_Keys_002(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图支持Ctrl+D和Del删除图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_003
      await Multimedia_Gallery_PC_Shortcut_Keys_003(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [宫格支持Ctrl+D和Del删除图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_004
      await Multimedia_Gallery_PC_Shortcut_Keys_004(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [相册支持Ctrl+D和Del删除] TID: Multimedia_Gallery_PC_Shortcut_Keys_005
      await Multimedia_Gallery_PC_Shortcut_Keys_005(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [人像支持Ctrl+D和Del移出] TID: Multimedia_Gallery_PC_Shortcut_Keys_006
      await Multimedia_Gallery_PC_Shortcut_Keys_006(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [拼图支持Ctrl+S快捷键保存] TID: Multimedia_Gallery_PC_Shortcut_Keys_007
      await Multimedia_Gallery_PC_Shortcut_Keys_007(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [编辑支持Ctrl+S快捷键保存] TID: Multimedia_Gallery_PC_Shortcut_Keys_008
      await Multimedia_Gallery_PC_Shortcut_Keys_008(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图支持Ctrl +/-缩放图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_009
      await Multimedia_Gallery_PC_Shortcut_Keys_009(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [宫格支持Ctrl+A全选图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_010
      await Multimedia_Gallery_PC_Shortcut_Keys_010(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [隐藏相册支持Ctrl+A全选相册] TID: Multimedia_Gallery_PC_Shortcut_Keys_011
      await Multimedia_Gallery_PC_Shortcut_Keys_011(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [图库支持Ctrl+F呼出搜索框] TID: Multimedia_Gallery_PC_Shortcut_Keys_012
      await Multimedia_Gallery_PC_Shortcut_Keys_012(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图支持page Up/page Down键切换图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_013
      await Multimedia_Gallery_PC_Shortcut_Keys_013(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频支持Space键播放暂停] TID: Multimedia_Gallery_PC_Shortcut_Keys_014
      await Multimedia_Gallery_PC_Shortcut_Keys_014(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [编辑支持Ctrl+Z快捷键撤销操作] TID: Multimedia_Gallery_PC_Shortcut_Keys_015
      await Multimedia_Gallery_PC_Shortcut_Keys_015(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [编辑支持Ctrl+Y或Ctrl+Shift+Z快捷键撤销操作] TID: Multimedia_Gallery_PC_Shortcut_Keys_016
      await Multimedia_Gallery_PC_Shortcut_Keys_016(dt);
    });
    it('Multimedia_Gallery_PC_Shortcut_Keys_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [编辑支持Ctrl +/-放大缩小预览图片] TID: Multimedia_Gallery_PC_Shortcut_Keys_017
      await Multimedia_Gallery_PC_Shortcut_Keys_017(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPCShortcutKeys').init();
      dt.log.i('afterEach MultimediaGalleryPCShortcutKeys start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPCShortcutKeys finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPCShortcutKeys').init();
      dt.log.i('afterAll MultimediaGalleryPCShortcutKeys start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPCShortcutKeys finish');
    });
  });
}

// DT步骤
/**
 * 大图-大图: [大图支持Ctrl+C复制图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Shortcut_Keys_001
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_001(dt: Dt) {
  dt.log.i('大图支持Ctrl+C复制图片 start');
  dt.log.i('STEP 1、在图库中打开大图查看图片');

  
  dt.log.i('STEP 2、使用Ctry+C快捷键复制图片');

  
  dt.log.i('预期结果2、图库被正常复制到剪切板');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、粘贴到其他应用，例如备忘录和文件管理中PS：picker场景不支持该特性。隐藏相册follow不支持复制功能原规格，不支持复制快捷键。');

  
  dt.log.i('预期结果3、图片可以正常粘贴到其他应用');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图支持Ctrl+C复制图片 end');
}

/**
 * 大图-格式: [宫格支持Ctrl+C复制图片]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_002
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_002(dt: Dt) {
  dt.log.i('宫格支持Ctrl+C复制图片 start');
  dt.log.i('STEP 1、在图库各类相册宫格中进入多选后选中几个图片');

  
  dt.log.i('STEP 2、在图库宫格中直接多选选中几个图片（框选，shift和ctry组合使用点击选中）');

  
  dt.log.i('STEP 3、使用Ctry+C快捷键复制图片');

  
  dt.log.i('预期结果3、图库被正常复制到剪切板');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、粘贴到其他应用，例如备忘录和文件管理中PS：picker场景不支持该特性。隐藏相册follow不支持复制功能原规格，不支持复制快捷键。');

  
  dt.log.i('预期结果4、图片可以正常粘贴到其他应用');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格支持Ctrl+C复制图片 end');
}

/**
 * 大图-删除: [大图支持Ctrl+D和Del删除图片]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Shortcut_Keys_003
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_003(dt: Dt) {
  dt.log.i('大图支持Ctrl+D和Del删除图片 start');
  dt.log.i('STEP 1、在图库中打开大图查看图片');

  
  dt.log.i('STEP 2、使用Ctry+D快捷键删除图片');

  
  dt.log.i('预期结果2、3、正常弹出删除确认框4、确认后删除进入回收站');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用del快捷键删除图片');

  
  dt.log.i('STEP 4、点击enter键、空格键，或者鼠标点击确认按钮');

  
  dt.log.i('预期结果4、确认后删除进入回收站');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图支持Ctrl+D和Del删除图片 end');
}

/**
 * 大图-删除: [宫格支持Ctrl+D和Del删除图片]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Shortcut_Keys_004
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_004(dt: Dt) {
  dt.log.i('宫格支持Ctrl+D和Del删除图片 start');
  dt.log.i('STEP 1、在图库各类相册宫格中进入多选后选中几个图片');

  
  dt.log.i('STEP 2、在图库宫格中直接多选选中几个图片（框选，shift和ctry组合使用点击选中）');

  
  dt.log.i('STEP 3、使用Ctry+D快捷键删除图片');

  
  dt.log.i('预期结果3、4、正常弹出删除确认框5、确认后删除进入回收站');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、使用del快捷键删除图片');

  
  dt.log.i('STEP 5、点击enter键、空格键，或者鼠标点击确认按钮');

  
  dt.log.i('预期结果5、确认后删除进入回收站');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格支持Ctrl+D和Del删除图片 end');
}

/**
 * 大图-删除: [相册支持Ctrl+D和Del删除]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Shortcut_Keys_005
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_005(dt: Dt) {
  dt.log.i('相册支持Ctrl+D和Del删除 start');
  dt.log.i('STEP 1、在图库中选中用户创建相册');

  
  dt.log.i('STEP 2、使用Ctry+D快捷键触发删除相册');

  
  dt.log.i('预期结果2、3、正常弹出删除确认框4、确认后相册被删除成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用del快捷键触发删除相册');

  
  dt.log.i('STEP 4、点击enter键、空格键，或者鼠标点击确认按钮');

  
  dt.log.i('预期结果4、确认后相册被删除成功');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册支持Ctrl+D和Del删除 end');
}

/**
 * 大图-格式: [人像支持Ctrl+D和Del移出]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_006
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 2、图库已生成人像相册
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_006(dt: Dt) {
  dt.log.i('人像支持Ctrl+D和Del移出 start');
  dt.log.i('STEP 1、在图库中选中人像相册');

  
  dt.log.i('STEP 2、使用Ctry+D快捷键触发移出相册');

  
  dt.log.i('预期结果2、3、正常弹出相册移出确认框4、确认后选中的人像相册被移出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用del快捷键触发移出相册');

  
  dt.log.i('STEP 4、点击enter键、空格键，或者鼠标点击确认按钮');

  
  dt.log.i('预期结果4、确认后选中的人像相册被移出成功');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像支持Ctrl+D和Del移出 end');
}

/**
 * 大图-格式: [拼图支持Ctrl+S快捷键保存]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_007
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_007(dt: Dt) {
  dt.log.i('拼图支持Ctrl+S快捷键保存 start');
  dt.log.i('STEP 1、在图库多选几个图片进行拼图');

  
  dt.log.i('预期结果1、拼图被正常保存');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在拼图页面进行图片编辑');

  
  dt.log.i('STEP 3、使用Ctrl+S快捷键保存拼图');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拼图支持Ctrl+S快捷键保存 end');
}

/**
 * 大图-格式: [编辑支持Ctrl+S快捷键保存]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_008
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_008(dt: Dt) {
  dt.log.i('编辑支持Ctrl+S快捷键保存 start');
  dt.log.i('STEP 1、在图库选中图片进入编辑页面');

  
  dt.log.i('预期结果1、编辑后的图片被正常保存');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对图片进行编辑');

  
  dt.log.i('STEP 3、使用Ctrl+S快捷键保存图片');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持Ctrl+S快捷键保存 end');
}

/**
 * 大图-大图: [大图支持Ctrl +/-缩放图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Shortcut_Keys_009
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_009(dt: Dt) {
  dt.log.i('大图支持Ctrl +/-缩放图片 start');
  dt.log.i('STEP 1、在图库选中图片进入大图页面');

  
  dt.log.i('预期结果1、图片被正常放大缩小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用Ctrl +快捷键放大图片');

  
  dt.log.i('STEP 3、使用Ctrl -快捷键缩小图片');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图支持Ctrl +/-缩放图片 end');
}

/**
 * 大图-格式: [宫格支持Ctrl+A全选图片]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_010
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_010(dt: Dt) {
  dt.log.i('宫格支持Ctrl+A全选图片 start');
  dt.log.i('STEP 1、在各相册宫格中查看图片，图片与视频相册、图片相册、视频相册、收藏相册、隐藏相册、最近删除相册、用户创建相册、人像相册、分类相册、来源相册');

  
  dt.log.i('预期结果1、宫格中的图片被正常全选选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用Ctrl+A快捷键全选图片');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格支持Ctrl+A全选图片 end');
}

/**
 * 大图-格式: [隐藏相册支持Ctrl+A全选相册]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_011
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 2、隐藏相册中存在各种相册
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_011(dt: Dt) {
  dt.log.i('隐藏相册支持Ctrl+A全选相册 start');
  dt.log.i('STEP 1、进入隐藏相册查看');

  
  dt.log.i('预期结果1、隐藏相册中各个相册被正常全选选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用Ctrl+A快捷键全选相册');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持Ctrl+A全选相册 end');
}

/**
 * 大图-格式: [图库支持Ctrl+F呼出搜索框]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_012
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_012(dt: Dt) {
  dt.log.i('图库支持Ctrl+F呼出搜索框 start');
  dt.log.i('STEP 1、打开图库');

  
  dt.log.i('预期结果1、正常进入搜索页面，搜索框正常获焦');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用Ctrl+F快捷键呼出搜索框');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库支持Ctrl+F呼出搜索框 end');
}

/**
 * 大图-大图: [大图支持page Up/page Down键切换图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Shortcut_Keys_013
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_013(dt: Dt) {
  dt.log.i('大图支持page Up/page Down键切换图片 start');
  dt.log.i('STEP 1、打开大图查看图片');

  
  dt.log.i('预期结果1、图片可以正常切换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用page Up快捷键切换图片');

  
  dt.log.i('STEP 3、使用page Down快捷键切换图片');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图支持page Up/page Down键切换图片 end');
}

/**
 * 大图-视频: [视频支持Space键播放暂停]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Shortcut_Keys_014
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_014(dt: Dt) {
  dt.log.i('视频支持Space键播放暂停 start');
  dt.log.i('STEP 1、打开视频大图进行查看');

  
  dt.log.i('预期结果1、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击Space键播放视频');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频支持Space键播放暂停 end');
}

/**
 * 大图-格式: [编辑支持Ctrl+Z快捷键撤销操作]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_015
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_015(dt: Dt) {
  dt.log.i('编辑支持Ctrl+Z快捷键撤销操作 start');
  dt.log.i('STEP 1、在图库选中图片进入编辑页面');

  
  dt.log.i('预期结果1、上一步的操作被成功撤销');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对图片进行一些编辑操作');

  
  dt.log.i('STEP 3、使用Ctrl+Z快捷键撤销上一步的操作步骤');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持Ctrl+Z快捷键撤销操作 end');
}

/**
 * 大图-格式: [编辑支持Ctrl+Y或Ctrl+Shift+Z快捷键撤销操作]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_016
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_016(dt: Dt) {
  dt.log.i('编辑支持Ctrl+Y或Ctrl+Shift+Z快捷键撤销操作 start');
  dt.log.i('STEP 1、在图库选中图片进入编辑页面');

  
  dt.log.i('预期结果1、撤销的操作被成功恢复');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对图片进行一些编辑操作');

  
  dt.log.i('STEP 3、撤销一些操作步骤3、使用Ctrl+Y或Ctrl+Shift+Z快捷键恢复刚才撤销的操作步骤');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持Ctrl+Y或Ctrl+Shift+Z快捷键撤销操作 end');
}

/**
 * 大图-格式: [编辑支持Ctrl +/-放大缩小预览图片]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_PC_Shortcut_Keys_017
 * 前置条件
 * 1、图库中存在不同格式的图片和视频文件
 */
async function Multimedia_Gallery_PC_Shortcut_Keys_017(dt: Dt) {
  dt.log.i('编辑支持Ctrl +/-放大缩小预览图片 start');
  dt.log.i('STEP 1、在图库选中图片进入编辑页面');

  
  dt.log.i('预期结果1、图片以当前预览中心点为锚点进行缩放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看预览图片');

  
  dt.log.i('STEP 3、使用Ctrl +/-放大缩小预览图片');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持Ctrl +/-放大缩小预览图片 end');
}

