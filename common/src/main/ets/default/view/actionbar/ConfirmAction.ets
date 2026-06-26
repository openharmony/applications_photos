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

import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionButtonProp, applyPcStyles, DefaultActionButtonProp } from './ActionButton';
import lazy { ActionViewModel, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { Log } from '../../utils/Log';

/**
 * 确认
 */
/* instrument ignore file */
const TAG = 'ConfirmAction';

/**
 * 按钮属性
 */
@Observed
export class ConfirmActionProp extends DefaultActionButtonProp {
  public action = Action.OK;
  public icon = Action.OK_ICON;
  public text = $r('app.string.action_ok');
  public key = 'ActionButton_check';
  public fillColor = $r('sys.color.icon_primary');
}

/**
 * 按钮属性，PC场景使用
 */
@Observed
export class ConfirmActionPropPc extends ConfirmActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * Action注册类
 */
export class ConfirmActionRegister extends ActionRegister {
  private readonly handler: () => void;

  /**
   * 构造函数
   * @param handler 处理器
   */
  public constructor(handler?: () => void) {
    super();
    this.handler = handler ?? ((): void => {
    });
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new ConfirmActionViewModel(this.handler);
  }

  public getActions(): Action[] {
    return [Action.OK];
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new ConfirmActionPropPc() : new ConfirmActionProp();
  }
}

export class ConfirmActionViewModel implements ActionViewModel {
  private readonly handler: () => void;

  /**
   * 构造函数
   * @param params 参数
   */
  public constructor(handler: () => void) {
    this.handler = handler;
  }

  public doAction(menuContext?: MenuContext): void {
    Log.info(TAG, 'doAction');
    this.handler?.();
  }
}