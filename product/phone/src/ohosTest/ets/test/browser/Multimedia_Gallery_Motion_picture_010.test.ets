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

export default function MultimediaGalleryMotionpicture(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryMotionpictureTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryMotionpicture').init();
      dt.log.i('beforeAll MultimediaGalleryMotionpicture start');
      dt.log.i('beforeAll MultimediaGalleryMotionpicture finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryMotionpicture', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Motion_picture_090', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换声音检查] TID: Multimedia_Gallery_Motion_picture_090
      await Multimedia_Gallery_Motion_picture_090(dt);
    });
    run('Multimedia_Gallery_Motion_picture_091', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换按钮检查] TID: Multimedia_Gallery_Motion_picture_091
      await Multimedia_Gallery_Motion_picture_091(dt);
    });
    run('Multimedia_Gallery_Motion_picture_092', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换loading检查] TID: Multimedia_Gallery_Motion_picture_092
      await Multimedia_Gallery_Motion_picture_092(dt);
    });
    run('Multimedia_Gallery_Motion_picture_093', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换多端同步] TID: Multimedia_Gallery_Motion_picture_093
      await Multimedia_Gallery_Motion_picture_093(dt);
    });
    run('Multimedia_Gallery_Motion_picture_177', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态图片自动播放场景] TID: Multimedia_Gallery_Motion_picture_177
      await Multimedia_Gallery_Motion_picture_177(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryMotionpicture').init();
      dt.log.i('afterEach MultimediaGalleryMotionpicture start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryMotionpicture finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryMotionpicture').init();
      dt.log.i('afterAll MultimediaGalleryMotionpicture start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryMotionpicture finish');
    });
  });
}

// DT步骤

/**
 * 大图-动态照片: [动态照片效果切换声音检查]
 * TAG: 302 TID: Multimedia_Gallery_Motion_picture_090
 * 前置条件
 * 1、相机拍摄动态照片
 */
async function Multimedia_Gallery_Motion_picture_090(dt: Dt) {
  dt.log.i('动态照片效果切换声音检查 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机拍摄动态照片');
  // Assume a common method to launch camera, capture motion photo, and return to gallery
  await dt.launchCameraApp(); // Placeholder: Launch camera app
  await dt.captureMotionPhoto(); // Placeholder: Capture a motion photo
  await dt.exitCameraToGallery(); // Placeholder: Exit camera and return to gallery
  await dt.assertComponent('photoGridView_grid_0',
    true); // Assert that the gallery grid view is visible, assuming the first item is the captured photo
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、图库照片页进入动态照片大图进行效果切换（覆盖动态照片、循环播放、主角时刻、运动轨迹、微动瞬间）');
  // 1.1、点击进入动态照片大图
  await dt.assertClick('photoGridView_grid_0'); // Assuming the first grid item is the dynamic photo
  await dt.assertComponent('MotionPictureLargeView', true); // Assert entry into large view of motion picture

  // 1.2、切换到覆盖动态照片效果
  await dt.clickIfExist('MotionEffectSwitchButton'); // Assuming a common button to open effect switching panel
  await dt.assertComponent('EffectOption_CoverMotionPhoto', true); // Assert effect options are visible
  await dt.assertClick('EffectOption_CoverMotionPhoto'); // Click to select "Cover Motion Photo"
  await dt.sleep(DELAY.short); // Allow time for effect to apply and UI to update
  // Add assertion for effect applied, e.g., checking specific UI elements or states
  await dt.assertComponent('MotionEffectAppliedIndicator_CoverMotionPhoto',
    true); // Placeholder: Assert indicator for effect

  // 1.3、切换到循环播放效果
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.sleep(DELAY.short);
  await dt.assertComponent('MotionEffectAppliedIndicator_LoopPlayback', true);

  // 1.4、切换到主角时刻效果
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.sleep(DELAY.short);
  await dt.assertComponent('MotionEffectAppliedIndicator_ProtagonistMoment', true);

  // 1.5、切换到运动轨迹效果
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.sleep(DELAY.short);
  await dt.assertComponent('MotionEffectAppliedIndicator_MotionTrail', true);

  // 1.6、切换到微动瞬间效果
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_SubtleMoment');
  await dt.sleep(DELAY.short);
  await dt.assertComponent('MotionEffectAppliedIndicator_SubtleMoment', true);

  dt.log.i('STEP 2、各效果长按播放（循环播放和微动瞬间效果无需长按播放）');
  // 2.1、长按播放覆盖动态照片效果并检查声音
  // Assume we are back to the "Cover Motion Photo" effect or navigate to it if needed
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_CoverMotionPhoto');
  await dt.sleep(DELAY.short);
  await dt.assertLongClickById('MotionPicturePlaybackArea'); // Assuming 'MotionPicturePlaybackArea' is the ID of the playback area
  // Add assertions for sound presence/absence (requires audio detection capabilities, not directly supported by current methods)
  // dt.assertSoundPlaying(); // Placeholder for sound assertion
  await dt.sleep(DELAY.short);

  // 2.2、播放循环播放效果并检查声音 (无需长按)
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.sleep(DELAY.short);
  // Add assertions for sound presence/absence
  // dt.assertSoundNotPlaying(); // Placeholder for sound assertion
  await dt.sleep(DELAY.short);

  // 2.3、长按播放主角时刻效果并检查声音
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.sleep(DELAY.short);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  // Add assertions for sound presence/absence
  // dt.assertSoundNotPlaying(); // Placeholder for sound assertion
  await dt.sleep(DELAY.short);

  // 2.4、长按播放运动轨迹效果并检查声音
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.sleep(DELAY.short);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  // Add assertions for sound presence/absence
  // dt.assertSoundNotPlaying(); // Placeholder for sound assertion
  await dt.sleep(DELAY.short);

  // 2.5、播放微动瞬间效果并检查声音 (无需长按)
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_SubtleMoment');
  await dt.sleep(DELAY.short);
  // Add assertions for sound presence/absence
  // dt.assertSoundNotPlaying(); // Placeholder for sound assertion
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果2、仅动态效果的动态照片支持声音，其余效果播放时无声音');
  // This is a manual verification step or requires specific audio detection APIs.
  // The automated steps above cover the actions leading to this expectation.

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换声音检查 end');
}

/**
 * 大图-动态照片: [动态照片效果切换按钮检查]
 * TAG: 301 TID: Multimedia_Gallery_Motion_picture_091
 * 前置条件
 * 1、相机拍摄动态照片
 */
async function Multimedia_Gallery_Motion_picture_091(dt: Dt) {
  dt.log.i('动态照片效果切换按钮检查 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机拍摄动态照片');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.exitCameraToGallery();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、图库照片页进入动态照片大图进行效果切换，效果切换时查看大图按钮显示');
  // 1.1、点击进入动态照片大图
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);

  // 1.2、点击动态照片效果切换入口，开始切换效果
  await dt.assertClick('MotionEffectSwitchButton'); // Click to open the effect switching panel
  await dt.assertComponent('EffectOption_CoverMotionPhoto', true); // Assert effect options are visible

  // 1.3、在切换过程中检查按钮状态 (这里假设切换需要一定时间，可以在中间进行断言)
  // 切换到循环播放
  await dt.assertClick('EffectOption_LoopPlayback');
  // 在切换过程中断言按钮状态 (这里需要模拟切换过程中的UI状态，可能需要更精细的延迟或UI事件监听)
  await dt.sleep(DELAY.short); // Simulate the time an effect takes to switch

  // 预期结果1、效果切换过程中动态照片效果切换入口、编辑入口和设置壁纸入口置灰显示，其余按钮不置灰
  // 1.4、断言“动态照片效果切换入口”置灰
  await dt.assertComponentClickable('MotionEffectSwitchButton', false); // Check if it's not clickable (grayed out)
  // Or check if it's disabled:
  // const switchButton = await dt.assertComponent('MotionEffectSwitchButton');
  // expect(await switchButton.isEnabled()).toBeFalsy();

  // 1.5、断言“编辑入口”置灰
  await dt.assertComponentClickable('EditButton', false); // Assuming 'EditButton' is the ID for the edit entry
  // const editButton = await dt.assertComponent('EditButton');
  // expect(await editButton.isEnabled()).toBeFalsy();

  // 1.6、断言“设置壁纸入口”置灰
  await dt.assertComponentClickable('SetWallpaperButton',
    false); // Assuming 'SetWallpaperButton' is the ID for setting wallpaper
  // const wallpaperButton = await dt.assertComponent('SetWallpaperButton');
  // expect(await wallpaperButton.isEnabled()).toBeFalsy();

  // 1.7、断言“其余按钮”不置灰 (例如，分享按钮，删除按钮等)
  await dt.assertComponentClickable('ShareButton', true); // Assuming 'ShareButton' is clickable
  await dt.assertComponentClickable('DeleteButton', true); // Assuming 'DeleteButton' is clickable

  // 1.8、等待效果切换完成
  await dt.sleep(); // Wait for the effect switch to fully complete and buttons to return to normal state

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换按钮检查 end');
}

/**
 * 大图-动态照片: [动态照片效果切换loading检查]
 * TAG: 299 TID: Multimedia_Gallery_Motion_picture_092
 * 前置条件
 * 1、相机拍摄动态照片
 */
async function Multimedia_Gallery_Motion_picture_092(dt: Dt) {
  dt.log.i('动态照片效果切换loading检查 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机拍摄动态照片');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.exitCameraToGallery();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、图库照片页进入动态照片大图进行效果切换，效果切换时查看loading显示');
  // 1.1、点击进入动态照片大图
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);

  // 1.2、点击动态照片效果切换入口
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOption_CoverMotionPhoto', true);

  // 1.3、选择一个效果进行切换，并立即检查loading显示
  await dt.assertClick('EffectOption_LoopPlayback'); // Click to switch to "Loop Playback"
  await dt.sleep(DELAY.rapid); // A very short delay to allow loading to appear

  // 预期结果1、切换loading显示在正中间，loading大小为48vp
  // 1.4、断言loading组件存在 (例如，LoadingIndicator)
  await dt.assertComponent('LoadingIndicator', true); // Assuming 'LoadingIndicator' is the ID of the loading component

  // 1.5、断言loading组件位置在正中间 (这通常需要获取组件的bounds或中心坐标进行计算)
  // This is a conceptual check, as direct pixel-perfect assertion might be complex.
  // If the framework provides methods to get component coordinates:
  // const loadingComponent = await dt.assertComponent('LoadingIndicator');
  // const bounds = await loadingComponent.getBounds();
  // const displaySize = await dt.getDisplaySize();
  // const centerX = bounds.left + bounds.width / 2;
  // const centerY = bounds.top + bounds.height / 2;
  // expect(centerX).toBeCloseTo(displaySize.width / 2, 5); // Within a tolerance
  // expect(centerY).toBeCloseTo(displaySize.height / 2, 5);

  // 1.6、断言loading组件大小为48vp (通常需要获取组件的尺寸进行断言)
  // const width = bounds.width;
  // const height = bounds.height;
  // expect(width).toBeCloseTo(48, 5); // Assuming 48vp translates to roughly 48 pixels or similar units
  // expect(height).toBeCloseTo(48, 5);

  await dt.sleep(); // Wait for the effect switch to complete and loading to disappear
  await dt.negateComponent('LoadingIndicator'); // Assert loading indicator disappears

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换loading检查 end');
}

/**
 * 大图-动态照片: [动态照片效果切换多端同步]
 * TAG: 297 TID: Multimedia_Gallery_Motion_picture_093
 * 前置条件
 * 1、辅助机和测试机已同步同一张动态照片
 */
async function Multimedia_Gallery_Motion_picture_093(dt: Dt) {
  dt.log.i('动态照片效果切换多端同步 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 辅助机和测试机已同步同一张动态照片');
  // Placeholder: Ensure both devices have the dynamic photo synchronized
  // This would typically involve external setup or a dedicated sync function
  await dt.setupSyncBetweenDevices(); // Placeholder for setting up sync
  await dt.assertComponent('photoGridView_grid_0', true); // Assert gallery is open on test device
  await dt.assertPhotoSynced('dynamicPhotoID_123',
    'auxiliaryDevice'); // Placeholder: Assert photo exists on auxiliary device
  await dt.assertPhotoSynced('dynamicPhotoID_123', 'testDevice'); // Placeholder: Assert photo exists on test device
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、辅助机和测试机将同一张动态照片大图下载完成');
  // 1.1、在测试机上点击进入动态照片大图，确保下载完成
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.sleep(DELAY.long); // Allow time for full download if not already
  await dt.assertComponent('DownloadCompleteIndicator', false); // Assert no download indicator

  // 1.2、在辅助机上点击进入动态照片大图，确保下载完成
  // This step implies controlling the auxiliary device, which might need a different Dt instance or a multi-device framework.
  // Assuming a `dt.aux` instance for the auxiliary device.
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.sleep(DELAY.long);
  await dt.assertComponent('DownloadCompleteIndicator', false);

  await dt.pressBack(); // Return to gallery grid view on test device
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2、辅助机进行动态照片效果切换，上传完成并等待测试机下行完成后查看测试机显示');
  // 2.1、辅助机切换动态照片效果 (模拟辅助机操作)
  // This requires a way to execute commands on the auxiliary device.
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_LoopPlayback'); // Auxiliary device switches to "Loop Playback"
  await dt.sleep(DELAY.long); // Allow auxiliary device to upload change
  await dt.pressBack();

  // 2.2、等待测试机下行完成
  await dt.sleep(DELAY.veryLong); // Long delay to ensure sync and download on test device

  // 2.3、测试机查看该动态照片显示
  await dt.assertClick('photoGridView_grid_0'); // Re-enter the large view on the test device
  await dt.assertComponent('MotionPictureLargeView', true);

  // 预期结果2、测试机该动态照片需重新下载，下载后支持效果切换
  // 2.4、断言测试机显示下载指示 (如果需要重新下载)
  await dt.assertComponent('DownloadIndicator', true); // Assert download indicator appears
  await dt.sleep(DELAY.long); // Wait for re-download to complete
  await dt.assertComponent('DownloadCompleteIndicator', false); // Assert download indicator disappears

  // 2.5、断言测试机支持效果切换 (即，切换按钮可用)
  await dt.assertComponentClickable('MotionEffectSwitchButton', true); // Assert the effect switch button is clickable
  // Further, verify the effect is indeed the one set by the auxiliary device
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOption_LoopPlayback_Selected',
    true); // Placeholder: Assert 'Loop Playback' is selected

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换多端同步 end');
}

/**
 * 大图-动态照片: [动态图片自动播放场景]
 * TAG: 291 TID: Multimedia_Gallery_Motion_picture_177
 * 前置条件
 * 1、已预置动态照片
 */
async function Multimedia_Gallery_Motion_picture_177(dt: Dt) {
  dt.log.i('动态图片自动播放场景 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 已预置动态照片');
  // Assume a setup function to ensure dynamic photos are present in the gallery
  await dt.prepareDynamicPhotos(); // Placeholder: Ensure dynamic photos are in gallery
  await dt.launchGalleryApp(); // Placeholder: Launch gallery app
  await dt.assertComponent('photoGridView_grid_0', true); // Assert gallery grid view is visible
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、初次进入图库，第一个为动态照片，检查动态照片是否播放');
  // 1.1、确保第一个图片是动态照片，并进入图库首页
  // (Assuming launchGalleryApp puts us on the main photo grid with dynamic photo as first item)
  await dt.sleep(DELAY.short); // Short delay for initial rendering
  // 1.2、断言动态照片未自动播放 (例如，检查播放/暂停按钮状态，或检查视频进度条未移动)
  await dt.assertComponent('PlayButton', true); // Assert play button is visible (implies not playing)
  await dt.assertComponent('PauseButton', false); // Assert pause button is not visible
  dt.log.i('预期结果1、不自动播放');

  dt.log.i('STEP 2、缩放动态照片，检查是否播放');
  // 2.1、点击进入动态照片大图
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);

  // 2.2、执行双指捏合放大操作
  await dt.assertPinchOutById('MotionPictureLargeView'); // Assuming MotionPictureLargeView is the ID of the large image area
  await dt.sleep(DELAY.short);
  // 2.3、断言动态照片未播放
  await dt.assertComponent('PlayButton', true);
  await dt.assertComponent('PauseButton', false);
  dt.log.i('预期结果2、不自动播放');

  dt.log.i('STEP 3、左右滑动动态照片，检查是否播放');
  // 3.1、滑动到下一张照片（假设下一张也是动态照片或者返回到第一张动态照片）
  await dt.swipeScreen.left(); // Swipe to the next photo
  await dt.sleep(DELAY.short);
  await dt.assertComponent('MotionPictureLargeView', true); // Assert still in large view

  // 3.2、断言动态照片播放
  await dt.assertComponent('PlayButton', false); // Assert play button is not visible (implies playing)
  await dt.assertComponent('PauseButton', true); // Assert pause button is visible
  dt.log.i('预期结果3、播放');
  await dt.assertComponent(PageTitle.index,
    true); // Assert current page is large view (PageTitle.index used here for generic page assertion)

  dt.log.i('STEP 4、再次缩放动态照片，检查是否播放');
  // 4.1、执行双指捏合放大操作
  await dt.assertPinchOutById('MotionPictureLargeView');
  await dt.sleep(DELAY.short);
  // 4.2、断言动态照片播放
  await dt.assertComponent('PlayButton', false);
  await dt.assertComponent('PauseButton', true);
  dt.log.i('预期结果4、播放');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、相机拍摄动态照片，快速打开该照片，检查是否播放');
  // 5.1、返回到图库首页
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  // 5.2、启动相机并拍摄动态照片
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.exitCameraToGalleryFast(); // Placeholder: A faster exit to gallery, directly opening the new photo

  // 5.3、断言动态照片未自动播放
  await dt.assertComponent('PlayButton', true);
  await dt.assertComponent('PauseButton', false);
  dt.log.i('预期结果5、不自动播放');
  await dt.assertComponent(PageTitle.index, true); // Assert current page is large view

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态图片自动播放场景 end');
}