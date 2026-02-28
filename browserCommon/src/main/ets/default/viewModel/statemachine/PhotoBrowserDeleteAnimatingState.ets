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
import lazy { PhotoBrowserStableState } from './PhotoBrowserStableState';

const TAG: string = 'PBDeleteAnimatingState';

export class PhotoBrowserDeleteAnimatingState extends PhotoBrowserBaseState {
  public stateName: PhotoBrowserStateName = PhotoBrowserStateName.DELETE_ANIMATING_STATE;
  private static readonly instance: PhotoBrowserDeleteAnimatingState = new PhotoBrowserDeleteAnimatingState();

  public static getInstance(): PhotoBrowserDeleteAnimatingState {
    return PhotoBrowserDeleteAnimatingState.instance;
  }

  public onEnter(listeners: IStateChangeListener[]): void {
    listeners.forEach(listener => {
      listener.onDeleteStart();
    });
  }

  public processDeleteEndEvent(photoBrowserStateMachine: PhotoBrowserStateMachine): void {
    photoBrowserStateMachine.setCurrentState(PhotoBrowserStableState.getInstance());
  }


}

