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

import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';

import lazy { Log } from '../../utils/Log';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { StringUtil } from '../../utils/StringUtil';
import lazy { FilterConditions } from '../../model/FilterConditions';
import lazy { SelectConstants } from '../common/SelectParams';
import lazy { AlbumInfo } from './album/AlbumInfo';
import lazy Rsc from '@ohos/tools/src/main/global/RscString';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { Constants } from '../common/Constants';
import lazy { UserFileData, FetchOptions } from '../../model/UserFileData';
import lazy { PickerAlbumsFilterEnhanceBuilder } from '../../model/PickerFilterEnhanceBuilder'
import lazy {
  AlbumFetchOptionBuilder,
  FileFetchOptionBuilder,
  PhotoFetchOptionBuilder
} from '../../model/FetchOption';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';

const TAG: string = 'AlbumDefine';

export enum QueryType {
  INVALID = -1,
  MEDIA = 0,
  SUBTYPE = 1,
  MIME_TYPE = 2,
}

export class AlbumDefine {
  public static readonly ALBUM_ID_ALL: string = 'default_all';
  public static readonly ALBUM_ID_CAMERA: string = 'default_camera';
  public static readonly ALBUM_ID_VIDEO: string = 'default_video';
  public static readonly ALBUM_ID_RECYCLE: string = 'default_recycle';
  public static readonly ALBUM_ID_FAVOR: string = 'default_favor';
  public static readonly ALBUM_ID_SNAPSHOT: string = 'default_snapshot';
  public static readonly ALBUM_ID_REMOTE: string = 'default_remote';
  public static readonly ALBUM_ID_PETALCLIP_VIDEO: string = 'default_petalclip_video';
  // 需要过滤的媒体文件类型
  public static readonly FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';
  public static readonly FILTER_MEDIA_TYPE_IMAGE: string = 'FILTER_MEDIA_TYPE_IMAGE';
  public static readonly FILTER_MEDIA_TYPE_VIDEO: string = 'FILTER_MEDIA_TYPE_VIDEO';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO: string = 'FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_JPEG: string = 'JPEG_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_GIF: string = 'GIF_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_PNG: string = 'PNG_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_HEIC: string = 'HEIC_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_HEIF: string = 'HEIF_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_BMP: string = 'BMP_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_WEBP: string = 'WEBP_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_IMAGE_AVIF: string = 'AVIF_IMAGE_TYPE';
  public static readonly FILTER_MEDIA_TYPE_VIDEO_MP4: string = 'MP4_VIDEO_TYPE';
  public static readonly FILTER_MEDIA_TYPE_VIDEO_MOV: string = 'MOV_VIDEO_TYPE';
  public static readonly PHOTO_KEYS_FILE_ID: string = 'file_id';
  public static readonly PHOTO_KEYS_DATA: string = 'data';
  public static readonly URI_PREFIX: string = 'file://media/Photo/';

  // key存放FILTER_*, value存放sql实际的过滤字段的类型
  public static readonly filterMediaTypeMap: Map<string, string> = new Map<string, string>();
  //key存放sql实际的过滤字段的类型, value存放sql进行过滤的字段
  public static readonly filterQueryTypeMap: Map<string, QueryType> = new Map<string, QueryType>();
  public static readonly CATEGORY_ALBUM_DISPLAY_NAME_MAP = new Map<string, Resource>([
    ['10001', $r('app.string.delicacy')],
    ['10002', $r('app.string.landscape')],
    ['10003', $r('app.string.document')],
    ['4', $r('app.string.id_card')],
    ['6', $r('app.string.bank_card')],
    ['10007', $r('app.string.motion')],
    ['10008', $r('app.string.means_of_transportation')],
    ['11', $r('app.string.aircraft')],
    ['14', $r('app.string.cats')],
    ['25', $r('app.string.blossom')],
    ['40', $r('app.string.city_overlook')],
    ['47', $r('app.string.night_view')],
    ['52', $r('app.string.high_mountain')],
    ['53', $r('app.string.construct')],
    ['55', $r('app.string.waterfall')],
    ['59', $r('app.string.rainbow')],
    ['62', $r('app.string.Statue_of_liberty')],
    ['63', $r('app.string.ppt')],
    ['68', $r('app.string.dinner_party')],
    ['69', $r('app.string.eiffel_tower')],
    ['97', $r('app.string.graduation_photo')],
    ['102', $r('app.string.wrist_watch')],
    ['105', $r('app.string.fountain')],
    ['107', $r('app.string.fireworks')],
    ['108', $r('app.string.business_card')],
    ['112', $r('app.string.panda')],
    ['113', $r('app.string.birthday_cake')],
    ['117', $r('app.string.the_oriental_pearl_tower')]
  ])
  static {
    AlbumDefine.filterMediaTypeMap.set(AlbumDefine.FILTER_MEDIA_TYPE_VIDEO,
      photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE);
    AlbumDefine.filterQueryTypeMap.set(photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE, QueryType.MEDIA);

    AlbumDefine.filterMediaTypeMap.set(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE,
      photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE);
    AlbumDefine.filterQueryTypeMap.set(photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE, QueryType.MEDIA);

    AlbumDefine.filterMediaTypeMap.set(AlbumDefine.FILTER_MEDIA_TYPE_ALL,
      photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE);
    AlbumDefine.filterQueryTypeMap.set(photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE, QueryType.INVALID);

    AlbumDefine.filterMediaTypeMap.set(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO,
      photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE);
    AlbumDefine.filterQueryTypeMap.set(photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE, QueryType.SUBTYPE);

  }

  //params: LOWER_CASE  获取最终的自定义upper case string
  public static getFilterMediaTypeUpperCase(filterMediaType: string): string {
    for (let value of AlbumDefine.filterMediaTypeMap) {
      if (value[1] === filterMediaType) {
        return value[0];
      }
    }
    return AlbumDefine.FILTER_MEDIA_TYPE_ALL;
  }

  //params: UPPER_CASE  获取  最终的传入数据库的lower case string
  public static getFilterMediaType(filterMediaType: string): string {
    if (AlbumDefine.filterMediaTypeMap.has(filterMediaType)) {
      Log.info(TAG, 'getFilterMediaType:' + AlbumDefine.filterMediaTypeMap.get(filterMediaType));
      return AlbumDefine.filterMediaTypeMap.get(filterMediaType) ??
      photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    }
    return filterMediaType;
  }

  //根据lower case string获取到最终的类型, mimeType subtype media
  public static getFilterQueryType(filterMediaType: string): QueryType {
    Log.info(TAG, 'getFilterQueryType filterMediaType:' + filterMediaType);
    let queryMediaType = AlbumDefine.getFilterMediaType(filterMediaType);
    Log.info(TAG, 'getFilterQueryType queryMediaType:' + queryMediaType);
    if (AlbumDefine.filterQueryTypeMap.has(queryMediaType)) {
      return AlbumDefine.filterQueryTypeMap.get(queryMediaType) ?? QueryType.INVALID;
    }
    return QueryType.INVALID;
  }

  public static getActualStringByQueryType(filterMediaType: string, queryType: QueryType): string {
    if (queryType === QueryType.INVALID || queryType === QueryType.MIME_TYPE) {
      return filterMediaType;
    }
    if (queryType === QueryType.MEDIA) {
      if (filterMediaType === photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE) {
        return '1';
      } else if (filterMediaType === photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE) {
        return '2';
      }
    } else if (queryType === QueryType.SUBTYPE) {
      if (filterMediaType === photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE) {
        return '3';
      }
    }
    return filterMediaType;
  }

  public static convertQueryAndFilterMap(filterTypeArray: Array<string>): Map<QueryType, string[]> {
    let map = new Map<QueryType, string[]>();
    for (let filterType of filterTypeArray) {

      let mediaString = AlbumDefine.getFilterMediaType(filterType);
      Log.info(TAG, 'convertQueryAndFilterMap filterType:' + filterType + '. mediaString:' + mediaString);
      if (mediaString === photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE) {
        continue;
      }
      let queryType = AlbumDefine.filterQueryTypeMap.get(mediaString) ?? QueryType.INVALID;
      Log.info(TAG, 'convertQueryAndFilterMap queryType:' + queryType);
      if (!map.has(queryType)) {
        map.set(queryType, []);
      }
      Log.info(TAG, 'convertQueryAndFilterMap str:' + AlbumDefine.getActualStringByQueryType(mediaString, queryType));
      map.get(queryType)?.push(AlbumDefine.getActualStringByQueryType(mediaString, queryType));
    }
    return map;
  }

  public static getFileFetchOpt(startIndex?: number, count?: number, filterMediaType?: string, needThumbnailReady?:
    boolean, orderProp?: string, fileIds?: number[], isAsc?: boolean): FetchOptions {
    let cameraShotKey = AppStorage.get<string>('cameraShotKey');
    return AlbumDefine.getFileFetchOptWithCamera(startIndex,
      count, filterMediaType, cameraShotKey, needThumbnailReady, orderProp, fileIds, isAsc);
  }

  public static getFileFetchOptAsync(startIndex?: number, count?: number, filterMediaType?: string, needThumbnailReady?:
    boolean, orderProp?: string, fileIds?: number[], isAsc?: boolean): FetchOptions {
    // taskpool调用AppStorage会导致子线程阻塞，该值表示锁屏相机，安全相机，对相册封面暂无影响
    let cameraShotKey = '';
    return AlbumDefine.getFileFetchOptWithCamera(startIndex,
      count, filterMediaType, cameraShotKey, needThumbnailReady, orderProp, fileIds, isAsc);
  }

  public static setFilterConditions(fetchOpt: FetchOptions, filterCondition?: FilterConditions): void {
    if (!fetchOpt || !filterCondition) {
      return;
    }
    if (filterCondition.recommendationType === SelectConstants.RECOMMEND_TYPE_COLOR_STYPE) {
      Log.info(TAG, 'getFetchOpt recommendationType filter');
      fetchOpt.predicates.equalTo('is_style_photo', 1);
    }

    let builder = new PickerAlbumsFilterEnhanceBuilder(fetchOpt);
    builder.setFilterParam({ filterConditions: filterCondition });
  }

  public static getOrderBuilder(builder: FileFetchOptionBuilder, isAsc: boolean = false,
    orderProp?: string): void {
    if (!builder) {
      Log.error(TAG, `builder undefined.`);
      return;
    }
    if (orderProp === UserFileData.FILE_KEY_DATE_TAKEN_MS.toString()) {
      // 拍摄时间
      // 降序：DATETAKEN  DESC DISPLAY_NAME DESC ID DESC
      // 升序：DATETAKEN  ASC DISPLAY_NAME ASC ID ASC
      builder.order(orderProp, isAsc);
    } else if (orderProp === UserFileData.FILE_KEY_SIZE.toString()) {
      // 文件大小
      // 降序：SIZE  DESC ID DESC
      // 升序：SIZE  ASC ID ASC
      builder.order(orderProp, isAsc);
      // 修改后宫格排序和分享框内排序不一致
      builder.order(UserFileData.FILE_KEY_FILE_ID, isAsc);
    } else if (orderProp === UserFileData.FILE_KEY_DISPLAY_NAME.toString()) {
      // 文件名
      // 降序：
      // 中文：DISPLAY_NAME  COLLATE LOCALIZED DESC
      // 非中文：DISPLAY_NAME  DESC
      // 升序：
      // 中文：DISPLAY_NAME  COLLATE LOCALIZED ASC
      // 非中文 : DISPLAY_NAME  ASC
      builder.order(orderProp, isAsc);
    } else {
      // 创建时间
      // 降序：DATE_ADDED  DESC DISPLAY_NAME DESC ID DESC
      // 升序：DATE_ADDED  ASC DISPLAY_NAME ASC ID ASC
      builder.order(UserFileData.FILE_KEY_DATE_ADDED.toString(), isAsc);
    }
  }

  public static getFileFetchOptWithDate(count: number, filterMediaType: string,
    dateTaken: number, dateAdded?: number): FetchOptions {
    let builder = new FileFetchOptionBuilder();

    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }

    builder.order(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(), false);
    builder.order(UserFileData.FILE_KEY_DATE_ADDED_MS.toString(), false);
    if (dateTaken && dateAdded) {
      builder.beginWrap();
      builder.equalTo(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(), dateTaken);
      builder.logicalAnd();
      builder.lessThan(UserFileData.FILE_KEY_DATE_ADDED_MS.toString(), dateAdded);
      builder.logicalOr();
      builder.lessThan(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(), dateTaken);
      builder.endWrap();
    } else if (dateTaken) {
      builder.lessThan(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(), dateTaken);
    } else {
      Log.info(TAG, `getFileFetchOptWithDate dateTaken is ${dateTaken}, dateAdded is ${dateAdded}`);
    }

    if (count && count > 0) {
      builder.select(0, count);
    }

    return builder.build();
  }

  // 该函数在taskpool中运行，禁止在该函数中使用appstorage变量, 会导致异常
  public static getFileFetchOptWithCamera(startIndex?:
    number, count?: number, filterMediaType?: string, cameraShotKey?:
    string, needThumbnailReady?: boolean, orderProp?: string, fileIds?: number[],
    isAsc: boolean = false): FetchOptions {
    let builder = new FileFetchOptionBuilder();
    AlbumDefine.getOrderBuilder(builder, isAsc, orderProp);
    if (ImageUtil.isThumbnailReady() && needThumbnailReady) {
      builder.thumbnailReady(UserFileData.THUMBNAIL_READY_VALUE);
    }
    if (filterMediaType) {
      Log.debug(TAG, `getFileFetchOptWithCamera: ${filterMediaType} `);
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    Log.debug(TAG, `cameraShotKey: ${cameraShotKey ?? ' ' + startIndex + count + filterMediaType} `);
    if (cameraShotKey) {
      if (filterMediaType) {
        builder.logicalAnd();
      }
      builder.cameraShotKey(cameraShotKey);
    }
    if (fileIds) {
      builder.fileIds(fileIds);
    } else if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }


  public static getFileFetchOptWithClassifyFromPhotoDb(startIndex?:
    number, count?: number, classifyFromPhotoKey?: string): FetchOptions {
    Log.info(TAG, 'category get note or camera data from photo')
    let predicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    let builder = new FileFetchOptionBuilder(fetchOptions);

    if (startIndex !== undefined && startIndex !== null && count !== undefined && count !== null &&
      startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  /**
   *
   * @param startIndex
   * @param count
   * @param filterMediaType
   * @param orderProp 宫格排序字段
   * @returns
   */
  public static getFileFetchOptWithEmptyColumn(startIndex?: number, count?: number,
    filterMediaType?: string, orderProp?: string, isAsc?: boolean): FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [],
    };
    let builder = new FileFetchOptionBuilder(fetchOption);
    builder.order(orderProp ?? UserFileData.FILE_KEY_DATE_ADDED.toString(), isAsc ?? false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex !== undefined && startIndex !== null && count !== undefined && count !== null &&
      startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  /* instrument ignore next */
  public static getFileFetchOptWithDateColumn(startIndex?: number, count?: number,
    filterMediaType?: string, orderProp?: string): FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
        UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(),
        photoAccessHelper.PhotoKeys.POSITION.toString(),
        UserFileData.FILE_KEY_THUMBNAIL_READY.toString(),
        UserFileData.BURST_KEY,
      ]
    };
    let builder = new FileFetchOptionBuilder(fetchOption);
    builder.order(orderProp ?? UserFileData.FILE_KEY_DATE_ADDED.toString(), false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex !== undefined && startIndex !== null && count !== undefined && count !== null &&
      startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  // 文件正在上传中，即仅存在本地的文件
  public static getUploadingFetchOpt(filterMediaType?: string): FetchOptions {
    let builder = new FileFetchOptionBuilder();
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    builder.locate(UserFileData.FILE_LOCATION_LOCAL);
    return builder.build();
  }

  public static getTrashFetchOpt(startIndex?: number, count?: number, filterMediaType?: string): FetchOptions {
    let builder = new FileFetchOptionBuilder();
    builder.order(UserFileData.FILE_KEY_DATE_TRASHED.toString(), false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex !== undefined && startIndex !== null && count !== undefined && count !== null &&
      startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  public static getTrashFetchOptWithEmptyColumn(startIndex?: number, count?: number, filterMediaType?: string):
    FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [],
    };
    let builder = new FileFetchOptionBuilder(fetchOption);
    builder.order(UserFileData.FILE_KEY_DATE_TRASHED.toString(), false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex !== undefined && startIndex !== null && count !== undefined && count !== null &&
      startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  /* instrument ignore next */
  public static getTrashFetchOptWithDateColumn(startIndex?: number, count?: number, filterMediaType?: string):
    FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_TAKEN_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_TRASHED_MS.toString(),
        UserFileData.FILE_KEY_THUMBNAIL_READY.toString()
      ]
    };
    let builder = new FileFetchOptionBuilder(fetchOption);
    builder.order(UserFileData.FILE_KEY_DATE_TRASHED.toString(), false);
    if (filterMediaType) {
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
    }
    if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  public static getFileFetchOptByUri(uri: string): FetchOptions {
    let builder = new FileFetchOptionBuilder().uri(uri);
    return builder.build();
  }

  /* instrument ignore next */
  public static getFileIdFromUri(uri: string): number | null {
    if (!uri) {
      Log.error(TAG, `input param uri is invalid: ${uri}`);
      return null;
    }
    let tempUri: string = uri.replace(AlbumDefine.URI_PREFIX, '');
    let uriIdStrArr: string[] = tempUri.split('/');
    if (!uriIdStrArr || uriIdStrArr.length === 0) {
      Log.info(TAG, `invaild uri: ${uri}`);
      return null;
    }
    let fileId = parseInt(uriIdStrArr[0]);
    if (!Number.isFinite(fileId)) {
      Log.info(TAG, `fileId Number.isNaN. uri:${uri}`);
      return null;
    }
    return fileId;
  }

  /* instrument ignore next */
  public static getFileIdList(uriList: string[]): number[] {
    let uriIdList: number[] = [];
    if (!uriList || uriList.length === 0) {
      Log.error(TAG, 'getFileIdList uriList is invalid');
      return uriIdList;
    }
    for (let uri of uriList) {
      let tempUri = uri.replace(AlbumDefine.URI_PREFIX, '');
      let uriIdStrArr = tempUri.split('/');
      if (!uriIdStrArr || uriIdStrArr.length === 0) {
        Log.info(TAG, `!uriIdStrArr || uriIdStrArr.length === 0. uri:${uri}`);
        continue;
      }
      let fileId = parseInt(uriIdStrArr[0]);
      if (!Number.isFinite(fileId)) {
        Log.info(TAG, `fileId Number.isNaN. uri:${uri}`);
        continue;
      }
      uriIdList.push(fileId);
    }
    return uriIdList;
  }

  /* instrument ignore next */
  public static getFileFetchOptByUriList(fileIdList: number[]): FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: UserFileData.ALL_IMAGE_VIDEO_FETCH_COLUMNS,
    };
    if (!fileIdList || fileIdList.length === 0) {
      return fetchOption;
    }
    fetchOption.predicates.in(AlbumDefine.PHOTO_KEYS_FILE_ID, fileIdList);
    return fetchOption;
  }

  public static getFileFetchOptForYearAndMonth(startIndex?: number, count?: number,
    isThumbnailReady?: boolean): FetchOptions {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.orderByDesc(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString())
      .orderByDesc(AlbumDefine.PHOTO_KEYS_FILE_ID.toString())
      .limit(count, startIndex);
    if (isThumbnailReady) {
      predicates.equalTo(UserFileData.FILE_KEY_THUMBNAIL_VISIBLE,
        UserFileData.THUMBNAIL_VISIBLE_VALUE);
    }
    let fetchOpt: photoAccessHelper.FetchOptions = {
      predicates,
      fetchColumns: [AlbumDefine.PHOTO_KEYS_FILE_ID,
        UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString(),
        photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString()]
    };
    return fetchOpt;
  }

  public static getFileFetchOptByDateModified(startIndex?: number, count?: number): FetchOptions {
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates()
        .orderByDesc(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString()).limit(count, startIndex),
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString(),
        UserFileData.FILE_KEY_DATE_TAKEN_MS.toString()]
    };
    return fetchOption;
  }

  public static getFileFetchOptByName(displayName: string): FetchOptions {
    let builder = new FileFetchOptionBuilder().displayName(displayName);
    return builder.build();
  }

  public static getFileFetchOptByPath(path: string): FetchOptions {
    let builder = new FileFetchOptionBuilder().path(path);
    return builder.build();
  }

  public static getPhotoFetchOptByUri(uri: string): FetchOptions {
    let builder = new PhotoFetchOptionBuilder().uri(uri);
    return builder.build();
  }

  public static getAlbumFetchOptByName(name: string): FetchOptions {
    let builder = new AlbumFetchOptionBuilder();
    builder.albumName(name);
    return builder.build();
  }

  public static getAlbumFetchOptByUri(albumUri: string): FetchOptions {
    let builder = new AlbumFetchOptionBuilder();
    if (albumUri) {
      builder.albumUri(albumUri);
    }
    return builder.build();
  }

  public static getAlbumsFetchOptByUris(albumUris: string[]): FetchOptions {
    let builder: AlbumFetchOptionBuilder = new AlbumFetchOptionBuilder();
    builder.albumUris(albumUris);
    return builder.build();
  }

  // 图库相册顺序倒序排列
  /* instrument ignore next */
  public static getAlbumFetchOptByOrderDesc(): FetchOptions {
    let builder = new AlbumFetchOptionBuilder();
    builder.albumOrderDesc();
    return builder.build();
  }

  public static setFilterMediaType(builder: FileFetchOptionBuilder, filterMediaType: string): FileFetchOptionBuilder {

    let queryType = AlbumDefine.getFilterQueryType(filterMediaType);
    Log.info(TAG, `getFileFetchOptWithVideoCleanup: ${filterMediaType} ${queryType}`);
    if (QueryType.MEDIA === queryType) {
      if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
        builder.media(UserFileData.MEDIA_TYPE_IMAGE.toString());
      } else if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
        builder.media(UserFileData.MEDIA_TYPE_VIDEO.toString());
      }
    } else if (QueryType.SUBTYPE === queryType) {
      if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO) {
        Log.info(TAG, `FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO`);
        builder.subType(UserFileData.SUB_TYPE_MOVING_PHOTO.toString());
      }
    } else if (QueryType.MIME_TYPE === queryType) {
      Log.info(TAG, `MIME_TYPE:${filterMediaType}`);
      builder.mimeType(AlbumDefine.filterMediaTypeMap.get(filterMediaType)?.toString() ?? '');
    }
    return builder;
  }

  /**
   *
   * 视频清理页面使用
   *
   * @param startIndex 查询开始索引
   * @param count 查询数量
   * @param filterMediaType 过滤媒体类型
   * @returns 查询语句
   */
  public static getFileFetchOptWithCleanupPage(fromPage: string, startIndex?: number, count?: number,
    needThumbnailReady?: boolean, imageOrderByName?: string): FetchOptions {
    Log.debug(TAG,
      `getFileFetchOptWithVideoCleanup: startIndex=${startIndex}, count=${count}`);
    let builder = new FileFetchOptionBuilder();
    if (fromPage === Constants.GRID_CLEANUP_PAGE) {
      builder.locateOr(UserFileData.FILE_LOCATION_LOCAL, UserFileData.FILE_LOCATION_LOCAL_CLOUD)
        .order(UserFileData.FILE_KEY_DATE_TRASHED.toString(), false);
    } else if (fromPage === Constants.VIDEO_CLEANUP_PAGE) {
      AlbumDefine.getAllLocalVideoFile(builder);
    } else if (fromPage === Constants.IMAGE_CLEANUP_PAGE) {
      AlbumDefine.getAllLocalPhotoFile(builder, imageOrderByName);
    }
    if (ImageUtil.isThumbnailReady() && needThumbnailReady) {
      builder.logicalAnd();
      builder.thumbnailReady(UserFileData.THUMBNAIL_READY_VALUE);
    }
    if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  /**
   * 按照视频文件大小降序 + date_takn升序 + 文件名降序来排列显示所有含本地文件的本地视频；
   *
   * @param builder
   * @returns 查询语句
   */
  public static getAllLocalVideoFile(builder: FileFetchOptionBuilder): FileFetchOptionBuilder {
    builder.media(UserFileData.MEDIA_TYPE_VIDEO.toString())
      .logicalAnd()
      .locateOr(UserFileData.FILE_LOCATION_LOCAL, UserFileData.FILE_LOCATION_LOCAL_CLOUD)
      .order(UserFileData.FILE_KEY_SIZE.toString(), false)
      .order(UserFileData.FILE_KEY_DATE_TAKEN_MS.toString(), true)
      .order(UserFileData.FILE_KEY_DISPLAY_NAME.toString(), false);
    return builder;
  }

  /**
   * 获取本地视频
   *
   * @param builder
   * @returns 查询语句
   */
  public static getAllLocalPhotoFile(builder: FileFetchOptionBuilder,
    imageOrderByName?: string): FileFetchOptionBuilder {
    builder.media(UserFileData.MEDIA_TYPE_IMAGE.toString())
      .logicalAnd()
      .locateOr(UserFileData.FILE_LOCATION_LOCAL, UserFileData.FILE_LOCATION_LOCAL_CLOUD)
      .order(imageOrderByName ?? UserFileData.FILE_KEY_DATE_TAKEN_MS, false);
    return builder;
  }

  // 获取连拍图片
  public static getCleanupPageBurstPhotosFetchOpt(startIndex: number, count: number): FetchOptions {
    let builder = new FileFetchOptionBuilder();
    AlbumDefine.setFilterMediaType(builder, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
    if (startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  // 获取连拍图片
  public static getBurstPhotosFetchOpt(startIndex: number, count: number, isDesc?: boolean, isTrash?: boolean):
    FetchOptions {
    let builder = new FileFetchOptionBuilder();

    if (isTrash) {
      builder.greaterThan(UserFileData.FILE_KEY_DATE_TRASHED.toString(), 0);
    } else {
      builder.equalTo(UserFileData.FILE_KEY_DATE_TRASHED.toString(), 0);
    }

    if (isDesc) {
      builder.order(UserFileData.FILE_KEY_TITLE.toString(), false);
    }

    AlbumDefine.setFilterMediaType(builder, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);

    if (startIndex >= 0 && count >= 0) {
      builder.select(startIndex, count);
    }
    return builder.build();
  }

  // 拼接 SQL, 查询在 albumUris 所在相册中的照片，并排除已删除的图片
  public static modifyPredicatesInAlbumUris(predicates: dataSharePredicates.DataSharePredicates,
    albumUris: string[]): void {
    if (!predicates) {
      Log.error(TAG, 'modifyPredicatesInAlbumUris: predicates is undefined');
      return;
    }
    if (!albumUris || albumUris.length === 0) {
      Log.error(TAG, 'modifyPredicatesInAlbumUris: albumUris is undefined or empty');
      return;
    }
    // photos 表中没有album uri相关的字段, 通过 owner_album_id 字段进行查询
    predicates.beginWrap();
    for (let index = 0; index < albumUris.length; index++) {
      let uriParts: string[] = albumUris[index].split('/');
      let albumId: string = uriParts[uriParts.length - 1];
      predicates.equalTo(UserFileData.FILE_KEY_OWNER_ALBUM_ID, albumId);
      if (index < albumUris.length - 1) {
        predicates.or();
      }
    }
    predicates.endWrap();
  }

  // 拼接 SQL, 查询在 PhotoUris 对应的照片
  public static modifyPredicatesInPhotoUris(predicates: dataSharePredicates.DataSharePredicates,
    photoUris: string[]): void {
    if (!predicates) {
      Log.error(TAG, 'modifyPredicatesInPhotoUris: predicates is undefined');
      return;
    }
    if (!photoUris || photoUris.length === 0) {
      Log.error(TAG, 'modifyPredicatesInPhotoUris: albumUris is undefined or empty');
      return;
    }

    predicates.beginWrap();
    for (let index = 0; index < photoUris.length; index++) {
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, photoUris[index]);
      if (index < photoUris.length - 1) {
        predicates.or();
      }
    }
    predicates.endWrap();
  }

  public static getPhotoTypeKeyByFilterMediaType(filterMediaType: string): string {
    if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
      return UserFileData.MEDIA_TYPE_VIDEO.toString();
    }
    if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      return UserFileData.MEDIA_TYPE_IMAGE.toString();
    }
    if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO) {
      return UserFileData.SUB_TYPE_MOVING_PHOTO.toString();
    }
    Log.error(TAG, `getPhotoTypeKeyByFilterMediaType: filterMediaType ${filterMediaType} is invalied`);
    return '';
  }

  /**
   * albumInfo序列化时，对其中的albumName做脱敏处理
   *
   * @param key key
   * @param value value
   * @returns res value
   */
  public static albumNameReplacer<T>(key: string, value: T): T | string {
    if (key === 'albumName' && (typeof value === 'string')) {
      return StringUtil.getAnonymizeString(value);
    }
    if (key == 'lpath' && (typeof value === 'string')) {
      return StringUtil.getAnonymizeString(value);
    }
    return value;
  }

  public static getAnonymizeAlbumName(value: Resource | string): Resource | string {
    return (typeof value === 'string') ? StringUtil.getAnonymizeString(value) : value;
  }

  /**
   * 判断系统相册
   *
   * @param albumType 相册类型
   * @returns true/false
   */
  public static isSystemAlbum(albumType: number): boolean {
    return albumType === photoAccessHelper.AlbumType.SYSTEM;
  }


  public static isPhotoAlbum(albumSubtype: number): boolean {
    return albumSubtype === photoAccessHelper.AlbumSubtype.IMAGE;
  }

  public static isVideoAlbum(albumSubtype: number): boolean {
    return albumSubtype === photoAccessHelper.AlbumSubtype.VIDEO;
  }


  /**
   * 判断用户相册
   *
   * @param albumType 相册类型
   * @param albumSubType 相册子类型
   * @returns true/false
   */
  public static isUserAlbum(albumType: number, albumSubType: number): boolean {
    return albumType === photoAccessHelper.AlbumType.USER &&
      albumSubType === photoAccessHelper.AlbumSubtype.USER_GENERIC;
  }

  /**
   * 判断来源相册
   *
   * @param albumSubType 相册子类型
   * @returns true/false
   */
  public static isSourceAlbum(albumSubType: number): boolean {
    return albumSubType === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  }

  /**
   * 判断是否存在融合相册
   * @param albumUri
   * @returns
   */
  public static isUnionAlbum(albumUri: string | undefined): boolean {
    return false;
  }
  
  /*
   * 通过相册类型获取相册名称（value）非resource,只要系统相册即可
   */
  public static getSystemAlbumNameByResource(album: AlbumInfo): string {
    let albumName: string = '';
    if (!album) {
      Log.debug(TAG, 'album is Invalid');
      return albumName;
    }
    if (typeof album.albumName === 'string') {
      albumName = album.albumName;
    }
    TraceControllerUtils.startTrace('setSystemAlbumName by Resource');
    // 相机、截图、屏幕录制，写缓存方式改变
    if (album?.lpath === Constants.LPATH_CAMERA) {
      albumName = Rsc.toString($r('app.string.source_camera'));
    } else if (album?.lpath === Constants.LPATH_SCREEN_SHOT) {
      albumName = Rsc.toString($r('app.string.source_screenshot'));
    } else if (album?.lpath === Constants.LPATH_SCREEN_RECORDING) {
      albumName = Rsc.toString($r('app.string.source_screen_recording'));
    }
    // 系统相册写缓存方式
    if (album?.subType === photoAccessHelper.AlbumSubtype.IMAGE) {
      albumName = Rsc.toString($r('app.string.album_photos'));
    } else if (album?.subType === photoAccessHelper.AlbumSubtype.VIDEO) {
      albumName = Rsc.toString($r('app.string.album_video'));
    } else if (album?.subType === photoAccessHelper.AlbumSubtype.FAVORITE) {
      albumName = Rsc.toString($r('app.string.album_favor'));
    } else if (album?.subType === photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT) {
      albumName = Rsc.toString($r('app.string.album_cloud_enhance'));
    } else {
      Log.debug(TAG, `albumSubType is error: ${album.subType}.`);
    }
    TraceControllerUtils.finishTrace('setSystemAlbumName by Resource');
    return albumName;
  }

  public static getAlbumNameResource(album: photoAccessHelper.Album): Resource | string {
    if (AlbumDefine.isSystemAlbum(album.albumType)) {
      // 系统相册，图库自己命名
      switch (album.albumSubtype) {
        case photoAccessHelper.AlbumSubtype.IMAGE:
          return $r('app.string.album_photos');
        case photoAccessHelper.AlbumSubtype.FAVORITE:
          return $r('app.string.album_favor');
        case photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT:
          return $r('app.string.album_cloud_enhance');
        case photoAccessHelper.AlbumSubtype.VIDEO:
          return $r('app.string.album_video');
        case photoAccessHelper.AlbumSubtype.TRASH:
          return $r('app.string.album_recycle');
        default:
          return '';
      }
    }
    // 系统来源相册需要自己命名
    if (album.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
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

  public static getAlbumNameString(albumName: Resource | string): string {
    if (typeof albumName === 'string') {
      return albumName;
    }
    return new RscGetter(getContext().resourceManager).getString(albumName);
  }

  public static getAlbumIdByAlbumUri(albumUri?: string): number {
    let numArray = albumUri?.match(/\d+(\.\d+)?/g);
    return Number(numArray?.pop() ?? '-1');
  }
}

export interface AlbumCallBackParam {
  userAlbumCount: number;
}