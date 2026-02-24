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

import lazy { PhotoBrowserStateMachine } from './PhotoBrowserStateMachine';
import lazy { PhotoBrowserBaseState } from './PhotoBrowserBaseState';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { PhotoBrowserSwiperGestureState } from './PhotoBrowserSwiperGestureState';
import lazy { PhotoBrowserBackState } from './PhotoBrowserBackState';
import lazy { PhotoBrowserInitState } from './PhotoBrowserInitState';
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';

const TAG: string = 'PBStableState';

export class PhotoBrowserStableState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.STABLE_STATE;
  private static readonly instance: PhotoBrowserStableState = new PhotoBrowserStableState();

  public static getInstance(): PhotoBrowserStableState {
    return PhotoBrowserStableState.instance;
  }

  public onEnter(listeners: IStateChangeListener[]): void {
    listeners.forEach(listener => {
      listener.onStable();
    });
  }

  public processSwiperGestureEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void {
    Log.debug(TAG, `processSwiperGestureEvent, index = ${index}, extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserSwiperGestureState.getInstance());
  }

  public processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserDeleteAnimatingState.getInstance());
  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processBackEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserBackState.getInstance());
  }

  public processExitAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserInitState.getInstance());
  }

  public processHeic2JPGEvent(targetIndex: number, isAnimating: boolean,
    controller?: SwiperController | undefined): void {
    Log.info(TAG, `processHeic2JPGEvent, targetIndex:${targetIndex}, isAnimating:${isAnimating}`);
    Heic2JPGManagerAccess.getInstance().setJumpPlan(targetIndex, isAnimating, controller);
  }
}

