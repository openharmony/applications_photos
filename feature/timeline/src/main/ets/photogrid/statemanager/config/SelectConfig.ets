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
import lazy { TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';

/**
 * 多选可变配置
 */
export interface ISelectVariableConfig {
}

/**
 * 多选初始化配置
 */
export interface ISelectConfig extends ISelectVariableConfig {
  /**
   * 是否支持多选
   */
  isSupportSelect?: boolean;

  /**
   * 是否支持默认在多选态
   */
  isSupportDefaultSelect?: boolean;

  selectManager?: TimelineSelectManager;
}

/**
 * 多选配置
 */
export class SelectConfig extends AbstractConfig<ISelectConfig> implements ISelectConfig {
  /**
   * [不可变更]是否支持多选
   */
  private _isSupportSelect: boolean = false;

  /**
   * [不可变更]是否支持默认在多选态（PC场景默认在多选态，工具栏默认显示）
   */
  private _isSupportDefaultSelect: boolean = false;

  private _selectManager: TimelineSelectManager | undefined;

  public get isSupportSelect(): boolean {
    return this._isSupportSelect;
  }

  public get isSupportDefaultSelect(): boolean {
    return this._isSupportDefaultSelect;
  }

  public get selectManager(): TimelineSelectManager | undefined {
    return this._selectManager;
  }

  protected override doInit(param?: ISelectConfig): void {
    this._isSupportSelect = this.getValue(param?.isSupportSelect, this._isSupportSelect);
    this._isSupportDefaultSelect = this.getValue(param?.isSupportDefaultSelect, this._isSupportDefaultSelect);
    this._selectManager = this.getValue(param?.selectManager, undefined);
  }
}