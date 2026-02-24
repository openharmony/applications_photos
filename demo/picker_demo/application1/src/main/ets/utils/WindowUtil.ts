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

import lazy { Log } from './Log';
import lazy window from '@ohos.window';
import type common from '@ohos.app.ability.common';
import type { Router, UIContext } from '@ohos.arkui.UIContext';
import type { BusinessError } from '@ohos.base';
import lazy settings from '@ohos.settings';

/* instrument ignore file */
const TAG: string = 'common_WindowUtil';
/* 自动旋转0是关闭，1是打开 */
const AUTO_ROTATE_OFF: string = '0';

export class WindowUtil {
  private static privacyReqMap: Map<common.Context, number> = new Map();

  static setWindowKeepScreenOn(context: common.UIAbilityContext, isKeepScreenOn: boolean): void {
    try {
      window.getLastWindow(context).then((windows) => {
        windows.setWindowKeepScreenOn(isKeepScreenOn).then((): void => {
          Log.info(TAG, `Photos succeeded in setting the screen to be always on. ${isKeepScreenOn}`);
        }).catch((err): void => {
          Log.error(TAG, 'Photos failed to set the screen to be always on. Cause:  ' + err);
        });
      }).catch((err): void => {
        Log.error(TAG, 'Failed to obtain the top window. Cause: ' + err);
      });
    } catch (exception) {
      Log.error(TAG, 'Failed to obtain the top window. Cause: ' + exception);
    }
  }

  static setPreferredOrientation(context: common.UIAbilityContext, orientation: number): void {
    const getLastWindowCallback = (err: BusinessError<void>, windowClass: window.Window): void => {
      if (err.code || !windowClass) {
        Log.error(TAG, 'Failed to obtain the top window. Cause: ' + orientation + err);
        return;
      }
      windowClass.setPreferredOrientation(orientation, (err: BusinessError<void>): void => {
        if (err.code) {
          Log.error(TAG, 'Failed to set window orientation. Cause: ' + orientation + err);
          return;
        }
        Log.info(TAG, 'Succeeded in setting window orientation.' + orientation);
      });
    };
    try {
      window.getLastWindow(context, getLastWindowCallback);
    } catch (exception) {
      Log.error(TAG, 'Failed to set window orientation. Cause: ' + orientation + exception);
    }
  }

  static setOrientation(orientation: number): void {
    const context = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
    this.setPreferredOrientation(context, orientation);
  }

  static getOrientationLockedValue(context: common.Context): boolean {
    Log.info(TAG, 'getOrientationLockedValue systemUIContext, context: ' + typeof (context));
    let value: string = null;
    try {
      value = settings.getValueSync(context,
        settings.general.ACCELEROMETER_ROTATION_STATUS,
        AUTO_ROTATE_OFF);
    } catch (err) {
      Log.error(TAG, `getValue:${err}, code: ${err?.code}`);
    }
    let ret: boolean = AUTO_ROTATE_OFF === value;
    Log.info(TAG, `getOrientationLockedValue systemUIContext, value: ${value} ret:${ret}`);
    return ret;
  }

  static prepareWinRouter(): void {
    Log.debug(TAG, `prepareWinRouter AppStorage.get<Router>('router'):${Boolean(AppStorage.get<Router>('router'))}`);
    if (AppStorage.get('router')) {
      return;
    }
    try {
      AppStorage.setOrCreate('uiContext', AppStorage.get<window.Window>('mainWindow')?.getUIContext());
    } catch (error) {
      Log.error(TAG, `Failed to get UIContext, error: ${error}, code: ${error?.code}`);
      return;
    }
    if (AppStorage.get('uiContext')) {
      Log.info(TAG,
        `prepareWinRouter AppStorage.get<window.window>('uiContext')=${typeof AppStorage.get<window.Window>('uiContext')}`);
      AppStorage.setOrCreate('router', AppStorage.get<UIContext>('uiContext').getRouter());
      Log.info(TAG, `prepareWinRouter localRouter=${Boolean(AppStorage.get<Router>('router'))}`);
    }
  }

  static setWaterMark(context: common.UIAbilityContext, isEnable: boolean): void {
    if (context === undefined || context === null) {
      Log.error(TAG, 'invalid context');
      return;
    }

    const getLastWindowCallback = (err: BusinessError<void>, windowClass: window.Window): void => {
      if (err.code || !windowClass) {
        Log.error(TAG, 'Failed to obtain the top window. Cause: ' + err);
        return;
      }
      windowClass.setWaterMarkFlag(isEnable, (err: BusinessError<void>): void => {
        if (err.code) {
          Log.error(TAG, 'Failed to set window water mark. Cause: ' + err);
          return;
        }
        Log.info(TAG, 'Succeeded in setting window water mark.');
      });
    };

    try {
      window?.getLastWindow(context, getLastWindowCallback);
    } catch (exception) {
      Log.error(TAG, 'Failed to set window water mark. Cause: ' + exception);
    }
  }


  /**
   * privacyReqMap记录context的请求隐私窗口的次数，每次isPrivate为true计数加一，为false时计数减一；
   * 当计数转为非0时设置隐私；反之计数转为0时才取消设置隐私；
   *
   * @param context 上下文信息
   * @param isPrivate 是否设置隐私
   * @param msg 用于维测日志打印，确定调用点、当前引用计数、isPrivate值
   */
  public static setPrivateWindow(context: common.Context, isPrivate: boolean, msg: string): void {
    if (context === undefined || context === null) {
      Log.error(TAG, 'invalid context');
      return;
    }
    let privacyReqCount: number = 0;
    try {
      window.getLastWindow(context).then((windowClass: window.Window) => {
        try {
          privacyReqCount = this.privacyReqMap.has(context) ? this.privacyReqMap.get(context) : 0;
          privacyReqCount = isPrivate ? privacyReqCount + 1 : privacyReqCount - 1;
          this.privacyReqMap.set(context, privacyReqCount);

          // 当隐私请求数非0时设置隐私；反之隐私请求数为0时才取消设置隐私；
          windowClass?.setWindowPrivacyMode(privacyReqCount > 0);
          Log.info(TAG,
            `${msg} privacy window set success! isPrivate: ${isPrivate}, privacyReqCount is :${privacyReqCount}`);
        } catch (err) {
          Log.error(TAG, `set PrivacyMode fail: ${err}`);
        }
        if (privacyReqCount <= 0) {
          this.privacyReqMap.delete(context);
        }
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
    }
  }

  private static setWindowSize(windowClass: window.Window, isFullScreen: boolean): void {
    try {
      if (isFullScreen) {
        windowClass?.recover();
      } else {
        windowClass?.setWindowLayoutFullScreen(false);
      }
    } catch (err) {
      Log.error(TAG, `set WindowSize fail: ${err}`);
    }
    return;
  }

  public static setWindowBackgroundColor(uiContext: common.UIAbilityContext, backgroundColor: string): void {
    if (!uiContext || !uiContext.windowStage) {
      Log.error(TAG, 'uiContext is error');
      return;
    }
    uiContext.windowStage.getMainWindow()
      .then((window) => {
        window.setWindowBackgroundColor(backgroundColor);
      })
      .catch((error) => {
        Log.error(TAG, 'setWindowBackgroundColorDefault: failed, error info is ' + error + ', code: ' + error?.code);
      });
  }

  public static maxOrRecoverWindows(context: common.Context, isFullScreen: boolean): void {
    try {
      window.getLastWindow(context).then((windowClass: window.Window) => {
        this.setWindowSize(windowClass, isFullScreen);
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
    }
  }
}