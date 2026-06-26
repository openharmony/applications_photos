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
import lazy { StringUtil } from './StringUtil';
import lazy { GridPageInfo } from './GridScrollBaseHelper';
import lazy { GridScreenInfo } from './GridScreenInfo';
import lazy { UiUtil } from './UiUtil';
import lazy { UnionAlbumMediaDataSource } from '../model/browser/photo/UnionAlbumMediaDataSource';
import lazy { AlbumGridSortHelper } from '../model/AlbumGridSortHelper';

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
  public async getAssetsSync(fetchOpt: FetchOptions): Promise<PhotoAsset[]> {
    if (fetchOpt === undefined || fetchOpt === null) {
      return [];
    }

    let userFileManager: photoAccessHelper.PhotoAccessHelper = UserFileManagerAccess.getInstance().getMediaLibrary();
    let result = await userFileManager?.getAssets(fetchOpt);
    return result.getAllObjects() ?? [];
  }

  /**
   * 获取相册
   *
   * @param albumUri 相册uri
   * @returns 相册
   */
  public async getAlbum(albumUri: string): Promise<PhotoAlbum | undefined> {
    if (!albumUri) {
      return undefined;
    }

    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    return album;
  }

  /**
   * 获取隐藏相册
   *
   * @param albumUri 隐藏相册uri
   * @param isHiddenSubAlbumQuery 是否按相册显示隐藏文件
   * @returns 相册
   */
  public async getHiddenAlbum(albumUri: string, isHiddenSubAlbumQuery?: boolean): Promise<PhotoAlbum | undefined> {
    if (!albumUri) {
      return undefined;
    }
    let album: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getHiddenAlbumByUri(albumUri, isHiddenSubAlbumQuery);
    return album;
  }

  /**
   * 同步获取相册的媒体库资源
   *
   * @param album 待获取的相册
   * @param fetchOpt Fetch选项
   * @returns 相册的媒体库资源
   */
  public async  getAlbumAssetsSync(album: PhotoAlbum | undefined, fetchOpt: FetchOptions): Promise<photoAccessHelper.PhotoAsset[]> {
    if (fetchOpt === undefined || fetchOpt === null) {
      return [];
    }
    let result = await album?.getAssets(fetchOpt)
    return result?.getAllObjects() ?? [];
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

  public getGirdDataFetchOptions(dataSource: MediaDataSource |
  undefined, queryParam: QueryParam): FetchOptions | undefined {
    if ((queryParam?.start || queryParam?.start === 0) && queryParam?.count) {
      if (dataSource instanceof UnionAlbumMediaDataSource && dataSource.isUnionAlbum) {
        queryParam.albumKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(dataSource.albumInfo);
        return dataSource.unionPhotoDataImpl.getFetchOpt(queryParam);
      }
      queryParam.albumKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(dataSource?.albumInfo);
      return dataSource?.photoDataImpl?.getFetchOpt(queryParam);
    }
    return undefined;
  }
}

/**
 * 日视图不规则布局宫格滑动策略类
 */
export class DayIrregularGridScrollStrategy extends GridScrollBaseStrategy {
  public getGridScreenInfo(): GridScreenInfo {
    return UiUtil.getGridScreenInfo();
  }

  public getGirdDataQueryParam(dataSource: MediaDataSource | undefined,
    start: number, count: number, gridPageInfo?: GridPageInfo): QueryParam | undefined {
    if (!dataSource) {
      return undefined;
    }
    let param: QueryParam = dataSource?.getQueryParam(start, count);
    if (gridPageInfo?.gridScene === Constants.PHOTO_TRANSITION_TIMELINE_GROUP ||
      gridPageInfo?.gridScene === Constants.PHOTO_TRANSITION_TIMELINE) {
      param.needThumbnailReady = true;
    }
    return param;
  }

  public getGirdDataFetchOptions(dataSource: MediaDataSource |
  undefined, queryParam: QueryParam): FetchOptions | undefined {
    if ((queryParam?.start || queryParam?.start === 0) && queryParam?.count) {
      return dataSource?.photoDataImpl?.getFetchOpt(queryParam);
    }
    return undefined;
  }
}