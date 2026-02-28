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
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function MultimediaGallerySmartAlbumClone(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerySmartAlbumCloneTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerySmartAlbumClone').init();
      dt.log.i('beforeAll MultimediaGallerySmartAlbumClone start');
      dt.log.i('beforeAll MultimediaGallerySmartAlbumClone finish');
    });
    /**
     * 打开大图
     */
    it('beforeMultimediaGallerySmartAlbumClone', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_SmartAlbumClone_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [克隆人像移除优先分析相机目录照片的限制] TID: Multimedia_Gallery_SmartAlbumClone_001
      await Multimedia_Gallery_SmartAlbumClone_001(dt);
    });
    it('Multimedia_Gallery_SmartAlbumClone_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库克隆本地xxx克隆检查] TID: Multimedia_Gallery_SmartAlbumClone_002
      await Multimedia_Gallery_SmartAlbumClone_002(dt);
    });
    it('Multimedia_Gallery_SmartAlbumClone_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库克隆云图xxx克隆检查] TID: Multimedia_Gallery_SmartAlbumClone_003
      await Multimedia_Gallery_SmartAlbumClone_003(dt);
    });
    it('Multimedia_Gallery_SmartAlbumClone_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [来源相册克隆后直接显示（xxx）] TID: Multimedia_Gallery_SmartAlbumClone_004
      await Multimedia_Gallery_SmartAlbumClone_004(dt);
    });
    it('Multimedia_Gallery_SmartAlbumClone_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库克隆本地图xxx克隆检查] TID: Multimedia_Gallery_SmartAlbumClone_005
      await Multimedia_Gallery_SmartAlbumClone_005(dt);
    });
    it('Multimedia_Gallery_SmartAlbumClone_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库克隆云图xxx克隆检查] TID: Multimedia_Gallery_SmartAlbumClone_006
      await Multimedia_Gallery_SmartAlbumClone_006(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerySmartAlbumClone').init();
      dt.log.i('afterEach MultimediaGallerySmartAlbumClone start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerySmartAlbumClone finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerySmartAlbumClone').init();
      dt.log.i('afterAll MultimediaGallerySmartAlbumClone start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerySmartAlbumClone finish');
    });
  });
}

// DT步骤
/**
 * 大图-: [克隆人像移除优先分析相机目录照片的限制]
 * GROUP: 大图 MODULE: TID: Multimedia_Gallery_SmartAlbumClone_001
 * 前置条件
 * 1、xxx手机中1000张人像照片，且照片分析完，生成人像相册，给其中的三个人像相册命名
 2、xxx手机中1000张人像照片，暂未分析
 3、xxx手机电量大于50%且不温控
 */
async function Multimedia_Gallery_SmartAlbumClone_001(dt: Dt) {
  dt.log.i('克隆人像移除优先分析相机目录照片的限制 start');
  dt.log.i('STEP 1、手机按照预置条件完成资源预置后立即进行xxx克隆；');

  
  dt.log.i('STEP 2、克隆完成后查看xxx手机相册人像页面；');

  
  dt.log.i('预期结果2、3个已命名人像可以直接看到；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、手机充电灭屏，同步查看CV日志;');

  
  dt.log.i('预期结果3、CV日志正常分析；');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、静置灭屏分析完成后查看手机相册人像页面。');

  
  dt.log.i('预期结果4、可以生成其他人像相册，对比xxx人像，有生成其他xxx未命名人像。');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('克隆人像移除优先分析相机目录照片的限制 end');
}

/**
 * 大图-视频: [图库克隆本地xxx克隆检查]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_SmartAlbumClone_002
 * 前置条件
 * 1、xxx手机图库未分析完成，存在已分析的人像，同时存在已命名和未命名人像，存在分类，存在不同三方的来源图片视频，在已生成的时刻；
 2、xxx本地存在未分析的图片视频；
 */
async function Multimedia_Gallery_SmartAlbumClone_002(dt: Dt) {
  dt.log.i('图库克隆本地xxx克隆检查 start');
  dt.log.i('STEP 1、手机按照预置条件完成资源预置后立即进行xxx克隆；');

  
  dt.log.i('STEP 2、克隆完成后查看xxx手机相册人像页面，观察并记录人像封面；');

  
  dt.log.i('预期结果2、已命名人像直接显示在人像页面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看地点相册；');

  
  dt.log.i('预期结果3、地点相册地图模式直接显示，城市模式需要息屏充电分析后更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、查看来源相册；');

  
  dt.log.i('预期结果4、来源相册直接更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 5、查看时刻；');

  
  dt.log.i('预期结果5、时刻直接显示；');
  
  // 确认组件存在
  
  dt.log.i('STEP 6、手机充电灭屏；待分析完成后重复步骤2-4。');

  
  dt.log.i('预期结果6、可以继续分析，对比xxx分析完成后人像封面根据xxx优选算法更新，时刻、地点城市模式会继续更新');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库克隆本地xxx克隆检查 end');
}

/**
 * 大图-视频: [图库克隆云图xxx克隆检查]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_SmartAlbumClone_003
 * 前置条件
 * 1、xxx手机登录云账号，同步图库图片，未分析完成，存在已分析的人像，同时存在已命名和未命名人像，存在分类，存在不同三方的来源图片视频，存在已生成的时刻；
 2、xxx登录账号打开云同步，但不分析。
 */
async function Multimedia_Gallery_SmartAlbumClone_003(dt: Dt) {
  dt.log.i('图库克隆云图xxx克隆检查 start');
  dt.log.i('STEP 1、手机按照预置条件完成资源预置后立即进行xxx克隆；');

  
  dt.log.i('STEP 2、克隆完成后查看xxx手机相册人像页面，观察并记录人像封面；');

  
  dt.log.i('预期结果2、已命名人像直接显示在人像页面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看地点相册；');

  
  dt.log.i('预期结果3、地点相册地图模式直接显示，城市模式需要息屏充电分析后更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、查看来源相册；');

  
  dt.log.i('预期结果4、来源相册直接更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 5、查看时刻；');

  
  dt.log.i('预期结果5、时刻直接显示；');
  
  // 确认组件存在
  
  dt.log.i('STEP 6、手机充电灭屏；待分析完成后重复步骤2-4。');

  
  dt.log.i('预期结果6、可以继续分析，对比xxx分析完成后人像封面根据xxx优选算法更新，时刻、地点城市模式会继续更新');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库克隆云图xxx克隆检查 end');
}

/**
 * 大图-: [来源相册克隆后直接显示（xxx）]
 * GROUP: 大图 MODULE: TID: Multimedia_Gallery_SmartAlbumClone_004
 * 前置条件
 * 1、xxx手机已预置图库资源并完成分析
 */
async function Multimedia_Gallery_SmartAlbumClone_004(dt: Dt) {
  dt.log.i('来源相册克隆后直接显示（xxx） start');
  dt.log.i('STEP 1、启动克隆，从xxx克隆到xxx');

  
  dt.log.i('STEP 2、克隆完成后，打开图库查看分类相册');

  
  dt.log.i('预期结果2、xxx分类能完整的克隆过来，显示、命名、图片数量等和双一致。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('来源相册克隆后直接显示（xxx） end');
}

/**
 * 大图-视频: [图库克隆本地图xxx克隆检查]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_SmartAlbumClone_005
 * 前置条件
 * 1、准备xxx手机A本地存在图片视频资源，未分析完成，存在已分析的人像，同时存在已命名和未命名人像，存在分类，存在不同三方的来源图片视频，存在已生成的时刻；
 2、xxx手机B（测试机）本地存在未分析的图片视频；
 3、手机A、B支持时刻移出素材、添加素材、重命名、更换封面的先在手机A进行移出素材、添加素材、重命名、更换封面等操作再进行克隆。
 */
async function Multimedia_Gallery_SmartAlbumClone_005(dt: Dt) {
  dt.log.i('图库克隆本地图xxx克隆检查 start');
  dt.log.i('STEP 1、手机按照预置条件完成资源预置后立即进行A-B克隆；');

  
  dt.log.i('STEP 2、克隆完成后查看xxx手机相册人像页面，观察并记录人像封面；');

  
  dt.log.i('预期结果2、B人像显示与A一致；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看地点相册；');

  
  dt.log.i('预期结果3、地点相册地图模式直接显示，城市模式需要息屏充电分析后更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、查看来源相册；');

  
  dt.log.i('预期结果4、来源相册直接更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 5、查看时刻；');

  
  dt.log.i('预期结果5、时刻直接显示；');
  
  // 确认组件存在
  
  dt.log.i('STEP 6、手机充电灭屏；待分析完成后重复步骤2-4。');

  
  dt.log.i('预期结果6、可以继续分析，对比手机A分析完成后人像封面根据xxx优选算法更新，时刻、地点城市模式会继续更新');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库克隆本地图xxx克隆检查 end');
}

/**
 * 大图-视频: [图库克隆云图xxx克隆检查]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_SmartAlbumClone_006
 * 前置条件
 * 1、准备xxx手机A登录云账号，同步图库图片，未分析完成，存在已分析的人像，同时存在已命名和未命名人像，存在分类，存在不同三方的来源图片视频，存在已生成的时刻；
 2、xxx手机B（测试机）登录账号打开云同步，但不分析。
 */
async function Multimedia_Gallery_SmartAlbumClone_006(dt: Dt) {
  dt.log.i('图库克隆云图xxx克隆检查 start');
  dt.log.i('STEP 1、手机按照预置条件完成资源预置后立即进行A-B克隆；');

  
  dt.log.i('STEP 2、克隆完成后查看xxx手机相册人像页面，观察并记录人像封面；');

  
  dt.log.i('预期结果2、B人像显示与A一致；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看地点相册；');

  
  dt.log.i('预期结果3、地点相册地图模式直接显示，城市模式需要息屏充电分析后更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 4、查看来源相册；');

  
  dt.log.i('预期结果4、来源相册直接更新；');
  
  // 确认组件存在
  
  dt.log.i('STEP 5、查看时刻；');

  
  dt.log.i('预期结果5、时刻直接显示；');
  
  // 确认组件存在
  
  dt.log.i('STEP 6、手机充电灭屏；待分析完成后重复步骤2-4。');

  
  dt.log.i('预期结果6、可以继续分析，对比手机A分析完成后人像封面根据xxx优选算法更新，时刻、地点城市模式会继续更新');
  
  // 确认组件存在
  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库克隆云图xxx克隆检查 end');
}

