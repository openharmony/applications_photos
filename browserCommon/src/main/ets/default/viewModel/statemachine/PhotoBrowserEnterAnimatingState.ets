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
import lazy { PhotoBrowserStableState } from './PhotoBrowserStableState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserBackState } from './PhotoBrowserBackState';
import lazy { PhotoBrowserSwiperGestureState } from './PhotoBrowserSwiperGestureState';

const TAG: string = 'PBEnterAnimatingState';

export class PhotoBrowserEnterAnimatingState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.ENTER_ANIMATING_STATE;
  private static readonly instance: PhotoBrowserEnterAnimatingState = new PhotoBrowserEnterAnimatingState();

  public static getInstance(): PhotoBrowserEnterAnimatingState {
    return PhotoBrowserEnterAnimatingState.instance;
  }

  public onEnter(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onEnterStartAnim?.();
      count += 1;
    }
  }

  public onLeave(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onEnterEndAnim?.();
      count += 1;
    }
  }

  public isRunningAnimation(): boolean {
    return true;
  }

  public processEnterAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processEnterAnimationEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserStableState.getInstance());
  }

  public processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserDeleteAnimatingState.getInstance());
  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processBackEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserBackState.getInstance());
  }

  // 一镜到底入场时可以左右滑动
  public processSwiperGestureEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void {
    Log.debug(TAG, `processSwiperGestureEvent, index = ${index}, extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserSwiperGestureState.getInstance());
  }

  public processInitialAnimationEvent(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.initialAnim?.();
      count += 1;
    }
  }

}

