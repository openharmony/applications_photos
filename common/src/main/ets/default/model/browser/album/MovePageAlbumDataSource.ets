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

import lazy { AlbumInfo } from './AlbumInfo';
import lazy { LoadingTask, LoadingInfo } from '../../DataSource';
import lazy { Constants, SelectMediaType } from '../../common/Constants';
import lazy { Log } from '../../../utils/Log';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { MovePageAlbumDataImplAsync } from './MovePageAlbumDataImplAsync';
import lazy { DataSource } from '../../DataSource';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import lazy { MovePageAlbumGetCallback } from './MovePageAlbumGetCallback';
import type { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import { BroadCastManager } from '../../../model/common/BroadCastManager';
import { BroadCastConstants } from '../../../model/common/BroadCastConstants';

const TAG: string = 'common_MovePageAlbumDataSource';

export class MovePageAlbumDataSource extends DataSource<AlbumInfo> {
  public albums: AlbumInfo[] = [];
  public albumDataImpl = new MovePageAlbumDataImplAsync();
  public sourceAlbumUri: string = '';
  protected blackLpath: string[] = [];

  initData(): void {
    this.initFirstBach();
  }

  initSecondData(): void {
    this.initSecondBatch();
  }

  /**
   * 初始化加载第一批相册数据
   */
  protected initFirstBach(): void {
    Log.info(TAG, `start initData`);
    let firstPatchDataTime: number = Date.now();
    TraceControllerUtils.startTrace('MovePageAlbumDataSource');
    let firstPatchDataCallback: AsyncCallback = {
      callback: (firstPatchAlbums: AlbumInfo[], firstPatchResult: number): void => {
        Log.info(TAG, `firstPathData took ${(
          Date.now() - firstPatchDataTime)} milliseconds to load first batch result: ${firstPatchResult}`);
        if (firstPatchResult > 0) {
          // push更新第一批数据
          let isOver: boolean = firstPatchAlbums.length < Constants.INIT_ALBUMS_FIRST_BATCH;
          this.pushAlbumInfo(firstPatchAlbums, isOver);
          if (firstPatchResult < Constants.INIT_ALBUMS_FIRST_BATCH) {
            // 第一批已完成全部相册加载，减一是有可能去除了源相册
            BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.BOARDCAST_CLOUD_ALBUM_LOAD_FINISH);
            return;
          } else {
            // 加载第二批
            this.initSecondBatch();
          }
        }
      }
    }
    let firstParam: QueryAlbumParam = {
      start: 0,
      count: Constants.INIT_ALBUMS_FIRST_BATCH,
    }
    this.albumDataImpl.getData(firstPatchDataCallback, firstParam);
  }

  /**
   * 初始化加载第二批相册数据
   */
  protected initSecondBatch(): void {
    let secondPatchTime: number = Date.now();
    let secondPatchDataCallback: AsyncCallback = {
      callback: (secondPatchAlbums: AlbumInfo[], secondPatchResult: number): void => {
        Log.info(TAG, `secondPatchData took ${(
          Date.now() - secondPatchTime)} milliseconds to load second batch result: ${secondPatchResult}`);
        if (secondPatchResult >= 0) {
          let isOver = secondPatchAlbums.length <
            Constants.INIT_ALBUMS_SECOND_BATCH - Constants.INIT_ALBUMS_FIRST_BATCH;
          //  push更新第二批数据
          this.pushAlbumInfo(secondPatchAlbums, isOver);
          if (secondPatchResult <
            Constants.INIT_ALBUMS_SECOND_BATCH - Constants.INIT_ALBUMS_FIRST_BATCH) {
            // 第二批数据已完成全部相册查询，无需第三批数据查询，减一是有可能去除了源相册
            BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.BOARDCAST_CLOUD_ALBUM_LOAD_FINISH);
          } else {
            // 第三批数据加载 利用taskpool进行加载
            let thirdPatchDataCallback = new MovePageAlbumGetCallback(this);
            this.albumDataImpl.buildMovePageAlbumsAsync(thirdPatchDataCallback, {
            });
          }
        }
        TraceControllerUtils.finishTrace('MovePageAlbumDataSource');
      }
    };
    // 第二批
    let secondParam: QueryAlbumParam = {
      start: Constants.INIT_ALBUMS_FIRST_BATCH,
      count: Constants.INIT_ALBUMS_SECOND_BATCH,
    }
    this.albumDataImpl.getData(secondPatchDataCallback, secondParam);
  }

  public loadData(): void {
    // 如果疯狂前后台切换 需要增加延时加载，全量相册数据查询是否要放到taskpool执行
    // 查全量相册数据
    let fullQueryAlbumsCallback: AsyncCallback = {
      callback: (albums: AlbumInfo[], result: number): void => {
        this.updateAlbumInfo(albums);
      }
    }
    this.albumDataImpl.getData(fullQueryAlbumsCallback, {
    });
  }

  public getData(index: number): AlbumInfo {
    Log.info(TAG, `getData index:${index} albumName:${this.albums[index]?.albumName} `);
    return this.albums[index];
  }

  public totalCount(): number {
    return this.albums.length;
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onNotify nfyInfo: ${JSON.stringify(nfyInfo)}`);
    switch (nfyInfo.type) {
      case MediaObserverNfyType.ALBUM_UPDATE:
        this.loadData();
        break;
      case MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM:
        this.loadData();
        break;
      default:
        break;
    }
  }

  public setSourceAlbumUri(sourceAlbumUri: string): void {
    this.sourceAlbumUri = sourceAlbumUri;
  }

  public setBlackLpath(mediaType: number): void {
    if (mediaType & SelectMediaType.IMAGE) {
      this.blackLpath.push(Constants.LPATH_SCREEN_RECORDING);
    }
    if (mediaType & SelectMediaType.VIDEO) {
      this.blackLpath.push(Constants.LPATH_SCREEN_SHOT);
    }
  }

  /**
   * 分批数据直接push
   * @param albums
   */
  public pushAlbumInfo(albums: AlbumInfo[], isOver?: boolean): void {
    Log.info(TAG, `pushAlbumInfo sourceAlbumUri：${this.sourceAlbumUri}`);
    // 过滤源相册，以及黑名单相册
    if (this.sourceAlbumUri || this.blackLpath.length > 0) {
      // 移动操作时， 排除 sourceAlbumUri 所在的相册
      albums = albums.filter((item) => item.uri !== this.sourceAlbumUri &&
        !(item.lpath && this.blackLpath.includes(item.lpath)));
    }
    this.albums.push(...albums);
    Log.info(TAG, `pushAlbumInfo this.albums:${this.albums.length}`);
    this.onDataReloaded();
  }

  /**
   * 全量查询直接update
   * @param albums
   */
  public updateAlbumInfo(albums: AlbumInfo[]): void {
    Log.info(TAG, `updateAlbumInfo sourceAlbumUri：${this.sourceAlbumUri}`);
    // 过滤源相册，以及黑名单相册
    if (this.sourceAlbumUri || this.blackLpath.length > 0) {
      // 移动操作时， 排除 sourceAlbumUri 所在的相册
      albums = albums.filter((item) => item.uri !== this.sourceAlbumUri &&
        !(item.lpath && this.blackLpath.includes(item.lpath)));
    }
    this.albums = albums;
    Log.info(TAG, `updateAlbumInfo this.albums:${this.albums.length}`);
    this.onDataReloaded();
  }

  /**
   * Overall refresh of notification framework
   */
  public onDataReloaded(): void {
    Log.debug(this.tag, `onDataReloaded listeners size ${this.listeners?.length}`);
    super.onDataReloaded();
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<AlbumInfo> | undefined {
    return undefined;
  }
}
