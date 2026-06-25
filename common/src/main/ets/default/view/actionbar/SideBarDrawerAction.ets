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
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ComponentLifecycleObserver } from '../ComponentLifecycle';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';

const TAG: string = 'SideBarDrawerAction';

/**
 * 侧边栏抽屉按钮属性
 */
@Observed
export class SideBarDrawerActionProp extends DefaultActionButtonProp {
  public action = Action.SIDEBAR_DRAWER;
  public icon = Action.SIDEBAR_DRAWER.iconRes;
  public text = Action.SIDEBAR_DRAWER.textRes;
  public key = 'ActionButton_' + Action.SIDEBAR_DRAWER.componentKey;
}

/**
 * 侧边栏抽屉按钮属性，PC场景使用
 */
@Observed
export class SideBarDrawerActionPropHugeScreen extends SideBarDrawerActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 侧边栏抽屉按钮Action注册类
 */
export class SideBarDrawerActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.drawer_listener';

  public getActions(): Action[] {
    return [Action.SIDEBAR_DRAWER];
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(SideBarDrawerActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .set(ActionRegister.ACTION_BAR_CONTROLLER, params.get(ActionRegister.ACTION_BAR_CONTROLLER))
        return menuContext;
      }
    };
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new DrawerActionViewModel();
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new SideBarDrawerActionPropHugeScreen() : new SideBarDrawerActionProp();
  }
}

/**
 * 侧边栏抽屉按钮VM层
 */
export class DrawerActionViewModel implements ActionViewModel, ComponentLifecycleObserver {
  private isActive: boolean = true;
  private menuContext: MenuContext | undefined = undefined;

  doAction(menuContext?: MenuContext) {
    if (!this.isActive) {
      Log.info(TAG, 'not active');
      return;
    }
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    if (!menuContext.broadCast) {
      Log.error(TAG, `broadcast is undefined`);
      return;
    }
    menuContext.onOperationStart?.();
    menuContext.onOperationEnd?.();
  }

  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.isActive = true;
  }

  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
    this.isActive = false;
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.release();
  }

  public release(): void {
    this.menuContext?.cancel();
    this.menuContext = undefined;
  }
}
