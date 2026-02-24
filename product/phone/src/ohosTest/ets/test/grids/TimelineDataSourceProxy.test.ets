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
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { describe, expect, it } from '@ohos/hypium';
import { TimelineDataSourceProxy } from '@ohos/timeline/src/main/ets/model/TimelineDataSourceProxy';

export default function TimelineDataSourceProxyTest() {

  describe('TimelineDataSourceProxyTest', () => {

    it('when_index_is_0_returns_undefined', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const item = proxy.getSimpleMediaItem(0);
      expect(item).assertEqual(undefined);
    });

    it('when_index_is_1_returns_undefined', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const item = proxy.getSimpleMediaItem(1);
      expect(item).assertEqual(undefined);
    });

    it('getValidEndIndex', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getValidEndIndex();
      expect(res != undefined).assertEqual(true);
    })

    it('getValidStartIndex', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getValidStartIndex();
      expect(res != undefined).assertEqual(true);
    })

    it('getAlbumUri', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getAlbumUri();
      expect(res != undefined).assertEqual(true);
    })

    it('getIndexByMediaItem', 0, () => {
      let mediaItem = new MediaItem();
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getIndexByMediaItem(mediaItem);
      expect(res != undefined).assertEqual(true);
    })

    it('getRawData', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getRawData(-1);
      expect(res === undefined).assertEqual(true);
    })

    it('enableGetData', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let flag = true;
      proxy.enableGetData(flag);
      expect(Reflect.get(proxy, 'enableGetDataFlag')).assertEqual(flag);
    })

    it('getMediaItemByUri', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getMediaItemByUri('aaa');
      expect(res).assertEqual(undefined);
    })

    it('getDataIndex', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getDataIndex(undefined);
      expect(res).assertEqual(-1);
    })

    it('when_index_is_0_returns_non_null', 0, () => {
      const timelineDataSource = new TimelineDataSourceProxy();
      timelineDataSource.activeStart = 1;

      const curMediaItem = timelineDataSource.getWrappedData(0);
      expect(curMediaItem != undefined).assertEqual(true);
    });

    it('when_index_is_negative_1_returns_non_null', 0, () => {
      const timelineDataSource = new TimelineDataSourceProxy();
      timelineDataSource.activeStart = 1;

      const curMediaItem = timelineDataSource.getWrappedData(-1);
      expect(curMediaItem != undefined).assertEqual(true);
    });

    it('when_index_is_5_returns_null', 0, () => {
      const timelineDataSource = new TimelineDataSourceProxy();
      timelineDataSource.activeStart = 1;

      const curMediaItem = timelineDataSource.getWrappedData(5);
      expect(curMediaItem === undefined).assertEqual(false);
    });

    it('computeMaxGridOffset', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.computeMaxGridOffset(512, 512, 4);
      expect(res).assertEqual(0);
    });

    it('when_startIndex_is_0_returns_0', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const res = proxy.computeStartIndex(0, 512, 512, 4);
      expect(res).assertEqual(0);
    });

    it('when_startIndex_is_2_returns_undefined', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const res = proxy.computeStartIndex(2, 512, 512, 4);
      expect(res).assertEqual(undefined);
    });

    it('dataToLayout', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.dataToLayout(-1);
      expect(res).assertEqual(-1);
    });

    it('when_item_is_undefined_returns_0', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const res = proxy.getGroupCountBeforeItem(undefined);
      expect(res).assertEqual(0);
    });

    it('when_item_is_new_MediaItem_returns_0', 0, () => {
      const proxy = new TimelineDataSourceProxy();
      const res = proxy.getGroupCountBeforeItem(new MediaItem());
      expect(res).assertEqual(0);
    });

    it('findGroupViewIndexes', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.findGroupViewIndexes(0);
      expect(res).assertNaN();
    });

    it('timeGroupIndexes', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.timeGroupIndexes(0);
      expect(res).assertEqual(-1);
    });

    it('indexesToGroup', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.indexesToGroup(0);
      expect(res).assertEqual(undefined);
    });

    it('getDataByDisplayName', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getDataByDisplayName('');
      expect(res).assertEqual(undefined);
    });

    it('getDataSource', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getDataSource();
      expect(res != undefined).assertEqual(true);
    });

    it('getGroups', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.getGroupData();
      expect(res != undefined).assertEqual(true);
    });

    it('layoutToData', 0, () => {
      let proxy = new TimelineDataSourceProxy();
      let res = proxy.layoutToData(1);
      expect(res != undefined).assertEqual(true);
    });

    it('computeStartIndexWithMassage', 0, () => {
      let offset: number = 0;
      let imageGridHeight: number = 100;
      let timeTitleHeight: number = 50;
      let gridColCnt: number = 3;
      let proxy = new TimelineDataSourceProxy();
      let result = proxy.computeStartIndexWithMassage(offset, imageGridHeight, timeTitleHeight, gridColCnt);
      expect(result).assertEqual(0);
    });


  })
}