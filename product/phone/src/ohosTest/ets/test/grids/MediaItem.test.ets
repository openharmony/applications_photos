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
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';

export default function MediaItemTest() {
  describe('MediaItemTest', () => {

    it ('equals', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.equals(undefined)).assertEqual(false);
    });

    it ('getFileId', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.getFileId()).assertEqual(0);
    });

    it ('getSubLocalityStatic', 0, async  () => {
      let mediaItem: MediaItem = new MediaItem();
      let res1 = await mediaItem.getSubLocalityStatic();
      expect(res1).assertEqual('');

      let subLocalityAddress = 'aaaa';
      Reflect.set(mediaItem, 'subLocalityAddress', subLocalityAddress);
      let res2 = await mediaItem.getSubLocalityStatic();
      expect(res2 === subLocalityAddress).assertEqual(false);
    });

    it ('getIsBurstPhotos', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.data = undefined;
      expect(mediaItem.getIsBurstPhotos()).assertEqual(false);
    });

    it ('getSaliencyFlag', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.data = undefined;
      expect(mediaItem.getSaliencyFlag()).assertEqual(false);
    });

    it ('getTimeId', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.timeId = 'aaaaa';
      expect(mediaItem.getTimeId()).assertEqual('aaaaa');

      mediaItem.timeId = '';
      expect(mediaItem.getTimeId()).assertEqual('');
    });

    it ('setDateAdded_getDateAdded', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setDateAdded(undefined);
      let dateAdded = 3;
      mediaItem.setDateAdded(dateAdded);

      expect(mediaItem.getDateAdded()).assertEqual(dateAdded);
    });

    it ('setShootingMode', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      let shootingMode = 'aaaa';
      mediaItem.setShootingMode(shootingMode);

      expect(Reflect.get(mediaItem, 'shootingMode')).assertEqual(shootingMode);
    });

    it ('setDetailTime', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      let detailTime = 3;
      mediaItem.setDetailTime(detailTime);

      expect(Reflect.get(mediaItem, 'detailTime')).assertEqual(detailTime);
    });

    it ('setDateTaken', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setDateAdded(undefined);
      let dateToken = 3;
      mediaItem.setDateTaken(dateToken);

      expect(Reflect.get(mediaItem, 'dateTaken')).assertEqual(dateToken);
    });

    it ('setTitle', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setTitle(undefined);
      let title = 'aaaaa';
      mediaItem.setTitle(title);

      expect(mediaItem.getTitle()).assertEqual(title);
    });

    it ('getStaticHashCode', 0, () => {
      expect(MediaItem.getStaticHashCode(undefined)).assertEqual('');
    });

    it ('setDisplayedWidth_getDisplayedWidth', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setDisplayedWidth(5)
      expect(mediaItem.getDisplayedWidth()).assertEqual(5);
    });

    it ('setFavorite', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setFavorite(true)
      expect(Reflect.get(mediaItem, 'isFavor')).assertEqual(true);
    });

    it ('getRotation', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.getRotation()).assertEqual(0);
    });

    it ('isEditableSize', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.isEditableSize()).assertEqual(false);
    });

    it ('getThumbnailReady', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.thumbnailReady = 1;
      expect(mediaItem.getThumbnailReady()).assertEqual(1);
    });

    it ('toString', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.toString().length > 0).assertEqual(true);
    });

    it ('isThumbnailCacheTimeout', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      expect(mediaItem.isThumbnailCacheTimeout(0)).assertEqual(true);
    });

    it ('getDetailAddress', 0, async() => {
      let mediaItem: MediaItem = new MediaItem();
      const res = await mediaItem.getDetailAddress(false);
      expect(res).assertEqual('');
    });

    it ('setUri', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.setUri('false');
      expect(mediaItem.uri).assertEqual('false');
    });

    it('should_return_true_when_width_is_zero', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.width = 0;
      mediaItem.height = 100;
      expect(mediaItem.isInvalidImageSize()).assertTrue();
    });

    it('should_return_true_when_height_is_zero', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.width = 100;
      mediaItem.height = 0;
      expect(mediaItem.isInvalidImageSize()).assertTrue();
    });

    it('should_return_true_when_width_and_height_are_zero', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.width = 0;
      mediaItem.height = 0;
      expect(mediaItem.isInvalidImageSize()).assertTrue();
    });

    it('should_return_false_when_width_and_height_are_valid', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.width = 100;
      mediaItem.height = 100;
      expect(mediaItem.isInvalidImageSize()).assertFalse();
    });

  });
}