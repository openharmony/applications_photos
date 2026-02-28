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

import lazy { TimelineDataImplAsync } from '../model/browser/photo/TimelineDataImplAsync';
import lazy { PhotoDataImpl } from '../model/browser/photo/PhotoDataImpl';
import lazy { AlbumDataImpl } from '../model/browser/album/AlbumDataImpl';
import type { BrowserDataInterface } from './BrowserDataInterface';
import lazy { AlbumThirdSelectDataImpl } from '../model/browser/album/AlbumThirdSelectDataImpl';
import lazy { AlbumDataImplAsync } from '../model/browser/album/AlbumDataImplAsync';
import lazy { PhotoDataImplAsync } from '../model/browser/photo/PhotoDataImplAsync';
import lazy { NormalAlbumDataImpl } from '../model/browser/album/NormalAlbumDataImpl';
import lazy { MovePageAlbumDataImplAsync } from '../model/browser/album/MovePageAlbumDataImplAsync';

export class BrowserDataFactory {
  public static readonly TYPE_PHOTO = 'photo';
  public static readonly TYPE_ALBUM = 'album';
  public static readonly TYPE_GROUP = 'group';
  public static readonly TYPE_DISTRIBUTED = 'distributed';
  public static readonly TYPE_THIRD_SELECT_ALBUM = 'third_select_album';
  public static readonly TYPE_ALBUM_ASYNC = 'album_async';
  public static readonly TYPE_PHOTO_ASYNC = 'photo_async';
  public static readonly TYPE_HIDDEN_PHOTO = 'hidden_photo';
  // 普通相册区域
  public static readonly TYPE_NORMAL_ALBUM = 'normal_album';
  // 相册排序页面（普通相册 + 更多相册）
  public static readonly TYPE_ALBUM_SORT = 'album_sort';
  // 移动到页面相册
  public static readonly TYPE_MOVE_PAGE_ALBUM_ASYNC = 'move_page_album_async';

  public static getFeature(type: string): BrowserDataInterface {
    if (type === BrowserDataFactory.TYPE_ALBUM) {
      return new AlbumDataImpl();
    } else if (type === BrowserDataFactory.TYPE_PHOTO) {
      return new PhotoDataImpl() as BrowserDataInterface;
    } else if (type === BrowserDataFactory.TYPE_GROUP) {
      return new TimelineDataImplAsync();
    } else if (type === BrowserDataFactory.TYPE_THIRD_SELECT_ALBUM) {
      return new AlbumThirdSelectDataImpl();
    } else if (type === BrowserDataFactory.TYPE_ALBUM_ASYNC) {
      return new AlbumDataImplAsync();
    } else if (type === BrowserDataFactory.TYPE_PHOTO_ASYNC) {
      return new PhotoDataImplAsync(`_async`) as BrowserDataInterface;
    } else if (type === BrowserDataFactory.TYPE_NORMAL_ALBUM) {
      return new NormalAlbumDataImpl();
    } else if (type === BrowserDataFactory.TYPE_MOVE_PAGE_ALBUM_ASYNC) {
      return new MovePageAlbumDataImplAsync();
    }
    throw Error(`${type} is an invalid type.`);
  }
}