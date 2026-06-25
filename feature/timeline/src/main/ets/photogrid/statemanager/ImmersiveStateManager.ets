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
import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';

/**
 * 沉浸式状态管理器
 */
export class ImmersiveStateManager extends AttributeStateManager<boolean> {
  protected isAlwaysImmersive: boolean = false;

  constructor(persistentId: number, initState: boolean, tag?: string) {
    super(persistentId, initState, tag);
  }

  public updateState(newState: boolean, reason?: string): void {
    if (this.isAlwaysImmersive) {
      return;
    }
    super.updateState(newState, reason);
  }

  public updateAlwaysImmersiveValue(isAlwaysImmersive: boolean): void {
    this.isAlwaysImmersive = isAlwaysImmersive;
    if (isAlwaysImmersive) { // 默认沉浸式，更新。若此处入参为false，请根据屏幕界面状态自行更新沉浸式状态值
      super.updateState(true, 'ImmersiveAlways')
    }
  }
}