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
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { DataWindow } from '@ohos/common/src/main/ets/default/utils/DataSourceWindowUtil';
import { describe, expect, it } from '@ohos/hypium';
import { TimelineDataSource } from '@ohos/timeline/src/main/ets/model/TimelineDataSource';

export default function TimelineDataSourceTest() {
  describe('TimelineDataSourceTest', () => {

    it('changeWindow', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);
      let dataWindow: DataWindow = new DataWindow(1, 10, 10, 1);
      timelineDataSource.changeWindow(dataWindow);

      Reflect.get(timelineDataSource, 'stepSize');
      expect(timelineDataSource.windowSize).assertEqual(10);
    })

    it('setPreloadStartIndex', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);

      let starIndex = 0;
      timelineDataSource.setPreloadStartIndex(starIndex);
      let preloadDataIndex: number = Reflect.get(timelineDataSource, 'preloadDataIndex');
      expect(preloadDataIndex).assertEqual(starIndex);
    })

    it('setDayDataOffset', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);

      timelineDataSource.setDayDataOffset(200, 1000);

      let dataOffset: number = Reflect.get(timelineDataSource, 'dayDataOffset');
      let maxPhotoNum: number = Reflect.get(timelineDataSource, 'maxPhotoNum');
      expect(dataOffset).assertEqual(200);
      expect(maxPhotoNum).assertEqual(1000);
    })

    it('getModifiedStart', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);

      let starIndex = 0;
      let modifiedStart = timelineDataSource.getModifiedStart(starIndex);
      expect(modifiedStart).assertEqual(starIndex);

      let starIndex1 = 800;
      timelineDataSource.setDayDataOffset(900, 700);
      let modifiedStart1 = timelineDataSource.getModifiedStart(starIndex1);
      expect(modifiedStart1).assertEqual(starIndex1);

      let starIndex2 = 800;
      let dataOffset = 600;
      timelineDataSource.setDayDataOffset(dataOffset, 700);
      let modifiedStart2 = timelineDataSource.getModifiedStart(starIndex2);
      expect(modifiedStart2).assertEqual(starIndex2 - dataOffset);
    })

    it('getMediaItemByPosition', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);
      timelineDataSource.activeStart = 1;
      let curMediaItem = timelineDataSource.getMediaItemByPosition(0);
      expect(curMediaItem).assertEqual(undefined);

      let curMediaItem1 = timelineDataSource.getMediaItemByPosition(2);
      expect(curMediaItem1 != undefined).assertEqual(true);
    });

    it('getWrappedData', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);
      timelineDataSource.activeStart = 1;
      let curMediaItem = timelineDataSource.getWrappedData(0, true);
      expect(curMediaItem != undefined).assertEqual(true);

      let curMediaItem1 = timelineDataSource.getWrappedData(0, false);
      expect(curMediaItem1 != undefined).assertEqual(true);

      let curMediaItem2 = timelineDataSource.getWrappedData(-1, true);
      expect(curMediaItem2 != undefined).assertEqual(true);

    });

    it('setUpdateMinCount', 0, () => {
      let broadCast: BroadCast = new BroadCast();
      let timelineDataSource = new TimelineDataSource(10, broadCast);
      timelineDataSource.setUpdateMinCount(5);
      expect(Reflect.get(timelineDataSource, 'updateMinCount')).assertEqual(5);
    });
  })
}