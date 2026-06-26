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
  CropAttr,
  CropScaleClass,
  HiLog,
  MediaType,
  BaseEditor,
  ScreenManager
} from '@oh-image-editor/editor-common';
import display from '@ohos.display';
import { RatioSelection } from './RatioSelection';

@Extend(SymbolGlyph)
function spinnerImg(isClosed: boolean) {
  .fontSize('24vp')
  .rotate({ angle: isClosed ? '90deg' : '0deg' })
  .fontColor([$r('sys.color.ohos_id_color_text_tertiary_dark')])
  .margin({ left: 16, right: 16 })
}

@Extend(SymbolGlyph)
function iconSym() {
  .fontSize('24vp')
  .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
  .margin({ right: 8 })
}

@Extend(Text)
function rotateText() {
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.Body_L'))
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary_dark'))
  .maxFontScale(1.45)
}

@Extend(Row)
function rotateTitle(isHover: boolean) {
  .width('100%')
  .height(40)
  .alignItems(VerticalAlign.Center)
  .backgroundColor(isHover ? 'rgba(255,255,255,0.05)' : Color.Transparent)
  .borderRadius(8)
}

const TAG = 'ScaleItem';

@Component
export struct ScaleItem {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State scaleList: CropScaleClass[] = this.cropsAttr.scaleDataList;
  @State hoverKey: string = '';
  @State isOnHover: boolean = false;

  aboutToAppear() {
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_right')).spinnerImg(this.cropsAttr.enableRatio)

        SymbolGlyph($r('sys.symbol.aspect_ratio')).iconSym()

        Text($r('app.string.crop_ratio_imageEdit')).rotateText()

        Blank()
      }
      .rotateTitle(this.isOnHover)
      .id('petalClip_ScaleItem_ratioButton')
      .onClick((): void => {
        this.cropsAttr.enableRatio = !this.cropsAttr.enableRatio;
      })
      .onHover((isHover: boolean | undefined) => {
        if (isHover == undefined) {
          return;
        }
        this.isOnHover = isHover;
      })
      .stateStyles({
        focused: {
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor($r('sys.color.ohos_id_color_activated'))
          .borderRadius(8)
        },
        normal: {
          .borderWidth(0)
        },
      })

      Column() {
        ForEach(this.scaleList, (item: CropScaleClass) => {
          RatioSelection({
            item: item,
            selectedRatio: this.cropsAttr.scale,
            onActive: (value: number, ratio: string, index: number, key: string) => {
              this.cropsAttr.scale = value;
              if (this.editor.interrupt) {
                this.editor.setCropReactInterrupt();
              }
              HiLog.i('VideoCropTool cropRatio value:', 'value = ' + value)
              HiLog.i('VideoCropTool cropRatio ratio:', 'ratio = ' + ratio)
              HiLog.i('VideoCropTool cropRatio value:', 'index = ' + index)

              value = value === -2 ? this.getPaveRatio() : value;
              this.cropsAttr.ratio = ratio;

              // 首次切换到自由比例不需要调用SDK setCropRect接口，防止打断动画
              if (value == 0) {
                App.getInstance()
                  .myEditor()
                  .asset
                  .crops()
                  .clipRatio = 0;
                return;
              }
              App.getInstance().myEditor().asset.calcOptimalRectUnderRatio(value, 300);
              if (this.editor.isEdit) {
                this.editor.isShowRevert = !this.editor.isEdited();
              }
            }
          })
            .visibility(this.cropsAttr.enableRatio ? Visibility.Visible : Visibility.None)
        })

        Row().width('100%').height(70)
          .visibility(this.cropsAttr.enableRatio ? Visibility.Visible : Visibility.None)
      }.id('petalClip_ScaleItem_ratioSelection')
      .margin({ top: 8, bottom: 8 })
    }.width('100%')
  }

  getPaveRatio(): number {
    let paveRatio = 1;
    try {
      let displayClass = display.getDefaultDisplaySync();
      paveRatio = displayClass.width / displayClass.height;
    } catch (err) {
      HiLog.e(TAG, `get screen info failed, err: ${err}, code: ${err?.code}`);
    }
    return paveRatio;
  }
}