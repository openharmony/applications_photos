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
import lazy { assert } from '../model/common/DataTypes';
import lazy { Log } from './Log';

/* instrument ignore file */
const TAG = 'Bundles';

export const BUNDLE_NAMES: Record<string, string> = {
  'camera': 'com.ohos.camera',
};

export namespace Bundles {
  /**
   * 开发者联盟现网环境 app_id
   * 配置位于 NewPhotos/product/phone/src/main/module.json5:23
   * 注意：测试环境的clientId和现网环境的不同，代码中涉及auth的部分都需要修改。
   */
  export const APP_ID = '109998783';

  //Government record al Number
  export const ICP = '苏ICP备17040376号-273A';

  export const CUSTOMER_SERVICE: string = '950800';

  // Get want info with key
  export const KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME: string = 'ohos.aafwk.param.callerBundleName';

  export const KEY_WANT_PARAMETERS_CALLER_ABILITY_NAME: string = 'ohos.aafwk.param.callerAbilityName';

  export const KEY_WANT_PARAMETERS_CALLER_TOKEN: string = 'ohos.aafwk.param.callerToken';

  export function isFromCamera(wantParam: Record<string, Object> | undefined): boolean {
    if (!wantParam) {
      Log.error(TAG, 'wantParam was undefined');
      return false;
    }
    const name = Bundles.getName(wantParam);
    switch (name) {
      case BUNDLE_NAMES.camera:
        return true;
      default:
        Log.error(TAG, `${name} was undefined`);
    }
    return false;
  }

  //获取拉起进程的包名
  export function getName(wantParam: Record<string, Object>): string {
    let member: Object = wantParam?.[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME];
    return assert.asDefault(member, '');
  }

  //获取图库包信息
  export function getInfo(): bundleManager.BundleInfo {
    return bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
  }
}

export default Bundles;