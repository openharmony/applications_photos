/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Constants, Log, PhotoDataSource, ScreenManager } from '@ohos/common';
import { MouseTurnPageButton } from './MouseTurnPageButton';

const TAG: string = 'browser_MouseTurnPageOperation';

@Component
export struct MouseTurnPageOperation {
  @State isOnLeftHover: boolean = false
  @State isOnRightHover: boolean = false
  @State isOnFirstHover: boolean = false
  isShowBar: boolean = false
  @Consume('transitionIndex') currentIndex: number
  @Prop isPhotoScaled: boolean = false
  private controller: SwiperController | null = null;
  private dataSource: PhotoDataSource | null = null;

  aboutToAppear(): void {
    this.isOnFirstHover = true
  }

  build() {
    if (!this.isPhotoScaled) {
      Row() {
        this.PhotoSwiperArrow()
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({
        top: $r('app.float.mouse_turn_page_button_margin'),
        bottom: $r('app.float.mouse_turn_page_button_margin')
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .onMouse((event?: MouseEvent) => {
        if (this.isOnFirstHover) {
          this.isOnFirstHover = false
          this.isOnLeftHover = true
          this.isOnRightHover = true
          setTimeout(() => {
            this.isOnLeftHover = false
            this.isOnRightHover = false
          }, Constants.MOUSE_TURN_PAGE_BUTTON_DISAPPEAR_TIMEOUT)
        }
      })
    }
  }

  @Builder
  PhotoSwiperArrow() {
    // Left
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Column()
          .width('100%')
          .height('100%')
          .onHover((isHover?: boolean) => {
            if (isHover != null) {
              this.isOnLeftHover = isHover
            }
          })
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .margin({
        top: this.isShowBar ? (ScreenManager.getInstance().getStatusBarHeight() + Constants.ActionBarHeight)
                            : ScreenManager.getInstance().getStatusBarHeight()
      })

      Column() {
        if (this.isOnLeftHover &&
        this.currentIndex > Constants.NUMBER_0) {
          MouseTurnPageButton({ isStart: true })
            .key('LeftMouseTurnPageButton')
            .onClick(() => {
              if (this.controller != null) {
                this.controller.showPrevious();
              }
            })
        }
      }
      .onHover((isHover?: boolean) => {
        if (isHover != null) {
          this.isOnLeftHover = isHover
        }
      })
      .width($r('app.float.mouse_turn_page_button_response_size'))
      .height($r('app.float.mouse_turn_page_button_response_size'))
      .padding({
        top: $r('app.float.mouse_turn_page_button_wrapper_padding'),
        bottom: $r('app.float.mouse_turn_page_button_wrapper_padding')
      })
    }
    .width($r('app.float.mouse_turn_page_button_hot_zone_width'))

    // Right
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Column()
          .width('100%')
          .height('100%')
          .onHover((isHover?: boolean) => {
            if (isHover != null) {
              this.isOnRightHover = isHover
            }
          })
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .margin({
        top: this.isShowBar ? (ScreenManager.getInstance().getStatusBarHeight() + Constants.ActionBarHeight)
                            : ScreenManager.getInstance().getStatusBarHeight()
      })

      Column() {
        if (this.isOnRightHover && this.dataSource != null &&
        this.currentIndex < this.dataSource.totalCount() - Constants.NUMBER_1) {
          MouseTurnPageButton({ isStart: false })
            .key('RightMouseTurnPageButton')
            .onClick(() => {
              if (this.controller != null) {
                this.controller.showNext();
              }
            })
        }
      }
      .onHover((isHover?: boolean) => {
        if (isHover != null) {
          this.isOnRightHover = isHover
        }
      })
      .width($r('app.float.mouse_turn_page_button_response_size'))
      .height($r('app.float.mouse_turn_page_button_response_size'))
      .padding({
        top: $r('app.float.mouse_turn_page_button_wrapper_padding'),
        bottom: $r('app.float.mouse_turn_page_button_wrapper_padding')
      })
    }
    .width($r('app.float.mouse_turn_page_button_hot_zone_width'))
  }
}