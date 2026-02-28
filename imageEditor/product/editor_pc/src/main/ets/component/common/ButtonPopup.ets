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
@Component
export struct ButtonPopup {
  @Prop popupText: Resource | undefined = undefined;
  @State textWidth: number = 0;
  @State textHeight: number = 0;
  private LEFT_RIGHT_PADDING: number = 32;
  private TOP_BOTTOM_PADDING: number = 24;

  build() {
    Row() {
      Text(this.popupText)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Regular)
        .fontColor('rgba(255,255,255,0.9)')
        .onAreaChange((_: Area, newValue: Area) => {
          this.textWidth = newValue.width as number;
          this.textHeight = newValue.height as number;
        })
    }
    .justifyContent(FlexAlign.Center)
    .width(this.textWidth + this.LEFT_RIGHT_PADDING)
    .height(this.textHeight + this.TOP_BOTTOM_PADDING)
    .backgroundColor('#4D4D4D')
    .borderRadius(8)
    .border({ width: 1, color: 'rgba(255,255,255,0.2)' })
    .outline({ width: 1, color: 'rgba(0,0,0,0.4)' })
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
  }
}