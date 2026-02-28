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
import lazy { AbstractVm } from './AbstractVm';

/**
 * 宫格选择视图模型
 */
export class GridSelectVm extends AbstractVm {
  protected isDoSelectAll: boolean = false;

  constructor() {
    super('GRID_SELECT_GridSelectVm');
  }

  /**
   * 点击空白处回调
   */
  public onTapGesture(): void {
  }
}