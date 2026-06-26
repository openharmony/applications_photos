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
import lazy { Constants } from '../model/common/Constants';

/* instrument ignore file */
const TAG: string = 'MapAuthorizationMatte';

@Component
export struct MapAuthorizationMatte {
  resetMapProtocolFun: Function = (): void => {
  };

  build() {
    Column() {
      Text($r('app.string.displayed_agreeing_map'))
        .accessibilityLevel('yes')
        .fontSize($r('app.float.map_protocol_text_size'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
      Text($r('app.string.click_view_protocol'))
        .accessibilityLevel('yes')
        .key('protocolView')
        .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
        .fontSize($r('app.float.map_protocol_text_size'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: $r('app.float.map_click_view_margin_top') })
        .onClick((): void => {
          this.resetMapProtocolFun();
        })
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundBlurStyle(BlurStyle.Thin)
  }
}