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
import lazy { Constants } from '../model/common/Constants';
import lazy display from '@ohos.display';
import lazy image from '@ohos.multimedia.image';
import lazy { DeviceInfo } from './DeviceInfo';
import type common from '@ohos.app.ability.common';
import type { PhotoAsset } from '../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { PhotoAccessHelperAccess } from '../access/PhotoAccessHelperAccess';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { MathUtil } from './MathUtil';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import lazy systemParameter from '@ohos.systemparameter';
import lazy Intl from '@ohos.intl';
import lazy i18n from '@ohos.i18n';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { LengthMetrics, Size } from '@kit.ArkUI';
import lazy { CommonUtil } from './CommonUtil';
import lazy Global from './GlobalContext';
import lazy { MediaDataProvider } from '../model/browser/dataObserver/MediaObserverCallback';
import lazy { Region } from '../model/common/DataTypes';

const TAG: string = 'common_ImageUtil';
/**
 * 默认图片边长大小
 */
const DEFAULT_SIZE_CONVERT: number = 1000;
const DEFAULT_LONG_SIZE: number = 768;
const DEFAULT_SHORT_SIZE: number = 256;
const DEFAULT_LONG_SHORT_RATIO: number = 3;
const DEFAULT_SIZE: number = 256;
const DATE_TAKEN_LEN: number = 13;
const FILE_ID_LEN: number = 10;
const CONVERSION_UNIT: number = 1024;

/**
 * 默认视频抽帧大小
 */
const VIDEO_FRAME_DEFAULT_SHORT_SIZE: number = 512;


/**
 * 大图LCD图宽高计算方式
 */
const LCD_LONG_SIZE: number = 1920;
const LCD_SHORT_SIZE: number = 512;
const MAXIMUM_LCD_LONG_SIZE: number = 4096;

export const TOTAL_READY_COUNT: number = 20000;

/**
 * Ready机制配置项开关
 */
const READY_ENABLE: string = 'const.sys.photos.ready.enable';
const READY_ON: string = 'on';

const INDEX_INVALID: number = -1;

const DEFAULT_ENCRYPTED_MARK: string = '******';

const ROOT_MEDIA_DIR: string = '/storage/cloud/files/';

const ROOT_SANDBOX_DIR: string = '/storage/Share/';

enum PreviewImageLimitedRatio {
  VERTICAL = 4 / 3,
  HORIZONTAL = 1 / 3,
  VERTICAL_LONG_IMAGE = 3 / 1,
}

export enum DecodeDynamicRange {
  AUTO = 0,
  SDR = 1,
  HDR = 2,
}

export class ImageUtil {
  // 默认缩略图大小，用于大图跳转
  public static readonly DEFAULT_THUMBNAIL_SIZE: number = 720;
  public static readonly LOADING_STATUS_LOAD_SUCC = 0;
  public static readonly LOADING_STATUS_DECODE_SUCC = 1;
  public static isOpenReady: boolean = false;
  public static thumbnailReadyFlag: boolean = true;
  private static preLocale: string = ImageUtil.getLocales();

  public static getThumbnailReady(): void {
    let param: string = systemParameter.getSync(READY_ENABLE, '');
    let length: number = (!param) ? 0 : param.length;
    ImageUtil.isOpenReady = (length !== 0) && param === READY_ON;
  }

  public static isThumbnailReady(): boolean {
    // 子线程拿不到单实例
    return !DeviceInfo.isPc() && ImageUtil.thumbnailReadyFlag;
  }

  public static setThumbnailReadyFlag(flag: boolean): void {
    // 放开过ready，就不再恢复ready，一直是按需加载
    if (!ImageUtil.thumbnailReadyFlag) {
      return;
    }
    ImageUtil.thumbnailReadyFlag = flag;
  }

  /**
   * 生成timeId
   *
   * @param dateTaken 图片拍摄时间
   * @param fileId 图片id
   * @returns timeId
   */
  public static generateTimeId(dateTaken: string, fileId: string): string {
    if (!dateTaken || !fileId) {
      return '';
    }

    // dateTaken预期为13位，对于不足13位的情况需要在前面补0。fileId必须为10位，且基本不足10位，直接在前面补0
    if (dateTaken.length < DATE_TAKEN_LEN) {
      dateTaken = dateTaken.slice(0, DATE_TAKEN_LEN).padStart(DATE_TAKEN_LEN, '0');
    }
    return dateTaken + fileId.slice(0, FILE_ID_LEN).padStart(FILE_ID_LEN, '0');
  }

  /* instrument ignore next */
  public static computeSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number):
    number {
    if (width === 0 || height === 0 || minSideLength === 0 || maxNumOfPixels === 0) {
      return 2;
    }
    let initialSize = ImageUtil.computeInitialSampleSize(width, height, minSideLength, maxNumOfPixels);
    Log.debug(TAG, `initialSize:  ${initialSize}`);
    return initialSize <= 8 ? ImageUtil.nextPowerOf2(initialSize) : Math.floor((initialSize + 8 - 1) / 8) * 8;
  }

  /* instrument ignore next */
  public static getScreenNailSize(size: image.Size, imageCompleteWidth?: number, imageCompleteHeight?: number): void {
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      // 屏幕最长边px值
      let screenWidth: number = displayClass.width;
      let screenHeight: number = displayClass.height;
      let maxScreenSideLength = Math.max(screenWidth, screenHeight);
      Log.info(TAG,
        `getScreenNailSize screenWidth-screenHeight-maxSideLength: ${screenWidth}${screenHeight}-${maxScreenSideLength}`);
      let targetSize = maxScreenSideLength * 1 / 4;
      let sizeWidth: number = size.width;
      let sizeHeight: number = size.height;
      if (sizeWidth === 0 && sizeHeight === 0) {
        // 宽高为0的图片，用image控件返回的宽高进行降采样
        if (imageCompleteWidth && imageCompleteHeight && imageCompleteWidth !== 0 && imageCompleteHeight !== 0) {
          size.width = imageCompleteWidth;
          size.height = imageCompleteHeight;
        } else {
          size.width = DEFAULT_SIZE;
          size.height = DEFAULT_SIZE;
        }
        Log.info(TAG, `getScreenNailSize target width: ${size.width},height: ${size.height}`);
      }
      let maxImageSideLength: number = Math.max(size.width, size.height);
      if (maxImageSideLength === 0) {
        Log.error(TAG, 'screen max length is zero');
        return;
      }
      let scale = targetSize / maxImageSideLength;
      size.width = Math.ceil(size.width * scale);
      size.height = Math.ceil(size.height * scale);
      Log.info(TAG, `getScreenNailSize scale: ${scale}, target width ${size.width}, height ${size.height}`);
    } catch (error) {
      Log.error(TAG, `getDefaultDisplaySync failed, error: ${error}, code: ${error?.code}`);
    }
  }

  // instrument ignore next
  public static nextPowerOf2(value: number): number {
    let useValue = value;
    if (useValue <= 0 || useValue > (1 << 30)) {
      Log.warn(TAG, `invalid sample value ${useValue}!`);
      return 1;
    }
    useValue -= 1;
    useValue |= useValue >> 16;
    useValue |= useValue >> 8;
    useValue |= useValue >> 4;
    useValue |= useValue >> 2;
    useValue |= useValue >> 1;
    Log.debug(TAG, `nextPowerOf2:${useValue}`);
    return useValue + 1;
  }

  /**
   * Calculate the aspect ratio, considering the direction of rotation
   *
   * @param info include orientation width height
   * @return the aspect ratio
   */
  public static calcRatio(info: Size): number {
    /* instrument ignore if */
    if (info === null || info === undefined) {
      return 1;
    }
    if (info.width === 0 || info.height === 0) {
      return 1;
    }
    return info.width / info.height;
  }

  /**
   * 计算缩略图大小生成对应路径
   * 计算缩略图大小规格：短边等于不小于给定大小；如果原图短边小于给定大小则返回原图大小
   *
   * @param uri 图片媒体路径
   * @param imageHeight 图片原高
   * @param imageWidth 图片原宽
   */
  // instrument ignore next
  public static calcThumbnail(uri: string, imageHeight: number, imageWidth: number, orientation?: number): string {
    if (uri == null) {
      return '';
    }
    if (!imageWidth || !imageHeight) {
      // 长宽无效返回缩略图默认值256 * 256
      return `${uri}/thumbnail/256/256`;
    }
    if (imageHeight < ImageUtil.DEFAULT_THUMBNAIL_SIZE || imageWidth < ImageUtil.DEFAULT_THUMBNAIL_SIZE) {
      return `${uri}/thumbnail/${imageWidth}/${imageHeight}`;
    }

    let width = 0;
    let height = 0;
    // instrument ignore if
    if (orientation !== undefined && orientation !== null &&
      (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270)) {
      let temp = imageWidth;
      imageWidth = imageHeight;
      imageHeight = temp;
    }
    // instrument ignore if
    if (imageHeight < imageWidth) {
      height = ImageUtil.DEFAULT_THUMBNAIL_SIZE;
      width = Math.round(height * imageWidth / imageHeight);
    } else {
      width = ImageUtil.DEFAULT_THUMBNAIL_SIZE;
      height = Math.round(width * imageHeight / imageWidth);
    }
    return `${uri}/thumbnail/${width}/${height}`;
  }

  /* instrument ignore next */
  public static calcThumbnailSize(imageHeight: number, imageWidth: number, orientation?: number): Size {
    if (!imageWidth || !imageHeight) {
      return { width: 256, height: 256 };
    }
    if (imageHeight < ImageUtil.DEFAULT_THUMBNAIL_SIZE || imageWidth < ImageUtil.DEFAULT_THUMBNAIL_SIZE) {
      return { width: imageWidth, height: imageHeight };
    }

    let width = 0;
    let height = 0;
    if (orientation !== null && orientation !== undefined &&
      (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270)) {
      let temp = imageWidth;
      imageWidth = imageHeight;
      imageHeight = temp;
    }
    if (imageHeight < imageWidth) {
      height = ImageUtil.DEFAULT_THUMBNAIL_SIZE;
      width = Math.round(height * imageWidth / imageHeight);
    } else {
      width = ImageUtil.DEFAULT_THUMBNAIL_SIZE;
      height = Math.round(width * imageHeight / imageWidth);
    }
    return { width: width, height: height };
  }

  /**
   * 获取媒体库小缩略图Size
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @param isCenterScale 是否需要居中裁剪
   * @returns
   */
  public static getThumbnailSize(width: number, height: number, shouldCenterCrop: boolean): Size {
    // PC不需要居中裁剪
    if (!DeviceInfo.isPc() && shouldCenterCrop) {
      return { width: DEFAULT_SIZE, height: DEFAULT_SIZE };
    }
    return ImageUtil.resizeThumbnail(width, height);
  }

  /**
   * 媒体库小缩略图等比例宽高计算方式
   * 根据原图宽高调整缩略图
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @returns
   */
  public static resizeThumbnail(width: number, height: number): Size {
    let maxLen = Math.max(width, height);
    let minLen = Math.min(width, height);
    let ratio = maxLen / minLen;
    /* instrument ignore else */
    if (minLen > DEFAULT_SHORT_SIZE) {
      minLen = DEFAULT_SHORT_SIZE;
      maxLen = DEFAULT_SHORT_SIZE * ratio;
      /* instrument ignore if */
      if (maxLen > DEFAULT_LONG_SIZE) {
        maxLen = DEFAULT_LONG_SIZE;
      }
      if (height > width) {
        width = minLen;
        height = maxLen;
      } else {
        width = maxLen;
        height = minLen;
      }
    } else if (minLen <= DEFAULT_SHORT_SIZE && maxLen > DEFAULT_SHORT_SIZE) {
      /* instrument ignore else */
      if (ratio > DEFAULT_LONG_SHORT_RATIO) {
        let newMaxLen = minLen * DEFAULT_LONG_SHORT_RATIO;
        if (height > width) {
          width = minLen;
          height = newMaxLen;
        } else {
          width = newMaxLen;
          height = minLen;
        }
      }
    } else {
      Log.warn(TAG, `resizeThumbnail fail, width: ${width}, height: ${height},`);
    }
    return { width: width ?? DEFAULT_SIZE, height: height ?? DEFAULT_SIZE };
  }

  /**
   * 是否为超长图（长短边比超过阈值）。
   * 用于在部分场景下避免走 ASTC 缩略图解码链路（更容易触发内存分配失败）。
   */
  public static isLongImage(width: number | undefined, height: number | undefined,
    longShortRatio: number = 4): boolean {
    if (!width || !height || width <= 0 || height <= 0) {
      return false;
    }
    const maxLen = Math.max(width, height);
    const minLen = Math.min(width, height);
    if (minLen === 0) {
      return false;
    }
    return (maxLen / minLen) > longShortRatio;
  }

  /**
   * 逐帧播放-抽帧等比例宽高计算方式
   * 根据LCD宽高调整，双边最小值大于128时，取128，按比例计算另一边
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @returns
   */
  public static resizeVideoFrame(width: number, height: number): Size {
    let ratio = width / height;
    if (height > VIDEO_FRAME_DEFAULT_SHORT_SIZE) {
      height = VIDEO_FRAME_DEFAULT_SHORT_SIZE;
      width = VIDEO_FRAME_DEFAULT_SHORT_SIZE * ratio;
    }
    return { width: width, height: height };
  }

  /**
   * 获取宫格小缩略图uri(拇指图)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @param thumbnailReady 缩略图生成时间
   * @returns 宫格小缩略图uri(拇指图)
   */
  public static getThumbnailJpgUri(sourceUri: string | undefined, path: string, modifiedDate: number,
    thumbnailReady?: number): string {
    if (!thumbnailReady) {
      return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=0&height=0&path=${path}`;
    }
    return `${sourceUri}?timestampApp=${
    modifiedDate}&thumbnailModifiedMs=${thumbnailReady}&oper=thumbnail&width=0&height=0&path=${path}`;
  }

  /**
   * 获取宫格小纹理图uri(纹理拇指图,年月日)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @param thumbnailReady 缩略图生成时间
   * @returns 宫格小缩略图uri(拇指图)
   */
  public static getThumbnailAstcUri(sourceUri: string | undefined, path: string | undefined,
    modifiedDate: number | undefined, thumbnailReady?: number): string {
    if (!thumbnailReady) {
      return `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=0&height=0&path=${path}`;
    }
    return `${sourceUri}?timestampApp=${
    modifiedDate}&thumbnailModifiedMs=${thumbnailReady}&oper=astc&width=0&height=0&path=${path}`;
  }

  /**
   * 获取带宽高的 JPG 缩略图 uri（用于特殊场景降内存）
   */
  public static getThumbnailJpgUriWithSize(sourceUri: string | undefined, path: string, modifiedDate: number,
    width: number, height: number, thumbnailReady?: number): string {
    if (!thumbnailReady) {
      return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=${width}&height=${height}&path=${path}`;
    }
    return `${sourceUri}?timestampApp=${
    modifiedDate}&thumbnailModifiedMs=${thumbnailReady}&oper=thumbnail&width=${width}&height=${height}&path=${path}`;
  }

  /**
   * 获取宫格小缩略图uri(拇指图)
   * 该函数在taskpool中运行，禁止在该函数中使用appstorage变量, 会导致异常
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @param isOpenYearMonth 年月日开关
   * @param thumbnailReady 缩略图生成时间
   * @returns 宫格小缩略图uri(拇指图)
   */
  public static getThumbnailUri(sourceUri: string | undefined, path: string, modifiedDate: number,
    isOpenYearMonth: boolean | undefined, thumbnailReady?: number, isPickerPage?: boolean | undefined): string {
    if (!sourceUri) {
      return '';
    }
    if (isOpenYearMonth || isPickerPage) {
      // 宫格/Picker 走 ASTC 容易触发 AllocMem -5，改用带尺寸的 JPG 缩略图
      return ImageUtil.getThumbnailJpgUriWithSize(sourceUri, path, modifiedDate, Constants.GRID_IMAGE_SIZE,
        Constants.GRID_IMAGE_SIZE, thumbnailReady);
    }
    return ImageUtil.getThumbnailJpgUri(sourceUri, path, modifiedDate, thumbnailReady);
  }

  /**
   * 获取大图LCD缩略图uri(大图)
   * PS: 不能用于taskpool子线程中,使用的全局变量，环境独立
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 大图LCD缩略图uri
   */
  public static getLCDUri(sourceUri: string | undefined, path: string | undefined, modifiedDate: number | undefined,
    decodeDynamicRange?: number): string {
    if (decodeDynamicRange) {
      return `${sourceUri}?timestampApp=${
      modifiedDate}&oper=thumbnail&width=-1&height=-1&decodeDynamicRange=${decodeDynamicRange}&path=${path}`;
    }

    // 不能用于taskpool子线程中,状态无法同步
    /* instrument ignore if */
    let hdrSwitch = AppStorage.get<boolean>('hdr_picture_switch');
    if (hdrSwitch === false || DeviceInfo.isTv()) {
      Log.info(TAG, `decodeDynamicRange opthion: image.DecodingDynamicRange.SDR, hdr_picture_switch:
        ${hdrSwitch}`);
      return `${sourceUri}?timestampApp=${
      modifiedDate}&oper=thumbnail&width=-1&height=-1&decodeDynamicRange=${image.DecodingDynamicRange.SDR}&path=${path}`;
    }
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=-1&height=-1&path=${path}`;
  }

  /**
   * 获取photoasset对应的lcd图沙箱路径
   *
   * @param path 图片path
   * @returns photoasset的LCD沙箱路径
   */
  public static getLCDPath(path: string): string {
    return `${ROOT_SANDBOX_DIR}.thumbs/${path.substring(ROOT_MEDIA_DIR.length)}/LCD.jpg`;
  }

  /**
   * 获取lcd uri
   * @param item item
   * @param size 尺寸
   * @returns uri
   */
  public static getHighlightCoverLcdUri(item: MediaItem, size?: image.Size, decodeDynamicRange: number = 1): string {
    return `${item?.uri}?timestampApp=${item?.getDateModified()}&oper=thumbnail` +
      `&width=${size ? size.width : -1}&height=${size ? size.height : -1}` +
      `&decodeDynamicRange=${decodeDynamicRange}&path=${item?.path}`;
  }

  /**
   * 获取大图帶寬高的LCD缩略图uri(大图)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 大图LCD缩略图uri
   */
  public static getLCDUriWithSize(sourceUri: string, path: string, modifiedDate: number, size: image.Size): string {
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=${size.width}&height=${size.height}` +
      `&path=${path}`;
  }

  /**
   * 媒体库大图LCD图宽高计算方式
   * 根据原图宽高调整LCD图，三步调整：
   * 1. 长边对齐1920；
   * 2. 如果对齐后短边过短(512)，短边对齐512；
   * 3. 如果对齐后长边过长(4096)，长边对齐4096；
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @returns
   */
  public static toLcd(width: number, height: number): image.Size {
    let maxLen = Math.max(width, height);
    let minLen = Math.min(width, height);

    let ratio = maxLen / minLen;
    let newMaxLen = maxLen;
    let newMinLen = minLen;

    // step1 长边对齐1920
    if (maxLen > LCD_LONG_SIZE) {
      newMaxLen = LCD_LONG_SIZE;
      newMinLen = LCD_LONG_SIZE / ratio;
    }

    let lastMinLen = newMinLen;
    let lastMaxLen = newMaxLen;
    // instrument ignore if
    if (newMinLen < LCD_SHORT_SIZE && minLen >= LCD_SHORT_SIZE) {
      // step2 短边过短，短边对齐512
      lastMinLen = LCD_SHORT_SIZE;
      lastMaxLen = lastMinLen * ratio;
      if (lastMaxLen > MAXIMUM_LCD_LONG_SIZE) {
        // step3 长边过长，长边对齐4096
        lastMaxLen = MAXIMUM_LCD_LONG_SIZE;
        lastMinLen = lastMaxLen / ratio;
      }
    }
    if (height > width) {
      width = lastMinLen;
      height = lastMaxLen;
    } else {
      width = lastMaxLen;
      height = lastMinLen;
    }
    return { width: Math.ceil(width), height: Math.ceil(height) };
  }

  /* instrument ignore next */
  private static computeInitialSampleSize(width: number, height: number,
    minSideLength: number, maxNumOfPixels: number): number {
    if ((maxNumOfPixels === -1) && (minSideLength === -1)) {
      return 1;
    }

    let lowerBound: number = (maxNumOfPixels === -1) ? 1 : Math.ceil(Math.sqrt((width * height) / maxNumOfPixels));
    Log.debug(TAG, `lowerBound: ${lowerBound}`);
    if (minSideLength === -1) {
      return lowerBound;
    } else {
      let sampleSize = Math.min(width / minSideLength, height / minSideLength);
      return Math.max(sampleSize, lowerBound);
    }
  }

  private static getLocales(): string {
    return i18n.System.getSystemLanguage();
  }

  private static formatMM: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {
    style: 'unit',
    unit: 'millimeter',
  });

  /* instrument ignore next */
  public static getFormatMMStr(size: number): string {
    if (!ImageUtil.formatMM || ImageUtil.preLocale !== ImageUtil.getLocales()) {
      Log.info(TAG, `Language change old:${ImageUtil.preLocale}, new:${ImageUtil.getLocales()}`);
      ImageUtil.preLocale = ImageUtil.getLocales();
      ImageUtil.formatMM = new Intl.NumberFormat(ImageUtil.getLocales(), { style: 'unit', unit: 'millimeter' });
    }
    return ImageUtil.formatMM.format(size);
  }

  private static formatKB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {
    style: 'unit',
    unit: 'kilobyte',
    unitDisplay: 'short',
  });
  private static formatMB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {
    style: 'unit',
    unit: 'megabyte',
    unitDisplay: 'short',
  });
  private static formatGB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {
    style: 'unit',
    unit: 'gigabyte',
    unitDisplay: 'short',
  });

  private static getFormatKB(): Intl.NumberFormat {
    /* instrument ignore if */
    if (!ImageUtil.formatKB || ImageUtil.preLocale !== ImageUtil.getLocales()) {
      ImageUtil.preLocale = ImageUtil.getLocales();
      ImageUtil.formatKB =
        new Intl.NumberFormat(ImageUtil.getLocales(), { style: 'unit', unit: 'kilobyte', unitDisplay: 'short' });
    }
    return ImageUtil.formatKB;
  }

  private static getFormatMB(): Intl.NumberFormat {
    /* instrument ignore if */
    if (!ImageUtil.formatMB || ImageUtil.preLocale !== ImageUtil.getLocales()) {
      ImageUtil.preLocale = ImageUtil.getLocales();
      ImageUtil.formatMB =
        new Intl.NumberFormat(ImageUtil.getLocales(), { style: 'unit', unit: 'megabyte', unitDisplay: 'short' });
    }
    return ImageUtil.formatMB;
  }

  private static getFormatGB(): Intl.NumberFormat {
    /* instrument ignore if */
    if (!ImageUtil.formatGB || ImageUtil.preLocale !== ImageUtil.getLocales()) {
      ImageUtil.preLocale = ImageUtil.getLocales();
      ImageUtil.formatGB =
        new Intl.NumberFormat(ImageUtil.getLocales(), { style: 'unit', unit: 'gigabyte', unitDisplay: 'short' });
    }
    return ImageUtil.formatGB;
  }

  public static getDisplaySize(size: number): string {
    if (size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) > 1 &&
      size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) < DEFAULT_SIZE_CONVERT) {
      let newSize: number = Number((size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT)).toFixed(2));
      if (newSize > 100) {
        newSize = Number((newSize).toFixed(0));
      }
      return ImageUtil.getFormatMB().format(newSize);
    }
    if (size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) > 1) {
      let newSize: number =
        Number((size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT)).toFixed(2));
      if (newSize > 100) {
        newSize = Number((newSize).toFixed(0));
      }
      return ImageUtil.getFormatGB().format(newSize);
    }
    let newSize: number = Number((size / DEFAULT_SIZE_CONVERT).toFixed(2));
    if (newSize > 100) {
      newSize = Number((newSize).toFixed(0));
    }
    return ImageUtil.getFormatKB().format(newSize);
  }

  public static getSortDisplaySize(size: number): string {
    return ImageUtil.getDisplaySize(size);
  }

  /**
   * 将byte大小转换为kB,MB,GB
   *
   * @param fileSize 文件大小
   * @returns 转换单位后的文件大小
   */
  public static formatFileSize(fileSize: number): string {
    if (fileSize === 0) {
      return '0 KB';
    }
    const units = ['BYTE', 'KB', 'MB', 'GB'];
    const index = Math.floor(Math.log(fileSize) / Math.log(Constants.CONVERSION_UNIT));
    return `${(fileSize / Math.pow(Constants.CONVERSION_UNIT, index)).toFixed(2)} ${units[index]}`;
  }

  public static formatMBSize(size: number): number {
    if (size === 0) {
      return 0;
    }
    return Number((size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT)).toFixed(2));
  }


  /* instrument ignore next */
  public static async getPixelMapForThumbnail(context: common.Context, uri: string, opts: image.DecodingOptions):
    Promise<image.PixelMap | undefined> {
    // instrument ignore if
    if (!context || !uri || !opts) {
      return undefined;
    }
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      let fileAsset: PhotoAsset = await UserFileManagerAccess.getInstance()
        .getObject(AlbumDefine.getFileFetchOptByUri(uri)) as PhotoAsset;
      if (!fileAsset) {
        // 隐藏相册
        const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
        fileAsset = await PhotoAccessHelperAccess.getHiddenAsset(context, uri) as PhotoAsset;
      }
      pixelMap = await fileAsset.getThumbnail(opts?.desiredSize);
      if (!pixelMap) {
        Log.error(TAG, `getPixelMapForThumbnail pixelMap is undefined. uri: ${uri}`);
      }
    } catch (err) {
      Log.error(TAG, `getPixelMapForThumbnail error code:${err?.code}---${err}`);
    }
    return pixelMap;
  }

  /* instrument ignore next */
  public static async getPixelMap(context: common.Context, uri: string, opts: image.DecodingOptions):
    Promise<image.PixelMap | undefined> {
    // instrument ignore if
    if (!context || !uri || !opts) {
      return undefined;
    }
    let pixelMap: image.PixelMap | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;
    let fileAsset: PhotoAsset | undefined;
    let fd: number = -1;
    try {
      fileAsset = await UserFileManagerAccess.getInstance()
        .getObject(AlbumDefine.getFileFetchOptByUri(uri)) as PhotoAsset;
      if (!fileAsset) {
        // 隐藏相册
        const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
        fileAsset = await PhotoAccessHelperAccess.getHiddenAsset(context, uri) as PhotoAsset;
      }
      if (!fileAsset) {
        // 最近删除
        fileAsset = await UserFileManagerAccess.getInstance().getTrashAssetByUri(uri) as PhotoAsset;
      }
      fd = await fileAsset?.open('r');
      imageSource = image.createImageSource(fd);
      try {
        pixelMap = await imageSource?.createPixelMap(opts);
      } catch (err) {
        Log.error(TAG, `imageSource?.createPixelMap error ${err}`);
      }
      if (!pixelMap && CommonUtil.isVideoFile(uri)) {
        try {
          pixelMap = await fileAsset.getThumbnail();
        } catch (err) {
          Log.error(TAG, `fileAsset.getThumbnail error ${err}`);
        }
      }
      if (!pixelMap) {
        Log.error(TAG, `getPixelMap pixelMap is undefined. uri: ${uri}`);
      }
    } catch (err) {
      Log.error(TAG, `getPixelMap error code:${err?.code}---${err}`);
    } finally {
      await imageSource?.release();
      Log.info(TAG, `[fd flag] getPixelMap, close fd: ${fd}`);
      await fileAsset?.close(fd);
    }
    return pixelMap;
  }

  /**
   * 限制长按预览图显示比例，对宽高比做限制，优化显示效果
   * @param width 原图宽
   * @param height 原图高
   * @returns 限制后的比例
   */
  public static getPreviewImageLayoutRatio(width: number, height: number): number {
    if (width === 0 || height === 0) {
      Log.warn(TAG, 'preview size invalid.');
      return PreviewImageLimitedRatio.VERTICAL;
    }
    const maxLen: number = Math.max(width, height);
    const minLen: number = Math.min(width, height);
    // 横向长图，长短边比限制在3:1内
    if (MathUtil.equals(width, maxLen)) {
      if (maxLen / minLen > DEFAULT_LONG_SHORT_RATIO) {
        return PreviewImageLimitedRatio.HORIZONTAL;
      }
      return height / width;
    }
    // 竖向长图
    if (MathUtil.equals(height, maxLen)) {
      if (maxLen / minLen > DEFAULT_LONG_SHORT_RATIO) {
        return PreviewImageLimitedRatio.VERTICAL_LONG_IMAGE;
      }
      return height / width;
    }
    /* instrument ignore next */
    // 其余场景采用默认4:3
    return PreviewImageLimitedRatio.VERTICAL;
  }

  public static getSingleLineIrregularModeAspectRatio(width: number, height: number): number {
    if (width === 0 || height === 0 || !width || !height) {
      Log.warn(TAG, 'getSingleLineModeAspectRatio width or height is 0');
      return 1;
    }
    const maxLen: number = Math.max(width, height);
    const minLen: number = Math.min(width, height);
    // 横向长图，长短边比限制在3:1内
    if (MathUtil.equals(width, maxLen)) {
      if (maxLen / minLen > DEFAULT_LONG_SHORT_RATIO) {
        return DEFAULT_LONG_SHORT_RATIO;
      }
      return width / height;
    }
    // 竖向长图，长短边比限制在1:3内
    if (MathUtil.equals(height, maxLen)) {
      if (maxLen / minLen > DEFAULT_LONG_SHORT_RATIO) {
        return 1 / DEFAULT_LONG_SHORT_RATIO;
      }
      return width / height;
    }
    return width / height;
  }

  /**
   * 判断是否存在透明通道的图片格式
   *
   * @param url 图片uri
   * @returns 是否存在透明通道的图片格式
   */
  public static isExitTransparentChannelImg(url: string): boolean {
    return url.indexOf(Constants.EXTENSION_PNG) > 0 ||
      url.indexOf(Constants.EXTENSION_GIF) > 0 ||
      url.indexOf(Constants.EXTENSION_HEIC) > 0;
  }

  /**
   * 判断是否存在透明通道的本地的图片格式
   *
   * @param item 图片MediaItem
   * @returns 是否存在透明通道的图片格式
   */
  public static isExitTransparentChannelLocalImgMimeType(item: MediaItem): boolean {
    return ImageUtil.isExitTransparentChannelImgMimeType(item) &&
      item.getPosition?.() !== photoAccessHelper.PositionType.CLOUD;
  }

  /**
   * 判断是否存在透明通道的图片格式
   *
   * @param item 图片MediaItem
   * @returns 是否存在透明通道的图片格式
   */
  public static isExitTransparentChannelImgMimeType(item: MediaItem): boolean {
    return item.mimeType?.toLowerCase() === Constants.MIME_TYPE_PNG ||
      item.mimeType?.toLowerCase() === Constants.MIME_TYPE_GIF ||
      item.mimeType?.toLowerCase() === Constants.MIME_TYPE_WEBP;
  }

  public static getSelectedSmallImgHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 40 : 36;
  }

  public static getSmallImgHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 40 : 36;
  }

  public static getSelectedSmallImgWidth(): number {
    return DeviceInfo.isTv() ? LengthMetrics.resource($r('app.float.tv_swiper_item_size')).value :
      ((DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 53 : 48);
  }

  public static getSmallImgWidth(): number {
    return DeviceInfo.isTv() ? LengthMetrics.resource($r('app.float.tv_swiper_item_size')).value :
      ((DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 20 : 18);
  }

  /**
   * 匿名化缩略图uri
   *
   * @param uri 缩略图Uri
   * @returns 匿名化后的缩略图uri
   */
  public static encryptThumbnailUri(uri: string): string {
    if (!uri) {
      return '';
    }
    let mark: number = uri.indexOf('?');
    Log.info(TAG, "encryptThumbnailUri mark: " + mark);
    if (mark === INDEX_INVALID) {
      return ImageUtil.encryptThumbnailSubUri(uri);
    }

    let frontStr: string = uri.substring(0, mark);
    let endStr: string = uri.substring(mark);
    Log.info(TAG, "encryptThumbnailUri frontStr: " + frontStr + " endStr: " + endStr);
    return ImageUtil.encryptThumbnailSubUri(frontStr) + ImageUtil.encryptThumbnailSubUri(endStr);
  }

  private static encryptThumbnailSubUri(subUri: string): string {
    let slashMark: number = subUri.lastIndexOf('/');
    if (slashMark === INDEX_INVALID) {
      return DEFAULT_ENCRYPTED_MARK;
    }
    let dotMark: number = subUri.lastIndexOf('.');
    if (dotMark === INDEX_INVALID) {
      return DEFAULT_ENCRYPTED_MARK;
    }
    return subUri.substring(0, slashMark + 1) + DEFAULT_ENCRYPTED_MARK + subUri.substring(dotMark);
  }

  // 构建pixelMap生成参数
  public static buildPixelMapOpt(tag: string, imageSize: Size, albumWidth: number,
    region: Region | undefined): image.DecodingOptions {
    Log.info(tag, `try createPixelMapSync,size=${JSON.stringify(imageSize)}, albumwidth=${albumWidth}`);
    // 计算裁剪区域：有优选框就按比例计算区域，没有则短边居中裁剪方形区域
    let x: number = 0;
    let y: number = 0;
    let width: number = 0;
    let height: number = 0;
    let minSize: number = Math.min(imageSize.width, imageSize.height);
    if (region && region.width && region.height) {
      // 有优选框，截取优选区域，如果不为方形，则按照优选区域居中方形裁剪，正方形边长为选区域居短边边长
      x = region.x * imageSize.width;
      y = region.y * imageSize.height;
      width = region.width * imageSize.width;
      height = region.height * imageSize.height;
      if (width >= height) {
        x = x + (width - height) * Constants.CROP_HALF;
        width = height;
      } else {
        y = y + (height - width) * Constants.CROP_HALF;
        height = width;
      }
    } else {
      // 没有优选框，居中方形裁剪，正方形边长为图片短边边长
      x = (imageSize.width - minSize) * Constants.CROP_HALF;
      y = (imageSize.height - minSize) * Constants.CROP_HALF;
      width = minSize;
      height = minSize;
    }
    let opt: image.DecodingOptions = {
      // 尺寸缩放
      desiredSize: {
        width: albumWidth,
        height: albumWidth,
      },
      // 裁剪区域
      desiredRegion: {
        x,
        y,
        size: {
          width,
          height,
        },
      },
      // 裁剪优先，可以减少解码区域
      cropAndScaleStrategy: image.CropAndScaleStrategy.CROP_FIRST,
    };
    return opt;
  }
}