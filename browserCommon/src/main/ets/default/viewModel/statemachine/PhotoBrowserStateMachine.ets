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
import lazy { IStateChangeListener } from './IPhotoBrowserState';
import lazy { PhotoBrowserBaseState } from './PhotoBrowserBaseState';
import lazy { PhotoBrowserInitState } from './PhotoBrowserInitState';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';

const TAG: string = 'PBStateMachine';

@Observed
export class PhotoBrowserStateMachine {
  private browserControllerId: number = 0;
  private currentState: PhotoBrowserBaseState;
  private listeners: IStateChangeListener[] = [];

  private currentIndex: number = -1; //大图Swiper当前index
  private currentMediaUri: string = '';
  private targetIndex: number = 0; //大图Swiper目标index，在Swiper左右滑动，删除等场景非稳定态时，和currentIndex值不同

  // 详情显示状态
  private showPropertiesShow: boolean = false;

  // 显示人像详情弹窗
  private showDetailPortraitTips: boolean = false;

  constructor() {
    this.currentState = PhotoBrowserInitState.getInstance();
    Log.info(TAG, `constructor currentState = ${this.currentState.stateName}`);
  }

  //public method begin
  public registerStateChangeListener(stateChangeListener: IStateChangeListener,
    isHighPriority: boolean = false): void {
    if (this.listeners.indexOf(stateChangeListener) >= 0) {
      return;
    }
    if (isHighPriority) {
      this.listeners.unshift(stateChangeListener);
      return;
    }
    this.listeners.push(stateChangeListener);
  }

  public unregisterStateChangeListener(stateChangeListener: IStateChangeListener): void {
    const listenerIndex: number = this.listeners.indexOf(stateChangeListener);
    if (listenerIndex >= 0) {
      this.listeners.splice(listenerIndex, 1);
    }
  }

  public getBrowserControllerId(): number {
    return this.browserControllerId;
  }

  public getCurrentIndex(): number {
    return this.currentIndex;
  }

  public getTargetIndex(): number {
    return this.targetIndex;
  }

  public getCurrentMediaUri(): string {
    Log.info(TAG, `getCurrentMediaUri currentMediaUri = ${this.currentMediaUri}`);
    return this.currentMediaUri;
  }

  public isPropertiesShow(): boolean {
    return this.showPropertiesShow;
  }

  public isRunningAnimation(): boolean {
    return this.currentState.isRunningAnimation();
  }

  /**
   * 是否正在执行大图滑动动效
   * @param index
   */
  public isOnSwiperAnimation(): boolean {
    return this.currentState.isOnSwiperAnimation();
  }

  /**
   * 大图Swiper是否执行Gesture事件
   * @param index
   */
  public isTouching(): boolean {
    return this.currentState.isOnTouch();
  }

  public setBrowserControllerId(browserControllerId: number): void {
    this.browserControllerId = browserControllerId;
  }

  public setCurrentIndex(index: number): void {
    Log.info(TAG, `setCurrentIndex index = ${index}, this.currentIndex = ${this.currentIndex}`);
    if (this.currentIndex === index) {
      return;
    }
    this.currentIndex = index;
    this.notifyCurrentIndexChange(this.currentIndex);
    // 临时添加，不允许再增加该广播的监听
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.TMP_CURRENT_INDEX_CHANGE);
  }

  public setTargetIndex(index: number): void {
    Log.info(TAG, `setTargetIndex index = ${index}, this.targetIndex = ${this.targetIndex}`);
    if (this.targetIndex === index) {
      return;
    }
    this.notifyTargetIndexAboutToChange(this.targetIndex);
    this.targetIndex = index;
    this.notifyTargetIndexChange(this.targetIndex);
  }

  public setPropertiesState(isShowPropertiesShow: boolean): void {
    Log.info(TAG, `setShowProperties old: ${isShowPropertiesShow}`);
    if (this.showPropertiesShow === isShowPropertiesShow) {
      return;
    }
    this.showPropertiesShow = isShowPropertiesShow;
    this.notifyPropertiesStateChange(isShowPropertiesShow);
  }

  public setCurrentMediaUri(currentMediaUri: string): void {
    Log.info(TAG, `setCurrentMediaUri currentaMediaUri = ${currentMediaUri}`);
    this.currentMediaUri = currentMediaUri;
  }

  public setCurrentState(currentState: PhotoBrowserBaseState): void {
    Log.info(TAG, `setCurrentState currentState = ${this.currentState.stateName},
      newState = ${currentState.stateName}`);
    if (currentState === this.currentState) {
      Log.info(TAG, `setCurrentState currentState is alreay at ${currentState.stateName}`);
      return;
    }
    this.currentState.onLeave(this.listeners);
    this.currentState = currentState;
    this.currentState.onEnter(this.listeners);
  }

  public getCurrentState(): PhotoBrowserBaseState | undefined {
    Log.info(TAG, `getCurrentState currentState = ${this.currentState.stateName}`);
    return this.currentState;
  }

  public setIsShowDetailPortraitTips(showDetailPortraitTips: boolean): void {
    this.showDetailPortraitTips = showDetailPortraitTips;
  }

  public isShowDetailPortraitTips(): boolean {
    Log.info(TAG, `isShowDetailPortraitTips = ${this.showDetailPortraitTips}`);
    return this.showDetailPortraitTips;
  }

  public processEnterAnimationStartEvent(): void {
    Log.info(TAG, `processEnterAnimationStartEvent, currentState = ${this.currentState.stateName}`);
    this.currentState.processEnterAnimationStartEvent(this);
  }

  public processEnterAnimationEndEvent(): void {
    Log.info(TAG, `processEnterAnimationEndEvent, currentState = ${this.currentState.stateName}`);
    this.currentState.processEnterAnimationEndEvent(this);
  }

  public processSetCurrentMediaEvent(mediaUri?: string): void {
    Log.info(TAG, `processSetCurrentMediaEvent, currentState = ${this.currentState.stateName},
      mediaUri = ${mediaUri}`);
    this.currentState.processSetCurrentMediaEvent(this, mediaUri);
  }

  public processSwiperGestureEvent(index: number, extraInfo: SwiperAnimationEvent): void {
    Log.debug(TAG, `processSwiperGestureEvent, currentState = ${this.currentState.stateName}, index = ${index},
      extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    this.currentState.processSwiperGestureEvent(this, index, extraInfo);
  }

  public processSwiperAnimationStartEvent(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    Log.info(TAG, `processSwiperAnimationStartEvent, currentState = ${this.currentState.stateName}, index = ${index},
      targetIndex = ${targetIndex}, extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    this.currentState.processSwiperAnimationStartEvent(this, index, targetIndex, extraInfo);
  }

  public processSwiperAnimationEndEvent(index: number, extraInfo: SwiperAnimationEvent): void {
    Log.info(TAG, `processSwiperAnimationEndEvent, currentState = ${this.currentState.stateName}, index = ${index},
      extraInfo.currentOffset = ${extraInfo.currentOffset}`);
    this.currentState.processSwiperAnimationEndEvent(this, index, extraInfo);
  }

  public processSwiperIndexChangeEvent(index: number): void {
    Log.info(TAG, `processSwiperIndexChange, currentState = ${this.currentState.stateName}, index = ${index}`);
    this.currentState.processSwiperIndexChangeEvent(this, index);
  }

  public processDeleteStartEvent(): void {
    Log.info(TAG, `processDeleteStartEvent, currentState = ${this.currentState.stateName}`);
    this.currentState.processDeleteStartEvent(this);
  }

  public processDeleteEndEvent(): void {
    Log.info(TAG, `processDeleteEndEvent, currentState = ${this.currentState.stateName}`);
    this.currentState.processDeleteEndEvent(this);
  }

  public processExitAnimationStartEvent(): void {
    Log.info(TAG, `processExitAnimationStartEvent, currentState = ${this.currentState?.stateName}`);
    this.currentState?.processExitAnimationStartEvent(this);
  }

  public processBackEndEvent(): void {
    Log.info(TAG, `processBackEndEvent, currentState = ${this.currentState?.stateName}`);
    this.currentState?.processBackEndEvent(this);
  }

  public processPhotoitemAppearEvent(): void {
    Log.info(TAG, `processPhotoitemAppearEvent, currentState = ${this.currentState?.stateName}`);
    this.currentState?.processPhotoitemAppearEvent(this);
  }


  public processExitAnimationEndEvent(): void {
    Log.info(TAG, `processExitAnimationEndEvent, currentState = ${this.currentState?.stateName}`);
    this.currentState?.processExitAnimationEndEvent(this);
  }

  //private method begin
  private notifyCurrentIndexChange(currentIndex: number): void {
    Log.info(TAG, `notifyCurrentIndexChange currentIndex = ${currentIndex}`);
    this.listeners.forEach(listener => {
      listener.onCurrentIndexChange(currentIndex);
    });
  }

  private notifyTargetIndexChange(targetIndex: number): void {
    Log.info(TAG, `notifyTargetIndexChange targetIndex = ${targetIndex}`);
    this.listeners.forEach(listener => {
      listener.onTargetIndexChange(targetIndex);
    });
  }

  private notifyTargetIndexAboutToChange(targetIndex: number): void {
    Log.info(TAG, `notifyTargetIndexAboutToChange targetIndex = ${targetIndex}`);
    this.listeners.forEach(listener => {
      listener?.onTargetIndexAboutToChange?.(targetIndex);
    });
  }

  private notifyPropertiesStateChange(isShowPropertiesShow: boolean): void {
    this.listeners.forEach(listener => {
      listener.onPropertiesStateChange(isShowPropertiesShow);
    });
  }

  public processHeic2JPGEvent(targetIndex: number, isAnimating: boolean,
    controller?: SwiperController | undefined): void {
    Log.info(TAG, `processHeic2JPGEvent, currentState = ${this.currentState?.stateName}`);
    this.currentState?.processHeic2JPGEvent(targetIndex, isAnimating, controller);
  }

  public processInitialAnimationEvent(): void {
    Log.info(TAG, `processInitialAnimationEvent, currentState = ${this.currentState?.stateName}`)
    this.currentState?.processInitialAnimationEvent(this.listeners);
  }

  public processDoubleTapAllowanceEvent(): boolean {
    Log.info(TAG, `processDoubleTapAllowanceEvent, currentState = ${this.currentState?.stateName}`)
    return this.currentState?.processDoubleTapAllowanceEvent() ?? false;
  }

  public processSwiperGestureAllowanceEvent(): boolean {
    Log.info(TAG, `processSwiperGestureAllowanceEvent, currentState = ${this.currentState?.stateName}`)
    return this.currentState?.processSwiperGestureAllowanceEvent() ?? false;
  }

  public processHideEnterAnimatingEvent(): void {
    Log.info(TAG, `processHideEnterAnimatingEvent, currentState = ${this.currentState?.stateName}`)
    let count: number = 0;
    while (count < this.listeners.length) {
      this.listeners[count]?.hideEnterAnimating?.();
      count += 1;
    }
  }

  public processThumnailViewShowEvent(): void {
    Log.info(TAG, `processThumnailViewShowEvent, currentState = ${this.currentState?.stateName}`)
    this.currentState?.processThumnailViewShowEvent(this.listeners);
  }
}