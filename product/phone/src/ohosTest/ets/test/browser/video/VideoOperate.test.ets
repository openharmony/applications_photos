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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { DisplayRotation, ON } from '@ohos.UiTest';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function VideoOperateTest(): void {
  describe('VideoOperateTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    run('beforeAll_VideoPlayer', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      dt.log.i('beforeAll_VideoPlayer start');
      await AppStart.photos();
      await dt.videoBrowser();
      dt.log.i('beforeAll_VideoPlayer finish');
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_0061', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [删除图片补位到下个视频播放] TID: Multimedia_Gallery_Dynamic_Photo_Export_0061
      await Multimedia_Gallery_Dynamic_Photo_Export_0061(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_076', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [遍历不同格式视频，进大图点击播放] TID: Multimedia_Gallery_PhotoBrowser_076
      await Multimedia_Gallery_PhotoBrowser_076(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [视频播放过程中，上划/下拉视频/左右滑动] TID: Multimedia_Gallery_VideoPlayer_02
      await Multimedia_Gallery_VideoPlayer_02(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_03', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-横竖屏用例: [视频播放过程中，横竖屏切换] TID: Multimedia_Gallery_VideoPlayer_03
      await Multimedia_Gallery_VideoPlayer_03(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_121', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [视频播放过程中锁屏或者退后台] TID: Multimedia_Gallery_VideoPlayer_Frame_121
      await Multimedia_Gallery_VideoPlayer_Frame_121(dt);
    });
    run('TC_Video_VDEC_ContainerFormat_0101', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-解析用例: [验证可以正常解析扩展名为mp4的媒体文件] TID: TC_Video_VDEC_ContainerFormat_0101
      await TC_Video_VDEC_ContainerFormat_0101(dt);
    });
    run('TC_Video_VDEC_Play_Compability_0101', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [验证H264编码格式的视频解码正常] TID: TC_Video_VDEC_Play_Compability_0101
      await TC_Video_VDEC_Play_Compability_0101(dt);
    });
    run('Multimedia_Gallery_Cloud_20240115001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云下行中/下行完毕/上行中，选择视频播放] TID: Multimedia_Gallery_Cloud_20240115001
      await Multimedia_Gallery_Cloud_20240115001(dt);
    });
    run('Multimedia_Gallery_Cloud_20240115002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云上行中，选择视频播放] TID: Multimedia_Gallery_Cloud_20240115002
      await Multimedia_Gallery_Cloud_20240115002(dt);
    });

    /**
     run('Multimedia_Gallery_SR20240327153237_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
     //  大图-下载用例: [云端下载视频截图] TID: Multimedia_Gallery_SR20240327153237_006
     await Multimedia_Gallery_SR20240327153237_006(dt);
     });
     */

    run('Multimedia_Gallery_SR20240327153237_023', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册视频截图] TID: Multimedia_Gallery_SR20240327153237_023
      await Multimedia_Gallery_SR20240327153237_023(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [不同入口打开大图界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_001
      await Multimedia_Gallery_VideoPlayer_Frame_001(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同入口打开动态图片界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_002
      await Multimedia_Gallery_VideoPlayer_Frame_002(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_063', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [相机进视频播放，进度条高度无异常] TID: Multimedia_Gallery_VideoPlayer_Frame_063
      await Multimedia_Gallery_VideoPlayer_Frame_063(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_064', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [相机进视频播放，调节进度条] TID: Multimedia_Gallery_VideoPlayer_Frame_064
      await Multimedia_Gallery_VideoPlayer_Frame_064(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_030', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [视频播放过程中调节进度条] TID: Multimedia_Gallery_VideoPlayer_Frame_030
      await Multimedia_Gallery_VideoPlayer_Frame_030(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachVideoOperateTest').init();
      let res = await dt.assertClick('PhotoBrowserActionBarButtonBack');
      if (!res) {
        // 唤起顶部组件
        await dt.driver.click(700, 500);
        await dt.sleep(DELAY.short);
        await dt.assertClick('PhotoBrowserActionBarButtonBack');
      }
      await dt.sleep(DELAY.short);
      await dt.assertClick('photoGridView_gird_0');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach VideoOperateTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoOperateTest').init();
      await Exit.browser();
      dt.log.i('afterAll VideoOperateTest finish');
    });
  });
}

/**
 * 大图-删除: [删除图片补位到下个视频播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_Dynamic_Photo_Export_0061
 * 前置条件
 * 图库存在多个视频和图片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_0061(dt: Dt) {
  dt.log.i('删除图片补位到下个视频播放 start');
  dt.log.i('STEP 1、宫格入口打开一个视频点击播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滑动到前一张图片，删除该张图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片删除成功，补位到视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除图片补位到下个视频播放 end');
}

/**
 * 大图-格式: [遍历不同格式视频，进大图点击播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_PhotoBrowser_076
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_076(dt: Dt) {
  dt.log.i('遍历不同格式视频，进大图点击播放 start');
  dt.log.i('STEP 1 点击图库进入照片页，进入所有格式视频，点击播放');

  await dt.sleep();
  dt.log.i('预期结果1.点击播放时跳转至视频界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2 视频播放时back到图库大图界面');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常退出，包括声音自动退出，图库大图界面正常显示视频封面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3. 视频播放时将图库切换到后台或息屏');

  await dt.sleep();
  dt.log.i('预期结果3. 视频播放暂停');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('遍历不同格式视频，进大图点击播放 end');
}

/**
 * 大图-滑动: [视频播放过程中，上划/下拉视频/左右滑动]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_02
 * 前置条件
 * 图库中存在不同格式的图片和视频
 */
async function Multimedia_Gallery_VideoPlayer_02(dt: Dt) {
  dt.log.i('视频播放过程中，上划/下拉视频/左右滑动 start');
  dt.log.i('STEP 1、点击播放按钮，视频开始播放，上划视频');
  await playVideo(dt);
  await dt.swipeScreen?.top();
  await dt.sleep();
  dt.log.i('预期结果1、页面上移，视频正常播放，不受上滑影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击播放按钮，视频开始播放，下拉视频');
  await dt.swipeScreen?.bottom();
  await dt.swipeScreen?.bottom();
  await dt.sleep();
  dt.log.i('预期结果2、视频播放中支持下拉返回，返回视频宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击播放按钮，视频开始播放，左滑或右滑切换上/下一张图片/视频');
  await dt.assertClick('photoGridView_gird_0');
  await dt.sleep(DELAY.short);
  await playVideo(dt);
  await dt.swipeScreen?.left();
  await playVideo(dt);
  await dt.swipeScreen?.right();
  await dt.sleep();
  dt.log.i('预期结果3、滑动后视频暂停播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放过程中，上划/下拉视频/左右滑动 end');
}

/**
 * 大图-横竖屏: [视频播放过程中，横竖屏切换]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_03
 * 前置条件
 * 图库中存在不同格式的图片和视频，系统旋转打开
 */
async function Multimedia_Gallery_VideoPlayer_03(dt: Dt) {
  dt.log.i('视频播放过程中，横竖屏切换 start');
  dt.log.i('STEP 1.1 视频竖屏开始播放，手动转动手机横屏查看1.2 视频横屏开始播放，手动将手机旋转为竖屏查看');
  await playVideo(dt);
  await dt.rotate(DisplayRotation.ROTATION_90);
  await dt.sleep();
  dt.log.i('预期结果1、2 视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1 视频竖屏开始播放，点击下方切换横竖屏按钮2.2 视频横屏开始播放，点击右上角切换横竖屏按钮');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  await dt.rotate(DisplayRotation.ROTATION_0);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放过程中，横竖屏切换 end');
}

/**
 * 大图-锁屏: [视频播放过程中锁屏或者退后台]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_121
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_121(dt: Dt) {
  dt.log.i('视频播放过程中锁屏或者退后台 start');
  dt.log.i('STEP 1、相机入口进入大图，播放长视频（至少3分以上）');

  await dt.sleep();
  dt.log.i('STEP 2、播放过程中，上滑到home桌面 30秒中；锁屏30秒');

  await dt.sleep();
  dt.log.i('预期结果2、home到桌面以及锁屏期间，视频声音不播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、亮屏回到相机界面，查看视频播放');

  await dt.sleep();
  dt.log.i('预期结果3、回到相机界面，停留在山慈视频播放界面，视频进度条未继续走动，视频处于暂停状态； 再次点击播放正常继续接续播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、图库任意界面播放视频，按照步骤2 3 重复一次');

  await dt.sleep();
  dt.log.i('预期结果4、图库界面表现和相机界面一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放过程中锁屏或者退后台 end');
}

/**
 * 大图-解析: [验证可以正常解析扩展名为mp4的媒体文件]
 * TAG: 视频播放 TID: TC_Video_VDEC_ContainerFormat_0101
 * 前置条件
 * 1、将PC侧资源push到手机Videos文件夹下；
 */
async function TC_Video_VDEC_ContainerFormat_0101(dt: Dt) {
  dt.log.i('验证可以正常解析扩展名为mp4的媒体文件 start');
  dt.log.i('STEP 1、进入图库，点击文件进行播放；');

  await dt.sleep();
  dt.log.i('STEP 2、退出图库应用；');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证可以正常解析扩展名为mp4的媒体文件 end');
}

/**
 * 大图-格式: [验证H264编码格式的视频解码正常]
 * TAG: 视频播放 TID: TC_Video_VDEC_Play_Compability_0101
 * 前置条件
 *  1、将PC侧资源push到手机media文件夹下；
 */
async function TC_Video_VDEC_Play_Compability_0101(dt: Dt) {
  dt.log.i('验证H264编码格式的视频解码正常 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证H264编码格式的视频解码正常 end');
}

/**
 * 大图-端云: [端云下行中/下行完毕/上行中，选择视频播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_Cloud_20240115001
 * 前置条件
 * 1、网络正常
 2、登录云账号
 */
async function Multimedia_Gallery_Cloud_20240115001(dt: Dt) {
  dt.log.i('端云下行中/下行完毕/上行中，选择视频播放 start');
  dt.log.i('STEP 1、点击开启同步，同步下行中，连续多次选择视频进行播放');

  await dt.sleep();
  dt.log.i('预期结果1、播放完整顺畅，有声音，声音和画面同步播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、同步下行中，选择视频播放到一半停止后继续点击播放');

  await dt.sleep();
  dt.log.i('预期结果2、停止后不能播放了，再次点击播放是续播正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、同步完毕后，连续多次选择视频进行播放');

  await dt.sleep();
  dt.log.i('预期结果3、播放完整顺畅，有声音，声音和画面同步播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、同步下行完毕后，选择视频播放到一半停止后继续点击播放');

  await dt.sleep();
  dt.log.i('预期结果4、停止后不能播放了，再次点击播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、关闭云同步，本地拍摄图片，点击开启同步，同步上行中，连续10次选择视频进行播放');

  await dt.sleep();
  dt.log.i('预期结果5、播放完整顺畅，有声音，声音和画面同步播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、同步上行中，选择视频播放到一半停止后继续点击播放');

  await dt.sleep();
  dt.log.i('预期结果6、停止后不能播放了，再次点击播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云下行中/下行完毕/上行中，选择视频播放 end');
}

/**
 * 大图-端云: [端云上行中，选择视频播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_Cloud_20240115002
 * 前置条件
 * 1、网络正常
 2、登录云账号(云账号上有图片1W和视频50个)
 */
async function Multimedia_Gallery_Cloud_20240115002(dt: Dt) {
  dt.log.i('端云上行中，选择视频播放 start');
  dt.log.i('STEP 1、点击开启同步，同步下行中，连续10次选择视频进行播放');

  await dt.sleep();
  dt.log.i('预期结果1、播放完整顺畅，有声音，声音和画面同步播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、同步下行中，选择视频播放到一半停止后继续点击播放');

  await dt.sleep();
  dt.log.i('预期结果2、停止后不能播放了，再次点击播放是续播正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云上行中，选择视频播放 end');
}

/**
 * 大图-下载: [云端下载视频截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_006
 * 前置条件
 * 1、存在云端视频
 */
async function Multimedia_Gallery_SR20240327153237_006(dt: Dt) {
  dt.log.i('云端下载视频截图 start');
  dt.log.i('STEP 1、云端的视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮（遍历未播放、暂停、播放状态）');

  await dt.sleep();
  dt.log.i('预期结果2、弹出截图窗口，提示“已保存至截图相册”，截图封面/当前图片/暂停图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端下载视频截图 end');
}

/**
 * 大图-删除: [最近删除相册视频截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_023
 * 前置条件
 * 1、最近删除相册存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_023(dt: Dt) {
  dt.log.i('最近删除相册视频截图 start');
  dt.log.i('STEP 1、进入最近删除相册的视频大图浏览');

  await dt.sleep();
  dt.log.i('预期结果1、最近删除相册不支持视频截图功能');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册视频截图 end');
}

/**
 * 大图-大图: [不同入口打开大图界面显示]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_001
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_001(dt: Dt) {
  dt.log.i('不同入口打开大图界面显示 start');
  dt.log.i('STEP 1、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果1、底部tab依次显示分享，收藏，编辑，删除按钮，右上角显示四方菜单按钮和云增强按钮（tab下无文字）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从隐藏相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果2、底部tab依次显示收藏，编辑，删除，右上角显示四方菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从最近删除相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果3、底部tab依次显示复原，收藏，右上角显示四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、相机入口进入查看大图');

  await dt.sleep();
  dt.log.i('预期结果4、底部tab依次显示分享，收藏，编辑，删除按钮，右上角显示四方菜单按钮和图库入口图标');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、锁屏相机入口进大图');

  await dt.sleep();
  dt.log.i('预期结果5、同相机入口显示一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口打开大图界面显示 end');
}

/**
 * 大图-动态照片: [不同入口打开动态图片界面显示]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_002
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_002(dt: Dt) {
  dt.log.i('不同入口打开动态图片界面显示 start');
  dt.log.i('STEP 1、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看动态图片，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果1、底部tab依次分享，收藏，动态照片图标，编辑，删除按钮，右上角显示四方菜单按钮和云增强按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从隐藏相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果2、底部tab依次显示收藏，动态照片图标，编辑，删除，右上角显示四方菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从最近删除相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果3、底部tab依次显示复原，动态照片图标，删除，右上角显示四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、相机入口进大图');

  await dt.sleep();
  dt.log.i('预期结果4、底部tab依次显示分享，收藏，动态照片图标，编辑，删除按钮，右上角显示四方菜单按钮和图库入口图标');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、锁屏相机入口进大图');

  await dt.sleep();
  dt.log.i('预期结果5、同相机入口显示一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口打开动态图片界面显示 end');
}

/**
 * 大图-进度条: [相机进视频播放，进度条高度无异常]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_063
 * 前置条件
 * 1、相机拍摄一段视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_063(dt: Dt) {
  dt.log.i('相机进视频播放，进度条高度无异常 start');
  dt.log.i('STEP 1、相机已拍摄一段视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击缩略图进入视频大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击播放，观察进度条');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，进度条高度显示无异常（参考图库视频播放进度条高度）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机进视频播放，进度条高度无异常 end');
}

/**
 * 大图-进度条: [相机进视频播放，调节进度条]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_064
 * 前置条件
 * 1、相机拍摄一段视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_064(dt: Dt) {
  dt.log.i('相机进视频播放，调节进度条 start');
  dt.log.i('STEP 1、相机已拍摄一段视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击缩略图进入视频大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击视频播放，拖动进度条');

  await dt.sleep();
  dt.log.i('预期结果3、视频画面随手动拖动变化而变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、拖动进度条到指定位置');

  await dt.sleep();
  dt.log.i('预期结果4、视频封面变化至指定位置画面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机进视频播放，调节进度条 end');
}

/**
 * 大图-进度条: [视频播放过程中调节进度条]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_030
 * 前置条件
 * 1、图库存在本地视频和端云视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_030(dt: Dt) {
  dt.log.i('视频播放过程中调节进度条 start');
  dt.log.i('STEP 1、本地视频播放过程中，展开缩略图后调节进度条');

  await dt.sleep();
  dt.log.i('预期结果1、进度条原地不动，缩略图随着调节进度刷新，大图随调节进度刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、本地视频暂停过程中，展开缩略图后调节进度条');

  await dt.sleep();
  dt.log.i('预期结果2、进度条原地不动，缩略图随着调节进度刷新，大图随调节进度刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、端云视频播放过程中，展开缩略图后调节进度条');

  await dt.sleep();
  dt.log.i('预期结果3、进度条原地不动，缩略图随着调节进度刷新，大图随调节进度刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、端云视频暂停过程中，展开缩略图后调节进度条');

  await dt.sleep();
  dt.log.i('预期结果4、进度条原地不动，缩略图随着调节进度刷新，大图随调节进度刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放过程中调节进度条 end');
}

async function deleteItem(dt: Dt): Promise<void> {
  await dt.assertClick(dt.button.delete());
  await dt.sleep(DELAY.short);
  await dt.assertComponentByText('删除');
  const button = await dt.driver.findComponent(ON.text('删除'));
  await button.click();
  await dt.sleep();
}

async function playVideo(dt: Dt): Promise<void> {
  await dt.assertClick('VideoPlayButton');
  await dt.sleep();
}
