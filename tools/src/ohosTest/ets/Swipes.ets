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

import { Drv } from './Drv.test';
import { TestConstants } from './TestConstants';
import { Driver, Rect } from '@ohos.UiTest';
import { Switcher } from './Switcher.test';
import { DELAY } from './Config.test';
import { KeyCode } from '@kit.InputKit';
import { Position } from '@kit.ArkUI';

interface SwipeConst {
  border: number,
}

export const SWIPES: SwipeConst = {
  border: 10,
};

/* instrument ignore file */
export class Swipes extends Switcher {
  constructor(tag: string, driver: Driver) {
    super(tag, driver);
  }

  // Swiper View 内向左滑动
  public async slideTreasureBox(): Promise<void> {
    this.log.i('swipe right to left');
    return this.driver.swipe(START_RIGHT_X, CONSTANT_RIGHT_Y, END_RIGHT_X, CONSTANT_RIGHT_Y, SPEED);
  }

  // Swiper View 内向右滑动
  public async slideTreasureBoxRight(): Promise<void> {
    this.log.i('swipe left to right');
    return this.driver.swipe(START_RIGHT_BOX_X, CONSTANT_RIGHT_BOX_Y, END_RIGHT_BOX_X, CONSTANT_RIGHT_BOX_Y, SPEED);
  }

  // 从左边屏幕侧滑
  public async slideLeftFromScreen(): Promise<void> {
    this.log.i('slide left from screen');
    await this.sleep(1000);
    await this.driver.triggerKey(KeyCode.KEYCODE_BACK);
  }

  // 从中下部屏幕上滑
  public async slideUpHalfScreen(): Promise<void> {
    this.log.i('slide up');
    return this.driver.swipe(CONSTANT_UP_X, START_UP_Y, CONSTANT_UP_X, END_UP_Y, SPEED);
  }

  // 从中下部屏幕上滑
  public async slideUpHalfScreenQuick(): Promise<void> {
    this.log.i('slide up');
    return this.driver.swipe(CONSTANT_UP_X, START_UP_Y, CONSTANT_UP_X, END_UP_Y, SPEED_RAPIDLY);
  }

  // 从底部屏幕上滑
  public async slideUpFromBottom(): Promise<void> {
    this.log.i('slide up from screen');
    return this.driver.swipe(SWIPE_UP_X, SWIPE_START_Y, SWIPE_UP_X, SWIPE_END_Y, SPEED_QUICKLY);
  }
}

// 速率
export const SPEED = 1500;

export const SPEED_QUICKLY = 5000;

export const SPEED_RAPIDLY = 10000;

// Swiper View 内向左滑动
const START_RIGHT_X = 1000;
const END_RIGHT_X = 500;
const CONSTANT_RIGHT_Y = 2650;

// Swiper View 内向右滑动
const START_RIGHT_BOX_X = 500;
const END_RIGHT_BOX_X = 1000;
const CONSTANT_RIGHT_BOX_Y = 2650;

// 上滑
const CONSTANT_UP_X = 625;
const START_UP_Y = 1400;
const END_UP_Y = 0;
// 底部上滑
const SWIPE_UP_X = 600;
const SWIPE_START_Y = 2750;
const SWIPE_END_Y = 500;
