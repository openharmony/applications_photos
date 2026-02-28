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

import lazy fs from '@ohos.file.fs';
import lazy util from '@ohos.util';
import lazy settings from '@ohos.settings';
import lazy rdb from '@ohos.data.relationalStore';
import lazy preferences from '@ohos.data.preferences';
import lazy convertxml from '@ohos.convertxml';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'TransferUtils';
const READ_DATA_SIZE:number = 1024 * 1024;

// xml转json对象类型定义
export interface XmlAttributes {
  name?: string;
  value?: string;
}

export interface XmlElement {
  _elements?: XmlElement[];
  _name?: string;
  _type?: string;
  _text?: string;
  _attributes?: XmlAttributes
}

export class TransferUtils {
  // 获取xml文本
  public static async getXmlStr(path: string): Promise<string> {
    let xmlContent: string = '';
    try {
      let access = fs.accessSync(path);
      if (!access) {
        Log.error(TAG, `file not accessible`);
        return '';
      }

      let fileStream = await fs.createStream(path, 'r');
      let bufArray: ArrayBuffer[] = [];
      let totalLength = 0;
      let buffer = new ArrayBuffer(READ_DATA_SIZE);

      let len = await fileStream.read(buffer);
      while (len !== 0) {
        totalLength += len;
        if (len < READ_DATA_SIZE) {
          buffer = buffer.slice(0, len);
          bufArray.push(buffer);
          break;
        }
        bufArray.push(buffer);
        buffer = new ArrayBuffer(READ_DATA_SIZE);
        len = fs.readSync(Number(fileStream), buffer);
      }

      let contentBuffer = new Uint8Array(totalLength);
      let offset = 0;
      bufArray.forEach(bufferArr => {
        let uInt8Arr = new Uint8Array(bufferArr);
        contentBuffer.set(uInt8Arr, offset);
        offset += uInt8Arr.byteLength;
      });
      let textDecoder = util.TextDecoder.create('utf-8', {
        ignoreBOM: false
      })
      xmlContent = textDecoder.decodeWithStream(new Uint8Array(contentBuffer), {
        stream: false
      });
      return xmlContent;
    } catch (error) {
      Log.error(TAG, `getXmlStr failed, error code:${error?.code} msg:${error?.message}`);
    }
    return xmlContent;
  }

  // xml文本转成XmlElement对象逻辑
  public static transferSourceXmlToXmlElement(xmlContent: string): XmlElement {
    let result: XmlElement = {};
    if (xmlContent.length === 0) {
      Log.error(TAG, `xmlContent is empty`);
      return result;
    }
    try {
      let conv = new convertxml.ConvertXML();
      let options: convertxml.ConvertOptions = {
        trim: false,
        declarationKey: '_declaration', // 转换后文件声明使用_declaration来标识
        instructionKey: '_instruction', // 转换后指令使用_instruction标识
        attributesKey: '_attributes', // 转换后属性使用_attributes标识
        textKey: '_text', // 转换后标签值使用_text标识
        cdataKey: '_cdata', // 转换后未解析数据使用_cdata标识
        doctypeKey: '_doctype', // 转换后文档类型使用_doctype标识
        commentKey: '_comment', // 转换后注释使用_comment标识
        parentKey: '_parent', // 转换后父类使用_parent标识
        typeKey: '_type', // 转换后元素类型使用_type标识
        nameKey: '_name', // 转换后标签名称使用_name标识
        elementsKey: '_elements' // 转换后元素使用_elements标识
      };
      let xmlJsonStr = JSON.stringify(conv.fastConvertToJSObject(xmlContent, options));
      result = JSON.parse(xmlJsonStr) as XmlElement;
    } catch (error) {
      Log.error(TAG, `get xmlContent failed, error code:${error?.code} msg:${error?.message}`);
    }
    return result;
  }

  // 解析sp xml文件对应的XmlElement对象
  public static parseXmlElement(xmlElement: XmlElement): Map<string, preferences.ValueType> {
    let spDataMap = new Map<string, preferences.ValueType>();

    if (!xmlElement._elements || xmlElement._elements.length == 0) {
      Log.error(TAG, `invalid xmlElement`);
      return spDataMap;
    }
    let rootNode = xmlElement._elements[0];
    if (!rootNode || !rootNode._elements) {
      Log.error(TAG, `invalid xml rootNode`);
      return spDataMap;
    }

    for (let i = 0; i < rootNode._elements.length; i++) {
      let item = rootNode._elements[i];
      let key = item._attributes?.name;
      if (!key) {
        continue;
      }
      let valueType = item._name;
      switch (valueType) {
        case 'string': {
          if (item._elements && item._elements.length > 0) {
            spDataMap.set(key, item._elements[0]._text as string || '');
          }
          break;
        }
        case 'set': {
          if (item._elements) {
            let strArr: string[] = [];
            item._elements.forEach((setValue) => {
              if (setValue._elements && setValue._elements.length > 0) {
                let item = setValue._elements[0]._text as string || '';
                strArr.push(item);
              }
            })
            spDataMap.set(key, strArr);
          }
          break;
        }
        case 'int':
        case 'float':
        case 'long':
        case 'boolean': {
          if (item._attributes) {
            spDataMap.set(key, item._attributes.value as preferences.ValueType);
          }
          break;
        }
        default: {
          break;
        }
      }
    }
    return spDataMap;
  }
}