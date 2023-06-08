
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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


import display from '@ohos.display';
import Extension from '@ohos.app.ability.ServiceExtensionAbility';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import dialogRequest from '@ohos.app.ability.dialogRequest';
import deviceInfo from '@ohos.deviceInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Constants } from '../common/model/common/Constants';
import { mediaModel } from '@ohos/base/src/main/ets/model/MediaModel';
import uri from '@ohos.uri';
import { screenManager } from '@ohos/base/src/main/ets/manager/ScreenManager';
import { GlobalContext } from '@ohos/base/src/main/ets/utils/GlobalContext';

const TAG: string = 'ServiceExtAbility';

export class ServiceExtAbility extends Extension {
  private globalThis = GlobalContext.getContext();

  onCreate(want): void {
    Log.info(TAG, "ServiceExtAbility want param : " + JSON.stringify(want));
    this.globalThis.setObject("windowClass", null);
    this.globalThis.setObject("photoAbilityContext", this.context);
  }

  onRequest(want, startId): void {
    if (want.action != Constants.ACTION_DELETE_DATA) {
      return;
    }
    mediaModel.onCreate(this.context);

    let uris: string[] | null = want.parameters?.uris as string[];
    let appName: string = want.parameters?.appName as string;
    Log.info(TAG, "get delete data : " + JSON.stringify(want.parameters));
    if (uris == undefined || uris.length ===0) {
      return;
    }
    AppStorage.SetOrCreate<string[]>("uris", uris);
    AppStorage.SetOrCreate<string>("appName", appName);

    let windowClass: window.Window = this.globalThis.getObject("windowClass") as window.Window;
    try {
      let config: window.Configuration = {
        name: "DeleteDialog " + appName + Math.random(), windowType: window.WindowType.TYPE_DIALOG, ctx: this.context
      }
      try {
        window.createWindow(config, (err: BusinessError, data: window.Window): void => {
          if (err.code != null) {
            Log.info(TAG, "Failed to create the window. Cause : " + JSON.stringify(err));
            return;
          }
          windowClass = data;
          Log.info(TAG, "Success ded in creating the window. Data : " + JSON.stringify(data));
          try {
            let requestInfo = dialogRequest.getRequestInfo(want);
            Log.info(TAG, "requestInfo param : " + JSON.stringify(requestInfo));

            let requestCallback: dialogRequest.RequestCallback = dialogRequest.getRequestCallback(want);
            AppStorage.SetOrCreate<dialogRequest.RequestCallback>("requestCallback", requestCallback);
            Log.info(TAG, "Succeeded in get requestCallback");

            windowClass.bindDialogTarget(requestInfo, (): void => {
              Log.info(TAG, 'Dialog Window Need Destroy.');
            }, (err: BusinessError): void => {
              Log.error(TAG, 'Dialog bindDialogTarget err');
              if (err.code != null) {
                Log.error(TAG, "Failed to bind dialog target. Cause : " + JSON.stringify(err));
                return;
              }
              Log.error(TAG, 'Succeeded in binding dialog target.');
              try {
                windowClass.setUIContent('pages/ResourceDeletePage', (err: BusinessError): void => {
                  if (err.code != null) {
                    Log.error(TAG, "Failed to load the content. Cause : " + JSON.stringify(err));
                    return;
                  }
                  Log.error(TAG, "Succeeded in loading the content");
                  let promise = display.getDefaultDisplay();
                  promise.then((data: display.Display): void => {
                    Log.error(TAG, "Succeeded in loading the content, width : " + data.width + ",  height : " + data.height);
                    screenManager.setWinWidth(data.width)
                    windowClass.resetSize(data.width, data.height);
                    windowClass.setBackgroundColor('#00000000');
                    windowClass.show();
                  })
                })
              } catch (err) {
                Log.error(TAG, "getDefaultDisplay fail : " + JSON.stringify(err));
              }
            })
            Log.info(TAG, 'bindDialogTarget done');
          } catch (exception) {
            Log.error(TAG, "Failed to load the content. Cause : " + JSON.stringify(exception));
          }
        })
      } catch (exception) {
        Log.error(TAG, "Failed to bind the window. Cause : " + JSON.stringify(exception));
      }
    } catch {
      Log.error(TAG, "Failed");
    }

    Log.info(TAG, 'done');

    let onStart = this.globalThis.getObject("onStart1");
    onStart = ((): void => {
      try {
        Log.info(TAG, 'test start1');
        windowClass.destroyWindow((err: BusinessError): void => {
          if (err.code != null) {
            Log.info(TAG, "Failed to destroy the window. Cause : " + JSON.stringify(err));
            return;
          }
          Log.info(TAG, "Succeeded in destroying the window.");
          windowClass = null;
        });
        Log.info(TAG, 'test done1');
      } catch (e) {
        Log.info(TAG, "Failed 1 : " + JSON.stringify(e));
      }
    });
  }

  onDisconnect(want): void {
    Log.info(TAG, "onDisconnect, want: " + want.abilityName);
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
  }

}
