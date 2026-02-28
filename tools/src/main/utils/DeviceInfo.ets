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
import lazy { systemParameter } from '@kit.BasicServicesKit';
import lazy { Log } from './Log';

const TAG: string = 'DeviceInfo';

enum DeviceType {
  PHONE,
  TABLET,
  TWO_IN_ONE,
  TV
}

/* instrument ignore file */
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
  private static deviceTypeMap: Map<string, DeviceType> =
    new Map<string, DeviceType>([
      ['phone', DeviceType.PHONE],
      ['tablet', DeviceType.TABLET],
      ['2in1', DeviceType.TWO_IN_ONE],
      ['tv', DeviceType.TV],
    ]);
  private static foldScreenProperty?: string = undefined;
  public static readonly FOLD_SCREEN_PRODUCT_PROPERTY = 'const.window.foldscreen.type';
  private static isVdeFold?: boolean = undefined;
  private static isSmallFold?: boolean = undefined;
  public static readonly SMALL_FOLD_SCREEN_VALUE: string = '2,';
  public static readonly SMALL_FOLD_SCREEN_VALUE_4: string = '4,';
  private static isGRLFold?: boolean = undefined;
  public static readonly GRL_FOLD_SCREEN_VALUE_6: string = '6,';
  /* GRL 设备 G态xxx */
  // G态
  public static readonly FOLD_STATE_EXPAND_WITH_SECOND_EXPAND: number = 11;
  // 13 xxx (G态)
  public static readonly FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND: number = 13;
  // xxx(G态)
  public static readonly FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED: number = 21;
  // xxx (G态)
  public static readonly FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED: number = 23;
  // xxx和xxx
  public static readonly FOLD_STATE_FOLDED_WITH_SECOND_HALF_FOLDED: number = 22;
  // N态
  public static readonly FOLD_STATE_FOLDED_WITH_SECOND_EXPAND: number = 12;
  private static isFoldAble?: boolean = undefined;

  public static isTablet(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      try {
        return DeviceInfo.isTriExpand(display.getFoldStatus());
      } catch (e) {
        Log.error(TAG, 'isTablet fail');
      }
    }
    return DeviceInfo.deviceTypeMap.get(deviceInfo.deviceType) === DeviceType.TABLET;
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

  /**
   * 笔记本电脑
   */
  public static isHym(): boolean {
    return deviceInfo.productSeries === 'HYM';
  }

  /**
   * 判断是否为手机UX显示，包括xxxM、F态
   */
  public static isPhoneUx(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      try {
        return !DeviceInfo.isTriExpand(display.getFoldStatus());
      } catch (e) {
        Log.error(TAG, 'get isPhoneUx fail');
        return false;
      }
    }
    return DeviceInfo.isPhoneExact() || DeviceInfo.isDefault();
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
    /* instrument ignore next */
    if (DeviceInfo.isPhoneVde()) {
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
    return display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
  }

  /**
   * 根据机型判断
   * 是否为xxx手机
   */
  public static isFoldablePhone(): boolean {
    return deviceInfo.productModel === 'ALT-AL10' || deviceInfo.productModel === 'HWL-AL20';
  }

  /**
   * 根据机型、屏幕判断
   * 是否为xxx
   */
  public static isVerdeFoldable(): boolean {
    return DeviceInfo.isPhoneVde() && display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN;
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
   * 根据机型、xxx判断
   * 是否为xxx手机的xxx
   * @returns
   */
  public static isFoldDisplayModeFull(): boolean {
    return display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
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
   * 安全隐私规范要求：在未经用户同意情况下不允许获取AAID
   * 异步方法兼容AAID.getAAID()
   * @returns
   */
  public static async getAAID(): Promise<string> {
    return '00000000-0000-0000-0000-000000000000';
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
      Log.error(TAG, `getFoldScreenProperty error:${e}`);
    }
    DeviceInfo.foldScreenProperty = tmpProperty;
    return tmpProperty;
  }

  /**
   * 根据机型、屏幕判断
   * 是否为GRLxxx（G态）
   *
   * @returns true:是GRL-G态, false:非GRL-G态
   */
  public static isGRLFoldExpanded(): boolean {
    return DeviceInfo.isGRLFoldScreen() &&
      display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
  }

  /**
   * 判断当前产品是否为GRL
   *
   * @returns true:是GRL, false:非GRL
   */
  public static isGRLFoldScreen(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFold !== undefined) {
      return DeviceInfo.isGRLFold;
    }
    let productProperty: string = DeviceInfo.getFoldScreenProperty();
    if (productProperty.startsWith(DeviceInfo.GRL_FOLD_SCREEN_VALUE_6)) {
      DeviceInfo.isGRLFold = true;
      return true;
    }
    DeviceInfo.isGRLFold = false;
    return false;
  }

  public static isTriExpand(foldStatus: number): boolean {
    return foldStatus === DeviceInfo.FOLD_STATE_EXPAND_WITH_SECOND_EXPAND ||
      foldStatus === DeviceInfo.FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND ||
      foldStatus === DeviceInfo.FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED ||
      foldStatus === DeviceInfo.FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED;
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
}