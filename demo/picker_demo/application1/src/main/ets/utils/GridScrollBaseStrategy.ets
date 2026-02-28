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

import lazy { Constants } from '../model/common/Constants';
import type { FetchOptions, PhotoAlbum, PhotoAsset } from '../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import type { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import type photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { QueryParam } from '../interface/BrowserDataInterface';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy { GridPageInfo } from './GridScrollBaseHelper';
import lazy { GridScreenInfo } from './GridScreenInfo';
import lazy { UiUtil } from './UiUtil';

/* instrument ignore file */
/**
 * 宫格滑动策略基类
 */
export class GridScrollBaseStrategy {
  /**
   * 获取宫格屏幕信息
   *
   * @returns 宫格屏幕信息
   */
  public getGridScreenInfo(): GridScreenInfo {
    return new GridScreenInfo();
  }

  /**
   * 获取宫格页对应的宫格数据查询参数
   *
   * @param dataSource 数据源
   * @param start 查询起始
   * @param count 查询个数
   * @returns 宫格页面对应的宫格数据查询参数
   */
  public getGirdDataQueryParam(dataSource: MediaDataSource | undefined,
    start: number, count: number, gridPageInfo?: GridPageInfo): QueryParam | undefined {
    return undefined;
  }

  /**
   * 获取宫格页对应的宫格数据查询选项
   *
   * @param dataSource 数据源
   * @param queryParam 查询参数
   * @returns 宫格页面对应的宫格数据查询选项
   */
  public getGirdDataFetchOptions(dataSource: MediaDataSource | undefined,
    queryParam: QueryParam): FetchOptions | undefined {
    return undefined;
  }

  /**
   * 同步获取媒体库资源
   *
   * @param fetchOpt Fetch选项
   * @returns 媒体库资源
   */
  public getAssetsSync(fetchOpt: FetchOptions): PhotoAsset[] {
    if (fetchOpt === undefined || fetchOpt === null) {
      return [];
    }

    let userFileManager: photoAccessHelper.PhotoAccessHelper = UserFileManagerAccess.getInstance().getMediaLibrary();
    return userFileManager?.getAssetsSync(fetchOpt) ?? [];
  }

  /**
   * 获取相册
   *
   * @param albumUri 相册uri
   * @returns 相册
   */
  public async getAlbum(albumUri: string): Promise<PhotoAlbum | undefined> {
    if (StringUtil.isEmpty(albumUri)) {
      return undefined;
    }

    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    return album;
  }

  /**
   * 同步获取相册的媒体库资源
   *
   * @param album 待获取的相册
   * @param fetchOpt Fetch选项
   * @returns 相册的媒体库资源
   */
  public getAlbumAssetsSync(album: PhotoAlbum | undefined, fetchOpt: FetchOptions): PhotoAsset[] {
    if (fetchOpt === undefined || fetchOpt === null) {
      return [];
    }

    return album?.getAssetsSync(fetchOpt) ?? [];
  }
}

/**
 * 日视图规则布局宫格滑动策略类
 */
export class DayRegularGridScrollStrategy extends GridScrollBaseStrategy {
  public getGridScreenInfo(): GridScreenInfo {
    return UiUtil.getGridScreenInfo();
  }

  public getGirdDataQueryParam(dataSource: MediaDataSource | undefined,
    start: number, count: number, gridPageInfo?: GridPageInfo): QueryParam | undefined {
    if (!dataSource) {
      return undefined;
    }
    let param: QueryParam = dataSource?.getQueryParam(start, count);
    if (gridPageInfo?.gridScene === Constants.PHOTO_TRANSITION_TIMELINE) {
      param.needThumbnailReady = true;
    }
    return param;
  }

  public getGirdDataFetchOptions(dataSource: MediaDataSource | undefined,
    queryParam: QueryParam): FetchOptions | undefined {
    if (!queryParam || queryParam.start < 0 || queryParam.count <= 0) {
      return undefined;
    }
    return dataSource?.photoDataImpl?.getFetchOpt(queryParam);
  }
}