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

import lazy { Log } from '../utils/Log';
import lazy { Constants, SelectMediaType } from '../model/common/Constants';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { DateUtil } from '../utils/DateUtil';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { Action, ActionID } from './browserOperation/Action';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  WindowMode,
  updateAlbumPageGridPaddingLeftAndRight,
  DiggingHoleCameraArea
} from '../model/common/ScreenManager';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { MultimodalInputManager } from '../model/common/MultimodalInputManager';
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo, AlbumBrowsingInfo } from '../utils/ReportToBigDataUtil';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { UserConstraintUtil } from '../utils/UserConstraintUtil';
import lazy { CommonUtil } from '../utils/CommonUtil';
import lazy { SelectManager, SelectListener } from '../model/browser/SelectManager';
import lazy { SelectParams, SingleSelectionMode } from '../model/common/SelectParams';
import lazy { SimpleGridMediaItem } from '../model/browser/photo/SimpleGridMediaItem';
import lazy HashMap from '@ohos.util.HashMap';
import lazy Global from '../utils/GlobalContext';
import lazy hiTraceMeter from '@ohos.hiTraceMeter';
import lazy common from '@ohos.app.ability.common';
import lazy { EventHelper } from './ViewEventHelper';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { UiUtil, VibrateType } from '../utils/UiUtil';
import lazy { ShortCut } from '../model/ShortCut';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { AttributeUpdater, ImageModifier as DragImageModifier, SymbolGlyphModifier } from '@ohos.arkui.modifier';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { PhotoAsset } from '../access/PhotoAccessHelperAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy UDC from '@ohos.data.unifiedDataChannel';
import lazy ArrayList from '@ohos.util.ArrayList';
import lazy { JSON, util } from '@kit.ArkTS';
import lazy { CustomColors, display, LengthMetrics } from '@kit.ArkUI';
import lazy { ViewData } from '../model/browser/photo/ViewData';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { DragPreviewComponent } from './DragPreviewComponent';
import lazy { GridUIController } from '../utils/GridUIController';
import lazy shareUrlUtil from '../utils/ShareUrlUtil';
import lazy { GridScrollMsg } from '../model/common/GridScrollMsg';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { AssetHelper } from '../utils/AssetHelper';
import lazy { AccessibilityUtil } from '../utils/AccessibilityUtil';
import lazy { FocusUtil } from '../utils/FocusUtil';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { DownloadListener } from '../model/browser/DownloadListener';
import lazy { TimeLineModelManager } from './TimeLineModelManager';
import lazy { GridSize, ImageGridSizeUtil } from '../utils/ImageGridSizeUtil';
import lazy { PickerInstanceUtil } from '../utils/PickerInstanceUtil';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy { ReplaceUriManager } from '../model/ReplaceUriManager';
import lazy { AlbumSetDataSource } from '../model/browser/album/AlbumSetDataSource';
import lazy { SourceTypeAlbumDataSource } from '../model/browser/album/SourceTypeAlbumDataSource';
import lazy { AlbumSetDataSourceManager } from '../model/browser/album/AlbumSetDataSourceManager';
import lazy { AlbumSetDataInfo } from '../model/common/AlbumSetDataInfo';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { MediaOperationType } from '../model/common/MediaOperationType';
import lazy { NavigationConstants } from '../model/common/NavigationConstants';
import lazy { FrameSelectionUtil } from '../utils/FrameSelectionUtil';
import lazy { MORE_MENU_ITEM_HEIGHT } from '../view/actionbar/MoreAction';
import lazy { PhotoPropertiesUtil } from '../utils/PhotoPropertiesUtil';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { ItemDisplayRatio } from '../model/common/SelectParams';
import lazy { GridItemUtils } from '../utils/GridItemUtils';
import lazy {
  MenuController,
  RightClickMenuGroup,
  MenuPopUpParams,
  PopType
} from './menu/MenuController';
import lazy { MenuPopUp } from './menu/MenuView';

/* instrument ignore file */
const TAG: string = 'common_ImageGridItemComponent';
const DRAG_PLACEHOLDER_ICON_SIZE: number = 24;
const DRAG_IMAGE_SCALE_RATIO: number = 1.05;
const HOVER_SCALE_START: number = 1.0;
const HOVER_SCALE_END: number = 0.95;
const HOVER_SCALE_DEFAULT: number = 1.0;
const OPEN_BROWSER_MOVING_PHOTO: number = 3;
const GRID_APPEAR_TIMEOUT: number = 2;
const GRID_REUSE_TIMEOUT: number = 2;
const COMPONENT_EMPTY_EFFECT_OPACITY = 0.99;
const GRID_MIN_SCALE = 0.001;
const BORDER_PADDING: number = DeviceInfo.isPcOrTablet() ? 10 : 8;
const COVER: string = 'Cover';
const ACCESSIBILITY_FOCUS_DELAY: number = 350;
const DURATION_CLOUD_DOWNLOAD: number = 500;
const TIMEOUT_INIT_FOCUS: number = 300;
const LOW_FREQUENCY_ACTIONS = [Action.MOVE, Action.RENAME];

@Extend(SymbolGlyph)
function focusSetting(key: string, handleEvent: Function) {
  .focusable(true)
  .onKeyEvent((event: KeyEvent): void => {
    event && handleEvent((event));
  })
}

class GridItemModifier extends AttributeUpdater<GridItemAttribute> {
  applyNormalAttribute(instance: GridItemAttribute) {
  }
}

class ImageModifier extends AttributeUpdater<MediaCachedImageAttribute, MediaCachedImageInterface> {
  applyNormalAttribute(instance: MediaCachedImageAttribute) {
  }
}

class StackModifier extends AttributeUpdater<StackAttribute> {
  applyNormalAttribute(instance: StackAttribute) {
  }
}

class TextModifier extends AttributeUpdater<TextAttribute, TextInterface> {
  applyNormalAttribute(instance: TextAttribute) {
  }
}

class RowModifier extends AttributeUpdater<RowAttribute> {
  applyNormalAttribute(instance: RowAttribute) {
  }
}

interface Region {
  size: Size;
  x: number;
  y: number;
}

interface Msg {
  from: string;
  enterPosition: number;
  mediaType: number;
}

// General grid picture control
@Reusable
@Component
export struct ImageGridItemComponent {
  private replaceUriManager: ReplaceUriManager | undefined;
  @ObjectLink @Watch('onViewDataChanged') item: ViewData;
  @State gridUiController: GridUIController = new GridUIController();
  private rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private mediaItem: MediaItem | undefined;
  private gridScrollMsg: GridScrollMsg | undefined;
  simpleMediaItem?: SimpleGridMediaItem;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State isVdeFolded: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink('getFoldStatus') @Watch('onFoldChanged') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldChanged') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @Link @Watch('onModeChange') isSelectedMode: boolean;
  @State isSelected: boolean = false;
  @StorageLink('isPhotoGridFocused') isPhotoGridFocused: boolean = true;
  @State isHover: boolean = false;
  @Consume broadCast: BroadCast;
  @Consume @Watch('onShow') isShow: boolean;
  @Prop private rightClickMenuController: MenuController;
  @State quality: number = Constants.DEFAULT_ITEM_OPACITY;
  @Link @Watch('onSelectedCountChange') selectedCount: number;
  @LocalStorageLink('isImageFull') @Watch('onItemFullChange') isImageFull: boolean = false;
  @LocalStorageLink('isVideoFull') @Watch('onItemFullChange') isVideoFull: boolean = false;
  @LocalStorageLink('isBrowserShow') isBrowserShow: boolean = false;
  loaded = false;
  pageName = '';
  @State isLoadImageError: boolean = false;
  @State private recycleDays: number = 0;
  @Consume rightClickMenuList: RightClickMenuGroup[];
  @Consume longPressMenuList: Action[];
  onMenuClicked: Function = (): void => {
  };
  handleRename: Function = (): void => {
  };
  onMenuClickedForSingleItem: Function = (): void => {
  };
  onRightMenuClicked: Function = (): void => {
  };
  onMenuListAppear: Function = (): void => {
  };
  private geometryTransitionString: string = '';
  @State geometryTransitionBrowserId: string = '';
  @State isTap: boolean = false;
  updateLongPressMenuList: Function = (): void => {
  };
  isRecycle: boolean = false;
  @State private imageThumbnail: string = '';
  @State isEditImage: boolean = false;
  @Prop isShowFileSize: boolean = false;
  @State editImageUri: string = '';
  private transitionId: string = '';
  private mediaType: number = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
  private fileSize: number = 0;
  @State isVideoMediaType: boolean = false;
  @State videoDuration: number | undefined = 0;
  private isEnteringPhoto = false;
  private isThird = false;
  private isThirdMultiPick: boolean = false;
  private isFromPickerView: boolean = false;
  private isPhotoInner: boolean = true;
  @Prop isBlockTransition: boolean = false;
  private imageLoggerFunc: Function = (isShowPhotoBrowser: boolean) => this.imageLogger(isShowPhotoBrowser);
  @State checkBoxColor: string = '';
  @State checkboxTextColor: string = '';
  isPreviewForSingleSelectionSupported: boolean = true;
  singleSelectionMode: number = SingleSelectionMode.BROWSER_MODE;
  private isRepeatSelectSupported: boolean = false;
  @State repeatPickTimes: number = 0; //单张图可被多次选择的次数
  private pickerLongPressMenuList: Action[] = [Action.PICKER_SELECT];
  @Prop private isLoadLCD: boolean = false;
  private longPressClickedMenu: Action | undefined = undefined;
  // allSelected state variable for gridView
  @Prop @Watch('onTimelinePageAllSelectedClicked') private timelinePageAllSelectClicker: boolean = false;
  private albumUri: string = '';
  private dataSource: MediaDataSource | null = null;
  private isTapStatusChange: boolean = false;
  private verifyTapStatusFun: Function = (isTap: boolean): void => this.verifyTapStatus(isTap);
  private onGeometryIdChangeFun: Function = (geometryTransitionBrowserId: string):
    void => this.onGeometryIdChange(geometryTransitionBrowserId);
  private onSelectUpdateFun: Function = (): void => this.onSelectUpdate();
  private onSelectRefreshFunForGroup: Function =
    (toSelected: boolean): void => this.onSelectRefreshForGroup(toSelected);
  private updateSelectedFun: Function = (selected: boolean, uri: string):
    void => this.updateSelectedStatus(selected, uri);
  private updateDownloadStateFun: Function = (uri: string): void => this.updateDownloadState(uri);
  private updateRepeatPickFun: Function = (selectUris: string[]): void => this.updateRepeatPickTime(selectUris);
  private focusKey: string = '_GridItem';
  @Link isSupportPrint: boolean;
  private isContextMenuDisabled: boolean = false;
  @State thumbnailWidth: string | undefined = Constants.PERCENT_100;
  @State thumbnailHeight: string | undefined = Constants.PERCENT_100;
  private ratio: number = 0;
  thumbnailSize: Size | null = null;
  @Link @Watch('resizeGridThumbnail') gridItemWidth: number;
  // singleLineModeGridItemWidth与singleLineModeGridItemHeight 仅picker单行不规则布局用 控制点击热区
  @State singleLineModeGridItemWidth: number = 1;
  @State singleLineModeGridItemHeight: number = 1;
  isSearchMode: boolean = false;
  private isShowSerialNum: boolean = false;
  @State selectedItemIndex: number = Constants.INVALID;
  selectManager: SelectManager | undefined = undefined;
  private focusNodeKey: string = '';
  private dragNodeKey: string = '';
  @State private mPosition: number = 0;
  private groupCountBefore: number = 0;
  @State isEffective: boolean = true;
  @Prop isNeedTransition: boolean = true;
  private drawnThumbnailCount: number = -1;
  private readonly onClickHelper: EventHelper<KeyEvent | GestureEvent> = new EventHelper<KeyEvent | GestureEvent>();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private focusCtrlManager = FocusCtrlManager.getInstance();
  @Link gridRowCount: number;
  @Prop isShowCloudCard: boolean = false;
  @State previewThumbnailUri: string = '';
  private gridItemModifier: GridItemModifier = new GridItemModifier();
  private imageModifier: ImageModifier = new ImageModifier();
  private stackModifier: StackModifier = new StackModifier();
  private textModifier: TextModifier = new TextModifier();
  private fileSizeModifier: TextModifier = new TextModifier();
  private recycleTextModifier: TextModifier = new TextModifier();
  private rowModifier: RowModifier = new RowModifier();
  private scroller?: Scroller;
  private positionDeviation: number = 0;
  // 兼容照片tab顶部卡片场景
  private getTimelineDragEndIndex: Function = (): number => {
		return 0;
	}
  private dragUris: ArrayList<string> = new ArrayList<string>();
  @Link @Watch('onSelectStateChange') private isRefreshSelectState: boolean;
  @State private isGifImage: boolean = false;
  private isGestureRejectOnScrollBarTouch: boolean = false;
  // 判断接触屏幕的手指数是否等于1个
  private isOneFinger: boolean = true;
  @Prop private imageGridItemHeight: number;
  private isFromOtherAlbumPage = false;
  private previewNotifyPhotoFun: Function = (selectedUri: string, photoBrowserRange: number):
    void => this.previewNotifyPhoto(selectedUri, photoBrowserRange);
  @State isSecondClick: boolean = false;
  @State private isLocalImage: boolean = false;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') private networkAvailable: boolean = false;
  @State private isDownloading: boolean = false;
  private dragAssets: PhotoAsset[] = [];
  private isAssetPrepared: boolean = false;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  private imageItemWidth: Length | undefined = 0;
  private imageItemHeight: Length | undefined = 0;
  private borderRowModifier: RowModifier = new RowModifier();
  private isFromPortraitCoverSet: boolean = false;
  private isFromPortrait: boolean = false;
  private useGridTrace: boolean = GridItemUtils.useGridTrace();
  private useGridReport: boolean = GridItemUtils.useGridReport();
  private traceStartTime: number = 0;
  private themeColor: CustomColors | undefined = undefined;
  private lastDisableDragMouseDownTime: number = 0;
  private hasInitFocus: boolean = false;
  @State imageZIndex: number = 0;
  @State private downloadProgress: number = 0;
  @LocalStorageLink('hasShowToast') private hasShowToast: boolean = false
  private otherTimeDaysIconBottomPadding: number = 0;
  private downloadListener: DownloadListener = {
    onDownloadFinished: (uri: string): void => this.onDownloadFinishedFunc(uri),
    onDownloadProgressChanged: (uri: string, progress: number): void =>
    this.onDownloadProgressChangedFunc(uri, progress),
    onDownloadStoped: (uri: string): void => this.onDownloadStopedFunc(uri),
    onDownloadFailed: (uri: string, err: string): void => this.onDownloadFailedFunc(uri, err),
  } as DownloadListener;
  @StorageLink('currentLanguage') currentLanguage: string | undefined = undefined;
  //是否子窗picker模式
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  //是否三方接口创建的picker子窗
  @LocalStorageLink(Constants.IS_THIRD_PICKER_SUBWINDOW) isThirdPickerSubwindow: boolean = false;
  //框选状态
  private isBoxSelectionStatus: boolean = false;
  @Prop private pcRecycleBottomHeight: number = 0;
  private browserDownloadToGridFun: Function = (uri: string) => this.browserDownloadToGrid(uri);
  private touchType: TouchType | undefined = undefined;
  @Prop disableAnimate: boolean = false;
  private albums?: AlbumSetDataSource;
  private sourceTypeAlbumsDataSource: SourceTypeAlbumDataSource =
    new SourceTypeAlbumDataSource(getContext(this), Constants.SOURCE_ALBUM_MIN_COUNT, new BroadCast());
  @Prop @Watch('closeContextMenu') isPrivateHideState: boolean = false;
  @State private selectedCountLessThanOne: boolean = this.selectedCount <= 1;
  @State private selectedCountGreaterThanZero: boolean = this.selectedCount > 0;
  @State private imageBackgroundColor: ResourceColor = 'none';
  @State private isFromGalleryCleanupPage: boolean = false;
  private isSingleLineMode: boolean = false;
  private singleLineModeItemDisplayRatio: number = -1;
  private singleLineModeImageBorderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0;
  @Prop selectMediaType: number;
  @StorageLink(Constants.IS_FULL_RATIO) @Watch('onIsFullRatioChange') isFullRatio: boolean = false;
  @State private isShowFullRatio: boolean = false;
  private previewPaddingLeftAndRight: number = updateAlbumPageGridPaddingLeftAndRight();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  private isFromShortcutEntryCleanupPage: boolean = false;
  public persistentId: number = 0;
  public useNewPhotoGrid?: boolean = false;
  private isSearchResultPage: boolean = false;
  private readonly selectListener: SelectListener = {
    onGroupSelectionChanged: (dateKey: number, isSelected: boolean) => {
      let dateTaken: number = this.mediaItem?.getDateTaken() ?? Number.NaN;
      if (!Number.isFinite(dateTaken)) {
        dateTaken = this.simpleMediaItem?.getDateTaken() ?? Number.NaN;
      }
      if (DateUtil.isTheSameDayInGroup(dateTaken, dateKey.toString())) {
        this.onSelectRefreshForGroup(isSelected);
      }
    },
  } as SelectListener;

  private onSelectedCountChange(): void {
    if (this.lastDisableDragMouseDownTime) {
      this.lastDisableDragMouseDownTime = 0;
    }
    this.selectedCountLessThanOne = this.selectedCount <= 1;
    this.selectedCountGreaterThanZero = this.selectedCount > 0;
    if (this.isFromGalleryCleanupPage && this.selectedCount === 0) {
      this.isSelected = false;
    }
  }

  /**
   * 全局变量albums仅在pc端移动到操作时显示的menu菜单会用到，非PC场景，及picker场景用不到该变量，无需进行初始化占用内存及UI线程
   * @returns  true 需要初始化全局变脸albums   false 不需要
   */
  private checkNeedInitAlbums(): boolean {
    return DeviceInfo.isPc() && !(this.isThird || this.isFromPickerView);
  }

  private replaceUriFunc: Function = (oriUri: string, replaceUri: string): void => {
    if (this.mediaItem?.uri != oriUri || !this.isThird || !this.mediaItem) {
      return;
    }
    if (this.mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      let replaceUri = this.replaceUriManager?.getReplaceMediaItem(this.mediaItem)?.uri ?? '';
      this.editImageUri = this.replaceUriManager?.getVideoCoverUri(replaceUri) ?? '';
    } else {
      this.editImageUri = replaceUri;
    }
    this.isEditImage = true;
  };

  private onDownloadFinishedFunc(uri: string): void {
    Log.info(TAG, `onDownloadFinishedFunc uri: ${uri}`);
    let item = this.dataSource?.getMediaItemByUri(uri, (mediaItem: MediaItem): void => {
      mediaItem?.setPosition?.(3);
    });
    item?.setPosition?.(3);
    if (this.item.mediaItem?.uri === uri) {
      animateTo({
        duration: DURATION_CLOUD_DOWNLOAD,
        curve: Curve.Friction,
        onFinish: (): void => {
          this.isDownloading = false;
          this.isLocalImage = true;
        }
      }, (): void => {
        this.downloadProgress = 100;
      })
    }
  }

  private onDownloadProgressChangedFunc(uri: string, progress: number): void {
    if (this.item.mediaItem?.uri === uri) {
      this.downloadProgress = Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS +
        progress / Constants.PICKER_PHOTO_DOWNLOAD_COMPLETE_PROGRESS *
          (Constants.PICKER_PHOTO_DOWNLOAD_COMPLETE_PROGRESS - Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS);
    }
  }

  private onDownloadStopedFunc(uri: string): void {
    Log.info(TAG, `onDownloadStopedFunc uri: ${uri}`);
    this.isDownloading = false;
  }

  private onDownloadFailedFunc(uri: string, err: string): void {
    Log.error(TAG, `onDownloadFailedFunc uri: ${uri}, error message: ${err}`);
    if (err === 'NETWORK_UNAVAILABLE' && !this.hasShowToast) {
      UiUtil.showToast($r('app.string.no_network'));
      this.hasShowToast = true
    }
    this.isDownloading = false;
  }

  private imageLogger(isShowPhotoBrowser: boolean): void {
    if (!isShowPhotoBrowser) {
      Log.i(TAG, `imageLogger thumbnail:${ImageUtil.encryptThumbnailUri(this.mediaItem?.thumbnail)}` +
        `, index:${this.mPosition}, isEffective:${this.isEffective}, isLoadImageError:${this.isLoadImageError}`);
    }
  }

  verifyTapStatus(isTap: boolean): void {
    Log.debug(TAG, `[GeometryLogger] verifyTapStatus isTap=${isTap}, oldTapStatus=${this.isTap},` +
      ` uri=${this.mediaItem?.uri}, mPosition=${this.mPosition}`);
    if(isTap === false && this.isTap === true && this.imageBackgroundColor !== 'none') {
      this.imageBackgroundColor = 'none';
    }
    if (ScreenManager.getInstance().isFromPickerInPhotos() &&
      this.pageName !== NavigationConstants.NAVIGATION_THIRD_ALBUM_GRID) {
      return;
    }
    let oldTapStatus = this.isTap;
    this.isTap = isTap;
    this.isTapStatusChange = oldTapStatus !== isTap;
  }

  onGeometryIdChange(geometryTransitionBrowserId: string): void {
    if (ScreenManager.getInstance().isFromPickerInPhotos() &&
      this.pageName !== NavigationConstants.NAVIGATION_THIRD_ALBUM_GRID) {
      return;
    }
    let oldTapStatus = this.isTap;
    if (!geometryTransitionBrowserId) {
      this.isTap = false;
      this.geometryTransitionBrowserId = '';
      // 大图返回宫格后，裂图尝试重新加载
      if (this.isLoadImageError) {
        this.isLoadImageError = false;
      }
    } else {
      this.isTap = true;
      let uriStartIndex = geometryTransitionBrowserId.indexOf('/');
      let uriEndIndex = geometryTransitionBrowserId.length;
      let uri = geometryTransitionBrowserId.substring(uriStartIndex, uriEndIndex);
      if (uri != this.mediaItem?.uniqueId) {
        Log.error(TAG, `[GeometryLogger] onGeometryIdChange mismatch! isTap = ${this.isTap},` +
          ` isTapStatusChange = ${this.isTapStatusChange}, uri=${uri} uniqueId=${this.mediaItem?.uniqueId},` +
          ` position=${this.mPosition}, geometryTransitionString=${this.geometryTransitionString},` +
          ` geometryTransitionBrowserId=${geometryTransitionBrowserId}`);
        return;
      }
      this.geometryTransitionString = PickerInstanceUtil.getPickerId() + this.pageName + uri;
      this.updateGeometryTransition(this.geometryTransitionString);
      this.geometryTransitionBrowserId = this.geometryTransitionString;
    }
    this.isTapStatusChange = oldTapStatus !== this.isTap;
    Log.info(TAG, `[GeometryLogger] onGeometryIdChange isTap = ${this.isTap},` +
      ` isTapStatusChange = ${this.isTapStatusChange}, uniqueId=${this.mediaItem?.uniqueId},` +
      ` position=${this.mPosition}, geometryTransitionString=${this.geometryTransitionString},` +
      ` geometryTransitionBrowserId=${geometryTransitionBrowserId},` + ` uri=${this.mediaItem?.uri}`);
  }

  /**
   * 更新UI相关的属性，用controller驱动界面刷新
   * 适用场景：宫格静止，A端对图片做收藏、编辑等改变图片属性的操作，B端同步刷新宫格。
   * 备注：连续滑动、滚动场景走整个节点回收、复用逻辑，此处逻辑不适用。
   */
  private onViewDataChanged(): void {
    if (this.isEditImage) {
      this.isEditImage = this.replaceUriManager?.hasReplaceMediaItem(this.item.mediaItem) ?? false;
    }
    TraceControllerUtils.startTrace('GridItemOnViewDataChanged');
    const tempItem: MediaItem | undefined = this.item?.mediaItem;
    if (!tempItem) {
      Log.error(TAG, `this.mediaItem is ${Boolean(this.item?.mediaItem)} ${
      this.mediaItem?.equals?.name} cannot get mediaItem, return`);
      TraceControllerUtils.finishTrace('GridItemOnViewDataChanged');
      return;
    }
    if (!tempItem.equals?.(this.mediaItem)) {
      this.mediaItem = tempItem;
    }
    // 收藏后更新,仅VDE提前更新
    if (DeviceInfo.isPhoneVde() && this.gridUiController.isFavor !== tempItem.isFavor) {
      this.gridUiController.isFavor = tempItem.isFavor;
    }
    if (this.gridScrollMsg?.isScrolling) {
      TraceControllerUtils.finishTrace('GridItemOnViewDataChanged');
      return;
    }
    // 收藏后更新
    if (this.gridUiController.isFavor !== tempItem.isFavor) {
      this.gridUiController.isFavor = tempItem.isFavor;
    }
    // 动态照片且为非关闭模式时更新
    if (this.gridUiController.isTurnedOnMovingPhoto !== tempItem.isTurnedOnMovingPhoto) {
      this.gridUiController.isTurnedOnMovingPhoto = tempItem.isTurnedOnMovingPhoto;
    }
    // 编辑后更新
    if (this.gridUiController.dateModified !==
    tempItem.dateModified || this.gridUiController.thumbnailReady !== tempItem.thumbnailReady) {
      this.gridUiController.dateModified = tempItem.dateModified;
      this.gridUiController.thumbnailReady = tempItem.thumbnailReady;
      // dateModified时间改变，图片源需要刷新，用最新的时间戳重新触发一次CachedImage请求
      if (this.isLoadLCD && this.pageName === Constants.PHOTO_ARTGRIDPAGE && this.mediaItem) {
        this.imageThumbnail = ImageUtil.getLCDUri(this.mediaItem.uri,
          this.mediaItem.path, this.mediaItem.getDateModified());
      } else {
        this.imageThumbnail = tempItem.thumbnail ?? '';
      }
      let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
      if (userId > 0) {
        Log.info(TAG, 'onViewDataChanged imageThumbnail:');
        this.imageThumbnail += `&user=${userId}`;
      }
      this.updateWidthHeight(tempItem);
      this.isEffective = Boolean(this.imageThumbnail);
      this.updateFileSize();
      this.imageModifier?.updateConstructorParams(this.imageThumbnail);
    }
    TraceControllerUtils.finishTrace('GridItemOnViewDataChanged')
  }

  // 编辑时90度旋转,如果获取的最新的值和原来的值宽高大小上不同，则获取最新的缩略图和组件宽高，并进行调整。
  private updateWidthHeight(tempItem: MediaItem) {
    if (this.isSelectedMode) {
      return;
    }
    if (!DeviceInfo.isPc() || StringUtil.isEmpty(tempItem?.uri) || tempItem?.uri !== this.mediaItem?.uri) {
      return;
    }
    if (
      ((tempItem?.width - tempItem?.height) > 0 &&
        (Number(this.imageItemWidth ?? 0) - Number(this.imageItemHeight ?? 0) < 0))
        || ((tempItem.width - tempItem.height) < 0 &&
        (Number(this.imageItemWidth ?? 0) - Number(this.imageItemHeight ?? 0) > 0))) {
      Log.debug(TAG, 'updateWidthHeight');
      this.initGridThumbnail();
      let tmp = this.imageItemWidth;
      this.imageItemWidth = this.imageItemHeight;
      this.imageItemHeight = tmp;
    }
  }

  aboutToAppear(): void {
    if (this.useGridTrace) {
      this.traceStartTime = Date.now();
      TraceControllerUtils.startTrace(TAG + '--aboutToAppear');
    }
    this.mediaItem = this.item?.mediaItem;
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
    if (this.checkNeedInitAlbums()) {
      this.albums = AlbumSetDataSourceManager.getInstance().getDataSource();
    }
    this.isShowFullRatio = this.isFullRatio && !this.isThird;
    this.initData(false);
    let id: string = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') as string;
    // 判断大图动效是否结束
    let isBrowserShow: boolean = LocalStorage.getShared()?.get<boolean>('isBrowserShow') as boolean;
    // 手机搜索页面，宫格进大图收藏，会触发GridItem重建，isTap会被错误赋值，先屏蔽。
    if (this.pageName !== 'RealTimeSearchSlotItem' && isBrowserShow && !this.useNewPhotoGrid) {
      this.isTap = this.geometryTransitionString === id;
    }
    this.eventRegister();
    // 大图会照片宫格页白块或裂图维测
    this.appBroadCast.on(BroadCastConstants.OPEN_OR_CLOSE_PHOTO_BROWSER, this.imageLoggerFunc);
    // 页面重新加载时，如果有选中的，需要主动获焦，延时为了保证组件渲染完毕
    setTimeout((): void => {
      this.hasInitFocus = true;
      this.refreshPickerFocus();
    }, TIMEOUT_INIT_FOCUS);
    Log.info(TAG, `c=${this.isTap},` +
      ` isShowSerialNum=${this.isShowSerialNum}, isThird=${this.isThird},` +
      ` Position=${this.mPosition}, index = ${this.mediaItem?.index}, id = ${id}` +
      ` geometryTransitionString = ${this.geometryTransitionString}， isShowFullRatio = ${this.isShowFullRatio}`);
    if (this.useGridTrace) {
      this.appearTraceFunc();
    }
  }

  aboutToReuse(params: ESObject): void {
    if (this.useGridTrace) {
      this.traceStartTime = Date.now();
      TraceControllerUtils.startTrace(TAG + '--aboutToReuse');
    }
    if (!CommonUtil.isValidObject(params)) {
      Log.error(TAG, 'reuse failed');
    }
    this.geometryTransitionBrowserId = '';
    this.isTapStatusChange = false;
    this.mediaItem = this.item?.mediaItem;
    this.simpleMediaItem = params.simpleMediaItem;
    this.mPosition = params.mPosition;
    this.downloadProgress = 0;
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
    if (params.isSelected !== this.isSelected) {
      this.isSelected = params.isSelected;
      this.updatePickerLongPressMenu(this.mediaItem?.uri ?? '', this.isSelected);
    }
    this.geometryTransitionString = params.geometryTransitionString;
    this.updateGeometryTransition(this.geometryTransitionString);
    if (this.isLoadImageError) {
      this.isLoadImageError = false;
    }
    this.initData(true);
    if (this.isTap) {
      this.isTap = false;
    }
    Log.debug(TAG, `ImageGridItem aboutToReuse transitionId: ${
    this.transitionId} geometryTransitionString:` + this.geometryTransitionString
      + ' this.isTap: ' + this.isTap + ' this.imageThumbnail: ' + this.imageThumbnail);
    if (this.useGridTrace) {
      this.reuseTraceFunc();
    }
  }

  aboutToRecycle() {
    this.commonDestroyProcessor();
  }

  /**
   * Don't select the same status repeatedly
   */
  onSelectUpdate(): void {
    Log.info(TAG, `GridItem onSelectUpdate oldState: ${this.isSelected}`);
    let oldSelectState: boolean = this.isSelected;
    this.updateIndex();
    if (this.selectManager && this.mediaItem?.uri) {
      this.isSelected = this.selectManager.isItemSelected(this.mediaItem?.uri, this.mPosition);
      Log.info(TAG, `GridItem onSelectUpdate nowState: ${this.isSelected}`);
    } else {
      this.isSelected = !this.isSelected;
      Log.error(TAG, `undefined err. selectManager:${this.selectManager}, uri:${this.mediaItem?.uri}`);
    }
    if (!oldSelectState && this.isSelected && DeviceInfo.isPc()) {
      this.requestFocusImage();
    }
    this.updatePickerLongPressMenu(this.mediaItem?.uri ?? '', this.isSelected);
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
  }

  onSelectRefreshForGroup(toSelect: boolean): void {
    Log.info(TAG, `GridItem selectRefresh uri: ${this.mediaItem?.uri}, toSelect: ${toSelect}`);
    if (this.isSelected !== toSelect) {
      this.isSelected = toSelect;
    }
    this.updatePickerLongPressMenu(this.mediaItem?.uri ?? '', this.isSelected);
  }

  // 公共数据初始化
  initData(isReuse: boolean): void {
    this.imageThumbnail = this.mediaItem?.thumbnail ?? '';
    if (isReuse && this.isLoadLCD && this.pageName === Constants.PHOTO_ARTGRIDPAGE && this.mediaItem) {
      this.imageThumbnail = ImageUtil.getLCDUri(this.mediaItem.uri,
        this.mediaItem.path, this.mediaItem.getDateModified());
    }
    let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      Log.info(TAG, 'initData imageThumbnail');
      this.imageThumbnail += `&user=${userId}`;
    }
    this.isEffective = Boolean(this.imageThumbnail);
    this.getSelectManager()?.addListener(this.selectListener);
    if (!this.isEffective) {
      return;
    }
    if (isReuse) {
      // 需要确保attribute非空
      this.imageModifier?.updateConstructorParams(this.imageThumbnail);
    }
    if (this.replaceUriManager && this.mediaItem) {
      this.isEditImage = this.replaceUriManager?.isEditorImage(this.mediaItem);
      this.editImageUri =
        this.isEditImage ? this.replaceUriManager?.getReplaceMediaItem(this.mediaItem)?.uri ?? '' : 'false';
      if (this.isEditImage && this.mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        let replaceUri = this.replaceUriManager?.getReplaceMediaItem(this.mediaItem)?.uri ?? '';
        this.editImageUri = this.replaceUriManager?.getVideoCoverUri(replaceUri) ?? '';
      }
    } else {
      this.editImageUri = ''
    }
    this.gridUiController.init(this.mediaItem, this.simpleMediaItem);
    this.albumUri = this.isThird ? this.albumUri : AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI) as string;
    this.focusNodeKey = this.genFocusNodeKey();
    if (this.isFromPortraitCoverSet) {
      this.dragNodeKey = this.pageName + COVER + this.focusKey + this.imageThumbnail;
    } else {
      this.dragNodeKey = this.pageName + this.focusKey + this.imageThumbnail;
    }
    this.imageModifier?.attribute?.key(this.dragNodeKey);
    this.stackModifier?.attribute?.key(this.focusNodeKey);
    this.transitionId = this.isSelected ? `${this.mediaItem?.hashCode}_${this.albumUri}_${this.isSelected}` :
      `${this.mediaItem?.hashCode}_${this.albumUri}`;
    this.gridItemModifier?.attribute?.dragPreview(this.dragNodeKey);
    this.updateRecycleAttributes();
    this.broadCast.on(this.mediaItem?.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + this.pageName,
      this.verifyTapStatusFun);
    this.broadCast.on(this.mediaItem?.uniqueId + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT,
      this.onGeometryIdChangeFun);
    this.broadCast.on(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA, this.onSelectUpdateFun);
    this.broadCast.on(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA_GROUP,
      this.onSelectRefreshFunForGroup);
    this.broadCast.on(Constants.UPDATE_SELECTED + this.mediaItem?.uri, this.updateSelectedFun);
    this.broadCast.on(Constants.UPDATE_SELECTED, this.updateSelectedFun);
    this.broadCast.on(Constants.UPDATE_DOWNLOAD_STATE, this.updateDownloadStateFun);
    this.broadCast.on(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
    this.broadCast.on(BroadCastConstants.PREVIEW_NOTIFY_PHOTO, this.previewNotifyPhotoFun);
    this.broadCast.on(BroadCastConstants.BROWSER_DOWNLOAD_TO_GRID, this.browserDownloadToGridFun);
    this.broadCast.on(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    this.initGridThumbnail();
    this.updateFileSize();
    this.mediaType =
      this.mediaItem?.mediaType ?? this.simpleMediaItem?.mediaType ?? UserFileManagerAccess.MEDIA_TYPE_IMAGE;
    this.isVideoMediaType = this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    this.videoDuration = this.mediaItem?.duration ?? this.simpleMediaItem?.getDuration() ?? 0;
    this.isGifImage = this.mediaItem?.mimeType === Constants.MIME_TYPE_GIF;
    this.isLocalImage = this.item.mediaItem?.getPosition?.() === 2 ? false : true;
    if (this.isThird && !this.isLocalImage && this.item.mediaItem?.uri && !this.isPhotoInner) {

    }
    this.isDownloading = false;
    if (this.isVideoMediaType && this.textModifier.attribute && this.videoDuration !== undefined) {
      if (DateUtil.getFormattedDuration(this.videoDuration) === '00:00') {
        this.textModifier.updateConstructorParams('');
      } else {
        this.textModifier.updateConstructorParams(DateUtil.getFormattedDuration(this.videoDuration));
      }
    }
    this.updateSelectedItemIndex();
    this.selectManager?.updateMediaItemFullState();
    if (this.isRepeatSelectSupported) {
      let selectedUris = this.selectManager?.isPickerIndexSet ?
        this.selectManager?.getSelectedUrisWithPickerIndex() : this.selectManager?.getSelectUris();
      this.updateRepeatPickTime(selectedUris ?? []);
    }
    this.onItemFullChange();
  }

  private updateRecycleAttributes(): void {
    if (!this.isRecycle) {
      return;
    }
    this.calculateRecycleDays();
    if (!this.recycleTextModifier.attribute) {
      return;
    }
    let daysResource: Resource = DeviceInfo.isPc() ?
    $r('app.plural.days_left', this.recycleDays, this.recycleDays) :
    $r('app.plural.recycle_days', this.recycleDays, this.recycleDays);
    this.recycleTextModifier.updateConstructorParams(daysResource);
    let colorResource: Resource = this.recycleDays <= Constants.RECYCLE_DAYS_WARN ? $r('sys.color.warning') :
      (DeviceInfo.isPc() ? $r('sys.color.font_secondary') : $r('app.color.text_color_above_picture'));
    this.recycleTextModifier.attribute?.fontColor(colorResource);
  }

  private updateSelectedItemIndex(): void {
    const pickerIndex = this.selectManager?.selectParam?.pickerIndex ?? Constants.INVALID;
    if (this.isSelected && this.isShowSerialNum && this.mediaItem?.uri) {
      const preselectItemsLength = this.selectManager?.totalSelectedItemUriWithPickerIndex.length ?? 0;
      if (this.isFromPickerView) {
        if (pickerIndex !== Constants.INVALID && preselectItemsLength > 0) {
          this.selectedItemIndex =
            this.selectManager?.getShowIndexByUriAndPickerIndex(this.mediaItem?.uri, pickerIndex) ?? Constants.INVALID;
        } else {
          this.selectedItemIndex = this.selectManager?.getShowIndexByUri(this.mediaItem?.uri) ?? Constants.INVALID;
        }
      } else {
        this.selectedItemIndex = this.selectManager?.getSelectItemIndexByUri(this.mediaItem?.uri) ??
        Constants.INVALID;
      }
    }
    this.refreshPickerFocus();
    this.isEffective = Boolean(this.imageThumbnail);
  }

  aboutToDisappear(): void {
    this.commonDestroyProcessor();
    if (this.isThird && this.item?.mediaItem?.uri && !this.isPhotoInner && !this.isDownloading) {
      Log.info(TAG, 'ImageGridItem aboutToDisappear download' + this.item?.mediaItem?.uri)
    }
  }

  commonDestroyProcessor(): void {
    this.geometryTransitionString = '';
    this.dataSource?.releaseViewDataCache(this.mediaItem);
    this.appBroadCast.off(BroadCastConstants.OPEN_OR_CLOSE_PHOTO_BROWSER, this.imageLoggerFunc);
    this.getSelectManager()?.removeListener(this.selectListener);
    if (!this.isEffective) {
      return;
    }
    this.resetPressAnim();
    if (this.mediaItem != null) {
      this.broadCast.off(this.mediaItem?.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + this.pageName,
        this.verifyTapStatusFun);
      this.broadCast.off(this.mediaItem?.uniqueId + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT,
        this.onGeometryIdChangeFun);
      this.broadCast.off(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA, this.onSelectUpdateFun);
      this.broadCast.off(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA_GROUP,
        this.onSelectRefreshFunForGroup);
    }
    this.broadCast.off(Constants.UPDATE_SELECTED + this.mediaItem?.uri, this.updateSelectedFun);
    this.broadCast.off(Constants.UPDATE_SELECTED, this.updateSelectedFun);
    this.broadCast.off(Constants.UPDATE_DOWNLOAD_STATE, this.updateDownloadStateFun);
    this.broadCast.off(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
    this.broadCast.off(BroadCastConstants.PREVIEW_NOTIFY_PHOTO, this.previewNotifyPhotoFun);
    this.broadCast.off(BroadCastConstants.BROWSER_DOWNLOAD_TO_GRID, this.browserDownloadToGridFun);
    this.broadCast.off(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
  }

  updateSelectedStatus(selected: boolean, uri: string): void {
    if (this.mediaItem != null && this.mediaItem?.uri === uri) {
      this.isSelected = selected;
      this.updatePickerLongPressMenu(uri, this.isSelected);
    }
    this.updateSelectedItemIndex();
  }

  private updateDownloadState(uri: string): void {
    if (this.mediaItem?.uri === uri && !this.isLocalImage && this.isThird && !this.isPhotoInner) {
      Log.info(TAG, 'updateDownloadState uri = ' + uri + `, isDownloading = ${this.isDownloading}`);
      if (this.isDownloading) {
        this.stopDownloadImage();
      } else {
        this.startDownloadImage();
      }
    }
  }

  private updateRepeatPickTime(selectUris: string[]): void {
    if (this.mediaItem != null) {
      this.onItemFullChange();
      let updateRepeatPickTimes = 0;
      selectUris.forEach(item => {
        if (item === this.mediaItem?.uri) {
          updateRepeatPickTimes++;
        }
      })
      this.repeatPickTimes = updateRepeatPickTimes;
    }
  }

  onModeChange(): void {
    if (!this.isSelectedMode || DeviceInfo.isPc()) {
      this.isSelected = false;
    }
  }

  onAllSelect(newMode: boolean): boolean {
    Log.debug(TAG, `onAllSelect ${newMode}`);
    return newMode;
  }

  private onTimelinePageAllSelectedClicked(): void {
    if (!this.selectManager) {
      Log.error(TAG, 'onTimelinePageAllSelectedClicked selectManager undefined');
      return;
    }
    if (this.mediaItem?.uri) {
      this.updateIndex();
      this.isSelected = this.selectManager.isItemSelected(this.mediaItem.uri, this.mPosition);
    }
  }

  private getSelectManager(): SelectManager | undefined {
    if (!this.selectManager) {
      this.selectManager = AppStorage.get<SelectManager>(Constants.PHOTO_GRID_SELECT_MANAGER);
    }
    return this.selectManager;
  }

  async routePage(isError: boolean): Promise<void> {
    Log.info(TAG, `routePage ${isError}`);
    try {
      TraceControllerUtils.startTrace('enterPhotoBrowser');
      if (this.isThird) {
        this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
      } else {
        this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
      }
    } catch (err) {
      let error = err as Error;
      Log.error(TAG, `fail callback, name: ${error.name}, msg: ${error.message}`);
    }
  }

  updateIndex(): void {
    if (!this.mediaItem?.getDateTaken()) {
      // dataTaken为空时，不能根据mediaItem的uniqueId获取实际位置，通过mPosition来计算
      this.groupCountBefore = !this.dataSource ? 0 : this.dataSource?.timeGroupIndexes(this.mPosition) + 1;
      return;
    }
    this.groupCountBefore =
      !this.dataSource ? 0 : this.dataSource.getGroupCountBeforeItem(this.mediaItem);
    let index: number = this.dataSource?.getDataIndex(this.mediaItem) ?? Constants.NOT_FOUND;
    if (index === Constants.NOT_FOUND) {
      this.mPosition = this.mPosition + this.groupCountBefore;
      return;
    }
    this.mPosition = index + this.groupCountBefore;
  }

  async routeToPreviewPage(): Promise<void> {
    try {
      this.updateIndex();
      Log.info(TAG, `[GeometryLogger] routeToPreviewPage uri=${this.mediaItem?.uri}, index=${this.mPosition}`);
      if (this.isThird && !this.isLocalImage && this.item.mediaItem?.uri) {

      }
      if (this.isThird) {
        this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
          [true, this.pageName, this.mediaItem, this.mPosition, this.geometryTransitionString]);
      } else {
        this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
          [this.pageName, this.mediaItem, this.mPosition - this.groupCountBefore, this.geometryTransitionString]);
      }
    } catch (err) {
      let error = err as Error;
      Log.error(TAG, `[GeometryLogger] fail callback, name: ${error.name}, msg: ${error.message}`);
    }
  }

  private appearTraceFunc(): void {
    Log.info(TAG, `aboutToAppear useGridTrace: ${this.useGridTrace}, useGridReport: ${this.useGridReport}`);
    TraceControllerUtils.finishTrace(TAG + '--aboutToAppear');
    let traceCostTime = Date.now() - this.traceStartTime;
    if (traceCostTime > GRID_APPEAR_TIMEOUT || this.useGridReport) {
      const msg: Record<string, number | string | boolean> = {
        'appearTimeout': traceCostTime,
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.GRID_APPEAR_TIMEOUT, msg);
      Log.info(TAG, `grid appear timeout: ${traceCostTime}`);
    }
  }

  private reuseTraceFunc(): void {
    TraceControllerUtils.finishTrace(TAG + '--aboutToReuse');
    let traceCostTime = Date.now() - this.traceStartTime;
    if (traceCostTime > GRID_REUSE_TIMEOUT || this.useGridReport) {
      Log.info(TAG, `aboutToReuse useGridTrace: ${this.useGridTrace}, useGridReport: ${this.useGridReport}`);
      const msg: Record<string, number | string | boolean> = {
        'reuseTimeout': traceCostTime,
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.GRID_REUSE_TIMEOUT, msg);
      Log.info(TAG, `grid reuse timeout: ${traceCostTime}`);
    }
  }

  private dealAllCloudImage(): void {
    if (!this.selectManager) {
      Log.error(TAG, 'selectManager undefined');
      return;
    }
    let cloudImageItems: string[] = [];
    if (this.networkAvailable) {
      this.selectManager.clickedSet.forEach(itemUri => {
        if (this.dataSource?.getItemByUri(itemUri)?.getPosition() === photoAccessHelper.PositionType.CLOUD) {
          cloudImageItems.push(itemUri);

        }
      })
    } else {
      this.selectManager.clickedSet.forEach(itemUri => {
        if (this.dataSource?.getItemByUri(itemUri)?.getPosition() === photoAccessHelper.PositionType.CLOUD) {
          cloudImageItems.push(itemUri);
        }
      })
    }
    this.selectManager.needCheckCloudImage = false;
    if (cloudImageItems.length !== 0) {
      Log.info(TAG, `cloudImage count: ${cloudImageItems.length}`)
      this.selectManager.updateSelectCount(cloudImageItems);
      this.selectManager.updateCount();
      if (!this.networkAvailable) {
        Log.info(TAG, 'No network');
        UiUtil.showToast($r('app.string.no_network'));
      }
    }
  }

  private onSelectStateChange(): void {
    if (!this.selectManager) {
      Log.error(TAG, 'selectManager undefined');
      return;
    }
    // 三方拉起picker使用shift多选中有未下载云图时，不选中并开始下载，图库拉起picker场景不对云图做特殊处理
    if (this.selectManager.needCheckCloudImage && !this.isBoxSelectionStatus && this.isThirdPickerSubwindow) {
      Log.info(TAG, `onSelectStateChange checkCloudImage`)
      this.dealAllCloudImage();
    }
    if (this.mediaItem?.uri) {
      this.isSelected =
        this.selectManager.isItemSelected(this.mediaItem?.uri, DeviceInfo.isPc() ? this.mPosition : undefined);
    }
  }

  private requestFocusImage(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPcOrTablet() && this.dragNodeKey && this.isSelected && !this.isFromPickerView) {
      FocusUtil.requestFocus(this.getUIContext()?.getFocusController(), this.dragNodeKey);
    }
  }

  selectStateChange(isRefreshSelectState: boolean = true, isFocusSelect: boolean = false): void {
    Log.info(TAG, 'change selected.');
    this.isAssetPrepared = false;
    let newState = (this.isRepeatSelectSupported || isFocusSelect) ? true : !this.isSelected;
    Log.debug(TAG, `change status to ${newState}, item is ${this.mediaItem?.uri}}`);
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    if (this.mediaItem != null && this.mediaItem?.uri) {
      this.updateIndex();
      this.mediaItem.mPosition = this.mPosition;
      Log.info(TAG, `ImageGridItem selectStateChange mPosition ${this.mPosition}`);
      this.broadCast.emit(BroadCastConstants.SELECT,
        [this.mPosition, this.mediaItem?.uri, newState, (isSelected: boolean): void => {
          let itemUri: string = this.mediaItem?.uri ?? '';
          Log.info(TAG, `enter callback, select status ${this.mPosition} ${itemUri} ${newState} ${this.isSelected}`);
          if (this.isPickerUsedSubwindow) {
            //picker超过选择最大上限时点击的图片按实际刷新选择状态
            this.isSelected = this.selectManager?.isItemSelected(this.mediaItem?.uri);
          } else {
            this.isSelected = isSelected ?? newState;
          }
          this.updatePickerLongPressMenu(itemUri, this.isSelected);
          // 点击选中后可以enter or space打开大图
          if (!isFocusSelect && isRefreshSelectState) {
            this.requestFocusImage();
          }
        }, isRefreshSelectState]);
    }
  }

  private updatePickerLongPressMenu(uri: string, isSelect: boolean): void {
    if (!this.isThirdMultiPick || uri !== this.mediaItem?.uri) {
      return;
    }
    if (isSelect) {
      this.pickerLongPressMenuList = [Action.PICKER_UNSELECT];
    } else {
      this.pickerLongPressMenuList = [Action.PICKER_SELECT];
    }
  }

  private moveMenuBlock(albumInfo?: AlbumInfo): boolean {
    Log.info(TAG, `by selectMediaType moveMenuBlock: ${this.selectMediaType}`);
    let videoFlag: boolean = false;
    let screenshotsFlag: boolean = false;
    if (!this.isSelected) {
      // 长按图片弹出菜单，移动到菜单屏蔽；
      videoFlag = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
        this.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE);
      screenshotsFlag = (albumInfo?.lpath === '/Pictures/Screenshots' &&
        this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
    } else {
      // 选中图片右键弹出菜单
      videoFlag = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
        (this.selectMediaType === SelectMediaType.IMAGE || this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有图片或图片视频都有，视频录制相册不显示；
      screenshotsFlag = (albumInfo?.lpath === '/Pictures/Screenshots' &&
        (this.selectMediaType === SelectMediaType.VIDEO || this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有视频或视频图片都有，截图相册不显示；
    }
    return videoFlag || screenshotsFlag;
  }

  @Builder
  buildAlbumMenu(albumInfo?: AlbumInfo, index?: number) {
    if (albumInfo && !albumInfo?.isSystemAlbum && albumInfo?.uri !== this.albumUri && !this.moveMenuBlock(albumInfo)) {
      MenuItem({
        content: albumInfo.albumName,
      })
        .key(`AlbumMenu${index}`)
        .margin({ top: albumInfo.isUserCreatedAlbum && index == 0 ? $r('sys.float.padding_level2') : 0 })
        .height(Constants.MENU_ITEM_HEIGHT_PC)
        .onClick((): void => {
          Log.info(TAG, `buildAlbumMenu click: ${albumInfo.uri}`);
          this.appBroadCast.emit(BroadCastConstants.PC_MEDIA_OPERATION,
            [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri]);
        })
    } else {
      MenuItem()
        .visibility(Visibility.None)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
    }
  }

  @Builder
  buildMoveSubMenu() {
    Menu() {
      MenuItemGroup() {
        MenuItem({
          content: this.changeTextRes(Action.NEW_ALBUM),
        })
          .height(Constants.MENU_ITEM_HEIGHT_PC)
          .onClick((): void => {
            Log.info(TAG, `buildMoveSubMenu click: ${ActionID[Action.NEW_ALBUM.actionID]}`);
            this.appBroadCast.emit(BroadCastConstants.PC_MEDIA_OPERATION, [MediaOperationType.NEW]);
          })
        MenuItem()
          .margin({
            bottom: $r('sys.float.padding_level2'),
          })
      }
      .width('auto')
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })

      MenuItemGroup() {
        LazyForEach(this.albums as AlbumSetDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });

        LazyForEach(this.sourceTypeAlbumsDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });
      }
      .width('auto')
      .margin({ top: $r('sys.float.padding_level2') })
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
    }
  }

  private isPcMoveMenu(menu: Action): boolean {
    return menu.equals(Action.MOVE) && DeviceInfo.isPc();
  }

  private getAlbumHashCode(item: AlbumSetDataInfo, index?: number): string {
    if (!item?.data) {
      return TAG + String(index);
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  handleActionNeedPhotoItem(menu: Action) {
    this.getUIContext()?.getFocusController()?.clearFocus();
    this.openPhotoBrowser();
    setTimeout((): void => {
      this.appBroadCast.emit(BroadCastConstants.MENU_ACTION_FROM_PHOTO_ITEM, [menu]);
    }, Constants.DELAY_HALF_SECOND);
  }

  private onLongPressMenuClick(action: Action, responseType: ResponseType): void {
    this.longPressClickedMenu = action;
    if (!DeviceInfo.isPc() && action === Action.MULTISELECT && responseType === ResponseType.RightClick) {
      this.isSelectedMode = true;
      this.broadCast.emit(BroadCastConstants.SELECT, []);
      this.updateLongPressMenuList();
    }
  }

  private onMenuClick(menu: Action): void {
    Log.info(TAG, `on right click menu, action: ${ActionID[menu.actionID]}`);
    this.onRightMenuClicked?.(menu, this.mediaItem);
    if (Action.RENAME.equals(menu)) {
      this.handleRename?.(menu, this.mPosition);
    } else if (Action.MULTISELECT.equals(menu)) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.isSelectedMode = true;
      }
      this.onMenuClicked?.(menu);
      this.selectStateChange();
    } else {
      // 1.当鼠标对着被选中的项按右键时，菜单中的功能，针对所有被选中的项做处理
      // 2.当鼠标对着未被选中的项按右键时，菜单中的功能，仅针对当前项处理，其他被选中的项不做任何处理
      if (this.isSelectedMode && this.isSelected) {
        this.onMenuClicked?.(menu);
      } else if (DeviceInfo.isPc() && this.isSelected) {
        Log.info(TAG, `onMenuClicked, ----action: ${menu.componentKey} - ${this.onMenuClicked}`);
        this.onMenuClicked?.(menu);
      } else {
        this.onMenuClickedForSingleItem?.(menu, this.mediaItem);
      }
    }
  }

  private getMenuPopUpParams(): MenuPopUpParams {
    const params: MenuPopUpParams = {
      isSelected: this.isSelected,
      mediaItem: this.mediaItem,
      appBroadCast: this.appBroadCast,
      onMenuClick: (menu: Action): void => this.onMenuClick(menu),
      albumUri: this.albumUri,
      albums: this.albums,
      sourceTypeAlbumsDataSource: this.sourceTypeAlbumsDataSource,
      type: PopType.MOVE,
      selectMediaType: this.selectMediaType,
    }
    return params;
  }

  @Builder
  RightClickMenuBuilder() {
    if ((!DeviceInfo.isPc() && !this.isShowLongPressMenu()) || !(this.rightClickMenuController &&
      this.rightClickMenuController.getMenuGroupListWithoutEmpty().length > 0)) {
      this.EmptyBuilder();
    } else {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start,
      }) {
        MenuPopUp({
          controller: this.rightClickMenuController,
          menuPopUpParams: this.getMenuPopUpParams(),
        })
        .width($r('app.float.more_menu_width'))
        .key('ImageGridItemComponent_RightClickMenu')
      }
    }
  }

  @Builder
  EmptyBuilder() {
  }

  @Builder
  LongPressActionMenuBuilder(responseType: ResponseType) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      Menu() {
        ForEach(this.isThird ? this.pickerLongPressMenuList : this.longPressMenuList,
          (action: Action, index: number) => {
            MenuItem({ content: action.textRes }) {
            }
            .margin({
              left: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_MARGIN : Constants.MENU_ITEM_START_MARGIN,
              right: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_MARGIN : Constants.MENU_ITEM_START_MARGIN,
            })
            .padding({
              left: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_PADDING : Constants.MENU_ITEM_START_PADDING,
              right: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_PADDING : Constants.MENU_ITEM_START_PADDING,
            })
            .contentFont({ weight: 'medium' })
            .key('LongPress_' + this.mPosition + action.componentKey)
            .onClick((): void => {
              this.onLongPressMenuClick(action, responseType);
            })
          })
      }
      .menuItemDivider({
        strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: LengthMetrics.vp(DeviceInfo.isTv() ? Constants.TV_MENU_START_MARGIN : Constants.MENU_START_MARGIN),
        endMargin: LengthMetrics.vp(DeviceInfo.isTv() ? Constants.TV_MENU_START_MARGIN : Constants.MENU_START_MARGIN),
      })
      .padding({
        left: Constants.MENU_LEFT_PADDING,
        right: Constants.MENU_LEFT_PADDING,
        top: DeviceInfo.isTv() ? Constants.TV_MENU_TOP_PADDING : Constants.MENU_TOP_PADDING,
        bottom: DeviceInfo.isTv() ? Constants.TV_MENU_TOP_PADDING : Constants.MENU_TOP_PADDING,
      })
      .width(DeviceInfo.isTv() ? $r('app.float.tv_more_menu_width') : $r('app.float.more_menu_width'))
      .radius(DeviceInfo.isTv() ? 26 : $r('sys.float.corner_radius_level10'))
      .key('ImageGridItemComponent_Menu')
    }
    .draggable(false)
  }

  /**
   * 宫格、相册长按图片弹出菜单
   */
  @Builder
  LongPressMenuBuilder(responseType: ResponseType) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      Menu() {
        ForEach(this.isThird ? this.pickerLongPressMenuList : this.longPressMenuList,
          (action: Action, index: number) => {
            MenuItem({ content: action.textRes }) {
            }
            .margin({ left: Constants.MENU_ITEM_START_MARGIN, right: Constants.MENU_ITEM_START_MARGIN })
            .padding({ left: Constants.MENU_ITEM_START_PADDING, right: Constants.MENU_ITEM_START_PADDING })
            .contentFont({ weight: 'medium' })
            .key(`LongPress_${this.mPosition}` + action.componentKey)
            .onClick((): void => {
              this.onLongPressMenuClick(action, responseType);
            })
          })
      }
      .menuItemDivider({
        strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
        endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
      })
      .padding({
        left: Constants.MENU_LEFT_PADDING,
        right: Constants.MENU_LEFT_PADDING,
        top: Constants.MENU_TOP_PADDING,
        bottom: Constants.MENU_TOP_PADDING,
      })
      .width($r('app.float.more_menu_width'))
      .radius($r('sys.float.corner_radius_level10'))
      .key('ImageGridItemComponent_Menu')
    }
    .draggable(false)
  }

  private handleLongPressMenuClick(action: Action): void {
    Log.info(TAG, `LongPressMenuBuilder onClick`);
    if (this.gridScrollMsg) {
      this.gridScrollMsg.isDragging = false;
    }

    if (action?.componentKey === 'Favor') {
      ReportToBigDataUtil.report(BigDataConstants.FAVOR_MENU_RESPONSE, {'from': 'GALLERY_GRID_LONG_PRESS_PAGE',
        'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),});
    }
    if (action?.componentKey === 'Hide') {
      ReportToBigDataUtil.report(BigDataConstants.HIDE_MENU_RESPONSE, {'from': 'GALLERY_GRID_LONG_PRESS_PAGE',
        'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),});
    }

    ReportToBigDataUtil.report(BigDataConstants.LONG_PRESS_MENU_CLICK,
      { 'from': this.pageName, 'action': action.componentKey });
    if (action === Action.MULTISELECT) {
      this.onMenuClicked?.(action);
      this.selectStateChange();
    } else if (action === Action.PICKER_SELECT || action === Action.PICKER_UNSELECT) {
      if (this.isThirdMultiPick) {
        this.selectStateChange();
      }
    } else {
      this.onMenuClickedForSingleItem?.(action, this.mediaItem);
    }
  }

  private isShowLongPressMenu(): boolean {
    if (this.isContextMenuDisabled || this.isThird || this.gridScrollMsg?.isScrollerBarTouch) {
      return false;
    }
    // 选择模式下，无论当前图片是否已选中，都允许长按弹出菜单（包含小图预览）
    if (this.isSelectedMode) {
      return true;
    }
    return this.longPressMenuList.length > 0;
  }

  private genFocusNodeKey() {
    let uuid = util.generateRandomUUID(true);
    return this.pageName + this.focusKey + '_' + uuid;
  }

  // 获取图片或视频的无障碍播报内容
  private getImageItemGridAccessibilityText(): string {
    let text: string = '';
    if (this.isSelectedMode && !this.isSelected && !this.isThird) {
      text = this.rsc.toString($r('app.string.deselected'));
    }
    if (this.gridUiController.isFavor) {
      text = `${text} ${this.rsc.toString($r('app.string.favorited'))}`
    }
    let index = this.dataSource?.getDataIndex(this.mediaItem) ?? this.mPosition;

    if (this.mediaItem?.data) {
      let dateNumber = Number(AssetHelper.get(this.mediaItem.data,
        photoAccessHelper.PhotoKeys.DATE_TAKEN_MS.toString()));
      let photoDate: string = DateUtil.getLocalizedDate(dateNumber);
      let timeAndLocation: string = DateUtil.getLocalizedTime(dateNumber);
      if (this.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        text = `${text} ${this.rsc.toString($r('app.string.album_photos'))} ${index + 1}, ${photoDate} ${
        timeAndLocation}`;
      } else if (this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        let videoDuration: string = DateUtil.getFormattedDurationForScreenReader(this.videoDuration ?? 0);
        text = `${text} ${this.rsc.toString($r('app.string.album_video'))} ${index + 1}, ${
        this.rsc.toString($r('app.string.duration'))}${videoDuration}, ${photoDate} ${timeAndLocation}`;
      }
    }
    return text;
  }

  @Styles
  imageGridAttrs() {
    .draggable(this.isShowLongPressMenu() && !DeviceInfo.isPc())
    .accessibilityText(this.isOpenTouchGuide ? this.getImageItemGridAccessibilityText() : '')
  }

  build() {
    if (this.pageName === Constants.PHOTO_TRANSITION_TIMELINE || this.isFromPhotoGridView() ||
    this.isFromHiddenView() || this.pageName === Constants.PHOTO_TRANSITION_TIMELINE_GROUP) {
      GridItem() {
        // pc
        this.buildImageGrid();
      }
      .borderRadius(DeviceInfo.isTv() ? 16 : 0)
      .clip(DeviceInfo.isTv() ? true : false)
      .selectable(true)
      .selected(this.isSelected)
      .onSelect((isSelected) => {
        if (!FrameSelectionUtil.isInFrame && DeviceInfo.isPc()) {
          this.selectManager?.deSelectAll();
          this.isRefreshSelectState = !this.isRefreshSelectState;
          FrameSelectionUtil.isInFrame = true;
        }
        if (this.isSelected !== isSelected && DeviceInfo.isPc()) {
          this.selectStateChange(false);
        }
      })
      .stickGridItemAttrs()
      .bindLongPressAction()
      .stackTouchStyle() // 长按和点击事件都放到GridItem上，避免重复获焦
      .id(`photoGridView_gird_${this.mPosition.toString()}`)
      .accessibilityLevel('yes')
      .accessibilityText(this.isOpenTouchGuide ? this.getImageItemGridAccessibilityText() : '')
    } else if (this.isPickerUsedSubwindow) {
      GridItem() {
        this.buildImageGrid();
      }
      .selectable(true)
      .selected(this.isSelected)
      .onSelect((isSelected) => {
        this.isBoxSelectionStatus = isSelected;
        if (this.isSelected !== isSelected) {
          // 框选未下载云图时，不选中并开始下载
          if (!this.isLocalImage && !this.isPhotoInner) {
            if (!this.isDownloading) {
              this.startDownloadImage();
            } else {
              this.stopDownloadImage();
            }
            return;
          }
          this.selectStateChange(false);
        }
      })
      .stickGridItemAttrs()
      .stackTouchStyle() // 长按和点击事件都放到GridItem上，避免重复获焦
      .id(`photoGridView_gird_${this.mPosition.toString()}`)
      .accessibilityLevel('yes')
      .accessibilityText(this.isOpenTouchGuide ? this.getImageItemGridAccessibilityText() : '')
    } else {
      if (this.isShowLongPressMenu()) { // 不需要绑定menu的情况下不设置bind长按属性，否则会导致组件上报无障碍长按事件
        Column() {
          this.buildImageGrid();
        }
        .imageGridAttrs()
        .bindLongPressAction()
        .stackTouchStyle()
      } else {
        Column() {
          this.buildImageGrid();
        }
        .key(`ImageGridItem_Column_${this.mPosition.toString()}`)
        .imageGridAttrs()
        .stackTouchStyle()
      }
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
      Log.info(TAG, 'reportDrawnCompleted timelinePage');
    }
  }

  initGridThumbnail() {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && (this.mediaItem?.width === 0) && (this.mediaItem?.height === 0)) {
      let sizeStore =
        AppStorage.get<HashMap<string, Size>>(Constants.KEY_OF_GRID_HIGHT0_SIZE_RECODE)?.get(this.imageThumbnail);
      if (sizeStore) {
        this.updateGridThumbnailWithSize(sizeStore);
        return;
      }
    }
    if (this.pageName === Constants.PHOTO_ARTGRIDPAGE || this.pageName === 'ProtagonistPlanetPage') {
      return;
    }
    if (this.mediaItem?.uri) {
      let size: Size = ImageUtil.getThumbnailSize(this.mediaItem.width, this.mediaItem.height, true);
      this.updateGridThumbnailWithSize(size);
    }
  }

  updateGridThumbnail(width: number, height: number) {
    let size: Size = ImageUtil.getThumbnailSize(width, height, true);
    if (!AppStorage.get<HashMap<string, Size>>(Constants.KEY_OF_GRID_HIGHT0_SIZE_RECODE)) {
      AppStorage.setOrCreate<HashMap<string, Size>>(Constants.KEY_OF_GRID_HIGHT0_SIZE_RECODE, new HashMap());
    }
    AppStorage.get<HashMap<string, Size>>(Constants.KEY_OF_GRID_HIGHT0_SIZE_RECODE)?.set(this.imageThumbnail, size);
    this.updateGridThumbnailWithSize(size);
  }

  updateGridThumbnailWithSize(size: Size) {
    let thumbnailWidth = size.width;
    let thumbnailHeight = size.height;
    this.thumbnailSize = size;
    if (!this.isSingleLineMode) {
      if (this.isShowFullRatio) {
        this.ratio = Constants.INVALID;
      } else {
        this.ratio = thumbnailWidth / thumbnailHeight;
      }
      this.imageModifier?.attribute?.aspectRatio(this.ratio);
      this.rowModifier?.attribute?.aspectRatio(this.ratio);
    }
    this.resizeGridThumbnail();
  }

  /**
   * 宫格内等比例缩略图宽高计算
   */
  resizeGridThumbnail() {
    let gridSize: GridSize = {
      thumbnailWidth: this.thumbnailWidth,
      thumbnailHeight: this.thumbnailHeight,
      ratio: this.ratio,
    };
    gridSize = ImageGridSizeUtil.resizeGridThumbnail(this.thumbnailSize, this.gridItemWidth, gridSize);
    this.thumbnailWidth = gridSize.thumbnailWidth;
    this.thumbnailHeight = gridSize.thumbnailHeight;
  }

  imageThumbnailCheck(imageThumbnail: string): boolean {
    if (imageThumbnail?.length > 0) {
      return true;
    }
    Log.error(TAG, 'imageThumbnail length is 0.');
    return false;
  }

  isInvalidImageSize(): boolean {
    if (!DeviceInfo.isPc()) {
      return false;
    }
    return (this.thumbnailWidth === '0' && this.thumbnailHeight === '0');
  }

  handleBuildOnAppear(isReportTrace: boolean): void {
    Log.i(TAG, `image component load success, uri: ${ImageUtil.encryptThumbnailUri(this.mediaItem?.uri)}` +
      `, index=${this.mPosition}`);

    // 性能打点需要等待绘制完成的节点数量
    if (isReportTrace &&
      this.pageName === Constants.PHOTO_TRANSITION_TIMELINE && this.mPosition === this.drawnThumbnailCount) {
      this.drawnCompletedReport();
    }

    if (this.isBlockTransition && !this.isFromPortrait) {
      this.isBlockTransition = false;
    }
    if (this.isSingleLineMode) {
      const componentUtils = this.getUIContext().getComponentUtils();
      const modePosition = componentUtils.getRectangleById(this.dragNodeKey);
      this.singleLineModeGridItemWidth = px2vp(modePosition.size.width);
      this.singleLineModeGridItemHeight = px2vp(modePosition.size.height);
    }
  }

  handleBuildOnError(event: ImageError, isCache?: boolean): void {
    // 宫格CachedImage加载错误
    // 宫格Image加载错误
    interface ImagePos {
      imagePosition: photoAccessHelper.PositionType | undefined;
      error: string;
    }

    let imagePos: ImagePos = {
      imagePosition: this.mediaItem?.getPosition?.(),
      error: event.message,
    };
    ReportToBigDataUtil.errEventReport(
      isCache ? BigDataConstants.GRID_CACHEDIMAGE_LOAD_ERROR : BigDataConstants.GRID_IMAGE_LOAD_ERROR, imagePos);
    this.isLoadImageError = true;
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    Log.error(TAG,
      `thumbnail load error, index=${this.mPosition}, uri: ${this.mediaItem?.uri}, path: ${this.mediaItem?.path
      }, imageThumbnail: ${
      this.imageThumbnail}, imagePosition: ${this.mediaItem?.getPosition?.()}, error: ${
      event.message}, isCache: ${isCache}`);
  }

  private updateFileSize(): void {
    this.fileSize = this.mediaItem?.size ?? 0;
    if (Number.isNaN(this.fileSize)) {
      this.fileSize = this.simpleMediaItem?.getSize() ?? 0;
    }
    this.fileSizeModifier.updateConstructorParams(`${ImageUtil.getSortDisplaySize(this.fileSize)}`);
  }

  private getActualImage(): string {
    if (this.isEditImage && this.editImageUri !== '') {
      return this.editImageUri;
    }
    this.videoDuration = this.mediaItem?.duration ?? this.simpleMediaItem?.getDuration() ?? 0;
    if (this.isVideoMediaType && this.textModifier.attribute && this.videoDuration !== undefined) {
      if (DateUtil.getFormattedDuration(this.videoDuration) === '00:00') {
        this.textModifier.updateConstructorParams('');
      } else {
        this.textModifier.updateConstructorParams(DateUtil.getFormattedDuration(this.videoDuration));
      }
    }
    if (this.isLoadLCD && this.pageName === Constants.PHOTO_ARTGRIDPAGE && this.mediaItem) {
      let lcdUri = ImageUtil.getLCDUri(this.mediaItem.uri,
        this.mediaItem.path, this.mediaItem.getDateModified());
      let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
      if (userId > 0) {
        Log.info(TAG, 'getActualImage imageThumbnail:');
        lcdUri += `&user=${userId}`;
      }
      return lcdUri;
    }
    if (StringUtil.isEmpty(this.imageThumbnail) && !this.mediaItem?.uri) {
      Log.warn(TAG, 'imageThumbnail is empty');
    }
    return this.imageThumbnail;
  }

  private onMenuAboutToAppear(): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    this.lastDisableDragMouseDownTime = 0;
    this.focusCtrlManager.setFocusItemKey('');
    this.getUIContext()?.getFocusController()?.clearFocus();
    if (!(this.isSelected && (this.selectManager?.getSelectedCount() ?? 0) > 1)) {
      this.selectStateChange();
    }
  }

  private getBorderColor(): Resource | Color {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && (!this.isThird || this.isPickerUsedSubwindow) && this.isSelected) {
      return this.isPhotoGridFocused ? $r('sys.color.ohos_id_color_focused_outline') : Color.Gray;
    }
    return Color.Transparent;
  }

  private getBorderWidth(): Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return $r('app.float.image_grid_item_border_width_pc');
    }
    return $r('app.float.image_grid_item_default_border_width');
  }

  private setFocusImage(): void {
    if (!DeviceInfo.isPcOrTablet() || this.isFromPickerView || this.isThird) {
      return;
    }
    let isKeyEvent: boolean = LocalStorage.getShared()?.get<boolean>('isKeyEvent') ?? false;
    if (!this.isSelectedMode && this.isOneFinger && !isKeyEvent && DeviceInfo.isPcOrTablet()) {
      return;
    }
    this.focusCtrlManager.setFocusItemIndex(this.mPosition + 1);
    this.selectStateChange(true, true);
  }

  private getImageBackgroundColor():void {
    if (!DeviceInfo.isSupportOpenPNGBrowserBackGroundEnabled()) {
      return;
    }
    if (!this.mediaItem?.uri || this.mediaItem?.uri.split('.')[this.mediaItem?.uri.split('.').length - 1].toUpperCase() !== 'PNG') {
      return;
    }
    let currentMode: ConfigurationConstant.ColorMode | undefined = AppStorage.get('currentColorMode');
    Log.info(TAG, `getImageBackgroundColor:currentMode:${currentMode}, this.item.uri${this.mediaItem?.uri}`);
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.imageBackgroundColor = $r('sys.color.background_secondary');
    } else if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.imageBackgroundColor = $r('app.color.black');
    } else {
      this.imageBackgroundColor = 'none';
    }
  }

  private isIrregularGrid(): boolean {
    return this.pageName === Constants.PHOTO_ARTGRIDPAGE;
  }

  @Styles
  focusBorderStyle(){
    .border({
      color: this.getBorderColor(),
      width: this.getBorderWidth(),
    })
  }

  @Builder
  buildImage() {
    Image(this.getActualImage())
      .alt(this.imageThumbnail)
      .draggable(false)
      .backgroundColor(this.imageBackgroundColor)
      .width(DeviceInfo.isPc() && !this.isShowFullRatio ? this.thumbnailWidth : Constants.PERCENT_100)
      .height(DeviceInfo.isPc() && !this.isShowFullRatio ? this.thumbnailHeight : Constants.PERCENT_100)
      .aspectRatio(this.isShowFullRatio ? Constants.INVALID : this.ratio)
      .objectFit(ImageFit.Cover)
      .interpolation(ImageInterpolation.Medium)
      .key(this.dragNodeKey)
      .focusBox(this.isThird ? {
        strokeWidth: LengthMetrics.px(0),
      } : {})
      .focusable(true)
      .onKeyEvent((event: KeyEvent) => {
        this.handleKeyEvent(event);
      })
      .onError((event: ImageError): void => {
        this.handleBuildOnError(event, false);
        this.startHidePreview();
      })
      .onComplete((event?: completed): void => {
        if (this.isInvalidImageSize() && event?.loadingStatus === 0) {
          this.updateGridThumbnail(event?.width, event?.height);
        }
        Log.info(TAG, `thumbnail load onComplete! ${this.imageThumbnail}, index=${this
          .mPosition}, imagePosition: ${this.mediaItem?.getPosition?.()}, loadingStatus: ${event?.loadingStatus}`);
        this.startHidePreview();
      })
      .onAppear((): void => {
        this.handleBuildOnAppear(false);
      })
      .geometryTransition(this.geometryTransitionChange())
      .attributeModifier(this.imageModifier)
      .transition(this.disableAnimate ? undefined : TransitionEffect.asymmetric(
        AppStorage.get<string>('geometryTransitionBrowserId') as string !== '' ?
        TransitionEffect.scale({ x: GRID_MIN_SCALE, y: GRID_MIN_SCALE }) :
        TransitionEffect.IDENTITY,
        TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY)))
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
        this.onImageAreaChange(newValue);
      })
  }

  @Builder
  buildCachedImage() {
    MediaCachedImage(this.getActualImage())
      .sourceSize({
        width: Constants.GRID_IMAGE_SIZE,
        height: Constants.GRID_IMAGE_SIZE,
      })
      .draggable(false)
      .backgroundColor(this.imageBackgroundColor)
      .opacity(((this.gridScrollMsg?.isDragging) && !this.isSelectedMode)
        ? Constants.BUTTON_INVALID_OPACITY : this.quality)
      .width(DeviceInfo.isPc() && !this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailWidth :
        Constants.PERCENT_100)
      .height(DeviceInfo.isPc() && !this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailHeight :
        Constants.PERCENT_100)
      .aspectRatio((this.isThird && this.isSingleLineMode) || this.isShowFullRatio ? undefined : this.ratio)
      .borderRadius(this.isThird && this.isSingleLineMode ? this.singleLineModeImageBorderRadius : 0)
      .objectFit(this.singleLineModeItemDisplayRatio !== ItemDisplayRatio.ORIGINAL_SIZE_RATIO || this.isShowFullRatio ?
        ImageFit.Cover : ImageFit.Auto)
      .interpolation(ImageInterpolation.Medium)
      .key(this.dragNodeKey)
      .focusBox({
        strokeWidth: LengthMetrics.px(0),
      })
      .focusable(true)
      .onKeyEvent((event: KeyEvent) => {
        this.handleKeyEvent(event);
      })
      .onError((event: ImageError): void => {
        this.handleBuildOnError(event, true);
        this.startHidePreview();
      })
      .onComplete((event?: completed): void => {
        if (this.isInvalidImageSize() && (event?.loadingStatus === ImageUtil.LOADING_STATUS_LOAD_SUCC ||
          event?.loadingStatus === ImageUtil.LOADING_STATUS_DECODE_SUCC)) {
          this.updateGridThumbnail(event?.width, event?.height);
        }
        if (event?.loadingStatus === ImageUtil.LOADING_STATUS_DECODE_SUCC) {
          Log.i(TAG, `Draw the image! ${ImageUtil.encryptThumbnailUri(this.imageThumbnail)}` +
            `, index=${this.mPosition}, imagePosition: ${this.mediaItem?.getPosition?.()}, pageName: ${this.pageName}`);
          if (this.mPosition === 0) {
            this.broadCast?.emit(BroadCastConstants.PHOTO_PICKER_ONSHOW_CAMERA, [])
          }
        }
        this.startHidePreview();
      })
      .zIndex(this.imageZIndex)
      .onAppear((): void => {
        this.handleBuildOnAppear(true);
      })
      .geometryTransition(this.geometryTransitionChange())
      .attributeModifier(this.imageModifier)
      .transition(this.disableAnimate ? undefined : TransitionEffect.asymmetric(
        !StringUtil.isEmpty(AppStorage.get<string>('geometryTransitionBrowserId')) ?
        TransitionEffect.scale({ x: GRID_MIN_SCALE, y: GRID_MIN_SCALE }) :
        TransitionEffect.IDENTITY,
        TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY)))
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
        this.onImageAreaChange(newValue);
      })
  }

  @Builder
  buildEditorImage() {
    Row() {
      Image($r('app.media.gif_mask_layer'))
        .draggable(false)
        .height($r('app.float.image_grid_item_gif_mask_layer_height'))
        .width($r('app.float.image_grid_item_gif_mask_layer_width'))
        .position({ x: '0%', y: '100%' })
        .markAnchor({
          x: 0,
          y: $r('app.float.image_grid_item_gif_mask_layer_height'),
        })
        .onError((error: ImageError): void => {
          Log.error(TAG, `Gif mask layer image load error, error=${error}`);
        })

      Image($r('app.media.replace'))
        .draggable(false)
        .position({ x: '0%', y: '100%' })
        .height($r('app.float.image_grid_item_gif_icon_size'))
        .width($r('app.float.image_grid_item_gif_icon_size'))
        .markAnchor({
          x: ($r('app.float.image_grid_item_gif_icon_markAnchor_x')),
          y: ($r('app.float.image_grid_item_gif_icon_markAnchor_y')),
        })
        .shadow({
          radius: $r('app.float.image_grid_item_gif_icon_shadow_radius'),
          color: $r('app.color.ohos_id_color_outer_default_sm'),
          offsetX: $r('app.float.image_grid_item_gif_icon_shadow_offset_x'),
          offsetY: $r('app.float.image_grid_item_gif_icon_shadow_offset_y'),
          fill: true,
        })
    }
    .width(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailWidth : Constants.PERCENT_100)
    .height(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailHeight : Constants.PERCENT_100)
    .aspectRatio(DeviceInfo.isPc() && !this.isSingleLineMode ? this.ratio : Constants.INVALID)
    .hitTestBehavior(HitTestMode.Transparent)
  }

  @Builder
  private buildVideoDuration() {
    // 缩略图左下角视频时长
    if (!this.isEditImage && this.isVideoMediaType && this.videoDuration && this.videoDuration > 0 &&
      !this.isShowFileSize) {
      Text(DateUtil.getFormattedDuration(this.videoDuration))
        .draggable(false)
        .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_image_icon_text_line_height') :
          (DeviceInfo.isPc() ? $r('app.float.image_icon_text_line_height') :
          $r('app.float.multiple_pick_normal_font_size')))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor(DeviceInfo.isPc() ?
        $r('sys.color.ohos_id_color_text_primary_dark') :
          (DeviceInfo.isTv() ? $r('sys.color.font_primary') : $r('app.color.text_color_above_picture')))
        .lineHeight(DeviceInfo.isPc() ?
        $r('app.float.image_icon_text_line_height_pc') :
          (DeviceInfo.isTv() ? $r('app.float.tv_icon_text_line_height') :
          $r('app.float.image_icon_text_line_height')))
        .margin({
          top: DeviceInfo.isTv() ?
            $r('app.float.tv_grid_item_text_margin_top') : $r('app.float.grid_item_text_margin_top'),
          right: DeviceInfo.isTv() ?
            $r('app.float.tv_grid_item_text_margin_right') : $r('app.float.grid_item_text_margin_right'),
          bottom: DeviceInfo.isPc() ?
          $r('app.float.grid_item_text_margin_bottom_pc') :
            (DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_bottom')),
          left: DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_lr'),
        })
        .attributeModifier(this.textModifier)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines((1))
    }
  }

  @Builder
  private buildTimeDaysIcon() {
    // 缩略图右下角距离删除天数
    if (this.isRecycle && !this.isSelectedMode) {
      Blank()

      Text($r('app.plural.recycle_days', this.recycleDays, this.recycleDays))
        .draggable(false)
        .fontSize(DeviceInfo.isPc() ? $r('sys.float.Body_S') :
          (DeviceInfo.isTv() ? $r('app.float.tv_image_icon_text_line_height') : $r('sys.float.Caption_M')))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .maxFontScale(1.0)
        .fontColor(DeviceInfo.isTv() ? $r('sys.color.font_primary') : (this.recycleDays <= Constants.RECYCLE_DAYS_WARN ?
        $r('sys.color.warning') : $r('app.color.text_color_above_picture')))
        .lineHeight(DeviceInfo.isPc() ?
        $r('app.float.image_icon_text_line_height_pc') :
          (DeviceInfo.isTv() ? $r('app.float.tv_icon_text_line_height') : $r('app.float.image_icon_text_line_height')))
        .margin({
          top: DeviceInfo.isTv() ? $r('app.float.tv_grid_item_text_margin_top') : $r('app.float.grid_item_text_margin_top'),
          right: DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_right'),
          bottom: DeviceInfo.isPc() ?
          $r('app.float.grid_item_text_margin_bottom_pc') :
            (DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_bottom')),
          left: $r('app.float.grid_item_text_margin_lr'),
        })
        .attributeModifier(this.recycleTextModifier)
    }
  }

  @Builder
  buildPCTimeDaysIcon() {
    Row() {
      if (this.isVideoMediaType) {
        Column() {
          this.buildVideoDuration();
        }
        .backgroundColor($r('sys.color.mask_tertiary'))
        .border({
          radius: { topRight: $r('app.float.time_shadow_radius') }
        })
      }
    }
    .width((this.isThird && this.isSingleLineMode) || this.isShowFullRatio ? Constants.PERCENT_100 :
      this.thumbnailWidth)
    .height((this.isThird && this.isSingleLineMode) || this.isShowFullRatio ? Constants.PERCENT_100 :
      this.thumbnailHeight)
    .aspectRatio((this.isThird && this.isSingleLineMode) || this.isShowFullRatio ? undefined : this.ratio)
    .alignItems(VerticalAlign.Bottom)
    .attributeModifier(this.rowModifier)

    // 判断不是失效图片才在这里显示还剩多少天（因为失效图片可能进入不到此函数，所以失效图片需要在外层显示还剩多少天）
    if (!this.isLoadImageError) {
      // PC端最近删除，图片下显示还剩多少天
      this.buildFontUnderImage();
    }
  }

  @Builder
  buildOtherTimeDaysIcon() {
    Row() {
      this.buildVideoDuration();
      this.buildTimeDaysIcon();
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_50)
    .aspectRatio(Constants.INVALID)
    .alignItems(VerticalAlign.Bottom)
    .linearGradient({
      angle: 0,
      colors: this.isLoadImageErrorCheck(this.isLoadImageError) ? null :
        [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
    })
    .position({ x: '0%', y: '50%' })
    .padding({ bottom: this.otherTimeDaysIconBottomPadding })
  }

  @Builder
  buildTvPickerCheckbox() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Stack() {
        Checkbox()
          .key(`Selector_${this.mPosition}`)
          .accessibilityLevel('no')
          .select(this.isSelected)
          .hitTestBehavior(HitTestMode.None)
          .height($r('app.float.tv_picker_checkbox_height'))
          .width($r('app.float.tv_picker_checkbox_width'))
      }
      .height(53)
      .width(53)
      .onClick((): void => {
        this.selectStateChange();
      })
    }
    .width('100%')
    .height('100%')
  }

  // picker缩略图checkbox
  @Builder
  buildPickerCheckbox() {
    Stack() {
      Checkbox()
        .margin(0)
        .key(`Selector_${this.mPosition}`)
        .accessibilityLevel('no')
        .select(this.isSelected)
        .hitTestBehavior(HitTestMode.None)
        .backgroundColor(!this.isSelected ? $r('app.color.black') : $r('app.color.transparent'))
        .opacity(this.isSelected ? $r('app.float.no_opacity') : $r('sys.float.alpha_20'))
        .border({ radius: $r('app.float.checkbox_border_radius') })

      Column() {
      }
      .height($r('app.float.checkbox_base_size'))
      .width($r('app.float.checkbox_base_size'))
      .border({
        color: $r('app.color.white'),
        width: this.isSelected ?
        $r('app.float.checkbox_selected_border_width') : $r('app.float.checkbox_unselected_border_width'),
        radius: $r('app.float.checkbox_border_radius'),
      })
      .accessibilityDescription(this.isSelected ? this.rsc.toString($r('app.string.checkbox_selected'))
        : this.rsc.toString($r('app.string.checkbox_deselected')))
      .onClick((): void => {
        this.selectStateChange();
        if (this.isOpenTouchGuide) {
          AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected
            ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
        }
      })
      .responseRegion({
        x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
            Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
        y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
        width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemWidth,
        height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemHeight,
      })
    }
    .stylesPosition()
  }

  @Builder
  buildPreviewIconPcOrTablet() {
    SymbolGlyph($r('sys.symbol.full_screen_fill'))
      .zIndex(1)
      .draggable(false)
      .accessibilityLevel('yes')
      .key(`Previewer_${this.mPosition}`)
      .fontSize($r('app.float.icon_size'))
      .position({ x: '0%', y: '0%' })
      .markAnchor({
        x: $r('app.float.grid_item_preview_padding'),
        y: $r('app.float.grid_item_preview_padding'),
      })
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .fontColor(['#33000000', $r('sys.color.white')])
      .stateStyles({
        focused: {
          .padding(3)
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor($r('sys.color.ohos_id_color_activated'))
          .borderRadius($r('sys.float.corner_radius_level2'))
        },
        normal: {
          .borderWidth(0)
        }
      })
      .onClick((): void => {
        Log.info(TAG, `onClick loadThumbnailUri${this.imageThumbnail}`);
        this.routeToPreviewPage();
        Log.info(TAG, 'expand.');
      })
  }

  @Builder
  buildLoadingPanel() {
    Stack() {
      Image($r('app.media.shadow'))
        .width($r('app.float.loading_progress_photo_shadow'))
        .height($r('app.float.loading_progress_photo_shadow'))
      Progress({ value: 0, total: 100, type: ProgressType.Ring })
        .value(this.downloadProgress)
        .color(this.themeColor?.backgroundEmphasize ? this.themeColor?.backgroundEmphasize : $r('sys.color.white'))
        .width($r('app.float.checkbox_base_size'))
        .height($r('app.float.checkbox_base_size'))
        .backgroundColor($r('sys.color.icon_on_fourth'))
        .shadow({
          radius: 100,
          color: 'rgba(0,0,0,0.2)',
          fill: true,
          type: ShadowType.BLUR,
        })
        .style({ strokeWidth: 3, enableScanEffect: false, shadow: false })
        .foregroundColor(ColoringStrategy.INVERT)
    }
    .onClick((): void => {
      this.onClickLoadPanel();
    })
    .width($r('app.float.checkbox_base_size'))
    .height($r('app.float.checkbox_base_size'))
    .responseRegion({
      x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
      y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
      width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemWidth,
      height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemHeight,
    })
    .stylesPosition();
  }

  @Builder
  buildCloudDownIcon() {
    Column() {
      SymbolGlyph($r('sys.symbol.cloud_and_arrow_down'))
        .draggable(false)
        .fontSize('20vp')
        .fontColor([$r('sys.color.ohos_id_color_text_primary_contrary')])
        .shadow({
          radius: $r('app.float.image_grid_item_gif_icon_shadow_radius'),
          color: $r('app.color.ohos_id_color_outer_default_sm'),
          offsetX: $r('app.float.image_grid_item_gif_icon_shadow_offset_x'),
          offsetY: $r('app.float.image_grid_item_gif_icon_shadow_offset_y'),
          fill: true,
        })
    }
    .height($r('app.float.checkbox_base_size'))
    .width($r('app.float.checkbox_base_size'))
    .onClick((): void => {
      this.onClickCloudDownIcon();
    })
    .responseRegion({
      x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
      y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
      width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemWidth,
      height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemHeight,
    })
    .stylesPosition();
  }

  @Builder
  buildCheckBox() {
    if (this.isRepeatSelectSupported && this.repeatPickTimes > 1) {
      this.buildRepeatHint() //单张图片多选右上角增加提示框
    } else if (this.isShowSerialNum && this.isThird &&
      this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.buildPickerCheckbox();
    } else if (this.isSelected && this.isShowSerialNum && this.selectedItemIndex > Constants.INVALID &&
      !this.isRepeatSelectSupported) {
      Column() {
        Text(`${this.selectedItemIndex + 1}`)
          .fontColor((this.isFromPickerView && this.checkboxTextColor != '')
            ? this.checkboxTextColor : $r('app.color.white'))
          .fontSize($r('app.float.multiple_pick_normal_font_size'))
      }
      .height($r('app.float.checkbox_base_size'))
      .width($r('app.float.checkbox_base_size'))
      .backgroundColor((this.isFromPickerView && this.checkBoxColor != '')
        ? this.checkBoxColor
        : $r('sys.color.comp_background_emphasize'))
      .border({
        width: $r('app.float.checkbox_selected_border_width'),
        radius: $r('app.float.checkbox_border_radius'),
      })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .accessibilityDescription(this.isSelected ?
        $r('app.string.checkbox_selected') : $r('app.string.checkbox_deselected'))
      .onClick((): void => {
        this.selectStateChange();
        if (this.isOpenTouchGuide) {
          AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected
            ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
        }
      })
      .responseRegion({
        x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
            Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
        y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
        width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemWidth,
        height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemHeight,
      })
      .stylesPosition()
    } else if (!this.isShowSerialNum && this.isThird) {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.buildTvPickerCheckbox();
      } else {
        this.buildPickerCheckbox();
      }
    } else {
      this.buildCheckBoxDefault();
    }
  }

  @Builder
  private buildCheckBoxDefault(): void {
    Checkbox()
      .margin(0)
      .focusable(false)
      .key(`Selector_${this.mPosition}`)
      .accessibilityLevel('no')
      .select(this.isSelected)
      .hitTestBehavior(HitTestMode.None)
      .selectedColor($r('sys.color.comp_background_emphasize'))
      .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') : $r('app.color.black'))
      .opacity(this.isSelected ? $r('app.float.no_opacity') : $r('sys.float.alpha_20'))
      .border({
        radius: DeviceInfo.isTv() ? $r('app.float.tv_checkbox_border_radius') :
        $r('app.float.checkbox_border_radius'),
        color: DeviceInfo.isTv() ? $r('app.color.tv_gird_checkbox_border_color') : undefined,
      })
      .onClick((event: ClickEvent): void => this.selectStateChange())
      .width(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : undefined)
      .height(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : undefined)
      .stylesPosition()

    // todo checkbox需求后适配移除
    if (this.isThird) {
      Column() {
      }
      .height(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : $r('app.float.checkbox_base_size'))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : $r('app.float.checkbox_base_size'))
      .border({
        color: DeviceInfo.isTv() ? $r('app.color.tv_gird_checkbox_border_color') : $r('app.color.white'),
        width: this.isSelected ?
        $r('app.float.checkbox_selected_border_width') :
          (DeviceInfo.isTv() ? $r('app.float.tv_checkbox_unselected_border_width') :
          $r('app.float.checkbox_unselected_border_width')),
        radius: DeviceInfo.isTv() ? $r('app.float.tv_checkbox_border_radius') : $r('app.float.checkbox_border_radius'),
      })
      .accessibilityDescription(this.isSelected ? this.rsc.toString($r('app.string.checkbox_selected'))
        : this.rsc.toString($r('app.string.checkbox_deselected')))
      .onClick((): void => {
        this.selectStateChange();
        if (this.isOpenTouchGuide) {
          AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected
            ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
        }
      })
      .responseRegion({
        x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
            Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
        y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
          this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
        width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemWidth,
        height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
          this.singleLineModeGridItemHeight,
      })
      .stylesPosition()
    } else {
      Column() {
      }
      .height(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : $r('app.float.checkbox_base_size'))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_size') : $r('app.float.checkbox_base_size'))
      .border({
        color: DeviceInfo.isTv() ? $r('app.color.tv_gird_checkbox_border_color') : $r('app.color.white'),
        width: this.isSelected ?
        $r('app.float.checkbox_selected_border_width') :
          (DeviceInfo.isTv() ? $r('app.float.tv_checkbox_unselected_border_width') :
          $r('app.float.checkbox_unselected_border_width')),
        radius: DeviceInfo.isTv() ? $r('app.float.tv_checkbox_border_radius') : $r('app.float.checkbox_border_radius'),
      })
      .accessibilityDescription(this.isSelected ? this.rsc.toString($r('app.string.checkbox_selected'))
        : this.rsc.toString($r('app.string.checkbox_deselected')))
      .focusable(false)
      .onClick((): void => {
        this.selectStateChange();
        if (this.isOpenTouchGuide) {
          AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected
            ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
        }
      })
      .stylesResponseRegion()
      .stylesPosition()
    }
  }

  @Builder
  private buildRepeatHint(): void {
    Column() {
      Text(this.repeatPickTimes > 99 ? '...' : `+${this.repeatPickTimes}`)
        .fontColor($r('app.color.white'))
        .fontSize($r('app.float.multiple_pick_normal_font_size'))
        .height($r('app.float.account_enable_cloud_font_size'))
        .width($r('app.float.checkbox_base_size'))
        .lineHeight(DeviceInfo.isPc() ?
        $r('app.float.image_icon_text_line_height_pc') : $r('app.float.image_icon_text_line_height'))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
    }
    .height($r('app.float.checkbox_base_size'))
    .width($r('app.float.checkbox_base_size'))
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('sys.color.comp_background_emphasize'))
    .border({
      width: $r('app.float.checkbox_selected_border_width'),
      radius: $r('app.float.checkbox_border_radius'),
    })
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick((): void => {
      this.selectStateChange()
    })
    .responseRegion({
      x: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        (UiUtil.isMirrorMode() ? Constants.GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X :
          Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemWidth),
      y: !this.isSingleLineMode ? Constants.GRID_ITEM_CHECKBOX_ANCHOR -
        this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.singleLineModeGridItemHeight,
      width: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemWidth,
      height: !this.isSingleLineMode ? this.gridItemWidth / Constants.GRID_ITEM_WIDTH_HALF :
        this.singleLineModeGridItemHeight,
    })
    .stylesPosition()
  }

  @Styles
  private stylesPosition(): void {
    .position({
      x: UiUtil.isMirrorMode() ? '0%' : '100%',
      y: '100%',
    })
    .markAnchor({
      x: UiUtil.isMirrorMode() ? $r('app.float.grid_item_checkbox_markAnchor_ug') :
        (DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_markAnchor') :
        $r('app.float.grid_item_checkbox_markAnchor')),
      y: DeviceInfo.isTv() ? $r('app.float.tv_grid_item_checkbox_markAnchor') :
      $r('app.float.grid_item_checkbox_markAnchor'),
    })
  }

  @Styles
  private stylesResponseRegion(): void {
    .responseRegion(
      DeviceInfo.isTablet() && getScreen().getWinMode() === WindowMode.UNDEFINED ? undefined : {
        x: Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.imageGridItemHeight / Constants.GRID_ITEM_WIDTH_HALF,
        y: Constants.GRID_ITEM_CHECKBOX_ANCHOR - this.imageGridItemHeight / Constants.GRID_ITEM_WIDTH_HALF,
        width: this.imageGridItemHeight / Constants.GRID_ITEM_WIDTH_HALF,
        height: this.imageGridItemHeight / Constants.GRID_ITEM_WIDTH_HALF,
      })
  }

  @Builder
  buildFavorIcon() {
    //收藏图标
    Row() {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        Image($r('app.media.favor_mask_layer'))
          .draggable(false)
          .height($r('app.float.image_grid_item_gif_mask_layer_height'))
          .width($r('app.float.image_grid_item_gif_mask_layer_height'))
          .position({ x: '100%', y: '0%' })
          .markAnchor({
            x: $r('app.float.image_grid_item_gif_mask_layer_height'),
            y: 0,
          })
          .onError((error: ImageError): void => {
            Log.error(TAG, `Gif mask layer image load error, error=${error}`);
          })
      }
      SymbolGlyph(!DeviceInfo.isPc() ? $r('sys.symbol.heart_fill') : (
        this.gridUiController.isFavor ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart')
      ))
        .draggable(false)
        .fontSize($r('app.float.image_grid_item_view_icon_size'))
        .fontColor([$r('app.color.icon_default_color_contrary')])
        .position({ x: '100%', y: '0%' })
        .markAnchor({
          x: ($r('app.float.image_grid_item_view_icon_markAnchor_x')),
          y: ($r('app.float.image_grid_item_view_icon_markAnchor_y')),
        })
        .key(`GridItem_FavorIcon_${this.mPosition}`)
        .shadow({
          radius: $r('app.float.image_grid_item_view_icon_shadow_radius'),
          color: $r('app.color.ohos_id_color_outer_default_sm'),
          offsetX: $r('app.float.image_grid_item_view_icon_shadow_offset_x'),
          offsetY: $r('app.float.image_grid_item_view_icon_shadow_offset_y'),
          fill: true,
        })
        .accessibilityText($r('app.string.action_favorite'))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick((): void => {
          Log.info(TAG, 'onClick favor Icon')
          ReportToBigDataUtil.report(BigDataConstants.FAVOR_MENU_RESPONSE, {'from': 'SEARCH_PAGE'});
          let action: Action = this.mediaItem?.isFavor ? Action.NOT_FAVORITE : Action.FAVORITE;
          if (!this.isThird) {
            this.gridUiController.isFavor = !this.gridUiController.isFavor;
          }
          if (AccessibilityUtil.isOpenTouchGuideSync()) {
            this.sendAccessFocusToGridItem();
          }
          // 取消收藏时，焦点会丢失， 发送焦点到对应的宫格项
          AccessibilityUtil.sendFocusAccessibilityEvent(`ImageGridItem_Column_${this.mPosition.toString()}`);
          this.onMenuClickedForSingleItem?.(action, this.mediaItem);
          this.appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [this.mediaItem]);
          this.isSelected && this.mediaItem &&
          this.selectManager?.updateSelectedUnFavorItemCount(this.mediaItem?.data);
        })
        .accessibilityLevel(this.isThird ? 'no' : 'yes')
    }
    .focusable(false)
    .width(DeviceInfo.isPc() && !this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailWidth :
      Constants.PERCENT_100)
    .height(DeviceInfo.isPc() && !this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailHeight :
      Constants.PERCENT_100)
    .aspectRatio(DeviceInfo.isPc() && !this.isSingleLineMode && !this.isShowFullRatio ? this.ratio : Constants.INVALID)
  }

  private sendAccessFocusToGridItem() {
    // 取消收藏时焦点会丢失，发送焦点到对应的宫格项
    if (this.pageName === Constants.PHOTO_TRANSITION_TIMELINE || this.isFromPhotoGridView() ||
    this.isFromHiddenView() || this.pageName === Constants.PHOTO_TRANSITION_TIMELINE_GROUP || this.isPickerUsedSubwindow) {
      if (this.dataSource?.albumInfo?.isFavorAlbum) {
        // 我的收藏相册取消收藏后焦点发送到返回按钮
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_BACK);
      } else {
        AccessibilityUtil.sendFocusAccessibilityEvent(`photoGridView_gird_${this.mPosition.toString()}`);
      }
    } else {
      AccessibilityUtil.sendFocusAccessibilityEvent(`ImageGridItem_Column_${this.mPosition.toString()}`);
    }
  }

  @Builder
  buildIcon(isErrorImage: boolean) {
    /* instrument ignore next */
    if (DeviceInfo.isTv() && this.isSelectedMode) {
      this.selectGridOverlay();
    }
    if (this.isVideoMediaType || this.isRecycle) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.buildPCTimeDaysIcon();
      } else {
        this.buildOtherTimeDaysIcon();
      }
    }
    if (this.isEditImage && this.isThird && this.editImageUri !== '') {
      this.buildEditorImage();
    }
    if ((this.gridUiController.isFavor || (!isErrorImage && !this.isRecycle && this.isHover && !this.isThird)) &&
      !DeviceInfo.isTv()) {
      this.buildFavorIcon();
    }

    // 根据需要，加载蒙层
    if ((!DeviceInfo.isPc() || this.isThird) && !DeviceInfo.isTv() && !this.isPickerUsedSubwindow) {
      this.buildMaskLayer();
    }

    if (this.isThird) {
      this.buildPickerIcon();
    } else if (this.getSelectedModeValue() && !DeviceInfo.isPc()) {
      this.buildCheckBox();
    } else {
    }

    if (this.isShowFileSize && Number.isFinite(this.fileSize)) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.buildFileSizePc();
      } else {
        this.buildFileSizeNormal();
      }
    }
  }

  @Builder
  buildFileSizePc() {
    Row() {
      Column() {
        this.buildFileSize()
      }
      .backgroundColor($r('sys.color.mask_tertiary'))
      .border({
        radius: { topRight: $r('app.float.time_shadow_radius') }
      })
    }
    .width( !this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailWidth : Constants.PERCENT_100)
    .height(!this.isSingleLineMode && !this.isShowFullRatio ? this.thumbnailHeight : Constants.PERCENT_100)
    .aspectRatio(this.isShowFullRatio ? Constants.INVALID : this.ratio)
    .alignItems(VerticalAlign.Bottom)
    .attributeModifier(this.rowModifier)
  }

  @Builder
  buildFileSizeNormal() {
    Row() {
      Row() {
        this.buildFileSize()
      }
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_50)
      .aspectRatio(Constants.INVALID)
      .alignItems(VerticalAlign.Bottom)
      .linearGradient({
        angle: 0,
        colors: this.isLoadImageErrorCheck(this.isLoadImageError) ? null :
          [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
      })
      .position({ x: '0%', y: '50%' })
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .hitTestBehavior(HitTestMode.Transparent)
    .alignItems(VerticalAlign.Bottom)
  }

  @Builder
  buildPickerIcon() {
    if (this.isDownloading && !this.isPhotoInner) {
      this.buildLoadingPanel();
    } else if (!this.isLocalImage && !this.isDownloading && !this.isPhotoInner) {
      this.buildCloudDownIcon();
    } else if (this.isThirdMultiPick && this.isSelectedMode && !this.isPickerUsedSubwindow) {
      this.buildCheckBox();
    } else if (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.buildCheckBox();
    } else if (this.isThird && this.isSelectedMode && !this.isPickerUsedSubwindow) {
      // 进入页面时默认显示多选框
      this.buildCheckBox();
    } else {
    }
  }

  private getSelectedModeValue(): boolean {
    Log.info(TAG, `getSelectedModeValue ${this.isSelectedMode}, index=${this.mPosition}, isThird=${this.isThird}` +
      `, isRepeatSelectSupported=${this.isRepeatSelectSupported}, repeatPickTimes=${this.repeatPickTimes}` +
      `, isSelected=${this.isSelected}, isShowSerialNum=${this.isShowSerialNum}` +
      `, isShowSerialNum=${this.isShowSerialNum}, selectedItemIndex=${this.selectedItemIndex}`);
    return this.isSelectedMode;
  }

  /**
   * 当三方拉起 picker 时, 多选模式/单选混合模式 显示蒙层
   */
  @Builder
  buildMaskLayer() {
    if (this.isSelected &&
      (this.isSelectedMode || this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE)) {
      // 如果是最近删除要显示图片下的文字，则蒙层要再加高一行字的高度
      if (this.isShowFontUnderImage()) {
        Row() {
          Column()
            .width('100%')
            .height(`${this.pcRecycleBottomHeight}vp`)
            .margin({ bottom: `${-this.pcRecycleBottomHeight}vp` })
            .backgroundColor($r('app.color.item_selection_bg_color'))
        }
        .height('100%')
        .width('100%')
        .backgroundColor($r('app.color.item_selection_bg_color'))
        .alignItems(VerticalAlign.Bottom)
      } else {
        // 其他按原来正常高度显示蒙层
        Column()
          .height('100%')
          .width('100%')
          .backgroundColor($r('app.color.item_selection_bg_color'))
      }
    }
  }

  @Builder
  selectGridOverlay() {
    Stack()
      .position({ y: Constants.TV_GRID_ITEM_OVERLAY_WIDTH - Constants.TV_GRID_ITEM_OVERLAY_HEIGHT, })
      .width(Constants.TV_GRID_ITEM_OVERLAY_WIDTH)
      .height(Constants.TV_GRID_ITEM_OVERLAY_HEIGHT)
      .linearGradient({
        direction: GradientDirection.Top,
        colors: [[$r('app.color.color_secondary'), 0], [$r('app.color.transparent'), 1]],
      })
      .enabled(false)
  }

  private gestureJudgeProcessor(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (event.sourceTool != SourceTool.MOUSE && this.gridScrollMsg?.isContextMenuDisabled) {
      this.gridScrollMsg.isContextMenuDisabledResetAble = false;
      return GestureJudgeResult.REJECT;
    }
    if (!gestureInfo) {
      Log.error(TAG, 'gesture info undefined');
      return GestureJudgeResult.CONTINUE;
    }
    if (this.isGestureRejectOnScrollBarTouch || !this.isOneFinger) {
      Log.warn(TAG, 'reject all gestures of gridItem,' +
        ` isGestureRejectOnScrollBarTouch:${this.isGestureRejectOnScrollBarTouch}, isOneFinger:${this.isOneFinger}`);
      return GestureJudgeResult.REJECT;
    }
    return GestureJudgeResult.CONTINUE;
  }

  @Styles
  bindLongPressAction() {
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.gestureJudgeProcessor(gestureInfo, event);
    })
    .bindContextMenu(
      !DeviceInfo.isPc() && this.isShowLongPressMenu() ?
        this.LongPressActionMenuBuilder(ResponseType.LongPress) : this.RightClickMenuBuilder,
      ResponseType.LongPress,
      this.isFromGalleryCleanupPage && !this.isShowLongPressMenu() ? undefined : this.longPressContextMenuOptions()
    );
  }

  /**
   * PC长按菜单过滤掉壁纸设置
   */
  private handleLongPressMenu(): void {
    let isTrashAlbum: boolean = this.albumUri ===
    UserFileManagerAccess.getInstance().getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE);
    if (this.isFromHiddenView() || isTrashAlbum || this.isSelected) {
      return;
    }
    // 无效格式文件需删除壁纸菜单，有效格式文件需检查是否缺失壁纸菜单
    const isValidWallpaperFormat = PhotoPropertiesUtil.isValidFormatToSetWallPaper(this.mediaItem?.uri);
    if (!isValidWallpaperFormat) {
      // 定义过滤后的右键菜单组列表
      const filteredRightClickMenuList = this.rightClickMenuList.filter((menuGroup) => {
        // 过滤当前组中的菜单项，移除 SET_WALLPAPER 动作
        const filteredMenuList = menuGroup.menuList.filter((action) => {
          const isSetWallpaperAction = action.actionID === Action.SET_WALLPAPER.actionID;
          const shouldKeepAction = !(isSetWallpaperAction && !isValidWallpaperFormat);
          if (!shouldKeepAction) {
            Log.info(TAG, `Filtered out uri: ${this.mediaItem?.uri}`);
          }
          return shouldKeepAction;
        });

        // 更新当前组的菜单项列表
        menuGroup.menuList = filteredMenuList;

        // 检查过滤后的菜单项列表是否为空
        const isMenuListEmpty = filteredMenuList.length === 0;

        // 如果菜单项列表为空，则该组将被过滤掉
        Log.info(TAG, `Filtered isMenuListEmpty: ${isMenuListEmpty}.`);

        // 返回 true 保留该组，false 删除该组
        return !isMenuListEmpty;
      });

      // 更新 rightClickMenuList 为过滤后的列表
      this.rightClickMenuList = filteredRightClickMenuList;
    } else {
      this.handleLongPressMenuIfMissingWallPaperMenu();
    }

    // 检查是否需要插入新的 RightClickMenuGroup
    Log.info(TAG, `Final rightClickMenuList length: ${this.rightClickMenuList.length}`);
  }

  private hasSetWallpaper(): boolean {
    return this.rightClickMenuList.some(group => group.menuList.some(action => action.actionID ===
    Action.SET_WALLPAPER.actionID)
    );
  }

  /**
   * 当前规格，菜单项一共三个group，壁纸放在group 2中
   * group 1:高频high frequency
   * group 2:应用特性Application Features
   * group 3:低频low frequency
   */
  private handleLongPressMenuIfMissingWallPaperMenu(): void {
    // 检查所有组是否都不包含 SET_WALLPAPER 动作
    if (!this.hasSetWallpaper() && !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      const groupCount = this.rightClickMenuList.length;
      switch (groupCount) {
        case 3:
          // 在第二个组中添加 SET_WALLPAPER
          if (this.rightClickMenuList[1]) {
            this.rightClickMenuList[1].menuList.push(Action.SET_WALLPAPER);
            console.log(TAG, 'Added SET_WALLPAPER to the second group in a 3-group setup.');
          }
          break;
        case 2:
          // 检查第二个组是否包含低频菜单
          const secondGroup = this.rightClickMenuList[1];
          const hasSpecialAction = secondGroup.menuList.some(action =>
          LOW_FREQUENCY_ACTIONS.some(specialAction => action.actionID === specialAction.actionID)
          );

          if (hasSpecialAction) {
            // 插入壁纸菜单到低频菜单之前
            const newGroup = new RightClickMenuGroup();
            newGroup.menuList.push(Action.SET_WALLPAPER)
            this.rightClickMenuList.splice(1, 0, newGroup);
            Log.info(TAG, 'Inserted new group with SET_WALLPAPER after the first group in a 2-group setup.');
          } else {
            // 添加到第二个组
            secondGroup.menuList.push(Action.SET_WALLPAPER);
            Log.info(TAG, 'Added SET_WALLPAPER to the second group in a 2-group setup.');
          }
          break;
        default:
          if (groupCount <= 1) {
            const newGroup = new RightClickMenuGroup();
            newGroup.menuList.push(Action.SET_WALLPAPER)
            if (groupCount === 0) {
              this.rightClickMenuList.push(newGroup);
              Log.info(TAG, 'Added new group with SET_WALLPAPER as the first group.');
            } else {
              this.rightClickMenuList.splice(1, 0, newGroup);
              Log.info(TAG, 'Inserted new group with SET_WALLPAPER after the first group in a <=1-group setup.');
            }
          }
          break;
      }
    }
  }

  private longPressContextMenuOptionsPC(): ContextMenuOptions {
    return {
      modalMode: ModalMode.TARGET_WINDOW,
      aboutToAppear: (): void => {
        Log.info(TAG, `LongPress MenuList aboutToAppear, uri=${this.mediaItem?.uri}`);
        this.onMenuListAppear(this.mediaItem);
        // 长按菜单显示时，隐藏底层原图和视频左下角时长，避免原图的四个角或视频左下角时长显示在预览图外
        this.handleLongPressMenu();

        UiUtil.touchVibrate(VibrateType.IMAGE);
        if (this.mediaItem) {
          this.previewThumbnailUri =
            ImageUtil.getThumbnailUri(this.mediaItem?.uri, this.mediaItem?.path,
              this.mediaItem?.getDateModified?.(),
              false, this.mediaItem?.getThumbnailReady?.());
        }
      },
      aboutToDisappear: (): void => {
        Log.info(TAG, `LongPress MenuList aboutToDisappear, uri=${this.mediaItem?.uri}`);
      },
      onAppear: (): void => {
        AppStorage.setOrCreate<string>(Constants.SHARE_ANCHOR_POINT_RECORD, this.focusNodeKey);
        Log.info(TAG, `LongPress MenuList Show, uri=${this.mediaItem?.uri}`);
        const msg: Record<string, number | string | boolean> = { 'from': this.pageName };
        ReportToBigDataUtil.report(BigDataConstants.LONG_PRESS, msg);
      },
      onDisappear: (): void => {
        Log.info(TAG, `LongPress MenuList Hide, uri=${this.mediaItem?.uri}`);
        // menu销毁时才处理事件，防止弹窗和menu动效重叠
        if (!this.longPressClickedMenu) {
          Log.error(TAG, 'get longPressClickedMenu failed');
          return;
        }
        this.handleLongPressMenuClick(this.longPressClickedMenu);
        this.longPressClickedMenu = undefined;
      },
      backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      placement: this.isVdeFolded ? Placement.BottomLeft : undefined,
    }
  }

  private longPressContextMenuOptions(): ContextMenuOptions {
    if (this.isShowLongPressMenu() || DeviceInfo.isPc()) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        return this.longPressContextMenuOptionsPC();
      }
      return {
        aboutToAppear: (): void => {
          Log.info(TAG, `LongPress MenuList aboutToAppear, uri=${this.mediaItem?.uri}`);
          UiUtil.touchVibrate(VibrateType.IMAGE);
          if (this.mediaItem) {
            this.previewThumbnailUri =
              ImageUtil.getThumbnailUri(this.mediaItem?.uri, this.mediaItem?.path, this.mediaItem?.getDateModified?.(),
                false, this.mediaItem?.getThumbnailReady?.());
          }
        },
        aboutToDisappear: (): void => {
          Log.info(TAG, `LongPress MenuList aboutToDisappear, uri=${this.mediaItem?.uri}`);
        },
        onAppear: (): void => {
          AppStorage.setOrCreate<string>('shareAnchorPoint', this.focusNodeKey);
          Log.info(TAG, `LongPress MenuList Show, uri=${this.mediaItem?.uri}`);
          const msg: Record<string, number | string | boolean> = { 'from': this.pageName };
          ReportToBigDataUtil.report(BigDataConstants.LONG_PRESS, msg);
          AlbumBrowsingInfo.albumLongPress = true;
        },
        onDisappear: (): void => {
          Log.info(TAG, `LongPress MenuList Hide, uri=${this.mediaItem?.uri}`);
          // menu销毁时才处理事件，防止弹窗和menu动效重叠
          if (!this.longPressClickedMenu) {
            Log.error(TAG, 'get longPressClickedMenu failed');
            return;
          }
          this.handleLongPressMenuClick(this.longPressClickedMenu);
          this.longPressClickedMenu = undefined;
          AlbumBrowsingInfo.albumLongPress = false;
        },
        preview: () => {
          this.PreviewBuilder();
        },
        backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        previewAnimationOptions: {
          hoverScale: [HOVER_SCALE_START, HOVER_SCALE_END],
        },
        placement: this.isVdeFolded ? Placement.BottomLeft : undefined,
        layoutRegionMargin: {
          left: this.isFromGalleryCleanupPage && !this.isFromShortcutEntryCleanupPage ?
            this.previewPaddingLeftAndRight + this.diggingHoleCameraArea.left : undefined,
          right: this.isFromGalleryCleanupPage && !this.isFromShortcutEntryCleanupPage ?
            this.previewPaddingLeftAndRight + this.diggingHoleCameraArea.right : undefined,
        },
      }
    } else {
      return {
        preview: () => {
        },
        previewAnimationOptions: {
          scale: [HOVER_SCALE_DEFAULT, DRAG_IMAGE_SCALE_RATIO],
        },
        placement: this.isVdeFolded ? Placement.BottomLeft : undefined,
      }
    }
  }

  @Styles
  stickGridItemAttrs() {
    .aspectRatio(this.isShowFontUnderImage() || this.pageName === Constants.PHOTO_ARTGRIDPAGE || this.pageName === 'ProtagonistPlanetPage' ?
      undefined : 1) // 当缩略图下显示文字时，aspectRatio需要不指定才能适配高度
    .height(this.pageName === Constants.PHOTO_ARTGRIDPAGE ? undefined :
    this.gridItemWidth) // 当缩略图下显示文字时，aspectRatio不指定，需要指定height（指定aspectRatio时，height属性自动失效）
    .margin({
      bottom: this.isShowFontUnderImage() ? `${this.pcRecycleBottomHeight}vp` : '0'
    }) // 当缩略图下显示文字时，底部需要留出24vp的空间
    .zIndex(this.isTap ? 1 : 0)
    .attributeModifier(this.gridItemModifier)
    .onMouse((event: MouseEvent): void => {
      if (event.button != MouseButton.Left || event.action != MouseAction.Press) {
        return;
      }
      this.getSelectManager()?.getSelectAsset((assets: PhotoAsset[]) => {
        this.dragAssets = assets;
      }, true)
    })
    .focusBox({
      strokeWidth: LengthMetrics.px(0),
    })
    .transition(this.isNeedTransition ?
      TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: Constants.GRID_OPACITY_DURATION }) :
      TransitionEffect.IDENTITY)
  }

  private handleTouchEvent(event: TouchEvent): void {
    this.touchType = event.type;
    if (event.type === TouchType.Up && this.gridScrollMsg && !this.gridScrollMsg?.isContextMenuDisabledResetAble) {
      this.gridScrollMsg.isContextMenuDisabledResetAble = true;
      this.gridScrollMsg?.resetIsContextMenuDisabled();
    }
    if (event.type !== TouchType.Move) {
      Log.i(TAG, `onTouch trigger touchTpe: ${event.type}, isSelectedMode: ${this.isSelectedMode}, ` +
        `isEnteringPhoto: ${this.isEnteringPhoto}, isSelected:${this.isSelected}`);
    }
    if (event.type === TouchType.Down) {
      this.updateLongPressMenuList?.(this.mediaItem?.isFavor);
      this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
      const isGestureRejectOnScrollBarTouch: boolean = this.gridScrollMsg?.isScrollerBarTouch ?? false;
      if (this.isGestureRejectOnScrollBarTouch !== isGestureRejectOnScrollBarTouch) {
        this.isGestureRejectOnScrollBarTouch = isGestureRejectOnScrollBarTouch;
      }
    }
  }

  private shouldProcessClick(event: GestureEvent): boolean {
    let isMouseOrTouchscreen = event.source === SourceType.Mouse || event.source === SourceType.TouchScreen;
    // 当前只适配pad的搜索页鼠标点击事件，
    if (DeviceInfo.isTablet() && !this.isSearchResultPage) {
      return true;
    }
    return !DeviceInfo.isPcOrTablet() ||
      (DeviceInfo.isPcOrTablet() && event.source === SourceType.TouchScreen && !this.isSelectedMode) ||
      (this.isThird && isMouseOrTouchscreen && !this.isPickerUsedSubwindow);
  }

  @Styles
  stackTouchStyle() {
    .onTouch((event: TouchEvent): void => {
      this.handleTouchEvent(event);
    })
    .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
      others: Array<GestureRecognizer>) => {
      if (current) {
        Log.info(TAG, `onGestureRecognizerJudgeBegin:${current.getType()}` +
          `, getFingerCount:${current.getFingerCount()}`);
        if (current.getType() == GestureControl.GestureType.TAP_GESTURE) {
          this.isOneFinger = current.getFingerCount() === 1;
        }
        if (current.getType() === GestureControl.GestureType.LONG_PRESS_GESTURE) {
          if(AppStorage.get('isTouchScrollBar')){
            return GestureJudgeResult.REJECT;
          }
        }
      }
      return GestureJudgeResult.CONTINUE;
    })
    // 走焦消费Enter & 空格
    .onKeyEvent((event?: KeyEvent) => {
      let storage = LocalStorage.GetShared();
      if (this.isSelectedMode && event?.type === KeyType.Down && event?.keyCode === KeyCode.KEYCODE_ENTER &&
      this.isPickerUsedSubwindow) {
        Log.info(TAG, 'PickerUsedSubwindow onKeyEvent press enter. ');
        this.onMenuClicked?.(Action.OK);
        return;
      }
      if (this.isSelectedMode && event?.type === KeyType.Down && event?.keyCode === KeyCode.KEYCODE_ENTER &&
      this.isSelectedMode && this.isThird && !storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) &&
        !this.isFromPickerView) {
        Log.info(TAG, 'onKeyEvent press enter. ');
        this.onMenuClicked?.(Action.OK);
        return;
      }
      if (event?.type === KeyType.Down &&
        (event?.keyCode === KeyCode.KEYCODE_ENTER || event?.keyCode === KeyCode.KEYCODE_SPACE)) {
        this.onClickHelper.process(event);
        this.getUIContext().getFocusController().clearFocus();
      }
    })
    .onKeyPreIme((event: KeyEvent) => {
      if (event && event.type === KeyType.Down && (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT ||
        event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT || event.keyCode === KeyCode.KEYCODE_DPAD_UP ||
        event.keyCode === KeyCode.KEYCODE_DPAD_DOWN)) {
        this.selectManager?.selectByArrowKey();
      }
      return false;
    })
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture({ count: 2 }).onAction((event: GestureEvent) => {
        if (!DeviceInfo.isPc() || (this.isThird && !this.isPickerUsedSubwindow)) {
          return;
        }
        this.isSecondClick = true;
        this.getUIContext()?.getFocusController()?.clearFocus();
        if (this.isSelectedMode || event.source === SourceType.Mouse) {
          this.openPhotoBrowser();
        }
      }),
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        Log.info(TAG, 'image tapgesture onAction');
        this.checkCtrlShiftPressState(event);
        /* instrument ignore next */
        if (DeviceInfo.isPcOrTablet()) {
          LocalStorage.getShared()?.setOrCreate<boolean>('isKeyEvent', false);
          this.getUIContext().getFocusController().clearFocus();
        }
        if (this.isThird && this.isSingleLineMode) {
          Log.info(TAG, `ignore image tap gesture, isThird and single line`);
          return;
        }
        if (this.isGestureRejectOnScrollBarTouch) {
          Log.warn(TAG, 'touching scroll bar, tap gesture reject');
          return;
        }
        if (this.shouldProcessClick(event)) {
          // picker 单选模式支持混合选择设置
          Log.info(TAG, `singleSelectionMode: ${this.singleSelectionMode}`);
          if (!this.isThirdMultiPick && this.singleSelectionMode === SingleSelectionMode.SELECT_MODE) {
            this.isPreviewForSingleSelectionSupported = false;
          } else if (!this.isThirdMultiPick &&
            this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
            this.isPreviewForSingleSelectionSupported = true;
          }
          /* instrument ignore next */
          if (DeviceInfo.isPc() && event.source === SourceType.TouchScreen && !this.isSelectedMode) {
            LocalStorage.getShared()?.setOrCreate<boolean>('isTapGesture', true);
          }
          this.onClickHelper.process(event);
          return;
        }
        LocalStorage.getShared()?.setOrCreate<boolean>('isTapGesture', false);
        if (this.isSecondClick) {
          this.isSecondClick = false;
          return;
        }
        this.getUIContext()?.getFocusController()?.clearFocus();
        if (!this.isPickerUsedSubwindow) {
          this.focusCtrlManager.setFocusItemKey(this.dragNodeKey);
          this.focusCtrlManager.setFocusItemUri(this.item?.mediaItem?.uri || '');
        } else {
          if (!this.isLocalImage && !this.isPhotoInner) {
            if (!this.isDownloading) {
              this.startDownloadImage();
            } else {
              this.stopDownloadImage();
            }
            return;
          }
        }
        if (event.sourceTool !== 0) {
          this.selectStateChange();
        }
      }),
    ))
  }

  checkCtrlShiftPressState(event: BaseEvent): void {
    if (event.getModifierKeyState?.(['Ctrl']) === true) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_CTRL_PRESS, true);
    } else if (event.getModifierKeyState?.(['Ctrl']) === false) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_CTRL_PRESS, false);
    }
    if (event.getModifierKeyState?.(['Shift']) === true) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS, true);
    } else if (event.getModifierKeyState?.(['Shift']) === false) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS, false);
    }
  }

  isLoadImageErrorCheck(isLoadImageError: boolean): boolean {
    if (isLoadImageError) {
      Log.error(TAG, 'isLoadImageError');
      return true;
    }
    return false;
  }

  isRecycleBinOrTimelinePageOrRealSearch(): boolean {
    if (this.pageName === Constants.PHOTO_TRANSITION_REAL_VIEW_PC ||
      this.pageName === Constants.PHOTO_TRANSITION_REAL_VIEW ||
    UserFileManagerAccess.isRecycleBin(this.albumUri) ||
      this.pageName === Constants.PHOTO_TRANSITION_TIMELINE ||
      this.pageName === Constants.PHOTO_ARTGRIDPAGE ||
    this.isFromOtherAlbumPage) {
      Log.debug(TAG, 'isRecycleBinOrTimelinePage or isShowSearchPage');
      return true;
    }
    return false;
  }

  @Builder
  buildImageGrid() {
    if (this.isEffective) {
      if (this.isTap && !this.useNewPhotoGrid) {
        Column() {
        }
        .onAppear(() => {
          Log.info(TAG,
            `[GeometryLogger] isTap placeholder component appear, uri=${this.mediaItem?.uri}, index=${this.mPosition}, pageName=${this.pageName}`);
        })
        .key('isTapPlaceHolder')
        .aspectRatio(1)
        .rotate({
          x: 0,
          y: 0,
          z: 1,
          angle: 0,
        })
        .backgroundColor($r('sys.color.background_secondary'))
        .width('100%')
        .height('100%')
        .zIndex(-1)
      } else {
        Column() {
          Stack({ alignContent: Alignment.Center }) {
            this.buildNormal();
          }
          .height('100%')
          .width('100%')
          .borderRadius(this.isThird && this.isSingleLineMode ? this.singleLineModeImageBorderRadius : 0)
          .key(this.focusNodeKey)
          .onFocus((): void => {
            if (DeviceInfo.isPc() && this.selectManager?.lastSelectMode !== this.selectManager?.isSelectedMode()) {
              if (this.selectManager) {
                Log.info(TAG, 'ignoreFocus');
                this.selectManager.lastSelectMode = !!this.selectManager.isSelectedMode();
              }
              return;
            }
            if (this.selectManager?.clickedSet.size === 0) {
              this.setFocusImage();
            }
          })
          .clip(!DeviceInfo.isPc() && !this.isShowFontUnderImage()) // 最近删除-图片下显示文字时，这里必须为false
          .attributeModifier(this.stackModifier)
          .onHover((isHover: boolean): void => {
            // 多选模式,选择态,非PC的情况鼠标悬浮不显示收藏图标
            if (this.isLoadImageErrorCheck(this.isLoadImageError) || this.isSelectedMode || !DeviceInfo.isPc()) {
              return;
            }
            this.isHover = isHover;
            if (!DeviceInfo.isTv()) {
              return;
            }
            if (this.isHover) {
              FocusUtil.requestFocus(this.getUIContext()?.getFocusController(), this.dragNodeKey);
            } else {
              FocusUtil.clearFocus(this.getUIContext()?.getFocusController());
            }
          })
        }
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY),
          TransitionEffect.opacity(0)))
        .id('imageGridItem')
        .bindContextMenu(this.LongPressMenuBuilder(ResponseType.RightClick), ResponseType.RightClick,
          {
            modalMode: DeviceInfo.isPc() ? ModalMode.TARGET_WINDOW : ModalMode.AUTO,
            onAppear: (): void => {
              ReportToBigDataUtil.report(BigDataConstants.OPEN_RIGHT_CLICK_MENU);
              Log.info(TAG, `menu onAppear, component anchor key: ${this.focusNodeKey}`);
              AppStorage.setOrCreate<string>(Constants.SHARE_ANCHOR_POINT_RECORD, this.focusNodeKey);
              this.onMenuListAppear();
              this.updateLongPressMenuList(this.mediaItem?.isFavor);
            },
            aboutToAppear: (): void => {
              this.onMenuAboutToAppear();
            },
            onDisappear: (): void => {
              if (!DeviceInfo.isPc()) {
                this.longPressClickedMenu && this.handleLongPressMenuClick(this.longPressClickedMenu);
                this.longPressClickedMenu = undefined;
              }
            }
          }) // 右键点击菜单，后续整改至新组件
        .stackTouchStyle()
        .accessibilityLevel('no')
      }
    }


  }

  @Builder
  buildFileSize() {
    Text(`${ImageUtil.getSortDisplaySize(this.fileSize)}`)
      .fontSize(DeviceInfo.isPc() || DeviceInfo.isTv() ? $r('app.float.image_icon_text_line_height') :
      $r('app.float.multiple_pick_normal_font_size'))
      .maxFontScale(2.0)
      .fontFamily($r('app.string.id_text_font_family_regular'))
      .fontColor(DeviceInfo.isPc() ?
      $r('sys.color.ohos_id_color_text_primary_dark') :
        (DeviceInfo.isTv() ? $r('sys.color.font_primary') : $r('app.color.text_color_above_picture')))
      .lineHeight(DeviceInfo.isPc() ?
      $r('app.float.image_icon_text_line_height_pc') :
        (DeviceInfo.isTv() ? $r('app.float.tv_icon_text_line_height') :
        $r('app.float.image_icon_text_line_height')))
      .margin({
        top: $r('app.float.grid_item_text_margin_top'),
        right: $r('app.float.grid_item_text_margin_right'),
        bottom: DeviceInfo.isPc() ?
        $r('app.float.grid_item_text_margin_bottom_pc') :
          (DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_bottom')),
        left: DeviceInfo.isTv() ? $r('app.float.tv_grid_item_padding') : $r('app.float.grid_item_text_margin_lr'),
      })
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines((1))
      .attributeModifier(this.fileSizeModifier)
  }

  @Builder
  PlaceHolderIcon(res: Resource) {
    Column() {
      Image(res)
        .width(DRAG_PLACEHOLDER_ICON_SIZE * DRAG_IMAGE_SCALE_RATIO)
        .height(DRAG_PLACEHOLDER_ICON_SIZE * DRAG_IMAGE_SCALE_RATIO)
        .fillColor($r('sys.color.ohos_id_color_click_effect'))
        .draggable(false)
    }
    .aspectRatio(1)
    .width(getScreen().getWinWidth() / this.gridRowCount * DRAG_IMAGE_SCALE_RATIO)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_hover'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
  }

  @Builder
  PreviewBuilder() {
    DragPreviewComponent({
      isLoadImageError: this.isLoadImageError,
      mediaType: this.mediaType,
      item: this.mediaItem,
      imageThumbnail: this.imageThumbnail,
    })
  }

  @Builder
  buildNormal() {
    // 缩略图
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
      }
      .width(this.isThird && this.isSingleLineMode ? '100%' : this.getWidth())
      .height(this.isThird && this.isSingleLineMode ? '100%' : this.getHeight())
      .focusBorderStyle()
      .hitTestBehavior(HitTestMode.Transparent)
      .attributeModifier(this.borderRowModifier)
    }
    if (this.isLoadImageErrorCheck(this.isLoadImageError)) {
      // 加载失败替代图片
      this.buildErrorImage();
    } else {
      // 加载各种情况的宫格缩略图
      this.buildImageByCondition();
    }
  }

  /**
   * 加载失败图片（即图片加载失败时的失败替代图片）
   */
  @Builder
  buildErrorImage() {
    Column() {
      SymbolGlyph(this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('sys.symbol.resolution_video_fill') : $r('sys.symbol.picture_fill'))
        .fontSize(DRAG_PLACEHOLDER_ICON_SIZE)
        .draggable(false)
        .aspectRatio(1)
        .rotate({
          x: 0,
          y: 0,
          z: 1,
          angle: 0,
        })
        .fontColor([$r('sys.color.ohos_id_color_click_effect')])
        .focusSetting(this.focusNodeKey, (event: KeyEvent): void => this.handleKeyEvent(event))
        .onAppear((): void => {
          Log.debug(TAG, 'appear the default image!');
        })
    }
    .width('100%')
    .height('100%')
    .geometryTransition(this.geometryTransitionChange())
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_hover'))
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
      this.onImageAreaChange(newValue);
    })

    this.iconBuilder(true)
    // PC端最近删除，图片下显示还剩多少天
    this.buildFontUnderErrorImage();
  }

  @Builder
  iconBuilder(isErrorImage: boolean) {
    if (this.checkBuildIconCondition()) {
      this.buildIcon(isErrorImage);
    }
  }

  private checkBuildIconCondition(): boolean {
    Log.info(TAG, `checkBuildIconCondition: geometryTransitionBrowserId=${this.geometryTransitionBrowserId}` +
      `, isTapStatusChange=${this.isTapStatusChange}， index=${this.mPosition}, uri=${ImageUtil.encryptThumbnailUri(this.mediaItem?.uri)}`);
    const res: boolean = this.geometryTransitionBrowserId === '' || !this.isTapStatusChange;
    return res;
  }

  /**
   * 加载各种情况的宫格缩略图
   */
  @Builder
  buildImageByCondition() {
    if (this.isEditImage && this.editImageUri !== '') {
      this.buildImage();
    } else if (AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine() ||
    this.isThird || this.isFromGalleryCleanupPage) {
      this.buildCachedImage();
    } else {
      this.buildImage();
    }
    /* instrument ignore next */
    if (DeviceInfo.isTv() && this.otherTimeDaysIconBottomPadding > 0) {
      Column() {
      }
      .height('100%')
      .width('100%')
      .hitTestBehavior(HitTestMode.None)
      .linearGradient({
        direction: GradientDirection.Bottom, // 渐变方向
        colors: [[Color.Transparent, 0.6], [$r('app.color.color_secondary'), 1]]
      })
    }
    this.iconBuilder(false);
  }

  /**
   * PC端最近删除界面，加载正常图片下的文字
   */
  @Builder
  buildFontUnderImage() {
    if (this.isShowFontUnderImage()) {
      // 图片高度有值时，定位图片相对位置时，取图片的高度
      if (this.thumbnailHeight) {
        Row() {
          this.buildFontForDaysLeft()
        }
        .width(Constants.PERCENT_100)
        .height(this.isShowFullRatio ? Constants.PERCENT_100 : this.thumbnailHeight)
        .alignItems(VerticalAlign.Bottom)
      } else {
        // 图片高度无值时，取宽度的值，然后按图片比例获取到高度
        Row() {
          this.buildFontForDaysLeft()
        }
        .attributeModifier(this.rowModifier)
        .width(this.isShowFullRatio ? Constants.PERCENT_100 : this.thumbnailWidth)
        .height(Constants.PERCENT_100)
        .aspectRatio(this.isShowFullRatio ? Constants.INVALID : this.ratio)
        .alignItems(VerticalAlign.Bottom)
      }
    }
  }

  /**
   * PC端最近删除界面，加载失败图片下的文字
   */
  @Builder
  buildFontUnderErrorImage() {
    if (this.isShowFontUnderImage()) {
      Row() {
        this.buildFontForDaysLeft()
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Bottom)
    }
  }

  /**
   * 最近删除界面，加载还剩%d天
   */
  @Builder
  buildFontForDaysLeft() {
    Column() {
      Text($r('app.plural.days_left', this.recycleDays, this.recycleDays))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Regular)
        .fontColor(this.recycleDays <=
        Constants.RECYCLE_DAYS_WARN ? $r('sys.color.warning') : $r('sys.color.font_secondary'))
        .textOverflow({ overflow: TextOverflow.None })
        .textAlign(TextAlign.Center)
        .width('100%')
        .height(`${this.pcRecycleBottomHeight - 8}vp`)
        .lineHeight(`${this.pcRecycleBottomHeight - 8}vp`)
        .maxFontScale(Constants.FONT_SCALE_LEVEL1_SIZE)
    }
    .align(Alignment.Bottom)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .margin({ bottom: `${-this.pcRecycleBottomHeight}vp` })
  }

  /**
   * 判断是否在图片下方显示文字：PC端-最近删除
   *
   * @returns 是否在图片下方显示文字
   */
  private isShowFontUnderImage(): boolean {
    return DeviceInfo.isPc() && this.isRecycle;
  }

  private resetPressAnim(): void {
    this.isEnteringPhoto = false;
  }

  private onShow(): void {
    this.resetPressAnim();
  }

  private onItemFullChange(): void {
    if (this.isSelected) {
      this.quality = Constants.DEFAULT_ITEM_OPACITY;
    } else {
      if ((this.isImageFull && this.mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) ||
        (this.isVideoFull && this.mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO)) {
        this.quality = Constants.OBSCURATION_ITEM_OPACITY;
      } else {
        this.quality = Constants.DEFAULT_ITEM_OPACITY;
      }
    }
  }

  private changeTextRes(action: Action): Resource {
    let textStr: Resource = action.textRes;
    if (Action.NOT_FAVORITE.equals(action) || Action.FAVORITE.equals(action)) {
      textStr = this.getFavorTextStr(action);
    }
    return textStr;
  }

  private getFavorTextStr(action: Action): Resource {
    if (this.isSelected) {
      let selectManager = ShortCut.mSelectManager;
      let favorable: boolean = selectManager?.getFavorable() ?? true;
      return favorable ? action.textRes : Action.FAVORITE.textRes;
    } else if (this.mediaItem?.isFavor) {
      return Action.FAVORITE.textRes;
    } else if (!this.mediaItem?.isFavor) {
      return Action.NOT_FAVORITE.textRes;
    }
    return action.textRes;
  }

  // 获取最近删除中，待回收照片倒计天数
  private calculateRecycleDays(): void {
    let currentTimeSeconds: number = new Date().getTime();
    let dateFromItem: number = this.mediaItem?.dateTrashed ?? 0;
    let dateFromSimpleItem: number = this.simpleMediaItem?.getDateTrashed() ?? 0;
    let itemDateTrashed: number =
      this.mediaItem?.dateTrashed && Number.isFinite(dateFromItem) ? dateFromItem : dateFromSimpleItem;
    let trashedDay: number = DateUtil.convertSecondsToDays(currentTimeSeconds - itemDateTrashed);
    let msg: string[] = [`leftDays ${trashedDay}`, `cur: ${currentTimeSeconds}`]
    msg.push(`media: ${this.mediaItem?.dateTrashed}`, `simple: ${this.simpleMediaItem?.getDateTrashed()}`);
    Log.info(TAG, msg.join(', '));
    if (trashedDay > Constants.RECYCLE_DAYS_MAX) {
      Log.info(TAG, `should delete right now currentSec=${currentTimeSeconds}, trashedSec=${
      itemDateTrashed}, trashedDay=${trashedDay}`);
      this.recycleDays = 0;
    } else if (trashedDay <= 0) {
      this.recycleDays = Constants.RECYCLE_DAYS_MAX - 1;
    } else {
      this.recycleDays = Number.parseInt((Constants.RECYCLE_DAYS_MAX - trashedDay) + '');
    }
  }

  private openPhotoBrowser(event?: KeyEvent | GestureEvent): void {
    LocalStorage.getShared()?.setOrCreate<boolean>('isOpenBrowser', true);
    this.getImageBackgroundColor();
    let isKeyEvent: boolean = LocalStorage.getShared()?.get<boolean>('isKeyEvent') ?? false;
    let isTabletClickEnter = false;
    if (isKeyEvent && event) {
      isTabletClickEnter = DeviceInfo.isTablet() && (event as KeyEvent)?.keyCode === KeyCode.KEYCODE_ENTER;
    }
    Log.info(TAG, `openPhotoBrowser, event: ${!!event}, isKeyEvent: ${isKeyEvent} isTabletClickEnter: ${isTabletClickEnter},
    KEYCODE_ENTER: ${(event as KeyEvent)?.keyCode === KeyCode.KEYCODE_ENTER}`);
    if ((this.isSelectedMode && !isTabletClickEnter) ||
      this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.routeToPreviewPage();
    } else {
      this.broadCast.emit(BroadCastConstants.JUMP_TO_PHOTO_BROWSER, []);
      this.jumperToPhotoBrowser();
    }
    // 进入新页面，默认聚焦左上角返回按钮
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      AccessibilityUtil.sendFocusAccessibilityEvent(this.isThird ?
      Constants.COMPONENT_KEY_BUTTON_BACK_THIRD : Constants.COMPONENT_KEY_BUTTON_BrowserBack, Constants.DELAY_THREE_HUNDRED_MILLISECOND);
    }
  }

  private jumperToPhotoBrowser(): void {
    this.focusCtrlManager.setFocusItemKey(this.dragNodeKey);
    this.focusCtrlManager.setFocusItemUri(this.item?.mediaItem?.uri || '');
    this.updateIndex();
    if (this.isPreviewForSingleSelectionSupportedCheck()) {
      return;
    }
    if (DeviceInfo.isPc() && this.isBrowserShow) {
      Log.warn(TAG, `isBrowserShow:${this.isBrowserShow}, need skip.`)
      return;
    }

    Log.info(TAG, `[GeometryLogger] openPhotoBrowser uri=${this.imageThumbnail},\
    mPosition=${this.mPosition}, imagePosition=${this.mediaItem?.getPosition?.()}, this.isThird: ${this.isThird}`);
    if (this.isThird) {
      this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
        [true, this.pageName, this.mediaItem, this.mPosition, this.geometryTransitionString]);
    } else {
      this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER,
        [this.pageName, this.mediaItem, this.mPosition - this.groupCountBefore, this.geometryTransitionString, this.mPosition, this.isLoadLCD]);
    }
    this.isEnteringPhoto = true;
  }

  private isPreviewForSingleSelectionSupportedCheck(): boolean {
    if (!this.isPreviewForSingleSelectionSupported) {
      if (!this.isLocalImage) {
        if (!this.isDownloading) {
          return this.startDownloadImage();
        } else {
          return this.stopDownloadImage();
        }
      }

      if (this.isFromPickerView) {
        this.selectStateChange();
        return true;
      } else {
        if (this.mediaItem?.uri) {
          this.selectManager?.toggle(this.mediaItem?.uri, true);
        }
        this.onMenuClicked?.(Action.OK);
        return true;
      }
    }
    return false;
  }

  private handleKeyEvent(event: KeyEvent): void {
    Log.info(TAG, `handleKeyEvent ${event.keyCode}`);
    /* instrument ignore next */
    if (DeviceInfo.isPcOrTablet()) {
      LocalStorage.getShared()?.setOrCreate<boolean>('isKeyEvent', true);
    }
    if (KeyType.Down == event.type) {
      return;
    }
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_TAB ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_UP ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_DOWN) {
      ShortCut.tabSelectedMedia = this.mediaItem;
    } else {
      Log.info(TAG, 'on key event Up, default');
    }
  }

  private tryOpenBrowser(event: KeyEvent | GestureEvent): boolean {
    Log.info(TAG, 'onclick tryOpenBrowser');
    let openMediaType: number = this.mediaType;
    if (openMediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE && this.mediaItem?.getIsMovingPhoto?.()) {
      openMediaType = OPEN_BROWSER_MOVING_PHOTO;
    }
    let msg: Msg = {
      from: BigDataConstants.BY_CLICK,
      enterPosition: ReportToBigDataUtil.getEnterPhotoBrowserPosition(this.focusCtrlManager.getTabIndex()),
      mediaType: openMediaType,
    }
    if (this.isThird) {
      let isBrowserShow = LocalStorage.getShared()?.get<boolean>('isBrowserShow') ?? false;
      if (isBrowserShow) {
        Log.info(TAG, 'Browser has shown, return');
        return false;
      }
    }
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_WAY, msg);
    PhotoInfo.mediaType = openMediaType;
    let localStorage: LocalStorage = LocalStorage.getShared();
    localStorage?.setOrCreate<number>(Constants.OPEN_MEDIA_TYPE, openMediaType);
    this.openPhotoBrowser(event);
    return false;
  }

  private browserDownloadToGrid(uri: string): void {
    if (this.mediaItem?.uri === uri && !this.isLocalImage && this.isThird && !this.isPhotoInner) {
      Log.info(TAG, 'browserDownloadToGrid uri = ' + uri + ', isDownloading = ' + this.isDownloading);
      this.isDownloading = true;
    }
  }

  private startDownloadImage(): boolean {
    Log.info(TAG, 'startDownloadImage, uri =' +
      (this.item.mediaItem?.uri ?? '') + ', isDownloading = ' + this.isDownloading);
    if (!this.networkAvailable) {
      Log.info(TAG, 'No network');
      UiUtil.showToast($r('app.string.no_network'));
      return false;
    }
    Log.info(TAG, 'startDownloadImage download ,isDownloading set true');
    this.isDownloading = true;
    this.downloadProgress = this.downloadProgress > Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS ?
    this.downloadProgress : Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS;
    Log.info(TAG, 'startDownloadImage: done');
    return true;
  }

  private stopDownloadImage(): boolean {
    Log.info(TAG, 'stopDownloadImage, uri =' +
      (this.item.mediaItem?.uri ?? '') + ', isDownloading = ' + this.isDownloading);
    if (!this.isThird) {
      Log.info(TAG, 'Is not picker');
      return false;
    }
    if (!this.isDownloading) {
      Log.info(TAG, 'no need stop download');
      return true;
    }
    this.isDownloading = false;
    return true;
  }

  private handleClick(event: KeyEvent | GestureEvent): boolean {
    Log.info(TAG, `click image position =  ${this.item?.mediaItem?.getPosition?.()}`);
    return this.tryOpenBrowser(event);
  }

  private onClickCloudDownIcon(): void {
    if (!this.isDownloading) {
      this.startDownloadImage();
    }
  }

  private onClickLoadPanel(): void {
    if (this.isDownloading) {
      this.stopDownloadImage();
    }
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
    if (this.networkAvailable) {
      this.hasShowToast = false
    }
  }

  private eventRegister() {
    this.onClickHelper.register((event: KeyEvent | GestureEvent): boolean => this.handleClick(event));
  }

  private updateGeometryTransition(geometryTransitionString: string): void {
    Log.debug(TAG, `updateGeometryTransition to ${geometryTransitionString}`);
    this.imageModifier.attribute?.geometryTransition(this.geometryTransitionChange());
  }

  private isFromPhotoGridView(): boolean {
    return this.pageName === Constants.PHOTO_TRANSITION_ALBUM ||
      this.pageName === Constants.PHOTO_ARTGRIDPAGE ||
      this.pageName === Constants.PHOTO_TRANSITION_REAL_VIEW_PC ||
      this.pageName === Constants.PHOTO_TRANSITION_REAL_VIEW ||
      this.pageName === Constants.PORTRAIT_PHOTO_GRID_PAGE ||
      this.pageName === Constants.PORTRAIT_COVER_SET_PHOTO_GRID_PAGE ||
      this.pageName === Constants.GROUP_PHOTO_GRID_PAGE;
  }

  private isFromHiddenView(): boolean {
    const PHOTO_HIDDEN_VIEW = 'PhotoHiddenView';
    const PHOTO_HIDDEN_PC_VIEW = 'PhotoHiddenPCView';
    const PHOTO_HIDDEN_GRID_VIEW = 'PhotoHiddenGridView';
    return this.pageName === PHOTO_HIDDEN_VIEW || this.pageName === PHOTO_HIDDEN_PC_VIEW ||
      this.pageName === PHOTO_HIDDEN_GRID_VIEW;
  }

  private getWidth(): number | string {
    return Number(this.imageItemWidth ?? 0) + BORDER_PADDING;
  }

  private getHeight(): number | string {
    return Number(this.imageItemHeight ?? 0) + BORDER_PADDING;
  }

  private previewNotifyPhoto(selectedUri: string, photoBrowserRange: number): void {
    if (selectedUri && this.mediaItem?.uri && this.mediaItem?.uri === selectedUri) {
      Log.info(TAG, `preview openPhotoBrowser uri=${selectedUri}, ` +
        `photoBrowserRange=${photoBrowserRange}, imagePosition=${this.mPosition}` +
        `geometryTransitionString=${this.geometryTransitionString}`);
      this.broadCast.emit(BroadCastConstants.PREVIEW_ENTER_PHOTO_BROWSER,
        [true, this.pageName, this.mediaItem, this.mPosition, this.geometryTransitionString, photoBrowserRange]);
    }
  }

  private onImageAreaChange(newValue: SizeOptions): void {
    if (this.imageItemWidth !== newValue?.width || DeviceInfo.isPc()) {
      this.imageItemWidth = newValue?.width ?? 0;
      let tempWidth: number = Number(this.imageItemWidth) + BORDER_PADDING;
      this.borderRowModifier.attribute?.width(tempWidth);
    }
    if (this.imageItemHeight !== newValue?.height || DeviceInfo.isPc()) {
      this.imageItemHeight = newValue?.height ?? 0;
      let tempHeight: number = Number(this.imageItemHeight) + BORDER_PADDING;
      this.borderRowModifier.attribute?.height(tempHeight);
    }
    if (this.isSingleLineMode) {
      this.singleLineModeGridItemWidth = Number(newValue?.width ?? 0);
      this.singleLineModeGridItemHeight = Number(newValue?.height ?? 0);
      this.borderRowModifier.attribute?.width('100%');
      this.borderRowModifier.attribute?.height('100%');
    }
  }

  /**
   * 销毁照片页预览宫格
   */
  private startHidePreview(): void {
    if (this.mPosition === Number.parseInt(((this.drawnThumbnailCount - 1) / 2).toString()) &&
      (this.gridScrollMsg?.isShowPreview || this.isFromPickerView)) {
      // 延迟触发预览宫格销毁，对于cacheImage缓存未命中的情况，给正式帧解码图片渲染送显留出时间
      Log.info(TAG, 'startHidePreview');
      this.broadCast.emit(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, []);
    }
  }

  onFoldChanged() {
    this.isVdeFolded = DeviceInfo.isVerdeFoldable();
  }

  /**
   * 刷新当前焦点，当列表中失焦时，当前选中的图片需要获焦
   */
  private refreshPickerFocus() {
    let storage = LocalStorage.GetShared();
    if (this.hasInitFocus && this.isSelected && this.isThird && !storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) &&
      !this.isFromPickerView) {
      this.requestFocusImage();
      // 因为没有主动设置zIndex，依赖的是stack默认的顺序，当图片获焦时，会盖住CheckBox，所以需要主动填一下zIndex
      this.imageZIndex = 0;
    }
  }

  private closeContextMenu() {
    if (this.isPrivateHideState) {
      this.getUIContext().getContextMenuController()?.close();
    }
  }

  private onIsFullRatioChange(): void {
    Log.info(TAG,
      `imageGridItem onIsFullRatio:${this.isFullRatio} ratio:${this.ratio} pcRecycleBottomHeight:${this.pcRecycleBottomHeight}`);
    this.isShowFullRatio = this.isFullRatio && !this.isThird;
    if (!this.isShowFullRatio && this.thumbnailSize) {
      this.updateGridThumbnailWithSize(this.thumbnailSize)
    }
  }

  geometryTransitionChange(): string {
    return (this.persistentId !== 0 || this.isBlockTransition) ? '' : this.geometryTransitionString;
  }
}
