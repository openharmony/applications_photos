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
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { SpliceMenuOperation } from '../../../../main/ets/MovingPhotoExtension/SpliceMenuOperation';


let spliceMenuOperation: SpliceMenuOperation | undefined = undefined;

export default function SpliceMenuOperationTest() {
  describe('SpliceMenuOperationTest', () => {

    beforeEach(() => {
      spliceMenuOperation = new SpliceMenuOperation(new MenuContext());
    });

    afterEach(() => {
      spliceMenuOperation = undefined;
    });
    it('setAlbumInfo', 0, () => {
      setAlbumInfo();
    });
    it('setIsFromSearch', 0, () => {
      setIsFromSearch();
    });
    it('doAction', 0, () => {
      doAction();
    });
  })
}


function setAlbumInfo() {
  if (spliceMenuOperation == undefined) {
    return;
  }
  let albumInfo: AlbumInfo = new AlbumInfo();
  spliceMenuOperation.setAlbumInfo(albumInfo, 'test');
  expect((spliceMenuOperation as ESObject).albumInfo).assertDeepEquals(albumInfo);
}

function setIsFromSearch() {
  if (spliceMenuOperation == undefined) {
    return;
  }
  spliceMenuOperation.setIsFromSearch(true);
  expect((spliceMenuOperation as ESObject).isFromSearch).assertTrue();
}

function doAction() {
  if (spliceMenuOperation == undefined) {
    return;
  }
  spliceMenuOperation.doAction();
  (spliceMenuOperation as ESObject).menuContext = null;
  spliceMenuOperation.doAction();
}

