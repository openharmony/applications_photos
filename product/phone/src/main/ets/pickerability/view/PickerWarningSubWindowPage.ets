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
import lazy { SubWindowUtil } from '@ohos/common/src/main/ets/default/utils/SubWindowUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

// instrument ignore file
const TAG: string = 'SubWindowPage';

@Entry
@Component
struct PickerWarningSubWindowPage {
  // @State sheetType: PickerType = PickerType.GALLERY_PICKER;
  @State isShowSheet: boolean = false;

  aboutToAppear(): void {
    Log.i(TAG, 'SubWindowPage aboutToAppear');
    // 延迟50ms再展示半模态，否则会卡顿
    setTimeout((): void => {
      this.isShowSheet = true;
    }, 50);
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      if (this.isShowSheet) {
        // PickerSheet({
        //   curPickerKey: this.sheetType,
        //   appIcon: $r('app.media.img_gallery_icon'),
        //   onClose: () => {
        //     SubWindowUtil.destroySubWindow();
        //   },
        // });
      }
    }
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }
}