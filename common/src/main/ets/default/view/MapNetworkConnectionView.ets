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
const TAG: string = 'MapNetworkConnectionView';

@Component
export struct MapNetworkConnectionView {
  settingUpTheNetworkFun: Function = (): void => {
  };

  build() {
    Column() {
      Text($r('app.string.gallery_network_disabled_please_enable_it'))
        .fontSize($r('app.float.map_protocol_text_size'))
        .fontColor('#000000')
      Text($r('app.string.setting_up_the_network'))
        .key('protocolView')
        .fontColor($r('app.color.color_control_highlight'))
        .fontSize($r('app.float.map_protocol_text_size'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: $r('app.float.map_click_view_margin_top') })
        .onClick((): void => {
          this.settingUpTheNetworkFun();
        })
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundBlurStyle(BlurStyle.Thin)
  }
}