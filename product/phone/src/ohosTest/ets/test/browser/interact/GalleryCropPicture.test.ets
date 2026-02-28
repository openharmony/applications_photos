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
import { MatchPattern } from '@kit.TestKit';

export default function TCCropPicture(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('TCCropPictureTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllTCCropPicture').init();
      dt.log.i('beforeAll TCCropPicture start');
      dt.log.i('beforeAll TCCropPicture finish');
    });
    /**
     * 打开大图
     */
    it('beforeTCCropPicture', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    it('TC_Crop_Picture_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [预览区单指移动] TID: TC_Crop_Picture_003
      await TC_Crop_Picture_003(dt);
    });
    it('TC_Crop_Picture_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [调整裁剪框的四角] TID: TC_Crop_Picture_004
      await TC_Crop_Picture_004(dt);
    });
    it('TC_Crop_Picture_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [调整裁剪框的四边] TID: TC_Crop_Picture_005
      await TC_Crop_Picture_005(dt);
    });
    it('TC_Crop_Picture_013', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [自由旋转] TID: TC_Crop_Picture_013
      await TC_Crop_Picture_013(dt);
    });
    it('TC_Crop_Picture_014', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [水平校正] TID: TC_Crop_Picture_014
      await TC_Crop_Picture_014(dt);
    });
    it('TC_Crop_Picture_015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [垂直校正] TID: TC_Crop_Picture_015
      await TC_Crop_Picture_015(dt);
    });
    it('TC_Crop_Picture_024', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [调节自由模式的画幅比例] TID: TC_Crop_Picture_024
      await TC_Crop_Picture_024(dt);
    });
    it('TC_Crop_Picture_025', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [调节各个比例大小] TID: TC_Crop_Picture_025
      await TC_Crop_Picture_025(dt);
    });
    it('TC_Crop_Picture_032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [角度旋转效果] TID: TC_Crop_Picture_032
      await TC_Crop_Picture_032(dt);
    });
    it('TC_Crop_Picture_040', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [原始画面镜像] TID: TC_Crop_Picture_040
      await TC_Crop_Picture_040(dt);
    });
    it('TC_Crop_Picture_041', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云图片进入编辑界面] TID: TC_Crop_Picture_041
      await TC_Crop_Picture_041(dt);
    });
    it('TC_Crop_Picture_042', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [联网-编辑端云图片] TID: TC_Crop_Picture_042
      await TC_Crop_Picture_042(dt);
    });
    it('TC_Crop_Picture_043', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [编辑端云图片时断网] TID: TC_Crop_Picture_043
      await TC_Crop_Picture_043(dt);
    });
    it('TC_Crop_Picture_044', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载端云图片，断网后恢复联网后重新下载] TID: TC_Crop_Picture_044
      await TC_Crop_Picture_044(dt);
    });
    it('TC_Crop_Picture_045', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [重复进入端云编辑界面] TID: TC_Crop_Picture_045
      await TC_Crop_Picture_045(dt);
    });
    it('TC_Crop_Picture_046', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载端云图片多次切换编辑按钮] TID: TC_Crop_Picture_046
      await TC_Crop_Picture_046(dt);
    });
    it('TC_Crop_Picture_047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [端云图片下载失败] TID: TC_Crop_Picture_047
      await TC_Crop_Picture_047(dt);
    });
    it('TC_Crop_Picture_049', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [端云图片编辑界面切换一级菜单] TID: TC_Crop_Picture_049
      await TC_Crop_Picture_049(dt);
    });
    it('TC_Crop_Picture_050', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [分屏场景端云图片编辑界面] TID: TC_Crop_Picture_050
      await TC_Crop_Picture_050(dt);
    });
    it('TC_Crop_Picture_051', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [悬浮窗场景端云图片编辑界面] TID: TC_Crop_Picture_051
      await TC_Crop_Picture_051(dt);
    });
    it('TC_Crop_Picture_052', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [特殊图片场景下端云场景编辑界面] TID: TC_Crop_Picture_052
      await TC_Crop_Picture_052(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachTCCropPicture').init();
      dt.log.i('afterEach TCCropPicture start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach TCCropPicture finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllTCCropPicture').init();
      dt.log.i('afterAll TCCropPicture start');
      await Exit.browser();
      dt.log.i('afterAll TCCropPicture finish');
    });
  });
}

// DT步骤


/**
 * 大图-: [预览区单指移动]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_003
 * 前置条件
 *
 */
async function TC_Crop_Picture_003(dt: Dt) {
  dt.log.i('预览区单指移动 start');
  dt.log.i('STEP 1.从图库-图库，点击编辑进入');


  dt.log.i('STEP 2.点击裁剪按钮进入裁剪页面');


  dt.log.i('STEP 3.单指移动预览窗画面');


  dt.log.i('预期结果3.1.移动后画面区域能覆盖裁剪框，以手动移动位置为准3.2.移动后画面区域超出裁剪框，移动时导致裁剪框空白距离超过裁剪框1/2时，有阻力且无法再向外移动，松手后，有自动回弹效果3.3.操作过程中：预览区实时显示调整画面，裁剪框内画面清晰，出现3*3宫格辅助线，裁剪框以外的画面保持清晰，覆盖变暗透明蒙层3.4.操作完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，裁剪框区域放大平移至适配屏幕中心');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预览区单指移动 end');
}

/**
 * 大图-: [调整裁剪框的四角]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_004
 * 前置条件
 *
 */
async function TC_Crop_Picture_004(dt: Dt) {
  dt.log.i('调整裁剪框的四角 start');
  dt.log.i('STEP 1.从图库-图片，点击编辑进入');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2.点击裁剪按钮进入裁剪页面');


  dt.log.i('STEP 3.选中裁剪框的四角缩小放大');


  dt.log.i('预期结果3.1.操作过程中：预览区实时显示调整画面，裁剪框内画面清晰，出现3*3宫格辅助线，裁剪框以外的画面保持清晰，覆盖变暗透明蒙层3.2.操作完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，裁剪框区域放大平移至适配屏幕中心');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('调整裁剪框的四角 end');
}

/**
 * 大图-: [调整裁剪框的四边]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_005
 * 前置条件
 *
 */
async function TC_Crop_Picture_005(dt: Dt) {
  dt.log.i('调整裁剪框的四边 start');
  dt.log.i('STEP 1.从图库-图片点击编辑进入');


  dt.log.i('STEP 2.点击裁剪按钮进入裁剪页面');


  dt.log.i('STEP 3.选中裁剪框的四个边，拉伸缩小');


  dt.log.i('预期结果3.1.边框随拉伸距离缩小长宽，拉伸后边框缩小至拉伸位置3.2 .操作过程中：预览区实时显示调整画面，裁剪框内画面清晰，出现3*3宫格辅助线，裁剪框以外的画面保持清晰，覆盖变暗透明蒙层3.3.操作完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，裁剪框区域放大平移至适配屏幕中心；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('调整裁剪框的四边 end');
}

/**
 * 大图-滑动: [自由旋转]
 * GROUP: 大图 MODULE: 滑动TID: TC_Crop_Picture_013
 * 前置条件
 *
 */
async function TC_Crop_Picture_013(dt: Dt) {
  dt.log.i('自由旋转 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、点击旋转');


  dt.log.i('预期结果2、icon高亮显示，选中选项，调节范围：-45~45，默认值0，刻度0 上的圆点被遮挡，刻度条长');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、向左滑动/向右滑动');


  dt.log.i('预期结果3.1.向左滑动，数值变正数递增，视频画面逆时针转；向右滑动，数值变负数递减，视频画面顺时针转，数值与滑动数值条展示一致3.2.校正过程中：滑动校正刻度条时有震感，预览区实时显示校正画面，裁剪框内画面清晰，出现9*9宫格辅助线（大9宫格为白色实线，小9宫格为白色透明线），裁剪框以外的画面保持清晰，覆盖变暗透明蒙层，滑动校正刻度条时，实时显示校正项名称和校正值3.3.校正完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，不显示已设置的校正值，若调整旋转为非0后，再调整为0，素材会回归，仍与裁剪框贴合');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到其他校正选项');


  dt.log.i('预期结果4.切换至其他选项时，预览窗保存旋转后的效果，该选项恢复默认图标样式');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、切换到其他剪辑tab（调节、滤镜）');


  dt.log.i('预期结果5.切换其他选项后，预览窗保存旋转后的效果');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、切换到裁剪页面');


  dt.log.i('预期结果6.预览窗保存旋转后的效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('自由旋转 end');
}

/**
 * 大图-滑动: [水平校正]
 * GROUP: 大图 MODULE: 滑动TID: TC_Crop_Picture_014
 * 前置条件
 *
 */
async function TC_Crop_Picture_014(dt: Dt) {
  dt.log.i('水平校正 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、点击水平校正');


  dt.log.i('预期结果2、icon高亮显示，选中选项，调节范围：-45~45，默认值0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、向左滑动/向右滑动');


  dt.log.i('预期结果3.1.向左滑动，数值变正数递增，视频画面变为左窄右宽；向右滑动，数值变负数递减，视频画面变为左宽右窄，数值与滑动数值条展示一致3.2.校正过程中：滑动校正刻度条时有震感，预览区实时显示校正画面，裁剪框内画面清晰，出现9*9宫格辅助线（大9宫格为白色实线，小9宫格为白色透明线），裁剪框以外的画面保持清晰，覆盖变暗透明蒙层，滑动校正刻度条时，实时显示校正项名称和校正值3.3.校正完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，不显示已设置的校正值，若调整旋转为非0后，再调整为0，素材会回归，仍与裁剪框贴合；');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到其他校正选项');


  dt.log.i('预期结果4.切换至其他选项时，预览窗保存水平校正后的效果，该选项恢复默认图标样式');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、切换到其他剪辑tab（调节、滤镜）');


  dt.log.i('预期结果5.切换其他选项后，预览窗保存水平校正后的效果');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、切换到裁剪页面');


  dt.log.i('预期结果6.预览窗保存水平校正后的效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水平校正 end');
}

/**
 * 大图-滑动: [垂直校正]
 * GROUP: 大图 MODULE: 滑动TID: TC_Crop_Picture_015
 * 前置条件
 *
 */
async function TC_Crop_Picture_015(dt: Dt) {
  dt.log.i('垂直校正 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、点击垂直校正');


  dt.log.i('预期结果2、icon高亮显示，选中选项，调节范围：-45~45，默认值0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、向左滑动/向右滑动');


  dt.log.i('预期结果3.1.向左滑动，数值变正数递增，视频画面变为上窄下宽；向右滑动，数值变负数递减，视频画面变为上宽下窄，数值与滑动数值条展示一致3.2.校正过程中：滑动校正刻度条时有震感，预览区实时显示校正画面，裁剪框内画面清晰，出现9*9宫格辅助线（大9宫格为白色实线，小9宫格为白色透明线），裁剪框以外的画面保持清晰，覆盖变暗透明蒙层，滑动校正刻度条时，实时显示校正项名称和校正值3.3.校正完成后：裁剪框内画面清晰，九宫格辅助线消失，裁剪框以外的画面模糊，覆盖蒙层，不显示已设置的校正值，若调整旋转为非0后，再调整为0，素材会回归，仍与裁剪框贴合');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到其他校正选项');


  dt.log.i('预期结果4.切换至其他选项时，预览窗保存垂直校正后的效果，该选项恢复默认图标样式');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、切换到其他剪辑tab（调节、滤镜）');


  dt.log.i('预期结果5.切换其他选项后，预览窗保存垂直校正后的效果');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、切换到裁剪页面');


  dt.log.i('预期结果6.预览窗保存垂直校正后的效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('垂直校正 end');
}

/**
 * 大图-: [调节自由模式的画幅比例]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_024
 * 前置条件
 *
 */
async function TC_Crop_Picture_024(dt: Dt) {
  dt.log.i('调节自由模式的画幅比例 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');


  dt.log.i('STEP 2、点击比例');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2.、默认选中自由比例，左滑依次显示：原始、自由、铺满、1:1、3:2、2:3、4:3、3:4、9:16、16:9');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选中自由，通过预览区调节画面');


  dt.log.i('预期结果3、可以通过4条边和4个角调整裁剪框到任意宽高，调节完成后自动撑满画布；');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到其他剪辑tab（调节、滤镜）');


  dt.log.i('预期结果4、切换到对应的tab，保存调整后的比例');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('调节自由模式的画幅比例 end');
}

/**
 * 大图-大图: [调节各个比例大小]
 * GROUP: 大图 MODULE: 大图TID: TC_Crop_Picture_025
 * 前置条件
 *
 */
async function TC_Crop_Picture_025(dt: Dt) {
  dt.log.i('调节各个比例大小 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');


  dt.log.i('STEP 2、点击比例');


  dt.log.i('预期结果2、默认选中自由比例，左滑依次显示：原始、自由、铺满、1:1、3:2、2:3、4:3、3:4、9:16、16:9');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、遍历浏览各个比例的效果');


  dt.log.i('预期结果3、遍历各个比例，效果显示ok');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、双指捏合放大图片，切换比例');


  dt.log.i('预期结果4、图片可正常放大，切换比例裁剪框按所选比例变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('调节各个比例大小 end');
}

/**
 * 大图-: [角度旋转效果]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_032
 * 前置条件
 *
 */
async function TC_Crop_Picture_032(dt: Dt) {
  dt.log.i('角度旋转效果 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面');


  dt.log.i('STEP 2、点击角度旋转');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2.1旋转效果：逆时针90度旋转2.3旋转过程中：预览区实时显示旋转画面，有素材旋转动画；只显示裁剪框内画面，裁剪框外画面隐去，裁剪框消失，有渐隐效果2.4旋转完成后：裁剪框内画面清晰，裁剪框出现，有渐显效果；裁剪框以外的画面模糊，覆盖蒙层；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到其他剪辑tab页（调节、滤镜）');


  dt.log.i('预期结果3.保留旋转后的画面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('角度旋转效果 end');
}

/**
 * 大图-: [原始画面镜像]
 * GROUP: 大图 MODULE: TID: TC_Crop_Picture_040
 * 前置条件
 *
 */
async function TC_Crop_Picture_040(dt: Dt) {
  dt.log.i('原始画面镜像 start');
  dt.log.i('STEP 1、从图库-图片，点击编辑进入裁剪页面，点击镜像');


  dt.log.i('预期结果1.1 镜像效果：在水平方向上做中心镜像翻转180度1.2 镜像过程中：预览区实时显示镜像画面，有卡片翻转效果，裁剪框消失，有渐隐效果1.3 镜像完成后：裁剪框出现，有渐显效果，裁剪框以外的画面模糊，覆盖蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到其他剪辑tab（调节、滤镜）');


  dt.log.i('预期结果2、保留镜像后的效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保存');


  dt.log.i('预期结果3、保留镜像后的效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('原始画面镜像 end');
}

/**
 * 大图-端云: [端云图片进入编辑界面]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_041
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_041(dt: Dt) {
  dt.log.i('端云图片进入编辑界面 start');
  dt.log.i('STEP 1、未联网，浏览大图点击编辑按钮');


  dt.log.i('预期结果1、图片下方弹出提示：无可用网络');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、联网，浏览大图点击编辑按钮');


  dt.log.i('预期结果2、进入图片编辑页面，图片中心展示图片下载loading图标');
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云图片进入编辑界面 end');
}

/**
 * 大图-端云: [联网-编辑端云图片]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_042
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_042(dt: Dt) {
  dt.log.i('联网-编辑端云图片 start');
  dt.log.i('STEP 1、联网，浏览大图点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果1、进入图片编辑页面，图片中心展示图片下载loading图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片下载过程中点击图片编辑菜单按钮');


  dt.log.i('预期结果2、下载过程中，除顶部返回按钮外，其他编辑按钮置灰，点击无反应。下载完成后，可以正常点击切换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图片下载完成后，退出图片编辑页面，点击编辑按钮，重新进入编辑页面');


  dt.log.i('预期结果3、直接进入编辑页面，不显示loading图标');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('联网-编辑端云图片 end');
}

/**
 * 大图-端云: [编辑端云图片时断网]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_043
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_043(dt: Dt) {
  dt.log.i('编辑端云图片时断网 start');
  dt.log.i('STEP 1、进入图片编辑页面，下载端云图片过程中断网');


  dt.log.i('预期结果1、toast提示“下载失败”，弹出弹框：网络异常, 请检查网络后再尝试');

  await dt.driver.assertComponentExist(ON.text('年', MatchPattern.CONTAINS)); //'下载失败'));
  dt.log.i('STEP 2、保持断网，点击网络异常弹框中的重试按钮');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2、网络异常弹框消失，图片中心展示loading进度，超过2秒后再次弹出网络异常弹框');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击网络异常弹框中的取消按钮');


  dt.log.i('预期结果3、退出图片编辑，切换到大图浏览页面');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、联网，重新进入编辑页面');


  dt.log.i('预期结果4、图片中心展示loading进度，继续下载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑端云图片时断网 end');
}

/**
 * 大图-下载: [下载端云图片，断网后恢复联网后重新下载]
 * GROUP: 大图 MODULE: 下载TID: TC_Crop_Picture_044
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_044(dt: Dt) {
  dt.log.i('下载端云图片，断网后恢复联网后重新下载 start');
  dt.log.i('STEP 1、进入图片编辑页面，下载端云图片过程中断网');


  dt.log.i('预期结果1、toast提示“下载失败”，弹出弹框：网络异常, 请检查网络后再尝试');

  await dt.driver.assertComponentExist(ON.text('年', MatchPattern.CONTAINS)); //'下载失败'));
  dt.log.i('STEP 2、连接网络，点击网络异常弹框中的重试按钮');

  await dt.sleep();
  dt.log.i('预期结果2、继续下载，图片中间显示loading进度');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载端云图片，断网后恢复联网后重新下载 end');
}

/**
 * 大图-端云: [重复进入端云编辑界面]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_045
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_045(dt: Dt) {
  dt.log.i('重复进入端云编辑界面 start');
  dt.log.i('STEP 1、进入端云图片编辑页面');


  dt.log.i('预期结果1、2、图片中心展示loading进度，继续下载3、下载过程中编辑按钮置灰，点击无反应');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片没有下载完成，退出编辑页面后，重新进入编辑页面');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 3、下载过程中，切换裁剪、调节和滤镜tab');


  dt.log.i('预期结果3、下载过程中编辑按钮置灰，点击无反应');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重复进入端云编辑界面 end');
}

/**
 * 大图-下载: [下载端云图片多次切换编辑按钮]
 * GROUP: 大图 MODULE: 下载TID: TC_Crop_Picture_046
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_046(dt: Dt) {
  dt.log.i('下载端云图片多次切换编辑按钮 start');
  dt.log.i('STEP 1、进入图片编辑页面，下载过程中，多次点击裁剪、调节和滤镜tab');


  dt.log.i('预期结果1-1、loading进度显示在图片中心位置1-2、下载过程中，除顶部返回按钮外，其他编辑按钮置灰，点击无反应1-3、下载完成后，正常点击切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载端云图片多次切换编辑按钮 end');
}

/**
 * 大图-下载: [端云图片下载失败]
 * GROUP: 大图 MODULE: 下载TID: TC_Crop_Picture_047
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_047(dt: Dt) {
  dt.log.i('端云图片下载失败 start');
  dt.log.i('STEP 1、进入端云图片编辑页面，图片下载超时');


  dt.log.i('预期结果1、toast提示“下载失败”，弹出弹框：网络异常, 请检查网络后再尝试');

  await dt.driver.assertComponentExist(ON.text('年', MatchPattern.CONTAINS)); //'下载失败'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云图片下载失败 end');
}

/**
 * 大图-端云: [端云图片编辑界面切换一级菜单]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_049
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_049(dt: Dt) {
  dt.log.i('端云图片编辑界面切换一级菜单 start');
  dt.log.i('STEP 1、联网，浏览大图点击编辑按钮');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果1、进入图片编辑页面，loading进度始终显示在图片中心位置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换编辑界面的裁剪、调节和滤镜一级菜单');


  dt.log.i('预期结果2、3、loading进度始终显示在图片中心位置，下载期间编辑按钮置灰无法点击');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏切换裁剪、调节和滤镜一级菜单（PC不支持横竖屏切换）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云图片编辑界面切换一级菜单 end');
}

/**
 * 大图-端云: [分屏场景端云图片编辑界面]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_050
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_050(dt: Dt) {
  dt.log.i('分屏场景端云图片编辑界面 start');
  dt.log.i('STEP 1、打开图库+其他应用的分屏场景，联网，浏览大图点击编辑按钮');


  dt.log.i('预期结果1、进入图片编辑页面，loading进度始终显示在图片中心位置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、下载端云图片期间，切换编辑界面的裁剪、调节和滤镜一级菜单');


  dt.log.i('预期结果2、3、loading进度始终显示在图片中心位置，下载期间编辑按钮置灰无法点击');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下载端云图片期间，横屏切换裁剪、调节和滤镜一级菜单（PC不支持横竖屏切换）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏场景端云图片编辑界面 end');
}

/**
 * 大图-端云: [悬浮窗场景端云图片编辑界面]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_051
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_051(dt: Dt) {
  dt.log.i('悬浮窗场景端云图片编辑界面 start');
  dt.log.i('STEP 1、打开图库后切换到悬浮窗模式，联网，浏览大图点击编辑按钮');


  dt.log.i('预期结果1、进入图片编辑页面，loading进度始终显示在图片中心位置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换编辑界面的裁剪、调节和滤镜一级菜单');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2、loading进度始终显示在图片中心位置，下载期间编辑按钮置灰无法点击');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗场景端云图片编辑界面 end');
}

/**
 * 大图-端云: [特殊图片场景下端云场景编辑界面]
 * GROUP: 大图 MODULE: 端云TID: TC_Crop_Picture_052
 * 前置条件
 * 登录端云账号，端云图片资源下行完成
 */
async function TC_Crop_Picture_052(dt: Dt) {
  dt.log.i('特殊图片场景下端云场景编辑界面 start');
  dt.log.i('STEP 1、浏览横长图，点击编辑按钮');


  dt.log.i('预期结果1、2、3、4、进入图片编辑页面，loading进度始终显示在图片中心位置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换横屏查看loading位置（PC不支持横竖屏切换）');


  dt.log.i('STEP 3、浏览横长图，点击编辑按钮');


  dt.log.i('STEP 4、切换横屏查看loading位置（PC不支持横竖屏切换）');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('特殊图片场景下端云场景编辑界面 end');
}

