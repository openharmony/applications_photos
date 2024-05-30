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
import { ScreenManager } from '../model/common/ScreenManager';

@Component
export struct PhotoBrowserHolder {
  @Consume isShowBar: boolean;
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];

  build() {
    Column() {
    }
    .key('PhotoBrowserHolder0')
    .backgroundColor($r('app.color.default_background_color'))
    .width('100%')
    .height(this.leftBlank[3])
    .markAnchor({ x: '0%', y: '100%' })
    .position({ x: '0%', y: '100%' })
    .opacity(0.95)
    .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
  }
}