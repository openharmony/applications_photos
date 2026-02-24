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

import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { DataSourceListener } from '../model/DataSourceManager';
import lazy { FormEventType, FormEventTypeUtils, FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { OperateEventType, OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { PreloadEventType, PreloadStateTypeUtils } from '../statemanager/GridPreloadFsm';
import lazy { AbstractVm } from './AbstractVm';
import lazy { SwitchCommonUtils } from './utils/SwitchCommonUtils';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';
import lazy { GridToolBarPosition } from '../../photogrid/statemanager/constants/ToolBarDefine';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SwitchMode } from '../statemanager/constants/SwitchDefine';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { accessibility } from '@kit.AccessibilityKit';

const PRELOAD_TIMEOUT_MILLIS: number = 300; // 预加载超时时间 为低端产品调整从150到300 待修改为可配置项
const HIDE_PREVIEW_TIMEOUT_MILLIS: number = 3000; // 预览态隐藏的超时时间
const LIGHT_FONT_COLOR: string = '#ffffff';
const DARK_FONT_COLOR: string = '#000000';
const MIN_BOTTOM_AVOID_HEIGHT: number = 28; // 底部最小避让高度，避免太多贴底
const BOTTOM_AVOID_AI_BAR_HEIGHT: number = 16; // 距离AiBar避让高度
const MIN_DP_NUM: number = 360; // grid calculation constant
const MIN_PAD_DP_NUM: number = 1550; // grid calculation constant
const PHOTO_GRID_NUM: number = 4; // grid calculation constant

/**
 * 宫格整体视图模型（负责管理初始化逻辑）
 */
export class PhotoGridVm extends AbstractVm {
  private loadTimeout: number = 0;
  private hidePreviewTimeout: number = 0;
  private updateWindowSystemBarTimeout: number = 0;

  public constructor(tag?: string) {
    super(tag ?? 'PhotoGridVm');
  }

  /**
   * 更新宫格显示区域大小
   *
   * @param newSize 新的宫格显示区域大小
   */
  public updateGridAreaSize(newSize: Size): void {
    this.displayStateManager.gridAreaSizeAsm.updateState(newSize, this.tag);
  }

  /**
   * 点击宫格空白处回调
   */
  public onTapGesture(): void {
  }

  /**
   * 开启延时加载
   */
  public openDelayLoad(): void {
    TraceUtils.startTrace(TraceTaskType.GRID_DELAY_LOAD);
    this.gridStateManager.delayLoadAsm.updateState(true, this.tag);
  }

  public override init(param?: number, eventHub?: common.EventHub): void {
    super.init(param);
    LogUtils.info(this.tag, `init has eventHub: ${!!eventHub}`);
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.getIsWaitDataSourceManager((_oldState, isWaitDataSourceManager) => {
      if (isWaitDataSourceManager) {
        LogUtils.info(this.tag, 'isWaitDataSourceManager');
        return;
      }
      // 初始化宫格状态
      let isEmpty = this.dataSourceManager.isEmpty();
      let isLoadingFinished = !isEmpty || !this.dayDataSource.isInInitData;
      LogUtils.info(this.tag, `doInit isEmpty: ${isEmpty}, isLoadingFinished: ${isLoadingFinished}`);

      this.initOperateState(isLoadingFinished, isEmpty);
      this.initFormState(isLoadingFinished, isEmpty);
      this.initPreloadState();
      this.initObserverStates();
    });
  }

  protected override doRelease(): void {
    if (this.loadTimeout !== 0) {
      clearTimeout(this.loadTimeout);
    }
    if (this.hidePreviewTimeout !== 0) {
      clearTimeout(this.hidePreviewTimeout);
    }
    accessibility.off('screenReaderStateChange');
    super.doRelease();
  }

  /**
   * 自动调整列数
   * @param reason
   */
  protected autoAdjustColumns(reason?: string): void {
    if (!this.gridStateManager.config.isAutoAdjustColumns) {
      return;
    }
    let size: Size = this.displayStateManager.gridAreaSizeAsm.currentState;
    if (size.width <= 0) {
      LogUtils.warn(this.tag, 'invalid size.');
      return;
    }
    let dayColumn: number = 0;
    // pad宫格列数计算
    if (DeviceInfo.isTablet() &&
      (getScreen().isFullModeReal() || AppStorage.get<boolean>('windowPcmodeSwitchStatus') ||
        (getScreen().isLandscapeLayout()))) {
      let winRealWidth = vp2px(getScreen().getWinLayoutWidth());
      //屏幕宽度
      let winWidth: number = getScreen().getDisplayWidth();
      if (winRealWidth <= 0 || winWidth <= 0) {
        LogUtils.warn(this.tag, 'invalid size.');
        return;
      }
      if (winRealWidth > winWidth) {
        winRealWidth = winWidth;
      }
      dayColumn = Math.ceil(2 * (winRealWidth / MIN_PAD_DP_NUM - 1) + PHOTO_GRID_NUM);
    } else {
      // dayColumn = Math.round(2 * (size.width / MIN_DP_NUM - 1) + PHOTO_GRID_NUM);
      // 手机形态宫格，横屏6格，竖屏4格
      if (isOrientationHorizontal()) {
        dayColumn = 6;
      } else {
        dayColumn = 4;
      }
    }
    let groupDayColumn = dayColumn - this.gridStateManager.config.dayColumnsGap;
    let monthColumn: number = 0;
    let yearColumn: number = 0;
    if (DeviceInfo.isTablet() &&
      (getScreen().isFullModeReal() || AppStorage.get<boolean>('windowPcmodeSwitchStatus'))) {
      let dayTabletColumn = Math.round(2 * (size.width / MIN_DP_NUM - 1) + PHOTO_GRID_NUM);
      monthColumn = dayTabletColumn + Math.pow(2, Math.ceil(Math.log2(dayColumn)));
      yearColumn = monthColumn + Math.pow(2, Math.ceil(Math.log2(dayColumn)) + 1);
    } else {
      monthColumn = dayColumn + Math.pow(2, Math.ceil(Math.log2(dayColumn)));
      yearColumn = monthColumn + Math.pow(2, Math.ceil(Math.log2(dayColumn)) + 1);
    }
    this.gridStateManager.updateColumns([yearColumn, monthColumn, dayColumn, groupDayColumn], reason);
  }

  private initOperateState(isLoadingFinished: boolean, isEmpty: boolean): void {
    if (isLoadingFinished) {
      this.stateProxy.operateFsm.submitEvent(isEmpty ? OperateEventType.DATA_CLEAR : OperateEventType.DATA_LOADED);
    } else {
      const dataLoadListener: DataSourceListener = {
        onDataUpdate: (count: number): void => {
          this.stateProxy.operateFsm.submitEvent(
            count > 0 ? OperateEventType.DATA_LOADED : OperateEventType.DATA_CLEAR);
          this.dataSourceManager.unRegisterObserver(dataLoadListener);
        }
      };
      this.registerDataSourceListener(dataLoadListener);
    }
  }

  private initFormState(isLoadingFinished: boolean, isEmpty: boolean): void {
    if (isLoadingFinished) {
      this.stateProxy.formFsm.submitEvent(isEmpty ? FormEventType.DATA_CLEAR : FormEventType.DATA_LOADED);
    }
  }

  private initPreloadState(): void {
    if (!this.gridStateManager.config.isSupportPreload) {
      LogUtils.info(this.tag, 'initPreloadState LOAD_FINISH.');
      this.stateProxy.preloadFsm.submitEvent(PreloadEventType.HIDE);
      return;
    }

    LogUtils.info(this.tag, 'initPreloadState ENTER_PRELOAD.');
    this.stateProxy.preloadFsm.submitEvent(PreloadEventType.ENTER_PRELOAD);

    this.loadTimeout = setTimeout((): void => {
      LogUtils.info(this.tag, 'initPreloadState PRELOAD_TIMEOUT.');
      this.loadTimeout = 0;
      this.stateProxy.preloadFsm.submitEvent(PreloadEventType.PRELOAD_TIMEOUT);
    }, PRELOAD_TIMEOUT_MILLIS);
    this.hidePreviewTimeout = setTimeout(() => {
      LogUtils.info(this.tag, 'initPreloadState HIDE_PRE_TIMEOUT.');
      this.hidePreviewTimeout = 0;
      this.stateProxy.preloadFsm.submitEvent(PreloadEventType.HIDE);
    }, HIDE_PREVIEW_TIMEOUT_MILLIS);
  }

  private initObserverStates(): void {
    // 监听宫格显示区域变化，变化时及时跳转宫格大小
    this.displayObserverProxy.getGridAreaSize(() => this.autoAdjustColumns('updateGridAreaSize'));
    // 监听是否自动调整列数
    this.gridObserverProxy.getIsAutoAdjustColumn((_oldState, newState): void => {
      if (newState) {
        this.autoAdjustColumns('autoAdjustColumnAsm_true');
      }
    });

    // 监听宫格状态机变化
    this.observerFormState();

    // 判断进入或退出沉浸态
    this.observerAndUpdateImmersiveState();

    // 更新宫格底部高度
    this.observerAndUpdateBottomHeight();

    // 监听切换态变化
    this.gridObserverProxy.getIsSwitching((_oldState, newState) => {
      if (newState) {
        this.stateProxy.timeController?.updateScrollerOpacity();
      }
    });

    // 监听沉浸态变化
    this.gridObserverProxy.getIsImmersive(()=> this.updateStatusBarState());

    // 监听预加载状态变化
    this.getPreloadState((oldState, newState) => {
      if (!PreloadStateTypeUtils.isInLoadedOrTimeoutState(oldState) &&
        PreloadStateTypeUtils.isInLoadedOrTimeoutState(newState)) {
        this.stateProxy.dataSourceManager.doAfterPreload()
      }
    });

    // 监听数据变化
    this.registerDataSourceListener({
      onDataUpdate: (count: number): void => {
        if (count > 0) {
          this.stateProxy.operateFsm.submitEvent(OperateEventType.DATA_LOADED);
          const lastValidForm = this.stateProxy.formFsm.getLastValidForm();
          if (lastValidForm !== undefined) {
            // 数据恢复场景，恢复到原有形态
            this.stateProxy.formFsm.submitEvent(FormEventTypeUtils.getSwitchEventTypeFromForm(lastValidForm));
          } else {
            this.stateProxy.formFsm.submitEvent(FormEventType.DATA_LOADED);
          }
        } else {
          this.stateProxy.operateFsm.submitEvent(OperateEventType.DATA_CLEAR);
          this.stateProxy.formFsm.submitEvent(FormEventType.DATA_CLEAR);
        }
      }
    });

    // 监听无障碍开关变化
    accessibility.on('screenReaderStateChange', (state: boolean) => {
      LogUtils.info(this.tag, `screenReaderStateChange ${state}`);
      AppStorage.setOrCreate<boolean>(Constants.OPEN_TOUCH_GUIDE, state);
    });
  }

  private observerFormState(): void {
    this.getFormState((oldState, newState): void => {
      if (!FormStateTypeUtils.isInDayState(oldState) && FormStateTypeUtils.isInDayState(newState)) {
        // 切换到日视图时，需要打开日视图数据更新开关
      } else if (FormStateTypeUtils.isInDayState(oldState) && !FormStateTypeUtils.isInDayState(newState)) {
        // 从日视图切换到其他视图时相当于销毁日视图，此时需要关闭日视图数据更新开关
      }
      if (FormStateTypeUtils.isInGroupDayState(newState)) {
        this.dayDataSource.enableDaySlidingWindow(false);
        this.groupDayDataSource.enableGroupSlidingWindow(true);
      } else if (FormStateTypeUtils.isInDayState(newState)) {
        this.dayDataSource.enableDaySlidingWindow(true);
        this.groupDayDataSource.enableGroupSlidingWindow(false);
      }

      // 更新是否处在分组状态
      this.gridStateManager.isGroupAsm.updateState(FormStateTypeUtils.isInGroupDayState(newState), 'FormChange');
    });
  }

  private observerAndUpdateImmersiveState(): void {
    // 判断进入或退出沉浸态
    this.getFormState((): void => this.updateImmersiveState('FormChange'));
    this.gridObserverProxy.getIsSwitching(() => this.updateImmersiveState('IsSwitchingChange'));
    this.gridObserverProxy.getIsInGroupState(() => this.updateImmersiveState('IsSwitchingChange'));
    this.titleBarObserverProxy.getImmersiveThreshold(() => this.updateImmersiveState('ImmersiveThresholdChange'));
    this.displayObserverProxy.getIsHorizontal(() => {
      this.updateImmersiveState('IsHorizontalChange');
      this.updateStatusBarState();
    });
  }

  private updateStatusBarState(): void {
    let currentStatusColor: string = LIGHT_FONT_COLOR;
    // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态和是否处于分组视图，浅色模式的非沉浸态时和浅色模式的分组视图时都是黑色
    if (!this.gridObserverProxy.getIsImmersive() && AppStorage.get('currentColorMode') !==
      ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      currentStatusColor = DARK_FONT_COLOR;
    }
    if (this.stateProxy.immersiveController) {
      this.stateProxy.immersiveController.textFontColor = currentStatusColor;
    }

    // 节流操作，避免频繁设置系统状态栏颜色造成的指令数超标问题
    if (!this.updateWindowSystemBarTimeout && this.displayObserverProxy.getIsGridShow()) {
      this.updateWindowSystemBarTimeout = setTimeout(() => {
        WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
        clearTimeout(this.updateWindowSystemBarTimeout);
        this.updateWindowSystemBarTimeout = 0;
      }, 50);
    }
  }

  private observerAndUpdateBottomHeight(): void {
    // 底部高度监听
    this.displayObserverProxy.getBottomAvoidHeight(() => this.updateBottomHeight());
    this.toolbarObserverProxy.getToolbarPosition(() => this.updateBottomHeight());
    this.switchObserverProxy.getSwitchMode(() => this.updateBottomHeight());
    this.getOperateState(() => this.updateBottomHeight());
  }

  private updateBottomHeight(): void {
    // vde外屏 === switch隐藏态
    if (this.switchObserverProxy.getSwitchMode() === SwitchMode.HIDE) {
      this.gridStateManager.bottomHeightAsm.updateState(Constants.ToolBarHeight, this.tag);
      return;
    }
    // 计算遮挡高度
    let bottomHeight = this.displayObserverProxy.getBottomAvoidHeight();
    if (this.switchStateManager.config.isSupportSwitch &&
      !OperateStateTypeUtils.isInSelectState(this.getOperateState())) {
      // 非沉浸态场景，遮挡高度为标题栏高度
      bottomHeight += SwitchCommonUtils.getSwitchAvoidHeight();
    } else if (OperateStateTypeUtils.isInSelectState(this.getOperateState()) &&
      this.toolbarObserverProxy.getToolbarPosition() === GridToolBarPosition.RIGHT_TOP) {
      bottomHeight = MIN_BOTTOM_AVOID_HEIGHT + BOTTOM_AVOID_AI_BAR_HEIGHT;
    } else {
      bottomHeight = Math.max(bottomHeight, MIN_BOTTOM_AVOID_HEIGHT);
    }
    this.gridStateManager.bottomHeightAsm.updateState(bottomHeight, this.tag);
  }
}