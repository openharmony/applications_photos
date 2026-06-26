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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { ON } from '@kit.TestKit';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function WallpaperTest(): void {
  describe('WallpaperTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllWallpaperTest').init();
      dt.log.i('beforeAll WallpaperTest start');
      dt.log.i('beforeAll WallpaperTest finish');
    });
    run('beforeWallpaperTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });
    run('Multimedia_Gallery_Wallpapers_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [不同语言模式下设置壁纸] TID: Multimedia_Gallery_Wallpapers_007
      await Multimedia_Gallery_Wallpapers_007(dt);
    });
    run('Multimedia_Gallery_Wallpapers_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [图库大图设置壁纸] TID: Multimedia_Gallery_Wallpapers_001
      await Multimedia_Gallery_Wallpapers_001(dt);
    });
    run('Multimedia_Gallery_Wallpapers_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [不同宫格入口进入壁纸设置页面] TID: Multimedia_Gallery_Wallpapers_003
      await Multimedia_Gallery_Wallpapers_003(dt);
    });
    run('Multimedia_Gallery_Wallpapers_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [相机入口进入壁纸设置页面] TID: Multimedia_Gallery_Wallpapers_002
      await Multimedia_Gallery_Wallpapers_002(dt);
    });
    run('Multimedia_Gallery_Wallpapers_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [不同模式下设置壁纸] TID: Multimedia_Gallery_Wallpapers_006
      await Multimedia_Gallery_Wallpapers_006(dt);
    });
    run('Multimedia_Gallery_Wallpapers_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [各种格式图片进入壁纸设置页面] TID: Multimedia_Gallery_Wallpapers_004
      await Multimedia_Gallery_Wallpapers_004(dt);
    });
    run('Multimedia_Gallery_Wallpapers_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [不同拍摄模式图片进入壁纸设置页面] TID: Multimedia_Gallery_Wallpapers_005
      await Multimedia_Gallery_Wallpapers_005(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachWallpaperTest').init();
      dt.log.i('afterEach WallpaperTest finish');
    });

    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllWallpaperTest').init();
      await Exit.browser();
      dt.log.i('afterAll WallpaperTest finish');
    });
  });
}

/**
 * 大图-壁纸: [不同语言模式下设置壁纸]
 * TAG: 38 TID: Multimedia_Gallery_Wallpapers_007
 * 前置条件
 * 1、图库中存在不同格式的图片文件
 */
async function Multimedia_Gallery_Wallpapers_007(dt: Dt) {
  dt.log.i('不同语言模式下设置壁纸 start');
  dt.log.i('STEP 1、系统设置不同的语言模式（其中维吾尔文页面需镜像显示）');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库点击图片进入大图，点击更多（其他设置语言）按钮');

  await dt.sleep();
  dt.log.i('STEP 3、点击 设置为壁纸（其他设置语言） 选项');

  await dt.sleep();
  dt.log.i('预期结果3、成功拉起壁纸设置页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击取消按钮');

  await dt.sleep();
  dt.log.i('预期结果4、5、返回到大图页面6、图片应用成功后回到大图页面7、壁纸设置成功8、过程中页面语言翻译正确、无截断、显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、侧划返回');

  await dt.sleep();
  dt.log.i('STEP 6、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果6、图片应用成功后回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果7、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果8、过程中页面语言翻译正确、无截断、显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同语言模式下设置壁纸 end');
}

/**
 * 大图-壁纸: [图库大图设置壁纸]
 * TAG: 39 TID: Multimedia_Gallery_Wallpapers_001
 * 前置条件
 * 1、图库中存在云端和本地图片文件
 */
async function Multimedia_Gallery_Wallpapers_001(dt: Dt) {
  dt.log.i('图库大图设置壁纸 start');
  dt.log.i('STEP 1、云端和本地的图片进入大图，点击更多按钮');
  await dt.clickIfExist('More_Image_More', DELAY.short);
  dt.log.i('More_Image_More clicked');
  await dt.sleep();

  dt.log.i('STEP 2、点击 设置为壁纸 选项');
  await dt.clickIfExistByText('设置为壁纸', DELAY.double);
  dt.log.i('设置为壁纸 clicked');
  await dt.sleep();
  dt.log.i('预期结果2、成功拉起壁纸设置页面');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、点击取消按钮');
  await dt.clickIfExist('wallpaper_cancel', DELAY.short);
  await dt.sleep();
  dt.log.i('预期结果3、4、返回到大图页面5、图片应用成功后回到大图页面6、壁纸设置成功');
  await dt.clickIfExist('More_Image_More', DELAY.short);
  dt.log.i('More_Image_More clicked');
  await dt.sleep();
  await dt.clickIfExistByText('设置为壁纸', DELAY.double);
  dt.log.i('设置为壁纸 clicked');
  await dt.sleep();

  dt.log.i('STEP 5、点击应用按钮');
  await dt.clickIfExist('wallpaper_apply', DELAY.default);
  await dt.sleep();
  await dt.clickIfExistByText('确定', DELAY.double);
  await dt.sleep();

  dt.log.i('预期结果5、图片应用成功后回到大图页面');
  dt.driver.assertComponentExist(ON.id('More_Image_More'));
  await dt.sleep(DELAY.double);
  dt.log.i('STEP 6、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果6、壁纸设置成功');

  dt.log.i('STEP 7、恢复默认壁纸');
  await AppStart.settings();
  await dt.sleep();
  await dt.clickIfExist('theme_settings', DELAY.short);
  dt.log.i('打开设置，桌面和个性化');
  await dt.clickIfExist('entry_wallpaper_picker_page', DELAY.short);
  dt.log.i('点击壁纸');

  await dt.clickIfExist('Card_01', DELAY.double);
  dt.log.i('点击默认壁纸');
  await dt.clickIfExist('wallpaper_apply', DELAY.double);
  await dt.clickIfExistByText('确定', DELAY.double);
  await dt.sleep(DELAY.long);
  dt.log.i('预期结果7、应用默认壁纸');
  await AppStart.stop(TestConstants.START_SETTINGS_WANT, 'stop settings');
  dt.log.i('退出设置');
  dt.log.i('图库大图设置壁纸 end');
}

/**
 * 大图-壁纸: [不同宫格入口进入壁纸设置页面]
 * TAG: 40 TID: Multimedia_Gallery_Wallpapers_003
 * 前置条件
 * 1、图库中存在不同格式的图片文件
 */
async function Multimedia_Gallery_Wallpapers_003(dt: Dt) {
  dt.log.i('不同宫格入口进入壁纸设置页面 start');
  dt.log.i('STEP 1、从各种相册宫格（除去隐藏相册和最近删除相册）进入大图，点击更多按钮');

  await dt.sleep();
  dt.log.i('STEP 2、从搜索页面宫格进入大图，点击更多按钮');

  await dt.sleep();
  dt.log.i('STEP 3、点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果3、成功拉起壁纸设置页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击取消按钮');

  await dt.sleep();
  dt.log.i('预期结果4、5、返回到大图页面6、图片应用成功后回到大图页面7、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、侧划返回');

  await dt.sleep();
  dt.log.i('STEP 6、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果6、图片应用成功后回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果7、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同宫格入口进入壁纸设置页面 end');
}

/**
 * 大图-壁纸: [相机入口进入壁纸设置页面]
 * TAG: 41 TID: Multimedia_Gallery_Wallpapers_002
 * 前置条件
 * 1、图库中存在不同格式的图片文件
 */
async function Multimedia_Gallery_Wallpapers_002(dt: Dt) {
  dt.log.i('相机入口进入壁纸设置页面 start');
  dt.log.i('STEP 1、从相机入口进入大图，点击更多按钮');

  await dt.sleep();
  dt.log.i('STEP 2、点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果2、成功拉起壁纸设置页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消按钮');

  await dt.sleep();
  dt.log.i('预期结果3、4、返回到大图页面5、图片应用成功后回到大图页面6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、侧划返回');

  await dt.sleep();
  dt.log.i('STEP 5、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果5、图片应用成功后回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口进入壁纸设置页面 end');
}

async function Multimedia_Gallery_Wallpapers_006(dt: Dt) {
  dt.log.i('不同模式下设置壁纸 start');
  dt.log.i('STEP 1、图库打开悬浮、分屏模式');

  await dt.sleep();
  dt.log.i('预期结果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果2、页面提示 壁纸不支持在小窗下编辑4、壁纸设置页面切换到竖屏显示6、成功拉起壁纸设置页面7、返回到大图页面8、图片应用成功后回到大图页面，切换到横屏显示9、壁纸设置成功10、过程中页面显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、系统开启横竖屏旋转');

  await dt.sleep();
  dt.log.i('STEP 4、横屏状态下在大图点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果4、壁纸设置页面切换到竖屏显示6、成功拉起壁纸设置页面7、返回到大图页面8、图片应用成功后回到大图页面，切换到横屏显示9、壁纸设置成功10、过程中页面显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、系统开启深色模式');

  await dt.sleep();
  dt.log.i('STEP 6、在大图点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果6、成功拉起壁纸设置页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击取消按钮；侧划返回');

  await dt.sleep();
  dt.log.i('预期结果7、返回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果8、图片应用成功后回到大图页面，切换到横屏显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果9、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果10、过程中页面显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同模式下设置壁纸 end');
}

/**
 * 大图-格式: [各种格式图片进入壁纸设置页面]
 * TAG: 43 TID: Multimedia_Gallery_Wallpapers_004
 * 前置条件
 * 1、图库中存在不同格式的图片文件，例如
 jpg、 dng、 heif、 png、 jpeg、 wbmp、 nef、 arw、 gif、 cr2、 webp、 bmp、 nrw、 rw2、 orf、 raf、 pef、 srw
 */
async function Multimedia_Gallery_Wallpapers_004(dt: Dt) {
  dt.log.i('各种格式图片进入壁纸设置页面 start');
  dt.log.i('STEP 1、各种格式图片进入大图，点击更多按钮');

  await dt.sleep();
  dt.log.i('STEP 2、点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果2、成功拉起壁纸设置页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消按钮');

  await dt.sleep();
  dt.log.i('预期结果3、4、返回到大图页面5、图片应用成功后回到大图页面6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、侧划返回');

  await dt.sleep();
  dt.log.i('STEP 5、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果5、图片应用成功后回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('各种格式图片进入壁纸设置页面 end');
}

/**
 * 大图-壁纸: [不同拍摄模式图片进入壁纸设置页面]
 * TAG: 44 TID: Multimedia_Gallery_Wallpapers_005
 * 前置条件
 * 1、用相机不同拍摄模式（动态照片、人像、夜景、广角等）拍摄不同的图片文件
 */
async function Multimedia_Gallery_Wallpapers_005(dt: Dt) {
  dt.log.i('不同拍摄模式图片进入壁纸设置页面 start');
  dt.log.i('STEP 1、各种拍摄模式（含动态照片）的图片进入大图，点击更多按钮');

  await dt.sleep();
  dt.log.i('STEP 2、点击 设置为壁纸 选项');

  await dt.sleep();
  dt.log.i('预期结果2、成功拉起壁纸设置页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消按钮');

  await dt.sleep();
  dt.log.i('预期结果3、4、返回到大图页面5、图片应用成功后回到大图页面6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、侧划返回');

  await dt.sleep();
  dt.log.i('STEP 5、点击应用按钮');

  await dt.sleep();
  dt.log.i('预期结果5、图片应用成功后回到大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、返回桌面查看壁纸');

  await dt.sleep();
  dt.log.i('预期结果6、壁纸设置成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同拍摄模式图片进入壁纸设置页面 end');
}

