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
import { describe, it, expect, } from '@ohos/hypium';
import { JsonUtil } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/JsonUtil';

export default function JsonUtilTest() {
  describe('getValueFromJson_testSuite', () => {

    it('atc_should_return_undefined_when_jsonString_is_invalid', 0, () => {
      const jsonString: ESObject = 'invalid json string';
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_path_is_empty', 0, () => {
      const jsonString: ESObject = '{"key1": "value1", "key2": "value2"}';
      const path: ESObject = '';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_path_is_invalid', 0, () => {
      const jsonString: ESObject = '{"key1": "value1", "key2": "value2"}';
      const path: ESObject = 'key3.key4';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_value_when_path_is_valid', 0, () => {
      const jsonString: ESObject = '{"key1": {"key2": "value1", "key3": "value2"}, "key4": "value3"}';
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertEqual('value1');
    });

    it('atc_should_return_undefined_when_path_leads_to_null', 0, () => {
      const jsonString: ESObject = '{"key1": null, "key2": "value2"}';
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_path_leads_to_undefined', 0, () => {
      const jsonString: ESObject = '{"key1": undefined, "key2": "value2"}';
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_path_leads_to_non_object', 0, () => {
      const jsonString: ESObject = '{"key1": "value1", "key2": "value2"}';
      const path: ESObject = 'key1';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertEqual('value1');
    });

    it('atc_should_return_undefined_when_path_leads_to_non_existent_property', 0, () => {
      const jsonString: ESObject = '{"key1": {"key2": "value1", "key3": "value2"}, "key4": "value3"}';
      const path: ESObject = 'key1.key4';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_jsonString_is_empty', 0, () => {
      const jsonString: ESObject = '';
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_jsonString_is_null', 0, () => {
      const jsonString: ESObject = null;
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });

    it('atc_should_return_undefined_when_jsonString_is_undefined', 0, () => {
      const jsonString: ESObject = undefined;
      const path: ESObject = 'key1.key2';
      const result: ESObject = JsonUtil.getValueFromJson(jsonString, path);
      expect(result).assertUndefined();
    });
  });
}