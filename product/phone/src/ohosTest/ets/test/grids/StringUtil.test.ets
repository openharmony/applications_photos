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
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import { MediaLibraryData } from '@ohos/common/src/main/ets/default/model/browser/photo/data/MediaData';
import { MediaQuery } from '@kit.ArkUI';

export default function StringUtilTest() {
  describe('StringUtilTest', () => {
    const INDEX_INVALID: number = -1;

    it('formatString_with_empty_string_returns_empty_string', 0, () => {
      const emptyString = StringUtil.formatString('');
      expect(emptyString).assertEqual('');
    });

    it('formatStringForNumber_with_empty_string_returns_empty_string', 0, () => {
      const emptyString = StringUtil.formatStringForNumber('');
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

    it('when_input_is_non_empty_string_returns_false', 0, () => {
      const res = StringUtil.isInvalid('aa');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false1', 0, () => {
      const res = StringUtil.isInvalid('bb');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false2', 0, () => {
      const res = StringUtil.isInvalid('cc');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false3', 0, () => {
      const res = StringUtil.isInvalid('dd');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false4', 0, () => {
      const res = StringUtil.isInvalid('ee');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false5', 0, () => {
      const res = StringUtil.isInvalid('ff');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false6', 0, () => {
      const res = StringUtil.isInvalid('jj');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false7', 0, () => {
      const res = StringUtil.isInvalid('kk');
      expect(res).assertEqual(false);
    });

    it('when_input_is_non_empty_string_returns_false8', 0, () => {
      const res = StringUtil.isInvalid('ll');
      expect(res).assertEqual(false);
    });

    it('empty_string_returns_empty_string', 0, () => {
      const res = StringUtil.getAnonymizeString('');
      expect(res).assertEqual('');
    });

    it('short_string_returns_masked_string', 0, () => {
      const res = StringUtil.getAnonymizeString('ab');
      expect(res).assertEqual('****b****');
    });

    it('medium_string_returns_masked_string', 0, () => {
      const res = StringUtil.getAnonymizeString('abcde');
      expect(res).assertEqual('***de***');
    });

    it('long_string_returns_masked_string', 0, () => {
      const res = StringUtil.getAnonymizeString('abcdefghi');
      expect(res).assertEqual('***hi***');
    });

    it('peopleNamesReplacer_with_names_returns_asterisks', 0, () => {
      const str = new String('str');
      const res = StringUtil.peopleNamesReplacer('names', str);
      expect(res).assertEqual('***');
    });

    it('peopleNamesReplacer_without_names_returns_original_string', 0, () => {
      const str = new String('str');
      const res = StringUtil.peopleNamesReplacer('str', str);
      expect(res).assertEqual(str);
    });

    it('when_second_arg_is_empty_string_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('aaaa', '');
      expect(res).assertEqual(false);
    });

    it('when_first_arg_is_empty_string_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('', 'aaaa');
      expect(res).assertEqual(false);
    });

    it('when_first_arg_starts_with_number_and_second_arg_is_single_number_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('7aaaa', '7');
      expect(res).assertEqual(false);
    });

    it('when_first_arg_starts_with_number_and_second_arg_is_different_number_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('7aaaa', '8');
      expect(res).assertEqual(false);
    });

    it('when_first_arg_starts_with_second_arg_returns_true', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('aaaa89', 'aaaa8');
      expect(res).assertEqual(true);
    });

    it('when_first_arg_does_not_start_with_second_arg_returns_false', 0, () => {
      const res = StringUtil.isStringStartsWithNumber('7aaaa', 'aaaa');
      expect(res).assertEqual(false);
    });

    it('when_fourth_arg_equals_first_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'c', 'a');
      expect(res).assertEqual(true);
    });

    it('when_fourth_arg_equals_second_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'c', 'b');
      expect(res).assertEqual(true);
    });

    it('when_fourth_arg_equals_third_arg_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'c', 'c');
      expect(res).assertEqual(true);
    });

    it('when_fourth_arg_equals_third_arg_with_file_path_returns_true', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'file://media/Photo/a', 'file://media/Photo/a');
      expect(res).assertEqual(true);
    });

    it('when_fourth_arg_differs_from_third_arg_with_file_path_returns_false', 0, () => {
      const res = StringUtil.isSamePhotoAsset('a', 'b', 'file://media/Photo/a', 'file://media/Photo/b');
      expect(res).assertEqual(false);
    });

    it('garbleFileName_empty_string_returns_empty_string', 0, () => {
      const res = StringUtil.garbleFileName('');
      expect(res).assertEqual('');
    });

    it('garbleFileName_short_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('ab');
      expect(res).assertEqual('****b****');
    });

    it('garbleFileName_short_string_returns_masked_string1', 0, () => {
      const res = StringUtil.garbleFileName('ac');
      expect(res).assertEqual('****c****');
    });

    it('garbleFileName_short_string_returns_masked_string2', 0, () => {
      const res = StringUtil.garbleFileName('ad');
      expect(res).assertEqual('****d****');
    });

    it('garbleFileName_short_string_returns_masked_string3', 0, () => {
      const res = StringUtil.garbleFileName('ae');
      expect(res).assertEqual('****e****');
    });

    it('garbleFileName_short_string_returns_masked_string4', 0, () => {
      const res = StringUtil.garbleFileName('af');
      expect(res).assertEqual('****f****');
    });

    it('garbleFileName_short_string_returns_masked_string5', 0, () => {
      const res = StringUtil.garbleFileName('ag');
      expect(res).assertEqual('****g****');
    });

    it('garbleFileName_short_string_returns_masked_string6', 0, () => {
      const res = StringUtil.garbleFileName('am');
      expect(res).assertEqual('****m****');
    });

    it('garbleFileName_short_string_returns_masked_string7', 0, () => {
      const res = StringUtil.garbleFileName('an');
      expect(res).assertEqual('****n****');
    });

    it('garbleFileName_medium_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('abcde');
      expect(res).assertEqual('***de***');
    });

    it('garbleFileName_medium_string_returns_masked_string1', 0, () => {
      const res = StringUtil.garbleFileName('abcdf');
      expect(res).assertEqual('***df***');
    });

    it('garbleFileName_medium_string_returns_masked_string2', 0, () => {
      const res = StringUtil.garbleFileName('abcdm');
      expect(res).assertEqual('***dm***');
    });

    it('garbleFileName_medium_string_returns_masked_string3', 0, () => {
      const res = StringUtil.garbleFileName('abcdn');
      expect(res).assertEqual('***dn***');
    });

    it('garbleFileName_medium_string_returns_masked_string4', 0, () => {
      const res = StringUtil.garbleFileName('abcdq');
      expect(res).assertEqual('***dq***');
    });

    it('garbleFileName_medium_string_returns_masked_string5', 0, () => {
      const res = StringUtil.garbleFileName('abcdw');
      expect(res).assertEqual('***dw***');
    });

    it('garbleFileName_medium_string_returns_masked_string6', 0, () => {
      const res = StringUtil.garbleFileName('abcdr');
      expect(res).assertEqual('***dr***');
    });

    it('garbleFileName_long_string_returns_masked_string', 0, () => {
      const res = StringUtil.garbleFileName('abcdefghij');
      expect(res).assertEqual('**ij**');
    });

    it('garbleFileName_screenshot_string_returns_original_string', 0, () => {
      const res = StringUtil.garbleFileName('screenshot_0');
      expect(res).assertEqual('screenshot_0');
    });

    it('garbleFileName_IMG_string_returns_original_string', 0, () => {
      const res = StringUtil.garbleFileName('IMG_0');
      expect(res).assertEqual('IMG_0');
    });

    it('garbleFileName_VID_string_returns_original_string', 0, () => {
      const res = StringUtil.garbleFileName('VID_0');
      expect(res).assertEqual('VID_0');
    });

    it('garbleFileName_SVID_string_returns_original_string', 0, () => {
      const res = StringUtil.garbleFileName('SVID_0');
      expect(res).assertEqual('SVID_0');
    });

    it('StringUtilTest_formatString', 0, () => {
      let normalString = StringUtil.formatString('hello,I am {0}, {1} years old', 'LiLei', '18');
      expect(normalString).assertEqual('hello,I am LiLei, 18 years old');
    })

    it('StringUtilTest_formatPercentForNumber', 0, () => {
      let percent = StringUtil.formatPercentForNumber(15 / 100, 'percent');
      expect(percent).assertEqual('15%');
    })

    it('StringUtilTest_formatStringForNumber', 0, () => {
      let res = StringUtil.formatStringForNumber('%d people', '18');
      expect(res).assertEqual('18 people');
    })

    it('StringUtilTest_connectString', 0, () => {
      let emptyString = StringUtil.connectString(['aa', 'bb'], '');
      expect(emptyString).assertEqual('aabb');
      let res = StringUtil.connectString(['aa', 'bb'], '>');
      expect(res).assertEqual('aa>bb');
    })

    it('StringUtilTest_getIdFromUri', 0, () => {
      let id = StringUtil.getIdFromUri('');
      expect(id).assertEqual(15);
    })

    it('StringUtilTest_arraybufferSerialize_arraybufferDeserialize', 0, () => {
      let arrayBuffer = StringUtil.arraybufferDeserialize('');
      let expectStr = StringUtil.arraybufferSerialize(arrayBuffer);
      expect(expectStr).assertEqual('');
    })

    it('StringUtilTest_checkNameInvalid', 0, () => {
      let normal = StringUtil.checkNameInvalid('图库用户小张');
      let other = StringUtil.checkNameInvalid('。.*');
      expect(normal).assertEqual(false);
      expect(other).assertEqual(true);
    })

    it('StringUtilTest_size', 0, () => {
      let normal = StringUtil.size('12345');
      let other = StringUtil.size('');
      expect(normal).assertEqual(5);
      expect(other).assertEqual(0);
    })

    it('uri_starts_with_MEDIA_URL_PREFIX_STR_returns_true', 0, () => {
      const testRes = MediaLibraryData.isMediaLibraryUri(`${PhotoDataSource.MEDIA_URL_PREFIX_STR}normal`);
      expect(testRes).assertEqual(true);
    });

    it('uri_starts_with_IMAGE_URL_PREFIX_STR_V10_returns_true', 0, () => {
      const testRes = MediaLibraryData.isMediaLibraryUri(`${PhotoDataSource.IMAGE_URL_PREFIX_STR_V10}normal`);
      expect(testRes).assertEqual(true);
    });

    it('uri_starts_with_VIDEO_URL_PREFIX_STR_V10_returns_true', 0, () => {
      const testRes = MediaLibraryData.isMediaLibraryUri(`${PhotoDataSource.VIDEO_URL_PREFIX_STR_V10}normal`);
      expect(testRes).assertEqual(true);
    });

    it('uri_starts_with_IMAGE_VIDEO_URL_PREFIX_STR_V10_returns_true', 0, () => {
      const testRes = MediaLibraryData.isMediaLibraryUri(`${PhotoDataSource.IMAGE_VIDEO_URL_PREFIX_STR_V10}normal`);
      expect(testRes).assertEqual(true);
    });

    it('uri_does_not_start_with_any_media_library_prefix_returns_false', 0, () => {
      const testRes = MediaLibraryData.isMediaLibraryUri('normal');
      expect(testRes).assertEqual(false);
    });

    it('textContextInfoReplacer_return_value', 0, () => {
      const testRes = StringUtil.textContextInfoReplacer<number>('normal', 1);
      expect(testRes).assertEqual(1);
    });

    it('textContextInfoReplacer_return_string', 0, () => {
      const testRes = StringUtil.textContextInfoReplacer<object>('textContextInfo', new MediaQuery());
      expect(testRes).assertEqual('***');
    });

    it('generateDisplayName_return_originalDisplayName', 0, () => {
      const testRes = StringUtil.generateDisplayName('normal', 'title');
      expect(testRes).assertEqual('normal');
    });

    it('generateDisplayName_return_title_plus_suffix', 0, () => {
      const testRes = StringUtil.generateDisplayName('normal.', 'title');
      expect(testRes).assertEqual('title' + 'normal.'.slice('normal.'.lastIndexOf('.')));
    });
  })
}