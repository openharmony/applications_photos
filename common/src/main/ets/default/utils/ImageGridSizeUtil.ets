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
import lazy { Constants } from '../model/common/Constants';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { ImageUtil } from './ImageUtil';
import lazy { HashMap } from '@kit.ArkTS';

export interface GridSize {
  thumbnailWidth: string | undefined;
  thumbnailHeight: string | undefined;
  ratio: number;
}

export class ImageGridSizeUtil {
  public static initGridThumbnail(mediaItem: MediaItem | undefined,
    pageName: string, imageThumbnail: string | undefined, gridItemWidth: number): GridSize {
    let gridSize: GridSize = {
      thumbnailWidth: Constants.PERCENT_100,
      thumbnailHeight: Constants.PERCENT_100,
      ratio: 0,
    };
    /* instrument ignore next */
    if (DeviceInfo.isPc() && (mediaItem?.width === 0) && (mediaItem?.height === 0)) {
      let sizeStore: Size | undefined =
        AppStorage.get<HashMap<string, Size>>(Constants.KEY_OF_GRID_HIGHT0_SIZE_RECODE)?.get(imageThumbnail);
      if (sizeStore) {
        return ImageGridSizeUtil.updateGridThumbnailWithSize(sizeStore, gridItemWidth);
      }
    }
    if (pageName === Constants.PHOTO_ARTGRIDPAGE) {
      return gridSize;
    }
    if (mediaItem?.uri) {
      let size: Size = ImageUtil.getThumbnailSize(mediaItem.width, mediaItem.height, true);
      return ImageGridSizeUtil.updateGridThumbnailWithSize(size, gridItemWidth);
    }
    return gridSize;
  }

  private static updateGridThumbnailWithSize(size: Size, gridItemWidth: number): GridSize {
    let thumbnailWidth = size.width;
    let thumbnailHeight = size.height;
    let gridSize: GridSize = {
      thumbnailWidth: Constants.PERCENT_100,
      thumbnailHeight: Constants.PERCENT_100,
      ratio: thumbnailWidth / thumbnailHeight,
    };
    return ImageGridSizeUtil.resizeGridThumbnail(size, gridItemWidth, gridSize);
  }

  /**
   * 宫格内等比例缩略图宽高计算
   */
  public static resizeGridThumbnail(thumbnailSize: Size | null, gridItemWidth: number, gridSize: GridSize): GridSize {
    if (!DeviceInfo.isPc()) {
      return gridSize;
    }

    let size: Size | null = thumbnailSize;
    // 资源宽高均小于宫格宽高
    let isResourceSmaller: boolean =
      gridItemWidth > px2vp(size?.width) && gridItemWidth > px2vp(size?.height);
    if (isResourceSmaller) {
      gridSize.thumbnailWidth = px2vp(size?.width)?.toString();
      gridSize.thumbnailHeight = px2vp(size?.height)?.toString();
      return gridSize;
    }
    // 等比例处理资源
    let justifyWidth: boolean = gridSize.ratio >= (gridItemWidth / gridItemWidth);
    if (justifyWidth) {
      gridSize.thumbnailWidth = Constants.PERCENT_100;
      gridSize.thumbnailHeight = undefined;
    } else {
      gridSize.thumbnailHeight = Constants.PERCENT_100;
      gridSize.thumbnailWidth = undefined;
    }
    return gridSize;
  }
}