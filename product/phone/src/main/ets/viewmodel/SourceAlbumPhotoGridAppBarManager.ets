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

import lazy { AppBarElementBuilder } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumPhotoGridAppBarManager } from './AlbumPhotoGridAppBarManager';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy {
  SecondLevelTitleProp
} from '@ohos/common/src/main/ets/default/view/actionbar/SecondLevelTitle';

import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { GridCancelViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridCancelViewModel';

const TAG: string = 'CityAlbumPhotoGridAppBarManager';

export class SourceAlbumPhotoGridAppBarManager extends AlbumPhotoGridAppBarManager {
  public navigationPageInfos: NavPathStack | undefined = new NavPathStack();
  private targetDataSource: AlbumDataSource | undefined = undefined;

  constructor(dataSource: AlbumDataSource | undefined, navPathStack?: NavPathStack,
    bindSheetController?: BindSheetController) {
    super(dataSource);
    this.targetDataSource = dataSource;
    this.navigationPageInfos = navPathStack;
    this.bindSheetController = bindSheetController;
  }

  protected onSelectModeChanged(): void {
    Log.info(TAG, `quitSelectMode hasUnmoving: ${this.selectManager?.isSelectedMode()}`);
    super.onSelectModeChanged();
    if (!this.selectManager?.isSelectedMode()) {
      this.updateNonSelectionTitle();
    }
  }

  protected updateNonSelectionTitle(): void {
    super.updateNonSelectionTitle();
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: SecondLevelTitleProp | undefined = titleBuilder?.builderParams as SecondLevelTitleProp;
    if (!titleProp) {
      return;
    }
    try {
      titleProp.content = this.targetDataSource?.albumInfo?.albumName ?? '';
    } catch (error) {
      Log.error(TAG, `getStringSync failed, error code: ${error?.code}, message: ${error?.message}.`);
    }
  }

  protected backFunc(): void {
    Log.info(TAG, 'Return to the previous page doAnimation');
    // 退出选择模式
    if (this.selectManager?.isSelectedMode()) {
      new GridCancelViewModel(this.instanceId).doAction();
      return;
    }
    this.navigationPageInfos?.pop();
  }
}