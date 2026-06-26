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

import lazy { PhotoBrowserBaseState } from './PhotoBrowserBaseState';
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserStateMachine } from './PhotoBrowserStateMachine';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PhotoBrowserInitState } from './PhotoBrowserInitState';

const TAG: string = 'PBExitAnimatingState';

export class PhotoBrowserExitAnimatingState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.EXIT_ANIMATING_STATE;
  private static readonly instance: PhotoBrowserExitAnimatingState = new PhotoBrowserExitAnimatingState();

  public onEnter(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onExitStartAnim?.();
      count += 1;
    }
  }

  public onLeave(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onExitEndAnim?.();
      count += 1;
    }
  }

  public static getInstance(): PhotoBrowserExitAnimatingState {
    return PhotoBrowserExitAnimatingState.instance;
  }

  public isRunningAnimation(): boolean {
    return true;
  }

  public processExitAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processExitAnimationEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserInitState.getInstance());
  }

  public processDoubleTapAllowanceEvent(): boolean {
    Log.info(TAG, `processDoubleTapAllowanceEvent`);
    return false;
  }

  public processSwiperGestureAllowanceEvent(): boolean {
    Log.info(TAG, `processSwiperGestureAllowanceEvent`);
    return false;
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
