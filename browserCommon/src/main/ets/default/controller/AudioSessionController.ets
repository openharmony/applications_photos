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
import lazy { audio } from '@kit.AudioKit';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'audioSessionCtrl';

export enum AudioSessionStrategy {
  CONCURRENCY_DEFAULT = 0,
  CONCURRENCY_MIX_WITH_OTHERS = 1,
  CONCURRENCY_DUCK_OTHERS = 2,
  CONCURRENCY_PAUSE_OTHERS = 3,
}

export interface AudioSessionParams {
  audioSessionStrategy?: AudioSessionStrategy;
  activateCallback?: () => void;
  deActivateCallback?: () => void;
  audioSessionDeActivateCallback?: (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent) => void;
}

export class AudioSessionController {
  private static audioSessionController: AudioSessionController | undefined = undefined;
  private audioSessionStrategy?: AudioSessionStrategy;
  private audioSessionManager: audio.AudioSessionManager = this.getAudioSessionManager();
  private activateCallback: () => void = (): void => {
    Log.info(TAG, 'default activateCallback. do nothing');
  };
  private deActivateCallback: () => void = (): void => {
    Log.info(TAG, 'default deActivateCallback. do nothing');
  };
  private audioSessionDeActivateCallback: (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent) => void =
    (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent): void => {
      Log.info(TAG, `default audioSessionDeActivateCallback, reason: ${audioSessionDeactivatedEvent.reason}`);
    };

  private constructor() {
  }

  public static getInstance(): AudioSessionController {
    if (AudioSessionController.audioSessionController) {
      return AudioSessionController.audioSessionController;
    }
    AudioSessionController.audioSessionController = AppStorage.get<AudioSessionController>('AudioSessionController');
    if (AudioSessionController.audioSessionController) {
      return AudioSessionController.audioSessionController;
    }
    AudioSessionController.audioSessionController = new AudioSessionController();
    AppStorage.setOrCreate('AudioSessionController', AudioSessionController.audioSessionController);
    return AudioSessionController.audioSessionController;
  }

  private getAudioSessionManager(): audio.AudioSessionManager {
    return audio.getAudioManager().getSessionManager();
  }

  public getAudioSessionStrategy(): AudioSessionStrategy | undefined {
    return this.audioSessionStrategy;
  }

  public setAudioSessionStrategy(audioSessionStrategy?: AudioSessionStrategy): void {
    this.audioSessionStrategy = audioSessionStrategy;
  }

  public setActivateCallback(activateCallback?: () => void): void {
    if (activateCallback) {
      this.activateCallback = activateCallback;
    }
  }

  public getActivateCallback(): () => void {
    return this.activateCallback;
  }

  public setDeActivateCallback(deActivateCallback?: () => void): void {
    if (deActivateCallback) {
      this.deActivateCallback = deActivateCallback;
    }
  }

  public getDeActivateCallback(): () => void {
    return this.deActivateCallback;
  }

  public setAudioSessionDeActivateCallback(
    audioSessionDeActivateCallback?: (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent) => void
  ): void {
    if (audioSessionDeActivateCallback) {
      this.audioSessionDeActivateCallback = audioSessionDeActivateCallback;
    }
  }

  public getAudioSessionDeActivateCallback():
    (audioSessionDeactivatedEvent: audio.AudioSessionDeactivatedEvent) => void {
    return this.audioSessionDeActivateCallback;
  }

  private transformStrategy(strategy: AudioSessionStrategy): audio.AudioConcurrencyMode {
    switch (strategy) {
      case AudioSessionStrategy.CONCURRENCY_DEFAULT:
        return audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;
      case AudioSessionStrategy.CONCURRENCY_MIX_WITH_OTHERS:
        return audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS;
      case AudioSessionStrategy.CONCURRENCY_DUCK_OTHERS:
        return audio.AudioConcurrencyMode.CONCURRENCY_DUCK_OTHERS;
      case AudioSessionStrategy.CONCURRENCY_PAUSE_OTHERS:
        return audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS;
      default:
        return audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;
    }
  }

  /* instrument ignore next */
  public activateAudioSession(): void {
    this.audioSessionManager.activateAudioSession({
      concurrencyMode: this.transformStrategy(this.getAudioSessionStrategy()),
    }).then((): void => {
      this.activateCallback();
    }).catch((error: BusinessError) => {
      Log.error(TAG, `activateAudioSession error. ${error.code} ${error.message}`);
    });
  }

  public getIsActivated(): boolean {
    return this.audioSessionManager.isAudioSessionActivated();
  }

  /* instrument ignore next */
  public deActivateAudioSession(): void {
    this.audioSessionManager.deactivateAudioSession().then((): void => {
      this.deActivateCallback();
    }).catch((error: BusinessError) => {
      Log.error(TAG, `deActivateAudioSession error. ${error.code} ${error.message}`);
    });
  }

  /* instrument ignore next */
  public registerAudioSessionDeActivateListener(): void {
    try {
      this.audioSessionManager.on('audioSessionDeactivated', this.audioSessionDeActivateCallback);
    } catch (error) {
      Log.error(TAG, `registerAudioSessionDeActivateListener error, ${error?.code} ${error?.message}`);
    }
  }

  /* instrument ignore next */
  public deRegisterAudioSessionDeActivateListener(): void {
    try {
      this.audioSessionManager.off('audioSessionDeactivated');
    } catch (error) {
      Log.error(TAG, `deRegisterAudioSessionDeActivateListener error, ${error?.code} ${error?.message}`);
    }
  }

  public setAudioSession(audioSessionParams: AudioSessionParams): void {
    if (this.audioSessionStrategy !== audioSessionParams.audioSessionStrategy) {
      Log.info(TAG, `setAudioSession ${this.audioSessionStrategy} -> ${audioSessionParams.audioSessionStrategy}`);
      this.setAudioSessionStrategy(audioSessionParams.audioSessionStrategy);
      this.setActivateCallback(audioSessionParams.activateCallback);
      this.setAudioSessionDeActivateCallback(audioSessionParams.audioSessionDeActivateCallback);
      this.activateAudioSession();
      this.registerAudioSessionDeActivateListener();
    }
  }

  public cancelAudioSession(audioSessionParams: AudioSessionParams): void {
    Log.info(TAG, `cancelAudioSession ${this.audioSessionStrategy}`);
    if (this.audioSessionStrategy !== undefined) {
      this.setAudioSessionStrategy();
      this.setDeActivateCallback(audioSessionParams.deActivateCallback);
      this.deActivateAudioSession();
      this.deRegisterAudioSessionDeActivateListener();
    } else {
      audioSessionParams.deActivateCallback?.();
    }
  }
}