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

import lazy { AbstractConfig } from '@ohos/common/src/main/ets/default/model/AbstractConfig';
import lazy { GridToolBarPosition } from '../constants/ToolBarDefine';

/**
 * 工具栏可变配置
 */
export interface IToolbarVariableConfig {
  /**
   * [可变]宫格工具栏位置（默认在下方）
   */
  toolbarPosition?: GridToolBarPosition
}

/**
 * 工具栏初始化配置
 */
export interface IToolbarConfig extends IToolbarVariableConfig {
}

/**
 * 工具栏配置
 */
export class ToolbarConfig extends AbstractConfig<IToolbarConfig> implements IToolbarConfig {
  /**
   * 宫格工具栏位置（默认在下方）
   */
  private _toolbarPosition: GridToolBarPosition = GridToolBarPosition.BOTTOM;

  protected override doInit(param?: IToolbarConfig): void {
    this._toolbarPosition = this.getValue(param?.toolbarPosition, this._toolbarPosition);
  }

  public get toolbarPosition(): GridToolBarPosition {
    return this._toolbarPosition;
  }
}