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
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Curves from '@ohos.curves';

const TAG: string = 'browser_BackgroundView';
const PROPERTY_BACK_GROUND_OPACITY: number = 0.05;
const BG_COLOR_CHANGE_ANIMATION = 200;

/**
 * 大图页背景板组件，随大图页是否为沉浸式状态而变化颜色
 */
@Component
export struct BackgroundView {
  @Consume @Watch('onChangeBgColor') onlyChangeBgColor: boolean;
  @Consume backgroundColorResource: Resource;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;
  @State isBlackBgVisibility: boolean = false;
  @State blackBgColorResource: Resource = this.backgroundColorResource;
  // 防止大图背景与actionbar、toolbar背景过度绘制，导致进出编辑动效背景透明度不一致的问题
  @Prop avoidOverdrawPadding: Padding | null = null;
  @Prop @Watch('onIsDetailSelectedChanged') isDetailSelected: boolean = false;
  @State backColor: Resource = $r('sys.color.background_secondary');
  private isFromPhotoBrowser: boolean = false;

  aboutToAppear(): void {
    Log.debug(TAG, '[aboutToAppear] start');
    if (this.isShowBar) {
      this.isBlackBgVisibility = false;
      this.opacityValue = 1;
    } else {
      this.isBlackBgVisibility = true;
      this.opacityValue = 0;
    }
  }

  onIsDetailSelectedChanged(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.isDetailSelected) {
      this.opacityValue = PROPERTY_BACK_GROUND_OPACITY;
      animateTo({
        duration: BG_COLOR_CHANGE_ANIMATION,
        curve: Curve.Sharp,
      }, () => {
        this.backColor = $r('app.color.black');
      })
    } else {
      this.backColor = $r('sys.color.background_secondary');
      animateTo({
        duration: BG_COLOR_CHANGE_ANIMATION,
        curve: Curve.Sharp,
      }, () => {
        this.opacityValue = this.isShowBar ? 1 : 0;
      })
    }
    Log.info(TAG, `isDetailSelected: ${this.isDetailSelected}, opacityValue: ${this.opacityValue}`);
  }

  onShowChanged(): void {
    Log.debug(TAG, `[onShowChanged] isShowBar: ${this.isShowBar}`);
    if (!this.isShowBar) {
      this.isBlackBgVisibility = true;
    }
    if (this.blackBgColorResource.id != $r('app.color.black').id) {
      this.blackBgColorResource = this.backgroundColorResource;
    }
    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? 0 : BrowserConstants.IMMERSE_ANIM_DELAY,
      curve: this.isShowBar ? Curves.cubicBezier(0.2, 0.0, 0.2, 1.0) : Curves.cubicBezier(0.6, 0.0, 0.6, 1.0),
      onFinish: () => {
        if (this.isShowBar) {
          this.isBlackBgVisibility = false;
        }
        this.blackBgColorResource = this.backgroundColorResource;
      }
    }, () => {
      if (this.isShowBar) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  onChangeBgColor(): void {
    this.blackBgColorResource = this.backgroundColorResource;
  }

  build() {
    Stack() {
      if (this.isFromPhotoBrowser) {
        if (this.isBlackBgVisibility) {
          Column() {
          }
          .key('PhotoBrowserBg')
          .backgroundColor(this.blackBgColorResource)
          .width('100%')
          .height('100%')
        }

        Column() {
        }
        .backgroundColor(this.backColor)
        .key('PhotoBrowserBg')
        .padding(this.isBlackBgVisibility ? 0 : (this.avoidOverdrawPadding ?? 0))
        .width('100%')
        .height('100%')
        .opacity(this.opacityValue)
      } else {
        Column() {
        }
        .key('PhotoBrowserBg')
        .backgroundColor(this.backgroundColorResource)
        .width('100%')
        .height('100%')
        .animation({
          duration: BrowserConstants.IMMERSE_ANIM_DURATION,
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}