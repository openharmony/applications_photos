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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { PositionFilter } from './PositionFilter';

export type FetchOptions = photoAccessHelper.FetchOptions;


export class UserFileData {
  public static readonly GROUP_BY_KEY: string = 'count(*)';
  public static readonly FILE_KEY_DATE_TAKEN_MS = photoAccessHelper.PhotoKeys.DATE_TAKEN_MS;
  public static readonly FILE_KEY_SIZE = photoAccessHelper.PhotoKeys.SIZE;
  public static readonly FILE_KEY_DISPLAY_NAME = photoAccessHelper.PhotoKeys.DISPLAY_NAME;
  public static readonly FILE_KEY_DATE_ADDED = photoAccessHelper.PhotoKeys.DATE_ADDED;
  public static readonly FILE_KEY_DATE_ADDED_MS = photoAccessHelper.PhotoKeys.DATE_ADDED_MS;
  public static readonly FILE_KEY_DATE_TRASHED = 'date_trashed'//photoAccessHelper.PhotoKeys.DATE_TRASHED;
  public static readonly FILE_KEY_TITLE = photoAccessHelper.PhotoKeys.TITLE;
  public static readonly FILE_KEY_OWNER_ALBUM_ID = 'owner_album_id';
  public static readonly GET_ASSERT_WITHOUT_BURST_PHOTO = 10004;
  public static readonly GET_ASSERT_WITHOUT_CLOUD = 10000;
  public static readonly GET_ASSERT_WITHOUT_LOCAL = 10001;
  public static readonly THUMBNAIL_READY_VALUE = '2';
  public static readonly FILE_KEY_THUMBNAIL_READY = 'thumbnail_ready';
  public static readonly BURST_KEY = 'burst_key';
  // 云上和本地都有
  public static readonly FILE_LOCATION_BOTH = 2;
  //本地图片上云后
  public static readonly FILE_LOCATION_LOCAL_CLOUD = 3;
  public static readonly FILE_LOCATION_LOCAL = photoAccessHelper.PositionType.LOCAL;
  public static readonly FILE_LOCATION_CLOUD = photoAccessHelper.PositionType.CLOUD;
  public static readonly FILE_KEY_THUMBNAIL_VISIBLE = 'thumbnail_visible';
  public static readonly MEDIA_TYPE_IMAGE = photoAccessHelper.PhotoType.IMAGE;
  public static readonly MEDIA_TYPE_VIDEO = photoAccessHelper.PhotoType.VIDEO;
  public static readonly SUB_TYPE_MOVING_PHOTO = photoAccessHelper.PhotoSubtype.MOVING_PHOTO;
  public static readonly THUMBNAIL_VISIBLE_VALUE = 1;
  public static readonly FILE_KEY_FILE_ID = 'file_id';
  public static readonly FETCH_COLUMNS_SIZE = 'size';
  public static readonly FETCH_COLUMNS_MIME_TYPE = 'mime_type';
  public static readonly FETCH_COLUMNS_LCD_SIZE = 'lcd_size';
  public static readonly FETCH_COLUMNS_THM_SIZE = 'thumb_size';
  public static readonly FETCH_COLUMNS_PHOTO_QUALITY = 'photo_quality';
  public static readonly FETCH_COLUMNS_IS_CE_AUTO = 'is_auto';
  public static readonly SHOOTING_MODE_TAG = 'shooting_mode_tag';
  public static readonly FRONT_CAMERA = 'front_camera';
  public static readonly FETCH_LCD_THM_SPLIT_SYMBOLS = ':';
  public static readonly KEY_OWNER_ALBUM_ID: string = 'owner_album_id';
  public static readonly ALL_IMAGE_VIDEO_FETCH_COLUMNS: string[] = [
    UserFileData.FILE_KEY_FILE_ID,
    photoAccessHelper.PhotoKeys.URI.toString(),
    photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
    photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
    photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
    photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
    photoAccessHelper.PhotoKeys.TITLE.toString(),
    // photoAccessHelper.PhotoKeys.CE_AVAILABLE.toString(),
    "ce_available",
    photoAccessHelper.PhotoKeys.DURATION.toString(),
    photoAccessHelper.PhotoKeys.WIDTH.toString(),
    photoAccessHelper.PhotoKeys.HEIGHT.toString(),
    photoAccessHelper.PhotoKeys.DATE_TAKEN_MS.toString(),
    photoAccessHelper.PhotoKeys.DETAIL_TIME.toString(),
    photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
    photoAccessHelper.PhotoKeys.FAVORITE.toString(),
    photoAccessHelper.PhotoKeys.POSITION.toString(),
    // photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString()
    'date_trashed_ms',
    // photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE.toString(),
    'moving_photo_effect_mode',
    photoAccessHelper.PhotoKeys.DYNAMIC_RANGE_TYPE.toString(),
    photoAccessHelper.PhotoKeys.COVER_POSITION.toString(),
    // photoAccessHelper.PhotoKeys.HIDDEN.toString(),
    "hidden",
    UserFileData.FETCH_COLUMNS_SIZE, // Waiting: 等媒体库枚举字段上库
    UserFileData.FETCH_COLUMNS_MIME_TYPE,
    UserFileData.BURST_KEY, // 连拍关键字
    UserFileData.FETCH_COLUMNS_LCD_SIZE,
    UserFileData.FETCH_COLUMNS_THM_SIZE,
    UserFileData.FILE_KEY_DATE_TAKEN_MS,
    UserFileData.FETCH_COLUMNS_THM_SIZE,
    UserFileData.FILE_KEY_THUMBNAIL_READY.toString(), // 增加缩略图生成时间
    UserFileData.FETCH_COLUMNS_PHOTO_QUALITY,
    UserFileData.FETCH_COLUMNS_IS_CE_AUTO,
    UserFileData.SHOOTING_MODE_TAG,
    UserFileData.FRONT_CAMERA,
    'original_subtype',
    // photoAccessHelper.PhotoKeys.DATE_DAY,
    'date_day',
    UserFileData.KEY_OWNER_ALBUM_ID,
  ];

  private constructor() {
  }

  public static convertPosition(predicates: dataSharePredicates.DataSharePredicates,
    filter: PositionFilter | undefined): void {
    if (!predicates || !filter) {
      return;
    }
    switch (filter) {
      case PositionFilter.LOCAL:
        predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.LOCAL);
        break;
      case PositionFilter.CLOUD:
        predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.CLOUD);
        break;
      case PositionFilter.BOTH:
        predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, Number(PositionFilter.BOTH));
        break;
      case PositionFilter.LOCAL_OR_CLOUD:
        // predicates.beginWrap()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.LOCAL)
        //   .or()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.CLOUD)
        //   .endWrap();
        break;
      case PositionFilter.LOCAL_OR_BOTH:
        // predicates.beginWrap()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.LOCAL)
        //   .or()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, Number(PositionFilter.BOTH))
        //   .endWrap();
        break;
      case PositionFilter.CLOUD_OR_BOTH:
        // predicates.beginWrap()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, photoAccessHelper.PositionType.CLOUD)
        //   .or()
        //   .equalTo(photoAccessHelper.PhotoKeys.POSITION, Number(PositionFilter.BOTH))
        //   .endWrap();
        break;
      default:
        break;
    }
  }
}