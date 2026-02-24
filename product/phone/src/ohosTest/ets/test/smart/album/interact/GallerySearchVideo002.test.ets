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

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2023. All rights reserved.
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














export default function MultimediaGallerySearchVideo002Test(): void {




  // Defines a test suite. Two parameters are supported: test suite name and test suite function.




  // Presets an action, which is performed only once before all test cases of the test suite start.




  // This API supports only one parameter: preset action function.




  describe('MultimediaGallerySearchVideo002Test', (): void => {




    /**
     *
     *
     *
     *
     * 确认当前图库app处于启动状态
     *
     *
     *
     *
     */




    beforeAll(async (): Promise<void> => {




      await AppStart.photos();




      const dt = await new Dt('beforeAllMultimediaGallerySearchVideo002').init();




      dt.log.i('beforeAll MultimediaGallerySearchVideo002 start');




      dt.log.i('beforeAll MultimediaGallerySearchVideo002 finish');




    });




    /**
     *
     *
     *
     *
     * 打开大图
     *
     *
     *
     *
     */




    run('MultimediaGallerySearchVideo002', Level.LEVEL4, async (dt: Dt): Promise<void> => {




      //  智慧图库-视频用例: [纯云端视频无法被搜索标签] TID: Multimedia_Gallery_SearchVideo_002




      await MultimediaGallerySearchVideo002(dt);




    });




    /**
     *
     *
     *
     *
     * 确保每次测试完毕回到大图页
     *
     *
     *
     *
     */




    afterEach(async (): Promise<void> => {




      const dt = await new Dt('afterEachMultimediaGallerySearchVideo002').init();




      dt.log.i('afterEach MultimediaGallerySearchVideo002 start');




      await dt.sleep(DELAY.short);




      dt.log.i('afterEach MultimediaGallerySearchVideo002 finish');




    });









    /**
     *
     *
     *
     *
     * 退出大图 回到时间线页面
     *
     *
     *
     *
     */




    afterAll(async (): Promise<void> => {




      const dt = await new Dt('afterAllMultimediaGallerySearchVideo002').init();




      dt.log.i('afterAll MultimediaGallerySearchVideo002 start');




      await Exit.browser();




      dt.log.i('afterAll MultimediaGallerySearchVideo002 finish');




    });




  });




}




/**
 *
 *
 *
 *
 * 智慧图库-视频: [纯云端视频无法被搜索标签]
 *
 *
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_SearchVideo_002
 *
 *
 *
 *
 * 前置条件
 *
 *
 *
 *
 * 1、云端存在视频测试资源，本地不存在
 *
 *
 *
 *
 */




async function MultimediaGallerySearchVideo002(dt: Dt) {




  dt.log.i('纯云端视频无法被搜索标签 start');




  dt.log.i('STEP 1、进入搜索页面，手动输入关键字，如“猫”');









  await dt.sleep();




  dt.log.i('预期结果1、不能搜索到视频结果，纯云视频不分析');




  await dt.sleep(DELAY.short);














  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');




  // 打印当前存在compid的组件




  await dt.showComponentsWithin();




  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在




  await dt.assertComponent(PageTitle.index, true);




  dt.log.i('纯云端视频无法被搜索标签 end');




}








