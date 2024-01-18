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

import { AlbumDefine, Constants } from '@ohos/common';

export class FormConstants {
  public static FORM_ITEM_ALBUM_URI = 'form_itemAlbumUri';
  public static FORM_ITEM_DISPLAY_NAME = 'form_itemDisplayName';
}

/**
 * Record parameters passed from outside moduel: FA/third apps
 * These parameters should not be modified after read from want
 */
export class SelectParams {
  /* max select count */
  maxSelectCount: number;
  /* select media type */
  filterMediaType: string;
  isFromWallpaper: boolean;
  /* whether entered from FA */
  isFromFa: boolean;
  /* whether entered from pick photos in FA */
  isFromFaPhoto: boolean;
  /* whether is multiple pick */
  isMultiPick: boolean;
  /* caller bundle name */
  bundleName: string;
  /* whether picker from Camera */
  cameraAble: boolean;
  /* whether picker can edit */
  editAble: boolean;
  preselectedUris: string[];
  uri: string;
  itemDisplayName: string;
  itemId: string;
  isFirstEnter: boolean;
  itemCount: number;
  itemCoverUri: string;
  remainingOfWallpapers: number;

  static defaultParam(): SelectParams {
    return {
      maxSelectCount: Constants.DEFAULT_MAX_THIRD_SELECT_COUNT,
      filterMediaType: AlbumDefine.FILTER_MEDIA_TYPE_ALL,
      isFromWallpaper: false,
      isFromFa: false,
      isFromFaPhoto: false,
      isMultiPick: false,
      bundleName: '',
      cameraAble: true,
      editAble: true,
      preselectedUris: [],
      uri: '',
      itemDisplayName: undefined,
      itemId: '',
      isFirstEnter: false,
      itemCount: 0,
      itemCoverUri: '',
      remainingOfWallpapers: 0
    };
  }
}
/* storage key begin */
export const THIRD_SELECT_IS_ORIGIN = 'third_select_is_origin';

export const IS_SPLIT_MODE = 'isSplitMode';

export const LEFT_BLANK = 'leftBlank';

export const IS_SIDE_BAR = 'isSidebar';

export const IS_HORIZONTAL = 'isHorizontal';
/* storage key end */

export const THUMBNAIL_WIDTH: number = 256;