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

import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

/**
 * 加载进度条组件
 */
@Component
export struct LoadingPanel {
  /* instrument ignore file */
  build() {
    Column() {
      LoadingProgress()
        .width($r('app.float.loading_panel_icon_w'))
        .height($r('app.float.loading_panel_icon_w'))
        .color($r('sys.color.icon_on_primary'))
        .margin({ bottom: $r('app.float.loading_panel_icon_margin') })
        .key('ProgressOfLoadingPanel')
      Text($r('app.string.image_loading'))
        .draggable(false)
        .fontSize($r('sys.float.Body_M'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.icon_on_primary'))
        .key('TextOfLoadingPanel')
    }
    .width('100%')
    .height('100%')
    .padding({ top: $r('app.float.loading_panel_item_gap') })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear(): void {
    // 大图加载超时(如转圈)
    ReportToBigDataUtil.errEventReport(BigDataConstants.BROWER_IMAGE_LOAD_TIME_OVER);
  }
}