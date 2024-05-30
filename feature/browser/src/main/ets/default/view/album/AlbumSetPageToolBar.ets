/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Action, Log } from '@ohos/common';
import { ToolBar } from '@ohos/common/CommonComponents';

const TAG: string = 'browser_AlbumSetPageToolBar';

@Component
export struct AlbumSetPageToolBar {
  @Provide isShowBar: boolean = true;
  @Provide toolMenuList: Action[] = [];
  @Provide moreMenuList: Action[] = [];
  @Consume @Watch('updateToolbar') isAlbumSetSelectedMode: boolean;
  @Consume('selectedCount') @Watch('updateToolbar') selectedAlbumsCount: number;
  @Consume isDisableRename: boolean;
  @Consume isDisableDelete: boolean;
  onMenuClicked: Function = (): void => {};
  @Provide hidePopup: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.updateToolbar();
  }

  build() {
    ToolBar({
      onMenuClicked: this.onMenuClicked
    })
  }

  private updateToolbar(): void {
    Log.info(TAG, 'updateToolbar');
    if (this.isAlbumSetSelectedMode) {
      Log.info(TAG, 'pushToolbar');
      this.toolMenuList = [];
      this.toolMenuList.push(
        ((!this.isDisableRename && this.selectedAlbumsCount == 1) ? Action.RENAME : Action.RENAME_INVALID),
        ((!this.isDisableDelete && this.selectedAlbumsCount > 0) ? Action.DELETE : Action.DELETE_INVALID));
    }
  }
}