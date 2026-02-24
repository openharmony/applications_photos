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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { PickerDataImplAsync } from './PickerDataImplAsync';
import lazy { PickerMediaDataSource } from './PickerMediaDataSource';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default//interface/BrowserDataInterface';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';

const TAG: string = 'PickerDataSourceManager';

export class PickerDataSourceManager {
  private photoDataImpl: PickerDataImplAsync;
  private dataSource: PickerMediaDataSource;

  public constructor(storage?: LocalStorage) {
    this.photoDataImpl = new PickerDataImplAsync(storage);
    this.dataSource = new PickerMediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.photoDataImpl);
  }

  public getDataImpl(): PickerDataImplAsync {
    return this.photoDataImpl;
  }

  public getDataSource(): PickerMediaDataSource {
    return this.dataSource;
  }

  public initDataWithType(filterMediaType: string, param?: SelectParams): void {
    TraceControllerUtils.startTrace('initDataWithType');
    this.dataSource.isInitData = true;
    this.dataSource.setFilterMediaType(filterMediaType);
    let albumUri: string = param?.albumUri ?? param?.albumUriForRecover ?? AlbumDefine.ALBUM_ID_ALL;
    if (!albumUri || albumUri === '') {
      albumUri = AlbumDefine.ALBUM_ID_ALL;
    }
    this.dataSource.setAlbumUri(albumUri);
    Log.info(TAG, `initDataWithType set albumUri: ${albumUri}, param.albumUri: ${param?.albumUri}, param.albumUriForRecover: ${param?.albumUriForRecover}`);
    
    let queryParam: QueryParam = {
      filterMediaType: param?.filterMediaType,
      filterConditions: {
        recommendationType: param?.recoverSceneEnabled ? param.recommendationTypeForRecover : param?.recommendationType,
        photoViewMimeTypeFilter : param?.photoViewMimeTypeFilter,
        fileSizeFilter : param?.fileSizeFilter,
        videoDurationFilter : param?.videoDurationFilter,
        photoViewMimeTypeFileSizeFilters : param?.photoViewMimeTypeFileSizeFilters,
        combinedMediaTypeFilter: param?.combinedMediaTypeFilter,
      },
      needThumbnailReady: true,
    };
    this.dataSource.setQueryParam(queryParam);
    Log.info(TAG, `param?.isCombinedMediaTypeFilterError=${param?.isCombinedMediaTypeFilterError}`)
    if (!param?.isCombinedMediaTypeFilterError) {
      this.dataSource.initData();
    }

    TraceControllerUtils.finishTrace('initDataWithType');
  }

  public release(): void {
    this.dataSource.viewDataCache.clear();
    this.dataSource.clearPreviewArray();
    this.dataSource.clearSimpleMediaItems();
    this.dataSource.releaseBroadCast();
  }
}