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
import promptAction from '@ohos.promptAction';
import resourceManager from '@ohos.resourceManager';
import vibrator from '@ohos.vibrator';
import { App } from '../../service/App';
import { Rectangle } from './types';
import { BusinessError } from '@ohos.base';
import { GlobalThisUtil } from './GlobalThisUtil';
import { DeviceUtil } from './DeviceUtil';
import { WinSize } from '../../service/EditorSDK';
import { Constants } from './Constants';
import {
  BOTTOM_HEIGHT,
  BOTTOM_HEIGHT_SPLIT,
  CURRENT_LANGUAGE,
  DIRECTION_RTL,
  EDITOR_STATUS_BAR_HEIGHT_KEY,
  LEFT_PORTRAIT_OFFSET_PAD,
  LEFT_PORTRAIT_OFFSET_PHONE,
  RIGHT_BAR_HEIGHT,
  TOP_BAR_HEIGHT,
  PC_TOP_BAR_HEIGHT
} from '../const';
import window from '@ohos.window';
import { ScreenManager } from './ScreenManager';
import { Configuration } from '@kit.ArkUI';
import { accessibility } from '@kit.AccessibilityKit';
import { common, ConfigurationConstant, Context } from '@kit.AbilityKit';
import { i18n } from '@kit.LocalizationKit';
import { SystemPropertiesManager } from '@ohos/common/src/main/ets/default/utils/SystemPropertiesManager';
import { Algorithms } from '../../service/model/Enum';
import { systemDateTime, systemParameter } from '@kit.BasicServicesKit';

/* instrument ignore file */
const TAG = 'UiUtil';
type SystemBarKeys = 'status' | 'navigation';
let hideNavigationFn = -1

export class UiUtil {
  public static readonly SHORTS_TOAST_DURATION = 2000;
  public static readonly TOAST_DURATION = 3000;
  public static readonly PC_BORDER_BOTTOM: number = 7;
  public static readonly CAMERA_GEAR_SLIP_LIGHT_ID: string = 'haptic.camera.gear_slip_light';
  public static readonly CAMERA_GEAR_SLIP_HEAVY_ID: string = 'haptic.camera.gear_slip_heavy';
  public static readonly CAMERA_CLICK_EFFECT_ID: string = 'haptic.camera.click';
  public static isPrivacyPage: boolean = false;

  public static async showToast(msg: string | Resource, duration?: number, bottom: string = '50%') {
    HiLog.d(TAG, `showToast: ${msg}`);
    try {
    } catch (error) {
      let message = (error as BusinessError).message
      let code = (error as BusinessError).code
      HiLog.e(TAG, `showToast error code is ${code}, message is ${message}`);
    }
  }

  public static async getString(resource: Resource, context: Context): Promise<string | null> {
    try {
      let mgr: resourceManager.ResourceManager = context.resourceManager;
      if (mgr) {
        return await mgr.getStringValue(resource.id);
      }
    } catch (error) {
      HiLog.e(TAG, `getResourceString error${error}`);
    }
    return null;
  }

  public static getStringLength(value: string) {
    let length = 0;
    for (let i = 0; i < value.length; i++) {
      let code = value.charAt(i);
      if (code.match(new RegExp('[^\\x00-\\xff]', 'ig'))) {
        length += 2;
      } else {
        length += 1;
      }
    }
    return length;
  }


  public static vibrateById(id: string) {
    try {
      // 查询是否支持id
      vibrator.isSupportEffect(id, (err: BusinessError, state: boolean) => {
        if (err) {
          HiLog.e(TAG, `Failed to query effect. Code: ${err.code}, message: ${err.message}`);
          return;
        }
        HiLog.i(TAG, 'Succeed in querying effect');
        if (state) {
          UiUtil.vibrate(id)
        }
      })
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      HiLog.e(TAG, `An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  public static vibrate(id: string) {
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: id,
        count: 1,
      }, {
        usage: 'unknown',
      }, (error: BusinessError) => {
        if (error) {
          HiLog.e(TAG, `Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
        } else {
          HiLog.i(TAG, 'Succeed in starting vibration');
        }
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      HiLog.e(TAG, `An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 获取状态栏高度
   *
   * @returns 单位px
   */
  public static getStatusBarHeight(): number {
    let height = AppStorage.get(EDITOR_STATUS_BAR_HEIGHT_KEY) as number;
    return height;
  }

  public static sleep(time: number) {
    return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
  }

  /**
   * 获取裁剪框最大可操作区域（id:editor_page_operation_area）的绝对位置（基于窗口的坐标）
   *
   * @param paddingLR 叠加计算左右内边距（可用于计算因拓展热点区域增加的内边距）
   * @param paddingTB 叠加计算上下内边距（可用于计算因拓展热点区域增加的内边距）
   * @param winSize 应用窗口宽高，只获得left、top值可不传该参数
   * @returns 裁剪框最大可操作区域（id:editor_page_operation_area）的绝对位置
   */
  public static getOperationArea(paddingLR: number, paddingTB: number, winSize?: WinSize,
    isVertical: boolean = false): Rectangle {
    let isCustomFilterCardShow: boolean = AppStorage.get<boolean>('isCustomFilterCardShow') ?? false;
    let topHeight = vp2px((DeviceUtil.isPc() ? PC_TOP_BAR_HEIGHT : TOP_BAR_HEIGHT) +
      App.getInstance().screenClass.avoidTop);
    let bottomHeight = (DeviceUtil.isPhone() || DeviceUtil.isPad()) ? (isVertical ? vp2px(BOTTOM_HEIGHT)
      : 0) : 0;
    // 位置计算与PreviewStarter中timeline.operWidth、timeline.operHeight、timeline.operTop初始化逻辑保持一致
    let left = paddingLR;
    let top = topHeight + paddingTB;
    if (!winSize) {
      return new Rectangle(left, top, 0, 0);
    }

    let right = (DeviceUtil.isPhone() || DeviceUtil.isPad()) ?
      vp2px(winSize.width) - paddingLR -
        (isVertical ?
          0 : vp2px(BOTTOM_HEIGHT_SPLIT + ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight() - 6)
        ) : vp2px(winSize.width) - vp2px(RIGHT_BAR_HEIGHT) - paddingLR;
    let bottom = vp2px(winSize.height) - bottomHeight - paddingTB -
      (isVertical ? 0 : vp2px(App.getInstance().screenClass.avoidBottom));
    HiLog.i(TAG, `getOperationArea avoidTop ${App.getInstance().screenClass.avoidTop}  avoidLeft ${App.getInstance()
      .screenClass
      .avoidLeft} avoidBottom${App.getInstance().screenClass.avoidBottom}  avoidRight${App.getInstance()
      .screenClass
      .avoidRight} , bottom is ${bottom}, top is ${top}`);
    HiLog.d(TAG, 'getOperationArea window size ' + winSize.width + ` height ${winSize.height}`);
    return new Rectangle(left, top, right, bottom);
  }

  /**
   * 获取应用窗口状态栏高度
   *
   * @returns 单位vp
   */
  public static getWindowStatusHeight(): number {
    if (DeviceUtil.isPhone() || DeviceUtil.isPad()) {
      return 0;
    }
    if (ScreenManager.getInstance().isUIExtensionEnv()) {
      return TOP_BAR_HEIGHT;
    }

    try {
      let isFullScreen: boolean = false;
      let mainWindow: window.Window = LocalStorage.getShared()?.get('editor_mainWindow') as window.Window;
      if (mainWindow?.getWindowProperties?.()) {
        isFullScreen = DeviceUtil.isPc() && mainWindow.getWindowProperties?.().isFullScreen;
      }
      return isFullScreen ? TOP_BAR_HEIGHT : (mainWindow.getWindowDecorHeight?.() + TOP_BAR_HEIGHT)
    } catch (err) {
      HiLog.e(TAG, `getWindowStatusHeight failed, error message: ${err?.message}, error code: ${err?.code}`);
      return TOP_BAR_HEIGHT;
    }
  }

  public static convertResource2Num(rec: Resource): number {
    let resMgr = App.getInstance().instanceData().context.resourceManager;
    let statusBarHeightRes: resourceManager.Resource = {
      bundleName: rec.bundleName,
      moduleName: rec.moduleName,
      id: rec.id,
    }
    return resMgr.getNumber(statusBarHeightRes);
  }

  public static setWindowSystemBarProperties(isDark: boolean, context: Context) {
    try {
      window.getLastWindow(context, (err: BusinessError, data) => {
        const errCode: number = err.code;
        if (errCode) {
          HiLog.e(TAG, `Failed to obtain the top window. Cause: ${JSON.stringify(err)}`);
          return;
        }
        if (isDark) {
          data.setWindowSystemBarProperties({
            statusBarContentColor: Constants.NormalColor,
            statusBarColor: Constants.DarkColor,
          });
          return;
        }
        if (AppStorage.get('currentColorMode') !== ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
          data.setWindowSystemBarProperties({
            statusBarContentColor: Constants.DarkColor,
            statusBarColor: Constants.NormalColor,
          });
        }
      });
    } catch (exception) {
      HiLog.e(TAG, `Failed to obtain the top window. Cause: ${JSON.stringify(exception)}`);
    }
  }

  /**
   * Get the content of the resource reference
   *
   * @param resource resource reference
   * @returns resource Corresponding content number
   */
  public static getResourceNumber(resource: Resource): number {
    let resMgr = App.getInstance().instanceData().context.resourceManager;
    if (resource.moduleName === 'browserlibrary') {
      resMgr = (GlobalThisUtil.getLocalProperty('photoLibraryContext') as Context).resourceManager;
    }

    return resMgr?.getNumber(resource.id) ?? Number.NaN;
  }

  public static hideStatusBar() {
    HiLog.i(TAG, 'hideStatusBar is start')
    ScreenManager.getInstance().getMainWindow()?.setSpecificSystemBarEnabled('status', false, false);
  }

  public static hideNavigationBar(isShow: boolean) {
    HiLog.i(TAG, 'hideNavigationBar is start')
    clearTimeout(hideNavigationFn);
    ScreenManager.getInstance().getMainWindow()?.setSpecificSystemBarEnabled('navigationIndicator', true, false);
    if (!isShow) {
      hideNavigationFn = setTimeout((): void => {
        ScreenManager.getInstance().getMainWindow()?.setSpecificSystemBarEnabled('navigationIndicator', false, false);
      }, 2000);
    }
  }

  public static async showStatusBar(isShow: boolean): Promise<void> {
    if (ScreenManager.getInstance().isUIExtensionEnv()) {
      return;
    }
    HiLog.i(TAG, 'showStatusBar start')

    let topWindow: window.Window = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    await topWindow?.setWindowLayoutFullScreen(true);
    try {
      topWindow?.setWindowSystemBarProperties(
        {
          statusBarColor: isShow ? '#00000000' : '#00FFFFFF',
          statusBarContentColor: isShow ? '#FFFFFFFF' : '#000000',
        }, (): void => {
        HiLog.i(TAG, 'showStatusBar() setStatusBarColor done, content color is' + (isShow ? 'white' : 'black'));
      });
    } catch (err) {
      HiLog.e(TAG, `showStatusBar() setStatusBarColor err: ${err}, code: ${err?.code}`);
    }
  }

  public static resetStatusAndNavigation() {
    if (ScreenManager.getInstance().isUIExtensionEnv()) {
      return;
    }
    let isPortrait = ScreenManager.getInstance().isScreenPortrait();
    let isFold = ScreenManager.getInstance().isDeviceFold();
    let isPad = DeviceUtil.isPad();
    if (isPortrait || !isFold || isPad) {
      ScreenManager.getInstance().getMainWindow()?.setSpecificSystemBarEnabled('status', true, false);
    }
    ScreenManager.getInstance().getMainWindow()?.setSpecificSystemBarEnabled('navigationIndicator', true, false);
  }

  public static setSystemUI(enable: boolean): void {
    if (ScreenManager.getInstance().isUIExtensionEnv()) {
      return;
    }
    HiLog.i(TAG, `setSystemUI enable: ${enable}`);
    let topWindow: window.Window = LocalStorage.getShared()?.get('editor_mainWindow') as window.Window;
    let names: SystemBarKeys[] = ['status', 'navigation'];
    if (DeviceUtil.isPc()) {
      names = ['navigation'];
    }
    topWindow?.setWindowSystemBarEnable(names);
  }

  // 是否为镜像模式
  public static isMirrorMode(): boolean {
    return Configuration.getLocale().dir === DIRECTION_RTL;
  }

  public static isSystemStatus() {
    HiLog.i(TAG, 'isSystemStatus isPrivacyPage %{public}s', UiUtil.isPrivacyPage)
    if (ScreenManager.getInstance().isUIExtensionEnv() || UiUtil.isPrivacyPage) {
      HiLog.w(TAG, 'Current Page is UIExtensionEnv')
      return;
    }
    let isPortrait = ScreenManager.getInstance().isScreenPortrait()
    UiUtil.showStatusBar(true);
    UiUtil.hideStatusBar();
    if (!isPortrait) {
      UiUtil.hideNavigationBar(false);
    } else {
      UiUtil.hideNavigationBar(true);
    }
  }

  //获取UIAbilityContext
  public static getUIAbilityContext(): common.UIAbilityContext {
    let hspModuleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext') as common.UIAbilityContext;
    let abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as common.UIAbilityContext;
    return hspModuleContext ? hspModuleContext : abilityContext;
  }

  //获取资源对象中的string数据
  public static getResourceString(resource: Resource | string, ...params: Array<string | number>): string {
    try {
      if (typeof resource === 'string') {
        return resource as string;
      }
      resource as Resource;
      if (resource === null) {
        HiLog.e(TAG, 'getResourceString param resource is null.');
        return '';
      }
      return UiUtil.getUIAbilityContext()
        .resourceManager
        .getStringSync((resource as Resource).id, ...params.map(String));
    } catch (error) {
      HiLog.e(TAG, `getResourceString error: ${error}, code: ${error?.code}`);
      return '';
    }
  }

  //获取资源对象中的string数据
  public static async getContextResourceText(context: Context, resource: Resource | string): Promise<string> {
    try {
      if (typeof resource === 'string') {
        return resource as string;
      }
      if (resource === null) {
        HiLog.e(TAG, 'getResourceString param resource is null.');
        return '';
      }
      return await (context || UiUtil.getUIAbilityContext())
        .resourceManager.getStringValue(resource);
    } catch (error) {
      HiLog.e(TAG, `getResourceString error: ${error}, code: ${error?.code}`);
      return '';
    }
  }

  public static getPreviewRectOffset(): number {
    let curLanguage = AppStorage.get<string>(CURRENT_LANGUAGE);
    let isRTL = i18n.isRTL(curLanguage)
    if (isRTL) {
      let isPortrait = ScreenManager.getInstance().isScreenPortrait();
      let offsetLeft = BOTTOM_HEIGHT_SPLIT - 6;
      // pad左部偏移量
      if (DeviceUtil.isPad()) {
        return (isPortrait ? LEFT_PORTRAIT_OFFSET_PAD : offsetLeft) +
        App.getInstance().screenClass.avoidLeft;
      }
      // 手机左部偏移量
      if (DeviceUtil.isPhone()) {
        if (ScreenManager.getInstance().isDeviceFold()) {
          return (isPortrait ? LEFT_PORTRAIT_OFFSET_PHONE : offsetLeft) +
          App.getInstance().screenClass.avoidLeft;
        } else {
          return isPortrait ? LEFT_PORTRAIT_OFFSET_PHONE : offsetLeft +
          App.getInstance().screenClass.avoidLeft;
        }
      }
    }
    return 0;
  }

  public static checkAlgorithms(algorithms: Algorithms): boolean {
    let key = '';
    switch (algorithms) {
      case Algorithms.Haze_Removal:
        key = 'const.camera.support_image_process.de_haze';
        break;
      case Algorithms.IntelligentCorrection:
        key = 'const.camera.support_image_process.horizontal_correction';
        break;
      case Algorithms.XTStyle:
        key = 'const.camera.support_image_process.xt_code';
        break;
      case Algorithms.WideAperture:
        key = 'const.camera.support_image_process.visual_effect';
        break;
      default:
        HiLog.w(TAG, 'checkAlgorithms wrong');
        return false;
    }
    let configurationStatus = SystemPropertiesManager.getInstance().get(key, 'false') ===
      'true';
    HiLog.i(TAG, `checkAlgorithms:${algorithms},key:${key},configurationStatus:${configurationStatus}`);
    return configurationStatus;
  }

  /**
   * 获取设备自启动后的时间，包括睡觉时间，单位ms/ns
   *
   * @param isNanoseconds 是否使用纳米时间
   * @returns 时间
   */
  public static getStartUpTime(isNanoseconds?: boolean, defaultValue: number = 0): number {
    try {
      return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, isNanoseconds);
    } catch (error) {
      HiLog.e(TAG, `getStartUpTime failed. code ${error.code}`);
    }
    return defaultValue;
  }

  public static addWindowWaterMark(): void {
    let isWindowWaterMarkSwitchOpened: boolean = systemParameter.getSync('const.product.hide', 'false') === 'true';
    HiLog.i(TAG, `isWindowWaterMarkSwitchOpened: ${isWindowWaterMarkSwitchOpened}`);
    if (isWindowWaterMarkSwitchOpened) {
      let isPicker: boolean = AppStorage?.get('isPickerPage') ?? false;
      let mainWindow: window.Window | undefined =
        isPicker ? LocalStorage.getShared()?.get<window.Window>('photosUiExtensionStage') :
        LocalStorage.getShared()?.get<window.Window>('mainWindow');
      if (mainWindow) {
        mainWindow.setWaterMarkFlag(true, (err: BusinessError<void>): void => {
          if (err.code) {
            HiLog.e(TAG, `Failed to set window water mark. Cause: ${err}`);
            return;
          }
          HiLog.i(TAG, 'Succeeded in setting window water mark.');
        });
      }
    }
  }

  /**
   * 根据当前语言和字体缩放比例获取字体大小
   *
   * @param currentLanguage 从LocalStorage获取的当前语言
   * @param language 从AppStorage获取的当前语言
   * @param fontScale 系统字体缩放比例
   * @returns 字体大小，单位vp
   */
  public  static  getFontSize(currentLanguage: string,language: string,fontScale: number): string{
    const actualLang = currentLanguage || language;
    const isChinese = actualLang?.trim().toLowerCase().startsWith('zh');
    // 中文环境下：大字体(>1.45)用17.5vp，否则12vp
    // 非中文环境：固定用9vp
    return isChinese ? (fontScale>1.45 ? '17.4vp' : '12vp') : '9.5vp';
  }

  /**
   * 根据当前语言和字体缩放比例获取胶囊宽度
   *
   * @param currentLanguage 从LocalStorage获取的当前语言
   * @param language 从AppStorage获取的当前语言
   * @param fontScale 系统字体缩放比例
   * @returns 胶囊宽度，单位vp
   */
  public  static  getWidthSize(currentLanguage: string,language: string,fontScale: number):string{
    const actualLang = currentLanguage || language;
    const isChinese = actualLang?.trim().toLowerCase().startsWith('zh');
    // 中文环境下：大字体(>1.45)用75vp，否则65vp
    // 非中文环境：固定用75vp
    return isChinese ? (fontScale > 1.45 ? '75vp' : '65vp') : '75vp';
  }

  public static calculateGradientAngle(start: Point, end: Point): number {
    // 计算两点之间的向量
    const dx = end.x - start.x;
    const dy = end.y - start.y;

    // 使用 Math.atan2(dy, dx) 计算角度
    // Math.atan2 返回的是弧度值，需要转换为角度
    const radian = Math.atan2(dy, dx);
    const degree = radian * (180 / Math.PI);

    console.info(`degree:${degree}`);
    // 根据实际情况调整角度
    // 从左上角到右下角的角度通常是 45 度
    return (90 + degree) % 360;
  }
}

interface Point {
  x: number;
  y: number;
}