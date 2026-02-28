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
import { HiLog } from '../util/HiLog';
import { ScreenUtil } from '../util/ScreenUtil';

@Component
export struct CustomScroll {
  @State tabLength: number = 0;
  @State marginScreen: number = 0;
  @Link scrollDirection: ScrollDirection;
  @State barState: BarState = BarState.On;
  @State barWidth: number = 0;
  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State angle: number = 90;
  @State itemWidth: number = 34;
  @State isRightEdge: boolean = true;
  @BuilderParam scrollItem?: () => void
  @Prop needMask: boolean = false;
  public scrollAppear: () => void = Event;
  public scroll: (state: ScrollState) => void = Event;
  public scrollEnd: () => void = Event;
  public scrollEdge: (side: Edge) => void = Event;
  public scroller: Scroller = new Scroller();

  build() {
    this.ParentView();
  }

  @Builder
  ParentView() {
    Row() {
      RelativeContainer() {
        this.CustomScroller();
      }.height('100%').width('100%')
    }
  }

  @Builder
  CustomScroller() {
    Scroll(this.scroller) {
      this.scrollItem?.();
    }
    .scrollable(this.scrollDirection)
    .scrollBar(this.barState)
    .scrollBarWidth(this.barWidth)
    .edgeEffect(this.edgeEffect)
    .height('100%')
    .width('100%')
    .onAppear((): void => {
      this.scrollAppear();
    })
    .onDidScroll((x: number, y: number, state: ScrollState): void => {
      this.scroll(state);
      if (!this.scroller.currentOffset()) {
        HiLog.w('CustomScroller', 'onDidScroll ignored');
        return;
      }
    })
    .onScrollEnd((): void => {
      this.scrollEnd();
    })
    .onScrollEdge((side: Edge) => {
      this.scrollEdge(side);
    })
    .id('petalclip_scroll')
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    , center: { anchor: '__container__', align: VerticalAlign.Center }
    })
  }
}
