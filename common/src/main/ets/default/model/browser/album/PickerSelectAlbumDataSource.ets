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

import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { FilterConditions } from '../../../model/FilterConditions';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { Log } from '../../../utils/Log';
import lazy { AbsDataSource } from '../AbsDataSource';
import lazy { Constants } from '../../common/Constants';
import lazy { AlbumDefine } from '../AlbumDefine';
import type { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import lazy { common } from '@kit.AbilityKit';
import lazy { PickerAlbumDataImplAsync, PickerAlbumDataParam } from './PickerAlbumDataImplAsync';
import lazy { LoadingInfo, LoadingTask } from '../../DataSource';
import lazy { FetchOptions, PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { MediaItem } from '../photo/MediaItem';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { FILTER_MEDIA_TYPE_ALL } from '../../common/SelectParams';
import lazy { PickerAlbumInfo } from './PickerAlbumInfo';
import lazy taskPool from '@ohos.taskpool';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { getScreen } from '../../common/ScreenManager';

/* instrument ignore file */
const TAG: string = 'PickerSelectAlbumDataSource';

@Concurrent
async function getItemsTask(context: common.Context, userId: number, isPickerUsedSubwindow: boolean, isFirst: boolean,
  rowCount:number, queryParam: QueryParam): Promise<void> {
  let requestTime: number = Date.now();
  let pickerAlbumDataParam: PickerAlbumDataParam = {
    isPickerUsedSubwindow: isPickerUsedSubwindow,
    isFirst: isFirst,
    rowCount: rowCount,
    userId: userId,
  }
  let albumDataImpl: PickerAlbumDataImplAsync = new PickerAlbumDataImplAsync(pickerAlbumDataParam, context);
  let callback: Function = (mediaSetList: PickerAlbumInfo[]) => {
    taskPool.Task.sendData(requestTime, mediaSetList);
  };
  albumDataImpl.getData(callback, queryParam);
}

export class PickerSelectAlbumDataSource extends AbsDataSource<PickerAlbumInfo> {
  private static readonly ROW_HEIGHT: number = 64;
  public albums: PickerAlbumInfo[] = [];
  private broadCast_: BroadCast;
  private queryParam: QueryParam;
  private showAllAlbumInfo: boolean = false;
  private albumInfoAll: PickerAlbumInfo = new PickerAlbumInfo();
  private blackList: string[] = [];
  private deviceId = '';
  private requestTask?: taskPool.Task;
  private context: common.Context;
  private isPickerUsedSubwindow: boolean;
  private rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private userId: number;
  private rowCount: number;

  public constructor(broadCast: BroadCast, context: common.Context, queryParams: QueryParam, userId?: number,
    isPickerUsedSubwindow?: boolean,) {
    super();
    this.broadCast_ = broadCast;
    this.context = context;
    this.queryParam = queryParams;
    this.userId = userId ?? -1;
    this.isPickerUsedSubwindow = isPickerUsedSubwindow ?? false;
    this.rowCount = Math.ceil(getScreen().getWinHeight() / PickerSelectAlbumDataSource.ROW_HEIGHT) ?? 0;
  }

  public initData(): void {
    TraceControllerUtils.startTrace('AlbumSetPageInitData');
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  public async setShowAllAlbumInfo(): Promise<void> {
    this.showAllAlbumInfo = true;
  }

  public cancelLoadData(): void {
    if (this.requestTask && !this.requestTask.isDone()) {
      taskPool.cancel(this.requestTask);
    }
  }

  private async setAllAlbumInfo(): Promise<void> {
    let filterMediaType: string = this.queryParam?.filterMediaType ?? FILTER_MEDIA_TYPE_ALL;
    let countFetchOpt: FetchOptions =
      AlbumDefine.getFileFetchOpt(undefined, undefined, filterMediaType, undefined);
    AlbumDefine.setFilterConditions(countFetchOpt, this.queryParam?.filterConditions);
    let count: number = await UserFileManagerAccess.getInstance().getCount(countFetchOpt, TAG);
    if (count < 1) {
      return;
    }
    this.albumInfoAll.count = count;
    let mediaItem: MediaItem | undefined =
      await this.getFirstObject(filterMediaType, this.queryParam?.filterConditions);
    if (mediaItem) {
      this.albumInfoAll.coverUri = mediaItem.thumbnail;
    }
    this.albumInfoAll.uri = Constants.ALBUM_URI_ALL_MEDIA;
    this.albumInfoAll.albumName = this.rsc.toString($r('app.string.pictures_and_videos'));
    if (this.albums && this.albums.length === 0) {
      return;
    }
    if (this.albums[0].uri === Constants.ALBUM_URI_ALL_MEDIA) {
      this.albums[0] = this.albumInfoAll;
    } else {
      this.albums.unshift(this.albumInfoAll);
    }
    Log.info(TAG, `getAllAlbumInfo finish : ${this.albums[0].count}`);
    this.onDataReloaded();
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

  public loadData(): void {
    Log.info(TAG, 'try to loadData');
    if (this.requestTask && !this.requestTask.isDone()) {
      taskPool.cancel(this.requestTask);
    }
    if (this.showAllAlbumInfo) {
      this.setAllAlbumInfo();
    }

    this.requestTask = new taskPool.Task(getItemsTask, this.context, this.userId, this.isPickerUsedSubwindow,
      this.albums.length === 0, this.rowCount, this.queryParam);
    this.requestTask.onReceiveData((requestTime: number, newAlbums: PickerAlbumInfo[]) => {
      this.updateAlbumSetData(requestTime, newAlbums);
    });
    taskPool.execute(this.requestTask);

  }

  totalCount(): number {
    let newTotalCount = this.albums.length;
    Log.debug(TAG, `totalCount: ${newTotalCount}`);
    if (this.lastTotalCount !== newTotalCount) {
      this.lastTotalCount = newTotalCount;
    }
    return newTotalCount;
  }

  public getData(index: number): PickerAlbumInfo | undefined {
    if (index < 0 || index >= this.albums.length) {
      Log.error(TAG, `index out of the total size, index: ${index} total size: ${this.albums.length}`);
      return undefined;
    }
    return this.albums[index];
  }

  public updateAlbumSetData(requestTime: number, newAlbums: PickerAlbumInfo[]): void {
    Log.info(TAG, `updateMediaItems size: ${newAlbums.length}`);
    this.lastUpdateTime = requestTime;
    if (this.lastUpdateTime < this.lastRequestTime && this.isActive) {
      // If there is a new media library change callback,
      // the query continues and the current data is updated without return.
      Log.debug(TAG, 'request data expired, request again!');
      this.loadData();
      return;
    }
    this.hasNewChange = false;
    this.albums = this.excludeBlackList(newAlbums);
    if (this.showAllAlbumInfo && this.albumInfoAll.count > 0) {
      this.albums.unshift(this.albumInfoAll);
    }
    this.onDataReloaded();

    Log.info(TAG, 'data reloaded finish');
    TraceControllerUtils.finishTrace('AlbumSetPageInitData');
    this.broadCast_?.emit(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, [this.totalCount()]);
    Log.debug(TAG, 'Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE updateAlbumPhotoInfo');
  }

  public excludeBlackList(originAlbums: PickerAlbumInfo[]): PickerAlbumInfo[] {
    if (!originAlbums || !this.blackList || this.blackList.length === 0) {
      return originAlbums;
    }
    originAlbums.filter((item): boolean => {
      return this.blackList.indexOf(item.uri) < 0;
    });
    return originAlbums;
  }

  onNotify(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `thirdSelect onNotify for albumDataSource with ${nfyInfo.type}`);
    if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD) {
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

  public setBlackList(albums: string[]): void {
    this.blackList = albums;
    Log.debug(TAG, `BlackList: set blacklist ${JSON.stringify(this.blackList)}.`);
  }

  public getQueryParams(): QueryParam {
    return this.queryParam;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<PickerAlbumInfo> | undefined {
    return undefined;
  }
}
