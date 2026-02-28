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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy userUtils from './UserUtils';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';

const TAG = 'MaskLayerUtils';

@Observed
export class MaskLayerUtils {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private static _ins: MaskLayerUtils | null = null;
  public isPickerMaskLayerShow: boolean = false;

  static getInstance(): MaskLayerUtils {
    if (!MaskLayerUtils._ins) {
      MaskLayerUtils._ins = new MaskLayerUtils();
    }
    return MaskLayerUtils._ins;
  }

  async init() {
    try {
      const d = Date.now();
      const userId: number = await userUtils.getUserId();
      // const isPickerMaskLayerShow: boolean = await appLock.isAppProtected('com.ohos.photos', {
      //   userId
      // });
      //this.setIsPickerMaskLayerShow(isPickerMaskLayerShow);
      const isPickerMaskLayerShow: boolean = false;
      Log.info(TAG,
        `MaskLayerUtils init show = ${this.isPickerMaskLayerShow}, userId = ${userId}, time = ${Date.now() - d}`);
    } catch (e) {
      Log.error(TAG, `getPickerAppProtected has error: ${e?.message}, code: ${e?.code}`);
    }
  }

  public getIsPickerMaskLayerShow(): boolean {
    return this.isPickerMaskLayerShow;
  }

  public setIsPickerMaskLayerShow(isPickerMaskLayerShow: boolean, isNeedEmitEvent: boolean = true): void {
    this.isPickerMaskLayerShow = isPickerMaskLayerShow;
    if (isNeedEmitEvent) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_PICKER_APP_LOCK_STATUS_UPDATED, [this.isPickerMaskLayerShow]);
    }
  }

  public async setPickerProtectedState(storage: LocalStorage, status: boolean) {
    try {
      let hostBundleName: string = '';
      let hostAppIndex: number = 0;
      if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
        const param = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
        hostBundleName = param?.bundleName ?? '';
        hostAppIndex = param?.appCloneIndex ?? 0;
      }
      // const appInfo: appLock.AppInfo = {
      //   bundleName: hostBundleName,
      //   appIndex: hostAppIndex,
      // };
      const userId = await userUtils.getUserId();
      // await AppLockManager.Helper.setPickerProtectedState([appInfo], AppLockManager.PickerType.PHOTO, status, userId);
    } catch (e) {
      Log.error(TAG, `setPickerProtectedState has error: ${e?.message}, code: ${e?.code}`);
    }
  }
}