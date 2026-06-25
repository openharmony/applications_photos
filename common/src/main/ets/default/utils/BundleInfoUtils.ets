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

import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy { Log } from './Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'BundleInfoUtils';

export class BundleInfoUtils {
  public static async getAppIdByBundleName(bundleName: string): Promise<string> {
    Log.info(TAG, `getAppIdByBundleName start. bundleName:${bundleName}`);
    return bundleManager.getBundleInfo(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO)
      .then((data) => {
        Log.info(TAG, `getAppIdByBundleName end. bundleName:${bundleName}`);
        return data?.signatureInfo?.appId;
      })
      .catch((error: BusinessError) => {
        Log.error(TAG, `getAppIdByBundleName has error, ${error}`);
        return '';
      });
  }
}