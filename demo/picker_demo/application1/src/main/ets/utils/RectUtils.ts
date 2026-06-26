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
 
import lazy print from '@ohos.print';
import lazy fileShare from '@ohos.fileshare';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import type common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy { UiUtil } from './UiUtil';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import type { SelectManager } from '../model/browser/SelectManager';
import lazy { Log } from './Log';
import lazy prompt from '@system.prompt';
 
/* instrument ignore file */
const TAG: string = 'RectUtils';
 
export class RectUtils {
  // Print max number
  static readonly PRINT_MAX_NUMBER: number = 100;
 
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
      let rectInfo: Array<object> = JSON.parse('[' + rect.$rect + ']');
      let rect_left: number = Number(JSON.parse('[' + rectInfo[0] + ']')[0]);
      let rect_top: number = Number(JSON.parse('[' + rectInfo[0] + ']')[1]);
      let rect_right: number = Number(JSON.parse('[' + rectInfo[1] + ']')[0]);
      let rect_bottom: number = Number(JSON.parse('[' + rectInfo[1] + ']')[1]);
      Log.info(TAG, `getRectInfoById left/top/right/bottom: ${rect_left}/${rect_top}/${rect_right}/${rect_bottom}`);
      return { left: rect_left, top: rect_top, right: rect_right, bottom: rect_bottom };
    } catch (err) {
      Log.info(TAG, `getPositionById error ${err}`);
    }
    return { left: 0, top: 0, right: 0, bottom: 0 };
  }
}
 
export class RectInfo {
  left: number = 0;
  top: number = 0;
  right: number = 0;
  bottom: number = 0;
}
 
export class RectJson {
  $rect: Array<number> = [];
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