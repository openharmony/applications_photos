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
import i18n from '@ohos.i18n';
import deviceInfo from '@ohos.deviceInfo';
import display from '@ohos.display';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { FoldPhoneTypeValue } from '../../service/model/Enum';
import { HiLog } from './HiLog';
import { BusinessError, systemParameter } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { image } from '@kit.ImageKit';
import { NullUtil } from './NullUtil';
import { Configuration } from '@kit.ArkUI';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

const TAG = 'DeviceUtil';

const FOLD_PRODUCT_TYPE = 'const.window.foldscreen.type';
const DEFAULTS_FOLD_TYPE = '0,0,0,0';

/**
 * 和设备相关工具类
 */
export class DeviceUtil {
  private static sFoldProductTypeValue: FoldPhoneTypeValue = FoldPhoneTypeValue.INVALID_VALUE;
  private static isVdeFold?: boolean = undefined;
  private static foldScreenProperty?: string = undefined;
  public static readonly FOLD_SCREEN_PRODUCT_PROPERTY = 'const.window.foldscreen.type';
  public static readonly SMALL_FOLD_SCREEN_VALUE_4: string = '4,';
  public static readonly TRI_FOLD_SCREEN_VALUE: number = 6;

  /**
   * 判断当前语言是否是英文
   *
   * @returns true 是
   */
  public static isEnglish(): boolean {
    return i18n.System.getSystemLanguage().includes('en');
  }

  // 是否为镜像模式
  public static isMirrorMode(): boolean {
    let modeDirection: string = 'rtl';
    return Configuration.getLocale().dir === modeDirection;
  }

  public static getDeviceType() {
    let deviceType = deviceInfo.deviceType;
    return deviceType;
  }

  public static isPhone(): boolean {
    return DeviceInfo.isPhoneUx()
    //return DeviceUtil.getDeviceType() === 'phone';
  }

  public static isPc(): boolean {
    return DeviceUtil.getDeviceType() === '2in1';
  }

  public static isPad(): boolean {
    return DeviceUtil.getDeviceType() === 'tablet';
  }

  public static isFoldable(): boolean {
    try {
      return display.isFoldable();
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isFoldable error code is ${code}, message is ${message}`);
    }
    return false;
  }

  // 判断当前设备是否为xxx(包含xxx和xxx,不包含阔xxx)
  public static isFoldLandScape(): boolean {
    /* instrument ignore if */
    if (DeviceUtil.isPhoneVde() || DeviceUtil.isPc()) {
      return false;
    }
    return DeviceUtil.isFoldable();
  }

  public static isFoldDeviceMain(): boolean {
    try {
      return display.isFoldable() && display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN;
    } catch (err) {
      HiLog.e(TAG, `display.getFoldDisplayMode get res error, error code : ${err.code}`);
      return false;
    }
  }

  public static isFoldDeviceFULL(): boolean {
    try {
      return display.isFoldable() && display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    } catch (err) {
      HiLog.e(TAG, `display.getFoldDisplayMode get res error, error code : ${err.code}`);
      return false;
    }
  }

  /**
   * 根据机型、屏幕判断
   * 是否为xxx
   */
  public static isVerdeFolded(): boolean {
    return DeviceUtil.isPhoneVde() && display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN;
  }

  /**
   * 获取产品属性const.window.foldscreen.type
   *
   * @returns property
   */
  private static getFoldScreenProperty(): string {
    if (DeviceUtil.foldScreenProperty !== undefined) {
      return DeviceUtil.foldScreenProperty;
    }
    let tmpProperty: string = '';
    try {
      tmpProperty = systemParameter.getSync(DeviceUtil.FOLD_SCREEN_PRODUCT_PROPERTY);
    } catch (e) {
      HiLog.e(TAG, 'getFoldScreenProperty error:' + e.code);
    }
    DeviceUtil.foldScreenProperty = tmpProperty ? tmpProperty : '';
    return tmpProperty;
  }

  /**
   * 根据机型判断
   * 是否为VDE手机
   */
  public static isPhoneVde(): boolean {
    if (DeviceUtil.isVdeFold !== undefined) {
      return DeviceUtil.isVdeFold;
    }
    let productProperty: string = DeviceUtil.getFoldScreenProperty();
    /* instrument ignore if */
    if (NullUtil.isStrNull(productProperty)) {
      return false;
    }
    HiLog.i(TAG, `isPhoneVde productProperty = ${productProperty}`);
    DeviceUtil.isVdeFold = productProperty.startsWith(DeviceUtil.SMALL_FOLD_SCREEN_VALUE_4);
    return DeviceUtil.isVdeFold;
  }

  public static isEmulator(): boolean {
    return deviceInfo.productModel === 'emulator';
  }

  public static isLandscape(): boolean {
    try {
      let orientation = display.getDefaultDisplaySync().orientation;
      return orientation == display.Orientation.LANDSCAPE || orientation == display.Orientation.LANDSCAPE_INVERTED;
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isLandscape error code is ${code}, message is ${message}`);
    }
    return false;
  }

  public static getFoldProductType(): FoldPhoneTypeValue {
    if (DeviceUtil.sFoldProductTypeValue !== FoldPhoneTypeValue.INVALID_VALUE) {
      return DeviceUtil.sFoldProductTypeValue;
    }
    try {
      let productValue: string = systemParameterEnhance.getSync(FOLD_PRODUCT_TYPE, DEFAULTS_FOLD_TYPE);
      HiLog.i(TAG, `productValue: ${productValue}`);
      const result: string[] = productValue?.split(',');
      if (result.length > 0) {
        DeviceUtil.sFoldProductTypeValue = Number.parseInt(result[0]);
        return DeviceUtil.sFoldProductTypeValue;
      }
    } catch (e) {
      HiLog.e(TAG, `Get fold product type value failed, error code : ${e.code}`);
    }
    return FoldPhoneTypeValue.INVALID_VALUE;
  }

  public static isSmallFoldProduct(): boolean {
    return FoldPhoneTypeValue.SMALL_FOLD === DeviceUtil.getFoldProductType() ||
      FoldPhoneTypeValue.EXPANDING_NEX_FORMS === DeviceUtil.getFoldProductType();
  }

  /**
   * 判断当前设备是否xxx设备,isTriFold: boolean 是否三xxx设备6
   * @returns true:是xxx, false:非xxx
   */
  public static isTriFoldScreen(): boolean {
    return DeviceUtil.TRI_FOLD_SCREEN_VALUE === DeviceUtil.getFoldProductType();
  }

  // 判断当前xxx设备是否全屏xxx,@returns true:是三屏xxx、即G态, false:非
  public static isTriFoldFullExpanded(): boolean {
    if (!DeviceUtil.isTriFoldScreen()) {
      return false;
    }
    let mCurStatus = DeviceUtil.getFoldStatus();
    return mCurStatus === display.FoldStatus.FOLD_STATUS_EXPANDED_WITH_SECOND_EXPANDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED_WITH_SECOND_EXPANDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_EXPANDED_WITH_SECOND_HALF_FOLDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED_WITH_SECOND_HALF_FOLDED;
  }

  // 判断当前xxx设备是否双屏xxx,@returns true:是双屏展开显示态、即M态, false:非
  public static isTriFoldLandScape(): boolean {
    if (!DeviceUtil.isTriFoldScreen()) {
      return false;
    }
    let mCurStatus = DeviceUtil.getFoldStatus();
    return mCurStatus === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
  }

  // 判断当前xxx设备是否直板态,@returns true:是直板显示态、即xxxorN态, false:非
  public static isTriFoldFolded(): boolean {
    if (!DeviceUtil.isTriFoldScreen()) {
      return false;
    }
    let mCurStatus = DeviceUtil.getFoldStatus();
    return mCurStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_FOLDED ||
      mCurStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED;
  }

  // 获取设备当前xxx,注明:仅对FoldChangeService开放调用
  public static getFoldStatus(): display.FoldStatus {
    try {
      return display.getFoldStatus();
    } catch (err) {
      return display.FoldStatus.FOLD_STATUS_FOLDED;
    }
  }

  /**
   * 获取的当前手机的形态，返回值
   * G - 全展开三叠
   * M - 二xxx开
   * 空字符串 直扳机
   * */
  /* instrument ignore next */
  public static currDevicePosture() {
    let devicePosture = '';
    if (DeviceUtil.isTriFoldFullExpanded()) {
      devicePosture = 'G';
    } else if (DeviceUtil.isTriFoldLandScape() ||
      DeviceUtil.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      devicePosture = 'M';
    }
    return devicePosture;
  }

  /**
   * 判断是否支持艺术签名水印
   */
  /* instrument ignore next */
  public static isSupportArkSignWatermark(): boolean {
    let sourcePath: string = '/sys_prod/resource/camera/camouflage';
    try {
      let isHide: string = systemParameterEnhance.getSync('const.mspes.camera_watermark');
      if (isHide === 'false' || !fs.accessSync(sourcePath)) {
        sourcePath = '/sys_prod/resource/camera';
      }
      let devModel: string = systemParameterEnhance.getSync('const.cust.devmodel');
      let targetPath: string = sourcePath + '/' + devModel;
      let res = fs.accessSync(targetPath + '/watermark/Renewal', fs.AccessModeType.EXIST);
      if (!res) {
        res = fs.accessSync(sourcePath + '/watermark/Renewal', fs.AccessModeType.EXIST);
      }
      return res;
    } catch (error) {
      HiLog.e(TAG, `isSupportFrontWatermark get error ${error}`);
      return false;
    }
  }

  /**
   * 获取支持的图片编码类型列表
   * @returns 支持的图片编码类型列表（MimeType）
   */
  public static getSupportedPackerImageFormats(): Array<string> {
    let imgPacker: image.ImagePacker | undefined;
    try {
      imgPacker = image.createImagePacker();
      let result = imgPacker.supportedFormats;
      return result;
    } catch (error) {
      HiLog.e(TAG, `getSupportedPackerImageFormats error ${error}`);
      return [];
    } finally {
      imgPacker?.release();
    }
  }
}