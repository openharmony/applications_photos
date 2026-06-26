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

import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

export class GroupFeatureManager {
  // 是否支持照片页日期分割视图特性，默认pc不支持
  public static isSupport(): boolean {
    return !DeviceInfo.isPc() && !DeviceInfo.isTv();
  }
}