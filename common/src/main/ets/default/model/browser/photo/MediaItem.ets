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

import lazy { Log } from '../../../utils/Log';
import type { FetchOptions, PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { Constants } from '../../common/Constants';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Size } from '@kit.ArkUI';
import lazy fileUri from '@ohos.file.fileuri';
import lazy { AssetHelper } from '../../../utils/AssetHelper';
import lazy { FetchType } from '../../../interface/BrowserDataInterface';
import type { Context } from '@ohos.abilityAccessCtrl';
import type { BusinessError } from '@kit.BasicServicesKit';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy Global from '../../../utils/GlobalContext';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { image } from '@kit.ImageKit';
import lazy { data } from '@kit.TelephonyKit';
import lazy systemDateTime from '@ohos.systemDateTime';
import lazy { UiUtil } from '../../../utils/UiUtil';
import lazy { findAddressSerialPipe } from '../../../utils/SerialPipe'
import { MovingPhoto, SendableSharedPhotoAsset } from '../../../access/SendablePhotoAccessHelper';

const TAG: string = 'MediaItem';
const THUMBNAIL_WIDTH: number = 256;
const NUMBER_DIGIT: number = 3; // 地址经纬度小数位数
const noEditableVideoType: string[] = ['video/mp2ts', 'video/mp2t', 'video/webm'];
const editableImageType: string[] = ['jpg', 'jpeg', 'jpe', 'png', 'webp', 'heic', 'heif'];
const FILE_ID_LENGTH: number = 10;
const MILLISECONDS_PER_SECOND: number = 1000;
const MAX_ENCODING_RESOLUTION: number = 1.5e8;
const FORMAT_HEIF: string = 'image/heif';
const FORMAT_HEIC: string = 'image/heic';

export const BURST_PHOTOS_SUBTYPE: number = 4;

interface BurstKey {
  burstKey?: string,
}

// 逐帧播放取帧公式系数
const CON1: number = 2.8958;
const CON2: number = 0.5016;
// 逐帧播放xxx最小抽帧个数
const MIN_FRAME_NUM: number = 3;

export const isPhotoAsset =
  (assets: PhotoAsset) => (assets as PhotoAsset).photoType !== undefined;


export const isVideoAssets = (item: PhotoAsset): boolean => isPhotoAsset(item) &&
  item.photoType === photoAccessHelper.PhotoType.VIDEO;

/**
 * 记录截图状态
 */
export enum CaptureState {
  /**
   * 从URL更新后的状态
   */
  NONE = 0,

  /**
   * 原始设置PIXMAP的状态
   */
  PIXMAP = 1,

  /**
   * 更新PhotoAsset后状态
   */
  PHOTO_ASSET_STATE = 2,
}

export class MediaItem {
  public static readonly THUMBNAIL_WIDTH = 256;
  public index?: number;
  public mediaType: number = Number.NaN;
  public mimeType: string = '';
  public uri: string = '';
  public uniqueId: string = '';
  public thumbnail: string = '';
  public duration: number = Number.NaN;
  private title: string = '';
  public size: number = Number.NaN;
  public dateTaken: number = Number.NaN;
  public dateDay: string = '';
  public address: string = '';
  private detailTime: number = Number.NaN;
  private detailTimeString: string = '';
  private dateAdded: number = Number.NaN;
  public dateModified: number = Number.NaN;
  public thumbnailReady: number = Number.NaN;
  public orientation: number = Number.NaN;
  public width: number = Number.NaN;
  public height: number = Number.NaN;
  public imgWidth: number = Number.NaN;
  public imgHeight: number = Number.NaN;
  public coverWidth: number = Number.NaN;
  public coverHeight: number = Number.NaN;
  public imgOriginWidth: number = Number.NaN;
  public imgOriginHeight: number = Number.NaN;
  private displayedWidth: number = Number.NaN;
  public isFavor: boolean = false;
  public displayName: string = '';
  public dateTrashed: number = Number.NaN;
  private position: photoAccessHelper.PositionType = Number.NaN;
  public hashCode: string = '';
  public data?: PhotoAsset;
  public path: string = '';
  public ocrCacheData: string = '';
  public ocrCacheDataFlag: boolean = false;
  public beautyState: string = '';
  public saliencyOffsetX: number = Number.NaN;
  public saliencyOffsetY: number = Number.NaN;
  public saliencyGetFlag: boolean = false;
  public timeId?: string;
  public detailAddress?: string;
  // public location?: mapCommon.LatLng;
  public fileData?: SendableSharedPhotoAsset | photoAccessHelper.SharedPhotoAsset;
  public burstKey?: string;
  private isMovingPhoto: boolean = false;
  public versionMetadata: string = '';
  public isTurnedOnMovingPhoto: boolean = false;
  public isBurstPhotos: boolean = false;
  private movingPhotoEffectMode?: number;
  private coverPosition?: number;
  private movingPhoto?: MovingPhoto;
  private cloudEnhancePhotoStatus?: string;
  private isAutoTask?: boolean = false;
  private subLocalityAddress: string = '';
  public frameNum: number = 0;
  private supportedFormats: string[] = [];
  public isResourceLoading?: boolean;
  public isHighQuality: boolean = true;
  public isFrameSticker: boolean = false;
  public isBorderSticker: boolean = false;
  public isXtStyleSticker: boolean = false;
  public isFestivalSticker: boolean = false;
  public isPersonalizedStickerStyle1: boolean = false;
  public stickerFilterName: string = '';
  public sealInputWidth: number = 0;
  public sealInputHeight: number = 0;
  public mPosition?: number;
  public fileId: number = 0;
  public isFromNtf: boolean = false;
  public rotation: number = 0; //用于视频单帧导出图片角度
  public captureId: string = '';
  public thumbnailPixmap?: image.PixelMap;
  public thumbnailUri: string = '';
  public captureState: CaptureState = CaptureState.NONE;
  public createTime: number = 0;
  public isShowThumbnail: boolean = false;
  public isThumbnailMovingPhoto: boolean = false;
  // isInfoMissing表示MediaItem中信息是否完整，例如精准通知组装的MediaItem中会有信息缺失
  public isInfoMissing: boolean = false;
  // photoPicker用于刷新panel小图
  private thumbnailUpdateTime: number = 0;
  private shootingMode: string = '';
  public isAddressLoaded: boolean = false;
  public lcdReady: boolean = false;

  constructor(data?: PhotoAsset, fetchType?: FetchType,
    fileData?: SendableSharedPhotoAsset | photoAccessHelper.SharedPhotoAsset) {
    // 区分photoAsset和fileAsset，根据不同的类型调用不同的方法初始化
    if (data) {
      this.initialize(data, fetchType);
      return;
    }
    /* instrument ignore if */
    if (fileData) {
      this.initFileData(fileData);
    }
  }

  public initialize(data?: PhotoAsset, fetchType?: FetchType): void {
    /* instrument ignore if */
    if (!data) {
      return;
    }
    this.mediaType = data.photoType;
    this.uri = data.uri;
    this.displayName = data.displayName;
    this.data = data;
    this.isBurstPhotos = this.isBurstPhotosAsset(data);
    /* instrument ignore if */
    if (AssetHelper.get(data, 'burst_key')) {
      this.burstKey = AssetHelper.get(data, 'burst_key').toString();
    }
    /* instrument ignore if */
    if (fetchType === FetchType.EMPTY) {
      return;
    }
    this.dateTrashed = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(), 0));
    /* instrument ignore if */
    if (fetchType === FetchType.DATE_INFO) {
      return;
    }
    this.initBaseInfo(data);

    this.path = String(AssetHelper.get(data, Constants.KEY_FILE_DATA, ''));
    this.imgWidth = this.width;
    this.displayedWidth = this.width;
    this.imgHeight = this.height;
    this.isFavor = Boolean(AssetHelper.get(data, photoAccessHelper.PhotoKeys.FAVORITE.toString(), false));
    this.ocrCacheData = '';
    this.ocrCacheDataFlag = false;
    this.beautyState = '';
    this.uniqueId = this.path;
    this.hashCode = this.uniqueId;
    this.saliencyOffsetX = 0;
    this.saliencyOffsetY = 0;
    this.saliencyGetFlag = false;
    /* instrument ignore if */
    if (!data) {
      return;
    }
    this.isMovingPhoto = this.isMovingPhotoAsset(data);
    this.coverPosition = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.COVER_POSITION.toString(), 0));
    this.isAutoTask = Boolean(AssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_IS_CE_AUTO, false));
    this.cloudEnhancePhotoStatus =
      String(AssetHelper.get(data, photoAccessHelper.PhotoKeys.CE_AVAILABLE.toString(), ''));
    Log.debug(TAG, `[MediaItem initialize] data uri is: ${this.uri}, path is ${this.path}, ` +
      `cloudEnhancePhotoStatus is ${this.cloudEnhancePhotoStatus},` +
      `isMovingPhoto: ${this.isMovingPhoto},` +
      `isAutoTask is ${this.isAutoTask}`
    );
    // instrument ignore if
    if (this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.frameNum = Math.floor(CON1 * Math.log(this.duration / MILLISECONDS_PER_SECOND) + CON2);
      this.frameNum = this.frameNum < MIN_FRAME_NUM ? MIN_FRAME_NUM : this.frameNum;
    }
  }

  private initFileData(data?: SendableSharedPhotoAsset | photoAccessHelper.SharedPhotoAsset): void {
    // instrument ignore if
    if (data) {
      this.mediaType = data.mediaType;
      this.uri = data.uri;
      this.displayName = data.displayName;
      this.fileData = data;
      this.dateTrashed = data.dateTrashedMs;
      this.orientation = data.orientation;
      this.size = data.size;
      this.width = data.width;
      this.height = data.height;
    }
    this.isBurstPhotos = data?.subtype === BURST_PHOTOS_SUBTYPE;
    // instrument ignore if
    if (this.orientation === Constants.ANGLE_90 || this.orientation === Constants.ANGLE_270) {
      // 交换长宽
      this.swapLength();
    }
    if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      this.duration = data?.duration ?? Number.NaN;
      if (this.duration === 0) {
        Log.warn(TAG, `duration is zero, video uri: ${this.uri}`);
      }
      this.orientation = 0;
    }
    this.isFavor = data?.isFavorite ?? false;
  }

  public initBaseInfo(data?: PhotoAsset): void {
    if (!data) {
      return;
    }
    this.mimeType = String(AssetHelper.get(data, UserFileManagerAccess.FETCH_COLUMNS_MIME_TYPE, ''));
    this.orientation = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
    this.rotation = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
    this.size = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.SIZE, 0));
    const widthKey = photoAccessHelper.PhotoKeys.WIDTH;
    const heightKey = photoAccessHelper.PhotoKeys.HEIGHT;
    this.width = Number(AssetHelper.get(data, widthKey, 0));
    if (this.width === 0) {
      Log.warn(TAG, `width is zero, try again: ${AssetHelper.get(data, widthKey, 0)}`);
    }
    this.imgOriginWidth = this.width;
    this.height = Number(AssetHelper.get(data, heightKey, 0));
    if (this.height === 0) {
      Log.warn(TAG, `height is zero, try again: ${AssetHelper.get(data, heightKey, 0)}`);
    }
    this.imgOriginHeight = this.height;
    if (this.orientation === Constants.ANGLE_90 || this.orientation === Constants.ANGLE_270) {
      this.swapLength();
    }
    if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      this.duration = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.DURATION, 0));
      /* instrument ignore if */
      if (this.duration === 0) {
        Log.warn(TAG, `duration is zero, video uri: ${this.uri}`);
      }
      this.orientation = 0;
    }

    let lcdSize = PhotoAccessHelperAccess.getLcdSize(data, this.uri);
    let thmSize = PhotoAccessHelperAccess.getThmSize(data, this.uri);

    this.coverWidth = lcdSize ? lcdSize.width : (thmSize ? thmSize.width : this.width);
    this.coverHeight = lcdSize ? lcdSize.height : (thmSize ? thmSize.height : this.height);

    let photoQuality = Number(AssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_PHOTO_QUALITY, 0));
    this.isHighQuality = photoQuality === 0;
  }

  /* instrument ignore next */
  public initThumbnailPixmap(captureId: string, thumbnailPixmap: image.PixelMap, isLivePhoto: boolean): void {
    this.captureId = captureId;
    this.isThumbnailMovingPhoto = isLivePhoto;
    let imageInfo = thumbnailPixmap.getImageInfoSync();
    this.width = imageInfo.size.width;
    this.height = imageInfo.size.height;
    Log.info(TAG, `initThumbnailPixmap captureId: ${captureId}, size(${this.width}, ${this.height})`);
    this.thumbnailPixmap = thumbnailPixmap;
    this.isShowThumbnail = true;
    this.captureState = CaptureState.PIXMAP;
    this.createTime = this.getCurrentTime();
  }

  /* instrument ignore next */
  public updateThumbnail(photoAsset: photoAccessHelper.PhotoAsset): void {
    Log.info(TAG, `updateThumbnail captureId ${this.captureId}.`);
    this.thumbnailUri = photoAsset?.uri;
    this.captureState = CaptureState.PHOTO_ASSET_STATE;
  }

  public isThumbnailState(): boolean {
    return this.captureState !== CaptureState.NONE;
  }

  /* instrument ignore next */
  public releaseThumbnail(): void {
    if (this.thumbnailPixmap) {
      this.thumbnailPixmap.release();
      this.thumbnailPixmap = undefined;
    }
  }

  public isThumbnailCacheTimeout(timeout: number): boolean {
    return (this.getCurrentTime() - this.createTime) >= timeout;
  }

  public getCurrentTime(): number {
    try {
      return systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE);
    } catch (error) {
      /* instrument ignore next */
      Log.error(TAG, `getTime failed. code ${error.code}`);
    }
    /* instrument ignore next */
    return 0;
  }

  public toString(): string {
    return `<captureId: ${this.captureId}, thumbnailUri: ${this.thumbnailUri}, uri: ${this.uri},` +
      ` createTime: ${this.createTime}>`;
  }

  /**
   * 交换长宽
   */
  private swapLength(): void {
    const len = this.width;
    this.width = this.height;
    this.height = len;
  }

  private isMovingPhotoAsset(data: PhotoAsset): boolean {
    let photoSubType: number = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 0));
    this.movingPhotoEffectMode = Number(AssetHelper.get(data,
      photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE.toString(), 0));
    // nova规格：非nova设备通过云同步有来回播放效果的动态照片，转为默认的动态照片
    /* instrument ignore if */
    if (this.movingPhotoEffectMode === photoAccessHelper.MovingPhotoEffectMode.BOUNCE_PLAY &&
      !DeviceInfo.isSupportBouncePlay()) {
      this.movingPhotoEffectMode = photoAccessHelper.MovingPhotoEffectMode.DEFAULT;
    }
    this.isTurnedOnMovingPhoto = photoSubType === photoAccessHelper.PhotoSubtype.MOVING_PHOTO;
    return this.isTurnedOnMovingPhoto ||
      (photoSubType === photoAccessHelper.PhotoSubtype.DEFAULT &&
        this.movingPhotoEffectMode === 10);
  }

  // 是否为连拍照片
  // 端云可能会存在subtype为连拍，但是无burstkey的普通图片
  private isBurstPhotosAsset(data: PhotoAsset): boolean {
    const photoSubType: number = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 0));
    const burstKey = AssetHelper.get(data, 'burst_key');
    const hasBurstKey = burstKey !== null && burstKey !== undefined && burstKey !== '';
    return (photoSubType === BURST_PHOTOS_SUBTYPE) && hasBurstKey;
  }

  /* instrument ignore next */
  public async getObject(fetchOpt: FetchOptions): Promise<PhotoAsset> {
    let object: PhotoAsset = await UserFileManagerAccess.getInstance().getObject(fetchOpt) as PhotoAsset;
    return object;
  }

  /* instrument ignore next */
  public async getItemByUri(uri: string): Promise<PhotoAsset> {
    let object: PhotoAsset;
    let fetchOpt = AlbumDefine.getFileFetchOptByUri(uri);
    object = await this.getObject(fetchOpt);
    return object;
  }

  public setThumbnail(thumbnail: string): void {
    this.thumbnail = thumbnail;
  }

  getThumbnailReady(): number {
    if (this.thumbnailReady) {
      return this.thumbnailReady;
    }
    if (this.data) {
      const thumbnailReadyKey = UserFileManagerAccess.FILE_KEY_THUMBNAIL_READY.toString();
      this.thumbnailReady = Number(AssetHelper.get(this.data, thumbnailReadyKey, 0));
    }
    return this.thumbnailReady;
    // return 0
  }

  public async isEditable(): Promise<boolean> {
    try {
      return await this.isEditableType() && this.isEditableSize();
    } catch (error) {
      // instrument ignore next
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
      return false;
    }
  }

  public isEditableSize(): boolean {
    let resolution = this.width * this.height;
    Log.debug(TAG, `isEditable, resolution is ${resolution}`);
    return resolution <= MAX_ENCODING_RESOLUTION;
  }

  public async isEditableType(): Promise<boolean> {
    let supportedFormats: Array<string> | undefined = AppStorage.get(Constants.IMAGE_PACKER_SUPPORTED_FORMATS);
    if (supportedFormats === undefined || supportedFormats.length === 0) {
      supportedFormats = image.createImagePacker().supportedFormats;
      if (supportedFormats.includes(FORMAT_HEIF)) {
        supportedFormats.push(FORMAT_HEIC);
      }
      AppStorage.setOrCreate<Array<string>>(Constants.IMAGE_PACKER_SUPPORTED_FORMATS, supportedFormats);
    }
    this.supportedFormats = supportedFormats;
    Log.debug(TAG, 'isEditableType, mimeType is ' + this.mimeType + `, supportedFormats is 111 ${this.supportedFormats}`);
    // instrument ignore if
    if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      return !noEditableVideoType.includes(this.mimeType);
    }

    // instrument ignore if
    if (!this.mimeType) {
      let suffix = this.uri?.split('.')[this.uri?.split('.').length - 1].toLowerCase();
      return !editableImageType.every(imageType => suffix.indexOf(imageType) === -1);
    }

    if (this.supportedFormats.includes(this.mimeType) && this.mimeType.toLowerCase() !== 'image/gif') {
      return true;
    }
    // instrument ignore next
    Log.warn(TAG, 'current mimeType support encoding,', this.mimeType);
    return false;
  }

  public getRotation(): number {
    // instrument ignore if
    if (this.data) {
      return Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
    }
    return 0;
  }

  public setFavorite(isFavorite: boolean): void {
    this.isFavor = isFavorite;
  }

  public setDisplayedWidth(width: number): void {
    if (this.displayedWidth !== width) {
      this.displayedWidth = width;
    }
  }

  public getDisplayedWidth(): number {
    return this.displayedWidth ?? 0;
  }

  public getHashCode(): string {
    return this.uniqueId;
  }

  public static getStaticHashCode(mediaItem: MediaItem | undefined): string {
    return mediaItem?.uniqueId ?? '';
  }

  public getTitle(): string {
    if (this.title) {
      return this.title;
    }
    // instrument ignore if
    if (!this.data) {
      return '';
    }
    // instrument ignore next
    this.title = String(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.TITLE.toString(), ''));
    return this.title;
    // return ''
  }

  public setTitle(title: string | undefined): void {
    if (!title) {
      return;
    }
    this.title = title;
  }

  public getDateDay() : string {
    if (this.dateDay) {
      return this.dateDay;
    }
    /* instrument ignore if */
    if (!this.data) {
      Log.warn(TAG, 'mediaitem is null when get dateDay');
      return '';
    }

    const dateDayKey = UserFileManagerAccess.FILE_KEY_DATE_DAY.toString();
    this.dateDay = String(AssetHelper.get(this.data, dateDayKey, 0));
    Log.debug(TAG, `dateDay has not been init, get dateDay from medialibrary: ${this.dateDay}`);
    /* instrument ignore if */
    if (this.dateDay === '') {
      Log.warn(TAG, `dateDay is null, try again: ${AssetHelper.get(this.data, dateDayKey, 0)}`);
    }
    return this.dateDay;
    // return ''
  }

  public setDateDay(dateDay: string): void {
    this.dateDay = dateDay;
  }

  public setAddress(address: string): void {
    this.address = address;
  }

  public getAddress(): string {
    return this.address;
  }

  public getDateTaken(): number {
    if (this.dateTaken) {
      return this.dateTaken;
    }
    /* instrument ignore if */
    if (!this.data) {
      Log.warn(TAG, 'mediaitem is null when get dateTaken');
      return Number.NaN;
    }
    const dateTakenKey = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
    this.dateTaken = Number(AssetHelper.get(this.data, dateTakenKey, 0));
    Log.debug(TAG, `dateTaken has not been init, get dateTaken from medialibrary: ${this.dateTaken}`);
    /* instrument ignore if */
    if (this.dateTaken === 0) {
      Log.warn(TAG, `dateTaken is zero, try again: ${AssetHelper.get(this.data, dateTakenKey, 0)}`);
    }
    return this.dateTaken;
    // return 0
  }

  public getShootingMode(): string {
    if (this.shootingMode) {
      return this.shootingMode;
    }
    /* instrument ignore if */
    if (!this.data) {
      Log.warn(TAG, 'mediaItem is null when get shootingMode');
      return '';
    }
    this.shootingMode = String(AssetHelper.get(this.data, Constants.SHOOTING_MODE_TAG));
    Log.info(TAG,
      `shootingMode has not been init, get shootingMode from medialibrary:${this.shootingMode}, displayName:${this.displayName}`);
    return this.shootingMode;
    // return ''
  }

  public getDetailTime(): number {
    if (this.detailTime) {
      return this.detailTime;
    }
    /* instrument ignore if */
    if (!this.data) {
      Log.warn(TAG, 'mediaitem is null when get detailTime');
      return Number.NaN;
    }
    this.detailTime = this.getDateTaken();
    Log.debug(TAG, `detailTime has not been init, get detailTime from medialibrary: ${this.detailTime}`);
    /* instrument ignore if */
    if (this.detailTime === 0) {
      Log.warn(TAG, `detailTime is zero`);
    }
    return this.detailTime;
  }

  public getDetailTimeString(): string {
    if (this.detailTimeString) {
      return this.detailTimeString;
    }
    /* instrument ignore if */
    if (!this.data) {
      Log.warn(TAG, 'mediaItem is null when get detailTimeString');
      return '';
    }

    this.detailTimeString = String(this.getDateTaken());
    Log.debug(TAG, `detailTimeString has not been init, get detailTime from medialibrary: ${this.detailTimeString}`);
    /* instrument ignore if */
    if (this.detailTimeString === '0' || this.detailTimeString === 'NaN') {
      this.detailTimeString = ''
      Log.warn(TAG, `detailTimeString is empty`);
    }
    return this.detailTimeString;
  }

  /* instrument ignore next */
  private convertDateToTimestamp(time: string): number {
    let photoDate = time.split(' ')[0];
    let photoTime = time.split(' ')[1];
    photoDate = photoDate.replace(/:/g, '-');
    Log.info(TAG, `new time is ${photoDate + ' ' + photoTime}`)
    return Date.parse(photoDate + ` ${photoTime}`)
  }

  public setDateTaken(dateTaken: number): void {
    this.dateTaken = dateTaken;
  }

  public setDetailTime(detailTime: number): void {
    this.detailTime = detailTime;
  }

  public setDetailTimeString(detailTime: string): void {
    this.detailTimeString = detailTime;
  }

  public setShootingMode(shootingMode: string): void {
    this.shootingMode = shootingMode;
  }

  public getDateAdded(): number {
    if (this.dateAdded) {
      return this.dateAdded;
    }

    // 年月场景，无需get，直接获取
    // instrument ignore if
    if (this.fileData) {
      this.dateAdded = this.fileData.dateAddedMs;
      return this.dateAdded;
    }

    // 普通场景，通过get获取
    // instrument ignore if
    if (!this.data) {
      Log.warn(TAG, 'mediaitem is null when get DATE_ADDED');
      return Number.NaN;
    }
    // instrument ignore next
    let dateAddedKey = photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString();
    this.dateAdded = Number(AssetHelper.get(this.data, dateAddedKey, 0));
    Log.info(TAG, `dateAdded has not been init, get DATE_ADDED from medialibrary: ${this.dateAdded}`);
    // instrument ignore if
    if (this.dateAdded === 0) {
      Log.warn(TAG, `dateAdded is zero, try again: ${AssetHelper.get(this.data, dateAddedKey, 0)}`);
    }
    // instrument ignore next
    return this.dateAdded;
    // return 0
  }

  public setDateAdded(dateAdded: number | undefined): void {
    if (!dateAdded) {
      return;
    }
    this.dateAdded = dateAdded;
  }

  /* instrument ignore next */
  private generateTimeId(dateAdded: string, fileId: string): string {
    // dateAdded必须13位，不足在前面补零，fileId必须10位，不足在前面补零
    const len = 13;
    dateAdded = dateAdded.slice(0, len).padStart(len, '0');
    return dateAdded + (Array(len).join('0') + fileId).slice(-FILE_ID_LENGTH);
  }

  public getTimeId(): string {
    if (this.timeId) {
      return this.timeId;
    }
    // 普通场景，通过get获取
    /* instrument ignore if */
    if (this.data) {
      let dateTaken = String(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.DATE_TAKEN.toString()));
      let fileId = String(AssetHelper.get(this.data, 'file_id'));
      this.timeId = this.generateTimeId(dateTaken, fileId);
    }

    // 年月场景，无需get，直接获取
    if (this.fileData) {
      let dateTaken = String(this.fileData.dateTaken);
      let fileId = String(this.fileData.fileId);
      this.timeId = this.generateTimeId(dateTaken, fileId);
    }
    return this.timeId ?? '';
  }

  public setUri(uri: string): void {
    this.uri = uri;
  }

  public setDateModified(dateModified: number): void {
    this.dateModified = dateModified;
  }

  public getDateModified(): number {
    if (this.dateModified) {
      return this.dateModified;
    }
    if (this.data) {
      const dataModifiedKey = photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString();
      this.dateModified = Number(AssetHelper.get(this.data, dataModifiedKey, 0));
    }
    /* instrument ignore if */
    if (this.fileData) {
      this.dateModified = this.fileData.dateModifiedMs;
    }
    return this.dateModified;
    // return 0
  }

  public setPosition(position: photoAccessHelper.PositionType): void {
    this.position = position;
  }

  /* instrument ignore next */
  public getPosition(): photoAccessHelper.PositionType {
    if (!this.data) {
      return Number.NaN;
    }
    if (!this.position) {
      const positionKey = photoAccessHelper.PhotoKeys.POSITION.toString();
      this.position =
        AssetHelper.get(this.data, positionKey,
          photoAccessHelper.PositionType.LOCAL) as photoAccessHelper.PositionType;
    }
    return this.position;
  }

  /* instrument ignore next */
  public getThumbnailSafe(size?: Size): string {
    const sourceUri: string | undefined = this.uri;
    const path: string = this.path;
    const modifiedDate: number = this.getDateModified();
    try {
      if (size) {
        return `${sourceUri}?timestampApp=${
        modifiedDate}&oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
      } else {
        return `${sourceUri}?timestampApp=${
        modifiedDate}&oper=thumbnail&width=${THUMBNAIL_WIDTH}&height=${THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}, code: ${err?.code}`);
      return '';
    }
  }

  public getSaliencyFlag(): boolean {
    return this.saliencyGetFlag;
  }

  // 异步从媒体库获取主体中心坐标,API11接口
  public async getSaliencyCoordinates(): Promise<void> {
    if (!this.data || this.saliencyGetFlag) {
      return;
    }
    let saliencyCoordinates: string | undefined = await UserFileManagerAccess.getInstance().getAnalysisData(this.uri);
    /* instrument ignore if */
    if (!saliencyCoordinates || saliencyCoordinates === '[]') {
      return;
    }
    this.saliencyGetFlag = true;
    let result: Record<string, number>[] | Record<string, number> = JSON.parse(saliencyCoordinates);
    /* instrument ignore if */
    if (Array.isArray(result)) {
      this.saliencyOffsetX = result?.[0]?.saliency_x ?? Number.NaN;
      this.saliencyOffsetY = result?.[0]?.saliency_y ?? Number.NaN;
      return;
    }
    this.saliencyOffsetX = result.saliency_x ?? Number.NaN;
    this.saliencyOffsetY = result.saliency_y ?? Number.NaN;
  }

  // 获取最佳呈现主体中心x
  public getSaliencyOffsetXPercent(): number {
    return this.saliencyOffsetX;
  }

  // 获取最佳呈现主体中心y
  public getSaliencyOffsetYPercent(): number {
    return this.saliencyOffsetY;
  }

  public getIsBurstPhotos(): boolean {
    if (!this.data) {
      return false;
    }
    return this.isBurstPhotosAsset(this.data);
    // return false;
  }

  public setIsBurstPhotos(isBurstPhotos: boolean): void {
    this.isBurstPhotos = isBurstPhotos;
  }

  public getIsMovingPhoto(): boolean {
    return this.isMovingPhoto;
  }

  public isExportVideo(): boolean {
    if (this.isMovingPhoto && this.data) {
      let photoSubType: number =
        Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 0));
      if (photoSubType !== photoAccessHelper.PhotoSubtype.DEFAULT) {
        return true;
      }
    }
    return false;
  }

  public setIsMovingPhoto(isMovingPhoto: boolean): void {
    this.isMovingPhoto = isMovingPhoto;
  }

  /* instrument ignore next */
  public getMovingPhoto(): MovingPhoto | undefined {
    return this.movingPhoto;
  }

  /* instrument ignore next */
  public setMovingPhoto(movingPhoto: MovingPhoto | undefined): void {
    this.movingPhoto = movingPhoto;
  }

  public getCoverPostion(): number | undefined {
    return this.coverPosition;
  }

  public setCoverPosition(coverPosition: number | undefined): void {
    this.coverPosition = coverPosition;
  }

  public getIsAutoTask(): boolean | undefined {
    return this.isAutoTask;
  }

  /* instrument ignore next */
  public setIsAutoTask(isAutoTask: boolean): void {
    this.isAutoTask = isAutoTask;
  }

  /* instrument ignore next */
  public setThumbnailUpdateTime(time: number): void {
    this.thumbnailUpdateTime = time;
  }

  /* instrument ignore next */
  public getThumbnailUpdateTime(): number {
    return this.thumbnailUpdateTime;
  }

  /* instrument ignore next */
  public getMovingPhotoEffectMode(): number {
    return this.movingPhotoEffectMode ?? 0;
  }

  /* instrument ignore next */
  public setMovingPhotoEffectMode(effectMode: number): void {
    this.movingPhotoEffectMode = effectMode;
  }

  public async getSubLocalityStatic(): Promise<string> {
    if (!this.data) {
      Log.info(TAG, 'getSubLocalityStatic null:' + this.dateDay);
      return '';
    }
    if (this.subLocalityAddress.length > 0) {
      Log.info(TAG, 'getSubLocalityStatic do not update:' + this.dateDay);
      return this.subLocalityAddress;
    }
    let detailAddress: string = await findAddressSerialPipe.pipe(
      () => this.data?.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_DETAIL_ADDRESS)
    );
    let cityName: string = JSON.parse(detailAddress)[0].city_name;
    let subLocality: string = JSON.parse(detailAddress)[0].sub_locality;
    /* instrument ignore if */
    if (cityName && subLocality) {
      this.subLocalityAddress = cityName + `，${subLocality}`;
    } else {
      this.subLocalityAddress = cityName + subLocality;
    }
    this.isAddressLoaded = true;
    Log.info(TAG, `getSubLocalityStatic dateDay:${this.dateDay} ` +
      `detailAddress:${detailAddress?.length} ${cityName?.length} ${subLocality?.length} ${this.subLocalityAddress?.length}`);
    return this.subLocalityAddress;
  }

  /**
   * 重置已缓存的地址
   */
  public resetSubLocalityAddress(): void {
    Log.info(TAG, 'resetSubLocalityAddress')
    this.subLocalityAddress = '';
    this.isAddressLoaded = false;
  }

  public getFileId(): number {
    if (this.fileId > 0) {
      return this.fileId;
    }
    if (this.data) {
      this.fileId = Number(AssetHelper.get(this.data, UserFileManagerAccess.FILE_KEY_FILE_ID, 0));
      return this.fileId;
    }
    if (this.fileData) {
      this.fileId = this.fileData.fileId;
      return this.fileId;
    }
    return 0;
  }

  public equals(target: Object | undefined): boolean {
    if (!target || !(target instanceof MediaItem)) {
      return false;
    }
    return this === target;
  }

  public getFileExtension(): string {
    let fileExt: string = this.uri.substring(this.uri.lastIndexOf('.'));
    return fileExt;
  }

  public isInvalidImageSize(): boolean {
    return (!this.width || this.width == 0 || !this.height || this.height == 0);
  }

  public isGifOrWebpType(): boolean {
    return this.mimeType?.toLowerCase().indexOf('gif') !== -1 ||
      this.mimeType?.toLowerCase().indexOf('webp') !== -1;
  }
}