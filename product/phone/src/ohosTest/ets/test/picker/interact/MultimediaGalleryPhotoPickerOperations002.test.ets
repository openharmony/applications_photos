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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';


export default function MultimediaGalleryPhotoPickerOperationsTest002(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerOperations061Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerOperations061').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerOperations061 start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerOperations061 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryPhotoPickerOperations061', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [申请保存图片+视频] TID: Multimedia_Gallery_PhotoPickerOperations_061
      await MultimediaGalleryPhotoPickerOperations061(dt);
    });

    run('MultimediaGalleryPhotoPickerOperations062', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [picker view化界面显示gif格式图片图标] TID: Multimedia_Gallery_PhotoPickerOperations_062
      await MultimediaGalleryPhotoPickerOperations062(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0100', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0100
      await MultimediaGalleryPhotoPickerPlayerStatus0100(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0101', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中暂停播放检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0101
      await MultimediaGalleryPhotoPickerPlayerStatus0101(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0102', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中开始拖动进度条检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0102
      await MultimediaGalleryPhotoPickerPlayerStatus0102(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0103', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放暂停开始拖动进度条检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0103
      await MultimediaGalleryPhotoPickerPlayerStatus0103(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0104', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中开始拖动进度条后结束拖动测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0104
      await MultimediaGalleryPhotoPickerPlayerStatus0104(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0105', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放暂停开始拖动进度条后结束拖动测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0105
      await MultimediaGalleryPhotoPickerPlayerStatus0105(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0106', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放完毕后重新播放检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0106
      await MultimediaGalleryPhotoPickerPlayerStatus0106(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0107', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放完毕后检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0107
      await MultimediaGalleryPhotoPickerPlayerStatus0107(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0108', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中拖拽进度条至播放完毕检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0108
      await MultimediaGalleryPhotoPickerPlayerStatus0108(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0109', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0109
      await MultimediaGalleryPhotoPickerPlayerStatus0109(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0110', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0110
      await MultimediaGalleryPhotoPickerPlayerStatus0110(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0111', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0111
      await MultimediaGalleryPhotoPickerPlayerStatus0111(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0112', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0112
      await MultimediaGalleryPhotoPickerPlayerStatus0112(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0113', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放停止退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0113
      await MultimediaGalleryPhotoPickerPlayerStatus0113(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0114', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0114
      await MultimediaGalleryPhotoPickerPlayerStatus0114(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0115', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0115
      await MultimediaGalleryPhotoPickerPlayerStatus0115(dt);
    });

    run('MultimediaGalleryPhotoPickerPlayerStatus0116', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0116
      await MultimediaGalleryPhotoPickerPlayerStatus0116(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0200', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [隐私空间，图片位置展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0200
      await MultimediaGalleryPhotoPickerPrivacy0200(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0201', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [隐私空间，不同图片类型展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0201
      await MultimediaGalleryPhotoPickerPrivacy0201(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0202', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，不同相册展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0202
      await MultimediaGalleryPhotoPickerPrivacy0202(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0203', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [隐私空间，排序规则验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0203
      await MultimediaGalleryPhotoPickerPrivacy0203(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0204', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-详情用例: [隐私空间，安全访问弹窗验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0204
      await MultimediaGalleryPhotoPickerPrivacy0204(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0205', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [隐私空间，图片选择数量限制验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0205
      await MultimediaGalleryPhotoPickerPrivacy0205(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0206', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，相机入口、搜索入口、编辑入口不展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0206
      await MultimediaGalleryPhotoPickerPrivacy0206(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0207', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [隐私空间，角标展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0207
      await MultimediaGalleryPhotoPickerPrivacy0207(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerOperations061').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerOperations061 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerOperations061 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerOperations061').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerOperations061 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerOperations061 finish');
    });
  });
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
  await dt.sleep(DELAY.short);


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

/**
 * picker-视频: [视频播放中检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0100
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0100(dt: Dt) {
  dt.log.i('视频播放中检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中检测回调状态 end');
}

/**
 * picker-视频: [视频播放中暂停播放检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0101
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0101(dt: Dt) {
  dt.log.i('视频播放中暂停播放检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停中');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中暂停播放检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中开始拖动进度条检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0102
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0102(dt: Dt) {
  dt.log.i('视频播放中开始拖动进度条检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后拖动进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为3-开始拖拽进度条');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中开始拖动进度条检测回调状态 end');
}

/**
 * picker-进度条: [视频播放暂停开始拖动进度条检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0103
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0103(dt: Dt) {
  dt.log.i('视频播放暂停开始拖动进度条检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停，然后拖动进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为3-开始拖拽进度条');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停开始拖动进度条检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中开始拖动进度条后结束拖动测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0104
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0104(dt: Dt) {
  dt.log.i('视频播放中开始拖动进度条后结束拖动测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后拖动进度条，然后停止拖拽进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为4-结束拖拽进度条');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中开始拖动进度条后结束拖动测回调状态 end');
}

/**
 * picker-进度条: [视频播放暂停开始拖动进度条后结束拖动测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0105
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0105(dt: Dt) {
  dt.log.i('视频播放暂停开始拖动进度条后结束拖动测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停，然后拖动进度条，然后停止拖拽进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为4-结束拖拽进度条');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停开始拖动进度条后结束拖动测回调状态 end');
}

/**
 * picker-视频: [视频播放完毕后重新播放检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0106
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0106(dt: Dt) {
  dt.log.i('视频播放完毕后重新播放检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('STEP 4.等待播放结束后重新点击播放');

  await dt.sleep();
  dt.log.i('预期结果4.demo中显示回调状态为0-播放中');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放完毕后重新播放检测回调状态 end');
}

/**
 * picker-视频: [视频播放完毕后检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0107
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0107(dt: Dt) {
  dt.log.i('视频播放完毕后检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('STEP 4.等待播放结束');

  await dt.sleep();
  dt.log.i('预期结果4.demo中显示回调状态为2-播放停止');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放完毕后检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中拖拽进度条至播放完毕检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0108
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0108(dt: Dt) {
  dt.log.i('视频播放中拖拽进度条至播放完毕检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后拖拽进度条至播放完毕');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中拖拽进度条至播放完毕检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0109
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0109(dt: Dt) {
  dt.log.i('视频播放中退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0110
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0110(dt: Dt) {
  dt.log.i('视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0111
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0111(dt: Dt) {
  dt.log.i('视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放然后暂停，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停，且视频还会处于播放暂停状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0112
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0112(dt: Dt) {
  dt.log.i('视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后暂停，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停，且视频还会处于播放暂停状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放停止退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0113
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0113(dt: Dt) {
  dt.log.i('视频播放停止退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放等待视频播放结束，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止，且视频还会处于播放完成状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放停止退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0114
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0114(dt: Dt) {
  dt.log.i('视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，播放视频停止，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止，且视频还会处于播放完成状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0115
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0115(dt: Dt) {
  dt.log.i('视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击图库，播放相同的视频');

  await dt.sleep();
  dt.log.i('STEP 5.图库退后台，拉回demo到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0116
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0116(dt: Dt) {
  dt.log.i('视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放，音乐播放被打断');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击音乐，播放音频');

  await dt.sleep();
  dt.log.i('STEP 5.音乐退后台，拉回demo到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态 end');
}

/**
 * picker-下载: [隐私空间，图片位置展示验证]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerPrivacy_0200
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在纯云端图片，云端下行且本地下载的图片，本地有但云端没有的图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0200(dt: Dt) {
  dt.log.i('隐私空间，图片位置展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，查看图片');

  await dt.sleep();
  dt.log.i('预期结果1.隐私空间内的纯云端的图库数据不展示，本地存在的图库数据展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.打开隐私空间内的文件管理器，查看图片');

  await dt.sleep();
  dt.log.i('预期结果2.隐私空间内的文件管理中无法查看主空间的图库资源');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，图片位置展示验证 end');
}

/**
 * picker-进入大图: [隐私空间，不同图片类型展示验证]
 * GROUP: picker MODULE: 进入大图TID: Multimedia_Gallery_PhotoPickerPrivacy_0201
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在静态图片，连拍的图片，动态图片，以及视频
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0201(dt: Dt) {
  dt.log.i('隐私空间，不同图片类型展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker ，查看图片');

  await dt.sleep();
  dt.log.i('预期结果1.静态照片，连拍照片，动态照片，视频均支持展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击宫格页面动态图片进大图');

  await dt.sleep();
  dt.log.i('预期结果2.进入大图动态照片自动播放动态效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，不同图片类型展示验证 end');
}

/**
 * picker-格式: [隐私空间，不同相册展示验证]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0202
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频资源
 3.登录账号且有智慧相册，删除相册以及隐藏相册
 4.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0202(dt: Dt) {
  dt.log.i('隐私空间，不同相册展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，切换到相册页');

  await dt.sleep();
  dt.log.i('STEP 2.向上滑动查看所有相册');

  await dt.sleep();
  dt.log.i('预期结果2.可以看到的相册有：视频相册，图片相册，收藏相册，自定义相册。 不可以看到的相册有智慧相册，删除相册，隐藏相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，不同相册展示验证 end');
}

/**
 * picker-视频: [隐私空间，排序规则验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPrivacy_0203
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0203(dt: Dt) {
  dt.log.i('隐私空间，排序规则验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，查看图片');

  await dt.sleep();
  dt.log.i('STEP 2.上划查看图片顺序');

  await dt.sleep();
  dt.log.i('预期结果2.排序顺序正常，和图库相册顺序保持一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，排序规则验证 end');
}

/**
 * picker-详情: [隐私空间，安全访问弹窗验证]
 * GROUP: picker MODULE: 详情TID: Multimedia_Gallery_PhotoPickerPrivacy_0204
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0204(dt: Dt) {
  dt.log.i('隐私空间，安全访问弹窗验证 start');
  dt.log.i('STEP 1.第一次调起隐私空间内picker ');

  await dt.sleep();
  dt.log.i('预期结果1.上方展示有安全访问图库字段');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.不点击×，再次进入picker ');

  await dt.sleep();
  dt.log.i('预期结果2.仍然可以看到上方展示的有安全访问图库的字段');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击了解详情');

  await dt.sleep();
  dt.log.i('预期结果3.拉起安全详情弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4. 点击×，再次进入picker');

  await dt.sleep();
  dt.log.i('预期结果4.上方无展示安全访问图库的字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，安全访问弹窗验证 end');
}

/**
 * picker-视频: [隐私空间，图片选择数量限制验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPrivacy_0205
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片超过100张
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0205(dt: Dt) {
  dt.log.i('隐私空间，图片选择数量限制验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker');

  await dt.sleep();
  dt.log.i('STEP 2.不选择图片');

  await dt.sleep();
  dt.log.i('预期结果2.完成按钮置灰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.选择1张图片，点击完成。');

  await dt.sleep();
  dt.log.i('预期结果3.拉起弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4. 选择100张图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果4.拉起弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.选择101张图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果5.选择第100图片后，完成按钮置灰，且点击弹出toast提示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，图片选择数量限制验证 end');
}

/**
 * picker-格式: [隐私空间，相机入口、搜索入口、编辑入口不展示验证]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0206
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频资源
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0206(dt: Dt) {
  dt.log.i('隐私空间，相机入口、搜索入口、编辑入口不展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker ，并查看该界面');

  await dt.sleep();
  dt.log.i('预期结果1.无拍照功能，无搜索功能');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击图片进大图');

  await dt.sleep();
  dt.log.i('预期结果2.大图无编辑入口');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，相机入口、搜索入口、编辑入口不展示验证 end');
}

/**
 * picker-动态照片: [隐私空间，角标展示验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerPrivacy_0207
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在收藏的图片，动态照片以及gif图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0207(dt: Dt) {
  dt.log.i('隐私空间，角标展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker,如隐私空间内picker ，并查看该界面');

  await dt.sleep();
  dt.log.i('预期结果1.动态照片以及gif图片都有对应的角标展示。导入的收藏的照片只有在隐私空间拉起主空间的picker页面才可看到。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，角标展示验证 end');
}
