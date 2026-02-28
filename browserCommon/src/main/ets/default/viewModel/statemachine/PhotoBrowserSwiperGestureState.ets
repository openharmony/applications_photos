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
import lazy { PhotoBrowserSwiperAnimatingState } from './PhotoBrowserSwiperAnimatingState';
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { PhotoBrowserBackState } from './PhotoBrowserBackState';

const TAG: string = 'PhotoBrowserSwiperGestureState';

export class PhotoBrowserSwiperGestureState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.SWIPING_STATE;
  private static readonly instance: PhotoBrowserSwiperGestureState = new PhotoBrowserSwiperGestureState();

  public static getInstance(): PhotoBrowserSwiperGestureState {
    return PhotoBrowserSwiperGestureState.instance;
  }

  public isOnSwiperGesture(): boolean {
    return true;
  }

  public isOnSwiperAnimation(): boolean {
    return true;
  }

  public onEnter(listeners: IStateChangeListener[]): void {
    listeners.forEach(listener => {
      if (listener.onGestureStateChange) {
        listener.onGestureStateChange(false);
      }
    });
  }

  public onLeave(listeners: IStateChangeListener[]): void {
    listeners.forEach(listener => {
      if (listener.onGestureStateChange) {
        listener.onGestureStateChange(true);
      }
    });
  }

  /**
   * 晋档
   * @returns
   */
  public isOnTouch(): boolean {
    return true;
  }

  public processSwiperGestureEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
      extraInfo: SwiperAnimationEvent): void {
    Log.debug(TAG, `processSwiperGestureEvent, index = ${index}, extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserSwiperGestureState.getInstance());
  }

  public processSwiperAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    Log.info(TAG, `processSwiperAnimationStartEvent, index = ${index}, targetIndex = ${targetIndex},
      extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    photoBrowserStateMachine.setTargetIndex(targetIndex);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserSwiperAnimatingState.getInstance());
  }

  public processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserDeleteAnimatingState.getInstance());
  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processBackEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserBackState.getInstance());
  }
}


export { PhotoBrowserSwiperAnimatingState };
