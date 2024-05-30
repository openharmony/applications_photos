/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { BroadCast, Constants, Log } from '@ohos/common';

const TAG: string = 'editor_PcCropRulerBar';

/**
 * 天枢PC图库编辑使用的角度调节尺工具栏
 */
@Component
export struct PcCropRulerBar {
  @Consume broadCast: BroadCast;
  @State cWidth: number = 250;
  @State cHeight: number = 57;
  private currentDef: number = 0;
  private startPos: number = 0;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private resetClicked: Function = (): void => {};
  private previous: number = 0;
  private rulerLength: number = 0
  private rulerWidth: number = 0
  private isVerticalScreen: boolean = true;
  private rulerDrawHeight = 24;

  iniSize() {
    this.rulerLength = this.cWidth
    this.rulerWidth = this.cHeight
  }

  multiScreenAdaptation() {
    if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_1) {
      this.context.font = Constants.RULER_CONTEXT_FONT_10PX
    } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_2) {
      this.context.font = Constants.RULER_CONTEXT_FONT_20PX
    } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_3) {
      this.context.font = Constants.RULER_CONTEXT_FONT_30PX
    } else {
      this.context.font = Constants.RULER_CONTEXT_FONT_20PX
    }
  }

  drawMidLine() {
    // 中点
    const midX= Math.floor(this.rulerLength / Constants.NUMBER_2);
    this.context.beginPath();
    this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
    this.context.strokeStyle = Constants.RULER_FILL_STYLE_100;
    this.context.lineCap = 'round';

    this.context.lineWidth = Constants.MID_LINE_WIDTH;
    this.context.moveTo(midX, this.rulerDrawHeight - Constants.EDITOR_LARGE_TICK_LINE_HEIGHT);
    this.context.lineTo(midX, this.rulerDrawHeight - Constants.NUMBER_1);

    this.context.stroke();
    this.context.closePath();
  }

  drawIntegerLine(curX: number, curNum: number) {
    this.context.moveTo(curX, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
    this.context.shadowBlur = Constants.RULER_LINE_WIDTH
    this.context.lineCap = 'round';
    if (Math.round(curNum) != Math.round(this.currentDef) && Math.round(curNum) == 0) {
      this.context.textBaseline = 'bottom'
      this.context.font = Constants.RULER_CONTEXT_FONT_25PX;
      this.context.fillText(curNum.toString(), curX, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
    }
    this.context.lineTo(curX, this.rulerDrawHeight);

  }

  drawLine() {
    // 起始绘制位置
    let beginNum: number = this.currentDef - (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
    let endNum: number = this.currentDef + (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
    let curX = 0;
    let curNum = 0;
    const scaleLen = Math.ceil((this.rulerLength) / Constants.NUMBER_5) + Constants.NUMBER_1;
    for (let i = 0; i < scaleLen; i++) {
      curNum = beginNum + i;
      this.context.beginPath();
      this.multiScreenAdaptation();
      this.context.textAlign = 'center';

      // 设置默认线型
      this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
      this.context.fillStyle = Constants.RULER_FILL_STYLE_40;

      // 边缘第三根线
      if (curNum <= (beginNum + Constants.NUMBER_3) || curNum >= (endNum - Constants.NUMBER_3)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_30;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_30;
      }

      // 次边缘的线
      if (curNum <= (beginNum + Constants.NUMBER_2) || curNum >= (endNum - Constants.NUMBER_2)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_20;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_20;
      }
      // 最边缘的线
      if (curNum <= (beginNum + Constants.NUMBER_2) || curNum >= (endNum - Constants.NUMBER_2)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_10;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_10;
      }

      // 标尺0与当前数值之间的白色竖线
      if ((curNum < this.currentDef && curNum >= 0) || (curNum > this.currentDef && curNum <= 0)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_100;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
      }

      // 设置线宽
      this.context.shadowBlur = 0;
      this.context.lineCap = 'round';
      curX = i * Constants.NUMBER_5
      if (curX == 0 || curX == this.rulerLength) {
        // 边界位置刻度线宽度为一半
        this.context.lineWidth = (Constants.RULER_LINE_WIDTH / Constants.NUMBER_2);
        if (curX < 0) {
          curX = 0;
        }
      } else {
        this.context.lineWidth = Constants.RULER_LINE_WIDTH;
      }

      // 绘制刻度线
      if (Math.abs(curNum) % Constants.NUMBER_10 === 0) {
        // 每隔10个刻度绘制一个中刻度线
        this.drawIntegerLine(curX, curNum)
      } else if ((curNum < this.currentDef && curNum >= 0) || (curNum > this.currentDef && curNum <= 0)) {
        // 0和当前刻度之间的线
        this.context.moveTo(curX, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
        this.context.lineTo(curX, this.rulerDrawHeight);
      } else {
        // 其他短刻度线
        this.context.moveTo(curX, this.rulerDrawHeight - Constants.EDITOR_SMALL_TICK_LINE_HEIGHT);
        this.context.lineTo(curX, this.rulerDrawHeight);
      }
      this.context.stroke();
      this.context.closePath();
    }
  }

  onTouchEvent(event: TouchEvent): void {
    let axis = this.isVerticalScreen ? 'x' : 'y';
    if (event.type === TouchType.Down) {
      this.startPos = event.touches[0][axis];
      this.previous = new Date().getTime();
    }
    if (event.type !== TouchType.Move) {
      return;
    }
    let now = new Date().getTime();
    if (now - this.previous < Constants.TIMEOUT) {
      return;
    }
    this.previous = now;
    let dir = this.startPos - event.touches[0][axis];
    if (Math.abs(dir / 5) < 1) {
      return;
    }
    this.currentDef += Number.parseInt((dir / 5).toFixed(0));
    this.startPos = event.touches[0][axis];
    if (Math.abs(this.currentDef) > Constants.EDGE_ANGLE) {
      this.currentDef = this.currentDef > Constants.EDGE_ANGLE ? Constants.EDGE_ANGLE : -Constants.EDGE_ANGLE;
    }
    this.drawRuler();
    this.broadCast.emit(Constants.RULER_CHANGED, [this.currentDef]);
  }

  onResetClicked() {
    this.currentDef = 0;
    this.drawRuler();
  }

  integerAngleToString(currentAngle: number): string | undefined {
    if (currentAngle % 10 === 0 && Math.abs(currentAngle) <= 40) {
      return currentAngle.toString();
    }

    return undefined;
  }

  aboutToAppear() {
    this.resetClicked = (): void => this.onResetClicked();
    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClicked);
    this.iniSize()
  }

  drawRuler() {
    this.context.clearRect(0, 0, this.cWidth, this.cHeight);
    this.drawMidLine();
    this.drawLine();
  }

  aboutToDisappear() {
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClicked);
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.drawRuler()
        })
    }
    .onTouch((event?: TouchEvent) => {
      this.onTouchEvent(event as TouchEvent);
    })
    .backgroundColor('#33000000')
    .borderRadius($r('app.float.edit_menu_item_radius'))
    .height($r('app.float.edit_menu_crop_ruler_bar_height'))
    .width($r('app.float.edit_menu_crop_ruler_bar_width'))
    .padding({ left: '12vp', right: '12vp', top: '16vp', bottom: '15vp' }) //旋转刻度尺的内边距
  }
}
