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

// 补充完成后修改为 run as run
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { describe } from '@ohos/hypium';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import {
  assertClickById,
  endTask,
  getTask,
  loggedTask,
  ShootStaticPhoto,
  SkipBootPage,
  StartCamera,
  StartPhotos,
  startTask,
  swipeIn,
  swipeSearch,
  testClickById,
  UpdateOrientation
} from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';

const TAG: string = `DT/EditorTest`;

export default function browserEditorTest(): void {
  describe('EditorTest', () => {
    run('Browser_take_photo', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await StartCamera();
      await ShootStaticPhoto();
    });
    run('Browser_Edit_start_photo', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await StartPhotos();
      await SkipBootPage();
    });
    run('Browser_Edit_Test03', TestConstants.TEST_LEVEL_ZERO, getTask(Browser_Edit_Test03));
    run('Browser_Edit_Test04', TestConstants.TEST_LEVEL_ZERO, getTask(Browser_Edit_Test04));
    run('Browser_Edit_Test05', TestConstants.TEST_LEVEL_ZERO, getTask(Browser_Edit_Test05));
  });
  describe('EditorWatermark', () => {
    run('Browser_Edit_Watermark_AddText', TestConstants.TEST_LEVEL_ZERO, startTask(Browser_Edit_AddText));
    run('Browser_Edit_Test06_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Test06_1));
    // 通用水印
    run('Browser_Edit_Test06_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Test06_2));
    run('Browser_Edit_Watermark_SwitchTab1', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Switch_Tab));
    // 画框水印
    run('Browser_Edit_Test06_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Test06_3));
    run('Browser_Edit_Watermark_SwitchTab2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Switch_Tab));
    run('Browser_Edit_Test06_4', TestConstants.TEST_LEVEL_ZERO, endTask(Browser_Edit_Test06_4));
  });
  describe('EditorCrop', () => {
    run('Browser_Edit_Test01', TestConstants.TEST_LEVEL_ZERO, startTask(Browser_Edit_Test01));
    run('Browser_Edit_Crop', TestConstants.TEST_LEVEL_ZERO, endTask(Browser_Edit_Crop));
  });
  describe('EditorAdjust', () => {
    run('Browser_Edit_Test02_1', TestConstants.TEST_LEVEL_ZERO, startTask(Browser_Edit_Test02_1));
    run('Browser_Edit_Test02_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Test02_2));
    run('Browser_Edit_Test02_3', TestConstants.TEST_LEVEL_ZERO, endTask(Browser_Edit_Test02_3));
  });
  describe('EditorText', () => {
    run('Browser_Edit_Test07_1', TestConstants.TEST_LEVEL_ZERO, startTask(Browser_Edit_Test07_1));
    run('Browser_Edit_Test07_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Browser_Edit_Test07_2));
    run('Browser_Edit_Test07_3', TestConstants.TEST_LEVEL_ZERO, endTask(Browser_Edit_Test07_3));
  });
}

/**
 * 1、图片旋转
 * 2、图片镜像
 * 3、将图片进行旋转
 * 4、将图片进行水平校正
 * 5、将图片进行垂直校正
 * 6、点击比例，切换成全屏、1:1、3:2、2:3、4:3、3:4、9:16、16:9
 * 7、切换成原始比例*/
async function Browser_Edit_Test01(driver: Driver) {
  // 图片旋转
  await testClickById(driver, 'petalclip_CropTool_rotateBtn', 'petalclip_CropTool_rotateBtn clicked');

  // 图片镜像
  await testClickById(driver, 'petalclip_CropTool_mirrorBtn', 'petalclip_CropTool_mirrorBtn clicked');

  //图片旋转
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(966, 2050, 400, 2050);

  // 图片水平校正
  await testClickById(driver, 'cropTab_horizontalCorrection_off', 'cropTab_horizontalCorrection_off clicked');
  await driver.swipe(666, 2050, 950, 2050);

  // 图片垂直校正
  await testClickById(driver, 'cropTab_verticalCorrection_off', 'cropTab_verticalCorrection_off clicked');
  await driver.swipe(466, 2050, 650, 2050);
  // 点击调节
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'petalClip_bottomToolBar_image_2', 'petalClip_bottomToolBar_image_2 clicked');
  // 点击裁剪
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'petalClip_bottomToolBar_image_1', 'petalClip_bottomToolBar_image_1 clicked');
}

async function Browser_Edit_Crop(driver: Driver) {
  // 点击比例，切换成全屏
  await testClickById(driver, 'cropTab_ratio_off', 'cropTab_ratio_off clicked');
  await driver.swipe(280, 2057, 850, 2057);
  await driver.swipe(280, 2057, 850, 2057);
  await testClickById(driver, 'petalclip_ScaleSelection_2', 'petalclip_ScaleSelection_2 clicked');

  // 点击原始
  await testClickById(driver, 'petalclip_ScaleSelection_0', 'petalclip_ScaleSelection_0 clicked');
  // 再次点击原始
  await testClickById(driver, 'petalclip_ScaleSelection_0', 'petalclip_ScaleSelection_0 clicked');

  // 滑动调节栏，点击1:1
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(840, 2057, 650, 2057);
  await testClickById(driver, 'petalclip_ScaleSelection_3', 'petalclip_ScaleSelection_3 clicked');

  // 点击3:2
  await testClickById(driver, 'petalclip_ScaleSelection_4', 'petalclip_ScaleSelection_4 clicked');

  // 滑动调节栏，点击4:3
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(840, 2057, 330, 2057);
  await testClickById(driver, 'petalclip_ScaleSelection_6', 'petalclip_ScaleSelection_6 clicked');

  // 滑动调节栏，点击16:9
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(840, 2057, 330, 2057);
  await testClickById(driver, 'petalclip_ScaleSelection_9', 'petalclip_ScaleSelection_9 clicked');
}

/**
 * 1、点击文字
 * 2、点击添加文本，拉起输入框
 * 3、输入文字,点击完成
 * 4、点击样式并修改
 * 5、点击蒙层，关闭样式弹窗*/
async function Browser_Edit_Test07_1(driver: Driver) {
  // 点击文字
  await testClickById(driver, 'petalClip_bottomToolBar_image_7', 'petalClip_bottomToolBar_image_7 clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击添加文本，拉起输入框
  await testClickById(driver, 'textTab_default_on', 'textTab_default_on clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 输入文本
  let input = await driver.findComponent(ON.id('text_edit_input_tab'));
  const text = 'test input text';
  await input.inputText(text);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 完成輸入
  await testClickById(driver, 'edit_box_check_mark', 'edit_box_check_mark clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  //点击样式
  await testClickById(driver, 'textTab_style_off', 'textTab_style_off clicked');
  //修改字体颜色
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'styles_font_color_4', 'styles_font_color_4 clicked');
  //字体加粗、斜体、下划线
  await testClickById(driver, 'text_editor_font_bold', 'text_editor_font_bold clicked');
  await testClickById(driver, 'text_editor_font_italic', 'text_editor_font_italic clicked');
  await testClickById(driver, 'text_editor_font_underline', 'text_editor_font_underline clicked');

  //阴影和背景
  await testClickById(driver, 'text_editor_font_style', 'text_editor_font_style clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'text_editor_font_style_background', 'text_editor_font_style_background clicked');
  //对齐方式
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'text_editor_align', 'text_editor_align clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'text_editor_align_left', 'text_editor_align_left clicked');
  // 点击蒙层，关闭样式弹窗
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'textedit_ClickImage', 'textedit_ClickImage clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  //文本框获焦后点击复制、编辑
  let textRichEditor = await driver.findComponent(ON.text('test input text'));
  await textRichEditor.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'edit_image_copy', 'edit_image_copy clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'edit_image_edit', 'edit_image_edit clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 输入文本
  let copyInput = await driver.findComponent(ON.id('text_edit_input_tab'));
  const copyText = 'test copy input text';
  await copyInput.inputText(copyText);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 完成輸入
  await testClickById(driver, 'edit_box_check_mark', 'edit_box_check_mark clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

/**
 * 1、删除
 * 2、redo、undo
 * */
async function Browser_Edit_Test07_2(driver: Driver) {
  //删除
  await testClickById(driver, 'edit_image_delete', 'edit_image_delete clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  //undo
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  //redo
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');
}

/**
 * 1、点击退出编辑
 * 2、点击保存*/
async function Browser_Edit_Test07_3(driver: Driver) {
  //点击退出编辑
  await testClickById(driver, 'petalClip_topToolBar_back', 'petalClip_topToolBar_back clicked');
  //点击取消
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');
  // 点击保存
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'petalClip_topToolBar_save', 'petalClip_topToolBar_save clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  let save = await driver.findComponent(ON.text('覆盖原图'));
  await save.click();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

/**
 * 1、点击调节
 * 2、点击曝光，调节曝光
 * 3、点击亮度，调节亮度
 * 4、点击对比度，调节对比度
 * 5、点击亮部，调节
 * 6、点击暗部，调节
 * 7、点击自然饱和度，调节
 * 8、点击褪色，调节
 * 9、点击颗粒，调节
 * 10、点击颗粒，取消颗粒效果
 * 11、点击颗粒，恢复颗粒效果
 * 12、点击保存*/
async function Browser_Edit_Test02_1(driver: Driver) {
  // 点击调节
  await testClickById(driver, 'petalClip_bottomToolBar_image_2', 'petalClip_bottomToolBar_image_2 clicked');
  // 调节一键调节强度
  await testClickById(driver, 'petalClip_AdjustItem_auto_false', 'petalClip_AdjustItem_auto_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
}

async function Browser_Edit_Test02_2(driver: Driver) {
  // 调节曝光强度
  await testClickById(driver, 'petalClip_AdjustItem_exposure_false', 'petalClip_AdjustItem_exposure_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));

  // 点击亮度，调节亮度
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_brightness_false'));
  await testClickById(driver, 'petalClip_AdjustItem_brightness_false', 'petalClip_AdjustItem_brightness_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));

  // 点击对比度，调节对比度
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_contrast_false'));
  await testClickById(driver, 'petalClip_AdjustItem_contrast_false', 'petalClip_AdjustItem_contrast_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));

  //点击亮部并进行调节
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_brightzone_false'));
  await testClickById(driver, 'petalClip_AdjustItem_brightzone_false', 'petalClip_AdjustItem_brightzone_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  //点击褪色并进行调节
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_fade_false'));
  await testClickById(driver, 'petalClip_AdjustItem_fade_false', 'petalClip_AdjustItem_fade_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'), 'left');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Browser_Edit_Test02_3(driver: Driver) {
  //点击颗粒并进行调节
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_grain_false'));
  await testClickById(driver, 'petalClip_AdjustItem_grain_false', 'petalClip_AdjustItem_grain_false clicked');
  await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  //点击颗粒取消颗粒调节,之后恢复颗粒调节
  await testClickById(driver, 'petalClip_AdjustItem_grain_true', 'petalClip_AdjustItem_grain_true clicked');
  await testClickById(driver, 'petalClip_AdjustItem_grain_false', 'petalClip_AdjustItem_grain_false clicked');

  // 点击保存按钮
  await testClickById(driver, 'petalClip_topToolBar_save', 'petalClip_topToolBar_save clicked');
  const saveBtn = await driver.findComponent(ON.text('覆盖原图'));
  if (saveBtn) {
    await saveBtn.click();
  }
  await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  Log.info(TAG, 'Browser_Edit_Test02 end');
}


/**
 * 1、点击编辑按钮，点击滤镜
 * 2、点击设置日暮滤镜效果
 * 3、点击设置晶莹滤镜效果，设置效果强度
 * 4、点击设置黑白滤效果，设置效果强度
 * 5、长按对比查看对比效果
 */
async function Browser_Edit_Test03(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test03 start');
  // 点击滤镜
  const filterBtn = await driver.findComponent(ON.text('滤镜'));
  if (filterBtn) {
    await filterBtn.click();
  }

  // 点击自然滤镜效果
  await testClickById(driver, 'petalClip_imageSelection_item_text_Natural',
    'petalClip_imageSelection_item_text_Natural clicked');

  // 点击原图效果
  await testClickById(driver, 'petalClip_imageSelection_item_text_000000000000000000',
    'petalClip_imageSelection_item_text_000000000000000000 clicked');

  // 点击经典滤镜效果，设置效果强度
  await testClickById(driver, 'petalClip_imageSelection_item_text_Classic',
    'petalClip_imageSelection_item_text_Classic clicked');
  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Filter 经典 clicked and set strength');

  // 滑动滤镜栏，点击粉调滤镜效果，设置效果强度
  await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_imageSelection_item_text_Pink'), 'right');
  await testClickById(driver, 'petalClip_imageSelection_item_text_Pink',
    'petalClip_imageSelection_item_text_Pink clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Filter 粉调 clicked and set strength');

  // 旋转屏幕
  await UpdateOrientation();

  // 长按对比
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.assertComponentExist(ON.id('petalClip_VideoTrimTool_compareButton'));
  let compareButtonEdit = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
  await compareButtonEdit.longClick();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'CompareEditButton clicked');
  Log.info(TAG, 'Browser_Edit_Test03 end');
}

// 1、点击编辑按钮，点击水印
async function Browser_Edit_Test06_1(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test06 start');

  // 点击水印
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'), ON.text('水印'));
  const button = await driver.findComponent(ON.text('水印'));
  if (button) {
    await button.click();
  } else {
    Log.error(TAG, 'Browser_Edit_Test06 failed');
  }
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  // 点击通用水印，设置水印参数
  await testClickById(driver, 'petalClip_sealType_itemInplaceSticker', 'petalClip_sealType_itemInplaceSticker clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_time_general', 'sealInfo_time_general clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  // 画框水印效果，设置水印参数
  await testClickById(driver, 'petalClip_sealType_itemFrameSticker', 'petalClip_sealType_itemFrameSticker clicked');
  await testClickById(driver, 'sealInfo_time_pic_frame', 'sealInfo_time_pic_frame clicked');
  await testClickById(driver, 'sealInfo_param_pic_frame', 'sealInfo_param_pic_frame clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  // 点击无水印效果
  await testClickById(driver, 'petalClip_sealType_itemNoSticker', 'petalClip_sealType_itemNoSticker clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'FrameSticker clicked');
}

// * 2、点击设置通用水印效果，设置水印参数
async function Browser_Edit_Test06_2(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test06 start');

  // 点击通用水印，设置水印参数
  await testClickById(driver, 'petalClip_sealType_itemInplaceSticker', 'petalClip_sealType_itemInplaceSticker clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_time_general', 'sealInfo_time_general clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

//   * 3、点击设置画框水印效果，设置水印参数
async function Browser_Edit_Test06_3(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test06 start');
  // 画框水印效果，设置水印参数
  await testClickById(driver, 'petalClip_sealType_itemFrameSticker', 'petalClip_sealType_itemFrameSticker clicked');
  await testClickById(driver, 'sealInfo_time_pic_frame', 'sealInfo_time_pic_frame clicked');
  await testClickById(driver, 'sealInfo_param_pic_frame', 'sealInfo_param_pic_frame clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

//   * 4、点击设置无水印效果
async function Browser_Edit_Test06_4(driver: Driver) {
  // 点击无水印效果
  await testClickById(driver, 'petalClip_sealType_itemNoSticker', 'petalClip_sealType_itemNoSticker clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  //撤销
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'FrameSticker clicked');
}

/**
 * 1、点击撤销
 * 2、点击恢复
 * 3、点击返回，点击取消
 * 4、点击保存
 */
async function Browser_Edit_Test04(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test04 start');
  // 点击水印
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'), ON.text('水印'));
  const button = await driver.findComponent(ON.text('水印'));
  if (button) {
    await button.click();
  } else {
    Log.error(TAG, 'Browser_Edit_Test06 failed');
  }
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  // 点击通用水印，设置水印参数
  await testClickById(driver, 'petalClip_sealType_itemInplaceSticker', 'petalClip_sealType_itemInplaceSticker clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_model_general', 'sealInfo_model_general clicked');
  await testClickById(driver, 'sealInfo_time_general', 'sealInfo_time_general clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击撤销按钮
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');

  // 点击恢复按钮
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');

  // 点击返回按钮
  await testClickById(driver, 'petalClip_topToolBar_back', 'petalClip_topToolBar_back clicked');

  // 点击取消
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');

  // 点击保存
  await testClickById(driver, 'petalClip_topToolBar_save', 'petalClip_topToolBar_save clicked');
  const saveBtn = await driver.findComponent(ON.text('另存为'));
  if (saveBtn) {
    await saveBtn.click();
  }
  await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  Log.info(TAG, 'Browser_Edit_Test04 end');
}

/**
 * 1、点击编辑按钮
 * 2、点击复原，确定复原
 * 返回主页
 */
async function Browser_Edit_Test05(driver: Driver) {
  Log.info(TAG, 'Browser_Edit_Test05 start');

  //点击复原
  await testClickById(driver, 'petalClip_topToolBar_topTool_recover', 'petalClip_topToolBar_topTool_recover clicked');

  //确定
  await testClickById(driver, 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
  await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  Log.info(TAG, 'Browser_Edit_Test05 end');
}

// 添加文本框
async function Browser_Edit_AddText(driver: Driver) {
  // 点击文字
  await assertClickById('petalClip_bottomToolBar_7');
  // 添加文本
  await assertClickById('textTab_default_on');
  // 点击完成
  await assertClickById('edit_box_check_mark');
}

// 切换水印&文本tab
async function Browser_Edit_Switch_Tab(driver: Driver) {
  // 水印
  await assertClickById('petalClip_bottomToolBar_5');
  // 点击文字
  await assertClickById('petalClip_bottomToolBar_7');
  // 点击裁剪
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'), ON.id('petalClip_bottomToolBar_image_1'), 'left');
  await assertClickById('petalClip_bottomToolBar_image_1');
  // 水印
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'), ON.id('petalClip_bottomToolBar_image_5'));
  await assertClickById('petalClip_bottomToolBar_5');
}
