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


export default function MultimediaMediaPhotoPickerAuthorizedTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllSUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100').init();
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 start');
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0103', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [畅联：分享图片，查看已分享的图片] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0103
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0103(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0106', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [小红书：新建笔记] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0106
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0106(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0107', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [微博：新建微博] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0107
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0107(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0108', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [美图秀秀：选图优化] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0108
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0108(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0109', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [抖音：发布作品] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0109
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0109(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0110', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [微信：分享图片] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0110
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0110(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0111', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [微信：新建朋友圈] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0111
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0111(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0112', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信：更换头像] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0112
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0112(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端打开备忘录，使用服务互通访问图库功能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0100(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0101', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端打开笔记，使用服务互通访问图库功能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0101
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0101(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0102', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端打开小红书，使用服务互通访问图库功能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0102
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0102(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0210', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端picker子窗位置验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0210
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0210(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0211', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [PC端相册展示：图片和视频数量为0时] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0211
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0211(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0212', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [PC端相册展示：图片和视频数量不为0，且我的相册数量不为0] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0212
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0212(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0213', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [PC端相册展示：图片和视频数量不为0，且来自应用相册数量不为0] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0213
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0213(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0214', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-收藏用例: [PC端相册展示：已删除相册与智慧分析相册，我的收藏] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0214
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0214(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0215', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端安全弹窗：存在弹窗（安全访问图库）] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0215
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0215(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0216', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端安全弹窗：不存在安全弹窗（安全访问图库）] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0216
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0216(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [PC端宫格选择样式验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0217
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端拍照显示验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0218
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端多选数量验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0222
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222(dt);
    });

    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端继承功能：动效验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0223
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachSUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100').init();
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllSUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100').init();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 start');
      await Exit.browser();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100 finish');
    });
  });
}

/**
 * picker-视频: [三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1100
 * 前置条件
 * 1.图库存在录屏保存的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100(dt: Dt) {
  dt.log.i('三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击微博，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权 end');
}

/**
 * picker-视频: [三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1200
 * 前置条件
 * 1.图库存在录屏保存的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200(dt: Dt) {
  dt.log.i('三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击小红书，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权 end');
}

/**
 * picker-下载: [畅联：分享图片，查看已分享的图片]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0103
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0103(dt: Dt) {
  dt.log.i('畅联：分享图片，查看已分享的图片 start');
  dt.log.i('STEP 1、宫格页滑动');

  await dt.sleep();
  dt.log.i('预期结果1、宫格页滑动流畅不掉帧，无白屏现象出现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滚动条滑动');

  await dt.sleep();
  dt.log.i('预期结果2、滚动条滑动流畅不掉帧，无白屏现象出现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图预览界面点击编辑，进入编辑页面，编辑后保存');

  await dt.sleep();
  dt.log.i('预期结果3、大图预览界面点击编辑，正常进入编辑页面，编辑后的图片正常保存，正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果4、云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、勾选后点击确定，点击已发送的图片');

  await dt.sleep();
  dt.log.i('预期结果5、勾选后点击确定的图片正常分享给畅联好友，点击已发送的图片可正常查看图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、所有图片切换相册页');

  await dt.sleep();
  dt.log.i('预期结果6、所有图片切换相册页，流畅不卡顿');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('畅联：分享图片，查看已分享的图片 end');
}

/**
 * picker-下载: [小红书：新建笔记]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0106
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0106(dt: Dt) {
  dt.log.i('小红书：新建笔记 start');
  dt.log.i('STEP 1、云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、勾选图片，点击预览进大图，右下角序号显示');

  await dt.sleep();
  dt.log.i('预期结果2、勾选图片，点击预览进大图，右下角序号图标正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、左右滑动切换预览大图');

  await dt.sleep();
  dt.log.i('预期结果3、左右滑动可正常切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、点击下一步，进入小红书编辑页，再次点击+号再次拉起picker view进行选图');

  await dt.sleep();
  dt.log.i('预期结果4、点击下一步，正常进入小红书编辑页，再次点击+号可再次拉起picker view进行选图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、点击下一步，进入小红书发布页');

  await dt.sleep();
  dt.log.i('预期结果5、点击下一步，正常进入小红书发布页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、点击图片查看已选择图片的大图预览页，再次点击+号再次拉起picker view进行选图');

  await dt.sleep();
  dt.log.i('预期结果6、点击图片可查看已选择图片的大图预览页，再次点击+号可再次拉起picker view进行选图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('小红书：新建笔记 end');
}

/**
 * picker-下载: [微博：新建微博]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0107
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0107(dt: Dt) {
  dt.log.i('微博：新建微博 start');
  dt.log.i('STEP 1、新建微博，拉起picker view，点击拍照，拍照后的图片正常显示在发微博页面');

  await dt.sleep();
  dt.log.i('预期结果1、新建微博，拉起picker view，点击拍照，拍照后的图片正常显示在发微博页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击云图正常下载，图标显示正常');

  await dt.sleep();
  dt.log.i('预期结果2、点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、勾选图片，点击预览进大图，右上角序号图标正常显示，滑动范围为已勾选的图片，点击下方缩略图可切换预览大图');

  await dt.sleep();
  dt.log.i('预期结果3、勾选图片，点击预览进大图，右上角序号图标正常显示，滑动范围为已勾选的图片，点击下方缩略图可切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、勾选图片，点击图片进大图，右下角序号图标正常显示，滑动范围为全部图片，左右滑动可正常切换预览大图');

  await dt.sleep();
  dt.log.i('预期结果4、勾选图片，点击图片进大图，右下角序号图标正常显示，滑动范围为全部图片，左右滑动可正常切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、点击下一步，正常进入发布微博页面，点击图片可进入已选择图片的大图预览页');

  await dt.sleep();
  dt.log.i('预期结果5、点击下一步，正常进入发布微博页面，点击图片可进入已选择图片的大图预览页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、再次点击+号可再次拉起picker view进行选图');

  await dt.sleep();
  dt.log.i('预期结果6、再次点击+号可再次拉起picker view进行选图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微博：新建微博 end');
}

/**
 * picker-下载: [美图秀秀：选图优化]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0108
 * 前置条件
 * 1、图库中存在未下载的云图
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0108(dt: Dt) {
  dt.log.i('美图秀秀：选图优化 start');
  dt.log.i('STEP 1、点击云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选择图片进入P图页面');

  await dt.sleep();
  dt.log.i('预期结果2、选择图片正常进入P图页面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美图秀秀：选图优化 end');
}

/**
 * picker-下载: [抖音：发布作品]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0109
 * 前置条件
 * 1、图库中存在未下载的云图
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0109(dt: Dt) {
  dt.log.i('抖音：发布作品 start');
  dt.log.i('STEP 1、点击云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选择图片进入发布作品编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、选择图片正常进入发布作品编辑页面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('抖音：发布作品 end');
}

/**
 * picker-下载: [微信：分享图片]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0110
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0110(dt: Dt) {
  dt.log.i('微信：分享图片 start');
  dt.log.i('STEP 1、微信好友聊天，拉起picker view，点击云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、微信好友聊天，拉起picker view，点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击上方相册页，选择相册进入');

  await dt.sleep();
  dt.log.i('预期结果2、点击上方相册页，可正常选择相册进入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、滑动多选');

  await dt.sleep();
  dt.log.i('预期结果3、滑动多选正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、勾选图片，点击预览进大图，右上角序号图标显示，左右滑动切换预览，点击下方缩略图切换预览大图');

  await dt.sleep();
  dt.log.i('预期结果4、勾选图片，点击预览进大图，右上角序号图标正常显示，滑动范围为已勾选的图片，点击下方缩略图可切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、勾选图片，点击图片进大图，右上角序号图标显示，左右滑动切换预览');

  await dt.sleep();
  dt.log.i('预期结果5、勾选图片，点击图片进大图，右上角序号图标正常显示，滑动范围为全部图片，左右滑动可正常切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、点击发送，发送图片给微信好友');

  await dt.sleep();
  dt.log.i('预期结果6、点击发送，可正常发送图片给微信好友');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信：分享图片 end');
}

/**
 * picker-下载: [微信：新建朋友圈]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0111
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0111(dt: Dt) {
  dt.log.i('微信：新建朋友圈 start');
  dt.log.i('STEP 1、新建朋友圈，拉起picker view，点击云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、微信好友聊天，拉起picker view，点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击上方相册页，选择相册进入');

  await dt.sleep();
  dt.log.i('预期结果2、点击上方相册页，可正常选择相册进入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、滑动多选');

  await dt.sleep();
  dt.log.i('预期结果3、滑动多选正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、勾选图片，点击预览进大图，右上角序号图标正常显示，左右滑动切换预览，点击下方缩略图切换预览大图');

  await dt.sleep();
  dt.log.i('预期结果4、勾选图片，点击预览进大图，右上角序号图标正常显示，滑动范围为已勾选的图片，点击下方缩略图可切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、勾选图片，点击图片进大图，右上角序号图标正常显示，左右滑动切换预览');

  await dt.sleep();
  dt.log.i('预期结果5、勾选图片，点击图片进大图，右上角序号图标正常显示，滑动范围为全部图片，左右滑动可正常切换预览大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、点击发送，进入发布朋友圈页面');

  await dt.sleep();
  dt.log.i('预期结果6、点击发送，可正常进入发布朋友圈页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、再次点击+号，再次拉起picker view进行选图');

  await dt.sleep();
  dt.log.i('预期结果7、再次点击+号，可再次拉起picker view进行选图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信：新建朋友圈 end');
}

/**
 * picker-进入大图: [微信：更换头像]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0112
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0112(dt: Dt) {
  dt.log.i('微信：更换头像 start');
  dt.log.i('STEP 1、更换头像，拉起picker view，点击云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果1、更换头像，拉起picker view，点击云图正常下载，图标显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击上方相册页，选择相册进入，观察相册页中的显示');

  await dt.sleep();
  dt.log.i('预期结果2、点击上方相册页，可正常选择相册进入，且相册页中显示的均为图片，不会显示视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击预览进入大图预览页面');

  await dt.sleep();
  dt.log.i('预期结果3、点击预览可正常进入大图预览页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、勾选点击图片，进入头像编辑页面');

  await dt.sleep();
  dt.log.i('预期结果4、勾选点击图片，可正常进入头像编辑页面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信：更换头像 end');
}

/**
 * picker-下载: [PC端打开备忘录，使用服务互通访问图库功能]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0100
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 3、PC手机服务互通
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0100(dt: Dt) {
  dt.log.i('PC端打开备忘录，使用服务互通访问图库功能 start');
  dt.log.i('STEP 1、PC端打开备忘录，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');

  await dt.sleep();
  dt.log.i('预期结果1、PC端打开备忘录，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC端备忘录使用服务互通访问图库功能插入图片，观察插入图片');

  await dt.sleep();
  dt.log.i('预期结果2、PC端备忘录使用服务互通访问图库功能插入图片，观察插入图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端打开备忘录，使用服务互通访问图库功能 end');
}

/**
 * picker-下载: [PC端打开笔记，使用服务互通访问图库功能]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0101
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 3、PC手机服务互通
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0101(dt: Dt) {
  dt.log.i('PC端打开笔记，使用服务互通访问图库功能 start');
  dt.log.i('STEP 1、PC端打开笔记，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');

  await dt.sleep();
  dt.log.i('预期结果1、PC端打开笔记，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC端笔记使用服务互通访问图库功能插入图片，观察插入图片');

  await dt.sleep();
  dt.log.i('预期结果2、PC端笔记使用服务互通访问图库功能插入图片，观察插入图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端打开笔记，使用服务互通访问图库功能 end');
}

/**
 * picker-下载: [PC端打开小红书，使用服务互通访问图库功能]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0102
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 3、PC手机服务互通
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0102(dt: Dt) {
  dt.log.i('PC端打开小红书，使用服务互通访问图库功能 start');
  dt.log.i('STEP 1、PC端打开小红书，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');

  await dt.sleep();
  dt.log.i('预期结果1、PC端打开小红书，使用服务互通访问图库功能，观察过程中界面布局、功能按钮、支持图片上限一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC端小红书使用服务互通访问图库功能插入图片，观察插入图片');

  await dt.sleep();
  dt.log.i('预期结果2、PC端小红书使用服务互通访问图库功能插入图片，观察插入图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端打开小红书，使用服务互通访问图库功能 end');
}

/**
 * picker-下载: [PC端picker子窗位置验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0210
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0210(dt: Dt) {
  dt.log.i('PC端picker子窗位置验证 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.手动拖动，缩放');

  await dt.sleep();
  dt.log.i('预期结果2.无法被拖动，无法缩放，位置固定');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端picker子窗位置验证 end');
}

/**
 * picker-视频: [PC端相册展示：图片和视频数量为0时]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0211
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内没有视频以及图片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0211(dt: Dt) {
  dt.log.i('PC端相册展示：图片和视频数量为0时 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.查看左侧侧边栏');

  await dt.sleep();
  dt.log.i('预期结果2.侧边栏有图片和视频，图片，视频这三项');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端相册展示：图片和视频数量为0时 end');
}

/**
 * picker-视频: [PC端相册展示：图片和视频数量不为0，且我的相册数量不为0]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0212
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 3.图库有两个用户自定义的相册，a和b
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0212(dt: Dt) {
  dt.log.i('PC端相册展示：图片和视频数量不为0，且我的相册数量不为0 start');
  dt.log.i('STEP 1.从a相册拉起picker，查看相册展示');

  await dt.sleep();
  dt.log.i('预期结果1.侧边栏展示的相册有，图片和视频，图片，视频，我的相册：b');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.从b相册拉起picker，查看相册展示');

  await dt.sleep();
  dt.log.i('预期结果2.侧边栏展示的相册有，图片和视频，图片，视频，我的相册：a');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端相册展示：图片和视频数量不为0，且我的相册数量不为0 end');
}

/**
 * picker-视频: [PC端相册展示：图片和视频数量不为0，且来自应用相册数量不为0]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0213
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 3.图库来自相册内有图片等资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0213(dt: Dt) {
  dt.log.i('PC端相册展示：图片和视频数量不为0，且来自应用相册数量不为0 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.查看左侧侧边栏');

  await dt.sleep();
  dt.log.i('预期结果2.左侧侧边栏有来自相册一栏，且对应的来自相册内的有资源的相册被展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端相册展示：图片和视频数量不为0，且来自应用相册数量不为0 end');
}

/**
 * picker-收藏: [PC端相册展示：已删除相册与智慧分析相册，我的收藏]
 * GROUP: picker MODULE: 收藏TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0214
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 3.已删除相册不为0，我的收藏不为0
 4.智慧分析完成，生成智慧分析类相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0214(dt: Dt) {
  dt.log.i('PC端相册展示：已删除相册与智慧分析相册，我的收藏 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.查看左侧侧边栏');

  await dt.sleep();
  dt.log.i('预期结果2.左侧侧边栏我的收藏被展示，已删除相册以及智慧分析类的相册不被展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端相册展示：已删除相册与智慧分析相册，我的收藏 end');
}

/**
 * picker-下载: [PC端安全弹窗：存在弹窗（安全访问图库）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0215
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0215(dt: Dt) {
  dt.log.i('PC端安全弹窗：存在弹窗（安全访问图库） start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.切换相册');

  await dt.sleep();
  dt.log.i('预期结果2.安全弹窗依然存在');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端安全弹窗：存在弹窗（安全访问图库） end');
}

/**
 * picker-下载: [PC端安全弹窗：不存在安全弹窗（安全访问图库）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0216
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 3.未取消安全弹窗
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0216(dt: Dt) {
  dt.log.i('PC端安全弹窗：不存在安全弹窗（安全访问图库） start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.宫格进大图，编辑界面查看');

  await dt.sleep();
  dt.log.i('预期结果2.大图和编辑界面均没有安全弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.取消安全弹窗后再次进入相册页，宫格页');

  await dt.sleep();
  dt.log.i('预期结果3.取消安全弹窗后，相册页，宫格页均不存在安全弹窗');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端安全弹窗：不存在安全弹窗（安全访问图库） end');
}

/**
 * picker-进入大图: [PC端宫格选择样式验证]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0217
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217(dt: Dt) {
  dt.log.i('PC端宫格选择样式验证 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.点击一次宫格内的任意一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.点击一次的图片被框选');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.再点击一次宫内其余的图片');

  await dt.sleep();
  dt.log.i('预期结果3.被点击一次的其余的图片也被框选');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击一次已经被点击过的一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.进入大图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端宫格选择样式验证 end');
}

/**
 * picker-下载: [PC端拍照显示验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0218
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218(dt: Dt) {
  dt.log.i('PC端拍照显示验证 start');
  dt.log.i('STEP 1.demo拉起picker，查看图片和视频宫格页面');

  await dt.sleep();
  dt.log.i('预期结果1.有拍照组件');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.图库拉起picker，查看图片和视频宫格页面');

  await dt.sleep();
  dt.log.i('预期结果2.没有拍照组件');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端拍照显示验证 end');
}

/**
 * picker-下载: [PC端多选数量验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0222
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222(dt: Dt) {
  dt.log.i('PC端多选数量验证 start');
  dt.log.i('STEP 1.demo拉起picker，选择分别1，500，501张');

  await dt.sleep();
  dt.log.i('预期结果1.选择1，500张时正常多选，选择第501张时弹出toast');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端多选数量验证 end');
}

/**
 * picker-下载: [PC端继承功能：动效验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0223
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223(dt: Dt) {
  dt.log.i('PC端继承功能：动效验证 start');
  dt.log.i('STEP 1.相册切换');

  await dt.sleep();
  dt.log.i('预期结果1.切换动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.大图页面左右滑动');

  await dt.sleep();
  dt.log.i('预期结果2.左右滑动动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.相册进大图，大图返回动效');

  await dt.sleep();
  dt.log.i('预期结果3.相册进大图以及大图返回动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.宫格页滑动，滚动条滑动');

  await dt.sleep();
  dt.log.i('预期结果4.宫格页滑动以及滚动条滑动效正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：动效验证 end');
}
