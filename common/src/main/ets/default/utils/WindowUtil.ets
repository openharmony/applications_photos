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
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import type common from '@ohos.app.ability.common';
import type { Router, UIContext } from '@ohos.arkui.UIContext';
import type { BusinessError } from '@ohos.base';
import lazy settings from '@ohos.settings';
import lazy { Context } from '@kit.AbilityKit';
import lazy { Constants } from '../model/common/Constants';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { ImmersiveController } from './ImmersiveController';
import lazy { isOrientationHorizontal } from '../model/common/ScreenManager';
import lazy { ScreenManager } from '../model/common/ScreenManager';

/* instrument ignore file */
const TAG: string = 'common_WindowUtil';
/* 自动旋转0是关闭，1是打开 */
const AUTO_ROTATE_OFF: string = '0';
let winChangeTimer: number = -1;
let winChangeFlag: boolean = true;

export class WindowUtil {
  private static privacyReqMap: Map<common.Context, number> = new Map();

  public static handleWinTopBarToggle(context: Context): void {
    if (!DeviceInfo.isPc() || !winChangeFlag) {
      return;
    }
    winChangeTimer = setTimeout((): void => {
      winChangeFlag = true;
      winChangeTimer && clearTimeout(winChangeTimer);
    }, 200);
    winChangeFlag = false;
    let windowStatus = ScreenManager.getInstance().getMainWindow()?.getWindowStatus();
    Log.info(TAG, `handleWinTopBarToggle, windowStatus: ${windowStatus}`);
    if (windowStatus === window.WindowStatusType.SPLIT_SCREEN) {
      WindowUtil?.maxOrRecoverWindows(context, true);
    } else {
      WindowUtil?.maxOrRecoverWindows(context,
        windowStatus === window.WindowStatusType.MAXIMIZE);
    }
  }

  public static setWindowKeepScreenOn(context: common.UIAbilityContext, isKeepScreenOn: boolean): void {
    try {
      window.getLastWindow(context).then((windows) => {
        windows.setWindowKeepScreenOn(isKeepScreenOn).then((): void => {
          Log.info(TAG, `Photos succeeded in setting the screen to be always on. ${isKeepScreenOn}`);
        }).catch((err: BusinessError): void => {
          Log.error(TAG, `Photos failed to set the screen to be always on. Cause:  ${err}`);
        });
      }).catch((err: BusinessError): void => {
        Log.error(TAG, `Failed to obtain the top window. Cause: ${err}`);
      });
    } catch (exception) {
      Log.error(TAG, `Failed to obtain the top window. Cause: ${exception}`);
    }
  }

  public static setPreferredOrientation(context: common.UIAbilityContext | undefined, orientation: number): void {
    Log.info(TAG, `setPreferredOrientation: ${orientation}`);
    let err: Error = new Error();
    console.log(TAG, `setPreferredOrientation stack: ${err.stack?.toString()}`);
    const getLastWindowCallback = (err: BusinessError<void>, windowClass: window.Window): void => {
      if (err.code || !windowClass || !context) {
        Log.error(TAG, `Failed to obtain the top window. Cause: ${orientation}` + err);
        return;
      }
      if (windowClass.getPreferredOrientation() === orientation) {
        Log.info(TAG, 'orientation is same');
        return;
      }
      windowClass.setPreferredOrientation(orientation, (err: BusinessError<void>): void => {
        if (err.code) {
          Log.error(TAG, `Failed to set window orientation. Cause: ${orientation}` + err);
          return;
        }
        Log.info(TAG, `Succeeded in setting window orientation.${orientation}`);
      });
    };
    try {
      context?.windowStage?.getMainWindow(getLastWindowCallback);
    } catch (exception) {
      Log.error(TAG, `Failed to set window orientation. Cause: ${orientation}` + exception);
    }
  }

  public static setOrientation(orientation: number): void {
    let context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    if (!context) {
      context = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
      Log.info(TAG, `setOrientation fallback to AppStorage context: ${Boolean(context)}`);
    }
    WindowUtil.setPreferredOrientation(context, orientation);
  }

  public static async getPreferredOrientation(): Promise<window.Orientation | undefined> {
    const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');

    if (!context || !context.windowStage) {
      Log.error(TAG, 'Context or windowStage is not available.');
      return undefined;
    }

    try {
      const windowClass = await WindowUtil.getMainWindow(context);
      return windowClass.getPreferredOrientation();
    } catch (error) {
      Log.error(TAG, `Error in getPreferredOrientation: ${error}`);
      return undefined;
    }
  }

  public static async getMainWindow(context: common.UIAbilityContext): Promise<window.Window> {
    return new Promise((resolve, reject) => {
      context.windowStage.getMainWindow((err: BusinessError, windowClass: window.Window) => {
        if (err?.code) {
          reject(err);
          return;
        }
        resolve(windowClass);
      });
    });
  }

  public static getOrientationLockedValue(context: common.Context): boolean {
    Log.info(TAG, `getOrientationLockedValue systemUIContext, context: ${typeof (context)}`);
    let value: string | null = null;
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

  public static prepareWinRouter(): void {
    Log.debug(TAG, `prepareWinRouter AppStorage.get<Router>('router'):${Boolean(AppStorage.get<Router>('router'))}`);
    if (AppStorage.get('router')) {
      return;
    }
    try {
      LocalStorage.getShared()
        .setOrCreate('uiContext', LocalStorage.getShared()?.get<window.Window>('mainWindow')?.getUIContext());
    } catch (error) {
      Log.error(TAG, `Failed to get UIContext, error: ${error}, code: ${error?.code}`);
      return;
    }
    if (LocalStorage.getShared()?.get('uiContext')) {
      Log.info(TAG, `prepareWinRouter LocalStorage.getShared()?.get('uiContext')=${
      typeof LocalStorage.getShared()?.get('uiContext')}`);
      AppStorage.setOrCreate('router', LocalStorage.getShared()?.get<UIContext>('uiContext')?.getRouter());
      Log.info(TAG, `prepareWinRouter localRouter=${Boolean(AppStorage.get<Router>('router'))}`);
    }
  }

  public static setWaterMark(context: common.UIAbilityContext, isEnable: boolean): void {
    if (context === undefined || context === null) {
      Log.error(TAG, 'invalid context');
      return;
    }

    const getLastWindowCallback = (err: BusinessError<void>, windowClass: window.Window): void => {
      if (err.code || !windowClass) {
        Log.error(TAG, `Failed to obtain the top window. Cause: ${err}`);
        return;
      }
      windowClass.setWaterMarkFlag(isEnable, (err: BusinessError<void>): void => {
        if (err.code) {
          Log.error(TAG, `Failed to set window water mark. Cause: ${err}`);
          return;
        }
        Log.info(TAG, 'Succeeded in setting window water mark.');
      });
    };

    try {
      window?.getLastWindow(context, getLastWindowCallback);
    } catch (exception) {
      Log.error(TAG, `Failed to set window water mark. Cause: ${exception}`);
    }
  }

  /**
   * 主窗口是否设置隐私
   *
   * @param context 上下文信息
   * @param isPrivate 是否设置隐私
   * @param msg 用于维测日志打印，确定调用点、当前引用计数、isPrivate值
   */
  public static setMainWindow(context: common.Context, isPrivate: boolean, msg: string): void {
    if (context === undefined || context === null) {
      Log.error(TAG, 'invalid context');
      return;
    }
    let privacyReqCount: number | undefined = 0;
    try {
      let uiContext: common.UIAbilityContext = context as common.UIAbilityContext;
      uiContext.windowStage.getMainWindow().then((window) => {
        try {
          privacyReqCount = WindowUtil.privacyReqMap.has(context) ? WindowUtil.privacyReqMap.get(context) : 0;
          if (privacyReqCount !== undefined) {
            privacyReqCount = isPrivate ? privacyReqCount + 1 : privacyReqCount - 1;
            WindowUtil.privacyReqMap.set(context, privacyReqCount);

            // 当隐私请求数非0时设置隐私；反之隐私请求数为0时才取消设置隐私；
            window?.setWindowPrivacyMode(privacyReqCount > 0);
          }
          Log.info(TAG, `${msg} privacy window set success! isPrivate: ${
          isPrivate}, privacyReqCount is :${privacyReqCount}`);
        } catch (err) {
          Log.error(TAG, `set PrivacyMode fail: ${err}`);
        }
        if (privacyReqCount !== undefined && privacyReqCount <= 0) {
          WindowUtil.privacyReqMap.delete(context);
        }
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
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
    let privacyReqCount: number | undefined = 0;
    try {
      window.getLastWindow(context).then((windowClass: window.Window) => {
        try {
          privacyReqCount = WindowUtil.privacyReqMap.has(context) ? WindowUtil.privacyReqMap.get(context) : 0;
          if (privacyReqCount !== undefined) {
            privacyReqCount = isPrivate ? privacyReqCount + 1 : privacyReqCount - 1;
            WindowUtil.privacyReqMap.set(context, privacyReqCount);

            // 当隐私请求数非0时设置隐私；反之隐私请求数为0时才取消设置隐私；
            windowClass?.setWindowPrivacyMode(privacyReqCount > 0);
          }
          Log.info(TAG, `${msg} privacy window set success! isPrivate: ${
          isPrivate}, privacyReqCount is :${privacyReqCount}`);
        } catch (err) {
          Log.error(TAG, `set PrivacyMode fail: ${err}`);
        }
        if (privacyReqCount !== undefined && privacyReqCount <= 0) {
          WindowUtil.privacyReqMap.delete(context);
        }
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
    }
  }

  private static setWindowSize(windowClass: window.Window, isFullScreen: boolean): void {
    Log.info(TAG, `setWindowSize ${isFullScreen}`);
    try {
      if (isFullScreen) {
        windowClass?.recover();
      } else {
        windowClass?.maximize(window.MaximizePresentation.FOLLOW_APP_IMMERSIVE_SETTING);
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
      .catch((error: BusinessError) => {
        Log.error(TAG, 'setWindowBackgroundColorDefault: failed, error info is ' + error + `, code: ${error?.code}`);
      });
  }

  public static maxOrRecoverWindows(context: common.Context, isFullScreen: boolean): void {
    try {
      window.getLastWindow(context).then((windowClass: window.Window) => {
        WindowUtil.setWindowSize(windowClass, isFullScreen);
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
    }
  }

  private static setSpecificSystemBar(topWindow: window.Window,
    name: window.SpecificSystemBar, isShow: boolean): void {
    try {
      topWindow?.setSpecificSystemBarEnabled(name, isShow).then(() => {
        Log.info(TAG, 'Succeeded in setting the system bar');
      }).catch((err: BusinessError) => {
        Log.error(TAG, `Failed to set the system bar. Cause code: ${err.code}, message: ${err.message}`);
      });
    } catch (exception) {
      Log.error(TAG, `Failed to set the system bar. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }

  public static setSpecificSystemUi(context: common.Context, name: window.SpecificSystemBar, isShow: boolean): void {
    if (context === undefined || context === null) {
      Log.error(TAG, 'invalid context');
      return;
    }
    try {
      window.getLastWindow(context).then((topWindow: window.Window) => {
        WindowUtil.setSpecificSystemBar(topWindow, name, isShow);
      });
    } catch (err) {
      Log.error(TAG, `get window fail: ${err}`);
    }
  }

  /**
   * 设置系统栏背景色
   *
   * @param statusColor 颜色值
   */
  public static setWindowSystemBarProperties(statusColor: string): void {
    Log.info(TAG, `updateWindowSystemBarProperties:${statusColor}`);
    let windowStage: window.WindowStage = global.windowStage();
    let windowClass: window.Window | undefined = undefined;
    windowStage?.getMainWindow((err: BusinessError, data) => {
      const errCode: number = err.code;
      if (errCode) {
        Log.error(TAG, `Failed updateWindowSystemBarProperties Cause code:${err.code}, message:${err.message}`);
        return;
      }
      windowClass = data;
      try {
        let promise = windowClass?.setWindowSystemBarProperties({ statusBarContentColor: statusColor });
        promise.then(() => {
          Log.info(TAG, 'Succeeded updateWindowSystemBarProperties');
        }).catch((err: BusinessError) => {
          Log.error(TAG, `Failed updateWindowSystemBarProperties Cause code:${err.code}, message:${err.message}`);
          return;
        });
      } catch (exception) {
        Log.error(TAG, `Failed updateWindowSystemBarProperties code:${exception.code}, message:${exception.message}`);
        return;
      }
    });
  }

  /**
   * 更新系统栏文字颜色
   *
   * @param statusColor 颜色值
   */
  public static updateWindowSystemBarProperties(statusColor: string): void {
    Log.info(TAG, `updateWindowSystemBarProperties:${statusColor}`);
    let contentColor: string = statusColor;
    //固定场景-直板机/F态,横屏为白色文字
    if (isOrientationHorizontal() && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      contentColor = Constants.RULER_FILL_STYLE_100;
    }
    let mainWindow: window.Window = global.mainWindow();
    if (!mainWindow) {
      Log.info(TAG, 'mainWindow is null or undefined');
      return;
    }
    mainWindow.setWindowSystemBarProperties({ statusBarContentColor: contentColor, navigationBarContentColor: contentColor});
  }

  /**
   * 沉浸态切换后恢复到切换前状态
   */
  public static resumeWindowSystemBarProperties() {
    let isDarkMode = ImmersiveController.isInImmersive ||
      AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    if (isDarkMode) {
      WindowUtil.updateWindowSystemBarProperties(Constants.RULER_FILL_STYLE_100);
    } else {
      WindowUtil.updateWindowSystemBarProperties(Constants.STATUS_BAR_CONTENT_COLOR);
    }
  }
}
