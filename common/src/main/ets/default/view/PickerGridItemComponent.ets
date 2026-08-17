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
import lazy { Action } from './browserOperation/Action';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy {
  getScreen,
  isOrientationHorizontal,
  DiggingHoleCameraArea
} from '../model/common/ScreenManager';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { MultimodalInputManager } from '../model/common/MultimodalInputManager';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil,
  PhotoInfo,
  BigDataMsg
} from '../utils/ReportToBigDataUtil';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { CommonUtil } from '../utils/CommonUtil';
import lazy { SelectManager } from '../model/browser/SelectManager';
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
import lazy { FocusCtrl } from '@ohos/tools/src/main/variables/FocusCtrl';
import lazy { AttributeUpdater } from '@ohos.arkui.modifier';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { CustomColors, LengthMetrics } from '@kit.ArkUI';
import lazy { ViewData } from '../model/browser/photo/ViewData';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { GridUIController } from '../utils/GridUIController';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { AssetHelper } from '../utils/AssetHelper';
import lazy { AccessibilityUtil } from '../utils/AccessibilityUtil';
import lazy { FocusUtil } from '../utils/FocusUtil';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { DownloadListener } from '../model/browser/DownloadListener';
import lazy { GridSize, ImageGridSizeUtil } from '../utils/ImageGridSizeUtil';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy { ReplaceUriManager } from '../model/ReplaceUriManager';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { MediaOperationType } from '../model/common/MediaOperationType';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { ItemDisplayRatio } from '../model/common/SelectParams';
import lazy { GridItemUtils } from '../utils/GridItemUtils';
import lazy { BadgeType } from '@ohos.file.PhotoPickerComponent';

/* instrument ignore file */
const TAG: string = 'pickerGridItemComponent';
const DRAG_PLACEHOLDER_ICON_SIZE: number = 24;
const OPEN_BROWSER_MOVING_PHOTO: number = 3;
const GRID_APPEAR_TIMEOUT: number = 2;
const GRID_REUSE_TIMEOUT: number = 2;
const COMPONENT_EMPTY_EFFECT_OPACITY = 0.99;
const GRID_MIN_SCALE = 0.001;
const BORDER_PADDING: number = DeviceInfo.isPcOrTablet() ? 10 : 8;
const COVER: string = 'Cover';
const DURATION_CLOUD_DOWNLOAD: number = 500;
const TIMEOUT_INIT_FOCUS: number = 300;

@Extend(SymbolGlyph)
function focusSetting(key: string, handleEvent: Function) {
  .focusable(true)
  .onKeyEvent((event: KeyEvent): void => {
    event && handleEvent((event));
  })
}

class GridItemModifier extends AttributeUpdater<GridItemAttribute> {
  applyNormalAttribute(instance: GridItemAttribute) {
    instance.transition(TransitionEffect.IDENTITY);
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

interface Msg {
  from: string;
  enterPosition: number;
  mediaType: number;
}

// General grid picture control
@Reusable
@Component
export struct PickerGridItemComponent {
  private replaceUriManager: ReplaceUriManager | undefined;
  @ObjectLink @Watch('onViewDataChanged') item: ViewData;
  @Link selectParams: SelectParams;
  @State gridUiController: GridUIController = new GridUIController();
  private rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private mediaItem: MediaItem | undefined;
  private simpleMediaItem?: SimpleGridMediaItem;
  @Link @Watch('onModeChange') isSelectedMode: boolean;
  @State isSelected: boolean = false;
  @Consume broadCast: BroadCast;
  @Consume @Watch('onShow') isShow: boolean;
  @State quality: number = Constants.DEFAULT_ITEM_OPACITY;
  @Link @Watch('onSelectedCountChange') selectedCount: number;
  @LocalStorageLink('isImageFull') @Watch('onItemFullChange') isImageFull: boolean = false;
  @LocalStorageLink('isVideoFull') @Watch('onItemFullChange') isVideoFull: boolean = false;
  loaded = false;
  pageName = '';
  @State isLoadImageError: boolean = false;
  @Consume longPressMenuList: Action[];
  onMenuClicked: Function = (): void => {
  };
  private geometryTransitionString: string = '';
  private imageThumbnail: string = '';
  @State isEditImage: boolean = false;
  @State editImageUri: string = '';
  private transitionId: string = '';
  private mediaType: number = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
  @State isVideoMediaType: boolean = false;
  @State videoDuration: number = 0;
  private isEnteringPhoto = false;
  private isPhotoInner: boolean = true;
  @Prop isBlockTransition: boolean = false;
  isPreviewForSingleSelectionSupported: boolean = true;
  singleSelectionMode: number = SingleSelectionMode.BROWSER_MODE;
  @State repeatPickTimes: number = 0; //单张图可被多次选择的次数
  // allSelected state variable for gridView
  @State private dataSource: MediaDataSource | null = null;
  private onSelectUpdateFun: Function = (): void => this.onSelectUpdate();
  private updateSelectedFun: Function = (selected: boolean, uri: string):
    void => this.updateSelectedStatus(selected, uri);
  private updateDownloadStateFun: Function = (uri: string): void => this.updateDownloadState(uri);
  private updateRepeatPickFun: Function = (selectUris: string[]): void => this.updateRepeatPickTime(selectUris);
  private focusKey: string = '_GridItem';
  @Link isSupportPrint: boolean;
  @State thumbnailWidth: string | undefined = Constants.PERCENT_100;
  @State thumbnailHeight: string | undefined = Constants.PERCENT_100;
  private ratio: number = 0;
  thumbnailSize: Size | null = null;
  @Link @Watch('resizeGridThumbnail') gridItemWidth: number;
  // singleLineModeGridItemWidth与singleLineModeGridItemHeight 仅picker单行不规则布局用 控制点击热区
  @State singleLineModeGridItemWidth: number = 1;
  @State singleLineModeGridItemHeight: number = 1;
  @State selectedItemIndex: number = Constants.INVALID;
  selectManager: SelectManager | undefined = undefined;
  private focusNodeKey: string = '';
  private dragNodeKey: string = '';
  private mPosition: number = 0;
  private groupCountBefore: number = 0;
  @State isEffective: boolean = true;
  @Link @Watch('isNeedTransitionListener') isNeedTransition: boolean;
  private drawnThumbnailCount: number = -1;
  private readonly onClickHelper: EventHelper<KeyEvent | GestureEvent> = new EventHelper<KeyEvent | GestureEvent>();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Link gridRowCount: number;
  @State previewThumbnailUri: string = '';
  private gridItemModifier: GridItemModifier = new GridItemModifier();
  private imageModifier: ImageModifier = new ImageModifier();
  private stackModifier: StackModifier = new StackModifier();
  private textModifier: TextModifier = new TextModifier();
  private rowModifier: RowModifier = new RowModifier();
  @Link @Watch('onSelectStateChange') private isRefreshSelectState: boolean;
  @State private isGifImage: boolean = false;
  // 判断接触屏幕的手指数是否等于1个
  private isOneFinger: boolean = true;
  private previewNotifyPhotoFun: Function = (selectedUri: string, photoBrowserRange: number):
    void => this.previewNotifyPhoto(selectedUri, photoBrowserRange);
  @State isSecondClick: boolean = false;
  @State private isLocalImage: boolean = false;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') private networkAvailable: boolean = false;
  @State private isDownloading: boolean = false;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  // 是否开启触摸浏览功能
  @StorageLink('touchGuideState') private touchGuideState: boolean = false;
  private imageItemWidth: Length | undefined = 0;
  private imageItemHeight: Length | undefined = 0;
  private borderRowModifier: RowModifier = new RowModifier();
  private isFromPortrait: boolean = false;
  private useGridTrace: boolean = GridItemUtils.useGridTrace();
  private useGridReport: boolean = GridItemUtils.useGridReport();
  private traceStartTime: number = 0;
  private lastDisableDragMouseDownTime: number = 0;
  private hasInitFocus: boolean = false;
  @State private downloadProgress: number = 0;
  @LocalStorageLink('hasShowToast') private hasShowToast: boolean = false
  private downloadListener: DownloadListener = {
    onDownloadFinished: (uri: string): void => this.onDownloadFinishedFunc(uri),
    onDownloadProgressChanged: (uri: string, progress: number): void =>
    this.onDownloadProgressChangedFunc(uri, progress),
    onDownloadStoped: (uri: string): void => this.onDownloadStopedFunc(uri),
    onDownloadFailed: (uri: string, err: string): void => this.onDownloadFailedFunc(uri, err),
  } as DownloadListener;
  @StorageLink('currentLanguage') currentLanguage: string | undefined = undefined;
  // 框选状态
  private isBoxSelectionStatus: boolean = false;
  private browserDownloadToGridFun: Function = (uri: string) => this.browserDownloadToGrid(uri);
  @Prop disableAnimate: boolean = false;
  @Prop @Watch('closeContextMenu') isPrivateHideState: boolean = false;
  @State private imageBackgroundColor: ResourceColor = 'none';
  @State private isFromGalleryCleanupPage: boolean = false;
  private isSingleLineMode: boolean = false;
  private singleLineModeItemDisplayRatio: number = -1;
  private singleLineModeImageBorderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0;
  @Prop selectMediaType: number;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @Link badgeType: BadgeType;
  @Link badgeConfigUrisSet: Set<string>; // 需要配置特殊角标的uri
  @Link @Watch('updateBadgeConfigIcon') badgeConfigUpdate: boolean;
  public persistentId: number = 0;
  @StorageLink('chosenItemIndex') chosenItemIndex: number = 0;
  @State baseIconOpacity: number = 1;
  @State specialIconOpacity: number = 0;
  @Prop isScreenSliding: boolean;
  private specialIconDurationTtime: number = 200;

  private updateBadgeConfigIcon(): void { // 特殊角标动画
    Log.info(TAG, `updateBadgeConfigIcon-Start${this.badgeConfigUrisSet?.size}----${this.isScreenSliding}`);
    if (this.isEditImage && this.editImageUri !== '') {
      return; // 编辑优先级最高 不操作其他
    }
    // 存在滚动条 | 滑动 的情况下就不需要做动画
    if (this.badgeConfigUrisSet && this.badgeConfigUrisSet?.has(this.item?.mediaItem?.uri || '')) {
      this.getUIContext().animateTo({
        duration: this.isScreenSliding ? 0 : this.specialIconDurationTtime,
        curve: Curve.Linear,
        onFinish: (() => {
          this.getUIContext().animateTo({
            duration: this.isScreenSliding ? 0 : this.specialIconDurationTtime,
            curve: Curve.Linear,
          }, () => {
            this.specialIconOpacity = 1;
          });
        })
      }, () => {
        this.baseIconOpacity = 0;
      })
    } else if (this.specialIconOpacity === 1) { // 用于特殊角标删除时的动画
      this.getUIContext().animateTo({
        duration: this.isScreenSliding ? 0 : this.specialIconDurationTtime,
        curve: Curve.Linear,
        onFinish: (() => {
          this.getUIContext().animateTo({
            duration:  this.isScreenSliding ? 0 : this.specialIconDurationTtime,
            curve: Curve.Linear,
          }, () => {
            this.specialIconOpacity = 0;
          });
        })
      }, () => {
        this.baseIconOpacity = 1;
      });
    }
    Log.info(TAG, `endTime`);
  }

  @LocalStorageLink('isAnimating') isAnimating: boolean = false;

  private onSelectedCountChange(): void {
    if (this.lastDisableDragMouseDownTime) {
      this.lastDisableDragMouseDownTime = 0;
    }
    if (this.isFromGalleryCleanupPage && this.selectedCount === 0) {
      this.isSelected = false;
    }
  }

  private replaceUriFunc: Function = (oriUri: string, replaceUri: string): void => {
    if (this.mediaItem?.uri != oriUri || !this.mediaItem) {
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
    this.simpleMediaItem = this.item?.simpleMediaItem;
    // 收藏后更新
    if (this.gridUiController.isFavor !== tempItem.isFavor) {
      this.gridUiController.isFavor = tempItem.isFavor;
    }
    // 动态照片且为非关闭模式时更新
    if (this.gridUiController.isTurnedOnMovingPhoto !== tempItem.isTurnedOnMovingPhoto) {
      this.gridUiController.isTurnedOnMovingPhoto = tempItem.isTurnedOnMovingPhoto;
    }
    // 编辑后更新
    if (!this.selectParams.isFromPickerView || !this.isEditImage) {
      if (this.gridUiController.dateModified !==
      tempItem.dateModified || this.gridUiController.thumbnailReady !== tempItem.thumbnailReady) {
        this.gridUiController.dateModified = tempItem.dateModified;
        this.gridUiController.thumbnailReady = tempItem.thumbnailReady;
        this.imageThumbnail = tempItem.thumbnail ?? '';
        let userId = this.selectParams?.userId ?? -1;
        if (userId > 0) {
          this.imageThumbnail += `&user=${userId}`;
        }
        this.updateWidthHeight(tempItem);
        this.isEffective = Boolean(this.imageThumbnail);
        this.imageModifier?.updateConstructorParams(this.imageThumbnail);
      }
      TraceControllerUtils.finishTrace('GridItemOnViewDataChanged')
    }
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
    this.simpleMediaItem = this.item?.simpleMediaItem;
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
    this.initData(false);
    let id: string = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') as string;
    // 判断大图动效是否结束
    let isBrowserShow: boolean = LocalStorage.getShared()?.get<boolean>('isBrowserShow') as boolean;
    // 手机搜索页面，宫格进大图收藏，会触发GridItem重建，isTap会被错误赋值，先屏蔽。
    this.eventRegister();
    // 页面重新加载时，如果有选中的，需要主动获焦，延时为了保证组件渲染完毕
    setTimeout((): void => {
      this.hasInitFocus = true;
      this.refreshPickerFocus();
    }, TIMEOUT_INIT_FOCUS);
    Log.info(TAG, `aboutToAppear  isShowSerialNum=${this.selectParams.isShowSerialNum},  Position=${
    this.mPosition}, index = ${this.mediaItem?.index}, id = ${id}` +
      ` geometryTransitionString = ${this.geometryTransitionString}`);
    if (this.badgeConfigUrisSet && this.badgeConfigUrisSet?.size > 0) {
      this.updateBadgeConfigIcon();
    }
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
    this.mediaItem = this.item?.mediaItem;
    this.simpleMediaItem = this.item?.simpleMediaItem;
    this.mPosition = params.mPosition;
    this.downloadProgress = 0;
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
    if (params.isSelected !== this.isSelected) {
      this.isSelected = params.isSelected;
    }
    this.geometryTransitionString = params.geometryTransitionString;
    this.updateGeometryTransition(this.geometryTransitionString);
    if (this.isLoadImageError) {
      this.isLoadImageError = false;
    }
    this.initData(true);
    Log.debug(TAG, `ImageGridItem aboutToReuse transitionId: ${
    this.transitionId} geometryTransitionString:` + this.geometryTransitionString
      + ' this.imageThumbnail: ' + this.imageThumbnail);
    if (this.useGridTrace) {
      this.reuseTraceFunc();
    }
    if (this.badgeConfigUrisSet?.has(this.item?.mediaItem?.uri || '')) {
      this.specialIconOpacity = 1;
      this.baseIconOpacity = 0;
    } else {
      this.specialIconOpacity = 0;
      this.baseIconOpacity = 1;
    }
  }

  aboutToRecycle() {
    this.commonDestroyProcessor(true);
  }

  /**
   * Don't select the same status repeatedly
   */
  onSelectUpdate(): void {
    Log.info(TAG, `GridItem onSelectUpdate oldState: ${this.isSelected}`);
    this.updateIndex();
    if (this.selectManager && this.mediaItem?.uri) {
      this.isSelected = this.selectManager.isItemSelected(this.mediaItem?.uri, this.mPosition);
      Log.info(TAG, `GridItem onSelectUpdate nowState: ${this.isSelected}`);
    } else {
      this.isSelected = !this.isSelected;
      Log.error(TAG, `undefined err. selectManager:${this.selectManager}, uri:${this.mediaItem?.uri}`);
    }
    if (this.mediaItem) {
      this.mediaItem.mPosition = this.mPosition;
    }
  }

  // 公共数据初始化
  initData(isReuse: boolean): void {
    this.imageThumbnail = this.mediaItem?.thumbnail ?? '';
    let userId = this.selectParams.userId ?? -1;
    if (userId > 0) {
      this.imageThumbnail += `&user=${userId}`;
    }
    this.isEffective = Boolean(this.imageThumbnail);
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
    this.gridUiController.init(this.mediaItem);
    this.focusNodeKey = this.pageName + this.focusKey + this.mPosition;
    this.dragNodeKey = this.pageName + this.focusKey + this.imageThumbnail;

    this.imageModifier?.attribute?.key(this.dragNodeKey);
    this.stackModifier?.attribute?.key(this.focusNodeKey);
    this.transitionId = this.isSelected ? `${this.mediaItem?.hashCode}_${this.selectParams.albumUri}_${this.isSelected}`
      : `${this.mediaItem?.hashCode}_${this.selectParams.albumUri}`;
    this.gridItemModifier?.attribute?.dragPreview(this.dragNodeKey);
    this.broadCast.on(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA, this.onSelectUpdateFun);
    this.broadCast.on(Constants.UPDATE_SELECTED + this.mediaItem?.uri, this.updateSelectedFun);
    if (!isReuse) {
      this.broadCast.on(Constants.UPDATE_SELECTED, this.updateSelectedFun);
      this.broadCast.on(Constants.UPDATE_DOWNLOAD_STATE, this.updateDownloadStateFun);
      this.broadCast.on(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
      this.broadCast.on(BroadCastConstants.PREVIEW_NOTIFY_PHOTO, this.previewNotifyPhotoFun);
      this.broadCast.on(BroadCastConstants.BROWSER_DOWNLOAD_TO_GRID, this.browserDownloadToGridFun);
      this.broadCast.on(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    }

    this.initGridThumbnail();
    this.mediaType =
      this.mediaItem?.mediaType || (this.simpleMediaItem?.mediaType ?? UserFileManagerAccess.MEDIA_TYPE_IMAGE);
    this.isVideoMediaType = this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    this.videoDuration = this.mediaItem?.duration || (this.simpleMediaItem?.getDuration() ?? 0);
    this.isGifImage = this.mediaItem?.mimeType === Constants.MIME_TYPE_GIF;
    this.isLocalImage = this.checkIsLocal();
    if (!this.isLocalImage && this.item.mediaItem?.uri && !this.isPhotoInner) {

    }
    this.isDownloading = false;
    if (this.isVideoMediaType && this.textModifier.attribute) {
      let durationStr: string = DateUtil.getFormattedDuration(this.videoDuration);
      if (durationStr === '00:00') {
        this.textModifier.updateConstructorParams('');
      } else {
        this.textModifier.updateConstructorParams(durationStr);
      }
    }
    this.updateSelectedItemIndex();
    this.selectManager?.updateMediaItemFullState();
    if (this.selectParams?.isRepeatSelectSupported) {
      let selectedUris = this.selectManager?.isPickerIndexSet ?
        this.selectManager?.getSelectedUrisWithPickerIndex() : this.selectManager?.getSelectUris();
      this.updateRepeatPickTime(selectedUris ?? []);
    }
    this.onItemFullChange();
  }

  private checkIsLocal(): boolean {
    let position: number | undefined = this.simpleMediaItem?.getPosition() ?? this.mediaItem?.getPosition();
    return position !== 2;
    // return false
  }

  private updateSelectedItemIndex(): void {
    const pickerIndex = this.selectManager?.selectParam?.pickerIndex ?? Constants.INVALID;
    if (this.isSelected && this.selectParams.isShowSerialNum && this.mediaItem?.uri) {
      const preselectItemsLength = this.selectManager?.totalSelectedItemUriWithPickerIndex.length ?? 0;
      if (this.selectParams.isFromPickerView) {
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
    Log.info(TAG, `ImageGridItem aboutToDisappear, index=${this.mPosition}`);
    this.commonDestroyProcessor(false);
    if (this.item?.mediaItem?.uri && !this.isPhotoInner && !this.isDownloading) {
      Log.info(TAG, 'ImageGridItem aboutToDisappear download' + this.item?.mediaItem?.uri);
    }
  }

  commonDestroyProcessor(isRecycle?: boolean): void {
    this.geometryTransitionString = '';
    this.dataSource?.releaseViewDataCache(this.mediaItem);
    if (!this.isEffective) {
      return;
    }
    this.resetPressAnim();
    if (this.mediaItem != null) {
      this.broadCast.off(this.mediaItem?.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA, this.onSelectUpdateFun);
    }
    this.broadCast.off(Constants.UPDATE_SELECTED + this.mediaItem?.uri, this.updateSelectedFun);
    if (!isRecycle) {
      this.broadCast.off(Constants.UPDATE_SELECTED, this.updateSelectedFun);
      this.broadCast.off(Constants.UPDATE_DOWNLOAD_STATE, this.updateDownloadStateFun);
      this.broadCast.off(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
      this.broadCast.off(BroadCastConstants.PREVIEW_NOTIFY_PHOTO, this.previewNotifyPhotoFun);
      this.broadCast.off(BroadCastConstants.BROWSER_DOWNLOAD_TO_GRID, this.browserDownloadToGridFun);
      this.broadCast.off(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    }
  }

  updateSelectedStatus(selected: boolean, uri: string): void {
    if (this.mediaItem != null && this.mediaItem?.uri === uri) {
      this.isSelected = selected;
    }
    this.updateSelectedItemIndex();
  }

  private updateDownloadState(uri: string): void {
    if (this.mediaItem?.uri === uri && !this.isLocalImage && !this.isPhotoInner) {
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
    Log.info(TAG, `selectedMode: ${this.isSelectedMode}, index=${this.mPosition}`);
    if (!this.isSelectedMode || DeviceInfo.isPc()) {
      this.isSelected = false;
    }
  }

  async routePage(isError: boolean): Promise<void> {
    Log.info(TAG, `routePage ${isError}`);
    try {
      TraceControllerUtils.startTrace('enterPhotoBrowser');
      this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
    } catch (err) {
      let error = err as Error;
      Log.error(TAG, `fail callback, name: ${error.name}, msg: ${error.message}`);
    }
  }

  updateIndex(): void {
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
      Log.info(TAG, `[GeometryLogger] routeToPreviewPage uri=${this.mediaItem?.uri}, uniqueID ${
        this.mediaItem?.uniqueId}, index=${this.mPosition}`);
      this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
        [true, this.pageName, this.mediaItem, this.mPosition, this.geometryTransitionString]);
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
    // picker使用shift多选中有未下载云图时，不选中并开始下载
    if (this.selectManager.needCheckCloudImage && !this.isBoxSelectionStatus) {
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
    if (DeviceInfo.isPc() && this.dragNodeKey && this.isSelected && !this.selectParams.isFromPickerView) {
      FocusUtil.requestFocus(this.getUIContext()?.getFocusController(), this.dragNodeKey);
    }
  }

  selectStateChange(isRefreshSelectState: boolean = true, isFocusSelect: boolean = false): void {
    Log.info(TAG, 'change selected.');
    let newState = (this.selectParams.isRepeatSelectSupported || isFocusSelect) ? true : !this.isSelected;
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
          this.isSelected = isSelected ?? newState;
          // 点击选中后可以enter or space打开大图
          if (!isFocusSelect && isRefreshSelectState) {
            this.requestFocusImage();
          }
        }, isRefreshSelectState]);
    }
  }

  @Builder
  EmptyBuilder() {
  }

  // 获取图片或视频的无障碍播报内容
  private getImageItemGridAccessibilityText(): string {
    let text: string = '';
    if (this.isSelectedMode && !this.isSelected) {
      text = this.rsc.toString($r('app.string.deselected'));
    }
    if (this.gridUiController.isFavor) {
      text = `${text} ${this.rsc.toString($r('app.string.favorited'))}`
    }
    let index = this.dataSource?.getDataIndex(this.mediaItem) ?? this.mPosition;

    if (this.mediaItem?.data) {
      let dateNumber = Number(AssetHelper.get(this.mediaItem.data,
        photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
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
    .draggable(false)
    .accessibilityText(this.touchGuideState ? this.getImageItemGridAccessibilityText() : '')
  }

  build() {
    GridItem() {
      Column() {
        this.buildImageGrid();
      }
      .key(`ImageGridItem_Column_${this.mPosition.toString()}`)
      .imageGridAttrs()
      .stackTouchStyle()
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
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
      this.ratio = thumbnailWidth / thumbnailHeight;
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
    let msg: Record<string, string | photoAccessHelper.PositionType | undefined> = {
      'imagePosition': this.mediaItem?.getPosition?.(),
      'error': event.message,
    };
    ReportToBigDataUtil.errEventReport(BigDataConstants.GRID_CACHEDIMAGE_LOAD_ERROR, msg);
    this.isLoadImageError = true;
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    Log.error(TAG, `thumbnail load error, index=${this.mPosition}, imagePosition: ${this.mediaItem?.getPosition?.()}`);
  }

  private isNeedTransitionListener(): void {
    if (this.isNeedTransition) {
      this.gridItemModifier?.attribute?.transition(
        TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({
            curve: Curve.Sharp,
            duration: Constants.GRID_ADD_OPACITY_DURATION,
            delay: Constants.GRID_ADD_TRANSITION_DURATION,
          }).combine(
            TransitionEffect.scale({ x: Constants.GRID_SCALE_VALUE, y: Constants.GRID_SCALE_VALUE })
              .animation({
                curve: Curve.Friction,
                duration: Constants.GRID_ADD_SCALE_DURATION,
                delay: Constants.GRID_ADD_TRANSITION_DURATION,
              })
          ),
          TransitionEffect.OPACITY.animation({
            curve: Curve.Sharp,
            duration: Constants.GRID_DEL_OPACITY_DURATION,
          }).combine(
            TransitionEffect.scale({ x: Constants.GRID_SCALE_VALUE, y: Constants.GRID_SCALE_VALUE })
              .animation({
                curve: Curve.Friction,
                duration: Constants.GRID_DEL_SCALE_DURATION,
              })
          )
        )
      )
    } else {
      this.gridItemModifier?.attribute?.transition(TransitionEffect.IDENTITY);
    }
  }

  private getActualImage(): string {
    if (this.isEditImage && this.editImageUri !== '') {
      return this.editImageUri;
    }
    return this.imageThumbnail;
  }

  private getBorderColor(): Resource | Color {
    /* instrument ignore next */
    return Color.Transparent;
  }

  private getBorderWidth(): Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return $r('app.float.image_grid_item_border_width_pc');
    }
    return $r('app.float.image_grid_item_default_border_width');
  }

  private getImageBackgroundColor(): void {
    if (!DeviceInfo.isSupportOpenPNGBrowserBackGroundEnabled()) {
      return;
    }
    if (!this.mediaItem?.uri ||
      this.mediaItem?.uri.split('.')[this.mediaItem?.uri.split('.').length - 1].toUpperCase() !== 'PNG') {
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

  @Styles
  focusBorderStyle(){
    .border({
      color: this.getBorderColor(),
      width: this.getBorderWidth(),
    })
  }

  @Builder
  buildCachedImage() {
    MediaCachedImage(this.getActualImage())
      .sourceSize(this.isEditImage && this.editImageUri !== '' ? undefined : {
        width: px2vp(Constants.GRID_IMAGE_SIZE),
        height: px2vp(Constants.GRID_IMAGE_SIZE),
      })
      .draggable(false)
      .backgroundColor(this.imageBackgroundColor)
      .opacity(this.quality)
      .width(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailWidth : Constants.PERCENT_100)
      .height(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailHeight : Constants.PERCENT_100)
      .aspectRatio(this.isSingleLineMode ? undefined : this.ratio)
      .borderRadius(this.isSingleLineMode ? this.singleLineModeImageBorderRadius : 0)
      .objectFit(this.singleLineModeItemDisplayRatio !== ItemDisplayRatio.ORIGINAL_SIZE_RATIO ?
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
            `, index=${this.mPosition}, imagePosition: ${this.mediaItem?.getPosition?.()}`);
          if (this.mPosition === 0) {
            this.broadCast?.emit(BroadCastConstants.PHOTO_PICKER_ONSHOW_CAMERA, [])
          }
        }
        this.startHidePreview();
      })
      .zIndex(0)
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
    Text(DateUtil.getFormattedDuration(this.videoDuration))
      .draggable(false)
      .fontSize(DeviceInfo.isPc() ? $r('app.float.image_icon_text_line_height') :
        $r('app.float.multiple_pick_normal_font_size'))
      .maxFontScale(2.0)
      .fontFamily($r('app.string.id_text_font_family_regular'))
      .fontColor(DeviceInfo.isPc() ?
        $r('sys.color.ohos_id_color_text_primary_dark') : $r('app.color.text_color_above_picture'))
      .lineHeight(DeviceInfo.isPc() ?
        $r('app.float.image_icon_text_line_height_pc') : $r('app.float.image_icon_text_line_height'))
      .margin({
        top: $r('app.float.grid_item_text_margin_top'),
        right: $r('app.float.grid_item_text_margin_right'),
        bottom: DeviceInfo.isPc() ?
          $r('app.float.grid_item_text_margin_bottom_pc') : $r('app.float.grid_item_text_margin_bottom'),
        left: $r('app.float.grid_item_text_margin_lr'),
      })
      .attributeModifier(this.textModifier)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines((1))
      .opacity(this.baseIconOpacity)
  }

  @Builder
  private buildLeftDownIconForSpecial(iconResource: Resource) {
    RelativeContainer() {
      Image( UiUtil.isMirrorMode() ? $r('app.media.gif_right_mask_layer') : $r('app.media.gif_mask_layer'))
        .draggable(false)
        .height($r('app.float.image_grid_item_gif_mask_layer_height'))
        .width($r('app.float.image_grid_item_gif_mask_layer_width'))
        .onError((error: ImageError): void => {
          Log.error(TAG, `Gif mask layer image load error, error=${error}`);
        })
        .alignRules({
          'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })

      Image($r('app.media.ic_uploaded_white'))
        .draggable(false)
        .height($r('app.float.image_grid_item_gif_icon_size'))
        .width($r('app.float.image_grid_item_gif_icon_size'))
        .shadow({
          radius: $r('app.float.image_grid_item_gif_icon_shadow_radius'),
          color: $r('app.color.ohos_id_color_outer_default_sm'),
          offsetX: $r('app.float.image_grid_item_gif_icon_shadow_offset_x'),
          offsetY: $r('app.float.image_grid_item_gif_icon_shadow_offset_y'),
          fill: true,
        })
        .margin({
          left: ($r('app.float.id_icon_margin_horizontal')),
          right: ($r('app.float.id_icon_margin_horizontal')),
          bottom: ($r('app.float.id_icon_margin_horizontal')),
        })
        .alignRules({
          'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })
    }
    .width(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailWidth : Constants.PERCENT_100)
    .height(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailHeight : Constants.PERCENT_100)
    .aspectRatio(DeviceInfo.isPc() && !this.isSingleLineMode ? this.ratio : Constants.INVALID)
    .hitTestBehavior(HitTestMode.Transparent)
    .opacity(this.specialIconOpacity)
  }

  @Builder
  buildPCTimeDaysIcon() {
    Row() {
      Column() {
        this.buildVideoDuration();
      }
      .backgroundColor($r('sys.color.mask_tertiary'))
      .border({
        radius: { topRight: $r('app.float.time_shadow_radius') }
      })
    }
    .width(this.isSingleLineMode ? '100%' : this.thumbnailWidth)
    .height(this.isSingleLineMode ? '100%' : this.thumbnailHeight)
    .aspectRatio(this.isSingleLineMode ? undefined : this.ratio)
    .alignItems(VerticalAlign.Bottom)
    .attributeModifier(this.rowModifier)
  }

  @Builder
  buildOtherTimeDaysIcon() {
    Row() {
      this.buildVideoDuration();
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
        // 如果选中且需要显示序号，则显示序号
        if (this.isSelected && this.selectParams.isShowSerialNum && this.selectedItemIndex > Constants.INVALID) {
          Text(`${this.selectedItemIndex + 1}`)
            .fontColor((this.selectParams.isFromPickerView && this.selectParams.checkboxTextColor != '')
              ? this.selectParams.checkboxTextColor : $r('app.color.white'))
            .fontSize($r('app.float.multiple_pick_normal_font_size'))
        }
      }
      .height($r('app.float.checkbox_base_size'))
      .width($r('app.float.checkbox_base_size'))
      .border({
        color: $r('app.color.white'),
        width: this.isSelected ?
          $r('app.float.checkbox_selected_border_width') : $r('app.float.checkbox_unselected_border_width'),
        radius: $r('app.float.checkbox_border_radius'),
      })
      .backgroundColor(this.isSelected && this.selectParams.isShowSerialNum && this.selectedItemIndex > Constants.INVALID ?
        ((this.selectParams.isFromPickerView && this.selectParams.checkBoxColor != '')
          ? this.selectParams.checkBoxColor
          : $r('sys.color.comp_background_emphasize')) : Color.Transparent)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .accessibilityDescription(this.isSelected ? this.rsc.toString($r('app.string.checkbox_selected'))
        : this.rsc.toString($r('app.string.checkbox_deselected')))
      .onClick((): void => {
        this.selectStateChange();
        if (this.isOpenTouchGuide) {
          AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected
            ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
        }
      })
      .enabled(!this.isAnimating)
      .rightDownResponseRegion()
    }
    .stylesPosition()
  }

  @Builder
  buildLoadingPanel() {
    Stack() {
      Image($r('app.media.shadow'))
        .width($r('app.float.loading_progress_photo_shadow'))
        .height($r('app.float.loading_progress_photo_shadow'))

      Progress({ value: 0, total: 100, type: ProgressType.Ring })
        .value(this.downloadProgress)
        .color(this.selectParams.customColor?.backgroundEmphasize ?? $r('sys.color.white'))
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
    .rightDownResponseRegion()
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
    .accessibilityText($r('app.string.download_photo'))
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick((): void => {
      this.onClickCloudDownIcon();
    })
    .rightDownResponseRegion()
    .stylesPosition();
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
    .onClick((): void => {
      this.selectStateChange()
    })
    .rightDownResponseRegion()
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
        $r('app.float.grid_item_checkbox_markAnchor'),
      y: $r('app.float.grid_item_checkbox_markAnchor'),
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
    }
    .focusable(false)
    .width(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailWidth : Constants.PERCENT_100)
    .height(DeviceInfo.isPc() && !this.isSingleLineMode ? this.thumbnailHeight : Constants.PERCENT_100)
    .aspectRatio(DeviceInfo.isPc() && !this.isSingleLineMode ? this.ratio : Constants.INVALID)
  }

  @Builder
  buildIcon() {
    // 根据需要，加载蒙层
    this.buildMaskLayer();
    /* instrument ignore next */
    if (this.gridUiController.isFavor) {
      this.buildFavorIcon();
    }
    // 左下角icon 优先级 wxEdit > special > gif = movingPhoto = duration，互斥
    if (this.isEditImage && this.editImageUri !== '') { // 微信编辑
      this.buildEditorImage();
    } else if (this.badgeType !== undefined &&
      this.badgeType === BadgeType.BADGE_UPLOADED &&
      this.specialIconOpacity === 1) { // 特殊角标：上传
      this.buildLeftDownIconForSpecial($r('app.media.ic_uploaded_white'));
    } else if (this.isVideoMediaType && this.baseIconOpacity === 1) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.buildPCTimeDaysIcon();
      } else {
        this.buildOtherTimeDaysIcon();
      }
    }
    this.buildPickerIcon();
  }

  @Builder
  buildPickerIcon() {
    if (this.isDownloading && !this.isPhotoInner) {
      this.buildLoadingPanel();
    } else if ((this.isSelectedMode || this.selectParams.isMultiPick) &&
      // 单选 + 不预览 时隐藏右下角多选框
      !(this.singleSelectionMode === SingleSelectionMode.SELECT_MODE &&
        !this.isPreviewForSingleSelectionSupported)) {
      // 多选模式 / 选择模式下显示checkbox（包括云图片和本地图片）
      this.buildCheckBox();
    } else if (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      // 混合模式始终显示多选框
      this.buildCheckBox();
    } else if (!this.isLocalImage && !this.isDownloading && !this.isPhotoInner) {
      // 非多选模式下，云图片显示云下载图标
      this.buildCloudDownIcon();
    }
  }

  @Builder
  buildCheckBox() {
    if (this.selectParams.isRepeatSelectSupported && this.repeatPickTimes > 1) {
      this.buildRepeatHint() //单张图片多选右上角增加提示框
    } else if (this.selectParams.isShowSerialNum &&
      this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.buildPickerCheckbox();
    } else if (this.isSelected && this.selectParams.isShowSerialNum && this.selectedItemIndex > Constants.INVALID &&
      !this.selectParams.isRepeatSelectSupported) {
      Column() {
        Text(`${this.selectedItemIndex + 1}`)
          .fontColor((this.selectParams.isFromPickerView && this.selectParams.checkboxTextColor != '')
            ? this.selectParams.checkboxTextColor : $r('app.color.white'))
          .fontSize($r('app.float.multiple_pick_normal_font_size'))
      }
      .height($r('app.float.checkbox_base_size'))
      .width($r('app.float.checkbox_base_size'))
      .backgroundColor((this.selectParams.isFromPickerView && this.selectParams.checkBoxColor != '')
        ? this.selectParams.checkBoxColor
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
      .rightDownResponseRegion()
      .stylesPosition()
    } else {
      // 多选模式下始终显示checkbox
      this.buildPickerCheckbox();
    }
  }

  @Styles
  private rightDownResponseRegion() {
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

  /**
   * 当三方拉起 picker 时, 多选模式/单选混合模式 显示蒙层
   */
  @Builder
  buildMaskLayer() {
    if (this.isSelected &&
      (this.isSelectedMode || this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE)) {
      // 如果是最近删除要显示图片下的文字，则蒙层要再加高一行字的高度
      // 其他按原来正常高度显示蒙层
      Column()
        .height('100%')
        .width('100%')
        .backgroundColor($r('app.color.item_selection_bg_color'))
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

  @Styles
  stickGridItemAttrs() {
    .aspectRatio(1) // 当缩略图下显示文字时，aspectRatio需要不指定才能适配高度
    .height(this.gridItemWidth) // 当缩略图下显示文字时，aspectRatio不指定，需要指定height（指定aspectRatio时，height属性自动失效）
    .attributeModifier(this.gridItemModifier)
    .draggable(false)
    .focusBox({
      strokeWidth: LengthMetrics.px(0),
    })
  }

  private handleTouchEvent(event: TouchEvent): void {
    this.isOneFinger = event?.touches?.length === 1;

    if (event.type !== TouchType.Move) {
      Log.i(TAG, `onTouch trigger touchTpe: ${event.type}, isSelectedMode: ${this.isSelectedMode}, ` +
        `isEnteringPhoto: ${this.isEnteringPhoto}, isSelected:${this.isSelected}`);
    }
    if (event.type === TouchType.Down) {
      this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
    }
  }

  private shouldProcessClick(event: GestureEvent): boolean {
    let isMouseOrTouchscreen = event.source === SourceType.Mouse || event.source === SourceType.TouchScreen;
    return !DeviceInfo.isPc() || (DeviceInfo.isPc() && event.source === SourceType.TouchScreen && !this.isSelectedMode)
      || isMouseOrTouchscreen;
  }

  @Styles
  stackTouchStyle() {
    .onTouch((event: TouchEvent): void => {
      this.handleTouchEvent(event);
    })
    // 走焦消费Enter & 空格
    .onKeyEvent((event?: KeyEvent) => {
      if (!event) {
        return;
      }
      if (event.type !== KeyType.Down) {
        return;
      }
      let storage = LocalStorage.GetShared();
      if (this.isSelectedMode && event.keyCode === KeyCode.KEYCODE_ENTER &&
        !storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) && !this.selectParams.isFromPickerView) {
        Log.info(TAG, 'onKeyEvent press enter. ');
        this.onMenuClicked?.(Action.OK);
        return;
      }
      if (event.keyCode === KeyCode.KEYCODE_ENTER || event.keyCode === KeyCode.KEYCODE_SPACE) {
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
        if (!DeviceInfo.isPc()) {
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
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          LocalStorage.getShared()?.setOrCreate<boolean>('isKeyEvent', false);
          this.getUIContext().getFocusController().clearFocus();
        }
        if (!this.isOneFinger) {
          Log.info(TAG, `ignore image tap gesture, isOneFinger:${this.isOneFinger}`);
          return;
        }
        if (this.isSingleLineMode) {
          Log.info(TAG, `ignore image tap gesture, isThird and single line`);
          return;
        }
      // 单选 + 不预览：点击缩略图直接选中并返回，不进入大图
      if (this.singleSelectionMode === SingleSelectionMode.SELECT_MODE &&
        !this.isPreviewForSingleSelectionSupported) {
        if (this.isPreviewForSingleSelectionSupportedCheck()) {
          return;
        }
      }
        if (this.shouldProcessClick(event)) {
          // picker 单选模式支持混合选择设置
          Log.info(TAG, `singleSelectionMode: ${this.singleSelectionMode}`);
          if (!this.selectParams.isMultiPick && this.singleSelectionMode === SingleSelectionMode.SELECT_MODE) {
            this.isPreviewForSingleSelectionSupported = false;
          } else if (!this.selectParams.isMultiPick &&
            this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
            this.isPreviewForSingleSelectionSupported = true;
          }
          if (this.singleSelectionMode === SingleSelectionMode.BROWSER_MODE &&
            this.selectParams.bundleName === Constants.SCENEBOARD_BUNDLE_NAME) {
            this.chosenItemIndex = this.mPosition;
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
        FocusCtrl.focusItemKey = this.dragNodeKey;
        FocusCtrl.focusItemUri = this.item?.mediaItem?.uri || '';

        if (event.sourceTool !== 0) {
          this.selectStateChange();
        }
      }),
    ))
  }

  isLoadImageErrorCheck(isLoadImageError: boolean): boolean {
    if (isLoadImageError) {
      Log.error(TAG, 'isLoadImageError');
      return true;
    }
    return false;
  }

  @Builder
  buildImageGrid() {
    if (this.isEffective) {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          this.buildNormal();
        }
        .height('100%')
        .width('100%')
        .borderRadius(this.isSingleLineMode ? this.singleLineModeImageBorderRadius : 0)
        .key(this.focusNodeKey)
        .clip(!DeviceInfo.isPc()) // 最近删除-图片下显示文字时，这里必须为false
        .attributeModifier(this.stackModifier)
      }
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY),
        TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY)))
      .id('imageGridItem')
      .stackTouchStyle()
      .accessibilityLevel('no')
    }
  }

  @Builder
  buildNormal() {
    // 缩略图
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
      }
      .width(this.isSingleLineMode ? '100%' : this.getWidth())
      .height(this.isSingleLineMode ? '100%' : this.getHeight())
      .focusBorderStyle()
      .hitTestBehavior(HitTestMode.Transparent)
      .attributeModifier(this.borderRowModifier)
    }
    if (this.isLoadImageErrorCheck(this.isLoadImageError)) {
      // 加载失败替代图片
      this.buildErrorImage();
    } else {
      // 加载各种情况的宫格缩略图
      this.buildCachedImage();
    }
    this.buildIcon();

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

  private openPhotoBrowser(): void {
    LocalStorage.getShared()?.setOrCreate<boolean>('isOpenBrowser', true);
    this.getImageBackgroundColor();
    if (this.isSelectedMode || this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.routeToPreviewPage();
    } else {
      this.jumperToPhotoBrowser();
    }
    // 进入新页面，默认聚焦左上角返回按钮
    if (this.isOpenTouchGuide) {
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_BACK_THIRD);
    }
  }

  private jumperToPhotoBrowser(): void {
    FocusCtrl.focusItemKey = this.dragNodeKey;
    FocusCtrl.focusItemUri = this.item?.mediaItem?.uri || '';
    this.updateIndex();
    if (this.isPreviewForSingleSelectionSupportedCheck()) {
      return;
    }
    Log.info(TAG, `[GeometryLogger] openPhotoBrowser uri=${this.imageThumbnail},\
    mPosition=${this.mPosition}, imagePosition=${this.mediaItem?.getPosition?.()}`);
    this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
      [true, this.pageName, this.mediaItem, this.mPosition, this.geometryTransitionString]);
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
      if (this.selectParams.isFromPickerView) {
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
    if (DeviceInfo.isPc()) {
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
      enterPosition: ReportToBigDataUtil.getEnterPhotoBrowserPosition(FocusCtrl.tabIndex),
      mediaType: openMediaType,
    }
    let isBrowserShow = LocalStorage.getShared()?.get<boolean>('isBrowserShow') ?? false;
    if (isBrowserShow) {
      Log.info(TAG, 'Browser has shown, return');
      return false;
    }
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_WAY, msg);
    PhotoInfo.mediaType = openMediaType;
    this.openPhotoBrowser();
    return false;
  }

  private browserDownloadToGrid(uri: string): void {
    if (this.mediaItem?.uri === uri && !this.isLocalImage && !this.isPhotoInner) {
      Log.info(TAG, 'browserDownloadToGrid uri = ' + uri + ', isDownloading = ' + this.isDownloading);
      this.isDownloading = true;
    }
  }

  private startDownloadImage(): boolean {
    const callerBundleName =
      LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.bundleName ?? '';
    const syncOptions: number = 0;
    const position = this.item.mediaItem?.getPosition();
    Log.info(TAG, `startDownloadImage, uri =  ${(this.item.mediaItem?.uri ?? '')},
    isDownloading = ${this.isDownloading}, syncOptions: ${syncOptions}, position: ${position},
    callerBundleName: ${callerBundleName}, isFromPickerView: ${this.selectParams.isFromPickerView}`);
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
    let sourceDownload: number = -1;
    if (position === photoAccessHelper.PositionType.CLOUD) {
      sourceDownload = syncOptions;
    }
    let msg: BigDataMsg = {
      'picker_mode': this.selectParams.isFromPickerView,
      'source_download': sourceDownload,
      'launch_pNameId': callerBundleName,
    }
    Log.info(TAG, `startDownloadImage currently downloading from cloud or home storage: ${sourceDownload}
      (0: cloud, 1: homeStorage)`);
    ReportToBigDataUtil.report(BigDataConstants.PICKER_DOWNLOAD_FILE_SOURCE, msg);
    return true;
  }

  private stopDownloadImage(): boolean {
    Log.info(TAG, 'stopDownloadImage, uri =' +
      (this.item.mediaItem?.uri ?? '') + ', isDownloading = ' + this.isDownloading);
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

  private getWidth(): number | string {
    return Number(this.imageItemWidth ?? 0) + BORDER_PADDING;
  }

  private getHeight(): number | string {
    return Number(this.imageItemHeight ?? 0) + BORDER_PADDING;
  }

  private previewNotifyPhoto(selectedUri: string, photoBrowserRange: number): void {
    if (this.mediaItem != null && this.mediaItem?.uri === selectedUri) {
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
    this.selectParams.isFromPickerView) {
      // 延迟触发预览宫格销毁，对于cacheImage缓存未命中的情况，给正式帧解码图片渲染送显留出时间
      Log.info(TAG, 'startHidePreview');
      this.broadCast.emit(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, []);
    }
  }

  /**
   * 刷新当前焦点，当列表中失焦时，当前选中的图片需要获焦
   */
  private refreshPickerFocus() {
    Log.debug(TAG, `refreshPickerFocus. index=${this.mPosition}`);
    let storage = LocalStorage.GetShared();
    if (this.hasInitFocus && this.isSelected && !storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) &&
      !this.selectParams.isFromPickerView) {
      this.requestFocusImage();
      // 因为没有主动设置zIndex，依赖的是stack默认的顺序，当图片获焦时，会盖住CheckBox，所以需要主动填一下zIndex
      this.imageModifier.attribute?.zIndex(0);
    }
  }

  private closeContextMenu() {
    if (this.isPrivateHideState) {
      this.getUIContext().getContextMenuController()?.close();
    }
  }

  geometryTransitionChange(): string {
    return (this.persistentId !== 0 || this.isBlockTransition) ? '' : this.geometryTransitionString;
  }
}
