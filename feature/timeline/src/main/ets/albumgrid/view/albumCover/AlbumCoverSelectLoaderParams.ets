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
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { DataSourceWrapper } from '@ohos/common/src/main/ets/default/model/DataSourceWrapper';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy {BindSheetController} from '../AlbumPhotoGridView'

export interface AlbumCoverSelectLoaderParams {
  selectCoverItem: MediaItem;
  persistentId: number;
  bindSheetController: BindSheetController;
}

export interface AlbumCoverPreviewLoaderParams {
  bindSheetController: BindSheetController;
}

export interface bindSheetLoaderParams {
  persistentId: number;
  navPathStackBindSheet: NavPathStack;
  dataSource?: AlbumDataSource | undefined;
  selectCoverItem?: MediaItem;
  albumInfo: AlbumInfo | undefined;
  rooterLoaderParams: (name: string, routerParams: rooterLoaderParams) => void;
}

export interface rooterLoaderParams {
  persistentId: number;
  navPathStackBindSheet: NavPathStack;
  dataSource?: AlbumDataSource | undefined;
  selectCoverItem?: MediaItem;
  albumInfo: AlbumInfo | undefined;
  routerControl?: (name: string) => void;
  item: MediaItem,
  itemHeight: number,
  itemWidth: number,
  index: number,
}