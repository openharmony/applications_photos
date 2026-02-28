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

import lazy { IStateChangeListener } from '../statemachine/IPhotoBrowserState';
import lazy { PhotoBrowserStateMachine } from '../statemachine/PhotoBrowserStateMachine';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'common_MovingPhotoComponentVM';

@Observed
export class MovingPhotoComponentVM implements IStateChangeListener {
  private stateMachine: PhotoBrowserStateMachine;

  /**
   * SwiperView单属性刷新控制器
   */
  constructor(stateMachine: PhotoBrowserStateMachine, onCurrentIndexChange: (currentIndex: number) => void,
    onTargetIndexChange: (targetIndex: number) => void) {
    this.stateMachine = stateMachine;
    this.onCurrentIndexChange = onCurrentIndexChange;
    this.onTargetIndexChange = onTargetIndexChange;
  }

  public onCreate(): void {
    this.stateMachine.registerStateChangeListener(this, true);
  }

  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
  }

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  public getTargetIndex(): number {
    return this.stateMachine.getTargetIndex();
  }

  public onCurrentIndexChange: (currentIndex: number) => void = () => {
  };
  public onTargetIndexChange: (targetIndex: number) => void = () => {
  };

  onPropertiesStateChange(isShowProperties: boolean): void {
    Log.info(TAG, 'run onPropertiesStateChange');
  }

  onDeleteStart(): void {
    Log.info(TAG, 'run onDeleteStart');
  }

  onStable(): void {
    Log.info(TAG, 'run onStable');
  }

  public onGestureStateChange = (isEnd: boolean): void => {
  }
}
