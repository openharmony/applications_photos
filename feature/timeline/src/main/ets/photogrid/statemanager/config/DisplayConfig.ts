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
import lazy { DEFAULT_BOTTOM_AVOID_HEIGHT } from '../constants/DisplayDefine';
import type { Size } from '@ohos.arkui.node';

/**
 * 屏幕显示可变参数
 */
export interface IDisplayVariableConfig {
  /**
   * 显示区域
   */
  areaSize?: Size;

  /**
   * 宫格是否可见（默认否）
   */
  isGridShow?: boolean;

  /**
   * 是否横屏状态（默认否）
   */
  isHorizontal?: boolean;

  /**
   * 是否展示状态栏（默认是）
   */
  isStatusBarInLayout?: boolean;

  /**
   * 底部避让高度
   */
  bottomAvoidHeight?: number;

  /**
   * 上方避让高度（主要是状态栏）
   */
  topAvoidHeight?: number;
}

/**
 * 屏幕显示初始化参数
 */
export interface IDisplayConfig extends IDisplayVariableConfig {
}

/**
 * 屏幕显示配置
 */
export class DisplayConfig extends AbstractConfig<IDisplayConfig> implements IDisplayConfig {
  /**
   * [可变更]顶部避让高度
   */
  private _areaSize: Size = { width: 0, height: 0 };

  /**
   * [可变更]宫格是否可见（默认是）
   */
  private _isGridShow: boolean = true;

  /**
   * [可变更]是否横屏状态（默认否）
   */
  private _isHorizontal: boolean = false;

  /**
   * [可变更]是否展示状态栏（默认是）
   */
  private _isStatusBarInLayout: boolean = true;

  /**
   * [可变更]底部避让高度
   */
  private _bottomAvoidHeight: number = DEFAULT_BOTTOM_AVOID_HEIGHT;

  /**
   * [可变更]顶部避让高度
   */
  private _topAvoidHeight: number = DEFAULT_BOTTOM_AVOID_HEIGHT;

  public constructor() {
    super('DisplayConfig');
  }

  public get areaSize(): Size {
    return this._areaSize;
  }

  public get isGridShow(): boolean {
    return this._isGridShow;
  }

  public get isHorizontal(): boolean {
    return this._isHorizontal;
  }

  public get isStatusBarInLayout(): boolean {
    return this._isStatusBarInLayout;
  }

  public get bottomAvoidHeight(): number {
    return this._bottomAvoidHeight;
  }

  public get topAvoidHeight(): number {
    return this._topAvoidHeight;
  }

  protected override doInit(param?: IDisplayConfig): void {
    this._areaSize = this.getValue(param?.areaSize, this._areaSize);
    this._isGridShow = this.getValue(param?.isGridShow, this._isGridShow);
    this._isHorizontal = this.getValue(param?.isHorizontal, this._isHorizontal);
    this._isStatusBarInLayout = this.getValue(param?.isStatusBarInLayout, this._isStatusBarInLayout);
    this._bottomAvoidHeight = this.getValue(param?.bottomAvoidHeight, this._bottomAvoidHeight);
    this._topAvoidHeight = this.getValue(param?.topAvoidHeight, this._topAvoidHeight);
  }
}