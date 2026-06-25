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
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { AlbumSetRenameMenuOperation } from '../album/AlbumSetRenameMenuOperation';
import common from '@ohos.app.ability.common';

const TAG: string = 'common_RenameAction';

/**
 * 删除按钮属性
 */
@Observed
export class RenameAlbumActionProp extends DefaultActionButtonProp {
  public action = Action.RENAME_ALBUM;
  public icon = Action.RENAME_ALBUM.iconRes;
  public text = Action.RENAME_ALBUM.textRes;
  public key = 'ActionButton_' + Action.RENAME_ALBUM.componentKey;
}

/**
 * 分享Action注册类
 */
export class RenameAlbumActionRegister extends ActionRegister {
  public static readonly DELETE_LISTENER: string = 'com.ohos.photos.delete_listener';

  public getActions(): Action[] {
    return [Action.RENAME_ALBUM];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new RenameAlbumActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(RenameAlbumActionRegister.DELETE_LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withFromSelectMode(true)
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withUIContext(getContext(this) as common.UIAbilityContext)
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new RenameAlbumActionProp();
  }
}

/**
 * 点击搜索VM层
 */
export class RenameAlbumActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    new AlbumSetRenameMenuOperation(menuContext).doAction();
  }
}