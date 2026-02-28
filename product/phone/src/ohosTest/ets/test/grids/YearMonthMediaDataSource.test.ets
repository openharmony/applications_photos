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
  YearMonthMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaDataSource';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import LightWeightMap from '@ohos.util.LightWeightMap';
import { YearMonthQueryParam, Priority } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthQueryParam';

export default function YearMonthMediaDataSourceTest() {
  describe('YearMonthMediaDataSourceTest', () => {

    it ('enableGetData', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let flag = true;
      datasource.enableGetData(flag);
      let res: boolean = Reflect.get(datasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it ('enableGetData1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(10);
      let flag = true;
      datasource.enableGetData(flag);
      let res: boolean = Reflect.get(datasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it ('enableGetData2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(15);
      let flag = true;
      datasource.enableGetData(flag);
      let res: boolean = Reflect.get(datasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it ('enableGetData3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(20);
      let flag = true;
      datasource.enableGetData(flag);
      let res: boolean = Reflect.get(datasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it ('enableGetData4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(25);
      let flag = true;
      datasource.enableGetData(flag);
      let res: boolean = Reflect.get(datasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it ('setPhotoBroadCast', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setPhotoBroadCast(new BroadCast());
      let res = Reflect.get(datasource, 'photosBroadCast');
      expect(res != undefined).assertEqual(true);
    });

    it ('releasePhotoBroadCast', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.releasePhotoBroadCast();
      let res = Reflect.get(datasource, 'photosBroadCast');
      expect(res).assertEqual(undefined);
    });

    it ('isEmpty', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      expect(datasource.isEmpty()).assertEqual(true);
    });

    it ('setCurrentViewType', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 0;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setCurrentViewType1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 1;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setCurrentViewType2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 2;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setCurrentViewType3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 3;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setCurrentViewType4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 4;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setCurrentViewType5', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let type = 5;
      datasource.setCurrentViewType(type);
      let res: number = Reflect.get(datasource, 'currentViewType');
      expect(res).assertEqual(type);
    });

    it ('setYearDataOffset', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 0;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setYearDataOffset1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 1;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setYearDataOffset2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 2;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setYearDataOffset3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 3;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setYearDataOffset4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 4;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setYearDataOffset5', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 5;
      let maxPhotoNum = 500;
      datasource.setYearDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'yearDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    it ('setMonthDataOffset6', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let dataOffset = 6;
      let maxPhotoNum = 500;
      datasource.setMonthDataOffset(dataOffset, maxPhotoNum);
      let res: number = Reflect.get(datasource, 'monthDataOffset');
      expect(res).assertEqual(dataOffset);
    });

    //测试onSyncCountChanged: ImageUtil.isThumbnailReady = false
    it ('onSyncCountChanged_when_ImageUtil_isThumbnailReady_is_false', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let mocker = new MockKit();
      when(mocker.mockFunc(ImageUtil, ImageUtil.isThumbnailReady))(ArgumentMatchers.any).afterReturn(false);
      expect(datasource.hasNewChange).assertFalse();
      mocker.ignoreMock(ImageUtil, ImageUtil.isThumbnailReady);
    });

    //setYearMonthDayViewIndex: this.enableGetDataFlag = true
    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(10);
      expect(datasource.yearMonthDayViewIndex).assertEqual(10);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(11);
      expect(datasource.yearMonthDayViewIndex).assertEqual(11);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(12);
      expect(datasource.yearMonthDayViewIndex).assertEqual(12);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(13);
      expect(datasource.yearMonthDayViewIndex).assertEqual(13);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(14);
      expect(datasource.yearMonthDayViewIndex).assertEqual(14);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false5', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(15);
      expect(datasource.yearMonthDayViewIndex).assertEqual(15);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false6', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(16);
      expect(datasource.yearMonthDayViewIndex).assertEqual(16);
    });

    it ('setYearMonthDayViewIndex_when_ImageUtil_isThumbnailReady_is_false7', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setYearMonthDayViewIndex(17);
      expect(datasource.yearMonthDayViewIndex).assertEqual(17);
    });

    //测试isSyncQuery: queryParam and queryParam.isForceSyncQuery = true
    it ('isSyncQuery_when_queryParam_and_isForceSyncQuery_is_true', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      let queryParam = new YearMonthQueryParam(1, 2, Priority.HIGH, true, true);
      const res: boolean = datasource.isSyncQuery(queryParam);
      expect(res).assertTrue();
    });

    //测试setAccessDataFlag
    it ('setAccessDataFlag_TRUE', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setAccessDataFlag(true);
      expect(Reflect.get(datasource, 'isAccessData')).assertTrue();
    });

    it ('setAccessDataFlag_FALSE', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.setAccessDataFlag(false);
      expect(Reflect.get(datasource, 'isAccessData')).assertFalse();
    });

    //测试getCachedDateTaken
    it ('getCachedDateTaken', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(0);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(1);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(2);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(3);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(4);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken5', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(5);
      expect(res).assertUndefined()
    });

    it ('getCachedDateTaken6', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res: number|undefined = datasource.getCachedDateTaken(6);
      expect(res).assertUndefined()
    });

    //测试resetDataOffset
    it ('resetDataOffset', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      datasource.resetDataOffset();
      expect(Reflect.get(datasource, 'yearDataOffset')).assertEqual(0);
    });

    //测试getModifiedStart: start < this.maxPhotosNum
    it ('getModifiedStart', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(1);
      expect(res).assertEqual(1);
    });

    it ('getModifiedStart1', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(2);
      expect(res).assertEqual(2);
    });

    it ('getModifiedStart2', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(3);
      expect(res).assertEqual(3);
    });

    it ('getModifiedStart3', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(4);
      expect(res).assertEqual(4);
    });

    it ('getModifiedStart4', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(5);
      expect(res).assertEqual(5);
    });

    it ('getModifiedStart5', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(6);
      expect(res).assertEqual(6);
    });

    it ('getModifiedStart6', 0, () => {
      let datasource: YearMonthMediaDataSource = new YearMonthMediaDataSource(5);
      const res = datasource.getModifiedStart(7);
      expect(res).assertEqual(7);
    });

  });
}