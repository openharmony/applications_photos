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
import { NormalAlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/NormalAlbumDataImpl';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum, PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';
import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import type { QueryAlbumParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

const TAG = 'NormalAlbumDataImplTest';

/**
 * NormalAlbumDataImpl Unittest
 *
 * @since 2024-07-26
 */
export default function NormalAlbumDataImplTest() {
  describe('NormalAlbumDataImplTest', () => {

    it('NormalAlbumDataImplTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await NormalAlbumDataImplTest01();
    });
  })
}


/**
 * buildAlbumsInfo
 */
async function NormalAlbumDataImplTest01() {
  let impl = new NormalAlbumDataImpl();
  let callback: AsyncCallback = {
    callback: () => {}
  };
  let param: QueryAlbumParam = {};

  impl.getData(callback, param);

  expect(impl !== undefined).assertTrue();
}