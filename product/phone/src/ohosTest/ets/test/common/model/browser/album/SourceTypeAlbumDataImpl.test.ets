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

import type {
  PhotoAlbum
} from '../../../../../../../../../../common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { SourceTypeAlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/SourceTypeAlbumDataImpl';
import { describe, expect, it } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function SourceTypeAlbumDataImplTest(): void {
  describe('SourceTypeAlbumDataImplTest', () => {
    let sourceAlbumUri: string = '/DCIM/Camera';
    let sourceAlbumUri1: string = '';

    it('sourceTypeAlbumDataImplTest01', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbums(undefined, undefined, undefined);
    })

    it('sourceTypeAlbumDataImplTest02', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbums(undefined, undefined, sourceAlbumUri);
    })

    it('sourceTypeAlbumDataImplTest03', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbums(undefined, undefined, sourceAlbumUri1);
    })

    it('sourceTypeAlbumDataImplTest04', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbumsWithFilter(undefined, undefined, undefined);
    })

    it('sourceTypeAlbumDataImplTest05', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbumsWithFilter(undefined, undefined, sourceAlbumUri);
    })

    it('sourceTypeAlbumDataImplTest06', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      sourceTypeAlbumDataImpl.buildSourceAlbumsWithFilter(undefined, undefined, sourceAlbumUri1);
    })

    it('sourceTypeAlbumDataImplTest07', TestConstants.TEST_LEVEL_ONE, async () => {
      const context = getContext();
      expect(context !== undefined).assertTrue();
      let sourceTypeAlbumDataImpl = new SourceTypeAlbumDataImpl(context);
      let newList: PhotoAlbum[] = [];
      let unionAlbumList: PhotoAlbum[][] = [];
      sourceTypeAlbumDataImpl.getSourceObject(context, newList, unionAlbumList, undefined);

    })
  })
}

