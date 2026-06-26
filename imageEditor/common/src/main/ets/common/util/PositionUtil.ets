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

import { Rectangle } from './types';
import { componentUtils } from '@kit.ArkUI';
import { HiLog } from './HiLog';

export class Position {
  private constructor() {
  }

  public static getRectangleById(id: string): Rectangle {
    let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById(id);
    if (modePosition === undefined || modePosition === null) {
      HiLog.e('PositionUtil', 'failed to get Rectangle by id');
      return new Rectangle(0, 0, 0, 0);
    }
    let x: number = Math.round(modePosition.windowOffset.x);
    let y: number = Math.round(modePosition.windowOffset.y);
    let width: number = Math.round(modePosition.size.width);
    let height: number = Math.round(modePosition.size.height);
    let rect = new Rectangle(px2vp(x), px2vp(y), px2vp(x + width), px2vp(y + height));
    return rect;
  }

  public static getCenterById(id: string): number[] {
    let rect = Position.getRectangleById(id);
    let centX = rect.left + (rect.right - rect.left) / 2;
    let centY = rect.top + (rect.bottom - rect.top) / 2;
    return [centX, centY];
  }

  // 判断数据是否在指定闭区间内
  public static isNumberInInterval(val: number, interval: [number, number]) {
    return val >= interval[0] && val <= interval[1]
  }

  // 判断两个矩形尺寸是否相同
  public static isRectangleSizeEqual(a: Rectangle, b: Rectangle): boolean {
    return Math.round(a.width() - b.width()) === 0 && Math.round(a.height() - b.height()) === 0
  }

  /**
   * 判断两个矩形是否相同
   * @param a
   * @param b
   * @returns
   */
  public static isSameRectInPixel(a: Rectangle, b: Rectangle): boolean {
    return Math.round(a.left - b.left) === 0 && Math.round(a.top - b.top) === 0 &&
      Math.round(a.right - b.right) === 0 && Math.round(a.bottom - b.bottom) === 0;
  }
}