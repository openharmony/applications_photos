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
import lazy image from '@ohos.multimedia.image';
import lazy { BusinessError } from '@ohos.base';
import lazy fs from '@ohos.file.fs';
import lazy HashMap from '@ohos.util.HashMap';
import lazy { Obj } from '@ohos/tools/tsIgnore/standardLibrary/Obj.e';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

/* instrument ignore file */
export default class ExifUtil {
  /**
   * 获取所有EXIF属性Key列表
   *
   * @returns 所有EXIF属性Key列表
   */
  public static getAllExifProps(): image.PropertyKey[] {
    let propArray: image.PropertyKey[] = Object.values(image.PropertyKey);
    Log.debug('ExifUtil', `getAllExifProps: ${JSON.stringify(propArray)}`);
    return propArray;
  }

  /**
   * 转移图片EXIF信息
   *
   * @param tag 日志记录模块
   * @param sourceUri 原图片
   * @param outputUri 输出图片
   */
  public static async transferAll(tag: string, sourceUri: string, outputUri: string | undefined): Promise<void> {
    if (!sourceUri || !outputUri || outputUri === undefined) {
      Log.debug(tag, 'try transferExifInfo, but url is empty');
      return;
    }
    let sourceFile: fs.File | undefined = undefined;
    let outFile: fs.File | undefined = undefined;
    let inImgSource: image.ImageSource | undefined = undefined;
    let outImgSource: image.ImageSource | undefined = undefined;
    try {
      sourceFile = await fs.open(sourceUri, fs.OpenMode.READ_ONLY);
      inImgSource = image.createImageSource(sourceFile?.fd);
      if (!inImgSource || inImgSource === undefined) {
        Log.error(tag, 'transferExifInfo in image source is undefined, uri: ', sourceUri);
        return;
      }
      outFile = await fs.open(outputUri, fs.OpenMode.READ_WRITE);
      let records: Record<image.PropertyKey, string | null> =
        await inImgSource.getImageProperties(ExifUtil.getAllExifProps());
      // 查询到的结果包含 null 和 default_exif_value 值，修改会部分报错，修改前移除这部分值
      let modifyProps: HashMap<image.PropertyKey, string | null> = ExifUtil.removeReadonlyAndNullValue(records);
      Log.debug(tag, `transferExifInfo to modify properties size: ${modifyProps.length}`);
      // 可修改项为空时不处理
      if (modifyProps.isEmpty()) {
        Log.debug(tag, 'transferExifInfo to modify properties empty, skip modify.');
        return;
      }
      outImgSource = image.createImageSource(outFile.fd);
      if (!outImgSource || outImgSource === undefined) {
        Log.error(tag, `transferExifInfo out image source is undefined, fd: ${outFile.fd}`);
        return;
      }
      ExifUtil.judgeAndUpdatePhotoExifInfo(tag, modifyProps, outImgSource);
      // 调用执行修改EXIF信息
      await outImgSource.modifyImageProperties(ExifUtil.mapToRecord(modifyProps)).catch((saveError: BusinessError) => {
        Log.error(tag, 'transferExifInfo modify error: ', JSON.stringify(saveError));
      });
    } catch (err) {
      Log.error(tag, 'transferExifInfo error: ', JSON.stringify(err));
    } finally {
      ExifUtil.releaseImageSource(tag, outImgSource);
      ExifUtil.releaseImageSource(tag, inImgSource);
      Log.info(tag, `[fd flag] transferAll outFile,fs closeSync fd: ${outFile?.fd}`);
      ExifUtil.closeFile(tag, outFile);
      Log.info(tag, `[fd flag] transferAll sourceFile,fs closeSync fd: ${sourceFile?.fd}`);
      ExifUtil.closeFile(tag, sourceFile);
    }
  }

  private static async releaseImageSource(tag: string, imgSource: image.ImageSource | undefined): Promise<void> {
    if (!imgSource) {
      return;
    }
    try {
      await imgSource?.release();
    } catch (error) {
      Log.error(tag, `release image source error: ${error}`);
    }
  }

  private static async closeFile(tag: string, file: fs.File | undefined): Promise<void> {
    if (!file) {
      return;
    }
    try {
      await fs.close(file);
    } catch (error) {
      Log.error(tag, `close file error: ${error}`);
    }
  }

  private static judgeAndUpdatePhotoExifInfo(tag: string, propsMap: HashMap<image.PropertyKey, string |
  null>, imgSource: image.ImageSource): void {
    let imgInfo: image.ImageInfo = imgSource.getImageInfoSync();
    Log.info(tag, `transferAllExif width=${imgInfo?.size?.width}, height=${imgInfo?.size?.height}`);
    // 宽高EXIF信息处理
    if (propsMap.hasKey(image.PropertyKey.IMAGE_WIDTH) || propsMap.hasKey(image.PropertyKey.IMAGE_LENGTH)) {
      propsMap.set(image.PropertyKey.IMAGE_WIDTH, imgInfo?.size?.width.toString());
      propsMap.set(image.PropertyKey.IMAGE_LENGTH, imgInfo?.size?.height.toString());
    }
    // 像素EXIF信息处理
    if (propsMap.hasKey(image.PropertyKey.PIXEL_X_DIMENSION) || propsMap.hasKey(image.PropertyKey.PIXEL_Y_DIMENSION)) {
      propsMap.set(image.PropertyKey.PIXEL_X_DIMENSION, imgInfo?.size?.width.toString());
      propsMap.set(image.PropertyKey.PIXEL_Y_DIMENSION, imgInfo?.size?.height.toString());
    }
    // 日期处理
    if (propsMap.hasKey(image.PropertyKey.DATE_TIME)) {
      let nowDate: string = DateUtil.format(new Date(), 'yyyy:MM:dd HH:mm:ss');
      propsMap.set(image.PropertyKey.DATE_TIME, nowDate);
    }
  }

  private static removeReadonlyAndNullValue(records: Record<image.PropertyKey, string | null>):
    HashMap<image.PropertyKey, string | null> {
    let resultMap: HashMap<image.PropertyKey, string | null> = ExifUtil.recordToMap(records);
    let iterator: IterableIterator<[image.PropertyKey, string | null]> = resultMap.entries();
    for (let it = iterator.next(); !it.done; it = iterator.next()) {
      // default_exif_value 为值的字段不能修改，会报错
      if (it.value[1] === null || 'default_exif_value' === it.value[1]) {
        resultMap.remove(it.value[0]);
      }
    }
    return resultMap;
  }

  private static mapToRecord(myMap: HashMap<image.PropertyKey, string | null>):
    Record<image.PropertyKey, string | null> {
    return Obj.fromEntries(myMap.entries()) as Record<image.PropertyKey, string | null>;
  }

  private static recordToMap(myRecord: Record<image.PropertyKey, string | null>):
    HashMap<image.PropertyKey, string | null> {
    let transferMap: HashMap<image.PropertyKey, string | null> = new HashMap();
    let keys: image.PropertyKey[] = ExifUtil.getAllExifProps();
    keys.forEach(key => {
      let val: string | null = myRecord[key];
      if (val !== null) {
        transferMap.set(key, myRecord[key]);
      }
    });
    return transferMap;
  }
}