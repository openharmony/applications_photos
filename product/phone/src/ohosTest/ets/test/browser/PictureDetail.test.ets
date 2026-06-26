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
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { ON } from '@ohos.UiTest';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { DisplayRotation, UIElementInfo, UIEventObserver } from '@kit.TestKit';

export default function PictureDetailTest(): void {
  describe('PictureDetailTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.

    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPictureDetailTest').init();
      dt.log.i('beforeAll PictureDetail start');
      dt.log.i('beforeAll PictureDetail finish');
    });
    it('beforePictureDetailTest', Level.LEVEL0, async (dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('ani_GalleryPhotoEffect_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [大图上滑查看详情动效] TID ani_GalleryPhotoEffect_001
      await ani_GalleryPhotoEffect_001(dt);
    });
    it('Multimedia_Gallery_HDRpicture_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [查看HDR格式图片详情显示] TID Multimedia_Gallery_HDRpicture_005
      await Multimedia_Gallery_HDRpicture_005(dt);
    });
    it('Multimedia_Gallery_PhotosBrowser_279', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [相机新拍一张图片，查看拍摄时间和显示时间一致性] TID Multimedia_Gallery_PhotosBrowser_279
      await Multimedia_Gallery_PhotosBrowser_279(dt);
    });
    it('Multimedia_Gallery_Video_menu_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页备注信息] TID Multimedia_Gallery_Video_menu_001
      await Multimedia_Gallery_Video_menu_001(dt);
    });
    it('Multimedia_Gallery_Video_menu_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [图片详情页信息显示] TID Multimedia_Gallery_Video_menu_002
      await Multimedia_Gallery_Video_menu_002(dt);
    });
    it('Multimedia_Gallery_Video_menu_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [视频详情页信息显示] TID Multimedia_Gallery_Video_menu_003
      await Multimedia_Gallery_Video_menu_003(dt);
    });
    it('Multimedia_Gallery_Video_menu_199', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [相机专业模式拍摄的图片详情页信息显示] TID Multimedia_Gallery_Video_menu_199
      await Multimedia_Gallery_Video_menu_199(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_333', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，备注信息检查] TID Multimedia_Gallery_PhotoOperations_333
      await Multimedia_Gallery_PhotoOperations_333(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach browser test').init();
      // 执行单个用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach browser test');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach browser test finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPictureDetailTest').init();
      dt.log.i('afterAll PictureDetailTest finish');
    });
  })

  describe('RemarkInfo', (): void => {
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => await AppStart.photos());
    it('beforeRemarkInfo', Level.LEVEL0, async (dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_PhotoOperations_335', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，修改备注信息] TID Multimedia_Gallery_PhotoOperations_335
      await Multimedia_Gallery_PhotoOperations_335(dt);

    })
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach RemarkInfo test').init();
      // 执行单个用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach RemarkInfo test');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach browser test finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllRemarkInfoTest').init();
      await Exit.browser();
      dt.log.i('afterAll RemarkInfo finish');
    });
  });

  describe('RemarkInfoRotated', (): void => {
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => await AppStart.photos());
    it('beforeRemarkRotated', Level.LEVEL0, async (dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('PhotoOperations_335Rotated', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，修改备注信息] TID Multimedia_Gallery_PhotoOperations_335
      // 4.手机横屏，重复1、2、3步
      await PhotoOperations_335Rotated(dt);
    }, {
      rotate: true,
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach browser test').init();
      // 执行单个用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach browser test');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach browser test finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPictureDetailTest').init();
      await Exit.browser();
      dt.log.i('afterAll PictureDetailTest finish');
    });
  })

  describe('DetailInspect', (): void => {
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => await AppStart.photos());
    it('beforeRemarkRotated', Level.LEVEL0, async (dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_PhotoOperations_337', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，已备注图片操作检查] TID Multimedia_Gallery_PhotoOperations_337
      await Multimedia_Gallery_PhotoOperations_337(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_339', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，文件保存来源检查] TID Multimedia_Gallery_PhotoOperations_339
      await Multimedia_Gallery_PhotoOperations_339(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_345', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，分辨率检查] TID Multimedia_Gallery_PhotoOperations_345
      await Multimedia_Gallery_PhotoOperations_345(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_347', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，文件大小检查] TID Multimedia_Gallery_PhotoOperations_347
      await Multimedia_Gallery_PhotoOperations_347(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_349', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [详情页，照片拍摄信息检查] TID Multimedia_Gallery_PhotoOperations_349
      await Multimedia_Gallery_PhotoOperations_349(dt);
    });
    it('Multimedia_Gallery_Application_Download_button_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [查看大图详情右上角增加下载按钮] TID Multimedia_Gallery_Application_Download button_001
      await Multimedia_Gallery_Application_Download_button_001(dt);
    });
    it('Multimedia_Gallery_AICloudEnhancementService_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [增强后120分图详情检查] TID Multimedia_Gallery_AICloudEnhancementService_006
      await Multimedia_Gallery_AICloudEnhancementService_006(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPictureDetailTest').init();
      // 执行单个用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach PictureDetailTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach PictureDetailTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPictureDetailTest').init();
      await Exit.browser();
      dt.log.i('afterAll PictureDetailTest finish');
    });
  });
}

/**
 * 大图-详情用例: [查看HDR格式图片详情显示]
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_005(dt: Dt) {
  dt.log.i('查看HDR格式图片详情显示 start');
  // 测试步骤
  // 1、进大图查看HDR图片
  await dt.driver.delayMs(DELAY.short);
  await dt.assertClick('More_Image_More');
  dt.log.i('buttonMore clicked');
  await dt.driver.delayMs(DELAY.short);
  await dt.assertClick('ActionBarButton_Text_Info');
  dt.log.i('buttonInfo clicked');
  await dt.sleep(DELAY.short);
  // 2、图片显示过程中上划查看详情

  if (await dt.driver.findComponent(ON.id('content'))) {
    await dt.driver.pressBack();
  }
  // 3、查看图片显示情况
  await Multimedia_Gallery_HDRpicture_005Expects(dt);
  dt.log.i('查看HDR格式图片详情显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_HDRpicture_005Expects(dt: Dt): Promise<void> {
  // 1、图片亮部有逐渐的提亮效果，过程动效正常无跳变
  // 2、详情部分正常显示没有高亮效果

}

/**
 * 大图-详情用例: [相机新拍一张图片，查看拍摄时间和显示时间一致性]
 * 前置条件
 * 1、图库至少存在1W张图片以上 ，天分组至少50个以上；图库 存在纯云端数据5K以上，天分组超过50个
 */
async function Multimedia_Gallery_PhotosBrowser_279(dt: Dt) {
  dt.log.i('相机新拍一张图片，查看拍摄时间和显示时间一致性 start');
  // 测试步骤
  // 1.进入相机，拍摄照片、视频和连拍等图片和视频，进入图库后打开大图浏览
  await dt.sleep(DELAY.short);
  // 2、查看大图左上角的显示时间 ，上滑查看详情卡片的时间，以及图片的名称
  await Multimedia_Gallery_PhotosBrowser_279Expects(dt);
  dt.log.i('相机新拍一张图片，查看拍摄时间和显示时间一致性 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotosBrowser_279Expects(dt: Dt): Promise<void> {
  // 1 、大图的左上角时间和详情卡片上时间显示一致，且时间和图片名称中的时间一致

}

/**
 * 大图-详情用例: [大图上滑查看详情动效]
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function ani_GalleryPhotoEffect_001(dt: Dt) {
  dt.log.i('大图上滑查看详情动效 start');
  // 测试步骤
  // 1、点击宫格缩略图进入大图
  await dt.sleep(DELAY.short);
  // 2、上滑图片
  await ani_GalleryPhotoEffect_001Expects(dt);
  dt.log.i('大图上滑查看详情动效 end');
}

/**
 * 预期结果
 */
async function ani_GalleryPhotoEffect_001Expects(dt: Dt): Promise<void> {
  // 2.1 上滑显示详情有动效，动效效果流畅并符合UX设计

}

/**
 * 大图-详情用例: [详情页备注信息]
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_Video_menu_001(dt: Dt) {
  dt.log.i('详情页备注信息 start');
  // 测试步骤
  // 1、进入图片大图，打开详情页
  await dt.sleep(DELAY.short);
  // 2、在没有备注的时候，观察备注的情况
  await dt.sleep(DELAY.short);
  // 3、在正在输入备注的时候，观察备注的情况
  await dt.sleep(DELAY.short);
  // 4、在输入备注以后，观察备注的情况
  await dt.sleep(DELAY.short);
  // 5、横屏模式下查看
  await dt.sleep(DELAY.short);
  // 6、深色模式下查看
  await Multimedia_Gallery_Video_menu_001Expects(dt);
  dt.log.i('详情页备注信息 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Video_menu_001Expects(dt: Dt): Promise<void> {
  // 2、显示”添加备注“字样
  // 3、显示单行文本，保留底板效果
  // 4、备注信息单行显示，最多支持140个字符，输入超出时会提示“已达到长度上限”
  // 5、横屏模式下备注正常显示
  // 6、深色模式下备注正常显示

}

/**
 * 大图-详情用例: [图片详情页信息显示]
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 2、用相机拍摄一张图片
 */
async function Multimedia_Gallery_Video_menu_002(dt: Dt) {
  dt.log.i('图片详情页信息显示 start');
  // 测试步骤
  // 1、进入图片大图，打开详情页
  await dt.sleep(DELAY.short);
  // 2、观察详情最上方显示信息
  await dt.sleep(DELAY.short);
  // 3、观察横线下方，直方图上方显示信息
  await dt.sleep(DELAY.short);
  // 4、观察直方图下方显示信息
  await dt.sleep(DELAY.short);
  // 5、观察详情最下方显示信息
  await dt.sleep(DELAY.short);
  // 6、横屏模式下查看
  await dt.sleep(DELAY.short);
  // 7、深色模式下查看
  await Multimedia_Gallery_Video_menu_002Expects(dt);
  dt.log.i('图片详情页信息显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Video_menu_002Expects(dt: Dt): Promise<void> {
  // 2、显示图片名称、云符号、图片拍摄时间、一条横线
  // 3、靠左侧显示图片分辨率（a×b）、大小（a.bMB）、图片拍摄模式（人像等），靠右侧显示拍摄设备（xxx拍摄图片暂不支持）、图片格式（JPEG等）
  // 4、等距显示ISO（例如ISO 200）、曝光时间（例如1/50 s）、曝光补偿（例如0 ev）、光圈（例如F1.8）,之间用|分割开
  // 5、靠左侧显示图片焦距，靠右侧显示对焦方式、白平衡、测光方式、闪光灯
  // 6、横屏模式下查看正常显示
  // 7、深色模式下查看正常显示

}

/**
 * 大图-详情用例: [视频详情页信息显示]
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 2、相机打开HDR Vivid录制模式，拍摄一个视频
 */
async function Multimedia_Gallery_Video_menu_003(dt: Dt) {
  dt.log.i('视频详情页信息显示 start');
  // 测试步骤
  // 1、打开刚刚录制的视频大图，进入详情页
  await dt.sleep(DELAY.short);
  // 2、观察详情最上方显示信息
  await dt.sleep(DELAY.short);
  // 3、观察横线下方，直方图上方显示信息
  await dt.sleep(DELAY.short);
  // 4、观察直方图下方信息
  await dt.sleep(DELAY.short);
  // 5、横屏模式下查看
  await dt.sleep(DELAY.short);
  // 6、深色模式下查看
  await Multimedia_Gallery_Video_menu_003Expects(dt);
  dt.log.i('视频详情页信息显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Video_menu_003Expects(dt: Dt): Promise<void> {
  // 2、显示图片名称、云符号、视频拍摄时间、一条横线
  // 3、靠左侧显示图片分辨率（a×b）、大小（a.bMB），靠右侧显示拍摄设备（xxx拍摄图片暂不支持）、视频格式（MP4等）
  // 4、靠左侧显示视频时长（时长：01:20），靠右侧显示HDR Vivid图标
  // 5、横屏模式下查看正常显示
  // 6、深色模式下查看正常显示

}

/**
 * 大图-详情用例: [相机专业模式拍摄的图片详情页信息显示]
 * 前置条件
 * 1、相机专业模式，参数选择RAW，拍摄图片
 */
async function Multimedia_Gallery_Video_menu_199(dt: Dt) {
  dt.log.i('相机专业模式拍摄的图片详情页信息显示 start');
  // 测试步骤
  // 1、相机进入大图查看dng格式图片的详情卡片
  await dt.sleep(DELAY.short);
  // 2、按照 普通jpg格式图片的详情要求来检查dbg格式图片的详情
  await Multimedia_Gallery_Video_menu_199Expects(dt);
  dt.log.i('相机专业模式拍摄的图片详情页信息显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Video_menu_199Expects(dt: Dt): Promise<void> {
  // 2、显示图片名称、云符号、图片拍摄时间、一条横线
  // 2、靠左侧显示图片分辨率（a×b）、大小（a.bMB）、图片拍摄模式（人像等），靠右侧显示拍摄设备、图片格式（DNG）
  // 2、不显示【等距显示ISO（例如ISO 200）、曝光时间（例如1/50 s）、曝光补偿（例如0 ev）、光圈（例如F1.8）,之间用|分割开】
  // 2、不显示【靠左侧显示图片焦距，靠右侧显示对焦方式、白平衡、测光方式、闪光灯】

}

/**
 * 大图-详情用例: [详情页，备注信息检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_333(dt: Dt) {
  dt.log.i('详情页，备注信息检查 start');
  // 测试步骤
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  // 2.手机横屏，重复步骤1
  await Multimedia_Gallery_PhotoOperations_333Expects(dt);
  dt.log.i('详情页，备注信息检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_333Expects(dt: Dt): Promise<void> {
  // 1.显示大图详情，详情界面显示备注信息
  // 1.1备注为空，备注框显示添加备注字样
  // 1.2备注不为空，备注框显示已有备注
  // 1.3备注框显示最多可输入140个字符
  // 2.横屏状态下，详细信息从右边呼出
  // (PC不用横屏）

}

/**
 * 大图-详情用例: [详情页，修改备注信息]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_335(dt: Dt) {
  dt.log.i('详情页，修改备注信息 start');
  // 测试步骤
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  await dt.driver.delayMs(DELAY.short);
  await dt.assertClick('More_Image_More', true, DELAY.short);
  dt.log.i('More_Image_More clicked');

  await dt.clickIfExistByText('详细信息', DELAY.short);
  dt.log.i('详细信息 clicked');

  // 2.点击添加备注
  await dt.assertComponent('TextInput');
  let input = await dt.assertComponent('TextInput');
  await input.click();
  await dt.driver.delayMs(DELAY.short);
  // 第一次拉起键盘，点击下一步
  await dt.clickIfExistByText('下一步', DELAY.short);
  await input.click();
  await dt.driver.delayMs(DELAY.short);
  // 注册toast监听
  let observer: UIEventObserver = await dt.driver.createUIEventObserver();
  let callback = (UIElementInfo: UIElementInfo) => {
    dt.log.i(`检测到toast 已达到长度上限 ${JSON.stringify(UIElementInfo)}`);
    try {
      expect(UIElementInfo.text).assertEqual('已达到长度上限');
      expect(UIElementInfo.type).assertEqual('Toast');
    } catch (error) {
      dt.log.e(`assertEqual error: ${error?.message}, code: ${error?.code}`);
    }
    dt.log.w('检测到toast 已达到长度上限');
  }
  observer.once('toastShow', callback);

  let input_text = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%^&abcdefghijklmnopqrstuvwxyz" +
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRST"
  await input.inputText(input_text);
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText(input_text);
  dt.log.i('成功输入140个字符');

  let input_text1 = input_text + '1';
  await input.inputText(input_text1);
  await dt.sleep(DELAY.double);
  // 断言该组件不存在:
  await dt.negateComponentByText(input_text1);
  dt.log.i('无法输入141个字符');

  await input.inputText('这是备注1');
  await dt.sleep(DELAY.short);
  await dt.assertComponentByText('这是备注1');

  // 3.收起键盘
  await dt.sleep(DELAY.short);
  await dt.getScreen().bottom();
  await dt.sleep(DELAY.short);
  dt.log.i('收起详情信息');

  await dt.clickIfExist('More_Image_More', DELAY.short);
  await dt.clickIfExistByText('详细信息', DELAY.short);
  await dt.assertComponentByText('这是备注1');
  dt.log.i('检测备注保存成功');
  dt.log.i('详情页，修改备注信息 end');
}

/**
 * 预期结果
 */
async function PhotoOperations_335Rotated(dt: Dt): Promise<void> {
  // 测试步骤
  // 设为横屏
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  await dt.driver.delayMs(DELAY.short);
  await dt.getScreen().top();
  dt.log.i('详细信息 clicked');
  let input = await dt.assertComponent('TextInput');
  await input.click();
  await dt.driver.delayMs(DELAY.short);
  await input.inputText("这是备注2");
  if (await dt.driver.findComponent(ON.id('parentLayout'))) {
    await dt.driver.triggerKey(2); // KEYCODE_BACK
    await dt.driver.delayMs(DELAY.short);
    dt.log.i('收起键盘');
  }

  // 2.弹出输入键盘，可正常添加备注，最多支持140个字符 （包括特殊字符）
  await dt.assertComponent('TextInput');
  await dt.driver.delayMs(DELAY.short);
  await input.click();
  let input_text = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%^&abcdefghijklmnopqrstuvwxyz" +
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRST"
  await input.inputText(input_text);
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(input_text));
  dt.log.i('横屏后成功输入140个字符');

  let input_text1 = input_text + "1";
  await input.inputText(input_text1);
  await dt.sleep(DELAY.double);
  await dt.negateComponentByText(input_text1);
  dt.log.i('无法输入141个字符');

  await input.inputText("这是备注2");
  await dt.sleep(DELAY.short);
  await dt.driver.assertComponentExist(ON.text("这是备注2"));

  // 3.收起键盘
  if (await dt.driver.findComponent(ON.id('parentLayout'))) {
    await dt.driver.triggerKey(2); // KEYCODE_BACK
    await dt.driver.delayMs(DELAY.short);
    dt.log.i('收起键盘');
  }

  await dt.driver.triggerKey(2); // KEYCODE_BACK
  await dt.driver.delayMs(DELAY.short);
  // 4.检查是否保存成功
  await dt.getScreen().top();
  await dt.assertComponentByText('这是备注2');
  await dt.driver.delayMs(DELAY.default);
  dt.log.i('详情页 横屏后修改备注信息 end');
}

/**
 * 大图-详情用例: [详情页，已备注图片操作检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 2.图片已备注
 */
async function Multimedia_Gallery_PhotoOperations_337(dt: Dt) {
  dt.log.i('详情页，已备注图片操作检查 start');
  // 测试步骤
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  // 2.点击备注，删除后再恢复，收起键盘
  await dt.sleep(DELAY.short);
  // 3.分享图片
  await dt.sleep(DELAY.short);
  // 4.添加图片到其他相册
  await dt.sleep(DELAY.short);
  // 5.手机横屏，重复1、2、3步
  await Multimedia_Gallery_PhotoOperations_337Expects(dt);
  dt.log.i('详情页，已备注图片操作检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_337Expects(dt: Dt): Promise<void> {
  // 1.显示大图详情，详情界面显示备注信息
  // 2.备注修改后不变
  // 3.收到图片后，备注信息不变
  // 4.添加后图片的备注不变
  // 5.横屏状态下，详细信息从右边呼出
  // （PC不用横屏）

}

/**
 * 大图-详情用例: [详情页，文件保存来源检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_339(dt: Dt) {
  dt.log.i('详情页，文件保存来源检查 start');
  // 测试步骤
  // 1.新增截图/录屏/相机拍摄
  await dt.getScreen().left();
  // 2.进入大图，上滑/点击右上角！查看详情
  await dt.sleep(DELAY.short);
  // 3.手机横屏，重复2步
  await Multimedia_Gallery_PhotoOperations_339Expects(dt);
  dt.log.i('详情页，文件保存来源检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_339Expects(dt: Dt): Promise<void> {
  // 2.详情信息显示手机型号·来自截图/屏幕录制/相机
  // （PC不用横屏）

}

/**
 * 大图-详情用例: [详情页，分辨率检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_345(dt: Dt) {
  dt.log.i('详情页，分辨率检查 start');
  // 测试步骤
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  // 2.手机横屏，重复以上步骤
  await dt.sleep(DELAY.short);
  // 
  await Multimedia_Gallery_PhotoOperations_345Expects(dt);
  dt.log.i('详情页，分辨率检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_345Expects(dt: Dt): Promise<void> {
  // 1.详情显示axb样式分辨率大小
  // 2.横屏状态下，详细信息从右边呼出
  // （PC不用横屏）

}

/**
 * 大图-详情用例: [详情页，文件大小检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_347(dt: Dt) {
  dt.log.i('详情页，文件大小检查 start');
  // 测试步骤
  // 1.进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  // 2.手机横屏，重复以上步骤
  await dt.sleep(DELAY.short);
  // 
  await Multimedia_Gallery_PhotoOperations_347Expects(dt);
  dt.log.i('详情页，文件大小检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_347Expects(dt: Dt): Promise<void> {
  // 1.详情显示a.bcMB样式文件大小
  // 2.横屏状态下，详细信息从右边呼出
  // 注：本地仅LCD图时显示原图大小（PC不用横屏）

}

/**
 * 大图-详情用例: [详情页，照片拍摄信息检查]
 * 前置条件
 * 1.图库中有不同格式的图片和视屏
 */
async function Multimedia_Gallery_PhotoOperations_349(dt: Dt) {
  dt.log.i('详情页，照片拍摄信息检查 start');
  // 测试步骤
  // 1.新拍一张照片，闪光灯默认关闭，进入大图，上滑/点击右上角！查看详情
  await dt.getScreen().left();
  // 2.新拍照片，将闪光灯设为自动/开启/常亮模式
  await dt.sleep(DELAY.short);
  // 3.手机横屏，重复以上步骤
  await Multimedia_Gallery_PhotoOperations_349Expects(dt);
  dt.log.i('详情页，照片拍摄信息检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_349Expects(dt: Dt): Promise<void> {
  // 1.详情显示色彩直方图，下方显示ISO、曝光时间、对焦方式、白平衡、曝光补偿、光圈、闪光灯（带有\的闪电标识）、测光方式、焦距
  // 2.详情显示色彩直方图，下方显示ISO、曝光时间、对焦方式、白平衡、曝光补偿、光圈、闪光灯（闪电标识）、测光方式、焦距
  // 3.横屏状态下，详细信息从右边呼出
  // （PC不用横屏）

}

/**
 * 大图-详情用例: [查看大图详情右上角增加下载按钮]
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Download_button_001(dt: Dt) {
  dt.log.i('查看大图详情右上角增加下载按钮 start');
  // 测试步骤
  // 1.点击开始下载原图
  await dt.getScreen().left();
  // 2.查看大图预览显示下载进度
  await Multimedia_Gallery_Application_Download_button_001Expects(dt);
  dt.log.i('查看大图详情右上角增加下载按钮 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Application_Download_button_001Expects(dt: Dt): Promise<void> {
  // 1.下载按钮点击正常
  // 2.大图预览显示下载进度:正在下载..%,
  //    取消叉号tab可手动关闭

}

/**
 * 大图-详情用例: [增强后120分图详情检查]
 * 前置条件
 * 1、手机连接WIFI
 */
async function Multimedia_Gallery_AICloudEnhancementService_006(dt: Dt) {
  dt.log.i('增强后120分图详情检查 start');
  // 测试步骤
  // 1、点击增强后120分进入大图，上滑查看详情
  await Multimedia_Gallery_AICloudEnhancementService_006Expects(dt);
  dt.log.i('增强后120分图详情检查 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_AICloudEnhancementService_006Expects(dt: Dt): Promise<void> {
  // 1、大图显示正常，详情中图片名称后缀带有“_enhanced”,大小后面显示“AI云增强”字样

}
