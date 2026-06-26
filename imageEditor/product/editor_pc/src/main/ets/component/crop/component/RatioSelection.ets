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
import { CropScaleClass, Event } from '@oh-image-editor/editor-common';

@Extend(Text)
function ratioText() {
  .padding({ left: 44 })
  .width('100%')
  .fontWeight(FontWeight.Regular)
  .fontSize(14)
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
  .maxFontScale(1.15)
}

@Extend(Row)
function ratioItem(isSelected: boolean) {
  .height(40)
  .width('100%')
  .borderRadius($r('sys.float.corner_radius_level4'))
  .margin({ top: 2, bottom: 2 })
  .backgroundColor(isSelected ? '#19FFFFFF' : '')
  .alignItems(VerticalAlign.Center)

}

@Component
export struct RatioSelection {
  @State isHover: boolean = false;
  @Prop selectedRatio: number = -1;
  @State item: CropScaleClass = new CropScaleClass(-1, '-1', 0, $r('app.string.crop_original_imageEdit'));
  public onActive: (value: number, ratio: string, index: number, key: string) => void = Event;

  build() {
    Row() {
      Text(this.item.text).ratioText()
    }.id(`petalClip_ScaleItem_ratio${this.item.ratio}`)
    .ratioItem(this.isHover || this.selectedRatio == this.item.value)
    .onHover((isHover?: boolean) => {
      if (isHover == null) {
        return;
      }
      this.isHover = isHover;
    })
    .onClick((): void => {
      if (this.selectedRatio == this.item.value) {
        return;
      }
      this.onActive(this.item.value, this.item.ratio, this.item.cropIndex, this.item.key);
    })
  }
}