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


export default function multimediaGalleryFilesdelete000012Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesdelete000012Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesdelete000012').init();
      dt.log.i('beforeAll MultimediaGalleryFilesdelete000012 start');
      dt.log.i('beforeAll MultimediaGalleryFilesdelete000012 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryFilesdelete000012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [存储空间占满时(系统剩余300M)，大图/宫格删除] TID: Multimedia_Gallery_Files_delete_000012
      await multimediaGalleryFilesdelete000012(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryFilesdelete000012').init();
      dt.log.i('afterEach MultimediaGalleryFilesdelete000012 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesdelete000012 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryFilesdelete000012').init();
      dt.log.i('afterAll MultimediaGalleryFilesdelete000012 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesdelete000012 finish');
    });
  });
}
/**
 * 宫格-删除: [存储空间占满时(系统剩余300M)，大图/宫格删除]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_000012
 * 前置条件
 * 手机资源预制存储空间快占满（系统剩余300M),（方法一：使用命令：1、hdc shell  2、cd storage/cloud/100/data/
 dd if=/dev/zero of=ab.txt bs=1G count=150（需要额外设置新的占用的空间，比如150=设置占用150G空间)
 方法二：下载各种应用占满空间）
 */
async function multimediaGalleryFilesdelete000012(dt: Dt) {
  dt.log.i('存储空间占满时(系统剩余300M)，大图/宫格删除 start');
  dt.log.i('STEP 1、从不同入口打开大图删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await dt.sleep();
  dt.log.i('STEP 2、从不同入口宫格多选删除，包括相机入口，照片页入口（三宫格，四宫格），相册入口（系统相册（图片相册视频相册，收藏相册，最近删除相册），用户创建相册入口，智慧相册入口（地点相册，人像相册，分类相册），来源相册），精彩时刻入口');

  await dt.sleep();
  dt.log.i('预期结果2、大图删除成功，无异常 3、宫格删除大图成功，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存储空间占满时(系统剩余300M)，大图/宫格删除 end');
}
