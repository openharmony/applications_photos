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

import type { FetchOptions } from '../access/UserFileManagerAccess';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { AsyncCallback, TBrowser } from '../model/common/AsyncCallback';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { YearMonthQueryParam } from '../model/browser/photo/YearMonthQueryParam';
import lazy { FilterConditions } from '../model/FilterConditions';

export enum FetchType {
  NORMAL,
  EMPTY,
  DATE_INFO,
}

export interface QueryParam extends QueryCountParam {
  start?: number,
  count?: number,
  fetchType?: FetchType,
  startTime?: number,
  id?: string,
  fileIds?: number[],
  orderBy?: string,
}

// albumUris will be used in union album
export interface QueryCountParam {
  albumUri?: string,
  albumUris?: string[],
  albumKey?: string,
  filterMediaType?: string,
  needThumbnailReady?: boolean,
  filterConditions?: FilterConditions,
  uris?: string[],
}

export interface QueryAlbumParam {
  filterMediaType?: string,
  uris?: string[],
  start?: number,
  count?: number,
  hasItemsOnly?: boolean,
  blackUriList?: string[],
  nameOnly?: boolean,
  orderSection?: number[],
  orderStyle?: number,
}

export interface YearMonthDataInterface {
  /**
   * 查询年月元数据
   *
   * @param callback 回调函数
   * @param param 查询参数
   */
  getMediaData(callback: AsyncCallback, param: YearMonthQueryParam): void;
}

export interface BrowserDataInterface {
  getData(callback: AsyncCallback | Function, param: QueryParam | QueryAlbumParam | undefined): void;

  getDataCount(callback: AsyncCallback |
  Function, param: QueryParam | QueryAlbumParam | AlbumInfo | QueryCountParam):
    void;

  getDataByBurstKey?: (burstKey: string, start: number, count: number, isDesc: boolean, isTrash?: boolean) =>
  Promise<MediaItem[]>;

  getDataByUri(uri: string, deviceId?: string): Promise<TBrowser.MayVoid>;

  getDataByName(name: string, albumUri: string): Promise<TBrowser.MayVoid>;

  getDataIndexByUri(callback: AsyncCallback | Function, param: QueryParam | QueryAlbumParam, uri: string): void;

  getMediaItemByUri(callback: AsyncCallback | Function, uri: string): void;

  getIsNewApiQuery(): boolean;

  getUnFavorCount(albumUri?: string, unionAlbumUris?: string[]): Promise<number>;

  checkMediaItemsInDataSource(selectedUris: string[], albumUris: string[]): Promise<string[]>

  /**
   * 获取Fetch选项
   *
   * @param query 查询参数
   * @returns Fetch选项
   */
  getFetchOpt(query: QueryParam): FetchOptions;

  getSinglePhotoAsset?(photoUri: string, albumUri?: string,
    fetchColumns?: string[]): Promise<photoAccessHelper.PhotoAsset | undefined>;

  getThumbnailSafe(sourceUri: string, path: string, modifiedDate: number, size?: Size): string;
}