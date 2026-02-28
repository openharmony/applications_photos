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

export default function MultimediaGalleryEditHDRTest(): void {
  run('Multimedia_Gallery_Edit_HDR_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [HDR图片进入编辑后保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_001
    await Multimedia_Gallery_Edit_HDR_001(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [编辑支持裁剪保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_002
    await Multimedia_Gallery_Edit_HDR_002(dt);
  });
  run('Multimedia_Gallery_Edit_HDR_003', Level.LEVEL0, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [编辑支持调节保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_003
    await Multimedia_Gallery_Edit_HDR_003(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_004', Level.LEVEL0, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [编辑支持滤镜保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_004
    await Multimedia_Gallery_Edit_HDR_004(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [AI修图不支持保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_005
    await Multimedia_Gallery_Edit_HDR_005(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [涂鸦不支持保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_006
    await Multimedia_Gallery_Edit_HDR_006(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [水印编辑支持保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_007
    await Multimedia_Gallery_Edit_HDR_007(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [一键美肤后图片编辑不支持保留HDR效果] TID: Multimedia_Gallery_Edit_HDR_008
    await Multimedia_Gallery_Edit_HDR_008(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [HDR图片编辑裁剪、调节、滤镜后保存后二次编辑] TID: Multimedia_Gallery_Edit_HDR_009
    await Multimedia_Gallery_Edit_HDR_009(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [HDR图片编辑AI修图/涂鸦/水印编辑保存后二次编辑] TID: Multimedia_Gallery_Edit_HDR_010
    await Multimedia_Gallery_Edit_HDR_010(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [HDR图片编辑保存后一键回退] TID: Multimedia_Gallery_Edit_HDR_011
    await Multimedia_Gallery_Edit_HDR_011(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [不同图库入口进编辑HDR效果保留验证] TID: Multimedia_Gallery_Edit_HDR_012
    await Multimedia_Gallery_Edit_HDR_012(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [相机拍摄的各类图片进编辑支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_013
    await Multimedia_Gallery_Edit_HDR_013(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [相机拍摄的各类水印图片进编辑支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_014
    await Multimedia_Gallery_Edit_HDR_014(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [云同步图片支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_015
    await Multimedia_Gallery_Edit_HDR_015(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [分享图片支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_016
    await Multimedia_Gallery_Edit_HDR_016(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [截屏/三方应用下载的图片不支持HDR图片编辑] TID: Multimedia_Gallery_Edit_HDR_017
    await Multimedia_Gallery_Edit_HDR_017(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [编辑后的图片上传至三方应用，应用内支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_018
    await Multimedia_Gallery_Edit_HDR_018(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [克隆的图片编辑支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_019
    await Multimedia_Gallery_Edit_HDR_019(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [不同格式图片编辑HDR效果保留情况验证] TID: Multimedia_Gallery_Edit_HDR_020
    await Multimedia_Gallery_Edit_HDR_020(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [动态图片编辑不支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_021
    await Multimedia_Gallery_Edit_HDR_021(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [不同分辨率图片编辑支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_022
    await Multimedia_Gallery_Edit_HDR_022(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [同一张HDR图片反复进行基础编辑和一键回退] TID: Multimedia_Gallery_Edit_HDR_023
    await Multimedia_Gallery_Edit_HDR_023(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HEIF用例: [不同图片连续进行基础编辑] TID: Multimedia_Gallery_Edit_HDR_024
    await Multimedia_Gallery_Edit_HDR_024(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [分屏/悬浮窗下编辑支持HDR效果保留] TID: Multimedia_Gallery_Edit_HDR_025
    await Multimedia_Gallery_Edit_HDR_025(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [HDR图片编辑过程xxx手机] TID: Multimedia_Gallery_Edit_HDR_026
    await Multimedia_Gallery_Edit_HDR_026(dt);
  });

  run('Multimedia_Gallery_Edit_HDR_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-HDR用例: [支持HDR图片编辑保存后的图片，存储空间无明显变化] TID: Multimedia_Gallery_Edit_HDR_027
    await Multimedia_Gallery_Edit_HDR_027(dt);
  });

  run('Multimedia_Gallery_Edit_Lock_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
    //  编辑-应用锁用例: [图片编辑与应用锁交互验证] TID: Multimedia_Gallery_Edit_Lock_001
    await Multimedia_Gallery_Edit_Lock_001(dt);
  });
}

/**
 * 编辑-HDR: [HDR图片进入编辑后保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_001
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_001(dt: Dt) {
  dt.log.i('HDR图片进入编辑后保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、设置关闭HDR显示，HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面图片预览无HDR效果，图片亮度色彩未提高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片进入编辑后保留HDR效果 end');
}

/**
 * 编辑-HDR: [编辑支持裁剪保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_002
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_002(dt: Dt) {
  dt.log.i('编辑支持裁剪保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、旋转图片角度（90度旋转/调节栏调节）');

  await dt.sleep();
  dt.log.i('预期结果2-7、功能正常使用，裁剪/矫正/旋转/镜像过程中仍保留HDR效果，图片亮度色彩未降低8、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面仍存在HDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击图片镜像');

  await dt.sleep();
  dt.log.i('STEP 4、水平矫正调节');

  await dt.sleep();
  dt.log.i('STEP 5、垂直矫正调节');

  await dt.sleep();
  dt.log.i('STEP 6、裁剪比例调节');

  await dt.sleep();
  dt.log.i('STEP 7、拖动裁剪框');

  await dt.sleep();
  dt.log.i('STEP 8、保存图片');

  await dt.sleep();
  dt.log.i('预期结果8、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面仍存在HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持裁剪保留HDR效果 end');
}

/**
 * 编辑-HDR: [编辑支持调节保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_003
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_003(dt: Dt) {
  dt.log.i('编辑支持调节保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击调节-一键调节');

  await dt.sleep();
  dt.log.i('预期结果2、一键调节功能正常，预览图片仍保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、遍历更改所有调节项数值（曝光、高光、阴影、亮度、对比度、亮部、暗部、饱和度、自然饱和度、色温、色调、锐度、暗角、褪色、颗粒）');

  await dt.sleep();
  dt.log.i('预期结果3-5、调节、对比功能正常，预览图片始终保留HDR效果，图片亮度色彩未降低6、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面仍存在HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击对比按钮');

  await dt.sleep();
  dt.log.i('STEP 5、关闭所有调节项');

  await dt.sleep();
  dt.log.i('STEP 6、保存图片（覆盖保存/另存为）');

  await dt.sleep();
  dt.log.i('预期结果6、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面仍存在HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持调节保留HDR效果 end');
}

/**
 * 编辑-HDR: [编辑支持滤镜保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_004
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_004(dt: Dt) {
  dt.log.i('编辑支持滤镜保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击滤镜，遍历所有滤镜并对比（原图、经典、灰调、自然、森系、白皙、粉调）');

  await dt.sleep();
  dt.log.i('预期结果2、滤镜切换及对比功能正常，预览图片仍保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保存图片（覆盖保存/另存为）');

  await dt.sleep();
  dt.log.i('预期结果3、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面仍存在HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑支持滤镜保留HDR效果 end');
}

/**
 * 编辑-HDR: [AI修图不支持保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_005
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_005(dt: Dt) {
  dt.log.i('AI修图不支持保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击AI修图');

  await dt.sleep();
  dt.log.i('预期结果2、进入AI修图界面，图片不保留HDR效果，图片亮度色彩降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、侧滑返回或点击左上角返回');

  await dt.sleep();
  dt.log.i('预期结果3、返回上一级裁剪界面，仍存在HDR效果，裁剪图片3、AI修图功能正常，进入界面时亮度变低，使用修图功能过程中图片亮度色彩无变化5、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面无HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次进入AI修图，进行消除/人像精修/背景/扩图操作');

  await dt.sleep();
  dt.log.i('STEP 5、保存图片（覆盖保存/另存为）');

  await dt.sleep();
  dt.log.i('预期结果5、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面无HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('AI修图不支持保留HDR效果 end');
}

/**
 * 编辑-HDR: [涂鸦不支持保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_006
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_006(dt: Dt) {
  dt.log.i('涂鸦不支持保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击涂鸦');

  await dt.sleep();
  dt.log.i('预期结果2、进入涂鸦界面，图片不保留HDR效果，进入界面时亮度变低，使用修图功能过程中图片亮度色彩无变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、侧滑返回或点击左上角返回');

  await dt.sleep();
  dt.log.i('预期结果3、返回上一级裁剪界面，亮度变高恢复HDR效果，裁剪图片亮度无变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次进入涂鸦，添加涂鸦痕迹/文本框');

  await dt.sleep();
  dt.log.i('预期结果4、图片不保留HDR效果，进入界面时亮度变低，使用修图功能过程中图片亮度色彩无变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、不保存涂鸦返回');

  await dt.sleep();
  dt.log.i('预期结果5、返回上一级裁剪界面，仍存在HDR效果，裁剪图片亮度无变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、再次进入涂鸦，添加涂鸦并保存涂鸦');

  await dt.sleep();
  dt.log.i('预期结果6、图片不保留HDR效果，进入界面时亮度变低，进行涂鸦/文本标注时，图片亮度色彩无变化；保存涂鸦后返回裁剪界面，无HDR效果；保存前后无亮度变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、保存图片（覆盖保存/另存为）');

  await dt.sleep();
  dt.log.i('预期结果7、图片保存成功，返回大图浏览；编辑后的图片在大图浏览界面无HDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('涂鸦不支持保留HDR效果 end');
}

/**
 * 编辑-HDR: [水印编辑支持保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_007
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片，且图片含水印
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_007(dt: Dt) {
  dt.log.i('水印编辑支持保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览-编辑');

  await dt.sleep();
  dt.log.i('STEP 2、点击水印编辑');

  await dt.sleep();
  dt.log.i('STEP 3、变更水印类型');

  await dt.sleep();
  dt.log.i('STEP 4、点击撤销');

  await dt.sleep();
  dt.log.i('STEP 5、调整水印参数显示效果');

  await dt.sleep();
  dt.log.i('STEP 6、依次点击撤销、恢复');

  await dt.sleep();
  dt.log.i('STEP 7、保存图片（覆盖保存/另存为）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑支持保留HDR效果 end');
}

/**
 * 编辑-HDR: [一键美肤后图片编辑不支持保留HDR效果]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_008
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片，且图片为人像图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_008(dt: Dt) {
  dt.log.i('一键美肤后图片编辑不支持保留HDR效果 start');
  dt.log.i('STEP 1、HDR图片进入大图浏览，长按人像选择一键美肤');

  await dt.sleep();
  dt.log.i('预期结果1、美肤成功，HDR效果丢失，图片亮度色彩降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入编辑');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面图片预览无HDR效果，图片亮度色彩未提高');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、返回大图浏览，长按人像取消一键美肤');

  await dt.sleep();
  dt.log.i('预期结果3、取消一键美肤成功，图片预览恢复保留HDR效果，图片亮度色彩提高');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、进入编辑');

  await dt.sleep();
  dt.log.i('预期结果4、图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一键美肤后图片编辑不支持保留HDR效果 end');
}

/**
 * 编辑-HDR: [HDR图片编辑裁剪、调节、滤镜后保存后二次编辑]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_009
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_009(dt: Dt) {
  dt.log.i('HDR图片编辑裁剪、调节、滤镜后保存后二次编辑 start');
  dt.log.i('STEP 1、HDR图片仅存在裁剪编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('预期结果1-4、编辑页面图片预览保留HDR效果，图片亮度色彩未降低；再次裁剪/调节/滤镜，HDR效果仍保留；进行AI修图/水印/涂鸦后HDR效果不保留');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、HDR图片仅存在调节编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('STEP 3、HDR图片仅存在滤镜编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('STEP 4、HDR图片经裁剪+调节+滤镜编辑后保存，再次进入编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片编辑裁剪、调节、滤镜后保存后二次编辑 end');
}

/**
 * 编辑-HDR: [HDR图片编辑AI修图/涂鸦/水印编辑保存后二次编辑]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_010
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_010(dt: Dt) {
  dt.log.i('HDR图片编辑AI修图/涂鸦/水印编辑保存后二次编辑 start');
  dt.log.i('STEP 1、HDR图片仅存在水印编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('预期结果1-4、编辑页面图片预览无HDR效果，图片亮度色彩未提高；再次任意编辑操作，HDR效果不恢复，水印编辑/AI修图/涂鸦亮度不降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、HDR图片仅存在AI修图编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('STEP 3、HDR图片仅存在涂鸦编辑后保存，再次进入编辑');

  await dt.sleep();
  dt.log.i('STEP 4、HDR图片经水印编辑+AI修图+涂鸦编辑后保存，再次进入编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片编辑AI修图/涂鸦/水印编辑保存后二次编辑 end');
}

/**
 * 编辑-HDR: [HDR图片编辑保存后一键回退]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_011
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_011(dt: Dt) {
  dt.log.i('HDR图片编辑保存后一键回退 start');
  dt.log.i('STEP 1、HDR图片经裁剪+调节+滤镜编辑后保存，再次进入编辑点击一键回退');

  await dt.sleep();
  dt.log.i('预期结果1-2、返回大图浏览，图片变回原图，有HDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、HDR图片经水印编辑+AI修图+涂鸦编辑后保存，再次进入编辑点击一键回退');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片编辑保存后一键回退 end');
}

/**
 * 编辑-HDR: [不同图库入口进编辑HDR效果保留验证]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_012
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_012(dt: Dt) {
  dt.log.i('不同图库入口进编辑HDR效果保留验证 start');
  dt.log.i('STEP 1、图库宫格大图进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('预期结果1-7、编辑页面图片预览保留HDR效果，进入编辑时图片亮度色彩未降低；裁剪/滤镜/调节与HDR效果叠加，保存图片后预览与编辑效果一致，保留HDR效果（进行AI修图/水印/涂鸦后HDR效果不保留）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相机入口大图进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 3、搜索大图进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 4、文件管理大图进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 5、智慧时刻/人像图片进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 6、隐藏相册大图进编辑，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同图库入口进编辑HDR效果保留验证 end');
}

/**
 * 编辑-HDR: [相机拍摄的各类图片进编辑支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_013
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_013(dt: Dt) {
  dt.log.i('相机拍摄的各类图片进编辑支持HDR效果保留 start');
  dt.log.i('STEP 1、相机普通拍照拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('预期结果1-7、编辑页面图片预览保留HDR效果，进入编辑时图片亮度色彩未降低；裁剪/滤镜/调节与HDR效果叠加，保存图片后预览与编辑效果一致，保留HDR效果（进行AI修图/水印/涂鸦后HDR效果不保留）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相机前置人像拍照拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 3、相机后置人像拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 4、相机超级微距拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 5、相机大光圈模式拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 6、相机普通拍照调节10x，拍摄图片后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 7、相机拍摄水印图片（普通水印/画框水印）后，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄的各类图片进编辑支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [相机拍摄的各类水印图片进编辑支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_014
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_014(dt: Dt) {
  dt.log.i('相机拍摄的各类水印图片进编辑支持HDR效果保留 start');
  dt.log.i('STEP 1、相机拍摄无水印图片，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('预期结果1-3、编辑页面图片预览保留HDR效果，进入编辑时图片亮度色彩未降低；裁剪/滤镜/调节与HDR效果叠加，保存图片后预览与编辑效果一致，保留HDR效果（进行AI修图/水印/涂鸦后HDR效果不保留）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相机拍摄通用水印图片，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();
  dt.log.i('STEP 3、相机拍摄画框水印图片，进入图库编辑图片，进行裁剪/滤镜/调节并保存图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄的各类水印图片进编辑支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [云同步图片支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_015
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_015(dt: Dt) {
  dt.log.i('云同步图片支持HDR效果保留 start');
  dt.log.i('STEP 1、xxx拍摄图片（未编辑过）云同步至xxx测试机，进入图片编辑');

  await dt.sleep();
  dt.log.i('预期结果1-4、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、5.0xxx拍摄图片（未编辑过）云同步至xxx测试机，进入图片编辑');

  await dt.sleep();
  dt.log.i('STEP 3、不同机型图片拍摄图片（未编辑过）云同步至xxx测试机进入图片编辑');

  await dt.sleep();
  dt.log.i('STEP 4、历史拍摄图片（未编辑过）进入图片编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云同步图片支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [分享图片支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_016
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_016(dt: Dt) {
  dt.log.i('分享图片支持HDR效果保留 start');
  dt.log.i('STEP 1、不同机型图片拍摄图片（未编辑过）分享至xxx测试机进入图片编辑');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、分享云增强图片进入图片编辑');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享图片支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [截屏/三方应用下载的图片不支持HDR图片编辑]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_017
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_017(dt: Dt) {
  dt.log.i('截屏/三方应用下载的图片不支持HDR图片编辑 start');
  dt.log.i('STEP 1、截屏图片进入图片编辑');

  await dt.sleep();
  dt.log.i('预期结果1-2、无HDR效果，进入编辑/涂鸦/修图时，图片亮度无提高或降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、三方应用下载的图片进入图片编辑（上传的HDR图片再次下载）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏/三方应用下载的图片不支持HDR图片编辑 end');
}

/**
 * 编辑-HDR: [编辑后的图片上传至三方应用，应用内支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_018
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_018(dt: Dt) {
  dt.log.i('编辑后的图片上传至三方应用，应用内支持HDR效果保留 start');
  dt.log.i('STEP 1、HDR图片经裁剪+调节+滤镜编辑后保存，上传至小红书');

  await dt.sleep();
  dt.log.i('预期结果1、三方应用预览图片有HDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、HDR图片经水印编辑+AI修图+涂鸦编辑后保存，上传至微博');

  await dt.sleep();
  dt.log.i('预期结果2、三方应用预览图片有HDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑后的图片上传至三方应用，应用内支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [克隆的图片编辑支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_019
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_019(dt: Dt) {
  dt.log.i('克隆的图片编辑支持HDR效果保留 start');
  dt.log.i('STEP 1、辅助机克隆HDR图片到测试机，测试机查看图片');

  await dt.sleep();
  dt.log.i('预期结果1、可正常显示图片效果，进入编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('克隆的图片编辑支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [不同格式图片编辑HDR效果保留情况验证]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_020
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_020(dt: Dt) {
  dt.log.i('不同格式图片编辑HDR效果保留情况验证 start');
  dt.log.i('STEP 1、相机拍摄heif格式HDR图片进入编辑');

  await dt.sleep();
  dt.log.i('预期结果1、进入编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相机拍摄jpg格式HDR图片进入编辑');

  await dt.sleep();
  dt.log.i('预期结果2、进入编辑页面图片预览保留HDR效果，图片亮度色彩未降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、png/bmp/webp图片进入编辑');

  await dt.sleep();
  dt.log.i('预期结果3、无HDR效果，进入编辑图片亮度无变化，修图/涂鸦后预览图片亮度无变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同格式图片编辑HDR效果保留情况验证 end');
}

/**
 * 编辑-HDR: [动态图片编辑不支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_021
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_021(dt: Dt) {
  dt.log.i('动态图片编辑不支持HDR效果保留 start');
  dt.log.i('STEP 1、动态HDR图片进入图片编辑');

  await dt.sleep();
  dt.log.i('预期结果1、进入编辑无HDR效果，图片亮度变低，编辑功能正常，保存正常,');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态图片编辑不支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [不同分辨率图片编辑支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_022
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_022(dt: Dt) {
  dt.log.i('不同分辨率图片编辑支持HDR效果保留 start');
  dt.log.i('STEP 1、1K及以下HDR图片(裁剪获得)后进入编辑');

  await dt.sleep();
  dt.log.i('预期结果1-4、进入编辑页面图片预览保留HDR效果，图片亮度色彩未降低5、进入编辑页面图片预览不保留HDR效果，图片亮度色彩降低');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、2K HDR图片后进入编辑');

  await dt.sleep();
  dt.log.i('STEP 3、4K HDR图片后进入编辑');

  await dt.sleep();
  dt.log.i('STEP 4、1K HDR图片后进入编辑');

  await dt.sleep();
  dt.log.i('STEP 5、512*512及以下HDR图片(裁剪获得)后进入编辑');

  await dt.sleep();
  dt.log.i('预期结果5、进入编辑页面图片预览不保留HDR效果，图片亮度色彩降低');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同分辨率图片编辑支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [同一张HDR图片反复进行基础编辑和一键回退]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_023
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_023(dt: Dt) {
  dt.log.i('同一张HDR图片反复进行基础编辑和一键回退 start');
  dt.log.i('STEP 1、同一张HDR图片反复进行基础编辑和一键回退，重复50次');

  await dt.sleep();
  dt.log.i('预期结果1、功能始终正常，无卡死闪退');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一张HDR图片反复进行基础编辑和一键回退 end');
}

/**
 * 编辑-HEIF: [不同图片连续进行基础编辑]
 * GROUP: 编辑 MODULE: HEIFTID: Multimedia_Gallery_Edit_HDR_024
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_024(dt: Dt) {
  dt.log.i('不同图片连续进行基础编辑 start');
  dt.log.i('STEP 1、50张HDR图片连续进行基础编辑');

  await dt.sleep();
  dt.log.i('预期结果1、功能始终正常，无卡死闪退');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同图片连续进行基础编辑 end');
}

/**
 * 编辑-HDR: [分屏/悬浮窗下编辑支持HDR效果保留]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_025
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_025(dt: Dt) {
  dt.log.i('分屏/悬浮窗下编辑支持HDR效果保留 start');
  dt.log.i('STEP 1、HDR图片进入图片编辑页面，上滑图库至左上角进入分屏模式，分屏模式下进行编辑');

  await dt.sleep();
  dt.log.i('预期结果1、2、分屏及悬浮窗模式下，图片编辑功能及ux布局正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、HDR图片进入图片编辑页面，上滑图库至右上角进入悬浮窗模式，悬浮窗模式下进行编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏/悬浮窗下编辑支持HDR效果保留 end');
}

/**
 * 编辑-HDR: [HDR图片编辑过程xxx手机]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_026
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_026(dt: Dt) {
  dt.log.i('HDR图片编辑过程xxx手机 start');
  dt.log.i('STEP 1、HDR图片进行基础编辑（裁剪/调节/滤镜），编辑过程中多次xxx');

  await dt.sleep();
  dt.log.i('预期结果1、编辑功能正常，图片亮度不降低，xxx屏幕无显示异常，无功能异常；撤销重做正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行水印编辑，并xxx');

  await dt.sleep();
  dt.log.i('预期结果2、水印编辑功能正常，xxx屏幕无显示异常，无功能异常；撤销重做正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进行AI修图/涂鸦操作，操作过程中多次xxx');

  await dt.sleep();
  dt.log.i('预期结果3、进入AI修图/水印/涂鸦后HDR效果不保留，xxx屏幕无显示异常，无功能异常；撤销重做正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、保存图片，预览图片');

  await dt.sleep();
  dt.log.i('预期结果4、保存正常，xxx形态下图片预览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片编辑过程xxx手机 end');
}

/**
 * 编辑-HDR: [支持HDR图片编辑保存后的图片，存储空间无明显变化]
 * GROUP: 编辑 MODULE: HDRTID: Multimedia_Gallery_Edit_HDR_027
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、相机拍摄的JPG/HEIF图片
 4、系统设置内图片HDR显示已打开
 */
async function Multimedia_Gallery_Edit_HDR_027(dt: Dt) {
  dt.log.i('支持HDR图片编辑保存后的图片，存储空间无明显变化 start');
  dt.log.i('STEP 1、查看hdr图片内存大小');

  await dt.sleep();
  dt.log.i('预期结果1、内存差值应该很小，对比编辑前应该减少1M以内');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入大图浏览-编辑，旋转图片+添加滤镜+一键调节后保存，查看图片内存大小');

  await dt.sleep();
  dt.log.i('STEP 3、对比编辑保存前后内存差值（覆盖保存/另存为）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持HDR图片编辑保存后的图片，存储空间无明显变化 end');
}

/**
 * 编辑-应用锁: [图片编辑与应用锁交互验证]
 * GROUP: 编辑 MODULE: 应用锁TID: Multimedia_Gallery_Edit_Lock_001
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、未设置图库应用锁
 */
async function Multimedia_Gallery_Edit_Lock_001(dt: Dt) {
  dt.log.i('图片编辑与应用锁交互验证 start');
  dt.log.i('STEP 1、长按图库应用图标，添加应用锁');

  await dt.sleep();
  dt.log.i('预期结果1、应用锁添加成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开图库，选择图片遍历编辑内裁剪、ai修图、调节、滤镜、涂鸦等功能，并保存编辑图片');

  await dt.sleep();
  dt.log.i('预期结果2、打开图库需要输入密码，编辑功能正常使用，图片保存成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、位于编辑界面时锁屏后，解锁手机');

  await dt.sleep();
  dt.log.i('预期结果3、解锁后直接进入图库，无需再次解锁，编辑功能及编辑保存正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、编辑界面位于后台时锁屏，解锁手机');

  await dt.sleep();
  dt.log.i('预期结果4、解锁后未进入图库，打开图库需输入密码，解锁后编辑功能及编辑保存正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、清理图库后台进程，重新进入图库');

  await dt.sleep();
  dt.log.i('预期结果5、无需再次输入密码，可直接进入，编辑功能及编辑保存正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、设置解锁方式为指纹解锁，重复步骤2-5');

  await dt.sleep();
  dt.log.i('预期结果6-7、编辑功能与保存正常8、编辑功能正常使用，图片保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、设置解锁方式为人脸识别，重复步骤2-5');

  await dt.sleep();
  dt.log.i('STEP 8、取消应用锁，打开图库，选择图片遍历编辑内裁剪、ai修图、调节、滤镜、涂鸦等功能，并保存编辑图片');

  await dt.sleep();
  dt.log.i('预期结果8、编辑功能正常使用，图片保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑与应用锁交互验证 end');
}