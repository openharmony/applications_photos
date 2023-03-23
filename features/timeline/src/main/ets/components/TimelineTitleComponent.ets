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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { TimelineDataItem } from '../data/TimelineDataItem';
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { LazyItem} from '@ohos/base/src/main/ets/vm/ItemDataSource';

const TAG = "TimelineTitleComponent"
// Group Title
@Component
export struct TimelineTitleComponent {
    @Consume broadCast: Broadcast;
    @Consume isSelectedMode: boolean;
    lazyItem: LazyItem<TimelineDataItem>
    timelineDataItem: TimelineDataItem;
    addresses = '';

    aboutToAppear(): void {
        Log.info(TAG, `${this.timelineDataItem.dateAdded}`);
    }

    private selectStateChange() {
        Log.info(TAG, `change selected ${this.isSelectedMode}`);
        if (this.isSelectedMode) {
            let isSelect = !this.timelineDataItem.isSelect()
            this.timelineDataItem.setSelect(isSelect)
            if (this.lazyItem) {
                this.lazyItem.update(this.timelineDataItem)
            }
            this.broadCast.emit(BroadcastConstants.GROUP_SELECT, []);
        }
    }

    build() {
        Row() {
            Column() {
                Text(DateUtil.getGroupDataLocalizedDate(this.timelineDataItem.dateAdded))
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                    .fontFamily($r('app.string.id_text_font_family_medium'))
                    .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
            }
            .height('100%')
            .justifyContent(FlexAlign.End)
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            if (this.isSelectedMode) {
                Column() {
                    Image(this.timelineDataItem.isSelect() ? $r('app.media.ic_gallery_public_checkbox_filled') : $r('app.media.ic_checkbox_off'))
                        .height($r('app.float.icon_size'))
                        .width($r('app.float.icon_size'))
                }
                .height($r('app.float.icon_title_size_hot'))
                .width($r('app.float.icon_title_size_hot'))
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .padding({
                    left: $r('app.float.group_title_padding_bottom'),
                })
                .onClick(() => {
                    this.selectStateChange()
                })
            }
        }
        .alignItems(VerticalAlign.Bottom)
        .margin({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_end'),
            bottom: $r('app.float.group_title_padding_bottom')
        })
        .height($r('app.float.group_title_height'));
    }
}