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

import { BroadCast, Constants, Log, ScreenManager } from '@ohos/common';

const TAG: string = 'editor_CropRulerBar';

interface RulerProperties {
  rulerWidth: number;
  rulerHeight: number;
}

@Component
export struct CropRulerBar {
  @Consume broadCast: BroadCast;
  @Consume @Watch('iniSize') screenWidth: number;
  @Consume @Watch('iniSize') screenHeight: number;
  @State cWidth: number = 250;
  @State cHeight: number = Constants.VERTICAL_RULER_COMPONENT_HEIGHT;
  @State rulerLength: number = Constants.NUMBER_0;
  @State rulerWidth: number = Constants.NUMBER_0;
  @Consume('verticalScreen') isVerticalScreen: boolean;
  private screenManager = ScreenManager.getInstance();
  private currentDef: number = Constants.NUMBER_0;
  private startPos: number = Constants.NUMBER_0;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private resetClicked: Function = (): void => {};
  private previous: number = Constants.NUMBER_0;

  setRulerProperties(rulerWidth: number, rulerHeight: number): void {
    AppStorage.setOrCreate<RulerProperties>('rulerProperties', {
      rulerWidth: rulerWidth,
      rulerHeight: rulerHeight
    } as RulerProperties)
  }

  iniSize(): void {
    if (this.isVerticalScreen) {
      this.rulerLength = this.cWidth;
      this.rulerWidth = this.cHeight;
    } else {
      this.cWidth = Constants.HORIZONTAL_CROP_RULER_WIDTH;
      this.cHeight = (this.screenHeight - this.screenHeight % Constants.NUMBER_20) - Constants.PADDING_HORIZONTAL;
      this.rulerLength = this.cHeight;
      this.rulerWidth = this.cWidth;
    }
    this.setRulerProperties(this.cWidth, this.cHeight);
  }

  multiScreenAdaptation(): void {
    if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_1) {
      this.context.font = Constants.RULER_CONTEXT_FONT_10PX;
    } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_2) {
      this.context.font = Constants.RULER_CONTEXT_FONT_20PX;
    } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_3) {
      this.context.font = Constants.RULER_CONTEXT_FONT_30PX;
    } else {
      this.context.font = Constants.RULER_CONTEXT_FONT_35PX;
    }
  }

  drawMidLine(): void {
    const midX= Math.floor(this.rulerLength / Constants.NUMBER_2);
    this.context.beginPath();
    this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
    if (this.isVerticalScreen) {
      this.context.fillRect(midX- Constants.MID_LINE_WIDTH / Constants.NUMBER_2,
        this.rulerWidth * Constants.NUMBER_8 / Constants.NUMBER_15,
        Constants.MID_LINE_WIDTH, Constants.MID_LINE_HEIGHT);
    } else {
      this.context.fillRect(this.rulerWidth * Constants.NUMBER_8_5 / Constants.NUMBER_15,
        midX- Constants.MID_LINE_WIDTH / Constants.NUMBER_2, Constants.MID_LINE_HEIGHT,
        Constants.MID_LINE_WIDTH);
    }
    this.context.stroke();
    this.context.closePath();
  }

  drawIntegerLine(curX: number, curNum: number): void {
    if (!this.isVerticalScreen) {
      this.context.moveTo((this.rulerWidth * 8.5) / 15, curX);
    } else {
      this.context.moveTo(curX, (this.rulerWidth * 8.5) / 15);
    }

    if (Math.abs(curNum) > Constants.EDGE_ANGLE) {
      this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
      this.context.shadowColor = Constants.RULER_FILL_STYLE_40;
    } else {
      this.context.strokeStyle = Constants.RULER_FILL_STYLE_90;
      this.context.shadowColor = Constants.RULER_FILL_STYLE_90;
    }
    this.context.shadowBlur = Constants.RULER_LINE_WIDTH
    if (Math.round(curNum) == Math.round(this.currentDef)) {
      if (!this.isVerticalScreen) {
        this.context.fillText(this.integerAngleToString(Math.round(curNum)) as string,
          (this.rulerWidth * 6) / 15, curX);
      } else {
        this.context.fillText(this.integerAngleToString(Math.round(curNum)) as string, curX,
          (this.rulerWidth * 6) / 15);
      }
    } else {
      if (!this.isVerticalScreen) {
        this.context.fillText((-curNum).toString(),
          (this.rulerWidth * 6) / 15, curX);
      } else {
        this.context.fillText(curNum.toString(), curX,
          (this.rulerWidth * 6) / 15);
      }

    }
    if (!this.isVerticalScreen) {
      this.context.lineTo(this.rulerWidth * 10.5 / 15, curX);
    } else {
      this.context.lineTo(curX, this.rulerWidth * 10.5 / 15);
    }
  }

  drawLine(): void {
    let beginNum = this.currentDef - (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
    let curX = 0;
    let curNum = 0;
    const scaleLen = Math.ceil((this.rulerLength) / Constants.NUMBER_5) + Constants.NUMBER_1;
    for (let i = 0; i < scaleLen; i++) {
      curNum = beginNum + i;
      this.context.beginPath();
      this.multiScreenAdaptation();
      this.context.textAlign = 'center';
      if (!this.isVerticalScreen) {
        this.context.textAlign = 'end';
        this.context.textBaseline = 'middle';
      }
      if (Math.abs(curNum) > Constants.EDGE_ANGLE) {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_40;
      } else {
        this.context.strokeStyle = Constants.RULER_FILL_STYLE_90;
        this.context.fillStyle = Constants.RULER_FILL_STYLE_90;
      }
      this.context.shadowBlur = 0;
      curX = i * Constants.NUMBER_5;
      if (curX == 0 || curX == this.rulerLength) {
        this.context.lineWidth = (Constants.RULER_LINE_WIDTH / Constants.NUMBER_2);
        if (curX < 0) {
          curX = 0;
        }
      } else {
        this.context.lineWidth = Constants.RULER_LINE_WIDTH;
      }
      if (Math.round(Math.abs(curNum)) % Constants.NUMBER_10 == 0) {
        this.drawIntegerLine(curX, curNum);
      } else {
        if (!this.isVerticalScreen) {
          this.context.moveTo((this.rulerWidth * Constants.NUMBER_9_5) / Constants.NUMBER_15, curX);
          this.context.lineTo(this.rulerWidth * Constants.NUMBER_10_5 / Constants.NUMBER_15, curX);
        } else {
          this.context.moveTo(curX, (this.rulerWidth * Constants.NUMBER_9_5) / Constants.NUMBER_15);
          this.context.lineTo(curX, this.rulerWidth * Constants.NUMBER_10_5 / Constants.NUMBER_15);
        }
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

  onResetClicked(): void {
    this.currentDef = Constants.NUMBER_0;
    this.drawRuler();
  }

  integerAngleToString(currentAngle: number): string | undefined{
    if (currentAngle % 10 === 0 && Math.abs(currentAngle) <= 40) {
      return currentAngle.toString();
    }

    return undefined;
  }

  aboutToAppear(): void {
    this.resetClicked = (): void => this.onResetClicked();
    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClicked);
    this.iniSize();
  }

  drawRuler(): void {
    this.context.clearRect(0, 0, this.cWidth, this.cHeight);
    this.drawMidLine();
    this.drawLine();
  }

  aboutToDisappear(): void {
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClicked);
  }

  build() {
    Flex({
      direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Column() {
        Canvas(this.context)
          .onReady(() => {
            this.drawRuler();
          })
      }
      .onTouch((event?: TouchEvent) => {
        this.onTouchEvent(event as TouchEvent);
      })
      .width(this.isVerticalScreen ? this.rulerLength : Constants.CROP_RULER_WIDTH)
      .height(this.isVerticalScreen ? this.rulerWidth : this.rulerLength)
    }
  }
}
