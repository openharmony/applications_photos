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
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';
import lazy { BatchRemoveMenuOperation } from '../browserOperation/BatchRemoveMenuOperation';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

const TAG: string = 'common_RemoveFromAction';

/**
 * 移出相册按钮属性
 */
@Observed
export class RemoveFromActionProp extends DefaultActionButtonProp {
  public action = Action.REMOVE_FROM;
  public icon = Action.REMOVE_FROM.iconRes;
  public text = Action.REMOVE_FROM.textRes;
  public key = 'ActionButton_' + Action.REMOVE_FROM.componentKey;
}

/**
 * 移出相册Action注册类
 */
export class RemoveFromRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.remove_from.listener';

  public getActions(): Action[] {
    return [Action.REMOVE_FROM];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new RemoveFromActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return {
      produce: () => {

        let listener: OperationListener | undefined = params.get<OperationListener>(RemoveFromRegister.LISTENER);
        let albumInfo: AlbumInfo = params.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO);
        let allSubClassify: string[] = params.get<string[]>('allSubClassify');
        let mainClassify: string[] = params.get<string[]>('mainClassify');
        let currentCard: string[] = params.get<string[]>('currentCard');

        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withAlbumUri(albumInfo.uri)
          .set(MenuContextConstants.SUB_CLASSIFY, allSubClassify)
          .set(MenuContextConstants.MAIN_CLASSIFY, mainClassify)
          .set(MenuContextConstants.IS_FROM_GROUP, albumInfo.isGroupAlbum)
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new RemoveFromActionProp();
  }
}

/**
 * 移出相册按钮VM层
 */
export class RemoveFromActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    new BatchRemoveMenuOperation(menuContext).doAction();
  }
}