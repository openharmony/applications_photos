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

export default function MultimediaGalleryMapAlbumPalacegrid(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryMapAlbumPalacegridTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryMapAlbumPalacegrid').init();
      dt.log.i('beforeAll MultimediaGalleryMapAlbumPalacegrid start');
      dt.log.i('beforeAll MultimediaGalleryMapAlbumPalacegrid finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryMapAlbumPalacegrid', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryMapAlbumPalacegrid014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式界面] TID: Multimedia_Gallery_MapAlbum_Palacegrid_014
      await multimediaGalleryMapAlbumPalacegrid014(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式缩放、拖动、旋转] TID: Multimedia_Gallery_MapAlbum_Palacegrid_015
      await multimediaGalleryMapAlbumPalacegrid015(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式缩放边界值验证] TID: Multimedia_Gallery_MapAlbum_Palacegrid_016
      await multimediaGalleryMapAlbumPalacegrid016(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式定位当前位置] TID: Multimedia_Gallery_MapAlbum_Palacegrid_017
      await multimediaGalleryMapAlbumPalacegrid017(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-指北针定位] TID: Multimedia_Gallery_MapAlbum_Palacegrid_018
      await multimediaGalleryMapAlbumPalacegrid018(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式，相册封图数目显示限值] TID: Multimedia_Gallery_MapAlbum_Palacegrid_019
      await multimediaGalleryMapAlbumPalacegrid019(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式，2个城市相册合并] TID: Multimedia_Gallery_MapAlbum_Palacegrid_020
      await multimediaGalleryMapAlbumPalacegrid020(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式，3个以上个城市相册合并] TID: Multimedia_Gallery_MapAlbum_Palacegrid_021
      await multimediaGalleryMapAlbumPalacegrid021(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-地图模式，相册合并动态化] TID: Multimedia_Gallery_MapAlbum_Palacegrid_022
      await multimediaGalleryMapAlbumPalacegrid022(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地图模式，点击相册缩略图跳转照片列表页] TID: Multimedia_Gallery_MapAlbum_Palacegrid_023
      await multimediaGalleryMapAlbumPalacegrid023(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [地图模式，不支持删除地点] TID: Multimedia_Gallery_MapAlbum_Palacegrid_024
      await multimediaGalleryMapAlbumPalacegrid024(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [地点相册-地图模式下相册缩略图动态更新] TID: Multimedia_Gallery_MapAlbum_Palacegrid_025
      await multimediaGalleryMapAlbumPalacegrid025(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [地图模式下，界面响应及交互验证] TID: Multimedia_Gallery_MapAlbum_Palacegrid_026
      await multimediaGalleryMapAlbumPalacegrid026(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [地图模式下，旋转屏适配] TID: Multimedia_Gallery_MapAlbum_Palacegrid_027
      await multimediaGalleryMapAlbumPalacegrid027(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [地图模式-城市相册中只有视频时，相册封图显示] TID: Multimedia_Gallery_MapAlbum_Palacegrid_028
      await multimediaGalleryMapAlbumPalacegrid028(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid029', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [拍摄照片时，未授权地理位置权限，未开启GPS] TID: Multimedia_Gallery_MapAlbum_Palacegrid_029
      await multimediaGalleryMapAlbumPalacegrid029(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid030', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地图模式，地理地址信息国际化] TID: Multimedia_Gallery_MapAlbum_Palacegrid_030
      await multimediaGalleryMapAlbumPalacegrid030(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册进入宫格模式] TID: Multimedia_Gallery_MapAlbum_Palacegrid_031
      await multimediaGalleryMapAlbumPalacegrid031(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [宫格模式，删除城市相册] TID: Multimedia_Gallery_MapAlbum_Palacegrid_032
      await multimediaGalleryMapAlbumPalacegrid032(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [宫格模式，新建城市相册] TID: Multimedia_Gallery_MapAlbum_Palacegrid_033
      await multimediaGalleryMapAlbumPalacegrid033(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid034', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [宫格模式，拖动城市相册自定义排序] TID: Multimedia_Gallery_MapAlbum_Palacegrid_034
      await multimediaGalleryMapAlbumPalacegrid034(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [宫格模式-城市相册封图动态更新] TID: Multimedia_Gallery_MapAlbum_Palacegrid_035
      await multimediaGalleryMapAlbumPalacegrid035(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid036', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [宫格模式，更新城市相册排序] TID: Multimedia_Gallery_MapAlbum_Palacegrid_036
      await multimediaGalleryMapAlbumPalacegrid036(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [进入城市相册照片宫格页] TID: Multimedia_Gallery_MapAlbum_Palacegrid_037
      await multimediaGalleryMapAlbumPalacegrid037(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid038', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [清空城市相册所有照片，单选删除，多选删除] TID: Multimedia_Gallery_MapAlbum_Palacegrid_038
      await multimediaGalleryMapAlbumPalacegrid038(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryMapAlbumPalacegrid').init();
      dt.log.i('afterEach MultimediaGalleryMapAlbumPalacegrid start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryMapAlbumPalacegrid finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryMapAlbumPalacegrid').init();
      dt.log.i('afterAll MultimediaGalleryMapAlbumPalacegrid start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryMapAlbumPalacegrid finish');
    });
  });
}

// DT步骤
/**
 * 宫格-: [地点相册-地图模式界面]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_014
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid014(dt: Dt) {
  dt.log.i('地点相册-地图模式界面 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.查看页面显示；');

  await dt.sleep();
  dt.log.i('预期结果2.界面显示正常，背景地图显示正常，对应地点的相册展示正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式界面 end');
}

/**
 * 宫格-: [地点相册-地图模式缩放、拖动、旋转]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_015
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid015(dt: Dt) {
  dt.log.i('地点相册-地图模式缩放、拖动、旋转 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.拖动地图模式页面；');

  await dt.sleep();
  dt.log.i('预期结果2.拖动反馈正常，页面无异常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.放大缩小地图模式页面；');

  await dt.sleep();
  dt.log.i('预期结果3.放大缩小反馈正常，页面无异常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.旋转地图模式页面；');

  await dt.sleep();
  dt.log.i('预期结果4.旋转反馈正常，页面无异常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式缩放、拖动、旋转 end');
}

/**
 * 宫格-: [地点相册-地图模式缩放边界值验证]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_016
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid016(dt: Dt) {
  dt.log.i('地点相册-地图模式缩放边界值验证 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.放大地图至最大，查看页面；');

  await dt.sleep();
  dt.log.i('预期结果2.放大过程中，动效过度丝滑，照片归属从城市到精确经纬度街道，地图页面无异常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.缩小地图至最小，查看页面；');

  await dt.sleep();
  dt.log.i('预期结果3.缩小过程中，动效过度丝滑，照片归属从街道到城市，地图页面无异常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击地图上照片缩略图；');

  await dt.sleep();
  dt.log.i('预期结果4.进入城市想写照片宫格页正常，照片显示无异常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式缩放边界值验证 end');
}

/**
 * 宫格-: [地点相册-地图模式定位当前位置]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_017
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid017(dt: Dt) {
  dt.log.i('地点相册-地图模式定位当前位置 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击当前定位按钮；');

  await dt.sleep();
  dt.log.i('预期结果2.当前位置居中显示，并显示周围照片，切换平滑；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.再次点击当前定位按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.回到默认状态，（以版本的国家决定，如果是中国版本则以中国居中显示），切换平滑；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.再次点击当前定位按钮；');

  await dt.sleep();
  dt.log.i('预期结果4.当前位置居中显示，并显示周围照片，切换平滑；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式定位当前位置 end');
}

/**
 * 宫格-: [地点相册-指北针定位]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_018
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid018(dt: Dt) {
  dt.log.i('地点相册-指北针定位 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.旋转地图；');

  await dt.sleep();
  dt.log.i('STEP 3.点击指北针按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.地图自动旋转到上北下南显示；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.再次点击指北针；');

  await dt.sleep();
  dt.log.i('预期结果4.界面无变化；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-指北针定位 end');
}

/**
 * 宫格-: [地点相册-地图模式，相册封图数目显示限值]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_019
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid019(dt: Dt) {
  dt.log.i('地点相册-地图模式，相册封图数目显示限值 start');
  dt.log.i('STEP 1.打开图库测试工具，添加当前地点相册照片；');

  await dt.sleep();
  dt.log.i('STEP 2.一直照片添加至99+，返回地图模式查看相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果2.地图模式下，当前地点相册封图显示为最新照片的缩略图，右上角数目显示99+；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击相册封图；');

  await dt.sleep();
  dt.log.i('预期结果3.成功进入当前位置地点相册照片宫格页，照片数目正确，显示正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式，相册封图数目显示限值 end');
}

/**
 * 宫格-: [地点相册-地图模式，2个城市相册合并]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_020
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.存在2个地点相邻很近其相册足以合并（A和B）；
 */
async function multimediaGalleryMapAlbumPalacegrid020(dt: Dt) {
  dt.log.i('地点相册-地图模式，2个城市相册合并 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地图模式，找到地点A和地点B的相册，查看显示；');

  await dt.sleep();
  dt.log.i('预期结果2.地点相册A和地点相册B合并展示，合并后缩略图为两者中最新的照片缩略图，照片数目相加；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击合并的相册，查看跳转及页面显示；');

  await dt.sleep();
  dt.log.i('预期结果3.成功跳转至合并后的照片宫格页，宫格页照片数目正确；照片显示正常；排序正确：按拍摄时间倒序；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式，2个城市相册合并 end');
}

/**
 * 宫格-: [地点相册-地图模式，3个以上个城市相册合并]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_021
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.存在3个地点相邻很近其相册足以合并（A，B，C）；
 */
async function multimediaGalleryMapAlbumPalacegrid021(dt: Dt) {
  dt.log.i('地点相册-地图模式，3个以上个城市相册合并 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地图模式，找到地点A、地点B、地点C的相册，查看显示；');

  await dt.sleep();
  dt.log.i('预期结果2.地点相册A、地点相册B、地点相册C合并展示，合并后缩略图为三者中最新的照片缩略图，照片数目相加；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击合并的相册，查看跳转及页面显示；');

  await dt.sleep();
  dt.log.i('预期结果3.成功跳转至合并后的照片宫格页，宫格页照片数目正确；照片显示正常；排序正确：按拍摄时间倒序；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式，3个以上个城市相册合并 end');
}

/**
 * 宫格-: [地点相册-地图模式，相册合并动态化]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_022
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.存在合并的城市相册，由A和B合并而成；
 */
async function multimediaGalleryMapAlbumPalacegrid022(dt: Dt) {
  dt.log.i('地点相册-地图模式，相册合并动态化 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地图模式，找到已合并的相册，一直放大地图，查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果2.合并相册C拆分为相册A和相册B，相册缩略图及数目对应正确；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击分开后的地点相册A，地点相册B，查看跳转，跳转完成后再点击任一图片查看；');

  await dt.sleep();
  dt.log.i('预期结果3.相册拆分后，跳转正常，跳转之后图片浏览正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.返回地图模式，一直缩小地图，查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果4.相册A和相册B合并为一个，合并后的相册缩略图及数目对应正确；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击合并后的地点相册，查看跳转，跳转完成后再点击任一图片查看；');

  await dt.sleep();
  dt.log.i('预期结果5.相册合并后，跳转正常，跳转之后图片浏览正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式，相册合并动态化 end');
}

/**
 * 宫格-: [地图模式，点击相册缩略图跳转照片列表页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_023
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid023(dt: Dt) {
  dt.log.i('地图模式，点击相册缩略图跳转照片列表页 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.地图模式下，点击某城市相册缩略图；');

  await dt.sleep();
  dt.log.i('预期结果2.成功跳转至城市相册照片宫格页面，页面显示正常，数目对应正确；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击任一照片查看；');

  await dt.sleep();
  dt.log.i('预期结果3.照片查看正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式，点击相册缩略图跳转照片列表页 end');
}

/**
 * 宫格-删除: [地图模式，不支持删除地点]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_024
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid024(dt: Dt) {
  dt.log.i('地图模式，不支持删除地点 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.地图模式下，长按点击某城市相册缩略图；');

  await dt.sleep();
  dt.log.i('STEP 3.查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果3.无删除标识，无法删除；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式，不支持删除地点 end');
}

/**
 * 宫格-删除: [地点相册-地图模式下相册缩略图动态更新]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_025
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 2.更新或新增当前地点的照片；
 */
async function multimediaGalleryMapAlbumPalacegrid025(dt: Dt) {
  dt.log.i('地点相册-地图模式下相册缩略图动态更新 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.地图模式下，选择一个城市，点击进入城市相册照片宫格页；');

  await dt.sleep();
  dt.log.i('STEP 3.该地点新增最新的照片；');

  await dt.sleep();
  dt.log.i('预期结果3.照片更新并增加成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.返回地图模式，查看该城市相册的缩略图；');

  await dt.sleep();
  dt.log.i('预期结果4.地图模式下，该城市相册封图更新为最新的照片缩略图，该城市相册照片数目+1；6.删除最新照片成功；7.地图模式下，该城市相册封图还原成刚才的封图，该城市相册照片数目-1；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击该地点，再次进入城市相册照片宫格页；');

  await dt.sleep();
  dt.log.i('STEP 6.删除步骤3新增的图片；');

  await dt.sleep();
  dt.log.i('预期结果6.删除最新照片成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7.返回地图模式，查看该地点相册的缩略图；');

  await dt.sleep();
  dt.log.i('预期结果7.地图模式下，该城市相册封图还原成刚才的封图，该城市相册照片数目-1；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-地图模式下相册缩略图动态更新 end');
}

/**
 * 宫格-滑动: [地图模式下，界面响应及交互验证]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_MapAlbum_Palacegrid_026
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 2.地图模式下存在10个以上城市相册；
 */
async function multimediaGalleryMapAlbumPalacegrid026(dt: Dt) {
  dt.log.i('地图模式下，界面响应及交互验证 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.地图模式下，查看地图模式显示；');

  await dt.sleep();
  dt.log.i('预期结果2.显示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.缩放、滑动、旋转地图；');

  await dt.sleep();
  dt.log.i('预期结果3.手势操作正常，界面反馈丝滑；（指南针旋转速度，地图显示速度丝滑，捏合显示速度）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.多次点击定位按钮；');

  await dt.sleep();
  dt.log.i('预期结果4.恢复原位功能可重复点击，切换丝滑；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击指北针；');

  await dt.sleep();
  dt.log.i('预期结果5.指北恢复丝滑；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.点击A城市进入城市相册照片列表页；');

  await dt.sleep();
  dt.log.i('预期结果6.成功进入A城市相册列表页；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7.点击A城市相册中某一图片或视屏；');

  await dt.sleep();
  dt.log.i('预期结果7.照片查看成功，大图模式正常，视频播放成功；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式下，界面响应及交互验证 end');
}

/**
 * 宫格-滑动: [地图模式下，旋转屏适配]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_MapAlbum_Palacegrid_027
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等

 */
async function multimediaGalleryMapAlbumPalacegrid027(dt: Dt) {
  dt.log.i('地图模式下，旋转屏适配 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.地图模式下，查看地图模式显示；');

  await dt.sleep();
  dt.log.i('预期结果2.显示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.旋转屏幕至横屏；');

  await dt.sleep();
  dt.log.i('预期结果3.地图页旋转适配成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.缩放、滑动、旋转地图；');

  await dt.sleep();
  dt.log.i('预期结果4.操作正常，页面无异常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击A城市进入城市相册照片列表页；');

  await dt.sleep();
  dt.log.i('预期结果5.成功进入A城市相册列表页；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.点击A城市相册中某一图片或视屏；');

  await dt.sleep();
  dt.log.i('预期结果6.照片查看成功，大图模式正常，视频播放成功；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式下，旋转屏适配 end');
}

/**
 * 宫格-视频: [地图模式-城市相册中只有视频时，相册封图显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_MapAlbum_Palacegrid_028
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 3.地点相册只有视频；
 */
async function multimediaGalleryMapAlbumPalacegrid028(dt: Dt) {
  dt.log.i('地图模式-城市相册中只有视频时，相册封图显示 start');
  dt.log.i('STEP 1.打开图库测试工具，进入地图相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.查看该城市相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果2.封图显示正常，为视频缩略图;');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击该城市缩略图，播放视频；');

  await dt.sleep();
  dt.log.i('预期结果3.成功进入城市相册照片宫格页，视频播放正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式-城市相册中只有视频时，相册封图显示 end');
}

/**
 * 宫格-: [拍摄照片时，未授权地理位置权限，未开启GPS]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_029
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.地点相册未授权地理位置，拍摄照片时未开启GPS；
 */
async function multimediaGalleryMapAlbumPalacegrid029(dt: Dt) {
  dt.log.i('拍摄照片时，未授权地理位置权限，未开启GPS start');
  dt.log.i('STEP 1.打开相机，拍照保存；');

  await dt.sleep();
  dt.log.i('STEP 2.打开图库，查看照片默认所在位置；');

  await dt.sleep();
  dt.log.i('预期结果2.照片在默认分类中，未在地点相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拍摄照片时，未授权地理位置权限，未开启GPS end');
}

/**
 * 宫格-: [地图模式，地理地址信息国际化]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_030
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid030(dt: Dt) {
  dt.log.i('地图模式，地理地址信息国际化 start');
  dt.log.i('STEP 1.切换系统语言为英文，打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.查看界面显示；');

  await dt.sleep();
  dt.log.i('预期结果2.界面显示正常，英文翻译正确；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.查看图片显示的位置；');

  await dt.sleep();
  dt.log.i('预期结果3.照片所属城市翻译正确，国际化正确；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图模式，地理地址信息国际化 end');
}

/**
 * 宫格-: [地点相册进入宫格模式]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_031
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid031(dt: Dt) {
  dt.log.i('地点相册进入宫格模式 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市切换至城市宫格模式；');

  await dt.sleep();
  dt.log.i('预期结果2.成功切换至城市相册宫格页；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.查看城市相册宫格页；');

  await dt.sleep();
  dt.log.i('预期结果3.城市相册宫格页展示正常，按城市相册内照片数目降序排列；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击一个城市相册，查看跳转；');

  await dt.sleep();
  dt.log.i('预期结果4.成功跳转至城市相册照片宫格页，按照片拍摄时间降序排列；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册进入宫格模式 end');
}

/**
 * 宫格-删除: [宫格模式，删除城市相册]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_032
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid032(dt: Dt) {
  dt.log.i('宫格模式，删除城市相册 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市切换至城市宫格模式；');

  await dt.sleep();
  dt.log.i('STEP 3.长按某城市相册/点击更多按钮；');

  await dt.sleep();
  dt.log.i('STEP 4.查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果4.无互动，不支持删除城市相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格模式，删除城市相册 end');
}

/**
 * 宫格-: [宫格模式，新建城市相册]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_033
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid033(dt: Dt) {
  dt.log.i('宫格模式，新建城市相册 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市切换至城市宫格模式；');

  await dt.sleep();
  dt.log.i('STEP 3.长按宫格页空白处/点击更多按钮；');

  await dt.sleep();
  dt.log.i('STEP 4.查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果4.无互动，不支持新建城市相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格模式，新建城市相册 end');
}

/**
 * 宫格-: [宫格模式，拖动城市相册自定义排序]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_034
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid034(dt: Dt) {
  dt.log.i('宫格模式，拖动城市相册自定义排序 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市切换至城市宫格模式；');

  await dt.sleep();
  dt.log.i('STEP 3.长按某城市宫格拖动自定义排序；');

  await dt.sleep();
  dt.log.i('STEP 4.查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果4.无互动，不支持自定义排序；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格模式，拖动城市相册自定义排序 end');
}

/**
 * 宫格-删除: [宫格模式-城市相册封图动态更新]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_035
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid035(dt: Dt) {
  dt.log.i('宫格模式-城市相册封图动态更新 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.新增某城市照片；');

  await dt.sleep();
  dt.log.i('STEP 3.切换至城市相册宫格页，查看此城市相册封图；');

  await dt.sleep();
  dt.log.i('预期结果3.封图更新成最新照片；5.封图还原成删除后剩余的照片最新；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.进入此城市相册，删除新增的照片，返回城市相册宫格页；');

  await dt.sleep();
  dt.log.i('STEP 5.查看此城市相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果5.封图还原成删除后剩余的照片最新；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格模式-城市相册封图动态更新 end');
}

/**
 * 宫格-: [宫格模式，更新城市相册排序]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_036
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid036(dt: Dt) {
  dt.log.i('宫格模式，更新城市相册排序 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册；');

  await dt.sleep();
  dt.log.i('STEP 2.新增某城市A照片，使得A照片数量>B城市相册照片数量；');

  await dt.sleep();
  dt.log.i('STEP 3.返回至城市相册宫格页，查看城市相册排序；');

  await dt.sleep();
  dt.log.i('预期结果3.城市相册A的排序变动，排在城市相册B前面；5.城市相册C的排序变动，排在城市相册B后面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.删减某城市C照片，使得C照片数量<B城市相册照片数量；');

  await dt.sleep();
  dt.log.i('STEP 5.返回至城市相册宫格页，查看城市相册排序；');

  await dt.sleep();
  dt.log.i('预期结果5.城市相册C的排序变动，排在城市相册B后面；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格模式，更新城市相册排序 end');
}

/**
 * 宫格-: [进入城市相册照片宫格页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_037
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid037(dt: Dt) {
  dt.log.i('进入城市相册照片宫格页 start');
  dt.log.i('STEP 1.打开图库测试工具，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市缩略图进入城市相册照片宫格页，查看跳转显示；');

  await dt.sleep();
  dt.log.i('预期结果2.跳转成功，页面显示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击城市相册封图进入城市相册照片宫格页，查看跳转显示；');

  await dt.sleep();
  dt.log.i('预期结果3.跳转成功，页面显示正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入城市相册照片宫格页 end');
}

/**
 * 宫格-删除: [清空城市相册所有照片，单选删除，多选删除]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_038
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid038(dt: Dt) {
  dt.log.i('清空城市相册所有照片，单选删除，多选删除 start');
  dt.log.i('STEP 1.打开图库测试工具，进入城市相册照片宫格页；');

  await dt.sleep();
  dt.log.i('STEP 2.单选图片，删除图片至清空城市相册A；');

  await dt.sleep();
  dt.log.i('预期结果2.删除照片成功，清空相册成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.返回宫格页及地图页，查看城市相册A显示；');

  await dt.sleep();
  dt.log.i('预期结果3.宫格页及地图页城市A消失；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.多选图片；删除图片至请空城市相册B；');

  await dt.sleep();
  dt.log.i('预期结果4.删除照片成功，清空相册成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.返回宫格页及地图页，查看城市相册B显示；');

  await dt.sleep();
  dt.log.i('预期结果5.宫格页及地图页城市B消失；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('清空城市相册所有照片，单选删除，多选删除 end');
}

































































