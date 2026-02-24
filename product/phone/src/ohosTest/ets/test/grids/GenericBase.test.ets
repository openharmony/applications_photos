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
import { describe,  it, expect } from '@ohos/hypium';
import { GenericBase } from '@ohos/common/src/main/ets/default/utils/GenericBase';

export default function GenericBaseTest() {
  describe('GenericBaseTest', () => {

    class MyGeneric extends GenericBase<string> {}

    //异常set\get
    it('set_when_undefined', 0, () => {
      let myGeneric: MyGeneric = new MyGeneric();
      let key = 'key';
      let val = undefined;
      myGeneric.set(key, val);
      expect(myGeneric.get(key)).assertEqual(val);
    });

    //正常set\get
    it('set_when_not_undefined', 0, () => {
      let myGeneric: MyGeneric = new MyGeneric();
      let key = 'key';
      let val = 'aaTest';
      myGeneric.set(key, val);
      expect(myGeneric.get(key)).assertEqual(val);
    });

    //测试delete
    it('delete_test', 0, () => {
      let myGeneric: MyGeneric = new MyGeneric();
      let key = 'key';
      let val = 'aaTest';
      myGeneric.set(key, val);
      expect(myGeneric.get(key)).assertEqual(val);
      myGeneric.delete(key);
      expect(myGeneric.get(key)).assertUndefined();
    });

  });
}