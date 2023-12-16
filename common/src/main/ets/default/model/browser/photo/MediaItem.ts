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
import userFileManager from '@ohos.filemanagement.userFileManager';
import { Log } from '../../../utils/Log';
import { FileAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import { DateUtil } from '../../../utils/DateUtil';
import { Constants } from '../../common/Constants';
import { AlbumDefine } from '../AlbumDefine';
import type photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG: string = 'common_MediaItem';

export const isPhotoAsset =
  (assets: FileAsset | photoAccessHelper.PhotoAsset): assets is photoAccessHelper.PhotoAsset => (<photoAccessHelper.PhotoAsset> assets).photoType !== undefined;

export class MediaItem {
  index?: number;
  mediaType: number;
  uri: string;
  thumbnail: string;
  duration: number;
  private title: string;
  size: number;
  private dateTaken: number;
  private dateModified: number;
  orientation: number;
  width: number;
  height: number;
  imgWidth: number;
  imgHeight: number;
  isFavor: boolean;
  displayName: string;
  dateTrashed: number;
  private position: userFileManager.PositionType;
  hashCode: string;
  private data: userFileManager.FileAsset | photoAccessHelper.PhotoAsset;
  path: string;

  constructor(data?: userFileManager.FileAsset | photoAccessHelper.PhotoAsset) {
    this.initialize(data);
  }

  initialize(data?: userFileManager.FileAsset | photoAccessHelper.PhotoAsset): void {
    if (!data) {
      return;
    }

    this.mediaType = isPhotoAsset(data) ? data.photoType : data.fileType;
    this.displayName = data.displayName;
    this.data = data;
    if (this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.duration = Number(data.get(userFileManager.ImageVideoKey.DURATION.toString()));
    }
    this.size = Number(data.get('size'));
    this.orientation = Number(data.get(userFileManager.ImageVideoKey.ORIENTATION.toString()));
    if (this.orientation === Constants.ANGLE_90 || this.orientation === Constants.ANGLE_270) {
      this.width = Number(data.get(userFileManager.ImageVideoKey.HEIGHT.toString()));
      this.height = Number(data.get(userFileManager.ImageVideoKey.WIDTH.toString()));
    } else {
      this.width = Number(data.get(userFileManager.ImageVideoKey.WIDTH.toString()));
      this.height = Number(data.get(userFileManager.ImageVideoKey.HEIGHT.toString()));
    }
    this.uri = data.uri;
    this.path = String(data.get(Constants.KEY_FILE_DATA));
    this.imgWidth = this.width;
    this.imgHeight = this.height;
    this.dateTrashed = Number(data.get(userFileManager.ImageVideoKey.DATE_TRASHED.toString()));
    this.isFavor = Boolean(data.get(userFileManager.ImageVideoKey.FAVORITE.toString()));
    this.hashCode = `${this.uri}_${this.size}_${this.orientation}_${this.isFavor}`;
  }

  async getObject(fetchOpt): Promise<FileAsset> {
    let object: FileAsset = await UserFileManagerAccess.getInstance().getObject(fetchOpt);
    return object;
  }

  async getItemByUri(uri: string): Promise<FileAsset> {
    let object: FileAsset = null;
    let fetchOpt = AlbumDefine.getFileFetchOptByUri(uri);
    object = await this.getObject(fetchOpt);
    return object;
  }

  setThumbnail(thumbnail: string) {
    this.thumbnail = thumbnail;
  }

  setFavorite(isFavorite: boolean) {
    this.isFavor = isFavorite;
  }

  getHashCode(): string {
    return `${this.uri}_${this.size}_${this.orientation}_${this.isFavor}`
  }

  getTitle(): string {
    if (!this.data) {
      return undefined;
    }
    if (!this.title) {
      this.title = String(this.data.get(userFileManager.ImageVideoKey.TITLE.toString()));
    }
    return this.title;
  }

  setTitle(title: string) {
    this.title = title;
  }

  getDataTaken(): number {
    if (!this.data) {
      return undefined;
    }
    if (!this.dateTaken) {
      this.dateTaken = Number(this.data.get(userFileManager.ImageVideoKey.DATE_ADDED.toString())) *
      DateUtil.MILLISECONDS_PER_SECOND; // Waiting: dateTaken is not supported, use dateAdded
    }
    return this.dateTaken;
  }

  setDataTaken(dateTaken: number) {
    this.dateTaken = dateTaken;
  }

  getDateModified(): number {
    if (!this.data) {
      return undefined;
    }
    if (!this.dateModified) {
      this.dateModified = Number(this.data.get(userFileManager.ImageVideoKey.DATE_MODIFIED.toString())) *
      DateUtil.MILLISECONDS_PER_SECOND;
    }
    return this.dateModified;
  }

  getPosition(): userFileManager.PositionType {
    if (!this.data) {
      return undefined;
    }
    if (!this.position) {
      this.position = this.data.get(userFileManager.ImageVideoKey.POSITION.toString()) as userFileManager.PositionType;
    }
    return this.position;
  }
}