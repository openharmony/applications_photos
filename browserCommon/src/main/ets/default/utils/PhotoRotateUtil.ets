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

import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';

/* instrument ignore file */
const TAG: string = 'PhotoRotateUtil';

export class PhotoRotateUtil {
  /**
   * 大图旋转-计算到指定正角位置
   *  ---旋转圈数 * 360 + 角度附近正角度
   * @param angle
   * @returns
   */
  public static convertAngleToTarget(angle: number): number {
    let leftAngle: number = angle % 360;
    let rotateNums: number = Math.trunc(angle / 360); //带符号
    let speAngle: number = PhotoRotateUtil.getSpecificAngle(leftAngle);
    let resAngle: number = speAngle + rotateNums * 360;
    Log.info(TAG, `convertAngleToTargetAngle = ${resAngle} speAngle = ${speAngle} rotateNums = ${rotateNums}`);
    return resAngle;
  }

  /**
   * 角度 转换到 对应旋转位置正角度
   * @param angle
   * @returns
   */
  private static getSpecificAngle(angle: number): number {
    if (angle <= -360 || angle >= 360) {
      Log.error(TAG, `browser rotate wrong, angel not normalized`);
    }
    let speAngle: number = angle;
    if (angle > -360 && angle < -315) {
      speAngle = -360;
    } else if (angle >= -315 && angle < -225) {
      speAngle = -270;
    } else if (angle >= -225 && angle < -135) {
      speAngle = -180;
    } else if (angle >= -135 && angle < -45) {
      speAngle = -90;
    } else if (angle >= -45 && angle < 45) {
      speAngle = 0;
    } else if (angle >= 45 && angle < 135) {
      speAngle = 90;
    } else if (angle >= 135 && angle < 225) {
      speAngle = 180;
    } else if (angle >= 225 && angle < 315) {
      speAngle = 270;
    } else if (angle >= 315 && angle < 360) {
      speAngle = 360;
    }
    return speAngle;
  }

  /**
   * 旋转进编辑
   * 计算当前角度所在圈的正0度（360*n,n = 0,1,2...）
   */
  public static getRecentZero(angle: number): number {
    if (angle % 360 === 270 || angle % 360 === -270) {
      return angle > 0 ? angle + 90 : angle - 90;
    }
    return Math.trunc(angle / 360) * 360;
  }
}
