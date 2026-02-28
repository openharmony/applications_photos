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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type common from '@ohos.app.ability.common';
import lazy { Log } from '../utils/Log';
import lazy { AlbumFetchOptionBuilder, FetchOptionBuilder } from '../model/FetchOption';
import lazy { UserFileManagerAccess } from './UserFileManagerAccess';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { ImageUtil } from '../utils/ImageUtil';
import type { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy i18n from '@ohos.i18n';
import lazy { Constants } from '../model/common/Constants';
import lazy { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import type { LatLongRange } from '../utils/MapUtil';
import lazy { AssetHelper } from '../utils/AssetHelper';
import lazy { Size } from '@kit.ArkUI';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { SendablePhotoAlbum } from './SendablePhotoAccessHelper';
import lazy { SelectParams } from '../model/common/SelectParams';
import lazy { AlbumAssetInfo } from '../model/browser/album/AlbumAssetInfo';
import { relationalStore } from '@kit.ArkData';
import { JSON } from '@kit.ArkTS';

const TAG = 'common_PhotoAccessHelperAccess';

const GET_PORTRAIT_FACE_INFO_SQL: string = 'SELECT ' +
  'beauty_bounder_x,' +
  'beauty_bounder_y,' +
  'beauty_bounder_width,' +
  'beauty_bounder_height,' +
  'aesthetics_score,' +
  'tag_id,' +
  'file_id,' +
  'scale_x,' +
  'scale_y,' +
  'scale_width,' +
  'scale_height ' +
  'FROM tab_analysis_image_face WHERE';

export type PhotoAlbum = photoAccessHelper.Album;

export type PhotoAsset = photoAccessHelper.PhotoAsset;

export interface AssetAlbumRelation {
  mapAsset: string,
  albumName: string
}

export interface ICoverAlbum {
  asset: photoAccessHelper.PhotoAsset,
  count: number
}

export const SHARE_ALBUM_LPATH: string = '/Xxx Share';

export interface QueryAlbumParams {
  albumType?: photoAccessHelper.AlbumType,
  albumSubtype?: photoAccessHelper.AlbumSubtype,
  albumUri: string,
  isHiddenSubAlbumQuery?: boolean
  filterMediaType?: string
}

export interface FaceDataInterface extends relationalStore.ValuesBucket {
  beauty_bounder_x: number;
  beauty_bounder_y: number;
  beauty_bounder_width: number;
  beauty_bounder_height: number;
  scale_x: number;
  scale_y: number;
  scale_width: number;
  scale_height: number;
  aesthetics_score: number;
  tag_id: string;
  file_id: number;
}

export interface GroupTagInfo extends relationalStore.ValuesBucket {
  album_id: number;
  group_tag: string;
  tag_id: string;
}

export class PhotoAccessHelperAccess {
  public static readonly FETCH_COLUMNS_LCD_SIZE = 'lcd_size';
  public static readonly FETCH_COLUMNS_THM_SIZE = 'thumb_size';
  public static readonly FETCH_COLUMNS_PHOTO_QUALITY = 'photo_quality';
  public static readonly FETCH_COLUMNS_IS_CE_AUTO = 'is_auto';
  // 存储格式： width:height
  public static readonly FETCH_LCD_THM_SPLIT_SYMBOLS = ':';
  public static readonly QUERY_EXCEED_TIME_FOR_LOG = 500;
  public static thirdSelectPrivacyMap = new Map<number, photoAccessHelper.HideSensitiveType>();
  private static instance: PhotoAccessHelperAccess = new PhotoAccessHelperAccess();

  private constructor() {

  }

  public static getInstance(): PhotoAccessHelperAccess {
    return PhotoAccessHelperAccess.instance;
  }

  public static getPhotoAccessHelper(context: Context): photoAccessHelper.PhotoAccessHelper {
    try {
      let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
      /* instrument ignore if */
      if (userId > 0) {
        return photoAccessHelper.getPhotoAccessHelper(context, userId);
      } else {
        return photoAccessHelper.getPhotoAccessHelper(context);
      }
    } catch (e) {
      /* instrument ignore next */
      return photoAccessHelper.getPhotoAccessHelper(context);
    }
  }

  /* instrument ignore next */
  public static async getHiddenAsset(context: common.Context | undefined, uri: string):
    Promise<PhotoAsset | undefined> {
    if (!context || uri.length <= 0) {
      Log.error(TAG, 'getHiddenAsset invalid param');
      return undefined;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      const album = await PhotoAccessHelperAccess.getInstance().getHiddenAlbum(context);
      fetchResult = await album?.getAssets(new FetchOptionBuilder().photoUri(uri)
        .setColumns([photoAccessHelper.PhotoKeys.FAVORITE, photoAccessHelper.PhotoKeys.POSITION]).getFetchOption());
      let asset: PhotoAsset | undefined = await fetchResult?.getFirstObject();
      if (!asset) {
        Log.error(TAG, 'Failed to get asset from hidden album, asset is null');
      }
      return asset;
    } catch (error) {
      /* instrument ignore next */
      Log.error(TAG, `Failed to get asset from hidden album, error: ${error}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public static getLcdSize(data?: PhotoAsset, uri?: string): Size | undefined {
    if (!data) {
      return undefined;
    }

    let lcdWidth: number = 0;
    let lcdHeight: number = 0;
    let lcdSize: string = String(AssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_LCD_SIZE, ''));
    if (lcdSize.length === 0) {
      Log.warn(TAG, `lcd size is zero, uri:${ImageUtil.encryptThumbnailUri(uri)}`);
      return undefined;
    }

    let lcdSizeArray = lcdSize.split(PhotoAccessHelperAccess.FETCH_LCD_THM_SPLIT_SYMBOLS);
    /* instrument ignore if */
    if (lcdSizeArray.length !== 2) {
      Log.warn(TAG, 'lcdSizeArray.length not 2');
      return undefined;
    }

    lcdWidth = parseInt(lcdSizeArray[0]);
    lcdHeight = parseInt(lcdSizeArray[1]);
    lcdWidth = !Number.isFinite(lcdWidth) ? 0 : lcdWidth;
    lcdHeight = !Number.isFinite(lcdHeight) ? 0 : lcdHeight;
    Log.debug(TAG, `lcdWidth=${lcdWidth}`);
    Log.debug(TAG, `lcdHeight=${lcdHeight}`);
    return { width: lcdWidth, height: lcdHeight };
  }

  public static getThmSize(data?: PhotoAsset, uri?: string): Size | undefined {
    if (!data) {
      return undefined;
    }

    let thmWidth: number = 0;
    let thmHeight: number = 0;
    let thmSize: string = String(AssetHelper.get(data, PhotoAccessHelperAccess.FETCH_COLUMNS_THM_SIZE, ''));
    if (thmSize.length === 0) {
      Log.warn(TAG, `thm size is zero, uri:${ImageUtil.encryptThumbnailUri(uri)}`);
      return undefined;
    }

    let thmSizeArray = thmSize.split(PhotoAccessHelperAccess.FETCH_LCD_THM_SPLIT_SYMBOLS);
    /* instrument ignore if */
    if (thmSizeArray.length !== 2) {
      Log.warn(TAG, 'thmSizeArray.length not 2');
      return undefined;
    }

    thmWidth = parseInt(thmSizeArray[0]);
    thmHeight = parseInt(thmSizeArray[1]);
    thmWidth = !Number.isFinite(thmWidth) ? 0 : thmWidth;
    thmHeight = !Number.isFinite(thmHeight) ? 0 : thmHeight;
    return { width: thmWidth, height: thmHeight };
  }

  // context可以通过LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext'),根据自身的情况确定
  /* instrument ignore next */
  public static async getHiddenAlbums(context: common.Context): Promise<PhotoAlbum[]> {
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      // 增加查询结果列lpath，默认不查询该字段导致后续无法使用（目前api没有对应的枚举类后续api升级可以切换成枚举）
      let systemFetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: ['lpath'],
        predicates: new dataSharePredicates.DataSharePredicates()
      };
      fetchResult =
        await accessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ALBUMS_MODE, systemFetchOption);
      const count = fetchResult.getCount();
      Log.info(TAG, `Hidden album view, album count: ${count}`);
      if (count === 0) {
        return [];
      }
      let albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      let newAlbums: PhotoAlbum[] = albums.filter(item => item?.count > 0);
      return newAlbums;
    } catch (error) {
      Log.error(TAG, `Failed to get albums from hidden album view, error: ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /* instrument ignore next */
  public async getHiddenAlbum(context: common.Context): Promise<PhotoAlbum | undefined> {
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult = await accessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
      const hiddenAlbum: PhotoAlbum = await fetchResult.getFirstObject();
      Log.info(TAG, `getHiddenAlbum : ${hiddenAlbum.albumUri}`);
      return hiddenAlbum;
    } catch (err) {
      Log.error(TAG, `getHiddenAlbum Get Hidden Album exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /* instrument ignore next */
  public async getCityAlbum(context: common.Context): Promise<PhotoAlbum[] | undefined> {
    if (!context) {
      return undefined;
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      // 映射规则：中文、繁体，获取结果为中文，其他语种获取结果为英文
      let language = i18n.System.getSystemLanguage();
      if (language.startsWith(Constants.CHINESE_LANGUAGE) ||
      language.startsWith(Constants.TRADITIONAL_CHINESE_LANGUAGE)) {
        language = Constants.CHINESE_LANGUAGE;
      } else {
        language = Constants.ENGLISH_LANGUAGE;
      }
      predicates.equalTo('language', language);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      Log.info(TAG, 'get city album start');
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult =
        await accessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, Constants.CITY_QUERY_SUB_TYPE, fetchOptions);
      const cityAlbum: PhotoAlbum[] = await fetchResult.getAllObjects();
      Log.info(TAG, `getCityAlbum : ${cityAlbum.length}`);
      return cityAlbum;
    } catch (err) {
      Log.error(TAG, `getCityAlbum Get City Album exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public async setCustomAlbumCover(context: common.Context, albumInfo: AlbumInfo | undefined,
    coverUri: string): Promise<boolean> {
    Log.info(TAG, ` albumInfo ` + albumInfo + `coverUri :` + coverUri)
    if (albumInfo === undefined || coverUri === undefined) {
      Log.info(TAG, `input params undefined`)
      return false;
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      let album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumInfo.uri);
      if (album === undefined) {
        Log.info(TAG, `album undefined`)
        return false;
      }
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(album);
      albumChangeRequest.setCoverUri(coverUri);
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      await accessHelper.applyChanges(albumChangeRequest);
      Log.info(TAG, `set cover finish`)
      return true;
    } catch (err) {
      Log.error(TAG, `setCustomAlbumCover exception! msg:  ${err}, code: ${err?.code}`);
      return false;
    } finally {
      accessHelper?.release()
      Log.info(TAG, `setCustomAlbumCover finish`)
    }
  }

  public async resetCustomAlbumCover(context: common.Context, albumInfo: AlbumInfo | undefined): Promise<boolean> {
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    if (albumInfo === undefined) {
      Log.info(TAG, `input params undefined`)
      return false;
    }
    try {
      let album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumInfo.uri);
      if (album === undefined) {
        Log.info(TAG, `album undefined`)
        return false;
      }
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(album);
      albumChangeRequest.resetCoverUri();
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      await accessHelper?.applyChanges(albumChangeRequest);
      Log.info(TAG, `reset cover finish`)
      return true;
    } catch (err) {
      Log.error(TAG, `resetCustomAlbumCover exception! msg:  ${err}, code: ${err?.code}`);
      return false;
    } finally {
      accessHelper?.release();
      Log.info(TAG, `resetCustomAlbumCover finish`)
    }
  }

  /* instrument ignore next */
  public async getHiddenPhotoAssetByUrl(context: common.Context, uri: string): Promise<PhotoAsset[] | undefined> {
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let album = await PhotoAccessHelperAccess.getAlbumByUri(context, {
        albumUri: uri,
        isHiddenSubAlbumQuery: true,
      });
      fetchResult = await album?.getAssets({
        fetchColumns: [],
        predicates: new dataSharePredicates.DataSharePredicates(),
      });
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      const assets: PhotoAsset[] | undefined = await fetchResult?.getAllObjects();
      return assets;
    } catch (error) {
      Log.error(TAG, `deleteAlbumByUri error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /* instrument ignore next */
  public static async getAlbumAssetInfo(album: PhotoAlbum, fromAlbum?: string,
    fromEntry?: string): Promise<AlbumAssetInfo> {
    let albumAssetInfo: AlbumAssetInfo = new AlbumAssetInfo();
    if (album === undefined) {
      return albumAssetInfo;
    }
    let predicates = new dataSharePredicates.DataSharePredicates;
    if (fromAlbum === Constants.VIDEO_CLEANUP_PAGE) {
      predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, UserFileManagerAccess.MEDIA_TYPE_VIDEO);
      predicates.and();
    } else if (fromAlbum === Constants.IMAGE_CLEANUP_PAGE) { // 最近删除页面包括视频和图片
      predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, UserFileManagerAccess.MEDIA_TYPE_IMAGE);
      predicates.and();
    }
    predicates.beginWrap();
    predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, UserFileManagerAccess.FILE_LOCATION_LOCAL);
    predicates.or();
    predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION, UserFileManagerAccess.FILE_LOCATION_LOCAL_CLOUD);
    predicates.endWrap();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: ['count(*)', 'sum(size)'],
      predicates: predicates,
    };
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    let albumAssetResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let startTime: number = Date.now();
      albumFetchResult = await album.getAssets(fetchOptions);
      if (!albumFetchResult || albumFetchResult.getCount() === 0) {
        return albumAssetInfo;
      }
      const assets = await albumFetchResult.getFirstObject();
      let count: number = assets?.get('count(*)') as number;
      let size: number = assets?.get('sum(size)') as number;
      albumAssetInfo.albumLocalAssetCount = count;
      albumAssetInfo.albumLocalAssetSize = size;
      Log.info(TAG, `getAlbumAssetInfo finished! count=${count},size=${size},cost time: ${Date.now() - startTime}`);

      // 图片专清中封面需要查询首个图片的Uri
      if (fromAlbum === Constants.IMAGE_CLEANUP_PAGE && fromEntry === Constants.IS_FROM_IMAGE_CLEANUP_ENTRY_PAGE) {
        // 相册页“图片”“视频”相册按照保存时间dateAdded倒序显示，非“图片”“视频”相册按照拍摄时间dateTaken倒序显示
        predicates.orderByDesc(PhotoAccessHelperAccess.isPhotoAlbum(album) ?
          UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString() :
          UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString())
        predicates.limit(1, 0);
        let uriFetchOptions: photoAccessHelper.FetchOptions = {
          fetchColumns: [photoAccessHelper.PhotoKeys.URI.toString()],
          predicates: predicates,
        };

        let getUriStartTime: number = Date.now();
        albumAssetResult = await album.getAssets(uriFetchOptions);
        if (!albumAssetResult || albumAssetResult.getCount() === 0) {
          return albumAssetInfo;
        }
        const assets = await albumAssetResult.getFirstObject();
        let albumFirstAssetUri: string = assets?.get(photoAccessHelper.PhotoKeys.URI) as string;
        albumAssetInfo.albumFirstAssetUri = albumFirstAssetUri;
        Log.info(TAG, `getAlbumAssetInfo finished! albumFirstAssetUri=${albumFirstAssetUri},cost time: ${Date.now() -
          getUriStartTime}`);
      }
    } catch (error) {
      Log.error(TAG, `getAlbumAssetInfo error: ${error}`);
      return albumAssetInfo;
    } finally {
      albumFetchResult?.close();
      albumAssetResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
    return albumAssetInfo;
  }

  /* instrument ignore next */
  public async deleteHiddenAlbums(context: common.Context | undefined, uris: string[]): Promise<void> {
    if (!context) {
      Log.error(TAG, 'deleteHiddenAlbums error: context is undefined');
      return;
    }
    try {
      await photoAccessHelper.MediaAssetChangeRequest.deleteAssets(context, uris);
    } catch (error) {
      Log.error(TAG, `deleteAlbumByUri error: ${error}, code: ${error?.code}`);
    }
  }

  /* instrument ignore next */
  public async cancelHiddenAlbum(context: common.Context, uri: string): Promise<void> {
    try {
      const assets: PhotoAsset[] | undefined = await this.getHiddenPhotoAssetByUrl(context, uri);
      await Promise.all((assets ?? []).map(asset => asset.setHidden(false)));
    } catch (error) {
      Log.error(TAG, `deleteAlbumByUri error: ${error}, code: ${error?.code}`);
    }
  }

  /**
   * seek media library album object
   * @param context 上下文
   * @param album 排序相册
   * @returns media library album object
   */
  /* instrument ignore next */
  public static async getMediaLibraryAlbum(context: common.Context, album: AlbumInfo, isPortrait: boolean):
    Promise<photoAccessHelper.Album | undefined> {
    if (!context) {
      return undefined;
    }
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    let fetchMediaHandlerAlbum: photoAccessHelper.Album | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(isPortrait ? photoAccessHelper.AlbumKeys.URI : photoAccessHelper.AlbumKeys.ALBUM_NAME,
        isPortrait ? album.uri : album?.albumName.toString());
      let fetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [],
      };
      fetchResult =
        await phAccessHelper?.getAlbums(isPortrait ? Constants.PORTRAIT_QUERY_TYPE : photoAccessHelper.AlbumType.USER,
          isPortrait ? Constants.PORTRAIT_QUERY_SUB_TYPE : photoAccessHelper.AlbumSubtype.USER_GENERIC, fetchOption);
      fetchMediaHandlerAlbum = await fetchResult.getFirstObject();
      Log.info(TAG, `get fetch media album : ${AlbumDefine.getAnonymizeAlbumName(fetchMediaHandlerAlbum.albumName)}`);
      return fetchMediaHandlerAlbum;
    } catch (err) {
      Log.info(TAG, `get fetch media album : ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
    return fetchMediaHandlerAlbum;
  }

  // save media library
  /* instrument ignore next */
  public static async saveMediaLibraryHandler(
    context: common.Context, originAlbum?: AlbumInfo, targetAlbum?: AlbumInfo, isPortrait: boolean = false):
    Promise<boolean> {
    if (!originAlbum || !context) {
      return false;
    }
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    try {
      let origin = await PhotoAccessHelperAccess.getMediaLibraryAlbum(context, originAlbum, isPortrait);
      let target: photoAccessHelper.Album | undefined | null;
      if (targetAlbum) {
        target = await PhotoAccessHelperAccess.getMediaLibraryAlbum(context, targetAlbum, isPortrait);
      } else {
        target = null;
      }
      if (!origin) {
        Log.info(TAG, `drag order save media library failed : origin variable is undefined, originalbum uri ${
        originAlbum.uri}`);
        return false;
      }
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(origin);
      albumChangeRequest?.placeBefore(target);
      await phAccessHelper?.applyChanges(albumChangeRequest);
      Log.info(TAG, `drag order save media library success, originAlbumUri: ${
      origin?.albumUri}_targetAlbumUri: ${target?.albumUri}`);
      return true;
    } catch (err) {
      Log.info(TAG, `drag order save media library failed : ${err}, code: ${err?.code}`);
      return false;
    } finally {
      phAccessHelper?.release();
    }
  }

  /* instrument ignore next */
  public static async getPhotoByUri(context: common.Context, uri: string): Promise<PhotoAsset | undefined> {
    if (!uri) {
      return undefined;
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult = await accessHelper.getAssets(new FetchOptionBuilder().photoUri(uri).getFetchOption());
      let assets: PhotoAsset = await fetchResult.getFirstObject();
      return assets;
    } catch (err) {
      Log.error(TAG, `getPhotoByUri ---- ${err}`);
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  /* instrument ignore next */
  public static async removeFromClassAlbum(context: common.Context, album: PhotoAlbum |
  undefined, assets: (PhotoAsset | undefined)[]): Promise<void> {
    if (!album || !assets) {
      return;
    }
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    try {
      let albumChangeRequest = new photoAccessHelper.MediaAlbumChangeRequest(album);
      Log.info(TAG, `getPhotoByUrisurisdf: ${albumChangeRequest}`);
      albumChangeRequest.dismissAssets(assets);
      Log.info(TAG, `getPhotoByUrisurisqw: ${album}`);
      await phAccessHelper.applyChanges(albumChangeRequest);
      Log.info(TAG, `getPhotoByUrisurishtf: ${context}`);
    } catch (err) {
      Log.error('applyChanges', `adwad${err}, code: ${err?.code}`);
    } finally {
      phAccessHelper?.release();
    }
  }

  /**
   * seek media library album object
   * @param context 上下文
   * @param batchUris 批量资产
   * @returns PhotoAsset[] 返回资产列表
   */
  /* instrument ignore next */
  public static async getPhotoByUris(context: common.Context, batchUris: PhotoAsset[]):
    Promise<(PhotoAsset | undefined)[]> {
    let assets: (PhotoAsset | undefined)[] = await Promise.all(batchUris.map(
      (asset: PhotoAsset) => PhotoAccessHelperAccess.getPhotoByUri(context, asset.uri)));
    return assets;
  }

  /* instrument ignore next */
  public static async getAlbumByUri(context: common.Context, queryAlbumParams: QueryAlbumParams):
    Promise<PhotoAlbum | undefined> {
    if (!context || !queryAlbumParams) {
      return undefined;
    }
    Log.debug(TAG, `getAlbumByUri albumUri is ${queryAlbumParams.albumUri}`);
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      const albumFetchOpt = new AlbumFetchOptionBuilder().photoAlbumUri(queryAlbumParams.albumUri).build();
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      const isHiddenAlbum = queryAlbumParams.isHiddenSubAlbumQuery || queryAlbumParams.albumSubtype ===
      photoAccessHelper.AlbumSubtype.HIDDEN;
      if (isHiddenAlbum) {
        fetchResult = await accessHelper.getHiddenAlbums(
            queryAlbumParams.isHiddenSubAlbumQuery ? photoAccessHelper.HiddenPhotosDisplayMode.ALBUMS_MODE :
            photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE, albumFetchOpt);
      } else {
        if (!queryAlbumParams.albumType || !queryAlbumParams.albumSubtype) {
          Log.warn(TAG, `getAlbumByUri return null because queryAlbumParams has undefined value, albumType:${
          queryAlbumParams.albumType}, albumSubtype: ${queryAlbumParams.albumSubtype}`);
          return undefined;
        }
        fetchResult =
          await accessHelper.getAlbums(queryAlbumParams.albumType, queryAlbumParams.albumSubtype, albumFetchOpt);
      }
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbumByUri return null');
        return undefined;
      }
      Log.debug(TAG, `getAlbumByUri--- return raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return undefined;
      }
      let album: PhotoAlbum = await fetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, 'getAlbumByUri result is null');
      }
      return album;
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  public static async getSubItemsCount(params: QueryAlbumParams): Promise<number> {
    let count = 0;
    if (!params) {
      return count;
    }
    if (params.albumUri) {
      let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
      try {
        let album: PhotoAlbum | undefined =
          await PhotoAccessHelperAccess.getAlbumByUri(getContext(), {
            albumType: params.albumType,
            albumSubtype: params.albumSubtype,
            albumUri: params.albumUri,
            isHiddenSubAlbumQuery: params.isHiddenSubAlbumQuery,
          });
        if (!album) {
          return count;
        }
        if (!params.filterMediaType && !params.isHiddenSubAlbumQuery) {
          return album.count;
        }
        // 当前相册count始终为0，先通过查全部图片获取count
        let fetchOpt = AlbumDefine.getFileFetchOpt(Constants.INVALID, Constants.INVALID, params.filterMediaType);
        fetchResult = await album.getAssets(fetchOpt);
        count = fetchResult.getCount();
      } catch (err) {
        Log.error(TAG, `getPhotoAssets--- ${err}`);
      } finally {
        fetchResult?.close();
        Log.info(TAG, `fetchResult is close.`);
      }
    } else {
      let fetchOpt = AlbumDefine.getFileFetchOpt(undefined, undefined, params.filterMediaType);
      count = await UserFileManagerAccess.getInstance().getCount(fetchOpt, TAG);
    }
    return count;
  }

  public static isSourceAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === 2049; //2049对应来源相册的 getAlbums 参数中的 albumSubType
  }

  // 人像查询
  public static async getPortraitFavorites(context: common.Context, predicate: dataSharePredicates.DataSharePredicates,
    options?: string): Promise<PhotoAlbum[] | undefined> {
    /* instrument ignore if */
    if (!context || !predicate) {
      return undefined;
    }
    const startTime: number = Date.now();
    Log.info(TAG, `${options} getPortraitFavorites start: ${startTime}`);
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicate,
    };
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult =
        await accessHelper.getAlbums(Constants.PORTRAIT_QUERY_TYPE, Constants.PORTRAIT_QUERY_SUB_TYPE, fetchOptions);
      const count = fetchResult.getCount();
      Log.info(TAG, `${options} getPortraitFavorites album view, album count: ${count}`);
      if (count === 0) {
        return [];
      }
      const albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      if (options === 'selectMe') {
        const getTheFirstThreeObjects = 3;
        return albums?.slice(0, getTheFirstThreeObjects);
      }
      let isCoverUriValid = (item: PhotoAlbum) => {
        /* instrument ignore if */
        if (!item?.coverUri?.trim() || item?.count <= 0) {
          Log.warn(TAG, `album coveruri or count illegal: ${item?.albumUri}, count: ${item?.count}`);
          return false;
        }
        return true;
      };
      return albums.filter(isCoverUriValid);
    } catch (error) {
      /* instrument ignore next */
      Log.error(TAG, `Failed to get albums from portrait album view, error----: ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `${options} getPortraitFavorites end: ${Date.now() - startTime}`);
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  // 人像tagId批量查询
  public static async getGroupTagInfo(context: Context,
    albumIdList: number[]): Promise<Map<number, GroupTagInfo> | undefined> {
    if (!context) {
      return new Map();
    }
    const QUERY = `SELECT album_id, group_tag FROM AnalysisAlbum `;
    let groupTagQuerySql: string = QUERY + `WHERE album_id IN ( ${albumIdList.join(',')} )`;
    const startTime: number = Date.now();
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let resultSet: relationalStore.ResultSet | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      const map: Map<number, GroupTagInfo> = new Map<number, GroupTagInfo>();
      let index: number = 0;
      Log.info(TAG, `getGroupTagInfo count: ${map.size}, cost:${Date.now() - startTime}`);
      return map;
    } catch (error) {
      Log.error(TAG, `getGroupTagInfo, error----: ${error}`);
      return undefined;
    } finally {
      accessHelper?.release();
    }
    return undefined
  }

  // 人像位置信息批量查询
  public static async getPortraitInfos(context: Context,
    fileIdList: number[]): Promise<Map<number, FaceDataInterface[]> | undefined> {
    if (!context) {
      Log.error(TAG, `query portrait face info context is undefined.`);
      return new Map();
    }
    let faceDataSql: string = GET_PORTRAIT_FACE_INFO_SQL + ` file_id IN ( ${fileIdList.join(',')} )`;
    const startTime: number = Date.now();
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let resultSet: relationalStore.ResultSet | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      const faceInfoMap: Map<number, FaceDataInterface[]> = new Map<number, FaceDataInterface[]>();
      let index: number = 0;
      // todo 替换op后报错 先这样解决
      Log.info(TAG, `getPortraitInfos analysisFacesData count: ${faceInfoMap.size}, cost:${Date.now() - startTime}`);
      return faceInfoMap;
    } catch (error) {
      Log.error(TAG, `Failed to get albums from portrait album view, error----: ${error}`);
      return undefined;
    } finally {
      accessHelper?.release();
    }
    return undefined
  }

  // 获取智慧相册中的图片/视频文件数量
  /* instrument ignore next */
  public static async getSmartAlbumMediaTypeCount(album: PhotoAlbum,
    mediaType: photoAccessHelper.PhotoType): Promise<number> {
    let mediaCount: number = 0;
    let predicates = new dataSharePredicates.DataSharePredicates;
    predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, mediaType);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: ['count(*)'],
      predicates: predicates,
    };
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      albumFetchResult = await album.getAssets(fetchOptions);
      if (!albumFetchResult || albumFetchResult.getCount() === 0) {
        return mediaCount;
      }
      const assets = await albumFetchResult.getFirstObject();
      mediaCount = assets?.get('count(*)') as number;
      Log.info(TAG, `getSmartAlbumMediaTypeCount finished! mediaCount = ${mediaCount}`);
    } catch (error) {
      Log.error(TAG, `getSmartAlbumMediaTypeCount error: ${error}`);
      return mediaCount;
    } finally {
      albumFetchResult?.close();
      Log.info(TAG, `albumFetchResult is close.`);
    }
    return mediaCount;
  }

  /* instrument ignore next */
  public static isImage(fileAsset: PhotoAsset): boolean {
    return fileAsset.photoType === photoAccessHelper.PhotoType.IMAGE;
  }

  public static isSystemAlbum(album: PhotoAlbum): boolean {
    return album.albumType === photoAccessHelper.AlbumType.SYSTEM;
  }

  public static isTrashAlbum(album: PhotoAlbum | SendablePhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.TRASH;
  }

  public static isUserAlbum(album: PhotoAlbum): boolean {
    return album.albumType === photoAccessHelper.AlbumType.USER;
  }

  public static isVideoAlbum(album: PhotoAlbum | SendablePhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.VIDEO;
  }

  /* instrument ignore next */
  public static isShareAlbum(album: PhotoAlbum | SendablePhotoAlbum): boolean {
    // return album.lpath === SHARE_ALBUM_LPATH;
    return false
  }

  public static isFavorAlbum(album: PhotoAlbum | SendablePhotoAlbum | undefined): boolean {
    return album?.albumSubtype === photoAccessHelper.AlbumSubtype.FAVORITE;
  }

  public static isCloudEnhanceAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT;
  }

  public static isScreenShotAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.SCREENSHOT;
  }

  public static isPhotoAlbum(album: PhotoAlbum | SendablePhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.IMAGE;
  }

  public static isUserGenericAlbum(album: PhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.USER_GENERIC;
  }

  public static isGroupAlbum(album: PhotoAlbum | SendablePhotoAlbum): boolean {
    return album.albumSubtype === photoAccessHelper.AlbumSubtype.GROUP_PHOTO;
  }

  public static getAlbumNameResource(album: PhotoAlbum): Resource | string {
    if (PhotoAccessHelperAccess.isSystemAlbum(album)) {
      // 系统相册，图库自己命名
      switch (album.albumSubtype) {
        case (photoAccessHelper.AlbumSubtype.IMAGE):
          /* instrument ignore next */
          return $r('app.string.album_photos');
        case photoAccessHelper.AlbumSubtype.FAVORITE:
          /* instrument ignore next */
          return $r('app.string.album_favor');
        case (photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT):
          /* instrument ignore next */
          return $r('app.string.album_cloud_enhance');
        case photoAccessHelper.AlbumSubtype.VIDEO:
          /* instrument ignore next */
          return $r('app.string.album_video');
        case photoAccessHelper.AlbumSubtype.TRASH:
          return $r('app.string.album_recycle');
        default:
        /* instrument ignore next */
          return '';
      }
    }
    // 系统来源相册需要自己命名
    if (album.albumSubtype === UserFileManagerAccess.SOURCE_GENERIC_ALBUM_SUB_TYPE) {
      switch (album.lpath) {
        case Constants.LPATH_CAMERA:
          return $r('app.string.source_camera');
        case Constants.LPATH_SCREEN_SHOT:
          return $r('app.string.source_screenshot');
        case Constants.LPATH_SCREEN_RECORDING:
          return $r('app.string.source_screen_recording')
        default:
          return album.albumName;
      }
    }
    // 用户相册，直接返回
    return album.albumName;
  }

  /* instrument ignore next */
  public static async getAlbumThumbnailUri(album: PhotoAlbum): Promise<string> {
    let thumbnail = '';
    try {
      const photoAsset = await PhotoAccessHelperAccess.getAlbumThumbnail(album);
      if (photoAsset) {
        const width = Number(photoAsset.get(photoAccessHelper.PhotoKeys.WIDTH));
        const height = Number(photoAsset.get(photoAccessHelper.PhotoKeys.HEIGHT));
        thumbnail = ImageUtil.calcThumbnail(photoAsset.uri, height, width);
      }
    } catch (err) {
      Log.error(TAG, `getAlbumCoverPhotoAsset Get photo by uri exception! msg: ${err}`);
    }
    return thumbnail;
  }

  public static async getAlbumThumbnail(album: PhotoAlbum): Promise<PhotoAsset | undefined> {
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let fetchOptionBuilder: FetchOptionBuilder = new FetchOptionBuilder();
      // uri存在查询uri === coverUri的图片，否则查询该相册下第一张图片
      if (album.coverUri) {
        fetchOptionBuilder.photoUri(album.coverUri);
      }
      const fetchOption = fetchOptionBuilder.getFetchOption();
      let startTime: number = Date.now();
      fetchResult = await album.getAssets(fetchOption);
      /* instrument ignore if */
      if (Date.now() - startTime > PhotoAccessHelperAccess.QUERY_EXCEED_TIME_FOR_LOG) {
        Log.info(TAG, `${album.albumUri} getAssets cost time:${Date.now() - startTime}`);
      }
      /* instrument ignore if */
      if (fetchResult.getCount() === 0) {
        Log.error(TAG, `albumUri: ${album.albumUri}, coverUri: ${album.coverUri}, Assets getCount = 0`);
        return undefined;
      }
      const photoAsset = await fetchResult.getFirstObject();
      return photoAsset;
    } catch (err) {
      /* instrument ignore if */
      Log.error(TAG, `getAlbumCoverPhotoAsset Get photo by uri exception! msg: ${err}`);
      return undefined;
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  /* instrument ignore next */
  public async getObject(album: PhotoAlbum, uri: string, fetchColumns?: string[]): Promise<PhotoAsset | undefined> {
    const fetchOption = new FetchOptionBuilder().photoUri(uri).getFetchOption();
    if (fetchColumns) {
      fetchOption.fetchColumns = fetchColumns;
    }
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await album.getAssets(fetchOption);
      if (fetchResult.getCount() !== 0) {
        return await fetchResult.getFirstObject();
      }
    } catch (err) {
      Log.error(TAG, `getObject --- ${err}}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  /**
   * 查询 Assets
   *
   * @param context 上下文
   * @param fetchOpt 查询条件
   * @returns 查询结果
   */
  /* instrument ignore next */
  public static async getAssets(context: common.Context, fetchOpt: photoAccessHelper.FetchOptions):
    Promise<(PhotoAsset | undefined)[]> {
    Log.info(TAG, `getAssets: ${JSON.stringify(fetchOpt)}`);
    if (!context) {
      Log.error(TAG, '[getAssets] context is null!');
      return [];
    }
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (!helper) {
        return [];
      }
      fetchResult = await helper.getAssets(fetchOpt);
      if (!fetchResult) {
        Log.warn(TAG, 'get all Object Data with empty fetchResult');
        return [];
      }
      if (fetchResult.getCount() <= 0) {
        return [];
      }

      let result = await fetchResult.getAllObjects();
      return result;
    } catch (error) {
      Log.error(TAG, `getAssets error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      helper?.release();
      Log.info(TAG, `finally fetchResult is close.`);
    }
  }

  public static async grantPermissionForUri(context: common.Context, tokenId: number,
    uri: string, hideSensitiveType?: photoAccessHelper.HideSensitiveType): Promise<number | undefined> {
    let result: number | undefined = undefined;
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (uri) {
        Log.info(TAG, `grantPermissionForUris tokenId:${tokenId}`);
        result = await helper?.grantPhotoUriPermission(
          tokenId,
          uri,
          photoAccessHelper.PhotoPermissionType.PERSISTENT_READ_IMAGEVIDEO,
          hideSensitiveType ? hideSensitiveType : photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE);
      }
    } catch (error) {
      Log.error(TAG, `grantPermissionForUris has error: ${error}, code: ${error?.code}`);
    } finally {
      helper?.release();
      Log.info(TAG, `grantPermissionForUris finished tokenId:${tokenId}`);
    }
    return result;
  }

  // 分类相册_数据查询接口
  public static async getCategoryAlbums(context: common.Context, albumSubType: photoAccessHelper.AlbumSubtype,
    albumNames: string[], limit: number): Promise<photoAccessHelper.Album[]> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      const isNewCategoryCVFinished = AppStorage.get<boolean>('isNewCategoryCVFinished')

      if (isNewCategoryCVFinished) {
        if (albumNames.length === 1) { // 查询具体某个相册数据
          Log.info(TAG, 'get single album')
          predicates
            .beginWrap()
            .in('album_name', albumNames)
            .greaterThanOrEqualTo('count', PhotoConstants.CATEGORY_ALBUM_MIN_COUNT)
            .endWrap()
        }

      } else {
        Log.info(TAG, `get old cate albums`)
        predicates.in('album_name', albumNames)
          .orderByDesc('count')
          .greaterThanOrEqualTo('count', PhotoConstants.CATEGORY_ALBUM_MIN_COUNT);
      }


      /* instrument ignore if */
      if (limit) {
        predicates.limit(limit, 0);
      }
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      fetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, albumSubType, fetchOptions);
      /* instrument ignore if */
      if (fetchResult === undefined) {
        Log.error(TAG, 'getAlbumsCallback fetchResult is undefined');
        return [];
      }
      const count = fetchResult.getCount();
      /* instrument ignore if */
      if (count === 0) {
        Log.info(TAG, 'getCategoryAlbums no data.');
        return [];
      }
      let categoryAlbum = await fetchResult.getAllObjects();
      Log.info(TAG, `getCategoryAlbums db result count : ${categoryAlbum?.length}`);
      return categoryAlbum;
    } catch (err) {
      /* instrument ignore next */
      Log.error(TAG, `albumsClassified：${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
    /* instrument ignore next */
    return [];
  }

  /**
   * 从photo表获取自拍数据,front_camera=1的数据
   * @param context
   * @returns 照片资源
   */
  public static async getCameraIn(context: common.Context): Promise<ICoverAlbum | undefined> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let predicatesCount = new dataSharePredicates.DataSharePredicates();

      predicatesCount.equalTo('front_camera', '1') // 前置摄像头
        .equalTo('hidden', 0)
      let fetchOptionsCount: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicatesCount,
      };
      fetchResult = await phAccessHelper.getAssets(fetchOptionsCount);
      const count = fetchResult?.getCount();

      if (count) {
        let predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('front_camera', '1') // 前置摄像头
          .equalTo('hidden', 0)
          .limit(1, 0)
          .orderByDesc('date_added')
        let fetchOptions: photoAccessHelper.FetchOptions = {
          fetchColumns: [],
          predicates: predicates,
        };
        fetchResult = await phAccessHelper.getAssets(fetchOptions);
        let asset = await fetchResult.getFirstObject();
        return { asset, count };
      }
      return undefined;
    } catch (err) {
      Log.error(TAG, `getCameraIn Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  /**
   * 从photo表获取备注数据,user_comment 不为空的数据
   * @param context
   * @returns 照片资源
   */
  public static async getUserComment(context: common.Context): Promise<ICoverAlbum | undefined> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let predicatesCount = new dataSharePredicates.DataSharePredicates();
      predicatesCount.isNotNull('user_comment') // 照片评论
        .notEqualTo('user_comment', '')
        .equalTo('hidden', 0)
      let fetchOptionsCount: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicatesCount,
      };
      fetchResult = await phAccessHelper.getAssets(fetchOptionsCount);
      const count = fetchResult?.getCount();
      if (count) {
        let predicates = new dataSharePredicates.DataSharePredicates();
        predicates.isNotNull('user_comment') // 照片评论
          .notEqualTo('user_comment', '')
          .equalTo('hidden', 0)
          .limit(1, 0)
          .orderByDesc('date_added')
        let fetchOptions: photoAccessHelper.FetchOptions = {
          fetchColumns: [],
          predicates: predicates,
        };
        fetchResult = await phAccessHelper.getAssets(fetchOptions);
        let asset = await fetchResult.getFirstObject();
        return { asset, count };
      }
      return undefined;
    } catch (err) {
      Log.error(TAG, `getUserComment Get Trash Album exception! msg:  ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  public static getPrivacyStatusByTokenId(tokenId: number): photoAccessHelper.HideSensitiveType {
    let privacyStatus = PhotoAccessHelperAccess.thirdSelectPrivacyMap.get(tokenId);
    Log.info(TAG, `getPrivacyStatusByTokenId, privacyStatus: ${privacyStatus}`);
    return privacyStatus === undefined ? photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE : privacyStatus;
  }

  /* instrument ignore next */
  public static async grantPermissionForUris(context: common.Context, tokenId: number,
    uris: string[], hideSensitiveType?: photoAccessHelper.HideSensitiveType): Promise<number | undefined> {
    let result: number | undefined = undefined;
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (uris && uris.length > 0) {
        Log.info(TAG, `grantPermissionForUris tokenId:${tokenId}`);
        result = await helper?.grantPhotoUrisPermission(
          tokenId,
          uris,
          photoAccessHelper.PhotoPermissionType.PERSISTENT_READ_IMAGEVIDEO,
          hideSensitiveType === undefined ? photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE :
            hideSensitiveType);
      }
    } catch (error) {
      Log.error(TAG, `grantPermissionForUris has error: ${error}, code: ${error?.code}`);
    } finally {
      helper?.release();
      Log.info(TAG, `grantPermissionForUris finished tokenId:${tokenId}`);
    }
    return result;
  }

  public static async getGroupAlbums(context: common.Context,
    predicate: dataSharePredicates.DataSharePredicates): Promise<PhotoAlbum[] | undefined> {
    if (!context || !predicate) {
      return undefined;
    }
    const startTime: number = Date.now();
    Log.info(TAG, `get group start: ${startTime}`);
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicate,
    };
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult =
        await accessHelper.getAlbums(Constants.PORTRAIT_QUERY_TYPE, Constants.GROUP_QUERY_SUB_TYPE, fetchOptions);
      const count = fetchResult.getCount();
      Log.info(TAG, `get group album view, album count: ${count}`);
      if (count === 0) {
        return [];
      }
      const albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      let isCoverUriValid = (item: PhotoAlbum) => {
        if (!item?.coverUri?.trim() || item?.count <= 0) {
          Log.warn(TAG, `album coveruri or count illegal: ${item?.albumUri}, count: ${item?.count}`);
          return false;
        }
        return true;
      };
      return albums.filter(isCoverUriValid);
    } catch (error) {
      Log.error(TAG, `Failed to get albums from group album view, error----: ${error}`);
      return [];
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `get group end: ${Date.now() - startTime}`);
    }
  }

  public static async getGroupAlbumsCount(context: common.Context,
    predicate: dataSharePredicates.DataSharePredicates, albumCounts: number[]): Promise<number> {
    if (!context || !predicate) {
      return 0;
    }
    const startTime: number = Date.now();
    Log.info(TAG, `get group start: ${startTime}`);
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicate,
    };
    let count: number = 0;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      fetchResult =
        await accessHelper.getAlbums(Constants.PORTRAIT_QUERY_TYPE, Constants.GROUP_QUERY_SUB_TYPE, fetchOptions);
      let albums = await fetchResult.getAllObjects();
      for (let album of albums) {
        if (album.count === 0) {
          continue;
        }
        count++;
        albumCounts.push(album.count);
      }
      Log.info(TAG, `get group album view, album count: ${count}`);
      return count;
    } catch (error) {
      Log.error(TAG, `Failed to get albums from group album view, error----: ${error}`);
      return 0;
    } finally {
      fetchResult?.close();
      accessHelper?.release();
      Log.info(TAG, `get group end: ${Date.now() - startTime}`);
    }
  }
}
