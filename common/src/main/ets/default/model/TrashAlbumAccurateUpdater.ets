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
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from './browser/dataObserver/MediaObserverCallback';
import lazy { AlbumAccurateUpdater, OrderStrategy } from './AlbumAccurateUpdater';
import lazy { MediaObserver, PhotoAssetChangeInfo } from './browser/dataObserver/MediaObserver';
import lazy { MediaItem } from './browser/photo/MediaItem';

const TAG: string = 'TrashAlbumAccurateUpdater';

export class GetDataTrashedFunction implements OrderStrategy {
  public isDesc: boolean;

  constructor(isDesc: boolean) {
    this.isDesc = isDesc;
  }

  public getItemValue(item: MediaItem): number {
    return item?.dateTrashed ?? 0;
  }

  public getNfyValue(changeInfo: PhotoAssetChangeInfo): number {
    return changeInfo?.dateTrashedMs ?? 0;
  }
}

/**
 * 增量更新器，最近删除相册宫格实现
 */
export class TrashAlbumAccurateUpdater extends AlbumAccurateUpdater {
  public shouldHandleType: string = MediaObserver.REGISTER_TRASH_PHOTO_CHANGE;
  protected _tag: string = 'TrashAlbumAccurateUpdater';

  public getTargetStrategy(): OrderStrategy {
    let orderStrategy: OrderStrategy = new GetDataTrashedFunction(true);
    return orderStrategy;
  }

  public checkNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    switch (nfyInfo.type) {
      case MediaObserverNfyType.PHOTO_ADD:
        // 回收站不需要响应照片新增通知，直接返回false
        return false;
      case MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM:
        return nfyInfo.albumUris[0] === this.albumUri;
      default:
        return super.checkNotify(nfyInfo);
    }
  }
}
