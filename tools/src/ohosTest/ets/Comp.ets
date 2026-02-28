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

import { Component, Driver, ON, Point, Rect } from '@ohos.UiTest';
import { DELAY } from './Config.test';
import { SPEED_QUICKLY, SPEED_RAPIDLY } from './Swipes';
import { DelayControl } from './DelayControl';
import { expect } from '@ohos/hypium';
import { UiDirection } from '@kit.TestKit';
import { PageTitle } from '../../main/global/pages/PageTitle';

interface IDistance {
  border: number,
  edge: number,
}

export const SIDES: IDistance = {
  border: 10,
  edge: 50,
};

export class Comp extends DelayControl {
  constructor(id: string, driver: Driver) {
    super(id, driver);
    this.id = id;
    this.driver = driver;
  }

  protected id: string;
  public comp: Component = new Component;
  public rect: Rect = {
    left: 400,
    top: 300,
    right: 500,
    bottom: 400,
  };

  public async init(): Promise<Comp> {
    await this.driver.assertComponentExist(ON.id(this.id));
    this.comp = await this.driver.findComponent(ON.id(this.id));
    this.rect = await this.comp.getBounds();
    this.log.i(`Bounds refreshed: ${JSON.stringify(this.rect)}, cmopId: ${this.id}`);
    return this;
  }

  /**
   * 从左往右划
   * @returns
   */
  public async right(speed: number = SPEED_RAPIDLY): Promise<void> {
    this.log.i('swipe to right ' + this.id);
    await this.swipeSymmetry(0.1, Direction.Horizontal, speed);
  };

  public async initIndex(): Promise<void> {
    if (await this.driver.findComponent(ON.id(PageTitle.index))) {
      this.id = PageTitle.index;
      await this.init();
    }
  }

  /**
   * 从右往左划
   * 等价于 await bar.horizontal(0.9, 0.1);
   * @returns
   */
  public async left(speed: number = SPEED_RAPIDLY): Promise<void> {
    this.log.i('swipe to left ' + this.id);
    await this.swipeSymmetry(0.9, Direction.Horizontal, speed);
  };

  /**
   * 从下往上划
   * @returns
   */
  public async top(speed: number = SPEED_RAPIDLY): Promise<void> {
    this.log.i('swipe to top');
    await this.swipeSymmetry(0.7, Direction.Vertical, speed);
  };

  /**
   * 从上往下划
   * @returns
   */
  public async bottom(speed: number = SPEED_RAPIDLY): Promise<void> {
    this.log.i('swipe to bottom');
    await this.swipeSymmetry(0.3, Direction.Vertical, speed);
  };

  //拉出顶部状态菜单
  public async StatusBarMenu(direction: UiDirection.LEFT | UiDirection.RIGHT = UiDirection.RIGHT) {
      let rect: Component = await this.driver.findComponent( ON.id('sbg_right'));
    if (direction==UiDirection.LEFT) {
      let rect: Component = await this.driver.findComponent( ON.id('sbg_left'));
    }
    let sbgCenter:Point = await rect.getBoundsCenter();

    // const sbg_right: Point = this.topCornerMenu(direction);
    const downCorner: Point = this.GetCorner(direction, UiDirection.DOWN);
    this.log.i(direction + ' cornerMenu swipe');
    await this.dragBetween([sbgCenter,downCorner]);
  }

  //点击屏幕底部角落 唤起底部菜单
  public async bottomcorner(direction: UiDirection.LEFT | UiDirection.RIGHT = UiDirection.RIGHT) {
    const downCorner: Point = this.GetCorner(direction, UiDirection.DOWN);
    this.log.i(direction + ' corner point get');
    await this.driver.click(downCorner.x,downCorner.y);
  }

  public async horizontal(start: number, end: number, speed: number = SPEED_RAPIDLY): Promise<void> {
    const line = this.getRoutine(start, Direction.Horizontal, end);
    await this.swipeBetween(line, speed);
  }

  public async swipeSymmetry(startEnd: number, direction: Direction, speed: number = SPEED_RAPIDLY): Promise<void> {
    const line = this.getRoutine(startEnd, direction);
    await this.swipeBetween(line, speed);
  }

  protected getPoint(startEnd: number, direction: Direction, truncateY: number = 0.5): Point {
    let x = ratioAtLine(this.rect.left, this.rect.right, startEnd);
    let y = ratioAtLine(this.rect.top, this.rect.bottom, truncateY);
    if (direction === Direction.Vertical) {
      x = ratioAtLine(this.rect.left, this.rect.right, truncateY);
      y = ratioAtLine(this.rect.top, this.rect.bottom, startEnd);
    }
    this.log.i(`getPoint Bounds: ${JSON.stringify(this.rect)}, cmopId: ${this.id}`);
    this.log.i(`getPoint x: ${x}, startEnd: ${startEnd}`);
    return { x: Math.round(x), y: Math.round(y) };
  }

  public getRoutine(start: number, direction: Direction, end?: number): [Point, Point] {
    // start 应该在 0 到 1 的范围内
    expect(start < 0 || start > 1).assertFalse();
    end = end || (1 - start);
    return [this.getPoint(start, direction), this.getPoint(end, direction)];
  }

  protected async swipeBetween(startEnd: [Point, Point], speed: number = SPEED_QUICKLY): Promise<void> {
    this.log.i(`swipe ${startEnd[0].x}, ${startEnd[0].y}, ${startEnd[1].x}, ${startEnd[1].y}`);
    await this.driver.swipe(startEnd[0].x, startEnd[0].y, startEnd[1].x, startEnd[1].y, speed);
    await this.driver.delayMs(DELAY.double);
  }

  protected async dragBetween(startEnd: [Point, Point], speed: number = SPEED_QUICKLY): Promise<void> {
    this.log.i(`drag ${startEnd[0].x}, ${startEnd[0].y}, ${startEnd[1].x}, ${startEnd[1].y}`);
    await this.driver.drag(startEnd[0].x, startEnd[0].y, startEnd[1].x, startEnd[1].y, speed);
    await this.driver.delayMs(DELAY.default);
  }

  protected topCornerMenu(horizontal: UiDirection.LEFT | UiDirection.RIGHT, border: number = SIDES.edge): Point {
    this.log.i(horizontal + ' top corner menu get');
    return this.GetCorner(horizontal, UiDirection.UP, border);
  }

  protected GetCorner(horizontal?: UiDirection.LEFT | UiDirection.RIGHT,
    vertical?: UiDirection.UP | UiDirection.DOWN, border: number = SIDES.border): Point {
    let x = (this.rect.left + this.rect.right) * 0.5;
    switch (horizontal) {
      case UiDirection.RIGHT:
        x = this.rect.right - border;
        break;
      case UiDirection.LEFT:
        x = this.rect.left + border;
        break;
    }
    let y = (this.rect.top + this.rect.bottom) * 0.5;
    switch (vertical) {
      case UiDirection.DOWN:
        y = this.rect.bottom - border;
        break;
      case UiDirection.UP:
        y = this.rect.top + border;
        break;
    }
    return { x: Math.round(x), y: Math.round(y) };
  }
}

enum Direction {
  Vertical,
  Horizontal,
}

export function ratioAtLine(left: number, right: number, ratio: number): number {
  let x = left + (right - left) * ratio;
  return x;
}