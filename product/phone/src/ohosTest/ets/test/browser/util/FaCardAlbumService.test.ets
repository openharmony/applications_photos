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
import {
  FaCardAlbumUtils,
  getUriExistInProxyInfo
} from "@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService";
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { DataShareResultSet } from "@kit.ArkData";
import { AlbumInfo } from "@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo";
import { AlbumType } from "@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil";
import { FaCardInfo } from "@ohos/dataprovider/src/main/ets/database/service/FaCardService";
import { FormControllerManager } from "@ohos/dataprovider/src/main/ets/controller/FormControllerManager";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { PhotoAsset } from "@ohos/common/src/main/ets/default/access/UserFileManagerAccess";
import { ImageInfo } from "@ohos/dataprovider/src/main/ets/database/service/ReminderService";
import { UserFileManagerAccess, PhotoAlbum } from "@ohos/common/src/main/ets/default/access/UserFileManagerAccess";
import { PhotoAccessHelperAccess } from "@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess";

export default function FaCardAlbumServiceUT() {
  describe('FaCardAlbumServiceUT', () => {
    let utils: FaCardAlbumUtils
    let mocker: MockKit

    beforeEach(() => {
      utils = new FaCardAlbumUtils({} as Context)
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll()
    })

    it('getUriExistInProxyInfo_case_one', 0, () => {
      // !resultSet
      const res = getUriExistInProxyInfo([], undefined)
      expect(res !== null).assertTrue()
    })

    it('getUriExistInProxyInfo_case_two', 0, () => {
      // resultSet
      const res = getUriExistInProxyInfo([],
        {
          getColumnIndex: str => 1,
          goToFirstRow: () => false,
          goToNextRow: () => false,
          getString: num => '1'
        } as DataShareResultSet)
      expect(res !== null).assertTrue()
    })

    it('getUriExistInProxyInfo_case_three', 0, () => {
      // resultSet.goToFirstRow()
      const res = getUriExistInProxyInfo([],
        {
          getColumnIndex: str => 1,
          goToFirstRow: () => true,
          goToNextRow: () => false,
          getString: num => '1'
        } as DataShareResultSet)
      expect(res !== null).assertTrue()
    })

    it('handleClick_case_one', 0, () => {
      // !album
      const run = (album?: ArgumentMatchers) => utils.handleClick(album as AlbumInfo, '', 1, AlbumType.CATEGORY)
      run('')
      expect(run !== null).assertTrue()
    })

    it('handleClick_case_two', 0, () => {
      // album
      const res = utils.handleClick(new AlbumInfo(), '1', 1, AlbumType.CATEGORY)
      expect(res !== null).assertTrue()
    })

    it('updateFaCardDb_case_one', 0, () => {
      // FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res = utils.updateFaCardDb(new AlbumInfo(), {} as FaCardInfo)
      expect(res !== null).assertTrue()
    })

    it('updateFaCardDb_case_two', 0, () => {
      // !FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res = utils.updateFaCardDb(new AlbumInfo(), {} as FaCardInfo)
      expect(res !== null).assertTrue()
    })

    it('insertReminderAndImage_case_one', 0, () => {
      // FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res: boolean = Reflect.get(utils, 'insertReminderAndImage').call(utils, new AlbumInfo(), {} as FaCardInfo)
      expect(res !== null).assertTrue()
    })

    it('insertReminderAndImage_case_two', 0, () => {
      // !FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res: boolean = Reflect.get(utils, 'insertReminderAndImage').call(utils, new AlbumInfo(), {} as FaCardInfo)
      expect(res !== null).assertTrue()
    })

    it('insertReminderAndImage_case_three', 0, () => {
      // !album
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res: boolean = Reflect.get(utils, 'insertReminderAndImage').call(utils, '', {} as FaCardInfo)
      expect(res !== null).assertTrue()
    })

    it('getAlbumAssets_case_one', 0, () => {
      // !fetchResult
      const album = {} as PhotoAlbum
      when(mocker.mockFunc(album, album.getAssets))(ArgumentMatchers.any).afterReturn(false)
      const res = utils.getAlbumAssets(album, 1, 1)
      expect(res !== null).assertTrue()
    })

    it('getAlbumAssets_case_two', 0, () => {
      // fetchResult
      const album = {} as PhotoAlbum
      when(mocker.mockFunc(album, album.getAssets))(ArgumentMatchers.any).afterReturn(true)
      const res = utils.getAlbumAssets(album, 1, 1)
      expect(res !== null).assertTrue()
    })

    it('getAlbumAssets_case_three', 0, () => {
      // fetchResult
      const album = {} as PhotoAlbum
      const asset = {} as photoAccessHelper.FetchResult<PhotoAsset>
      when(mocker.mockFunc(album, album.getAssets))(ArgumentMatchers.any).afterReturn(asset)
      when(mocker.mockFunc(asset, asset.getCount))(ArgumentMatchers.any).afterReturn(true)
      const res = utils.getAlbumAssets(album, 1, 1)
      expect(res !== null).assertTrue()
    })

    it('getAlbumAssets_case_four', 0, () => {
      // !fetchResult
      const album = {} as PhotoAlbum
      const asset = {} as photoAccessHelper.FetchResult<PhotoAsset>
      when(mocker.mockFunc(album, album.getAssets))(ArgumentMatchers.any).afterReturn(asset)
      when(mocker.mockFunc(asset, asset.getCount))(ArgumentMatchers.any).afterReturn(false)
      const res = utils.getAlbumAssets(album, 1, 1)
      expect(res !== null).assertTrue()
    })

    it('getAssetsByTurn_case_one', 0, () => {
      // result.length < count
      const res = utils.getAssetsByTurn({} as PhotoAlbum, 1, 1, 1)
      expect(res !== null).assertTrue()
    })

    it('getAssetsByTurn_case_two', 0, () => {
      // !result.length < count
      const res = utils.getAssetsByTurn({} as PhotoAlbum, 1, -1, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_one', 0, () => {
      // FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res = utils.insertNewTurnReminderAndImage(new UserFileManagerAccess(), {} as FaCardInfo, {} as ImageInfo,
        {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_two', 0, () => {
      // !faCardInfo.albumUri
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res = utils.insertNewTurnReminderAndImage(new UserFileManagerAccess(), {} as FaCardInfo, {} as ImageInfo,
        {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_three', 0, () => {
      // !photoAlbum
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(false)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1' } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_four', 0, () => {
      // photoAlbum.albumType === photoAccessHelper.AlbumType.SMART
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1' } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_five', 0, () => {
      // !photoAlbum.albumType === photoAccessHelper.AlbumType.SMART
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = {} as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1' } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_six', 0, () => {
      // photoAlbum.count == 0
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART, count: 0 } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1' } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_seven', 0, () => {
      // !photoAlbum.count == 0
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART, count: 1 } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      when(mocker.mockFunc(PhotoAccessHelperAccess,
        PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount))(ArgumentMatchers.any).afterReturn(1)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1' } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_eight', 0, () => {
      // imageCount <= perTurnInsertAmount
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART, count: 1 } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      when(mocker.mockFunc(PhotoAccessHelperAccess,
        PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount))(ArgumentMatchers.any).afterReturn(1)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1', playbackInterval: 1 } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_nine', 0, () => {
      // perTurnInsertAmount > remainCount
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART, count: 1 } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      when(mocker.mockFunc(PhotoAccessHelperAccess,
        PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount))(ArgumentMatchers.any).afterReturn(180)
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1', playbackInterval: 100 } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertNewTurnReminderAndImage_case_ten', 0, () => {
      // perTurnInsertAmount > remainCount
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access = new UserFileManagerAccess()
      const album = { albumType: photoAccessHelper.AlbumType.SMART, count: 1 } as PhotoAlbum
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(album)
      when(mocker.mockFunc(PhotoAccessHelperAccess,
        PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount))(ArgumentMatchers.any).afterReturn(1)
      when(mocker.mockFunc(utils, utils.getAssetsByTurn))(ArgumentMatchers.any).afterReturn([1])
      const res = utils.insertNewTurnReminderAndImage(access, { albumUri: '1', playbackInterval: 1 } as FaCardInfo,
        {} as ImageInfo, {} as ImageInfo, 1)
      expect(res !== null).assertTrue()
    })

    it('insertSinglePhoto_case_one', 0, () => {
      // FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res = FaCardAlbumUtils.insertSinglePhoto({} as PhotoAsset, '1', {} as Context, '1')
      expect(res !== null).assertTrue()
    })

    it('insertSinglePhoto_case_two', 0, () => {
      // !context
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const run =
        (context?: Context) => FaCardAlbumUtils.insertSinglePhoto({} as PhotoAsset, '1', context as Context, '1')
      run()
      expect(run !== null).assertTrue()
    })

    it('insertSinglePhoto_case_three', 0, () => {
      // !context
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res = FaCardAlbumUtils.insertSinglePhoto({} as PhotoAsset, '1', {} as Context, '1')
      expect(res !== null).assertTrue()
    })
  })
}