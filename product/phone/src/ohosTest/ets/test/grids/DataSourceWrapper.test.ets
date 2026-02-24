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
import { DataSourceWrapper } from '@ohos/common/src/main/ets/default/model/DataSourceWrapper';
import { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import { describe, expect, it, MockKit } from '@ohos/hypium';
import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

export default function DataSourceWrapperTest() {

  describe('DataSourceWrapperTest', () => {

    it ('changeMode', 0, () => {
      let wrapper = new DataSourceWrapper();
      let newMode = GridViewMode.GROUP;
      wrapper.changeMode(newMode);
      expect(wrapper.viewMode).assertEqual(newMode);

      newMode = GridViewMode.GRID;
      wrapper.changeMode(newMode);
      expect(wrapper.viewMode).assertEqual(newMode);

    })

    it ('setIsShowPlaceHolder', 0, () => {
      let wrapper = new DataSourceWrapper();
      let show = true;
      wrapper.setIsShowPlaceHolder(show);
      expect(wrapper.isShowPlaceHolder).assertEqual(show);
    })

    it ('getData', 0, () => {
      let wrapper = new DataSourceWrapper();
      let res = wrapper.getData(0);
      expect(res !== undefined).assertEqual(true);
    })

    it ('layoutToData', 0, () => {
      let wrapper = new DataSourceWrapper();
      let res = wrapper.layoutToData(0);
      expect(res).assertEqual(0);
    })

    it ('dataToLayout', 0, () => {
      let wrapper = new DataSourceWrapper();
      let res = wrapper.dataToLayout(0);
      expect(res).assertEqual(0);
    })

    it ('totalCount', 0, () => {
      let wrapper = new DataSourceWrapper();
      let res = wrapper.totalCount();
      expect(res).assertEqual(0);
    })

    it ('setDataSource', 0, () => {
      let wrapper = new DataSourceWrapper();
      let dataSource = new MediaDataSource(1, undefined, true, undefined);
      wrapper.setDataSource(dataSource);
      expect(Reflect.get(wrapper, 'dataSource') !== undefined).assertTrue();
    })

    it ('changeMode_GROUP', 0, () => {
      let wrapper = new DataSourceWrapper();
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      wrapper.changeMode(GridViewMode.GROUP);
      expect(wrapper.viewMode).assertEqual(GridViewMode.GROUP)
      mocker.ignoreMock(Log, Log.info);
    })

    it ('changeMode_GRID', 0, () => {
      let wrapper = new DataSourceWrapper();
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      wrapper.changeMode(GridViewMode.GRID);
      expect(wrapper.viewMode).assertEqual(GridViewMode.GRID);
      mocker.ignoreMock(Log, Log.info);
    })

    it ('setIsShowPlaceHolder_set_true', 0, () => {
      let wrapper = new DataSourceWrapper();
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      wrapper.setIsShowPlaceHolder(true);
      expect(wrapper.isShowPlaceHolder).assertTrue();
      mocker.ignoreMock(Log, Log.info);
    })

    it ('setIsShowPlaceHolder_set_false', 0, () => {
      let wrapper = new DataSourceWrapper();
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      wrapper.setIsShowPlaceHolder(false);
      expect(wrapper.isShowPlaceHolder).assertFalse();
      mocker.ignoreMock(Log, Log.info);
    })
  })
}
