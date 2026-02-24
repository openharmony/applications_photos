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

export const FAST_SCROLL_INTERVAL_MS = 500;
const FAST_SCROLL_ENTER_TIMES = 5;
const FAST_SCROLL_EXIT_TIMES = 1;

export class FastScrollChecker {
  private lastTimestamp: number | null = null;
  private consecutiveMatch: number = 0;
  private consecutiveMismatch: number = 0;
  private isFastScrolling: boolean = false;

  /**
   * 记录一次滑动事件
   * @returns 当前是否处于快速滑动状态
   */
  public recordScrollAndCheck(): boolean {
    const now = Date.now();

    // 如果是第一次滑动，只记录时间戳
    if (this.lastTimestamp === null) {
      this.lastTimestamp = now;
      return false;
    }

    // 计算当前滑动与上一次的间隔
    const interval = now - this.lastTimestamp;
    this.lastTimestamp = now;

    if (!this.isFastScrolling) {
      // 非快速滑动状态下的处理
      if (interval < FAST_SCROLL_INTERVAL_MS) {
        this.consecutiveMatch++;
        this.consecutiveMismatch = 0;
      } else {
        this.consecutiveMatch = 0;
      }

      // 检查是否进入快速滑动状态（连续5次间隔<500ms）
      if (this.consecutiveMatch >= FAST_SCROLL_ENTER_TIMES) {
        this.isFastScrolling = true;
        this.consecutiveMismatch = 0; // 重置退出计数器
      }
    } else {
      // 快速滑动状态下的处理
      if (interval < FAST_SCROLL_INTERVAL_MS) {
        // 符合条件，重置退出计数器
        this.consecutiveMismatch = 0;
      } else {
        // 不符合条件，增加退出计数器
        this.consecutiveMismatch++;
        // 检查是否退出快速滑动（1次间隔≥500ms）
        if (this.consecutiveMismatch >= FAST_SCROLL_EXIT_TIMES) {
          this.isFastScrolling = false;
          this.consecutiveMatch = 0; // 重置进入计数器
        }
      }
    }
    return this.isFastScrolling;
  }
}