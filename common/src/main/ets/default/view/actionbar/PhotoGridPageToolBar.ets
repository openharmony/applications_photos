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
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { Log } from '../../../default/utils/Log';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess'
import lazy { ToolBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ToolBar';
import lazy { getScreen } from '../../../default/model/common/ScreenManager';
import lazy { display } from '@kit.ArkUI';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { CREATION, CREATION_INVALID } from './CreationAction';
import lazy { MOVIE, MOVIE_INVALID } from './MovieAction';
import lazy { VIDEO_SPLICING, VIDEO_SPLICING_INVALID } from './VideoSplicingAction';
import lazy { DeviceInfo as DeviceInfoMovie } from '../../../default/utils/DeviceInfo';

/* instrument ignore file */

const TAG: string = 'browser_PhotoGridPageToolBar';

export enum FeatureType {
  FEATURE_PHOTO_CREATE, // 图库创作特性
  FEATURE_PHOTO_AUTO_CLIP //流光易剪
}

@Component
export struct PhotoGridPageToolBar {
  @Link @Watch('updateToolbar') private isSelectedMode: boolean;
  @Consume @Watch('updateToolbar') isAllSelected: boolean;
  @Link @Watch('updateToolbar') totalSelectedCount: number;
  @Provide selectedCount: number = 0;
  @Consume isEmpty: boolean;
  public isRecycleAlbum: boolean = false;
  @Link isDataFreeze: boolean;
  onMenuClicked: Function = (): void => {
  };
  public isDistributedAlbum: boolean = false;
  @Provide toolMenuList: Action[] = [];
  @Consume hidePopup: boolean;
  public isPhotoCityGrid: boolean = false;
  public albumUri: string = '';
  @Link isScreenRecordingAlbum: boolean;
  @StorageLink('isFullMode') @Watch('updateToolbar') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('getFoldStatus') @Watch('updateToolbar') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('updateToolbar') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @Link private moreMenuList: Action[];
  @Link private creationMenuList: Action[];
  private isDuplicateAlbum: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.updateToolbar();
  }

  build() {
    ToolBar({
      onMenuClicked: this.onMenuClicked,
      totalSelectedCount: this.totalSelectedCount,
      moreMenuList: this.moreMenuList,
      creationMenuList: this.creationMenuList,
    })
  }

  public getFeatureType(type: FeatureType): boolean {
    return false;
  }

  private getVideoMenuList(): void {
    if(DeviceInfoMovie.isSupportMovie()){
      if (this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE)) {
        this.toolMenuList.push(this.selectedCount === 0 ? VIDEO_SPLICING_INVALID : VIDEO_SPLICING);
      }
      if (this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) {
        this.toolMenuList.push(this.selectedCount === 0 ? MOVIE_INVALID : MOVIE);
      }
      this.toolMenuList.push(
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    }else{
      this.toolMenuList.push(Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    }
  }
  private updateToolbar(): void {
    Log.info(TAG, 'updateToolbar');
    this.selectedCount = this.totalSelectedCount;
    if (this.isSelectedMode) {
      this.toolMenuList = [];
      /* instrument ignore next */
      if (DeviceInfo.isFoldable() && this.isFullMode && !DeviceInfo.isPhoneVde()) {
        return;
      }
      if (this.isRecycleAlbum) {
        this.toolMenuList.push(Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
      } else if (this.isDistributedAlbum) {
        this.toolMenuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
      } else if (this.isDuplicateAlbum) {
        this.toolMenuList.push(Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
      } else {
        if (this.albumUri === UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)) {
          this.getVideoMenuList();
        } else if (this.isScreenRecordingAlbum) {
          this.getVideoMenuList();
        } else {
          /* instrument ignore next */
          if (DeviceInfo.isVerdeFoldable()) {
            this.toolMenuList.push(
              Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
          } else {
            if (DeviceInfoMovie.isSupportMovie()) {
              this.toolMenuList.push(
                (this.selectedCount === 0 ? CREATION_INVALID : CREATION),
                  Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
            } else {
              this.toolMenuList.push(Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
            }
          }
        }
      }
    } else {
      if (this.isRecycleAlbum && !this.isDataFreeze) {
        this.toolMenuList = [];
        this.toolMenuList.push(this.isEmpty ? Action.CLEAR_RECYCLE_INVALID : Action.CLEAR_RECYCLE);
      }
    }
  }
}