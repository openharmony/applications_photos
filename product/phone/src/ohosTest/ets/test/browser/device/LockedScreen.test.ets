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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
// 补充完成后修改为 run as it
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { Component, Driver, MatchPattern, On, ON } from '@ohos.UiTest';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 */
export default function LockedScreenTest(): void {
  describe('LockedScreenTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllLockedScreenTest').init();
      dt.log.i('beforeAll LockedScreenTest start');
      dt.log.i('beforeAll LockedScreenTest finish');
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_05', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图删除图片/视频] TID: Multimedia_Gallery_LockScreenCamera_Picture_05
      await Multimedia_Gallery_LockScreenCamera_Picture_05(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [无锁屏密码-锁屏相机进缩略图] TID: Multimedia_Gallery_LockScreenCamera_Picture_01
      await Multimedia_Gallery_LockScreenCamera_Picture_01(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_04', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图收藏图片/视频] TID: Multimedia_Gallery_LockScreenCamera_Picture_04
      await Multimedia_Gallery_LockScreenCamera_Picture_04(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进缩略图] TID: Multimedia_Gallery_LockScreenCamera_Picture_02
      await Multimedia_Gallery_LockScreenCamera_Picture_02(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_03', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图浏览未解锁] TID: Multimedia_Gallery_LockScreenCamera_Picture_03
      await Multimedia_Gallery_LockScreenCamera_Picture_03(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_06', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图浏览解锁] TID: Multimedia_Gallery_LockScreenCamera_Picture_06
      await Multimedia_Gallery_LockScreenCamera_Picture_06(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_07', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图删除图片/视频 Copy of (1)] TID: Multimedia_Gallery_LockScreenCamera_Picture_07
      await Multimedia_Gallery_LockScreenCamera_Picture_07(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_09', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [有锁屏密码-锁屏相机进大图浏览解锁 Copy of (1)] TID: Multimedia_Gallery_LockScreenCamera_Picture_09
      await Multimedia_Gallery_LockScreenCamera_Picture_09(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_08', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [无锁屏密码-锁屏相机进缩略图 Copy of (1)] TID: Multimedia_Gallery_LockScreenCamera_Picture_08
      await Multimedia_Gallery_LockScreenCamera_Picture_08(dt);
    });
    run('Multimedia_Gallery_LockScreenCamera_Picture_099', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [锁屏界面，拍10张图片，点击一张进编辑，保存后返回大图浏览] TID: Multimedia_Gallery_LockScreenCamera_Picture_099
      await Multimedia_Gallery_LockScreenCamera_Picture_099(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachLockedScreenTest').init();
      dt.log.i('afterEach LockedScreenTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLockedScreenTest').init();
      await Exit.browser();
      dt.log.i('afterAll LockedScreenTest finish');
    });
  });
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图删除图片/视频]
 * TAG: 208 TID: Multimedia_Gallery_LockScreenCamera_Picture_05
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_05(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图删除图片/视频 start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图界面删除按钮');

  await dt.sleep();
  dt.log.i('预期结果2、出现删除确认弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消');

  await dt.sleep();
  dt.log.i('预期结果3、删除弹窗消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次点击删除按钮');

  await dt.sleep();
  dt.log.i('预期结果4、出现删除确认弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击确定');

  await dt.sleep();
  dt.log.i('预期结果5、大图删除，界面显示“没有照片和视频”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('没有照片和视频', true);
  dt.log.i('STEP 6、返入锁屏相机，连续拍摄多张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果6.1、缩略图显示为空6.2、连续拍照左下角空缩略图拍照后刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、大图界面点击删除按钮，点击确定');

  await dt.sleep();
  dt.log.i('预期结果7、出现删除弹窗，大图删除动效符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、进入图库相册页点击最近删除相册查看');

  await dt.sleep();
  dt.log.i('预期结果8、图库最近删除相册存在删除大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果9、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图删除图片/视频 end');
}

/**
 * 大图-锁屏: [无锁屏密码-锁屏相机进缩略图]
 * TAG: 209 TID: Multimedia_Gallery_LockScreenCamera_Picture_01
 * 前置条件
 * 1、手机不设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_01(dt: Dt) {
  dt.log.i('无锁屏密码-锁屏相机进缩略图 start');
  dt.log.i('STEP 1、进入锁屏相机，查看并点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、正常进入大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、拍摄一张照片或者视频');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄成功，缩略图刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果3、进入大图界面，照片/视频正常显示/播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图左右滑动，底部预览条滑动');

  await dt.sleep();
  dt.log.i('预期结果4、大图左右滑动流畅，底部预览条滑动流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图上滑详情页，点击备注和名字输入内容，点击地图卡片导航入口');

  await dt.sleep();
  dt.log.i('预期结果5、上滑显示详情页5.1、备注和名字可以修改5.2、点击地图卡片位置跳转到导航');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、依次操作分享、收藏、编辑、删除按钮，进入顶部右上角显示的图库入口图标和跟多按钮');

  await dt.sleep();
  dt.log.i('预期结果6、分享、收藏、编辑、删除可正常进行操作，顶部右上角图库图标进入，更多按钮出现');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击更多按钮下拉的添加到按钮、隐藏按钮、详细信息');

  await dt.sleep();
  dt.log.i('预期结果7.1、点击添加到页面正常跳转到添加到页面7.2、点击隐藏按钮大图正常隐藏7.3、点击详细信息，详情页正常出现');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果8、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无锁屏密码-锁屏相机进缩略图 end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图收藏图片/视频]
 * TAG: 210 TID: Multimedia_Gallery_LockScreenCamera_Picture_04
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_04(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图收藏图片/视频 start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图界面收藏按钮');

  await dt.sleep();
  dt.log.i('预期结果2、大图页底部收藏按钮显示蓝色，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库相册页点击收藏相册查看');

  await dt.sleep();
  dt.log.i('预期结果3、图库收藏相册显示收藏的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图收藏图片/视频 end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进缩略图]
 * TAG: 211 TID: Multimedia_Gallery_LockScreenCamera_Picture_02
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库不存在照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_02(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进缩略图 start');
  dt.log.i('STEP 1、进入锁屏相机，查看并点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、缩略图为空，点击后跳转提示界面“没有照片和视频”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('没有照片和视频');
  dt.log.i('STEP 2、拍摄一张照片或者视频');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄成功，缩略图刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果3、进入大图界面，照片/视频正常显示/播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看菜单');

  await dt.sleep();
  dt.log.i('预期结果4、菜单依次显示分享、收藏、编辑、删除按钮，顶部右上角显示的图库入口图标和更多按钮');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、锁屏后再亮屏，再次打开锁屏相机，点击缩略图');

  await dt.sleep();
  dt.log.i('预期结果5.1亮屏后进入锁屏界面5.2缩略图为空，点击后跳转提示界面“没有照片和视频”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('没有照片和视频', true);
  dt.log.i('STEP 6、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果6、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进缩略图 end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图浏览未解锁]
 * TAG: 212 TID: Multimedia_Gallery_LockScreenCamera_Picture_03
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_03(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图浏览未解锁 start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片或者视频');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击左下角缩略图，左右滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果2、进入大图界面，无法左右滑动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、大图返回相机，连续拍摄多张照片或者视频');

  await dt.sleep();
  dt.log.i('预期结果3、返回锁屏相机');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击左下角缩略图进入大图，左右滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果4、进入大图界面，左右滑动只能浏览本次锁屏相机所拍摄的内容');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、在大图界面进行点击分享、编辑，顶部右上角图库图标按钮和更多按钮');

  await dt.sleep();
  dt.log.i('预期结果5、点击分享/编辑/顶部右上角图库图标/更多按钮拉起解锁弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、解锁界面点击返回按钮');

  await dt.sleep();
  dt.log.i('预期结果6、返回大图界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、大图上滑详情，点击备注和名字输入内容，点击地图卡片导航入口');

  await dt.sleep();
  dt.log.i('预期结果7.1上滑出现详情内容7.2、点击备注、名字输入框、地图卡片导航入口拉起解锁弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、查看有AI控件的大图');

  await dt.sleep();
  dt.log.i('预期结果8、安全相机屏蔽AI控件');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果9、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图浏览未解锁 end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图浏览解锁]
 * TAG: 213 TID: Multimedia_Gallery_LockScreenCamera_Picture_06
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_06(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图浏览解锁 start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图界面进行点击分享/编辑/顶部右上角图库图标按钮/更多/大图上滑详情，点击备注和名字输入内容/点击地图卡片导航入口');

  await dt.sleep();
  dt.log.i('预期结果2、出现解锁界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在解锁界面输入密码');

  await dt.sleep();
  dt.log.i('预期结果3、解锁后返回大图界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在大图界面进行点击分享/编辑/顶部右上角图库图标按钮/更多/大图上滑详情，点击备注和名字输入内容/点击地图卡片导航入口');

  await dt.sleep();
  dt.log.i('预期结果4、大图页面所有图片资源刷新，可以正常操作分享/编辑/顶部右上角图库图标按钮/更多/大图上滑详情，点击备注和名字输入内容/点击地图卡片导航入口界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左右滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果5、大图左右滑动流畅，底部预览条滑动流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果6、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图浏览解锁 end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图删除图片/视频 Copy of (1)]
 * TAG: 214 TID: Multimedia_Gallery_LockScreenCamera_Picture_07
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_07(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图删除图片/视频 Copy of (1) start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享/编辑等操作，输入锁屏密码');

  await dt.sleep();
  dt.log.i('预期结果2、进入解锁界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在大图界面删除按钮');

  await dt.sleep();
  dt.log.i('预期结果3、出现删除确认弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击取消');

  await dt.sleep();
  dt.log.i('预期结果4、删除弹窗消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、再次点击删除按钮');

  await dt.sleep();
  dt.log.i('预期结果5、出现删除确认弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击确定');

  await dt.sleep();
  dt.log.i('预期结果6、大图删除');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、大图界面点击删除按钮，点击确定');

  await dt.sleep();
  dt.log.i('预期结果7、自动跳转到下一张');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、进入图库相册页点击最近删除相册查看');

  await dt.sleep();
  dt.log.i('预期结果8、图库最近删除相册存在删除大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果9、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图删除图片/视频 Copy of (1) end');
}

/**
 * 大图-锁屏: [有锁屏密码-锁屏相机进大图浏览解锁 Copy of (1)]
 * TAG: 215 TID: Multimedia_Gallery_LockScreenCamera_Picture_09
 * 前置条件
 * 1、手机设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_09(dt: Dt) {
  dt.log.i('有锁屏密码-锁屏相机进大图浏览解锁 Copy of (1) start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享/编辑等操作，输入锁屏密码');

  await dt.sleep();
  dt.log.i('预期结果2、进入解锁界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、依次点击分享、收藏、编辑、删除');

  await dt.sleep();
  dt.log.i('预期结果3.1正常拉起分享页面3.2当前大图可正常收藏3.3当前大图可正常编辑3.4当前大图可以正常删除');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果4、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有锁屏密码-锁屏相机进大图浏览解锁 Copy of (1) end');
}

/**
 * 大图-锁屏: [无锁屏密码-锁屏相机进缩略图 Copy of (1)]
 * TAG: 216 TID: Multimedia_Gallery_LockScreenCamera_Picture_08
 * 前置条件
 * 1、手机不设置密码
 2、手机置于锁屏界面
 3、图库存在历史照片和视频
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_08(dt: Dt) {
  dt.log.i('无锁屏密码-锁屏相机进缩略图 Copy of (1) start');
  dt.log.i('STEP 1、进入锁屏相机，拍摄一张照片/视频，点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、左下角空缩略图拍照后刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享/编辑等操作，输入锁屏密码');

  await dt.sleep();
  dt.log.i('预期结果2、进入解锁界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在大图界面点击右上角更多按钮');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示设置壁纸、移动到、隐藏、详细信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、依次点击设置壁纸、移动到、隐藏、详细信息');

  await dt.sleep();
  dt.log.i('预期结果4.1当前大图可正常设置为壁纸4.2当前大图可正常移动到目标相册4.3当前大图可正常隐藏/取消隐藏4.4显示当前大图详情信息页');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、横竖屏切换重复以上动作（默认手机、xxxxxx和xxx、pad）');

  await dt.sleep();
  dt.log.i('预期结果5、横竖屏切换动效正常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无锁屏密码-锁屏相机进缩略图 Copy of (1) end');
}

/**
 * 大图-锁屏: [锁屏界面，拍10张图片，点击一张进编辑，保存后返回大图浏览]
 * TAG: 217 TID: Multimedia_Gallery_LockScreenCamera_Picture_099
 * 前置条件
 * 1、手机无锁屏密码
 */
async function Multimedia_Gallery_LockScreenCamera_Picture_099(dt: Dt) {
  dt.log.i('锁屏界面，拍10张图片，点击一张进编辑，保存后返回大图浏览 start');
  dt.log.i('STEP 1、锁屏状态下进入相机拍照，拍10张');

  await dt.sleep();
  dt.log.i('STEP 2、进入大图后点击进入编辑 ，裁剪后另存为');

  await dt.sleep();
  dt.log.i('STEP 3、大图界面左右滑动');

  await dt.sleep();
  dt.log.i('预期结果3、大图滑动流畅自然，无用户主观认为的卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('锁屏界面，拍10张图片，点击一张进编辑，保存后返回大图浏览 end');
}

