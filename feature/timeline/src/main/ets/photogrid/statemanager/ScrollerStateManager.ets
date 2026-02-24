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

import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy { ConfigObserverProxy } from '@ohos/common/src/main/ets/default/model/ConfigObserverProxy';
import lazy { ConfigStateManager } from '@ohos/common/src/main/ets/default/model/ConfigStateManager';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { IScrollerConfig, ScrollerConfig, IScrollerVariableConfig } from './config/ScrollerConfig';
import lazy { ISelectVariableConfig } from './config/SelectConfig';
import lazy { FORM_SIZE, FormIndex } from './constants/GridDefine';
import lazy { GridFormFsm } from './GridFormFsm';

/**
 * 滚动条观察者代理
 */
export class ScrollerObserverProxy extends ConfigObserverProxy<ScrollerStateManager, ScrollerConfig> {
  public constructor(getProxyFunc: (persistentId: number) => ScrollerStateManager) {
    super(getProxyFunc, 'ScrollerObserverProxy');
  }

  /**
   * 查询宫格滚动条触摸状态
   *
   * @param formIndex 形态索引
   * @returns 属性状态
   */
  public getIsScrollerTouched(formIndex?: FormIndex, callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.getScrollerTouchAsm(formIndex), callback);
  }

  /**
   * 查询宫格滚动条触摸状态
   *
   * @param formIndex 形态索引
   * @returns 属性状态
   */
  public getIsScrolling(formIndex?: FormIndex, callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.getScrollerScrollingAsm(formIndex), callback);
  }

  /**
   * 查询胶囊显示状态
   *
   * @param formIndex 形态索引
   * @param callback 状态变更回调
   * @returns 胶囊显示状态
   */
  public getIsCapsuleVisible(formIndex?: FormIndex, callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.getCapsuleVisibleAsm(formIndex), callback);
  }

  /**
   * 查询宫格显示的第一个索引
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getFirstIndexInGrid(formIndex?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getFirstIndexInGridAsm(formIndex), callback);
  }

  /**
   * 查询宫格显示的最后一个索引
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getLastIndexInGrid(formIndex?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getLastIndexInGridAsm(formIndex), callback);
  }

  /**
   * 查询宫格显示的最后一个索引
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getInitIndexInGrid(formIndex?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getInitIndexInGridAsm(formIndex), callback);
  }
}

/**
 * 滚动条状态管理器
 */
export class ScrollerStateManager extends ConfigStateManager<ScrollerConfig, IScrollerConfig, IScrollerVariableConfig> {
  public override readonly config: ScrollerConfig = new ScrollerConfig();

  // 滚动条管理器
  private readonly scrollerList: Scroller[] = [];

  // 滚动条滚动状态管理器
  private readonly scrollingManagers: AttributeStateManager<boolean>[] = [];

  // 滚动条触摸状态管理器
  private readonly touchManagers: AttributeStateManager<boolean>[] = [];

  // 胶囊显示状态管理器
  private readonly capsuleVisibleManagers: AttributeStateManager<boolean>[] = [];

  // 宫格形态状态机
  private readonly formFsm: GridFormFsm;

  // 宫格显示的第一个索引
  private readonly firstIndexInGrid: AttributeStateManager<number>[] = [];

  // 宫格显示的最后一个索引
  private readonly lastIndexInGrid: AttributeStateManager<number>[] = [];

  // 宫格显示的初始索引
  private readonly initIndexInGrid: AttributeStateManager<number>[] = [];

  public constructor(persistentId: number, formFsm: GridFormFsm) {
    super(persistentId, 'ScrollerStateManager');
    this.formFsm = formFsm;
    this.initManagers(persistentId);
  }

  private initManagers(persistentId: number): void {
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.scrollerList.push(new Scroller());
      this.scrollingManagers.push(new AttributeStateManager(persistentId, false, `${FormIndex[formIndex]}Scrolling`));
      this.touchManagers.push(
        new AttributeStateManager(persistentId, false, `${FormIndex[formIndex]}ScrollerTouching`));
      this.capsuleVisibleManagers.push(
        new AttributeStateManager(persistentId, false, `${FormIndex[formIndex]}CapsuleVisible`));
      this.firstIndexInGrid.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}FirstIndexInGrid`));
      this.lastIndexInGrid.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}LastIndexInGrid`));
      this.initIndexInGrid.push(new AttributeStateManager(persistentId, -1, `${FormIndex[formIndex]}InitIndexInGrid`));
    }
  }

  /**
   * 获取滚动条（注意：不要从Scroller获取滚动距离，直接从状态管理获取）
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 滚动条
   */
  public getScroller(formIndex?: FormIndex): Scroller {
    return this.getListItem(this.scrollerList, formIndex);
  }

  /**
   * 获取滚动条触摸状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 滚动条触摸状态
   */
  public getScrollerTouchAsm(formIndex?: FormIndex): AttributeStateManager<boolean> {
    return this.getListItem(this.touchManagers, formIndex);
  }

  /**
   * 获取滚动条触摸状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 滚动条触摸状态
   */
  public getScrollerScrollingAsm(formIndex?: FormIndex): AttributeStateManager<boolean> {
    return this.getListItem(this.scrollingManagers, formIndex);
  }

  /**
   * 获取胶囊显示状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 胶囊显示状态
   */
  public getCapsuleVisibleAsm(formIndex?: FormIndex): AttributeStateManager<boolean> {
    return this.getListItem(this.capsuleVisibleManagers, formIndex);
  }

  public override updateStateFromVariableConfig(_config?: IScrollerVariableConfig, _reason?: string): void {
  }
  
  /**
   * 获取宫格显示的第一个索引状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 胶囊显示状态
   */
  public getFirstIndexInGridAsm(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.firstIndexInGrid[formIndex ?? this.formFsm.getCurrentForm()];
  }

  /**
   * 获取宫格显示的最后一个索引状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 胶囊显示状态
   */
  public getLastIndexInGridAsm(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.lastIndexInGrid[formIndex ?? this.formFsm.getCurrentForm()];
  }

  /**
   * 获取宫格显示的最后一个索引状态
   *
   * @param formIndex 宫格形态，为空时取当前形态
   * @returns 胶囊显示状态
   */
  public getInitIndexInGridAsm(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.initIndexInGrid[formIndex ?? this.formFsm.getCurrentForm()];
  }

  protected override updateStateFromInitConfig(config: ScrollerConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);
  }

  private getListItem<T>(list: T[], formIndex?: FormIndex): T {
    return list[formIndex ?? this.formFsm.getCurrentForm()] ?? list[FormIndex.DAY];
  }
}