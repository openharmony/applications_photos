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

import type { QueryParam } from '../../../interface/BrowserDataInterface';
import type common from '@ohos.app.ability.common';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumInfo } from './AlbumInfo';
import type { PhotoAlbum } from '../../../access/PhotoAccessHelperAccess';
import lazy { AlbumDataImpl } from './AlbumDataImpl';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { nowOverOneWeek, sourceAlbumCountReport } from '../../../utils/StatisticReportUtil';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { LoadingInfo } from '../../DataSource';
import lazy { Constants } from '../../common/Constants';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy {
  UserFileManagerAccess,
  FetchOptions,
  FileAssetEx,
  toString,
  AlbumCountAndPhotoAsset
} from '../../../access/UserFileManagerAccess';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy { HashMap } from '@kit.ArkTS';
import lazy { AlbumGridSortHelper } from '../../AlbumGridSortHelper';
import lazy { SHARE_ALBUM_LPATH } from '../../../access/PhotoAccessHelperAccess';

const TAG: string = 'common_SourceTypeAlbumDataImpl';

type FetchAlbumResult = photoAccessHelper.FetchResult<PhotoAlbum>;
type PhotoAccessHelper = photoAccessHelper.PhotoAccessHelper;

export class SourceTypeAlbumDataImpl extends AlbumDataImpl {
  private context: common.Context;
  private lastSourceAlbumCountReportTime: string = '';
  private readonly sourceAlbumLPath = [
    '/DCIM/Camera',
    '/Pictures/Screenshots',
    '/Pictures/Screenrecords',
  ];
  private readonly sourceAlbumLPathShow = [
  ];
  // 有效的系统来源相册的数量
  private sysAlbumCount: number = 0;
  private userFileManagerAccess: UserFileManagerAccess;

  constructor(context: common.Context) {
    super();
    this.context = context;
    this.userFileManagerAccess = UserFileManagerAccess.getInstance();
    if (!this.userFileManagerAccess.getMediaLibrary()) {
      this.userFileManagerAccess = new UserFileManagerAccess();
      this.userFileManagerAccess.onCreate(this.context);
    }
  }

  public async getSourceAlbumData(callback: (albums: AlbumInfo[]) => void,
    param?: Partial<QueryParam>, sourceAlbumUri?: string, info?: LoadingInfo): Promise<void> {
    Log.info(TAG, `load data getData start : ${JSON.stringify(param)}`);
    if (!param) {
      let startTime: number = Date.now();
      const albums: AlbumInfo[] = await this.buildSourceAlbums(info, undefined, sourceAlbumUri);
      Log.info(TAG, `getSourceAlbumData cost: ${Date.now() - startTime}ms`);
      callback?.(albums);
    }
  }

  public async buildSourceAlbums(info?: LoadingInfo, filterMediaType?: string, sourceAlbumUri?: string):
    Promise<AlbumInfo[]> {
    // step 1. 获取所有来源相册
    let albums: PhotoAlbum[] = [];
    let unionAlbumList: PhotoAlbum[][] = [];
    await this.getSourceObject(this.context, albums, unionAlbumList, info);
    if (sourceAlbumUri) {
      // 移动操作时， 排除 sourceAlbumUri 所在的相册
      albums = albums.filter((item: PhotoAlbum) => item.albumUri !== sourceAlbumUri);
      unionAlbumList = unionAlbumList
        .filter((unionAlbum: PhotoAlbum[]): boolean => {
          return unionAlbum.find((item: PhotoAlbum) => item.albumUri === sourceAlbumUri) === undefined;
        });
    }
    Log.info(TAG, `buildSourceAlbums filterMediaType: ${filterMediaType}  sourceAlbumUri:${
    sourceAlbumUri} album count: ${albums.length}, unionAlbum count: ${unionAlbumList.length}`);


    // step 2. 将系统来源相册和除聚合相册外第三方来源相册转化为 AlbumInfo
    if (albums?.length === 0 && unionAlbumList?.length === 0) {
      return [];
    }
    let albumInfos: AlbumInfo[] = await this.buildAlbumsInfo(albums, filterMediaType);

    // step 3. 将聚合相册转化为 AlbumInfo ，并根据其 count 将其插入到合适位置, 应排在系统来源相册之后
    let fetchArray: Promise<AlbumInfo | undefined>[] = unionAlbumList
      .map((unionAlbum: PhotoAlbum[]): Promise<AlbumInfo | undefined> => {
        return this.buildUnionAlbumInfo(unionAlbum, filterMediaType);
      });
    let unionAlbumInfos: (AlbumInfo | undefined)[] = await Promise.all(fetchArray);
    for (let albumInfo of unionAlbumInfos) {
      /* instrument ignore next */
      if (!albumInfo) {
        continue;
      }
      Log.debug(TAG, `buildSourceAlbums-${AlbumDefine.getAnonymizeAlbumName(albumInfo.albumName)}: ${albumInfo.count}`);

      let idx: number = this.sysAlbumCount;
      while (idx < albumInfos.length && (albumInfos[idx].count > albumInfo.count ||
        albumInfos[idx].count === albumInfo.count && albumInfos[idx].albumName > albumInfo.albumName)) {
        idx++;
      }
      albumInfos.splice(idx, 0, albumInfo);
    }

    // step 4. 若 info 中规定了来源相册的个数，则对 albumInfos 进行截取
    /* instrument ignore next */
    if (info && info.count > this.sysAlbumCount && albumInfos.length > info.count) {
      albumInfos = albumInfos.slice(0, info.count);
    }

    return albumInfos;
  }

  public async buildSourcePhotoAlbums(): Promise<PhotoAlbum[]> {
    let accessHelper = PhotoAccessHelperAccess.getPhotoAccessHelper(this.context);
    let newList: PhotoAlbum[] = [];
    let systemAlbumsFetchResult = await this.getSystemAlbums(accessHelper);

    await this.processSystemAlbumList(systemAlbumsFetchResult, newList);

    accessHelper.release();
    return newList;
  }

  public async buildSourceAlbumsWithFilter(info?: LoadingInfo, param?: QueryParam, sourceAlbumUri?: string):
    Promise<AlbumInfo[]> {
    // step 1. 获取所有来源相册
    let albums: PhotoAlbum[] = [];
    let unionAlbumList: PhotoAlbum[][] = [];
    await this.getSourceObject(this.context, albums, unionAlbumList);
    Log.info(TAG, `buildSourceAlbumsWithFilter param: ${toString(param)}
     album count: ${albums.length}, unionAlbum count: ${unionAlbumList.length}`);

    // step 2. 将系统来源相册和除聚合相册外第三方来源相册转化为 AlbumInfo
    let albumInfos: AlbumInfo[] = await Promise.all(albums
      .map(async (album: PhotoAlbum): Promise<AlbumInfo> => {
        return this.buildAlbumInfoWithFilter(album, param);
      }));

    // step 3. 将聚合相册转化为 AlbumInfo ，并根据其 count 将其插入到合适位置, 应排在系统来源相册之后.,自行排序
    let fetchArray: Promise<AlbumInfo | undefined>[] = unionAlbumList
      .map((unionAlbum: PhotoAlbum[]): Promise<AlbumInfo | undefined> => {
        return this.buildUnionAlbumInfoWithFilter(unionAlbum, param);
      });
    let unionAlbumInfos: (AlbumInfo | undefined)[] = await Promise.all(fetchArray);
    for (let albumInfo of unionAlbumInfos) {
      /* instrument ignore next */
      if (!albumInfo) {
        continue;
      }
      Log.debug(TAG,
        `buildSourceAlbumsWithFilter-${AlbumDefine.getAnonymizeAlbumName(albumInfo.albumName)}: ${albumInfo.count}`);

      let idx: number = this.sysAlbumCount;
      /* instrument ignore next */
      while (idx < albumInfos.length && (albumInfos[idx].count > albumInfo.count ||
        albumInfos[idx].count === albumInfo.count && albumInfos[idx].albumName > albumInfo.albumName)) {
        idx++;
      }
      albumInfos.splice(idx, 0, albumInfo);
    }

    return albumInfos;
  }

  public async getSourceObject(context: common.Context, newList: PhotoAlbum[], unionAlbumList: PhotoAlbum[][],
    info?: LoadingInfo): Promise<void> {
    if (!newList || !unionAlbumList) {
      Log.error(TAG, 'getSourceObject error: newList or unionAlbumList is undefined');
      return;
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined;
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getSourceObject', startTime);
    try {
      accessHelper = PhotoAccessHelperAccess.getPhotoAccessHelper(context);
      const fetchResults = await Promise.all([
        this.getSystemAlbums(accessHelper),
        this.getUnionAlbums(accessHelper),
      ]);
      const systemFetchResult = fetchResults[0];
      const unionAlbumFetchResult: FetchAlbumResult[] = fetchResults[1];
      await this.processSystemAlbumList(systemFetchResult, newList);
      this.sysAlbumCount = newList.length;
      await this.processUnionAlbum(unionAlbumFetchResult, unionAlbumList);
      Log.info(TAG, `systemAlbumCount: ${this.sysAlbumCount} unionAlbumCount: ${unionAlbumList.length}`);
      // 来源相册数量
      /* instrument ignore next */
      if (nowOverOneWeek(this.lastSourceAlbumCountReportTime)) {
        sourceAlbumCountReport(newList.length + unionAlbumList.length).then((lastTime: string) => {
          this.lastSourceAlbumCountReportTime = lastTime;
        });
      }
    } catch (err) {
      Log.error(TAG, `Get Source Object exception! msg: ${err}, code: ${err?.code}`);
    } finally {
      accessHelper?.release();
    }
    TraceControllerUtils.finishTraceWithTaskId('getSourceObject', startTime);
    Log.info(TAG, `getSourceObject cost: ${Date.now() - startTime}ms`);
  }

  private async processSystemAlbumList(systemFetchResult: FetchAlbumResult[], newList: PhotoAlbum[]): Promise<void> {
    for (const fetchResult of systemFetchResult) {
      const count: number = fetchResult.getCount();
      /* instrument ignore next */
      if (count === 0) {
        fetchResult.close();
        Log.info(TAG, 'processSystemAlbumList continue for count = 0.');
        continue;
      }
      const albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      /* instrument ignore next */
      for (let album of albums) {
        Log.info(TAG,
          `systemAlbumPush-albumName: ${AlbumDefine.getAnonymizeAlbumName(album?.albumName)}, count: ${album?.count}`);
        if (album.lpath === SHARE_ALBUM_LPATH) {
          AlbumGridSortHelper.getInstance().setShareAlbumUri(album.albumUri);
        }
        if (album.count === 0) {
          Log.info(TAG, 'processSystemAlbumList continue for album.count = 0.');
          continue;
        }
        newList.push(album);
      }
      fetchResult.close();
    }
  }

  /* instrument ignore next */
  private async getSystemAlbums(accessHelper: PhotoAccessHelper): Promise<FetchAlbumResult[]> {
    // 由于数据库接口限制，若一次将四个相册查询出来，将不能够根据其 lpath 排序，所以一次查询一个，保证结果有序
    let fetchArray: Promise<FetchAlbumResult>[] = [];

    // 设置查询条件-根据 lpath 查询相册-分享（另外相机、截图、屏幕录制被移到系统相册处显示，来源相册这里不再显示）
    let sourceAlbum: string[] = DeviceInfo.isPc() ?
    this.sourceAlbumLPath : this.sourceAlbumLPathShow;
    for (const lpath of sourceAlbum) {
      let systemPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      systemPredicates.equalTo('lpath', lpath).notEqualTo('count', 0);
      let systemFetchOption: photoAccessHelper.FetchOptions = {
        predicates: systemPredicates,
        fetchColumns: [],
      };
      fetchArray.push(accessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE,
        Constants.SOURCE_QUERY_SUB_TYPE, systemFetchOption));
      Log.info(TAG, `getAlbums result is close ot not close.`);
    }
    const arr: FetchAlbumResult[] = await Promise.all(fetchArray);
    return arr;
  }

  /* instrument ignore next */
  public async buildUnionAlbumsInfo(param?: QueryParam): Promise<AlbumInfo[]> {
    let accessHelper = PhotoAccessHelperAccess.getPhotoAccessHelper(this.context);
    let fetchAlbumResult = await this.getUnionAlbums(accessHelper);
    let unionAlbumList: PhotoAlbum[][] = [];
    await this.processUnionAlbum(fetchAlbumResult, unionAlbumList);
    let albumInfos: AlbumInfo[] = [];
    for (let i = 0; i < unionAlbumList.length; i++) {
      let albumInfo = await this.buildUnionAlbumInfoWithFilter(unionAlbumList[i], param);
      if (albumInfo) {
        albumInfos.push(albumInfo);
      }
    }
    accessHelper.release();
    return albumInfos;
  }

  public async getSourceAlbumsCount(): Promise<number> {
    Log.info(TAG, 'getSourceAlbumsCount start');
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined;
    try {
      const startTime: number = Date.now();
      accessHelper = PhotoAccessHelperAccess.getPhotoAccessHelper(this.context);
      const fetchResults = await Promise.all([
        this.getSourceAlbumsExceptUnionAlbum(accessHelper),
        this.getUnionAlbums(accessHelper),
      ]);
      fetchResult = fetchResults[0];
      const albums: PhotoAlbum[] = await fetchResult?.getAllObjects();
      let unionAlbumFetchResult: FetchAlbumResult[] = fetchResults[1];
      let unionAlbumList: PhotoAlbum[][] = [];
      await this.processUnionAlbum(unionAlbumFetchResult, unionAlbumList);
      const count: number = albums?.length + unionAlbumList.length;
      Log.info(TAG, `getSourceAlbumsCount: ${count}, unionAlbumList length: ${unionAlbumList.length}, ` +
        `cost time: ${Date.now() - startTime}`);
      return count;
    } catch (err) {
      Log.error(TAG, `Get Source Object exception! msg: ${err}, code: ${err?.code}`);
    } finally {
      accessHelper?.release();
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    return 0;
  }

  private async getSourceAlbumsExceptUnionAlbum(accessHelper: PhotoAccessHelper): Promise<FetchAlbumResult> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let excludeList: string[] = [];

    if (!DeviceInfo.isPc()) {
      // 由于相机、截图、录屏被挪走，和系统相册、用户相册显示到顶部，计算总数时需要排除掉
      excludeList.push(...UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST);
    }

    predicates.notIn('lpath', excludeList).and().notEqualTo('count', 0);
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [],
    };
    const res: FetchAlbumResult =
      await accessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE, Constants.SOURCE_QUERY_SUB_TYPE, fetchOption);
    return res;
  }

  private async getUnionAlbums(accessHelper: PhotoAccessHelper): Promise<FetchAlbumResult[]> {
    let fetchArray: Promise<FetchAlbumResult>[] = [];

    const arr: FetchAlbumResult[] = await Promise.all(fetchArray);
    return arr;
  }

  private async processUnionAlbum(allFetchResult: FetchAlbumResult[], unionAlbumList: PhotoAlbum[][]): Promise<void> {
    for (let fetchResult of allFetchResult) {
      let subAlbumList: PhotoAlbum[] = [];
      const count: number = fetchResult.getCount();
      if (count === 0) {
        fetchResult.close();
        Log.info(TAG, `fetchResult is close.`);
        continue;
      }

      const albums: PhotoAlbum[] = await fetchResult.getAllObjects();
      for (const album of albums) {
        Log.debug(TAG, `UnionAlbum-AlbumName: ${AlbumDefine.getAnonymizeAlbumName(
          album.albumName)}, count: ${album.count} uri: ${album.albumUri}`);
        if (album.count > 0) {
          subAlbumList.push(album);
        }
      }
      if (subAlbumList.length > 0) {
        unionAlbumList.push(subAlbumList);
      }
      fetchResult.close();
      Log.info(TAG, `fetchResult is close.`);
    }
    Log.info(TAG, `processUnionAlbum, valid count:  ${unionAlbumList.length}`)
  }

  private async buildUnionAlbumInfo(albums: PhotoAlbum[], filterMediaType?: string): Promise<AlbumInfo | undefined> {
    if (albums.length === 0) {
      return undefined;
    }
    const albumInfo: AlbumInfo = new AlbumInfo(albums[0]);
    albumInfo.setAlbumName(albums[0].albumName);

    // 处理count, videoCount, cover，特别是 filterMediaType 存在的情况
    const count: number = albums.reduce((count: number, album: PhotoAlbum): number => count + album.count, 0);
    const videoCount: number = albums.reduce((count: number, album: PhotoAlbum):
      number => count + (album.videoCount ?? 0), 0);
    albumInfo.setCount(filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE ? count - videoCount : count);
    albumInfo.setVideoCount(videoCount);
    albumInfo.setFilterMediaType(filterMediaType ?? '');
    await this.setAlbumCoverFromAlbums(albums, albumInfo, filterMediaType);

    albumInfo.setAlbumCount(albums.length);
    const unionAlbumUris: string[] = albums.map((album: PhotoAlbum): string => album.albumUri);
    albumInfo.setUnionAlbumUris(unionAlbumUris);

    return albumInfo;
  }

  private async buildUnionAlbumInfoWithFilter(albums: PhotoAlbum[], param?: QueryParam):
    Promise<AlbumInfo | undefined> {
    if (albums.length === 0) {
      return undefined;
    }
    const albumInfo: AlbumInfo = new AlbumInfo(albums[0]);

    // 处理count, videoCount, cover，特别是 filterMediaType 存在的情况
    let count = 0;
    let coverUris: string[] = [];
    let photoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
    for (let album of albums) {
      let albumCountAndPhotoAsset: AlbumCountAndPhotoAsset =
        await this.userFileManagerAccess.getAlbumAssetCountAndPhotoAsset(album, param);
      let tmpCount = albumCountAndPhotoAsset.getCount();
      count += tmpCount;
      let photoAssets = albumCountAndPhotoAsset.getAsset();
      coverUris.push(photoAssets?.uri ?? '');
    }
    photoAsset = await this.userFileManagerAccess.getPhotoAssetByUri(coverUris[0]);
    albumInfo.setCount(count);
    albumInfo.setFilterMediaType(param?.filterMediaType ?? '');
    albumInfo.setSubtype(param?.filterConditions?.mediaType ?? 0);
    if (photoAsset) {
      this.setAlbumCover(albumInfo, photoAsset);
    }

    albumInfo.setAlbumCount(albums.length);
    const unionAlbumUris: string[] = albums.map((album: PhotoAlbum): string => album.albumUri);
    albumInfo.setUnionAlbumUris(unionAlbumUris);

    return albumInfo;
  }

  private async buildAlbumsInfo(albums: PhotoAlbum[], filterMediaType?: string): Promise<AlbumInfo[]> {
    let coverFileIdList: number[] = await Promise.all(albums.map(async (album: PhotoAlbum) => {
      return AlbumDefine.getFileIdFromUri(album.coverUri ?? '') ?? Number.NaN;
    }));
    let fetchOpt = AlbumDefine.getFileFetchOptByUriList(coverFileIdList);
    return await Promise.all(albums
      .map(async (album: PhotoAlbum, index: number) => {
        const albumInfo = new AlbumInfo(album);
        albumInfo.setVideoCount(album.videoCount ?? 0);
        albumInfo.setCount(filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE ?
          (album.count - (album.videoCount ?? 0)) : album.count);
        return albumInfo;
      }))
  }

  private async buildAlbumInfoWithFilter(album: PhotoAlbum, param?: QueryParam): Promise<AlbumInfo> {
    const albumInfo = new AlbumInfo(album);
    let videoCount: number = album.videoCount ?? 0;
    let count: number = album.count;
    let tempResult: AlbumCountAndPhotoAsset =
      await this.userFileManagerAccess.getAlbumAssetCountAndPhotoAsset(album, param);
    count = tempResult.getCount();
    albumInfo.setCount(count);
    albumInfo.setVideoCount(videoCount);
    let coverAssets = tempResult.getAsset();
    if (coverAssets) {
      this.setAlbumCover(albumInfo, coverAssets);
    }
    return albumInfo;
  }
}