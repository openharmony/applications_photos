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

import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { FoldPhonePhotoItemVM } from '../phone/FoldPhonePhotoItemVM';
import lazy { PhonePhotoItemVM } from '../phone/PhonePhotoItemVM';
import lazy { ThirdFoldPhonePhotoItemVM } from '../phone/ThirdFoldPhotoItemVm';
import lazy { PhotoBrowserStateMachine } from '../statemachine/PhotoBrowserStateMachine';
import lazy { TabletPhotoItemVM } from '../tablet/TabletPhotoItemVM';
import lazy { PhotoItemVM } from './PhotoItemVM';

export class PhotoItemVMFactory {
  public static getPhotoItemVM(stateMachine: PhotoBrowserStateMachine): PhotoItemVM {
    /* instrument ignore next */
    if (DeviceInfo.isTabletDevice() || DeviceInfo.isSuperLauncher()) {
      return new TabletPhotoItemVM(stateMachine);
    } else if (DeviceInfo.isGRLFoldScreen()) {
      return new ThirdFoldPhonePhotoItemVM(stateMachine);
    } else if (DeviceInfo.isFoldDevice()) {
      return new FoldPhonePhotoItemVM(stateMachine);
    } else {
      return new PhonePhotoItemVM(stateMachine);
    }
  }
}