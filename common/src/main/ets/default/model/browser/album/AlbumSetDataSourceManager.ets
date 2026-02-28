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

import lazy { BroadCast } from '../../../utils/BroadCast';
import lazy { Log } from '../../../utils/Log';
import lazy { DataListener, LoadingResult } from '../../DataSource';
import lazy { AlbumSetDataSource } from './AlbumSetDataSource';
import lazy { AlbumInfo } from './AlbumInfo';
import lazy { PageData } from '../../PageData';
import lazy { Constants } from '.././../common/Constants'

const TAG: string = 'browser_AlbumSetDataSourceManager';

export class AlbumSetDataSourceManager {
  private static instance?: AlbumSetDataSourceManager;
  private broadCast: BroadCast;
  private dataSource: AlbumSetDataSource;
  private mIsDirty: boolean;
  private dataListener: DataListener<AlbumInfo> = {
    onLoadingFinished: (result: LoadingResult<AlbumInfo>) => this.onDataLoadingFinished(result),
  };
  private pageData: PageData<AlbumInfo> | undefined = undefined;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.broadCast = new BroadCast();
    this.dataSource = new AlbumSetDataSource(this.broadCast, undefined, true);
    this.dataSource.addListener(this.dataListener);
    this.dataSource.registerAlbumObserver();
    this.dataSource.notifyDirty();
    this.mIsDirty = false;
  }

  private onDataLoadingFinished(result: LoadingResult<AlbumInfo>): void {
    this.pageData = result.newPageData;
  }

  public static onDestroy(): void {
    AlbumSetDataSourceManager.instance?.dataSource?.unregisterAlbumObserver();
    AlbumSetDataSourceManager.instance?.dataSource?.pause();
    AlbumSetDataSourceManager.instance?.dataSource?.removeListener(AlbumSetDataSourceManager.instance?.dataListener);
    AlbumSetDataSourceManager.instance?.dataSource?.onDestroy();
    AppStorage.delete(Constants.PHOTO_ALBUMSET_DATASOURCE_MANAGER);
    AlbumSetDataSourceManager.instance = undefined;
  }

  public static getInstance(): AlbumSetDataSourceManager {
    if (AlbumSetDataSourceManager.instance) {
      Log.info(TAG, 'albumDatasourceManager singletonInstance exist');
      return AlbumSetDataSourceManager.instance;
    }
    let manager = AppStorage.get<AlbumSetDataSourceManager>(Constants.PHOTO_ALBUMSET_DATASOURCE_MANAGER);
    if (manager) {
      Log.info(TAG, `appStorage-AlbumSetDataSourceManager exist`);
      AlbumSetDataSourceManager.instance = manager;
      return manager;
    } else {
      Log.info(TAG, `appStorage-AlbumSetDataSourceManager not exist`);
      AlbumSetDataSourceManager.instance = new AlbumSetDataSourceManager();
      AppStorage.setOrCreate(Constants.PHOTO_ALBUMSET_DATASOURCE_MANAGER,
        AlbumSetDataSourceManager.instance);
      return AlbumSetDataSourceManager.instance;
    }
  }

  private getPageData(blackUriList?: string[]): PageData<AlbumInfo> | undefined {
    if (!blackUriList || blackUriList.length === 0) {
      return this.pageData;
    }

    // 只能尽可能过滤一下当前已有的数据，但是在滑窗外的未知元素是否在黑名单内是不确定的
    // 其他场景复用PageData时，还需要触发一次查询，刷新一次，保证滑窗外的黑名单元素也被过滤，以保证总量正确
    let data: (AlbumInfo | undefined)[] = this.pageData?.data ?? [];
    let filtered: (AlbumInfo | undefined)[] = [];
    for (let info of data) {
      if (!info || blackUriList.indexOf(info?.uri) < 0) {
        filtered.push(info);
      }
    }
    return new PageData<AlbumInfo>(this.pageData?.version ?? 0, filtered, this.pageData?.placeholdersBefore ?? 0,
      this.pageData?.placeholdersAfter ?? 0);
  }

  public getBroadCast(): BroadCast {
    return this.broadCast;
  }

  public getDataSource(): AlbumSetDataSource {
    if (this.mIsDirty) {
      this.refreshDataSource();
    }
    return this.dataSource;
  }

  public create(blackUriList?: string[]): AlbumSetDataSource {
    return new AlbumSetDataSource(new BroadCast(), this.getPageData(blackUriList), false, blackUriList);
  }

  /**
   * @deprecated 已与 吴昊 确认需要回退 沈启龙 NewPhotos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager.ts
   * 中的isDirty与一系列async函数的部分修改
   * API 11 适配完之后处理
   */
  public async getDataSourceAsync(): Promise<AlbumSetDataSource> {
    if (this.mIsDirty) {
      await this.refreshDataSourceAsync();
    }
    return this.dataSource;
  }

  public refreshDataSource(): void {
    this.dataSource.notifyDirty();
    this.mIsDirty = false;
  }

  public async refreshDataSourceAsync(): Promise<void> {
    this.dataSource.notifyDirty();
    this.mIsDirty = false;
  }

  public isDirty(): boolean {
    return this.mIsDirty;
  }

  public setDirty(isDirty: boolean): void {
    this.mIsDirty = isDirty;
  }
}