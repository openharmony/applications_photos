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

import lazy { SingleLineConfig, PickerOrientation } from '@ohos.file.PhotoPickerComponent';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { CameraGridItemComponent } from './CameraGridItemComponent';
import lazy { Constants, PreviewItemConstants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { GridAutoScrollerUtil } from '@ohos/common/src/main/ets/default/utils/GridAutoScrollerUtil';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy { ImageGridItemComponent } from '@ohos/common/src/main/ets/default/view/ImageGridItemComponent';
import lazy { PickerGridItemComponent } from '@ohos/common/src/main/ets/default/view/PickerGridItemComponent';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { SelectParams, SingleSelectionMode,
  ItemDisplayRatio } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { PickerMediaDataSource } from '../common/PickerMediaDataSource';
import lazy { PickerGridIrregularIndexData } from '../model/PickerGridIrregularIndexData';
import lazy { ThirdSelectedPanel } from './ThirdSelectedPanel';
import lazy { ThirdSelectedPageActionBar } from './ThirdSelectedPageActionBar';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { CustomTheme } from '@ohos.arkui.theme';
import lazy { DefaultThemeColor } from '../common/DefaultThemeColor';
import lazy { GridDragScrollBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridDragScrollBaseHelper';
import lazy { GridScrollScene, GridScrollUtil } from '@ohos/common/src/main/ets/default/utils/GridScrollUtil';
import lazy { GridSlideBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridSlideBaseHelper';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { RegularGridScrollInfo } from '@ohos/common/src/main/ets/default/utils/GridScrollBaseHelper';
import lazy { TimeLineModelManager } from '@ohos/common/src/main/ets/default/view/TimeLineModelManager';
import lazy { ThirdSelectConstants } from '../utils/ThirdSelectConstants';
import lazy { ApplyRecoverInfo } from '../utils/recoverScene/ApplyRecoverInfo';
import lazy { RecoverController } from '../utils/recoverScene/RecoverController';
import lazy { PickerViewWarningDialog } from '@ohos/common/src/main/ets/default/view/dialog/PickerViewWarningDialog';
import lazy { AppPresenceStatus, PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { PickerInstanceUtil } from '@ohos/common/src/main/ets/default/utils/PickerInstanceUtil';
import lazy { GrantPagePromptBox } from './GrantPagePromptBox';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';
import lazy { PickerPreviewGridItem } from '@ohos/common/src/main/ets/default/view/PickerPreviewGridItem';
import lazy { FocusUtil } from '@ohos/common/src/main/ets/default/utils/FocusUtil';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { PhotoPickerMaskLayer } from './PhotoPickerMaskLayer';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { ThirdSelectBrowserParams } from './ThirdSelectBrowserParams'
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { ThirdSelectAlbumGridScrollVM } from '../utils/ThirdSelectAlbumGridScrollVM'

import { BadgeType } from '@ohos.file.PhotoPickerComponent';
/* instrument ignore file */
const TAG: string = 'ThirdSelectAlbumGridBase';
const INIT_PADDING_IN_GRID_TOP_HEIGHT: number = 0.1;
const INVALID_RECOMMEND_TYPE: number = 0;

/**
 * ThirdSelectAlbumGridBase
 */
@Component
export struct ThirdSelectAlbumGridBase {
  // 滑动条
  replaceUriManager: ReplaceUriManager | undefined = undefined;
  private scroller: Scroller = new Scroller();
  @Link selectParams: SelectParams;
  @Link isSearchVisible: boolean;
  public dataSource: PickerMediaDataSource | undefined = undefined;
  @Consume uriResult: string;
  @Consume broadCast: BroadCast;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // 搜索无结果时为true，包括搜索结果无匹配的图片/视频，或者本身图库就为空
  @Consume isSearchNoResultPageVisible: boolean;
  @Consume @Watch('onPageShowChanged') isShow: boolean;

  public selectManager: ThirdSelectManager | undefined;
  @ObjectLink browserController: BrowserController;
  @Link gridItemWidth: number;
  @Link gridItemHeight: number;
  @Link isNeedTransition: boolean;
  // 大图图片索引
  @Link @Watch('onPlaceholderIndexChanged') placeholderIndex: number;
  @Link isShowScrollBar: boolean;
  @Link isVisibleScrollBar: boolean;
  @Consume albumsShow: boolean;
  @Link @Watch('refreshGridRowOrColCount') gridRowCount: number;
  @Link @Watch('refreshGridRowOrColCount') gridColCount: number;
  private isSlidingHorizontally: boolean = false;
  private singleLineConfig: SingleLineConfig | undefined = undefined;
  private hasInitSingleLineModeDrawnThumbnailCount: boolean = false;
  @State private itemDisplayRatio: number = -1;
  @State private imageBorderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0;
  @State private itemGap: Length = Constants.GRID_GUTTER;
  private horizontalPanOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Horizontal });
  private verticalPanOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  @Consume isSelectedMode: boolean;
  private firstIndex: number = 0;
  private lastIndex: number = 0;
  private oriSelectedCount: number | undefined = 0;
  private tempIndex: number = -1;
  private gridAutoScrollerUtil = new GridAutoScrollerUtil();
  @StorageLink('isHorizontal') private isHorizontal: boolean = isOrientationHorizontal();
  private isSelectFull: boolean = false;
  private oriState: boolean = false;
  @State currentUri: string = '';
  private panelId: string = 'ThirdSelectAlbumGridBase';
  private isSetOriginal: boolean = false;
  private entryIndex: number = 0;
  private cacheSet: Set<String> = new Set<String>();
  onMenuClicked: Function = (): void => {
  };
  @Link selectedCount: number;
  @State isSupportPrint: boolean = false;
  @Consume isShowBar: boolean;
  @Consume pageInfo: NavPathStack;
  private isFromAlbum: boolean = false;
  private showActionBar: boolean = false;
  public isFirstEnter: boolean = false;
  @Link title: string;
  private isShowImage: boolean = false;
  @Link isPageHidden: Visibility;
  private onUpdateLayoutOptionsFunc: Function = (size: number): void => this.onUpdateLayoutOptions(size);
  private searchController?: SearchController = new SearchController();
  @Link displaySearchWords: string;
  public isPreviewForSingleSelectionSupported: boolean = true;
  public singleSelectionMode: number = 0;
  public isOriginalSupported: boolean = true;
  private colorTheme: CustomTheme = {};
  @State private isClickScrollBar: boolean = false;
  @Link private layoutOptions: GridLayoutOptions;
  private albumLayoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
  }
  private updatePageIndexFunc: Function = (currentIndex: number): void => this.onIndexChange(currentIndex);
  private dayRegularGridDragScrollHelper: GridDragScrollBaseHelper | undefined =
    GridScrollUtil.createDragScrollHelper(GridScrollScene.DAY_VIEW_REGULAR_GRID_DRAG_SCROLL, true);
  private dayGridSlideHelper: GridSlideBaseHelper | undefined =
    GridScrollUtil.createSlideHelper(GridScrollScene.DAY_VIEW_GRID_SLIDE);
  private isTouchScrollBar: boolean = false;
  private isSupportGridSlide: boolean = false;
  @Prop private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @Prop private moreMenuList: Action[] = [];
  @Link private isRefreshSelectState: boolean;
  private completeButtonText: number = ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE;
  @StorageLink('isShowPickerWarnDialog') private isShowPickerWarnDialog: Boolean = false;
  @StorageLink('isShowPickerViewWarnDialog') private isShowPickerViewWarnDialog: Boolean = false;
  private isPhotoInner: boolean = false;
  private isGrantPage: boolean = false;
  @State private isNeedShowGrantPagePromptBox: boolean = true;
  @Link private totalCount: number;
  @State private thirdSelectController: ThirdSelectGridController = new ThirdSelectGridController();
  private gridIrregularIndexData = new PickerGridIrregularIndexData();
  private countGridOffsetTop: number = 0;
  private countGridOffsetBottom: number = 0;
  private isReachStart: boolean = false;
  private isReachEnd: boolean = false;
  @State gridStartOffset: number = 0;
  @State gridEndOffset: number = 0;
  @State thirdSelectGirdCount: number = 0;
  @State imageArray: MediaItem[] = [];
  @State isShowRaw: boolean = true;
  @State isShowPreview: boolean = false;
  private IS_FIRST_START: boolean = true;
  private showRawTimer: number = 0;
  private isFromCamera: boolean = false;
  private hidePreviewFun: Function = (): void => this.hidePreview();
  private showRawGridFun: Function = (): void => this.showRawGrid();
  private switchAlbumFun: Function = (albumUri: string): void => this.switchAlbum(albumUri);
  private onShowCamera: Function = (): void => {
    if (this.isFromCamera && this.uriResult) {
      let item: MediaItem | undefined = this.dataSource?.getMediaItemByUriFromAll(this.uriResult,
        (mediaItem: MediaItem): void => this.onGetItemByUri(mediaItem));
      if (item !== undefined) {
        this.broadCast.emit(BroadCastConstants.SELECT, [0, item.uri, true, undefined]);
        this.isFromCamera = false;
      }
    }
  };
  private dataObserver: CommonObserverCallback | undefined = new CommonObserverCallback(this);
  @State previewLayoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
  };
  @State gridTemplateAttributeModifier: GridTemplateAttributeModifier =
    new GridTemplateAttributeModifier();
  private isMirrorMode: boolean = false;
  private singleLineConfigGridGutter: number = -1;
  private drawnThumbnailCount: number = 0;
  private drawnCountPointPhone: number = 28;
  @Link isGestureSliding: boolean;
  @State private cachedCount: number = Constants.GRID_CACHE_ROW_COUNT;
  @Link isPickerMaskLayerShow: boolean;
  //是否子窗picker模式
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  private isTvPhotoBrowserLoad: boolean = false;
  private dataIndexForRecover: number = 0;
  @StorageLink('unDataGridCount') private unDataGridCount: number = 0;
  @StorageLink('loadedSize') loadedSize: number = 0;
  private isEnableReScroll: boolean = false;
  @Link isReScrollAfterGetAnchor: boolean;
  private hasGotRecoverAnchor: boolean = false;
  @Link isReScrollAfterDataLoaded: boolean;
  @State hasScrolledToAnchor: boolean = false;
  private updateUnDataGridCountFunc: Function =
    (isInRecommend: boolean, cameraAble: boolean): void => this.updateUnDataGridCount(isInRecommend, cameraAble);
  @BuilderParam selectBrowserLoader: ($$: ThirdSelectBrowserParams) => void;
  private cancelFunc: Function | undefined = undefined;
  private gridScrollVM = new ThirdSelectAlbumGridScrollVM();
  //需要回弹的高度
  private needChangeStartHeight: number = 0;
  //记录偏移量
  private countScrollOffset: number = 0;
  // 大图切换回调，可以传递placeholderIndex以外的组件信息
  placeholderIndexChangedCallback?: (
    placeholderIndex: number, showWarnDialogOffset?: boolean, showCameraGridItem?: boolean
  ) => void;

  @Link badgeType: BadgeType;//接收数据
  @Link badgeConfigUrisSet: Set<string>;
  @State isScreenSliding: boolean = false//屏幕是否移动
  @Link badgeConfigUpdate: boolean;
  /**
   * 发现
   */
  aboutToAppear() {
    Log.info(TAG, `aboutToAppear isFromFa: ${this.selectParams.isFromFa} cameraAble: ${this.selectParams.cameraAble}` +
      `isSearchVisible: ${
      this.isSearchVisible} showActionBar: ${this.showActionBar}, isFromPickerView: ${
      this.selectParams.isFromPickerView}`);
    this.broadCast.on(BroadCastConstants.UPDATE_LAYOUT_OPTIONS, this.onUpdateLayoutOptionsFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_PAGE_INDEX, this.updatePageIndexFunc);
    this.broadCast.on(BroadCastConstants.SWITCH_GRID_VIEW_RAW, this.showRawGridFun);
    this.broadCast.on(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, this.hidePreviewFun);
    this.broadCast.on(BroadCastConstants.PHOTO_PICKER_COMPONENT_SWITCH_ALBUM, this.switchAlbumFun);
    this.broadCast.on(BroadCastConstants.PHOTO_PICKER_ONSHOW_CAMERA, this.onShowCamera);
    this.broadCast.on(BroadCastConstants.UPDATE_UN_DATA_GRID_COUNT, this.updateUnDataGridCountFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR, this.updateRecoverInfoAfterGetAnchor);
    this.appBroadCast.on(BroadCastConstants.RE_SCROLL_AFTER_DATA_LOADED, this.reScrollAfterDataLoaded);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.colorTheme = DefaultThemeColor.getCustomTheme(this.selectParams.customColor)
    this.isSupportGridSlide = TimeLineModelManager.getInstance().isOpenYearMonthTimeLine();
    this.dayGridSlideHelper?.init(this.scroller, this.dataSource as MediaDataSource);
    this.dayRegularGridDragScrollHelper?.init(this.scroller, this.dataSource as MediaDataSource);
    let storage = LocalStorage.getShared();
    storage?.setOrCreate('hasShowToast', false);
    this.isGrantPage = storage?.has(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS);
    if (this.isGrantPage && this.isNeedShowGrantPagePromptBox) {
      this.gridIrregularIndexData.showSafeDialog(true);
      this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
      Log.info(TAG, 'aboutToDisappear, isGrantPage');
    }
    this.initGridTemplateAttributeModifierParams();
    this.initRecoverSceneParams();
    this.checkWarning();
    if (!this.isPhotoInner) {

    }
    this.initPreviewData();
    this.initCachedCount();
    this.initSingleLineConfigParams();
  }

  onPageShowChanged() {
    Log.info(TAG, `onPageShowChanged isShow: ${this.isShow}`);
    this.isShow ? this.dataSource?.onActive() : this.dataSource?.onInActive();
  }

  /**
   * 大图滑动，index切换回调
   */
  onPlaceholderIndexChanged(): void {
    if (this.placeholderIndexChangedCallback) {
      this.placeholderIndexChangedCallback(this.placeholderIndex, this.isFirstItemIrregular(), this.isSupportCamera())
    }
  }
  private refreshGridRowOrColCount(): void {
    Log.info(TAG, 'refreshGridRowOrColCount');
    this.initGridTemplateAttributeModifierParams();
    this.initCachedCount();
  }
  private initCachedCount(): void {
    if (!this.isSlidingHorizontally) {
      this.cachedCount = this.gridRowCount;
    } else {
      this.cachedCount = this.gridColCount;
    }
  }

  private initSingleLineConfigParams(): void {
    this.itemDisplayRatio = this.singleLineConfig && this.singleLineConfig.itemDisplayRatio !== undefined ?
    this.singleLineConfig.itemDisplayRatio : -1;
    this.imageBorderRadius = this.singleLineConfig && this.singleLineConfig.itemBorderRadius ?
    this.singleLineConfig.itemBorderRadius : 0;
    this.itemGap = this.singleLineConfig && this.singleLineConfig.itemGap !== undefined ?
    this.singleLineConfig.itemGap : Constants.GRID_GUTTER;
    Log.info(TAG, `aboutToAppear isSlidingHorizontally = ${this.isSlidingHorizontally},
      singleLineMode = ${this.singleLineConfig !== undefined}, itemDisplayRatio = ${this.itemDisplayRatio}`);
  }

  private initPreviewData() {
    /* instrument ignore next */
    if (DeviceInfo.isPc() || !this.selectParams.isFromPickerView ||
      this.selectParams.recommendationType !== INVALID_RECOMMEND_TYPE) {
      return;
    }
    if (this.IS_FIRST_START && this.dataSource) {
      this.imageArray = this.dataSource.getPreviewArray();
      if (this.imageArray.length === 0) {
        return;
      }
      Log.info(TAG, 'initPreviewData');
      this.isShowPreview = true;
      this.isShowRaw = false;
      this.showRawTimer = setTimeout((): void => {
        Log.info(TAG, 'picker showRaw timeout');
        this.isShowRaw = true;
      }, PreviewItemConstants.DURATION_DEFAULT_SHOW_RAW);
      this.IS_FIRST_START = false;
      this.drawnThumbnailCount = Math.min(this.dataSource.totalCount(), this.drawnCountPointPhone);
    }
  }

  private initGridTemplateAttributeModifierParams() {
    this.gridTemplateAttributeModifier.isSlidingHorizontally = this.isSlidingHorizontally;
    if (!this.singleLineConfig) {
      this.gridTemplateAttributeModifier.rowGridCount = this.gridRowCount;
      this.gridTemplateAttributeModifier.colGridCount = this.gridColCount;
    } else {
      this.gridTemplateAttributeModifier.rowGridCount = 1;
      this.gridTemplateAttributeModifier.colGridCount = 1;
    }
    if (DeviceInfo.isTv()) {
      this.gridTemplateAttributeModifier.rowGridCount = Constants.TV_BAR_GRID_ROW_COUNT;
    }
    let logMsg: string = `GridTemplateAttribute rowCount = ${this.gridTemplateAttributeModifier.rowGridCount}, `;
    logMsg += `colCount = ${this.gridTemplateAttributeModifier.colGridCount}, `;
    logMsg += `isSlidingHorizontally = ${this.gridTemplateAttributeModifier.isSlidingHorizontally}`;
    Log.info(TAG, logMsg);
  }

  public switchAlbum(albumUri: string): void {
    Log.info(TAG, `switchAlbum: albumUri =  ${albumUri}`);
    this.dayRegularGridDragScrollHelper?.switchAlbum(albumUri);
  }

  onGetItemByUri(mediaItem: MediaItem): void {
    Log.info(TAG, `onGetItemByUri: MediaItem index: ${mediaItem.index}, uri: ${mediaItem.uri}, ` +
      `mediaType: ${mediaItem.mediaType}, thumbnail: ${mediaItem.thumbnail}`);
    if (mediaItem?.thumbnail == undefined) {
      mediaItem.thumbnail = this.uriResult as string;
    }
    if (!this.isFromCamera) {
      Log.info(TAG, 'onGetItemByUri stop')
      return;
    }
    this.isFromCamera = false;
    this.dataSource?.cameraItems.push(mediaItem);
    this.broadCast.emit(BroadCastConstants.CAMERA_SELECT, [0, mediaItem.uri, true, undefined, mediaItem]);
  }

  /**
   * 消失
   */
  aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear, isFromPickerView: ${this.selectParams.isFromPickerView}`);
    if (!this.selectParams.isFromPickerView) {
      this.broadCast.emit(BroadCastConstants.THIRD_PICKER_ALBUM_GIRD_CLOSE, []);
    }
    this.broadCast.off(BroadCastConstants.UPDATE_LAYOUT_OPTIONS, this.onUpdateLayoutOptionsFunc);
    this.broadCast.off(BroadCastConstants.UPDATE_PAGE_INDEX, this.updatePageIndexFunc);
    this.broadCast.off(BroadCastConstants.SWITCH_GRID_VIEW_RAW, this.showRawGridFun);
    this.broadCast.off(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, this.hidePreviewFun);
    this.broadCast.off(BroadCastConstants.PHOTO_PICKER_COMPONENT_SWITCH_ALBUM, this.switchAlbumFun);
    this.broadCast.off(BroadCastConstants.PHOTO_PICKER_ONSHOW_CAMERA, this.onShowCamera);
    this.broadCast.off(BroadCastConstants.UPDATE_UN_DATA_GRID_COUNT, this.updateUnDataGridCountFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR, this.updateRecoverInfoAfterGetAnchor);
    this.appBroadCast.off(BroadCastConstants.RE_SCROLL_AFTER_DATA_LOADED, this.reScrollAfterDataLoaded);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    let storage = LocalStorage.getShared();
    storage?.delete('hasShowToast');
  }

  private isFirstItemIrregular(): boolean {
    return (this.isShowDialog() || (this.isGrantPage && this.isNeedShowGrantPagePromptBox)) && !this.isFromAlbum;
  }

  /**
   * 计算
   * @param gesturePosX 手势位置X
   * @param gesturePosY 手势位置Y
   * @param gridGutterVp 宫格间距vp值
   */
  private calEntryIndex(gesturePosX: number, gesturePosY: number, gridGutterVp: number): void {
    this.cacheSet.clear();
    let index: number = this.firstIndex;
    try {
      for (; index <= this.lastIndex; index++) {
        let rect: RectResult = this.scroller.getItemRect(index);
        if ((!this.isSlidingHorizontally || !this.isMirrorMode) && rect.x <= gesturePosX && rect.y <= gesturePosY &&
          rect.x + rect.width + gridGutterVp >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gridGutterVp >= gesturePosY - Number.EPSILON) {
          break;
        }
        if (this.isSlidingHorizontally && this.isMirrorMode && rect.x - gridGutterVp <= gesturePosX &&
          rect.y <= gesturePosY && rect.x + rect.width >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gridGutterVp >= gesturePosY - Number.EPSILON) {
          break;
        }
      }
    } catch (err) {
      Log.error(TAG, `getItemRectErrorForEntry ${err}, this ${this}, scroller ${this?.scroller}, index ${index}`);
    }

    if (this.selectParams.cameraAble && !this.isFromAlbum && index >= 0) {
      index--;
    }
    if (this.isFirstItemIrregular() && index >= 0) {
      index--;
    }
    if (index < 0) {
      return;
    }
    this.entryIndex = index;
    let tempData = this.dataSource?.getWrappedData(index);
    if (!tempData || !this.selectManager) {
      this.oriState = false;
      return;
    }
    if (tempData.mediaItem?.uri) {
      this.oriState = this.selectManager.isItemSelected(tempData.mediaItem.uri, index);
    }
  }

  /**
   * 一镜到底ID
   * @param item
   * @param index
   * @returns
   */
  getGeometryTransitionId(item: ViewData, index: number): string {
    let mediaItem = item?.mediaItem;
    if (mediaItem) {
      return PickerInstanceUtil.getPickerId() + TAG + mediaItem.uri;
    } else {
      return PickerInstanceUtil.getPickerId() + TAG + index;
    }
  }

  /**
   * 计算当前位置索引
   * @param gesturePosX 手势位置X
   * @param gesturePosY 手势位置Y
   * @param isSlidingHorizontally 是否水平滑动
   * @param gridGutterVp 宫格间距
   */
  private calCurrentIndexAndToggle(gesturePosX: number, gesturePosY: number, isSlidingHorizontally: boolean,
    gridGutterVp: number): void {
    let index: number = this.firstIndex;
    try {
      for (; index <= this.lastIndex; index++) {
        let rect: RectResult = this.scroller.getItemRect(index);
        if (rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0) {
          Log.warn(TAG,
            `getItemRectWarn currentIndex = ${index} firstIndex = ${this.firstIndex} lastIndex = ${this.lastIndex}`);
          return;
        }
        if (!isSlidingHorizontally && (rect.y > gesturePosY || gesturePosY < 0)) {
          break;
        }
        if (isSlidingHorizontally && ((!this.isMirrorMode && rect.x > gesturePosX) ||
          (this.isMirrorMode && rect.x + rect.width < gesturePosX) || gesturePosX < 0)) {
          break;
        }
        if ((!this.isSlidingHorizontally || !this.isMirrorMode) && rect.x <= gesturePosX && rect.y <= gesturePosY &&
          rect.x + rect.width + gridGutterVp >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gridGutterVp >= gesturePosY - Number.EPSILON) {
          break;
        }
        if (this.isSlidingHorizontally && this.isMirrorMode && rect.x - gridGutterVp <= gesturePosX &&
          rect.y <= gesturePosY && rect.x + rect.width >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gridGutterVp >= gesturePosY - Number.EPSILON) {
          break;
        }
      }
    } catch (err) {
      Log.error(TAG, `getItemRectErrorForCurrent ${err}, this ${this}, scroller ${this?.scroller}, index ${index}`);
      return;
    }
    if (index === this.lastIndex + 1 && this.entryIndex != index) {
      index--;
    }
    if (this.selectParams.cameraAble && !this.isFromAlbum && index >= 0) {
      index--;
    }
    if (this.isFirstItemIrregular() && index >= 0) {
      index--;
    }
    if (index >= 0) {
      this.toggleItemsWithIndex(this.entryIndex, index);
    }
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  private toggleItemsWithIndex(entryIndex: number, currentIndex: number): void {
    if (this.tempIndex === currentIndex || !this.selectManager || this.browserController.isAnimating ||
      entryIndex === this.loadedSize) {
      return;
    }
    Log.info(TAG, `toggleItemsWithIndex ${entryIndex}  ${currentIndex} ${this.tempIndex}`);
    if (currentIndex === entryIndex) {
      this.releaseToggleWithIndex(entryIndex, this.tempIndex);
      let tempData = this.dataSource?.getWrappedData(entryIndex);
      if (tempData?.mediaItem) {
        this.toggleItemWithCheckNum(tempData.mediaItem, !this.oriState, entryIndex);
      }
    } else if (currentIndex > entryIndex) {
      this.slideDown(entryIndex, currentIndex);
    } else {
      this.slideUp(entryIndex, currentIndex);
    }
    this.tempIndex = currentIndex;
  }

  /**
   * 向上滑动
   * @param entryIndex 选中索引
   * @param currentIndex 当前索引
   */
  private slideUp(entryIndex: number, currentIndex: number): void {
    if (this.tempIndex > entryIndex) {
      this.releaseToggleWithIndex(this.tempIndex, this.entryIndex + 1);
    }
    if (this.tempIndex > currentIndex) {
      let index = entryIndex;
      if (this.tempIndex <= entryIndex) {
        index = this.tempIndex - 1;
      }
      for (; index >= currentIndex; index--) {
        let tempData = this.dataSource?.getWrappedData(index);
        if (!tempData || !tempData.mediaItem) {
          continue;
        }
        if (this.selectManager?.isItemSelected(tempData.mediaItem?.uri, index) &&
          (this.tempIndex > entryIndex || index < this.tempIndex)) {
          this.cacheSet.add(tempData.mediaItem?.uri);
        }
        this.toggleItemWithCheckNum(tempData.mediaItem, !this.oriState, index);
      }
    } else if (this.tempIndex < currentIndex) {
      for (let index = currentIndex - 1; index >= this.tempIndex; index--) {
        let tempData = this.dataSource?.getWrappedData(index);
        if (!tempData || !tempData.mediaItem || this.isNoNeedReleaseState(tempData.mediaItem)) {
          continue;
        }
        this.toggleItemWithCheckNum(tempData.mediaItem, this.oriState, index);
      }
    }
  }

  /**
   * 向下滑动
   * @param entryIndex 选中索引
   * @param currentIndex 当前索引
   */
  private slideDown(entryIndex: number, currentIndex: number): void {
    if (this.tempIndex < entryIndex) {
      this.releaseToggleWithIndex(this.tempIndex, this.entryIndex - 1);
    }
    if (this.tempIndex < currentIndex) {
      let index = entryIndex;
      if (this.tempIndex >= entryIndex) {
        index = this.tempIndex + 1;
      }
      for (; index <= currentIndex; index++) {
        let tempData = this.dataSource?.getWrappedData(index);
        if (!tempData || !tempData.mediaItem) {
          continue;
        }
        if (this.selectManager?.isItemSelected(tempData.mediaItem?.uri, index) &&
          (this.tempIndex < entryIndex || index > this.tempIndex)) {
          this.cacheSet.add(tempData.mediaItem?.uri);
        }
        this.toggleItemWithCheckNum(tempData.mediaItem, !this.oriState, index);
      }
    } else if (this.tempIndex > currentIndex) {
      for (let index = currentIndex + 1; index <= this.tempIndex; index++) {
        let tempData = this.dataSource?.getWrappedData(index);
        if (!tempData || !tempData.mediaItem || this.isNoNeedReleaseState(tempData.mediaItem)) {
          continue;
        }
        this.toggleItemWithCheckNum(tempData.mediaItem, this.oriState, index);
      }
    }
  }

  /**
   * 释放Toggle
   * @param start 初始
   * @param end 结束
   */
  private releaseToggleWithIndex(start: number, end: number): void {
    if (this.tempIndex === -1 || !this.selectManager) {
      return;
    }
    if (end < start) {
      let temp = end;
      end = start;
      start = temp;
    }
    for (let index = start; index <= end; index++) {
      let tempData = this.dataSource?.getWrappedData(index);
      if (!tempData || !tempData.mediaItem || this.isNoNeedReleaseState(tempData.mediaItem)) {
        continue;
      }
      this.toggleItemWithCheckNum(tempData.mediaItem, this.oriState, index);
    }
  }

  private isNeedUpdateDownloadState(uri: string, selectState: boolean): boolean | undefined {
    return selectState;
  }

  private toggleItemWithCheckNum(mediaItem: MediaItem, selectState: boolean, targetIndex?: number): boolean {
    if (mediaItem.getPosition?.() === 2 &&
      !this.isPhotoInner) {
      if (this.isNeedUpdateDownloadState(mediaItem?.uri, selectState)) {
        Log.info(TAG, `Is cloud image, toggleItemWithCheckNum uri = ${mediaItem?.uri}`);
        this.broadCast.emit(Constants.UPDATE_DOWNLOAD_STATE, [mediaItem?.uri]);
      }
      return true;
    }

    if (selectState && this.selectManager?.isSelectFull(mediaItem)) {
      if (this.isSelectFull) {
        return false;
      }

      if (this.selectParams.isFromPickerView) {
        let storage = LocalStorage.getShared();
        PickerUtil.exceedMaxSelectedSendData(mediaItem, this.selectManager, this.selectParams, storage);
      }

      if (this.selectParams.maxSelectedReminderMode === undefined ||
        this.selectParams.maxSelectedReminderMode === Constants.TOAST_REMIND_MODE) {
        UiUtil.showToast($r('app.string.up_to_limit_tips'));
      }
      this.isSelectFull = true;
      return false;
    }
    if (this.selectParams.isFromPickerView) { // 处理picker view化的场景
      // 规避重复选择以及拦截选择数量超过最大选择数量
      this.dealWithPickerView(mediaItem, selectState, targetIndex);
    } else { // 处理系统picker的场景
      this.dealWithSystemPicker(mediaItem, selectState, targetIndex);
    }
    return true;
  }

  private dealWithPickerView(mediaItem: MediaItem, selectState: boolean, targetIndex: number | undefined) {
    let isIncludes: boolean = this.selectManager?.getSelectUris()?.includes(mediaItem?.uri) ?? false;
    if ((!isIncludes && selectState && !this.isSlideSelectFull(mediaItem)) || !selectState) {
      this.broadCast.emit(BroadCastConstants.SELECT,
        [targetIndex, mediaItem?.uri, selectState, (isSelected: boolean): void => {
          if (this.isSelectFull && !selectState && !this.selectManager?.isSelectFull(mediaItem)) {
            this.isSelectFull = false;
          }
        }]);
    }
  }

  private dealWithSystemPicker(mediaItem: MediaItem, selectState: boolean, targetIndex: number | undefined) {
    if (mediaItem?.data?.uri) {
      this.selectManager?.toggle(mediaItem.data.uri, selectState, targetIndex);
    }
    this.broadCast.emit(Constants.UPDATE_SELECTED + mediaItem?.uri, [selectState, mediaItem?.uri]);
    if (this.isSelectFull && !selectState && !this.selectManager?.isSelectFull(mediaItem)) {
      this.isSelectFull = false;
    }
    this.selectManager?.updateMediaItemFullState();
  }

  private isSlideSelectFull(mediaItem: MediaItem): boolean {
    let selectUrisLength = this.selectManager?.getSelectUris()?.length ?? 0;
    if (selectUrisLength >= this.selectParams.maxSelectCount) {
      return true;
    }
    let imageCount = 0;
    let videoCount = 0;
    this.selectManager?.getSelectUris()?.forEach((uri) => {
      let item = this.dataSource?.getMediaItemByUri(uri);
      if (item?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        imageCount++;
      }
      if (item?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        videoCount++;
      }
    });
    if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE &&
      imageCount >= this.selectParams.maxPhotoSelectNumber) {
      return true;
    }
    if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO &&
      videoCount >= this.selectParams.maxVideoSelectNumber) {
      return true;
    }
    return false;
  }

  /**
   * 判断是不需要释放状态
   * @param mediaItem mediaItem
   * @returns
   */
  private isNoNeedReleaseState(mediaItem: MediaItem): boolean {
    return (this.oriState && !this.cacheSet.has(mediaItem.uri)) ||
      (!this.oriState && this.cacheSet.has(mediaItem.uri));
  }

  /**
   * 参数是否满足
   * @returns
   */
  private isParamSatisfied(): boolean {
    return !this.selectParams.isMultiPick || (this.selectParams.isFromPickerView &&
      (this.selectParams.isRepeatSelectSupported || !this.selectParams.isSlidingSelectionSupported));
  }

  /**
   * 拖动手势识别成功回调
   * @param event
   */
  private onPanGestureActionStart(event: GestureEvent): void {
    if (!this.isSelectedMode || DeviceInfo.isPc() || this.isParamSatisfied()) {
      return;
    }
    Log.info(TAG, `onPanGestureActionStart ${this.isGestureSliding}`);
    this.isGestureSliding = true;
    this.oriSelectedCount = this.selectManager?.getSelectedCount();
    event.fingerList = isFilterListEmpty(event.fingerList);
    if (event.fingerList.length <= 0) {
      return;
    }
    this.isMirrorMode = UiUtil.isMirrorMode();
    const gridGutterVp: number = !this.singleLineConfig ? Constants.GRID_GUTTER :
    this.calSingleLineModeGridGutterVp(this.isSlidingHorizontally);
    if (!this.isSlidingHorizontally) {
      this.gridAutoScrollerUtil.initIsEntryFromHotAndNotScrolled(event.fingerList[0].localY);
      this.calEntryIndex(event.fingerList[0].localX - event.offsetX, event.fingerList[0].localY, gridGutterVp);
    } else {
      this.gridAutoScrollerUtil.initIsEntryFromHotAndNotScrolledInHorizontalDirection(event.fingerList[0].localX);
      this.calEntryIndex(event.fingerList[0].localX, event.fingerList[0].localY - event.offsetY, gridGutterVp);
    }
  }

  /**
   * 拖动手势移动回调
   * @param event
   */
  private onPanGestureActionUpdate(event: GestureEvent): void {
    Log.debug(TAG, 'onPanGestureActionUpdate');
    this.isGestureSliding = true;
    if (!this.isSelectedMode || DeviceInfo.isPc() || this.isParamSatisfied()) {
      return;
    }
    event.fingerList = isFilterListEmpty(event.fingerList);
    if (event.fingerList.length <= 0) {
      return;
    }
    const gridGutterVp: number = !this.singleLineConfig ? Constants.GRID_GUTTER :
    this.calSingleLineModeGridGutterVp(this.isSlidingHorizontally);
    if (!this.isSlidingHorizontally) {
      this.gridAutoScrollerUtil.autoscrollOrStop(this.scroller, event.fingerList[0].localY);
      this.calCurrentIndexAndToggle(event.fingerList[0].localX, event.fingerList[0].localY, this.isSlidingHorizontally,
        gridGutterVp);
    } else {
      this.gridAutoScrollerUtil.autoscrollOrStopInHorizontalDirection(this.scroller, event.fingerList[0].localX);
      this.calCurrentIndexAndToggle(event.fingerList[0].localX, event.fingerList[0].localY, this.isSlidingHorizontally,
        gridGutterVp);
    }
  }

  private onPanGestureActionEnd(event: GestureEvent): void {
    Log.info(TAG, `onPanGestureActionEnd ${this.isGestureSliding}`);
    this.isGestureSliding = false;
    this.tempIndex = -1;
    this.isSelectFull = false;
    if (!this.isSelectedMode || DeviceInfo.isPc() || this.isParamSatisfied()) {
      return;
    }
    let count: number = 0;
    if (this.selectManager) {
      count = this.selectManager?.getSelectedCount();
    }
    if (this.oriSelectedCount) {
      count = Math.abs(count - this.oriSelectedCount);
    }
    this.gridAutoScrollerUtil.isEntryFromHotAndNotScrolled = false;
    this.scroller.scrollBy(0, 0);
    const msg: Record<string, number | string | boolean> = {
      'behaviorType': this.oriState ?
      BigDataConstants.PHOTO_SLIDE_DESELECT_TYPE : BigDataConstants.PHOTO_SLIDE_SELECT_TYPE,
      'count': count
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_SLIDE_SELECT, msg);
  }

  private calSingleLineModeGridGutterVp(isSlidingHorizontally: boolean): number {
    if (this.singleLineConfigGridGutter >= 0) {
      return this.singleLineConfigGridGutter;
    }

    // 图片占一屏或超过一屏场景，无法计算间距，因滑动时下一张图片未漏出，可给予默认间距
    let defaultGridGutter: number = Constants.GRID_GUTTER;
    if (this.firstIndex >= this.lastIndex) {
      return defaultGridGutter;
    }
    try {
      const firstRect = this.scroller.getItemRect(this.firstIndex);
      const nextRect = this.scroller.getItemRect(this.firstIndex + 1);
      if (isSlidingHorizontally) {
        if (!this.isMirrorMode) {
          defaultGridGutter = nextRect.x - (firstRect.x + firstRect.width);
        } else {
          defaultGridGutter = firstRect.x - (nextRect.x + firstRect.width);
        }
      } else {
        defaultGridGutter = nextRect.y - (firstRect.y + firstRect.height);
      }
      this.singleLineConfigGridGutter = defaultGridGutter;
    } catch (e) {
      Log.error(TAG, `calSingleLineModeGridGutterVp error code = ${e?.code}, error msg = ${e?.message}`);
    }
    return defaultGridGutter;

  }

  private checkWarning(): void {
    if (this.selectParams.bundleName === Constants.PHOTO_BUNDLE_NAME || this.isGrantPage || this.isVerdeFoldable) {
      this.isShowPickerWarnDialog = false;
      this.isShowPickerViewWarnDialog = false;
      return;
    }
    let key: string = this.selectParams.isFromPickerView ?
    Constants.ACCESSING_PICKER_VIEW_APP_LIST : Constants.ACCESSING_PICKER_APP_LIST;
    PickerUtil.isAppExist(this.selectParams.bundleName, key)
      .then((result: AppPresenceStatus) => {
        if (result === AppPresenceStatus.NOT_EXIST && !this.isSlidingHorizontally) {
          this.gridIrregularIndexData.showSafeDialog(true);
          if (this.selectParams.isFromPickerView) {
            this.isShowPickerViewWarnDialog = true;
          } else {
            this.isShowPickerWarnDialog = true;
            this.updateUnDataGridCountOnWarnDialog();
            this.reScrollOnPickerWarnDiagLoaded();
          }
          Log.info(TAG, 'show dialog');
        } else {
          this.gridIrregularIndexData.showSafeDialog(false);
          if (this.selectParams.isFromPickerView) {
            this.isShowPickerViewWarnDialog = false;
          } else {
            this.isShowPickerWarnDialog = false;
            this.isEnableReScroll = false;
          }
          Log.info(TAG, 'close dialog');
        }
        this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
      });
  }

  private scrollReachBoundary(scrollOffset: number, scrollState: ScrollState) {
    if (this.selectParams.gridStartOffset === 0 && this.selectParams.gridEndOffset === 0) {
      return;
    }
    if (!this.selectParams.isFromPickerView) {
      return;
    }
    if (this.isReachStart && scrollState === ScrollState.Scroll) {
      let gridHeight: number = this.gridAutoScrollerUtil.getScrollerHeight();
      if (this.selectParams.gridStartOffset <= 0 || this.selectParams.gridStartOffset >= gridHeight) {
        return;
      }
      this.countGridOffsetTop += scrollOffset;
      Log.info(TAG, `scrollReachBoundary Top ${scrollState} ${this.countGridOffsetTop}`);
      if (this.countGridOffsetTop <= -this.selectParams.gridStartOffset) {
        if (this.gridStartOffset !== this.selectParams.gridStartOffset) {
          this.gridStartOffset = INIT_PADDING_IN_GRID_TOP_HEIGHT;
        }
        this.gridIrregularIndexData.showGridStartOffset(true);
        this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
      }
      return;
    }
    if (this.isReachEnd && scrollState === ScrollState.Scroll) {
      let gridHeight: number = this.gridAutoScrollerUtil.getScrollerHeight();
      if (this.selectParams.gridEndOffset <= 0 || this.selectParams.gridEndOffset >= gridHeight) {
        return;
      }
      this.countGridOffsetBottom += scrollOffset;
      Log.info(TAG, `scrollReachBoundary Bottom ${scrollState} ${this.countGridOffsetBottom}`);
      if (this.countGridOffsetBottom >= this.selectParams.gridEndOffset) {
        this.gridEndOffset = this.selectParams.gridEndOffset;
        this.gridIrregularIndexData.showGridEndOffset(true,
          this.isSupportCamera() ? this.totalCount + 1 : this.totalCount);
        this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
        this.isReachEnd = false;
      }
      return;
    }
  }

  /**
   * isSearchNoResultPageVisible 搜索无结果时为true，包括搜索结果无匹配的图片/视频，或者本身图库就为空
   * displaySearchWords 表示搜索词
   * 展示场景：
   * 1. isSearchNoResultPageVisible为true, displaySearchWords不为空，即搜索无匹配的图片/视频，
   *    此场景的安全横幅写在搜索结果页的组件中（PickerSearchComponent.ets），此处不展示横幅
   * 2. isSearchNoResultPageVisible为true, displaySearchWords为空，即代表图库无图片/视频，此处需要展示横幅
   * 3. isSearchNoResultPageVisible为false, 即有图片/视频展示，此处需要展示横幅
   *
   * @returns true: 本组件中需要展示安全横幅
   */
  private isShowDialog(): boolean {
    let result: boolean =
      ((this.isShowPickerWarnDialog && !this.selectParams.isFromPickerView) ||
        (this.isShowPickerViewWarnDialog && this.selectParams.isFromPickerView)) &&
        (!this.isSearchNoResultPageVisible ||
          this.displaySearchWords === '');
    result = result && !this.isSlidingHorizontally && !this.singleLineConfig;
    Log.debug(TAG,
      `isShowDialog: result = ${result},${this.isSearchNoResultPageVisible},${this.displaySearchWords?.length ?? -1}`);
    return result;
  }

  private hidePreview(): void {
    this.isShowPreview = false;
  }

  private showRawGrid(): void {
    this.isShowRaw = true;
    clearTimeout(this.showRawTimer);
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
            this.updateUnDataGridCountOnWarnDialog();
          }
          this.gridIrregularIndexData.showSafeDialog(false);
          this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
        },
      })
        .visibility(this.hasScrolledToAnchor ? Visibility.Visible : Visibility.Hidden)
    }
  }

  @Builder
  buildGrantPagePromptBox() {
    GridItem() {
      GrantPagePromptBox({
        appName: LocalStorage.getShared()?.get<string>(Constants.PHOTO_PICKER_GRANT_PHOTO_APP_NAME) as string,
        count: this.totalCount,
        emitHidePickerViewWarningDialog: (): void => {
          this.isNeedShowGrantPagePromptBox = false;
          this.gridIrregularIndexData.showSafeDialog(false);
          this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
        },
      })
    }
  }

  @Builder
  buildPhotoViewPreView() {
    Grid(this.scroller, this.layoutOptions) {
      if (this.isShowDialog() && !this.isFromAlbum && !this.isGrantPage) {
        this.buildPickerWarningDialog();
      }
      if (this.isSupportCamera()) {
        this.buildCameraGridItem();
      }
      ForEach(this.imageArray, (item: MediaItem, index: number) => {
        if (item?.thumbnail?.length > 0) {
          PickerPreviewGridItem({
            item: item,
            index: index,
            gridItemWidth: this.gridItemWidth,
            drawnThumbnailCount: Number.parseInt((this.imageArray.length / 2).toString()),
            isSlidingHorizontally: this.isSlidingHorizontally,
            isSingleLineMode: this.singleLineConfig !== undefined && this.singleLineConfig !== null,
            singleLineModeItemDisplayRatio: this.itemDisplayRatio,
            imageBorderRadius: this.imageBorderRadius
          })
        }
      }, (item: MediaItem, index: number) => {
        return `${index}PickerGridItemPreview`;
      })
    }
    .gridGapStyle(this.itemGap)
    .attributeModifier(this.gridTemplateAttributeModifier)
    .cachedCount(0)
    .scrollBar(!this.singleLineConfig ? BarState.Auto : BarState.Off)
    .onAreaChange((oldValue, newValue) => {
      if (!this.singleLineConfig || this.hasInitSingleLineModeDrawnThumbnailCount) {
        return;
      }
      const containerWidth = Number(newValue.width);
      const containerHeight = Number(newValue.height);
      this.hasInitSingleLineModeDrawnThumbnailCount = true;
      this.drawnThumbnailCount = this.getSingleLineModeDrawnThumbnailCount(this.scroller, this.imageArray.length,
        containerWidth, containerHeight);
      Log.info(TAG, `get singleLineMode drawnThumbnailCount is ${this.drawnThumbnailCount}`);
      this.broadCast.emit(BroadCastConstants.PICKER_SINGLE_LINE_MODE_PREVIEW_IMG_CREATED, [
        Number.parseInt((this.drawnThumbnailCount / 2).toString())]);
      // 如果只显示了相机 真实宫格也只能加载相机Item 后面的图片Item不会显示 此处直接让图片Item一定延时后显示
      if (this.isSupportCamera() && this.drawnThumbnailCount === 1) {
        setTimeout((): void => {
          this.showRawGrid();
          this.hidePreview();
          Log.info(TAG, 'isSupportCamera is true and drawnThumbnailCount is 1, start to hide preview');
        }, PreviewItemConstants.ENCODE_FRAME_INTERVAL);
      }
    })
  }

  @Builder
  buildPhotoGrid() {
    Grid(this.scroller, this.isFromAlbum ?
    this.albumLayoutOptions : this.layoutOptions) {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.buildTvGridItem()
      } else {
        this.buildGridItem();
      }
    }
    .key('ThirdSelectAlbum_Gird')
    .onScrollStart((): void => {
      this.isScreenSliding = true
      this.handleScrollStart();
    })
    .onScrollStop((): void => {
      this.isScreenSliding = false
      this.handleScrollStop();
    })
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .scrollBar(DeviceInfo.isPc() && !this.singleLineConfig ? BarState.Auto : BarState.Off)
    .attributeModifier(this.gridTemplateAttributeModifier)
    .layoutDirection(!this.isSlidingHorizontally ? GridDirection.Row : GridDirection.Column)
    .cachedCount(this.cachedCount)
    .onAttach(() => {
      this.scrollToRecoverAnchor();
    })
    .onScrollIndex((index: number, last: number): void => {
      this.handleScrollIndex(index, last);
    })
    .enableScrollInteraction(!this.browserController.isBrowserShow)
    .onScrollBarUpdate(
      this.onScrollBarUpdateActived() ?
        (index: number, offset: number): ComputedBarAttribute => this.gridScrollVM.onScrollBarUpdate({
          index,
          offset,
          count: this.dataSource?.getCount() || 0,
          rowOffset: this.isShowDialog() && !this.isFromAlbum && !this.isGrantPage ? 1 : 0,
          columnOffset: this.isSupportCamera() ? 1 : 0,
          gridItemHeight: this.gridItemHeight,
          gridRowCount: this.gridRowCount,
        }) : undefined
    )
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.dayRegularGridDragScrollHelper?.handleScroll(scrollOffset);
      this.scrollReachBoundary(scrollOffset, scrollState);
    })
    .onWillScroll((offset: number, state: ScrollState, source: ScrollSource): void | ScrollResult => {
      this.countScrollOffset += offset;
      if (this.needChangeStartHeight !== 0 && this.gridStartOffset !== this.selectParams.gridStartOffset &&
        this.gridStartOffset !== 0) {
        if (this.gridStartOffset < 0) {
          this.gridStartOffset = INIT_PADDING_IN_GRID_TOP_HEIGHT;
        }
        //偏移量*（设置的高度/需要回弹的高度），为了高度变化流畅
        this.gridStartOffset += offset * (this.selectParams.gridStartOffset / -this.needChangeStartHeight);
        if (this.gridStartOffset > this.selectParams.gridStartOffset) {
          this.gridStartOffset = this.selectParams.gridStartOffset;
          this.needChangeStartHeight = 0;
        }
      }
      return this.handleWillScroll(offset, state, source);
    })
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      this.handleAreaChange(oldValue, newValue);
    })
    .onReachStart(() => {
      Log.info(TAG, 'onReachStart');
      this.isReachStart = true;
    })
    .onReachEnd(() => {
      Log.info(TAG, 'onReachEnd');
      this.isReachEnd = true;
    })
    .onTouch((event) => {
      if (event.type === TouchType.Up && this.gridStartOffset !== this.selectParams.gridStartOffset) {
        this.needChangeStartHeight = this.countScrollOffset;
      }
    })
    .visibility(this.isShowPreview ? Visibility.Hidden : Visibility.Visible)
    .gesture(
      PanGesture(this.isSlidingHorizontally ? this.verticalPanOption : this.horizontalPanOption)
        .onActionStart((event: GestureEvent): void => this.onPanGestureActionStart(event))
        .onActionUpdate((event: GestureEvent): void => this.onPanGestureActionUpdate(event))
        .onActionEnd((event: GestureEvent): void => this.onPanGestureActionEnd(event))
    )
    .margin({
      top: this.getPickerAlbumGridTopMargin(),
      left: $r('app.float.picker_album_grid_margin'), right: $r('app.float.picker_album_grid_margin'),
    })
    .fadingEdge(DeviceInfo.isTv(),
      { fadingEdgeLength: LengthMetrics.resource($r('app.float.picker_fade_edge_length')) })
    .flingSpeedLimit(Constants.GRID_PICKER_FLING_SPEED)
    .columnsGap(DeviceInfo.isTv() ? 3 : (this.isPickerUsedSubwindow ? Constants.PC_GRID_GUTTER :
    this.itemGap))
    .rowsGap(DeviceInfo.isTv() ? 3 : (this.isPickerUsedSubwindow ? Constants.PC_GRID_GUTTER :
    this.itemGap))
    .padding({
      left: this.isPickerUsedSubwindow ? $r('sys.float.padding_level12') : 0,
      right: this.isPickerUsedSubwindow ? $r('sys.float.padding_level12') : 0,
      top: (this.isPickerUsedSubwindow && !this.isShowDialog()) ? $r('sys.float.padding_level4') : 0,
      bottom: this.isPickerUsedSubwindow ? $r('sys.float.padding_level4') : 0,
    })
    .multiSelectable(true);
  }

  private onScrollBarUpdateActived() {
    // 横向滑动与单行模式不做优化
    return this.selectParams.orientation === PickerOrientation.VERTICAL && !this.selectParams.singleLineConfig;
  }

  private initRecoverSceneParams() {
    this.unDataGridCount = 0;
    if (!this.selectParams.recoverSceneEnabled) {
      this.hasScrolledToAnchor = true;
      Log.info(TAG, `hasScrolledToAnchor has set as ${this.hasScrolledToAnchor} in unRecoverScene.`);
    }
    if (this.selectParams.recoverSceneEnabled) {
      this.dataIndexForRecover = this.selectParams.dataIndexForRecover;
      this.hasGotRecoverAnchor = this.selectParams.hasGotRecoverAnchor;
      this.isEnableReScroll = true;
      Log.info(TAG, `isEnableReScroll is enabled.`);
    }
    this.updateUnDataGridCountOnCamera(this.selectParams.cameraAble);
  }

  private updateUnDataGridCount(isInRecommend: boolean, cameraAble:boolean) {
    this.unDataGridCount = 0;
    if (!isInRecommend) {
      this.updateUnDataGridCountOnCamera(cameraAble);
    }
    this.updateUnDataGridCountOnWarnDialog();
  }

  private updateUnDataGridCountOnCamera(cameraAble:boolean) {
    let isInAll: boolean = ApplyRecoverInfo.getIsInAll(this.selectParams);
    if (isInAll) {
      this.unDataGridCount =
        ApplyRecoverInfo.getUnDataGridCountOnCamera(cameraAble, this.unDataGridCount);
    }
    Log.info(TAG, `updateUnDataGridCountOnCamera, unDataGridCount is:${this.unDataGridCount}, isInAll is: ${isInAll}`);
  }

  private updateUnDataGridCountOnWarnDialog() {
    let isInAll: boolean = ApplyRecoverInfo.getIsInAll(this.selectParams);
    let isInRecommend: boolean = ApplyRecoverInfo.getIsInRecommend(this.selectParams);
    if (isInAll || isInRecommend) {
      this.unDataGridCount =
        ApplyRecoverInfo.getUnDataGridCountOnWarnDialog(this.isShowPickerWarnDialog, this.unDataGridCount);
    }
    Log.info(TAG,
      `updateUnDataGridCountOnWarnDialog, unDataGridCount: ${this.unDataGridCount}, isInAll: ${isInAll}, isInRecommend:${isInRecommend}`);
  }

  /**
   * 1. recoverSceneEnabled用于在AlbumGridBase组件attach时判断是否需要进行现场恢复，如果此时已经获取到锚点信息，并且已加载数据比当前锚点位置大时，直接进行现场恢复。
   * 2. 如果AlbumGridBase组件在attach时，未获取到锚点信息，则设置isReScrollAfterGetAnchor为true。
   * 在parseContextRecoveryInfo()获取锚点信息后，接收其发送的UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR广播通知，从而进行现场恢复。
   * 3. 如果进行现场恢复时，已获取到锚点位置，但是已加载数据比当前锚点位置小，则设置isReScrollAfterDataLoaded为true。
   * 在接收数据加载发送的RE_SCROLL_AFTER_DATA_LOADED广播通知后，进行现场恢复。
   */
  private scrollToRecoverAnchor() {
    Log.info(TAG, `scrollToRecoverAnchor, recoverSceneEnabled is: ` +
      `${this.selectParams.recoverSceneEnabled}, isReScrollAfterGetAnchor is: ${this.isReScrollAfterGetAnchor}, ` +
      `isReScrollAfterDataLoaded is ${this.isReScrollAfterDataLoaded}, hasGotRecoverAnchor is ${this.hasGotRecoverAnchor}`);
    if (this.selectParams.recoverSceneEnabled || this.isReScrollAfterGetAnchor || this.isReScrollAfterDataLoaded) {
      this.selectParams.recoverSceneEnabled = false;
      this.broadCast.emit(Constants.DISABLE_SCROLL_TO_ANCHOR, []);
      if (this.hasGotRecoverAnchor === false) {
        this.isReScrollAfterGetAnchor = true;
        return;
      }
      if (this.loadedSize < this.dataIndexForRecover) {
        this.isReScrollAfterDataLoaded = true;
        return;
      }
      let lastGridIndex = ApplyRecoverInfo.convertDataIndexToGridIndex(this.dataIndexForRecover,
        this.selectParams.isRecoverAlbum, this.unDataGridCount);
      this.scroller.scrollToIndex(lastGridIndex);
      this.hasScrolledToAnchor = true;
      Log.info(TAG, `hasScrolledToAnchor has set as ${this.hasScrolledToAnchor} in RecoverScene.`);
    }
  }

  private reScrollAfterDataLoaded = (dataIndexForRecover: number) => {
    Log.info(TAG, `emit reScrollAfterDataLoaded, ` +
      `dataIndexForRecover is ${dataIndexForRecover}, loadedSize is ${this.loadedSize}.`);
    if (this.dataIndexForRecover !== dataIndexForRecover) {
      this.dataIndexForRecover = dataIndexForRecover;
    }
    this.scrollToRecoverAnchor();
    this.isReScrollAfterDataLoaded = false;
  }

  private updateRecoverInfoAfterGetAnchor = (dataIndexForRecover: number) => {
    Log.info(TAG, `emit updateRecoverInfoAfterGetAnchor, isReScrollAfterGetAnchor is ${this.isReScrollAfterGetAnchor}, ` +
      `dataIndexForRecover is ${dataIndexForRecover}.`);
    this.hasGotRecoverAnchor = true;
    if (this.dataIndexForRecover !== dataIndexForRecover) {
      this.dataIndexForRecover = dataIndexForRecover;
    }
    if (this.isReScrollAfterGetAnchor) {
      this.scrollToRecoverAnchor();
      this.isReScrollAfterGetAnchor = false;
    }
  }

  private reScrollOnPickerWarnDiagLoaded() {
    if (!this.isEnableReScroll) {
      return;
    }
    if (!this.selectParams.isRecoverAlbum && this.isEnableReScroll) {
      Log.info(TAG, `reScrollOnPickerWarnDiagLoaded.`)
      let lastGridIndex: number = ApplyRecoverInfo.convertDataIndexToGridIndex(this.dataIndexForRecover,
        this.selectParams.isRecoverAlbum, this.unDataGridCount);
      this.scroller.scrollToIndex(lastGridIndex);
    }
    this.isEnableReScroll = false;
  }

  @Builder
  buildGrid() {
    WithTheme({ theme: this.colorTheme }) {
      Column() {
        this.buildActionBar();

        Stack() {
          if (this.isShowRaw) {
            this.buildPhotoGrid();
          }

          if (this.isShowPreview) {
            this.buildPhotoViewPreView();
          }
          if (this.isPickerMaskLayerShow && this.isFromAlbum && !this.browserController.isBrowserShow) {
            Column() {
              PhotoPickerMaskLayer({
                isPickerMaskLayerShow: this.isPickerMaskLayerShow,
                photoBrowserBackgroundColorMode: this.selectParams.photoBrowserBackgroundColorMode,
              })
            }
          }
        }
        .layoutWeight(1)

        if (!DeviceInfo.isPc() && this.isShowScrollBar && !this.isPickerMaskLayerShow && !this.singleLineConfig) {
          this.buildGridScrollBar();
        }

        if (this.selectParams?.isNeedSelectBar && !this.isPickerMaskLayerShow &&
          (this.selectParams?.isMultiPick || this.isPickerUsedSubwindow ||
            this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE)) {
          this.buildPanel();
        }

        if (!this.selectParams.isFromPickerView && !this.isVerdeFoldable && !this.isPickerUsedSubwindow) {
          PickerSelectTip()
            .margin({
              bottom: (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
              $r('app.float.navigation_margin_bottom') : $r('app.float.picker_footer_safety_height'))
            });
        }
      }
      .visibility(this.isPageHidden)
      .transition({ type: TransitionType.All, opacity: 0 })
    }
  }

  /**
   * 大图动画返回回调
   * @param currentIndex
   */
  private onIndexChange(currentIndex: number): void {
    Log.info(TAG, `picker onIndexChange ${currentIndex}`);
    this.isShowScrollBar = false;
  }

  private isSupportCamera(): boolean {
    if (this.isPickerUsedSubwindow && !StringUtil.isInvalid(this.selectParams.uri)) {
      return false;
    }
    /* instrument ignore next */
    if (DeviceInfo.isTv() && this.dataSource?.albumUri) {
      return false;
    }
    return !this.selectParams.isFromFa && this.selectParams.cameraAble && !this.isFromAlbum &&
      !this.showActionBar && !this.displaySearchWords;
  }

  @Builder
  buildTvGridItem() {
    if (this.isShowDialog()) {
      Column()
    }
    if (this.isSupportCamera()) {
      GridItem() {
        CameraGridItemComponent({
          resultUri: '',
          selectParams: this.selectParams,
          broadCast: this.broadCast,
          thirdSelectController: this.thirdSelectController,
          updateDataFunc: (uri: string) => {
            Log.debug(TAG, `get camera callback, uri ${uri}`);
            this.dataSource?.initData();

            this.uriResult = uri;
            let item: MediaItem | undefined = this.dataSource?.getMediaItemByUriFromAll(uri,
              (mediaItem: MediaItem): void => this.onGetItemByUri(mediaItem));
            if (item !== undefined) {
              this.broadCast.emit(BroadCastConstants.SELECT, [0, item.uri, true, undefined]);
            }
          }
        });
      }
      .key('TvCameraGridItem')
      .selectable(false)
      .aspectRatio(1)
      .width($r('app.float.tv_picker_photo_grid_size'))
      .height($r('app.float.tv_picker_photo_grid_size'))
      .margin({
        left: $r('app.float.tv_grid_item_padding'),
        right: $r('app.float.tv_grid_item_padding'),
        bottom: $r('app.float.picker_album_grid_margin'),
      })
      .borderRadius($r('app.float.tv_picker_photo_item_radius'))
      .clip(true)
    }
    this.buildTvPhotoGridItem();
  }

  @Builder
  buildTvPhotoGridItem() {
    LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
      ImageGridItemComponent({
        replaceUriManager: this.replaceUriManager,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        dataSource: this.dataSource,
        item: item,
        isSelected: this.selectManager?.isItemSelected((item?.mediaItem)?.uri as string, index) ?? false,
        pageName: TAG,
        isThird: true,
        mPosition: index,
        isThirdMultiPick: this.selectParams.isMultiPick,
        isShowSerialNum: this.selectParams.isShowSerialNum,
        geometryTransitionString: this.getGeometryTransitionId(item, index as number),
        selectedCount: $thirdSelectGirdCount,
        isSupportPrint: $isSupportPrint,
        gridItemWidth: this.gridItemWidth,
        selectManager: this.selectManager,
        isNeedTransition: this.isNeedTransition,
        gridRowCount: $gridRowCount,
        isFromPickerView: this.selectParams.isFromPickerView,
        drawnThumbnailCount: this.drawnThumbnailCount,
        checkBoxColor: this.selectParams.checkBoxColor,
        checkboxTextColor: this.selectParams.checkboxTextColor,
        isPreviewForSingleSelectionSupported: this.isPreviewForSingleSelectionSupported,
        singleSelectionMode: this.singleSelectionMode,
        isRepeatSelectSupported: this.selectParams.isRepeatSelectSupported,
        albumUri: this.selectParams.albumUri,
        isSelectedMode: this.isSelectedMode,
        themeColor: this.selectParams.customColor,
        isRefreshSelectState: $isRefreshSelectState,
        isPhotoInner: this.isPhotoInner,
        otherTimeDaysIconBottomPadding: Constants.TV_BAR_GRID_BOTTOM_PADDING,
      })
        .reuseId(UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_ALBUM,
          item, this.getGeometryTransitionId(item, index as number)))
        .aspectRatio(1)
        .zIndex(index === this.placeholderIndex ? 1 : 0)
        .width($r('app.float.tv_picker_photo_grid_size'))
        .height($r('app.float.tv_picker_photo_grid_size'))
        .margin({
          left: $r('app.float.tv_grid_item_padding'),
          right: $r('app.float.tv_grid_item_padding'),
          bottom: $r('app.float.picker_album_grid_margin'),
        })
        .borderRadius($r('app.float.tv_picker_photo_item_radius'))
        .clip(true)
    }, (item: ViewData, index?: number) => {
      if (item == undefined || item.mediaItem == undefined) {
        return JSON.stringify(item) + index;
      } else {
        return this.getGeometryTransitionId(item, index as number) as string;
      }
    })
  }

  @Builder
  buildGridItem() {
    if (this.gridStartOffset !== 0) {
      this.buildPaddingInGridTop();
    }
    if (this.isShowDialog() && !this.isFromAlbum && !this.isGrantPage) {
      this.buildPickerWarningDialog();
    }
    if (this.isGrantPage && this.isNeedShowGrantPagePromptBox) {
      this.buildGrantPagePromptBox();
    }
    if (this.isSupportCamera()) {
      this.buildCameraGridItem();
    }
    if (this.isPickerUsedSubwindow) {
      this.buildPickerPhotoGridItem();
    } else {
      this.buildPhotoGridItem();
    }
    if (this.gridEndOffset > 0) {
      this.buildPaddingInGridBottom();
    }
    if (!this.selectParams.isFromPickerView && !this.selectParams.isMultiPick) {
      this.buildFooter();
    }
  }

  private handleScrollStart(): void {
    this.isShowScrollBar = this.isVisibleScrollBar;
    this.gridScrollVM.onScrollStart();
    this.searchController?.stopEditing();
    if (this.isSupportGridSlide) {
      this.dayGridSlideHelper?.handleScrollStart();
    }
  }

  private handleScrollStop(): void {
    if (this.isSupportGridSlide) {
      this.dayGridSlideHelper?.handleScrollStop();
    }
    if (this.isReachStart || this.isReachEnd) {
      this.isReachStart = false;
      this.countGridOffsetTop = 0;
      this.countGridOffsetBottom = 0;
    }
  }

  private handleAreaChange(oldValue: Area, newValue: Area): void {
    if (!this.isSlidingHorizontally) {
      this.gridAutoScrollerUtil.setScrollerHeight(assert.asDefault(newValue.height, 0, 'onAreaChange paramNull'));
      this.gridAutoScrollerUtil.setExtraAreaHeightByIsHorizontal(this.isHorizontal,
        this.calcScrollBarPaddingTop(), 0, true, true);
    } else {
      this.gridAutoScrollerUtil.setScrollerWidth(assert.asDefault(newValue.width, 0, 'onAreaChange paramNull'));
      this.gridAutoScrollerUtil.setExtraAreaWidth();
    }
  }

  private handleScrollIndex(index: number, last: number): void {
    this.firstIndex = index;
    this.lastIndex = last;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      FocusUtil.setFocusState(this.getUIContext()?.getFocusController(), index, last);
    }
    if (!this.isTouchScrollBar) {
      this.dayGridSlideHelper?.handleScrollIndex(index, last);
    }
    let scrollInfo: RegularGridScrollInfo = {
      imageGridItemHeight: this.gridItemWidth,
      gridRowCount: this.gridRowCount,
    };
    this.dayRegularGridDragScrollHelper?.recordScrollInfo(scrollInfo);
    this.dayRegularGridDragScrollHelper?.handleScrollIndex(index, last);
    this.prepareContextRecoverInfo(index, last);
  }

  private prepareContextRecoverInfo(index: number, last: number) {
    RecoverController.setRecoverLastGridIndex(last);
    if (this.selectParams.bundleName === Constants.SCENEBOARD_BUNDLE_NAME) {
      RecoverController.setRecoverFirstGridIndex(index);
    }
  }

  private handleWillScroll(offset: number, state: ScrollState, source: ScrollSource): ScrollResult {
    // 拖动滚动条离手后停止宫格滚动
    if (source === ScrollSource.SCROLL_BAR_FLING) {
      return { offsetRemain: 0 }
    }

    if (source == ScrollSource.SCROLL_BAR && this.dayRegularGridDragScrollHelper !== undefined) {
      // 滚动条滑动
      this.cachedCount = Constants.GRID_CACHE_ROW_COUNT_NONE;
      const scrollHelperOffset = this.dayRegularGridDragScrollHelper?.handleWillScroll(offset, source) ?? 0;
      this.gridScrollVM.onWillScroll(scrollHelperOffset, offset);
      return { offsetRemain: scrollHelperOffset };
    } else {
      // 抛滑
      this.initCachedCount();
      let scrollInfo: RegularGridScrollInfo = {
        imageGridItemHeight: this.gridItemWidth,
        gridRowCount: this.gridRowCount,
      };
      this.dayGridSlideHelper?.recordScrollInfo(scrollInfo);
      return { offsetRemain: this.dayGridSlideHelper?.handleWillScroll(offset, source) ?? offset };
    }
  }

  private getPickerAlbumGridTopMargin(): number | Resource {
    if (this.selectParams.isFromPickerView || this.isPickerUsedSubwindow) {
      return 0;
    }
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return this.isShowDialog() ?
      $r('app.float.picker_album_grid_margin_show_dialog') : $r('app.float.picker_album_grid_margin');
    }
    return this.convertMarginTop();
  }

  private convertMarginTop(): number {
    return px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_elements_margin_vertical_m')));
  }

  private convertPickerPanelHeight(): number {
    return px2vp(UiUtil.getResourceNumber($r('app.float.picker_panel_title_height')));
  }

  private convertFooterNavigationHeight(): number {
    return px2vp(UiUtil.getResourceNumber($r('app.float.navigation_margin_bottom')));
  }

  private convertSelectTipsColHeight(): number {
    return px2vp(UiUtil.getResourceNumber($r('app.float.picker_select_tips_col_height')));
  }

  private calcScrollBarPaddingTop(): number {
    return this.selectParams.isFromPickerView ? 0 :
      (this.showActionBar ? (Constants.ActionBarHeight + this.convertMarginTop() + this.convertMarginTop()) :
      this.convertMarginTop());
  }

  private calcScrollBarPaddingBottom(): number {
    return this.selectParams.isFromPickerView ? 0 :
      (this.selectParams?.isMultiPick ? (this.convertPickerPanelHeight() +
      this.convertFooterNavigationHeight()) + this.convertSelectTipsColHeight() :
      this.convertFooterNavigationHeight());
  }

  /**
   * 计算picker左右滑动时，滚动条的左右边距
   * 因滚动条按钮中心旋转90度后，两边会超出宫格边界，需要设定边距为：（宽度 - 高度） / 2
   *
   * @returns 滚动条的左右边距
   */
  private calcScrollBarHorizontallyPaddingWhenClicked(): number {
    return (px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_big_height'))) -
    px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_big_width')))) / 2;
  }

  private calcScrollBarHorizontallyPaddingNotClicked(): number {
    return (px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_small_height'))) -
    px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_small_width')))) / 2
  }

  private calcScrollBarMarkAnchorYWhenClicked(): number {
    return this.calcScrollBarPaddingBottom() + px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_big_width')));
  }

  private calcScrollBarMarkAnchorYNotClicked(): number {
    return this.calcScrollBarPaddingBottom() + px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_small_width')));
  }

  @Builder
  buildActionBar() {
    if (this.showActionBar) {
      ThirdSelectedPageActionBar({
        leftAction: Action.BACK,
        isSelectPhotoGrid: true,
        title: this.title,
        selectParams: this.selectParams,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isFirstEnter: this.isFirstEnter,
        totalSelectedCount: $selectedCount,
        isSearchEnabled: this.isSearchVisible,
        actionBarMarginTop: this.convertMarginTop(),
        moreMenuList: this.moreMenuList,
        pickerController: this.thirdSelectController,
      });
    }
  }

  @Builder
  buildPanel() {
    ThirdSelectedPanel({
      maxSelectCount: this.selectParams.maxSelectCount,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      mTransition: TAG,
      currentUri: this.currentUri,
      isShowBar: $isShowBar,
      totalSelectedCount: $selectedCount,
      totalCount: this.totalCount,
      dataSource: this.dataSource,
      needInit: false,
      panelId: this.panelId,
      isSetOriginal: this.isSetOriginal,
      isShowImage: this.isShowImage,
      pickerPanelHeight: this.convertPickerPanelHeight(),
      footerNavigationHeight: this.convertFooterNavigationHeight(),
      isOriginalSupported: this.isOriginalSupported,
      isImmersiveCompared: this.selectParams?.isImmersiveCompared,
      isCollagePageEnter: this.selectParams?.isCollagePageEnter,
      completeButtonText: this.completeButtonText,
      isVerdeFoldable: this.isVerdeFoldable,
      browserController: this.browserController,
      isMultiPick: this.selectParams?.isMultiPick ?? true,
    })
  }

  @Builder
  buildPickerPhotoGridItem() {
    LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
      ImageGridItemComponent({
        replaceUriManager: this.replaceUriManager,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        dataSource: this.dataSource,
        item: item,
        isSelected: this.selectManager?.isItemSelected((item?.mediaItem)?.uri as string, index) ?? false,
        pageName: TAG,
        isThird: true,
        mPosition: index,
        isThirdMultiPick: this.selectParams.isMultiPick,
        isShowSerialNum: this.selectParams.isShowSerialNum,
        geometryTransitionString: this.getGeometryTransitionId(item, index as number),
        selectedCount: $thirdSelectGirdCount,
        isSupportPrint: $isSupportPrint,
        gridItemWidth: this.gridItemWidth,
        selectManager: this.selectManager,
        isNeedTransition: this.isNeedTransition,
        gridRowCount: $gridRowCount,
        isFromPickerView: this.selectParams.isFromPickerView,
        drawnThumbnailCount: this.drawnThumbnailCount,
        checkBoxColor: this.selectParams.checkBoxColor,
        checkboxTextColor: this.selectParams.checkboxTextColor,
        isPreviewForSingleSelectionSupported: this.isPreviewForSingleSelectionSupported,
        isRepeatSelectSupported: this.selectParams.isRepeatSelectSupported,
        albumUri: this.selectParams.albumUri,
        isSelectedMode: this.isSelectedMode,
        themeColor: this.selectParams.customColor,
        isRefreshSelectState: $isRefreshSelectState,
        isPhotoInner: this.isPhotoInner,
      })
        .reuseId(UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_ALBUM,
          item, this.getGeometryTransitionId(item, index as number)))
    }, (item: ViewData, index?: number) => {
      if (item == undefined || item.mediaItem == undefined) {
        return JSON.stringify(item) + index;
      } else {
        return this.getGeometryTransitionId(item, index as number) as string;
      }
    })
  }

  @Builder
  buildPhotoGridItem() {
    LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
      PickerGridItemComponent({
        replaceUriManager: this.replaceUriManager,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        dataSource: this.dataSource,
        item: item,
        selectParams: $selectParams,
        isSelected: this.selectManager?.isItemSelected((item?.mediaItem)?.uri as string, index) ?? false,
        pageName: TAG,
        mPosition: index,
        geometryTransitionString: this.getGeometryTransitionId(item, index as number),
        selectedCount: $thirdSelectGirdCount,
        isSupportPrint: $isSupportPrint,
        gridItemWidth: this.gridItemWidth,
        selectManager: this.selectManager,
        isNeedTransition: this.isNeedTransition,
        gridRowCount: $gridRowCount,
        drawnThumbnailCount: this.drawnThumbnailCount,
        isPreviewForSingleSelectionSupported: this.isPreviewForSingleSelectionSupported,
        singleSelectionMode: this.singleSelectionMode,
        isSelectedMode: this.isSelectedMode,
        isRefreshSelectState: $isRefreshSelectState,
        isPhotoInner: this.isPhotoInner,
        isSingleLineMode: this.singleLineConfig !== undefined && this.singleLineConfig !== null,
        singleLineModeItemDisplayRatio: this.itemDisplayRatio,
        singleLineModeImageBorderRadius: this.imageBorderRadius,
        badgeType: this.badgeType,
        badgeConfigUrisSet: this.badgeConfigUrisSet,
        badgeConfigUpdate: this.badgeConfigUpdate,
        isScreenSliding: this.isScreenSliding
      })
        .visibility(this.hasScrolledToAnchor ? Visibility.Visible : Visibility.Hidden)
        .width(this.isSlidingHorizontally ? undefined : Constants.PERCENT_100)
        .height(this.isSlidingHorizontally ? Constants.PERCENT_100 : (this.singleSelectionMode ? undefined :
          Constants.PERCENT_100))
        .reuseId(UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_ALBUM,
          item, this.getGeometryTransitionId(item, index as number)))
        .aspectRatio(this.itemDisplayRatio !== ItemDisplayRatio.ORIGINAL_SIZE_RATIO ? 1 :
          ImageUtil.getSingleLineIrregularModeAspectRatio(item.mediaItem?.width, item.mediaItem?.height))
        .zIndex(index === this.placeholderIndex ? 1 : 0);
    }, (item: ViewData, index?: number) => {
      if (item == undefined || item.mediaItem == undefined) {
        return JSON.stringify(item) + index;
      } else {
        return this.getGeometryTransitionId(item, index as number) as string;
      }
    })
  }

  @Builder
  buildGridScrollBar() {
    ScrollBar({
      scroller: this.scroller as Scroller, direction: this.isSlidingHorizontally ? ScrollBarDirection.Horizontal :
      ScrollBarDirection.Vertical,
      state: BarState.Auto,
    }) {
      Row() {
        if (this.isClickScrollBar) {
          Image($r('app.media.scroll_press_light'))
            .draggable(false)
            .width($r('app.float.scroll_bar_big_width'))
            .height($r('app.float.scroll_bar_big_height'))
        } else {
          Image($r('app.media.scroll_light'))
            .draggable(false)
            .width($r('app.float.scroll_bar_small_width'))
            .height($r('app.float.scroll_bar_small_height'))
            .borderRadius(25)
        }
      }
      .rotate(this.isSlidingHorizontally ? {
        centerX: '50%',
        centerY: '50%',
        centerZ: 0,
        angle: '90deg'
      } : undefined)
      .padding({
        left: this.isSlidingHorizontally ? (this.isClickScrollBar ?
        this.calcScrollBarHorizontallyPaddingWhenClicked() : this.calcScrollBarHorizontallyPaddingNotClicked()) : 0,
        right: this.isSlidingHorizontally ? (this.isClickScrollBar ?
        this.calcScrollBarHorizontallyPaddingWhenClicked() : this.calcScrollBarHorizontallyPaddingNotClicked()) : 0,
      })
      .onTouch((event: TouchEvent): void => {
        this.isTouchScrollBar = true;
        if (event.type === TouchType.Move && !this.isClickScrollBar) {
          Log.debug(TAG, 'scrollBar first TouchType.Move');
          this.isClickScrollBar = true;

        } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
          Log.debug(TAG, `scrollBar TouchType.Up or Cancel. type=${event.type}`);
          this.isClickScrollBar = false;
          this.isTouchScrollBar = false;
          this.initCachedCount();
          this.dayRegularGridDragScrollHelper?.handleScrollStop();
        } else if (event.type === TouchType.Down) {
          Log.debug(TAG, 'scrollBar TouchType.Down');
          this.isClickScrollBar = true;
          this.dayRegularGridDragScrollHelper?.handleScrollStart();
        }
      })
    }
    .width(this.isSlidingHorizontally ? '100%' : (this.isClickScrollBar ? $r('app.float.scroll_bar_margin_small') :
    $r('app.float.scroll_bar_small_width')))
    .height(this.isSlidingHorizontally ? (this.isClickScrollBar ? $r('app.float.scroll_bar_big_width') :
    $r('app.float.scroll_bar_small_width')) : '100%')
    .accessibilityLevel('no-hide-descendants')
    .hitTestBehavior(HitTestMode.Transparent)
    .position(this.isSlidingHorizontally ? { x: 0, y: '100%' } : { x: '100%', y: 0 })
    .padding({ top: this.calcScrollBarPaddingTop(), bottom: this.calcScrollBarPaddingBottom() })
    .markAnchor({
      x: !this.isSlidingHorizontally ? (this.isClickScrollBar ? $r('app.float.scroll_bar_big_width') :
      $r('app.float.scroll_bar_small_width')) : 0,
      y: this.isSlidingHorizontally ? (this.isClickScrollBar ? this.calcScrollBarMarkAnchorYWhenClicked() :
      this.calcScrollBarMarkAnchorYNotClicked()) : 0,
    })
  }

  @Builder
  buildCameraGridItem() {
    GridItem() {
      CameraGridItemComponent({
        resultUri: '',
        selectParams: this.selectParams,
        broadCast: this.broadCast,
        thirdSelectController: this.thirdSelectController,
        updateDataFunc: (uri: string) => {
          Log.debug(TAG, `get camera callback, uri ${uri}`);
          this.dataSource?.initData();
          this.uriResult = uri;
          this.isFromCamera = true;
        }
      });
    }
    .key('CameraGridItem')
    .selectable(false)
    .onSelect((isSelected: boolean) => {
      // 阻止拍照按钮被选中
      return;
    })
    .borderRadius(this.singleLineConfig ? this.imageBorderRadius : 0)
    .aspectRatio(1)
    .visibility(this.hasScrolledToAnchor ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  buildPaddingInGridTop() {
    GridItem() {
      Column()
        .height(this.gridStartOffset)
        .width('100%')
        .backgroundColor($r('sys.color.ohos_id_color_panel_bg'))
        .key('GridOffsetStart')
    }
  }

  @Builder
  buildPaddingInGridBottom() {
    GridItem() {
      Column()
        .height(this.gridEndOffset)
        .width('100%')
        .backgroundColor($r('sys.color.ohos_id_color_panel_bg'))
        .key('GridOffsetEnd')
    }
  }

  @Builder
  buildFooter() {
    GridItem() {
      Column()
        .height(DeviceInfo.isPhoneUx() &&
          !DeviceInfo.isFoldable() ? px2vp(UiUtil.getResourceNumber($r('app.float.navigation_margin_bottom'))) : 0)
        .backgroundColor($r('sys.color.comp_background_list_card'))
    }
  }

  build() {
    if (this.isFromAlbum) {
      NavDestination() {
        this.buildGrid();
      }
      .title('ThirdSelectAlbumGridBase')
      .hideTitleBar(true)
      .backgroundColor($r('sys.color.ohos_id_color_panel_bg'))
      .visibility(this.isPageHidden)
      .onBackPressed((): boolean => {
        // 相册页宫格进大图若NavDestination可见，重写onBackPressed方法，触发退出大图动效
        if (this.browserController.isAnimating && this.browserController.isBrowserShow) {
          this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
          return true;
        }
        return false;
      })
    } else {
      /* instrument ignore next */
      this.buildGrid();
    }
  }

  private onUpdateLayoutOptions(size: number): void {
    if (this.selectParams.isFromPickerView || this.selectParams.isMultiPick ||
      !DeviceInfo.isPhoneUx() || DeviceInfo.isFoldable() || this.isGrantPage) {
      return;
    }
    let count: number = this.isSupportCamera() ? size + 1 : size;
    if (size > 0) {
      this.gridIrregularIndexData.showFooter(true, count);
    }
    this.gridIrregularIndexData.showSafeDialog(this.isShowDialog());
    this.layoutOptions.irregularIndexes = this.gridIrregularIndexData.getIrregularIndexes();
    Log.info(TAG, `onUpdateLayoutOptions:${size}`);
  }

  private getSingleLineModeDrawnThumbnailCount(scroller: Scroller, totalLen: number, containerWidth: number,
    containerHeight: number): number {
    let drawnThumbnailCount: number = 1;
    try {
      for (let idx = 0; idx < totalLen; idx++) {
        const rect = scroller.getItemRect(idx);
        if (this.isSlidingHorizontally && rect.x < containerWidth - 1 && rect.x + rect.width > containerWidth) {
          drawnThumbnailCount = idx + 1;
          break;
        }
        if (!this.isSlidingHorizontally && rect.y < containerHeight - 1 && rect.y + rect.height > containerHeight) {
          drawnThumbnailCount = idx + 1;
          break;
        }
      }
    } catch (e) {
      Log.error(TAG, `getSingleLineModeDrawnThumbnailCount error: ${e?.message}`);
    }
    return drawnThumbnailCount;
  }
}

@Extend(Grid)
function gridGapStyle(itemGap?: Length) {
  .columnsGap(typeof itemGap !== 'undefined' ? itemGap : Constants.GRID_GUTTER)
  .rowsGap(typeof itemGap !== 'undefined' ? itemGap : Constants.GRID_GUTTER)
}

class GridTemplateAttributeModifier implements AttributeModifier<GridAttribute> {
  public isSlidingHorizontally: boolean = true;
  public rowGridCount: number = 1;
  public colGridCount: number = 1;

  applyNormalAttribute(instance: GridAttribute): void {
    if (this.isSlidingHorizontally) {
      instance.rowsTemplate('1fr '.repeat(this.colGridCount))
    } else {
      instance.columnsTemplate('1fr '.repeat(this.rowGridCount))
    }
    let logMsg: string = `applyNormalAttribute done, isSlidingHorizontally = ${this.isSlidingHorizontally}, `;
    logMsg += `rowGridCount = ${this.rowGridCount}, colGridCount = ${this.colGridCount}`
    Log.info(TAG, logMsg);
  }
}