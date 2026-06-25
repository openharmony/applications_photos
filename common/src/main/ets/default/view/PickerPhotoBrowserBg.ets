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
import lazy { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import lazy Curves from '@ohos.curves';

@Component
  /* instrument ignore file */
export struct PickerPhotoBrowserBg {
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;

  onShowChanged(): void {
    animateTo({
      duration: PhotoConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? 0 : PhotoConstants.IMMERSE_ANIM_DELAY,
      curve: this.isShowBar ? Curves.cubicBezier(0.2, 0.0, 0.2, 1.0) : Curves.cubicBezier(0.6, 0.0, 0.6, 1.0),
    }, () => {
      if (this.isShowBar) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  build() {
    Column()
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .backgroundColor($r('sys.color.background_secondary'))
      .key('PhotoBrowserBg')
      .opacity(this.opacityValue)
  }
}