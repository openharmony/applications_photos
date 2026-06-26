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

import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BrowserController, Params } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy uriPermissionManager from '@ohos.application.uriPermissionManager';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { EmptyPageProp, NoPhotoIndexComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoIndexComponent';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { RecoverController } from '../utils/recoverScene/RecoverController';
import lazy {
  SelectParams,
  SingleSelectionMode,
  SelectConstants
} from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { SelectUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/SelectUtil';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { UiUtil, CurrentRowOffset } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Verify } from '@ohos/common/src/main/ets/default/utils/Verify';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { ThirdSelectedPanel } from './ThirdSelectedPanel';
import lazy { PickerMediaDataSource } from '../common/PickerMediaDataSource';
import lazy { ThirdBrowserDataSource } from '../common/ThirdBrowserDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { MediaItemUtil } from '@ohos/common/src/main/ets/default/utils/MediaItemUtil';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy {
  FormConstants,
  IS_HORIZONTAL,
  IS_SPLIT_MODE,
  LEFT_BLANK,
  THIRD_SELECT_IS_ORIGIN,
  ThirdSelectConstants
} from '../utils/ThirdSelectConstants';
import lazy { ThirdSelectAlbumListBase } from './ThirdSelectAlbumListBase';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy window from '@ohos.window';
import lazy { curves, display, LengthMetrics, uiExtension, uiExtensionHost } from '@kit.ArkUI';
import lazy { SearchSwitchManager } from '@ohos/common/src/main/ets/default/model/SearchSwitchManager';
import lazy {
  ItemRestriction,
  SegmentButton,
  SegmentButtonOptions,
  SegmentButtonTextItem
} from '@ohos.arkui.advanced.SegmentButton';
import lazy { ThirdSelectAlbumGridBase } from './ThirdSelectAlbumGridBase';
import lazy { PickerDataImplAsync } from '../common/PickerDataImplAsync';
import lazy { CustomTheme } from '@ohos.arkui.theme';
import lazy { DefaultThemeColor } from '../common/DefaultThemeColor';
import lazy {
  AlbumThirdSelectDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumThirdSelectDataSource';
import lazy HashMap from '@ohos.util.HashMap';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PickerOrientation, PreselectedInfo, BadgeType } from '@ohos.file.PhotoPickerComponent';
import lazy { BusinessError } from '@ohos.base';
import lazy { ValueType } from '@kit.ArkData';
import lazy { AppPresenceStatus, PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { SelectionChecker } from '../model/SelectionChecker';
import lazy { AlbumChecker } from '../model/AlbumChecker';
import lazy { PickerViewWarningDialog } from '@ohos/common/src/main/ets/default/view/dialog/PickerViewWarningDialog';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { SavePhotosManager } from '../manager/SavePhotosManager';
import lazy { ThirdSelectedPageActionBar } from './ThirdSelectedPageActionBar';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { MaskLayerUtils } from '../utils/MaskLayerUtils';
import lazy { PhotoPickerMaskLayer } from './PhotoPickerMaskLayer';
import lazy { PickerPhotoGridController } from '../thirdselectphoto/viewcontroller/PickerPhotoGridController';
import lazy { commonEventManager } from '@kit.BasicServicesKit';
import lazy { PickerCloseButton } from './PickerCloseButton';
import lazy { PickerThumbnailCreator } from '../utils/PickerThumbnailCreator';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { HashSet } from '@kit.ArkTS';

/* instrument ignore file */
const TAG: string = 'ThirdSelectPhotoGridBase';

const EMPTY_PICKER: EmptyPageProp = {
  illustration: $r('app.media.photo_empty'),
  title: $r('app.string.no_photo_head_title_timeline'),
  subTitle: $r('app.string.no_photo_sub_title_timeline'),
  extraInfo: 'ThirdSelectPhotoGridBase',
  hasBarSpace: true,
};
const PICKER_TRANSITIONS_ANIMATE_DURATION: number = 200;
const PICKER_CURVES_SPRING_MOTION_RESPONSE: number = 0.314;
const PICKER_CURVES_SPRING_MOTION_FRACTION: number = 0.95;
const COMPONENT_KEY_ADD_HIGHLIGHT: string = 'addHighlight'; // 时刻新增照片
const COMPONENT_KEY_COVER_HIGHLIGHT: string = 'CoverHighlight'; // 时刻更换封面
const SEGMENT_PHOTO_INDEX: number = 0;
const SEGMENT_ALBUM_INDEX: number = 1;
const RECOMMEND_TAB_INDEX: number = 1;
let subscriber:commonEventManager.CommonEventSubscriber;

export class SelectInfo {
  public position: number = 0;
  public uri: string = '';
  public selectState: boolean = false;
  public callback: Function = (isSelected: boolean): void => {
  };
  public item: MediaItem | undefined = undefined;
  public state: number = 0; // 0代表未授权, 1代表已授权, 2代表已发送数据
}

export interface ThirdSelectGridListener {
  onCompleted?: (items: MediaItem[]) => void;
  onCompletedWithUris?: (uris: string[]) => void;
  onCancelled?: () => void;
}

interface SelectJumpParams {
  showCancel: boolean,
  name: string,
  item: MediaItem,
};

enum  badgeConfigOptionType {
  SET_DATA = 1,
  ADD_DATA = 2,
  DELETE_DATA = 3,
};

@Observed
export class ThirdSelectGridController {
  /**
   * 是否代理所有行为（complete、cancel等），即把后续的处理任务权移交
   */
  public hasDelegate: boolean = false;
  private readonly listeners: ThirdSelectGridListener[] = [];

  public register(listener: ThirdSelectGridListener): void {
    if (this.listeners.indexOf(listener) >= 0 || !listener) {
      return;
    }
    this.listeners.push(listener);
  }

  public onCompleted(items: MediaItem[]): void {
    this.listeners.forEach((listener: ThirdSelectGridListener) => listener.onCompleted?.(items));
  }

  public onCompletedWithUris(uris: string[]): void {
    this.listeners.forEach((listener: ThirdSelectGridListener) => listener.onCompletedWithUris?.(uris));
  }

  public onCancelled(): void {
    this.listeners.forEach((listener: ThirdSelectGridListener) => listener.onCancelled?.());
  }
}
export interface JumpBrowserOptions<T> {
  /**
   * 是否展示取消符号
   */
  readonly showCancel: boolean;

  /**
   * 页面名称
   */
  readonly name: string;

  /**
   * 媒体文件信息
   */
  readonly item: MediaItem;

  /**
   * 坐标index信息
   */
  readonly geometryTapIndex: number;

  /**
   * 坐标标识符
   */
  readonly geometryTransitionString: string;
}

/**
 * Third Select Album Page
 */
@Component
export struct ThirdSelectPhotoGridBase {
  private userId = -1;
  private replaceUriManager: ReplaceUriManager | undefined = undefined;
  private navPageInfos: NavPathStack = new NavPathStack();
  private readonly PHONE_HORIZONTAL_SHEET_WIDTH: number = 480;
  @State @Watch('onPageHiddenChanged') isPageHidden: Visibility = Visibility.Visible;
  @State @Watch('onSelectCountChanged') selectedCount: number = 0;
  @Consume isSelectedMode: boolean;
  @State @Watch('onMoreMenuListChanged') private moreMenuList: Action[] = [];
  @Provide rightClickMenuList: Action[] = [];
  @Provide longPressMenuList: Action[] = [];
  private photoDataImpl: PhotoDataImpl = new PickerDataImplAsync();
  private inputDataSource: PickerMediaDataSource | undefined
  private dataSource: PickerMediaDataSource =
    new PickerMediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.photoDataImpl);
  @Consume broadCast: BroadCast;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @Consume isShow: boolean;
  public selectManager: ThirdSelectManager | undefined = undefined;
  private storage: LocalStorage | undefined = undefined;
  public isActive = false;
  @State isGestureSliding: boolean = false;
  @State @Watch('onTitleChanged') title: string = '';
  @State @Watch('onIsEmptyChanged') isEmpty: boolean = false;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: number[] = getScreen().getLeftBlank();
  @StorageLink(IS_HORIZONTAL) @Watch('watchIsHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  public DEFAULT_TOAST_DURATION = 2000;
  @State @Watch('updateIsFoldable') gridRowCount: number = 0;
  @State @Watch('updateIsFoldable') gridColCount: number = 0;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State @Watch('onIsVerdeFoldableChanged') private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State isShowScrollBar: boolean = false;
  @State isVisibleScrollBar: boolean = false;
  @Provide isShowBar: boolean = true;
  public scroller: Scroller = new Scroller();
  public isFirstEnter: boolean = false;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  public backFuncBinder: Function | undefined = undefined;
  @State selectParams: SelectParams = SelectParams.defaultParam();
  @State screenHeight: number = getScreen().getWinHeight();
  @State isAllMediaAlbum: boolean = true;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  private isImageDownloading: boolean = false;
  @LocalStorageLink('placeholderIndex') placeholderIndex: number = -1;
  @LocalStorageLink('geometryTransitionBrowserId') @Watch('onGeometryIdChange')
  public geometryTransitionBrowserId: string = '';
  private geometryTransitionUri: string = '';
  @ObjectLink @Watch('onBrowserControllerChanged') browserController: BrowserController;
  @State private subTitle: Resource | string = $r('app.string.no_photo_sub_title_timeline');
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private dataObserver: CommonObserverCallback | undefined = new CommonObserverCallback(this);
  private isReportSmartRecommendData: boolean = false;
  private itemId: string = '';
  private isItemIdChange: boolean = false;
  @LocalStorageLink('showCancel') showCancel: boolean = true;
  @StorageLink('loadedSize') loadedSize: number = 0;
  @State isReScrollAfterGetAnchor: boolean = false;
  @State isReScrollAfterDataLoaded: boolean = false;
  @Provide uriResult: string = '';
  @Provide @Watch('onAlbumsShowChanged') albumsShow: boolean = false;
  private currentSelectedAlbumId: string = '';
  private isPhotoInner: boolean = false;
  private cancelFunc: Function | undefined = undefined;
  private okFunc: Function | undefined = undefined;
  private isNeedFilterSourceAlbum: boolean = false;
  private sourceAlbumUri: string = '';
  private isSetOriginal: boolean = false;
  private isJumpBrowserBySelected: boolean = false;
  @State gridItemWidth: number = 0;
  @State gridItemHeight: number = 0;
  // 滚动行数历史
  private lastRow: number = -1;
  private lastCol: number = -1;
  // 是否启用了搜索功能
  @State isSearchEnabled: boolean = true;
  // 搜索界面是否可见
  @State isSearchVisible: boolean = false;
  @State isRecommendListVisible: boolean = true;
  // 搜索无结果时为true，包括搜索结果无匹配的图片/视频，或者本身图库就为空
  @Provide isSearchNoResultPageVisible: boolean = false;
  @Consume displaySearchWords: string;
  @Link searchKeyword: string;
  private panelId: string = 'ThirdSelectPhotoGridBase';
  private funcOnSelectCallback: Function = (position: number, key: string,
    value: boolean, callback: Function): void => {
    this.onSelectCallback(position, key, value, callback);
  };
  private funcOnCameraSelectCallback: Function = (position: number, key: string,
    value: boolean, callback: Function, mediaItem?: MediaItem): void => {
    this.onSelectCallback(position, key, value, callback, mediaItem);
  };
  private funcJumpBrowserCallback: Function = (
    showCancel: boolean, name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, isSelectMode = false, isFromGridItem: boolean
  ): void => {
    this.isJumpBrowserBySelected = false;
    this.jumpBrowserCallback(showCancel, name, item, geometryTapIndex, geometryTransitionString, isSelectMode,
      isFromGridItem);
  };
  private funcJumpBrowserBySelected: Function = (
    params: SelectJumpParams, geometryTapIndex: number,
    geometryTransitionString: string, isSelectMode = false
  ): void => {
    this.isJumpBrowserBySelected = true;
    this.jumpBrowserCallback(params.showCancel, params.name, params.item, geometryTapIndex, geometryTransitionString,
      isSelectMode);
  };
  private funcUpdateSystemUiOnEditorExit: Function = (): void => this.updateSystemUiOnEditorExit();
  private funcOnLoadingFinished: Function = (size: number): void => this.onLoadingFinished(size, true);
  private funcOnReloadFinishedCallback: Function = (): void => this.onReloadFinishedCallback();
  private photoGridNum: number = Constants.PICKER_DEFAULT_GRID_ROW_COUNT;
  private param?: SelectParams;
  @ObjectLink @Watch('onActionBarControllerChanged') actionBarController: ActionBarController;
  public defaultGridNum: number = 4;
  public minDpNum: number = 360;
  public menuWidthRatio: number = 0.4;
  @State isFoldable: boolean = DeviceInfo.isFoldable();
  @State private winHeight: number = 0;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State isNeedTransition: boolean = false;
  @Provide albumYOffset: number = 0;
  private isDoRecommendTabAnimation: boolean = false;
  private currentSelectUri: string = '';
  private currentSelectPosition: number = 0;
  private currentSelectStatus: boolean = false;
  private currentCallback: Function = (): void => {
  };
  @LocalStorageLink('pickerBrowsertTitle') pickerBrowsertTitle: string = '';
  private selectInfoList: SelectInfo[] = [];
  @State tabOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: $r('app.string.pictures_and_videos') }, {
      text: $r('app.string.all_albums'),
    }] as ItemRestriction<SegmentButtonTextItem>,
    selectedBackgroundColor: $r('sys.color.comp_background_list_card'),
    fontWeight: FontWeight.Medium,
    selectedFontWeight: FontWeight.Medium,
    buttonPadding: {
      top: '9.6vp',
      bottom: '9.6vp',
    }
  })
  @State @Watch('tabSelectedIndexesChange') tabSelectedIndexes: number[] = [0];
  @State private controller: ThirdSelectGridController = new ThirdSelectGridController();
  @State pickerPhotoGridController: PickerPhotoGridController =
    new PickerPhotoGridController(getContext(this), LocalStorage.getShared());
  @Provide @Watch('onNavPathStackChange') pageInfo: NavPathStack = new NavPathStack();
  // 图片和视频页缓存param
  private cachedParam?: SelectParams = new SelectParams();
  private initGridRowOrColCountFunc: Function = (): void => {
    if (!this.isHorizontalPickerOrientation()) {
      this.initGridRowCount();
    } else {
      this.initGridColCount();
    }
  };
  private onSwitchThirdAlbumFunc: Function = (params: SelectParams): void => this.onSwitchThirdAlbum(params);
  private funcOnAlbumGirdCloseCallback: Function = (): void => this.onAlbumGirdClose();
  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State private searchBarAndCapsuleOpacity: number = 1;
  private onFirstDataInitCallBackFunc: Function = (): void => this.onFirstDataInitCallBack();
  private searchController: SearchController = new SearchController();
  private isOnItemClickedSet: boolean = false;
  private colorTheme: CustomTheme = {};
  // 获取相册信息，主要是相册名称
  private albums: AlbumThirdSelectDataSource | undefined = undefined;
  private onThirdSelectAlbumPhotosUpdateFunc: Function = (size: number): void => {
    if (this.selectParams.isFromPickerView && this.selectParams.searchAble) {
      this.onThirdSelectAlbumPhotosUpdate(size);
    }
  }
  private allAlbumInfoMap: HashMap<string, AlbumInfo> = new HashMap<string, AlbumInfo>();
  @State private tempAlbumUri: string = '';
  @State private isRefreshSelectState: boolean = false;
  private photoPermissionMap: HashMap<string, number> = new HashMap<string, number>();
  private previewJumpBrowserCallbackFunc: Function = (
    showCancel: boolean, name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, photoBrowserRange: number, isAcrossAlbum?: boolean,
  ): void => {
    this.previewJumpBrowserCallback(showCancel, name, item, geometryTapIndex, geometryTransitionString,
      photoBrowserRange, isAcrossAlbum);
  };
  private previewExitBrowserCallbackFunc: Function = (inDynamicEffect: boolean): void => {
    Log.info(TAG, `previewExitBrowserCallbackFunc inDynamicEffect: ${inDynamicEffect}`)
    this.inDynamicEffect = inDynamicEffect;
  };
  @State private layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
  };
  @StorageLink('isShowPickerWarnDialog') @Watch('onShowPickerWarnDialogChanged')
  private isShowPickerWarnDialog: Boolean = false;
  @StorageLink('isShowPickerViewWarnDialog') @Watch('onShowPickerWarnDialogChanged')
  private isShowPickerViewWarnDialog: Boolean = false;
  private savePhotosManager: SavePhotosManager = new SavePhotosManager();

  private onShowPickerWarnDialogChanged(): void {
    Log.info(TAG, 'onShowPickerWarnDialogChanged, isShowPickerWarnDialog = ' + this.isShowPickerWarnDialog +
      ', isShowPickerViewWarnDialog = ' + this.isShowPickerViewWarnDialog + ', isFromPickerView = ' +
    this.selectParams.isFromPickerView + ', bundleName = ' + this.param?.bundleName);
    if (this.isShowDialog()) {
      this.layoutOptions.irregularIndexes = [0];
    } else {
      this.layoutOptions.irregularIndexes = [];
    }
  }

  private selectionChecker: SelectionChecker | undefined = undefined;
  private albumChecker: AlbumChecker | undefined = undefined;
  private inDynamicEffect: boolean = false;
  @State private totalCount: number = 0;
  @State maskLayerUtils: MaskLayerUtils = MaskLayerUtils.getInstance();
  @State isPickerMaskLayerShow: boolean = false;
  @State isEnterAlbums: boolean = false;
  private pickerSidebarContentWidth: number = 0;
  @State isFirstOnAreachange: boolean = false;
  private isShowDialog(): boolean {
    let result = (this.isShowPickerWarnDialog && !this.selectParams.isFromPickerView) ||
      (this.isShowPickerViewWarnDialog && this.selectParams.isFromPickerView) &&
        this.isShowDialogUnderLayout();
    Log.debug(TAG, `isShowDialog: result = ${result}`);
    return result;
  }
  private isCombinedMediaTypeFilterError: boolean = false;
  public setReceiveInterval: number = -1;
  @State badgeConfigUrisSet: Set<string> = new Set<string>();
  @State badgeType: BadgeType | undefined = undefined;
  private badgeConfigReceiveSet: Set<string> = new Set<string>(); // 触发更新
  private maxBadgeConfigSize: number = 200000; // 最大badgeConfigUri大小
  private badgeConfigOptionType: badgeConfigOptionType | undefined = undefined; // 标记操作类型
  @State badgeConfigUpdate: boolean = false;
  @State stateMachine: PhotoBrowserStateMachine = new PhotoBrowserStateMachine();
  private browserDataSource: ThirdBrowserDataSource = new ThirdBrowserDataSource(this.stateMachine);

  /**
   * 大图切换回调。将目标资源所在的宫格缩略图组件滚动至视窗内，保证大图过渡动画
   * @param newIndex 新的placeholderIndex
   * @param showWarnDialogOffset 是否展示顶部安全提示
   * @param showCameraGridItem 是否展示相机宫格
   */
  private onPlaceholderChanged = (newIndex: number, showWarnDialog?: boolean, showCameraGridItem?: boolean) => {
    Log.debug(TAG, `[GeometryLogger] onPlaceholderChanged newIndex ${newIndex}`);
    if (!this.isHorizontalPickerOrientation()) {
      const offset: CurrentRowOffset = {
        row: showWarnDialog ? 1 : 0,
        col: showCameraGridItem ? 1 : 0
      }
      // 优化滚动功耗
      const curRow = UiUtil.getCurrentRow(newIndex, this.dataSource, this.gridRowCount, this.lastRow, offset);

      if (typeof curRow === 'number') {
        const scrollTargetIndex = newIndex + offset.col + offset.row;
        this.scroller.scrollToIndex(scrollTargetIndex);
        this.lastRow = curRow;
        Log.debug(TAG, `onPlaceholderIndexChanged, new Index: ${newIndex}, curRow: ${curRow}, showWarnDialog: ${
        showWarnDialog}, showCameraGridItem: ${showCameraGridItem}, scrollTarget: ${scrollTargetIndex
        }, last row: ${this.lastRow}`);
      }
    } else {
      const curCol = UiUtil.getCurrentCol(newIndex, this.dataSource, this.gridColCount, this.lastCol);
      if (curCol) {
        this.scroller.scrollToIndex(newIndex);
        this.lastCol = curCol;
      }
    }
    UiUtil.emitByPlaceholderIndex(newIndex, this.dataSource, this.broadCast, 'ThirdSelectAlbumGridBase');
  }

  /**
   * 大图关闭，清除行数历史
   */
  private clearScrollHistory = () => {
    Log.info(TAG, 'clearScrollHistory');
    this.lastRow = -1;
  }

  /**
   * 在PhotoGridBase的selectParams参数初始化后，AlbumGridBase组件初始化前，如果parseContextRecoveryInfo()获取锚点信息后，发送UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR广播，
   * 则AlbumGridBase无法通过广播更新hasGotRecoverAnchor和dataIndexForRecover的值，导致无法进行现场恢复。
   * 因此在PhotoGridBase中需要添加广播，用于更新hasGotRecoverAnchor和dataIndexForRecover的值。
   * 确保AlbumGridBase组件初始化时，如果已发送UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR广播，则参数通过PhotoGridBase正常传递获取，如果未发送广播，则组件接收广播刷新。
   */
  private updateRecoverInfoAfterGetAnchor = (dataIndexForRecover: number) => {
    Log.info(TAG, `emit updateRecoverInfoAfterGetAnchor, dataIndexForRecover is ${dataIndexForRecover}, ` +
      `dataIndexForRecover in selectParams is:${this.selectParams.dataIndexForRecover}.`);
    if (!this.selectParams.hasGotRecoverAnchor) {
      this.selectParams.hasGotRecoverAnchor = true;
    }
    if (this.selectParams.dataIndexForRecover !== dataIndexForRecover) {
      this.selectParams.dataIndexForRecover = dataIndexForRecover;
    }
  }

  private sharedLocalStorage = this.getUIContext().getSharedLocalStorage();
  // 是否在图库内拉起。
  private isInPhotos = Boolean(ScreenManager.getInstance().isFromPickerInPhotos());
  private pickerThumbnailCreator: PickerThumbnailCreator = PickerThumbnailCreator.getInstance();
  // 是否是草稿箱模式
  private isGrantPage: boolean = false;
  private thumbnailCreatorStoppedReason?: string;

  /**
   * 相册页返回后刷新数据
   */
  onAlbumGirdClose() {
    Log.info(TAG, 'onAlbumGirdClose');
    if (this.albumsShow || this.isAllMediaAlbum) {
      Log.info(TAG, 'skip to update photo grid\'s data.');
      return;
    }
    this.isAllMediaAlbum = true;
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
    RecoverController.setRecoverAlbumUri(Constants.PICKER_ALL_PHOTOS_SHEET);
    RecoverController.setIsRecoverInAlbumPage(false);
    this.isFirstEnter = false;
    if (this.cachedParam && this.param !== undefined) {
      this.param.itemDisplayName = this.cachedParam.itemDisplayName;
      this.param.itemId = this.cachedParam.itemId;
      this.param.uri = this.cachedParam.uri;
      this.param.unionAlbumUris = this.cachedParam.unionAlbumUris;
      this.initSelectParams(this.param);
      this.isItemIdChange = true;
      this.onInActive();
      this.onActive();
      this.isShow = true;
    }
  }

  private onNavPathStackChange(): void {
    this.isEnterAlbums = this.pageInfo.getAllPathName()?.indexOf(NavigationConstants.NAVIGATION_THIRD_ALBUM_GRID) >= 0;
    Log.info(TAG, `isEnterAlbums = ${this.isEnterAlbums}`);
  }

  @Builder
  PageMap(name: string) {
    if (name === NavigationConstants.NAVIGATION_THIRD_ALBUM_GRID) {
      Stack({ alignContent: Alignment.Start }) {
        ThirdSelectAlbumGridBase({
          replaceUriManager: this.replaceUriManager,
          scroller: this.scroller,
          selectParams: this.selectParams,
          dataSource: this.dataSource,
          isSearchVisible: this.isSearchVisible,
          selectManager: this.selectManager,
          browserController: this.browserController,
          gridItemWidth: this.gridItemWidth,
          gridItemHeight: this.gridItemHeight,
          isNeedTransition: this.isNeedTransition,
          isShowScrollBar: this.isShowScrollBar,
          isVisibleScrollBar: this.isVisibleScrollBar,
          gridRowCount: this.gridRowCount,
          gridColCount: this.gridColCount,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          panelId: this.panelId,
          selectedCount: this.selectedCount,
          totalCount: this.totalCount,
          isFromAlbum: true,
          showActionBar: true,
          title: this.title,
          isPageHidden: this.isPageHidden,
          isGestureSliding: $isGestureSliding,
          displaySearchWords: this.displaySearchWords,
          isSetOriginal: this.isSetOriginal,
          isOriginalSupported: this.selectParams.isOriginalSupported,
          isPreviewForSingleSelectionSupported: this.selectParams.isPreviewForSingleSelectionSupported,
          singleSelectionMode: this.selectParams.singleSelectionMode,
          moreMenuList: this.moreMenuList,
          isRefreshSelectState: $isRefreshSelectState,
          completeButtonText: this.selectParams.completeButtonText,
          layoutOptions: this.layoutOptions,
          isPhotoInner: this.isPhotoInner,
          placeholderIndex: this.placeholderIndex,
          thirdSelectController: this.controller,
          isVerdeFoldable: this.isVerdeFoldable,
          isPickerMaskLayerShow: this.isPickerMaskLayerShow,
          isSlidingHorizontally: this.isHorizontalPickerOrientation(),
          singleLineConfig: this.selectParams.singleLineConfig,
          placeholderIndexChangedCallback: this.onPlaceholderChanged,
          cancelFunc: this.cancelFunc,
          badgeType: this.badgeType,
          badgeConfigUrisSet: this.badgeConfigUrisSet,
          badgeConfigUpdate: this.badgeConfigUpdate,
          isReScrollAfterGetAnchor: this.isReScrollAfterGetAnchor,
          isReScrollAfterDataLoaded: this.isReScrollAfterDataLoaded,
        });
      }
      //防止子组件手势冲突
      .parallelGesture(
        GestureGroup(GestureMode.Exclusive,
          PanGesture()
        )
      )
      .padding({
        bottom: this.selectParams.isFromFa ? this.diggingHoleCameraArea.bottom : 0,
      })
      .width('100%')
      .height('100%')
      .transition(TransitionEffect.OPACITY)
    }
  }

  tabSelectedIndexesChange() {
    Log.info(TAG, `tabSelectedIndexesChange ${this.tabSelectedIndexes[0]}`);
    if (this.tabSelectedIndexes[0] === 1) {
      this.dataSource?.changeDataImpl(this.photoDataImpl);
    }
    performanceMonitor.begin('tabSelectedIndexesChange', performanceMonitor.ActionType.LAST_UP);
    animateTo({
      duration: PICKER_TRANSITIONS_ANIMATE_DURATION,
      curve: curves.springMotion(PICKER_CURVES_SPRING_MOTION_RESPONSE, PICKER_CURVES_SPRING_MOTION_FRACTION),
      onFinish: (): void => {
        performanceMonitor.end('tabSelectedIndexesChange');
      },
    }, (): void => {
      this.albumsShow = this.tabSelectedIndexes[0] === 1;
      if (this.tabSelectedIndexes[0] === 0) {
        this.onAlbumGirdClose();
      }
    })
  }

  /**
   * 横竖屏变化
   */
  watchIsHorizontal() {
    Log.info(TAG, `watchIsHorizontal isHorizontal: ${this.isHorizontal}`)
    if (!this.isHorizontalPickerOrientation()) {
      this.initGridRowCount();
    } else {
      this.initGridColCount();
    }
  }

  /**
   * xxx更新
   */
  updateIsFoldable(): void {
    if (this.isFoldable === DeviceInfo.isFoldable()) {
      return;
    }
    this.isFoldable = DeviceInfo.isFoldable();
    Log.info(TAG, `IsFoldable change: ${this.isFoldable}`);
  }

  /**
   * 交换相册
   * @param params 选择参数
   */
  private onSwitchThirdAlbum(params: SelectParams): void {
    Log.info(TAG, `onSwitchThirdAlbum params.uri: ${params?.uri}`);
    RecoverController.setRecoverAlbumUri(params.uri);
    RecoverController.setIsRecoverInAlbumPage(true);
    this.isAllMediaAlbum = params.uri === undefined || params.uri === '';
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
    this.isFirstEnter = params.isFirstEnter;
    this.isItemIdChange = true;
    if (this.selectParams?.isImmersiveCompared && params?.isImmersiveCompared != undefined) {
      params.isImmersiveCompared = this.selectParams.isImmersiveCompared;
    }
    if (this.selectParams?.isCollagePageEnter && params?.isCollagePageEnter != undefined) {
      params.isCollagePageEnter = this.selectParams.isCollagePageEnter;
    }
    this.initSelectParams(params);
    this.dataSource.resetActiveWindow();
    this.dataSource.initData();
    if (this.userId > 0) {
      this.dataSource.size = 1;
      Log.info(TAG, 'onSwitchThirdAlbum dataSource size = 1');
    }
    if (this.param !== undefined && this.param !== undefined) {
      this.param.itemDisplayName = params.itemDisplayName;
      this.param.itemId = params.uri;
      this.param.uri = params.uri;
      this.param.unionAlbumUris = params.unionAlbumUris;
    }

    this.onActive();
    this.isShow = true;
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return;
    }
    this.pageInfo.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_THIRD_ALBUM_GRID, null));
  }

  onActionBarControllerChanged(): void {
    if (this.actionBarController) {
      this.moreMenuList = this.actionBarController.moreMenuList;
      this.isEmpty = this.actionBarController.isEmpty;
      this.selectedCount = this.actionBarController.totalSelectedCount;
      this.albumsShow = this.actionBarController.albumsShow;
      this.title = this.actionBarController.title;
    }
  }

  /**
   * 更多菜单改变
   */
  onMoreMenuListChanged(): void {
    if (this.actionBarController) {
      this.actionBarController.moreMenuList = this.moreMenuList;
    }
  }

  onIsEmptyChanged(): void {
    if (this.actionBarController) {
      this.actionBarController.isEmpty = this.isEmpty;
    }
  }

  /**
   * 选择数量变化
   */
  onSelectCountChanged(): void {
    if (this.actionBarController) {
      this.actionBarController.totalSelectedCount = this.selectedCount;
    }
  }

  /**
   * 页面隐藏
   */
  onPageHiddenChanged(): void {
    Log.info(TAG, `onPageHiddenChanged isPageHidden: ${this.isPageHidden}`)
  }

  /**
   * 页面展示变化
   */
  onAlbumsShowChanged(): void {
    Log.info(TAG, `onAlbumsShowChanged albumsShow: ${this.albumsShow}`)
    if (this.actionBarController) {
      this.actionBarController.albumsShow = this.albumsShow;
    }
  }

  /**
   * 标题变化
   */
  onTitleChanged(): void {
    if (this.actionBarController) {
      this.actionBarController.title = this.title;
    }
  }

  private updateRecoverSceneInfo(index: number) {
    let isInRecommend: boolean = false;
    if (index === 0) {
      RecoverController.setRecoverAlbumUri(Constants.PICKER_ALL_PHOTOS_SHEET);
    } else {
      isInRecommend = true;
    }
    this.broadCast.emit(BroadCastConstants.UPDATE_UN_DATA_GRID_COUNT, [isInRecommend, this.param?.cameraAble]);
    RecoverController.setSelectedRecommendType(index);
    RecoverController.setIsRecoverInAlbumPage(false);
    Log.info(TAG, `updateRecoverSceneInfo, index is ${index}, cameraAble is ${this.param?.cameraAble}`);
  }

  /**
   * 网络发生变化
   */
  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }


  /**
   * GeometryId发生变化
   */
  onGeometryIdChange(): void {
    Log.debug(TAG, `onGeometryIdChange geometryTransitionBrowserId is ${this.geometryTransitionBrowserId}`);
    this.geometryTransitionUri =
      UiUtil.getGeometryTransitionUri(this.geometryTransitionBrowserId, this.geometryTransitionUri, this.broadCast);
  }

  /**
   * 浏览控制发生变化
   */
  onBrowserControllerChanged(): void {
    this.updateSystemUi();
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return;
    }
    Log.info(TAG, `onBrowserController isAnimating:${this.browserController.isAnimating}
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
      if ((this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) &&
        !this.inDynamicEffect) {
        this.isPageHidden = Visibility.Hidden;
      } else {
        // 进入退出大图无动效场景，如picker底部条
        this.isPageHidden = Visibility.Visible;
        Log.info(TAG, 'no animation and no photoBrowser, show page');
      }
    }
  }

  /**
   * 菜单点击
   * @param action action
   */
  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.selectParams?.isImmersiveCompared) {
        this.backImmersiveCompared();
        return;
      }
      this.pageInfo.pop();
    } else if (action.actionID === Action.CANCEL.actionID) {
      if (this.isPhotoInner && this.cancelFunc !== undefined &&
        !this.selectParams?.isImmersiveCompared && !this.selectParams?.isCollagePageEnter) {
        this.cancelFunc();
      } else {
        if (this.selectParams?.isImmersiveCompared) {
          // 非直板机和xxxxxx 竖屏展示
          if (!DeviceInfo.isPc() && !(DeviceInfo.isTablet() || DeviceInfo.isFoldable())) {
            WindowUtil.setOrientation(window.Orientation.UNSPECIFIED);
          }
          setTimeout((): void => {
            this.backImmersiveCompared();
          }, Constants.ENTER_TO_COMPARE_PAGE_TIME)

        } else if (this.selectParams?.isCollagePageEnter) {
          this.backImmersiveCompared();
        } else {
          this.setPickResult();
        }
      }
    } else if (action.actionID === Action.OK.actionID) {
      this.doAtOkAction();
    }
  }

  private doAtOkAction(): void {
    /* instrument ignore next */
    if (this.selectParams.isFromFa) {
      let uriArray: string[] = Array.from(this.selectManager?.selectedMap.keys() ?? []);
      const coverUri: string | undefined = uriArray[0];
      if (!coverUri) {
        Log.warn(TAG, 'doAtOkAction isFromFa but coverUri is empty');
        return;
      }
      this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
        ['',
          LocalStorage.getShared()?.get<string>(FormConstants.FORM_ITEM_ALBUM_URI),
          LocalStorage.getShared()?.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
          coverUri,
          false,
          uriArray]);
    } else if (this.isPhotoInner && this.okFunc !== undefined && !this.selectParams?.isImmersiveCompared &&
      !this.selectParams?.isCollagePageEnter && !this.selectParams?.isHighlightPickerView) {
      this.broadCast?.emit(Constants.UPDATE_SHEET_STATE, [false]);
      this.okFunc();
    } else {
      let uriArray: string[] = [];
      let arr: MediaItem[] = [];
      if (this.selectManager !== undefined) {
        uriArray = SelectUtil.getUriArray(this.selectManager?.isPreview ?
          this.selectManager?.previewSet as Set<string> : this.selectManager?.clickedSet as Set<string>);
        arr = this.selectManager?.getSelectItems();
        if (this.selectParams?.isImmersiveCompared) {
          Log.info(TAG, 'onMenuClicked, action: toImmersiveComparedPage');
          this.toImmersiveComparedPage(arr);
          return;
        } else if (this.selectParams?.isCollagePageEnter) {
          Log.info(TAG, 'onMenuClicked, action: toCollagePage');
          this.toCollagePage(arr);
          return;
        }
      }
      this.setPickResult(uriArray, arr);
    }
  }

  private async setFAPickResultForTv(): Promise<void> {
    Log.info(TAG, `setFAPickResultForTv: lenght:${this.selectInfoList?.length}`);
    for (let item of this.selectInfoList) {
      if (item.uri !== undefined) {
        Log.info(TAG, `setFAPickResultForTv. picker item uri is : ${item.uri}`);
        this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
          ['',
            LocalStorage.getShared()?.get<string>(FormConstants.FORM_ITEM_ALBUM_URI),
            LocalStorage.getShared()?.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
            item.uri, false]);
        break;
      }
    }
    return;
  }

  private backImmersiveCompared() {
    this.navPageInfos?.pop();
  }

  private toImmersiveComparedPage(arr: MediaItem[]) {
    const verify = new Verify(this.broadCast);
    verify.photoVerification(arr);
    this.broadCast?.emit(Constants.UPDATE_SHEET_STATE, [false]);
    this.navPageInfos?.pop();
  }

  /**
   * 拼贴页面
   * @param arr 数据集
   * @returns
   */
  private async toCollagePage(arr: MediaItem[]): Promise<void> {
    if (!arr || arr.length === 0) {
      return;
    }
    let item = arr[0];
    const isRemoteResource: boolean = false;
    if (isRemoteResource) {
      if (!this.networkAvailable) {
        // 网络不可用，提示无法下载
        UiUtil.showToast($r('app.string.no_network'));
        return;
      }
    }
    // 重复触发下载，会导致进度混乱
    if (this.isImageDownloading) {
      Log.warn(TAG, 'repeated download is prohibited.');
      return;
    }

    // 图片下载完毕的回调
    const startTime = Date.now();
    let downloadFinishCallback: Function = (err: string = ''): void => {
      ReportToBigDataUtil.downloadOriginReport(BigDataConstants.DOWNLOAD_FOR_COLLAGE, Date.now() - startTime, err);
      if (err) {
        return;
      }
      this.isImageDownloading = false;
      this.handleEnterCollagePage(item);
    }
    if (isRemoteResource) {
      this.broadCast.emit(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, [item.uri]);
    } else {
      this.handleEnterCollagePage(item);
    }
  }

  private async handleEnterCollagePage(imgMediaItem: MediaItem): Promise<void> {
    if (!imgMediaItem) {
      return;
    }
    let formatList: string[] = Constants.formatList;
    let flag: boolean = formatList.some((item) => {
      return imgMediaItem.uri.endsWith(item) || imgMediaItem.uri.endsWith(item.toLocaleUpperCase());
    })
    if (!flag) {
      UiUtil.showToast($r('app.string.image_specification_error'));
      const msg: Record<string, number | string | boolean> = {
        'reason': Constants.IMAGE_SPECIFICATIONS,
      };
      ReportToBigDataUtil.report(BigDataConstants.ENTER_COLLAGE_FAIL, msg);
      return;
    }
    AppStorage.setOrCreate('backCollageReplaceUri', imgMediaItem.uri);
    this.broadCast?.emit(Constants.UPDATE_SHEET_STATE, [false]);
    this.navPageInfos?.pop();
    Log.info(TAG, 'handleEnterCollagePage');
  }

  /**
   * 发现
   */
  aboutToAppear(): void {
    Log.info(TAG, `call aboutToAppear param - bundleName: ${this.param?.bundleName}, ` +
      `albumName: ${AlbumDefine.getAnonymizeAlbumName(this.param?.albumName)}, albumUri: ${this.param?.albumUri}}`);
    this.isCombinedMediaTypeFilterError = this.sharedLocalStorage?.
      get<boolean>(Constants.IS_PHOTO_PICKER_COMBINED_FILTER_ERROR) ?? false;
    this.isGrantPage = Boolean(this.sharedLocalStorage?.has(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS));
    if (this.inputDataSource) {
      this.dataSource.releaseBroadCast();
      this.dataSource = this.inputDataSource;
    }
    getContext(this)?.eventHub?.on(Constants.PHOTO_PICKER_ON_FOREGROUND, this.pickerOnForegroundFun);
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
    WindowUtil.prepareWinRouter();
    this.userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (!DeviceInfo.isPc()) {
      if (!(this.param?.isCollagePageEnter || this.param?.isImmersiveCompared || this.param?.isFromFa)) {
        WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      }
    }
    this.dataSource.changeDataImpl(this.photoDataImpl);
    if (this.param?.recoverSceneEnabled) {
      this.initPickerRecoverSceneParams();
    }
    this.initSelectParams(this.param, this.dataSource.isInitData);
    Log.info(TAG, 'call aboutToAppear, initSelectParams finish');

    this.initSelectOtherParams();
    this.registerListenBroadCast();
    this.isPickerMaskLayerShow = MaskLayerUtils.getInstance().getIsPickerMaskLayerShow();
    this.selectManagerRegisterCallback();
    this.dataSource.registerCallback('updateCount',
      (newState: number) => {
        this.onDataCountUpdate(newState);
      });
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.isActive = true;
    this.cachedParam = new SelectParams();
    if (this.param !== undefined) {
      this.cachedParam.itemDisplayName = this.param.itemDisplayName;
      this.cachedParam.itemId = this.param.itemId;
      this.cachedParam.uri = this.param.uri;
      this.cachedParam.unionAlbumUris = this.param.unionAlbumUris;
      this.selectParams.recommendationType = this.param.recommendationType;
      this.updateTitle();
    }

    LocalStorage.getShared()?.setOrCreate<boolean>('showCancel', true);

    // save all photo dataSource
    if (this.dataSource.albumUri === '' &&
      LocalStorage.getShared()?.get<MediaDataSource>(Constants.APP_KEY_ALL_PHOTO_DATASOURCE) === undefined) {
      LocalStorage.getShared()?.setOrCreate(Constants.APP_KEY_ALL_PHOTO_DATASOURCE, this.dataSource);
    }

    Log.error(TAG, `data count = ${this.dataSource.totalCount()}`);

    this.broadCast.on(BroadCastConstants.SWITCH_THIRD_ALBUM, this.onSwitchThirdAlbumFunc);

    this.initAlbumData();

    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.initGridRowOrColCountFunc);
    if (this.selectParams.isFromPickerView || this.selectParams.bundleName === 'com.ohos.sceneboard') {
      this.setPickerReceiveDataCallback();
    }
    this.checkWarning();
    if (this.dataSource.isInitData && this.totalCount === 0) { // 如果总数查询回调来早，比这里注册监听早，那么这里需要更新下
      Log.info(TAG, 'update count when appear');
      this.onDataCountUpdate(this.dataSource.size);
      this.onLoadingFinished(this.dataSource.size, false);
    }
    this.broadCast.on(BroadCastConstants.PICKER_NOTIFY_SCROLL_INDEX, this.gridScrollCallback)
    this.reportPhotoPickerLockedStatus();
    this.reportPhotoPickerComponentBrowseMode();
    // 占用事件
    this.onOccupyEvents();
    this.broadCast.on(BroadCastConstants.OCCUPY_EVENTS, this.onOccupyEvents);
    this.initPickerPhotoGridController();
    if (!this.selectParams.isFromPickerView && this.isSpecialCreatePicker()) {
      this.subscribeScreenOff();
    }
    this.startCreateThumbnail();
    Log.info(TAG, 'aboutToAppear has executed');
    this.browserDataSource.setAlbumDataSource(this.dataSource);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    let param: Params = this.browserController.browserParam as Params;
    this.browserDataSource?.setSelectMode(this.selectManager as ThirdSelectManager, param?.selectMode);
    this.getUIContext().getSharedLocalStorage()?.setOrCreate(Constants.PHOTO_PICKER_BROWSER_DATASOURCE,
      this.browserDataSource);
  }

  private isSpecialCreatePicker(): boolean {
    return this.selectParams?.bundleName === Constants.CAMERA_BUNDLE_NAME
  }

  private canCreateThumbnail() {
    if (this.isInPhotos) {
      Log.i(TAG, 'is in photos')
      return false
    }
    if (this.isGrantPage) {
      Log.i(TAG, 'is in grant page')
      return false
    }
    return true
  }

  // 触发缩略图生成
  private startCreateThumbnail(): void {
    if (!this.canCreateThumbnail()) {
      return;
    }
    this.pickerThumbnailCreator.start();
    // userFileManagerAccess的销毁早于page aboutToDisappear导致stop失败。注册销毁前回调来保证任务中断
    this.pickerThumbnailCreator.registerDestroyCallBack(
      () => this.stopCreateThumbnail('destroy call back')
    );
  }

  // 停止缩略图生成
  private stopCreateThumbnail(reason?: string): void {
    if (!this.canCreateThumbnail()) {
      return;
    }
    // 非page hide中断会设置reason，减少重复调用
    if (this.thumbnailCreatorStoppedReason) {
      return;
    }
    this.thumbnailCreatorStoppedReason = reason;
    this.pickerThumbnailCreator.stop();
  }

  // 锁屏事件
  private subscribeScreenOff(): void {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.SCREEN_LOCKED'], // Subscribe to screen out public events
    }
    commonEventManager.createSubscriber(subscribeInfo, (err, data) => {
      if (err) {
        Log.error(TAG, `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      Log.info(TAG, 'Succeeded in creating subscriber.');
      subscriber = data;
      commonEventManager.subscribe(subscriber, () => {
        Log.info(TAG, `obtain SCREEN_LOCKED event`);
        this.controller.onCompleted([]);
      })
    })
  }

  private initPickerPhotoGridController(): void {
    this.pickerPhotoGridController.selectionChecker = this.selectionChecker;
    this.pickerPhotoGridController.albumChecker = this.albumChecker;
    this.pickerPhotoGridController.isShowPickerWarnDialog = this.isShowPickerWarnDialog;
    this.pickerPhotoGridController.dataSource = this.dataSource;
    this.pickerPhotoGridController.isOnItemClickedSet = this.isOnItemClickedSet;
    this.pickerPhotoGridController.param = this.param;
    this.pickerPhotoGridController.photoPermissionMap = this.photoPermissionMap;
    this.pickerPhotoGridController.selectInfoList = this.selectInfoList;
  }

  onOccupyEvents() {
    let extensionWindowProxy: uiExtension.WindowProxy =
      LocalStorage.getShared().get<uiExtension.WindowProxy>('extensionWindowProxy') as uiExtension.WindowProxy;
    extensionWindowProxy?.occupyEvents(uiExtension.EventFlag.EVENT_PAN_GESTURE_UP |
    uiExtension.EventFlag.EVENT_PAN_GESTURE_DOWN);
  }

  private gridScrollCallback: Function = (index: number): void => {
    this.gridScroll(index);
  };

  private gridScroll(index: number) {
    let current = this.isShowDialog() ? index + 1 : index;
    current = this.param?.cameraAble ? current + 1 : current;
    Log.info(TAG, `gridScroll ${current}`)
    this.scroller.scrollToIndex(current, false, ScrollAlign.CENTER);
  }

  private onDataCountUpdate(newState: number): void {
    Log.info(TAG, `updateTotalCount ${newState}`);
    this.isVisibleScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
    this.selectManager?.setTotalCount(newState);
    this.updateSearchNoResultPageVisibility(newState);
  }

  private initAlbumData(): void {
    if (this.selectParams.isFromPickerView && this.selectParams.searchAble) {
      this.albums = new AlbumThirdSelectDataSource(this.broadCast, getContext(this));
      this.albums.initData();
    }
  }

  /**
   * 初始化选择参数
   */
  private initSelectOtherParams() {
    if (this.param) {
      this.selectParams.cameraAble = this.param.cameraAble;
      this.selectParams.isShowSerialNum = this.param.isShowSerialNum;
      this.selectParams.isHighlightPickerView = this.param.isHighlightPickerView;
      this.selectParams.highlightPickerType = this.param.highlightPickerType;

      // 更新编辑许可
      this.selectParams.editAble = this.param.editAble;
      this.selectParams.searchAble = this.param.searchAble;

      // 父组件手动关闭搜索功能时不跟随传入参数
      if (this.isSearchEnabled) {
        this.isSearchEnabled = this.selectParams.searchAble && SearchSwitchManager.getInstance().isSupportPhotoSearch();
      }
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE, this.selectParams.editAble);

      if (this.selectParams.isFromFa) {
        this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
        LocalStorage.getShared()?.setOrCreate(FormConstants.FORM_ITEM_ALBUM_URI, this.param.uri);
        LocalStorage.getShared()?.setOrCreate(FormConstants.FORM_ITEM_DISPLAY_NAME, this.param.itemDisplayName);
      }
      this.dataSource.setFilterMediaType(this.selectParams.filterMediaType);
      this.initSelectManager();
      this.selectionChecker = new SelectionChecker(this.selectManager, this.broadCast,
        LocalStorage.getShared()?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY));
      this.albumChecker = new AlbumChecker(this.dataSource,
        LocalStorage.getShared()?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY));
      this.selectManager?.setIsMultiPick(this.selectParams.isMultiPick);
      if (!this.isHorizontalPickerOrientation()) {
        this.initGridRowCount();
      } else {
        this.initGridColCount();
      }
      this.dataSource.setBroadCast(this.broadCast);
      if (this.param.isHighlightPickerView) {
        // 只有时刻中拉的写入 不然会影响到相机那新增相册拉的picker
        this.dataSource.albumUri = this.param.albumUri;
      }
    }
  }

  /**
   * Picker恢复现场
   */
  private initPickerRecoverSceneParams(): void {
    let albumUriForRecover: string = this.param?.albumUriForRecover ?? '';
    let segmentButtonIndex: number = this.param?.isRecoverAlbum ? SEGMENT_ALBUM_INDEX : SEGMENT_PHOTO_INDEX;
    this.tabSelectedIndexes = [segmentButtonIndex];
    this.albumsShow = segmentButtonIndex === SEGMENT_ALBUM_INDEX;
    Log.info(TAG, `initPickerRecoverSceneParams, segmentButtonIndex is ${segmentButtonIndex}, recover album uri is ${albumUriForRecover}`)
    if (!this.albumsShow || !this.param) {
      return;
    }
    this.recoverAlbum(albumUriForRecover);
  }

  private async recoverAlbum(albumUriForRecover: string): Promise<void> {
    let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
    let recoveredAlbumInfo: PhotoAlbum | undefined =
      await userFileManagerAccess.getAlbumByUri(albumUriForRecover);
    if (!recoveredAlbumInfo) {
      return;
    }
    let recoveredAlbumName: Resource | string = userFileManagerAccess.getAlbumNameResource(recoveredAlbumInfo);
    Log.info(TAG, `recover album scene begin, itemDisplayName is ${recoveredAlbumName}, `+
      `count is ${recoveredAlbumInfo.count}`);
    let params: SelectParams = this.selectParams;
    params.isFirstEnter = false;
    params.itemDisplayName = recoveredAlbumName;
    params.itemCount = recoveredAlbumInfo.count;
    params.itemId = albumUriForRecover;
    params.uri = albumUriForRecover;
    params.itemCoverUri = recoveredAlbumInfo.coverUri;
    params.dataIndexForRecover = this.param?.dataIndexForRecover ?? 0;
    setTimeout((): void => {
      this.onSwitchThirdAlbum(params);
    }, Constants.DELAY_TO_ENTER_ALBUM_ON_RECOVER);
    Log.info(TAG, `recover album scene finished`);
  }

  /**
   * 注册监听
   */
  private registerListenBroadCast(): void {
    this.broadCast.on(BroadCastConstants.SELECT, this.funcOnSelectCallback);
    this.broadCast.on(BroadCastConstants.CAMERA_SELECT, this.funcOnCameraSelectCallback);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.funcJumpBrowserCallback);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER_BY_SELECTED, this.funcJumpBrowserBySelected);
    this.broadCast.on(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT, this.funcUpdateSystemUiOnEditorExit);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.funcOnLoadingFinished);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.funcOnReloadFinishedCallback);
    this.broadCast.on(BroadCastConstants.THIRD_PICKER_ALBUM_GIRD_CLOSE, this.funcOnAlbumGirdCloseCallback);
    this.broadCast.on(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
    this.broadCast.on(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER, this.previewJumpBrowserCallbackFunc);
    this.broadCast.on(BroadCastConstants.PREVIEW_EXIT_PHOTO_BROWSER, this.previewExitBrowserCallbackFunc);
    this.appBroadCast.on(BroadCastConstants.OPEN_BROWSER_IN_SELECT_VIEW, this.onOpenBrowserInSelectView);
    this.appBroadCast.on(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW,
      this.onCloseBrowserAndReturnToSelectView);
    this.appBroadCast.on(BroadCastConstants.PHOTO_PICKER_APP_LOCK_STATUS_UPDATED,
      this.onPhotoPickerAppLockStatusUpdated);
    this.appBroadCast.on(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, this.clearScrollHistory);
    this.appBroadCast.on(BroadCastConstants.UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR, this.updateRecoverInfoAfterGetAnchor);
  }

  private onOpenBrowserInSelectView = () => {
    animateToImmediately({
      duration: 200,
      curve: Curve.Sharp,
    }, () => {
      this.searchBarAndCapsuleOpacity = 0;
    })
  }
  private onCloseBrowserAndReturnToSelectView = () => {
    animateToImmediately({
      duration: 200,
      curve: Curve.Sharp,
      delay: 100,
    }, () => {
      this.searchBarAndCapsuleOpacity = 1;
    })
  }
  private onPhotoPickerAppLockStatusUpdated = (status: boolean) => {
    Log.info(TAG, `onPhotoPickerAppLockStatusUpdated status = ${status}`);
    this.isPickerMaskLayerShow = status;
  }

  private selectManagerRegisterCallback(): void {
    this.selectManager?.registerCallback?.('updateCount',
      (newState: number) => {
        Log.info(TAG, `updateSelectedCount ${newState}`);
        this.selectedCount = newState;
        this.selectManager?.emitCallback?.('thirdSelectUpdateCount', [newState]);
      });

    this.selectManager?.registerCallback?.('refreshData',
      (refresh: boolean) => {
        this.broadCast.emit(this.panelId + BroadCastConstants.REFRESH_SELECT_DATA, [true]);
      });

    this.selectManager?.registerCallback?.('verifySecondarySelection', (isSelected: boolean, targetId: string) => {
      this.broadCast.emit(Constants.UPDATE_SELECTED, [isSelected, targetId]);
      this.broadCast.emit(BroadCastConstants.UPDATE_PHOTO_BROWSER_SELECT_STATUS, [isSelected, targetId]);
    });
  }

  private updateNumOfSelectParam(data: Record<string, Object>): void {
    let totalCount: number = data['totalCount'] as number;
    let photoCount: number = data['photoCount'] as number;
    let videoCount: number = data['videoCount'] as number;
    Log.info(TAG, 'ReceiveDataCallback: set max count totalCount = ' +
      totalCount + `photoCount = ${photoCount}` + 'videoCount = ' + videoCount);
    if (totalCount !== undefined) {
      this.selectParams.maxSelectCount = (totalCount >= 0 ?
        totalCount : Constants.LIMIT_MAX_THIRD_SELECT_COUNT);
    }
    if (photoCount !== undefined) {
      this.selectParams.maxPhotoSelectNumber = (photoCount >= 0 ?
        photoCount : Constants.LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT);
    }
    if (videoCount !== undefined) {
      this.selectParams.maxVideoSelectNumber = (videoCount >= 0 ?
        videoCount : Constants.LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT);
    }
    this.selectManager?.setSelectParam(this.selectParams);
    this.selectManager?.updateMediaItemFullState();
  }

  private setPickerReceiveDataCallback(): void {
    try {
      let storage = LocalStorage.getShared();
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      if (session) {
        Log.info(TAG, 'PhotoPickerComponent onRemoteReady set ReceiveDataCallback');
        session.setReceiveDataCallback((data) => {
          this.handleDataCallback(data, session);
        });
        session?.sendData({ 'dataType': 'remoteReady' });
        this.isOnItemClickedSet = storage?.get<boolean>('isOnItemClickedSet') ?? false;
      }
    } catch (err) {
      Log.info(TAG, `setPickerReceiveDataCallback fail ${err}`);
    }
  }

  /* badgeConfig特殊角标信息分批接收：
   *    媒体库                                              图库
   *        ---->(我要发送消息 needSendBadgeConfigs: true)
   *        （发送下标为0的数据过来 'nextIndex': 0）<----
   *        ---->(发送下标为0的数据，图库进行接收）
   *        （发送下标为1的数据过来 'nextIndex': 1）<----
   *                         ...以此类推...
   *        ---->(发送下标为n的数据，并告知结束 isOver:true 图库接收 并走结束逻辑，触发pickerGridItemComponent组件更新）
   * */
  private handleDataCallback(data: Record<string, Object>, session: UIExtensionContentSession | undefined): void {
    Log.info(TAG, `ReceiveDataCallback${JSON.stringify(data)}`);
    let needSendBadgeConfigs: boolean = data['needSendBadgeConfigs'] as boolean; // 发送 uri
    if (needSendBadgeConfigs) { // 准备操作
      this.handleBadgeConfigPrepare(data, session);
      return;
    }
    let isOver: boolean = data['isOver'] as boolean; // 是否结束
    let badgeConfigUri: object = data['badgeConfig'];
    if (Array.isArray(badgeConfigUri)) { // 接收数据流程
      this.handleBadgeConfigReceive(badgeConfigUri, session, data);
      return;
    }
    if (isOver) { // 结束操作
      this.handleBadgeConfigOver(data);
      return;
    }

    let exitPicker: Object = data['exitPicker'];
    if (exitPicker && this.selectParams.bundleName === 'com.ohos.sceneboard') {
      this.controller.onCompleted([]);
      Log.info(TAG, 'ReceiveDataCallback：exitPicker');
      return;
    }
    let albumUri: Object = data['albumUri'];
    if (albumUri) {
      if (typeof albumUri === 'string') {
        if (albumUri.startsWith(Constants.UNION_ALBUM_URI_HEAD)) {
          let unionAlbumUris: string[] = albumUri.substring(Constants.UNION_ALBUM_URI_HEAD.length).split('|');
          this.handleAlbumSelected(unionAlbumUris[0], unionAlbumUris);
        } else {
          this.handleAlbumSelected(albumUri);
        }
      }
      return;
    }
    let selectUri: Object = data['clickConfirm'];
    if (selectUri) {
      this.handleClickConfirm(session, data, selectUri);
      return;
    }
    let enterCamera: Object = data['enterCamera'];
    if (enterCamera !== undefined && enterCamera !== null) {
      Log.info(TAG, 'ReceiveDataCallback: enter camera');
      this.broadCast?.emit(BroadCastConstants.JUMP_TO_CAMARA, [enterCamera as boolean ?? true]);
      return;
    }
    let isHasCount = data['totalCount'] || data['photoCount'] || data['videoCount'];
    if (isHasCount) {
      this.updateNumOfSelectParam(data);
      return;
    }
    let itemUri: Object = data['itemUri'];
    // 单行模式下，photoPickerComponent组件不提供打开大图浏览相关功能, photoPickerComponent组件不支持大图相关回调
    // 不能删除singleLineConfig，否则会造成兼容性问题
    if (itemUri && this.selectParams.singleLineConfig === undefined) {
      this.handleSetPhotoBrowserItem(itemUri, data);
      return;
    }
    // 单行模式下，photoPickerComponent组件不提供打开大图浏览相关功能, photoPickerComponent组件不支持大图相关回调
    // 不能删除singleLineConfig，否则会造成兼容性问题
    let exitPhotoBrowser: Object = data['exitPhotoBrowser'];
    if (exitPhotoBrowser && this.selectParams.singleLineConfig === undefined) {
      Log.info(TAG, 'ReceiveDataCallback: exit photo browser');
      this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
      return;
    }
    // 单行模式下，photoPickerComponent组件不提供打开大图浏览相关功能, photoPickerComponent组件不支持大图相关回调
    // 不能删除singleLineConfig，否则会造成兼容性问题
    let photoBrowserUIElements: Object = data['elements'];
    if (photoBrowserUIElements && this.selectParams.singleLineConfig === undefined) {
      this.setPhotoBrowserUIElementVisibility(photoBrowserUIElements, data);
      return;
    }
    let createUri: string = data['createUri'] as string;
    if (createUri) {
      let date = data['date'] as number
      let selectedMediaUri = data['selectedMediaUri'] as string;
      let invalid = !this.selectParams.isFromPickerView || !this.selectManager?.isItemSelected(selectedMediaUri);
      this.replaceUriManager?.createAndGrantFile(invalid, createUri, getContext(this).filesDir, date);
      Log.info(TAG, `ReceiveDataCallback createUri:  ${selectedMediaUri}`);
      return;
    }
    let oriUri = data['oriUri'];
    if (oriUri) {
      let replaceUri = data['replaceUri'] as string;
      let item = this.selectManager?.getSelectMediaItemByUri(oriUri as string);
      if (!item) {
        this.replaceUriManager?.sendReplaceResult(data['date'] as number, 14000002, 'Invalid URI');
        return;
      }
      if (item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        MediaItemUtil.parseVideoPixelMap(replaceUri).then((pixelMap) => {
          if (!pixelMap) {
            return;
          }
          let coverUri = replaceUri.substring(0, replaceUri.lastIndexOf('.')) + '_cover.jpeg';
          MediaItemUtil.createCoverFile(coverUri, pixelMap, () => {
            this.replaceUriManager?.parseMediaItemByVideo(replaceUri).then((replaceItem) => {
              if (item) {
                this.replaceUriManager?.setReplaceMap(item, replaceItem);
              }
              this.replaceUriManager?.setVideoCoverMap(replaceUri, coverUri);
              this.broadCast.emit(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, [oriUri, replaceUri, data['date']]);
            })
          })
        })
      } else {
        MediaItemUtil.parseUri(replaceUri).then((mediaItem: MediaItem) => {
          this.replaceUriManager?.setReplaceMap(item ?? new MediaItem(), mediaItem);
          this.broadCast.emit(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, [oriUri, replaceUri, data['date']]);
        });
      }
      this.replaceUriManager?.sendReplaceResult(data['date'] as number, 0, 'ok');
      return;
    }

    let replaceUris = data['replaceUris'];
    if (replaceUris) {
      if (!this.selectParams.isFromPickerView) {
        return;
      }
      this.savePhotosManager.handleSavePhotos(data, this.replaceUriManager);
      return;
    }
    this.handleSelectUris(data);
  }

  // 准备操作
  private handleBadgeConfigPrepare(data: Record<string, Object>, session: UIExtensionContentSession | undefined): void {
    if (this.setReceiveInterval !== -1) {
      clearInterval(this.setReceiveInterval); // 定时器回收
    }
    this.badgeConfigOptionType = data['BadgeOptionType'] as badgeConfigOptionType; // 用于判断是什么操作
    this.badgeConfigReceiveSet.clear(); // 回收内存。
    session?.sendData({ 'dataType': 'onBadgeConfigSend', 'nextIndex': 0 });
    return;
  }

  //接收数据
  private handleBadgeConfigReceive(badgeConfigUri: string[],
    session: UIExtensionContentSession | undefined, data: Record<string, Object>) {
    badgeConfigUri.forEach((item: string) => {
      this.badgeConfigReceiveSet.add(item); // 去重
    });
    if (this.setReceiveInterval !== -1) {
      clearInterval(this.setReceiveInterval); // 回收定时器
    }
    session?.sendData({ 'dataType': 'onBadgeConfigSend', 'nextIndex': Number(data['index']) + 1 });
    this.setReceiveInterval = setInterval(() => {
      session?.sendData({ 'dataType': 'onBadgeConfigSend', 'nextIndex': Number(data['index']) + 1 });
    }, 300); // 兜底操作
    return;
  }

  // 维护两个set，badgeConfigReceiveSet用于接收，badgeConfigUrisSet全量,用badgeConfigUpdate触发子组件更新
  private handleBadgeConfigOver(data: Record<string, Object>): void {
    clearInterval(this.setReceiveInterval);
    this.badgeType = data['badgeConfigType'] as BadgeType;
    Log.info(TAG, `${this.badgeConfigReceiveSet.size}`);
    if (this.badgeConfigOptionType === badgeConfigOptionType.SET_DATA) { // 用于首次收到 或者 更新的时候 更新数据
      this.badgeConfigUrisSet = new Set(this.badgeConfigReceiveSet); // 拷贝数据
    } else if (this.badgeConfigOptionType === badgeConfigOptionType.ADD_DATA) { // 添加数据
      let tempSet = new Set(this.badgeConfigUrisSet);
      this.badgeConfigUrisSet.clear();
      this.badgeConfigReceiveSet.forEach((item: string) => {
        tempSet.add(item);
      });
      if (tempSet.size > this.maxBadgeConfigSize) {
        tempSet = new Set(Array.from(tempSet).splice(0, this.maxBadgeConfigSize)); // 限制最大长度
      }
      this.badgeConfigUrisSet = tempSet;
    } else if (this.badgeConfigOptionType === badgeConfigOptionType.DELETE_DATA) { // 删除数据
      const tempSet = new Set(this.badgeConfigUrisSet);
      this.badgeConfigUrisSet.clear();
      this.badgeConfigReceiveSet.forEach((item: string) => {
        tempSet.delete(item);
      });
      this.badgeConfigUrisSet = tempSet;
    }
    this.badgeConfigReceiveSet.clear();
    this.badgeConfigUpdate = !this.badgeConfigUpdate; // 触发更新
    Log.info(TAG,
      `data is received ${this.badgeType}--${this.badgeConfigOptionType}--${this.badgeConfigUrisSet.size}`);
    return;
  }


  private handleSelectUris(data: Record<string, Object>): void {
    let selectedUris: string[] = data['selectUris'] as string[] ?? [];
    let selectedUrisWithPickerIndex: PreselectedInfo[]  = data['uriAndPickerIndexLists'] as PreselectedInfo[] ?? [];
    // 嵌入式Picker支持滑动选择场景中,如果手势正在滑动中,则不响应用户SetData的SET_SELECTED_URIS类型
    let isBlockCallUpdateSelectUris: boolean = this.selectParams.isFromPickerView;
    isBlockCallUpdateSelectUris &&= this.selectParams.isSlidingSelectionSupported;
    isBlockCallUpdateSelectUris &&= this.isGestureSliding;
    if (!isBlockCallUpdateSelectUris) {
      if (selectedUrisWithPickerIndex.length === 0) {
        this.selectManager?.updateSelectUris(selectedUris);
      } else {
        this.selectManager?.setTotalSelectedItemUriWithPickerIndex(selectedUrisWithPickerIndex);
        selectedUris = selectedUrisWithPickerIndex
          .filter((item: PreselectedInfo) => this.selectManager?.filterWithPickerIndex(item))
          .map((item: PreselectedInfo) => item.uri)
        this.selectManager?.updateSelectUris(selectedUris, false);
      }
    }
    this.selectManager?.updateMediaItemFullState();
    if (this.param?.isRepeatSelectSupported) {
      this.broadCast?.emit(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, [selectedUris]);
    }
    Log.info(TAG, 'ReceiveDataCallback: set selectUris');
  }

  private jumpToPhotoBrowserFromSelectedList(selectedItemUri: string): void {
    // 点击已选列表的item进行预览，跳转进入大图
    Log.debug(TAG, 'jumpToPhotoBrowserFromSelectedList begin')
    let selectedItem: MediaItem | undefined = this.selectManager?.getSelectedItem(selectedItemUri);
    if (!selectedItem) {
      Log.info(TAG, `not find ${selectedItemUri} in selected list`)
      return;
    }
    this.broadCast.emit(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER,
      [true, TAG, selectedItem, , , ThirdSelectConstants.PHOTO_BROWSER_RANGE_SELECTED_ONLY]);
  }

  private jumpToPhotoBrowserFromGridItem(index: number, itemUri: Object, data: Record<string, Object>): void {
    // 点击已选列表的item进行预览，跳转进入大图
    Log.debug(TAG, `jumpToPhotoBrowserFromGridItem index ${index}, itemUri ${itemUri}`)
    if (!itemUri) {
      return;
    }
    let layoutIndex = this.isShowDialog() ? index + 1 : index;
    layoutIndex = this.param?.cameraAble ? layoutIndex + 1 : layoutIndex;
    if (!data['isFromItemClick']){
      this.scroller.scrollToIndex(layoutIndex, false, ScrollAlign.CENTER);
    }
    this.jumpToBrowserDelay(itemUri, data);
  }

  // 检查选中uri列表是否全部存在于当前滑窗内。true表示全部存在于当前滑窗数据内
  private isALLSelectedUrisInWindow(): boolean {
    let selectedUris: string[] | undefined = this.selectManager?.getSelectUris();
    if (selectedUris === undefined) {
      return true;
    }
    if (selectedUris.length <= 0) {
      return true;
    }
    let index: number = 0;
    for (index; index < selectedUris.length; index++) {
      const uri = selectedUris[index];
      if (this.dataSource.getDataIndexByUri(uri) < 0) {
        break;
      }
    }
    return index === selectedUris.length;
  }

  private jumpToPhotoBrowserFromCrossAlnum(selectedItemUri: string, data: Record<string, Object>): void {
    // 当前相册资源下，已选择列表中点击进大图的item未找到，且为只浏览已选照片的模式时。则直接进大图，不通过广播给gridItem添加跳转动效。
    let photoBrowserRange: number = Number(data['photoBrowserRange']);
    let isSelectOnly: boolean = photoBrowserRange === ThirdSelectConstants.PHOTO_BROWSER_RANGE_SELECTED_ONLY;
    Log.debug(TAG, `isSelectOnly is ${isSelectOnly}, photoBrowserRange is ${photoBrowserRange}`)
    if (isSelectOnly) {
      this.jumpToPhotoBrowserFromSelectedList(selectedItemUri);
    } else {
      let selectedItem: MediaItem | undefined = this.selectManager?.getSelectedItem(selectedItemUri);
      if (!selectedItem) {
        Log.info(TAG, `not find ${selectedItemUri} in selected list`);
        return;
      }
      this.broadCast.emit(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER,
        [true, TAG, selectedItem, , , ThirdSelectConstants.PHOTO_BROWSER_RANGE_ALL, true]);
    }
    return;
  }

  private jumpToPhotoBrowser(selectedItemUri: string, itemUri: Object, data: Record<string, Object>) {
    let selectedItem: MediaItem | undefined = this.dataSource.getMediaItemByUri(selectedItemUri);
    if (selectedItem) {
      let index = this.dataSource.getDataIndex(selectedItem);
      Log.info(TAG, `jumpToPhotoBrowser in loaded data: index = ${index}`);
      if (index !== Constants.NOT_FOUND) {
        if (!this.isALLSelectedUrisInWindow()) {
          this.jumpToPhotoBrowserFromCrossAlnum(selectedItemUri, data);
        }
        this.jumpToPhotoBrowserFromGridItem(index, itemUri, data);
      } else {
        Log.info(TAG, 'jumpToPhotoBrowser: invalid index');
        this.jumpToBrowserDelay(itemUri, data);
      }
    } else {
      this.dataSource.getItemIndexByUri(selectedItemUri, (index: number): void => {
        Log.info(TAG, `jumpToPhotoBrowser not in loaded data: index = ${index}`);
        if (index < 0) {
          this.jumpToPhotoBrowserFromCrossAlnum(selectedItemUri, data);
        }
        this.dataSource.getMediaItemByUri(selectedItemUri, (mediaItem: MediaItem): void => {
          this.dataSource.updateSlidingWindow(index);
          let targetIndex = index - this.dataSource.activeStart;
          if (targetIndex >= 0) {
            this.dataSource.items[targetIndex] = mediaItem;
          }
          this.jumpToPhotoBrowserFromGridItem(index, itemUri, data);
        })
      });
    }
  }

  private async handleSetPhotoBrowserItem(itemUri: Object, data: Record<string, Object>): Promise<void> {
    let selectedItemUri: string = String(itemUri);
    let photoBrowserRange: Object = data['photoBrowserRange'];
    this.browserDataSource.setUriToShowAfterDifferenceListFetched(selectedItemUri);
    this.browserDataSource.setAllMode(photoBrowserRange === ThirdSelectConstants.PHOTO_BROWSER_RANGE_ALL);
    this.browserDataSource.setSelectMode(this.selectManager as ThirdSelectManager,
      photoBrowserRange === ThirdSelectConstants.PHOTO_BROWSER_RANGE_SELECTED_ONLY);
    if (this.browserController.isBrowserShow) { // 点击大图界面下方底部缩略图，大图跟随联动
      const index: number = await this.getBrowserPhotoIndex(selectedItemUri);
      this.broadCast?.emit(BroadCastConstants.SET_PHOTO_BROWSER_ITEM, [selectedItemUri, index]);
      LocalStorage.getShared()?.setOrCreate('geometryEnable', false);
    } else { // 宫格界面，点击已选列表中的item预览，跳转进入大图
      this.jumpToPhotoBrowser(selectedItemUri, itemUri, data);
    }
  }

  /**
   * 获取uri对应的index位置
   */
  private async getBrowserPhotoIndex(itemUri: string): Promise<number> {
    let tgtIndex = await this.browserDataSource.getIndexByUri(itemUri);
    Log.info(TAG, `getBrowserPhotoIndex, uri=${itemUri}, tgtIndex=${tgtIndex}`);
    if (tgtIndex !== Constants.NOT_FOUND) {
      return tgtIndex;
    }
    let index: number = -1;
    try {
      index = await new Promise<number>((resolve) => { //3. DataSource里面找
        this.dataSource.getItemIndexByUri(itemUri, (index: number) => {
          Log.info(TAG, `setPhotoBrowserItem not in range: index = ${index}`);
          if (index !== Constants.NOT_FOUND) {
            this.dataSource.updateSlidingWindow(index);
            this.scroller.scrollToIndex(index);
            resolve(index);
          } else {
            resolve(Constants.NOT_FOUND);
          }
        });
      });
    } catch (err) {
      Log.info(TAG, `err=${err.message}`);
    }
    Log.info(TAG,
      `this.browserDataSource.differenceList.length：${this.browserDataSource.differenceList.length}, index=${index}`);
    return index + this.browserDataSource.differenceList.length;
  }

  private jumpToBrowserDelay(itemUri: Object, data: Record<string, Object>): void {
    setTimeout((): void => {
      let photoBrowserRange: Object = data['photoBrowserRange'];
      this.broadCast?.emit(BroadCastConstants.PREVIEW_NOTIFY_PHOTO, [itemUri as string,
        photoBrowserRange as number ?? ThirdSelectConstants.PHOTO_BROWSER_RANGE_ALL]);
    }, 10);
  }

  private setPhotoBrowserUIElementVisibility(photoBrowserElements: Object, data: Record<string, Object>): void {
    let newPhotoBrowserElements: number[] = photoBrowserElements as number[] ?? [];
    if (newPhotoBrowserElements.length === 0) {
      return;
    }
    let isVisible: boolean = data['isVisible'] as boolean ?? true;
    Log.info(TAG, `elments size: ${newPhotoBrowserElements.length}, isvisible: ${isVisible}`);
    newPhotoBrowserElements.forEach((element: number) => {
      if (element === ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_CHECKBOX) {
        if (this.selectParams.isPhotoBrowserCheckboxVisible !== isVisible) {
          this.broadCast.emit(BroadCastConstants.UPDATE_PHOTO_BROWSER_UI_ELEMENT_VISIBILITY,
            [ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_CHECKBOX, isVisible]);
        }
        this.selectParams.isPhotoBrowserCheckboxVisible = isVisible;
      }
      if (element === ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_BACK_BUTTON) {
        if (this.selectParams.isPhotoBrowserBackButtonVisible !== isVisible) {
          this.broadCast.emit(BroadCastConstants.UPDATE_PHOTO_BROWSER_UI_ELEMENT_VISIBILITY,
            [ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_BACK_BUTTON, isVisible]);
        }
        this.selectParams.isPhotoBrowserBackButtonVisible = isVisible;
      }
    })
    return;
  }

  /**
   * 处理选中相册
   * @param albumUri 相册源
   */
  private handleAlbumSelected(albumUri: string, unionAlbumUris: string[] = []): void {
    Log.info(TAG, `ReceiveDataCallback: select album ${albumUri}, unionAlbumUris: ${unionAlbumUris}.`);
    if (albumUri === Constants.ALBUM_URI_ALL_MEDIA) {
      // 图片和视频相册场景
      this.selectParams.itemId = '';
      this.selectParams.uri = '';
    } else {
      this.selectParams.itemId = albumUri;
      this.selectParams.uri = albumUri;
      this.selectParams.unionAlbumUris = unionAlbumUris;
    }
    this.broadCast?.emit(BroadCastConstants.PHOTO_PICKER_COMPONENT_SWITCH_ALBUM, [this.selectParams.uri]);
    this.isAllMediaAlbum = this.selectParams.uri === '';
    this.initSelectParams(this.selectParams);
    this.dataSource.resetActiveWindow();
    this.dataSource.initData();
  }

  /**
   * 处理点击确认
   * @param session 会话
   * @param data 数据
   * @param selectUri 选中源
   */
  private handleClickConfirm(session: UIExtensionContentSession | undefined,
    data: Record<string, Object>, selectUri: Object): void {
    let isConfirm: boolean = data['isConfirm'] as boolean;
    if (isConfirm) {
      Log.info(TAG, 'ReceiveDataCallback: click Confirm');
      session?.sendData({ 'dataType': 'selectOrDeselect', 'select-item-list': selectUri as string, 'isSelect': true });
      for (let selectInfo of this.selectInfoList) {
        if (selectInfo?.uri === (selectUri as string)) {
          this.onSelectChanged(
            selectInfo.position, selectInfo.uri, selectInfo.selectState, selectInfo.callback);
          this.broadCast?.emit(BroadCastConstants.SELECT_CONFIRM, [selectUri as string]);
          break;
        }
      }
    } else {
      this.selectManager?.updateTotalSelectUris(selectUri as string, false);
      if (!this.param?.isRepeatSelectSupported || this.selectManager?.getCountByUri(selectUri as string) === 0) {
        this.pickerPhotoGridController.setSelectInfoList(this.selectInfoList);
        let storage = LocalStorage.getShared();
        let params = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
        this.pickerPhotoGridController.revokePermissionByUri(selectUri as string, params?.bundleName);
      }
    }
    this.selectInfoList = this.selectInfoList.filter((item: SelectInfo) => {
      return item?.uri !== (selectUri as string);
    })
  }

  /**
   * 返回
   */
  onBackPress() {
    this.onMenuClicked(this.selectParams.isFromFa ? Action.BACK : Action.CANCEL);
    clearInterval(this.setReceiveInterval)
  }

  /**
   * 页面显示
   */
  onPageShow() {
    Log.debug(TAG, 'onPageShow');

    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
    this.isItemIdChange =
      (this.itemId && this.param?.itemId !== undefined && this.param.itemId !==
        '' && this.itemId !== this.param.itemId) as boolean;
    if (this.isItemIdChange) {
      this.initSelectParams(this.param);
    }

    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    this.updateSystemUi();
    this.onActive();
  }

  private updateSystemUi() {
    if (!this.browserController.isBrowserShow) {
    }
  }

  /**
   * 页面变化
   */
  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  /**
   * 页面隐藏
   */
  onPageHide() {
    Log.debug(TAG, 'onPageHide');
    this.isShow = false;
    this.onInActive();
    this.stopCreateThumbnail();
  }

  /**
   * 页面消失
   */
  aboutToDisappear(): void {
    getContext(this)?.eventHub?.off(Constants.PHOTO_PICKER_ON_FOREGROUND, this.pickerOnForegroundFun)
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver = undefined;
    MediaItemUtil.deleteAllPickPhoto(this.replaceUriManager?.getAllCreateUris(), getContext(this).filesDir)
    this.dataSource.releaseBroadCast();
    this.inputDataSource?.releaseBroadCast();

    if (this.broadCast) {
      this.broadCast.off(BroadCastConstants.SELECT, this.funcOnSelectCallback);
      this.broadCast.off(BroadCastConstants.CAMERA_SELECT, this.funcOnCameraSelectCallback);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.funcJumpBrowserCallback);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER_BY_SELECTED, this.funcJumpBrowserBySelected);
      this.broadCast.off(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT, this.funcUpdateSystemUiOnEditorExit);
      this.broadCast.off(Constants.ON_LOADING_FINISHED, this.funcOnLoadingFinished);
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.funcOnReloadFinishedCallback);
      this.broadCast.off(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
      this.broadCast.off(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER, this.previewJumpBrowserCallbackFunc);
      this.broadCast.off(BroadCastConstants.PREVIEW_EXIT_PHOTO_BROWSER, this.previewExitBrowserCallbackFunc);
      this.broadCast.off(BroadCastConstants.THIRD_PICKER_ALBUM_GIRD_CLOSE, this.funcOnAlbumGirdCloseCallback);
      this.broadCast.off(BroadCastConstants.SWITCH_THIRD_ALBUM, this.onSwitchThirdAlbumFunc);
      this.broadCast.off(BroadCastConstants.OCCUPY_EVENTS, this.onOccupyEvents);
    }
    if (this.appBroadCast) {
      this.appBroadCast.off(BroadCastConstants.OPEN_BROWSER_IN_SELECT_VIEW, this.onOpenBrowserInSelectView);
      this.appBroadCast.off(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW,
        this.onCloseBrowserAndReturnToSelectView);
      this.appBroadCast.off(BroadCastConstants.PHOTO_PICKER_APP_LOCK_STATUS_UPDATED,
        this.onPhotoPickerAppLockStatusUpdated);
      this.appBroadCast.off(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, this.clearScrollHistory);
      this.appBroadCast.off(BroadCastConstants.UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR, this.updateRecoverInfoAfterGetAnchor);
    }
    if (this.selectManager) {
      this.selectManager.clearTaskMission();
    }
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.initGridRowOrColCountFunc);
    if (!this.selectParams.isFromPickerView && this.isSpecialCreatePicker() && subscriber) {
      commonEventManager.unsubscribe(subscriber);
    }
    PhotoAccessHelperAccess.thirdSelectPrivacyMap.delete(this.selectParams.tokenId);
    clearInterval(this.setReceiveInterval)
    this.stopCreateThumbnail('about to disappear');
    Log.info(TAG, 'call aboutToDisappear');
  }

  private pickerOnForegroundFun: Function = (isOnForeground: boolean): void => {
    Log.info(TAG, `pickerOnForegroundFun: isOnForeground=${isOnForeground}`);
    if (isOnForeground) {
      this.maskLayerUtils.init();
      this.updateTitle(this.param);
    }
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (!this.isActive) {
      this.dataSource.hasNewChange = true;
      return;
    }
    this.selectionChecker?.check();
    this.albumChecker?.check();
    this.dataSource.onNotify(nfyInfo);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  private isInRecoverProcess(): boolean {
    return this.param?.recoverSceneEnabled || this.isReScrollAfterGetAnchor || this.isReScrollAfterDataLoaded
  }

  getGeometryTransitionId(item: ViewData, index: number): string {
    let mediaItem = item.mediaItem;
    if (mediaItem) {
      return TAG + mediaItem.getHashCode() +
        (this.selectManager?.isItemSelected(mediaItem.uri as string) ?? false);
    } else {
      return TAG + index;
    }
  }

  onGetItemByUri(mediaItem: MediaItem): void {
    Log.info(TAG, `onGetItemByUri: MediaItem mediaItem.index =  ${
    mediaItem.index} mediaItem.uri ` + mediaItem.uri + ' mediaItem.mediaType ' +
    mediaItem.mediaType + ' mediaItem.thumbnail ' + mediaItem.thumbnail);
    if (mediaItem?.thumbnail == undefined) {
      mediaItem.thumbnail = this.uriResult as string;
    }
    this.dataSource.cameraItems.push(mediaItem);
    this.broadCast.emit(BroadCastConstants.SELECT, [0, mediaItem.uri, !this.selectParams.isFromPickerView, undefined]);
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  private onIsVerdeFoldableChanged(): void {
    this.isSearchVisible = !this.isVerdeFoldable;
  }

  private onFirstDataInitCallBack(): void {

  }

  /**
   * 相册数量变化的回调
   *
   * @param size 相册数量
   */
  private onThirdSelectAlbumPhotosUpdate(size: number): void {
    this.allAlbumInfoMap.clear();
    this.albums?.mediaAlbumList.forEach((item: AlbumInfo) => {
      this.allAlbumInfoMap.set(item.uri, item);
    })
    Log.info(TAG, `onThirdSelectAlbumPhotosUpdate allAlbumInfoMap length: ${this.allAlbumInfoMap.length}`);
  }

  @Builder
  buildAlbums() {
    ThirdSelectAlbumListBase({
      param: this.selectParams,
      pageStatus: this.pageStatus,
      selectId: this.currentSelectedAlbumId,
      selectedCount: $selectedCount,
      isNeedFilterAlbumSource: this.isNeedFilterSourceAlbum,
      sourceAlbumUri: this.sourceAlbumUri,
      photoDataSource: this.dataSource,
      winHeight: this.winHeight,
      isVerdeFoldable: this.isVerdeFoldable
    })
      .borderRadius(8)
      .margin({
        left: this.isHorizontal ? 0 : getScreen()
          .getLeftSafePadding($r('sys.float.ohos_id_card_margin_start'), false),
        right: this.isHorizontal ? 0 : getScreen()
          .getRightSafePadding($r('sys.float.ohos_id_card_margin_end'), false),
        top: DeviceInfo.isTv() ? 11 : $r('sys.float.ohos_id_elements_margin_vertical_m'),
        bottom: this.thirdSelectAlbumListBaseBottom(),
      })
      .transition(
        TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END).combine(
          TransitionEffect.OPACITY
        ),
          TransitionEffect.move(TransitionEdge.END)).combine(
          TransitionEffect.OPACITY
        )
      )
  }

  @Builder
  buildAlbumsSideBar() {
    Column() {
      Text($r('app.string.title_select_photos'))
        .margin({ top: LengthMetrics.vp(37), start: LengthMetrics.vp(32) })
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .fontSize(27)
        .width($r('app.float.tv_picker_album_title_height'))
        .height(37)
      Column() {
        this.buildAlbums()
      }
      .height($r('app.float.tv_picker_albums_height'))
      PickerSelectTip().margin({ start: LengthMetrics.vp(32) })
    }.alignItems(HorizontalAlign.Start)
    .width($r('app.float.tv_picker_album_side_bar_height'))
    .height('100%')
    .backgroundColor(Constants.HISTOGRAM_INTERNAL_STROKE_COLOR)
  }

  thirdSelectAlbumListBaseBottom() {
    if (this.selectParams.isFromFa) {
      return this.diggingHoleCameraArea.bottom;
    }
    return 0;
  }

  /**
   * 分段按钮bar
   */
  @Builder
  SegmentButtonBar() {
    Stack({alignContent: Alignment.End}) {
      Row() {
        SegmentButton({ options: this.tabOptions, selectedIndexes: this.tabSelectedIndexes })
          .key('SegmentButton')
          .align(Alignment.Center)
          .width('100%')
          .height($r('app.float.picker_segment_button_height'))
          .defaultFocus(false)
      }
      .opacity(((this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) &&
      this.browserController.isPullDownAndDrag) ? (1 - this.geometryOpacity) : this.searchBarAndCapsuleOpacity)
      .focusable(false)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(Constants.ActionBarHeight + Constants.ActionBarPaddingHeight)
      .width('100%')
      .padding({
        left: $r('app.float.picker_segment_button_margin_start_and_end'),
        right: $r('app.float.picker_segment_button_margin_start_and_end'),
        top: this.isVerdeFoldable ? Constants.PICKER_SEGMENT_BAR_PADDING_TOP : $r('app.float.tab_bar_padding_top'),
        bottom: this.isVerdeFoldable ? Constants.PICKER_SEGMENT_BAR_PADDING_BOTTOM :
          $r('app.float.tab_bar_padding_bottom'),
      })
      .margin({
        top: $r('sys.float.ohos_id_elements_margin_vertical_m'),
      })
      if (DeviceInfo.isPhoneOrTablet()) {
        PickerCloseButton({
          pickerController: this.controller,
          topMargin: $r('sys.float.ohos_id_elements_margin_vertical_m'),
          componentHeight: Constants.ActionBarHeight + Constants.ActionBarPaddingHeight,
        })
      }
    }
  }

  @Builder
  buildGrid() {
    Stack({ alignContent: Alignment.Start }) {
      ThirdSelectAlbumGridBase({
        replaceUriManager: this.replaceUriManager,
        scroller: this.scroller,
        selectParams: this.selectParams,
        dataSource: this.dataSource,
        isSearchVisible: this.isSearchVisible,
        selectManager: this.selectManager,
        browserController: this.browserController,
        gridItemWidth: this.gridItemWidth,
        gridItemHeight: this.gridItemHeight,
        isNeedTransition: this.isNeedTransition,
        isShowScrollBar: this.isShowScrollBar,
        isVisibleScrollBar: this.isVisibleScrollBar,
        gridRowCount: this.gridRowCount,
        gridColCount: this.gridColCount,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        panelId: this.panelId,
        selectedCount: this.selectedCount,
        totalCount: this.totalCount,
        isFromAlbum: false,
        showActionBar: false,
        title: this.title,
        isPageHidden: this.isPageHidden,
        isGestureSliding: $isGestureSliding,
        searchController: this.searchController,
        displaySearchWords: this.displaySearchWords,
        isSetOriginal: this.isSetOriginal,
        isPreviewForSingleSelectionSupported: this.selectParams.isPreviewForSingleSelectionSupported,
        singleSelectionMode: this.selectParams.singleSelectionMode,
        isOriginalSupported: this.selectParams.isOriginalSupported,
        moreMenuList: this.moreMenuList,
        isRefreshSelectState: $isRefreshSelectState,
        completeButtonText: this.selectParams.completeButtonText,
        layoutOptions: this.layoutOptions,
        isPhotoInner: this.isPhotoInner,
        placeholderIndex: this.placeholderIndex,
        thirdSelectController: this.controller,
        isVerdeFoldable: this.isVerdeFoldable,
        isPickerMaskLayerShow: this.isPickerMaskLayerShow,
        isSlidingHorizontally: this.isHorizontalPickerOrientation(),
        singleLineConfig: this.selectParams.singleLineConfig,
        placeholderIndexChangedCallback: this.onPlaceholderChanged,
        cancelFunc: this.cancelFunc,
        isReScrollAfterGetAnchor: this.isReScrollAfterGetAnchor,
        isReScrollAfterDataLoaded: this.isReScrollAfterDataLoaded,
        badgeType: this.badgeType,
        badgeConfigUrisSet: this.badgeConfigUrisSet,
        badgeConfigUpdate: this.badgeConfigUpdate
      });
    }
    //防止子组件手势冲突
    .parallelGesture(
      GestureGroup(GestureMode.Exclusive,
        PanGesture()
      )
    )
    .onTouch((event) => {
      if (this.isRecommendListVisible) {
        this.isRecommendListVisible = false;
      }
    })
    .padding({
      bottom: this.selectParams.isFromFa ? this.diggingHoleCameraArea.bottom : 0,
    })
    .width(DeviceInfo.isTv() ? this.pickerSidebarContentWidth : '100%')
    .height('100%')
    .layoutWeight(1)
    .transition(TransitionEffect.OPACITY)
    .onAppear((): void => {
      Log.info(TAG, 'ThirdSelectAlbumGridBase onAppear');
    })
  }

  @Builder
  buildRowGridBase() {
    Row() {
      this.buildAlbumsSideBar();
      WithTheme({ theme: this.colorTheme }) {
        this.buildPickerGrid();
      }
    }
    .onAreaChange((oldVal: Area, newVal: Area) => {
      this.winHeight = newVal.height as number;
    })
    .width('100%')
    .height('100%')
    .backgroundColor((this.selectParams.isFromPickerView && this.selectParams.backgroundColor != '') ?
    this.selectParams.backgroundColor : Color.Transparent)
  }

  @Builder
  buildFlexGridBase() {
    Stack() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start,
      }) {
        if (this.selectParams?.isNeedActionBar) {
          this.SegmentButtonBar();
        }
        if (this.param?.itemDisplayName && this.param?.highlightPickerType === COMPONENT_KEY_COVER_HIGHLIGHT) {
          ThirdSelectedPageActionBar({
            leftAction: Action.NONE,
            isSelectPhotoGrid: true,
            title: this.title,
            selectParams: this.selectParams,
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
            isFirstEnter: this.isFirstEnter,
            totalSelectedCount: $selectedCount,
            isSearchEnabled: this.isSearchVisible,
            moreMenuList: this.moreMenuList,
            pickerController: this.controller,
          });
        }
        WithTheme({ theme: this.colorTheme }) {
          this.buildSegmentContent();
        }
      }
      .onAreaChange((oldVal: Area, newVal: Area) => {
        this.winHeight = newVal.height as number;
      })
      .width('100%')
      .height('100%')
      .backgroundColor((this.selectParams.isFromPickerView && this.selectParams.backgroundColor !== '') ?
      this.selectParams.backgroundColor : Color.Transparent)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.selectParams.isFromPickerView ? $r('sys.color.background_secondary') : Color.Transparent)
  }

  build() {
    Navigation(this.pageInfo) {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.buildRowGridBase();
      } else {
        this.buildFlexGridBase();
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      if (!this.isFirstOnAreachange) {
        this.broadCast.emit(Constants.UPDATE_NAVIGATION_HEIGHT, [Number(newValue.height)]);
        this.isFirstOnAreachange = true;
      } else {
        return;
      }
    })
    .opacity(((this.browserController.isBrowserShow || this.browserController.isSelectBrowserShow) &&
    this.browserController.isPullDownAndDrag) ? (1 - this.geometryOpacity) : 1)
    .mode(NavigationMode.Stack)
    .title('ThirdSelectPhotoGridBase')
    .hideTitleBar(true)
    .hideToolBar(true)
    .navDestination(this.PageMap)
    .visibility(this.isPageHidden)
    .transition(TransitionEffect.OPACITY)
    .margin(this.selectParams?.gridMargin)
  }

  @Builder
  buildPickerGrid() {
    Column() {
      if (this.isNeedShowEmptyPage() && !DeviceInfo.isTv()) {
        this.buildNoPhotoComponent();
        if (this.selectParams?.isNeedSelectBar) {
          this.buildPanel();
        }
        if (!this.selectParams.isFromPickerView) {
          PickerSelectTip()
            .margin({
              bottom: (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
              $r('app.float.navigation_margin_bottom') : $r('app.float.picker_footer_safety_height'))
            });
        }
      } else {
        this.buildGrid();
      }
    }
    .flexGrow(1)
    .transition(
      TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.START).combine(
        TransitionEffect.OPACITY
      ),
        TransitionEffect.move(TransitionEdge.START)).combine(
        TransitionEffect.OPACITY
      )
    )
  }

  @Builder
  buildSegmentContent() {
    Stack() {
      // 相册列表页
      if (this.albumsShow) {
        this.buildAlbums();
      } else {
        // 图片宫格页
        this.buildPickerGrid()
      }
      if (this.isPickerMaskLayerShow && !this.browserController.isBrowserShow && !this.isEnterAlbums) {
        PhotoPickerMaskLayer({
          isPickerMaskLayerShow: this.isPickerMaskLayerShow,
          photoBrowserBackgroundColorMode: this.selectParams.photoBrowserBackgroundColorMode,
        })
      }
    }
  }

  private isNeedShowEmptyPage(): boolean {
    return this.isEmpty && !this.displaySearchWords &&
      (this.selectParams.isFromFa || !this.selectParams.cameraAble);
  }

  @Builder
  buildPanel() {
    ThirdSelectedPanel({
      maxSelectCount: this.selectParams.maxSelectCount,
      onMenuClicked: (action: Action): void => {
      },
      mTransition: TAG,
      currentUri: '',
      isShowBar: $isShowBar,
      totalSelectedCount: $selectedCount,
      totalCount: this.totalCount,
      dataSource: this.dataSource,
      needInit: false,
      panelId: this.panelId,
      isSetOriginal: this.isSetOriginal,
      isShowImage: false,
      isOriginalSupported: this.selectParams.isOriginalSupported,
      isImmersiveCompared: this.selectParams.isImmersiveCompared,
      isCollagePageEnter: this.selectParams.isCollagePageEnter,
      completeButtonText: this.selectParams.completeButtonText,
      browserController: this.browserController,
    })
  }

  @Builder
  buildNoPhotoComponent() {
    if (this.selectParams.isFromFa) {
      NoPhotoIndexComponent({ prop: EMPTY_PICKER, subTitle: this.subTitle })
    } else {
      if (!this.selectParams.cameraAble || this.albumsShow) {
        if (this.isShowDialog() && !DeviceInfo.isTv()) {
          this.buildPickerWarningDialog();
        }
        List() {
          NoPhotoComponent({
            title: this.selectManager?.selectParam?.recommendationType !== SelectConstants.RECOMMEND_TYPE_COLOR_STYPE ?
            $r('app.string.no_distributed_photo_head_title_album') : $r('app.string.color_stype_no_photo'),
            winHeight: this.winHeight,
            isThird: true,
          })
        }
          .layoutWeight(1)
          .sticky(StickyStyle.Header)
      }
    }
  }

  @Builder
  buildPickerWarningDialog() {
    GridItem() {
      PickerViewWarningDialog({
        appName: this.selectParams.bundleName,
        isFromPickerView: this.selectParams.isFromPickerView,
        color: this.selectParams.backgroundColor,
        uiComponentColorMode: this.selectParams.uiComponentColorMode,
        emitHidePickerViewWarningDialog: (): void => {
          if (this.selectParams.isFromPickerView) {
            this.isShowPickerViewWarnDialog = false;
          } else {
            this.isShowPickerWarnDialog = false;
          }
        },
      })
    }
  }

  jumpToBrowserGeometryTransition(showCancel: boolean, targetIndex: number,
    name: string, item: MediaItem, isSelectMode = false,
    geometryTapIndex: number,
    geometryTransitionString: string, isAllMode = false): void {

    const params: Params = {
      showCancel,
      position: targetIndex,
      bundleName: this.selectParams.bundleName,
      tokenId: this.selectParams.tokenId,
      transition: name,
      title: this.title,
      selectMode: isSelectMode,
      isAllMode: isAllMode,
      maxSelectCount: this.selectParams.maxSelectCount,
      maxSelectedReminderMode: this.selectParams.maxSelectedReminderMode,
      isFromFa: this.selectParams.isFromFa,
      geometryTransitionEnable: geometryTapIndex !== undefined && geometryTransitionString !== undefined,
      isNeedSelectBar: this.selectParams.isNeedSelectBar,
      isShowSerialNum: this.selectParams.isShowSerialNum,
      isFromPickerView: this.selectParams.isFromPickerView,
      singleSelectionMode: this.selectParams.singleSelectionMode,
      checkBoxColor: this.selectParams.checkBoxColor,
      checkboxTextColor: this.selectParams.checkboxTextColor,
      isOriginalSupported: this.selectParams.isOriginalSupported,
      photoBrowserBackgroundColorMode: this.selectParams.photoBrowserBackgroundColorMode,
      isRepeatSelectSupported: this.selectParams.isRepeatSelectSupported,
      customColor: this.selectParams.customColor,
      completeButtonText: this.selectParams.completeButtonText,
      isPhotoBrowserCheckboxVisible: this.selectParams.isPhotoBrowserCheckboxVisible,
      isPhotoBrowserBackButtonVisible: this.selectParams.isPhotoBrowserBackButtonVisible,
      photoBrowserCheckboxPosition: this.selectParams.photoBrowserCheckboxPosition,
      isImmersiveCompared: this.selectParams.isImmersiveCompared,
      isCollagePageEnter: this.selectParams.isCollagePageEnter,
      highlightPickerType: this.selectParams.highlightPickerType,
      isHighlightPickerView: this.selectParams.isHighlightPickerView,
      photoBrowserMargin: this.selectParams.photoBrowserMargin,
      item: item,
      pickerIndex: this.selectParams.pickerIndex,
      preselectedInfos : this.selectParams.preselectedInfos,
    };
    this.browserDataSource.setAllMode(params.isAllMode ?? false);
    this.browserDataSource.setSelectMode(this.selectManager as ThirdSelectManager, params.selectMode);
    Log.info(TAG, `jumpToBrowserGeometryTransition params: ${
    JSON.stringify(params)} geometryTransitionString: ${geometryTransitionString
    }, geometryTapIndex ${geometryTapIndex}`)
    this.browserController.showBrowser(geometryTapIndex,
      geometryTransitionString, 'ThirdSelectAlbumGridBase', params);
  }

  private initGridRowCount(): void {
    /* instrument ignore next */
    if (this.param?.singleLineConfig) {
      this.gridRowCount = 1;
      Log.info(TAG, `singleLineMode row count ${this.gridRowCount}`);
      return;
    }
    if (DeviceInfo.isTv() && this.pickerSidebarContentWidth > 0) {
      this.gridRowCount = Math.round(2 * (this.pickerSidebarContentWidth / UiUtil.minDpNum - 1) + this.photoGridNum);
      this.gridItemWidth =
        (this.pickerSidebarContentWidth - (this.gridRowCount - 1) * Constants.GRID_GUTTER) / this.gridRowCount;
      Log.info(TAG, `row count ${this.gridRowCount}  ${this.gridItemWidth}`);
      return;
    }
    const isVerticalPhone: boolean = !this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable();
    const contentWidth =
      (isVerticalPhone ||
        this.param?.isFromPickerView) ? getScreen().getWinWidth() :
      Math.min(this.PHONE_HORIZONTAL_SHEET_WIDTH, ScreenManager.getInstance().getWinWidth());
    this.gridRowCount = Math.round(2 * (contentWidth / UiUtil.minDpNum - 1) + this.photoGridNum);
    RecoverController.setRecoverGridRowCount(this.gridRowCount);
    Log.info(TAG, `initGridRowCount sta1 gridRowCount: ${this.gridRowCount}`)
    this.gridItemWidth = (contentWidth - (this.gridRowCount - 1) * Constants.GRID_GUTTER) / this.gridRowCount;
    this.gridItemHeight = this.gridItemWidth;
    Log.info(TAG, ` row count ${this.gridRowCount}`);
  }

  private initGridColCount(): void {
    if (this.param?.singleLineConfig) {
      this.gridColCount = 1;
      Log.info(TAG, `singleLineMode col count ${this.gridColCount}`);
      return;
    }
    const isVerticalPhone: boolean = !this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable();
    const contentWidth =
      (isVerticalPhone ||
        this.param?.isFromPickerView) ? getScreen().getWinWidth() :
      Math.min(this.PHONE_HORIZONTAL_SHEET_WIDTH, ScreenManager.getInstance().getWinWidth());
    this.gridRowCount = Math.round(2 * (contentWidth / UiUtil.minDpNum - 1) + this.photoGridNum);
    this.gridItemWidth = (contentWidth - (this.gridRowCount - 1) * Constants.GRID_GUTTER) / this.gridRowCount;
    const contentHeight = getScreen().getWinHeight();
    this.gridColCount = Math.round(contentHeight / (this.gridItemWidth + Constants.GRID_GUTTER));
    this.gridItemHeight = (contentHeight - (this.gridColCount - 1) * Constants.GRID_GUTTER) / this.gridColCount;
    this.gridItemWidth = this.gridItemHeight;
    Log.info(TAG, `initGridColCount gridItemHeight = ${this.gridItemHeight}, gridColCount: ${this.gridColCount}`);
  }

  private initSelectParams(param?: SelectParams, isPreLoad?: boolean): void {
    Log.info(TAG, `initSelectParams param - albumUri: ${param?.albumUri}`)
    if (param) {
      this.initParams(param, isPreLoad);
      if (param.isFromFa != undefined || param.isFromFa != undefined) {
        this.selectParams.isFromFa = param.isFromFa;
        LocalStorage.getShared()?.setOrCreate(FormConstants.FORM_ITEM_ALBUM_URI, param.uri);
        LocalStorage.getShared()?.setOrCreate(FormConstants.FORM_ITEM_DISPLAY_NAME, param.itemDisplayName);
      }
      if (param.isFromFaPhoto != undefined || param.isFromFaPhoto != undefined) {
        this.selectParams.isFromFaPhoto = param.isFromFaPhoto;
      }
      if (param.isFirstEnter != undefined || param.isFirstEnter != undefined) {
        this.isFirstEnter = param.isFirstEnter;
      }
      if (param.filterMediaType) {
        this.initTabOptions(param);
      }
      if (!this.dataSource.isInitData) {
        Log.info(TAG, 'initSelectParams: dataSource is not init');
        this.dataSource.setFilterMediaType(this.selectParams.filterMediaType);
        this.dataSource.initData();
        if (this.photoDataImpl instanceof PickerDataImplAsync) {
          (this.photoDataImpl as PickerDataImplAsync).setContext(getContext());
        }
      }
      this.selectParams.isFromWallpaper = param.isFromWallpaper;
      if (this.selectParams.isFromWallpaper) {
        this.selectParams.maxSelectCount = param.remainingOfWallpapers;
      } else {
        // 第三方拉起图库选择时，有传入最大就用传入的，没有用50
       if(param.maxSelectCount){
         this.selectParams.maxSelectCount = param.maxSelectCount
       }else {
         this.selectParams.maxSelectCount = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;;
       }
      }
      if (this.backFuncBinder !== undefined) {
        this.backFuncBinder((): void => this.onBackPress());
      }
      if (Array.isArray(param?.preselectedInfos)) {
        this.selectParams.preselectedInfos = param.preselectedInfos;
        Log.info(TAG, `Filtered preselectedInfos for pickerIndex=${this.selectParams.preselectedInfos}`);
      }
      if (param?.pickerIndex !== undefined) {
        this.selectParams.pickerIndex = param.pickerIndex;
        Log.info(TAG, `selectParams.pickerIndex set to ${this.selectParams.pickerIndex}`);
      }
      this.isSearchVisible = !this.isVerdeFoldable && param?.searchAble;
      Log.info(TAG, `initSelectParams sta1 select param ${JSON.stringify(this.selectParams)}`);
    }
    // 进入页面时默认开启多选模式
    this.isSelectedMode = true;
    // 强制开启多选能力，以便在缩略图右下角展示多选框
    this.selectParams.isMultiPick = true;
    // 开启显示选择顺序序号
    this.selectParams.isShowSerialNum = true;
    if (param != undefined && param.customColor != undefined) {
      this.selectParams.customColor = param?.customColor;
    }
    this.colorTheme = DefaultThemeColor.getCustomTheme(this.selectParams.customColor);
    Log.info(TAG, `initSelectParams sta2 select param ${
    JSON.stringify(this.selectParams)}, select mode ${this.isSelectedMode}`);
  }

  private initTabOptions(param: SelectParams) {
    this.selectParams.filterMediaType = param.filterMediaType;
    let photoOrVideo: Resource;
    switch (param.filterMediaType) {
      case AlbumDefine.FILTER_MEDIA_TYPE_IMAGE:
        photoOrVideo = $r('app.string.all_photos');
        break;
      case AlbumDefine.FILTER_MEDIA_TYPE_VIDEO:
        photoOrVideo = $r('app.string.all_videos');
        break;
      default:
        photoOrVideo = $r('app.string.pictures_and_videos');
        break;
    }
    this.tabOptions = SegmentButtonOptions.tab({
      buttons: [{ text: photoOrVideo }, {
        text: $r('app.string.all_albums'),
      }] as ItemRestriction<SegmentButtonTextItem>,
      selectedBackgroundColor: $r('sys.color.comp_background_list_card'),
      fontWeight: FontWeight.Medium,
      selectedFontWeight: FontWeight.Medium,
      buttonPadding: {
        top: '9.6vp',
        bottom: '9.6vp',
      }
    });
  }

  private initParams(param: SelectParams, isPreLoad?: boolean): void {
    this.isItemIdChange = (CommonUtil.isValidObject(this.itemId) && this.itemId !== param.itemId) as boolean;
    this.itemId = param.itemId == undefined ? AlbumDefine.ALBUM_ID_ALL : param.itemId;
    this.dataSource.setAlbumUri(this.itemId as string);
    let albumUri = param.uri ?? param.albumUri ?? param.albumUriForRecover ?? this.itemId;
    Log.info(TAG, `[initSelectParams] get image album uri is: ${UserFileManagerAccess.getInstance(this.storage)
      .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE)}, param.uri: ${param.uri}, param.albumUri: ${param.albumUri}, param.albumUriForRecover: ${param.albumUriForRecover}, albumUri: ${albumUri}`);

    this.currentSelectedAlbumId = albumUri;

    this.dataSource.setAlbumUri(albumUri);
    if (param && param.unionAlbumUris && param.unionAlbumUris.length > 0) {
      this.dataSource.setAlbumUris(param.unionAlbumUris);
      this.dataSource.isUnionAlbum = true;
    } else {
      this.dataSource.isUnionAlbum = false;
    }
    if (!isPreLoad) {
      this.dataSource.resetActiveWindow();
    }

    this.updateTitle(param);
    this.selectParams.bundleName = param.bundleName;
    this.selectParams.userId = param.userId ?? -1;
    this.selectParams.callerAbilityName = param.callerAbilityName;
    this.selectParams.tokenId = param.tokenId;
    this.selectParams.isMultiPick = param.isMultiPick;
    this.selectParams.isOriginalSupported = param.isOriginalSupported;
    this.selectParams.isPreviewForSingleSelectionSupported = param.isPreviewForSingleSelectionSupported;
    this.selectParams.singleSelectionMode = param.singleSelectionMode;
    this.selectParams.albumUriForRecover = param.albumUriForRecover;
    this.selectParams.timeAnchorForRecover = param.timeAnchorForRecover;
    this.selectParams.displayNameForRecover = param.displayNameForRecover;
    this.selectParams.dataIndexForRecover = param.dataIndexForRecover;
    this.selectParams.recoverSceneEnabled = param.recoverSceneEnabled;
    this.selectParams.hasGotRecoverAnchor = param.hasGotRecoverAnchor;
    this.selectParams.isRecoverAlbum = param.isRecoverAlbum;
    Log.info(TAG, `[initSelectParams] dataIndexForRecover is: ${this.selectParams.dataIndexForRecover}`);
    this.selectParams.isNeedSelectBar = param.isNeedSelectBar;
    this.selectParams.isNeedActionBar = param.isNeedActionBar;
    this.selectParams.isFromPickerView = param.isFromPickerView;
    this.selectParams.checkBoxColor = param.checkBoxColor;
    this.selectParams.checkboxTextColor = param.checkboxTextColor;
    this.selectParams.backgroundColor = param.backgroundColor;
    this.selectParams.isRepeatSelectSupported = param.isRepeatSelectSupported;
    this.selectParams.albumUri = param.albumUri;
    this.selectParams.unionAlbumUris = param.unionAlbumUris;
    this.selectParams.gridMargin = param.gridMargin;
    this.selectParams.photoBrowserMargin = param.photoBrowserMargin;
    this.selectParams.gridStartOffset = param.gridStartOffset;
    this.selectParams.gridEndOffset = param.gridEndOffset;
    if (param.maxPhotoSelectNumber !== undefined && param.maxPhotoSelectNumber >= 0) {
      this.selectParams.maxPhotoSelectNumber =
        Math.min(param.maxPhotoSelectNumber, Constants.LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT);
    }
    if (param.maxVideoSelectNumber !== undefined && param.maxVideoSelectNumber >= 0) {
      this.selectParams.maxVideoSelectNumber =
        Math.min(param.maxVideoSelectNumber, Constants.LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT);
    }
    this.selectParams.maxSelectedReminderMode = param.maxSelectedReminderMode;
    this.selectParams.photoBrowserBackgroundColorMode = param.photoBrowserBackgroundColorMode;
    this.selectParams.isImmersiveCompared = param.isImmersiveCompared;
    this.selectParams.isCollagePageEnter = param.isCollagePageEnter;
    this.selectParams.completeButtonText = param.completeButtonText;
    this.selectParams.isSlidingSelectionSupported = param.isSlidingSelectionSupported;
    this.selectParams.photoBrowserCheckboxPosition = param.photoBrowserCheckboxPosition;
    this.selectParams.orientation = param.orientation;
    this.selectParams.singleLineConfig = param.singleLineConfig;
    this.selectParams.uiComponentColorMode = param.uiComponentColorMode;
    this.selectParams.pickerIndex = param.pickerIndex;
  }

  private updateTitle(param?: SelectParams): void {
    let displayName: Resource | string = param?.itemDisplayName == undefined ? $r('app.string.album_all') : param.itemDisplayName;
    if (typeof displayName === 'object') {
      UiUtil.getResourceString(displayName as Resource)?.then((stringResource: string) => {
        this.title = stringResource;
         if (this.browserController.isBrowserShow) {
           this.pickerBrowsertTitle = this.title;
         }
      })
    } else {
      this.title = displayName as string;
    }
    Log.debug(TAG, `update title ${this.title}`);
  }

  private onSelectCallback(position: number, key: string, value: boolean, callback: Function, mediaItem?: MediaItem): void {
    let isMultiPick = this.selectParams.isMultiPick;
    let isHybridMode = this.selectParams.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE;
    let isFromPickerView = this.selectParams.isFromPickerView;
    if ((isMultiPick || isFromPickerView || isHybridMode) && value && this.selectManager?.getMediaItemFunc &&
    this.selectManager?.isSelectFull(this.selectManager?.getMediaItemFunc(key))) {
      if (this.param?.maxSelectedReminderMode === undefined ||
        this.param?.maxSelectedReminderMode === Constants.TOAST_REMIND_MODE) {
        UiUtil.showToast($r('app.string.up_to_limit_tips'));
      }
      if (isFromPickerView) {
        let storage = LocalStorage.getShared();
        PickerUtil.exceedMaxSelectedSendData(this.selectManager?.getMediaItemFunc(key), this.selectManager,
          this.selectManager?.selectParam, storage);
      }
      return;
    }
    this.handleSelectChanged(position, key, value, callback, mediaItem);
  }

  private handleSelectChanged(position: number, key: string, value: boolean,
    callback: Function, item?: MediaItem): void {
    if (this.selectParams?.isFromPickerView || (DeviceInfo.isTv() && this.selectParams?.isFromFa)) {
      if (value) {
        let selectInfo = new SelectInfo();
        selectInfo.uri = key;
        selectInfo.position = position;
        selectInfo.selectState = value;
        selectInfo.callback = callback;
        selectInfo.item = item;
        selectInfo.state = 0;
        this.selectInfoList.push(selectInfo);
      } else {
        this.selectInfoList = this.selectInfoList.filter((item: SelectInfo) => {
          return item?.uri !== key;
        })
      }
      Log.info(TAG, `handleSelectChanged:key = ${key}`);
      this.selectManager?.updateTotalSelectUris(key, value);
      this.pickerPhotoGridController.setSelectInfoList(this.selectInfoList);
      this.pickerPhotoGridController.grantUriPermissionAndSendData(key, value);
      if (!value || !this.isOnItemClickedSet) { // 未设置OnItemClicked回调的以及取消勾选的场景直接响应勾选或取消勾选动作
        this.onSelectChanged(position, key, value, callback);
      }
    } else {
      this.onSelectChanged(position, key, value, callback);
    }
  }

  private onPcSelectChanged(position: number, key: string, value: boolean, callback: Function): void {
    this.selectManager?.setImageHeadTailPosition(this.isSelectedMode, value, key, position,
      (isNowSelected: boolean) => {
        this.isRefreshSelectState = !this.isRefreshSelectState;
        this.broadCast.emit(Constants.UPDATE_SELECTED, [value, key]);
        callback?.(isNowSelected);
        this.selectManager?.updateMediaItemFullState();
      });
  }

  private onSelectChanged(position: number, key: string, value: boolean, callback: Function): void {
    Log.info(TAG, `isHorizontal ${this.isHorizontal}, position ${position}, uri ${key}, select ${value}`);
    let isMultiPick = this.selectParams.isMultiPick;
    if (this.param?.isRepeatSelectSupported) {
      let selectedUris = this.selectManager?.isPickerIndexSet ?
        this.selectManager?.getSelectedUrisWithPickerIndex() : this.selectManager?.getSelectUris();
      this.broadCast.emit(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, [selectedUris ?? []]);
    }
    if (!isMultiPick) {
      // update correct status from select manager
      value = !(this.selectManager?.isItemSelected(key) ?? false);
      this.selectManager?.deSelectAll();
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.onPcSelectChanged(position, key, value, callback);
      return;
    }
    if (this.selectManager?.toggle(key, value, position) ?? false) {
      Log.info(TAG, 'enter event process');
      this.broadCast.emit(Constants.UPDATE_SELECTED, [value, key]);
      callback?.(value);
      this.selectManager?.updateMediaItemFullState();
    }
  }

  private jumpBrowserCallback(showCancel: boolean, name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, isSelectMode = false, isFromGridItem?: boolean): void {
    if (!item) {
      Log.error(TAG, 'jumpBrowserCallback failed, item is null');
      return;
    }
    if (!item.uri) {
      Log.error(TAG, 'jumpBrowserCallback failed, item.uri is empty');
      return;
    }
    let options = {
      showCancel : showCancel,
      name : name,
      item : item,
      geometryTapIndex : geometryTapIndex,
      geometryTransitionString : geometryTransitionString
    } as JumpBrowserOptions<MediaItem>;
    this.jumpToBrowser(options, isSelectMode, false, isFromGridItem);
  }

  private previewJumpBrowserCallback(showCancel: boolean, name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, photoBrowserRange: number, isAcrossAlbum?: boolean): void {
    let isSelectMode: boolean;
    let isAllMode: boolean = false;

    isSelectMode = photoBrowserRange === ThirdSelectConstants.PHOTO_BROWSER_RANGE_SELECTED_ONLY;
    if (isAcrossAlbum) {
      isAllMode = photoBrowserRange === ThirdSelectConstants.PHOTO_BROWSER_RANGE_ALL;
    }
    let selectedUris: string[] | undefined = this.selectManager?.getSelectUris();
    if (selectedUris === undefined) {
      isAllMode = true;
    } else if (selectedUris.length > 0) {
      let index: number = 0;
      for (index; index < selectedUris.length; index++) {
        const uri = selectedUris[index];
        if (this.dataSource.getDataIndexByUri(uri) < 0) {
          break;
        }
      }
      if (index === selectedUris.length) {
        isAllMode = false;
      } else {
        isAllMode = true;
      }
    }
    Log.info(TAG, `isAcrossAlbum=${isAcrossAlbum}, isalllMode=${isAllMode},isSelectMode=${isSelectMode}`);
    let options = {
      showCancel : showCancel,
      name : name,
      item : item,
      geometryTapIndex : geometryTapIndex,
      geometryTransitionString : geometryTransitionString
    } as JumpBrowserOptions<MediaItem>;

    this.jumpToBrowser(options, isSelectMode, isAllMode);
  }

  private jumpToBrowser(options: JumpBrowserOptions<MediaItem>, isSelectMode: boolean, isAllMode?: boolean,
    isFromGridItem?: boolean) {
    Log.info(TAG, `jumpToBrowser isSelectMode ${isSelectMode}, isAllMode=${isAllMode}, isFromGridItem=${isFromGridItem},
      this.isALLSelectedUrisInWindow()=${this.isALLSelectedUrisInWindow()}`);
    this.browserDataSource.setAllMode(isAllMode ?? false);
    let showCancel: boolean = options.showCancel;
    let name: string = options.name;
    let item: MediaItem = options.item;
    let geometryTapIndex: number = options.geometryTapIndex;
    let geometryTransitionString: string = options.geometryTransitionString;
    let targetIndex: number = Constants.INVALID;
    // 1.isSelectMode=true：SELECTED_ONLY模式
    // 2.isAllMode=true：PHOTO_BROWSER_RANGE_ALL模式,且跨相册点击预览
    // 3.isSelectMode=false && isAllMode=false：宫格页面进大图/当前相册页面勾选后直接进大图
    LocalStorage.getShared()?.setOrCreate('geometryEnable', geometryTapIndex !== undefined);
    if (isSelectMode) {
      targetIndex = this.selectManager?.getSelectItemIndex(item) ?? Constants.INVALID;
    } else {
      //1.来自预览点击 && all && 有一个勾选的文件不在滑窗 --》 index=0
      if (!this.isALLSelectedUrisInWindow() && isAllMode && !isFromGridItem) {
        targetIndex = this.browserDataSource.getDataIndex(item);
      } else {
        targetIndex = this.dataSource.getDataIndex(item);
      }
    }
    if (targetIndex === Constants.NOT_FOUND && this.isJumpBrowserBySelected && !this.selectParams.isFromPickerView) {
      this.broadCast.emit(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER,
        [true, TAG, item, , , ThirdSelectConstants.PHOTO_BROWSER_RANGE_SELECTED_ONLY]);
      return;
    }
    targetIndex = targetIndex < 0 && this.dataSource.totalCount() > 0 ? 0 : targetIndex;
    Log.info(TAG, `jumpToBrowser index: ${targetIndex}, geometryTapIndex ${geometryTapIndex
    }, transition: ${name}, geometryTransitionString: ${geometryTransitionString}, isSelectMode: ${isSelectMode}`);
    LocalStorage.getShared()?.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    let storage = LocalStorage.getShared();
    if (this.param?.isFromPickerView) {
      try {
        let session: UIExtensionContentSession | undefined =
          storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.sendData({ 'dataType': 'onPhotoBrowserStateChanged', 'isEnter': true, 'duration': 400 });
      } catch (err) {
        let error = err as Error;
        Log.error(TAG, `onBackPressInner sendData fail, name: ${error.name}, msg: ${error.message}`);
      }
    }
    this.jumpToBrowserGeometryTransition(showCancel, targetIndex, name, item, isSelectMode, geometryTapIndex,
      geometryTransitionString, isAllMode);
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_CLICK_PREVIEW, undefined);
  }

  updateSearchNoResultPageVisibility(newState: number) {
    this.isSearchNoResultPageVisible = (newState == 0);
  }

  private updateSystemUiOnEditorExit(): void {
    this.updateSystemUi();
  }

  private onLoadingFinished(size: number, isNeedReload: boolean): void {
    this.onLoadFinishedCallback(size, (): void => {
      if (this.param) {
        this.updateTitle(this.param);
      }
    }, isNeedReload);
  }

  private onReloadFinishedCallback(): void {
    Log.info(TAG, 'ON_DATA_RELOADED');
    this.dataSource.onDataReloaded();
  }

  private onLoadFinishedCallback(size: number, updateTitle: Function, isNeedReload: boolean): void {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    this.broadCast.emit(BroadCastConstants.UPDATE_LAYOUT_OPTIONS, [size]);
    this.isEmpty = size === 0;
    this.totalCount = size;
    updateTitle?.();

    Log.info(TAG, `isEmpty: ${this.isEmpty}`);
    if (isNeedReload) {
      this.dataSource.onDataReloaded();
    }
    this.loadedSize = size;
    if (this.isReScrollAfterDataLoaded && size >= (this.param?.dataIndexForRecover ?? 0)) {
      this.appBroadCast.emit(BroadCastConstants.RE_SCROLL_AFTER_DATA_LOADED, [this.param?.dataIndexForRecover]);
    }
    this.modifyPhotoSelectStatus();
  }

  /**
   * 图库预选择
   */
  private modifyPhotoSelectStatus(): void {
    let preselectedList = this.param?.preselectedInfos ?? [];
    if (preselectedList.length === 0) {
      if (!this.param?.preData?.length) {
        return;
      }
      if (this.param?.preData.length > this.selectParams.maxSelectCount && !this.param.isRepeatSelectSupported) {
        this.param.preData = this.param?.preData.slice(0, this.selectParams.maxSelectCount);
      }
      this.selectManager?.initPreSelectPhotos(this.param?.preData, this.param?.isHighlightPickerView);
      let hashSet: HashSet<string> = new HashSet();
      for (let preUri of this.param?.preData) {
        hashSet.add(preUri)
      }
      this.pickerPhotoGridController.preData = hashSet;
      this.param.preData = []; // 防止多次调用，重置变量
    } else {
      // PreselectedInfos is set
      if (preselectedList.length > this.selectParams.maxSelectCount && !this.param?.isRepeatSelectSupported) {
        preselectedList = preselectedList.slice(0, this.selectParams.maxSelectCount);
      }
      const filteredUris: string[] = [];
      for (const item of preselectedList) {
        if (this.selectManager?.filterWithPickerIndex(item)) {
          filteredUris.push(item.uri);
        }
      }
      this.selectManager?.initPreSelectPhotos(filteredUris, this.param?.isHighlightPickerView);
      let hashSet: HashSet<string> = new HashSet();
      for (let preUri of filteredUris) {
        hashSet.add(preUri)
      }
      this.pickerPhotoGridController.preData = hashSet;
    }
  }

  private initSelectManager(): void {
    let manager: ThirdSelectManager | undefined =
      LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    if (manager?.getClassName() === 'ThirdSelectManager') {
      Log.debug(TAG, `use cached select manager, current select count ${manager.getSelectedCount()}`);
      this.selectManager = manager;
    } else {
      Log.debug(TAG, 'create new select manager');
      this.selectManager = new ThirdSelectManager();
      LocalStorage.getShared()?.setOrCreate(Constants.THIRD_SELECT_MANAGER, this.selectManager);
    }
    if (this.isFirstEnter) {
      Log.debug(TAG, 'clear select manager');
      this.selectManager?.deSelectAll();
      LocalStorage.getShared()?.setOrCreate(THIRD_SELECT_IS_ORIGIN, false);
    }
    this.selectManager?.setSelectParam(this.selectParams);
    this.selectManager?.setGetMediaItemFunc(
      (uris: string, itemNotifyCallback: Function): MediaItem | undefined => {
        return this.dataSource.getMediaItemByUriFromAll(uris, itemNotifyCallback);
      });
    this.selectManager.albumUri = this.param?.albumUri;
  }

  private onActive(): void {
    if (this.isItemIdChange) {
      this.isActive = false;
      this.dataSource?.initData();
    }

    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.dataSource?.onActive();
      if (this.dataSource.isDataChange) {
        this.dataSource.forceUpdate();
      }
      if (this.dataSource.hasNewChange) {
        this.albumChecker?.check();
      }
    }
  }

  private onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.dataSource?.onInActive();
    }
  }

  private async setPickResult(uriArray?: string[], mediaArray?: MediaItem[]): Promise<void> {
    let isOrigin: boolean = LocalStorage.getShared()?.get<boolean>(THIRD_SELECT_IS_ORIGIN) ?? false;
    let uriLength = 0;
    if (uriArray !== undefined && uriArray !== undefined) {
      uriLength = uriArray.length;
    }
    if (this.controller.hasDelegate) {
      if (mediaArray) {
        this.controller.onCompleted(mediaArray);
      } else {
        this.controller.onCancelled();
      }
    }
    let selectedMap: Map<string, MediaItem> = this.selectManager?.selectedMap ?? new Map();
    SelectUtil.getCountOfMedia(uriArray ?? [], selectedMap).then((result: number[]) => {
      interface Msg {
        isOriginalChecked: boolean;
        selectItemSize: number;
        selectImageSize: number;
        selectVideoSize: number;
      }

      let msg: Msg = {
        isOriginalChecked: isOrigin,
        selectItemSize: uriLength,
        selectImageSize: result[0],
        selectVideoSize: result[1],
      }
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_RESULT, msg);
    });
  }

  private checkWarning(): void {
    if (this.selectParams.bundleName === Constants.PHOTO_BUNDLE_NAME ||
    LocalStorage.getShared()?.has(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS) || this.isVerdeFoldable) {
      return;
    }
    let key: string = this.selectParams.isFromPickerView ?
    Constants.ACCESSING_PICKER_VIEW_APP_LIST : Constants.ACCESSING_PICKER_APP_LIST;
    PickerUtil.isAppExist(this.selectParams.bundleName, key)
      .then((result: AppPresenceStatus) => {
        if (result === AppPresenceStatus.NOT_EXIST && !this.isHorizontalPickerOrientation() &&
          !this.param?.singleLineConfig) {
          this.layoutOptions.irregularIndexes = [0];
          if (this.selectParams.isFromPickerView) {
            this.isShowPickerViewWarnDialog = true;
          } else {
            this.isShowPickerWarnDialog = true;
          }
          Log.info(TAG, 'show dialog');
        } else {
          this.layoutOptions.irregularIndexes = [];
          if (this.selectParams.isFromPickerView) {
            this.isShowPickerViewWarnDialog = false;
          } else {
            this.isShowPickerWarnDialog = false;
          }
          Log.info(TAG, 'close dialog');
        }
      });
  }

  private reportPhotoPickerLockedStatus(): void {
    const reportDelay: number = 200;
    const timerId = setTimeout(() => {
      const msg: Record<string, number | string | boolean> = {
        'lockedStatus': this.isPickerMaskLayerShow,
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_LOCKED_STATUS, msg);
      clearTimeout(timerId);
    }, reportDelay);
  }

  private isHorizontalPickerOrientation(): boolean {
    return this.selectParams.orientation == PickerOrientation.HORIZONTAL
  }

  private isShowDialogUnderLayout(): boolean {
    return !this.isHorizontalPickerOrientation() && !this.selectParams.singleLineConfig;
  }

  private reportPhotoPickerComponentBrowseMode(): void {
    if (!this.selectParams.isFromPickerView) {
      return;
    }
    const msg: Record<string, number | string | boolean> = {
      'bundleName': this.selectParams.bundleName,
      'isSlidingHorizontally': this.isHorizontalPickerOrientation(),
      'isSingleLineMode': this.selectParams.singleLineConfig !== undefined &&
        this.selectParams.singleLineConfig !== null
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
  }
}
