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
import lazy { PhotoBrowserBaseState } from './PhotoBrowserBaseState';
import lazy { PhotoBrowserExitAnimatingState } from './PhotoBrowserExitAnimatingState';
import lazy { PhotoBrowserStateMachine } from './PhotoBrowserStateMachine';
/* instrument ignore file */
const TAG: string = 'PBBackState';

export class PhotoBrowserBackState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.BACK_STATE;
  private static readonly instance: PhotoBrowserBackState = new PhotoBrowserBackState();

  constructor() {
    super();
  }

  public static getInstance(): PhotoBrowserBackState {
    return PhotoBrowserBackState.instance;
  }

  public onEnter(listeners: IStateChangeListener[]): void {
    let count: number = 0;
    while (count < listeners.length) {
      listeners[count]?.onBackEndAnim?.();
      count += 1;
    }
  }

  public processExitAnimationStartEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processExitAnimationStartEvent`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserExitAnimatingState.getInstance());
  }

  public processPhotoitemAppearEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    Log.info(TAG, `processPhotoitemAppear`);
    photoBrowserStateMachine.setCurrentState(PhotoBrowserExitAnimatingState.getInstance());
  }

}