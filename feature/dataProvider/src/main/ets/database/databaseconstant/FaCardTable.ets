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
export enum FaCardTable {
  TABLE_NAME = 'facard',

  FORM_ID = 'form_id',

  ALBUM_URI = 'album_uri',

  COVER_URI = 'cover_uri',

  COVER_DATA = 'cover_data',

  COVER_TYPE = 'cover_type',

  IS_ALBUM = 'is_album',

  // 0: ALL; 1: ALBUM; 2: HIGHLIGHT_ALBUM; 3: SINGLE
  ALBUM_TYPE = 'album_type',

  // 15, 30
  PLAYBACK_INTERVAL = 'playback_interval',

  // string | Resource
  ALBUM_NAME = 'album_name',

  // 0: DO NOT SHOW; 1: SHOW
  IS_SHOW_ALBUM_NAME = 'is_show_album_name',
}

export enum AlbumType {
  NOT_FOUND = -1,
  ALL = 0,
  ALBUM = 1,
  HIGHLIGHT_ALBUM = 2, // 时刻相册
  SINGLE = 3,
  PORTRAIT_ALBUM = 4, //人像相册
}

export enum IsShowAlbumName{
  OFF,
  ON
}

export const FACARD_DEFAULT_VALUE: Record<string, number | string> = {
  'form_id': 1,
}