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

import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { Log } from '../../../default/utils/Log';


import lazy { ToolBar } from '../../../../../../../browserCommon/src/main/ets/default/view/actionbar/ToolBar';

/* instrument ignore file */
const TAG: string = 'browser_AlbumSetPageToolBar';

@Component
export struct AlbumSetPageToolBar {
  @Provide isShowBar: boolean = true;
  @Provide toolMenuList: Action[] = [];
  @State moreMenuList: Action[] = [];
  @Consume @Watch('updateToolbar') isAlbumSetSelectedMode: boolean;
  @Consume('selectedCount') @Watch('updateToolbar') selectedAlbumsCount: number;
  @Consume isDisableRename: boolean;
  @Consume isDisableDelete: boolean;
  onMenuClicked: Function = (): void => {
  };
  @Provide hidePopup: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.updateToolbar();
  }

  build() {
    ToolBar({
      onMenuClicked: this.onMenuClicked,
      isFoldableAlbumMultiChoice: DeviceInfo.isFoldable(),
      moreMenuList: this.moreMenuList,
    })
  }

  private updateToolbar(): void {
    Log.info(TAG, 'updateToolbar');
    if (this.isAlbumSetSelectedMode) {
      Log.info(TAG, 'pushToolbar');
      this.toolMenuList = [];
      this.toolMenuList.push(
        !this.isDisableRename && this.selectedAlbumsCount === 1 ? Action.RENAME_ALBUM : Action.RENAME_ALBUM_INVALID,
        !this.isDisableDelete && this.selectedAlbumsCount > 0 ? Action.DELETE_ALBUM : Action.DELETE_ALBUM_INVALID);
    }
  }
}