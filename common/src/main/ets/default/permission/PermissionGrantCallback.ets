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

import lazy { Permissions } from '@kit.AbilityKit';

export default interface PermissionGrantCallback {
  /**
   * onGranted 部分或全部權限被授權后回調
   *
   * @param permissions 被授權的權限
   */
  onGranted: (permissions: Array<Permissions>) => void,

  /**
   * onDenied 部分或全部權限被拒絕
   *
   * @param permissions 被拒絕的權限
   */
  onDenied: (permissions: Array<Permissions>) => void,

  /**
   * onError 授權失敗，接口層返回的錯誤
   *
   * @param message 錯誤信息
   */
  onError: (message: string) => void,

  /**
   * onAllPermissionGranted 授權成功
   */
  onAllPermissionGranted: () => void;
}