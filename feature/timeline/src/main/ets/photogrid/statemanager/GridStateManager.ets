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
import lazy {
  IStateChangeObserver,
  StateChangeCallback
} from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy {
  DEFAULT_COLUMN,
  FORM_SIZE,
  FormIndex,
  IRREGULAR_SIZE,
  IrregularType,
  PullDownState,
} from './constants/GridDefine';
import lazy { GridConfig, IGridConfig, IGridVariableConfig } from './config/GridConfig';
import lazy { GridFormFsm } from './GridFormFsm';
import lazy { GridShowEventType, GridShowFsm, GridShowStateType } from './GridShowFsm';
import lazy { DisplayStateManager } from './DisplayStateManager';
import lazy { ImmersiveStateManager } from './ImmersiveStateManager';
import lazy { RestoreFpEventType, RestoreFpFsm, RestoreFpStateType } from './GridRestoreFpFsm';
import lazy { SwitchType } from './common/SwitchStartInfo';
import lazy { SortRuleString } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';

/**
 * 抽象宫格观察者代理
 */
export class GridObserverProxy extends ConfigObserverProxy<GridStateManager, GridConfig> {
  public constructor(getProxyFunc: (persistentId: number) => GridStateManager) {
    super(getProxyFunc, 'GridObserverProxy');
  }

  /**
   * 查询宫格是否处在分组状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsInGroupState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isGroupAsm, callback);
  }

  /**
   * 查询宫格是否处在沉浸态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsImmersive(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.immersiveAsm, callback);
  }

  /**
   * 查询宫格是否处在切换中
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsSwitching(callback?: StateChangeCallback<boolean, SwitchType>): boolean {
    return this.getState<boolean>(this.proxy.isSwitchingAsm, callback);
  }

  /**
   * 查询是否自动更新宫格列数
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsAutoAdjustColumn(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.autoAdjustColumnAsm, callback, false);
  }

  /**
   * 查询宫格列数
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridColumn(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getColumnManager(gridForm), callback);
  }

  /**
   * 查询宫格左右内距
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridPaddingLeftAndRight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.gridPaddingAsm, callback);
  }

  /**
   * 查询指定不规则区域类型对应的高度
   *
   * @param irregularType 不规则类型
   * @param callback 更新回调
   * @param isCallbackImmediately 是否理解回调
   * @returns 属性状态
   */
  public getIrregularTypeHeight(irregularType: IrregularType, callback?: StateChangeCallback<number>,
    isCallbackImmediately: boolean = true): number {
    return this.getState<number>(this.proxy.getIrregularTypeHeightManager(irregularType), callback,
      isCallbackImmediately);
  }

  /**
   * 查询消息头高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getHeadMsgHeight(callback?: StateChangeCallback<number>): number {
    return this.getIrregularTypeHeight(IrregularType.HEAD_MSG, callback);
  }

  /**
   * 查询排序选择器高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSortSelectorHeight(callback?: StateChangeCallback<number>): number {
    return this.getIrregularTypeHeight(IrregularType.SORT_SELECTOR, callback);
  }

  /**
   * 查询消息头下拉状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getHeadMsgPullDownState(callback?: StateChangeCallback<PullDownState>): PullDownState {
    return this.getState<PullDownState>(this.proxy.headMsgPullDownAsm, callback);
  }

  /**
   * 查询消息头下拉高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getHeadMsgPullDownHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.headMsgPullDownHeightAsm, callback);
  }

  /**
   * 查询分组头高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGroupTitleHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.groupTitleHeightAsm, callback);
  }

  /**
   * 查询宫格上方不规则区域高度
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIrregularHeight(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getIrregularHeightManager(gridForm), callback);
  }

  /**
   * 查询宫格总高度（不包括上方不规则和下方避让区域高度）
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridHeight(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getGridHeightManager(gridForm), callback);
  }

  /**
   * 查询宫格底部高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getBottomHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.bottomHeightAsm, callback);
  }

  /**
   * 查询是否处于延时加载状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getDelayLoad(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.delayLoadAsm, callback);
  }

  /**
   * 查询宫格上方不规则区域数目
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIrregularCount(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getIrregularCountManager(gridForm), callback);
  }

  /**
   * 查询所有宫格列数
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridColumns(callback?: StateChangeCallback<number[]>): number[] {
    return this.getState<number[]>(this.proxy.allColumnAsm, callback);
  }

  /**
   * 获取指定宫格形态当前目标放缩系数
   *
   * @param gridForm 宫格形态
   * @returns 目标放缩系数
   */
  public getFormTargetScale(gridForm: FormIndex): number {
    return this.proxy.getFormTargetScale(gridForm);
  }

  /**
   * 查询宫格显示状态
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridShowState(gridForm?: FormIndex,
    callback?: StateChangeCallback<GridShowStateType, GridShowEventType>): GridShowStateType {
    return this.getState<GridShowStateType>(this.proxy.getGridShowFsm(gridForm), callback);
  }

  /**
   * 查询恢复补位状态
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getRestoreFpState(gridForm?: FormIndex,
    callback?: StateChangeCallback<RestoreFpStateType, RestoreFpEventType>): RestoreFpStateType {
    return this.getState<RestoreFpStateType>(this.proxy.getRestoreFpFsm(gridForm), callback);
  }

  /**
   * 查询宫格图片高度
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridImageHeight(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getImageHeightManager(gridForm), callback);
  }

  /**
   * 查询宫格图片行间距
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridImageGutter(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getImageGutterManager(gridForm), callback);
  }

  /**
   * 查询宫格图片列间距
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridImageColumnGutter(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getImageColumnGutterManager(gridForm), callback);
  }

  /**
   * 查询宫格缓存数量
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getCachedCount(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getCachedCountManager(gridForm), callback);
  }

  /**
   * 查询宫格默认缓存数量
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getOriginalCachedCount(gridForm?: FormIndex): number {
    return this.proxy.config.cachedCounts[gridForm ?? this.getCurrentForm()] ?? 1;
  }

  /**
   * 查询宫格是否支持补位
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getIsSupportFp(gridForm?: FormIndex, callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.getIsSupportFpManager(gridForm), callback);
  }

  /**
   * 查询宫格补位信息
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getFillPostion(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getFillPositionManager(gridForm), callback);
  }

  /**
   * 获取指定宫格形态当前滚动距离
   *
   * @param gridForm
   * @param callback 更新回调
   * @returns 当前滚动距离
   */
  public getScrollOffset(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getScrollOffsetManager(gridForm), callback);
  }

  /**
   * 获取首个可见宫格索引
   *
   * @param formIndex 宫格形态
   * @param callback 更新回调
   * @returns 首个可见宫格索引
   */
  public getFirstIndex(gridForm?: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getFirstIndexManager(gridForm), callback);
  }

  /**
   * 获取当前宫格形态
   *
   * @returns 当前宫格形态
   */
  public getCurrentForm(): FormIndex {
    return this.proxy.getCurrentForm();
  }

  /**
   * 获取外部存储提示卡片显示状态
   *
   * @param callback 更新回调
   * @returns 属性类型
   */
  public getSdCardState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.sdCardStatusAsm, callback);
  }

  /**
   * 获取外部存储提示卡片名称
   *
   * @param callback 更新回调
   * @returns 属性类型
   */
  public getCardName(callback?: StateChangeCallback<string>): string {
    return this.getState<string>(this.proxy.cardNameAsm, callback);
  }

  /**
   * 查询宫格滚动条触摸状态
   *
   * @param formIndex 形态索引
   * @returns 属性状态
   */
  public getGridLevel(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.gridLevelAsm, callback);
  }

  /**
   * 获取是否关联tabbar沉浸动效
   *
   * @returns 是否关联状态
   */
  public getIsSupportTabbarAnimation(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isSupportTabbarAnimationAsm, callback);
  }

  /**
   * 获取宫格排序状态
   */
  public getGridSortState(callback?: StateChangeCallback<SortRuleString>): SortRuleString {
    return this.getState<SortRuleString>(this.proxy.gridSortAsm, callback);
  }

  /**
   * 获取宫格刷新动效状态
   */
  public getGridAnimState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.gridAnimAsm, callback);
  }

  /**
   * 查询宫格右键菜单事件更新
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getRightClickMenu(callback?: StateChangeCallback<ParamsWrapper>): ParamsWrapper {
    return this.getState<ParamsWrapper>(this.proxy.rightClickMenuAsm, callback);
  }

  /**
   * 获取菜单动作状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getActionState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.actionStateAsm, callback);
  }
  
  /**
   * 获取相机地理位置提醒卡片显示状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getCameraCardShowState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.cameraCardShowStateAsm, callback);
  }

  /**
   * 获取相机地理位置提醒卡片显示状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getUpdateCameraAuthorizeState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.updateCameraAuthorizeStatusAsm, callback);
  }

  /**
   * 获取相机地理位置提醒卡片透明度
   *
   * @param callback 更新回调
   * @returns 透明度
   */
  public getUpdateCameraCardOpacity(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.updateCameraCardOpacityAsm, callback);
  }

  /**
   * 更新宫格可见性状态
   *
   * @param callback 更新回调
   * @returns 宫格可见性
   */
  public getGirdVisibleState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.gridVisibleStateAsm, callback);
  }

  /**
   * 是否显示预加载视图
   *
   * @param callback 更新回调
   * @returns 预加载视图可见性
   */
  public getShowPreview(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isShowPreviewAsm, callback);
  }
}

/**
 * 所有列状态管理器
 */
class AllColumnAsm extends AttributeStateManager<number[]> {
  constructor(persistentId: number) {
    super(persistentId, DEFAULT_COLUMN, 'AllColumn');
  }

  protected override logState(state: number[]): string {
    return state.join(', ');
  }
}

/**
 * 宫格状态管理器
 */
export class GridStateManager extends ConfigStateManager<GridConfig, IGridConfig, IGridVariableConfig> {
  public override readonly config: GridConfig = new GridConfig();

  /**
   * 分组状态管理器（是否处于日期分组状态）
   */
  public readonly isGroupAsm: AttributeStateManager<boolean>;

  /**
   * 沉浸态状态管理器（是否在沉浸态）
   */
  public readonly immersiveAsm: ImmersiveStateManager;

  /**
   * 右键菜单点击状态管理器
   */
  public readonly rightClickMenuAsm: AttributeStateManager<ParamsWrapper>;

  /**
   * 宫格形态切换中管理器（是否在宫格形态切换中）
   */
  public readonly isSwitchingAsm: AttributeStateManager<boolean, SwitchType>;

  /**
   * 自动调整列数管理器
   */
  public readonly autoAdjustColumnAsm: AttributeStateManager<boolean>;

  /**
   * 所有列状态管理器
   */
  public readonly allColumnAsm: AllColumnAsm;

  /**
   * 消息头下拉状态管理器
   */
  public readonly headMsgPullDownAsm: AttributeStateManager<PullDownState>;

  /**
   * 消息头下拉高度
   */
  public readonly headMsgPullDownHeightAsm: AttributeStateManager<number>;

  /**
   * 分组头高度管理器
   */
  public readonly groupTitleHeightAsm: AttributeStateManager<number>;

  /**
   * 宫格左右内距管理器
   */
  public readonly gridPaddingAsm: AttributeStateManager<number>;

  /**
   * 外部存储提示卡片状态管理器
   */
  public readonly sdCardStatusAsm: AttributeStateManager<boolean>;

  /**
   * 外部存储提示卡片名称管理器
   */
  public readonly cardNameAsm: AttributeStateManager<string>;

  /**
   * 相机地理权限提醒卡片显示状态
   */
  public readonly cameraCardShowStateAsm: AttributeStateManager<boolean>;

  /**
   * 相机地理权限提醒卡片显示状态
   */
  public readonly updateCameraAuthorizeStatusAsm: AttributeStateManager<boolean>;

  /**
   * 相机地理权限提醒卡片显示状态
   */
  public readonly updateCameraCardOpacityAsm: AttributeStateManager<number>;

  /**
   * 宫格挡位管理器
   */
  public readonly gridLevelAsm: AttributeStateManager<number>;

  /**
   * 宫格底部避让高度管理器
   */
  public readonly bottomHeightAsm: AttributeStateManager<number>;

  /**
   * 延时加载管理器（当无预加载机制时，开启延时错误加载机制）
   */
  public readonly delayLoadAsm: AttributeStateManager<boolean>;

  // 宫格形态状态机
  private readonly formFsm: GridFormFsm;

  // 宫格排序状态管理器
  public readonly gridSortAsm: AttributeStateManager<SortRuleString>;

  // 宫格刷新动效管理器
  public readonly gridAnimAsm: AttributeStateManager<boolean>;

  // 菜单状态监听管理器
  public readonly actionStateAsm: AttributeStateManager<boolean>;

  // 宫格可见性监听管理器
  public readonly gridVisibleStateAsm: AttributeStateManager<boolean>;

  // 预加载视图是否可见
  public readonly isShowPreviewAsm: AttributeStateManager<boolean>;

  // 按类型区分的不规则区域高度管理器
  private readonly irregularTypeHeightManagers: AttributeStateManager<number>[] = [];

  // 屏幕显示状态管理器
  private readonly displayStateManager: DisplayStateManager;

  // 按宫格形态区分的不规则区域高度管理器（例如：消息头、云服务卡片，后续涉及新增时，适配到此处，注：此高度需要包括不规格区域中间和下方的间距）
  private readonly irregularHeightManagers: AttributeStateManager<number>[] = [];

  // 宫格总高度管理器
  private readonly gridHeightManagers: AttributeStateManager<number>[] = [];

  // 按宫格形态区分的不规则区域数量管理器
  private readonly irregularCountManagers: AttributeStateManager<number>[] = [];

  /**
   * 关联tabbar沉浸动效状态
   */
  public readonly isSupportTabbarAnimationAsm: AttributeStateManager<boolean>;

  // 宫格列数管理器
  private readonly columnManagers: AttributeStateManager<number>[] = [];

  // 宫格图片行间距管理器
  private readonly imageGutterManagers: AttributeStateManager<number>[] = [];

  // 宫格图片列间距管理器
  private readonly imageColumnGutterManagers: AttributeStateManager<number>[] = [];

  // 宫格缓存数量管理器
  private readonly cachedCountManagers: AttributeStateManager<number>[] = [];

  // 宫格图片高度管理器
  private readonly imageHeightManagers: AttributeStateManager<number>[] = [];

  // 是否支持宫格补位管理器
  private readonly isSupportFpManagers: AttributeStateManager<boolean>[] = [];

  // 宫格补位管理器
  private readonly fillPositionManagers: AttributeStateManager<number>[] = [];

  // 宫格滚动距离管理器
  private readonly scrollOffsetManagers: AttributeStateManager<number>[] = [];

  // 切换结束时第一个可见宫格索引
  private readonly firstIndexManagers: AttributeStateManager<number>[] = [];

  // 宫格显示状态机
  private readonly gridShowFsmList: GridShowFsm[] = [];

  // 恢复补位状态机
  private readonly restoreFpFsmList: RestoreFpFsm[] = [];

  private readonly displayListener: IStateChangeObserver<Size> = {
    onStateChange: (_oldState, newState) => {
      if (newState.width > 0) {
        this.updateImageHeights(newState.width, 'gridAreaReport');
      }
    }
  };

  public constructor(persistentId: number, formFsm: GridFormFsm, displayStateManager: DisplayStateManager) {
    super(persistentId, 'GridStateManager');

    this.formFsm = formFsm;
    this.displayStateManager = displayStateManager;
    this.isGroupAsm = new AttributeStateManager(persistentId, false, 'IsGroup');
    this.immersiveAsm = new ImmersiveStateManager(persistentId, false, 'Immersive');
    this.isSupportTabbarAnimationAsm = new AttributeStateManager(persistentId, false, 'IsSupportTabbarAnimation');
    this.isSwitchingAsm = new AttributeStateManager(persistentId, false, 'GRID_SWITCH_IsSwitching');
    this.autoAdjustColumnAsm = new AttributeStateManager(persistentId, true, 'AutoAdjustColumn');
    this.allColumnAsm = new AllColumnAsm(persistentId);
    this.gridPaddingAsm = new AttributeStateManager(persistentId, 0, 'gridPaddingLeftAndRight')
    this.headMsgPullDownAsm = new AttributeStateManager(persistentId, PullDownState.NONE, 'HeadMsgPullDown');
    this.headMsgPullDownHeightAsm = new AttributeStateManager(persistentId, 100, 'headMsgPullDownHeight');
    this.groupTitleHeightAsm = new AttributeStateManager(persistentId, 0, 'GroupTitleHeight');
    this.sdCardStatusAsm = new AttributeStateManager(persistentId, false, 'sdCardStatus');
    this.cardNameAsm = new AttributeStateManager(persistentId, '', 'cardName');
    this.gridLevelAsm = new AttributeStateManager(persistentId, this.config.defaultGridLevel, 'GridLevel');
    this.gridSortAsm = new AttributeStateManager(persistentId, new SortRuleString(), 'GridSort');
    this.gridAnimAsm = new AttributeStateManager(persistentId, true, 'GridAnim');
    this.rightClickMenuAsm = new AttributeStateManager(persistentId, new ParamsWrapper(), 'RightClickMenu');
    this.bottomHeightAsm = new AttributeStateManager(persistentId, 0, 'BottomHeight');
    this.delayLoadAsm = new AttributeStateManager(persistentId, false, 'DelayLoad');
    this.actionStateAsm = new AttributeStateManager(persistentId, false, 'ActionState');
    this.gridVisibleStateAsm = new AttributeStateManager(persistentId, true, 'GridVisibleState');
    this.cameraCardShowStateAsm = new AttributeStateManager(persistentId, false, 'CameraCardShowState');
    this.updateCameraAuthorizeStatusAsm = new AttributeStateManager(persistentId, false, 'UpdateCameraAuthorizeStatus');
    this.updateCameraCardOpacityAsm = new AttributeStateManager(persistentId, 1, 'UpdateCameraCardOpacity');
    this.isShowPreviewAsm = new AttributeStateManager(persistentId, false, 'isShowPreview');
   this.initManagers(persistentId);
  }

  /**
   * 获取指定宫格形态当前目标放缩系数
   *
   * @param formIndex 宫格形态
   * @param currentForm 当前形态
   * @returns 目标放缩系数
   */
  public getFormTargetScale(formIndex: FormIndex, currentForm?: FormIndex): number {
    return this.getGridColumn(formIndex) / this.getGridColumn(currentForm ?? this.formFsm.getCurrentForm());
  }

  /**
   * 获取不规则高度管理器
   *
   * @param irregularType 不规则类型
   * @returns 管理器
   */
  public getIrregularTypeHeightManager(irregularType: IrregularType): AttributeStateManager<number> {
    return this.irregularTypeHeightManagers[irregularType];
  }

  /**
   * 获取不规则高度管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getIrregularHeightManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.irregularHeightManagers, formIndex);
  }

  /**
   * 获取宫格高度管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getGridHeightManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.gridHeightManagers, formIndex);
  }

  /**
   * 获取不规则数目管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getIrregularCountManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.irregularCountManagers, formIndex);
  }

  /**
   * 获取宫格列数
   *
   * @param formIndex 形态索引
   * @returns 一行行数
   */
  public getGridColumn(formIndex?: FormIndex): number {
    return this.getListItem(this.columnManagers, formIndex).currentState;
  }

  /**
   * 获取列数管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getColumnManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.columnManagers, formIndex);
  }

  /**
   * 获取图片行间距管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getImageGutterManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.imageGutterManagers, formIndex);
  }

  /**
   * 获取图片列间距管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getImageColumnGutterManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.imageColumnGutterManagers, formIndex);
  }

  /**
   * 获取缓存数量管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getCachedCountManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.cachedCountManagers, formIndex);
  }

  /**
   * 获取图片高度管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getImageHeightManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.imageHeightManagers, formIndex);
  }

  /**
   * 获取是否支持补位管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getIsSupportFpManager(formIndex?: FormIndex): AttributeStateManager<boolean> {
    return this.getListItem(this.isSupportFpManagers, formIndex);
  }

  /**
   * 获取补位管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getFillPositionManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.fillPositionManagers, formIndex);
  }

  /**
   * 获取补位管理器
   *
   * @param formIndex 形态索引
   * @returns 管理器
   */
  public getScrollOffsetManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.scrollOffsetManagers, formIndex);
  }

  /**
   * 获取首个可见宫格索引管理器
   *
   * @param formIndex 宫格形态
   * @returns 管理器
   */
  public getFirstIndexManager(formIndex?: FormIndex): AttributeStateManager<number> {
    return this.getListItem(this.firstIndexManagers, formIndex);
  }

  /**
   * 获取宫格显示状态机
   *
   * @param formIndex 形态索引
   * @returns 宫格显示状态机
   */
  public getGridShowFsm(formIndex?: FormIndex): GridShowFsm {
    return this.getListItem(this.gridShowFsmList, formIndex);
  }

  /**
   * 获取恢复补位状态机
   *
   * @param formIndex 形态索引
   * @returns 恢复占位状态机
   */
  public getRestoreFpFsm(formIndex?: FormIndex): RestoreFpFsm {
    return this.getListItem(this.restoreFpFsmList, formIndex);
  }

  /**
   * 获取当前宫格形态
   *
   * @returns 当前宫格形态
   */
  public getCurrentForm(): FormIndex {
    return this.formFsm.getCurrentForm();
  }

  /**
   * 更新宫格列数
   *
   * @param columns 宫格列数
   * @param reason 原因
   */
  public updateColumns(columns: number[], reason?: string): void {
    this.updateColumnsInner(columns, reason, true);
  }

  /**
   * 按照类型更新不规则高度区域高度
   *
   * @param irregularType 不规则类型
   * @param newHeight 新高度
   * @param reason 原因
   * @returns 管理器
   */
  public updateIrregularTypeHeight(irregularType: IrregularType, newHeight: number, reason?: string): void {
    return this.getIrregularTypeHeightManager(irregularType)?.updateState(newHeight, reason);
  }

  public override updateStateFromVariableConfig(config?: IGridVariableConfig, reason?: string): void {
    // 更新是否自动调整列数
    this.autoAdjustColumnAsm.updateState(config?.isAutoAdjustColumns, reason);

    // 更新关联tabbar沉浸式动效
    this.isSupportTabbarAnimationAsm.updateState(config?.isSupportTabbarAnimation, reason);

    // 更新宫格列数
    if (config?.gridColumns !== undefined) {
      this.updateColumnsInner(config.gridColumns, reason);
    }

    // 分组头高度
    this.groupTitleHeightAsm.updateState(config?.groupTitleHeight, reason);
  }

  /**
   * 更新宫格排序状态
   *
   * @param sortRule 排序字段、升降序
   * @param reason 更新原因
   */
  public updateGirdSort(sortRuleInfo: SortRuleString, reason?: string): void {
    this.gridSortAsm.updateState(sortRuleInfo, reason);
  }

  /**
   * 更新宫格刷新是否需要动效
   * @param needAnim
   * @param reason
   */
  public updateGirdAnimState(needAnim: boolean, reason?: string): void {
    this.gridAnimAsm.updateState(needAnim, reason);
  }

  /**
   * 更新菜单操作状态
   * @param isNavToOtherPage
   * @param reason
   */
  public updateActionState(isNavToOtherPage: boolean, reason?: string): void {
    this.actionStateAsm.updateState(isNavToOtherPage, reason);
  }

  /**
   * 更新宫格可见性状态
   *
   * @param isGridVisible 宫格是否可见
   * @param reason 更新原因
   */
  public updateGridVisibleState(isGridVisible: boolean, reason?: string): void {
    this.gridVisibleStateAsm.updateState(isGridVisible, reason);
  }

  /**
   * 更新相机权限状态
   *
   * @param isUpdateCameraShowState 更新相机权限状态
   * @param reason 更新原因
   */
  public updateCameraCardShowState(isUpdateCameraShowState: boolean, reason?: string): void {
    this.cameraCardShowStateAsm.updateState(isUpdateCameraShowState, reason);
  }

  /**
   * 更新相机权限状态
   *
   * @param isUpdateCameraAuthorizeState 更新相机权限状态
   * @param reason 更新原因
   */
  public updateCameraAuthorizeState(isUpdateCameraAuthorizeState: boolean, reason?: string): void {
    this.updateCameraAuthorizeStatusAsm.updateState(isUpdateCameraAuthorizeState, reason);
  }

  /**
   * 更新相机权限卡片透明度
   *
   * @param cameraCardOpacity 更新相机权限透明度
   * @param reason 更新原因
   */
  public updateCameraCardOpacity(cameraCardOpacity: number, reason?: string): void {
    this.updateCameraCardOpacityAsm.updateState(cameraCardOpacity, reason);
  }

  /**
   * 更新是否显示预加载视图
   *
   * @param isShowPreview 是否显示预加载视图
   * @param reason 更新原因
   */
  public updateIsShowPreview(isShowPreview: boolean, reason?: string): void {
    this.isShowPreviewAsm.updateState(isShowPreview, reason);
  }

  protected override doInit(config: IGridConfig): void {
    super.doInit(config);

    // 当宫格宽高未配置时，内部上报时机较为靠后，通过监听此变化来完成图片高度计算修复
    if (this.displayStateManager.gridAreaSizeAsm.currentState.width <= 0) {
      this.displayStateManager.gridAreaSizeAsm.registerObserver(this.displayListener);
    }
  }

  protected override doRelease(): void {
    this.displayStateManager.gridAreaSizeAsm.unRegisterObserver(this.displayListener);
    super.doRelease();
  }

  protected override updateStateFromInitConfig(config: GridConfig, reason?: string): void {
    // 更新宫格行间距
    this.updateAsmList(this.imageGutterManagers, config.imageGutters, reason);

    // 更新宫格列间距
    this.updateAsmList(this.imageColumnGutterManagers, config.imageColumnGutters, reason);

    // 更新缓存数量
    this.updateAsmList(this.cachedCountManagers, config.cachedCounts, reason);

    // 更新是否支持占位
    this.updateAsmList(this.isSupportFpManagers, [true, true, true, false], reason);

    //更新宫格左右内距
    this.gridPaddingAsm.updateState(config.gridPaddingLeftAndRight, reason);

    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);

    // 更新宫格列间距
    this.updateAsmList(this.imageGutterManagers, config.imageColumnGutters, reason);

    // 初始化分组状态
    this.isGroupAsm.updateState(config.isLastFormIsDayGroup, reason);

    // 初始化形态状态机
    this.formFsm.initIsLastFormIsDayGroup(config.isLastFormIsDayGroup);

    // 初始化宫格挡位
    this.gridLevelAsm.updateState(config.defaultGridLevel, reason);
  }

  private initManagers(persistentId: number): void {
    for (let irregularIndex = 0; irregularIndex < IRREGULAR_SIZE; irregularIndex++) {
      this.irregularTypeHeightManagers.push(
        new AttributeStateManager(persistentId, 0, `${IrregularType[irregularIndex]}_IrregularHeight`));
    }
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.irregularHeightManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_IrregularHeight`));
      this.gridHeightManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_GridHeight`));
      // 默认不规则高度为1，为消息头
      this.irregularCountManagers.push(
        new AttributeStateManager(persistentId, 1, `GRID_SWITCH_${FormIndex[formIndex]}_IrregularCount`));
      this.columnManagers.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}_Column`));
      this.imageGutterManagers.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}_ImageGutter`));
      this.imageColumnGutterManagers.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}_ImageColumnGutter`));
      this.cachedCountManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_CachedCount`));
      this.imageHeightManagers.push(new AttributeStateManager(persistentId, 0, `${FormIndex[formIndex]}_ImageHeight`));
      this.isSupportFpManagers.push(
        new AttributeStateManager(persistentId, false, `GRID_SWITCH_${FormIndex[formIndex]}_IsSupportFp`));
      this.fillPositionManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_FillPosition`));
      this.scrollOffsetManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_ScrollOffset`, false));
      this.firstIndexManagers.push(
        new AttributeStateManager(persistentId, 0, `GRID_SWITCH_${FormIndex[formIndex]}_FirstIndex`));
      this.gridShowFsmList.push(new GridShowFsm(persistentId, `${FormIndex[formIndex]}_GridShowFsm`));
      this.restoreFpFsmList.push(new RestoreFpFsm(persistentId, `${FormIndex[formIndex]}_RestoreFpFsm`));
    }
  }

  private getListItem<T>(list: T[], formIndex?: FormIndex): T {
    return list[formIndex ?? this.formFsm.getCurrentForm()] ?? list[FormIndex.DAY];
  }

  private updateColumnsInner(columns: number[], reason?: string, forceUpdate: boolean = false): void {
    if (!columns || columns.length !== FORM_SIZE) {
      LogUtils.warn(this.tag, 'updateColumnsInner invalid columnCounts.');
      return;
    }
    let needUpdate: boolean = false;
    let newColumns: number[] = this.allColumnAsm.currentState.slice();
    // 宫格宽度
    const gridWidth: number = this.displayStateManager.gridAreaSizeAsm.currentState.width;
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      if (this.getGridColumn(formIndex) !== columns[formIndex] && columns[formIndex] > 0) {
        LogUtils.info(this.tag, `updateColumnsInner, formIndex=${formIndex}, colums: ${columns[formIndex]} reason:${reason}`);
        // 更新宫格列数
        this.getColumnManager(formIndex).updateState(columns[formIndex], reason);
        // 更新宫格图片高度
        this.updateSingleImageHeight(gridWidth, formIndex, columns[formIndex], reason);
        newColumns[formIndex] = columns[formIndex];
        needUpdate = true;
      } else if (forceUpdate) {
        this.updateSingleImageHeight(gridWidth, formIndex, columns[formIndex], reason);
      }
    }
    if (needUpdate) {
      this.allColumnAsm.updateState(newColumns, reason);
    }
  }

  private updateImageHeights(gridWidth: number, reason?: string): void {
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.updateSingleImageHeight(gridWidth, formIndex, this.getGridColumn(formIndex), reason);
    }
  }

  private updateSingleImageHeight(gridWidth: number, formIndex: FormIndex, newColumn: number, reason?: string): void {
    if (!this.config.isAutoAdjustColumns) {
      return;
    }
    if (gridWidth <= 0) {
      LogUtils.warn(this.tag, 'updateSingleColumn invalid gridWidth.');
      return;
    }
    if (newColumn <= 0) {
      LogUtils.warn(this.tag, 'updateSingleColumn invalid newColumn.');
      return;
    }
    // 图片间距
    const gridColumnGutter: number = this.getImageColumnGutterManager(formIndex).currentState;
    // 图片高度
    const imageHeight: number = (gridWidth - (newColumn - 1) * gridColumnGutter) / newColumn;
    this.getImageHeightManager(formIndex).updateState(imageHeight, reason);
  }

  private updateAsmList<T>(originalList: AttributeStateManager<T>[], newList: T[], reason?: string): void {
    if (!newList || newList.length !== FORM_SIZE) {
      LogUtils.warn(this.tag, 'invalid params.');
      return;
    }
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      const manager = this.getListItem(originalList, formIndex);
      if (manager.currentState !== newList[formIndex] && newList[formIndex] > 0) {
        manager.updateState(newList[formIndex], reason);
      }
    }
  }
}