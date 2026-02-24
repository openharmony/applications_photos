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
import lazy { AlbumPhotoGridLoaderParams } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridLoaderParams';
import lazy { AlbumPhotoGridView } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { AlbumPhotoGridAppBarManager } from '../../viewmodel/AlbumPhotoGridAppBarManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';

@Builder
export function AlbumPhotoGirdLoader($$: AlbumPhotoGridLoaderParams) {
  /* instrument ignore if */
  if (AlbumUtils.useNewPhotoGrid() && $$.importDataSource instanceof AlbumDataSource) {
    AlbumPhotoGridView({
      pageStatus: $$.pageStatus,
      isSelectedMode: $$.isSelectedMode,
      importDataSource: $$.importDataSource,
      gridInitConfigSyncer: $$.gridInitConfigSyncer,
      navPathStack: $$.navPathStack,
      gridAppBarManager: new AlbumPhotoGridAppBarManager($$.importDataSource, $$.bindSheetController,
        $$.browserController),
      albumGridConfig: {
        isSupportSortSelector: true,
      },
      bindSheetController: $$.bindSheetController,
    })
  }
}