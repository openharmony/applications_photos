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
import { userFileManager } from '@kit.CoreFileKit';
import lazy { Log } from '../utils/Log';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';

const TAG: string = 'MoviePageConstants';

export class MoviePageConstants {
  public static readonly DEFAULT_MIN_SELECT_COUNT: number = 0;
  public static readonly DEFAULT_MAX_MOVIE_COUNT: number = 30;
  public static readonly DEFAULT_MAX_VIDEO_SPLICING_COUNT: number = 50;
  public static readonly MENU_DIVIDER_START_MARGIN: number = 48;
  //选中的列表
  public static readonly KEY_MOVIE_PAGE_LIST: string = 'com.ohos.photos.movie_page_list';
  //特性类型
  public static readonly KEY_FEATURE_TYPE: string = 'com.ohos.photos.movie_page_feature_type';
  //albumUri
  public static readonly KEY_ALBUM_URI: string = 'com.ohos.photos.movie_page_album_uri';
  //broadCast
  public static readonly KEY_BROAD_CAST: string = 'com.ohos.photos.movie_page_broadCast';
  //subtype
  public static readonly KEY_AlBUM_SUBTYPE: string = 'com.ohos.photos.movie_page_subtype';
  public static readonly KEY_SEARCH_RESULT_PAGE: string = 'com.ohos.photos.search_result_page';
  public static readonly KEY_LAST_DOWNLOAD_LIST: string = 'com.ohos.photos.last_download_list';

  public static jumpMovieFilter(assets: MediaItem[]): MediaItem[] {
    let filterAssets: MediaItem[] = [];
    for (let i = 0; i < assets.length; i++) {
      let info: MediaItem = assets[i];
      if (info.mediaType === undefined) {
        Log.error(TAG, `Mediatype is illegal, mediaType: ${info.mediaType}`);
        continue;
      }
      let maxSize = Number.MAX_SAFE_INTEGER;
      // 长宽无效或者超过最大值则拦截
      if (info.width > maxSize || info.height > maxSize) {
        Log.error(TAG, `Select video size illegal, width is ${info.width}, height is ${info.height}`);
        continue;
      }
      if (info.mediaType === userFileManager.FileType.VIDEO && !MoviePageConstants.isVideoTypeSupported(info.uri)) {
        Log.error(TAG, `VideoType is not supported.`);
        continue;
      }
      filterAssets.push(info);
    }
    return filterAssets;
  }

  public static isVideoTypeSupported(uri: string): boolean {
    if (!uri) {
      Log.error(TAG, `Select file uri is null.`);
      return false;
    }
    let index = uri.lastIndexOf('.');
    if (index === -1) {
      Log.error(TAG, `Select file uri has no suffix`);
      return false;
    }
    return true;
  }
}