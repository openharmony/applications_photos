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
import lazy { SimpleGridMediaItem } from '../model/browser/photo/SimpleGridMediaItem';

/**
 * 控制宫格界面刷新相关变量
 * 1、isFavor：收藏图标，批量收藏/大图收藏返回场景
 * 2、dateModified：高质量图刷新、图片/视频编辑
 * 3、thumbnailReady：缩略图刷新
 * 4、size: 文件大小
 */
export class GridUIController {
  public isFavor: boolean = false;
  public dateModified: number = 0;
  public thumbnailReady: number = 0;
  public isTurnedOnMovingPhoto: boolean = false;

  constructor() {
  }

  public init(item: MediaItem | undefined, simpleItem?: SimpleGridMediaItem): void {
    /* instrument ignore if */
    if (!item) {
      return;
    }
    this.isFavor = item.isFavor || (simpleItem?.isFavorite() === true);
    this.isTurnedOnMovingPhoto = item.isTurnedOnMovingPhoto;
    this.dateModified = item.dateModified;
    this.thumbnailReady = item.thumbnailReady;
  }
}