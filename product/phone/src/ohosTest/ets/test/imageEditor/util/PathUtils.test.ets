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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { PathUtils } from '@oh-image-editor/editor-common/src/main/ets/common/util/PathUtils';

export default function PathUtilsTest() {
  describe('PathUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * @tc.name: PathUtils_extractFileSuffix_001
     * @tc.desc: Verify correct extraction of simple file extension
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_001', 0, () => {
      const result = PathUtils.extractFileSuffix('file.txt');
      expect(result).assertEqual('txt');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_002
     * @tc.desc: Verify correct handling of uppercase extensions
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_002', 0, () => {
      const result = PathUtils.extractFileSuffix('IMAGE.PNG');
      expect(result).assertEqual('png');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_003
     * @tc.desc: Verify removal of leading/trailing spaces in path
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_003', 0, () => {
      const result = PathUtils.extractFileSuffix('  file . mp4  ');
      expect(result).assertEqual('mp4');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_004
     * @tc.desc: Verify correct extraction when query parameters are present
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_004', 0, () => {
      const result = PathUtils.extractFileSuffix('video.mp4?token=abc');
      expect(result).assertEqual('mp4');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_005
     * @tc.desc: Verify correct extraction when hash fragment is present
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_005', 0, () => {
      const result = PathUtils.extractFileSuffix('page.html#section1');
      expect(result).assertEqual('html');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_006
     * @tc.desc: Verify correct extraction with both query and hash
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_006', 0, () => {
      const result = PathUtils.extractFileSuffix('file.zip?ref=123#download');
      expect(result).assertEqual('zip');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_007
     * @tc.desc: Verify empty string returns empty result
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_007', 0, () => {
      const result = PathUtils.extractFileSuffix('');
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_008
     * @tc.desc: Verify undefined input returns empty result
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_008', 0, () => {
      const result = PathUtils.extractFileSuffix();
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_009
     * @tc.desc: Verify whitespace-only input returns empty result
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_009', 0, () => {
      const result = PathUtils.extractFileSuffix('   ');
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_010
     * @tc.desc: Verify no extension (e.g., just filename) returns empty result
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_010', 0, () => {
      const result = PathUtils.extractFileSuffix('document');
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_011
     * @tc.desc: Verify single dot at end returns empty result
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_011', 0, () => {
      const result = PathUtils.extractFileSuffix('file.');
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_012
     * @tc.desc: Verify multiple dots (e.g., .gitignore)
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_012', 0, () => {
      const result = PathUtils.extractFileSuffix('.gitignore');
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_013
     * @tc.desc: Verify relative path with extension returns correct suffix
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_013', 0, () => {
      const result = PathUtils.extractFileSuffix('./image.png');
      expect(result).assertEqual('png');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_014
     * @tc.desc: Verify absolute path with extension returns correct suffix
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_014', 0, () => {
      const result = PathUtils.extractFileSuffix('/assets/style.css');
      expect(result).assertEqual('css');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_015
     * @tc.desc: Verify whitelist filter works: matched extension
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_015', 0, () => {
      const result = PathUtils.extractFileSuffix('video.avi', ['mp4', 'avi']);
      expect(result).assertEqual('avi');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_016
     * @tc.desc: Verify whitelist filter works: unmatched extension
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_016', 0, () => {
      const result = PathUtils.extractFileSuffix('video.mov', ['mp4', 'avi']);
      expect(result).assertEqual('');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_017
     * @tc.desc: Verify whitelist is ignored when empty array provided
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_017', 0, () => {
      const result = PathUtils.extractFileSuffix('file.docx', []);
      expect(result).assertEqual('docx');
    });

    /**
     * @tc.name: PathUtils_extractFileSuffix_018
     * @tc.desc: Verify whitelist is ignored when undefined
     * @tc.type: FUNC
     * @tc.require:
     */
    it('PathUtils_extractFileSuffix_018', 0, () => {
      const result = PathUtils.extractFileSuffix('file.pdf', undefined);
      expect(result).assertEqual('pdf');
    });
  })
}