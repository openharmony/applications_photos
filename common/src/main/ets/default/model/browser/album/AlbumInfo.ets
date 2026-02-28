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

import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import type { MediaItem } from '../photo/MediaItem';
import lazy { Constants } from '../../common/Constants';
import type { Region } from '../../common/DataTypes';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { Log } from '../../../utils/Log';
import lazy { GridViewMode } from '../../../view/grid/GridView';
import lazy { AlbumGridSortRule } from '../../AlbumGridSortHelper';
import lazy { AlbumAssetInfo } from './AlbumAssetInfo';

type AlbumSet = PhotoAlbum;

const TAG: string = 'AlbumInfo';

@Observed
export class AlbumInfo {
  public uri: string = '';
  public coverPhotoUri: string = '';
  public coverUri: string = '';
  public coverOrientation: number = Number.NaN;
  public albumName: Resource | string = '';
  public count: number = Number.NaN;
  public isTimeline: boolean = false;
  public isSystemAlbum: boolean = false;
  public isTrashAlbum: boolean = false;
  public isFavorAlbum: boolean = false;
  public isVideoAlbum: boolean = false;
  public isScreenShotAlbum: boolean = false;
  public isPhotoAlbum: boolean = false;
  public isSourceAlbum: boolean = false;
  public isUserCreatedAlbum: boolean = false;
  public isDuplicateAlbum: boolean = false;
  public filterMediaType: string = '';
  public queryParam: QueryParam | undefined = undefined;
  public dateModified?: number;
  public videoCount: number = Number.NaN;
  public mediaItem: MediaItem | undefined;
  public isShootingAlbum: boolean = false;
  public isGroupAlbum: boolean = false;
  public coverUris: string [] = [];
  public subAlbums: AlbumInfo [] = [];
  public fourSubAlbums: AlbumInfo [] = [];
  public albumId: string = '';
  public albumCount: number = Number.NaN;
  public albumType: number = Number.NaN;
  public coverUriSource: string | undefined | number = '';
  public subType: number = Number.NaN;
  public region: Region | undefined = undefined;
  public coverImgSize: Size | undefined = undefined;
  public regionMap: Region[] = [];
  public coverSizeMap: Size[] = [];
  public tagId?: string = '';
  public unionAlbumUris: string[] = [];
  public lpath: string | undefined;
  public photoAlbum: AlbumSet | undefined = undefined;
  public viewMode: GridViewMode = GridViewMode.GRID;
  // 宫格排序规则
  public sortRule: AlbumGridSortRule = AlbumGridSortRule.SHOOT_TIME;
  /**
   * 相册本地资产大小，不包含纯云端资产
   */
  public albumLocalAssetSize: number = 0;
  /**
   * 相册本地资产数量，不包含纯云端资产
   */
  public albumLocalAssetCount: number = 0;
  /**
   * 人像、合影相册是否为收藏相册
   */
  public isFavoritesAlbum: boolean = false;

  constructor(album?: AlbumSet, queryParam?: QueryParam) {
    if (album) {
      this.uri = album.albumUri;
      this.coverUri = album.coverUri;
      this.count = album.count;
      this.videoCount = album.videoCount ?? 0;
      this.queryParam = queryParam;
      this.photoAlbum = album;
      this.inByPhotoHelperAlbum(album);
      this.coverUriSource = album.coverUriSource;
    }
  }

  public setAlbumLocalAssetSize(albumLocalAssetSize: number): void {
    this.albumLocalAssetSize = albumLocalAssetSize;
  }

  public setAlbumLocalAssetCount(albumLocalAssetCount: number): void {
    this.albumLocalAssetCount = albumLocalAssetCount;
  }

  // 通过photoHelper类去获取的相册信息
  public inByPhotoHelperAlbum(album: PhotoAlbum): void {
    this.isSystemAlbum = PhotoAccessHelperAccess.isSystemAlbum(album);
    this.isTrashAlbum = PhotoAccessHelperAccess.isTrashAlbum(album);
    this.isFavorAlbum = PhotoAccessHelperAccess.isFavorAlbum(album);
    this.isVideoAlbum = PhotoAccessHelperAccess.isVideoAlbum(album);
    this.isScreenShotAlbum = PhotoAccessHelperAccess.isScreenShotAlbum(album);
    this.isPhotoAlbum = PhotoAccessHelperAccess.isPhotoAlbum(album);
    this.albumName = PhotoAccessHelperAccess.getAlbumNameResource(album);
    this.isSourceAlbum = PhotoAccessHelperAccess.isSourceAlbum(album);
    this.isUserCreatedAlbum = PhotoAccessHelperAccess.isUserGenericAlbum(album) &&
    PhotoAccessHelperAccess.isUserAlbum(album);
    this.albumType = album.albumType;
    this.subType = album.albumSubtype;
    this.lpath = album.lpath;
    this.coverUriSource = album.coverUriSource;
  }

  /**
   * 系统相册类型细分。调用此方法前，应保证subType已有效赋值
   */
  public setSystemAlbumSubType(): void {
    if (!this.isSystemAlbum) {
      return;
    }
    if (this.subType === UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE) {
      this.isPhotoAlbum = true;
    } else if (this.subType === UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE) {
      this.isVideoAlbum = true;
    } else if (this.subType === UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE) {
      this.isFavorAlbum = true;
    } else if (this.subType === UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE) {
      this.isTrashAlbum = true;
    } else {
      Log.warn(TAG, `isSystemAlbum, but invalid subtype : ${this.subType}`);
    }
  }

  public setAlbumCount(albumCount: number): void {
    this.albumCount = albumCount;
  }

  public setSubAlbums(subAlbums: AlbumInfo []): void {
    this.subAlbums = subAlbums;
  }

  public setCoverUris(uris: string[]): void {
    this.coverUris = uris;
  }

  public setFourSubAlbums(fourSubAlbums: AlbumInfo []): void {
    this.fourSubAlbums = fourSubAlbums;
  }

  public setCoverImgSize(size: Size): void {
    this.coverImgSize = size;
  }

  public setRegion(region: Region): void {
    this.region = region;
  }

  public setCoverSizeMap(coverSizeMap: Size[]): void {
    this.coverSizeMap = coverSizeMap;
  }

  public setTagId(tagId: string): void {
    this.tagId = tagId;
  }

  public setRegionMap(regionMap: Region[]): void {
    this.regionMap = regionMap;
  }

  public setCoverOrientation(orientation: number): void {
    this.coverOrientation = orientation;
  }

  public setMediaItem(mediaItem: MediaItem): void {
    this.mediaItem = mediaItem;
  }

  public setAlbumName(albumName: Resource | string): void {
    this.albumName = albumName;
  }

  public setUri(uri: string): void {
    this.uri = uri;
  }

  public setCount(count: number): void {
    this.count = count;
  }

  public setVideoCount(count: number): void {
    this.videoCount = count;
  }

  public setFilterMediaType(filterMediaType: string): void {
    this.filterMediaType = filterMediaType;
  }

  public setSubtype(subType: number): void {
    this.subType = subType;
  }

  public setFilterParam(queryParam: QueryParam): void {
    this.queryParam = queryParam;
  }

  public setCoverUri(coverUri: string): void {
    this.coverUri = coverUri;
  }

  public setCoverPhotoUri(coverPhotoUri: string): void {
    this.coverPhotoUri = coverPhotoUri;
  }

  public async getAlbumAssetInfo(fromAlbum?: string, fromEntry?: string): Promise<AlbumAssetInfo> {
    return this.photoAlbum ? await PhotoAccessHelperAccess.getAlbumAssetInfo(this.photoAlbum, fromAlbum, fromEntry) :
      new AlbumAssetInfo();
  }

  public setFavoritesAlbum(isFavor: boolean): void {
    this.isFavoritesAlbum = isFavor;
  }

  public getHashCode(): string {
    return `${this.uri}_${this.coverUri}_${this.count}_${AlbumDefine.getAlbumNameString(this.albumName)}`;
  }

  public static getAlbumInfoHashCode(item: AlbumInfo): string {
    return `${item.uri}_${item.coverUri}_${item.count}_${item.albumName}`;
  }

  public isTrashOrHiddenAlbum(): boolean {
    return this.isTrashAlbum;
  }

  public setUnionAlbumUris(unionAlbumUris: string[]): void {
    this.unionAlbumUris = unionAlbumUris;
  }

  public toString(): string {
    return JSON.stringify(this, AlbumDefine.albumNameReplacer);
  }

  private albumClassified(printInfo: string[]): void {
    if (this.isSystemAlbum) {
      printInfo.push(`isSystemAlbum:${this.isSystemAlbum}`);
    }
    if (this.isTrashAlbum) {
      printInfo.push(`isTrashAlbum:${this.isTrashAlbum}`);
    }
    if (this.isFavorAlbum) {
      printInfo.push(`isFavorAlbum:${this.isFavorAlbum}`);
    }
    if (this.isVideoAlbum) {
      printInfo.push(`isVideoAlbum:${this.isVideoAlbum}`);
    }
    if (this.isSourceAlbum) {
      printInfo.push(`isSourceAlbum:${this.isSourceAlbum}`);
    }
    if (this.isDuplicateAlbum) {
      printInfo.push(`isDuplicateAlbum:${this.isDuplicateAlbum}`);
    }
    if (this.isUserCreatedAlbum) {
      printInfo.push(`isUserCreatedAlbum:${this.isUserCreatedAlbum}`);
    }
    if (this.isScreenShotAlbum) {
      printInfo.push(`isScreenShotAlbum:${this.isScreenShotAlbum}`);
    }
    if (this.isPhotoAlbum) {
      printInfo.push(`isPhotoAlbum:${this.isPhotoAlbum}`);
    }
  }

  public printAlbumInfo(): string {
    let printInfo: string[] = [];
    printInfo.push(`uri:${this.uri}`);
    printInfo.push(`coverUri:${this.coverUri}`);
    printInfo.push(`coverPhotoUri:${this.coverPhotoUri}`);
    printInfo.push(`count:${this.count}`);
    printInfo.push(`albumName:${AlbumDefine.getAnonymizeAlbumName(this.albumName)}`);
    printInfo.push(`videoCount:${this.videoCount}`);
    printInfo.push(`sortRule:${this.sortRule}`);
    printInfo.push(`region:${this.region}`);
    this.albumClassified(printInfo);
    return JSON.stringify(printInfo);
  }
}
