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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';

/* instrument ignore file */
const TAG: string = 'PickerSelectTipToast';

@Component
export struct PickerSelectTipToast {
  params?: SelectParams = this.getUIContext().getSharedLocalStorage()?.get<SelectParams>(
    Constants.PHOTO_PICKER_PARAMS_KEY
  );

  aboutToAppear(): void {
    Log.info(TAG, `PickerSelectTipToast is aboutToAppear.`)
  }

  build() {
    // PickerShieldAnimate({
    //   pickerType:PickerType.GALLERY_PICKER,
    //   animateType: AnimateType.TOAST,
    //   callerBundleName: this.params?.bundleName,
    //   callerPid: this.params?.callerPid,
    // })
    // .hitTestBehavior(HitTestMode.None)
  }
}