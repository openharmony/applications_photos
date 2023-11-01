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

import { Log } from '../utils/Log';

const TAG: string = 'common_GridScrollBar';

@Component
export struct GridScrollBar {
  scroller: Scroller | null = null;
  @State isClickScrollBar: boolean = false;

  build() {
    ScrollBar({ scroller: this.scroller as Scroller, direction: ScrollBarDirection.Vertical,
      state: BarState.Auto }) {
      Row() {
        if (this.isClickScrollBar) {
          Image($r('app.media.scroll_press_light'))
            .width($r('app.float.scroll_bar_big_width'))
            .height($r('app.float.scroll_bar_big_height'))
        } else {
          Image($r('app.media.scroll_light'))
            .width($r('app.float.scroll_bar_small_width'))
            .height($r('app.float.scroll_bar_small_height'))
            .borderRadius(25)
        }
      }
    }
    .width(this.isClickScrollBar ? $r('app.float.scroll_bar_margin_small') : $r('app.float.scroll_bar_small_width'))
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .position({ x: '100%', y: 0 })
    .markAnchor({
      x: this.isClickScrollBar ? $r('app.float.scroll_bar_big_width') : $r('app.float.scroll_bar_small_width'),
      y: 0
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type == TouchType.Move && !this.isClickScrollBar) {
        Log.debug(TAG, `scrollBar first TouchType.Move`);
        this.isClickScrollBar = true;
      } else if (event?.type == TouchType.Up || event?.type == TouchType.Cancel) {
        Log.debug(TAG, `scrollBar TouchType.Up or Cancel. type=${event?.type}`);
        this.isClickScrollBar = false;
      }
    })
  }
}