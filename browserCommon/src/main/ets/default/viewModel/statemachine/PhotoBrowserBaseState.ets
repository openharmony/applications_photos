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
import lazy { IPhotoBrowserState, IStateChangeListener, PhotoBrowserStateName } from './IPhotoBrowserState';
import lazy { PhotoBrowserDeleteAnimatingState } from './PhotoBrowserDeleteAnimatingState';
import lazy { PhotoBrowserStateMachine } from './PhotoBrowserStateMachine';


export abstract class PhotoBrowserBaseState implements IPhotoBrowserState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.INIT_STATE;

  constructor() {
  }

  public onEnter(listeners: IStateChangeListener[]): void {
  }

  public onLeave(listeners: IStateChangeListener[]): void {
  }

  public isRunningAnimation(): boolean {
    return false;
  }

  public isOnSwiperAnimation(): boolean {
    return false;
  }

  public isOnSwiperGesture(): boolean {
    return false;
  }

  public isOnTouch(): boolean {
    return false;
  }


  public processEnterAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processEnterAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processSetCurrentMediaEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, mediaUri?: string): void {

  }

  public processSwiperGestureEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void {

  }

  public processSwiperAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    targetIndex: number, extraInfo: SwiperAnimationEvent): void {

  }

  public processSwiperAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void {

  }

  public processSwiperIndexChangeEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number): void {

  }

  public processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processDeleteEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processExitAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processExitAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processPhotoitemAppearEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processExitNoPhotosEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {

  }

  public processHeic2JPGEvent(targetIndex: number, isAnimating: boolean, controller?: SwiperController) {

  }

  public processInitialAnimationEvent(listeners: IStateChangeListener[]): void {

  }

  public processDoubleTapAllowanceEvent(): boolean {
    return true;
  }

  public processSwiperGestureAllowanceEvent(): boolean {
    return true;
  }

  public processHideThumbnailEvent(listeners: IStateChangeListener[]): void {

  }

  public processThumnailViewShowEvent(listeners: IStateChangeListener[]): void {

  }
}