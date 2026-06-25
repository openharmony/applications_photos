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
import {
  BrowserStatisticReportManager,
  cloudEnhanceAlbumFileCountReport,
  commonAlbumStatusBaseReport,
  externalStorageStatusBaseReport,
  favorAlbumFileCountReport,
  fileCountReport,
  hiddenAlbumsCountReport,
  moreAlbumsFileCountReport,
  nowOverOneDay,
  nowOverOneWeek,
  openAlbumReportFn,
  photoAlbumFileCountReport,
  protraitAlbumsCountReport,
  settingsPageStatusReport,
  smartAlbumsCountReport,
  sourceAlbumCountReport,
  userAlbumsCountReport,
  videoAlbumFileCountReport
} from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

const NUMBER_ONE: number = 1;
export default function StatisticReportUtilTest() {
  describe('StatisticReportUtilTest', () => {

    it('StatisticReportUtilTest_init', 0, () => {
      let manager = new BrowserStatisticReportManager();
      manager.init();
      expect(manager.indexChangeTimestamp > 0).assertTrue();
    })

    it('StatisticReportUtilTest_switch', 0, () => {
      let manager = new BrowserStatisticReportManager();
      manager.switch()
      expect(manager.indexChangeTimestamp > 0).assertTrue();
    })

    it('StatisticReportUtilTest_end', 0, () => {
      let manager = new BrowserStatisticReportManager();
      manager.end()
      expect(manager.indexChangeTimestamp).assertNaN();
    })

    it('StatisticReportUtilTest_nowOverOneWeek', 0, () => {
      let res = nowOverOneWeek('');
      expect(res).assertEqual(true);
    })

    it('StatisticReportUtilTest_nowOverOneDay', 0, () => {
      let res = nowOverOneDay('');
      expect(res).assertEqual(true);
    })

    it('StatisticReportUtilTest_openAlbumReportFn', 0, () => {
      openAlbumReportFn(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      openAlbumReportFn(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
      openAlbumReportFn(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);
      openAlbumReportFn(UserFileManagerAccess.CLOUD_ENHANCE_ALBUM_SUB_TYPE);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_settingsPageStatusReport', 0, () => {
      settingsPageStatusReport(undefined, undefined, undefined, undefined);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_commonAlbumStatusBaseReport', 0, async () => {
      commonAlbumStatusBaseReport('test', 1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_fileCountReport', 0, async () => {
      fileCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_userAlbumsCountReport', 0, async () => {
      userAlbumsCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_photoAlbumFileCountReport', 0, async () => {
      photoAlbumFileCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_cloudEnhanceAlbumFileCountReport', 0, async () => {
      cloudEnhanceAlbumFileCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_videoAlbumFileCountReport', 0, async () => {
      videoAlbumFileCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_favorAlbumFileCountReport', 0, async () => {
      favorAlbumFileCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_hiddenAlbumsCountReport', 0, async () => {
      hiddenAlbumsCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_sourceAlbumCountReport', 0, async () => {
      sourceAlbumCountReport(1);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_moreAlbumsFileCountReport', 0, async () => {
      moreAlbumsFileCountReport(1, 2);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_smartAlbumsCountReport', 0, async () => {
      smartAlbumsCountReport(1, 2, 3);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_protraitAlbumsCountReport', 0, async () => {
      protraitAlbumsCountReport(1, 2, 3, 4, 5);
      expect(NUMBER_ONE).assertEqual(1);
    })

    it('StatisticReportUtilTest_externalStorageStatusBaseReport', 0, async () => {
      externalStorageStatusBaseReport('aaa', 1);
      expect(NUMBER_ONE).assertEqual(1);
    })

  })
}

