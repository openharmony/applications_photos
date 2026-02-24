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
import { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';

export default function BrowserStringUtilTest() {
  describe('BrowserStringUtilTest', () => {

    it('BrowserStringUtilTest_formatString_with_empty_string1', 0, () => {
      const emptyString = StringUtil.formatString('');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string2', 0, () => {
      const emptyString = StringUtil.formatString('', '11');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string3', 0, () => {
      const emptyString = StringUtil.formatString('', '11', '22');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string4', 0, () => {
      const emptyString = StringUtil.formatString('', '', '');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string5', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '11');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string6', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '11', '22');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string7', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '11', '22', '33');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string8', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '11', '22', '33', '44');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string9', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '11', '22', '33', '44', '55');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatString_with_empty_string10', 0, () => {
      const emptyString = StringUtil.formatString('', '', '', '', '');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string1', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string2', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '', '');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string3', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string4', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '2');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string5', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '3');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string6', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1', '2');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string7', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1', '2', '3');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string8', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1111111');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string9', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '3');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string10', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1', '2');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string11', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1', '2', '3');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string12', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1111111');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string13', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '111', '2222');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string14', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '11', '22', '33');
      expect(emptyString).assertEqual('');
    });

    it('BrowserStringUtilTest_formatStringForNumber_with_empty_string15', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('', '1111111', '111111');
      expect(emptyString).assertEqual('');
    });

    it('when_input_is_undefined_returns_true', 0, () => {
      const res = StringUtil.isInvalid(undefined);
      expect(res).assertEqual(true);
    });

    it('when_input_is_empty_string_returns_true', 0, () => {
      const res = StringUtil.isInvalid('');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false1', 0, () => {
      const res = StringUtil.isInvalid('aa');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false2', 0, () => {
      const res = StringUtil.isInvalid('aaa');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false3', 0, () => {
      const res = StringUtil.isInvalid('1');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false4', 0, () => {
      const res = StringUtil.isInvalid('1aa');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false5', 0, () => {
      const res = StringUtil.isInvalid('aa%');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false6', 0, () => {
      const res = StringUtil.isInvalid('a+a');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false7', 0, () => {
      const res = StringUtil.isInvalid('a1111a');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false8', 0, () => {
      const res = StringUtil.isInvalid('a~a');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false9', 0, () => {
      const res = StringUtil.isInvalid('bbbbb');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false10', 0, () => {
      const res = StringUtil.isInvalid('aa1111111111111111111111');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false11', 0, () => {
      const res = StringUtil.isInvalid('11');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false12', 0, () => {
      const res = StringUtil.isInvalid('aabbb');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false13', 0, () => {
      const res = StringUtil.isInvalid('aabsjkde');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false14', 0, () => {
      const res = StringUtil.isInvalid('ajokdeio');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false15', 0, () => {
      const res = StringUtil.isInvalid('dejlkj;');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_input_is_non_empty_string_returns_false16', 0, () => {
      const res = StringUtil.isInvalid('adejlaoi[;');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number1', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number2', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('1', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number3', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('~aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number4', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('^aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number5', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('*aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number6', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('(aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number7', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('~aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number8', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('!aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number9', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('@aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number10', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('#aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number11', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('$aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number12', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('%aaaa3', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number13', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('&1aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number14', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('^1aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number15', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('*1aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number16', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('!7aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number17', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('&6aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number18', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('deeaaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number19', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('ee', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_is_string_start_with_number20', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('11aaaa', '');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_first_arg_is_empty_string_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('', 'bbbb');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_first_arg_starts_with_number_and_second_arg_is_single_number_returns_false', 0,
      () => {
        const res = StringUtil.isStringStartsWithNumber('7bbbb', '7');
        expect(res).assertEqual(false);
      });

    it('BrowserStringUtilTest_when_first_arg_starts_with_number_and_second_arg_is_different_number_returns_false', 0,
      () => {
        const res = StringUtil.isStringStartsWithNumber('7bbbb', '8');
        expect(res).assertEqual(false);
      });

    it('BrowserStringUtilTest_when_first_arg_starts_with_second_arg_returns_true', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('bbbb89', 'bbbb8');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_first_arg_does_not_start_with_second_arg_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('7bbbb', 'bbbb');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_when_fourth_arg_equals_first_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('d', 'b', 'c', 'd');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_fourth_arg_equals_second_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'd', 'c', 'd');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_fourth_arg_equals_third_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'd', 'd');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_fourth_arg_equals_third_arg_with_file_path_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('da', 'b', 'file://media/Photo/da', 'file://media/Photo/da');
      expect(res).assertEqual(true);
    });

    it('BrowserStringUtilTest_when_fourth_arg_differs_from_third_arg_with_file_path_returns_false', 0, () => {
      const res = StringUtil.isSamePhotoAsset('aa', 'bd', 'file://media/Photo/aa', 'file://media/Photo/bd');
      expect(res).assertEqual(false);
    });

    it('BrowserStringUtilTest_garbleFileName_short_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('aab');
      expect(res).assertEqual('****b****');
    });

    it('BrowserStringUtilTest_garbleFileName_medium_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('abcde');
      expect(res).assertEqual('***de***');
    });

    it('BrowserStringUtilTest_garbleFileName_long_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('abcdefghij');
      expect(res).assertEqual('**ij**');
    });

    it('BrowserStringUtilTest_formatString', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '18', '');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old');
    });

    it('BrowserStringUtilTest_formatString1', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '18', '', '');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old');
    });

    it('BrowserStringUtilTest_formatString2', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '18');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old');
    });

    it('BrowserStringUtilTest_formatString3', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old,{3}', 'LiLei', '18', '22');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old,{3}');
    });

    it('BrowserStringUtilTest_formatString4', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'HanMeiMei', '18');
      expect(normalString).assertEqual('hello,I am HanMeiMei, 18 years old');
    });

    it('BrowserStringUtilTest_formatString5', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '');
      expect(normalString).assertEqual('hello,I am LiLei,  years old');
    });

    it('BrowserStringUtilTest_formatString6', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '20');
      expect(normalString).assertEqual('hello,I am LiLei, 20 years old');
    });

    it('BrowserStringUtilTest_formatString7', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '30');
      expect(normalString).assertEqual('hello,I am LiLei, 30 years old');
    });

    it('BrowserStringUtilTest_formatString8', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '40');
      expect(normalString).assertEqual('hello,I am LiLei, 40 years old');
    });

    it('BrowserStringUtilTest_formatString9', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '50');
      expect(normalString).assertEqual('hello,I am LiLei, 50 years old');
    });

    it('BrowserStringUtilTest_formatString10', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '60');
      expect(normalString).assertEqual('hello,I am LiLei, 60 years old');
    });

    it('BrowserStringUtilTest_formatString11', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old,{},{}', 'LiLei', '18', '1', '1');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old,{},{}');
    });

    it('BrowserStringUtilTest_formatString12', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old,{2},{3}', 'LiLei', '18', '1', '1');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old,1,1');
    });

    it('BrowserStringUtilTest_formatString13', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old,{2}', 'LiLei', '18', '22','2');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old,22');
    });
  })
}