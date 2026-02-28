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

import { DisplayRotation, Driver } from '@ohos.UiTest';
import { expect } from '@ohos/hypium';
import { DELAY } from './Config.test';
import { DelayControl } from './DelayControl';
import { Factory } from './Factory.test';
import { ScreenComp } from './ScreenComp';

/* instrument ignore file */

/**
 * DT条件切换工具类
 *
 * 我们还以利用可复用设计对执行条件进行遍历, 覆盖人工无法穷举的场景.
 *
 * 考虑以下这些条件: (互斥用中括号)
 *
 * 环境:
 * 应用锁 横竖屏 [全屏 分屏 悬浮窗 xxx展开] [深色模式 浅色模式]
 *
 * 进入方式:
 * 从 锁屏相机 [宫格 时间线 相册] 进入
 *
 * 图片类型/格式 :
 * [ 动态 摩尔纹 HEIF heif HDR 动态照片 mp4]
 *
 * 对以上场景进行排列组合; 我们可以计算这些不同场景的数量(应用锁 为2种可能条件(有/无); [全屏 分屏 悬浮窗]为3种可能条件)为:
 * 2 x 2 x 3 x 2
 * x 2 x 3
 * x 7
 * = 1008 种
 *
 * 编写条件变化函数覆盖以上条件; 用for循环可以遍历上述条件
 * 此方法理论上可以大幅提高DT覆盖率, 测试用例全的前提下, 可以充分并高效的覆盖业务代码中由
 * ScreenManager.Rotation isSecurityCamera screenUnlock
 * 判断产生的分支
 */
export class Switcher extends DelayControl {
  constructor(tag: string, driver: Driver) {
    super(tag, driver);
  }

  public swipeScreen?: ScreenComp;

  public getScreen(): ScreenComp {
    expect(!this.swipeScreen).assertFalse();
    if (!this.swipeScreen) {
      this.log.e('swipeScreen not initialized!');
      throw Error('swipeScreen not initialized!');
    }
    return this.swipeScreen;
  }

  /**
   * 条件变化函数
   * 可以在2个测试执行步骤中任意插入
   * 对于关键易出错场景应该覆盖到位
   * @param conf  条件变化控制; 为空时随机切换条件
   * @returns
   */
  public async conditionChange(conf?: Factory.Config): Promise<void> {

  }

  /**
   * 横竖屏
   * @param rotation
   * @param ms
   * @returns
   */
  public async rotate(rotation?: DisplayRotation, ms?: number): Promise<void> {
    if (!rotation) {
      if (this.rotation === DisplayRotation.ROTATION_0) {
        rotation = DisplayRotation.ROTATION_0;
      } else {
        rotation = DisplayRotation.ROTATION_90
      }
    }
    this.rotation = rotation;
    await this.driver.setDisplayRotation(this.rotation);
    await this.sleep(ms ?? DELAY.default);
    await this.getScreen().initIndex();
  }
}