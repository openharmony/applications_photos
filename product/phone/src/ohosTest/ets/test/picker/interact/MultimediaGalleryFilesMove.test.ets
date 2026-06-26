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

export default function MultimediaGalleryFilesMove(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesMoveTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesMove').init();
      dt.log.i('beforeAll MultimediaGalleryFilesMove start');
      dt.log.i('beforeAll MultimediaGalleryFilesMove finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryFilesMove', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryFilesmove005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [从相机进大图，添加照片到新建相册成功] TID: Multimedia_Gallery_Files_move_005
      await multimediaGalleryFilesmove005(dt);
    });
    run('MultimediaGalleryFilesmove006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [从FA卡片进大图，添加图片到新建相册成功] TID: Multimedia_Gallery_Files_move_006
      await multimediaGalleryFilesmove006(dt);
    });
    run('MultimediaGalleryFilesrecover001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册，大图恢复图片/视频成功] TID: Multimedia_Gallery_Files_recover_001
      await multimediaGalleryFilesrecover001(dt);
    });
    run('MultimediaGalleryFilesrecover002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册，宫格恢复图片/视频成功（单个+批量）] TID: Multimedia_Gallery_Files_recover_002
      await multimediaGalleryFilesrecover002(dt);
    });
    run('MultimediaGalleryFilesrecover003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [新建相册内容删除后，可恢复到新建相册] TID: Multimedia_Gallery_Files_recover_003
      await multimediaGalleryFilesrecover003(dt);
    });
    run('MultimediaGalleryFilesrecover005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频相册内容删除后，可恢复到视频相册] TID: Multimedia_Gallery_Files_recover_005
      await multimediaGalleryFilesrecover005(dt);
    });
    run('MultimediaGalleryFilesrecover006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏相册内容删除后（不在新建相册），可恢复到收藏相册、图片相册/视频相册] TID: Multimedia_Gallery_Files_recover_006
      await multimediaGalleryFilesrecover006(dt);
    });
    run('MultimediaGalleryFilesrecover007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏相册内容删除后（也在新建相册），可恢复到收藏相册、图片相册/视频相册、新建相册] TID: Multimedia_Gallery_Files_recover_007
      await multimediaGalleryFilesrecover007(dt);
    });
    run('MultimediaGalleryFilesremove001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [用户创建相册，大图移除图片/视频成功] TID: Multimedia_Gallery_Files_remove_001
      await multimediaGalleryFilesremove001(dt);
    });
    run('MultimediaGalleryFilesremove002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [用户创建相册，宫格移除图片/视频成功（单个+批量）] TID: Multimedia_Gallery_Files_remove_002
      await multimediaGalleryFilesremove002(dt);
    });
    run('MultimediaGalleryFilesremove003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [用户创建相册，文件移除时，不进入最近删除] TID: Multimedia_Gallery_Files_remove_003
      await multimediaGalleryFilesremove003(dt);
    });
    run('MultimediaGalleryFilesRenameAndmove001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [自建相册重命名后添加照片/视频] TID: Multimedia_Gallery_Files_RenameAndmove_001
      await multimediaGalleryFilesRenameAndmove001(dt);
    });
    run('MultimediaGalleryFilesRenameAndmove002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [新建相册重命名后添加照片/视频] TID: Multimedia_Gallery_Files_RenameAndmove_002
      await multimediaGalleryFilesRenameAndmove002(dt);
    });
    run('MultimediaGalleryFilesScreenshot001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [截图相册全选照片移动至相机相册] TID: Multimedia_Gallery_Files_Screenshot_001
      await multimediaGalleryFilesScreenshot001(dt);
    });
    run('MultimediaGalleryMapAlbum001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [图库地点相册横竖屏切换检查] TID: Multimedia_Gallery_MapAlbum_001
      await multimediaGalleryMapAlbum001(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [进入地点相册] TID: Multimedia_Gallery_MapAlbum_Palacegrid_001
      await multimediaGalleryMapAlbumPalacegrid001(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册隐私申明] TID: Multimedia_Gallery_MapAlbum_Palacegrid_002
      await multimediaGalleryMapAlbumPalacegrid002(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册隐私申明-初始化后再次进入] TID: Multimedia_Gallery_MapAlbum_Palacegrid_003
      await multimediaGalleryMapAlbumPalacegrid003(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册隐私申明-停止服务后再次进入] TID: Multimedia_Gallery_MapAlbum_Palacegrid_004
      await multimediaGalleryMapAlbumPalacegrid004(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册隐私申明-关于隐私申明内容] TID: Multimedia_Gallery_MapAlbum_Palacegrid_005
      await multimediaGalleryMapAlbumPalacegrid005(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册隐私申明-隐私申明内容比对] TID: Multimedia_Gallery_MapAlbum_Palacegrid_006
      await multimediaGalleryMapAlbumPalacegrid006(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册-关于第三方SDK] TID: Multimedia_Gallery_MapAlbum_Palacegrid_007
      await multimediaGalleryMapAlbumPalacegrid007(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [地点相册地图模式与宫格模式切换] TID: Multimedia_Gallery_MapAlbum_Palacegrid_008
      await multimediaGalleryMapAlbumPalacegrid008(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [地点相册封图动态更新] TID: Multimedia_Gallery_MapAlbum_Palacegrid_009
      await multimediaGalleryMapAlbumPalacegrid009(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [中国发货机器进入地点相册地图模式] TID: Multimedia_Gallery_MapAlbum_Palacegrid_010
      await multimediaGalleryMapAlbumPalacegrid010(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库相册列表，地点相册国际化] TID: Multimedia_Gallery_MapAlbum_Palacegrid_012
      await multimediaGalleryMapAlbumPalacegrid012(dt);
    });
    run('MultimediaGalleryMapAlbumPalacegrid013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [地点相册中只有视频时，相册封图显示] TID: Multimedia_Gallery_MapAlbum_Palacegrid_013
      await multimediaGalleryMapAlbumPalacegrid013(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryFilesMove').init();
      dt.log.i('afterEach MultimediaGalleryFilesMove start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesMove finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryFilesMove').init();
      dt.log.i('afterAll MultimediaGalleryFilesMove start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesMove finish');
    });
  });
}

// DT步骤
/**
 * 宫格-大图: [从相机进大图，添加照片到新建相册成功]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_move_005
 * 前置条件
 * 1、图库有新建相册
 */
async function multimediaGalleryFilesmove005(dt: Dt) {
  dt.log.i('从相机进大图，添加照片到新建相册成功 start');
  dt.log.i('STEP 1、打开相机拍摄1张图片/视频后，点击左下角，进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、进入大图正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击更多-“移动到”，选择新建相册');

  await dt.sleep();
  dt.log.i('预期结果2.1、当前大图添加成功，自动返回大图页，大图保持不变；被添加的文件显示在目标相册中2.2、图片和视频相册图片数量不变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.1、大图第二次添加到相同相册3.2、大图二次添加到其他相册');

  await dt.sleep();
  dt.log.i('预期结果3.1、出现替换为新文件或者跳过当前文件，取消移动的提示框；3.2、添加成功自动返回大图页，大图保持不变；被添加的文件显示在目标相册中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、切换到下一张大图，进行添加');

  await dt.sleep();
  dt.log.i('预期结果4、下一张大图添加成功，显示在目标相册中');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('从相机进大图，添加照片到新建相册成功 end');
}

/**
 * 宫格-大图: [从FA卡片进大图，添加图片到新建相册成功]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_move_006
 * 前置条件
 * 1、图库有新建相册
 */
async function multimediaGalleryFilesmove006(dt: Dt) {
  dt.log.i('从FA卡片进大图，添加图片到新建相册成功 start');
  dt.log.i('STEP 1、从桌面默认FA卡片进大图');

  await dt.sleep();
  dt.log.i('STEP 2、点击更多-“添加到相册”');

  await dt.sleep();
  dt.log.i('预期结果2、拉起添加到界面，相册列表只有用户新建相册，不显示预制相册；显示符合UX设计；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、添加到界面-点击1个新建相册');

  await dt.sleep();
  dt.log.i('预期结果3.1、直接添加，并返回大图页，大图保持不变；3.2、图片和视频相册图片数量不变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、进入新建相册查看');

  await dt.sleep();
  dt.log.i('预期结果4、当前大图显示在新建相册中；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('从FA卡片进大图，添加图片到新建相册成功 end');
}

/**
 * 宫格-删除: [最近删除相册，大图恢复图片/视频成功]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_recover_001
 * 前置条件
 * 1、图库最近删除相册有图片、视频
 */
async function multimediaGalleryFilesrecover001(dt: Dt) {
  dt.log.i('最近删除相册，大图恢复图片/视频成功 start');
  dt.log.i('STEP 1、最近删除相册，打开图片/视频大图，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果1、恢复的图片从大图页消失，内容刷新到下一张；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、分别在年、月、日视图、相册页查看刚恢复照片');

  await dt.sleep();
  dt.log.i('预期结果2、图片恢复到年、月、日视图以及图片相册，显示正常，图片相册数量增加1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册，大图恢复图片/视频成功 end');
}

/**
 * 宫格-删除: [最近删除相册，宫格恢复图片/视频成功（单个+批量）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_recover_002
 * 前置条件
 * 1、图库最近删除相册有大量图片、视频
 */
async function multimediaGalleryFilesrecover002(dt: Dt) {
  dt.log.i('最近删除相册，宫格恢复图片/视频成功（单个+批量） start');
  dt.log.i('STEP 1、最近删除相册，点击更多多选-进入多选，选择1个图片/视频，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果1、图片、视频从宫格页消失，有消失动画；图片恢复到图片相册，视频恢复到视频相册，显示正常，图片和视频相册数量增加1；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、再点击全选，选择全部图片+视频，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果2、所有图片、视频从宫格消失，宫格显示空图；图片全部恢复到图片相册，视频全部恢复到视频相册，显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册，宫格恢复图片/视频成功（单个+批量） end');
}

/**
 * 宫格-删除: [新建相册内容删除后，可恢复到新建相册]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_recover_003
 * 前置条件
 * 1、图库最近删除相册有图片、视频
 */
async function multimediaGalleryFilesrecover003(dt: Dt) {
  dt.log.i('新建相册内容删除后，可恢复到新建相册 start');
  dt.log.i('STEP 1、最近删除相册，选择从新建相册删除图片/视频，大图/宫格-多选，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果1、文件从最近删除消失，恢复到新建相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新建相册内容删除后，可恢复到新建相册 end');
}

/**
 * 宫格-删除: [视频相册内容删除后，可恢复到视频相册]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_recover_005
 * 前置条件
 * 1、图库最近删除相册有图片、视频
 */
async function multimediaGalleryFilesrecover005(dt: Dt) {
  dt.log.i('视频相册内容删除后，可恢复到视频相册 start');
  dt.log.i('STEP 1、最近删除相册，打开视频大图，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果1、视频从大图页消失，刷新到下一张；恢复后的视频显示在视频相册，视频相册数量增加3、视频从宫格页消失，有消失动画；恢复后的视频显示在视频相册，视频相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、或宫格页多选视频，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果3、视频从宫格页消失，有消失动画；恢复后的视频显示在视频相册，视频相册数量增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频相册内容删除后，可恢复到视频相册 end');
}

/**
 * 宫格-收藏: [收藏相册内容删除后（不在新建相册），可恢复到收藏相册、图片相册/视频相册]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_recover_006
 * 前置条件
 * 1、图库最近删除相册有收藏的图片、视频，无新建相册
 */
async function multimediaGalleryFilesrecover006(dt: Dt) {
  dt.log.i('收藏相册内容删除后（不在新建相册），可恢复到收藏相册、图片相册/视频相册 start');
  dt.log.i('STEP 1、从收藏相册删除图片、视频（不在新建相册）');

  await dt.sleep();
  dt.log.i('STEP 2、再从最近删除恢复仅图片、仅视频、图片+视频');

  await dt.sleep();
  dt.log.i('预期结果2、恢复的图片显示在恢复到收藏相册、图片相册中，恢复的视频显示在收藏相册、视频相册中；恢复数量正确；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏相册内容删除后（不在新建相册），可恢复到收藏相册、图片相册/视频相册 end');
}

/**
 * 宫格-收藏: [收藏相册内容删除后（也在新建相册），可恢复到收藏相册、图片相册/视频相册、新建相册]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_recover_007
 * 前置条件
 * 1、图库最近删除相册有收藏的图片、视频
 */
async function multimediaGalleryFilesrecover007(dt: Dt) {
  dt.log.i('收藏相册内容删除后（也在新建相册），可恢复到收藏相册、图片相册/视频相册、新建相册 start');
  dt.log.i('STEP 1、从收藏相册删除图片、视频（也在多个新建相册中）');

  await dt.sleep();
  dt.log.i('STEP 2、再从最近删除恢复仅图片、仅视频、图片+视频');

  await dt.sleep();
  dt.log.i('预期结果2、恢复的图片显示在收藏相册、图片相册、所在的新建相册中，恢复的视频显示在收藏相册、视频相册、所在的新建相册中；恢复数量正确；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏相册内容删除后（也在新建相册），可恢复到收藏相册、图片相册/视频相册、新建相册 end');
}

/**
 * 宫格-视频: [用户创建相册，大图移除图片/视频成功]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_remove_001
 * 前置条件
 * 1、图库有用户创建相册（非空）
 */
async function multimediaGalleryFilesremove001(dt: Dt) {
  dt.log.i('用户创建相册，大图移除图片/视频成功 start');
  dt.log.i('STEP 1、用户创建相册，只有1个图片/视频，进入大图-垃圾桶按钮”，确认删除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果1、文件移除成功，返回宫格，显示空界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、用户创建相册，有多个图片/视频，选择第一个/中间、最后1个图片/视频，分别进入大图-垃圾桶按钮”，确认删除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果2、第一个/中间文件移除成功，自动切到下一个；最后1个文件移除成功，自动切到上一个；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、操作步骤1/2，弹出移除确认弹框-点击取消/移除');

  await dt.sleep();
  dt.log.i('预期结果3、弹出移除确认弹框，提示“是否删除此图片？”/“是否删除此视频？”，显示符合UX设计；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('是否删除此图片？'));
  dt.log.i('STEP 4、按顺序连续操作删除，查看结果');

  await dt.sleep();
  dt.log.i('预期结果4、大图删除正常，自动切换下一张流畅，不卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、滑动浏览到任意大图删除，多次操作，查看结果');

  await dt.sleep();
  dt.log.i('预期结果5、大图删除正常，自动切换下一张流畅，不卡顿');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册，大图移除图片/视频成功 end');
}

/**
 * 宫格-视频: [用户创建相册，宫格移除图片/视频成功（单个+批量）]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_remove_002
 * 前置条件
 * 1、图库有用户创建相册（非空）
 */
async function multimediaGalleryFilesremove002(dt: Dt) {
  dt.log.i('用户创建相册，宫格移除图片/视频成功（单个+批量） start');
  dt.log.i('STEP 1、用户创建相册，多选模式-选择1个图片，进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果1 2、弹出提示“是否移除此文件？”，显示符合UX设计；3 4 5、弹出提示“是否移除N个文件？”，显示符合UX设计；6 7、弹出提示“是否移除全部文件？”，显示符合UX设计；1 2 3 4 5 6、点击移除，文件从本相册移除，有移除动画；实体文件不会删除进“最近删除”；7、所有文件从本相册移除，显示空宫格页；实体文件不会删除进“最近删除”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('是否移除此文件？'));
  dt.log.i('STEP 2、用户创建相册，多选模式-选择1个视频，进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('STEP 3、用户创建相册，多选模式-选择多个（N个：仅图片），进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果3 4 5、弹出提示“是否移除N个文件？”，显示符合UX设计；6 7、弹出提示“是否移除全部文件？”，显示符合UX设计；1 2 3 4 5 6、点击移除，文件从本相册移除，有移除动画；实体文件不会删除进“最近删除”；7、所有文件从本相册移除，显示空宫格页；实体文件不会删除进“最近删除”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('是否移除N个文件？'));
  dt.log.i('STEP 4、用户创建相册，多选模式-选择多个（N个：仅视频），进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('STEP 5、用户创建相册，多选模式-选择多个（N个：仅图片、仅视频、图片+视频），进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('STEP 6、用户创建相册，多选模式-全选（仅图片/仅视频/图片+视频），进行移除，查看结果；');

  await dt.sleep();
  dt.log.i('预期结果6 7、弹出提示“是否移除全部文件？”，显示符合UX设计；1 2 3 4 5 6、点击移除，文件从本相册移除，有移除动画；实体文件不会删除进“最近删除”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('是否移除全部文件？'));
  dt.log.i('预期结果7、所有文件从本相册移除，显示空宫格页；实体文件不会删除进“最近删除”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('最近删除'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册，宫格移除图片/视频成功（单个+批量） end');
}

/**
 * 宫格-删除: [用户创建相册，文件移除时，不进入最近删除]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_remove_003
 * 前置条件
 * 1、图库有用户创建相册（非空），最近删除不显示
 */
async function multimediaGalleryFilesremove003(dt: Dt) {
  dt.log.i('用户创建相册，文件移除时，不进入最近删除 start');
  dt.log.i('STEP 1、用户创建相册，大图/多选图片、视频，操作移除后，查看最近删除');

  await dt.sleep();
  dt.log.i('预期结果1、点击移除，文件从本相册移除，有移除动画；最近删除不显示，移除的文件不进入“最近删除”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('最近删除'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册，文件移除时，不进入最近删除 end');
}

/**
 * 宫格-视频: [自建相册重命名后添加照片/视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_RenameAndmove_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频
 */
async function multimediaGalleryFilesRenameAndmove001(dt: Dt) {
  dt.log.i('自建相册重命名后添加照片/视频 start');
  dt.log.i('STEP 1、打开自建相册，从更多里面修改相册名称后添加照片');

  await dt.sleep();
  dt.log.i('预期结果1、照片添加成功，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('自建相册重命名后添加照片/视频 end');
}

/**
 * 宫格-视频: [新建相册重命名后添加照片/视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_RenameAndmove_002
 * 前置条件
 * 1、图库中存在不同格式的照片和视频
 */
async function multimediaGalleryFilesRenameAndmove002(dt: Dt) {
  dt.log.i('新建相册重命名后添加照片/视频 start');
  dt.log.i('STEP 1、新建相册，直接重命名后添加照片');

  await dt.sleep();
  dt.log.i('预期结果1、照片添加成功，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新建相册重命名后添加照片/视频 end');
}

/**
 * 宫格-格式: [截图相册全选照片移动至相机相册]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Files_Screenshot_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频
 */
async function multimediaGalleryFilesScreenshot001(dt: Dt) {
  dt.log.i('截图相册全选照片移动至相机相册 start');
  dt.log.i('STEP 1、从截图相册全选照片移动到相机相册，回到相册页');

  await dt.sleep();
  dt.log.i('预期结果1、相册页对应相册刷新；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截图相册全选照片移动至相机相册 end');
}

/**
 * 宫格-竖屏: [图库地点相册横竖屏切换检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_MapAlbum_001
 * 前置条件
 * 1、图库资源预置完成并息屏分析；
 2、存在不同来源的相册，地点相册等。
 */
async function multimediaGalleryMapAlbum001(dt: Dt) {
  dt.log.i('图库地点相册横竖屏切换检查 start');
  dt.log.i('STEP 1.打开图库，点击进入地点相册地图模式；');

  await dt.sleep();
  dt.log.i('STEP 2、横竖屏切换，查看页面反馈；');

  await dt.sleep();
  dt.log.i('预期结果2-4、展示动画、切换场景等正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到城市模式，横竖屏切换，查看页面反馈；');

  await dt.sleep();
  dt.log.i('STEP 4、地图模式放大、缩小，横竖屏切换，查看页面反馈。');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库地点相册横竖屏切换检查 end');
}

/**
 * 宫格-: [进入地点相册]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_001
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid001(dt: Dt) {
  dt.log.i('进入地点相册 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.点击地点相册，查看跳转；');

  await dt.sleep();
  dt.log.i('预期结果2.跳转正常，若是第一次进入，弹出隐私申明；若不是第一次进入，默认进入到地点相册地图模式；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入地点相册 end');
}

/**
 * 宫格-: [地点相册隐私申明]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_002
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid002(dt: Dt) {
  dt.log.i('地点相册隐私申明 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.第一次进入地点相册，隐私申明弹窗；');

  await dt.sleep();
  dt.log.i('预期结果2.隐私声明弹窗正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击查看隐私声明内容；');

  await dt.sleep();
  dt.log.i('预期结果3.隐私声明内容查看正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.返回点击取消；');

  await dt.sleep();
  dt.log.i('预期结果4.未进入地点相册，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击页面中央的“点击查看”，');

  await dt.sleep();
  dt.log.i('预期结果5.隐私声明弹窗正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.点击同意；');

  await dt.sleep();
  dt.log.i('预期结果6.成功进入地点相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7.返回至相册列表，点击地点相册再次进入');

  await dt.sleep();
  dt.log.i('预期结果7.未弹窗隐私申明，成功进入地点相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册隐私申明 end');
}

/**
 * 宫格-: [地点相册隐私申明-初始化后再次进入]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_003
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.用户已经确认过隐私声明；
 */
async function multimediaGalleryMapAlbumPalacegrid003(dt: Dt) {
  dt.log.i('地点相册隐私申明-初始化后再次进入 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.恢复出厂设置，初始化隐私申明，再次进入地点相册；');

  await dt.sleep();
  dt.log.i('预期结果2.隐私声明弹窗正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.隐私声明弹窗，点击查看隐私声明内容；');

  await dt.sleep();
  dt.log.i('预期结果3.隐私声明内容查看正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.返回点击取消；');

  await dt.sleep();
  dt.log.i('预期结果4.未进入地点相册，返回相册列表；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.再次进入地点相册，隐私申明弹窗；');

  await dt.sleep();
  dt.log.i('预期结果5.隐私声明弹窗正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.点击确定；');

  await dt.sleep();
  dt.log.i('预期结果6.成功进入地点相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7.返回至相册列表，点击地点相册再次进入；');

  await dt.sleep();
  dt.log.i('预期结果7.未弹窗隐私申明，成功进入地点相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册隐私申明-初始化后再次进入 end');
}

/**
 * 宫格-: [地点相册隐私申明-停止服务后再次进入]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_004
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.用户已经确认过隐私声明；
 */
async function multimediaGalleryMapAlbumPalacegrid004(dt: Dt) {
  dt.log.i('地点相册隐私申明-停止服务后再次进入 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地点相册，相册-更多-设置-业务与隐私的声明-关于地图相册与隐私的声明，进入关于隐私申明；');

  await dt.sleep();
  dt.log.i('STEP 3.点击停止服务，查看反馈；');

  await dt.sleep();
  dt.log.i('预期结果3.返回上一级；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.再次进入地点相册，隐私申明弹窗；');

  await dt.sleep();
  dt.log.i('预期结果4.隐私声明弹窗正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.点击确定；');

  await dt.sleep();
  dt.log.i('预期结果5.成功进入地点相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6.返回至相册列表，点击地点相册再次进入；');

  await dt.sleep();
  dt.log.i('预期结果6.未弹窗隐私申明，成功进入地点相册；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册隐私申明-停止服务后再次进入 end');
}

/**
 * 宫格-: [地点相册隐私申明-关于隐私申明内容]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_005
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.用户已经确认过隐私声明；
 */
async function multimediaGalleryMapAlbumPalacegrid005(dt: Dt) {
  dt.log.i('地点相册隐私申明-关于隐私申明内容 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地点相册关于页，进入关于隐私申明；');

  await dt.sleep();
  dt.log.i('STEP 3.查看隐私申明内容，点击隐私申明中超链接；');

  await dt.sleep();
  dt.log.i('预期结果3.查看隐私申明成功，超链接成功跳转；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册隐私申明-关于隐私申明内容 end');
}

/**
 * 宫格-: [地点相册隐私申明-隐私申明内容比对]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_006
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 */
async function multimediaGalleryMapAlbumPalacegrid006(dt: Dt) {
  dt.log.i('地点相册隐私申明-隐私申明内容比对 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.第一次进入地点相册，隐私申明弹窗；');

  await dt.sleep();
  dt.log.i('STEP 3.点击查看隐私声明内容，再点击同意；');

  await dt.sleep();
  dt.log.i('预期结果3.与提供的隐私声明文件进行比对，无显示错误，无缺少内容，内容一致；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.进入关于隐私声明页面，点击隐私声明，查看内容；');

  await dt.sleep();
  dt.log.i('预期结果4.查看已签署的隐私声明内容，与提供的隐私声明文件进行比对，无显示错误，无缺少内容，内容一致；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册隐私申明-隐私申明内容比对 end');
}

/**
 * 宫格-: [地点相册-关于第三方SDK]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_007
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 */
async function multimediaGalleryMapAlbumPalacegrid007(dt: Dt) {
  dt.log.i('地点相册-关于第三方SDK start');
  dt.log.i('STEP 1.打开图库应用，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.进入地点相册点击右上角更多-设置-关于页，点击关于第三方SDK；');

  await dt.sleep();
  dt.log.i('预期结果2.成功进入第三方SDK页面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.查看页面内容，点击超链接；');

  await dt.sleep();
  dt.log.i('预期结果3.页面展示正常，超链接跳转正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册-关于第三方SDK end');
}

/**
 * 宫格-: [地点相册地图模式与宫格模式切换]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_008
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid008(dt: Dt) {
  dt.log.i('地点相册地图模式与宫格模式切换 start');
  dt.log.i('STEP 1.打开图库测试工具，进入地图相册；');

  await dt.sleep();
  dt.log.i('STEP 2.点击城市按钮，查看切换；');

  await dt.sleep();
  dt.log.i('预期结果2.从地图模式成功切换至城市宫格列表页；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击地图按钮，查看切换；');

  await dt.sleep();
  dt.log.i('预期结果3.从城市宫格页切换到地图模式页；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册地图模式与宫格模式切换 end');
}

/**
 * 宫格-删除: [地点相册封图动态更新]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_MapAlbum_Palacegrid_009
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.更新或增加当前最新照片
 */
async function multimediaGalleryMapAlbumPalacegrid009(dt: Dt) {
  dt.log.i('地点相册封图动态更新 start');
  dt.log.i('STEP 1.打开图库测试工具，进入地图相册；');

  await dt.sleep();
  dt.log.i('STEP 2.新增最新照片；');

  await dt.sleep();
  dt.log.i('预期结果2.照片更新并增加成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.返回图库相册列表页，查看地图相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果3.地点相册封图更新，取有地理位置信息的第一张照片，地点相册照片数目+1；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.进入该地点相册列表，删除新增的照片；');

  await dt.sleep();
  dt.log.i('预期结果4.删除有地理位置信息的第一张图片；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.返回图库相册列表页，查看地图相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果5.图库相册列表，地点相册封图恢复成步骤1的图片；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册封图动态更新 end');
}

/**
 * 宫格-: [中国发货机器进入地点相册地图模式]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_010
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 2.设备为中国发货机器；
 */
async function multimediaGalleryMapAlbumPalacegrid010(dt: Dt) {
  dt.log.i('中国发货机器进入地点相册地图模式 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.点击地点相册，查看跳转显示；');

  await dt.sleep();
  dt.log.i('预期结果2.进入地图模式默认显示全球地图，中国发货地机器则中国居中显示；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('中国发货机器进入地点相册地图模式 end');
}

/**
 * 宫格-: [图库相册列表，地点相册国际化]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_MapAlbum_Palacegrid_012
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等
 */
async function multimediaGalleryMapAlbumPalacegrid012(dt: Dt) {
  dt.log.i('图库相册列表，地点相册国际化 start');
  dt.log.i('STEP 1.在系统设置将系统语言设置成英文；');

  await dt.sleep();
  dt.log.i('STEP 2.打开图库应用，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 3.查看相册列表展示；');

  await dt.sleep();
  dt.log.i('预期结果3.地点相册适配英文显示，显示正常；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册列表，地点相册国际化 end');
}

/**
 * 宫格-视频: [地点相册中只有视频时，相册封图显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_MapAlbum_Palacegrid_013
 * 前置条件
 * 1.图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册，地点相册等；
 3.地点相册只有视频；
 */
async function multimediaGalleryMapAlbumPalacegrid013(dt: Dt) {
  dt.log.i('地点相册中只有视频时，相册封图显示 start');
  dt.log.i('STEP 1.打开图库测试工具，进入相册列表；');

  await dt.sleep();
  dt.log.i('STEP 2.查看地点相册封图显示；');

  await dt.sleep();
  dt.log.i('预期结果2.封图显示正常，为视频缩略图;');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册中只有视频时，相册封图显示 end');
}















































