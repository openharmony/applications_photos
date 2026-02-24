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
import lazy { GridScrollMsg } from '../model/common/GridScrollMsg';
import lazy { GridDragScrollBaseHelper } from '../utils/GridDragScrollBaseHelper';
import lazy { Log } from '../utils/Log';
import lazy { UiUtil } from '../utils/UiUtil';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil,
  AlbumBrowsingInfo,
  Scenario,
  PhotoInfo
} from '../utils/ReportToBigDataUtil';

/* instrument ignore file */
const TAG: string = 'common_GridScrollBar';

@Component
export struct GridScrollBar {
  public scroller: Scroller | null = null;
  private gridDragScrollHelper?: GridDragScrollBaseHelper;
  @State isClickScrollBar: boolean = false;
  @Prop paddingTop: number = 0;
  @Prop paddingBottom: number = 0;
  private gridScrollMsg: GridScrollMsg = new GridScrollMsg(false);
  private readonly scrollBarElemId: string = 'GridScrollBar';
  private moveStartY: number = -1; //侧边栏滚动条的开始坐标值
  private moveEndY: number = -1; //侧边栏滚动条的结束坐标值
  private changedNum: number = 0; //起始与结束滑动的改变值
  private isMovedFlag: Boolean = false; //判定为滑动的标志

  private handleTouchEvent(event: TouchEvent): void {
    AppStorage.setOrCreate<boolean>('isTouchScrollBar', true);
    if (this.moveStartY === -1) {
      //第一次按下时的坐标值
      this.moveStartY = event.touches?.pop()?.y as number;
    } else {
      //当下Touch的坐标值
      this.moveEndY = event.touches?.pop()?.y as number;
    }
    //当前后滑动的差值大于0
    if (this.moveStartY !== -1 && this.moveEndY !== -1 && !this.isMovedFlag) {
      this.changedNum = Math.abs(this.moveStartY - this.moveEndY);
      if (this.changedNum > 0) {
        Log.info(TAG, `changedNum = ${this.changedNum}`);
        this.isMovedFlag = true;
      }
    }
    if (event.type === TouchType.Move && !this.isClickScrollBar && this.isMovedFlag) {
      Log.debug(TAG, 'scrollBar first TouchType.Move');
      this.isClickScrollBar = true;

      let scenario = ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex);
      const msg: Record<string, number | string | boolean> = {
        'browserEvent': 'scrollBarBrowse',
        'scenario': scenario,
      };
      if (scenario === Scenario.ALBUM_PAGE) {
        msg['subAlbumType'] = AlbumBrowsingInfo.albumSubtype;
      }
      ReportToBigDataUtil.report(BigDataConstants.SCROLL_BAR_BROWSE, msg);
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      Log.debug(TAG, `scrollBar TouchType.Up or Cancel. type=${event.type}`);
      AppStorage.setOrCreate<boolean>('isTouchScrollBar', false);
      this.isClickScrollBar = false;
      this.gridScrollMsg.isScrollerBarTouch = false;
      this.gridDragScrollHelper?.handleScrollStop();
      this.isMovedFlag = false;
      this.moveStartY = -1;
      this.moveEndY = -1;
    } else if (event.type === TouchType.Down) {
      Log.debug(TAG, 'scrollBar TouchType.Down');
      if (UiUtil.isScrollBarVisible(this.scrollBarElemId)) {
        this.gridScrollMsg.isScrollerBarTouch = true;
      }
      this.gridDragScrollHelper?.handleScrollStart();
    }
  }

  build() {
    ScrollBar({
      scroller: this.scroller as Scroller, direction: ScrollBarDirection.Vertical,
      state: BarState.Auto,
    }) {
      Row() {
        if (this.isClickScrollBar) {
          Image($r('app.media.scroll_press_light'))
            .draggable(false)
            .width($r('app.float.scroll_bar_big_width'))
            .height($r('app.float.scroll_bar_big_height'))
        } else {
          Image($r('app.media.scroll_light'))
            .draggable(false)
            .width($r('app.float.scroll_bar_small_width'))
            .height($r('app.float.scroll_bar_small_height'))
            .borderRadius(25)
        }
      }
      .onTouch((event: TouchEvent): void => {
        this.handleTouchEvent(event);
      })
    }
    .id(this.scrollBarElemId)
    .width(this.isClickScrollBar ? $r('app.float.scroll_bar_margin_small') : $r('app.float.scroll_bar_small_width'))
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .position({ x: UiUtil.isMirrorMode() ? 0 : '100%', y: 0 })
    .padding({ top: this.paddingTop, bottom: this.paddingBottom })
    .markAnchor({
      x: UiUtil.isMirrorMode() ? 0 :
        (this.isClickScrollBar ? $r('app.float.scroll_bar_big_width') : $r('app.float.scroll_bar_small_width')),
      y: 0,
    })
  }
}