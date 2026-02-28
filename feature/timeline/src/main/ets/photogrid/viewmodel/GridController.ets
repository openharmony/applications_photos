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

import lazy { ObserverManager } from '@ohos/common/src/main/ets/default/utils/ObserverManager';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { FORM_SIZE, ScrollReason } from '../statemanager/constants/GridDefine';
import lazy { PinchAction } from '../statemanager/constants/PinchDefine';
import lazy { IGridVariableConfig } from '../statemanager/config/GridConfig';
import lazy { FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { IToolbarVariableConfig } from '../statemanager/config/ToolbarConfig';
import lazy { IPinchVariableConfig } from '../statemanager/config/PinchConfig';
import lazy { ISwitchVariableConfig } from '../statemanager/config/SwitchConfig';
import lazy { IDisplayVariableConfig } from '../statemanager/config/DisplayConfig';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { OperateStateTypeUtils } from '../../photogrid/statemanager/GridOperateFsm';
import lazy {
  ControllerType,
  GridStartParams,
  IGridController
} from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { SwitchCommonUtils } from './utils/SwitchCommonUtils';
import lazy { IAlbumVariableConfig } from '../statemanager/config/AlbumConfig';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

/**
 * 宫格状态监听器
 */
export interface GridStateListener {
  /**
   * 最后形态为日分组形态变更回调
   *
   * @param isLastFormIsDayGroup 最后形态为日分组形态
   */
  onIsLastFormIsDayGroupChange?: (isLastFormIsDayGroup: boolean) => void;

  /**
   * 日分组导航是否开启变更回调
   *
   * @param isGroupDayGuideOpen 日分组导航是否开启
   */
  onGroupDayGuideOpenChange?: (isGroupDayGuideOpen: boolean) => void;

  /**
   * 捏合状态变化
   *
   * @param pinchState 捏合状态
   */
  onPinchStateChange?: (pinchState: PinchAction) => void;

  /**
   * 通知切换组件是否隐藏到底部
   *
   * @param isHidToBottom 是否隐藏到底部
   * @param reason 更新原因
   */
  onSwitchHidToBottomChange?: (isHidToBottom: boolean, reason?: string) => void;

  /**
   * 宫格操作回调
   */
  onGridOperated?: () => void;

  /**
   * 选择模式变化回调
   *
   * @param isSelectedMode 是否进入多选模式
   */
  onSelectedModeChange?: (isSelectedMode: boolean) => void;
}

/**
 * 宫格控制器，用于内外部状态同步
 */
export class GridController extends ObserverManager<GridStateListener> implements IGridController {
  // 观察者代理（生命周期同父类）
  private readonly observerProxy: GridStateObserverProxy = new GridStateObserverProxy();

  // 观察者代理(内部状态监听专用，有观察者时才存在)
  private readonly innerObserverProxy: GridStateObserverProxy = new GridStateObserverProxy();

  public constructor() {
    super('GridController');
  }

  public getControllerType(): ControllerType {
    return ControllerType.PHOTO_GRID;
  }

  /**
   * 更新宫格配置
   *
   * @param variableConfig 可变配置
   */
  public updateGridConfig(variableConfig: IGridVariableConfig): void {
    this.stateProxy.gridStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
  }

  /**
   * 更新切换配置
   *
   * @param variableConfig 可变配置
   */
  public updateSwitchConfig(variableConfig: ISwitchVariableConfig): void {
    this.stateProxy.switchStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
  }

  /**
   * 更新捏合配置
   *
   * @param variableConfig 可变配置
   */
  public updatePinchConfig(variableConfig: IPinchVariableConfig): void {
    this.stateProxy.pinchStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
  }

  /**
   * 更新工具栏配置
   *
   * @param variableConfig 可变配置
   */
  public updateToolbarConfig(variableConfig: IToolbarVariableConfig): void {
    if (variableConfig.toolbarPosition !== undefined) {
      this.stateProxy.toolbarStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
    }
  }

  /**
   * 更新屏幕显示配置
   *
   * @param variableConfig 可变配置
   */
  public updateDisplayConfig(variableConfig: IDisplayVariableConfig): void {
    this.stateProxy.displayStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
  }

  /**
   * 更新相册配置
   *
   * @param variableConfig 可变配置
   */
  public updateAlbumConfig(variableConfig: IAlbumVariableConfig): void {
    this.stateProxy.albumStateManager.updateStateFromVariableConfig(variableConfig, this.tag);
  }

  /**
   * 更新是否在动效中，动效中需要冻结标题栏，工具栏，切换组件的操作
   *
   * @param isInAnim 是否在动效中
   */
  public updateIsInAnimation(isInAnim: boolean): void {
    this.stateProxy.browserAnimAsm.updateState(isInAnim, this.tag);
  }

  public updateSdCardState(isShowSdCard: boolean): void {
    this.stateProxy.gridStateManager.sdCardStatusAsm.updateState(isShowSdCard, this.tag);
  }

  public updateCardName(cardName: string): void {
    this.stateProxy.gridStateManager.cardNameAsm.updateState(cardName, this.tag);
  }

  /**
   * 获取状态代理
   *
   * @returns 状态代理
   */
  protected get stateProxy(): GridStateProxy {
    return GridStateProxy.getInstance(this.persistentId);
  }

  /**
   * 初始化子组件状态管理者
   *
   * @param timeController 时间标签管理者
   * @param immersiveController 沉浸态管理者
   */
  public initSubComponentState(timeController?: TimeController, immersiveController?: ImmersiveController) {
    this.stateProxy.initSubComponentState(timeController, immersiveController);
  }

  public updateDataSourceActiveStatus(isActive: boolean): void {
    if (isActive) {
      this.stateProxy.dataSourceManager.dayDataSource.resume();
      if (this.stateProxy.gridStateManager.config.isSupportHeadMsg) {

      }
      this.stateProxy.dataSourceManager.resume();
    } else {
      this.stateProxy.dataSourceManager.dayDataSource.pause();
      if (this.stateProxy.gridStateManager.config.isSupportHeadMsg) {

      }
      this.stateProxy.dataSourceManager.pause();
    }
  }

  /**
   * 刷新宫格被覆盖状态信息
   *
   * @param isGridCovered 宫格是否被覆盖
   */
  public updateGridCovered(isGridCovered: boolean): void {
    this.stateProxy.displayStateManager.updateGridCovered(isGridCovered, this.tag);
  }

  /**
   * 刷新宫格聚焦状态信息
   *
   * @param isPhotoGridFocused 宫格是否聚焦
   */
  public updateGridFocused(isPhotoGridFocused: boolean): void {
    this.stateProxy.displayStateManager.updateGridFocused(isPhotoGridFocused, this.tag);
  }

  /**
   * 刷新选择刷新状态信息
   */
  public refreshSelectState(): void {
    this.stateProxy.selectStateManager.refreshSelectState();
  }

  /**
   * 将指定图片移动到屏幕显示区域内，并返回其坐标信息
   *
   * @param placeholderIndex 图片项索引
   * @returns item位置信息
   */
  public getGridStartParams(uri: string, needScrolling: boolean = true): GridStartParams | undefined {
    let itemIndex: number = this.stateProxy.dataSourceManager.dayDataSource.getDataIndexByUri(uri);
    if (itemIndex === Constants.NOT_FOUND) {
      itemIndex = this.stateProxy.dataSourceManager.dayDataSource.getSimpleMediaItemIndexByUri(uri);
    }
    let ratio: number = 1;
    let thumbnailWidth: number | undefined = undefined;
    let thumbnailHeight: number | undefined = undefined;
    // 当前宫格item形态(是否正方形)
    const isFullRatio = AppStorage.get<boolean>(Constants.IS_FULL_RATIO);
    if (DeviceInfo.isPc() && !isFullRatio) {
      let item = this.stateProxy.dataSourceManager.dayDataSource.getItemByUri(uri);
      if (item.width && item.height) {
        ratio = item.width / item.height;
        thumbnailWidth = px2vp(item.width);
        thumbnailHeight = px2vp(item.height);
      }
    }
    LogUtils.info(this.tag, `scrollToItem index ${itemIndex} ratio = ${ ratio }`);
    if (itemIndex < 0) {
      return undefined;
    }
    // 获取当前宫格形态
    const gridForm = this.observerProxy.getCurrentForm();
    const itemRect = SwitchCommonUtils.calcRectFromItemIndex(itemIndex, this.observerProxy, gridForm);
    // 上方遮挡高度
    const topOcclusionHeight = this.observerProxy.titleBarObserverProxy.getTitleBarHeight();
    // 下方避让距离
    const bottomOcclusionHeight = this.observerProxy.gridObserverProxy.getBottomHeight();
    // 偏移距离
    const scrollOffset = this.observerProxy.gridObserverProxy.getScrollOffset(gridForm);
    // 窗口高度
    const winHeight = this.observerProxy.displayObserverProxy.getGridAreaSize().height;
    // 宫格边距
    const padding = this.observerProxy.gridObserverProxy.getGridPaddingLeftAndRight();
    // 侧边栏宽度
    const slideBarWidth = getScreen().getWinWidth() - this.observerProxy.displayObserverProxy.getGridAreaSize().width;
    const topScrollOffset = itemRect.top - topOcclusionHeight;
    const bottomScrollOffset = itemRect.bottom - (winHeight - bottomOcclusionHeight);
    let targetOffset: number;
    if (topScrollOffset < scrollOffset) {
      // 说明宫格在窗口可见范围的上方
      targetOffset = topScrollOffset;
    } else if (bottomScrollOffset > scrollOffset) {
      // 说明宫格在窗口可见范围的下方
      targetOffset = bottomScrollOffset;
    } else {
      // 说明宫格在无遮挡可见范围内，不用处理
      targetOffset = scrollOffset;
    }

    LogUtils.info(this.tag, `calcRectFromItemIndex gridForm:${gridForm} itemIndex:${itemIndex}` +
      `, rect: [${itemRect.left}, ${itemRect.top}], scrollOffset: ${scrollOffset}, targetOffset: ${targetOffset}`);
    if (targetOffset !== scrollOffset && needScrolling) {
      // 触发宫格滚动
      this.stateProxy.gridStateManager.getScrollOffsetManager(gridForm).updateState(
        Math.max(0, targetOffset), ScrollReason.OUTER);
    }
    return {
      left: itemRect.left + padding + slideBarWidth,
      top: itemRect.top - targetOffset,
      right: itemRect.right + padding + slideBarWidth,
      bottom: itemRect.bottom - targetOffset,
      ratio: ratio,
      slideBarWidth: slideBarWidth,
      thumbnailWidth: thumbnailWidth,
      thumbnailHeight: thumbnailHeight
    };
  }
  
  /**
   * 更新菜单操作状态
   *
   * @param navToOtherPage 菜单操作状态
   */
  public updateActionState(navToOtherPage: boolean): void {
    this.stateProxy.gridStateManager.actionStateAsm.updateState(navToOtherPage, this.tag);
  }

  /**
   * 更新宫格是否在前台状态
   *
   * @param isActive 是否在前台
   */
  public updateGridActiveState(isActive: boolean): void {
    this.stateProxy.displayStateManager.gridActiveAsm.updateState(isActive, this.tag);
  }

  /**
   * 更新气泡显示状态
   *
   * @param isUpdateGuideState 是否更新气泡显示状态
   */
  public updateDayGuideState(isUpdateGuideState: boolean): void {
    this.stateProxy.switchStateManager.isUpdateGuideStateAsm.updateState(isUpdateGuideState, 'updateDayGuideState');
  }

  /**
   * 更新气泡显示状态
   *
   * @param isShowDayGuide 是否显示
   */
  public updateDayGuideShowState(isShowDayGuide: boolean): void {
    this.stateProxy.switchStateManager.isDayGuideShowAsm.updateState(isShowDayGuide, this.tag);
  }

  /**
   * 更新宫格可见状态
   *
   * @param isGridVisible 宫格是否用户可见
   */
  public updateGridVisible(isGridVisible: boolean): void {
    this.stateProxy.gridStateManager.updateGridVisibleState(isGridVisible, 'updateGridVisible');
  }

  /**
   * 更新相机地理权限卡片是否可见
   *
   * @param isShow 是否可见
   */
  public updateCameraCardShowState(isUpdateCameraShowState: boolean): void {
    this.stateProxy.gridStateManager.updateCameraCardShowState(isUpdateCameraShowState, 'updateCameraCardShowState');
  }

  /**
   * 更新相机地理权限状态
   *
   * @param isUpdateCameraAuthorizeState 是否更新
   * */
  public updateCameraAuthorizeState(isUpdateCameraAuthorizeState: boolean): void {
    this.stateProxy.gridStateManager.updateCameraAuthorizeState(isUpdateCameraAuthorizeState,
      'updateCameraAuthorizeState');
  }

  /**
   * 更新占位index
   *
   * @param uniqueId mediaItem的uniqueId
   * @param isTap 是否tap, 为true时隐藏宫格
   */
  public updatePlaceHolder(uniqueId: string, isTap: boolean):void {
    LogUtils.info(this.tag, `updatePlaceHolder uniqueId = ${uniqueId}, isTap = ${isTap}`)
    this.stateProxy.displayStateManager.updatePlaceHolder(uniqueId, isTap);
  }

  /**
   * 更新初始位置
   *
   * @param formIndex 初始层级
   * @param index 初始位置
   */
  public updateInitIndex(formIndex: FormIndex, index: number): void {
    LogUtils.info(this.tag,`updateInitIndex ${index}, formIndex ${formIndex}`)
    this.stateProxy.scrollerStateManager.getInitIndexInGridAsm(formIndex).updateState(index);
  }

  protected override doInit(persistentId: number): void {
    this._persistentId = persistentId;
    super.doInit(persistentId);
    this.observerProxy.init(persistentId);
    if (this.observerSize > 0) {
      // 初始化可能在设置监听之后，此处弥补此问题
      this.onObserverStateChange(true);
    }
  }

  protected override doRelease(): void {
    this.observerProxy.release();
    this.innerObserverProxy.release();
    super.doRelease();
  }

  protected override onObserverStateChange(hasObserver: boolean): void {
    if (hasObserver) {
      this.innerObserverProxy.init(this.persistentId);
      this.registerObservers();
    } else {
      this.innerObserverProxy.release();
    }
  }

  private registerObservers(): void {
    this.innerObserverProxy.getFormState((_oldState, newState) => {
      if (FormStateTypeUtils.isInDayState(newState)) {
        this.callbackObservers(observer => observer.onIsLastFormIsDayGroupChange?.(false));
      } else if (FormStateTypeUtils.isInGroupDayState(newState)) {
        this.callbackObservers(observer => observer.onIsLastFormIsDayGroupChange?.(true));
      }
    });
    this.innerObserverProxy.switchObserverProxy.getGroupDayGuideOpenState((_oldState, newState) => {
      this.callbackObservers(observer => observer.onGroupDayGuideOpenChange?.(newState));
    });
    this.innerObserverProxy.switchObserverProxy.getSwitchIsHidToBottom((_oldState, newState, reason?) => {
      this.callbackObservers(observer => observer.onSwitchHidToBottomChange?.(newState, reason));
    })
    this.innerObserverProxy.pinchObserverProxy.registerEventListener({
      onPinchStateChange: (pinchAction: PinchAction): void => {
        this.callbackObservers(observer => observer.onPinchStateChange?.(pinchAction));
      }
    });
    this.innerObserverProxy.gridObserverProxy.getIsSwitching((_oldState, newState) => {
      if (newState) {
        // 宫格切换中
        this.callbackObservers(observer => observer.onGridOperated?.());
      }
    });
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.innerObserverProxy.scrollerObserverProxy.getIsScrolling(formIndex, (_oldState, newState) => {
        if (newState) {
          // 宫格滑动中
          this.callbackObservers(observer => observer.onGridOperated?.());
        }
      });
    }
    this.innerObserverProxy.getOperateState((_oldState, newState) => {
      this.callbackObservers(observer =>
        observer.onSelectedModeChange?.(OperateStateTypeUtils.isInSelectState(newState)));
    })
  }

  private formIndexToViewType(gridForm: FormIndex): string {
    if (gridForm === FormIndex.YEAR) {
      return Constants.YEAR;
    } else if (gridForm === FormIndex.MONTH) {
      return Constants.MONTH;
    } else {
      return '';
    }
  }

  private isInYearOrMonthView(gridForm: FormIndex): boolean {
    return gridForm === FormIndex.YEAR || gridForm === FormIndex.MONTH;
  }
}