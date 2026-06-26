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

import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy {
  Constants as BrowserConstants,
  Constants as PhotoConstants
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  getScreen,
  isOrientationHorizontal,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy {
  AvPlayConstants,
  AvplayerStatus,
  MediaPosition,
  PageStatus,
  PlayType,
  LoadProgressType,
  XComponentStatus,
  VideoReportParams,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy fs from '@ohos.file.fs';
import lazy { PlayProgress } from './PlayProgress';
import lazy { VideoPlayController } from '../controller/VideoPlayController';
import lazy { BusinessError } from '@ohos.base';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { ShortCut } from '@ohos/common/src/main/ets/default/model/ShortCut';
import lazy { VideoAnalyzerAdaptor } from '../controller/VideoAnalyzerAdaptor';
import lazy { media } from '@kit.MediaKit';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { NetQualityUtil } from '../utils/NetQualityUtil';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';

import lazy {
  ShortcutManager,
  ShortcutController
} from '../../../../../../browserCommon/src/main/ets/default/controller/ShortcutController';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { image } from '@kit.ImageKit';
import lazy { AudioSessionController, AudioSessionParams, AudioSessionStrategy } from '../controller/AudioSessionController';
import lazy { audio } from '@kit.AudioKit';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { VideoPlayerVM } from '../viewModel/base/VideoPlayerVM';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PhotoBrowserStateMachine } from '../viewModel/statemachine/PhotoBrowserStateMachine';
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { MediaLibraryData } from '@ohos/common/src/main/ets/default/model/browser/photo/data/MediaData';

export class VideoPlayerBigDataReport {
  public static videoPlay(params: VideoReportParams): void {
    Log.info(TAG, `vpl ${params.url} ${params.position}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'subtype': params.subtype,
      'quality': params.quality,
      'position': params.position
    };
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_PLAY, msg);
  }

  public static videoPlayStartSuccess(params: VideoReportParams): void {
    Log.info(TAG, `vpss ${params.url} ${params.position} ${params.timeCost} ${params.bitrate}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'position': params.position,
      'subtype': params.subtype,
      'quality': params.quality,
      'timeCost': params.timeCost,
      'bitrate': params.bitrate,
      'netType': params.netType,
      'netDownWidthAvg': params.netDownWidthAvg,
      'netDownRateAvg': params.netDownRateAvg,
      'netRttMsAvg': params.netRttMsAvg,
    };
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_PLAY_START_SUCCESS, msg);
  }

  public static videoPlayerErrorHappened(params: VideoReportParams): void {
    Log.info(TAG, `vpeh ${params.url} ${params.code} ${params.position}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'code': params.code,
      'position': params.position,
      'duration': params.duration,
      'playDuration': params.playDuration
    };
    ReportToBigDataUtil.errEventReport(BigDataConstants.VIDEO_PLAYER_ERROR_HAPPENED, msg);
  }

  public static cloudVideoBufferTimes(params: VideoReportParams): void {
    Log.info(TAG, `cvbt ${params.url} ${params.bufferTimes}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'bufferTimes': params.bufferTimes
    };
    ReportToBigDataUtil.report(BigDataConstants.CLOUD_VIDEO_BUFFER_TIMES, msg);
  }

  public static cloudVideoNetworkNoService(): void {
    ReportToBigDataUtil.report(BigDataConstants.CLOUD_VIDEO_NETWORK_NO_SERVICE);
  }

  public static cloudVideoBufferingShort(params: VideoReportParams): void {
    Log.info(TAG, `cvbs ${params.url} ${params.space}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'space': params.space,
      'netType': params.netType,
      'netDownWidthAvg': params.netDownWidthAvg,
      'netDownRateAvg': params.netDownRateAvg,
      'netRttMsAvg': params.netRttMsAvg,
    };
    ReportToBigDataUtil.report(BigDataConstants.CLOUD_VIDEO_BUFFERING_SHORT, msg);
  }

  public static cloudVideoCatonTime(params: VideoReportParams): void {
    Log.info(TAG, `cvct ${params.url} ${params.catonTime} ${params.totalTime}`);
    // 卡顿时长占比
    const rate: number = params.totalTime !== 0 ? params.catonTime / params.totalTime : -1;
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'totalTime': params.totalTime,
      'playTime': params.playTime,
      'catonTime': params.catonTime,
      'rate': rate,
      'netDownRateAvg': params.netDownRateAvg,
    };
    ReportToBigDataUtil.report(BigDataConstants.CLOUD_VIDEO_CATON_TIME, msg);
  }

  public static videoPlayFinish(params: VideoReportParams): void {
    Log.info(TAG, `vpf ${params.url} ${params.playTime} ${params.duration}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'subtype': params.subtype,
      'quality': params.quality,
      'position': params.position,
      'playTime': params.playTime,
      'duration': params.duration,
      'bufferTimes': params.bufferTimes,
      'totalTime': params.totalTime,
      'netType': params.netType,
    }
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_PLAY_FINISH, msg);
  }

  public static videoPause(params: VideoReportParams): void {
    Log.info(TAG, `vpa ${params.url} ${params.playTime} ${params.duration}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'subtype': params.subtype,
      'quality': params.quality,
      'position': params.position,
      'playTime': params.playTime,
      'duration': params.duration,
      'netType': params.netType,
      'pauseReason': params.pauseReason
    }
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_PAUSE, msg);
  }

  public static videoFastPlay(params: VideoReportParams): void {
    Log.info(TAG, `vfp ${params.url} ${params.position} ${params.fastPlayTime}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(params.url),
      'subtype': params.subtype,
      'quality': params.quality,
      'position': params.position,
      'fastPlayTime': params.fastPlayTime,
    }
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_FAST_PLAY, msg);
  }
}

/* instrument ignore file */
const TAG: string = 'videoPlayer';
const TV_MAX_FRAME_NUM: number = 12;

/**
 * 视频播放组件
 */
@Component
export struct VideoPlayer {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  @State isEditor: boolean = false;
  private replaceUriManager: ReplaceUriManager | undefined;
  // 控制器
  private videoPlayController?: VideoPlayController;
  private xComponentController?: XComponentController;
  // 基本信息，对应媒体的唯一标识
  @Prop private src: string;
  @Prop private path: string;
  @Prop private dateModified: number;
  @Prop private thumbnail: Thumbnail;
  @Prop private coverWidth: number;
  @Prop private coverHeight: number;
  @Consume @Watch('updatePosition') private mPosition: number;
  @Consume private isShowVideo: boolean;
  public hideThumbnailImageFunc: () => void = () => {
  }
  @Link item: MediaItem;
  private subType: number = -1;
  private photoQuality: number = -1;

  public getIsShowVideo(): boolean {
    return this.isShowVideo;
  }

  @Link pauseFromSubScreen: boolean;
  private isThird: boolean = false;
  @Prop private maxTime: number;
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  private replaceUriFunc: Function = async (oriUri: string, replaceUri: string): Promise<void> => {
    if (!this.src.startsWith(oriUri)) {
      return;
    }
    let oriMediaItem = this.replaceUriManager?.getOriginMediaItem(oriUri) ?? new MediaItem();
    this.refreshOnCoveredByEdit(oriMediaItem,
      this.replaceUriManager?.getReplaceMediaItem(oriMediaItem) ?? new MediaItem());
    this.isEditor = true;
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.videoPlayController?.reset();
      setTimeout((): void => {
        this.src = replaceUri;
        this.videoPlayController = VideoPlayController.getInstance(this.src);
        this.videoPlayController?.setVideoPlayer(this);
        this.videoPlayController?.setVideoSrc(this.src);
        this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
        this.isRefreshXComponent = !this.isRefreshXComponent;
      }, 200);
    }
  }
  private imageComplete: Function = (): void => {
  };
  private imageError: Function = (): void => {
    // 封面图加载失败时隐藏封面，避免一直显示空白背景
    this.isShowCoverPicture = false;
  };
  private placeHolderImage: string = '';
  // 广播工具
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private broadCast: BroadCast = new BroadCast();
  // 广播函数
  private playVideoFunc: Function = (fromCloudSync: boolean, uniqueId: string): void => this.playVideo(fromCloudSync, uniqueId);
  private videoSwiperGestureIndexChangedFunc: Function = (index: number): void => {
    this.videoSwiperGestureIndexChanged(index);
  };
  private onSwiperIndexChangedFunc: Function = (index: number): void => this.onSwiperIndexChanged(index);
  private videoBackPressFunc: Function = (): void => this.videoBackPress();
  private onVideoBackPressByMenuFunc: Function = (): void => this.onVideoBackPressByMenu();
  private refreshOnCoveredByEditFunc: Function = (beforeEdit: MediaItem, afterEdit: MediaItem): void => {
    this.refreshOnCoveredByEdit(beforeEdit, afterEdit);
  };
  private resetVideoBeforeEditFunc: Function = (url?: string): void => this.resetVideoBeforeEdit(url);
  private onClickVideoPause: Function = (): void => this.handleSubScreenPause();
  private onClickVideoPlay: Function = (): void => this.handleSubScreenPlay();
  private getVideoFrameFunc: Function = (id: string, index: number): void => {
    this.expandToFetchAllFrame();
  }
  // 状态
  @State @Watch('showCoverPictureWatch') private isShowCoverPicture: boolean = true;
  @State private zIndexOfCoverPicture: number = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
  @State public isShowLoadingProgress: boolean = false;
  @State public zIndexOfLoadingProgress: number = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
  @State private isShowProgress: boolean = false;
  @State private isRefreshXComponent: boolean = false;
  @State private isForcePlay: boolean = false;
  @State private isForcePlayCast: boolean = true;
  @State private loadingProgressHeight: number = AvPlayConstants.LOADING_PROGRESS_DEFAULT_PADDING;
  @StorageLink('isHorizontal') @Watch('calculateLoadingProgressHeight') private isHorizontal: boolean =
    isOrientationHorizontal();
  @Link xComponentHeight: number;
  // 拉起播放重试
  private attemptPlayVideoTimes: number = 0;
  private attemptPlayVideoMaxTimes: number = 5;
  private attemptWaitTime: number = 100;
  // 等待reset期间，重试次数
  private timesOfWaitReset: number = 0;
  private maxTimesOfWaitReset: number = 20;
  // 端云同步视频
  @Prop private mediaPosition: photoAccessHelper.PositionType = photoAccessHelper.PositionType.LOCAL;
  private cloudPlayWaitTime: number = 250;
  private isFullScreenKeyDown: boolean = false;
  // 宽高信息
  private hasClickedPlayButton: boolean = false;

  public getHasClickedPlayButton(): boolean {
    return this.hasClickedPlayButton;
  }

  @Prop private videoRealWidth: number;
  @Prop private videoRealHeight: number;
  @Prop private videoRatio: number;
  // 是否静音
  @StorageLink('isMute') private isMute: boolean = false;
  /**
   * 标志当前是否正在执行一镜到底动效
   */
  @Link isRunningAnimation: boolean;
  private surfaceID?: string;
  private fd?: number;
  @Consume backgroundColorResource: Resource;
  // 外屏到内屏接续播放
  @Prop isSubScreen: boolean = false;
  private onVideoPlayButtonClick?: Function;
  private onPreDragFun: Function = (): void => {
  };
  private onDragStartFun: Function = (): void => {
  };
  private onDropFun: Function = (): void => {
  };
  private onDragMoveFun: Function = (): void => {
  };
  private onDragEnterFun: Function = (): void => {
  };
  private onDragLeaveFun: Function = (): void => {
  };
  private onDragEndFun: Function = (): void => {
  };
  public surfaceXComponentMap: [string | undefined, XComponentStatus] = [, XComponentStatus.LOAD];
  // 前后台切换
  @LocalStorageLink(Constants.VIDEO_PAGE_STATUS) @Watch('pageStatusChanged') private pageStatus: PageStatus =
    PageStatus.SHOW;
  @Link videoCoverFrame: PixelMap[];
  private isVideoPauseCastDisconnect: boolean = false;
  private clickPlayButtonTime: number = -1;
  public beforePageHideStatus?: string;
  /**
   * 是否因音频焦点抢占导致的暂停
   */
  private audioInterruptPause: boolean = false;
  /**
   * 是否因编辑导致了视频宽高比变化
   */
  private videoRatioChangeByEdit: boolean = false;
  private continuePlaying: boolean = false;
  private attemptInterrupt: boolean = false;
  @Prop @Watch('onPageChanged') private pageStatusValue: boolean = false;
  // AI参数
  private videoAnalyzerAdaptor?: VideoAnalyzerAdaptor;
  @Prop private mIsCurrent: boolean = false;
  // private controller?: visionImageAnalyzer.VisionImageAnalyzerController;
  @LocalStorageLink('isBrowserShow') isBrowserShow: boolean = true;
  // 展开前预览条中进度条的位移，初始位置：首帧起始处
  @Prop private isFrameExpand: boolean = false;
  @StorageLink('networkAvailable') networkAvailable: boolean = false;
  public netQuality: NetQualityUtil | undefined;
  private imageShowSource: string | PixelMap | undefined = '';
  private playType: PlayType = PlayType.AUTOPLAY;
  private progressType: LoadProgressType = LoadProgressType.PREVIEW;
  public startPlayVideo: number = -1;
  /**
   * 一镜到底动效配对 ID
   */
  @Link geometryTransitionId: string;
  /**
   * 图片 x 轴方向位移，在下拉跟手动效中生效
   */
  @Link geometryOffsetX: number;
  /**
   * 图片 y 轴方向位移，在下拉跟手动效中生效
   */
  @Link geometryOffsetY: number;
  /**
   * 是否pickerView化场景
   */
  private isFromPickerView: boolean = false;
  /**
   * 防止进入编辑时触发滑动监听
   */
  private isRestBeforeEdit: boolean = false;
  @State isShowAstcCover: boolean = false;
  private isCoverHdr: boolean = false;
  @State hdrBrightness: number = 1;
  // 创建AVImageGenerator对象
  private avImageGenerator: media.AVImageGenerator | undefined;
  private expandAvImageGenerator: media.AVImageGenerator | undefined;
  private userId: number = -1;
  private albumInfo?: AlbumInfo;
  @State public isSpeedUp: boolean = false;
  private canFastPlay: boolean = true;
  private longPressStartTime: number = -1;
  private viewModel: VideoPlayerVM = new VideoPlayerVM(this.stateMachine);
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') @Watch('onCurrentModeChange')currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  onValueChange?: (isShowCoverPicture: boolean) => void;
  private onCurrentModeChange(): void {
    Log.info(TAG, `onCurrentModeChange:${this.currentMode}`);
  }
  // @State
  /**
   * 视频返回宫格时，使用缩略图做返回动效
   */
  private backPressEventFunc: Function = (): void => {
    this.isShowAstcCover = true;
  }
  // 进入大图动效复用时，重置参数
  private recoverImageShowSourceFunc: Function = (): void => {
    this.isShowAstcCover = false;
    this.setSpeedUpValue(false);
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.videoPlayController?.setVideoPlayer(this);
      this.videoPlayController?.setVideoSrc(this.src);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
      this.isShowProgress = !this.isSubScreen;
    }
  };
  private isOpening: boolean = false;
  private stateInversionFunc: (uri: string) => void = (uri: string): void => {
    this.stateInversion(uri);
  }
  private audioInterruptPauseFunc: Function = (): void => this.audioInterrupt();
  private audioSessionParams: AudioSessionParams = {
    audioSessionStrategy: AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS,
    activateCallback: () => {
      Log.info(TAG, '[audioSession] activate by videoPlayer: CONCURRENCY_PAUSE_OTHERS');
    },
    audioSessionDeActivateCallback: (event: audio.AudioSessionDeactivatedEvent): void => {
      if (event.reason === audio.AudioSessionDeactivatedReason.DEACTIVATED_LOWER_PRIORITY) {
        Log.info(TAG, `[audioSession] reason: ${event.reason}, will invoke pause`);
        this.videoPlayController?.pause(PauseReason.AUDIO);
      }
    }
  }
  private onVideoDownloadCompletedFunc: (uri: string) => void = (uri: string): void => {
    this.onVideoDownloadCompleted(uri);
  }

  public getSrc(): string {
    return this.src;
  }

  private normalizePathForFsOpen(input: string): string {
    if (!input) {
      return input;
    }
    // file manager docs uri, e.g. file://docs/storage/External/...
    const docsPrefix: string = 'file://docs';
    if (input.startsWith(docsPrefix)) {
      let p: string = input.substring(docsPrefix.length);
      if (p.length > 0 && !p.startsWith('/')) {
        p = '/' + p;
      }
      return decodeURI(p);
    }
    // generic file uri, e.g. file:///data/storage/... or file://<abs-path>
    const filePrefix: string = 'file://';
    if (input.startsWith(filePrefix)) {
      let p: string = input.substring(filePrefix.length);
      // handle file:///xxx -> /xxx
      if (p.startsWith('/')) {
        // already absolute
        return decodeURI(p);
      }
      // file://C:/... or other absolute formats: keep as-is after stripping scheme
      return decodeURI(p);
    }
    return input;
  }

  public setSpeedUpValue(value: boolean): void {
    Log.info(TAG, `set 'isSpeedUp' to ${value}`)
    this.isSpeedUp = value;
  }

  private stateInversion(uri: string): void {
    if (uri === this.src && this.videoPlayController) {
      let currentState: string | undefined = this.videoPlayController.getAvPlayerState();
      Log.info(TAG, `double click. current state:${currentState}`);
      if (currentState === AvplayerStatus.PLAYING) {
        this.videoPlayController.pause(PauseReason.DOUBLE_CLICK);
      }
      if (currentState === AvplayerStatus.PREPARED || currentState === AvplayerStatus.COMPLETED) {
        this.playVideo(this.mediaPosition === photoAccessHelper.PositionType.CLOUD, this.item.uniqueId);
      }
      if (currentState === AvplayerStatus.INITIALIZED) {
        this.onPrepared(uri);
      }
      if (currentState === AvplayerStatus.PAUSED) {
        this.videoPlayController.play();
      }
      if (!this.networkAvailable && currentState === AvplayerStatus.IDLE) {
        // 网络不可用
        UiUtil.showToast($r('app.string.no_network'));
        VideoPlayerBigDataReport.cloudVideoNetworkNoService();
        return;
      }
    }
  }

  private audioInterrupt(): void {
    Log.info(TAG, 'audio interrupt pause');
    this.audioInterruptPause = true;
  }

  private pageStatusChanged(): void {
    if (this.mPosition !== this.viewModel.getCurrentIndex()) {
      return;
    }
    if (!this.videoPlayController) {
      Log.error(TAG, 'page status changed, current videoPlayerController is undefined.');
      return;
    }
    this.videoPlayController.setPageStatus(this.pageStatus);
    let avplayerStatus: string | undefined = this.videoPlayController.getAvPlayerState();
    if (this.pageStatus === PageStatus.HIDE) {
      this.pageHideHandler(avplayerStatus);
    } else {
      this.pageShowHandler(avplayerStatus);
    }
  }

  private stopVideoAnalyzer(): void {
    let currentVideoState: string | undefined = this.videoPlayController?.getAvPlayerState();
    if (currentVideoState === AvplayerStatus.PLAYING) {
      this.videoAnalyzerAdaptor?.stopVideoAnalyzer();
    }
  }

  private startVideoAnalyzer(): void {
    let currentVideoState: string | undefined = this.videoPlayController?.getAvPlayerState();
    if (currentVideoState === AvplayerStatus.PAUSED) {
      this.videoAnalyzerAdaptor?.startVideoAnalyzer();
    }
  }

  private pageHideHandler(avplayerStatus?: string): void {
    Log.info(TAG, `onPageHide current avplayer status: ${avplayerStatus}, src: ${this.src}`);
    // 视频切换后台需要清除该变量,防止下次非卡片切换前台视频播放被重置
    LocalStorage.getShared().delete(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE);
    this.beforePageHideStatus = avplayerStatus;
    if (avplayerStatus === AvplayerStatus.PLAYING) {
      this.videoPlayController?.onPageHidePause();
    } else {
      Log.info(TAG, `onPageHide not invoke pause method, src: ${this.src}`);
      return;
    }
  }

  private pageShowHandler(avplayerStatus?: string): void {
    Log.info(TAG, `onPageShow before avplayer status: ${this.beforePageHideStatus},current: ${
    avplayerStatus},hasClickedPlayButton: ${this.hasClickedPlayButton},src: ${this.src}`);
    // 视频切换前台如果该flag为true,则重置, 仅点击卡片进入大图时设置该flag
    if (LocalStorage.getShared().get<boolean>(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE)) {
      LocalStorage.getShared().delete(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE);
      this.videoPlayController?.reset();
      return;
    }
    if (this.beforePageHideStatus === AvplayerStatus.PLAYING) {
      this.videoPlayController?.onPageShowPlay();
    } else if (this.hasClickedPlayButton) {
      this.videoPlayController?.play();
    } else {
      Log.info(TAG, `onPageHide or isHiddenAlbum not invoke play method, src: ${this.src}`);
      return;
    }
  }

  private getSurfaceID(): string | undefined {
    return this.surfaceID;
  }

  private setSurfaceID(id: string | undefined): void {
    this.surfaceID = id;
  }

  private updateOldProgress(progress: number, isShowVideo: boolean): void {
    this.isShowProgress = false;
    this.videoPlayController?.setBeforeMediaServiceDiedProgress(progress);
    this.videoPlayController?.setContinuePlayOnMediaServiceRevive(true);
    this.isShowVideo = isShowVideo;
    this.isForcePlay = true;
  }

  private showPlayProgress(isPausing: boolean): void {
    Log.info(TAG, `set progress isPause ${isPausing}`);
    setTimeout((): void => {
      this.isShowProgress = true;
      if (isPausing) {
        this.videoPlayController?.pause(PauseReason.CAST);
      }
    }, 500);
  }

  private initXComponent(): XComponentOptions {
    if (this.xComponentController) {
      return {
        type: XComponentType.SURFACE,
        controller: this.xComponentController,
        imageAIOptions: {
          types: [0, 1, 3],
          // aiController: this.controller,
        }
      }
    } else {
      // 编辑检查分支
      this.xComponentController = new XComponentController();
      this.videoAnalyzerAdaptor?.setXComponentController(this.xComponentController);
      return {
        type: XComponentType.SURFACE,
        controller: this.xComponentController,
        imageAIOptions: {
          types: [0, 1, 3],
          // aiController: this.controller,
        }
      }
    }
  }

  aboutToAppear() {
    Log.info(TAG, `aboutToAppear success,mPosition: ${this.mPosition},currentIndex: ${
    this.viewModel.getCurrentIndex()},maxTime: ${this.maxTime},mediaPosition: ${this.mediaPosition},src: ${
    this.src}, videoAnalyzerAdaptor: ${this.videoAnalyzerAdaptor} ,XComponentController ${this.xComponentController}
    , currentMode:${this.currentMode}`);
    this.decodeVideoLcdImageInfo();
    this.calculateLoadingProgressHeight();
    if (this.isEditor) {
      let items = this.replaceUriManager?.getReplaceOriAndReplaceMediaItem(this.src);
      if (items && items?.length !== 0) {
        this.videoRealWidth = items[1].width;
        this.videoRealHeight = items[1].height;
      }
    }
    this.userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (this.userId > 0) {
      this.src += `?user=${this.userId}`;
    }
    // 开启核心控制广播
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoSwiperGestureIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, this.videoBackPressFunc);
    this.broadCast.on(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, this.videoBackPressFunc);
    this.broadCast.on(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS_BY_MENU, this.onVideoBackPressByMenuFunc);
    this.appBroadCast.on(BroadCastConstants.PLAY_VIDEO, this.playVideoFunc);
    this.appBroadCast.on(BroadCastConstants.SWIPER_INDEX_CHANGED, this.onSwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.REFRESH_ON_COVERED_BY_EDIT, this.refreshOnCoveredByEditFunc);
    this.appBroadCast.on(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, this.resetVideoBeforeEditFunc);
    this.appBroadCast.on(BroadCastConstants.PAUSE_FROM_SUB_SCREEN, this.onClickVideoPause);
    this.appBroadCast.on(BroadCastConstants.PLAY_FROM_SUB_SCREEN, this.onClickVideoPlay);
    this.appBroadCast.on(BrowserConstants.PHOTO_PHOTO_BACK_PRESS, this.backPressEventFunc);
    this.broadCast.on(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, this.resetVideoBeforeEditFunc);
    this.appBroadCast.on(BroadCastConstants.RECOVER_SHOW_RESOURCE, this.recoverImageShowSourceFunc);
    this.appBroadCast.on(BroadCastConstants.STATE_INVERSION, this.stateInversionFunc);
    this.appBroadCast.on(BroadCastConstants.AUDIO_INTERRUPT_PAUSE + this.src, this.audioInterruptPauseFunc);
    this.appBroadCast.on(BroadCastConstants.ON_VIDEO_DOWNLOAD_COMPLETED, this.onVideoDownloadCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.GET_VIDEO_FRAME_FOR_PREVIEW + this.item.uniqueId, this.getVideoFrameFunc);
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.videoPlayController?.setVideoPlayer(this);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
    }
    if (this.pageStatusValue) {
      this.pageStatus = PageStatus.SHOW;
    }
    if (this.pageStatus === PageStatus.SHOW) {
      this.videoPlayController?.setPageStatus(PageStatus.SHOW);
    }
  }

  aboutToDisappear() {
    let traceId: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('videoPlayerAboutToDisappear', traceId);
    Log.info(TAG, `aboutToDisappear success,mPosition: ${this.mPosition},currentIndex: ${
    this.viewModel.getCurrentIndex()},src: ${this.src}`);
    this.videoAnalyzerAdaptor?.deinit();
    this.isShowProgress = false;
    this.isShowCoverPicture = true;
    this.attemptInterrupt = true;
    if (this.getMediaPosition() === MediaPosition.CLOUD) {
      this.netQuality?.unregisterNetQuality();
    }
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoSwiperGestureIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, this.videoBackPressFunc);
    this.broadCast.off(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, this.videoBackPressFunc);
    this.broadCast.off(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS_BY_MENU, this.onVideoBackPressByMenuFunc);
    this.appBroadCast.off(BroadCastConstants.PLAY_VIDEO, this.playVideoFunc);
    this.appBroadCast.off(BroadCastConstants.SWIPER_INDEX_CHANGED, this.onSwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.REFRESH_ON_COVERED_BY_EDIT, this.refreshOnCoveredByEditFunc);
    this.appBroadCast.off(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, this.resetVideoBeforeEditFunc);
    this.appBroadCast.off(BroadCastConstants.PAUSE_FROM_SUB_SCREEN, this.onClickVideoPause);
    this.appBroadCast.off(BroadCastConstants.PLAY_FROM_SUB_SCREEN, this.onClickVideoPlay);
    this.appBroadCast.off(BrowserConstants.PHOTO_PHOTO_BACK_PRESS, this.backPressEventFunc);
    this.broadCast.off(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, this.resetVideoBeforeEditFunc);
    this.appBroadCast.off(BroadCastConstants.RECOVER_SHOW_RESOURCE, this.recoverImageShowSourceFunc);
    this.appBroadCast.off(BroadCastConstants.STATE_INVERSION, this.stateInversionFunc);
    this.appBroadCast.off(BroadCastConstants.AUDIO_INTERRUPT_PAUSE + this.src, this.audioInterruptPauseFunc);
    this.appBroadCast.off(BroadCastConstants.ON_VIDEO_DOWNLOAD_COMPLETED, this.onVideoDownloadCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.GET_VIDEO_FRAME_FOR_PREVIEW + this.item.uniqueId, this.getVideoFrameFunc);
    this.thumbnail?.release();
    TraceControllerUtils.finishTraceWithTaskId('videoPlayerAboutToDisappear', traceId);
    this.avImageGenerator?.release();
    this.expandAvImageGenerator?.release();
    if (this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING) {
      this.videoPlayController?.reset();
    }
  }

  private onPageChanged(): void {
    if (this.pageStatusValue) {
      this.pageStatus = PageStatus.SHOW;
    } else {
      this.pageStatus = PageStatus.HIDE;
    }
  }

  private playVideo(fromCloudSync: boolean, uniqueId: string): void {
    Log.info(TAG, `playVideo check mPosition: ${this.mPosition},currentIndex: ${
    this.viewModel.getCurrentIndex()},src:${this.src}, uniqueId:${uniqueId}`);
    if (this.mPosition !== this.viewModel.getCurrentIndex()) {
      return;
    }
    if (uniqueId && uniqueId !== this.item.uniqueId) {
      return;
    }
    this.isForcePlay = true;
    this.hasClickedPlayButton = true;
    this.attemptInterrupt = false;
    let params: VideoReportParams = new VideoReportParams();
    params.url = this.src;
    params.position = fromCloudSync ? MediaPosition.CLOUD : MediaPosition.LOCAL;
    params.subtype = this.subType;
    params.quality = this.photoQuality;
    VideoPlayerBigDataReport.videoPlay(params);
    this.isShowVideo = true;
    if (this.playType === PlayType.CLICK_TO_PLAY) {
      this.initClickPlayButtonTime();
    }
    if (fromCloudSync) {
      this.playCloudVideo();
    } else {
      this.playLocalVideo();
    }
  }

  private playCloudVideo(): void {
    Log.info(TAG, `prepare play cloud video, mPosition and currentIndex: ${
    this.mPosition},mediaPosition: ${this.mediaPosition},src: ${this.src}`);
    this.isShowLoadingProgress = true;
    this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
    // 等待时间用于avplayer状态流转：idle -> initialized -> prepared
    setTimeout((): void => {
      this.playLocalVideo();
    }, this.cloudPlayWaitTime);
  }

  private playLocalVideo(): void {
    Log.info(TAG, `prepare play local video, mPosition: ${this.mPosition}, currentIndex: ${
    this.viewModel.getCurrentIndex()},mediaPosition: ${this.mediaPosition},state: ${
    this.videoPlayController?.getAvPlayerState()},src: ${this.src}`);
    if (this.attemptInterrupt) {
      Log.info(TAG, `play local video attempt interruptted, times: ${this.attemptPlayVideoTimes},src: ${this.src}`);
      return;
    }
    let avplayerStatus: string | undefined = this.videoPlayController?.getAvPlayerState();
    switch (avplayerStatus) {
      case AvplayerStatus.PAUSED:
        this.pauseHandler();
        break;
      case AvplayerStatus.PREPARED:
        this.preparedHandler();
        break;
      case AvplayerStatus.PLAYING:
        this.playingHandler();
        break;
      case AvplayerStatus.COMPLETED:
        this.completedHandler();
        break;
      case AvplayerStatus.IDLE:
        this.idleHandler();
        break;
      case undefined:
        Log.error(TAG, 'error happened on play local video, videoPlayController is undefined.');
        if (!this.videoPlayController) {
          break;
        }
        this.videoPlayController = VideoPlayController.getInstance(this.src);
        this.videoPlayController?.setVideoPlayer(this);
        this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
        setTimeout((): void => {
          this.playLocalVideo();
        }, this.attemptWaitTime);
        break;
      default:
        Log.info(TAG, `avplayer current state is ${
        this.videoPlayController?.getAvPlayerState()}, begin attempt play video`);
        if (this.mediaPosition === photoAccessHelper.PositionType.LOCAL) {
          this.attemptPlayLocalVideo();
        } else {
          this.attemptPlayCloudVideo();
        }
    }
  }

  private attemptPlayCloudVideo(): void {
    let status: string | undefined = this.videoPlayController?.getAvPlayerState();
    let overTimes: number = this.attemptPlayVideoTimes < this.attemptPlayVideoMaxTimes ?
      this.attemptWaitTime : this.attemptWaitTime * this.attemptPlayVideoMaxTimes;
    if ((status === AvplayerStatus.INITIALIZED || status === AvplayerStatus.IDLE)) {
      setTimeout((): void => {
        this.attemptPlayVideoTimes++;
        let currentState: string | undefined = this.videoPlayController?.getAvPlayerState();
        if (currentState !== AvplayerStatus.INITIALIZED && currentState !== AvplayerStatus.IDLE) {
          Log.info(TAG, `attemptPlayCloudVideo: state changed to ${currentState} during wait, skip retry. src: ${this.src}`);
          return;
        }
        this.playLocalVideo();
      }, overTimes);
    }
  }

  private attemptPlayLocalVideo(): void {
    if ((this.videoPlayController?.getAvPlayerState() === AvplayerStatus.INITIALIZED ||
      this.videoPlayController?.getAvPlayerState() === AvplayerStatus.IDLE) &&
      this.attemptPlayVideoTimes < this.attemptPlayVideoMaxTimes) {
      setTimeout((): void => {
        this.attemptPlayVideoTimes++;
        let currentState: string | undefined = this.videoPlayController?.getAvPlayerState();
        if (currentState !== AvplayerStatus.INITIALIZED && currentState !== AvplayerStatus.IDLE) {
          Log.info(TAG, `attemptPlayLocalVideo: state changed to ${currentState} during wait, skip retry. src: ${this.src}`);
          return;
        }
        this.playLocalVideo();
      }, this.attemptWaitTime);
    }
  }

  private pauseHandler(): void {
    // 快速点击返回和播放按钮，会出现pause慢导致的最终状态停留在paused
    this.completedHandler();
  }

  private preparedHandler(): void {
    this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
    this.videoPlayController?.setVolume(
      this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
    Log.info(TAG, `preparedHandler pageStatus: ${this.pageStatus} isMute: ${this.isMute}`);
    if (this.pageStatus === PageStatus.SHOW) {
      this.activeAudioSession('preparedHandler');
      this.videoPlayController?.play();
    }
  }

  private playingHandler(): void {
    if (this.videoPlayController?.getIsResetting() && this.timesOfWaitReset < this.maxTimesOfWaitReset) {
      Log.warn(TAG, `on click play button, current avplayer is resetting. attemptTimes: ${this.timesOfWaitReset}`);
      setTimeout((): void => {
        this.timesOfWaitReset++;
        this.playLocalVideo();
      }, this.attemptWaitTime);
    } else {
      Log.warn(TAG, 'the current video is already playing');
    }
  }

  private completedHandler(): void {
    this.isShowLoadingProgress = false;
    this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
    this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
    this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
    this.videoPlayController?.setVolume(
      this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
    this.activeAudioSession('completedHandler');
    this.videoPlayController?.play();
  }

  private idleHandler(): void {
    if (!this.videoPlayController?.getAvPlayer()?.url) {
      Log.info(TAG, 'current avplayer state is idle, and avplayer url undefined');
      this.setAvplayerUrlAndSurfaceId(this.src, this.getSurfaceID());
    }
  }

  private activeAudioSession(reason: string): void {
    let audioSessionController: AudioSessionController = AudioSessionController.getInstance();
    audioSessionController.cancelAudioSession({
      deActivateCallback: (): void => {
        Log.info(TAG, `[audioSession] deActivate by videoPlayer ${reason}: ${audioSessionController.getAudioSessionStrategy()}`);
        audioSessionController.setAudioSession(this.audioSessionParams);
      }
    });
  }

  public syncItemDurationFromAvPlayer(durationMs: number): void {
    if (!Number.isFinite(durationMs) || durationMs <= 0) {
      return;
    }
    const current: number | undefined = this.item?.duration;
    if (!Number.isFinite(current) || Number.isNaN(current) || (current ?? 0) <= 0) {
      this.item.duration = durationMs;
    }
    // PhotoPreviewer 使用 @Prop curItem，对 MediaItem 字段原地赋值不会触发 UI；SwiperVM 侧用 @Track 承接
    this.appBroadCast.emit(BroadCastConstants.VIDEO_DURATION_RESOLVED, [this.item.uniqueId, durationMs]);
  }

  public onPrepared(src: string): void {
    Log.info(TAG, `onPrepared,this.src: ${this.src},src: ${src},this.pageStatus: ${this.pageStatus}`);
    if (this.src === src && this.pageStatus === PageStatus.SHOW) {
      const preparedDuration: number = this.videoPlayController?.getAvPlayer()?.duration ?? Number.NaN;
      if (Number.isFinite(preparedDuration) && preparedDuration > 0) {
        this.syncItemDurationFromAvPlayer(preparedDuration);
      }
      Log.info(TAG, `on prepared auto play,isShowCoverPicture: ${
      this.isShowCoverPicture},mediaPosition: ${this.mediaPosition}`);
      if (this.playType === PlayType.AUTOPLAY ||
        (this.playType === PlayType.CLICK_TO_PLAY && this.hasClickedPlayButton)) {
        this.isShowProgress = false;
        this.isForcePlay = true;
        this.playVideo(this.mediaPosition === photoAccessHelper.PositionType.CLOUD, this.item.uniqueId);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_SHOW_VIDEO, []);
      }
    } else {
      Log.info(TAG, `on prepared not auto play, pageStatus: ${
      this.pageStatus}, param src: ${src}, this.src: ${this.src}.`);
    }
  }

  public onPlaying(src: string, surfaceId?: string): void {
    if (this.src === src) {
      // 播放后，状态重置
      this.audioInterruptPause = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_ZERO;
      Log.info(TAG, `on playing, update status. param surfaceId: ${
      surfaceId},current surfaceId: ${this.getSurfaceID()},src: ${this.src}, isShowCoverPicture: ${
      this.isShowCoverPicture}`);
      this.stopVideoAnalyzer();
      this.hasClickedPlayButton = false;
      this.attemptPlayVideoTimes = 0;
      this.timesOfWaitReset = 0;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_TWO;
      this.videoPlayController?.setContinuePlayOnMediaServiceRevive(true);
      setTimeout((): void => {
        this.isShowCoverPicture = false;
        this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      }, AvPlayConstants.REMOVE_COVER_DELAY)
      this.isShowProgress = true;
      this.isShowVideo = true;
      if (this.clickPlayButtonTime !== -1) {
        this.startPlayVideo = Date.now();
        let params: VideoReportParams = new VideoReportParams();
        params.url = this.src;
        params.position = this.getMediaPosition();
        params.timeCost = this.startPlayVideo - this.clickPlayButtonTime;
        params.subtype = this.subType;
        params.quality = this.photoQuality;
        if (this.videoPlayController) {
          params.bitrate = this.videoPlayController.bitrate;
        }
        if (this.netQuality) {
          params.netType = this.netQuality.netType();
          params.netDownWidthAvg = this.netQuality.netDownWidthAvg();
          params.netDownRateAvg = this.netQuality.netDownRateAvg();
          params.netRttMsAvg = this.netQuality.netRttMsAvg();
        }
        VideoPlayerBigDataReport.videoPlayStartSuccess(params);
        this.clickPlayButtonTime = -1;
      }
    } else {
      Log.error(TAG, `on playing error, param src: ${src}, this.src: ${this.src}.`);
    }
  }

  public onPaused(src: string): void {
    // 频繁返回与点击播放，会出现pause超时，点击播放后才pause完成，此时需自动起播
    if (this.src === src && this.hasClickedPlayButton) {
      Log.info(TAG, `on paused, time out and click play button, invoke play method automatically,src: ${this.src}.`);
      this.videoPlayController?.play();
    } else if (this.src === src) {
      // paused回调，若media service died时avplayer处于paused状态，则不响应拉起后自动续播，并seek到故障点
      this.videoPlayController?.setContinuePlayOnMediaServiceRevive(false);
      this.startVideoAnalyzer()
      Log.info(TAG, `on paused, hasClickedPlayButton: false, param src equals this.src: ${this.src}.`);
    } else {
      Log.info(TAG, `on paused, hasClickedPlayButton: ${
      this.hasClickedPlayButton},param src: ${src}, this.src: ${this.src}.`);
    }
  }

  public onCompleted(src: string): void {
    if (this.src === src) {
      if (!this.isFrameExpand) {
        this.isShowCoverPicture = true;
        this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
        this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
        setTimeout((): void => {
          this.appBroadCast.emit(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, [0]);
        }, AvPlayConstants.RESET_PREVIEW_BAR_DELAY)
      }

      this.setSpeedUpValue(false);
      this.fastPlayExit();

      this.isShowLoadingProgress = false;
      this.videoPlayController?.resetProgress();
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.videoPlayController?.setContinuePlayOnMediaServiceRevive(false);
    } else {
      Log.error(TAG, `on completed error, param src: ${src}, this.src: ${this.src}.`);
    }
  }

  public getMediaPosition(): MediaPosition {
    return this.mediaPosition === photoAccessHelper.PositionType.CLOUD ? MediaPosition.CLOUD : MediaPosition.LOCAL;
  }

  public backToVideoCover(src: string): void {
    if (this.src === src) {
      Log.info(TAG, `back to video cover, show cover picture and hide loading progress. src: ${this.src}`);
      this.isShowCoverPicture = true;
      this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.videoPlayController?.setContinuePlayOnMediaServiceRevive(false);
    } else {
      Log.error(TAG, `back to video cover error, param src: ${src}, this.src: ${this.src}`);
    }
  }

  private onSwiperIndexChanged(targetIndex: number): void {
    if (this.mPosition === targetIndex && !this.isRestBeforeEdit) {
      Log.info(TAG, `onSwiperIndexChanged targetIndex:${targetIndex}, mPosition and currentIndex: ${
      this.mPosition},isShowProgress: ${this.isShowProgress}, src: ${this.src}`);
      // 1.广播当前avplayer实例 2.重设avplayer播放url和surfaceId 3.重设进度条 此处执行顺序不可变更
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.videoPlayController?.setVideoPlayer(this);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
      this.isShowProgress = true;
      this.clickPlayButtonTime = -1;
      this.attemptInterrupt = false;
      if (this.videoPlayController.getIsResetting()) {
        let label: string = this.videoPlayController.getLabel();
        Log.info(TAG, `current controller avplayer: ${label} on resetting, set idle enhancer callback.`);
        this.videoPlayController.setIdleEnhancer((): void => {
          this.setAvplayerUrlAndSurfaceId(this.src, this.getSurfaceID());
        });
      } else {
        this.setAvplayerUrlAndSurfaceId(this.src, this.getSurfaceID());
      }
      if (Global.getBoolean('autoPlayEnable') && this.mediaPosition === photoAccessHelper.PositionType.CLOUD) {
        if (!this.networkAvailable) {
          // 网络不可用
          UiUtil.showToast($r('app.string.no_network'));
          VideoPlayerBigDataReport.cloudVideoNetworkNoService();
        }
      }
      // this.expandToFetchAllFrame()
    }
  }

  private videoSwiperGestureIndexChanged(index: number, isDoDelete?: Boolean): void {
    let traceId: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('videoPlayerSwiperIndexChange', traceId);
    if (index === this.mPosition) {
      Log.info(TAG, `videoSwiperGestureIndexChanged index and mPosition: ${
      index},status: ${this.videoPlayController?.getAvPlayerState()},src: ${this.src}`);
      let currentState: string | undefined = this.videoPlayController?.getAvPlayerState();
      this.stopVideoAnalyzer();
      if (currentState !== AvplayerStatus.IDLE) {
        this.videoPlayController?.reset();
      }
      if (!isDoDelete) {
        this.isShowCoverPicture = true;
      }
      this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.isShowProgress = false;
      this.hasClickedPlayButton = false;
      this.fd = undefined;
      this.attemptInterrupt = true;
    }
    TraceControllerUtils.finishTraceWithTaskId('videoPlayerSwiperIndexChange', traceId);
  }

  private resetVideoBeforeEdit(url?: string): void {
    if (url && this.src === url && this.mPosition === this.viewModel.getCurrentIndex() &&
      this.videoPlayController?.getAvPlayerState() !== AvplayerStatus.IDLE) {
      Log.info(TAG, `start to invoke reset method before edit. avplayer state is ${
      this.videoPlayController?.getAvPlayerState()}`);
      this.isRestBeforeEdit = true;
      this.videoPlayController?.reset();
      this.fd = undefined;
      this.isShowVideo = false;
      this.broadCast.emit(BrowserConstants.RESET_VIDEO_FRAME_BEFORE_EDIT, []);
    }
  }

  private fastPlayEntry(): void {
    Log.info(TAG, 'Enter fast play mode');
    this.videoPlayController?.fastPlayEntry();
    this.fastPlayBroadcast();
    this.initLongPressStartTime();
  }

  private fastPlayExit(): void {
    Log.info(TAG, 'Exit fast play mode');
    this.videoPlayController?.fastPlayExit();
    this.fastPlayBroadcast();
    // 用户打点
    if (this.longPressStartTime !== -1) {
      let longPressEndTime = Date.now();
      Log.info(TAG, `longPressEndTime: ${longPressEndTime}`);
      let params: VideoReportParams = new VideoReportParams();
      params.url = this.src;
      params.subtype = this.subType;
      params.quality = this.photoQuality;
      params.position = this.getMediaPosition();
      params.fastPlayTime = Date.now() - this.longPressStartTime;
      VideoPlayerBigDataReport.videoFastPlay(params);
      this.longPressStartTime = -1;
    }
  }

  public fastPlayBroadcast(): void {
    Log.info(TAG, 'FASTPLAY: Broadcast emit');
    this.appBroadCast.emit(BroadCastConstants.SHOW_FAST_PLAY_LABEL, [this.isSpeedUp]);
  }

  private refreshOnCoveredByEdit(beforeEdit: MediaItem, afterEdit: MediaItem): void {
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.isRestBeforeEdit = false;
      Log.info(TAG, `refresh on covered by edit, this.mPosition: ${
      this.mPosition},this.currentIndex: ${this.viewModel.getCurrentIndex()}, this.src: ${this.src}`);
      Log.info(TAG, `before edit,this.maxTime: ${beforeEdit.duration}, this.videoRealWidth: ${
      beforeEdit.imgWidth},this.videoRealHeight: ${beforeEdit.imgHeight}`);
      // 创建xComponent组件controller对象
      this.xComponentController = new XComponentController();
      this.videoAnalyzerAdaptor?.setXComponentController(this.xComponentController);
      this.videoAnalyzerAdaptor?.stopVideoAnalyzer();
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
      this.isShowCoverPicture = true;
      this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      // 编辑之后如果宽高发生了变化，需要重新计算组件宽高
      if (beforeEdit.imgWidth !== afterEdit.imgWidth || beforeEdit.imgHeight !== afterEdit.imgHeight) {
        this.videoRealWidth = afterEdit.imgWidth;
        this.videoRealHeight = afterEdit.imgHeight;
        this.videoRatio = this.videoRealWidth / this.videoRealHeight;
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_REAL_SIZE,
          [this.videoRealWidth, this.videoRealHeight, this.src]);
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_RATIO, [this.videoRatio, this.src]);
      }
      if (beforeEdit.duration !== afterEdit.duration) {
        this.maxTime = afterEdit.duration;
        this.broadCast.emit(PhotoConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, []);
      }
      this.isRefreshXComponent = !this.isRefreshXComponent;
      Log.info(TAG, `after edit, this.maxTime: ${this.maxTime}, this.videoRealWidth: ${
      this.videoRealWidth},this.videoRealHeight: ${this.videoRealHeight}`);
    }
  }

  public videoStartRenderFrame(src: string): void {
    if (src === this.src) {
      TraceControllerUtils.finishTraceWithTaskId('videoPlayerClickButton', AvPlayConstants.TRACE_ID_OF_PLAY_BUTTON);
      Log.info(TAG, `videoStartRenderFrame param src: ${src}, current src: ${this.src}.`);
      setTimeout((): void => {
        this.isShowCoverPicture = false;
        this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      }, AvPlayConstants.REMOVE_COVER_DELAY)
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_ZERO;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_TWO;
      this.isForcePlayCast = true;
      this.onValueChange?.(this.isShowCoverPicture);
    } else {
      Log.error(TAG, `videoStartRenderFrame error, param src: ${src}, current src: ${this.src}.`);
    }
  }

  private videoBackPress(): void {
    Log.info(TAG, `video back, this.isShowCoverPicture = ${this.isShowCoverPicture}, this.url = ${this.src}`);
    if(DeviceInfo.isSmallFoldState()){
      this.geometryOffsetX = 0;
      this.geometryOffsetY = 0;
    }
    this.isShowProgress = false;
    this.isShowCoverPicture = true;
    this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
    this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
    this.isShowLoadingProgress = false;
    this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
    this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
    this.hasClickedPlayButton = false;
    this.attemptInterrupt = true;
    if (this.videoPlayController) {
      if (this.videoPlayController.getAvPlayerState() !== AvplayerStatus.COMPLETED) {
        this.videoPlayController.reportVideoPlayFinish();
      }
      this.videoPlayController.closeFd();
      this.fd = undefined;
    }
    VideoPlayController.release();
  }

  /**
   * 空格暂停视频
   */
  private pauseBySpace(): void {
    Log.info(TAG, 'pauseBySpace');
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.hasClickedPlayButton = false;
      this.videoPlayController?.pause(PauseReason.MANUALLY);
    }
  }

  private onVideoBackPressByMenu(): void {
    Log.info(TAG, `video back by menu, mPosition: ${this.mPosition}, currentIndex: ${
    this.viewModel.getCurrentIndex()},isShowProgress: ${this.isShowProgress}, isShowCoverPicture: ${
    this.isShowCoverPicture},url: ${this.src}`);
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      this.isShowCoverPicture = true;
      this.appBroadCast.emit(BroadCastConstants.SHOW_COVER_PICTURE, [this.isShowCoverPicture]);
      this.zIndexOfCoverPicture = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.isShowLoadingProgress = false;
      this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.isShowLoadingProgress]);
      this.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      this.hasClickedPlayButton = false;
      this.attemptInterrupt = true;

      this.videoPlayController?.pause(PauseReason.MANUALLY);
      this.videoPlayController?.getAvPlayer()?.seek(0);
      this.videoPlayController?.setLastReportTime(0);
      this.videoPlayController?.exitSlowMotion();
    }
  }

  private handleStop(): void {
    let avplayerStatus: string | undefined = this.videoPlayController?.getAvPlayerState();
    Log.info(TAG, `getAvPlayerState:${avplayerStatus}`);
    if (avplayerStatus === AvplayerStatus.PLAYING) {
      if (ShortCut.videoStoppable) {
        this.pauseBySpace();
      } else {
        ShortCut.videoStoppable = true;
      }
    } else {
      this.onVideoPlayButtonClick?.();
    }
  }

  private handleKeyEvent(event: KeyEvent): void {
    Log.info(TAG, `handleKeyEvent type= ${event.type}, keyCode= ${event.keyCode}`);
    if (event.type === KeyType.Down) {
      if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER ||
        event.keyCode === MultimodalInputManager.KEY_CODE_SPACE
      ) {
        this.shortcutController.listen(event);
      }
    }

    if (KeyType.Down === event.type) {
      this.isFullScreenKeyDown = getScreen().getIsFullScreen();
      return;
    }

    // key up
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ESC) {
      if (this.isFullScreenKeyDown) {
        return;
      }

      interface Msg {
        from: string;
      }

      let msg: Msg = {
        from: BigDataConstants.BY_KEYBOARD,
      };
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
      this.broadCast.emit(BrowserConstants.PULL_DOWN_END, []);
    }
    Log.info(TAG, 'on key event Up, default');
  }

  public onMediaServiceDied(): void {
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      // 创建xComponent组件controller对象
      this.xComponentController = new XComponentController();
      this.videoAnalyzerAdaptor?.setXComponentController(this.xComponentController);
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.videoPlayController?.setVideoPlayer(this);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
      this.isRefreshXComponent = !this.isRefreshXComponent;
    }
  }

  public getPhotoQuality(): number {
    return this.photoQuality;
  }

  public getSubtype(): number {
    return this.subType;
  }

  private isMovieModeLow(item?: MediaItem) {
    if (item) {
      this.subType = item.data?.get(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE) as number;
      this.photoQuality = item.data?.get(PhotoAccessHelperAccess.FETCH_COLUMNS_PHOTO_QUALITY) as number;
    }
    // 电影模式低质量模式
    Log.info(TAG, `src: ${this.src} is movie mode subType ${this.subType} photo_quality ${this.photoQuality}`);
    if (this.subType === 5 && this.photoQuality === 1) {
      Log.info(TAG, `is movie mode low`);
      return true;
    } else {
      Log.info(TAG, `is normal video`);
      return false;
    }
  }

  private requestFdCallback(surfaceId?: string, src?: string, fd?: number) {
    if (!surfaceId || !src || !fd){
      return;
    }
    if (surfaceId && this.videoPlayController?.getAvPlayer()) {
      Log.info(TAG, `photos_fd, open: ${fd}`);
      this.fd = fd;
      Log.info(TAG, `prepare setAvplayerUrlAndSurfaceId, file.fd: ${fd}, surfaceId: ${
      this.getSurfaceID()},mediaPosition: ${this.mediaPosition},src: ${this.src}`);
      // 激活avplayer状态流转
      this.videoPlayController?.activateAvplayer(src, surfaceId, this.fd);
    } else if (surfaceId && this.videoPlayController) {
      Log.info(TAG, 'avplayer is undefined.');
      this.videoPlayController.onCreatTimeoutCallback = (): void => {
        Log.info(TAG, 'create avplayer timeout callback invoked.');
        // 激活avplayer状态流转
        if (surfaceId) {
          this.videoPlayController?.activateAvplayer(src, surfaceId, fd);
        }
      }
    } else {
      Log.error(TAG, `error happened on set avplayer url and surfaceId, surfaceId: ${this.surfaceID
      }, current videoPlayController: ${this.videoPlayController}`);
    }
  }

  private setAvplayerUrlAndSurfaceId(src?: string, surfaceId?: string): void {
    Log.info(TAG, `setAvplayerUrlAndSurfaceId surfaceId: ${surfaceId}, fd: ${this.fd}, src: ${src}`);
    if (!(this.videoPlayController && src)) {
      Log.info(TAG, `setAvplayerUrlAndSurfaceId return directly videoPlayController:${
      VideoPlayController} mCurrent:${this.mIsCurrent}`)
      return;
    }
    if (this.fd && surfaceId && this.fd !== -1) {
      this.videoPlayController?.activateAvplayer(src, surfaceId, this.fd);
      return;
    }
    let isVideoFdOpening: boolean = AppStorage.get('isVideoFdOpening') ?? false;
    if (isVideoFdOpening) {
      Log.info(TAG, 'current is opening fd, return directly');
      return;
    }
    if (!surfaceId && this.mIsCurrent) {
      surfaceId = this.surfaceID ?? this.xComponentController?.getXComponentSurfaceId();
      this.setSurfaceID(surfaceId);
      Log.info(TAG, `set surfaceId:${surfaceId}`);
    }
    AppStorage.setOrCreate<boolean>('isVideoFdOpening', true);
    Log.info(TAG, `photos_fd, open start${this.src}`);
    if (this.isMovieModeLow(this.item)) {
      // 电影模式80分图，请求原始视频
      this.item.data?.requestSource().then(fd => {
        this.requestFdCallback(surfaceId, src, fd);
      }).catch((err: BusinessError): void => {
        Log.error(TAG, `open file failed with error message: ${err.message}, error code: ${err.code}, src: ${this.src}`);
      }).finally((): void => {
        AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
      });
    } else if (MediaLibraryData.isMediaLibraryUri(src) && this.item.data) {
      // 如果是 media library URI（如从文件管理拉起），使用 PhotoAsset 的 requestSource 方法打开
      this.item.data.requestSource().then(fd => {
        this.requestFdCallback(surfaceId, src, fd);
        AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
      }).catch((err: BusinessError): void => {
        Log.error(TAG, `open media library uri failed with error message: ${err.message}, error code: ${err.code}, src: ${this.src}`);
        // 如果 requestSource 失败，尝试使用 open 方法
        this.item.data?.open('r').then(fd => {
          this.requestFdCallback(surfaceId, src, fd);
          AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
        }).catch((openErr: BusinessError): void => {
          Log.error(TAG, `open media library uri with open method failed, error message: ${openErr.message}, error code: ${openErr.code}, src: ${this.src}`);
          AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
        });
      });
    } else {
      // 非媒体库 URI 的处理
      // 1. 对于 file://docs/... 这类由文件管理“其它路径”拉起的沙箱文档 URI：
      //    - 不能转成 /storage/... 的真实路径去 open（通常无权限，会 13900002）
      //    - 但可以直接对 docs URI 执行 fs.open 以拿到可用 fd，再交给 avplayer
      const docsPrefix: string = 'file://docs';
      if (src.startsWith(docsPrefix)) {
        if (!surfaceId) {
          Log.error(TAG, `surfaceId is undefined when handling docs uri, src: ${src}`);
          AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
          return;
        }
        Log.info(TAG, `open docs uri by fs.open, src: ${src}, surfaceId: ${surfaceId}`);
        fs.open(src).then((file): void => {
          this.requestFdCallback(surfaceId, src, file.fd);
        }).catch((err: BusinessError): void => {
          Log.error(TAG, `open docs uri failed with error message: ${err.message}, error code: ${err.code}, src: ${src}`);
        }).finally((): void => {
          AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
        });
        return;
      }

      // 2. 普通文件路径，优先使用真实物理路径打开
      let openPath: string = this.path && this.path.length > 0 ? this.path : this.normalizePathForFsOpen(src);
      fs.open(openPath).then((file): void => {
        this.requestFdCallback(surfaceId, src, file.fd);
      }).catch((err: BusinessError): void => {
        Log.error(TAG,
          `open file failed with error message: ${err.message}, error code: ${err.code}, src: ${this.src}, openPath: ${openPath}`);
      }).finally((): void => {
        AppStorage.setOrCreate<boolean>('isVideoFdOpening', false);
      });
    }
  }

  /**
   * 获取视频帧的宽高
   * 根据原图宽高调整缩略图
   * 宽高最大为128
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @returns
   */
  private calcVideoFrameSize(): media.PixelMapParams {
    let params: media.PixelMapParams = {};
    if (this.coverWidth && this.coverHeight && !Number.isNaN(this.coverWidth) && !Number.isNaN(this.coverHeight) &&
      this.coverWidth !== 0 && this.coverHeight !== 0) {
      let size = ImageUtil.resizeVideoFrame(this.coverWidth, this.coverHeight);
      params = {
        width: size.width,
        height: size.height,
      }
    }
    return params;
  }

  private async openFileForFrameFetch(): Promise<fs.File | undefined> {
    if (this.isMovieModeLow(this.item) || (MediaLibraryData.isMediaLibraryUri(this.src) && this.item.data)) {
      try {
        const fd: number = await this.item.data!.requestSource();
        return { fd } as fs.File;
      } catch (error) {
        Log.error(TAG, `expandToFetchAllFrame requestSource error: ${error}, src: ${this.src}`);
        return undefined;
      }
    }
    const openPath: string = this.path && this.path.length > 0 ? this.path : this.normalizePathForFsOpen(this.src);
    try {
      return await fs.open(openPath);
    } catch (error) {
      Log.error(TAG, `expandToFetchAllFrame fs open error: ${error}, openPath: ${openPath}, src: ${this.src}`);
      return undefined;
    }
  }

  public async expandToFetchAllFrame() {
    const currentIndex: number = this.viewModel.getCurrentIndex();
    Log.info(TAG, `expandToFetchAllFrame start, mPosition: ${this.mPosition}, currentIndex: ${currentIndex}, src: ${this.src}`);
    if (this.mPosition !== currentIndex) {
      Log.info(TAG, `expandToFetchAllFrame skip, not current page`);
      return;
    }
    let avplayerState: string | undefined = this.videoPlayController?.getAvPlayerState();
    if (avplayerState === AvplayerStatus.INITIALIZED || avplayerState === AvplayerStatus.PREPARED) {
      Log.info(TAG, `expandToFetchAllFrame: avplayer is ${avplayerState}, defer to avoid decoder contention`);
      setTimeout((): void => {
        this.expandToFetchAllFrame();
      }, 300);
      return;
    }
    let frameNum: number = Math.floor(AvPlayConstants.CON1 * Math.log(this.maxTime / AvPlayConstants.A_THOUSAND) + AvPlayConstants.CON2);
    frameNum = frameNum < AvPlayConstants.MIN_FRAME_NUM ? AvPlayConstants.MIN_FRAME_NUM : frameNum;
    let frameGap: number = this.maxTime / frameNum;
    let frameTime: number[] = new Array(frameNum).fill(0);
    frameTime[0] = 0;
    for(let i = 0; i < frameNum - 1; i++) {
      frameTime[i + 1] = frameTime[i] + Math.floor(frameGap * AvPlayConstants.A_THOUSAND);
    }
    let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_PREVIOUS_SYNC;
    let params: media.PixelMapParams = this.calcVideoFrameSize();
    this.expandAvImageGenerator = await media.createAVImageGenerator();
    const file: fs.File | undefined = await this.openFileForFrameFetch();
    if (!file) {
      return;
    }
    if (!file.fd) {
      Log.error(TAG, `expandToFetchAllFrame fd: ${file.fd}`);
      return;
    }
    if (this.expandAvImageGenerator) {
      this.expandAvImageGenerator.fdSrc = { fd: file.fd };
    }
    for (let i = 0; i < frameNum; i++) {
      Log.info(TAG, `expandToFetchAllFrame ${i} - ${frameTime[i]} - ${frameNum} - ${this.maxTime}`);
      try {
        this.videoCoverFrame[i] = await this.expandAvImageGenerator.fetchFrameByTime(frameTime[i], queryOption, params);
      } catch (error) {
        Log.error(TAG, `expandToFetchAllFrame: ${error}`);
      }
    }
    this.expandAvImageGenerator.release();
    Log.info(TAG, `expandToFetchAllFrame release fd: ${file.fd}`);
    fs.closeSync(file.fd);
  }

  private updatePosition(): void {
    Log.info(TAG, `updatePosition, this.mPosition: ${this.mPosition}, this.src: ${this.src}`);
    if (this.isRestBeforeEdit) {
      this.isRestBeforeEdit = false;
    }
    if (this.mPosition === this.viewModel.getCurrentIndex()) {
      // 刷新avplayer
      this.videoPlayController = VideoPlayController.getInstance(this.src);
      this.videoPlayController?.setVideoPlayer(this);
      this.videoPlayController?.setVideoSrc(this.src);
      this.appBroadCast.emit(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, [this.videoPlayController]);
      let SET_SURFACE_ID_DELAY_TIME: number = 0;
      setTimeout((): void => {
        this.setAvplayerUrlAndSurfaceId(this.src, this.getSurfaceID());
        this.isShowProgress = true;
      }, SET_SURFACE_ID_DELAY_TIME);
    }
  }

  public videoSizeChange(width: number, height: number, src: string): void {
    if (this.src === src) {
      this.appBroadCast.emit(BrowserConstants.SET_IMAGE_SIZE_WHEN_ZERO, [this.src, width, height]);
      if (height !== 0) {
        // 注意时序
        this.videoRealWidth = width;
        this.videoRealHeight = height;
        this.videoRatio = width / height;
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_REAL_SIZE,
          [this.videoRealWidth, this.videoRealHeight, this.src]);
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_RATIO, [this.videoRatio, this.src]);
        this.videoRatioChangeByEdit = true;
      }
      Log.info(TAG, `playWindowSize onVideoRatioChanged by avplayer end. this.videoRealWidth: ${
      this.videoRealWidth},this.videoRealHeight: ${this.videoRealHeight}, this.src: ${this.src}`);
    }
  }

  private calculateLoadingProgressHeight(): void {
    if (this.videoRealWidth === 0 || this.videoRealHeight === 0) {
      return;
    }
    let winHeight: number = getScreen().getWinLayoutHeight();
    let bottomHeight: number = this.calculateBottomHeight();
    if (this.xComponentHeight / 2 + bottomHeight >= winHeight / 2) {
      this.loadingProgressHeight = AvPlayConstants.LOADING_PROGRESS_DEFAULT_PADDING +
        bottomHeight - (winHeight / 2 - this.xComponentHeight / 2);
      Log.info(TAG, `calculate loadingProgress height(vp): ${
      this.loadingProgressHeight},bottomHeight: ${bottomHeight}`);
    }
  }

  private showCoverPictureWatch(): void {
    if (this.isShowCoverPicture && !this.isCoverHdr) {
      Log.info(TAG, `isShowCoverPicture true, old.HdrBrightness ${this.hdrBrightness} set HdrBrightness 0`);
      this.hdrBrightness = 0;
    }

    if (!this.isShowCoverPicture && this.hdrBrightness === 0) {
      Log.info(TAG, `isShowCoverPicture false, old.HdrBrightness ${this.hdrBrightness} set HdrBrightness animateto 1`);
      animateTo({
        duration: 2000,
        curve: Curve.Linear,
      }, () => {
        this.hdrBrightness = 1;
      })
    }
    this.onValueChange?.(this.isShowCoverPicture);
  }

  private calculateBottomHeight(): number {
    let bottomHeight: number = 0;
    let mode: WindowMode = getScreen().getWinMode();
    switch (mode) {
      case WindowMode.FULLSCREEN:
        if (!DeviceInfo.isPc() && !this.isHorizontal) {
          bottomHeight = Constants.ToolBarAvoidHeight + Constants.ToolBarHeight + Constants.PreviewHeight;
        }
        break;
      case WindowMode.FLOATING:
      case WindowMode.PRIMARY:
      case WindowMode.UNDEFINED:
        if (!DeviceInfo.isPc() && !this.isHorizontal) {
          bottomHeight = Constants.ToolBarHeight;
        }
        break;
      default:
        Log.error(TAG, `unknow window mode ${mode}`);
        break;
    }
    // unit vp
    return bottomHeight;
  }

  private isInvalidVideoSize(): boolean {
    return (this.videoRealWidth === 0 && this.videoRealHeight === 0);
  }

  public getVideoPlayerSrc(): string {
    return this.src;
  }

  public getCurrentSrc(): string | undefined {
    if (this.viewModel.getCurrentIndex() === this.mPosition) {
      return this.src;
    }
    return undefined;
  }
  @Builder
  buildXComponent() {
    Column() {
      XComponent(this.initXComponent())
        .hdrBrightness(this.hdrBrightness)
        .onLoad((): void => {
          this.setSurfaceID(this.xComponentController?.getXComponentSurfaceId());
          this.surfaceXComponentMap = [this.surfaceID, XComponentStatus.LOAD];
          Log.info(TAG, `Surface[${this.surfaceID}] onload ${this.continuePlaying}`);
          if (this.continuePlaying && this.mPosition === this.viewModel.getCurrentIndex()) {
            this.continuePlaying = false;
          } else {
            this.setAvplayerUrlAndSurfaceId(this.src, this.getSurfaceID());
          }
          if (Global.getBoolean('autoPlayEnable') && this.mPosition ===
          this.viewModel.getCurrentIndex() && this.mediaPosition === photoAccessHelper.PositionType.CLOUD) {
            if (!this.networkAvailable) {
              // 网络不可用
              UiUtil.showToast($r('app.string.no_network'));
              VideoPlayerBigDataReport.cloudVideoNetworkNoService();
            }
          }
        })
        .onDestroy((): void => {
          Log.info(TAG, `XComponent onDestroy: ${this.src}`);
          this.surfaceXComponentMap = [this.surfaceID, XComponentStatus.DESTROY];
        })
        .width(AvPlayConstants.FULL_PERCENT)
        .height(AvPlayConstants.FULL_PERCENT);
    }
    .width(AvPlayConstants.FULL_PERCENT)
    .height(AvPlayConstants.FULL_PERCENT)
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ repeat: true })
          .onAction((event: GestureEvent) => {
            Log.info(TAG,
              `isVideoPlaying: ${this.videoPlayController?.getAvPlayerState()}, isSpeedUp: ${this.isSpeedUp}`);
            // picker和三方不能倍速视频
            if (!this.canFastPlay) {
              Log.info(TAG, 'Video in the third mode or picker cannot fast play');
              return;
            }
            // low movie disable fast play
            if (this.isMovieModeLow()) {
              Log.info(TAG, 'low movie disable fast play');
              return;
            }
            // 加载过程中不再加速
            if (this.isShowLoadingProgress) {
              Log.info(TAG, 'Cloud video is buffering, fast play not allowed');
              if (this.isSpeedUp) {
                this.setSpeedUpValue(false);
                this.fastPlayExit();
              }
              return;
            }
            // 仅正在播放时允许长按倍速；播放结束、未起播等状态不展示倍速标识
            if (this.videoPlayController?.getAvPlayerState() !== AvplayerStatus.PLAYING) {
              Log.info(TAG,
                `longpress fast play skipped, state is ${this.videoPlayController?.getAvPlayerState()}`);
              return;
            }
            // 如果在加速状态下，就不用再设置加速了
            if (this.isSpeedUp) {
              return;
            }
            Log.info(TAG, 'longpress start');
            this.setSpeedUpValue(true);
            this.fastPlayEntry();
          })
          // 长按动作一结束触发
          .onActionEnd((event: GestureEvent) => {
            Log.info(TAG,
              `isVideoPlaying: ${this.videoPlayController?.getAvPlayerState()}, isSpeedUp: ${this.isSpeedUp}`);
            // if (!DeviceInfo.isPc() && !DeviceInfo.isTv() &&
            //   this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING) {
            //   Log.info(TAG, 'longpress end');
            //   this.setSpeedUpValue(false);
            //   this.fastPlayExit();
            // }
            if (this.isSpeedUp) {
              Log.info(TAG, 'longpress end');
              this.setSpeedUpValue(false);
              this.fastPlayExit();
            }
          })
          .onActionCancel((event: GestureEvent) => {
            Log.info(TAG, `longpress cancelled, isVideoPlaying: ${
            this.videoPlayController?.getAvPlayerState()}, isSpeedUp: ${this.isSpeedUp}`);
            this.setSpeedUpValue(false);
            this.fastPlayExit();
          })
      )
    )
    .justifyContent(FlexAlign.Center)
    .zIndex(AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_ONE)
    // 封面加载过程中或者加载失败时默认不显示，点击播放时强制显示
    .visibility(this.isForcePlay && this.isForcePlayCast ? Visibility.Visible : Visibility.Hidden);
  }

  @Builder
  buildPlayProgress() {
    // 进度条
    if (this.isShowProgress && this.progressType === LoadProgressType.SLIDER) {
      PlayProgress({
        videoPlayController: this.videoPlayController,
        maxTime: this.maxTime,
        url: this.src,
      })
        .position({
          y: AvPlayConstants.PLAY_PAGE.COLUMN_HEIGHT_ONE,
        })
        .width(AvPlayConstants.FULL_PERCENT)
        .zIndex(AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE)
        .height(AvPlayConstants.PLAY_PAGE.DEFAULT_HEIGHT);
    }
  }

  @Builder
  private onlineProgress() {
    if (this.isShowLoadingProgress) {
      Column() {
        LoadingProgress()
          .color($r('sys.color.white'))
          .width($r('app.float.loading_progress_video_player'))
          .height($r('app.float.loading_progress_video_player'))
      }
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      .key('videoPlayerLoadingProgress')
      .zIndex(this.zIndexOfLoadingProgress)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center);
    }
  }

  private thumbnailOnComplete(event?: completed): void {
    if (event?.loadingStatus === 0 && this.isInvalidVideoSize()) {
      this.videoRealWidth = event?.width;
      this.videoRealHeight = event?.height;
      this.videoRatio = event?.width / event?.height;
      setTimeout((): void => {
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_REAL_SIZE,
          [this.videoRealWidth, this.videoRealHeight, this.src]);
        this.appBroadCast.emit(BrowserConstants.SET_VIDEO_RATIO, [this.videoRatio, this.src]);
        this.appBroadCast.emit(BrowserConstants.SET_IMAGE_SIZE_WHEN_ZERO,
          [this.src, event?.width, event?.height]);
      }, 0);
      Log.info(TAG, `Decode video lcd size by <Video>: ${event?.width}, ${event?.height}, uri: ${this.thumbnail?.url}`);
    }
    setTimeout((): void => {
      this.imageComplete(event);
      if (event?.loadingStatus === 1) {
        this.broadCast.emit(BroadCastConstants.CURRENT_LCD_LOAD_COMPLETED, []);
        Log.info(TAG, `cover picture load completed ,video uri: ${this.thumbnail?.url}`);
      }
    }, 0);
  }

  private async decodeVideoLcdImageInfo(): Promise<void> {
    Log.info(TAG, 'decodeVideoLcdImageInfo start.');
    let str = ImageUtil.getLCDPath(this.path);
    let file = await fs.open(str);
    Log.info(TAG, 'decodeVideoLcdImageInfo createImageSource');
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      imageSource = image.createImageSource(file.fd);
      if (imageSource) {
        let imageInfo = await imageSource.getImageInfo();
        if (imageInfo) {
          Log.info(TAG, `imageInfo lcd path:${str} isHdr: ${imageInfo.isHdr}`);
          this.isCoverHdr = imageInfo.isHdr;
          if (!this.isCoverHdr) {
            this.hdrBrightness = 0;
          }
        } else {
          Log.error(TAG, 'decodeVideoLcdImageInfo imageInfo is null');
        }
      } else {
        Log.error(TAG, 'decodeVideoLcdImageInfo createImageSource is null');
      }
    } catch (err) {
      Log.error(TAG, `open file failed with error message: ${err?.message}, error code: ${err?.code}`);
    } finally {
      Log.info(TAG, `[fd flag] decodeVideoLcdImageInfo fS close fd: ${file?.fd}`);
      fs.closeSync(file.fd);
      imageSource?.release()
    }
  }

  private getActualImage(): string {
    if (this.isEditor) {
      return this.replaceUriManager?.getVideoCoverUri(this.src) ?? '';
    }
    let uri = this.isShowAstcCover ? ImageUtil.getThumbnailAstcUri(this.src, this.path, this.dateModified) :
      this.thumbnail?.url;
    if (this.userId > 0) {
      return uri + (uri.includes('?') ? '&' : '?') + 'user=' + this.userId;
    }
    Log.info(TAG, `getActualImage: ${ReportToBigDataUtil.urlAnonymize(uri)}`);
    return uri;
  }

  build() {
    Stack() {
      Image(this.getActualImage())
        .objectFit(ImageFit.Cover)
        .alt(this.placeHolderImage)
        .opacity(1)
        .visibility(this.isShowCoverPicture ? Visibility.Visible : Visibility.Hidden)
        .width(AvPlayConstants.FULL_PERCENT)
        .height(AvPlayConstants.FULL_PERCENT)
        .zIndex(this.zIndexOfCoverPicture)
        .dynamicRangeMode(DeviceInfo.isTv() ? undefined : DynamicRangeMode.HIGH)
        .key(`browserVideoFocus_${this.thumbnail?.url}`)
        .onComplete((event?: completed): void => this.thumbnailOnComplete(event))
        .onError((event: ImageError): void => {
          this.imageError(event);
        })
        .focusable(false)
        .draggable(false)
      // 在线播放加载进度
      this.onlineProgress();
      Stack() {
        if (this.isShowXComponent()) {
          if (this.isRefreshXComponent) {
            this.buildXComponent();
          } else {
            this.buildXComponent();
          }
        }
        this.buildPlayProgress();
      }.width(AvPlayConstants.FULL_PERCENT)

    }
    .geometryTransition(this.isFromPickerView && this.isRunningAnimation ? this.geometryTransitionId : '')
    .offset({
      x: this.isFromPickerView ? this.geometryOffsetX : 0,
      y: this.isFromPickerView ? this.geometryOffsetY : 0,
    })
    .clip(this.isFromPickerView)
    .width(AvPlayConstants.FULL_PERCENT)
    .height(AvPlayConstants.FULL_PERCENT)
    .key('videoPlayer')
    .alignContent(Alignment.Center)
    .focusable(true)
    .defaultFocus(true)
    .onKeyEvent((event: KeyEvent): void => {
      event && this.handleKeyEvent(event);
    });
  }

  private isShowXComponent(): boolean {
    return true;
  }

  private handleSubScreenPause(): void {
    Log.info(TAG, 'handleSubScreenPause');
    this.videoPlayController?.manuallyPause();
    this.isShowVideo = false;
    this.pauseFromSubScreen = true;
  }

  private handleSubScreenPlay(): void {
    Log.info(TAG, 'handleSubScreenPlay');
    this.videoPlayController?.manuallyPlay();
    this.isShowVideo = true;
    this.pauseFromSubScreen = false;
  }

  public closeFd(fd: number): void {
    if (fd === this.fd) {
      this.fd = undefined;
    }
  }

  public setFd(fd: number): void {
    this.fd = fd;
  }

  public initClickPlayButtonTime(): void {
    this.clickPlayButtonTime = Date.now();
  }

  public initLongPressStartTime(): void {
    this.longPressStartTime = Date.now();
    Log.info(TAG, `longPressStartTime: ${this.longPressStartTime}`);
  }

  public showLoadingProgress(): void {
    if (this.mPosition === this.viewModel.getCurrentIndex() &&
      this.mediaPosition === photoAccessHelper.PositionType.CLOUD) {
      this.isShowLoadingProgress = true;
    }
  }

  private onVideoDownloadCompleted(uri: string): void {
    Log.info(TAG, `onVideoDownloadCompleted current:${this.src},download: ${uri}`);
    if (uri !== this.src) {
      return;
    }
    const status: string | undefined = this.videoPlayController?.getAvPlayerState();
    if (status !== AvplayerStatus.PAUSED && status !== AvplayerStatus.PLAYING) {
      this.videoPlayController?.reset();
    } else {
      Log.error(TAG, 'onVideoDownloadCompleted status is playing,can not change play mode to local');
    }
  }
}
