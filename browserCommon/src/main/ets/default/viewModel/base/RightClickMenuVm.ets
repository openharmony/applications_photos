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

import lazy { MenuController } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { UpdateMenuParam } from '../../view/RightClickMenu';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

/* instrument ignore file  */
/**
 * 右键菜单逻辑控制
 */
@Observed
export class RightClickMenuVM {
  @Track public rightClickMenuList: Action[][] = [];
  public menuController: MenuController;
  private item: MediaItem;

  constructor(item: MediaItem) {
    this.item = item;
    this.menuController = new MenuController();
  }

  /**
   * 初始化加载右键菜单
   *
   * @param param 菜单参数
   */
  public onLoadRightClickMenu(param: UpdateMenuParam): void {
  }

  /**
   * 刷新右键菜单列表
   *
   * @param param 菜单参数
   */
  public setMenuGroup(param: UpdateMenuParam): void {
    let firstMenuGroup: Action[] = [];
    if (param.pageFrom === Constants.ENTRY_FROM.RECYCLE) {
      firstMenuGroup = [
        Action.DELETE,
      ];
    } else {
      if (param.pageFrom !== Constants.ENTRY_FROM.HIDDEN) {
        firstMenuGroup.push(Action.MOVE);
      }
      firstMenuGroup.push(Action.NOT_FAVORITE, Action.EDIT, Action.DELETE);
      if (param.isUserCreatedAlbum && param.pageFrom !== Constants.ENTRY_FROM.HIDDEN &&
        !firstMenuGroup.includes(Action.MOVE)) {
        firstMenuGroup.push(Action.REMOVE_FROM);
      }
      firstMenuGroup.push(Action.RENAME);
    }

    if (this.isVideo()) {
      this.handleVideoMenu(firstMenuGroup, param.isVideoPlaying);
    }
    this.rightClickMenuList = [firstMenuGroup];
  }

  /**
   * 处理视频菜单
   *
   * @param firstMenuGroup 第一个菜单列表
   * @param isVideoPlaying 是否视频播放中
   */
  protected handleVideoMenu(firstMenuGroup: Action[], isVideoPlaying: boolean): void {
    firstMenuGroup.unshift(isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY);
  }

  /**
   * 当前是否是视频
   *
   * @returns true 是视频
   */
  public isVideo(): boolean {
    return this.item && this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
  }
}