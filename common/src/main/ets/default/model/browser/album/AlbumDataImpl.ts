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

import { AlbumDefine } from '../AlbumDefine';
import { AlbumInfo } from './AlbumInfo';
import type { AsyncCallback } from '../../common/AsyncCallback';
import { BrowserDataImpl } from '../BrowserDataImpl';
import type { Album, FetchOptions } from '../../../access/UserFileManagerAccess';
import { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import { Log } from '../../../utils/Log';
import { Constants } from '../../common/Constants';
import { MediaItem } from '../photo/MediaItem';
import { ImageUtil } from '../../../utils/ImageUtil';

const TAG: string = 'common_AlbumDataImpl';

type AlbumInfoEx = {
  relativePath?: string
};

type QueryAlbumParam = {
  filterMediaType?: string;
  uris?: string[]
};

export type InitAlbumParam = {
  deviceId?: string,
  deviceName?: string,
  moreInfo?: boolean
};

export type AlbumSimpleInfo = {
  uris: string[],
  count: number,
  videoCount: number,
};

export class AlbumDataImpl extends BrowserDataImpl {
  private moreInfo: boolean = false;

  constructor(param: InitAlbumParam) {
    super();

    if (param && param.moreInfo) {
      this.moreInfo = param.moreInfo
    }
  }

  getDataByUri(uri: unknown) {
  }

  getData(callback: AsyncCallback<unknown>, param: QueryAlbumParam): void {
    Log.info(TAG, 'load data  getData start : ' + param);
    if (param == null) {
      this.buildAlbums(callback);
    } else if (param?.filterMediaType != undefined) {
      this.buildAlbums(callback, param.filterMediaType);
    } else {
      // 删除相册时，计算图片视频数量
      this.genAlbumsInfo(callback, param.uris);
    }
  }

  async getDataByName(name: string, albumUri?: string): Promise<Album> {
    let albums = await UserFileManagerAccess.getInstance().getUserAlbums(AlbumDefine.getAlbumFetchOptByName(name));
    if (albums && albums.length > 0) {
      let opt: FetchOptions = AlbumDefine.getFileFetchOpt();
      let fileResult = await albums[0].getPhotoAssets(opt);
      if (fileResult == null || fileResult == undefined) {
        Log.warn(TAG, `not valid fileResult`);
        return null;
      }
      let count = fileResult.getCount();
      fileResult.close();
      if (count <= 0) {
        Log.warn(TAG, `Not valid album Name: ${albums[0].albumName}, URI: ${albums[0].albumUri}`);
        return null;
      }
      return albums[0];
    } else {
      return null;
    }
  }

  getDataCount(callback: AsyncCallback<unknown>, albumInfo: AlbumInfo): void {
  }

  getDataIndexByUri(callback: AsyncCallback<unknown>, param: QueryAlbumParam, uri: string): void {
  }

  getDataIndexById(callback: AsyncCallback<unknown>, param: QueryAlbumParam, id: number): void {
  }

  getMediaItemByUri(callback: AsyncCallback<unknown>, uri: string): void {
  }

  private async genAlbumsInfo(cb: AsyncCallback<AlbumSimpleInfo>, uris: string[]): Promise<void> {
    Log.info(TAG, `genAlbumsInfo uris: ${JSON.stringify(uris)}`);
    Log.info(TAG, 'load data  genAlbumsInfo start');

    let res = {
      uris: [],
      count: 0,
      videoCount: 0,
    };

    for (let uri of uris) {
      let objects = await super.getItems(uri, Constants.INVALID, Constants.INVALID);
      Log.info(TAG, `get album objects: uri: ${uri} length: ${objects.length}`);

      res.count += objects.length;
      for (let item of objects) {
        if (item.fileType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
          res.videoCount++;
        }
        res.uris.push(item.uri);
      }
    }

    Log.info(TAG, `genAlbumsInfo done`);
    cb.callback(res);
  }

  private async buildAlbums(callback: AsyncCallback<AlbumInfo[]>, filterMediaType?: string) {
    Log.debug(TAG, `buildAlbums`);
    let sourceData = new Array<AlbumInfo>();
    await this.getSystemAlbumsInfo(sourceData, filterMediaType);
    await this.getUserAlbumsInfo(sourceData, filterMediaType);
    await this.getTrashAlbumInfo(sourceData, filterMediaType);
    callback.callback(sourceData);
  }

  private async getUserAlbumsInfo(albumArray: Array<AlbumInfo>, filterMediaType?: string): Promise<void> {
    Log.info(TAG, 'getUserAlbumsInfo start');
    let albums: Album[] = await UserFileManagerAccess.getInstance().getUserAlbums();
    if (!albums) {
      Log.error(TAG, 'getUserAlbumsInfo, albums undefined');
    }
    Log.info(TAG, `getUserAlbumsInfo fetch albums length : ${albums.length}`);
    try {
      for (let album of albums) {
        let albumInfo: AlbumInfo = new AlbumInfo(album);
        let albumName: string = await UserFileManagerAccess.getInstance().getAlbumName(album);
        albumInfo.setAlbumName(albumName);
        albumInfo.setFilterMediaType(filterMediaType as string);
        let count = albumInfo.count;
        albumInfo.setCount(count); // Waiting: album.count不为0时，在构造函数里直接获取
        let videoCount = 0;
        if (count > 0) {
          // 没有相册，设置为第一张
          let hasCoverUri: Boolean = false;
          if (album.coverUri) {
            await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri)).then((obj) => {
              if (obj && obj.obj) {
                let mediaItem = new MediaItem(obj.obj);
                mediaItem.setThumbnail(this.getThumbnailSafe(obj.obj.uri, String(obj.obj.get(Constants.KEY_FILE_DATA))));
                albumInfo.setMediaItem(mediaItem);
                albumInfo.setCoverUri(ImageUtil.calcThumbnail(obj.obj.uri, mediaItem.height, mediaItem.width));
                hasCoverUri = true;
              }
            });
          }
          if (!hasCoverUri) {
            await UserFileManagerAccess.getInstance().getAlbumFirstObject(album).then((obj) => {
              if (obj) {
                let mediaItem = new MediaItem(obj);
                mediaItem.setThumbnail(this.getThumbnailSafe(obj.uri, String(obj.get(Constants.KEY_FILE_DATA))));
                albumInfo.setMediaItem(mediaItem);
                albumInfo.setCoverUri(ImageUtil.calcThumbnail(obj.uri, mediaItem.height, mediaItem.width));
              }
            });
          }
          // 相册的视频数量
          videoCount = await this.getItemsCountOfAlbum(album, AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
        }
        albumInfo.setVideoCount(videoCount);
        albumArray.push(albumInfo);
        Log.info(TAG, `getUserAlbumsInfo done, albumInfo : ${JSON.stringify(albumInfo)}, albumArray length: ${albumArray.length}`);
      }
    } catch (error) {
      Log.error(TAG, `getUserAlbumsInfo error occured: ${error}`);
    }
    Log.info(TAG, 'getUserAlbumsInfo done');
  }

  private async getSystemAlbumsInfo(albumArray: Array<AlbumInfo>, filterMediaType?: string): Promise<void> {
    Log.debug(TAG, 'getSystemAlbumsInfo');

    let albums: Album[] = await UserFileManagerAccess.getInstance().getSystemAlbums();
    Log.debug(TAG, `getSystemAlbumsInfo albums is : ${albums}`);

    if (albums) {
      for (let album of albums) {
        Log.info(TAG, `album ${JSON.stringify(album)}`)
        let albumInfo: AlbumInfo = new AlbumInfo(album);
        let count = await this.getItemsCount(album.albumUri);
        // 系统相册为空时不展示
        if (count === 0) {
          continue;
        }
        albumInfo.setCount(count); // TODO album.count不为0时，在构造函数里直接获取
        // 相册的视频数量
        let videoCount = await this.getItemsCount(album.albumUri, AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
        albumInfo.setVideoCount(videoCount);
        let albumName: string = await UserFileManagerAccess.getInstance().getAlbumName(album);
        albumInfo.setAlbumName(albumName);
        albumInfo.setFilterMediaType(filterMediaType);
        if (!album.coverUri) {
          await UserFileManagerAccess.getInstance().getAlbumFirstObject(album).then((obj) => {
            if (obj) {
              let mediaItem = new MediaItem(obj);
              mediaItem.setThumbnail(this.getThumbnailSafe(obj.uri, String(obj.get(Constants.KEY_FILE_DATA))));
              albumInfo.setMediaItem(mediaItem);
              albumInfo.setCoverUri(this.getThumbnailSafe(obj.uri, String(obj.get(Constants.KEY_FILE_DATA))));
            }
          });
        } else {
          await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(album.coverUri)).then((obj) => {
            if (obj) {
              let mediaItem = new MediaItem(obj.obj);
              mediaItem.setThumbnail(this.getThumbnailSafe(obj.obj.uri, String(obj.obj.get(Constants.KEY_FILE_DATA))));
              albumInfo.setMediaItem(mediaItem);
              albumInfo.setCoverUri(this.getThumbnailSafe(obj.obj.uri, String(obj.obj.get(Constants.KEY_FILE_DATA))));
            }
          });
        }
        Log.debug(TAG, `getSystemAlbumsInfo albumInfo is : ${albumInfo}`);
        albumArray.push(albumInfo);
        Log.debug(TAG, `getSystemAlbumsInfo albumArray length is : ${albumArray.length}`);
      }
    } else {
      Log.error(TAG, 'Failed getSystemAlbumsInfo');
    }

    Log.debug(TAG, 'getSystemAlbumsInfo done');
  }

  private async getTrashAlbumInfo(albumArray: Array<AlbumInfo>, filterMediaType?: string): Promise<void> {
    Log.info(TAG, 'getTrashAlbumInfo start');
    let album: Album = await UserFileManagerAccess.getInstance().getTrashAlbum() as Album;
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
    let albumName: string = await UserFileManagerAccess.getInstance().getAlbumName(album) as string;
    albumInfo.setAlbumName(albumName);
    albumInfo.setFilterMediaType(filterMediaType as string);
    albumArray.push(albumInfo);
    Log.info(TAG, `getTrashAlbumInfo done, albumInfo : ${JSON.stringify(albumInfo)}, albumArray length: ${albumArray.length}`);
  }
}