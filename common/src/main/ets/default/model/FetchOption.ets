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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import type { FetchOptions } from './UserFileData';
import lazy { UserFileData } from './UserFileData';
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from '../utils/Log';
const TAG: string = 'FetchOption';

export function toString(obj: Object | undefined): string {
  return JSON.stringify(obj);
}

export class FetchOption {
}

/**
 * 文件fetchOption
 */
export class FileFetchOptionBuilder {
  private fetchOption: photoAccessHelper.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: [],
  };

  constructor(fetchOpt?: photoAccessHelper.FetchOptions) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }

    // Array.prototype.slice.call: 对ALL_IMAGE_VIDEO_FETCH_COLUMNS进行拷贝而非引用
    this.fetchOption.fetchColumns = UserFileData.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
  }

  public build(): FetchOptions {
    return this.fetchOption;
  }

  // 用于timeline分组查询
  public groupBy(): FileFetchOptionBuilder {
    this.fetchOption.fetchColumns.push(UserFileData.GROUP_BY_KEY);
    return this;
  }

  public media(mediaType: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(), mediaType);
    return this;
  }

  public mimeType(mediaType: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(UserFileData.FETCH_COLUMNS_MIME_TYPE.toString(), mediaType);
    return this;
  }

  public subType(subType: string): FileFetchOptionBuilder {
    if (subType === UserFileData.GET_ASSERT_WITHOUT_BURST_PHOTO.toString()) {
      this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
    } else {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), subType);
    }

    return this;
  }

  public position(position: string): FileFetchOptionBuilder {
    if (position === UserFileData.GET_ASSERT_WITHOUT_LOCAL.toString()) {
      this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 1);
    } else if (position === UserFileData.GET_ASSERT_WITHOUT_CLOUD.toString()) {
      this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
    } else {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION.toString(), position);
    }
    return this;
  }

  public uri(uri: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri);
    return this;
  }

  public uriList(uri: string[]): FileFetchOptionBuilder {
    for (let index = 0; index < uri.length; index++) {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri[index]);
      if (index < uri.length - 1) {
        this.fetchOption.predicates.or();
      }
    }
    return this;
  }

  public order(key: string, isAsc = true): FileFetchOptionBuilder {
    if (isAsc) {
      //升序
      this.fetchOption.predicates.orderByAsc(key);
    } else {
      //降序
      this.fetchOption.predicates.orderByDesc(key);
    }
    return this;
  }

  public greaterThan(key: string, value: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.greaterThan(key, value);
    return this;
  }

  public lessThan(key: string, value: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.lessThan(key, value);
    return this;
  }

  public lessThanOrEqualTo(key: string, value: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.lessThanOrEqualTo(key, value);
    return this;
  }

  public equalTo(key: string, value: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(key, value);
    return this;
  }

  public thumbnailReady(name: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(UserFileData.FILE_KEY_THUMBNAIL_VISIBLE,
      UserFileData.THUMBNAIL_VISIBLE_VALUE);
    return this;
  }

  public logicalAnd(): FileFetchOptionBuilder {
    this.fetchOption.predicates.and();
    return this;
  }

  public logicalOr(): FileFetchOptionBuilder {
    this.fetchOption.predicates.or();
    return this;
  }

  public select(start: number, count: number): FileFetchOptionBuilder {
    this.fetchOption.predicates.limit(count, start);
    return this;
  }

  public displayName(name: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(), name);
    return this;
  }

  public path(path: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(Constants.KEY_FILE_DATA, path);
    return this;
  }

  public fetchColumns(columns: string[]): FileFetchOptionBuilder {
    this.fetchOption.fetchColumns = columns;
    return this;
  }

  // 文件位置：LOCAL, CLOUD, BOTH
  public locate(location: photoAccessHelper.PositionType): FileFetchOptionBuilder {
    this.fetchOption.predicates
      .equalTo(photoAccessHelper.PhotoKeys.POSITION.toString(), location)
    return this;
  }

  public locateOr(location1: photoAccessHelper.PositionType,
    location2: photoAccessHelper.PositionType): FileFetchOptionBuilder {
    this.fetchOption.predicates.beginWrap();
    this.fetchOption.predicates
      .equalTo(photoAccessHelper.PhotoKeys.POSITION.toString(), location1)
      .or()
      .equalTo(photoAccessHelper.PhotoKeys.POSITION.toString(), location2)
    this.fetchOption.predicates.endWrap();
    return this;
  }

  public beginWrap(): FileFetchOptionBuilder {
    this.fetchOption.predicates.beginWrap();
    return this;
  }

  public endWrap(): FileFetchOptionBuilder {
    this.fetchOption.predicates.endWrap();
    return this;
  }

  public cameraShotKey(cameraShotKey: string): FileFetchOptionBuilder {
    this.fetchOption.predicates.equalTo('camera_shot_key', cameraShotKey);
    return this;
  }

  public fileIds(fileIds: number[]): FileFetchOptionBuilder {
    if (fileIds) {
      this.fetchOption.predicates.in('file_id', fileIds);
    }
    return this;
  }
}

/**
 * PhotoFetchOption
 */
export class PhotoFetchOptionBuilder {
  private fetchOption: photoAccessHelper.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: [],
  };

  constructor(fetchOpt?: photoAccessHelper.FetchOptions) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }
  }

  public build(): FetchOptions {
    return this.fetchOption;
  }

  public uri(uri: string): PhotoFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri);
    return this;
  }
}

/**
 * 相册fetchOption
 */
export class AlbumFetchOptionBuilder {
  private fetchOption: photoAccessHelper.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: [],
  };

  constructor(fetchOpt?: photoAccessHelper.FetchOptions) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }
  }

  public build(): FetchOptions {
    return this.fetchOption;
  }

  public media(mediaType: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo('file_type', mediaType);
    return this;
  }

  public logicalAnd(): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.and();
    return this;
  }

  public albumName(name: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.AlbumKeys.ALBUM_NAME.toString(), name);
    return this;
  }

  public albumUri(uri: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.AlbumKeys.URI.toString(), uri);
    return this;
  }

  public albumUris(uris: string[]): AlbumFetchOptionBuilder {
    if (!uris || uris.length === 0) {
      Log.error(TAG, 'AlbumFetchOptionBuilder.albumUris: albumUris is undefined or empty!');
      return this;
    }
    for (let index = 0; index < uris.length; index++) {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uris[index]);
      if (index < uris.length - 1) {
        this.fetchOption.predicates.or();
      }
    }
    return this;
  }

  public photoAlbumUri(uri: string): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.AlbumKeys.URI, uri);
    return this;
  }

  // 图库相册顺序倒序排列
  public albumOrderDesc(): AlbumFetchOptionBuilder {
    this.fetchOption.predicates.orderByDesc('date_modified');
    return this;
  }
}

export class FetchOptionBuilder {
  private fetchOption: photoAccessHelper.FetchOptions = {
    predicates: new dataSharePredicates.DataSharePredicates(),
    fetchColumns: [],
  };

  constructor(fetchOpt?: photoAccessHelper.FetchOptions) {
    /* instrument ignore next */
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    }

    // Array.prototype.slice.call: 对ALL_IMAGE_VIDEO_FETCH_COLUMNS进行拷贝而非引用,修改为按需获取非全量获取
    this.fetchOption.fetchColumns = UserFileData.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
  }

  public getFetchOption(): photoAccessHelper.FetchOptions {
    return this.fetchOption;
  }

  public media(mediaType: string): FetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, mediaType);
    return this;
  }

  public select(start: number, count: number): FetchOptionBuilder {
    this.fetchOption.predicates.limit(count, start);
    return this;
  }

  public photoUri(uri: string): FetchOptionBuilder {
    this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
    return this;
  }

  /* instrument ignore next */
  public setColumns(columns: string[]): FetchOptionBuilder {
    this.fetchOption.fetchColumns = columns;
    return this;
  }

  /* instrument ignore next */
  public order(key: string, isAsc = true): FetchOptionBuilder {
    if (isAsc) {
      // 升序
      this.fetchOption.predicates.orderByAsc(key);
    } else {
      // 降序
      this.fetchOption.predicates.orderByDesc(key);
    }
    return this;
  }
}