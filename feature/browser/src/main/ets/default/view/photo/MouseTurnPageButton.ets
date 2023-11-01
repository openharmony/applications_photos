/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
export struct MouseTurnPageButton {
  @State iconColor: Resource = $r('app.color.ohos_id_color_white_icon')
  @State buttonBackgroundColor: Resource = $r('app.color.ohos_id_color_whiteIcon_blackPlane')
  @State isButtonHover: boolean = false
  @Consume @Watch('handleIconColor') isDefaultBackgroundColor: boolean
  private isStart: boolean = false;
  private imageResource: Resource | null = null;

  aboutToAppear() {
    this.imageResource = this.isStart ? $r('app.media.ic_public_arrow_left_swiper')
                                      : $r('app.media.ic_public_arrow_right_swiper')
    this.handleIconColor()
  }

  public handleIconColor(): void {
    if (this.isDefaultBackgroundColor) {
      this.iconColor = $r('app.color.ohos_id_color_white_icon')
      this.buttonBackgroundColor = this.isButtonHover ? $r('app.color.ohos_id_color_whiteIcon_blackPlane_hover')
                                                      : $r('app.color.ohos_id_color_whiteIcon_blackPlane')
    } else {
      this.iconColor = $r('app.color.ohos_id_color_black_icon')
      this.buttonBackgroundColor = this.isButtonHover ? $r('app.color.ohos_id_color_blackIcon_whitePlane_hover')
                                                      : $r('app.color.ohos_id_color_blackIcon_whitePlane')
    }
  }

  build() {
    Button({ type: ButtonType.Capsule }) {
      Image(this.imageResource)
        .fillColor(this.iconColor)
        .width($r('app.float.mouse_turn_page_button_image_width'))
        .height($r('app.float.mouse_turn_page_button_image_height'))
        .focusable(true)
    }
    .backgroundColor(this.buttonBackgroundColor)
    .width($r('app.float.mouse_turn_page_button_size'))
    .height($r('app.float.mouse_turn_page_button_size'))
    .focusable(true)
    .responseRegion({
      x: $r('app.float.mouse_turn_page_button_response_offset'),
      y: $r('app.float.mouse_turn_page_button_response_offset'),
      width: $r('app.float.mouse_turn_page_button_response_size'),
      height: $r('app.float.mouse_turn_page_button_response_size')
    })
    .onHover((isHover?: boolean) => {
      if (isHover != null) {
        this.isButtonHover = isHover
      }
      this.handleIconColor()
    })
  }
}