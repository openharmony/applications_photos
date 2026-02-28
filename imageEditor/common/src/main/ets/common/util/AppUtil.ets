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
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import { App } from '../../service/App';
import { HiLog } from './HiLog';
import { ScreenManager } from './ScreenManager';

/* instrument ignore file */
export class AppUtil {
  private static TAG = 'AppUtil';

  public static keepScreenOn(isKeepScreenOn: boolean): void {
    if (!App.getInstance() || !App.getInstance().instanceData() || ScreenManager.getInstance().isUIExtensionEnv()) {
      HiLog.i(AppUtil.TAG,
        `keepScreenOn ${isKeepScreenOn}` + ' ignored, windowStage is not initialized or isUIExtensionEnv');
      return;
    }
    let windowStage: window.WindowStage | undefined = App.getInstance().instanceData().windowStage;
    if (!windowStage) {
      HiLog.i(AppUtil.TAG, `keepScreenOn ${isKeepScreenOn}` + ' ignored, windowStage is not initialized');
      return;
    }
    windowStage
      .getMainWindow()
      .then((window: window.Window) => {
        HiLog.i(AppUtil.TAG, `keepScreenOn ${isKeepScreenOn}` + ' succeed');
        window.setWindowKeepScreenOn(isKeepScreenOn);
      })
      .catch((err: BusinessError) => {
        HiLog.e(AppUtil.TAG, 'keepScreenOn ' + isKeepScreenOn + ` failed, err=${err}`);
      })
  }
}
