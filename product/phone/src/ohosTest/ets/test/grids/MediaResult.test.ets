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
import { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';

export default function MediaResultTest() {

  describe('MediaResultTest', () => {
    //测试update: path equal and captureId valid
    it('update_when_mediaItem_path_equal_with_this_path_and_captureId_valid', 0, () => {
      let mediaItem = new MediaItem();
      let mediaResult: MediaResult = new MediaResult(mediaItem);
      let newMediaItem = new MediaItem();
      newMediaItem.path = 'path';
      newMediaItem.dateModified = 1;
      newMediaItem.isFavor = true;
      newMediaItem.displayName = 'displayName';
      newMediaItem.setTitle('title');
      newMediaItem.orientation = 1;
      newMediaItem.size = 1;
      newMediaItem.width = 1;
      newMediaItem.height = 1;
      newMediaItem.isResourceLoading = true;
      newMediaItem.captureId = 'captureId';
      newMediaItem.thumbnailPixmap = undefined;
      newMediaItem.thumbnailUri = 'thumbnailUri';
      newMediaItem.createTime = 1;
      mediaResult.path = newMediaItem.path;
      mediaResult.update(newMediaItem);
      expect(mediaResult.captureId).assertEqual(newMediaItem.captureId);
    });

    //测试update: path equal and captureId not valid
    it('update_when_mediaItem_path_equal_with_this_path_and_captureId_not_valid', 0, () => {
      let mediaItem = new MediaItem();
      let mediaResult: MediaResult = new MediaResult(mediaItem);
      let newMediaItem = new MediaItem();
      newMediaItem.path = '';
      newMediaItem.dateModified = 1;
      newMediaItem.isFavor = true;
      newMediaItem.displayName = 'displayName';
      newMediaItem.setTitle('title');
      newMediaItem.orientation = 1;
      newMediaItem.size = 1;
      newMediaItem.width = 1;
      newMediaItem.height = 1;
      newMediaItem.isResourceLoading = true;
      newMediaItem.captureId = '';
      newMediaItem.thumbnailPixmap = undefined;
      newMediaItem.thumbnailUri = 'thumbnailUri';
      newMediaItem.createTime = 1;
      mediaResult.path = newMediaItem.path;
      mediaResult.update(newMediaItem);
      expect(mediaResult.captureId).assertEqual('');
    });


    //测试update: path not equal or captureId not valid
    it('update_when_mediaItem_path_not_equal_with_this_path', 0, () => {
      let mediaItem = new MediaItem();
      let mediaResult: MediaResult = new MediaResult(mediaItem);
      let newMediaItem = new MediaItem();
      newMediaItem.path = 'path';
      newMediaItem.dateModified = 1;
      newMediaItem.isFavor = true;
      newMediaItem.displayName = 'displayName';
      newMediaItem.setTitle('title');
      newMediaItem.orientation = 1;
      newMediaItem.size = 1;
      newMediaItem.width = 1;
      newMediaItem.height = 1;
      newMediaItem.isResourceLoading = true;
      newMediaItem.captureId = 'captureId';
      newMediaItem.thumbnailPixmap = undefined;
      newMediaItem.thumbnailUri = 'thumbnailUri';
      newMediaItem.createTime = 1;
      mediaResult.path = 'path1';
      mediaResult.update(newMediaItem);
      expect(mediaResult.item).assertEqual(mediaItem);
    });

    //测试updateAll: input valid
    it('updateAll_when_input_valid', 0, () => {
      let mediaItem = new MediaItem();
      let mediaResult: MediaResult = new MediaResult(mediaItem);
      let newMediaItem = new MediaItem();
      newMediaItem.path = 'path';
      newMediaItem.dateModified = 1;
      newMediaItem.isFavor = true;
      newMediaItem.displayName = 'displayName';
      newMediaItem.setTitle('title');
      newMediaItem.orientation = 1;
      newMediaItem.size = 1;
      newMediaItem.width = 1;
      newMediaItem.height = 1;
      newMediaItem.isResourceLoading = true;
      newMediaItem.captureId = 'captureId';
      newMediaItem.thumbnailPixmap = undefined;
      newMediaItem.thumbnailUri = 'thumbnailUri';
      newMediaItem.createTime = 1;
      mediaResult.path = 'path1';
      let newMediaResult = new MediaResult(newMediaItem);
      mediaResult.updateAll(newMediaResult);
      expect(mediaResult.item).assertEqual(newMediaResult.item);
    });

    //测试setItemPos
    it('setItemPos_when_input_valid', 0, () => {
      let newMediaItem = new MediaItem();
      newMediaItem.path = 'path';
      newMediaItem.dateModified = 1;
      newMediaItem.isFavor = true;
      newMediaItem.displayName = 'displayName';
      newMediaItem.setTitle('title');
      newMediaItem.orientation = 1;
      newMediaItem.size = 1;
      newMediaItem.width = 1;
      newMediaItem.height = 1;
      newMediaItem.isResourceLoading = true;
      newMediaItem.captureId = 'captureId';
      newMediaItem.thumbnailPixmap = undefined;
      newMediaItem.thumbnailUri = 'thumbnailUri';
      newMediaItem.createTime = 1;
      let mediaResult: MediaResult = new MediaResult(newMediaItem);
      mediaResult.setItemPos(1234);
      expect(mediaResult.pos).assertEqual(1234);
    });

  });
}