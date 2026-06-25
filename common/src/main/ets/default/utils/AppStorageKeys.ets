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

export class AppStorageKeys {
  private constructor() {
  }

  public static readonly MAIN_WINDOW: string = 'mainWindow';
  public static readonly CLOUD_DRIVE_STATUS: string = 'cloudDriveStatus';
  public static readonly CLOUD_FULL_CARD_DATA: string = 'cloudFullCardData';
  public static readonly CLOUD_TOTAL_SPACE: string = 'cloudTotalSpace';
  public static readonly DEFAULT_CLOUD_FULL_CARD_DATA: string = 'defaultCloudFullCardData';
  public static readonly FULL_TIPS_CONFIRM_TEXT: string = 'fullTipsConfirmText';
  public static readonly FULL_TIPS_PUSH_PARAMS: string = 'fullTipsPushParams';
  public static readonly IS_FULL_CARD_SHOW: string = 'isFullCardShow';
  public static readonly SYNC_STATUS: string = 'syncStatus';
  public static readonly UNLIMITED_USE_OF_MOBILE_NETWORK: string = 'unlimitedUseOfMobileNetwork';
  public static readonly Z_OPERATION_LIST: string = 'zOperationList';
  public static readonly Y_OPERATION_LIST: string = 'yOperationList';
  public static readonly FORM_CURRENT_URI: string = 'form_currentUri';
  public static readonly SHARE_ANCHOR_POINT: string = 'shareAnchorPoint';
  public static readonly CALENDER_NAVIGATION_TIME: string = 'com.ohos.photos.Calender_Navigation_Time';
  public static readonly CALENDER_NAVIGATION_INFO: string = 'com.ohos.photos.Calender_Navigation_Info';
  public static readonly CALENDER_LOCK_CLOUD_CARD_ONCE: string = 'com.ohos.photos.Calender_lock_cloud_card';
  public static readonly IS_PHOTO_GRID_FOCUSED: string = 'isPhotoGridFocused';
}