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
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeleteUIExtensionComponent } from '@ohos/common/src/main/ets/default/view/DeleteUIExtensionComponent';

/* instrument ignore file */
const FOREGROUND_PHOTO_WIDTH: number = 576;
const BACKGROUND_PHOTO_WIDTH: number = 512;

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct DeleteUIExtensionPage {
  private session: UIExtensionContentSession =
    storage?.get<UIExtensionContentSession>(Constants.APP_KEY_SESSION) as UIExtensionContentSession;
  private phoneAlignRule: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
    'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
    'middle': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
  };

  onPageShow() {
    this.session.setWindowBackgroundColor(Constants.COLOR_TRANSPARENT);
  }

  build() {
    Column() {
      DeleteUIExtensionComponent({
        isPc: false,
        foregroundPhotoWidth: FOREGROUND_PHOTO_WIDTH,
        backgroundPhotoWidth: BACKGROUND_PHOTO_WIDTH,
        session: this.session,
        storage: storage,
        alignRule: this.phoneAlignRule,
      })
    }
    .width('100%')
    .height('100%')
  }
}