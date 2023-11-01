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
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import type { FetchOptions } from '../../access/UserFileManagerAccess';
import {
  AlbumFetchOptionBuilder,
  FileFetchOptionBuilder,
  UserFileManagerAccess
} from '../../access/UserFileManagerAccess';
import { Log } from '../../utils/Log';

const TAG: string = 'AlbumDefine';

export class AlbumDefine {
  static readonly ALBUM_ID_ALL: string = 'default_all';
  static readonly ALBUM_ID_CAMERA: string = 'default_camera';
  static readonly ALBUM_ID_VIDEO: string = 'default_video';
  static readonly ALBUM_ID_RECYCLE: string = 'default_recycle';
  static readonly ALBUM_ID_FAVOR: string = 'default_favor';
  static readonly ALBUM_ID_SNAPSHOT: string = 'default_snapshot';
  static readonly ALBUM_ID_REMOTE: string = 'default_remote';

  // 需要过滤的媒体文件类型
  static readonly FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';
  static readonly FILTER_MEDIA_TYPE_IMAGE: string = 'FILTER_MEDIA_TYPE_IMAGE';
  static readonly FILTER_MEDIA_TYPE_VIDEO: string = 'FILTER_MEDIA_TYPE_VIDEO';

  static getFileFetchOpt(startIndex?: number, count?: number, filterMediaType?: string): FetchOptions {
    let builder = new FileFetchOptionBuilder();
    builder
      .order(UserFileManagerAccess.FILE_KEY_DATE_TAKEN.toString(), false)
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType)
    }
    if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  static getFileFetchOptWithEmptyColumn(startIndex?: number, count?: number, filterMediaType?: string): FetchOptions {
    let fetchOption: userFileManager.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: []
    };
    let builder = new FileFetchOptionBuilder(fetchOption);
    builder.order(UserFileManagerAccess.FILE_KEY_DATE_TAKEN.toString(), false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  static getFavoriteFetchOpt(filterMediaType?: string) {
    let builder = new FileFetchOptionBuilder();
    if (filterMediaType == undefined) {
      filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
    }
    AlbumDefine.setFilterMediaType(builder, filterMediaType)
      .order(UserFileManagerAccess.FILE_KEY_DATE_TAKEN.toString(), false);

    return builder.build();
  }

  static getTimelineGroupFetchOpt() {
    let builder = new FileFetchOptionBuilder();
    builder.groupBy();
    return builder.build();
  }

  static getFileFetchOptByUri(uri: string) {
    let builder = new FileFetchOptionBuilder().uri(uri);
    return builder.build();
  }

  static getFileFetchOptByName(displayName: string) {
    let builder = new FileFetchOptionBuilder().displayName(displayName);
    return builder.build();
  }

  static getAlbumFetchOptByName(name: string) {
    let builder = new AlbumFetchOptionBuilder()
    builder.albumName(name);
    return builder.build();
  }

  static getAlbumFetchOptByUri(albumUri: string) {
    let builder = new AlbumFetchOptionBuilder();
    if (albumUri) {
      builder.albumUri(albumUri);
    }
    return builder.build();
  }

  static setFilterMediaType(builder: FileFetchOptionBuilder, filterMediaType: string): FileFetchOptionBuilder {
    if (filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      builder.media(UserFileManagerAccess.MEDIA_TYPE_IMAGE.toString())
    } else if (filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
      builder.media(UserFileManagerAccess.MEDIA_TYPE_VIDEO.toString())
    }
    return builder;
  }
}