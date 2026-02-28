// instrument ignore file
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
import { HiLog } from '../../../../common/util/HiLog';
import { Position } from '../../../../common/util/PositionUtil';
import { Rectangle } from '../../../../common/util/types';
import { Constants, ResizeDirectionEdit, TouchMoveType } from '../util/Const';
import { TextAreaInfo } from './TextAreaInfo';
import vibrator from '@ohos.vibrator';
import { BusinessError } from '@ohos.base';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { Point } from '../../../../common/util/PointUtil';

const TAG = 'TextInputData';

@Observed
export class TextInputData {
  public x: number = 0;
  public y: number = 0;
  public height: number = Constants.DEFAULT_TEXTAREA_HEIGHT;
  public dpiRatio: number = 1;
  public iconSize: number = 24;
  public moveType: number = TouchMoveType.DEFAULT;
  private startX: number = 0;
  private startY: number = 0;
  private startDisplayX: number = 0;
  private startDisplayY: number = 0;
  /**
   * 触摸事件开始时，记录的文本框原始位置
   */
  private oriContentLocationX: number = 0;
  private oriContentLocationY: number = 0;
  /**
   * 触摸事件开始时，记录文本框原始的高和宽
   */
  private oriWidth: number = 0;
  private oriHeight: number = 0;
  public isChange: boolean = false;
  /**
   * 显示高度，可比实际高度高
   */
  public heightShow: number = Constants.DEFAULT_TEXTAREA_HEIGHT;
  private currentDisplayX: number = 0;
  private currentDisplayY: number = 0;
  public angle: number = 0;
  public globalScale: number = 1;
  public localScale: number = 1;
  public widthLeftIncrementHist: number = 0;
  /**
   * 宽度左增量
   */
  public widthLeftIncrement: number = 0;
  public heightTopIncrementHist: number = 0;
  /**
   * 高度上增量
   */
  public heightTopIncrement: number = 0;
  /**
   * 进入编辑时，文本初始宽高
   */
  public startEditWidth: number = 0;
  public startEditHeight: number = 0;
  public rotateTrans: number = 34; // 旋转图标长度
  public moveTouchStartX: number = 0; // 手指初始位置坐标x，相对于原始坐标
  public moveTouchStartY: number = 0; // 手指初始位置坐标y，相对于原始坐标
  public minHeight: number = Constants.DEFAULT_TEXTAREA_HEIGHT;
  public topBottomPadding = 30;
  public topBottomPaddingForPad = 34;
  /**
   * 是否为新创建的文本框。
   * 默认不是，通过ElementSelectState.ADD添加时，将值改成true，其它场景不要修改。当文本框移动或缩放，则改成false。
   * 文本框默认最大宽度是画布宽度。但新创建的文本框输入文字时，不能超出画布边界，用该变量做区分。
   */
  public isNewTextView: boolean = false;
  public isOuterPage: boolean = false;
  public rotateIconHeight: number = 20;
  // 角度吸附的振动状态
  public vibrationsStatus: boolean = false;

  public dealDownEvent(event: TouchEvent, oriHeight: number, textArea: TextAreaInfo) {
    /* instrument ignore if */
    if (!event || event.touches.length <= 0) {
      return;
    }
    this.startX = event.touches[0].x;
    this.startY = event.touches[0].y;
    this.startDisplayX = event.touches[0].displayX;
    this.startDisplayY = event.touches[0].displayY;
    this.oriContentLocationX = this.x;
    this.oriContentLocationY = this.y;
    this.oriWidth = textArea.width;
    this.oriHeight = this.height;
    this.isChange = false;
    this.moveType = TouchMoveType.DEFAULT;
    this.setTouchMoveStyle(textArea);
  }

  private areaIsResize(textArea: TextAreaInfo): boolean {
    /* instrument ignore if */
    if (this.startX >= textArea.width - this.iconSize && this.startY >= this.heightShow - this.iconSize) {
      return true;
    }
    return false;
  }

  private setTouchMoveStyle(textArea: TextAreaInfo) {
    if (this.areaIsResize(textArea)) {
      this.moveType = TouchMoveType.RESIZE;
    } else {
      this.moveType = TouchMoveType.MOVE;
    }
  }

  public dealUpEvent() {
    this.widthLeftIncrementHist += this.widthLeftIncrement;
    this.heightTopIncrementHist += this.heightTopIncrement;
    this.widthLeftIncrement = 0;
    this.heightTopIncrement = 0;
  }

  /**
   *  获取移动后的x和y的偏移量
   * @param event 事件
   * @param scaleValue 实时缩放值
   * @returns Point
   */
  public getPositionOffset(event: TouchEvent, scaleValue: number): Point {
    this.currentDisplayX = event.touches[0].displayX;
    this.currentDisplayY = event.touches[0].displayY;
    let offsetX = ((this.currentDisplayX - this.startDisplayX) / this.globalScale) / scaleValue;
    let offsetY = ((this.currentDisplayY - this.startDisplayY) / this.globalScale) / scaleValue;
    return {
      x: offsetX,
      y: offsetY,
    } as Point;
  }

  public dealMoveEvent(event: TouchEvent, moveType: TouchMoveType, resizeDirection: ResizeDirectionEdit,
    scaleValue: number, paintViewHeight: number, textArea: TextAreaInfo) {
    /* instrument ignore if */
    if (!event) {
      return;
    }
    this.currentDisplayX = event.touches[0].displayX;
    this.currentDisplayY = event.touches[0].displayY;
    let offsetX = ((this.currentDisplayX - this.startDisplayX) / this.globalScale) / scaleValue;
    let offsetY = ((this.currentDisplayY - this.startDisplayY) / this.globalScale) / scaleValue;
    if (moveType == TouchMoveType.MOVE) {
      this.isNewTextView = false;
      this.areaMove(offsetX, offsetY);
    } else if (moveType == TouchMoveType.RESIZE) {
      /* instrument ignore if */
      if ((resizeDirection === ResizeDirectionEdit.BOTTOM_RIGHT ||
        resizeDirection === ResizeDirectionEdit.BOTTOM_LEFT) &&
        offsetY > 0 && this.height >= Constants.TEXT_MAX_HEIGHT) {
        return;
      }
      if ((resizeDirection === ResizeDirectionEdit.TOP_LEFT ||
        resizeDirection === ResizeDirectionEdit.TOP_RIGHT) &&
        offsetY < 0 && this.height >= Constants.TEXT_MAX_HEIGHT) {
        return;
      }
      this.isNewTextView = false;
      this.areaResize(resizeDirection, offsetX, offsetY, textArea);
    } else {
      HiLog.i(TAG, `dealMoveEvent undefined move type: ${moveType}}`)
    }
  }

  public areaMove(offsetX: number, offsetY: number) {
    this.x = this.oriContentLocationX + offsetX;
    this.y = this.oriContentLocationY + offsetY;
  }

  private areaResize(resizeDirection: ResizeDirectionEdit, offsetX: number, offsetY: number, textArea: TextAreaInfo) {
    this.setResizeTextLocation(resizeDirection, offsetX, offsetY, textArea);
  }

  /**
   * 设置缩放后文本框的坐标。注意，文本框缩放会收到文本框最大/最小尺寸限制。（最大尺寸规格未定，后续补充）
   *
   * @param resizeDirection 修改尺寸的方向
   * @param offsetX X的的变化量
   * @param offsetY Y的变化量
   */
  /* instrument ignore next */
  private setResizeTextLocation(resizeDirection: ResizeDirectionEdit, offsetX: number, offsetY: number,
    textArea: TextAreaInfo) {
    const dx = (offsetX * Math.cos(this.radian) + offsetY * Math.sin(this.radian)) * this.localScale;
    const dy = (-offsetX * Math.sin(this.radian) + offsetY * Math.cos(this.radian)) * this.localScale;

    let wordHeight = this.calWordHeight(textArea);

    switch (resizeDirection) {
      case ResizeDirectionEdit.TOP_LEFT: {
        textArea.width = Math.max(Math.min(this.oriWidth - dx, this.getTextMaxWidth()), this.getTextMinWidth());
        this.height = Math.max(this.oriHeight - dy, this.getTextMinHeight(), wordHeight);

        let resizeLocationX = this.oriContentLocationX + dx;
        let maxLocationX = this.oriContentLocationX + (this.oriWidth - this.getTextMinWidth()) * this.localScale;
        let minLocationX = this.oriContentLocationX + (this.oriWidth - this.getTextMaxWidth()) * this.localScale;
        this.x = Math.max(Math.min(resizeLocationX, maxLocationX), minLocationX);

        let resizeLocationY = this.oriContentLocationY + dy;
        let maxLocationY = this.oriContentLocationY + (this.oriHeight - this.height) * this.localScale;
        let minLocationY = this.oriContentLocationY + (this.oriHeight - this.getTextMaxHeight()) * this.localScale;
        this.y = Math.max(Math.min(resizeLocationY, maxLocationY), minLocationY);
        break;
      }
      case ResizeDirectionEdit.TOP_RIGHT: {
        textArea.width = Math.max(Math.min(this.oriWidth + dx, this.getTextMaxWidth()), this.getTextMinWidth());
        this.height = Math.max(this.oriHeight - dy, this.getTextMinHeight(), wordHeight);

        let resizeLocationY = this.oriContentLocationY + dy;
        let maxLocationY = this.oriContentLocationY + (this.oriHeight - this.height) * this.localScale;
        let minLocationY = this.oriContentLocationY + (this.oriHeight - this.getTextMaxHeight()) * this.localScale;
        this.y = Math.max(Math.min(resizeLocationY, maxLocationY), minLocationY);
        break;
      }
      case ResizeDirectionEdit.BOTTOM_RIGHT: {
        textArea.width = Math.max(Math.min(this.oriWidth + dx, this.getTextMaxWidth()), this.getTextMinWidth());
        this.height = Math.max(this.oriHeight + dy, this.getTextMinHeight(), wordHeight);
        break;
      }
      case ResizeDirectionEdit.BOTTOM_LEFT: {
        textArea.width = Math.max(Math.min(this.oriWidth - dx, this.getTextMaxWidth()), this.getTextMinWidth());
        this.height = Math.max(this.oriHeight + dy, this.getTextMinHeight(), wordHeight);

        let resizeLocationX = this.oriContentLocationX + dx;
        let maxLocationX = this.oriContentLocationX + (this.oriWidth - this.getTextMinWidth()) * this.localScale;
        let minLocationX = this.oriContentLocationX + (this.oriWidth - this.getTextMaxWidth()) * this.localScale;
        this.x = Math.max(Math.min(resizeLocationX, maxLocationX), minLocationX);
        break;
      }
      default: {
        HiLog.e(TAG, `setResizeTextLocation unknown direction: ${resizeDirection}`)
      }
    }
  }

  public calWordHeight(textArea: TextAreaInfo) {
    let manager: LayoutManager = textArea.richEditorController.getLayoutManager();
    /* instrument ignore if */
    if (manager === undefined) {
      HiLog.e(TAG, `calWordHeight manager is undefined`);
      return Constants.DEFAULT_TEXTAREA_HEIGHT;
    }
    let lineCount = manager.getLineCount();
    /* instrument ignore if */
    if (lineCount <= 0) {
      return Constants.DEFAULT_TEXTAREA_HEIGHT;
    }
    let height = 0;
    for (let i = 0; i < lineCount; i++) {
      let metrics: LineMetrics = manager.getLineMetrics(i);
      height = Math.max(height, metrics.height);
    }
    // 不同设备底层引擎实际单位的值不同
    let curPadding = DeviceUtil.isPad() ? this.topBottomPaddingForPad : this.topBottomPadding;
    let wordHeight = px2vp(height) * lineCount + curPadding;
    HiLog.i(TAG, `calWordHeight: lineCount:${lineCount}, wordHeight:${wordHeight}`);
    return wordHeight;
  }

  /**
   * 获取文本当前旋转弧度
   * @returns
   */
  private get radian() {
    return this.angle / 180 * Math.PI;
  }

  /* instrument ignore next */
  private setResizeTextSize(resizeDirection: ResizeDirectionEdit, offsetX: number, offsetY: number) {
    let resizeWidth = 0;
    let resizeHeight = 0;
    const dX = offsetX * Math.cos(this.radian) + offsetY * Math.sin(this.radian);
    const dY = -offsetX * Math.sin(this.radian) + offsetY * Math.cos(this.radian);
    switch (resizeDirection) {
      case ResizeDirectionEdit.TOP_LEFT: {
        resizeWidth = this.oriWidth - dX;
        resizeHeight = this.oriHeight - dY;
        break;
      }
      case ResizeDirectionEdit.TOP_RIGHT: {
        // 右上角缩放不影响文本框位置X值，故需要重新计算宽度
        resizeWidth = this.oriWidth + dX;
        resizeHeight = this.oriHeight - dY;
        break;
      }
      case ResizeDirectionEdit.BOTTOM_RIGHT: {
        // 右下角缩放不影响文本框位置X, Y值，故需要重新计算宽度
        resizeWidth = this.oriWidth + dX;
        resizeHeight = this.oriHeight + dY;
        break;
      }
      case ResizeDirectionEdit.BOTTOM_LEFT: {
        resizeWidth = this.oriWidth - dX;
        // 左下角缩放不影响文本框位置Y值，故需要重新计算宽度
        resizeHeight = this.oriHeight + dY;
        break;
      }
      default: {
        HiLog.e(TAG, `setResizeTextSize unknown direction: ${resizeDirection}`)
      }
    }
  }

  /**
   * 获取文本框最大宽度
   *
   * @returns 文本框最大宽度。
   */
  public getTextMaxWidth(): number {
    return Constants.TEXT_MAX_WIDTH;
  }

  /**
   * 获取文本框最大高度
   *
   * @returns 文本框最大高度
   */
  public getTextMaxHeight(): number {
    return Constants.TEXT_MAX_HEIGHT;
  }

  /**
   * 获取文本框最小宽度
   *
   * @returns 文本框最小宽度
   */
  public getTextMinWidth(): number {
    return Constants.DEFAULT_TEXTAREA_WIDTH;
  }

  /**
   * 获取文本框最小高度
   *
   * @returns 文本框最小高度
   */
  public getTextMinHeight(): number {
    return Constants.DEFAULT_TEXTAREA_HEIGHT * this.dpiRatio;
  }

  /**
   * 获取文本实际x坐标
   * @returns
   */
  public getRealPositionX(initPositionX: number, width: number, maxWidth: number, scaleValueX: number): number {
    let resultX = initPositionX + this.getScaledStartPositionX() + this.oriCenterBorderHorizontalDist -
      this.oriCenterCornerDist * Math.cos(this.radianOfOriCenterCorner)
    width = scaleValueX * width;
    if (width >= maxWidth) {
      /* instrument ignore if */
      if (resultX + width - Constants.MENU_BOX_DIFFERENCE_VALUE <= 0) {
        return -width + Constants.MENU_BOX_DIFFERENCE_VALUE;
      }
      /* instrument ignore if */
      if (resultX + Constants.DEFAULT_TEXTAREA_HEIGHT * scaleValueX +
      Constants.MENU_BOX_DIFFERENCE_VALUE >= maxWidth) {
        return maxWidth - Constants.DEFAULT_TEXTAREA_HEIGHT * scaleValueX -
        Constants.MENU_BOX_DIFFERENCE_VALUE;
      }
      return resultX;
    }
    /* instrument ignore if */
    if (resultX + width / 2 + Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX <= 0) {
      return -width / 2 - Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX;
    }
    /* instrument ignore if */
    if (resultX + width / 2 + Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX >= maxWidth) {
      return maxWidth - width / 2 - Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX;
    }
    return resultX;
  }

  public isBottomEdge(initPositionY: number, height: number, maxHeight: number): boolean {
    let resultY = initPositionY + this.getScaledStartPositionY() + this.oriCenterBorderVerticalDist -
      this.oriCenterCornerDist * Math.sin(this.radianOfOriCenterCorner);
    if (resultY + height / 2 > maxHeight) {
      return true;
    }
    return false;
  }

  /* instrument ignore if */
  public isRightEdge(initPositionX: number, width: number, maxWidth: number, scaleValueX: number): boolean {
    let resultX = initPositionX + this.getScaledStartPositionX() + this.oriCenterBorderHorizontalDist -
      this.oriCenterCornerDist * Math.cos(this.radianOfOriCenterCorner)
    if (resultX + width / 2 + Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX > maxWidth) {
      return true;
    }
    return false;
  }

  /**
   * 获取文本初始中心点与左上角顶点的连线与x轴的夹角
   * @returns
   */
  /* instrument ignore if */
  private get radianOfOriCenterCorner() {
    if (!this.oriCenterBorderHorizontalDist) {
      return -Math.PI / 2 + this.radian;
    }
    return Math.atan(this.oriCenterBorderVerticalDist / this.oriCenterBorderHorizontalDist) + this.radian;
  }

  /**
   * 获取文本缩放后的原始x坐标
   * @returns
   */
  private getScaledStartPositionX() {
    return this.x - this.startEditWidth * (this.localScale - 1) / 2;
  }

  /**
   * 获取文本缩放后的初始中心点左边距
   * @returns
   */
  private get oriCenterBorderHorizontalDist() {
    return this.scaledStartWidth / 2 + (this.widthLeftIncrementHist + this.widthLeftIncrement) * this.localScale;
  }

  /**
   * 文本缩放后起始宽度
   */
  private get scaledStartWidth() {
    return this.startEditWidth * this.localScale;
  }

  /**
   * 获取文本缩放后的初始中心点至左上角距离
   * @returns
   */
  private get oriCenterCornerDist() {
    const sign = (this.oriCenterBorderHorizontalDist >= 0 ? 1 : -1);
    return sign *
    Math.sqrt(Math.pow(this.oriCenterBorderHorizontalDist, 2) + Math.pow(this.oriCenterBorderVerticalDist, 2));
  }

  /**
   * 获取文本缩放后的初始中心点上边距
   * @returns
   */
  private get oriCenterBorderVerticalDist() {
    return this.scaledStartHeight / 2 + (this.heightTopIncrementHist + this.heightTopIncrement) * this.localScale;
  }

  /**
   * 文本缩放后起始高度
   */
  private get scaledStartHeight() {
    return this.startEditHeight * this.localScale;
  }

  /**
   * 获取文本实际y坐标
   * @returns
   */
  public getRealPositionY(initPositionY: number, height: number, maxHeight: number, scaleValueY: number): number {
    let resultY = initPositionY + this.getScaledStartPositionY() + this.oriCenterBorderVerticalDist -
      this.oriCenterCornerDist * Math.sin(this.radianOfOriCenterCorner);
    height = scaleValueY * height;
    /* instrument ignore if */
    if (height >= maxHeight) {
      if (resultY + height - Constants.MENU_BOX_DIFFERENCE_VALUE <= 0) {
        return -height + Constants.MENU_BOX_DIFFERENCE_VALUE;
      }
      if (resultY + Constants.MENU_BOX_DIFFERENCE_VALUE >= maxHeight) {
        return maxHeight - Constants.MENU_BOX_DIFFERENCE_VALUE;
      }
      return resultY;
    }
    /* instrument ignore if */
    if (resultY + height / 2 <= 0) {
      return -height / 2;
    }
    /* instrument ignore if */
    if (resultY + height / 2 >= maxHeight) {
      return maxHeight - height / 2;
    }
    return resultY;
  }

  /**
   * 获取文本缩放后的原始y坐标
   */
  private getScaledStartPositionY() {
    return this.y - this.startEditHeight * (this.localScale - 1) / 2;
  }

  /* instrument ignore next */
  public areaRotate(touchEvt: TouchEvent, textArea: TextAreaInfo) {
    let degree =
      this.getRotateDegree(this.moveTouchStartX, this.moveTouchStartY, touchEvt.touches[0].x, touchEvt.touches[0].y,
        textArea)
    if (degree != 0) {
      degree = Number((degree).toFixed(2));
      this.moveTouchStartX = touchEvt.touches[0].x;
      this.moveTouchStartY = touchEvt.touches[0].y;
      this.angle = (degree + this.angle) % 360;
      if (this.angle >= 90 - Constants.ADSORPTION_ANGLE && this.angle <= 90 + Constants.ADSORPTION_ANGLE) {
        this.Vibrations(this.vibrationsStatus);
        return;
      }
      if ((this.angle >= 360 - Constants.ADSORPTION_ANGLE && this.angle < 360) ||
        (this.angle >= 0 && this.angle < Constants.ADSORPTION_ANGLE)) {
        this.Vibrations(this.vibrationsStatus);
        return;
      }
      if (this.angle >= 180 - Constants.ADSORPTION_ANGLE && this.angle <= 180 + Constants.ADSORPTION_ANGLE) {
        this.Vibrations(this.vibrationsStatus);
        return;
      }
      if (this.angle >= 270 - Constants.ADSORPTION_ANGLE && this.angle <= 270 + Constants.ADSORPTION_ANGLE) {
        this.Vibrations(this.vibrationsStatus);
        return;
      }
      this.vibrationsStatus = false;
    }
  }

  /**
   * 获取旋转角度
   *
   * @param rect 矩形区域
   * @param lastMovePoint 上一个点
   * @param curMovePoint 当前移动的点
   * @returns 旋转角度
   */
  public getRotateDegree(lastMovePointX: number, lastMovePointY: number, curMovePointX: number,
    curMovePointY: number, textArea: TextAreaInfo): number {
    const centerX = textArea.width / 2;
    const centerY = this.minHeight / 2
    const cLength: number = Math.hypot(lastMovePointX - centerX, lastMovePointY - centerY);
    const bLength: number = Math.hypot(curMovePointX - centerX, curMovePointY - centerY);
    const aLength: number = Math.hypot(curMovePointX - lastMovePointX, curMovePointY - lastMovePointY);
    let cosA: number = (bLength * bLength + cLength * cLength - aLength * aLength) / (2 * bLength * cLength);
    /* instrument ignore if */
    if (cosA < -1) {
      cosA = -1;
    }
    if (cosA > 1) {
      cosA = 1;
    }
    const radian: number = Math.acos(cosA);
    const degree: number = radian / Math.PI * 180;
    const vectorA2BX: number = lastMovePointX - centerX;
    const vectorA2BY: number = lastMovePointY - centerY;
    const vectorA2CX: number = curMovePointX - centerX;
    const vectorA2CY: number = curMovePointY - centerY;
    const magnitude: number = vectorA2BX * vectorA2CY - vectorA2CX * vectorA2BY;
    return magnitude < 0 ? 360 - degree : degree;
  }

  public touchStart(touchEvt: TouchEvent) {
    /* instrument ignore if */
    if (!touchEvt) {
      return;
    }
    this.moveTouchStartX = touchEvt.touches[0].x;
    this.moveTouchStartY = touchEvt.touches[0].y;
  }

  /**
   * 获取三角函数sin值
   * @param vAngle 旋转角度
   * @returns 三角函数sin值
   */
  public getSinValue(vAngle: number): number {
    return Math.round(Math.sin((vAngle * Math.PI / 180)) * 1000000) / 1000000;
  }

  /**
   * 获取三角函数cos值
   * @param vAngle 旋转角度
   * @returns 三角函数cos值
   */
  public getCosValue(vAngle: number): number {
    return Math.round(Math.cos((vAngle * Math.PI / 180)) * 1000000) / 1000000;
  }

  /**
   * 获取外接矩形
   * @param width 宽度
   * @param height 高度
   * @param x x坐标
   * @param y y坐标
   * @param vAngle 旋转角度
   * @returns 外接矩形
   */
  public getInscribedRect(width: number, height: number, x: number, y: number, vAngle: number): Rectangle {
    let centerX = x + width / 2;
    let centerY = y + height / 2;

    // 按照A-B-C-D顺序计算
    let outAX = centerX - this.getCosValue(vAngle) * width / 2 - this.getSinValue(vAngle) * height / 2;
    let outAY = centerY + this.getSinValue(vAngle) * width / 2 - this.getCosValue(vAngle) * height / 2;

    let outBX = centerX + this.getCosValue(vAngle) * width / 2 - this.getSinValue(vAngle) * height / 2;
    let outBY = centerY - this.getSinValue(vAngle) * width / 2 - this.getCosValue(vAngle) * height / 2;

    let outCX = centerX + this.getCosValue(vAngle) * width / 2 + this.getSinValue(vAngle) * height / 2;
    let outCY = centerY - this.getSinValue(vAngle) * width / 2 + this.getCosValue(vAngle) * height / 2;

    let outDX = centerX - this.getCosValue(vAngle) * width / 2 + this.getSinValue(vAngle) * height / 2;
    let outDY = centerY + this.getSinValue(vAngle) * width / 2 + this.getCosValue(vAngle) * height / 2;

    let minX = Math.min(outAX, outBX, outCX, outDX);
    let maxX = Math.max(outAX, outBX, outCX, outDX);
    let minY = Math.min(outAY, outBY, outCY, outDY);
    let maxY = Math.max(outAY, outBY, outCY, outDY);

    return new Rectangle(minX, minY, maxX, maxY);
  }

  private getMenuOffX(textArea: TextAreaInfo, menuWidth: number, realPositionX: number, scaleValueX: number,
    paintViewWidth: number): number {
    let menuOffX = 0;
    /* instrument ignore if */
    if (textArea.width <= menuWidth) {
      // 屏幕左边界
      if (realPositionX - Constants.MIN_MENU_TO_SCREEN <= 0) {
        return -realPositionX + Constants.MIN_MENU_TO_SCREEN;
      }
      // 屏幕右边界
      if (realPositionX + menuWidth * scaleValueX + Constants.MIN_MENU_TO_SCREEN >= paintViewWidth) {
        return -(realPositionX + menuWidth * scaleValueX + Constants.MIN_MENU_TO_SCREEN - paintViewWidth);
      }
    } else {
      if (realPositionX + ((textArea.width - menuWidth) / 2) * scaleValueX +
        Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX -
      Constants.MIN_MENU_TO_SCREEN <= 0) {
        return -realPositionX +
          ((menuWidth * scaleValueX - textArea.width * scaleValueX) / 2 - Constants.MIN_MENU_TO_SCREEN) +
          Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX;
      }
      let width = realPositionX + ((textArea.width - menuWidth) / 2) * scaleValueX + menuWidth * scaleValueX +
        Constants.MENU_BOX_DIFFERENCE_VALUE * scaleValueX + Constants.MIN_MENU_TO_SCREEN
      if (width >= paintViewWidth) {
        return paintViewWidth - width;
      }
    }
    return menuOffX;
  }

  public refreshMenuPosition(textArea: TextAreaInfo, paintViewWidth: number, paintViewHeight: number,
    positionX: number, positionY: number, menuWidth: number, scaleValueX: number, scaleValueY: number): Point {
    let realPositionX = this.getRealPositionX(positionX, textArea.width, paintViewWidth, scaleValueX);
    let realPositionY = this.getRealPositionY(positionY, this.minHeight, paintViewHeight, scaleValueY);
    let rectangle =
      this.getInscribedRect(textArea.width, this.minHeight, realPositionX, realPositionY, this.angle);
    let menuOffX = this.getMenuOffX(textArea, menuWidth, realPositionX, scaleValueX, paintViewWidth);
    let menuOffY = 0;
    /* instrument ignore if */
    if (rectangle.top <=
      (Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT + Constants.DEFAULT_TEXTAREA_TOP_MENU_MARGIN)) {
      this.isOuterPage = true;
      menuOffY = rectangle.bottom - realPositionY - this.minHeight + 12;
    } else {
      this.isOuterPage = false;
      menuOffY = realPositionY - rectangle.top;
    }
    let sinValue = this.getSinValue(this.angle);
    /* instrument ignore if */
    if (this.angle >= 220 && this.angle < 320) {
      menuOffY = menuOffY + Constants.rotateIconWidth * (-sinValue);
    }
    /* instrument ignore if */
    if (this.isOuterPage && this.angle >= 35 && this.angle < 135) {
      menuOffY = menuOffY + Constants.rotateIconWidth * (sinValue);
    }
    return {
      x: menuOffX / scaleValueX,
      y: menuOffY / scaleValueY,
    } as Point;
  }


  /**
   * 吸附角度的振动
   */
  Vibrations(vibrationsStatus: boolean) {
    /* instrument ignore if */
    if (vibrationsStatus) {
      return;
    }
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: 'haptic.slide',
        count: 1,
      }, {
        id: 0,
        usage: 'alarm',
      }, (error: BusinessError) => {
        /* instrument ignore if */
        if (error) {
          HiLog.e(TAG, `TextInputData error code=${error.code},message=${error.message}`);
          return;
        }
        console.info('TextInputData Succeed in starting vibration');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      HiLog.e(TAG, `TextInputData An unexpected error occurred. code=${e.code},message=${e.message}`);
    }
    this.vibrationsStatus = true;
  }
}
