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

import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Log } from '../../utils/Log';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { BroadCast } from '../../utils/BroadCast';

const TAG: string = 'LoopPlayAction';

/**
 * 动图循环播放按钮属性
 */
@Observed
export class LoopPlayActionProp extends DefaultActionButtonProp {
  public action = Action.LOOP_PLAY;
  public icon = Action.LOOP_PLAY.iconRes;
  public text = Action.LOOP_PLAY.textRes;
  public key = 'ActionButton_' + Action.LOOP_PLAY.componentKey;
}

/**
 * 动图循环播放按钮属性，PC场景使用
 */
@Observed
export class LoopPlayActionPropHugeScreen extends LoopPlayActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 动图循环播放按钮Action注册类
 */
export class LoopPlayActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.loop_play_listener';

  public getActions(): Action[] {
    return [Action.LOOP_PLAY];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new LoopPlayActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface | undefined =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    let listener: OperationListener | undefined =
      params.get<OperationListener>(LoopPlayActionRegister.LISTENER);
    return {
      produce: () => {
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withMediaItem(currentPhoto?.getCurrentPhoto())
          .set(ActionRegister.ACTION_BAR_CONTROLLER, params.get(ActionRegister.ACTION_BAR_CONTROLLER))
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new LoopPlayActionPropHugeScreen() : new LoopPlayActionProp();
  }
}

/**
 * 动图循环播放VM层
 */
export class LoopPlayActionViewModel implements ActionViewModel {
  doAction(menuContext?: MenuContext) {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    if (!menuContext.mediaItem) {
      Log.error(TAG, 'VideoPause current item is undefined.');
      return;
    }
    menuContext.onOperationStart?.();
    menuContext.onOperationEnd?.();
  }
}
