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

import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';

export namespace TimelineTool {
  // 当前视图左上第一个缩略图下标
  let viewFirstIndex: number = 0;

  export function formatTimeStampToLocalizedDate(milliseconds: number, rsc: RscGetter): string {
    if (DateUtil.isSameDay(milliseconds)) {
      return rsc.getString($r('app.string.date_today'));
    }
    if (DateUtil.isSameDay(milliseconds + DateUtil.MILLISECONDS_OF_ONE_DAY)) {
      return rsc.getString($r('app.string.date_yesterday'));
    }
    return DateUtil.getLocalizedDate(milliseconds);
  }

  /**
   * 更新当前视图左上第一个缩略图下标
   *
   * @param value 当前视图左上第一个缩略图下标
   */
  export function setViewFirstIndex(value: number): void {
    viewFirstIndex = value;
  }

  /**
   * 获取当前视图左上第一个缩略图下标
   *
   * @returns viewFirstIndex 当前视图左上第一个缩略图下标
   */
  export function getViewFirstIndex(): number {
    return viewFirstIndex;
  }
}