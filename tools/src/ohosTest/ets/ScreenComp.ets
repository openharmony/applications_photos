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

import { ON, Point, UiDirection, WindowMode } from '@ohos.UiTest';
import { PageTitle } from '../../main/global/pages/PageTitle';
import { Comp } from './Comp';
import { DELAY } from './Config.test';
import { Dt } from './Dt';

/* instrument ignore file  */
export class ScreenComp extends Comp {
  public windowMode: WindowMode = WindowMode.FULLSCREEN;

  public async cornerMenu(direction: UiDirection.LEFT | UiDirection.RIGHT = UiDirection.RIGHT) {
    const topCorner: Point = this.topCornerMenu(direction);
    this.log.i(direction + ' cornerMenu swipe');
    await this.dragBetween([topCorner, this.GetCorner(direction, UiDirection.DOWN)]);
    this.windowMode = WindowMode.FLOATING;
  }

  public async switchMode(mode: WindowMode) {
    const dt = new Dt(this.tag, this.driver);
    this.log.i(`switch WindowMode to ${mode}`);
    switch (mode) {
      //全屏
      case WindowMode.FULLSCREEN:
        await this.clickTopMenu(UiDirection.LEFT);
        break;
    //悬浮窗
      case WindowMode.FLOATING:
        await this.fullScreenToFloat();
        await dt.sleep();
        this.log.i('到这里首次进入悬浮窗会弹出引导页');
        await dt.clickIfExistByText('完成');
        await dt.sleep(DELAY.short);
        await dt.assertClick('SCBFloatMiniCoverWindow', true);
        break;
    //分屏
      case WindowMode.PRIMARY:
        await this.fullScreenToPrimary();
        await dt.assertClick('ResidentLayout_AppItem_com.ohos.browser', true);
        break;

      default:
        this.log.w('switchMode not implemented');
        break;
    }
    this.windowMode = mode;
    await this.initIndex();
    await dt.sleep();
  }

  public async clickTopMenu(direction: UiDirection.LEFT | UiDirection.RIGHT = UiDirection.RIGHT) {
    const dt = new Dt(this.tag, this.driver);
    await dt.driver.penClick(this.topCornerMenu(direction));
    await this.sleep();
  }

  private async fullScreenToFloat() {
    await this.swipeBetween([this.GetCorner(UiDirection.RIGHT, UiDirection.DOWN),
      this.topCornerMenu(UiDirection.RIGHT)]);
    await this.sleep();
  }

  private async fullScreenToPrimary() {
    await this.swipeBetween([this.GetCorner(UiDirection.RIGHT, UiDirection.DOWN),
      this.topCornerMenu(UiDirection.LEFT)]);
    await this.sleep();
  }

  public async minimize() {
    this.log.w('minimize');
    await this.switchMode(WindowMode.FLOATING);
    await this.clickTopMenu();
  }

  /**
   * 退出图库app, 每次测试套结束必须执行, 保证测试套独立性
   */
  public async quitApp() {
    this.log.w('quitApp');
    await this.swipeBetween([this.GetCorner(undefined, UiDirection.DOWN), this.GetCorner()], 600);
    await this.left();
    await this.sleep();
    await this.top();
  }
}
