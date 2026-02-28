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
import { describe, expect, it } from '@ohos/hypium';
import { GroupFeature } from '@ohos/common/src/main/ets/default/utils/GroupFeature';

export default function GroupFeatureTest() {
  describe('GroupFeatureTest', () => {

    // 测试getInstance 异常代码 需重构
    it('should_return_new_Instance', 0, () => {
      let res: GroupFeature = GroupFeature.getInstance();
      expect(res!==undefined).assertTrue();
    });

    // 测试getInstance 异常代码 需重构
    it('should_return_old_Instance', 0, () => {
      let res1: GroupFeature = GroupFeature.getInstance();
      Reflect.set(GroupFeature,'instance',res1);
      let res2: GroupFeature = GroupFeature.getInstance();
      expect(res2 !== undefined).assertTrue();
    });

    //测试isSupported
    it('should_return_false_when_isDeviceSupported_returns_false', 0, async () => {
      let groupFeature: GroupFeature = GroupFeature.getInstance();
      const result = groupFeature.isSupported();
      expect(result !== undefined).assertTrue();
    });

    //测试IsDeviceSupported
    it('IsDeviceSupportedTest', 0, async () => {
      const result = GroupFeature.getInstance().isDeviceSupported();
      expect(result !== undefined).assertTrue();
    });

    //测试isInvalid
    it('isInvalidTest', 0, async () => {
      let str = 'valid';
      const result = GroupFeature.isInvalid(str);
      expect(result).assertFalse();
    });

    //测试getAnonymizeAlbumName
    it('getAnonymizeAlbumNameTest',0,() => {
      const result = GroupFeature.getAnonymizeAlbumName('valid');
      expect(result).not().assertNull();
    });

    //测试getAnonymizeString
    it('getAnonymizeString_3',0,() => {
      let str = 'abc'
      let strLength = str.length;
      const result = GroupFeature.getAnonymizeString(str);
      expect(result).assertEqual('****' + str.substring(strLength - 1) + '****');
    });
    it('getAnonymizeString_4',0,() => {
      const ANONYMIZATION_LEFT_LENGTH: number = 2;
      let str = 'abcd'
      let strLength = str.length;
      const result = GroupFeature.getAnonymizeString(str);
      expect(result).assertEqual('***' + str.substring(strLength - ANONYMIZATION_LEFT_LENGTH) + '***');
    });
    it('getAnonymizeString_8',0,() => {
      const ANONYMIZATION_MAX_LENGTH: number = 8;
      let str = 'abcdefghigklm'
      const result = GroupFeature.getAnonymizeString(str);
      expect(result).assertEqual('**' + str.substring(ANONYMIZATION_MAX_LENGTH) + '**');
    });

    //测试checkNameInvalid
    it('checkNameInvalid',0,() => {
      let str = 'abcdefghigklm'
      const result = GroupFeature.checkNameInvalid(str);
      expect(result!=undefined).assertTrue();
    });
  });

}