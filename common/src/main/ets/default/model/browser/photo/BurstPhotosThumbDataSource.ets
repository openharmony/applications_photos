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
import lazy { MediaItem } from './MediaItem';
import lazy { Constants } from '../../common/Constants';

import lazy { ViewData } from '../../browser/photo/ViewData';
import lazy { MediaResult } from './MediaResult';
import lazy { Thumbnail } from './Thumbnail';
import lazy { BurstPhotosDataSource } from './BurstPhotosDataSource';
import lazy { ImageUtil } from '../../../utils/ImageUtil';

import lazy { DeviceInfo } from '../../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_BurstPhotosThumbDataSource';

// 预览条图片的margin
const LIST_MID_ITEM_MARGIN_MAX: number = 6;
const LIST_MID_ITEM_MARGIN_MIN: number = 2;

// 缩略图最大长宽比
const MAX_RATIO = 2;
// 预览条图片的高度
const PREVIEW_IMG_HEIGHT: number = 36;
const PREVIEW_IMG_HEIGHT2: number = 40;

// DataSource
export class BurstPhotosThumbDataSource extends BurstPhotosDataSource {
  public photoDataSource: BurstPhotosDataSource | undefined;
  public mediaResultMap: Map<string, MediaResult> = new Map<string, MediaResult>();

  setPhotoDataSource(photoDataSource: BurstPhotosDataSource): void {
    this.photoDataSource = photoDataSource;
  }

  totalCount(): number {
    if (!this.photoDataSource) {
      return 0;
    }
    return this.photoDataSource.totalCount();
  }

  // LazyForEach call
  getData(index: number): MediaResult | undefined {
    if (!this.photoDataSource) {
      return;
    }
    let mediaItem: MediaItem | undefined = this.photoDataSource.getData(index)?.item;
    if (mediaItem === undefined) {
      Log.info(TAG, `get empty data index: ${index}`);
      return undefined;
    }
    let uri: string = mediaItem.path;
    let mediaResult: MediaResult;
    if (this.mediaResultMap.has(uri)) {
      mediaResult = this.mediaResultMap.get(uri) ?? new MediaResult(mediaItem);
      if (mediaResult.dateModified !== mediaItem.getDateModified() || mediaResult.path != mediaItem.path) {
        mediaResult.setItemThumbnail(new Thumbnail(
          this.photoDataImpl?.getThumbnail(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
            ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, false))));
      }
      mediaResult.update(mediaItem);
      mediaResult.setItemPos(index);
      this.mediaResultMap.set(uri, mediaResult);
    } else {
      mediaResult = new MediaResult(mediaItem);
      mediaResult.setItemThumbnail(new Thumbnail(
        this.photoDataImpl?.getThumbnail(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
          ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, false))));
      mediaResult.setItemPos(index);
      if (index != this.getCurrentIndex()) {
        mediaResult.itemMargin = {
          left: LIST_MID_ITEM_MARGIN_MIN,
          right: LIST_MID_ITEM_MARGIN_MIN,
          top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
          bottom: 0,
        };
      } else {
        mediaResult.itemMargin = {
          left: LIST_MID_ITEM_MARGIN_MAX,
          right: LIST_MID_ITEM_MARGIN_MAX,
          top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
          bottom: 0,
        };
      }
      const calcWidth = mediaItem.width / mediaItem.height * this.getSmallImgHeight();
      mediaResult.itemWidth = Math.min(this.getSmallImgHeight() * MAX_RATIO,
        Math.max(calcWidth, this.getSmallImgHeight() / 2));
      this.mediaResultMap.set(uri, mediaResult);
    }

    return mediaResult;
  }

  private getSmallImgHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet()) ? PREVIEW_IMG_HEIGHT2 : PREVIEW_IMG_HEIGHT;
  }

  getCurrentIndex(): number {
    return this.photoDataSource ? this.photoDataSource.getCurrentIndex() : 0;
  }

  updateIndexWidthMargin(index1: number, shrinkFactor1: number, isTouching1: boolean,
    startIndex1: number, percent1: number) {
    let index: number = index1;
    let shrinkFactor: number = shrinkFactor1;
    let isTouching: boolean = isTouching1;
    let startIndex: number = startIndex1;
    let percent: number = percent1;
    this.genMargin(index, shrinkFactor, isTouching, startIndex, percent);
  }

  private genMargin(centerIndex: number, shrinkFactor: number, isTouching: boolean,
    startIndex: number, percent: number) {
    this.mediaResultMap.forEach((value, key) => {
      let gap = LIST_MID_ITEM_MARGIN_MAX - LIST_MID_ITEM_MARGIN_MIN;
      let ret: number = LIST_MID_ITEM_MARGIN_MIN;
      let pos = value.pos;
      if (pos != undefined) {
        if ((centerIndex < pos - 1 || centerIndex > pos + 1) && value?.itemMargin?.left === LIST_MID_ITEM_MARGIN_MIN) {
          return;
        }
        if (isTouching) {
          if (startIndex === pos + 1) { // 右侧item
            ret = LIST_MID_ITEM_MARGIN_MIN + gap * Math.max(0, percent);
          } else if (startIndex === pos - 1) { // 左侧item
            ret = LIST_MID_ITEM_MARGIN_MIN + gap * Math.max(0, 0 - percent);
          } else if (startIndex === pos) {
            ret = LIST_MID_ITEM_MARGIN_MIN + gap * shrinkFactor * (1 - Math.abs(percent)); // 1 -> 0
          }
        } else if (shrinkFactor === 1 && centerIndex === pos) { // shrinkFactor等于1为停止态，当前图片需设置margin
          Log.info(TAG, `genMargin pos ${pos}`);
          ret = LIST_MID_ITEM_MARGIN_MAX;
        }
        if (!value.itemMargin || value.itemMargin.left !== ret) {
          value.itemMargin = {
            left: ret,
            right: ret,
            top: Constants.PHOTO_DETAIL_NOTE_MARGIN_UP,
            bottom: 0,
          };
        }
      }
    })
  }

  // 设置当前缩略图的宽度
  setCurrentSmallImgWidth(targetWidth: number): void {
    let index = this.getCurrentIndex();
    this.mediaResultMap.forEach((value, key) => {
      if (value.pos === index) {
        value.itemWidth = targetWidth;
      }
    });
  }

  getCurrentSmallImgWidth(): number | undefined {
    let index = this.getCurrentIndex();
    let ret: number | undefined = undefined;
    this.mediaResultMap.forEach((value, key) => {
      if (value.pos === index) {
        ret = value.itemWidth;
      }
    });
    return ret;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (!this.photoDataSource) {
      return;
    }
    return this.photoDataSource.registerDataChangeListener(listener);
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    if (!this.photoDataSource) {
      return;
    }
    return this.photoDataSource.unregisterDataChangeListener(listener);
  }
}