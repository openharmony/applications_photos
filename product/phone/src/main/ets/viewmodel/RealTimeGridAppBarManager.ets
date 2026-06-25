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

import lazy { MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumPhotoGridAppBarManager } from './AlbumPhotoGridAppBarManager';
import lazy { ActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/ActionRegister';
import lazy { GridCancelViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridCancelViewModel';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BigDataConstants } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { DeleteAlbumActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteAlbumAction';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { SecondLevelTitleProp } from '@ohos/common/src/main/ets/default/view/actionbar/SecondLevelTitle';
import lazy { AppBarElementBuilder } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';

const TAG: string = 'RealTimeGridAppBarManager';


export class RealTimeGridAppBarManager extends AlbumPhotoGridAppBarManager {
  private navigationPageInfos: NavPathStack = new NavPathStack();
  private targetDataSource: AlbumDataSource | undefined = undefined;

  private title: string = '';

  constructor(dataSource: AlbumDataSource | undefined, navPathStack: NavPathStack, title?: string) {
    super(dataSource);
    this.navigationPageInfos = navPathStack;
    this.title = title ?? '';
    this.targetDataSource = dataSource;
  }

  protected registerMoreAction(params: ParamsWrapper): void {
  }

  protected buildCommonParams(): ParamsWrapper {
    return super.buildCommonParams()
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_PHOTO)
      .set(MenuConstants.KEY_ALBUM_INFO, this.albumInfo)
      .set(MenuConstants.KEY_CONTEXT, this.context)
      .set(DeleteAlbumActionRegister.DELETE_ALBUM_LISTENER, this.deleteAlbumOperationListener)
      .set(BindSheetController.KEY_ALBUM_COVER_CONTROLLER, this.bindSheetController)
  }

  protected updateNonSelectionTitle(): void {
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: SecondLevelTitleProp | undefined = titleBuilder?.builderParams as SecondLevelTitleProp;
    if (!titleProp) {
      Log.error(TAG, `updateNonSelectionTitle titleProp is null`);
      return;
    }
    titleProp.fontSize = this.getFontSizeNonSysAlbumTitle();
    titleProp.minFontSize = $r('sys.float.Body_M');
    titleProp.maxFontSize = this.getFontSizeNonSysAlbumTitle();
    titleProp.fontColor = isImmersive ? '#FFFFFF' : AppBarStyles.BUTTON_FILL_COLOR;
    let isSelectedMode: boolean | undefined = this.selectManager?.isSelectedMode();
    // 非选择模式时显示搜索名称
    if (!isSelectedMode) {
      titleProp.content = this.title;
    }
  }

  protected onSelectModeChanged(): void {
    Log.info(TAG, `RealTimeGrid quitSelectMode hasUnmoving: ${this.selectManager?.isSelectedMode()}`);
    super.onSelectModeChanged();
    if (this.selectManager?.isSelectedMode()) {
      this.selectManager?.setPhotoDataImpl(this.targetDataSource?.photoDataImpl as PhotoDataImpl);
    }
  }

  /**
   * 用户相册，分类相册，搜索界面使用的单行标题字体大小
   */
  private getFontSizeNonSysAlbumTitle(): Resource {
    if (DeviceInfo.isPc() || DeviceInfo.isFoldablePhone() ||
      (DeviceInfo.isPhone() && !AppStorage.get<boolean>('isHorizontal'))) {
      return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    } else if (DeviceInfo.isTablet()) {
      return $r('app.float.first_level_title_font_size');
    }
    return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE
  }

  public backFunc(): void {
    Log.info(TAG, `Return RealTimeGridAppBarManager${this.selectManager?.isSelectedMode()}`);
    // 退出选择模式
    if (this.selectManager?.isSelectedMode()) {
      new GridCancelViewModel(this.instanceId).doAction();
      return;
    }
    this.navigationPageInfos.pop();
  }
}
