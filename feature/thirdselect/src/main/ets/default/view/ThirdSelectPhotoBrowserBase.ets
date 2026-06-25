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

import lazy Matrix4 from '@ohos.matrix4';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy {
  AvPlayConstants,
  AvplayerStatus,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy {
  BigDataConstants,
  fromMsg,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { BrowserDataFactory } from '@ohos/common/src/main/ets/default/interface/BrowserDataFactory';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  getScreen,
  isOrientationHorizontal,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { MsgDownloadFinish } from '@ohos/common/src/main/ets/default/model/common/BigDataDotting';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { PhotoSelectedSwiper } from '@ohos/common/src/main/ets/default/view/PhotoSelectedSwiper';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { SelectUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/SelectUtil';
import lazy { SelectManager, ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { DownloadListener } from '@ohos/common/src/main/ets/default/model/browser/DownloadListener';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { Verify } from '@ohos/common/src/main/ets/default/utils/Verify';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { VideoPlayController } from '../../../../../../../browserCommon/src/main/ets/default/controller/VideoPlayController';
import lazy {
  FormConstants,
  IS_HORIZONTAL,
  THIRD_SELECT_IS_ORIGIN,
  ThirdSelectConstants
} from '../utils/ThirdSelectConstants';
import lazy { ThirdSelectedPanel } from './ThirdSelectedPanel';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy window from '@ohos.window';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { ThirdSelectedPageActionBar } from './ThirdSelectedPageActionBar';
import lazy { PickerPhotoBrowserBg } from '@ohos/common/src/main/ets/default/view/PickerPhotoBrowserBg';
import lazy { AppBarController } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { CustomColors, CustomTheme } from '@ohos.arkui.theme';
import lazy { DefaultThemeColor } from '../common/DefaultThemeColor';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { PickerInstanceUtil } from '@ohos/common/src/main/ets/default/utils/PickerInstanceUtil';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { display, uiExtension } from '@kit.ArkUI';
import lazy {
  SelectConstants,
  PickedMediaInfo,
  SingleSelectionMode
} from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy {
  ShortcutController,
  ShortcutManager
} from '@ohos/browsercommon/src/main/ets/default/controller/ShortcutController';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { PickerEditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/PickerEditorPhotoContext';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';

import lazy { MaskLayerUtils } from '../utils/MaskLayerUtils';
import lazy { PhotoPickerMaskLayer } from './PhotoPickerMaskLayer';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { PickerMediaDataSource } from '../common/PickerMediaDataSource';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { ThirdSelectPhotoPrivacyBase } from './ThirdSelectPhotoPrivacyBase';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { Rsc } from '@ohos/tools/src/main/global/RscString';
import { PickerThumbnailCreator } from '../utils/PickerThumbnailCreator'
import { ThirdBrowserDataSource } from '../common/ThirdBrowserDataSource';

/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectPhotoBrowserBase';
const ACCESSIBILITY_FOCUS_DELAY: number = 350;
const FOOTER_SAFETY_HEIGHT: number = 16;

interface ShortcutParam {
  keys: number[],
  cb: Function,
  uid: number,
}

interface Params {
  showCancel: boolean;
  position: number;
  bundleName: string;
  tokenId: number,
  transition: string;
  title: string;
  selectMode: boolean;
  isAllMode: boolean;
  maxSelectCount: number;
  maxSelectedReminderMode: number;
  isFromFa: boolean;
  isJustSelected: boolean;
  isCollagePageEnter: boolean;
  highlightPickerType: string;
  isHighlightPickerView: boolean;
  isNeedSelectBar: boolean;
  isShowSerialNum: boolean;
  isFromPickerView: boolean;
  singleSelectionMode: SingleSelectionMode;
  checkBoxColor: string;
  checkboxTextColor: string;
  isOriginalSupported: boolean;
  photoBrowserBackgroundColorMode: number;
  isRepeatSelectSupported: boolean;
  customColor: CustomColors;
  isImmersiveCompared: boolean;
  completeButtonText: number;
  isPhotoBrowserCheckboxVisible: boolean;
  isPhotoBrowserBackButtonVisible: boolean;
  photoBrowserCheckboxPosition: [number, number];
  photoBrowserMargin: Margin;
};

interface Msg {
  isOriginalChecked: boolean;
  selectItemSize: number;
  selectImageSize: number;
  selectVideoSize: number;
}

// third selection photoBrowser
@Component
export struct ThirdSelectPhotoBrowserBase {
  replaceUriManager: ReplaceUriManager | undefined = undefined;
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @Provide backgroundColorResource: Resource = $r('sys.color.background_secondary');
  @State stateMachine: PhotoBrowserStateMachine = new PhotoBrowserStateMachine();
  @State totalSelectedCount: number = 0;
  @State totalCount: number = 0;
  @State editButtonWidth :number = 0;
  @State displayAreaWidth :number = 0;
  private maxSelectedReminderMode: number = Constants.TOAST_REMIND_MODE;
  @Consume broadCast: BroadCast;
  @Provide isSelected: boolean = true;
  @State isShowActionBar: boolean = true;
  @Provide isDefaultBackgroundColor: boolean = true;
  @State isPhotoScaled: boolean = false;
  @Provide isPullingDown: boolean = false;
  @Provide isPullingUp: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide viewData: string = '';
  public selectManager?: ThirdSelectManager;
  public bundleName: string = '';
  public tokenId: number = 0;
  public isMultiPick = true;
  public mTransition: string = '';
  public controller: SwiperController = new SwiperController();
  public isOriginalSupported: boolean = true;
  @Provide('transitionIndex') @Watch('onCurrentIndexChanged') currentIndex: number = 0;
  @State currentUri: string = '';
  private isFromFa: boolean = false;
  @State private isButtonEnabledInSingleMode: boolean = false;
  @Provide disableSwipe: boolean = false;
  // position
  public mPosition: number = 0;
  @LocalStorageLink('pickerBrowsertTitle') title: string = '';
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  public maxSelectCount: number = 0;
  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State @Watch('onGeometryChanged') geometryTransitionId: string = '';
  @Link isRunningAnimation: boolean;
  @State privacyOptionsText: Resource | undefined = undefined;
  @State translateX: string = '0%';
  @ObjectLink browserController: BrowserController;
  public onEnterEdit: Function | undefined = undefined;
  public canEditVideo: boolean = false;
  @Provide isDeleting: boolean = false;
  // DataSource
  private dataSource: ThirdBrowserDataSource =
    this.getUIContext().getSharedLocalStorage()?.get(Constants.PHOTO_PICKER_BROWSER_DATASOURCE) ??
      new ThirdBrowserDataSource(this.stateMachine);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @Provide geometryTransitionEnable: boolean = false;
  @LocalStorageLink('geometryEnable') geometryEnable: boolean = false;
  private isSelectMode: boolean = false;
  private isNeedSelectBar: boolean = true;
  private isShowSerialNum: boolean = false;
  private isFromPickerView: boolean = false;
  private singleSelectionMode: SingleSelectionMode = SingleSelectionMode.BROWSER_MODE;
  @LocalStorageLink('showCancel') showCancel: boolean = false;
  private photoUnEdit: MediaItem | undefined = undefined;
  @Provide canEdit: boolean = false;
  @State isJustSelected: boolean = true;
  public allPhotoDataSource: MediaDataSource | undefined = undefined;
  public newMediaItem: MediaItem | undefined = undefined;
  private geometryTransitionInitial: boolean = false;
  private swiperDuration: number = 400;
  private editNewUri: string = '';
  private currentEditUri: string = '';
  private currentPhoto: MediaItem | undefined;
  private startEditTime: number = 0;
  private waitingUpdateData: boolean = false;
  private waitingUpdateIndex: number = -1;
  @State @Watch('onPullDownAndDrag') isPullDownAndDragPhoto: boolean = false;
  private panelId: string = 'ThirdSelectPhotoBrowserBase';
  private funcStartPullingDown: Function = (event: KeyEvent): void => this.startPullingDown(event);
  private funcCancelPullingDown: Function = (): void => this.cancelPullingDown();
  private handlePauseClickFuc: Function = (): void => this.handlePauseClick();
  private funcToggleBars: Function = (): void => this.toggleBars();
  private funcHideBars: Function = (): void => this.hideBars();
  private funcEndPullingDown: Function = (): void => this.endPullingDown();
  private funcOnDataSizeChanged: Function = (size: number): void => this.onDataSizeChanged(size);
  private funcSelectCallback: Function = (position: number, key: string, value: boolean): void => {
    this.selectCallback(position, key, value);
  };
  private funcUpdateEditItem: Function = (): void => this.updateEditItem();
  private funcDataContentChanged: Function = (): void => this.dataContentChanged();
  private funcJumpBrowserCallback: Function = (
    showCancel: boolean, name: string, item: MediaItem, isSelectMode = false, isFromPanel: boolean
  ): void => {
    if (!this.browserController.isAnimating) {
      this.jumpBrowserCallback(showCancel, name, item, isSelectMode, isFromPanel);
    }
  };
  private funcOnDataReloadWithEdit: Function = async (): Promise<void> => await this.onDataReloadWithEdit();
  private funcPageDisappear: Function = (): void => this.pageDisappear();
  private isPhotoInner: boolean = false;
  private okFunc: Function | undefined = (): void => {
  };
  private cancelFunc: Function | undefined = (): void => {
  };
  private dataObserver: CommonObserverCallback | undefined = new CommonObserverCallback(this);
  private isSetOriginal: boolean = false;
  // 页面销毁时，ThirdSelectPhotoBrowserBase作为子组件可能仍未销毁，然后ThirdSelectPhotoBrowserBase在disappear时会调用
  // refreshData刷新panel，这时会导致Crash，该变量用于识别这种情况，并组织刷新panel
  private isPageDisappear: boolean = false;
  @Provide isShowVideo: boolean = false;
  @Provide isEnableMouse: boolean = false;
  private isCollagePageEnter: boolean = false;
  private isHighlightPickerView: boolean = false;
  private highlightPickerType: string = '';
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  @State @Watch('onDownloadStatusChange') isImageDownloading: boolean = false;
  @Provide menuList: Action[] = [];
  @Provide toolMenuList: Action[] = [];
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State private moreMenuList: Action[] = [];
  @Provide isShowBar: boolean = true;
  @LocalStorageProp('isEditorShown') @Watch('onEditorClose') isEditorShown: boolean = false;
  private isImmersiveCompared: boolean = false;
  private videoPlayListenerFunc: Function = (): void => this.videoPlayListener();
  private videoPlayCompletedFunc: Function = (): void => this.videoPlayCompleted();
  private videoPlayController?: VideoPlayController;
  private isVideoPlaying: boolean = false;
  @StorageLink('isMute') @Watch('onIsMuteChanged') private isMute: boolean = false;
  private isVideoHide: boolean = false;
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);
  private videoPlaySwiperIndexChangedFunc: Function = (): void => this.videoPlaySwiperIndexChanged();
  private swiperSelectChangedFunc: Function = (index: number): void => this.swiperSelectChanged(index);
  private updateSwiperAnimationStateFunc: Function = (isInSwiperAnimation: boolean): void =>
  this.updateSwiperAnimationState(isInSwiperAnimation);
  private updateSelectedFun: Function = (selected: boolean, uri: string): void => this.updateSelected(selected, uri);
  private selectConfirmFun: Function = (uri: string): void => this.selectConfirm(uri);
  private updateRepeatPickFun: Function = (selectUris: string[]): void => this.updateRepeatPickTime(selectUris);
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State selectedItemIndex: number = Constants.INVALID;
  public checkBoxColor: string = '';
  public checkboxTextColor: string = '';
  @State isShowEditButton: boolean = true;
  private isInSwiperAnimation: boolean = false;
  @State photoBrowserBackgroundColorMode: number = 0;
  @State repeatPickTimes: number = 0; //单张图可被多次选择的次数
  private isRepeatSelectSupported: boolean = false;
  @State private appBarController: AppBarController = new AppBarController();
  private colorTheme: CustomTheme = {};
  private onPhotoBrowserBackPressEventFunc: Function = (): boolean => this.onBackPress();
  private completeButtonText: number = ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE;
  private setPhotoBrowserItemFunc: Function =
    (itemUri: string, index: number): void => this.setPhotoBrowserItem(itemUri, index);
  @State private isCheckboxVisible: boolean = true;
  @State private isBackButtonVisible: boolean = true;
  private checkboxPosition: [number, number] = [0, 0];
  private isSetCheckboxPosition: boolean = false;
  private navPageInfos: NavPathStack = new NavPathStack();
  @State private pickerPhotoBrowserHeight: string = '';
  @State private panelMarginTop: ResourceStr = '';
  @State private allHeight: Length = 0;
  @State private panelHeight: Length = 0;
  private updateUIElementVisibilityFunc: Function = (elementType: number, isVisible: boolean): void =>
  this.updateUIElementVisibility(elementType, isVisible);
  @State @Watch('calIsButtonEnabledInSingleMode') private isRemoteResource: boolean = false;
  @Prop private downloadProgress: number = 0;
  private downloadListener: DownloadListener = {
    onDownloadFinished: (uri: string): void => this.onDownloadFinishedFunc(uri),
    onDownloadProgressChanged: (uri: string, progress: number): void =>
    this.onDownloadProgressChangedFunc(uri, progress),
    onDownloadStoped: (uri: string): void => this.onDownloadStopedFunc(uri),
    onDownloadFailed: (uri: string, err: string): void => this.onDownloadFailedFunc(uri, err),
  } as DownloadListener;
  @State private thirdSelectController: ThirdSelectGridController = new ThirdSelectGridController();
  private footerNavigationHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.navigation_margin_bottom')));
  private selectTipsHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.picker_select_tips_col_height')));
  @LocalStorageLink('isShowBrowserAni') @Watch('showBrowserAniChange') isShowBrowserAni: boolean = false;
  //是否子窗picker模式
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  @LocalStorageProp('geometryTransitionBrowserId') @Watch('onGeometryTransitionBrowserId') geometryTransitionBrowserId: string = '';
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  @State photoBrowserMargin: Margin = {};
  @State uriBeforeEdit: string = '';
  // 如果在swiper动画过程中，targetIndex是swiper动画的目标位置。其他场景与currentIndex含义一致
  private targetIndex: number = 0;
  @State maskLayerUtils: MaskLayerUtils = MaskLayerUtils.getInstance();
  @State isPickerMaskLayerShow: boolean = false;
  @LocalStorageLink(BroadCastConstants.UPDATE_IS_PICKER_SPLIT_SCREEN) isPickerSplitScreen: boolean = true;
  @LocalStorageLink(BroadCastConstants.UPDATE_IS_HALF_SCREEN) isHalfScreen: boolean = false;
  @LocalStorageLink(BroadCastConstants.UPDATE_IMAGE_HEIGHT) maxImageHeight: number = 0;
  @LocalStorageLink(BroadCastConstants.UPDATE_STACK_HEIGHT) maxStackHeight: number = 0;
  private panelMargin: number = 20;
  private footerHeight: number = 56;
  private pickerMarginTop: number = 72;
  private scroller: Scroller = new Scroller()
  private pageInfo: NavPathStack = new NavPathStack();
  private onPhotoPickerAppLockStatusUpdated = (status: boolean) => {
    Log.info(TAG, `onPhotoPickerAppLockStatusUpdated status = ${status}`);
    this.isPickerMaskLayerShow = status;
  }
  private isActive: boolean = true
  private pickerThumbnailCreator: PickerThumbnailCreator = PickerThumbnailCreator.getInstance();
  private changePrivacyViewStatus = (isShowPrivacyView: boolean) => {
    Log.info(TAG, `changePrivacyViewStatus, isShow: ${isShowPrivacyView}`)
    if (isShowPrivacyView) {
      this.pageInfo.pushPath({ name: 'ThirdSelectPhotoPrivacyBase' });
    } else {
      this.pageInfo.pop();
    }
    this.photoBrowserBarAnimate(isShowPrivacyView);
    this.changePrivacyOptionsText();
  };

  private changePrivacyOptionsText = () => {
    let privacyStatus = PhotoAccessHelperAccess.getPrivacyStatusByTokenId(this.tokenId);
    if (privacyStatus !== photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE) {
      // this.privacyOptionsText = $r('app.string.source_privacy_options');
    } else {
      // this.privacyOptionsText = $r('app.string.source_privacy_options');
    }
  }

  private photoBrowserBarAnimate = (isShowPrivacyView: boolean) => {
    this.getUIContext().animateTo({
      curve: BrowserConstants.PICKER_PRIVACY_OPTIONS_CURVE,
    }, () => {
      this.translateX = isShowPrivacyView ? '-2%' : '0%'
    })
  }

  private onDownloadStatusChange(): void {
    this.calIsButtonEnabledInSingleMode();
  }

  calIsButtonEnabledInSingleMode(): void {
    Log.info(TAG, `calIsButtonEnabledInSingleMode isRemoteResource is ${this.isRemoteResource}` +
      `isFromFa is ${this.isFromFa}, networkAvailable is ${this.networkAvailable}` +
      `downloadProgress is ${this.downloadProgress}`);
    if (!this.isRemoteResource) {
      this.isButtonEnabledInSingleMode = true;
    } else if (this.isFromFa) {
      this.isButtonEnabledInSingleMode = this.networkAvailable && (this.downloadProgress === 100);
    } else {
      this.isButtonEnabledInSingleMode = false;
    }
  }

  private onDownloadFinishedFunc(uri: string): void {
    Log.info(TAG, `onDownloadFinishedFunc uri: ${uri}`);
    this.downloadProgress = 100;
    if (this.currentEditUri === uri) {
      this.currentEditUri = '';
      this.startEditTime = 0;
    }
    setTimeout((): void => {
      this.isImageDownloading = false;
      this.isRemoteResource = false;
    }, 500)
  }

  private back2Grid: Function = (): void => {
    if (this.browserController.isBrowserShow && !this.isEditorShown) {
      Log.info(TAG, 'Picker back2Grid');
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, fromMsg(BigDataConstants.BY_KEYBOARD));
      this.onBackPress();
      this.getUIContext().getFocusController().clearFocus()
    }
  }

  private onPickerPressEnter: Function = (): void => {
    Log.info(TAG, 'Picker PressEnter');
    if (this.browserController.isBrowserShow && !this.isEditorShown && this.isPickerUsedSubwindow) {
      this.onPressEnter();
    }
  }

  private showPreviousFun: Function = (): void => {
    Log.info(TAG, 'showPreviousFun');
    if (this.isEditorShown) {
      Log.info(TAG, 'showPreviousFun isEditorShown');
      return;
    }
    this.controller.showPrevious();
  }

  private showNextFun: Function = (): void => {
    Log.info(TAG, 'showNextFun');
    if (this.isEditorShown) {
      Log.info(TAG, 'showNextFun isEditorShown');
      return;
    }
    this.controller.showNext();
  }

  private shortcutList: ShortcutParam[] = [
    {
      keys: [MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT],
      cb: this.showPreviousFun,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT],
      cb: this.showNextFun,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_PAGE_UP],
      cb: this.showPreviousFun,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_PAGE_DOWN],
      cb: this.showNextFun,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_KEYBOARD_ESC],
      cb: this.back2Grid,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_SPACE],
      cb: this.back2Grid,
      uid: -1,
    },
    {
      keys: [MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER],
      cb: this.onPickerPressEnter,
      uid: -1,
    },
  ]

  private onDownloadProgressChangedFunc(uri: string, progress: number): void {
    if (this.currentPhoto?.uri === uri) {
      this.downloadProgress = Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS +
        progress / Constants.PICKER_PHOTO_DOWNLOAD_COMPLETE_PROGRESS *
          (Constants.PICKER_PHOTO_DOWNLOAD_COMPLETE_PROGRESS - Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS);
    }
  }

  private onDownloadStopedFunc(uri: string): void {
    Log.info(TAG, `onDownloadStopedFunc uri: ${uri}`);
    this.isImageDownloading = false;
  }

  private onDownloadFailedFunc(uri: string, err: string): void {
    Log.error(TAG, `onDownloadFailedFunc uri: ${uri}, error message: ${err}`);
    if (err === 'NETWORK_UNAVAILABLE') {
      UiUtil.showToast($r('app.string.no_network'));
    }
    this.isImageDownloading = false;
    if (this.currentEditUri === uri) {
      this.reportEditDownLoadErrorInfo(err);
      this.currentEditUri = '';
      this.startEditTime = 0;
    }
  }

  onPressEnter(): void {
    Log.info(TAG, ' onPressEnter.');
    if (this.totalSelectedCount > 0) {
      this.onMenuClicked(Action.OK);
    }
  }

  onEditorClose(): void {
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    Log.info(TAG, 'editorCloseNow');
  }

  onGeometryChanged(): void {
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  onPullDownAndDrag(): void {
    Log.debug(TAG, `onPullDownAndDrag: ${this.isPullDownAndDragPhoto}`);
    this.browserController.isPullDownAndDrag = this.isPullDownAndDragPhoto;
  }

  async aboutToAppear(): Promise<void> {
    this.pickerThumbnailCreator.stop();
    this.isPickerMaskLayerShow = MaskLayerUtils.getInstance().getIsPickerMaskLayerShow();
    this.allPhotoDataSource = LocalStorage.getShared()?.get<MediaDataSource>(Constants.APP_KEY_ALL_PHOTO_DATASOURCE);
    Log.info(TAG, `photoBrowser aboutToAppear geometryTransitionEnable ${this.geometryTransitionEnable}`);
    this.appBarController.padding = {
      top: 0,
      left: 0,
      right: 0,
      bottom:
      getScreen().getWinMode() === WindowMode.FULLSCREEN ? $r('app.float.navigation_margin_bottom') : 0
    };
    WindowUtil.prepareWinRouter();
    this.isDefaultBackgroundColor = this.isPickerUsedSubwindow;
    // picker场景默认进入有声播放，普通大图场景默认进入无声播放
    this.isMute = false;
    this.geometryTransitionInitial = this.geometryTransitionEnable;
    this.geometryTransitionId = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') as string;
    Log.info(TAG, `aboutToAppear geometryTransitionId: ${this.geometryTransitionId}`);
    this.browserController.browserBackFunc = (): boolean => this.onBackPress();
    this.selectManager = LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    this.dataSource.setAlbumDataSource(LocalStorage.getShared()?.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER));
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    let param: Params = this.browserController.browserParam as Params;
    this.initParam(param);
    this.dataSource.setAllMode(param.isAllMode);
    this.dataSource?.setSelectMode(this.selectManager as ThirdSelectManager, param.selectMode);
    this.setTotalSelectedCount();
    if (param.showCancel !== undefined) {
      this.showCancel = param.showCancel;
    }

    this.dataSource.setBroadCast(this.broadCast);
    this.onPhotoChanged(param.position);
    this.calIsButtonEnabledInSingleMode();

    this.photoUnEdit = this.getCurrentPhoto();
    try {
      this.canEdit = (this.canEditVideo || this.photoUnEdit?.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) &&
        LocalStorage.getShared()?.get<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE) as boolean &&
        await UiUtil.isEditedEnable(this.photoUnEdit);
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
      this.canEdit = false;
    }

    this.mTransition = param.transition;
    this.bundleName = param.bundleName;
    this.tokenId = param.tokenId;
    this.title = param.title;
    this.maxSelectCount = param.maxSelectCount;

    this.setBroadCast();
    this.updateMenu();
    this.addShortcutListener();

    this.dataSource.getAlbumDataSource()?.setPhotoBroadCast(this.broadCast);
    this.breakpointSystem.registerOrientationChange();
    if (this.pageStatus) {
      this.onPageShow();
    }
    this.isShowEditButton = true;
    this.pickerPhotoBrowserHeight = this.getPhotoDisplayAreaHeight();
    this.totalCount = this.dataSource?.totalCount();
    if (!this.isPhotoInner) {

    }
    // 占用事件
    let extensionWindowProxy: uiExtension.WindowProxy =
      LocalStorage.getShared().get<uiExtension.WindowProxy>('extensionWindowProxy') as uiExtension.WindowProxy;
    extensionWindowProxy?.occupyEvents(uiExtension.EventFlag.EVENT_PAN_GESTURE_LEFT |
    uiExtension.EventFlag.EVENT_PAN_GESTURE_RIGHT);
    this.changePrivacyOptionsText();
  }

  private initParam(param: Params): void {
    this.isFromFa = param.isFromFa;
    this.isSelectMode = param.selectMode;
    this.isNeedSelectBar = param.isNeedSelectBar;
    this.isShowSerialNum = param.isShowSerialNum;
    this.isFromPickerView = param.isFromPickerView;
    this.singleSelectionMode = param.singleSelectionMode;
    this.checkBoxColor = param.checkBoxColor;
    this.checkboxTextColor = param.checkboxTextColor;
    this.isOriginalSupported = param.isOriginalSupported;
    this.photoBrowserBackgroundColorMode = param.photoBrowserBackgroundColorMode;
    this.isRepeatSelectSupported = param.isRepeatSelectSupported;
    this.isImmersiveCompared = param.isImmersiveCompared;
    this.isCollagePageEnter = param.isCollagePageEnter;
    this.highlightPickerType = param.highlightPickerType;
    this.isHighlightPickerView = param.isHighlightPickerView;
    this.colorTheme = DefaultThemeColor.getCustomTheme(param.customColor);
    this.completeButtonText = param.completeButtonText;
    this.maxSelectedReminderMode = param.maxSelectedReminderMode;
    this.checkboxPosition = param.photoBrowserCheckboxPosition;
    if (this.checkboxPosition && this.checkboxPosition.length > 0 && this.checkboxPosition[0] &&
    this.checkboxPosition[1]) {
      this.isSetCheckboxPosition = this.checkboxPosition[0] !== 0 || this.checkboxPosition[1] !== 0;
    }
    this.isCheckboxVisible = param.isPhotoBrowserCheckboxVisible;
    this.isBackButtonVisible = param.isPhotoBrowserBackButtonVisible;
    this.photoBrowserMargin = param.photoBrowserMargin;
  }

  private setTotalSelectedCount(): void {
    this.isMultiPick = this.selectManager?.getIsMultiPick() as boolean;
    if (this.isMultiPick || this.isFromPickerView) {
      this.totalSelectedCount = this.selectManager?.getSelectedCount() as number;
    } else {
      this.totalSelectedCount = 1;
    }
  }

  private updateUIElementVisibility(elementType: number, isVisible: boolean): void {
    if (elementType === ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_CHECKBOX) {
      this.isCheckboxVisible = isVisible;
    }
    if (elementType === ThirdSelectConstants.PHOTO_BROWSER_UI_ELEMENT_BACK_BUTTON) {
      this.isBackButtonVisible = isVisible;
    }
  }

  private pageDisappear(): void {
    this.isPageDisappear = true;
    this.onBackPress();
  }

  startPullingDown(event: KeyEvent): void {
    Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
    this.isPullingDown = true;
  }

  cancelPullingDown(): void {
    Log.info(TAG, 'pulling down cancel');
    this.isPullingDown = false;
  }

  endPullingDown(): void {
    this.browserController.isDrag = true;
    this.onBackPress();
  }

  updateEditItem(): void {
    let currentPhoto = this.getCurrentPhoto();
    this.photoUnEdit = currentPhoto;
  }

  private showBrowserAniChange(): void {
    if (this.browserController.isBrowserShow && !this.isShowBrowserAni) {
      this.dataSource?.updatePixMapDataSource(this.currentIndex, this.browserController.isAnimating);
    }
  }
  private onGeometryTransitionBrowserId(): void {
    this.geometryTransitionId = this.geometryTransitionBrowserId;
  }

  onCurrentIndexChanged(): void {
    if (this.browserController.isBrowserShow && this.isShowBrowserAni) {
      let item = this.getCurrentPhoto();
      if (item && !ImageUtil.isExitTransparentChannelLocalImgMimeType(item)) {
        Log.info(TAG, 'onCurrentIndexChanged is animating');
        return;
      }
    }
    this.broadCast?.emit(BrowserConstants.EVENT_ON_CURRENT_INDEX_CHANGED, [this.currentIndex]);
  }

  public async onDataReloadWithEdit(): Promise<void> {
    Log.info(TAG, 'BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT animate to data reloaded start with edit');
    ReportToBigDataUtil.report(BigDataConstants.CREATE_THIRD_EDIT_SAVE, undefined);
    PickerEditorPhotoContext.getInstance().setIsPickerWaitingEditExitBroadCast(false);
    try {
      this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [0]);
      let uri: string = PickerEditorPhotoContext.getInstance().getEditorUriOnExit() ?? '';
      Log.info(TAG, `onDataReloadWithEdit uri= ${uri}`);
      if (uri) {
        // is in current album
        let newIndex = this.dataSource.getDataIndexByUri(uri);
        // 编辑另存为找不到新图index，则使用原图index
        let beforeIndex = this.dataSource.getDataIndexByUri(this.uriBeforeEdit);
        let ternaryIndex = newIndex !== Constants.NOT_FOUND ? newIndex : beforeIndex;

        if (newIndex != Constants.NOT_FOUND) {
          this.selectStateChangeEdit(uri);
          this.dataSource.updatePixMapDataSource(newIndex, this.browserController.isAnimating)
        }

        if (ternaryIndex !== Constants.NOT_FOUND) {
          // Search for the position of new image/video after edit in current 500 items succeed
          LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', ternaryIndex);
          if (!this.isMultiPick) {
            this.currentIndex = ternaryIndex;
            this.photoUnEdit = this.getCurrentPhoto();
          } else {
            let currentSelectIndex =
              (this.photoUnEdit ?
              this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ?? Constants.INVALID;
            this.currentIndex = ternaryIndex;
            if (currentSelectIndex !== -1 && newIndex !== Constants.NOT_FOUND &&
              this.totalSelectedCount <= this.maxSelectCount) {
              this.selectStateChangeEdit(uri);
              this.broadCast.emit(Constants.UPDATE_SELECTED, [true, uri]);
            }
            if (this.dataSource.getSelectMode() && this.selectManager) {
              this.dataSource.setSelectMode(this.selectManager, this.dataSource.getSelectMode());
            }
          }

          this.photoUnEdit = this.getCurrentPhoto();
          if (this.photoUnEdit) {
            await this.photoChangedByMediaItem(this.photoUnEdit, true);
          }
        } else { // is not in current album or over 500
          // Search for the position of new image/video after edit in current 500 items failed
          this.canEdit = false;

          this.editNewUri = uri;
          this.dataSource.enableGetData(false);
          this.currentIndex = 0;
          this.dataSource.getItemIndexByUri(
            this.editNewUri,
            (index: number): void => this.onGetItemIndexByNewEditUri(index));
        }
      }
    } catch (e) {
      Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
    } finally {
      this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [this.swiperDuration]);
    }
    this.dataSource.onDataReloaded();
  }

  dataContentChanged(): void {
    if (!this.targetIndex || this.targetIndex === this.currentIndex) {
      this.onPhotoChanged(this.currentIndex);
    }
    if (this.waitingUpdateData) {
      let result: MediaResult = this.dataSource.getDataInTimeLine(this.waitingUpdateIndex);
      if (result !== undefined) {
        this.currentIndex = this.waitingUpdateIndex;
        let mediaItem: MediaItem | undefined = result.item;
        let pos: number | undefined = result.pos;
        let thumbnail: string | undefined = result.thumbnail?.url;
        if (pos) {
          this.currentIndex = pos;
        }
        if (mediaItem) {
          this.newMediaItem = mediaItem;
        }
        if (thumbnail) {
          this.newMediaItem?.setThumbnail(thumbnail);
        }

        this.currentUri = this.editNewUri;
        this.editNewUri = '';

        this.updateSelectItemByNewEditIndexFromDataSource(this.currentIndex);

        if (this.dataSource.getSelectMode()) {
          LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
        }
        this.waitingUpdateIndex = -1;
        this.waitingUpdateData = false;
      } else {
        this.waitingUpdateData = true;
      }
    }
  }

  onGetItemIndexByNewEditUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByNewEditUri: index=${index}`);
    if (!this.editNewUri) {
      Log.error(TAG, `onGetItemIndexByNewEditUri empty editNewUri`)
      this.dataSource.enableGetData(true);
      return;
    }

    if (index != Constants.NOT_FOUND) { // over 500
      Log.info(TAG, `data reloaded move to ${index}`);

      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', index);

      this.dataSource.enableGetData(true);
      this.dataSource.onDataReloaded();
      let result: MediaResult = this.dataSource.getDataInTimeLine(this.currentIndex);
      if (result !== undefined) {
        let mediaItem: MediaItem | undefined = result.item;
        let pos: number | undefined = result.pos;
        let thumbnail: string | undefined = result.thumbnail?.url;
        if (pos) {
          this.currentIndex = pos;
        }
        this.newMediaItem = mediaItem;
        if (thumbnail) {
          this.newMediaItem?.setThumbnail(thumbnail);
        }

        this.currentUri = this.editNewUri;
        this.editNewUri = '';

        this.updateSelectItemByNewEditIndexFromDataSource(this.currentIndex);

        if (this.dataSource.getSelectMode()) {
          LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
        }
      } else {
        this.waitingUpdateIndex = index;
        this.waitingUpdateData = true;
      }
    } else { // other album and can not save new in this album
      Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
      this.dataSource.enableGetData(true);
      this.dataSource.onDataReloaded();


      // 此时数据应当使用选中列表的数据
      let dataImpl: PhotoDataImpl | undefined =
        BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl | undefined;
      dataImpl?.getDataByUri(this.editNewUri).then((fileAsset: photoAccessHelper.PhotoAsset | undefined): void => {
        this.newMediaItem = new MediaItem(fileAsset);
        if (dataImpl) {
          this.newMediaItem.setThumbnail(dataImpl?.getThumbnailSafe(this.newMediaItem.uri,
            this.newMediaItem.path, this.newMediaItem.getDateModified()));
        }
        this.editNewUri = '';
        this.updateSelectItemByNewEditItem(this.newMediaItem, this.currentIndex);

        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
        this.geometryTransitionId = '';
      });
    }
  }

  updateSelectItemByNewEditIndexFromDataSource(index: number): void {
    Log.info(TAG, `updateSelectItemByNewEditIndexFromDataSource: index=${index}`);
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', index); // timeLineIndex
    if (!this.isMultiPick) {
      this.currentIndex = index;
      this.photoUnEdit = this.getCurrentPhoto();
    } else {
      let currentSelectIndex =
        (this.photoUnEdit ? this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ?? Constants.INVALID;
      this.currentIndex = index;
      if (currentSelectIndex !== -1) {
        this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.photoUnEdit?.uri ?? '']);
        this.unSelectEditPhoto();
      }

      if (this.totalSelectedCount < this.maxSelectCount && this.photoUnEdit?.uri) {
        this.selectStateChangeEdit(this.photoUnEdit.uri);
      }

      if (this.dataSource.getSelectMode() && this.selectManager) {
        this.dataSource.setSelectMode(this.selectManager, this.dataSource.getSelectMode());
      }
      this.photoUnEdit = this.getCurrentPhotoInTimeLine();
    }
    let getCur: MediaItem | undefined = this.getCurrentPhotoInTimeLine()
    if (getCur) {
      this.photoChangedByMediaItem(getCur);
    }
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [this.photoUnEdit?.uri, this.isSelected]);
  }

  updateSelectItemByNewEditItem(mediaItem: MediaItem, index?: number): void {
    Log.info(TAG, `updateSelectItemByNewEditItem: index=${index}`);
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', index as number); // timeLineIndex
    if (!this.isMultiPick) {
      this.currentIndex = index as number;
      this.photoUnEdit = this.getCurrentPhoto();
    } else {
      let currentSelectIndex =
        (this.photoUnEdit ? this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ?? Constants.INVALID;
      this.currentIndex = index as number;
      if (currentSelectIndex !== -1) {
        this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.photoUnEdit?.uri ?? '']);
        this.unSelectEditPhoto();
      }

      if (this.totalSelectedCount < this.maxSelectCount) {
        this.isSelected = true;
        this.selectManager?.toggleEditThree(mediaItem.uri, true, mediaItem);
        this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [mediaItem.uri, this.isSelected]);
      }

      if (this.dataSource.getSelectMode() && this.selectManager) {
        this.dataSource.setSelectMode(this.selectManager, this.dataSource.getSelectMode());
        this.photoUnEdit = mediaItem;
      }
    }
    this.photoChangedByMediaItem(mediaItem);
    this.broadCast.emit(this.panelId +
    BroadCastConstants.UPDATE_SELECT, [this.photoUnEdit?.uri ?? '', this.isSelected]);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'call aboutToDisappear');
    this.pickerThumbnailCreator.start();
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    // 数据清理以及重置
    this.showCancel = true;
    this.isActive = false;
    if (this.selectManager !== null) {
      if (this.selectManager?.isPreview) {
        this.selectManager.isPreview = false;
        this.selectManager.clickedSet.clear();

        this.selectManager.previewSet.forEach(
          (value: string) => {
            this.selectManager?.clickedSet.add(value);
          });
      }

      ((this.selectManager?.selectedMap) as Map<string, MediaItem>)?.forEach(
        (value: MediaItem, key: string) => {
          if (this.selectManager != null && !(this.selectManager.clickedSet.has(key))) {
            if (value !== undefined) {
              this.selectManager.indexMap.delete(value);
            }
            this.selectManager.selectedMap.delete(key);
          }
        });

      // selectManager 多余数据处理
      this.selectManager?.previewSet.clear();
    }

    if (!this.isPageDisappear) {
      this.selectManager?.refreshData();
    }

    this.dataSource.release();
    PickerEditorPhotoContext.getInstance().clear();
    this.unRegisterBroadCast();
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.videoPlayListenerFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_SELECT_CHANGED, this.swiperSelectChangedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_PICKER_APP_LOCK_STATUS_UPDATED,
      this.onPhotoPickerAppLockStatusUpdated);
    UiUtil.resetGeometryTransitionParams();
    this.removeShortcutListener();
    this.breakpointSystem.unregisterOrientationChange();
    if (this.isImageDownloading) {
      this.broadCast.emit(BroadCastConstants.BROWSER_DOWNLOAD_TO_GRID, [this.getCurrentPhoto()?.uri ?? '']);
    }
    // 占用事件取消
    this.broadCast.emit(BroadCastConstants.OCCUPY_EVENTS);
  }

  private addShortcutListener(): void {
    for (let i = 0; i < this.shortcutList.length; i++) {
      let uid = this.shortcutController.addListener(
        this.shortcutList[i].keys.slice(),
        this.shortcutList[i].cb,
      );
      this.shortcutList[i].uid = uid;
    }
  }

  private removeShortcutListener(): void {
    for (let i = 0; i < this.shortcutList.length; i++) {
      this.shortcutController.removeListener(this.shortcutList[i].keys, this.shortcutList[i].uid);
    }
  }

  private unRegisterBroadCast(): void {
    if (this.broadCast) {
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.funcJumpBrowserCallback);
      this.broadCast.off(BroadCastConstants.SELECT, this.funcSelectCallback);
      this.broadCast.off(BrowserConstants.PULL_DOWN_START, this.funcStartPullingDown);
      this.broadCast.off(BrowserConstants.PULL_DOWN_CANCEL, this.funcCancelPullingDown);
      this.broadCast.off(BrowserConstants.TOGGLE_BAR, this.funcToggleBars);
      this.broadCast.off(BrowserConstants.HIDE_BARS, this.funcHideBars);
      this.broadCast.off(BrowserConstants.PULL_DOWN_END, this.funcEndPullingDown);
      this.broadCast.off(BrowserConstants.DATA_SIZE_CHANGED, this.funcOnDataSizeChanged);
      this.broadCast.off(BroadCastConstants.UPDATE_EDIT_ITEM, this.funcUpdateEditItem);
      this.broadCast.off(BrowserConstants.DATA_CONTENT_CHANGED, this.funcDataContentChanged);
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.funcOnDataReloadWithEdit);
      this.broadCast.off(BroadCastConstants.PICKER_PAGE_DISAPPEAR, this.funcPageDisappear);
      this.broadCast.off(BroadCastConstants.UPDATE_PHOTO_BROWSER_SELECT_STATUS, this.updateSelectedFun);
      this.broadCast.off(BroadCastConstants.SELECT_CONFIRM, this.selectConfirmFun);
      this.broadCast.off(BroadCastConstants.UPDATE_SWIPER_ANIMATION_STATE, this.updateSwiperAnimationStateFunc);
      this.broadCast.off(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
      this.broadCast.off(BroadCastConstants.CHANGE_IS_PAUSE, this.handlePauseClickFuc);
      this.broadCast.off(BroadCastConstants.BROWSER_ON_BACK_PRESS, this.onPhotoBrowserBackPressEventFunc);
      this.broadCast.off(BroadCastConstants.SET_PHOTO_BROWSER_ITEM, this.setPhotoBrowserItemFunc);
      this.broadCast.off(BroadCastConstants.UPDATE_PHOTO_BROWSER_UI_ELEMENT_VISIBILITY,
        this.updateUIElementVisibilityFunc);
    }
  }

  private updateRepeatPickTime(selectUris: string[]): void {
    if (this.currentUri != null) {
      let updateRepeatPickTimes = 0;
      selectUris.forEach(item => {
        if (item === this.currentUri) {
          updateRepeatPickTimes++;
        }
      })
      this.repeatPickTimes = updateRepeatPickTimes;
    }
  }

  toggleBars(): void {
    Log.debug(TAG, `toggleBars: ${this.isShowActionBar}`);
    if (this.isShowActionBar) {
      this.hideBars();
    } else {
      this.showBars();
    }
  }

  showBars(): void {
    Log.debug(TAG, 'showBars');
  }

  hideBars(): void {
    Log.debug(TAG, 'hideBars');
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.debug(TAG, `onMediaLibDataNfy isActive: ${this.isActive} nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (!this.dataSource || !this.isUsefulNotify(nfyInfo) || !this.isActive) {
      Log.info(TAG, 'dataSource is empty or is not useful notify or page is not foreground');
      if (this.dataSource.getAlbumDataSource() instanceof PickerMediaDataSource) {
        let iDataSource = this.dataSource.getAlbumDataSource() as PickerMediaDataSource;
        if (iDataSource && typeof iDataSource.isDataChange === 'boolean' &&
          nfyInfo.type != MediaObserverNfyType.NONE) {
          iDataSource.isDataChange = true;
        }
      }
      return;
    }
    if (!nfyInfo.uris || !nfyInfo.uris.length) {
      return;
    }
    this.dataSource.switchRefreshOn();
    this.dataSource.onNotify(nfyInfo, true);
    if (PickerEditorPhotoContext.getInstance().isPickerWaitingEditExitBroadCast()) {
      for (const uri of nfyInfo.uris) {
        const idx = this.dataSource.getDataIndexByUri(uri);
        if (idx !== -1) {
          this.dataSource?.updatePixMapDataSource(idx, this.browserController.isAnimating);
        }
      }
    }
    this.dataSource.onDataReloaded();

    if (this.allPhotoDataSource !== undefined && this.allPhotoDataSource !== null) {
      this.allPhotoDataSource.onDataReloaded();
    }
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onDataReloaded();

    if (this.allPhotoDataSource !== undefined && this.allPhotoDataSource !== null) {
      this.allPhotoDataSource.onDataReloaded();
    }
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size}`);
    if (size === 0) {
      this.onBackPress();
    }
  }

  async onPhotoChanged(index: number): Promise<void> {
    Log.info(TAG, `onPhotoChanged index: ${index}`)
    if (index < 0) {
      Log.error(TAG, `onPhotoChanged, index is error. index = ${index}`);
      return;
    }
    if (this.currentIndex !== index) {
      this.currentIndex = index;
    }
    this.currentPhoto = this.getCurrentPhoto();
    // 需要保证时序，否则解码条数有问题
    this.dataSource?.updatePixMapDataSource(this.currentIndex, this.browserController.isAnimating);
    this.targetIndex = index;
    let currentPhoto = this.getCurrentPhoto();
    this.dataSource.updateCurrent(this.currentIndex);
    this.browserController.currentIndex = index;
    if (!currentPhoto) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
      return;
    }
    this.dealRemoteResourceDownload(currentPhoto);
    this.updateSelectedItemIndex(currentPhoto?.uri);
    try {
      this.canEdit = (this.canEditVideo || currentPhoto.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) &&
        LocalStorage.getShared()?.get<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE) as boolean &&
        await UiUtil.isEditedEnable(currentPhoto);
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
      this.canEdit = false;
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri) ?? false;
    this.currentUri = currentPhoto.uri;

    let dataSourceIndex = this.isSelectMode && index !== Constants.INVALID ?
      (this.selectManager?.getSelectItemDataSourceIndex(currentPhoto) ?? Constants.INVALID) : index;
    let timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex);
    if (this.isRepeatSelectSupported) {
      this.updateRepeatPickTime(this.selectManager?.getSelectUris() ? this.selectManager?.getSelectUris() : []);
    }
    if (this.geometryEnable) {
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', timelineIndex as number);
      Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        geometryTransitionId = ${this.geometryTransitionId}, placeholderIndex = ${timelineIndex}`);
    }
    this.onPhotoBrowserChanged();

    // 根据滑动方向 以及当前的位置 处理
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, [this.currentUri]);
  }

  private onPhotoBrowserChanged(): void {
    if (this.isFromPickerView && this.isMultiPick) {
      Log.info(TAG, `onPhotoBrowserChanged uri: ${this.currentUri}`);
      let storage = LocalStorage.getShared();
      if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
        let session: UIExtensionContentSession | undefined =
          storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.sendData({ 'dataType': 'onPhotoBrowserChanged', 'uri': this.currentUri });
      }
    }
  }

  private async dealRemoteResourceDownload(currentPhoto: MediaItem): Promise<void> {
    if (this.isPhotoInner) {
      return;
    }
    if (this.isRemoteResource && this.isImageDownloading) {
      Log.info(TAG, `this.broadCast.off ${this.currentUri}`);
    }
    let isRemoteResource = false;
    this.isRemoteResource = isRemoteResource;
    if (this.isRemoteResource) {
      Log.info(TAG, `RemoteResource photo: ${currentPhoto.uri}`);
      this.downloadCloudImage(currentPhoto);
    }
  }

  private downloadCloudImage(currentItem: MediaItem): void {
    if (!this.networkAvailable) {
      // 网络不可用，提示无法下载
      UiUtil.showToast($r('app.string.no_network'));
      return;
    }
    this.downloadProgress = Constants.PICKER_PHOTO_DOWNLOAD_START_PROGRESS;
    Log.info(TAG, `downloadFinishCallback startDownload ${currentItem.uri}`);
    this.isImageDownloading = true;
  }

  private updateSelected(selected: boolean, uri: string): void {
    if (this.isFromPickerView) {
      if (uri != null && uri === this.currentUri) {
        this.isSelected = selected;
        Log.info(TAG, 'updateSelected this.isSelected = ' + this.isSelected + ` selected = ${selected}`);
      }
      this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
      this.updateSelectedItemIndex(this.currentUri);
    }
  }

  private selectConfirm(uri: string): void {
    if (!this.isFromPickerView) {
      return;
    }
    if (uri !== this.currentUri) {
      Log.info(TAG, 'selectConfirm this.currentUri = ' + this.currentUri + ` uri = ${uri}`);
    }
    if (!uri) {
      uri = this.currentUri;
    }
    this.isSelected = true;
    Log.info(TAG, `selectConfirm, uri = ${uri}`);
    this.updateSelectedItemIndex(uri);
    this.broadCast.emit(Constants.UPDATE_SELECTED, [true, uri]);
    this.selectManager?.toggle(uri, true);
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [uri, true]);
  }

  private updateSelectedItemIndex(uri: string): void {
    if (this.isShowSerialNum) {
      if (this.isFromPickerView) {
        this.selectedItemIndex = this.selectManager?.getShowIndexByUri(uri) ?? Constants.INVALID;
      } else {
        this.selectedItemIndex = this.selectManager?.getSelectItemIndexByUri(uri) ?? Constants.INVALID;
      }
    }
    Log.info(TAG, 'updateSelectedItemIndex: ' +
    this.isFromPickerView + ` selectedItemIndex = ${this.selectedItemIndex}`);
  }

  async photoChangedByMediaItem(mediaItem: MediaItem, isPickerEditorExit?: boolean): Promise<void> {
    Log.info(TAG,
      `photoChangedByMediaItem, mediaItem uri is ${mediaItem.uri}, isPickerEditorExit is ${isPickerEditorExit}`);
    if (this.dataSource.getSelectMode()) {
      this.currentIndex = this.dataSource.getDataIndex(mediaItem);
    } else {
      this.currentIndex = this.dataSource.getDataIndexByUri(this.photoUnEdit?.uri ?? '');
      // 先暂时不更新编辑图片 this.photoUnEdit = mediaItem;
    }

    let currentPhoto = mediaItem;
    try {
      this.canEdit =
        (this.canEditVideo ||
          currentPhoto.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) &&
          LocalStorage.getShared()?.get<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE) as boolean &&
          await UiUtil.isEditedEnable(currentPhoto);
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
      this.canEdit = false;
    }

    if (currentPhoto === undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri) ?? false;
      this.currentUri = currentPhoto.uri;

      let dataSourceIndex =
        this.isSelectMode ?
          (this.selectManager?.getSelectItemDataSourceIndex(currentPhoto) ?? Constants.INVALID) : this.currentIndex;
      let timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex);

      if (this.geometryTransitionId !== undefined && this.geometryTransitionId !== '') {
        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', timelineIndex as number);
        this.geometryTransitionId = PickerInstanceUtil.getPickerId() + this.browserController.pageFrom +
        currentPhoto.getHashCode();
        Log.info(TAG, `onPhotoChanged, index: ${this.currentIndex}, currentPhoto: ${currentPhoto.uri}, \
        geometryTransitionId = ${this.geometryTransitionId}, placeholderIndex = ${timelineIndex}`);
      }

      if ((this.totalSelectedCount < this.maxSelectCount || currentPhoto.getIsMovingPhoto()) && !isPickerEditorExit) {
        // 根据滑动方向 以及当前的位置 处理
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, [this.currentUri]);
      }
    }
  }

  selectStateChange(isDeselectAll? : boolean): void {
    Log.info(TAG, 'change selected.');
    let currentPhoto = this.getCurrentPhoto();
    if (!currentPhoto) {
      return;
    }
    if (this.totalSelectedCount >= this.maxSelectCount && !this.isSelected &&
      (this.maxSelectedReminderMode === undefined || this.maxSelectedReminderMode === Constants.TOAST_REMIND_MODE)) {
      UiUtil.showToast($r('app.string.up_to_limit_tips'));
      return;
    }
    if (isDeselectAll) {
      this.isSelected = false;
    } else {
      this.isSelected = !this.isSelected;
    }
    if (this.isSelected) {
      this.broadCast.emit(BroadCastConstants.SELECT, [0, this.currentUri, true]);
      this.broadCast.emit(Constants.UPDATE_SELECTED, [true, this.currentUri]);
      this.selectManager?.toggle(currentPhoto.uri, true);
    } else {
      this.broadCast.emit(BroadCastConstants.SELECT, [0, this.currentUri, false]);
      this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.currentUri]);
      this.selectManager?.toggle(currentPhoto.uri, false);
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;

    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [currentPhoto.uri, this.isSelected]);
  }

  selectStateChangeEdit(uri: string): void {
    if (!uri) {
      Log.info(TAG, 'selectStateChangeEdit uri is null');
      return;
    }
    let newIndex = this.dataSource.getDataIndexByUri(uri);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex?.(newIndex);
    if (currentPhoto?.getIsMovingPhoto() && this.currentUri === uri) {
      Log.info(TAG, 'moving photo repeated invocation');
      return;
    }
    let oldSelectedMovingPhotoUri = this.getOldSelectedMovingPhotoUri(currentPhoto);
    if (!this.isMultiPick) {
      if (!currentPhoto?.getIsMovingPhoto()) {
        return;
      }
    } else {
      if (this.totalSelectedCount === this.maxSelectCount) {
        let containsUri = this.selectManager?.selectedMap?.has(uri);
        if (containsUri) {
          Log.info(TAG, 'Maximum number of items selected');
          return;
        } else if (!oldSelectedMovingPhotoUri) {
          if (this.isFromPickerView) {
            let storage = LocalStorage.getShared();
            PickerUtil.exceedMaxSelectedSendData(this.newMediaItem, this.selectManager,
              this.selectManager?.selectParam, storage);
          }

          UiUtil.showToast($r('app.string.up_to_limit_tips'));
          return;
        } else {
          Log.info(TAG, 'deal moving photo edit');
        }
      }
    }
    Log.info(TAG, 'change selected.');
    this.isSelected = true;
    Log.info(TAG, `selectStateChangeEdit index ${newIndex}`);
    let isSelectedBeforeEdit: boolean = this.selectManager?.isItemSelected(this.uriBeforeEdit) ?? false
    this.selectManager?.toggleEdit(uri, isSelectedBeforeEdit, newIndex, oldSelectedMovingPhotoUri);
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;

    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [uri, this.isSelected]);
  }

  private getOldSelectedMovingPhotoUri(currentPhoto: MediaItem | undefined): string {
    let oldUri: string = '';
    let isCurrentPhotoSelected = this.selectManager?.selectedMap?.has(this.currentUri);
    if (currentPhoto?.getIsMovingPhoto() && isCurrentPhotoSelected) {
      oldUri = this.currentUri;
    }
    return oldUri;
  }

  unSelectEditPhoto(): void {
    Log.info(TAG, 'unSelectEditPhoto.');
    if (this.photoUnEdit?.uri) {
      this.selectManager?.toggleEdit(this.photoUnEdit?.uri, false);
    }
    this.isSelected = false;
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change`);
  }

  selectCallback(position: number, key: string, value: boolean): void {
    this.updateSelectedItemIndex(key);
    if (key === this.currentUri) {
      this.isSelected = value;
    }
    this.selectManager?.toggle(key, value);
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after select callback`);
  }

  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow() {
    Log.debug(TAG, `onPageShow this.mTransition ${this.mTransition}`);
    // hide status bar
    getScreen().setSystemUi(false);
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.mTransition]);

    this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [this.swiperDuration]);
    // 当视频正在播放是时候，回到后台，再回到前台的时候，需要继续播放
    if (this.videoPlayController && this.isShowVideo && this.isVideoHide) {
      this.videoPlayController?.play();
      this.isVideoHide = false;
    }
    this.isActive = true
  }

  onPageHide() {
    Log.debug(TAG, `onPageHide this.mTransition ${this.mTransition}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.mTransition]);
    // 当视频正在播放的时候，从前台变成后台的时候，需要暂停播放
    if (this.videoPlayController && this.isShowVideo &&
      this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING) {
      Log.info(TAG, `photoBrowser onPageHide${this.videoPlayController?.getAvPlayerState()}`);
      this.videoPlayController?.pause(PauseReason.PICKER);
      this.isVideoHide = true;
    }
    this.isActive = false
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, fromMsg(BigDataConstants.BY_CLICK));
      this.onBackPress();
      return;
    } else if (action.actionID === Action.MATERIAL_SELECT.actionID) {
      Log.info(TAG, 'click UN_SELECTED');
      this.selectStateChange();
      return;
    } else if (action.actionID === Action.SELECTED.actionID) {
      Log.info(TAG, 'click SELECTED');
      this.selectStateChange();
      return;
    } else if (action.actionID === Action.OK.actionID) {
      Log.info(TAG, 'click OK');
      if (this.isFromFa) {
        this.setFAPickResult();
      } else if (!this.isImmersiveCompared && !this.isCollagePageEnter &&
      this.isPhotoInner && !this.isHighlightPickerView) {
        this.broadCast?.emit(Constants.UPDATE_SHEET_STATE, [false]);
        this.okFunc?.();
        return;
      } else {
        this.setPickResult();
      }
    } else if (action.actionID ===
    Action.SOUND_FILLED.actionID || action.actionID === Action.SOUND_OFF_FILLED.actionID) {
      this.isMute = !this.isMute;
    } else if (action.actionID === Action.VIDEO_PAUSE.actionID || action.actionID === Action.VIDEO_PLAY.actionID) {
      if (this.isVideoPlaying) {
        Log.info(TAG, 'play');
        this.videoPlayController?.play();
        this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
      } else {
        Log.info(TAG, 'pause');
        this.videoPlayController?.pause(PauseReason.PICKER);
        this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
      }
      this.isVideoPlaying = !this.isVideoPlaying;
      this.updateMenu();
    } else if (action.actionID === Action.PHONE_ROTATE.actionID) {
      this.doRotateAction();
    } else if (action.actionID === Action.DESELECT_ALL.actionID) {
      //取消选择
      this.selectManager?.deSelectAll();
      this.selectStateChange(true);
    } else if (action.actionID === Action.CANCEL.actionID) {
      if (this.isPickerUsedSubwindow) {
        this.broadCast.emit(BroadCastConstants.CANCEL_PICKER_OPERATION, []);
      }
    }
  }

  private doRotateAction(): void {
    if (this.isHorizontal) {
      Log.info(TAG, 'isHorizontal');
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
    } else {
      Log.info(TAG, 'isHorizontal not');
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
    }
  }

  private initVideoPlay(videoPlayController: VideoPlayController): void {
    this.videoPlayController = videoPlayController;
  }

  /**
   * 点击视频播放回调
   * @param playVideoModel  AVPlay 的控制器
   */
  private videoPlayListener() {
    Log.info(TAG, 'VideoPlayListener start ');
    this.isShowVideo = true;
    this.hideBars();
    this.updateMenu();
  }

  /**
   * 视频播放完成后的回调
   */
  private videoPlayCompleted() {
    this.showBars();
    Log.info(TAG, 'VideoPlayCompleted start ');
    this.updateVideoState();
  }

  /**
   * 视频切换的回调
   */
  private videoPlaySwiperIndexChanged() {
    Log.info(TAG, 'VideoPlaySwiperIndexChanged start ');
    this.updateVideoState();
  }

  /**
   * 更新下张照片选择状态
   */
  private swiperSelectChanged(index: number) {
    this.targetIndex = index;
    let mediaItem = this.dataSource.getData(index)?.item;
    if (mediaItem?.uri) {
      this.updateSelectedItemIndex(mediaItem.uri);
      this.updateRepeatPickTimes(mediaItem.uri);
      this.isSelected = this.selectManager?.isItemSelected(mediaItem.uri) ?? false;
    }
    Log.info(TAG, 'this.isSelected：' + this.isSelected + ` index：${index}`);
  }

  private updateRepeatPickTimes(uri: string): void {
    if (!this.isRepeatSelectSupported) {
      return;
    }
    let updateRepeatPickTimes = 0;
    this.selectManager?.getSelectUris().forEach(item => {
      if (item === uri) {
        updateRepeatPickTimes++;
      }
    })
    this.repeatPickTimes = updateRepeatPickTimes;
  }

  private updateSwiperAnimationState(isInSwiperAnimation: boolean) {
    this.isInSwiperAnimation = isInSwiperAnimation;
  }

  updateMenu(): void {
    let list: Action[] = [];
    let actionbarList: Action[] = [];
    if (this.isShowVideo) {
      list.push(this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED,
        this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY, DeviceInfo.isPc() ? Action.NONE :
        Action.PHONE_ROTATE_INVALID);
      actionbarList.push(this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED,
        this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY, DeviceInfo.isPc() ? Action.NONE :
        Action.PHONE_ROTATE_INVALID);
    }
    this.toolMenuList = list;
    this.menuList = actionbarList;
  }

  setBroadCast(): void {
    this.broadCast.on(BrowserConstants.PULL_DOWN_START, this.funcStartPullingDown);
    this.broadCast.on(BrowserConstants.PULL_DOWN_CANCEL, this.funcCancelPullingDown);
    this.broadCast.on(BrowserConstants.TOGGLE_BAR, this.funcToggleBars);
    this.broadCast.on(BrowserConstants.HIDE_BARS, this.funcHideBars);
    this.broadCast.on(BrowserConstants.PULL_DOWN_END, this.funcEndPullingDown);
    this.broadCast.on(BrowserConstants.DATA_SIZE_CHANGED, this.funcOnDataSizeChanged);
    this.broadCast.on(BroadCastConstants.SELECT, this.funcSelectCallback);
    this.broadCast.on(BroadCastConstants.UPDATE_EDIT_ITEM, this.funcUpdateEditItem);
    this.broadCast.on(BrowserConstants.DATA_CONTENT_CHANGED, this.funcDataContentChanged);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.funcJumpBrowserCallback);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.funcOnDataReloadWithEdit);
    this.broadCast.on(BroadCastConstants.PICKER_PAGE_DISAPPEAR, this.funcPageDisappear);
    this.broadCast?.on(BroadCastConstants.UPDATE_PHOTO_BROWSER_SELECT_STATUS, this.updateSelectedFun);
    this.broadCast.on(BroadCastConstants.SELECT_CONFIRM, this.selectConfirmFun);
    this.broadCast.on(BroadCastConstants.UPDATE_SWIPER_ANIMATION_STATE, this.updateSwiperAnimationStateFunc);

    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.videoPlayListenerFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_SELECT_CHANGED, this.swiperSelectChangedFunc);
    this.broadCast.on(BroadCastConstants.CHANGE_IS_PAUSE, this.handlePauseClickFuc);
    this.broadCast.on(BroadCastConstants.UPDATE_REPEAT_PICK_TIMES, this.updateRepeatPickFun);
    this.broadCast.on(BroadCastConstants.BROWSER_ON_BACK_PRESS, this.onPhotoBrowserBackPressEventFunc);
    this.broadCast.on(BroadCastConstants.SET_PHOTO_BROWSER_ITEM, this.setPhotoBrowserItemFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_PHOTO_BROWSER_UI_ELEMENT_VISIBILITY,
      this.updateUIElementVisibilityFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_PICKER_APP_LOCK_STATUS_UPDATED,
      this.onPhotoPickerAppLockStatusUpdated);
  }

  private getPanelMarginTop(): string {
    const top: number = (this.allHeight.valueOf() as number) - (this.panelHeight.valueOf() as number) -
    this.selectTipsHeight
    Log.info(TAG, `getPanelMarginTop allHeight: ${this.allHeight} panelHeight: ${this.panelHeight} top: ${top}`);
    return top.toString();
  }

  /**
   * 更新视频状态
   */
  private updateVideoState() {
    this.isShowVideo = false;
    this.isVideoPlaying = false;
    this.updateMenu();
  }

  private onIsMuteChanged(): void {
    Log.info(TAG, `[videoPlayer] onIsMuteChanged, isMute: ${this.isMute}`);
    this.videoPlayController?.setVolume(this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
    this.updateMenu();
  }

  private reportEditDownLoadErrorInfo(err: string): void {
    ReportToBigDataUtil.downloadOriginReport(BigDataConstants.DOWNLOAD_FOR_EDIT, Date.now() - this.startEditTime, err);
    if (err) {
      return;
    }
    let msg: MsgDownloadFinish = {
      scene: BigDataConstants.DOWNLOAD_FOR_EDIT,
      network: this.networkAvailable ? BigDataConstants.NETWORK_AVAILABLE : BigDataConstants.NETWORK_UNAVAILABLE,
      size: this.getCurrentPhoto()?.size ?? Number.NaN,
      timeCost: Date.now() - this.startEditTime,
    }
    this.isRemoteResource = false;
    ReportToBigDataUtil.report(BigDataConstants.DOWNLOAD_ORIGIN_PHOTO_ID, msg);
  }

  getCurrentPhoto(): MediaItem | undefined {
    Log.debug(TAG, `getCurrentPhoto  ${this.currentIndex}`);
    return this.dataSource.getData(this.currentIndex)?.item;
  }

  private getPhotoByIndex(index: number): MediaItem | undefined {
    return this.dataSource.getRawData(index)?.data;
  }

  getCurrentPhotoInTimeLine(): MediaItem | undefined {
    return this.getCurrentPhotoInTimeLineByIndex(this.currentIndex);
  }

  getCurrentPhotoInTimeLineByIndex(index: number): MediaItem | undefined {
    return this.dataSource.getDataInTimeLine(index)?.item;
  }

  onBackPress() {
    if (!this.isPageDisappear) {
      this.selectManager?.refreshData();
    }
    if (this.isShowVideo) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    }
    getScreen().setSystemUi(!this.isHorizontal);
    if (this.geometryTransitionInitial && this.geometryEnable) {
      Log.info(TAG, 'onBackPress sta1');
      this.controller.finishAnimation((): void => this.onBackPressInner());
    } else {
      Log.info(TAG, 'onBackPress sta2');
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
      this.sendPhotoBrowserStateChangedData();
      this.browserController.hideBrowserImmediately();
    }
    if (this.isImageDownloading) {

    }
    Log.info(TAG, `onBackPress currentIndex: ${this.currentIndex}`);
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      let index: number = this.currentIndex ?? 0;
      AccessibilityUtil.sendFocusAccessibilityEvent(`ImageGridItem_Column_${index}`, ACCESSIBILITY_FOCUS_DELAY);
    }
    return true;
  }

  @Builder
  buildActionBar() {
    ThirdSelectedPageActionBar({
      leftAction: Action.BACK,
      isSelectPhotoGrid: true,
      title: this.title,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      totalSelectedCount: $totalSelectedCount,
      isSearchEnabled: false,
      isFromPickerView: this.isFromPickerView,
      moreMenuList: this.moreMenuList,
      isNeedShowPrivacyMask: !this.isPhotoInner,
      changePrivacyViewStatus: this.changePrivacyViewStatus,
      privacyOptionsText: this.privacyOptionsText,
      pickerController: this.thirdSelectController,
    })
      .translate({x: this.translateX})
      .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      .opacity(this.geometryOpacity)
      .hitTestBehavior(HitTestMode.Transparent)
      .transition(TransitionEffect.asymmetric(
        BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
        this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
      ))
      .enabled(!this.isPullDownAndDragPhoto)
      .height(this.isVerdeFoldable ? Constants.ActionBarHeight : $r('app.float.picker_action_bar_height'))
  }

  @Builder
  buildPhotoBrowserArea() {
    Stack({ alignContent: Alignment.TopEnd }) {
      PickerPhotoBrowserBg({
        isShowBar: $isShowBar,
      })
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.asymmetric(
          BrowserConstants.PICKER_BROWSER_BACKGROUND_OPEN_EFFECT,
          this.browserController.isDrag ? TransitionEffect.opacity(0) :
          BrowserConstants.PICKER_BROWSER_BACKGROUND_CLOSE_EFFECT
        ))
        .enabled(!this.isPullDownAndDragPhoto && !this.browserController.isAnimating)
        .height(!this.isPickerSplitScreen ? this.maxImageHeight : this.getPickerPhotoBrowserBgHeight())

      this.buildPhotoDisplayArea();
    }
    .width('100%')
    .height('100%')
    .margin({
      top: this.isVerdeFoldable ? Constants.ActionBarHeight :
        !this.isPickerSplitScreen ? 0 : $r('app.float.picker_action_bar_height'),
    })
    .padding({
      top: this.isVerdeFoldable ? Constants.ActionBarButtonPadding : 0,
    })
  }
  private getPanelMargin(): number {
    return this.maxImageHeight + this.panelMargin;
  }
  @Builder
  buildSelectBar() {
    if (this.isNeedSelectBar) {
      WithTheme({ theme: this.colorTheme }) {
        if (this.isPickerUsedSubwindow) {
          Column() {
            this.buildPanel();
          }
          .transition(TransitionEffect.asymmetric(
            BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
            this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
          ))
          .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
          .opacity(this.geometryOpacity)
          .backgroundColor(Color.Transparent)
          .panelStyle()
          .position({ bottom: 0 })
        } else {
          Column() {
            this.buildPanel();
          }
          .panelStyle()
        }
      }
    }
  }


  @Styles
  panelStyle() {
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (newValue.height !== undefined && (oldValue.height === 0 ||
        (newValue.height > 0 && newValue.height !== oldValue.height))) {
        this.panelHeight = newValue.height;
        this.panelMarginTop = this.getPanelMarginTop();
      }
    })
    .margin({top: !this.isPickerSplitScreen ? this.getPanelMargin() : 0})
    .position({
      bottom: this.isVerdeFoldable || this.isPickerUsedSubwindow ? 0 : this.footerNavigationHeight
    })
  }

  @Builder
  buildCommonPhotoBrowserPage() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.buildActionBar();
      if (!this.isPickerSplitScreen) {
        Scroll(this.scroller) {
          // 大图
          this.buildPhotoBrowserArea();

        }
        .scrollBar(BarState.Auto)
        .scrollable(ScrollDirection.Vertical)
        .height(this.maxStackHeight)
        .margin({top: this.pickerMarginTop, bottom: this.footerHeight})
      } else {
        this.buildPhotoBrowserArea();

        this.buildSelectBar();
      }


      if (this.isPickerMaskLayerShow) {
        Column() {
          PhotoPickerMaskLayer({
            isPickerMaskLayerShow: this.isPickerMaskLayerShow,
            photoBrowserBackgroundColorMode: this.photoBrowserBackgroundColorMode,
          })
        }
        .margin({
          top: this.isVerdeFoldable ? Constants.ActionBarHeight : $r('app.float.picker_action_bar_height'),
        })
      }

      if (!this.browserController.isAnimating && !this.isVerdeFoldable && !this.isPickerUsedSubwindow) {
        Column() {
          PickerSelectTip()
        }
        .opacity(this.geometryOpacity)
        .width('100%')
        .position({
          bottom: (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
          this.footerNavigationHeight : FOOTER_SAFETY_HEIGHT)
        })
      }
    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (newValue.height) {
        Log.info(TAG, `all onSizeChange oldValue: ${JSON.stringify(oldValue)} newValue: ${JSON.stringify(newValue)}`)
        this.allHeight = newValue.height;
        this.panelMarginTop = this.getPanelMarginTop();
        this.pickerPhotoBrowserHeight = this.getPhotoDisplayAreaHeight();
      }
    })
    .height('100%')
  }

  // 大图组件
  @Builder
  buildComponentPhotoBrowserPage() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景板
      Column() {
      }
      .backgroundColor($r('sys.color.background_primary'))
      .width('100%')
      .height('100%')
      .opacity(this.geometryOpacity)
      .transition(TransitionEffect.asymmetric(
        BrowserConstants.OPEN_EFFECT,
        this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
      ))
      .enabled(!this.isPullDownAndDragPhoto)


      // 大图
      Stack({ alignContent: Alignment.Center }) {
        this.buildPhotoDisplayArea();
      }
      .width('100%')
      .height('100%')

      if (this.isBackButtonVisible) {
        this.buildBackButton();
      }
      if (this.isPickerMaskLayerShow) {
        PhotoPickerMaskLayer({
          isPickerMaskLayerShow: this.isPickerMaskLayerShow,
          photoBrowserBackgroundColorMode: this.photoBrowserBackgroundColorMode,
        })
      }
    }
    .margin(this.photoBrowserMargin)
  }

  @Builder
  buildBackButton() {
    ThirdSelectedPageActionBar({
      leftAction: Action.BACK,
      isSelectPhotoGrid: true,
      title: this.title,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      totalSelectedCount: $totalSelectedCount,
      isSearchEnabled: false,
      isFromPickerView: this.isFromPickerView,
      moreMenuList: this.moreMenuList,
      isNeedShowPrivacyMask: !this.isPhotoInner,
      changePrivacyViewStatus: this.changePrivacyViewStatus,
      privacyOptionsText: this.privacyOptionsText,
      pickerController: this.thirdSelectController,
    })
      .opacity(this.geometryOpacity)
      .transition(TransitionEffect.asymmetric(
        BrowserConstants.OPEN_EFFECT,
        this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
      ))
      .enabled(!this.isPullDownAndDragPhoto)
      .hitTestBehavior(HitTestMode.Transparent)
  }

  @Builder
  selectedCheckBox() {
    Column() {
      Text(`${this.selectedItemIndex + 1}`)
        .fontColor((this.isFromPickerView && this.checkboxTextColor != '')
          ? this.checkboxTextColor : $r('app.color.white'))
        .fontSize(this.selectedItemIndex > 98 ?
        $r('app.float.multiple_pick_small_font_size') : $r('app.float.multiple_pick_normal_font_size'))
    }
    .height($r('app.float.checkbox_base_size'))
    .width($r('app.float.checkbox_base_size'))
    .backgroundColor((this.isFromPickerView && this.checkBoxColor != '')
      ? this.checkBoxColor
      : $r('sys.color.ohos_id_color_activated'))
    .margin({
      bottom: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_vertical_l'),
      right: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_horizontal_l'),
    })
    .border({
      width: $r('app.float.checkbox_selected_border_width'),
      radius: $r('app.float.checkbox_border_radius'),
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // picker大图右下角
  @Builder
  checkBox() {
    Stack() {
      if (this.isRepeatSelectSupported && this.repeatPickTimes > 1) {
        this.buildRepeatHint() //单张图片多选右上角增加提示框
      } else if (this.isShowSerialNum && this.selectedItemIndex > Constants.INVALID &&
        !this.isRepeatSelectSupported && this.isMultiPick) {
        this.selectedCheckBox();
      } else {
        Stack() {
          Checkbox({ name: 'checkbox', group: 'checkboxGroup' })
            .margin(0)
            .select(this.isSelected)
            .key(`Checkbox_${this.currentIndex}`)
            .accessibilityLevel('no')
            .hitTestBehavior(HitTestMode.None)
            .backgroundColor(!this.isSelected ? $r('app.color.color_notify') : $r('app.color.transparent'))
            .opacity(this.isSelected ? $r('app.float.no_opacity') : $r('sys.float.alpha_20'))
            .border({
              radius: $r('app.float.checkbox_border_radius'),
            })
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
            if (AccessibilityUtil.isOpenTouchGuideSync()) {
              this.handleClick();
            }
          })
          .responseRegion({
            x: '100%',
            y: '100%',
            width: $r('app.float.checkbox_base_size'),
            height: $r('app.float.checkbox_base_size'),
          })
        }
        .margin({
          bottom: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_vertical_l'),
          right: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_horizontal_l'),
        })
      }
    }
  }

  @Builder
  private buildRepeatHint(): void {
    Row() {
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
    .backgroundColor($r('sys.color.icon_emphasize'))
    .border({
      width: $r('app.float.checkbox_selected_border_width'),
      radius: $r('app.float.checkbox_border_radius'),
    })
    .margin({
      bottom: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_vertical_l'),
      right: this.isSetCheckboxPosition ? 0 : $r('sys.float.ohos_id_elements_margin_horizontal_l'),
    })
  }

  @Styles
  private stylesPosition(): void {
    .position({
      x: UiUtil.isMirrorMode() ? $r('sys.float.ohos_id_elements_margin_horizontal_l') : this.isSetCheckboxPosition ? this.checkboxPosition[0] * 100 + '%' : this.isHalfScreen ? 0 : '100%',
      y: this.isSetCheckboxPosition ? this.checkboxPosition[1] * 100 + '%' : this.isHalfScreen ? 0 : '100%',
    })
    .markAnchor({
      x: UiUtil.isMirrorMode() ? 0 : this.isSetCheckboxPosition ? $r('app.float.selectPhotoBrowser_checkbox_icon_radius') : this.isHalfScreen ? $r('app.float.picker_split_screen_checkbox_size') :
      $r('app.float.picker_checkbox_size'),
      y: this.isSetCheckboxPosition ? $r('app.float.selectPhotoBrowser_checkbox_icon_radius') : this.isHalfScreen ? $r('app.float.picker_split_screen_checkbox_size') :
      $r('app.float.picker_checkbox_size')
    })
  }

  private exceedMaxSelected(): boolean {
    if (this.totalSelectedCount >= this.maxSelectCount && !this.isSelected) {
      if (this.isFromPickerView) {
        let storage = LocalStorage.getShared();
        PickerUtil.exceedMaxSelectedSendData(this.newMediaItem, this.selectManager, this.selectManager?.selectParam,
          storage);
      }
      if (this.maxSelectedReminderMode === undefined || this.maxSelectedReminderMode === Constants.TOAST_REMIND_MODE) {
        UiUtil.showToast($r('app.string.up_to_limit_tips'));
      }
      return true;
    }
    return false;
  }

  private handleClick(): void {
    Log.info(TAG, 'change selected.');
    let currentPhoto = this.getCurrentPhoto();
    if (!currentPhoto) {
      return;
    }
    if (this.exceedMaxSelected()) {
      return;
    }
    if (this.isFromPickerView) {
      if (this.isInSwiperAnimation) {
        Log.info(TAG, 'handleClick: isInSwiperAnimation');
        return;
      }
      let storage = LocalStorage.getShared();
      let isOnItemClickedSet: boolean = storage?.get<boolean>('isOnItemClickedSet') ?? false;
      if (!this.isSelected && isOnItemClickedSet) {
        this.broadCast.off(BroadCastConstants.SELECT, this.funcSelectCallback);
        this.broadCast.emit(BroadCastConstants.SELECT, [0, this.currentUri, true]);
        this.broadCast.on(BroadCastConstants.SELECT, this.funcSelectCallback);
        return;
      }
    }
    this.isSelected = this.isRepeatSelectSupported ? true : !this.isSelected;
    this.broadCast.emit(BroadCastConstants.SELECT, [0, this.currentUri, this.isSelected]);
    this.broadCast.emit(Constants.UPDATE_SELECTED, [this.isSelected, this.currentUri]);
    this.selectManager?.toggle(currentPhoto.uri, this.isSelected);
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [currentPhoto.uri, this.isSelected]);
    setTimeout(() => {
      this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, [currentPhoto?.uri]);
    }, Constants.DELAY_TWENTIETH_SECOND)
  }

  private isBuildCheckBox(): boolean {
    if (this.isMultiPick || this.isFromPickerView) {
      return true;
    }
    if (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      return true;
    }
    return false;
  }

  @Builder
  buildCheckBox() {
    if (this.isBuildCheckBox()) {
      Row() {
        this.checkBox();
      }
      .opacity(this.geometryOpacity)
      .hitTestBehavior(HitTestMode.Transparent)
      .transition(TransitionEffect.asymmetric(
        BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
        this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
      ))
      .accessibilityLevel('no')
      .enabled(!this.isPullDownAndDragPhoto)
      .onClick((): void => {
        if (!AccessibilityUtil.isOpenTouchGuideSync()) {
          this.handleClick();
        }
      })
      .stylesPosition()
    }
  }

  @Builder
  buildDownloadIcon() {
    Row() {
      this.loadingIcon();
    }
    .opacity(this.geometryOpacity)
    .hitTestBehavior(HitTestMode.Transparent)
    .transition(TransitionEffect.asymmetric(
      BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
      this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
    ))
    .enabled(!this.isPullDownAndDragPhoto)
    .stylesPosition()
  }

  @Builder
  loadingIcon() {
    Stack() {
      Image($r('app.media.shadow'))
        .width($r('app.float.loading_progress_photo_shadow'))
        .height($r('app.float.loading_progress_photo_shadow'))
      Row() {
        Progress({ value: 0, total: 100, type: ProgressType.Ring })
          .value(this.downloadProgress)
          .color(this.colorTheme?.colors?.backgroundEmphasize ?
            this.colorTheme?.colors?.backgroundEmphasize : $r('sys.color.white'))
          .backgroundColor($r('sys.color.icon_on_fourth'))
          .shadow({
            radius: 100,
            color: 'rgba(0,0,0,0.2)',
            fill: true,
            type: ShadowType.BLUR,
          })
          .height($r('app.float.checkbox_base_size'))
          .width($r('app.float.checkbox_base_size'))
          .style({ strokeWidth: 3, enableScanEffect: false, shadow: false })
          .foregroundColor(ColoringStrategy.INVERT)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .height($r('app.float.checkbox_base_size'))
    .width($r('app.float.checkbox_base_size'))
    .margin({
      bottom: $r('sys.float.ohos_id_elements_margin_vertical_l'),
      right: $r('sys.float.ohos_id_elements_margin_horizontal_l'),
    })
  }

  @Builder
  buildPanel() {
    ThirdSelectedPanel({
      maxSelectCount: this.maxSelectCount,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      isBrowserMode: true,
      isMultiPick: this.isMultiPick,
      singleSelectionMode: this.singleSelectionMode,
      mTransition: TAG,
      isFromFa: this.isFromFa,
      currentUri: this.currentUri,
      isShowBar: $isShowActionBar,
      totalSelectedCount: $totalSelectedCount,
      totalCount: this.totalCount,
      needInit: true,
      panelId: this.panelId,
      isSetOriginal: this.isSetOriginal,
      isShowImage: true,
      isOriginalSupported: this.isOriginalSupported,
      colorTheme: this.colorTheme,
      isImmersiveCompared: this.isImmersiveCompared,
      isCollagePageEnter: this.isCollagePageEnter,
      completeButtonText: this.completeButtonText,
      isButtonEnabledInSingleMode: this.isButtonEnabledInSingleMode,
      isVerdeFoldable: this.isVerdeFoldable,
      browserController: this.browserController,
      showTitle: this.isFromPickerView || this.isMultiPick
    })
      .hitTestBehavior(HitTestMode.Transparent)
      .enabled(!this.isPullDownAndDragPhoto)
      .width('100%')
  }

  @Builder
  buildSelectPhotoPrivacyBase(): void {
    ThirdSelectPhotoPrivacyBase({
      totalSelectedCount: this.totalSelectedCount,
      changePrivacyOptionsText: this.changePrivacyOptionsText,
      photoBrowserBarAnimate: this.photoBrowserBarAnimate,
      tokenId: this.tokenId,
      bundleName: this.bundleName,
      pickerController: this.thirdSelectController,
    })
      .width('100%')
      .height('100%')
  }

  @Builder
  pageMap(name: string, param: Object) {
    if (name === 'ThirdSelectPhotoPrivacyBase') {
      this.buildSelectPhotoPrivacyBase()
    }
  }

  build() {
    if (this.isFromPickerView) {
      WithTheme({ colorMode: this.photoBrowserBackgroundColorMode }) {
        this.buildComponentPhotoBrowserPage();
      }
    } else if (DeviceInfo.isPhoneOrTablet()){
      // Navigation(this.pageInfo){
        this.buildCommonPhotoBrowserPage();
      // }
      // .hideTitleBar(true)
      // .hideToolBar(true)
      // .navDestination(this.pageMap)
    } else {
      this.buildCommonPhotoBrowserPage()
    }
  }

  private getPhotoDisplayAreaHeight(): string {
    if (this.isFromPickerView) {
      return '100%';
    }

    if (this.isVerdeFoldable) {
      let height: string = 'calc(100% - ' +
      px2vp(this.rsc.getNumber($r('app.float.picker_action_bar_height_verde_out'))) + 'vp - ' +
      px2vp(this.rsc.getNumber($r('app.float.picker_panel_title_height_verde_out'))) + 'vp';

      if (this.isMultiPick) { // 预览列表
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_panel_image_height_verde_out'))) + 'vp';
      }
      height += ')';
      Log.info(TAG, 'the height is ' + height);
      return height;
    }

    let height: string = 'calc(100% - ' +
    px2vp(this.rsc.getNumber($r('app.float.picker_action_bar_height'))) + 'vp - ' +
    px2vp(this.rsc.getNumber($r('app.float.picker_panel_title_height'))) + 'vp';
    if (this.isMultiPick) { // 预览列表
      height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_panel_image_height'))) + 'vp';
    }
    height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_select_tips_col_height'))) + 'vp';
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) { // 减去屏幕底部bar
      height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_under_bar'))) + 'vp';
    } else {
      height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_fordable_under_bar'))) + 'vp';
    }
    height += ')';
    Log.info(TAG, `the height is ${height}`);
    return height;
  }

  private getPickerPhotoBrowserBgHeight(): string {
    let height: string = 'calc(100% - ' +
    px2vp(this.rsc.getNumber($r('app.float.picker_action_bar_height'))) + 'vp'
    if (this.isPickerUsedSubwindow) {
      if (this.isMultiPick) {
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_panel_image_height'))) + 'vp';
      }
      height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_selected_panel_height'))) + 'vp';
    } else {
      if (this.isNeedSelectBar && this.isMultiPick) {
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_panel_title_height'))) + 'vp';
      }
      if (!this.isFromPickerView) {
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_select_tips_col_height'))) + 'vp';
      }
      /* instrument ignore next */
      if (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) { // 减去屏幕底部bar
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_under_bar'))) + 'vp';
      } else {
        height += ' - ' + px2vp(this.rsc.getNumber($r('app.float.picker_fordable_under_bar'))) + 'vp';
      }
      if (DeviceInfo.isVerdeFoldable()) {
        height += ' + ' + px2vp(this.rsc.getNumber($r('app.float.picker_selected_panel_height'))) + 'vp';
      }
      // 胶囊按钮为了适配适老化高度会比其他actionBar多5vp，这里需要补齐，否则背景和宫格间会留一道缝隙
      height += `+ ${Constants.ActionBarPaddingHeight}vp`;
    }
    height += ')';
    Log.info(TAG, `the height is ${height}`);
    return height;
  }

  @Builder
  buildPhotoDisplayArea() {
    // 大图
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
      .opacity(this.geometryOpacity)
      .transition(TransitionEffect.asymmetric(
        BrowserConstants.OPEN_EFFECT,
        this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
      ))

      PhotoSelectedSwiper({
        geometryTransitionPre: PickerInstanceUtil.getPickerId() + 'ThirdSelectAlbumGridBase',
        stateMachine: this.stateMachine,
        replaceUriManager: this.replaceUriManager,
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        onPhotoChanged: async (index: number): Promise<void> => await this.onPhotoChanged(index),
        onPressEnter: (): void => this.onPressEnter(),
        swiperController: this.controller,
        verifyPhotoScaledFunc: (matrix?: Matrix4.Matrix4Transit): void => this.verifyPhotoScaled(matrix),
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isRunningAnimation: $isRunningAnimation,
        isInSelectedMode: true,
        isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
        isShowBar: $isShowBar,
        pageStatus: this.pageStatus,
        isFromPickerView: this.isFromPickerView,
        isMultiPick: this.isMultiPick,
      });
      WithTheme({ theme: this.colorTheme }) {
        if (this.isRemoteResource && !this.isPhotoInner) {
          this.buildDownloadIcon();
        } else {
          if (this.isCheckboxVisible) {
            this.buildCheckBox();
          }
        }
      }
    }
    .height(!this.isPickerSplitScreen ? this.maxImageHeight : this.isPickerUsedSubwindow ?
    this.getPickerPhotoBrowserBgHeight() : (this.isFromPickerView ? undefined : this.pickerPhotoBrowserHeight))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.displayAreaWidth = newValue.width as number
    })
    if (!this.isPickerSplitScreen) {
      this.buildSelectBar();
    }
  }

  private handlePauseClick(): void {
    this.videoPlayController?.pause(PauseReason.PICKER);
    this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
  }

  @Builder
  editButton() {
    Stack() {
      Button({ type: ButtonType.Capsule, stateEffect: true }) {
        Text($r('app.string.action_edit'))
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.ohos_id_text_size_button3'))
          .maxFontScale(1.45)
          .textAlign(TextAlign.Center)
      }
      .backgroundColor('#00000000')
      .backgroundBlurStyle(BlurStyle.COMPONENT_THIN)
      .borderRadius('50%')
      .padding({
        left: $r('app.float.small_button_radius'),
        right: $r('app.float.small_button_radius'),
        top: $r('app.float.picker_button_padding_top_and_bottom'),
        bottom: $r('app.float.edit_reset_margin_bottom'),
      })
    }
    .backgroundColor('#808080')
    .borderRadius('50%')
    .transition(TransitionEffect.asymmetric(
      BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
      this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
    ))
  }

  verifyPhotoScaled(matrix?: Matrix4.Matrix4Transit): void {
    if (matrix) {
      let mat: number[] | undefined = (matrix.copy() as Matrix4x4).matrix4x4;
      if (mat) {
        let xScale: number = mat[0];
        let yScale: number = mat[5];
        Log.info(TAG, `photo in PhotoItem has Scaled x scale: ${xScale}, y scale: ${yScale}, mat: ${mat}`);
        this.isPhotoScaled = xScale != 1 || yScale != 1;
      }
    } else {
      this.isPhotoScaled = false;
      Log.info(TAG, `photo in PhotoItem has not Scaled isPhotoScaled: ${this.isPhotoScaled}`);
    }
  }

  private onBackPressInner(): void {
    let timelineIndex: number;
    if (this.isSelectMode) {
      if (!this.currentPhoto || this.currentPhoto.size === 0) {
        Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
        return;
      }
      let dataSourceIndex = this.selectManager?.getSelectItemDataSourceIndex(this.currentPhoto);
      if (!dataSourceIndex || dataSourceIndex === Constants.INVALID) {
        timelineIndex = this.dataSource.getPositionByIndex(this.currentIndex) as number;
      } else {
        timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex) as number;
      }
    } else {
      timelineIndex = this.dataSource.getPositionByIndex(this.currentIndex) as number;
    }
    Log.info(TAG, `onBackPressInner timelineIndex: ${timelineIndex}`)
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    this.sendPhotoBrowserStateChangedData();
    this.isShowEditButton = false;
    this.broadCast.emit(BroadCastConstants.UPDATE_PAGE_INDEX, [timelineIndex]);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, []);
    // vx pickerview大图返回宫格场景临时规避
    if (this.isFromPickerView) {
      this.broadCast.emit(BroadCastConstants.PREVIEW_EXIT_PHOTO_BROWSER, [true])
      setTimeout((): void => {
        this.browserController.hideBrowser(timelineIndex);
        this.broadCast.emit(BroadCastConstants.PREVIEW_EXIT_PHOTO_BROWSER, [false])
      }, 40)
    } else {
      this.browserController.hideBrowser(timelineIndex);
    }
  }

  private sendPhotoBrowserStateChangedData(): void {
    let storage = LocalStorage.getShared();
    if (this.isFromPickerView) {
      try {
        let session: UIExtensionContentSession | undefined =
          storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.sendData({ 'dataType': 'onPhotoBrowserStateChanged', 'isEnter': false, 'duration': 400 })
      } catch (err) {
        let error = err as Error;
        Log.error(TAG, `onBackPressInner sendData fail, name: ${error.name}, msg: ${error.message}`);
      }
    }
  }

  private jumpBrowserCallback(showCancel: boolean, name: string, item: MediaItem, isSelectMode = false,
    isFromPanel?: boolean): void {
    Log.info(TAG, `jumpBrowserCallback item: ${JSON.stringify(item)}, isFromPanel=${isFromPanel}`);
    if (item?.getIsMovingPhoto()) {
      Global.setString('previewClickMovingPhoto', item.uri);
    }
    this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.currentIndex]);
    this.showCancel = showCancel;
    if (this.dataSource.getSelectMode()) {
      this.jumpBrowserInSelectMode(item);
    } else {
      this.jumpBrowserInUnselectMode(item, isFromPanel);
    }
    this.photoUnEdit = item;
  }

  private jumpBrowserInUnselectMode(item: MediaItem, isFromPanel?: boolean) {
    if (this.selectManager) {
      this.dataSource.setSelectMode(this.selectManager);
    }
    Log.info(TAG, `currentIndex: ${this.currentIndex}`);
    if (this.currentIndex === Constants.NOT_FOUND && !this.isFromPickerView) {
      Log.info(TAG, `currentIndex not found, convert to select mode`)
      this.dataSource.setSelectMode(this.selectManager, true);
      this.jumpBrowserInSelectMode(item);
    } else if (this.dataSource.getAllMode()) {
      this.dataSource.setSelectMode(this.selectManager);
      this.jumpBrowserInSelectMode(item);
    } else {
      Log.info(TAG, `jumpBrowserInUnselectMode, currentIndex: ${this.currentIndex}`);
      this.refreshDataIndex(item, isFromPanel);
    }
  }

  private jumpBrowserInSelectMode(item: MediaItem) {
    if (this.dataSource && item && this.currentUri != item.uri) {
      let tgtIndex = this.dataSource.getDataIndex(item);
      Log.info(TAG, `jumpBrowserInSelectMode, jump to item.uri: ${item.uri}, jump to index: ${tgtIndex}, ` +
        `currentUri: ${this.currentUri}, this.currentIndex:${this.currentIndex}`);
      let jumpIndex: number = this.dataSource.getSelectMode() ? tgtIndex : this.currentIndex;
      this.onPhotoChanged(jumpIndex);
      this.dataSource.onDataReloaded();
    }
  }

  private refreshDataIndex(item: MediaItem, isFromPanel?: boolean): void {
    if (isFromPanel) {
      if (this.currentIndex === Constants.NOT_FOUND) {
        this.dataSource?.getItemIndexByUri(item?.uri ?? '', (index: number): void => {
          this.broadCast.emit(BroadCastConstants.PICKER_NOTIFY_SCROLL_INDEX, [index]);
          this.dataSource?.updateSlidingWindow(index);
          this.currentIndex = index;
          this.onPhotoChanged(this.currentIndex);
        });
      } else {
        this.onPhotoChanged(this.currentIndex);
      }
    } else {
      this.onPhotoChanged(this.currentIndex);
    }
  }

  // setPhotoBrowserItem是通过broadCast事件触发的，targetIndex可能为undefined
  private setPhotoBrowserItem(uri: string, targetIndex: number): void {
    Log.info(TAG, `setPhotoBrowserItem uri: ${uri}, targetIndex=${targetIndex}`);
    let tgtIndex: number = this.dataSource.getDataIndexByUri(uri);
    this.currentIndex = targetIndex ?? tgtIndex;
    if (tgtIndex === Constants.NOT_FOUND) {
      this.dataSource.getMediaItemByUri(uri, (mediaItem: MediaItem): void => {
        if (mediaItem) {
          this.jumpBrowserCallback(false, '', mediaItem, this.dataSource.getSelectMode());
        }
      })
      Log.info(TAG, 'item is not in current album or over 500');
    } else {
      let item: MediaItem | undefined = undefined;
      if (this.isSelectMode) {
        item = this.dataSource.getSelectedItem(tgtIndex);
      } else {
        item = this.dataSource?.getItemByUri(uri);
      }
      if (this.dataSource.getAllMode() && !item?.uri) {
        item = this.selectManager?.getSelectedItem(uri);
      }
      Log.debug(TAG, `isSelectMode is ${this.isSelectMode}, item is ${item?.uri}`);
      if (item) {
        this.jumpBrowserCallback(false, '', item, this.dataSource.getSelectMode());
      }
    }
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  private toImmersiveComparedPage(arr: MediaItem[]) {
    const verify = new Verify(this.broadCast);
    arr = arr.filter(item => this.selectManager?.isSelected(item?.uri));
    verify.photoVerification(arr);
    this.navPageInfos?.pop();
  }

  private async toCollagePage(currentItem: MediaItem): Promise<void> {
    if (!currentItem) {
      return;
    }
    const isRemoteResource: boolean = false;
    if (isRemoteResource) {
      // 原图只在云端，需要先下载
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
      this.handleEnterCollagePage(currentItem);
    }
    if (isRemoteResource) {
      this.broadCast.emit(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, [currentItem.uri]);
    } else {
      this.handleEnterCollagePage(currentItem);
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
    this.navPageInfos?.pop();
  }

  private queryPickedMediaInfo(): PickedMediaInfo | undefined {
    let pickedMediaInfo: PickedMediaInfo = new PickedMediaInfo();
    let isSingleSelectHybridMode: boolean = (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE);
    if (this.isMultiPick || isSingleSelectHybridMode) {
      if (this.selectManager === null) {
        Log.error(TAG, 'Select Manager empty');
        return undefined;
      }
      if (this.selectManager?.isPreview ?? false) {
        pickedMediaInfo.uriArray = SelectUtil.getUriArray(this.selectManager?.previewSet ?? new Set());
      } else {
        pickedMediaInfo.uriArray = SelectUtil.getUriArray((this.selectManager?.clickedSet ?? new Set()) as Set<string>);
      }
      if (this.selectManager !== undefined) {
        pickedMediaInfo.mediaArray = this.selectManager.getSelectItems();
      }
      Log.info(TAG, `uri size: ${pickedMediaInfo.uriArray}`);
    } else {
      let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
      if (currentPhoto === undefined) {
        Log.error(TAG, `currentPhoto is undefined`);
        return undefined;
      }
      pickedMediaInfo.uriArray = [currentPhoto.uri];
      pickedMediaInfo.mediaType = currentPhoto.mediaType;
      pickedMediaInfo.mediaArray = [currentPhoto];
    }
    return pickedMediaInfo;
  }

  private async setFAPickResult(): Promise<void> {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto) {
      Log.info(TAG, `setFAPickResult. updateFormData obj: ${currentPhoto.uri}  currentIndex: ${this.currentIndex}`);
      this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
        ['',
          LocalStorage.getShared()?.get<string>(FormConstants.FORM_ITEM_ALBUM_URI),
          LocalStorage.getShared()?.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
          currentPhoto.uri, false]);
    } else {
      Log.error(TAG, 'Fa setPickResult is null');
    }
    return;
  }

  private async setPickResult(): Promise<void> {
    if (this.isFromFa) {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto) {
        Log.debug(TAG, `setPickResult. updateFormData obj: ${currentPhoto.uri}  currentIndex: ${this.currentIndex}`);
        this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
          ['',
            LocalStorage.getShared()?.get<string>(FormConstants.FORM_ITEM_ALBUM_URI),
            LocalStorage.getShared()?.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
            currentPhoto.uri, false]);
      } else {
        Log.error(TAG, 'Fa setPickResult is null');
      }
      return;
    }
    let pickedMediaInfo: PickedMediaInfo | undefined = this.queryPickedMediaInfo();
    if (pickedMediaInfo === undefined) {
      return;
    }
    if (this.isCollagePageEnter) {
      let getCur: MediaItem | undefined = this.getCurrentPhoto()
      if (getCur) {
        this.onBackPress();
        this.toCollagePage(getCur);
      }
      return;
    }
    if (this.isImmersiveCompared) {
      if (this.selectManager !== undefined) {
        this.onBackPress();
        let arr: MediaItem[] = this.selectManager?.getSelectItems();
        this.toImmersiveComparedPage(arr);
      }
      return;
    }
    if (this.thirdSelectController.hasDelegate) {
      if (pickedMediaInfo.mediaArray.length > 0) {
        this.thirdSelectController.onCompleted(pickedMediaInfo.mediaArray);
      } else {
        this.thirdSelectController.onCancelled();
      }
      Log.info(TAG, `thirdSelectController: ${pickedMediaInfo.mediaArray.length}`);
    }
    let selectedMap: Map<string, MediaItem> = this.selectManager?.selectedMap ?? new Map();
    SelectUtil.getCountOfMedia(pickedMediaInfo.uriArray, selectedMap).then((result: number[]) => {
      const isOrigin: boolean = LocalStorage.getShared()?.get<boolean>(THIRD_SELECT_IS_ORIGIN) ?? false;
      const mediaType: number = pickedMediaInfo?.mediaType ?? 0;
      const isMediaTypeImage: boolean = (mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE);
      const isMediaTypeVideo: boolean = (mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
      let msg: Msg = {
        isOriginalChecked: isOrigin,
        selectItemSize: pickedMediaInfo?.uriArray.length ?? 0,
        selectImageSize: this.isMultiPick ? result[0] : (isMediaTypeImage ? 1 : 0),
        selectVideoSize: this.isMultiPick ? result[1] : (isMediaTypeVideo ? 1 : 0),
      }
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_RESULT, msg);
    });
  }


  private isUsefulNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    return nfyInfo.type === MediaObserverNfyType.PHOTO_ADD ||
      nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE || nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE ||
      nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE_ASTC;
  }
}
