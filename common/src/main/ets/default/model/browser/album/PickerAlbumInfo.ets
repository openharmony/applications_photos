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
import lazy { collections } from '@kit.ArkTS';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { PhotoAlbum } from '../../../access/UserFileManagerAccess';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { AlbumInfo } from '../album/AlbumInfo';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { Constants } from '../../../model/common/Constants';
export const PICKER_ALBUM_FETCH_COLUMNS: string[] = [
  photoAccessHelper.PhotoKeys.URI.toString(),
  photoAccessHelper.PhotoKeys.WIDTH.toString(),
  photoAccessHelper.PhotoKeys.HEIGHT.toString(),
  photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
  UserFileManagerAccess.GROUP_BY_KEY,
  'owner_album_id',
];

@Sendable
export class PickerAlbumInfo {
  public uri: string = '';
  public albumName: string = '';
  public albumType: undefined | number = undefined;
  public albumSubtype: undefined | number = undefined;
  public lpath: undefined | string = '';
  public coverUri: string = '';
  public count: number = Number.NaN;
  public isSystemAlbum: boolean = false;
  public isVideoAlbum: boolean = false;
  public isPhotoAlbum: boolean = false;
  public unionAlbumUris: collections.Array<string> = new collections.Array<string>();

  constructor(photoAlbum?: PhotoAlbum) {
    if (!photoAlbum) {
      return;
    }
    this.uri = photoAlbum.albumUri;
    this.isSystemAlbum = AlbumDefine.isSystemAlbum(photoAlbum.albumType);
    this.isVideoAlbum = AlbumDefine.isVideoAlbum(photoAlbum.albumSubtype);
    this.isPhotoAlbum = AlbumDefine.isSystemAlbum(photoAlbum.albumSubtype);
    this.albumType = photoAlbum.albumType;
    this.albumSubtype = photoAlbum.albumSubtype;
    this.lpath = photoAlbum.lpath;
  }

  public getAlbumNameResource(): ResourceStr {
    if (this.uri === 'file://media/PhotoAlbum/pictures_and_videos') {
      return $r('app.string.pictures_and_videos');
    }
    if (this.isSystemAlbum) {
      // 系统相册，图库自己命名
      switch (this.albumSubtype) {
        case photoAccessHelper.AlbumSubtype.IMAGE:
          return $r('app.string.album_photos');
        case photoAccessHelper.AlbumSubtype.FAVORITE:
          return $r('app.string.album_favor');
        case photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT:
          return $r('app.string.album_cloud_enhance');
        case photoAccessHelper.AlbumSubtype.VIDEO:
          return $r('app.string.album_video');
        case photoAccessHelper.AlbumSubtype.TRASH:
          return $r('app.string.album_recycle');
        default:
          return '';
      }
    }
    // 系统来源相册需要自己命名
    if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
      switch (this.lpath) {
        case Constants.LPATH_CAMERA:
          return $r('app.string.source_camera');
        case Constants.LPATH_SCREEN_SHOT:
          return $r('app.string.source_screenshot');
        case Constants.LPATH_SCREEN_RECORDING:
          return $r('app.string.source_screen_recording')
        default:
          return this.albumName;
      }
    }
    // 用户相册，直接返回
    return this.albumName;
  }

  public convertFromAlbumInfo(albumInfo: AlbumInfo): void {
    this.uri = albumInfo.uri;
    this.coverUri = albumInfo.coverUri;
    this.uri = albumInfo.uri;
    this.count = albumInfo.count;
    this.isSystemAlbum = albumInfo.isSystemAlbum;
    this.isVideoAlbum = albumInfo.isVideoAlbum;
    this.isPhotoAlbum = albumInfo.isPhotoAlbum;
    if (!this.isSystemAlbum) {
      this.albumName = String(albumInfo.albumName);
    }
    if (!albumInfo.unionAlbumUris) {
      return;
    }
    albumInfo.unionAlbumUris.forEach((uri: string) => {
      this.unionAlbumUris.push(uri);
    });
  }

  public getUnionAlbumUrisArray(): string[] {
    let unionAlbumUrisArray: string[] = [];
    if (!this.unionAlbumUris || this.unionAlbumUris.length) {
      return unionAlbumUrisArray;
    }
    this.unionAlbumUris.forEach((uri: string) => {
      unionAlbumUrisArray.push(uri);
    })
    return unionAlbumUrisArray;
  }
}