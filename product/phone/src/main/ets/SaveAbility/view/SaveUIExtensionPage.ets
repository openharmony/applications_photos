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
import lazy { SaveUIExtensionComponent } from '@ohos/extensions/src/main/ets/view/SaveUIExtensionComponent';

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
  /* instrument ignore file */
export struct SaveUIExtensionPage {
  private wantParam: Record<string, Object> = storage?.get(Constants.APP_KEY_WANT_PARAM) as Record<string, Object>;
  private session: UIExtensionContentSession | undefined =
    storage?.get<UIExtensionContentSession>(Constants.APP_KEY_SESSION) as UIExtensionContentSession;

  public onPageShow(): void {
    this.session?.setWindowBackgroundColor(Constants.COLOR_TRANSPARENT);
  }

  build() {
    Column() {
      SaveUIExtensionComponent({
        isPc: false,
        session: this.session,
        wantParam: this.wantParam,
      })
    }
    .width('100%')
    .height('100%')
  }
}