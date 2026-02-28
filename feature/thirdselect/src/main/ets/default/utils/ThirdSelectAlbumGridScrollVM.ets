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
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

const TAG = 'ThirdSelectAlbumGridScrollVM'

interface OnScrollBarUpdateOptions {
  // 当前显示的网格起始位置的索引值。
  index: number,
  // 当前显示的网格起始位置元素相对网格显示起始位置的偏移，单位vp。
  offset: number,
  // 行偏移，展示安全提示时为1
  rowOffset: number,
  // 列偏移，展示相机宫格时为1
  columnOffset: number,
  // 宫格项高度，vp
  gridItemHeight: number,
  // 宫格行项数
  gridRowCount: number,
  // 宫格总项数，用于总高度计算
  count: number,
}

export class ThirdSelectAlbumGridScrollVM {
  // 绘制触发的对应帧的滚动条位置与实际用户手指的间隔
  private flushToRealOffset: number = 0;
  // 加载内容对应帧位置与绘制位置的间隔
  private loadToFlushOffset: number = 0;
  private willScrollTriggered: boolean = false;

  public onScrollStart(): void {
    this.loadToFlushOffset = 0;
    this.flushToRealOffset = 0;
  }

  /**
   * 记录手指位置与滚动条实际位置之间的偏移
   * @param scrollHelperOffset 抽帧计算后的滚动条偏移量
   * @param offset 实际的滑动偏移量
   */
  public onWillScroll(scrollHelperOffset: number, offset: number): void {
    this.willScrollTriggered = true;
    if (scrollHelperOffset === 0) {
      this.flushToRealOffset += offset;
    } else {
      this.loadToFlushOffset = offset + this.flushToRealOffset;
      this.flushToRealOffset = 0;
    }
  }

  /**
   * scroller位置更新，补全手指滑动偏移与抽帧后偏移量之间的差值，优化跟手
   * @param options
   * @returns
   */
  public onScrollBarUpdate(options: OnScrollBarUpdateOptions): ComputedBarAttribute {
    let totalOffset = 0;
    const totalRow = Math.ceil((options.count + options.columnOffset) / options.gridRowCount) + options.rowOffset;
    const totalLength = totalRow * (options.gridItemHeight + Constants.GRID_GUTTER) - Constants.GRID_GUTTER;
    if (options.index === 0) {
      totalOffset = -options.offset;
    } else {
      const row = Math.ceil((options.index - options.rowOffset) / options.gridRowCount) + options.rowOffset;
      totalOffset = row * (options.gridItemHeight + Constants.GRID_GUTTER) - options.offset;
      if (this.willScrollTriggered) {
        totalOffset += (this.loadToFlushOffset + this.flushToRealOffset);
        this.willScrollTriggered = false;
      }
    }

    return {
      totalOffset,
      totalLength,
    }
  }
}