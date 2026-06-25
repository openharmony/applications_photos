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
import lazy { ActionViewModel, MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumPhotoGridAppBarManager } from './AlbumPhotoGridAppBarManager';
import lazy { FormStateType, FormStateTypeUtils } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridFormFsm';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { GridMultiSelectViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridMultiSelectViewModel';
import lazy { GridStateProxy } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridStateProxy';
import lazy { LeftBackActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/LeftBackAction';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy {
  MULTISELECT,
  MultiSelectActionRegister,
  selectionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/SelectionAction';
import lazy {
  SecondLevelTitleProp
} from '@ohos/common/src/main/ets/default/view/actionbar/SecondLevelTitle';

import lazy { GridCancelViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridCancelViewModel';
const TAG: string = 'CityAlbumPhotoGridAppBarManager';

export class CityAlbumPhotoGridAppBarManager extends AlbumPhotoGridAppBarManager {
  public navigationPageInfos: NavPathStack = new NavPathStack();
  private targetDataSource: AlbumDataSource | undefined = undefined;

  constructor(dataSource: AlbumDataSource | undefined, navPathStack: NavPathStack) {
    super(dataSource);
    this.targetDataSource = dataSource;
    this.navigationPageInfos = navPathStack;
  }

  protected registerMoreAction(params: ParamsWrapper): void {
    // 城市相册没有更多按钮
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
    this.navigationPageInfos.pop();
  }
}