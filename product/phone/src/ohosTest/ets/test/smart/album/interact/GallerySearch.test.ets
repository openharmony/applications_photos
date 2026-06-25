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

export default function GallerySearchTest(): void {

  // Defines a test suite. Two parameters are supported: test suite name and test suite function.

  // Presets an action, which is performed only once before all test cases of the test suite start.

  // This API supports only one parameter: preset action function.

  describe('GallerySearchTest', (): void => {

    /**
     *
     * 确认当前图库app处于启动状态
     *
     */

    beforeAll(async (): Promise<void> => {

      await AppStart.photos();

      const dt = await new Dt('beforeAllGallerySearch').init();

      dt.log.i('beforeAll GallerySearch start');

      dt.log.i('beforeAll GallerySearch finish');

    });

    /**
     *
     * 打开大图
     *
     */

    run('beforeGallerySearch', Level.LEVEL0, async (dt: Dt): Promise<void> => {

      await dt.browser();

    });

    // DT声明

    run('Multimedia_Gallery_Search_0011', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-滑动用例: [搜索框为空点击搜索键盘不收起] TID: Multimedia_Gallery_Search_0011

      await Multimedia_Gallery_Search_0011(dt);

    });

    run('Multimedia_Gallery_Search_0012', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [语言设置为维语检查] TID: Multimedia_Gallery_Search_0012

      await Multimedia_Gallery_Search_0012(dt);

    });

    run('Multimedia_Gallery_Search_1', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [联想搜索标签顺序显示] TID: Multimedia_Gallery_Search_1

      await Multimedia_Gallery_Search_1(dt);

    });

    run('Multimedia_Gallery_Search_10', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [中文环境截屏OCR搜索] TID: Multimedia_Gallery_Search_10

      await Multimedia_Gallery_Search_10(dt);

    });

    run('Multimedia_Gallery_Search_100', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索月和市家组合关键字] TID: Multimedia_Gallery_Search_100

      await Multimedia_Gallery_Search_100(dt);

    });

    run('Multimedia_Gallery_Search_101', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [父亲节照片支持文字搜索] TID: Multimedia_Gallery_Search_101

      await Multimedia_Gallery_Search_101(dt);

    });

    run('Multimedia_Gallery_Search_102', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [妇女节照片支持文字搜索] TID: Multimedia_Gallery_Search_102

      await Multimedia_Gallery_Search_102(dt);

    });

    run('Multimedia_Gallery_Search_103', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [国庆节照片支持文字搜索] TID: Multimedia_Gallery_Search_103

      await Multimedia_Gallery_Search_103(dt);

    });

    run('Multimedia_Gallery_Search_104', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [清明节照片支持文字搜索] TID: Multimedia_Gallery_Search_104

      await Multimedia_Gallery_Search_104(dt);

    });

    run('Multimedia_Gallery_Search_105', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [文字搜索结果在搜索框手动输入可以搜到结果的关键词] TID: Multimedia_Gallery_Search_105

      await Multimedia_Gallery_Search_105(dt);

    });

    run('Multimedia_Gallery_Search_106', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [母亲节照片支持文字搜索] TID: Multimedia_Gallery_Search_106

      await Multimedia_Gallery_Search_106(dt);

    });

    run('Multimedia_Gallery_Search_107', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [元旦节照片支持文字搜索] TID: Multimedia_Gallery_Search_107

      await Multimedia_Gallery_Search_107(dt);

    });

    run('Multimedia_Gallery_Search_108', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [渐进式搜索结果合理性验证] TID: Multimedia_Gallery_Search_108

      await Multimedia_Gallery_Search_108(dt);

    });

    run('Multimedia_Gallery_Search_109', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [中秋节照片支持文字搜索] TID: Multimedia_Gallery_Search_109

      await Multimedia_Gallery_Search_109(dt);

    });

    run('Multimedia_Gallery_Search_11', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [横屏手机、xxx，pad按照宫格界面展示推荐照片] TID: Multimedia_Gallery_Search_11

      await Multimedia_Gallery_Search_11(dt);

    });

    run('Multimedia_Gallery_Search_110', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [春节支持文字搜索] TID: Multimedia_Gallery_Search_110

      await Multimedia_Gallery_Search_110(dt);

    });

    run('Multimedia_Gallery_Search_111', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [文字搜索结果在搜索框手动输入不可以搜到结果的关键词] TID: Multimedia_Gallery_Search_111

      await Multimedia_Gallery_Search_111(dt);

    });

    run('Multimedia_Gallery_Search_112', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [劳动节照片支持文字搜索] TID: Multimedia_Gallery_Search_112

      await Multimedia_Gallery_Search_112(dt);

    });

    run('Multimedia_Gallery_Search_113', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [重阳节照片支持文字搜索] TID: Multimedia_Gallery_Search_113

      await Multimedia_Gallery_Search_113(dt);

    });

    run('Multimedia_Gallery_Search_114', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [情人节照片支持文字搜索] TID: Multimedia_Gallery_Search_114

      await Multimedia_Gallery_Search_114(dt);

    });

    run('Multimedia_Gallery_Search_115', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [端午节照片支持文字搜索] TID: Multimedia_Gallery_Search_115

      await Multimedia_Gallery_Search_115(dt);

    });

    run('Multimedia_Gallery_Search_116', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索性能测试（索引构建完成）] TID: Multimedia_Gallery_Search_116

      await Multimedia_Gallery_Search_116(dt);

    });

    run('Multimedia_Gallery_Search_117', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索非同一个文件名里的非连续关键字组合搜索] TID: Multimedia_Gallery_Search_117

      await Multimedia_Gallery_Search_117(dt);

    });

    run('Multimedia_Gallery_Search_118', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索地点的其中几个连续字进行搜索] TID: Multimedia_Gallery_Search_118

      await Multimedia_Gallery_Search_118(dt);

    });

    run('Multimedia_Gallery_Search_119', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索非同一个备注里的连续关键字组合搜索] TID: Multimedia_Gallery_Search_119

      await Multimedia_Gallery_Search_119(dt);

    });

    run('Multimedia_Gallery_Search_12', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [推荐规则] TID: Multimedia_Gallery_Search_12

      await Multimedia_Gallery_Search_12(dt);

    });

    run('Multimedia_Gallery_Search_120', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [输入超过85个空格分隔的有效关键字] TID: Multimedia_Gallery_Search_120

      await Multimedia_Gallery_Search_120(dt);

    });

    run('Multimedia_Gallery_Search_121', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索非同一个相册名里的非连续关键字组合搜索] TID: Multimedia_Gallery_Search_121

      await Multimedia_Gallery_Search_121(dt);

    });

    run('Multimedia_Gallery_Search_123', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索非同一个备注里的非连续关键字组合搜索] TID: Multimedia_Gallery_Search_123

      await Multimedia_Gallery_Search_123(dt);

    });

    run('Multimedia_Gallery_Search_124', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [胶囊、联想搜索遍历Pad，Teton设备] TID: Multimedia_Gallery_Search_124

      await Multimedia_Gallery_Search_124(dt);

    });

    run('Multimedia_Gallery_Search_125', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-竖屏用例: [胶囊、联想搜索遍历横竖屏模式、深色模式、大字体模式] TID: Multimedia_Gallery_Search_125

      await Multimedia_Gallery_Search_125(dt);

    });

    run('Multimedia_Gallery_Search_126', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [隐藏截图后搜索] TID: Multimedia_Gallery_Search_126

      await Multimedia_Gallery_Search_126(dt);

    });

    run('Multimedia_Gallery_Search_127', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-删除用例: [AB登陆同一云账号，B增删改云端照片，A实时搜索界面点击展开查看] TID: Multimedia_Gallery_Search_127

      await Multimedia_Gallery_Search_127(dt);

    });

    run('Multimedia_Gallery_Search_128', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [分类完成，索引未构建完成，实时搜索界面点击展开查看] TID: Multimedia_Gallery_Search_128

      await Multimedia_Gallery_Search_128(dt);

    });

    run('Multimedia_Gallery_Search_129', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [实时搜索命中1万条数据性能测试] TID: Multimedia_Gallery_Search_129

      await Multimedia_Gallery_Search_129(dt);

    });

    run('Multimedia_Gallery_Search_13', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [输入词自动联想] TID: Multimedia_Gallery_Search_13

      await Multimedia_Gallery_Search_13(dt);

    });

    run('Multimedia_Gallery_Search_130', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索结果点击“更多”到“更多”页内容显示完成性能] TID: Multimedia_Gallery_Search_130

      await Multimedia_Gallery_Search_130(dt);

    });

    run('Multimedia_Gallery_Search_131', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [英语下搜索省关键字] TID: Multimedia_Gallery_Search_131

      await Multimedia_Gallery_Search_131(dt);

    });

    run('Multimedia_Gallery_Search_132', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [英语下搜索国家、省、市、区县组合关键字（无归属关系）] TID: Multimedia_Gallery_Search_132

      await Multimedia_Gallery_Search_132(dt);

    });

    run('Multimedia_Gallery_Search_133', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [英语下年月日和地点的非连续字符组合搜索] TID: Multimedia_Gallery_Search_133

      await Multimedia_Gallery_Search_133(dt);

    });

    run('Multimedia_Gallery_Search_134', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [英语下搜索街道关键字] TID: Multimedia_Gallery_Search_134

      await Multimedia_Gallery_Search_134(dt);

    });

    run('Multimedia_Gallery_Search_135', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [照片页、相册页横屏进入搜索] TID: Multimedia_Gallery_Search_135

      await Multimedia_Gallery_Search_135(dt);

    });

    run('Multimedia_Gallery_Search_136', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索中输入文档，推荐标签能推荐出身份证、护照、银行卡、ppt和名片（体验性）] TID: Multimedia_Gallery_Search_136

      await Multimedia_Gallery_Search_136(dt);

    });

    run('Multimedia_Gallery_Search_137', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-竖屏用例: [搜索建议界面人像、地点分类横竖屏分别显示的相册数量] TID: Multimedia_Gallery_Search_137

      await Multimedia_Gallery_Search_137(dt);

    });

    run('Multimedia_Gallery_Search_138', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索中来电，挂断后不会影响搜索结果] TID: Multimedia_Gallery_Search_138

      await Multimedia_Gallery_Search_138(dt);

    });

    run('Multimedia_Gallery_Search_139', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [设备克隆之后使用联想搜索和胶囊搜索] TID: Multimedia_Gallery_Search_139

      await Multimedia_Gallery_Search_139(dt);

    });

    run('Multimedia_Gallery_Search_14', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [图库有图片和视频时，查看搜索建议界面] TID: Multimedia_Gallery_Search_14

      await Multimedia_Gallery_Search_14(dt);

    });

    run('Multimedia_Gallery_Search_140', Level.LEVEL4, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [后置摄像头拍的人像不支持“自拍“搜索] TID: Multimedia_Gallery_Search_140

      await Multimedia_Gallery_Search_140(dt);

    });

    run('Multimedia_Gallery_Search_15', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [实时更新推荐8张展示照片支持全部展开，为向下展开，不跳转新画面，保留上方搜索功能。] TID: Multimedia_Gallery_Search_15

      await Multimedia_Gallery_Search_15(dt);

    });

    run('Multimedia_Gallery_Search_16', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [联想搜索界面显示] TID: Multimedia_Gallery_Search_16

      await Multimedia_Gallery_Search_16(dt);

    });

    run('Multimedia_Gallery_Search_17', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [胶囊搜索] TID: Multimedia_Gallery_Search_17

      await Multimedia_Gallery_Search_17(dt);

    });

    run('Multimedia_Gallery_Search_18', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-收藏用例: [搜索结果一级界面照片收藏、删除查看] TID: Multimedia_Gallery_Search_18

      await Multimedia_Gallery_Search_18(dt);

    });

    run('Multimedia_Gallery_Search_19', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索结果检查] TID: Multimedia_Gallery_Search_19

      await Multimedia_Gallery_Search_19(dt);

    });

    run('Multimedia_Gallery_Search_2', Level.LEVEL3, async (dt: Dt): Promise<void> => {

      //  智慧图库-拖拽用例: [本地图片搜索结果一级界面top8缩略图支持长按拖拽] TID: Multimedia_Gallery_Search_2

      await Multimedia_Gallery_Search_2(dt);

    });

    run('Multimedia_Gallery_Search_20', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [联想搜索显示] TID: Multimedia_Gallery_Search_20

      await Multimedia_Gallery_Search_20(dt);

    });

    run('Multimedia_Gallery_Search_21', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [搜索同一个备注里的连续关键字搜索（包括视频和图片备注）] TID: Multimedia_Gallery_Search_21

      await Multimedia_Gallery_Search_21(dt);

    });

    run('Multimedia_Gallery_Search_22', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-下载用例: [相册名搜索] TID: Multimedia_Gallery_Search_22

      await Multimedia_Gallery_Search_22(dt);

    });

    run('Multimedia_Gallery_Search_24', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-大图用例: [支持节假日别称的搜索] TID: Multimedia_Gallery_Search_24

      await Multimedia_Gallery_Search_24(dt);

    });

    run('Multimedia_Gallery_Search_25', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [支持季节的搜索] TID: Multimedia_Gallery_Search_25

      await Multimedia_Gallery_Search_25(dt);

    });

    run('Multimedia_Gallery_Search_26', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索人像名关键字] TID: Multimedia_Gallery_Search_26

      await Multimedia_Gallery_Search_26(dt);

    });

    run('Multimedia_Gallery_Search_27', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索地点单个关键字] TID: Multimedia_Gallery_Search_27

      await Multimedia_Gallery_Search_27(dt);

    });

    run('Multimedia_Gallery_Search_28', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索市关键字] TID: Multimedia_Gallery_Search_28

      await Multimedia_Gallery_Search_28(dt);

    });

    run('Multimedia_Gallery_Search_29', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索国家关键字] TID: Multimedia_Gallery_Search_29

      await Multimedia_Gallery_Search_29(dt);

    });

    run('Multimedia_Gallery_Search_3', Level.LEVEL1, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [按照地点分类搜索在上海拍的照片] TID: Multimedia_Gallery_Search_3

      await Multimedia_Gallery_Search_3(dt);

    });

    run('Multimedia_Gallery_Search_30', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-用例: [搜索区县关键字] TID: Multimedia_Gallery_Search_30

      await Multimedia_Gallery_Search_30(dt);

    });

    /**
     *
     * 确保每次测试完毕回到大图页
     *
     */

    afterEach(async (): Promise<void> => {

      const dt = await new Dt('afterEachGallerySearch').init();

      dt.log.i('afterEach GallerySearch start');

      await dt.sleep(DELAY.short);

      dt.log.i('afterEach GallerySearch finish');

    });

    /**
     *
     * 退出大图 回到时间线页面
     *
     */

    afterAll(async (): Promise<void> => {

      const dt = await new Dt('afterAllGallerySearch').init();

      dt.log.i('afterAll GallerySearch start');

      await Exit.browser();

      dt.log.i('afterAll GallerySearch finish');

    });

  });

}

// DT步骤

/**
 *
 * 智慧图库-滑动: [搜索框为空点击搜索键盘不收起]
 *
 * GROUP: 智慧图库 MODULE: 滑动TID: Multimedia_Gallery_Search_0011
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_0011(dt: Dt) {

  dt.log.i('搜索框为空点击搜索键盘不收起 start');

  dt.log.i('STEP 1、进入图库搜索页，搜索框不输入，点击键盘搜索键或回车键，查看页面反馈；');

  await dt.sleep();

  dt.log.i('预期结果1、键盘不收起，  toast提示：输入内容不能为空；');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、搜索框输入无效关键词，点击键盘搜索键或回车键，查看页面反馈；');

  await dt.sleep();

  dt.log.i('预期结果2、键盘不收起，页面显示文本：没有“xxxxxx”的搜索结果，请尝试其他搜索词；');

  await dt.sleep(DELAY.double);

  await dt.driver.assertComponentExist(ON.text('xxxxxx'));

  dt.log.i('STEP 3、搜索框输入关键词，有效/无效场景收起键盘，再次点击搜索框调起键盘，再页面上滑动，查看页面反馈。');

  await dt.sleep();

  dt.log.i('预期结果3、滑动页面时键盘收起。');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索框为空点击搜索键盘不收起 end');

}

/**
 *
 * 智慧图库-: [语言设置为维语检查]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_0012
 *
 * 前置条件
 *
 * 1、预置图库资源，充电息屏分析完成；
 *
 2、切换语言为维语。

 */

async function Multimedia_Gallery_Search_0012(dt: Dt) {

  dt.log.i('语言设置为维语检查 start');

  dt.log.i('STEP 1、进入图库搜索页；');

  await dt.sleep();

  dt.log.i('STEP 2、搜索框输入单字、数字、特殊符号、短语、随机语言文字等能搜索到结果的关键词并搜索，查看页面反馈。');

  await dt.sleep();

  dt.log.i('预期结果2、搜索页按照维语习惯显示；搜索结果按照维语习惯显示，显示内容正确，UX符合逻辑，');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('语言设置为维语检查 end');

}

/**
 *
 * 智慧图库-视频: [联想搜索标签顺序显示]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_1
 *
 * 前置条件
 *
 * 图库中图片和视频
 *
 */

async function Multimedia_Gallery_Search_1(dt: Dt) {

  dt.log.i('联想搜索标签顺序显示 start');

  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();

  dt.log.i('STEP 2、输入“2022”');

  await dt.sleep();

  dt.log.i('STEP 3、查看联想搜索标签');

  await dt.sleep();

  dt.log.i('预期结果3、按显示顺序循环选取，直至5个或没了，其中⼈物（亲密关系、⼈物相册命名）显示2个：时间（年、⽉、⽇、节⽇）1个；静态标签、动态标签、⼤类（动植物、⻛景）、⼩类（猫、⼭、海）、⾼光时刻标1个；OCR文本、相册命名、拍摄模式、图片标题1个；地点（国家、省、城市、区、街道、poi）不限个数');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('联想搜索标签顺序显示 end');

}

/**
 *
 * 智慧图库-: [中文环境截屏OCR搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_10
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机切换为中文

 */

async function Multimedia_Gallery_Search_10(dt: Dt) {

  dt.log.i('中文环境截屏OCR搜索 start');

  dt.log.i('STEP 1、进入指定应用的界面 （如微信）                                                                                             ');

  await dt.sleep();

  dt.log.i('STEP 2、使用指关节在界面画S，长截屏指定应用');

  await dt.sleep();

  dt.log.i('STEP 3、等数据同步和索引更新完成（约2min左右）');

  await dt.sleep();

  dt.log.i('STEP 4、进入图库搜索界面，输入应用的中文名称');

  await dt.sleep();

  dt.log.i('预期结果4、可以搜索出该应用的名称（如微信）');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('中文环境截屏OCR搜索 end');

}

/**
 *
 * 智慧图库-: [搜索月和市家组合关键字]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_100
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_100(dt: Dt) {

  dt.log.i('搜索月和市家组合关键字 start');

  dt.log.i('STEP 1、进入搜索页面，搜索月和市家组合关键字');

  await dt.sleep();

  dt.log.i('预期结果1、对应时间地点的照片会被搜索出来');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索月和市家组合关键字 end');

}

/**
 *
 * 智慧图库-: [父亲节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_101
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制父亲节的照片

 */

async function Multimedia_Gallery_Search_101(dt: Dt) {

  dt.log.i('父亲节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入父亲节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示父亲节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('父亲节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [妇女节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_102
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制妇女节的照片

 */

async function Multimedia_Gallery_Search_102(dt: Dt) {

  dt.log.i('妇女节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入妇女节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示妇女节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('妇女节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [国庆节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_103
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制国庆节的照片

 */

async function Multimedia_Gallery_Search_103(dt: Dt) {

  dt.log.i('国庆节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入国庆节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示国庆时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('国庆节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [清明节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_104
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制清明节的照片

 */

async function Multimedia_Gallery_Search_104(dt: Dt) {

  dt.log.i('清明节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入清明节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示清明节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('清明节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [文字搜索结果在搜索框手动输入可以搜到结果的关键词]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_105
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机中预制人像、地点、时间、节假日、分类的照片

 */

async function Multimedia_Gallery_Search_105(dt: Dt) {

  dt.log.i('文字搜索结果在搜索框手动输入可以搜到结果的关键词 start');

  dt.log.i('STEP 1、在图库入口界面输入包含地点的文字指令');

  await dt.sleep();

  dt.log.i('预期结果1、有搜索结果，直接展示搜索结果，搜索框下面有推荐的胶囊');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在搜索框手动输入可以搜索到结果的关键词');

  await dt.sleep();

  dt.log.i('预期结果2、搜索结果界面近一步缩小');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('文字搜索结果在搜索框手动输入可以搜到结果的关键词 end');

}

/**
 *
 * 智慧图库-: [母亲节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_106
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制母亲节的照片

 */

async function Multimedia_Gallery_Search_106(dt: Dt) {

  dt.log.i('母亲节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入母亲节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示母亲节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('母亲节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [元旦节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_107
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制元旦节的照片

 */

async function Multimedia_Gallery_Search_107(dt: Dt) {

  dt.log.i('元旦节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入元旦节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示元旦节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('元旦节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [渐进式搜索结果合理性验证]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_108
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机中预制人像、地点、时间、节假日、分类的照片

 */

async function Multimedia_Gallery_Search_108(dt: Dt) {

  dt.log.i('渐进式搜索结果合理性验证 start');

  dt.log.i('STEP 1、在搜索输入框手动输入人像自定义标签文字指令');

  await dt.sleep();

  dt.log.i('预期结果1、搜索的结果中包含了日期、文件名、文本备注、地点、相册、OCR文字识别和截屏应用的所有结果');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在搜索输入框手动输入地点标签文字指令');

  await dt.sleep();

  dt.log.i('预期结果2、搜索的结果中包含了日期、文件名、文本备注、地点、相册、OCR文字识别和截屏应用的所有结果');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('渐进式搜索结果合理性验证 end');

}

/**
 *
 * 智慧图库-: [中秋节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_109
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制中秋节的照片

 */

async function Multimedia_Gallery_Search_109(dt: Dt) {

  dt.log.i('中秋节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入中秋节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示中秋节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('中秋节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [横屏手机、xxx，pad按照宫格界面展示推荐照片]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_11
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_11(dt: Dt) {

  dt.log.i('横屏手机、xxx，pad按照宫格界面展示推荐照片 start');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('横屏手机、xxx，pad按照宫格界面展示推荐照片 end');

}

/**
 *
 * 智慧图库-: [春节支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_110
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制春节的照片

 */

async function Multimedia_Gallery_Search_110(dt: Dt) {

  dt.log.i('春节支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入春节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示春节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('春节支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [文字搜索结果在搜索框手动输入不可以搜到结果的关键词]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_111
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机中预制人像、地点、时间、节假日、分类的照片

 */

async function Multimedia_Gallery_Search_111(dt: Dt) {

  dt.log.i('文字搜索结果在搜索框手动输入不可以搜到结果的关键词 start');

  dt.log.i('STEP 1、在图库入口界面输入包含地点的文字指令');

  await dt.sleep();

  dt.log.i('预期结果1、有搜索结果，直接展示搜索结果，搜索框下面有推荐的胶囊');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在搜索框手动输入不可以搜索到结果的关键词');

  await dt.sleep();

  dt.log.i('预期结果2、无搜索结果，界面可以正常刷新“无搜索结果”的提示页');

  await dt.sleep(DELAY.double);

  await dt.driver.assertComponentExist(ON.text('无搜索结果'));

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('文字搜索结果在搜索框手动输入不可以搜到结果的关键词 end');

}

/**
 *
 * 智慧图库-: [劳动节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_112
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制劳动节的照片

 */

async function Multimedia_Gallery_Search_112(dt: Dt) {

  dt.log.i('劳动节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入劳动节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示劳动节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('劳动节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [重阳节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_113
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制重阳节的照片

 */

async function Multimedia_Gallery_Search_113(dt: Dt) {

  dt.log.i('重阳节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入重阳节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示重阳节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('重阳节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [情人节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_114
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制情人节的照片

 */

async function Multimedia_Gallery_Search_114(dt: Dt) {

  dt.log.i('情人节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入情人节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示情人节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('情人节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [端午节照片支持文字搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_115
 *
 * 前置条件
 *
 * 1、手机保持充电，电量大于50%
 *
 '2、连接WLAN

 3、手机预制端午节的照片

 */

async function Multimedia_Gallery_Search_115(dt: Dt) {

  dt.log.i('端午节照片支持文字搜索 start');

  dt.log.i('STEP 1、进入搜索页面，手动输入端午节');

  await dt.sleep();

  dt.log.i('预期结果1、搜索结果显示端午节时间范围的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('端午节照片支持文字搜索 end');

}

/**
 *
 * 智慧图库-: [搜索性能测试（索引构建完成）]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_116
 *
 * 前置条件
 *
 * 2000张符合搜索条件（如地点：上海）的照片
 *
 */

async function Multimedia_Gallery_Search_116(dt: Dt) {

  dt.log.i('搜索性能测试（索引构建完成） start');

  dt.log.i('预期结果2000条记录，进入应用后首次搜索平均耗时1.5s，之后每次搜索平均200ms');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索性能测试（索引构建完成） end');

}

/**
 *
 * 智慧图库-: [搜索非同一个文件名里的非连续关键字组合搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_117
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_117(dt: Dt) {

  dt.log.i('搜索非同一个文件名里的非连续关键字组合搜索 start');

  dt.log.i('STEP 1、进入搜索页面，搜索输入照片不同文件名里的多个非连续字符');

  await dt.sleep();

  dt.log.i('预期结果1、无法搜出结果（多关键字显示交集）');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索非同一个文件名里的非连续关键字组合搜索 end');

}

/**
 *
 * 智慧图库-: [搜索地点的其中几个连续字进行搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_118
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_118(dt: Dt) {

  dt.log.i('搜索地点的其中几个连续字进行搜索 start');

  dt.log.i('STEP 1、进入搜索页面，搜索处输鲁木');

  await dt.sleep();

  dt.log.i('预期结果1、对应乌鲁木齐的照片都会被搜索出来');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索地点的其中几个连续字进行搜索 end');

}

/**
 *
 * 智慧图库-: [搜索非同一个备注里的连续关键字组合搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_119
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_119(dt: Dt) {

  dt.log.i('搜索非同一个备注里的连续关键字组合搜索 start');

  dt.log.i('STEP 1、进入搜索页面，搜索输入照片不同备注里的多个连续字符');

  await dt.sleep();

  dt.log.i('预期结果1、无法搜出结果（多关键字显示交集）');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('搜索非同一个备注里的连续关键字组合搜索 end');

}

/**
 *
 * 智慧图库-: [推荐规则]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_12
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_12(dt: Dt) {

  dt.log.i('推荐规则 start');

  dt.log.i('预期结果1、左对齐优先推荐匹配；');

  await dt.sleep(DELAY.short);

  dt.log.i('预期结果2、按照分类顺序，每隔类别最多显示数量最多的前两项（不区分输入的类型）');

  await dt.sleep(DELAY.short);

  dt.log.i('预期结果3、当搜索关键字小于等于5个时，搜索结果直接全部展示，当搜索关键字大于5个时，按照对应的类型，每种类型至多匹配2条。');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('推荐规则 end');

}

/**
 *
 * 智慧图库-: [输入超过85个空格分隔的有效关键字]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_120
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_120(dt: Dt) {

  dt.log.i('输入超过85个空格分隔的有效关键字 start');

  dt.log.i('STEP 1、输入关键词后点击搜索，输入85个关键字，以空格分隔');

  await dt.sleep();

  dt.log.i('预期结果1、可以搜索出备注对应的照片');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('输入超过85个空格分隔的有效关键字 end');

}

/**
 *
 * 智慧图库-: [搜索非同一个相册名里的非连续关键字组合搜索]
 *
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_121
 *
 * 前置条件
 *
 * 无特殊要求
 *
 */

async function Multimedia_Gallery_Search_121(dt: Dt) {
  dt.log.i('搜索非同一个相册名里的非连续关键字组合搜索 start');
  dt.log.i('STEP 1、进入搜索页面，搜索输入照片不同相册名里的多个非连续字符');

  await dt.sleep();
  dt.log.i('预期结果1、无法搜出结果（多关键字显示交集）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索非同一个相册名里的非连续关键字组合搜索 end');
}

/**
 * 智慧图库-: [搜索非同一个备注里的非连续关键字组合搜索]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_123
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_123(dt: Dt) {
  dt.log.i('搜索非同一个备注里的非连续关键字组合搜索 start');
  dt.log.i('STEP 1、进入搜索页面，搜索输入照片不同备注里的多个非连续字符');

  await dt.sleep();
  dt.log.i('预期结果1、无法搜出结果（多关键字显示交集）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索非同一个备注里的非连续关键字组合搜索 end');
}

/**
 * 智慧图库-视频: [胶囊、联想搜索遍历Pad，Teton设备]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_124
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_124(dt: Dt) {
  dt.log.i('胶囊、联想搜索遍历Pad，Teton设备 start');
  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();
  dt.log.i('STEP 2、输入“2022”');

  await dt.sleep();
  dt.log.i('STEP 3、查看联想搜索标签');

  await dt.sleep();
  dt.log.i('预期结果3、界面无截断等');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('胶囊、联想搜索遍历Pad，Teton设备 end');
}

/**
 * 智慧图库-竖屏: [胶囊、联想搜索遍历横竖屏模式、深色模式、大字体模式]
 * GROUP: 智慧图库 MODULE: 竖屏TID: Multimedia_Gallery_Search_125
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_125(dt: Dt) {
  dt.log.i('胶囊、联想搜索遍历横竖屏模式、深色模式、大字体模式 start');
  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();
  dt.log.i('STEP 2、输入“2022”');

  await dt.sleep();
  dt.log.i('STEP 3、查看联想搜索标签');

  await dt.sleep();
  dt.log.i('预期结果3、界面无截断等');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('胶囊、联想搜索遍历横竖屏模式、深色模式、大字体模式 end');
}

/**
 * 智慧图库-: [隐藏截图后搜索]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_126
 * 前置条件
 * 1、图库中有截图（手机桌面截图）
 2、电量大于50%，充电灭屏分析完成
 */
async function Multimedia_Gallery_Search_126(dt: Dt) {
  dt.log.i('隐藏截图后搜索 start');
  dt.log.i('STEP 1、隐藏该截图');

  await dt.sleep();
  dt.log.i('STEP 2、进入搜索界面搜索“主题”');

  await dt.sleep();
  dt.log.i('预期结果2、搜索不到该截图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从隐藏相册中恢复该截图，进入搜索界面搜索“主题”');

  await dt.sleep();
  dt.log.i('预期结果3、等待索引构建完成,可以搜索到该截图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏截图后搜索 end');
}

/**
 * 智慧图库-删除: [AB登陆同一云账号，B增删改云端照片，A实时搜索界面点击展开查看]
 * GROUP: 智慧图库 MODULE: 删除TID: Multimedia_Gallery_Search_127
 * 前置条件
 * 1.手机电量大于50%，预制280类、100+动作图片和视频
 2.AB登陆同一云账号，打开云同步开关
 */
async function Multimedia_Gallery_Search_127(dt: Dt) {
  dt.log.i('AB登陆同一云账号，B增删改云端照片，A实时搜索界面点击展开查看 start');
  dt.log.i('STEP 1.充电灭屏分析，等待分析完成并索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 2.A进入图库搜索界面输入“1”，B设备删除、增加、修改云端图片，点击展开');

  await dt.sleep();
  dt.log.i('预期结果2、界面显示正常，不会自动收起');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('AB登陆同一云账号，B增删改云端照片，A实时搜索界面点击展开查看 end');
}

/**
 * 智慧图库-视频: [分类完成，索引未构建完成，实时搜索界面点击展开查看]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_128
 * 前置条件
 * 1.手机电量大于50%，预制280类、100+动作图片和视频
 */
async function Multimedia_Gallery_Search_128(dt: Dt) {
  dt.log.i('分类完成，索引未构建完成，实时搜索界面点击展开查看 start');
  dt.log.i('STEP 1.充电灭屏分析，等待分析完成并索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 2.亮屏进入图库搜索界面输入“1”，点击展开');

  await dt.sleep();
  dt.log.i('预期结果2、界面显示正常，不会自动收起');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分类完成，索引未构建完成，实时搜索界面点击展开查看 end');
}

/**
 * 智慧图库-视频: [实时搜索命中1万条数据性能测试]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_129
 * 前置条件
 * 1.手机电量大于50%，预制280类、100+动作图片和视频
 */
async function Multimedia_Gallery_Search_129(dt: Dt) {
  dt.log.i('实时搜索命中1万条数据性能测试 start');
  dt.log.i('STEP 1.充电灭屏分析，等待分析完成并索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 2.亮屏进入图库搜索界面输入“1”，查看性能');

  await dt.sleep();
  dt.log.i('预期结果2、性能不高于1s');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('实时搜索命中1万条数据性能测试 end');
}

/**
 * 智慧图库-: [输入词自动联想]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_13
 * 前置条件
 * 1.充电灭屏，索引构建完成
 */
async function Multimedia_Gallery_Search_13(dt: Dt) {
  dt.log.i('输入词自动联想 start');
  dt.log.i('STEP 1、打开图库；');

  await dt.sleep();
  dt.log.i('预期结果1.搜索内容中包含所有”东方明珠”信息。');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('东方明珠'));
  dt.log.i('STEP 2、右上角搜索框输入关键字如""东方明珠""后，点击搜索；');

  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('输入词自动联想 end');
}

/**
 * 智慧图库-: [搜索结果点击“更多”到“更多”页内容显示完成性能]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_130
 * 前置条件
 * 1、已生成各种索引，时间、人像、地点、分类、OCR
 2、3万数据
 */
async function Multimedia_Gallery_Search_130(dt: Dt) {
  dt.log.i('搜索结果点击“更多”到“更多”页内容显示完成性能 start');
  dt.log.i('STEP 1、点击更多，进入宫格界面');

  await dt.sleep();
  dt.log.i('预期结果1、点击搜索结果“更多”，显示“更多”首屏内容完成时延：低于800ms，低于3s（20万以内数据）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('更多'));

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索结果点击“更多”到“更多”页内容显示完成性能 end');
}

/**
 * 智慧图库-: [英语下搜索省关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_131
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_131(dt: Dt) {
  dt.log.i('英语下搜索省关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输英语省');

  await dt.sleep();
  dt.log.i('预期结果1、对应省的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('英语下搜索省关键字 end');
}

/**
 * 智慧图库-: [英语下搜索国家、省、市、区县组合关键字（无归属关系）]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_132
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_132(dt: Dt) {
  dt.log.i('英语下搜索国家、省、市、区县组合关键字（无归属关系） start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输入USA');

  await dt.sleep();
  dt.log.i('预期结果1、无法搜索出结果（多关键字显示交集，不存在这样的照片）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('英语下搜索国家、省、市、区县组合关键字（无归属关系） end');
}

/**
 * 智慧图库-: [英语下年月日和地点的非连续字符组合搜索]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_133
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_133(dt: Dt) {
  dt.log.i('英语下年月日和地点的非连续字符组合搜索 start');
  dt.log.i('STEP 1、进入搜索页面，搜索英语下年月日和地点的非连续字符组合');

  await dt.sleep();
  dt.log.i('预期结果1、对应时间地点的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('英语下年月日和地点的非连续字符组合搜索 end');
}

/**
 * 智慧图库-: [英语下搜索街道关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_134
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_134(dt: Dt) {
  dt.log.i('英语下搜索街道关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输英语街道');

  await dt.sleep();
  dt.log.i('预期结果1、对应街道的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('英语下搜索街道关键字 end');
}

/**
 * 智慧图库-视频: [照片页、相册页横屏进入搜索]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_135
 * 前置条件
 * 1、时间轴有超过500张照片，50个视频，有地点相册，有精彩时刻，分类和云端照片
 */
async function Multimedia_Gallery_Search_135(dt: Dt) {
  dt.log.i('照片页、相册页横屏进入搜索 start');
  dt.log.i('STEP 1、进入图库时间轴');

  await dt.sleep();
  dt.log.i('STEP 2、分屏缩放');

  await dt.sleep();
  dt.log.i('STEP 3、手机横屏');

  await dt.sleep();
  dt.log.i('STEP 4、点击搜索，输入推荐的标签');

  await dt.sleep();
  dt.log.i('预期结果4.1、图库无crash 4.2、图标、文字等无异常、无遮挡。4.3、图片无显示异常4.4、图库可正常操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页、相册页横屏进入搜索 end');
}

/**
 * 智慧图库-: [搜索中输入文档，推荐标签能推荐出身份证、护照、银行卡、ppt和名片（体验性）]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_136
 * 前置条件
 * 1、手机保持充电，电量大于50%
 '2、连接WLAN
 3、手机中预制能生成标签、时间、人像、地点、事物分类的照片 ,尤其是文档类(包含银行卡、身份证、ppt和名片）
 */
async function Multimedia_Gallery_Search_136(dt: Dt) {
  dt.log.i('搜索中输入文档，推荐标签能推荐出身份证、护照、银行卡、ppt和名片（体验性） start');
  dt.log.i('STEP 1、打开图库应用，点击右上角搜索并输入框手动输入：“文档”');

  await dt.sleep();
  dt.log.i('预期结果1、搜索结果页面上，搜索输入框下方的标签维度推荐包含身份证、护照、银行卡、ppt和名片。');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索中输入文档，推荐标签能推荐出身份证、护照、银行卡、ppt和名片（体验性） end');
}

/**
 * 智慧图库-竖屏: [搜索建议界面人像、地点分类横竖屏分别显示的相册数量]
 * GROUP: 智慧图库 MODULE: 竖屏TID: Multimedia_Gallery_Search_137
 * 前置条件
 * 1、图库中人像、地点分类中分别有超过7个的分类结果
 */
async function Multimedia_Gallery_Search_137(dt: Dt) {
  dt.log.i('搜索建议界面人像、地点分类横竖屏分别显示的相册数量 start');
  dt.log.i('STEP 1、手机竖屏进入图库');

  await dt.sleep();
  dt.log.i('STEP 2、点击搜索进入搜索建议界面 ');

  await dt.sleep();
  dt.log.i('预期结果2.1、显示的人像分类结果最多显示12个相册2.2、显示的事物和地点分类结果最多显示12个相册2.3、显示的时间分类最多6个');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、手机横屏');

  await dt.sleep();
  dt.log.i('预期结果3.1、显示的人像分类结果最多显示12个相册3.2、显示的事物和地点分类结果最多显示12个相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索建议界面人像、地点分类横竖屏分别显示的相册数量 end');
}

/**
 * 智慧图库-: [搜索中来电，挂断后不会影响搜索结果]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_138
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_138(dt: Dt) {
  dt.log.i('搜索中来电，挂断后不会影响搜索结果 start');
  dt.log.i('STEP 1、输入关键词后点击搜索，同时拨打电话给该手机');

  await dt.sleep();
  dt.log.i('预期结果1、搜索结果仍然正确，不会受影响');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索中来电，挂断后不会影响搜索结果 end');
}

/**
 * 智慧图库-视频: [设备克隆之后使用联想搜索和胶囊搜索]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_139
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_139(dt: Dt) {
  dt.log.i('设备克隆之后使用联想搜索和胶囊搜索 start');
  dt.log.i('STEP 1、克隆设备');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库搜索输入“2022”');

  await dt.sleep();
  dt.log.i('STEP 3、查看搜索标签');

  await dt.sleep();
  dt.log.i('预期结果3、联想搜索最多显示5个标签，胶囊搜索标签按照照片数量排序');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设备克隆之后使用联想搜索和胶囊搜索 end');
}

/**
 * 智慧图库-视频: [图库有图片和视频时，查看搜索建议界面]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_14
 * 前置条件
 * 1、图库中有照片和视频，且有分类，地点，人像
 */
async function Multimedia_Gallery_Search_14(dt: Dt) {
  dt.log.i('图库有图片和视频时，查看搜索建议界面 start');
  dt.log.i('STEP 1、进入图库');

  await dt.sleep();
  dt.log.i('STEP 2、点击搜索进入搜索建议界面');

  await dt.sleep();
  dt.log.i('预期结果2、有对应的标签和人像、地点、事物分类');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库有图片和视频时，查看搜索建议界面 end');
}

/**
 * 智慧图库-: [后置摄像头拍的人像不支持“自拍“搜索]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_140
 * 前置条件
 * 1.准备后置摄像头自拍人像拍照（10.1及之后的版本）
 */
async function Multimedia_Gallery_Search_140(dt: Dt) {
  dt.log.i('后置摄像头拍的人像不支持“自拍“搜索 start');
  dt.log.i('STEP 1.充电灭屏2分钟');

  await dt.sleep();
  dt.log.i('预期结果1.在搜索框中搜索“自拍”，搜不到照片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('自拍'));

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('后置摄像头拍的人像不支持“自拍“搜索 end');
}

/**
 * 智慧图库-: [实时更新推荐8张展示照片支持全部展开，为向下展开，不跳转新画面，保留上方搜索功能。]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_15
 * 前置条件
 * 图片备注中有“涵”或名称中包含“涵”
 */
async function Multimedia_Gallery_Search_15(dt: Dt) {
  dt.log.i('实时更新推荐8张展示照片支持全部展开，为向下展开，不跳转新画面，保留上方搜索功能。 start');
  dt.log.i('STEP 1.打开图库；2、右上角搜索框输入关键字：“涵”，点击搜索；');

  await dt.sleep();
  dt.log.i('预期结果1.下方实时展示8张照片，点击更多可以显示所有。');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.提示的文件描述和照片数保持一致');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('实时更新推荐8张展示照片支持全部展开，为向下展开，不跳转新画面，保留上方搜索功能。 end');
}

/**
 * 智慧图库-视频: [联想搜索界面显示]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_16
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_16(dt: Dt) {
  dt.log.i('联想搜索界面显示 start');
  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();
  dt.log.i('STEP 2、输入“2022”');

  await dt.sleep();
  dt.log.i('STEP 3、查看联想搜索标签');

  await dt.sleep();
  dt.log.i('预期结果3、标签下面无“更多”选项');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('更多', true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('联想搜索界面显示 end');
}

/**
 * 智慧图库-视频: [胶囊搜索]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_17
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_17(dt: Dt) {
  dt.log.i('胶囊搜索 start');
  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();
  dt.log.i('STEP 2、输入“2022”，点击确认');

  await dt.sleep();
  dt.log.i('STEP 3、查看标签顺序');

  await dt.sleep();
  dt.log.i('预期结果3、标签的顺序按照照片数量的顺序排列');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('胶囊搜索 end');
}

/**
 * 智慧图库-收藏: [搜索结果一级界面照片收藏、删除查看]
 * GROUP: 智慧图库 MODULE: 收藏TID: Multimedia_Gallery_Search_18
 * 前置条件
 * 1.手机电量大于50%，预制280类、100+动作图片和视频
 */
async function Multimedia_Gallery_Search_18(dt: Dt) {
  dt.log.i('搜索结果一级界面照片收藏、删除查看 start');
  dt.log.i('STEP 1.充电灭屏分析，等待分析完成并索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 2.亮屏进入图库搜索界面输入“风景”，点击大图收藏或删除，返回搜索界面');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示收藏图标、删除照片被刷新掉');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索结果一级界面照片收藏、删除查看 end');
}

/**
 * 智慧图库-: [搜索结果检查]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_19
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_19(dt: Dt) {
  dt.log.i('搜索结果检查 start');
  dt.log.i('STEP 1、输入关键词后点击搜索查看搜索结果');

  await dt.sleep();
  dt.log.i('预期结果1、搜索结果按照宫格显示，搜索结果按照和搜索内容的关联程度依次从高到低排序。');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索结果检查 end');
}

/**
 * 智慧图库-拖拽: [本地图片搜索结果一级界面top8缩略图支持长按拖拽]
 * GROUP: 智慧图库 MODULE: 拖拽TID: Multimedia_Gallery_Search_2
 * 前置条件
 * 1、图库有本地素材，cv分析已完成，索引已构建
 */
async function Multimedia_Gallery_Search_2(dt: Dt) {
  dt.log.i('本地图片搜索结果一级界面top8缩略图支持长按拖拽 start');
  dt.log.i('STEP 1、输入搜索内容后出现搜索结果内容');

  await dt.sleep();
  dt.log.i('STEP 2、长按缩略图触发拖拽');

  await dt.sleep();
  dt.log.i('预期结果2、图片、视频支持拖拽，同时不支持长按进入选择模式，不支持多选拖拽');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击缩略图进入大图，长按图片触发拖拽');

  await dt.sleep();
  dt.log.i('预期结果3、图片、视频支持拖拽');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地图片搜索结果一级界面top8缩略图支持长按拖拽 end');
}

/**
 * 智慧图库-视频: [联想搜索显示]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_20
 * 前置条件
 * 图库中图片和视频
 */
async function Multimedia_Gallery_Search_20(dt: Dt) {
  dt.log.i('联想搜索显示 start');
  dt.log.i('STEP 1、点击搜索');

  await dt.sleep();
  dt.log.i('STEP 2、输入“2022”');

  await dt.sleep();
  dt.log.i('STEP 3、查看联想搜索标签');

  await dt.sleep();
  dt.log.i('预期结果3、最多显示5个标签');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('联想搜索显示 end');
}

/**
 * 智慧图库-视频: [搜索同一个备注里的连续关键字搜索（包括视频和图片备注）]
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_Search_21
 * 前置条件
 * 导入照片备注里的连续字符“西游”的照片
 电量大于50%，充电灭屏2分钟
 */
async function Multimedia_Gallery_Search_21(dt: Dt) {
  dt.log.i('搜索同一个备注里的连续关键字搜索（包括视频和图片备注） start');
  dt.log.i('STEP 1、进入搜索页面，搜索输入照片备注里的连续字符“西游” image\\Gallery\\beizhu1.jpg');

  await dt.sleep();
  dt.log.i('预期结果1、对应备注的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索同一个备注里的连续关键字搜索（包括视频和图片备注） end');
}

/**
 * 智慧图库-下载: [相册名搜索]
 * GROUP: 智慧图库 MODULE: 下载TID: Multimedia_Gallery_Search_22
 * 前置条件
 * 1、手机保持充电，电量大于10%
 2、手机切换为中文
 */
async function Multimedia_Gallery_Search_22(dt: Dt) {
  dt.log.i('相册名搜索 start');
  dt.log.i('STEP 1、进入指定的应用，下载图片 （如微信）（也可以导入照片到应用路径）     Multimedia\\image\\Gallery\\Screenshot_20180717_094916"", ""Pictures/WeiXin/""                                                                                      ');

  await dt.sleep();
  dt.log.i('STEP 2、充电灭屏2分钟，等待索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 3、进入图库搜索界面，输入应用的中文名称“”微信“”');

  await dt.sleep();
  dt.log.i('预期结果3、可以搜索出该应用的名称（如微信）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册名搜索 end');
}

/**
 * 智慧图库-大图: [支持节假日别称的搜索]
 * GROUP: 智慧图库 MODULE: 大图TID: Multimedia_Gallery_Search_24
 * 前置条件
 * 1、已生成各种索引，时间、人像、地点、分类、OCR
 */
async function Multimedia_Gallery_Search_24(dt: Dt) {
  dt.log.i('支持节假日别称的搜索 start');
  dt.log.i('STEP 1、搜索框中分别输入“五一”、“六一”，“十一”');

  await dt.sleep();
  dt.log.i('STEP 2、进入更多页面，浏览大图');

  await dt.sleep();
  dt.log.i('预期结果2、图片时间分别对应国庆节、儿童节、国庆节');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持节假日别称的搜索 end');
}

/**
 * 智慧图库-: [支持季节的搜索]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_25
 * 前置条件
 * 1、已生成各种索引，时间、人像、地点、分类、OCR
 */
async function Multimedia_Gallery_Search_25(dt: Dt) {
  dt.log.i('支持季节的搜索 start');
  dt.log.i('STEP 1、分别输入春、夏、秋、冬进行搜索');

  await dt.sleep();
  dt.log.i('STEP 2、查看被搜到的图片的时间');

  await dt.sleep();
  dt.log.i('预期结果2、图片时间返回正确，按照搜索词分别为：春（3-5月份），夏（6-8月份），秋（9-11月份），冬（12-2月份）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持季节的搜索 end');
}

/**
 * 智慧图库-: [搜索人像名关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_26
 * 前置条件
 * 1、已生成各种索引，时间、人像、地点、分类、OCR
 */
async function Multimedia_Gallery_Search_26(dt: Dt) {
  dt.log.i('搜索人像名关键字 start');
  dt.log.i('STEP 1、人像相册命名');

  await dt.sleep();
  dt.log.i('STEP 2、充电灭屏');

  await dt.sleep();
  dt.log.i('STEP 3、搜索框输入已命名人像');

  await dt.sleep();
  dt.log.i('预期结果3、搜索首页有人像标签和top8推荐，搜索到的结果与发现页人像相册匹配');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索人像名关键字 end');
}

/**
 * 智慧图库-: [搜索地点单个关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_27
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_27(dt: Dt) {
  dt.log.i('搜索地点单个关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输入英语');

  await dt.sleep();
  dt.log.i('预期结果1、可以实现当前语言和英语的搜索');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看搜索页面的搜索规则');

  await dt.sleep();
  dt.log.i('预期结果2、分词的规则是国家、省、市、区、街道/路（以输入的字符进行模糊匹配，第一个字符就开始搜索，关键字需要连续匹配，浦东新区的关键字字可以为“浦东”“东新”“新区”）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('浦东'));

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索地点单个关键字 end');
}

/**
 * 智慧图库-: [搜索市关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_28
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_28(dt: Dt) {
  dt.log.i('搜索市关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输入市');

  await dt.sleep();
  dt.log.i('预期结果1、对应市的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索市关键字 end');
}

/**
 * 智慧图库-: [搜索国家关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_29
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_29(dt: Dt) {
  dt.log.i('搜索国家关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输国家');

  await dt.sleep();
  dt.log.i('预期结果1、对应国家的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索国家关键字 end');
}

/**
 * 智慧图库-: [按照地点分类搜索在上海拍的照片]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_3
 * 前置条件
 * 1、预制照片
 '2、连接WLAN
 3、准备包含上海的照片资源
 */
async function Multimedia_Gallery_Search_3(dt: Dt) {
  dt.log.i('按照地点分类搜索在上海拍的照片 start');
  dt.log.i('STEP 1、将预制图片push到测试手机Camera路径');

  await dt.sleep();
  dt.log.i('STEP 2、打开图库网络连接开关 ');

  await dt.sleep();
  dt.log.i('STEP 3、充电灭屏，等待分类完成 ，确认图库中可以搜索到上海                                                                                                   ');

  await dt.sleep();
  dt.log.i('STEP 4.  利用语音助手搜索“在上海拍摄的照片“”');

  await dt.sleep();
  dt.log.i('预期结果4.有搜索图片结果，直接展示搜索结果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('按照地点分类搜索在上海拍的照片 end');
}

/**
 * 智慧图库-: [搜索区县关键字]
 * GROUP: 智慧图库 MODULE: TID: Multimedia_Gallery_Search_30
 * 前置条件
 * 无特殊要求
 */
async function Multimedia_Gallery_Search_30(dt: Dt) {
  dt.log.i('搜索区县关键字 start');
  dt.log.i('STEP 1、进入搜索页面，搜索处输入区县');

  await dt.sleep();
  dt.log.i('预期结果1、对应区县的照片会被搜索出来');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索区县关键字 end');
}