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

import lazy { AlbumThirdSelectCallback } from './AlbumThirdSelectCallback';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import type { FilterConditions } from '../../../model/FilterConditions';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumInfo } from './AlbumInfo';
import lazy { AbsDataSource } from '../AbsDataSource';
import lazy { Constants } from '../../common/Constants';
import lazy { AlbumSetDataInfo } from '../../common/AlbumSetDataInfo';
import lazy { AlbumDefine } from '../AlbumDefine';
import type { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import lazy { common } from '@kit.AbilityKit';
import lazy { AlbumThirdSelectDataImpl } from './AlbumThirdSelectDataImpl';
import lazy { LoadingInfo, LoadingTask } from '../../DataSource';
import lazy { FetchOptions, PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { MediaItem } from '../photo/MediaItem';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { SelectParams } from '../../common/SelectParams';

/* instrument ignore file */
const TAG: string = 'common_AlbumThirdSelectDataSource';

export class AlbumListInfo {
  private title: string;
  private albums: AlbumInfo[];

  constructor(title: string, albums: AlbumInfo[]) {
    this.title = title;
    this.albums = albums;
  }

  getHashCode(): string {
    return `${this.title}_${this.albums}`;
  }
}

export class AlbumThirdSelectDataSource extends AbsDataSource<AlbumInfo> {
  public mediaSetList: AlbumInfo[] = [];
  public mediaAlbumList: AlbumInfo[] = [];
  protected albumDataImpl: BrowserDataInterface;
  private isMultiParameter: boolean = false;
  private broadCast_: BroadCast;
  private filterMediaType: string = '';
  private queryParam: QueryParam | undefined = undefined;
  private blackList: string[] = [];
  private deviceId = '';
  private filterAlbumsFunction: Function = (mediaSetList: AlbumInfo[]): AlbumInfo[] => {
    return mediaSetList;
  };
  private callback: AlbumThirdSelectCallback = new AlbumThirdSelectCallback(this);
  private isPickerUsedSubwindow: boolean = false;

  public constructor(broadCast: BroadCast, context: common.Context, userId?: number, isPickerUsedSubwindow?: boolean,
    queryParam?: QueryParam) {
    super();
    this.tag = TAG;
    Log.debug(TAG, 'constructor');
    this.broadCast_ = broadCast;
    if (isPickerUsedSubwindow) {
      this.isPickerUsedSubwindow = isPickerUsedSubwindow;
    }
    if (queryParam) {
      this.queryParam = queryParam;
    }
    this.albumDataImpl = new AlbumThirdSelectDataImpl(context, userId, isPickerUsedSubwindow);
  }

  initData(): void {
    TraceControllerUtils.startTrace('AlbumSetPageInitData');
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  public cancelLoadData(): void {
    (this.albumDataImpl as AlbumThirdSelectDataImpl)?.cancelLoadData();
  }

  public async getAllAlbumInfo(params: SelectParams): Promise<AlbumInfo> {
    let albumInfo: AlbumInfo = new AlbumInfo();
    let countFetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOpt(undefined, undefined, params.filterMediaType, undefined);
    AlbumDefine.setFilterConditions(countFetchOpt, this.queryParam?.filterConditions);
    let count: number = await UserFileManagerAccess.getInstance().getCount(countFetchOpt, TAG);
    albumInfo.count = count;
    let mediaItem: MediaItem | undefined =
      await this.getFirstObject(params.filterMediaType, this.queryParam?.filterConditions);
    if (mediaItem) {
      albumInfo.coverUri = mediaItem.thumbnail;
    }
    Log.info(TAG, 'getAllAlbumInfo finish');
    return albumInfo;
  }

  public async getFirstObject(filterMediaType: string,
    filterConditions?: FilterConditions): Promise<MediaItem | undefined> {
    let fetchOpt: FetchOptions = AlbumDefine.getFileFetchOptWithDateColumn(0, 1, filterMediaType,
      UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString());
    AlbumDefine.setFilterConditions(fetchOpt, filterConditions);
    let photoAssets: PhotoAsset[] | undefined = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt, TAG);
    if (!photoAssets) {
      return undefined;
    }
    let mediaItem: MediaItem = new MediaItem(photoAssets[0]);
    mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(), false,
      mediaItem.getThumbnailReady()));
    return mediaItem;
  }

  loadData(): void {
    Log.info(TAG, 'load data');
    if (!this.albumDataImpl) {
      return;
    }
    this.callback.updateTime();
    // filterConditions存在时，优先过滤filterConditions
    if ((this.queryParam !== undefined) && (this.queryParam.filterConditions !== undefined)) {
      this.albumDataImpl.getData(this.callback, this.queryParam);
      return;
    }
    this.albumDataImpl.getData(this.callback,
      this.filterMediaType ? { filterMediaType: this.filterMediaType } : undefined);
  }

  totalCount(): number {
    let newTotalCount = this.mediaAlbumList.length;
    Log.debug(TAG, `totalCount: ${newTotalCount}`);
    if (this.lastTotalCount !== newTotalCount) {
      this.lastTotalCount = newTotalCount;
    }
    return newTotalCount;
  }

  setMultiParameter(isMultiParameter: boolean): void {
    this.isMultiParameter = isMultiParameter;
  }

  public getData(index: number): AlbumSetDataInfo | undefined {
    Log.info(TAG, `getData size: ${
    this.mediaAlbumList.length} index: ${index}, item: ${JSON.stringify(this.mediaAlbumList[index])}`);
    if (index < 0 || index >= this.mediaAlbumList.length) {
      Log.error(TAG, `index out of the total size, index: ${index} total size: ${this.mediaAlbumList.length}`);
      return undefined;
    }
    return new AlbumSetDataInfo(this.mediaAlbumList[index], index);
  }

  updateAlbumSetData(requestTime: number, mediaSetList: AlbumInfo[]): void {
    TraceControllerUtils.startTraceWithTaskId('updateAlbumSetData', requestTime);
    Log.info(TAG, `updateMediaItems size: ${mediaSetList.length}`);
    this.lastUpdateTime = requestTime;
    if (this.lastUpdateTime < this.lastRequestTime && this.isActive) {
      // If there is a new media library change callback,
      // the query continues and the current data is updated without return.
      Log.debug(TAG, 'request data expired, request again!');
      this.loadData();
    } else {
      this.hasNewChange = false;
    }
    this.mediaSetList = this.excludeBlackList(mediaSetList);

    TraceControllerUtils.finishTraceWithTaskId('updateAlbumSetData', requestTime);
    this.mediaAlbumList = [];

    for (let i = 0; i < this.mediaSetList.length; i++) {
      let albumInfo: AlbumInfo = this.mediaSetList[i];
      if (!albumInfo.isTrashAlbum) {
        if (this.isPickerUsedSubwindow &&
          (albumInfo.isVideoAlbum || albumInfo.isPhotoAlbum) &&
          albumInfo.count === 0) {
          this.mediaAlbumList.push(albumInfo);
          continue;
        }
        if ((this.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO && albumInfo.videoCount > 0) ||
          (this.filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_VIDEO && albumInfo.count > 0)) {
          this.mediaAlbumList.push(albumInfo);
        }
      }
    }
    this.onDataReloaded();
    Log.info(TAG, 'data reloaded finish');
    TraceControllerUtils.finishTrace('AlbumSetPageInitData');
    this.broadCast_?.emit(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, [this.totalCount()]);
    Log.debug(TAG, 'Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE updateAlbumPhotoInfo');
  }

  excludeBlackList(mediaSetList: AlbumInfo[]): AlbumInfo[] {
    let res: AlbumInfo[];
    Log.info(TAG, `excludeBlackList size: ${mediaSetList.length}`);
    if (this.blackList.length === 0) {
      Log.debug(TAG, 'BlackList: no black list.');
      res = mediaSetList;
    } else {
      Log.debug(TAG, `BlackList: albums name ${JSON.stringify(this.blackList)}.`);
      res = mediaSetList.filter((item): boolean => {
        return this.blackList.indexOf(item.uri) < 0;
      });
    }
    res = this.filterAlbumsFunction(res) ?? [];
    Log.debug(TAG, `BlackList: old albums length ${mediaSetList.length}, new albums length ${res.length}.`);
    return res;
  }

  onNotify(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `thirdSelect onNotify for albumDataSource with ${JSON.stringify(nfyInfo)}`);
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC) {
      Log.info(TAG, 'thirdSelect onNotify drop for MediaObserverNfyType.PHOTO_ADD_ASTC');
      return;
    }
    this.hasNewChange = false;
    super.onNotify(nfyInfo);
  }

  onChange(mediaType: string): void {
    if (!this.deviceId) {
      if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
        super.onChange(mediaType);
      }
    } else if (mediaType === 'remote') {
      super.onChange(mediaType);
    }
  }

  updateAlbumMediaCount(): void {
    for (let album of this.mediaSetList) {
      this.albumDataImpl.getDataCount(() => {
      }, album);
    }
  }

  setFilterMediaType(filterMediaType: string): void {
    Log.info(TAG, `set filterMediaType: ${filterMediaType}`);
    this.filterMediaType = filterMediaType;
  }

  setFilterParam(queryParam: QueryParam): void {
    Log.info(TAG, `set queryParam: ${queryParam}`);
    this.queryParam = queryParam;
  }

  setBlackList(albums: string[]): void {
    this.blackList = albums;
    Log.debug(TAG, `BlackList: set blacklist ${JSON.stringify(this.blackList)}.`);
  }

  setFilterAlbumsFunction(filterAlbumsFunction: Function): void {
    this.filterAlbumsFunction = filterAlbumsFunction;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    return undefined;
  }
}
