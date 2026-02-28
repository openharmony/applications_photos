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

const TAG: string = 'DeviceInfo';

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
  static readonly DEFAULT: number = 0;
  static readonly PHONE: number = 1;
  static readonly TABLET: number = 2;
  static readonly TWO_IN_ONE: number = 3;

  public static readonly FOLD_SCREEN_PRODUCT_PROPERTY = 'const.window.foldscreen.type';
  public static readonly SMALL_FOLD_SCREEN_VALUE: string = '2,';
  private static isSmallFold?: boolean = undefined;
  private static foldScreenProperty?: string = undefined;

  private static deviceTypeValue: number =
    deviceInfo.deviceType === 'phone' ? DeviceInfo.PHONE :
      (deviceInfo.deviceType === 'tablet' ? DeviceInfo.TABLET :
        (deviceInfo.deviceType === '2in1' ? DeviceInfo.TWO_IN_ONE :
        DeviceInfo.DEFAULT));

  public static isTablet(): boolean {
    return DeviceInfo.deviceTypeValue === DeviceInfo.TABLET;
  }

  public static isPc(): boolean {
    return DeviceInfo.deviceTypeValue === DeviceInfo.TWO_IN_ONE;
  }

  /**
   * 判断为Phone以外的设备时, 建议使用 !DeviceInfo.isPhone()
   */
  public static isPcOrTablet(): boolean {
    return DeviceInfo.isTablet() || DeviceInfo.isPc();
  }

  /**
   * 笔记本电脑
   */
  public static isHym(): boolean {
    return deviceInfo.productSeries === 'HYM';
  }

  public static isPhone(): boolean {
    return DeviceInfo.isPhoneExact() || DeviceInfo.isDefault();
  }

  /**
   * 智能手机  RK设备
   * 判断为Phone设备时, 建议使用 DeviceInfo.isPhone()
   */
  private static isDefault(): boolean {
    return DeviceInfo.deviceTypeValue === DeviceInfo.DEFAULT;
  }

  /**
   * 智能手机  非RK设备
   * 判断为Phone设备时, 建议使用 DeviceInfo.isPhone()
   */
  private static isPhoneExact(): boolean {
    return DeviceInfo.deviceTypeValue === DeviceInfo.PHONE;
  }

  /**
   * 根据屏幕判断
   * 是否为xxxxxx
   */
  public static isFoldable(): boolean {
    return display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
  }

  /**
   * 根据机型判断
   * 是否为xxx手机
   */
  public static isFoldablePhone(): boolean {
    return deviceInfo.productModel === 'ALT-AL10';
  }

  public static getODID(): string {
    return deviceInfo.ODID;
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
    return DeviceInfo.isSmallFoldScreen() &&
      display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
  }

  /**
   * 判断当前是否为xxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isHalfFoldState(): boolean {
    return DeviceInfo.isSmallFoldScreen() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
  }

  /**
   * 判断当前是否为xxxxxx
   *
   * @returns true:xxx, false:xxx
   */
  public static isSmallFoldExpanded(): boolean {
    return DeviceInfo.isSmallFoldScreen() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED;
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
    let tmpProperty: string = '';
    try {
      tmpProperty = systemParameter.getSync(DeviceInfo.FOLD_SCREEN_PRODUCT_PROPERTY);
    } catch (e) {
      Log.error(TAG, 'getFoldScreenProperty error:' + e);
    }
    DeviceInfo.foldScreenProperty = tmpProperty;
    return tmpProperty;
  }

  /**
   * 判断当前设备是否是xxx设备
   *
   * @returns true:是xxx, false:是xxx
   */
  public static isSmallFoldScreen(): boolean {
    if (DeviceInfo.isSmallFold !== undefined) {
      return DeviceInfo.isSmallFold;
    }
    let productProperty: string = DeviceInfo.getFoldScreenProperty();
    Log.info(TAG, `productProperty = ${productProperty}`);
    if (productProperty.startsWith(DeviceInfo.SMALL_FOLD_SCREEN_VALUE)) {
      DeviceInfo.isSmallFold = true;
      return true;
    }
    DeviceInfo.isSmallFold = false;
    return false;
  }

  /**
   * 设置图片浏览界面是否响应窗口横竖屏旋转
   *
   * @param isRotation
   */
  /* instrument ignore next */
  public static setRotationCapability(isRotation: boolean): void {
    Log.info(TAG, `setRotationCapability isRotation: ${isRotation}`);
    let context: common.UIAbilityContext =
      AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    if (isRotation) {
      WindowUtil.setPreferredOrientation(context, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    } else {
      WindowUtil.setPreferredOrientation(context, window.Orientation.PORTRAIT);
    }
  }
}