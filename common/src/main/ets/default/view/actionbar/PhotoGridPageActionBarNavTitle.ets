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

import lazy { Action, ActionID, SubMenuParamType } from '../../../default/view/browserOperation/Action';
import lazy { ActionBarController } from '../../../default/view/ActionBarController';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { Log } from '../../../default/utils/Log';
import lazy { PhotoGridPageActionBar } from './PhotoGridPageActionBar';

/* instrument ignore file */
const TAG: string = 'browser_PhotoGridPageActionBarNavTitle';

@Component
export struct PhotoGridPageActionBarNavTitle {
  @ObjectLink @Watch('onActionBarControllerChanged') actionBarController: ActionBarController;
  @Provide @Watch('onIsAllSelectedChanged') isAllSelected: boolean = false;
  @State @Watch('onMoreMenuListChanged') moreMenuList: Action[] = [];
  @State creationMenuList: Action[] = [];
  @Provide @Watch('onIsEmptyChanged') isEmpty: boolean = false;
  @State @Watch('onTotalSelectedCountChanged') totalSelectedCount: number = 0;
  @State @Watch('onActionMoreMenuListChanged') actionMoreMenuList: Action[] = [];
  @Link private isSelectedMode: boolean;
  private albumInfo?: AlbumInfo;
  public isNavDestinationPageActionBar: boolean = false;
  public isFromPortrait: boolean = false;
  public isFromPortraitCoverSet: boolean = false;
  @State isScreenRecordingAlbum: boolean = false;

  onActionBarControllerChanged(): void {
    this.isAllSelected = this.actionBarController.isAllSelected;
    this.moreMenuList = this.actionBarController.moreMenuList;
    this.creationMenuList = this.actionBarController.creationMenuList;
    this.totalSelectedCount = this.actionBarController.totalSelectedCount;
    this.actionMoreMenuList = this.actionBarController.actionMoreMenuList;
  }

  onIsAllSelectedChanged(): void {
    this.actionBarController.isAllSelected = this.isAllSelected;
  }

  onMoreMenuListChanged(): void {
    this.actionBarController.moreMenuList = this.moreMenuList;
  }

  onIsEmptyChanged(): void {
    this.actionBarController.isEmpty = this.isEmpty;
  }

  onTotalSelectedCountChanged(): void {
    this.actionBarController.totalSelectedCount = this.totalSelectedCount;
  }

  onActionMoreMenuListChanged(): void {
    this.actionBarController.actionMoreMenuList = this.actionMoreMenuList;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.isAllSelected = this.actionBarController.isAllSelected;
    this.moreMenuList = this.actionBarController.moreMenuList;
    this.creationMenuList = this.actionBarController.creationMenuList;
    this.actionMoreMenuList = this.actionBarController.actionMoreMenuList;
    this.totalSelectedCount = this.actionBarController.totalSelectedCount;
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
  }

  onMenuClicked(action: Action, param?: SubMenuParamType): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    this.actionBarController?.handleClick(action, param);
  }

  build() {
    PhotoGridPageActionBar({
      title: this.albumInfo?.albumName,
      isFromFa: false,
      albumInfo: this.albumInfo,
      onMenuClicked: (action: Action, param?: SubMenuParamType): void => this.onMenuClicked(action, param),
      isDistributedAlbum: false,
      totalSelectedCount: $totalSelectedCount,
      isNavTitle: true,
      actionMoreMenuList: $actionMoreMenuList,
      isNavDestinationPageActionBar: this.isNavDestinationPageActionBar,
      isFromPortraitCoverSet: this.isFromPortraitCoverSet,
      isFromPortrait: this.isFromPortrait,
      isScreenRecordingAlbum: $isScreenRecordingAlbum,
      isSelectedMode: this.isSelectedMode,
      moreMenuList: this.moreMenuList,
      creationMenuList: this.creationMenuList,
    })
  }
}