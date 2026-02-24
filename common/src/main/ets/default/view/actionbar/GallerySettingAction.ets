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

/* instrument ignore file */
const TAG = 'GallerySettingAction';

@Observed
export class GallerySettingActionProp extends DefaultActionButtonProp {
  public action = Action.GALLERY_SETTINGS;
  public text = $r('app.string.action_setting');
  public key = 'ActionButton_GallerySetting';
}

/**
 * Action注册类
 */
export class GallerySettingActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.GALLERY_SETTINGS];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new GallerySettingActionViewModel(params?.get<NavPathStack>(
      MenuConstants.KEY_NAV_PATH_STACK) as NavPathStack);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new GallerySettingActionProp();
  }
}

/**
 * VM层
 */
export class GallerySettingActionViewModel implements ActionViewModel {
  private readonly navigationPageInfos: NavPathStack;

  /**
   * 构造函数
   * @param navigationPageInfos 导航栈
   */
  public constructor(navigationPageInfos: NavPathStack) {
    this.navigationPageInfos = navigationPageInfos;
  }

  public doAction(menuContext?: MenuContext): void {
    // 导航到设置页
    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS]).then(() => {
      this.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS, null));
    });
  }
}