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
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';
import { TimelineDataItem } from '../data/TimelineDataItem';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { TimelineItemDataSource } from '../vm/TimelineItemDataSource';

const TAG = "TimelineScrollBar"

@Component
export struct TimelineScrollBar {
    scroller: Scroller;
    dataSource: TimelineItemDataSource;
    @Link isHideScrollBar: boolean;
    @State isClickScrollBar: boolean = false;
    @Consume dateText: string;
    @Consume broadCast: Broadcast;
    private startY: number = 0;

    aboutToAppear(): void {
    }

    nodeGap(count: number): number {
        let windowHeight: number = screenManager.getWinHeight() - WindowConstants.TOOL_BAR_SIZE;
        let gridHeight: number = windowHeight - WindowConstants.SCROLL_MARGIN * 2;
        let gapS = Math.ceil(gridHeight * count / this.dataSource.childCount() - WindowConstants.SCROLL_MARGIN * 2);
        if (gapS >= WindowConstants.SCROLL_BAR_SIDE_MIN_GAP) {
            return gapS;
        }
        return -1;
    }

    private isFirst(item: TimelineDataItem): boolean {
        return this.dataSource.groupItem.indexOf(item) == 0;
    }

    private isLast(item: TimelineDataItem): boolean {
        return this.dataSource.groupItem.indexOf(item) == this.dataSource.groupItem.length - 1;
    }

    private isShowLocalizedYear(item: TimelineDataItem): boolean {
        if (this.dataSource.groupItem.indexOf(item) > 0) {
            return DateUtil.getLocalizedYearString(item.dateAdded) != DateUtil.getLocalizedYearString(this.dataSource.getDataByIndex(this.dataSource.groupItem.indexOf(item) - 1).dateAdded);
        }
        return true;
    }

    build() {
        Stack({ alignContent: Alignment.End }) {
            if (this.isClickScrollBar && !this.isHideScrollBar) {
                Column() {
                    ForEach(this.dataSource.groupItem, (year: TimelineDataItem) => {
                        if (this.nodeGap(year.groupChild.length) > 0 || this.isFirst(year) || this.isLast(year)) {
                            Row() {
                                Text(DateUtil.getLocalizedYear(year.dateAdded))
                                    .fontSize($r('sys.float.ohos_id_text_size_body3'))
                                    .fontFamily($r('app.string.id_text_font_family_regular'))
                                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
                            }
                            .height($r('app.float.scroll_bar_side_text_height_small'))
                            .backgroundColor($r('app.color.scroll_bar_side_text_small_color'))
                            .borderRadius($r('app.float.scroll_bar_side_text_radio'))
                            .padding({
                                left: $r('app.float.scroll_bar_side_text_padding_horizontal_small'),
                                right: $r('app.float.scroll_bar_side_text_padding_horizontal_small'),
                                top: $r('app.float.scroll_bar_side_text_padding_vertical_small'),
                                bottom: $r('app.float.scroll_bar_side_text_padding_vertical_small')
                            })
                            .shadow({
                                radius: $r('app.float.scroll_bar_side_text_shadow_radio'),
                                color: $r('app.color.scroll_bar_side_text_shadow_color'),
                                offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
                                offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
                            })
                            .margin({
                                bottom: this.nodeGap(year.groupChild.length)
                            })
                            .visibility(this.isShowLocalizedYear(year) ? Visibility.Visible : Visibility.Hidden)
                        }
                    }, year => JSON.stringify(year))
                }
                .height('100%')
                .margin({
                    right: $r('app.float.scroll_bar_margin_small'),
                    top: $r('app.float.max_padding_start'),
                    bottom: $r('app.float.max_padding_end')
                })
            }

            ScrollBar({
                scroller: this.scroller,
                direction: ScrollBarDirection.Vertical,
                state: this.isHideScrollBar ? BarState.Off : BarState.Auto
            }) {
                Row() {
                    if (this.isClickScrollBar) {
                        Row() {
                            Row() {
                                Text(this.dateText)
                                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                                    .fontFamily($r('app.string.id_text_font_family_medium'))
                                    .fontColor($r('app.color.title_text_color'))
                            }
                            .height($r('app.float.scroll_bar_side_text_height'))
                            .backgroundColor($r('app.color.scroll_bar_side_text_color'))
                            .borderRadius($r('app.float.scroll_bar_side_text_radio'))
                            .padding({
                                left: $r('app.float.scroll_bar_side_text_padding_horizontal'),
                                right: $r('app.float.scroll_bar_side_text_padding_horizontal'),
                                top: $r('app.float.scroll_bar_side_text_padding_vertical'),
                                bottom: $r('app.float.scroll_bar_side_text_padding_vertical')
                            })
                            .shadow({
                                radius: $r('app.float.scroll_bar_side_text_shadow_radio'),
                                color: $r('app.color.scroll_bar_side_text_shadow_color'),
                                offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
                                offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
                            })

                            Row() {
                                Image($r("app.media.scroll_press_light"))
                            }
                            .width($r('app.float.scroll_bar_big_width'))
                            .height($r('app.float.scroll_bar_big_height'))
                            .margin({ left: $r('app.float.scroll_bar_side_gap') })
                        }
                        .width($r('app.float.scroll_press_all_width'))
                        .justifyContent(FlexAlign.End)
                    } else {
                        Row() {
                            Image($r("app.media.scroll_light"))
                                .width($r('app.float.scroll_bar_small_width'))
                                .height($r('app.float.scroll_bar_small_height'))
                        }
                    }
                }
            }
            .height('100%')
            .width(this.isClickScrollBar
                ? $r('app.float.scroll_press_all_width') : $r('app.float.scroll_bar_small_width'),)
        }
        .onTouch((event: TouchEvent) => {
            if (this.dateText == '') {
                Log.warn(TAG, `dateText is null`)
                this.broadCast.emit(BroadcastConstants.INIT_DATE_TEXT, [])
            }
            if (event.type == TouchType.Down) {
                this.isClickScrollBar = false;
                this.startY = event.touches[0].y
            } else if (event.type == TouchType.Up) {
                this.isClickScrollBar = false;
            } else if (event.type == TouchType.Move) {
                if (Math.abs(event.touches[0].y - this.startY) > 50){
                    this.isClickScrollBar = true;
                }
            }
        })
    }
}