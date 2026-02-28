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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarColorMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';

/**
 * 工具栏元素收藏按钮组件，满足收藏动效
 */
@Component
export struct ToolBarButtonFavor {
  public action: Action = Action.NONE;
  public isAutoTint: boolean = true;
  public colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  //值变更触发动效
  @Prop triggerValue: number;

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      SymbolGlyph(this.action.iconRes)
        .draggable(false)
        .commonButtonStyle()
        .fontColor([this.colorMode === ActionBarColorMode.TRANSPARENT
          ? Action.ICON_DEFAULT_COLOR_CONTRARY : (this.action.actionID ===
          Action.FAVORITE.actionID ? Action.FAVORITE.fillColor : Action.NOT_FAVORITE.fillColor)])
        .symbolEffect(new ReplaceSymbolEffect(EffectScope.LAYER), this.triggerValue)
    }
    .height($r('app.float.icon_size'))
    .width($r('app.float.icon_size'))
  }
}


@Extend(SymbolGlyph)
function commonButtonStyle() {
  .fontSize($r('app.float.icon_size'))
}