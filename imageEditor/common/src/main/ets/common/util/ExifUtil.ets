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
import image from '@ohos.multimedia.image';
import { HiLog } from './HiLog';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import HashMap from '@ohos.util.HashMap';
import { Obj } from '@ohos/tools/tsIgnore/standardLibrary/Obj.e';
import { Trace } from './Trace';
import { util } from '@kit.ArkTS';
import { XT_STYLE_OFF } from '../const';

const XT_STYLE_MIN_COLOR_TEMPERATURE_VALUE = 0;
const XT_STYLE_MAX_COLOR_TEMPERATURE_VALUE = 20;
const XT_STYLE_MIN_SATURATION_VALUE = 0;
const XT_STYLE_MAX_SATURATION_VALUE = 10;
const XT_STYLE_MIN_LIGHT_SHADOW_VALUE = 0;
const XT_STYLE_MAX_LIGHT_SHADOW_VALUE = 10;
const TAG = 'ExifUtil';

/* instrument ignore file */
export default class ExifUtil {
  private static businessKeys: image.PropertyKey[] = [
    image.PropertyKey.IMAGE_WIDTH,
    image.PropertyKey.IMAGE_LENGTH,
    image.PropertyKey.PIXEL_X_DIMENSION,
    image.PropertyKey.PIXEL_Y_DIMENSION,
    'HwMnoteXtStyleTemplateName' as image.PropertyKey,
    'HwMnoteXtStyleCustomLightAndShadow' as image.PropertyKey,
    'HwMnoteXtStyleCustomSaturation' as image.PropertyKey,
    'HwMnoteXtStyleCustomHue' as image.PropertyKey,
    image.PropertyKey.DATE_TIME,
    image.PropertyKey.CAPTURE_MODE, // 大光圈业务使用字段，必须从原图复制修改
  ];

  /**
   * 获取所有EXIF属性Key列表
   *
   * @returns 所有EXIF属性Key列表
   */
  public static getAllExifProps(): image.PropertyKey[] {
    let propArray: image.PropertyKey[] = Object.values(image.PropertyKey);
    HiLog.d('ExifUtil', `getAllExifProps: ${JSON.stringify(propArray)}`);
    return propArray;
  }

  /**
   * 转移图片EXIF信息
   *
   * @param tag 日志记录模块
   * @param sourceUri 原图片
   * @param outputUri 输出图片
   * @param isDoAiRefine isDoAiRefine
   * @param xtStyleParams XTStyleExifUpdateData
   * @param isAiLableNeeded isAiLableNeeded
   * @param isXmageWatermark 是否保存XMAGE水印信息
   */
  public static async transferAll(tag: string, sourceUri: string, outputUri: string | undefined, isDoAiRefine: boolean,
    isAiLableNeeded: boolean, isXmageWatermark: boolean): Promise<void> {
    if (!sourceUri || !outputUri) {
      HiLog.d(tag, 'try transferExifInfo, but url is empty');
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
        HiLog.e(tag, 'transferExifInfo in image source is undefined, uri: %{public}s', sourceUri);
        return;
      }
      outFile = await fs.open(outputUri, fs.OpenMode.READ_WRITE);
      outImgSource = image.createImageSource(outFile.fd);
      if (!outImgSource || outImgSource === undefined) {
        HiLog.e(tag, 'transferExifInfo out image source is undefined, fd: %{public}i', outFile.fd);
        return;
      }

      let records: Record<image.PropertyKey, string | null> =
        await ExifUtil.getAllExifRecord(tag, inImgSource, ExifUtil.getAllExifProps());
      // 查询到的结果包含 null 和 default_exif_value 值，修改会部分报错，修改前移除这部分值
      let modifyProps: HashMap<image.PropertyKey, string | null> = ExifUtil.removeReadonlyAndNullValue(records);
      // 移出已经修改过的key
      let existKeySet: Record<image.PropertyKey, string | null> =
        await ExifUtil.getAllExifRecord(tag, outImgSource, Array.from(modifyProps.keys()));
      ExifUtil.removeKeyIfExist(tag, modifyProps, existKeySet, outImgSource.getImageInfoSync());

      // 添加 AI 隐式标识
      if (isAiLableNeeded) {
        let aiHiddenLabel = ExifUtil.generateAiLabel();
        modifyProps.set('UserComment' as image.PropertyKey, aiHiddenLabel);
      }

      // 可修改项为空时不处理
      modifyProps.set('HwMnoteAiEdit' as image.PropertyKey, isDoAiRefine ? '1' : '0');
      HiLog.i(tag, `transferExifInfo success set ai flag ${isDoAiRefine.toString()}`);
      await ExifUtil.upDateXtStyleExifInfos(tag, modifyProps);
      if (modifyProps.isEmpty()) {
        HiLog.d(tag, 'transferExifInfo to modify properties empty, skip modify.');
        return;
      }
      ExifUtil.judgeAndUpdatePhotoExifInfo(tag, modifyProps, outImgSource);

      await ExifUtil.updateWaterMarkExif(isXmageWatermark, modifyProps, outImgSource);

      HiLog.i(tag, `transferExifInfo to modify properties size: ${modifyProps.length.toString()}`);
      modifyProps.forEach((value: string, key: image.PropertyKey) => {
        HiLog.d(tag, `transferExifInfo key = ${key}, value = ${value}`);
      });

      // 调用执行修改EXIF信息, 数量大于0时执行修改
      Trace.begin(`modifyImageProperties-${modifyProps.length}`);
      modifyProps.length > 0 && await outImgSource.modifyImageProperties(ExifUtil.mapToRecord(modifyProps))
        .catch((saveError: BusinessError) => {
          HiLog.e(tag, `transferExifInfo modify error: ${saveError}`);
        });
      Trace.end(`modifyImageProperties-${modifyProps.length}`);
    } catch (err) {
      HiLog.e(tag, `transferExifInfo error: ${err}`);
    } finally {
      ExifUtil.releaseImageSource(tag, outImgSource);
      ExifUtil.releaseImageSource(tag, inImgSource);
      HiLog.i(tag, `[fd flag] transferAll outFile,fs closeSync fd: ${outFile?.fd}`);
      ExifUtil.closeFile(tag, outFile);
      HiLog.i(tag, `[fd flag] transferAll sourceFile,fs closeSync fd: ${sourceFile?.fd}`);
      ExifUtil.closeFile(tag, sourceFile);
    }
  }

  private static async updateWaterMarkExif(hasWatermark: boolean,
    modifyProps: HashMap<image.PropertyKey, string | null>, outImgSource: image.ImageSource): Promise<void> {
    try {
      HiLog.i(TAG, `updateWaterMarkExif hasWatermark=${hasWatermark}`);
      if (hasWatermark) {
        await ExifUtil.changeWaterMarkExif(modifyProps, outImgSource);
      } else {
        // 水印图经过了"另存为"或"分享"，editdata = ''，hasWatermark = false
        // 清除watermark exif，防止切换动态效果后，大图页显示异常
        modifyProps.set(image.PropertyKey.IS_XMAGE_SUPPORTED, undefined);
        modifyProps.set(image.PropertyKey.XMAGE_MODE, undefined)
        modifyProps.set(image.PropertyKey.XMAGE_LEFT, undefined)
        modifyProps.set(image.PropertyKey.XMAGE_TOP, undefined)
        modifyProps.set(image.PropertyKey.XMAGE_RIGHT, undefined)
        modifyProps.set(image.PropertyKey.XMAGE_BOTTOM, undefined)
      }
    } catch (error) {
      HiLog.e(TAG, `updateWaterMarkExif error ${error}`);
    }
  }

  private static async changeWaterMarkExif(propsMap: HashMap<image.PropertyKey, string | null>,
    imgSource: image.ImageSource): Promise<void> {
    HiLog.begin(TAG, `changeWaterMarkExif`);
    try {
      let xmageKeys: image.PropertyKey[] = [
        image.PropertyKey.IS_XMAGE_SUPPORTED,
        image.PropertyKey.XMAGE_MODE,
        image.PropertyKey.XMAGE_LEFT,
        image.PropertyKey.XMAGE_TOP,
        image.PropertyKey.XMAGE_RIGHT,
        image.PropertyKey.XMAGE_BOTTOM];
      let records: Record<image.PropertyKey, string | null> = await imgSource.getImageProperties(xmageKeys);
      let modifyProps: HashMap<image.PropertyKey, string | null> = ExifUtil.removeReadonlyAndNullValue(records);
      if (modifyProps.hasKey(image.PropertyKey.XMAGE_MODE) && modifyProps.hasKey(image.PropertyKey.XMAGE_LEFT)) {
        propsMap.set(image.PropertyKey.IS_XMAGE_SUPPORTED, modifyProps.get(image.PropertyKey.IS_XMAGE_SUPPORTED))
        propsMap.set(image.PropertyKey.XMAGE_MODE, modifyProps.get(image.PropertyKey.XMAGE_MODE))
        propsMap.set(image.PropertyKey.XMAGE_LEFT, modifyProps.get(image.PropertyKey.XMAGE_LEFT))
        propsMap.set(image.PropertyKey.XMAGE_TOP, modifyProps.get(image.PropertyKey.XMAGE_TOP))
        propsMap.set(image.PropertyKey.XMAGE_RIGHT, modifyProps.get(image.PropertyKey.XMAGE_RIGHT))
        propsMap.set(image.PropertyKey.XMAGE_BOTTOM, modifyProps.get(image.PropertyKey.XMAGE_BOTTOM))
      }
    } catch (err) {
      HiLog.e(TAG, `changeWaterMarkExif error: ${err}`);
    }
    HiLog.end(TAG, `changeWaterMarkExif`);
  }

  private static async getAllExifRecord(tag: string,
    imgSource: image.ImageSource, keys: image.PropertyKey[]): Promise<Record<image.PropertyKey, string | null>> {
    Trace.begin('getAllExifRecord');
    try {
      HiLog.d(tag, `getImageProperties length=${keys.length}`);
      return await imgSource.getImageProperties(keys);
    } catch (e) {
      HiLog.e(tag, 'transferExifInfo getImageProperties: %{public}o', e);
      return {} as Record<image.PropertyKey, string | null>;
    } finally {
      Trace.end('getAllExifRecord');
    }
  }

  private static removeKeyIfExist(tag: string, modifyProps: HashMap<image.PropertyKey, string | null>,
    existKeySet: Record<image.PropertyKey, string | null>, modifyImgInfo: image.ImageInfo): void {
    HiLog.i(tag, `removeKeyIfExist width=${modifyImgInfo.size.width}, height=${modifyImgInfo.size.height}`);
    for (const key of modifyProps.keys()) {
      let val: string | null = existKeySet[key];
      if (val === undefined || val === null) {
        continue;
      }
      // 移出不需要修改的宽高（业务需要修改，已经修改过的）
      if ((key === image.PropertyKey.IMAGE_WIDTH || key === image.PropertyKey.PIXEL_X_DIMENSION) &&
        parseInt(val) === modifyImgInfo.size.width) {
        modifyProps.remove(key);
        continue;
      }
      if ((key === image.PropertyKey.IMAGE_LENGTH || key === image.PropertyKey.PIXEL_Y_DIMENSION) &&
        parseInt(val) === modifyImgInfo.size.height) {
        modifyProps.remove(key);
        continue;
      }
      if (ExifUtil.businessKeys.includes(key)) {
        // 跳过业务要修改的字段
        continue;
      }
      // 移出不需要修改已经存在的字段
      if (existKeySet[key] !== undefined && modifyProps.get(key) === existKeySet[key]) {
        modifyProps.remove(key);
      }
    }
  }

  private static async releaseImageSource(tag: string, imgSource: image.ImageSource | undefined): Promise<void> {
    if (!imgSource) {
      return;
    }
    try {
      await imgSource?.release();
    } catch (error) {
      HiLog.e(tag, `release image source error: ${error}`);
    }
  }

  private static async closeFile(tag: string, file: fs.File | undefined): Promise<void> {
    if (!file) {
      return;
    }
    try {
      await fs.close(file);
    } catch (error) {
      HiLog.e(tag, `close file error: ${error}`);
    }
  }

  private static upDateXtStyleModifyProps(modifyProps: HashMap<image.PropertyKey, string | null>, key: string,
    minValue: number, maxValue: number) {
    let value: string | undefined | null = modifyProps.get(key as image.PropertyKey);
    if (typeof value === 'string') {
      let numerator: number = parseFloat(value) * maxValue;
      let res: string = String(numerator) + '/' + String(maxValue - minValue);
      HiLog.i('MediaSaveManager', 'upDateXtStyleExifFormat res = %{public}s', res);
      modifyProps.set(key as image.PropertyKey, res);
    }
  }

  private static async upDateXtStyleExifInfos(tag: string, modifyProps: HashMap<image.PropertyKey, string | null>):
    Promise<void> {
      let templateName: string | undefined | null =
        modifyProps.get('HwMnoteXtStyleTemplateName' as image.PropertyKey);
      if (templateName === undefined || templateName === '' || templateName === null) {
        HiLog.i(tag, `transferExifInfo upDateXtStyleExifInfos ignore`)
      } else {
        HiLog.i(tag, `transferExifInfo upDateXtStyleExifInfos revert`)
        //没有修改XXX数据 把原图值读出写入效果图
        let xtStyleTemplateStr: string | undefined | null =
          modifyProps.get('HwMnoteXtStyleTemplateName' as image.PropertyKey);
        if (typeof xtStyleTemplateStr === 'string') {
          let xtStyleTemplate: number = parseFloat(xtStyleTemplateStr);
          xtStyleTemplate = xtStyleTemplate === 0 ? XT_STYLE_OFF : xtStyleTemplate;
          modifyProps.set('HwMnoteXtStyleTemplateName' as image.PropertyKey, xtStyleTemplate.toString());
        }
        ExifUtil.upDateXtStyleModifyProps(modifyProps, 'HwMnoteXtStyleCustomLightAndShadow',
          XT_STYLE_MIN_LIGHT_SHADOW_VALUE, XT_STYLE_MAX_LIGHT_SHADOW_VALUE);
        ExifUtil.upDateXtStyleModifyProps(modifyProps, 'HwMnoteXtStyleCustomSaturation',
          XT_STYLE_MIN_SATURATION_VALUE, XT_STYLE_MAX_SATURATION_VALUE);
        ExifUtil.upDateXtStyleModifyProps(modifyProps, 'HwMnoteXtStyleCustomHue',
          XT_STYLE_MIN_COLOR_TEMPERATURE_VALUE, XT_STYLE_MAX_COLOR_TEMPERATURE_VALUE);
    }
  }

  private static judgeAndUpdatePhotoExifInfo(tag: string, propsMap: HashMap<image.PropertyKey, string |
  null>, imgSource: image.ImageSource): void {
    let imgInfo: image.ImageInfo = imgSource.getImageInfoSync();
    HiLog.i(tag, `transferAllExif width=${imgInfo?.size?.width}, height=${imgInfo?.size?.height}`);
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
    for (let it = iterator.next();!it.done; it = iterator.next()) {
      // default_exif_value 为值的字段不能修改，会报错
      // 因为Hw字段是按照某种协议存入MakerNote字段里的，后续如果再以MakerNote为key写入内容的话，会把之前已经写入的Hw字段覆盖
      if (it.value[1] === null || 'default_exif_value' === it.value[1] || it.value[1] === undefined ||
        image.PropertyKey.MAKER_NOTE === it.value[0]) {
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

  public static generateAiLabel(): string {
    // AI隐式标识的key是首字母大写, 因此此处变量命名首字母大写, 请勿修改
    interface LabelValue {
      Label: string;
      ContentProducer: string;
      ProduceID: string;
      ReservedCode1: string;
      ContentPropagator: string;
      PropagateID: string;
      ReservedCode2: string;
    }
    // AI隐式标识的key是首字母大写, 因此此处变量命名首字母大写, 请勿修改
    interface AiLabel {
      AIGC: LabelValue;
    }

    let uuid = Date.now() + util.generateRandomUUID();

    let labelValue: LabelValue =
      {
        Label: '1',
        ContentProducer: '0011' + '913201147770231720' + '10000' ,
        ProduceID: uuid,
        ReservedCode1: '',
        ContentPropagator: '0011' + '913201147770231720' + '10000',
        PropagateID: uuid,
        ReservedCode2: '',
      };
    let aiLabel: AiLabel = {
      AIGC: labelValue,
    };

    return JSON.stringify(aiLabel);
  }

  public static readIntVal(imageSource: image.ImageSource, key: string | image.PropertyKey,
    options: image.ImagePropertyOptions, defaultValue: number): Promise<number> {
    return imageSource.getImageProperty(key, options).then(val => {
      if (val === 'default_exif_value') {
        return defaultValue;
      }
      if (!val) {
        return defaultValue;
      }
      return parseInt(val);
    })
  }

  public static hasKey(imageSource: image.ImageSource, key: string | image.PropertyKey,
    options: image.ImagePropertyOptions): Promise<boolean> {
    return imageSource.getImageProperty(key, options).then(val => {
      if (val === 'default_exif_value' || val === undefined || val === '') {
        return false;
      }
      return true;
    })
  }
}