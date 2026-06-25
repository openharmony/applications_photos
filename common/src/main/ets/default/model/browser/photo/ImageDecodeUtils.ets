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
import lazy { Log } from '../../../../default/utils/Log';
import lazy { thermal } from '@kit.BasicServicesKit';
import lazy { TraceControllerUtils } from '../../../../default/utils/TraceControllerUtils';

const TAG = 'ImageDecodeUtils';

export class ImageDecodeUtils {
  public static maxLevel: thermal.ThermalLevel = thermal.ThermalLevel.HOT;

  public static isHighTemperatureControll(): boolean {
    TraceControllerUtils.startTrace(`isHighTemperatureControll`);
    let level: thermal.ThermalLevel = thermal.getLevel();
    TraceControllerUtils.finishTrace(`isHighTemperatureControll`);
    Log.info(TAG, `isHighTemperatureControll level: ${level}`);
    if (level >= ImageDecodeUtils.maxLevel) {
      return true;
    }
    return false;
  }

}