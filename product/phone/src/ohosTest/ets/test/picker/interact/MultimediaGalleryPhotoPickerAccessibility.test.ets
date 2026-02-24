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

export default function MultimediaGalleryPhotoPickerAccessibility(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerAccessibilityTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerAccessibility').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerAccessibility start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerAccessibility finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerAccessibility', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerAccessibility0001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [图库picker，备忘录拉起picker无障碍] TID: Multimedia_Gallery_PhotoPicker_Accessibility_0001
      await MultimediaGalleryPhotoPickerAccessibility0001(dt);
    });
    run('MultimediaGalleryPhotoPickerAccessibility0002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [图库picker，微博拉起picker无障碍] TID: Multimedia_Gallery_PhotoPicker_Accessibility_0002
      await MultimediaGalleryPhotoPickerAccessibility0002(dt);
    });
    run('MultimediaGalleryPhotoPickerAccessibility0003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-预览条用例: [图库picker，小红书拉起picker多选，预览条无障碍] TID: Multimedia_Gallery_PhotoPicker_Accessibility_0003
      await MultimediaGalleryPhotoPickerAccessibility0003(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerAccessibility').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerAccessibility start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerAccessibility finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerAccessibility').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerAccessibility start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerAccessibility finish');
    });
  });
}

// DT步骤
/**
 * picker-进入大图: [图库picker，备忘录拉起picker无障碍]
 * GROUP: picker MODULE: 进入大图TID: Multimedia_Gallery_PhotoPicker_Accessibility_0001
 * 前置条件
 * 1.图库存在图片和视频
 2.设置已开启屏幕朗读（设置-辅助功能-屏幕朗读）

 */
async function MultimediaGalleryPhotoPickerAccessibility0001(dt: Dt) {
  dt.log.i('图库picker，备忘录拉起picker无障碍 start');
  dt.log.i('STEP 1.备忘录拉起picker（覆盖三种聚焦方式：1）在界面上单指不抬手触摸浏览；2）聚焦页面首个元素后，抬手单指向右骚动，循环扫动；3）在界面上抬手点击每个可见的元素）');

  await dt.sleep();
  dt.log.i('STEP 2.所有图片界面，点击缩略图等可选中元素聚焦，语音播报提示后双击打开，图片左侧图标点击，双击');

  await dt.sleep();
  dt.log.i('预期结果2.点击缩略图可选中元素聚焦，语音播报，双击后点击打开进入大图界面，图片文字左侧图标点击聚焦，双击后返回至宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.所有图片界面，上下滑动，切换可选中元素聚焦');

  await dt.sleep();
  dt.log.i('预期结果3.所有图片界面，上下滑动可以切换聚焦的元素');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.所有图片界面，双指滑动进行多选');

  await dt.sleep();
  dt.log.i('预期结果4.所有图片页面，双指滑动可进行多选');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.单指点击所有相册，聚焦后双击');

  await dt.sleep();
  dt.log.i('预期结果5.可打开所有相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6.所有相册界面，点击相册等可选中元素聚焦，语音播报提示后双击打开，打开相册后，宫格页面，双指滑动进行多选。单指该页面元素，双击。');

  await dt.sleep();
  dt.log.i('预期结果6.所有相册页面，点击任意相册可以选中该相册元素并聚焦，语音播报提示，且双击后打开。打开相册后进入该宫格页面，双指滑动可进行多选，如果存在未下载的云图，未下载的云图将被下载。该页面元素单指点击可以聚焦，然后双击后可以选中该元素。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker，备忘录拉起picker无障碍 end');
}

/**
 * picker-进入大图: [图库picker，微博拉起picker无障碍]
 * GROUP: picker MODULE: 进入大图TID: Multimedia_Gallery_PhotoPicker_Accessibility_0002
 * 前置条件
 * 1.图库存在图片和视频
 2.设置已开启屏幕朗读（设置-辅助功能-屏幕朗读）

 */
async function MultimediaGalleryPhotoPickerAccessibility0002(dt: Dt) {
  dt.log.i('图库picker，微博拉起picker无障碍 start');
  dt.log.i('STEP 1.微博拉起picker（覆盖三种聚焦方式：1）在界面上单指不抬手触摸浏览；2）聚焦页面首个元素后，抬手单指向右骚动，循环扫动；3）在界面上抬手点击每个可见的元素）');

  await dt.sleep();
  dt.log.i('STEP 2，宫格页面点击缩略图等可选中元素，后双击打开，');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页面点击缩略图可聚焦该元素，语音播报提示后，双击即可打开，后进入大图界面，该页面元素可以选中，选中聚焦后，双击即可执行。上下滑动可以切换不同元素聚焦。双指滑动即可多选，如果有未下载的云图则会被下载');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3单指点击微博相册，双击。然后单指点击，双指点击，滑动等操作');

  await dt.sleep();
  dt.log.i('预期结果3.单指点击微博相册，聚焦于微博相册，双击后可以展示所有相册。单指可聚焦所选相册，双击后即可打开进入大图界面。所有界面均可上划滑动切换焦点，双击后即可执行。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker，微博拉起picker无障碍 end');
}

/**
 * picker-预览条: [图库picker，小红书拉起picker多选，预览条无障碍]
 * GROUP: picker MODULE: 预览条TID: Multimedia_Gallery_PhotoPicker_Accessibility_0003
 * 前置条件
 * 1.图库存在图片和视频
 2.设置已开启屏幕朗读（设置-辅助功能-屏幕朗读）

 */
async function MultimediaGalleryPhotoPickerAccessibility0003(dt: Dt) {
  dt.log.i('图库picker，小红书拉起picker多选，预览条无障碍 start');
  dt.log.i('STEP 1.小红书拉起picker（覆盖三种聚焦方式：1）在界面上单指不抬手触摸浏览；2）聚焦页面首个元素后，抬手单指向右骚动，循环扫动；3）在界面上抬手点击每个可见的元素）');

  await dt.sleep();
  dt.log.i('STEP 2.全部界面/视频/照片，点击缩略图等可选中元素聚焦，语音播报提示后双击打开，图片左侧图标点击，双击');

  await dt.sleep();
  dt.log.i('预期结果2.全部界面/视频/照片，点击缩略图会聚焦缩略图，双击后打开进入大图，左侧返回图标点击一次语音播报，再双击会返回到宫格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.所有图片界面/视频/照片，上下滑动，切换可选中元素聚焦所有图片界面，双指滑动进行多选。选中三张图片');

  await dt.sleep();
  dt.log.i('预期结果3.所有图片界面/视频/照片，向上滑动可聚焦上一个元素，向下滑动聚焦下一个元素。双指滑动可进行多选。选中的多张图片下方会有预览条，且可以选中聚焦');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker，小红书拉起picker多选，预览条无障碍 end');
}