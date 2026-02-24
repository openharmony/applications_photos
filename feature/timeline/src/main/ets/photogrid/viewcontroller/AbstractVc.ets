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

import lazy { AttributeUpdater } from '@ohos.arkui.modifier';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { StateTransferProcessor } from '@ohos/common/src/main/ets/default/model/StateTransferProcessor';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { OperateEventType, OperateStateType, OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { FormEventType, FormStateType } from '../statemanager/GridFormFsm';
import lazy { AnimationOpacity } from './animation/AnimationDefine';
import lazy { AbstractVm } from '../viewmodel/AbstractVm';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { ShowMode } from '../statemanager/constants/GridDefine';

/**
 * 操作状态转移执行器
 */
class OperateStateTransferProcessor extends StateTransferProcessor<OperateStateType, OperateEventType> {
  protected logTransition?(matchedActions: string[], oldState: OperateStateType, newState: OperateStateType,
    event?: OperateEventType | undefined): void {
    LogUtils.info(this.tag, `[<${OperateStateType[oldState]} -> ${OperateStateType[newState]}>, ` +
      `event: ${OperateEventType[event ?? OperateEventType.NONE]}, matchedActions: ${matchedActions.join(', ')}]`);
  }
}

/**
 * 形态状态转移执行器
 */
class FormStateTransferProcessor extends StateTransferProcessor<FormStateType, FormEventType> {
  protected override logTransition(matchedActions: string[], oldState: FormStateType, newState: FormStateType,
    event?: FormEventType): void {
    LogUtils.info(this.tag, `[<${FormStateType[oldState]} -> ${FormStateType[newState]}>, ` +
      `event: ${FormEventType[event ?? FormEventType.NONE]}, matchedActions: ${matchedActions.join(', ')}]`);
  }
}

/**
 * 基础属性更新器
 */
export class BaseAttributeUpdater<T extends CommonAttribute = CommonAttribute> extends AttributeUpdater<T> {
  /**
   * 放缩系数
   */
  protected viewId?: string;
  /**
   * 放缩系数
   */
  protected zIndex?: number;
  /**
   * 放缩系数
   */
  protected scaleOptions: ScaleOptions = {};
  /**
   * 不透明度
   */
  protected opacity: number = AnimationOpacity.DEFAULT;
  /**
   * 不透明度
   */
  protected visibility: Visibility = Visibility.Visible;
  /**
   * 是否使能
   */
  protected enabled: boolean = true;
  /**
   * 是否横屏
   */
  protected isHorizontal: boolean = false;
  /**
   * 高度
   */
  protected height?: Length;
  /**
   * 内边距
   */
  protected padding?: LocalizedPadding;
  /**
   * 外边距
   */
  protected margin?: LocalizedPadding;
  /**
   * 不可见
   */
  protected notVisible: Visibility = Visibility.Hidden;
  // 是否可见
  private isVisible: boolean = true;
  // 是否能可见
  private isCanVisible: boolean = true;

  public constructor(viewId?: string, zIndex?: number) {
    super();
    this.viewId = viewId;
    this.zIndex = zIndex;
  }

  public override initializeModifier(instance: T): void {
    this.initInstance(instance);
  }

  public override onComponentChanged(instance: T): void {
    this.initInstance(instance);
  }

  /**
   * 更新是否可见
   *
   * @param isVisible 是否可见
   * @param isCanVisible 是否能可见
   */
  public updateVisible(isVisible?: boolean, isCanVisible?: boolean): void {
    if (isVisible !== undefined) {
      this.isVisible = isVisible;
    }
    if (isCanVisible !== undefined) {
      this.isCanVisible = this.isCanVisible;
    }
    this.updateVisibility();
  }

  /**
   * 获取是否可见
   *
   * @returns 是否可见
   */
  public getIsVisible(): boolean {
    return this.isCanVisible && this.isVisible;
  }

  /**
   * 更新放缩系数
   *
   * @param scaleOptions 放缩系数
   */
  public updateScale(scaleOptions: ScaleOptions): void {
    this.scaleOptions = scaleOptions;
    this.attribute?.scale(this.scaleOptions);
  }

  /**
   * 更新不透明度
   *
   * @param opacity 不透明度
   */
  public updateOpacity(opacity: number): void {
    this.opacity = opacity;
    this.attribute?.opacity(this.opacity);
  }

  /**
   * 更新是否使能
   *
   * @param enabled 是否使能
   */
  public updateEnable(enabled: boolean): void {
    this.enabled = enabled;
    this.attribute?.enabled(enabled);
  }

  /**
   * 更新是否横屏
   *
   * @param isHorizontal 是否横屏
   */
  public updateIsHorizontal(isHorizontal: boolean): void {
    this.isHorizontal = isHorizontal;
  }

  /**
   * 更新高度
   *
   * @param height 高度
   */
  public updateHeight(height: Length): void {
    this.height = height;
    if (this.height !== undefined) {
      this.attribute?.height(this.height);
    }
  }

  /**
   * 更新内边距
   *
   * @param newPadding 新的内边距
   */
  public updatePadding(newPadding: LocalizedPadding): void {
    if (this.padding === undefined) {
      this.padding = {};
    }
    if (newPadding.top !== undefined) {
      this.padding.top = newPadding.top;
    }
    if (newPadding.bottom !== undefined) {
      this.padding.bottom = newPadding.bottom;
    }
    if (newPadding.start !== undefined) {
      this.padding.start = newPadding.start;
    }
    if (newPadding.end !== undefined) {
      this.padding.end = newPadding.end;
    }
    this.attribute?.padding(this.padding);
  }

  /**
   * 更新外边距
   *
   * @param newMargin 新的外边距
   */
  public updateMargin(newMargin: LocalizedMargin): void {
    if (this.margin === undefined) {
      this.margin = {};
    }
    if (newMargin.top !== undefined) {
      this.margin.top = newMargin.top;
    }
    if (newMargin.bottom !== undefined) {
      this.margin.bottom = newMargin.bottom;
    }
    if (newMargin.start !== undefined) {
      this.margin.start = newMargin.start;
    }
    if (newMargin.end !== undefined) {
      this.margin.end = newMargin.end;
    }
    this.attribute?.margin(this.margin);
  }

  /**
   * 初始化实例
   *
   * @param instance 实例
   */
  protected initInstance(instance: T): void {
    instance
      .visibility(this.visibility)
      .scale(this.scaleOptions)
      .opacity(this.opacity)
      .enabled(this.enabled);
    if (this.viewId !== undefined) {
      instance.id(this.viewId);
    }
    if (this.zIndex !== undefined) {
      instance.zIndex(this.zIndex);
    }
    if (this.height !== undefined) {
      instance.height(this.height);
    }
    if (this.padding !== undefined) {
      instance.padding(this.padding);
    }
    if (this.margin !== undefined) {
      instance.margin(this.margin);
    }
  }

  /**
   * 直接根据当前状态触发可见性刷新
   */
  private updateVisibility(): void {
    let tempVisibility = this.getIsVisible() ? Visibility.Visible : this.notVisible;
    if (tempVisibility !== this.visibility) {
      this.visibility = tempVisibility;
      this.attribute?.visibility(this.visibility);
    }
  }
}

/**
 * 抽象视图控制器
 *
 * @param V 视图模型类型
 */
@Observed
export abstract class AbstractVc<V extends AbstractVm, U extends BaseAttributeUpdater<T>,
T extends CommonAttribute = CommonAttribute> extends GridStateObserverProxy<V> {
  /**
   * 是否可显示
   */
  @Track public isCanShow: boolean = true;
  /**
   * 是否显示
   */
  @Track public isShow: boolean = false;
  /**
   * 是否在多选模式
   */
  @Track public isSelectMode: boolean = false;
  /**
   * 宫格属性更新器
   */
  @Track public readonly attributeUpdater: U;
  /**
   * 操作状态迁移执行器
   */
  protected readonly operateStp: OperateStateTransferProcessor;
  /**
   * 宫格形态迁移执行器
   */
  protected readonly formStp: FormStateTransferProcessor;
  /**
   * 视图模型
   */
  protected viewModel?: V;
  /**
   * 显示模式
   */
  protected readonly showMode: ShowMode;
  // 操作状态监听
  private readonly operateStataListener: StateChangeCallback<OperateStateType, OperateEventType> =
    (oldState, newState, event): void => this.operateStp.onStateChange(oldState, newState, event);
  // 形态状态监听
  private readonly formStataListener: StateChangeCallback<FormStateType, FormEventType> =
    (oldState, newState, event): void => this.formStp.onStateChange(oldState, newState, event);

  public constructor(attributeUpdater: U, tag?: string, showMode?: ShowMode) {
    super(tag);
    this.attributeUpdater = attributeUpdater;
    this.showMode = showMode ?? ShowMode.ON_TREE;
    this.operateStp = new OperateStateTransferProcessor(tag ?? this.constructor.name);
    this.formStp = new FormStateTransferProcessor(tag ?? this.constructor.name);
  }

  protected override doInit(viewModel: V): void {
    super.doInit(viewModel);
    this.viewModel = viewModel;
    LogUtils.info(this.tag, `doInit persistentId: ${this.persistentId}`);
    this.operateStp.init(this.persistentId);
    this.operateStp.setObserverStateListener((hasObserver: boolean): void => {
      if (hasObserver) {
        this.getOperateState(this.operateStataListener);
      } else {
        this.releaseCallback(this.operateStataListener);
      }
    });
    this.formStp.init(this.persistentId);
    this.formStp.setObserverStateListener((hasObserver: boolean): void => {
      if (hasObserver) {
        this.getFormState(this.formStataListener);
      } else {
        this.releaseCallback(this.formStataListener);
      }
    });
    this.initCommonStates();
    this.initStates();
    this.initOperateFsmObservers();
    this.initFormFsmObservers();
  }

  protected override doRelease(): void {
    LogUtils.info(this.tag, 'doRelease');
    this.releaseStates();
    this.operateStp.setObserverStateListener();
    this.operateStp.release();
    this.formStp.setObserverStateListener();
    this.formStp.release();
    this.releaseCallback(this.operateStp.onStateChange);
    this.releaseCallback(this.formStp.onStateChange);
    super.doRelease();
  }

  /**
   * 初始化状态监听
   */
  protected initStates(): void {
  }

  /**
   * 释放状态监听
   */
  protected releaseStates(): void {
  }

  /**
   * 初始化操作状态机监听器
   */
  protected initOperateFsmObservers(): void {
  }

  /**
   * 初始化形态状态机监听器
   */
  protected initFormFsmObservers(): void {
  }

  /**
   * 横屏状态变化通知
   *
   * @param isHorizontal
   */
  protected onIsHorizontalChange?(isHorizontal: boolean): void;

  /**
   * 查询可见性
   */
  protected isInShowState(): boolean {
    if (this.showMode === ShowMode.ON_TREE) {
      return this.isCanShow && this.isShow;
    } else {
      return this.attributeUpdater.getIsVisible();
    }
  }

  /**
   * 更新可见性
   *
   * @param isShow 是否可见
   * @param reason 更新原因
   */
  protected updateShowState(isShow: boolean, reason?: string): void {
    // 注册显隐监听
    // 注册显隐监听
    if (this.showMode === ShowMode.ON_TREE) {
      if (this.isShow === isShow) {
        return;
      }
      this.isShow = isShow;
    } else {
      this.isShow = true; // 默认不可见，此时设置为直接可见，若组件有其他诉求，可通过isCanShow进行控制
      if (this.attributeUpdater.getIsVisible() === isShow) {
        return;
      }
      this.attributeUpdater.updateVisible(isShow);
    }
    LogUtils.info(this.tag, `updateShowState mode: ${ShowMode[this.showMode]}, isShow: ${isShow}, reason: ${reason}`);
  }

  /**
   * 更新能否可见
   *
   * @param isCanShow 能否可见
   */
  protected updateCanShowState(isCanShow: boolean): void {
    // 注册显隐监听
    LogUtils.info(this.tag, `updateShowState ShowMode: ${ShowMode[this.showMode]}, isCanShow: ${isCanShow}`);
    if (this.showMode === ShowMode.ON_TREE) {
      this.isCanShow = isCanShow;
    } else {
      this.attributeUpdater.updateVisible(undefined, isCanShow);
    }
  }

  private initCommonStates(): void {
    // 监听屏幕方向变化
    this.displayObserverProxy.getIsHorizontal((_oldState, isHorizontal) => {
      this.onIsHorizontalChange?.(isHorizontal);
    });

    // 监听多选模式
    this.getOperateState((_oldState, newState) => {
      this.isSelectMode = OperateStateTypeUtils.isInSelectState(newState);
    });
  }
}