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

import lazy { Log } from './Log';
import lazy display from '@ohos.display';
import lazy Curves from '@ohos.curves';
import lazy { Constants } from '../model/common/Constants';
import lazy { UiUtil } from '../utils/UiUtil';

/* instrument ignore file */
const TAG: string = 'common_GridAutoScrollerUtil';

export class GridAutoScrollerUtil {
  // 热区规范: 10mm转px
  private static readonly HOT_AREA_LENGTH: number =
    Math.round(this.getDensityDPI() * 10 / 25.4 / this.getDensityPixels());
  // 计算滚动速度: 贝塞尔曲线
  private static readonly SLIDE_SELECT_SPEED_CURVE: Curves.ICurve = Curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  // 计算滚动速度: 最大速度
  private static readonly AUTO_SPEED_MAX: number = Math.round(1600 / this.getDensityPixels());
  // 热区趋势阈值5vp
  private static readonly THRESHOLD: number = 5;
  private speedFlag: number = 0;
  private scrollerHeight: number = 0;
  private scrollerWidth: number = 0;
  private extraUpArea: number = 0;
  private extraDownArea: number = 0;
  private extraLeftArea: number = 0;
  private extraRightArea: number = 0;
  private oriGesturePosX: number = 0;
  private oriGesturePosY: number = 0;
  public isEntryFromHotAndNotScrolled: boolean = false;

  private static getDensityDPI(): number {
    try {
      return display.getDefaultDisplaySync().densityDPI;
    } catch (e) {
      Log.error(TAG, `getDensityDPI error, stack ${e?.stack}, code ${e?.code}`)
      return 1;
    }
  }

  private static getDensityPixels(): number {
    try {
      return display.getDefaultDisplaySync().densityPixels;
    } catch (e) {
      Log.error(TAG, `getDensityPixels error, stack ${e?.stack}, code ${e?.code}`)
      return 1;
    }
  }

  public autoscrollOrStop(scroller: Scroller, gesturePosY: number): void {
    let isIn: boolean = false;
    if (gesturePosY > this.extraUpArea && gesturePosY <= GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraUpArea) {
      if (!this.isEntryFromHotAndNotScrolled || this.isWantToAutoUp(gesturePosY)) {
        this.speedFlag = GridAutoScrollerUtil.SLIDE_SELECT_SPEED_CURVE
          .interpolate(1 - gesturePosY / (GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraUpArea));
        scroller.scrollEdge(Edge.Top, { velocity: this.speedFlag * GridAutoScrollerUtil.AUTO_SPEED_MAX });
        this.isEntryFromHotAndNotScrolled = false;
      }
      return;
    } else if (
      gesturePosY < this.scrollerHeight - this.extraDownArea &&
        gesturePosY >= this.scrollerHeight - this.extraDownArea - GridAutoScrollerUtil.HOT_AREA_LENGTH) {
      if (!this.isEntryFromHotAndNotScrolled || this.isWantToAutoDown(gesturePosY)) {
        this.speedFlag = GridAutoScrollerUtil.SLIDE_SELECT_SPEED_CURVE
          .interpolate(1 - (this.scrollerHeight - gesturePosY) /
            (GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraDownArea));
        scroller.scrollEdge(Edge.Bottom, { velocity: this.speedFlag * GridAutoScrollerUtil.AUTO_SPEED_MAX });
        this.isEntryFromHotAndNotScrolled = false;
      }
      return;
    }
    // 热区扩展区域:最大速度滚动
    if ((gesturePosY >= 0 && gesturePosY <= this.extraUpArea) || gesturePosY < 0) {
      scroller.scrollEdge(Edge.Top, { velocity: GridAutoScrollerUtil.AUTO_SPEED_MAX });
      isIn = true;
      this.isEntryFromHotAndNotScrolled = false;
    } else if ((gesturePosY <= this.scrollerHeight &&
      gesturePosY >= this.scrollerHeight - this.extraDownArea) || gesturePosY > this.scrollerHeight) {
      scroller.scrollEdge(Edge.Bottom, { velocity: GridAutoScrollerUtil.AUTO_SPEED_MAX });
      isIn = true;
      this.isEntryFromHotAndNotScrolled = false;
    }
    if (!isIn) {
      this.isEntryFromHotAndNotScrolled = false;
      scroller.scrollBy(0, 0);
    }
  }

  public autoscrollOrStopInHorizontalDirection(scroller: Scroller, gesturePosX: number): void {
    let isInHotExtraArea: boolean = false;
    if (gesturePosX > this.extraLeftArea && gesturePosX <= GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraLeftArea) {
      if (!this.isEntryFromHotAndNotScrolled || this.isWantToAutoLeft(gesturePosX)) {
        this.speedFlag = GridAutoScrollerUtil.SLIDE_SELECT_SPEED_CURVE
          .interpolate(1 - gesturePosX / (GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraLeftArea));
        scroller.scrollEdge(UiUtil.isMirrorMode() ? Edge.End : Edge.Start,
          { velocity: this.speedFlag * GridAutoScrollerUtil.AUTO_SPEED_MAX });
        this.isEntryFromHotAndNotScrolled = false;
      }
      return;
    } else if (gesturePosX < this.scrollerWidth - this.extraRightArea &&
      gesturePosX >= this.scrollerWidth - this.extraRightArea - GridAutoScrollerUtil.HOT_AREA_LENGTH) {
      if (!this.isEntryFromHotAndNotScrolled || this.isWantToAutoRight(gesturePosX)) {
        this.speedFlag = GridAutoScrollerUtil.SLIDE_SELECT_SPEED_CURVE
          .interpolate(1 - (this.scrollerWidth - gesturePosX) /
            (GridAutoScrollerUtil.HOT_AREA_LENGTH + this.extraRightArea));
        scroller.scrollEdge(UiUtil.isMirrorMode() ? Edge.Start : Edge.End,
          { velocity: this.speedFlag * GridAutoScrollerUtil.AUTO_SPEED_MAX });
        this.isEntryFromHotAndNotScrolled = false;
      }
      return;
    }
    // 热区扩展区域:最大速度滚动
    if (gesturePosX <= this.extraLeftArea) {
      scroller.scrollEdge(UiUtil.isMirrorMode() ? Edge.End : Edge.Start,
        { velocity: GridAutoScrollerUtil.AUTO_SPEED_MAX });
      isInHotExtraArea = true;
      this.isEntryFromHotAndNotScrolled = false;
    } else if (gesturePosX >= this.scrollerWidth - this.extraRightArea) {
      scroller.scrollEdge(UiUtil.isMirrorMode() ? Edge.Start : Edge.End,
        { velocity: GridAutoScrollerUtil.AUTO_SPEED_MAX });
      isInHotExtraArea = true;
      this.isEntryFromHotAndNotScrolled = false;
    }
    if (!isInHotExtraArea) {
      this.isEntryFromHotAndNotScrolled = false;
      scroller.scrollBy(0, 0);
    }
  }

  /**
   * 下热区有向下趋势,触发滚动; 阈值5vp
   * @returns
   */
  private isWantToAutoDown(gesturePosY: number): boolean {
    if (gesturePosY - this.oriGesturePosY > GridAutoScrollerUtil.THRESHOLD) {
      return true;
    }
    return false;
  }

  /**
   * 上热区有向上趋势,触发滚动; 阈值5vp
   * @returns
   */
  private isWantToAutoUp(gesturePosY: number): boolean {
    if (this.oriGesturePosY - gesturePosY > GridAutoScrollerUtil.THRESHOLD) {
      return true;
    }
    return false;
  }

  /**
   * 左热区有向左趋势,触发滚动; 阈值5vp
   *
   * @returns 是否有趋势
   */
  private isWantToAutoLeft(gesturePosX: number): boolean {
    if (this.oriGesturePosX - gesturePosX > GridAutoScrollerUtil.THRESHOLD) {
      return true;
    }
    return false;
  }

  /**
   * 右热区有向右趋势,触发滚动; 阈值5vp
   *
   * @returns 是否有趋势
   */
  private isWantToAutoRight(gesturePosX: number): boolean {
    if (gesturePosX - this.oriGesturePosX > GridAutoScrollerUtil.THRESHOLD) {
      return true;
    }
    return false;
  }

  public setScrollerHeight(height: number): void {
    Log.info(TAG, `scrollerHeight is ${height}`);
    this.scrollerHeight = height;
  }

  public getScrollerHeight(): number {
    return this.scrollerHeight;
  }

  public setScrollerWidth(width: number): void {
    Log.info(TAG, `ScrollerWidth is ${width}`);
    this.scrollerWidth = width;
  }

  /**
   * 根据横竖屏设置额外区域
   * @param isHorizontal 是否横屏
   */
  public setExtraAreaHeightByIsHorizontal(isHorizontal: boolean, actionBarHeight: number = 0,
    statusBarHeight: number = 0,
    upFlag: boolean = false, downFlag: boolean = false) {
    if (isHorizontal) {
      this.extraUpArea = actionBarHeight - statusBarHeight;
      this.extraDownArea = 0;
    } else {
      this.extraUpArea = actionBarHeight;
      this.extraDownArea = Constants.ToolBarHeight;
    }
    // 标题栏无沉浸式时，upFlag赋值为true
    if (upFlag) {
      this.extraUpArea = 0;
    }
    // toolBar无模糊时，downFlag赋值为true
    if (downFlag) {
      this.extraDownArea = 0;
    }
  }

  /**
   * 根据横竖屏设置水平方向额外区域
   */
  public setExtraAreaWidth() {
    this.extraLeftArea = 0;
    this.extraRightArea = 0;
  }

  public initIsEntryFromHotAndNotScrolled(gesturePosY: number): void {
    this.isEntryFromHotAndNotScrolled = false;
    this.oriGesturePosY = gesturePosY;
    if (gesturePosY < this.extraUpArea || gesturePosY > this.scrollerHeight - this.extraDownArea) {
      return;
    }
    if (gesturePosY < this.extraUpArea + GridAutoScrollerUtil.HOT_AREA_LENGTH ||
      gesturePosY > this.scrollerHeight - this.extraDownArea - GridAutoScrollerUtil.HOT_AREA_LENGTH) {
      this.isEntryFromHotAndNotScrolled = true;
    }
  }

  public initIsEntryFromHotAndNotScrolledInHorizontalDirection(gesturePosX: number): void {
    this.isEntryFromHotAndNotScrolled = false;
    this.oriGesturePosX = gesturePosX;
    if (gesturePosX < this.extraLeftArea || gesturePosX > this.scrollerWidth - this.extraRightArea) {
      return;
    }
    if (gesturePosX < this.extraLeftArea + GridAutoScrollerUtil.HOT_AREA_LENGTH ||
      gesturePosX > this.scrollerWidth - this.extraRightArea - GridAutoScrollerUtil.HOT_AREA_LENGTH) {
      this.isEntryFromHotAndNotScrolled = true;
    }
  }
}