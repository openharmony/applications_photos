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
import { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import Curves from '@ohos.curves';
import { Log } from '../utils/Log';

const TAG: string = 'browser_PhotoBrowserComponentBg';

@Component
export struct PhotoBrowserComponentBg {
  @Consume @Watch('onChangeBgColor') onlyChangeBgColor: boolean;
  @Consume backgroundColorResource: Resource;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;
  @State isBlackBgVisibility: boolean = false;
  @State blackBgColorResource: Resource = this.backgroundColorResource;
  private isFromPhotoBrowser = false;

  onShowChanged(): void {
    if (!this.isShowBar) {
      this.isBlackBgVisibility = true;
    }
    if (this.blackBgColorResource.id != $r('app.color.black').id) {
      this.blackBgColorResource = this.backgroundColorResource;
    }
    animateTo({
      duration: PhotoConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? 0 : PhotoConstants.IMMERSE_ANIM_DELAY,
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
        .key('PhotoBrowserBg')
        .backgroundColor($r('app.color.default_background_color'))
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
          duration: PhotoConstants.IMMERSE_ANIM_DURATION
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}