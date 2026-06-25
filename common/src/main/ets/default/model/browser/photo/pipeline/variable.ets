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

interface Factor {
  A: number,
  B: number,
}

// calculate scale arg
export namespace Scales {
  // Scale lower limit
  export const COMPONENT_SCALE_FLOOR: number = 0.5;

  // After reaching max scale, you can also scale an additional 0.2x max scale, and rebound after letting go
  export const OVER_SCALE_EXTRA_FACTOR: number = 1.5;

  // If the aspect ratio of the picture is the same as the display area,
  // double-click to adjust the zoom factor to 4 / 3
  export const SAME_RATIO_SCALE_FACTOR: number = 2;

  export const THRESHOLD: number = 0.5;

  export const COEFFICIENT_OF_FRICTION: number = -8.4;

  interface Range {
    MIN: number,
    MAX: number,
  }

  interface Correspond {
    RANGE: Range,
    FACTOR: Range,
  }

  export const CORRE: Correspond = {
    RANGE: {
      MIN: 0.7,
      MAX: 1.3,
    },
    FACTOR: {
      MIN: 1.13,
      MAX: 1.64,
    },
  };

  export const FACTOR: Factor = {
    A: 1 / 3,
    B: 5 / 6,
  };

  export const MAGNIFICATION: number = 2;

  export interface BigData {
    screenHeight?: number;
    screenWidth?: number;
    speed?: number;
    offset?: [number, number];
    eventType?: string,

    // 上次缩放值
    lastScale?: number,

    // 默认缩放值
    defaultScale?: number,

    // 当前缩放值
    scale?: number,

    // 缩放中心点，是相对于控件的百分比位置，非绝对位置
    center?: [number, number],
    lastOffset?: [number, number],

    // 最大缩放比例
    maxScale?: number,

    // 是否已经到达最左边
    hasReachLeft?: boolean,

    // 是否已经到达最右边
    hasReachRight?: boolean,
    height?: number;
    width?: number;
  }

  export function overwrite(msg: Scales.BigData, status: Scales.BigData): Scales.BigData {
    return {
      screenHeight: status.screenHeight ?? msg.screenHeight,
      screenWidth: status.screenWidth ?? msg.screenWidth,
      speed: status.speed ?? msg.speed,
      offset: status.offset ?? msg.offset,
      eventType: status.eventType ?? msg.eventType,
      // 上次缩放值
      lastScale: status.lastScale ?? msg.lastScale,
      // 默认缩放值
      defaultScale: status.defaultScale ?? msg.defaultScale,
      // 当前缩放值
      scale: status.scale ?? msg.scale,
      // 缩放中心点，是相对于控件的百分比位置，非绝对位置
      center: status.center ?? msg.center,
      lastOffset: status.lastOffset ?? msg.lastOffset,
      // 最大缩放比例
      maxScale: status.maxScale ?? msg.maxScale,
      // 是否已经到达最左边
      hasReachLeft: status.hasReachLeft ?? msg.hasReachLeft,
      // 是否已经到达最右边
      hasReachRight: status.hasReachRight ?? msg.hasReachRight,
      height: status.height ?? msg.height,
      width: status.width ?? msg.width,
    }
  }
}

