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
/* instrument ignore file*/
import lazy { QueryParam } from '../interface/BrowserDataInterface';
import lazy {
  AlbumDataSource,
  AlbumDataSourceParam,
  AlbumLoadingInfo,
  AlbumLoadingTask,
  AlbumLoadingTaskParams
} from './AlbumDataSource';
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { AsyncCallback } from './common/AsyncCallback';
import lazy { UnionAlbumPhotoDataImpl } from './browser/photo/UnionAlbumPhotoDataImpl';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { LoadingInfo, LoadingTask } from './DataSource';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { CommonContext, TimelineDataManager } from './browser/photo/TimelineDataManager';
import lazy collections from '@arkts.collections';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { Log } from '../utils/Log';
import lazy { AlbumDefine } from './browser/AlbumDefine';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { AlbumGridSortHelper } from '../model/AlbumGridSortHelper';

const TAG: string = 'common_UnionAlbumDataSource';

class UnionLoadingTask extends AlbumLoadingTask {
  public constructor(params: AlbumLoadingTaskParams) {
    super(params);
  }

  protected async loadDataCount(): Promise<number> {
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let param: QueryParam = {
      albumUri: loadingInfo?.albumInfo.uri ?? '',
      albumUris: loadingInfo.albumInfo.unionAlbumUris,
      filterMediaType: loadingInfo.filterMediaType ?? '',
    };
    return new Promise<number>((resolve) => {
      let asyncCallback: AsyncCallback<number> | undefined = {
        callback: (count: number, albumUri: string) => {
          asyncCallback = undefined;
          resolve(count);
        },
      };
      new UnionAlbumPhotoDataImpl().getDataCount(asyncCallback, param);
    });
  }

  protected async loadGroupData(): Promise<TimelineData[]> {
    let albumUris: string[] = (this.info as AlbumLoadingInfo)?.albumInfo.unionAlbumUris ?? [];
    if (albumUris.length === 0) {
      return [];
    }

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_TAKEN_MS);
    AlbumDefine.modifyPredicatesInAlbumUris(predicates, albumUris);
    predicates.groupBy([String(photoAccessHelper.PhotoKeys.DATE_DAY)]);

    let fetchOptions: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [String(photoAccessHelper.PhotoKeys.DATE_TAKEN_MS),
        String(photoAccessHelper.PhotoKeys.DATE_DAY), UserFileManagerAccess.GROUP_BY_KEY],
    } as photoAccessHelper.FetchOptions;
    let result: collections.Array<TimelineData> = new collections.Array<TimelineData>();

    const START_TIME: number = Date.now();
    const TRACE_TAG: string = 'TimelineDataManager.getResult';
    TraceControllerUtils.startTraceWithTaskId(TRACE_TAG, START_TIME);
    let dataArr: photoAccessHelper.PhotoAsset[] =
      await UserFileManagerAccess.getResult(this.params.context as CommonContext, fetchOptions, TAG);
    TimelineDataManager.parseGroupAssetData(dataArr, result);
    TraceControllerUtils.finishTraceWithTaskId(TRACE_TAG, START_TIME);

    Log.info(TAG, `loadGroupData: ${dataArr.length}`);
    return TimelineData.convertTimelineData(result);
  }

  protected async loadData(start: number, count: number): Promise<MediaItem[]> {
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let param: QueryParam = {
      albumUri: loadingInfo?.albumInfo.uri ?? '',
      albumUris: loadingInfo.albumInfo.unionAlbumUris,
      start: start,
      count: count,
      needThumbnailReady: loadingInfo.needThumbnailReady,
      filterMediaType: loadingInfo.filterMediaType,
    };
    if (!param.albumUris || param.albumUris.length <= 1){
      param.albumKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.params.albumInfo);
    }

    return new Promise<MediaItem[]>((resolve) => {
      let asyncCallback: AsyncCallback<MediaItem[]> | undefined = {
        callback: (items: MediaItem[], albumUri: string) => {
          asyncCallback = undefined;
          resolve(items);
        },
      };
      new UnionAlbumPhotoDataImpl().getData(asyncCallback, param);
    });
  }
}

export class UnionAlbumDataSource extends AlbumDataSource {
  private albumUris: string[] = [];

  public constructor(param: AlbumDataSourceParam) {
    super(param);
    this.tag = TAG;
    this.albumUris = param.albumInfo.unionAlbumUris.slice();
    this.albumUri = this.albumUris[0];
  }

  public getQueryParam(start: number, count: number): QueryParam {
    return {
      albumUri: this.albumUri,
      albumUris: this.albumUris,
      start: start,
      count: count,
      filterMediaType: this.filterMediaType,
    };
  }

  public buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    let task: LoadingTask<MediaItem> = new UnionLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      accurateUpdater: this.accurateUpdater,
      coldStartState: this.coldStartState,
      context: this.context,
      dataImpl: this.photoDataImpl,
      albumInfo: this.albumInfo ?? new AlbumInfo(),
      viewMode: this.viewMode,
    } as AlbumLoadingTaskParams);
    super.buildLoadingTask(info);
    return task;
  }
}
