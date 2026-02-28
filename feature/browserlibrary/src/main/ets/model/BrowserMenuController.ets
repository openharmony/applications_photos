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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuGroup';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MenuController } from '@ohos/common/src/main/ets/default/view/menu/MenuController';

const TAG: string = 'ThirdMoreMenuController';

export interface UpdateMenuParamCamera {
  hasUnFavor: boolean;
  isVideo:boolean;
  canWallPaper: boolean;
  isExportVideo: boolean;
  invalidFlag: boolean;
  canPrint: boolean;
  isSandboxEnv: boolean;
  hasWrite: boolean;
}

@Observed
export class BrowserMenuController extends MenuController {
  private applicationActionList: Action[] = [
    Action.SET_WALLPAPER,
  ];
  private lowActionList: Action[] = [
    Action.MOVE,
    Action.MOVE_INVALID,
    Action.RENAME,
    Action.RENAME_INVALID,
    Action.SLIDE_SHOW
  ];

  constructor() {
    super();
  }

  /**
   * 初始化菜单项
   *
   * @param boolList 菜单项显示条件集合
   */
  public initMenu(param: UpdateMenuParamCamera): void {
    Log.info(TAG, `initMenu`);
    const applicationBoolList: boolean[] = this.getApplicationFeaturesBoolList(param);
    const lowBoolList: boolean[] = this.getLowFrequencyBoolList(param);
    const applicationGroup: RightClickMenuGroup =
      new RightClickMenuGroup(this.applicationActionList, applicationBoolList);
    const lowGroup: RightClickMenuGroup = new RightClickMenuGroup(this.lowActionList, lowBoolList);

    super.setMenuGroupList([applicationGroup, lowGroup]);
  }

  /**
   * 判断条件变更刷新GroupList
   *
   * @param param
   */
  public dealMenuGroupByParams(param: UpdateMenuParamCamera): void {
    const applicationBoolList: boolean[] = this.getApplicationFeaturesBoolList(param);
    const lowBoolList: boolean[] = this.getLowFrequencyBoolList(param);

    super.dealMenuGroup([applicationBoolList, lowBoolList]);
  }

  /**
   * 处理PC菜单group中的M菜单项是否显示判断条件List
   *
   * @param param
   * @returns boolList
   */
  private getApplicationFeaturesBoolList(param: UpdateMenuParamCamera): boolean[] {
    const canWallPaper: boolean = param.canWallPaper;
    const boolList: boolean[] = [
      canWallPaper,
    ];
    return boolList;
  }

  /**
   * 处理PC菜单group中的M菜单项是否显示判断条件List
   *
   * @param param
   * @returns boolList
   */
  private getLowFrequencyBoolList(param: UpdateMenuParamCamera): boolean[] {
    const invalidFlag: boolean = param.invalidFlag;
    const isExportVideo: boolean = param.isExportVideo;
    const canPrint: boolean = param.canPrint;
    const isSandboxEnv: boolean = param.isSandboxEnv;
    const hasWrite: boolean = param.hasWrite;
    const isVideo: boolean = param.isVideo;
    const boolList: boolean[] = [
      invalidFlag,
      !invalidFlag,
      invalidFlag,
      !invalidFlag,
      true,
      canPrint,
      hasWrite && isExportVideo && isSandboxEnv,
      invalidFlag,
      !invalidFlag,
      !isVideo,
    ];
    return boolList;
  }
}