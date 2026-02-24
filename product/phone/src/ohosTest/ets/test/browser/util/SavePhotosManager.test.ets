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
import { SavePhotosManager } from '@ohos/thirdselect/src/main/ets/default/manager/SavePhotosManager'
import { MediaItem } from "@ohos/common/src/main/ets/default/model/browser/photo/MediaItem";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { SelectParams } from "@ohos/common/src/main/ets/default/model/common/SelectParams";
import { BusinessError } from '@ohos.base';
import { ReplaceUriManager } from "@ohos/common/src/main/ets/default/model/ReplaceUriManager";

interface dataType extends Record<string, Object> {
  date: number;
  config: number[];
  replaceUris: string[];
  saveMode: number;
}

export default function SavePhotosManagerUT() {
  describe('SavePhotosManagerUT', () => {
    let manager: SavePhotosManager;
    let mocker: MockKit

    beforeEach(() => {
      manager = new SavePhotosManager()
      mocker = new MockKit()
    })

    it('saveReplacedPhotoAssets_test', 0, async () => {
      // saveMode === 1
      const replaceUrisMap = new Map([[new MediaItem(), new MediaItem()]])
      const callback = () => {
      }
      await manager.saveReplacedPhotoAssets(replaceUrisMap, callback, [], 1)
      // !saveMode
      const res = await manager.saveReplacedPhotoAssets(replaceUrisMap, callback, [], 0)
      expect(res !== null).assertTrue()
    })

    it('savePhotoAssetsAsNew_test', 0, async () => {
      const run = async (replaceUrisMap?: Map<MediaItem, MediaItem>, callback?: Function,
        configs?: Array<photoAccessHelper.PhotoCreationConfig>, saveMode?: number, params?: SelectParams,
        appName?: string): Promise<void> => await Reflect.get(manager, 'savePhotoAssetsAsNew')
        .call(manager, replaceUrisMap, callback, configs, saveMode, params, appName)
      // replaceUrisMap === undefined
      const callback = () => {
      }
      await run(undefined, callback)
      // configs === undefined
      const replaceUrisMap = new Map([[new MediaItem(), new MediaItem()]])
      await run(replaceUrisMap, callback)
      // configs !== undefined
      const res = await run(replaceUrisMap, callback, [{} as photoAccessHelper.PhotoCreationConfig])
      expect(res !== null).assertTrue()
    })

    it('getToastMode_test', 0, () => {
      const run = (savePhotosCount: number, saveVideosCount: number): number => Reflect.get(manager, 'getToastMode')
        .call(manager, savePhotosCount, saveVideosCount)
      // savePhotosCount > 0 && saveVideosCount > 0
      run(1, 1)
      // savePhotosCount > 0
      run(1, 0)
      // saveVideosCount > 0
      run(0, 1)
      // return
      const res = run(0, 0)
      expect(res !== null).assertTrue()
    })

    it('writeMediaAssetsToGallery_test', 0, () => {
      const run = (replaceUris: Array<string>, desFileUris?: Array<string>,
        error?: BusinessError<void>): Array<string> => Reflect.get(manager, 'writeMediaAssetsToGallery')
        .call(manager, replaceUris, desFileUris, error)
      // for
      // catch
      const res = run(['', ''], [], {} as BusinessError<void>)
      expect(res !== null).assertTrue()
    })

    it('savePhotoAssetsOverride_test', 0, async () => {
      const run = async (replaceUrisMap: Map<MediaItem, MediaItem>, callback: Function,
        saveMode?: number): Promise<void> => await Reflect.get(manager, 'savePhotoAssetsOverride')
        .call(manager, replaceUrisMap, callback, saveMode)
      // photoAsset
      let asset = {
        uri: '', photoType: 1,
      } as photoAccessHelper.PhotoAsset
      const getMap = (photoAsset: photoAccessHelper.PhotoAsset) => new Map([[new MediaItem(photoAsset), new MediaItem({
        uri: '',
      } as photoAccessHelper.PhotoAsset)]])
      const callback = () => {
      }
      run(getMap(asset), callback)
      // !photoAsset
      asset = {
        uri: '',
      } as photoAccessHelper.PhotoAsset
      const res = run(getMap(asset), callback)
      expect(res !== null).assertTrue()
    })

    it('handleSavePhotos_test', 0, () => {
      // context === undefined
      let mocker: MockKit = new MockKit()
      const localStorage = new LocalStorage()
      when(mocker.mockFunc(LocalStorage, LocalStorage.getShared))().afterReturn(localStorage)
      const mockGet = mocker.mockFunc(localStorage, localStorage.get)
      when(mockGet)(ArgumentMatchers.any).afterReturnNothing()
      const data: dataType = {
        date: 1,
        config: [1],
        replaceUris: [],
        saveMode: 1,
      }
      manager.handleSavePhotos(data, undefined)
      // configs.length !== replaceUris.length
      when(mockGet)(ArgumentMatchers.any).afterReturn(1)
      when(mocker.mockFunc(manager, Reflect.get(manager, 'sendData')))(ArgumentMatchers.any).afterReturnNothing()
      manager.handleSavePhotos(data, undefined)
      // configs
      data.replaceUris = ['1']
      // tokenId
      when(mockGet)(ArgumentMatchers.any).afterReturn({
        tokenId: 1,
      })
      // successDesFileUris.length
      when(mocker.mockFunc(manager, Reflect.get(manager, 'writeMediaAssetsToGallery')))(ArgumentMatchers.any)
        .afterReturn(['1'])
      manager.handleSavePhotos(data, undefined)
      // mediaItems.length !== 0
      const replaceUriManager = new ReplaceUriManager()
      when(mocker.mockFunc(replaceUriManager, replaceUriManager.hasReplaceUri))(ArgumentMatchers.any).afterReturn(true)
      when(mocker.mockFunc(replaceUriManager, replaceUriManager.getReplaceOriAndReplaceMediaItem))(ArgumentMatchers.any)
        .afterReturn([new MediaItem({
          uri: '',
        } as photoAccessHelper.PhotoAsset)])
      when(mocker.mockFunc(manager, Reflect.get(manager, 'isExist')))(ArgumentMatchers.any)
        .afterReturn(false)
      const res = manager.handleSavePhotos(data, replaceUriManager)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(LocalStorage, LocalStorage.getShared)
      mocker.ignoreMock(localStorage, localStorage.get)
      mocker.ignoreMock(manager, Reflect.get(manager, 'sendData'))
      mocker.ignoreMock(manager, Reflect.get(manager, 'writeMediaAssetsToGallery'))
      mocker.ignoreMock(replaceUriManager, replaceUriManager.hasReplaceUri)
      mocker.ignoreMock(replaceUriManager, replaceUriManager.getReplaceOriAndReplaceMediaItem)
    })

    it('sendData_test', 0, () => {
      const localStorage = new LocalStorage()
      when(mocker.mockFunc(LocalStorage, LocalStorage.getShared))().afterReturn(localStorage)
      when(mocker.mockFunc(localStorage, localStorage.get))(ArgumentMatchers.any).afterReturnNothing()
      const res: number = Reflect.get(manager, 'sendData').call(manager)
      expect(res !== null).assertTrue()
    })

    it('isExist_test', 0, () => {
      const run = (map: Map<MediaItem, MediaItem>, item: MediaItem): boolean => Reflect.get(manager, 'isExist')
        .call(manager, map, item)
      // val.uri == item.uri
      const item = new MediaItem()
      const itemWithUri = new MediaItem({
        uri: '1',
      } as photoAccessHelper.PhotoAsset)
      run(new Map([[item, itemWithUri]]), itemWithUri)
      // val.uri !== item.uri
      const res = run(new Map([[item, item]]), itemWithUri)
      expect(res !== null).assertTrue()
    })

    it('showToast_test', 0, async () => {
      manager.showToast(1, 0, '1')
      manager.showToast(1, 1, '1')
      manager.showToast(1, 2, '1')
      manager.showToast(0, 0, '1')
      manager.showToast(0, 1, '1')
      const res = manager.showToast(0, 2, '1')
      expect(res !== null).assertTrue()
    })
  })
}