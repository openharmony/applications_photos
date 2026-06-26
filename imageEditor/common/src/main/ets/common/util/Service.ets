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
/* instrument ignore file*/
import window from '@ohos.window';
import pointer from '@ohos.multimodalInput.pointer';
import { GlobalThisUtil } from './GlobalThisUtil';
import { HiLog } from './HiLog';


const TAG = 'service';

export class Service {
  public static changeMouseShape(pointerShape: pointer.PointerStyle) {
    window.getLastWindow(GlobalThisUtil.getProperty('editor_abilityContext'), (error, win) => {
      if (error?.code) {
        HiLog.e(TAG, 'Failed to obtain the top window. Cause: ' + error + `, code: ${error?.code}`);
        return;
      }
      let windowId = win.getWindowProperties?.().id;
      if (windowId < 0) {
        HiLog.e(TAG, 'Invalid windowId');
        return;
      }
      try {
        HiLog.i(TAG, `Failed to obtain the top window. Cause: ${windowId}`);
        pointer.setPointerStyle(windowId, pointerShape, error => {
          HiLog.i(TAG, 'Set pointer style success');
        });
      } catch (error) {
        HiLog.e(TAG, `Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
      }
    })
  }

  /**
   * 修改横竖屏定位状态
   *
   * @param orientation 0默认 1竖屏 2横屏 3竖屏翻转 4横屏翻转 8自适应 11锁定当前状态
   */
  public static changeOrientationMode(orientation: window.Orientation) {
    window.getLastWindow(GlobalThisUtil.getProperty('editor_abilityContext'), (error, win) => {
      if (error.code) {
        HiLog.e(TAG, 'Failed to obtain the top window.');
        return;
      }
      let windowId = win.getWindowProperties().id;
      if (windowId < 0) {
        HiLog.e(TAG, 'Invalid windowId');
        return;
      }
      try {
        win.setPreferredOrientation(orientation, (err) => {
          if (err.code) {
            HiLog.e(TAG, 'Failed to set window orientation.');
            return;
          }
          HiLog.i(TAG, `Succeeded in setting window orientation: ${orientation}`);
        });
      } catch (err) {
        HiLog.e(TAG, `Failed to set window orientation, error code : ${err.code}`);
      }
    })
  }
}