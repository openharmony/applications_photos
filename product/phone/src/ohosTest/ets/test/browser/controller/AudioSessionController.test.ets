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
import {
  AudioSessionController,
  AudioSessionParams,
  AudioSessionStrategy,
} from '@ohos/browsercommon/src/main/ets/default/controller/AudioSessionController';
import { IntentionCode, KeyCode, KeyEvent } from '@kit.InputKit';
import { audio } from '@kit.AudioKit';

let audioSessionController: AudioSessionController | undefined = undefined;

export default function AudioSessionControllerTest() {
  describe('AudioSessionControllerTest', () => {

    beforeEach(() => {
      audioSessionController = AudioSessionController.getInstance();
    });

    afterEach(() => {
      audioSessionController = undefined;
    });

    it('setAudioSessionStrategy', 0, () => {
      setAudioSessionStrategy();
    });
    it('setActivateCallback', 0, () => {
      setActivateCallback();
    });
    it('setDeActivateCallback', 0, () => {
      setDeActivateCallback();
    });
    it('setAudioSessionDeActivateCallback', 0, () => {
      setAudioSessionDeActivateCallback();
    });
    it('transformStrategy', 0, () => {
      transformStrategy();
    });
    it('setAudioSession', 0, () => {
      setAudioSession();
    });
    it('cancelAudioSession', 0, () => {
      cancelAudioSession();
    });
  })
}

function setAudioSessionStrategy() {
  if (audioSessionController == undefined) {
    return;
  }
  audioSessionController.setAudioSessionStrategy();
  audioSessionController.setAudioSessionStrategy(AudioSessionStrategy.CONCURRENCY_MIX_WITH_OTHERS);
  expect((audioSessionController as ESObject).audioSessionStrategy)
    .assertEqual(AudioSessionStrategy.CONCURRENCY_MIX_WITH_OTHERS);
}

function setActivateCallback() {
  if (audioSessionController == undefined) {
    return;
  }
  audioSessionController.setActivateCallback();
  audioSessionController.setActivateCallback(() => {
  });
}

function setDeActivateCallback() {
  if (audioSessionController == undefined) {
    return;
  }
  audioSessionController.setDeActivateCallback();
  audioSessionController.setDeActivateCallback(() => {
  });
}

function setAudioSessionDeActivateCallback() {
  if (audioSessionController == undefined) {
    return;
  }
  audioSessionController.setAudioSessionDeActivateCallback(() => {
  });
  audioSessionController.setAudioSessionDeActivateCallback();
}

function transformStrategy() {
  if (audioSessionController == undefined) {
    return;
  }
  (audioSessionController as ESObject).transformStrategy();

  let result: audio.AudioConcurrencyMode =
    (audioSessionController as ESObject).transformStrategy(AudioSessionStrategy.CONCURRENCY_DEFAULT);
  expect(result).assertEqual(audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT);
  result = (audioSessionController as ESObject).transformStrategy(AudioSessionStrategy.CONCURRENCY_MIX_WITH_OTHERS);
  expect(result).assertEqual(audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS);
  result = (audioSessionController as ESObject).transformStrategy(AudioSessionStrategy.CONCURRENCY_DUCK_OTHERS);
  expect(result).assertEqual(audio.AudioConcurrencyMode.CONCURRENCY_DUCK_OTHERS);
  result = (audioSessionController as ESObject).transformStrategy(AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS);
  expect(result).assertEqual(audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS);
  (audioSessionController as ESObject).transformStrategy(null as ESObject);
}

function setAudioSession() {
  if (audioSessionController == undefined) {
    return;
  }
  let audioSessionParams: AudioSessionParams = {
    audioSessionStrategy: AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS,
    activateCallback: () => {
    },
    audioSessionDeActivateCallback: (event: audio.AudioSessionDeactivatedEvent): void => {
    }
  }

  let mocker: MockKit = new MockKit();
  let mockIsActivated: Function = mocker.mockFunc(audioSessionController, audioSessionController.getIsActivated);
  let mockSetAudioSessionStrategy: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.setAudioSessionStrategy);
  let mockSetActivateCallback: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.setActivateCallback);
  let mockSetAudioSessionDeActivateCallback: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.setAudioSessionDeActivateCallback);
  let mockActivateAudioSession: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.activateAudioSession);
  let mockRegisterAudioSessionDeActivateListener: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.registerAudioSessionDeActivateListener);

  when(mockIsActivated)().afterReturn(false);
  when(mockSetAudioSessionStrategy)(ArgumentMatchers.any).afterReturnNothing();
  when(mockSetActivateCallback)(ArgumentMatchers.any).afterReturnNothing();
  when(mockSetAudioSessionDeActivateCallback)(ArgumentMatchers.any).afterReturnNothing();
  when(mockActivateAudioSession)().afterReturnNothing();
  when(mockRegisterAudioSessionDeActivateListener)().afterReturnNothing();

  audioSessionController.setAudioSession(audioSessionParams);

  when(mockIsActivated)().afterReturn(true);
  audioSessionController.setAudioSession(audioSessionParams);

  mocker.ignoreMock(audioSessionController, audioSessionController.getIsActivated);
  mocker.ignoreMock(audioSessionController, audioSessionController.setAudioSessionStrategy);
  mocker.ignoreMock(audioSessionController, audioSessionController.setActivateCallback);
  mocker.ignoreMock(audioSessionController, audioSessionController.setAudioSessionDeActivateCallback);
  mocker.ignoreMock(audioSessionController, audioSessionController.activateAudioSession);
  mocker.ignoreMock(audioSessionController, audioSessionController.registerAudioSessionDeActivateListener);
}

function cancelAudioSession() {
  if (audioSessionController == undefined) {
    return;
  }
  let audioSessionParams: AudioSessionParams = {
    audioSessionStrategy: AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS,
    activateCallback: () => {
    },
    audioSessionDeActivateCallback: (event: audio.AudioSessionDeactivatedEvent): void => {
    }
  }

  let mocker: MockKit = new MockKit();
  let mockIsActivated: Function = mocker.mockFunc(audioSessionController, audioSessionController.getIsActivated);
  let mockSetDeActivateCallback: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.setDeActivateCallback);
  let mockDeActivateAudioSession: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.deActivateAudioSession);
  let mockDeRegisterAudioSessionDeActivateListener: Function =
    mocker.mockFunc(audioSessionController, audioSessionController.deRegisterAudioSessionDeActivateListener);

  when(mockIsActivated)([]).afterReturn(false);
  when(mockSetDeActivateCallback)([ArgumentMatchers.anyFunction]).afterReturnNothing();
  when(mockDeActivateAudioSession)([]).afterReturnNothing();
  when(mockDeRegisterAudioSessionDeActivateListener)([]).afterReturnNothing();
  audioSessionController.cancelAudioSession(audioSessionParams);

  when(mockIsActivated)().afterReturn(true);
  audioSessionController.cancelAudioSession(audioSessionParams);

  mocker.ignoreMock(audioSessionController, audioSessionController.getIsActivated);
  mocker.ignoreMock(audioSessionController, audioSessionController.setDeActivateCallback);
  mocker.ignoreMock(audioSessionController, audioSessionController.deActivateAudioSession);
  mocker.ignoreMock(audioSessionController, audioSessionController.deRegisterAudioSessionDeActivateListener);
}