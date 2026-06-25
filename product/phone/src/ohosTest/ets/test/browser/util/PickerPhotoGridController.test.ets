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
import { ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import {
  PickerPhotoGridController
} from '@ohos/thirdselect/src/main/ets/default/thirdselectphoto/viewcontroller/PickerPhotoGridController'

export default function PickerPhotoGridControllerUT() {
  describe('PickerPhotoGridControllerUT', () => {
    let controller: PickerPhotoGridController
    let mocker: MockKit
    const context = {} as Context
    const storage = { get: (a) => 1 } as LocalStorage

    beforeEach(() => {
      controller = new PickerPhotoGridController(context, storage)
      mocker = new MockKit()
    })

    it('grantUriPermissionAndSendData_case_one', 0, async () => {
      // !session
      const storage: Storage = Reflect.get(controller, 'storage')
      when(mocker.mockFunc(storage, storage.get))(ArgumentMatchers.any).afterReturn(false)
      const res = await controller.grantUriPermissionAndSendData('1', false)
      expect(res !== null).assertTrue()
    })

    it('grantUriPermissionAndSendData_case_two', 0, async () => {
      // value
      const storage: Storage = Reflect.get(controller, 'storage')
      when(mocker.mockFunc(storage, storage.get))(ArgumentMatchers.any).afterReturn(true)
      const res = await controller.grantUriPermissionAndSendData('1', true)
      expect(res !== null).assertTrue()
    })

    it('grantUriPermissionAndSendData_case_three', 0, async () => {
      // value
      const storage: Storage = Reflect.get(controller, 'storage')
      when(mocker.mockFunc(storage, storage.get))(ArgumentMatchers.any).afterReturn({ bundleName: '' })
      when(mocker.mockFunc(controller, controller.handleSendSelectData))(ArgumentMatchers.any).afterReturn('')
      const res = await controller.grantUriPermissionAndSendData('1', false)
      expect(res !== null).assertTrue()
    })

    it('handleSendSelectData_case_one', 0, () => {
      // !isSelect
      const res = controller.handleSendSelectData('1', undefined, false)
      expect(res !== null).assertTrue()
    })

    it('handleSendSelectData_case_two', 0, () => {
      // !isSelect
      Reflect.set(controller, 'selectInfoList', [{ uri: '0' }, { uri: '1' }])
      const res = controller.handleSendSelectData('1', undefined, true)
      expect(res !== null).assertTrue()
    })

    it('handleSendSelectData_case_three', 0, () => {
      // this.isOnItemClickedSet
      Reflect.set(controller, 'selectInfoList', [{ state: 2 }, { state: 0 }])
      Reflect.set(controller, 'isOnItemClickedSet', true)
      const res = controller.handleSendSelectData('1', undefined, true)
      expect(res !== null).assertTrue()
    })

    it('sendSelectData_case_one', 0, () => {
      // !this.isOnItemClickedSet
      const res = controller.sendSelectData('1', undefined, true)
      expect(res !== null).assertTrue()
    })

    it('sendSelectData_case_two', 0, () => {
      // this.isOnItemClickedSet
      Reflect.set(controller, 'isOnItemClickedSet', true)
      const res = controller.sendSelectData('1', undefined, true)
      expect(res !== null).assertTrue()
    })

    it('sendSelectData_case_three', 0, () => {
      // this.isOnItemClickedSet
      Reflect.set(controller, 'isOnItemClickedSet', true)
      const res = controller.sendSelectData('1', undefined, false)
      expect(res !== null).assertTrue()
    })
  })
}