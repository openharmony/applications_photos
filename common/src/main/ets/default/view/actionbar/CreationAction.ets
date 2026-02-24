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
import lazy { ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { MoreActionRegister, MoreActionProp } from './MoreAction';
import lazy { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import lazy { Constants } from '../../model/common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { MoviePageConstants } from '../../utils/MoviePageConstants';

const CREATION_TEXT: string = '创作';
export const COMPONENT_KEY_CREATION: string = 'Creation';

export const COMPONENT_KEY_CREATION_INVALID: string = 'Creation';

export const CREATION: Action = new Action({
  id: Action.uuid,
  iconRes: $r('sys.symbol.lightbulb_max'),
  textRes: $r('app.string.action_creation'),
  componentKey: COMPONENT_KEY_CREATION,
});

export const CREATION_INVALID: Action = new Action({
  id: Action.uuid,
  iconRes: $r('sys.symbol.lightbulb_max'),
  textRes: $r('app.string.action_creation'),
  componentKey: COMPONENT_KEY_CREATION_INVALID,
  isInvalid: true,
});

/* instrument ignore file */
const TAG = 'CreationAction';

/**
 * 按钮属性，手机平板等场景使用
 */
@Observed
export class CreationActionProp extends MoreActionProp {
  public action = CREATION;
  public icon = $r('sys.symbol.lightbulb_max');
  public text: string | Resource = $r('app.string.action_creation');
  public key = 'ActionButton_' + CREATION.componentKey;
  public isShowIcon: boolean | undefined = true;
  public menuItemGroupDivider: DividerStyleOptions | undefined = {
    strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
    color: $r('sys.color.ohos_id_color_list_separator'),
    startMargin: LengthMetrics.vp(MoviePageConstants.MENU_DIVIDER_START_MARGIN),
    endMargin: LengthMetrics.vp(Constants.MENU_DIVIDER_END_MARGIN - Constants.MENU_ITEM_START_MARGIN),
  }
  public menuItemDivider: DividerStyleOptions | undefined = undefined;
}


/**
 * 更多Action注册类
 */
export class CreationActionRegister extends MoreActionRegister {
  public constructor(registers: ActionRegister[]) {
    super(registers);
  }

  public getActions(): Action[] {
    return [CREATION];
  }

  public buildViewProp(action: Action, params: ParamsWrapper): CreationActionProp {
    return new CreationActionProp();
  }
}
