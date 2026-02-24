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
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { DataWindow } from '@ohos/common/src/main/ets/default/utils/DataSourceWindowUtil';
import { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import {
  QueryParam
} from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { SimpleGridMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SimpleGridMediaItem';
import util from '@ohos.util';
import { LoadingInfo } from '@ohos/common/src/main/ets/default/model/DataSource';
import { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

const NUMBER_ONE: number = 1;

export default function MediaDataSourceTest() {
  describe('MediaDataSourceTest', () => {
    class MyQueryParam implements QueryParam {
      // 实现接口的属性和方法
    }

    let queryParam = new MyQueryParam();

    it('should_return_when_item_uniqueId_is_undefined', 0, () => {
      let item: MediaItem | undefined = undefined;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.releaseViewDataCache(item);
      expect(mediaDatasource.viewDataCache.size).assertEqual(0);
    });

    it('should_delete_item_from_viewDataCache_when_item_uniqueId_is_valid', 0, () => {
      let item: MediaItem = new MediaItem();
      item.uniqueId = '123';
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.viewDataCache.set(item.uniqueId, new ViewData());
      mediaDatasource.releaseViewDataCache(item);
      expect(mediaDatasource.viewDataCache.size).assertEqual(0);
    });

    it('should_return_false_when_isDataSourceMode_is_false', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      Reflect.set(mediaDatasource, 'isDataSourceMode', false)
      expect(mediaDatasource.getDataSourceMode()).assertEqual(false);
    });

    it('should_return_true_when_isDataSourceMode_is_true', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      Reflect.set(mediaDatasource, 'isDataSourceMode', true)
      expect(mediaDatasource.getDataSourceMode()).assertEqual(true);
    });

    it('should_set_deleteIndex_correctly', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setDeleteIndex(5);
      expect(mediaDatasource.deleteIndex).assertEqual(5);
    });

    it('should_return_when_enableGetDataFlag_is_false', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.enableGetDataFlag = false;
      mediaDataSource.setYearMonthDayViewIndex(5);
      expect(mediaDataSource.yearMonthDayViewIndex).assertEqual(0);
    });

    it('should_set_yearMonthDayViewIndex_when_enableGetDataFlag_is_true', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.enableGetDataFlag = true;
      mediaDataSource.setYearMonthDayViewIndex(5);
      expect(mediaDataSource.yearMonthDayViewIndex).assertEqual(5);
    });

    it('should_return_deleteIndex_when_deleteIndex_is_set', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.deleteIndex = 5;
      expect(mediaDatasource.getDeleteIndex()).assertEqual(5);
    });

    it('should_return_minus_one_when_deleteIndex_is_not_set', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      expect(mediaDatasource.getDeleteIndex()).assertEqual(-1);
    });

    it('should_return_correct_total_count_when_invalidUris_is_empty', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.invalidUris = [];
      mediaDataSource.size = 100;
      expect(mediaDataSource.totalCount()).assertEqual(100);
    });

    it('should_return_correct_total_count_when_invalidUris_is_not_empty', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.invalidUris = ['uri1', 'uri2'];
      mediaDataSource.size = 100;
      expect(mediaDataSource.totalCount()).assertEqual(98);
    });

    it('should_return_correct_total_count_when_lastTotalCount_is_different_from_size', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.invalidUris = [];
      mediaDataSource.size = 100;
      mediaDataSource.lastTotalCount = 50;
      expect(mediaDataSource.totalCount()).assertEqual(100);
    });

    it('should_return_previewItems_when_getPreviewArray_is_called', 0, () => {
      let mediaItem1: MediaItem = new MediaItem();
      let mediaItem2: MediaItem = new MediaItem();
      let mediaItem3: MediaItem = new MediaItem();
      let previewItems: MediaItem[] = [mediaItem1, mediaItem2, mediaItem3];

      let mediaDataSource: MediaDataSource = new MediaDataSource(10, undefined, false, undefined);
      Reflect.set(mediaDataSource, 'previewItems', previewItems);

      const result = mediaDataSource.getPreviewArray();
      expect(result).assertDeepEquals(previewItems);

    });

    it('should_clear_preview_items_when_called', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.clearPreviewArray();
      const previewItems: MediaItem[] = Reflect.get(mediaDataSource, 'previewItems');
      expect(previewItems.length).assertEqual(0);
    });

    it('should_return_undefined_when_enableGetDataFlag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableGetDataFlag = false;
      const result = mediaDatasource.getData(0);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_getWrappedData_returns_undefined', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mediaDatasource, mediaDatasource.getWrappedData);
      when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(undefined);
      const result = mediaDatasource.getData(0);
      expect(result).assertUndefined();
      mocker.ignoreMock(mediaDatasource, mediaDatasource.getWrappedData);
    });

    it('should_return_undefined_when_getWrappedData_returns_undefined_and_index_is_-1', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mediaDatasource, mediaDatasource.getWrappedData);
      when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(undefined);
      const result = mediaDatasource.getData(-1);
      expect(result).assertUndefined();
      mocker.ignoreMock(mediaDatasource, mediaDatasource.getWrappedData);
    });

    it('should_return_undefined_when_dataIndex_is_out_of_range', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      let result = mediaDatasource.getRawData(-1);
      expect(result).assertUndefined();
    });

    it('should_return_mediaItem_when_dataIndex_is_in_range', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      let res = mediaDatasource.getRawData(5);
      expect(res).assertUndefined();
    });

    it('should_return_undefined_when_dataIndex_is_equal_to_activeEnd', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.activeEnd = 10;
      let result = mediaDatasource.getRawData(10);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_dataIndex_is_less_than_activeStart', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.activeStart = 5;
      let result = mediaDatasource.getRawData(3);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_dataIndex_is_greater_than_or_equal_to_activeEnd', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.activeEnd = 10;
      let result = mediaDatasource.getRawData(11);
      expect(result).assertUndefined();
    });

    it('should_return_empty_array_when_photoDataImpl_getDataByBurstKey_returns_null', 0, async () => {
      let burstKey: string = 'testKey';
      let isTrash: boolean = false;
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let mocker: MockKit = new MockKit();
      const result = await mediaDataSource.getMediaItemsByBurstKey(burstKey, isTrash);
      expect(result).assertDeepEquals([]);
      mocker.ignoreMock(mediaDataSource.photoDataImpl, mediaDataSource.photoDataImpl.getDataByBurstKey);
    });

    it('should_return_empty_array_when_photoDataImpl_getDataByBurstKey_and_burstKey_is_null', 0, async () => {
      let burstKey: string = '';
      let isTrash: boolean = false;
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let mocker: MockKit = new MockKit();
      const result = await mediaDataSource.getMediaItemsByBurstKey(burstKey, isTrash);
      expect(result).assertDeepEquals([]);
      mocker.ignoreMock(mediaDataSource.photoDataImpl, mediaDataSource.photoDataImpl.getDataByBurstKey);
    });

    it('should_return_Constants_NOT_FOUND_when_item_is_undefined', 0, () => {
      let item: MediaItem | undefined = undefined;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.getDataIndex(item);
      expect(result).assertEqual(Constants.NOT_FOUND);
    });

    it('should_return_index_when_item_is_found_in_items', 0, () => {
      let item: MediaItem = new MediaItem();
      item.uniqueId = 'uniqueId1';
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.items = [item];
      let result = mediaDatasource.getDataIndex(item);
      expect(result).assertEqual(0 + mediaDatasource.activeStart);
    });

    it('should_return_Constants_NOT_FOUND_when_item_is_not_found_in_items', 0, () => {
      let item: MediaItem = new MediaItem();
      item.uniqueId = 'uniqueId2';
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.items = [new MediaItem()];
      let result = mediaDatasource.getDataIndex(item);
      expect(result).assertEqual(Constants.NOT_FOUND);
    });

    it('should_return_mediaItem_when_uri_matches', 0, () => {
      let uri: string = 'file://media/123';
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.uri = uri;
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      mediaDataSource.items = [mediaItem];
      const result = mediaDataSource.getItemByUri(uri);
      expect(result).assertDeepEquals(mediaItem);
    });

    it('should_return_newMediaItem_when_uri_not_matches', 0, () => {
      let uri: string = 'file://media/123';
      let mediaItem: MediaItem = new MediaItem();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      mediaDataSource.items = [mediaItem];
      const result = mediaDataSource.getItemByUri(uri);
      expect(result).assertDeepEquals(new MediaItem());
    });

    it('should_return_mediaItem_when_path_matches', 0, () => {
      let path: string = 'path/to/mediaItem';
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.path = path;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      mediaDatasource.items = [mediaItem];
      let result: MediaItem = mediaDatasource.getItemByPath(path);
      expect(result).assertEqual(mediaItem);
    });

    it('should_return_newMediaItem_when_path_not_matches', 0, () => {
      let path: string = 'path/to/mediaItem';
      let mediaItem: MediaItem = new MediaItem()
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      mediaDataSource.items = [mediaItem];
      const result = mediaDataSource.getItemByPath(path);
      expect(result).assertDeepEquals(new MediaItem());
    });

    it('should_return_correct_index_when_uri_matches', 0, async () => {
      let uri = 'file://media/12345';
      let mediaItem = new MediaItem();
      mediaItem.uri = uri;
      let mediaDataSource = new MediaDataSource(10, new PhotoDataImpl());
      mediaDataSource.items = [mediaItem];
      mediaDataSource.activeStart = 5;
      const result = mediaDataSource.getDataIndexByUri(uri);
      expect(result).assertEqual(5);
    });

    it('should_return_NOT_FOUND_when_uri_does_not_match', 0, async () => {
      let uri = 'file://media/12345';
      let mediaItem = new MediaItem();
      mediaItem.uri = 'file://media/67890';
      let mediaDataSource = new MediaDataSource(10, new PhotoDataImpl());
      mediaDataSource.items = [mediaItem];
      mediaDataSource.activeStart = 5;
      const result = mediaDataSource.getDataIndexByUri(uri);
      expect(result).assertEqual(Constants.NOT_FOUND);
    });

    it('should_return_NOT_FOUND_when_items_is_empty', 0, async () => {
      let uri = 'file://media/12345';
      let mediaDataSource = new MediaDataSource(10, new PhotoDataImpl());
      mediaDataSource.items = [];
      mediaDataSource.activeStart = 5;
      const result = mediaDataSource.getDataIndexByUri(uri);
      expect(result).assertEqual(Constants.NOT_FOUND);
    });

    it('should_return_undefined_when_items_and_cameraItems_are_empty', 0, () => {
      let uri: string = 'testUri';
      let itemNotifyCallback: Function = () => {
      };
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.cameraItems = [];
      mediaDataSource.items = [];
      const result = mediaDataSource.getMediaItemByUriFromAll(uri, itemNotifyCallback);
      expect(result).assertUndefined();
    });

    it('should_return_item_when_uri_matches_in_items', 0, () => {
      let uri: string = 'testUri';
      let itemNotifyCallback: Function = () => {
      };
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let item: MediaItem = new MediaItem();
      item.uri = uri;
      mediaDataSource.cameraItems = [];
      mediaDataSource.items = [item];
      const result = mediaDataSource.getMediaItemByUriFromAll(uri, itemNotifyCallback);
      expect(result).assertDeepEquals(item);
    });

    it('should_return_item_when_uri_matches_not_in_items', 0, () => {
      let uri: string = 'testUri';
      let uri1: string = 'testUri1';
      let itemNotifyCallback: Function = () => {
      };
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let item: MediaItem = new MediaItem();
      item.uri = uri;
      mediaDataSource.cameraItems = [];
      mediaDataSource.items = [item];
      const result = mediaDataSource.getMediaItemByUriFromAll(uri1, itemNotifyCallback);
      expect(result).assertEqual(undefined);
    });

    it('should_return_item_when_uri_matches_in_cameraItems', 0, () => {
      let uri: string = 'testUri';
      let itemNotifyCallback: Function = () => {
      };
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let item: MediaItem = new MediaItem();
      item.uri = uri;
      mediaDataSource.cameraItems = [item];
      mediaDataSource.items = [];
      const result = mediaDataSource.getMediaItemByUriFromAll(uri, itemNotifyCallback);
      expect(result).assertDeepEquals(item);
    });

    it('should_return_mediaCount_when_getMediaCount_is_called', 0, () => {
      let mediaCount: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.mediaCount = mediaCount;
      const result = mediaDatasource.getMediaCount();
      expect(result).assertEqual(mediaCount);
    });

    it('should_reset_active_window_correctly', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.resetActiveWindow();
      expect(mediaDatasource.activeStart).assertEqual(0);
      expect(mediaDatasource.activeEnd).assertEqual(windowSize);
      expect(mediaDatasource.items.length).assertEqual(windowSize);
    });

    it('isSupportChangeCountByNotify_test', 0, async () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let uri: string = 'file://test/123';
      mediaDataSource.albumUri = uri;
      let res: boolean | undefined  = Reflect.get(mediaDataSource, 'isSupportChangeCountByNotify').call(mediaDataSource);
      expect(res).assertEqual(undefined);
    });

    it('isSupportChangeCountByNotify_test_when_albumUri_is_null', 0, async () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let res: boolean | undefined = Reflect.get(mediaDataSource, 'isSupportChangeCountByNotify').call(mediaDataSource);
      expect(res).assertEqual(false);
    });

    it('should_return_true_when_uri_is_in_cache', 0, () => {
      let uri: string = 'file://test/123';
      let indexNotifyCallback: Function = (index: number) => {
      };
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.uri = uri;
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      mediaDataSource.items = [mediaItem];
      let result = mediaDataSource.isUriInCache(uri, indexNotifyCallback);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_uri_is_not_in_cache', 0, () => {
      let uri: string = 'file://test/123';
      let indexNotifyCallback: Function = (index: number) => {};
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      let result = mediaDataSource.isUriInCache(uri, indexNotifyCallback);
      expect(result).assertEqual(false);
    });

    it('updateSize_test_when', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.hasNewChange = true;
      let count = 10;
      mediaDataSource.updateSize(1, count);
      let mediaCount: number = Reflect.get(mediaDataSource, 'mediaCount');
      expect(mediaCount).assertEqual(count);
    });

    it('should_call_updateSize_when_mediaItems_is_not_null', 0, () => {
      let mediaItem: MediaItem = new MediaItem();
      let mediaItems: MediaItem[] = [mediaItem];
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.updateCountThroughMediaItems(10, mediaItems);
      let mediaCount: number = Reflect.get(mediaDataSource, 'mediaCount');
      expect(mediaCount).assertEqual(1);
    });

    it('should_call_triggerDataRefresh_when_clearData_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mocker.mockFunc(mediaDataSource, mediaDataSource.triggerDataRefresh);
      mediaDataSource.clearData(0, 10);
      mocker.verify('triggerDataRefresh', [0, 10]).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.triggerDataRefresh);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_triggerDataRefresh_when_isCountChanged_is_true_and_broadCast_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.isCountChanged = true;
      mocker.mockFunc(mediaDataSource, mediaDataSource.onDataReloaded);
      mediaDataSource.triggerDataRefresh(0, 10);
      mocker.verify('onDataReloaded', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onDataReloaded);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_enableGetDataFlag_to_true_when_flag_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableGetData(true);
      expect(mediaDatasource.enableGetDataFlag).assertEqual(true);
    });

    it('should_set_enableGetDataFlag_to_false_when_flag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableGetData(false);
      expect(mediaDatasource.enableGetDataFlag).assertEqual(false);
    });

    it('should_set_enableQueryDataFlag_to_true_when_flag_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableQueryData(true);
      let enableQueryDataFlag: boolean = Reflect.get(mediaDatasource, 'enableQueryDataFlag')
      expect(enableQueryDataFlag).assertEqual(true);
    });

    it('should_set_enableQueryDataFlag_to_false_when_flag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableQueryData(false);
      let enableQueryDataFlag: boolean = Reflect.get(mediaDatasource, 'enableQueryDataFlag')
      expect(enableQueryDataFlag).assertEqual(false);
    });

    it('should_set_enableSlidingWindowFlag_to_true_when_flag_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableSlidingWindow(true);
      let enableSlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableSlidingWindowFlag')
      expect(enableSlidingWindowFlag).assertEqual(true);
    });

    it('should_set_enableSlidingWindowFlag_to_false_when_flag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableSlidingWindow(false);
      let enableSlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableSlidingWindowFlag')
      expect(enableSlidingWindowFlag).assertEqual(false);
    });

    it('should_set_enableDaySlidingWindowFlag_to_true_when_flag_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableDaySlidingWindow(true);
      let enableDaySlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableDaySlidingWindowFlag')
      expect(enableDaySlidingWindowFlag).assertEqual(true);
    });

    it('should_set_enableDaySlidingWindowFlag_to_false_when_flag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableDaySlidingWindow(false);
      let enableDaySlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableDaySlidingWindowFlag')
      expect(enableDaySlidingWindowFlag).assertEqual(false);
    });

    it('should_set_enableGroupSlidingWindowFlag_to_true_when_flag_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableGroupSlidingWindow(true);
      let enableGroupSlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableGroupSlidingWindowFlag')
      expect(enableGroupSlidingWindowFlag).assertEqual(true);
    });

    it('should_set_enableGroupSlidingWindowFlag_to_false_when_flag_is_false', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.enableGroupSlidingWindow(false);
      let enableGroupSlidingWindowFlag: boolean = Reflect.get(mediaDatasource, 'enableGroupSlidingWindowFlag')
      expect(enableGroupSlidingWindowFlag).assertEqual(false);
    });

    it('should_return_when_dataIndex_is_invalid', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.updateSlidingWindow(Constants.INVALID);
      expect(mediaDatasource.activeStart).assertEqual(0);
      expect(mediaDatasource.activeEnd).assertEqual(10);
    });

    it('should_return_when_dataIndex_is_less_than_windowCenter', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.activeEnd = 10;
      mediaDatasource.updateSlidingWindow(1);
      expect(mediaDatasource.activeStart).assertEqual(0);
      expect(mediaDatasource.activeEnd).assertEqual(10);
    });

    it('should_set_albumInfo_when_albumInfo_is_not_undefined', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let albumInfo: AlbumInfo = new AlbumInfo();
      mediaDatasource.setAlbumInfo(albumInfo);
      expect(mediaDatasource.albumInfo).assertEqual(albumInfo);
    });

    it('should_set_albumInfo_when_albumInfo_is_undefined', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setAlbumInfo(undefined);
      expect(mediaDatasource.albumInfo).assertUndefined();
    });

    it('should_set_album_uri_correctly', 0, () => {
      let uri: string = "testUri";
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setAlbumUri(uri);
      expect(mediaDatasource.albumUri).assertEqual(uri);
    });

    it('should_set_filterMediaType_correctly', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setFilterMediaType('video');
      expect(mediaDatasource.filterMediaType).assertEqual('video');
    });

    it('should_set_queryParam_correctly', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setQueryParam(queryParam);
      let getQueryParam: QueryParam = Reflect.get(mediaDatasource, 'queryParam');
      expect(getQueryParam).assertEqual(queryParam);
    });

    it('should_set_broadCast_and_register_callback', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, queryParam);
      mediaDatasource.setBroadCast(broadCast);
      expect(mediaDatasource.broadCast).assertEqual(broadCast);
    });

    it('should_set_photo_broad_cast_when_broadCastParam_is_not_null', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, queryParam);
      let broadCast: BroadCast = new BroadCast();
      mediaDatasource.setPhotoBroadCast(broadCast);
      expect(mediaDatasource.photosBroadCast).assertEqual(broadCast);
    });

    it('should_set_isSourceAlbum_and_isShootOrClassAlbum_correctly', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      mediaDataSource.setAlbumType(true, true);
      expect(mediaDataSource.isSourceAlbum).assertEqual(true);
      expect(mediaDataSource.isShootOrClassAlbum).assertEqual(true);
    });

    it('should_release_photos_broad_cast_when_called', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.releasePhotoBroadCast();
      expect(mediaDatasource.photosBroadCast).assertUndefined();
    });

    it('should_call_onActive_when_transition_is_ALBUM_and_isActive_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mocker.mockFunc(mediaDataSource, mediaDataSource.onActive);
      mediaDataSource.onPhotoBrowserActive(true, Constants.PHOTO_TRANSITION_ALBUM);
      mocker.verify('onActive', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onActive);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_onInActive_when_transition_is_ALBUM_and_isActive_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mocker.mockFunc(mediaDataSource, mediaDataSource.onInActive);
      mediaDataSource.onPhotoBrowserActive(false, Constants.PHOTO_TRANSITION_ALBUM);
      mocker.verify('onInActive', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onInActive);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_onActive_when_transition_is_CAMERA_and_isActive_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mocker.mockFunc(mediaDataSource, mediaDataSource.onActive);
      mediaDataSource.onPhotoBrowserActive(true, Constants.PHOTO_TRANSITION_CAMERA);
      mocker.verify('onActive', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onActive);
      expect(NUMBER_ONE).assertEqual(1);

    });

    it('should_call_onInActive_when_transition_is_CAMERA_and_isActive_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mocker.mockFunc(mediaDataSource, mediaDataSource.onInActive);
      mediaDataSource.onPhotoBrowserActive(false, Constants.PHOTO_TRANSITION_CAMERA);
      mocker.verify('onInActive', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onInActive);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_onChange_when_transition_is_EDIT_and_isActive_is_true_and_unifyNotify_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mediaDataSource.isEditSaveReload = false;
      mediaDataSource.unifyNotify = false;

      mocker.mockFunc(mediaDataSource, mediaDataSource.onChange);
      mediaDataSource.onPhotoBrowserActive(true, Constants.PHOTO_TRANSITION_EDIT);

      mocker.verify('onChange', ['image']).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onChange);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_onChange_when_transition_is_EDIT_and_isActive_is_true_and_unifyNotify_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mediaDataSource.isEditSaveReload = false;
      mediaDataSource.isActive = true;
      mediaDataSource.unifyNotify = true;

      mocker.mockFunc(mediaDataSource, mediaDataSource.onMediaLibDataChange);
      mediaDataSource.onPhotoBrowserActive(true, Constants.PHOTO_TRANSITION_EDIT);

      mocker.verify('onMediaLibDataChange', ['image']).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onMediaLibDataChange);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_return_immediately_when_transition_is_EDIT_and_isActive_is_false', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mediaDataSource.isEditSaveReload = true;
      mediaDataSource.onPhotoBrowserActive(false, Constants.PHOTO_TRANSITION_EDIT);
      expect(mediaDataSource.isEditSaveReload).assertFalse()
    });

    it('should_update_notify_count_status_when_isInfoValidForUpdateOtherAlbumCount_returns_true', 0, () => {
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, false, undefined);
      mediaDatasource.updateNotifyCountStatus(nfyInfo);
      expect(mediaDatasource.needFullQueryCount).assertEqual(true);
    });

    it('should_update_notify_count_status_when_isInfoValidForUpdateOtherAlbumCount_returns_false', 0, () => {
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.sharedAlbumAssets.length = 0;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, true, undefined);
      mediaDatasource.updateNotifyCountStatus(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_needFullQueryCount_to_true_when_needFullQueryCount_is_true', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mediaDataSource.setNeedFullQueryCount(true);
      expect(mediaDataSource.needFullQueryCount).assertEqual(true);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_log_info_when_nfyInfo_is_not_null', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_update_notify_count_status_when_isSupportChangeCountByNotify_is_true_and_isGalleryCleanupPage_is_false',
      0, () => {
        let mediaDatasource: MediaDataSource = new MediaDataSource(10);
        let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
        nfyInfo.type = MediaObserverNfyType.ALBUM_ADD;
        mediaDatasource.onNotify(nfyInfo);
        expect(NUMBER_ONE).assertEqual(1);
      })

    it('should_handle_photo_add_when_nfyInfo_type_is_PHOTO_ADD', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.PHOTO_ADD;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_remove_when_nfyInfo_type_is_PHOTO_REMOVE', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.PHOTO_REMOVE;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_update_when_nfyInfo_type_is_PHOTO_UPDATE', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.PHOTO_UPDATE;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_add_ASTC_when_nfyInfo_type_is_PHOTO_ADD_ASTC', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.PHOTO_ADD_ASTC;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_add_to_album_when_nfyInfo_type_is_ADD_PHOTO_INTO_ALBUM', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_add_to_album_when_nfyInfo_type_is_ADD_PHOTO_INTO_ALBUM_and_albumUris', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;
      nfyInfo.albumUris[0] = '';
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_photo_remove_from_album_when_nfyInfo_type_is_REMOVE_PHOTO_FROM_ALBUM', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      let uri = 'testuri';
      mediaDatasource.albumUri = 'testuri';
      nfyInfo.uris = [uri, uri, uri];
      nfyInfo.type = MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_default_when_nfyInfo_type_is_NONE_and_isSourceAlbum_is_true', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.NONE;
      mediaDatasource.isSourceAlbum = true;
      mediaDatasource.onNotify(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('switchRefreshOn_test', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, false, undefined);
      mediaDatasource.switchRefreshOn();
      expect(mediaDatasource.isRefresh).assertTrue();
    });

    it('should_return_correct_resource_when_getCategory_is_called', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let res = mediaDatasource.getCategory();
      expect(UiUtil.getResourceStringSync(res).length).assertEqual(0)
    });

    it('should_return_correct_active_start_when_forward_sliding', 0, () => {
      let windowSize = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.activeStart = 0;
      let dataIndex = 5;
      let windowCenter = 7;
      let lastForwardStepSize = 3;
      let res: number  = Reflect.get(mediaDatasource, 'getWindowActiveStart')
        .call(mediaDatasource, dataIndex, windowCenter, lastForwardStepSize);
      expect(res).assertEqual(0);
    });


    it('should_return_correct_active_start_when_isforward', 0, () => {
      let windowSize = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.activeStart = 0;
      let dataIndex = 7;
      let windowCenter = 5;
      let lastForwardStepSize = 3;
      let res: number = Reflect.get(mediaDatasource, 'getWindowActiveStart')
        .call(mediaDatasource, dataIndex, windowCenter, lastForwardStepSize);
      expect(res).assertEqual(3);
    });

    it('should_return_true_when_totalCount_is_zero', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      const result = mediaDataSource.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_requestUri_equals_dataUri', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.isInvalidData('sameUri', 'sameUri');
      expect(result).assertEqual(false);
    });

    it('should_return_correct_query_param_when_getQueryParam_is_called', 0, () => {
      let start: number = 10;
      let count: number = 20;
      let mediaDatasource: MediaDataSource = new MediaDataSource(100, new PhotoDataImpl(), true, {
        albumUri: 'testAlbumUri',
        filterMediaType: 'testMediaType',
      });
      let res = mediaDatasource.getQueryParam(start, count);
      expect(res.start).assertEqual(start);
    });

    it('should_create_simpleMediaItems_when_capacity_is_greater_than_or_equal_to_zero', 0, () => {
      let capacity: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(100, new PhotoDataImpl(), true, {});
      mediaDatasource.createSimpleMediaItems(capacity);
      let res: util.LRUCache<number, SimpleGridMediaItem> = Reflect.get(mediaDatasource, 'simpleMediaItems')
      expect(res != undefined).assertEqual(true);
    });

    it('should_clear_simpleMediaItems_when_simpleMediaItems_is_not_null_and_not_empty', 0, () => {
      let simpleMediaItems: util.LRUCache<number, SimpleGridMediaItem> = new util.LRUCache();
      let mediaItem: SimpleGridMediaItem = new SimpleGridMediaItem();
      simpleMediaItems.put(0, mediaItem);
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, queryParam);
      Reflect.set(mediaDatasource, 'simpleMediaItems', simpleMediaItems)
      mediaDatasource.clearSimpleMediaItems();
      let simpleMediaItemsLength: number = Reflect.get(mediaDatasource, 'simpleMediaItems').length;
      expect(simpleMediaItemsLength).assertEqual(0);
    });

    it('should_return_index_when_index_is_valid', 0, () => {
      let index: number = 5;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.layoutToData(index);
      expect(result).assertEqual(index);
    });

    it('should_return_0_when_dataIndex_is_0', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.getGroupIndexByDataIndex(0);
      expect(result).assertEqual(0);
    });

    it('should_return_minus_one_when_index_is_less_than_zero', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.findGroupViewIndexes(-1);
      expect(result).assertEqual(-1);
    });

    it('timeGroupIndexes_should_return_minus_one_when_index_is_less_than_zero', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result = mediaDatasource.timeGroupIndexes(-1);
      expect(result).assertEqual(-1);
    });

    it('should_return_undefined_when_index_is_out_of_range', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      let result = mediaDataSource.indexesToGroup(11);
      expect(result).assertUndefined();
    });

    it('should_calculate_group_global_offset_correctly', 0, () => {
      let windowSize: number = 10;
      let mediaDatasource: MediaDataSource = new MediaDataSource(windowSize);
      mediaDatasource.computeGroupGlobalOffset(100, 10, 3);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_return_minus_one_when_all_parameters_are_zero', 0, () => {
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, false, {});
      let result = mediaDatasource.computeMaxGridOffset(0, 0, 0);
      expect(result).assertEqual(-1);
    });

    it('should_return_correct_start_index_when_offset_is_zero', 0, () => {
      let offset: number = 0;
      let imageGridHeight: number = 100;
      let timeTitleHeight: number = 50;
      let gridColCnt: number = 3;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, false, undefined);
      let result: number = mediaDatasource.computeStartIndex(offset, imageGridHeight, timeTitleHeight, gridColCnt);
      expect(result).assertEqual(-1);
    });

    it('should_return_correct_index_when_offset_is_zero', 0, () => {
      let offset: number = 0;
      let imageGridHeight: number = 100;
      let timeTitleHeight: number = 50;
      let gridColCnt: number = 3;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10, undefined, false, undefined);
      let result = mediaDatasource.computeStartIndexWithMassage(offset, imageGridHeight, timeTitleHeight, gridColCnt);
      expect(result).assertEqual(-1);
    });

    it('should_return_undefined_when_info_is_null', 0, () => {
      let info: LoadingInfo = {
        start: 0,
        count: 10,
      };
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      let result: undefined = Reflect.get(mediaDatasource, 'buildLoadingTask').call(mediaDatasource, info);
      expect(result).assertEqual(undefined);
    });

    it('should_call_super_onMediaLibDataNfy_when_nfyInfo_is_not_null', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      mediaDataSource.onMediaLibDataNfy(nfyInfo);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_update_group_day_sliding_window_when_dataIndex_is_valid', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      mediaDataSource.updateGroupDaySlidingWindow(5);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_expand_window_when_activeStart_less_than_or_equal_to_current_activeStart_and_activeEnd_greater_than_or_equal_to_current_activeEnd',
      0, async () => {
        let dataWindow: DataWindow = new DataWindow(1, 10, 10, 1);
        let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, queryParam);
        mediaDataSource.isActive = true;
        mediaDataSource.activeStart = 1;
        mediaDataSource.activeEnd = 10;
        mediaDataSource.items = new Array<MediaItem>(10);
        mediaDataSource.unifyNotify = false;

        await mediaDataSource.changeWindow(dataWindow);

        let stepSize: number = Reflect.get(mediaDataSource, 'stepSize');
        expect(mediaDataSource.windowSize).assertEqual(10);
        expect(stepSize).assertEqual(1);
        expect(mediaDataSource.activeStart).assertEqual(1);
        expect(mediaDataSource.activeEnd).assertEqual(10);
      });

    it('should_slice_window_when_activeStart_greater_than_or_equal_to_current_activeStart_and_activeEnd_less_than_or_equal_to_current_activeEnd',
      0, async () => {
        let dataWindow: DataWindow = new DataWindow(1, 15, 15, 1);
        let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, queryParam);
        mediaDataSource.isActive = true;
        mediaDataSource.activeStart = 5;
        mediaDataSource.activeEnd = 10;
        mediaDataSource.items = new Array<MediaItem>(5);
        mediaDataSource.unifyNotify = false;

        await mediaDataSource.changeWindow(dataWindow);

        let stepSize: number = Reflect.get(mediaDataSource, 'stepSize')
        expect(mediaDataSource.windowSize).assertEqual(15);
        expect(stepSize).assertEqual(1);
        expect(mediaDataSource.activeStart).assertEqual(1);
        expect(mediaDataSource.activeEnd).assertEqual(15);
      });

    it('should_slice_window_when_activeStart_greater_than_or_equal_to_current_activeStart_and_activeEnd_less_than_or_equal_to_current_activeEnd_and_unifyNotify_is_true',
      0, async () => {
        let dataWindow: DataWindow = new DataWindow(1, 15, 15, 1);
        let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, queryParam);
        mediaDataSource.isActive = true;
        mediaDataSource.activeStart = 5;
        mediaDataSource.activeEnd = 10;
        mediaDataSource.items = new Array<MediaItem>(5);
        mediaDataSource.unifyNotify = true;

        await mediaDataSource.changeWindow(dataWindow);

        let stepSize: number = Reflect.get(mediaDataSource, 'stepSize')
        expect(mediaDataSource.windowSize).assertEqual(15);
        expect(stepSize).assertEqual(1);
        expect(mediaDataSource.activeStart).assertEqual(1);
        expect(mediaDataSource.activeEnd).assertEqual(15);
      });

    it('should_expand_window_when_unifyNotify_is_true', 0, async () => {
      let dataWindow: DataWindow = new DataWindow(5, 15, 10, 1);
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, queryParam);
      mediaDataSource.isActive = true;
      mediaDataSource.activeStart = 1;
      mediaDataSource.activeEnd = 10;
      mediaDataSource.items = new Array<MediaItem>(10);
      mediaDataSource.unifyNotify = true;

      await mediaDataSource.changeWindow(dataWindow);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_expand_window_when_unifyNotify_is_false', 0, async () => {
      let dataWindow: DataWindow = new DataWindow(5, 15, 10, 1);
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, queryParam);
      mediaDataSource.isActive = true;
      mediaDataSource.activeStart = 1;
      mediaDataSource.activeEnd = 10;
      mediaDataSource.items = new Array<MediaItem>(10);
      mediaDataSource.unifyNotify = false;

      await mediaDataSource.changeWindow(dataWindow);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_view_mode_to_default_when_mode_is_not_provided', 0, () => {
      let mode: GridViewMode = GridViewMode.GRID;
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.setViewMode(mode);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_callback_when_enableQueryDataFlag_is_false', 0, () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), false, {});
      Reflect.set(mediaDataSource, 'enableQueryDataFlag', false);
      Reflect.get(mediaDataSource, 'queryData').call(mediaDataSource, () => {
        expect(mediaDataSource.hasNewChange).assertEqual(false);
      });
    });

    it('should_handle_empty_mediaItems_when_lastUpdateTime_less_than_lastRequestTime_and_isActive_and_start_greater_than_activeEnd',
      0, async () => {
        let requestTime: number = 123456789;
        let start: number = 11;
        let mediaItems: MediaItem[] = [];
        let mediaDatasource: MediaDataSource = new MediaDataSource(10);
        mediaDatasource.activeEnd = 10;
        mediaDatasource.lastUpdateTime = 0;
        mediaDatasource.lastRequestTime = 1;
        mediaDatasource.isActive = true;
        mediaDatasource.itemChangeListener = () => {};
        let mocker: MockKit = new MockKit();
        mediaDatasource.mediaDataUpdateExecutor(requestTime, start, mediaItems);
        mocker.ignoreMock(mediaDatasource, mediaDatasource.mediaDataUpdateExecutor);
        expect(NUMBER_ONE).assertEqual(1);
      });

    it('should_handle_empty_mediaItems_when_lastUpdateTime_less_than_lastRequestTime_and_isActive', 0, async () => {
      let requestTime: number = 123456789;
      let start: number = 0;
      let mediaItem: MediaItem = new MediaItem();
      let mediaItems: MediaItem[] = [mediaItem, mediaItem, mediaItem];
      let mediaDatasource: MediaDataSource = new MediaDataSource(10);
      mediaDatasource.lastUpdateTime = 0;
      mediaDatasource.lastRequestTime = 1;
      mediaDatasource.isActive = true;
      let mocker: MockKit = new MockKit();
      mediaDatasource.mediaDataUpdateExecutor(requestTime, start, mediaItems);
      mocker.ignoreMock(mediaDatasource, mediaDatasource.mediaDataUpdateExecutor);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_handle_empty_mediaItems_when_lastUpdateTime_less_than_lastRequestTime_and_isActive_and_include_uri', 0,
      async () => {
        let requestTime: number = 123456789;
        let start: number = 0;
        let mediaItem: MediaItem = new MediaItem();
        mediaItem.uri = 'testUri';
        let mediaItems: MediaItem[] = [mediaItem, mediaItem, mediaItem];
        let mediaDatasource: MediaDataSource = new MediaDataSource(10);
        mediaDatasource.invalidUris = ['testUri'];
        mediaDatasource.lastUpdateTime = 0;
        mediaDatasource.lastRequestTime = 1;
        mediaDatasource.isActive = true;
        mediaDatasource.isEditSaveReload = true;
        mediaDatasource.addedCount = 1;
        let mocker: MockKit = new MockKit();
        mediaDatasource.mediaDataUpdateExecutor(requestTime, start, mediaItems);
        mocker.ignoreMock(mediaDatasource, mediaDatasource.mediaDataUpdateExecutor);
        expect(NUMBER_ONE).assertEqual(1);
      });

    it('should_call_onDataReloaded_when_forceUpdate_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});

      mocker.mockFunc(mediaDataSource, mediaDataSource.onDataReloaded);
      mediaDataSource.forceUpdate();
      mocker.verify('onDataReloaded', []).once();
      mocker.ignoreMock(mediaDataSource, mediaDataSource.onDataReloaded);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('getSimpleMediaItem_test_when_index_less_than_0', 0, async () => {
      let mediaDataSource: MediaDataSource = new MediaDataSource(10, new PhotoDataImpl(), true, {});
      let res: SimpleGridMediaItem | undefined = mediaDataSource.getSimpleMediaItem(-1);
      expect(res).assertEqual(undefined);
    });

    it('should_return_0_when_called_with_MediaItem', 0, () => {
      // 创建一个MediaItem对象作为参数
      let item: MediaItem = new MediaItem();
      // 创建MediaDataSource实例
      let mediaDataSource: MediaDataSource = new MediaDataSource(10);
      // 调用被测函数
      const result = mediaDataSource.getGroupCountBeforeItem(item);
      // 验证返回值是否为0
      expect(result).assertEqual(0);
    });

    it('should_return_validEndIndex_value', 0, () => {
      const windowSize = 10;
      const mediaDataSource = new MediaDataSource(windowSize);
      // 设置validEndIndex的值
      mediaDataSource.validEndIndex = 5;
      // 调用getValidEndIndex函数
      const result = mediaDataSource.getValidEndIndex();
      // 使用断言验证返回值是否正确
      expect(result).assertEqual(5);
    });

  });
}