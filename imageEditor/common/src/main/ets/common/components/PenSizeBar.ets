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

import { Event } from '../jul';
import { App, BaseEditor } from '../../service/App';

let touchX = 0;

const HOT_REGION: number = 32;

@Component
export struct PenSizeBar {
  @Prop @Watch('refreshParam') minRadius: number;
  @Prop @Watch('refreshParam') maxRadius: number;
  @Prop @Watch('refreshParam') maxLength: number;
  @Prop maxLevels: number;
  @Prop updateShowRevert: boolean = true;
  @Prop currentValue: number =
    Math.floor(this.maxLevels / 2) * (this.minRadius + this.maxLength + this.maxRadius) / (this.maxLevels - 1);
  @Prop isScreenPortrait: boolean = true;
  public onCurrentSizeChange: (val: number) => void = Event;
  public onEnd: () => void = Event;

  @State baseEditor: BaseEditor = App.getInstance().myEditor();
  private penWidth: number = 36;
  @State private minRadiusPx: number = 0;
  @State private maxRadiusPx: number = 0;
  @State private maxLengthPx: number = 0;
  private penSizeArray: number[] = [4, 6, 9, 12, 16];

  aboutToAppear() {
    this.refreshParam();
  }

  build() {
    Column() {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          Path()
            .commands(this.isScreenPortrait ? this.getCommand(1) : this.getLandscapeCommand(1))
            .fill("#1affffff")
            .stroke(Color.Transparent)
            .width(this.isScreenPortrait ? this.minRadius + this.maxLength + this.maxRadius : this.maxRadius * 2)
            .height(this.isScreenPortrait ? this.maxRadius * 2 : this.minRadius + this.maxLength + this.maxRadius)
          this.SnapPoint();
          Row()
            .width(16)
            .height(16)
            .backgroundColor("#E6E6E6")
            .borderRadius(16)
            .position(this.isScreenPortrait ? {x : this.getCircleCurrentX(), y: -8 + this.maxRadius} : {x: -8 + this.maxRadius, y: this.getCircleCurrentX() })
            .shadow({
              radius: 4,
              color: 'rgba(0, 0, 0, 0.3)',
              offsetX: 0,
              offsetY: 0,
            })
        }
        .width(this.isScreenPortrait ? this.minRadius + this.maxLength + this.maxRadius : this.maxRadius * 2)
        .height(this.isScreenPortrait ? this.maxRadius * 2 : this.minRadius + this.maxLength + this.maxRadius)
      }
      // 暂不支持焦点/切换焦点/快捷键
    }
    .width(this.isScreenPortrait ? this.minRadius + this.maxLength + this.maxRadius + HOT_REGION : this.penWidth)
    .height(this.isScreenPortrait ? this.penWidth : this.minRadius + this.maxLength + this.maxRadius + HOT_REGION)
    .justifyContent(FlexAlign.Center)
    .onTouch((event?: TouchEvent) => {
      if (!event) {
        return;
      }
      this.touchPenSizeBar(event);
    })
  }

  @Builder
  SnapPoint() {
    ForEach(this.penSizeArray, (item: number, index?: number) => {
      if (index !== 0 && index !== this.penSizeArray.length - 1 && index) {
        Row()
          .width(4)
          .height(4)
          .backgroundColor($r('sys.color.icon_on_tertiary'))
          .borderRadius(4)
          .position(this.isScreenPortrait ?
            {
              x: index * (this.minRadius + this.maxLength + this.maxRadius) / (this.maxLevels - 1),
              y: -2 + this.maxRadius,
            } :
            {
              x: -2 + this.maxRadius,
              y: index * (this.minRadius + this.maxLength + this.maxRadius) / (this.maxLevels - 1),
            }
          )
      }
    })
  }

  private refreshParam() {
    this.minRadiusPx = vp2px(this.minRadius);
    this.maxRadiusPx = vp2px(this.maxRadius);
    this.maxLengthPx = vp2px(this.maxLength);
  }

  getCommand(x: number): string {
    let L = this.maxLengthPx * x;
    let R = this.minRadiusPx + (this.maxRadiusPx - this.minRadiusPx) * x;
    let str = `M ${this.minRadiusPx} ${this.maxRadiusPx +
    this.minRadiusPx} A ${this.minRadiusPx} ${this.minRadiusPx} 0 1 1 ${this.minRadiusPx} ${this.maxRadiusPx -
    this.minRadiusPx} L ${L + this.minRadiusPx} ${this.maxRadiusPx - R} A ${R} ${R} 0 1 1 ${L + this.minRadiusPx} ${R +
    this.maxRadiusPx} Z`;
    console.log(`PenSizeBar getCommand return ${str}`);
    return str;
  }

  getLandscapeCommand(y: number): string {
    let L = this.maxLengthPx * y;
    let R = this.minRadius + (this.maxRadiusPx - this.minRadiusPx) * y;
    let str = `M ${this.maxRadiusPx +
    this.minRadiusPx} ${this.minRadiusPx} A ${this.minRadiusPx} ${this.minRadiusPx} 1 1 0 ${this.maxRadiusPx -
    this.minRadiusPx} ${this.minRadiusPx} L ${this.maxRadiusPx - R} ${L + this.minRadiusPx} A ${R} ${R} 1 1 0 ${R +
    this.maxRadiusPx} ${L + this.minRadiusPx} Z`;
    console.log(`PenSizeBar getLandscapeCommand return ${str}`);
    return str;
  }

  getCircleCurrentX(): number {
    let currentX: number =
      this.currentValue / (this.maxLevels - 1) * (this.minRadius + this.maxLength + this.maxRadius) - 8;
    if (this.currentValue === 0) {
      return currentX + 8;
    } else if (this.currentValue === 4) {
      return currentX - 8;
    } else {
      return currentX;
    }
  }

  touchPenSizeBar(event: TouchEvent) {
    if (!event) {
      return;
    }
    if (event.type == TouchType.Down) {
      touchX = (this.isScreenPortrait ? event.touches[0].x : event.touches[0].y) - HOT_REGION / 2;
      this.baseEditor.animateChangeImmersive(false);
    }
    if (event.type == TouchType.Move) {
      touchX = (this.isScreenPortrait ? event.touches[0].x : event.touches[0].y) - HOT_REGION / 2;
      if (touchX < 8) {
        touchX = 8;
      }
      if (touchX > (this.minRadius + this.maxLength + this.maxRadius) - 8) {
        touchX = (this.minRadius + this.maxLength + this.maxRadius) - 8;
      }
    }
    this.currentValue = touchX / (this.minRadius + this.maxLength + this.maxRadius) * (this.maxLevels - 1);
    if (event.type == TouchType.Up) {
      if (this.updateShowRevert) {
        this.baseEditor.isShowRevert = !this.baseEditor.editModified;
      }
      animateTo({
        duration: 100,
        curve:Curve.Sharp,
      }, () => {
        this.currentValue = Math.round(this.currentValue);
      })
      this.onCurrentSizeChange(this.currentValue);
      this.onEnd();
    }
  }
}