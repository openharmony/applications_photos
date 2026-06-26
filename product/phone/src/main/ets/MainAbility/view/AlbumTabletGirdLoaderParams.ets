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

import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { GridInitConfigSyncer } from '@ohos/timeline/src/main/ets/view/adapter/GridInitConfigSyncer';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

export interface AlbumTabletGirdLoaderParams {
  pageStatus: boolean;
  actionBarController: ActionBarController;
  isLevelOneHeadTitle?: boolean;
  isSelectedMode: boolean;
  dataSource?: MediaDataSource;
  importDataSource?: AlbumDataSource | MediaDataSource;
  mSelectManager?: SelectManager | undefined
  isUnionAlbumPage?: boolean;
  bindSheetController: BindSheetController;
  gridInitConfigSyncer?: GridInitConfigSyncer;
  browserController?: PhotosHmBrowserController;
  navPathStack: NavPathStack;
}