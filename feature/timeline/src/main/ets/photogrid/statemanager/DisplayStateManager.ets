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

import lazy { Size } from '@ohos.arkui.node';
import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy { ConfigListenerObserverProxy} from '@ohos/common/src/main/ets/default/model/ConfigObserverProxy';
import lazy { ConfigStateManager } from '@ohos/common/src/main/ets/default/model/ConfigStateManager';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { ConfigurationChangeListener, EnvironmentHelper } from '@ohos/common/src/main/ets/default/utils/EnvironmentHelper';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy { DisplayConfig, IDisplayConfig, IDisplayVariableConfig } from './config/DisplayConfig';

/**
 * 屏幕显示事件监听
 */
export interface DisplayEventListener {
  /**
   * 显示区域变化前回调
   *
   * @param newSize 新的大小
   */
  onPreAreaSizeChange?: (newSize: Size) => void;

  /**
   * 显示区域变化后回调
   *
   * @param newSize 新的大小
   */
  onPostAreaSizeChange?: (newSize: Size) => void;

  /**
   * 占位区域变化
   *
   * @param uniqueId mediaItem的uniqueId
   * @param isTap 是否tap, 为true时隐藏宫格
   */
  onPlaceHolderChange?: (uniqueId: string, isTap: boolean) => void;
}

/**
 * 屏幕显示观察者代理
 */
export class DisplayObserverProxy
  extends ConfigListenerObserverProxy<DisplayStateManager, DisplayConfig, DisplayEventListener> {
  public constructor(getProxyFunc: (persistentId: number) => DisplayStateManager) {
    super(getProxyFunc, 'DisplayObserverProxy');
  }

  /**
   * 查询宫格是否显示
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsGridShow(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.gridShowAsm, callback);
  }

  /**
   * 查询宫格是否显示
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsGridActive(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.gridActiveAsm, callback);
  }

  /**
   * 查询是否在横屏状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsHorizontal(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.horizontalAsm, callback);
  }

  /**
   * 查询是否展示statusbar
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsStatusBarInLayout(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.statusBarInLayoutAsm, callback);
  }

  /**
   * 查询底部避让高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getBottomAvoidHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.bottomAvoidHeightAsm, callback);
  }

  /**
   * 查询顶部避让高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getTopAvoidHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.topAvoidHeightAsm, callback);
  }

  /**
   * 查询宫格显示区域大小
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridAreaSize(callback?: StateChangeCallback<Size>): Size {
    return this.getState<Size>(this.proxy.gridAreaSizeAsm, callback);
  }

  /**
   * 获取宫格被覆盖状态状态信息
   *
   * @param callback 更新回调
   * @returns 宫格是否被覆盖
   */
  public getGridCovered(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isGridCoveredAsm, callback);
  }

  /**
   * 获取宫格聚焦状态信息
   *
   * @param callback 更新回调
   * @returns 宫格是否聚焦
   */
  public getGridFocused(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isPhotoGridFocusedAsm, callback);
  }

  /**
   * 获取当前语言
   *
   * @param callback 更新回调
   * @returns 当前语言
   */
  public getLanguage(callback?: StateChangeCallback<string>): string {
    return this.getState<string>(this.proxy.languageAsm, callback);
  }

  /**
   * 获取宫格宫格是否在调整大小中
   *
   * @param callback 更新回调
   * @returns 当前语言
   */
  public getIsGridResize(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isGridResizeAsm, callback);
  }
}

/**
 * 宫格显示区域大小管理器
 */
class GridAreaSizeAsm extends AttributeStateManager<Size> {
  private updateListener?: DisplayEventListener;

  public constructor(persistentId: number, initState: Size) {
    super(persistentId, initState, 'GridAreaSize');
  }

  public setUpdateListener(preUpdateListener?: DisplayEventListener): void {
    this.updateListener = preUpdateListener;
  }

  public updateState(newState: Size, reason?: string): void {
    if (this.currentState.height === newState.height && this.currentState.width === newState.width) {
      return;
    }
    this.updateListener?.onPreAreaSizeChange?.(newState);
    super.updateState(newState, reason);
    this.updateListener?.onPostAreaSizeChange?.(newState);
  }

  protected logState(size: Size): string {
    return `GridAreaSize: [${size.width}, ${size.height}]`;
  }
}

/**
 * 屏幕显示状态管理器
 */
export class DisplayStateManager
  extends ConfigStateManager<DisplayConfig, IDisplayConfig, IDisplayVariableConfig, DisplayEventListener> {
  public override readonly config: DisplayConfig = new DisplayConfig();
  /**
   * 宫格是否显示
   */
  public readonly gridShowAsm: AttributeStateManager<boolean>;

  /**
   * 宫格是否在前台
   */
  public readonly gridActiveAsm: AttributeStateManager<boolean>;

  /**
   * 横屏状态管理器（是否横屏）
   */
  public readonly horizontalAsm: AttributeStateManager<boolean>;
  /**
   * 状态栏状态管理器（是否展示状态栏）
   */
  public readonly statusBarInLayoutAsm: AttributeStateManager<boolean>;
  /**
   * 底部避让高度管理器
   */
  public readonly bottomAvoidHeightAsm: AttributeStateManager<number>;
  /**
   * 顶部避让高度管理器
   */
  public readonly topAvoidHeightAsm: AttributeStateManager<number>;
  /**
   * 宫格显示区域大小管理器
   */
  public readonly gridAreaSizeAsm: GridAreaSizeAsm;

  /**
   * 宫格被覆盖状态管理器
   */
  public readonly isGridCoveredAsm: AttributeStateManager<boolean>;

  /**
   * 宫格聚焦状态管理器
   */
  public readonly isPhotoGridFocusedAsm: AttributeStateManager<boolean>;

  /**
   * 宫格聚焦状态管理器
   */
  public readonly languageAsm: AttributeStateManager<string>;

  /**
   * 宫格大小变化中状态管理器
   */
  public readonly isGridResizeAsm: AttributeStateManager<boolean>;

  private readonly cfgListener: ConfigurationChangeListener = {
    onConfigurationUpdated: (oldConfig: Configuration | undefined,
      newConfig: Configuration) => this.onConfigurationUpdated(oldConfig, newConfig),
  } as ConfigurationChangeListener;

  public constructor(persistentId: number) {
    super(persistentId, 'DisplayStateManager');
    this.gridAreaSizeAsm = new GridAreaSizeAsm(persistentId, { width: 0, height: 0 });
    this.gridShowAsm = new AttributeStateManager(persistentId, true, 'GridShow');
    this.horizontalAsm = new AttributeStateManager(persistentId, false, 'Horizontal');
    this.statusBarInLayoutAsm = new AttributeStateManager(persistentId, true, 'statusBarInLayout');
    this.bottomAvoidHeightAsm = new AttributeStateManager(persistentId, 0, 'BottomAvoidHeight');
    this.topAvoidHeightAsm = new AttributeStateManager(persistentId, 0, 'TopAvoidHeight');
    this.isGridCoveredAsm = new AttributeStateManager(persistentId, false, 'isGridCoveredAsm');
    this.isPhotoGridFocusedAsm = new AttributeStateManager(persistentId, false, 'isPhotoGridFocused');
    this.languageAsm = new AttributeStateManager(persistentId, '', 'Language');
    this.isGridResizeAsm = new AttributeStateManager(persistentId, false, 'GridResize');
    this.gridActiveAsm = new AttributeStateManager(persistentId, true, 'GridActive');
  }

  public override updateStateFromVariableConfig(config?: IDisplayVariableConfig, reason?: string): void {
    // 是否显示宫格
    this.gridShowAsm.updateState(config?.isGridShow, reason);

    // 是否横屏状态
    this.horizontalAsm.updateState(config?.isHorizontal, reason);

    // 状态栏是否展示
    this.statusBarInLayoutAsm.updateState(config?.isStatusBarInLayout, reason);

    // 更新宫格显示区域
    if (!!config?.areaSize) {
      this.gridAreaSizeAsm.updateState(config?.areaSize, reason);
    }

    // 底部避让高度
    this.bottomAvoidHeightAsm.updateState(config?.bottomAvoidHeight, reason);

    // 顶部避让高度
    this.topAvoidHeightAsm.updateState(config?.topAvoidHeight, reason);
  }

  protected override updateStateFromInitConfig(config: DisplayConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);
  }

  /**
   * 刷新宫格被覆盖状态信息
   *
   * @param isGridCovered 宫格是否被覆盖
   * @param reason 更新原因
   */
  public updateGridCovered(isGridCovered: boolean, reason?: string): void {
    this.isGridCoveredAsm.updateState(isGridCovered, reason);
  }

  /**
   * 更新宫格聚焦状态信息
   *
   * @param isPhotoGridFocused 宫格是否聚焦
   * @param reason 更新原因
   */
  public updateGridFocused(isPhotoGridFocused: boolean, reason?: string): void {
    this.isPhotoGridFocusedAsm.updateState(isPhotoGridFocused, reason);
  }

  /**
   * 更新占位index
   *
   * @param uniqueId mediaItem的uniqueId
   * @param isTap 是否tap, 为true时隐藏宫格
   */
  public updatePlaceHolder(uniqueId: string, isTap: boolean):void {
    this.callbackObservers(observer => {
      observer.onPlaceHolderChange?.(uniqueId, isTap);
    })
  }

  protected override doInit(config: IDisplayConfig): void {
    super.doInit(config);
    this.gridAreaSizeAsm.setUpdateListener({
      onPreAreaSizeChange:
        (newState: Size) => this.callbackObservers(observer => {
          this.isGridResizeAsm.updateState(true, this.tag);
          observer.onPreAreaSizeChange?.(newState);
        }),
      onPostAreaSizeChange:
        (newState: Size) => this.callbackObservers(observer => {
          observer.onPostAreaSizeChange?.(newState);
          this.isGridResizeAsm.updateState(false, this.tag);
        }),
    });
    EnvironmentHelper.getInstance(getContext())?.addListener(this.cfgListener);
  }

  protected doRelease(): void {
    this.gridAreaSizeAsm.setUpdateListener();
    EnvironmentHelper.getInstance(getContext())?.removeListener(this.cfgListener);
    super.doRelease();
  }

  private onConfigurationUpdated(oldConfig: Configuration | undefined, newConfig: Configuration): void {
    if (oldConfig?.language !== newConfig.language) {
      this.languageAsm.updateState(newConfig.language, 'onConfiguration');
    }
  }
}