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


export default function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbumTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002', Level.LEVEL2,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [人像相册中满足优选条件的人像数大于等于10，进行封面优选] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_002
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum003', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [人像优选算法会进行多重排他算法筛选符合条件的封面] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_003
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum003(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum004', Level.LEVEL4,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [人像封面优选的人像框评分计算方式] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_004
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum004(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum005', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [xxx、xxxOTA升级场景下，人像相册默认进行封面优选] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_005
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum005(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum006', Level.LEVEL2,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [xxx场景下，用户已设置封面的相册默认不进行封面优选] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_006
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum006(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum007', Level.LEVEL2,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [手机新增图片后，默认进行一次封面优选，后续新增图片不再刷新] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_007
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum007(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum008', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [用户设置相册封面后，默认不修改封面图片] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_008
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum008(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum009', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-删除用例: [用户删除、隐藏封面图片后，默认设置剩余图片中最高分的作为封面] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_009
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum009(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum010', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-删除用例: [用户将被删除、隐藏封面图片恢复后，默认不再刷新当前人像封面] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_010
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum010(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum011', Level.LEVEL3,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [用户编辑封面图片后，默认不修改封面图片，等待再次拉起分析后，进行优选] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_011
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum011(dt);
      });

    run('APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum012', Level.LEVEL4,
      async (dt: Dt): Promise<void> => {
        //  宫格-用例: [大数据量下，人像封面优选正常运行] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_012
        await APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum012(dt);
      });

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

    run('MultimediaGalleryPhotoPickerAlbumSelection001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [三方拉起picker，相册选择(如微信)] TID: Multimedia_Gallery_PhotoPicker_AlbumSelection_001
      await MultimediaGalleryPhotoPickerAlbumSelection001(dt);
    });

    run('MultimediaGalleryPhotoPickerAppLock001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-应用锁用例: [应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker] TID: Multimedia_Gallery_PhotoPicker_AppLock_001
      await MultimediaGalleryPhotoPickerAppLock001(dt);
    });

    run('MultimediaGalleryPhotoPickerShare001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [分享视频资源，picker拉起查看验证] TID: Multimedia_Gallery_PhotoPicker_Share_001
      await MultimediaGalleryPhotoPickerShare001(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0131', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [宫格页同时设置上下左右四个方向的margin值20%] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0131
      await MultimediaGalleryPhotoPickerMarginComponent0131(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0132', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [宫格页同时设置上方以及下方margin值20%] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0132
      await MultimediaGalleryPhotoPickerMarginComponent0132(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0133', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [宫格页同时设置上方以及右方margin值20%] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0133
      await MultimediaGalleryPhotoPickerMarginComponent0133(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0134', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [宫格页同时设置下方以及左方margin值20%] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0134
      await MultimediaGalleryPhotoPickerMarginComponent0134(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0135', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [宫格页同时设置左方以及右方margin值20%] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0135
      await MultimediaGalleryPhotoPickerMarginComponent0135(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0142', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [半模态picker（如：备忘录），切换动态照片动态照片角标验证] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0142
      await MultimediaGalleryPhotoPickerMarginComponent0142(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0143', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [半模态picker（如：备忘录），动态图编辑后成静态图片，角标验证] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0143
      await MultimediaGalleryPhotoPickerMarginComponent0143(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0144', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [云端下行，半模态picker（如：备忘录）,动态照片关闭动态，角标验证] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0144
      await MultimediaGalleryPhotoPickerMarginComponent0144(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002 finish');
    });
  });
}

/**
 * 宫格-: [人像相册中满足优选条件的人像数大于等于10，进行封面优选]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_002
 * 前置条件
 * 1、手机电量大于50%
 2、预置20张可生成人像相册的图片
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum002(dt: Dt) {
  dt.log.i('人像相册中满足优选条件的人像数大于等于10，进行封面优选 start');
  dt.log.i('STEP 1、将9张符合条件的图片导入手机后，充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看实时日志（关键字MediaCV），等待生成人像相册，');

  await dt.sleep();
  dt.log.i('预期结果2、实时日志中，人像封面优选算法正常运行：【beauty_aesthetics_processor】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果3、3.1 图库未显示人像相册3.2 AnalysisAlbum表中is_cover_satisfied不等于43.3 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded=1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、导入3张不符合排他算法的图片：人脸重叠排他、人脸面积 < 360 x 360排他、闭眼排他（当前不支持）、整张图片的美学评分排他，重复步骤2-3');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_image_face表中新增图片的 beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version写入对应数据、is_excluded=0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、导入2张符合条件图片，重复步骤2-3');

  await dt.sleep();
  dt.log.i('预期结果5、5.1 图库显示人像相册，封面为优选结果3.2 AnalysisAlbum表中cover_uri更新为对应封面图片的路径、is_cover_satisfied=43.3 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version写入对应数据、is_excluded=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像相册中满足优选条件的人像数大于等于10，进行封面优选 end');
}

/**
 * 宫格-: [人像优选算法会进行多重排他算法筛选符合条件的封面]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_003
 * 前置条件
 * 1、手机电量大于50%
 2、预置20张可生成人像相册的图片（其中已知存在人脸面积小于360*360图片a、b；人脸重叠图片c、d）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum003(dt: Dt) {
  dt.log.i('人像优选算法会进行多重排他算法筛选符合条件的封面 start');
  dt.log.i('STEP 1、将20张图片导入手机后充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、等待智慧分析跑完后，查看数据库字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face表中对应的beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version写入对应数据 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像优选算法会进行多重排他算法筛选符合条件的封面 end');
}

/**
 * 宫格-: [人像封面优选的人像框评分计算方式]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_004
 * 前置条件
 * 1、手机电量大于50%
 2、预置20张可生成人像相册的图片（同一人像背景相同，但是人像角度不同的图片）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum004(dt: Dt) {
  dt.log.i('人像封面优选的人像框评分计算方式 start');
  dt.log.i('STEP 1、将20张图片导入手机后充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、等待智慧分析跑完后，查看数据库字段');

  await dt.sleep();
  dt.log.i('预期结果2、基于tab_analysis_image_face表中pitch，yaw、roll以及图片的美学评分结果，计算图片中的人像的美学评分值计算方式参考：');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像封面优选的人像框评分计算方式 end');
}

/**
 * 宫格-: [xxx、xxxOTA升级场景下，人像相册默认进行封面优选]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_005
 * 前置条件
 * 1、旧版本中图库存在人像相册（图片数量20）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum005(dt: Dt) {
  dt.log.i('xxx、xxxOTA升级场景下，人像相册默认进行封面优选 start');
  dt.log.i('STEP 1、触发xxx升级服务/xxxOTA升级服务');

  await dt.sleep();
  dt.log.i('STEP 2、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、2.1人像页中出现人像相册，封面为升级场景下的默认图片2.2 AnalysisAlbum表中cover_uri为升级后默认的对应封面图片的路径、is_cover_satisfied=0\12.3 tab_analysis_image_facebeauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded默认为空4、4.1人像相册封面更新为优选封面4.2AnalysisAlbumAnalysisAlbum表中cover_uri更新为对应封面图片的路径、is_cover_satisfied=44.3tab_analysis_image_facetab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、充电息屏，等待智慧分析结果');

  await dt.sleep();
  dt.log.i('STEP 4、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果4、4.1人像相册封面更新为优选封面4.2AnalysisAlbumAnalysisAlbum表中cover_uri更新为对应封面图片的路径、is_cover_satisfied=44.3tab_analysis_image_facetab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx、xxxOTA升级场景下，人像相册默认进行封面优选 end');
}

/**
 * 宫格-: [xxx场景下，用户已设置封面的相册默认不进行封面优选]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_006
 * 前置条件
 * 1、旧版本中图库存在人像相册
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum006(dt: Dt) {
  dt.log.i('xxx场景下，用户已设置封面的相册默认不进行封面优选 start');
  dt.log.i('STEP 1、给人像相册设置封面，触发xxx升级服务');

  await dt.sleep();
  dt.log.i('STEP 2、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、2.1人像页中出现人像相册，封面为用户设置的封面2.2 AnalysisAlbum表中cover_uri为升级后默认的对应封面图片的路径、is_cover_satisfied=22.3 tab_analysis_image_facebeauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded默认为空4、4.1人像相册封面不更新4.2AnalysisAlbumAnalysisAlbum表中cover_uri不更新、is_cover_satisfied=24.3tab_analysis_image_facetab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、充电息屏，等待智慧分析结果');

  await dt.sleep();
  dt.log.i('STEP 4、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果4、4.1人像相册封面不更新4.2AnalysisAlbumAnalysisAlbum表中cover_uri不更新、is_cover_satisfied=24.3tab_analysis_image_facetab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx场景下，用户已设置封面的相册默认不进行封面优选 end');
}

/**
 * 宫格-: [手机新增图片后，默认进行一次封面优选，后续新增图片不再刷新]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_007
 * 前置条件
 * 1、手机电量大于50%
 2、预置20张可生成人像相册的图片
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum007(dt: Dt) {
  dt.log.i('手机新增图片后，默认进行一次封面优选，后续新增图片不再刷新 start');
  dt.log.i('STEP 1、将15张图片导入手机后，充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看实时日志（关键字MediaCV），等待生成人像相册，');

  await dt.sleep();
  dt.log.i('预期结果2、实时日志中，人像封面优选算法正常运行：【beauty_aesthetics_processor】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果3、3.1 人像相册封面结果与之前版本不一致，为优选结果3.2 AnalysisAlbum表中cover_uri更新为对应封面图片的路径、is_cover_satisfied=43.3 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、剩余5张图片导入手机，充电息屏，重复步骤2-3');

  await dt.sleep();
  dt.log.i('预期结果4、人像封面默认为首次进行优选的结果，不再刷新：AnalysisAlbum表中cover_uri不更新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机新增图片后，默认进行一次封面优选，后续新增图片不再刷新 end');
}

/**
 * 宫格-: [用户设置相册封面后，默认不修改封面图片]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_008
 * 前置条件
 * 1、手机电量大于50%
 2、预置20张可生成人像相册的图片
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum008(dt: Dt) {
  dt.log.i('用户设置相册封面后，默认不修改封面图片 start');
  dt.log.i('STEP 1、将图片导入手机后，充电息屏，等待生成人像相册');

  await dt.sleep();
  dt.log.i('预期结果1、实时日志中，等待人像聚类算法结束，亮屏查看3、人像优选算法正常运行：【beauty_aesthetics_processor】4、4.1人像相册封面结果为用户设置结果3.2 AnalysisAlbum表中cover_uri更新为用户设置的封面图片的路径、is_cover_satisfied=23.3 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、设置图片a作为封面（图片a不是优选设置的封面）');

  await dt.sleep();
  dt.log.i('STEP 3、查看实时日志');

  await dt.sleep();
  dt.log.i('预期结果3、人像优选算法正常运行：【beauty_aesthetics_processor】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果4、4.1人像相册封面结果为用户设置结果3.2 AnalysisAlbum表中cover_uri更新为用户设置的封面图片的路径、is_cover_satisfied=23.3 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户设置相册封面后，默认不修改封面图片 end');
}

/**
 * 宫格-删除: [用户删除、隐藏封面图片后，默认设置剩余图片中最高分的作为封面]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_009
 * 前置条件
 * 1、手机电量大于50%
 2、手机已存在2个人像相册（每个相册15张图片）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum009(dt: Dt) {
  dt.log.i('用户删除、隐藏封面图片后，默认设置剩余图片中最高分的作为封面 start');
  dt.log.i('STEP 1、删除人像封面图片A，隐藏人像封面图片a');

  await dt.sleep();
  dt.log.i('STEP 2、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、2.1 人像相册封面更换成了图片B以及b2.2 phtots表中图片A、a的date_trashed=1、hidden=12.2 AnalysisAlbum表中cover_uri更新为图片B、b的路径、is_cover_satisfied=42.3 tab_analysis_image_face表中同一相册内图片B评分仅次于图片A，图片b评分仅次于图片a');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户删除、隐藏封面图片后，默认设置剩余图片中最高分的作为封面 end');
}

/**
 * 宫格-删除: [用户将被删除、隐藏封面图片恢复后，默认不再刷新当前人像封面]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_010
 * 前置条件
 * 1、手机电量大于50%
 2、手机已存在一个人像相册（20张图片）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum010(dt: Dt) {
  dt.log.i('用户将被删除、隐藏封面图片恢复后，默认不再刷新当前人像封面 start');
  dt.log.i('STEP 1、删除人像封面图片A');

  await dt.sleep();
  dt.log.i('STEP 2、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、结果与用例【用户删除、隐藏封面图片后，默认设置剩余图片中最高分的作为封面】一致4、人像封面图片未更换，4.2 AnalysisAlbum表中cover_uri不更新，还是为图片B、b的路径、is_cover_satisfied=45、不再刷新当前人像封面，AnalysisAlbum表中cover_uri不更新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、将图片A从最近删除、隐藏相册恢复');

  await dt.sleep();
  dt.log.i('STEP 4、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果4、人像封面图片未更换，4.2 AnalysisAlbum表中cover_uri不更新，还是为图片B、b的路径、is_cover_satisfied=4');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果5、不再刷新当前人像封面，AnalysisAlbum表中cover_uri不更新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户将被删除、隐藏封面图片恢复后，默认不再刷新当前人像封面 end');
}

/**
 * 宫格-: [用户编辑封面图片后，默认不修改封面图片，等待再次拉起分析后，进行优选]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_011
 * 前置条件
 * 1、手机电量大于50%
 2、手机已存在2个人像相册（每个相册15张图片）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum011(dt: Dt) {
  dt.log.i('用户编辑封面图片后，默认不修改封面图片，等待再次拉起分析后，进行优选 start');
  dt.log.i('STEP 1、编辑人像封面图片A（将人像部分裁剪掉），编辑人像封面图片a（没有裁剪人像部分）');

  await dt.sleep();
  dt.log.i('STEP 2、检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、2.1 人像相册封面没有被更换2.2 tab_analysis_total表中图片A、a数据清零，等待下次智慧分析刷新数据2.2 AnalysisAlbum表、 tab_analysis_image_face表中数据不变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、充电息屏，再次进行人像封面优选，检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果3、3.1 人像相册封面选择评分最高的图片B、b（人像未被裁剪，存在b图片就是a图片的可能）3.2 被编辑的图片A、a的智慧数据被更新3.3 AnalysisAlbum表中cover_uri更新为图片B、b的路径、is_cover_satisfied=4');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户编辑封面图片后，默认不修改封面图片，等待再次拉起分析后，进行优选 end');
}

/**
 * 宫格-: [大数据量下，人像封面优选正常运行]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_PortraitBeautyAestheticsAlbum_012
 * 前置条件
 * 1、手机电量大于50%
 2、手机存在3w数据
 */
async function APPFWKMediaFwkMediaLibraryMediaCVPortraitBeautyAestheticsAlbum012(dt: Dt) {
  dt.log.i('大数据量下，人像封面优选正常运行 start');
  dt.log.i('STEP 1、充电息屏，查看实时日志');

  await dt.sleep();
  dt.log.i('预期结果1、智慧分析正常进行，人像封面优选算法正常运行：【beauty_aesthetics_processor】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在分析过程中亮屏，检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果2、2.1 已生成部分人像相册，相册封面显示的都是优选封面2.2 tab_analysis_image_face表中beauty_bounder_x、beauty_bounder_y、beauty_bounder_width、beauty_bounder_height、aesthetics_score、beauty_bounder_version、is_excluded写入对应数据2.2 AnalysisAlbum表中cover_uri更新为对应封面图片的路径、is_cover_satisfied=4；若is_cover_satisfied不为4，检查tab_analysis_image_face表中对应相册中图片的is_excluded字段数量应该小于10');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、等待分析完成，检查图库相册页-人像相册界面以及相关数据库');

  await dt.sleep();
  dt.log.i('预期结果3、3.1 所有人像相册都已生成，并且皆为优选封面（封面图片的评分皆为当前相册的最高值）3.2 tab_analysis_image_face表、AnalysisAlbum表中数据更新正确');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大数据量下，人像封面优选正常运行 end');
}

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
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.所有图片界面，双指滑动进行多选');

  await dt.sleep();
  dt.log.i('预期结果4.所有图片页面，双指滑动可进行多选');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.单指点击所有相册，聚焦后双击');

  await dt.sleep();
  dt.log.i('预期结果5.可打开所有相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.所有相册界面，点击相册等可选中元素聚焦，语音播报提示后双击打开，打开相册后，宫格页面，双指滑动进行多选。单指该页面元素，双击。');

  await dt.sleep();
  dt.log.i('预期结果6.所有相册页面，点击任意相册可以选中该相册元素并聚焦，语音播报提示，且双击后打开。打开相册后进入该宫格页面，双指滑动可进行多选，如果存在未下载的云图，未下载的云图将被下载。该页面元素单指点击可以聚焦，然后双击后可以选中该元素。');
  await dt.sleep(DELAY.short);


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
  await dt.sleep(DELAY.short);


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
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker，小红书拉起picker多选，预览条无障碍 end');
}

/**
 * picker-下载: [三方拉起picker，相册选择(如微信)]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPicker_AlbumSelection_001
 * 前置条件
 * 1、下载安装微信
 2、登录微信账号
 */
async function MultimediaGalleryPhotoPickerAlbumSelection001(dt: Dt) {
  dt.log.i('三方拉起picker，相册选择(如微信) start');
  dt.log.i('STEP 1、好友发消息界面，右下方加号,照片拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、点击上方图片和视频，展开所有相册');

  await dt.sleep();
  dt.log.i('预期结果2、所有相册相册名以及资源数量全为白字显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方拉起picker，相册选择(如微信) end');
}

/**
 * picker-应用锁: [应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker]
 * GROUP: picker MODULE: 应用锁TID: Multimedia_Gallery_PhotoPicker_AppLock_001
 * 前置条件
 * 1.图库添加应用锁，应用锁设置为隐私密码
 */
async function MultimediaGalleryPhotoPickerAppLock001(dt: Dt) {
  dt.log.i('应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker start');
  dt.log.i('STEP 1.息屏后，拉起息屏相机点击个性风格-更多拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1.拉起picker后需要用锁屏密码解锁');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.解开应用锁');

  await dt.sleep();
  dt.log.i('预期结果2.锁屏密码后再用隐私密码解锁才可以拉起picker查看图库资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.息屏后，拉起扫码，点击相册');

  await dt.sleep();
  dt.log.i('预期结果3.需要先输入锁屏密码后再输入隐私密码才可以解锁');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker end');
}

/**
 * picker-视频: [分享视频资源，picker拉起查看验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPicker_Share_001
 * 前置条件
 * 1.分享到测试机任意一个以上视频（包含1个）
 */
async function MultimediaGalleryPhotoPickerShare001(dt: Dt) {
  dt.log.i('分享视频资源，picker拉起查看验证 start');
  dt.log.i('STEP 1.嵌入式picker如小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.查看图片和视频相册');

  await dt.sleep();
  dt.log.i('预期结果2.可以看到新增的分享视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.切换为分享相册查看');

  await dt.sleep();
  dt.log.i('预期结果3.分享相册内可以看到新增的分享过来的视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享视频资源，picker拉起查看验证 end');
}

/**
 * picker-下载: [宫格页同时设置上下左右四个方向的margin值20%]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerMarginComponent_0131
 * 前置条件
 * 下载demo  label.hap
 */
async function MultimediaGalleryPhotoPickerMarginComponent0131(dt: Dt) {
  dt.log.i('宫格页同时设置上下左右四个方向的margin值20% start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.录入宫格页上下左右四个方向的margin值20%');

  await dt.sleep();
  dt.log.i('STEP 3.点击拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页上下左右四个方向的margin值为20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页同时设置上下左右四个方向的margin值20% end');
}

/**
 * picker-下载: [宫格页同时设置上方以及下方margin值20%]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerMarginComponent_0132
 * 前置条件
 * 下载demo  label.hap
 */
async function MultimediaGalleryPhotoPickerMarginComponent0132(dt: Dt) {
  dt.log.i('宫格页同时设置上方以及下方margin值20% start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.录入宫格页上方margin值20%，下方margin值20%');

  await dt.sleep();
  dt.log.i('STEP 3.点击拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页上方margin值为20%，下方margin值为20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页同时设置上方以及下方margin值20% end');
}

/**
 * picker-下载: [宫格页同时设置上方以及右方margin值20%]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerMarginComponent_0133
 * 前置条件
 * 下载demo  label.hap
 */
async function MultimediaGalleryPhotoPickerMarginComponent0133(dt: Dt) {
  dt.log.i('宫格页同时设置上方以及右方margin值20% start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.录入宫格页上方margin值20%，右方margin值20%');

  await dt.sleep();
  dt.log.i('STEP 3.点击拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页上方margin值为20%，右方margin值为20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页同时设置上方以及右方margin值20% end');
}

/**
 * picker-下载: [宫格页同时设置下方以及左方margin值20%]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerMarginComponent_0134
 * 前置条件
 * 下载demo  label.hap
 */
async function MultimediaGalleryPhotoPickerMarginComponent0134(dt: Dt) {
  dt.log.i('宫格页同时设置下方以及左方margin值20% start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.录入下方margin值20%，左方margin值20%');

  await dt.sleep();
  dt.log.i('STEP 3.点击拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页下方margin值为20%，左方margin值为20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页同时设置下方以及左方margin值20% end');
}

/**
 * picker-下载: [宫格页同时设置左方以及右方margin值20%]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerMarginComponent_0135
 * 前置条件
 * 下载demo  label.hap
 */
async function MultimediaGalleryPhotoPickerMarginComponent0135(dt: Dt) {
  dt.log.i('宫格页同时设置左方以及右方margin值20% start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.录入宫格页左方margin值20%，右方margin值20%');

  await dt.sleep();
  dt.log.i('STEP 3.点击拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页左方margin值为20%，右方margin值为20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页同时设置左方以及右方margin值20% end');
}

/**
 * picker-动态照片: [半模态picker（如：备忘录），切换动态照片动态照片角标验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerMarginComponent_0142
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerMarginComponent0142(dt: Dt) {
  dt.log.i('半模态picker（如：备忘录），切换动态照片动态照片角标验证 start');
  dt.log.i('STEP 1.系统相机拍摄动态照片');

  await dt.sleep();
  dt.log.i('STEP 2.图库中找到新添加的动态照片，开启循环播放动效');

  await dt.sleep();
  dt.log.i('STEP 3.备忘录调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果3.picker调起的宫格页，动态照片角标显示5.picker调起的宫格页，动态照片角标显示7.picker调起的宫格页，动态照片角标显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.图库中找到新添加的动态照片，开启主角时刻动效');

  await dt.sleep();
  dt.log.i('STEP 5.备忘录调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果5.picker调起的宫格页，动态照片角标显示7.picker调起的宫格页，动态照片角标显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.图库中找到新添加的动态照片，开启运动轨迹动效');

  await dt.sleep();
  dt.log.i('STEP 7.备忘录调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果7.picker调起的宫格页，动态照片角标显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('半模态picker（如：备忘录），切换动态照片动态照片角标验证 end');
}

/**
 * picker-动态照片: [半模态picker（如：备忘录），动态图编辑后成静态图片，角标验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerMarginComponent_0143
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerMarginComponent0143(dt: Dt) {
  dt.log.i('半模态picker（如：备忘录），动态图编辑后成静态图片，角标验证 start');
  dt.log.i('STEP 1.系统相机拍摄动态照片');

  await dt.sleep();
  dt.log.i('STEP 2.进入图库，点击最新添加的动态照片进大图');

  await dt.sleep();
  dt.log.i('STEP 3.点击编辑，涂鸦5.备忘录调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果3.动态照片变为静态照片5.无法看到角标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.备忘录调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果5.无法看到角标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('半模态picker（如：备忘录），动态图编辑后成静态图片，角标验证 end');
}

/**
 * picker-动态照片: [云端下行，半模态picker（如：备忘录）,动态照片关闭动态，角标验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerMarginComponent_0144
 * 前置条件
 * 1.云端有多张动态照片
 2.已下行同步
 */
async function MultimediaGalleryPhotoPickerMarginComponent0144(dt: Dt) {
  dt.log.i('云端下行，半模态picker（如：备忘录）,动态照片关闭动态，角标验证 start');
  dt.log.i('STEP 1.进入图库，关闭一张动态照片的动态效果');

  await dt.sleep();
  dt.log.i('STEP 2.备忘录调起picker');

  await dt.sleep();
  dt.log.i('预期结果2.关闭动态效果的动态图片没有动态照片的角标，没有关闭动态效果的动态图片有动态照片的角标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端下行，半模态picker（如：备忘录）,动态照片关闭动态，角标验证 end');
}
