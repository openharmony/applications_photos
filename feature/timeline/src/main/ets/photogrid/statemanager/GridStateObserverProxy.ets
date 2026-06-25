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

import lazy { AbstractObserverProxy } from '@ohos/common/src/main/ets/default/model/AbstractObserverProxy';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { DataSourceListener } from '../model/DataSourceManager';
import lazy { FormIndex } from './constants/GridDefine';
import lazy { DisplayObserverProxy } from './DisplayStateManager';
import lazy { OperateEventType, OperateStateType } from './GridOperateFsm';
import lazy { FormEventType, FormStateType } from './GridFormFsm';
import lazy { PreloadEventType, PreloadStateType } from './GridPreloadFsm';
import lazy { GridObserverProxy } from './GridStateManager';
import lazy { GridStateProxy } from './GridStateProxy';
import lazy { PinchObserverProxy } from './PinchStateManager';
import lazy { SelectObserverProxy } from './SelectStateManager';
import lazy { SwitchObserverProxy } from './SwitchStateManager';
import lazy { ToolbarObserverProxy } from './ToolbarStateManager';
import lazy { ScrollerObserverProxy } from './ScrollerStateManager';
import lazy { TitleBarObserverProxy } from './TitleBarStateManager';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { GroupInfo } from './common/GroupInfo';
import lazy { AlbumObserverProxy } from './AlbumStateManager';

/**
 * 宫格所有状态监听器代理
 */
export class GridStateObserverProxy<V = number> extends AbstractObserverProxy<GridStateProxy, V> {
  /**
   * 宫格观察者代理
   */
  public readonly gridObserverProxy: GridObserverProxy = new GridObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).gridStateManager);
  /**
   * 切换观察者代理
   */
  public readonly switchObserverProxy: SwitchObserverProxy = new SwitchObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).switchStateManager);
  /**
   * 捏合观察者代理
   */
  public readonly pinchObserverProxy: PinchObserverProxy = new PinchObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).pinchStateManager);
  /**
   * 工具栏观察者代理
   */
  public readonly toolbarObserverProxy: ToolbarObserverProxy = new ToolbarObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).toolbarStateManager);
  /**
   * 多选观察者代理
   */
  public readonly selectObserverProxy: SelectObserverProxy = new SelectObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).selectStateManager);
  /**
   * 屏幕显示观察者代理
   */
  public readonly displayObserverProxy: DisplayObserverProxy = new DisplayObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).displayStateManager);
  /**
   * 滚动观察者代理
   */
  public readonly scrollerObserverProxy: ScrollerObserverProxy = new ScrollerObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).scrollerStateManager);
  /**
   * 相册观察者代理
   */
  public readonly albumObserverProxy: AlbumObserverProxy = new AlbumObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).albumStateManager);
  /**
   * 标题栏观察者代理
   */
  public readonly titleBarObserverProxy: TitleBarObserverProxy = new TitleBarObserverProxy(
    persistentId => GridStateProxy.getInstance(persistentId).titleBarStateManager);
  // 数据源监听器
  private readonly datasourceListeners: Set<DataSourceListener> = new Set();

  public constructor(tag?: string) {
    super(persistentId => GridStateProxy.getInstance(persistentId), tag ?? 'GridStateObserverProxy');
  }

  /**
   * 查询是否在等待数据源管理器
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsWaitDataSourceManager(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.waitDataSourceManagerAsm, callback);
  }

  /**
   * 获取分组信息
   *
   * @returns 分组信息
   */
  public get groupInfo(): GroupInfo {
    return this.proxy.groupInfo;
  }

  /**
   * 查询宫格操作状态机状态
   *
   * @param callback 更新回调
   * @returns 状态机状态
   */
  public getOperateState(callback?: StateChangeCallback<OperateStateType, OperateEventType>): OperateStateType {
    return this.getState<OperateStateType>(this.proxy.operateFsm, callback);
  }

  /**
   * 查询宫格形态状态机状态
   *
   * @param callback 更新回调
   * @returns 状态机状态
   */
  public getFormState(callback?: StateChangeCallback<FormStateType, FormEventType>): FormStateType {
    return this.getState<FormStateType>(this.proxy.formFsm, callback);
  }

  /**
   * 获取当前形态索引
   *
   * @returns 形态索引
   */
  public getCurrentForm(): FormIndex {
    return this.proxy.formFsm.getCurrentForm();
  }


  /**
   * 查询宫格加载状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getPreloadState(callback?: StateChangeCallback<PreloadStateType, PreloadEventType>): PreloadStateType {
    return this.getState<PreloadStateType>(this.proxy.preloadFsm, callback);
  }

  /**
   * 查询是否在大图切换动效中
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsInBrowserAnim(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.browserAnimAsm, callback);
  }

  /**
   * 查询是否所有缩略图生成完成
   *
   * @returns 是否所有缩略图生成完成
   */
  public isAllThumbnailReady(): boolean {
    return this.proxy.dataSourceManager.isAllThumbnailReady();
  }

  /**
   * 注册数据源事件监听
   *
   * @param dataSourceListener 数据源事件监听
   */
  public registerDataSourceListener(dataSourceListener: DataSourceListener): void {
    this.datasourceListeners.add(dataSourceListener);
    this.proxy.getDataSourceManager()?.registerObserver(dataSourceListener);
  }

  /**
   * 注销数据源事件监听
   *
   * @param dataSourceListener 数据源事件监听
   */
  public unRegisterDataSourceListener(dataSourceListener: DataSourceListener): void {
    this.datasourceListeners.delete(dataSourceListener);
    this.proxy.getDataSourceManager()?.unRegisterObserver(dataSourceListener);
  }

  /**
   * 查询数据数量
   *
   * @returns 数据数量
   */
  public totalCount(): number {
    return this.proxy.dataSourceManager.totalCount();
  }

  /**
   * 查询分组信息
   *
   * @returns 分组信息
   */
  public getGroups(): TimelineData[] {
    return this.proxy.dataSourceManager.getGroups();
  }

  protected override doInit(param: V): void {
    super.doInit(param);
    this.gridObserverProxy.init(this.persistentId);
    this.switchObserverProxy.init(this.persistentId);
    this.pinchObserverProxy.init(this.persistentId);
    this.toolbarObserverProxy.init(this.persistentId);
    this.selectObserverProxy.init(this.persistentId);
    this.displayObserverProxy.init(this.persistentId);
    this.scrollerObserverProxy.init(this.persistentId);
    this.titleBarObserverProxy.init(this.persistentId);
    this.albumObserverProxy.init(this.persistentId);

    if (this.albumObserverProxy.config.isAlwaysImmersive) {
      GridStateProxy.getInstance(this.persistentId).gridStateManager.immersiveAsm.updateAlwaysImmersiveValue(true);
    }
  }

  protected override doRelease(): void {
    this.clearDataSourceListeners();
    this.gridObserverProxy.release();
    this.switchObserverProxy.release();
    this.pinchObserverProxy.release();
    this.toolbarObserverProxy.release();
    this.selectObserverProxy.release();
    this.displayObserverProxy.release();
    this.scrollerObserverProxy.release();
    this.titleBarObserverProxy.release();
    this.albumObserverProxy.release();
    super.doRelease();
  }

  private clearDataSourceListeners(): void {
    if (this.datasourceListeners.size > 0) {
      if (GridStateProxy.checkInstance(this.persistentId)) {
        for (let listener of this.datasourceListeners) {
          this.proxy.getDataSourceManager()?.unRegisterObserver(listener);
        }
      }
      this.datasourceListeners.clear();
    }
  }
}