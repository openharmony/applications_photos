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

export default function IMediaAPPGalleryBasicFACardTest(): void {
  run('IMediaAPP_Gallery_BasicFA_card_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-滑动用例: [用户初次设置图库FA卡片，图片相册内有图片时，智能推送图片相册最新图片为封面图片] TID: IMediaAPP_Gallery_BasicFA_card_001
    await IMediaAPP_Gallery_BasicFA_card_001(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-用例: [添加两个FA卡片，观察是够同步刷新] TID: IMediaAPP_Gallery_BasicFA_card_019
    await IMediaAPP_Gallery_BasicFA_card_019(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-大图用例: [FA卡片单击浏览不同分辨率照片] TID: IMediaAPP_Gallery_BasicFA_card_023
    await IMediaAPP_Gallery_BasicFA_card_023(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-进入大图用例: [FA卡片进入大图浏览，复制照片] TID: IMediaAPP_Gallery_BasicFA_card_027
    await IMediaAPP_Gallery_BasicFA_card_027(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-进入大图用例: [FA卡片单击进入大图浏览左右滑动] TID: IMediaAPP_Gallery_BasicFA_card_030
    await IMediaAPP_Gallery_BasicFA_card_030(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-进入大图用例: [FA卡片单击进入大图浏览，编辑图片并保存] TID: IMediaAPP_Gallery_BasicFA_card_033
    await IMediaAPP_Gallery_BasicFA_card_033(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-进入大图用例: [FA卡片单击进入大图浏览，收藏/取消收藏图片] TID: IMediaAPP_Gallery_BasicFA_card_035
    await IMediaAPP_Gallery_BasicFA_card_035(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_0471', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-用例: [重启/灭屏手机后查看桌面FA卡片显示] TID: IMediaAPP_Gallery_BasicFA_card_0471
    await IMediaAPP_Gallery_BasicFA_card_0471(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_090', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-大图用例: [FA卡片单击浏览P3色域图片] TID: IMediaAPP_Gallery_BasicFA_card_090
    await IMediaAPP_Gallery_BasicFA_card_090(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_11', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-用例: [拖动FA移动位置观察FA卡片显示] TID: IMediaAPP_Gallery_BasicFA_card_11
    await IMediaAPP_Gallery_BasicFA_card_11(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_14', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-格式用例: [不同照片格式、比例、类型的FA卡片显示] TID: IMediaAPP_Gallery_BasicFA_card_14
    await IMediaAPP_Gallery_BasicFA_card_14(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_16', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-删除用例: [在图库中删除/恢复FA封面图片] TID: IMediaAPP_Gallery_BasicFA_card_16
    await IMediaAPP_Gallery_BasicFA_card_16(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_17', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-收藏用例: [在图库新增/取消收藏，观察FA封面图片] TID: IMediaAPP_Gallery_BasicFA_card_17
    await IMediaAPP_Gallery_BasicFA_card_17(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_20', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-删除用例: [FA卡片删除] TID: IMediaAPP_Gallery_BasicFA_card_20
    await IMediaAPP_Gallery_BasicFA_card_20(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_21', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-用例: [设备解锁/重启/升级后，FA卡片的变化] TID: IMediaAPP_Gallery_BasicFA_card_21
    await IMediaAPP_Gallery_BasicFA_card_21(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_22', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-端云用例: [FA卡片添加端云图片] TID: IMediaAPP_Gallery_BasicFA_card_22
    await IMediaAPP_Gallery_BasicFA_card_22(dt);
  });
  run('IMediaAPP_Gallery_BasicFA_card_23', Level.LEVEL3, async (dt: Dt): Promise<void> => {
    //  卡片-收藏用例: [添加FA卡片后，点击进入FA卡片，对图片大图进行分享/收藏/编辑/删除/更多等操作] TID: IMediaAPP_Gallery_BasicFA_card_23
    await IMediaAPP_Gallery_BasicFA_card_23(dt);
  });

}

/**
 * 卡片-滑动: [用户初次设置图库FA卡片，图片相册内有图片时，智能推送图片相册最新图片为封面图片]
 * GROUP: 卡片 MODULE: 滑动TID: IMediaAPP_Gallery_BasicFA_card_001
 * 前置条件
 * 1、图片相册内有图片
 */
async function IMediaAPP_Gallery_BasicFA_card_001(dt: Dt) {
  dt.log.i('用户初次设置图库FA卡片，图片相册内有图片时，智能推送图片相册最新图片为封面图片 start');
  dt.log.i('STEP 1、长按图库添加服务卡片，观察服务卡片添加界面卡片的显示');

  await dt.sleep();
  dt.log.i('预期结果1、卡片添加预览界面，所有卡片都是用最新图片为封面图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动选择卡片尺寸，添加到桌面，观察桌面上卡片的显示');

  await dt.sleep();
  dt.log.i('预期结果2.1、卡片样式为设置的卡片样式2.2、封面为对应相册的首张照片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户初次设置图库FA卡片，图片相册内有图片时，智能推送图片相册最新图片为封面图片 end');
}

/**
 * 卡片-: [添加两个FA卡片，观察是够同步刷新]
 * GROUP: 卡片 MODULE: TID: IMediaAPP_Gallery_BasicFA_card_019
 * 前置条件
 * 1、图库相机相册无照片
 */
async function IMediaAPP_Gallery_BasicFA_card_019(dt: Dt) {
  dt.log.i('添加两个FA卡片，观察是够同步刷新 start');
  dt.log.i('STEP 1、桌面图库上划，添加两个2*2/2*4/4*4FA卡片');

  await dt.sleep();
  dt.log.i('预期结果1、桌面展示想相对应的两个2*2/2*4/4*4FA卡片，默认显示版权图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相机拍摄照片');

  await dt.sleep();
  dt.log.i('预期结果2、同步显示相机相册照片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加两个FA卡片，观察是够同步刷新 end');
}

/**
 * 卡片-大图: [FA卡片单击浏览不同分辨率照片]
 * GROUP: 卡片 MODULE: 大图TID: IMediaAPP_Gallery_BasicFA_card_023
 * 前置条件
 * 1、桌面图库上划，添加2*2/2*4/4*4FA卡片
 2、图库图片相册预制照片
 */
async function IMediaAPP_Gallery_BasicFA_card_023(dt: Dt) {
  dt.log.i('FA卡片单击浏览不同分辨率照片 start');
  dt.log.i('STEP 1、长按FA卡片编辑选择照片');

  await dt.sleep();
  dt.log.i('STEP 2、选择不同分别率的照片（手机的默认几种分辨率的图片的 + 快图软件编辑生成的各种分辨率图片）');

  await dt.sleep();
  dt.log.i('预期结果2、大图正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片单击浏览不同分辨率照片 end');
}

/**
 * 卡片-进入大图: [FA卡片进入大图浏览，复制照片]
 * GROUP: 卡片 MODULE: 进入大图TID: IMediaAPP_Gallery_BasicFA_card_027
 * 前置条件
 * 1、图库图片相册预制照片
 2、有自定义相册
 */
async function IMediaAPP_Gallery_BasicFA_card_027(dt: Dt) {
  dt.log.i('FA卡片进入大图浏览，复制照片 start');
  dt.log.i('STEP 1、长按FA卡片编辑选择照片');

  await dt.sleep();
  dt.log.i('STEP 2、单击新添加的FA卡片进入大图浏览，点击更多选择“添加到相册”');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到图片列表');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、back到桌面查看卡片显示');

  await dt.sleep();
  dt.log.i('预期结果3、卡片上大图没有明显变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片进入大图浏览，复制照片 end');
}

/**
 * 卡片-进入大图: [FA卡片单击进入大图浏览左右滑动]
 * GROUP: 卡片 MODULE: 进入大图TID: IMediaAPP_Gallery_BasicFA_card_030
 * 前置条件
 * 1、桌面有2*2、2*4、4*4 相册卡片
 2、相册预置包括仅含图片、图片+视频相册
 */
async function IMediaAPP_Gallery_BasicFA_card_030(dt: Dt) {
  dt.log.i('FA卡片单击进入大图浏览左右滑动 start');
  dt.log.i('STEP 1、单击新添加的FA卡片进入大图浏览');

  await dt.sleep();
  dt.log.i('预期结果1.1、若相册最新文件为照片，点击FA进入大图显示封面照片对应的大图1.2、若相册最新文件为视频，点击FA进入大图依然显示封面照片对应的大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动照片');

  await dt.sleep();
  dt.log.i('预期结果2、大图浏览左右滑动正常，展示相册的全部数据，顺序显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片单击进入大图浏览左右滑动 end');
}

/**
 * 卡片-进入大图: [FA卡片单击进入大图浏览，编辑图片并保存]
 * GROUP: 卡片 MODULE: 进入大图TID: IMediaAPP_Gallery_BasicFA_card_033
 * 前置条件
 * 1、桌面图库上划，添加2*2、2*4、4*4 FA卡片
 2、图库相机相册预制照片
 */
async function IMediaAPP_Gallery_BasicFA_card_033(dt: Dt) {
  dt.log.i('FA卡片单击进入大图浏览，编辑图片并保存 start');
  dt.log.i('STEP 1、长按FA卡片编辑选择照片');

  await dt.sleep();
  dt.log.i('STEP 2、单击新添加的FA卡片进入大图浏览，编辑照片（裁剪/旋转）');

  await dt.sleep();
  dt.log.i('STEP 3、在图库中编辑FA封面图片另存后，返回桌面FA卡片观察');

  await dt.sleep();
  dt.log.i('预期结果3、FA卡片内容不会变化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在图库中编辑FA封面图片覆盖原图后，返回桌面FA卡片观察');

  await dt.sleep();
  dt.log.i('预期结果4、FA卡片改变为编辑后的样式');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片单击进入大图浏览，编辑图片并保存 end');
}

/**
 * 卡片-进入大图: [FA卡片单击进入大图浏览，收藏/取消收藏图片]
 * GROUP: 卡片 MODULE: 进入大图TID: IMediaAPP_Gallery_BasicFA_card_035
 * 前置条件
 * 1、桌面图库上划，添加2*2、2*4、4*4FA卡片
 2、图库相机相册预制照片
 */
async function IMediaAPP_Gallery_BasicFA_card_035(dt: Dt) {
  dt.log.i('FA卡片单击进入大图浏览，收藏/取消收藏图片 start');
  dt.log.i('STEP 1、单击FA卡片进入大图浏览，点击收藏');

  await dt.sleep();
  dt.log.i('STEP 2、收藏后查看“我的收藏”相册');

  await dt.sleep();
  dt.log.i('预期结果2、照片被收藏，且在收藏相册中找到这张被收藏的照片4、照片被取消收藏，且在收藏相册中找不到这张被收藏的照片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次进入大图浏览，取消之前收藏的照片');

  await dt.sleep();
  dt.log.i('STEP 4、取消收藏后查看“我的收藏”相册');

  await dt.sleep();
  dt.log.i('预期结果4、照片被取消收藏，且在收藏相册中找不到这张被收藏的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片单击进入大图浏览，收藏/取消收藏图片 end');
}

/**
 * 卡片-: [重启/灭屏手机后查看桌面FA卡片显示]
 * GROUP: 卡片 MODULE: TID: IMediaAPP_Gallery_BasicFA_card_0471
 * 前置条件
 * 1、FA卡片正常显示
 */
async function IMediaAPP_Gallery_BasicFA_card_0471(dt: Dt) {
  dt.log.i('重启/灭屏手机后查看桌面FA卡片显示 start');
  dt.log.i('STEP 1、灭屏手机进入桌面查看图库FA卡片');

  await dt.sleep();
  dt.log.i('预期结果1-2、FA卡片正常加载图库数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、重启手机后进入桌面查看图库FA卡片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重启/灭屏手机后查看桌面FA卡片显示 end');
}

/**
 * 卡片-大图: [FA卡片单击浏览P3色域图片]
 * GROUP: 卡片 MODULE: 大图TID: IMediaAPP_Gallery_BasicFA_card_090
 * 前置条件
 * 1、桌面图库上划，添加2*2/2*4/4*4FA卡片
 2、图库相机相册预制P3色域照片
 */
async function IMediaAPP_Gallery_BasicFA_card_090(dt: Dt) {
  dt.log.i('FA卡片单击浏览P3色域图片 start');
  dt.log.i('STEP 1、长按FA卡片编辑选择图片');

  await dt.sleep();
  dt.log.i('STEP 2、选择P3色域照片');

  await dt.sleep();
  dt.log.i('预期结果2、大图正常显示，和在图库查看此张P3色域照片显示效果一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片单击浏览P3色域图片 end');
}

/**
 * 卡片-: [拖动FA移动位置观察FA卡片显示]
 * GROUP: 卡片 MODULE: TID: IMediaAPP_Gallery_BasicFA_card_11
 * 前置条件
 * 1、FA卡片已添加相机相册
 */
async function IMediaAPP_Gallery_BasicFA_card_11(dt: Dt) {
  dt.log.i('拖动FA移动位置观察FA卡片显示 start');
  dt.log.i('STEP 1、长按拖动FA卡片，观察拖动过程和停止拖动后的FA卡片显示');

  await dt.sleep();
  dt.log.i('预期结果1、FA卡片正常显示当前封面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖动FA移动位置观察FA卡片显示 end');
}

/**
 * 卡片-格式: [不同照片格式、比例、类型的FA卡片显示]
 * GROUP: 卡片 MODULE: 格式TID: IMediaAPP_Gallery_BasicFA_card_14
 * 前置条件
 * 1、图库中有/无照片

 */
async function IMediaAPP_Gallery_BasicFA_card_14(dt: Dt) {
  dt.log.i('不同照片格式、比例、类型的FA卡片显示 start');
  dt.log.i('STEP 1、图库中无图片时，长按桌面图库图标，添加三种不同尺寸FA卡片至桌面及负一屏（2*2、2*4、4*4）');

  await dt.sleep();
  dt.log.i('预期结果1、卡片添加成功，卡片显示默认图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图库中无图片时，添加一张FA卡片，再通过拍照/截屏等方式添加一张图片');

  await dt.sleep();
  dt.log.i('预期结果2、卡片添加成功，卡片刷新为图库中的最新添加的图片，后续继续新增图片，卡片不会刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图库中存在多张图片时，长按桌面图库图标，添加三种不同尺寸FA卡片至桌面及负一屏（2*2、2*4、4*4）');

  await dt.sleep();
  dt.log.i('预期结果3、卡片添加成功，卡片刷新为图库中的最新照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同照片格式、比例、类型的FA卡片显示 end');
}

/**
 * 卡片-删除: [在图库中删除/恢复FA封面图片]
 * GROUP: 卡片 MODULE: 删除TID: IMediaAPP_Gallery_BasicFA_card_16
 * 前置条件
 * ""1、图库中存在图片
 2、FA卡片添加正常""

 */
async function IMediaAPP_Gallery_BasicFA_card_16(dt: Dt) {
  dt.log.i('在图库中删除/恢复FA封面图片 start');
  dt.log.i('STEP 1、添加一张FA卡片至桌面，点击进入FA卡片/打开图库，编辑该图片，对图片进行覆盖原图保存或另存为');

  await dt.sleep();
  dt.log.i('预期结果1、图片编辑成功，FA卡片刷新成编辑后的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、添加一张FA卡片至桌面，点击进入FA卡片/打开图库，删除该图片');

  await dt.sleep();
  dt.log.i('预期结果2、点图片删除成功，大图刷新为下一张图片，回到桌面后，FA卡片刷新为默认图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、添加一张FA卡片至桌面，将图库内所有图片均删除，再将全部图片进行恢复');

  await dt.sleep();
  dt.log.i('预期结果3、FA卡片先刷新成默认图片，再更新为删除图库所有照片前，图库中的最早一张图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、添加一张FA卡片至桌面，长按卡片-编辑-选择图片');

  await dt.sleep();
  dt.log.i('预期结果4、可以选择图库内任意一张图片，FA卡片刷新成选中的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('在图库中删除/恢复FA封面图片 end');
}

/**
 * 卡片-收藏: [在图库新增/取消收藏，观察FA封面图片]
 * GROUP: 卡片 MODULE: 收藏TID: IMediaAPP_Gallery_BasicFA_card_17
 * 前置条件
 * 1、FA卡片已添加“我的收藏”相册
 */
async function IMediaAPP_Gallery_BasicFA_card_17(dt: Dt) {
  dt.log.i('在图库新增/取消收藏，观察FA封面图片 start');
  dt.log.i('STEP 1、在图库中新增收藏照片，返回桌面观察FA卡片');

  await dt.sleep();
  dt.log.i('预期结果1、新增收藏FA卡片封面不变；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、取消封面图片收藏');

  await dt.sleep();
  dt.log.i('预期结果2、FA卡片封面刷新为下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、取消所有收藏，返回桌面观察FA卡片');

  await dt.sleep();
  dt.log.i('预期结果3、取消所有收藏FA卡片显示版权图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('在图库新增/取消收藏，观察FA封面图片 end');
}

/**
 * 卡片-删除: [FA卡片删除]
 * GROUP: 卡片 MODULE: 删除TID: IMediaAPP_Gallery_BasicFA_card_20
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function IMediaAPP_Gallery_BasicFA_card_20(dt: Dt) {
  dt.log.i('FA卡片删除 start');
  dt.log.i('STEP 1，将相册设置为FA卡片，删除相册名');

  await dt.sleep();
  dt.log.i('预期结果1，相册进行删除后FA卡片无变动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2，删除图片相册下所有图片');

  await dt.sleep();
  dt.log.i('预期结果2，删除后FA卡片重置为默认壁纸图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片删除 end');
}

/**
 * 卡片-: [设备解锁/重启/升级后，FA卡片的变化]
 * GROUP: 卡片 MODULE: TID: IMediaAPP_Gallery_BasicFA_card_21
 * 前置条件
 * 1、图库中存在图片
 2、FA卡片添加正常
 */
async function IMediaAPP_Gallery_BasicFA_card_21(dt: Dt) {
  dt.log.i('设备解锁/重启/升级后，FA卡片的变化 start');
  dt.log.i('STEP 1、桌面添加图库FA卡片后，锁定手机屏幕');

  await dt.sleep();
  dt.log.i('预期结果1、手机解锁后仍显示之前的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、桌面添加图库FA卡片后，重启手机');

  await dt.sleep();
  dt.log.i('预期结果2、重启手机后仍显示之前的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、安装更低的ROM版本，桌面添加图库FA卡片后，在设置-通用-系统更新处，检查手机更新情况，将手机升级');

  await dt.sleep();
  dt.log.i('预期结果3、手机升级后仍显示之前的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设备解锁/重启/升级后，FA卡片的变化 end');
}

/**
 * 卡片-端云: [FA卡片添加端云图片]
 * GROUP: 卡片 MODULE: 端云TID: IMediaAPP_Gallery_BasicFA_card_22
 * 前置条件
 * 1、图库中存在图片
 2、FA卡片添加正常
 3、登录云账号
 */
async function IMediaAPP_Gallery_BasicFA_card_22(dt: Dt) {
  dt.log.i('FA卡片添加端云图片 start');
  dt.log.i('STEP 1、图库中无图片情况下，添加一张FA卡片，登录云账号，同步云上照片，照片同步完后，观察FA卡片变化');

  await dt.sleep();
  dt.log.i('预期结果1、2 FA卡片显示最新的端云图片3、FA卡片显示最新的图片4、FA卡片显示选中的端云图片5、FA卡片正常显示为最新的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图库中无图片情况下，登录云账号，同步云上照片，添加一张FA卡片，观察FA卡片变化');

  await dt.sleep();
  dt.log.i('STEP 3、图库中有图片情况下，登录云账号，同步云上照片，添加一张FA卡片，观察FA卡片变化');

  await dt.sleep();
  dt.log.i('预期结果3、FA卡片显示最新的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、添加一张FA卡片，长按卡片-编辑-选择图片，选择图片时选择端云的图片');

  await dt.sleep();
  dt.log.i('预期结果4、FA卡片显示选中的端云图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、同步完端云图片后，将手机断网');

  await dt.sleep();
  dt.log.i('预期结果5、FA卡片正常显示为最新的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA卡片添加端云图片 end');
}

/**
 * 卡片-收藏: [添加FA卡片后，点击进入FA卡片，对图片大图进行分享/收藏/编辑/删除/更多等操作]
 * GROUP: 卡片 MODULE: 收藏TID: IMediaAPP_Gallery_BasicFA_card_23
 * 前置条件
 * 1、图库中存在图片
 2、FA卡片添加正常
 */
async function IMediaAPP_Gallery_BasicFA_card_23(dt: Dt) {
  dt.log.i('添加FA卡片后，点击进入FA卡片，对图片大图进行分享/收藏/编辑/删除/更多等操作 start');
  dt.log.i('STEP 1、FA卡片添加成功，进入大图后，分享/收藏/取消收藏/编辑/删除/添加至相册/复制/隐藏/重命名等操作');

  await dt.sleep();
  dt.log.i('预期结果1、FA卡片的大图各项操作正常，与图库打开大图一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、FA卡片添加成功，进入大图后，点击返回按钮/下拉返回/侧滑返回');

  await dt.sleep();
  dt.log.i('预期结果2、FA返回正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、FA卡片添加成功，进入大图后，点击右上角图片图标');

  await dt.sleep();
  dt.log.i('预期结果3、进入图库照片页tab');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、FA卡片添加成功，进入大图后，点击右上角的感叹号/上滑大图查看详情');

  await dt.sleep();
  dt.log.i('预期结果4、大图详情信息展示正常，添加备注/重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、FA卡片添加成功，进入大图后，长按图片进行抠图');

  await dt.sleep();
  dt.log.i('预期结果5、图片抠图成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、FA卡片添加成功，进入大图后，使用ai控件识别文字');

  await dt.sleep();
  dt.log.i('预期结果6、ai控件识别文字正常，复制文字功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加FA卡片后，点击进入FA卡片，对图片大图进行分享/收藏/编辑/删除/更多等操作 end');
}













