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

import { Level } from '@ohos/hypium';
import { ON} from '@ohos.UiTest';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function MultimediaGalleryEditFloatingWindowTest(): void {
  run('Multimedia_Gallery_editFloatingWindow_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-格式用例: [图片编辑进入悬浮窗入口] TID: Multimedia_Gallery_editFloatingWindow_001
    await Multimedia_Gallery_editFloatingWindow_001(dt);
  });

  run('Multimedia_Gallery_editFloatingWindow_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-格式用例: [进入悬浮窗内，使用图片编辑的裁剪功能] TID: Multimedia_Gallery_editFloatingWindow_002
    await Multimedia_Gallery_editFloatingWindow_002(dt);
  });

  run('Multimedia_Gallery_editFloatingWindow_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-格式用例: [进入悬浮窗内，使用图片编辑的调节功能] TID: Multimedia_Gallery_editFloatingWindow_003
    await Multimedia_Gallery_editFloatingWindow_003(dt);
  });

  run('Multimedia_Gallery_editFloatingWindow_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-格式用例: [进入悬浮窗内，使用图片编辑的滤镜功能] TID: Multimedia_Gallery_editFloatingWindow_004
    await Multimedia_Gallery_editFloatingWindow_004(dt);
  });

  run('Multimedia_Gallery_editFloatingWindow_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-格式用例: [进入悬浮窗内，使用图片编辑的一键还原功能] TID: Multimedia_Gallery_editFloatingWindow_005
    await Multimedia_Gallery_editFloatingWindow_005(dt);
  });

  run('Multimedia_Gallery_editFloatingWindow_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-竖屏用例: [进入悬浮窗，将手机横竖屏旋转] TID: Multimedia_Gallery_editFloatingWindow_006
    await Multimedia_Gallery_editFloatingWindow_006(dt);
  });
}

/**
 * 编辑-格式: [图片编辑进入悬浮窗入口]
 * GROUP: 编辑 MODULE: 格式TID: Multimedia_Gallery_editFloatingWindow_001
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_001(dt: Dt) {
  dt.log.i('图片编辑进入悬浮窗入口 start');
  dt.log.i('STEP 1、选择不同位置的图片进入图片编辑页面(照片页、相册页、相机缩略图、截屏后左下角缩略图），上滑图库，右滑进入悬浮窗');

  await dt.sleep();
  dt.log.i('预期结果1、 2  进入悬浮窗后, 页面布局正常，符合ux规范（pc不支持悬浮窗）3、调整悬浮窗大小过程中，图片编辑页面布局正常，无排版错乱，窗口大小变化过程中动画过渡自然');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开图库，上滑出现分屏和悬浮窗，右滑进入悬浮窗，再打开图片，进入图片编辑页面');

  await dt.sleep();
  dt.log.i('STEP 3、进入悬浮窗状态，按住悬浮窗边缘，调整悬浮窗的大小');

  await dt.sleep();
  dt.log.i('预期结果3、调整悬浮窗大小过程中，图片编辑页面布局正常，无排版错乱，窗口大小变化过程中动画过渡自然');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑进入悬浮窗入口 end');
}

/**
 * 编辑-格式: [进入悬浮窗内，使用图片编辑的裁剪功能]
 * GROUP: 编辑 MODULE: 格式TID: Multimedia_Gallery_editFloatingWindow_002
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_002(dt: Dt) {
  dt.log.i('进入悬浮窗内，使用图片编辑的裁剪功能 start');
  dt.log.i('STEP 1、进入悬浮窗内，拖动裁剪框/在裁剪框内双指放大缩小图片');

  await dt.sleep();
  dt.log.i('预期结果1、2、3进入悬浮窗后，页面布局正常，符合ux规范，功能正常使用4、点击返回后，返回到了图片大图页面，撤销/后退/保存/对比功能正常使用5、图片保存成功，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入悬浮窗内，使用下方90度旋转/拖动刻度尺旋转/镜像翻转功能');

  await dt.sleep();
  dt.log.i('STEP 3、进入悬浮窗内，使用下方旋转/水平校正/垂直校正/调整比例功能');

  await dt.sleep();
  dt.log.i('STEP 4、进入悬浮窗内，点击上方返回/撒销/后退/保存/对比按钮');

  await dt.sleep();
  dt.log.i('预期结果4、点击返回后，返回到了图片大图页面，撤销/后退/保存/对比功能正常使用');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、使用1、2、3、4功能对图片 进行编辑并保存后、退出悬浮窗、在图库中查看图片是否正常');

  await dt.sleep();
  dt.log.i('预期结果5、图片保存成功，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入悬浮窗内，使用图片编辑的裁剪功能 end');
}

/**
 * 编辑-格式: [进入悬浮窗内，使用图片编辑的调节功能]
 * GROUP: 编辑 MODULE: 格式TID: Multimedia_Gallery_editFloatingWindow_003
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_003(dt: Dt) {
  dt.log.i('进入悬浮窗内，使用图片编辑的调节功能 start');
  dt.log.i('STEP 1、进入悬浮窗内，使用调节功能，选择不同的调节项，拖动调节bar调节强度');

  await dt.sleep();
  dt.log.i('预期结果1、进入悬浮窗后，页面布局正常，符合ux规范，功能正常使用');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入悬浮窗内，点击上方返回/撤销/后退/保存/对比按钮');

  await dt.sleep();
  dt.log.i('预期结果2、点击返回后，返回到了图片大图页面，撤销/后退/保存/对比功能正常使用');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用1、2功能对图片进行编辑并保存后，退出悬浮窗， 在图库中查看图片是否正常');

  await dt.sleep();
  dt.log.i('预期结果3、图片保存成功，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入悬浮窗内，使用图片编辑的调节功能 end');
}

/**
 * 编辑-格式: [进入悬浮窗内，使用图片编辑的滤镜功能]
 * GROUP: 编辑 MODULE: 格式TID: Multimedia_Gallery_editFloatingWindow_004
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_004(dt: Dt) {
  dt.log.i('进入悬浮窗内，使用图片编辑的滤镜功能 start');
  dt.log.i('STEP 1、进入悬浮窗内，使用滤镜功能，选择不同的滤镜（原图、经典、灰调、自然、森系、白皙、粉调、除雾）,拖动调节bar调节强度');

  await dt.sleep();
  dt.log.i('预期结果1、进入悬浮窗后，页面布局正常，符合ux规范，功能正常使用');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入悬浮窗内，点击上方返回/撤销/后退/保存/对比按钮');

  await dt.sleep();
  dt.log.i('预期结果2、点击返回后，返回到了图片大图页面、撤销/后退/保存/对比功能正常使用');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用1、2功能对图片进行编辑并保存后，退出悬浮窗，在图库中查看图片是否正常');

  await dt.sleep();
  dt.log.i('预期结果3、图片保存成功，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入悬浮窗内，使用图片编辑的滤镜功能 end');
}

/**
 * 编辑-格式: [进入悬浮窗内，使用图片编辑的一键还原功能]
 * GROUP: 编辑 MODULE: 格式TID: Multimedia_Gallery_editFloatingWindow_005
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_005(dt: Dt) {
  dt.log.i('进入悬浮窗内，使用图片编辑的一键还原功能 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入悬浮窗内，使用图片编辑的一键还原功能 end');
}

/**
 * 编辑-竖屏: [进入悬浮窗，将手机横竖屏旋转]
 * GROUP: 编辑 MODULE: 竖屏TID: Multimedia_Gallery_editFloatingWindow_006
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function Multimedia_Gallery_editFloatingWindow_006(dt: Dt) {
  dt.log.i('进入悬浮窗，将手机横竖屏旋转 start');
  dt.log.i('STEP 1、进入悬浮窗内，将手机旋转为横屏，对图片进行编辑');

  await dt.sleep();
  dt.log.i('预期结果1、进入悬浮窗后，ALN不支持横屏操作，xxx支持横屏；悬浮窗内按钮无重叠，可正常操作');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入悬浮窗，将手机横竖屏旋转 end');
}
