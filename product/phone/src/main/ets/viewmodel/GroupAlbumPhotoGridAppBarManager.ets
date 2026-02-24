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

/* instrument ignore file */
import lazy { MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumPhotoGridAppBarManager } from './AlbumPhotoGridAppBarManager';
import lazy { ActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/ActionRegister';
import lazy { DeleteGroupActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteGroupAction';
import lazy { RemoveFromGroupActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/RemoveFromGroupAction';
import lazy { MoreActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/MoreAction';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import { RemoveFromRegister } from '@ohos/common/src/main/ets/default/view/actionbar/RemoveFromAction';

const TAG: string = 'GroupAlbumPhotoGridAppBarManager';

export class GroupAlbumPhotoGridAppBarManager extends AlbumPhotoGridAppBarManager {
  // public navigationPageInfos: NavPathStack = new NavPathStack();

  // constructor(dataSource: AlbumDataSource | undefined,
    // navPathStack: NavPathStack) {
    // super(dataSource);
    // this.navigationPageInfos = navPathStack;
  // }

  protected registerMoreAction(params: ParamsWrapper): void { // 非选择模式配置，合影相册按钮配置
    // 更多菜单
    let moreRegisters: ActionRegister[] = [];

    // 删除合影相册
    moreRegisters.push(new DeleteGroupActionRegister());

    new MoreActionRegister(moreRegisters).register(params);
    this.setActionEnabled(Action.MORE, true);
  }

  protected registerMoreSelectActions(params: ParamsWrapper): ActionRegister[] {
    let registers: ActionRegister[] = [];
    super.registerMoreSelectActions(params).forEach((action: ActionRegister) => {
      registers.push(action);
    });
    return registers;
  }

  /**
   * back键返回
   */
  protected backFunc(): void {
    Log.info(TAG, 'Return to the previous page doAnimation');
    // this.navigationPageInfos.pop();
  }
}