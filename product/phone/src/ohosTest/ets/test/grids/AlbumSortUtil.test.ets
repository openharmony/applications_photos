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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  AlbumSortUtil,
  syncAlbumsOrderByNameInSection,
  updateAlbumSortOrder,
  updateDefaultAlbumSortOrder
} from '@ohos/common/src/main/ets/default/utils/AlbumSortUtil';
import { AlbumOrderSection,
  AlbumOrderStatus,
  AlbumOrderType } from '@ohos/common/src/main/ets/default/model/common/AlbumSortConstants';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { AlbumOrder, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';
import { QueryAlbumParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

export default function AlbumSortUtilTest() {
  describe('AlbumSortUtilTest', () => {
    const TAG: string = 'common_AlbumSortUtil';
    it('should_not_change_myAlbumAreaIsValid_when_myAlbumAreaOrderType_is_not_SORT_BY_NAME', 0, async () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      let myAlbumAreaOrderType = AlbumOrderType.CUSTOM_SORT; // 设置为非 SORT_BY_NAME
      albumSortUtil.setMyAlbumAreaOrderType(myAlbumAreaOrderType);
      albumSortUtil.setMyAlbumAreaIsValid(true); // 初始状态
      await albumSortUtil.updateMyAlbumAreaStatus();
      const myAlbumAreaIsValid: boolean = albumSortUtil.getMyAlbumAreaIsValid();
      expect(myAlbumAreaIsValid).assertTrue();
    });

    it('should_set_myAlbumAreaIsValid_to_false_when_myAlbumAreaOrderType_is_SORT_BY_NAME_and_has_unsorted_albums', 0, async () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      let myAlbumAreaOrderType = AlbumOrderType.SORT_BY_NAME; // 设置为 SORT_BY_NAME
      albumSortUtil.setMyAlbumAreaOrderType(myAlbumAreaOrderType);
      albumSortUtil.setMyAlbumAreaIsValid(true); // 初始状态

      const mocker = new MockKit();
      const mockFunc = mocker.mockFunc(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().checkForUnsortedAlbums);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      await albumSortUtil.updateMyAlbumAreaStatus();
      const myAlbumAreaIsValid: boolean = albumSortUtil.getMyAlbumAreaIsValid();
      expect(myAlbumAreaIsValid).assertFalse();
      mocker.ignoreMock(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().checkForUnsortedAlbums);
    });

    it('should_not_change_myAlbumAreaIsValid_when_myAlbumAreaOrderType_is_SORT_BY_NAME_and_no_unsorted_albums', 0, async () => {
      const albumSortUtil = AlbumSortUtil.getInstance();

      let myAlbumAreaOrderType = AlbumOrderType.SORT_BY_NAME; // 设置为 SORT_BY_NAME
      albumSortUtil.setMyAlbumAreaOrderType(myAlbumAreaOrderType);
      albumSortUtil.setMyAlbumAreaIsValid(true); // 初始状态

      const mocker = new MockKit();
      const mockFunc = mocker.mockFunc(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().checkForUnsortedAlbums);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      await albumSortUtil.updateMyAlbumAreaStatus();
      const myAlbumAreaIsValid: boolean = albumSortUtil.getMyAlbumAreaIsValid();
      expect(myAlbumAreaIsValid).assertTrue();
      mocker.ignoreMock(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().checkForUnsortedAlbums);
    });

    it('should_set_albumListAreaIsValid_to_true_when_input_is_true', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      albumSortUtil.setAlbumListAreaIsValid(true);
      expect(albumSortUtil.getAlbumListAreaIsValid()).assertTrue();
    });

    it('should_set_albumListAreaIsValid_to_false_when_input_is_false', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      albumSortUtil.setAlbumListAreaIsValid(false);
      expect(albumSortUtil.getAlbumListAreaIsValid()).assertFalse();
    });

    it('should_call_setMyAlbumAreaOrderType_when_section_is_MY_ALBUMS_AREA', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      const mocker = new MockKit();

      const mockSetMyAlbumAreaOrderType = mocker.mockFunc(albumSortUtil, albumSortUtil.setMyAlbumAreaOrderType);
      when(mockSetMyAlbumAreaOrderType)(ArgumentMatchers.any).afterReturnNothing();

      albumSortUtil.setSectionOrderType(AlbumOrderSection.MY_ALBUMS_AREA, AlbumOrderType.CUSTOM_SORT);

      mocker.verify('setMyAlbumAreaOrderType', [AlbumOrderType.CUSTOM_SORT]).atLeast(1);
      mocker.ignoreMock(albumSortUtil, albumSortUtil.setMyAlbumAreaOrderType);
    });

    it('should_call_setAlbumListAreaOrderType_when_section_is_SOURCE_ALBUMS_AREA', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      const mocker = new MockKit();

      const mockSetAlbumListAreaOrderType = mocker.mockFunc(albumSortUtil, albumSortUtil.setAlbumListAreaOrderType);
      when(mockSetAlbumListAreaOrderType)(ArgumentMatchers.any).afterReturnNothing();

      albumSortUtil.setSectionOrderType(AlbumOrderSection.SOURCE_ALBUMS_AREA, AlbumOrderType.CUSTOM_SORT);

      mocker.verify('setAlbumListAreaOrderType', [AlbumOrderType.CUSTOM_SORT]).atLeast(1);
      mocker.ignoreMock(albumSortUtil, albumSortUtil.setAlbumListAreaOrderType);
    });

    it('should_log_error_when_section_is_unsupported', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      const mocker = new MockKit();

      const mockLogError = mocker.mockFunc(Log, Log.error);
      when(mockLogError)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();

      albumSortUtil.setSectionOrderType(999, AlbumOrderType.CUSTOM_SORT);

      mocker.verify('error', [TAG, `Unsupported album section: 999`]).atLeast(1);
      mocker.ignoreMock(Log, Log.error);
    });

    //测试resetAllSectionsSorting
    it('resetAllSectionsSorting_when_functions_execute_once', 0, () => {
      let mocker = new MockKit();
      let albumSortUtil: AlbumSortUtil = AlbumSortUtil.getInstance();
      mocker.mockFunc(albumSortUtil, albumSortUtil.setAlbumListAreaOrderType);
      let orderType: AlbumOrderType = AlbumOrderType.CUSTOM_SORT;
      albumSortUtil.resetAllSectionsSorting();
      mocker.verify('setAlbumListAreaOrderType', [orderType]).once();
      mocker.ignoreMock(albumSortUtil, albumSortUtil.setAlbumListAreaOrderType);
      mocker.clear(albumSortUtil);
    });

    //测试resetAllSectionsValidity
    it('resetAllSectionsValidity_when_functions_execute_once', 0, () => {
      let mocker = new MockKit();
      let albumSortUtil: AlbumSortUtil = AlbumSortUtil.getInstance();
      mocker.mockFunc(albumSortUtil, albumSortUtil.setAlbumListAreaIsValid);
      albumSortUtil.resetAllSectionsValidity();
      mocker.verify('setAlbumListAreaIsValid', [true]).once();
      mocker.ignoreMock(albumSortUtil, albumSortUtil.setAlbumListAreaIsValid);
      mocker.clear(albumSortUtil);
    });

    //测试syncAlbumsOrderByNameInSection: orderSection.length = 0
    it('syncAlbumsOrderByNameInSection_when_orderSection_length_zero', 0, async() => {
      let param: QueryAlbumParam = {
        filterMediaType: 'string',
        uris: ['string'],
        start: 1,
        count: 1,
        hasItemsOnly: true,
        blackUriList: ['string'],
        nameOnly: true,
        orderSection: [],
        orderStyle: 1,
      }
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.error);
      await syncAlbumsOrderByNameInSection(param);
      mocker.verify('error', [TAG, 'syncAlbumsOrderByNameInSection orderSection is wrong']).atLeast(1);
      mocker.ignoreMock(Log, Log.error);
    });

    //orderSection.length = 2
    it('syncAlbumsOrderByNameInSection_when_orderSection_length_is_two', 0, async() => {
      let param: QueryAlbumParam = {
        filterMediaType: 'string',
        uris: ['string'],
        start: 1,
        count: 1,
        hasItemsOnly: true,
        blackUriList: ['string'],
        nameOnly: true,
        orderSection: [1, 2],
        orderStyle: 1,
      }
      await syncAlbumsOrderByNameInSection(param);
      const res = AlbumSortUtil.getInstance().getMyAlbumAreaIsValid();
      expect(res).assertTrue();
    });

    //orderSection.length = 1
    it('syncAlbumsOrderByNameInSection_when_orderSection_length_is_one', 0, async() => {
      let param: QueryAlbumParam = {
        filterMediaType: 'string',
        uris: ['string'],
        start: 1,
        count: 1,
        hasItemsOnly: true,
        blackUriList: ['string'],
        nameOnly: true,
        orderSection: [1],
        orderStyle: 1,
      }
      await syncAlbumsOrderByNameInSection(param);
      const res = AlbumSortUtil.getInstance().getMyAlbumAreaIsValid();
      expect(res).assertTrue();
    });


    //测试updateAlbumSortOrder: input_is_null
    it('updateAlbumSortOrder_when_input_is_null', 0, async() => {
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      let sourceAlbums: AlbumOrder[] = [];
      let targetAlbums: AlbumOrderInfo[] = [];
      updateAlbumSortOrder(sourceAlbums, targetAlbums);
      mocker.verify('info', [TAG, `updateAlbumSortOrder sourceAlbums:${sourceAlbums.length} targetAlbums:${targetAlbums.length}`]).atLeast(1);
      mocker.ignoreMock(Log, Log.info);
    });

    it('should_update_sourceAlbums_when_lengths_are_equal', 0, () => {
      let sourceAlbums: AlbumOrder[] = [
        {
          albumId: 1,
          albumOrder: 0,
          orderSection: 0,
          orderType: 0,
          orderStatus: 0
        },
        {
          albumId: 2,
          albumOrder: 0,
          orderSection: 0,
          orderType: 0,
          orderStatus: 0
        }
      ];

      let albumOrderInfo1 = new AlbumOrderInfo();
      albumOrderInfo1.albumId = 1;
      albumOrderInfo1.albumOrderSection = 1;
      albumOrderInfo1.albumOrderType = 1;
      albumOrderInfo1.orderStatus = AlbumOrderStatus.INVALID;

      let albumOrderInfo2 = new AlbumOrderInfo();
      albumOrderInfo2.albumId = 2;
      albumOrderInfo2.albumOrderSection = 2;
      albumOrderInfo2.albumOrderType = 2;
      albumOrderInfo2.orderStatus = AlbumOrderStatus.VALID;

      let targetAlbums: AlbumOrderInfo[] = [albumOrderInfo1, albumOrderInfo2];


      updateAlbumSortOrder(sourceAlbums, targetAlbums);
      expect(sourceAlbums[0].albumId).assertEqual(1);
      expect(sourceAlbums[0].albumOrder).assertEqual(1);
      expect(sourceAlbums[0].orderSection).assertEqual(1);
      expect(sourceAlbums[0].orderType).assertEqual(1);
      expect(sourceAlbums[0].orderStatus).assertEqual(AlbumOrderStatus.VALID);

      expect(sourceAlbums[1].albumId).assertEqual(2);
      expect(sourceAlbums[1].albumOrder).assertEqual(2);
      expect(sourceAlbums[1].orderSection).assertEqual(2);
      expect(sourceAlbums[1].orderType).assertEqual(2);
      expect(sourceAlbums[1].orderStatus).assertEqual(AlbumOrderStatus.VALID);

    });

    it('should_update_sourceAlbums_and_truncate_when_source_is_longer', 0, () => {
      // 初始化源相册数组，包含三个元素
      let sourceAlbums: AlbumOrder[] = [
        {
          albumId: 1,
          albumOrder: 0,
          orderSection: 0,
          orderType: 0,
          orderStatus: 0
        },
        {
          albumId: 2,
          albumOrder: 0,
          orderSection: 0,
          orderType: 0,
          orderStatus: 0
        },
        {
          albumId: 3,
          albumOrder: 0,
          orderSection: 0,
          orderType: 0,
          orderStatus: 0
        }
      ];

      // 初始化目标相册数组，包含两个元素
      let albumOrderInfo1 = new AlbumOrderInfo();
      albumOrderInfo1.albumId = 1;
      albumOrderInfo1.albumOrderSection = 1;
      albumOrderInfo1.albumOrderType = 1;
      albumOrderInfo1.orderStatus = AlbumOrderStatus.INVALID;

      let albumOrderInfo2 = new AlbumOrderInfo();
      albumOrderInfo2.albumId = 2;
      albumOrderInfo2.albumOrderSection = 2;
      albumOrderInfo2.albumOrderType = 2;
      albumOrderInfo2.orderStatus = AlbumOrderStatus.VALID;

      let targetAlbums: AlbumOrderInfo[] = [albumOrderInfo1, albumOrderInfo2];

      // 调用更新相册排序顺序的方法
      updateAlbumSortOrder(sourceAlbums, targetAlbums);

      // 验证源相册数组长度是否正确，应被截断为2
      expect(sourceAlbums.length).assertEqual(2);
      // 验证第一个元素的属性是否正确更新
      expect(sourceAlbums[0].albumId).assertEqual(1);
      expect(sourceAlbums[0].albumOrder).assertEqual(1);
      expect(sourceAlbums[0].orderSection).assertEqual(1);
      expect(sourceAlbums[0].orderType).assertEqual(1);
      expect(sourceAlbums[0].orderStatus).assertEqual(AlbumOrderStatus.VALID);

      expect(sourceAlbums[1].albumId).assertEqual(2);
      expect(sourceAlbums[1].albumOrder).assertEqual(2);
      expect(sourceAlbums[1].orderSection).assertEqual(2);
      expect(sourceAlbums[1].orderType).assertEqual(2);
      expect(sourceAlbums[1].orderStatus).assertEqual(AlbumOrderStatus.VALID);
    });

    it('should_set_myAlbumAreaOrderType_to_CUSTOM_SORT', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      const originalOrderType: AlbumOrderType = albumSortUtil.getMyAlbumAreaOrderType();
      albumSortUtil.setMyAlbumAreaOrderType(AlbumOrderType.CUSTOM_SORT);
      const curOrderType: AlbumOrderType = albumSortUtil.getMyAlbumAreaOrderType();
      expect(curOrderType).assertEqual(AlbumOrderType.CUSTOM_SORT);
      // 恢复原始状态
      albumSortUtil.setMyAlbumAreaOrderType(originalOrderType);
    });

    it('should_set_myAlbumAreaOrderType_to_SORT_BY_NAME', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      const originalOrderType: AlbumOrderType = albumSortUtil.getMyAlbumAreaOrderType();
      albumSortUtil.setMyAlbumAreaOrderType(AlbumOrderType.SORT_BY_NAME);
      const curOrderType: AlbumOrderType = albumSortUtil.getMyAlbumAreaOrderType();
      expect(curOrderType).assertEqual(AlbumOrderType.SORT_BY_NAME);
      // 恢复原始状态
      albumSortUtil.setMyAlbumAreaOrderType(originalOrderType);
    });

    it('should_set_myAlbumAreaIsValid_to_true_when_called_with_true', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      albumSortUtil.setMyAlbumAreaIsValid(true);
      const myAlbumAreaIsValid: boolean = albumSortUtil.getMyAlbumAreaIsValid();
      expect(myAlbumAreaIsValid).assertTrue();
    });

    it('should_set_myAlbumAreaIsValid_to_false_when_called_with_false', 0, () => {
      const albumSortUtil = AlbumSortUtil.getInstance();
      albumSortUtil.setMyAlbumAreaIsValid(false);
      const myAlbumAreaIsValid: boolean = albumSortUtil.getMyAlbumAreaIsValid();
      expect(myAlbumAreaIsValid).assertFalse();
    });

    it('should_not_modify_empty_array', 0, () => {
      const sourceAlbums: AlbumOrder[] = [];
      updateDefaultAlbumSortOrder(sourceAlbums);
      expect(sourceAlbums.length).assertEqual(0);
    });

    it('should_modify_single_element_array', 0, () => {
      const sourceAlbums: AlbumOrder[] = [
        {
          albumId: 0,
          albumOrder: 0,
          orderSection: AlbumOrderSection.SOURCE_ALBUMS_AREA,
          orderType: AlbumOrderType.SORT_BY_NAME,
          orderStatus: AlbumOrderStatus.INVALID
        }
      ];
      updateDefaultAlbumSortOrder(sourceAlbums);
      expect(sourceAlbums[0].albumOrder).assertEqual(-1);
      expect(sourceAlbums[0].orderSection).assertEqual(AlbumOrderSection.UNSORTED_ALBUMS_AREA);
      expect(sourceAlbums[0].orderType).assertEqual(AlbumOrderType.CUSTOM_SORT);
      expect(sourceAlbums[0].orderStatus).assertEqual(AlbumOrderStatus.VALID);
    });


    it('should_modify_multiple_elements_array', 0, () => {
      // 初始化源相册数组，包含两个元素
      const sourceAlbums: AlbumOrder[] = [
        {
          albumId: 0, // 相册ID
          albumOrder: 0, // 当前排序顺序
          orderSection: AlbumOrderSection.MY_ALBUMS_AREA, // 当前排序区域
          orderType: AlbumOrderType.SORT_BY_NAME, // 当前排序类型
          orderStatus: AlbumOrderStatus.INVALID // 当前排序状态
        },
        {
          albumId: 1, // 相册ID
          albumOrder: 1, // 当前排序顺序
          orderSection: AlbumOrderSection.MY_ALBUMS_AREA, // 当前排序区域
          orderType: AlbumOrderType.SORT_BY_NAME, // 当前排序类型
          orderStatus: AlbumOrderStatus.INVALID // 当前排序状态
        }
      ];

      // 调用更新默认排序顺序的方法
      updateDefaultAlbumSortOrder(sourceAlbums);
      // 验证第一个元素的属性是否正确更新
      expect(sourceAlbums[0].albumOrder).assertEqual(-1);
      expect(sourceAlbums[0].orderSection).assertEqual(AlbumOrderSection.UNSORTED_ALBUMS_AREA);
      expect(sourceAlbums[0].orderType).assertEqual(AlbumOrderType.CUSTOM_SORT);
      expect(sourceAlbums[0].orderStatus).assertEqual(AlbumOrderStatus.VALID);
      // 验证第二个元素的属性是否正确更新
      expect(sourceAlbums[1].albumOrder).assertEqual(-1);
      expect(sourceAlbums[1].orderSection).assertEqual(AlbumOrderSection.UNSORTED_ALBUMS_AREA);
      expect(sourceAlbums[1].orderType).assertEqual(AlbumOrderType.CUSTOM_SORT);
      expect(sourceAlbums[1].orderStatus).assertEqual(AlbumOrderStatus.VALID);
    });

    it('should_set_myAlbumAreaIsValid_to_false_when_sorted_by_name_and_has_unsorted_albums', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockJudgeAlbumSortedByName: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);
      let mockCheckForUnsortedAlbums: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.checkForUnsortedAlbums);

      when(mockJudgeAlbumSortedByName)(ArgumentMatchers.any).afterReturn(true);
      when(mockCheckForUnsortedAlbums)(ArgumentMatchers.any).afterReturn(true);

      const albumSortUtil = AlbumSortUtil.getInstance();
      await albumSortUtil.judgeMyAlbumAreaIsValid();

      expect(albumSortUtil.getMyAlbumAreaIsValid()).assertFalse();
      expect(albumSortUtil.getMyAlbumAreaOrderType()).assertEqual(AlbumOrderType.SORT_BY_NAME);

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);
      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.checkForUnsortedAlbums);
    });

    it('should_set_myAlbumAreaIsValid_to_true_when_sorted_by_name_and_no_unsorted_albums', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockJudgeAlbumSortedByName: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);
      let mockCheckForUnsortedAlbums: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.checkForUnsortedAlbums);

      when(mockJudgeAlbumSortedByName)(ArgumentMatchers.any).afterReturn(true);
      when(mockCheckForUnsortedAlbums)(ArgumentMatchers.any).afterReturn(false);

      const albumSortUtil = AlbumSortUtil.getInstance();
      await albumSortUtil.judgeMyAlbumAreaIsValid();

      expect(albumSortUtil.getMyAlbumAreaIsValid()).assertTrue();
      expect(albumSortUtil.getMyAlbumAreaOrderType()).assertEqual(AlbumOrderType.SORT_BY_NAME);

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);
      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.checkForUnsortedAlbums);
    });

    it('should_set_myAlbumAreaIsValid_to_true_when_sorted_by_custom_sort', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockJudgeAlbumSortedByName: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);

      when(mockJudgeAlbumSortedByName)(ArgumentMatchers.any).afterReturn(false);

      const albumSortUtil = AlbumSortUtil.getInstance();
      await albumSortUtil.judgeMyAlbumAreaIsValid();

      expect(albumSortUtil.getMyAlbumAreaIsValid()).assertTrue();
      expect(albumSortUtil.getMyAlbumAreaOrderType()).assertEqual(AlbumOrderType.CUSTOM_SORT);

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.judgeAlbumSortedByName);
    });

  });
}

