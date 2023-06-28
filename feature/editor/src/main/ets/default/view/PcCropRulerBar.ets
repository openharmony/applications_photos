/*
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
  private current_def: number = 0;
  private startPos: number = 0;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private resetClicked: Function = undefined;
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
    const mid_x = Math.floor(this.rulerLength / Constants.NUMBER_2);
    this.context.beginPath();
    this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
    this.context.strokeStyle = Constants.RULER_FILL_STYLE_100;
    this.context.lineCap = 'round';

    this.context.lineWidth = Constants.MID_LINE_WIDTH;
    this.context.moveTo(mid_x, this.rulerDrawHeight - Constants.EDITOR_LARGE_TICK_LINE_HEIGHT);
    this.context.lineTo(mid_x, this.rulerDrawHeight - Constants.NUMBER_1);

    this.context.stroke();
    this.context.closePath();
  }

  drawIntegerLine(cur_x: number, cur_num: number) {
    this.context.moveTo(cur_x, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
    this.context.shadowBlur = Constants.RULER_LINE_WIDTH
    this.context.lineCap = 'round';
    if (Math.round(cur_num) != Math.round(this.current_def) && Math.round(cur_num) == 0) {
      this.context.textBaseline = 'bottom'
      this.context.font = Constants.RULER_CONTEXT_FONT_25PX;
      this.context.fillText(cur_num.toString(), cur_x, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
    }
    this.context.lineTo(cur_x, this.rulerDrawHeight);

  }

  drawLine() {
    // 起始绘制位置
    let begin_num = this.current_def - (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
    let end_num = this.current_def + (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
    let cur_x = 0;
    let cur_num = 0;
    const scale_len = Math.ceil((this.rulerLength) / Constants.NUMBER_5) + Constants.NUMBER_1;
    for (let i = 0; i < scale_len; i++) {
      cur_num = begin_num + i;
      this.context.beginPath();
      this.multiScreenAdaptation();
      this.context.textAlign = 'center';

      // 设置默认线型
      this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
      this.context.fillStyle = Constants.RULER_FILL_STYLE_40;

      // 边缘第三根线
      if (cur_num <= (begin_num + Constants.NUMBER_3) || cur_num >= (end_num - Constants.NUMBER_3)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_30;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_30;
      }

      // 次边缘的线
      if (cur_num <= (begin_num + Constants.NUMBER_2) || cur_num >= (end_num - Constants.NUMBER_2)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_20;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_20;
      }
      // 最边缘的线
      if (cur_num <= (begin_num + Constants.NUMBER_2) || cur_num >= (end_num - Constants.NUMBER_2)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_10;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_10;
      }

      // 标尺0与当前数值之间的白色竖线
      if ((cur_num < this.current_def && cur_num >= 0) || (cur_num > this.current_def && cur_num <= 0)) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_100;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
      }

      // 设置线宽
      this.context.shadowBlur = 0;
      this.context.lineCap = 'round';
      cur_x = i * Constants.NUMBER_5
      if (cur_x == 0 || cur_x == this.rulerLength) {
        // 边界位置刻度线宽度为一半
        this.context.lineWidth = (Constants.RULER_LINE_WIDTH / Constants.NUMBER_2);
        if (cur_x < 0) {
          cur_x = 0;
        }
      } else {
        this.context.lineWidth = Constants.RULER_LINE_WIDTH;
      }

      // 绘制刻度线
      if (Math.abs(cur_num) % Constants.NUMBER_10 === 0) {
        // 每隔10个刻度绘制一个中刻度线
        this.drawIntegerLine(cur_x, cur_num)
      } else if ((cur_num < this.current_def && cur_num >= 0) || (cur_num > this.current_def && cur_num <= 0)) {
        // 0和当前刻度之间的线
        this.context.moveTo(cur_x, this.rulerDrawHeight - Constants.EDITOR_MIDDLE_TICK_LINE_HEIGHT);
        this.context.lineTo(cur_x, this.rulerDrawHeight);
      } else {
        // 其他短刻度线
        this.context.moveTo(cur_x, this.rulerDrawHeight - Constants.EDITOR_SMALL_TICK_LINE_HEIGHT);
        this.context.lineTo(cur_x, this.rulerDrawHeight);
      }
      this.context.stroke();
      this.context.closePath();
    }
  }

  onTouchEvent(event: TouchEvent) {
    if (event.type == TouchType.Down) {
      if (this.isVerticalScreen) {
        this.startPos = (event.touches[0].x);
      } else {
        this.startPos = (event.touches[0].y);
      }
      this.previous = new Date().getTime();
    }

    if (event.type == TouchType.Move) {
      let now = new Date().getTime();
      if (now - this.previous >= Constants.TIMEOUT) {
        this.previous = now;
      } else {
        return;
      }

      let dir = this.isVerticalScreen ? this.startPos - (event.touches[0].x) :
        this.startPos - (event.touches[0].y);
      if (Math.abs(dir / Constants.NUMBER_5) >= Constants.NUMBER_1) {
        this.current_def += parseInt((dir / Constants.NUMBER_5).toFixed(0));
        this.startPos = this.isVerticalScreen ? (event.touches[0].x) : (event.touches[0].y)
        if (Math.abs(this.current_def) > Constants.EDGE_ANGLE) {
          this.current_def = this.current_def > Constants.EDGE_ANGLE ?
          Constants.EDGE_ANGLE : -Constants.EDGE_ANGLE;
        }

        this.drawRuler();
        this.broadCast.emit(Constants.RULER_CHANGED, [this.current_def]);
      }
    }
  }

  onResetClicked() {
    this.current_def = 0;
    this.drawRuler();
  }

  integerAngleToString(currentAngle: number): string {
    switch (currentAngle) {
      case -Constants.NUMBER_40:
        return Constants.NEGATIVE_FORTY;
      case -Constants.NUMBER_30:
        return Constants.NEGATIVE_THIRTY;
      case -Constants.NUMBER_20:
        return Constants.NEGATIVE_TWENTY;
      case -Constants.NUMBER_10:
        return Constants.NEGATIVE_TEN;
      case Constants.NUMBER_0:
        return Constants.ZERO_STR;
      case Constants.NUMBER_10:
        return Constants.POSITIVE_TEN;
      case Constants.NUMBER_20:
        return Constants.POSITIVE_TWENTY;
      case Constants.NUMBER_30:
        return Constants.POSITIVE_THIRTY;
      case Constants.NUMBER_40:
        return Constants.POSITIVE_FORTY;
      default:
        break;
    }
  }

  aboutToAppear() {
    this.resetClicked = this.onResetClicked.bind(this);
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
    .onTouch((event) => {
      this.onTouchEvent(event);
    })
    .backgroundColor('#33000000')
    .borderRadius($r('app.float.edit_menu_item_radius'))
    .height($r('app.float.edit_menu_crop_ruler_bar_height'))
    .width($r('app.float.edit_menu_crop_ruler_bar_width'))
    .padding({ left: '12vp', right: '12vp', top: '16vp', bottom: '15vp' }) //旋转刻度尺的内边距
  }
}
