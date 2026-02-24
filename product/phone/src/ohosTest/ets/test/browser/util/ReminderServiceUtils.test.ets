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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import ReminderService, { ImageInfo } from '@ohos/dataprovider/src/main/ets/database/service/ReminderService';

const TAG: string = `ReminderServiceUtils `;

export default function ReminderServiceUT() {

  describe('ReminderServiceUtilsUT', () => {
    let reminderService: ReminderService;
    let mocker: MockKit

    beforeEach(() => {
      reminderService = new ReminderService({} as Context)
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('registerForPhotosAndAlbums_case1', 0, () => {
      when(mocker.mockFunc(UserFileManagerAccess.getInstance(),
        UserFileManagerAccess.getInstance().getMediaLibrary))(ArgumentMatchers.any).afterReturn('1');
      const func = () => {
        reminderService.registerForPhotosAndAlbums('', []);
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('unregisterForPhotosAndAlbums_case1', 0, () => {
      when(mocker.mockFunc(UserFileManagerAccess.getInstance(),
        UserFileManagerAccess.getInstance().getMediaLibrary))(ArgumentMatchers.any).afterReturn('1');
      const func = () => {
        reminderService.unregisterForPhotosAndAlbums('');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('deleteByFormIdAndIdWithOption_case1', 0, () => {
      const res = reminderService.deleteByFormIdAndIdWithOption('', 0, '');
      expect(res).not().assertNull();
    });
    it('insert_case1', 0, () => {
      const func = () => {
        reminderService.insert('', '', '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('queryImageByUris_case1', 0, () => {
      const res = reminderService.queryImageByUris([]);
      expect(res).not().assertNull();
    });
    it('queryImageBySearchUris_case1', 0, () => {
      const res = reminderService.queryImageByImageUriId([]);
      expect(res).not().assertNull();
    });
    it('updateIsHiddenById_case1', 0, () => {
      const func = () => {
        reminderService.updateIsHiddenById(0, 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('changeDeleteStatus_case1', 0, () => {
      const func = () => {
        const run = (isDelete: number, imageUris: string[], formId?: string): void => Reflect.get(reminderService,
          'changeDeleteStatus')
          .call(reminderService, isDelete, imageUris, formId)
        run(0, [], '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('hiddenRecordByImageUris_case1', 0, () => {
      const func = () => {
        reminderService.hiddenRecordByImageUris([], '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('showRecordByImageUris_case1', 0, () => {
      const func = () => {
        reminderService.showRecordByImageUris([], '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('queryRemainCount_case1', 0, () => {
      const func = () => {
        reminderService.queryRemainCount('', {} as ImageInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('queryLastImageInfo_case1', 0, () => {
      const func = () => {
        reminderService.queryLastImageInfo('');
      }
      expect(func).not().assertThrowError('BusinessError');
    });
  })
}
