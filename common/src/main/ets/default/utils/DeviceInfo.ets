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

import lazy deviceInfo from '@ohos.deviceInfo';
import lazy display from '@ohos.display';
import type common from '@ohos.app.ability.common';
import lazy window from '@ohos.window';
import lazy { systemParameter } from '@kit.BasicServicesKit';
import lazy { Log } from './Log';

import lazy { WindowUtil } from './WindowUtil';
import lazy { PreviewItemConstants } from '../model/common/Constants';
import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy { FoldUtil } from './FoldUtil';
import lazy { SystemPropertiesManager } from './SystemPropertiesManager';
import lazy { Constants } from '../model/common/Constants';
import { tag } from '@kit.ConnectivityKit';

const TAG: string = 'DeviceInfo';

enum DeviceType {
  PHONE,
  TABLET,
  TWO_IN_ONE,
  TV
}

enum HardWareType {
  KIRIN_9020 = 'kirin9020'
}

/**
 * Querying the Device Type
 *
 * default：智能手机  RK设备
 * phone: 智能手机  非RK设备
 * 2in1：平板
 * tablet：平板
 * tv：智慧屏
 * wearable：智能穿戴
 * liteWearable：轻量级智能穿戴
 * smartVision：智慧视觉设备
 */
export class DeviceInfo {
  public static readonly FOLD_SCREEN_PRODUCT_PROPERTY = 'const.window.foldscreen.type';
  // ADU类型样机
  public static readonly FOLD_SCREEN_PROTOTYPE_PROPERTY_ADU = 'const.dfx.enable_retail';
  public static readonly SMALL_FOLD_SCREEN_VALUE: string = '2,';
  public static readonly SMALL_FOLD_SCREEN_VALUE_4: string = '4,';
  public static readonly GRL_FOLD_SCREEN_VALUE_6: string = '6,';
  public static readonly SUPER_LAUNCHER_DISPLAY_NAME: string = 'SuperLauncher';
  private static isSmallFold?: boolean = undefined;
  private static isGRLFold?: boolean = undefined;
  private static isFoldAble?: boolean = undefined;
  private static foldScreenProperty?: string = undefined;
  private static deviceTypeMap: Map<string, DeviceType> =
    new Map<string, DeviceType>([
      ['phone', DeviceType.PHONE],
      ['tablet', DeviceType.TABLET],
      ['2in1', DeviceType.TWO_IN_ONE],
      ['tv', DeviceType.TV],
    ]);
  private static isVdeFold?: boolean = undefined;
  private static isNsvDevice?: boolean = undefined;
  private static isNormalDevice?: boolean = undefined;

  public static isTablet(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      return FoldUtil.isTriExpand(FoldUtil.getInstance().getCurFoldStatus());
    }
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.TABLET;
  }

  /**
   * 设备是否为平板
   *
   * @returns 是平板设备返回true
   */
  public static isTabletDevice(): boolean {
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.TABLET;
  }

  /**
   * 设备是xxx（包含xxx、xxx）
   *
   * @returns xxx设备返回true
   */
  public static isFoldDevice(): boolean {
    /* instrument ignore if */
    if (DeviceInfo.isFoldAble !== undefined) {
      return DeviceInfo.isFoldAble;
    }
    DeviceInfo.isFoldAble = false;
    try {
      DeviceInfo.isFoldAble = display.isFoldable();
    } catch (error) {
      /* instrument ignore next */
      Log.error(TAG, 'failed to get fold');
    }
    return DeviceInfo.isFoldAble;
  }

  public static isPc(): boolean {
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.TWO_IN_ONE;
  }

  /**
   * 判断为Phone以外的设备时, 建议使用 !DeviceInfo.isPhone()
   */
  public static isPcOrTablet(): boolean {
    return DeviceInfo.isTablet() || DeviceInfo.isPc();
  }

  public static isPhoneOrTablet(): boolean {
    return DeviceInfo.isPhone() || DeviceInfo.isTablet();
  }

  /**
   * 笔记本电脑
   */
  public static isHym(): boolean {
    return deviceInfo.productSeries === 'HYM';
  }

  /**
   * 判断是否支持动态照片来回播放特性
   */
  public static isSupportBouncePlay(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.movingPhoto_bounce_play.enable', 'false') === 'true';
  }

  /**
   * 判断是否移出删除场景模糊动效
   */
  public static isSupportRemoveBlurEnabled(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.removeBlur.enable', 'false') === 'true';
  }

  /**
   * 判读是否支持进入PNG大图时添加背景色
   */
  public static isSupportOpenPNGBrowserBackGroundEnabled(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.openPNGBrowserBackGround.enable', 'false') === 'true';
  }

  /**
   * 判读是否支持退出PNG大图时添加背景色
   */
  public static isSupportClosePNGBrowserBackGroundEnabled(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.closePNGBrowserBackGround.enable', 'false') === 'true';
  }

  /**
   * 判断图片编辑是否支持轻量级视效，true:表示支持，裁剪页去掉高斯模糊;false：表示不支持，默认为false
   */
  public static isSupportLiteVisualEffect(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photos.editor_lite_visual_effect.enable', 'false') === 'true';
  }

  /**
   * 判断是否支持将动态照片中视频拼接导出特性
   */
  public static isSupportSplice(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.movingPhoto_splice.enable', 'false') === 'true';
  }

  // 判断是否支持一键成片
  public static isSupportMovie(): boolean {
    return SystemPropertiesManager.getInstance().get('const.photo.moviePage_movie.enable', 'true') === 'true';
  }

  /**
   * 判断是否支持一拍多得, true: 支持, false: 不支持，默认为false
   */
  public static isSupportUltraPhoto(): boolean {
    return systemParameterEnhance.getSync('const.photo.support_ultraphoto', 'false') === 'true';
  }

  /**
   * 判断是否支持Debug, true: 支持, false: 不支持，默认为false
   */
  public static isDebugEnable(): boolean {
    return systemParameterEnhance.getSync('const.sys.photos.editor.debug.enable', 'false') === 'true';
  }

  /**
   * 判断是否为手机UX显示，包括xxxM、F态
   */
  public static isPhoneUx(): boolean {
    /* instrument ignore if */
    //todo 先注释pc也用手机手机的ui
    // if (DeviceInfo.isGRLFoldScreen()) {
    //   return !FoldUtil.isTriExpand(FoldUtil.getInstance().getCurFoldStatus());
    // }
    // return DeviceInfo.isPhoneExact() || DeviceInfo.isDefault();
    return true
  }

  /**
   * 判断是否为手机产品，包括xxx
   */
  public static isPhone(): boolean {
    /* instrument ignore if */
    return DeviceInfo.isPhoneExact() || DeviceInfo.isDefault();
  }

  public static isTv(): boolean {
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.TV;
  }

  /**
   * 智能手机  RK设备
   * 判断为Phone设备时, 建议使用 DeviceInfo.isPhone()
   */
  /* instrument ignore next */
  private static isDefault(): boolean {
    return !DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType);
  }

  /**
   * 智能手机  非RK设备
   * 判断为Phone设备时, 建议使用 DeviceInfo.isPhone()
   */
  private static isPhoneExact(): boolean {
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.PHONE;
  }

  /**
   * 根据屏幕判断
   * 是否为xxx、xxx
   */
  public static isFoldable(): boolean {
    /* instrument ignore if */
    if (DeviceInfo.isNormalPhone() || DeviceInfo.isPhoneVde() || DeviceInfo.isPc()) {
      return false;
    }
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      try {
        let foldState = display.getFoldStatus();
        if ((foldState === display.FoldStatus.FOLD_STATUS_EXPANDED ||
          foldState === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) &&
          display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Log.error(TAG, 'get isFoldable fail');
      }
    }
    try {
      return display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    } catch (e) {
      Log.error(TAG, `parse isFoldable fail, stack ${e?.stack}, code ${e?.code}`);
      return false;
    }
  }

  /**
   * 根据机型判断
   * 是否为xxx手机
   */
  public static isFoldablePhone(): boolean {
    return deviceInfo.productModel === 'ALT-AL10' || deviceInfo.productModel === 'HWL-AL20' || deviceInfo.productModel === 'NCJ-AL10' || deviceInfo.productModel === 'NCJ-AL20';
  }

  /**
   * 根据机型判断
   * 是否为VDE手机
   */
  public static isPhoneVde(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isVdeFold !== undefined) {
      return DeviceInfo.isVdeFold;
    }
    let productProperty: string = DeviceInfo.getFoldScreenProperty();
    Log.info(TAG, `isPhoneVde productProperty = ${productProperty}`);
    DeviceInfo.isVdeFold = productProperty.startsWith(DeviceInfo.SMALL_FOLD_SCREEN_VALUE_4);
    return DeviceInfo.isVdeFold;
  }

  /**
   * 根据机型、屏幕判断
   * 是否为xxx
   */
  public static isVerdeFoldable(): boolean {
    try {
      return DeviceInfo.isPhoneVde() && display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN;
    } catch (e) {
      Log.error(TAG, `parse isVerdeFoldable error, stack ${e?.stack}, code ${e?.code}`)
      return false;
    }
  }

  /**
   * 安全隐私规范要求：在未经用户同意情况下不允许获取ODID
   * 此处不允许修改为deviceInfo.ODID 否则违反隐私安全问题
   * @returns
   */
  public static getODID(): string {
    return '00000000-0000-0000-0000-000000000000';
  }

  /**
   * 判断当前是否为模拟器
   */
  public static isEmulator(): boolean {
    return deviceInfo.productModel === 'emulator';
  }

  /**
   * 判断当前是否为xxxxxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isSmallFoldState(): boolean {
    try {
      return DeviceInfo.isSmallFoldScreen() && display.getFoldDisplayMode() ===
      display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
    } catch (e) {
      Log.error(TAG, `parse isSmallFoldState error, stack ${e?.stack}, code ${e?.code}`)
      return false;
    }
  }

  /**
   * 判断当前是否为xxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isHalfFoldState(): boolean {
    try {
      return DeviceInfo.isSmallFoldScreen() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
    } catch (e) {
      Log.error(TAG, `parse isHalfFoldState error, stack ${e?.stack}, code ${e?.code}`)
      return false;
    }
  }

  /**
   * 判断当前是否为xxxxxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isSmallFoldExpanded(): boolean {
    try {
      return DeviceInfo.isSmallFoldScreen() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED;
    } catch (e) {
      Log.error(TAG, `parse isSmallFoldExpanded error, stack ${e?.stack}, code ${e?.code}`)
      return false;
    }
  }

  /**
   * 判断当前产品是否为GRL
   *
   * @returns true:是GRL, false:非GRL
   */
  public static isGRLFoldScreen(): boolean {
    /* instrument ignore if */
    if (DeviceInfo.isGRLFold !== undefined) {
      return DeviceInfo.isGRLFold;
    }
    let productProperty: string = DeviceInfo.getFoldScreenProperty();
    /* instrument ignore if */
    if (productProperty.startsWith(DeviceInfo.GRL_FOLD_SCREEN_VALUE_6)) {
      DeviceInfo.isGRLFold = true;
      return true;
    }
    DeviceInfo.isGRLFold = false;
    return false;
  }

  /**
   * 获取产品属性const.window.foldscreen.type
   *
   * @returns property
   */
  private static getFoldScreenProperty(): string {
    if (DeviceInfo.foldScreenProperty !== undefined) {
      return DeviceInfo.foldScreenProperty;
    }
    let tmpProperty: string = SystemPropertiesManager.getInstance().get(DeviceInfo.FOLD_SCREEN_PRODUCT_PROPERTY);
    DeviceInfo.foldScreenProperty = tmpProperty;
    Log.info(TAG, `productProperty = ${tmpProperty}`);
    return tmpProperty;
  }

  /**
   * 判断当前设备是否是xxx设备
   *
   * @returns true:是xxx, false:是xxx
   */
  public static isSmallFoldScreen(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isSmallFold !== undefined) {
      return DeviceInfo.isSmallFold;
    }
    let productProperty: string = DeviceInfo.getFoldScreenProperty();
    /* instrument ignore if */
    if (productProperty.startsWith(DeviceInfo.SMALL_FOLD_SCREEN_VALUE)) {
      DeviceInfo.isSmallFold = true;
      return true;
    }
    DeviceInfo.isSmallFold = false;
    return false;
  }

  /**
   * 获取不同设备首屏的照片个数，用于预显示数据
   *
   * @returns 不同设备首屏的照片个数
   */
  public static getFirstPatchNum(): number {
    if (DeviceInfo.isPhoneUx()) {
      /* instrument ignore else */
      if (!DeviceInfo.isHalfFoldState()) {
        return PreviewItemConstants.PHONE_UNFOLD;
      } else {
        return PreviewItemConstants.PHONE_LAUNCH_PHOTO_NUMBER;
      }
    } else if (DeviceInfo.isPc()) {
      /* instrument ignore next */
      return PreviewItemConstants.PC_LAUNCH_PHOTO_NUMBER;
    } else if (DeviceInfo.isTablet()) {
      /* instrument ignore next */
      return PreviewItemConstants.PAD_LAUNCH_PHOTO_NUMBER;
    } else {
      /* instrument ignore next */
      return PreviewItemConstants.PHONE_LAUNCH_PHOTO_NUMBER;
    }
  }

  /**
   * 判断设备是否是NSV平台
   *
   * @returns true: NSV平台, false: 非NSV平台
   */
  public static isNSVPlatform(): boolean {
    if (DeviceInfo.isNsvDevice !== undefined) {
      return DeviceInfo.isNsvDevice;
    }
    let hardWardType: string = SystemPropertiesManager.getInstance().get('ohos.boot.hardware', '');
    DeviceInfo.isNsvDevice = hardWardType.includes(HardWareType.KIRIN_9020);
    return DeviceInfo.isNsvDevice;
  }

  /**
   * 根据机型、屏幕判断
   * 是否为GRLxxx（G态）
   *
   * @returns true:是GRL-G态, false:非GRL-G态
   */
  public static isGRLFoldExpanded(): boolean {
    try {
      return DeviceInfo.isGRLFoldScreen() &&
        display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    } catch (e) {
      Log.error(TAG, `parse isGRLFoldExpanded error, stack ${e?.stack}, code ${e?.code}`)
      return false;
    }
  }

  /**
   * 是否为GRL双轴全xxx
   * @returns
   */
  public static isGRLFullExpanded(): boolean {
    return DeviceInfo.isGRLFoldScreen() &&
      FoldUtil.getInstance().getCurFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED_WITH_SECOND_EXPANDED;
  }

    /**
   * 根据机型、屏幕判断
   * 是否为GRL-M态
   *
   * @returns true:是GRL-M态, false:非GRL-M态
   */
  public static isGRLMStatus(): boolean {
    return DeviceInfo.isGRLFoldScreen() &&
      FoldUtil.getInstance().getCurFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED &&
      AppStorage.get<number>('windowStatus') !== window.WindowStatusType.SPLIT_SCREEN;
  }

  /**
   * 判断当前是否为PCxxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isPcHalfFoldState(): boolean {
    let screenFoldStatus: boolean = false;
    try {
      screenFoldStatus = (display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
    } catch (e) {
      /* instrument ignore next */
      Log.error(TAG, 'getFoldStatus error:' + e);
    }
    return DeviceInfo.isPc() && screenFoldStatus;
  }

  /**
   * 判断当前是否为PCxxx
   *
   * @returns
   */
  public static isPcFold(): boolean {
    let screenFoldStatus: boolean = false;
    try {
      screenFoldStatus = (display.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_UNKNOWN);
    } catch (e) {
      /* instrument ignore next */
      Log.error(TAG, 'isPcFold error:' + e);
    }
    return DeviceInfo.isPc() && screenFoldStatus;
  }

  /**
   * 获取产品属性const.dfx.enable_retail
   *
   * @returns true:ADU样机, false:非ADU样机
   */
  public static isPrototypeAdu(): boolean {
    return SystemPropertiesManager.getInstance().get(DeviceInfo.FOLD_SCREEN_PROTOTYPE_PROPERTY_ADU, 'false') === 'true';
  }

  /**
   * 获取产品属性device_enable_retail
   *
   * @returns true:LDU样机, false:非LDU样机
   */
  public static isPrototypeLdu(): boolean {
    /* instrument ignore if */
    if (AppStorage.get<boolean>(Constants.DEVICE_ENABLE_RETAIL)) {
      return true;
    }
    return false;
  }

  /**
   * 判断是否是超级桌面(车机)
   *
   * @returns
   */
  public static isSuperLauncher(): boolean {
    try {
      const displayClass: display.Display = display.getDefaultDisplaySync();
      return displayClass?.name === DeviceInfo.SUPER_LAUNCHER_DISPLAY_NAME;
    } catch (error) {
      Log.error(TAG, `check superLauncher error: ${error}, code: ${error?.code}`);
      return false;
    }
  }

  /**
   * 根据机型判断
   * 是否为PSD手机
   *
   * @returns true:PSD样机, false:非PSD样机
   */
  public static isPhonePSD(): boolean {
    return deviceInfo.productSeries === 'PSD';
  }

  /**
   * 判断QXS当前是PC模式还是平板模式
   *
   * @returns true：PC模式 false：平板模式
   */
  public static isPCMode(): boolean {
    return SystemPropertiesManager.getInstance().get('persist.sceneboard.ispcmode', 'true') === 'true';
  }

  /**
   * 判断是否支持个性色卡(在图片编辑中nova继承XXX特性，但无xmage效果，因此nova为支持个性色卡，旗舰目前为默认值false，使用xmage风格)
   *
   * @returns true:支持个性色卡(nova使用), false:不支持个性色卡(使用xmage风格)
   */
  public static isSupportCustomFilterEnabled(): boolean {
    return systemParameterEnhance.getSync('const.photo.custom_filter.enable', 'false') === 'true';
  }

  /**
   * 判断是否是直板机
   *
   * @returns true:是直板机
   */
  public static isNormalPhone(): boolean{
    if (DeviceInfo.isNormalDevice !== undefined){
      return DeviceInfo.isNormalDevice;
    }
    DeviceInfo.isNormalDevice = SystemPropertiesManager.getInstance().get(DeviceInfo.FOLD_SCREEN_PRODUCT_PROPERTY) === '';
    Log.info(TAG, `isNormalPhone = ${DeviceInfo.isNormalDevice}`);
    return DeviceInfo.isNormalDevice;
  }
}