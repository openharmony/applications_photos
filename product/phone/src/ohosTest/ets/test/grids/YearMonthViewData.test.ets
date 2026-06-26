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
import { describe, expect, it, MockKit } from '@ohos/hypium';
import {
  YearMonthViewData,
  YearMonthViewDataBuilder
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthViewData';
import { YearMonthMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaItem';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { YearMonthUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthUtil';

export default function YearMonthViewDataTest() {
  describe('YearMonthViewDataTest', () => {

    //测试computeAverageDateModified: len > 0
    it('computeAverageDateModified_when_mediaItems_length_is_bigger_than_zero', 0, () => {
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      let mediaItems: YearMonthMediaItem[] = [];
      mediaItems.push(new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(1, 1, 1));
      const res: number = Reflect.get(yearMonthViewData, 'computeAverageDateModified').call(mediaItems);
      expect(res).assertEqual(0);
    });

    //测试computeAverageDateModified: len <= 0
    it('computeAverageDateModified_when_mediaItems_length_is_zero', 0, () => {
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      let mediaItems: YearMonthMediaItem[] = [];
      const res: number = Reflect.get(yearMonthViewData, 'computeAverageDateModified').call(mediaItems);
      expect(res).assertEqual(0);
    });

    //测试needUpdateViewData: YearMonthUtil.isYearMonthView(currentView) = false
    it('needUpdateViewData_when_currentView_not_year_or_month', 0, () => {
      let currentView: string = "undefined";
      let viewWidth: number = 1;
      let itemCount = 0;
      let mediaItems: YearMonthMediaItem[] = [];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertFalse();
    });

    //测试needUpdateViewData: viewWidth < 0
    it('needUpdateViewData_when_viewWidth_is_smaller_than_0', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = -1;
      let itemCount = 0;
      let mediaItems: YearMonthMediaItem[] = [];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertFalse();
    });

    //测试needUpdateViewData: this.currentView !== currentView
    it('needUpdateViewData_when_update_currentView', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 1;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.currentView = Constants.MONTH;
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertTrue();
    });

    //测试needUpdateViewData: this.viewWidth !== viewWidth
    it('needUpdateViewData_when_update_viewWidth', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 1;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.currentView = Constants.YEAR;
      yearMonthViewData.viewWidth = 0;
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertTrue();
    });

    //测试needUpdateViewData: this.data.itemCount !== itemCount
    it('needUpdateViewData_when_update_itemCount', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 1;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.currentView = Constants.YEAR;
      yearMonthViewData.viewWidth = 1;
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertTrue();
    });

    //测试needUpdateViewData: this.data.mediaItems.length !== mediaItems.length
    it('needUpdateViewData_when_update_mediaItems', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 0;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.currentView = Constants.YEAR;
      yearMonthViewData.viewWidth = 1;
      const res: number = Reflect.get(yearMonthViewData, 'needUpdateViewData')
        .call(yearMonthViewData, currentView, viewWidth, itemCount, mediaItems);
      expect(res).assertTrue();
    });

    //测试updateViewData: !YearMonthUtil.isYearMonthView(currentView) = true
    it('updateViewData_when_currentView_not_year_or_month', 0, () => {
      let currentView: string = 'DAY';
      let viewWidth: number = 1;
      let itemCount = 0;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.viewWidth = 1;
      yearMonthViewData.updateViewData(currentView, viewWidth, mediaItems, itemCount);
      expect(YearMonthUtil.isYearMonthView(currentView)).assertFalse();
    });

    //测试updateViewData: viewWidth < 0
    it('updateViewData_when_viewWidth_is_smaller_than_zero', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = -1;
      let itemCount = 0;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.updateViewData(currentView, viewWidth, mediaItems, itemCount);
      expect(viewWidth < 0).assertTrue();
    });

    //测试updateViewData: this.groupIndex === 0 && this.fillPosition > 0
    it('updateViewData_when_groupIndex_is_zero_and_fillPosition_bigger', 0, () => {
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 2;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      yearMonthViewData.fillPosition = 1;
      yearMonthViewData.updateViewData(currentView, viewWidth, mediaItems, itemCount);
      expect(yearMonthViewData.data !== undefined).assertTrue();
    });

    //测试updateViewDataIfNeed: this.needUpdateViewData(currentView, viewWidth, mediaItems, itemCount) = true
    it('updateViewData_when_need_update_data', 0, () => {
      let mocker = new MockKit();
      let currentView: string = Constants.YEAR;
      let viewWidth: number = 1;
      let itemCount = 2;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      let yearMonthViewData: YearMonthViewData = new YearMonthViewData();
      mocker.mockFunc(yearMonthViewData, yearMonthViewData.updateViewData);
      yearMonthViewData.fillPosition = 1;
      yearMonthViewData.updateViewDataIfNeed(currentView, viewWidth, mediaItems, itemCount);
      mocker.verify('updateViewData', [currentView, viewWidth, mediaItems, itemCount]).atLeast(1);
      mocker.ignoreMock(yearMonthViewData, yearMonthViewData.updateViewData);
      mocker.clear(yearMonthViewData);
    });

    //测试getViewData
    it('getViewData_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewData = Reflect.get(yearMonthViewDataBuilder, 'getViewData')
        .call(yearMonthViewDataBuilder);
      expect(res !== undefined).assertTrue();
    });

    //测试 viewKey
    it('viewKey_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.viewKey('test');
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.viewKey).assertEqual('test');
    });

    //测试 currentView
    it('currentView_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.currentView('test');
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.currentView).assertEqual('test');
    });

    //测试 viewWidth
    it('viewWidth_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.viewWidth(1);
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.viewWidth).assertEqual(1);
    });

    //测试 column
    it('column_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.column(1);
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.column).assertEqual(1);
    });

    //测试 groupIndex
    it('groupIndex_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.groupIndex(1);
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.groupIndex).assertEqual(1);
    });

    //测试 fillPosition
    it('fillPosition_when_set', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      const res: YearMonthViewDataBuilder = yearMonthViewDataBuilder.fillPosition(1);
      const viewData: YearMonthViewData = Reflect.get(res, '_viewData');
      expect(viewData.fillPosition).assertEqual(1);
    });

    //测试 build
    it('build_when_return_undefined', 0, () => {
      let yearMonthViewDataBuilder: YearMonthViewDataBuilder = new YearMonthViewDataBuilder();
      let count: number = 2;
      let mediaItems: YearMonthMediaItem[] = [new YearMonthMediaItem(1, 1, 1), new YearMonthMediaItem(2, 2, 2)];
      const res: YearMonthViewData = yearMonthViewDataBuilder.build(mediaItems, count);
      expect(res !== undefined).assertTrue();
    });

  });
}