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

import lazy { Log } from './Log';

/* instrument ignore file */
const TAG: string = 'RectUtils';

export class RectUtils {
  // Print max number
  public static readonly PRINT_MAX_NUMBER: number = 100;

  /**
   * 获取key的Rect
   *
   * @param key key
   * @returns RectInfo RectInfo
   */
  public static getRectInfoById(key: string): RectInfo {
    try {
      let strJson: string = getInspectorByKey(key);
      let rect: RectJson = JSON.parse(strJson);
      let rectInfo: object[] = JSON.parse(`[${rect.$rect} + ']'`);
      let left: number = Number(JSON.parse(`[${rectInfo[0]} + ']'`)[0]);
      let top: number = Number(JSON.parse(`[${rectInfo[0]} + ']'`)[1]);
      let right: number = Number(JSON.parse(`[${rectInfo[1]} + ']'`)[0]);
      let bottom: number = Number(JSON.parse(`[${rectInfo[1]} + ']'`)[1]);
      Log.info(TAG, `getRectInfoById left/top/right/bottom: ${left}/${top}/${right}/${bottom}`);
      return {
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      };
    } catch (err) {
      Log.info(TAG, `getPositionById error ${err}`);
    }
    return {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
    };
  }
}

export class RectInfo {
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;
}

export class RectJson {
  $rect: number[] = [];
}

/**
 * 区域类型
 */
export interface Region {
  x: number, // 起点位置x
  y: number, // 起点位置y
  width: number, // 宽
  height: number // 高
}