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
 * 取消
 */
/* instrument ignore file */
const TAG = 'CancelAction';

/**
 * 按钮属性
 */
@Observed
export class CancelActionProp extends DefaultActionButtonProp {
  public action = Action.CANCEL;
  public icon = Action.CANCEL_ICON;
  public text = $r('app.string.action_cancel');
  public key = 'ActionButton_Cancel';
  public fillColor = $r('sys.color.icon_primary');
}

/**
 * 按钮属性，PC场景使用
 */
@Observed
export class CancelActionPropPc extends CancelActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * Action注册类
 */
export class CancelActionRegister extends ActionRegister {
  private readonly viewModel: ActionViewModel | undefined;
  private readonly handler: () => void;

  /**
   * 构造函数
   * @param handler 处理器
   */
  public constructor(handler?: () => void, viewModel?: ActionViewModel) {
    super();
    this.handler = handler ?? ((): void => {
    });
    this.viewModel = viewModel;
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return this.viewModel ?? new CancelActionViewModel(this.handler);
  }

  public getActions(): Action[] {
    return [Action.CANCEL];
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new CancelActionPropPc() : new CancelActionProp();
  }
}

export class CancelActionViewModel implements ActionViewModel {
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