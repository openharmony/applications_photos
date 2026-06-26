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

import lazy { Log } from '../../../utils/Log';
import type { AlbumInfo } from '../../browser/album/AlbumInfo';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { AlbumDataImpl } from './AlbumDataImpl';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { SmartAlbumBaseDataSource } from './SmartAlbumBaseDataSource';
import lazy { Constants } from '../../common/Constants';
import lazy { moreAlbumsFileCountReport, nowOverOneWeek } from '../../../utils/StatisticReportUtil';
import lazy {
  MediaObserverRefinedCallback,
  MediaObserverNfyInfoForAlbums
} from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserver } from '../dataObserver/MediaObserver';
import lazy { AlbumRefreshUtil, DataSourceType, SharedAlbumAssetItems } from '../../../utils/AlbumRefreshUtil';
import lazy { ParamsWrapper } from '../../../view/actionbar/Menu';
import lazy { ImageUtil } from '../../../utils/ImageUtil';

const TAG: string = 'common_MoreAlbumsDataSource';

export class MoreAlbumsDataSource extends SmartAlbumBaseDataSource implements MediaObserverRefinedCallback {
  public albumDataImpl: BrowserDataInterface;
  public hasLoadMoreAlbumDataError: boolean = false;
  private trashedAlbumUri: string = '';

  public constructor(broadCast: BroadCast) {
    super(broadCast);
    this.albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
  }

  public initData(): void {
    Log.debug(TAG, 'initData');
    this.loadData();
  }

  private lastMoreAlbumsFileCountReportTime: string = '';

  public async loadData(): Promise<void> {
    try {
      Log.info(TAG, 'load data');

      let loadFromPrecise = AlbumRefreshUtil.getHasPreciseInfo(DataSourceType.Trashed);
      Log.info(TAG,
        `[preciseInfo] trashed album load from precise info: ${loadFromPrecise}, uri: ${this.trashedAlbumUri}`);

      let moreAlbums: AlbumInfo[] = [];
      if (loadFromPrecise && this.trashedAlbumUri) {
        moreAlbums = this.albums;

        let preciseInfoMap: Map<string, ParamsWrapper> = AlbumRefreshUtil.getPreciseInfoMap(DataSourceType.Trashed);

        let albumUris = preciseInfoMap.keys();
        let isLoad: boolean = false;
        for (let albumUri of albumUris) {
          let albumParam: ParamsWrapper | undefined = preciseInfoMap.get(albumUri);
          isLoad = this.loadFromPreciseInfo(this.trashedAlbumUri, moreAlbums[0], albumParam);

          if (isLoad) {
            break;
          }
        }
        AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.Trashed);

      } else {
        moreAlbums = await (this.albumDataImpl as AlbumDataImpl).getMoreAlbums();
      }

      this.updateAlbumSetData(Date.now(), moreAlbums);
      this.broadCast?.emit(Constants.HIDDEN_ALBUM_AND_TRASH_ALBUM_COUNT,
        [[moreAlbums[0]?.count, moreAlbums[1]?.count]]);
      Log.info(TAG, JSON.stringify(moreAlbums), 'load data end');
      // 隐藏相册文件数量, 回收站文件数量
      if (nowOverOneWeek(this.lastMoreAlbumsFileCountReportTime)) {
        moreAlbumsFileCountReport(moreAlbums[0]?.count ?? 0, moreAlbums[1]?.count ?? 0).then((x) => {
          this.lastMoreAlbumsFileCountReportTime = x;
        });
      }
      this.trashedAlbumUri = moreAlbums[0]?.uri;
    } catch (error) {
      this.hasLoadMoreAlbumDataError = true;
      Log.error(TAG, `getMoreAlbumData error: ${error}`);
    }
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0 || (this.albums?.[0]?.count === 0) && (this.totalCount() === 1);
  }

  public override registerAlbumObserver(): void {
    MediaObserver.getInstance().registerAlbumObserver(MediaObserver.TRASHED_ALBUM_CHANGE, this);
  }

  public override unregisterAlbumObserver(): void {
    MediaObserver.getInstance().unregisterAlbumObserver(MediaObserver.TRASHED_ALBUM_CHANGE, this);
  }

  public onRefinedNotify(ntfInfo: MediaObserverNfyInfoForAlbums): void {
    if (this.isActive) {
      AlbumRefreshUtil.setTrashedAlbumPreciseAlbumInfo(DataSourceType.Trashed, ntfInfo);
    }
    this.loadData();
  }

  /**
   * 精准通知更新最近删除相册
   * @param albumId 相册的uri
   * @param albumInfo 相册对象
   * @param albumParam 相册的精准通知信息
   * @returns
   */
  /* instrument ignore next */
  private loadFromPreciseInfo(albumId: string, albumInfo: AlbumInfo, albumParam: ParamsWrapper | undefined): boolean {
    if (!albumId || !albumParam) {
      return false;
    }

    if (albumInfo?.uri === albumId) {
      // iamgeCount 暂无字段，后续有此字段需求再补齐
      let coverUri = albumParam.get(SharedAlbumAssetItems.coverUri) as string | undefined;
      let count = albumParam.get(SharedAlbumAssetItems.count) as number | undefined;
      let videoCount = albumParam.get(SharedAlbumAssetItems.videoCount) as number | undefined;

      try {
        if (coverUri && albumInfo.coverPhotoUri !== coverUri) {
          albumInfo.setCoverPhotoUri(coverUri);
          // coverUri 需要为astc图，否则为原图，影响性能，且同步过程显示裂图，接口其余参数待分析
          albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(coverUri, undefined, undefined));
        }
        if (count !== undefined) {
          albumInfo.setCount(count);
        }
        if (videoCount !== undefined) {
          albumInfo.setVideoCount(videoCount);
        }
      } catch (err) {
        AlbumRefreshUtil.resetNeedLoadStatus(DataSourceType.Trashed);
        Log.error(TAG, `Set albumInfo error, code: ${err?.code}, msg: ${err?.message}`);
      }
      return true;
    }
    return false;
  }
}