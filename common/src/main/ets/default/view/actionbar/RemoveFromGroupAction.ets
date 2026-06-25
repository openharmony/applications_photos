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
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { RemoveFromGroupOperation } from '../browserOperation/RemoveFromGroupOperation';
import lazy { RemoveFromRegister } from './RemoveFromAction';

const TAG: string = 'common_RemoveFromGroupAction';

/**
 * 分享按钮属性，手机平板等场景使用
 */
@Observed
export class RemoveFromGroupActionProp extends DefaultActionButtonProp {
  public action = Action.REMOVE_FROM_GROUP;
  public icon = Action.REMOVE_FROM_GROUP.iconRes;
  public text = Action.REMOVE_FROM_GROUP.textRes;
  public key = 'ActionButton_' + Action.REMOVE_FROM_GROUP.componentKey;
}

/**
 * 分享Action注册类
 */
export class RemoveFromGroupActionRegister extends RemoveFromRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.remove_from_group_listener';

  public getActions(): Action[] {
    return [Action.REMOVE_FROM_GROUP];
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new RemoveFromGroupActionProp();
  }
}