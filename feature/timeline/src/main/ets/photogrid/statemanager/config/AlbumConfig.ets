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

import lazy { AbstractConfig } from '@ohos/common/src/main/ets/default/model/AbstractConfig';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { BaseBuildParams, emptyBuildBuilder } from '../../view/ViewLoader';

/**
 * 相册信息类型
 */
export type AlbumInfoType = AlbumInfo | undefined;

/**
 * 相册可变配置
 */
export interface IAlbumVariableConfig {
  /**
   * 相册信息
   */
  albumInfo?: AlbumInfoType;
}

/**
 * 相册不可变配置
 */
export interface IAlbumConfig extends IAlbumVariableConfig {
  /**
   * 是否支持排序选择
   */
  isSupportSortSelector?: boolean;
  /**
   * 是否一直沉浸式模式
   */
  isAlwaysImmersive?: boolean;
  /**
   * 额外参数配置
   */
  extraParams?: ParamsWrapper;
  /**
   * 是否处于删除相册
   */
  isSupportTrashMsg?: boolean;
  /**
   * 是否支持相册缩放动效
   */
  isSupportScaleAnimation?: boolean;
  /**
   * 日宫格顶部不规则区域构建器，只在日视图展示
   *
   * @param params
   */
  dayViewIrregularBuilder?: (param: BaseBuildParams) => void;
}

/**
 * 相册配置
 */
export class AlbumConfig extends AbstractConfig<IAlbumConfig> implements IAlbumConfig {
  private _albumInfo: AlbumInfoType = undefined;

  private _isSupportSortSelector: boolean = false;

  private _isAlwaysImmersive: boolean = false;

  private _extraParams: ParamsWrapper = new ParamsWrapper();

  private _isSupportTrashMsg: boolean = false;

  private _isSupportScaleAnimation: boolean | undefined = undefined;

  private _dayViewIrregularBuilder: (param: BaseBuildParams) => void = emptyBuildBuilder;

  public get albumInfo(): AlbumInfoType {
    return this._albumInfo;
  }

  public get isSupportSortSelector(): boolean {
    return this._isSupportSortSelector;
  }

  public get isAlwaysImmersive(): boolean {
    return this._isAlwaysImmersive;
  }

  public get extraParams(): ParamsWrapper {
    return this._extraParams;
  }

  public get isSupportTrashMsg(): boolean {
    return this._isSupportTrashMsg;
  }

  public get isSupportScaleAnimation(): boolean | undefined {
    return this._isSupportScaleAnimation;
  }

  public get dayViewIrregularBuilder(): (param: BaseBuildParams) => void {
    return this._dayViewIrregularBuilder;
  }

  protected override doInit(param?: IAlbumConfig): void {
    this._albumInfo = this.getValue(param?.albumInfo, this._albumInfo);
    this._isSupportSortSelector = this.getValue(param?.isSupportSortSelector, this._isSupportSortSelector);
    this._isAlwaysImmersive = this.getValue(param?.isAlwaysImmersive, this._isAlwaysImmersive);
    this._extraParams = this.getValue(param?.extraParams, this._extraParams);
    this._isSupportTrashMsg =
      this.getValue(param?.isSupportTrashMsg, this._isSupportTrashMsg);
    this._isSupportScaleAnimation = this.getValue(param?.isSupportScaleAnimation, this._isSupportScaleAnimation);
    this._dayViewIrregularBuilder = this.getValue(param?.dayViewIrregularBuilder, this._dayViewIrregularBuilder);
  }
}