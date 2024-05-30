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
import { BroadCast, BroadCastConstants, Constants, DateUtil, Log, ScreenManager, TimelineData } from '@ohos/common';

const TAG: string = 'timeline_TimelineScrollBar';

@Component
export struct TimelineScrollBar {
  scroller: Scroller | null = null;
  @Consume @Watch('updateTotalNum') yearData: TimelineData[];
  @State isClickScrollBar: boolean = false;
  @Consume dateText: string;
  @Consume broadCast: BroadCast;
  @State totalNum: number = 0;
  gridHeight: number = ScreenManager.getInstance()
    .getWinHeight() - Constants.ActionBarHeight - Constants.TOOL_BAR_SIZE - Constants.SCROLL_MARGIN * 2;

  aboutToAppear(): void {
    this.updateTotalNum();
  }

  nodeGap(count: number): number {
    Log.debug(TAG, `nodeGap start ${count} --- ${this.gridHeight} ---- ${this.totalNum}`)
    let gapS = Math.ceil(this.gridHeight * count / this.totalNum - 48);
    if (gapS >= Constants.SCROLL_BAR_SIDE_MIN_GAP) {
      return gapS;
    }

    return -1;
  }

  updateTotalNum() {
    let totalCount = 0;
    for (let year of this.yearData) {
      totalCount = totalCount + year.count;
    }
    this.totalNum = totalCount;
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      if (this.isClickScrollBar) {
        Column() {
          ForEach(this.yearData, (year: TimelineData, index?: number) => {
            if (this.nodeGap(year.count) > 0 || this.yearData.indexOf(year) == 0 ||
              this.yearData.indexOf(year) == this.yearData.length - 1) {
              Row() {
                Text(DateUtil.getLocalizedYear(year.startDate))
                  .fontSize($r('sys.float.ohos_id_text_size_body3'))
                  .fontFamily($r('app.string.id_text_font_family_medium'))
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
                  .key('TimelineScrollBar_Text_' + index)
              }
              .key('TimelineScrollBar_Row_' + index)
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
                bottom: this.nodeGap(year.count)
              })
            }
          }, (year: TimelineData) => JSON.stringify(year))
        }
        .height('100%')
        .margin({
          right: $r('app.float.scroll_bar_margin_small'),
          top: $r('sys.float.ohos_id_max_padding_start'),
          bottom: $r('sys.float.ohos_id_max_padding_end')
        })
      }

      ScrollBar({ scroller: this.scroller as Scroller, direction: ScrollBarDirection.Vertical,
        state: BarState.Auto }) {
        Row() {
          if (this.isClickScrollBar) {
            Row() {
              Row() {
                Text(this.dateText)
                  .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                  .fontFamily($r('app.string.id_text_font_family_medium'))
                  .fontColor($r('app.color.title_text_color'))
                  .fontWeight(FontWeight.Medium)
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
                Image($r('app.media.scroll_press_light'))
              }
              .width($r('app.float.scroll_bar_big_width'))
              .height($r('app.float.scroll_bar_big_height'))
              .margin({ left: $r('app.float.scroll_bar_side_gap') })
            }
            .width($r('app.float.scroll_press_all_width'))
            .justifyContent(FlexAlign.End)
          } else {
            Row() {
              Image($r('app.media.scroll_light'))
                .width($r('app.float.scroll_bar_small_width'))
                .height($r('app.float.scroll_bar_small_height'))
                .borderRadius(25)
            }
          }
        }
      }
      .height('100%')
      .width(this.isClickScrollBar ? $r('app.float.scroll_press_all_width') : $r('app.float.scroll_bar_small_width'))
      .onTouch((event?: TouchEvent) => {
        if (this.dateText == '') {
          Log.debug(TAG, `dateText is null`)
          this.broadCast.emit(BroadCastConstants.INIT_DATE_TEXT, [])
        }
        if ((event as TouchEvent).type == TouchType.Move && !this.isClickScrollBar) {
          Log.debug(TAG, `scrollBar first TouchType.Move`);
          this.isClickScrollBar = true;
        } else if ((event as TouchEvent).type == TouchType.Up || (event as TouchEvent).type == TouchType.Cancel) {
          Log.debug(TAG, `scrollBar TouchType.Up or Cancel. type=${(event as TouchEvent).type}`);
          this.isClickScrollBar = false;
        }
      })
    }
    .hitTestBehavior(HitTestMode.Transparent)
    .position({ x: '100%', y: 0 })
    .markAnchor({
      x: '100%',
      y: 0
    })
  }
}