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

import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy PrivacyViewer from '../components/mainpage/PrivacyViewer';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG = 'AgreementPage';

/* instrument ignore file */
@Entry
@Component
export struct AgreementPage {
  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
  }

  build() {
    Row() {
      PrivacyViewer({
      //   agreement: {
      //     type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
      //       (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL)
      //   },
      //   isFullPage: true,
      })
    }
  }
}