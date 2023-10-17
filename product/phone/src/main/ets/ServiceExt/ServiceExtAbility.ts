
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

import  {
  Constants,
  ScreenManager,
  UserFileManagerAccess,
  MediaObserver,
  Log
} from '@ohos/common';
import display from '@ohos.display';
import Extension from '@ohos.app.ability.ServiceExtensionAbility';
import Window from '@ohos.window';
import dialogRequest from '@ohos.app.ability.dialogRequest';
import common from '@ohos.app.ability.common';

const TAG: string = 'ServiceExtAbility';

export default class ServiceExtAbility extends Extension {

  onCreate(want) {
    Log.info(TAG, `ServiceExtAbility want param : ${JSON.stringify(want)}`);
    AppStorage.setOrCreate('windowClass', null);
    AppStorage.setOrCreate('photosAbilityContext', this.context);
    AppStorage.SetOrCreate(Constants.SCREEN_SIDEBAR, false);
    AppStorage.SetOrCreate("deviceType", Constants.DEFAULT_DEVICE_TYPE);
  }

  onRequest(want, startId) {
    if (want.action != Constants.ACTION_DELETE_DATA) {
      return;
    }
    UserFileManagerAccess.getInstance().onCreate(AppStorage.get<common.UIAbilityContext>('photosAbilityContext'));
    MediaObserver.getInstance().registerForAllPhotos();
    MediaObserver.getInstance().registerForAllAlbums();

    let wantParam: {[key:string]: object} = want.parameters;
    let uris: any = wantParam?.uris;
    let appName: string = wantParam?.appName as unknown as string;
    Log.info(TAG, `get delete data : ${JSON.stringify(wantParam)}}`);
    if (uris == undefined || uris.length ===0) {
      return;
    }
    AppStorage.SetOrCreate("uris", uris);
    AppStorage.SetOrCreate("appName", appName);

    let windowClass = globalThis.windowClassg;
    try {
      let config = {
        name: "DeleteDialog " + appName + Math.random(), windowType: Window.WindowType.TYPE_DIALOG, ctx: this.context
      }
      try {
        Window.createWindow(config, (err, data) => {
          if (err.code) {
            Log.info(TAG, `Failed to create the window. Cause : ${JSON.stringify(err)}`);
            return;
          }
          windowClass = data;
          Log.info(TAG, `Success ded in creating the window. Data : ${JSON.stringify(data)}`);
          try {
            let requestInfo = dialogRequest.getRequestInfo(want);
            Log.info(TAG, `requestInfo param : ${JSON.stringify(requestInfo)}`);

            var requestCallback = dialogRequest.getRequestCallback(want);
            AppStorage.SetOrCreate("requestCallback", requestCallback);
            Log.info(TAG, `Succeeded in get requestCallback`);

            windowClass.bindDialogTarget(requestInfo, () => {
              Log.info(TAG, 'Dialog Window Need Destroy.');
            }, (err) => {
              Log.error(TAG, 'Dialog bindDialogTarget err');
              if (err.code) {
                Log.error(TAG, `Failed to bind dialog target. Cause : ${JSON.stringify(err)}`);
                return;
              }
              Log.error(TAG, 'Succeeded in binding dialog target.');
              try {
                windowClass.setUIContent('pages/ResourceDeletePage', (err) => {
                  if (err.code) {
                    Log.error(TAG, `Failed to load the content. Cause : ${JSON.stringify(err)}`);
                    return;
                  }
                  Log.error(TAG, `Succeeded in loading the content`);
                  let promise = display.getDefaultDisplay();
                  promise.then((data) => {
                    Log.error(TAG, `Succeeded in loading the content, width : ${data.width},  height : ${data.height}`);
                    ScreenManager.getInstance().setWinWidth(px2vp(data.width));
                    windowClass.resetSize(data.width, data.height);
                    windowClass.setBackgroundColor('#00000000');
                    windowClass.show();
                  })
                })
              } catch (err) {
                Log.error(TAG, `getDefaultDisplay fail : ${JSON.stringify(err)}`);
              }
            })
            Log.info(TAG, 'bindDialogTarget done');
          } catch (exception) {
            Log.error(TAG, `Failed to load the content. Cause : ${JSON.stringify(exception)}`);
          }
        })
      } catch (exception) {
        Log.error(TAG, `Failed to bind the window. Cause : ${JSON.stringify(exception)}`);
      }
    } catch {
      Log.error(TAG, `Failed`);
    }

    globalThis.onStart1 = (() => {
      try {
        Log.info(TAG, 'test start1');
        windowClass.destroyWindow((err) => {
          if (err.code) {
            Log.info(TAG, `Failed to destroy the window. Cause : ${JSON.stringify(err)}`);
            return;
          }
          Log.info(TAG, `Succeeded in destroying the window.`);
          windowClass = null;
        });
      } catch (e) {
        Log.info(TAG, `Failed 1 : ${JSON.stringify(e)}`);
      }
    });
  }

  onDisconnect(want) {
    Log.info(TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy');
  }

}