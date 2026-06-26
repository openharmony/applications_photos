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

import {
  CategoryAlbumSetDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/CategoryAlbumSetDataSource';
import { beforeEach, describe, it } from '@ohos/hypium';
import { BroadCast } from '../../../../../../../../../../common/src/main/ets/default/utils/BroadCast';
import {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';


export default function CategoryAlbumSetDataSourceTest(): void {
  describe('CategoryAlbumSetDataSourceTest', () => {
    let dataSource: CategoryAlbumSetDataSource;
    let broadCast: BroadCast;
    let context: Context;
    let nfyInfoPhotoAdd: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoOther: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoAdd: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoRemove: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoUpdate: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoNone: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let nfyInfoPho: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let remove: MediaObserverNfyInfo = new MediaObserverNfyInfo();

    let dissmiss: MediaObserverNfyInfo = new MediaObserverNfyInfo();


    beforeEach(() => {

      broadCast = new BroadCast();
      context = getContext();

      dataSource = new CategoryAlbumSetDataSource(broadCast, context);


      nfyInfoPhotoAdd.type = MediaObserverNfyType.PHOTO_ADD_ASTC;

      nfyInfoOther.type = MediaObserverNfyType.ALBUM_ADD;

      nfyInfoAdd.type = MediaObserverNfyType.PHOTO_ADD;

      nfyInfoRemove.type = MediaObserverNfyType.PHOTO_REMOVE;

      nfyInfoUpdate.type = MediaObserverNfyType.PHOTO_UPDATE;

      nfyInfoNone.type = MediaObserverNfyType.NONE;

      nfyInfoPho.type = MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;

      remove.type = MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM;

      dissmiss.type = MediaObserverNfyType.DISMISS_PHOTO_FROM_ALBUM;

    });

    it('noNotify_test01', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoPhotoAdd);
    });

    it('noNotify_test02', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoOther);
    });

    it('noNotify_test03', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoOther);
    });

    it('noNotify_test04', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoAdd);
    });

    it('noNotify_test05', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoRemove);
    });

    it('noNotify_test06', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoUpdate);
    });

    it('noNotify_test07', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoNone);
    });


    it('noNotify_test08', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(nfyInfoPho);

    });

    it('noNotify_test09', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(remove);
    });

    it('noNotify_test10', TestConstants.TEST_LEVEL_ZERO, async () => {
      dataSource.onNotify(dissmiss);
    });
  })
}