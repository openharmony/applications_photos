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

import lazy Global from '../../../default/utils/GlobalContext';
import lazy { Action, ActionID } from '../../../default/view/browserOperation/Action';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '../../../default/model/common/AlbumSetDataInfo';
import lazy { AlbumSetDataSource } from '../../../default/model/browser/album/AlbumSetDataSource';
import lazy { AlbumSetDataSourceManager } from '../../../default/model/browser/album/AlbumSetDataSourceManager';
import lazy { AlbumSetNewMenuOperation } from '../../../default/view/browserOperation/AlbumSetNewMenuOperation';
import lazy { AlbumSetSelectManager } from '../../../default/model/browser/SelectManager';
import lazy { AnimationUtil } from '../../../default/utils/AnimationUtil';
import lazy { TabbarShowController, IsShowListener } from '../../../default/model/common/TabbarShowController';
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '../../../default/model/browser/photo/Constants';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { CustomDialogView } from '../../../default/view/dialog/CustomDialogView';
import lazy { DataStoreUtil } from '../../../default/utils/DataStoreUtil';
import lazy { DateUtil } from '../../../default/utils/DateUtil';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { EmptyPageProp, NoPhotoIndexComponent } from '../../../default/view/NoPhotoIndexComponent';
import lazy { FeatureSwitchUtil } from '../../../default/utils/FeatureSwitchUtil';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  updateAlbumPageGridPaddingLeftAndRight,
  WindowMode,
} from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy { MediaObserver } from '../../../default/model/browser/dataObserver/MediaObserver';
import lazy { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import lazy { MenuOperationFactory } from '../../../default/interface/MenuOperationFactory';
import lazy { MoveOrCopyBroadCastProp } from '../../../default/view/browserOperation/MoveOrCopyBroadCastProp';
import lazy { MultimodalInputManager } from '../../../default/model/common/MultimodalInputManager';
import lazy { NavigationBroadCastManager } from '../../../default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '../../../default/model/common/NavigationConstants';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil,
  PhotoInfo,
  AlbumBrowsingInfo
} from '../../../default/utils/ReportToBigDataUtil';
import lazy { SelectParams } from '../../../default/model/common/SelectParams';
import lazy { MoreAlbumsDataSource } from '../../../default/model/browser/album/MoreAlbumsDataSource';
import lazy { DuplicateAlbumDataSource } from '../../../default/model/browser/album/DuplicateAlbumDataSource';
import lazy { TraceControllerUtils } from '../../../default/utils/TraceControllerUtils';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy Curves from '@ohos.curves';
import lazy { AlbumSetPageActionBar } from '../../../default/view/album/AlbumSetPageActionBar';
import lazy { AlbumSetPageToolBar } from '../../../default/view/album/AlbumSetPageToolBar';
import lazy { AlbumGridItemNewStyle } from '../../../default/view/album/AlbumGridItemNewStyle';
import lazy { AlbumSetDeleteMenuOperation } from '../../../default/view/album/AlbumSetDeleteMenuOperation';
import lazy { AlbumSetRenameMenuOperation } from '../../../default/view/album/AlbumSetRenameMenuOperation';
import lazy { AlbumMore } from '../../../default/view/album/AlbumMore';
import lazy hiTraceMeter from '@ohos.hiTraceMeter';
import lazy common from '@ohos.app.ability.common';
import lazy { ShortCut } from '../../model/ShortCut';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '../../../default/view/actionbar/Menu';
import lazy { LengthMetrics, screen, window } from '@kit.ArkUI';
import lazy { DataListener, LoadingResult } from '../../../default/model/DataSource';
import lazy { AlbumSetCacheManager } from '../../../default/model/AlbumSetCacheManager';
import lazy { SourceAlbumSetDataSource } from '../../../default/model/SourceAlbumSetDataSource';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PhotoAccessHelperAccess } from '../../../default/access/PhotoAccessHelperAccess';
import lazy display from '@ohos.display';
import lazy { FontUtil } from '../../../default/utils/FontUtil';
import lazy { unifiedDataChannel, uniformTypeDescriptor, ValueType } from '@kit.ArkData';
import lazy {
  AlbumRefreshUtil,
  PageStatusListener,
  OnAlbumClickListener,
  AlbumRefreshConst,
} from '../../../default/utils/AlbumRefreshUtil';
import lazy { getDurationConst, GridLink } from '../../../default/model/browser/photo/const/GridLinkDelay';
import lazy { ImageUtil } from '../../../default/utils/ImageUtil';
import lazy { SdCardDataView } from './SdCardDataView';
import lazy { SdCardDataViewUtils } from '../../../default/utils/SdCardDataViewUtils';
import lazy { AlbumDataSource } from '../../../default/model/AlbumDataSource';
import lazy volumemanager from '@ohos.file.volumeManager';
import lazy { AccessibilityUtil } from '../../../default/utils/AccessibilityUtil';
import lazy { albumReportToBigData } from '../../model/browser/album/ReportAlbumDataUtil';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { StatusBarClickEvent } from '../../utils/StatusBarClickEvent';
import lazy { TabBarUtils } from '../../../default/utils/TabBarUtils';
import systemParameter from '@ohos.systemparameter';
import lazy { AlbumGrid } from '../../../default/model/AlbumGrid';
import lazy { AlbumUtils } from '../../../default/utils/AlbumUtils';
import lazy { AlbumGridSortHelper, SortRuleString } from '../../../default/model/AlbumGridSortHelper';
import lazy { GridViewMode } from '../../../default/view/grid/GridView';

/* instrument ignore file */
const TAG: string = 'AlbumSetPage';
const TRANSITION_EFFECT_ALPHA: number = 0.99;
const COOL_START_DELAY: number = 2000;
const SHOW_COUNT = 4;
type commonContext = common.UIAbilityContext | common.ServiceExtensionContext;
const reportDataContext: commonContext = getContext(this) as commonContext;

interface ParamAlbumInfo {
  item: string;
  isFromFACard: boolean;
  isFromThirdSelect: boolean;
  paramsWrapper?: ParamsWrapper;
}

const EMPTY_ALBUMS: EmptyPageProp = {
  illustration: $r('app.media.album_empty'),
  title: $r('app.string.no_photo_head_title_album'),
  subTitle: $r('app.string.no_photo_sub_title_album'),
  extraInfo: Constants.COMPONENT_KEY_ALBUMS,
  hasBarSpace: false,
};

let storage: LocalStorage = LocalStorage.getShared();

// Album Set Page
@Component
export struct AlbumSetPage {
  @State private isPageHidden: Visibility = Visibility.Visible;
  @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
  @Provide('selectedCount') @Watch('updateRightClickMenuList') selectedAlbumsCount: number = 0;
  @Provide @Watch('updateRightClickMenuList') isDisableDelete: boolean = false;
  @Provide @Watch('updateRightClickMenuList') isDisableRename: boolean = false;
  @State expandMore: Resource | string = $r('app.string.more_text');
  @State showLess: Resource | string = $r('app.string.show_less');
  // 宫格区相册数据是否为空
  @State private isEmpty: boolean = false;
  // 列表区相册数据是否为空
  @State private isSourceAlbumEmpty: boolean = false;
  @State @Watch('isFinishedChanged') isFinished: boolean = false;
  @State isSource: boolean = false;
  @State albumScale: number = 1;
  @State gridScale: number = 1;
  @State private albumStyleScale: number = Constants.ALBUM_DEFAULT_SCALE;
  @State gestureEnd: boolean = false;
  @State animationEnd: boolean = false;
  @Provide gridColumnsCount: number = 1;
  @Provide broadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  private albums: AlbumSetDataSource = AlbumSetDataSourceManager.getInstance().getDataSource();
  // 普通相册的数量
  private albumsLastCount: number = -1;
  private readonly albumsDataListener: DataListener<AlbumInfo> = {
    onLoadingFinished: (result: LoadingResult<AlbumInfo>) => {
      if (this.albumsLastCount !== this.albums.totalCount()) {
        this.albumsLastCount = this.albums.totalCount();
        this.updateLayoutOptions('normal');
        this.moreAlbums.loadData()
      }
    },
  };
  moreAlbums: MoreAlbumsDataSource = new MoreAlbumsDataSource(new BroadCast());
  private duplicateAlbumDataSource: DuplicateAlbumDataSource | undefined;
  @State isMoreEmpty: boolean = !UserFileManagerAccess.getInstance().isMoreAlbumVisible();
  @State @Watch('onMoreAlbumCountChanged') private albumCount: number = this.moreAlbums.totalCount();
  @State message: string | Resource = this.expandMore;
  @State private sourceCounts: number = 0;
  @State private subTitle: Resource | string = $r('app.string.no_photo_sub_title_album');
  @State renderGroupFlag: boolean = false;
  private densityDpi: number = -1;
  private isDensityDpiChange: boolean = false;
  appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  isInCurrentTab = false;
  @State @Watch('isActiveChanged') isActive: boolean = false; // Whether the page is in the foreground
  private isOnAlbumSetPage: boolean = true; // 当前页面是否在相册首页
  scroller: Scroller = new Scroller();
  @Consume('isShowSideBar') @Watch('initGridRowCount') isSidebar: boolean;
  mSelectManager = new AlbumSetSelectManager();
  isDataFreeze: boolean = false;
  isLauncherUpdate = true;
  // the switch of distributed page
  @Provide isTabBarShow: boolean = false;
  @State actionMoreMenuList: Action[] = [];
  @Provide rightClickMenuList: Action[] = [];
  @Provide longPressMenuList: Action[] = [];
  @StorageLink('isHorizontal') @Watch('onOrientationChanged') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChanged') private statusBarHeight: number = 0;
  @State @Watch('updateLayoutOptions') private cardNameUris: string[] = [];
  private cloudCardTimerIdWithPinch: number | undefined = undefined;
  @State @Watch('updateLayoutOptions') isShowSdCard: boolean = true;
  @State isHaveMore: boolean = false;
  @State cardCount: number = -1;
  @State cardNameUri: string = '';
  @State cardShowTitle: string | Resource = '';
  @State cardShowSubTitle: string | Resource = '';
  private updateSDCardShowFunc: Function = (uriPath: string): void => this.updateSDCardAddShow(uriPath);
  private updateSDCardHideFunc: Function = (uriPath: string): void => this.updateSDCardHideShow(uriPath);
  private albumRenameUpdateFunc: Function =
    (oldUri: string, newUri: string): void => this.albumRenameUpdate(oldUri, newUri);
  @State pageStatus: boolean = false;
  @State bottomHeight: number = 0;
  @StorageLink('selectedAlbumUri') selectedAlbumUri: string = '';
  @StorageLink('albumActionBarOpacity') @Watch('onAlbumOpacityChanged') albumActionBarOpacity: number = 1;
  @StorageLink('albumOpacity') @Watch('onAlbumOpacityChanged') albumOpacity: number = 1;
  @StorageLink('albumOtherScale') albumOtherScale: number = 1;
  @StorageLink('isDoingGeometryTransitionAnimation')
  @Watch('onGeometryAnimation') isDoingGeometryTransitionAnimation: boolean = false;
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @Consume isShowPhotoHiddenView: boolean;
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State private animationTempo: number = 0;
  private currentIndex: number = Constants.LOCAL_TAB_INDEX;
  private needNotify = false;
  @State private isOpenTransition: boolean = false;
  @State private isGridScrolling: boolean = false;
  @State private isAlbumDataLoaded: boolean = false;
  private isUpdateFromTabSelect: boolean = false;
  @Provide albumsShow: boolean = false;
  private shortCutKeyCompose: Function = (firstKey: number, secondKey: number):
    void => this.albumShortCutKey(firstKey, secondKey);
  private onTabChangedFunc: Function = (index: number): void => this.onTabChanged(index);
  private onStateResetFunc: Function = (index: number): void => this.onStateReset(index);
  private onResetZeroFunc: Function = (pageNumber: number): void => this.onResetZero(pageNumber);
  private onSendMoveCopyBroadCastFunc: Function = (index: number): void => this.onSendMoveCopyBroadCast(index);
  private onWinSizeChangedFunc: Function = (): void => {
    this.initGridRowCount();
    this.albumPageGridPaddingLeftAndRight = updateAlbumPageGridPaddingLeftAndRight();
    this.calculateGridHeight();
  }
  private onSystemScreenChangeCallback: Callback<number> = (id: number): void => this.onSystemScreenChange(id);
  private onMenuClickedFunc = (action: Action, arg: Object[]): void => this.onMenuClicked(action, arg);
  private hasClickedSettingUpdateFunc = (): void => this.hasClickedSettingUpdate();
  private pickerOperationFunc = (displayName: string, albumUri: string, completedFunc?: Function): void =>
  this.onPickerOperation(displayName, albumUri, completedFunc);
  private onPickerOperationBackFunc = (): void => this.onPickerOperationBack();
  private onPickerOperationBackToNewAlbumFunc = (albumInfo: string): void =>
  this.onPickerOperationBackToNewAlbum(albumInfo);
  private moreAlbumEmptyFunc: Function = (isEmpty: boolean, count: number) => this.moreAlbumEmpty(isEmpty, count);
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @StorageLink('isSyncing') isSyncing: boolean = false;
  @Consume isShowTabBar: boolean;
  context: Context = getContext(this);
  iconsNum: number = 2;
  @State pageDeleteNum: number = (getScreen().getWinWidth() * 3 / 4 -
    2 * px2vp(this.context.resourceManager.getNumber($r('app.float.max_padding_end'))) ?? 24) / (2 * this.iconsNum);
  deleteDialogIndex: number = 1;
  @Provide hasClickedSetting: boolean = false;
  private pinchTime: number = 0;
  private hasClickedDeleteButton: boolean = false;
  private updateHasClickedDeleteButtonValueFunc: Function = (): void => this.updateHasClickedDeleteButtonValue();
  private onLoadingFinishedFunc: Function = (size: number): void => this.onLoadingFinished(size);
  private updateHiddenAlbumAndTrashAlbumCountFunc: Function = (count: number[]): void => {
    this.updateHiddenAlbumAndTrashAlbumCount(count);
  }
  private onSelectFunc: Function = (key: string, value: boolean, isDisableRename: boolean, isDisableDelete: boolean,
    callback: Function): void => this.onSelect(key, value, isDisableRename, isDisableDelete, callback);
  private updateSelectedAlbumInfosFunc: Function = (isSelected: boolean, albumInfo: AlbumInfo): void =>
    this.updateSelectedAlbumInfos(isSelected, albumInfo);
  private onDataReloadedCallbackFunc: Function = (): void => this.onDataReloadedCallback();
  @State @Watch('onIsVerdeFoldableChanged') isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  private readonly tabbarShowListener: IsShowListener = {
    onIsShowTabbarChange: (isShowTabbar: boolean) => {
      if (!this.isInCurrentTab) {
        return;
      }
      this.isShowToolBar = isShowTabbar;
    },
  };
  public tabbarShowController: TabbarShowController = TabbarShowController.getInstance();
  @State private isShowToolBar: boolean = true;
  private preScrollPosition: number[] = [0, 0];
  // 监听到外部拖入时间，收藏，智慧，来源，隐藏，最近删除等相册置灰
  @State private isDraggingToPage: boolean = false;
  private saveDialogController?: CustomDialogController;
  // 拖拽文件中各类型数量
  @State isStopEvent: boolean = false;
  @State layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [],
  }
  /**
   * 是否开启捏合宫格相册动效
   */
  @State private enableAnimation: boolean = false;
  @State uriAccumulateCount: number = 0;
  @State public isShowHiddenGridView: boolean = false;
  @State private isAnimating: boolean = false;
  private drawnAlbumCount: number = 0;
  @State private expandMoreDownButton: Resource = $r('sys.symbol.chevron_down');
  @State private hoverSelectUrl: string | undefined = undefined;
  private albumPageGridPaddingLeftAndRight: number = updateAlbumPageGridPaddingLeftAndRight();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  // Grid高度
  @State gridHeight: number | string = Constants.PERCENT_100;
  @StorageLink('isSplitMode') @Watch('onSplitModeChanged') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('isShowDuplicateAlbum') @Watch('onShowDuplicateChange') isShowDuplicateAlbum: boolean = false;
  private handleDeleteAlbumFunc: Function = (albumInfo: AlbumInfo): void => this.handleDeleteAlbum(albumInfo);
  @State private listPaddingTopAndBottom: Resource = $r('sys.float.padding_level6');
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;
  private windowTop: number = 0;
  private lastWindowTop: number = -1;
  private screenHeight: number = 0;
  private updateGridHeightFunc = (data: window.RectChangeOptions): void => this.updateGridHeight(data);
  private albumContext: Context = getContext();
  private boxSelectStr: string = this.albumContext.resourceManager.getStringSync($r('app.string.checkbox_selected'));
  private boxDeselectStr: string =
    this.albumContext.resourceManager.getStringSync($r('app.string.checkbox_deselected'));
  private selectStr: string = this.albumContext.resourceManager.getStringSync($r('app.string.selected'));
  private deselectStr: string = this.albumContext.resourceManager.getStringSync($r('app.string.deselected'));
  private clickActionStr: string =
    this.albumContext.resourceManager.getStringSync($r('app.string.accessibility_event_click_action'));
  private readonly menuHelper: MenuHelper = new MenuHelper();
  private readonly cacheMgr: AlbumSetCacheManager =
    storage?.get<AlbumSetCacheManager>(AlbumSetCacheManager.STORAGE_KEY) ?? new AlbumSetCacheManager(getContext());
  private clickEvent: StatusBarClickEvent = new StatusBarClickEvent();
  private readonly sourceAlbumSetDataSource: SourceAlbumSetDataSource =
    new SourceAlbumSetDataSource(getContext(this), this.cacheMgr, Constants.EXPAND_MORE_AMOUNT);
  private readonly sourceAlbumListener: DataListener<AlbumInfo> = {
    onLoadingFinished: (result: LoadingResult<AlbumInfo>): void => this.onSourceAlbumLoadingFinishedFunc(),
  };

  private selectedAlbumInfos: Set<AlbumInfo> = new Set();
  private updateSelectedAlbumInfos(isSelected: boolean, albumInfo: AlbumInfo): void {
    if (!albumInfo) {
      Log.warn(TAG, `updateSelectedAlbumInfos albumInfo is null`);
      return;
    }
    if (isSelected) {
      this.selectedAlbumInfos.add(albumInfo);
      Log.info(TAG, `updateSelectedAlbumInfos add ${AlbumDefine.getAnonymizeAlbumName(albumInfo.albumName)}, count ${this.selectedAlbumInfos.size}`);
    } else {
      this.selectedAlbumInfos.delete(albumInfo);
      Log.info(TAG, `updateSelectedAlbumInfos delete ${AlbumDefine.getAnonymizeAlbumName(albumInfo.albumName)}, count ${this.selectedAlbumInfos.size}`);
    }
  }

  private onSourceAlbumLoadingFinishedFunc(): void {
    if (this.sourceCounts !== this.sourceAlbumSetDataSource.dataCount()) {
      let needUpdate: boolean = true;
      if ((this.sourceCounts !== 0) && (this.sourceAlbumSetDataSource.dataCount() !== 0)) {
        needUpdate = false;
      }
      this.sourceCounts = this.sourceAlbumSetDataSource.dataCount();
      if (needUpdate) {
        this.updateLayoutOptions('sourceAlbum');
      }
    }
    this.isSourceAlbumEmpty = (this.sourceCounts === 0);
    Log.info(TAG, `onSourceAlbumLoadingFinishedFunc isSourceAlbumEmpty ${this.isSourceAlbumEmpty}`);
  }

  @State private barState: BarState = BarState.Off;
  private readonly onAlbumClickListener: OnAlbumClickListener = {
    onAlbumClicked: (info: AlbumInfo) => this.onAlbumClicked(info),
  } as OnAlbumClickListener;
  private readonly pageStatusListener: PageStatusListener = {
    // 此处的isActive表示相册页数据状态。onAppear在 进入相册宫格等非相册首页 场景触发，此时相册页数据不需要刷新，设置状态为false
    onAppear: () => {
      this.isActive = false;
    },
    onDisappear: () => {
      this.isActive = true;
    },
  } as PageStatusListener;

  private onAlbumClicked(info: AlbumInfo): PageStatusListener | undefined {
    AppStorage.setOrCreate('albumType', info.subType);
    return this.pageStatusListener;
  }

  private onMoreAlbumCountChanged(): void {
    this.updateLayoutOptions('moreAlbum');
  }

  private updateLayoutOptions(label: string): void {
    let msg: string[] = [`${label} updateLayoutOptions normal: ${this.albums.totalCount()}`];
    msg.push(`source: ${this.sourceAlbumSetDataSource.totalCount()}`);
    msg.push(`more: ${this.moreAlbums.totalCount()}`);

    // 普通相册每个元素占一列
    // 分割线占一行
    // 来源相册、更多（隐藏相册、回收站）分别是一个List，各占一行
    // 即不规则元素的index为上述占一行的元素index
    const irregularIndexes: number[] = [];
    let sdCardCount: number = this.isShowSdCard && this.cardNameUris?.length > 0 ? 1 : 0;
    let blankItemCount: number = this.isVerdeFoldable ? 1 : 0;
    if (this.isVerdeFoldable) { // Verde顶部占位
      irregularIndexes.push(0);
    }
    if (this.isShowSdCard && this.cardNameUris && this.cardNameUris?.length > 0) { // SdCardTip
      irregularIndexes.push(blankItemCount);
    }
    let dividerCount: number = 0;
    let sourceCount: number = 0;
    if (this.hasSourceAlbum()) {
      // 普通相册 + 分割线
      irregularIndexes.push(
        this.albums.totalCount() + blankItemCount + sdCardCount + dividerCount);
      sourceCount = 1;
    }

    // 如果显示重复照片相册
    let duplicateAlbum: number = 0;
    if (this.isShowDuplicateAlbum) {
      irregularIndexes.push(
        this.albums.totalCount() + blankItemCount + sdCardCount + dividerCount + sourceCount
      );
      duplicateAlbum = 1;
    }

    if (this.hasMoreAlbum()) {
      // 普通相册 + 分割线 + 智慧相册 + 来源相册
      irregularIndexes.push(
        this.albums.totalCount() + blankItemCount + sdCardCount + dividerCount + sourceCount + duplicateAlbum
      );
    }

    // layout末尾增加三个占位
    if (irregularIndexes.length > 0) { // 末尾预留位置兜底
      let lastIndex: number = irregularIndexes[irregularIndexes.length - 1] + 1;
      irregularIndexes.push(lastIndex);
      irregularIndexes.push(lastIndex + 1);
      irregularIndexes.push(lastIndex + 2);
    }

    this.layoutOptions = {
      regularSize: [1, 1],
      irregularIndexes,
    };
    msg.push(`irregular: [${irregularIndexes.toString()}]`);
    Log.info(TAG, msg.join(', '));
  }

  private onLoadingFinished(size: number): void {
    let isRefreshLayoutOption: boolean = this.isEmpty != (size === 0);
    this.isEmpty = (size === 0);
    this.isSource = true;
    this.isAlbumDataLoaded = true;

    // 根据是否存在用户自定义相册，刷新【多选】按钮是否显示
    this.refreshActionMoreMenuListByUserAlbum(this.albums.hasUserAlbum());
    if (isRefreshLayoutOption) {
      this.updateLayoutOptions('onLoadingFinished');
    }
    Log.info(TAG, `onLoadingFinished isEmpty: ${this.isEmpty}`);
  }

  private updateHiddenAlbumAndTrashAlbumCount(count: number[]): void {
    this.isMoreEmpty = count[0] === 0;
  }

  private onSelect(key: String, value: boolean, isDisableRename: boolean,
    isDisableDelete: boolean, callback: Function): void {
    Log.info(TAG, `album delete onSelect${JSON.stringify(key)}`);
    this.mSelectManager.toolBarStateToggle(key as string, value, isDisableRename, isDisableDelete);
    if (this.mSelectManager.toggle(key as string, value)) {
      Log.info(TAG, 'enter event process');
      callback();
    }
  }

  private updateHasClickedDeleteButtonValue(): void {
    this.hasClickedDeleteButton = false;
  }

  private updatedOptionAndData(): void {
      this.updateLayoutOptions('updatedOptionAndData');
      this.albums.onDataReloaded();
  }

  private onDataReloadedCallback(): void {
    Log.info(TAG, 'THE_ON_DATA_RELOADED');
    if (this.renderGroupFlag) {
      Log.info(TAG, 'onDataReloadedCallback return for renderGroupFlag.');
      return;
    }

    if (!this.isActive) {
      Log.info(TAG, `onDataReloadedCallback return for inactive. active status : ${this.isActive}`);
      return;
    }

    // 根据是否存在用户自定义相册，刷新【多选】按钮是否显示
    this.refreshActionMoreMenuListByUserAlbum(this.albums.hasUserAlbum());

    if (this.isLauncherUpdate) {
      this.updatedOptionAndData();
      this.isLauncherUpdate = false;
      Log.info(TAG, 'onDataReloadedCallback return for isLauncherUpdate.');
      return;
    }

    if (this.isUpdateFromTabSelect) {
      this.updatedOptionAndData();
      this.isUpdateFromTabSelect = false;
      Log.info(TAG, 'onDataReloadedCallback return for isUpdateFromTabSelect.');
      return;
    }

    this.updatedOptionAndData();
  }

  private onEnterPhotoGridViewPageFunc: Function = (): void => this.onEnterPhotoGridViewPage();
  private onExitPhotoGridViewPageFunc: Function = (): void => this.onExitPhotoGridViewPage();

  private onEnterPhotoGridViewPage(): void {
    this.isActive = false;
  }

  private onExitPhotoGridViewPage(): void {
    this.isActive = true;
  }

  onPickerOperation(displayName: string, albumUri: string, completedFunc?: Function) {
    Log.info(TAG,
      `onPickerOperation, albumName: ${AlbumDefine.getAnonymizeAlbumName(displayName)}, albumUri: ${albumUri}`);
    const params: SelectParams = new SelectParams();
    params.bundleName = Constants.PHOTO_BUNDLE_NAME;
    params.isMultiPick = true;
    params.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
    params.isFirstEnter = true;
    params.maxSelectCount = Constants.LIMIT_MAX_THIRD_SELECT_COUNT;
    params.uri = '';
    params.cameraAble = false;
    params.editAble = false;
    params.albumName = displayName;
    params.albumUri = albumUri;
    params.isNewAlbum = true;
    this.renderGroupFlag = true;

    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PICKER_BASE_PAGE]).then(() => {
      this?.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_PICKER_BASE_PAGE, params), false);
      completedFunc?.();
    });
  }

  onPickerOperationBack(): void {
    // this.isActive = true;
    this.navigationPageInfos.pop();
    Log.info(TAG, 'onPickerOperationBack');
    this.albums.resume();
    this.renderGroupFlag = false;
    this.onModeChange();
    this.onDataReloadedCallback();
  }

  private onPickerOperationBackToNewAlbumNewGrid(albumInfo: string): void {
    Log.info(TAG, 'onPickerOperationBackToNewAlbumNewGrid');
    let targetAlbumInfo: AlbumInfo = JSON.parse(albumInfo) as AlbumInfo;
    const paramAlbumInfo: ParamAlbumInfo = {
      item: JSON.stringify(targetAlbumInfo),
      isFromFACard: false,
      isFromThirdSelect: false
    };
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, true);
    AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, paramAlbumInfo);
    // AlbumGrid.firstItem = targetAlbumInfo.mediaItem?.data;
    AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, targetAlbumInfo.uri);
    let params: ParamsWrapper = new ParamsWrapper();
    let targetDataSource: AlbumDataSource = new AlbumDataSource({
        context: getContext(),
        albumInfo: targetAlbumInfo,
        isAccurateNotify: true,
      });
    params.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE, targetDataSource);
    params.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_IS_NEW_ALBUM, true);
    params.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_LISTENER, this.pageStatusListener);
    this.setStatusOnAnimationFinish();
    this.navigationPageInfos.pop();
    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE]).then(() => {
      this.navigationPageInfos.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE, params));
    });
  }

  onPickerOperationBackToNewAlbum(albumInfo: string): void {
    Log.info(TAG, 'onPickerOperationBackToNewAlbum');
    this.albums.resume();
    this.renderGroupFlag = false;
    this.onModeChange();
    this.onDataReloadedCallback();

    if (!DeviceInfo.isEmulator() && !DeviceInfo.isTablet() && AlbumUtils.useNewPhotoGrid()) {
      this.onPickerOperationBackToNewAlbumNewGrid(albumInfo);
      return;
    }

    let paramsWrapper: ParamsWrapper = new ParamsWrapper();
    paramsWrapper.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_IS_NEW_ALBUM, true);
    const params: ParamAlbumInfo = {
      item: albumInfo,
      isFromFACard: false,
      isFromThirdSelect: true,
      paramsWrapper: paramsWrapper,
    };

    if (DeviceInfo.isPhoneUx()) {
      let targetAlbumInfo: AlbumInfo = JSON.parse(albumInfo) as AlbumInfo;
      let targetDataSource: AlbumDataSource =
        new AlbumDataSource({ context: getContext(), albumInfo: targetAlbumInfo });
      params.paramsWrapper?.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE, targetDataSource);
    }
    // 使用动态加载，在navigation pushPath之前调用
    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW]).then(() => {
      this.navigationPageInfos.pop();
      this.navigationPageInfos?.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW,
        params));
    });
  }

  private handleDeleteAlbum(albumInfo: AlbumInfo): void {
    Log.info(TAG, `handleDeleteAlbum isAlbumSetSelectedMode:${this.isAlbumSetSelectedMode}`);

    if (this.isAlbumSetSelectedMode) {
      this.onMenuClicked(Action.DELETE_ALBUM, []);
    } else {
      if (albumInfo) { // tab选delete or Album内无选择态删除delete_album_inside
        this.onMenuClickedForSingleItem(Action.DELETE_ALBUM, albumInfo);
      } else { // tab选 + ctrl + d
        ShortCut.tabSelectedAlbum && this.onMenuClickedForSingleItem(Action.DELETE_ALBUM, ShortCut.tabSelectedAlbum);
      }
    }
  }

  private setStatusOnAnimationFinish(): void {
    setTimeout((): void => {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
    }, getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID))
  }

  onMenuClicked(action: Action, arg: Object[]): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    let menuContext: MenuContext;
    if (Action.ABOUT_GALLERY.equals(action)) {
      NavigationBroadCastManager.getInstance()
        .targetName = NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY;
      this.navigationBroadCast.emitAsync(
        NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY]).then(() => {
        this.navigationPageInfos.pushPath(
          new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY, null));
      });
    } else if (Action.GALLERY_SETTINGS.equals(action)) {
      if (this.hasClickedSetting) {
        Log.info(TAG, 'the Setting button has been clicked');
        return;
      }
      this.hasClickedSetting = true;
      NavigationBroadCastManager.getInstance()
        .targetName = NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS;
      this.navigationBroadCast.emitAsync(
        NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS]).then(() => {
        this.navigationPageInfos?.pushPath(
          new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS, null));
      });
    } else if (Action.NEW_ALBUM.equals(action)) {
      menuContext = new MenuContext();
      menuContext
        .withOperationStartCallback((): void => this.onOperationStart(false))
        .withOperationEndCallback((): void => this.onOperationEnd(true))
        .withBroadCast(this.broadCast);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetNewMenuOperation, menuContext).doAction();
    } else if (Action.CANCEL.equals(action)) {
      if (this.isAlbumSetSelectedMode) {
        TabBarUtils.printLog(TAG, 'CANCEL isAlbumSetSelectedMode', this.isShowTabBar, true);
        this.isShowTabBar = true;
        const msg: Record<string, number | string | boolean> = {
          'IS_ENTER': 'false',
          'IS_QUIT': 'true',
          'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),
        };
        ReportToBigDataUtil.report(BigDataConstants.MULTI_SELECT_MODE, msg);
      }
      this.isAlbumSetSelectedMode = false;
    } else if (Action.MULTISELECT.equals(action)) {
      TabBarUtils.printLog(TAG, 'onMenuClicked MULTISELECT', this.isShowTabBar, false);
      this.isShowTabBar = false;
      this.isAlbumSetSelectedMode = true;
      const msg: Record<string, number | string | boolean> = {
        'IS_ENTER': 'true',
        'IS_QUIT': 'false',
        'from': AlbumBrowsingInfo.albumLongPress ? 'GALLERY_GRID_LONG_PRESS_PAGE' : 'CLICK_BUTTON_PAGE',
        'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),
      };
      ReportToBigDataUtil.report(BigDataConstants.MULTI_SELECT_MODE, msg);
    } else if (Action.RENAME_ALBUM.equals(action)) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(true)
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onRenameOperationEnd())
        .withUIContext(getContext(this) as common.UIAbilityContext)
        .withBroadCast(this.broadCast);
      getContext()?.eventHub.on(BroadCastConstants.ALBUM_RENAME_ALBUM_TAB, this.albumRenameUpdateFunc);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetRenameMenuOperation, menuContext).doAction();
    } else if (Action.DELETE_ALBUM.equals(action)) {
      if (this.hasClickedDeleteButton) {
        Log.info(TAG, 'the delete button has been clicked');
        return;
      }
      this.hasClickedDeleteButton = true;
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(true)
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => {
          this.resetViewModeAndSort(this.selectedAlbumInfos);
          this.onOperationEnd(false);
        })
        .withBroadCast(this.broadCast);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetDeleteMenuOperation, menuContext).doAction();
    }
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_CONTEXT, getContext());
    this.menuHelper.onMenuClicked(action, params);
  }

  /**
   * 调用菜单的前置方法
   * @param isOnAlbumSetPage
   * 新建相册时会进入picker页面，不会处于相册首页，页面需要去激活，避免相册页dataSource查询
   * 删除、重命名场景，仍处于相册页，则使用默认参数
   */
  onOperationStart(isOnAlbumSetPage: boolean = true): void {
    this.isActive = isOnAlbumSetPage;
    this.isDataFreeze = true;
    this.albums.pause();

  }

  /*
   * 新建相册完成拉起picker时，picker仍然处于显示状态，此时设置needFreeze为false，使dataSource仍保持freeze态。
   * 等picker关闭后，再设置unfreeze并加载数据
   */
  private onOperationEnd(needFreeze: boolean = false): void {
    Log.debug(TAG, 'onOperationEnd');
    this.unlockTransitionOnce();
    this.isDataFreeze = false;
    this.isAlbumSetSelectedMode = false;
    if (!needFreeze) {
      this.albums.resume();
    }
    TabBarUtils.printLog(TAG, 'onOperationEnd', this.isShowTabBar, true);
    this.isShowTabBar = true;
  }

  onRenameOperationEnd(): void {
    Log.debug(TAG, 'onRenameOperationEnd');
    this.isDataFreeze = false;
    this.isAlbumSetSelectedMode = false;
    this.albums.resume();
    getContext()?.eventHub.off(BroadCastConstants.ALBUM_RENAME_ALBUM_TAB, this.albumRenameUpdateFunc);
    TabBarUtils.printLog(TAG, 'onRenameOperationEnd', this.isShowTabBar, true);
    this.isShowTabBar = true;
  }

  moreAlbumEmpty(isEmpty: boolean, albumCount: number): void {
    this.albumCount = albumCount;
    this.isMoreEmpty = isEmpty;
  }

  /**
   * 增加卡片
   *
   * @param uriPath uri路径
   */
  private updateSDCardAddShow(uriPath: string): void {
    this.cardNameUris.push(uriPath);
    this.isHaveMore = this.cardNameUris.length > 1;
    this.cardCount = this.cardNameUris.length;
    this.getTitleByIsHaveMore();
  }

  /**
   * 移除卡片
   *
   * @param uriPath uri路径
   */
  private updateSDCardHideShow(uriPath: string): void {
    this.cardNameUris = this.cardNameUris.filter(item => item !== uriPath);
    this.cardNameUris = this.cardNameUris.filter(item => item !== '');
    this.isHaveMore = this.cardNameUris.length > 1;
    this.cardCount = this.cardNameUris.length;
    this.getTitleByIsHaveMore();
  }

  private albumRenameUpdate(oldUri: string, newUri: string): void {
    this.albums.updateRenamedAlbumInfo(oldUri, newUri);
  }

  private resetViewModeAndSort(albumInfos: Set<AlbumInfo>): void {
    // 重置显示日期 排序
    Log.info(TAG, `resetViewModeAndSort count: ${albumInfos.size}`);
    for (let albumInfo of albumInfos) {
      Log.info(TAG, `resetViewModeAndSort albumName: ${AlbumDefine.getAnonymizeAlbumName(albumInfo.albumName)}`);
      AlbumUtils.saveViewMode(getContext(), albumInfo?.subType, albumInfo?.lpath, GridViewMode.GRID);
      AlbumGridSortHelper.getInstance().setSortRule(
        AlbumGridSortHelper.getAlbumKeyByAlbumInfo(albumInfo), '', SortRuleString.defaultType);
    }
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
    albumReportToBigData(reportDataContext);
    this.moreAlbums.initialize();
    this.changeAppKeyNewAlbum();
    this.registerBroadcast();
    this.registerWindowChangedListener();
    this.onActive();
    this.updateActionMoreMenuList();
    this.refreshActionMoreMenuListByUserAlbum(this.albums.hasUserAlbum());
    this.updateRightClickMenuList();
    this.updateLongPressMenuList();
    this.initGridRowCount();
    this.initAlbumStyleScale();
    this.clickEvent.register(TAG, () => {
      if (!this.isActive) {
        return;
      }
      this.albums?.updateSlidingWindow(0);
      setTimeout(() => {
        this.scroller?.scrollToIndex(0, false)
      }, Constants.DELAY_TENTH_SECOND);
    });
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
    this.broadCast.on(BroadCastConstants.SELECT, this.onSelectFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_SELECT_ALBUMINFOS, this.updateSelectedAlbumInfosFunc);
    this.broadCast.on(BroadCastConstants.PICKER_OPERATION, this.pickerOperationFunc);
    this.navigationBroadCast.on(
      NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, this.onPickerOperationBackFunc);
    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_NEW_ALBUM,
      this.onPickerOperationBackToNewAlbumFunc);
    this.updateLayoutOptions('Appear');
    UserFileManagerAccess.getInstance().registerPhotoAccess((): void => this.albumPhotoAccessCallBack());
    MediaObserver.getInstance().registerObserver(this.sourceAlbumSetDataSource);
    this.sourceAlbumSetDataSource.notifyDirty();
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedCallbackFunc);
    this.mSelectManager.registerCallback('updateCount', (newState: number) => this.updateSelectedCount(newState));
    this.mSelectManager.registerCallback('updateToolBarState', (isDisableRename: boolean, isDisableDelete: boolean) => {
      this.updateToolBarState(isDisableRename, isDisableDelete);
    });
    TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
    this.moreAlbums.registerAlbumObserver();
    this.calculateGridHeight();
    this.onAlbumOpacityChanged();
    this.registerActions();
    screen.on('change', this.onSystemScreenChangeCallback);
    this.setAnimationTempo();
    this.currentFontSizeScaleChange();
    this.isShowDuplicateAlbum = false;
    this.tabbarShowController.addListener(this.tabbarShowListener);

    this.querySdCardData();
    getContext()?.eventHub.on(BroadCastConstants.EXTERNAL_STORAGE_SHOW, this.updateSDCardShowFunc);
    getContext()?.eventHub.on(BroadCastConstants.EXTERNAL_STORAGE_NOT_SHOW, this.updateSDCardHideFunc);
    this.PreviewStatusChange();
  }

  private async querySdCardData(): Promise<void> {
    this.cardNameUris = await SdCardDataViewUtils.getInstance().getSdCardName() ?? [];
    this.isHaveMore = this.cardNameUris.length > 1;
    this.cardCount = this.cardNameUris.length;
    this.getTitleByIsHaveMore();
  }

  private getTitleByIsHaveMore(): void {
    if (this.cardNameUris?.length > 0) {
      let uri: string = this.isHaveMore ? '' : this.cardNameUris[0];
      if (!this.isHaveMore) {
        this.queryVolumeByUri(uri);
      } else {
        this.cardShowTitle = $r('app.string.viewing_storage_devices_more');
        this.cardShowSubTitle = $r('app.string.viewing_storage_devices_more_sub');
      }
    }
  }

  private async queryVolumeByUri(uri: string): Promise<void> {
    // let volume: volumemanager.Volume = await SdCardDataViewUtils.getInstance().getSdCardNameByUuid(uri);
    // let cardShowName: string = volume?.diskType === 1 ? '' : volume?.description ?? '';
    // this.cardShowTitle =
    //   $r('app.string.viewing_storage_devices', cardShowName === '' ? $r('app.string.externalDisk') : cardShowName);
    // this.cardShowSubTitle =
    //   $r('app.string.jump_to_file_management_tips', cardShowName === '' ? $r('app.string.externalDisk') : cardShowName);
  }

  private albumPhotoAccessCallBack(): void {
    this.albums.notifyDirty();
    this.moreAlbums.loadData();
    this.sourceAlbumSetDataSource.notifyDirty();
    Log.info(TAG, 'User AlbumPhotoAccessCallBack');
  }

  private initAlbumStyleScale(): void {
    DataStoreUtil.getInstance().getData('albumStyle', '1').then((value: ValueType): void => {
      const valueNumber: number = parseInt(value.toString());
      if (Number.isFinite(valueNumber)) {
        this.albumStyleScale = valueNumber;
      }
    });
  }

  private setAnimationTempo(): void {
    setTimeout((): void => {
      this.animationTempo = 1.0;
    }, COOL_START_DELAY);
  }

  private registerActions(): void {
    let params: ParamsWrapper = new ParamsWrapper()
      .set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_ALBUM);
  }

  private registerBroadcast() {
    this.albums.addListener(this.albumsDataListener);
    this.moreAlbums.broadCast?.on(Constants.ON_LOADING_FINISHED, this.moreAlbumEmptyFunc);
    this.sourceAlbumSetDataSource.addListener(this.sourceAlbumListener);
    this.appBroadCast.on(BroadCastConstants.SHORTCUT_KEY_COMPOSE, this.shortCutKeyCompose);
    this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateResetFunc);
    this.appBroadCast.on(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, this.onSendMoveCopyBroadCastFunc);
    AppStorage.setOrCreate('setSelectManagerToAnother', this.mSelectManager);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.moreAlbums.broadCast?.on(Constants.HIDDEN_ALBUM_AND_TRASH_ALBUM_COUNT,
      this.updateHiddenAlbumAndTrashAlbumCountFunc);
    this.appBroadCast.on(BroadCastConstants.RESET_ZERO, this.onResetZeroFunc);
    this.appBroadCast.on(BroadCastConstants.SETTING_MULTIPLE_CLICKS, this.hasClickedSettingUpdateFunc);
    this.appBroadCast.on(BroadCastConstants.HAS_CLICKED_ALBUM_DELETE_BUTTON,
      this.updateHasClickedDeleteButtonValueFunc);
    this.appBroadCast.on(BroadCastConstants.DELETE_ALBUM_INSIDE, this.handleDeleteAlbumFunc);
    this.appBroadCast.on(BroadCastConstants.DELETE_ALBUM_OUTSIDE, this.handleDeleteAlbumFunc);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'AlbumSetPageAboutToDisappear');
    // Fix issue: 图库不退出，直接从FA 卡片点击进入，仍然显示dialog
    this.clickEvent.unRegister();
    this.destroyWindowChangedListener();
    this.broadCast.emit(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG, []);
    this.broadCast.emit(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, []);
    this.broadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
    this.onInActive();
    this.broadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.moreAlbums.broadCast?.off(Constants.ON_LOADING_FINISHED, this.moreAlbumEmptyFunc);
    this.broadCast.off(BroadCastConstants.SELECT, this.onSelectFunc);
    this.broadCast.off(BroadCastConstants.UPDATE_SELECT_ALBUMINFOS, this.updateSelectedAlbumInfosFunc);
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedCallbackFunc);
    this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateResetFunc);
    this.appBroadCast.off(BroadCastConstants.RESET_ZERO, this.onResetZeroFunc);
    this.appBroadCast.off(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, this.onSendMoveCopyBroadCastFunc);
    this.appBroadCast.off(BroadCastConstants.SETTING_MULTIPLE_CLICKS, this.hasClickedSettingUpdateFunc);
    this.moreAlbums.broadCast?.off(Constants.HIDDEN_ALBUM_AND_TRASH_ALBUM_COUNT,
      this.updateHiddenAlbumAndTrashAlbumCountFunc);
    this.broadCast.off(BroadCastConstants.PICKER_OPERATION, this.pickerOperationFunc);
    this.appBroadCast.off(BroadCastConstants.HAS_CLICKED_ALBUM_DELETE_BUTTON,
      this.updateHasClickedDeleteButtonValueFunc);
    this.navigationBroadCast.off(
      NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, this.onPickerOperationBackFunc);
    this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_NEW_ALBUM,
      this.onPickerOperationBackToNewAlbumFunc);
    this.appBroadCast.off(BroadCastConstants.SHORTCUT_KEY_COMPOSE, this.shortCutKeyCompose);
    this.appBroadCast.off(BroadCastConstants.DELETE_ALBUM_INSIDE, this.handleDeleteAlbumFunc);
    this.appBroadCast.off(BroadCastConstants.DELETE_ALBUM_OUTSIDE, this.handleDeleteAlbumFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
    MediaObserver.getInstance().unregisterObserver(this.sourceAlbumSetDataSource);
    this.moreAlbums.unregisterAlbumObserver();
    this.duplicateAlbumDataSource?.unregisterAlbumObserver();
    screen.off('change', this.onSystemScreenChangeCallback);
    this.saveDialogController = undefined;
    this.tabbarShowController.removeListener(this.tabbarShowListener);
    AlbumRefreshUtil.onDestroy();
    getContext()?.eventHub.off(BroadCastConstants.EXTERNAL_STORAGE_SHOW, this.updateSDCardShowFunc);
    getContext()?.eventHub.off(BroadCastConstants.EXTERNAL_STORAGE_NOT_SHOW, this.updateSDCardHideFunc);
  }

  hasClickedSettingUpdate(): void {
    this.hasClickedSetting = false;
  }

  // Callback when the page is show.
  onIndexPageShow(): void {
    Log.info(TAG, '[onIndexPageShow]  albumActionBarOpacity: ' + this.albumActionBarOpacity + ', albumOpacity: ' +
    this.albumOpacity + ', this.isPageHidden: ' + this.isPageHidden);
    // 前后台切换时，置灰变量需要重置
    this.isDraggingToPage = false;
    Log.info(TAG, `[onIndexPageShow] isShow=${this.isShow}, isInCurrentTab=${this.isInCurrentTab}`);
    // 当前tab不为相册页时，相册数据一直处于非激活态，此时无需修改前后台状态
    if (!this.isInCurrentTab) {
      Log.info(TAG, 'onIndexPageShow return for isInCurrentTab.');
      return;
    }
    // 前台切后台时，数据都应设置为非激活态
    // 前台切后台时，当前数据为非激活态，则后台再切换为前台时，仍然保持非激活态
    if (!this.isShow) {
      if (!this.isActive) {
        // 相册首页不是当前页面（进相册宫格、智慧相册、搜索、照片页、时刻等场景），在切后台进行标记，用于此场景下切前台，仍然保持非激活态
        this.isOnAlbumSetPage = false;
      }
      this.onInActive();
      Log.info(TAG, 'onIndexPageShow return for isShow.');
      return;
    }
    if (this.isVerdeFoldable) {
      this.tabbarShowController.setIsShowTabbar(true);
    }
    // 后台切前台时判断：若进后台之前为非激活态，则恢复前台时，仍然保持非激活态
    if (!this.isOnAlbumSetPage) {
      this.isOnAlbumSetPage = true;
      Log.info(TAG, 'onIndexPageShow return for isOnAlbumSetPage.');
      return;
    }
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
      // 只有当前处于相册页，进行后台到前台的切换，才需要更新下宫格区相册区域和列表区相册区域的有效性
    }
    this.onActive();
  }

  onModeChange(): void {
    if (this.isShowPhotoHiddenView) {
      Log.info(TAG, 'onModeChange return for isShowPhotoHiddenView.');
      return;
    }
    Log.info(TAG, `onModeChange ${this.isAlbumSetSelectedMode}`);
    this.updateActionMoreMenuList();
    this.updateRightClickMenuList();
    this.selectedAlbumInfos.clear();
    if (!this.isAlbumSetSelectedMode) {
      if (!this.isShowPhotoGridView) {
        TabBarUtils.printLog(TAG, 'onModeChange', this.isShowTabBar, true);
        this.isShowTabBar = true;
      }
      this.mSelectManager.emitCallback('updateCount', [0]);
      this.mSelectManager.onModeChange(false);
    }
  }

  private updateSelectedCount(newState: number): void {
    Log.info(TAG, `updateSelectedCount ${newState}`);
    if (this.isDataFreeze) {
      Log.info(TAG, 'updateSelectedCount return for isDataFreeze.');
      return;
    }
    if (this.selectedAlbumsCount === 0 && newState === 0) {
      this.selectedAlbumsCount--;
    } else {
      this.selectedAlbumsCount = newState;
    }
  }

  private updateToolBarState(isDisableRename: boolean, isDisableDelete: boolean): void {
    if (this.isDataFreeze) {
      Log.info(TAG, 'updateToolBarState return for isDataFreeze.');
      return;
    }
    Log.info(TAG, `updateToolBarState: isDisableRename: ${isDisableRename}, isDisableDelete: ${isDisableDelete}`);
    this.isDisableRename = isDisableRename;
    this.isDisableDelete = isDisableDelete;
  }

  private changeAppKeyNewAlbum(): void {
    if (AppStorage.get<boolean>(Constants.APP_KEY_NEW_ALBUM)) {
      AppStorage.setOrCreate<boolean>(Constants.APP_KEY_NEW_ALBUM, false);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    }
  }

  albumShortCutKey(firstKey: number, secondKey: number) {
    let targetScale: number = AppStorage.get<number>(Constants.albumScreenScale) ?? UiUtil.albumDefaultScale;
    if (firstKey === MultimodalInputManager.KEY_CODE_CTRL_LEFT ||
      firstKey === MultimodalInputManager.KEY_CODE_CTRL_RIGHT) {
      if (secondKey === MultimodalInputManager.keyCodePlus || secondKey === MultimodalInputManager.keyCodeNumPadAdd) {
        targetScale = Constants.gridLargeScale;
      }
      if (secondKey === MultimodalInputManager.keyCodeMinus ||
        secondKey === MultimodalInputManager.keyCodeNumPadSubtract) {
        targetScale = Constants.gridSmallScale;
      }
    }
    try {
      DataStoreUtil.getInstance().putData('albumStyle', targetScale);
    } catch (error) {
      Log.error(TAG, `albumShortCutKey End putData error: ${error}, code: ${error?.code}`);
    }
    DataStoreUtil.getInstance().flush();
    AppStorage.setOrCreate<number>(Constants.albumScreenScale, targetScale);
    this.initGridRowCount();
  }

  /**
   * 更新动作栏菜单
   */
  updateActionMoreMenuList(): void {
    if (this.isAlbumSetSelectedMode && !DeviceInfo.isPhoneVde()) {
      this.actionMoreMenuList = [];
      Log.info(TAG, 'actionMoreMenuList: AlbumSetSelectedMode');
      return;
    }
    let tempMenuList: Action[] = [];

    tempMenuList.push(Action.MULTISELECT);

    tempMenuList.push(Action.GALLERY_SETTINGS);

    let msg: string = tempMenuList.map((action: Action) => action.componentKey).join(',');
    Log.info(TAG, `actionMoreMenuList: ${msg}`);
    this.actionMoreMenuList = tempMenuList;
  }

  updateRightClickMenuList(): void {
    if (this.isShowPhotoHiddenView) {
      Log.info(TAG, 'updateRightClickMenuList return for isShowPhotoHiddenView.');
      return;
    }
    if (this.isAlbumSetSelectedMode) {
      this.rightClickMenuList = [];
      if (!this.isDisableRename && this.selectedAlbumsCount === 1) {
        this.rightClickMenuList.push(Action.RENAME_ALBUM);
      }
      if (!this.isDisableDelete && this.selectedAlbumsCount > 0) {
        this.rightClickMenuList.push(Action.DELETE_ALBUM);
      }
    }
  }

  private isFinishedChanged(): void {
    Log.info(TAG, 'this.isFinished = ' + this?.isFinished + `, this.isEmpty = ${this?.isEmpty}`);
    this.updateLayoutOptions('isFinishedChanged');
  }

  private updateLongPressMenuList(): void {
    let tempMenuList: Action[] = [];
    if (!this.isAlbumSetSelectedMode) {
      tempMenuList.push(Action.MULTISELECT);
    }
    tempMenuList.push(Action.MOVE_PHOTO, Action.RENAME_ALBUM, Action.DELETE_ALBUM);
    let msg: string = tempMenuList.map((action: Action) => action.componentKey).join(',');
    Log.info(TAG, `longPressMenuList: ${msg}`);
    if (!UiUtil.isActionArrayEqual(this.longPressMenuList, tempMenuList)) {
      this.longPressMenuList = tempMenuList;
    }
  }

  onStateReset(index: number): void {
    if (index === Constants.ALBUM_PAGE_INDEX) {
      this.isAlbumSetSelectedMode = false;
    }
  }

  onTabChanged(index: number): void {
    if (index === Constants.ALBUM_PAGE_INDEX) {
      Log.info(TAG, '[onTabChanged]  albumActionBarOpacity: ' + this.albumActionBarOpacity + ', albumOpacity: ' +
      this.albumOpacity + ', this.isPageHidden: ' + this.isPageHidden);
      this.isDraggingToPage = false;
      if (!this.isActive) {
        this.isUpdateFromTabSelect = true;
        let intervalId = setInterval((): void => {
          this.isUpdateFromTabSelect = false;
          clearInterval(intervalId);
        }, Constants.GRID_LOCK_DURATION);
      }
      this.isInCurrentTab = true;
      this.onActive();
    } else {
      this.isInCurrentTab = false;
      this.isAlbumSetSelectedMode = false;
      this.onInActive();
    }
  }

  onSendMoveCopyBroadCast(index: number): void {
    if (index === Constants.ALBUM_PAGE_INDEX) {
      MoveOrCopyBroadCastProp.getInstance().sendMoveOrAddBroadCast(this.broadCast);
    }
  }

  judgeIsOpenTransitionAni(): boolean {
    return !this.isAlbumSetSelectedMode && this.isOpenTransition && !this.isGridScrolling && !this.isSyncing;
  }

  // Callback when the page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      ReportToBigDataUtil.report(BigDataConstants.ENTER_ALBUM_SET_PAGE);
      Log.info(TAG, `onActive albumOpacity: ${this.albumOpacity}, isShowPhotoGridView: ${this.isShowPhotoGridView}`);
      this.isActive = true;
      if (this.currentIndex === Constants.LOCAL_TAB_INDEX) {
        this.onLocalAlbumSetActive();
      } else {
        this.onLocalAlbumSetInActive();
      }
      this.showNotify();
      // 相册页透明度为1与显示相册宫格变量为互斥关系，此处为兜底
      if (this.albumOpacity === 1 && this.isShowPhotoGridView) {
        AppStorage.setOrCreate<boolean>('isShowPhotoGridView', false);
        this.isShowTabBar = true;
      }
    }
    this.isFinishedChanged();
    if (this.albumCount === 0 && this.moreAlbums.hasLoadMoreAlbumDataError) {
      this.moreAlbums.hasLoadMoreAlbumDataError = false;
      this.moreAlbums.loadData();
    }
    this.albums.resume();
    this.moreAlbums.onActive();
    this.sourceAlbumSetDataSource.resume();
    // 由于当修改系统设置的显示大小时，虽然触发了screen.change事件，但屏幕没有显示图库，新设置的dpi对图库并不生效，需要在进入图库时重新计算一次
    if (this.isDensityDpiChange) {
      this.isDensityDpiChange = false;
      getScreen().updateSize();
    }
  }

  // Callback when the page is in the background
  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.moreAlbums?.onInActive();
    }
    /**
     * 场景：PAD模式下悬浮态切换为全屏，会先创建PAD布局和数据源，再销毁相册页，导致数据源的isActive状态异常
     * 如果已经存在SideBar，则无需暂停album
     */
    if (!this.isSidebar) {
      this.albums?.pause();
    }
    this.sourceAlbumSetDataSource.pause();
  }

  // Callback when the local albums' page is in the foreground
  onLocalAlbumSetActive(): void {
    if (this.currentIndex === Constants.LOCAL_TAB_INDEX) {
      Log.info(TAG, `Local album set is on active, opacity = ${this.albumOpacity}`);
      this.albums?.resume();
    }
  }

  // Callback when the local albums' page is in the background
  onLocalAlbumSetInActive(): void {
    if (this.currentIndex === Constants.OTHER_EQUIPMENT_TAB_INDEX) {
      Log.info(TAG, 'Local album set is on inactive');
      this.albums?.pause();
    }
  }

  onResetZero(pageNumber: number): void {
    if (pageNumber === Constants.ALBUM_PAGE_INDEX) {
      this.scroller.scrollEdge(Edge.Top);
    }
  }

  private unlockTransitionOnce(): void {
    this.isOpenTransition = true;
    let intervalId = setInterval((): void => {
      this.isOpenTransition = false;
      clearInterval(intervalId);
    }, Constants.GRID_LOCK_DURATION);
  }

  initGridRowCount(): void {
    Log.info(TAG, `get screen width is : ${getScreen().getWinWidth()}, height is : ${getScreen().getWinHeight()}`);
    let diggingAlbumArea = this.diggingHoleCameraArea?.top || this.diggingHoleCameraArea?.left ||
      this.diggingHoleCameraArea?.right || this.diggingHoleCameraArea?.bottom;
    if (DeviceInfo.isPhoneUx() && getScreen().isHorizontal() && diggingAlbumArea === 0 &&
      !DeviceInfo.isGRLMStatus() && !DeviceInfo.isSuperLauncher()) {
      // 横屏时进多任务直接切换到一个不支持横屏的应用，再从多任务切回图库，此时图库是横屏的，若挖空区域都为空，不做处理.
      Log.warn(TAG, 'screen is horizontal and diggingAlbumArea is invalid');
      return;
    }
    this.gridColumnsCount = UiUtil.getAlbumGridCount(this.isSidebar);
  }

  isRecycleAlbumOfPhoneLikeDevice(item: AlbumInfo): boolean {
    return !DeviceInfo.isPc() && item.isTrashAlbum;
  }

  private albumSetDataInfoCheck(item: AlbumSetDataInfo | undefined, index: number): boolean {
    if (item && item.data) {
      return true;
    }
    Log.error(TAG, `albumSetDataInfo is invalid, index=${index}`);
    return false;
  }

  private onShowExpandMoreButtonClick(): void {
    const dataCount: number = this.sourceAlbumSetDataSource.dataCount();
    const showCount: number = this.sourceAlbumSetDataSource.getShowCount();
    Log.info(TAG, `photo_source expandMore/showLess button animate dataCount: ${dataCount} showCount: ${showCount}`);
    animateTo({
      curve: Curves.interpolatingSpring(0, 1, Constants.GROUP_ITEM_PRESS_CURVE_STIFFNESS, Constants.CARD_CONTAINER),
    }, () => {
      // 点击收回，显示5个
      if (dataCount === showCount) {
        this.sourceAlbumSetDataSource.setShowCount(Constants.EXPAND_MORE_AMOUNT);
        this.message = this.expandMore;
        this.expandMoreDownButton = $r('sys.symbol.chevron_down');
        if (AccessibilityUtil.isOpenTouchGuideSync()) {
          // 发送焦点到`更多`项
          AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_EXPAND_MORE);
        }
        return;
      }
      // 点击更多 显示往下20个， 如果全部显示了 显示收回
      if (showCount + Constants.SOURCE_ALBUM_FIRST_BATCH_QUERY_COUNT < dataCount) {
        this.sourceAlbumSetDataSource.setShowCount(showCount + Constants.SOURCE_ALBUM_FIRST_BATCH_QUERY_COUNT);
      } else {
        this.sourceAlbumSetDataSource.setShowCount(dataCount);
        this.message = this.showLess;
        this.expandMoreDownButton = $r('sys.symbol.chevron_up');
        if (AccessibilityUtil.isOpenTouchGuideSync()) {
          AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_EXPAND_MORE);
        }
      }
    })
  }

  @Builder
  AlbumMoreBuilder(item: AlbumSetDataInfo, index: number) {
    AlbumMore({
      item: item.data,
      keyIndex: index,
      isSourceAlbumShow: index <= this.moreAlbums.totalCount(),
      albumCount: this.albumCount,
      onClickListener: this.onAlbumClickListener,
    });
  }

  @Builder
  MoreList() {
    Column() {
      List() {
        LazyForEach(this.moreAlbums, (item: AlbumSetDataInfo, index: number) => {
          ListItem(){
            this.AlbumMoreBuilder(item, index)
          }
          .padding({
            left: $r('sys.float.corner_radius_level4'),
            right: $r('sys.float.corner_radius_level4'),
          })
          .hoverEffect(HoverEffect.Highlight)
          .backgroundColor(this.hoverSelectUrl === item.data.uri && this.currentMode ===
          ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
          // HdsListItem({
          //   customItemBuilder: this.AlbumMoreBuilder.bind(this, item, index)
          // })
          //   .padding({
          //     left: $r('sys.float.corner_radius_level4'),
          //     right: $r('sys.float.corner_radius_level4'),
          //   })
          //   .hoverEffect(HoverEffect.Highlight)
          //   .backgroundColor(this.hoverSelectUrl === item.data.uri && this.currentMode ===
          //   ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
          //   .stateStyles({
          //     pressed: this.pressedStyles,
          //     focused: {
          //       .backgroundColor($r('sys.color.interactive_click'))
          //     },
          //     selected: {
          //       .backgroundColor($r('sys.color.comp_background_emphasize'))
          //     }
          //   })
          //   .key(`moreAlbum_${index}`)
          //   .borderRadius($r('sys.float.corner_radius_level8'))
          //   .onHover((isHover: boolean, event: HoverEvent): void => {
          //     this.getSelectUri(isHover, item.data.uri);
          //   })
        }, (item: AlbumSetDataInfo, index?: number) => {
          return this.getListItemCode(item, index);
        })
      }
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
      .listDirection(Axis.Vertical)
      .margin({
        bottom: this.isVerdeFoldable ? $r('sys.float.padding_level8') : $r('app.float.list_margin_bottom'),
      })
      .padding({
        top: $r('app.float.list_item_top_bottom_padding'),
        bottom: $r('app.float.list_item_top_bottom_padding'),
        left: $r('app.float.list_item_top_bottom_padding'),
        right: $r('app.float.list_item_top_bottom_padding'),
      })
      .divider({
        strokeWidth: '1px',
        color: $r('sys.color.ohos_fa_list_separator'),
        endMargin: $r('app.float.list_divider_end'),
        startMargin: $r('app.float.list_divider_start'),
      })
      .onAppear(() => {
        Log.info(TAG, 'recycle album column onAppear');
      })
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
    }
  }

  private isFinishedOrEmpty(): boolean {
    return this.isFinished || this.isEmpty;
  }

  private hasSourceAlbum(): boolean {
    return this.sourceCounts > 0 && !DeviceInfo.isEmulator() && this.isFinishedOrEmpty();
  }

  private hasMoreAlbum(): boolean {
    return this.moreAlbums.totalCount() > 0 && this.isFinishedOrEmpty();
  }

  // 方向变化监听
  onOrientationChanged() {
    Log.info(TAG, `onOrientationChanged isHorizontal: ${this.isHorizontal}`);
    this.calculateGridHeight();
  }

  // 分屏变化监听
  onSplitModeChanged() {
    Log.info(TAG, `onSplitModeChanged isSplitMode: ${this.isSplitMode}`);
    this.calculateGridHeight();
  }

  private onStatusBarHeightChanged(): void {
    Log.info(TAG, `onStatusBarHeightChanged: ${px2vp(this.statusBarHeight)}`);
    this.calculateGridHeight();
  }

  // 计算核心Grid部分高度
  calculateGridHeight() {
    Log.info(TAG, `calculateGridHeight isSplitMode: ${this.isSplitMode} isHorizontal: ${this.isHorizontal}
      IsFullScreen: ${getScreen().getIsFullScreen()}`);
    if (!DeviceInfo.isPhoneUx()) {
      this.gridHeight = Constants.PERCENT_100;
      return;
    }
    const naviBarHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.navigation_margin_bottom')));
    const winHeight: number = getScreen().getWinHeight();

    let msg: string[] = [`calculateGridHeight: winHeight: ${winHeight}`];
    msg.push(`Constants.ActionBarHeight: ${Constants.ActionBarHeight}`);
    msg.push(`naviBarHeight: ${naviBarHeight}`);
    const splitScreenScale: number = 3;
    if (this.isHorizontal) {
      // 手机横屏不显示 StatusBar，xxx横竖屏均显示
      const getStatusBarHeight = this.isFoldExpanded ? px2vp(this.statusBarHeight) : 0;
      this.gridHeight =
        winHeight - Constants.ActionBarHeight - naviBarHeight - Constants.ToolBarHeight_Horizontal - getStatusBarHeight;
      msg.push(`this.isHorizontal: ${this.isHorizontal}`);
      msg.push(`Constants.ToolBarHeight_Horizontal: ${Constants.ToolBarHeight_Horizontal}`);
      msg.push(`this.isFoldExpanded: ${this.isFoldExpanded}`);
      msg.push(`getStatusBarHeight: ${getStatusBarHeight}`);
    } else if (!DeviceInfo.isSmallFoldState() && getScreen().getWinMode() === WindowMode.PRIMARY &&
      this.windowTop < this.screenHeight / splitScreenScale) {
      this.gridHeight = winHeight - Constants.ActionBarHeight - Constants.ToolBarHeight - px2vp(this.statusBarHeight);
      msg.push(`this.isHorizontal: ${this.isHorizontal}`);
      msg.push(`Constants.ToolBarHeight: ${Constants.ToolBarHeight}`);
      msg.push(`px2vp(this.statusBarHeight): ${px2vp(this.statusBarHeight)}`);
    } else {
      this.gridHeight =
        winHeight - Constants.ActionBarHeight - naviBarHeight - Constants.ToolBarHeight -
        px2vp(this.statusBarHeight || getScreen().getStatusBarHeight());
      msg.push(`this.isHorizontal: ${this.isHorizontal}`);
      msg.push(`Constants.ToolBarHeight: ${Constants.ToolBarHeight}`);
      msg.push(`px2vp(this.statusBarHeight): ${px2vp(this.statusBarHeight || getScreen().getStatusBarHeight())}`);
    }
    msg.push(`gridHeight: ${this.gridHeight}`);
    Log.info(TAG, msg.join(', '));
  }

  private buildSmartItemKey(item: AlbumSetDataInfo, index?: number): string {
    if (!item || !item.data) {
      return (TAG + index) as string;
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  @Builder
  selectedModeBg() {
    Column()
      .height('100%')
      .width('100%')
      .border({ radius: $r('sys.float.corner_radius_level6') })
      .backgroundColor(this.isAlbumSetSelectedMode
        ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
  }

  @Builder
  isShowExpandMore() {
    Row() {
      if (this.sourceCounts > Constants.EXPAND_MORE_AMOUNT) {
        Text(this.message)
          .id('expandMore')
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize(Constants.TEXT_SIZE_BODY2)
          .textAlign(TextAlign.End)
          .margin({
            right: $r('app.float.list_item_right_icon2_margin_left'),
          })
        SymbolGlyph(this.expandMoreDownButton)
          .draggable(false)
          .fontSize($r('app.float.list_item_right_icon2_height'))
          .fontColor([$r('sys.color.icon_tertiary')])
          .animation(this.isActive ? {
            duration: Constants.SHOW_MORE_MENU_DURATION,
            curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
              Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING),
            tempo: this.animationTempo,
          } : null)
      }
    }
  }

  @Builder
  SourceListItemBuilder(item: AlbumSetDataInfo, index: number) {
    AlbumMore({
      item: item?.data,
      keyIndex: index,
      isSourceAlbumShow: index <= this.sourceAlbumSetDataSource.dataCount(),
      albumCount: this.albumCount,
      onClickListener: this.onAlbumClickListener,
    });
  }

  @Builder
  buildSourceListItem() {
    LazyForEach(this.sourceAlbumSetDataSource, (item: AlbumSetDataInfo, index: number) => {
      ListItem(){
        this.SourceListItemBuilder(item, index)
      }
      .padding({
        left: $r('sys.float.corner_radius_level4'),
        right: $r('sys.float.corner_radius_level4'),
      })
      .width('100%')
      .hoverEffect(HoverEffect.Highlight)
      .backgroundColor(this.hoverSelectUrl === item?.data?.uri && this.currentMode ===
      ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
      .stateStyles({
        pressed: this.pressedStyles,
        focused: {
          .backgroundColor($r('sys.color.interactive_click'))
        },
        selected: {
          .backgroundColor($r('sys.color.comp_background_emphasize'))
        }
      })
      .key(`fromAlbum_${index}`)
      .id(`fromAlbum_${index}`)
      .borderRadius($r('sys.float.corner_radius_level8'))
      .onHover((isHover: boolean, event: HoverEvent): void => {
        this.hoverSelectUrl = isHover ? item?.data?.uri : undefined;
      })
      // HdsListItem({
      //   customItemBuilder: this.SourceListItemBuilder.bind(this, item, index)
      // })
      //   .padding({
      //     left: $r('sys.float.corner_radius_level4'),
      //     right: $r('sys.float.corner_radius_level4'),
      //   })
      //   .width('100%')
      //   .hoverEffect(HoverEffect.Highlight)
      //   .backgroundColor(this.hoverSelectUrl === item?.data?.uri && this.currentMode ===
      //   ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
      //   .stateStyles({
      //     pressed: this.pressedStyles,
      //     focused: {
      //       .backgroundColor($r('sys.color.interactive_click'))
      //     },
      //     selected: {
      //       .backgroundColor($r('sys.color.comp_background_emphasize'))
      //     }
      //   })
      //   .key(`fromAlbum_${index}`)
      //   .id(`fromAlbum_${index}`)
      //   .borderRadius($r('sys.float.corner_radius_level8'))
      //   .onHover((isHover: boolean, event: HoverEvent): void => {
      //     this.hoverSelectUrl = isHover ? item?.data?.uri : undefined;
      //   })
    }, (item: AlbumSetDataInfo, index?: number) => {
      if (!item || !item.data) {
        return (TAG + index) as string;
      }
      return item.data.getHashCode() + index;
    })
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor(
        this.isAlbumSetSelectedMode ? $r('sys.color.ohos_id_color_list_card_bg') : $r('sys.color.interactive_click'))
    .borderColor($r('sys.color.comp_background_list_card'))
  }

  @Builder
  buildSourceListExpandMore() {
    Row() {
      this.isShowExpandMore();
    }
    .alignItems(VerticalAlign.Center)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick((): void => {
      this.onShowExpandMoreButtonClick();
    })
    .key(Constants.COMPONENT_KEY_EXPAND_MORE)
    .margin({
      top: $r('app.float.more_text_margin_bottom'),
      left: $r('app.float.more_text_margin_bottom'),
      right: $r('app.float.more_text_margin_bottom'),
      bottom: $r('app.float.buttonActionTextSize_horizontal'),
    })
    .hoverEffect(HoverEffect.Highlight)
    .borderRadius($r('sys.float.ohos_id_corner_radius_clicked'))
    .padding('4vp')
    .constraintSize({ minHeight: $r('app.float.default_padding_end') })
    .stateStyles({
      normal: {
        .backgroundColor(undefined)
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      }
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  SourceListBuilder() {
    if (this.sourceCounts > Constants.EXPAND_MORE_AMOUNT) {
      this.buildSourceListExpandMore();
    }
  }

  @Builder
  SourceList() {
    List() {
      ListItemGroup() {
        this.buildSourceListItem();
      }
      .divider({
        strokeWidth: '1px',
        color: $r('sys.color.ohos_fa_list_separator'),
        endMargin: $r('app.float.list_divider_end'),
        startMargin: $r('app.float.list_divider_start'),
      })
      .width('100%')
      ListItem(){
        this.SourceListBuilder()
      }

      // HdsListItem({
      //   customItemBuilder: this.SourceListBuilder.bind(this)
      // })
    }
    .alignListItem(ListItemAlign.Center)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
    .listDirection(Axis.Vertical)
    .padding({
      top: $r('app.float.list_item_top_bottom_padding'),
      bottom: this.sourceCounts > Constants.EXPAND_MORE_AMOUNT ? 0 : $r('app.float.list_item_top_bottom_padding'),
      left: $r('app.float.list_item_top_bottom_padding'),
      right: $r('app.float.list_item_top_bottom_padding'),
    })
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
  }

  @Builder
  buildSource() {
    if (this.hasSourceAlbum()) {
      GridItem() {
        this.SourceList();
      }
      .opacity(this.isAlbumSetSelectedMode ? Constants.MULTISELECT_SYSTEM_ALBUM_INFO_OPACITY :
        Constants.SYSTEM_ALBUM_INFO_OPACITY)
      .width('100%')
      .margin({
        top: DeviceInfo.isPc() ?
          $r('app.float.pc_source_list_margin_top') : $r('app.float.phone_source_list_margin_top')
      })
      .columnStart(0)
      .columnEnd(this.gridColumnsCount - 1)
      .key('SourceAlbum')
      .enabled(!this.isDraggingToPage)
    }
  }

  /**
   * 计算相册滑动条偏移量
   *
   * @param index
   * @param offset
   * @returns ComputedBarAttribute
   */
  private calcuScrollBarOffset(index: number, offset: number): ComputedBarAttribute {
    if (this.preScrollPosition.length > 0 && index !== this.preScrollPosition[0]) {
      this.preScrollPosition[0] = index;
      Log.info(TAG, `Enter calcuScrollBarOffset index:${index},offset:${offset}`);
    }
    // 系统、用户相册
    let normalAlbumBeginIndex: number = 0;
    let normalAlbumCount: number = this.albums.totalCount();
    let leftPadding: number =
      this.albumPageGridPaddingLeftAndRight + (this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.left);
    let rightPadding: number =
      this.albumPageGridPaddingLeftAndRight + (this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.right);
    let normalAlbumRectHeight: number =
      (getScreen().getWinLayoutWidth() - Constants.ALBUM_SET_GUTTER * (this.gridColumnsCount - 1) - leftPadding -
        rightPadding) / this.gridColumnsCount + Constants.ALBUM_NAME_HEIGHT * this.currentFontSizeScale +
      Constants.ALBUM_SET_MARGIN;
    Log.debug(TAG, `normalAlbumCount:${normalAlbumCount}, normalAlbumRectHeight:${normalAlbumRectHeight}`);

    // 分割线
    let dividerIndex: number = this.albums.totalCount();
    let dividerCount: number = 0;
    let dividerHeight: number = Constants.ALBUM_DIVIDER_HEIGHT;

    // 来源相册
    let sourceAlbumIndex: number = 0;
    let sourceAlbumCount: number = this.hasSourceAlbum() ? 1 : 0;
    let showCount: number =
      Math.min(this.sourceAlbumSetDataSource.dataCount(), this.sourceAlbumSetDataSource.getShowCount());
    let expandHeight: number = this.sourceAlbumSetDataSource.dataCount() > Constants.EXPAND_MORE_AMOUNT ?
      Constants.ALBUM_EXPAND_HEIGHT : Constants.LIST_PADDING_TOP_BOTTOM;
    let sourceAlbumRectHeight =
      showCount * Constants.MAIN_LIST_HEIGHT * this.currentFontSizeScale + expandHeight + Constants.COLUMN_MARGIN_SIX;
    Log.debug(TAG, `sourceAlbumCount:${sourceAlbumCount}, sourceAlbumRectHeight:${sourceAlbumRectHeight}`);

    // 更多相册
    let moreAlbumIndex: number = sourceAlbumIndex + sourceAlbumCount;
    let moreAlbumCount: number = this.hasMoreAlbum() ? 1 : 0;
    let moreAlbumRectHeight = this.moreAlbums.totalCount() * Constants.MAIN_LIST_HEIGHT * this.currentFontSizeScale +
      Constants.MORE_ALBUM_HEIGHT * this.currentFontSizeScale;
    Log.debug(TAG, `moreAlbumCount:${moreAlbumCount}, moreAlbumRectHeight:${moreAlbumRectHeight}`);

    let normalAlbumsHeight: number =
      Math.ceil(this.albums.totalCount() / this.gridColumnsCount) * normalAlbumRectHeight;
    let dividersHeight: number = dividerCount * dividerHeight;
    let sourceAlbumsHeight: number = sourceAlbumCount * sourceAlbumRectHeight;
    let moreAlbumsHeight: number = moreAlbumCount * moreAlbumRectHeight;
    Log.debug(TAG, `normalAlbumsHeight: ${normalAlbumsHeight}, dividersHeight: ${dividersHeight}, ` +
      `sourceAlbumsHeight: ${sourceAlbumsHeight}, ` +
      `moreAlbumsHeight: ${moreAlbumsHeight},`)

    let totalLength: number =
      normalAlbumsHeight + dividersHeight + sourceAlbumsHeight + moreAlbumsHeight;
    let totalOffset: number = 0;
    if (index < dividerIndex) {
      totalOffset = Math.floor(index / this.gridColumnsCount) * normalAlbumRectHeight;
    } else if (index === dividerIndex) {
      totalOffset = normalAlbumsHeight;
    } else if (index < sourceAlbumIndex) {
      totalOffset = normalAlbumsHeight + dividersHeight;
    } else if (index === sourceAlbumIndex) {
      totalOffset = normalAlbumsHeight + dividersHeight;
    } else if (index === moreAlbumIndex) {
      totalOffset = normalAlbumsHeight + dividersHeight + sourceAlbumsHeight;
    }
    totalOffset -= offset; // offset是负数
    Log.debug(TAG, `index:${index}, offset:${offset}, totalOffset:${totalOffset}, totalLength:${totalLength}`);
    return { totalOffset: totalOffset, totalLength: totalLength };
  }

  @State albumCardLargeHeight: number = 0;
  @StorageLink('winStatusMode') @Watch('PreviewStatusChange') winMode: window.WindowStatusType =
    ScreenManager.getInstance().windowStatusMode;

  private PreviewStatusChange(): void {
    if (this.currentFontSizeScale == Constants.FONT_SCALE_HEAVY_SIZE) {
      if (this.winMode == window.WindowStatusType.SPLIT_SCREEN) {
        this.albumCardLargeHeight = Constants.CARD_LARGE_SPLIT_SCREEN_HEIGHT;
      } else if (this.winMode == window.WindowStatusType.FLOATING) {
        this.albumCardLargeHeight = Constants.CARD_LARGE_FLOATING_SCREEN_HEIGHT;
      } else {
        this.albumCardLargeHeight = Constants.CARD_OTHER_SCREEN_HEIGHT;
      }
    } else if (this.currentFontSizeScale > Constants.FONT_SCALE_NORMAL_SIZE) {
      if (this.winMode == window.WindowStatusType.SPLIT_SCREEN) {
        this.albumCardLargeHeight = Constants.CARD_MIDDLE_SPLIT_SCREEN_HEIGHT *
          (this.currentFontSizeScale - 1);
      } else if (this.winMode == window.WindowStatusType.FLOATING) {
        this.albumCardLargeHeight = Constants.CARD_MIDDLE_FLOATING_SCREEN_HEIGHT *
          (this.currentFontSizeScale - 1);
      } else {
        this.albumCardLargeHeight = Constants.CARD_OTHER_SCREEN_HEIGHT *
          (this.currentFontSizeScale - 1);
      }
    } else {
      this.albumCardLargeHeight = 0;
    }
  }

  @Builder
  LocalAlbumSet() {
    Stack() {
      Grid(this.scroller, this.layoutOptions) {
        if (this.isVerdeFoldable) {
          GridItem() {
          }
          .height(Constants.ToolBarHeight_Horizontal)
        }

        if (this.isShowSdCard && this.cardNameUris && this.cardNameUris?.length > 0) {
          GridItem() {
            SdCardDataView({
              isHaveMore: this.isHaveMore,
              uris: this.cardNameUris,
              cardShowTitle: this.cardShowTitle,
              cardShowSubTitle: this.cardShowSubTitle,
            })
              .margin({
                bottom: $r('app.float.account_listcard_padding_top_and_bottom'),
              })
          }
        }

        LazyForEach(this.albums, (item: AlbumSetDataInfo | undefined, index: number) => {
          // 普通相册
          GridItem() {
            if (this.albumSetDataInfoCheck(item, index)) {
              if (this.selectedAlbumUri === item?.data?.uri) {
                Column() {
                }
                .width('100%')
                .aspectRatio(1)
                .key(String(index))
              } else {
                AlbumGridItemNewStyle({
                  isDraggingToPage: this.isDraggingToPage,
                  dataSource: this.albums,
                  isStopEvent: this.isStopEvent,
                  item: item?.data,
                  isSelected: this.isAlbumSetSelectedMode ?
                    this.mSelectManager.isItemSelected(item?.data?.uri) : false,
                  onMenuClicked: this.onMenuClickedFunc,
                  onMenuClickedForSingleItem: (action: Action, currentAlbum: AlbumInfo): void =>
                  this.onMenuClickedForSingleItem(action, currentAlbum),
                  keyIndex: index,
                  bottomHeight: $bottomHeight,
                  isShowHiddenGridView: this.isShowHiddenGridView,
                  mSelectManager: this.mSelectManager,
                  updateLongPressMenuList: (): void => this.updateLongPressMenuList(),
                  onEnterAlbumFunc: this.onEnterPhotoGridViewPageFunc,
                  onExitAlbumFunc: this.onExitPhotoGridViewPageFunc,
                  onClickListener: this.onAlbumClickListener,
                  albumContext: this.albumContext,
                  boxSelectStr: this.boxSelectStr,
                  boxDeselectStr: this.boxDeselectStr,
                  selectStr: this.selectStr,
                  deselectStr: this.deselectStr,
                  clickActionStr: this.clickActionStr,
                  albumCardLargeHeight: this.albumCardLargeHeight,
                })
                  .transition(TransitionEffect.opacity(TRANSITION_EFFECT_ALPHA))
                  .visibility(Visibility.Visible)
              }
            } else {
              Column() {
              }
              .width('100%')
              .aspectRatio(1)
              .key(String(index))
            }
          }
          .focusBox({
            strokeWidth: LengthMetrics.px(0),
          })
          .scale({ x: this.albumScale, y: this.albumScale })
          .zIndex((item?.data && this.selectedAlbumUri === item?.data?.uri) ? 1 : 0)
          .clip(false)
          .key(`Album_${index}`)
          .animation(this.enableAnimation ? {
            duration: this.gestureEnd ? Constants.albumStyleSwitchDuration : Constants.albumItemSmoothDuration,
              tempo: this.animationTempo,
              curve: this.gestureEnd ? Curve.Friction : Curve.Smooth,
          }: null)
          .transition(AnimationUtil.albumAnimation(this.judgeIsOpenTransitionAni()))
          .onAppear((): void => {
            if (this.drawnAlbumCount === 0) {
              this.drawnAlbumCount = Math.min(this.albums.getAlbumCount(), this.gridColumnsCount * 3);
              Log.info(TAG, `reportDrawnCompleted drawnAlbumCount: ${this.drawnAlbumCount}`);
            }
            if (this.drawnAlbumCount > 0) {
              this.drawnAlbumCount--;
              if (this.drawnAlbumCount === 0) {
                this.drawnAlbumCount = -1;
                this.drawnCompletedReport();
              }
            }
            this.isFinished = true;
          })
          .onKeyEvent((event: KeyEvent) => {
            Log.info(TAG, `type=${event.type}, keyCode=${event.keyCode}`);
            if (event.type === KeyType.Up) {
              if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_TAB ||
                event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT ||
                event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT ||
                event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_UP ||
                event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_DOWN
              ) {
                ShortCut.tabSelectedAlbum = item?.data;
              }
            }
          })
          .enabled(this.getAlbumIsEnabled(item?.data))
        }, (item: AlbumSetDataInfo, index?: number) => {
          if (!item || !item.data) {
            Log.info(TAG, `LazyForEach item or item.data not exist, key: ${(TAG + index) as string}`);
            return (TAG + index) as string;
          }
          return item.data.getHashCode();
        })
        if (this.isFinished || this.isEmpty) {
          // 来源相册
          // this.buildSource();

          // 重复照片相册
          if (this.isShowDuplicateAlbum) {
            this.buildDuplicateAlbum();
          }
          // 隐藏相册、回收站
          GridItem() {
            this.MoreList();
          }
          .opacity(this.isAlbumSetSelectedMode ? Constants.MULTISELECT_SYSTEM_ALBUM_INFO_OPACITY :
            Constants.SYSTEM_ALBUM_INFO_OPACITY)
          .width('100%')
          .columnStart(0)
          .columnEnd(this.gridColumnsCount - 1)
          .key('MoreAlbum')
          .enabled(!this.isDraggingToPage)

          if (this.isVerdeFoldable) {
            GridItem() {
            }.height(Constants.ToolBarHeight_Horizontal)
          }
        }
      }
      .onScrollBarUpdate((index: number, offset: number): ComputedBarAttribute => {
        if (this.isVerdeFoldable) {
          // 外屏不显示滑动条
          if (offset > 0 || (index === this.preScrollPosition[0] &&
            Math.abs(offset - this.preScrollPosition[1]) < Constants.VERDE_SLIDING_THRESHOLD)) {
            return { totalOffset: 0, totalLength: 0 }
          }
          if (this.isScrollDown(index, offset)) {
            this.tabbarShowController.setIsShowTabbar(false);
          } else {
            this.tabbarShowController.setIsShowTabbar(true);
          }
          this.preScrollPosition = [index, offset];
          return { totalOffset: 0, totalLength: 0 }
        }
        return this.calcuScrollBarOffset(index, offset);
      })
      .height(DeviceInfo.isPhoneUx() && !this.isVerdeFoldable ? this.gridHeight : Constants.PERCENT_100)
      .cachedCount(Constants.ALBUM_SET_CACHED)
      .onScrollStart((): void => {
        this.isGridScrolling = true;
        if (this.barState === BarState.Off) {
          this.barState = BarState.Auto;
        }
      })
      .onScrollStop((): void => {
        this.isGridScrolling = false;
      })
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .clip(false)
      .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
      .scale({ x: this.gridScale, y: this.gridScale })
      .padding({
        top: $r('app.float.album_set_page_padding_top'),
        bottom: (this.isShowTabBar || DeviceInfo.isPhoneUx() || this.isHorizontal) ? 0
          : (getScreen()
            .checkSplitOrFloatMode() ?
            $r('app.float.tab_bar_vertical_height') : $r('app.float.photo_browser_action_bar_cover_height')),
        left: this.albumPageGridPaddingLeftAndRight + (this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.left),
        right: this.albumPageGridPaddingLeftAndRight + (this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.right),
      })
      .margin({
        left: getScreen().getLeftSafePadding($r('sys.float.padding_level6'), false),
        right: getScreen().getRightSafePadding($r('sys.float.padding_level6'), false),
      })
      .animation(this.enableAnimation ? {
        duration: this.animationEnd ? Constants.albumStyleSmoothDuration : Constants.albumStyleSwitchDuration,
        tempo: this.animationTempo,
        curve: this.animationEnd ? Curve.Smooth : Curve.Friction,
        onFinish: this.gridScale === Constants.gridLargeAnimation ||
          this.gridScale === Constants.gridSmallAnimation ? () => {
          this.animationEnd = true;
          this.gridScale = Constants.gridDefaultScale;
        } : () => {
        }
      } : null)
      .columnsGap(DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level6'))
      .rowsGap(DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level6'))
      .scrollBar(this.isVerdeFoldable ? BarState.Off : this.barState)
      .priorityGesture(
        // 捏合手势
        PinchGesture({ fingers: 2 })// 手势识别成功回调
          .onActionStart((event: GestureEvent): void => {
            this.enableAnimation = true;
            this.gestureEnd = false;
            this.animationEnd = false;
            this.pinchTime = event.timestamp;
            // 捏合时不展示卡片
            this.isShowSdCard = false;
            // 清理已存在定时器
            clearTimeout(this.cloudCardTimerIdWithPinch);
          })// 手势移动过程中回调
          .onActionUpdate((event: GestureEvent) => {
            // 节流，超10ms刷一次
            if (event.timestamp -
            this.pinchTime < BrowserConstants.GESTURE_INTERVAL * DateUtil.MICROSECONDS_PER_SECOND) {
              return;
            }
          })// 手势识别成功，手指抬起后回/调
          .onActionEnd((event: GestureEvent): void => {
            // 捏合结束延时恢复卡片展示
            this.cloudCardTimerIdWithPinch = setTimeout((): void => {
              this.isShowSdCard = true;
              // 重置开启捏合动效
              this.enableAnimation = false;
            }, Constants.SYNC_CARD_DISPLAY_DELAY);
            this.gestureEnd = true;
            this.albumScale = Constants.albumLargeScale;
          })
      )
    }
  }

  private isScrollDown(index: number, offset: number): boolean {
    if (index > this.preScrollPosition[0]) {
      return true;
    }
    if (index == this.preScrollPosition[0]) {
      return offset < this.preScrollPosition[1];
    }
    return false;
  }

  // 相册是否置灰
  private getAlbumIsEnabled(album?: AlbumInfo): boolean {
    if (!album || this.isAlbumSetSelectedMode) {
      return true;
    }
    if (album.isUserCreatedAlbum) {
      return true;
    }
    return true;
  }

  /**
   * 重复照片相册
   */
  @Builder
  buildDuplicateAlbum() {
    GridItem() {
      Column() {
        List() {
          this.buildDuplicateAlbumSub()
        }
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius(DeviceInfo.isPc() ?
          $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
        .listDirection(Axis.Vertical)
        .padding({
          top: $r('app.float.list_item_top_bottom_padding'),
          bottom: $r('app.float.list_item_top_bottom_padding'),
          left: $r('app.float.list_item_top_bottom_padding'),
          right: $r('app.float.list_item_top_bottom_padding'),
        })
        .divider({
          strokeWidth: '1px',
          color: $r('sys.color.ohos_fa_list_separator'),
          endMargin: $r('app.float.list_divider_end'),
          startMargin: $r('app.float.list_divider_start'),
        })
        .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
      }.width('100%')
    }
    .opacity(this.isAlbumSetSelectedMode ? Constants.MULTISELECT_SYSTEM_ALBUM_INFO_OPACITY :
      Constants.SYSTEM_ALBUM_INFO_OPACITY)
    .width('100%')
    .key('DuplicateAlbum');
  }

  @Builder
  AlbumBuilder(item: AlbumSetDataInfo, index?: number) {
    AlbumMore({
      item: item.data,
      keyIndex: index,
      albumCount: this.albumCount,
    });
  }

  /**
   * 重复照片相册-处理huge_depth扫描问题拆分出的子级逻辑
   */
  @Builder
  buildDuplicateAlbumSub() {
    LazyForEach(this.getDuplicateAlbumDataSource(), (item: AlbumSetDataInfo, index?: number) => {
      ListItem(){
        this.AlbumBuilder(item, index)
      }
      // HdsListItem({
      //   customItemBuilder: this.AlbumBuilder.bind(this, item, index)
      // })
        .padding({
          left: $r('sys.float.corner_radius_level4'),
          right: $r('sys.float.corner_radius_level4'),
        })
    }, (item: AlbumSetDataInfo, index?: number) => this.buildSmartItemKey(item, index))
  }

  @Builder
  buildAlumSetContent() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      Column() {
        AlbumSetPageActionBar({
          onMenuClicked: this.onMenuClickedFunc,
          actionMoreMenuList: this.actionMoreMenuList,
        })
          .opacity(this.albumActionBarOpacity)
          .zIndex(1)

        if (this.isEmpty && this.isAlbumDataLoaded && this.isMoreEmpty &&
          !this.isTabBarShow && this.isSourceAlbumEmpty) {
          NoPhotoIndexComponent({ prop: EMPTY_ALBUMS, subTitle: this.subTitle })
        }
      }
      .accessibilityLevel('no')
      .zIndex(2)
      .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      .enabled(!this.isAnimating)

      if (!this.isEmpty || !this.isMoreEmpty || this.isTabBarShow || !this.isSourceAlbumEmpty) {
        Column() {
          this.LocalAlbumSet();
        }
        .zIndex(-1)
        .opacity(this.albumOpacity)
        .scale({ x: this.albumOtherScale, y: this.albumOtherScale })
        .layoutWeight(1)
      }

      if (this.isAlbumSetSelectedMode && !DeviceInfo.isGRLMStatus()) {
        AlbumSetPageToolBar({ onMenuClicked: this.onMenuClickedFunc })
          .zIndex(2)
          .visibility(!this.isHorizontal ? Visibility.Visible : Visibility.Hidden)
          .backgroundColor(Color.Transparent)
          .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      }
    }
    .id('AlumSetContent')
    .renderGroup(this.renderGroupFlag)
  }

  /*
    外屏相册构造函数
   */
  @Builder
  buildOutAlumSetContent() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.Top }) {
        // 相册宫格
        if (!this.isEmpty || !this.isMoreEmpty || this.isTabBarShow) {
          Column() {
            this.LocalAlbumSet();
          }
          .opacity(this.albumOpacity)
          .scale({ x: this.albumOtherScale, y: this.albumOtherScale })
          .layoutWeight(1)
          .height('100%')
        }

        // 工具栏
        if (this.isShowToolBar) {
          Column() {
            AlbumSetPageActionBar({
              onMenuClicked: this.onMenuClickedFunc,
              actionMoreMenuList: this.actionMoreMenuList,
            })
              .opacity(this.albumActionBarOpacity)

            if (this.isEmpty && this.isAlbumDataLoaded && this.isMoreEmpty && !this.isTabBarShow) {
              NoPhotoIndexComponent({ prop: EMPTY_ALBUMS, subTitle: this.subTitle })
                .height('100%')
            }
          }
          .transition(
            TransitionEffect
              .move(TransitionEdge.TOP)
              .animation({
                duration: this.isAlbumDataLoaded ? Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION : 0,
                curve: Curve.Friction,
              })
          )
          .height(Constants.ActionBarHeight)
          .accessibilityLevel('no')
          .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
          .enabled(!this.isAnimating)
        }
      }.height('100%')

      // 多选栏
      if (this.isAlbumSetSelectedMode) {
        AlbumSetPageToolBar({ onMenuClicked: this.onMenuClickedFunc })
          .visibility(!this.isHorizontal ? Visibility.Visible : Visibility.Hidden)
          .backgroundColor(Color.Transparent)
          .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      }
    }
    .height('100%')
    .id('OutAlumSetContent')
  }

  build() {
    Stack() {
      if (this.isVerdeFoldable) {
        this.buildOutAlumSetContent();
      } else {
        this.buildAlumSetContent();
      }

      CustomDialogView({ broadCast: $broadCast, deleteDialogIndex: this.deleteDialogIndex })
    }
    .height('100%')
    .accessibilityLevel('no')
    .visibility(this.isPageHidden)
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      this.calculateGridHeight();
    })
    .onAppear((): void => {
      Log.info(TAG, 'build Stack onAppear');
    })
  }

  private onMenuClickedForSingleItem(action: Action, currentAlbum: AlbumInfo): void {
    Log.info(TAG, `single menu click, action: ${action?.actionID}, ` +
      `currentAlbum: ${AlbumDefine.getAnonymizeAlbumName(currentAlbum?.albumName)}`);
    if (!currentAlbum) {
      Log.info(TAG, 'onMenuClickedForSingleItem return for currentAlbum.');
      return;
    }
    //
    let msg: Record<string, number | string | boolean | undefined> | undefined;
    if (action?.actionID == ActionID.DELETE_ALBUM) {
      msg = {
        'type': BigDataConstants.ALBUM_DELETE,
        'ALBUM_TYPE': currentAlbum?.subType,
      };
    } else if (action?.actionID == ActionID.NEW_ALBUM) {
      msg = {
        'type': BigDataConstants.ALBUM_ADD,
        'ALBUM_TYPE': currentAlbum?.subType,
      };
    } else if (action?.actionID == ActionID.RENAME) {
      msg = {
        'type': BigDataConstants.ALBUM_RENAME,
        'ALBUM_TYPE': currentAlbum?.subType,
      };
    }
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);

    let menuContext: MenuContext;
    if (action.actionID === Action.RENAME_ALBUM.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(false)
        .withAlbumInfo(currentAlbum)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onRenameOperationEnd())
        .withUIContext(getContext(this) as common.UIAbilityContext)
        .withBroadCast(this.broadCast);
      getContext()?.eventHub.on(BroadCastConstants.ALBUM_RENAME_ALBUM_TAB, this.albumRenameUpdateFunc);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetRenameMenuOperation, menuContext).doAction();
    } else if (action.actionID === Action.DELETE_ALBUM.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(false)
        .withAlbumInfo(currentAlbum as AlbumInfo)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => {
          this.resetViewModeAndSort(new Set([currentAlbum as AlbumInfo]));
          this.onOperationEnd(false);
        })
        .withBroadCast(this.broadCast);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetDeleteMenuOperation, menuContext).doAction();
    } else if (action.actionID === Action.MOVE_PHOTO.actionID) {
      this.routeToAddMediaPage(currentAlbum);
    }
  }

  private getSelectUri(isHover: boolean, index: string | undefined): void {
    this.hoverSelectUrl = isHover ? index : undefined;
  }

  private getListItemCode(item: AlbumSetDataInfo, index: number | undefined): string {
    if (!item || !item.data) {
      Log.info(TAG, 'getListItemCode return for item.');
      return (TAG + index) as string;
    }
    if (item.data.mediaItem) {
      Log.info(TAG, 'getListItemCode return for item.data.mediaItem.');
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  private routeToAddMediaPage(currentAlbum: AlbumInfo): void {
    Log.info(TAG, 'routeToAddMediaPage');
    const params: SelectParams = new SelectParams();
    params.bundleName = Constants.PHOTO_BUNDLE_NAME;
    params.isMultiPick = true;
    params.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
    params.isFirstEnter = true;
    params.maxSelectCount = Constants.LIMIT_MAX_THIRD_SELECT_COUNT;
    params.uri = '';
    params.cameraAble = false;
    params.editAble = false;
    params.albumName = currentAlbum?.isSystemAlbum ?
      (UiUtil.getResourceStringSync(currentAlbum.albumName as Resource)) : (currentAlbum.albumName as string);
    params.albumUri = currentAlbum.uri;
    params.isNewAlbum = false;
    params.isFromAlbumSetPage = true;

    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PICKER_BASE_PAGE]).then(() => {
      this?.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_PICKER_BASE_PAGE, params), false);
    });
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION }).opacity(0);
    PageTransitionExit({ duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION }).opacity(0);
  }

  private showNotify(): void {
    if (this.needNotify) {
      UiUtil.showToast($r('app.string.distributed_album_disconnected'));
      this.needNotify = false;
    }
  }

  @Builder
  LongPressMenuBuilder(item: AlbumInfo) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      Menu() {
        ForEach(this.longPressMenuList, (action: Action, index: number) => {
          MenuItem({ content: action.textRes }) {
          }
          .contentFont({ weight: 'medium' })
          .key(`Album_LongPress_${action.componentKey}`)
          .onClick((): void => {
            if (action === Action.MULTISELECT) {
              this.onMenuClicked?.(action, []);
              this.onSelect(item?.uri, true, item?.isSystemAlbum || item?.isSourceAlbum,
                item?.isSystemAlbum || item?.isSourceAlbum, (): void => {
                  Log.info(TAG, 'album select callback');
                  this.broadCast.emit(Constants.UPDATE_SELECTED, [true, item?.uri]);
                });
            } else {
              this.onMenuClickedForSingleItem?.(action, item);
            }
          })
        })
      }
      .menuItemDivider({
        strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
        endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
      })
      .width($r('app.float.more_menu_width'))
      .radius($r('sys.float.corner_radius_level10'))
      .key('AlbumSetPage_Menu')
    }
  }

  private drawnCompletedReport(): void {
    //冷启动打点上报
    let reportLabel: string = Global.getString('appStartDrawnCompletedReportLabel');
    let reportTaskId: number = Global.getNumber('appStartDrawnCompletedReportTaskId');
    if (reportLabel !== '' && Number.isFinite(reportTaskId)) {
      let context: common.UIAbilityContext | undefined =
        LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
      if (canIUse('SystemCapability.Ability.AbilityRuntime.Core')) {
        context?.reportDrawnCompleted((): void => {
        });
      }
      hiTraceMeter.finishTrace(reportLabel + reportTaskId, reportTaskId);
      Global.deleteString('appStartDrawnCompletedReportLabel');
      Global.deleteString('appStartDrawnCompletedReportTaskId');
      Log.info(TAG, 'reportDrawnCompleted albumSetPage');
    }
  }

  onGeometryAnimation(): void {
    Log.debug(TAG, `onGeometryAnimation isDoingAnimating:${this.isDoingGeometryTransitionAnimation}
      isShowPhotoGridView:${this.isShowPhotoGridView}`);
    if (this.isDoingGeometryTransitionAnimation) {
      // 开始进入/退出宫格，显示相册
      this.isPageHidden = Visibility.Visible;
    } else {
      // 动效结束隐藏宫格, 减少冗余渲染
      this.isPageHidden = this.isShowPhotoGridView ? Visibility.Hidden : Visibility.Visible;
      Log.info(TAG, `animation finished, this.isPageHidden: ${this.isPageHidden}`);
    }
  }

  private onAlbumOpacityChanged(): void {
    Log.info(TAG, 'albumActionBarOpacity: ' + this.albumActionBarOpacity + ', albumOpacity: ' + this.albumOpacity +
      ', this.isPageHidden: ' + this.isPageHidden);
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    this.updateLayoutOptions('onFoldDisplayModeChanged');
  }

  private onIsVerdeFoldableChanged(): void {
    this.updateActionMoreMenuList();
    this.refreshActionMoreMenuListByUserAlbum(this.albums.hasUserAlbum());
  }

  /**
   * 根据是否存在用户自定义相册，刷新【多选】按钮是否显示
   *
   * @param hasUserAlbum 是否用户自定义相册数量
   */
  private refreshActionMoreMenuListByUserAlbum(hasUserAlbum: boolean): void {
    /* instrument ignore next */
    Log.info(TAG, `AlbumSetPage refreshActionMoreMenuListByUserAlbum userAlbumCount: ${hasUserAlbum}`);
    let indexOfMulti = this.actionMoreMenuList.indexOf(Action.MULTISELECT);
    if (hasUserAlbum && indexOfMulti === Constants.INVALID) {
      // 将【多选】按钮添加到第一个
      this.actionMoreMenuList.unshift(Action.MULTISELECT);
    } else if (!hasUserAlbum && indexOfMulti !== Constants.INVALID) {
      // 将【多选】按钮删除
      this.actionMoreMenuList.splice(indexOfMulti, 1);
    }
  }

  /**
   * 当屏幕属性（dpi、横竖屏切换等）变化时触发，判断dpi（即系统设置的显示大小）变化时会刷新getScreen()的尺寸
   *
   * @param id 屏幕id
   */
  private onSystemScreenChange(id: number): void {
    Log.info(TAG, `onSystemScreenChange begin, screenId = ${id}`);
    let displayClass: display.Display = display.getDefaultDisplaySync();
    if (!displayClass) {
      Log.info(TAG, `onSystemScreenChange return in displayClass.`);
      return;
    }
    if (this.densityDpi !== displayClass.densityDPI) {
      Log.info(TAG, `onSystemScreenChange exec this.densityDpi: ${this.densityDpi}, displayClass.densityDPI: ${
      displayClass.densityDPI}`);
      this.densityDpi = displayClass.densityDPI;

      // 当系统设置修改显示大小时，如果图库应用显示了，需要立即刷新
      getScreen().updateSize();

      // 当系统设置修改显示大小时，图库界面没有显示，这时候需要设置变量标记，待进入图库时再触发刷新（因为这时候新的dpi对图库还没生效）
      this.isDensityDpiChange = true;
    }
  }

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG, `currentFontSizeScaleChange listPaddingTopAndBottom: ${this.listPaddingTopAndBottom}`);
    this.PreviewStatusChange();
  }

  /**
   * 当是否显示重复照片标记变化时
   */
  private onShowDuplicateChange(): void {
    console.log(`onShowDuplicateChange isShowDuplicateAlbum = ${this.isShowDuplicateAlbum}`);
    // 将相册首页多一个重复相册显示为整行
    this.updateLayoutOptions('onShowDuplicateChange');
    // 在显示重复照片相册时才初始化重复照片datasource，并注册重复照片observer，避免未显示时也绑定了进行无效查询
    this.getDuplicateAlbumDataSource();
  }

  /**
   * 获取重复照片相册dataSource，获取前先判断是否初始化，如果没有初始化，先初始化
   *
   * @returns 重复照片相册dataSource
   */
  private getDuplicateAlbumDataSource(): DuplicateAlbumDataSource {
    if (this.duplicateAlbumDataSource === undefined) {
      this.duplicateAlbumDataSource = new DuplicateAlbumDataSource(new BroadCast());
      this.duplicateAlbumDataSource.registerAlbumObserver();
    }
    return this.duplicateAlbumDataSource;
  }

  private isActiveChanged(): void {
    Log.info(TAG, `isActiveChanged: ${this.isActive}`);

    if (!this.isActive) {
      this.onInActive();
      return;
    }
    this.onActive();
    if (this.isVerdeFoldable) {
      this.tabbarShowController.setIsShowTabbar(true);
    }
    this.moreAlbums.loadData();
    // 移动到页面DataSource独立之后，可以删除下一行代码
    this.albums.onDataReloaded();
  }

  private registerWindowChangedListener() {
    window.getLastWindow(getContext(this), (err: BusinessError, data) => {
      try {
        data.on('windowRectChange', this.updateGridHeightFunc);
      } catch (error) {
        Log.error(TAG, `register windowSizeChange window error: ${err}, code: ${err?.code}`);
      }
    });
  }

  private updateGridHeight(data: window.RectChangeOptions) {
    if (!data) {
      return;
    }
    this.screenHeight = ScreenManager.getInstance().getDisScreenHeight();
    Log.info(TAG, `get window top = ${data.rect.top}, left = ${data.rect.left},width = ${data.rect.width},` +
      `height = ${data.rect.height} screenHeight =  ${this.screenHeight}`);
    this.windowTop = data.rect.top;
    if (this.lastWindowTop !== this.windowTop) {
      this.calculateGridHeight();
      this.lastWindowTop = this.windowTop;
    }
  }

  private destroyWindowChangedListener() {
    window.getLastWindow(getContext(this), (err: BusinessError, data) => {
      try {
        data.off('windowRectChange', this.updateGridHeightFunc);
      } catch (error) {
        Log.error(TAG, `windowSizeChange destroy window error: ${err}, code: ${err?.code}`);
      }
    });
  }
}
