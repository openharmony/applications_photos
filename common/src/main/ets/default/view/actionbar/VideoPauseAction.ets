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
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';

const TAG: string = 'VideoPauseAction';

/**
 * 视频暂停按钮属性，手机平板等场景使用
 */
@Observed
export class VideoPauseActionProp extends DefaultActionButtonProp {
  public action = Action.VIDEO_PAUSE;
  public icon = Action.VIDEO_PAUSE.iconRes;
  public text = Action.VIDEO_PAUSE.textRes;
  public key = 'ActionButton_' + Action.VIDEO_PAUSE.componentKey;
}

/**
 * 视频暂停Action 属性 PC场景使用
 */
@Observed
export class VideoPauseActionPropHugeScreen extends VideoPauseActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 视频暂停Action注册类
 */
export class VideoPauseActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.video_pause_listener';

  public getActions(): Action[] {
    return [Action.VIDEO_PAUSE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new VideoPauseActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(VideoPauseActionRegister.LISTENER);
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
    return DeviceInfo.isPc() ? new VideoPauseActionPropHugeScreen() : new VideoPauseActionProp();
  }
}

/**
 * 点击视频播放VM层
 */
export class VideoPauseActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
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