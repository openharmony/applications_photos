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

import { Level } from '@ohos/hypium';
import { ON} from '@ohos.UiTest';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function MultimediaGalleryEditUndoRedoTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  run('Multimedia_Gallery_Edit_Undo_Redo_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-大图用例: [图片编辑多功能交互撤销重做功能验证] TID: Multimedia_Gallery_Edit_Undo_Redo_001
    await Multimedia_Gallery_Edit_Undo_Redo_001(dt);
  });
  run('Multimedia_Gallery_Edit_Undo_Redo_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-大图用例: [图片编辑裁剪撤销重做功能验证] TID: Multimedia_Gallery_Edit_Undo_Redo_002
    await Multimedia_Gallery_Edit_Undo_Redo_002(dt);
  });
  run('Multimedia_Gallery_Edit_Undo_Redo_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-大图用例: [图片编辑调节撤销重做功能验证] TID: Multimedia_Gallery_Edit_Undo_Redo_003
    await Multimedia_Gallery_Edit_Undo_Redo_003(dt);
  });
  run('Multimedia_Gallery_Edit_Undo_Redo_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-大图用例: [图片编辑滤镜撤销重做功能验证] TID: Multimedia_Gallery_Edit_Undo_Redo_004
    await Multimedia_Gallery_Edit_Undo_Redo_004(dt);
  });
  run('Multimedia_Gallery_Edit_Undo_Redo_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-大图用例: [AI修图内撤销重做功能验证] TID: Multimedia_Gallery_Edit_Undo_Redo_005
    await Multimedia_Gallery_Edit_Undo_Redo_005(dt);
  });
}

/**
 * 编辑-大图: [图片编辑多功能交互撤销重做功能验证]
 * GROUP: 编辑 MODULE: 大图TID: Multimedia_Gallery_Edit_Undo_Redo_001
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 */
async function Multimedia_Gallery_Edit_Undo_Redo_001(dt: Dt) {
  dt.log.i('图片编辑多功能交互撤销重做功能验证 start');
  dt.log.i('STEP 1、大图浏览界面点击编辑');

  await dt.sleep();
  dt.log.i('预期结果1、初始状态下撤销重做按钮不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行任意裁剪/调节/滤镜/水印操作后，点击撤销');

  await dt.sleep();
  dt.log.i('预期结果2、屏幕顶部播报本次撤销的操作功能类型，多次撤销功能顺序正确，效果撤销正确');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重做按钮');

  await dt.sleep();
  dt.log.i('预期结果3、屏幕顶部播报恢复的操作功能类型，多次重做功能顺序正确，效果恢复正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击进入ai修图后，侧滑返回');

  await dt.sleep();
  dt.log.i('预期结果4、撤销重做按钮不显示，图片为进入ai修图时样式');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进行任意裁剪/调节/滤镜/水印操作后，进入涂鸦后点击左上角返回');

  await dt.sleep();
  dt.log.i('预期结果5、撤销重做按钮状态与进入涂鸦前一致，支持向前撤销重做');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、进入涂鸦，绘制后点击右上角保存按钮');

  await dt.sleep();
  dt.log.i('预期结果6、撤销重做按钮不显示，涂鸦已保存');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑多功能交互撤销重做功能验证 end');
}

/**
 * 编辑-大图: [图片编辑裁剪撤销重做功能验证]
 * GROUP: 编辑 MODULE: 大图TID: Multimedia_Gallery_Edit_Undo_Redo_002
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 */
async function Multimedia_Gallery_Edit_Undo_Redo_002(dt: Dt) {
  dt.log.i('图片编辑裁剪撤销重做功能验证 start');
  dt.log.i('STEP 1、大图浏览界面点击编辑');

  await dt.sleep();
  dt.log.i('预期结果1、初始状态下撤销重做按钮不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击旋转按钮');

  await dt.sleep();
  dt.log.i('预期结果2、旋转后界面顶部显示撤销重做按钮，撤销按钮高亮，重做按钮置灰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果3、屏幕顶部依次播报“撤销：90゜旋转”、“恢复：90゜旋转”，撤销/恢复效果正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：90゜旋转', true);
  dt.log.i('STEP 4、调节任意旋转角度后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果4、屏幕顶部依次播报“撤销：旋转”、“恢复：旋转”，撤销/恢复效果正确，刻度变化正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：旋转', true);
  dt.log.i('STEP 5、点击镜像后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果5、屏幕顶部依次播报“撤销：镜像”、“恢复：镜像”，撤销/恢复效果正确，刻度变化正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：镜像', true);
  dt.log.i('STEP 6、调节水平矫正刻度后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果6、屏幕顶部依次播报“撤销：水平矫正”、“恢复：水平矫正”，撤销/恢复效果正确，刻度变化正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：水平矫正', true);
  dt.log.i('STEP 7、调节垂直矫正刻度后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果7、屏幕顶部依次播报“撤销：比例”、“恢复：比例”，撤销/恢复效果正确，刻度变化正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：比例', true);
  dt.log.i('STEP 8、调节比例选项后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果8、屏幕顶部依次播报“撤销：比例”、“恢复：比例”，撤销/恢复效果正确，刻度变化正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：比例', true);
  dt.log.i('STEP 9、裁剪图片后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果9、屏幕顶部依次播报“撤销：画面裁切”、“恢复：画面裁切”，撤销/恢复效果正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：画面裁切', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑裁剪撤销重做功能验证 end');
}

/**
 * 编辑-大图: [图片编辑调节撤销重做功能验证]
 * GROUP: 编辑 MODULE: 大图TID: Multimedia_Gallery_Edit_Undo_Redo_003
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 */
async function Multimedia_Gallery_Edit_Undo_Redo_003(dt: Dt) {
  dt.log.i('图片编辑调节撤销重做功能验证 start');
  dt.log.i('STEP 1、大图浏览界面点击编辑-调节');

  await dt.sleep();
  dt.log.i('预期结果1、初始状态下撤销重做按钮不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、开启一键调节后依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果2、开启一键调节后界面顶部显示撤销重做按钮，撤销高亮，重做置灰；撤销重做操作时，屏幕顶部依次播报“撤销：一键调节开启”、“恢复：一键调节开启”，撤销/恢复效果正确');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('撤销：一键调节开启'));
  dt.log.i('STEP 3、关闭一键调节后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果3、屏幕顶部依次播报“撤销：一键调节关闭”、“恢复：一键调节关闭”，撤销/恢复效果正确');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：一键调节关闭', true);
  dt.log.i('STEP 4、调节曝光/高光/阴影/亮度/对比度/亮部/暗部/饱和度/自然饱和度/色温/色调/锐度/暗角/褪色/颗粒后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果4、屏幕顶部播报功能调节正确：如“撤销：曝光调节”、“恢复：亮度调节”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('撤销：曝光调节', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑调节撤销重做功能验证 end');
}

/**
 * 编辑-大图: [图片编辑滤镜撤销重做功能验证]
 * GROUP: 编辑 MODULE: 大图TID: Multimedia_Gallery_Edit_Undo_Redo_004
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 */
async function Multimedia_Gallery_Edit_Undo_Redo_004(dt: Dt) {
  dt.log.i('图片编辑滤镜撤销重做功能验证 start');
  dt.log.i('STEP 1、大图浏览界面点击编辑-滤镜');

  await dt.sleep();
  dt.log.i('预期结果1、初始状态下撤销重做按钮不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、调节任意滤镜后，依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果2、切换滤镜后界面顶部显示撤销重做按钮，撤销高亮，重做置灰；撤销重做操作时，屏屏幕顶部播报撤销/恢复滤镜正确，撤销/恢复效果正确');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑滤镜撤销重做功能验证 end');
}

/**
 * 编辑-大图: [AI修图内撤销重做功能验证]
 * GROUP: 编辑 MODULE: 大图TID: Multimedia_Gallery_Edit_Undo_Redo_005
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 */
async function Multimedia_Gallery_Edit_Undo_Redo_005(dt: Dt) {
  dt.log.i('AI修图内撤销重做功能验证 start');
  dt.log.i('STEP 1、大图浏览界面点击编辑-AI修图');

  await dt.sleep();
  dt.log.i('预期结果1、初始状态下撤销重做按钮不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入人像精修后，点击一键精修');

  await dt.sleep();
  dt.log.i('预期结果2、界面顶部显示撤销重做按钮，撤销高亮，重做置灰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、依次点击撤销、重做');

  await dt.sleep();
  dt.log.i('预期结果3、撤销/恢复效果正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击切换色调/调节虚化/光影后，点击撤销/重做');

  await dt.sleep();
  dt.log.i('预期结果4、撤销/恢复效果正确，图像显示效果正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、选择消除，选中消除区域后点击撤销/重做');

  await dt.sleep();
  dt.log.i('预期结果5、选中效果可撤销/恢复');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击一键消除后，点击撤销/重做');

  await dt.sleep();
  dt.log.i('预期结果6、消除效果可撤销/恢复');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、选择消除区域后进入扩图');

  await dt.sleep();
  dt.log.i('预期结果7、选中区域自动消失，点击撤销跳过选中操作，撤销选中前的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、移动扩图图片位置，点击一键扩图后点击撤销/重做');

  await dt.sleep();
  dt.log.i('预期结果8、扩图效果可撤销/恢复，图片移动位置可撤销/恢复');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、进入背景，调节背景虚化/背景去色');

  await dt.sleep();
  dt.log.i('预期结果9、背景虚化//去色效果可撤销/恢复，图片效果变化正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('AI修图内撤销重做功能验证 end');
}