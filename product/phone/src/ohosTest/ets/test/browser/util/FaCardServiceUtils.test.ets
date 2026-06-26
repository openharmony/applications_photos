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
import { afterEach, beforeEach, describe, expect, it, MockKit } from '@ohos/hypium';

import FaCardService from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import { ValuesBucket } from '@kit.ArkData';

const TAG: string = `FaCardServiceUtilsTest `;

export default function FaCardServiceUT() {
  describe('FaCardServiceUtilsUT', () => {
    let faCardAlbum: FaCardService;
    let mocker: MockKit

    beforeEach(() => {
      faCardAlbum = new FaCardService({} as Context)
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('insert_case1', 0, () => {
      const res = faCardAlbum.insert('', 1, 1, '', '');
      expect(res !== null).assertTrue()
    });

    it('update_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      const res = faCardAlbum.update('', bucket);
      expect(res !== null).assertTrue()
    });

    it('queryAllForm_case1', 0, () => {
      const res = faCardAlbum.queryAllForm();
      expect(res !== null).assertTrue()
    });

    it('queryByFormId_case1', 0, () => {
      const res = faCardAlbum.queryByFormId('');
      expect(res !== null).assertTrue()
    });

    it('queryFaCardsByAlbumUri_case1', 0, () => {
      const res = faCardAlbum.queryFaCardsByAlbumUri('');
      expect(res !== null).assertTrue()
    });

    it('queryFaCard_case1', 0, () => {
      const res = faCardAlbum.queryFaCard('');
      expect(res !== null).assertTrue()
    });

    it('queryInterval_case1', 0, () => {
      const res = faCardAlbum.queryInterval('');
      expect(res !== null).assertTrue()
    });

    it('queryInterval_case2', 0, () => {
      Reflect.set(faCardAlbum, 'context', undefined);
      const res = faCardAlbum.queryInterval('');
      expect(res !== null).assertTrue()
    });
  })
}
