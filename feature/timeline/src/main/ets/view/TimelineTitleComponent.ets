/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { BroadCast, BroadCastConstants, DateUtil, Log, TimelineData } from '@ohos/common';

const TAG: string = 'timeline_TimelineTitleComponent';

// Group Title
@Component
export struct TimelineTitleComponent {
  @State groupData: TimelineData = new TimelineData();
  @Consume isSelectedMode: boolean;
  @State isSelected: boolean = false;
  @Consume broadCast: BroadCast;
  mPosition = 0;
  addresses = '';

  aboutToAppear(): void {
    Log.info(TAG, `${this.groupData.startDate} position ${this.position}`);
  }

  selectStateChange() {
    AppStorage.setOrCreate('focusUpdate', true);
    Log.info(TAG, 'change selected.');
    this.broadCast.emit(BroadCastConstants.GROUP_SELECT, [this.mPosition]);
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.End
    }) {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Start,
        justifyContent: FlexAlign.End
      }) {
        Text(DateUtil.getGroupDataLocalizedDate(this.groupData.startDate))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontFamily($r('app.string.id_text_font_family_medium'))
          .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
          .fontWeight(500)
          .key('TimeLineTitleOfGroup' + this.mPosition)
      }
      .height('100%')
      .layoutWeight(1)

      if (this.isSelectedMode) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          Checkbox()
            .select(this.isSelected)
            .selectedColor($r('sys.color.ohos_id_color_activated_end'))
            .key('SelectAllOfGroup' + this.mPosition)
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .focusable(false)
            .onChange(() => {
              this.selectStateChange()
            })
        }
        .height($r('app.float.icon_title_size_hot'))
        .width($r('app.float.icon_title_size_hot'))
        .padding({
          left: $r('app.float.group_title_padding_bottom'),
        })
      }
    }
    .margin({
      left: $r('app.float.max_padding_start'),
      right: $r('app.float.max_padding_end')
    })
    .padding({ bottom: $r('app.float.group_title_padding_bottom') })
    .height($r('app.float.group_title_height'));
  }
}