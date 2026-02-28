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

export enum PhotoBrowserStateName {
  INIT_STATE = 'Init_State', //起始状态
  ENTER_ANIMATING_STATE = 'Enter_Animating_State', //进入大图一镜到底动效状态
  EXIT_ANIMATING_STATE = 'Exit_Animating_State', //退出大图一镜到底动效状态
  STABLE_STATE = 'Stable_State', //静止稳定状态
  SWIPING_STATE = 'Swiping_State', //跟手左右滑动状态
  SWIPER_ANIMATING_STATE = 'Swiper_Animating_State', //松手Swiper左右滑动动效状态
  EDIT_STATE = 'Edit_State', //进入编辑态
  DELETE_ANIMATING_STATE = 'Delete_Animating_State', //删除动效状态
  PULLING_DOWN_STATE = 'Pulling_Down_State', //下拉跟手状态
  BACK_STATE = 'Back_State' // 返回状态
}

export interface IStateChangeListener {
  onCurrentIndexChange(currentIndex: number): void;
  onTargetIndexChange(targetIndex: number): void;
  saveTargetItem?(targetIndex: number): void;
  onTargetIndexAboutToChange?(targetIndex: number): void;
  onPropertiesStateChange(isShowProperties: boolean): void;
  onDeleteStart(): void;
  onStable(): void;
  onGestureStateChange?(isEnd: boolean): void;
  onEnterStartAnim?(): void;
  onEnterEndAnim?(): void;
  onExitStartAnim?(): void;
  onExitEndAnim?(): void;
  onBackEndAnim?(): void;
  onPhotoitemAppear?(): void;
  onSwiperAnimEnd?(): void;
  initialAnim?(): void;
  hideEnterAnimating?(): void;
  onThumbnailViewShow?(): void;
}

export class ViewStateChangeListener implements IStateChangeListener {
  public onCurrentIndexChange: (currentIndex: number) => void = () => {
  };
  public onTargetIndexChange: (targetIndex: number) => void = () => {
  };
  public onPropertiesStateChange: (isShowProperties: boolean) => void = (isShowProperties: boolean) => {};
  public onDeleteStart: () => void = () => {};
  public onStable: () => void = () => {};
  public onGestureStateChange: (isEnd: boolean) => void = () => {};

  constructor(onCurrentIndexChange: (currentIndex: number) => void,
    onTargetIndexChange: (targetIndex: number) => void) {
    this.onCurrentIndexChange = onCurrentIndexChange;
    this.onTargetIndexChange = onTargetIndexChange;
  }
}

export interface IPhotoBrowserState {
  stateName: PhotoBrowserStateName;
  processEnterAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processEnterAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processSetCurrentMediaEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, mediaUri?: string): void;
  processSwiperGestureEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void;
  processSwiperAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    targetIndex: number, extraInfo: SwiperAnimationEvent): void;
  processSwiperAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number,
    extraInfo: SwiperAnimationEvent): void;
  processSwiperIndexChangeEvent(photoBrowserStateMachine: PhotoBrowserStateMachine, index: number): void;
  processDeleteStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processDeleteEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processExitAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processExitAnimationEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processBackEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
  processPhotoitemAppearEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void;
}