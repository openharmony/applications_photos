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
const DEFAULT_INDEX: number = 2;
/* instrument ignore file */
@Observed
export class ScrollerUtil {
  public isShowShadowStart: boolean = false;
  public isShowShadowEnd: boolean = true;
  public scrollDistance: number = 0;
  public shadowRate: number = 0;

  public handleDidScroll(scroller: Scroller, isScreenPortrait: boolean, state?: ScrollState) {
    if (!scroller.currentOffset()) {
      return;
    }
    const scrollDistance = (
      isScreenPortrait ? scroller.currentOffset().xOffset : scroller.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0;
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance;
  }

  public handleScrollEdge(scroller: Scroller, isScreenPortrait: boolean, side: Edge) {
    if (side === Edge.Start || side === Edge.Top) {
      this.isShowShadowStart = false;
    } else {
      this.isShowShadowStart = true;
    }
    if (side === Edge.End || side === Edge.Bottom || side === Edge.Baseline) {
      this.scrollDistance = (
        isScreenPortrait ? scroller.currentOffset().xOffset : scroller.currentOffset().yOffset
      ) ?? 0;
      this.isShowShadowEnd = false;
    } else {
      this.isShowShadowEnd = true;
    }
  }

  public static scrollerTo(
    index: number,
    scroller: Scroller,
    isScreenPortrait: boolean,
    itemWidth: number,
    itemHeight: number,
    standIndex: number = DEFAULT_INDEX
  ): void {
    scroller.scrollTo(isScreenPortrait ? {
      xOffset: index < standIndex ? 0 : (index - standIndex) * itemWidth,
      yOffset: 0,
    } : {
      xOffset: 0,
      yOffset: index < standIndex ? 0 : (index - standIndex) * itemHeight
    });
  }
}