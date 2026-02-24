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

/* instrument ignore file */

import { VIDEO_SPLICING,
  VIDEO_SPLICING_INVALID } from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarColorMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
/* instrument ignore file  */
/**
 * 工具栏元素通用按钮组件
 */
@Component
export struct ToolBarButton {
  @State res: Resource | undefined = undefined;
  public action: Action = Action.NONE;
  public isAutoTint: boolean = true;
  public colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      if (this.isAutoTint) {
        if (this.action?.actionID === VIDEO_SPLICING.actionID ||
          this.action?.actionID === VIDEO_SPLICING_INVALID.actionID) {
          // todo 临时解决上库，待资源上symbol后移除
          Image(this.res)
            .width($r('app.float.pc_actionbar_button_size'))
            .height($r('app.float.pc_actionbar_button_size'))
        } else {
        SymbolGlyph(this.res)
          .draggable(false)
          .commonButtonStyle()
          .fontColor([this.colorMode === ActionBarColorMode.TRANSPARENT
            ? Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor])
      }
      } else {
        if (this.action?.actionID === VIDEO_SPLICING.actionID ||
          this.action?.actionID === VIDEO_SPLICING_INVALID.actionID) {
          // todo 临时解决上库，待资源上symbol后移除
          Image(this.res)
            .width($r('app.float.pc_actionbar_button_size'))
            .height($r('app.float.pc_actionbar_button_size'))
        } else {
          SymbolGlyph(this.res)
            .draggable(false)
            .commonButtonStyle()
        }
      }
    }
    .height($r('app.float.icon_size'))
    .width($r('app.float.icon_size'))
  }
}

@Extend(SymbolGlyph)
function commonButtonStyle() {
  .fontSize($r('app.float.icon_size'))
}