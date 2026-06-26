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
import lazy { IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { PhotoBrowserBackState } from './PhotoBrowserBackState';

const TAG: string = 'PBSwiperAnimatingState';

/**
 * 标识大图Swiper滑动动效执行状态
 */
export class PhotoBrowserSwiperAnimatingState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.SWIPER_ANIMATING_STATE;
  private static readonly instance: PhotoBrowserSwiperAnimatingState = new PhotoBrowserSwiperAnimatingState();

  public static getInstance(): PhotoBrowserSwiperAnimatingState {
    return PhotoBrowserSwiperAnimatingState.instance;
  }

  /**
   * 滑动状态入场事件
   * @param listeners
   */
  public onEnter(listeners: IStateChangeListener[]): void {}

  /**
   * 滑动动效离场事件
   * @param listeners
   */
  public onLeave(listeners: IStateChangeListener[]): void {
    listeners.forEach(listener => {
      listener.onSwiperAnimEnd?.();
    });
  }

  public isOnSwiperAnimation(): boolean {
    return true;
  }

  /**
   * onGesture贯穿onGesture和onAnimationStart
   * @returns
   */
  public isOnSwiperGesture(): boolean {
    return true;
  }

  processSwiperIndexChangeEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number): void {
    Log.info(TAG, `processSwiperIndexChange, index = ${index}`);
    photoBrowserStateMachine.setCurrentIndex(index);
    photoBrowserStateMachine.setTargetIndex(index);
  }

  public processSwiperAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processSwiperAnimationStartEvent start`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserSwiperAnimatingState.getInstance());
  }

  public processSwiperAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void {
    Log.info(TAG, `processSwiperAnimationEndEvent, index = ${index},
      extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserStableState.getInstance());
  }

  public processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserDeleteAnimatingState.getInstance());
  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processBackEndEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserBackState.getInstance());
  }
}
