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
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { BroadCast } from '../../utils/BroadCast';

const TAG: string = 'SlideShowAction';

/**
 * 播放幻灯片按钮属性，手机平板等场景使用
 */
@Observed
export class SlideShowActionProp extends DefaultActionButtonProp {
  public action = Action.SLIDE_SHOW;
  public icon = Action.SLIDE_SHOW.iconRes;
  public text = Action.SLIDE_SHOW.textRes;
  public key = 'ActionButton_' + Action.SLIDE_SHOW.componentKey;
}

/**
 * 播放幻灯片Action 属性 PC场景使用
 */
@Observed
export class SlideShowActionPropHugeScreen extends SlideShowActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 播放幻灯片Action注册类
 */
export class SlideShowActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.slide_show_listener';

  public getActions(): Action[] {
    return [Action.SLIDE_SHOW];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new SlideShowActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(SlideShowActionRegister.LISTENER);
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
    return DeviceInfo.isPc() ? new SlideShowActionPropHugeScreen() : new SlideShowActionProp();
  }
}

/**
 * 点击截屏VM层
 */
export class SlideShowActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    if (!menuContext.mediaItem) {
      Log.error(TAG, 'slideShow currentPhoto is undefined.');
      return;
    }
    menuContext.onOperationStart?.();
    menuContext.onOperationEnd?.();
  }
}