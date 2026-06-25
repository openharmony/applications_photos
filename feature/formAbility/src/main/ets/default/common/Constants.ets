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

export class Constants {
  /* instrument ignore file */
  public static readonly PHOTOS_FORM_STORAGE_PREFIX: string = 'photos_form_';
  public static readonly PHOTOS_FORM_CAMERA_NAME: string = 'Camera';
  public static readonly PHOTOS_FORM_ALBUM_NAME_ALL: string = 'default_all';
  public static readonly PHOTOS_FORM_OPERATION_MODE_NONE: number = 0;
  public static readonly PHOTOS_FORM_OPERATION_MODE_DESTROY: number = 1;
  public static readonly PHOTOS_FORM_OPERATION_MODE_UPDATE: number = 2;
  public static readonly PHOTOS_FORM_OPERATION_MODE_EVENT: number = 3;
  public static readonly PHOTOS_FORM_OPERATION_MODE_CALLBACK: number = 4;
  public static readonly PHOTOS_FORM_OPERATION_IS_SHOW_ALBUM_NAME: number = 5;
  public static readonly FORM_ID: string = 'formId_';
  public static readonly DISPLAY_NAME: string = 'displayName_';
  public static readonly ALBUM_NAME: string = 'albumName_';
  public static readonly CURRENT_URL: string = 'currentUri_';
  public static readonly INTERVAL_TIME: string = 'intervalTime_';
  public static readonly CURRENT_INDEX: string = 'currentIndex_';
  public static readonly FLEX_GROW: number = 2;
  public static readonly DIALOG_BOTTOM_OFFSET: number = 12;
  public static readonly DEFAULT_TIME: number = 30;
  public static readonly FROM_PLAYBACK_INTERVAL: string = 'form_playback_interval';
  public static readonly FROM_PLAYBACK_IS_SHOW_NAME: string = 'form_playback_isShowName';
  public static readonly PHOTOS_FORM_DEFAULT_PERIOD: number = 5;
  public static readonly FA_INDEX_VALUE: string = 'faIndexValue';
  public static readonly FA_FD_NULL: number = -1;
  public static readonly RADIO_DIVIDER_STROKE_WIDTH: number = 0.5;
  public static readonly FROM_IMAGE_DATA_KEY: string =
    'datashareproxy://com.ohos.medialibrary.medialibrarydata/image_data';
  public static readonly FROM_IMAGE_JUMP_KEY: string =
    'datashareproxy://com.ohos.medialibrary.medialibrarydata/image_uri';
}