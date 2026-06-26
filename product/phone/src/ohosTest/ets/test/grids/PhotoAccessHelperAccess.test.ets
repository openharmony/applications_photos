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
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { FetchOptionBuilder } from '@ohos/common/src/main/ets/default/model/FetchOption';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import type common from '@ohos.app.ability.common';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import {
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

export type PhotoAsset = photoAccessHelper.PhotoAsset;
export type PhotoAlbum = photoAccessHelper.Album;

export default function PhotoAccessHelperAccessTest() {
  describe('PhotoAccessHelperAccessTest', () => {

    it('FetchOptionBuilder_media', 0, () => {
      let builder = new FetchOptionBuilder();
      let res = builder.media(photoAccessHelper.PhotoKeys.PHOTO_TYPE);
      expect(res != undefined).assertEqual(true);
    });

    it('FetchOptionBuilder_select', 0, () => {
      let builder = new FetchOptionBuilder();
      let res = builder.select(0, 1);
      expect(res != undefined).assertEqual(true);
    });

    it('FetchOptionBuilder_getInstance', 0, () => {
      let res = PhotoAccessHelperAccess.getInstance();
      expect(res != undefined).assertEqual(true);
    });

    it('FetchOptionBuilder_getLcdSize', 0, () => {
      let res = PhotoAccessHelperAccess.getLcdSize();
      expect(res === undefined).assertEqual(true);
    });

    it('FetchOptionBuilder_getThmSize', 0, () => {
      let res = PhotoAccessHelperAccess.getThmSize()
      expect(res === undefined).assertEqual(true);
    });

    // 测试getPhotoAccessHelper
    it('getPhotoAccessHelper_undefined', 0, () => {
      let context: common.AbilityStageContext = {} as common.AbilityStageContext;
      AppStorage.setOrCreate('photosGlobalContext', context);
      const res = PhotoAccessHelperAccess.getPhotoAccessHelper(context);
      expect(res === undefined).assertTrue();
    });

    // 测试getAlbumAssetInfo
    it('getAlbumAssetInfo_with_not_empty_fromEntry', 0, async () => {
      let albumUri:string = 'file://media/PhotoAlbum/7'
      let test_album = (await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri) as photoAccessHelper.Album);
      const res = PhotoAccessHelperAccess.getAlbumAssetInfo(test_album,'a://photo/image/0');
      expect(res).not().assertNull();
    });

    // 测试setCustomAlbumCover
    it('setCustomAlbumCover_undefined', 0, async () => {
      const res = await PhotoAccessHelperAccess.getInstance().setCustomAlbumCover(getContext(),undefined, '');
      expect(res).not().assertNull();
    });

    it('setCustomAlbumCover_defined', 0, async () => {
      const res = await PhotoAccessHelperAccess.getInstance().setCustomAlbumCover(getContext(),new AlbumInfo(), 'valid');
      expect(res).not().assertNull();
    });

    //测试resetCustomAlbumCover
    it('resetCustomAlbumCover_undefined', 0, async () => {
      const res = await PhotoAccessHelperAccess.getInstance().resetCustomAlbumCover(getContext(), undefined);
      expect(res).assertFalse();
    });

    it('resetCustomAlbumCover_defined', 0, async () => {
      const res = await PhotoAccessHelperAccess.getInstance().resetCustomAlbumCover(getContext(), new AlbumInfo());
      expect(res).assertTrue();
    });

    //测试getHiddenPhotoAssetByUrl
    it('getHiddenPhotoAssetByUrl_undefined', 0, async () => {
      const res = await PhotoAccessHelperAccess.getInstance().getHiddenPhotoAssetByUrl(getContext(),'');
      expect(res).not().assertNull();
    });

    // 测试getAlbumAssetInfo分支
    it('getAlbumAssetInfo_with_empty_fromEntry', 0, async () => {
      let albumUri: string = 'file://media/PhotoAlbum/7'
      let test_album = (await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri) as photoAccessHelper.Album);
      const res = PhotoAccessHelperAccess.getAlbumAssetInfo(test_album,'');
      expect(res).not().assertNull();
    });

    // 测试getCleanupAlbumCoverUri分支
    it('getCleanupAlbumCoverUri_undefined', 0, async () => {
      let predicates = new dataSharePredicates.DataSharePredicates();
      let albumUri: string = 'file://media/PhotoAlbum/7'
      let test_album = (await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri) as photoAccessHelper.Album);
      const run = (album: photoAccessHelper.Album,
      predicates: dataSharePredicates.DataSharePredicates): Promise<string> =>
        Reflect.get(PhotoAccessHelperAccess, 'getCleanupAlbumCoverUri').call(album, predicates);

      const res = await run(test_album, predicates);
      expect(res).not().assertNull();
    });

    // 测试getPhotoByUri分支
    it('getPhotoByUri_valid', 0, async () => {
      const res = await PhotoAccessHelperAccess.getPhotoByUri(getContext(),'valid');
      expect(res).not().assertNull();
    });

    // 测试getPhotoByUris分支
    it('getPhotoByUris_empty', 0, async () => {
      let photoAsset: photoAccessHelper.PhotoAsset[] = [];
      const res = PhotoAccessHelperAccess.getPhotoByUris(getContext(),photoAsset);
      expect(res).not().assertNull();
    });

    //测试getPrivacyStatusByTokenId
    it('getPrivacyStatusByTokenId_input_album', 0, async () => {
      let tokenId: number = 1;
      const res = PhotoAccessHelperAccess.getPrivacyStatusByTokenId(tokenId);
      expect(res !== undefined).assertTrue();
    });

    //测试getGroupAlbums
    it('getGroupAlbums_input_context', 0, async () => {
      let predicates = new dataSharePredicates.DataSharePredicates();
      const res = PhotoAccessHelperAccess.getGroupAlbums(getContext(), predicates);
      expect(res !== undefined).assertTrue();
    });
  });

}

