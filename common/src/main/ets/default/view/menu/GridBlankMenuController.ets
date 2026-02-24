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

import lazy { MenuController } from './MenuController';
import lazy { Action } from '../browserOperation/Action';
import lazy { RightClickMenuGroup } from './MenuGroup';

export interface UpdateMenuParamGridBlank {
  canPasteAlbum: boolean;
  isAllSelected: boolean;
}

@Observed
export class GridBlankMenuController extends MenuController {
  private actionList: Action[] = [
    Action.PASTE_FROM_PASTEBOARD,
    Action.DESELECT_ALL,
    Action.SELECT_ALL,
  ];

  constructor() {
    super();
  }

  /**
   * 处理PC菜单group中的M菜单项是否显示判断条件List
   *
   * @param param
   * @returns boolList
   */
  private getGridBoolList(param: UpdateMenuParamGridBlank): boolean[] {
    const canPasteAlbum = param.canPasteAlbum;
    const isAllSelected = param.isAllSelected;
    const boolList: boolean[] = [
      canPasteAlbum,
      isAllSelected,
      !isAllSelected,
      canPasteAlbum,
      canPasteAlbum,
    ];
    return boolList;
  }

  /**
   * 判断条件变更刷新GroupList
   *
   * @param param
   */
  public dealMenuGroupByParams(param: UpdateMenuParamGridBlank): void {
    const boolList: boolean[] = this.getGridBoolList(param);
    super.dealMenuGroup([boolList]);
  }

  /**
   * 初始化菜单项
   *
   * @param boolList 菜单项显示条件集合
   */
  public initMenu(params: UpdateMenuParamGridBlank): void {
    const boolList: boolean[] = this.getGridBoolList(params);
    const group: RightClickMenuGroup = new RightClickMenuGroup(this.actionList, boolList);
    this.setMenuGroupList([group]);
  }
}