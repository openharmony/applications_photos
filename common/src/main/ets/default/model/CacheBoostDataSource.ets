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

import lazy common from '@ohos.app.ability.common';
import lazy { AlbumSetCacheManager, CacheType } from './AlbumSetCacheManager';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { ChangeInfo, DataSource, LoadingInfo, LoadingResult, LoadingTask } from './DataSource';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from './common/AlbumSetDataInfo';
import lazy { PageData } from './PageData';
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from './browser/dataObserver/MediaObserverCallback';

const TAG: string = 'common_CacheBoostDataSource';

export interface CacheLoadingResult extends LoadingResult<AlbumInfo> {
  source: 'cache' | 'database';
}

export interface CacheLoadingInfo extends LoadingInfo {
  readonly tryFetchFromCache: boolean;
}

export abstract class CacheBoostLoadTask extends LoadingTask<AlbumInfo> {
  protected readonly context: common.Context;
  protected readonly cacheMgr: AlbumSetCacheManager;
  protected tag: string = TAG;
  protected cacheType: CacheType | undefined = undefined;

  public constructor(info: LoadingInfo, source: DataSource<AlbumInfo>, pageData: PageData<AlbumInfo>,
    cacheMgr: AlbumSetCacheManager, context: common.Context) {
    super(info, source, pageData);
    this.context = context;
    this.cacheMgr = cacheMgr;
  }

  protected abstract loadAlbumFromCache(cache: Object | undefined): AlbumInfo[];

  protected async loadAlbumFromDb(info?: LoadingInfo): Promise<AlbumInfo[]> {
    return [];
  }

  public async start(): Promise<LoadingResult<AlbumInfo>> {
    let cacheLoadingInfo: CacheLoadingInfo = this.info as CacheLoadingInfo;
    let start: number = Date.now();
    Log.info(this.tag, `start to load data: ${cacheLoadingInfo?.tryFetchFromCache}`);
    if (cacheLoadingInfo?.tryFetchFromCache && this.cacheMgr) {
      try {
        let cache: Object | undefined = this.cacheMgr.getCache(this.cacheType);
        Log.info(this.tag, `finished to load data from cache cost: ${Date.now() - start}`);
        let albums: (AlbumInfo | undefined)[] = this.loadAlbumFromCache(cache);
        if (albums.length > 0) {
          return {
            info: this.info,
            oldPageData: this.pageData,
            newPageData: new PageData(this.loadVersion, albums, 0, 0),
            source: 'cache',
          } as CacheLoadingResult;
        }
      } catch (error) {
        Log.info(this.tag, `getCache failed`);
        return {
          info: this.info,
          oldPageData: this.pageData,
          newPageData: new PageData(this.loadVersion, [], 0, 0),
          source: 'cache',
        } as CacheLoadingResult;
      }
    }

    let data: PageData<AlbumInfo> = await this.loadPageDataFromDb(cacheLoadingInfo);
    Log.info(this.tag, `finished to load data from database: ${data?.size}, cost: ${Date.now() - start}`);
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: data,
      source: 'database',
    } as CacheLoadingResult;
  }

  protected async loadPageDataFromDb(cacheLoadingInfo: CacheLoadingInfo): Promise<PageData<AlbumInfo>> {
    let albums: AlbumInfo[] = await this.loadAlbumFromDb(cacheLoadingInfo);
    return new PageData(this.loadVersion, albums, 0, 0);
  }
}

/**
 * 冷启缓存加速数据源，首次从缓存里面取值，再从数据库取值
 */
export abstract class CacheBoostDataSource extends DataSource<AlbumInfo> {
  protected readonly context: common.Context;
  protected readonly cacheMgr: AlbumSetCacheManager;
  protected isCoolStart: boolean = true;

  public constructor(context: common.Context, cacheMgr: AlbumSetCacheManager) {
    super();
    this.context = context;
    this.cacheMgr = cacheMgr;
  }

  protected abstract writeCache(albums: (AlbumInfo | undefined)[]): Promise<void>;

  public getData(index: number): AlbumSetDataInfo | undefined {
    let albumInfo: AlbumInfo | undefined = this.pageData.getData(index);
    return albumInfo ? new AlbumSetDataInfo(albumInfo, index) : undefined;
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    return { start: 0, count: 0, tryFetchFromCache: this.isCoolStart } as CacheLoadingInfo;
  }

  protected dispatchUpdates(result: LoadingResult<AlbumInfo>): void {
    super.dispatchUpdates(result);
    this.notifyDatasetChanged([{ type: DataOperationType.RELOAD }]);
    Log.info(this.tag, `dispatchUpdates: ${result?.newPageData?.size}`);
  }

  protected notifyDataLoaded(result: LoadingResult<AlbumInfo>): void {
    super.notifyDataLoaded(result);
    this.isCoolStart = false;

    // 如果是从缓存中取到的数据，就再从数据库查询最新数据
    let cacheResult: CacheLoadingResult = result as CacheLoadingResult;
    if (cacheResult?.source === 'cache') {
      this.notifyDirty();
    } else {
      this.writeCache(result.newPageData.data);
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC) {
      Log.info(TAG, 'onNotify drop for MediaObserverNfyType.PHOTO_ADD_ASTC');
      return;
    }
    super.onNotify(nfyInfo);
  }
}