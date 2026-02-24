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
import lazy { SwitchMode } from '../constants/SwitchDefine';

/**
 * 切换可变参数
 */
export interface ISwitchVariableConfig {
  /**
   * 是否开启日分组导航
   */
  isOpenGroupDayGuide?: boolean;

  /**
   * 切换组件模式
   */
  switchMode?: SwitchMode;

  /**
   * 是否隐藏Switch到底部
   */
  switchHidToBottom?: boolean;

  /**
   * 是否更新切换向导状态
   */
  isUpdateGuideState?: boolean;

  /**
   * 是否显示提醒气泡
   */
  isDayGuideShow?: boolean;
}

/**
 * 切换初始化参数
 */
export interface ISwitchConfig extends ISwitchVariableConfig {
  /**
   * [不可变更]是否支持切换组件，默认不支持
   */
  isSupportSwitch?: boolean;
  /**
   * 是否支持切换动效
   */
  isSupportSwitchAnimate?: boolean;
}

/**
 * 切换配置
 */
export class SwitchConfig extends AbstractConfig<ISwitchConfig> implements ISwitchConfig {
  /**
   * [不可变更]是否支持切换组件，默认不支持
   */
  private _isSupportSwitch: boolean = false;

  /**
   * 是否支持切换动效，默认支持
   */
  private _isSupportSwitchAnimate: boolean = true;

  /**
   * [可变更]是否开启日分组导航
   */
  private _isOpenGroupDayGuide: boolean = true;

  /**
   * [可变更]切换组件模式
   */
  private _switchMode: SwitchMode = SwitchMode.NORMAL;

  /**
   * [变更]切换组件模式
   */
  private _switchHidToBottom: boolean = false;

  /**
   * 是否更新切换向导状态
   */
  private _isUpdateGuideState?: boolean = true;

  /**
   * 是否显示提醒气泡
   */
  private _isDayGuideShow?: boolean = false;

  protected override doInit(param?: ISwitchConfig): void {
    this._isSupportSwitch = this.getValue(param?.isSupportSwitch, this._isSupportSwitch);
    this._isOpenGroupDayGuide = this.getValue(param?.isOpenGroupDayGuide, this._isOpenGroupDayGuide);
    this._switchMode = this.getValue(param?.switchMode, this._switchMode);
    this._switchHidToBottom = this.getValue(param?.switchHidToBottom, this._switchHidToBottom);
    this._isSupportSwitchAnimate = this.getValue(param?.isSupportSwitchAnimate, this._isSupportSwitchAnimate);
    this._isUpdateGuideState = this.getValue(param?.isUpdateGuideState, this._isUpdateGuideState);
    this._isDayGuideShow = this.getValue(param?.isDayGuideShow, this._isDayGuideShow);
  }

  public get isSupportSwitch(): boolean {
    return this._isSupportSwitch;
  }

  public get isOpenGroupDayGuide(): boolean {
    return this._isOpenGroupDayGuide;
  }

  public get switchMode(): SwitchMode {
    return this._switchMode;
  }

  public get switchHidToBottom(): boolean {
    return this._switchHidToBottom;
  }

  public get isSupportSwitchAnimate(): boolean {
    return this._isSupportSwitchAnimate;
  }

  public get isUpdateGuideState(): boolean {
    return this._isUpdateGuideState;
  }

  public get isDayGuideShow(): boolean {
    return this._isDayGuideShow;
  }
}