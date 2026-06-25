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

import lazy {
  AvPlayConstants,
  AVPlayerCallBack,
  AvplayerErrorCode,
  AvplayerStatus,
  Events,
  MediaPosition,
  PageStatus,
  XComponentStatus,
  VideoReportParams,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { formatDuration } from '@ohos/common/src/main/ets/default/model/common/DurationFormatter';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy audio from '@ohos.multimedia.audio';
import lazy media from '@ohos.multimedia.media';
import lazy { PlayProgress } from '../../../../../../browserCommon/src/main/ets/default/view/PlayProgress';
import lazy common from '@ohos.app.ability.common';
import lazy { VideoPlayer, VideoPlayerBigDataReport } from '../view/VideoPlayer';
import lazy { BusinessError } from '@ohos.base';
import lazy Queue from '@ohos.util.Queue';
import lazy fs from '@ohos.file.fs';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { AudioSessionController, AudioSessionStrategy } from './AudioSessionController';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ApsUtil } from '@ohos/common/src/main/ets/default/utils/ApsUtil';

const TAG: string = 'videoPlayerController';
const BUFFERING_OVER_TIME: number = 5000;

/**
 * 一种使用接口隐藏属性的规避方法：
 * AVPlayer中有一个不对外暴露的属性enableStartFrameRateOpt，
 * 为了显式设置该属性的值，封装了一个装饰器CustomAVPlayer，方便
 * 使用enableStartFrameRateOpt属性
 *
 * enableStartFrameRateOpt：设为true时，视频框架调用优化后的
 * 视频起播方式，该起播方法会在prepare状态执行
 */
interface CustomAVPlayer extends media.AVPlayer {
  // avPlayer不对外暴露的属性
  enableStartFrameRateOpt?: boolean;
}

/**
 * avplayer播放控制器
 */
export class VideoPlayController {
  private label: string = '';
  private avPlayer?: media.AVPlayer;
  private customAvPlayer?: CustomAVPlayer;
  private duration: number = 0;
  private url: string = '';
  // 对应媒体的唯一标识
  private src: string = '';
  private fd: number = -1;
  private surfaceId: string = '';
  private progress?: PlayProgress;
  private videoPlayer?: VideoPlayer;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private static videoPlayerQueue: Queue<VideoPlayController> = new Queue();
  private static currentVideoController: VideoPlayController;
  private isFromPickerView: boolean = LocalStorage.getShared()?.get(Constants.IS_FROM_PICKER_VIEW) as boolean;
  private enablePlayApsState: boolean = false;
  private avPlayerCallBack: AVPlayerCallBack | undefined = {
    idleCallBack: (): void => {
    },
    initializedCallBack: (): void => {
    },
    preparedCallBack: (): void => {
    },
    playingCallBack: (): void => {
    },
    pauseCallBack: (): void => {
    },
    completedCallBack: (): void => {
    },
    stopCallBack: (): void => {
    },
    releasedCallBack: (): void => {
    },
    errorCallBack: (): void => {
    }
  };
  private voidMethod: () => void = (): void => {
  };
  private videoProgress: number = 0;
  private beforeMediaServiceDiedProgress: number = 0;
  private continuePlayOnMediaServiceRevive: boolean = false;
  private isResetting: boolean = false;
  private isPausing: boolean = false;
  private preProgressTime: number = 0;
  private lastReportTime: number = 0;
  private bottomMenuChangeTime: number = 200;
  private isBufferingUpdate: boolean = false;
  // 防抖阈值
  private antiJitterThreshold: number = 999;
  // 上报时间间隔
  private printTimeInterval: number = 200;
  // media service died后拉起续播点
  private progressTimeOnPaused: number = 0;
  // on page hide pause完成后的回调
  private onPageHidePausedCallback: Function = (): void => {
  };
  // slow motion
  private slowMotionStart: number = 0;
  private slowMotionEnd: number = 0;
  // 锚点区间播放倍率
  private anchorIntervalPlaySpeed: number = AvPlayConstants.PLAY_SPEED.SPEED_1_0_X;
  private currentPlaySpeed: number = AvPlayConstants.PLAY_SPEED.SPEED_1_0_X;
  private fps: number | undefined = AvPlayConstants.VIDEO_FPS_60;
  private isSettingSpeed: boolean = false;
  private pageStatus: PageStatus = PageStatus.SHOW;
  // 缓冲转圈次数
  private bufferTimes: number = 0;
  // 缓冲转圈开始时间
  private bufferStartTime: number = 0;
  // 缓冲转圈结束时间
  private bufferEndTime: number = 0;
  // 缓冲转圈总时间
  private bufferTotalTime: number = 0;
  // 缓冲转圈用户耐心值
  private bufferPatience: number = 0;
  // 缓冲间隔时间
  private bufferInterval: number = 5000;
  /**
   *  视频起播后的回调
   */
  private onPlayingCallbackEnhancer: Function = (): void => {
  };
  /**
   *  视频暂停后的回调
   */
  private onPausedCallbackEnhancer: Function = (): void => {
  };
  /**
   *  视频播放完成后的回调
   */
  private onCompletedCallbackEnhancer: Function = (): void => {
  };
  /**
   * 视频封面帧
   */
  private videoCoverFrame: PixelMap[] = [];
  /**
   * createAVPlayer超时回调
   */
  public onCreatTimeoutCallback: Function = (): void => {
  };
  /**
   * 是否在跟手拖动seek
   */
  private isFingerSlide: boolean = false;
  private seekRawTime: number = 0;
  // 视频比特率/码率
  public bitrate: number = -1;
  /**
   *  当播放器处于idle时的回调
   */
  private onIdleCallbackEnhancer: () => void = (): void => {
  }
  private networkTimeId: number = 0;
  /**
   *  Seek是否是continuous模式
   */
  private seekContinuousSupported: boolean = true;

  private constructor(label: string) {
    Log.info(TAG, 'create videoPlayerController!');
    this.label = label;
    this.createAVPlayer();
  }

  private static initInstanceQueue(): VideoPlayController {
    // 当前创建两个对象，后续可根据实际体验增加
    VideoPlayController.videoPlayerQueue.add(new VideoPlayController('[C_ONE]'));
    VideoPlayController.videoPlayerQueue.add(new VideoPlayController('[C_TWO]'));
    // 取队列第一个出队列作为返回结果，并且压入队尾
    VideoPlayController.currentVideoController = VideoPlayController.videoPlayerQueue.pop();
    VideoPlayController.videoPlayerQueue.add(VideoPlayController.currentVideoController);
    Log.info(TAG, `[GetInstance] init queue success,return instance: ${
    VideoPlayController.currentVideoController.label}`);
    return VideoPlayController.currentVideoController;
  }

  public static getInstance(src?: string): VideoPlayController {
    if (VideoPlayController.videoPlayerQueue.length === 0) {
      return VideoPlayController.initInstanceQueue();
    }
    let currentSrc: string | undefined = VideoPlayController.currentVideoController.videoPlayer?.getVideoPlayerSrc();
    let label: string = VideoPlayController.currentVideoController.label;
    Log.info(TAG, `[GetInstance] check src: ${src}, currentSrc: ${currentSrc}`);
    if (src === currentSrc) {
      // 视频未发生变化，则直接返回当前正在使用的VideoPlayController
      Log.info(TAG, `[GetInstance] check src same,return directly,instance: ${label}`);
      return VideoPlayController.currentVideoController;
    } else {
      // 当前正在使用的VideoPlayController即队尾的VideoPlayController，进行reset
      let currentState: string | undefined = VideoPlayController.currentVideoController.getAvPlayerState();
      Log.info(TAG, `[GetInstance] check src diff,should reset instance: ${label},current state: ${
      currentState},isResetting: ${VideoPlayController.currentVideoController.isResetting}`);
      if (currentState !== AvplayerStatus.IDLE && !VideoPlayController.currentVideoController.isResetting) {
        VideoPlayController.currentVideoController?.reset();
      }
    }
    /* instrument ignore next */
    for (let i = 0; i < VideoPlayController.videoPlayerQueue.length - 1; i++) {
      let currentVideoController: VideoPlayController = VideoPlayController.videoPlayerQueue.pop();
      let currentState: string | undefined = currentVideoController.getAvPlayerState();
      if (currentState === AvplayerStatus.IDLE) {
        // 若出列的VideoPlayController状态满足要求则返回结果，并压入队尾
        VideoPlayController.currentVideoController = currentVideoController;
        VideoPlayController.videoPlayerQueue.add(currentVideoController);
        Log.info(TAG, `[GetInstance] success,currentState is idle,return instance: ${currentVideoController.label}`);
        return currentVideoController;
      } else {
        // 若出列的VideoPlayController状态不满足要求则reset
        Log.info(TAG, `[GetInstance] currentState : ${currentState}`);
        if (currentState !== AvplayerStatus.IDLE && !currentVideoController.isResetting) {
          currentVideoController?.reset();
        }
        VideoPlayController.videoPlayerQueue.add(currentVideoController);
        VideoPlayController.currentVideoController = currentVideoController;
      }
    }
    Log.info(TAG, `[GetInstance] success,currentState is ${
    VideoPlayController.currentVideoController.getAvPlayerState()},return instance: ${
    VideoPlayController.currentVideoController.label}`);
    return VideoPlayController.currentVideoController;
  }

  private async releaseErrorAvPlayer(avplayer?: media.AVPlayer): Promise<void> {
    await avplayer?.release();
  }

  private createAVPlayer(): void {
    try {
      media.createAVPlayer().then((avPlayer) => {
        if (avPlayer) {
          Log.info(TAG, 'createAvPlayer success!');
          this.avPlayer = avPlayer;
          // 指向avPlayer实例
          this.customAvPlayer = this.avPlayer as CustomAVPlayer;
          // 顺序不可变
          this.setStateMachineCallBack();
          this.bindState();
          this.setStateMachineListener();
          // 超时回调
          this.onCreatTimeoutCallback();
          this.onCreatTimeoutCallback = this.voidMethod;
        } else {
          Log.error(TAG, 'createAvPlayer fail!');
        }
      });
    } catch (error) {
      Log.error(TAG, `createAvPlayer error: ${error}`);
    }
  }

  /* instrument ignore next */
  private setStateMachineCallBack(): void {
    if (this.avPlayerCallBack === undefined) {
      return;
    }
    this.avPlayerCallBack.idleCallBack = (): void => {
      Log.info(TAG, `${this.label} will invoke idle callback.`);
      this.resetProgress();
      this.onIdleCallbackEnhancer();
      this.onIdleCallbackEnhancer = this.voidMethod;
    };
    this.avPlayerCallBack.initializedCallBack = (): void => {
      Log.info(TAG, `${this.label} will invoke initialized callback.`);
      if (this.avPlayer) {
        this.avPlayer.audioRendererInfo = {
          usage: audio.StreamUsage.STREAM_USAGE_MOVIE,
          rendererFlags: 0,
        }
        this.avPlayer.surfaceId = this.surfaceId;
        if (this.customAvPlayer) {
          // 确定customAvPlayer实例中含有该属性，避免编译出错
          if (Reflect.has(this.customAvPlayer, 'enableStartFrameRateOpt')) {
            // avPlayer的属性，设为true时，视频播放会调用优化后的起播方法，必须在prepare前设置
            this.customAvPlayer.enableStartFrameRateOpt = true;
          } else {
            Log.warn(TAG, 'enableStartFrameRateOpt property does not exist');
          }
        }
        Log.info(TAG, 'enableCameraPostprocessing call');
        // this.avPlayer.enableCameraPostprocessing?.().then(() => {
        //   Log.info(TAG, 'enableCameraPostprocessing success')
        // }).catch((error: BusinessError): void => {
        //   Log.error(TAG, `enableCameraPostprocessing failed: ${error.code}`);
        // });
        Log.info(TAG, 'enableCameraPostprocessing called');
        this.avPlayer.prepare();
      }
    };
    this.avPlayerCallBack.preparedCallBack = (): void => {
      Log.info(TAG, `${this.label} will invoke prepared callback.`);
      if (this.avPlayer) {
        this.updateSeekRawTime(0);
        this.avPlayer.videoScaleType = 0;
        this.duration = this.avPlayer.duration;
        this.progress?.setMaxTime(this.avPlayer.duration);
        this.videoPlayer?.onPrepared(this.src);
        this.calculateSlowMotionAnchor();
        Log.error(TAG, 'isSeekContinuousSupported start');
        this.seekContinuousSupported = this.avPlayer?.isSeekContinuousSupported();
        Log.error(TAG, `isSeekContinuousSupported end ${this.seekContinuousSupported}`);
        this.getMediaBitrate();
        if (this.continuePlayOnMediaServiceRevive || this.progressTimeOnPaused !== 0) {
          Log.info(TAG, `${this.label} step 3 success. src: ${this.src}`);
          this.continuePlayFromDiedTimePoint(this.progressTimeOnPaused === 0, this.beforeMediaServiceDiedProgress);
        }
      }
    };
    this.avPlayerCallBack.playingCallBack = (): void => {
      let duration = this.avPlayer?.duration || 0;
      this.videoPlayer?.onPlaying(this.src, this.avPlayer?.surfaceId);
      let currentState: string | undefined = VideoPlayController.currentVideoController.getAvPlayerState();
      Log.info(TAG, `${this.label} will invoke playing callback. ${this.seekRawTime}. ${duration}. ${currentState}`);
      if ((duration - this.seekRawTime) > Constants.SEEK_ALLOWABLE_OFFSET_TIME ||
        currentState === AvplayerStatus.COMPLETED) {
        this.appBroadCast.emit(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, [false]);
      }
      this.updateSeekRawTime(0);
      this.progressTimeOnPaused = 0;
      WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
      common.UIAbilityContext, true);
    };
    this.avPlayerCallBack.pauseCallBack = (): void => {
      Log.info(TAG, `${this.label} will invoke paused callback. ${this.isFingerSlide}`);
      if (!this.isFingerSlide) {
        this.updateSeekRawTime(0);
        this.videoPlayer?.onPaused(this.src);
        this.appBroadCast.emit(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, [true]);
        this.progressTimeOnPaused = this.videoProgress;
        WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
        common.UIAbilityContext, false);
      }
    };
    this.avPlayerCallBack.completedCallBack = (): void => {
      Log.info(TAG, `${this.label} will invoke completed callback.`);
      this.releaseAudioSession('videoPlayer completed');
      this.updateSeekRawTime(0);
      this.videoPlayer?.onCompleted(this.src);
      if (this.videoPlayer?.getMediaPosition() === MediaPosition.CLOUD) {
        let params: VideoReportParams = new VideoReportParams();
        params.url = this.src;
        params.duration = this.duration;
        params.playTime = this.videoProgress;
        params.totalTime = this.bufferTotalTime;
        if (this.videoPlayer.netQuality) {
          params.netDownRateAvg = this.videoPlayer.netQuality?.netDownRateAvg();
        }
        VideoPlayerBigDataReport.cloudVideoCatonTime(params);
      }
      this.reportVideoPlayFinish();
      this.bufferTotalTime = 0;
      this.bufferEndTime = 0;

      WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
      common.UIAbilityContext, false);
    };
    this.avPlayerCallBack.stopCallBack = (): void => {
      WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
      common.UIAbilityContext, false);
    };
    this.avPlayerCallBack.releasedCallBack = (): void => {
      WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
      common.UIAbilityContext, false);
    };
    this.avPlayerCallBack.errorCallBack = (): void => {
      Log.info(TAG, `${this.label} error handling by listener.`);
    };
  }

  /* instrument ignore next */
  private setStateMachineListener(): void {
    // 视频进度的监听回调函数
    this.avPlayer?.on(Events.TIME_UPDATE, (time: number) => {
      Log.debug(TAG, `[StateMachineListener] ${this.label} debug_time_update time: ${time}`);
      // 200 ms打印一次
      if (Math.abs(time - this.preProgressTime) > this.printTimeInterval) {
        Log.info(TAG, `[StateMachineListener] ${this.label} time_update time: ${time}`);
        this.preProgressTime = time;
      }
      if (time < this.lastReportTime) {
        Log.warn(TAG, `${this.label} time less than lastReportTime, time: ${time}, lastReportTime: ${
        this.lastReportTime}`);
      }
      if (time >= this.lastReportTime || time + this.antiJitterThreshold < this.lastReportTime) {
        this.videoProgress = time;
        this.updateProgressTime(time);
        this.updateSeekTime(time);
        this.lastReportTime = time;
      }
    });

    // 音频焦点变化
    this.avPlayer?.on(Events.AUDIO_INTERRUPT, (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      Log.info(TAG, `[StateMachineListener] ${this.label} audio interrupt, info is: ${JSON.stringify(info)}`);
      if (info.eventType === audio.InterruptType.INTERRUPT_TYPE_BEGIN) {
        this.audioInterruptBegin(info);
      }
      if (info.eventType === audio.InterruptType.INTERRUPT_TYPE_END) {
        this.audioInterruptEnd(info);
      }
    });

    // 视频播放结束触发回调
    this.avPlayer?.on(Events.END_OF_STREAM, (): void => {
      Log.info(TAG, `[StateMachineListener] ${this.label} endOfStream success`);
      // 当视频播放结束后， 需要把视频资源释放，回到之前的状态。底部导航栏需要显示，播放按键显示
      this.appBroadCast.emit(BroadCastConstants.VIDEO_PLAY_COMPLETED, []);
      if (this.videoPlayer) {
        this.videoPlayer.isShowLoadingProgress = false;
        this.appBroadCast.emit(BroadCastConstants.SHOW_LOADING_PROGRESS, [this.videoPlayer.isShowLoadingProgress]);
        this.videoPlayer.zIndexOfLoadingProgress = AvPlayConstants.PLAY_PLAYER.VIDEO_INDEX_THREE;
      }
      this.lastReportTime = 0;
    });

    // 音频流输出设备变化及原因
    this.avPlayer?.on(Events.AUDIO_OUTPUT_DEVICE_CHANGE_WITH_INFO, (info: audio.AudioStreamDeviceChangeInfo): void => {
      let deviceRole: audio.DeviceRole = info.devices[0].deviceRole;
      let deviceType: audio.DeviceType = info.devices[0].deviceType;
      let currentStatus: string | undefined = this.getAvPlayerState();
      let reason: audio.AudioStreamDeviceChangeReason = info.changeReason;
      Log.info(TAG, `[StateMachineListener] ${this.label}] output device change. deviceRole: ${
      deviceRole}, deviceType ${deviceType}, status: ${currentStatus}, reason: ${reason}`);
      if (deviceRole === audio.DeviceRole.OUTPUT_DEVICE && deviceType === audio.DeviceType.SPEAKER &&
        reason === audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE) {
        this.pause(PauseReason.AUDIO);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, [true]);
        this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
      }
    });

    // 首帧上报回调函数
    this.avPlayer?.on(Events.START_RENDER_FRAME, (): void => {
      Log.info(TAG, `[StateMachineListener] ${this.label} startRenderFrame success, src: ${this.src}`);
      this.videoPlayer?.videoStartRenderFrame(this.src);
    });

    // 视频宽高上报回调函数
    this.avPlayer?.on(Events.VIDEO_SIZE_CHANGE, (width: number, height: number) => {
      this.videoPlayer?.videoSizeChange(width, height, this.src);
      Log.info(TAG, `[StateMachineListener] ${this.label} videoSizeChange success, the real width : ${
      width}, height: ${height}`);
    });

    // seekTime完成后回调
    this.avPlayer?.on(Events.SEEK_DONE, (value: number) => {
      Log.info(TAG, `[StateMachineListener] ${this.label} seekTime done! value = ${value}, avplayCurrentTime is ${
      this.avPlayer?.currentTime}`);
      if (this.avPlayer) {
        this.updateProgressTime(this.avPlayer.currentTime);
        this.updateSeekTime(this.avPlayer.currentTime);
        this.setSpeedOnSlowMotionSeekDone(this.avPlayer.currentTime);
      }
    });

    // 设置错误监听
    this.avPlayer?.on(Events.ERROR, (error: BusinessError): void => {
      Log.info(TAG, `[StateMachineListener] ${this.label} error code: ${error.code}, error msg : ${error.message}.`);
      if (this.videoPlayer) {
        let params: VideoReportParams = new VideoReportParams();
        params.url = this.src;
        params.code = error.code;
        params.position = this.videoPlayer.getMediaPosition();
        params.duration = this.duration;
        params.playDuration = this.videoProgress;
        VideoPlayerBigDataReport.videoPlayerErrorHappened(params);
      }
      this.avplayerErrorHandler(error);
    });

    // 倍速设置生效回调
    this.avPlayer?.on(Events.SPEED_DONE, (speed: number): void => {
      Log.info(TAG, `[StateMachineListener] ${this.label} speed done, value is: ${
      speed}, current isSettingSpeed: ${this.isSettingSpeed}`);
      this.isSettingSpeed = false;
      this.currentPlaySpeed = speed;
    });
  }

  private bindState(): void {
    this.avPlayer?.on(Events.STATE_CHANGE, async (state) => {
      Log.info(TAG, `[StateMachineBindState] : ${this.label} ${state} callback start.`);
      this.appBroadCast.emit(BroadCastConstants.VIDEO_STATUS_REPORTED, [state]);
      switch (state) {
        case AvplayerStatus.IDLE:
          this.avPlayerCallBack?.idleCallBack();
          break;
        case AvplayerStatus.INITIALIZED:
          this.avPlayerCallBack?.initializedCallBack();
          break;
        case AvplayerStatus.PREPARED:
          this.avPlayerCallBack?.preparedCallBack();
          break;
        case AvplayerStatus.PLAYING:
          this.avPlayerCallBack?.playingCallBack();
          this.onPlayingCallbackEnhancer();
          if (this.isFromPickerView) {
            this.sendPlayStateToThirdApp(0);
          }
          break;
        case AvplayerStatus.PAUSED:
          this.avPlayerCallBack?.pauseCallBack();
          this.onPausedCallbackEnhancer();
          if (this.isFromPickerView) {
            this.sendPlayStateToThirdApp(1);
          }
          break;
        case AvplayerStatus.COMPLETED:
          if (this.enablePlayApsState) {
            ApsUtil.disableVideoPlayerApsState();
            this.enablePlayApsState = false;
          }
          this.avPlayerCallBack?.completedCallBack();
          this.onCompletedCallbackEnhancer();
          if (this.isFromPickerView) {
            this.sendPlayStateToThirdApp(2);
          }
          break;
        case AvplayerStatus.STOPPED:
          this.avPlayerCallBack?.stopCallBack();
          break;
        case AvplayerStatus.RELEASED:
          this.avPlayerCallBack?.releasedCallBack();
          break;
        case AvplayerStatus.ERROR:
          this.avPlayerCallBack?.errorCallBack();
          break;
        default:
          Log.info(TAG, `${this.label} unknown state: ${state}.`);
      }
      Log.info(TAG, `[StateMachineBindState] : ${this.label} ${state} callback end.`);
    });
  }

  /* instrument ignore next */
  private sendPlayStateToThirdApp(state: number): void {
    let storage = LocalStorage?.GetShared();
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      let session: UIExtensionContentSession | undefined =
        storage.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.sendData({ 'dataType': 'onVideoPlayStateChanged', 'state': state });
    }
  }

  private setSpeedOnSlowMotionSeekDone(time: number): void {
    if (this.fps !== AvPlayConstants.VIDEO_FPS_120 && this.fps !== AvPlayConstants.VIDEO_FPS_240) {
      return;
    }
    Log.info(TAG, `${this.label} slow motion video seek done! currentTime:${
    time},slowMotionStart:${this.slowMotionStart}, slowMotionEnd: ${this.slowMotionEnd}`);
    if (time >= this.slowMotionStart && time < this.slowMotionEnd) {
      this.isSettingSpeed = true;
      this.avPlayer?.setSpeed(this.anchorIntervalPlaySpeed);
    } else {
      this.isSettingSpeed = true;
      this.avPlayer?.setSpeed(AvPlayConstants.PLAY_SPEED.SPEED_1_0_X);
    }
  }

  private setSpeed(speed: number): void {
    this.isSettingSpeed = true;
    this.avPlayer?.setSpeed(speed);
  }

  // 倍速时，分别设置60,120,240fps视频的倍速
  public fastPlayEntry(): void {
    if (DeviceInfo.isPc()) {
      return;
    }
    let playSpeed2X: number = 0;
    if (this.fps === AvPlayConstants.VIDEO_FPS_120) {
      playSpeed2X = AvPlayConstants.PLAY_SPEED.SPEED_0_5_X;
    } else if (this.fps === AvPlayConstants.VIDEO_FPS_240) {
      playSpeed2X = AvPlayConstants.PLAY_SPEED.SPEED_0_25_X;
    } else {
      playSpeed2X = AvPlayConstants.PLAY_SPEED.SPEED_2_0_X;
    }

    Log.warn(TAG, `playSpeed2X: ${playSpeed2X}`);
    this.setSpeed(playSpeed2X);
  }

  // 倍速结束后，恢复60,120,240fps的初始速度
  public fastPlayExit() {
    if (DeviceInfo.isPc()) {
      return;
    }
    this.setSpeed(this.anchorIntervalPlaySpeed);
  }

  /* instrument ignore next */
  public exitSlowMotion(): void {
    this.isSettingSpeed = true;
    this.avPlayer?.setSpeed(AvPlayConstants.PLAY_SPEED.SPEED_1_0_X);
  }

  private setSpeedOnPlaySlowMotion(time: number): void {
    if (this.fps !== AvPlayConstants.VIDEO_FPS_120 && this.fps !== AvPlayConstants.VIDEO_FPS_240) {
      return;
    }
    if (this.isResetting) {
      Log.info(TAG, `${this.label} is resetting, can't set speed.`);
      return;
    }
    if (time >= this.slowMotionStart && time < this.slowMotionEnd && !this.isSettingSpeed &&
      this.currentPlaySpeed !== this.anchorIntervalPlaySpeed) {
      Log.info(TAG, `video speed slow value: ${this.anchorIntervalPlaySpeed}`);
      this.isSettingSpeed = true;
      this.avPlayer?.setSpeed(this.anchorIntervalPlaySpeed);
    }
    if (time > this.slowMotionEnd && !this.isSettingSpeed &&
      this.currentPlaySpeed !== AvPlayConstants.PLAY_SPEED.SPEED_1_0_X) {
      Log.info(TAG, `video speed normal value: ${AvPlayConstants.PLAY_SPEED.SPEED_1_0_X}`);
      this.isSettingSpeed = true;
      this.avPlayer?.setSpeed(AvPlayConstants.PLAY_SPEED.SPEED_1_0_X);
    }
  }

  /* instrument ignore next */
  private getMediaBitrate(): void {
    this.avPlayer?.getTrackDescription().then((arrList: media.MediaDescription[]): void => {
      for (let i = 0; i < arrList.length; i++) {
        let desc: media.MediaDescription = arrList[i];
        if (desc[media.MediaDescriptionKey.MD_KEY_TRACK_TYPE] === media.MediaType.MEDIA_TYPE_VID) {
          this.bitrate = assert.asNumber(desc[media.MediaDescriptionKey.MD_KEY_BITRATE],
            'get bit_rate type error') ?? -1;
        }
      }
    });
  }

  /**
   *  慢动作锚点区间
   */
  /* instrument ignore next */
  private calculateSlowMotionAnchor(): void {
    if (!this.isSlowMotionVideo()) {
      Log.info(TAG, `video url: ${this.src} is not slow motion video,
      speed does not need to be changed. speed: ${this.anchorIntervalPlaySpeed}`);
      this.avPlayer?.setSpeed(AvPlayConstants.PLAY_SPEED.SPEED_1_0_X);
      return;
    }
    this.avPlayer?.getTrackDescription().then((arrList: media.MediaDescription[]): void => {
      this.slowMotionStart = 0;
      this.slowMotionEnd = 0;
      let originFrameRate: number | undefined = 0;
      for (let i = 0; i < arrList.length; i++) {
        let desc: media.MediaDescription = arrList[i];
        if (desc[media.MediaDescriptionKey.MD_KEY_TRACK_TYPE] === media.MediaType.MEDIA_TYPE_VID) {
          originFrameRate = assert.asNumber(desc[media.MediaDescriptionKey.MD_KEY_FRAME_RATE],
            'get frame_rate type error');
        }
      }
      this.fps = this.calibrateDeviation(originFrameRate ?? 0);
      Log.info(TAG, `${this.label} originFrameRate is: ${originFrameRate}, fps is: ${this.fps}, url: ${this.src}`);
      // 120 or 240 fps means slow motion video
      if (this.fps === AvPlayConstants.VIDEO_FPS_120) {
        this.anchorIntervalPlaySpeed = AvPlayConstants.PLAY_SPEED.SPEED_0_25_X;
      } else if (this.fps === AvPlayConstants.VIDEO_FPS_240) {
        this.anchorIntervalPlaySpeed = AvPlayConstants.PLAY_SPEED.SPEED_0_125_X;
      } else {
        Log.info(TAG, `${this.label} normal video playback, speed does need to be changed.`);
        this.anchorIntervalPlaySpeed = AvPlayConstants.PLAY_SPEED.SPEED_1_0_X;
      }
      // 临时方案变更：全区间
      // 正式方案：
      // 锚点起始位置: this.slowMotionStart = Math.trunc(this.duration * AvPlayConstants.PLAY_SPEED.ANCHOR_START);
      // 锚点结束位置: this.slowMotionEnd = Math.trunc(this.duration * AvPlayConstants.PLAY_SPEED.ANCHOR_END);
      this.slowMotionStart = 0;
      this.slowMotionEnd = this.duration;
      Log.info(TAG, `${this.label} slow motion video, start: ${this.slowMotionStart}, end: ${
      this.slowMotionEnd},speed: ${this.anchorIntervalPlaySpeed}`);
      if (!DeviceInfo.isPc()) {
        this.avPlayer?.setSpeed(this.anchorIntervalPlaySpeed);
      }
    }).catch((error: BusinessError): void => {
      Log.error(TAG, `${this.label} error happened on getTrackDescription, error code: ${
      error.code},error msg: ${error.message}`);
    });
  }

  private isSlowMotionVideo(): boolean {
    return this.src?.includes(AvPlayConstants.VIDEO_PREFIX_STR);
  }

  /**
   *  帧率误差校准
   * @param frameRate 帧率
   * @returns 校准值
   */
  private calibrateDeviation(frameRate: number): number {
    let fps: number = Math.round(frameRate ? frameRate / 100 : 0);
    if (Math.trunc(fps / 100) === 1 && fps >= AvPlayConstants.VIDEO_FPS_120 * AvPlayConstants.VIDEO_FPS_DEVIATION_MIN &&
      fps <= AvPlayConstants.VIDEO_FPS_120 * AvPlayConstants.VIDEO_FPS_DEVIATION_MAX) {
      fps = AvPlayConstants.VIDEO_FPS_120;
    }
    if (Math.trunc(fps / 100) === 2 && fps >= AvPlayConstants.VIDEO_FPS_240 * AvPlayConstants.VIDEO_FPS_DEVIATION_MIN &&
      fps <= AvPlayConstants.VIDEO_FPS_240 * AvPlayConstants.VIDEO_FPS_DEVIATION_MAX) {
      fps = AvPlayConstants.VIDEO_FPS_240;
    }
    return fps;
  }

  /* instrument ignore next */
  private audioInterruptBegin(info: audio.InterruptEvent): void {
    Log.info(TAG, `audio interrupt begin, hintType is ${info.hintType}`);
    if (info.hintType === audio.InterruptHint.INTERRUPT_HINT_PAUSE ||
      info.hintType === audio.InterruptHint.INTERRUPT_HINT_STOP) {
      this.pause(PauseReason.AUDIO);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, [true]);
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
    }
  }

  /* instrument ignore next */
  private audioInterruptEnd(info: audio.InterruptEvent): void {
    Log.info(TAG, `audio interrupt end, hintType is ${info.hintType}`);
    if (info.hintType === audio.InterruptHint.INTERRUPT_HINT_RESUME) {
      this.play();
      this.appBroadCast.emit(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, [false]);
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
    }
  }

  public getAvPlayerState(): string | undefined {
    if (!this.avPlayer) {
      Log.error(TAG, `${this.label} current avplayer instance is undefined, get avplayer state fail.`);
      return;
    }
    return this.avPlayer.state;
  }

  /* instrument ignore next */
  public activateAvplayer(src: string, surfaceId: string, fd: number): void {
    if (!this.avPlayer || this.getAvPlayerState() === AvplayerStatus.RELEASED) {
      Log.info(TAG, `[fd flag] activateAvplayer 1 photos_fd, close: ${fd}, reason: avplayer undefined or
       avplayer released.`);
      if (fd !== -1) {
        /* instrument ignore next */
        fs.close(fd).catch((err: BusinessError): void => {
          Log.error(TAG, `${this.label} close fd error.reason:avplayer undefined. ${err.code}: ${err.message}`);
        });
        this.videoPlayer?.closeFd(fd);
        this.videoPlayer?.setFd(this.fd);
      }
      Log.error(TAG, `${this.label} activateAvplayer fail, this.avPlayer is undefined.`);
      return;
    }
    if (this.getAvPlayerState() !== AvplayerStatus.IDLE) {
      this.activateOnNotIdle(src, surfaceId, fd);
      return;
    }
    if (this.src === src && this.fd !== -1 && this.fd !== fd && this.avPlayer.surfaceId === surfaceId) {
      Log.info(TAG, `[fd flag] activateAvplayer 2 photos_fd, close: ${fd}, this fd: ${this.fd}, reason: Obtain
       the FD repeatedly.`);
      if (fd !== -1) {
        fs.close(fd).catch((err: BusinessError): void => {
          Log.error(TAG, `${this.label} close fd error.reason:activateAvplayer(). ${err.code}: ${err.message}`);
        });
      }
      this.videoPlayer?.closeFd(this.fd);
      this.videoPlayer?.setFd(this.fd);
    } else if (this.src === src && this.fd !== -1 && this.fd !== fd && this.avPlayer.surfaceId !== surfaceId) {
      this.reActivateOnFdAndSurfaceIdRepeats(src, surfaceId, fd);
      return;
    } else {
      this.src = src;
      this.url = `fd://${fd}`;
      this.surfaceId = surfaceId;
      this.fd = fd;
    }
    if (this.fd === -1 || this.surfaceId === '') {
      Log.error(TAG, `${this.label} activate avplayer fail. reason: fd: ${this.fd}, surfaceId: ${this.surfaceId}`);
      return;
    }
    Log.info(TAG, `${this.label} activate avplayer, avplayer.url: ${this.avPlayer.url}, src: ${this.src}, surfaceId: ${
    this.surfaceId}, fd: ${this.fd}`);
    this.avPlayer.url = this.url;
    if (Global.getBoolean('autoPlayEnable')) {
      // 自动播放场景下，从激活avplayer开始计算起播时延
      this.videoPlayer?.initClickPlayButtonTime();
      this.videoPlayer?.showLoadingProgress();
    }
  }

  private activateOnNotIdle(src: string, surfaceId: string, fd: number): void {
    Log.warn(TAG, `${this.label} activateAvplayer fail,current avplayer state is not idle,state: ${
    this.getAvPlayerState()}, this.src: ${this.src}`);
    if (this.src === src) {
      Log.info(TAG, `[fd flag] activateOnNotIdle photos_fd, close: ${fd}, reason: avplayer not idle.`);
      // instrument ignore if
      if (this.fd !== fd && fd !== -1) {
        fs.close(fd).catch((err: BusinessError): void => {
          Log.error(TAG, `${this.label} close fd error.reason: activateOnNotIdle(), ${err.code}: ${err.message}`);
        });
        this.videoPlayer?.closeFd(fd);
        this.videoPlayer?.setFd(this.fd);
      }
      // instrument ignore if
      if (this.avPlayer && this.avPlayer.surfaceId !== surfaceId) {
        Log.info(TAG, `activateAvplayer avplyer not idle reset and update surfaceId,old: ${
        this.avPlayer.surfaceId}, new: ${surfaceId}`);
        this.avPlayer.reset().then((): void => {
          this.surfaceId = surfaceId;
          if (this.avPlayer) {
            this.avPlayer.url = this.url;
          }
        });
      }
    }
  }

  /**
   *  同一个视频的fd和surfaceId同时变化时触发
   * @param src
   * @param surfaceId 新开的surfaceID
   * @param fd 新开的fd
   */
  /* instrument ignore next */
  private reActivateOnFdAndSurfaceIdRepeats(src: string, surfaceId: string, fd: number): void {
    Log.info(TAG, `[fd flag] reActivateOnFdAndSurfaceIdRepeats photos_fd, close: ${this.fd}, reason: fd and surfaceId
     It's all different.`);
    fs.close(this.fd).catch((err: BusinessError): void => {
      Log.error(TAG, `${this.label} close fd error.reason: fdAndSurfaceIdRepeats(). ${err.code}: ${err.message}`);
    });
    this.fd = -1;
    this.src = src;
    this.fd = fd;
    this.url = `fd://${fd}`;
    this.surfaceId = surfaceId;
    if (this.avPlayer) {
      this.avPlayer.url = this.url;
    }
  }

  /* instrument ignore next */
  public getPlayerUrl(): string {
    return this.url;
  }

  /* instrument ignore next */
  public manuallyPlay(): boolean {
    Log.info(TAG, `${this.label} manually invoke play method, avplayer state is ${this.avPlayer?.state}`);
    if (this.isBufferingUpdate) {
      Log.info(TAG, `${this.label} manually invoke play method, current is loading data`);
      setTimeout((): void => {
        // double check，防止200ms延迟后快速点击 状态相悖
        this.appBroadCast.emit(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, [this.isBufferingUpdate]);
      }, this.bottomMenuChangeTime);
      return false;
    }
    this.play();
    return true;
  }

  public manuallyPause(): boolean {
    Log.info(TAG, `${this.label} manually invoke pause method, avplayer state is ${this.avPlayer?.state}`);
    if (this.isBufferingUpdate) {
      Log.info(TAG, `${this.label} manually invoke pause method, current is loading data`);
      this.appBroadCast.emit(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, [true]);
      return false;
    }
    this.pause(PauseReason.MANUALLY);
    return true;
  }

  public play(): void {
    if (!this.enablePlayApsState) {
      ApsUtil.enableVideoPlayerApsState();
      this.enablePlayApsState = true;
    }
    Log.info(TAG, `${this.label} invoke play method, avplayer state is ${this.avPlayer?.state}, pageStatus: ${
    this.pageStatus}`);
    // instrument ignore if
    if (this.pageStatus !== PageStatus.SHOW) {
      if (this.videoPlayer) {
        this.videoPlayer.beforePageHideStatus = AvplayerStatus.PLAYING;
      }
      Log.info(TAG, 'Not show pageStauts, return.');
      return;
    }
    let status: string[] = [AvplayerStatus.PREPARED, AvplayerStatus.PAUSED, AvplayerStatus.COMPLETED,
      AvplayerStatus.PLAYING];
    let currentStatus: string | undefined = this.getAvPlayerState();
    // instrument ignore if
    if (currentStatus && status.includes(currentStatus)) {
      this.avPlayer?.play().then((): void => {
        if (this.pageStatus === PageStatus.HIDE) {
          Log.info(TAG, `Play video when page is hidden and then stop`);
          if (this.videoPlayer) {
            this.videoPlayer.beforePageHideStatus = AvplayerStatus.PLAYING;
          }
          this.onPageHidePause();
        }
      });
    } else {
      Log.error(TAG, `${this.label} invoke play method fail. currentStatus: ${currentStatus}`);
    }
  }

  public pause(pauseReason: PauseReason): void {
    Log.info(TAG, `${this.label} invoke pause method, avplayer state is ${
    this.avPlayer?.state}, isPausing: ${this.isPausing}`);
    if (this.isPausing) {
      return;
    }
    this.isPausing = true;
    this.avPlayer?.pause(() => {
      this.isPausing = false;
    });
    let params: VideoReportParams = new VideoReportParams();
    params.url = this.src;
    if (this.videoPlayer) {
      params.subtype = this.videoPlayer?.getSubtype();
      params.quality = this.videoPlayer?.getPhotoQuality();
    }
    params.playTime = this.videoProgress;
    params.duration = this.duration;
    // instrument ignore if
    if (this.videoPlayer?.netQuality) {
      params.position = this.videoPlayer.getMediaPosition();
      params.netType = this.videoPlayer.netQuality.netType();
    }
    params.pauseReason = pauseReason;
    VideoPlayerBigDataReport.videoPause(params);
  }

  /**
   * 在上滑到后台时触发的pause操作
   */
  /* instrument ignore next */
  public onPageHidePause(): void {
    if (this.enablePlayApsState) {
      ApsUtil.disableVideoPlayerApsState();
      this.enablePlayApsState = false;
    }
    Log.info(TAG, `${this.label} onPageHide, invoke pause directly. isPausing: ${this.isPausing}, src: ${this.src}`);
    if (this.isPausing || this.getAvPlayerState() !== AvplayerStatus.PLAYING || this.isResetting) {
      return;
    }
    this.isPausing = true;
    this.avPlayer?.pause().then((): void => {
      Log.info(TAG, `${this.label} onPageHide pause done, invoke callback. src: ${this.src}`);
      this.isPausing = false;
      this.onPageHidePausedCallback();
      this.onPageHidePausedCallback = (): void => {
      };
    });
  }

  /**
   * 在图库回到前台时触发的play操作
   */
  /* instrument ignore next */
  public onPageShowPlay(): void {
    if (!this.enablePlayApsState) {
      ApsUtil.enableVideoPlayerApsState();
      this.enablePlayApsState = true;
    }
    Log.info(TAG, `${this.label} onPageShow, invoke play directly. status: ${this.getAvPlayerState()
    }, src: ${this.src}, isPausing: ${this.isPausing}`);
    let currentStatus: string | undefined = this.getAvPlayerState();
    if (currentStatus === AvplayerStatus.PAUSED) {
      this.avPlayer?.play();
    } else if (currentStatus === AvplayerStatus.PLAYING && this.isPausing) {
      this.onPageHidePausedCallback = (): void => {
        if (this.pageStatus === PageStatus.SHOW) {
          this.avPlayer?.play();
        }
      }
    } else {
      Log.warn(TAG, `${this.label} onPageShow, status: ${this.getAvPlayerState()}`);
    }
  }

  public async reset(): Promise<void> {
    if (this.enablePlayApsState) {
      ApsUtil.disableVideoPlayerApsState();
      this.enablePlayApsState = false;
    }
    Log.info(TAG, `${this.label} reset start,src: ${this.src}`);
    this.videoPlayer?.netQuality?.unregisterNetQuality();
    if (this.isResetting || this.getAvPlayerState() === AvplayerStatus.IDLE) {
      Log.warn(TAG, `${this.label} reset fail, current isResetting: ${
      this.isResetting},state: ${this.getAvPlayerState()},src: ${this.src}`);
      return;
    }
    if (!this.avPlayer) {
      Log.error(TAG, `${this.label} reset error, current avplayer undefiend.`);
      return;
    }
    clearTimeout(this.networkTimeId);
    if (this.getAvPlayerState() !== AvplayerStatus.COMPLETED) {
      this.reportVideoPlayFinish();
    }
    if (this.bufferTimes !== 0) {
      let params: VideoReportParams = new VideoReportParams();
      params.url = this.src;
      params.bufferTimes = this.bufferTimes;
      VideoPlayerBigDataReport.cloudVideoBufferTimes(params);
      this.bufferTimes = 0;
    }
    this.isResetting = true;
    let resetSrc: string = this.src;
    this.avPlayer?.reset().then(() => {
      this.isResetting = false;
      Log.info(TAG, `${this.label} reset completed,src: ${resetSrc}`);
      this.releaseAudioSession('videoPlayer reset');
    });
    this.closeFd();
    this.fd = -1;
    this.src = '';
    this.url = '';
    this.surfaceId = '';
    this.lastReportTime = 0;
    this.continuePlayOnMediaServiceRevive = false;
    this.progressTimeOnPaused = 0;
    this.isBufferingUpdate = false;
    this.bufferStartTime = 0;
    this.bufferEndTime = 0;
    this.bufferTotalTime = 0;
    this.videoCoverFrame = [];
    this.pageStatus = PageStatus.SHOW;
    // reset slow motion play speed
    this.resetIfPlaySlowMotion();
    this.videoPlayer?.netQuality?.clearQueue();
    let isInImmersivePage: boolean = getScreen().isInImmersivePage;
    // 幻灯片页面视频reset时禁止设置屏幕常亮状态
    if (!isInImmersivePage) {
      WindowUtil.setWindowKeepScreenOn(LocalStorage.getShared()?.get<Context>('photosAbilityContext') as
      common.UIAbilityContext, false);
    }
  }

  public closeFd(): void {
    Log.info(TAG, `[fd flag] closeFd photos_fd, close: ${this.fd}`);
    // instrument ignore if
    if (this.fd !== -1) {
      fs.close(this.fd).catch((err: BusinessError): void => {
        Log.error(TAG, `${this.label} close fd error.reason:closeFd(), ${err.code}: ${err.message}`);
      });
      this.videoPlayer?.closeFd(this.fd);
      this.fd = -1;
    }
  }

  /* instrument ignore next */
  private resetIfPlaySlowMotion(): void {
    if (this.currentPlaySpeed !== AvPlayConstants.PLAY_SPEED.SPEED_1_0_X ||
      this.fps === AvPlayConstants.VIDEO_FPS_120 || this.fps === AvPlayConstants.VIDEO_FPS_240) {
      Log.info(TAG, `${this.label} reset slow motion video state, currentSpeed: ${
      this.currentPlaySpeed},fps: ${this.fps}, src: ${this.src}`);
      this.fps = AvPlayConstants.VIDEO_FPS_60;
      this.anchorIntervalPlaySpeed = AvPlayConstants.PLAY_SPEED.SPEED_1_0_X;
      this.currentPlaySpeed = AvPlayConstants.PLAY_SPEED.SPEED_1_0_X;
      this.slowMotionStart = 0;
      this.slowMotionEnd = 0;
    }
  }

  public getIsResetting(): boolean {
    return this.isResetting;
  }

  public getIsPausing(): boolean {
    return this.isPausing;
  }

  public setVolume(volume: number): void {
    this.avPlayer?.setVolume(volume);
  }

  public setVideoPlayerProgress(progress?: PlayProgress): void {
    this.progress = progress;
  }

  public getVideoPlayerProgress(): PlayProgress | undefined {
    return this.progress;
  }

  private updateProgressTime(time: number): void {
    if (!this.progress) {
      return;
    }
    let nowSeconds: number = Math.floor(time / AvPlayConstants.A_THOUSAND);
    let totalSeconds: number = Math.floor(this.duration / AvPlayConstants.A_THOUSAND);
    if (this.duration !== 0 && this.duration < AvPlayConstants.A_THOUSAND) {
      totalSeconds = 1;
    }
    this.progress.currentTime = formatDuration(nowSeconds);
    this.progress.totalTime = formatDuration(totalSeconds);
    this.progress.progressVal = nowSeconds;
    Log.debug(TAG, `${this.label} updateProgressTime ${nowSeconds}`);
    this.progress.rawTime = time;
  }

  private updateSeekTime(time: number): void {
    this.appBroadCast.emit(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, [time]);
  }

  public resetProgress(): void {
    Log.info(TAG, `${this.label} reset video progress`);
    if (this.progress) {
      this.progress.currentTime = AvPlayConstants.PLAY_PROGRESS.CURRENT_TIME;
      this.progress.progressVal = AvPlayConstants.PLAY_PROGRESS.PROGRESS_VAL;
    }
  }

  public getAvPlayer(): media.AVPlayer | undefined {
    return this.avPlayer;
  }

  // 如果media service died后再次拉起是否继续播放
  public setContinuePlayOnMediaServiceRevive(continuePlayOnMediaServiceRevive: boolean): void {
    this.continuePlayOnMediaServiceRevive = continuePlayOnMediaServiceRevive;
  }

  /* instrument ignore next */
  private continuePlayFromDiedTimePoint(autoPlay: boolean, time: number): void {
    this.avPlayer?.seek(time, media.SeekMode.SEEK_CLOSEST);
    if (autoPlay) {
      this.avPlayer?.play().then((): void => {
        Log.info(TAG, `${this.label} step 4 success.`);
      });
    }
  }

  public setBeforeMediaServiceDiedProgress(progress: number): void {
    this.beforeMediaServiceDiedProgress = progress;
  }

  /* instrument ignore next */
  private avplayerErrorHandler(error: BusinessError): void {
    Log.error(TAG, `${this.label} handling error: ${error.code} start. ${this.src}`);
    switch (error.code) {
      case AvplayerErrorCode.SERVICE_DIED:
        this.mediaServiceDiedHandler();
        break;
      case AvplayerErrorCode.UNSUPPORTED_MEDIA_TYPE:
        this.unsupportedMediaTypeHandler();
        break;
      case AvplayerErrorCode.IO_ERROR:
        this.ioErrorHandler();
        break;
      case AvplayerErrorCode.OPERATION_NOT_ALLOWED:
        this.illegalOperationHandler();
        break;
      default:
        Log.error(TAG, `${this.label} current error not handled. error code: ${
        error.code}, error msg: ${error.message}`);
    }
    Log.error(TAG, `${this.label} handling error: ${error.code} end. ${this.src}`);
  }

  /* instrument ignore next */
  private illegalOperationHandler(): void {
    if (this.getAvPlayerState() === AvplayerStatus.IDLE) {
      Log.info(TAG, `${this.label} reset completed current status is idle, is OK.`);
    } else {
      Log.error(TAG, `${this.label} handle fail.`);
    }
  }

  /* instrument ignore next */
  private ioErrorHandler(): void {
    let avplayerSurfaceId: string | undefined = this.avPlayer?.surfaceId;
    let xComponentSurfaceId: string | undefined = this.videoPlayer?.surfaceXComponentMap[0];
    let xComponentStatus: XComponentStatus | undefined = this.videoPlayer?.surfaceXComponentMap[1];
    Log.info(TAG, `${this.label} ioError,avplayerSurfaceId:${
    avplayerSurfaceId},xComponentSurfaceId: ${xComponentSurfaceId}, xComponentStatus: ${xComponentStatus}`);
    if (avplayerSurfaceId === xComponentSurfaceId && xComponentStatus === XComponentStatus.LOAD) {
      // 弹窗
      UiUtil.showToast($r('app.string.video_player_cloud_io_error'));
    }
    // 长按加速中断网发生ioerror，将蒙版和label撤销
    this.videoPlayer?.setSpeedUpValue(false);
    this.videoPlayer?.fastPlayBroadcast();
    // 重置菜单栏
    this.appBroadCast.emit(BroadCastConstants.VIDEO_PLAY_COMPLETED, []);
    // 回到封面
    this.videoPlayer?.backToVideoCover(this.src);
    // 重新激活avplayer
    this.reset();
  }

  /* instrument ignore next */
  private unsupportedMediaTypeHandler(): void {
    Log.info(TAG, `${this.label} unSupported meida type, url: ${this.src}`);
    if (PhotoConfig.isFromMeetime) {
      Log.info(TAG, 'unsupportedMediaTypeHandler isFromMeetime');
      return;
    }
    UiUtil.showToast($r('app.string.unsupported_video_type'));
    this.appBroadCast.emit(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, [false, this.src]);
    this.appBroadCast.emit(BroadCastConstants.VIDEO_PLAY_COMPLETED, []);
    if (this.getAvPlayerState() !== AvplayerStatus.IDLE) {
      // 回到封面
      this.videoPlayer?.backToVideoCover(this.src);
      this.reset();
    }
  }

  // media service 20s最多拉起4次
  /* instrument ignore next */
  private mediaServiceDiedHandler(): void {
    this.beforeMediaServiceDiedProgress = this.videoProgress;
    Log.info(TAG, `${this.label} step 1: release error instance.${this.label}. step 2: create new instance.${
    this.label}. step 3: refresh xComponent.${this.label}. step 4: check is or not contune play from died point.`);
    this.releaseErrorAvPlayer(this.avPlayer);
    Log.info(TAG, `${this.label} step 1 success.`);
    media.createAVPlayer().then((avPlayer) => {
      Log.info(TAG, `${this.label} step 2 success.`);
      if (avPlayer) {
        this.avPlayer = avPlayer;
        // 顺序不可变
        this.setStateMachineCallBack();
        this.bindState();
        this.setStateMachineListener();
        this.videoPlayer?.onMediaServiceDied();
      } else {
        Log.error(TAG, `${this.label} step 2 fail. avPlayer is undefined.`);
      }
    }).catch((error: BusinessError): void => {
      Log.error(TAG, `${this.label} step 2 error: ${error}`);
    });
  }

  public reportVideoPlayFinish(): void {
    if (!this.videoPlayer) {
      return;
    }
    let params: VideoReportParams = new VideoReportParams();
    params.url = this.src;
    params.subtype = this.videoPlayer.getSubtype();
    params.quality = this.videoPlayer.getPhotoQuality();
    params.position = this.videoPlayer.getMediaPosition();
    params.playTime = this.videoProgress;
    params.duration = this.duration;
    params.bufferTimes = this.bufferTimes;
    params.totalTime = this.bufferTotalTime;
    // instrument ignore if
    if (this.videoPlayer.netQuality) {
      params.netType = this.videoPlayer.netQuality?.netType();
    }
    VideoPlayerBigDataReport.videoPlayFinish(params);
  }

  public getVideoCoverFrame(): PixelMap[] {
    return this.videoCoverFrame;
  }

  /* instrument ignore next */
  public getIsBufferingUpdate(): boolean {
    return this.isBufferingUpdate;
  }

  public getVideoProgress(): number {
    return this.videoProgress;
  }

  public getSeekRawTime(): number {
    return this.seekRawTime;
  }

  public getVideoSrc(): string {
    return this.src;
  }

  public setVideoSrc(src: string): void {
    this.src = src;
  }

  public setLastReportTime(lastReportTime: number): void {
    this.lastReportTime = lastReportTime;
  }

  public setPageStatus(pageStatus: PageStatus): void {
    this.pageStatus = pageStatus;
  }

  public setPlayingEnhancer(cb: Function): void {
    this.onPlayingCallbackEnhancer = cb;
  }

  public setPauseEnhancer(cb: Function): void {
    this.onPausedCallbackEnhancer = cb;
  }

  public setCompletedEnhancer(cb: Function): void {
    this.onCompletedCallbackEnhancer = cb;
  }

  public setIdleEnhancer(cb: () => void): void {
    this.onIdleCallbackEnhancer = cb;
  }

  public getLabel(): string {
    return this.label;
  }

  public getVideoPlayer(): VideoPlayer | undefined {
    return this.videoPlayer;
  }

  public setVideoPlayer(videoPlayer?: VideoPlayer): void {
    this.videoPlayer = videoPlayer;
  }

  public updateFingerSlide(isFingerSlide: boolean): void {
    this.isFingerSlide = isFingerSlide;
  }

  public updateSeekRawTime(seekRawTime: number): void {
    this.seekRawTime = seekRawTime;
    Log.info(TAG, `updateSeekRawTime this.seekRawTime: ${this.seekRawTime}`);
  }

  /**
   * 获取视频格式是否支持continuous
   * @returns Seek是否是continuous模式
   */
  public isSeekContinueSupported(): boolean {
    return this.seekContinuousSupported;
  }

  /**
   *  释放video控制器
   */
  /* instrument ignore next */
  public releaseController(): void {
    if (this.enablePlayApsState) {
      ApsUtil.disableVideoPlayerApsState();
      this.enablePlayApsState = false;
    }
    Log.info(TAG, `${this.label} releaseController start.`);
    this.avPlayer = undefined;
    this.avPlayerCallBack = undefined;
    this.videoPlayer = undefined;
    this.voidMethod = () => {
    };
    this.onPlayingCallbackEnhancer = () => {
    };
    this.onPausedCallbackEnhancer = () => {
    };
    this.onCompletedCallbackEnhancer = () => {
    };
    this.onCreatTimeoutCallback = () => {
    };
    this.onIdleCallbackEnhancer = () => {
    };
    Log.info(TAG, `${this.label} releaseController end.`);
  }

  /**
   *  释放资源
   */
  public static release(): void {
    let releaseQueue: Queue<VideoPlayController> = new Queue();
    let queue: Queue<VideoPlayController> = VideoPlayController.videoPlayerQueue;
    Log.info(TAG, `avplayer instance queue release, length: ${queue.length}`);
    while (queue.length > 0) {
      releaseQueue.add(queue.pop());
    }
    Log.info(TAG, `releaseQueue start release, length: ${releaseQueue.length}, queue.length: ${queue.length}`);
    /* instrument ignore next */
    while (releaseQueue.length > 0) {
      let controller: VideoPlayController = releaseQueue.pop();
      let avplayer: media.AVPlayer | undefined = controller.getAvPlayer();
      // 释放avplayer实例
      avplayer?.release().then((): void => {
        Log.info(TAG, `${controller.label} release success, off avplayer events`);
        VideoPlayController.offEvents(avplayer);
        controller.releaseController();
        controller.releaseAudioSession('videoPlayer release', true);
      });
    }
  }

  /**
   *  释放实例前关闭注册的监听
   * @param avplayer
   */
  public static offEvents(avplayer: media.AVPlayer | undefined): void {
    if (!avplayer) {
      return;
    }
    avplayer.off(Events.STATE_CHANGE);
    avplayer.off(Events.TIME_UPDATE);
    avplayer.off(Events.AUDIO_INTERRUPT);
    avplayer.off(Events.END_OF_STREAM);
    avplayer.off(Events.START_RENDER_FRAME);
    avplayer.off(Events.VIDEO_SIZE_CHANGE);
    avplayer.off(Events.ERROR);
    avplayer.off(Events.SEEK_DONE);
    avplayer.off(Events.SPEED_DONE);
    avplayer.off(Events.AUDIO_OUTPUT_DEVICE_CHANGE_WITH_INFO);
  }

  private releaseAudioSession(reason: string, cancelAll: boolean = false): void {
    let audioSessionController: AudioSessionController = AudioSessionController.getInstance();
    if (cancelAll) {
      audioSessionController.cancelAudioSession({
        deActivateCallback: (): void => {
          Log.info(TAG, `[audioSession] deActivate by ${reason}: ${audioSessionController.getAudioSessionStrategy()}`);
        }
      });
      return;
    }
    if (audioSessionController.getAudioSessionStrategy() === AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS) {
      audioSessionController.cancelAudioSession({
        deActivateCallback: (): void => {
          Log.info(TAG, `[audioSession] deActivate by ${reason}: CONCURRENCY_PAUSE_OTHERS`);
        }
      });
    }
  }
}