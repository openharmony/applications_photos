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
import { Builder } from '@ohos/common/src/main/ets/default/model/browser/photo/pipeline/ImageRequest';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';

export default function ImageRequestTest() {
  describe('ImageRequestTest', () => {
    //测试setAlbum
    it('setAlbum_when_set', 0, () => {
      let builder: Builder = new Builder();
      let albumUri = 'test'
      builder.setAlbum(albumUri);
      expect(builder.albumUri).assertEqual(albumUri);
    });

    //测试setItem
    it('setItem_when_set', 0, () => {
      let builder: Builder = new Builder();
      let item = new MediaItem();
      builder.setItem(item);
      expect(builder.item !== undefined).assertTrue();
    });

    //测试setUri
    it('setUri_when_set', 0, () => {
      let builder: Builder = new Builder();
      let uri: string = './photos/';
      builder.setUri(uri);
      expect(builder.uri).assertEqual(uri);
    });

    //测试setIsThumbnail
    it('setIsThumbnail_when_set', 0, () => {
      let builder: Builder = new Builder();
      let isThumbnail: boolean = true;
      builder.setIsThumbnail(isThumbnail);
      expect(builder.isThumbnail).assertEqual(isThumbnail);
    });

    //测试setIsNewApi
    it('setIsNewApi_when_set', 0, () => {
      let builder: Builder = new Builder();
      let isNewApi: boolean = true;
      builder.setIsNewApi(isNewApi);
      expect(builder.isNewApi).assertEqual(isNewApi);
    });

    //测试build
    it('build_when_set', 0, () => {
      let builder: Builder = new Builder();
      let item = new MediaItem();
      builder.setItem(item);
      const res = builder.build();
      expect(res !== undefined).assertTrue();
    });

  });
}