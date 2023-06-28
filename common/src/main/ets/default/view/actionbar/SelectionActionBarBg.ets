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

// Select mode preview backplane
@Component
export struct SelectionActionBarBg {
  build() {
    Column() {
    }
    .width('100%')
    .height($r('app.float.selection_actionbar_bg_height'))
    .linearGradient({ angle: 0, colors:
    [[$r('app.color.transparent'), 0], [$r('app.color.selection_actionbar_gradient_start_color'), 1.0]] })
  }
}
