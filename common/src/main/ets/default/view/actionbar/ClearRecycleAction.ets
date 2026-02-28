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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy {
  ActionModel,
  ActionViewModel,
  MenuConstants,
  OperationListener,
  ParamsWrapper
} from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

const TAG: string = 'common_ClearRecycleAction';

/**
 * 清空最近删除属性
 */
@Observed
export class ClearRecycleActionProp extends DefaultActionButtonProp {
  public action = Action.CLEAR_RECYCLE;
  public icon = Action.CLEAR_RECYCLE.iconRes;
  public text = Action.CLEAR_RECYCLE.textRes;
  public key = 'ActionButton_' + Action.CLEAR_RECYCLE.componentKey;
}

/**
 * 清空最近删除Action注册类
 */
export class ClearRecycleActionRegister extends ActionRegister {
  public static readonly CLEAR_RECYCLE_LISTENER: string = 'com.ohos.photos.clear_recycle_listener';

  public getActions(): Action[] {
    return [Action.CLEAR_RECYCLE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new ClearRecycleActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let listener: OperationListener | undefined
      = params.get<OperationListener>(ClearRecycleActionRegister.CLEAR_RECYCLE_LISTENER);
    return {
      produce: () => {
        let menuContext = new MenuContext();
        menuContext
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withAlbumUri(UserFileManagerAccess.getRecycleBinUri())
          .withAlbumInfo(params.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO))
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new ClearRecycleActionProp();
  }
}

/**
 * 删除页右键菜单恢复VM层
 */
export class ClearRecycleActionViewModel implements ActionViewModel {
  public async doAction(menuContext?: MenuContext): Promise<void> {
    Log.info(TAG,'ClearRecycle doAction');
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    menuContext.operate(Action.CLEAR_RECYCLE.actionID);
  }
}
