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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { getScreen, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo'
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { PhotoBrowserStateMachine } from '../../viewModel/statemachine/PhotoBrowserStateMachine';

/* instrument ignore file */
const TAG: string = 'browser_MouseTurnPageOperation';
const SLIDE_BAR_SHOW_DURATION: number = 2000;

@Component
export struct MouseTurnPageOperation {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State isOnLeftHover: boolean = true;
  @State isOnRightHover: boolean = true;
  @State isOnFirstHover: boolean = false;
  @State windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  @Link isShowBar: boolean;
  @Consume('transitionIndex') currentIndex: number;
  @Consume isEnableMouse: boolean;
  @Prop isPhotoScaled: boolean = false;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private controller: SwiperController | null = null;
  private dataSource: PhotoDataSource | null = null;
  private mTimer: number = 0;
  private propertiesDefaultWidth: number = 333;
  private rightTimer: number = 0;
  private leftTimer: number = 0;
  @LocalStorageLink('sideBarWidth') sideBarWidth: number = 0;
  @Prop isDetailSelected: boolean = false;
  @Prop isPcPictureScene: boolean = false;
  @Prop isShowSideBar: boolean = true;

  private setTurnTimer(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.leftTimer && clearTimeout(this.leftTimer);
      this.rightTimer && clearTimeout(this.rightTimer);
      this.leftTimer = setTimeout((): void => {
        this.isOnLeftHover = false;
      }, SLIDE_BAR_SHOW_DURATION);
      this.rightTimer = setTimeout((): void => {
        this.isOnRightHover = false;
      }, SLIDE_BAR_SHOW_DURATION);
    }
  }

  private onWinSizeChanged(): void {
    this.windowLayoutWidth = getScreen().getWinLayoutWidth();
  }

  /**
   * 点击向左划或者向右划,先保存详情信息
   */
  private clickSaveProInfo(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.isDetailSelected) {
      this.appBroadCast?.emit(BroadCastConstants.TURN_LEFT_OR_RIGHT_ITEM_CLICKED, []);
    }
  }

  aboutToAppear(): void {
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.isOnFirstHover = true;
    this.setTurnTimer();
  }

  aboutToDisappear() {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  showHover(): void {
    Log.info(TAG, 'showHover');
    this.isOnLeftHover = true;
    this.isOnRightHover = true;
    this.mTimer = setTimeout((): void => {
      this.mTimer = 0;
      this.isOnLeftHover = false;
      this.isOnRightHover = false;
    }, Constants.MOUSE_TURN_PAGE_BUTTON_DISAPPEAR_TIMEOUT);
  }

  build() {
    if (!this.isPhotoScaled) {
      Row() {
        this.PhotoSwiperArrow();
      }
      // 如果PC展示详情的话，需要修改宽度比例
      .width(this.getMouseTurnPageOperationWith())
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({
        top: $r('app.float.mouse_turn_page_button_margin'),
        bottom: $r('app.float.mouse_turn_page_button_margin'),
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .onMouse((event: MouseEvent): void => {
        if (event && this.isOnFirstHover) {
          this.isOnFirstHover = false;
          this.isEnableMouse = true;
        }
      })
    }
  }

  /**
   * 详情左右切图目前只整改了PC图库大图预览场景
   * @returns
   */
  private getMouseTurnPageOperationWith(): number | string {
    Log.info(TAG,
      `this.isDetailSelected: ${this.isDetailSelected}, this.isPcPictureScene: ${this.isPcPictureScene}, this.isShowSideBar: ${this.isShowSideBar}`);
    if (this.isDetailSelected && this.isPcPictureScene) {
      return this.windowLayoutWidth - this.propertiesDefaultWidth - (this.isShowSideBar ? this.sideBarWidth : 0);
    }
    if (this.stateMachine.isPropertiesShow() && DeviceInfo.isPc()) {
      return this.windowLayoutWidth - this.propertiesDefaultWidth;
    }
    return '100%';
  }

  @Styles
  commonStyle() {
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .margin({
      top: this.isShowBar ? (getScreen()
        .getStatusBarHeight() + Constants.ActionBarHeight) : getScreen().getStatusBarHeight()
    })
  }

  @Styles
  commonColumnStyle() {
    .width($r('app.float.mouse_turn_page_button_response_size'))
    .height($r('app.float.mouse_turn_page_button_response_size'))
    .padding({
      top: $r('app.float.mouse_turn_page_button_wrapper_padding'),
      bottom: $r('app.float.mouse_turn_page_button_wrapper_padding'),
    })
  }

  @Styles
  commonStackStyle() {
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
    })
    .width($r('app.float.mouse_turn_page_button_hot_zone_width'))
  }

  @Builder
  PhotoSwiperArrow() {
    this.LeftMouseTurnPageButton();
    this.RightMouseTurnPageButton();
  }

  @Builder
  LeftMouseTurnPageButton() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .commonStyle()
      .onHover((isHover?: boolean) => {
        this.isOnLeftHover = isHover ?? this.isOnLeftHover;
      })

      Column() {
        if (this.isOnLeftHover &&
          this.currentIndex > 0) {
          // MouseTurnPageButton({ isStart: true })
          //   .key('LeftMouseTurnPageButton')
          //   .onClick((): void => {
          //     this.controller?.showPrevious();
          //     this.isOnLeftHover = this.currentIndex > 1;
          //     this.clickSaveProInfo();
          //   })
        }
      }
      .onHover((isHover?: boolean) => {
        this.isOnLeftHover = isHover ?? this.isOnLeftHover;
        isHover && clearTimeout(this.leftTimer);
      })
      .commonColumnStyle()
    }
    .commonStackStyle()
  }

  @Builder
  RightMouseTurnPageButtonInner() {
    Column() {
      if (this.isOnRightHover &&
        this.currentIndex < (this.dataSource?.totalCount() ?? 0) - 1) {
        // MouseTurnPageButton({ isStart: false })
        //   .key('RightMouseTurnPageButton')
        //   .onClick((): void => {
        //     this.controller?.showNext();
        //     this.isOnRightHover = this.currentIndex < (this.dataSource?.totalCount() ?? 0) - 2;
        //     this.clickSaveProInfo();
        //   })
      }
    }
    .onHover((isHover?: boolean) => {
      this.isOnRightHover = isHover ?? this.isOnRightHover;
      isHover && clearTimeout(this.rightTimer);
    })
    .commonColumnStyle()
  }

  @Builder
  RightMouseTurnPageButton() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .commonStyle()
      .onHover((isHover?: boolean) => {
        this.isOnRightHover = isHover ?? this.isOnRightHover;
      })

      this.RightMouseTurnPageButtonInner();
    }
    .commonStackStyle()
  }
}


