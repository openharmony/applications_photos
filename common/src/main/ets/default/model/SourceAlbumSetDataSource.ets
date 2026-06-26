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

import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy {
  ChangeInfo,
  ChangeType,
  DataSource,
  LoadingInfo,
  LoadingResult,
  LoadingState,
  LoadingTask
} from './DataSource';
import lazy common from '@ohos.app.ability.common';
import lazy { PageData } from './PageData';
import lazy { AlbumSetCacheManager, CacheType } from './AlbumSetCacheManager';
import lazy { CacheBoostDataSource, CacheBoostLoadTask, CacheLoadingInfo } from './CacheBoostDataSource';
import lazy { SourceTypeAlbumDataImpl } from './browser/album/SourceTypeAlbumDataImpl';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Constants } from './common/Constants';
import lazy { Log } from '../utils/Log';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

const TAG: string = 'common_SourceAlbumSetDataSource';

// 相册缓存字段
interface AlbumCache {
  uri: string;
  coverUri: string;
  name: string;
  count: number;
  unionAlbumUris: string[];
  lpath: string;
}

interface SourceSetCache {
  albums: AlbumCache[];
};

class SourceAlbumSetLoadTask extends CacheBoostLoadTask {
  public constructor(info: LoadingInfo, source: DataSource<AlbumInfo>, pageData: PageData<AlbumInfo>,
    cacheMgr: AlbumSetCacheManager, context: common.Context) {
    super(info, source, pageData, cacheMgr, context);
    this.tag = TAG;
    this.cacheType = CacheType.SOURCE;
  }

  /* instrument ignore next */
  protected loadAlbumFromCache(cache: Object | undefined): AlbumInfo[] {
    let sourceSetCache: SourceSetCache | undefined = cache as SourceSetCache;
    if (!sourceSetCache || sourceSetCache.albums.length <= 0) {
      return [];
    }
    let albums: AlbumInfo[] = [];
    sourceSetCache.albums.forEach((value: AlbumCache) => {
      let info: AlbumInfo = new AlbumInfo();
      info.uri = value.uri;
      info.coverUri = value.coverUri;
      info.albumName = value.name;
      info.count = value.count;
      info.unionAlbumUris = value.unionAlbumUris ?? [];
      info.subType = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
      info.isSourceAlbum = true;
      info.lpath = value.lpath;
      albums.push(info);
    });
    return albums;
  }

  protected async loadAlbumFromDb(info?: LoadingInfo): Promise<AlbumInfo[]> {
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('loadAlbumFromDb-buildSourceAlbums', startTime);
    Log.info(this.tag, `SourceAlbumLoadFromDb, LoadingInfo: ${info?.start}_${info?.count}`);
    let albums: AlbumInfo[] = [];
    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
    } else {
      albums = await new SourceTypeAlbumDataImpl(this.context).buildSourceAlbums(info);
    }
    Log.info(this.tag, `SourceAlbumLoadFromDb, album length: ${albums?.length}, cost: ${Date.now() - startTime}`);
    TraceControllerUtils.finishTraceWithTaskId('loadAlbumFromDb-buildSourceAlbums', startTime);
    return albums;
  }

  /* instrument ignore next */
  protected async loadPageDataFromDb(cacheLoadingInfo: CacheLoadingInfo): Promise<PageData<AlbumInfo>> {
    let albums: AlbumInfo[] = await this.loadAlbumFromDb(cacheLoadingInfo);
    let sourceAlbumsCount: number = this.pageData.size;
    if (this.source?.latestVersion > this.pageData.version) { // 数据变化
      if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
      } else {
        sourceAlbumsCount = await new SourceTypeAlbumDataImpl(this.context).getSourceAlbumsCount();
      }
    }
    Log.info(this.tag, `sourceAlbumsCount: ${sourceAlbumsCount}, currentQueryCount: ${albums?.length}`);
    return new PageData(this.loadVersion, albums, 0, sourceAlbumsCount - albums?.length);
  }
}

export class SourceAlbumSetDataSource extends CacheBoostDataSource implements IDataSource {
  private showCount: number;

  public constructor(context: common.Context, cacheMgr: AlbumSetCacheManager, showCount: number) {
    super(context, cacheMgr);
    this.tag = TAG;
    this.showCount = showCount;
  }

  /* instrument ignore next */
  protected async writeCache(albums: (AlbumInfo | undefined)[]): Promise<void> {
    if (albums.length <= 0) {
      this.cacheMgr.writeCache(CacheType.SOURCE, undefined);
      return;
    }
    let caches: AlbumCache[] = [];
    albums.slice(0, Constants.EXPAND_MORE_AMOUNT).forEach((album: AlbumInfo | undefined) => {
      caches.push({
        uri: album?.uri,
        coverUri: album?.coverUri,
        name: album?.albumName,
        count: album?.count,
        unionAlbumUris: album?.unionAlbumUris ?? [],
        lpath: album?.lpath,
      } as AlbumCache);
    });
    this.cacheMgr.writeCache(CacheType.SOURCE, {
      albums: caches,
    } as SourceSetCache);
  };

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    return new SourceAlbumSetLoadTask(info, this, this.pageData, this.cacheMgr, this.context);
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    return {
      start: 0, count: this.showCount + Constants.SOURCE_ALBUM_FIRST_BATCH_QUERY_COUNT,
      tryFetchFromCache: this.isCoolStart,
    } as CacheLoadingInfo;
  }

  public totalCount(): number {
    return Math.min(super.totalCount(), this.showCount);
  }

  public dataCount(): number {
    // 当总量大于showCount时，显示“展开”
    return super.totalCount();
  }

  public setShowCount(count: number): void {
    let lastShowCount: number = this.showCount;
    this.showCount = count;
    this.notifyDatasetChanged([{ type: DataOperationType.RELOAD }]);
    if (count > lastShowCount) {
      this.notifyDirty({ changeType: ChangeType.WINDOW });
    }
  }

  public getShowCount(): number {
    return this.showCount;
  }

  public hasSourceAlbum(): boolean {
    return this.totalCount() === 0 ? false : true;
  }
}