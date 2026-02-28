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
 
import { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData'

@Component
export struct LazyLoadImg {
  @Prop item: ViewData
  @Prop @Watch('onTouchScrollEndChange') touchScrollEnd: boolean
  @BuilderParam children: () => void

  aboutToAppear(): void {
    if (!this.touchScrollEnd) {
      this.item.deferLoad = true;
    } else {
      this.item.deferLoad = false;
    }
  }

  private onTouchScrollEndChange(): void {
    if (this.touchScrollEnd) {
      this.item.deferLoad = false;
    }
  }

  private shouldShowSpace(): boolean {
    return !this.touchScrollEnd && this.item.deferLoad === true;
  }

  build() {
    Row() {
      if (this.shouldShowSpace()) {
        Row().width('100%').aspectRatio(1).backgroundColor("#E0E0E0")
      } else {
        this.children?.()
      }
    }
    .onAppear(() => {
      if (!this.touchScrollEnd) {
        this.item.deferLoad = true;
      } else {
        this.item.deferLoad = false;
      }
    })
  }
}
