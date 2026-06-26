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
import { HiLog } from './HiLog';
import display from '@ohos.display';
import { GlobalThisUtil } from './GlobalThisUtil';

export class ScreenUtil {
  private static TAG = 'DeviceUtil';

  public static getScreenWidth(): number {
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
    } catch (exception) {
      HiLog.e(ScreenUtil.TAG, `Failed to obtain the default display object. Code: ${JSON.stringify(exception)}`);
    }
    return displayClass != null ? px2vp(displayClass.width) : 0;
  }


  public static getPreviewerWidthLpx(): number {
    let previewerWidth = px2lpx(vp2px(GlobalThisUtil.getProperty('previewer_area_width')));
    return previewerWidth;
  }

  public static getRefreshRate(): number {
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
    } catch (exception) {
      HiLog.e(ScreenUtil.TAG, `Failed to obtain the default display object. Code: ${JSON.stringify(exception)}`);
    }
    return displayClass != null ? displayClass.refreshRate : 0;
  }
}