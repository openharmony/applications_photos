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
import { MediaItemUtil } from '@ohos/common/src/main/ets/default/utils/MediaItemUtil';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'MediaItemUtilTest';
const NUMBER_ONE: number = 1;

export default function MediaItemUtilTest() {
  describe('MediaItemUtilTest', () => {

    it('MediaItemUtilTest_deletePickPhoto', 0, () => {
      let str1: string = 'aaa';
      let str2: string = 'bbb';
      MediaItemUtil.deletePickPhoto(str1, str2);
      expect(NUMBER_ONE).assertEqual(1);
      Log.info(TAG, "deletePickPhoto_ok");
    })

    it('MediaItemUtilTest_deleteAllPickPhoto', 0, () => {
      let arr1: string[] = ['aaa', 'bbb'];
      let str2: string = 'ccc';
      MediaItemUtil.deleteAllPickPhoto(arr1, str2);
      expect(NUMBER_ONE).assertEqual(1);
      Log.info(TAG, "deleteAllPickPhoto_ok");
    })

    it('MediaItemUtilTest_createFileAndGrant', 0, () => {
      let str1: string = 'aaa';
      let str2: string = 'bbb';
      let str3: string = 'ccc';
      let index: number = 0;

      interface ErrorInfo {
        code: number;
        message: string;
        name: string;
      }

      const mockCallback = (a: ErrorInfo, b: string) => {
        expect(typeof a.code).assertEqual('number');
        expect(typeof a.message).assertEqual('string');
        expect(typeof b).assertEqual('string');
        Log.info(TAG, "okk");
      };
      MediaItemUtil.createFileAndGrant(str1, str2, str3, index, mockCallback);
      Log.info(TAG, "createFileAndGrant_ok");
    })

    it('MediaItemUtilTest_getFileName_true', 0, () => {
      let str1: string = 'aaa';
      let str2: string = 'xxx';
      let ret = MediaItemUtil.getFileName(str1, str2);
      expect(ret).assertEqual('xxx/47BCE5C74F589F4867DBD57E9CA9F808');
      Log.info(TAG, `ret:${ret}`);
    })

    it('MediaItemUtilTest_getFileName_false', 0, () => {
      let str1: string = 'aaa.bbb.ccc';
      let str2: string = 'xxx';
      let ret = MediaItemUtil.getFileName(str1, str2);
      expect(ret).assertEqual('xxx/B6ECAACA926C959F4546C79DF437B503.ccc');
      Log.info(TAG, `ret:${ret}`);
    })

    it('MediaItemUtilTest_getSaveFileName', 0, () => {
      let str1: string = 'aaa';
      let str2: string = 'xxx';
      let ret = MediaItemUtil.getSaveFileName(str1, str2);
      expect(ret).assertEqual('file://com.ohos.photos/xxx/47BCE5C74F589F4867DBD57E9CA9F808');
      Log.info(TAG, `ret:${ret}`);
    })

    it('MediaItemUtilTest_parsePixelMapSync', 0, () => {
      let str1: string = 'aaa';
      let res = MediaItemUtil.parsePixelMapSync(str1);
      expect(res).assertEqual(undefined);
    })

    it('MediaItemUtilTest_parseUri', 0, async () => {
      let str1: string = 'aaa';
      let res = await MediaItemUtil.parseUri(str1);
      expect(res.uri.length).assertEqual(0);
      Log.info(TAG, "parseUri_ok");
    })

    it('MediaItemUtilTest_parseVideoPixelMap', 0, () => {
      let str1: string = 'aaa';
      let res = MediaItemUtil.parseVideoPixelMap(str1);
      expect(res != undefined).assertEqual(true);
      Log.info(TAG, "parseVideoPixelMap_ok");
    })

  })
}