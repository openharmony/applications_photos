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
import { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

export default function AlbumUtilsTest() {
  describe('AlbumUtilsTest', () => {
    it('AlbumUtilsTest_isAlbumGroupModeSupported', 0, () => {
      let res = AlbumUtils.isAlbumGroupModeSupported();
      expect(res).assertEqual(true);
    })

    it('AlbumUtilsTest_useNewPhotoGrid', 0, () => {
      let res = AlbumUtils.useNewPhotoGrid();
      expect(res != undefined).assertEqual(true)
    })

    it('AlbumUtilsTest_isAlbumSupported', 0, () => {
      let res1 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.USER_GENERIC);
      let res2 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.IMAGE);
      let res3 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.VIDEO);
      let res4 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.FAVORITE);
      let res5 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.SCREENSHOT);
      let res6 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.CAMERA);
      let res7 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT);
      let res8 = AlbumUtils.isAlbumSupported(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC);
      expect(res1).assertEqual(true)
      expect(res2).assertEqual(true)
      expect(res3).assertEqual(true)
      expect(res4).assertEqual(true)
      expect(res5).assertEqual(true)
      expect(res6).assertEqual(true)
      expect(res7).assertEqual(true)
      expect(res8).assertEqual(true)
    })


  })
}