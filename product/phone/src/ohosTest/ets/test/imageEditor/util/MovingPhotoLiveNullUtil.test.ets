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
import { it, describe, expect } from '@ohos/hypium';
import { NullUtil } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/NullUtil'

export default function MovingPhotoLiveNullUtilTest() {
  describe('MovingPhotoLiveNullUtilTest',() => {
    it('MovingPhotoLiveNullUtilTest_isObjNull_001', 0, () => {
      // 输入资源未被定义
      const input = undefined;
      const result = NullUtil.isObjNull(input);
      expect(result).assertEqual(true);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_002', 0, () => {
      // 输入资源为字符串
      const input = 'asd';
      const result = NullUtil.isObjNull(input);
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_003', 0, () => {
      // 输入资源未被定义
      const input: string | undefined | null = undefined;
      const result = NullUtil.isStrNull(input);
      // 预期结果为 true，因为输入是 undefined
      expect(result).assertEqual(true);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_004', 0, () => {
      const input: string | undefined | null = null;
      const result = NullUtil.isStrNull(input);
      // 预期结果为 true，因为输入是 null
      expect(result).assertEqual(true);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_005', 0, () => {
      const input: string | undefined | null = '';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 true，因为输入是空字符串
      expect(result).assertEqual(true);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_006', 0, () => {
      const input: string | undefined | null = 'Hello, World!';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_007', 0, () => {
      // 测试资源是个字母
      const input: string | undefined | null = 'H';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_008', 0, () => {
      // 测试资源是个句子
      const input: string | undefined | null =
        'During the execution of test cases on the mobile phone, ' +
          'an error occurred due to the screen being locked, but it worked normally after unlocking. ';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_009', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '!';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_010', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '@';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_011', 0, () => {
      // 输入资源为空
      const input = null;
      const result = NullUtil.isObjNull(input);
      expect(result).assertEqual(true);
    });


    it('MovingPhotoLiveNullUtilTest_isObjNull_012', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '#';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_013', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '$';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_014', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '%';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_015', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '^';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_016', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '&';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_017', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '*';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_018', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '(';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_019', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ')';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_020', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '-';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_021', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '_';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_022', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '=';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_023', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '+';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_024', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '[';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_025', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ']';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_026', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '}';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_027', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '{';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_028', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '|';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_029', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ';';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_030', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ':';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_031', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ',';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_032', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '<';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_033', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '>';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_034', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '.';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_035', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '?';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_036', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ' ';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_037', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = ' 1';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });

    it('MovingPhotoLiveNullUtilTest_isObjNull_038', 0, () => {
      // 测试资源是个特殊字符
      const input: string | undefined | null = '@Component';
      const result = NullUtil.isStrNull(input);
      // 预期结果为 false，因为输入是非空字符串
      expect(result).assertEqual(false);
    });
  });
}
