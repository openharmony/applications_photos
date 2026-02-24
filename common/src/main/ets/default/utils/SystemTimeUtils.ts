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

/* instrument ignore file */

import lazy systemDateTime from '@ohos.systemDateTime';
import lazy { LogUtils } from './LogUtils';

const TAG = 'SystemTimeUtils';

/**
 * 系统时间工具类.
 */
export class SystemTimeUtils {
  private constructor() {
  }

  /**
   * 获取当前时间
   *
   * @param isNanoseconds 是否使用纳米时间
   * @param defaultValue 获取失败时的默认值
   * @returns 时间
   */
  public static getTime(isNanoseconds?: boolean, defaultValue: number = 0): number {
    try {
      return systemDateTime.getTime(isNanoseconds);
    } catch (error) {
      LogUtils.error(TAG, `getTime failed. code ${error.code}`);
    }
    return defaultValue;
  }

  /**
   * 获取设备自启动后的时间，包括睡觉时间，单位ms/ns
   *
   * @param isNanoseconds 是否使用纳米时间
   * @returns 时间
   */
  public static getStartUpTime(isNanoseconds?: boolean, defaultValue: number = 0): number {
    try {
      return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, isNanoseconds);
    } catch (error) {
      LogUtils.error(TAG, `getStartUpTime failed. code ${error.code}`);
    }
    return defaultValue;
  }
}