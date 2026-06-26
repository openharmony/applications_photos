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

const NUMBER_ONE: number = 1;
enum PreviewImageLimitedRatio {
  VERTICAL = 4 / 3,
  HORIZONTAL = 1 / 3,
  VERTICAL_LONG_IMAGE = 3 / 1,
}

export default function ImageUtilTest() {
  describe('ImageUtilTest', () => {
    it('ImageUtilTest_computeSampleSize', 0, () => {
      expect(ImageUtil.computeSampleSize(0, 1, 1, 1)).assertEqual(2);
      expect(ImageUtil.computeSampleSize(1, 0, 1, 1)).assertEqual(2);
      expect(ImageUtil.computeSampleSize(1, 1, 0, 1)).assertEqual(2);
      expect(ImageUtil.computeSampleSize(1, 1, 1, 0)).assertEqual(2);
      expect(ImageUtil.computeSampleSize(1, 1, -1, 10000)).assertEqual(1);
      expect(ImageUtil.computeSampleSize(9, 9, 1, -1)).assertEqual(16);
      expect(ImageUtil.computeSampleSize(10, 10, -1, -1)).assertEqual(1);
    });

    it('ImageUtilTest_calcThumbnailSize', 0, () => {
      expect(ImageUtil.calcThumbnailSize(0, 0, undefined)).assertDeepEquals({
        width: 256, height: 256,
      });
      expect(ImageUtil.calcThumbnailSize(100, 100, undefined)).assertDeepEquals({
        width: 100, height: 100,
      });
      expect(ImageUtil.calcThumbnailSize(750, 1500, undefined)).assertDeepEquals({
        width: 1440, height: 720,
      });
      expect(ImageUtil.calcThumbnailSize(1500, 750, undefined)).assertDeepEquals({
        width: 720, height: 1440,
      });
      expect(ImageUtil.calcThumbnailSize(1500, 750, Constants.ANGLE_90)).assertDeepEquals({
        width: 1440, height: 720,
      });
      expect(ImageUtil.calcThumbnailSize(750, 1500, Constants.ANGLE_270)).assertDeepEquals({
        width: 720, height: 1440,
      });
    });

    it('ImageUtilTest_isThumbnailReady', 0, () => {
      ImageUtil.thumbnailReadyFlag = true;
      ImageUtil.setThumbnailReadyFlag(true);
      expect(ImageUtil.isThumbnailReady()).assertTrue();

      ImageUtil.setThumbnailReadyFlag(false);
      expect(ImageUtil.isThumbnailReady()).assertFalse();

      ImageUtil.thumbnailReadyFlag = false;
      ImageUtil.setThumbnailReadyFlag(true);
      expect(ImageUtil.isThumbnailReady()).assertFalse();

      ImageUtil.setThumbnailReadyFlag(false);
      expect(ImageUtil.isThumbnailReady()).assertFalse();
    });

    it('ImageUtilTest_nextPowerOf2', 0, () => {

      expect(ImageUtil.nextPowerOf2(-1)).assertEqual(1);

      expect(ImageUtil.nextPowerOf2((1 << 30) + 1)).assertEqual(1);

      expect(ImageUtil.nextPowerOf2(2)).assertEqual(2);
    });

    it('ImageUtilTest_generateTimeId', 0, () => {
      // dateTaken为‘’,则生成的timeId为''
      let dateTaken = '';
      let fileId = 'myPhoto';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual('');

      // fileId‘’,则生成的timeId为''
      dateTaken = "1234567890";
      fileId = '';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual('');

      // dateTaken不足13位，则在dateTaken前面补充0凑13位
      dateTaken = "1234567890";
      fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("00012345678901234567890");

      // dateTaken为13位，保持原状
      dateTaken = "1234567890123";
      fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("12345678901231234567890");

      // dateTaken超过13位，保持原状
      dateTaken = "12345678901234";
      fileId = '1234567890';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("123456789012341234567890");

      // fileId必须为10位，且基本不足10位，直接在前面补0
      dateTaken = "12345678901234";
      fileId = '123456';
      expect(ImageUtil.generateTimeId(dateTaken, fileId)).assertEqual("123456789012340000123456");
    });

    it('ImageUtilTest_calcRatio', 0, () => {
      let info: Size = { width: 0, height: 300 };
      expect(ImageUtil.calcRatio(info)).assertEqual(1);

      info.width = 300;
      info.height = 0;
      expect(ImageUtil.calcRatio(info)).assertEqual(1);

      info.width = 200;
      info.height = 400;
      expect(ImageUtil.calcRatio(info)).assertEqual(0.5);
    });

    it('ImageUtilTest_calcThumbnail', 0, () => {
      let imageUri = "/data/myPhoto";
      // 长度为0，返回256 * 256
      expect(ImageUtil.calcThumbnail(imageUri, 0, 200, 0)).assertEqual(
        "/data/myPhoto/thumbnail/256/256");

      // 宽度为0，返回256 * 256
      expect(ImageUtil.calcThumbnail(imageUri, 100, 0, 0)).assertEqual(
        "/data/myPhoto/thumbnail/256/256");

      expect(ImageUtil.calcThumbnail(imageUri, 400, 800, 0)).assertEqual(
        "/data/myPhoto/thumbnail/800/400");

      expect(ImageUtil.calcThumbnail(imageUri, 800, 400, 0)).assertEqual(
        "/data/myPhoto/thumbnail/400/800");

      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_90)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");

      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_270)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");

      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_90)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");

      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_270)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");

      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_180)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");

      expect(ImageUtil.calcThumbnail(imageUri, 1600, 800, Constants.ANGLE_360)).assertEqual(
        "/data/myPhoto/thumbnail/720/1440");

      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_180)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");

      expect(ImageUtil.calcThumbnail(imageUri, 800, 1600, Constants.ANGLE_360)).assertEqual(
        "/data/myPhoto/thumbnail/1440/720");
    });

    it('ImageUtilTest_getThumbnailSize', 0, () => {
      // 长度为0，返回256 * 256
      expect(ImageUtil.getThumbnailSize(200, 300, true).width).assertEqual(256);

      expect(ImageUtil.getThumbnailSize(200, 300, true).height).assertEqual(256);

      expect(ImageUtil.getThumbnailSize(200, 300, false).width).assertEqual(ImageUtil.resizeThumbnail(200, 300).width);

      expect(ImageUtil.getThumbnailSize(200, 300, false).height).assertEqual(ImageUtil.resizeThumbnail(200, 300).height);


    });

    it('ImageUtilTest_resizeThumbnail', 0, () => {
      let size = ImageUtil.resizeThumbnail(200, 400);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(400);

      size = ImageUtil.resizeThumbnail(200, 800);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(600);

      size = ImageUtil.resizeThumbnail(800, 200);
      expect(size.width).assertEqual(600);
      expect(size.height).assertEqual(200);

      size = ImageUtil.resizeThumbnail(400, 800);
      expect(size.width).assertEqual(256);
      expect(size.height).assertEqual(256 * 2);

      size = ImageUtil.resizeThumbnail(800, 400);
      expect(size.width).assertEqual(256 * 2);
      expect(size.height).assertEqual(256);

      size = ImageUtil.resizeThumbnail(800, 40);
      expect(size.width).assertEqual(120);
      expect(size.height).assertEqual(40);
    });

    it('ImageUtilTest_resizeVideoFrame', 0, () => {
      let size = ImageUtil.resizeVideoFrame(400, 800);
      expect(size.width).assertEqual(256);
      expect(size.height).assertEqual(512);

      size = ImageUtil.resizeVideoFrame(200, 400)
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(400);
    });

    it('ImageUtilTest_getThumbnailJpgUri_with_thumbnailReady_is_true', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 1);
      expect(res).assertEqual('http://www.baidu.com?timestampApp=2012&' +
        'thumbnailModifiedMs=1&oper=thumbnail&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('ImageUtilTest_getThumbnailJpgUri_with_thumbnailReady_is_false', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 0);
      expect(res).assertEqual('http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });


    it('ImageUtilTest_getThumbnailAstcUri_with_thumbnailReady_is_true', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 1);
      expect(res).assertEqual(
        'http://www.baidu.com?timestampApp=2012&thumbnailModifiedMs=1&oper=astc&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('ImageUtilTest_getThumbnailAstcUri_with_thumbnailReady_is_false', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let res = ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0);
      expect(res).assertEqual(
        'http://www.baidu.com?timestampApp=2012&oper=astc&width=0&height=0&path=myPhoto');
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('ImageUtilTest_getThumbnailUri', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let isOpenYearMonth = false;
      let isPickerPage = false;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailJpgUri(originUrl, path, modifiedDate, 0));

      isOpenYearMonth = true;
      isPickerPage = false;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0));

      isOpenYearMonth = false;
      isPickerPage = true;
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage)).assertEqual(
        ImageUtil.getThumbnailAstcUri(originUrl, path, modifiedDate, 0));

      originUrl = '';
      expect(ImageUtil.getThumbnailUri(originUrl, path, modifiedDate, isOpenYearMonth, 0, isPickerPage))
        .assertEqual('');
    });

    it('ImageUtilTest_getLCDUri', 0, () => {
      let originUrl = "http://www.baidu.com";
      let path = "myPhoto";
      let modifiedDate = 2012;
      let decodeDynamicRange = 1;

      expect(ImageUtil.getLCDUri(originUrl, path, modifiedDate, decodeDynamicRange)).assertEqual(
        "http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=-1&height=-1&decodeDynamicRange=1&path=myPhoto");

      decodeDynamicRange = 0;
      expect(ImageUtil.getLCDUri(originUrl, path, modifiedDate, decodeDynamicRange)).assertEqual(
        "http://www.baidu.com?timestampApp=2012&oper=thumbnail&width=-1&height=-1&path=myPhoto");
    });

    it('ImageUtilTest_getLCDPath', 0, () => {
      let path = "/storage/cloud/files/";
      expect(ImageUtil.getLCDPath(path)).assertEqual(`/storage/Share/.thumbs//LCD.jpg`);
    });


    it('ImageUtilTest_getHighlightCoverLcdUri', 0, () => {

      let item: MediaItem = new MediaItem();

      expect(ImageUtil.getHighlightCoverLcdUri(item, { width: -1, height: -1 }, 1)).assertEqual(
        `${item?.uri}?timestampApp=${item?.getDateModified()}&oper=thumbnail` +
          `&width=-1&height=-1` +
          `&decodeDynamicRange=1&path=${item?.path}`);
    });


    it('ImageUtilTest_getLCDUriWithSize', 0, () => {
      let sourceUri = 'aaaa';
      let path = 'bbbb';
      let modifiedDate = 1111;
      let size: image.Size = { width: 256, height: 256 };
      expect(ImageUtil.getLCDUriWithSize(sourceUri, path, modifiedDate, size))
        .assertEqual('aaaa?timestampApp=1111&oper=thumbnail&width=256&height=256&path=bbbb');
    });

    it('ImageUtilTest_toLcd', 0, () => {
      let size: image.Size = ImageUtil.toLcd(2000, 4000);
      expect(size.width).assertEqual(960);
      expect(size.height).assertEqual(1920);

      size = ImageUtil.toLcd(800, 4000);
      expect(size.width).assertEqual(512);
      expect(size.height).assertEqual(2560);

      size = ImageUtil.toLcd(800, 4000);
      expect(size.width).assertEqual(512);
      expect(size.height).assertEqual(2560);

      size = ImageUtil.toLcd(200, 4000);
      expect(size.width).assertEqual(96);
      expect(size.height).assertEqual(1920);

      size = ImageUtil.toLcd(200, 1000);
      expect(size.width).assertEqual(200);
      expect(size.height).assertEqual(1000);

      size = ImageUtil.toLcd(4000, 2000);
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(960);

      size = ImageUtil.toLcd(4000, 800);
      expect(size.width).assertEqual(2560);
      expect(size.height).assertEqual(512);

      size = ImageUtil.toLcd(4000, 800);
      expect(size.width).assertEqual(2560);
      expect(size.height).assertEqual(512);

      size = ImageUtil.toLcd(4000, 200);
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(96);

      size = ImageUtil.toLcd(1000, 200);
      expect(size.width).assertEqual(1000);
      expect(size.height).assertEqual(200);
    });

    it('ImageUtilTest_getThumbnailReady', 0, () => {
      ImageUtil.getThumbnailReady();
      expect(ImageUtil.isOpenReady).assertFalse();
    });

    it('ImageUtilTest_formatFileSize', 0, () => {
      let fileSize = 0;
      let num0 = ImageUtil.formatFileSize(fileSize);
      expect(num0).assertEqual('0 KB');

      fileSize = 1;
      let num1 = ImageUtil.formatFileSize(fileSize);
      expect(num1).assertEqual('1.00 BYTE');

      fileSize = 1000;
      let num2 = ImageUtil.formatFileSize(fileSize);
      expect(num2).assertEqual('1.00 KB');

      fileSize = 1000 * 1000;
      let num3 = ImageUtil.formatFileSize(fileSize);
      expect(num3).assertEqual('1.00 MB');

      fileSize = 1000 * 1000 * 1000;
      let num4 = ImageUtil.formatFileSize(fileSize);
      expect(num4).assertEqual('1.00 GB');
    });

    it('ImageUtilTest_getPreviewImageLayoutRatio', 0, () => {
      let width = 0;
      let height = 0;
      let num1 = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num1).assertEqual(PreviewImageLimitedRatio.VERTICAL);

      // 横向长图，长短边比限制在3:1内
      width = 1080;
      height = 256;
      let num2 = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num2).assertEqual(PreviewImageLimitedRatio.HORIZONTAL);

      width = 1080;
      height = 512;
      let num3 = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num3).assertEqual(height / width);

      // 横向长图，长短边比限制在3:1内
      width = 256;
      height = 1080;
      let num4 = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num4).assertEqual(PreviewImageLimitedRatio.VERTICAL_LONG_IMAGE);

      // 横向长图，长短边比限制在3:1内
      width = 512;
      height = 1080;
      let num5 = ImageUtil.getPreviewImageLayoutRatio(width, height);
      expect(num5).assertEqual(height / width);

    });

    it('ImageUtilTest_getSingleLineIrregularModeAspectRatio', 0, () => {
      let num1 = ImageUtil.getSingleLineIrregularModeAspectRatio(0, 0);
      expect(num1).assertEqual(1);

      let num2 = ImageUtil.getSingleLineIrregularModeAspectRatio(1080, 256);
      expect(num2).assertEqual(3);

      let num3 = ImageUtil.getSingleLineIrregularModeAspectRatio(1080, 512);
      expect(num3).assertEqual(1080 / 512);

      let num4 = ImageUtil.getSingleLineIrregularModeAspectRatio(256, 1080);
      expect(num4).assertEqual(1 / 3);

      let num5 = ImageUtil.getSingleLineIrregularModeAspectRatio(512, 1080);
      expect(num5).assertEqual(512 / 1080);

    });

    it('ImageUtilTest_getDisplaySize', 0, () => {
      let num1 = ImageUtil.getDisplaySize(1001);
      expect(num1).assertEqual('1 kB');

      let num2 = ImageUtil.getDisplaySize(1000001);
      expect(num2).assertEqual('1 MB');

      let num3 = ImageUtil.getDisplaySize(1000000001);
      expect(num3).assertEqual('1 GB');
    });

    it('ImageUtilTest_getSortDisplaySize', 0, () => {
      let num1 = ImageUtil.getSortDisplaySize(1001);
      expect(num1).assertEqual('1 kB');

      let num2 = ImageUtil.getSortDisplaySize(1000001);
      expect(num2).assertEqual('1 MB');

      let num3 = ImageUtil.getSortDisplaySize(1000000001);
      expect(num3).assertEqual('1 GB');

    });

    it('ImageUtilTest_formatMBSize', 0, () => {
      let num1 = ImageUtil.formatMBSize(0);
      expect(num1).assertEqual(0);

      let num2 = ImageUtil.formatMBSize(1000001);
      expect(num2).assertEqual(1);

    });

    it('ImageUtilTest_isExitTransparentChannelImg', 0, () => {
      let num1 = ImageUtil.isExitTransparentChannelImg('.png');
      expect(num1).assertEqual(false);

    });

    it('ImageUtilTest_isExitTransparentChannelLocalImgMimeType', 0, () => {
      let item = new MediaItem();
      item.setPosition(photoAccessHelper.PositionType.LOCAL);

      let num1 = ImageUtil.isExitTransparentChannelLocalImgMimeType(item);
      expect(num1).assertEqual(false);

    });

    it('ImageUtilTest_encryptThumbnailUri', 0, () => {
      let num1 = ImageUtil.encryptThumbnailUri('');
      expect(num1).assertEqual('');

      let num2 = ImageUtil.encryptThumbnailUri('******');
      expect(num2).assertEqual('******');

      let num3 = ImageUtil.encryptThumbnailUri('/******');
      expect(num3).assertEqual('******');

      let num4 = ImageUtil.encryptThumbnailUri('/aaaa.img');
      expect(num4).assertEqual('/******.img');

    });

    it('ImageUtilTest_getSelectedSmallImgHeight', 0, () => {
      let num1 = ImageUtil.getSelectedSmallImgHeight();
      expect(num1).assertEqual(36);

    });

    it('ImageUtilTest_getSelectedSmallImgWidth', 0, () => {
      let num1 = ImageUtil.getSelectedSmallImgWidth();
      expect(num1).assertEqual(48);

    });

    it('ImageUtilTest_getSmallImgWidth', 0, () => {
      let num1 = ImageUtil.getSmallImgWidth();
      expect(num1).assertEqual(18);

    });

  })
}
