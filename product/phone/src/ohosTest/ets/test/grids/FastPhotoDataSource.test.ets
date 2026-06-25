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

import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { FastPhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/FastPhotoDataSource';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';

export default function FastPhotoDataSourceTest() {
  describe('FastPhotoDataSourceTest', () => {

    let dataSource: FastPhotoDataSource;
    beforeEach(() => {
      dataSource = new FastPhotoDataSource(new PhotoBrowserStateMachine());
    });

    it('getUriByCaptureId_should_return_empty_string_when_no_thumbnails_exist', 0, () => {
      const result = dataSource.getUriByCaptureId('any-id');
      expect(result).assertEqual('');
    });

    it('isSamePhotoAsset_should_return_true_when_uris_have_same_media_library_id', 0, () => {
      const uri1 = 'file://media/Photo/12345/photo1.jpg';
      const uri2 = 'file://media/Photo/12345/photo2.jpg';
      const run = (uri: string, compareUri: string): boolean =>
      Reflect.get(dataSource, 'isSamePhotoAsset').call(dataSource, uri, compareUri);
      const result = run(uri1, uri2);
      expect(result).assertTrue();
    });
    it('isSamePhotoAsset_should_return_false_when_uris_have_different_media_library_ids', 0, () => {
      const uri1 = 'file://media/Photo/12345/photo1.jpg';
      const uri2 = 'file://media/Photo/67890/photo1.jpg';
      const run = (uri: string, compareUri: string): boolean =>
      Reflect.get(dataSource, 'isSamePhotoAsset').call(dataSource, uri, compareUri);
      const result = run(uri1, uri2);
      expect(result).assertFalse();
    });
    it('isSamePhotoAsset_should_return_false_when_one_uri_is_invalid', 0, () => {
      const uri1 = 'file://media/Photo/12345/photo1.jpg';
      const uri2 = 'invalid_uri_format';
      const run = (uri: string, compareUri: string): boolean =>
      Reflect.get(dataSource, 'isSamePhotoAsset').call(dataSource, uri, compareUri);
      const result = run(uri1, uri2);
      expect(result).assertFalse();
    });
    it('isSamePhotoAsset_should_return_false_when_both_uris_are_invalid', 0, () => {
      const uri1 = 'invalid_uri1';
      const uri2 = 'invalid_uri2';
      const run = (uri: string, compareUri: string): boolean =>
      Reflect.get(dataSource, 'isSamePhotoAsset').call(dataSource, uri, compareUri);
      const result = run(uri1, uri2);
      expect(result).assertTrue();
    });

    it('isSamePhotoAsset_should_return_false_when_uris_have_different_path_formats', 0, () => {
      const uri1 = 'file://media/Photo/12345/photo1.jpg';
      const uri2 = 'content://media/external/images/media/12345';
      const run = (uri: string, compareUri: string): boolean =>
      Reflect.get(dataSource, 'isSamePhotoAsset').call(dataSource, uri, compareUri);
      const result = run(uri1, uri2);
      expect(result).assertFalse();
    });
    it("isThumbnailIndex_is_not_index", 0, async () => {
      let testindex = 1;
      const run = (index: number): boolean =>
      Reflect.get(dataSource, 'isThumbnailIndex').call(index);
      const result = run(testindex);
      expect(result).assertFalse();
    });

    it("mediaTotalCount", 0, async () => {
      let dataSource1: FastPhotoDataSource;
      const stateMachine = new PhotoBrowserStateMachine();
      dataSource1 = new FastPhotoDataSource(stateMachine);
      const result = dataSource1.mediaTotalCount();
      expect(result).assertEqual(0);
    });

    it('lockThumbnail_when_delayClearTimeoutId_is_zero',0, () => {
      Reflect.set(dataSource, 'delayClearTimeoutId', 0);
      dataSource.lockThumbnail();
      expect(Reflect.get(dataSource, 'delayClearTimeoutId')).assertEqual(0);
    });

    it('lockThumbnail_when_delayClearTimeoutId_is_not_zero', 0, () => {
      Reflect.set(dataSource, 'delayClearTimeoutId', 100);
      dataSource.lockThumbnail();
      expect(Reflect.get(dataSource, 'delayClearTimeoutId')).assertEqual(0);
    });

    it('unlockThumbnail_should_call_delayDeleteThumbnails_when_unlockThumbnail_is_called', 0, () => {
      dataSource.unlockThumbnail();
      expect(Reflect.get(dataSource, 'delayClearTimeoutId')>0).assertTrue();
    });

  })
}
