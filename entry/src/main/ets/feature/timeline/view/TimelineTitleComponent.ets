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

import { TimelineData } from '../../../common/model/browser/photo/TimelineData'
import { Logger } from '../../../common/utils/Logger'
import { DateUtil } from '../../../common/utils/DateUtil'
import { BroadCast } from '../../../common/utils/BroadCast'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'

// Group Title
@Component
export struct TimelineTitleComponent {
    logger: Logger = new Logger('TimelineTitleComponent');
    @State groupData: TimelineData = new TimelineData(null, null, null);
    @Consume isSelectedMode: boolean;
    @State isSelected: boolean = false;
    @Consume broadCast: BroadCast;
    position = 0;
    addresses = '';

    aboutToAppear(): void {
        this.logger.info(`${this.groupData.startDate} position ${this.position}`);
    }

    selectStateChange() {
        this.logger.info('change selected.');
        this.broadCast.emit(BroadCastConstants.GROUP_SELECT, [this.position]);
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
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                    .fontFamily($r('app.string.id_text_font_family_medium'))
                    .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
            }
            .height('100%')
            .layoutWeight(1)

            if (this.isSelectedMode) {
                Flex({
                    direction: FlexDirection.Column,
                    justifyContent: FlexAlign.Center,
                    alignItems: ItemAlign.Center
                }) {
                    Image(this.isSelected ? $r('app.media.ic_gallery_public_checkbox_filled') : $r('app.media.ic_checkbox_off'))
                        .height($r('app.float.icon_size'))
                        .width($r('app.float.icon_size'))

                }
                .height($r('app.float.icon_title_size_hot'))
                .width($r('app.float.icon_title_size_hot'))
                .padding({
                    left: $r('app.float.group_title_padding_bottom'),
                })
                .onClick(() => {
                    this.selectStateChange()
                })
            }
        }
        .margin({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_end'),
            bottom: $r('app.float.group_title_padding_bottom')
        })
        .height($r('app.float.group_title_height'));
    }
}