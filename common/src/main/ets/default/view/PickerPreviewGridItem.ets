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

import lazy { ItemDisplayRatio } from '../model/common/SelectParams';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { Constants, PreviewItemConstants } from '../model/common/Constants';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { GridSize, ImageGridSizeUtil } from '../utils/ImageGridSizeUtil';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy { Log } from '../utils/Log';

/* instrument ignore file */
const TAG: string = 'PickerPreviewGridItem';

@Component
export struct PickerPreviewGridItem {
  private item: MediaItem | undefined = undefined;
  private index: number = -1;
  private gridItemWidth: number = 0;
  private ratio: number = 0;
  private drawnThumbnailCount: number = -1;
  private isSlidingHorizontally: boolean = false;
  private isSingleLineMode: boolean = false;
  private singleLineModeItemDisplayRatio: number = -1;
  private imageBorderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0;
  private previewImgLoaded: boolean = false;
  private onPickerSingleLineModePreviewImgCreated: Function = (drawnThumbnailCount: number) => {
    this.singleLineModeEmitSwitchGridViewRaw(drawnThumbnailCount);
  }
  @Consume broadCast: BroadCast;

  aboutToAppear(): void {
    if (!this.item) {
      return;
    }
    this.broadCast.on(BroadCastConstants.PICKER_SINGLE_LINE_MODE_PREVIEW_IMG_CREATED,
      this.onPickerSingleLineModePreviewImgCreated);
    let gridSize: GridSize =
      ImageGridSizeUtil.initGridThumbnail(this.item, TAG, this.item?.thumbnail, this.gridItemWidth);
    this.ratio = gridSize.ratio;
  }

  aboutToDisappear(): void {
    this.broadCast.off(BroadCastConstants.PICKER_SINGLE_LINE_MODE_PREVIEW_IMG_CREATED,
      this.onPickerSingleLineModePreviewImgCreated);
  }

  singleLineModeEmitSwitchGridViewRaw(drawnThumbnailCount: number) {
    this.drawnThumbnailCount = drawnThumbnailCount;
    // 单行布局下 第一张图超宽 极简宫格仅显示一个 这里 drawnThumbnailCount 为 0，如果收到事件，无需校验index
    if ((drawnThumbnailCount < 1 || this.index === drawnThumbnailCount - 1) && this.previewImgLoaded) {
      setTimeout((): void => {
        this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
        Log.info(TAG, 'image onComplete and receive broadCast, ready to SWITCH_GRID_VIEW_RAW');
      }, PreviewItemConstants.ENCODE_FRAME_INTERVAL);
    }
  }

  build() {
    GridItem() {
      MediaCachedImage(this.item?.thumbnail)
        .width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100)
        .aspectRatio(this.singleLineModeItemDisplayRatio === ItemDisplayRatio.ORIGINAL_SIZE_RATIO ?
          undefined : this.ratio)
        .borderRadius(this.imageBorderRadius)
        .objectFit(this.singleLineModeItemDisplayRatio !== ItemDisplayRatio.ORIGINAL_SIZE_RATIO ?
        ImageFit.Cover : ImageFit.Auto)
        .onComplete(() => {
          this.previewImgLoaded = true;
          // 单行布局下 第一张图超宽 极简宫格仅显示一个 这里 drawnThumbnailCount 为 0，如果收到事件，无需校验index
          if (this.drawnThumbnailCount < 1 || this.index === this.drawnThumbnailCount - 1) {
            setTimeout((): void => {
              this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
              Log.info(TAG, 'image onComplete, ready to SWITCH_GRID_VIEW_RAW');
            }, PreviewItemConstants.ENCODE_FRAME_INTERVAL);
          }
        })
        .onError((): void => {
          this.previewImgLoaded = true;
          this.broadCast.emit(BroadCastConstants.SWITCH_GRID_VIEW_RAW, []);
        })
        .draggable(false)
    }
    .width(this.isSlidingHorizontally ? undefined : Constants.PERCENT_100)
    .height(this.isSlidingHorizontally ? Constants.PERCENT_100 : (this.isSingleLineMode ? undefined :
    Constants.PERCENT_100))
    .aspectRatio(this.singleLineModeItemDisplayRatio !== ItemDisplayRatio.ORIGINAL_SIZE_RATIO ?
    this.ratio : ImageUtil.getSingleLineIrregularModeAspectRatio(this.item?.width, this.item?.height))
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture({ count: 1 }).onAction(() => {
        Log.info(TAG, 'PickerPreviewGridItem click');
      })
    ))
  }
}