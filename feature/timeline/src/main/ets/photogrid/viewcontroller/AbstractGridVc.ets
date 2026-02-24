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
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { SwitchStartInfo } from '../statemanager/common/SwitchStartInfo';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { SwitchDirection } from '../statemanager/constants/SwitchDefine';
import lazy { FormEventType, FormEventTypeUtils, FormStateType, FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { RestoreFpStateType } from '../statemanager/GridRestoreFpFsm';
import lazy { AbstractGridVm } from '../viewmodel/AbstractGridVm';
import lazy { AbstractFormVc } from './AbstractFormVc';
import lazy { BaseAttributeUpdater } from './AbstractVc';
import lazy { AnimationCurve, AnimationDuration, AnimationOpacity } from './animation/AnimationDefine';
import lazy { LOW_GRID_GAP, ViewId } from './constants/ViewDefine';

/**
 * 宫格属性更新器
 */
export class GridAttributeUpdater extends BaseAttributeUpdater<GridAttribute> {
  /**
   * 缓存数量
   */
  protected cachedCount: number = -1;
  /**
   * 列数模板
   */
  protected columnsTemplate?: string;
  /**
   * 原始背景颜色
   */
  protected originalBgColor?: Resource;

  // 低宫格层级
  private readonly lowZIndex: number;
  // 是否在低宫格层级
  private isLowGrid: boolean = false;
  // 触摸测试模式
  private hitTestMode: HitTestMode = HitTestMode.Default;
  // 宫格列数
  private gridColumn: number = 0;
  // 图片行间距
  private gridGutter: number = 0;
  // 图片列间距
  private gridColumnGutter: number = 0;
  // 是否显示背景色
  private isShowBackground: boolean = true;

  public constructor(viewId: string, zIndex: number, lowZIndex?: number) {
    super(viewId, zIndex);
    this.lowZIndex = lowZIndex ?? zIndex - LOW_GRID_GAP;
  }

  /**
   * 获取当前层级
   *
   * @returns 当前层级
   */
  public getZIndex(): number {
    return this.isLowGrid ? this.lowZIndex : (this.zIndex as number);
  }

  /**
   * 更新是否低宫格
   *
   * @param isLowGrid 是否低宫格
   */
  public updateIsLowGrid(isLowGrid: boolean): void {
    if (this.isLowGrid !== isLowGrid) {
      this.isLowGrid = isLowGrid;
      this.attribute?.zIndex(this.getZIndex());
    }
  }

  /**
   * 更新触摸测试模式
   *
   * @param hitTestMode 触摸测试模式
   */
  public updateHitTestMode(hitTestMode: HitTestMode): void {
    if (this.hitTestMode !== hitTestMode) {
      this.hitTestMode = hitTestMode;
      this.attribute?.hitTestBehavior(this.hitTestMode);
    }
  }

  /**
   * 更新缓存数量
   *
   * @param cachedCount 缓存数量
   */
  public updateCachedCount(cachedCount: number): void {
    if (this.cachedCount !== cachedCount) {
      this.cachedCount = cachedCount;
      this.attribute?.cachedCount(this.cachedCount);
    }
  }

  /**
   * 更新宫格列数
   *
   * @param gridColumn 宫格列数
   */
  public updateGridColumn(gridColumn: number): void {
    this.gridColumn = gridColumn;
    this.attribute?.columnsTemplate(this.getColumnsTemplate());
  }

  /**
   * 更新列数模板
   *
   * @param columnsTemplate 列数模板
   */
  public updateColumnsTemplate(columnsTemplate: string): void {
    this.columnsTemplate = columnsTemplate;
    this.attribute?.columnsTemplate(this.getColumnsTemplate());
  }

  /**
   * 更新宫格行间距
   *
   * @param gridGutter 宫格行间距
   */
  public updateGridGutter(gridGutter: number): void {
    this.gridGutter = gridGutter;
    this.attribute?.rowsGap(this.gridGutter);
  }

  /**
   * 更新宫格列间距
   *
   * @param gridColumnGutter 宫格列间距
   */
  public updateGridColumnGutter(gridColumnGutter: number): void {
    this.gridColumnGutter = gridColumnGutter;
    this.attribute?.columnsGap(this.gridColumnGutter);
  }

  /**
   * 更新是否显示背景色
   */
  public updateShowBackground(isShowBackground: boolean): void {
    if (this.originalBgColor && (this.isShowBackground !== isShowBackground)) {
      this.isShowBackground = isShowBackground;
      this.attribute?.backgroundColor(isShowBackground ? this.originalBgColor : Color.Transparent);
    }
  }

  protected override initInstance(instance: GridAttribute): void {
    super.initInstance(instance);
    instance
      .clip(false)
      .draggable(false)
      .zIndex(this.getZIndex())
      .columnsGap(this.gridColumnGutter)
      .rowsGap(this.gridGutter)
      .columnsTemplate(this.getColumnsTemplate())
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .scrollBar(BarState.Off)
      .hitTestBehavior(this.hitTestMode)
      .alignRules({
        top: { anchor: ViewId.CONTAINER, align: VerticalAlign.Top },
        bottom: { anchor: ViewId.CONTAINER, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
    if (this.cachedCount >= 0) {
      instance.cachedCount(this.cachedCount);
    }
    if (this.originalBgColor) {
      instance.backgroundColor(this.isShowBackground ? this.originalBgColor : Color.Transparent);
    }
  }

  private getColumnsTemplate(): string {
    return this.columnsTemplate ?? '1fr '.repeat(this.gridColumn);
  }
}

/**
 * 抽象宫格视图控制器
 */
@Observed
export abstract class AbstractGridVc<V extends AbstractGridVm, U extends GridAttributeUpdater>
  extends AbstractFormVc<V, U, GridAttribute> {
  /**
   * 宫格布局参数
   */
  @Track public gridLayoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [0],
  };
  /**
   * 宫格不规则头高度
   */
  @Track public headHeight: number = 0;
  /**
   * 宫格底部高度
   */
  @Track public tailHeight: number = 0;

  // 记录最后收到的补位数
  private lastFillPosition: number = 0;
  private isShowCard: boolean = false;
  private cameraAuthCardShow: boolean = false;
  private cloudDriveStatus: boolean = true;

  /**
   * 日视图切换到月视图时候释放ImageGridItemComponent节点进复用池
   */
  public updateRecycleGridItemSate(state: boolean): void {
  }

  public updateCloudSwitchState(cloudDriveStatus: boolean): void {
    this.cloudDriveStatus = cloudDriveStatus;
  }

  protected override initStates(): void {
    super.initStates();

    // 初始化消息头和宫格尾部高度
    if (this.gridObserverProxy.config.isSupportHeadMsg || this.gridObserverProxy.config.isSupportOtherIrregular) {
      this.gridObserverProxy.getIrregularHeight(this.gridForm, (_oldState, irregularHeight) => {
        // 临时方案，后续云同步卡片移入IrregularView后，可以去掉
        if (this.gridObserverProxy.getIrregularCount(this.gridForm) > 1) {
          this.headHeight = this.gridObserverProxy.getHeadMsgHeight() -
            this.gridObserverProxy.getGridImageGutter(this.gridForm);
        } else {
          this.headHeight = irregularHeight - this.gridObserverProxy.getGridImageGutter(this.gridForm);
        }
      });
    }
    this.gridObserverProxy.getBottomHeight((_oldState, bottomHeight) => {
      this.tailHeight = bottomHeight;
    });

    // 初始化缓存数量
    this.gridObserverProxy.getCachedCount(this.gridForm, (_oldState, cachedCount) => {
      this.attributeUpdater.updateCachedCount(cachedCount);
    });

    this.registerAnimationListeners();

    this.registerFillPositionObserver();

    // 更新相机地理权限提醒卡片显示状态
    this.gridObserverProxy.getCameraCardShowState((_oldState, isCameraCardShow) => {
      LogUtils.info(this.tag, `getCameraCardShowState:${this.cameraAuthCardShow} ${isCameraCardShow}`);
      this.cameraAuthCardShow = isCameraCardShow;
    });
  }

  protected override updateShowState(isShow: boolean, reason?: string): void {
    super.updateShowState(isShow, reason);
    LogUtils.info(this.tag, `GRID_SWITCH updateShowState isShow: ${isShow}, reason: ${reason}`);
    this.attributeUpdater.updateIsLowGrid(!isShow);
    this.attributeUpdater.updateHitTestMode(isShow ? HitTestMode.Default : HitTestMode.Block);
  }

  protected override onIsHorizontalChange(isHorizontal: boolean): void {
    this.attributeUpdater.updateIsHorizontal(isHorizontal);
  }

  protected override initFormFsmObservers(): void {
    // 跟手动作
    this.registerFollowHandArriveAction();
    this.registerFollowHandLeaveAction();
    this.registerLeaveHandAction();

    // 切换动作
    this.registerSwitchArriveAction();
    this.registerSwitchLeaveAction();
    this.registerSwitchOverAction();
  }

  /**
   * 注册跟手到达动作
   */
  protected registerFollowHandArriveAction(): void {
    this.formStp.registerObserver({
      actionName: 'FollowHandArrive',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType): boolean => {
        return !FormStateTypeUtils.isInFormState(oldState, this.gridForm) &&
        FormStateTypeUtils.isInFormState(newState, this.gridForm) &&
        FormStateTypeUtils.isInFollowHandState(newState);
      },
      isAnimateImmediately: () => true,
      animationParam: (oldState: FormStateType, newState: FormStateType, event?: FormEventType):
        AnimateParam | undefined => {
        if (FormStateTypeUtils.isLargerFrom(oldState, newState)) {
          // 从大宫格切换到当前小宫格，无须动效，直接出现
          return undefined;
        }
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.SHARP_CURVE,
          duration: FormEventTypeUtils.isQuickPinchEvent(event ?? FormEventType.NONE) ?
            AnimationDuration.QUICK_PINCH : AnimationDuration.SLOW_PINCH,
          onFinish: () => {
            LogUtils.info('AbstractGridVc', `FollowHandArrive onFinish`);
          }
        }
      },
      prepareAction: () => {
        LogUtils.info('AbstractGridVc', `FollowHandArrive prepareAction`);
        this.restoreZIndex();
        this.attributeUpdater.updateShowBackground(true);
        this.updateRecycleGridItemSate(false);
      },
      targetAction: (): void => {
        this.updateGridOpacity(true);
      }
    });
  }

  /**
   * 注册跟手离开动作
   */
  protected registerFollowHandLeaveAction(): void {
    this.formStp.registerObserver({
      actionName: 'FollowHandLeave',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType): boolean => {
        return FormStateTypeUtils.isInFormState(oldState, this.gridForm) &&
          FormStateTypeUtils.isLargerFrom(oldState, newState) &&
          FormStateTypeUtils.isInFollowHandState(newState);
      },
      isAnimateImmediately: () => true,
      animationParam: (_oldState: FormStateType, _newState: FormStateType, event?: FormEventType): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.SHARP_CURVE,
          duration: FormEventTypeUtils.isQuickPinchEvent(event ?? FormEventType.NONE) ?
          AnimationDuration.QUICK_PINCH : AnimationDuration.SLOW_PINCH
        }
      },
      prepareAction: (): void => {
        this.attributeUpdater.updateEnable(false);
        this.attributeUpdater.updateShowBackground(false);
      },
      targetAction: (): void => {
        // 从当前大宫格切换到小宫格，大宫格需要隐藏
        this.attributeUpdater.updateOpacity(AnimationOpacity.TRANSPARENT);
      }
    });
  }

  /**
   * 注册离手动作
   */
  protected registerLeaveHandAction(): void {
    this.formStp.registerObserver({
      actionName: 'LeaveHand',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType): boolean => {
        return FormStateTypeUtils.isInFollowHandState(oldState) && !FormStateTypeUtils.isInFollowHandState(newState);
      },
      isAnimateImmediately: () => true,
      animationParam: (_oldState: FormStateType, newState: FormStateType): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.LEAVE_HAND_CURVE,
          onFinish: () => {
            if (FormStateTypeUtils.isInFormState(newState, this.gridForm)) {
              this.viewModel?.notifyPinchAnimationEnd();
            }
            this.attributeUpdater.updateShowBackground(false);
            LogUtils.info('AbstractGridVc', `LeaveHand onFinish`);
          }
        }
      },
      prepareAction: (oldState: FormStateType, newState: FormStateType): void => {
        LogUtils.info('AbstractGridVc', `LeaveHand prepareAction`);
        if (!FormStateTypeUtils.isInFormState(oldState, this.gridForm) &&
          FormStateTypeUtils.isInFormState(newState, this.gridForm)) {
          // 此场景说明跳过了跟手到达，需要补齐跟手到达的动作
          this.restoreZIndex();
          this.updateGridOpacity(true);
        }
      },
      targetAction: (): void => {
        this.updateScaleToTarget(this.pinchObserverProxy.switchStartInfo);
      }
    });
  }

  /**
   * 注册切换到达动作
   */
  protected registerSwitchArriveAction(): void {
    this.formStp.registerObserver({
      actionName: 'SwitchArriveScale',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): boolean => {
        let currentState = FormStateTypeUtils.getStateTypeFromForm(this.gridForm);
        return oldState !== currentState && newState === currentState && FormEventTypeUtils.isSwitchEvent(event);
      },
      isNeedAnimation: () => this.switchObserverProxy.config.isSupportSwitchAnimate,
      isAnimateImmediately: () => false,
      animationParam: (): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.LEAVE_HAND_CURVE,
          onFinish: () => {
            this.viewModel?.notifySwitchAnimationEnd();
            this.updateCameraCardOpacity();
            this.canShowCloudCard();
          }
        }
      },
      targetAction: (): void => {
        this.updateScaleToTarget(this.switchObserverProxy.switchStartInfo);
        if (!this.switchObserverProxy.config.isSupportSwitchAnimate) {
          this.viewModel?.notifySwitchAnimationEnd();
        }
      }
    });

    this.formStp.registerObserver({
      actionName: 'SwitchArriveOpacity',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): boolean => {
        let currentState = FormStateTypeUtils.getStateTypeFromForm(this.gridForm);
        return oldState !== currentState && newState === currentState && FormEventTypeUtils.isSwitchEvent(event);
      },
      isNeedAnimation: () => this.switchObserverProxy.config.isSupportSwitchAnimate,
      isAnimateImmediately: () => false,
      animationParam: (): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.SHARP_CURVE,
          duration: AnimationDuration.SWITCH,
        }
      },
      prepareAction: () => {
        this.restoreZIndex();
        this.attributeUpdater.updateShowBackground(true);
        this.updateRecycleGridItemSate(false);
      },
      targetAction: (): void => {
        this.attributeUpdater.updateShowBackground(true);
        this.updateGridOpacity(true);
      }
    });
  }

  protected async canShowCloudCard(): Promise<void> {
  }

  protected updateCameraCardOpacity(): void {
    if (this.gridObserverProxy.config.isShowCameraCard && this.cameraAuthCardShow &&
      (this.gridForm === FormIndex.DAY || this.gridForm === FormIndex.GROUP_DAY)) {
      this.proxy.gridStateManager.updateCameraCardOpacityAsm.updateState(1, 'Show After Switching');
    }
  }

  /**
   * 注册切换离开动作
   */
  protected registerSwitchLeaveAction(): void {
    this.formStp.registerObserver({
      actionName: 'SwitchLeaveScale',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): boolean => {
        let currentState = FormStateTypeUtils.getStateTypeFromForm(this.gridForm);
        return oldState === currentState && newState !== currentState && FormEventTypeUtils.isSwitchEvent(event);
      },
      isNeedAnimation: () => this.switchObserverProxy.config.isSupportSwitchAnimate,
      isAnimateImmediately: () => false,
      animationParam: (): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.LEAVE_HAND_CURVE,
        }
      },
      targetAction: (): void => {
        this.updateScaleToTarget(this.switchObserverProxy.switchStartInfo);
      }
    });

    this.formStp.registerObserver({
      actionName: 'SwitchLeaveOpacity',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): boolean => {
        let currentState = FormStateTypeUtils.getStateTypeFromForm(this.gridForm);
        return oldState === currentState && newState !== currentState && FormEventTypeUtils.isSwitchEvent(event);
      },
      isNeedAnimation: () => this.switchObserverProxy.config.isSupportSwitchAnimate,
      isAnimateImmediately: () => false,
      animationParam: (): AnimateParam => {
        return {
          finishCallbackType: FinishCallbackType.LOGICALLY,
          curve: AnimationCurve.SHARP_CURVE,
          duration: AnimationDuration.SWITCH,
        }
      },
      prepareAction: (oldState: FormStateType, newState: FormStateType): void => {
        this.attributeUpdater.updateEnable(false);
        if (!this.switchObserverProxy.config.isSupportSwitchAnimate ||
          FormStateTypeUtils.isLargerFrom(oldState, newState)) {
          this.attributeUpdater.updateShowBackground(false);
        }
      },
      targetAction: (oldState: FormStateType, newState: FormStateType): void => {
        if (!this.switchObserverProxy.config.isSupportSwitchAnimate ||
          FormStateTypeUtils.isLargerFrom(oldState, newState)) {
          this.attributeUpdater.updateShowBackground(false);
          this.updateGridOpacity(false);
        }
      }
    });
  }

  /**
   * 注册切换不涉及场景的动作
   */
  protected registerSwitchOverAction(): void {
    this.formStp.registerObserver({
      actionName: 'SwitchOver',
      isStateTransferMatched: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): boolean => {
        // 大宫格切小宫格，跨过当前当前宫格
        let oldForm: FormIndex = FormStateTypeUtils.getFormFromStateType(oldState);
        let newForm: FormIndex = FormStateTypeUtils.getFormFromStateType(newState);
        return oldForm !== newForm && oldForm !== this.gridForm && newForm !== this.gridForm &&
        FormEventTypeUtils.isSwitchEvent(event);
      },
      isNeedAnimation: () => this.switchObserverProxy.config.isSupportSwitchAnimate,
      targetAction: (): void => {
        this.attributeUpdater.updateIsLowGrid(true);

        // 刷新scale到目标大小
        this.updateScaleToTarget(this.switchObserverProxy.switchStartInfo);
      }
    });
  }

  /**
   * 注册补位监听
   */
  protected registerFillPositionObserver(): void {
    if (!this.gridObserverProxy.getIsSupportFp(this.gridForm)) {
      return;
    }

    this.gridObserverProxy.getRestoreFpState(this.gridForm, (_oldState, restoreFpState) => {
      switch (restoreFpState) {
        case RestoreFpStateType.IDLE_STATE:
        case RestoreFpStateType.FILL_POSITION_STATE:
          this.updateFillPosition();
          break;
        case RestoreFpStateType.ANIMATION_READY_STATE:
          this.doRestoreAnimation();
          break;
      }
    });
  }

  /**
   * 更新补位
   *
   * @param fillPosition 新的补位数
   */
  protected doUpdateFillPosition(fillPosition: number): void {
    LogUtils.info(this.tag, `doUpdateFillPosition: ${fillPosition}`);
    this.viewModel?.notifyDataReloaded();
  }

  private updateFillPosition(): void {
    const fillPosition = this.gridObserverProxy.getFillPostion(this.gridForm);
    if (this.lastFillPosition !== fillPosition) {
      this.lastFillPosition = fillPosition;
      this.doUpdateFillPosition(fillPosition);
    }
  }

  private doRestoreAnimation(): void {
    this.updateFillPosition();
    this.attributeUpdater.updateShowBackground(false);
    this.updateGridOpacity(false);
    animateTo({
      duration: AnimationDuration.RESTORE_FILL_POSITION,
      curve: AnimationCurve.SHARP_CURVE,
    }, () => {
      this.attributeUpdater.updateShowBackground(true);
      this.updateGridOpacity(true);
    });
  }

  private registerAnimationListeners(): void {
    this.pinchObserverProxy.getGridPinchScale(this.gridForm, (_oldState, newState) => {
      if (!FormStateTypeUtils.isInFollowHandState(this.getFormState())) {
        // 非跟手态不处理
        return;
      }
      this.attributeUpdater.updateScale({
        x: newState,
        y: newState,
        centerX: this.pinchObserverProxy.switchStartInfo?.anchorCenterX,
        centerY: this.pinchObserverProxy.switchStartInfo?.anchorCenterY,
      });
    });

    this.pinchObserverProxy.registerEventListener({
      onPinchWillArrive: (formIndex, direction) => this.onGridWillArrive(formIndex, direction),
    });

    this.switchObserverProxy.registerEventListener({
      onSwitchWillArrive: (formIndex, direction) => this.onGridWillArrive(formIndex, direction),
    });

    // 初始化放缩系数
    this.getFormState((oldState, newState) => {
      if (!FormStateTypeUtils.isHasDataState(oldState) && FormStateTypeUtils.isHasDataState(newState)) {
        this.updateScaleToTarget();
      }
    });
  }

  private updateScaleToTarget(switchStartInfo?: SwitchStartInfo): void {
    let targetScale: number = this.gridObserverProxy.getFormTargetScale(this.gridForm);
    this.attributeUpdater.updateScale({
      x: targetScale,
      y: targetScale,
      centerX: switchStartInfo?.anchorCenterX ?? 0,
      centerY: switchStartInfo?.anchorCenterY ?? 0,
    });
  }

  private onGridWillArrive(formIndex: FormIndex, direction?: SwitchDirection): void {
    if (formIndex === this.gridForm && direction === SwitchDirection.SCALE_DOWN) {
      this.restoreZIndex();
      this.attributeUpdater.updateShowBackground(true);
      this.updateGridOpacity(true);
    } else {
      this.handlePreJumpOverSwitch(formIndex);
    }
  }

  private handlePreJumpOverSwitch(targetForm: FormIndex): void {
    // 从大宫格向小宫格捏合时，如果跨层级，即层级跨度超过2，隐藏大宫格避免左右平移跳变，当前透明度动效无法打断，所以使用zIndex隐藏界面。
    if (this.gridForm - targetForm >= 2) {
      LogUtils.info(this.tag, `JumpOver hide form: ${this.gridForm}`);
      this.attributeUpdater.updateIsLowGrid(true);
    }
  }

  private updateGridOpacity(isShow: boolean): void {
    this.attributeUpdater.updateOpacity(isShow ? AnimationOpacity.DEFAULT : AnimationOpacity.TRANSPARENT);
  }

  private restoreZIndex(): void {
    this.attributeUpdater.updateIsLowGrid(false);
    this.attributeUpdater.updateEnable(true);
  }
}