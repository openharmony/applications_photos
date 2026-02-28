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
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { PhotoAlbum } from '../../access/PhotoAccessHelperAccess';
import lazy { AlbumGridSortHelper } from '../../model/AlbumGridSortHelper';

export interface MenuOptionOtherParams {
  isFromPortrait?: boolean,
  isFromHighlight?: boolean,
  isRename?: boolean,
  albumUri?: string,
  uri?: string,
  currentIndex?: number,
  mediaCount?: number,
  isFromGalleryCleanup?: boolean,
  album?: PhotoAlbum;
  isGroupGrid?: boolean;

  // 待操作文件是否为连拍封面
  isBurstPhotos?: boolean,

  // 待操作的连拍封面对应的一组连拍
  burstPhotos?: MediaItem[],

  // 保存连拍时删除原连拍，不需要删除弹窗
  isSkipDeleteDialog?: boolean,

  sortHelper?: AlbumGridSortHelper,
}