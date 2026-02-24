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
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import {
  assertClickById,
  assertClickByText,
  ConnectionWifi,
  ConnectionWifiClickButton,
  getWifiConnectionName,
  ShootMovingPhoto,
  ShootStaticPhoto,
  SkipBootPage,
  StartCamera,
  StartFiles,
  StartPhotos,
  StartSetting,
  StopFiles,
  simulateIn,
  BackToHome,
  skipCameraBoot,
  clickTextIfExist
} from '../tools/steps';
import { Driver, MatchPattern, ON } from '@kit.TestKit';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { retriesAsync } from '../tools/utils';
import wifiManager from '@ohos.wifiManager';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DeviceUtil } from '@oh-image-editor/editor-common'

const TAG = 'EditorSetup';

export default function Ba() {
  describe('B_Setup', () => {
    it('B_Editor_Setup_Skip', 0, async () => {
      const driver = Driver.create();
      await StopFiles();
      await StartFiles();
      let component = await driver.findComponent(ON.id('advanced_dialog_button_0'));
      if (component) {
        await assertClickById('advanced_dialog_button_0');
        await driver.delayMs(1000);
      }
      await clickTextIfExist('同意', driver);
      await clickTextIfExist('跳过', driver);
      await clickTextIfExist('不允许', driver);
    });

    it('B_Editor_Setup_DeleteAlbum', 0, async () => {
      const driver = Driver.create();
      // 打开文件管理
      await StopFiles();
      await StartFiles();

      await driver.delayMs(2000);
      await assertClickByText('浏览');
      await driver.delayMs(1000);
      await assertClickByText('我的手机');

      // 进入图库文件夹 避免内部有多个文件（滑动查找5次）
      const galleryIcon = ON.id('galleryIcon');
      let attempts = 5;
      while (attempts-- > 0) {
        const cmp = await driver.findComponent(galleryIcon);
        if (cmp) {
          await assertClickById('galleryIcon');
          break;
        }
        if (DeviceUtil.isFoldLandScape()) {
          await driver.swipe(1600, 1400, 1600, 400, 900);
        } else {
          await driver.swipe(600, 1400, 600, 400, 900);
        }
        await driver.delayMs(500);
      }
      await retriesAsync(async () => {
        await assertClickByText('多选');
        await driver.delayMs(1000);
        let components = await driver.findComponents(ON.text('新建相册', MatchPattern.CONTAINS));
        if (!components || !components.length) {
          return Promise.resolve();
        }
        for (let i = 0; i < components.length; i++) {
          await components[i].click();
        }
        await assertClickByText('删除');
        await driver.delayMs(2000);
        const dialogBtn = await driver.findComponent(ON.text('删除').within(ON.type('Dialog')));
        if (dialogBtn) {
          await dialogBtn.click();
        }
        return Promise.reject();
      }, 5);
    });
    it('B_Editor_setup_Delete', 0, async () => {
      const driver = Driver.create();
      // 打开文件管理
      await StopFiles();
      await StartFiles();
      await driver.delayMs(2000);
      await assertClickByText('浏览');
      await driver.delayMs(1000);
      await assertClickByText('我的手机');
      // 进入图库文件夹 避免内部有多个文件（滑动查找5次）
      const galleryIcon = ON.id('galleryIcon');
      let attempts = 5;
      while (attempts-- > 0) {
        const cmp = await driver.findComponent(galleryIcon);
        if (cmp) {
          await assertClickById('galleryIcon');
          break;
        }
        if (DeviceUtil.isFoldLandScape()) {
          await driver.swipe(1600, 1400, 1600, 400, 900);
        } else {
          await driver.swipe(600, 1400, 600, 400, 900);
        }
        await driver.delayMs(500);
      }
      const multi = await driver.findComponent(ON.text('多选').within(ON.id('top_button')));
      if (multi) {
        await multi.click();
      }
      for (const group of ['图片编辑组', '最佳表情', '拍照预制']) {
        const item = await driver.findComponent(ON.text(group).within(ON.type('ListItem')));
        if (item) {
          await item.click();
        }
      }
      const selectedItems = await driver.findComponents(ON.type('ListItem').selected());
      if (selectedItems && selectedItems.length !== 0) {
        await assertClickById('delete');
        const dialogBtn = await driver.findComponent(ON.text('删除').within(ON.type('Dialog')));
        if (dialogBtn) {
          await dialogBtn.click();
        }
      }

      await driver.delayMs(TestConstants.DELAY_FIVE_SECOND);
      await StopFiles();
    });
    it('B_Editor_Setup_Copy', 0, async (dt: Dt) => {
      const driver = Driver.create();
      // 打开文件管理
      await StopFiles();
      await StartFiles();
      await driver.delayMs(2000);
      await assertClickByText('浏览');
      await driver.delayMs(1000);
      await assertClickByText('我的手机');
      // 进入图库文件夹
      const multi = await driver.findComponent(ON.text('多选').within(ON.id('top_button')));
      if (multi) {
        await multi.click();
      }
      for (const group of ['图片编辑组', '最佳表情']) {
        const item = await driver.findComponent(ON.text(group).within(ON.type('ListItem')));
        if (item) {
          await item.click();
        }
      }
      const cmp = await assertClickById('copy');
      expect(cmp).assertInstanceOf('Object');
      await driver.delayMs(3000);
      const photos = await driver.findComponent(ON.id('gallery').within(ON.type('SheetPage')));
      if (photos) {
        await photos.click();
      }
      await dt.clickIfExist('dialog_confirm');
      await driver.delayMs(TestConstants.DELAY_FIVE_SECOND);
      await StopFiles();
    });
    it('B_Editor_Connection_Wifi', 0, async () => {
      const isActive = wifiManager.isWifiActive();
      if (isActive) {
        expect(isActive).assertTrue();
        if (await getWifiConnectionName() !== 'WLAN') {
          Log.info(TAG, 'wifi is opened and connected');
          return;
        } else {
          Log.info(TAG, 'wifi is opened but not connected');
          //打开设置，连接wifi
          await StartSetting();
          await ConnectionWifi();
        }
      } else {
        expect(isActive).assertFalse();
        //下滑连接WiFi
        Log.info(TAG, 'wifi is close,need to open wifi and connection wifi');
        await StartSetting();
        await ConnectionWifiClickButton();
      }
    });

    it('B_Start_Camera', 0, async (dt: Dt) => {
      const isStartCamera = await StartCamera();
      expect(isStartCamera).assertTrue();
      await skipCameraBoot();
    });
    it('B_Take_Photo_Static', 0, async (dt: Dt) => {
      const isShootStaticPhoto = await ShootStaticPhoto();
      expect(isShootStaticPhoto).assertTrue();
    });
    it('B_Take_Photo_Dynamic', 0, async (dt: Dt) => {
      const isShootStaticPhoto = await ShootMovingPhoto();
      expect(isShootStaticPhoto).assertTrue();
      await BackToHome();
    });
    it('B_Create_Camera_Album_1', 0, async (dt: Dt) => {
      const success = await StartPhotos();
      expect(success).assertTrue();
      await SkipBootPage();
    });
    it('B_Create_Camera_Album_2', 0, async (dt: Dt) => {
      const clicked = await assertClickById('TabAlbums');
      expect(clicked).not().assertNull();
      await dt.driver.delayMs(TestConstants.DELAY_FIVE_SECOND);
    });
    it('B_Create_Camera_Album_3', 0, async (dt: Dt) => {
      const clicked = await assertClickById('TabPhotos');
      expect(clicked).not().assertNull();
      await dt.driver.delayMs(TestConstants.DELAY_FIVE_SECOND);
    });
    it('B_Create_Camera_Album_4', 0, async (dt: Dt) => {
      let component = await simulateIn(dt.driver, ON.id('photoGridView_gird_1'), 50);
      if (component) {
        expect(component).assertInstanceOf('Object');
        await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      }
    });
    it('B_Create_Camera_Album_5', 0, async (dt: Dt) => {
      const clicked = await assertClickByText('多选');
      expect(clicked).not().assertNull();
    });
    it('B_Create_Camera_Album_6', 0, async (dt: Dt) => {
      await assertClickById('Selector_1');
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      //4.点击完成按钮
      await assertClickById('Selector_2');
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      await assertClickById('More');
      await assertClickById('ActionBarButton_Text_ActionButton_Move');
      let result = await dt.driver.findComponent(ON.text('拍照预制'));
      let condition = 10;
      while (condition--) {
        if (result) {
          break;
        }
        await dt.driver.swipe(600, 1400, 600, 400, 900);
        result = await dt.driver.findComponent(ON.text('拍照预制'));
      }
      if (result) {
        await result.click();
        await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);
      } else {
        await assertClickById('AccessibilityComponentNewAlbum');
        const input = await dt.driver.findComponent(ON.id('NewAlbumDialogTextInput'));
        expect(input).not().assertNull();
        await input.inputText('拍照预制');
        const btn = await assertClickById('advanced_dialog_button_1');
        expect(btn).not().assertNull();
      }
      Log.info(TAG, 'add photo finish');
    });
  });
}