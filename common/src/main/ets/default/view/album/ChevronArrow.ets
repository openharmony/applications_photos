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
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy curves from '@ohos.curves';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { AccessibilityUtil } from '../../../default/utils/AccessibilityUtil';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { BroadCast } from '../../utils/BroadCast'

/* instrument ignore file */
const expandAngle: number = 0;

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Component
export struct ChevronArrow {
  private onClickFunc: Function = (): void => {
  };
  @State isHover: boolean = false;
  @State isPressed: boolean = false;
  @Prop isExpand: boolean = false;

  private getBackgroundColor(isPressed: boolean, isHover: boolean): ResourceColor {
    if (isPressed) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_up'))
        .draggable(false)
        .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_arrow_icon_size') : $r('app.float.icon_size'))
        .fontColor([$r('sys.color.icon_tertiary')])
        .focusable(true)
    }
    .justifyContent(FlexAlign.Center)
    .height(DeviceInfo.isTv() ? 42 : $r('app.float.icon_size_hot'))
    .width(DeviceInfo.isTv() ? 42 : $r('app.float.icon_size_hot'))
    .backgroundColor(this.getBackgroundColor(this.isPressed, this.isHover))
    .rotate({
      angle: this.isExpand ? expandAngle : (180 - expandAngle),
    })
    .key(Constants.COMPONENT_KEY_CHEVRON_ARROW)
    // 响应rotate动画
    .animation({ curve: curves.springCurve(0, 1, 228, 30) })
    .offset({ x: 4 })
    .borderRadius($r('sys.float.corner_radius_level4'))
    .accessibilityText(this.isExpand ? $r('app.string.show_less') : $r('app.string.expand'))
    .onClick((event: ClickEvent): void => {
      this.onClickFunc();
      appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
      if (AccessibilityUtil.isOpenTouchGuideSync()) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_CHEVRON_ARROW);
      }
    })
    .onKeyEvent((event: KeyEvent): void => {
      FocusCtrlManager.handleSideBarKeyEvent(event);
    })
    .onHover((isHover: boolean, event: HoverEvent) => {
      this.isHover = isHover;
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === 0) {
        this.isPressed = true;
      } else if (event.type === 1) {
        this.isPressed = false;
      }
    })
  }
}
