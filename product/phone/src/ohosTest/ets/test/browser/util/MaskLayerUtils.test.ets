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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { MaskLayerUtils } from "@ohos/thirdselect/src/main/ets/default/utils/MaskLayerUtils";
import userUtils from '@ohos/thirdselect/src/main/ets/default/utils/UserUtils';
import appLock from '@ohos.security.appLock';
import { SelectParams } from "@ohos/common/src/main/ets/default/model/common/SelectParams";
import { Constants } from "@ohos/common/src/main/ets/default/model/common/Constants";

export default function MaskLayerUtilsUT() {
  describe('MaskLayerUtilsUT', () => {
    interface IsAppProtectedFuncInterFace {
      isAppProtectedFunc: (bundleName: string, options?: appLock.Options) => Promise<boolean>,
    }

    let utils: MaskLayerUtils;

    beforeEach(() => {
      utils = new MaskLayerUtils();
    });

    afterEach(() => {
    });

    it('MaskLayerUtils_getInstance_test01', 0, () => {
      const ins = MaskLayerUtils.getInstance();
      expect(ins).not().assertNull();
    })

    it('MaskLayerUtils_init_test01', 0, async () => {
      let mocker: MockKit = new MockKit();
      const mockFunc = mocker.mockFunc(userUtils, userUtils.getUserId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(105);
      const isAppProtectedFuncInterFace: IsAppProtectedFuncInterFace = {
        isAppProtectedFunc: appLock.isAppProtected,
      };
      const mockFunc2 = mocker.mockFunc(isAppProtectedFuncInterFace, isAppProtectedFuncInterFace.isAppProtectedFunc);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      await utils.init();
      const res = utils.getIsPickerMaskLayerShow();
      expect(res).assertEqual(false);
      mocker.ignoreMock(userUtils, userUtils.getUserId);
      mocker.ignoreMock(isAppProtectedFuncInterFace, isAppProtectedFuncInterFace.isAppProtectedFunc);
    })


    it('MaskLayerUtils_setPickerProtectedState_test01', 0, async () => {
      let mocker: MockKit = new MockKit();
      const mockFunc = mocker.mockFunc(userUtils, userUtils.getUserId);
      when(mockFunc)().afterReturn(102);
      const localStorage = new LocalStorage();
      const params = new SelectParams();
      params.bundleName = 'com.xxx.test';
      params.appCloneIndex = 0;
      localStorage.setOrCreate(Constants.PHOTO_PICKER_PARAMS_KEY, params);
      const res = await utils.setPickerProtectedState(localStorage, false);
      expect(res !== null).assertTrue()
      localStorage.delete(Constants.PHOTO_PICKER_PARAMS_KEY);
      localStorage.clear();
    })
  })
}