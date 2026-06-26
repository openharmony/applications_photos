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

import lazy { Constants } from '../model/common/Constants';
import lazy { DeviceInfo } from './DeviceInfo';

const TAG: string = `GroupFeature`;
const ANONYMIZATION_MIN_LENGTH: number = 3;
const ANONYMIZATION_MAX_LENGTH: number = 8;
const ANONYMIZATION_LEFT_LENGTH: number = 2;
/**
 * HighLightSwitchManager
 */
export class GroupFeature {
  private isFeatureSupported: boolean = false;

  private constructor() {
  }

  public static getInstance(): GroupFeature {
    if (!GroupFeature.instance) {
      GroupFeature.instance = new GroupFeature();
    }
    return GroupFeature.instance;
  }

  private static instance: GroupFeature | undefined = undefined;

  public isSupported(): boolean {
    if (!this.isDeviceSupported()) {
      return false;
    }
    return this.isFeatureSupported;
  }

  public isDeviceSupported(): boolean {
    return !DeviceInfo.isPc();
  }

  public static isInvalid(text?: string): boolean {
    return !text;
  }

  public static getAnonymizeAlbumName(value: Resource | string): Resource | string {
    return (typeof value === 'string') ? GroupFeature.getAnonymizeString(value) : value;
  }

  /**
   * 字符串脱敏
   *
   * @param str
   * @returns AnonymizeString
   */
  public static getAnonymizeString(str: string): string {
    if (!str) {
      return str;
    }

    let strLength: number = str.length;
    if (strLength <= ANONYMIZATION_MIN_LENGTH) { // 对于长度小于3的字串，保留最后一位
      return '****' + str.substring(strLength - 1) + '****';
    } else if (strLength <= ANONYMIZATION_MAX_LENGTH) { // 对于长度介于4-8之间的字串，保留最后两位
      return '***' + str.substring(strLength - ANONYMIZATION_LEFT_LENGTH) + '***';
    } else { // 对于长度大于8的文件名，从第8位开始保留
      return '**' + str.substring(ANONYMIZATION_MAX_LENGTH) + '**';
    }
  }

  public static checkNameInvalid(inputName: string): boolean {
    return Constants.NAME_PATTERN.test(inputName);
  }
}