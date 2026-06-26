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

import type { MediaItem } from './browser/photo/MediaItem';
import type { AlbumInfo } from './browser/album/AlbumInfo';
import type { SelectManager } from './browser/SelectManager';

/**
 * 业务: 快捷键
 */
export namespace ShortCut {
  // tab选择的相册元素
  export let tabSelectedAlbum: AlbumInfo | undefined = undefined;

  // tab选择的媒体元素
  export let tabSelectedMedia: MediaItem | undefined = undefined;

  // 是否在photoItem组件里
  export let isInPhotoItem: Boolean = false;

  export let mSelectManager: SelectManager | undefined = undefined;

  export let videoStoppable: Boolean = true;

  export let deleteDialogOpenFlag: Boolean = false;
}