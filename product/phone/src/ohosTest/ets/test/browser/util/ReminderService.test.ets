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
import { UserFileManagerAccess } from "@ohos/common/src/main/ets/default/access/UserFileManagerAccess";
import ReminderService, { ImageInfo } from "@ohos/dataprovider/src/main/ets/database/service/ReminderService";
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";

export default function ReminderServiceUT() {
  describe('ReminderServiceUT', () => {
    let service: ReminderService
    let mocker: MockKit

    beforeEach(() => {
      service = new ReminderService({} as Context)
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll()
    })

    it('batchInsert_case_one', 0, async () => {
      // insertNO !== undefined
      when(mocker.mockFunc(service, service.mBatchInsert))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.batchInsert('1', '1', [])
      expect(res !== null).assertTrue()
    })

    it('batchInsert_case_two', 0, async () => {
      // insertNO == undefined
      when(mocker.mockFunc(service, service.mBatchInsert))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.batchInsert('1', '1', [])
      expect(res !== null).assertTrue()
    })

    it('updateRegisterForPhotosAndAlbums_case_one', 0, async () => {
      // photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.updateRegisterForPhotosAndAlbums('1', [])
      expect(res !== null).assertTrue()
    })

    it('updateRegisterForPhotosAndAlbums_case_two', 0, async () => {
      // albumUri
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.updateRegisterForPhotosAndAlbums('1', [], '1')
      expect(res !== null).assertTrue()
    })

    it('updateRegisterForPhotosAndAlbums_case_three', 0, async () => {
      // !photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(false)
      const res = await service.updateRegisterForPhotosAndAlbums('1', [])
      expect(res !== null).assertTrue()
    })

    it('registerForPhotosAndAlbums_case_one', 0, async () => {
      // photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.registerForPhotosAndAlbums('1', [])
      expect(res !== null).assertTrue()
    })

    it('registerForPhotosAndAlbums_case_two', 0, async () => {
      // !photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(false)
      const res = await service.registerForPhotosAndAlbums('1', [])
      expect(res !== null).assertTrue()
    })

    it('registerForPhotosAndAlbums_case_three', 0, async () => {
      // albumUri
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.registerForPhotosAndAlbums('1', [], '1')
      expect(res !== null).assertTrue()
    })

    it('unregisterForPhotosAndAlbums_case_one', 0, async () => {
      // photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.unregisterForPhotosAndAlbums('1')
      expect(res !== null).assertTrue()
    })

    it('unregisterForPhotosAndAlbums_case_two', 0, async () => {
      // !photoAccessHelper
      const access = UserFileManagerAccess.getInstance()
      when(mocker.mockFunc(access, access.onCreate))(ArgumentMatchers.any).afterReturn(false)
      when(mocker.mockFunc(access, access.getMediaLibrary))(ArgumentMatchers.any).afterReturn(false)
      const res = await service.unregisterForPhotosAndAlbums('1')
      expect(res !== null).assertTrue()
    })

    it('deleteByFormIdAndIdWithOption_case_one', 0, async () => {
      // !this.context
      Reflect.set(service, 'context', undefined)
      const res = await service.deleteByFormIdAndIdWithOption('1', 1, '1')
      expect(res !== null).assertTrue()
    })

    it('deleteByFormIdAndIdWithOption_case_two', 0, async () => {
      // OPT_LESS_THAN
      const res = await service.deleteByFormIdAndIdWithOption('1', 1, 'OPT_LESS_THAN')
      expect(res !== null).assertTrue()
    })

    it('deleteByFormIdAndIdWithOption_case_three', 0, async () => {
      // OPT_NOT_EQUAL
      const res = await service.deleteByFormIdAndIdWithOption('1', 1, 'OPT_NOT_EQUAL')
      expect(res !== null).assertTrue()
    })

    it('deleteByFormIdAndIdWithOption_case_four', 0, async () => {
      // OPT_DEFAULT
      const res = await service.deleteByFormIdAndIdWithOption('1', 1, 'OPT_DEFAULT')
      expect(res !== null).assertTrue()
    })

    it('deleteByFormIdAndIdWithOption_case_five', 0, async () => {
      // default
      const res = await service.deleteByFormIdAndIdWithOption('1', 1, '1')
      expect(res !== null).assertTrue()
    })

    it('insert_case_one', 0, async () => {
      // insertNO !== undefined
      when(mocker.mockFunc(service, service.mInsert))(ArgumentMatchers.any).afterReturn(true)
      when(mocker.mockFunc(service, service.registerForPhotosAndAlbums))(ArgumentMatchers.any).afterReturn(true)
      const res = await service.insert('1', '1', '1')
      expect(res !== null).assertTrue()
    })

    it('insert_case_two', 0, async () => {
      // insertNO === undefined
      when(mocker.mockFunc(service, service.mInsert))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.insert('1', '1', '1')
      expect(res !== null).assertTrue()
    })

    it('queryImageByUris_case_one', 0, async () => {
      // filterHidden
      const res = await service.queryImageByUris(['1', '2'])
      expect(res !== null).assertTrue()
    })

    it('queryImageByUris_case_two', 0, async () => {
      // !filterHidden
      const res = await service.queryImageByUris(['1'])
      expect(res !== null).assertTrue()
    })

    it('queryImageByImageUriId_case_one', 0, async () => {
      // !includeHidden
      const res = await service.queryImageByImageUriId([], false)
      expect(res !== null).assertTrue()
    })

    it('queryImageByImageUriId_case_two', 0, async () => {
      // includeHidden
      const res = await service.queryImageByImageUriId([])
      expect(res !== null).assertTrue()
    })

    it('changeDeleteStatus_case_one', 0, async () => {
      // !includeHidden
      const res: boolean = await Reflect.get(service, 'changeDeleteStatus').call(service, 1, ['1', '2'])
      expect(res !== null).assertTrue()
    })

    it('changeDeleteStatus_case_two', 0, async () => {
      // includeHidden
      const res: boolean = await Reflect.get(service, 'changeDeleteStatus').call(service, 1, ['1'])
      expect(res !== null).assertTrue()
    })

    it('changeDeleteStatus_case_three', 0, async () => {
      // formId
      const res: boolean = await Reflect.get(service, 'changeDeleteStatus').call(service, 1, ['1', '2'], '1')
      expect(res !== null).assertTrue()
    })

    it('changeDeleteStatus_case_four', 0, async () => {
      // !formId
      const res: boolean = await Reflect.get(service, 'changeDeleteStatus').call(service, 1, ['1'])
      expect(res !== null).assertTrue()
    })

    it('queryRemainImagesInfo_case_one', 0, async () => {
      // !queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.queryRemainImagesInfo('1', {} as ImageInfo)
      expect(res !== null).assertTrue()
    })

    it('queryRemainImagesInfo_case_two', 0, async () => {
      // queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn({ rowCount: 1 })
      const res = await service.queryRemainImagesInfo('1', {} as ImageInfo)
      expect(res !== null).assertTrue()
    })

    it('queryRemainCount_case_one', 0, async () => {
      // !queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.queryRemainCount('1', {} as ImageInfo)
      expect(res !== null).assertTrue()
    })

    it('queryRemainCount_case_two', 0, async () => {
      // queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn({ rowCount: 1 })
      const res = await service.queryRemainCount('1', {} as ImageInfo)
      expect(res !== null).assertTrue()
    })

    it('queryImageInfoForSingleAlbum_case_one', 0, async () => {
      // !queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.queryImageInfoForSingleAlbum('1')
      expect(res !== null).assertTrue()
    })

    it('queryImageInfoForSingleAlbum_case_two', 0, async () => {
      // queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn({ rowCount: 1 })
      const res = await service.queryImageInfoForSingleAlbum('1')
      expect(res !== null).assertTrue()
    })

    it('queryLastImageInfo_case_one', 0, async () => {
      // !queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn(undefined)
      const res = await service.queryLastImageInfo('1')
      expect(res !== null).assertTrue()
    })

    it('queryLastImageInfo_case_two', 0, async () => {
      // queryResult
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn({ rowCount: 1 })
      const res = await service.queryLastImageInfo('1')
      expect(res !== null).assertTrue()
    })

    it('queryLastImageInfo_case_three', 0, async () => {
      // carouselCompleted
      when(mocker.mockFunc(service, service.mQuery))(ArgumentMatchers.any).afterReturn({ rowCount: 1 })
      const res = await service.queryLastImageInfo('1', true)
      expect(res !== null).assertTrue()
    })

    it('queryByFormId_case_one', 0, async () => {
      // filterHidden
      const res = await service.queryByFormId('1', true)
      expect(res !== null).assertTrue()
    })

    it('queryByFormId_case_two', 0, async () => {
      // !filterHidden
      const res = await service.queryByFormId('1')
      expect(res !== null).assertTrue()
    })
  })
}