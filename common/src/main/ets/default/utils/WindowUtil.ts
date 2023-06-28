/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Log } from './Log';
import window from '@ohos.window';

const TAG: string = 'common_WindowUtil';

export class WindowUtil {
  static setWindowKeepScreenOn(context, isKeepScreenOn: boolean) {
    try {
      window.getLastWindow(context).then((windows) => {
        windows.setWindowKeepScreenOn(isKeepScreenOn).then(() => {
          Log.info(TAG, 'Photos succeeded in setting the screen to be always on.');
        }).catch((err) => {
          Log.error(TAG, 'Photos failed to set the screen to be always on. Cause:  ' + JSON.stringify(err));
        });
      }).catch((err) => {
        Log.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
      });
    } catch (exception) {
      Log.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
  }

  static setPreferredOrientation(context, orientation: number) {
    try {
      window.getLastWindow(context, (err, data) => {
        if (err.code || !data) {
          Log.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        let windowClass = data;
        windowClass.setPreferredOrientation(orientation, (err) => {
          if (err.code) {
            Log.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(err));
            return;
          }
          Log.info(TAG, 'Succeeded in setting window orientation.');
        });
      });
    } catch (exception) {
      Log.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(exception));
    }
  }
}