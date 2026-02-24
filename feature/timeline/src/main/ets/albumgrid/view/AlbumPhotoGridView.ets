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

import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { getScreen,
  isOrientationHorizontal,
  ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { GridController } from '../../photogrid/viewmodel/GridController';
import lazy { GridAppBarManager } from '../../photogrid/view/GridAppBar';
import lazy { GridStateObserverProxy } from '../../photogrid/statemanager/GridStateObserverProxy';
import lazy { GridStateProxy } from '../../photogrid/statemanager/GridStateProxy';
import lazy { FormIndex } from '../../photogrid/statemanager/constants/GridDefine';
import lazy { GridInitConfigSyncer } from '../../view/adapter/GridInitConfigSyncer';
import lazy { PhotoGridView } from '../../photogrid/view/PhotoGridView';
import lazy { SwitchMode } from '../../photogrid/statemanager/constants/SwitchDefine';
import lazy { DataSourceManager } from '../../photogrid/model/DataSourceManager';
import lazy { TimelineDataSourceProxy } from '../../model/TimelineDataSourceProxy';
import lazy { FormEventTypeUtils, FormStateTypeUtils } from '../../photogrid/statemanager/GridFormFsm';
import lazy { ParamAlbumInfo } from '@ohos/common/src/main/ets/default/interface/Album';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { AlbumRefreshConst, PageStatusListener } from '@ohos/common/src/main/ets/default/utils/AlbumRefreshUtil';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { IAlbumConfig } from '../../photogrid/statemanager/config/AlbumConfig';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy {AlbumCoverPreviewPage} from  '../view/albumCover/AlbumCoverPreviewPage'
import lazy {AlbumCoverSelectPage} from  '../view/albumCover/AlbumCoverSelectPage'
import lazy { JSON } from '@kit.ArkTS';
import lazy { AlbumPhotoGridVm } from '../viewmodel/AlbumPhotoGridVm';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { GridToolBarPosition } from '../../photogrid/statemanager/constants/ToolBarDefine';
import lazy { BigDataConstants,
  ReportToBigDataUtil,
  AlbumBrowsingInfo,
  PhotoInfo
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine'
import lazy { AlbumBigDataConstants } from '@ohos/common/src/main/ets/default/model/browser/album/ReportAlbumDataUtil';
import lazy { CustomBuilderLoaderParam } from './CustomBuilderLoaderParam';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { ComponentLifecycleRegistry } from '@ohos/common/src/main/ets/default/view/ComponentLifecycle';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';
import lazy { IrregularViewBuildParams } from '../../photogrid/view/IrregularView';
import lazy { buildSortSelectorView } from './../../photogrid/view/common/SortSelectorView';
import lazy { AlbumGridSortHelper, SortRuleString } from '@ohos/common/src/main/ets/default//model/AlbumGridSortHelper'
import lazy { DEFAULT_TOP_AVOID_HEIGHT } from '../../photogrid/statemanager/constants/DisplayDefine';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

const TAG = 'AlbumPhotoGridView';

@Observed
export class BindSheetController {
  public static readonly KEY_ALBUM_COVER_CONTROLLER: string = 'com.ohos.photos.album_change_controller';
  public isShow: boolean = false;
}

@Component
export struct AlbumPhotoGridView {
  @State @Watch('onIsPageHiddenChange') private isPageHidden: boolean = false;
  // 其他全局参数
  @StorageLink('isHorizontal') @Watch('isHorizontalChange') private isHorizontal: boolean =
    AppStorage.get<boolean>('isHorizontal') ?? false;
  // 状态栏高度
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') statusBarHeight: number =
    AppStorage.get('statusBarHeight') ?? 0;

  @Consume @Watch('onBrowserControllerChanged') browserController: PhotosHmBrowserController;

  @State private timeController: TimeController = new TimeController();

  @ObjectLink private bindSheetController : BindSheetController ;

  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;

  @State private immersiveController: ImmersiveController = new ImmersiveController(this.currentMode,
    this.getIsHorizontal4Vxx(), false, 20, this.timeController);

  @State public broadcast: BroadCast = new BroadCast();

  @Prop @Watch('onPageChanged') pageStatus: boolean = false;

  @State private isReady: boolean = false;

  @Link  isSelectedMode: boolean;

  // 宫格初始配置同步器
  public gridInitConfigSyncer?: GridInitConfigSyncer;

  public navPathStack: NavPathStack = new NavPathStack();

  public gridAppBarManager: GridAppBarManager = new GridAppBarManager();

  /**
   * [支持重载]相册配置，仅初始化时生效
   */
  public albumGridConfig?: IAlbumConfig;

  public customBuilderLoaderParam: CustomBuilderLoaderParam | undefined = undefined;

  // 实例ID
  private persistentId: number = 0;

  private readonly gridController: GridController = new GridController();

  private readonly observerProxy: GridStateObserverProxy = new GridStateObserverProxy();

  private isShowSideBar: boolean = DeviceInfo.isPhoneUx() ? false : ActionBarVar.isShowSideBar;

  private importDataSource: AlbumDataSource | undefined = undefined;

  private dataSourceManager: DataSourceManager | undefined = undefined;

  @State albumInfo: AlbumInfo | undefined = undefined;

  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  private albumNameChangeFunc: Function =
    (newAlbumName: string, oldAlbumUri: string): Promise<void> => this.onAlbumNameUpdate(newAlbumName, oldAlbumUri);

  private onAlbumClickListener: PageStatusListener | undefined = undefined;

  // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
  private readonly lifecycleRegistry: ComponentLifecycleRegistry = new ComponentLifecycleRegistry();

  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private readonly onPickerOperationBackToExistAlbumFunc: Function =
    (): void => this.onPickerOperationBackToExistAlbum();

  private readonly menuHelper: MenuHelper = new MenuHelper();

  public selectManager: TimelineSelectManager = new TimelineSelectManager();

  private viewModel: AlbumPhotoGridVm = new AlbumPhotoGridVm();

  @StorageLink('photoGridViewOpacity') photoGridViewOpacity: number = 0;

  private navPathStackBindSheet: NavPathStack = new NavPathStack();

  @State private bindSheetHeight: number = 0;

  @State private bindSheetWidth: Dimension = SheetSize.LARGE;

  @State private selectCoverItem: MediaItem = new MediaItem();

  private readonly onWinsizeChangedCallbackFunc: Function = (): void => this.onWinsizeChangedCallback();
  private irregularViewBuilder: (($$: IrregularViewBuildParams) => void) | undefined = undefined;

  private enterAlbumTime: number = 0;
  @StorageProp('change_background') @Watch('changeBackgroundStatus') isBackGround: boolean = false;
  private isSupportGroupDay?: boolean = false;

  isSearchResultPage = false;

  /**
   * 直接赋值给新框架的SelectManager
   */
  public initSelectManager: TimelineSelectManager | undefined;

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

  aboutToAppear(): void {
    LogUtils.info(TAG, `aboutToAppear ${this.initSelectManager?.albumInfo}`);
    LogUtils.info(TAG, `isSupportGroupDay :${this.isSupportGroupDay}`);
    this.isReady = false;
    this.appBroadCast.emit(BroadCastConstants.MAP_MOVING_CHANGE, [false]);
    this.persistentId = GridStateProxy.getNewProxyId();
    this.observerProxy.init(this.persistentId);
    this.viewModel.setNavPathStack(this.navPathStack);
    this.gridController.init(this.persistentId);
    this.gridController.initSubComponentState(this.timeController, this.immersiveController);
    this.observerGridController(this.gridController);
    this.initAlbumInfo().then(() => {
      this.dataSourceManager = new DataSourceManager(this.persistentId, this.importDataSource,
        new TimelineDataSourceProxy(this.importDataSource));
      this.isReady = true;
    });
    if (this.isSearchResultPage) {
      this.photoGridViewOpacity = 1;
    }
    this.initAlbumConfig();
    // 设置相册页数据 inactive 状态
    getContext()?.eventHub.emit(AlbumRefreshConst.EVENT_KEY_APPEAR, []);
    getContext()?.eventHub.off(AlbumRefreshConst.EVENT_KEY_APPEAR);
    let listenerParam: ParamsWrapper =
      this.navPathStack.getParamByName(NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE)[0] as ParamsWrapper;
    if (listenerParam) {
      this.onAlbumClickListener =
        listenerParam.params.get(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_LISTENER) as PageStatusListener;
    }
    if (this.onAlbumClickListener) {
      this.onAlbumClickListener.onAppear();
    }
    // 相册封面
    this.bindSheetWidthAndHeight()
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinsizeChangedCallbackFunc);
    this.registerActions();

    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_EXIST_ALBUM,
      this.onPickerOperationBackToExistAlbumFunc);

    this.enterAlbumTime = Date.now();
  }

  private reportBrowsingInfo(): void {
    const duration : number = Math.floor((Date.now() - this.enterAlbumTime) / 1000);
    if (this.albumInfo) {
      let name = AlbumDefine.getSystemAlbumNameByResource(this.albumInfo);

      let albumSubtype: number = this.albumInfo.subType;
      if (this.albumInfo.lpath === Constants.LPATH_CAMERA) {
        albumSubtype = AlbumBigDataConstants.CAMERA_ALBUM;
      } else if (this.albumInfo.lpath === Constants.LPATH_SCREEN_SHOT) {
        albumSubtype = AlbumBigDataConstants.SCREEN_SHOTS_ALBUM;
      } else if (this.albumInfo.lpath === Constants.LPATH_SCREEN_RECORDING) {
        albumSubtype = AlbumBigDataConstants.SCREEN_RECORDING;
      } else {
        albumSubtype = this.albumInfo.subType;
      }
      const msg: Record<string, number | string | Resource | undefined> = {
        'albumName': name,
        'duration': duration,
        'albumSubtype': albumSubtype,
      };
      if (albumSubtype !== Constants.CITY_QUERY_SUB_TYPE) {
        ReportToBigDataUtil.report(BigDataConstants.ALBUM_BROWSING_DURATION, msg);
      }
    }
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.releaseListeners();
    this.gridController.release();
    this.observerProxy.release();
    this.importDataSource?.releaseBroadCast();
    this.dataSourceManager?.releaseBroadCast();
    this.appBroadCast.off(BroadCastConstants.UPDATE_TITLE, this.albumNameChangeFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinsizeChangedCallbackFunc);
    this.resetStatusBar();
    this.reportBrowsingInfo();
    this.appBroadCast.emit(BroadCastConstants.MAP_MOVING_CHANGE, [true]);

    // 设置相册页数据 active 状态
    getContext()?.eventHub.emit(AlbumRefreshConst.EVENT_KEY_DISAPPEAR, []);
    getContext()?.eventHub.off(AlbumRefreshConst.EVENT_KEY_DISAPPEAR);
    if (this.onAlbumClickListener) {
      this.onAlbumClickListener.onDisappear();
    }

    this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_EXIST_ALBUM,
      this.onPickerOperationBackToExistAlbumFunc);
  }

  /**
   * isPageHidden 的watch函数
   */
  onIsPageHiddenChange() {
    this.gridController.updateDisplayConfig({ isGridShow: !this.isPageHidden });
    LogUtils.info(TAG, `isGridShow: ${!this.isPageHidden}`);
  }

  /**
   * browserController 的watch函数
   */
  onBrowserControllerChanged(): void {
    let isAnimating: boolean = this.browserController.isAnimating;
    this.gridController.updateIsInAnimation(isAnimating);
    LogUtils.debug(TAG, `onBrowserController isAnimating:${isAnimating}
      isBrowserShow:${this.browserController.isBrowserShow}
      isSelectBrowserShow:${this.browserController.isSelectBrowserShow}
      isPullDownAndDrag: ${this.browserController.isPullDownAndDrag}
      isPageHidden: ${this.isPageHidden}`);
    if (this.browserController.isPullDownAndDrag) {
      //开始拖拽，宫格显示
      this.isPageHidden = false;
    } else if (isAnimating) {
      // 开始退出大图或进入大图，显示宫格
      this.isPageHidden = false;
    } else {
      // 进大图动效结束隐藏宫格, 减少冗余渲染
      if (this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) {
        this.isPageHidden = true;
      } else {
        this.isPageHidden = false;
      }
    }
    // 从大图页回到宫格时需要设置状态栏颜色
    if (this.browserController.isStartHide) {
      /* instrument ignore next */
      if (this.observerProxy.getCurrentForm() !== FormIndex.GROUP_DAY) {
        let yOffset: number = this.observerProxy.gridObserverProxy.getScrollOffset();
        let isAlwaysImmersive: boolean = this.observerProxy.albumObserverProxy.config.isAlwaysImmersive;
        this.immersiveController.setStatusColor(yOffset, this.currentMode, this.isShowSideBar, isAlwaysImmersive);
      }
    }
    if (this.browserController.isBrowserShow) {
      // 已进入大图，更新状态栏
      getScreen().setDefaultStatusBarProperties();
    }
  }

  /**
   * isHorizontal 的watch函数
   */
  isHorizontalChange(): void {
    this.gridController.updateDisplayConfig({
      isHorizontal: this.isHorizontal,
      topAvoidHeight: this.getTopAvoidHeight(),
    });
    this.gridController.updateToolbarConfig({
      toolbarPosition: this.isHorizontal ? GridToolBarPosition.RIGHT_TOP : GridToolBarPosition.BOTTOM,
    });
    LogUtils.info(TAG, `isHorizontalChange: ${this.isHorizontal}`);
  }

  onWinsizeChangedCallback(): void {
    this.gridController.updateDisplayConfig({
      areaSize: {
        width: ScreenManager.getInstance().getWinWidth(),
        height: ScreenManager.getInstance().getWinHeight()
      },
    });
  }

  /**
   * statusBarHeight 的watch函数
   */
  onStatusBarHeightChange(): void {
    LogUtils.info(TAG, `onStatusBarHeightChange: ${this.statusBarHeight}`);
    this.gridController.updateDisplayConfig({ topAvoidHeight: this.getTopAvoidHeight() });
  }

  /* instrument ignore next */
  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  /* instrument ignore next */
  onPageShow(): void {
    LogUtils.info(TAG, `onPageShow`)
    this.dataSourceManager?.dayDataSource.resume();
  }

  /***
   * // TODO 监听pick返回，主动刷新------解决添加完图片当前相册页不刷新问题
   */
  private onPickerOperationBackToExistAlbum(): void {
    if (!this.dataSourceManager) {
      return;
    }
    this.dataSourceManager.dayDataSource.notifyDirty();
  }

  /* instrument ignore next */
  onPageHide(): void {
    LogUtils.info(TAG, `onPageHide`)
    this.dataSourceManager?.dayDataSource.pause();
  }

  private resetStatusBar():void {
    getScreen().setDefaultStatusBarProperties();
  }

  private async initAlbumInfo(): Promise<void> {
    let paramAlbumInfo = AppStorage.get<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    LogUtils.info(TAG, `paramAlbumInfo ${(paramAlbumInfo?.item)}`)
    AppStorage.delete(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    if (paramAlbumInfo) {
      this.albumInfo = JSON.parse(paramAlbumInfo.item) as AlbumInfo;
      await AlbumUtils.setViewMode(getContext(), this.albumInfo);
      this.gridController.updateAlbumConfig({
        albumInfo: this.albumInfo,
      });
      this.importDataSource?.setAlbumInfo(this.albumInfo);
      LogUtils.info(TAG, `albumViewMode ${this.albumInfo?.viewMode}`)
      if (this.albumInfo?.viewMode === GridViewMode.GROUP) {
        GridStateProxy.getInstance(this.persistentId).formFsm.changeIsLastFormIsDayGroup(true);
        GridStateProxy.getInstance(this.persistentId)
          .formFsm
          .submitEvent(FormEventTypeUtils.getSwitchEventTypeFromForm(FormIndex.GROUP_DAY));
      }
      this.observerProxy.getFormState((_oldState, newState) => {
        LogUtils.info(TAG, `albumPhotoGrid init getFormState=${newState}`);
        if (FormStateTypeUtils.isInDayState(newState) && this.importDataSource instanceof AlbumDataSource) {
          this.importDataSource?.setViewMode(GridViewMode.GRID);
        }
        if (FormStateTypeUtils.isInGroupDayState(newState)) {
          this.importDataSource?.setViewMode(GridViewMode.GROUP);
        }
      })
    }
    this.appBroadCast.on(BroadCastConstants.UPDATE_TITLE, this.albumNameChangeFunc);
  }

  private releaseListeners(): void {
  }

  private observerGridController(gridController: GridController): void {
    gridController.registerObserver({
      onIsLastFormIsDayGroupChange: (isLastFormIsDayGroup: boolean) => {
        this.gridInitConfigSyncer?.saveIsLastFormIsDayGroup(isLastFormIsDayGroup);
      },
      onGridOperated: () => {
        LogUtils.info(TAG, 'onGridOperated');
        this.browserController.cancelBrowserToGridAnim();
      },
      onSelectedModeChange: (isSelectedMode: boolean) => {
        LogUtils.info(TAG, 'onSelectedModeChange');
        this.isSelectedMode = isSelectedMode;
      }
    });
  }

  private getTopAvoidHeight(): number {
    return this.isHorizontal ? 0 : px2vp(this.statusBarHeight);
  }

  private getIsHorizontal4Vxx(): boolean {
    return !DeviceInfo.isVerdeFoldable() && this.isHorizontal;
  }

  /**
   * 重命名相册，Uri改变，重新请求
   * @param name 新的相册名称
   */
  private async onAlbumNameUpdate(newAlbumName: string, oldAlbumUri: string): Promise<void> {
    LogUtils.info(TAG, `onAlbumNameUpdate, newAlbumName: ${newAlbumName}, oldAlbumUri: ${oldAlbumUri}`);
    if (!newAlbumName) {
      return;
    }
    const album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByName(newAlbumName);
    if (album === undefined) {
      LogUtils.error(TAG, `onAlbumNameUpdate, newAlbum not found`);
      return;
    }
    LogUtils.info(TAG, `onAlbumNameUpdate, new album uri: ${album.albumUri}`);

    // 重命名后 将当前是否显示日期和排序同步到新相册中
    // 记录旧的
    let currentViewMode: GridViewMode = this.albumInfo?.viewMode ?? GridViewMode.GRID;
    let currentSortRule = this.albumInfo?.sortRule;
    let currentAlbumKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo);
    let currentSortRuleString: SortRuleString = AlbumGridSortHelper.getInstance().getSortRule(TAG, currentAlbumKey);
    // 删掉旧的
    await AlbumUtils.saveViewMode(getContext(), this.albumInfo?.subType, this.albumInfo?.lpath, GridViewMode.GRID);
    AlbumGridSortHelper.getInstance().setSortRule(currentAlbumKey, '', SortRuleString.defaultType);
    // 写入新的
    this.albumInfo = new AlbumInfo(album);
    this.albumInfo.viewMode = currentViewMode;
    AlbumUtils.saveViewMode(getContext(), this.albumInfo?.subType, this.albumInfo?.lpath, currentViewMode);
    if (currentSortRule) {
      this.albumInfo.sortRule = currentSortRule;
    }
    AlbumGridSortHelper.getInstance().setSortRule(AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo),
      currentSortRuleString.rule, currentSortRuleString.type);

    // 更新数据源，刷新界面
    this.importDataSource?.setAlbumUri(album.albumUri);
    this.importDataSource?.setAlbumInfo(this.albumInfo);
    GridStateProxy.getInstance(this.persistentId).gridStateManager.updateGirdAnimState(false);
    let timer = setTimeout((): void => {
      GridStateProxy.getInstance(this.persistentId).gridStateManager.updateGirdAnimState(true);
      clearTimeout(timer);
    }, Constants.GRID_LOCK_DURATION);
    this.importDataSource?.notifyDirty();
    this.gridController.updateAlbumConfig({
      albumInfo: this.albumInfo,
    });
  }

  private initAlbumConfig(): void{
    if (this.albumGridConfig?.isSupportSortSelector) {
      this.albumGridConfig.dayViewIrregularBuilder = buildSortSelectorView;
    }
  }

  // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
  private registerActions(): void {
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_LIFECYCLE_REGISTRY, this.lifecycleRegistry)
      .set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.selectManager)
      .set(MenuConstants.KEY_BROADCAST, this.broadcast)
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_PHOTO);
    ActionUtils.register(params);
  }

  build() {
    if (this.isReady) {
      PhotoGridView({
        persistentId: this.persistentId,
        dataSourceManager: this.dataSourceManager,
        gridConfig: {
          isSupportStaggerLoading: false,
          isSupportGroupDay: false,
          isSupportLocationTitle: false,
          isSupportPreload: false,
          isSupportHeadMsg: false,
          isSupportOtherIrregular: true,
          isSupportDefaultSelect: false,
          isLastFormIsDayGroup: false,
          isAutoAdjustColumns: true,
          isSupportMinimal: !DeviceInfo.isFoldDevice(),
          scrollbarEnableCounts: this.albumInfo?.isGroupAlbum ? Constants.GROUP_PHOTOS_CNT_FOR_HIDE_SCROLL_BAR :
            Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR,
        },
        switchConfig: {
          isSupportSwitch: false,
          switchMode: SwitchMode.NORMAL,
          isOpenGroupDayGuide: !(this.gridInitConfigSyncer?.groupDayGuideHasDisplayed ?? true),
          switchHidToBottom: true,
          isSupportSwitchAnimate: false,
        },
        pinchConfig: {
          isSupportPinch: false,
        },
        titleBarConfig: {
          titleBarHeight: (!DeviceInfo.isPhone() || this.isHorizontal || DeviceInfo.isVerdeFoldable()) ?
            Constants.ActionBarHeight : Constants.ActionBarHeight + DEFAULT_TOP_AVOID_HEIGHT,
        },
        selectConfig: {
          isSupportSelect: true,
          selectManager: this.initSelectManager,
        },
        displayConfig: {
          areaSize: {
            width: ScreenManager.getInstance().getWinWidth(),
            height: ScreenManager.getInstance().getWinHeight()
          },
          isGridShow: !this.isPageHidden,
          isHorizontal: this.isHorizontal,
          bottomAvoidHeight: 0,
          topAvoidHeight: this.getTopAvoidHeight(),
        },
        albumConfig: this.albumGridConfig,
        navPathStack: this.navPathStack,
        gridAppBarManager: this.gridAppBarManager,
        broadcast: this.broadcast,
        viewModel: this.viewModel,
        albumInfo: this.albumInfo,
        irregularViewBuilder: this.irregularViewBuilder,
        dayViewBuilder: this.customBuilderLoaderParam?.dayViewBuilder ?? undefined,
      })
        .opacity(this.photoGridViewOpacity)
        .transition(
          (DeviceInfo.isTablet()) ?
            TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({
                duration: 200,
                curve: Curve.Sharp,
              })
              ,
              TransitionEffect.OPACITY.animation({
                duration: 200,
                curve: Curve.Sharp,
              })
            ) : TransitionEffect.OPACITY.animation({ duration: 300, curve: 'standard' }))
        .bindSheet(this.bindSheetController.isShow, this.buildHighlightBindSheet(), {
          showClose: false,
          preferType: SheetType.CENTER,
          height: this.bindSheetHeight,
          width: this.bindSheetWidth,
          backgroundColor: Color.Transparent,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
          onWillAppear: async () => {
            LogUtils.info(TAG, `BindSheet onWillAppear. ${this.bindSheetHeight}, ${this.bindSheetWidth}`);
            // 键盘避让
            this.getUIContext().setKeyboardAvoidMode(4);
          },
          onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
            if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
              LogUtils.info(TAG, 'DismissReason.');
            }
            dismissSheetAction.dismiss();
          }),
          onAppear: () => {
            LogUtils.info(TAG, 'BindSheet onAppear.');
          },
          onDisappear: () => {
            this.navPathStackBindSheet.clear();
            this.bindSheetController.isShow = false;
          }
        })
        .onAreaChange((oldValue: Area, newValue: Area): void => {
          this.bindSheetWidthAndHeight()
        })
    }
  }

  @State private itemHeight: number = Constants.ALBUM_COVER_PREVIEW_ITEM_HEIGHT;

  @Builder
  buildHighlightBindSheet() {
    Navigation(this.navPathStackBindSheet) {
      AlbumCoverSelectPage({
        navPathStackBindSheet: this.navPathStackBindSheet,
        selectCoverItem: this.selectCoverItem,
        albumInfo: this.albumInfo,
        bindSheetController : this.bindSheetController,
      });
    }
    .hideTitleBar(true)
    .navDestination(this.routerControl)
  }

  @Builder
  routerControl(name: string) {
    if (name === 'AlbumCoverPreviewPage') {
      AlbumCoverPreviewPage({
        navPathStackBindSheet: this.navPathStackBindSheet,
        selectCoverItem: this.selectCoverItem,
        bindSheetController: this.bindSheetController,
        albumInfo: this.albumInfo,
        itemHeight:this.itemHeight,
        itemWidth:this.itemHeight,
      });
    } else if (name === 'AlbumCoverSelectPage') {
      AlbumCoverSelectPage({
        navPathStackBindSheet: this.navPathStackBindSheet,
        selectCoverItem: this.selectCoverItem,
        dataSource:this.importDataSource,
        albumInfo: this.albumInfo,
        bindSheetController: this.bindSheetController,
      });
    }
  }

  public changeBackgroundStatus(changedPropertyName: string): void {
    if (this.isBackGround) {
      this.reportBrowsingInfo();
    } else {
      this.enterAlbumTime = Date.now();
    }
  }
}
