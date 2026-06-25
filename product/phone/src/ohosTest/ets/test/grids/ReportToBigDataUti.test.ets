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
import { describe, expect, it } from '@ohos/hypium';
import { BigDataConstants,
  BigDataMsg,
  ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';

export default function ReportToBigDataUtilTest() {
  describe('ReportToBigDataUtilTest', () => {

    it('ReportToBigDataUtilTest_getEnterPhotoBrowserPosition', 0, () => {
      let res1 = ReportToBigDataUtil.getEnterPhotoBrowserPosition(-1);
      expect(res1).assertEqual(BigDataConstants.OPERATION_IN_OTHER_PAGE);

      let res2 = ReportToBigDataUtil.getEnterPhotoBrowserPosition(0);
      expect(res2).assertEqual(BigDataConstants.OPERATION_IN_TIMELINE_PAGE);

      let res3 = ReportToBigDataUtil.getEnterPhotoBrowserPosition(1);
      expect(res3).assertEqual(BigDataConstants.OPERATION_IN_ALBUM_PAGE);

      let res4 = ReportToBigDataUtil.getEnterPhotoBrowserPosition(2);
      expect(res4).assertEqual(BigDataConstants.OPERATION_IN_HIGHLIGHT_PAGE);
    })

    it('ReportToBigDataUtilTest_getFileNameOfPhotoTakenByCamera', 0, () => {
      let res1 = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera();
      expect(res1.length).assertEqual(0);

      let mediaItem: MediaItem = new MediaItem();
      let res2 = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera(mediaItem);
      expect(res2.length).assertEqual(0);
    })

    it('ReportToBigDataUtilTest_setFileNameProperty', 0, () => {
      let msg : BigDataMsg = {
        'FileName' : 'hahah'
      }
      let name : string = 'aaaa'
      ReportToBigDataUtil.setFileNameProperty(msg, name);
      expect(msg['FileName']).assertEqual(name);
    })

  })
}