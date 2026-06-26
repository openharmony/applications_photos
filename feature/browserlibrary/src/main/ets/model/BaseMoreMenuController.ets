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

import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { MenuController, RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';

const TAG: string = 'BaseMoreMenuController';

export interface UpdateMenuParamCamera {
  hasUnFavor: boolean;
  isVideo: boolean;
  canWallPaper: boolean;
  isExportVideo: boolean;
  invalidFlag: boolean;
  canPrint: boolean;
  isSandboxEnv: boolean;
  hasWrite: boolean;
}

export interface UpdateMenuParamBrowser {
  pageFrom: number;
  isUserCreatedAlbum: boolean;
  isVideoPlaying: boolean;
  isFromPortrait: boolean;
  hasUnFavor: boolean;
  isVideo: boolean;
  canWallPaper: boolean;
  isExportVideo: boolean;
  canSlideShow: boolean;
  canPrint: boolean;
  isHidden: boolean;
}

@Observed
export class BaseMoreMenuController extends MenuController {
  constructor() {
    super();
  }

  /**
   * 初始化菜单项
   *
   * @param boolList 菜单项显示条件集合
   */
  public initMenu(param: ParamsWrapper): void {
  }

  /**
   * 判断条件变更刷新GroupList
   */
  public dealMenuGroupByParams(param: ParamsWrapper): void {
  }

  public getMenuGroupListWithoutEmpty(): RightClickMenuGroup[] {
    return super.getMenuGroupListWithoutEmpty();
  }

  public getMenuGroupList(): RightClickMenuGroup[] {
    return super.getMenuGroupList();
  }

  public setMenuGroupList(list: RightClickMenuGroup[]): void {
    super.setMenuGroupList(list);
  }

  public dealMenuGroup(boolListArray: boolean[][]): void {
    super.dealMenuGroup(boolListArray);
  }
}