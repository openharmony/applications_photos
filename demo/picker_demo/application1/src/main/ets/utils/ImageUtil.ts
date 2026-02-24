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
import lazy { StringUtil } from './StringUtil';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG: string = 'common_ImageUtil';
/**
 * 默认图片边长大小
 */
const DEFAULT_SIZE_CONVERT: number = 1000;
const DEFAULT_LONG_SIZE: number = 768;
const DEFAULT_SHORT_SIZE: number = 256;
const DEFAULT_LONG_SHORT_RATIO: number = 3;
const DEFAULT_SIZE: number = 256;

/**
 * 大图LCD图宽高计算方式
 */
const LCD_LONG_SIZE: number = 1920;
const LCD_SHORT_SIZE: number = 512;
const MAXIMUM_LCD_LONG_SIZE: number = 4096;

/**
 * Ready机制配置项开关
 */
const READY_ENABLE: string = 'const.sys.photos.ready.enable';
const READY_ON: string = 'on';

export type ImageSize = {
  width: number;
  height: number;
};

enum PreviewImageLimitedRatio {
  VERTICAL = 4 / 3,
  HORIZONTAL = 1 / 3,
  VERTICAL_LONG_IMAGE = 3 / 1
}

export class ImageUtil {
  // 默认缩略图大小，用于大图跳转
  static readonly DEFAULT_THUMBNAIL_SIZE: number = 720;
  static readonly LOADING_STATUS_LOAD_SUCC = 0;
  static readonly LOADING_STATUS_DECODE_SUCC = 1;

  static isOpenReady: boolean = false;

  static getThumbnailReady(): void {
    let param: string = systemParameter.getSync(READY_ENABLE, '');
    let length: number = (param === undefined || param === null || param.length === 0) ? 0 : param.length;
    this.isOpenReady = (length !== 0) && param === READY_ON;
  }

  static isThumbnailReady(): boolean {
    return !DeviceInfo.isPc();
  }

  static computeSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number): number {
    if (width === 0 || height === 0 || minSideLength === 0 || maxNumOfPixels === 0) {
      return 2;
    }
    let initialSize = ImageUtil.computeInitialSampleSize(width, height, minSideLength, maxNumOfPixels);
    Log.debug(TAG, `initialSize:  ${initialSize}`);
    return initialSize <= 8 ? ImageUtil.nextPowerOf2(initialSize) : Math.floor((initialSize + 8 - 1) / 8) * 8;
  }

  static getScreenNailSize(size: image.Size, imageCompleteWidth?: number, imageCompleteHeight?: number): void {
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      // 屏幕最长边px值
      let screenWidth: number = displayClass.width;
      let screenHeight: number = displayClass.height;
      let maxScreenSideLength = Math.max(screenWidth, screenHeight);
      Log.info(TAG, `getScreenNailSize maxSideLength: ${maxScreenSideLength}`);
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
      // instrument ignore if
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

  static nextPowerOf2(value: number): number {
    let useValue = value;
    // instrument ignore if
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
  static calcRatio(info: ImageSize): number {
    // instrument ignore if
    if (info === null || info === undefined) {
      return 1;
    }
    // instrument ignore if
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
  static calcThumbnail(uri: string, imageHeight: number, imageWidth: number, orientation?: number): string {
    // instrument ignore if
    if (uri == null) {
      return '';
    }
    // instrument ignore if
    if (!imageWidth || !imageHeight) {
      // 长宽无效返回缩略图默认值256 * 256
      return `${uri}/thumbnail/256/256`;
    }
    if (imageHeight < this.DEFAULT_THUMBNAIL_SIZE || imageWidth < this.DEFAULT_THUMBNAIL_SIZE) {
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
    if (imageHeight < imageWidth) {
      height = this.DEFAULT_THUMBNAIL_SIZE;
      width = Math.round(height * imageWidth / imageHeight);
    } else {
      width = this.DEFAULT_THUMBNAIL_SIZE;
      height = Math.round(width * imageHeight / imageWidth);
    }
    return `${uri}/thumbnail/${width}/${height}`;
  }

  static calcThumbnailSize(imageHeight: number, imageWidth: number, orientation?: number): ImageSize {
    if (!imageWidth || !imageHeight) {
      return { width: 256, height: 256 };
    }
    if (imageHeight < this.DEFAULT_THUMBNAIL_SIZE || imageWidth < this.DEFAULT_THUMBNAIL_SIZE) {
      return { width: imageWidth, height: imageHeight };
    }

    let width = 0;
    let height = 0;
    if (orientation !== null && orientation !== undefined && (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270)) {
      let temp = imageWidth;
      imageWidth = imageHeight;
      imageHeight = temp;
    }
    if (imageHeight < imageWidth) {
      height = this.DEFAULT_THUMBNAIL_SIZE;
      width = Math.round(height * imageWidth / imageHeight);
    } else {
      width = this.DEFAULT_THUMBNAIL_SIZE;
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
  static getThumbnailSize(width: number, height: number, shouldCenterCrop: boolean): ImageSize {
    // PC不需要居中裁剪
    if (!DeviceInfo.isPc() && shouldCenterCrop) {
      return { width: DEFAULT_SIZE, height: DEFAULT_SIZE };
    }
    return this.resizeThumbnail(width, height);
  }

  /**
   * 媒体库小缩略图等比例宽高计算方式
   * 根据原图宽高调整缩略图
   *
   * @param width 图片宽 px
   * @param height 图片高 px
   * @returns
   */
  static resizeThumbnail(width: number, height: number): ImageSize {
    let maxLen = Math.max(width, height);
    let minLen = Math.min(width, height);
    let ratio = maxLen / minLen;
    if (minLen > DEFAULT_SHORT_SIZE) {
      minLen = DEFAULT_SHORT_SIZE;
      maxLen = DEFAULT_SHORT_SIZE * ratio;
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
   * 获取宫格小缩略图uri(拇指图)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 宫格小缩略图uri(拇指图)
   */
  static getThumbnailJpgUri(sourceUri: string, path: string, modifiedDate: number): string {
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=0&height=0&path=${path}`;
  }

  /**
   * 获取宫格小纹理图uri(纹理拇指图,年月日)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 宫格小缩略图uri(拇指图)
   */
  static getThumbnailAstcUri(sourceUri: string, path: string, modifiedDate: number): string {
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=0&height=0&path=${path}`;
  }

  /**
   * 获取宫格小缩略图uri(拇指图)
   * 该函数在taskpool中运行，禁止在该函数中使用appstorage变量, 会导致异常
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @param isOpenYearMonth 年月日开关
   * @returns 宫格小缩略图uri(拇指图)
   */
  public static getThumbnailUri(sourceUri: string, path: string, modifiedDate: number, isOpenYearMonth: boolean): string {
    // instrument ignore else
    if (isOpenYearMonth) {
      return ImageUtil.getThumbnailAstcUri(sourceUri, path, modifiedDate);
    } else {
      return ImageUtil.getThumbnailJpgUri(sourceUri, path, modifiedDate);
    }
  }

  /**
   * 获取大图LCD缩略图uri(大图)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 大图LCD缩略图uri
   */
  static getLCDUri(sourceUri: string, path: string, modifiedDate: number): string {
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=-1&height=-1&path=${path}`;
  }

  /**
   * 获取lcd uri
   * @param item item
   * @param size 尺寸
   * @returns uri
   */
  public static getLcdUri(item: MediaItem, size?: image.Size): string {
    return `${item?.uri}?timestampApp=${item?.getDateModified()}&oper=thumbnail` +
      `&width=${size ? size.width : -1}&height=${size ? size.height : -1}&path=${item?.path}`;
  }

  /**
   * 获取大图帶寬高的LCD缩略图uri(大图)
   *
   * @param sourceUri 图片uri
   * @param path 图片path
   * @param modifiedDate 修改时间
   * @returns 大图LCD缩略图uri
   */
  static getLCDUriWithSize(sourceUri: string, path: string, modifiedDate: number, size: image.Size): string {
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
  static toLcd(width: number, height: number): image.Size {
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
    return i18n.getSystemLanguage();
  }

  private static formatMM: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'millimeter'});

  static getFormatMMStr(size: number): string {
    if (!ImageUtil.formatMM) {
      ImageUtil.formatMM = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'millimeter'});
    }
    return ImageUtil.formatMM.format(size);
  }

  private static formatKB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'kilobyte'});
  private static formatMB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'megabyte'});
  private static formatGB: Intl.NumberFormat = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'gigabyte'});

  private static getFormatKB(): Intl.NumberFormat {
    if (!ImageUtil.formatKB) {
      ImageUtil.formatKB = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'kilobyte'});
    }
    return ImageUtil.formatKB;
  }

  private static getFormatMB(): Intl.NumberFormat {
    if (!ImageUtil.formatMB) {
      ImageUtil.formatMB = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'megabyte'});
    }
    return ImageUtil.formatMB;
  }

  private static getFormatGB(): Intl.NumberFormat {
    if (!ImageUtil.formatGB) {
      ImageUtil.formatGB = new Intl.NumberFormat(ImageUtil.getLocales(), {style: 'unit', unit: 'gigabyte'});
    }
    return ImageUtil.formatGB;
  }

  static getDisplaySize(size: number): string {
    if (size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) > 1 && size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) < DEFAULT_SIZE_CONVERT) {
      const newSize: number = Number((size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT)).toFixed(2));
      return ImageUtil.getFormatMB().format(newSize);
    } else if (size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT) > 1) {
      const newSize: number = Number((size / (DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT * DEFAULT_SIZE_CONVERT)).toFixed(2));
      return ImageUtil.getFormatGB().format(newSize);
    } else {
      const newSize: number = Number((size / DEFAULT_SIZE_CONVERT).toFixed(2));
      return ImageUtil.getFormatKB().format(newSize);
    }
  }

  /* instrument ignore next */
  public static async getPixelMapForThumbnail(context: common.Context, uri: string, opts: image.DecodingOptions): Promise<image.PixelMap | undefined> {
    // instrument ignore if
    if (!context || !uri || !opts) {
      return undefined;
    }
    let pixelMap: image.PixelMap = undefined;
    let imageSource: image.ImageSource = undefined;
    try {
      let fileAsset: PhotoAsset = await UserFileManagerAccess.getInstance()
        .getObject(AlbumDefine.getFileFetchOptByUri(uri)) as PhotoAsset;
      if (!fileAsset) {
        // 隐藏相册
        const context = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
        fileAsset = await PhotoAccessHelperAccess.getHiddenAsset(context, uri) as PhotoAsset;
      }
      pixelMap = await fileAsset.getThumbnail(opts?.desiredSize);
      if (!pixelMap) {
        Log.error(TAG, `getPixelMapForThumbnail pixelMap is undefined. uri: ${uri}`);
      }
    } catch (err) {
      Log.error(TAG, `getPixelMapForThumbnail error code:${err?.code}---${err}`);
    } finally {
      imageSource?.release();
    }
    return pixelMap;
  }

  /* instrument ignore next */
  static async getPixelMap(context: common.Context, uri: string, opts: image.DecodingOptions): Promise<image.PixelMap | undefined> {
    // instrument ignore if
    if (!context || !uri || !opts) {
      return undefined;
    }
    let pixelMap: image.PixelMap = undefined;
    let imageSource: image.ImageSource = undefined;
    try {
      let fileAsset: PhotoAsset = await UserFileManagerAccess.getInstance()
        .getObject(AlbumDefine.getFileFetchOptByUri(uri)) as PhotoAsset;
      if (!fileAsset) {
        // 隐藏相册
        const context = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
        fileAsset = await PhotoAccessHelperAccess.getHiddenAsset(context, uri) as PhotoAsset;
      }
      let fd = await fileAsset?.open('r');
      imageSource = image.createImageSource(fd);
      fileAsset?.close(fd);
      pixelMap = await imageSource?.createPixelMap(opts);
      if (!pixelMap) {
        Log.error(TAG, `getPixelMap pixelMap is undefined. uri: ${uri}`);
      }
    } catch (err) {
      Log.error(TAG, `getPixelMap error code:${err?.code}---${err}`);
    } finally {
      imageSource?.release();
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
    // 其余场景采用默认4:3
    return PreviewImageLimitedRatio.VERTICAL;
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
    return this.isExitTransparentChannelImgMimeType(item) &&
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
      item.mimeType?.toLowerCase() === Constants.MIME_TYPE_HEIC;
  }

  public static getSelectedSmallImgHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 40 : 36;
  }

  public static getSmallImgHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 40 : 36;
  }

  public static getSelectedSmallImgWidth(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 53 : 48;
  }

  public static getSmallImgWidth(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? 20 : 18;
  }
}