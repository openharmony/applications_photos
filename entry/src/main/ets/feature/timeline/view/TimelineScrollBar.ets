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
import {Constants} from '../../../common/model/common/Constants.ets'
import {ScreenManager} from '../../../common/model/common/ScreenManager.ets';
import {DateUtil} from '../../../common/utils/DateUtil.ets';
import {TimelineData} from '../../../common/model/browser/photo/TimelineData.ets';
import {Logger} from '../utils/Logger'
import {BroadCast} from '../../../common/utils/BroadCast.ets';
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants.ets';

@Component
export struct TimelineScrollBar {
    scroller: Scroller;

    @Consume @Watch('updateTotalNum') yearData: TimelineData[];
    @State isClickScrollBar: boolean = false;
    @Consume isHideScrollBar: boolean;
    @Consume dateText: string;
    @Consume broadCast: BroadCast;

    @State totalNum: number = 0;
    gridHeight: number = ScreenManager.getInstance().getWinHeight() - Constants.ActionBarHeight;
    logger: Logger = new Logger('TimelineScrollBar');

    private aboutToAppear(): void {
        this.updateTotalNum();
    }

    nodeGap(count: number): number {
        this.logger.debug(`nodeGap start ${count} --- ${this.gridHeight} ---- ${this.totalNum}`)
        let gapS = Math.ceil(this.gridHeight * count / this.totalNum - 24);
        if (gapS >= Constants.SCROLL_BAR_SIDE_MIN_GAP) {
            return gapS;
        }

        return -1;
    }

    updateTotalNum() {
        let totalCount = 0;
        for(let year of this.yearData) {
            totalCount = totalCount + year.count;
        }
        this.totalNum = totalCount;
    }

    build() {
        Stack({alignContent: Alignment.End}) {
            if (this.isClickScrollBar) {
                Column() {
                    ForEach(this.yearData, (year: TimelineData) => {
                        if (this.nodeGap(year.count) > 0 || this.yearData.indexOf(year) == 0
                        || this.yearData.indexOf(year) == this.yearData.length - 1) {
                            Row() {
                                Text(DateUtil.getLocalizedYear(year.startDate))
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
                                offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
                                offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
                            })
                            .border({
                                width: $r('app.float.scroll_bar_side_text_border_width')
                            })
                            .margin({
                                bottom: this.nodeGap(year.count)
                            })
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

            ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical,
                state: this.isHideScrollBar? BarState.Off: BarState.Auto }) {
                Row() {
                    if (this.isClickScrollBar) {
                        Flex({
                            direction: FlexDirection.RowReverse,
                            alignItems: ItemAlign.Center,
                            justifyContent: FlexAlign.Start
                        }) {
                            Row() {
                                Image($r('app.media.scroll_press_light_hdpi'))
                            }
                            .width($r('app.float.scroll_bar_big_width'))
                            .height($r('app.float.scroll_bar_big_height'))
                            .margin({left: $r('app.float.scroll_bar_side_gap')})

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
                                offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
                                offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
                            })
                            .border({
                                width: $r('app.float.scroll_bar_side_text_border_width')
                            })
                        }
                        .width($r('app.float.scroll_press_all_width'))
                    } else {
                        Image($r('app.media.scroll_light_hdpi'))
                            .width($r('app.float.scroll_bar_small_width'))
                            .height($r('app.float.scroll_bar_small_height'))
                            .borderRadius(25)
                    }
                }
            }
            .height('100%')
            .position({x:'100%', y:0})
            .markAnchor({
                x: this.isClickScrollBar
                    ? $r('app.float.scroll_press_all_width') : $r('app.float.scroll_bar_small_width'),
                y: 0
            })
            .onTouch((event: TouchEvent) => {
                if (this.dateText == '') {
                    this.logger.debug(`dateText is null`)
                    this.broadCast.emit(BroadCastConstants.INIT_DATE_TEXT, [])
                }
                if (event.type == TouchType.Down) {
                    this.isClickScrollBar = true;
                } else if (event.type == TouchType.Up) {
                    this.isClickScrollBar = false;
                }
            })
        }
    }
}