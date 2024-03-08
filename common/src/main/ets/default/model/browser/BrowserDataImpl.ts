/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import type { BrowserDataInterface } from '../../interface/BrowserDataInterface';
import { AlbumDefine } from './AlbumDefine';
import { Log } from '../../utils/Log';
import type { FileAsset, FileAssetEx } from '../../access/UserFileManagerAccess';
import { Album, UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import type { AsyncCallback } from '../common/AsyncCallback';
import { Constants } from '../common/Constants';

const TAG: string = 'BrowserDataImpl';

export type QueryParam = {
  albumUri: string,
  start: number,
  count: number,
  filterMediaType?: string
};

export abstract class BrowserDataImpl implements BrowserDataInterface {
  static readonly THUMBNAIL_WIDTH = 256;

  abstract getData(callback: AsyncCallback<unknown> | Function, param: QueryParam): void;

  abstract getDataCount(callback: AsyncCallback<unknown> | Function, param: unknown): void;

  abstract getDataByUri(uri: unknown): unknown;

  abstract getDataByName(name: string, albumUri: string): unknown;

  abstract getDataIndexByUri(callback: AsyncCallback<unknown> | Function, param: QueryParam, uri: string): void;

  abstract getMediaItemByUri(callback: AsyncCallback<unknown> | Function, uri: string): void;

  async getAllObject(fetchOpt): Promise<Array<FileAsset>> {
    Log.debug(TAG, `getAllObject ${fetchOpt}`);
    let allObject = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    return allObject;
  }

  async getCount(fetchOpt): Promise<number> {
    let count = await UserFileManagerAccess.getInstance().getCount(fetchOpt);
    return count;
  }

  async getFirstObject(fetchOpt): Promise<FileAssetEx> {
    Log.debug(TAG, 'getFirstObject');
    let firstObject: FileAssetEx = await UserFileManagerAccess.getInstance().getFirstObject(fetchOpt);
    return firstObject;
  }

  async getObject(fetchOpt): Promise<FileAsset> {
    Log.debug(TAG, 'getFirstObject');
    let object: FileAsset = await UserFileManagerAccess.getInstance().getObject(fetchOpt);
    return object;
  }

  async getItems(albumUri?: string, startIndex?: number, count?: number, filterMediaType?: string): Promise<Array<FileAsset>> {
    let result: Array<FileAsset> = null;

    // albumUri不为空，则从目标相册中获取；否则默认从所有媒体资源中获取
    if (albumUri) {
      let album: Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      if (album) {
        let fetchResult = await album.getPhotoAssets(fetchOpt);
        result = await fetchResult.getAllObject();
        fetchResult.close();
      }
    } else {
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      Log.debug(TAG, `getMediaItem start ${JSON.stringify(fetchOpt)}`);
      result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    }
    return result;
  }

  async getItemsCountOfAlbum(album: Album, filterMediaType?: string): Promise<number> {
    let count = 0;
    // 当前相册count始终为0，先通过查全部图片获取count
    let fetchOpt = AlbumDefine.getFileFetchOptWithEmptyColumn(Constants.INVALID, Constants.INVALID, filterMediaType);
    let fetchResult = await album.getPhotoAssets(fetchOpt);
    count = fetchResult.getCount();
    fetchResult.close();
    return count;
  }

  async getItemsCount(albumUri?: string, filterMediaType?: string): Promise<number> {
    let count = 0;
    if (albumUri) {
      let album: Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      // 当前相册count始终为0，先通过查全部图片获取count
      let fetchOpt = AlbumDefine.getFileFetchOpt(Constants.INVALID, Constants.INVALID, filterMediaType);
      let fetchResult = await album.getPhotoAssets(fetchOpt);
      count = fetchResult.getCount();
      fetchResult.close();
    } else {
      let fetchOpt = AlbumDefine.getFileFetchOpt(undefined, undefined, filterMediaType);
      count = await this.getCount(fetchOpt);
    }
    return count;
  }

  async getItemIndexByUri(uri: string, albumUri?: string): Promise<number> {
    let index: number = Constants.INVALID;
    let realUri: string = uri;
    let realAlbumUri: string = albumUri;
    let allObject: Array<FileAsset> = null;
    Log.debug(TAG, `getItemIndexByUri uri: ${uri}, albumUri: ${albumUri}`);
    if (!uri.startsWith(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS)) {
      let targetObject: FileAsset = await this.getItemByUri(uri);
      if (targetObject) {
        Log.debug(TAG, `find photo for uri: ${realUri}=>${targetObject.uri}`);
        realUri = targetObject.uri;
      }
    }
    Log.debug(TAG, `getItemIndexByUri real uri: ${realUri}`);
    if (albumUri && albumUri.length > 0) {
      if (!albumUri.startsWith(UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS)) {
        let targetAlbum: Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
        if (targetAlbum) {
          Log.debug(TAG, `find album for uri: ${realAlbumUri}=>${targetAlbum.albumUri}`);
          realAlbumUri = targetAlbum.albumUri;
        }
      }
    } else {
      realAlbumUri = "";
    }
    Log.debug(TAG, `getItemIndexByUri real album uri: ${realAlbumUri}`);
    allObject = await this.getItems(realAlbumUri);
    if (allObject) {
      Log.debug(TAG, `getItemIndexByUri count: ${allObject.length}`);
      index = allObject.findIndex((item: FileAsset) => item.uri == realUri);
    }
    return index;
  }

  async getItemByUri(uri: string): Promise<FileAsset> {
    let object: FileAsset = null;
    let fetchOpt = AlbumDefine.getFileFetchOptByUri(uri);
    object = await this.getObject(fetchOpt);
    return object;
  }

  getThumbnailSafe(sourceUri: string, path: string, size?): string {
    try {
      if (size) {
        if (size.width != 0 && size.height != 0) {
          return `${sourceUri}?oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
        } else {
          Log.warn(TAG, 'getThumbnailSafe with width==0 and height==0, so do not use thumbnail' + JSON.stringify(size));
          return `${sourceUri}`;
        }
      } else {
        return `${sourceUri}?oper=thumbnail&width=${BrowserDataImpl.THUMBNAIL_WIDTH}&height=${BrowserDataImpl.THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}`);
      return null;
    }
  }
}