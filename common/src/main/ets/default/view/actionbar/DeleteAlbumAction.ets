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
import lazy { AlbumSetDeleteMenuOperation } from '../album/AlbumSetDeleteMenuOperation';
import lazy { Log } from '../../utils/Log';

const TAG: string = 'common_DeleteAlbumAction';

/**
 * 删除按钮属性
 */
@Observed
export class DeleteAlbumActionProp extends DefaultActionButtonProp {
  public action = Action.DELETE_ALBUM;
  public icon = Action.DELETE_ALBUM.iconRes;
  public text = Action.DELETE_ALBUM.textRes;
  public key = 'ActionButton_' + Action.DELETE_ALBUM.componentKey;
}

/**
 * 分享Action注册类
 */
export class DeleteAlbumActionRegister extends ActionRegister {
  public static readonly DELETE_ALBUM_LISTENER: string = 'com.ohos.photos.deleteAlbum_listener';

  public getActions(): Action[] {
    return [Action.DELETE_ALBUM];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new DeleteAlbumActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(DeleteAlbumActionRegister.DELETE_ALBUM_LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withFromSelectMode(true)
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST));
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new DeleteAlbumActionProp();
  }
}

/**
 * 点击搜索VM层
 */
export class DeleteAlbumActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    new AlbumSetDeleteMenuOperation(menuContext).doAction();
  }
}