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
import { Component, DisplayRotation, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';

export default function photoBrowserTest(): void {
  describe('PhotoBrowserTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPhotoBrowserTest').init();
      dt.log.i('beforeAll PhotoBrowserTest start');
      dt.log.i('beforeAll PhotoBrowserTest finish');
    });
    it('beforePhotoBrowserTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('DeleteButtonTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DeleteButtonTest(dt);
    });
    it('toolBarButtonDeleteTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await toolBarButtonDeleteTest(dt);
    });
    it('MoreMenuTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await MoreMenuTest(dt);
    });
    it('addToAlbumTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await addToAlbumTest(dt);
    });
    it('browserDetailTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await browserDetailTest(dt);
    });
    it('browserEditDetailTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await browserEditDetailTest(dt);
    });
    it('editButtonTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await editButtonTest(dt);
    });
    it('MovingPhotoButtonTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await MovingPhotoButtonTest(dt);
    });
    it('DeleteButtonRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await DeleteButtonTest(dt);
    }, {
      rotate: true,
    });
    it('toolBarButtonDeleteRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await toolBarButtonDeleteTest(dt);
    }, {
      rotate: true,
    });
    it('MoreMenuRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await MoreMenuTest(dt);
    }, {
      rotate: true,
    });
    it('addToAlbumRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await addToAlbumTest(dt);
    }, {
      rotate: true,
    });
    it('browserDetailRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await browserDetailTest(dt);
    }, {
      rotate: true,
    });
    it('editButtonRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await editButtonTest(dt);
    }, {
      rotate: true,
    });
    it('MovingPhotoButtonRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await MovingPhotoButtonTest(dt);
    }, {
      rotate: true,
    });
    it('browserEditDetailRotateTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await browserEditDetailRotateTest(dt);
    }, {
      rotate: true,
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPhotoBrowserTest').init();
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach PhotoBrowserTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach PhotoBrowserTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotoBrowserTest').init();
      await Exit.browser();
      dt.log.i('afterAll PhotoBrowserTest finish');
    });
  });
}

/**
 * 1、点击编辑
 * 2、点击编辑页面基础按钮
 * 3、点击编辑
 */
export async function editBrowserTest(dt: Dt) {
  dt.log.i(`Task_002_Edit_Test01 start ${dt.button.edit()}`);
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);

  for (
    let component: Component | undefined = await dt.driver.findComponent(ON.id('VideoPlayButton'));
    component;
    component = await dt.driver.findComponent(ON.id('VideoPlayButton'))
  ) {
    dt.log.i('swipeToVideo left');
    await dt.swipeScreen?.left();
  }

  await dt.assertClick(dt.button.edit());
  dt.log.i('toolBarButtonEdit clicked');

  // 编辑页基础按钮点击
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  await dt.assertComponent('videoEditor_CropTool_rotateBtn');

  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertComponent('videoEditor_CropTool_mirrorBtn');
  // 点击保存
  await dt.assertComponent('videoEditor_topToolBar_save');
  dt.log.i('photoEditSaveButton clicked');

  await dt.assertComponentByText('覆盖原图');
  let cover = await dt.driver.findComponent(ON.text('覆盖原图'));
  await cover.click();
  dt.log.i('cover clicked');
  await dt.sleep(DELAY.double);
  await restoreBrowserTest(dt);
}

/**
 *
 * 1、点击保存
 * 2、点击编辑
 * 3、点击复原
 * 3、点击确定
 */
export async function restoreBrowserTest(dt: Dt) {
  dt.log.i(`toolBarButtonEdit clicked ${dt.button.edit()}`);
  // 编辑
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  await dt.assertClick('ToolBarButtonEdit');
  dt.log.i('toolBarButtonEdit clicked');

  await dt.assertComponent('videoEditor_topToolBar_topTool_recover');
  let photoEditRecoverButton = await dt.driver.findComponent(ON.id('videoEditor_topToolBar_topTool_recover'));
  await photoEditRecoverButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  dt.log.i('photoEditRecoverButton clicked');

  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  let deleteDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  await deleteDialogConfirmButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);

  dt.log.i('Task_002_Edit_Test02 end');
}

/**
 * 1、点击删除
 * 2、点击取消
 */
export async function DeleteButtonTest(dt: Dt) {
  for (let i = 0; i < 4; i++) {
    await dt.swipeScreen?.left();
  }
  dt.log.i('Task_002_Delete_Test01 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(dt.button.delete());
  dt.log.i('toolBarButtonDelete clicked');
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  let deleteDialogCancelButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  await deleteDialogCancelButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('deleteDialogCancelButton clicked');
  dt.log.i('Task_002_Delete_Test01 end');
}

/**
 * 1、点击删除 ToolBarButtonDelete
 * 2、确认删除 DeleteDialogConfirmButton
 * 返回到下一张大图
 */
export async function toolBarButtonDeleteTest(dt: Dt) {
  dt.log.i('Task_002_Delete_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick(dt.button.delete());
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('toolBarButtonDelete1 clicked');
  await dt.driver.assertComponentExist(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  let deleteDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  await deleteDialogConfirmButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  dt.log.i('deleteConfirmBtn clicked');
  dt.log.i('Task_002_Delete_Test02 end');
}

/**
 * 1、点击更多
 * 2、点击返回
 */
export async function MoreMenuTest(dt: Dt) {
  dt.log.i('Task_002_More_Test01 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('More_Image_More clicked');
  await dt.driver.click(100, 400);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  dt.log.i('Task_002_More_Test01 end');
}

/**
 * 1、点击更多
 * 2、点击添加到相册
 * 3、点击取消
 * 4、点击更多
 * 5、点击添加到相册
 * 6、新建相册
 * 4、确认
 * 返回到大图页面
 */
export async function addToAlbumTest(dt: Dt) {
  dt.log.i('Task_002_More_Test03 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('toolBarButtonMore clicked');
  await dt.assertClick('ActionBarButton_Text_Move');
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  dt.log.i('toolBarPopupBuilderTextOfAdd clicked');
  // 点击返回按钮
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('toolBarButtonMore1 clicked');
  await dt.assertClick('ActionBarButton_Text_Move');
  dt.log.i('ActionBarButton_Text_Add clicked');
  //actionBarButtonNew替换控件无法给id赋值，做替换
  await dt.assertClick('More_Image_NewAlbum');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('actionBarButtonNew clicked');
  let newAlbumDialogCancelBtn = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  dt.log.i(`newAlbumDialogCancelBtn clicked ${newAlbumDialogCancelBtn}`);
  if (!newAlbumDialogCancelBtn) {
    await handleRotation(dt);
    newAlbumDialogCancelBtn = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_FIRST));
  }
  await newAlbumDialogCancelBtn.click();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i(`newAlbumDialogCancelBtn clicked ${newAlbumDialogCancelBtn}`);
  //actionBarButtonNew替换控件无法给id赋值，做替换
  await dt.assertClick('More_Image_NewAlbum');
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  dt.log.i('actionBarButtonNew1 clicked');

  await dt.clickIfExist('Paf.Permission.button_confirm');
  let newAlbumDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  if (!newAlbumDialogConfirmButton) {
    await handleRotation(dt);
    newAlbumDialogConfirmButton = await dt.driver.findComponent(ON.id(TestConstants.DIALOG_BUTTON_SECOND));
  }
  await newAlbumDialogConfirmButton.click();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('newAlbumDialogConfirmButton clicked');
  dt.log.i('Task_002_More_Test03 end');
}

export async function handleRotation(dt: Dt) {
  await dt.clickIfExist('KeyHideKbd');
  await dt.rotate();
}

/**
 * 1、点击图片详情
 * 2、点击返回(点击图片位置返回：规避os中pressBack的bug)
 */
export async function browserDetailTest(dt: Dt) {
  dt.log.i('Task_002_ImageDetail_Test01 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (dt.rotation === DisplayRotation.ROTATION_0) {
    await dt.assertClick('More_Image_More');
    dt.log.i('buttonMore clicked');
    await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.assertClick('ActionBarButton_Text_Info');
  } else {
    await dt.getScreen().top();
  }

  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.id('content'))) {
    await dt.driver.pressBack();
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  dt.log.i('Task_002_ImageDetail_Test01 end');
}

/**
 * 1、点击图片详情
 * 2、点击编辑
 * 3、点击返回
 * 4、点击图片隐藏详情
 * 5、上滑显示图片详情
 * 6、下滑隐藏图片详情
 */
export async function browserEditDetailTest(dt: Dt) {
  dt.log.i('Task_002_ImageDetail_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  if (dt.rotation === DisplayRotation.ROTATION_0) {
    await dt.assertClick('More_Image_More');
    dt.log.i('buttonMore clicked');
    await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.assertClick('ActionBarButton_Text_Info');
  } else {
    await dt.getScreen().top();
  }

  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('PhotoDetailTitle');
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  dt.log.i('photoDetailEdit clicked');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('actionBarButtonBack clicked');
  await dt.driver.click(700, 300);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image clicked hide detail info');
  await dt.driver.swipe(660, 1800, 660, 400, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe up');
  await dt.driver.swipe(660, 400, 660, 1800, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe down');
}

export async function browserEditDetailRotateTest(dt: Dt) {
  dt.log.i('Task_002_ImageDetail_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('buttonMore clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  let menu=await dt.driver.findComponent(ON.id('ActionBarButton_Menu'))
  await menu.scrollToBottom()
  await dt.assertClick('ActionBarButton_Text_Info');
  dt.log.i('buttonInfo clicked');
  await dt.assertComponent('PhotoDetailTitle');
  await dt.assertClick('PhotoDetailTitle');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('photoDetailEdit clicked');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  await dt.driver.click(700, 300);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image clicked hide detail info');
  await dt.swipeScreen?.top();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe up');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image exit properties');
}

/**
 * 1、点击编辑
 * 2、返回
 * @param dt
 */
export async function editButtonTest(dt: Dt) {
  dt.log.i(`Task_002_Edit_Test0 start editButtonTest`);
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  dt.log.i(`Task_002_Edit_Test02 start click More_Image_Edit`);
  dt.log.i('editor button clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertComponent(dt.button.edit());
  const editSuccess = await dt.assertClick(dt.button.edit());
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  if (editSuccess) {
    await dt.driver.pressBack();
    await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    dt.log.i('pressBack clicked');
  } else {
    dt.log.e('edit fail');
  }
  dt.log.i('editButtonTest end');
}

/**
 * 1、点击动态照片
 * 2、点击动态照片列表
 * @param dt
 */
export async function MovingPhotoButtonTest(dt: Dt) {
  dt.log.i(`start click MovingPhotoButtonTest`);
  await dt.driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  dt.log.i(`loop find movingphoto MovingPhotoButtonTest`);

  await dt.loopUntil(`${dt.barButton()}MotionPicture`, async () => {
    await dt.swipeScreen?.left(600);
  }, 6);

  dt.log.i('MovingPhoto button clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertComponent(`${dt.barButton()}MotionPicture`);
  await dt.assertClick(`${dt.barButton()}MotionPicture`);
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  dt.log.i('MovingPhotoMenuItem_MotionPicture clicked');
  await dt.assertComponent('MovingPhotoMenuItem_MotionPicture');
  await dt.assertClick('MovingPhotoMenuItem_MotionPicture');
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);

  await dt.assertComponent(`${dt.barButton()}MotionPicture`);
  await dt.assertClick(`${dt.barButton()}MotionPicture`);

}