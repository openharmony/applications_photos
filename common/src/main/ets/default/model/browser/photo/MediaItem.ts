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

const TAG: string = 'common_MediaItem';

export class MediaItem {
  index?: number;
  mediaType: number;
  uri: string;
  thumbnail: string;
  duration: number;
  title: string;
  size: number;
  dateTaken: number;
  dateModified: number;
  orientation: number;
  width: number;
  height: number;
  imgWidth: number;
  imgHeight: number;
  isFavor: boolean;
  displayName: string;
  dateTrashed: number;
  position: userFileManager.PositionType;
  hashCode: string;

  constructor(data: userFileManager.FileAsset) {
    if (!data) {
      return;
    }

    this.mediaType = data.fileType;
    this.uri = data.uri;
    this.displayName = data.displayName;
    this.duration = Number(data.get(userFileManager.ImageVideoKey.DURATION.toString()));
    this.title = String(data.get(userFileManager.ImageVideoKey.TITLE.toString()));
    this.size = Number(data.get("size"));
    this.dateTaken = Number(data.get(userFileManager.ImageVideoKey.DATE_ADDED.toString())) * DateUtil.MILLISECONDS_PER_SECOND; // TODO dateTaken is not supported, use dateAdded
    this.dateModified = Number(data.get(userFileManager.ImageVideoKey.DATE_MODIFIED.toString())) * DateUtil.MILLISECONDS_PER_SECOND;
    this.orientation = Number(data.get(userFileManager.ImageVideoKey.ORIENTATION.toString()));
    if (this.orientation == Constants.ANGLE_90 || this.orientation == Constants.ANGLE_270) {
      this.width = Number(data.get(userFileManager.ImageVideoKey.HEIGHT.toString()));
      this.height = Number(data.get(userFileManager.ImageVideoKey.WIDTH.toString()));
    } else {
      this.width = Number(data.get(userFileManager.ImageVideoKey.WIDTH.toString()));
      this.height = Number(data.get(userFileManager.ImageVideoKey.HEIGHT.toString()));
    }
    this.imgWidth = this.width;
    this.imgHeight = this.height;
    this.dateTrashed = Number(data.get(userFileManager.ImageVideoKey.DATE_TRASHED.toString()));
    this.isFavor = Boolean(data.get(userFileManager.ImageVideoKey.FAVORITE.toString()));
    this.position = data.get(userFileManager.ImageVideoKey.POSITION.toString()) as userFileManager.PositionType;
    this.hashCode = `${this.uri}_${this.size}_${this.orientation}_${this.isFavor}`
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
}