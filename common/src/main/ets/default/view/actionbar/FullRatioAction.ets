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

import { Log } from '@ohos/tools/src/main/utils/Log';
import { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import { ActionRegister } from './ActionRegister';
import { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper } from './Menu';
import { MenuContext } from '../browserOperation/MenuContext';
import { BroadCast } from '../../utils/BroadCast';
import { Action } from '../browserOperation/Action';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';

const TAG: string = 'FullRatioAction';

/**
 * 正方形按钮属性
 */
@Observed
export class FullRatioActionProp extends DefaultActionButtonProp {
  public action = Action.FULL_RATIO;
  public key = 'ActionButton_' + Action.FULL_RATIO.componentKey;
}

/**
 * 正方形按钮属性，PC场景使用
 */
@Observed
export class FullRatioActionPropHugeScreen extends FullRatioActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 分享Action注册类
 */
export class FullRatioActionRegister extends ActionRegister {

  public getActions(): Action[] {
    return [Action.FULL_RATIO];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new FullRatioActionViewModel(params.get<BroadCast>(MenuConstants.KEY_BROADCAST));
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return { produce: () => new MenuContext() };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new FullRatioActionPropHugeScreen();
  }
}

/**
 * 点击正方形VM层
 */
export class FullRatioActionViewModel implements ActionViewModel {
   protected tag: string = 'common_FullRatioActionViewModel';
   private broadCast: BroadCast;

   public constructor( broadCast: BroadCast) {
    this.broadCast = broadCast;
   }

  public doAction(): void {
    Log.info(this.tag, 'doAction');
    this.broadCast?.emit(BroadCastConstants.UPDATE_ALBUM_GRID_FULL_RATIO, []);
  }
}