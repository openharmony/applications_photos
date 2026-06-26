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

import lazy Intl from '@ohos.intl';
import lazy i18n from '@ohos.i18n';

import lazy { Log } from './Log';

const TAG: string = 'common_StringUtil';
const ANONYMIZATION_MIN_LENGTH: number = 3;
const ANONYMIZATION_MAX_LENGTH: number = 8;
const ANONYMIZATION_LEFT_LENGTH: number = 2;

export class StringUtil {
  public static formatString(str: string, ...val: string[]): string {
    if (str == null) {
      Log.error(TAG, 'formatString input is null!');
      return '';
    }
    let result = str;
    for (let index = 0; index < val.length; index++) {
      while (result.indexOf(`{${index}}`) !== -1) {
        result = result.replace(`{${index}}`, val[index]);
      }
    }
    return result;
  }

  public static formatPercentForNumber(value: number, style?: string, unit?: string): string {
    let currentLocale = new Intl.Locale();
    let locale = i18n.System.getSystemLocale();
    let numfmt = new Intl.NumberFormat();
    let options = numfmt.resolvedOptions();
    options.locale = locale;
    options.numberingSystem = currentLocale.numberingSystem;
    options.localeMatcher = 'best fit';
    options.style = style;
    if (unit) {
      options.unit = unit;
    }
    let params = [i18n.System.getSystemLanguage(), locale];
    let numberFormat = new Intl.NumberFormat(params, options);
    return numberFormat.format(value).replace(' ', '');
  }

  public static formatStringForNumber(str: string, ...val: string[]): string {
    if (str == null) {
      Log.error(TAG, 'formatStringForNumber input is null!');
      return '';
    }
    let result = str;
    for (let index = 0; index < val.length; index++) {
      while (result.indexOf('%d') !== -1) {
        result = result.replace('%d', val[index] as string);
      }
    }
    return result;
  }

  public static connectString(strList: string[], connector: string): string {
    if (strList == null || strList.length <= 0 || connector == null) {
      Log.error(TAG, 'connectString input is invalid!');
      return '';
    }
    let result = '';
    for (let i = 0; i < strList.length; i++) {
      if (strList[i]) {
        result = result + strList[i].trim() + connector;
      }
      Log.info(TAG, `connectString: ${i}  + ${result}`);
    }
    return result.substr(0, (result.length - connector.length));
  }

  static getIdFromUri(uri: string): number {
    let srcIndex = uri.lastIndexOf('/');
    let srcEnd = uri.length;
    let srcId = uri.substring(srcIndex + 1, srcEnd);
    let fileId = new Number(srcId);
    Log.info(TAG, `getIdByUri fileId: ${fileId}`);
    return fileId.valueOf();
  }

  /**
   * Arraybuffer序列化，String.fromCharCode.apply采用UTF-16编码，需要在Uint16Array视图下进行
   * @param buffer
   */
  static arraybufferSerialize(buffer: ArrayBuffer): string {
    Log.info(TAG, `arraybuffer serialize start, source buffer : ${buffer}`);
    let serializedBuffer: string = String.fromCharCode.apply(null, [...(new Uint16Array(buffer))]);
    Log.info(TAG, `arraybuffer serialize end, result buffer : ${serializedBuffer}`);
    return serializedBuffer;
  }

  /**
   * 基于UTF-16进行Arraybuffer反序列化，每2个字节为单位进行转换
   * @param serializedBuffer
   */
  static arraybufferDeserialize(serializedBuffer: string): ArrayBuffer {
    Log.info(TAG, `arraybuffer deserialize start, source buffer : ${serializedBuffer}`);
    let resultBuffer: ArrayBuffer = new ArrayBuffer(serializedBuffer.length * 2);
    let bufferView = new Uint16Array(resultBuffer);
    for (let i = 0, strLen = serializedBuffer.length; i < strLen; i++) {
      bufferView[i] = serializedBuffer.charCodeAt(i);
    }
    Log.info(TAG, `arraybuffer deserialize end, result buffer : ${resultBuffer}`);
    return resultBuffer;
  }

  static checkNameInvalid(inputName: string): boolean {
    let NAME_PATTERN: RegExp = /[\\.\\\\/:*?"'`<>|\[\]{}]/;
    return NAME_PATTERN.test(inputName);
  }

  static isEmpty(text?: string): boolean {
    return text === undefined || text === null || text.length === 0;
  }

  public static isInvalid(text?: string): boolean {
    return this.isEmpty(text) || text.trim().length === 0;
  }

  static size(text: string): number {
    return this.isEmpty(text) ? 0 : text.length;
  }

  /**
   * 针对不带后缀的视频图片名称进行脱敏
   * @param fileName：不带后缀的视频或图片名称
   * @returns 脱敏后的fileName
   */
  static garbleFileName(fileName: string): string {
    let garbleName: string = fileName;
    if (fileName === undefined || fileName === null || fileName.length === 0) {
      return garbleName;
    }
    if (fileName.startsWith('screenshot_') || fileName.startsWith('IMG_') ||
    fileName.startsWith('VID_') || fileName.startsWith('SVID_')) {
      // 此时认为文件名为系统命名，不做处理
      return garbleName;
    }

    let length: number = fileName.length;

    // 对于长度小于3的文件名，保留文件名的最后一位
    if (length <= 3) {
      garbleName = '****' + fileName.substring(length - 1) + '****';
    } else if (length > 8) {
      // 对于长度大于8的文件名，从第8位开始保留
      garbleName = '**' + fileName.substring(8) + '**';
    } else {
      // 对于长度介于4-8之间的文件名，保留最后两位
      garbleName = '***' + fileName.substring(length - 2) + '***';
    }
    return garbleName;
  }

  /**
   * 字符串脱敏
   *
   * @param str
   * @returns AnonymizeString
   */
  public static getAnonymizeString(str: string): string {
    if (!str) {
      return str;
    }

    let strLength: number = str.length;
    if (strLength <= ANONYMIZATION_MIN_LENGTH) { // 对于长度小于3的字串，保留最后一位
      return '****' + str.substring(strLength - 1) + '****';
    } else if (strLength <= ANONYMIZATION_MAX_LENGTH) { // 对于长度介于4-8之间的字串，保留最后两位
      return '***' + str.substring(strLength - ANONYMIZATION_LEFT_LENGTH) + '***';
    } else { // 对于长度大于8的文件名，从第8位开始保留
      return '**' + str.substring(ANONYMIZATION_MAX_LENGTH) + '**';
    }
  }

  public static encrypt(data: string): string {
    return data.replace(/(\/\w+)\./g, '/******.');
  }
}