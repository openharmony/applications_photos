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
import lazy { Remain } from '../../model/browser/photo/const/Type';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Log } from '../../utils/Log';

const TAG: string = 'Previewer';

/* instrument ignore file */
export namespace Previewer {
  export function scrollFrameReducer(offset: number, state: ScrollState): Remain | undefined {
    const OFFSET_THRESHOLD: number = 50;
    const OFFSET_LIMIT: number = -20;

    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      let offsetRemain: number = offset;
      if (offset > OFFSET_THRESHOLD) {
        Log.info(TAG, `offset > OFFSET_THRESHOLD, offset: ${offset}, offsetRemain: ${OFFSET_LIMIT}`);
        return { offsetRemain: OFFSET_LIMIT }
      }
      if (offset < -OFFSET_THRESHOLD) {
        Log.info(TAG, `offset < -OFFSET_THRESHOLD, offset: ${offset}, offsetRemain: ${-OFFSET_LIMIT}`);
        return { offsetRemain: -OFFSET_LIMIT }
      }
      Log.info(TAG, `offsetRemain: ${offsetRemain}`);
      return { offsetRemain };
    }
    return undefined;
  }

  export interface MouseState {
    isLeftMouseButtonPress: boolean;
    mousePositionX: number;
    isTrigScroll: boolean;
    scrollDistance?: number;
  }

  export function getMouseState(event: MouseEvent, smallScroller: Scroller): MouseState {
    const MOUSE_LIMIT: number = 10;
    let state: MouseState = {
      isLeftMouseButtonPress: false,
      mousePositionX: Number.NaN,
      isTrigScroll: false,
    }

    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
        state.isLeftMouseButtonPress = true;
        state.mousePositionX = event.windowX;
      }
      state.isTrigScroll = state.isLeftMouseButtonPress &&
        event.action === MouseAction.Move && Number.isFinite(state.mousePositionX) &&
        Math.abs(event.windowX - state.mousePositionX) > MOUSE_LIMIT;
      if (state.isTrigScroll) {
        state.scrollDistance = event.windowX - state.mousePositionX > 0 ? -MOUSE_LIMIT : MOUSE_LIMIT;
      }
    }
    return state;
  }
}

export default Previewer;