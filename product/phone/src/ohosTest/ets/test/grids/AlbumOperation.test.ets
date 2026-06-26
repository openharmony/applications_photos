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
import { describe, expect } from '@ohos/hypium';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { SkipBootPage } from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { ON } from '@kit.TestKit';

const TAG: string = `${TestConstants.TAG}albumOperationTest`;
const NUMBER_ONE: number = 1;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function albumOperationTest(): void {
  describe('AlbumOperationTest', (): void => {
    it('AlbumOperation_001', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AlbumOperation_001(dt);
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('AlbumOperation_002', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AlbumOperation_002(dt);
    });
    it('AlbumOperation_003', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AlbumOperation_003(dt);
    })
    it('AlbumOperation_004', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AlbumOperation_004(dt);
    })
    it('AlbumOperation_005', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await AlbumOperation_005(dt);
    });
  })

}

/**
 * 打开图库
 */
async function AlbumOperation_001(dt: Dt) {
  Log.info(TAG, 'Task_001_StartPhoto_Test01 start');
  try {
    let res =
      await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
        .then((): void => {
          Log.info(TAG, 'MainAbility start success');
        });
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  Log.info(TAG, 'AlbumOperation_001 end ');
  await SkipBootPage();
}

/**
 * 1、点击相册tab， 点击第0个相册
 * 2、打开宫格页第二张图片
 * 3、点击更多-点击复制
 * 4、点击分享-返回
 * 5、退出大图浏览
 */
async function AlbumOperation_002(dt: Dt) {
  Log.info(TAG, 'AlbumOperation_002 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击相册
  await dt.assertClick('TabAlbums');
  // 多次下拉寻找图片相册
  await dt.swipeUp();
  // 点击图片相册
  await dt.assertTextClick(TestConstants.ALBUM_NAME_TU_PIAN_NAME);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, '图片 clicked');
  // 点击第2张图片
  await dt.assertClick('photoGridView_gird_1');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'photoGridView_gird_1 clicked');
  // 大图分享
  await dt.assertClick('ToolBarButtonShare');
  await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  Log.info(TAG, 'buttonShare clicked');
  // 返回
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  Log.info(TAG, 'pressBack clicked');
  // 点击返回退出大图预览
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ActionBarButtonBack clicked');
  Log.info(TAG, 'AlbumOperation_002 end');
}

/**
 * 1.点击多选，选中第8张，收藏，多选，选中第8张，取消收藏
 */
async function AlbumOperation_003(dt: Dt) {
  Log.info(TAG, 'AlbumOperation_003 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击第八个图片
  if (await driver.findComponent(ON.id('photoGridView_gird_1'))) {
    await dt.assertClick('Selector_1');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 点击更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击收藏
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_FAVOR);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击多选
    await dt.assertTextClick('多选');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击第八个图片
    await dt.assertClick('Selector_1');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 点击更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击取消收藏
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_FAVOR);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  Log.info(TAG, 'AlbumOperation_003 end');
}

/**
 * 点击多选，选中第9张，隐藏
 */
async function AlbumOperation_004(dt: Dt) {
  Log.info(TAG, 'AlbumOperation_004 start');
  let driver = dt.driver;
  // 点击多选
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await driver.findComponent(ON.id('photoGridView_gird_1'))) {
    Log.info(TAG, 'photoGridView_gird_1 find');
    await dt.assertClick('Selector_1');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 点击更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击隐藏
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_HIDE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击确认
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  Log.info(TAG, 'AlbumOperation_004 start');
}

/**
 * 1、点击多选
 * 2、选中第一，第二张进行复制
 * 3、点击分享-返回
 * 4、点击全选进行复制
 * 5、退出多选,返回tab页
 */
async function AlbumOperation_005(dt: Dt) {
  Log.info(TAG, 'AlbumOperation_005 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击多选
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'multiSelectedBtn click');
  const button1 = await driver.findComponent(ON.id('Selector_4'));
  const button2 = await driver.findComponent(ON.id('Selector_5'));
  if (button1 && button2) {
    // 选中第一，第二张进行复制
    await button1.click();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'button1 clicked');
    await button2.click();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'button2 clicked');

    // 分享第一、二张
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_SHARE);
    await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    Log.info(TAG, 'buttonShare clicked');
    // 点击返回取消分享
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    Log.info(TAG, 'pressBack clicked');
    // 点击左上角×，取消多选
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_CANCEL);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'ActionBarButtonCancel clicked');
    // 点击返回，退出当前相册
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'ActionBarButtonBack clicked ');
  }
  Log.info(TAG, 'AlbumOperation_005 end');
}