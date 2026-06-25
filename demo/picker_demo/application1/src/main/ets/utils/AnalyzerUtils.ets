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

import lazy Matrix4 from '@ohos.matrix4';
import lazy { Log } from './Log';
import lazy { Matrix4x4 } from './Matrix4x4';

export interface ComponentSizeInfo {
  componentWidth: number;
  componentHeight: number;
  componentPositionX: number;
  componentPositionY: number;
}

export enum Status {
  STATUS_NONE = 0,
  OVERLAY_NONE = 1,
  OVERLAY_SHOW = 2,
  OVERLAY_HIDE = 3,
  AIBUTTON_SELECTED = 4,
  AIBUTTON_UNSELECTED = 5,
  AIBUTTON_HIDE = 6,
  SELECTED_TO_UNSELECTED = 7,
  UNSELECTED_TO_SELECTED = 8,
  LOOKUP_PANEL_SHOW = 9,
  LOOKUP_PANEL_HIDE = 10,
  LOOKUP_PANEL_LOW = 11,
  LOOKUP_PANEL_MEDIUM = 12,
  LOOKUP_PANEL_HIGH = 13,
}

const TAG: string = 'common_AnalyzerUtil';

export class AnalyzerUtil {
  public static SUBJECT_TYPE: number = 0;
  public static TEXT_TYPE: number = 1;
  public static SEARCH_TYPE: number = 3;

  public static isTextSelectedDrug(selectedStatus: Status,
    isSelectedTextChange: boolean,
    preGestureType: GestureControl.GestureType,
    gestureInfo: GestureInfo): boolean {
    return selectedStatus === Status.UNSELECTED_TO_SELECTED &&
      isSelectedTextChange && preGestureType === GestureControl.GestureType.PAN_GESTURE &&
      gestureInfo.type === GestureControl.GestureType.TAP_GESTURE;
  }

  public static isFingerListEmpty(fingerList: FingerInfo[]): boolean {
    if (fingerList.length === 0) {
      Log.info(TAG, 'checkEventInVideoAnalyzer: fingerList is invalid');
      return true;
    }
    return false;
  }

  public static getScale(matrix: Matrix4.Matrix4Transit): number {
    let mat: number[] | undefined = (matrix.copy() as Matrix4x4).matrix4x4;
    let scale: number = 1;
    if (mat) {
      scale = mat[0];
    }
    return scale;
  }

  public static isFingerInComponent(componentSizeInfo: ComponentSizeInfo, scale: number,
    fingerList: FingerInfo[]): boolean {
    let width: number = componentSizeInfo.componentWidth * scale;
    let height: number = componentSizeInfo.componentHeight * scale;
    let widthDiff: number = (width > componentSizeInfo.componentWidth) ?
      (width - componentSizeInfo.componentWidth) / 2 : 0;
    let heightDiff: number = (height > componentSizeInfo.componentHeight) ?
      (height - componentSizeInfo.componentHeight) / 2 : 0;
    let left: number = componentSizeInfo.componentPositionX - widthDiff;
    let right: number = left + width;
    let top: number = componentSizeInfo.componentPositionY - heightDiff;
    let bottom: number = top + height;

    if (fingerList[0].globalX < left || fingerList[0].globalX > right ||
      fingerList[0].globalY < top || fingerList[0].globalY > bottom) {
      return false;
    }
    return true;
  }
}