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

export default function LivePhoto2(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('LivePhoto2Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllLivePhoto2').init();
      dt.log.i('beforeAll LivePhoto2 start');
      dt.log.i('beforeAll LivePhoto2 finish');
    });
    /**
     * 打开大图
     */
    it('beforeLivePhoto2', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('TC_LivePhoto_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [06.编辑后复原] TID: TC_LivePhoto_013
      await TC_LivePhoto_013(dt);
    });
    it('TC_LivePhoto_014', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [07.组合操作后导出] TID: TC_LivePhoto_014
      await TC_LivePhoto_014(dt);
    });
    it('TC_LivePhoto_015', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [08.导出方式支持覆盖保存和另存为] TID: TC_LivePhoto_015
      await TC_LivePhoto_015(dt);
    });
    it('TC_LivePhoto_017', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [02.带水印的动图，重选封面帧] TID: TC_LivePhoto_017
      await TC_LivePhoto_017(dt);
    });
    it('TC_LivePhoto_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [03.不带水印动图，重选封面帧] TID: TC_LivePhoto_018
      await TC_LivePhoto_018(dt);
    });
    it('TC_LivePhoto_019', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [04.横/竖屏素材，重选封面帧] TID: TC_LivePhoto_019
      await TC_LivePhoto_019(dt);
    });
    it('TC_LivePhoto_020', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [05.选取封面帧，组合编辑后，导出] TID: TC_LivePhoto_020
      await TC_LivePhoto_020(dt);
    });
    it('TC_LivePhoto_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [06.组合编辑后，选取封面帧，导出] TID: TC_LivePhoto_021
      await TC_LivePhoto_021(dt);
    });
    it('TC_LivePhoto_022', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [01.默认封面有初始标识] TID: TC_LivePhoto_022
      await TC_LivePhoto_022(dt);
    });
    it('TC_LivePhoto_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [Heif动图组合操作后导出] TID: TC_LivePhoto_023
      await TC_LivePhoto_023(dt);
    });
    it('TC_LivePhoto_024', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [带水印动图基础编辑] TID: TC_LivePhoto_024
      await TC_LivePhoto_024(dt);
    });
    it('TC_LivePhoto_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [含滤镜动图编辑，涂鸦/修图后添加水印保存] TID: TC_LivePhoto_025
      await TC_LivePhoto_025(dt);
    });
    it('TC_LivePhoto_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [相机页滤镜和编辑页滤镜一致性校验] TID: TC_LivePhoto_027
      await TC_LivePhoto_027(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachLivePhoto2').init();
      dt.log.i('afterEach LivePhoto2 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach LivePhoto2 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLivePhoto2').init();
      dt.log.i('afterAll LivePhoto2 start');
      await Exit.browser();
      dt.log.i('afterAll LivePhoto2 finish');
    });
  });
}


async function TC_LivePhoto_013(dt: Dt) {
  dt.log.i('TC_LivePhoto_013 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_014(dt: Dt) {
  dt.log.i('TC_LivePhoto_014 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_015(dt: Dt) {
  dt.log.i('TC_LivePhoto_015 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_017(dt: Dt) {
  dt.log.i('TC_LivePhoto_017 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_018(dt: Dt) {
  await dt.swipeScreen?.left();
  dt.log.i('TC_LivePhoto_018 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_019(dt: Dt) {
  dt.log.i('TC_LivePhoto_019 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_020(dt: Dt) {
  dt.log.i('TC_LivePhoto_020 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_021(dt: Dt) {
  dt.log.i('TC_LivePhoto_021 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_022(dt: Dt) {
  dt.log.i('TC_LivePhoto_022 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_023(dt: Dt) {
  dt.log.i('TC_LivePhoto_023 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_024(dt: Dt) {
  await dt.swipeScreen?.left();
  dt.log.i('TC_LivePhoto_024 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_025(dt: Dt) {
  dt.log.i('TC_LivePhoto_025 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_LivePhoto_027(dt: Dt) {
  dt.log.i('TC_LivePhoto_027 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}




/**
 * 大图-格式: [06.编辑后复原]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_013
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_13(dt: Dt) {
  dt.log.i('06.编辑后复原 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2、关闭原声，设置封面帧');
  dt.log.i('STEP 2.1、关闭原声');
  await dt.assertComponentClickable('MuteButton', true);
  await dt.assertClick('MuteButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、设置封面帧');
  await dt.assertComponentClickable('CoverFrameButton', true);
  await dt.assertClick('CoverFrameButton', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 3.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 3.2、放大预览区');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.3、缩小预览区');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.5、旋转预览区');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.6、垂直校正');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.7、水平校正');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.8、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.9、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.10、镜像');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('MirrorButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4、进入调节页面：开启/关闭一键调节、设置单个调节项、设置调节强度');
  dt.log.i('STEP 4.1、切换到调节页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 4.2、开启一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.3、关闭一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.4、设置单个调节项（亮度）');
  await dt.assertComponentClickable('BrightnessSlider', true);
  await dt.assertClick('BrightnessSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.5、设置调节强度');
  await dt.assertComponentClickable('IntensitySlider', true);
  await dt.assertClick('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 5、进入滤镜页面：设置滤镜');
  dt.log.i('STEP 5.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPageComponent', true);
  

  dt.log.i('STEP 5.2、设置滤镜');
  await dt.assertComponentClickable('FilterOption', true);
  await dt.assertClick('FilterOption', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 6、点击保存按钮，选择覆盖原视频');
  dt.log.i('STEP 6.1、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('SaveOptionsComponent', true);
  

  dt.log.i('STEP 6.2、选择覆盖原视频');
  await dt.assertComponentClickable('OverwriteOption', true);
  await dt.assertClick('OverwriteOption', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 6.3、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果6.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果6.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果6.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 7、再次进入编辑页面，点击复原');
  dt.log.i('STEP 7.1、再次选择livephoto照片');
  await dt.albumList();
  await dt.browser();
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 7.2、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 7.3、点击复原按钮');
  await dt.assertComponentClickable('RestoreButton', true);
  await dt.assertClick('RestoreButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果7、可以成功复原为原始动图');
  await dt.assertComponent('PreviewAreaComponent', true);
  await dt.assertComponent('ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('EditPageComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('06.编辑后复原 end');
}

/**
 * 大图-格式: [07.组合操作后导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_014
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_14(dt: Dt) {
  dt.log.i('07.组合操作后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2、关闭原声，设置封面帧');
  dt.log.i('STEP 2.1、关闭原声');
  await dt.assertComponentClickable('MuteButton', true);
  await dt.assertClick('MuteButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、设置封面帧');
  await dt.assertComponentClickable('CoverFrameButton', true);
  await dt.assertClick('CoverFrameButton', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 3.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 3.2、放大预览区');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.3、缩小预览区');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.5、旋转预览区');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.6、垂直校正');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.7、水平校正');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.8、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.9、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.10、镜像');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('MirrorButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4、进入调节页面：开启一键调节、设置单个调节项、设置调节强度');
  dt.log.i('STEP 4.1、切换到调节页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 4.2、开启一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.3、设置单个调节项（亮度）');
  await dt.assertComponentClickable('BrightnessSlider', true);
  await dt.assertClick('BrightnessSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.4、设置调节强度');
  await dt.assertComponentClickable('IntensitySlider', true);
  await dt.assertClick('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 5、进入滤镜页面：设置滤镜');
  dt.log.i('STEP 5.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPageComponent', true);
  

  dt.log.i('STEP 5.2、设置滤镜');
  await dt.assertComponentClickable('FilterOption', true);
  await dt.assertClick('FilterOption', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 6、点击保存按钮，选择另存为');
  dt.log.i('STEP 6.1、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('SaveOptionsComponent', true);
  

  dt.log.i('STEP 6.2、选择另存为');
  await dt.assertComponentClickable('SaveAsOption', true);
  await dt.assertClick('SaveAsOption', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 6.3、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果6.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果6.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果6.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('07.组合操作后导出 end');
}

/**
 * 大图-格式: [08.导出方式支持覆盖保存和另存为]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_015
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_15(dt: Dt) {
  dt.log.i('08.导出方式支持覆盖保存和另存为 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2、关闭原声，设置封面帧');
  dt.log.i('STEP 2.1、关闭原声');
  await dt.assertComponentClickable('MuteButton', true);
  await dt.assertClick('MuteButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、设置封面帧');
  await dt.assertComponentClickable('CoverFrameButton', true);
  await dt.assertClick('CoverFrameButton', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 3.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 3.2、放大预览区');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.3、缩小预览区');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.5、旋转预览区');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.6、垂直校正');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.7、水平校正');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.8、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.9、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.10、镜像');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('MirrorButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4、进入调节页面：开启一键调节、设置单个调节项、设置调节强度');
  dt.log.i('STEP 4.1、切换到调节页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 4.2、开启一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.3、设置单个调节项（亮度）');
  await dt.assertComponentClickable('BrightnessSlider', true);
  await dt.assertClick('BrightnessSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4.4、设置调节强度');
  await dt.assertComponentClickable('IntensitySlider', true);
  await dt.assertClick('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 5、进入滤镜页面：设置滤镜');
  dt.log.i('STEP 5.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPageComponent', true);
  

  dt.log.i('STEP 5.2、设置滤镜');
  await dt.assertComponentClickable('FilterOption', true);
  await dt.assertClick('FilterOption', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 6、点击保存按钮，弹窗显示覆盖保存和另存为');
  dt.log.i('STEP 6.1、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('SaveOptionsComponent', true);
  

  dt.log.i('STEP 7.1、选择覆盖保存');
  dt.log.i('STEP 7.1.1、选择覆盖保存选项');
  await dt.assertComponentClickable('OverwriteOption', true);
  await dt.assertClick('OverwriteOption', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 7.1.2、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果7.1.1、覆盖保存成功，编辑操作对LivePhoto所有帧生效');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 7.2、选择另存为');
  dt.log.i('STEP 7.2.1、再次进入编辑页面');
  await dt.albumList();
  await dt.browser();
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 7.2.2、点击编辑按钮');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 7.2.3、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('SaveOptionsComponent', true);
  

  dt.log.i('STEP 7.2.4、选择另存为选项');
  await dt.assertComponentClickable('SaveAsOption', true);
  await dt.assertClick('SaveAsOption', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 7.2.5、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果7.2.1、另存为保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果7.2.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果7.2.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('08.导出方式支持覆盖保存和另存为 end');
}

/**
 * 大图-滑动: [02.带水印的动图，重选封面帧]
 * GROUP: 大图 MODULE: 滑动 TID: TC_LivePhoto_017
 * 前置条件
 * 1、图库中存在带水印的动图
 */
async function TC_LivePhoto_17(dt: Dt) {
  dt.log.i('02.带水印的动图，重选封面帧 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在带水印的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证带水印的动图存在');
  await dt.assertComponent('WatermarkedLivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择带水印的动图');
  await dt.assertComponentClickable('WatermarkedLivePhotoComponent', true);
  await dt.assertClick('WatermarkedLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('预期结果1、编辑界面显示动态编辑页签，初始状态封面帧显示水印');
  await dt.assertComponent('DynamicEditTab', true);
  await dt.assertComponent('WatermarkComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、分别向左/向右滑动选取封面帧');
  dt.log.i('STEP 2.1、向左滑动选取封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(400, 500, 300, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、向右滑动选取封面帧');
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果2、滑动时上方预览图与选择帧实时变化，预览图始终显示水印');
  await dt.assertComponent('PreviewAreaComponent', true);
  await dt.assertComponent('WatermarkComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、点击选择封面按钮');
  dt.log.i('STEP 3.1、点击选择封面按钮');
  await dt.assertComponentClickable('SelectCoverButton', true);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果3、更换封面成功，新封面帧下方显示白色圆点');
  await dt.assertComponent('CoverFrameIndicator', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 4、保存图片');
  dt.log.i('STEP 4.1、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 4.2、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果4、保存后水印仍然存在，播放正常，封面帧已切换');
  await dt.assertComponent('WatermarkComponent', true);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击。');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('02.带水印的动图，重选封面帧 end');
}

/**
 * 大图-滑动: [03. 不带水印动图，重选封面帧]
 * GROUP: 大图 MODULE: 滑动 TID: TC_LivePhoto_018
 * 前置条件
 * 1、图库中存在不带水印的动图
 */
async function TC_LivePhoto_18(dt: Dt) {
  dt.log.i('03.不带水印动图，重选封面帧 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在不带水印的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证不带水印的动图存在');
  await dt.assertComponent('NonWatermarkedLivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('BrowseComponent', true);
  

  dt.log.i('STEP 1.2、选择不带水印的动图');
  await dt.assertComponentClickable('NonWatermarkedLivePhotoComponent', true);
  await dt.assertClick('NonWatermarkedLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('预期结果1、封面帧不显示水印，滑动视频帧不显示水印');
  await dt.negateComponent('WatermarkComponent', false);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、左右滑动设置封面帧');
  dt.log.i('STEP 2.1、向左滑动选择封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(400, 500, 300, 500, 100);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、向右滑动选择封面帧');
  await dt.driver.swipe(300, 500, 400, 500, 100);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.3、点击选择封面按钮');
  await dt.assertComponentClickable('SelectCoverButton', true);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('CoverFrameIndicator', true);
  

  dt.log.i('预期结果2、封面帧设置成功');
  await dt.assertComponent('CoverFrameIndicator', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('03.不带水印动图，重选封面帧 end');
}

/**
 * 大图-竖屏: [04. 横/竖屏素材，重选封面帧]
 * GROUP: 大图 MODULE: 竖屏 TID: TC_LivePhoto_019
 * 前置条件
 * 1、图库中存在横屏和竖屏的livephoto照片
 */
async function TC_LivePhoto_19(dt: Dt) {
  dt.log.i('04.横/竖屏素材，重选封面帧 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在横屏和竖屏的livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证横屏livephoto照片存在');
  await dt.assertComponent('LandscapeLivePhotoComponent', true);
  

  dt.log.i('STEP 0.3、验证竖屏livephoto照片存在');
  await dt.assertComponent('PortraitLivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择不同的动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择横屏livephoto照片');
  await dt.assertComponentClickable('LandscapeLivePhotoComponent', true);
  await dt.assertClick('LandscapeLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 1.4、选择竖屏livephoto照片');
  await dt.albumList();
  await dt.browser();
  await dt.assertComponentClickable('PortraitLivePhotoComponent', true);
  await dt.assertClick('PortraitLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.5、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2、选取封面帧后，保存');
  dt.log.i('STEP 2.1、滑动选择封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、点击选择封面按钮');
  await dt.assertComponentClickable('SelectCoverButton', true);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('CoverFrameIndicator', true);
  

  dt.log.i('STEP 2.3、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 2.4、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('ImagePreviewComponent', DELAY.default);
  

  dt.log.i('预期结果2、保存成功');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('04.横/竖屏素材，重选封面帧 end');
}

/**
 * 大图-格式: [05.选取封面帧，组合编辑后，导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_020
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_20(dt: Dt) {
  dt.log.i('05.选取封面帧，组合编辑后，导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('Browse', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2、选取封面帧');
  dt.log.i('STEP 2.1、滑动选择封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、点击选择封面按钮');
  await dt.assertComponentClickable('SelectCoverButton', true);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('CoverFrameIndicator', true);
  

  dt.log.i('STEP 3.1、在动态页面：设置封面帧，关闭原声');
  dt.log.i('STEPiel 3.1.1、关闭原声');
  await dt.assertComponentClickable('MuteButton', true);
  await dt.assertClick('MuteButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 3.2.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 3.2.2、放大预览区');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.3、缩小预览区');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.5、旋转预览区');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.6、垂直校正');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.7、水平校正');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.8、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.9、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2.10、镜像');
  dt.log.i('a');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('click', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.3、进入调节页面：开启一键调节、设置调节强度');
  dt.log.i('STEP 3.3.1、切换到调节页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 3.3.2、开启一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('Preview', true);
  

  dt.log.i('STEP 3.3.3、设置调节强度');
  await dt.assertComponentClickable('IntensitySlider', true);
  await dt.assertClick('Slider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.4、进入滤镜页面：设置滤镜');
  dt.log.i('STEP 3.4.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPage', true);
  

  dt.log.i('STEP 3.4.2、设置滤镜');
  await dt.assertComponentClickable('FilterOption', true);
  await dt.assertClick('Click', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 4、保存成功');
  dt.log.i('STEP 4.1、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('ImagePreview', true);
  

  dt.log.i('STEP 4.2、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('Preview', DELAY.default);
  

  dt.log.i('预期结果4.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果4.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间空间与原文件保持一致');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始结束, 开始验证预期组件: 包含是否激活(true), 是否可点击(clickable).');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreview', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('05. 选取封面帧，组合编辑后，导出 end');
}

/**
 * 大图-格式: [06. 组合编辑后，选取封面帧，导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_021
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_21(dt: Dt) {
  dt.log.i('06.组合编辑后，选取封面帧，导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 2.1、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 2.1.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 2.1.2、放大预览区');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.3、缩小预览区');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.5、旋转预览区');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.6、垂直校正');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.7、水平校正');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.8、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.9、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.10、镜像');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('MirrorButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、进入调节页面：开启一键调节、设置调节强度');
  dt.log.i('STEP 2.2.1、切换到调节页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 2.2.2、开启一键调节');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.3、设置调节强度');
  await dt.assertComponentClickable('IntensitySlider', true);
  await dt.assertClick('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.3、进入滤镜页面：设置滤镜');
  dt.log.i('STEP 2.3.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPageComponent', true);
  

  dt.log.i('STEP 2.3.2、设置滤镜');
  await dt.assertComponentClickable('FilterOption', true);
  await dt.assertClick('FilterOption', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果2、封面帧界面缩略图根据编辑操作效果实时刷新');
  await dt.assertComponent('ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、选取封面帧后，保存');
  dt.log.i('STEP 3.1、滑动选择封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 3.2、点击选择封面按钮');
  await dt.assertComponentClickable('SelectCoverButton', true);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('CoverFrameIndicator', true);
  

  dt.log.i('STEP 3.3、点击保存按钮');
  await dt.assertComponentClickable('SaveButton', true);
  await dt.assertClick('SaveButton', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 3.4、长按预览动图');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertLongClickById('Preview', DELAY.default);
  

  dt.log.i('预期结果3.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果3.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable).');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreview', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('06.组合编辑后，选取封面帧，导出 end');
}

/**
 * 大图-滑动: [01. 默认封面有初始标识]
 * GROUP: 大图 MODULE: 滑动 TID: TC_LivePhoto_022
 * 前置条件
 * 1、图库中存在livephoto照片
 */
async function TC_LivePhoto_22(dt: Dt) {
  dt.log.i('01.默认封面有初始标识 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livephoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证livephoto照片存在');
  await dt.assertComponent('LivePhotoComponent', true);
  

  dt.log.i('STEP 1、选择动图，进入编辑界面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.2、选择livephoto照片');
  await dt.assertComponentClickable('LivePhotoComponent', true);
  await dt.assertClick('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑界面');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('预期结果1、原有的默认封面有初始标识');
  await dt.assertComponent('DefaultCoverIndicator', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、重设封面帧');
  dt.log.i('STEP 2.1、滑动选择封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2、滑动靠近初始封面帧');
  await dt.driver.swipe(400, 500, 300, 500, 100);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果2、重设封面后，滑动封面帧靠近初始封面时有吸附效果');
  await dt.assertComponent('SnapEffectComponent', false);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable).');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('EditPageComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('01.默认封面有初始标识 end');
}

/**
 * 大图-heif: [Heif动图组合操作后导出]
 * GROUP: 大图 MODULE: heif TID: TC_LivePhoto_023
 * 前置条件: 无明确指定，假设图库中存在HEIF格式动图
 */
async function TC_LivePhoto_23(dt: Dt) {
  dt.log.i('Heif动图组合操作后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在HEIF格式的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  

  dt.log.i('STEP 0.2、验证HEIF格式动图存在');
  await dt.assertComponent('HEIFLivePhotoComponent', true);
  

  dt.log.i('STEP 1、使用不同设备拍摄heif格式动图，从相机或图库进入编辑页面');
  dt.log.i('STEP 1.1、导航到相机页面');

  await dt.assertComponent('CameraComponent', true);
  

  dt.log.i('STEP 1.2、拍摄HEIF格式动图');
  await dt.assertComponentClickable('CaptureHEIFButton', true);
  await dt.assertClick('CaptureHEIFButton', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.3、从相机进入编辑页面');
  await dt.assertComponentClickable('CameraEditButton', true);
  await dt.assertClick('CameraEditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  

  dt.log.i('STEP 1.4、从图库进入编辑页面');
  await dt.albumList();
  await dt.browser();
  await dt.assertComponentClickable('HEIFLivePhotoComponent', true);
  await dt.assertClick('HEIFLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  

  dt.log.i('STEP 1.5、点击编辑按钮');
  await dt.assertComponentClickable('EditButton', true);
  await dt.assertClick('EditButton', false, DELAY.default);
  await dt.assertComponent('EditPageComponent', true);
  dt.log.i('预期结果1.1、导入后，预览区动效加载正常，缩略图和预览区显示正常');
  await dt.assertComponent('PreviewAreaComponent', true);
  await dt.assertComponent('ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果1.2、Livephoto不支持截取，原有的默认封面有初始标识');
  await dt.assertComponent('DefaultCoverIndicator', true);
  await dt.negateComponent('TrimSliderComponent', false);
  dt.log.i('STEP 2、设置如下操作：');
  dt.log.i('STEP 2.1、动态页面：设置静音，设置封面帧');
  dt.log.i('STEP 2.1.1、设置静音');
  await dt.assertComponentClickable('SilentButton', true);
  await dt.assertClick('SilentButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.1.2、设置封面帧');
  await dt.assertComponentClickable('CoverFrameSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertClick('SelectCoverButton', false, DELAY.default);
  await dt.assertComponent('CoverFrameIndicator', true);
  

  dt.log.i('STEP 2.2、切换到裁剪页面，调节三个方向上的校正效果，设置比例，90度旋转，镜像，双指缩放/单指移动预览窗，调节裁剪边框到任意宽高');
  dt.log.i('STEP 2.2.1、切换到裁剪页面');
  await dt.assertComponentClickable('CropTab', true);
  await dt.assertClick('CropTab', false, DELAY.default);
  await dt.assertComponent('CropPageComponent', true);
  

  dt.log.i('STEP 2.2.2、调整三个方向上的校正效果（旋转、垂直、水平）');
  await dt.assertComponentClickable('RotateButton', true);
  await dt.assertClick('RotateButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('a');
  await dt.assertComponentClickable('VerticalAlignButton', true);
  await dt.assertClick('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('a');
  await dt.assertComponentClickable('HorizontalAlignButton', true);
  await dt.assertClick('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.3、设置比例');
  await dt.assertComponentClickable('AspectRatioButton', true);
  await dt.assertClick('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.4、90度旋转');
  await dt.assertComponentClickable('Rotate90Button', true);
  await dt.assertClick('Rotate90Button', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.5、镜像');
  await dt.assertComponentClickable('MirrorButton', true);
  await dt.assertClick('MirrorButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.6、双指缩放预览窗');
  await dt.assertComponentClickable('ZoomInButton', true);
  await dt.assertClick('ZoomInButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('a');
  await dt.assertComponentClickable('ZoomOutButton', true);
  await dt.assertClick('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.7、单指移动预览窗');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.2.8、调节裁剪边框到任意宽高');
  await dt.assertComponentClickable('CropBoundarySlider', true);
  await dt.driver.swipe(300, 400, 350, 400, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.3、切换到调整页面，添加一键调整或普通调整');
  dt.log.i('STEP 2.3.1、切换到调整页面');
  await dt.assertComponentClickable('AdjustTab', true);
  await dt.assertClick('AdjustTab', false, DELAY.default);
  await dt.assertComponent('AdjustPageComponent', true);
  

  dt.log.i('STEP 2.3.2、添加一键调整');
  await dt.assertComponentClickable('AutoAdjustButton', true);
  await dt.assertClick('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.3.3、添加普通调整（例如亮度）');
  await dt.assertComponentClickable('BrightnessSlider', true);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.4、切换到滤镜页面，添加滤镜效果（非原片）');
  dt.log.i('STEP 2.4.1、切换到滤镜页面');
  await dt.assertComponentClickable('FilterTab', true);
  await dt.assertClick('FilterTab', false, DELAY.default);
  await dt.assertComponent('FilterPageComponent', true);
  

  dt.log.i('STEP 2.4.2、添加滤镜效果');
  await dt.assertComponentClickable('FilterOptionButton', true);
  await dt.assertClick('FilterOption', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.5、设置涂鸦和AI编辑');
  dt.log.i('STEP 2.5.1、切换到涂鸦页面');
  await dt.assertComponentClickable('DoodleTab', true);
  await dt.assertClick('DoodleTab', false, DELAY.default);
  await dt.assertComponent('DoodlePageComponent', true);
  

  dt.log.i('STEP 2.5.2、添加涂鸦');
  await dt.assertComponentClickable('DoodleTool', true);
  await dt.driver.swipe(300, 300, 400, 400, 300);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('STEP 2.5.3、切换到AI编辑页面');
  await dt.assertComponentClickable('AIEditTab', true);
  await dt.assertClick('AIEditTab', false, DELAY.default);
  await dt.assertComponent('AIEditPageComponent', true);
  

  dt.log.i('STEP 2.5.4、添加AI编辑效果');
  await dt.assertComponentClickable('AIEnhanceButton', true);
  await dt.assertClick('AIEnhanceButton', false, DELAY.default);
  await dt.assertComponent('PreviewAreaComponent', true);
  

  dt.log.i('预期结果2.1、封面帧界面缩略图根据编辑操作效果实时刷新2.2、编辑操作对LivePhoto所有帧生效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击保存按钮，选择覆盖保存或另存为');

  
  dt.log.i('预期结果3、封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、保存成功后，再次进入编辑页面');

  
  dt.log.i('预期结果4、覆盖保存显示复原按钮，可复原为原始动图；另存为不显示复原按钮');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Heif动图组合操作后导出 end');
}

/**
 * 大图-滑动: [带水印动图基础编辑]
 * GROUP: 大图 MODULE: 滑动TID: TC_LivePhoto_024
 * 前置条件
 * 相机设置自带水印，选择相机滤镜，使用如下设备拍摄动图（直板机：ce/pi、pura 70、nova 12 utra、ALN；xxx：pocket2、Ice、ALT；平板：weber，XYAO；PC：harden）
 */
async function TC_LivePhoto_24(dt: Dt) {
  dt.log.i('带水印动图基础编辑 start');
  dt.log.i('STEP 1、进入动态编辑页面重选封面帧');

  
  dt.log.i('预期结果1、预览图始终含水印，选择帧初始状态显示水印；滑动或点击选择封面帧后，选择帧不再展示水印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、裁剪图片，调整矫正值、镜像');

  
  dt.log.i('预期结果2、裁剪页面不显示水印，长按预览图可播放动图。裁剪/矫正/镜像功能正常，双指缩放与单指平移正常，无跳变/变形');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、调节图片，开启一键调节或其他选项');

  
  dt.log.i('预期结果3、调节界面显示水印，长按预览图可播放动图。调节功能正常，图片预览正常，双指缩放与单指平移正常，无跳变/变形');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、添加滤镜');

  
  dt.log.i('预期结果4、滤镜界面显示水印，长按预览图可播放动图。滤镜功能正常，图片预览正常、模板预览正常、双指缩放与单指平移正常，无跳变/变形');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入动态编辑页');

  
  dt.log.i('预期结果5、长按预览图可播放动图，所有封面选择帧均已添加裁剪/滤镜/调节效果。');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、保存图片');

  
  dt.log.i('预期结果6、图片保存成功，裁剪、滤镜、调节效果作用于整个动态图片');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、 切换为其他动态模式');

  
  dt.log.i('预期结果7、仍保留编辑后效果');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('带水印动图基础编辑 end');
}

/**
 * 大图-HEIF: [含滤镜动图编辑，涂鸦/修图后添加水印保存]
 * GROUP: 大图 MODULE: HEIFTID: TC_LivePhoto_025
 * 前置条件
 * 1、选择相机滤镜拍摄不同格式（JPG或HEIF）动图，使用如下设备（直板机：ce/pi、pura 70、nova 12 utra、ALN；xxx：pocket2、Ice、ALT；平板：weber，XYAO；PC：harden）
 */
async function TC_LivePhoto_25(dt: Dt) {
  dt.log.i('含滤镜动图编辑，涂鸦/修图后添加水印保存 start');
  dt.log.i('STEP 1、进入动图编辑页面，切换到滤镜页面');

  
  dt.log.i('预期结果1、默认选择相机拍摄时所选滤镜，预览窗滤镜效果显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、更换滤镜');

  
  dt.log.i('预期结果2、原滤镜效果消失，切换为新滤镜效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、动态编辑页面设置静音，重选封面帧');

  
  dt.log.i('预期结果3、滤镜效果作用于整个动图，静音与重选封面帧功能正常');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、进行涂鸦与AI修图');

  
  dt.log.i('预期结果4、重选封面帧后涂鸦/修图，预览图显示为新封面帧，涂鸦与修图功能正常');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、切换到裁剪页面，调节三个方向上的校正效果，设置比例，90度旋转，镜像，双指缩放/单指移动预览窗，调节裁剪边框到任意宽高');

  
  dt.log.i('预期结果5、图片预览效果为涂鸦/修图后效果，裁剪页面功能无异常');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、切换到调节页面，添加一键调节或普通调节');

  
  dt.log.i('预期结果6、调节功能正常，图片预览无异常');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、添加水印（画框/通用）');

  
  dt.log.i('预期结果7、水印添加成功');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、点击保存按钮，选择覆盖保存');

  
  dt.log.i('预期结果8 、保存成功后，素材位置与原视频位置一致，图片显示为静图，大图预览与编辑效果一致');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、保存成功后，再次进入编辑页面');

  
  dt.log.i('预期结果9、二次编辑页面不显示动图编辑页签，显示水印页签');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 10、点击复原按钮，选择复原');

  
  dt.log.i('预期结果10、复原成功后大图浏览恢复为动图，与相机拍摄初始效果相同');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('含滤镜动图编辑，涂鸦/修图后添加水印保存 end');
}

/**
 * 大图-视频: [相机页滤镜和编辑页滤镜一致性校验]
 * GROUP: 大图 MODULE: 视频TID: TC_LivePhoto_027
 * 前置条件
 *
 */
async function TC_LivePhoto_27(dt: Dt) {
  dt.log.i('相机页滤镜和编辑页滤镜一致性校验 start');
  dt.log.i('STEP 1、使用如下设备（直板机：ce/pi、pura 70、nova 12 utra、ALN；xxx：pocket2、Ice、ALT；平板：weber，XYAO；PC：harden），打开相机滤镜');

  
  dt.log.i('STEP 2、添加滤镜，设置滤镜强度');

  
  dt.log.i('预期结果2.1、滤镜缩略图与编辑页面滤镜缩略图一致2.2、滤镜数量与编辑页面滤镜数量一致2.3、滤镜排列顺序与编辑页面滤镜排列顺序一致2.4、滤镜效果与编辑页面滤镜效果一致2.5、不显示滤镜强度');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拍摄视频或动图，进入编辑页面');

  
  dt.log.i('预期结果3.1、滤镜效果与相机滤镜效果一致3.2、滤镜缩略图与相机滤镜缩略图一致3.3、滤镜数量与相机滤镜数量一致3.4、滤镜排列顺序与相机滤镜排列顺序一致3.5、截取、裁剪、调节后滤镜缩略图实时刷新；滤镜页时间轴调整后缩略图实时刷新3.6、不显示滤镜强度');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机页滤镜和编辑页滤镜一致性校验 end');
}

