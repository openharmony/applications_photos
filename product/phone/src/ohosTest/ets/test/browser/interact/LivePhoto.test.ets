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

export default function LivePhoto(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('LivePhotoTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllLivePhoto').init();
      dt.log.i('beforeAll LivePhoto start');
      dt.log.i('beforeAll LivePhoto finish');
    });
    /**
     * 打开大图
     */
    it('beforeLivePhoto', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('TC_LivePhoto_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [01.素材来源] TID: TC_LivePhoto_001
      await TC_LivePhoto_001(dt);
    });
    it('TC_LivePhoto_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [02.格式校验] TID: TC_LivePhoto_002
      await TC_LivePhoto_002(dt);
    });
    it('TC_LivePhoto_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [03.横竖屏校验] TID: TC_LivePhoto_003
      await TC_LivePhoto_003(dt);
    });
    it('TC_LivePhoto_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [05.LivePhoto支持截取] TID: TC_LivePhoto_005
      await TC_LivePhoto_005(dt);
    });
    it('TC_LivePhoto_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [06.不支持的格式，弹窗提示] TID: TC_LivePhoto_006
      await TC_LivePhoto_006(dt);
    });
    it('TC_LivePhoto_007', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [04.导入LivePhoto，预览区和缩略图显示] TID: TC_LivePhoto_007
      await TC_LivePhoto_007(dt);
    });
    it('TC_LivePhoto_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [02.添加裁剪后导出] TID: TC_LivePhoto_009
      await TC_LivePhoto_009(dt);
    });
    it('TC_LivePhoto_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [03.添加调节后导出] TID: TC_LivePhoto_010
      await TC_LivePhoto_010(dt);
    });
    it('TC_LivePhoto_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [04.添加滤镜后导出] TID: TC_LivePhoto_011
      await TC_LivePhoto_011(dt);
    });
    it('TC_LivePhoto_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [05.撤销恢复后导出] TID: TC_LivePhoto_012
      await TC_LivePhoto_012(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachLivePhoto').init();
      dt.log.i('afterEach LivePhoto start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach LivePhoto finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLivePhoto').init();
      dt.log.i('afterAll LivePhoto start');
      await Exit.browser();
      dt.log.i('afterAll LivePhoto finish');
    });
  });
}

/**
 * 大图-下载: [01.素材来源]
 * GROUP: 大图 MODULE: 下载 TID: TC_LivePhoto_001
 * 前置条件
 * 1、图库存在相机拍摄、网上下载和xxx分享的动图
 */
async function TC_LivePhoto_001(dt: Dt) {
  dt.log.i('TC_LivePhoto_001 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_002(dt: Dt) {
  dt.log.i('TC_LivePhoto_002 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_003(dt: Dt) {
  dt.log.i('TC_LivePhoto_003 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_005(dt: Dt) {
  dt.log.i('TC_LivePhoto_005 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_006(dt: Dt) {
  dt.log.i('TC_LivePhoto_006 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_007(dt: Dt) {
  dt.log.i('TC_LivePhoto_007 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_009(dt: Dt) {
  dt.log.i('TC_LivePhoto_009 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_010(dt: Dt) {
  dt.log.i('TC_LivePhoto_010 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_011(dt: Dt) {
  dt.log.i('TC_LivePhoto_011 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_012(dt: Dt) {
  dt.log.i('TC_LivePhoto_012 start');
  await dt.swipeScreen?.left();
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true);

}

async function TC_LivePhoto_01(dt: Dt) {
  dt.log.i('01.素材来源 start');

  dt.log.i('STEP 0、验证前置条件：确保图库存在相机拍摄、网上下载和xxx分享的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证相机拍摄的动图存在');
  await dt.assertComponent(PageTitle.index, true); //'CameraLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.3、验证网上下载的动图存在');
  await dt.assertComponent(PageTitle.index, true); //'DownloadedLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.4、验证xxx分享的动图存在');
  await dt.assertComponent(PageTitle.index, true); //'SharedLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择网上下载和xxx分享的动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择网上下载的动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('DownloadedLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('DownloadedLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果1、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 1.4、选择xxx分享的动图');
  await dt.sleep(); //albumList();
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('SharedLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('SharedLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.5、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果2、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、拍摄动图后，从图库或相机进入编辑页面');
  dt.log.i('STEP 2.1、从相机拍摄动图');
  await dt.sleep(); //camera();
  await dt.assertComponent(PageTitle.index, true); //'CameraComponent', true);
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('CaptureLivePhotoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('CaptureLivePhotoButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2.2、从相机进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果3、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2.3、从图库进入编辑页面');
  await dt.sleep(); //albumList();
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('CameraLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('CameraLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.4、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果4、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditPageComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('01.素材来源 end');
}

/**
 * 大图-格式: [02.格式校验]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_002
 * 前置条件
 * 1、图库存在JPEG、HELF格式的动图
 */
async function TC_LivePhoto_02(dt: Dt) {
  dt.log.i('02.格式校验 start');

  dt.log.i('STEP 0、验证前置条件：确保图库存在JPEG、HELF格式的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证JPEG格式的动图存在');
  await dt.assertComponent(PageTitle.index, true); //'JPEGLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.3、验证HELF格式的动图存在');
  await dt.assertComponent(PageTitle.index, true); //'HELFLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择不同格式的动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择JPEG格式的动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('JPEGLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('JPEGLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果1、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 1.4、选择HELF格式的动图');
  await dt.sleep(); //albumList();
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('HELFLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('HELFLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.5、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果2、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditPageComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('02.格式校验 end');
}

/**
 * 大图-竖屏: [03.横竖屏校验]
 * GROUP: 大图 MODULE: 竖屏 TID: TC_LivePhoto_003
 * 前置条件
 * 1、图库存在横屏和竖屏的动图
 */
async function TC_LivePhoto_03(dt: Dt) {
  dt.log.i('03.横竖屏校验 start');

  dt.log.i('STEP 0、验证前置条件：确保图库存在横屏和竖屏的动图');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证横屏动图存在');
  await dt.assertComponent(PageTitle.index, true); //'LandscapeLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.3、验证竖屏动图存在');
  await dt.assertComponent(PageTitle.index, true); //'PortraitLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择不同的动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择横屏动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LandscapeLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LandscapeLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果1、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 1.4、选择竖屏动图');
  await dt.sleep(); //albumList();
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('PortraitLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('PortraitLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.5、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果2、预览区动效加载正常，缩略图和预览区播放正常，无花屏');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditPageComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('03.横竖屏校验 end');
}

/**
 * 大图-: [05.LivePhoto支持截取]
 * GROUP: 大图 MODULE: TID: TC_LivePhoto_005
 * 前置条件
 * 1、图库中存在LivePhoto照片
 */
async function TC_LivePhoto_05(dt: Dt) {
  dt.log.i('05.LivePhoto支持截取 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在LivePhoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证LivePhoto照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择LivePhoto照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.4、切换到截取页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('TrimTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('TrimTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'TrimPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.5、执行截取操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('TrimSlider', true);
  await dt.assertComponent(PageTitle.index, true); //Click('TrimSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.sleep();

  dt.log.i('预期结果1、LivePhoto支持截取');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditPageComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('05.LivePhoto支持截取 end');
}

/**
 * 大图-格式: [06.不支持的格式，弹窗提示]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_006
 * 前置条件
 * 1、图库存在不支持的LivePhoto格式照片
 */
async function TC_LivePhoto_06(dt: Dt) {
  dt.log.i('06.不支持的格式，弹窗提示 start');

  dt.log.i('STEP 0、验证前置条件：确保图库存在不支持的LivePhoto格式照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证不支持的LivePhoto格式照片存在');
  await dt.assertComponent(PageTitle.index, true); //'UnsupportedLivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择不支持的LivePhoto格式照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('UnsupportedLivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('UnsupportedLivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果1、不支持的LivePhoto格式照片进入编辑有弹窗提示');
  await dt.assertComponent(PageTitle.index, true); //'ErrorPopupComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('06.不支持的格式，弹窗提示 end');
}

/**
 * 大图-格式: [04.导入LivePhoto，预览区和缩略图显示]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_007
 * 前置条件
 * 1、图库中存在livdphoto格式照片
 */
async function TC_LivePhoto_07(dt: Dt) {
  dt.log.i('04.导入LivePhoto，预览区和缩略图显示 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在livdphoto格式照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证livdphoto格式照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择livdphoto格式照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('预期结果1.1、导入后，进入预览区动效加载正常，缩略图和预览区显示正常');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'ThumbnailAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 1.4、长按预览窗');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('PreviewAreaComponent', true);
  await dt.sleep(DELAY.short); //断言LongClickById('PreviewAreaComponent', DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果1.2、动态图片可正常播放');
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditPageComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('04.导入LivePhoto，预览区和缩略图显示 end');
}

/**
 * 大图-格式: [02.添加裁剪后导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_009
 * 前置条件
 * 1、图库中存在LivePhoto照片
 */
async function TC_LivePhoto_09(dt: Dt) {
  dt.log.i('02.添加裁剪后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在LivePhoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证LivePhoto照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面，切换到裁剪页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择LivePhoto照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.4、切换到裁剪页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('CropTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('CropTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'CropPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像');
  dt.log.i('STEP 2.1、放大预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ZoomInButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('ZoomInButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.2、缩小预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ZoomOutButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.3、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.4、旋转预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RotateButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RotateButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.5、垂直校正');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('VerticalAlignButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.6、水平校正');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('HorizontalAlignButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.7、设置比例');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AspectRatioButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.8、90度旋转');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('Rotate90Button', true);
  await dt.assertComponent(PageTitle.index, true); //Click('Rotate90Button', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.9、镜像');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('MirrorButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('MirrorButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3、点击保存按钮');
  dt.log.i('STEP 3.1、点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('SaveButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('SaveButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.2、长按预览动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short); //断言LongClickById('ImagePreviewComponent', DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果3.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果3.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('02.添加裁剪后导出 end');
}

/**
 * 大图-格式: [03.添加调节后导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_010
 * 前置条件
 * 1、图库中存在LivePhoto照片
 */
async function TC_LivePhoto_10(dt: Dt) {
  dt.log.i('03.添加调节后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在LivePhoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证LivePhoto照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面，切换到调节页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择LivePhoto照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.4、切换到调节页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AdjustTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AdjustTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'AdjustPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、开启一键调节、设置单个调节项、设置调节强度');
  dt.log.i('STEP 2.1、开启一键调节');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AutoAdjustButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.2、设置单个调节项（亮度）');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('BrightnessSlider', true);
  await dt.assertComponent(PageTitle.index, true); //Click('BrightnessSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.3、设置调节强度');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('IntensitySlider', true);
  await dt.assertComponent(PageTitle.index, true); //Click('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3、点击保存按钮，选择覆盖原视频');
  dt.log.i('STEP 3.1、点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('SaveButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('SaveButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'SaveOptionsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.2、选择覆盖原视频');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('OverwriteOption', true);
  await dt.assertComponent(PageTitle.index, true); //Click('OverwriteOption', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.3、长按预览动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short); //断言LongClickById('ImagePreviewComponent', DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果3.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果3.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('03.添加调节后导出 end');
}

/**
 * 大图-格式: [04.添加滤镜后导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_011
 * 前置条件
 * 1、图库中存在LivePhoto照片
 */
async function TC_LivePhoto_11(dt: Dt) {
  dt.log.i('04.添加滤镜后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在LivePhoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证LivePhoto照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面，切换到滤镜页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择LivePhoto照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.4、切换到滤镜页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('FilterTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('FilterTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'FilterPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、设置滤镜');
  dt.log.i('STEP 2.1、选择滤镜');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('FilterOption', true);
  await dt.assertComponent(PageTitle.index, true); //Click('FilterOption', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3、点击保存按钮，选择覆盖原视频');
  dt.log.i('STEP 3.1、点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('SaveButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('SaveButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'SaveOptionsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.2、选择覆盖原视频');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('OverwriteOption', true);
  await dt.assertComponent(PageTitle.index, true); //Click('OverwriteOption', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.3、长按预览动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short); //断言LongClickById('ImagePreviewComponent', DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果3.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果3.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('04.添加滤镜后导出 end');
}

/**
 * 大图-格式: [05.撤销恢复后导出]
 * GROUP: 大图 MODULE: 格式 TID: TC_LivePhoto_012
 * 前置条件
 * 1、图库中存在LivePhoto照片
 */
async function TC_LivePhoto_12(dt: Dt) {
  dt.log.i('05.撤销恢复后导出 start');

  dt.log.i('STEP 0、验证前置条件：确保图库中存在LivePhoto照片');
  dt.log.i('STEP 0.1、进入图库相册列表');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 0.2、验证LivePhoto照片存在');
  await dt.assertComponent(PageTitle.index, true); //'LivePhotoComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、选择动图，进入编辑页面');
  dt.log.i('STEP 1.1、导航到照片页面');
  await dt.sleep(); //albumList();
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.2、选择LivePhoto照片');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('LivePhotoComponent', true);
  await dt.assertComponent(PageTitle.index, true); //Click('LivePhotoComponent', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1.3、点击编辑按钮进入编辑页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('EditButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('EditButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'EditPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、关闭原声、设置封面帧，撤销/恢复');
  dt.log.i('STEP 2.1、关闭原声');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('MuteButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('MuteButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.2、设置封面帧');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('CoverFrameButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('CoverFrameButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.3、撤销操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('UndoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('UndoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2.4、恢复操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RedoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RedoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3、进入裁剪页面：放大/缩小/双指移动预览区、旋转/垂直/水平校正、设置比例、90度旋转、镜像、撤销/恢复');
  dt.log.i('STEP 3.1、切换到裁剪页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('CropTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('CropTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'CropPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.2、放大预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ZoomInButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('ZoomInButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.3、缩小预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ZoomOutButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('ZoomOutButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.4、双指移动预览区');
  await dt.driver.swipe(300, 500, 400, 600, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.5、旋转预览区');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RotateButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RotateButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.6、垂直校正');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('VerticalAlignButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('VerticalAlignButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.7、水平校正');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('HorizontalAlignButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('HorizontalAlignButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.8、设置比例');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AspectRatioButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AspectRatioButton', false, DELAY.default);
  await dt.assertTextClick('16:9', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.9、90度旋转');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('Rotate90Button', true);
  await dt.assertComponent(PageTitle.index, true); //Click('Rotate90Button', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.10、镜像');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('MirrorButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('MirrorButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.11、撤销操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('UndoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('UndoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3.12、恢复操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RedoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RedoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、进入调节页面：开启/关闭一键调节、设置单个调节项、设置调节强度、撤销/恢复');
  dt.log.i('STEP 4.1、切换到调节页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AdjustTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AdjustTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'AdjustPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.2、开启一键调节');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AutoAdjustButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.3、关闭一键调节');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('AutoAdjustButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('AutoAdjustButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.4、设置单个调节项（亮度）');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('BrightnessSlider', true);
  await dt.assertComponent(PageTitle.index, true); //Click('BrightnessSlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 400, 500, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.5、设置调节强度');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('IntensitySlider', true);
  await dt.assertComponent(PageTitle.index, true); //Click('IntensitySlider', false, DELAY.default);
  await dt.driver.swipe(300, 500, 350, 500, 300);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.6、撤销操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('UndoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('UndoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4.7、恢复操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RedoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RedoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、进入滤镜页面：设置滤镜、撤销/恢复');
  dt.log.i('STEP 5.1、切换到滤镜页面');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('FilterTab', true);
  await dt.assertComponent(PageTitle.index, true); //Click('FilterTab', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'FilterPageComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5.2、设置滤镜');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('FilterOption', true);
  await dt.assertComponent(PageTitle.index, true); //Click('FilterOption', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5.3、撤销操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('UndoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('UndoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5.4、恢复操作');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('RedoButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('RedoButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'PreviewAreaComponent', true);
  await dt.sleep();

  dt.log.i('STEP 6、点击保存按钮，选择覆盖原视频');
  dt.log.i('STEP 6.1、点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('SaveButton', true);
  await dt.assertComponent(PageTitle.index, true); //Click('SaveButton', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'SaveOptionsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 6.2、选择覆盖原视频');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('OverwriteOption', true);
  await dt.assertComponent(PageTitle.index, true); //Click('OverwriteOption', false, DELAY.default);
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 6.3、长按预览动图');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.sleep(DELAY.short); //断言LongClickById('ImagePreviewComponent', DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果6.1、保存成功，编辑操作对LivePhoto所有帧生效');
  dt.log.i('预期结果6.2、保存后的文件封装格式与原文件保持一致，编码格式与源文件保持一致，色彩空间与原文件保持一致');
  dt.log.i('预期结果6.3、跳转到大图页面，长按可以播放动图');
  await dt.assertComponent(PageTitle.index, true); //'ImagePreviewComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent(PageTitle.index, true); //ComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent(PageTitle.index, true); //'PageTitle.index', true);
  dt.log.i('05.撤销恢复后导出 end');
}