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
import type { BrowserDataInterface, QueryParam } from '../../interface/BrowserDataInterface';
import lazy { FilterConditions } from '../../model/FilterConditions';
import lazy { FetchType } from '../../interface/BrowserDataInterface';
import lazy { AlbumDefine } from './AlbumDefine';
import type { FetchOptions, FileAssetEx, PhotoAlbum, PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import type { AsyncCallback, TBrowser } from '../common/AsyncCallback';
import lazy { Constants } from '../common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { LogExtender } from '@ohos/tools/src/main/utils/LogExtender';
import lazy { Size } from '@kit.ArkUI';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { TimeLineModelManager } from '../../view/TimeLineModelManager';
import lazy { PhotoAccessHelperAccess } from '../../access/PhotoAccessHelperAccess';
import lazy { SelectConstants, SelectParams } from '../common/SelectParams';
import lazy { Log } from '../../utils/Log';
import lazy { AlbumGridSortHelper, SortRuleString } from '../AlbumGridSortHelper';
import lazy { MediaItem } from '../browser/photo/MediaItem';

const TAG: string = 'BrowserDataImpl';

export abstract class BrowserDataImpl extends LogExtender implements BrowserDataInterface {
  public static readonly THUMBNAIL_WIDTH = 256;

  abstract getData(callback?: AsyncCallback | Function, param?: QueryParam | undefined): void;

  abstract getDataCount(callback: AsyncCallback | Function, param: QueryParam): void;

  abstract getDataByUri(uri: string): Promise<TBrowser.MayVoid>;

  abstract getDataByName(name: string, albumUri: string): Promise<TBrowser.MayVoid>;

  abstract getDataIndexByUri(callback: AsyncCallback | Function, param: QueryParam, uri: string): void;

  abstract getMediaItemByUri(callback: AsyncCallback | Function, uri: string): void;

  public async getDataByBurstKey(burstKey: string, start: number, count: number, isDesc: boolean, isTrash?: boolean):
    Promise<MediaItem[]> {
    if (!burstKey) {
      Log.info(TAG, 'burstKey is empty');
      return [];
    }
    try {
      let result: PhotoAsset[] = [];
      const fetchOpt: FetchOptions = AlbumDefine.getBurstPhotosFetchOpt(start, count, isDesc, isTrash);
      result = await UserFileManagerAccess.getInstance().getBurstPhotosObject(burstKey, fetchOpt);
      return result.map(item => new MediaItem(item));
    } catch (error) {
      this.error(TAG, 'getDataByBurstKey error');
      return [];
    }
  }

  public async checkMediaItemsInDataSource(selectedUris: string[], albumUris: string[]): Promise<string[]> {
    Log.info(TAG, 'checkMediaItemsInDataSource');
    return [];
	}

  public async getUnFavorCount(albumUri?: string): Promise<number> {
    return 0;
  }

  public async getCurrentAlbum(albumUri: string): Promise<photoAccessHelper.Album | undefined> {
    const album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    return album;
  }

  public async getItems(query?: QueryParam): Promise<PhotoAsset[]> {
    let result: PhotoAsset[] = [];
    let fetchOpt: FetchOptions = this.getFetchOpt(query as QueryParam);
    // albumUri不为空，则从目标相册中获取；否则默认从所有媒体资源中获取
    if (query?.albumUri) {
      let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(query.albumUri);
      this.info(TAG, `getItems album fetchOpt ${JSON.stringify(fetchOpt)}, album : ${JSON.stringify(album)}`);
      if (album) {
        let requestTime: number = Date.now();
        let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
        try {
          TraceControllerUtils.startTraceWithTaskId('browserDataImpl-getAllObject', requestTime);
          fetchResult = await album.getAssets(fetchOpt);
          result = await fetchResult.getAllObjects();
          TraceControllerUtils.finishTraceWithTaskId('browserDataImpl-getAllObject', requestTime);
        } catch (err) {
          Log.error(TAG, `Failed to get items, error: ${err?.code}, ${err?.message}`);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      }
    } else {
      this.debug(TAG, `getItems album null start ${JSON.stringify(fetchOpt)}`);
      result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
    }
    this.info(TAG,
      `getItems result : ${result.length},start: ${query?.start},count: ${query?.count},startTime: ${query?.startTime},`);
    return result;
  }

  public getFetchOpt(query: QueryParam): FetchOptions {
    const fetchType: FetchType | undefined = query.fetchType;
    const startIndex: number | undefined = query.start;
    const count: number | undefined = query.count;
    const filterMediaType: string | undefined = query.filterMediaType;
    const orderby: string | undefined = query.orderBy;
    let fetchOpt: FetchOptions;
    if (query.albumUri) {
      if (UserFileManagerAccess.isRecycleBin(query.albumUri)) {
        if (fetchType === FetchType.EMPTY) {
          fetchOpt = AlbumDefine.getTrashFetchOptWithEmptyColumn(startIndex, count, filterMediaType);
        } else if (fetchType === FetchType.DATE_INFO) {
          fetchOpt = AlbumDefine.getTrashFetchOptWithDateColumn(startIndex, count, filterMediaType);
        } else {
          fetchOpt = AlbumDefine.getTrashFetchOpt(startIndex, count, filterMediaType);
        }
      } else {
        let orderProp: string = AlbumGridSortHelper.getOrderPropByAlbumUri(query.albumUri, query.albumKey);
        let isAsc: boolean =
          AlbumGridSortHelper.getInstance().getSortRule('getFetchOpt', query.albumKey ?? '').type ===
          SortRuleString.ASC;
        if (orderby === UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()) {
          orderProp = orderby;
          isAsc = false;
        }
        if (fetchType === FetchType.EMPTY) {
          fetchOpt = AlbumDefine.getFileFetchOptWithEmptyColumn(startIndex, count, filterMediaType, orderProp, isAsc);
        } else if (fetchType === FetchType.DATE_INFO) {
          fetchOpt = AlbumDefine.getFileFetchOptWithDateColumn(startIndex, count, filterMediaType, orderProp);
        } else {
          fetchOpt =
            AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType, false, orderProp, undefined, isAsc);
        }
      }
    } else {
      // 宫格页 isOrderByDateTaken === true
      const orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS;
      if (fetchType === FetchType.EMPTY) {
        fetchOpt = AlbumDefine.getFileFetchOptWithEmptyColumn(startIndex, count, filterMediaType, orderProp);
      } else if (fetchType === FetchType.DATE_INFO) {
        fetchOpt = AlbumDefine.getFileFetchOptWithDateColumn(startIndex, count, filterMediaType, orderProp);
      } else {
        fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType,
          query.needThumbnailReady, orderProp, query.fileIds);
      }
    }
    this.info(TAG,
      `getFetchOpt startIndex: ${startIndex},count: ${count},filterMediaType: ${filterMediaType}`);
    return fetchOpt;
  }

  public async getItemsCount(albumUri?: string, filterMediaType?: string, needThumbnailReady?: boolean,
    storage?: LocalStorage, filterConditions?: FilterConditions): Promise<number> {

    let userId = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      this.info(TAG, `getItemsCount userId:${userId}`);
    }
    TraceControllerUtils.startTrace(`getItemsCount album:${albumUri}`);
    this.info(TAG, `query medialibrary getItemsCount start albumUri:${albumUri}, filterMediaType: ${filterMediaType}, filter: ${JSON.stringify(filterConditions)}`);
    let count = 0;
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance(storage).getAlbumByUri(albumUri);
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let cameraShotKey = AppStorage.get<string>('cameraShotKey');
      if (!cameraShotKey && album) {
        if (!filterMediaType && !filterConditions) {
          TraceControllerUtils.finishTrace(`getItemsCount album:${albumUri}`);
          return album.count;
        }
        // 当前相册count始终为0，先通过查全部图片获取count
        let fetchOpt = AlbumDefine.getFileFetchOpt(Constants.INVALID, Constants.INVALID, filterMediaType);
        if (userId > 0) {
          fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
          fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
        }
        AlbumDefine.setFilterConditions(fetchOpt, filterConditions);
        fetchResult = await album.getAssets(fetchOpt);
        count = fetchResult.getCount();
      } else {
        let fetchOpt = AlbumDefine.getFileFetchOpt(undefined, undefined, filterMediaType, needThumbnailReady);
        if (userId > 0) {
          this.info(TAG, 'medialibrary getItemsCount userId:' + userId);
          fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
          fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
        }
        AlbumDefine.setFilterConditions(fetchOpt, filterConditions);
        count = await UserFileManagerAccess.getInstance(storage).getCount(fetchOpt, TAG);
        this.info(TAG, 'medialibrary getItemsCount end' + count);
      }
      this.info(TAG, 'query medialibrary getItemsCount end');
    } catch (err) {
      this.error(TAG, `Failed to get items Count, error: ${err?.code}, ${err?.message}`);
    } finally {
      fetchResult?.close();
      this.info(TAG, `fetchResult is close.`);
    }
    TraceControllerUtils.finishTrace(`getItemsCount album:${albumUri}`);
    return count;
  }

  /* instrument ignore next */
  public async getItemIndexByUri(uri: string, albumUri?: string, filterMediaType?: string,
    orderProp?: string, isFromCard: boolean = false): Promise<number> {
    let index: number = Constants.INVALID;
    let realUri: string = uri;
    let realAlbumUri: string = albumUri as string;
    let orderProperty: string | undefined = orderProp;
    this.debug(TAG, `getItemIndexByUri uri: ${uri}, albumUri: ${albumUri}, filterMediaType: ${filterMediaType}`);
    if (!uri.startsWith(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS)) {
      let targetObject: PhotoAsset = await UserFileManagerAccess.getPhotoByUri(uri);
      if (targetObject) {
        this.debug(TAG, `find photo for uri: ${realUri}=>${targetObject.uri}`);
        realUri = targetObject.uri;
      }
    }
    this.debug(TAG, `getItemIndexByUri real uri: ${realUri}`);
    if (albumUri?.length) {
      if (!albumUri.startsWith(UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS)) {
        let targetAlbum: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
        if (targetAlbum) {
          this.debug(TAG, `find album for uri: ${realAlbumUri}=>${targetAlbum.albumUri}`);
          realAlbumUri = targetAlbum.albumUri;
          orderProperty = AlbumGridSortHelper.getAlbumKeyByPhotoAlbum(targetAlbum);
        }
      }
    } else {
      realAlbumUri = '';
    }
    this.debug(TAG, `getItemIndexByUri real album uri: ${realAlbumUri}`);
    index = await UserFileManagerAccess.getInstance().getPhotoIndexByUri(realUri, realAlbumUri, filterMediaType,
      orderProperty, undefined, isFromCard, this.applyFilterConditions());
    this.info(TAG, `getItemIndexByUri index: ${index}`);

    return index;
  }

  protected applyFilterConditions(conditions?: FilterConditions): FilterConditions | undefined {
    return undefined;
  }

  public getThumbnailSafe(sourceUri: string, path: string, modifiedDate: number, size?: Size): string {
    let isOpenYearMonth: boolean =
      AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine() ?? false;
    this.debug(TAG, `getThumbnailSafe sourceUri: ${
    sourceUri}, path: ${path}, modifiedDate: ${modifiedDate}, size: ${JSON.stringify(size)}`);
    try {
      if (size) {
        if (size.width === 0 || size.height === 0) {
          this.warn(TAG, `getThumbnailSafe with width==0 and height==0, sourceUri: ${sourceUri}}, size: ${
          JSON.stringify(size)}`);
        }
        if ((isOpenYearMonth && !DeviceInfo.isPc() && size.width === BrowserDataImpl.THUMBNAIL_WIDTH &&
          size.height === BrowserDataImpl.THUMBNAIL_WIDTH) || ImageUtil.isExitTransparentChannelImg(sourceUri)) {
          return `${sourceUri}?timestampApp=${
          modifiedDate}&oper=astc&width=${size.width}&height=${size.height}&path=${path}`;
        }
        return `${sourceUri}?timestampApp=${
        modifiedDate}&oper=astc&width=${size.width}&height=${size.height}&path=${path}`;
      } else {
        if (isOpenYearMonth || ImageUtil.isExitTransparentChannelImg(sourceUri)) {
          return `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=${
          BrowserDataImpl.THUMBNAIL_WIDTH}&height=${BrowserDataImpl.THUMBNAIL_WIDTH}&path=${path}`;
        }
        return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=${
        BrowserDataImpl.THUMBNAIL_WIDTH}&height=${BrowserDataImpl.THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      this.warn(TAG, `get Thumbnail Failed! msg:${err}, code: ${err?.code}`);
      return '';
    }
  }

  public getThumbnailUri(sourceUri: string, path: string, modifiedDate: number, thumbnailReady?: number): string {
    let isOpenYearMonth: boolean =
      AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine() ?? false;
    let isPickerPage: boolean = AppStorage.get<boolean>('isPickerPage') ?? false;
    return ImageUtil.getThumbnailUri(sourceUri, path, modifiedDate, isOpenYearMonth, thumbnailReady, isPickerPage);
  }

  public getIsNewApiQuery(): boolean {
    return false;
  }

  // 可获取除隐藏相册外的内容。若 albumUri 为空，则不能够获取到 ”最近删除“ 相册内的内容。
  public async getSinglePhotoAsset(photoUri: string, albumUri?: string,
    fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    if (albumUri) {
      let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      if (album) {
        return await PhotoAccessHelperAccess.getInstance()?.getObject(album, photoUri, fetchColumns);
      }
    }
    return await UserFileManagerAccess.getInstance().getPhotoAssetByUri(photoUri, fetchColumns);
  }
}