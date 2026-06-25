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
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import image from '@ohos.multimedia.image';
import { describe, expect, it } from '@ohos/hypium';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const imageUri = "/data/myPhoto";
const NUMBER_ONE: number = 1;

enum PreviewImageLimitedRatio {
  VERTICAL = 4 / 3,
  HORIZONTAL = 1 / 3,
  VERTICAL_LONG_IMAGE = 3 / 1,
}

export default function BrowserImageUtilTest() {
  describe('BrowserImageUtilTest', () => {
    it('BrowserImageUtilTest_computeSampleSize_001', 0, () => {
      expect(ImageUtil.computeSampleSize(0, 1, 1, 1)).assertEqual(2);
    });

    it('BrowserImageUtilTest_computeSampleSize_002', 0, () => {
      expect(ImageUtil.computeSampleSize(1, 0, 1, 1)).assertEqual(2);
    });

    it('BrowserImageUtilTest_computeSampleSize_003', 0, () => {
      expect(ImageUtil.computeSampleSize(1, 1, 0, 1)).assertEqual(2);
    });

    it('BrowserImageUtilTest_computeSampleSize_004', 0, () => {
      expect(ImageUtil.computeSampleSize(1, 1, 1, 0)).assertEqual(2);
    });

    it('BrowserImageUtilTest_computeSampleSize_005', 0, () => {
      expect(ImageUtil.computeSampleSize(1, 1, -1, 10000)).assertEqual(1);
    });

    it('BrowserImageUtilTest_computeSampleSize_006', 0, () => {
      expect(ImageUtil.computeSampleSize(9, 9, 1, -1)).assertEqual(16);
    });

    it('BrowserImageUtilTest_computeSampleSize_007', 0, () => {
      expect(ImageUtil.computeSampleSize(10, 10, -1, -1)).assertEqual(1);
    });

    it('BrowserImageUtilTest_calcThumbnailSize_001', 0, () => {
      expect(ImageUtil.calcThumbnailSize(0, 0, undefined)).assertDeepEquals({
        width: 256, height: 256,
      });
    });

    it('BrowserImageUtilTest_calcThumbnailSize_002', 0, () => {
      expect(ImageUtil.calcThumbnailSize(100, 100, undefined)).assertDeepEquals({
        width: 100, height: 100,
      });
    });

    it('BrowserImageUtilTest_calcThumbnailSize_003', 0, () => {
      expect(ImageUtil.calcThumbnailSize(750, 1500, undefined)).assertDeepEquals({
        width: 1440, height: 720,
      });
    });

    it('BrowserImageUtilTest_calcThumbnailSize_004', 0, () => {
      expect(ImageUtil.calcThumbnailSize(1500, 750, undefined)).assertDeepEquals({
        width: 720, height: 1440,
      });
    });

    it('BrowserImageUtilTest_calcThumbnailSize_005', 0, () => {
      expect(ImageUtil.calcThumbnailSize(1500, 750, Constants.ANGLE_90)).assertDeepEquals({
        width: 1440, height: 720,
      });
    });

    it('BrowserImageUtilTest_calcThumbnailSize_006', 0, () => {
      expect(ImageUtil.calcThumbnailSize(750, 1500, Constants.ANGLE_270)).assertDeepEquals({
        width: 720, height: 1440,
      });
    });

    it('BrowserImageUtilTest_isThumbnailReady_001', 0, () => {
      ImageUtil.thumbnailReadyFlag = true;
      ImageUtil.setThumbnailReadyFlag(true);
      expect(ImageUtil.isThumbnailReady()).assertTrue();
    });

    it('BrowserImageUtilTest_isThumbnailReady_002', 0, () => {
      ImageUtil.thumbnailReadyFlag = true;
      ImageUtil.setThumbnailReadyFlag(false);
      expect(ImageUtil.isThumbnailReady()).assertFalse();
    });

    it('BrowserImageUtilTest_isThumbnailReady_003', 0, () => {
      ImageUtil.thumbnailReadyFlag = false;
      ImageUtil.setThumbnailReadyFlag(true);
      expect(ImageUtil.isThumbnailReady()).assertFalse();
    });

    it('BrowserImageUtilTest_isThumbnailReady_004', 0, () => {
      ImageUtil.thumbnailReadyFlag = false;
      ImageUtil.setThumbnailReadyFlag(false);
      expect(ImageUtil.isThumbnailReady()).assertFalse();
    });

    it('BrowserImageUtilTest_nextPowerOf2_001', 0, () => {
      expect(ImageUtil.nextPowerOf2(-1)).assertEqual(1);
    });

    it('BrowserImageUtilTest_nextPowerOf2_002', 0, () => {
      expect(ImageUtil.nextPowerOf2((1 << 30) + 1)).assertEqual(1);
    });

    it('BrowserImageUtilTest_nextPowerOf2_003', 0, () => {
      expect(ImageUtil.nextPowerOf2(2)).assertEqual(2);
    });

    it('BrowserImageUtilTest_generateTimeId_001', 0, () => {
      // dateTaken为‘’,则生成的timeId为''
      let dateTaken = '';
      let fileId = 'myPhoto';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual('');
    });

    it('BrowserImageUtilTest_generateTimeId_002', 0, () => {
      // fileId‘’,则生成的timeId为''
      let dateTaken = "1234567890";
      let fileId = '';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual('');
    });

    it('BrowserImageUtilTest_generateTimeId_003', 0, () => {
      // dateTaken不足13位，则在dateTaken前面补充0凑13位
      let dateTaken = "1234567890";
      let fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("00012345678901234567890");
    });

    it('BrowserImageUtilTest_generateTimeId_004', 0, () => {
      // dateTaken为13位，保持原状
      let dateTaken = "1234567890123";
      let fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("12345678901231234567890");
    });

    it('BrowserImageUtilTest_generateTimeId_005', 0, () => {
      // dateTaken超过13位，保持原状
      let dateTaken = "12345678901234";
      let fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("123456789012341234567890");
    });

    it('BrowserImageUtilTest_generateTimeId_006', 0, () => {
      // fileId必须为10位，且基本不足10位，直接在前面补0
      let dateTaken = "12345678901234";
      let fileId = '123456';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("123456789012340000123456");
    });

    it('BrowserImageUtilTest_calcRatio_001', 0, () => {
      let info: Size = { width: 0, height: 300 };
      expect(ImageUtil.calcRatio(info)).assertEqual(1);
    });

    it('BrowserImageUtilTest_calcRatio_002', 0, () => {
      let info: Size = { width: 300, height: 0 };
      expect(ImageUtil.calcRatio(info)).assertEqual(1);
    });

    it('BrowserImageUtilTest_calcRatio_003', 0, () => {
      let info: Size = { width: 200, height: 400 };
      expect(ImageUtil.calcRatio(info)).assertEqual(0.5);
    });

    it('BrowserImageUtilTest_calcThumbnail_001', 0, () => {
      // 长度为0，返回256 * 256
      expect(ImageUtil.calcThumbnail(imageUri, 0, 200, 0)).assertEqual(
        "/data/myPhoto/thumbnail/256/256");
    });

    it('BrowserImageUtilTest_calcThumbnail_002', 0, () => {
      // 宽度为0，返回256 * 256
      expect(ImageUtil.calcThumbnail(imageUri, 100, 0, 0)).assertEqual(
        "/data/myPhoto/thumbnail/256/256");
    });

    it('BrowserImageUtilTest_calcThumbnail_003', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 400, 800, 0)).assertEqual(
        "/data/myPhoto/thumbnail/800/400");
    });

    it('BrowserImageUtilTest_calcThumbnail_004', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 800, 400, 0)).assertEqual(
        "/data/myPhoto/thumbnail/400/800");
    });

    it('BrowserImageUtilTest_calcThumbnail_005', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_90)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");
    });

    it('BrowserImageUtilTest_calcThumbnail_006', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_270)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");
    });

    it('BrowserImageUtilTest_calcThumbnail_007', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_90)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");
    });

    it('BrowserImageUtilTest_calcThumbnail_008', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_270)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");
    });

    it('BrowserImageUtilTest_calcThumbnail_009', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_180)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");
    });

    it('BrowserImageUtilTest_calcThumbnail_010', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_360)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");
    });

    it('BrowserImageUtilTest_calcThumbnail_011', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_180)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");
    });

    it('BrowserImageUtilTest_calcThumbnail_012', 0, () => {
      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_360)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");
    });

    it('BrowserImageUtilTest_getThumbnailSize_001', 0, () => {
      // 长度为0，返回256 * 256
      expect(ImageUtil.getThumbnailSize(200, 300, true).width).assertEqual(256);
    });

    it('BrowserImageUtilTest_getThumbnailSize_002', 0, () => {
      expect(ImageUtil.getThumbnailSize(200, 300, true).height).assertEqual(256);
    });

    it('BrowserImageUtilTest_getThumbnailSize_003', 0, () => {
      expect(ImageUtil.getThumbnailSize(200, 300, false).width).assertEqual(ImageUtil.resizeThumbnail(200, 300).width);
    });

    it('BrowserImageUtilTest_getThumbnailSize_004', 0, () => {
      expect(ImageUtil.getThumbnailSize(200, 300, false).height)
        .assertEqual(ImageUtil.resizeThumbnail(200, 300).height);
    });

    it('BrowserImageUtilTest_resizeThumbnail_001', 0, () => {
      let size = ImageUtil.resizeThumbnail(200, 400);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(400);
    });

    it('BrowserImageUtilTest_resizeThumbnail_002', 0, () => {
      let size = ImageUtil.resizeThumbnail(200, 800);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(600);
    });

    it('BrowserImageUtilTest_resizeThumbnail_003', 0, () => {
      let size = ImageUtil.resizeThumbnail(800, 200);
      expect(size.width).assertEqual(600);
      expect(size.height).assertEqual(200);
    });

    it('BrowserImageUtilTest_resizeThumbnail_004', 0, () => {
      let size = ImageUtil.resizeThumbnail(400, 800);
      expect(size.width).assertEqual(256);
      expect(size.height).assertEqual(256 * 2);
    });

    it('BrowserImageUtilTest_resizeThumbnail_005', 0, () => {
      let size = ImageUtil.resizeThumbnail(800, 400);
      expect(size.width).assertEqual(256 * 2);
      expect(size.height).assertEqual(256);
    });

    it('BrowserImageUtilTest_resizeThumbnail_006', 0, () => {
      let size = ImageUtil.resizeThumbnail(800, 40);
      expect(size.width).assertEqual(120);
      expect(size.height).assertEqual(40);
    });

    it('BrowserImageUtilTest_resizeVideoFrame_001', 0, () => {
      let size = ImageUtil.resizeVideoFrame(400, 800);
      expect(size.width).assertEqual(256);
      expect(size.height).assertEqual(512);
    });

    it('BrowserImageUtilTest_resizeVideoFrame_002', 0, () => {
      let size = ImageUtil.resizeVideoFrame(200, 400)
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(400);
    });

    it('BrowserImageUtilTest_getThumbnailJpgUri_with_thumbnailReady_is_true', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 1);
      expect(res).assertEqual('http://www.baidu.com?timestampApp=2012?' +
        'thumbnailModifiedMs=1&oper=thumbnail&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('BrowserImageUtilTest_getThumbnailJpgUri_with_thumbnailReady_is_false', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 0);
      expect(res).assertEqual('http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('BrowserImageUtilTest_getThumbnailAstcUri_with_thumbnailReady_is_true', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 1);
      expect(res).assertEqual(
        'http://www.baidu.com?timestampApp=2012?thumbnailModifiedMs=1&oper=astc&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('BrowserImageUtilTest_getThumbnailAstcUri_with_thumbnailReady_is_false', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0);
      expect(res).assertEqual(
        'http://www.baidu.com?timestampApp=2012&oper=astc&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('BrowserImageUtilTest_getThumbnailUri_001', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let isOpenYearMonth = false;
      let isPickerPage = false;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 0));
    });

    it('BrowserImageUtilTest_getThumbnailUri_002', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let isOpenYearMonth = true;
      let isPickerPage = false;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0));
    });

    it('BrowserImageUtilTest_getThumbnailUri_003', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let isOpenYearMonth = false;
      let isPickerPage = true;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0));
    });

    it('BrowserImageUtilTest_getThumbnailUri_004', 0, () => {
      let originUrl = '';
      let path = "myPhoto";
      let modifiedDate = 2012;
      let isOpenYearMonth = false;
      let isPickerPage = true;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage))
        .assertEqual('');
    });

    it('BrowserImageUtilTest_getLCDUri_001', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let decodeDynamicRange = 1;
      expect(ImageUtil.getLCDUri(originUrl, path, modifiedDate, decodeDynamicRange)).assertEqual(
        "http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=-1&height=-1&decodeDynamicRange=1&path=myPhoto");
    });

    it('BrowserImageUtilTest_getLCDUri_002', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let decodeDynamicRange = 0;
      expect(ImageUtil.getLCDUri(originUrl, path, modifiedDate, decodeDynamicRange)).assertEqual(
        "http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=-1&height=-1&path=myPhoto");
    });

    it('BrowserImageUtilTest_getLCDPath', 0, () => {
      let path = "/storage/cloud/files/";
      expect(ImageUtil.getLCDPath(path)).assertEqual(`/storage/Share/.thumbs//LCD.jpg`);
    });

    it('BrowserImageUtilTest_getHighlightCoverLcdUri', 0, () => {
      let item: MediaItem = new MediaItem();
      expect(ImageUtil.getHighlightCoverLcdUri(item, { width: -1, height: -1 }, 1)).assertEqual(
        `${item?.uri}?timestampApp=${item?.getDateModified()}&oper=thumbnail` +
          `&width=-1&height=-1` +
          `&decodeDynamicRange=1&path=${item?.path}`);
    });

    it('BrowserImageUtilTest_getLCDUriWithSize', 0, () => {
      let sourceUri = 'aaaa';
      let path = 'bbbb';
      let modifiedDate = 1111;
      let size: image.Size = { width: 256, height: 256 };
      expect(ImageUtil.getLCDUriWithSize(sourceUri, path, modifiedDate, size))
        .assertEqual('aaaa?timestampApp=1111&oper=thumbnail&width=256&height=256&path=bbbb');
    });

    it('BrowserImageUtilTest_toLcd_001', 0, () => {
      let size: image.Size = ImageUtil.toLcd(2000, 4000);
      expect(size.width).assertEqual(960);
      expect(size.height).assertEqual(1920);
    });

    it('BrowserImageUtilTest_toLcd_002', 0, () => {
      let size = ImageUtil.toLcd(800, 4000);
      expect(size.width).assertEqual(512);
      expect(size.height).assertEqual(2560);
    });

    it('BrowserImageUtilTest_toLcd_003', 0, () => {
      let size = ImageUtil.toLcd(200, 4000);
      expect(size.width).assertEqual(96);
      expect(size.height).assertEqual(1920);
    });

    it('BrowserImageUtilTest_toLcd_004', 0, () => {
      let size = ImageUtil.toLcd(200, 1000);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(1000);
    });

    it('BrowserImageUtilTest_toLcd_005', 0, () => {
      let size = ImageUtil.toLcd(4000, 2000);
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(960);
    });

    it('BrowserImageUtilTest_toLcd_006', 0, () => {
      let size = ImageUtil.toLcd(4000, 800);
      expect(size.width).assertEqual(2560);
      expect(size.height).assertEqual(512);
    });

    it('BrowserImageUtilTest_toLcd_007', 0, () => {
      let size = ImageUtil.toLcd(4000, 200);
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(96);
    });

    it('BrowserImageUtilTest_toLcd_008', 0, () => {
      let size = ImageUtil.toLcd(1000, 200);
      expect(size.width).assertEqual(1000);
      expect(size.height).assertEqual(200);
    });

    it('BrowserImageUtilTest_getThumbnailReady', 0, () => {
      ImageUtil.getThumbnailReady();
      expect(ImageUtil.isOpenReady).assertFalse();
    });

    it('BrowserImageUtilTest_formatFileSize_001', 0, () => {
      let fileSize = 0;
      let num = ImageUtil.formatFileSize(fileSize);
      expect(num).assertEqual('0 KB');
    });

    it('BrowserImageUtilTest_formatFileSize_002', 0, () => {
      let fileSize = 1;
      let num = ImageUtil.formatFileSize(fileSize);
      expect(num).assertEqual('1.00 BYTE');
    });

    it('BrowserImageUtilTest_formatFileSize_003', 0, () => {
      let fileSize = 1000;
      let num = ImageUtil.formatFileSize(fileSize);
      expect(num).assertEqual('1.00 KB');
    });

    it('BrowserImageUtilTest_formatFileSize_004', 0, () => {
      let fileSize = 1000 * 1000;
      let num = ImageUtil.formatFileSize(fileSize);
      expect(num).assertEqual('1.00 MB');
    });

    it('BrowserImageUtilTest_formatFileSize_005', 0, () => {
      let fileSize = 1000 * 1000 * 1000;
      let num = ImageUtil.formatFileSize(fileSize);
      expect(num).assertEqual('1.00 GB');
    });

    it('BrowserImageUtilTest_getPreviewImageLayoutRatio_001', 0, () => {
      let width = 0;
      let height = 0;
      let num = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num).assertEqual(PreviewImageLimitedRatio.VERTICAL);
    });

    it('BrowserImageUtilTest_getPreviewImageLayoutRatio_002', 0, () => {
      // 横向长图，长短边比限制在3:1内
      let width = 1080;
      let height = 256;
      let num = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num).assertEqual(PreviewImageLimitedRatio.HORIZONTAL);
    });

    it('BrowserImageUtilTest_getPreviewImageLayoutRatio_003', 0, () => {
      let width = 1080;
      let height = 512;
      let num = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num).assertEqual(height / width);
    });

    it('BrowserImageUtilTest_getPreviewImageLayoutRatio_004', 0, () => {
      // 横向长图，长短边比限制在3:1内
      let width = 256;
      let height = 1080;
      let num = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num).assertEqual(PreviewImageLimitedRatio.VERTICAL_LONG_IMAGE);
    });

    it('BrowserImageUtilTest_getPreviewImageLayoutRatio_005', 0, () => {
      // 横向长图，长短边比限制在3:1内
      let width = 512;
      let height = 1080;
      let num = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num).assertEqual(height / width);
    });

    it('BrowserImageUtilTest_getSingleLineIrregularModeAspectRatio_001', 0, () => {
      let num = ImageUtil.getSingleLineIrregularModeAspectRatio(0, 0);
      expect(num).assertEqual(1);
    });

    it('BrowserImageUtilTest_getSingleLineIrregularModeAspectRatio_002', 0, () => {
      let num = ImageUtil.getSingleLineIrregularModeAspectRatio(1080, 256);
      expect(num).assertEqual(3);
    });

    it('BrowserImageUtilTest_getSingleLineIrregularModeAspectRatio_003', 0, () => {
      let num = ImageUtil.getSingleLineIrregularModeAspectRatio(1080, 512);
      expect(num).assertEqual(1080 / 512);
    });

    it('BrowserImageUtilTest_getSingleLineIrregularModeAspectRatio_004', 0, () => {
      let num = ImageUtil.getSingleLineIrregularModeAspectRatio(256, 1080);
      expect(num).assertEqual(1 / 3);
    });

    it('BrowserImageUtilTest_getSingleLineIrregularModeAspectRatio_005', 0, () => {
      let num = ImageUtil.getSingleLineIrregularModeAspectRatio(512, 1080);
      expect(num).assertEqual(512 / 1080);
    });

    it('BrowserImageUtilTest_getDisplaySize_001', 0, () => {
      let num = ImageUtil.getDisplaySize(1001);
      expect(num).assertEqual('1 kB');
    });

    it('BrowserImageUtilTest_getDisplaySize_002', 0, () => {
      let num = ImageUtil.getDisplaySize(1000001);
      expect(num).assertEqual('1 MB');
    });

    it('BrowserImageUtilTest_getDisplaySize_003', 0, () => {
      let num = ImageUtil.getDisplaySize(1000000001);
      expect(num).assertEqual('1 GB');
    });

    it('BrowserImageUtilTest_getSortDisplaySize_001', 0, () => {
      let num = ImageUtil.getSortDisplaySize(1001);
      expect(num).assertEqual('1 kB');
    });

    it('BrowserImageUtilTest_getSortDisplaySize_002', 0, () => {
      let num = ImageUtil.getSortDisplaySize(1000001);
      expect(num).assertEqual('1 MB');
    });

    it('BrowserImageUtilTest_getSortDisplaySize_003', 0, () => {
      let num = ImageUtil.getSortDisplaySize(1000000001);
      expect(num).assertEqual('1 GB');
    });

    it('BrowserImageUtilTest_formatMBSize_001', 0, () => {
      let num = ImageUtil.formatMBSize(0);
      expect(num).assertEqual(0);
    });

    it('BrowserImageUtilTest_formatMBSize_002', 0, () => {
      let num = ImageUtil.formatMBSize(1000001);
      expect(num).assertEqual(1);
    });

    it('BrowserImageUtilTest_isExitTransparentChannelImg', 0, () => {
      let num = ImageUtil.isExitTransparentChannelImg('.png');
      expect(num).assertEqual(false);
    });

    it('BrowserImageUtilTest_isExitTransparentChannelLocalImgMimeType', 0, () => {
      let item = new MediaItem();
      item.setPosition(photoAccessHelper.PositionType.LOCAL);

      let num = ImageUtil.isExitTransparentChannelLocalImgMimeType(item);
      expect(num).assertEqual(false);
    });

    it('BrowserImageUtilTest_encryptThumbnailUri_001', 0, () => {
      let num = ImageUtil.encryptThumbnailUri('');
      expect(num).assertEqual('');
    });

    it('BrowserImageUtilTest_encryptThumbnailUri_002', 0, () => {
      let num = ImageUtil.encryptThumbnailUri('******');
      expect(num).assertEqual('******');
    });

    it('BrowserImageUtilTest_encryptThumbnailUri_003', 0, () => {
      let num = ImageUtil.encryptThumbnailUri('/******');
      expect(num).assertEqual('******');
    });

    it('BrowserImageUtilTest_encryptThumbnailUri_004', 0, () => {
      let num = ImageUtil.encryptThumbnailUri('/aaaa.img');
      expect(num).assertEqual('/******.img');
    });

    it('BrowserImageUtilTest_getSelectedSmallImgHeight', 0, () => {
      let num = ImageUtil.getSelectedSmallImgHeight();
      expect(num).assertEqual(36);
    });

    it('BrowserImageUtilTest_getSelectedSmallImgWidth', 0, () => {
      let num = ImageUtil.getSelectedSmallImgWidth();
      expect(num).assertEqual(48);
    });

    it('BrowserImageUtilTest_getSmallImgWidth', 0, () => {
      let num = ImageUtil.getSmallImgWidth();
      expect(num).assertEqual(18);
    });
  })
}
