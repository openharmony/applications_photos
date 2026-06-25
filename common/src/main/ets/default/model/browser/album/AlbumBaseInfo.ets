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

import lazy { PhotoAlbum, PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import type { MediaItem } from '../photo/MediaItem';
import lazy { AlbumDefine } from '../AlbumDefine';

type AlbumSet = PhotoAlbum;

const TAG: string = 'AlbumBaseInfo';

@Observed
export class AlbumBaseInfo {
  public uri: string = '';
  public coverUri: string = '';
  public albumName: Resource | string = '';
  public count: number = Number.NaN;
  public dateModified?: number;
  public videoCount: number = Number.NaN;
  public mediaItem: MediaItem | undefined;
  public albumId: number = Number.NaN;
  public albumType: number = Number.NaN;
  public albumSubtype: number = Number.NaN;
  public lpath: string | undefined;

  constructor(album?: AlbumSet) {
    if (album) {
      this.uri = album.albumUri;
      this.coverUri = album.coverUri;
      this.count = album.count;
      this.videoCount = album.videoCount ?? 0;
      this.albumType = album.albumType;
      this.albumSubtype = album.albumSubtype;
      this.lpath = album.lpath;
      this.albumId = this.getAlbumId(album);
      this.albumName = PhotoAccessHelperAccess.getAlbumNameResource(album);
    }
  }

  public getAlbumId(album: PhotoAlbum): number {
    const temp = album.albumUri.split('/');
    return Number(temp[temp.length - 1]);
  }

  public setUri(uri: string): void {
    this.uri = uri;
  }

  public setCoverUri(coverUri: string): void {
    this.coverUri = coverUri;
  }

  public setCount(count: number): void {
    this.count = count;
  }

  public setVideoCount(count: number): void {
    this.videoCount = count;
  }

  public setMediaItem(mediaItem: MediaItem): void {
    this.mediaItem = mediaItem;
  }

  public setAlbumName(albumName: string): void {
    this.albumName = albumName;
  }

  public setSubtype(albumSubtype: number): void {
    this.albumSubtype = albumSubtype;
  }

  public toString(): string {
    return JSON.stringify(this, AlbumDefine.albumNameReplacer);
  }
}