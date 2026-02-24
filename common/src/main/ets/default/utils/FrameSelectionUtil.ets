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

/* instrument ignore file */

import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

const TAG: string = 'common_FrameSelectionUtil';

export class FrameSelectionUtil {
  public static isInFrame: boolean = false; //是否处于框选中

  public static init(): void {
    FrameSelectionUtil.isInFrame = false;
  }

  public static mainViewOnMouse(event?: MouseEvent): void {
    if (!event || !DeviceInfo.isPc()) {
      return;
    }
    if ((event.button === MouseButton.Left) && (event.action === MouseAction.Release)) {
      FrameSelectionUtil.isInFrame = false;
    }
  }
}