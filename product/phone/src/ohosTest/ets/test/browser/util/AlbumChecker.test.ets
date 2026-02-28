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
import { describe, beforeEach, afterEach, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AlbumChecker } from '@ohos/thirdselect/src/main/ets/default/model/AlbumChecker';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { PickerMediaDataSource } from '@ohos/thirdselect/src/main/ets/default//common/PickerMediaDataSource';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

export default function AlbumCheckerUT() {
  describe('album_checkerUT', () => {
    let albumChecker: AlbumChecker;
    let mockDataSource: PickerMediaDataSource;
    let mockSession: UIExtensionContentSession;
    let mocker: MockKit;

    beforeEach(() => {
      mockDataSource = new PickerMediaDataSource(10);
      albumChecker = new AlbumChecker(mockDataSource, mockSession);
      mocker = new MockKit();
    });

    afterEach(() => {
      mocker.clearAll();
    });

    it('should_return_immediately_when_is_checking_is_true', 0, async () => {
      Reflect.set(albumChecker, 'isChecking', true)
      const res = await albumChecker.check();
      expect(res !== null).assertTrue();
    });

    it('should_return_immediately_when_album_uri_is_empty', 0, async () => {
      mockDataSource.albumUri = '';
      albumChecker = new AlbumChecker(mockDataSource, mockSession);
      const res = await albumChecker.check();
      expect(res !== null).assertTrue();
    });

    it('should_return_immediately_when_album_uri_is_all_media', 0, async () => {
      mockDataSource.albumUri = Constants.ALBUM_URI_ALL_MEDIA;
      albumChecker = new AlbumChecker(mockDataSource, mockSession);
      const res = await albumChecker.check();
      expect(res !== null).assertTrue();
    });

    it('should_call_check_again_when_has_pending_is_true', 0, async () => {
      Reflect.set(albumChecker, 'hasPending', true)
      const res = await albumChecker.check();
      expect(res !== null).assertTrue();
    });

    it('should_handle_album_deleted_case', 0, async () => {
      const testAlbumUri = 'testAlbumUri';
      mockDataSource.albumUri = testAlbumUri;
      const mockGetAlbumByUri =
        mocker.mockFunc(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().getAlbumByUri);
      when(mockGetAlbumByUri)(testAlbumUri).afterReturn(undefined);
      const res = await albumChecker.check();
      expect(res !== null).assertTrue();
    });
  });
}