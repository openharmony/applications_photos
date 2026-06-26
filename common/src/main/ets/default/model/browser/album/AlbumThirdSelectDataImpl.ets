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

import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { AlbumInfo } from './AlbumInfo';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { BrowserDataImpl } from '../BrowserDataImpl';
import lazy { Log } from '../../../utils/Log';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { isVideoAssets, MediaItem } from '../photo/MediaItem';
import type { FetchOptions, PhotoAlbum } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess, toString, AlbumCountAndPhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { Constants } from '../../common/Constants';
import type { AlbumSimpleInfo } from './AlbumDataImpl';
import lazy { CommonUtil } from '../../../utils/CommonUtil';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { SourceTypeAlbumDataImpl } from './SourceTypeAlbumDataImpl';
import lazy { common } from '@kit.AbilityKit';
import lazy { getScreen } from '../../common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_AlbumThirdSelectDataImpl';

interface AlbumInfoEx {
  relativePath?: string;
};

interface QueryAlbumParam {
  filterMediaType?: string;
  uris?: string[]
};

// 定义 AlbumResult 类
class AlbumResult {
  albums: AlbumInfo[];
  index: number;

  public constructor(albums: AlbumInfo[], index: number) {
    this.albums = albums;
    this.index = index;
  }

  public getAlbums(): AlbumInfo[] {
    return this.albums ?? [];
  }

  public getIndex(): number {
    return this.index;
  }
}

export class AlbumThirdSelectDataImpl extends BrowserDataImpl {
  private static readonly ROW_HEIGHT: number = 64;
  private isFirstLoad: boolean = true;
  private context: common.Context | undefined = undefined;
  private isPickerUsedSubwindow: boolean = false;
  private isCancel: boolean = false;

  constructor(context?: common.Context, userId?: number, isPickerUsedSubwindow?: boolean) {
    super();
    this.context = context ?? getContext();
    if (isPickerUsedSubwindow) {
      this.isPickerUsedSubwindow = isPickerUsedSubwindow;
    }
  }

  public getData(callback: AsyncCallback<AlbumInfo[] | AlbumSimpleInfo>, param: QueryParam): void {
    Log.info(TAG, `getData, this.checkQueryParams(param)=${this.checkQueryParams(param)}`);
    if (!param) {
      this.buildAlbums(callback);
    } else if (this.checkQueryParams(param)) {
      this.buildAlbumsWithFilter(callback, param);
    } else if (param?.filterMediaType !== undefined) {
      this.buildAlbums(callback, param.filterMediaType);
    } else {
      Log.warn(TAG, 'getData invalid.');
    }
  }

  private hasEnhancedFilter(param: QueryParam): boolean {
    if (!param?.filterConditions) {
      return false;
    }
    return Boolean(param.filterConditions.mimeType || param.filterConditions.photoViewMimeTypeFilter ||
    param.filterConditions.fileSizeFilter || param.filterConditions.videoDurationFilter ||
    param.filterConditions.photoViewMimeTypeFileSizeFilters || param.filterConditions.combinedMediaTypeFilter);
  }

  private checkQueryParams(param?: QueryParam): boolean {
    if (!param?.filterConditions) {
      return false;
    }
    let hasNormalType: boolean =
      Boolean(param.filterConditions.mediaType || param.filterConditions.subtype || param.filterConditions.position);
    let hasBasicFilterMediaType: boolean =
      (param.filterMediaType && this.isBasicFilterType(param.filterMediaType)) as boolean;
    let isRecommendationTypeInvalid: boolean = (!param.filterConditions.recommendationType ||
      (param.filterConditions.recommendationType && param.filterConditions.recommendationType <= 0)) as boolean;

    if (hasNormalType) {
      return true;
    }
    if (this.hasEnhancedFilter(param)) {
      return true;
    }
    if (!hasBasicFilterMediaType) {
      return true;
    }
    if (!isRecommendationTypeInvalid) {
      return true;
    }
    return false;
  }

  private isBasicFilterType(filterType: string): boolean {
    return (filterType === AlbumDefine.FILTER_MEDIA_TYPE_ALL ||
      filterType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE ||
      filterType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
  }

  public async getDataByUri(uri: string): Promise<PhotoAlbum | undefined> {
    let albums = await UserFileManagerAccess.getInstance().getUserAlbums(AlbumDefine.getAlbumFetchOptByUri(uri));
    if (albums?.length > 0) {
      return albums[0];
    } else {
      return undefined;
    }
  }

  public async getDataByName(name: string, albumUri?: string): Promise<PhotoAlbum | undefined> {
    let albums = await UserFileManagerAccess.getInstance().getUserAlbums(AlbumDefine.getAlbumFetchOptByName(name));
    if (albums?.length > 0) {
      let opt: FetchOptions = AlbumDefine.getFileFetchOpt();
      let fileResult = await albums[0].getAssets(opt);
      if (fileResult === null || fileResult === undefined) {
        Log.warn(TAG, 'not valid fileResult');
        return undefined;
      }
      let count = fileResult.getCount();
      fileResult.close();
      Log.info(TAG, `fetchResult is close.`);
      if (count <= 0) {
        Log.warn(TAG, `thirdSelect not valid album Name: ${AlbumDefine.getAnonymizeAlbumName(albums[0].albumName)}, ` +
          `URI: ${albums[0].albumUri}`);
        return undefined;
      }
      return albums[0];
    } else {
      return undefined;
    }
  }

  public getDataCount(callback: AsyncCallback<AlbumInfo>, albumInfo: AlbumInfo): void {
  }

  private async genAlbumsInfo(cb: AsyncCallback<AlbumSimpleInfo>, ...uris: string[]): Promise<void> {
    Log.info(TAG, 'load data  genAlbumsInfo start uris: ${JSON.stringify(uris)}');

    let res: AlbumSimpleInfo = {
      uris: [],
      count: 0,
      videoCount: 0,
    };

    for (let uri of uris) {
      const param: QueryParam = {
        albumUri: uri,
        start: Constants.INVALID,
        count: Constants.INVALID,
      };
      let objects = await super.getItems(param);
      if (!objects) {
        Log.warn(TAG, `genAlbumsInfo: objects is undefined, param: ${param}`);
        continue;
      }

      res.count += objects.length;
      for (let item of objects) {
        if (isVideoAssets(item)) {
          res.videoCount++;
        }
        res.uris?.push(item?.uri);
      }
    }

    Log.info(TAG, 'genAlbumsInfo done');
    cb.callback(res);
  }

  public cancelLoadData() {
    this.isCancel = true;
  }

  public isCancelLoadData(): boolean {
    return this.isCancel;
  }

  protected async buildAlbums(callback: AsyncCallback<AlbumInfo[]>, filterMediaType?: string): Promise<void> {
    Log.debug(TAG, 'buildAlbums');

    let sourceData: AlbumInfo[] = [];
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
      // 1. 获取全部相册PhotoAlbum
      let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getAllSortedAlbums({
      });
      // 2. 转换成AlbumsInfo
      sourceData = await this.getAlbumsInfo(albums, filterMediaType);
    } else {
      await this.getSystemAlbumsInfo(sourceData, filterMediaType);
      await this.getUserAlbumsInfo(sourceData, filterMediaType);
      // sourceAlbum
      await this.getSourceAlbumInfo(sourceData, filterMediaType);
    }
    callback.callback(sourceData);
  }

  protected async buildNormalAlbums(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    // 1. 获取全部相册PhotoAlbum
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSortedNormalAlbums({
    });
    // 2. 转换成AlbumsInfo
    let sourceData: AlbumInfo[] = await this.getAlbumsInfo(albums, filterMediaType);

    albumArray.push(...sourceData)
  }

  protected async buildSourceAlbums(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    // 1. 获取全部相册PhotoAlbum
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSortedListAreaAlbums({
    });
    // 2. 转换成AlbumsInfo
    let sourceData: AlbumInfo[] = await this.getAlbumsInfo(albums, filterMediaType);

    albumArray.push(...sourceData)
  }

  protected async getAlbumsInfo(albums: PhotoAlbum[], filterMediaType?: string): Promise<AlbumInfo[]> {
    let albumArray: AlbumInfo[] = [];
    // 维护已处理分组的集合
    const processedGroups = new Set<number>();
    try {
      for (let album of albums) {
        // 判断其中是否存在 微信、微博相册，有的话需要考虑融合 将微信、微博根据lpath聚类为单个相册
        let lpath: string | undefined = album.lpath?.trim();
        let groupIndex: number | undefined = undefined;
        if (groupIndex !== undefined) {
          // 融合相册处理
          /* instrument ignore next */
          if (processedGroups.has(groupIndex)) {
            // 标记该分组已处理
            continue;
          }
          // 标记该分组已处理
          processedGroups.add(groupIndex);
        } else {
          let albumInfo: AlbumInfo = new AlbumInfo(album);
          let count = album.count;
          // 相册的视频数量
          const videoCount = album.videoCount ?? 0;
          albumInfo.setVideoCount(videoCount);
          // Waiting: album.count不为0时，在构造函数里直接获取
          albumInfo.setCount(filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE ? count - videoCount : count);
          let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
          albumInfo.setAlbumName(albumName);
          albumInfo.setFilterMediaType(filterMediaType as string);
          if (albumInfo.count > 0) {
            await this.setCoverPhoto(album, albumInfo, filterMediaType);
          }
          albumArray.push(albumInfo);
          Log.info(TAG, `getAlbumsInfo done, albumInfo: ${albumInfo.printAlbumInfo()}`);
        }
      }
    } catch (error) {
      Log.error(TAG, `getAlbumsInfo error occured: ${error}, code: ${error?.code}`);
    }
    return albumArray;
  }

  private async buildAlbumsWithFilter(callback: AsyncCallback<AlbumInfo[]>,
    param: QueryParam): Promise<void> {
    Log.info(TAG, `buildAlbumsWithFilter, param: ${toString(param)}`);
    if (this.isFirstLoad) {
      this.isFirstLoad = false;
      await this.firstBatchAlbumInfos(callback, param);
      return;
    }
    let photoAlbums: PhotoAlbum[] = await this.getSystemPhotoAlbum();
    photoAlbums = photoAlbums.concat(await this.getUserPhotoAlbum());
    photoAlbums = photoAlbums.concat(await this.getSourcePhotoAlbum());
    let albumInfos: AlbumInfo[] = [];
    let tempResult: AlbumResult = await this.getAlbums(photoAlbums, 0, param, photoAlbums.length);
    albumInfos = albumInfos.concat(tempResult.getAlbums());
    let unionAlbumInfos: AlbumInfo[] = await this.getUnionAlbumInfo(param);
    albumInfos = albumInfos.concat(unionAlbumInfos);
    if (this.isCancelLoadData()) {
      this.isCancel = false;
      Log.info(TAG, `cancel load data.`);
      callback.callback(undefined);
    }
    callback.callback(albumInfos);
  }

  private async firstBatchAlbumInfos(callback: AsyncCallback<AlbumInfo[]>,
    param: QueryParam) {
    let rowCount = Math.ceil(getScreen().getWinHeight() / AlbumThirdSelectDataImpl.ROW_HEIGHT);
    let photoAlbums: PhotoAlbum[] = await this.getSystemPhotoAlbum();
    photoAlbums = photoAlbums.concat(await this.getUserPhotoAlbum());
    photoAlbums = photoAlbums.concat(await this.getSourcePhotoAlbum());
    let albumCount: number = Math.min(rowCount, photoAlbums.length);
    let albumInfos: AlbumInfo[] = [];

    let tempResult: AlbumResult = await this.getAlbums(photoAlbums, 0, param, albumCount);
    albumInfos = albumInfos.concat(tempResult.getAlbums());
    if (this.isCancelLoadData()) {
      this.isCancel = false;
      Log.info(TAG, `first cancel load data.`);
      callback.callback(undefined);
      return;
    }
    Log.info(TAG, `first batch albumInfos length: ${albumInfos.length}, index: ${tempResult.getIndex()}`);
    if (tempResult.getIndex() >= photoAlbums.length) {
      let unionAlbumInfos: AlbumInfo[] = await this.getUnionAlbumInfo(param);
      albumInfos = albumInfos.concat(unionAlbumInfos);
      callback.callback(albumInfos);
      return;
    } else {
      callback.callback(albumInfos);
    }
    tempResult = await this.getAlbums(photoAlbums, tempResult.getIndex(), param, photoAlbums.length);
    albumInfos = albumInfos.concat(tempResult.getAlbums());
    if (this.isCancelLoadData()) {
      this.isCancel = false;
      Log.info(TAG, `second cancel load data.`);
      callback.callback(undefined);
      return;
    }
    let unionAlbumInfos: AlbumInfo[] = await this.getUnionAlbumInfo(param);
    albumInfos = albumInfos.concat(unionAlbumInfos);
    Log.info(TAG, `second batch albumInfos length:${albumInfos.length}`);
    callback.callback(albumInfos);
  }

  private async getUnionAlbumInfo(param: QueryParam): Promise<AlbumInfo[]> {
    let albumInfos = await new SourceTypeAlbumDataImpl(this.context ?? getContext()).buildUnionAlbumsInfo(param);
    return albumInfos;
  }

  private async getAlbums(photoAlbums: PhotoAlbum[], index: number, param: QueryParam,
    albumCount: number): Promise<AlbumResult> {
    Log.info(TAG, 'getAlbums filterMediaType:' + param?.filterMediaType + ', filterConditions=' +
    toString(param?.filterConditions));
    let albumInfos: AlbumInfo[] = [];
    for (; index < photoAlbums.length; index++) {
      if (this.isCancelLoadData()) {
        Log.info(TAG, `getAlbums cancel load data `);
        return new AlbumResult([], 0);
      }
      if (albumInfos.length >= albumCount) {
        break;
      }
      let album: PhotoAlbum = photoAlbums[index];
      let result: AlbumCountAndPhotoAsset =
        await UserFileManagerAccess.getInstance().getAlbumAssetCountAndPhotoAsset(album, param);
      let count: number = result.getCount();
      let photoAsset: photoAccessHelper.PhotoAsset | undefined = result.getAsset();
      if (count <= 0) {
        Log.info(TAG, `count:` + count);
        continue;
      }
      let albumInfo: AlbumInfo = new AlbumInfo(album);
      albumInfo.setCount(count); // Waiting: album.count不为0时，在构造函数里直接获取
      // 相册的视频数量
      const videoCount = album.videoCount ?? 0;
      albumInfo.setVideoCount(videoCount);
      let mediaItem = new MediaItem(photoAsset);
      mediaItem.setThumbnail(ImageUtil.getThumbnailAstcUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified()));
      albumInfo.setMediaItem(mediaItem);
      albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified()));
      albumInfo.setCoverPhotoUri(mediaItem.uri);
      albumInfos.push(albumInfo);
    }
    return new AlbumResult(albumInfos, index);
  }

  private async getSourcePhotoAlbum(): Promise<PhotoAlbum[]> {
    if (!this.context) {
      Log.info(TAG, 'context is undefined.');
      return [];
    }
    let albumInfos: PhotoAlbum[] =
      await new SourceTypeAlbumDataImpl(this.context).buildSourcePhotoAlbums();
    return albumInfos;
  }

  private async getSystemPhotoAlbum(): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    for (let lpath of UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST) {
      let photoAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums(lpath);
      if (photoAlbums.length > 0 && photoAlbums[0].count > 0) {
        albums.push(photoAlbums[0]);
      }
    }
    return albums;
  }

  private async getUserPhotoAlbum(): Promise<PhotoAlbum[]> {
    let albumInfos: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    return albumInfos;
  }

  protected async getUserAlbumsInfo(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    Log.debug(TAG, `getUserAlbumsInfo albums is : ${albums}`);

    if (!albums) {
      Log.error(TAG, 'getUserAlbumsInfo, albums undefined');
      return;
    }
    Log.info(TAG, `getUserAlbumsInfo fetch albums length : ${albums.length}`);

    try {
      await this.processAlbums(albums, albumArray, filterMediaType);
    } catch (error) {
      Log.error(TAG, `getUserAlbumsInfo error occurred: ${error}, code: ${error?.code}`);
    }

    Log.info(TAG, 'getUserAlbumsInfo done');
  }

  private async processAlbums(albums: PhotoAlbum[], albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    for (let album of albums) {
      let albumInfo: AlbumInfo = new AlbumInfo(album);
      const albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
      albumInfo.setAlbumName(albumName);
      albumInfo.setFilterMediaType(filterMediaType as string);
      const count = albumInfo.count;
      albumInfo.setCount(count); // Waiting: album.count不为0时，在构造函数里直接获取
      if (count > 0) {
        // 相册的视频数量
        const videoCount = album.videoCount ?? 0;
        albumInfo.setVideoCount(videoCount);
        if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
          albumInfo.setCount(count - videoCount);
        }
        // 设置封面
        await this.setCoverPhoto(album, albumInfo, filterMediaType);
      }
      albumArray.push(albumInfo);
      Log.info(TAG, `processAlbums done, albumInfo : ${albumInfo.toString()}, ` +
        `albumArray length: ${albumArray.length}`);
    }
  }

  protected async getSystemAlbumsInfo(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    // 系统来源相册（包含相机、截图、录屏）
    if (!DeviceInfo.isPc()) {
      for (let lpath of UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST) {
        let photoAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums(lpath);
        if (photoAlbums.length > 0 && photoAlbums[0].count > 0) {
          albums.push(photoAlbums[0]);
        }
      }
    }
    Log.debug(TAG, `getSystemAlbumsInfo albums is : ${albums}`);

    if (!albums) {
      Log.error(TAG, 'getSystemAlbumsInfo, albums undefined');
    }
    Log.info(TAG, `getSystemAlbumsInfo fetch albums length : ${albums.length}`);
    try {
      for (let album of albums) {
        let albumInfo: AlbumInfo = new AlbumInfo(album);
        let count = album.count;
        // 系统相册为空时不展示
        if (!this.isPickerUsedSubwindow && count === 0) {
          Log.warn(TAG, 'getSystemAlbumsInfo count is 0');
          continue;
        }
        // 相册的视频数量
        const videoCount = album.videoCount ?? 0;
        albumInfo.setVideoCount(videoCount);
        // Waiting: album.count不为0时，在构造函数里直接获取
        albumInfo.setCount(filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE ? count - videoCount : count);
        let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
        albumInfo.setAlbumName(albumName);
        albumInfo.setFilterMediaType(filterMediaType as string);
        if (albumInfo.count > 0) {
          await this.setCoverPhoto(album, albumInfo, filterMediaType);
        }
        albumArray.push(albumInfo);
        Log.info(TAG, `getSystemAlbumsInfo done, albumInfo : ${albumInfo.toString()}, ` +
          `albumArray length: ${albumArray.length}`);
      }
    } catch (error) {
      Log.error(TAG, `getSystemAlbumsInfo error occured: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, 'getSystemAlbumsInfo done');
  }

  public async useRetrysetAlbumCover(album: PhotoAlbum, albumInfo: AlbumInfo): Promise<void> {
    let hasCoverUri: Boolean = false;
    if (album.coverUri) {
      await UserFileManagerAccess.getInstance()
        .getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri), TAG)
        .then((obj) => {
          if (obj?.obj) {
            let mediaItem = new MediaItem(obj.obj);
            this.setAlbumInfoProp(albumInfo, mediaItem, obj.obj);
            hasCoverUri = true;
          }
        });
    }
    if (!hasCoverUri) {
      await UserFileManagerAccess.getInstance().getAlbumFirstObject(album).then((obj) => {
        if (obj) {
          let item = new MediaItem(obj);
          this.setAlbumInfoProp(albumInfo, item, obj);
        }
      });
    }
  }

  protected async getTrashAlbumInfo(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    Log.debug(TAG, `getTrashAlbumInfo albums is : ${album}`);

    if (!album) {
      Log.error(TAG, 'getTrashAlbumInfo, get album undefined');
    }
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    let count = albumInfo.count;
    // 系统相册为空时不展示
    if (count === 0) {
      Log.warn(TAG, 'getTrashAlbumInfo count is 0');
      return;
    }
    albumInfo.setCount(count);
    if (album) {
      let albumName: Resource | string = await UserFileManagerAccess.getInstance().getAlbumNameResource(album);
      albumInfo.setAlbumName(albumName);
    }
    albumInfo.setFilterMediaType(filterMediaType as string);
    albumArray.push(albumInfo);
    Log.info(TAG, `getTrashAlbumInfo done, albumInfo : ${albumInfo.toString()}, ` +
      `albumArray length: ${albumArray.length}`);
  }

  protected async getSourceAlbumInfo(albumArray: AlbumInfo[], filterMediaType?: string): Promise<void> {
    if (!this.context) {
      Log.info(TAG, 'context is undefined.');
      return;
    }
    let albumInfos: AlbumInfo[] =
      await new SourceTypeAlbumDataImpl(this.context).buildSourceAlbums(undefined, filterMediaType);
    Log.debug(TAG, `buildSourceAlbums albums is : ${albumInfos}`);
    if (!albumInfos) {
      Log.error(TAG, 'buildSourceAlbums, albums undefined');
      return;
    }
    Log.info(TAG, `buildSourceAlbums fetch albums length : ${albumInfos.length}`);
    try {
      for (let albumInfo of albumInfos) {
        // 来源相册为空时不展示
        if (albumInfo.count === 0) {
          Log.warn(TAG, 'getSourceAlbumInfo count is 0');
          continue;
        }
        albumArray.push(albumInfo);
        Log.info(TAG, `getSourceAlbumInfo done, albumInfo : ${albumInfo.toString()}, ` +
          `albumArray length: ${albumArray.length}`);
      }
    } catch (error) {
      Log.error(TAG, `getSourceAlbumInfo error occured: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, 'getSourceAlbumInfo done');
  }

  public getDataIndexByUri(callback: AsyncCallback, param: QueryParam, uri: string): void {
  }

  public getDataIndexById(callback: AsyncCallback, param: QueryParam, id: number): void {
  }

  public getMediaItemByUri(callback: AsyncCallback | Function, uri: string): void {
  }

  /**
   * 设置相册封面
   * @param album 相册
   * @param albumInfo 相册
   * @param filterMediaType 过滤媒体类型
   * @returns
   */
  private async setCoverPhoto(album: PhotoAlbum, albumInfo: AlbumInfo, filterMediaType?: string): Promise<void> {
    let hasCoverUri: Boolean = false;
    if (album.coverUri) {
      // 常见视频文件扩展名
      const isVideo = CommonUtil.isVideoFile(album.coverUri);
      const count = albumInfo.count;
      const videoCount = albumInfo.videoCount;
      Log.info(TAG, `setCoverPhoto isVideo: ${isVideo} filterMediaType: ${
      filterMediaType} count: ${count} videoCount: ${videoCount}`);
      // 筛选图片 但封面不是图片
      if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE && isVideo && count > 0) {
        // 查找此相册第一个图片
        let obj = await UserFileManagerAccess.getInstance().getAlbumFirstImageOrVideo(album,
          UserFileManagerAccess.MEDIA_TYPE_IMAGE.toString());
        if (obj) {
          let mediaItem = new MediaItem(obj);
          Log.info(TAG, `setCoverPhoto FILTER_MEDIA_TYPE_IMAGE mediaItem: ${mediaItem?.uri}`);
          if (!CommonUtil.isVideoFile(mediaItem.uri)) {
            this.setAlbumInfoProp(albumInfo, mediaItem, obj);
            hasCoverUri = true;
          }
        }
      } else if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO && !isVideo && videoCount > 0) {
        // 筛选视频 但封面不是视频
        let obj = await UserFileManagerAccess.getInstance().getAlbumFirstImageOrVideo(album,
          UserFileManagerAccess.MEDIA_TYPE_VIDEO.toString());
        if (obj) {
          let mediaItem = new MediaItem(obj);
          Log.info(TAG, `setCoverPhoto FILTER_MEDIA_TYPE_VIDEO mediaItem: ${mediaItem?.uri}`);
          if (CommonUtil.isVideoFile(mediaItem.uri)) {
            this.setAlbumInfoProp(albumInfo, mediaItem, obj);
            hasCoverUri = true;
          }
        }
      } else {
        let obj = await UserFileManagerAccess.getInstance()
          .getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri), TAG);
        if (obj?.obj) {
          let mediaItem = new MediaItem(obj.obj);
          this.setAlbumInfoProp(albumInfo, mediaItem, obj.obj, album.coverUri);
          hasCoverUri = true;
        }
      }
    }
    if (!hasCoverUri) {
      await UserFileManagerAccess.getInstance().getAlbumFirstObject(album).then((obj) => {
        if (obj) {
          let mediaItem = new MediaItem(obj);
          this.setAlbumInfoProp(albumInfo, mediaItem, obj);
        }
      });
    }
  }

  private setAlbumInfoProp(albumInfo: AlbumInfo, mediaItem: MediaItem, obj: photoAccessHelper.PhotoAsset, uri =
  obj.uri):

    void {
    mediaItem.setThumbnail(this.getThumbnailSafe(obj.uri,
      String(obj.get(Constants.KEY_FILE_DATA)), mediaItem.getDateModified()));
    albumInfo.setMediaItem(mediaItem);
    albumInfo.setCoverUri(ImageUtil.calcThumbnail(obj.uri, mediaItem.height, mediaItem.width));
    albumInfo.setCoverPhotoUri(uri);
  }
}