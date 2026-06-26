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
import { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import { describe, expect, it } from '@ohos/hypium';

export default function MediaObserverTest() {

  describe('MediaObserverTest', () => {

    it ('sliceSharedPhotoAssets', 0, () => {
      let observer = new MediaObserver();
      let originalString = 'aaaa';
      let res = observer.sliceSharedPhotoAssets(originalString);
      expect(res.length).assertEqual(0);

      originalString = 'sharedPhotoAssets';
      let res1 = observer.sliceSharedPhotoAssets(originalString);
      expect(res1.length).assertEqual(0);

      originalString = '[sharedPhotoAssets';
      let res2 = observer.sliceSharedPhotoAssets(originalString);
      expect(res2.length).assertEqual(0);

      originalString = 'sh]ared[PhotoAssets';
      let res3 = observer.sliceSharedPhotoAssets(originalString);
      expect(res3.length).assertEqual(0);

      originalString = 'aaaa[sharedPhotoAssets]';
      let res4 = observer.sliceSharedPhotoAssets(originalString);
      expect(res4.length).assertEqual(0);
    })

    it ('parseAssetType', 0, () => {
      let observer = new MediaObserver();
      let assetData = '';
      let res = observer.parseAssetType(assetData);
      expect(res.length).assertEqual(0);

      assetData = 'aaa';
      res = observer.parseAssetType(assetData);
      expect(res.length).assertEqual(0);

      assetData = 'mediaType';
      res = observer.parseAssetType(assetData);
      expect(res.length).assertEqual(0);

      assetData = 'mediaType:aaaa';
      res = observer.parseAssetType(assetData);
      expect(res).assertEqual('a');

    })

    it ('parseAssetData', 0, () => {
      let observer = new MediaObserver();
      let assetData = '';
      let res = observer.parseAssetData(assetData);
      expect(res.length).assertEqual(0);

      assetData = 'aaa';
      res = observer.parseAssetData(assetData);
      expect(res.length).assertEqual(0);

      assetData = 'mediaType';
      res = observer.parseAssetData(assetData);
      expect(res.length).assertEqual(0);

      assetData = `dateYear:2025-dateMonth:05`;
      res = observer.parseAssetData(assetData);
      expect(res.length).assertEqual(0);

      assetData = `dateYear:2025"dateMonth:05"`;
      res = observer.parseAssetData(assetData);
      expect(res.length).assertEqual(2);

    })
  })
}
