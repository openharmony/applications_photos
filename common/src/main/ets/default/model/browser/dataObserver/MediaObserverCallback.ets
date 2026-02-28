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

/* instrument ignore file */

import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { LightWeightMap } from '@kit.ArkTS';
import type { AlbumChangeData } from '../../../access/UserFileManagerAccess';

export enum MediaObserverNfyType {
  NONE,
  PHOTO_ADD = 1,
  PHOTO_REMOVE,
  PHOTO_UPDATE,
  PHOTO_ADD_ASTC,
  PHOTO_UPDATE_ASTC,
  ALBUM_ADD = 11,
  ALBUM_REMOVE,
  ALBUM_UPDATE,
  ADD_PHOTO_INTO_ALBUM = 21,
  REMOVE_PHOTO_FROM_ALBUM,
  DISMISS_PHOTO_FROM_ALBUM,
}

/**
 * 媒体变化类型
 */
export enum MediaChangeType {
  /**
   * 图片变化
   */
  IMAGE = 'image',

  /**
   * 相册变化
   */
  ALBUM = 'album'
}

export class MediaObserverNfyInfo {
  public type: number;
  public uris: string[];
  public albumUris: string[];
  public sharedPhotoAssets: Array<photoAccessHelper.SharedPhotoAsset>;
  public sharedAlbumAssets: Array<photoAccessHelper.SharedAlbumAsset>;
  public sharedExtraPhotoAssets: Array<photoAccessHelper.SharedPhotoAsset>;

  constructor() {
    this.type = MediaObserverNfyType.NONE;
    this.uris = [];
    this.albumUris = [];
    this.sharedPhotoAssets = [];
    this.sharedAlbumAssets = [];
    this.sharedExtraPhotoAssets = [];
  }

  public info(): string {
    return `info = { type = ${this.type}, uris = ${this.uris}, albumUris = ${this.albumUris} }`;
  }
}

export class MediaObserverNfyInfoForAlbums {
  public type: number;
  public albumChangeDatas: AlbumChangeData[] | null;
  public isForRecheck: boolean;


  constructor() {
    this.type = MediaObserverNfyType.NONE;
    this.albumChangeDatas = [];
    this.isForRecheck = false;
  }
}

export interface MediaChangeDataSource {
  // 是否触发全量查询标识位
  needRefreshCount: boolean;

  // 更新needRefreshCount变量 是否需要全量查询
  updateNotifyCountStatus(nfyInfo: MediaObserverNfyInfo): void;
}

export class MediaDataProvider {
  // 单实例内容
  private static instance: MediaDataProvider = new MediaDataProvider();
  // 缩略图总数量
  public totalReadyCount: number = 0;
  // 图片、视频总数量
  public totalImageCount: number = 0;
  public totalVideoCount: number = 0;
  // 图片、视频缩略图总数量
  public totalReadyImageCount: number = 0;
  public totalReadyVideoCount: number = 0;
  //本地+云 图片，视频总数量
  public totalBothImageCount: number = 0;
  public totalBothVideoCount: number = 0;
  //白块数量
  public totalWhiteBlocksImageCount: number = 0;
  public totalWhiteBlocksVideoCount: number = 0;

  // 获取单实例
  public static getInstance(): MediaDataProvider {
    return MediaDataProvider.instance;
  }

  // 判断是否需要进行全量查询
  public static isInfoValidForCountUpdate(nfyInfo: MediaObserverNfyInfo): boolean {
    if ((nfyInfo.sharedPhotoAssets && nfyInfo.sharedPhotoAssets.length > 0) ||
      (nfyInfo.sharedAlbumAssets && nfyInfo.sharedAlbumAssets.length > 0)) {
      switch (nfyInfo.type) {
        case MediaObserverNfyType.PHOTO_ADD_ASTC:
        case MediaObserverNfyType.PHOTO_ADD:
        case MediaObserverNfyType.PHOTO_UPDATE_ASTC:
        case MediaObserverNfyType.PHOTO_REMOVE:
          return false;
        default:
          return true;
      }
    }
    return true;
  }
}

export class MediaDataVaryInfo {
  // 图片、视频变化数量
  public imageVaryCount: number = 0;
  public videoVaryCount: number = 0;
  public readyImageVaryCount: number = 0;
  public readyVideoVaryCount: number = 0;
  public bothImageVaryCount: number = 0;
  public bothVideoVaryCount: number = 0;
  public whiteBlocksImageVaryCount: number = 0;
  public whiteBlocksVideoVaryCount: number = 0;
  public localImageCount: number = 0;
  public localVideoCount: number = 0;
  public monthVaryMap: LightWeightMap<string, number> = new LightWeightMap();
  public yearVaryMap: LightWeightMap<string, number> = new LightWeightMap();
}

export interface MediaObserverCallback {
  onChange: (mediaType: string) => void;
  onNotify: (nfyInfo: MediaObserverNfyInfo) => void;
}

export interface MediaObserverRefinedCallback {
  onRefinedNotify: (ntfInfo: MediaObserverNfyInfoForAlbums) => void;
}