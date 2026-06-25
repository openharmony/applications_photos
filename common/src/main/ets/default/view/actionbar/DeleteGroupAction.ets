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

import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import { ActionRegister } from './ActionRegister';
import { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import { SelectManager } from '../../model/browser/SelectManager';
import type { BroadCast } from '../../utils/BroadCast';
import { DeleteGroupMenuOperation } from '../browserOperation/DeleteGroupMenuOperation';
import { Log } from '../../utils/Log';
import { Constants } from '../../model/common/Constants';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import { MediaItem } from '../../model/browser/photo/MediaItem';
import  { AlbumDataSource } from '../../model/AlbumDataSource';

const TAG: string = 'DeleteGroupAction';

/**
 * 删除按钮属性
 */
@Observed
export class DeleteGroupActionProp extends DefaultActionButtonProp {
  public action = Action.DELETE_GROUP;
  public icon = Action.DELETE_GROUP.iconRes;
  public text = Action.DELETE_GROUP.textRes;
  public key = 'ActionButton_' + Action.DELETE_GROUP.componentKey;
}

/**
 * 删除Action注册类
 */
export class DeleteGroupActionRegister extends ActionRegister {
  public static readonly DELETE_GROUP_LISTENER: string = 'com.ohos.photos.delete_group_listener';

  public getActions(): Action[] {
    return [Action.DELETE_GROUP];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new DeleteGroupActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let listener: OperationListener | undefined =
      params.get<OperationListener>(DeleteGroupActionRegister.DELETE_GROUP_LISTENER);
    return {
      produce: () => {
        return new MenuContext()
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withAlbumInfo(params.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO))
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withDataSource(params.get<AlbumDataSource>(MenuConstants.KEY_DATASOURCE));
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new DeleteGroupActionProp();
  }
}

/**
 * 删除操作VM层
 */
export class DeleteGroupActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    let albumInfo: AlbumInfo | undefined = menuContext.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO);
    if (albumInfo) {
      menuContext.withAlbumInfo(albumInfo);
    }
    new DeleteGroupMenuOperation(menuContext).doAction();
  }
}