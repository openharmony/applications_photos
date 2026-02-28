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
// instrument ignore file
import { UiUtil } from '../../../../common/util/UiUtil';
import { TextAreaInfo } from '../model/TextAreaInfo';
import { Constants } from '../util/Const';

const TAG = 'TextEditMenu';

@Extend(Row)
function pressState() {
  .stateStyles({
    focused: {
      .backgroundColor($r('sys.color.ohos_id_color_focused_outline'))
    },
    pressed: {
      .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    },
    normal: {
      .backgroundColor('#FF202224')
    }
  })
}

@Extend(Text)
function boxText() {
  .fontColor(Color.White)
  .fontSize(`${vp2px(14)}px`) // 不跟随系统字体大小变化
  .height(16)
  .fontFamily(Constants.DEFAULT_TEXTAREA_FONT_FAMILY)
  .fontWeight(FontWeight.Medium)
  .height(Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT - 12)
  .borderRadius(45)
}

@Component
export struct TextEditMenu {
  @State private editHover: boolean = false;
  @State private styleHover: boolean = false;
  @State private deleteHover: boolean = false;
  @State private textEditMenuWidth: number = 0;
  @State private textCopyMenuWidth: number = 0;
  @State private textDeleteMenuWidth: number = 0;
  @Link menuWidth: number;
  @ObjectLink textArea: TextAreaInfo;

  editCallback: Function = () => {
  };
  modifyStyleCallback: Function = () => {
  };
  copyStyleCallback: Function = () => {
  };
  deleteCallback: Function = () => {
  };

  public onColorModeChange() {

  }

  build() {
    Row({ space: 0 }) {
      // 文本标注编辑
      Row() {
        Text($r('app.string.edit_imageEdit'))
          .boxText()
          .backgroundColor(this.editHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent)
      }
      .hitTestBehavior(HitTestMode.Block)
      .pressState()
      .padding({
        left: 18,
        top: 16,
        right: 12,
        bottom: 16,
      })
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { colorMode: ThemeColorMode.DARK })
      .accessibilityDescription(' ')
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString($r('app.string.edit_imageEdit')) +
      UiUtil.getResourceString($r('app.string.button_imageEdit')) +
      UiUtil.getResourceString($r('app.string.double_click_edit_imageEdit')))
      .onHover((isHover: boolean, event: HoverEvent): void => {
        // instrument ignore if
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.editHover = isHover;
      })
      .height(Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT)
      .borderRadius({
        topLeft: 45,
        bottomLeft: 45,
      })
      .id(`edit_image_edit`)
      .onClick((): void => {
        this.editCallback();
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.textEditMenuWidth = Number(newValue.width);
        this.textArea.textEditMenuWidth = this.textEditMenuWidth + this.textCopyMenuWidth + this.textDeleteMenuWidth;
        this.menuWidth = this.textArea.textEditMenuWidth;
      })

      // 文本标注复制
      Row() {
        Text($r('app.string.copy'))
          .boxText()
          .backgroundColor(this.styleHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent)
      }
      .hitTestBehavior(HitTestMode.Block)
      .pressState()
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { colorMode: ThemeColorMode.DARK })
      .padding({
        left: 12,
        top: 16,
        right: 12,
        bottom: 16,
      })
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString($r('app.string.copy')) +
      UiUtil.getResourceString($r('app.string.button_imageEdit')))
      .id(`edit_image_copy`)
      .onHover((isHover: boolean, event: HoverEvent): void => {
        // instrument ignore if
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.styleHover = isHover;
      })
      .height(Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT)
      .onClick((): void => {
        this.copyStyleCallback();
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.textCopyMenuWidth = Number(newValue.width);
        this.textArea.textEditMenuWidth = this.textEditMenuWidth + this.textCopyMenuWidth + this.textDeleteMenuWidth;
        this.menuWidth = this.textArea.textEditMenuWidth;
      })

      // 文本标注删除
      Row() {
        Text($r('app.string.delete_imageEdit'))
          .boxText()
          .backgroundColor(this.deleteHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent)
      }
      .hitTestBehavior(HitTestMode.Block)
      .pressState()
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { colorMode: ThemeColorMode.DARK })
      .padding({
        left: 12,
        top: 16,
        right: 18,
        bottom: 16,
      })
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString($r('app.string.delete_imageEdit')) +
      UiUtil.getResourceString($r('app.string.button_imageEdit')))
      .id(`edit_image_delete`)
      .onHover((isHover: boolean, event: HoverEvent): void => {
        // instrument ignore if
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.deleteHover = isHover;
      })
      .height(Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT)
      .borderRadius({
        topRight: 45,
        bottomRight: 45,
      })
      .onClick((): void => {
        this.deleteCallback();
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.textDeleteMenuWidth = Number(newValue.width);
        this.textArea.textEditMenuWidth = this.textEditMenuWidth + this.textCopyMenuWidth + this.textDeleteMenuWidth;
        this.menuWidth = this.textArea.textEditMenuWidth;
      })
    }
    .direction(Direction.Ltr)
    .height(Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT)
    .borderRadius(45)
    .backgroundColor('#FF202224')
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { colorMode: ThemeColorMode.DARK })
    .shadow(Constants.textShadow)
  }
}