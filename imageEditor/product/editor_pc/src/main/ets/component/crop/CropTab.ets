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
import {
  App,
  ButtonBubble,
  CropAttr,
  BaseEditor,
  ScreenManager,
  FIRST_FRAME_STATUS
} from '@oh-image-editor/editor-common'
import { ButtonPopup } from '../common/ButtonPopup'
import { RulerItem } from './component/RulerItem'
import { ScaleItem } from './component/ScaleItem'
import { CropIndex } from '@oh-image-editor/editor-common/src/main/ets/common/const'

@Extend(SymbolGlyph)
function iconSym() {
  .fontSize(24)
  .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
}

@Extend(Column)
function menuStyle(isFirstFrameStatue: boolean) {
  .backgroundColor('#252525')
  .justifyContent(FlexAlign.Start)
  .height('100%')
  .width($r('app.float.right_bar_width'))
  .enabled(isFirstFrameStatue)
  .opacity(isFirstFrameStatue ? 1 : 0.4)
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.Body_L'))
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
  .margin({ top: 19 })
}

@Extend(Button)
function mirrorBtn(isHover: boolean, isPress: boolean) {
  .align(Alignment.Center)
  .width(48)
  .height(48)
  .borderRadius($r('sys.float.corner_radius_level4'))
  .backgroundColor(isHover ? (isPress ? '#525252' : '#484848') : 'rgba(0,0,0,0)')
}

@Component
export struct CropTab {
  @State editor: BaseEditor = App.getInstance().myEditor();
  private scroller: Scroller = new Scroller();
  private timer: number = -1;
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State popupText: Resource | undefined = undefined;
  @State mirrorPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_mirror'), false, false, false);
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();

  aboutToAppear() {
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Flex({ direction: FlexDirection.Column }) {
          this.rotateCrop();

          ScaleItem()

          Blank()
        }
        .padding({
          left: 16,
          right: 16,
        })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .id('petalclip_CropTool_CropTool')
    .menuStyle(this.isFirstFrameStatue)
  }

  @Builder
  popupBuilder() {
    ButtonPopup({
      popupText: this.popupText,
    })
  }

  @Builder
  rotateCrop() {
    Column() {
      RulerItem({
        item: this.cropsAttr.cropTabs[CropIndex.ROTATE],
      }).margin({ bottom: 2 })
      RulerItem({
        item: this.cropsAttr.cropTabs[CropIndex.HORIZONTAL],
      }).margin({ bottom: 2 })
      RulerItem({
        item: this.cropsAttr.cropTabs[CropIndex.VERTICAL],
      }).margin({ bottom: 2 })
    }
  }
}