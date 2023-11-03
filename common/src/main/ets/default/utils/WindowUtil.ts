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
import { Router, UIContext } from '@ohos.arkui.UIContext';
import common from '@ohos.app.ability.common';

const TAG: string = 'common_WindowUtil';

export class WindowUtil {
  static setWindowKeepScreenOn(context: common.UIAbilityContext, isKeepScreenOn: boolean): void {
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

  static setPreferredOrientation(context: common.UIAbilityContext, orientation: number): void {
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

  static prepareWinRouter(): void {
    Log.debug(TAG, `prepareWinRouter AppStorage.get<Router>('router')=${AppStorage.get<Router>('router')}`);
    if (AppStorage.get('router')) {
      return;
    }
    try {
      AppStorage.setOrCreate('uiContext', (AppStorage.get<window.Window>('mainWindow') as window.Window).getUIContext());
    } catch (error) {
      Log.error(TAG, `Failed to get UIContext, error: ${error}`);
      return;
    }
    if (AppStorage.get('uiContext')) {
      Log.info(TAG, `prepareWinRouter AppStorage.get<window.Window>('uiContext')=${AppStorage.get<window.Window>('uiContext')}`);
      AppStorage.setOrCreate('router', (AppStorage.get<UIContext>('uiContext')).getRouter());
      Log.info(TAG, `prepareWinRouter localRouter=${AppStorage.get<Router>('router')}`);
    }
  }
}