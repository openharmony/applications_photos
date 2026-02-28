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

// todo lishang controller类需要被重构，逐步进行，相机使用的接口需要保留，待相机切换后删除
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AddMenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/AddMenuOperation';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BusinessError, power } from '@kit.BasicServicesKit';
import lazy {
  AlbumSetNewMenuOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/AlbumSetNewMenuOperation';
import lazy {
  BigDataConstants,
  EnvMsg,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { MsgDownloadFinish } from '@ohos/common/src/main/ets/default/model/common/BigDataDotting';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  Constants as BrowserConstants,
  EditType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { PrintUtil } from '@ohos/common/src/main/ets/default/utils/PrintUtil';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  setHorizontal,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { MenuContext, SourceSceneType } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { MenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOperation';
import lazy { MenuOperationFactory } from '@ohos/common/src/main/ets/default/interface/MenuOperationFactory';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import lazy { NetworkConnectionAccess } from '@ohos/privacy/src/main/ets/access/NetworkConnectionAccess';
import lazy { SelfObject } from '@ohos/common/src/main/ets/default/model/common/DataTypes';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Environment, PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { RenameMenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/RenameMenuOperation';
import lazy sensor from '@ohos.sensor';
import lazy window from '@ohos.window';
import lazy { LibraryConstants } from './LibraryConstants';
import lazy abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy common from '@ohos.app.ability.common';
import lazy Want from '@ohos.app.ability.Want';
import lazy { AvPlayConstants, AvplayerStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { SandboxObjectImpl } from './browser/photo/SandboxObjectImpl';
import lazy { SandboxDataSource } from './browser/photo/SandboxDataSource';
import lazy display from '@ohos.display';
import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { StartOptions } from '@kit.AbilityKit';
import lazy { userFileManager } from '@kit.CoreFileKit';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { MenuOptionOtherParams } from '@ohos/common/src/main/ets/default/view/browserOperation/interfaces';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { image } from '@kit.ImageKit';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { FastPhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/FastPhotoDataSource';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { ShowBrowserParam, BrowserCaller } from './ShowBrowserParam';
import lazy {
  EnterInfoFace,
  ParamBrowser,
  PhotoBrowserUtils
} from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy { isSublist } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy { MediaLibraryData } from '@ohos/common/src/main/ets/default/model/browser/photo/data/MediaData';
import lazy { MediaOperationType } from '@ohos/common/src/main/ets/default/model/common/MediaOperationType';
import lazy { EditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy {
  PhotoAccessHelperAccess,
  PhotoAlbum
} from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { ShortCut } from '@ohos/common/src/main/ets/default/model/ShortCut';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { PositionParams } from '@ohos/common/src/main/ets/default/view/browserOperation/DeleteMenuOperation';
import lazy { PhotoPropertiesUtil } from '@ohos/common/src/main/ets/default/utils/PhotoPropertiesUtil';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
import lazy { UpdateMenuParamCamera } from './BrowserMenuController';
import lazy { JumpType } from './LibraryConstants';
import lazy { PhotoBrowserGetCameraAlbum } from './PhotoBrowserGetCameraAlbum';
import lazy { ThirdMoreMenuController } from './ThirdMoreMenuController';
import lazy { EditorController } from 'browsercommonphone';
import lazy { UriDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/UriDataSource';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy utd from '@ohos.data.uniformTypeDescriptor';
import lazy { uriPermissionManager, wantConstant } from '@kit.AbilityKit';
import lazy { SwingServiceController } from '@ohos/browsercommon/src/main/ets/default/utils/SwingServiceHelper'
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';
import lazy { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { IdGenerator } from '@ohos/common/src/main/ets/default/utils/IdGenerator';
import lazy { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import lazy { LIST_CACHE_COUNT } from '../view/SwiperView';
import lazy { WallpaperEditorComponent } from '@ohos/common/src/main/ets/default/view/WallpaperEditorComponent';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { BrowserControlInterface } from '@ohos/common/src/main/ets/default/interface/BrowserControlInterface';
import lazy {
  RemoveFromGroupOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/RemoveFromGroupOperation';
import lazy { WallpaperUtils } from '@ohos/common/src/main/ets/default/utils/WallpaperUtils';
import lazy { EffectToggleHelper } from '@ohos/browsercommon/src/main/ets/default/utils/EffectToggleHelper';
import lazy {
  EffectPhotoContext, ShotForMoreContext
} from '@ohos/browsercommon/src/main/ets/default/utils/EffectPhotoContext';

/* instrument ignore file */
const TAG: string = 'BasePhotoBrowserController';

const CHANGE_SWIPER_DURATION: number = 400;

const SECURITY_MENU_LIST: number[] =
  [Action.EDIT.actionID, Action.GOTO_PHOTOS.actionID, Action.MOVE.actionID,
    Action.BOUNCE_PLAY.actionID, Action.MICRO_MOTION.actionID,
    Action.DYNAMIC_PANNING.actionID, Action.FLASH_CAPTURE.actionID, Action.CLOSE_FLASH_CAPTURE.actionID,
    Action.VIRTUAL_APERTURE.actionID, Action.CLOSE_VIRTUAL_APERTURE.actionID];

const PHOTO_SCALED: string = 'photo_scaled';

const DELAY_TIME: number = 100;

const DELAY_TIME_CONVERT: number = 200;
/**
 * 图片标题信息
 */
interface TitleName {
  title: string;
  displayName: string;
};

/**
 * 权限标示，新增枚举值需要乘以2递增：0x0001、0x0002、0x0004、0x0008...
 */
export enum PermissionFlag {
  READ_IMAGEVIDEO = 0x0001,
  WRITE_IMAGEVIDEO = 0x0002,
}

/**
 * 大图组件控制器，作为大图组件和其他交互的桥接层，负责大图组件公有的的数据初始化、关键回调监听、数据更新
 */
@Observed
export class BasePhotoBrowserController implements BrowserControlInterface {
  public currentItem: MediaItem | undefined;
  public browserControllerId: number = IdGenerator.generatorIdStatic();
  // 大图显示部分
  public isBrowserShow: boolean = false;
  // 非大图部分，包括actionbar、toolbar、缩略图预览条
  public isBrowserShowContent: boolean = false;
  public isAnimating: boolean = false;
  public viewAppearCount: number = 0;
  /**
   * 当前图片 index
   */
  public oldPhotoSize: number = 0;
  public broadCast: BroadCast = new BroadCast();
  public stateMachine: PhotoBrowserStateMachine = new PhotoBrowserStateMachine();
  public dataSource: PhotoDataSource = new FastPhotoDataSource(this.stateMachine);
  public uiContext: UIContext | undefined = undefined;
  // 当前外屏图片 Uri
  protected currentMediaUriOnSubScreen: string = '';
  /**
   * 图片是否被拖动标志位
   */
  public isDrag: boolean = false;
  /**
   * 数据源是否是沙箱数据
   */
  public isSandboxEnv: boolean = false;
  /**
   * 数据源是否是沙箱数据
   */
  public isHidden: boolean = true;
  /**
   * 是否展示视频按钮
   */
  private isShowVideo: boolean = false;
  private isSupportRotation: boolean = true;
  // 当前图片 Uri
  protected currentMediaUri: string = '';
  // 拉起大图组件方式
  public pageFrom: string = 'PhotoBrowserView';
  public mediaPermissionFlag: number = 0x0000;
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  // 应用级广播监听
  protected appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public isFromViewDataWithThirdUri = false;
  protected isFromViewDataWithMediaUri = false;
  public isForceShowBar = false;
  // time to view the current picture
  public checkedTransition: string = Constants.PHOTO_TRANSITION_CAMERA;
  private viewTime = 0;
  private uriFromThirdPartyApp: string = '';
  private editNewUri: string = '';
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  // Ability 上下文信息，由拉起的三方进程传入
  public abilityContext: common.UIAbilityContext;
  private mCallbacks: Map<string, Function[]> = new Map<string, Function[]>();
  private networkAvailable: boolean = false;
  private geometryTransitionId: string = '';
  // 判断三方是否使用单个固定geometryId
  private enableSingleGeometryId: boolean = true;
  // 三方提供的单个固定geometryId值
  protected singleGeometryId: string = '';
  // 图库打开相册信息
  public albumUri = '';
  public albumInfo?: AlbumInfo;
  // 时刻相册数据
  private highlightPhotoAlbum?: PhotoAlbum;
  private isMute: boolean = false;
  private isVideoPlaying: boolean = true;
  private isFullMode: boolean = true;
  private needCheckPermission: boolean = true;
  public isFoldExpanded: boolean = DeviceInfo.isFoldable();
  private curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  protected isBrowserFullShow: boolean = true;
  private isJumpToPhoto: boolean = false;
  private currentPage: string = Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER;
  private onLeftBlankChangedFunc: Function = (data: number[]): void => this.onLeftBlankChanged(data);
  private onWinSizeChangedCallBack: Function = (data: number[]): void => this.onWinSizeChanged(data);
  private onSplitModeChangedFunc: Function = (mode: boolean): void => this.onSplitModeChanged(mode);
  private QRCodeUpdateFunc: Function = (): void => this.QRCodeUpdate();
  private QRCodeGetItemFunc: Function = (callback: Function): void => this.QRCodeGetItem(callback);
  private showDeleteDialogFunc: Function =
    (deleteMessage: Resource[], confirmCallback: Function, cancelCallback: Function, isAlbumDelete: boolean,
      isExpandPositionParams: PositionParams): void => this.showDeleteDialog(
      deleteMessage, confirmCallback, cancelCallback, isAlbumDelete, isExpandPositionParams);
  private onDeviceRotateChangedFunc: Callback<sensor.OrientationResponse> =
    (data: sensor.OrientationResponse): void => this.onDeviceRotateChanged(data);
  private rotateChangeCount: number = 0;
  private rotateChangeCountMax: number = 5;
  public bundleName: string = '';
  public abilityStage: Context | undefined = undefined;
  public comparable: boolean = false;
  public comparedMediaItem: MediaItem | undefined = undefined;
  private isShowMovingPhoto: boolean | undefined = false;
  private isEnhanceTriggered: boolean = false;
  private isPlayFromInitialAnimation: boolean = false;
  public hashCode: number = 0;
  /**
   * 安全相机保存字段
   */
  protected cameraShotKey: string | undefined;
  //PC相机进大图，详情是否拉起
  public isDetailSelected: boolean = false;
  private favorCacheItemsMap = new Map<String, MediaItem>();
  public isDoDeleteAnim: boolean = false;
  protected videoPlayController?: VideoPlayController;
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);
  private onPhotoBrowserBackPressEventFunc: Function = (isNoPhotos?: boolean, isMouseScrolling?: boolean):
  boolean | void => this.onBackPress(isNoPhotos, isMouseScrolling);
  public pixmap: image.PixelMap | undefined = undefined;
  private networkConnectionStatus: boolean = true;
  public isPhotoBrowserViewShow = false;
  private showLoadingTimerId?: number;
  public isFromGalleryCleanupPage: boolean = false;
  public isPrivateHideState: boolean = false;
  public isFromPortrait: boolean = false;
  private readonly clickThrottle: Throttle<void> = new Throttle<void>(BrowserConstants.CLICK_DELETE_INTERVAL, TAG);
  private isShowBar: boolean = true;
  public isFromPortraitCard: boolean = false;
  private isFromGroup: boolean = false;

  private routeToSettingsPageFunc: Function = (componentId: string) => this.routeToSettingsPage(componentId);
  private dealMenuClickFunc: Function = (action: Action, actionId: number): void =>
    this.dealMenuClick(action, actionId);
  mSelectManager = new SelectManager();
  private operationPosition: number = BigDataConstants.OPERATION_IN_INVALID_POSITION;
  public isPullDownAndDrag: boolean = false;
  public isPhotoActive = false;
  public isStopCastSuccess = false;
  public isShowWallPaper = false;
  private initDataMoreOne = false;
  private localStorage?: LocalStorage;
  private moreMenuController: ThirdMoreMenuController = new ThirdMoreMenuController();
  /**
   * 正在执行动画，此时侧滑返回被拦截，延时200毫秒后重新触发侧滑返回操作
   */
  protected backPressOverTime: number = 0;
  private downloadFinishCallback: Function | undefined = undefined;
  private downloadCancelCallback: Function | undefined = undefined;

  //【视频】是否是支持的视频格式
  private isSupportedVideoType: boolean = true;
  //【视频】广播回调
  private setIsSupportedVideoTypeFunc: Function = (isSupportedVideoType: boolean, src: string):
    void => this.setIsSupportedVideoType(isSupportedVideoType, src);
  /**
   * 点击进行特效切换
   */
  public onEffectModeSwitchClicked: (isMovingPhoto?: boolean) => void = (isMovingPhoto: boolean = true): void => {
    if(!isMovingPhoto) {
      this.setIsPhotoSwitching(true);
      return;
    }
    Log.info(TAG, '[switchEffectMode:] onEffectModeSwitchClicked update menu.');
    this.waitingDoneCallback();
    this.waitingDoneCallback = (): void => {
    };
    this.isWaitingOnUpdateMenu = false;
  }

  // 宫格排序
  private sortHelper?: AlbumGridSortHelper;

  private QRCodeUpdate(): void {
    this.updateMenu(this.getTargetIndex());
  }

  private QRCodeGetItem(callback: Function): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getTargetIndex());
    callback(currentPhoto);
  }

  /**
   * 是否是支持的视频格式
   * @param isSupportedVideoType
   * @param src
   */
  /* instrument ignore next */
  private setIsSupportedVideoType(isSupportedVideoType: boolean, src: string): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getTargetIndex());
    if (!currentPhoto) {
      return;
    }
    if (currentPhoto.uri === src) {
      this.isSupportedVideoType = isSupportedVideoType;
    }
  }

  public setIsSupportedVideoTypeFun(isSupportedVideoType: boolean): void {
    this.isSupportedVideoType = isSupportedVideoType;
  }

  public getCurrentIndex() {
    return this.stateMachine.getCurrentIndex();
  }

  public setCurrentIndex(currentIndex: number) {
    this.stateMachine.setCurrentIndex(currentIndex);
  }

  public getTargetIndex() {
    return this.stateMachine.getTargetIndex();
  }

  public setTargetIndex(targetIndex: number) {
    this.stateMachine.setTargetIndex(targetIndex);
  }

  private initVideoPlay(vpc: VideoPlayController): void {
    Log.info(TAG, `[videoPlayer] bind controller:${vpc.getLabel()} to ${this.currentMediaUri}`);
    this.videoPlayController = vpc;
  }

  private onLeftBlankChanged(data: number[]): void {
    Log.info(TAG, `onleftBlankChanged: ${data}`);
    AppStorage.setOrCreate<number[]>('leftBlank', data);
  }

  private onSplitModeChanged(mode: boolean): void {
    Log.info(TAG, `onSplitModeChanged: ${JSON.stringify(mode)}`);
    AppStorage.setOrCreate<boolean>('isSplitMode', mode);
  }

  private onWinSizeChanged(data: number[]): void {
    Log.info(TAG, `onWinSizeChanged: ${data}`);
    AppStorage.setOrCreate<boolean>('isFullMode', getScreen().getWinMode() === WindowMode.FULLSCREEN);
    this.isFullMode = getScreen().getWinMode() === WindowMode.FULLSCREEN;
    this.updateMenu(this.getCurrentIndex());
  }

  public setWaitingDoneCallback(callback: () => void): void {
    if (this.isWaitingOnUpdateMenu) {
      this.waitingDoneCallback = callback;
    } else {
      callback();
    }
  }

  public browserAnimController: BrowserAnimController = new BrowserAnimController();
  private movingPhotoEffectMode?: number = 0;
  private isMovingPhotoSwitching: boolean = false;
  private movingPhotoMoreList: Action[] = [];
  private showMovingPhotoCloseEffect: boolean = false;
  private isWaitingOnUpdateMenu: boolean = false;
  private isMovingPhotoDownloading: boolean = false;
  private isAutoTask: boolean = false;
  private waitingDoneCallback: () => void = (): void => {
  };
  private setIsDownloadingFunc: (isDownloading: boolean, uri: string) => void =
    (isDownloading: boolean, uri: string): void => {
      this.setIsMovingPhotoDownloading(isDownloading, uri);
    }
  private onFoldDisplayChanged: (status: display.FoldDisplayMode) => void = (status: display.FoldDisplayMode) => {
    AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
    this.updateMenu(this.getCurrentIndex());
    Log.info(TAG, `fold status change getFoldStatus:${status}`);
    if (typeof this.swiperOnFoldChange === 'function') {
      this.swiperOnFoldChange();
    }
  };
  public swiperOnFoldChange: Function | undefined = undefined;

  /**
   * 大图组件控制器，使用三方传递的上下信息，完成初始化
   *
   * @param abilityContext 三方传入的 ability 上下文信息
   * @param windowStage 三方传入的窗口信息
   * @param abilityStage 三方传入的 ability 信息
   */
  constructor(abilityContext: common.UIAbilityContext, windowStage: window.WindowStage |
  undefined, abilityStage: Context) {
    this.abilityContext = abilityContext;
    this.bundleName = abilityContext.abilityInfo?.bundleName;
    this.abilityStage = abilityStage;
    this.hashCode = Date.now();
    // LocalStorage.getShared()?.setOrCreate('photoLibraryContext',
    //   abilityStage.createModuleContext('com.ohos.photobrowser', 'browserlibrary'));
    this.stateMachine.setBrowserControllerId(this.browserControllerId);
    systemParameterEnhance.get('system.photos.rotate.enable', 'true').then((value: string): void => {
      Log.info(TAG, `system.photos.rotate.enable = ${value}`);
      AppStorage.setOrCreate<boolean>(Constants.ENABLE_ROTATE, value === 'true');
    });

    systemParameterEnhance.get('system.photos.innerpic.enable', 'false').then((value: string): void => {
      Log.info(TAG, `system.photos.innerpic.enable = ${value}`);
      AppStorage.setOrCreate<boolean>(Constants.ENABLE_INNERPIC, value === 'false');
    });
  }

  private setIsMovingPhotoDownloading(isDownloading: boolean, uri: string): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex?.(this.getCurrentIndex());
    Log.info(TAG, `[movingPhoto] setIsDownloading ${uri} currentPhoto:${currentPhoto?.uri}`);
    if (currentPhoto?.uri === uri) {
      this.isMovingPhotoDownloading = isDownloading;
    }
    this.updateMenu(this.getTargetIndex());
  }

  protected showBrowserInner(param: Object, showBrowserParam?: ShowBrowserParam): void {
    if (showBrowserParam) {
      this.pageFrom = showBrowserParam.caller;
      this.singleGeometryId = showBrowserParam.geometryTransitionString;
      this.setTargetIndex(showBrowserParam.targetIndex);
      this.isFromPortrait = showBrowserParam.isFromPortrait ?? false;
      this.isFromGroup = showBrowserParam.isFromGroup ?? false;
      this.isFromPortraitCard = showBrowserParam.isFromPortraitCard ?? false;
      this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER));
      this.highlightPhotoAlbum = showBrowserParam.highlightPhotoAlbum ?? undefined;
    }
    this.browserAnimController.init(showBrowserParam?.gridController);
    this.browserAnimController.initFun(this.enterOnStartFun, this.enterOnfinishFun, this.exitOnStartFun,
      this.exitOnfinishFun);
    const paramBrowser: ParamBrowser = param as ParamBrowser;
    this.setTargetIndex(paramBrowser?.position);
    if (paramBrowser && paramBrowser.albumInfo) {
      this.albumInfo = paramBrowser.albumInfo;
      this.albumUri = paramBrowser.albumInfo.uri;
      this.sortHelper = paramBrowser.sortHelper;
    } else {
      this.albumUri = this.dataSource.getAlbumDataSource()?.albumUri ?? '';
      this.albumInfo = this.dataSource.getAlbumDataSource()?.albumInfo;
      this.sortHelper = paramBrowser.sortHelper;
    }
    if (paramBrowser.coverPhotoUri !== undefined && paramBrowser.coverPhotoUri !== null
      && this.albumInfo !== undefined && this.albumInfo !== null
      && paramBrowser.coverPhotoUri.length > 0) {
      this.albumInfo.coverPhotoUri = paramBrowser.coverPhotoUri;
    }
    Log.info(TAG, `showBrowserInner albumInfo subType:${this.albumInfo?.subType} albumUri:${this.albumUri}`);
  }

  public onViewShow(param: ParamBrowser) {
    Log.info(TAG, `onviewShow viewDataIndex:${param.viewDataIndex} isAllMediaData:${param.isAllMediaData}
      isFromPuzzle:${param.pageFrom === Constants.ENTRY_FROM.PUZZLE}`);
    // 特殊：拼图保存覆盖走photoBrowser.ets，pageFrom赋值对应caller
    if (param.pageFrom === Constants.ENTRY_FROM.PUZZLE) {
      this.pageFrom = BrowserCaller.PUZZLE_PAGE;
    } else if (param.pageFrom === Constants.ENTRY_FROM.ENTRY_FROM_MOVIE_PAGE) {
      this.pageFrom = BrowserCaller.MOVIE_PAGE;
      this.setTargetIndex(0);
    } else if (param.viewDataIndex || param.isAllMediaData) {
      Log.info(TAG, 'found viewIndex');
      this.isFromViewDataWithThirdUri = true;
      this.dataSource = new UriDataSource(this.stateMachine, String(param.viewData)
        .split('?'), UserFileManagerAccess.MEDIA_TYPE_IMAGE, undefined, undefined, param.isAllMediaData);
      let viewIndex = Number.parseInt(param.viewDataIndex);
      if (Number.isNaN(viewIndex) || viewIndex <= 0 || viewIndex > String(param.viewData).split('?').length) {
        viewIndex = 0;
      } else {
        viewIndex -= 1;
      }
      if (param.isAllMediaData) {
        MediaObserver.getInstance().registerObserver(this.dataObserver);
      }
      this.isForceShowBar = param.isAllMediaData;
      this.setTargetIndex(viewIndex);
      param.position = viewIndex;
    } else {
      if (!param.viewData || String(param.viewData).length === 0) {
        return;
      }
      if (MediaLibraryData.isMediaLibraryUri(String(param.viewData))) {
        this.isFromViewDataWithMediaUri = true;
        this.dataSource = new FastPhotoDataSource(this.stateMachine, undefined, new PhotoDataImplAsync(TAG));
        this.dataSource.enableGetData(false);
        let callerBundleName: string = AppStorage.get<string>('callerBundleName') ?? '';
        if ((!param.viewDataAlbum || param.viewDataAlbum.length === 0) && callerBundleName === 'com.ohos.camera') {
          PhotoBrowserGetCameraAlbum.getCameraAlbumInfo((albumInfo: AlbumInfo | undefined) => {
            if (albumInfo?.uri) {
              Log.info(TAG, `getSourceAlbumByCamera successes uri: ${albumInfo.uri}`);
              this.dataSource.setAlbumUri(albumInfo.uri);
            }
            this.dataSource.initData();
            if (!AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) && this.dataSource.getAlbumDataSource()) {
              Log.info(TAG, `MediaDataSource is undefined`);
              AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource.getAlbumDataSource());
            }
            UserFileManagerAccess.getInstance().onCreate(this.abilityContext);
            MediaObserver.getInstance().registerObserver(this.dataObserver);
            MediaObserver.getInstance().subscribe(this.abilityContext, TAG);
            let uri = String(param.viewData);
            this.dataSource.getItemIndexByUri(uri, (index: number) => {
              this.onGetItemIndexByUri(index, uri);
            });
          });
        } else {
          this.dataSource.initData();
          if (!AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) && this.dataSource.getAlbumDataSource()) {
            Log.info(TAG, `MediaDataSource is undefined`);
            AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource.getAlbumDataSource());
          }
          UserFileManagerAccess.getInstance().onCreate(this.abilityContext);
          MediaObserver.getInstance().registerObserver(this.dataObserver);
          MediaObserver.getInstance().subscribe(this.abilityContext, TAG);
          let uri = String(param.viewData);
          this.dataSource.getItemIndexByUri(uri, (index: number) => {
            this.onGetItemIndexByUri(index, uri);
          });
        }
      } else {
        Log.error(TAG, 'ViewData Enter Not found media library uri');
        this.dataSource = new UriDataSource(this.stateMachine, [String(param.viewData)],
          param.viewDataType,
          param.imageArea ? param.imageArea.width : 0,
          param.imageArea ? param.imageArea.height : 0);
        this.isFromViewDataWithThirdUri = true;
      }
    }
  }

  private onGetItemIndexByUri(index: number, uri: string): void {
    if (uri) {
      if (index !== -1) {
        // 三方拉起，大图显示传入的图片
        this.setCurrentIndex(index);
        this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [index]);
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.getCurrentIndex());
        this.dataSource.onDataReloaded();
      } else {
        this.dataSource.getItemIndexByUri(uri, (index: number) => {
          this.onGetItemIndexByUri(index, uri)
        })
      }
    }
  }

  /**
   * 打断大图返回动画
   */
  public cancelBrowserToGridAnim(): void {
    this.stateMachine.processExitAnimationEndEvent();
  }


  /**
   * 大图组件初始化，完成权限确认、窗口信息同步、回调注册和数据初始化工作
   *
   * @param enableSingleGeometryId 是否打开一镜到底动效
   * @param mediaUri 图片的 Uri 信息
   * todo lishang 区分相机和图库
   */
  public init(pageFrom: string, enableSingleGeometryId?: boolean, mediaUri?: string, isSandboxEnv?: boolean): void {
    this.pageFrom = pageFrom;
    if (enableSingleGeometryId !== undefined && enableSingleGeometryId !== null) {
      this.enableSingleGeometryId = enableSingleGeometryId;
    }
    UserFileManagerAccess.getInstance().onCreate(this.abilityContext);
    // 图库进入初始化相册信息
    if (pageFrom !== BrowserCaller.CAMERA_PAGE) {
      UserFileManagerAccess.getInstance().prepareSystemAlbums();
    }
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    MediaObserver.getInstance().subscribe(this.abilityContext, TAG);
    if (!(AppStorage?.get<boolean>('IsShowSearchPage') ||
      (pageFrom === BrowserCaller.PORTRAIT_PHOTO_GRID_PAGE || pageFrom === BrowserCaller.LOCATION_PHOTO_GRID_PAGE))) {
      Log.info(TAG, `initScreenManager`);
      this.initScreenManager();
    }
    global.setCtx(this.abilityContext);
    try {
      display.on('foldDisplayModeChange', this.onFoldDisplayChanged);
    } catch (err) {
      Log.error(TAG, `Display.on error: ${err}, code: ${err?.code}`);
    }

    if (pageFrom === 'TimelinePage') {
      return;
    }

    Log.info(TAG, `constructor mediaUri: ${mediaUri}, isPc: ${DeviceInfo.isPc()}, isSandboxEnv: ${isSandboxEnv},
     enableSingleGeometryId: ${enableSingleGeometryId}`);
    if (this.needCheckPermission) {
      this.verifyAccessPermission();
    }
    if (pageFrom === 'PhotoBrowserView') {
      PhotoConfig.setEnvironment(Environment.ENV_LIBRARY);
    }
    //系统音量
    AppStorage.setOrCreate<boolean>('isMute', false);
    this.initNetworkStatus();
    NetworkConnectionAccess.register();
    this.setPianoSetting();
    if (isSandboxEnv) {
      this.isSandboxEnv = isSandboxEnv;
      this.dataSource = new SandboxDataSource(this.stateMachine);
    } else {
      let listeners = this.dataSource.getAlbumDataSource()?.listeners;
      let needCreateDataSource: boolean = !listeners || listeners.length <= 0;
      if (needCreateDataSource) {
        this.dataSource = new FastPhotoDataSource(this.stateMachine, undefined, new PhotoDataImplAsync(TAG));
      }
      if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
        this.setCameraAlbumInfo(needCreateDataSource);
      } else {
        this.dataSource.initData(!needCreateDataSource);
      }
      if (mediaUri) {
        this.setCurrentMediaUriInner(mediaUri);
      }
    }
    if (this.broadCast) {
      this.dataSource.setBroadCast(this.broadCast);
      this.dataSource.setBroadCastToAlbum(this.broadCast);
    }
    let msg: EnvMsg = {
      env: isSandboxEnv ? BigDataConstants.ENV_SANDBOX : BigDataConstants.ENV_MEDIA,
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_ENV_ID, msg);
    global.setBrowserAbilityCtx(this.abilityContext);
    CommonUtil.registerProgDispSwitchObserver();
  }

  private setCameraAlbumInfo(needCreateDataSource: boolean, callback?: () => void) {
    // 相机缩略图要显示相机相册和云图的图片：CAMERA_ALBUM_SUB_TYPE和CLOUD_ENHANCE_ALBUM_SUB_TYPE
    // Init system album information
    PhotoBrowserGetCameraAlbum.getCameraAlbumInfo((albumInfo: AlbumInfo | undefined) => {
      if (albumInfo) {
        Log.info(TAG, `getSourceAlbumByLPath successes uri: ${albumInfo.uri}`);
        this.dataSource.setAlbumUri((albumInfo.uri));
      } else {
        Log.error(TAG, 'getSourceAlbumByLPath failed');
      }
      this.dataSource.initData(!needCreateDataSource);
      if (this.broadCast) {
        this.dataSource.setBroadCast(this.broadCast);
        this.dataSource.setBroadCastToAlbum(this.broadCast);
      }
      callback?.();
    });
  }

  public initLastAutoMediaItem(): void {
  }

  public updateHorizontal(): void {
  }

  public enterOnStartFun: () => void = () => {
  };

  public enterOnfinishFun: () => void = () => {
  };

  public exitOnStartFun: () => void = () => {
  };

  public exitOnfinishFun: () => void = () => {
  };

  public setHidePhotoBrowser(hidePhotoBrowser: Function): void {
  };

  /**
   * 图库拉起编辑，上下文信息设置
   */
  public setEditorContext(): void {
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      return;
    }
    EditorPhotoContext.getInstance().setIsVirtualAlbum(this.isVirtualAlbum());
  }

  private showDeleteDialog(deleteMessage: Resource[], confirmCallback: Function, cancelCallback:
    Function, isAlbumDelete: boolean, isExpandPositionParams: PositionParams): void {
    Log.info(TAG, 'SHOW_DELETE_DIALOG');
    ShortCut.deleteDialogOpenFlag = true;
  }

  /**
   * 是否虚拟相册打开大图
   * @returns
   */
  private isVirtualAlbum(): boolean {
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      return false;
    }
    let isVirtualAlbum =
      this.isFromGroup ||
        this.pageFrom === BrowserCaller.SEARCH_GRID_PAGE ||
        this.pageFrom === BrowserCaller.SEARCH_SLOT_ITEM_PAGE ||
        this.pageFrom === BrowserCaller.HIGHLIGHT_PAGE ||
        this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY ||
        ((this.albumInfo?.isShootingAlbum ?? false) && this.albumInfo?.albumId === BrowserConstants.SHOOT_BURST_PHOTOS);
    Log.info(TAG, `isVirtualAlbum: ${isVirtualAlbum}`);
    return isVirtualAlbum;
  }

  private setPianoSetting(): void {
    systemParameterEnhance.get('const.photos.enable_piano', 'true').then((value: string) => {
      if (!this.needCheckPermission) {
        Log.info(
          TAG, 'without medialibrary permission: please check medialibrary permission by setNeedCheckPermission()'
        );
        value = 'false';
      } else {
        if (this.mediaPermissionFlag !== (PermissionFlag.READ_IMAGEVIDEO | PermissionFlag.WRITE_IMAGEVIDEO)) {
          Log.info(TAG, `without medialibrary permission: mediaPermission is ${this.mediaPermissionFlag}`);
          value = 'false';
        }
      }
      Log.info(TAG, `const.photos.enable_piano = ${value}`);
      AppStorage.setOrCreate(Constants.ENABLE_PIANO, value);
    });
  }

  /**
   * 设置沙箱环境时DataSource的数据源
   * @param sandboxInfo
   */
  public setSandboxData(sandboxInfo: SandboxObjectImpl[]): void {
    if (this.dataSource && this.isSandboxEnv) {
      (this.dataSource as SandboxDataSource)?.setData?.(sandboxInfo);
      if (this.currentMediaUri) {
        this.changeCurrentMediaUri(this.currentMediaUri);
      }
    }
  }

  /**
   * 是否需要校验媒体库读写权限
   * @param need
   */
  public setNeedCheckPermission(need: boolean): void {
    this.needCheckPermission = need;
  }

  public getSingleGeometryId(): string {
    return this.singleGeometryId;
  }

  public getAlbumInfo() {
    return this.albumInfo;
  }

  public getAlbumUri() {
    return this.albumUri;
  }

  /**
   * 设置一镜到底动效时，大图加载完成前的占位图
   * @param placeholderUri
   */
  public setGeometryPlaceholder(placeholderUri: string): void {
    AppStorage.setOrCreate(LibraryConstants.PLACEHOLDER_FOR_GEOMETRY_TRANSITION, placeholderUri);
  }

  /**
   * 删除图片的 GeometryId
   */
  public cleanSingleGeometryId(): void {
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
  }

  public setCurrentMediaUriInner(mediaUri: string): void {
    Log.info(TAG, `[enterLibrary] setCurrentMediaUriInner, mediaUri: ${mediaUri}`);
    this.stateMachine.processSetCurrentMediaEvent(mediaUri);
    this.currentMediaUri = mediaUri;
    this.dataSource.getItemIndexByUri(mediaUri, (index: number) => {
      Log.info(TAG, `[enterLibrary] get index from mediaLibrary, currentIndex: ${
        this.getCurrentIndex()}, index: ${index}`);
      if (index === -1) {
        Log.error(TAG, `[enterLibrary] failed to getData, set index 0`);
        index = 0;
      }

      this.setTargetIndex(index);
      if (this.getCurrentIndex() === index) {
        return;
      }
      this.setCurrentItem(index);
      this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [index]);
    });
  }

  protected changeCurrentMediaUri(mediaUri: string): void {
    Log.info(TAG, `old albumUri: ${this.currentMediaUri}, new albumUri: ${mediaUri}`);
    if (this.mCallbacks.has(LibraryConstants.UPDATE_CURRENT_INDEX)) {
      return;
    }
    this.setCurrentMediaUriInner(mediaUri);
  }

  /**
   * 确认当前进程是否满足拉起大图所需的权限要求
   */
  private verifyAccessPermission(): void {
    Log.info(TAG, 'start verify access permission');
    const msg: Record<string, number | string | boolean> = {
      'isPhoneDevice': !DeviceInfo.isPc(),
      'bundleName': this.bundleName
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_CONTROLLER_INIT, msg);
    let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_WITH_PERMISSION;
    let userId = 100;
    let atManager = abilityAccessCtrl.createAtManager();
    let tokenID = bundleManager.getApplicationInfoSync(this.bundleName, appFlags, userId).accessTokenId;
    let readPermissionResult = atManager.verifyAccessTokenSync(tokenID, 'ohos.permission.READ_IMAGEVIDEO');
    if (readPermissionResult !== -1) {
      Log.info(TAG, 'have read permission');
      this.mediaPermissionFlag |= PermissionFlag.READ_IMAGEVIDEO;
    }
    Log.info(TAG, 'have read permission');
    let writePermissionResult = atManager.verifyAccessTokenSync(tokenID, 'ohos.permission.WRITE_IMAGEVIDEO');
    if (writePermissionResult !== -1) {
      Log.info(TAG, 'have write permission');
      this.mediaPermissionFlag |= PermissionFlag.WRITE_IMAGEVIDEO;
    }
    Log.info(TAG, `verify permission is: ${this.mediaPermissionFlag}`);
  }

  /**
   * 窗口管理器初始化，使用三方传入的 windowStage 进行初始化
   *
   * @param windowStage 窗口信息，由三方出传入
   */
  private initScreenManager() {
    getScreen().on(ScreenManager.ON_LEFT_BLANK_CHANGED, this.onLeftBlankChangedFunc);
    getScreen().on(ScreenManager.ON_SPLIT_MODE_CHANGED, this.onSplitModeChangedFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    Log.info(TAG, 'Application onCreate finish');
    if (!getScreen().isUIExtensionEnv()) {
      let windowStage: window.WindowStage | undefined =
        LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage');
      windowStage?.getMainWindow().then((win: window.Window) => {
        TraceControllerUtils.startTrace('getMainWindow_Callback');
        LocalStorage.getShared()?.setOrCreate('mainWindow', win);
        getScreen().getAvoidArea();
        getScreen().openColorSpaceWideGamut(win);
        getScreen().initializationSize().then((): void => {
          getScreen().initWindowMode();
          getScreen().registerWindowAvoidArea();
          getScreen().initOrientation();
          AppStorage.setOrCreate<Router | undefined>('router', undefined);
          WindowUtil.prepareWinRouter();
          TraceControllerUtils.finishTrace('getMainWindow_Callback');
        }).catch((): void => {
          Log.error(TAG, 'get device screen info failed.');
        });
      }).catch((): void => {
        Log.error(TAG, 'device getMainWindow failed.');
      });
    } else {
      getScreen().initializationSize().then((): void => {
        getScreen().getAvoidArea();
        getScreen().initWindowMode();
        getScreen().registerWindowAvoidArea();
        AppStorage.setOrCreate<Router | undefined>('router', undefined);
        WindowUtil.prepareWinRouter();
      }).catch((): void => {
        Log.error(TAG, 'get device screen info failed.');
      });
    }
  }

  private initNetworkStatus(): void {
    // CloudDriveUtil.queryNetworkConnectionWithContextAsync(this.abilityContext).then((value: boolean) => {
    //   this.networkConnectionStatus = value;
    //   Log.info(TAG, `networkConnectionStatus is: ${this.networkConnectionStatus}`);
    // });
  }

  /**
   * GeometryId 更新回调
   *
   * @param geometryTransitionId 更新的 GeometryId
   */
  public onGeometryIdChange(geometryTransitionId: string) {
    Log.debug(TAG, `onGeometryIdChange newId: ${geometryTransitionId}, oldId: ${this.geometryTransitionId}`);
    this.geometryTransitionId = geometryTransitionId;
  }

  public getJumpToPhoto(): boolean {
    Log.debug(TAG, `getJumpToPhoto ${this.isJumpToPhoto}`);
    return this.isJumpToPhoto;
  }

  /**
   * 注销大图组件控制器
   */
  public unInit(): void {
    Log.info(TAG, 'unInit');
    LocalStorage.getShared()?.delete('currentOperateControllerId');
    CommonUtil.unregisterProgDispSwitchObserver();
    this.dataSource?.unInit();
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    NetworkConnectionAccess.unregister();
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      UserFileManagerAccess.getInstance().onDestroy();
      getScreen().unRegisterWindowAvoidArea();
      getScreen().destroyWindowModePhotoBrowser();
    }
    getScreen().off(ScreenManager.ON_LEFT_BLANK_CHANGED, this.onLeftBlankChangedFunc);
    getScreen().off(ScreenManager.ON_SPLIT_MODE_CHANGED, this.onSplitModeChangedFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    AppStorage.delete('isMute');
    try {
      display.off('foldDisplayModeChange', this.onFoldDisplayChanged);
    } catch (err) {
      Log.error(TAG, `Display.off error: ${err}, code: ${err?.code}`);
    }
    if (this.swiperOnFoldChange) {
      this.swiperOnFoldChange = undefined;
    }
  }

  /**
   * 广播回调注册
   */
  public registerBroadCast(broadCast?: BroadCast): void {
    if (!broadCast) {
      Log.info(TAG, `registerBroadCast broadcast is undefined`);
      return;
    }
    Log.info(TAG, '[registerBroadCast] start');
    // view注册广播时，把新建的broadcast传入，controller需要保存最新的broadcast
    // 销毁时仍然传入broadcast，保证新的view的broadcast不会被清理
    this.broadCast = broadCast;
    if (this.dataSource) {
      this.dataSource.setBroadCast(broadCast);
      this.dataSource.setBroadCastToAlbum(broadCast);
    }
    broadCast.on(BrowserConstants.DELETE, (): void => {
      Log.info(TAG, 'broad delete');
      // 删除最后一张图片时，设置为左滑补位
      if (this.getCurrentIndex() >= this.dataSource.totalCount() - 1) {
        Log.info(TAG, 'delete last item, set isBigPhotoLeftToRightAnim true');
        AppStorage.set<boolean>('isBigPhotoLeftToRightAnim', true);
      }
      this.stateMachine.processDeleteStartEvent();
      this.emitCallback(LibraryConstants.DELETE, [])
    }
    );
    broadCast.on(BrowserConstants.TOGGLE_BAR, (backgroundColorResource?: Resource) => {
      Log.info(TAG, 'on [TOGGLE_BAR]');
      this.emitCallback(LibraryConstants.ON_TOGGLE_BARS_CALLBACK, [backgroundColorResource]);
    });
    broadCast.on(BrowserConstants.HIDE_BARS, (backgroundColorResource?: Resource) => {
      Log.info(TAG, 'on [HIDE_BARS]');
      this.emitCallback(LibraryConstants.HIDE_BARS_CALLBACK, [backgroundColorResource]);
    });
    broadCast.on(BrowserConstants.SHOW_BARS, (backgroundColorResource?: Resource) => {
      Log.info(TAG, 'on [SHOW_BARS]');
      this.emitCallback(LibraryConstants.SHOW_BARS_CALLBACK, [backgroundColorResource]);
    });
    broadCast.on(PHOTO_SCALED, (isPhotoScaled: boolean) => {
      this.emitCallback(LibraryConstants.PHOTO_SCALED, [isPhotoScaled]);
    });
    this.registerPullDownBroadCast(broadCast);
    broadCast.on(BrowserConstants.DATA_SIZE_CHANGED, (size: number) => this.onDataSizeChanged(size));
    broadCast.on(BrowserConstants.DATA_CONTENT_CHANGED, () => this.DataContentChanged());
    broadCast.on(BrowserConstants.SET_FAVOR, (isFavor: boolean) => this.setFavor(isFavor));

    broadCast.on(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT,
      (): void => this.emitCallback(LibraryConstants.UPDATE_SYSTEM_UI, []))
    broadCast.on(BrowserConstants.RENAME,
      (result: TitleName, uniqueId: string) => this.updatePhotoName(result, uniqueId));
    broadCast.on(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM,
      (): void => this.emitCallback(LibraryConstants.UPDATE_DELETING, [true]))
    broadCast.on(BrowserConstants.SET_DISABLE_SWIPE, (value: boolean) => {
      Log.info(TAG, `on [SET_DISABLE_SWIPE], value: ${value}`);
      this.emitCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK, [undefined, undefined, value]);
    });
    broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, () => this.onDataReloadedWithEdit());
    broadCast.on(BroadCastConstants.MEDIA_OPERATION,
      (displayName: string, albumUri: string, completedFunc?: Function) =>
      this.mediaOperation(displayName, albumUri, completedFunc));
    broadCast.on(BrowserConstants.BROWSER_FULL_SHOW,
      (isBrowserFullShow: boolean) => this.browserFullShow(isBrowserFullShow));
    // 监听PC端大图菜单移动图片到相册的广播
    this.appBroadCast.on(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER, 
      (...args: ESObject[]): void => {
        Log.info(TAG, `BasePhotoBrowserController PC_MEDIA_OPERATION_BROWSER received, args count: ${args.length}, args: ${JSON.stringify(args)}`);
        if (args.length < 3) {
          Log.error(TAG, `PC_MEDIA_OPERATION_BROWSER invalid params count: ${args.length}, args: ${JSON.stringify(args)}`);
          return;
        }
        const operationType: string = args[0] as string;
        const albumName: string = args[1] as string;
        const albumUri: string = args[2] as string;
        Log.info(TAG, `BasePhotoBrowserController PC_MEDIA_OPERATION_BROWSER pageType: ${operationType}, albumName: ${albumName}, albumUri: ${albumUri}`);
        if (!operationType || !albumName || !albumUri) {
          Log.error(TAG, `PC_MEDIA_OPERATION_BROWSER invalid params: operationType=${operationType}, albumName=${albumName}, albumUri=${albumUri}`);
          return;
        }
        this.mediaOperationBack(operationType, albumName, albumUri);
      });
    this.appBroadCast.on(BroadCastConstants.MENU_ACTION_FROM_PHOTO_CAMERA, this.dealMenuClickFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.onPhotoBrowserBackPressEventFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);

    this.appBroadCast.on(BroadCastConstants.ROUTE_TO_SETTINGS_PAGE, this.routeToSettingsPageFunc);
    this.appBroadCast.on(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.on(BroadCastConstants.SET_IS_DOWNLOADING, this.setIsDownloadingFunc);
    this.appBroadCast.on(BroadCastConstants.QRCODE_UPDATE, this.QRCodeUpdateFunc);
    this.appBroadCast.on(BroadCastConstants.QRCODE_GET_ITEM, this.QRCodeGetItemFunc);
    broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
  }

  private registerPullDownBroadCast(broadCast: BroadCast): void {
    broadCast.on(BrowserConstants.PULL_DOWN_START, (event: KeyEvent) => this.pullDownStart(event));
    broadCast.on(BrowserConstants.PULL_DOWN_END, (): void => this.pullDownEnd());
    broadCast.on(BrowserConstants.PULL_DOWN_CANCEL, (): void => {
      Log.info(TAG, 'pulling down cancel');
      this.emitCallback(LibraryConstants.PULL_DOWN_CANCEL, []);
      this.emitCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK, [undefined, false, undefined]);
    });
  }

  private pullDownStart(event: KeyEvent): void {
    Log.info(TAG, `pulling down start: ${JSON.stringify(event)}`);
    this.emitCallback(LibraryConstants.PULL_DOWN_START, [event]);
    this.emitCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK, [undefined, true, undefined]);
  }

  private pullDownEnd(): void {
    Log.info(TAG, 'pulling down end');
    this.emitCallback(LibraryConstants.PULL_DOWN_END, []);
    this.isDrag = true;
    this.onBackPress(undefined, undefined, this.browserControllerId);
  }

  protected DataContentChanged(): void {
    Log.debug(TAG, 'PhotoConstants.DATA_CONTENT_CHANGED');
    let currentPhoto = this.getPhotoByIndex(this.getTargetIndex());
    let videoStatus: string | undefined = this.videoPlayController?.getAvPlayerState();
    let currentPlaySrc: string | undefined = this.videoPlayController?.getVideoPlayer()?.getCurrentSrc();
    if (this.pageFrom === BrowserCaller.VIEWDATA_PAGE) {
      this.oldPhotoSize = Math.max(this.dataSource.totalCount(), 0);
    }
    if (this.pageFrom === BrowserCaller.VIEWDATA_PAGE && this.isDataLoadFinishedFromViewData(this.getCurrentIndex())) {
      Log.info(TAG, 'from view data index mediaItem load finished');
      this.broadCast.emit(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, []);
    }
    if (currentPlaySrc === currentPhoto?.uri && (videoStatus === AvplayerStatus.PLAYING ||
      videoStatus === AvplayerStatus.PAUSED)) {
      Log.info(TAG, '[videoPlayer] on current video playing,data content changed, return directly.');
      return;
    }
    if (this.getTargetIndex() === this.getCurrentIndex()) {
      this.onPhotoChanged(this.getTargetIndex());
    } else {
      Log.debug(TAG, 'ignore DATA_CONTENT_CHANGED event in swipe animation');
    }
  }

  private isDataLoadFinishedFromViewData(index: number): boolean {
    let albumDataSource: MediaDataSource | undefined = this.dataSource.getAlbumDataSource();
    if (!albumDataSource) {
      return false;
    }
    const activeStart: number = albumDataSource.activeStart;
    const activeEnd: number = albumDataSource.activeEnd;
    if (!this.checkThumbItemExist(index)){
      return false;
    }
    const leftIndex: number = index - LIST_CACHE_COUNT;
    if (activeStart <= leftIndex && leftIndex <= activeEnd && !this.checkThumbItemExist(leftIndex)) {
      return false;
    }
    return true;
  }

  private checkThumbItemExist(index: number) {
    let albumDataSource: MediaDataSource | undefined = this.dataSource.getAlbumDataSource();
    if (!albumDataSource) {
      return false;
    }
    let indexMediaItem : MediaItem | undefined = albumDataSource.getRawData(index);
    if (!indexMediaItem) {
      Log.info(TAG, `photoBrowser from viewdata index ${index} albumDatasource mediaItem not exist`);
      return false;
    }
    return true;
  }

  private async mediaOperation(displayName: string, albumUri: string, completedFunc?: Function): Promise<void> {
    Log.info(TAG, `broadCast on mediaOperation, albumUri: ${albumUri}`);
    ReportToBigDataUtil.report(BigDataConstants.COPY_MENU_RESPONSE);
    let menuContext = new MenuContext();
    menuContext.withMediaItem(this.getCurrentPhoto())
      .withBroadCast(this.broadCast)
      .withTargetAlbumName(displayName)
      .withAlbumUri(albumUri)
      .withOperationEndCallback((err: Object, count: number, total: number): void => {
        this.onAddEnd(err, count, total);
      });
    const currentPhoto: MediaItem | undefined = this.getCurrentPhoto();
    if (currentPhoto?.getIsBurstPhotos()) {
      const assets: MediaItem[] = await this.dataSource.getMediaItemsByBurstKey(currentPhoto?.burstKey);
      menuContext.withBurstPhotos(assets)
    }
    let menuOperation: MenuOperation = MenuOperationFactory.getInstance()
      .createMenuOperation(AddMenuOperation, menuContext);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    menuOperation?.doAction();
    completedFunc?.();
  }

  private browserFullShow(isBrowserFullShow: boolean): void {
    Log.info(TAG, `on [BROWSER_FULL_SHOW], isBrowserFullShow ${isBrowserFullShow}`);
    this.isBrowserFullShow = isBrowserFullShow;
    this.emitCallback(LibraryConstants.BROWSER_FULL_SHOW, [isBrowserFullShow]);
  }

  private setFavor(isFavor: boolean): void {
    Log.debug(TAG, 'set favor !');
    let currentPhoto = this.getPhotoByIndex(this.getCurrentIndex());
    if (currentPhoto && !isFavor) {
      currentPhoto.isFavor = isFavor;
      this.updateMenu(this.getCurrentIndex());
    } else {
      Log.debug(TAG, 'update favor !');
    }
  }

  private onDataReloadedWithEdit(): void {
    Log.debug(TAG, 'animate to data reloaded start with edit');
    try {
      let uri: string | undefined = LocalStorage.getShared()?.get<string>(BroadCastConstants.PHOTO_EDIT_SAVE_URI);
      Log.debug(TAG, `data reloaded start with edit by uri ${uri}`);
      if (uri) {
        let newIndex = this.dataSource.getDataIndexByUri(uri);
        let oldIndex = this.getCurrentIndex();
        if (newIndex != Constants.NOT_FOUND) {
          // Search for the position of new image/video after edit in current 500 items succeed
          Log.info(TAG, `data reloaded from ${oldIndex} move to ${newIndex}`);
          this.dataSource.resetPhotoRequest(uri);
          this.onPhotoChanged(newIndex);
        } else {
          // Search for the position of new image/video after edit in current 500 items failed
          Log.info(TAG, `data reloaded from ${oldIndex} move to unknown`);
          this.editNewUri = uri;
          this.setCurrentItem(0);
          this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [0]);
          this.dataSource.getItemIndexByUri(uri, (index: number): void => {
            this.onGetItemIndexByNewEditUri(index, oldIndex);
          });
        }
      }
    } catch (e) {
      Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
    }
  }

  private onGetItemIndexByNewEditUri(index: number, oldIndex: number): void {
    Log.info(TAG, `onGetItemIndexByNewEditUri: index=${index}`);
    if (this.editNewUri.length > 0) {
      if (index != Constants.NOT_FOUND) {
        Log.info(TAG, `data reloaded move to ${index}`);
        this.setCurrentItem(index);
        this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [index]);
        this.dataSource.enableGetData(true);
        this.dataSource.getDataWithoutCache(this.getCurrentIndex());
        this.dataSource.onDataReloaded();
        this.editNewUri = '';
      } else {
        Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
        this.editNewUri = '';
        this.setCurrentItem(oldIndex);
        this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [oldIndex]);
        this.dataSource.enableGetData(true);
      }
      this.onPhotoChanged(this.getCurrentIndex());
    }
  }

  /**
   * 广播回调注销
   */
  public unregisterBroadCast(broadCast?: BroadCast): void {
    Log.info(TAG, '[unregisterBroadCast] start');
    this.appBroadCast.off(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER, undefined);
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.onPhotoBrowserBackPressEventFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.ROUTE_TO_SETTINGS_PAGE, this.routeToSettingsPageFunc);
    this.appBroadCast.off(BroadCastConstants.MENU_ACTION_FROM_PHOTO_CAMERA, this.dealMenuClickFunc);
    this.appBroadCast.off(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.off(BroadCastConstants.SET_IS_DOWNLOADING, this.setIsDownloadingFunc);
    this.appBroadCast.off(BroadCastConstants.QRCODE_UPDATE, this.QRCodeUpdateFunc);
    this.appBroadCast.off(BroadCastConstants.QRCODE_GET_ITEM, this.QRCodeGetItemFunc);
    if (!broadCast) {
      return;
    }
    broadCast.off(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
    broadCast.off(PHOTO_SCALED, undefined);
    broadCast.off(BrowserConstants.DELETE, undefined);
    broadCast.off(BrowserConstants.TOGGLE_BAR, undefined);
    broadCast.off(BrowserConstants.HIDE_BARS, undefined);
    broadCast.off(BrowserConstants.SHOW_BARS, undefined);
    broadCast.off(BrowserConstants.PULL_DOWN_START, undefined);
    broadCast.off(BrowserConstants.PULL_DOWN_END, undefined);
    broadCast.off(BrowserConstants.PULL_DOWN_CANCEL, undefined);
    broadCast.off(BrowserConstants.DATA_SIZE_CHANGED, undefined);
    broadCast.off(BrowserConstants.DATA_CONTENT_CHANGED, undefined);
    broadCast.off(BrowserConstants.SET_FAVOR, undefined);
    broadCast.off(BroadCastConstants.ROUTE_TO_PORTRAIT_PAGE, undefined);
    broadCast.off(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT, undefined);
    broadCast.off(BrowserConstants.RENAME, undefined);
    broadCast.off(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM, undefined);
    broadCast.off(BrowserConstants.SET_DISABLE_SWIPE, undefined);
    broadCast.off(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, undefined);
    broadCast.off(BroadCastConstants.MEDIA_OPERATION, undefined);
    broadCast.off(BrowserConstants.BROWSER_FULL_SHOW, undefined);
    broadCast.release();
  }

  public async mediaOperationBack(pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string,
    navigationPageFunc?: Function): Promise<void> {
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource,
      this.getCurrentIndex());
    if (!currentPhoto) {
      Log.error(TAG, 'MediaOperation currentPhoto is undefined');
      return;
    }
    let menuContext = new MenuContext();
    let menuOperation: MenuOperation | null = null;
    Log.info(TAG, 'browserController MediaOperation back');
    menuContext.withFromPage(Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER);
    switch (pageType) {
      case MediaOperationType.ADD: // '添加到'不需要设置源相册
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(mediaOperationAlbumName)
          .withAlbumUri(mediaOperationAlbumUri)
          .withOperationEndCallback((err: Error, count: number, total: number): void => {
            this.onCopyEnd(err as Object, count, total);
          });
        if (currentPhoto.getIsBurstPhotos()) {
          // 连拍照片需要批量处理
          const assets: MediaItem[] = await this.dataSource.getMediaItemsByBurstKey(currentPhoto?.burstKey);
          menuContext.withBurstPhotos(assets)
        }
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
        break;
      case MediaOperationType.MOVE:
        menuContext.withOperationEndCallback((err: Object, count: number, total: number): void => {
          this.onCopyEnd(err, count, total);
        })
          .withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(mediaOperationAlbumName)
          .withAlbumInfo(this.albumInfo)
          .withAlbumUri(mediaOperationAlbumUri)
          .withOriginalAlbumUri(this.albumInfo?.uri)
          .withNavigationPageFunc(navigationPageFunc)
          .operate(Action.MOVE.actionID);
        break;
      default:
        break;
    }
    menuOperation?.doAction();
  }

  onCopyEnd(err: Object, count: number, total: number): void {
    Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  /**
   * 菜单栏点击回调
   *
   * @param action 用户操作意图信息，包括收藏、返回等
   */
  public onMenuClicked(action: Action): void {
    let actionID: number = action.actionID;
    Log.info(TAG, `onMenuClicked, actionID: ${ActionID[actionID]}, targetIndex: ` +
      `${this.getTargetIndex()} currentIndex = ${this.getCurrentIndex()}`);
    // 触发收藏动效
    if (actionID === Action.FAVORITE.actionID || actionID === Action.NOT_FAVORITE.actionID) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_TRIGGER_VALUE, []);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_TRIGGER_VALUE_ACTION_BAR, []);
    }
    if (this.getTargetIndex() === -1 && this.getCurrentIndex() === 0) {
      this.setTargetIndex(this.getCurrentIndex());
    }
    if ((this.isDoDeleteAnim && actionID === Action.DELETE.actionID) || !this.clickThrottle.isPassable()) {
      Log.info(TAG, 'Deleting animation, cannot delete');
      return;
    }

    this.emitCallback(LibraryConstants.GET_IS_PULLING_DOWN, [(isPullingDown: boolean) => {
      // 锁屏相机，使用分享、收藏、跳转图库功能需要先解锁
      let screenIsLock: boolean = getScreen().screenIsLock();
      if (screenIsLock && SECURITY_MENU_LIST.indexOf(actionID) > -1) {
        this.unlockScreen(action, actionID);
      } else {
        this.dealMenuClick(action, actionID);
      }
    }]);
  }

  private unlockScreen(action: Action, actionID: number): void {
    let callback = (unlockResult: boolean) => {
      if (unlockResult) {
        this.dealMenuClick(action, actionID);
      }
    }
    getScreen().screenUnlock(callback);
  }

  private infoAction(currentPhoto: MediaItem | undefined) {
    this.showInfo(currentPhoto);
  }

  public goToPhotosAction(currentPhoto: MediaItem | undefined): void {

  }

  private dealMenuClick(action: Action, actionID: number) {

    // Swiper的切换滑动会存在currentIndex更新不及时问题，所以需要使用targetIndex
    let currentPhoto = this.getPhotoByIndex(this.getTargetIndex());
    if (!currentPhoto) {
      // 兜底措施，如果currentPhoto不在范围内的情况下，进行主动获取
      currentPhoto = this.dataSource?.getDataWithoutCache(this.getTargetIndex())?.item;
    }
    switch (actionID) {
      case Action.BACK.actionID:
        this.onBackPress(undefined, undefined, this.browserControllerId);
        return;
      case Action.INFO.actionID:
        this.infoAction(currentPhoto);
        return;
      case Action.INFO_SELECTED.actionID:
        this.infoAction(currentPhoto);
        return;
      case Action.NOT_FAVORITE.actionID:
      case Action.FAVORITE.actionID:
        this.favoriteClicked(currentPhoto);
        break;
      case Action.GOTO_PHOTOS.actionID:
        this.goToPhotosAction(currentPhoto);
        break;
      case Action.EDIT.actionID:
        this.onEditClicked();
        return;
      case Action.RENAME.actionID:
        this.rename(currentPhoto);
        break;
      case Action.MOVE.actionID:
        if (!DeviceInfo.isPc()) {
          this.moveActionNotPc(currentPhoto);
        }
        return;
      case Action.SOUND_FILLED.actionID: //禁音
      case Action.SOUND_OFF_FILLED.actionID: // 声音
        this.soundFilled();
        return;
      case Action.VIDEO_PAUSE.actionID: // 暂停
      case Action.VIDEO_PLAY.actionID: // 播放
        this.onVideoPlayOrPauseClicked();
        return;
      case Action.PHONE_ROTATE.actionID: //旋转
        this.phoneRotate(currentPhoto);
        return;
      case Action.FLASH_CAPTURE.actionID:
      case Action.CLOSE_FLASH_CAPTURE.actionID:
      case Action.VIRTUAL_APERTURE.actionID:
      case Action.CLOSE_VIRTUAL_APERTURE.actionID:
      case Action.DYNAMIC_PANNING.actionID:
        this.handleEffectToggleChange(actionID, currentPhoto);
        return;
      case Action.SET_WALLPAPER.actionID:
        this.setWallpaper(currentPhoto);
        return;
      case Action.REMOVE_FROM_GROUP.actionID:
        this.removeFromGroup(currentPhoto, action);
        return;
      case Action.SLIDE_SHOW.actionID:
        this.jumpSlideShowPage();
        return;
      case Action.PRINT.actionID:
        this.handlePrint(currentPhoto, action);
        return;
      default:
        this.handleOtherCase(currentPhoto, action);
        return;
    }
  }

  private handleEffectToggleChange(actionID: number, currentPhoto?: MediaItem): void {
    // 抓拍走动图链路
    if (!currentPhoto) {
      Log.info(TAG, `handleEffectToggleChange return`);
      return;
    }
    const effectMode: number =
      Number(currentPhoto.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    let isMoving = (currentPhoto.data?.get('subtype') === photoAccessHelper.PhotoSubtype.MOVING_PHOTO ||
      effectMode === photoAccessHelper.MovingPhotoEffectMode.IMAGE_ONLY);
    EffectPhotoContext.getInstance().setIsSwitching(true);
    ShotForMoreContext.getInstance()
      .setUrl(currentPhoto.uri)
      .setPhotoType(isMoving ? 1 : 0)
      .setSwitchStartTime();
    this.isMovingPhotoSwitching = true;
    this.appBroadCast.emit(BroadCastConstants.SET_IS_SWITCHING, [true]);
    if (isMoving) {
      const callback: Function = (success: boolean) => {
        EffectPhotoContext.getInstance().setIsSwitching(false);
        this.isMovingPhotoSwitching = false;
        ShotForMoreContext.getInstance()
          .setSwitchEndTime()
          .setResult(success);
        ShotForMoreContext.getInstance().reportSwitch();
        ShotForMoreContext.getInstance().clear();
      }
      this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_LOADING_PROGRESS, [true, currentPhoto?.uri]);
    } else {
      const callback: Function = (success: boolean) => {
        EffectPhotoContext.getInstance().setIsSwitching(false);
        this.isMovingPhotoSwitching = false;
        this.appBroadCast.emit(BroadCastConstants.SET_IS_SWITCHING, [false]);
        ShotForMoreContext.getInstance()
          .setSwitchEndTime()
          .setResult(success);
        ShotForMoreContext.getInstance().reportSwitch();
        ShotForMoreContext.getInstance().clear();
      }
      let imageUpdateCallback: Function = () => {
        this.updatePixMapDataSource();
        this.dataSource.resetPhotoRequest(currentPhoto.uri);
      }
      this.onEffectModeSwitchClicked(false);
      EffectPhotoContext.getInstance()
        .setUri(currentPhoto?.uri)
        .setImageUpdateCallback(imageUpdateCallback);
      this.dataSource.resetPhotoRequest(currentPhoto.uri);
      this.appBroadCast.emit(BroadCastConstants.CHANGE_IMAGE_LOADING, [true]);
      //EffectToggleHelper.setEffectToggle(actionID, getContext(this), currentPhoto?.data, callback);
    }
  }

  private handleOtherCase(currentPhoto: MediaItem | undefined, action: Action): void {
    if (this.pageFrom !== BrowserCaller.CAMERA_PAGE) {
      AppStorage.setOrCreate<string>(Constants.KEY_OF_HIDDEN_POSITION, TAG);
      AppStorage.setOrCreate<string>(Constants.KEY_OF_UNHIDDEN_POSITION, TAG);
    }
    // 连拍照片的删除/隐藏等单独处理
    const batchHandleActions = [
      Action.DELETE.actionID,
      Action.REMOVE_FROM.actionID,
    ]
    let broadCast: BroadCast = this.broadCast;
    let isFromHighlight: boolean = this.pageFrom === BrowserCaller.HIGHLIGHT_PAGE;
    if (isFromHighlight) {
      broadCast = this.appBroadCast;
    }

    let albumInfo: AlbumInfo | undefined;
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      albumInfo = new AlbumInfo();
      if (PhotoBrowserGetCameraAlbum.cameraAlbumInfo) {
        // 分享场景，设置相机相册筛选相册相册照片
        albumInfo = PhotoBrowserGetCameraAlbum.cameraAlbumInfo;
      }
      albumInfo.isTrashAlbum = false;
    } else {
      albumInfo = this.albumInfo;
    }

    let operationPosition: number | undefined;
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      operationPosition = undefined;
    } else {
      operationPosition = this.getOperationPosByPageFrom();
    }

    let otherParams: MenuOptionOtherParams | undefined;
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      otherParams = undefined;
    } else {
      let albumUri: string | undefined =
        this.albumInfo?.uri ? this.albumInfo?.uri : this.highlightPhotoAlbum?.albumUri;
      otherParams = {
        albumUri: albumUri,
        uri: currentPhoto?.uri,
        isFromPortrait: this.isFromPortrait,
        currentIndex: this.getCurrentIndex(),
        mediaCount: this.dataSource.totalCount(),
        album: this.highlightPhotoAlbum,
        isFromHighlight: isFromHighlight,
        sortHelper: this.sortHelper,
        isGroupGrid: this.albumInfo?.viewMode === GridViewMode.GROUP,
      };
    }
    Log.info(TAG, `handleOtherCase isGroupGrid ${otherParams?.isGroupGrid}`)
    menuOption(action.actionID, currentPhoto, broadCast, albumInfo,
      operationPosition, this.currentPage, otherParams, this.pageFrom);
  }

  private getOperationPosByPageFrom(): number {
    let operationPosition: number = BigDataConstants.OPERATION_IN_INVALID_POSITION;
    if (this.pageFrom === BrowserCaller.SEARCH_GRID_PAGE ||
      this.pageFrom === BrowserCaller.SEARCH_GRID_PAGE_PC) {
      operationPosition = BigDataConstants.OPERATION_IN_SEARCH_RESULT_PAGE;
    } else if (this.pageFrom === BrowserCaller.SEARCH_SLOT_ITEM_PAGE) {
      operationPosition = BigDataConstants.OPERATION_IN_REAL_TIME_PAGE;
    }
    return operationPosition;
  }

  private rename(currentPhoto: MediaItem | undefined): void {
    this.emitCallback(LibraryConstants.UPDATE_HIDE_POPUP, [true]);
    if (currentPhoto == undefined) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    let menuContext: MenuContext = new MenuContext();
    menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumInfo(this.albumInfo);
    let menuOperation: MenuOperation | undefined = MenuOperationFactory.getInstance()
      .createMenuOperation(RenameMenuOperation, menuContext);
    menuOperation?.doAction();
  }

  private async favoriteClicked(currentPhoto: MediaItem | undefined): Promise<void> {
    if (currentPhoto == undefined) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    let menuContext: MenuContext = new MenuContext();
    Log.debug(TAG, `before modify, isFavor: ${currentPhoto.isFavor}`);
    currentPhoto.isFavor = !currentPhoto.isFavor;

    let handleMediaItem: Function = this.getFavorHandleMethod(menuContext, currentPhoto);
    handleMediaItem(currentPhoto);

    this.updateMenu(this.getCurrentIndex());
    if (currentPhoto.isFavor) {
      ReportToBigDataUtil.report(BigDataConstants.FAVOR_MENU_RESPONSE, { 'from': 'FULL_IMAGE_PAGE' });
    }
  }

  private getFavorHandleMethod(menuContext: MenuContext, currentPhoto: MediaItem): Function {
    let handleMediaItem: Function = () => {
    };
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      handleMediaItem = (mediaItem: MediaItem) => {
        menuContext.withMediaItem(mediaItem)
          .withBroadCast(this.broadCast)
          .withTargetFavorStatus(currentPhoto.isFavor)
          .operate(Action.FAVORITE.actionID)
      }
    } else {
      if (!UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
        handleMediaItem = (mediaItem: MediaItem) => {
          menuContext.withMediaItem(mediaItem)
            .withBroadCast(this.broadCast)
            .withTargetFavorStatus(currentPhoto.isFavor)
            .operate(Action.FAVORITE.actionID);
        };
      } else {
        handleMediaItem = (mediaItem: MediaItem) => {
          if (currentPhoto.isFavor) {
            if (this.favorCacheItemsMap.has(mediaItem.uri)) {
              this.favorCacheItemsMap.delete(mediaItem.uri);
            } else {
              Log.error(TAG, `not fount item uri ${mediaItem.uri}`);
            }
          } else {
            this.favorCacheItemsMap.set(mediaItem.uri, mediaItem);
          }
        }
      }
    }
    return handleMediaItem;
  }

  private showInfo(currentPhoto: MediaItem | undefined): void {
    if (currentPhoto == undefined) {
      Log.warn(TAG, 'currentPhoto is undefined');
      return;
    }
    this.broadCast.emit(BrowserConstants.RESET_DEFAULT_SCALE + currentPhoto.uri, []);
    this.broadCast.emit(BrowserConstants.OPEN_CLICK_DETAIL_PULLING_UP + currentPhoto.uniqueId, [currentPhoto.uniqueId]);
  }

  private moveActionNotPc(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.MOVE.');
      return;
    }
    import('@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage')
      .then((extendMediaOperationBasePage) => {
        extendMediaOperationBasePage.MediaOperationBasePage.judgeIsEmptyAlbumsAndCallbackByMediaType(
          this.pageFrom === BrowserCaller.CAMERA_PAGE ? null : this.albumInfo?.uri,
          (): void => this.showPromptNewAlbumDialog(this.pageFrom === BrowserCaller.CAMERA_PAGE),
          (blackUris?: string[]): void => this.routeToSelectAlbumPage(this.pageFrom === BrowserCaller.CAMERA_PAGE,
            currentPhoto, blackUris),
          currentPhoto.mediaType
        );
      })
  }

  /**
   * 声音开启回调
   */
  private soundFilled(): void {
    this.emitCallback(LibraryConstants.VIDEO_IS_MUTE, [(isMute: boolean) => {
      if (isMute) {
        this.emitCallback(LibraryConstants.VIDEO_SOUND_FILLED, [AvPlayConstants.AV_PLAY_VOLUME]);
      } else {
        this.emitCallback(LibraryConstants.VIDEO_SOUND_FILLED, [AvPlayConstants.AV_PLAY_MUTE]);
      }
    }]);
  }

  public setNetworkAvailable(networkAvailable: boolean): void {
    Log.info(TAG, `networkAvailable: ${networkAvailable}`);
    this.networkAvailable = networkAvailable;
  }

  /**
   * 视频播放完/暂停回调
   */
  private videoPlayAndPause(): void {
    this.emitCallback(LibraryConstants.VIDEO_PLAYING_STATE, [(isVideoPlaying: boolean) => {
      this.emitCallback(LibraryConstants.VIDEO_IS_PLAYING, [this.isVideoPlaying]);
    }]);
  }

  /**
   * 屏幕旋转处理回调
   */
  orientationSensor(rotationStatus: string): void {
    if (rotationStatus === BrowserConstants.ROTATION_STATUS_ON) {
      try {
        sensor.on(sensor.SensorId.ORIENTATION, this.onDeviceRotateChangedFunc);
      } catch (err) {
        Log.error(TAG, `orientation sensor on fail, errCode: ${err.code}, msg: ${err.message}`);
      }
    }
  }

  private phoneRotate(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined when phoneRotate.');
      return;
    }
    if (!this.isSupportRotation) {
      return;
    }
    if (isOrientationHorizontal()) {
      WindowUtil.setOrientation(window.Orientation.USER_ROTATION_PORTRAIT);
      setTimeout((): void => {
        setHorizontal(false);
      }, BrowserConstants.DELAY_FOR_ROTATE_START);
    } else {
      WindowUtil.setOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
      setTimeout((): void => {
        setHorizontal(true);
      }, BrowserConstants.DELAY_FOR_ROTATE_START);
    }
    this.offSensorOrientation();
    // 用户打点
    Log.info(TAG, `pra ${currentPhoto.uri}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(currentPhoto.uri),
    };
    ReportToBigDataUtil.report(BigDataConstants.PHONE_ROTATE_ACTION, msg);
  }


  private onDeviceRotateChanged(data: sensor.OrientationResponse): void {
    Log.debug(TAG, `The device rotates z:${data.alpha}, x:${data.beta}, y:${data.gamma}`);
    // 关闭后再次打开监听时，开始几个数据不准。
    if (this.rotateChangeCount > this.rotateChangeCountMax) {
      this.rotateChangeCount = 0;
      if (((isOrientationHorizontal() && Math.abs(data.gamma) > BrowserConstants.ROTATE_DEVICE_60_DEG_Y) ||
        (!isOrientationHorizontal() && Math.abs(data.gamma) < BrowserConstants.ROTATE_DEVICE_30_DEG_Y)) &&
        (Math.abs(data.beta) > BrowserConstants.ROTATE_DEVICE_30_DEG_X &&
          Math.abs(data.beta) < BrowserConstants.ROTATE_DEVICE_150_DEG_X)) {
        this.offSensorOrientation();
        this.setOrientationAuto();
      }
    } else {
      this.rotateChangeCount++;
    }
  }

  private setOrientationAuto(): void {
    if (!this.isSupportRotation) {
      return;
    }
    setTimeout((): void => {
      WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    }, BrowserConstants.DELAY_FOR_SET_AUTO_ROTATE_SCREEN);
  }

  private offSensorOrientation(): void {
    try {
      // 取消注册SensorId.ORIENTATION的所有回调
      sensor.off(sensor.SensorId.ORIENTATION);
      this.rotateChangeCount = 0;
    } catch (err) {
      Log.error(TAG, `orientation sensor off fail, errCode: ${err?.code}, msg: ${err?.message}`);
    }
  }

  private onAddEnd(err: Object, count: number, total: number): void {
    Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  /**
   * 跳转到图库设置页面
   */
  private routeToSettingsPage(componentId: string): void {
    let param: Want = {
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
      parameters: {
        uri: Constants.WANT_PARAM_URI_SETTINGS,
        componentId: componentId
      }
    };
    Log.debug(TAG, `routeToSettingsPage parm: ${JSON.stringify(param)}`);

    this.abilityContext.startAbility(param);
    this.emitCallback(LibraryConstants.JUMP_TYPE, [JumpType.JUMP_TO_SETTINGS]);
  }

  /**
   * 跳转到图库照片页回调
   */
  public routeToPhotoBrowser(isShowVideo: boolean): void {
    const parameters: Record<string, Object> = {
      'ability.params.backToOtherMissionStack': true
    }
    parameters.isShowTabMenu = false;
    parameters.isShowToolMenu = false;
    parameters.uri = 'formAbility';
    if (this.currentMediaUriOnSubScreen === '') {
      Log.error(TAG, 'thumbnailUri is empty, route fail');
      this.abilityContext.terminateSelf();
      return;
    }
    parameters.currentUri = this.currentMediaUriOnSubScreen;
    parameters.isFromSubScreen = true;
    let cameraShotKey = AppStorage.get<string>('cameraShotKey');
    parameters.cameraShotKey = assert.asDefault(cameraShotKey, '');
    if (this.getCurrentPhoto()?.mediaType == userFileManager.FileType.VIDEO && isShowVideo) {
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
      let videoProgress = this.videoPlayController?.getVideoProgress();
      parameters.videoPlayProgress = assert.asDefault(videoProgress, 0);
    }
    if (LocalStorage.getShared().get<boolean>('isDeleteDialogOpen')) {
      Log.debug(TAG, 'isDeleting =true');
      parameters.isDeleting = true;
      AppStorage.setOrCreate<boolean>('isFirstTimeDelete', false);
    }
    let options: StartOptions = {
      displayId: 0,
    }
    let param: Want = {
      parameters: parameters,
      uri: this.currentMediaUri,
      action: 'ability.params.backToOtherMissionStack',
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
    };
    Log.debug(TAG, `routeToPhotoBrowser parm: ${JSON.stringify(param)}`);
    this.abilityContext.startAbility(param, options).then((): void => {
      Log.info(TAG, 'start photos complete');
      this.abilityContext.terminateSelf();
    });
  }


  /**
   * 跳转图库编辑页回调
   *
   * @returns
   */
  private async onEditClicked(): Promise<void> {
    let currentPhoto = this.getPhotoByIndex(this.getTargetIndex());
    if (!currentPhoto || currentPhoto.size === 0) {
      Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
      return;
    }
    this.emitCallback(LibraryConstants.EDITOR_INIT, []);
    // 上报编辑的资源类型
    let editType: EditType = currentPhoto.getIsMovingPhoto() ? EditType.MOVING_PHOTO : (currentPhoto.mediaType ===
    photoAccessHelper.PhotoType.IMAGE ? EditType.IMAGE : EditType.VIDEO);
    const msg: Record<string, number | string | boolean> = {
      'url': currentPhoto.uri,
      'type': editType
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_EDIT_FROM, msg);
    // 图片在本地，直接跳转编辑
    if (currentPhoto?.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      this.appBroadCast.emit(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, [currentPhoto?.uri]);
      this.setIsShowVideo(false);
      this.updateMenu(this.getCurrentIndex());
    }
    this.jumpToEditPage(currentPhoto, false);
  }

  private downloadFile(currentPhoto: MediaItem): void {
    if (!this.networkAvailable) {
      Log.info(TAG, 'download file no network');
      // 网络不可用，提示无法下载
      UiUtil.showToast($r('app.string.no_network'));
      return;
    }
    if (currentPhoto?.getIsMovingPhoto()) {
      this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_STOP_DOWNLOAD, [currentPhoto?.uri]);
    }
    this.jumpToEditPage(currentPhoto, true);
  }

  private showPromptNewAlbumDialog(isFromCamera: boolean): void {
    this.emitCallback(LibraryConstants.UPDATE_HIDE_POPUP, [true]);
    this.broadCast.emit(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, [
      (): void => {
        Log.info(TAG, 'new albums cancel');
      },
      (): void => {
        Log.info(TAG, 'createNewAlbum');
        let menuContext = new MenuContext();
        menuContext
          .withAlbumInfo(isFromCamera ? undefined : this.albumInfo)
          .withBroadCast(this.broadCast)
          .withJumpSourceToMain(JumpSourceToMain.ALBUM)
          .withSourceScene(SourceSceneType.BIG_PHOTO_COMPONENT);
        let menuOperation =
          MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
        menuOperation.doAction();
      }
    ]);
  }

  private routeToSelectAlbumPage(isFromCamera: boolean, currentPhoto: MediaItem, blackUris?: string[]): void {
    if (isFromCamera) {
      let param: Want = {
        bundleName: 'com.ohos.photos',
        abilityName: 'com.ohos.photos.MainAbility',
        parameters: {
          uri: Constants.WANT_PARAM_URI_SHARE_BROWSER_ADD,
          mediaUri: `${this.getCurrentPhoto()?.uri}`
        }
      };
      Log.debug(TAG, `routeToSelectAlbumPage parm: ${JSON.stringify(param)}`);
      this.abilityContext.startAbilityForResult(param, (err: BusinessError, result: common.AbilityResult) => {
        if (err.code) {
          Log.error(TAG, `startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
        }
        Log.info(TAG, `routeToSelectAlbumPage finish resultCode: ${result.resultCode}, want: ${result.want}`);
        this.isJumpToPhoto = false;
        if (result.resultCode === 0) {
          // 将相机相册照片移动到其他相册，返回相机大图组件需要移除图片，有移除动画
          this.photoBrowserDeleteConfirm();
        } else if (result.resultCode === 100 && this.pageFrom === BrowserCaller.CAMERA_PAGE) {
          // 在选择相册页退后台,大图组件做下树处理
          if (this.isBrowserFullShow) {
            this.isBrowserFullShow = false;
          }
          this.emitCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, [false]);
        }
      });
      this.isJumpToPhoto = true;
      this.emitCallback(LibraryConstants.JUMP_TYPE, [JumpType.JUMP_TO_SELECTALBUM]);
    } else {
      let pageFrom: string = Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER;
      let pageType: string = MediaOperationType.MOVE;
      let mediaType: number = currentPhoto?.mediaType ?? Number.NaN;
      let albumInfo: AlbumInfo | undefined = this.albumInfo;
      this.emitCallback(LibraryConstants.JUMP_TO_MOVE_TO_ALBUM,
        [pageFrom, pageType, mediaType, albumInfo, blackUris, this.browserControllerId]);
    }
  }

  private photoBrowserDeleteConfirm(): void {
    this.emitCallback(LibraryConstants.UPDATE_DELETING, [true]);
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
    if (this.getCurrentIndex() === this.dataSource?.totalCount() - 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    }
  }

  private setWallpaper(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    if (!DeviceInfo.isPc() && WallpaperEditorComponent.shouldBlockWallpaperEdit()) {
      UiUtil.showToast($r('app.string.not_support_wallpaper_edit'));
      return;
    }

    // 如果是云图弹toast 提示下载
    if (currentPhoto.getPosition() === photoAccessHelper.PositionType.CLOUD) {
      UiUtil.showToast($r('app.string.current_picture_not_download_please_download_and_try_again'));
      return;
    }
    let mode = power.getPowerMode();
    if (mode === power.DevicePowerMode.MODE_CUSTOM_POWER_SAVE) {
      Log.info(TAG, 'MODE_CUSTOM_POWER_SAVE');
      UiUtil.showToast($r('app.string.not_support_wallpaper_change'));
      return;
    }

    // if (DeviceInfo.isPc()) {
    //   WallpaperUtils.setWallpaper(currentPhoto.uri);
    // } else {
    //   let lcdUri: string = ImageUtil.getLCDUri(currentPhoto.uri, currentPhoto.path, currentPhoto.getDateModified());
    //   this.emitCallback(LibraryConstants.JUMP_TO_WALLPAPER_EDITOR, [currentPhoto.uri, lcdUri]);
    // }
    //todo 设置壁纸pc和手机先都走手机逻辑
      let lcdUri: string = ImageUtil.getLCDUri(currentPhoto.uri, currentPhoto.path, currentPhoto.getDateModified());
      this.emitCallback(LibraryConstants.JUMP_TO_WALLPAPER_EDITOR, [currentPhoto.uri, lcdUri]);

    ReportToBigDataUtil.report(BigDataConstants.SET_WALLPAPER, {
      'url': ReportToBigDataUtil.urlAnonymize(currentPhoto.uri)
    });
  }

  private removeFromGroup(currentPhoto: MediaItem | undefined, action: Action): void {
    let otherParams: MenuOptionOtherParams = {
      albumUri: this.albumUri,
      uri: currentPhoto?.uri,
    }
    menuOption(action.actionID, currentPhoto, this.broadCast,
      this.albumInfo, undefined, undefined, otherParams, this.pageFrom);
  }

  private jumpSlideShowPage(): void {
    this.emitCallback(LibraryConstants.JUMP_TO_SLIDE_SHOW, []);
  }

  private handlePrint(currentPhoto: MediaItem | undefined, action: Action): void {
    if (!currentPhoto) {
      Log.error(TAG, 'currentPhoto is undefined');
      return;
    }
    this.handleOtherCase(currentPhoto, action);
  }

  private onVideoPlayOrPauseClicked(): void {
    if (!this.isSupportedVideoType) {
      UiUtil.showToast($r('app.string.unsupported_video_type'));
      return;
    }
    if (!this.isNetworkAvailable()) {
      return;
    }
    this.isVideoPlaying = !this.isVideoPlaying;
    this.updateMenu(this.getTargetIndex());
    this.videoPlayAndPause();
    if (!this.isVideoPlaying) {
      Log.info(TAG, `[videoPlayer] click menu, action is play, isVideoPlay ${this.isVideoPlaying}`);
      let success: boolean | undefined = this.videoPlayController?.manuallyPlay();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PLAYING : AvplayerStatus.PAUSED]);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_SHOW_VIDEO, []);
      this.isShowVideo = true;
    } else {
      Log.info(TAG, `[videoPlayer] click menu, action is pause isVideoPlay ${this.isVideoPlaying}`);
      let success: boolean | undefined = this.videoPlayController?.manuallyPause();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PAUSED : AvplayerStatus.PLAYING]);
    }
  }

  private isNetworkAvailable(): boolean {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getTargetIndex());
    if (!currentPhoto) {
      return false;
    }
    let fileAsset: PhotoAsset | undefined = currentPhoto.data;
    if (!fileAsset) {
      Log.info(TAG, 'fileAsset is undefined');
      return true;
    }
    let filePosition: photoAccessHelper.PositionType =
      fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
    if (filePosition !== UserFileManagerAccess.FILE_LOCATION_CLOUD) {
      return true;
    }
    if (!this.networkAvailable) {
      // 网络不可用
      UiUtil.showToast($r('app.string.no_network'));
      return false;
    }
    return true;
  }
  /*
   * 系统变化语言回调
   */

  public updateCurrentLanguage(): void {
    Log.info(TAG, 'updateCurrentLanguage aaaaa');
    if (this.abilityStage) {
      LocalStorage.getShared()?.setOrCreate('photoLibraryContext',
        this.abilityStage?.createModuleContext('com.ohos.photobrowser', 'browserlibrary'));
    }
    this.updateActionBar(this.getCurrentIndex());
  }

  /**
   * 图片更新回调
   *
   * @param index 更新后的图片 index
   */
  public onPhotoChanged(index: number, isAnimating?: boolean): void {
    Log.info(TAG, `onPhotoChanged start, index=${index}`);
    let currentPhoto = this.getCurrentPhoto();

    this.reportToBigDataForPhotoSlide(index);
    this.setCurrentItem(index);
    this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [this.getCurrentIndex()]);
    this.updateActionBar(index);
    this.updateId(index);
    this.updatePixMapDataSource(isAnimating ? isAnimating : false);
  }

  /**
   * 图片下标 index 更新回调
   *
   * @param index 更新后的图片index
   */
  public onIndexChange(index: number, updateSource: boolean = true): void {
    Log.info(TAG, `onIndexChange start, index=${index}`);
    this.reportToBigDataForPhotoSlide(index);
    this.setCurrentItem(index);
    this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [this.getCurrentIndex()]);
    this.updateId(index);
    if (updateSource) {
      this.updatePixMapDataSource();
    }
    this.isSupportedVideoType = true;
  }

  public updatePixMapDataSource(isAnimating?: boolean): void {
    this.dataSource.updatePixMapDataSource(this.getCurrentIndex(), isAnimating ? isAnimating : false);
  }

  public setCurrentItem(index: number): void {
    this.setCurrentIndex(index);
    this.dataSource.updateCurrent(index);
    let currentPhoto = this.getCurrentPhoto();
    if (this.isSandboxEnv && currentPhoto) {
      this.currentMediaUri = currentPhoto.uri;
    }
  }

  public onDataPrepare(index: number): void {
    Log.info(TAG, `onDataPrepare start, index=${index}`);
    Heic2JPGManagerAccess.getInstance().verifyJumpSuccess(index);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    this.setTargetIndex(index);
    AppStorage.setOrCreate<MediaItem | undefined>('targetItem', this.getPhotoByIndex(this.getTargetIndex()));
    this.updateActionBar(index);
    this.emitCallback(LibraryConstants.UPDATE_PREPARED_INDEX, [index]);
  }

  /**
   * 执行图片下标 index 更新操作，刷新图片 geometryTransitionId
   *
   * @param index 更新后的图片下标 index
   */
  private updateId(index: number): void {
    Log.info(TAG, `updateId, enableSingle: ${this.enableSingleGeometryId}`);
    if (this.enableSingleGeometryId) {
      return;
    }
    let currentPhoto = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      Log.error(TAG, 'updateId, item is undefined');
    } else {
      LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId);
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', index);
      let geometryTransitionId: string = this.pageFrom + currentPhoto.hashCode;
      Log.info(TAG, `updateId, geometryTransitionId: ${geometryTransitionId}`);
      LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', geometryTransitionId);
    }
  }

  /**
   * 大图组件数据集 dataSource，数据量变化时的处理回调，当前 dataSource 清空时候，触发返回逻辑
   *
   * @param size
   */
  private onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size} oldPhotoSize = ${this.oldPhotoSize}`);
    if (this.pageFrom === BrowserCaller.SEARCH_GRID_PAGE || this.pageFrom === BrowserCaller.SEARCH_SLOT_ITEM_PAGE) {
      size = this.dataSource?.totalCount();
    }
    let needBack: boolean = this.oldPhotoSize !== 0 && size === 0;
    this.oldPhotoSize = size;
    if (size !== 0 || this.uriFromThirdPartyApp) {
      return;
    }
    if (needBack) {
      this.onBackPress(true, undefined, this.browserControllerId);
    }
  }

  /**
   * ActionBar 信息更新回调，使用新图片的信息，更新 actionBar 显示内容
   *
   * @param index 更新后的图片 index
   */
  public updateActionBar(index: number): void {
    Log.info(TAG, `updateActionBar index: ${index}`);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    this.getActionBarSubtitle(currentPhoto);

    this.updateMenu(index);
  }

  public getActionBarSubtitle(currentPhoto: MediaItem | undefined): void {
    let photoDate: string = DateUtil.getLocalizedDate(currentPhoto?.getDetailTime?.());
    let timestamp: number;

    if (!currentPhoto) {
      this.emitCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE, [photoDate, photoDate]);
      return;
    }

    timestamp = DateUtil.convertDateToTimestamp(currentPhoto.getDetailTimeString());
    if (!timestamp) {
      timestamp = currentPhoto?.getDetailTime?.();
    }
    this.emitCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE, [photoDate, DateUtil.getLocalizedTime(timestamp)])
  }

  /**
   * 静音设置回调
   *
   * @param val 是否静音标志
   */
  public setIsMute(val: boolean): void {
    this.isMute = val;
  }

  /**
   * 设置大图组件是否全屏显示
   *
   * @param val 是否全屏显示标志
   */
  public setIsBrowserFullShow(val: boolean): void {
    this.isBrowserFullShow = val;
  }

  /**
   * 播放设置回调
   *
   * @param val 是否播放正在标志
   */
  public setVideoPlaying(val: boolean): void {
    this.isVideoPlaying = val;
  }

  /**
   * 设置是否展示视频系列按钮
   */
  public setIsShowVideo(val: boolean): void {
    this.isShowVideo = val;
  }

  public setIsEnhanceTriggered(isEnhanceTriggered: boolean): void {
    this.isEnhanceTriggered = isEnhanceTriggered;
  }

  private getUpdateMenuParam(currentPhoto: MediaItem | undefined): UpdateMenuParamCamera {
    const hasWrite: boolean =
      (this.mediaPermissionFlag & PermissionFlag.WRITE_IMAGEVIDEO) === PermissionFlag.WRITE_IMAGEVIDEO;
    const param: UpdateMenuParamCamera = {
      invalidFlag: Boolean(hasWrite && currentPhoto?.data),
      canWallPaper: PhotoPropertiesUtil.isValidFormatToSetWallPaper(currentPhoto?.uri),
      isSandboxEnv: this.isSandboxEnv,
      canPrint: false,
      isExportVideo: Boolean(currentPhoto?.isExportVideo()),
      isVideo: currentPhoto?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO,
      hasUnFavor: this.mSelectManager.hasSelectedUnFavorItem(),
      hasWrite: hasWrite,
    };
    return param;
  }

  public initMoreMenu(index: number): void {
    Log.info(TAG,
      `setMenuGroupList menuGroupList: index ${index}`);
    let currentPhoto = this.getPhotoByIndex(index);
    let menuParam: UpdateMenuParamCamera = this.getUpdateMenuParam(currentPhoto);
    let param: ParamsWrapper = new ParamsWrapper().set(Constants.KEY_UPDATE_MENU_PARAM_CAMERA, menuParam);
    this.moreMenuController.initMenu(param);
  }

  /**
   * 大图组件更新菜单栏信息
   *
   * @param index 当前图片 index 信息
   * @param isShowVideo 是否展示视频组件标志
   */
  public async updateMenuForLibrary(index: number, isShowVideo?: boolean) {
    Log.info(TAG, `updateMenuForLibrary start`);
    let currentPhoto = this.getPhotoByIndex(index);
    if (currentPhoto == undefined) {
      return;
    }
    let isVideo = currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    let hasWrite: boolean =
      (this.mediaPermissionFlag & PermissionFlag.WRITE_IMAGEVIDEO) === PermissionFlag.WRITE_IMAGEVIDEO;
    if (!hasWrite) {
      AppStorage.setOrCreate<boolean>('isEditEnabled', false);
    }
    // 标题栏按钮
    let menuTemp: Action[] = [Action.GOTO_PHOTOS, Action.MORE];

    // 工具栏按钮
    let toolMenuTemp: Action[] = [];
    let item: MediaItem | undefined = this.getCurrentPhoto();
    if (!DeviceInfo.isTv() && !DeviceInfo.isPc()) {
      toolMenuTemp.push(hasWrite && currentPhoto?.data && !item?.isShowThumbnail ?
        (currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE) : Action.FAVORITE_INVALID);
    }
    if (DeviceInfo.isPc()) {
      toolMenuTemp.push(hasWrite && currentPhoto?.data && !item?.isShowThumbnail ?
        (Action.FAVORITE) : Action.FAVORITE_INVALID);
    }
    if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) { // 视频组件
      Log.info(TAG, `[videoPlayer] updateMenu this.isMute: ${this.isMute},isShowVideo: ${isShowVideo}`);
      toolMenuTemp.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY);
      if (!DeviceInfo.isTv()) {
        toolMenuTemp.push(this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
      }
    }
    this.appBroadCast.emit(BroadCastConstants.UPDATE_SHOW_MOVING_PHOTO_STATUS, [this.isShowMovingPhoto]);

    // 编辑规避verde外屏
    if (!DeviceInfo.isVerdeFoldable() && !DeviceInfo.isTv()) {
      try {
        toolMenuTemp.push(await UiUtil.isEditedEnable(currentPhoto) && hasWrite && currentPhoto?.data &&
          await currentPhoto?.isEditable?.() && !this.isMovingPhotoSwitching && !item?.isShowThumbnail ?
        Action.EDIT : Action.EDIT_INVALID);
      } catch (error) {
        Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
        toolMenuTemp.push(Action.EDIT_INVALID);
      }
    }

    toolMenuTemp.push(hasWrite && currentPhoto?.data && !item?.isShowThumbnail ? Action.DELETE : Action.DELETE_INVALID);

    // 更多菜单按钮
    let moreMenuTemp: Action[] = [];
    if (!DeviceInfo.isTv()) {
      moreMenuTemp.push(hasWrite && currentPhoto?.data ? Action.MOVE : Action.MOVE_INVALID);
      let isExportVideo: boolean | undefined = currentPhoto?.isExportVideo();
      if (PrintUtil.suffix(currentPhoto)) {
        moreMenuTemp.push(Action.PRINT);
      }
      moreMenuTemp.push(hasWrite && currentPhoto?.data ? Action.RENAME : Action.RENAME_INVALID);
    }
    if ((DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) &&
      currentPhoto.data?.photoType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO &&
      this.pageFrom !== BrowserCaller.VIEWDATA_PAGE) {
      moreMenuTemp.push(Action.SLIDE_SHOW);
    }
    // Pad 大图组件更换封面
    if (DeviceInfo.isTablet() && (this.albumInfo?.isUserCreatedAlbum || this.albumInfo?.isSourceAlbum)) {
      let albumCoverMenu = this.getAlbumCoverMenuItem(currentPhoto, index);
      if (albumCoverMenu !== undefined) {
        moreMenuTemp.push(albumCoverMenu);
      }
    }
    //PC相机大图进详情，保留状态栏，且详情按钮放在更多外
    moreMenuTemp.push(hasWrite && currentPhoto?.data ? Action.INFO : Action.INFO_INVALID);
    if (!DeviceInfo.isTv() && !DeviceInfo.isEmulator() && !DeviceInfo.isPc() && !this.isSandboxEnv &&
      currentPhoto?.mediaType === photoAccessHelper.PhotoType.IMAGE && !DeviceInfo.isVerdeFoldable() &&
      !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      moreMenuTemp.unshift(hasWrite && currentPhoto?.data && !this.isMovingPhotoSwitching ?
      Action.SET_WALLPAPER : Action.SET_WALLPAPER_INVALID);
    }
    Log.info(TAG, `updateMenuForLibrary end`);
  }

  private getAlbumCoverMenuItem(currentPhoto: MediaItem | undefined, index: number): Action | undefined {
    Log.info(TAG, " coverUriSource :" + this.albumInfo?.coverUriSource + " index :" + index);
    // coverUriSource : 0 表示默认封面 ,其余值表示 自定义封面
    return undefined;
  }

  // TODO: updateMenu重构后移动到PhotosHmBrowserController
  public updateAssetFavorState() {
    if (this.pageFrom !== BrowserCaller.CAMERA_PAGE) {
      Log.info(TAG, `photobrowser disappear update Favor state`);
      this.favorCacheItemsMap.forEach((item: MediaItem): void => {
        if (item.data) {
          let data: PhotoAsset = item.data as PhotoAsset;
          data.setFavorite(item.isFavor);
        } else {
          Log.error(TAG, 'item.data is not a valid PhotoAsset.');
        }
      });
      this.favorCacheItemsMap.clear();
    }
  }

  // TODO: updateMenu重构后移动到PhotosHmBrowserController
  private setFavorCacheItemsMap(currentPhoto: MediaItem) {
    if (UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
      let key = currentPhoto.uri;
      if (this.favorCacheItemsMap.has(key)) {
        let tempPhotoItem: MediaItem | undefined = this.favorCacheItemsMap.get(key);
        if (tempPhotoItem) {
          currentPhoto.isFavor = tempPhotoItem.isFavor;
        }
        this.favorCacheItemsMap.set(key, currentPhoto);
      }
    }
  }

  /**
   * 图库应用更新菜单栏信息
   * @param index
   */
  public async updateMenuForPhotoHm(index: number) {
    this.isFoldExpanded = DeviceInfo.isFoldable(); // 更新菜单栏之前更新xxx机手机xxx
    Log.info(TAG, `updateMenuForPhotoHm start`);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      return;
    }
    // 数据集查询相册信息
    let albumUri: string = this.dataSource.getAlbumDataSource()?.albumUri ?? '';
    let albumInfo: AlbumInfo | undefined = this.dataSource.getAlbumDataSource()?.albumInfo;
    let isEdit = false;
    try {
      isEdit = await currentPhoto?.isEditable?.();
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
    }
    let isVideo = currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    let isCloud: boolean = currentPhoto.getPosition() === photoAccessHelper.PositionType.CLOUD;

    let pageFrom: string = this.pageFrom;
    if (UserFileManagerAccess.isRecycleBin(albumUri)) {
      pageFrom = BrowserCaller.RECYCLE;
    }
    Log.info(TAG, `updateMenuForPhotoHm pageFrom:${pageFrom} uri:${albumUri} info:${albumInfo} isCloud:${isCloud}`);

    // 收藏相册处理
    this.setFavorCacheItemsMap(currentPhoto);

    /**
     * finalMenuList 菜单支持用户 Action 列表（）
     *  --- 配合 MenuTemp + list
     * toolMenuList 工具栏菜单支持用户 Action 列表
     *  --- 配合 list
     * moreMenuList 更多菜单支持用户 Action 列表
     */
    let menuTemp: Action[] = [];
    let effectAction: Action[] = [];
    if (lockedScreenMgr().isFromLockedScreen) {
      menuTemp = [];
      // TODO：FA入口适配(当前TAG版本无法调试，代码存在差异，)
    } else if (this.pageFrom === BrowserCaller.FACARD ||
      (this.isFromViewDataWithMediaUri && !UserFileManagerAccess.isRecycleBin(albumUri))) {
      menuTemp = [Action.GOTO_PHOTOS];
    }

    // 菜单支持用户 Action 列表
    let finalMenuList: Action[] = [];

    // list 表示工具栏按钮集合
    let list: Action[] = [];
    Log.info(TAG, `updateMenu ${pageFrom}`);
    switch (pageFrom) {
      case BrowserCaller.TIMELINE_PAGE:
      case BrowserCaller.TIMELINE_PAGE_GROUP:
      case BrowserCaller.VIEWDATA_PAGE:
      case BrowserCaller.ALBUM_PAGE:
      case BrowserCaller.SEARCH_GRID_PAGE:
      case BrowserCaller.PORTRAIT_PHOTO_GRID_PAGE:
      case BrowserCaller.SEARCH_SLOT_ITEM_PAGE:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
            this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        // 编辑按钮
        if (!DeviceInfo.isVerdeFoldable()) {
          list.push(!isEdit || this.isMovingPhotoSwitching ? Action.EDIT_INVALID : Action.EDIT);
        }
        // 删除按钮
        list.push(Action.DELETE);
        // 更多按钮
        finalMenuList.push(Action.MORE);
        break;
      case BrowserCaller.HIDDEN_ALBUM:
      case BrowserCaller.HIDDEN_GRID_ALBUM:
        if (this.isPrivateHideState) {
          list.push(currentPhoto.isFavor ? Action.FAVORITE_INV : Action.NOT_FAVORITE_INVALID);
        } else {
          list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        }
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          if (this.isPrivateHideState) {
            list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE_INVALID : Action.VIDEO_PLAY_INVALID,
              this.isMute ? Action.SOUND_OFF_FILLED_INVALID : Action.SOUND_FILLED_INVALID);
          } else {
            list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
              this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
          }
        } else {
          Log.info(TAG, '[normal picture]')
        }
        if (!DeviceInfo.isVerdeFoldable()) {
          list.push(!isEdit || this.isMovingPhotoSwitching || this.isPrivateHideState ?
          Action.EDIT_INVALID : Action.EDIT);
        }
        list.push(this.isPrivateHideState ? Action.DELETE_INVALID : Action.DELETE);
        finalMenuList.push(this.isPrivateHideState ? Action.MORE_INVALID : Action.MORE);
        break;
      case BrowserCaller.RECYCLE:
        // 动态照片、视频 按钮
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
            this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        // 删除 按钮
        list.push(Action.DELETE);
        // 更多按钮
        finalMenuList.push(Action.MORE);
        break;
      case BrowserCaller.HIGHLIGHT_PAGE:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
            this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
        }
        if (!DeviceInfo.isVerdeFoldable()) {
          list.push(Action.EDIT);
        }
        list.push(Action.DELETE);
        finalMenuList.push(Action.MORE)
        break;
      default:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
            this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        if (!DeviceInfo.isVerdeFoldable()) {
          list.push(Action.EDIT);
        }
        list.push(Action.DELETE);
        finalMenuList.push(Action.MORE)
        break;
    }

    // toolMenuList 工具栏菜单支持用户 Action 列表
    let toolMenuList: Action[] = [];
    if (!DeviceInfo.isVerdeFoldable() && isOrientationHorizontal()) {
      finalMenuList.splice(-1, 0, ...list);
      toolMenuList = [];
    } else {
      if (!UiUtil.isActionArrayEqual(toolMenuList, list)) {
        toolMenuList = list;
      }
    }
    if ((DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde()) &&
    this.isFullMode && !lockedScreenMgr().isFromLockedScreen) {
      if (!isSublist(finalMenuList, list)) {
        finalMenuList = list.concat(finalMenuList);
      }
      toolMenuList = [];
    }
    if (!UiUtil.isActionArrayEqual(finalMenuList, menuTemp)) {
      finalMenuList = menuTemp.concat(finalMenuList);
    }

    // 更多菜单
    let moreMenuList: Action[] = [];
    Log.info(TAG, `curIndex: ${index}  isMoving: ${currentPhoto?.getIsMovingPhoto()},
    mediaType: ${currentPhoto?.mediaType}`);
    let isExportVideo: boolean = currentPhoto.isExportVideo();
    if (!albumInfo && this.pageFrom !== BrowserCaller.HIGHLIGHT_PAGE) {
      // 照片页
      moreMenuList = [Action.MOVE];
    } else {
      // 指定相册
      if (albumInfo?.isTrashAlbum) {
      } else {
        moreMenuList = [Action.MOVE];
      }
    }
    if (PrintUtil.suffix(currentPhoto as MediaItem) && !this.albumInfo?.isTrashAlbum) {
      moreMenuList.push(Action.PRINT);
    }
    if (!albumInfo?.isTrashAlbum) {
      moreMenuList.push(Action.RENAME);
    }
    // if ((DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) && !isVideo && this.isSupportSlideShow(albumInfo) &&
    //   this.pageFrom !== BrowserCaller.VIEWDATA_PAGE) {
    //   moreMenuList.push(Action.SLIDE_SHOW);
    // }
    if ((DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) && !isVideo && this.isSupportSlideShow(albumInfo)) {
      moreMenuList.push(Action.SLIDE_SHOW);
    }
    moreMenuList.push(Action.INFO);
    if (albumInfo?.isSourceAlbum || albumInfo?.isUserCreatedAlbum ||
      (albumInfo?.isSystemAlbum && DeviceInfo.isPhoneUx())) {
      let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getTargetIndex());
      let albumCoverMenu = this.getAlbumCoverMenuItem(currentPhoto, index);
      if (albumCoverMenu !== undefined) {
        moreMenuList.unshift(albumCoverMenu);
      }
    }
    if (!DeviceInfo.isEmulator() && !albumInfo?.isTrashAlbum &&
      currentPhoto.mediaType === photoAccessHelper.PhotoType.IMAGE && !DeviceInfo.isVerdeFoldable() &&
      !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      moreMenuList.unshift(this.isMovingPhotoSwitching ? Action.SET_WALLPAPER_INVALID : Action.SET_WALLPAPER);
    }
    this.emitCallback(LibraryConstants.MENU_KEY_UPDATE_CALLBACK,
      [finalMenuList, toolMenuList, moreMenuList, this.showMovingPhotoCloseEffect, effectAction]);
    Log.info(TAG, 'updateMenuForPhotoHm complete');
  }

  private isSupportSlideShow(albumInfo: AlbumInfo | undefined): boolean {
    // false
    return !(albumInfo?.isTrashAlbum ||
      this.pageFrom === BrowserCaller.HIGHLIGHT_PAGE);
  }

  /**
   * 更新菜单栏信息
   *
   * @param index 当前图片 index 信息
   * @param isShowVideo 是否展示视频组件标志
   */
  public async updateMenu(index: number, isShowVideo?: boolean): Promise<void> {
    Log.info(TAG, `controller updateMenu pageFrom:${this.pageFrom} index:${index}`);
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      this.updateMenuForLibrary(index, isShowVideo);
    } else {
      this.updateMenuForPhotoHm(index);
    }
  }

  public isSupportImageEditorReport() {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getCurrentIndex());
    let hasWrite: boolean = (this.mediaPermissionFlag & PermissionFlag.WRITE_IMAGEVIDEO) ===
    PermissionFlag.WRITE_IMAGEVIDEO;
    if (currentPhoto?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
      const msg: Record<string, string | boolean | undefined> = UiUtil.isImageEditedEnable(currentPhoto, hasWrite);
      ReportToBigDataUtil.report(BigDataConstants.SUPPORT_IMAGE_EDITOR, msg);
    }
  }

  public setIsPhotoSwitching(isSwitching: boolean): void {
    this.isMovingPhotoSwitching = isSwitching;
    this.updateMenu(this.getTargetIndex());
  }

  public pullUpToCamera(): void {
  }

  /**
   * 从数据集中读取当前图片
   *
   * @returns 当前图片对应的 MediaItem
   */
  public getCurrentPhoto(): MediaItem | undefined {
    Log.info(TAG, `getCurrentPhoto currentIndex: ${this.getCurrentIndex()} ` +
      `targetIndex: ${this.getTargetIndex()}`);
    let currentPhoto: MediaItem | undefined = this.dataSource.getRawData(this.getCurrentIndex()).data;
    if (!currentPhoto) {
      this.initDataOnceMoreWhenError();
      Log.warn(TAG, `getCurrentPhoto currentIndex: ${this.getCurrentIndex()}, currentPhoto is undefined` +
       `cameraAlbumInfo ${PhotoBrowserGetCameraAlbum?.cameraAlbumInfo?.uri}`);
    }
    Log.info(TAG, `getCurrentPhoto success! getCurrentPhoto currentIndex: ${this.getCurrentIndex()}`)
    return currentPhoto;
  }

  private initDataOnceMoreWhenError(): void {
    Log.info(TAG, `init data once more, pageFrom: ${PhotoConfig.isLibrary()}, album: ${PhotoBrowserGetCameraAlbum.cameraAlbumInfo}`);
    if (!this.initDataMoreOne && PhotoConfig.isLibrary() && PhotoBrowserGetCameraAlbum.cameraAlbumInfo) {
      Log.error(TAG, `getCurrentPhoto currentIndex initData once more, items ${this.dataSource?.getAlbumDataSource()?.items?.length}`);
      this.dataSource.getAlbumDataSource()?.initData();
      this.initDataMoreOne = true;
    }
  }

  /**
   * 基于图片 index，读取指定图片
   *
   * @param index 图片的 index 信息
   * @returns 指定图片对应的 MediaItem
   */
  public getPhotoByIndex(index: number): MediaItem | undefined {
    return this.dataSource.getRawData(index).data;
  }

  /**
   * 大图组件切后台的回调
   */
  public onBackground(): void {
    Log.info(TAG, 'onBackground');
    if (!this.isJumpToPhoto) {
      this.updateTransIdAndDoMenuBack();
    } else {
      this.isJumpToPhoto = false;
    }
  }

  /**
   * 更新GeometryId，返回隐藏大图组件
   */
  protected updateTransIdAndDoMenuBack(isNoPhotos?: boolean): void {
    Log.info(TAG, `is enableSingle: ${this.enableSingleGeometryId}`);
    if (!this.enableSingleGeometryId) {
      this.emitCallback(LibraryConstants.UPDATE_TRANS_ID, [this.geometryTransitionId]);
    }

    if (!PhotoConfig.isLibrary()) {
      this.emitCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, [isNoPhotos]);
      return;
    }

    if (DeviceInfo.isTv() || (DeviceInfo.isPhoneUx() && isOrientationHorizontal() && !DeviceInfo.isVerdeFoldable()
      && !DeviceInfo.isFoldable())) {
      Log.info(TAG, `Do Portrait Rotate`);
      // Do rotate screen first, making sure back animation runs well
      if (!this.isSandboxEnv && this.isSupportRotation) {
        WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      }
      this.offSensorOrientation();
      setTimeout((): void => {
        if (!this.isSandboxEnv) {
          this.setRotationCapability(false);
        }
        this.emitCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, [isNoPhotos]);
      }, BrowserConstants.DELAY_FOR_ROTATE_SCREEN)
    } else {
      if (!this.isSandboxEnv) {
        this.setRotationCapability(false);
      }
      this.emitCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, [isNoPhotos]);
    }
  }

  // display的朝向和window的朝向值不同，通过display朝向得到对应的window朝向枚举值
  protected getWindowOrientationValue(orientation: number): number {
    let result: number = 0;
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        result = window.Orientation.USER_ROTATION_PORTRAIT;
        break;
      case display.Orientation.LANDSCAPE:
        result = (DeviceInfo.isTablet() && !PhotoConfig.isLibrary()) ? window.Orientation.USER_ROTATION_LANDSCAPE :
        window.Orientation.USER_ROTATION_LANDSCAPE_INVERTED;
        break;
      case display.Orientation.PORTRAIT_INVERTED:
        result = window.Orientation.USER_ROTATION_PORTRAIT_INVERTED;
        break;
      case display.Orientation.LANDSCAPE_INVERTED:
        result = (DeviceInfo.isTablet() && !PhotoConfig.isLibrary()) ?
        window.Orientation.USER_ROTATION_LANDSCAPE_INVERTED : window.Orientation.USER_ROTATION_LANDSCAPE;
        break;
      default:
        result = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
        break;
    }
    return result;
  }

  public releasePixelMap(): void {
    this.pixmap?.release();
    this.pixmap = undefined;
  }

  /**
   * 大图组件返回操作回调
   * isMouseScrolling  首次进入相机大图动效中是否鼠标滚动
   */
  public onBackPress(isNoPhotos?: boolean, isMouseScrolling?: boolean, browserControllerId?: number): void {}

  /**
   * 图片重命名回调
   *
   * @param result 编辑后的图片标题
   */
  private updatePhotoName(result: TitleName, uniqueId?: string): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto) {
      Log.info(TAG, `updatePhotoName result:${
      StringUtil.garbleFileName(result?.title)}, currentPhoto.uniqueId: ${currentPhoto.uniqueId}, uniqueId: ${
      uniqueId}`);
      if (currentPhoto.uniqueId === uniqueId) {
        currentPhoto.setTitle(result.title);
        currentPhoto.displayName = result.displayName;
      }
      this.appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [currentPhoto]);
    }
  }

  /**
   * 插桩回调，在页面 onPageShow 结束时触发，用于大图组件是否激活状态更新，已经图片容器 Swiper 动画的启动
   *
   * @param isEditorShown
   */
  public onPageShowEnd(isEditorShown: boolean): void {
    Log.info(TAG, 'call onPageShowEnd');
    if (this.isJumpToPhoto) {
      this.isJumpToPhoto = false;
    }
    this.syncPhotoName();
    this.updateActionBar(this.getCurrentIndex());
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [CHANGE_SWIPER_DURATION]);
    this.viewTime = Date.now();
  }

  /**
   * 插桩回调，在页面 onPageHide 结束时候触发，用于大图组件是否激活状态更新, 以及关闭系统横竖屏监听回调
   */
  public onPageHideEnd(): void {
    Log.info(TAG, 'call onPageHideEnd');
    this.offSensorOrientation();
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
  }

  /**
   * 数据集 dataSource 内容有变化时候触发回调，以相机场景为例子，通常发生在生成新图片、新视频时候
   *
   * @param changeType 新增内容类型，当前支持图片或视频
   */
  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy type: ${JSON.stringify(nfyInfo)}`);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.getCurrentIndex());
    if (!this.dataSource || !this.isUsefulNotify(nfyInfo)) {
      Log.info(TAG, 'dataSource is empty');
      return;
    }
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE && !PhotoBrowserGetCameraAlbum.cameraAlbumInfo) {
      // 还没获取到相机相册，重新获取一次相机相册
      Log.info(TAG, `onMediaLibDataNfy getCameraAlbumInfo`);
      let listeners = this.dataSource.getAlbumDataSource()?.listeners;
      let needCreateDataSource: boolean = !listeners || listeners.length <= 0;
      this.setCameraAlbumInfo(needCreateDataSource, () => {
        // 完成后继续响应媒体库通知，重新获取一次数据，刷新界面
        this.dataSource.switchRefreshOn();
        this.dataSource.onNotify(nfyInfo, true);
        if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD) {
          Log.debug(TAG, `new photo is added, uri is ${nfyInfo.uris.toString()}`)
          if (nfyInfo.uris[0] === Heic2JPGManagerAccess.addedResUri) {
            this.onHeic2JPGCompleted(nfyInfo);
          }
        }
      });
    }
    this.dataSource.switchRefreshOn();
    this.dataSource.onNotify(nfyInfo, true);
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD) {
      Log.debug(TAG, `new photo is added, uri is ${nfyInfo.uris.toString()}`)
      if (nfyInfo.uris[0] === Heic2JPGManagerAccess.addedResUri) {
        this.onHeic2JPGCompleted(nfyInfo);
      }
    }
  }

  private async onHeic2JPGCompleted(nfyInfo: MediaObserverNfyInfo): Promise<void> {
    let addedResUri = nfyInfo.uris[0];
    let displayName = nfyInfo.uris[0].toString().split('/').pop()?.toString();
    Log.info(TAG, `onHeic2JPGCompleted ${displayName} ${addedResUri}`);
    if (this.showLoadingTimerId) {
      clearTimeout(this.showLoadingTimerId);
      this.showLoadingTimerId = undefined;
    }
    this.appBroadCast.emit(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, [false]);
    let currentPhoto = this.getPhotoByIndex(this.getCurrentIndex());
    if (!currentPhoto) {
      Log.info(TAG, `onHeic2JPGCompleted null ${displayName} ${addedResUri}`);
      return;
    }
    let waitCount = 0;
    let targetItem = await this.dataSource.getDataByUri(addedResUri);
    Log.info(TAG, `onHeic2JPGCompleted targetItem ${targetItem.uri}`);
    Heic2JPGManagerAccess.isDirtyToJPG = false;
    setTimeout((): void => {
      this.jump2JPG(addedResUri, displayName || '', waitCount);
    }, DELAY_TIME)
  }

  private async jump2JPG(addedResUri: string, displayName: string, waitedCount: number): Promise<void> {
    let newIndex = this.dataSource.getDataIndexByUri(addedResUri);
    Log.info(TAG, `jump2JPG ${displayName} ${addedResUri} ${newIndex}`);
    if (waitedCount === Heic2JPGManagerAccess.MAX_WAIT_TIME) {
      return;
    }
    if (newIndex === Constants.NOT_FOUND) {
      setTimeout((): void => {
        Log.debug(TAG, `wait count ${++waitedCount}`)
        this.jump2JPG(addedResUri, displayName, waitedCount);
      }, DELAY_TIME_CONVERT);
    } else {
      let currentPhoto = this.getPhotoByIndex(this.getCurrentIndex());
      if (!currentPhoto) {
        Log.info(TAG, `jump2JPG currentPhoto ${currentPhoto} ${this.getCurrentIndex()}`);
        return;
      }
      this.stateMachine.processHeic2JPGEvent(newIndex, Math.abs(this.getCurrentIndex() - newIndex) < 10);
    }
  }

  /**
   * 过滤无效通知，大图组件不关注除增删改外的其他通知
   * @param nfyInfo
   * @returns
   */
  private isUsefulNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    if (this.pageFrom === BrowserCaller.CAMERA_PAGE) {
      // 相机相册不拦截相册的新增和移除通知
      return nfyInfo.type === MediaObserverNfyType.PHOTO_ADD ||
        nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE ||
        nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE ||
        nfyInfo.type === MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM ||
        nfyInfo.type === MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM;
    } else {
      return nfyInfo.type === MediaObserverNfyType.PHOTO_ADD ||
        nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE ||
        nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE;
    }
  }

  /**
   * 数据集 dataSource 内容有变化时候触发回调，以相机场景为例子，通常发生在生成新图片、新视频时候
   *
   * @param changeType 新增内容类型，当前支持图片或视频
   */
  public onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    if (!this.dataSource) {
      Log.info(TAG, 'dataSource is empty');
      return;
    }
    this.dataSource.switchRefreshOn();
    this.dataSource.onChange(changeType, true);
  }

  /**
   * 数据上报回调，上报用户水平滑动切图动作
   *
   * @param index 图片下标 index 信息
   */
  private reportToBigDataForPhotoSlide(index: number): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto && index != this.getCurrentIndex() && this.viewTime != 0) {
      let currentTime = Date.now();

      interface Msg {
        type: string;
        duration: number;
      }

      let msg: Msg = {
        type: currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
        BigDataConstants.VIDEO : BigDataConstants.NORMAL_PHOTO,
        duration: (currentTime - this.viewTime),
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_SLIDE_ID, msg);
      this.viewTime = Date.now();
    }
  }

  /**
   * 同步图片标题信息
   */
  private syncPhotoName(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto) {
      this.syncPhotoNameProcess(currentPhoto).then((result: TitleName) => {
        if (result) {
          this.updatePhotoName(result);
          this.broadCast.emit(BrowserConstants.UPDATE_PHOTO_NAME + currentPhoto?.path, [result.title]);
        }
      });
    }
  }

  /**
   * 通过数据库查询，完成同步图片标题信息
   *
   * @param currentPhoto 当前图片信息
   * @returns 图片对应标题信息
   */
  private async syncPhotoNameProcess(currentPhoto: MediaItem): Promise<TitleName> {
    Log.debug(TAG, 'syncPhotoNameProcess start');
    let renameResult: TitleName = { title: '', displayName: '' };
    let fileAsset = await this.dataSource.getDataByUri(currentPhoto.uri);
    if (fileAsset) {
      renameResult.title = fileAsset.get(UserFileManagerAccess.FILE_KEY_TITLE.toString()) as string;
      renameResult.displayName = fileAsset.displayName;
    } else {
      let key: string = `renameResult${currentPhoto.uri}`;
      renameResult = AppStorage.get<TitleName>(key) ?? renameResult;
      AppStorage.delete(key);
    }
    Log.debug(TAG, `syncPhotoName end, renameResult : ${JSON.stringify(renameResult)}`);
    return renameResult;
  }

  /**
   * 拉起大图组件初始化SystemUi属性
   *
   * @param isHorizontal 是否是横屏
   */
  public initSystemUi(isHorizontal: boolean) {
  }

  /**
   * 设置系统 UI 风格，沉浸式/非沉浸式
   *
   * @param isShowBar 是否展示顶部栏
   */
  public setSystemUi(isShowBar: boolean): void {
    this.isShowBar = isShowBar;
    if (isShowBar) {
      getScreen().setSystemUi(isShowBar);
    } else {
      getScreen().setSystemUi(isShowBar, !isShowBar, true);
    }
  }

  public setIsShowBar(isShowBar: boolean): void {
    this.isShowBar = isShowBar;
  }

  /**
   * 设置默认的状态栏背景及内容的显示颜色
   */
  public setDefaultStatusBarProperties(): void {
    getScreen().setDefaultStatusBarProperties(true);
  }

  /**
   * 设置大图组件是否可以通过修改窗口模式来适配横竖屏旋转
   * @param isSupportRotation
   */
  public setSupportRotation(isSupportRotation: boolean): void {
    this.isSupportRotation = isSupportRotation;
  }

  // public photosRotateType: string = PhotosRotateType.TYPE_SYSTEM;

  /**
   * 设置大图组件是否响应窗口横竖屏旋转
   * @param isSupportRotation
   */
  public setRotationCapability(isRotation: boolean): void {
    this.breakpointSystem.registerOrientationChange();
    Log.info(TAG, `setRotationCapability isRotation: ${isRotation}`);
    if (!this.isSupportRotation) {
      return;
    }
    // this.photosRotateType = PhotosRotateController.getPhotosRotateType(getContext(this));
    if (isRotation) {
      //图片旋转模式--始终
      // if (DeviceInfo.isPhone() && !DeviceInfo.isFoldDevice() && this.photosRotateType == PhotosRotateType.TYPE_ALWAYS) {
      //   Log.info(TAG, `setRotationCapability setRotation: ${window.Orientation.AUTO_ROTATION}`);
      //   WindowUtil.setPreferredOrientation(this.abilityContext, window.Orientation.AUTO_ROTATION);
      // } else {
      //   Log.info(TAG, `setRotationCapability setRotation: ${window.Orientation.AUTO_ROTATION_UNSPECIFIED}`);
      //   WindowUtil.setPreferredOrientation(this.abilityContext, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      // }
    } else {
      WindowUtil.setPreferredOrientation(this.abilityContext,
          DeviceInfo.isSmallFoldState() ? window.Orientation.PORTRAIT : window.Orientation.UNSPECIFIED);
      this.breakpointSystem.unregisterOrientationChange();
    }
  }

  /**
   * 大图组件控制器监听回调统一注册入口
   *
   * @param event 回调监听关键字
   * @param callback 回调具体实现
   */
  public registerCallback(event: string, callback: Function): void {
    let cbs = this.mCallbacks.get(event);
    if (!cbs) {
      cbs = [];
      this.mCallbacks.set(event, cbs);
    }
    cbs.push(callback);
  }

  /**
   * 大图组件控制器监听回调统一注销入口
   *
   * @param event 回调监听关键字
   * @param callback 回调监听关键字
   */
  public unregisterCallback(event?: string, callback?: Function): void {
    if (!event) {
      this.mCallbacks = new Map();
      return;
    }
    if (!callback) {
      this.mCallbacks.delete(event);
      return;
    }

    const cbs = this.mCallbacks.get(event);
    if (!cbs) {
      return;
    }
    let length = cbs.length;
    for (let i = 0; i < length; i++) {
      let cb = cbs[i];
      if (cb === callback) {
        cbs.splice(i, 1);
        break;
      }
    }

    // Delete callback array if empty
    let newLength = cbs.length;
    if (newLength === 0) {
      this.mCallbacks.delete(event);
    }
  }

  /**
   * 大图组件控制器监听回调统一触发执行入口
   *
   * @param name 回调监听关键字
   * @param argument 回调入参列表
   */
  public emitCallback(event: string, args: SelfObject[]): void {
    let cbs = this.mCallbacks.get(event);
    if (!cbs) {
      return;
    }
    let l = cbs.length;
    for (let i = 0; i < l; i++) {
      cbs[i]?.(...args);
    }
  }

  /**
   * 跳转编辑页面
   *
   * @param item 待编辑图片
   * @param isRemoteSource 是否云图
   */
  private jumpToEditPage(item: MediaItem, isRemoteSource: boolean): void {
    this.emitCallback(LibraryConstants.JUMP_TO_EDIT_PAGE, [item, isRemoteSource]);
  }

  /**
   * 获取系统 NavigationBar 高度
   *
   * @returns NavigationBar 的高度值
   */
  public getNaviBarHeight(): number {
    return getScreen().getNaviBarHeight();
  }

  /**
   * 大图组件调用方，在注册的volumeChange事件中调用此方法，可在系统音量变化时，解除静音
   */
  onSystemVolumeChanged(): void {
    let isMute = AppStorage.get<boolean>('isMute');
    Log.info(TAG, `[videoPlayer] system volume changed, isMute: ${isMute}`);
    if (isMute) {
      AppStorage.set<boolean>('isMute', false);
    }
  }

  public removeCachedThumbnail(item?: MediaItem): void {
  }

  public lockThumbnail(): void {
  }

  public unlockThumbnail(): void {
  }

  public hasThumbnail(): boolean {
    return false;
  }

  public setCameraAnimController(): void {
  }

  public getIsBrowserFullShow(): boolean {
    return this.isBrowserFullShow;
  }

  public initSwingService(): void {
    if (!this.isPhotoBrowserViewShow) {
      Log.info(TAG, 'initSwingService ignored, view invisible');
      return;
    }
    Log.info(TAG, `browsercontroller initSwingService`);
  }

  public cancelSwingService(): void {
    Log.info(TAG, `browsercontroller cancelSwingService`);
  }

  public onAppearSwing(): void {
  }

  public onDisappearSwing(): void {
  }

  public onPageShowSwing(): void {
  }

  public onWindowStatusShareListen(windowType?: window.WindowStageEventType, windowStatus?: number): void {
  }

  public onPageHideSwing(): void {
  }

  /**
   * 进入大图动画期间，处理除了大图动画外的业务逻辑
   */
  public onEnterAnimating(): void {
  }

  public setLocalStorage(localStorage: LocalStorage | undefined): void {
    this.localStorage = localStorage;
  }

  public getLocalStorage(): LocalStorage | undefined {
    return this.localStorage;
  }
}

/**
 * 对外暴露接口，供三方使用：大图组件控制器初始化函数
 *
 * @param photoBrowserController 大图组件控制器实例，由三方传入
 * @param enableSingleGeometryId 是否开启一镜到底动效效果标志位
 * @param mediaUri 图片 Uri 信息
 */
export function initPhotoBrowserController(photoBrowserController: BasePhotoBrowserController,
  pageFrom: string = 'PhotoBrowserView', enableSingleGeometryId?: boolean, mediaUri?: string,
  isSandboxEnv?: boolean): void {
  photoBrowserController.init(pageFrom, enableSingleGeometryId, mediaUri, isSandboxEnv);
}

/**
 * 对外暴露接口，供三方使用：大图组件控制器注销函数
 *
 * @param photoBrowserController 大图组件控制器实例，由三方传入
 */
export function unInitPhotoBrowserController(photoBrowserController: BasePhotoBrowserController): void {
  photoBrowserController.unInit();
}

export async function handleTermination(): Promise<boolean> {
  let extend = await import('browsercommonphone');
  return extend.ImageEditorSDK.handleTermination();
}