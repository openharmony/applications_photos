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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserBackState } from './PhotoBrowserBackState';
import lazy { PhotoBrowserBaseState } from './PhotoBrowserBaseState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { PhotoBrowserEnterAnimatingState } from './PhotoBrowserEnterAnimatingState';
import lazy { PhotoBrowserStateMachine } from './PhotoBrowserStateMachine';

const TAG: string = 'PBInitState';

export class PhotoBrowserInitState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.INIT_STATE;
  private static readonly instance: PhotoBrowserInitState = new PhotoBrowserInitState();

  constructor() {
    super();
  }

  public static getInstance(): PhotoBrowserInitState {
    return PhotoBrowserInitState.instance;
  }

  public processEnterAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processEnterAnimationStartEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserEnterAnimatingState.getInstance());
  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processBackEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserBackState.getInstance());
  }

  public processSetCurrentMediaEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, mediaUri?: string): void {
    Log.info(TAG, `processSetCurrentMediaEvent, mediaUri: ${mediaUri}`);
    if (mediaUri === undefined) {
      return;
    }
  }

  public processPhotoitemAppearEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processPhotoitemAppearEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserEnterAnimatingState.getInstance());
  }

  public processInitialAnimationEvent(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.initialAnim?.();
      count += 1;
    }
  }

  public processThumnailViewShowEvent(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onThumbnailViewShow?.();
      count += 1;
    }
  }
}