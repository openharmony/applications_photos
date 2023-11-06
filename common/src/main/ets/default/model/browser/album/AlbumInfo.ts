/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import { Album, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

import type { MediaItem } from '../photo/MediaItem';

export class AlbumInfo {
  uri: string;
  coverUri: string;
  albumName: string;
  count: number;
  isSystemAlbum: boolean;
  isTrashAlbum: boolean;
  isFavorAlbum: boolean;
  isVideoAlbum: boolean;
  isScreenShotAlbum: boolean;
  isPhotoAlbum: boolean;
  filterMediaType: string;
  dateModified: number;
  videoCount: number;
  mediaItem: MediaItem;
  deviceName: string;
  deviceId: string;

  constructor(album?: Album) {
    if (album) {
      this.uri = album.albumUri;
      this.coverUri = album.coverUri;
      this.isSystemAlbum = UserFileManagerAccess.getInstance().isSystemAlbum(album);
      this.isTrashAlbum = UserFileManagerAccess.getInstance().isTrashAlbum(album);
      this.isFavorAlbum = UserFileManagerAccess.getInstance().isFavorAlbum(album);
      this.isVideoAlbum = UserFileManagerAccess.getInstance().isVideoAlbum(album);
      this.isScreenShotAlbum = UserFileManagerAccess.getInstance().isScreenShotAlbum(album);
      this.isPhotoAlbum = UserFileManagerAccess.getInstance().isPhotoAlbum(album);
      this.count = album.count; // TODO 相册count都是0
      this.dateModified = album.dateModified;
    }
  }

  setMediaItem(mediaItem: MediaItem) {
    this.mediaItem = mediaItem;
  }

  setAlbumName(albumName: string): void {
    this.albumName = albumName;
  }

  setCount(count: number): void {
    this.count = count;
  }

  setVideoCount(count: number): void {
    this.videoCount = count;
  }

  setFilterMediaType(filterMediaType: string): void {
    this.filterMediaType = filterMediaType;
  }

  setCoverUri(coverUri: string): void {
    this.coverUri = coverUri;
  }

  getHashCode(): string {
    return `${this.uri}_${this.coverUri}_${this.count}_${this.albumName}`;
  }
}
