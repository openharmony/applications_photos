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
import lazy { PINCH_SPEED_THRESHOLD } from '../constants/PinchDefine';

/**
 * 捏合可变配置参数
 */
export interface IPinchVariableConfig {
  /**
   * 捏合速度阈值
   */
  pinchSpeedThreshold?: number;
}

/**
 * 捏合配置参数
 */
export interface IPinchConfig extends IPinchVariableConfig {
  /**
   * 是否支持捏合操作
   */
  isSupportPinch?: boolean;
}

/**
 * 捏合配置
 */
export class PinchConfig extends AbstractConfig<IPinchConfig> implements IPinchConfig {
  /**
   * 是否支持捏合操作（手机、平板支持，PC、模拟器不支持）
   */
  private _isSupportPinch: boolean = false;

  /**
   * 捏合速度阈值
   */
  private _pinchSpeedThreshold: number = PINCH_SPEED_THRESHOLD;

  protected override doInit(param?: IPinchConfig): void {
    this._isSupportPinch = this.getValue(param?.isSupportPinch, this._isSupportPinch);
    this._pinchSpeedThreshold = this.getValue(param?.pinchSpeedThreshold, this._pinchSpeedThreshold,
      value => value > 0);
  }

  public get isSupportPinch(): boolean {
    return this._isSupportPinch;
  }

  public get pinchSpeedThreshold(): number {
    return this._pinchSpeedThreshold;
  }
}