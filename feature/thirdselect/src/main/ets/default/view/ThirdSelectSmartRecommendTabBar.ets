/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
  BroadCast,
  BroadCastConstants,
} from '@ohos/common';
import deviceInfo from '@ohos.deviceInfo';
import SmartPickerConstants from '../common/SmartPickerConstants';
import SmartPickerRecommendTabInfo from '../common/SmartPickerRecommendTabInfo';

@Component
export struct ThirdSelectSmartRecommendTabBar {
  @Link currentTabIndex: number;
  @Link smartRecommendTabItems: Array<SmartPickerRecommendTabInfo>;
  @Consume broadCast: BroadCast;
  private staticTitleMap = new Map([
    [SmartPickerConstants.LABEL_ID_CARD, $r('app.string.photo_id_card')],
    [SmartPickerConstants.LABEL_QR_CODE, $r('app.string.photo_qr_code')],
    [SmartPickerConstants.LABEL_BAR_CODE, $r('app.string.photo_bar_code')],
    [SmartPickerConstants.LABEL_ALL_PHOTO, $r('app.string.photo_all')],
    [SmartPickerConstants.LABEL_AVATAR, $r('app.string.photo_profile_picture')],
  ]);

  build() {
    Row() {
      ForEach(this.smartRecommendTabItems, (item: SmartPickerRecommendTabInfo, index: number) => {
        Row() {
          Text(this.getTabTitle(item))
            .fontColor(this.currentTabIndex === index ? $r('sys.color.ohos_id_color_text_primary_dark') : $r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_button3'))
            .fontWeight(FontWeight.Regular)
            .draggable(false)
            .margin({ left: $r('app.float.picker_smart_recommend_tab_text_margin_left') })
            .lineHeight($r('app.float.picker_smart_recommend_tab_text_height'))
        }
        .backgroundColor(this.currentTabIndex === index ? $r('sys.color.ohos_id_color_secondary') : $r('sys.color.ohos_id_color_button_normal'))
        .height($r('app.float.picker_smart_recommend_tab_height'))
        .margin({ left: index === 0 ? 0 : $r('app.float.picker_smart_recommend_tab_margin_left') })
        .padding({ left: $r('app.float.picker_smart_recommend_tab_left_padding'), right: $r('app.float.picker_smart_recommend_tab_right_padding') })
        .borderRadius(SmartPickerConstants.RECOMMEND_TAB_BORDER_RADIUS)
        .key('pickerRecommendTab_' + index)
        .onClick((event: ClickEvent) => {
          this.changeTab(index);
        })
      })
    }
    .alignSelf(ItemAlign.Start)
    .margin({ bottom: $r('app.float.picker_smart_recommend_tab_bar_margin_bottom') })
    .padding({ top: $r('app.float.picker_smart_recommend_tab_bar_padding_top'), bottom: $r('app.float.picker_smart_recommend_tab_bar_padding_bottom') })
  }

  private changeTab(index: number): void {
    if (this.currentTabIndex === index) {
      return;
    }
    this.currentTabIndex = index;
    this.broadCast.emit(BroadCastConstants.THIRD_PICKER_SWITCH_SMART_RECOMMEND_TAB, [this.currentTabIndex]);
  }

  private getTabTitle(item: SmartPickerRecommendTabInfo): Resource {
    let titleRes: Resource = $r('app.string.photo_all');
    if (this.staticTitleMap.has(item.getLabelId())) {
      titleRes = this.staticTitleMap.get(item.getLabelId()) as Resource;
    }
    return titleRes;
  }
}