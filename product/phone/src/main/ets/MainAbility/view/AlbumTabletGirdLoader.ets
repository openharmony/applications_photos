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

import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { AlbumTabletGirdLoaderParams } from './AlbumTabletGirdLoaderParams';
import lazy { AlbumPhotoGridView } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { AlbumPhotoGridAppBarManager } from '../../viewmodel/AlbumPhotoGridAppBarManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';

/* instrument ignore file */
@Builder
export function AlbumTabletGirdLoader($$: AlbumTabletGirdLoaderParams) {
  /* instrument ignore if */
  if (AlbumUtils.useNewPhotoGrid() && $$.importDataSource instanceof AlbumDataSource) {
    AlbumPhotoGridView({
      pageStatus: $$.pageStatus,
      isSelectedMode: $$.isSelectedMode,
      navPathStack: $$.navPathStack,
      importDataSource: $$.importDataSource,
      gridInitConfigSyncer: $$.gridInitConfigSyncer,
      // gridAppBarManager: new AlbumPhotoGridAppBarManager($$.importDataSource, $$.bindSheetController),
      albumGridConfig: {
        isSupportSortSelector: true,
      },
      bindSheetController: $$.bindSheetController
    })
  }
}