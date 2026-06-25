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
import lazy { PickerAlbumInfo, PICKER_ALBUM_FETCH_COLUMNS } from './PickerAlbumInfo';
import lazy { AlbumInfo } from './AlbumInfo';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { BrowserDataImpl } from '../BrowserDataImpl';
import lazy { Log } from '../../../utils/Log';
import type { FetchOptions, PhotoAlbum } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess, toString, PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { SourceTypeAlbumDataImpl } from './SourceTypeAlbumDataImpl';
import lazy { common } from '@kit.AbilityKit';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { AssetHelper } from '../../../utils/AssetHelper';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { PickerAlbumsFilterEnhanceBuilder } from '../../PickerFilterEnhanceBuilder';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Constants } from '../../common/Constants';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_AlbumThirdSelectDataImpl';

export interface PickerAlbumDataParam {
  isPickerUsedSubwindow: boolean;
  isFirst: boolean;
  rowCount: number;
  userId: number;
}

export class PickerAlbumDataImplAsync extends BrowserDataImpl {
  private static readonly BATCH_COUNT: number = 100;
  private context: common.Context | undefined = undefined;
  private userFileManagerAccess: UserFileManagerAccess;
  private albumDataParam: PickerAlbumDataParam;
  private rsc: RscGetter;

  constructor(albumDataParam: PickerAlbumDataParam, context?: common.Context) {
    super();
    this.context = context ?? getContext();
    this.albumDataParam = albumDataParam;
    this.rsc = new RscGetter(this.context.resourceManager);
    this.userFileManagerAccess = new UserFileManagerAccess(this.albumDataParam.userId);
    this.userFileManagerAccess.onCreate(this.context);
  }

  public getData(callback: Function, param: QueryParam): void {
    this.buildAlbums(callback, param);
  }

  public async getDataByUri(uri: string): Promise<PhotoAlbum | undefined> {
    let albums = await this.userFileManagerAccess.getUserAlbums(AlbumDefine.getAlbumFetchOptByUri(uri));
    if (albums?.length > 0) {
      return albums[0];
    } else {
      return undefined;
    }
  }

  public async getDataByName(name: string, albumUri?: string): Promise<PhotoAlbum | undefined> {
    let albums = await this.userFileManagerAccess.getUserAlbums(AlbumDefine.getAlbumFetchOptByName(name));
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

  public getDataCount(callback: AsyncCallback<PickerAlbumInfo>, pickerAlbumInfo: PickerAlbumInfo): void {
  }

  protected async buildAlbums(callback: Function, param?: QueryParam): Promise<void> {
    Log.info(TAG, `buildAlbums, param: ${param?.filterConditions === undefined}`);
    TraceControllerUtils.startTrace('buildAlbumsNew');
    let photoAlbums: PhotoAlbum[] = [];
    let deviceIsolation: boolean = DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen();
    if (deviceIsolation) {
      photoAlbums = await this.userFileManagerAccess.getAllSortedAlbums({
        start: param?.start,
        count: param?.count
      })
    } else {
      photoAlbums = await this.getSystemPhotoAlbum();
      photoAlbums = photoAlbums.concat(await this.getUserPhotoAlbum());
      photoAlbums = photoAlbums.concat(await this.getSourcePhotoAlbum());
    }
    Log.info(TAG, `buildAlbums getBaseAlbums finsih size : ${photoAlbums.length}`);
    let pickerAlbumInfos: PickerAlbumInfo[] = [];
    let albumBatchArray: PhotoAlbum[][] = this.splitRequestBatches(photoAlbums);
    // 维护已处理融合相册分组的集合
    let processedGroups: Set<number> = new Set<number>();

    for (let albumBatch of albumBatchArray) {
      await this.getAlbums(albumBatch, pickerAlbumInfos, processedGroups, param);
      if (this.albumDataParam.isFirst) {
        callback(pickerAlbumInfos);
      }
    }
    if (!deviceIsolation) {
      let unionPickerAlbumInfos: PickerAlbumInfo[] = await this.getUnionPickerAlbumInfo(param);
      if (unionPickerAlbumInfos.length !== 0) {
        pickerAlbumInfos = pickerAlbumInfos.concat(unionPickerAlbumInfos);
      }
    }
    callback(pickerAlbumInfos);
    TraceControllerUtils.finishTrace('buildAlbumsNew');
  }

  private async getAlbumDetailInfo(album: PhotoAlbum, param?: QueryParam): Promise<PickerAlbumInfo | undefined> {
    if (!album) {
      Log.error(TAG, 'getAlbumDetailInfo album null');
      return undefined;
    }
    let fetchOptionBuilder = new PickerAlbumsFilterEnhanceBuilder();
    fetchOptionBuilder.setFilterParam(param)
      .setColumn(PICKER_ALBUM_FETCH_COLUMNS)
      .order(this.getOrderNameByAlbum(album), false)
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      albumFetchResult = await album.getAssets(fetchOptionBuilder.build());
      let assets: PhotoAsset = await albumFetchResult.getFirstObject();
      if (!assets) {
        return undefined;
      }
      return this.getPickerAlbumInfo(album, assets);
    } catch (error) {
      Log.error(TAG, `Error in getAlbumDetailInfo: ${error.code}, ${error.message}`);
      return undefined;
    } finally {
      albumFetchResult?.close();
    }
  }

  private getPickerAlbumInfo(album: PhotoAlbum, assets: PhotoAsset): PickerAlbumInfo {
    let resCount: number = Number(AssetHelper.get(assets, UserFileManagerAccess.GROUP_BY_KEY, 0));
    let pickerAlbumInfo: PickerAlbumInfo = new PickerAlbumInfo(album);
    pickerAlbumInfo.count = resCount;
    if (!pickerAlbumInfo.isSystemAlbum) {
      pickerAlbumInfo.albumName = album.albumName;
    } else {
      pickerAlbumInfo.albumName = this.rsc.toString(AlbumDefine.getAlbumNameResource(album));
    }
    let dataModifiedKey: string = photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString();
    let dataModifiedTime: number = Number(AssetHelper.get(assets, dataModifiedKey, 0));
    let path: string = String(AssetHelper.get(assets, Constants.KEY_FILE_DATA, ''));
    pickerAlbumInfo.coverUri = ImageUtil.getThumbnailAstcUri(assets.uri, path, dataModifiedTime);
    return pickerAlbumInfo;
  }

  private splitRequestBatches(photoAlbums: PhotoAlbum[]): PhotoAlbum[][] {
    let albumBatches: PhotoAlbum[][] = [];
    if (!photoAlbums) {
      return albumBatches;
    }
    let albumCount: number = 0;
    if (this.albumDataParam.isFirst && this.albumDataParam.rowCount > 0) {
      albumCount = Math.min(this.albumDataParam.rowCount, photoAlbums.length);
      albumBatches.push(photoAlbums.slice(0, albumCount));
      if (albumBatches[0].length === photoAlbums.length) {
        return albumBatches;
      }
    }
    for (let i = albumCount; i < photoAlbums.length; i += PickerAlbumDataImplAsync.BATCH_COUNT) {
      albumBatches.push(photoAlbums.slice(i, i + PickerAlbumDataImplAsync.BATCH_COUNT));
    }
    return albumBatches;
  }

  private async getUnionPickerAlbumInfo(param?: QueryParam): Promise<PickerAlbumInfo[]> {
    let albumInfos: AlbumInfo[] =
      await new SourceTypeAlbumDataImpl(this.context ?? getContext()).buildUnionAlbumsInfo(param);
    let pickerAlbumInfos: PickerAlbumInfo[] = [];
    albumInfos.forEach((albumInfo: AlbumInfo) => {
      if (albumInfo.count > 0) {
        let pickerAlbumInfo: PickerAlbumInfo = new PickerAlbumInfo();
        pickerAlbumInfo.convertFromAlbumInfo(albumInfo);
        pickerAlbumInfos.push(pickerAlbumInfo);
      }
    });
    return pickerAlbumInfos;
  }

  private async getAlbums(photoAlbums: PhotoAlbum[], pickerAlbumInfos: PickerAlbumInfo[], processedGroups: Set<number>,
    param?: QueryParam): Promise<PickerAlbumInfo[]> {
    if (!pickerAlbumInfos) {
      pickerAlbumInfos = [];
    }
    if (!photoAlbums || photoAlbums.length === 0) {
      return pickerAlbumInfos;
    }
    let otherAlbumsMap: Map<string, PhotoAlbum> = new Map<string, PhotoAlbum>();
    let otherAlbumIds: string[] = [];
    await this.packSystemAlbums(photoAlbums, pickerAlbumInfos, otherAlbumIds, otherAlbumsMap, processedGroups, param);
    await this.packCommonAlbums(pickerAlbumInfos, otherAlbumIds, otherAlbumsMap, param);
    this.resortAlbums(photoAlbums, pickerAlbumInfos);
    Log.info(TAG, `getAlbum pickerAlbumInfos is ${pickerAlbumInfos.length}`);
    return pickerAlbumInfos;
  }

  private async packSystemAlbums(photoAlbums: PhotoAlbum[], pickerAlbumInfos: PickerAlbumInfo[],
    otherAlbumIds: string[], otherAlbumsMap: Map<string, PhotoAlbum>, processedGroups: Set<number>,
    param?: QueryParam): Promise<void> {
    for (let i = 0; i < photoAlbums.length; i++) {
      let album: PhotoAlbum = photoAlbums[i];
      let lpath: string | undefined = album?.lpath?.trim();
      let unionAlbumGroupIndex: number | undefined = undefined;
      if (!album) {
        continue;
      }
      if (AlbumDefine.isSystemAlbum(album.albumType)) {
        let pickerAlbumInfo: PickerAlbumInfo | undefined = await this.getAlbumDetailInfo(album, param);
        if (!pickerAlbumInfo) {
          continue;
        }
        if (pickerAlbumInfo.count > 0 || (this.albumDataParam.isPickerUsedSubwindow &&
          (pickerAlbumInfo.isPhotoAlbum || pickerAlbumInfo.isVideoAlbum))) {
          pickerAlbumInfos.push(pickerAlbumInfo);
        }
      } else if (unionAlbumGroupIndex !== undefined) {
        // 融合相册处理
        if (processedGroups.has(unionAlbumGroupIndex)) {
          // 标记该分组已处理
          continue;
        }
        // 标记该分组已处理
        processedGroups.add(unionAlbumGroupIndex);
      } else {
        let albumCount: number = this.getAlbumResCount(album, param);
        if (albumCount === 0) {
          continue;
        }
        let albumId: string = this.getAlbumId(album);
        otherAlbumsMap.set(albumId, album);
        otherAlbumIds.push(albumId);
      }
    }
  }

  private async packCommonAlbums(pickerAlbumInfos: PickerAlbumInfo[], otherAlbumIds: string[],
    otherAlbumsMap: Map<string, PhotoAlbum>, param?: QueryParam): Promise<void> {
    if (!otherAlbumIds || otherAlbumIds.length === 0) {
      return;
    }
    let fetchOptions: FetchOptions = this.getBatchRequestAlbumOption(otherAlbumIds,
      UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString(), param);
    let result: PhotoAsset[] = await this.userFileManagerAccess.getAllObject(fetchOptions);
    for (let i = 0; i < result.length; i++) {
      let photoAsset: PhotoAsset = result[i];
      let albumId: string = String(AssetHelper.get(photoAsset, 'owner_album_id', ''));
      if (!otherAlbumsMap.has(albumId)) {
        continue;
      }
      let album: PhotoAlbum | undefined = otherAlbumsMap.get(albumId);
      if (!album) {
        continue;
      }
      let pickerAlbumInfo: PickerAlbumInfo = this.getPickerAlbumInfo(album, photoAsset);
      if (!pickerAlbumInfo || pickerAlbumInfo.count === 0) {
        continue;
      }
      pickerAlbumInfos.push(pickerAlbumInfo);
    }
  }

  /**
   * 根据albums的顺序重新排序
   * @param photoAlbums 原始相册列表
   * @param pickerAlbumInfos 需要重排的列表
   */
  /* instrument ignore next */
  private resortAlbums(photoAlbums: PhotoAlbum[], pickerAlbumInfos: PickerAlbumInfo[]): void {
    if (pickerAlbumInfos.length === 0) {
      return;
    }
    let newSequence = pickerAlbumInfos.sort((a, b) => photoAlbums.findIndex(o => o.albumUri ===
    a.uri) - photoAlbums.findIndex(o => o.albumUri === b.uri));
    pickerAlbumInfos = newSequence;
  }

  /**
   * 获取albumId，当前媒体库未开放，需要从albumUri中截取
   * @param photoAlbum
   * @returns
   */
  private getAlbumId(photoAlbum: PhotoAlbum): string {
    let regexString: string = 'file://media/PhotoAlbum/';
    let albumId: string = '';
    if (photoAlbum.albumUri.startsWith(regexString)) {
      albumId = photoAlbum.albumUri.substring(regexString.length, photoAlbum.albumUri.length);
    }
    return albumId;
  }

  private getBatchRequestAlbumOption(ownAlbumIds: string[], orderBy: string, param?: QueryParam): FetchOptions {
    let fetchOptionBuilder = new PickerAlbumsFilterEnhanceBuilder();
    fetchOptionBuilder.setFilterParam(param)
      .setColumn(PICKER_ALBUM_FETCH_COLUMNS)
      .order(orderBy, false)
      .setOwnAlbumIds(ownAlbumIds)
      .groupBy(['owner_album_id']);
    return fetchOptionBuilder.build();
  }

  private getOrderNameByAlbum(album: PhotoAlbum): string {
    return (PhotoAccessHelperAccess.isVideoAlbum(album) || PhotoAccessHelperAccess.isPhotoAlbum(album)) ?
      UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString() :
      UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
  }

  private getAlbumResCount(album: PhotoAlbum, param?: QueryParam): number {
    if (!param) {
      return album.count;
    }
    if (param.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
      return album.videoCount ?? 0;
    }
    return album.count;
  }

  private async getSourcePhotoAlbum(): Promise<PhotoAlbum[]> {
    if (!this.context) {
      Log.info(TAG, 'context is undefined.');
      return [];
    }
    let pickerAlbumInfos: PhotoAlbum[] =
      await new SourceTypeAlbumDataImpl(this.context).buildSourcePhotoAlbums();
    return pickerAlbumInfos;
  }

  private async getSystemPhotoAlbum(): Promise<PhotoAlbum[]> {
    let albums: PhotoAlbum[] = await this.userFileManagerAccess?.getSystemAlbums();
    for (let lpath of UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST) {
      let photoAlbums: PhotoAlbum[] = await this.userFileManagerAccess?.getSystemSourceAlbums(lpath);
      if (photoAlbums.length > 0 && photoAlbums[0].count > 0) {
        albums.push(photoAlbums[0]);
      }
    }
    return albums;
  }

  private async getUserPhotoAlbum(): Promise<PhotoAlbum[]> {
    let pickerAlbumInfos: PhotoAlbum[] = await this.userFileManagerAccess?.getUserAlbums();
    return pickerAlbumInfos;
  }

  public getDataIndexByUri(callback: AsyncCallback, param: QueryParam, uri: string): void {
  }

  public getDataIndexById(callback: AsyncCallback, param: QueryParam, id: number): void {
  }

  public getMediaItemByUri(callback: AsyncCallback | Function, uri: string): void {
  }
}