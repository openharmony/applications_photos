/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
export enum MediaObserverNfyType {
  NONE,
  PHOTO_ADD = 1,
  PHOTO_REMOVE,
  PHOTO_UPDATE,
  ALBUM_ADD = 11,
  ALBUM_REMOVE,
  ALBUM_UPDATE,
  ADD_PHOTO_INTO_ALBUM = 21,
  REMOVE_PHOTO_FROM_ALBUM,
}

export class MediaObserverNfyInfo {
  type: number;
  uris: Array<string>;
  albumUris: Array<string>;

  constructor() {
    this.type = MediaObserverNfyType.NONE;
    this.uris = [];
    this.albumUris = [];
  }
}

export interface MediaObserverCallback {
  onChange(mediaType: string): void;
}