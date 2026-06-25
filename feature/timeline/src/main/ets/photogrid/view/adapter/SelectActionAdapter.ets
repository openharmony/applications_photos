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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { GridStateObserverProxy } from '../../statemanager/GridStateObserverProxy';
import lazy { GridSelectVm } from '../../viewmodel/GridSelectVm';

/**
 * 选择动作适配器
 */
export class SelectActionAdapter extends GridStateObserverProxy {
  // 宫格选择视图模型
  protected readonly gridSelectVm: GridSelectVm;

  public constructor(gridSelectVm?: GridSelectVm) {
    super('GRID_SELECT_SelectAdapter');
    this.gridSelectVm = gridSelectVm ?? new GridSelectVm();
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.gridSelectVm.init(persistentId);
  }

  protected override doRelease(): void {
    this.gridSelectVm.release();
    super.doRelease();
  }

  /**
   * 处理点击空白处事件
   */
  public onTapGesture(): void {
    this.gridSelectVm.onTapGesture();
  }
}