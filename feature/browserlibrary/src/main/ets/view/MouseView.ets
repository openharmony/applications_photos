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
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MouseTurnPageButton } from '@ohos/browsercommon/src/main/ets/default/view/MouseTurnPageButton';
import lazy { PhotoBrowserController } from '../model/PhotoBrowserController';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { PhotosHmBrowserController } from '../Index';

const TAG: string = 'browser_MouseView';
const SLIDE_BAR_SHOW_DURATION: number = 2000;

/**
 * 大图页鼠标切换组件，支持在鼠标场景下，点击改组件提供的左右箭头按钮，切换图片
 */
@Component
export struct MouseView {
  @Consume browserController: PhotosHmBrowserController;
  @State isOnLeftHover: boolean = true;
  @State isOnRightHover: boolean = true;
  @State isOnFirstHover: boolean = false;
  @Link isShowBar: boolean;
  @Consume('transitionIndex') currentIndex: number;
  @Prop isPhotoScaled: boolean = false;
  private controller: SwiperController = new SwiperController();
  private mTimer: number = 0;
  private rightTimer: number = 0;
  private leftTimer: number = 0;

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

  aboutToAppear(): void {
    this.isOnFirstHover = true;
    this.setTurnTimer();
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
      .width('100%')
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
        }
      })
      .key(TAG)
    }
  }

  @Builder
  PhotoSwiperArrow() {
    // Left
    this.LeftMouseTurnPageButton();
    // Right
    this.RightMouseTurnPageButton();
  }

  @Builder
  LeftMouseTurnPageButton() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .width('100%')
      .height('100%')
      .onHover((isHover?: boolean) => {
        this.isOnLeftHover = isHover ?? this.isOnLeftHover;
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .margin({
        top: this.isShowBar ? (getScreen()
          .getStatusBarHeight() + Constants.ActionBarHeight) : getScreen().getStatusBarHeight()
      })

      Column() {
        if (this.isOnLeftHover &&
          this.currentIndex > 0) {
          MouseTurnPageButton({ isStart: true })
            .key('LeftMouseTurnPageButton')
            .onClick((): void => {
              this.controller.showPrevious();
              if (this.currentIndex > 1) {
                this.isOnLeftHover = true;
              } else {
                this.isOnLeftHover = false;
              }
            })
        }
      }
      .onHover((isHover?: boolean) => {
        this.isOnLeftHover = isHover ?? this.isOnLeftHover;
        isHover && clearTimeout(this.leftTimer);
      })
      .width($r('app.float.mouse_turn_page_button_response_size'))
      .height($r('app.float.mouse_turn_page_button_response_size'))
      .padding({
        top: $r('app.float.mouse_turn_page_button_wrapper_padding'),
        bottom: $r('app.float.mouse_turn_page_button_wrapper_padding'),
      })
    }
    .width($r('app.float.mouse_turn_page_button_hot_zone_width'))
  }

  @Builder
  RightMouseTurnPageButton() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .width('100%')
      .height('100%')
      .onHover((isHover?: boolean) => {
        this.isOnRightHover = isHover ?? this.isOnRightHover;
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .margin({
        top: this.isShowBar ? (getScreen()
          .getStatusBarHeight() + Constants.ActionBarHeight) : getScreen().getStatusBarHeight()
      })

      Column() {
        // if (this.isOnRightHover &&
        //   this.currentIndex < this.browserController.dataSource.totalCount() - 1) {
        //   MouseTurnPageButton({ isStart: false })
        //     .key('RightMouseTurnPageButton')
        //     .onClick((): void => {
        //       this.controller.showNext();
        //       this.isOnRightHover = this.currentIndex < this.browserController.dataSource.totalCount() - 2;
        //     })
        // }
      }
      .onHover((isHover?: boolean) => {
        this.isOnRightHover = isHover ?? this.isOnRightHover;
        isHover && clearTimeout(this.rightTimer);
      })
      .width($r('app.float.mouse_turn_page_button_response_size'))
      .height($r('app.float.mouse_turn_page_button_response_size'))
      .padding({
        top: $r('app.float.mouse_turn_page_button_wrapper_padding'),
        bottom: $r('app.float.mouse_turn_page_button_wrapper_padding'),
      })
    }
    .width($r('app.float.mouse_turn_page_button_hot_zone_width'))
  }
}

