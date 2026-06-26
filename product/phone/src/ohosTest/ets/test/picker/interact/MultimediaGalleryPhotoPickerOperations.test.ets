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

export default function MultimediaGalleryPhotoPickerOperations(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerOperationsTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerOperations').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerOperations start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerOperations finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerOperations', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerOperations040', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面查看] TID: Multimedia_Gallery_PhotoPickerOperations_040
      await MultimediaGalleryPhotoPickerOperations040(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations041', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面勾选图片/视频拦截能力] TID: Multimedia_Gallery_PhotoPickerOperations_041
      await MultimediaGalleryPhotoPickerOperations041(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations042', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面支持配置CheckBox的填充色] TID: Multimedia_Gallery_PhotoPickerOperations_042
      await MultimediaGalleryPhotoPickerOperations042(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations043', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面CheckBox顺序] TID: Multimedia_Gallery_PhotoPickerOperations_043
      await MultimediaGalleryPhotoPickerOperations043(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations044', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面支持配置宫格页面背景] TID: Multimedia_Gallery_PhotoPickerOperations_044
      await MultimediaGalleryPhotoPickerOperations044(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations045', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [picker view化界面进退大图回调通知，动效效果查看] TID: Multimedia_Gallery_PhotoPickerOperations_045
      await MultimediaGalleryPhotoPickerOperations045(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations046', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [picker view化界面相册列表选相册能力] TID: Multimedia_Gallery_PhotoPickerOperations_046
      await MultimediaGalleryPhotoPickerOperations046(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-竖屏用例: [picker view化界面横竖屏/分屏/悬浮窗展示] TID: Multimedia_Gallery_PhotoPickerOperations_047
      await MultimediaGalleryPhotoPickerOperations047(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations057', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [申请保存单张图片] TID: Multimedia_Gallery_PhotoPickerOperations_057
      await MultimediaGalleryPhotoPickerOperations057(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations058', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [申请保存多张图片] TID: Multimedia_Gallery_PhotoPickerOperations_058
      await MultimediaGalleryPhotoPickerOperations058(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations059', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [申请保存单个视频] TID: Multimedia_Gallery_PhotoPickerOperations_059
      await MultimediaGalleryPhotoPickerOperations059(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations060', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [申请保存多个视频] TID: Multimedia_Gallery_PhotoPickerOperations_060
      await MultimediaGalleryPhotoPickerOperations060(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations061', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [申请保存图片+视频] TID: Multimedia_Gallery_PhotoPickerOperations_061
      await MultimediaGalleryPhotoPickerOperations061(dt);
    });
    run('MultimediaGalleryPhotoPickerOperations062', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [picker view化界面显示gif格式图片图标] TID: Multimedia_Gallery_PhotoPickerOperations_062
      await MultimediaGalleryPhotoPickerOperations062(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerOperations').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerOperations start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerOperations finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerOperations').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerOperations start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerOperations finish');
    });
  });
}

// DT步骤
/**
 * picker-视频: [picker view化界面查看]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_040
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations040(dt: Dt) {
  dt.log.i('picker view化界面查看 start');
  dt.log.i('STEP 1.小红书拉起picker调起photo picker界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入picker view化的界面，上方展示三方的界面，下方展示photo picker的图片/视频的宫格界面');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.全部界面展示相机入口，视频及图片宫格缩略图；视频界面展示视频宫格缩略图；图片界面展示图片宫格缩略图覆盖手机，xxx，pc，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面查看 end');
}
/**
 * picker-视频: [picker view化界面勾选图片/视频拦截能力]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_041
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations041(dt: Dt) {
  dt.log.i('picker view化界面勾选图片/视频拦截能力 start');
  dt.log.i('STEP 1.点击符合三方传输要求的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果1.符合要求的图片/视频可被传入三方的url中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击不符合三方传输要求的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果2.不符合要求的图片/视频被拦截，不传入三方的url中');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.覆盖直板机，xxx，pc，pad');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面勾选图片/视频拦截能力 end');
}
/**
 * picker-视频: [picker view化界面支持配置CheckBox的填充色]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_042
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations042(dt: Dt) {
  dt.log.i('picker view化界面支持配置CheckBox的填充色 start');
  dt.log.i('STEP 1.设置CheckBox颜色');

  await dt.sleep();
  dt.log.i('预期结果1.选中的缩略图右下方CheckBox颜色为配置的颜色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.在图片宫格界面点击选中缩略图');

  await dt.sleep();
  dt.log.i('预期结果2.覆盖直板机，xxx，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面支持配置CheckBox的填充色 end');
}
/**
 * picker-视频: [picker view化界面CheckBox顺序]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_043
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations043(dt: Dt) {
  dt.log.i('picker view化界面CheckBox顺序 start');
  dt.log.i('STEP 1.在全部/视频/图片界面点击选择图片');

  await dt.sleep();
  dt.log.i('预期结果1.依次选中的图片按顺序排序，右下角checkbox显示排序数字');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.再次点击已选中的部分图片/视频');

  await dt.sleep();
  dt.log.i('预期结果2.点击部分的图片取消选择，这些图片后的顺序依次改变，重新生成顺序覆盖手机，xxx，pc，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面CheckBox顺序 end');
}
/**
 * picker-视频: [picker view化界面支持配置宫格页面背景]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_044
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations044(dt: Dt) {
  dt.log.i('picker view化界面支持配置宫格页面背景 start');
  dt.log.i('STEP 1.设置宫格界面的背景色');

  await dt.sleep();
  dt.log.i('预期结果1.宫格界面显示设置的背景色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入picker view化界面');

  await dt.sleep();
  dt.log.i('预期结果2.覆盖直板机，xxx，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面支持配置宫格页面背景 end');
}
/**
 * picker-大图: [picker view化界面进退大图回调通知，动效效果查看]
 * GROUP: picker MODULE: 大图TID: Multimedia_Gallery_PhotoPickerOperations_045
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations045(dt: Dt) {
  dt.log.i('picker view化界面进退大图回调通知，动效效果查看 start');
  dt.log.i('STEP 1.点击宫格缩略图的左上角放大图标进入大图');

  await dt.sleep();
  dt.log.i('预期结果1.进入大图有放大动效，直至大图完全显示，动效流畅，无crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.大图界面下滑/侧滑/点击back键返回宫格界面');

  await dt.sleep();
  dt.log.i('预期结果2.退出大图有缩小动效，直至回到宫格大小，动作流畅，无crash覆盖手机，xxx，pc，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面进退大图回调通知，动效效果查看 end');
}
/**
 * picker-视频: [picker view化界面相册列表选相册能力]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_046
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations046(dt: Dt) {
  dt.log.i('picker view化界面相册列表选相册能力 start');
  dt.log.i('STEP 1.进入picker view化界面，点击进入相册页面');

  await dt.sleep();
  dt.log.i('预期结果1.相册页列表展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击进入相册');

  await dt.sleep();
  dt.log.i('预期结果2.进入相册展示宫格缩略图页面，可退出相册宫格界面覆盖手机，xxx，pc，pad ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面相册列表选相册能力 end');
}
/**
 * picker-竖屏: [picker view化界面横竖屏/分屏/悬浮窗展示]
 * GROUP: picker MODULE: 竖屏TID: Multimedia_Gallery_PhotoPickerOperations_047
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerOperations047(dt: Dt) {
  dt.log.i('picker view化界面横竖屏/分屏/悬浮窗展示 start');
  dt.log.i('STEP 1.进入picker view化界面,横竖屏旋转');

  await dt.sleep();
  dt.log.i('预期结果1.横竖屏旋转时，picker界面图片无变形，旋转动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.切换到横屏/分屏/悬浮窗状态下');

  await dt.sleep();
  dt.log.i('预期结果2.横屏/分屏/悬浮窗时宫格及大图界面展示及功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.覆盖直板机，xxx，pad');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面横竖屏/分屏/悬浮窗展示 end');
}
/**
 * picker-: [申请保存单张图片]
 * GROUP: picker MODULE: TID: Multimedia_Gallery_PhotoPickerOperations_057
 * 前置条件
 * 1.图库第一个文件为图片

 */
async function MultimediaGalleryPhotoPickerOperations057(dt: Dt) {
  dt.log.i('申请保存单张图片 start');
  dt.log.i('STEP 1.点击“单张图片”按钮');

  await dt.sleep();
  dt.log.i('预期结果1.hilog | grep SaveUIExtensionLog');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击保存');

  await dt.sleep();
  dt.log.i('预期结果2.看到返回的uri字串');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('申请保存单张图片 end');
}
/**
 * picker-: [申请保存多张图片]
 * GROUP: picker MODULE: TID: Multimedia_Gallery_PhotoPickerOperations_058
 * 前置条件
 * 1.图库前两个文件为图片
 */
async function MultimediaGalleryPhotoPickerOperations058(dt: Dt) {
  dt.log.i('申请保存多张图片 start');
  dt.log.i('STEP 1.点击“多张图片”按钮');

  await dt.sleep();
  dt.log.i('预期结果1.hilog | grep SaveUIExtensionLog');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击保存');

  await dt.sleep();
  dt.log.i('预期结果2.看到返回的uri字串');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('申请保存多张图片 end');
}
/**
 * picker-视频: [申请保存单个视频]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_059
 * 前置条件
 * 1.图库第一个文件为视频
 */
async function MultimediaGalleryPhotoPickerOperations059(dt: Dt) {
  dt.log.i('申请保存单个视频 start');
  dt.log.i('STEP 1.点击“单个视频”按钮');

  await dt.sleep();
  dt.log.i('预期结果1.hilog | grep SaveUIExtensionLog');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击保存');

  await dt.sleep();
  dt.log.i('预期结果2.看到返回的uri字串');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('申请保存单个视频 end');
}
/**
 * picker-视频: [申请保存多个视频]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_060
 * 前置条件
 * 1.图库前两个文件为视频
 */
async function MultimediaGalleryPhotoPickerOperations060(dt: Dt) {
  dt.log.i('申请保存多个视频 start');
  dt.log.i('STEP 1.点击“多个视频”按钮');

  await dt.sleep();
  dt.log.i('预期结果1.hilog | grep SaveUIExtensionLog');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击保存');

  await dt.sleep();
  dt.log.i('预期结果2.看到返回的uri字串');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('申请保存多个视频 end');
}
/**
 * picker-视频: [申请保存图片+视频]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerOperations_061
 * 前置条件
 * 1.图库第一个文件为图片，第二个是视频
 */
async function MultimediaGalleryPhotoPickerOperations061(dt: Dt) {
  dt.log.i('申请保存图片+视频 start');
  dt.log.i('STEP 1.点击“图片+视频”按钮');

  await dt.sleep();
  dt.log.i('预期结果1.hilog | grep SaveUIExtensionLog');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击保存');

  await dt.sleep();
  dt.log.i('预期结果2.看到返回的uri字串');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3.保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('申请保存图片+视频 end');
}
/**
 * picker-格式: [picker view化界面显示gif格式图片图标]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerOperations_062
 * 前置条件
 * 1.图库中存在视频和图片
 2.存在gif格式图片
 */
async function MultimediaGalleryPhotoPickerOperations062(dt: Dt) {
  dt.log.i('picker view化界面显示gif格式图片图标 start');
  dt.log.i('STEP 1.进入picker view化界面，查看缩略图宫格显示');

  await dt.sleep();
  dt.log.i('预期结果1.进入picker view化界面，gif格式缩略图显示gif图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入相册');

  await dt.sleep();
  dt.log.i('预期结果2.进入相册宫格，gif格式缩略图显示gif图标覆盖手机，xxx，pc，pad');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker view化界面显示gif格式图片图标 end');
}
