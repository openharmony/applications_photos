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

import lazy { AvPlayConstants, AvplayerStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { formatDuration } from '@ohos/common/src/main/ets/default/model/common/DurationFormatter';
import lazy media from '@ohos.multimedia.media';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { VideoPlayController } from '../controller/VideoPlayController';

/* instrument ignore file */
const TAG: string = 'videoPlayerProgress';

/**
 * 视频进度条组件
 */
@Component
export struct PlayProgress {
  private videoPlayController?: VideoPlayController;
  @State currentTime: string = AvPlayConstants.PLAY_PROGRESS.CURRENT_TIME;
  @State totalTime: string = AvPlayConstants.PLAY_PROGRESS.TOTAL_TIME;
  @State progressVal: number = AvPlayConstants.PLAY_PROGRESS.PROGRESS_VAL;
  @State rawTime: number = AvPlayConstants.PLAY_PROGRESS.RAW_TIME;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private refreshVideoStateFunc: Function = (state: AvplayerStatus): void => this.refreshVideoState(state);
  private beforeVideoState: AvplayerStatus = AvplayerStatus.PAUSED;
  @Consume isProgressOnPanGesture: boolean;
  private maxTime: number = 0;
  private shouldPause: boolean = false;
  private backPoint: number = -1;
  // 是否正在执行pause动作
  private isPausing: boolean = false;
  // seek pause后置处理器
  private seekPausedPostHandler: Function = (): void => {
  };
  // seek pause后置交换处理器
  private seekPausedContinuePlay: Function = (): void => this.continuePlay();
  private url: string = '';
  private isFromPickerView: boolean = LocalStorage.getShared()?.get(Constants.IS_FROM_PICKER_VIEW) as boolean;

  private continuePlay(): void {
    this.videoPlayController?.getAvPlayer()?.play().then((): void => {
      Log.info(TAG, 'seek moving, invoke play after paused.');
      this.seekPausedPostHandler = (): void => {
      };
    });
  }

  @Consume backgroundColorResource: Resource;

  public setMaxTime(maxTime: number): void {
    maxTime = Math.floor(maxTime / AvPlayConstants.A_THOUSAND);
    if (this.maxTime === 0) {
      this.maxTime = maxTime;
      this.totalTime = formatDuration(this.maxTime);
      Log.info(TAG, `progress max time changed by set, maxTime: ${this.maxTime}, totalTime: ${this.totalTime}, url: ${
      this.url}`);
    }
  }

  public resetBackPoint(): void {
    this.backPoint = -1;
  }

  public getRawTime(): number {
    return this.rawTime;
  }

  private refreshVideoState(state: AvplayerStatus): void {
    Log.info(TAG, `get video status from broadcast,status: ${state}.`);
    this.beforeVideoState = state;
  }

  aboutToAppear() {
    this.maxTime = Math.floor(this.maxTime / AvPlayConstants.A_THOUSAND);
    this.totalTime = formatDuration(this.maxTime);
    Log.info(TAG, `progress aboutToAppear,maxTime: ${this.maxTime}, totalTime: ${this.totalTime}, url: ${this.url}`);
    this.videoPlayController?.setVideoPlayerProgress(this);
    this.appBroadCast.on(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, this.refreshVideoStateFunc);
  }

  aboutToDisappear() {
    this.appBroadCast.off(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, this.refreshVideoStateFunc);
  }

  // 开启进度条假seek，弹回loading的位置：backPoint，规避loading期间seek回退问题
  private fakeSeek(value: number, mode: SliderChangeMode): void {
    Log.info(TAG, `avplayer loading data, fake seek start, value: ${value}, mode: ${
    mode.toString()}, this.backPoint: ${this.backPoint}, videoProgress: ${
    this.videoPlayController?.getVideoProgress()}`);
    if (mode === SliderChangeMode.Moving || mode === SliderChangeMode.Click) {
      this.progressVal = Math.floor(value);
      this.currentTime = formatDuration(this.progressVal);
    } else if (mode === SliderChangeMode.End) {
      if (this.videoPlayController) {
        let backTime: number = this.backPoint !== -1 ? this.backPoint : this.videoPlayController.getVideoProgress();
        this.progressVal = Math.floor(backTime / AvPlayConstants.A_THOUSAND);
        this.currentTime = formatDuration(this.progressVal);
      }
    } else {
      return;
    }
  }

  private setSeekTime(value: number, mode: SliderChangeMode): void {
    Log.debug(TAG, `seekTime value: ${value}, slider change mode: ${mode.toString()}, beforeState: ${
    this.beforeVideoState}`);
    let time: number = Math.round(value);
    switch (mode) {
      case SliderChangeMode.Begin:
        this.seekBeginHandler();
        break;
      case SliderChangeMode.Moving:
        this.seekMovingHandler(time);
        break;
      case SliderChangeMode.Click:
        this.seekClickHandler(time);
        break;
      case SliderChangeMode.End:
        this.seekEndHandler(time);
        break;
      default:
        break;
    }
  }

  private seekBeginHandler(): void {
    if (this.beforeVideoState === AvplayerStatus.PLAYING) {
      Log.info(TAG, 'seek begin.');
      this.shouldPause = true;
    }
    if (this.beforeVideoState === AvplayerStatus.PAUSED) {
      Log.info(TAG, 'seek PAUSED.');
    }
  }

  private seekMovingHandler(value: number): void {
    let currentVideoState: string | undefined = this.videoPlayController?.getAvPlayerState();
    Log.debug(TAG, `seek moving, shouldPause: ${this.shouldPause}, before state: ${
    this.beforeVideoState}, current state: ${currentVideoState}.`);
    if (this.shouldPause && currentVideoState === AvplayerStatus.PLAYING && !this.isPausing) {
      this.isPausing = true;
      this.videoPlayController?.getAvPlayer()?.pause().then((): void => {
        this.isPausing = false;
        this.seekPausedPostHandler();
      });
    }
    // 拖动过程中当前时间发生变化，其他参数保持不变
    this.progressVal = value;
    this.currentTime = formatDuration(value);
  }

  private seekClickHandler(value: number): void {
    Log.info(TAG, `seek click, progress seek, slidermode is click, value = ${value}`);
  }

  private sendPlayStateToThirdApp(mode: SliderChangeMode): void {
    let storage = LocalStorage.GetShared();
    let state: number = -1;
    if (mode === SliderChangeMode.Begin) {
      state = 3;
    } else if (mode === SliderChangeMode.End) {
      state = 4;
    }
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) && state !== -1) {
      let session: UIExtensionContentSession | undefined =
        storage.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.sendData({ 'dataType': 'onVideoPlayStateChanged', 'state': state });
    }
  }

  private seekEndHandler(value: number): void {
    let currentVideoState: string | undefined = this.videoPlayController?.getAvPlayerState();
    Log.info(TAG, `seek end, before state: ${this.beforeVideoState}, current state: ${
    currentVideoState}, shouldPause: ${this.shouldPause}.`);
    let seekTime: number = value * AvPlayConstants.A_THOUSAND;
    this.videoPlayController?.getAvPlayer()?.seek(seekTime, media.SeekMode.SEEK_CLOSEST);
    if (this.beforeVideoState === AvplayerStatus.PLAYING && currentVideoState === AvplayerStatus.PAUSED) {
      this.videoPlayController?.play();
    }
    if (this.shouldPause && this.beforeVideoState === AvplayerStatus.PLAYING &&
      currentVideoState === AvplayerStatus.PLAYING) {
      this.seekPausedPostHandler = this.seekPausedContinuePlay;
    }
    this.shouldPause = false;
    if (this.backPoint === -1) {
      this.backPoint = seekTime;
    }
  }

  private getTimeTextColor(): ResourceColor {
    return Color.White;
  }

  private isLightBackGround() {
    return this.backgroundColorResource.id !== $r('app.color.black').id;
  }

  build() {
    Column() {
      Row() {
        Text(this.currentTime)
          .fontSize($r('app.float.slider_font_size'))
          .fontColor(this.getTimeTextColor())
        Slider({
          value: this.progressVal,
          step: AvPlayConstants.PLAY_PROGRESS.STEP,
          style: SliderStyle.OutSet,
          max: this.maxTime,
        })
          .blockColor(Color.White)
          .trackColor($r('sys.color.comp_background_secondary'))
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .trackThickness(AvPlayConstants.PLAY_PROGRESS.TRACK_THICKNESS)
          .layoutWeight(1)
          .focusable(true)
          .key('videoPlayerProgress')
          .margin({ left: AvPlayConstants.PLAY_PROGRESS.MARGIN_LEFT })
          .onChange((value: number, mode: SliderChangeMode): void => {
            if (this.videoPlayController?.getIsBufferingUpdate()) {
              this.fakeSeek(value, mode);
            } else {
              this.setSeekTime(value, mode);
            }
            if (this.isFromPickerView && (mode === SliderChangeMode.Begin || mode === SliderChangeMode.End)) {
              this.sendPlayStateToThirdApp(mode);
            }
          })
          .draggable(false)
          .onTouch((event: TouchEvent): void => {
            if (event.type === TouchType.Down) {
              this.isProgressOnPanGesture = true;
            }
            if (event.type === TouchType.Up) {
              this.isProgressOnPanGesture = false;
            }
          })
        Text(this.totalTime)
          .fontSize($r('app.float.slider_font_size'))
          .fontColor(this.getTimeTextColor())
          .margin({ left: AvPlayConstants.PLAY_PROGRESS.MARGIN_LEFT })
      }
      .width(AvPlayConstants.PLAY_PROGRESS.ROW_WIDTH)
    }
    .width(AvPlayConstants.FULL_PERCENT)
    .height(AvPlayConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
  }
}