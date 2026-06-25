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
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON, PointerMatrix } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { SkipBootPage } from '../../imageEditor/tools/steps';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';

const TAG: string = `${TestConstants.TAG}SmartTimeLineOperationByRotateTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();


async function testOpenApp(ability: string, name: string): Promise<void> {
  Log.info(TAG, ` ${name} start`);
  try {
    await abilityDelegator.executeShellCommand(ability)
      .then((): void => {
        Log.info(TAG, 'MainAbility start success');
      });
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  Log.info(TAG, `${name} end`);
}

async function testClickById(driver: Driver, id: string, logInfo: string): Promise<void> {
  await driver.assertComponentExist(ON.id(id));
  const button = await driver.findComponent(ON.id(id));
  await button.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, logInfo);
}

async function testClickByText(driver: Driver, id: string, logInfo: string): Promise<void> {
  await driver.assertComponentExist(ON.text(id));
  const button = await driver.findComponent(ON.text(id));
  await button.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, logInfo);
}

async function testClickByPosition(driver: Driver, x: number, y: number, logInfo: string): Promise<void> {
  await driver.click(x, y);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, logInfo);
}

export default function SmartTimeLineOperationByRotateTest(): void {
  describe('SmartTimeLineOperationByRotateTest', () => {
    /**
     * 1、打开图库
     */
    it('SmartTimeLineOperationByRotate_start_photo', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      let result = await testOpenApp('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos',
        'SmartTimeLineOperationByRotate_start_photo');
      expect(result !== null).assertTrue();
    }, {
      rotate: false,
    });

    it('SmartTimeLineOperationByRotate_001', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await SmartTimeLineOperationByRotateTest01(dt);
    }, {
      rotate: false
    })

    it('SmartTimeLineOperationByRotate_002', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await SmartTimeLineOperationByRotateTest02(dt);
    }, {
      rotate: false,
    })

    it('SmartTimeLineOperationByRotate_003', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await SmartTimeLineOperationByRotateTest03(dt);
    }, {
      rotate: false,
    })

  })
}

/**
 * 1、点击toolbar全选
 * 2、选择第一张照片
 * 3、选择第二张照片
 * 4、点击对比
 * 5、双指缩放
 * 6、单指平移
 * 7、取消联动
 * 8、双指缩放
 * 9、单指平移
 * 10、点击加号跳转到picker
 * 11、选择一张照片
 * 12、点击完成
 * 13、取消勾选底部图片
 * 14、点击收藏按钮
 * 15、点击删除图标
 * 16、点击删除按钮
 */
async function SmartTimeLineOperationByRotateTest01(dt: Dt) {
  Log.info(TAG, 'SmartTimeLineOperationByRotate_001 start');
  let driver = dt.driver;
  await dt.albumList();
  await Exit.album('Album_0', 540, 1200);
  if (await driver.findComponent(ON.id('Album_0'))) {
    await dt.driver.assertComponentExist(ON.id('Album_0'));
    await dt.clickIfExist('Album_0', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExistByText('多选', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExist('Selector_0', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExist('Selector_1', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExist('Selector_2', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExist('ToolBarButton_ActionButton_Creation', TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExist('ActionBarButton_Text_ActionButton_Collage', TestConstants.DELAY_ONE_SECOND);
    // await twoFingerPinch(dt.driver);
    await testClickById(driver, 'More_Image_Back', 'More_Image_Back clicked');

    // 退出多选模式
    await testClickById(driver, 'ActionButton_Cancel', 'More_Image_Cancel clicked');
    await testClickById(driver, 'ActionButton_Back', 'More_Image_Back clicked');
  }
}

async function twoFingerPinch(driver: Driver) {
  // 双指捏合放大
  let pointers01 = PointerMatrix.create(2, 3);
  pointers01.setPoint(0, 0, {
    x: 700, y: 1000,
  });
  pointers01.setPoint(0, 1, {
    x: 700, y: 900,
  });
  pointers01.setPoint(0, 2, {
    x: 700, y: 800,
  });
  pointers01.setPoint(1, 0, {
    x: 700, y: 1250,
  });
  pointers01.setPoint(1, 1, {
    x: 700, y: 1350,
  });
  pointers01.setPoint(1, 2, {
    x: 700, y: 1450,
  });
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  // 平移
  await driver.swipe(135, 904, 618, 884, 600);

  // 双指捏合缩小
  let pointers02 = PointerMatrix.create(2, 3);
  pointers02.setPoint(0, 0, {
    x: 700, y: 800,
  });
  pointers02.setPoint(0, 1, {
    x: 700, y: 900,
  });
  pointers02.setPoint(0, 2, {
    x: 700, y: 1000,
  });
  pointers02.setPoint(1, 0, {
    x: 700, y: 1450,
  });
  pointers02.setPoint(1, 1, {
    x: 700, y: 1350,
  });
  pointers02.setPoint(1, 2, {
    x: 700, y: 1250,
  });
  await driver.injectMultiPointerAction(pointers02);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  await pointers(driver, pointers01, pointers02);
}

async function pointers(driver: Driver, pointers01: PointerMatrix, pointers02: PointerMatrix) {
  await testClickById(driver, 'ImmersiveComparedLinkage', 'ImmersiveComparedLinkage clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 双指捏合放大
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  // 平移
  await driver.swipe(135, 904, 618, 884, 600);

  // 双指捏合缩小
  await driver.injectMultiPointerAction(pointers02);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  await testClickById(driver, 'ImmersiveComparedListItem2', 'ImmersiveComparedListItem2 clicked');
  await testClickById(driver, 'ImmersiveComparedFavor0', 'ImmersiveComparedFavor0 clicked');
  await testClickById(driver, 'ImmersiveComparedDelete0', 'ImmersiveComparedDelete0 clicked');
  await testClickById(driver, 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
  await testClickById(driver, 'More_Image_Back', 'More_Image_Back clicked');

  // 退出多选模式
  await testClickById(driver, 'ActionButton_Cancel', 'More_Image_Cancel clicked');
  await testClickById(driver, 'ActionButton_Back', 'More_Image_Back clicked');

  Log.info(TAG, 'SmartTimeLineOperationByRotate_001 end');
}

/**
 * 1、点击toolbar全选
 * 2、选择第一张照片
 * 3、选择第二张照片
 * 4、点击拼图
 * 5、双指缩放
 * 6、单指平移
 * 7、取消联动
 * 8、双指缩放
 * 9、单指平移
 * 10、点击旋转
 * 11、点击镜像
 * 12、点击替换
 * 13、点击完成
 * 14、点击取消边框
 * 15、替换边框样式
 * 16、返回照片页
 * 16、退出多选
 */
async function SmartTimeLineOperationByRotateTest02(dt: Dt) {
  Log.info(TAG, 'SmartTimeLineOperationByRotate_002 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await Exit.album('TabAlbums', 540, 1200);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await driver.findComponent(ON.id('TabAlbums'))) {
    await driver.assertComponentExist(ON.id('TabAlbums'));
    await testClickById(driver, 'TabAlbums', 'TabAlbums clicked');
    await testClickById(driver, 'Album_0', 'Album_0 clicked');
    await testClickByPosition(driver, 954, 214, 'SelectedPortrait1 clicked');
    await testClickById(driver, 'Selector_0', 'Selector_0 clicked');
    await testClickById(driver, 'Selector_1', 'Selector_1 clicked');
    await testClickById(driver, 'ToolBarButton_ActionButton_Creation', 'ToolBarButton_ActionButton_Creation clicked');
    await testClickById(driver, 'ActionBarButton_Text_ActionButton_Collage', 'ActionBarButton_Text_ActionButton_Collage clicked');

    // await puzzleTwoFingerPinch(driver);
    await testClickById(driver, 'More_Image_Back', 'More_Image_Back clicked');

    // 退出多选模式
    await testClickById(driver, 'ActionButton_Cancel', 'More_Image_Cancel clicked');
    await testClickById(driver, 'ActionButton_Back', 'More_Image_Back clicked');
  }
}

async function puzzleTwoFingerPinch(driver: Driver) {
  // 双指捏合放大
  let pointers01 = PointerMatrix.create(2, 3);
  pointers01.setPoint(0, 0, {
    x: 700, y: 1000,
  });
  pointers01.setPoint(0, 1, {
    x: 700, y: 900,
  });
  pointers01.setPoint(0, 2, {
    x: 700, y: 800,
  });
  pointers01.setPoint(1, 0, {
    x: 700, y: 1250,
  });
  pointers01.setPoint(1, 1, {
    x: 700, y: 1350,
  });
  pointers01.setPoint(1, 2, {
    x: 700, y: 1450,
  });
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  // 平移
  await driver.swipe(135, 904, 618, 884, 600);

  // 双指捏合缩小
  let pointers02 = PointerMatrix.create(2, 3);
  pointers02.setPoint(0, 0, {
    x: 700, y: 800,
  });
  pointers02.setPoint(0, 1, {
    x: 700, y: 900,
  });
  pointers02.setPoint(0, 2, {
    x: 700, y: 1000,
  });
  pointers02.setPoint(1, 0, {
    x: 700, y: 1450,
  });
  pointers02.setPoint(1, 1, {
    x: 700, y: 1350,
  });
  pointers02.setPoint(1, 2, {
    x: 700, y: 1250,
  });
  await driver.injectMultiPointerAction(pointers02);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  await puzzlePointers(driver, pointers01, pointers02);
}

async function puzzlePointers(driver: Driver, pointers01: PointerMatrix, pointers02: PointerMatrix) {
  // 双指捏合放大
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  // 平移
  await driver.swipe(135, 904, 618, 884, 600);

  // 双指捏合缩小
  await driver.injectMultiPointerAction(pointers02);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ImmersiveComparedImage scaled');

  await testClickById(driver, 'puzzle_image_rotate', 'puzzle_image_rotate clicked');
  await testClickById(driver, 'puzzle_image_mirroring', 'puzzle_image_mirroring clicked');
  await testClickById(driver, 'puzzle_frame', 'puzzle_frame clicked');
  await testClickById(driver, 'puzzle_frame', 'puzzle_frame clicked');
  await testClickById(driver, 'puzzle_template_longJigsawPuzzle-2', 'puzzle_template_longJigsawPuzzle-2 clicked');
  await testClickById(driver, 'puzzle_template_longJigsawPuzzle-1', 'puzzle_template_longJigsawPuzzle-1 clicked');
  await testClickById(driver, 'puzzle_template_2_1', 'puzzle_template_2_1 clicked');
  await testClickById(driver, 'puzzle_template_2_2', 'puzzle_template_2_2 clicked');
  await testClickById(driver, 'puzzle_template_2_3', 'puzzle_template_2_3 clicked');
  //左滑
  await driver.swipe(900, 2550, 300, 2550, 600);
  await testClickById(driver, 'puzzle_template_2_4', 'puzzle_template_2_4 clicked');
  await testClickById(driver, 'puzzle_template_2_5', 'puzzle_template_2_5 clicked');
  await testClickById(driver, 'puzzle_template_2_6', 'puzzle_template_2_6 clicked');
  await testClickById(driver, 'More_Image_Back', 'More_Image_Back clicked');

  // 退出多选模式
  await testClickById(driver, 'ActionButton_Cancel', 'AccessibilityComponentCancel clicked');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  await testClickById(driver, 'ActionButton_Back', 'More_Image_Back clicked');
  Log.info(TAG, 'pressBack');

  Log.info(TAG, 'SmartTimeLineOperationByRotate_002 end');
}

async function SmartTimeLineOperationByRotateTest03(dt: Dt) {
  Log.info(TAG, 'SmartTimeLineOperationByRotateTest03 start');
  let driver = dt.driver;
  // 下拉显示出更多相册列
  await Exit.album('moreAlbum_0', 1200, 540);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击最近删除
  if (await driver.findComponent(ON.id('moreAlbum_0'))) {
    await driver.assertComponentExist(ON.id('moreAlbum_0'));
    await testClickById(driver, 'fromAlbum_0', 'moreAlbum_0 clicked');
    await testClickById(driver, 'photoGridView_gird_0', 'Selector_0 clicked');
    // // 点击更多 // await testClickById(driver, 'ActionBarButton_Text_MultiSelected', 'ActionBarButtonMultiSelected clicked');
    // // 点击全选 // await testClickById(driver, 'ActionBarButtonSelectAll', 'ActionBarButtonSelectAll clicked');
    // // 点击恢复 // await testClickById(driver, 'ToolBarButtonRecover', 'ToolBarButtonRecover clicked');
    await testClickById(driver, 'More_Image_Back', 'More_Image_Back clicked');
    await testClickById(driver, 'ActionButton_Back', 'More_Image_Back clicked');
  }
}