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

import lazy { AssetHelper } from '../../../utils/AssetHelper';
import lazy { Constants } from '../../common/Constants';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { Log } from '../../../utils/Log';
import type { MediaItem } from './MediaItem';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import type { PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'SimpleGridMediaItem';

const VALUE_UNKNOWN: number = -1;

const FLAG_NOT_FAVORITE: number = 0;

const FLAG_FAVORITE: number = 1;

export const FETCH_COLUMNS: string[] = [
  photoAccessHelper.PhotoKeys.URI.toString(),
  photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
  photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
  photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
  photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
  photoAccessHelper.PhotoKeys.DURATION.toString(),
  photoAccessHelper.PhotoKeys.WIDTH.toString(),
  photoAccessHelper.PhotoKeys.HEIGHT.toString(),
  photoAccessHelper.PhotoKeys.DATE_TAKEN_MS.toString(),
  photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
  photoAccessHelper.PhotoKeys.FAVORITE.toString(),
  photoAccessHelper.PhotoKeys.POSITION.toString(),
  // photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(),
  'date_trashed_ms',
  UserFileManagerAccess.FILE_KEY_THUMBNAIL_READY.toString()
];

/**
 * 用于封装宫格浏览场景下的MediaItem（仅定义最小集必须参数）
 */
export class SimpleGridMediaItem {
  /**
   * 媒体类型
   */
  public mediaType: number = photoAccessHelper.PhotoType.IMAGE;
  /**
   * 媒体uri
   */
  public uri: string = '';
  /**
   * 显示名
   */
  public displayName: string = '';
  private data?: PhotoAsset;
  private path: string = '';
  private dateModified: number = VALUE_UNKNOWN;
  private thumbnailReady: number = VALUE_UNKNOWN;
  private orientation: number = VALUE_UNKNOWN;
  private favorProp: number = VALUE_UNKNOWN;
  private thumbnailUri: string = '';
  private duration: number = VALUE_UNKNOWN;
  private dateTrashed: number = VALUE_UNKNOWN;
  private dateAdded: number = VALUE_UNKNOWN;
  private dateTaken: number = VALUE_UNKNOWN;
  private dateDay: string = '';
  private subLocalityAddress: string = '';
  private size: number = VALUE_UNKNOWN;
  private position: number = Number.NaN;

  constructor(data?: PhotoAsset) {
    if (!data) {
      return;
    }
    this.initialize(data);
  }

  /**
   * 从MediaItem中解析出SimpleGridMediaItem
   *
   * @param mediaItem 待解析的MediaItem
   * @returns 解析后的SimpleGridMediaItem
   */
  public static parseFromMediaItem(mediaItem?: MediaItem): SimpleGridMediaItem | undefined {
    if (!mediaItem || !mediaItem.data) {
      return undefined;
    }

    return new SimpleGridMediaItem(mediaItem.data);
  }

  /**
   * 获取MediaItem的路径
   *
   * @returns 路径
   */
  public getPath(): string {
    if (this.path) {
      return this.path;
    }
    if (!this.data) {
      return '';
    }
    this.path = String(AssetHelper.get(this.data, Constants.KEY_FILE_DATA, ''));
    return this.path;
  }

  /**
   * 获取MediaItem的size
   *
   * @returns size
   */
  public getSize(): number {
    if (this.size) {
      return this.size;
    }
    if (!this.data) {
      return 0;
    }
    this.size = Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.SIZE, 0));
    return this.size;
  }

  /**
   * 获取MediaItem的修改日期
   *
   * @returns 修改日期
   */
  public getDateModified(): number {
    if (this.dateModified !== VALUE_UNKNOWN) {
      return this.dateModified;
    }
    if (!this.data) {
      return 0;
    }
    const dateModifiedKey = photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString();
    this.dateModified = Number(AssetHelper.get(this.data, dateModifiedKey, 0));
    return this.dateModified;
  }

  /**
   * 获取缩略图的生成日期
   *
   * @returns 生成日期
   */
  public getThumbnailReady(): number {
    if (this.thumbnailReady !== VALUE_UNKNOWN) {
      return this.thumbnailReady;
    }
    if (!this.data) {
      return 0;
    }
    const thumbnailReadyKey = UserFileManagerAccess.FILE_KEY_THUMBNAIL_READY.toString();
    this.thumbnailReady = Number(AssetHelper.get(this.data, thumbnailReadyKey, 0));
    return this.thumbnailReady;
  }

  /**
   * 设置MediaItem的缩略图生成日期
   *
   * @param thumbnailReady 缩略图生成日期
   */
  public setThumbnailReady(thumbnailReady: number): void {
    this.thumbnailReady = thumbnailReady;
  }

  /**
   * 获取MediaItem的旋转角度
   *
   * @returns 旋转角度
   */
  public getOrientation(): number {
    if (this.orientation !== VALUE_UNKNOWN) {
      return this.orientation;
    }
    if (!this.data) {
      return 0;
    }
    this.orientation = Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
    return this.orientation;
  }

  /**
   * 设置MediaItem的旋转角度
   *
   * @param orientation 旋转角度
   */
  public setOrientation(orientation: number): void {
    this.orientation = orientation;
  }

  /**
   * 获取MediaItem的收藏属性
   *
   * @returns true表示已收藏
   */
  public isFavorite(): boolean {
    if (this.favorProp !== VALUE_UNKNOWN) {
      return this.favorProp === FLAG_FAVORITE;
    }
    if (!this.data) {
      return false;
    }
    let isFavor: boolean = Boolean(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.FAVORITE.toString(), false));
    this.favorProp = isFavor ? FLAG_FAVORITE : FLAG_NOT_FAVORITE;
    return isFavor;
  }

  /**
   * 设置MediaItem的收藏属性
   *
   * @param isFavor 是否已收藏
   */
  public setFavorite(isFavor: boolean): void {
    this.favorProp = isFavor ? FLAG_FAVORITE : FLAG_NOT_FAVORITE;
  }

  /**
   * 获取MediaItem的缩略图uri
   *
   * @returns 缩略图uri
   */
  public getThumbnailUri(): string {
    if (this.thumbnailUri) {
      return this.thumbnailUri;
    }
    if (!this.data) {
      return '';
    }
    this.thumbnailUri = ImageUtil.getThumbnailUri(this.uri, this.getPath(), this.getDateModified(), true,
      this.getThumbnailReady());
    return this.thumbnailUri;
  }

  /**
   * 设置MediaItem的缩略图uri
   *
   * @param 缩略图uri
   */
  public setThumbnailUri(thumbnailUri: string): void {
    this.thumbnailUri = thumbnailUri;
  }

  /**
   * 获取视频MediaItem的时长
   *
   * @returns 时长
   */
  public getDuration(): number {
    if (this.duration !== VALUE_UNKNOWN) {
      return this.duration;
    }
    if (!this.data) {
      return 0;
    }
    if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      this.duration = Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.DURATION, 0));
      if (this.duration === 0) {
        Log.warn(TAG, `duration is zero, video uri: ${this.uri}`);
      }
      this.orientation = 0;
    }
    return this.duration;
  }

  /**
   * 设置视频MediaItem的时长
   *
   * @param duration 时长
   */
  public setDuration(duration: number): void {
    this.duration = duration;
  }

  /**
   * 获取MediaItem的回收时间
   *
   * @returns 回收时间
   */
  public getDateTrashed(): number {
    if (this.dateTrashed !== VALUE_UNKNOWN) {
      return this.dateTrashed;
    }
    if (!this.data) {
      return 0;
    }
    this.dateTrashed = Number(AssetHelper.get(this.data, 'date_trashed_ms'/*photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString()*/, 0));
    return this.dateTrashed;
  }

  /**
   * 设置MediaItem的回收时间
   *
   * @param dateTrashed 回收时间
   */
  public setDateTrashed(dateTrashed: number): void {
    this.dateTrashed = dateTrashed;
  }

  /**
   * 获取图片或视频MediaItem的dateAdded
   *
   * @returns dateAdded
   */
  public getDateAdded(): number {
    if (this.dateAdded !== VALUE_UNKNOWN) {
      return this.dateAdded;
    }
    if (!this.data) {
      return 0;
    }
    this.dateAdded = Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.DATE_ADDED_MS, 0));
    if (this.dateAdded === 0) {
      Log.warn(TAG, `dateAdded is zero, video or image uri: ${this.uri}`);
    }
    return this.dateAdded;
  }

  /**
   * 获取图片或视频MediaItem的dateTaken
   *
   * @returns dateTaken
   */
  public getDateTaken(): number {
    if (this.dateTaken !== VALUE_UNKNOWN) {
      return this.dateTaken;
    }
    if (!this.data) {
      return Number.NaN;
    }
    this.dateTaken = Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.DATE_TAKEN_MS, 0));
    if (this.dateTaken === 0) {
      Log.warn(TAG, `dateTaken is zero, video or image uri: ${this.uri}`);
    }
    return this.dateTaken;
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
  }

  /**
   * 设置图片或视频MediaItem的dateDay
   *
   * @param dateDay 图片或视频MediaItem的dateDay
   */
  public setDateDay(dateDay: string): void {
    this.dateDay = dateDay;
  }

  /**
   * 设置图片或视频MediaItem的dateAdded
   *
   * @param dateAdded 图片或视频MediaItem的dateAdded
   */
  public setDateAdded(dateAdded: number): void {
    this.dateAdded = dateAdded;
  }

  /**
   * 获取图片或视频位置，本地图片还是云端图片
   *
   * @returns dateTaken
   */
  public getPosition(): number {
    if (Object.values(photoAccessHelper.PositionType).includes(this.position)) {
      return this.position;
    }
    if (!this.data) {
      return Number.NaN;
    }
    this.position =
      Number(AssetHelper.get(this.data, photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.LOCAL));
    return this.position;
  }

  /**
   * 设置图片或视频位置，本地图片还是云端图片
   *
   * @param dateAdded 图片或视频MediaItem的dateAdded
   */
  public setPosition(position: number): void {
    this.position = position;
  }

  /**
   * 通过PhotoAsset.get接口解析属性
   *
   * @returns 解析后的SimpleGridMediaItem
   */
  public parseFromPhotoAsset(): SimpleGridMediaItem {
    this.getThumbnailUri();
    this.getThumbnailReady();
    this.getOrientation();
    this.isFavorite();
    this.getDuration();
    this.getDateAdded();
    this.getPosition();
    return this;
  }

  /**
   * 根据相册属性，通过PhotoAsset.get接口解析属性
   *
   * @returns 解析后的SimpleGridMediaItem
   */
  public parseFromAlbum(album?: PhotoAlbum): SimpleGridMediaItem {
    if (album?.albumSubtype === UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE) {
      this.getDateTrashed();
    }
    return this;
  }

  private initialize(data: PhotoAsset): void {
    this.data = data;
    this.mediaType = data.photoType;
    this.uri = data.uri;
    this.displayName = data.displayName;
    this.size = Number(AssetHelper.get(data, photoAccessHelper.PhotoKeys.SIZE, 0));
  }

  public async getSubLocalityStatic(): Promise<string> {
    if (!this.data) {
      return '';
    }
    if (this.subLocalityAddress.length) {
      return this.subLocalityAddress;
    }
    let detailAddress: string =
      await this.data.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_DETAIL_ADDRESS);
    let cityName: string = JSON.parse(detailAddress)[0].city_name;
    let subLocality: string = JSON.parse(detailAddress)[0].sub_locality;
    if (cityName && subLocality) {
      this.subLocalityAddress = cityName + `，${subLocality}`;
    } else {
      this.subLocalityAddress = cityName + subLocality;
    }
    return this.subLocalityAddress;
  }
}