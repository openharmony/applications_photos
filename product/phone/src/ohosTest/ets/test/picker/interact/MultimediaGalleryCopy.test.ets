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

export default function MultimediaGalleryCopy(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryCopyTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryCopy').init();
      dt.log.i('beforeAll MultimediaGalleryCopy start');
      dt.log.i('beforeAll MultimediaGalleryCopy finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryCopy', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryCopy005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [复制一张图片后，不进行粘贴，再次复制另一个视频进行粘贴] TID: Multimedia_Gallery_Copy_005
      await multimediaGalleryCopy005(dt);
    });
    run('MultimediaGalleryCopy006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [复制文件后，关闭图库应用再粘贴] TID: Multimedia_Gallery_Copy_006
      await multimediaGalleryCopy006(dt);
    });
    run('MultimediaGalleryCopy007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [复制大量文件（500张以上），提示“超过复制图片数量上限，复制失败”] TID: Multimedia_Gallery_Copy_007
      await multimediaGalleryCopy007(dt);
    });
    run('MultimediaGalleryCopy008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [复制多张云端照片到剪贴板] TID: Multimedia_Gallery_Copy_008
      await multimediaGalleryCopy008(dt);
    });
    run('MultimediaGalleryCopy009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [复制单张云端照片到剪贴板] TID: Multimedia_Gallery_Copy_009
      await multimediaGalleryCopy009(dt);
    });
    run('MultimediaGallerycoverreplace001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻首页封面更换] TID: Multimedia_Gallery_cover_replace_001
      await multimediaGallerycoverreplace001(dt);
    });
    run('MultimediaGallerycoverreplace0011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面更换的时效] TID: Multimedia_Gallery_cover_replace_0011
      await multimediaGallerycoverreplace0011(dt);
    });
    run('MultimediaGallerycoverreplace0012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [更换封面后克隆测试] TID: Multimedia_Gallery_cover_replace_0012
      await multimediaGallerycoverreplace0012(dt);
    });
    run('MultimediaGallerycoverreplace002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻宫格右上角设置菜单更换封面] TID: Multimedia_Gallery_cover_replace_002
      await multimediaGallerycoverreplace002(dt);
    });
    run('MultimediaGallerycoverreplace003', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [宫格界面长按单个照片设置封面] TID: Multimedia_Gallery_cover_replace_003
      await multimediaGallerycoverreplace003(dt);
    });
    run('MultimediaGallerycoverreplace004', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图右上角设置为封面] TID: Multimedia_Gallery_cover_replace_004
      await multimediaGallerycoverreplace004(dt);
    });
    run('MultimediaGallerycoverreplace005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [更换封面后副标题时间刷新] TID: Multimedia_Gallery_cover_replace_005
      await multimediaGallerycoverreplace005(dt);
    });
    run('MultimediaGallerycoverreplace006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [更换不同时刻封面] TID: Multimedia_Gallery_cover_replace_006
      await multimediaGallerycoverreplace006(dt);
    });
    run('MultimediaGallerycoverreplace007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [更换封面后布局效果] TID: Multimedia_Gallery_cover_replace_007
      await multimediaGallerycoverreplace007(dt);
    });
    run('MultimediaGallerycoverreplace008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [适老化、深色模式、无障碍、横竖屏、全球化、大字体下更换封面后查看布局] TID: Multimedia_Gallery_cover_replace_008
      await multimediaGallerycoverreplace008(dt);
    });
    run('MultimediaGallerycoverreplace009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [多次更换时刻封面] TID: Multimedia_Gallery_cover_replace_009
      await multimediaGallerycoverreplace009(dt);
    });
    run('MultimediaGalleryCVlcdstorage001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-下载用例: [LCD图下载小于90%限制解除，不打印LCD图片生成小于90%不启动相关日志] TID: Multimedia_Gallery_CV_lcd_storage_001
      await multimediaGalleryCVlcdstorage001(dt);
    });
    run('MultimediaGalleryCVlcdstorage002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-下载用例: [LCD图下载小于90%断网，智慧分析继续可以生成时刻] TID: Multimedia_Gallery_CV_lcd_storage_002
      await multimediaGalleryCVlcdstorage002(dt);
    });
    run('MultimediaGalleryCVlcdstorage003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [Rom空间小于10%中断+清除后继续分析+大于10%可正常CV分析] TID: Multimedia_Gallery_CV_lcd_storage_003
      await multimediaGalleryCVlcdstorage003(dt);
    });
    run('MultimediaGalleryCVlcdstorage004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [Rom空间小于10%中断cv分析] TID: Multimedia_Gallery_CV_lcd_storage_004
      await multimediaGalleryCVlcdstorage004(dt);
    });
    run('MultimediaGalleryCVlcdstorage005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [Rom空间小于10%清除后继续分析] TID: Multimedia_Gallery_CV_lcd_storage_005
      await multimediaGalleryCVlcdstorage005(dt);
    });
    run('MultimediaGalleryCVlcdstorage006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [Rom空间小于10%稳定性验证] TID: Multimedia_Gallery_CV_lcd_storage_006
      await multimediaGalleryCVlcdstorage006(dt);
    });
    run('MultimediaGalleryCVlcdstorage007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [1k资源首个时刻生成时延] TID: Multimedia_Gallery_CV_lcd_storage_007
      await multimediaGalleryCVlcdstorage007(dt);
    });
    run('MultimediaGalleryCyclicOptimization001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务1K模型首个时刻生成的时长] TID: Multimedia_Gallery_CyclicOptimization_001
      await multimediaGalleryCyclicOptimization001(dt);
    });
    run('MultimediaGalleryCyclicOptimization002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [精彩时刻生成流程优化_3k图集(手机-通用)] TID: Multimedia_Gallery_CyclicOptimization_002
      await multimediaGalleryCyclicOptimization002(dt);
    });
    run('MultimediaGalleryCyclicOptimization003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [精彩时刻生成流程优化_5k图集(手机-通用)] TID: Multimedia_Gallery_CyclicOptimization_003
      await multimediaGalleryCyclicOptimization003(dt);
    });
    run('MultimediaGalleryCyclicOptimization004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [精彩时刻生成流程优化_2w图集(手机-通用)] TID: Multimedia_Gallery_CyclicOptimization_004
      await multimediaGalleryCyclicOptimization004(dt);
    });
    run('MultimediaGalleryDarkMode001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库照片宫格页深色模式适配] TID: Multimedia_Gallery_DarkMode_001
      await multimediaGalleryDarkMode001(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryCopy').init();
      dt.log.i('afterEach MultimediaGalleryCopy start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryCopy finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryCopy').init();
      dt.log.i('afterAll MultimediaGalleryCopy start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryCopy finish');
    });
  });
}

// DT步骤
/**
 * 宫格-视频: [复制一张图片后，不进行粘贴，再次复制另一个视频进行粘贴]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Copy_005
 * 前置条件
 * 1、图库中存在不同格式的图片、视频
 */
async function multimediaGalleryCopy005(dt: Dt) {
  dt.log.i('复制一张图片后，不进行粘贴，再次复制另一个视频进行粘贴 start');
  dt.log.i('STEP 1、打开图库应用，进入照片页');

  await dt.sleep();
  dt.log.i('STEP 2、点击更多，选择一张图片，点击更多——复制');

  await dt.sleep();
  dt.log.i('预期结果2/3、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）4、视频成功粘贴，视频正确显示，不显示图片5、视频成功粘贴，视频正确显示，不显示图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、不进行粘贴，再进入视频页后，点击更多，选择一个视频，点击更多——复制');

  await dt.sleep();
  dt.log.i('STEP 4、打开PC文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果4、视频成功粘贴，视频正确显示，不显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果5、视频成功粘贴，视频正确显示，不显示图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制一张图片后，不进行粘贴，再次复制另一个视频进行粘贴 end');
}

/**
 * 宫格-格式: [复制文件后，关闭图库应用再粘贴]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Copy_006
 * 前置条件
 * 1、图库中存在不同格式的图片、视频
 */
async function multimediaGalleryCopy006(dt: Dt) {
  dt.log.i('复制文件后，关闭图库应用再粘贴 start');
  dt.log.i('STEP 1、打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、点击更多，选择一张图片，点击更多——复制');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）4、图片粘贴成功，正确显示图片5、图片粘贴成功，正确显示图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、关闭图库应用');

  await dt.sleep();
  dt.log.i('STEP 4、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果4、图片粘贴成功，正确显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果5、图片粘贴成功，正确显示图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制文件后，关闭图库应用再粘贴 end');
}

/**
 * 宫格-视频: [复制大量文件（500张以上），提示“超过复制图片数量上限，复制失败”]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Copy_007
 * 前置条件
 * 1、图库中大量图片和视频（500张以上）
 */
async function multimediaGalleryCopy007(dt: Dt) {
  dt.log.i('复制大量文件（500张以上），提示“超过复制图片数量上限，复制失败” start');
  dt.log.i('STEP 1、打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、选择一张图片-点击“多选”-点击“全选”');

  await dt.sleep();
  dt.log.i('STEP 3、点击“更多”（或右击图片）-点击“复制”');

  await dt.sleep();
  dt.log.i('预期结果3、复制失败，出现“超过复制图片数量上限，复制失败”提示');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('超过复制图片数量上限，复制失败'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制大量文件（500张以上），提示“超过复制图片数量上限，复制失败” end');
}

/**
 * 宫格-视频: [复制多张云端照片到剪贴板]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Copy_008
 * 前置条件
 * 1、测试机和辅助机登陆同一云账号，开启图库云同步
 2、辅助机有已经同步到云端的照片
 3、手机已连接WLAN
 */
async function multimediaGalleryCopy008(dt: Dt) {
  dt.log.i('复制多张云端照片到剪贴板 start');
  dt.log.i('STEP 1、测试机同步云端照片，打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、点击更多-点击“多选”-选择多张照片-点击“更多”（或右击图片）-点击“复制”');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果4、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制多张云端照片到剪贴板 end');
}

/**
 * 宫格-视频: [复制单张云端照片到剪贴板]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Copy_009
 * 前置条件
 * 1、测试机和辅助机登陆同一云账号，开启图库云同步
 2、辅助机有已经同步到云端的照片
 3、手机已连接WLAN
 */
async function multimediaGalleryCopy009(dt: Dt) {
  dt.log.i('复制单张云端照片到剪贴板 start');
  dt.log.i('STEP 1、测试机同步云端照片，打开图库应用，进入照片页/预制相册');

  await dt.sleep();
  dt.log.i('STEP 2、大图模式或点击多选，选择一张照片，点击“更多”（鼠标右击图片），点击“复制”');

  await dt.sleep();
  dt.log.i('预期结果2、出现“复制成功”提示，符合UX设计，随后消失（PC没有提示）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('复制成功'));
  dt.log.i('STEP 3、打开文件管理器，在文件管理器中粘贴');

  await dt.sleep();
  dt.log.i('预期结果3、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复上述操作进行复制，返回桌面，在桌面中粘贴（PC）');

  await dt.sleep();
  dt.log.i('预期结果4、图片和视频粘贴成功，图片和视频正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('复制单张云端照片到剪贴板 end');
}

/**
 * 宫格-: [时刻首页封面更换]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_001
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace001(dt: Dt) {
  dt.log.i('时刻首页封面更换 start');
  dt.log.i('STEP 1、生成时刻后，在时刻首页面长按某个时刻');

  await dt.sleep();
  dt.log.i('预期结果1、弹出弹框');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击封面更换');

  await dt.sleep();
  dt.log.i('预期结果2、点击封面更换后跳转至选择照片页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择一张照片更换');

  await dt.sleep();
  dt.log.i('预期结果3、封面完成更换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻首页封面更换 end');
}

/**
 * 宫格-: [时刻封面更换的时效]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_0011
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace0011(dt: Dt) {
  dt.log.i('时刻封面更换的时效 start');
  dt.log.i('STEP 1、更换封面后，查看封面设置生效时间');

  await dt.sleep();
  dt.log.i('预期结果1、封面设置生效时间不低于30ms');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、封面设置完成后封面刷新时间');

  await dt.sleep();
  dt.log.i('预期结果2、封面设置完成后封面刷新不低于80ms');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面更换的时效 end');
}

/**
 * 宫格-: [更换封面后克隆测试]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_0012
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace0012(dt: Dt) {
  dt.log.i('更换封面后克隆测试 start');
  dt.log.i('STEP 1、更换封面后，进行xxx克隆测试');

  await dt.sleep();
  dt.log.i('预期结果1、克隆后封面显示为更换后的');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('更换封面后克隆测试 end');
}

/**
 * 宫格-: [时刻宫格右上角设置菜单更换封面]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_002
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace002(dt: Dt) {
  dt.log.i('时刻宫格右上角设置菜单更换封面 start');
  dt.log.i('STEP 1、时刻生成后，点击进入某个时刻上滑进入宫格页面');

  await dt.sleep();
  dt.log.i('预期结果1、进入宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角设置按钮');

  await dt.sleep();
  dt.log.i('预期结果2、弹出菜单中存在封面更换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击选择封面更换');

  await dt.sleep();
  dt.log.i('预期结果3、跳转至照片选择页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、选择一张照片更换');

  await dt.sleep();
  dt.log.i('预期结果4、封面完成更换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻宫格右上角设置菜单更换封面 end');
}

/**
 * 宫格-: [宫格界面长按单个照片设置封面]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_003
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace003(dt: Dt) {
  dt.log.i('宫格界面长按单个照片设置封面 start');
  dt.log.i('STEP 1、时刻生成后，点击进入某个时刻上滑进入宫格页面');

  await dt.sleep();
  dt.log.i('预期结果1、进入宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按任一照片（遍历当前封面照片和非当前封面照片）');

  await dt.sleep();
  dt.log.i('预期结果2、弹出弹框存在设为封面菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击设置为封面');

  await dt.sleep();
  dt.log.i('预期结果3、封面更换完成');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格界面长按单个照片设置封面 end');
}

/**
 * 宫格-大图: [大图右上角设置为封面]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_cover_replace_004
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace004(dt: Dt) {
  dt.log.i('大图右上角设置为封面 start');
  dt.log.i('STEP 1、时刻生成后，点击进入某个时刻上滑进入宫格页面');

  await dt.sleep();
  dt.log.i('预期结果1、进入宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击某个图片进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果2、进入大图页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击右上角设置菜单');

  await dt.sleep();
  dt.log.i('预期结果3、设置菜单中存在设为封面菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、选择设置为封面');

  await dt.sleep();
  dt.log.i('预期结果4、封面更换完成');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图右上角设置为封面 end');
}

/**
 * 宫格-: [更换封面后副标题时间刷新]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_005
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace005(dt: Dt) {
  dt.log.i('更换封面后副标题时间刷新 start');
  dt.log.i('STEP 1、更换封面后，查看副标题时间');

  await dt.sleep();
  dt.log.i('预期结果1、副标题时间更随当面封面照片时间刷新（人像相册）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('更换封面后副标题时间刷新 end');
}

/**
 * 宫格-: [更换不同时刻封面]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_006
 * 前置条件
 * 1.预置可生成多个不同种类的时刻，包含人像、景区、宠物、生日等
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace006(dt: Dt) {
  dt.log.i('更换不同时刻封面 start');
  dt.log.i('STEP 1、生成不同时刻后，分别对相应时刻更换封面');

  await dt.sleep();
  dt.log.i('预期结果1、时刻封面更换完成');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、更换时刻后查看页面布局');

  await dt.sleep();
  dt.log.i('预期结果2、封面更换完成后，页面布局显示正常，无遮挡等');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('更换不同时刻封面 end');
}

/**
 * 宫格-: [更换封面后布局效果]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_007
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace007(dt: Dt) {
  dt.log.i('更换封面后布局效果 start');
  dt.log.i('STEP 1、更换封面后查看布局是否异常');

  await dt.sleep();
  dt.log.i('预期结果1&2、页面布局显示正常，无遮挡等备注：充电息屏后达到最佳效果，关注点1.以最佳呈现中心点为美学中心点，结合人像主体物的人脸进行多比例的校验，存在裁切人脸的情况下重新矫正最佳呈现中心点关注点2.尽量保证不裁切人脸');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、更换封面后充电息屏半小时，查看页面布局');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('更换封面后布局效果 end');
}

/**
 * 宫格-竖屏: [适老化、深色模式、无障碍、横竖屏、全球化、大字体下更换封面后查看布局]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_cover_replace_008
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace008(dt: Dt) {
  dt.log.i('适老化、深色模式、无障碍、横竖屏、全球化、大字体下更换封面后查看布局 start');
  dt.log.i('STEP 1、适老化模式下，更换封面查看页面布局');

  await dt.sleep();
  dt.log.i('预期结果1&2&3&4&5&6、页面布局现在正常，无遮挡等');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、深色模式下，更换封面查看页面布局');

  await dt.sleep();
  dt.log.i('STEP 3、无障碍模式下，更换封面查看页面布局');

  await dt.sleep();
  dt.log.i('STEP 4、更换封面后横竖屏切换查看页面布局');

  await dt.sleep();
  dt.log.i('STEP 5、更换多语言后，更换封面查看页面布局');

  await dt.sleep();
  dt.log.i('STEP 6、大字体下，更名封面查看页面布局');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('适老化、深色模式、无障碍、横竖屏、全球化、大字体下更换封面后查看布局 end');
}

/**
 * 宫格-: [多次更换时刻封面]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_cover_replace_009
 * 前置条件
 * 1.预置可生成多个时刻的照片
 2.手机电量大于50%，充电灭屏分析，连接网络，等待生成时刻
 */
async function multimediaGallerycoverreplace009(dt: Dt) {
  dt.log.i('多次更换时刻封面 start');
  dt.log.i('STEP 1、在某个时刻中，连续多次更换时刻封面');

  await dt.sleep();
  dt.log.i('预期结果1、封面更换正常，每次均可成功更换封面，无卡顿等');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多次更换时刻封面 end');
}

/**
 * 宫格-下载: [LCD图下载小于90%限制解除，不打印LCD图片生成小于90%不启动相关日志]
 * GROUP: 宫格 MODULE: 下载TID: Multimedia_Gallery_CV_lcd_storage_001
 * 前置条件
 * 1、登录3W、5W、或者10W的（便于观察过程）的云空间
 2、插电熄屏电量大于50%，温度小于37摄氏度
 */
async function multimediaGalleryCVlcdstorage001(dt: Dt) {
  dt.log.i('LCD图下载小于90%限制解除，不打印LCD图片生成小于90%不启动相关日志 start');
  dt.log.i('STEP 1、查看日志打印');

  await dt.sleep();
  dt.log.i('预期结果1、SA拉起后日志不会打印LCD下载未达到90%的日志（无相关日志打印“Count of the lcd and thumbnail have not reach 90 percent of total media resources!”）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('Count of the lcd and thumbnail have not reach 90 percent of total media resources!'));
  dt.log.i('预期结果2、打印当前LCD下载进度（打印相关日志“In IsLcdAndThumbnailCountReachThreshold, allMediaResourcesCount is xxx, lcdAndThumbnailCount is xxx”）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('In IsLcdAndThumbnailCountReachThreshold, allMediaResourcesCount is xxx, lcdAndThumbnailCount is xxx'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('LCD图下载小于90%限制解除，不打印LCD图片生成小于90%不启动相关日志 end');
}

/**
 * 宫格-下载: [LCD图下载小于90%断网，智慧分析继续可以生成时刻]
 * GROUP: 宫格 MODULE: 下载TID: Multimedia_Gallery_CV_lcd_storage_002
 * 前置条件
 * 1、登录3W、5W、或者10W的（便于观察过程）的云空间
 2、插电熄屏电量大于50%，温度小于37摄氏度
 */
async function multimediaGalleryCVlcdstorage002(dt: Dt) {
  dt.log.i('LCD图下载小于90%断网，智慧分析继续可以生成时刻 start');
  dt.log.i('预期结果1、LCD图不再下载');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、智慧分析不会停止，时刻能够生成（断网只会影响地点解析，此时保证地点解析基本完成）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('LCD图下载小于90%断网，智慧分析继续可以生成时刻 end');
}

/**
 * 宫格-视频: [Rom空间小于10%中断+清除后继续分析+大于10%可正常CV分析]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_CV_lcd_storage_003
 * 前置条件
 * 1图库中已预置2k+图片和视频资源
 2.手机电量大于50%，灭屏，充电
 */
async function multimediaGalleryCVlcdstorage003(dt: Dt) {
  dt.log.i('Rom空间小于10%中断+清除后继续分析+大于10%可正常CV分析 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Rom空间小于10%中断+清除后继续分析+大于10%可正常CV分析 end');
}

/**
 * 宫格-视频: [Rom空间小于10%中断cv分析]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_CV_lcd_storage_004
 * 前置条件
 * 1图库中已预置2k+图片和视频资源
 2.手机电量大于50%，灭屏，充电
 */
async function multimediaGalleryCVlcdstorage004(dt: Dt) {
  dt.log.i('Rom空间小于10%中断cv分析 start');
  dt.log.i('STEP 1、构造手机空间小于10%');

  await dt.sleep();
  dt.log.i('STEP 2、用“hdc shell ”和“hilog | grep MediaCV”命令打印日志');

  await dt.sleep();
  dt.log.i('预期结果2、内存日志打印 totalSize:xxx, freeSize:xxx智慧分析被打断，日志打印：[media_analyse_service.cpp(OnStop):xx] OnStop');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Rom空间小于10%中断cv分析 end');
}

/**
 * 宫格-视频: [Rom空间小于10%清除后继续分析]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_CV_lcd_storage_005
 * 前置条件
 * 1图库中已预置2k+图片和视频资源
 2.手机电量大于50%，灭屏，充电
 */
async function multimediaGalleryCVlcdstorage005(dt: Dt) {
  dt.log.i('Rom空间小于10%清除后继续分析 start');
  dt.log.i('STEP 1、构造手机空间小于10%');

  await dt.sleep();
  dt.log.i('STEP 2、用“hdc shell ”和“hilog | grep MediaCV”命令打印日志');

  await dt.sleep();
  dt.log.i('预期结果2、内存日志打印 totalSize:xxx, freeSize:xxx智慧分析被打断，日志打印：[media_analyse_service.cpp(OnStop):xx] OnStop');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、手机端查看是否会有内存不足10%提醒');

  await dt.sleep();
  dt.log.i('预期结果3、智慧分析日志正常打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Rom空间小于10%清除后继续分析 end');
}

/**
 * 宫格-视频: [Rom空间小于10%稳定性验证]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_CV_lcd_storage_006
 * 前置条件
 * 1图库中已预置2k+图片和视频资源
 2.手机电量大于50%，灭屏，充电
 */
async function multimediaGalleryCVlcdstorage006(dt: Dt) {
  dt.log.i('Rom空间小于10%稳定性验证 start');
  dt.log.i('STEP 1、构造手机空间小于10%');

  await dt.sleep();
  dt.log.i('预期结果1.日志打印结果符合预期，不会打印智慧分析日志');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、用“hdc shell ”和“hilog | grep MediaCV”命令打印日志');

  await dt.sleep();
  dt.log.i('STEP 3、清除内存空间大于10%，查看日志');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Rom空间小于10%稳定性验证 end');
}

/**
 * 宫格-视频: [1k资源首个时刻生成时延]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_CV_lcd_storage_007
 * 前置条件
 * 1图库中已预置3k图片和视频资源
 2.手机电量大于50%，灭屏，充电
 */
async function multimediaGalleryCVlcdstorage007(dt: Dt) {
  dt.log.i('1k资源首个时刻生成时延 start');
  dt.log.i('STEP 1、插电熄屏等待时刻生成，关注首个时刻生成时延');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('1k资源首个时刻生成时延 end');
}

/**
 * 宫格-: [智慧分析服务1K模型首个时刻生成的时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_CyclicOptimization_001
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置1K测试资源：资源取模型数据：1K标准数据集：
 */
async function multimediaGalleryCyclicOptimization001(dt: Dt) {
  dt.log.i('智慧分析服务1K模型首个时刻生成的时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库');

  await dt.sleep();
  dt.log.i('STEP 3、日志中存在 CV has analysised 1000 pictrue, start to run highlight again打印');

  await dt.sleep();
  dt.log.i('预期结果3、日志中存在MEDIA_CV_ILOG(”CV has analysised 1000 pictrue, start to run highlight again”)打印');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('CV has analysised 1000 pictrue, start to run highlight again'));
  dt.log.i('STEP 4、查看第一个时刻生成时间tab_highlight_album表中查看第一个时刻生成时间generate_time字段（需转换时间戳））转化时间戳工具：https://www.bejson.com/convert/unix/');

  await dt.sleep();
  dt.log.i('预期结果4、首个时刻生成的时间减掉挂起分析的时间，首个时刻生成的时间35min');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务1K模型首个时刻生成的时长 end');
}

/**
 * 宫格-: [精彩时刻生成流程优化_3k图集(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_CyclicOptimization_002
 * 前置条件
 * 1、手机图库预置3k张图片
 2、设备已连接网络
 */
async function multimediaGalleryCyclicOptimization002(dt: Dt) {
  dt.log.i('精彩时刻生成流程优化_3k图集(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；抓取log，检索日志');

  await dt.sleep();
  dt.log.i('STEP 2、查看第一个时刻生成时间');

  await dt.sleep();
  dt.log.i('预期结果2、第一个时刻生成时间对比历史版本有优化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看整体完成时间');

  await dt.sleep();
  dt.log.i('预期结果3、整体完成时间对比历史版本有优化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻生成流程优化_3k图集(手机-通用) end');
}

/**
 * 宫格-: [精彩时刻生成流程优化_5k图集(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_CyclicOptimization_003
 * 前置条件
 * 1、手机图库预置5k张图片
 2、设备已连接网络
 */
async function multimediaGalleryCyclicOptimization003(dt: Dt) {
  dt.log.i('精彩时刻生成流程优化_5k图集(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；抓取log，检索日志');

  await dt.sleep();
  dt.log.i('STEP 2、查看第一个时刻生成时间');

  await dt.sleep();
  dt.log.i('预期结果2、第一个时刻生成时间对比历史版本有优化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看整体完成时间');

  await dt.sleep();
  dt.log.i('预期结果3、整体完成时间对比历史版本有优化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻生成流程优化_5k图集(手机-通用) end');
}

/**
 * 宫格-: [精彩时刻生成流程优化_2w图集(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_CyclicOptimization_004
 * 前置条件
 * 1、手机图库预置2w张图片
 2、设备已连接网络
 */
async function multimediaGalleryCyclicOptimization004(dt: Dt) {
  dt.log.i('精彩时刻生成流程优化_2w图集(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；抓取log，检索日志');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻生成时间日志打点');

  await dt.sleep();
  dt.log.i('预期结果2、查看打点日志：时刻打点需求清单_精彩时刻.xlsx 打点命令如下：1.hdc shell2.hisysevent -l -o PHOTOS_UE -n + 事件名');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻生成流程优化_2w图集(手机-通用) end');
}

/**
 * 宫格-深色: [图库照片宫格页深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_001
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode001(dt: Dt) {
  dt.log.i('图库照片宫格页深色模式适配 start');
  dt.log.i('STEP 1、进入图库照片宫格页，查看界面深色模式显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换年月日视图，查看界面深色模式显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、往下滑动一屏，查看滚动轴显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 4、点击右上角四方菜单，查看弹窗显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 5、长按图片跳出右键菜单，查看弹窗显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库照片宫格页深色模式适配 end');
}


























