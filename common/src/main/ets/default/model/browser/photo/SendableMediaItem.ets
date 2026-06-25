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
import lazy {
  SendablePhotoAccessHelper,
  SendablePhotoAsset,
  SendableSharedPhotoAsset
} from '../../../access/SendablePhotoAccessHelper';
import lazy { DateUtil } from '../../../utils/DateUtil';
import lazy { Constants } from '../../common/Constants';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy fileUri from '@ohos.file.fileuri';
import lazy { FetchType } from '../../../interface/BrowserDataInterface';
import lazy { BURST_PHOTOS_SUBTYPE, MediaItem } from './MediaItem';
import lazy { collections } from '@kit.ArkTS';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { SendableAssetHelper } from '../../../utils/SendableAssetHelper';
import lazy { UserFileData } from '../../../model/UserFileData';
import lazy { PhotoAccessHelperAccess, PhotoAsset } from '../../../access/PhotoAccessHelperAccess';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { AvPlayConstants } from '../../common/AvPlayConstants';


/**
 * 支持Sendable传输的MediaItem, 成员变量必须为Sendable类型(FileAsset不支持)
 */
@Sendable
export class SendableMediaItem {
  private data?: SendablePhotoAsset;
  private mediaType: number = photoAccessHelper.PhotoType.IMAGE;
  private mimeType: string = '';
  public uri: string = '';
  private uniqueId: string = '';
  private thumbnail: string = '';
  private duration: number = 0;
  private title: string = '';
  private size: number = 0;
  private dateTaken: number = 0;
  private dateDay: string = '';
  private detailTime: number = 0;
  private detailTimeString: string = '';
  private shootingMode: string = '';
  private dateAdded: number = 0;
  public dateModified: number = 0;
  public thumbnailReady: number = 0;
  private orientation: number = 0;
  private width: number = 0;
  private height: number = 0;
  private imgWidth: number = 0;
  private imgHeight: number = 0;
  private coverWidth: number = 0;
  private coverHeight: number = 0;
  private imgOriginWidth: number = 0;
  private imgOriginHeight: number = 0;
  private displayedWidth: number = 0;
  private isFavor: boolean = false;
  private displayName: string = '';
  private dateTrashed: number = 0;
  private position: number = photoAccessHelper.PositionType.LOCAL;
  private hashCode: string = '';
  public path: string = '';
  private ocrCacheData: string = '';
  private ocrCacheDataFlag: boolean = false;
  private beautyState: string = '';
  private saliencyOffsetX: number = 0;
  private saliencyOffsetY: number = 0;
  private saliencyGetFlag: boolean = false;
  public timeId: string = '';
  private readonly TAG: string = 'common_SendableMediaItem';
  private subLocalityAddress: string = '';
  private isMovingPhoto: boolean = false;
  public isTurnedOnMovingPhoto: boolean = false;
  private coverPosition?: number;
  private movingPhotoEffectMode: number = 0;
  private cloudEnhancePhotoStatus: string = '';
  private isAutoTask: boolean = false;
  private isBurstPhotos: boolean = false;
  private burstKey: string | undefined = undefined;
  private frameNum: number = 0;
  private isHighQuality: boolean = true;
  private fileId: number = 0;
  private lcdReady: boolean = false;

  constructor(data?: SendablePhotoAsset, fetchType?: FetchType, sharedData?: SendableSharedPhotoAsset) {
    if (data) {
      this.initialize(data, fetchType);
      return;
    }
    if (sharedData) {
      this.initSharedData(sharedData, fetchType);
    }
  }

  public getWidth(): number {
    return this.width;
  }

  public getHeight(): number {
    return this.height;
  }

  initialize(data?: SendablePhotoAsset, fetchType?: FetchType): void {
    if (data) {
      this.data = data;
      this.mediaType = data.photoType;
      this.uri = data.uri;
      this.displayName = data.displayName;
      if (SendableAssetHelper.get(data, 'burst_key')) {
        this.burstKey = SendableAssetHelper.get(data, 'burst_key').toString();
      }

      // 资源subType判断
      let photoSubType: number = assert.asDefault<number>(SendableAssetHelper.get(data,
        photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 0), 0);

      // 是否是动态照片
      this.isMovingPhoto = this.isMovingPhotoAsset(data, photoSubType);
      this.isBurstPhotos = photoSubType === BURST_PHOTOS_SUBTYPE;
      if (fetchType === FetchType.EMPTY) {
        return;
      }
      this.dateTrashed = Number(SendableAssetHelper.get(data,
        photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(), 0));

      const positionKey = photoAccessHelper.PhotoKeys.POSITION.toString();
      this.position = SendableAssetHelper.get(
        data, positionKey, photoAccessHelper.PositionType.LOCAL) as photoAccessHelper.PositionType;

      if (fetchType === FetchType.DATE_INFO) {
        return;
      }
      this.initBaseInfo(data);
      this.isFavor = Boolean(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.FAVORITE.toString(), false));
      this.ocrCacheData = '';
      this.ocrCacheDataFlag = false;
      this.beautyState = '';
      this.uniqueId = this.path;
      this.hashCode = this.uniqueId;
      this.saliencyOffsetX = 0;
      this.saliencyOffsetY = 0;
      this.saliencyGetFlag = false;
      this.initOtherInfo(data);
      if (this.mediaType === UserFileData.MEDIA_TYPE_VIDEO) {
        // 根据视频时长，决定取帧数量。拟合曲线：count = 2.8958ln(x) + 0.5016; x为视频时长，单位秒。
        this.frameNum = Math.floor(AvPlayConstants.CON1 * Math.log(this.duration /
        AvPlayConstants.A_THOUSAND) + AvPlayConstants.CON2);
        this.frameNum = this.frameNum < AvPlayConstants.MIN_FRAME_NUM ? AvPlayConstants.MIN_FRAME_NUM : this.frameNum;
      }
    }
  }

  private initSharedData(sharedData: SendableSharedPhotoAsset, fetchType?: FetchType): void {
    this.fileId = sharedData.fileId;
    this.dateTaken = sharedData.dateTaken;
    this.dateModified = sharedData.dateModified;
    this.dateDay = sharedData.dateDay;
  }

  initBaseInfo(data?: SendablePhotoAsset): void {
    if (data) {
      this.mimeType = String(SendableAssetHelper.get(data, SendablePhotoAccessHelper.FETCH_COLUMNS_MIME_TYPE, ''));
      this.orientation = Number(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
      this.size = Number(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.SIZE, 0));
      const widthKey = photoAccessHelper.PhotoKeys.WIDTH;
      const heightKey = photoAccessHelper.PhotoKeys.HEIGHT;
      this.width = Number(SendableAssetHelper.get(data, widthKey, 0));
      if (this.width === 0) {
        Log.warn(this.TAG, `width is zero, try again: ${SendableAssetHelper.get(data, widthKey, 0)}`);
      }
      this.imgOriginWidth = this.width;
      this.height = Number(SendableAssetHelper.get(data, heightKey, 0));
      if (this.height === 0) {
        Log.warn(this.TAG, `height is zero, try again: ${SendableAssetHelper.get(data, heightKey, 0)}`);
      }
      this.imgOriginHeight = this.height;
      if (this.orientation === Constants.ANGLE_90 || this.orientation === Constants.ANGLE_270) {
        // 交换长宽
        let tmp = this.width;
        this.width = this.height;
        this.height = tmp;
      }
      if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
        this.duration = Number(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.DURATION, 0));
        if (this.duration === 0) {
          Log.warn(this.TAG, `duration is zero, video uri: ${this.uri}`);
        }
        this.orientation = 0;
      }

      let lcdSize = SendablePhotoAccessHelper.getLcdSize(data, this.uri);
      let thmSize = SendablePhotoAccessHelper.getThmSize(data, this.uri);
      this.lcdReady = lcdSize !== undefined;
      this.coverWidth = lcdSize ? lcdSize.width : (thmSize ? thmSize.width : this.width);
      this.coverHeight = lcdSize ? lcdSize.height : (thmSize ? thmSize.height : this.height);

      this.path = String(SendableAssetHelper.get(data, Constants.KEY_FILE_DATA, ''));
      this.imgWidth = this.width;
      this.displayedWidth = this.width;
      this.imgHeight = this.height;
      let photoQuality = Number(SendableAssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_PHOTO_QUALITY, 0));
      this.isHighQuality = photoQuality === 0;
    }
  }

  initOtherInfo(data?: SendablePhotoAsset): void {
    if (data) {
      this.title = String(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.TITLE.toString(), ''));

      const dateTakenKey = UserFileData.FILE_KEY_DATE_TAKEN_MS.toString();
      this.dateTaken = Number(SendableAssetHelper.get(data, dateTakenKey, 0));
      const dateDayKey = photoAccessHelper.PhotoKeys.DATE_DAY.toString();
      this.dateDay = String(SendableAssetHelper.get(data, dateDayKey));
      const detailTimeKey = photoAccessHelper.PhotoKeys.DETAIL_TIME.toString();
      this.detailTimeString = String(SendableAssetHelper.get(data, detailTimeKey, 0));
      this.detailTime = this.convertDateToTimestamp(String(SendableAssetHelper.get(data, detailTimeKey, 0)));

      this.shootingMode = String(SendableAssetHelper.get(data, Constants.SHOOTING_MODE_TAG));

      let dateAddedKey = photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString();
      this.dateAdded = Number(SendableAssetHelper.get(data, dateAddedKey, 0));

      const dataModifiedKey = photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString();
      this.dateModified = Number(SendableAssetHelper.get(data, dataModifiedKey, 0));

      const thumbnailReadyKey = UserFileData.FILE_KEY_THUMBNAIL_READY.toString();
      this.thumbnailReady = Number(SendableAssetHelper.get(data, thumbnailReadyKey, 0));

      this.coverPosition =
        Number(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.COVER_POSITION.toString(), 0));
      this.isAutoTask = Boolean(SendableAssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_IS_CE_AUTO, false));
      // 是否是云增强照片，云增强照片当前的状态
      this.cloudEnhancePhotoStatus =
        String(SendableAssetHelper.get(data, photoAccessHelper.PhotoKeys.CE_AVAILABLE.toString(), ''))
      Log.debug(this.TAG, `isAutoTask = ${this.isAutoTask}`);
      if (SendableAssetHelper.get(data, 'burst_key')) {
        this.burstKey = SendableAssetHelper.get(data, 'burst_key').toString();
      }
    }
  }

  public isMovingPhotoAsset(data?: SendablePhotoAsset, photoSubType?: number): boolean {
    if (!data) {
      return false;
    }
    this.movingPhotoEffectMode = Number(SendableAssetHelper.get(data,
      photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE.toString(), 0));
    if (this.movingPhotoEffectMode === photoAccessHelper.MovingPhotoEffectMode.BOUNCE_PLAY &&
      !DeviceInfo.isSupportBouncePlay()) {
      this.movingPhotoEffectMode = photoAccessHelper.MovingPhotoEffectMode.DEFAULT;
    }
    this.isTurnedOnMovingPhoto = photoSubType === photoAccessHelper.PhotoSubtype.MOVING_PHOTO;
    return this.isTurnedOnMovingPhoto ||
      (photoSubType === photoAccessHelper.PhotoSubtype.DEFAULT &&
        this.movingPhotoEffectMode === 10);
  }

  private convertDateToTimestamp(time: string): number {
    if (!time || time === '0') {
      return 0;
    }
    let photoDate = time.split(' ')[0];
    let photoTime = time.split(' ')[1];
    photoDate = photoDate.replace(/:/g, '-');
    Log.debug(this.TAG, `new time is ${photoDate + ' ' + photoTime}`)
    return Date.parse(photoDate + ` ${photoTime}`)
  }

  /* instrument ignore file */
  public static createMediaItems(input: collections.Array<SendableMediaItem>): MediaItem[] {
    let ret: MediaItem[] = [];
    if (!input || input.length <= 0) {
      return ret;
    }
    input.forEach((item: SendableMediaItem, index: number) => {
      let mediaItem = new MediaItem();
      mediaItem.data = item.data?.convertToPhotoAsset();
      mediaItem.mediaType = item.mediaType;
      mediaItem.mimeType = item.mimeType;
      mediaItem.uri = item.uri;
      mediaItem.uniqueId = item.uniqueId;
      mediaItem.thumbnail = item.thumbnail;
      mediaItem.thumbnailReady = item.thumbnailReady;
      mediaItem.setTitle(item.title);
      mediaItem.size = item.size;
      mediaItem.setDateTaken(item.dateTaken);
      mediaItem.setDateDay(item.dateDay);
      mediaItem.setDetailTime(item.detailTime);
      mediaItem.setDetailTimeString(item.detailTimeString);
      mediaItem.setShootingMode(item.shootingMode);
      mediaItem.setDateAdded(item.dateAdded);
      mediaItem.setDateModified(item.dateModified);
      mediaItem.duration = item.duration;
      mediaItem.orientation = item.orientation;
      mediaItem.width = item.width;
      mediaItem.height = item.height;
      mediaItem.imgWidth = item.imgWidth;
      mediaItem.imgHeight = item.imgHeight;
      mediaItem.coverWidth = item.coverWidth;
      mediaItem.coverHeight = item.coverHeight;
      mediaItem.imgOriginWidth = item.imgOriginWidth;
      mediaItem.imgOriginHeight = item.imgOriginHeight;
      mediaItem.setDisplayedWidth(item.displayedWidth);
      mediaItem.isFavor = item.isFavor;
      mediaItem.displayName = item.displayName;
      mediaItem.dateTrashed = item.dateTrashed;
      mediaItem.setPosition(item.position);
      mediaItem.hashCode = item.hashCode;
      mediaItem.path = item.path;
      mediaItem.ocrCacheData = item.ocrCacheData;
      mediaItem.ocrCacheDataFlag = item.ocrCacheDataFlag;
      mediaItem.beautyState = item.beautyState;
      mediaItem.saliencyOffsetX = item.saliencyOffsetX;
      mediaItem.saliencyOffsetY = item.saliencyOffsetY;
      mediaItem.saliencyGetFlag = item.saliencyGetFlag;
      mediaItem.timeId = item?.timeId;
      mediaItem.burstKey = item.burstKey;
      mediaItem.isTurnedOnMovingPhoto = item.isTurnedOnMovingPhoto;
      mediaItem.setIsMovingPhoto(item.isMovingPhoto);
      mediaItem.setCoverPosition(item.coverPosition);
      mediaItem.setMovingPhotoEffectMode(item.movingPhotoEffectMode);
      mediaItem.setIsAutoTask(item.isAutoTask);
      mediaItem.setIsBurstPhotos(item.isBurstPhotos);
      mediaItem.frameNum = item.frameNum;
      mediaItem.isHighQuality = item.isHighQuality;
      ret.push(mediaItem);
      item.data = undefined;
      mediaItem.lcdReady = item.lcdReady;
    });
    return ret;
  }

  setThumbnail(thumbnail: string): void {
    this.thumbnail = thumbnail;
  }
}