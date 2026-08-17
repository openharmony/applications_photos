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

import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { getScreen, ScreenManager, ColumnSize } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy {
  AppBarController,
  AppBarElementBuilder,
  AppBarStyler,
  TOOLBAR_ANIMATE_DURATION,
  TOOL_BAR_OPTIONS
} from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { CommAppBarStyler } from '@ohos/common/src/main/ets/default/view/actionbar/CommAppBarStyler';
import lazy { CommToolbarStyler } from '@ohos/common/src/main/ets/default/view/actionbar/CommToolbarStyler';
import lazy {
  ActionListener,
  ActionViewModel,
  MenuConstants,
  MenuHelper,
  OperationListener,
  ParamsWrapper
} from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy {
  firstLevelTitleBuilder,
  FirstLevelTitleProp
} from '@ohos/common/src/main/ets/default/view/actionbar/FirstLevelTitle';
import lazy { ActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/ActionRegister';
import lazy { MovieActionRegister, MovieListener } from '@ohos/common/src/main/ets/default/view/actionbar/MovieAction';
import lazy {
  VideoSplicingActionRegister,
  VideoSplicingListener
} from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { DeleteActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteAction';
import lazy { SelectMediaType } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MoveActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/MoveAction';
import lazy { FavorActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/FavorAction';
import lazy { CREATION, CreationActionRegister, } from '@ohos/common/src/main/ets/default/view/actionbar/CreationAction';
import lazy {
  MULTISELECT,
  MultiSelectActionRegister,
  selectionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/SelectionAction';
import lazy {
  RecoverActionRegister
} from '@ohos/common/src/main/ets/default/view/actionbar/RecoverAction';
import lazy { PrintActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/PrintAction';
import lazy {
  ActionButtonProp,
  immersiveActionBuilder,
  toolbarActionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/ActionButton';
import lazy { ViewId, ViewZIndex } from '../viewcontroller/constants/ViewDefine';
import lazy { GridMultiSelectViewModel } from '../viewmodel/GridMultiSelectViewModel';
import lazy { GridCancelViewModel } from '../viewmodel/GridCancelViewModel';
import lazy { ActionWrapper } from '@ohos/common/src/main/ets/default/interface/ActionWrapper';
import lazy {
  FavoriteChecker,
  MediaTypeChecker,
  GIFPhotoChecker,
  SelectedItemsParser,
  SelectListener,
  SelectManager
} from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { CancelActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/CancelAction';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { GridOperateFsm, OperateEventType } from '../statemanager/GridOperateFsm';
import lazy { EventHelper } from '@ohos/common/src/main/ets/default/view/ViewEventHelper';
import lazy { StorageUtils } from '@ohos/common/src/main/ets/default/utils/StorageUtils';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { GridStateManager } from '../statemanager/GridStateManager';
import lazy { IStateChangeObserver } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { ComponentLifecycleRegistry } from '@ohos/common/src/main/ets/default/view/ComponentLifecycle';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { FormEventType, FormStateType } from '../statemanager/GridFormFsm';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import type { AppBarManager } from '@ohos/common/src/main/ets/default/viewmodel/GridAppBarManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BrowserJumper } from '../viewmodel/BrowserJumper';
import lazy { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { VIDEO_SPLICING } from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { MOVIE } from '@ohos/common/src/main/ets/default/view/actionbar/MovieAction';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';

const TAG: string = 'GridAppBar';
/**
 * 菜单栏元素个数阈值
 */
const TOOL_MENU_LIST_LENGTH_THRESHOLD: number = 4;

export enum FeatureType {
  FEATURE_PHOTO_CREATE, // 图库创作特性
  FEATURE_PHOTO_AUTO_CLIP //流光易剪
}
export class GridAppBarManager implements AppBarManager {
  public static readonly KEY_INSTANCE_ID: string = 'KEY_INSTANCE_ID';
  public static readonly KEY_CONTEXT: string = 'KEY_CONTEXT';
  public static readonly KEY_UI_CONTEXT: string = 'KEY_UI_CONTEXT';
  public static readonly KEY_NAV_PATH_STACK: string = 'KEY_NAV_PATH_STACK';
  public static readonly KEY_BROADCAST: string = 'KEY_BROADCAST';
  public static readonly KEY_LIFECYCLE: string = 'KEY_LIFECYCLE';
  public static readonly KEY_BROWSER_CONTROLLER: string = 'KEY_BROWSER_CONTROLLER';
  public static readonly BUILDER_KEY_TITLE: string = 'Grid_Title';
  public static readonly KEY_DATASOURCE: string = 'KEY_DATASOURCE';

  /**
   * View层Controller，对外提供
   */
  @Track public actionBarController: AppBarController = new AppBarController();
  @Track public toolbarController: AppBarController = new AppBarController();
  /**
   * 样式控制器
   */
  protected actionBarStyler: AppBarStyler | undefined;
  protected toolbarStyler: AppBarStyler | undefined;
  /**
   * 菜单点击处理分发（Action形式）
   */
  protected readonly menuHelper: MenuHelper = new MenuHelper();
  /**
   * 用于放非Action类的builder，不需要每次都创建
   */
  protected readonly elements: Map<string, AppBarElementBuilder> = new Map();
  /**
   * 用于放actions，不需要每次都创建M/V/VM
   */
  protected readonly actions: Map<string, ActionWrapper> = new Map();
  protected readonly selectedParseResult: ParamsWrapper = new ParamsWrapper();
  /**
   * 初始化参数
   */
  protected initParams: ParamsWrapper | undefined = undefined;
  protected instanceId: number = 0;
  protected context: Context | undefined;
  protected gridStateManager: GridStateManager | undefined;
  /**
   * 标题栏观察者代理
   */
  protected gridObserverProxy: GridStateObserverProxy = new GridStateObserverProxy();
  protected uiContext: UIContext | undefined;
  protected selectedItemsParser: SelectedItemsParser | undefined;
  protected selectManager: SelectManager | undefined;
  protected readonly deleteOperationListener: OperationListener = {
    onOperationStart: () => {
      LogUtils.info(TAG, 'deleteOperationListener onOperationStart');
      this.onOperationStart();
    },
    onOperationEnd: () => {
      LogUtils.info(TAG, 'deleteOperationListener onOperationEnd');
      this.quitSelectMode();
      this.onOperationEnd();
    }
  }
  protected readonly operationListener: OperationListener = {
    onOperationStart: () => {
      LogUtils.info(TAG, 'operationListener onOperationStart');
      this.onOperationStart();
    },
    onOperationEnd: () => {
      LogUtils.info(TAG, 'operationListener onOperationEnd');
      this.quitSelectMode();
      this.onOperationEnd()
    },
  };
  // 避免连续点击触发执行
  private isDoingAction = false;
  protected readonly getIsDoingAction: Function = (): boolean => {
    return this.isDoingAction;
  };
  protected readonly setIsDoingAction: Function = (state: boolean): void => {
    this.isDoingAction = state;
  };
  protected readonly batchOperationListener: OperationListener = {
    onOperationStart: () => {
      LogUtils.info(TAG, 'batchOperationListener onOperationStart');
      this.onOperationStart()
    },
    onOperationEnd: () => {
      LogUtils.info(TAG, 'batchOperationListener onOperationEnd');
      this.quitSelectMode();
      this.onOperationEnd();
      this.isDoingAction = false;
    },
  }
  protected readonly moveListener: OperationListener = {
    onOperationStart: () => {
      LogUtils.info(TAG, 'moveListener onOperationStart');
      this.onOperationStart()
    },
    onOperationEnd: () => {
      LogUtils.info(TAG, 'moveListener onOperationEnd');
      // 移动操作跳转到选择相册界面时，可能修改状态栏颜色，这里在操作完成时复原
      let currentStatusColor: string = ImmersiveController.FONT_COLOR_LIGHT;
      // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态和是否处于分组视图，浅色模式的非沉浸态时和浅色模式的分组视图时都是黑色
      if (!this.gridObserverProxy.gridObserverProxy.getIsImmersive() && AppStorage.get('currentColorMode') !==
      ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        currentStatusColor = ImmersiveController.FONT_COLOR_DARK;
      }
      WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
      this.quitSelectMode();
      this.onOperationEnd();
    },
  };
  private readonly collageListener: OperationListener = {
    onOperationEnd: () => {
      this.quitSelectMode();
    }
  };
  private readonly documentScanListener: OperationListener = {
    onOperationEnd: () => {
      this.quitSelectMode();
    }
  };
  protected readonly movieBrowserJumper: BrowserJumper = new BrowserJumper();
  protected readonly movieListener: MovieListener = {
    onOperationStart: () => this.onOperationStart(),
    onOperationEnd: () => {
      this.quitSelectMode();
      this.onOperationEnd();
    },
    jumpToBrowser: (item: MediaItem) => this.movieBrowserJumper?.setTargetItem(item)
  };
  protected readonly videoSplicingListener: VideoSplicingListener = {
    onOperationStart: () => this.onOperationStart(),
    onOperationEnd: () => {
      this.quitSelectMode();
      this.onOperationEnd();
    },
    jumpToBrowser: (item: MediaItem) => this.movieBrowserJumper?.setTargetItem(item)
  };
  protected broadCast: BroadCast | undefined;
  private lifecycle: ComponentLifecycleRegistry | undefined;
  private readonly onLayoutChangedFunc: Function = (): void => this.updateLayout();
  private readonly selectListener: SelectListener = {
    onModeChanged: (newMode: boolean) => this.onSelectModeChanged(),
    onSelectCountChanged: (newCount: number) => {
      this.updateAppBar();
      this.selectedItemsParser?.notifyDirty();
    },
  };
  private readonly onAreaChange: (oldValue: Area, newValue: Area) => void =
    (oldValue: Area, newValue: Area) => this.onActionBarAreaChanged(oldValue, newValue);
  private readonly backPressEventHandler: (event: string) => boolean = (event: string) => {
    Log.info(TAG, `onBackPress ${this.selectManager?.isSelectedMode()}`);
    if (this.selectManager?.isSelectedMode()) {
      // 退出选择模式
      this.quitSelectMode();
      return true;
    }
    return false;
  }
  private readonly immersiveStateObserver: IStateChangeObserver<boolean, string> = {
    onStateChange: (oldState: boolean, newState: boolean, event?: string | undefined): void => {
      Log.info(TAG, `onImmersiveStateChanged ${this.gridStateManager?.immersiveAsm.currentState}`);
      this.updateLayout();
    }
  };
  private readonly formStateObserver: IStateChangeObserver<FormStateType, FormEventType> = {
    onStateChange: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): void => {
      this.updateLayout();
    }
  }
  private readonly favorCountChecker: FavoriteChecker = new FavoriteChecker();
  private readonly mediaTypeChecker: MediaTypeChecker = new MediaTypeChecker();
  private readonly gifPhotoChecker: GIFPhotoChecker = new GIFPhotoChecker();
  private readonly selectedItemsCheckerListener: DataListener<ParamsWrapper> = {
    onLoadingFinished: (result: LoadingResult<ParamsWrapper>) => this.updateCheckerResult(result),
  } as DataListener<ParamsWrapper>;
  protected albumInfo: AlbumInfo | undefined;
  private readonly actionListener: ActionListener = {
    onActionEvent: (action, params) => {
      LogUtils.info(TAG, `actionListener:${action?.actionID} ${action?.componentKey}`);
      let isNavToOtherPage: boolean = false;
      // 不是搜索操作时时设置返回桌面生效，搜索操作时设置返回桌面不生效
      if (action?.actionID !== ActionID.PHOTO_SEARCH) {
        isNavToOtherPage = true;
      }
      this.gridStateManager?.actionStateAsm?.updateState(isNavToOtherPage, action?.componentKey);
    }
  };
  private gridBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public init(params: ParamsWrapper): void {
    /*
     * 初始化所有ActionBar、ToolBar涉及的元素，其builder（View层）放到
     * 常规元素，涉及 Model View ViewModel，其中：
     * - Model：元素操作场景的数据提供者
     * - View：View本身会注入到AppBar中，由AppBarController持有，以Prop/Controller开放外部控制
     *   可以通过AppBarController的get(key: string)接口获取
     * - ViewModel：一般持有Model，处理点击事件，非Action的自定义元素/扩展Action（比如动态图片等有弹出菜单）要自行处理用户交互
     * V寄宿于AppBarController，不应该有任何业务相关，比如监听等，应该由VM来通知V，所以M&VM可能涉及释放
     */
    this.initParams = params;
    this.instanceId = this.initParams?.get<number>(GridAppBarManager.KEY_INSTANCE_ID) ?? 0;
    this.context = params.get<Context>(GridAppBarManager.KEY_CONTEXT);
    this.selectManager = GridStateProxy.getInstance(this.instanceId).selectManager;
    this.selectManager?.addListener(this.selectListener);
    this.broadCast = this.initParams?.get<BroadCast>(GridAppBarManager.KEY_BROADCAST);
    this.lifecycle = params.get<ComponentLifecycleRegistry>(GridAppBarManager.KEY_LIFECYCLE);
    this.uiContext = params.get<UIContext>(GridAppBarManager.KEY_UI_CONTEXT);
    StorageUtils.get<EventHelper<string>>(params.get<UIContext>(GridAppBarManager.KEY_UI_CONTEXT),
      Constants.LOCAL_KEY_INDEX_BACK_PRESS_EVENT_HELPER,
      new EventHelper<string>())?.register(this.backPressEventHandler);
    this.gridStateManager = GridStateProxy.getInstance(this.instanceId).gridStateManager;
    this.gridStateManager.immersiveAsm.registerObserver(this.immersiveStateObserver);
    this.gridObserverProxy.init(this.instanceId);
    GridStateProxy.getInstance(this.instanceId).formFsm.registerObserver(this.formStateObserver);
    this.selectedItemsParser = new SelectedItemsParser(this.selectManager);
    this.selectedItemsParser.addChecker(this.favorCountChecker);
    this.selectedItemsParser.addChecker(this.mediaTypeChecker);
    if (DeviceInfo.isPhone()) {
      this.selectedItemsParser?.addChecker(this.gifPhotoChecker);
    }
    this.selectedItemsParser.addListener(this.selectedItemsCheckerListener);

    // 顶部ActionBar与底部ToolBar各自控制（放入的元素/形态/位置等）
    this.actionBarStyler =
      this.actionBarStyler ??
        new CommAppBarStyler(getContext(), this.actionBarController, getScreen(), this.selectManager);
    this.actionBarStyler?.register?.();
    this.actionBarController.onAreaChange = this.onAreaChange;
    this.actionBarController.key = ViewId.TITLE_BAR;

    this.toolbarStyler = this.toolbarStyler ?? new CommToolbarStyler(this.toolbarController, getScreen());
    this.toolbarStyler?.register?.();
    this.toolbarController.key = ViewId.TOOL_BAR;
    this.toolbarController.options = TOOL_BAR_OPTIONS;
    this.toolbarController.height = Constants.ToolBarHeight;
    this.toolbarController.gapWidth = undefined;

    // 标题
    let titleProp: FirstLevelTitleProp = new FirstLevelTitleProp();
    titleProp.content = $r('app.string.tab_timeline');
    titleProp.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp});
    let titleBuilder: AppBarElementBuilder = {
      builder: firstLevelTitleBuilder,
      builderParams: titleProp,
      key: GridAppBarManager.BUILDER_KEY_TITLE,
    };
    this.elements.set(GridAppBarManager.BUILDER_KEY_TITLE, titleBuilder);

    getScreen().on(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    getScreen().on(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    getScreen().on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);

    this.extraInit();
    this.updateLayout();
  }

  public extraInit(): void {
    this.movieBrowserJumper.init(this.instanceId,
      GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource,
      this.initParams?.get<PhotosHmBrowserController>(GridAppBarManager.KEY_BROWSER_CONTROLLER));
  }

  public registerAppBar(): void {
    // 根据场景决定放进去哪些元素，同时根据视图形态确定ActionBar的样式（大小、位置、padding等）
    this.actionBarController.builders = [];
    if (this.selectManager?.mIsSelectedMode) {
      this.registerSelectionActions();
    } else {
      this.registerNonSelectionActions();
    }

    this.actionBarController.zIndex = ViewZIndex.TITLE_BAR;
    this.actionBarController.alignRules = {
      top: { anchor: '__container__', align: VerticalAlign.Top },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
    };
    this.menuHelper.getDispatcher()?.add(this.actionListener);
  }

  protected registerSelectionActions(): void {
    let params: ParamsWrapper =
      this.buildCommonParams().set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.actionBarController);

    // 取消
    let cancelViewModel: ActionViewModel | undefined = this.actions.get(Action.CANCEL.componentKey)?.viewModel;
    new CancelActionRegister(undefined, cancelViewModel ?? new GridCancelViewModel(this.instanceId)).register(params);

    // 未选择 / 已选择X项
    this.actionBarController.put(this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE));

    // 多选/全选/取消全选按钮
    if (this.usePhoneUx() || DeviceInfo.isTablet()) {
      params.set(MultiSelectActionRegister.KEY_CUSTOM_MULTISELECT_BUILDER, selectionBuilder);
    }
    let selectViewModel: ActionViewModel | undefined = this.actions.get(MULTISELECT.componentKey)?.viewModel;
    new MultiSelectActionRegister(selectViewModel ?? new GridMultiSelectViewModel(this.instanceId)).register(params);

    if (!this.showToolBar()) {
      this.registerCommonSelectActions(params);
    }
  }

  protected registerNonSelectionActions(): void {
    // 常规宫格非选择模式显示相册名等
  }

  public getFeatureType(type: FeatureType): boolean {
    return false;
  }

  protected registerCommonSelectActions(params: ParamsWrapper): void {
      if (!DeviceInfo.isVerdeFoldable()) {
        // 对比
        if ((this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE) ||
        this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) && DeviceInfo.isSupportMovie()) {
          // 入口开放
          // 创作
          new CreationActionRegister(this.registerCreationSelectActions(params)).register(params);
        }
      }

    // 移动到相册
    new MoveActionRegister().register(params);
    // 打印
    new PrintActionRegister().register(params);
    // 删除
    new DeleteActionRegister().register(params);

  }

  protected registerMoreSelectActions(params: ParamsWrapper): ActionRegister[] {
    return [
      new MoveActionRegister(),
      new FavorActionRegister(),
    ];
  }
  /**
   * 相册是否仅包含视频
   * @returns
   */
  private isAllVideo(): boolean {
    // 屏幕录制相册
    if (this.albumInfo?.lpath === Constants.LPATH_SCREEN_RECORDING) {
      return true;
    }
    // 视频相册
    if (this.albumInfo?.isVideoAlbum) {
      return true;
    }
    return false;
  }

  protected registerCreationSelectActions(params: ParamsWrapper): ActionRegister[] {
    let creationMenuList: ActionRegister[] = [];
    if (this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) {
      creationMenuList.push(new MovieActionRegister());
    }
    if (this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE)) {
      creationMenuList.push(new VideoSplicingActionRegister());
    }
    return creationMenuList;
  }

  protected setActionEnabled(action: Action, enabled: boolean) {
    let prop: ActionButtonProp | undefined = this.getProp(action);
    if (prop) {
      prop.isEnabled = enabled;
    }
  }

  protected setActionHidden(action: Action, isHidden: boolean) {
    let prop: ActionButtonProp | undefined = this.getProp(action);
    if (prop && prop.isHidden !== isHidden) {
      prop.isHidden = isHidden;
    }
  }

  protected showToolBar(): boolean {
    return (DeviceInfo.isTablet() || DeviceInfo.isPhoneUx()) && !getScreen().isHorizontal() &&
      !(DeviceInfo.isFoldable() && getScreen().isFullMode());
  }

  protected registerSelectionTools(): void {
    if (!this.showToolBar()) {
      this.toolbarController.visibility = Visibility.Hidden;
      return;
    }
    this.toolbarController.visibility = Visibility.Visible;

    let params: ParamsWrapper =
      this.buildCommonParams()
        .set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.toolbarController)
        .set(MenuConstants.KEY_CUSTOM_ACTION_BUILDER, toolbarActionBuilder) // 定制Action为ToolBar形式

    this.registerCommonSelectActions(params);
  }

  protected registerNonSelectionTools(): void {
    this.toolbarController.visibility = Visibility.Hidden;
  }

  protected updateToolBar(): void {
    this.toolbarController.builders = [];
    if (this.selectManager?.mIsSelectedMode) {
      this.registerSelectionTools();
    } else {
      this.registerNonSelectionTools();
    }

    this.toolbarController.zIndex = ViewZIndex.TITLE_BAR;
    this.toolbarController.alignRules = {
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
    };
  }
  /**
   * 照片页和相册页点击多选按钮后toolBar属性修改
   *
   * @param toolbarController 子类的toolbarController
   */
  protected  multiSelectToolBarParameter(toolbarController: AppBarController): void {
    toolbarController.gapWidth = 0;
    toolbarController.options = {
      direction: FlexDirection.Row,
      wrap: FlexWrap.NoWrap,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceAround,
    };
    let horizontalPadding: number = getScreen().getScreenColumns() === ColumnSize.COLUMN_FOUR &&
      toolbarController.builders.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD ? 0 :
      getScreen().getScreenColumns() === ColumnSize.COLUMN_EIGHT &&
        toolbarController.builders.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
        AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING*2 + (getScreen().getWinWidth() -
          AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING*9)/ColumnSize.COLUMN_EIGHT:
        AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING;
    toolbarController.padding = {
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: getScreen().getAiBarHeight(),
    };
  }

  protected buildCommonParams(): ParamsWrapper {
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_NAV_PATH_STACK, this.initParams?.get<NavPathStack>(GridAppBarManager.KEY_NAV_PATH_STACK))
      .set(MenuConstants.KEY_ACTION_COLLECTOR, this.actions)
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.selectManager)
      .set(MenuConstants.KEY_BROADCAST, this.broadCast)
      .set(MenuConstants.KEY_LIFECYCLE_REGISTRY, this.lifecycle)
      .set(MenuConstants.KEY_NAVIGATION_BROADCAST, NavigationBroadCastManager.getInstance().getBroadCast())
      .set(ActionRegister.ACTION_BAR_CONTROLLER, this.actionBarController)
      .set(ActionRegister.TOOL_BAR_CONTROLLER, this.toolbarController)
      .set(DeleteActionRegister.DELETE_LISTENER, this.deleteOperationListener)
      .set(MoveActionRegister.LISTENER, this.moveListener)
      .set(MoveActionRegister.SELECTED_PARSE_RESULT, this.selectedParseResult)
      .set(FavorActionRegister.LISTENER, this.batchOperationListener)
      .set(RecoverActionRegister.LISTENER, this.batchOperationListener)
      .set(MenuConstants.KEY_CUSTOM_ACTION_BUILDER, immersiveActionBuilder)
      .set(MovieActionRegister.LISTENER, this.movieListener)
      .set(VideoSplicingActionRegister.LISTENER, this.videoSplicingListener)
      .set(MenuConstants.KEY_DATASOURCE, this.initParams?.get<AlbumDataSource>(GridAppBarManager.KEY_DATASOURCE))
      .set(MenuConstants.KEY_GET_IS_DOING_ACTION, this.getIsDoingAction)
      .set(MenuConstants.KEY_SET_IS_DOING_ACTION, this.setIsDoingAction);
    return params;
  }

  protected usePhoneUx(): boolean {
    return DeviceInfo.isPhoneUx();
  }

  public updateAppBar(): void {
    // 设置按钮形态（多选/全选/取消全选）
    this.updateSelectionButton();

    if (!this.selectManager?.isSelectedMode()) {
      return;
    }

    // 以下为选择模式下特有
    let selectedCount: number = this.selectManager?.getSelectedCount() ?? 0;
    let msg: string[] = [`updateAppBar count: ${selectedCount}`];
    msg.push(`total: ${this.selectManager?.totalCount}`);
    Log.info(TAG, msg.join(', '));

    // 设置标题内容（未选择/已选择X项）
    this.updateSelectionTitle();

    this.setActionEnabled(VIDEO_SPLICING, selectedCount > 0);
    this.setActionEnabled(MOVIE, selectedCount > 0);
    this.setActionEnabled(CREATION, selectedCount > 0);
    this.setActionEnabled(Action.MOVE, selectedCount > 0);
    this.setActionEnabled(Action.PRINT, selectedCount > 0);
    this.setActionEnabled(Action.DELETE, selectedCount > 0);
    let gifPhotoChecker: boolean = this.selectedParseResult.get<boolean>(GIFPhotoChecker.KEY_IS_GIF_PHOTO);
    let mediaType: SelectMediaType =
      this.selectedParseResult.get<SelectMediaType>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE) ?? SelectMediaType.INVALID;
    this.setActionEnabled(Action.PRINT, selectedCount > 0 && mediaType === SelectMediaType.IMAGE);

    // 设置收藏/取消收藏
    this.updateFavor();
  }

  protected getProp(action: Action): ActionButtonProp | undefined {
    let props: (ActionButtonProp | undefined)[] = ActionUtils.getProps(this.actionBarController);
    props.push(...ActionUtils.getProps(this.toolbarController));
    let prop: ActionButtonProp | undefined;
    for (let prop of props) {
      if (prop?.action === action) {
        return prop;
      }
    }
    return prop;
  }

  private updateFavor(): void {
    let favorProp: ActionButtonProp | undefined = this.getProp(Action.FAVORITE);
    let hasUnFavoriteStatus: boolean = true;
    if (!favorProp) {
      Log.warn(TAG, 'favor action not found!');
      return;
    }
    for (let key of this.selectedParseResult.params.keys()) {
      if (key === FavoriteChecker.KEY_HAS_UN_FAVORITE) {
        hasUnFavoriteStatus = this.selectedParseResult.params.get(key)?.toString() === 'true'
        break;
      }
    }
    // 这俩字串内容跟名字是反的，action_not_favorite是“收藏”，action_favorite是“取消收藏”
    // 有未被收藏的就显示“收藏”，反之，全部都是收藏的才显示“取消收藏”
    let currentText: Resource | undefined = favorProp?.text as Resource;
    let targetText: Resource =
      hasUnFavoriteStatus ? $r('app.string.action_not_favorite') : $r('app.string.action_favorite');
    let targetIcon: Resource = hasUnFavoriteStatus ? $r('sys.symbol.heart') : $r('sys.symbol.heart_fill');
    let targetColor: ResourceColor = hasUnFavoriteStatus ? $r('sys.color.ohos_id_color_titlebar_icon') : $r('sys.color.icon_emphasize');
    if (currentText?.id !== targetText.id && favorProp) {
      favorProp.text = targetText;
      favorProp.icon = targetIcon;
      favorProp.fillColor = targetColor;
    }
  }

  protected updateSelectionTitle(): void {
    // 未选择 / 已选择x项
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: FirstLevelTitleProp | undefined = titleBuilder?.builderParams as FirstLevelTitleProp;
    if (!titleProp) {
      return;
    }

    let currentFontSize: number | string | Resource = titleProp.fontSize;
    if (currentFontSize !== AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE) {
      titleProp.fontSize = AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    }
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    ImmersiveController.isInImmersive = isImmersive;
    this.gridBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    let currentFontColor: ResourceColor = titleProp.fontColor;
    let targetColor: ResourceColor =
      isImmersive ? ImmersiveController.FONT_COLOR_LIGHT : ActionBarProp.NORMAL_TEXT_COLOR;
    if (currentFontColor !== targetColor) {
      titleProp.fontColor = targetColor;
    }

    let currentText: string | Resource | undefined = titleProp.content;
    let targetText: string | Resource | undefined;
    if (!this.selectManager?.isSelectedMode()) {
      targetText = $r('app.string.tab_timeline');
    } else {
      let count: number = this.selectManager.getSelectedCount();
      targetText =
        count > 0 ? $r('app.plural.count_details_selected', count, count) : $r('app.string.title_none_selected');
    }
    if (currentText !== targetText && targetText) {
      titleProp.content = targetText;
    }
    titleProp.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp});
  }

  protected updateSelectionButton(): void {
    let actionWrapper: ActionWrapper | undefined = this.actions.get(MULTISELECT.componentKey);
    let currentProp: ActionButtonProp | undefined = actionWrapper?.controller as ActionButtonProp;
    if (!currentProp) {
      Log.info(TAG, `updateSelectionButton. currentProp is null`);
      return;
    }
    // 是否全选
    const isSelectAll: boolean = this.selectManager?.getSelectedCount() === this.selectManager?.totalCount;
    let targetText: string | Resource = $r('app.string.multiselect');
    if (this.selectManager?.isSelectedMode()) {
      targetText = isSelectAll ? $r('app.string.action_deselect_all') : $r('app.string.action_select_all');
      currentProp.key = isSelectAll ? Action.DESELECT_ALL.componentKey : Action.SELECT_ALL.componentKey;
    } else {
      currentProp.key = Action.MULTISELECT.componentKey;
    }
    if (currentProp?.text !== targetText) {
      currentProp.text = targetText;
    }
    currentProp.icon = isSelectAll ? Action.DESELECT_ALL.iconRes : Action.SELECT_ALL.iconRes;
    currentProp.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp});
  }

  protected updateLayout(): void {
    let msg: string[] = [`updateLayout select: ${this.selectManager?.mIsSelectedMode}`];
    msg.push(`showToolBar: ${this.showToolBar()}`);
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    msg.push(`isImmersive: ${isImmersive}`);
    Log.info(TAG, msg.join(', '));
    this.registerAppBar();
    this.updateToolBar();
    this.updateAppBar();
  }

  protected onActionBarAreaChanged(oldValue: Area, newValue: Area): void {
    this.updateTitleBarHeight(newValue.height as number);

    let threshold: number = (Constants.ActionBarHeight - AppBarStyles.ACTION_BAR_BUTTON_HEIGHT) / 2;
    Log.info(TAG, `onActionBarAreaChanged immersiveThreshold: ${threshold}`);
    GridStateProxy.getInstance(this.instanceId)
      .titleBarStateManager
      .immersiveThresholdAsm
      .updateState(threshold, 'GridAppBar area changed');
    let currentStatusColor: string = ImmersiveController.FONT_COLOR_LIGHT;
    // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态和是否处于分组视图，浅色模式的非沉浸态时和浅色模式的分组视图时都是黑色
    if (!this.gridObserverProxy.gridObserverProxy.getIsImmersive() && AppStorage.get('currentColorMode') !==
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      currentStatusColor = ImmersiveController.FONT_COLOR_DARK;
    }
    WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
  }

  protected updateTitleBarHeight(height: number): void {
    let newHeight: number = Math.max(0, height);
    Log.info(TAG, `onActionBarAreaChanged: ${newHeight}`);
    GridStateProxy.getInstance(this.instanceId)
      .titleBarStateManager
      .titleBarHeightAsm
      .updateState(newHeight, 'GridAppBar changed');
  }

  protected quitSelectMode(): void {
    Log.info(TAG, 'quitSelectMode');
    let operateFsm: GridOperateFsm = GridStateProxy.getInstance(this.instanceId).operateFsm;
    this.selectManager?.deSelectAll();
    this.selectManager?.onModeChange(false);
    operateFsm.submitEvent(OperateEventType.ENTER_BROWSER);
  }

  protected onOperationStart(): void {
    LogUtils.info(TAG, 'onOperationStart');
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.pause();
  }

  protected onOperationEnd(): void {
    LogUtils.info(TAG, `onOperationEnd`);
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.resume();
  }

  protected onSelectModeChanged(): void {
    this.updateLayout();
    if (this.showToolBar()) {
      // 进入选择模式，anchor从0->100，反之退出时，从100->0
      let startAnchor: string = this.selectManager?.isSelectedMode() ? '-100%' : '0%';
      let endAnchor: string = this.selectManager?.isSelectedMode() ? '0%' : '-100%';
      this.toolbarController.markAnchor = {
        x: Constants.PERCENT_0,
        y: startAnchor,
      };
      this.uiContext?.animateTo({
        curve: Curve.Friction,
        duration: TOOLBAR_ANIMATE_DURATION,
      }, () => {
        this.toolbarController.markAnchor = {
          x: Constants.PERCENT_0,
          y: endAnchor,
        };
      });
    } else {
      let anchor: string = this.selectManager?.isSelectedMode() ? '0%' : '-100%';
      this.toolbarController.markAnchor = {
        x: Constants.PERCENT_0,
        y: anchor,
      };
    }
  }

  protected updateCheckerResult(result: LoadingResult<ParamsWrapper>): void {
    this.selectedParseResult.params.clear();
    let checkResult: ParamsWrapper | undefined = result.newPageData.data[0];
    if (!checkResult) {
      return;
    }

    for (let key of checkResult.params.keys()) {
      this.selectedParseResult.set(key, checkResult.params.get(key));
    }
    this.updateAppBar();
  }

  public release(): void {
    this.actionBarStyler?.unregister?.();
    this.toolbarStyler?.unregister?.();
    for (let wrapper of this.actions.values()) {
      wrapper.model?.release?.();
      wrapper.viewModel?.release?.();
    }
    getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    getScreen().off(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    getScreen().off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);
    this.selectManager?.removeListener(this.selectListener);
    StorageUtils.get<EventHelper<string>>(this.initParams?.get<UIContext>(GridAppBarManager.KEY_UI_CONTEXT),
      Constants.LOCAL_KEY_INDEX_BACK_PRESS_EVENT_HELPER,
      new EventHelper<string>())?.unregister(this.backPressEventHandler);
    this.gridStateManager?.immersiveAsm.unRegisterObserver(this.immersiveStateObserver);
    this.gridObserverProxy.release();
    GridStateProxy.getInstance(this.instanceId).formFsm.unRegisterObserver(this.formStateObserver);
    this.selectedItemsParser?.removeAllCheckers();
    this.selectedItemsParser?.removeListener(this.selectedItemsCheckerListener);
    this.menuHelper.getDispatcher()?.remove(this.actionListener);
  }
}
