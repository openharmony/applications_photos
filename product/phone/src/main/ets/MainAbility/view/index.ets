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

import lazy abilityAccessCtrl, { PermissionRequestResult, Permissions } from '@ohos.abilityAccessCtrl';
import lazy { Animator, AnimatorOptions, AnimatorResult } from '@kit.ArkUI';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil,
  AlbumBrowsingInfo,
  PhotoInfo
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BreakpointSystem, BreakPointType } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  updateAlbumPageGridPaddingLeftAndRight,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy {
  NavigationBroadCastManager
} from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy { TabItem } from '@ohos/common/src/main/ets/default/model/common/TabItem';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy taskpool from '@ohos.taskpool';
import lazy { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy router from '@ohos.router';
import lazy data_preferences from '@ohos.data.preferences';
import lazy common from '@ohos.app.ability.common';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { BusinessError } from '@ohos.base';
import lazy {
  getDurationConst,
  GridLink
} from '@ohos/common/src/main/ets/default/model/browser/photo/const/GridLinkDelay';
import lazy window from '@ohos.window';
import lazy display from '@ohos.display';
import lazy HashMap from '@ohos.util.HashMap';
import lazy {
  TabbarShowController,
  IsShowListener
} from '@ohos/common/src/main/ets/default/model/common/TabbarShowController';
import lazy {
  SideBar,
  SideBarItemClickListener,
  SideBarType
} from '../../../../../../../feature/browser/src/main/ets/default/view/SideBar';
import lazy curves from '@ohos.curves';
import lazy { SymbolGlyphModifier } from '@ohos.arkui.modifier';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { ActionBarVar, SideBarViewModel } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarColorMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import lazy { TabContentComponentLoaderParams } from './TabContentComponentLoaderParams';
import lazy { AlbumPhotoViewLoaderParams } from './AlbumPhotoViewLoaderParams';
import lazy { TimelinePageLoaderParams } from '@ohos/timeline/src/main/ets/view/TimelinePageLoaderParams';
import lazy { PickerBasePageParams } from '../../pickerability/view/PickerBasePage';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { WallpaperEditorLoaderParams } from '@ohos/common/src/main/ets/default/view/WallpaperEditorComponent';
import lazy { SlideShowLoaderParams } from '@ohos/common/src/main/ets/default/view/SlideShowPage';
import lazy { ImageCacheUtil } from '@ohos/common/src/main/ets/default/utils/ImageCacheUtil';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { SdCardDataViewUtils } from '@ohos/common/src/main/ets/default/utils/SdCardDataViewUtils';
import lazy CommonEventManager from '@ohos.commonEventManager';
import lazy { FoldUtil, FoldData } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { RelationStoreUtil } from '@ohos/common/src/main/ets/default/utils/RelationStoreUtil';
import lazy { AddPeopleTagLoaderParams } from './AddPeopleTagLoaderParams';
import lazy {
  externalStorageStatusBaseReport,
  nowOverOneDay
} from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import lazy {
  GridViewMode,
  PhotoGridViewConstants,
  PhotoGridViewController
} from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { EventHelper } from '@ohos/common/src/main/ets/default/view/ViewEventHelper';
import lazy { StorageUtils } from '@ohos/common/src/main/ets/default/utils/StorageUtils';
import lazy { GridInitConfigSyncer } from '@ohos/timeline/src/main/ets/view/adapter/GridInitConfigSyncer';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy {
  PhotoBrowserViewLoaderParams
} from '@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams';
import lazy { initPhotoBrowserController,
  LibraryConstants,
  PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy {
  AlbumCoverSelectLoaderParams,
  AlbumCoverPreviewLoaderParams
} from '@ohos/timeline/src/main/ets/albumgrid/view/albumCover/AlbumCoverSelectLoaderParams';
import lazy { TabBarUtils } from '@ohos/common/src/main/ets/default/utils/TabBarUtils';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { DaySubType } from '@ohos/common/src/main/ets/default/model/common/DaySubType';
import lazy { ShortcutController,
  ShortcutManager } from '@ohos/browsercommon/src/main/ets/default/controller/ShortcutController';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { PhotoAccessHelperAccess, PhotoAsset, PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { AccessUtil } from '@ohos/dataprovider/src/main/ets/AccessUtil'
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { DataSourceCommonUtil } from '@ohos/common/src/main/ets/default/utils/DataSourceCommonUtil';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import systemParameter from '@ohos.systemparameter';
import { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';

export type Preferences = data_preferences.Preferences;

export type UIAbilityContext = common.UIAbilityContext;

/* instrument ignore file */
const TAG: string = 'Photosindex';
const COMPONENT_KEY_PHOTOS: string = 'Photos';
const COMPONENT_KEY_ALBUMS: string = 'Albums';
const SHOW_SIDEBAR: number = 0;
const HIDE_SIDEBAR: number = 1;

interface Params {
  jumpSource: number;
  saveFinish: number;
  tabName: string;
  componentId: string;
  mediaItem: MediaItem;
  // location: mapCommon.LatLng;
};

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
};

PersistentStorage.persistProp<boolean>(Constants.IS_LOG_IN, false);
PersistentStorage.persistProp<string>(Constants.APP_STORAGE_KEY_USER_NAME, '');
PersistentStorage.persistProp<string>(Constants.APP_STORAGE_KEY_LOCAL_AVATAR_URI, '')
PersistentStorage.persistProp<number>(Constants.LAST_MEDIA_COUNT_REPORT_TIME, Constants.DEFAULT_TIMESTAMP);

PersistentStorage.persistProp<boolean>(Constants.OLD_PHOTO_ALBUM_SHOW, false);
PersistentStorage.persistProp<boolean>(Constants.OLD_VIDEO_ALBUM_SHOW, false);
PersistentStorage.persistProp<boolean>(Constants.OLD_FAVOR_ALBUM_SHOW, false);
PersistentStorage.persistProp<string>(Constants.APP_STORAGE_KEY_PORTRAIT_CACHE_INFO, '');

let storage: LocalStorage = LocalStorage.getShared();

@Concurrent
async function preLoad(): Promise<void> {
  await import('./PhotoBrowserLoader');
  await import('./TimelinePageLoader');
}

@Builder
export function IndexPageLoader(wrapperBindFunc: () => void, isFromFormProfile: boolean = false, isFromFormPortrait = false) {
  IndexPage({
    wrapperBindFunc,
    isFromFormProfile: isFromFormProfile,
    isFromFormPortrait: isFromFormPortrait,
  })
}

// Application entry
@Entry(storage)
@Component
struct IndexPage {
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') @Watch('onColorModeChange') private currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @State symbolModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.picture_fill'))
    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
    .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
      $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]);
  @State symbolModifierAlbum: SymbolGlyphModifier =
    new SymbolGlyphModifier($r('sys.symbol.rectangle_on_rectangle_fill'))
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
        $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]);
  @State symbolModifierMoment: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.heart_square_stack_fill'))
    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
    .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
      $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]);
  //tabbar高亮
  @State symbolModifierHighlighting: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.picture_fill'))
    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
    .fontColor([$r('sys.color.font_emphasize'),
      this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
        $r('app.color.tabbar_picture_fill_light_color') : $r('app.color.tabbar_picture_fill_dark_color')]);
  @State symbolModifierAlbumHighlighting: SymbolGlyphModifier =
    new SymbolGlyphModifier($r('sys.symbol.rectangle_on_rectangle_fill'))
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon'),
        $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor02')]);
  @State private isPageHidden: Visibility = Visibility.Visible;
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State @Watch('onShowVerdeOutTabBar') private isShowVerdeOutTabBar: boolean = true;
  private readonly tabbarShowListener: IsShowListener = {
    onIsShowTabbarChange: (isShowTabbar: boolean) => {
      if (!this.isVerdeFoldable) {
        return;
      }
      this.isShowVerdeOutTabBar = isShowTabbar;
    },
  };
  public tabbarShowController: TabbarShowController = TabbarShowController.getInstance();
  @StorageLink('app_key_tabs_index') preIndex: number = Constants.TIMELINE_PAGE_INDEX;
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @Provide private saveSwitch: boolean = false;
  @Provide private deleteSwitch: boolean = false;
  @Provide private largerSwitch: boolean = false;
  @Provide private smallerSwitch: boolean = false;
  @Provide isShow: boolean = true;
  @Provide screenHeight: number = 0.0;
  @Provide screenWidth: number = 0.0;
  @Provide isAlbumSetSelectedMode: boolean = false;
  @Provide isShowSideBar: boolean = DeviceInfo.isPhoneUx() ? false : true;
  @Provide albumInfoForMe: AlbumInfo | undefined = undefined;
  @State currentIndex: number = this.preIndex;
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  @State controlButtonMarginLeft: number = 16;
  @StorageLink('currentBreakpoint') @Watch('updateParameters') currentBreakpoint: string = Constants.BREAKPOINT_MD;
  @StorageLink('isShowPhotoGridView') @Watch('doAnimation') isShowPhotoGridView: boolean = false;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('navigationBarHeight') @Watch('navigationBarHeightChange') private navigationBarHeight: number = 0;
  @StorageLink('navigationBarBottomHeight') @Watch('navigationBarHeightChange')
  private navigationBarBottomHeight: number = 0;
  @StorageLink('windowStatus') @Watch('updatePhoneUx') windowStatus: number | undefined = undefined;
  @StorageLink('windowPcmodeSwitchStatus') @Watch('updatePhoneUx') windowPcmodeSwitchStatus: boolean = false;
  @Provide @Watch('isShowTabBarValueChangeVariableMonitoring') isShowTabBar: boolean = true;
  @State pageStatus: boolean = false;
  @State @Watch('onShowPhotoBrowser') isShowPhotoBrowser: boolean = false;
  @State @Watch('onShowSelectPhotoBrowser') isShowSelectPhotoBrowser: boolean = false;
  @State isRunningAnimation: boolean = false;
  public foldableScreenTabBarPadding: number = getScreen().getWinWidth() / 8;
  private tabs: TabItem[] = [
    new TabItem($r('app.string.tab_timeline'), $r('app.media.ic_photos'), $r('app.media.ic_photos_actived'), false,
      $r('sys.color.icon_secondary'), COMPONENT_KEY_PHOTOS),
    new TabItem($r('app.string.tab_albums'), $r('app.media.ic_albums'), $r('app.media.ic_albums_actived'), false,
      $r('sys.color.icon_secondary'), COMPONENT_KEY_ALBUMS),
    new TabItem($r('app.string.tab_highlights'),
      $r('app.media.ic_highlights'), $r('app.media.ic_highlights_activated'), false,
      $r('sys.color.icon_secondary'), Constants.COMPONENT_KEY_HIGHLIGHTS)
  ];
  private tabsController: TabsController = new TabsController();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private jumpSource: number = 0;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private photosPreferences: Preferences | null = null;
  @StorageLink('isFullMode') @Watch('isFullModeChange') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('old_photo_album_show') oldPhotoAlbumShow: boolean = false;
  @StorageLink('old_cloud_enhance_album_show') oldCloudEnhanceAlbumShow: boolean = false;
  @StorageLink('old_video_album_show') oldVideoAlbumShow: boolean = false;
  @StorageLink('old_favor_album_show') oldFavorAlbumShow: boolean = false;
  @Provide('isShowPhotoHiddenView') @Watch('doAnimation') isShowPhotoHiddenView: boolean = false;
  @State private isShowHiddenGridView: boolean = false;
  @Provide @Watch('updateBrowserStatus') browserController: PhotosHmBrowserController = new PhotosHmBrowserController(
    global.uiAbilityContext(), global.windowStage(), getContext())
  @Provide isShowPhotoClassifieds: boolean = false;
  @Provide isShowPhotoShooting: boolean = false;
  @Provide isShowPortraitAlbumsView: boolean = false;
  @State isShowHighlightView: boolean = false;
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  @LocalStorageProp('isEditorShown') isEditorShown: boolean = false;
  private firstKey: number | null = null;
  private navBarStateFlag: boolean = true;

  private sideBarItemClickListener: SideBarItemClickListener = {
    onSideBarItemClick: (sideBarIndex: number) => {
      if (sideBarIndex === SideBarType.HIGHLIGHT) {
        this.isShowHighlightView = true;
      } else {
        this.isShowHighlightView = false;
      }
    },
  };
  private navPathStack: NavPathStack = new NavPathStack();
  @Provide('navigationPageInfos') navigationPageInfos: NavPathStack = new NavPathStack();
  @StorageLink('isHorizontal') @Watch('isHorizontalChange') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isShowFinishToast') isShowFinishToast: boolean = false;
  @Provide favorCacheItemsMap: HashMap<String, MediaItem> = new HashMap<String, MediaItem>();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State private currentTabBarHeight: number = DeviceInfo.isVerdeFoldable() ?
    Constants.ToolBarHeight : px2vp(this.rsc.getNumber($r('app.float.tab_nav_bar_vertical_height')));
  @State isSelectedModeIndex: boolean = false;
  @State tabsPaddingBottom: number = this.isShowTabBar ? px2vp(this.navigationBarHeight) :
    this.diggingHoleCameraArea.bottom;
  @State initTabsPaddingBottom: number = this.tabsPaddingBottom;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private loadNavigationPageFun: (name: string) => Promise<void> =
    (name: string): Promise<void> => this.loadNavigationPage(name);
  @State private isBrowserLoaded: boolean = false;
  private isSelectBrowserLoaded: boolean = false;
  @State scrollIndex: number = -1;
  @Provide isShowTimelinePage: boolean = true;
  @Provide isShowPortraitView: boolean = false;
  @State private isShowGallerySettingBasePage: boolean = false;
  @State private isShowAboutGalleryPage: boolean = false;
  // 搜索相关
  @State private searchKeyword: string = '';
  @Provide photoSearchWord: string = '';
  @Provide displaySearchWords: string = '';
  @Provide photoSearchOnSubmit: number = 0;
  @Provide searchHistoryClearOnSubmit: number = 0;
  @Provide photoHistoryWordClicked: string = '';
  @State isShowSearchPage: boolean = false;
  @State isSearchBarFocused: boolean = false;
  @Provide clickSearchSlotItemWatch: number = 0;
  @State isSelectedMode: boolean = false;
  @State private colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @State private titlePaddingLeft: number = updateAlbumPageGridPaddingLeftAndRight();
  @State isTabContentLoaded: boolean = false;
  @State isTimelineLoaded: boolean = false;
  @State isAlbumPhotoViewLoaded: boolean = false;
  @State sideBarWidth: number = Constants.TAB_BAR_WIDTH;
  @State private isShowSdCardTip: boolean = false;
  @State private cardNameUris: string[] = [];
  private insertExternalStorageCountReportTime: string = '';
  private removeExternalStorageCountReportTime: string = '';
  private insertExternalStorageCount: number = 0;
  private removeExternalStorageCount: number = 0;
  @State strokeWidth: string = '0';
  @State @Watch('onPhoneUxChange') isPhoneUx: boolean = DeviceInfo.isPhoneUx();
  // 是否需要横屏后隐藏年月日和TAB，false表示横竖屏切换时不用隐藏
  private whetherToHide: boolean = false;
  @State @Watch('isShowTabBarByHotZone') isShowTabAndSegmentButton: boolean = this.whetherToHide ? !this.isHorizontal : true;
  // 监听点击TAB切换视图操作
  @State isChangeByClickTab: boolean = false;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;
  @LocalStorageLink('geometryReuseId') geometryReuseId: string = '';
  @LocalStorageLink(PhotoGridViewConstants.KEY_INDEX_GRID_VIEW_CONTROLLER) gridViewController: PhotoGridViewController =
    new PhotoGridViewController();
  @StorageLink('isLogIn') isLogIn: boolean = true;
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);
  @LocalStorageLink('isKeepStatus') isKeepStatus: boolean = false;
  private albumInfo: AlbumInfo = new AlbumInfo();
  private isFirstStart: boolean = false;
  @StorageLink('isKeepCategoryPage') isKeepCategoryPage: boolean = false;
  @StorageLink('isKeepShootPage') isKeepShootPage: boolean = false;
  private focusCtrlManager = FocusCtrlManager.getInstance();
  public isFromFormProfile: boolean = false;
  public isFromFormPortrait: boolean = false;
  private handleShowSearchPageFunc: () => void = (): void => this.handleShowSearchPage();
  private isFromPortraitCard: boolean = false;
  private wrapperBindFunc?: () => void;

  private onFoldDataChange(foldData: FoldData) {
    if (FoldUtil.isTriExpand(this.curFoldStatus) === FoldUtil.isTriExpand(foldData.curFoldStatus) ||
      this.windowStatus === window.WindowStatusType.FLOATING) {
      this.curFoldStatus = foldData.curFoldStatus;
      return;
    }
    let isShowCategoryPage = LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED);
    if (isShowCategoryPage === undefined) {
      Log.info(TAG, 'classified album is not need keep');
      this.isShowPhotoClassifieds = false;
    }

    let isShowShootingPage = LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING);
    if (isShowShootingPage === undefined) {
      Log.info(TAG, 'shooting mode album is not need keep');
      this.isShowPhotoShooting = false;
    }

    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_PORTRAIT_ENTRY) === undefined) {
      Log.info(TAG, 'portrait album is not need keep');
      this.isShowPortraitAlbumsView = false;
    }
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_KEEP_SEARCH) === undefined) {
      Log.info(TAG, 'search page is not need keep');
      this.isShowSearchPage = false;
    }

    this.isKeepCategoryPage = true;
    this.isKeepShootPage = true;
    this.isKeepStatus = true;
    this.curFoldStatus = foldData.curFoldStatus;
    let portraitPosition = LocalStorage.getShared()?.get<number>(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
    Log.info(TAG,`grl portrait compontent position: ${portraitPosition}`);
    ScreenManager.getInstance().initOrientation();
    if (FoldUtil.isTriExpand(foldData.curFoldStatus)) {
      this.isPhoneUx = this.getPhoneUX();
      this.isShowSideBar = true;
      ActionBarVar.isShowSideBar = this.isShowSideBar;
      TabBarUtils.printLog(TAG, 'onFoldDataChange isTriExpand', this.isShowTabBar, false);
      this.isShowTabBar = false;
      if (this.currentIndex === Constants.TIMELINE_PAGE_INDEX) {
        this.isShowTimelinePage = true;
        this.isShowPhotoGridView = false;
        this.isAlbumPhotoViewLoaded = false;
        this.isShowHighlightView = false;
      } else if (this.currentIndex === Constants.ALBUM_PAGE_INDEX) {
        this.isShowTimelinePage = false;
        if (!this.isShowPhotoHiddenView && portraitPosition === undefined && isShowCategoryPage === undefined &&
          isShowShootingPage === undefined) {
          this.isShowPhotoGridView = true;
        }
        this.isAlbumPhotoViewLoaded = true;
        this.isShowHighlightView = false;
      } else {
        this.isShowTimelinePage = false;
        this.isShowPhotoGridView = false;
        this.isAlbumPhotoViewLoaded = false;
        this.isShowHighlightView = true;
      }
      if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_HIDDEN_ENTRY)) {
        this.navigationPageInfos?.clear(false);
      }
    } else {
      this.isPhoneUx = true;
      this.isShowSideBar = false;
      ActionBarVar.isShowSideBar = this.isShowSideBar;
      TabBarUtils.printLog(TAG, 'onFoldDataChange not triExpand', this.isShowTabBar, true);
      this.isShowTabBar = true;
      if (this.isShowTimelinePage) {
        this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
      } else {
        this.currentIndex = Constants.ALBUM_PAGE_INDEX;
      }
      this.onTabChanged(this.currentIndex);
    }
    if (DeviceInfo.isGRLFoldScreen()) {
      let showSideBar = LocalStorage.getShared()?.get<number>(Constants.APP_KEY_GRL_IS_SHOW_SIDEBAR);
      Log.info(TAG, `onFoldDataChange storage showSideBar: ${showSideBar}`);
      if (showSideBar === SHOW_SIDEBAR) {
        this.isShowSideBar = true;
      } else if (showSideBar === HIDE_SIDEBAR) {
        this.isShowSideBar = false;
      }
    }
  }

  private FoldDisplayModeChangeFunc = (status: display.FoldDisplayMode): void => {
    AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
    if (this.isShowPhotoBrowser) {
      return;
    }
    if (status === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN && this.isHorizontal) {
      getScreen().setSystemUi(false, true);
    } else {
      getScreen().setSystemUi(true);
    }
  }

  private hideBrowserBarsFunc: () => void = (): void => {
    this.browserController.emitCallback(LibraryConstants.HIDE_BARS_CALLBACK, []);
  }
  // tabBar显示和隐藏动效
  private viewAnimator: AnimatorResult | undefined;
  private updateColorModeFunc: () => void = (): void => this.updateColorMode();
  private jumpToAlbumForFileManagerFunc: () => void = (): void => this.jumpToAlbumForFileManager();

  private isPullingDown: boolean = false;
  private isPullingDownFunc: (isPullingDown: boolean) => void = (isPullingDown: boolean): void => {
    this.isPullingDown = isPullingDown;
  }
  private isPullingUp: boolean = false;
  private isPullingUpFunc: (isPullingUp: boolean) => void = (isPullingUp: boolean): void => {
    this.isPullingUp = isPullingUp;
  }
  private isClickRemoveOrHiddenDialog: boolean = false;
  private isClickRemoveOrHiddenDialogFunc: (isClickRemoveOrHiddenDialog: boolean) => void =
    (isClickRemoveOrHiddenDialog: boolean): void => {
      this.isClickRemoveOrHiddenDialog = isClickRemoveOrHiddenDialog;
    }
  private isShowOrHideBar: boolean = false;
  private isShowOrHideBarFunc: (isShowOrHideBar: boolean) => void = (isShowOrHideBar: boolean): void => {
    this.isShowOrHideBar = isShowOrHideBar;
  }
  private onIsSelectModeFunc: (isSelectMode: boolean) => void = (isSelectMode: boolean): void => {
    this.isSelectedMode = isSelectMode;
  }
  isFaCardExitTransition = false;
  private changePageExitTransitionFunc: () => void = (): void => {
    this.isFaCardExitTransition = true;
  }
  // 宫格初始配置同步器
  private gridInitConfigSyncer?: GridInitConfigSyncer;
  @State isConfigReady: boolean = false;

  private getTitlePaddingLeft(): number {
    this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight();
    return this.titlePaddingLeft;
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))
        && i18n.isRTL(this.currentLanguage);
    }
  }

  public async isGetTips(): Promise<void> {
    let isCompareTip = await DataStoreUtil.getInstance().getData(Constants.IS_CLOSE_COMPARE_TIP, true) as boolean;
    AppStorage.setOrCreate<boolean>(Constants.IS_CLOSE_COMPARE_TIP, isCompareTip);
    let isConnectionTip = await DataStoreUtil.getInstance().getData(Constants.IS_CLOSE_CONNECTION_TIP, true) as boolean;
    AppStorage.setOrCreate<boolean>(Constants.IS_CLOSE_CONNECTION_TIP, isConnectionTip);
  }

  private onColorModeChange(): void {
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.symbolModifierHighlighting = new SymbolGlyphModifier($r('sys.symbol.picture_fill'))
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
        .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon'),
          $r('app.color.tabbar_picture_fill_light_color')]);
    } else {
      this.symbolModifierHighlighting = new SymbolGlyphModifier($r('sys.symbol.picture_fill'))
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
        .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon'),
          $r('app.color.tabbar_picture_fill_dark_color')]);
    }
  }

  // 外屏，控制显示和隐藏tabBar动效
  onShowVerdeOutTabBar(): void {
    let options: AnimatorOptions = {
      duration: Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION,
      easing: 'friction',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      begin: this.isShowVerdeOutTabBar ? 0 : Constants.ToolBarHeight,
      end: this.isShowVerdeOutTabBar ? Constants.ToolBarHeight : 0,
      iterations: 1,
    }
    this.viewAnimator = Animator.create(options);
    if (this.viewAnimator) {
      this.viewAnimator.onFinish = () => {
        if (!DeviceInfo.isVerdeFoldable()) {
          Log.info(TAG,
            `onfinishAni resetHeight ${px2vp(this.rsc.getNumber($r('app.float.tab_nav_bar_vertical_height')))}`);
          this.currentTabBarHeight = px2vp(this.rsc.getNumber($r('app.float.tab_nav_bar_vertical_height')));
        }
      }
      this.viewAnimator.onFrame = (progress: number) => {
        this.currentTabBarHeight = progress;
      }
    }
    if (this.viewAnimator) {
      this.viewAnimator.play();
    }
  }

  // 由isShowTabAndSegmentButton控制显示和隐藏tabBar动效
  isShowTabBarByHotZone(): void {
    if (!this.whetherToHide || (this.currentIndex !== 0 && !this.isHorizontal)) {
      Log.info(TAG, 'isShowTabBarByHotZone return');
      return;
    }
    let currentTabBarHeight: number = ImmersiveController.endTabBarHeight;
    let tabBarHeight: number = this.isFullMode ? Constants.ToolBarHeight + px2vp(this.navigationBarHeight) :
      Constants.ToolBarHeight + px2vp(this.navigationBarBottomHeight);
    if (this.isShowTabAndSegmentButton) {
      // 横屏显示TAB时根据TAB高度初始值是否异常判断，竖屏显示TAB时判断当前值是否小于默认偏移，防止竖屏时偏移不够导致分段按钮和TAB间隔异常
      if (this.isHorizontal) {
        if (currentTabBarHeight <= 0) {
          currentTabBarHeight = tabBarHeight;
        }
      } else {
        if (currentTabBarHeight < tabBarHeight) {
          currentTabBarHeight = tabBarHeight;
        }
      }
    }
    let options: AnimatorOptions = {
      duration: Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION,
      easing: 'friction',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      begin: this.isShowTabAndSegmentButton ? 0 : currentTabBarHeight,
      end: this.isShowTabAndSegmentButton ? currentTabBarHeight : 0,
      iterations: 1,
    }
    Log.info(TAG,
      `isShowTabBarByHotZone isHorizontal:${this.isHorizontal} ${this.isShowTabAndSegmentButton} isFirstStart:${this.isFirstStart} ` +
        `${this.isShowTabBar} ${currentTabBarHeight} ${this.currentTabBarHeight} ${ImmersiveController.endTabBarHeight} ${tabBarHeight}`);
    if (this.isShowTabAndSegmentButton) {
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_SEGMENT, [this.currentIndex]);
    }
    this.viewAnimator = Animator.create(options);
    if (this.viewAnimator) {
      this.viewAnimator.onFinish = () => {
        Log.info(TAG, `isShowTabBarByHotZone onFinish:${this.currentTabBarHeight}`);
      }
      this.viewAnimator.onFrame = (progress: number) => {
        this.currentTabBarHeight = progress;
      }
    }
    if (this.viewAnimator) {
      // 第一次横屏冷启动时因为isShowTabAndSegmentButton会从默认值true更新为false导致位移动效触发，因此需要禁止启动动效
      if (this.isHorizontal && this.isFirstStart) {
        this.isFirstStart = false;
        this.currentTabBarHeight = 0;
      } else {
        this.viewAnimator.play();
      }
    }
  }

  doAnimation(): void {
    if (this.isSidebar && this.currentBreakpoint !== Constants.BREAKPOINT_LG) {
      this.isSidebar = !this.isShowPhotoGridView && !this.isShowPhotoHiddenView && !this.isShowHiddenGridView &&
        !this.isShowPhotoClassifieds && !this.isShowPhotoShooting;
    }
    if (this.isShowPhotoClassifieds || this.isShowPhotoShooting) {
      return;
    }
    animateTo({
      duration: getDurationConst((this.isShowPhotoGridView || this.isShowPhotoHiddenView) ? GridLink.IN_TAB_BAR :
        GridLink.OUT_TAB_BAR),
      curve: Curve.Sharp,
    }, (): void => {
      TabBarUtils.printLog(TAG, 'doAnimation', this.isShowTabBar, !this.isShowPhotoGridView);
      this.isShowTabBar = !this.isShowPhotoGridView;
    })
  }

  private async getRefreshCategoryFlag(): Promise<void> {
    try {
      const categoryFreshFlag: string =
        systemParameter.getSync(Constants.MEDIA_CATEGORY_FRESH);
      // 转二进制
      const categoryFlagBinary: string = Number(categoryFreshFlag).toString(2);
      const paddedCategoryFlagBinary: string = categoryFlagBinary.padStart(3, '0');
      Log.info(TAG, `categoryFreshFlag ${categoryFreshFlag} paddedCategoryFlagBinary ${paddedCategoryFlagBinary}`)
      if (paddedCategoryFlagBinary[2] === Constants.CATEGORY_CV_DONE ||
        (paddedCategoryFlagBinary[1] === Constants.CATEGORY_OLD_DONE &&
          paddedCategoryFlagBinary[0] === Constants.CATEGORY_NEW_EMPTY)) {
        Log.info(TAG, '|isNewCategoryCVFinished true');
        AppStorage.SetOrCreate<boolean>('isNewCategoryCVFinished', true);
        AppStorage.SetOrCreate<boolean>('needNoteUser', true);
      }
    } catch (e) {
      Log.info(TAG, `getRefreshCategoryFlag error ${e.message}`)
    }

  }

  aboutToDisappear(): void {
    Log.info(TAG, '[aboutToDisappear]');
    try {
      display.off('foldDisplayModeChange', this.FoldDisplayModeChangeFunc);
    } catch (err) {
      Log.error(TAG, `Display.off error: ${err}, code: ${err?.code}`);
    }
    this.isFirstStart = false;
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    this.breakpointSystem.unregister();
    this.tabbarShowController.removeListener(this.tabbarShowListener);
    this.navigationBroadCast.off(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
    this.appBroadCast.off(BroadCastConstants.HIDE_BROWSER_BARS, this.hideBrowserBarsFunc)
    this.appBroadCast.off(BroadCastConstants.SELECT, this.onIsSelectModeFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, this.updateColorModeFunc);
    this.appBroadCast.off(BroadCastConstants.IS_PULLING_DOWN, this.isPullingDownFunc);
    this.appBroadCast.off(BroadCastConstants.IS_PULLING_UP, this.isPullingUpFunc);
    this.appBroadCast.off(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, this.isClickRemoveOrHiddenDialogFunc);
    this.appBroadCast.off(BroadCastConstants.JUMP_TO_ALBUM_FOR_FILE_MANAGER, this.jumpToAlbumForFileManagerFunc);
    this.appBroadCast.off(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
    this.appBroadCast.off(BroadCastConstants.CHANGE_PAGE_EXIT_TRANSITION, this.changePageExitTransitionFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_SEARCH_PAGE_BY_SIDE_BAR_ALBUM, this.handleShowSearchPageFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    SdCardDataViewUtils.getInstance().unsubscribeStorageDeviceChangeEvent();
  }

  isShowTabBarValueChangeVariableMonitoring(): void {
    Log.info(TAG, `isShowTabBar value change to ${this.isShowTabBar}`);
    this.tabsPaddingBottomChange();
  }

  private async onShowPhotoBrowser(): Promise<void> {
    this.appBroadCast.emit(BroadCastConstants.OPEN_OR_CLOSE_PHOTO_BROWSER, [this.isShowPhotoBrowser]);
    if (this.isBrowserLoaded) {
      return;
    }
    Log.info(TAG, 'onShowPhotoBrowser load browserLoader');
    try {
      let photoBrowserLoader = await import('./PhotoBrowserLoader');
      this.photoBrowserViewLoader = photoBrowserLoader.PhotoBrowserViewLoader;
      this.isBrowserLoaded = true;
    } catch (error) {
      Log.error(TAG, `loadPhotoBrowser error: ${error}`);
    }
  }

  private async onShowSelectPhotoBrowser(): Promise<void> {
    if (this.isSelectBrowserLoaded) {
      return;
    }
    Log.info(TAG, 'onShowSelectPhotoBrowser load browserLoader');
    try {
      let photoBrowserLoader = await import('./PhotoBrowserLoader');
      this.selectPhotoBrowserLoader = photoBrowserLoader.SelectPhotoBrowserLoader;
      this.isSelectBrowserLoaded = true;
    } catch (error) {
      Log.error(TAG, `onShowSelectPhotoBrowser error: ${error}`);
    }
  }

  isHorizontalChange(): void {
    this.tabsPaddingBottomChange();
    // 直板手机照片页进入横屏不显示tabBar
    if (this.whetherToHide && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx() &&
      !(DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) &&
      this.currentIndex === Constants.TIMELINE_PAGE_INDEX && !this.isShowPhotoBrowser) {
      Log.info(TAG, `isHorizontalChange start:${this.isHorizontal} ${this.isShowTabAndSegmentButton}`);
      if (this.isHorizontal) {
        this.currentTabBarHeight = 0;
        this.isShowTabAndSegmentButton = false;
      } else {
        this.isShowTabAndSegmentButton = true;
      }
    }
    if (this.isHorizontal && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      ScreenManager.getInstance().setDefaultStatusBarProperties(true);
    } else {
      ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    }
    Log.info(TAG, `isHorizontalChange end:${this.currentIndex} ${this.isHorizontal} ${this.isShowTabAndSegmentButton}`);
    if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      ScreenManager.getInstance().recoverHorizontalStatusBar(this.isHorizontal);
    }
  }

  private onWinSizeChanged(): void {
    this.tabsPaddingBottomChange();
    this.onWinSizeChangedInner();
    // 大xxxxxx,不区分横竖屏
    if (DeviceInfo.isFoldable()) {
      ScreenManager.getInstance().recoverHorizontalStatusBar(false);
    }
  }

  private isFullModeChange(): void {
    this.tabsPaddingBottomChange();
  }

  private currentTabBarHeightChange(): void {
    // tab存在
    if (!this.isHorizontal) {
      // 垂直
      this.currentTabBarHeight = this.isFullMode ? Constants.ToolBarHeight + px2vp(this.navigationBarHeight) :
        Constants.ToolBarHeight + px2vp(this.navigationBarBottomHeight);
    } else {
      // 水平
      if ((DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) || DeviceInfo.isPhoneUx()) {
        this.currentTabBarHeight = this.isFullMode ?
          Constants.ToolBarHeight_Horizontal + px2vp(this.navigationBarHeight) :
          Constants.ToolBarHeight_Horizontal + px2vp(this.navigationBarBottomHeight);
      }
      /* instrument ignore next */
      if (DeviceInfo.isFoldable() && getScreen().isFullMode()) {
        this.currentTabBarHeight = Constants.TabCoverAIHeight;
      }
      /* instrument ignore next */
      if (DeviceInfo.isFoldable() && !getScreen().isFullMode()) {
        this.currentTabBarHeight = Constants.ToolBarHeight;
      }
    }
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.currentTabBarHeight = this.isShowVerdeOutTabBar ? Constants.ActionBarHeight : 0;
    }
    // 记录tabBar高度
    if (!DeviceInfo.isFoldable() && this.isHorizontal) {
      ImmersiveController.endTabBarHeight = this.currentTabBarHeight;
    }
    Log.info(TAG, `currentTabBarHeightChange:${this.isShowTabBar} ${this.tabsPaddingBottom} ${this.currentTabBarHeight}`);
  }

  private tabsPaddingBottomChange(): void {
    // 如果复杂类型里面的属性值不变，不建议直接赋值，否则被@StorageLink装饰的变量都会触发变化，引起节点标脏
    let tempDiggingHoleCameraArea: DiggingHoleCameraArea = getScreen().getDiggingHoleCameraArea();
    if (!(tempDiggingHoleCameraArea.top === this.diggingHoleCameraArea.top &&
      tempDiggingHoleCameraArea.bottom === this.diggingHoleCameraArea.bottom &&
      tempDiggingHoleCameraArea.left === this.diggingHoleCameraArea.left &&
      tempDiggingHoleCameraArea.right === this.diggingHoleCameraArea.right)) {
      this.diggingHoleCameraArea = tempDiggingHoleCameraArea;
    }
    this.currentTabBarHeightChange();
    let tabsPaddingBottom = 0;
    if (this.isShowTabBar) {
      // tab存在
      tabsPaddingBottom = this.isFullMode ? px2vp(this.navigationBarHeight) : px2vp(this.navigationBarBottomHeight);
      this.initTabsPaddingBottom = tabsPaddingBottom;
    } else {
      // tab不存在
      tabsPaddingBottom = this.diggingHoleCameraArea.bottom;
      this.initTabsPaddingBottom = tabsPaddingBottom;
    }
    this.tabsPaddingBottom = tabsPaddingBottom;
    Log.info(TAG, `tabsPaddingBottomChange:${this.diggingHoleCameraArea.bottom} ${this.tabsPaddingBottom} ${this.currentTabBarHeight}`);
    this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight();
  }

  updateParameters(): void {
    this.isSidebar = new BreakPointType({
      sm: false,
      md: false,
      lg: true,
    }).getValue(this.currentBreakpoint) as boolean;
  }

  private navigationBarHeightChange(): void {
    this.tabsPaddingBottomChange();
  }

  initPhotosStore(): void {
    this.photosPreferences = AppStorage.get<Preferences>(Constants.PHOTOS_STORE_KEY) as Preferences;
    if (this.photosPreferences) {
      this.preIndex = this.photosPreferences.getSync(Constants.PREFERENCES_KEY_LAST_PAGE, 0) as number;
      Log.info(TAG, `initPhotosStore preIndex: ${this.preIndex}`);
      this.currentIndex = this.preIndex;
    } else {
      Log.warn(TAG, 'initPhotosStore photosPreferences is undefined');
    }
  }

  private initTabPage(): void {
    if (!this.isPhoneUx) {
      return;
    }
    this.loadTabPage(this.currentIndex);
    const TAB_PAGE_PRELOAD_DURATION: number = 400;
    setTimeout((() => {
      if (this.currentIndex === Constants.TIMELINE_PAGE_INDEX) {
        this.loadTabPage(Constants.ALBUM_PAGE_INDEX);
      } else if (this.currentIndex === Constants.ALBUM_PAGE_INDEX) {
        this.loadTabPage(Constants.TIMELINE_PAGE_INDEX);
      } else {
        this.loadTabPage(Constants.ALBUM_PAGE_INDEX);
        this.loadTabPage(Constants.TIMELINE_PAGE_INDEX);
      }
    }), TAB_PAGE_PRELOAD_DURATION);
    PhotoInfo.scenarioIndex = this.currentIndex;
    let localStorage: LocalStorage = LocalStorage.getShared();
    localStorage?.setOrCreate<number>(Constants.SCENARIO_INDEX, this.currentIndex);
  }

  updatePhotosStore(key: string, value: number): void {
    if (!this.photosPreferences) {
      Log.warn(TAG, 'initPhotosStore photosPreferences is undefined');
      return;
    }
    this.photosPreferences.put(key, value).then((): void => {
      Log.debug(TAG, `updatePhotosStore succeeded to put the value of '${key}'.`);
      this.photosPreferences?.flush();
    }).catch((err: BusinessError) => {
      Log.error(TAG, `updatePhotosStore Failed to put the value of '${key}'. Cause: ${err}, code: ${err?.code}`);
    });
  }

  private getPhoneUX(currentWinMode?: WindowMode): boolean {
    let winMode = currentWinMode ?? getScreen().getWinMode();
    return DeviceInfo.isPhoneUx() || (DeviceInfo.isTablet() && winMode === WindowMode.FLOATING &&
      !this.windowPcmodeSwitchStatus && !getScreen().isFullModeReal() && !getScreen().isLandscapeLayout());
  }

  aboutToAppear(): void {
    this.wrapperBindFunc?.();
    TraceControllerUtils.startTrace('indexPageAppearToShow');
    Log.info(TAG, '[aboutToAppear] isShowTabBarByHotZone');
    this.isFirstStart = true;
    ReportToBigDataUtil.report(BigDataConstants.INDEX_APPEAR);
    initPhotoBrowserController(this.browserController, 'TimelinePage', false);
    this.getRefreshCategoryFlag();
    let currentWinMode: WindowMode = getScreen().getWinMode();
    if (currentWinMode === WindowMode.FLOATING && !this.windowPcmodeSwitchStatus) {
      this.isPhoneUx = true;
    } else {
      this.isPhoneUx = this.getPhoneUX(currentWinMode);
    }
    if (DeviceInfo.isTablet()) {
      this.isShowTabBar = this.isPhoneUx;
      this.isShowSideBar = !this.isPhoneUx;
      ActionBarVar.isShowSideBar = this.isShowSideBar;
    }
    getScreen().updateSize();
    taskpool.execute(preLoad).then((res): void => {
      Log.i(TAG, `preLoad res：${res}`);
    }).catch((error: string): void => {
      Log.e(TAG, `preLoad error：${error}`);
    });
    const LOAD_BROWSER_DURATION: number = 450;
    setTimeout((): void => {
      this.onShowPhotoBrowser();
      this.onShowSelectPhotoBrowser();
    }, LOAD_BROWSER_DURATION);
    this.loadAlbumPhotoView();
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    this.breakpointSystem.registerOrientationChange();
    WindowUtil.prepareWinRouter();
    this.isGetTips();
    try {
      display.on('foldDisplayModeChange', this.FoldDisplayModeChangeFunc);
    } catch (err) {
      Log.error(TAG, `Display.on error: ${err}, code: ${err?.code}`);
    }
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }

    if (AlbumUtils.useNewPhotoGrid()) {
      this.gridInitConfigSyncer = new GridInitConfigSyncer();
      let param: Params = tryGetRouterParam() as Params;
      if (param?.jumpSource === JumpSourceToMain.PHOTO_VIEW) {
        this.gridInitConfigSyncer.initGridConfig(DaySubType.GROUP).then(() => {
          Log.info(TAG, `initGridConfig finish--group`);
          this.isConfigReady = true;
        });
      } else {
        this.gridInitConfigSyncer.initGridConfig().then(() => {
          Log.info(TAG, `initGridConfig finish`);
          this.isConfigReady = true;
        });
      }
    }

    this.breakpointSystem.register();
    this.navigationBroadCast.on(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);

    this.updateParameters();
    this.requestPermissions();
    this.initDataFromParam();
    this.appBroadCast.on(BroadCastConstants.HIDE_BROWSER_BARS, this.hideBrowserBarsFunc)
    this.appBroadCast.on(BroadCastConstants.SELECT, this.onIsSelectModeFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, this.updateColorModeFunc);
    this.appBroadCast.on(BroadCastConstants.IS_PULLING_DOWN, this.isPullingDownFunc);
    this.appBroadCast.on(BroadCastConstants.IS_PULLING_UP, this.isPullingUpFunc);
    this.appBroadCast.on(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, this.isClickRemoveOrHiddenDialogFunc);
    this.appBroadCast.on(BroadCastConstants.JUMP_TO_ALBUM_FOR_FILE_MANAGER, this.jumpToAlbumForFileManagerFunc);
    this.appBroadCast.on(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
    this.appBroadCast.on(BroadCastConstants.CHANGE_PAGE_EXIT_TRANSITION, this.changePageExitTransitionFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_SEARCH_PAGE_BY_SIDE_BAR_ALBUM, this.handleShowSearchPageFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    // 储存AiBar高度
    let localStorage: LocalStorage = LocalStorage.getShared();
    localStorage.setOrCreate<number>(Constants.AI_BAR_HEIGHT, getScreen().getAiBarHeight());

    // 设置图片加载框架图片缓存最大值
    ImageCacheUtil.initCacheSize(Constants.IMAGE_LOADER_MAX_CACHE_SIZE);

    // 图库启动后挂载文件系统服务
    ImageCacheUtil.resetH8();

    LocalStorage.getShared()?.setOrCreate<SideBarViewModel>(SideBarViewModel.STORAGE_KEY, new SideBarViewModel())
    this.currentLanguage = i18n.System.getSystemLanguage();
    this.onLanguageChange();
    this.tabbarShowController.addListener(this.tabbarShowListener);
    this.querySdCardData();
    SdCardDataViewUtils.getInstance()?.subscribeStorageDeviceChangeEvent(this.subscribeStorageDeviceChangeCallback);
    AlbumGridSortHelper.getInstance().resume(this.getUIContext().getHostContext());
    Log.info(TAG, `updateTabAndSegmentState:${this.isHorizontal} ${this.isShowTabAndSegmentButton}`);
    // 冷启动过程中执行横竖屏旋转时会出现横竖屏状态监听延迟导致TAB显隐异常，延迟100毫秒再判断状态
    setTimeout((): void => {
      this.updateTabAndSegmentState();
    }, 100);
  }

  private async updateTabAndSegmentState(): Promise<void> {
    try {
      const isDeviceHorizontal: boolean = await isOrientationHorizontal();
      if (isDeviceHorizontal) {
        this.isShowTabAndSegmentButton = false;
      } else {
        this.isShowTabAndSegmentButton = true;
      }
      Log.info(TAG, `updateTabAndSegmentState isHorizontal:${this.isHorizontal} ${this.isShowTabAndSegmentButton}`);
    } catch (err) {
      Log.info(TAG, `updateTabAndSegmentState error: ${err}`);
    }
  }

  private async querySdCardData(): Promise<void> {
    this.cardNameUris = await SdCardDataViewUtils.getInstance().getSdCardName() ?? [];
    // 外接设备打点初始化
    this.insertExternalStorageCount =
      await DataStoreUtil.getInstance().getData(BigDataConstants.INSERT_EXTERNAL_STORAGE_COUNT, 0);
    this.removeExternalStorageCount =
      await DataStoreUtil.getInstance().getData(BigDataConstants.REMOVE_EXTERNAL_STORAGE_COUNT, 0);
    this.insertExternalStorageCountReportTime =
      await DataStoreUtil.getInstance().getData(BigDataConstants.INSERT_EXTERNAL_STORAGE_TIME, '');
    this.removeExternalStorageCountReportTime =
      await DataStoreUtil.getInstance().getData(BigDataConstants.REMOVE_EXTERNAL_STORAGE_TIME, '');
  }

  private async insertExternalStorageCountReport(): Promise<void> {
    this.insertExternalStorageCount++;
    if (nowOverOneDay(this.insertExternalStorageCountReportTime)) {
      externalStorageStatusBaseReport(BigDataConstants.INSERT_EXTERNAL_STORAGE_COUNT, this.insertExternalStorageCount)
        .then((x) => {
          this.insertExternalStorageCountReportTime = x;
        });
      this.insertExternalStorageCount = 0;
      DataStoreUtil.getInstance().putData(BigDataConstants.INSERT_EXTERNAL_STORAGE_COUNT, 0);
      DataStoreUtil.getInstance()
        .putData(BigDataConstants.INSERT_EXTERNAL_STORAGE_TIME, this.insertExternalStorageCountReportTime);
    } else {
      DataStoreUtil.getInstance()
        .putData(BigDataConstants.INSERT_EXTERNAL_STORAGE_COUNT, this.insertExternalStorageCount);
    }
    DataStoreUtil.getInstance().flush();
  }

  private async removeExternalStorageCountReport(): Promise<void> {
    this.removeExternalStorageCount++;
    if (nowOverOneDay(this.removeExternalStorageCountReportTime)) {
      externalStorageStatusBaseReport(BigDataConstants.REMOVE_EXTERNAL_STORAGE_COUNT, this.removeExternalStorageCount)
        .then((x) => {
          this.removeExternalStorageCountReportTime = x;
        });
      this.removeExternalStorageCount = 0;
      DataStoreUtil.getInstance().putData(BigDataConstants.REMOVE_EXTERNAL_STORAGE_COUNT, 0);
      DataStoreUtil.getInstance()
        .putData(BigDataConstants.REMOVE_EXTERNAL_STORAGE_TIME, this.removeExternalStorageCountReportTime);
    } else {
      DataStoreUtil.getInstance()
        .putData(BigDataConstants.REMOVE_EXTERNAL_STORAGE_COUNT, this.removeExternalStorageCount);
    }
    DataStoreUtil.getInstance().flush();
  }

  private subscribeStorageDeviceChangeCallback = (error: BusinessError,
    commonEventData: CommonEventManager.CommonEventData): void => {
    if (error) {
      Log.info(TAG, `subscribeStorageDeviceChangeCallback error: ${error?.message}`);
      return;
    }
    let fsUuid: string = '';
    switch (commonEventData?.event) {
      case CommonEventManager.Support.COMMON_EVENT_VOLUME_MOUNTED:
        fsUuid = commonEventData.parameters?.['fsUuid'] ?? '';
        DataStoreUtil.getInstance().delData(fsUuid);
        /* instrument ignore next */
        if (DeviceInfo.isTablet()) {
          this.cardNameUris.push(fsUuid);
        }
        getContext()?.eventHub.emit(BroadCastConstants.EXTERNAL_STORAGE_SHOW, fsUuid);
        // 插入打点
        this.insertExternalStorageCountReport();
        break;
      case CommonEventManager.Support.COMMON_EVENT_VOLUME_UNMOUNTED:
        fsUuid = commonEventData.parameters?.['fsUuid'] ?? '';
        DataStoreUtil.getInstance().delData(fsUuid);
        getContext()?.eventHub.emit(BroadCastConstants.EXTERNAL_STORAGE_NOT_SHOW, fsUuid);
        /* instrument ignore next */
        if (DeviceInfo.isTablet()) {
          this.cardNameUris = this.cardNameUris?.filter(item => item !== fsUuid);
        }
        // 移除打点
        this.removeExternalStorageCountReport();
        break;
      default:
        break;
    }
  }

  private async loadTabPage(index: number): Promise<void> {
    Log.info(TAG, `loadTabPage start page: ${index}, isShowPhotoGridView =
      ${AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW)}, isGRL = ${DeviceInfo.isGRLFoldScreen()}`);
    try {
      if (index === Constants.TIMELINE_PAGE_INDEX) {
        let obj = await import('./TimelinePageLoader');
        this.timelinePageLoader = obj.TimelinePageLoader;
        this.isTimelineLoaded = true;
      } else if (index === Constants.ALBUM_PAGE_INDEX) {
        if (!(DeviceInfo.isGRLFoldScreen() && AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW))) {
          this.resetAlbumSetPageDefaultParams();
        }
        let obj = await import('./TabContentComponent');
        this.tabContentComponentLoader = obj.TabContentComponentLoader;
        this.isTabContentLoaded = true;
      } else {
        Log.debug(TAG, `other tab page, index is ${index}`);
      }
    } catch (error) {
      Log.error(TAG, 'loadTabPage failed!');
    }
  }

  private async loadAlbumPhotoView(): Promise<void> {
    if (this.isPhoneUx) {
      return;
    }
    try {
      let obj = await import('./AlbumPhotoView');
      this.albumPhotoViewLoader = obj.AlbumPhotoViewLoader;
      this.isAlbumPhotoViewLoaded = true;
    } catch (error) {
      Log.error(TAG, 'loadAlbumPhotoView failed!');
    }
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      ScreenManager.getInstance().recoverHorizontalStatusBar(this.isHorizontal);
    }
    Log.info(TAG, `isVdeFoldable ${this.isVerdeFoldable}`);
  }

  private onWinSizeChangedInner(): void {
    this.updatePhoneUx();
  }

  private isAccessedFullGuide(): boolean {
    let isAccessCloudPage: boolean = true;
    if (!DeviceInfo.isPc()) {
      let isCloudPageTmp: boolean = Protocol.get<boolean>(Constants.FULL_SCREEN_GUIDE, false);
      isAccessCloudPage = isCloudPageTmp;
    }
    return isAccessCloudPage;
  }

  private isEnterFullGuide(isAccessFullGuide: boolean,
    isCloudLogIn: boolean | undefined, isCloudSync: boolean | undefined):
    boolean {
    if (isAccessFullGuide) {
      Log.info(TAG, 'Have Entered Full Guide Page');
      return false;
    }
    // 未登录账号 不弹
    if (!isCloudLogIn) {
      Log.info(TAG, 'FULL GUIDE NOT LOG IN');
      return false;
    }
    // 登录账号 开启云同步
    if (isCloudLogIn && isCloudSync) {
      Log.info(TAG, 'FULL GUIDE LOG IN AND OPEN CLOUD SYNC');
      return false;
    }
    // 登录账号 未开启云同步
    if (isCloudLogIn && !isCloudSync) {
      Log.info(TAG, 'FULL GUIDE LOG IN AND NOT OPEN CLOUD SYNC');
      return true;
    }
    // 兜底返回false，不显示全屏引导页
    return false;
  }

  private judgeEnterFullGuidePage(): void {
    // xxx无需进入引导页
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      return;
    }
    let isAccessFullGuide: boolean = this.isAccessedFullGuide();
    if (!isAccessFullGuide) {
      if (this.isEnterFullGuide(isAccessFullGuide, this.isLogIn, false)) {
        Log.info(TAG, 'enter FullGuidePage');
        try {
          this.getUIContext().getRouter().replaceUrl({
            url: 'MainAbility/view/FullGuidePage',
          });
        } catch (err) {
          Log.error(TAG, `index enter fullGuidePage ${err}, code: ${err?.code}`);
        }
      }
    }
  }

  private judgeEnterSettingPage(): void {
    if (AppStorage.get<boolean>('enterSettingPage')) {
      Log.info(TAG, 'index from FullGuidePage Enter Setting Page');
      AppStorage.setOrCreate('enterSettingPage', false);
      NavigationBroadCastManager.getInstance()
        .targetName = NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS;
      AppStorage.setOrCreate('openCloudSync', true);
      this.navigationBroadCast.emitAsync(
        NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS]).then(() => {
        this.navigationPageInfos
          .pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS, null));
      });
    }
  }

  onPageShow(): void {
    Log.info(TAG, `[onPageShow] entryFromHap: ${this.entryFromHap}`);
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
    getContext().eventHub.emit(BroadCastConstants.ON_PAGE_SHOW, `${TAG} onPageShow()`);
    if (this.entryFromHap === Constants.ENTRY_FROM_NONE && lockedScreenMgr().isFromLockedScreen) {
      lockedScreenMgr().onExit(true, true, TAG, 'ENTRY_FROM_NONE');
    }
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    AppStorage.setOrCreate<boolean>('pageShowFlag', true);
    setTimeout((): void => {
      this.isShow = true;
    }, 50);
    let param: Params = tryGetRouterParam() as Params;
    if (param) {
      this.jumpSource = param.jumpSource;
      Log.info(TAG, `jumpSource is ${param.jumpSource}`);
    }
    Log.info(TAG, `router clear ${this.jumpSource}, routerLength=${router.getLength}`);
    if (this.jumpSource === JumpSourceToMain.CAMERA) {
      getScreen().recoverDefaultStatusBar();
    } else if (this.jumpSource === JumpSourceToMain.ALBUM) {
      AppStorage.get<Router>('router')?.clear();
      // To help AlbumSetPage show copy or move dialog
      if (AppStorage.get<boolean>(Constants.IS_SHOW_MOVE_COPY_DIALOG)) {
        this.appBroadCast.emit(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, [this.currentIndex]);
        AppStorage.setOrCreate(Constants.IS_SHOW_MOVE_COPY_DIALOG, false);
      }
    } else if (this.jumpSource === JumpSourceToMain.SETTINGS) {
      AppStorage.get<Router>('router')?.clear();
      if (AppStorage.get<boolean>(Constants.IS_SHOW_SETTINGS_PAGE)) {
        NavigationBroadCastManager.getInstance()
          .targetName = NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS;
        this.navigationBroadCast.emitAsync(
          NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS]).then(() => {
          this.navigationPageInfos
            .pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS, param?.componentId));
        });

        AppStorage.setOrCreate(Constants.IS_SHOW_SETTINGS_PAGE, false);
      }
    }
    this.pageStatus = true;
    TraceControllerUtils.finishTrace('indexPageAppearToShow');
    this.focusCtrlManager.setTabIndex(this.currentIndex);
    if (this.isShowFinishToast) {
      this.isShowFinishToast = false;
    }
  }

  onPageHide(): void {
    Log.info(TAG, '[onPageHide]');
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
    this.getUIContext().getHostContext()?.eventHub.emit(BroadCastConstants.ON_PAGE_HIDE, `${TAG} onPageHide()`);
    this.pageStatus = false;
    this.appBroadCast.emit(BroadCastConstants.CAST_MANAGER_STOP_ABILITY, [true]);
    this.appBroadCast.emit(BroadCastConstants.STOP_TIMELINE_READY_PROGRESS, []);
    setTimeout((): void => {
      this.isShow = false;
    }, 50);
  }

  differentViewBack(): boolean {
    if (this.isShowPhotoGridView || this.isShowPhotoHiddenView || this.isShowHiddenGridView ||
    this.isShowPhotoClassifieds || this.isShowPhotoShooting || this.isShowPortraitAlbumsView) {
      this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT, []);
      return true;
    } else {
      if (this.isAlbumSetSelectedMode) {
        this.isAlbumSetSelectedMode = !this.isAlbumSetSelectedMode;
        return true;
      } else {
        return false;
      }
    }
  }

  onBackPress(): boolean {
    Log.info(TAG, `onBackPress showBrowser: ${this.isShowPhotoBrowser},` +
      ` showSelectBrowser: ${this.isShowSelectPhotoBrowser},` +
      ` currentIndex: ${this.currentIndex}, showGrid: ${this.isShowPhotoGridView},` +
      ` isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}, isPullingDown: ${this.isPullingDown},` +
      ` isPullingUp: ${this.isPullingUp} isShowOrHideBar: ${this.isShowOrHideBar}`);
    if (DeviceInfo.isGRLFoldScreen() && !this.isShowPhotoBrowser && !this.isSelectedMode) {
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CATEGORY_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
    }

    if (this.isPullingDown && this.isRunningAnimation || this.isClickRemoveOrHiddenDialog) {
      Log.info(TAG, 'Not allow to onBackpress when isRunningAnimation and pullingDown or isClickRemoveOrHiddenDialog');
      return true;
    }
    if (this.isShowPhotoBrowser) {
      Log.info(TAG, `onBackPress:${this.currentIndex} ${this.isHorizontal}`);
      if (this.whetherToHide && this.currentIndex === 0 && this.isHorizontal) {
        this.currentTabBarHeight = 0;
      }
      if (this.isPullingUp || this.isShowOrHideBar) {
        this.doPhotoBrowserViewBack();
        this.isShowOrHideBar = false;
        return true;
      }
      this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_CENTER, []);
      this.doPhotoBrowserViewBack();
      return true;

    }
    if (this.isShowSelectPhotoBrowser) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }
    if (this.currentIndex === Constants.ALBUM_PAGE_INDEX) {
      const processed: boolean = this.differentViewBack();
      if (processed) {
        return true;
      }
    }
    if ((DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) && this.isShowSearchPage) {
      this.isShowSearchPage = false;
      if (DeviceInfo.isGRLFoldScreen()) {
        LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_KEEP_SEARCH);
      }
      this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
      return true;
    }

    // 当显示隐藏相册二级宫格时，返回到隐藏相册一级宫格
    if (this.isShowHiddenGridView && (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))) {
      Log.info(TAG, `onBackPress isShowHiddenGridView = ${this.isShowHiddenGridView}`);
      this.appBroadCast.emit(BroadCastConstants.HIDDEN_GRID_VIEW_BACK_PAD_AND_PC);
      return true;
    }

    // 当显示隐藏相册，且没有显示隐藏相册二级宫格（上面的if已经判断，所以这里不用再需要判断）时，返回到图片与视频相册宫格
    if (this.isShowPhotoHiddenView && (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))) {
      Log.info(TAG, `onBackPress isShowPhotoHiddenView = ${this.isShowPhotoHiddenView}`);
      getContext()?.eventHub.emit(BroadCastConstants.BACK_TO_FIRST_ALBUM_PAD_AND_PC);
      return true;
    }

    let isProcessed: boolean = false;

    if (!this.isShowHiddenGridView) {
      this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT,
        [(isModeChanged: boolean): void => {
          isProcessed = isModeChanged;
        }]);
      if (AccessibilityUtil.isOpenTouchGuideSync()) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_MULTI_SELECT);
      }
    }
    let helper: EventHelper<string> | undefined =
      StorageUtils.get<EventHelper<string>>(this.getUIContext(),
        Constants.LOCAL_KEY_INDEX_BACK_PRESS_EVENT_HELPER, new EventHelper<string>());
    if (!isProcessed && helper) {
      isProcessed = helper.process('');
    }
    return isProcessed;
  }

  doSelectPhotoBrowserViewBack(): void {
    this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  doPhotoBrowserViewBack(): void {
    this.browserController.onBackPress();
  }

  @BuilderParam photoBrowserViewLoader: ($$: PhotoBrowserViewLoaderParams) => void;
  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;
  @BuilderParam tabContentComponentLoader: ($$: TabContentComponentLoaderParams) => void;
  @BuilderParam albumPhotoViewLoader: ($$: AlbumPhotoViewLoaderParams) => void;
  @BuilderParam timelinePageLoader: ($$: TimelinePageLoaderParams) => void;
  private isNavigationToOtherPage: boolean = false;

  // ESC特殊场景屏蔽
  private checkEscRecoverWindowScene(): boolean {
    return getScreen().getIsFullScreen() && !this.browserController.isBrowserShow &&
      !this.browserController.isAnimating && !this.browserController.isSelectedMode &&
      !this.isShowHiddenGridView && !this.isShowPhotoHiddenView && !getScreen().isInImmersivePage;
  }

  //左侧侧边栏区 + 右侧内容区
  @Builder
  SideBarPanelBuilder() {
    SideBarContainer(SideBarContainerType.Embed) {
      SideBar({
        pageStatus: this.pageStatus,
        isShowSearchPage: this.isShowSearchPage,
        isSearchBarFocused: this.isSearchBarFocused,
        isShowTimelinePage: this.isShowTimelinePage,
        isShowPhotoHiddenView: this.isShowPhotoHiddenView,
        isShowPhotoClassifieds: this.isShowPhotoClassifieds,
        isShowPortraitAlbumsView: this.isShowPortraitAlbumsView,
        isShowPhotoShooting: this.isShowPhotoShooting,
        sideBarItemClickListener: this.sideBarItemClickListener,
        photoSearchWord: this.photoSearchWord,
        displaySearchWords: this.displaySearchWords,
        searchHistoryClearOnSubmit: this.searchHistoryClearOnSubmit,
        photoHistoryWordClicked: this.photoHistoryWordClicked,
        isShowHiddenGridView: this.isShowHiddenGridView,
        navigationPageInfos: this.navigationPageInfos,
        navigationBroadCast: this.navigationBroadCast,
        searchKeyword: this.searchKeyword,
        isShowHighlightView: this.isShowHighlightView,
        sideBarWidth: this.sideBarWidth
      })
        .padding({
          top: ((DeviceInfo.isTablet() && !this.windowPcmodeSwitchStatus) ||
          FoldUtil.isTriExpand(this.curFoldStatus)) ? px2vp(this.statusBarHeight) : 0,
        })
        .backgroundColor($r('sys.color.background_secondary'))
        .onAreaChange((oldValue: Area, newValue: Area) => {
          ActionBarVar.sideBarWidth = Number(newValue.width);
          this.sideBarWidth = ActionBarVar.sideBarWidth;
          this.appBroadCast.emit(BroadCastConstants.ON_SIDEBAR_WIDTH_CHANGED, []);
        })

      Column() {
        this.ContentPanelBuilder()
      }
      .width('100%')
      .height('100%')
    }
    .showControlButton(false)
    .showSideBar(this.isShowSideBar)
    .divider({ strokeWidth: this.strokeWidth })
    .width('100%')
    .height('100%')
    .flexGrow(1)
    .onAppear((): void => {
      this.strokeWidth = '1vp';
    })
  }
  // 相册照片视图加载器
  @Builder
  AlbumPhotoViewLoader() {
    this.albumPhotoViewLoader({
      pageStatus: this.pageStatus,
      isShowPhotoBrowser: this.isShowPhotoBrowser,
      currentTabBarHeight: this.currentTabBarHeight,
      isSelectedModeIndex: this.isSelectedModeIndex,
      tabsPaddingBottom: this.tabsPaddingBottom,
      initTabsPaddingBottom: this.initTabsPaddingBottom,
      isShowHiddenGridView: this.isShowHiddenGridView,
      isShowSearchPage: this.isShowSearchPage,
      isSelectedMode: this.isSelectedMode,
      isShowTabAndSegmentButton: this.isShowTabAndSegmentButton,
      navigationPageInfos: this.navigationPageInfos,
      sideBarWidth: this.sideBarWidth,
      isShowSdCardTip: this.isShowSdCardTip,
      cardNameUris: this.cardNameUris,
      gridInitConfigSyncer: this.gridInitConfigSyncer,
      isConfigReady: this.isConfigReady,
    })
  }

  //右侧内容区
  @Builder
  ContentPanelBuilder() {
    if (this.isAlbumPhotoViewLoaded && !this.isShowHighlightView) {
      this.AlbumPhotoViewLoader()
    }
  }
  /*
    @Builder
    HDSSideBarBuilder() {
      HdsSideBar({
        sideBarPanelBuilder: (): void => {
          this.SideBarPanelBuilder()
        },
        contentPanelBuilder: (): void => {
          this.ContentPanelBuilder()
        },
        autoHide: true,
        contentAreaMask: false,
        sideBarContainerType: SideBarContainerType.Embed,
        isShowSideBar: this.isShowSideBar,
        sideBarWidth: $r('app.float.action_bar_view_width'),
        minSideBarWidth: $r('app.float.action_bar_view_min_width'),
        maxSideBarWidth: $r('app.float.action_bar_view_max_width'),
        onChange: (isEmbed: boolean) => {
          Log.info(TAG, `bar status:${isEmbed}`);
          this.isShowSideBar = isEmbed;
          ActionBarVar.isShowSideBar = isEmbed;
          this.appBroadCast.emit(BroadCastConstants.ON_SIDEBAR_CHANGED, [this.isShowSideBar]);
          let sideBarViewModel: SideBarViewModel | undefined =
            LocalStorage.getShared()?.get<SideBarViewModel>(SideBarViewModel.STORAGE_KEY);
          if (sideBarViewModel) {
            sideBarViewModel.status = this.isShowSideBar;
          }
        },
      })
    }
  */

  build() {
    Navigation(this.navigationPageInfos) {
      Stack({ alignContent: Alignment.BottomStart }) {
        if (this.entryFromHap === Constants.ENTRY_FROM_NONE && !lockedScreenMgr().isFromLockedScreen) {
          if (this.isPhoneUx) {
            Tabs({
              barPosition: BarPosition.End,
              index: this.currentIndex,
              controller: this.tabsController,
            }) {
              TabContent() {
                if (this.isTimelineLoaded) {
                  this.timelinePageLoader({
                    isShowPhotoBrowser: this.isShowPhotoBrowser,
                    isInCurrentTab: this.currentIndex === Constants.TIMELINE_PAGE_INDEX,
                    currentTabBarHeight: this.currentTabBarHeight,
                    isSelectedModeIndex: this.isSelectedModeIndex,
                    tabsPaddingBottom: this.tabsPaddingBottom,
                    initTabsPaddingBottom: this.initTabsPaddingBottom,
                    pageStatus: this.pageStatus,
                    isShowSearchPage: this.isShowSearchPage,
                    isShowGallerySettingBasePage: this.isShowGallerySettingBasePage,
                    isShowAboutGalleryPage: this.isShowAboutGalleryPage,
                    isShowTabAndSegmentButton: this.isShowTabAndSegmentButton,
                    sideBarWidth: this.sideBarWidth,
                    isShowSdCardTip: this.isShowSdCardTip,
                    cardNameUris: this.cardNameUris,
                    isChangeByClickTab: this.isChangeByClickTab,
                    navPathStack: this.navigationPageInfos,
                    isShowTabBar: this.isShowTabBar,
                    gridInitConfigSyncer: this.gridInitConfigSyncer,
                    isConfigReady: this.isConfigReady,
                  })
                }
              }.tabBar(new BottomTabBarStyle({
                normal: this.symbolModifier,
                selected: this.symbolModifierHighlighting,
              }, $r('app.string.tab_timeline'))
                .padding({
                  bottom: this.isVerdeFoldable ? 0 : this.tabsPaddingBottom,
                })
                .layoutMode((this.isHorizontal && !DeviceInfo.isFoldable()) && !this.isVerdeFoldable
                  ? LayoutMode.HORIZONTAL : LayoutMode.VERTICAL).id('TabPhotos')
              )

              TabContent() {
                if (this.isTabContentLoaded) {
                  this.tabContentComponentLoader({
                    currentIndex: this.currentIndex,
                    isShowPhotoBrowser: this.isShowPhotoBrowser,
                    isShowSelectPhotoBrowser: this.isShowSelectPhotoBrowser,
                    pageStatus: this.pageStatus,
                    isShowHiddenGridView: this.isShowHiddenGridView,
                    isShowTabAndSegmentButton: this.isShowTabAndSegmentButton,
                    navigationPageInfos: this.navigationPageInfos,
                  });
                }
              }.tabBar(new BottomTabBarStyle({
                normal: this.symbolModifierAlbum,
                selected: this.symbolModifierAlbumHighlighting,
              }, $r('app.string.tab_albums'))
                .padding({
                  bottom: this.isVerdeFoldable ? 0 : this.tabsPaddingBottom,
                })
                .layoutMode((this.isHorizontal && !DeviceInfo.isFoldable()) && !this.isVerdeFoldable
                  ? LayoutMode.HORIZONTAL : LayoutMode.VERTICAL).id('TabAlbums')
              )
            }
            .accessibilityLevel('no')
            .enabled(this.browserController.enableClick)
            .animationDuration(0)
            .vertical(false)
            .barOverlap(true)
            .barBackgroundColor(UiUtil.isLiteDeviceUI() ?
              $r('sys.color.comp_background_gray') : Color.Transparent)
            .barBackgroundBlurStyle(UiUtil.isLiteDeviceUI() ? BlurStyle.NONE : BlurStyle.COMPONENT_THICK)
            .scrollable(false)
            .barMode(BarMode.Fixed)
            .barHeight(this.isShowTabBar &&
              ((DeviceInfo.isPhoneUx()) || (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))
                || DeviceInfo.isFoldable()) ? this.currentTabBarHeight : 0)
            .flexGrow(1)
            .onChange((index: number) => {
              AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_ID, '');
              AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, '');
              this.resetTabState(this.currentIndex);
              this.onTabChanged(index);
              this.focusCtrlManager.setTabIndex(this.currentIndex);
              Log.info(TAG, `Switch to Tab ${this.currentIndex}.`);
            })
            .onTabBarClick((index: number) => {
              Log.info(TAG, `TabBar has Clicked ${index} ${this.currentIndex} ${this.isShowTabAndSegmentButton}`);
              if (index === this.currentIndex) {
                // 暂时禁用快捷回顶部，暂时不要修改
                return;
              }
              // 其他页面横屏状态时切换到照片页需要主动触发分段按钮的显示, 冷起到相册页再横屏，然后切换到照片页不会触发广播接收
              if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx() && !(DeviceInfo.isTablet() ||
              FoldUtil.isTriExpand(this.curFoldStatus)) && index === Constants.TIMELINE_PAGE_INDEX &&
              this.isShowTabAndSegmentButton) {
                this.isChangeByClickTab = true;
                this.appBroadCast.emit(BroadCastConstants.IS_SHOW_SEGMENT, [index]);
              }
              // 竖屏非照片页进入横屏，再切到照片页显示tabBar
              if (index === Constants.TIMELINE_PAGE_INDEX && this.preIndex !== Constants.TIMELINE_PAGE_INDEX &&
                !this.isShowTabAndSegmentButton && this.isHorizontal &&
                !(DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) &&
                !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
                this.isShowTabAndSegmentButton = true;
                return;
              }
              // 竖屏非照片页进入横屏，再切到照片页不显示tabBar
              if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx() && this.isHorizontal &&
                index === Constants.TIMELINE_PAGE_INDEX && !this.isShowPhotoBrowser &&
                !this.isShowTabAndSegmentButton && !(DeviceInfo.isTablet() ||
              FoldUtil.isTriExpand(this.curFoldStatus))) {
                this.isShowTabBarByHotZone();
              }
            })
            .visibility(this.isPageHidden)
          } else {
            Stack({ alignContent: Alignment.TopStart }) {
              this.SideBarPanelBuilder()
              if (this.isShowSideBar || !(this.isSelectedMode || this.isAlbumSetSelectedMode)) {
                this.sideBarButton();
              }
            }
            .width('100%')
            .height('100%')
            .flexGrow(1)
            .visibility(this.isPageHidden)
          }

          if (this.isShowPhotoBrowser && this.isBrowserLoaded) {
            Column() {
              this.photoBrowserViewLoader({
                isShowBar: true,
                pageStatus: this.pageStatus,
                hidePhotoBrowser: (isPlayAni: boolean, index: number): void => {
                  // todo lishang 接口需要更新，index改为返回实际index
                  this.browserController.hideBrowser(index)
                },
                isRunningAnimation: this.isRunningAnimation,
                isShowMenu: true,
                canPullingUp: true,
                isShowThumbSource: true,
                isShowImageAnalyzer: true,
                reportStartTime: 0,
                onDeleteAllPhoto: (): void => {
                }
              })
            }
            .width('100%')
            .height('100%')

            // Opacity must change for TransitionEffect taking effect
            .transition(TransitionEffect.opacity(0.99))
            .id(this.geometryReuseId)
          }

          if (this.isShowSelectPhotoBrowser) {
            Column() {
              this.selectPhotoBrowserLoader({
                pageStatus: this.pageStatus,
                geometryTransitionEnable: this.browserController.geometryTransitionEnable,
                isRunningAnimation: this.isRunningAnimation
              });
            }
            .width('100%')
            .height('100%')

            // Opacity must change for TransitionEffect taking effect
            .transition(TransitionEffect.opacity(0.99))
            .id(this.geometryReuseId)
          }

          // 显示点击热区
          if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx() &&
            !(DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) && this.isHorizontal &&
            this.currentIndex === Constants.TIMELINE_PAGE_INDEX && !this.isShowPhotoBrowser &&
            !this.isShowTabAndSegmentButton) {
            this.HotZone();
          }
        }
      }
      .alignContent(Alignment.BottomStart)
      .flexGrow(1)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({
        top: this.leftBlank[1],
        bottom: this.leftBlank[3],
      })
    }
    .key(PageTitle.index)
    .navDestination(this.PageMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .onKeyEvent((event: KeyEvent) => {
      Log.info(TAG, `phone index onKeyEvent keyCode: ${event.keyCode} type: ${event.type}`);
      if (DeviceInfo.isPcOrTablet()) {
        LocalStorage.getShared()?.setOrCreate<boolean>('isKeyEvent', true);
      }
      this.shortcutController.listen(event);
      if (event.type === KeyType.Down) {
        if (event.keyCode === KeyCode.KEYCODE_CTRL_LEFT || event.keyCode === KeyCode.KEYCODE_CTRL_RIGHT) {
          Log.info(TAG, 'index keyboardShortcut ctrl');
          AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_CTRL_PRESS, true);
        }
        if (event.keyCode === KeyCode.KEYCODE_SHIFT_LEFT || event.keyCode === KeyCode.KEYCODE_SHIFT_RIGHT) {
          Log.info(TAG, 'index keyboardShortcut shift');
          AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS, true);
        }
        // if (event.keyCode === KeyCode.KEYCODE_ESCAPE && this.checkEscRecoverWindowScene()) {
        //   Log.info(TAG, 'index escape maxOrRecoverWindows');
        //   WindowUtil?.maxOrRecoverWindows(getContext(this), true);
        // }
        if (event.keyCode === KeyCode.KEYCODE_ESCAPE) {
          Log.info(TAG, 'index keyboardShortcut Escape');
          this.appBroadCast.emit(BroadCastConstants.BACK_EVENTS, []);
        }

        let isCtrlPress = AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS);
        let isShiftPress = AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS);
        if (isCtrlPress && isShiftPress) {
          Log.info(TAG, `Ctrl + Shift`)
        } else if (isCtrlPress) {
          if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_A) {
            Log.info(TAG, 'index keyboardShortcut ctrl + a');
            this.appBroadCast.emit(BroadCastConstants.SELECT_ALL, []);
          } else if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_C) {
            Log.info(TAG, 'index keyboardShortcut ctrl + c');
            this.appBroadCast.emit(BroadCastConstants.COPY_MEDIA, []);
          } else if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_V) {
            Log.info(TAG, 'index keyboardShortcut ctrl + v');
            this.appBroadCast.emit(BroadCastConstants.PASTE_MEDIA, []);
          } else if (event.keyCode === MultimodalInputManager.KEY_CODE_P) {
            Log.info(TAG, 'index keyboardShortcut ctrl + p');
            // 优先处理宫格多选打印（SelectManager 由宫格写入 AppStorage）
            let selectManager: SelectManager | undefined =
              AppStorage.get<SelectManager>(Constants.PHOTO_GRID_SELECT_MANAGER);
            if (selectManager && selectManager.getSelectedCount() > 0) {
              menuOption(Action.PRINT.actionID, selectManager, this.appBroadCast);
              return;
            }
          }
        }

        if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_DELETE) {
          Log.info(TAG, 'index keyboardShortcut del.');
          this.appBroadCast.emit(BroadCastConstants.DELETE_MEDIA, []);
        }
      }
      if (!this.navBarStateFlag) {
        return;
      }
      if (event.type === KeyType.Down) {
        if (!this.firstKey) {
          this.firstKey = event.keyCode;
        }
        if (event.keyCode == MultimodalInputManager.keyCodeAltLeft ||
          event.keyCode == MultimodalInputManager.keyCodeAltRight ||
          event.keyCode == MultimodalInputManager.keyCodeMetaLeft) {
          this.firstKey = null;
        }
      }
      if (event.type == KeyType.Up) {
        if (event.keyCode == this.firstKey) {
          this.firstKey = null;
        }
        if (AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS) &&
          event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_C) {
          this.appBroadCast.emit(BroadCastConstants.COPY_BROWSER_MEDIA, []);
        }
        if (this.firstKey && event.keyCode) {
          this.appBroadCast.emit(BroadCastConstants.SHORTCUT_KEY_COMPOSE, [this.firstKey, event.keyCode]);
        }
        if (event.keyCode === KeyCode.KEYCODE_CTRL_LEFT || event.keyCode === KeyCode.KEYCODE_CTRL_RIGHT) {
          AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_CTRL_PRESS, false);
        }
        if (event.keyCode === KeyCode.KEYCODE_SHIFT_LEFT || event.keyCode === KeyCode.KEYCODE_SHIFT_RIGHT) {
          AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS, false);
        }
      }
      if (DeviceInfo.isTablet() && (event.type == Number(-1) || event.type == KeyType.Up)) {
        Log.info(TAG, `phone index on key event Up, isKeyEvent = false`);
        LocalStorage.getShared()?.setOrCreate<boolean>('isKeyEvent', false);
      }
    })
    .keyboardShortcut('d', [ModifierKey.CTRL], (): void => {
      Log.info(TAG, 'index keyboardShortcut ctrl + d.');
      this.appBroadCast.emit(BroadCastConstants.DELETE_MEDIA, []);
    })
    .onNavBarStateChange((isVisible: boolean) => {
      let targetName = NavigationBroadCastManager.getInstance().targetName;
      this.isNavigationToOtherPage = !isVisible;
      Log.info(TAG, `onNavBarStateChange = ${isVisible}, targetName= ${targetName}`);
      this.navBarStateFlag = isVisible;
      if (isVisible) {
        this.isShowGallerySettingBasePage = false;
        this.isShowAboutGalleryPage = false;
        NavigationBroadCastManager.getInstance().targetName = '';
        return;
      }
      if (targetName == NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS) {
        this.isShowGallerySettingBasePage = true;
        return;
      }
      if (targetName == NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY) {
        this.isShowAboutGalleryPage = true;
      }
    })
  }

  @Builder
  HotZone() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
      }
      .width((ScreenManager.getInstance().getWinWidth() - ScreenManager.getInstance().getAiBarWidth()) / 2)
      .height(Constants.PERCENT_100)
      .gesture(
        TapGesture({ count: 1, fingers: 1 })
          .onAction((): void => {
            this.isShowTabAndSegmentButton = true;
          })
      )

      Column() {
      }
      .width((ScreenManager.getInstance().getWinWidth() - ScreenManager.getInstance().getAiBarWidth()) / 2)
      .height(Constants.PERCENT_100)
      .gesture(
        TapGesture({ count: 1, fingers: 1 })
          .onAction((): void => {
            this.isShowTabAndSegmentButton = true;
          })
      )
    }
    .width(Constants.PERCENT_100)
    .height(ScreenManager.getInstance().getAiBarHeight())
    .position({ x: 0, y: ScreenManager.getInstance().getWinHeight() - ScreenManager.getInstance().getAiBarHeight() })
  }

  // 动态加载页面：用于承接import异步导入的loader
  @BuilderParam navigationPageLoader: () => void;
  @BuilderParam albumCoverSelectPageLoader: ($$: AlbumCoverSelectLoaderParams) => void;
  @BuilderParam albumCoverPreviewPageLoader: ($$: AlbumCoverPreviewLoaderParams) => void;
  @BuilderParam collagePageLoader: () => void;
  @BuilderParam moviePageLoader: () => void;
  @BuilderParam pickerBasePageLoader: ($$: PickerBasePageParams) => void;
  @BuilderParam wallpaperEditorLoader: ($$: WallpaperEditorLoaderParams) => void;
  @BuilderParam slideShowPageLoader: ($$: SlideShowLoaderParams) => void;
  @BuilderParam addPeoplePageLoader: ($$: AddPeopleTagLoaderParams) => void;
  @BuilderParam groupPageLoader: ($$: AddPeopleTagLoaderParams) => void;

  @Builder
  PageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION ||
      name === NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS ||
      name === NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY ||
      name === NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW ||
      name === NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE ||
      name === NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES ||
      name === NavigationConstants.NAVIGATION_DESTINATION_STATEMENTS_CARDS ||
      name === NavigationConstants.NAVIGATION_DESTINATION_SERVICE_AGREEMENTS_CARDS ||
      name === NavigationConstants.NAVIGATION_PRIVACY_VIEWER ||
      name === NavigationConstants.NAVIGATION_SMART_ALBUM_GRID_PAGE ||
      name === NavigationConstants.NAVIGATION_GROUP_PAGE) {
      if (this.navigationPageLoader) {
        this.navigationPageLoader();
      }
    } else {
      this.PageMapContinue(name, param);
    }
  }

  @Builder
  PageMapContinue(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_MOVIE_PAGE) {
      this.moviePageLoader();
    } else if (name === NavigationConstants.NAVIGATION_WALLPAPER_EDITOR) {
      this.wallpaperEditorLoader({
        navPageInfos: this.navigationPageInfos,
      });
    } else if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
      this.pickerBasePageLoader({
        params: param as SelectParams,
        navPageInfos: this.navigationPageInfos,
      });
    } else if (name === NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE) {
      this.slideShowPageLoader({
        navigationPageInfos: this.navigationPageInfos,
      });
    }
  }

  pageTransition() {
    PageTransitionEnter({
      duration: 0,
      curve: Curve.FastOutSlowIn,
    })
      .opacity(0)
    if (this.isFaCardExitTransition) {
      PageTransitionExit({
        type: RouteType.Push,
        duration: 300,
      })
        .opacity(1)
    } else {
      PageTransitionExit({ duration: 0, curve: Curve.FastOutSlowIn })
        .opacity(0)
    }
  }

  private updateColorMode(): void {
    this.colorMode = ImmersiveController.isInImmersive ? ActionBarColorMode.TRANSPARENT : ActionBarColorMode.NORMAL;
  }

  @Builder
  sideBarButton() {
    Button({ type: ButtonType.Circle }) {
      SymbolGlyph(this.isShowSideBar ? $r('sys.symbol.open_sidebar') :
        $r('sys.symbol.close_sidebar'))
        .fontSize($r('app.float.icon_size'))
        .fontColor([this.colorMode && !this.isShowSideBar && !this.isShowSearchPage ?
          Action.ICON_DEFAULT_COLOR_CONTRARY : $r('sys.color.icon_primary')])
        .draggable(false)
    }
    .backgroundColor(this.colorMode && !this.isShowSideBar && !this.isShowSearchPage ?
      ImmersiveController.bottomColumnBgColor : $r('sys.color.comp_background_tertiary'))
    .backgroundBlurStyle(this.colorMode && !this.isShowSideBar && !this.isShowSearchPage ?
      BlurStyle.COMPONENT_ULTRA_THIN : BlurStyle.NONE)
    .borderRadius($r('sys.float.corner_radius_level4'))
    .height($r('app.float.action_bar_button_height'))
    .width($r('app.float.action_bar_button_height'))
    .id(Constants.COMPONENT_KEY_SIDE_BUTTON)
    .position({
      x: this.isRTL ? getScreen().getWinWidth() - this.getSidebuttonMarginL() - 40 : this.getSidebuttonMarginL(),
      y: this.windowPcmodeSwitchStatus ? 8 : px2vp(this.statusBarHeight) + 8,
    })
    // .focusable(!this.browserController.isBrowserShow)
    .draggable(false)
    .accessibilityText(this.isShowSideBar ? $r('app.string.show_less') : $r('app.string.expand'))
    .onClick((event: ClickEvent): void => {
      Log.info(TAG, `SidebarButton onClick isInImmersive: ${ImmersiveController.isInImmersive}`);
      this.updateColorMode();
      animateTo({
        duration: 500,
        curve: curves.interpolatingSpring(0, 1, 400, 38),
      }, () => {
        this.isShowSideBar = !this.isShowSideBar;
        ActionBarVar.isShowSideBar = this.isShowSideBar;
        this.appBroadCast.emit(BroadCastConstants.ON_SIDEBAR_CHANGED, [this.isShowSideBar]);
        if (DeviceInfo.isGRLFoldScreen()) {
          if (this.isShowSideBar) {
            LocalStorage.getShared()?.setOrCreate<number>(Constants.APP_KEY_GRL_IS_SHOW_SIDEBAR, SHOW_SIDEBAR);
          } else {
            LocalStorage.getShared()?.setOrCreate<number>(Constants.APP_KEY_GRL_IS_SHOW_SIDEBAR, HIDE_SIDEBAR);
          }
        }
        if (AccessibilityUtil.isOpenTouchGuideSync()) {
          AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_SIDE_BUTTON);
        }
      })
    })
  }

  private getSidebuttonMarginL(): number {
    return (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) && !this.isShowSideBar
      ? this.getTitlePaddingLeft() : 16;
  }

  updateBrowserStatus(): void {
    //通过navigation跳转到其它页面，index页面中的PhotoBrowserView无需显示
    if (this.isNavigationToOtherPage) {
      return;
    }
    this.isShowPhotoBrowser = this.browserController.isBrowserShow;
    this.isShowSelectPhotoBrowser = this.browserController.isSelectBrowserShow;
    this.isRunningAnimation = this.browserController.isAnimating;

    Log.info(TAG, `updateBrowserStatus isAnimating:${this.browserController.isAnimating}
      isBrowserShow:${this.browserController.isBrowserShow}
      isSelectBrowserShow:${this.browserController.isSelectBrowserShow}
      isPullDownAndDrag: ${this.browserController.isPullDownAndDrag}`);
    if (this.browserController.isPullDownAndDrag) {
      //开始拖拽，宫格显示
      this.isPageHidden = Visibility.Visible;
    } else if (this.browserController.isAnimating) {
      // 开始退出大图或进入大图，显示宫格
      this.isPageHidden = Visibility.Visible;
    } else {
      // 进大图动效结束隐藏宫格, 减少冗余渲染
      if (this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) {
        this.isPageHidden = Visibility.Hidden;
      } else {
        this.isPageHidden = Visibility.Visible;
      }
      Log.debug(TAG, `animation finished, this.isPageHidden: ${this.isPageHidden}`);
    }
  }

  // Reset the status of the removed tab. It is currently in the selection mode status (index is before switching)
  private resetTabState(index: number): void {
    this.appBroadCast.emit(BroadCastConstants.RESET_STATE_EVENT, [index]);
  }

  // Tab page switching callback (index after switching)
  private onTabChanged(index: number): void {
    Log.info(TAG, `onTabChanged begin, index = ${index}`);
    this.updatePhotosStore(Constants.PREFERENCES_KEY_LAST_PAGE, index);
    this.loadTabPage(index).then(() => {
      this.currentIndex = index;
      this.preIndex = this.currentIndex;
      this.appBroadCast.emit(BroadCastConstants.ON_TAB_CHANGED, [index]);
      getContext().eventHub.emit(BroadCastConstants.ON_TAB_CHANGED, this.tabs[index]?.componentKey);
    });
    PhotoInfo.scenarioIndex = index;
    let localStorage: LocalStorage = LocalStorage.getShared();
    localStorage?.setOrCreate<number>(Constants.SCENARIO_INDEX, index);
  }

  private async requestPermissions(): Promise<void> {
    this.photosPreferences = AppStorage.get<Preferences>(Constants.PHOTOS_STORE_KEY) as Preferences;
    let isRequested: boolean = false;
    if (this.photosPreferences) {
      isRequested = await this.photosPreferences.get(Constants.PHOTOS_PERMISSION_FLAG, false) as boolean;
    } else {
      Log.warn(TAG, 'photos preferences is undefined.');
    }
    Log.info(TAG, `Has permission been requested? ${isRequested}`);
    if (isRequested) {
      return;
    }
    let permissionList: Permissions[] = [
      'ohos.permission.READ_IMAGEVIDEO',
      'ohos.permission.WRITE_IMAGEVIDEO'
    ];
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(LocalStorage.getShared()
        .get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext, permissionList)
        .then((data: PermissionRequestResult) => {
          Log.debug(TAG, JSON.stringify(data));
          let sum: number = 0;
          for (let i = 0; i < data.authResults.length; i++) {
            sum += data.authResults[i];
          }
          Log.info(TAG, `permissions sum: ${sum}`);
          if (!this.photosPreferences) {
            return;
          }
          this.photosPreferences.put(Constants.PHOTOS_PERMISSION_FLAG, true).then((): void => {
            Log.debug(TAG, `Succeeded in putting the value of '${Constants.PHOTOS_PERMISSION_FLAG}'.`);
            this.photosPreferences?.flush();
          }).catch((err: BusinessError) => {
            Log.error(TAG, `Failed to put the value of '${
            Constants.PHOTOS_PERMISSION_FLAG}'. Cause: ${err}, code: ${err?.code}`);
          });
        })
        .catch((err: BusinessError) => {
          Log.error(TAG, `Failed to start ability err code: ${err.code}`);
        });
    } catch (error) {
      Log.error(TAG, `catch error: ${error}, code: ${error?.code}`);
    }
  }

  private initDataFromParam(): void {
    let param: Params = tryGetRouterParam() as Params;
    Log.info(TAG, `[initDataFromParam] param: ${JSON.stringify(param)}`);
    if (!param) {
      this.initPhotosStore();
      this.initTabPage();
      return;
    }

    this.jumpSource = param?.jumpSource;
    if (this.jumpSource == JumpSourceToMain.CAMERA) {
      this.entryFromHap = Constants.ENTRY_FROM_NONE;
      this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
      Log.info(TAG, `Camera in, switch to Tab ${this.currentIndex}.`);
      const msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.ENTER_BY_CAMERA
      };
      ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTOS_ID, msg);
      this.onTabChanged(Constants.TIMELINE_PAGE_INDEX);
      return;
    } else if (this.jumpSource == JumpSourceToMain.PETALCLIP_VIDEO) {
      this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
      this.entryFromHap = Constants.ENTRY_FROM_NONE;
      Log.info(TAG, `petalclip in, switch to Tab ${this.currentIndex}.`);
      const msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.ENTER_BY_PETALCLIP
      };
      ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTOS_ID, msg);
    } else if (this.jumpSource === JumpSourceToMain.FILE_MANAGER) {
      // 从文件管理app跳转过来进入相册首页时，进行相册首页数据初始化
      this.showAlbumForFileManager();
      return;
    } else if (this.jumpSource === JumpSourceToMain.TAB_PAGE) {
      // 从体验、演示app跳转过来
      let tabName = param.tabName;
      if (tabName === Constants.ENTER_ALBUM_PAGE_FROM_FILE_MANAGER) {
        this.showAlbumForFileManager();
      } else if (tabName === Constants.ENTER_TIMELINE_PAGE) {
        this.onTabChanged(Constants.TIMELINE_PAGE_INDEX);
      }
      return;
    } else if (this.jumpSource === JumpSourceToMain.SETTINGS) {
      this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
      this.entryFromHap = Constants.ENTRY_FROM_NONE;
    } else if (this.jumpSource == JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER ||
      this.jumpSource === JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER_PHOTO_ICON) {
      this.initDataFromFACard(param);
      return;
    }
    switch (this.jumpSource) {
      case JumpSourceToMain.PHOTO_VIEW:
        this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
        this.entryFromHap = Constants.ENTRY_FROM_NONE;
        break;
      default:
        break;
    }
    this.initTabPage();
  }

  private initDataFromFACard(param: Params): void {
    Log.info(TAG,
      `initDataFromFACard isShowPhoto:${this.isShowPhotoGridView}, grid isShow:${this.gridViewController.isShow}`);
    // 刷新相册页参数，标识返回到相册首页
    this.isShowPhotoGridView = false;
    this.gridViewController.setIsShow(TAG, 'initDataFromFACard', this.gridViewController.isShow, false);
    // 从FA卡片进入大图浏览页面，点击返回进入相册或者相册宫格页面
    this.entryFromHap = Constants.ENTRY_FROM_NONE;
    // 返回和相册图标都跳转到相册页
    this.currentIndex = Constants.ALBUM_PAGE_INDEX;
    // Fix: 热启动时,图库进入相册宫格或者其它页面导致相册tab页隐藏时,不杀死进程,从FACard进入后需要重置该变量,防止不显示相册tab页.
    AppStorage.delete(Constants.KEY_OF_ALBUM_OPACITY);
    AppStorage.delete(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY);
    AppStorage.delete(Constants.KEY_OF_ALBUM_OTHER_SCALE);
    AppStorage.delete(Constants.KEY_OF_SELECTED_ALBUM_URI);
    AppStorage.delete(Constants.OPEN_TOUCH_GUIDE);
    AppStorage.setOrCreate(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
    if (this.isShowTabBar) {
      // 如果值相同，则不再次触发监听
      this.isShowTabBarValueChangeVariableMonitoring();
    } else {
      TabBarUtils.printLog(TAG, 'initDataFromFACard', this.isShowTabBar, true);
      this.isShowTabBar = true;
    }
    this.onTabChanged(this.currentIndex);
  }

  private async loadNavigationPage(name: string): Promise<void> {
    try {
      Log.info(TAG, `loadNavigationPage name: ${name}`);
      if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
        let pageObj = await import('@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage');
        this.navigationPageLoader = pageObj.MediaOperationBasePageLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS) {
        let pageObj = await import('@ohos/privacy/src/main/ets/setting/GallerySettingsBasePage');
        this.navigationPageLoader = pageObj.GallerySettingsBasePageLoader;
      } else if (name === NavigationConstants.NAVIGATION_MOVIE_PAGE) {
        let pageObj = await import('./MoviePage');
        this.moviePageLoader = pageObj.MoviePageLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES) {
        let pageObj = await import('@ohos/privacy/src/main/ets/components/extendedService/ExtendedServicesPage');
        this.navigationPageLoader = pageObj.ExtendedServicesPageLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_STATEMENTS_CARDS) {
        let pageObj = await import('@ohos/privacy/src/main/ets/components/extendedService/StatementsCards');
        this.navigationPageLoader = pageObj.PageLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_SERVICE_AGREEMENTS_CARDS) {
        let pageObj = await import('@ohos/privacy/src/main/ets/components/extendedService/ServiceAgreementsCards');
        this.navigationPageLoader = pageObj.ServiceAgreementsPageLoader;
      } else if (name === NavigationConstants.NAVIGATION_PRIVACY_VIEWER) {
        let pageObj = await import('@ohos/privacy/src/main/ets/components/mainpage/PrivacyViewerFullScreen');
        this.navigationPageLoader = pageObj.PrivacyViewerFullScreenLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_CHANGE_ALBUM_NAME) {
        let pageObj = await import('@ohos/timeline/src/main/ets/albumgrid/view/albumCover/AlbumCoverChangeView');
        this.albumCoverSelectPageLoader = pageObj.AlbumCoverSelectPageLoader;
      } else if (name === NavigationConstants.NAVIGATION_DESTINATION_ALBUM_PREVIEW) {
        let pageObj = await import('@ohos/timeline/src/main/ets/albumgrid/view/albumCover/AlbumCoverChangeView');
        this.albumCoverPreviewPageLoader = pageObj.AlbumCoverPreviewPageLoader;
      } else if (name === NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE ||
        name === NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW) {
        let pageObj = await import('./OtherAlbumPage');
        this.navigationPageLoader = pageObj.OtherAlbumPageLoader;
      } else {
        this.loadNavigationPageContinue(name);
      }
      Log.info(TAG, 'loadNavigationPage success.');
    } catch (error) {
      Log.error(TAG, `loadNavigationPage error: ${error}`);
    }
  }

  private async loadNavigationPageContinue(name: string): Promise<void> {
    if (name === NavigationConstants.NAVIGATION_WALLPAPER_EDITOR) {
      let pageObj = await import('@ohos/common/src/main/ets/default/view/WallpaperEditorComponent');
      this.wallpaperEditorLoader = pageObj.WallpaperEditorLoader;
    } else if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
      let pageObj = await import('../../pickerability/view/PickerBasePage');
      this.pickerBasePageLoader = pageObj.PickerBasePageLoader;
    } else if (name === NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE) {
      let pageObj = await import('@ohos/common/src/main/ets/default/view/SlideShowPage');
      this.slideShowPageLoader = pageObj.SlideShowPageLoader;
    } else if (name === NavigationConstants.NAVIGATION_GROUP_PAGE) {
      let pageObj = await import('./GroupGridView');
      this.navigationPageLoader = pageObj.GroupAlbumPageLoader;
    } else {
      Log.debug(TAG, `No need to import lazy here: ${name}`);
    }
  }

  private updatePhoneUx(): void {
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
      return;
    }
    this.isPhoneUx = this.getPhoneUX();
    if (DeviceInfo.isGRLFoldScreen()) {
      this.isShowTabBar = AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW) || this.isSelectedMode ||
        (this.currentIndex !== 0 && (this.isShowPhotoClassifieds || this.isShowPortraitAlbumsView ||
        this.isShowPhotoShooting)) ? false : this.isPhoneUx;
    } else if (DeviceInfo.isTablet()) {
      this.isShowTabBar = this.isPhoneUx;
    } else {
      this.isShowTabBar = AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW) ? false : this.isPhoneUx;
    }
    this.isShowSideBar = !this.isPhoneUx;
    ActionBarVar.isShowSideBar = this.isShowSideBar;
  }

  private onPhoneUxChange(): void {
    if (this.isPhoneUx) {
      this.loadTabPage(this.currentIndex);
    } else {
      if (DeviceInfo.isTabletDevice() && getScreen().isFullModeReal() &&
        !AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
        this.isShowTimelinePage = true;
        this.isShowPhotoGridView = false;
      }
      this.loadAlbumPhotoView();
    }
    if (DeviceInfo.isGRLFoldScreen()) {
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_RECOVER_GRID_VIEW, true);
      setTimeout(() => {
        LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_GRID_VIEW);
      }, Constants.APP_KEY_GRL_NUM_CHANGE);
    }
  }

  /**
   * 处理文件管理跳转到相册首页跳转入口逻辑
   */
  private jumpToAlbumForFileManager(): void {
    Log.info(TAG, 'jumpToAlbumForFileManager begin...');
    // 判断当前处在相册、照片、时刻首页时(没有直接判断的参数，只能间接判断)，不用跳转相册首页（判断不是相册首页时直接tabChange就行）
    if (this.isShowTabBar && !this.isShowPhotoBrowser && !this.isShowPhotoGridView &&
      (!this.navigationPageLoader)) {
      // 不是在相册首页时，切换到相册首页
      if (this.currentIndex !== Constants.ALBUM_PAGE_INDEX) {
        this.onTabChanged(Constants.ALBUM_PAGE_INDEX);
      }
    } else {
      // 跳转相册首页
      const options: router.RouterOptions = {
        url: 'MainAbility/view/index',
        params: {
          jumpSource: JumpSourceToMain.FILE_MANAGER,
        }
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    }
  }

  // 通过当前当前页面名称
  private getCurrentNavigationPathName(): string {
    let currentNavigationPathName = this.navigationPageInfos.size() === 0 ? '' :
      this.navigationPageInfos.getAllPathName()[this.navigationPageInfos.size() - 1];
    return currentNavigationPathName;
  }

  // 用于处理平板模式下, 处理在侧边栏不同的相册内点击搜索按钮的事件
  private handleShowSearchPage() {
    if (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) {
      this.isShowSearchPage = true;
      if (DeviceInfo.isGRLFoldScreen()) {
        LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_KEEP_SEARCH, true);
      }
      return;
    }
  }

  /**
   * 从文件管理app跳转过来进入相册首页时，进行相册首页数据初始化
   */
  private showAlbumForFileManager(): void {
    Log.info(TAG, 'showAlbumForFileManager begin...');
    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, 1);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_CATEGORY_ACTION_BAR_OPACITY, 1);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_CATEGORY_VIEW_GRID_OPACITY, 1);

    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 1);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 0);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 0);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);

    AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, -1);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_CITY_GRID_VIEW, false);
    AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');

    ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 1);
    TabBarUtils.printLog(TAG, 'showAlbumForFileManager', this.isShowTabBar, true);
    this.isShowTabBar = true;
    this.onTabChanged(Constants.ALBUM_PAGE_INDEX);
  }

  private resetAlbumSetPageDefaultParams(): void {
    Log.info(TAG, 'resetAlbumSetPageDefaultParams.');
    AppStorage.setOrCreate<number>('albumActionBarOpacity', 1);
    AppStorage.setOrCreate<number>('albumOpacity', 1);
    AppStorage.setOrCreate<boolean>('isShowPhotoGridView', false);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, 1);
    AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');
    this.isShowTabBar = true;
  }
}