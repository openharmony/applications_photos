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

/**
 * 全局开关状态校验以及申请开启接口定义
 */
export abstract class GlobalSwitchChecker {
  // 抽象方法：检查开关是否打开
  abstract isSwitchOn(): boolean;

  // 抽象方法：请求打开开关
  abstract requestOpenSwitch(): Promise<boolean>;
}