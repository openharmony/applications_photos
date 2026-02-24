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
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionViewModel, MenuConstants, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { NavigationBroadCastManager } from '../../model/common/NavigationBroadCastManager';

@Observed
export class AboutActionProp extends DefaultActionButtonProp {
  public action = Action.ABOUT_GALLERY;
  public text = $r('app.string.about');
  public key = 'ActionButton_About';
}

/**
 * Action注册类
 */
export class AboutActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.ABOUT_GALLERY];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new AboutActionViewModel(params?.get<NavPathStack>(
      MenuConstants.KEY_NAV_PATH_STACK) as NavPathStack);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new AboutActionProp();
  }
}

/**
 * VM层
 */
export class AboutActionViewModel implements ActionViewModel {
  private readonly navigationPageInfos: NavPathStack;

  /**
   * 构造函数
   * @param navigationPageInfos 导航栈
   */
  public constructor(navigationPageInfos: NavPathStack) {
    this.navigationPageInfos = navigationPageInfos;
  }

  public doAction(menuContext?: MenuContext): void {
    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY]).then(() => {
      this.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_ABOUT_GALLERY, null));
    });
  }
}