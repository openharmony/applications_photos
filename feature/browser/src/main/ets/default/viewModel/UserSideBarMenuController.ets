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
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuGroup';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

/* instrument ignore file */
const TAG: string = 'UserSideBarMenuController';

export interface UpdateMenuParamUserAlbum {
  canRename: boolean;
}

@Observed
export class UserSideBarMenuController extends MenuController {
  private actionList: Action[] = [Action.RENAME_ALBUM, Action.DELETE_ALBUM];

  constructor() {
    super();
  }

  /**
   * 初始化菜单项
   *
   * @param boolList 菜单项显示条件集合
   */
  public initMenu(param: UpdateMenuParamUserAlbum): void {
    Log.info(TAG, `initMenu`);
    const boolList: boolean[] = this.getActionMoreBoolListGrid(param)
    const group: RightClickMenuGroup = new RightClickMenuGroup(this.actionList, boolList);

    super.setMenuGroupList([group]);
  }

  /**
   * 判断条件变更刷新GroupList
   *
   * @param param
   */
  public dealMenuGroupByParams(param: UpdateMenuParamUserAlbum): void {
    const boolList: boolean[] = this.getActionMoreBoolListGrid(param)

    super.dealMenuGroup([boolList]);
  }

  /**
   * 处理PC菜单group中的M菜单项是否显示判断条件List
   *
   * @param param
   * @returns boolList
   */
  private getActionMoreBoolListGrid(param: UpdateMenuParamUserAlbum): boolean[] {
    const canRename: boolean = param.canRename;
    const boolList: boolean[] = [
      canRename,
      true,
    ];
    return boolList;
  }
}