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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { MenuOperation } from '../browserOperation/MenuOperation';
import lazy { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import { RecoverMenuOperation } from '../browserOperation/RecoverMenuOperation';
import { BatchRecoverMenuOperation } from '../browserOperation/BatchRecoverMenuOperation';

const TAG: string = 'RecoverAction';

@Observed
export class RecoverActionProp extends DefaultActionButtonProp {
  public action = Action.RECOVER;
  public icon = Action.RECOVER.iconRes;
  public text = Action.RECOVER.textRes;
  public key = 'ActionButton_' + Action.RECOVER.componentKey;
}

@Observed
export class RenameActionPropHugeScreen extends RecoverActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

export class RecoverActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.recover.listener';

  public getActions(): Action[] {
    return [Action.RECOVER];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new RecoverActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined = params.get<OperationListener>(RecoverActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withAlbumUri(UserFileManagerAccess.getRecycleBinUri())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withMediaItem(currentPhoto?.getCurrentPhoto())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .set(MenuConstants.KEY_GET_IS_DOING_ACTION, params.get(MenuConstants.KEY_GET_IS_DOING_ACTION))
          .set(MenuConstants.KEY_SET_IS_DOING_ACTION, params.get(MenuConstants.KEY_SET_IS_DOING_ACTION));
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new RenameActionPropHugeScreen() : new RecoverActionProp();
  }
}

/**
 * 重命名Action VM层
 */
export class RecoverActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    Log.info(TAG, 'Recover doAction');
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    let isDoingAction: boolean = false;
    isDoingAction = menuContext.get<Function>(MenuConstants.KEY_GET_IS_DOING_ACTION)?.();
    if (isDoingAction) {
      Log.error(TAG, 'already doing recover');
      return;
    }
    menuContext.get<Function>(MenuConstants.KEY_SET_IS_DOING_ACTION)?.(true);
    if (menuContext.mediaItem) {
      new RecoverMenuOperation(menuContext).doAction();
      return;
    }
    let menuOperation: MenuOperation = MenuOperationFactory.getInstance()
      .createMenuOperation(BatchRecoverMenuOperation, menuContext);
    menuOperation.doAction();
  }
}