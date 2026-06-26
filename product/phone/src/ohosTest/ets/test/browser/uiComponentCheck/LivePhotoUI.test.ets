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

import { beforeAll, afterAll, describe, Level, expect } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { ON } from '@ohos.UiTest';
import { UiComponentId } from '../../utils/UiComponentId';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 * 本测试套用来check动态照片大图页每个元素是否正常
 */
export default function LivePhotoUITest(): void {
  describe('LivePhotoUITest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllLivePhotoUITest').init();
      dt.log.i('beforeAll LivePhotoUITest start');
      await AppStart.photos();
      dt.log.i('beforeAll LivePhotoUITest finish');
    });
    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLivePhotoUITest').init();
      dt.log.i('afterAll LivePhotoUITest start');
      await Exit.browser();
      dt.log.i('afterAll LivePhotoUITest finish');
    });
    it('beforeLivePhotoUITest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('prepareLivePhoto', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 准备一张动态照片
      await prepareLivePhoto(dt);
    });
    it('Live_Photo_Image_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-返回
      await Live_Photo_Image_001(dt);
    });
    it('Live_Photo_Image_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-日期
      await Live_Photo_Image_002(dt);
    });
    it('Live_Photo_Image_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-时间
      await Live_Photo_Image_003(dt);
    });
    it('Live_Photo_Image_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-更多,更多对应的四个点
      await Live_Photo_Image_004(dt);
    });
    it('Live_Photo_Image_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-缩略图预览
      await Live_Photo_Image_005(dt);
    });
    it('Live_Photo_Image_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-分享
      await Live_Photo_Image_006(dt);
    });
    it('Live_Photo_Image_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-收藏
      await Live_Photo_Image_007(dt);
    });
    it('Live_Photo_Image_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-编辑
      await Live_Photo_Image_008(dt);
    });
    it('Live_Photo_Image_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-删除
      await Live_Photo_Image_009(dt);
    });
    it('Live_Photo_Image_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-动态照片组件
      await Live_Photo_Image_010(dt);
    });
    it('Live_Photo_Image_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-动态照片按钮以及popup选项
      await Live_Photo_Image_011(dt);
    });
    it('Live_Photo_Image_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 动态照片大图-更多popup选项
      await Live_Photo_Image_012(dt);
    });
  });
}


/*
 * 准备动态照片
 * */
async function prepareLivePhoto(dt: Dt) {
  dt.log.i('prepareLivePhoto start');
  await dt.cameraShoot(); //进入相机，进入拍照模式
  await dt.sleep(DELAY.short);
  let LiveButton = await dt.driver.findComponent(ON.id("TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE")); //打开动图按钮
  if (LiveButton) {
    await LiveButton.click();
    await dt.sleep();
  }
  await dt.clickIfExist("COMPONENT_ID_SHUTTER_PHOTO_1"); //点击拍照按钮
  await dt.sleep(DELAY.short);
  await dt.pressBack();
  //返回图库
  await dt.sleep();
  await dt.swipeScreen?.right();
  await dt.loopUntil('ToolBarButtonMotionPicture', async () => {
    await dt.swipeScreen?.left();
    await dt.sleep(DELAY.long);
  }, 50);
  await dt.sleep(DELAY.long);
  dt.log.i('prepareLivePhoto end');
}

/**
 * 动态照片大图-返回
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_001(dt: Dt) {
  dt.log.i('Live_Photo_Image_001 动态照片大图-返回 start');

  dt.log.i('预期结果1、存在More_Image_Back这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_BACK));
  expect(comp).not().assertNull();

  dt.log.i('预期结果2、存在AccessibilityComponent_BrowserBack这个id');
  const compBtn = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_BACK_BUTTON));
  expect(compBtn).not().assertNull();
  const isClickable = await compBtn.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await compBtn.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Live_Photo_Image_001 end');
}

/**
 * 动态照片大图-日期
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_002(dt: Dt) {
  dt.log.i('Live_Photo_Image_002 动态照片大图-日期 start');

  dt.log.i('预期结果1、存在PhotoBrowserDateTitle这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_DATE_TITLE));
  expect(comp).not().assertNull();

  dt.log.i('Live_Photo_Image_002 end');
}

/**
 * 动态照片大图-时间
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_003(dt: Dt) {
  dt.log.i('Live_Photo_Image_003 动态照片大图-时间 start');

  dt.log.i('预期结果1、存在PhotoBrowserTimeLocationTitle这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TIME_LOCATION));
  expect(comp).not().assertNull();

  dt.log.i('Live_Photo_Image_003 end');
}

/**
 * 动态照片大图-更多,更多对应的四个点
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_004(dt: Dt) {
  dt.log.i('Live_Photo_Image_004 动态照片大图-更多 start');

  dt.log.i('预期结果1、存在More_Image_More对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_MORE));
  expect(comp).not().assertNull();

  dt.log.i('Live_Photo_Image_004 end');
}

/**
 * 动态照片大图-缩略图预览
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_005(dt: Dt) {
  dt.log.i('Live_Photo_Image_005 动态照片大图-缩略图预览 start');

  dt.log.i('预期结果1、存在PhotoBrowserPreviewBar对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_PREVIEW_BAR));
  expect(comp).not().assertNull();

  dt.log.i('Live_Photo_Image_005 end');
}

/**
 * 动态照片大图-分享
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_006(dt: Dt) {
  dt.log.i('Live_Photo_Image_006 动态照片大图-分享 start');

  dt.log.i('预期结果1、存在ToolBarButtonShare对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_SHARE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Live_Photo_Image_006 end');
}

/**
 * 动态照片大图-收藏
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_007(dt: Dt) {
  dt.log.i('Live_Photo_Image_007 动态照片大图-收藏 start');

  dt.log.i('预期结果1、存在ToolBarButtonFavor的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_FAVORITE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Live_Photo_Image_007 end');
}

/**
 * 动态照片大图-编辑
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_008(dt: Dt) {
  dt.log.i('Live_Photo_Image_008 动态照片大图-编辑 start');

  dt.log.i('预期结果1、存在ToolBarButtonEdit对应的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_EDIT));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Live_Photo_Image_008 end');
}

/**
 * 动态照片大图-删除
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_009(dt: Dt) {
  dt.log.i('Live_Photo_Image_009 动态照片大图-删除 start');

  dt.log.i('预期结果1、存在ToolBarButtonDelete对应的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_DELETE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Live_Photo_Image_009 end');
}

/**
 * 动态照片大图-动态照片组件
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_010(dt: Dt) {
  dt.log.i('Live_Photo_Image_010 动态照片大图-动态照片组件 start');

  dt.log.i('预期结果1、存在movingPhoto这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_MOVING_PHOTO));
  expect(comp).not().assertNull();
  dt.log.i('Live_Photo_Image_010 end');
}

/**
 * 动态照片大图-动态照片按钮以及popup选项
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_011(dt: Dt) {
  dt.log.i('Live_Photo_Image_011 动态照片大图-动态照片按钮 start');

  dt.log.i('预期结果1、存在动态照片模式切换按钮');

  const comp = await dt.driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  expect(comp).not().assertNull();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();
  dt.log.i('点击动态照片模式切换按钮');
  await dt.assertClick('ToolBarButtonMotionPicture');
  await dt.sleep(DELAY.double);
  const livePhotoOptions: string[] = ['动态照片', '关闭动态']
  dt.log.i(`预期结果2、动态照片${livePhotoOptions.length}种效果选项`);
  for (const option of livePhotoOptions) {
    dt.log.i(`Live_Photo_Image_011 assert text: ${option}`);
    await dt.assertComponentByText(option);
  }
  await dt.assertClick('ToolBarButtonMotionPicture');
  dt.log.i('Live_Photo_Image_011 end');
}

/**
 * 动态照片大图-更多popup选项
 * TAG:
 * 前置条件
 *
 */
async function Live_Photo_Image_012(dt: Dt) {
  dt.log.i('Live_Photo_Image_012 动态照片大图-更多popup选项 start');
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE);
  await dt.sleep(DELAY.double);
  dt.log.i('预期结果1、更多选项中有9中选项');
  const moreBtnOptions: string[] = ['设置为壁纸', '扫描为文档', '移动到', '隐藏', '导出视频', '打印或生成 PDF', '重命名',
    '播放幻灯片', '详细信息'];
  for (const option of moreBtnOptions) {
    dt.log.i(`Live_Photo_Image_012 assert text: ${option}`);
    await dt.assertComponentByText(option);
  }
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_MORE);
  dt.log.i('Live_Photo_Image_012 end');
}
