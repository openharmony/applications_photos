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

import lazy { AlbumCallBackParam, AlbumDefine } from '../AlbumDefine';
import lazy { AlbumInfo } from './AlbumInfo';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { BrowserDataImpl } from '../BrowserDataImpl';
import lazy {
  FetchOptions,
  FileAssetEx,
  PhotoAlbum,
  UserFileManagerAccess
} from '../../../access/UserFileManagerAccess';
import type { PhotoAsset } from '../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy { Log } from '../../../utils/Log';
import lazy { Constants } from '../../common/Constants';
import lazy { isPhotoAsset, MediaItem } from '../photo/MediaItem';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import type common from '@ohos.app.ability.common';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { QueryAlbumParam, QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { CommonUtil } from '../../../utils/CommonUtil';
import lazy { AlbumAssetInfo } from './AlbumAssetInfo';
import lazy { PreferencesUtil } from '../../../utils/PreferencesUtil';
import lazy { HashMap } from '@kit.ArkTS';
import lazy { buildUnionAlbumInfo } from '../../../utils/UnionAlbumsUtil';
import lazy { SHARE_ALBUM_LPATH } from '../../../access/PhotoAccessHelperAccess';
import lazy { AlbumGridSortHelper } from '../../AlbumGridSortHelper';

/* instrument ignore file */
const TAG: string = 'common_AlbumDataImpl';

export interface AlbumSimpleInfo {
  uris: string[];
  count: number;
  videoCount: number;
}

export class AlbumDataImpl extends BrowserDataImpl {
  constructor() {
    super();
  }

  /* instrument ignore next */
  public async getDataByUri(uri: string): Promise<AlbumInfo | undefined> {
    return await this.getAlbumsByUri(uri);
  }

  public getData(callback: AsyncCallback<AlbumInfo[] | AlbumSimpleInfo>, param: QueryAlbumParam): void {
    Log.info(TAG, `load data getData start: ${JSON.stringify(param)}`);
    if (!param) {
      this.buildAlbums(callback);
    } else if (param.start !== undefined && param.count !==
      undefined && Number.isFinite(param.start) && Number.isFinite(param.count)) {
      this.getAlbums(callback, param.start, param.count,
        param.filterMediaType, param.blackUriList, param.nameOnly, param.hasItemsOnly);
    } else if (param.filterMediaType !== undefined && param.filterMediaType !== null) {
      this.buildAlbums(callback, param.filterMediaType);
    } else {
      // 删除相册时，计算图片视频数量
      this.genAlbumsInfo(callback, param.uris ?? []);
    }
  }

  public async getDataAsync(callback: AsyncCallback<AlbumInfo[] | AlbumSimpleInfo>, param?: QueryAlbumParam):
    Promise<void> {
    Log.debug(TAG, `load data  getData start: ${param}`);
    if (!param) {
      await this.buildAlbums(callback);
    } else if (param?.filterMediaType !== undefined && param?.filterMediaType !== null) {
      await this.buildAlbums(callback, param.filterMediaType);
    } else {
      // 删除相册时，计算图片视频数量
      await this.genAlbumsInfo(callback, param.uris ?? []);
    }
  }

  public async getAlbumLpathByUriAsync(albumUri?: string): Promise<string | undefined> {
    return await UserFileManagerAccess.getInstance().getAlbumLpathByUri(albumUri);
  }

  /**
   * 查询相册命名
   *
   * @param name 相册名
   * @param albumUri 对应相册的uri
   * @returns 相册名称
   */
  /* instrument ignore next */
  public async getDataByName(name: string, albumUri?: string): Promise<PhotoAlbum | undefined> {
    let albums = await UserFileManagerAccess.getInstance().getUserAlbums(AlbumDefine.getAlbumFetchOptByName(name));
    if (albums?.length > 0) {
      let opt: FetchOptions = AlbumDefine.getFileFetchOpt();
      let fileResult = await albums[0].getAssets(opt);
      if (!fileResult) {
        Log.warn(TAG, 'not valid fileResult');
        return undefined;
      }
      let count = fileResult.getCount();
      fileResult.close();
      Log.info(TAG, `fetchResult is close.`);
      if (count <= 0) {
        Log.warn(TAG, `Not valid album Name: ${AlbumDefine.getAnonymizeAlbumName(albums[0].albumName)}, ` +
          `URI: ${albums[0].albumUri}`);
        return undefined;
      }
      return albums[0];
    }
    return undefined;
  }

  /* instrument ignore next */
  public getDataCount(callback: AsyncCallback<number>, param: QueryAlbumParam): void {
    this.getAlbumsCount(param).then((count): void => {
      Log.debug(TAG, `getAlbumsCount callback: ${count}`);
      callback.callback(count);
    });
  }

  /* instrument ignore next */
  public getDataIndexByUri(callback: AsyncCallback<number>, param: QueryAlbumParam, uri: string): void {
    Log.debug(TAG, `getDataIndexByUri: ${uri}, ${JSON.stringify(param)}`);
    this.getAlbumsIndexByUri(uri, param?.filterMediaType).then((index): void => {
      Log.debug(TAG, `getAlbumsIndexByUri callback: ${index}`);
      callback.callback(index);
    });
  }

  /* instrument ignore next */
  public getMediaItemByUri(callback: AsyncCallback<AlbumInfo>, uri: string): void {
    this.getAlbumsByUri(uri).then((album): void => {
      Log.debug(TAG, `getAlbumsByUri callback: ${album?.toString()}`);
      callback.callback(album);
    });
  }

  protected setAlbumCover(albumInfo: AlbumInfo, data: PhotoAsset): void {
    if (!albumInfo || !data) {
      return;
    }
    let mediaItem: MediaItem = new MediaItem(data);
    mediaItem.setThumbnail(ImageUtil.getThumbnailAstcUri(data.uri, String(data.get(Constants.KEY_FILE_DATA)),
      mediaItem.getDateModified()));
    albumInfo.setMediaItem(mediaItem);
    albumInfo.setCoverOrientation(mediaItem.orientation);
    albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(data.uri, String(data.get(Constants.KEY_FILE_DATA)),
      mediaItem.getDateModified()));
    albumInfo.setCoverPhotoUri(data.uri);
  }

  private async genAlbumsInfo(cb: AsyncCallback<AlbumSimpleInfo>, uris: string[]): Promise<void> {
    Log.debug(TAG, `genAlbumsInfo uris: ${JSON.stringify(uris)}`);
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
        Log.debug(TAG, `get album objects undefined: uri: ${uri} `);
        continue;
      }
      Log.debug(TAG, `get album objects: uri: ${uri} length: ${objects.length}`);

      res.count += objects.length;
      for (let item of objects) {

        if (isPhotoAsset(item) && item.photoType === photoAccessHelper.PhotoType.VIDEO) {
          res.videoCount++;
        }
        (res.uris ?? []).push(item.uri);
      }
    }

    Log.debug(TAG, 'genAlbumsInfo done');
    cb.callback(res);
  }

  /* instrument ignore next */
  private async buildAlbums(callback: AsyncCallback<AlbumInfo[]>, filterMediaType?: string): Promise<void> {
    Log.debug(TAG, 'buildAlbums');
    let sourceData: AlbumInfo[] = [];
    let sysAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    await this.getSystemAlbumsInfo(sysAlbums, sourceData, undefined, undefined, filterMediaType);
    let userAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    await this.getUserAlbumsInfo(userAlbums, sourceData, undefined, undefined, filterMediaType);
    await this.getTrashAlbumInfo(sourceData, undefined, undefined, filterMediaType);
    callback.callback(sourceData);
    Log.debug(TAG, 'buildAlbums end');
  }

  protected async getAlbums(callback: AsyncCallback<AlbumInfo[]>, start: number, count: number,
    filterMediaType?: string,
    blackUriList?: string[], nameOnly?: boolean, hasItemsOnly?: boolean): Promise<void> {
    Log.info(TAG, `getAlbums, start = ${start} count = ${
    count}, filterMediaType = ${filterMediaType}, blackUriList = ${JSON.stringify(blackUriList)}`);
    let sourceData: AlbumInfo[] = [];
    if (count === 0) {
      Log.error(TAG, 'getAlbums end, no albums');
      return;
    }
    let leftCount: number = 0;
    let sysAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    let systemAlbumCount: number = await this.getSystemAlbumsCount(sysAlbums, filterMediaType, blackUriList);
    let userAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    let userAlbumCount: number = await this.getUserAlbumsCount(userAlbums, filterMediaType, blackUriList, hasItemsOnly);

    if (start < systemAlbumCount && count > 0) {
      await this.getSystemAlbumsInfo(sysAlbums, sourceData, start, count, filterMediaType, blackUriList, nameOnly);
    }
    if (start >= systemAlbumCount) {
      start -= systemAlbumCount;
    } else {
      start = 0;
    }
    leftCount = count - sourceData.length;
    if (start < userAlbumCount && leftCount > 0) {
      await this.getUserAlbumsInfo(userAlbums,
        sourceData, start, leftCount, filterMediaType, blackUriList, nameOnly, hasItemsOnly);
    }
    if (start >= userAlbumCount) {
      start -= userAlbumCount;
    } else {
      start = 0;
    }

    Log.info(TAG, `getAlbums end, sourceData.length=${sourceData.length}`);
    let param: AlbumCallBackParam = {
      userAlbumCount: userAlbumCount,
    };
    callback.callback(sourceData, JSON.stringify(param));
    Log.debug(TAG, 'getAlbums end');
  }

  protected async getAlbumsCount(param: QueryAlbumParam): Promise<number> {
    Log.debug(TAG, 'genAlbumsCount start');
    let sysAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    let systemAlbumCount: number =
      await this.getSystemAlbumsCount(sysAlbums, param?.filterMediaType, param?.blackUriList);
    let userAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    let userAlbumCount: number =
      await this.getUserAlbumsCount(userAlbums, param?.filterMediaType, param?.blackUriList, param?.hasItemsOnly);
    let albumCount: number = systemAlbumCount + userAlbumCount;
    Log.debug(TAG, `genAlbumsCount end, count = ${albumCount}`);
    return albumCount;
  }

  /* instrument ignore next */
  private async getAlbumsByUri(uri: string): Promise<AlbumInfo | undefined> {
    Log.debug(TAG, 'genAlbumsCount start');
    return await this.getSystemAlbumByUri(uri) ||
      await this.getUserAlbumByUri(uri) || await this.getTrashAlbumByUri(uri);
  }

  private async getAlbumsIndexByUri(uri: string, filterMediaType?: string): Promise<number> {
    Log.debug(TAG, 'getAlbumsIndexByUri start');
    let index: number = 0;
    let count: number = 0;
    index = await this.getSystemAlbumIndexByUri(uri, filterMediaType);
    if (index !== -1) {
      Log.debug(TAG, `getAlbumsIndexByUri done, index=${index}`);
      return index + count;
    }
    let sysAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    count += await this.getSystemAlbumsCount(sysAlbums, filterMediaType);
    index = await this.getUserAlbumIndexByUri(uri, filterMediaType);
    if (index !== -1) {
      Log.debug(TAG, `getAlbumsIndexByUri done, index=${index}`);
      return index + count;
    }
    let userAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    count += await this.getUserAlbumsCount(userAlbums, filterMediaType);
    index = await this.getTrashAlbumIndexByUri(uri, filterMediaType);
    if (index !== -1) {
      Log.debug(TAG, `getAlbumsIndexByUri done, index=${index}`);
      return index + count;
    }
    return -1;
  }

  protected async getUserAlbumsInfo(albums: PhotoAlbum[], albumArray: AlbumInfo[], start?: number, count?: number,
    filterMediaType?: string, blackUriList?: string[],
    nameOnly?: boolean, hasItemsOnly?: boolean): Promise<void> {
    Log.debug(TAG, `getUserAlbumsInfo start, start=${
      start}, count=${count}, filterMediaType=${filterMediaType}, blackUriList=${blackUriList}`);
    let index: number = 0;
    if (!albums) {
      Log.error(TAG, 'getUserAlbumsInfo, albums undefined');
    }
    Log.info(TAG, `getUserAlbumsInfo fetch albums length: ${albums.length}`);
    try {
      for (let album of albums) {
        if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
          Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
          continue;
        }
        if (hasItemsOnly) {
          let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
          if (photoCount === 0) {
            Log.debug(TAG, `getUserAlbumsInfo count is 0, mediaType: ${filterMediaType}`);
            continue;
          }
        }

        Log.debug(TAG, `getUserAlbumsInfo index: ${index}`);

        // 当start和count都存在时，判断当前相册的index，只有该index在[start,start+count]之间时，该相册是本次需要获取的相册
        const userAlbumsInfoBool = start !==
          undefined && count !== undefined && Number.isFinite(start) && Number.isFinite(count);
        if (userAlbumsInfoBool) {
          index++;
        }
        if (userAlbumsInfoBool && index <= start) {
          continue;
        }
        if (userAlbumsInfoBool && index > (start + count)) {
          break;
        }
        let albumInfo: AlbumInfo = new AlbumInfo(album);
        albumInfo.setFilterMediaType(filterMediaType ?? '');
        let photoCount = albumInfo.count;
        if (nameOnly) {
          albumArray.push(albumInfo);
          Log.debug(TAG, `getSystemAlbumsInfo done, albumInfo: ${albumInfo.toString()}, ` +
            `albumArray length: ${albumArray.length}`);
          continue;
        }
        if (photoCount > 0) {
          // 没有相册，设置为第一张
          await this.useRetrysetAlbumCover(album, albumInfo);
          // 相册的视频数量
          if (album.videoCount === undefined) {
            Log.warn(TAG, `getUserAlbumsInfo warn: album.videoCount is undefined, album uri: ${album.albumUri}`);
          }
        }
        albumArray.push(albumInfo);
        Log.debug(TAG, `getUserAlbumsInfo done, albumInfo: ${albumInfo.toString()}, ` +
          `albumArray length: ${albumArray.length}`);
      }
    } catch (error) {
      Log.error(TAG, `getUserAlbumsInfo error occured: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, `getUserAlbumsInfo done, count: ${albumArray.length}`);
  }

  /* instrument ignore next */
  private async getUserAlbumByUri(uri: string): Promise<AlbumInfo | undefined> {
    Log.debug(TAG, 'getUserAlbumsByUri start');
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance()
      .getUserAlbums(AlbumDefine.getAlbumFetchOptByUri(uri));
    let albumInfo: AlbumInfo | undefined = undefined;
    if (!albums) {
      Log.error(TAG, 'getUserAlbumsByUri, albums undefined');
    }
    Log.info(TAG, `getUserAlbumsByUri fetch albums length: ${albums.length}`);
    try {
      for (let album of albums) {
        if (album.albumUri !== uri) {
          continue;
        }
        albumInfo = new AlbumInfo(album);
        let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
        albumInfo.setAlbumName(albumName);
        albumInfo.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_ALL);
        albumInfo.isSystemAlbum = false;
        let photoCount = albumInfo.count;
        albumInfo.setCount(photoCount); // Waiting: album.count不为0时，在构造函数里直接获取
        let videoCount = 0;
        if (photoCount > 0) {
          // 没有相册，设置为第一张
          await this.useRetrysetAlbumCover(album, albumInfo);
          // 相册的视频数量
          videoCount = album.videoCount ?? 0;
        }
        albumInfo.setVideoCount(videoCount);
        Log.debug(TAG, `getUserAlbumsByUri done, albumInfo: ${albumInfo.printAlbumInfo()}`);
      }
    } catch (error) {
      Log.error(TAG, `getUserAlbumsByUri error occured: ${error}, code: ${error?.code}`);
    }
    Log.debug(TAG, 'getUserAlbumsByUri done');
    return albumInfo;
  }

  /* instrument ignore next */
  private async getUserAlbumIndexByUri(uri: string, filterMediaType?: string): Promise<number> {
    Log.debug(TAG, 'getUserAlbumIndexByUri start');
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    let index: number = 0;
    if (!albums) {
      Log.error(TAG, 'getUserAlbumIndexByUri, albums undefined');
      return -1;
    }
    Log.info(TAG, `getUserAlbumIndexByUri fetch albums length: ${albums.length}`);
    for (let album of albums) {
      if (album.albumUri !== uri) {
        index++;
        continue;
      }
      Log.debug(TAG, `getUserAlbumIndexByUri done, index=${index}`);
      return index;
    }
    Log.debug(TAG, 'getUserAlbumIndexByUri done');
    return -1;
  }

  protected async getUserAlbumsCount(albums: PhotoAlbum[], filterMediaType?: string, blackUriList?:
    string[], hasItemsOnly?: boolean): Promise<number> {
    Log.debug(TAG, 'getUserAlbumsCount start');
    let albumCount = 0;
    if (!albums) {
      Log.error(TAG, 'getUserAlbumsCount, albums undefined');
    }
    Log.info(TAG, `getUserAlbumsCount fetch albums length ${albums.length}`);
    try {
      for (let album of albums) {
        if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
          Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
          continue;
        }
        if (!hasItemsOnly) {
          albumCount++;
          continue;
        }
        let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
        if (photoCount === 0) {
          Log.debug(TAG, `getUserAlbumsCount count is 0, mediaType: ${filterMediaType}`);
          continue;
        }
        albumCount++;
      }
    } catch (error) {
      Log.error(TAG, `getUserAlbumsCount error occured: ${error}, code: ${error?.code}`);
    }
    Log.debug(TAG, `getUserAlbumsCount done, count = ${albumCount}`);
    return albumCount;
  }

  protected async getSystemAlbumsInfo(albums: PhotoAlbum[], albumArray: AlbumInfo[], start?: number,
    count?: number, filterMediaType?: string, blackUriList?: string[], nameOnly?: boolean): Promise<void> {
    Log.debug(TAG, `getSystemAlbumsInfo start, start=${start}, count=${
      count}, filterMediaType=${filterMediaType}, blackUriList=${blackUriList}`);
    let index: number = 0;
    if (!albums) {
      Log.error(TAG, 'getSystemAlbumsInfo, albums undefined');
    }
    Log.info(TAG, `getSystemAlbumsInfo fetch albums length: ${albums.length}`);
    try {
      for (let album of albums) {
        let photoCount = album.count;
        let videoCount = album.videoCount ?? 0;
        // 系统相册为空时不展示
        if (this.continueControl(filterMediaType, videoCount, photoCount, blackUriList, album)) {
          continue;
        }
        /*
          当start和count都存在时，判断当前相册的index，只有该index在[start,start+count]之间时，该相册是本次需要获取的相册
        */
        const systemAlbumsInfoBool = start && count && Number.isFinite(start) && Number.isFinite(count);
        if (systemAlbumsInfoBool) {
          index++;
        }
        if (systemAlbumsInfoBool && index <= start) {
          continue;
        }
        if (systemAlbumsInfoBool && index > (start + count)) {
          break;
        }
        let albumInfo: AlbumInfo = this.getAlbumInfo(album, photoCount, videoCount ?? 0, filterMediaType);

        if (nameOnly) {
          albumArray.push(albumInfo);
          Log.debug(TAG, `getSystemAlbumsInfo done, albumInfo: ${albumInfo.toString()}, ` +
            `albumArray length: ${albumArray.length}`);
          continue;
        }
        await this.useRetrysetAlbumCover(album, albumInfo);

        albumArray.push(albumInfo);
        Log.info(TAG, `getSystemAlbumsInfo done, albumInfo: ${albumInfo.toString()}, ` +
          `albumArray length: ${albumArray.length}`);
      }
    } catch (error) {
      Log.error(TAG, `getSystemAlbumsInfo error occured: ${error}, code: ${error?.code}`);
    }
  }

  /* instrument ignore next */
  public continueControl(filterMediaType: AlbumDefine | undefined, videoCount: number, photoCount: number,
    blackUriList: string[] | undefined, album: PhotoAlbum): boolean {
    if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
      if (videoCount === 0) {
        Log.debug(TAG, 'getSystemAlbumsInfo video count is 0');
        return true;
      }
    } else if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      if ((photoCount - videoCount) === 0) {
        Log.debug(TAG, 'getSystemAlbumsInfo photo count is 0');
        return true;
      }
    } else {
      if (photoCount === 0) {
        Log.debug(TAG, 'getSystemAlbumsInfo count is 0');
        return true;
      }
    }
    if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
      Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
      return true;
    }
    return false;
  }

  public getAlbumInfo(album: PhotoAlbum, photoCount: number, videoCount: number, filterMediaType?: string): AlbumInfo {
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    albumInfo.setFilterMediaType(filterMediaType ?? '');
    albumInfo.isSystemAlbum = true;
    return albumInfo;
  }

  protected async useRetrysetAlbumCover(album: PhotoAlbum, albumInfo: AlbumInfo,
    filterMediaType?: string): Promise<void> {
    if (!album || !albumInfo) {
      Log.error(TAG, 'useRetrysetAlbumCover: album or albumInfo is undefined!');
      return;
    }

    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('useRetrysetAlbumCover', startTime);
    let checkFilterType: (uri: string) => boolean = (uri: string): boolean => {
      if (filterMediaType && filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_ALL) {
        const isVideo: boolean = CommonUtil.isVideoFile(uri);
        const filterVideo: boolean = filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO;
        return isVideo === filterVideo;
      }
      return true;
    }
    let userFileManager: UserFileManagerAccess = UserFileManagerAccess.getInstance();

    // 获取 album 的 Cover
    if (album.coverUri) {
      let firstCover: FileAssetEx = await userFileManager
        .getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri), TAG);
      if (firstCover?.obj && checkFilterType(firstCover?.obj.uri)) {
        this.setAlbumCover(albumInfo, firstCover.obj);
        TraceControllerUtils.finishTraceWithTaskId('useRetrysetAlbumCover', startTime);
        Log.info(TAG, `useRetrysetAlbumCover from cover finished, cost time: ${Date.now() - startTime}}`);
        return;
      }
    }

    //  album 的 Cover 不可用，获取 album 中所有文件中的第一个， 注意 filterMediaType
    let firstItem: photoAccessHelper.PhotoAsset | undefined;
    if (filterMediaType && filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_ALL) {
      let photoTypeKey: string = AlbumDefine.getPhotoTypeKeyByFilterMediaType(filterMediaType);
      firstItem = await userFileManager.getAlbumFirstImageOrVideo(album, photoTypeKey);
    } else {
      firstItem = await userFileManager.getAlbumFirstObject(album);
    }
    if (firstItem) {
      this.setAlbumCover(albumInfo, firstItem);
      Log.info(TAG, `useRetrysetAlbumCover from all items finished, cost time: ${Date.now() - startTime}}`);
    } else {
      Log.error(TAG, `useRetrysetAlbumCover from all items failed, cost time: ${Date.now() - startTime}}`);
    }
    TraceControllerUtils.finishTraceWithTaskId('useRetrysetAlbumCover', startTime);
  }

  private hasNoSpecifiedContent(albumInfo: AlbumInfo, filterMediaType?: string): boolean {
    return (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO && albumInfo.videoCount === 0) ||
      albumInfo.count === 0;
  }

  protected async setAlbumCoverFromAlbums(albums: PhotoAlbum[], albumInfo: AlbumInfo,
    filterMediaType?: string): Promise<void> {
    if (!albums || albums.length == 0) {
      Log.error(TAG, 'setAlbumCoverFromAlbums: albums is undefined or empty!');
      return;
    }
    if (!albumInfo) {
      Log.error(TAG, 'setAlbumCoverFromAlbums: albumInfo is undefined!');
      return;
    }
    if (this.hasNoSpecifiedContent(albumInfo, filterMediaType)) {
      Log.info(TAG, 'setAlbumCoverFromAlbums: albumInfo does not have specified content, fast return!');
      return;
    }

    const startIndex: number = 0;
    const count: number = 1;
    const needThumbnailReady: boolean = false;
    const orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS;
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('setAlbumCoverFromAlbums', startTime);

    // 获取 albums 的 Cover 中 filterMediaType 类型的第一个
    let fetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType, needThumbnailReady, orderProp);
    let coverUris: string[] = albums.map((album: PhotoAlbum): string => album.coverUri);
    AlbumDefine.modifyPredicatesInPhotoUris(fetchOpt.predicates, coverUris);
    let firstCover: FileAssetEx = await UserFileManagerAccess.getInstance().getFirstObject(fetchOpt, TAG);
    if (firstCover.obj) {
      this.setAlbumCover(albumInfo, firstCover.obj);
      TraceControllerUtils.finishTraceWithTaskId('setAlbumCoverFromAlbums', startTime);
      Log.info(TAG, `setAlbumCoverFromAlbums from all covers finished, cost time: ${Date.now() - startTime}}`);
      return;
    }

    //  albums 的 Cover 均不可用，获取 albums 中所有文件中filterMediaType 类型的第一个
    const albumUris: string[] = albums.map((album: PhotoAlbum): string => album.albumUri);
    let allItemsFetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType, needThumbnailReady, orderProp);
    AlbumDefine.modifyPredicatesInAlbumUris(allItemsFetchOpt.predicates, albumUris);
    let firstItem: FileAssetEx = await UserFileManagerAccess.getInstance().getFirstObject(allItemsFetchOpt, TAG);
    if (firstItem.obj) {
      this.setAlbumCover(albumInfo, firstItem.obj);
      Log.info(TAG, `setAlbumCoverFromAlbums from all items finished, cost time: ${Date.now() - startTime}}`);
    } else {
      Log.error(TAG, `setAlbumCoverFromAlbums from all items failed, cost time: ${Date.now() - startTime}}`);
    }
    TraceControllerUtils.finishTraceWithTaskId('setAlbumCoverFromAlbums', startTime);
  }

  /* instrument ignore next */
  private async getSystemAlbumByUri(uri: string): Promise<AlbumInfo | undefined> {
    Log.debug(TAG, 'getSystemAlbumsByUri start');
    let albumInfo: AlbumInfo | undefined = undefined;
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    if (!albums) {
      Log.error(TAG, 'getSystemAlbumsByUri, albums undefined');
    }
    Log.info(TAG, `getSystemAlbumsByUri fetch albums length: ${albums.length}`);
    try {
      for (let album of albums) {
        if (album.albumUri !== uri || album.count === 0) {
          continue;
        }
        albumInfo = new AlbumInfo(album);
        let photoCount = album.count;
        let videoCount = album.videoCount ?? 0;
        albumInfo.setCount(photoCount); // Waiting: album.count不为0时，在构造函数里直接获取
        // 相册的视频数量
        albumInfo.setVideoCount(videoCount);
        let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
        albumInfo.setAlbumName(albumName);
        albumInfo.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_ALL);
        albumInfo.isSystemAlbum = true;
        await this.useRetrysetAlbumCover(album, albumInfo);
        Log.debug(TAG, `getSystemAlbumsByUri done, albumInfo: ${albumInfo.toString()}`);
      }
    } catch (error) {
      Log.error(TAG, `getSystemAlbumsByUri error occured: ${error}, code: ${error?.code}`);
    }
    Log.debug(TAG, 'getSystemAlbumsByUri done');
    return albumInfo;
  }

  public getItemsCountOfAlbum(album: PhotoAlbum, filterMediaType?: string): number {
    if (!filterMediaType) {
      return album.count;
    }
    if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      return album.imageCount ?? 0;
    } else if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
      return album.videoCount ?? 0;
    } else {
      this.error(TAG, `unknown media type: ${filterMediaType}`);
      return album.count;
    }
  }

  /* instrument ignore next */
  private async getSystemAlbumIndexByUri(uri: string, filterMediaType?: string): Promise<number> {
    Log.debug(TAG, 'getSystemAlbumIndexByUri start');
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    let index: number = 0;
    if (!albums) {
      Log.error(TAG, 'getSystemAlbumIndexByUri, albums undefined');
      return -1;
    }
    Log.info(TAG, `getSystemAlbumIndexByUri fetch albums length: ${albums.length}`);
    for (let album of albums) {
      let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
      if (photoCount === 0) {
        Log.debug(TAG, `getSystemAlbumIndexByUri count is 0, mediaType: ${filterMediaType}`);
        continue;
      }
      if (album.albumUri !== uri) {
        index++;
        continue;
      }
      Log.debug(TAG, `getSystemAlbumIndexByUri done, index=${index}`);
      return index;
    }
    Log.debug(TAG, 'getSystemAlbumIndexByUri done');
    return -1;
  }

  protected async getSystemAlbumsCount(albums: PhotoAlbum[], filterMediaType?: string, blackUriList?: string[]):
    Promise<number> {
    Log.debug(TAG, `getSystemAlbumsCount start filter: ${filterMediaType}, black: ${blackUriList}`);
    let albumCount = 0;
    if (!albums) {
      Log.error(TAG, 'getSystemAlbumsCount, albums undefined');
    }
    Log.info(TAG, `getSystemAlbumsCount fetch albums length: ${albums.length}`);
    for (let album of albums) {
      let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
      if (photoCount === 0) {
        Log.debug(TAG, `getSystemAlbumsCount count is 0, filterMediaType: ${filterMediaType}`);
        continue;
      }
      if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
        Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
        continue;
      }
      albumCount++;
    }
    Log.info(TAG, `getSystemAlbumsCount done, count = ${albumCount}`);
    return albumCount;
  }

  private async getTrashAlbumInfo(albumArray: AlbumInfo[], start?: number, count?: number, filterMediaType?:
    string, blackUriList?: string[], nameOnly?: boolean): Promise<void> {
    Log.debug(TAG, 'getTrashAlbumInfo start');
    let index: number = 0;
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    if (!album) {
      Log.error(TAG, 'getTrashAlbumInfo, get album undefined');
      return;
    }
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    let photoCount = albumInfo.count;
    let videoCount = album.videoCount ?? 0;

    if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
      Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
      return;
    }
    /*
      当start和count都存在时，判断当前相册的index，只有该index在[start,start+count]之间时，该相册是本次需要获取的相册
    */
    if (start !== undefined && count !== undefined && Number.isFinite(start) && Number.isFinite(count)) {
      index++;
      if (index <= start) {
        return;
      }
      if (index > (start + count)) {
        return;
      }
    }
    albumInfo.setCount(photoCount);
    albumInfo.setVideoCount(videoCount);
    let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
    albumInfo.setAlbumName(albumName);
    albumInfo.setFilterMediaType(filterMediaType ?? '');
    albumInfo.isSystemAlbum = true;
    albumInfo.isTrashAlbum = true;
    albumArray.push(albumInfo);
    Log.debug(TAG, `getTrashAlbumInfo done, albumInfo: ${albumInfo.toString()}, ` +
      `albumArray length: ${albumArray.length}`);
  }

  private async getTrashAlbumByUri(uri: string): Promise<AlbumInfo | undefined> {
    Log.debug(TAG, 'getTrashAlbumByUri start');
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    if (!album) {
      Log.error(TAG, 'getTrashAlbumByUri, get album undefined');
      return undefined;
    }
    if (album.albumUri !== uri || album.count === 0) {
      return undefined;
    }
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    let photoCount = albumInfo.count;
    let videoCount = album.videoCount ?? 0;
    albumInfo.setCount(photoCount);
    albumInfo.setVideoCount(videoCount);
    albumInfo.isSystemAlbum = true;
    let albumName: Resource | string = UserFileManagerAccess.getInstance().getAlbumNameResource(album);
    albumInfo.setAlbumName(albumName);
    albumInfo.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_ALL);
    Log.debug(TAG, `getTrashAlbumByUri done, albumInfo: ${albumInfo.toString()}`);
    return albumInfo;
  }

  private async getTrashAlbumIndexByUri(uri: string, filterMediaType?: string): Promise<number> {
    Log.debug(TAG, 'getTrashAlbumIndexByUri start');
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    let index: number = 0;
    if (!album) {
      Log.error(TAG, 'getTrashAlbumIndexByUri, albums undefined');
      return -1;
    }
    let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
    if (photoCount === 0) {
      Log.warn(TAG, `getTrashAlbumIndexByUri count is 0, mediaType: ${filterMediaType}`);
      return -1;
    }
    if (album.albumUri === uri) {
      return 0;
    }
    Log.debug(TAG, 'getTrashAlbumIndexByUri done');
    return -1;
  }

  private async getTrashAlbumsCount(filterMediaType?: string, blackUriList?: string[]): Promise<number> {
    Log.debug(TAG, 'getTrashAlbumsCount start');
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    if (!album) {
      Log.error(TAG, 'getTrashAlbumsCount, get album undefined');
      return 0;
    }
    let photoCount = this.getItemsCountOfAlbum(album, filterMediaType);
    if (photoCount === 0) {
      Log.warn(TAG, `getTrashAlbumsCount count is 0, mediaType: ${filterMediaType}`);
      return 0;
    }
    if (blackUriList && blackUriList.indexOf(album.albumUri) >= 0) {
      Log.debug(TAG, `Album ${album.albumUri} is in black uri list`);
      return 0;
    }
    Log.debug(TAG, 'getTrashAlbumsCount done, count = 1');
    return 1;
  }

  public async getHiddenAlbumInfo(filterMediaType?: string): Promise<AlbumInfo> {
    Log.info(TAG, 'getHiddenAlbumInfo start');
    const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    if (!context) {
      Log.error(TAG, 'getHiddenAlbumInfo: context is undefined.');
      return new AlbumInfo();
    }
    const accessHelper = PhotoAccessHelperAccess.getInstance();
    let album: PhotoAlbum | undefined = await accessHelper.getHiddenAlbum(context);
    if (!album) {
      Log.error(TAG, 'getHiddenAlbumInfo, get album undefined');
    }
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    albumInfo.setAlbumName($r('app.string.hidden_album'));
    albumInfo.setFilterMediaType(filterMediaType ?? '');
    Log.info(TAG, `getHiddenAlbumInfo done, albumInfo: ${albumInfo.toString()}`);
    return albumInfo;
  }

  /* instrument ignore next */
  private async getCityAlbumInfo(filterMediaType?: string): Promise<AlbumInfo[] | undefined> {
    Log.info(TAG, 'getCityAlbumInfo start');
    const context = AppStorage.get<common.UIAbilityContext>('CityphotosAbilityContext');
    if (!context) {
      Log.error(TAG, 'getHiddenAlbumInfo: context is undefined.');
      return undefined;
    }
    const accessHelper = PhotoAccessHelperAccess.getInstance();
    let albums: PhotoAlbum[] | undefined = await accessHelper.getCityAlbum(context);
    let sourceData: AlbumInfo[] = [];
    if (!albums || albums.length === 0) {
      Log.error(TAG, 'getCityAlbumInfo, get albums undefined');
      return undefined;
    }
    // 批量获取相册封面
    let coverFileIdList: number[] = await Promise.all(albums.map(async (album: PhotoAlbum) => {
      return AlbumDefine.getFileIdFromUri(album.coverUri ?? '') ?? Number.NaN;
    }));
    let requestTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('BatchQueryCityCoverAssets', requestTime);
    let fetchOpt = AlbumDefine.getFileFetchOptByUriList(coverFileIdList);
    let assets: PhotoAsset[] = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
    let assetsMap: HashMap<number, PhotoAsset> = new HashMap<number, PhotoAsset>();
    assets.map((asset: PhotoAsset) => {
      assetsMap.set(Number(asset.get(AlbumDefine.PHOTO_KEYS_FILE_ID)), asset);
    });
    TraceControllerUtils.finishTraceWithTaskId('BatchQueryCityCoverAssets', requestTime);
    Log.info(TAG, `getCityAlbumInfo query coverAssets cost ${Date.now() - requestTime}`);
    // 创建相册信息
    for (let album of albums) {
      let albumInfo: AlbumInfo = new AlbumInfo(album);
      albumInfo.setAlbumName(album.albumName);
      albumInfo.setFilterMediaType(filterMediaType ?? '');
      let photoCount = albumInfo.count;
      albumInfo.setCount(photoCount);
      let coverUri: string = albumInfo.coverUri;
      const coverAsset: PhotoAsset | undefined = assetsMap.get(AlbumDefine.getFileIdFromUri(album.coverUri ?? ''));
      if (coverAsset) {
        let mediaItem: MediaItem = new MediaItem(coverAsset);
        coverUri = ImageUtil.getThumbnailAstcUri(coverUri, mediaItem.path, mediaItem.getDateModified());
      } else {
        coverUri = `${coverUri}?oper=thumbnail&width=0&height=0`;
      }
      albumInfo.setCoverUri(coverUri);
      sourceData.push(albumInfo);
      Log.info(TAG, `getCityAlbumInfo -- ${albumInfo.toString()}`);
    }
    Log.info(TAG, `getCityAlbumInfo done, city album count: ${sourceData.length}`);
    return sourceData;
  }

  public async getMoreAlbums(filterMediaType?: string): Promise<AlbumInfo[]> {
    let sourceData: AlbumInfo[] = [];
    await this.getTrashAlbumInfo(sourceData, undefined, undefined, filterMediaType);
    return sourceData;
  }

  /**
   * 图库清理列表相册，包含视频相册和最近删除相册
   *
   * @returns 清理相册列表
   */
  public async getCleanupAlbum(): Promise<AlbumInfo[]> {
    let cleanupData: AlbumInfo[] = [];
    const videoAlbumInfo = await this.getVideoAlbum();
    let videoAlbumAssetInfo: AlbumAssetInfo = await videoAlbumInfo.getAlbumAssetInfo(Constants.VIDEO_CLEANUP_PAGE);
    videoAlbumInfo.setAlbumName($r('app.string.video_cleanup'))
    videoAlbumInfo.setAlbumLocalAssetCount(videoAlbumAssetInfo.albumLocalAssetCount);
    videoAlbumInfo.setAlbumLocalAssetSize(videoAlbumAssetInfo.albumLocalAssetSize);
    Log.info(TAG, `getCleanupAlbum: videoAlbumAssetInfo=${videoAlbumAssetInfo.toString()}`);
    cleanupData.push(videoAlbumInfo);

    const screenshotAlbumInfo = await this.getScreenshotAlbum();
    let screenshotAlbumAssetInfo: AlbumAssetInfo =
      await screenshotAlbumInfo.getAlbumAssetInfo(Constants.IMAGE_CLEANUP_PAGE);
    screenshotAlbumInfo.isScreenShotAlbum = true;
    screenshotAlbumInfo.setAlbumName($r('app.string.screenshot_cleanup'));
    screenshotAlbumInfo.setAlbumLocalAssetCount(screenshotAlbumAssetInfo.albumLocalAssetCount);
    screenshotAlbumInfo.setAlbumLocalAssetSize(screenshotAlbumAssetInfo.albumLocalAssetSize);
    Log.info(TAG,
      `getCleanupAlbum: screenshotAlbumAssetInfo=${screenshotAlbumAssetInfo.toString()}`);
    cleanupData.push(screenshotAlbumInfo);

    const trashAlbumInfo = await this.getTrashAlbum();
    let trashAlbumAssetInfo: AlbumAssetInfo = await trashAlbumInfo.getAlbumAssetInfo();
    trashAlbumInfo.setAlbumLocalAssetCount(trashAlbumAssetInfo.albumLocalAssetCount);
    trashAlbumInfo.setAlbumLocalAssetSize(trashAlbumAssetInfo.albumLocalAssetSize);
    Log.info(TAG, `getCleanupAlbum: trashAlbumAssetInfo=${trashAlbumAssetInfo.toString()}`);
    cleanupData.push(trashAlbumInfo);
    return cleanupData;
  }

  public async getScreenshotAlbum(): Promise<AlbumInfo> {
    let screenshotAlbum: AlbumInfo;
    let photoAlbums: PhotoAlbum[] =
      await UserFileManagerAccess.getInstance().getSystemSourceAlbums(Constants.LPATH_SCREEN_SHOT);
    if (photoAlbums.length > 0) {
      screenshotAlbum = this.getAlbumInfo(photoAlbums[0], photoAlbums[0].count, photoAlbums[0].videoCount ?? 0);
      Log.info(TAG, `getScreenshotAlbum: screenshotAlbum.count=${screenshotAlbum.count}`);
      screenshotAlbum.lpath = Constants.LPATH_SCREEN_SHOT;
    } else {
      screenshotAlbum = new AlbumInfo();
    }
    return screenshotAlbum;
  }

  /**
   * 图片专清列表，包含全部图片、截图图片
   *
   * @returns 清理相册列表
   */
  public async getCleanupPhotoAlbums(): Promise<AlbumInfo[]> {
    let cleanupPhotoAlbums: AlbumInfo[] = [];
    // 获取截屏图片
    const screenshotAlbumInfo = await this.getScreenshotAlbum();
    let screenshotAlbumAssetInfo: AlbumAssetInfo =
      await screenshotAlbumInfo.getAlbumAssetInfo(Constants.IMAGE_CLEANUP_PAGE,
        Constants.IS_FROM_IMAGE_CLEANUP_ENTRY_PAGE);
    screenshotAlbumInfo.isScreenShotAlbum = true;
    screenshotAlbumInfo.setAlbumName($r('app.string.screenshot_photos'));
    screenshotAlbumInfo.setAlbumLocalAssetCount(screenshotAlbumAssetInfo.albumLocalAssetCount);
    screenshotAlbumInfo.setAlbumLocalAssetSize(screenshotAlbumAssetInfo.albumLocalAssetSize);
    screenshotAlbumInfo.setCoverUri(screenshotAlbumAssetInfo.albumFirstAssetUri);
    PreferencesUtil.putSync('screenshot_photos',
      [screenshotAlbumInfo.albumLocalAssetCount.toString(),
        screenshotAlbumInfo.albumLocalAssetSize.toString(),
        screenshotAlbumInfo.coverUri, screenshotAlbumInfo.uri]);
    Log.info(TAG, `getCleanupPhotoAlbums: screenshotAlbumAssetInfo=${screenshotAlbumAssetInfo.toString()}`);
    cleanupPhotoAlbums.push(screenshotAlbumInfo);
    return cleanupPhotoAlbums;
  }

  /**
   * 获取系统图片相册，不包含纯云端图片
   *
   * @returns 系统全部图片
   */
  public async getAllPhotoAlbum(): Promise<AlbumInfo[]> {
    let allPhotoAlbums: AlbumInfo[] = [];
    let photoAlbum = await this.getPhotoAlbum();
    let photoAlbumAssetInfo: AlbumAssetInfo =
      await photoAlbum.getAlbumAssetInfo(Constants.IMAGE_CLEANUP_PAGE, Constants.IS_FROM_IMAGE_CLEANUP_ENTRY_PAGE);
    photoAlbum.setAlbumName($r('app.string.all_photos_title'));
    photoAlbum.setAlbumLocalAssetCount(photoAlbumAssetInfo.albumLocalAssetCount);
    photoAlbum.setAlbumLocalAssetSize(photoAlbumAssetInfo.albumLocalAssetSize);
    photoAlbum.setCoverUri(photoAlbumAssetInfo.albumFirstAssetUri);
    PreferencesUtil.putSync('all_photos_title',
      [photoAlbum.albumLocalAssetCount.toString(),
        photoAlbum.albumLocalAssetSize.toString(), photoAlbum.coverUri, photoAlbum.uri]);
    Log.info(TAG, `getCleanupPhotoAlbums: photoAlbum=${photoAlbum.toString()}`);
    allPhotoAlbums.push(photoAlbum);
    return allPhotoAlbums;
  }

  /* instrument ignore next */
  public async getCityAlbums(filterMediaType?: string): Promise<AlbumInfo[] | undefined> {
    let sourceData: AlbumInfo[] | undefined = await this.getCityAlbumInfo(filterMediaType);
    return sourceData;
  }

  public async getPhotoAlbum(): Promise<AlbumInfo> {
    let album: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    if (!album) {
      Log.error(TAG, 'failed to get photo album');
      return new AlbumInfo();
    }
    return this.getAlbumInfo(album, album.count, 0);
  }

  public async getVideoAlbum(): Promise<AlbumInfo> {
    let album: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
    if (!album) {
      Log.error(TAG, 'failed to get video album');
      return new AlbumInfo();
    }
    return this.getAlbumInfo(album, album.count, album.videoCount ?? 0);
  }

  public async getFavoriteAlbum(): Promise<AlbumInfo> {
    let album: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);
    if (!album) {
      Log.error(TAG, 'failed to get favorite album');
      return new AlbumInfo();
    }
    return this.getAlbumInfo(album, album.count, album.videoCount ?? 0);
  }

  public async getTrashAlbum(): Promise<AlbumInfo> {
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getTrashAlbum();
    if (!album) {
      Log.error(TAG, 'failed to get trash album');
      return new AlbumInfo();
    }
    Log.info(TAG, `getTrashAlbum, count: ${album.count}, videoCount: ${album.videoCount}`);
    return this.getAlbumInfo(album, album.count, album.videoCount ?? 0);
  }

  /* instrument ignore next */
  public async getSystemSourceAlbums(): Promise<AlbumInfo[]> {
    let albumInfos: AlbumInfo[] = [];
    for (let lpath of UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST) {
      let photoAlbums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums(lpath);
      if (photoAlbums.length > 0 && photoAlbums[0].count > 0) {
        let albumInfo = this.getAlbumInfo(photoAlbums[0], photoAlbums[0].count, photoAlbums[0].videoCount ?? 0);
        albumInfo.lpath = lpath;
        albumInfos.push(albumInfo);
      }
    }
    return albumInfos;
  }

  public async buildSortedAlbumInfo(albums:PhotoAlbum[]): Promise<AlbumInfo[]> {
    let result: AlbumInfo[] = [];
    if (!albums || albums.length === 0) {
      Log.error(TAG, 'buildSortedAlbumInfo error: albums is empty!');
      return result;
    }
    let coverFileIdList: number[] = await Promise.all(albums.map(async (album: PhotoAlbum) => {
      return AlbumDefine.getFileIdFromUri(album.coverUri ?? '') ?? Number.NaN;
    }));
    let fetchOpt = AlbumDefine.getFileFetchOptByUriList(coverFileIdList);
    let assets: PhotoAsset[] = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    let assetsMap: HashMap<number, PhotoAsset> = new HashMap<number, PhotoAsset>();
    assets.map((asset: PhotoAsset) => {
      assetsMap.set(Number(asset.get(AlbumDefine.PHOTO_KEYS_FILE_ID)), asset);
    });
    let processedGroups: Set<number> = new Set<number>();
    for (const album of albums) {
      let lpath: string | undefined = album.lpath?.trim();
      let groupIndex: number | undefined = undefined;
      if (groupIndex !== undefined) {
        // 融合相册处理
        if (processedGroups.has(groupIndex)) {
          // 标记该分组已处理
          continue;
        }
        processedGroups.add(groupIndex);
      } else {
        if (album.lpath === SHARE_ALBUM_LPATH) {
          AlbumGridSortHelper.getInstance().setShareAlbumUri(album.albumUri);
        }
        // 非融合相册
        let albumInfo: AlbumInfo = new AlbumInfo(album);
        albumInfo.setVideoCount(album.videoCount ?? 0);
        albumInfo.setCount(album.count);
        if (album?.count === 0) {
          // 空相册无需进行相册封面资产加载的兜底方案
          result.push(albumInfo);
          continue;
        }
        let startTime: number = Date.now();
        let coverAsset: PhotoAsset | undefined =
          assetsMap.get(AlbumDefine.getFileIdFromUri(albumInfo.coverUri ?? ''));
        // 如果封面存在直接使用即可
        if (coverAsset) {
          this.setAlbumCover(albumInfo, coverAsset);
          Log.info(TAG, `setAlbumCover from cover finished, cost time: ${Date.now() - startTime}}`);
        } else {
          // 如果封面不存在，默认使用该相册下的第一张
          let firstItem: PhotoAsset | undefined = await UserFileManagerAccess.getInstance().getAlbumFirstObject(album);
          if (firstItem) {
            this.setAlbumCover(albumInfo, firstItem);
            Log.info(TAG, `setAlbumCover from all finished, cost time: ${Date.now() - startTime}}`);
          } else {
            Log.error(TAG, `setAlbumCover from all items failed, cost time = ${Date.now() - startTime}`);
          }
        }
        Log.info(TAG, `getAlbumInfo: ${albumInfo?.toString()}`);
        result.push(albumInfo);
      }
    }
    return result;
  }
}