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

import { Constants, ScreenManager, UserFileManagerAccess, MediaObserver, Log } from '@ohos/common';
import display from '@ohos.display';
import Extension from '@ohos.app.ability.ServiceExtensionAbility';
import Window from '@ohos.window';
import dialogRequest from '@ohos.app.ability.dialogRequest';
import type common from '@ohos.app.ability.common';
import type Want from '@ohos.app.ability.Want';

const TAG: string = 'ServiceExtAbility';

export default class ServiceExtAbility extends Extension {
  private windowClass;

  onCreate(want: Want): void {
    Log.info(TAG, 'ServiceExtAbility want param:' + JSON.stringify(want));
    AppStorage.setOrCreate('windowClass', null);
    AppStorage.setOrCreate('photosAbilityContext', this.context);
    AppStorage.setOrCreate(Constants.SCREEN_SIDEBAR, false);
    AppStorage.setOrCreate('deviceType', Constants.PC_DEVICE_TYPE);
  }

  onReconnect(want: Want): void {
    Log.info(TAG, 'onReconnect windowClass : ' + this.windowClass);
    if (this.windowClass === null || this.windowClass === undefined) {
      return;
    }
    try {
      Log.info(TAG, 'test start1');
      this.windowClass.destroyWindow((err): void => {
        if (err.code) {
          Log.info(TAG, 'Failed to destroy the window. Cause:' + JSON.stringify(err));
          return;
        }
        Log.info(TAG, 'Succeeded in destroying the window.');
        this.windowClass = null;
      });
      Log.info(TAG, 'test done1');
    } catch (e) {
      Log.error(TAG, 'fail1 ' + JSON.stringify(e));
    }
  }


  onRequest(want: Want, startId: number): void {
    if (want.action !== Constants.ACTION_DELETE_DATA) {
      return;
    }
    UserFileManagerAccess.getInstance().onCreate(AppStorage.get<common.UIAbilityContext>('photosAbilityContext'));
    MediaObserver.getInstance().registerForAllPhotos();
    MediaObserver.getInstance().registerForAllAlbums();
    let wantParam: { [key: string]: Object } = want.parameters;
    let uris: any = wantParam?.uris;
    let appName: string = wantParam?.appName as string;
    Log.info(TAG, 'get delete data : ' + JSON.stringify(wantParam));
    if (!uris?.length) {
      return;
    }
    AppStorage.setOrCreate('uris', uris);
    AppStorage.setOrCreate('appName', appName);
    this.windowClass = AppStorage.get('windowClassg');
    let config: Window.Configuration = {
      name: 'DeleteDialog ' + appName + Math.random(), windowType: Window.WindowType.TYPE_DIALOG, ctx: this.context
    };
    try {
      Window.createWindow(config, (err, data): void => { //创建模态窗口
        if (err.code) {
          Log.info(TAG, 'Failed to create the window. Cause: ' + JSON.stringify(err));
          return;
        }
        this.windowClass = data;
        Log.info(TAG, 'Success ded in creating the window. Data: ');
        this.bindDialogTarget(want);
      });
    } catch (exception) {
      Log.info(TAG, 'Failed to create the window. Cause: ' + JSON.stringify(exception));
    }
  }

  private bindDialogTarget(want: Want): void {
    try {
      let requestInfo: dialogRequest.RequestInfo = dialogRequest.getRequestInfo(want); //从Want中获取请求方的RequestInfo
      Log.info(TAG, 'requestInfo param:' + JSON.stringify(requestInfo));

      let requestCallback: dialogRequest.RequestCallback = dialogRequest.getRequestCallback(want);
      AppStorage.setOrCreate('requestCallback', requestCallback);

      this.windowClass.bindDialogTarget(requestInfo, (): void => { //绑定模态窗口与目标窗口
        Log.info(TAG, 'Dialog Window Need Destroy.');
      }, (err): void => {
        if (err.code) {
          Log.info(TAG, 'Failed to bind dialog target. Cause:' + JSON.stringify(err));
          return;
        }
        Log.info(TAG, 'Succeeded in binding dialog target.');
        this.setContentUI();
      });
    } catch (exception) {
      Log.error(TAG, 'Failed to bind dialog target. Cause:' + JSON.stringify(exception));
    }
  }

  private setContentUI(): void {
    try {
      this.windowClass.setUIContent('pages/ResourceDeletePage', (err): void => {
        if (err.code) {
          Log.info(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        Log.info(TAG, 'Succeeded in loading the content.');
        display.getDefaultDisplay().then((data): void => {
          Log.info(TAG, 'Succeeded in loading the content.' + data.width + ',  ' + data.height);
          ScreenManager.getInstance().setWinWidth(px2vp(data.width));
          this.windowClass.resetSize(data.width, data.height); //设置窗口全屏
          this.windowClass.setBackgroundColor('#00000000'); //设置窗口背景透明
          this.windowClass.show();
        }).catch((err): void => {
          Log.error(TAG, 'getDefaultDisplay fail: ' + JSON.stringify(err));
        });
      });
    } catch (exception) {
      Log.error(TAG, 'Failed to load the content. Cause:' + JSON.stringify(exception));
    }
  }

  onDisconnect(want: Want): void {
    Log.info(TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
  }
}