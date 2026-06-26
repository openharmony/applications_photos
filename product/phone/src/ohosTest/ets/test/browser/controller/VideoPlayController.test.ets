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

import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import {
  AvPlayConstants,
  AvplayerStatus,
  PageStatus,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import media from '@ohos.multimedia.media';

let videoPlayController: VideoPlayController | undefined = undefined;

export default function VideoPlayControllerTest() {
  describe('VideoPlayControllerTest', () => {

    beforeEach(() => {
      videoPlayController = VideoPlayController.getInstance();
    });

    afterEach(() => {
      videoPlayController = undefined;
      VideoPlayController.release();
    });

    it('getInstance', 0, () => {
      VideoPlayController.getInstance();
      VideoPlayController.getInstance('test');
    });
    it('setSpeedOnSlowMotionSeekDone', 0, () => {
      setSpeedOnSlowMotionSeekDone();
    });
    it('exitSlowMotion', 0, () => {
      exitSlowMotion();
    });
    it('setSpeedOnPlaySlowMotion', 0, () => {
      setSpeedOnPlaySlowMotion();
    });
    it('testSomeFunc', 0, () => {
      testSomeFunc();
    });
    it('calibrateDeviation', 0, () => {
      calibrateDeviation();
    });
    it('activateAvplayer', 0, () => {
      activateAvplayer();
    });
    it('getAvPlayerState', 0, async () => {
      await getAvPlayerState();
    });
    it('activateOnNotIdle', 0, async () => {
      expect(activateOnNotIdle()).assertPromiseIsResolved();
    });
    it('manuallyPause', 0, () => {
      manuallyPause();
    });
    it('play', 0, () => {
      play();
    });
    it('pause', 0, () => {
      pause();
    });
    it('testGetAndSet', 0, () => {
      testGetAndSet();
    });
    it('closeFd', 0, () => {
      closeFd();
    });
    it('updateProgressTime', 0, () => {
      updateProgressTime();
    });
    it('reportBufferingShort', 0, () => {
      reportBufferingShort();
    });
    it('reportVideoPlayFinish', 0, () => {
      reportVideoPlayFinish();
    });
    it('resetProgress', 0, () => {
      resetProgress();
    });
    it('offEvents', 0, () => {
      offEvents();
    });
  })
}

function setSpeedOnSlowMotionSeekDone() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).fps = AvPlayConstants.VIDEO_FPS_60;
  (videoPlayController as ESObject).setSpeedOnSlowMotionSeekDone(1000);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(false);

  (videoPlayController as ESObject).fps = AvPlayConstants.VIDEO_FPS_120;
  (videoPlayController as ESObject).slowMotionStart = 5000;
  (videoPlayController as ESObject).slowMotionEnd = 10000;
  (videoPlayController as ESObject).setSpeedOnSlowMotionSeekDone(7500);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(true);

  (videoPlayController as ESObject).setSpeedOnSlowMotionSeekDone(12000);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(true);
}

function exitSlowMotion() {
  if (videoPlayController == undefined) {
    return;
  }
  videoPlayController.exitSlowMotion();
  expect((videoPlayController as ESObject).isSettingSpeed).assertTrue();
}

function setSpeedOnPlaySlowMotion() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).fps = AvPlayConstants.VIDEO_FPS_60;
  (videoPlayController as ESObject).setSpeedOnPlaySlowMotion(1000);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(false);

  (videoPlayController as ESObject).isResetting = true;
  (videoPlayController as ESObject).setSpeedOnPlaySlowMotion(1000);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(false);

  (videoPlayController as ESObject).fps = AvPlayConstants.VIDEO_FPS_120;
  (videoPlayController as ESObject).isResetting = false;
  (videoPlayController as ESObject).slowMotionStart = 0;
  (videoPlayController as ESObject).slowMotionEnd = 1000;
  (videoPlayController as ESObject).currentPlaySpeed = 1.0;
  (videoPlayController as ESObject).anchorIntervalPlaySpeed = 0.5;
  (videoPlayController as ESObject).setSpeedOnPlaySlowMotion(500);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(true);

  (videoPlayController as ESObject).fps = AvPlayConstants.VIDEO_FPS_120;
  (videoPlayController as ESObject).isResetting = false;
  (videoPlayController as ESObject).slowMotionStart = 0;
  (videoPlayController as ESObject).slowMotionEnd = 1000;
  (videoPlayController as ESObject).currentPlaySpeed = 0.5;
  (videoPlayController as ESObject).setSpeedOnPlaySlowMotion(1500);
  expect((videoPlayController as ESObject).isSettingSpeed).assertEqual(true);
}

function testSomeFunc() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).avPlayerCallBack.idleCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.initializedCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.preparedCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.playingCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.pauseCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.completedCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.stopCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.releasedCallBack();
  (videoPlayController as ESObject).avPlayerCallBack.errorCallBack();
  (videoPlayController as ESObject).onPageHidePausedCallback();
  (videoPlayController as ESObject).onPlayingCallbackEnhancer();
  (videoPlayController as ESObject).onPausedCallbackEnhancer();
  (videoPlayController as ESObject).onCompletedCallbackEnhancer();
  (videoPlayController as ESObject).onCreatTimeoutCallback();
  (videoPlayController as ESObject).onIdleCallbackEnhancer();
  (videoPlayController as ESObject).voidMethod();
}

function calibrateDeviation() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).calibrateDeviation(12000);
  (videoPlayController as ESObject).calibrateDeviation(24000);
  (videoPlayController as ESObject).calibrateDeviation(100);
}

function activateAvplayer() {
  if (videoPlayController == undefined) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockfunc: Function = mocker.mockFunc(videoPlayController, videoPlayController.getAvPlayerState);
  when(mockfunc)().afterReturn(AvplayerStatus.RELEASED);
  videoPlayController.activateAvplayer('src', 'surfaceId', 1);

  when(mockfunc)().afterReturn(AvplayerStatus.RELEASED);
  videoPlayController.activateAvplayer('src', 'surfaceId', -1);
  mocker.ignoreMock(videoPlayController, videoPlayController.getAvPlayerState);
}

async function getAvPlayerState() {
  if (videoPlayController == undefined) {
    return;
  }
  videoPlayController.getAvPlayerState();
  let avPlayer: ESObject = new Object();
  avPlayer.state = 'test';
  (videoPlayController as ESObject).avPlayer = await media.createAVPlayer();
  videoPlayController.getAvPlayerState();
}

async function activateOnNotIdle() {
  if (videoPlayController == undefined) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockfunc: Function = mocker.mockFunc(videoPlayController, videoPlayController.getAvPlayerState);
  when(mockfunc)().afterReturn(AvplayerStatus.IDLE);
  (videoPlayController as ESObject).src = 'src';
  (videoPlayController as ESObject).activateOnNotIdle('src', 'newSurfaceId', 1);
  (videoPlayController as ESObject).fd = 0;
  let avPlayer = await media.createAVPlayer();
  avPlayer.surfaceId = 'newSurfaceId';
  (videoPlayController as ESObject).avPlayer = avPlayer;
  (videoPlayController as ESObject).activateOnNotIdle('src', 'newSurfaceId', 1);
  (videoPlayController as ESObject).activateOnNotIdle('src', 'surfaceId', -1);
  (videoPlayController as ESObject).avPlayer.enableCameraPostprocessing?.();
  (videoPlayController as ESObject).avPlayer.prepare();
}


function manuallyPause() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).isBufferingUpdate = true;
  expect(videoPlayController.manuallyPause()).assertFalse();
  (videoPlayController as ESObject).isBufferingUpdate = false;
  expect(videoPlayController.manuallyPause()).assertTrue();
}

function play() {
  if (videoPlayController == undefined) {
    return;
  }
  (VideoPlayController as ESObject).pageStatus = PageStatus.SHOW;
  videoPlayController.play();
  (VideoPlayController as ESObject).pageStatus = PageStatus.HIDE;
  videoPlayController.play();
}

function pause() {
  if (videoPlayController == undefined) {
    return;
  }
  (VideoPlayController as ESObject).isPausing = true;
  videoPlayController.pause(PauseReason.MANUALLY);
  (VideoPlayController as ESObject).pageStatus = false;
  videoPlayController.pause(PauseReason.MANUALLY);
}

function testGetAndSet() {
  if (videoPlayController == undefined) {
    return;
  }
  videoPlayController.getIsResetting();
  videoPlayController.getIsPausing();
  videoPlayController.setVolume(1);
  videoPlayController.setVideoPlayerProgress();
  videoPlayController.getVideoProgress();
  videoPlayController.setLastReportTime(1);
  videoPlayController.setPageStatus(PageStatus.HIDE);
  videoPlayController.setPlayingEnhancer(() => {
  });
  videoPlayController.setPauseEnhancer(() => {
  });
  videoPlayController.setCompletedEnhancer(() => {
  });
  videoPlayController.setIdleEnhancer(() => {
  });
  videoPlayController.getLabel();
  videoPlayController.getVideoPlayer();
  videoPlayController.setVideoPlayer();
  videoPlayController.updateFingerSlide(true);
  videoPlayController.updateSeekRawTime(1);
  videoPlayController.isSeekContinueSupported();
  videoPlayController.setVideoSrc('test');
  videoPlayController.getVideoSrc();
  videoPlayController.getVideoPlayerProgress();
  videoPlayController.setContinuePlayOnMediaServiceRevive(true);
  videoPlayController.setBeforeMediaServiceDiedProgress(1);
  videoPlayController.setBeforeMediaServiceDiedProgress(1);
  videoPlayController.getVideoCoverFrame();
  videoPlayController.releaseController();
  expect((VideoPlayController as ESObject).videoPlayer).assertUndefined();
}

function closeFd() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).fd = 1;
  videoPlayController.closeFd();
  (videoPlayController as ESObject).fd = -1;
  videoPlayController.closeFd();
}

function updateProgressTime() {
  if (videoPlayController == undefined) {
    return;
  }
  (videoPlayController as ESObject).progress = null;
  (videoPlayController as ESObject).updateProgressTime();
  (videoPlayController as ESObject).progress = new Object() as ESObject;
  (videoPlayController as ESObject).duration = 1;
  (videoPlayController as ESObject).updateProgressTime();
  (videoPlayController as ESObject).duration = 0;
  (videoPlayController as ESObject).updateProgressTime();
}

function reportBufferingShort() {
  if (videoPlayController == undefined) {
    return;
  }
  let videoPlayer: ESObject = new Object() as ESObject;
  let netQuality: ESObject = new Object() as ESObject;
  videoPlayer.netQuality = null;
  netQuality.netType = () => {
  };
  netQuality.netDownWidthAvg = () => {
  };
  netQuality.netDownRateAvg = () => {
  };
  netQuality.netRttMsAvg = () => {
  };
  (videoPlayController as ESObject).reportBufferingShort();
  videoPlayer.netQuality = netQuality;
  (videoPlayController as ESObject).reportBufferingShort();
}

function reportVideoPlayFinish() {
  if (videoPlayController == undefined) {
    return;
  }
  let videoPlayer: ESObject = new Object() as ESObject;
  let netQuality: ESObject = new Object() as ESObject;
  videoPlayer.netQuality = null;
  (videoPlayController as ESObject).reportVideoPlayFinish();
  videoPlayer.netQuality = netQuality;
  (videoPlayController as ESObject).reportVideoPlayFinish();
}

function resetProgress() {
  if (videoPlayController == undefined) {
    return;
  }
  videoPlayController.resetProgress();
  (videoPlayController as ESObject).progress = new Object() as ESObject;
  videoPlayController.resetProgress();
}

function offEvents() {

  VideoPlayController.offEvents(null as ESObject);
  let avplayer: ESObject = new Object() as ESObject;
  avplayer.off = () => {
  }
  VideoPlayController.offEvents(avplayer);
}