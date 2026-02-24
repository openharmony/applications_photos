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

import { MustAt } from './MustAt';
import { TestConstants } from './TestConstants';
import { Component, ON } from '@kit.TestKit';
import { ScreenComp } from './ScreenComp';
import { expect } from '@ohos/hypium';
import { DELAY } from './Config.test';
import { Dt } from './Dt';

export class CommonOperate extends MustAt {
  public async swipeUntilClick(CompId?: string) {
    CompId = CompId || this.button.videoScreenshot();
    for (
      let component: Component | undefined = undefined;
      !component;
      component = await this.driver.findComponent(ON.id(CompId))
    ) {
      await this.swipeScreen?.left();
      this.log.i('swipe to left');
    }
    await this.assertClick(CompId);
    await this.sleep();
  }

  /**
   * 跳过引导页
   */
  public async skipBootPage() {
    await this.driver.wakeUpDisplay();
    await this.sleep(DELAY.long);
    await this.clickIfExistByText('同意', TestConstants.DELAY_ONE_SECOND);
    await this.clickIfExistByText('跳过', TestConstants.DELAY_ONE_SECOND);
    await this.clickIfExistByText('立即体验', TestConstants.DELAY_ONE_SECOND);
    await this.clickIfExistByText('暂不登录');
    await this.clickIfExistByText('稍后升级', TestConstants.DELAY_ONE_SECOND);
    await this.clickIfExistByText('暂不开启', TestConstants.DELAY_ONE_SECOND);
    await this.clickIfExist('EnableSyncSplashCancelButton_false');
  }

  /**
   * 跳过相机引导页
   */
  public async skipCameraBootPage() {
    await this.driver.wakeUpDisplay();
    await this.sleep();
    this.log.i('Camera_Permission start');
    await this.sleep(DELAY.double);
    let id = 'Paf.Permission.button_confirm';
    if (await this.driver.findComponent(ON.id(id))) {
      this.log.i( 'agree clicked');
      await this.clickIfExist( id );
      await this.sleep();
      id = 'STARTUP_GUIDANCE_BTN';
      if (await this.driver.findComponent(ON.id(id))) {
        this.log.i('start up guidance is clicked.');
        await this.clickIfExist( id );
      }
      await this.clickIfExistByText('仅使用期间允许');
      await this.sleep();
    } else {
      this.log.i( 'Already agree.');
    }
    const component = await this.driver.findComponent(ON.id('COMPONENT_ID_SHUTTER_PHOTO_1'));
    expect(component).not().assertNull();
    this.log.i('Init_Permission end');
  }

  //选择拍照模式
  public async shoot(): Promise<void> {
    await this.sleep();
    await this.clickIfExist("COMPONENT_ID_CONTROL_PHOTO_2");//选择拍照
    this.log.i('at cameraShoot');
  }


  //enterBrowserTab
  public async clickTimeline(): Promise<void> {
    await this.sleep(TestConstants.DELAY_THREE_SECOND);
    await this.clickIfExist('TabPhotos');
    this.log.i('TabPhotos clicked');
  }

  //enterVideoBrowser
  public async clickVideoBrowser(): Promise<void> {
    await this.sleep(TestConstants.DELAY_THREE_SECOND);
    await this.clickIfExist('TabAlbums');
    await this.sleep(TestConstants.DELAY_TWO_SECOND);
    await this.assertClick('Album_1');
    await this.assertClick('photoGridView_gird_0');
    await this.sleep(TestConstants.DELAY_TWO_SECOND);
    this.log.i('TabPhotos clicked');
  }

  public async browserToVideo(): Promise<void> {
    await this.backToTimeline();
    await this.clickVideoBrowser();
    await this.sleep();
  }

  public async backToTimeline(): Promise<void> {
    await this.pressBack();
    await this.wait();
    await this.sleep(DELAY.short);
    await this.mustAtTimeline();
  }

  //clickGridItem
  public async clickGridItem(): Promise<void> {
    await this.sleep(DELAY.short);
    const hasButton = await this.clickIfExist('imageGridItem');
    await this.negateComponent('imageGridItem');
    if (!hasButton) {
      await this.clickIfExist('TimelinePage_GridItem12');
    }
    this.log.i('browser clicked');
  }

  //clickTabAlbums
  public async tabAlbums(): Promise<void> {
    await this.sleep(DELAY.double);
    await this.clickIfExist('TabAlbums');
    this.log.i('TabAlbums clicked');
  }

  /**
   * 判断当前页面是否在首页
   */
  public async tabIndex(): Promise<void> {
    const dt = await new Dt('tabIndex').init();
    await dt.loopUntil('TabAlbums', async () => {
      await dt.driver.pressBack();
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }, 5);
    this.log.i('exit TabAlbums Task end');
  }
}