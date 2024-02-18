/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import photoAccessHelper from '@ohos.file.photoAccessHelper';

export default class SmartPickerConstants {
  static readonly INVALID: number = -1;
  static readonly INVALID_PHOTO_SELECT_TYPE: number = -1;
  static readonly SMART_PICKER_MANAGER: string = 'smart_picker_manager';
  static readonly LABEL_ID_CARD: string = '4';
  static readonly LABEL_QR_CODE: string = '191';
  static readonly LABEL_BAR_CODE: string = '192';
  static readonly LABEL_AVATAR: string = '10000';
  static readonly LABEL_ALL_PHOTO: string = '10001';

  static readonly RECOMMEND_TYPE_LABEL: number = 1;
  static readonly RECOMMEND_TYPE_PROFILE: number = 2;
  static readonly RECOMMEND_TYPE_CONTENT: number = 3;
  static readonly VIRTUAL_ALBUM_URI_PREFIX: string = 'file://media/SmartPickerPhotoAlbum/';

  static readonly PHOTO_SELECT_TYPE_DEFAULT: number = 0;

  static readonly QR_OR_BAR_CODE: number = 1;
  static readonly QR_CODE: number = 2;
  static readonly BAR_CODE: number = 3;
  static readonly ID_CARD: number = 4;
  static readonly PROFILE_PICTURE: number = 5;

  static readonly NAME_ID_CARD: string = '身份证';
  static readonly NAME_QR_CODE: string = '二维码';
  static readonly NAME_BAR_CODE: string = '条码';
  static readonly NAME_AVATAR: string = '头像';

  static readonly LABEL_NAME_MAP: Map<string, string> = new Map([
    [SmartPickerConstants.NAME_ID_CARD, SmartPickerConstants.LABEL_ID_CARD],
    [SmartPickerConstants.NAME_QR_CODE, SmartPickerConstants.LABEL_QR_CODE],
    [SmartPickerConstants.NAME_BAR_CODE, SmartPickerConstants.LABEL_BAR_CODE],
    [SmartPickerConstants.NAME_AVATAR, SmartPickerConstants.LABEL_AVATAR],
  ]);

  static readonly LABEL_ID_KEY: string = 'album_name';
  static readonly RECOMMEND_TAB_BORDER_RADIUS: number = 20;

  static readonly ALL_IMAGE_VIDEO_FETCH_COLUMNS: Array<string> = [
    photoAccessHelper.PhotoKeys.URI.toString(),
    photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
    photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
    photoAccessHelper.PhotoKeys.DATE_ADDED.toString(),
    photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString(),
    photoAccessHelper.PhotoKeys.TITLE.toString(),
    photoAccessHelper.PhotoKeys.DURATION.toString(),
    photoAccessHelper.PhotoKeys.WIDTH.toString(),
    photoAccessHelper.PhotoKeys.HEIGHT.toString(),
    photoAccessHelper.PhotoKeys.DATE_TAKEN.toString(),
    photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
    photoAccessHelper.PhotoKeys.FAVORITE.toString(),
    photoAccessHelper.PhotoKeys.POSITION.toString(),
    photoAccessHelper.PhotoKeys.DATE_TRASHED.toString(),
    photoAccessHelper.PhotoKeys.HIDDEN.toString(),
    photoAccessHelper.PhotoKeys.SIZE.toString()
  ];
  static readonly PICKER_INIT_DATA_FIRST_QUERY_FINISH: string = 'picker_init_data_first_query_finish';
}

