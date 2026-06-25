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
  YearMonthMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaDataSource';
import { describe, expect, it } from '@ohos/hypium';
import { YearMonthDataView } from '@ohos/timeline/src/main/ets/model/YearMonthDataView';

export default function YearMonthDataViewTest() {
  describe('YearMonthDataViewTest', () => {

    // 测试getRowCount
    it ('getRowCount_nan', 0, () => {
      let dataSource = new YearMonthMediaDataSource(4);
      let view1 = new YearMonthDataView('date', dataSource);
      let res1 = view1.getRowCount(0);
      expect(res1 === Number.NaN).assertEqual(false);
    })

    it ('getRowCount_valid', 0, () => {
      let dataSource = new YearMonthMediaDataSource(4);
      let view1 = new YearMonthDataView('date', dataSource);
      view1.setItemCountPerGroup(10);
      view1.setItemCountPerRow(10);
      let res1 = view1.getRowCount(1);
      expect(res1).assertEqual(-1);
    })

    //测试getData
    it('when_index_is_negative_returns_undefined', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      const res = view.getData(-1);
      expect(res).assertEqual(undefined);
    });

    it('when_index_is_zero_returns_undefined', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      const res = view.getData(0);
      expect(res).assertEqual(undefined);
    });

    //测试setItemCountPerRow
    it('should_setItemCountPerRow_when_itemCountPerRow_is_valid', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let itemCountPerRow: number = 10;
      view.setItemCountPerRow(itemCountPerRow);
      expect(Reflect.get(view,'itemCountPerRow')).assertEqual(itemCountPerRow);
    });

    //测试setItemCountPerGroup
    it('should_setItemCountPerGroup_when_itemCountPerGroup_is_valid', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let itemCountPerGroup: number = 10;
      view.setItemCountPerGroup(itemCountPerGroup);
      expect(Reflect.get(view,'itemCountPerGroup')).assertEqual(itemCountPerGroup);
    });

    //测试setViewWidth
    it('should_setViewWidth_when_viewWidth_is_valid', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 10;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid11', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 11;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid12', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 12;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid13', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 13;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid14', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 14;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid15', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 15;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid18', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 18;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid20', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 20;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid26', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 26;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid30', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 30;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid34', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 34;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid40', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 40;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid47', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 47;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid50', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 50;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid60', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 60;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid70', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 70;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid80', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 80;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid90', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 90;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    it('should_setViewWidth_when_viewWidth_is_valid100', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let viewWidth: number = 100;
      view.setViewWidth(viewWidth);
      expect(Reflect.get(view,'viewWidth')).assertEqual(viewWidth);
    });

    //测试updateFillPosition
    it('should_update_fillPosition_when_fillPosition_is_valid', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 10;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid11', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 11;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid12', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 12;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid13', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 13;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid14', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 14;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid15', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 15;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid16', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 16;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid17', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 17;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid18', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 18;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid19', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 19;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid20', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 20;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid26', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 26;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid30', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 30;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid35', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 35;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid40', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 40;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid47', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 47;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid50', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 50;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid58', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 58;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid60', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 60;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid66', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 66;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid70', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 70;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid77', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 77;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid80', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 80;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid88', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 88;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid90', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 90;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid100', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 100;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid115', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 115;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid123', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 123;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid136', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 136;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid142', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 142;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid150', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 150;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid156', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 156;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid157', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 157;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid158', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 158;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    it('should_update_fillPosition_when_fillPosition_is_valid160', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      let fillPosition: number = 160;
      view.updateFillPosition(fillPosition);
      expect(Reflect.get(view,'fillPosition')).assertEqual(fillPosition);
    });

    //测试totalCount
    it('should_return_correct_count_when_dataSource_is_not_null', 0, () => {
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      view.setItemCountPerGroup(10);
      view.updateFillPosition(10);
      const result = view.totalCount();
      expect(result).assertEqual(1);
    });

    //测试initData
    it('initData_test',0,()=>{
      const dataSource = new YearMonthMediaDataSource(4);
      dataSource.enableGetDataFlag = false;
      const view = new YearMonthDataView('date', dataSource);
      view.initData();
      expect(dataSource.isInitData).assertTrue();
    });
  })
}