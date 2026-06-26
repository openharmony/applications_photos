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

import { Component, Driver, ON } from '@ohos.UiTest';
import { expect } from '@ohos/hypium';
import Timer from '../../main/utils/Timer';
import { DELAY } from './Config.test';
import { Ui } from './Ui';

/* instrument ignore file */

/**
 * 延时工具类
 */
export class DelayControl extends Ui {
  constructor(tag: string, driver: Driver) {
    super(tag);
    this.driver = driver;
  }

  public driver: Driver;

  /**
   * 手动触发延时
   *
   * 使用方法: await dt.sleep(millisecond)
   * @param ms millisecond
   * @returns
   */
  public async sleep(ms?: number): Promise<void> {
    ms = ms ?? DELAY.default;
    if (ms >= DELAY.default - 1) {
      this.log.i('sleeping:' + ms);
    }
    await Timer.sleep(ms);
  }

  /**
   * 等待动效结束
   * @param ms
   * @returns
   */
  public async wait(ms?: number): Promise<void> {
    this.log.i('waiting:' + ms);
    await this.driver.waitForIdle(DELAY.rapid, ms || DELAY.long);
  }

  /**
   * 循环操作直到expectId界面
   * @param expectId
   * @param loopFunc
   * @param limit
   * @returns
   */
  public async loopUntil(expectId: string, loopFunc?: () => Promise<void>,
    limit?: number): Promise<void> {
    if (await this.driver.findComponent(ON.id(expectId))) {
      this.log.i(expectId + ' already here. ');
      return;
    }
    let i = 0;
    limit = limit ?? 0x50;
    if (!loopFunc) {
      loopFunc = async (): Promise<void> => {
      };
    }
    for (
      let component: Component | undefined = undefined;
      !component;
      component = await this.driver.findComponent(ON.id(expectId))
    ) {
      await loopFunc();
      await this.sleep(1);
      i++;
      if (i > limit) {
        this.log.i('found comp:' + expectId);
        break;
      }
    }
  }

  /**
   * 执行异步函数, 并计算函数执行时间
   * 对组件进行性能指标限制
   *
   * 使用方法: const duration = await dt.waitForComp(PANEL, MAX_SHOW_PANEL_DURATION);
   * @param
   * @returns ms millisecond
   */
  public async waitForComp(expectId: string, assertLess: number = DELAY.enormous): Promise<number> {
    const duration = await Timer.getDuration(async (dt: DelayControl) => {
      await this.loopUntil(expectId, async () => {
      },)
    })
    this.log.w(expectId + ' it takes ' + duration + 'ms; max: ' + assertLess);
    if (assertLess) {
      expect(duration).assertLess(assertLess);
    }
    return duration;
  }
}