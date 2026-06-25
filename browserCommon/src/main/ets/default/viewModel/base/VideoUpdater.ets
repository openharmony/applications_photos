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
import lazy { PhotoBrowserStateMachine } from '../statemachine/PhotoBrowserStateMachine';
import lazy { ItemStackUpdater } from './ItemStackUpdater'

export class VideoUpdater extends ItemStackUpdater {
  private stateMachine: PhotoBrowserStateMachine;
  constructor(stateMachine: PhotoBrowserStateMachine) {
    super();
    this.stateMachine = stateMachine;
  }
  public updateStackScale(isPropertiesShow: boolean, isOnlyPropertiesShow: boolean, useImage: boolean,
    imageSlideScale: number, geometryScale: number): void {

    if (isPropertiesShow && useImage) {
      this.updateScale({ x: imageSlideScale, y: imageSlideScale });
      return;
    }

    this.updateScale({ x: geometryScale, y: geometryScale });
  }
}