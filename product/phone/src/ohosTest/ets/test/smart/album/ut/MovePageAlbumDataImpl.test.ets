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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { MovePageAlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/MovePageAlbumDataImpl';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import type { QueryAlbumParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';

const TAG = 'MovePageAlbumDataImplTest';

/**
 * MovePageAlbumDataImpl Unittest
 *
 * @since 2024-07-26
 */
export default function MovePageAlbumDataImplTest() {
  describe('MovePageAlbumDataImplTest', () => {

    it('MovePageAlbumDataImplTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataImplTest01();
    });
  })
}


async function MovePageAlbumDataImplTest01() {
  let impl = new MovePageAlbumDataImpl();
  let param: QueryAlbumParam = {};
  await impl.getMovePageAlbumCount(param);

  expect(impl !== undefined).assertTrue();
}