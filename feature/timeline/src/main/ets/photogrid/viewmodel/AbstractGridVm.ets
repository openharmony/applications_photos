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
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy {
  FormIndex,
  IrregularType,
  ScrollReason,
  MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM
} from '../statemanager/constants/GridDefine';
import lazy { FormEventTypeUtils, FormStateType, FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { GridShowEventType } from '../statemanager/GridShowFsm';
import lazy { SwitchStateUpdateParams } from '../statemanager/SwitchStateManager';
import lazy { OptionType, ReportUtils } from './utils/ReportUtils';
import lazy { SwitchStartInfo, SwitchType } from '../statemanager/common/SwitchStartInfo';
import lazy { SwitchStartUtils } from './utils/SwitchStartUtils';
import lazy { AlignMode, SwitchCalcUtils } from './utils/SwitchCalcUtils';
import lazy { AbstractScrollVm } from './AbstractScrollVm';
import lazy { ViewId } from '../viewcontroller/constants/ViewDefine';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';

const OPEN_OTHER_CONTENT_DURATION: number = 100;
const FOCUS_DELAY: number = 300;

/**
 * 抽象宫格视图模型
 */
export abstract class AbstractGridVm extends AbstractScrollVm {
  /**
   * 支持的不规则区域类型
   */
  protected readonly supportIrregularTypes: IrregularType[] = [IrregularType.HEAD_MSG];

  // 是否滑动保持显示
  private isSwitchKeepShow: boolean = this.getIsKeepShow();

  // 云服务卡片高度
  private cloudCardHeight: number = 0;

  // 相机地理位置权限卡片高度
  private cameraAuthLocationCardHeight: number = 0;

  // 人像不规则预期高度
  private portraitSwiperHeight: number = 0;

  /**
   * 通知切换动效结束
   */
  public notifySwitchAnimationEnd(): void {
    // 当前状态为结束状态时, 允许通知捏合动效结束
    if (this.stateProxy.formFsm.getCurrentForm() === this.gridForm) {
      this.stateProxy.switchStateManager.notifyAnimationFinished(this.gridForm);

      // 更新切换中状态
      this.handleSwitchEnd(this.switchObserverProxy.switchStartInfo?.switchType ?? SwitchType.SWITCH_BUTTON);
    }
  }

  /**
   * 通知捏合动效结束
   */
  public notifyPinchAnimationEnd(): void {
    // 当前状态为结束状态时, 允许通知捏合动效结束
    if (this.stateProxy.formFsm.getCurrentForm() === this.gridForm) {
      this.stateProxy.pinchStateManager.notifyAnimationFinished(this.gridForm);

      // 更新切换中状态
      this.handleSwitchEnd(this.pinchObserverProxy.switchStartInfo?.switchType ?? SwitchType.PINCH_GRID);
    }
  }

  /**
   * 处理单指点击事件
   *
   * @param event 点击事件
   * @param focusIndex 无障碍主动获焦
   * @param anchorIndex 无障碍指定切换锚点
   */
  public handleSingleTapEvent(event: GestureEvent, focusIndex?: number, anchorIndex?: number): void {
    let currentForm: FormIndex = this.currentForm;
    let targetForm: FormIndex = this.currentForm + 1;
    if (targetForm === FormIndex.DAY && this.stateProxy.formFsm.isLastDayFormIsDayGroup()) {
      targetForm = FormIndex.GROUP_DAY;
    }
    let switchParams = this.buildSwitchParams(targetForm, currentForm, event, anchorIndex);
    if (switchParams === undefined) {
      return;
    }

    // 记录TRACE
    if (!this.gridObserverProxy.getIsSwitching()) {
      TraceUtils.startTrace(TraceTaskType.GRID_SWITCH);
    }
    // 更新切换中状态
    this.gridStateManager.isSwitchingAsm.updateState(true, SwitchType.CLICK_GRID);
    // 更新切换状态
    this.switchStateManager.updateSwitchState(switchParams);
    // 提交切换事件
    this.stateProxy?.formFsm.submitEvent(FormEventTypeUtils.getSwitchEventTypeFromForm(targetForm));
    // 主动聚焦动作
    this.sendFocusAccessibilityEvent(focusIndex);
    // 切换打点
    ReportUtils.reportFormChange(currentForm, targetForm, OptionType.VIEW);
  }

  /**
   * 更新云同步卡片高度（注：后续切换至新方案时，直接使用updateIrregularTypeHeight进行更新，部分遗留代码需要同步清除）
   *
   * @param cardHeight 卡片高度
   * @param reason 更新原因
   */
  public updateCloudCardHeight(cardHeight: number, reason?: string): void {
    this.cloudCardHeight = cardHeight > 0 ? cardHeight + this.gridObserverProxy.getGridImageGutter() : 0;
    this.updateIrregularHeight(reason);
  }

  /**
   * 更新相机地理位置权限卡片高度（注：后续切换至新方案时，直接使用updateIrregularTypeHeight进行更新，部分遗留代码需要同步清除）
   *
   * @param cardHeight 卡片高度
   * @param reason 更新原因
   */
  public updateCameraAuthLocationCardHeight(cardHeight: number, reason?: string): void {
    this.cameraAuthLocationCardHeight = cardHeight > 0 ? cardHeight + this.gridObserverProxy.getGridImageGutter() : 0;
    this.updateIrregularHeight(reason);
  }

  /**
   * 更新云同步卡片高度（注：后续切换至新方案时，直接使用updateIrregularTypeHeight进行更新，部分遗留代码需要同步清除）
   *
   * @param cardHeight 卡片高度
   * @param reason 更新原因
   */
  public updatePortraitSwiperHeight(cardHeight: number, reason?: string): void {
    this.portraitSwiperHeight = cardHeight > 0 ? cardHeight + this.gridObserverProxy.getGridImageGutter() : 0;
    this.updateIrregularHeight(reason);
  }

  /**
   * 更新不规则区域数量
   *
   * @param isShow 是否可见
   * @param irregularType 不规则区域类型
   */
  public updateIrregularCount(isShow: boolean, irregularType: string): void {
    LogUtils.info(this.tag, `updateIrregularCount isShow:${isShow} irregularType:${irregularType}`);
    this.gridStateManager.getIrregularCountManager(this.gridForm).updateState(isShow ? 2 : 1, this.tag);
  }

  /**
   * 更新相机地理权限卡片是否可见
   *
   * @param isShow 是否可见
   */
  public updateCameraCardShowState(isShow: boolean): void {
    this.gridStateManager.cameraCardShowStateAsm.updateState(isShow, 'updateCameraCardShowState');
  }

  /**
   * 通知数据重新加载
   */
  public notifyDataReloaded(): void {
    LogUtils.info(this.tag, 'notifyDataReloaded');
    this.dataSource.onDataReloaded();
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.initShowState();
    this.registerObservers();
    this.registerEventListeners();
    // 启动时更新日期标题
    if (this.totalCount() > 0) {
      this.updateCurrentTime(0);
    }
  }

  protected offsetChanged(firstIndex: number, scrollChange: boolean): void {
  }

  private initShowState(): void {
    this.gridShowFsm.submitEvent(
      this.isInCurrentForm() ? GridShowEventType.DIRECTION_SHOW : GridShowEventType.DIRECTION_HIDE);

    this.getFormState((oldState: FormStateType, newState: FormStateType): void => {
      if (FormStateTypeUtils.isHasDataState(oldState) && !FormStateTypeUtils.isHasDataState(newState)) {
        this.gridShowFsm.submitEvent(GridShowEventType.DIRECTION_HIDE);
      } else if (this.isInCurrentForm()) {
        this.updateCurrentTime(this.firstIndexInGrid);
        this.gridShowFsm.submitEvent(GridShowEventType.DIRECTION_SHOW);
      }
    });
  }

  private registerObservers(): void {
    this.switchObserverProxy.getSwitchIsTouched((): void => this.updateIsKeepShow());

    // 不规则高度监听
    let irregularHeight: number = 0;
    for (let irregularType of this.supportIrregularTypes) {
      irregularHeight += this.gridObserverProxy.getIrregularTypeHeight(irregularType, () => {
        this.updateIrregularHeight(`${IrregularType[irregularType]}HeightChange`);
      }, false);
    }
    this.updateIrregularHeight(this.tag, irregularHeight);

    // 宫格高度监听
    if (this.gridForm !== FormIndex.GROUP_DAY) {
      this.registerDataSourceListener({ onDataUpdate: () => this.updateGridHeight() });
      this.gridObserverProxy.getFillPostion(this.gridForm, () => this.updateGridHeight());
      this.gridObserverProxy.getGridImageHeight(this.gridForm, () => this.updateGridHeight());
      this.gridObserverProxy.getGridImageGutter(this.gridForm, () => this.updateGridHeight());
      this.gridObserverProxy.getGridColumn(this.gridForm, () => this.updateGridHeight());
    }

    // 判断进入或退出沉浸态
    this.gridObserverProxy.getScrollOffset(this.gridForm, () => this.updateImmersiveState('ScrollOffsetChange'));

    // 判断清空补位信息
    if (this.gridObserverProxy.getIsSupportFp(this.gridForm)) {
      this.gridObserverProxy.getIsSwitching(() => this.updateFillPostion());
      this.gridObserverProxy.getIsImmersive(() => this.updateFillPostion());
    }
  }

  private updateGridHeight(): void {
    const imageCount = this.totalCount();
    const fillPosition = this.gridObserverProxy.getFillPostion(this.gridForm);
    const gridColumn = this.gridObserverProxy.getGridColumn(this.gridForm);
    const gridImageHeight = this.gridObserverProxy.getGridImageHeight(this.gridForm);
    const gridImageGutter = this.gridObserverProxy.getGridImageGutter(this.gridForm);
    const gridHeight = Math.ceil((imageCount + fillPosition) / gridColumn) * (gridImageHeight + gridImageGutter);
    this.gridStateManager.getGridHeightManager(this.gridForm).updateState(gridHeight, this.tag);
  }

  private registerEventListeners(): void {
    this.switchObserverProxy.registerEventListener({
      // 切换即将到达时，则显示
      onSwitchWillArrive: (formIndex: FormIndex): void => {
        if (formIndex === this.gridForm) {
          this.gridShowFsm.submitEvent(GridShowEventType.WILL_SHOW);
        }
      },

      // 切换动效结束时，非当前视图不显示
      onSwitchEndAnimation: (formIndex: FormIndex): void => {
        if (formIndex !== this.gridForm) {
          this.gridShowFsm.submitEvent(this.isSwitchKeepShow ? GridShowEventType.OTHER_KEEP_SHOW_END_ANIMATION :
          GridShowEventType.OTHER_END_ANIMATION);
        }
      },

      // 形态切换前，处理补位和滑动
      onPreFromSwitch: (targetForm: FormIndex): void => {
        if (this.gridForm === targetForm) {
          this.handlePreFormSwitch(this.switchStateManager.switchStartInfo);
        }
      },
    });

    this.pinchObserverProxy.registerEventListener({
      // 捏合即将到达时，处在捏合态，则显示
      onPinchWillArrive: (formIndex: FormIndex): void => {
        if (formIndex === this.gridForm) {
          this.gridShowFsm.submitEvent(GridShowEventType.WILL_SHOW);

          if (!this.isInCurrentForm()) {
            this.handlePreFormSwitch(this.pinchStateManager.switchStartInfo, true);
          }
        }
      },

      // 捏合动效结束时，非当前视图不显示
      onPinchEndAnimation: (formIndex: FormIndex): void => {
        if (formIndex !== this.gridForm) {
          this.gridShowFsm.submitEvent(GridShowEventType.OTHER_END_ANIMATION);
        }
      },

      // 形态切换前，处理补位和滑动，兜底操作
      onPreFromSwitch: (targetForm: FormIndex): void => {
        if (this.gridForm === targetForm) {
          this.handlePreFormSwitch(this.pinchStateManager.switchStartInfo, true);
        }
      },
    });
  }

  private updateIrregularHeight(reason?: string, inIrregularHeight?: number): void {
    let irregularHeight: number = 0;
    if (inIrregularHeight !== undefined) {
      irregularHeight = inIrregularHeight;
    } else {
      for (let irregularType of this.supportIrregularTypes) {
        irregularHeight += this.gridObserverProxy.getIrregularTypeHeight(irregularType);
      }
    }
    irregularHeight += this.cloudCardHeight; // 当前云同步卡片高度单独处理
    irregularHeight += this.cameraAuthLocationCardHeight; // 当前相机地理位置卡片高度单独处理
    irregularHeight += this.portraitSwiperHeight;
    this.gridStateManager.getIrregularHeightManager(this.gridForm).updateState(irregularHeight, reason);
  }

  private updateFillPostion(): void {
    // 非切换中，非沉浸态时，清空补位信息
    if (!this.gridObserverProxy.getIsSwitching() && !this.gridObserverProxy.getIsImmersive() &&
      this.gridObserverProxy.getFillPostion() > 0) {
      this.gridStateManager.getFillPositionManager().updateState(0, 'handleSwitchEnd');
    }
  }

  private getIsKeepShow(): boolean {
    return this.switchStateManager.switchIsTouchedAsm.currentState;
  }

  private updateIsKeepShow(): void {
    let isKeepShow: boolean = this.getIsKeepShow();
    if (this.isSwitchKeepShow !== isKeepShow) {
      this.isSwitchKeepShow = isKeepShow;
      if (!isKeepShow) {
        this.gridShowFsm.submitEvent(GridShowEventType.CANCEL_KEEP_SHOW);
      }
    }
  }

  private buildSwitchParams(targetForm: FormIndex, currentForm: FormIndex, event: GestureEvent, anchorIndex?: number):
    SwitchStateUpdateParams | undefined {
    let switchParams: SwitchStateUpdateParams = {
      targetForm: targetForm,
      currentForm: currentForm,
    };
    if (!AccessibilityUtil.isOpenTouchGuideSync()) {
      // 开启触摸浏览时，fingerInfo在Gesture状态下为undefined，导致单指双击无效
      const fingerList: FingerInfo[] = isFilterListEmpty(event.fingerList);
      if (!fingerList || fingerList.length === 0) {
        LogUtils.error(this.tag, 'TapGesture fingerList Empty');
        return undefined;
      }
      const startInfo = SwitchStartUtils.buildClickGridStartInfo(this, fingerList[0].localX, fingerList[0].localY);
      if (startInfo.anchorItemIndex < 0) {
        // 说明点击处没有图片，此时按照规格，不执行跳转
        return undefined;
      }
      switchParams.switchStartInfo = startInfo;
    } else {
      // 开启触摸浏览时，根据event.target.area.position获取获焦组件的偏移量
      let accessibilityPosition = event.target?.area?.position;
      let localY = typeof accessibilityPosition.y === "number" ? accessibilityPosition.y : 0;
      if (localY !== 0) {
        // 获焦为一个GridItem
        let localX = typeof accessibilityPosition.x === "number" ? accessibilityPosition.x : 0;
        const startInfo = SwitchStartUtils.buildClickGridStartInfo(this, localX, localY, anchorIndex);
        switchParams.switchStartInfo = startInfo;
      } else {
        // 获焦为整个图
        switchParams.switchStartInfo = SwitchStartUtils.buildButtonSwitchStartInfo(this);
      }
    }
    return switchParams;
  }

  private sendFocusAccessibilityEvent(focusIndex?: number) {
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      switch (this.currentForm) {
        case FormIndex.MONTH:
          if (focusIndex !== undefined) {
            // 从年视图GridItem跳转月视图时获焦到GridItem上
            let elementId = `${ViewId.MONTH_GRID_ITEM}_${focusIndex.toString()}`;
            AccessibilityUtil.sendFocusAccessibilityEvent(elementId, FOCUS_DELAY);
          } else {
            AccessibilityUtil.sendFocusAccessibilityEvent(ViewId.MONTH_GRID, FOCUS_DELAY);
          }
          break;
        case FormIndex.DAY:
          if (focusIndex !== undefined) {
            // 从月视图GridItem跳转日视图时获焦到GridItem上
            let elementId = `photoGridView_gird_${focusIndex.toString()}`;
            AccessibilityUtil.sendFocusAccessibilityEvent(elementId, FOCUS_DELAY);
          } else {
            AccessibilityUtil.sendFocusAccessibilityEvent(ViewId.DAY_GRID, FOCUS_DELAY);
          }
          break;
        case FormIndex.GROUP_DAY:
          if (focusIndex !== undefined) {
            // 从月视图GridItem跳转日组视图时获焦到GridItem上
            let layoutIndex = this.stateProxy.dataSourceManager.groupDayDataSource.dataToLayout(focusIndex);
            let elementId = `photoGridView_gird_${layoutIndex.toString()}`;
            AccessibilityUtil.sendFocusAccessibilityEvent(elementId, FOCUS_DELAY);
          } else {
            AccessibilityUtil.sendFocusAccessibilityEvent(ViewId.GROUP_DAY_GRID, FOCUS_DELAY);
          }
          break;
      }
    }
  }

  private handleSwitchEnd(switchType: SwitchType): void {
    // 更新切换中状态
    this.gridStateManager.isSwitchingAsm.updateState(false, switchType);

    // 清除切换信息
    this.switchStateManager.clearStartInfo();

    // 记录TRACE
    TraceUtils.finishTrace(TraceTaskType.GRID_SWITCH);
  }

  private handlePreFormSwitch(startInfo?: SwitchStartInfo, fromPinch?: boolean): void {
    if (!startInfo) {
      LogUtils.warn(this.tag, 'GRID_SWITCH handlePreFormSwitch invalid params.');
      return;
    }

    let fromIndex = Math.min(this.currentForm, this.gridForm);
    if (startInfo.isAnchorCenterXCached(fromIndex)) {
      startInfo.setCachedAnchorCenterX(fromIndex);
      LogUtils.debug(this.tag, `GRID_SWITCH use cached ${FormIndex[fromIndex]} startInfo ${startInfo}`);
      return;
    }

    const calcResult = SwitchCalcUtils.calcSwitch({
      startInfo: startInfo,
      observerProxy: this,
      startForm: this.currentForm,
      targetForm: this.gridForm,
      anchorAlignMode: startInfo._switchType === SwitchType.SWITCH_BUTTON ? AlignMode.TOP : AlignMode.MIDDLE,
    });

    if (calcResult === undefined) {
      return;
    }

    // 更新日视图或者日分组视图是否允许更新滑窗
    this.dataSourceManager.updateSlidingWindowState(this.gridForm);
    // 更新补位信息
    this.gridStateManager.getFillPositionManager(this.gridForm).updateState(calcResult.fillPosition, this.tag);
    // 触发数据预加载，补位影响数据预加载，因此放在更新补位后
    this.triggerPreloadViewData(this.convertFirstIndex(calcResult.firstIndex),
      `${FormIndex[this.currentForm]}->${FormIndex[this.gridForm]}`);

    if (fromPinch) {
      let scrollChange =
        (calcResult.scrollOffset != this.gridStateManager.getScrollOffsetManager(this.gridForm).currentState)
      this.offsetChanged(fromIndex, scrollChange);
    }
    // 更新滚动距离
    this.gridStateManager.getScrollOffsetManager(this.gridForm).updateState(calcResult.scrollOffset,
      ScrollReason.SWITCH);
    // 更新锚点中心X轴坐标
    startInfo.setCachedAnchorCenterX(fromIndex, calcResult.centerX);
    // 更新首个可见宫格
    this.gridStateManager.getFirstIndexManager(this.gridForm).updateState(calcResult.firstIndex, this.tag);
  }

  private convertFirstIndex(firstIndex: number) {
    return this.gridForm === FormIndex.YEAR || this.gridForm === FormIndex.MONTH ?
      Math.floor(firstIndex / (this.gridObserverProxy.getGridColumn(this.gridForm)
        * MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM)) : firstIndex;
  }
}