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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PhotoGridView } from '../photogrid/view/PhotoGridView';
import lazy { GridStateProxy } from '../photogrid/statemanager/GridStateProxy';
import lazy { GridController } from '../photogrid/viewmodel/GridController';
import lazy { Constants, CoursesParams } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AppStorageKeys } from '@ohos/common/src/main/ets/default/utils/AppStorageKeys';
import lazy { PinchAction } from '../photogrid/statemanager/constants/PinchDefine';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { GridStateObserverProxy } from '../photogrid/statemanager/GridStateObserverProxy';
import lazy { FormIndex, PullDownState } from '../photogrid/statemanager/constants/GridDefine';
import lazy { FocusUtil } from '@ohos/common/src/main/ets/default/utils/FocusUtil';
import lazy { getScreen, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { GridInitConfigSyncer } from './adapter/GridInitConfigSyncer';
import lazy { FileAssetEx, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { TimeLineModelManager } from '@ohos/common/src/main/ets/default/view/TimeLineModelManager';
import lazy { FoldData, FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { SwitchMode, SwitchShowUpdateReason } from '../photogrid/statemanager/constants/SwitchDefine';
import lazy { SelectListener, SelectManager,
  TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { TimelineDataSourceManager } from '../model/TimelineDataSourceManager';
import lazy { GridAppBarManager } from '../photogrid/view/GridAppBar';
import lazy subscribeEvent, {
  CommonEventManagerAccess,
} from '@ohos/common/src/main/ets/default/access/CommonEventManagerAccess';
import lazy eventMgr from '@ohos.commonEventManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ComponentLifecycleRegistry } from '@ohos/common/src/main/ets/default/view/ComponentLifecycle';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import lazy { WifiStatusUpdater } from './WifiStatusUpdater';
import lazy { IStateChangeObserver } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy wifiManager from '@ohos.wifiManager';
import lazy display from '@ohos.display';
import lazy { TimelineDataSourceProxy } from '../model/TimelineDataSourceProxy';
import lazy { DataSourceManager } from '../photogrid/model/DataSourceManager';
import lazy { GridToolBarPosition } from '../photogrid/statemanager/constants/ToolBarDefine';
import lazy { TabBarUtils } from '@ohos/common/src/main/ets/default/utils/TabBarUtils';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { AlbumLoadingTaskResult } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';
import {
  CameraAuthLocationFromEnum,
  CameraAuthLocationManager } from '@ohos/common/src/main/ets/default/viewmodel/CameraAuthLocationManager';
import lazy { ColdStartState } from '@ohos/common/src/main/ets/default/model/ColdStartState';
import lazy { PreloadStateTypeUtils } from '../photogrid/statemanager/GridPreloadFsm';
import lazy { LengthMetrics } from '@kit.ArkUI'
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';


const TAG: string = 'TimelineView';
const TITLE_BAR_HEIGHT: number = 60;
const COURSE_NAV_DELAY: number = 500;

@Component
export struct TimelineView {
  // 从父组件直接继承的参数开始
  @Prop @Watch('onCurrentTabsChange') isInCurrentTab: boolean = true;
  @Link @Watch('onPhotoBrowserShow') isShowPhotoBrowser: boolean;
  @Consume @Watch('onBrowserControllerChanged') browserController: PhotosHmBrowserController;
  @Link @Watch('onTabBarHeightChange') currentTabBarHeight: number;
  @Link isSelectedModeIndex: boolean;
  @Link tabsPaddingBottom: number;
  @Link initTabsPaddingBottom: number;
  @Prop @Watch('onPageShow') private pageStatus: boolean = false;
  @Link isShowSearchPage: boolean;
  @Prop @Watch('onShowGallerySettingBasePage') private isShowGallerySettingBasePage: boolean;
  @Prop @Watch('onShowAboutGalleryPage') private isShowAboutGalleryPage: boolean;
  @Link @Watch('isShowSegmentButton') isShowTabAndSegmentButton: boolean;
  @Link @Watch('updateGroupLayoutOptionsNormal') isShowSdCardTip: boolean;
  @Link @Watch('updateGroupLayoutOptionsNormal') cardNameUris: string[];
  // 监听是否点击TAB切换视图操作
  @Prop isChangeByClickTab: boolean = false;
  // 宫格初始配置同步器
  public gridInitConfigSyncer?: GridInitConfigSyncer;
  @Consume('navigationPageInfos') @Watch('navigationPageInfosChanged') navigationPageInfos: NavPathStack;
  @Consume('isShowSideBar') @Watch('isShowSideBarChanged') isSidebar: boolean;
  @State @Watch('onIndexPageShow') isShow: boolean = true;
  // 从父组件直接继承的参数结束

  // 其他全局参数
  @StorageLink('isHorizontal') @Watch('isHorizontalChange') private isHorizontal: boolean =
    AppStorage.get<boolean>('isHorizontal') ?? false;
  @StorageLink('getFoldStatus') @Watch('onFoldChanged') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldChanged') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  // 状态栏高度
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') private statusBarHeight: number =
    AppStorage.get('statusBarHeight') ?? 0;

  @Link public isShowTabBar: boolean;
  @State public broadcast: BroadCast = TimelineDataSourceManager.getInstance().getBroadCast();
  public navPathStack: NavPathStack = new NavPathStack();
  public gridAppBarManager: GridAppBarManager = new GridAppBarManager();

  private isOpenYearMonth: boolean =
    AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine() ?? false;

  private currentIndex: number = Constants.TIMELINE_PAGE_INDEX;
  // 从父组件接收的参数结束

  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink(AppStorageKeys.UNLIMITED_USE_OF_MOBILE_NETWORK) @Watch('onNetWorkChanged') isToggleOn: boolean = false;

  // 状态栏颜色
  @State @Watch('changeStatusColor') currentStatusColor: string = Constants.STATUS_BAR_CONTENT_COLOR;

  @State private isAnimating: boolean = false;
  @State @Watch('onIsPageHiddenChange') private isPageHidden: boolean = false;
  @State private timeController: TimeController = new TimeController();
  @State private immersiveController: ImmersiveController = new ImmersiveController(this.currentMode,
    this.getIsHorizontal4Vxx(), false, 20, this.timeController);

  // 其他全局状态
  @State @Watch('adjustGridRowCount') contentWidthLatest: number = 0; // 最新窗口宽度
  private isShowSideBar: boolean = DeviceInfo.isPhoneUx() ? false : ActionBarVar.isShowSideBar;

  // 实例ID
  private persistentId: number = 0;

  private readonly gridController: GridController = new GridController();

  private readonly observerProxy: GridStateObserverProxy = new GridStateObserverProxy();

  private isActive = false; // Is the page active
  private isAboutToDisappear = false;
  private timeChangeSubscriber: eventMgr.CommonEventSubscriber | undefined;
  private curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = foldData => {
    if (this.curFoldStatus !== foldData.curFoldStatus) {
      this.curFoldStatus = foldData.curFoldStatus;
      this.updateSwitchShowMode();
    }
  };
  private readonly selectListener: SelectListener = {
    onModeChanged: (): void => this.onSelectModeChanged(),
  }
  private readonly pageShowFunc: () => void = () => this.isShow = true;
  private readonly pageHideFunc: () => void = () => this.isShow = false;
  private readonly wifiStatusObserver: IStateChangeObserver<boolean> = {
    onStateChange: (oldState: boolean, newState: boolean, event?: string | undefined): void => {
      this.onNetWorkChanged();
    }
  };
  private wifiStatusUpdater: WifiStatusUpdater | undefined;

  // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
  private readonly lifecycleRegistry: ComponentLifecycleRegistry = new ComponentLifecycleRegistry();
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private naviDestMediaOperBackFun: Function = (pageType: string, mediaOperationAlbumName: string,
    mediaOperationAlbumUri: string, navigationPageFunc?: Function): void => {
    this.onMediaOperationBack(pageType, mediaOperationAlbumName, mediaOperationAlbumUri, navigationPageFunc);
  };
  @Provide appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private readonly menuHelper: MenuHelper = new MenuHelper();
  public selectManager: TimelineSelectManager = new TimelineSelectManager();
  // 菜单处理

  private readonly onWinsizeChangedCallbackFunc: Function = (): void => this.onWinsizeChangedCallback();
  private onTabChangedFunc: Function = (index: number): void => this.onTabChanged(index);

  private dataSourceManager: DataSourceManager | undefined = new DataSourceManager(this.persistentId,
    TimelineDataSourceManager.getInstance().getDataSource(), new TimelineDataSourceProxy());
  // 是否需要横屏后隐藏年月日和TAB，false表示横竖屏切换时不用隐藏
  private whetherToHide: boolean = false;
  @Prop isConfigReady: boolean = false;
  private onHidDeleteDialogFunc: Function = (): void => this.onHidDeleteDialog();
  private timeId: number | undefined;

aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.persistentId = GridStateProxy.getNewProxyId();
    Log.info(TAG, `abouttoappear create persistentId: ${this.persistentId}`);
    this.observerProxy.init(this.persistentId);
    this.gridController.init(this.persistentId);
    this.gridController.initSubComponentState(this.timeController, this.immersiveController);
    this.observerGridController(this.gridController);
    this.initScrollProcess();
    this.initListeners();
    this.isAboutToDisappear = false;
    // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      this.naviDestMediaOperBackFun);
    this.appBroadCast?.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast?.on(BroadCastConstants.HIDE_DELETE_DIALOG, this.onHidDeleteDialogFunc);
    this.registerActions();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinsizeChangedCallbackFunc);
    // 初始化时设置返回桌面生效
    this.gridController.updateActionState(true);
    this.isActive = true;
    this.gridController.updateGridActiveState(true);

    // 监听照片数量变化
    this.dataSourceManager?.registerObserver({
      onDataUpdate: (count: number): void => {
        LogUtils.info(TAG, `onDataUpdate:${count}`);
        // 有照片时实时更新提醒气泡状态
        this.updateDayGuideState();
      }
    });
    // 从日历课程表跳转过来后找到对应的课件；
    this.photoViewJumpToTimelineView();
  }

  private async photoViewJumpToTimelineView(): Promise<void> {
    Log.info(TAG, `photoViewJumpToTimelineView start`);
    let courses: CoursesParams = tryGetRouterParam() as CoursesParams;
    if (!courses || courses.pageFrom !== Constants.ENTRY_FROM.PHOTO_VIEW) {
      Log.info(TAG, `photoViewJumpToTimelineView page not from photo view`);
      return;
    };
    interface CalenderClassReportInfo {
      title: string;
      startTime: number;
      endTime: number;
    }
    let msg: CalenderClassReportInfo = {
      title: courses.subjectTitle,
      startTime: courses.subjectStartTime,
      endTime: courses.subjectStopTime,
    }
    ReportToBigDataUtil.report(BigDataConstants.CALENDER_CLASS_INFO, msg);
    getScreen().recoverDefaultStatusBar();
    // AppStorage 传递 courses信息
    AppStorage.setOrCreate<number>(AppStorageKeys.CALENDER_NAVIGATION_TIME,
      systemDateTime.getUptime(systemDateTime.TimeType.STARTUP));
    AppStorage.setOrCreate<CoursesParams>(AppStorageKeys.CALENDER_NAVIGATION_INFO, courses);
    AppStorage.setOrCreate<boolean>(AppStorageKeys.CALENDER_LOCK_CLOUD_CARD_ONCE, true);
    Log.info(TAG, `photoViewJumpToTimelineView subjectStopTime: ${courses.subjectStopTime}`);
    let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance()
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates
      .orderByDesc('date_taken_ms')
      .lessThanOrEqualTo('date_taken_ms', courses.subjectStopTime);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [
        photoAccessHelper.PhotoKeys.URI.toString(),
        photoAccessHelper.PhotoKeys.DATE_TAKEN_MS,
        photoAccessHelper.PhotoKeys.TITLE,
      ],
    };
    let firstCover: FileAssetEx = await userFileManagerAccess.getFirstObject(fetchOptions, TAG);
    if (firstCover && firstCover.obj) {
      Log.info(TAG, `photoViewJumpToTimelineView uri: ${firstCover.obj.uri}`);
      Log.info(TAG, `photoViewJumpToTimelineView uri: ${firstCover.obj.uri}`);
      let initIndex = await userFileManagerAccess.getPhotoIndexByUri(firstCover.obj.uri, '', undefined,
        UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString(), false, false);
      Log.info(TAG, `photoViewJumpToTimelineView index: ${initIndex}`);
      this.timeId = setTimeout(() => {
        let layoutIndex = this.dataSourceManager?.groupDayDataSource.dataToLayout(initIndex) ?? initIndex + 1;
        Log.info(TAG, `photoViewJumpToTimelineView layoutIndex: ${layoutIndex}`)
        this.gridController.updateInitIndex(FormIndex.GROUP_DAY, layoutIndex + 1);
        clearTimeout(this.timeId);
      }, COURSE_NAV_DELAY)
    }
  }

  private dataToLayoutIndex(index: number): number {
    const groups: TimelineData[] = this.observerProxy.getGroups();
    const gridColumn = this.observerProxy.gridObserverProxy.getGridColumn(FormIndex.GROUP_DAY);
    Log.info(TAG, `photoViewJumpToTimelineView gridColumn: ${gridColumn}`)
    const groupIndex = this.dataSourceManager?.groupDayDataSource.timeGroupIndexes(index) ?? -1;
    Log.info(TAG, `photoViewJumpToTimelineView groupIndex: ${groupIndex}`)
    let layoutIndex: number = 1;
    if (groupIndex < 0) {
      return index;
    }
    let count = index + 1;
    for (let i: number = 0; i <= groupIndex; i++) {
      if (i === groupIndex) {
        layoutIndex += (Math.ceil(count / gridColumn) - 1) * gridColumn;
      } else {
        layoutIndex += Math.ceil(groups[i].count / gridColumn) * gridColumn;
        count -= groups[i].count;
      }
    }
    return layoutIndex + groupIndex + 1;
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.isAboutToDisappear = true;
    this.releaseListeners();
    this.gridController.release();
    this.observerProxy.release();
    this.navigationBroadCast.off(
      NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK, this.naviDestMediaOperBackFun);
    this.appBroadCast?.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast?.off(BroadCastConstants.HIDE_DELETE_DIALOG, this.onHidDeleteDialogFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinsizeChangedCallbackFunc);
    if (this.timeId) {
      clearTimeout(this.timeId)
    }
  }

  private onSelectModeChanged(): void {
    let selectManager: SelectManager = GridStateProxy.getInstance(this.persistentId).selectManager;
    Log.info(TAG, `onSelectStateChanged ${selectManager.mIsSelectedMode}`);
    TabBarUtils.printLog(TAG, 'onModeChange', this.isShowTabBar, !selectManager.mIsSelectedMode);
    this.isShowTabBar = !selectManager.mIsSelectedMode;
    this.appBroadCast?.emit(BroadCastConstants.SELECT, [selectManager.mIsSelectedMode]);
    // 选择模式时不显示气泡，退出选择模式后更新气泡状态
    this.updateDayGuideState();
  }

  /**
   * isInCurrentTab 的watch函数
   */
  onCurrentTabsChange(): void {
    Log.info(TAG, `onCurrentTabsChange:${this.isInCurrentTab}, currentMode:${this.currentMode}` +
      `, textFontColor:${this.immersiveController.textFontColor}`);
    this.gridController.updateDataSourceActiveStatus(this.isShow && this.isInCurrentTab);
    if (this.isInCurrentTab) {
      if (!this.browserController.isBrowserShow) {
        // 相册或时刻切换到照片页，且大图组件不存在时触发未生成缩略图资源的批量加载
        this.startReadyProcess();
      }
      WindowUtil.updateWindowSystemBarProperties(this.immersiveController.textFontColor);
      return;
    } else {
      this.stopReadyProcess();
    }
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      WindowUtil.updateWindowSystemBarProperties(Constants.STATUS_BAR_CONTENT_COLOR);
    } else {
      WindowUtil.updateWindowSystemBarProperties(Constants.RULER_FILL_STYLE_100);
    }
  }

  /**
   * isShowPhotoBrowser 的watch函数
   */
  onPhotoBrowserShow(): void {
    if (!this.isInCurrentTab) {
      return;
    }
    // 显示大图时不显示气泡，大图返回宫格时显示气泡, 大图返回相册宫格时会误触发提醒显示
    Log.info(TAG, `onPhotoBrowserShow isShowPhotoBrowser:${this.isShowPhotoBrowser}, isShow:${this.isShow}` +
      `, isInCurrentTab:${this.isInCurrentTab}, currentMode:${this.currentMode}`);
    if (this.isShowPhotoBrowser) {
      this.gridController.updateDayGuideShowState(false);
    }
    this.updateDayGuideState();
    this.updateGridVisibleState();
    // 大图返回宫格时更新权限状态
    this.gridController.updateCameraAuthorizeState(true);
    if (this.isShowPhotoBrowser || this.observerProxy.getCurrentForm() === FormIndex.GROUP_DAY) {
      if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
        setTimeout(() => {
          WindowUtil.updateWindowSystemBarProperties(Constants.STATUS_BAR_CONTENT_COLOR);
        })
      } else {
        WindowUtil.updateWindowSystemBarProperties(Constants.RULER_FILL_STYLE_100);
      }
      return;
    }
    WindowUtil.updateWindowSystemBarProperties(this.immersiveController.textFontColor);
  }

  /**
   * browserController 的watch函数
   */
  onBrowserControllerChanged(): void {
    if (!this.isInCurrentTab) {
      return;
    }
    this.isAnimating = this.browserController.isAnimating;
    this.gridController.updateIsInAnimation(this.isAnimating);
    Log.debug(TAG, `onBrowserController isAnimating:${this.isAnimating}
      isBrowserShow:${this.browserController.isBrowserShow}
      isSelectBrowserShow:${this.browserController.isSelectBrowserShow}
      isPullDownAndDrag: ${this.browserController.isPullDownAndDrag}
      isPageHidden: ${this.isPageHidden}`);
    if (this.browserController.isPullDownAndDrag) {
      //开始拖拽，宫格显示
      this.isPageHidden = false;
    } else if (this.isAnimating) {
      // 开始退出大图或进入大图，显示宫格
      this.isPageHidden = false;
    } else {
      // 进大图动效结束隐藏宫格, 减少冗余渲染
      if (this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) {
        if (this.isPageHidden) {
          // 退出大图触发缩略图批量生成
          this.startReadyProcess();
        } else {
          // 进入大图停止缩略图批量生成
          this.stopReadyProcess();
        }
        this.isPageHidden = true;
      } else {
        this.isPageHidden = false;
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          FocusUtil.activateFocus(this.getUIContext()?.getFocusController());
        }
        Log.debug(TAG, `animation finished, this.isPageHidden: ${this.isPageHidden}`);
      }
    }
    // 从大图页回到宫格时需要设置状态栏颜色
    if (this.browserController.isStartHide) {
      /* instrument ignore next */
      if (this.observerProxy.getCurrentForm() !== FormIndex.GROUP_DAY) {
        let yOffset: number = this.observerProxy.gridObserverProxy.getScrollOffset();
        this.immersiveController.setStatusColor(yOffset, this.currentMode, this.isShowSideBar);
      }
    }
    if (this.browserController.isBrowserShow) {
      // 已进入大图，更新状态栏
      getScreen().setDefaultStatusBarProperties();
    }
  }

  onTabBarHeightChange(): void {
    Log.info(TAG, `onTabBarHeightChange: ${this.currentTabBarHeight}`);
    this.gridController.updateDisplayConfig({ bottomAvoidHeight: this.currentTabBarHeight });
  }

  /**
   * pageStatus 的watch函数
   */
  onPageShow() {
    // TODO 数据源相关，待处理
  }

  /**
   * isShow 的watch函数
   */
  onIndexPageShow(): void {
    LogUtils.info(TAG, `[onIndexPageShow] isShow=${this.isShow}, isInCurrentTab=${this.isInCurrentTab} ${this.isShowPhotoBrowser}`);
    this.showTimelinePage(this.isShow);
    // 图库主界面回前台/退后台
    this.gridController.updateDataSourceActiveStatus(this.isShow && this.isInCurrentTab);
    this.updateDayGuideState();
    this.updateGridVisibleState();
    if (this.isShow && this.isInCurrentTab) {
      if (!this.browserController.isBrowserShow) {
        // 宫格页面处于前台，且大图组件不存在时触发未生成缩略图资源的批量加载
        this.startReadyProcess();
      }
      // 宫格从后台回到前台时更新权限状态
      this.gridController.updateCameraAuthorizeState(true);
      this.isActive = true;
      this.gridController.updateGridActiveState(true);
      // 照片页在前台时设置返回桌面生效
      this.gridController.updateActionState(true);
      // 图库从后台切换到前台时需要重新获取相机权限开关状态，防止图库在后台时手动修改权限状态
      this.getCameraAuthCardShowState();
    } else if (!this.isShow && this.isInCurrentTab) {
      this.stopReadyProcess();
      this.isActive = false;
      this.gridController.updateGridActiveState(false);
    }
  }

  private async getCameraAuthCardShowState(): Promise<void> {
    let cameraAuthCardShow: boolean = await CameraAuthLocationManager.getIsShowCameraAuthLocationCard(getContext(this),
      CameraAuthLocationFromEnum.TimeLine);
    let totalCount: number = this.dataSourceManager?.dayDataSource?.totalCount() ?? 0;
    if (totalCount <= 10) {
      cameraAuthCardShow = false;
    }
    Log.info(TAG, `getCameraAuthCardShowState:${cameraAuthCardShow} ${totalCount}`);
    this.gridController.updateCameraCardShowState(cameraAuthCardShow);
  }

  /**
   * isShowGallerySettingBasePage 的watch函数
   */
  onShowGallerySettingBasePage(): void {
    Log.info(TAG, `onShowGallerySettingBasePage,isShowGallerySettingBasePage:${this.isShowGallerySettingBasePage}`)
    this.showTimelinePage(!this.isShowGallerySettingBasePage)
  }

  /**
   * isShowAboutGalleryPage 的watch函数
   */
  onShowAboutGalleryPage(): void {
    Log.info(TAG, `onShowGallerySettingBasePage,isShowGallerySettingBasePage:${this.isShowAboutGalleryPage}`)
    this.showTimelinePage(!this.isShowAboutGalleryPage)
  }

  /**
   * isShowTabAndSegmentButton 的watch函数，年月日胶囊显示或隐藏动效
   */
  isShowSegmentButton(): void {
    // 更新显示模式
    this.updateSwitchShowMode();

    Log.info(TAG, `isShowSegmentButton:${this.whetherToHide} ${this.isShowTabAndSegmentButton}`);
    if (this.whetherToHide) {
      this.gridController.updateSwitchConfig({ switchHidToBottom: !this.isShowTabAndSegmentButton });
    }
  }

  /**
   * isShowSdCardTip和cardNameUris 的watch函数，更新日期分组视图IrregularIndex
   */
  updateGroupLayoutOptionsNormal(): void {
    // TODO 待补充
  }

  /**
   * isSidebar 的watch函数
   */
  isShowSideBarChanged(): void {
    let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
    let winWidth = getScreen().getWinWidth();
    let contentWidth = winWidth - sideBarWidth;
    this.contentWidthLatest = contentWidth;
    // 侧边栏展开收起时需要重新计算年月视图每个ListItem的高度, 保证跟随滚动条滚动的时间胶囊计算正确
    // TODO 影响待补充
  }

  /**
   * currentMode 的watch函数
   */
  onColorModeChange(): void {
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.currentStatusColor = Constants.STATUS_BAR_CONTENT_COLOR;
    } else {
      this.currentStatusColor = Constants.RULER_FILL_STYLE_100;
    }
    this.updateImmersiveStatusBar();
    let currentStatusColor: string = this.updateStatusColorByImmersive();
    Log.info(TAG, `onColorModeChange:${this.currentMode}, isInImmersive:${this.immersiveController?.isInImmersive}` +
      `,currentStatusColor:${this.currentStatusColor} ${currentStatusColor} ${this.currentIndex}`);
    this.immersiveController.onColorModeChange(this.currentMode, currentStatusColor);
  }

  /**
   * currentStatusColor 的watch函数
   */
  changeStatusColor() {
    // 当前是照片页时根据当前是否处于沉浸态更新系统标题栏颜色，防止颜色值变化和当前视图不符
    let currentStatusColor: string = this.updateStatusColorByImmersive();
    Log.info(TAG, `changeStatusColor:${this.currentStatusColor}, currentStatusColor:${currentStatusColor}` +
      `, isInImmersive:${this.immersiveController?.isInImmersive}, currentIndex:${this.currentIndex}`);
    WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
  }

  /**
   * isPageHidden 的watch函数
   */
  onIsPageHiddenChange() {
    this.gridController.updateDisplayConfig({ isGridShow: !this.isPageHidden });
    Log.info(TAG, `isGridShow: ${!this.isPageHidden}`);
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
    Log.info(TAG, `isHorizontalChange: ${this.isHorizontal}`);
    this.updateSwitchShowMode();
    this.updateIsStatusBarInLayout();
  }

  onWinsizeChangedCallback(): void {
    Log.info(TAG, `onWinsizeChangedCallback`);
    this.gridController.updateDisplayConfig({
      areaSize: {
        width: ScreenManager.getInstance().getWinWidth(),
        height: ScreenManager.getInstance().getWinHeight()
      },
    });
  }

  /**
   * isFoldExpanded 的watch函数
   */
  onFoldChanged(): void {
    Log.info(TAG, `onFoldChanged: ${this.isFoldExpanded}`);
    this.updateSwitchShowMode();
    this.updateIsSupportTabbarAnimation();
    this.updateIsStatusBarInLayout();
  }

  /**
   * statusBarHeight 的watch函数
   */
  onStatusBarHeightChange(): void {
    Log.info(TAG, `onStatusBarHeightChange: ${this.statusBarHeight}`);
    this.gridController.updateDisplayConfig({ topAvoidHeight: this.getTopAvoidHeight() });
  }

  /**
   * contentWidthLatest 的watch函数
   */
  adjustGridRowCount(): void {
    // TODO 待补充
  }

  private updateSwitchShowMode(): void {
    this.gridController.updateSwitchConfig({ switchMode: this.getSwitchMode() });
  }

  private getSwitchMode(): SwitchMode {
    if (DeviceInfo.isVerdeFoldable()) {
      return SwitchMode.HIDE;
    }
    let swichMode: SwitchMode;
    if (this.whetherToHide && DeviceInfo.isPhoneUx() && this.getIsHorizontal4Vxx() &&
      !(DeviceInfo.isFoldable() || DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))) {
      swichMode = SwitchMode.ONLY_BOTTOM_SHOW;
    } else {
      swichMode = SwitchMode.NORMAL;
    }
    return swichMode;
  }

  private getIsHorizontal4Vxx(): boolean {
    return !DeviceInfo.isVerdeFoldable() && this.isHorizontal;
  }

  private showTimelinePage(isShowTimelinePage?: boolean): void {
    Log.info(TAG, `showTimelinePage currentMode:${this.currentMode} ${isShowTimelinePage} ${this.isShowPhotoBrowser} ` +
      `${this.isShowGallerySettingBasePage} ${this.isShowAboutGalleryPage}, isInCurrentTab:${this.isInCurrentTab}` +
      `, isInImmersive:${this.immersiveController?.isInImmersive}`);
    if (this.isShowPhotoBrowser || this.isShowGallerySettingBasePage || this.isShowAboutGalleryPage) {
      setTimeout((): void => {
        // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态
        let currentStatusColor: string = Constants.RULER_FILL_STYLE_100;
        if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT &&
          !this.immersiveController?.isInImmersive) {
          currentStatusColor = Constants.STATUS_BAR_CONTENT_COLOR;
        }
        WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
      })
      return;
    }
    if (isShowTimelinePage && this.isInCurrentTab) {
      WindowUtil.updateWindowSystemBarProperties(this.immersiveController.textFontColor);
      return;
    }
    // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT &&
      !this.immersiveController?.isInImmersive && this.isInCurrentTab) {
      WindowUtil.updateWindowSystemBarProperties(Constants.STATUS_BAR_CONTENT_COLOR);
      return;
    }
    if (this.isInCurrentTab) {
      WindowUtil.updateWindowSystemBarProperties(Constants.RULER_FILL_STYLE_100);
    }
  }

  /**
   * 根据当前视图是否在沉浸态更新标题栏颜色
   * @returns 标题栏颜色
   */
  private updateStatusColorByImmersive(): string {
    let currentStatusColor: string = this.currentStatusColor;
    if (this.currentIndex === Constants.TIMELINE_PAGE_INDEX) {
      // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态
      if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT &&
        !this.immersiveController?.isInImmersive) {
        currentStatusColor = Constants.STATUS_BAR_CONTENT_COLOR;
      } else {
        currentStatusColor = Constants.RULER_FILL_STYLE_100;
      }
    }
    return currentStatusColor;
  }

  private updateImmersiveStatusBar(): void {
    // 分组视图下不需要更新状态栏沉浸式状态
    if (this.isActive && this.observerProxy.getCurrentForm() !== FormIndex.GROUP_DAY) {
      let yOffset: number = this.observerProxy.gridObserverProxy.getScrollOffset();
      this.immersiveController.setStatusColor(yOffset, this.currentMode, this.isShowSideBar);
      this.immersiveController.enterOrQuiteImmersive(yOffset, this.currentMode, this.getIsHorizontal4Vxx(),
        this.observerProxy.scrollerObserverProxy.getIsScrollerTouched(),
        this.observerProxy.getCurrentForm() as number, Constants.ANIMATE_TIME, this.isShowSideBar);
    }
    Log.info(TAG, `updateImmersiveStatusBar:${this.isActive}` +
      `, isInImmersive: ${this.immersiveController?.isInImmersive}` +
      `, currentStatusColor: ${FormIndex[this.observerProxy.getCurrentForm()]}`);
  }

  private observerGridController(gridController: GridController): void {
    gridController.registerObserver({
      onIsLastFormIsDayGroupChange: (isLastFormIsDayGroup: boolean) => {
        this.gridInitConfigSyncer?.saveIsLastFormIsDayGroup(isLastFormIsDayGroup);
      },
      onGroupDayGuideOpenChange: (isGroupDayGuideOpen: boolean) => {
        this.gridInitConfigSyncer?.saveGroupDayGuideHasDisplayed(!isGroupDayGuideOpen);
      },
      onPinchStateChange: (pinchState: PinchAction) => {
        switch (pinchState) {
          case PinchAction.START:
            // 捏合场景禁用ready缩略图生成逻辑
            this.stopReadyProcess();
            break;
          case PinchAction.END:
            // 捏合结束，放开ready缩略图生成
            this.startReadyProcess();
            break;
        }
      },
      onSwitchHidToBottomChange: (isHidToBottom: boolean, reason?: string) => {
        if (reason !== SwitchShowUpdateReason.OUTER_REASON) {
          // 将内部状态同步到外部
          this.isShowTabAndSegmentButton = !isHidToBottom;
        }
      },
      onGridOperated: () => {
        LogUtils.info(TAG, 'onGridOperated');
        this.browserController.cancelBrowserToGridAnim();
      }
    });
  }

  private initScrollProcess(): void {
    // 年月日分组视图在滑动的时候需要停止云同步，滑动结束500ms后打开云同步，为了避免滑动过程中出现云同步导致触发onDataReload的滑动卡顿问题
    for (let index: FormIndex = FormIndex.YEAR; index <= FormIndex.GROUP_DAY; index++) {
      this.observerProxy.scrollerObserverProxy.getIsScrolling(index, (oldState, newState) => {
        LogUtils.info(TAG, `scroll state change newState:${newState} oldState:${oldState}`);
        if (this.observerProxy.gridObserverProxy.getHeadMsgPullDownState() !== PullDownState.NONE) {
          return;
        }
        if (newState) {

        } else {

        }
      })
    }
  }
  
  private initListeners(): void {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    GridStateProxy.getInstance(this.persistentId).selectManager.addListener(this.selectListener);
    this.initTimeChangeListener();
    this.getUIContext()?.getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_SHOW, this.pageShowFunc);
    this.getUIContext()?.getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_HIDE, this.pageHideFunc);
    this.initNetworkStatus();
  }

  private async initNetworkStatus(): Promise<void> {
    this.wifiStatusUpdater = new WifiStatusUpdater(this.persistentId, wifiManager.isWifiActive());
    this.wifiStatusUpdater.init();
    this.wifiStatusUpdater.registerObserver(this.wifiStatusObserver);
  }

  private onNetWorkChanged(): void {
    GridStateProxy.getInstance(this.persistentId)
      .dataSourceManager
      .updateWifiStatus(this.wifiStatusUpdater !== undefined && this.wifiStatusUpdater.currentState, this.isToggleOn);
  }

  private initTimeChangeListener(): void {
    CommonEventManagerAccess.createSubscriber([Constants.TIME_CHANGED_KEY, Constants.TIME_TICK_KEY,
      Constants.TIMEZONE_CHANGED_KEY])
      .then((subscriber?: eventMgr.CommonEventSubscriber): void => {
        this.timeChangeSubscriber = subscriber;
        if (!this.timeChangeSubscriber) {
          Log.error(TAG, 'create timeChange subscriber failed');
          return;
        }
        Log.info(TAG, 'create timeChange subscriber');
        if (this.isAboutToDisappear) {
          return;
        }
        subscribeEvent(this.timeChangeSubscriber, (eventData: eventMgr.CommonEventData): void => {
          Log.info(TAG, `timeChange status change: ${eventData.event}`);
          AppStorage.setOrCreate(Constants.CURRENT_TIME, new Date().getTime());
        }, TAG);
      })
  }

  private releaseListeners(): void {
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    GridStateProxy.getInstance(this.persistentId).selectManager.removeListener(this.selectListener);
    if (this.timeChangeSubscriber !== undefined) {
      CommonEventManagerAccess.unsubscribe(this.timeChangeSubscriber);
      this.timeChangeSubscriber = undefined;
    }
    this.getUIContext()?.getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_SHOW, this.pageShowFunc);
    this.getUIContext()?.getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_HIDE, this.pageHideFunc);
    this.wifiStatusUpdater?.unRegisterObserver(this.wifiStatusObserver);
    this.wifiStatusUpdater?.release();
  }

  private startReadyProcess(): void {
    Log.debug(TAG, 'startReadyProcess');
    if (this.observerProxy.isAllThumbnailReady()) {
      Log.info(TAG, 'all thumbnail is ready, no need to start ready task');
      return;
    }
    UserFileManagerAccess.getInstance().startCreateThumbnailTask();
  }

  private stopReadyProcess(): void {
    Log.debug(TAG, 'stopReadyProcess');
    UserFileManagerAccess.getInstance().stopCreateThumbnailTask();
  }

  private getTopAvoidHeight(): number {
    return this.isHorizontal ? 0 : px2vp(this.statusBarHeight);
  }

  // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
  private registerActions(): void {
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_LIFECYCLE_REGISTRY, this.lifecycleRegistry)
      .set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.selectManager)
      .set(MenuConstants.KEY_BROADCAST, this.appBroadCast)
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_PHOTO);
    ActionUtils.register(params);
  }

  private updateIsSupportTabbarAnimation() : void {
    this.gridController.updateGridConfig({ isSupportTabbarAnimation: this.getIsSupportTabbarAnimation() });
  }

  private getIsSupportTabbarAnimation(): boolean {
    return DeviceInfo.isVerdeFoldable();
  }

  private updateIsStatusBarInLayout() : void {
    this.gridController.updateDisplayConfig({ isStatusBarInLayout: this.getIsStatusBarInLayout()});
  }

  private getIsStatusBarInLayout(): boolean {
    return !DeviceInfo.isVerdeFoldable() && !this.isHorizontal;
  }

  private updateDayGuideState(): void {
    let totalCount: number = this.dataSourceManager?.dayDataSource?.totalCount() ?? 0;
    let selectManager: SelectManager = GridStateProxy.getInstance(this.persistentId).selectManager;
    // 打开设置页、照片页不在前台、不在照片页、大图页、选择模式、照片数量为0时时都不显示气泡, 其他场景时根据是否能够显示气泡historicalOptStatus判断是否显示气泡
    let isShowGuide: boolean = this.navigationPageInfos?.size() === 0 && this.isShow && this.isInCurrentTab &&
      !this.isShowPhotoBrowser && !selectManager?.mIsSelectedMode && totalCount !== 0;
    LogUtils.info(TAG, `updateDayGuideState isShowGuide:${isShowGuide} navigation:${this.navigationPageInfos?.size()}` +
      ` isShow:${this.isShow} isInCurrentTab:${this.isInCurrentTab} isShowPhotoBrowser:${!this.isShowPhotoBrowser}` +
      ` mIsSelectedMode:${!selectManager?.mIsSelectedMode} totalCount:${totalCount}`);
    this.gridController.updateDayGuideState(isShowGuide);
  }

  private updateGridVisibleState(): void {
    // 打开设置页、照片页不在前台、不在照片页、大图页、选择模式、照片数量为0时时都不显示气泡, 其他场景时根据是否能够显示气泡historicalOptStatus判断是否显示气泡
    let isGridVisible: boolean = this.navigationPageInfos?.size() === 0 && this.isShow && this.isInCurrentTab &&
      !this.isShowPhotoBrowser;
    LogUtils.info(TAG, `updateDayGuideState navigation:${this.navigationPageInfos?.size()}` +
      ` isShow:${this.isShow} isInCurrentTab:${this.isInCurrentTab} isShowPhotoBrowser:${!this.isShowPhotoBrowser}`);
    this.gridController.updateGridVisible(isGridVisible);
  }

  /**
   * 是否支持显示云同步卡片
   *
   * @returns 是否支持显示云同步卡片
   */
  private isCloudCardSupported(): boolean {
    return !(DeviceInfo.isPc() || DeviceInfo.isTv() || DeviceInfo.isEmulator() || DeviceInfo.isPrototypeAdu() ||
      DeviceInfo.isPrototypeLdu());
  }
  
  /**
   * 是否显示相机权限卡片
   *
   * @returns 是否显示相机权限卡片
   */
  private isShowCameraCard(): boolean {
    return !(DeviceInfo.isPc() || DeviceInfo.isTv() || DeviceInfo.isEmulator() || DeviceInfo.isPrototypeAdu() ||
    DeviceInfo.isPrototypeLdu());
  }

  // 以下大图页面监听对比按钮代码暂时在照片页逻辑实现，等大图适配新框架后删除当前实现逻辑
  onMediaOperationBack(pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string,
    navigationPageFunc?: Function): void {
    LogUtils.info(TAG, `onMediaOperationBack, pageType=${pageType}, mediaOperationAlbumUri=${mediaOperationAlbumUri}`);
  }

  onTabChanged(index: number): void {
    LogUtils.info(TAG, `onTabChanged index:${index}, isInCurrentTab:${this.isInCurrentTab}`);
    if (index === Constants.TIMELINE_PAGE_INDEX) {
      this.isInCurrentTab = true;
      this.isActive = true;
      this.gridController.updateGridActiveState(true);
      this.updateDayGuideState();
    } else {
      this.isInCurrentTab = false;
      this.isActive = false;
      this.gridController.updateGridActiveState(false);
      this.gridController.updateDayGuideShowState(false);
      this.updateDayGuideState();
    }
    this.updateGridVisibleState();
  }

  navigationPageInfosChanged(): void {
    // 照片页、相册页和时刻页的设置或关于页面返回宫格时会误触发显示提醒
    let isShowGuide: boolean = this.navigationPageInfos?.size() === 0 && this.isShow && this.isInCurrentTab
    LogUtils.info(TAG, `navigationPageInfosChanged isShowGuide:${isShowGuide}, ${this.navigationPageInfos?.size()}` +
      `, isShow=${this.isShow}, isInCurrentTab=${this.isInCurrentTab}`);
    // 打开图库设置页或关于页时不显示提醒气泡，关闭这两个页面时显示气泡
    this.updateDayGuideState();
    this.updateGridVisibleState();
  }

  onHidDeleteDialog(): void {
    LogUtils.info(TAG, 'onHidDeleteDialog');
    this.updateDayGuideState();
  }

  build() {
    if (this.isConfigReady) {
      PhotoGridView({
        persistentId: this.persistentId,
        dataSourceManager: this.dataSourceManager,
        gridConfig: {
          isSupportGroupDay: false,
          isSupportPreload: true,
          isSupportHeadMsg: true,
          isSupportDefaultSelect: false,
          isSupportShowTimeInTitle: true,
          isSupportTabbarAnimation: this.getIsSupportTabbarAnimation(),
          isLastFormIsDayGroup: false,
          isAutoAdjustColumns: true,
          hasCloudCard: this.isCloudCardSupported(),
          dayColumnsGap: 1,
          isSupportMinimal: !DeviceInfo.isFoldDevice(),
          isShowCameraCard: this.isShowCameraCard(),
        },
        switchConfig: {
          isSupportSwitch: true,
          switchMode: this.getSwitchMode(),
          isOpenGroupDayGuide: !(this.gridInitConfigSyncer?.groupDayGuideHasDisplayed ?? true),
          switchHidToBottom: this.whetherToHide ? !this.isShowTabAndSegmentButton : false,
        },
        pinchConfig: {
          isSupportPinch: true,
        },
        selectConfig: {
          isSupportSelect: true,
        },
        displayConfig: {
          areaSize: {
            width: ScreenManager.getInstance().getWinWidth(),
            height: ScreenManager.getInstance().getWinHeight()
          },
          isGridShow: !this.isPageHidden,
          isHorizontal: this.isHorizontal,
          isStatusBarInLayout: this.getIsStatusBarInLayout(),
          bottomAvoidHeight: this.currentTabBarHeight,
          topAvoidHeight: this.getTopAvoidHeight(),
        },
        navPathStack: this.navPathStack,
        gridAppBarManager: this.gridAppBarManager,
        broadcast: this.broadcast,
      })
    }
  }
}