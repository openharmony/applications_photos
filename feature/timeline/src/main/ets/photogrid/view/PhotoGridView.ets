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

import lazy { common } from '@kit.AbilityKit';
import lazy  { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy {
  AppBarManager,
  GridAppBarManager as GridAppBarManagerViewModel
} from '@ohos/common/src/main/ets/default/viewmodel/GridAppBarManager';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { IGridConfig } from '../statemanager/config/GridConfig';
import lazy { PhotoGridVc } from '../viewcontroller/PhotoGridVc';
import lazy { PhotoGridVm } from '../viewmodel/PhotoGridVm';
import lazy  { titleBarMaskViewBuilder, TitleBarMaskViewBuildParams } from './GridTitleBarMaskView';
import lazy  { gridNoDataViewBuilder, GridNoDataViewBuildParams } from './GridNoDataView';
import lazy  {
  dayViewBuilder,
  DayViewBuildParams
} from './ViewLoader';
import lazy  { ISwitchConfig } from '../statemanager/config/SwitchConfig';
import lazy  { IPinchConfig } from '../statemanager/config/PinchConfig';
import lazy  { IToolbarConfig } from '../statemanager/config/ToolbarConfig';
import lazy  { ISelectConfig } from '../statemanager/config/SelectConfig';
import lazy  { IDisplayConfig } from '../statemanager/config/DisplayConfig';
import lazy { DataSourceManager } from '../model/DataSourceManager';
import lazy { dayPreviewBuilder, DayPreviewBuildParams } from './DayPreviewGridView';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { GridAppBarManager } from './GridAppBar';
import lazy { AppBar } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { ComponentLifecycleRegistry } from '@ohos/common/src/main/ets/default/view/ComponentLifecycle';
import lazy { irregularViewBuilder, IrregularViewBuildParams } from './IrregularView';
import lazy { fixedIrregularViewBuilder, FixedIrregularViewBuildParams } from './FixedIrregularView';
import lazy { SelectActionAdapter } from './adapter/SelectActionAdapter';
import lazy { IAlbumConfig } from '../statemanager/config/AlbumConfig';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { DeviceInfo as CustomDeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ITitleBarConfig } from '../statemanager/config/TitleBarConfig';

const TAG: string = 'PhotoGridView';
const FINGER_COUNT: number = 2;
const MIN_PINCH_DISTANCE: number = 0.01;

/**
 * 宫格视图
 */
@Component
export struct PhotoGridView {
  /**
   * [支持重载]组件实例ID, 默认使用新的ID
   */
  public persistentId: number = 0;
  /**
   * [支持重载]宫格配置，仅初始化时生效
   */
  public gridConfig?: IGridConfig;
  /**
   * [支持重载]切换配置，仅初始化时生效
   */
  public switchConfig?: ISwitchConfig;
  /**
   * [支持重载]捏合配置，仅初始化时生效
   */
  public pinchConfig?: IPinchConfig;
  /**
   * [支持重载]菜单栏配置，仅初始化时生效
   */
  public titleBarConfig?: ITitleBarConfig;
  /**
   * [支持重载]工具栏配置，仅初始化时生效
   */
  public toolbarConfig?: IToolbarConfig;
  /**
   * [支持重载]多选配置，仅初始化时生效
   */
  public selectConfig?: ISelectConfig;
  /**
   * [支持重载]屏幕显示配置，仅初始化时生效
   */
  public displayConfig?: IDisplayConfig;
  /**
   * [支持重载]相册配置，仅初始化时生效
   */
  public albumConfig?: IAlbumConfig;
  /**
   * [支持重载]宫格数据源
   */
  public dataSourceManager?: DataSourceManager;
  /**
   * [支持重载]宫格数据源，异步方式，优先级高于dataSourceManager
   */
  public asyncDataSourceManager?: Promise<DataSourceManager>;
  /**
   * [支持重载]选择动作适配器
   */
  public selectActionAdapter?: SelectActionAdapter;
  /**
   *  键盘特性事件
   */
  public keyBoardEventHub?: common.EventHub;
  /**
   *  是否使用双击事件
   */
  public isUseDoubleClick?: boolean;
  /**
   * [支持重载]宫格视图控制器
   */
  @State public viewController: PhotoGridVc = new PhotoGridVc();
  /**
   * [支持重载]宫格视图模型
   */
  public viewModel: PhotoGridVm = new PhotoGridVm();
  public navPathStack: NavPathStack = new NavPathStack();
  @State public broadcast: BroadCast = new BroadCast();
  /**
   * [支持重载]宫格标题栏蒙层构建方法
   */
  @BuilderParam public titleBarMaskViewBuilder: ($$: TitleBarMaskViewBuildParams) => void = titleBarMaskViewBuilder;
  /**
   * [支持重载]宫格无数据视图构建方法
   */
  @BuilderParam public noDataViewBuilder: ($$: GridNoDataViewBuildParams) => void = gridNoDataViewBuilder;
  /**
   * [支持重载]宫格日视图构建方法
   */
  @BuilderParam public dayViewBuilder: ($$: DayViewBuildParams) => void = dayViewBuilder;
  /**
   * [支持重载]日宫格预览视图构建方法
   */
  @BuilderParam public dayPreviewBuilder: ($$: DayPreviewBuildParams) => void = dayPreviewBuilder;
  /**
   * [支持重载]不规则区域视图构建方法
   */
  @BuilderParam public irregularViewBuilder: ($$: IrregularViewBuildParams) => void = irregularViewBuilder;
  /**
   * [支持重载]固定不规则区域视图构建方法
   */
  @BuilderParam public fixedIrregularViewBuilder: ($$: FixedIrregularViewBuildParams) => void =
    fixedIrregularViewBuilder;

  public readonly gridAppBarManager: AppBarManager = new GridAppBarManager();
  private readonly lifecycleRegistry: ComponentLifecycleRegistry = new ComponentLifecycleRegistry();
  public readonly albumInfo: AlbumInfo = new AlbumInfo();
  public readonly recycleBottomHeight: number = 0;
  private navPathStackBindSheet: NavPathStack = new NavPathStack();

  @State private selectCoverItem: MediaItem = new MediaItem();

  /**
   * 宫格进大图控制器
   */
  @Consume browserController: PhotosHmBrowserController;
  private isShowSdCardTip: boolean = false;
  private saveDialogController?: CustomDialogController;

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    TraceUtils.startTrace(TraceTaskType.PHOTO_GRID_INIT);
    if (this.persistentId === 0) {
      this.persistentId = GridStateProxy.getNewProxyId();
    }
    this.initConfig();
    this.viewModel.init(this.persistentId, this.keyBoardEventHub);
    this.viewController.init(this.viewModel);
    this.initSelectActionHandler();
    this.initGridAppBarManager();
    TraceUtils.finishTrace(TraceTaskType.PHOTO_GRID_INIT);
    LogUtils.info(TAG, `日视图是否初始化:+ this.viewController.isDayViewInit:${this.viewController.isDayViewInit}
    +this.viewController.this.viewController.isDayPreviewInit:${this.viewController.isDayPreviewInit}`);
    LogUtils.info(TAG, `this.viewController.isNoDataViewInit : ${JSON.stringify(this.viewController.isNoDataViewInit)}`);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.saveDialogController = undefined;
    this.selectActionAdapter?.release();
    this.viewController.release();
    this.viewModel.release();
    this.gridAppBarManager.release();
    this.lifecycleRegistry.aboutToDisappear();
    GridStateProxy.releaseInstance(this.persistentId);
  }

  // 初始化配置
  private initConfig(): void {
    GridStateProxy.getInstance(this.persistentId).init({
      gridConfig: this.gridConfig,
      switchConfig: this.switchConfig,
      pinchConfig: this.pinchConfig,
      titleBarConfig: this.titleBarConfig,
      toolbarConfig: this.toolbarConfig,
      selectConfig: this.selectConfig,
      displayConfig: this.displayConfig,
      albumConfig: this.albumConfig,
      dataSourceManager: this.dataSourceManager,
      asyncDataSourceManager: this.asyncDataSourceManager,
    });
  }

  private initSelectActionHandler(): void {
    if (!this.selectActionAdapter) {
      this.selectActionAdapter = new SelectActionAdapter();
    }
    this.selectActionAdapter.init(this.persistentId);
  }

  private initGridAppBarManager(): void {
    let params: ParamsWrapper = new ParamsWrapper().set(GridAppBarManager.KEY_INSTANCE_ID, this.persistentId)
      .set(GridAppBarManager.KEY_CONTEXT, getContext())
      .set(GridAppBarManager.KEY_UI_CONTEXT, this.getUIContext())
      .set(GridAppBarManager.KEY_NAV_PATH_STACK, this.navPathStack)
      .set(GridAppBarManager.KEY_BROADCAST, this.broadcast)
      .set(GridAppBarManager.KEY_LIFECYCLE, this.lifecycleRegistry)
      .set(GridAppBarManager.KEY_BROWSER_CONTROLLER, this.browserController)
      .set(GridAppBarManagerViewModel.KEY_IS_USE_DOUBLE_CLICK, this.isUseDoubleClick)
      .set(GridAppBarManager.KEY_DATASOURCE, this.dataSourceManager?.dayDataSource);
    this.gridAppBarManager.init(params);
  }


  @State private bindSheetHeight: number = 0;

  @State private bindSheetWidth: Dimension = SheetSize.LARGE;

  private bindSheetWidthAndHeight(): void {
    // 分栏
    if (getScreen().isSplitMode()) {
      LogUtils.info(TAG, 'This is a Split Mode');
      this.bindSheetHeight = getScreen().getWinHeight() > getScreen().getWinWidth() ? getScreen().getWinHeight() :
      getScreen().getWinWidth();
      this.bindSheetWidth = SheetSize.LARGE;
      return;
    }
    // xxx展开或者平板
    if (DeviceInfo.isFoldable() || DeviceInfo.isTablet()) {
      LogUtils.info(TAG, 'This is a Fold or pad devices');
      // 560vp
      this.bindSheetHeight = 1750;
      this.bindSheetWidth = '480vp';
      return;
    }
    // 直板机横屏
    if (DeviceInfo.isPhoneUx() && isOrientationHorizontal()) {
      LogUtils.info(TAG, 'This is a mobile phone and it is horizontal');
      this.bindSheetHeight = getScreen().getWinHeight() - 8;
      this.bindSheetWidth = '480vp';
      return;
    }
    // 直板机竖屏
    if (!isOrientationHorizontal() && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() &&
      !getScreen().isSplitMode()) {
      LogUtils.info(TAG, 'This is a mobile phone and it is vertical');
      // 底部弹窗距离信号栏为8vp
      this.bindSheetHeight = getScreen().getWinHeight() - getScreen().getStatusBarHeight() - 8;
      this.bindSheetWidth = '100%';
      return;
    }
  }

  @Builder
  buildTopHelpView() {
    // 标题栏
    AppBar({ controller: this.gridAppBarManager.actionBarController });

    // 标题栏蒙层
    if (this.viewController.isTitleBarMaskInit) {
      this.titleBarMaskViewBuilder({
        persistentId: this.persistentId,
      })
    }

    // 不规则区域
    if (this.viewController.isIrregularViewInit) {
      // 固定不规则区域
      this.fixedIrregularViewBuilder({
        persistentId: this.persistentId,
      })
      if (!this.viewController.isNoDataState) {
        // 非固定不规则区域
        this.irregularViewBuilder({
          persistentId: this.persistentId,
        })
      }
    }
  }

  @Builder
  bottomHelperView() {
    if (this.gridAppBarManager.toolbarController) {
      // 工具栏
      AppBar({ controller: this.gridAppBarManager.toolbarController });
    }
  }

  @Builder
  buildNoDataView() {
    if (this.viewController.isNoDataViewInit) {
      this.noDataViewBuilder({
        persistentId: this.persistentId,
      })
    }
  }

  @Builder
  buildDayView() {
    // 日预览视图
    if (this.viewController.isDayPreviewInit) {
      this.dayPreviewBuilder({
        persistentId: this.persistentId,
      })
    }

    // 日视图
    if (this.viewController.isDayViewInit) {
      this.dayViewBuilder({
        persistentId: this.persistentId,
        isShowSdCardTip: this.isShowSdCardTip,
        broadCast: this.broadcast,
        albumInfo: this.albumInfo,
        recycleBottomHeight: this.recycleBottomHeight,
      })
    }
  }

  @Builder
  buildGrid() {
    // 宫格本体控件
    RelativeContainer() {
      // 宫格上方的顶部辅助视图
      this.buildTopHelpView();

      // 无数据视图
      this.buildNoDataView();

      // 日视图
      this.buildDayView();

      // 宫格下方的底部辅助视图
      this.bottomHelperView();
    }
    .attributeModifier(this.viewController.gridUpdater)
    .gesture(TapGesture({ count: 1 }).onAction(() => this.selectActionAdapter?.onTapGesture()))
    .accessibilityLevel('no')
    .onAreaChange((_oldValue, newValue) => {
      this.viewModel.updateGridAreaSize({
        width: newValue.width as number,
        height: newValue.height as number,
      });
    })
    .key(TAG + '_RelativeContainer')
  }

  build() {
    Stack() {
      // 宫格本体
      this.buildGrid();

      // 宫格弹框
      CustomDialogView({ broadCast: this.broadcast })
    }
    .attributeModifier(this.viewController.attributeUpdater)
    .accessibilityLevel('no')
  }
}