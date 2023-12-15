/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Constants } from '../model/common/Constants';

import { Log } from './Log';

const TAG: string = 'common_StringUtil';

export class StringUtil {
  public static formatString(str: string, ...val: any[]): string {
    if (str == null) {
      Log.error(TAG, 'formatString input is null!')
      return '';
    }
    let result = str;
    for (let index = 0; index < val.length; index++) {
      while (result.indexOf(`{${index}}`) != -1) {
        result = result.replace(`{${index}}`, val[index]);
      }
    }
    return result;
  }

  public static formatStringForNumber(str: string, ...val: any[]): string {
    if (str == null) {
      Log.error(TAG, 'formatStringForNumber input is null!');
      return '';
    }
    let result = str;
    for (let index = 0; index < val.length; index++) {
      while (result.indexOf('%d') != -1) {
        result = result.replace('%d', val[index]);
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
      if (strList[i] != '') {
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
    let serializedBuffer: string = String.fromCharCode.apply(null, new Uint16Array(buffer));
    return serializedBuffer;
  }

  /**
   * 基于UTF-16进行Arraybuffer反序列化，每2个字节为单位进行转换
   * @param serializedBuffer
   */
  static arraybufferDeserialize(serializedBuffer: string): ArrayBuffer {
    let resultBuffer: ArrayBuffer = new ArrayBuffer(serializedBuffer.length * Constants.NUMBER_2);
    let bufferView = new Uint16Array(resultBuffer);
    for (let i = 0, strLen = serializedBuffer.length; i < strLen; i++) {
      bufferView[i] = serializedBuffer.charCodeAt(i);
    }
    return resultBuffer;
  }

  static checkNameInvalid(inputName: string): boolean {
    return Constants.NAME_PATTERN.test(inputName);
  }

  static isEmpty(value: string): boolean {
    return value === undefined || value === '' || value === null;
  }
}