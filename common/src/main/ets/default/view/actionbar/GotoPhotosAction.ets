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
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { GotoPhotosMenuOperation } from '../browserOperation/GotoPhotosMenuOperation';
import lazy { AppStorageKeys } from '../../utils/AppStorageKeys';

const TAG: string = 'GotoPhotosAction';
const GOTO_PHOTOS_BUTTON_KEY: string = 'ActionButton_' + Action.GOTO_PHOTOS.componentKey;

/**
 * 跳转图库按钮属性
 */
@Observed
export class GotoPhotosActionProp extends DefaultActionButtonProp {
  public action = Action.GOTO_PHOTOS;
  public icon = $r('sys.symbol.picture');
  public text = $r('app.string.action_goto_photos');
  public key = GOTO_PHOTOS_BUTTON_KEY;
}

/**
 * 跳转图库按钮属性，PC场景使用
 */
@Observed
export class GotoPhotosActionPropHugeScreen extends GotoPhotosActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 跳转图库Action注册类
 */
export class GotoPhotosActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.goto_photos_listener';

  public getActions(): Action[] {
    return [Action.GOTO_PHOTOS];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new GotoPhotosActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhotoParam: BrowserControlInterface | undefined =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(GotoPhotosActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withJumpSourceToMain(params.get<number>(MenuConstants.KEY_JUMP_SOURCE_TO_MAIN))
          .withMediaItem(currentPhotoParam?.getCurrentPhoto())
          .set(ActionRegister.ACTION_BAR_CONTROLLER, params.get(ActionRegister.ACTION_BAR_CONTROLLER))
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new GotoPhotosActionPropHugeScreen() : new GotoPhotosActionProp();
  }
}

/**
 * 点击跳转图库VM层
 */
export class GotoPhotosActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    if (!menuContext.broadCast) {
      Log.error(TAG, 'broadcast is undefined');
      return;
    }
    if (!menuContext.mediaItem) {
      Log.error(TAG, 'currentPhoto is undefined.');
      return;
    }
    AppStorage.setOrCreate<string>(AppStorageKeys.FORM_CURRENT_URI, '');
    menuContext.onOperationStart?.();
    new GotoPhotosMenuOperation(menuContext).doAction();
    menuContext.onOperationEnd?.();
  }
}