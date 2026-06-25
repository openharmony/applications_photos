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

import lazy { CaptureState, MediaItem } from './MediaItem';
import type { Thumbnail } from './Thumbnail';
import lazy { image } from '@kit.ImageKit';
import lazy { Log } from '../../../utils/Log';

const TAG: string = 'common_MediaItemResult';

@Observed
export class Margin {
  top?: number;
  right?: number;
  bottom?: number;
  left?: number;
}

@Observed
export class MediaResult {
  public path?: string;
  public dateModified?: number;
  public isFavor?: boolean;
  public displayName?: string;
  public title?: string;
  public orientation?: number;
  public size?: number;
  width?: number;
  height?: number;
  pos?: number;
  thumbnail?: Thumbnail;
  item?: MediaItem;
  itemWidth?: number;
  itemMargin?: Margin;
  public isResourceLoading?: boolean;
  public captureId?: string = '';
  public thumbnailPixmap?: image.PixelMap;
  public thumbnailUri?: string = '';
  public captureState?: CaptureState = CaptureState.NONE;
  public createTime?: number = 0;
  public updateTime?: number = 0;
  public isShowPhoto?: boolean;
  public isShowThumbnail?: boolean;

  constructor(mediaItem: MediaItem) {
    this.initialize(mediaItem);
  }

  public initialize(mediaItem?: MediaItem): void {
    if (!mediaItem) {
      return;
    }
    this.path = mediaItem.path;
    this.dateModified = mediaItem.getDateModified?.();
    this.isFavor = mediaItem.isFavor;
    this.displayName = mediaItem.displayName;
    this.title = mediaItem.getTitle?.();
    this.orientation = mediaItem.orientation;
    this.size = mediaItem.size;
    this.width = mediaItem.width;
    this.height = mediaItem.height;
    this.item = mediaItem;
    this.isResourceLoading = mediaItem.isResourceLoading;
    this.captureId = mediaItem.captureId;
    this.thumbnailPixmap = mediaItem.thumbnailPixmap;
    this.thumbnailUri = mediaItem.thumbnailUri;
    this.captureState = mediaItem.captureState;
    this.createTime = mediaItem.createTime;
    this.isShowPhoto = !mediaItem.isThumbnailState?.();
    this.isShowThumbnail = mediaItem.isShowThumbnail;
  }

  public update(mediaItem?: MediaItem): void {
    if (this.path === mediaItem?.path) {
      this.width = mediaItem?.width;
      this.height = mediaItem?.height;
      this.item = mediaItem;
      this.path = mediaItem?.path;
      this.dateModified = mediaItem?.getDateModified?.();
      this.isFavor = mediaItem?.isFavor;
      this.displayName = mediaItem?.displayName;
      this.title = mediaItem?.getTitle?.();
      this.orientation = mediaItem?.orientation;
      this.size = mediaItem?.size;
      this.isResourceLoading = mediaItem?.isResourceLoading;
      if (mediaItem?.captureId !== '') {
        this.captureId = mediaItem?.captureId;
        this.thumbnailPixmap = mediaItem?.thumbnailPixmap;
        this.thumbnailUri = mediaItem?.thumbnailUri;
        this.createTime = mediaItem?.createTime;
      }
      this.updateTime = mediaItem?.getCurrentTime?.();
    }
  }

  public updateAll(mediaResult?: MediaResult): void {
    this.path = mediaResult?.path;
    this.dateModified = mediaResult?.dateModified;
    this.isFavor = mediaResult?.isFavor;
    this.displayName = mediaResult?.displayName;
    this.title = mediaResult?.title;
    this.orientation = mediaResult?.orientation;
    this.size = mediaResult?.size;
    this.width = mediaResult?.width;
    this.height = mediaResult?.height;
    this.pos = mediaResult?.pos;
    this.thumbnail = mediaResult?.thumbnail;
    this.item = mediaResult?.item;
    this.itemWidth = mediaResult?.itemWidth;
    this.itemMargin = mediaResult?.itemMargin;
    this.isResourceLoading = mediaResult?.isResourceLoading;
    this.captureId = mediaResult?.captureId;
    this.thumbnailPixmap = mediaResult?.thumbnailPixmap;
    this.thumbnailUri = mediaResult?.thumbnailUri;
    this.captureState = mediaResult?.captureState;
    this.createTime = mediaResult?.createTime;
    this.updateTime = mediaResult?.item?.getCurrentTime();
  }

  public setItemThumbnail(thumbnail: Thumbnail): void {
    this.thumbnail = thumbnail;
  }

  public setItemPos(pos: number): void {
    this.pos = pos;
  }

  public toString(): string {
    return `<captureId: ${this.captureId}, thumbnailUri: ${this.thumbnailUri}, path: ${this.path}, ` +
      `captureState: ${this.captureState}, isShowPhoto: ${this.isShowPhoto},` +
      `isShowThumbnail: ${this.isShowThumbnail}>`;
  }
}