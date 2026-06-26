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
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { Constants, PreviewItemConstants } from '../model/common/Constants';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { GridSize, ImageGridSizeUtil } from '../utils/ImageGridSizeUtil';
import lazy { Log } from '../utils/Log';
import lazy { TimeLineModelManager } from './TimeLineModelManager';


const TAG: string = 'PreviewGridItem';

/**
 * 照片页宫格预加载帧创建，目前仅限照片页
 */
@Component
export struct PreviewGridItem {
  private item: MediaItem | undefined = undefined;
  private index: number = -1;
  private gridItemWidth: number = 0;
  private thumbnailWidth: string | undefined = Constants.PERCENT_100;
  private thumbnailHeight: string | undefined = Constants.PERCENT_100;
  private ratio: number = 0;
  private drawnThumbnailCount: number = -1;
  @StorageLink(Constants.IS_FULL_RATIO) isShowFullRatio: boolean = false;
  @Consume broadCast: BroadCast;

  aboutToAppear(): void {
    /* instrument ignore if */
    if (!this.item) {
      return;
    }
    let gridSize: GridSize = ImageGridSizeUtil.initGridThumbnail(
      this.item, Constants.PHOTO_TRANSITION_TIMELINE, this.item?.thumbnail, this.gridItemWidth);
    if (!this.isShowFullRatio) {
      this.thumbnailWidth = gridSize.thumbnailWidth;
      this.thumbnailHeight = gridSize.thumbnailHeight;
      this.ratio = gridSize.ratio;
    }
    Log.info(TAG, `aboutToAppear thumbnail: ${this.item.thumbnail} thumbnailWidth: ${
    this.thumbnailWidth}thumbnailHeight: ${this.thumbnailHeight} ratio: ${
    this.ratio} gridItemWidth: ${this.gridItemWidth}`);
  }

  build() {
    GridItem() {
      if (AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine()) {
        this.buildCachedImage();
      } else {
        this.buildImage();
      }
    }
    .height(DeviceInfo.isPc() ? this.gridItemWidth : undefined)
  }

  @Builder
  buildCachedImage() {
    MediaCachedImage(this.item?.thumbnail)
      .width(DeviceInfo.isPc() ? this.thumbnailWidth : Constants.PERCENT_100)
      .height(DeviceInfo.isPc() ? this.thumbnailHeight : Constants.PERCENT_100)
      .aspectRatio(this.ratio)
      .objectFit(ImageFit.Cover)
      .onComplete(() => {
        if (this.index === this.drawnThumbnailCount - 1) {
          // 延迟触发大帧创建，给解码图片渲染送显留出时间，包含cacheImage缓存未命中的情况和真正冷启动的情况
          setTimeout((): void => {
            this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
          }, PreviewItemConstants.ENCODE_FRAME_INTERVAL);
        }
      })
      /* instrument ignore next */
      .onError((): void => {
        // 图片显示失败，直接触发大帧创建
        this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
      })
  }

  /* instrument ignore next */
  @Builder
  buildImage() {
    Image(this.item?.thumbnail)
      .width(DeviceInfo.isPc() ? this.thumbnailWidth : Constants.PERCENT_100)
      .height(DeviceInfo.isPc() ? this.thumbnailHeight : Constants.PERCENT_100)
      .aspectRatio(this.ratio)
      .objectFit(ImageFit.Cover)
      .onComplete(() => {
        if (this.index === this.drawnThumbnailCount - 1) {
          // 延迟触发大帧创建，给解码图片渲染送显留出时间
          setTimeout((): void => {
            this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
          }, PreviewItemConstants.ENCODE_FRAME_INTERVAL);
        }
      })
      /* instrument ignore next */
      .onError((): void => {
        this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
      })
  }
}

