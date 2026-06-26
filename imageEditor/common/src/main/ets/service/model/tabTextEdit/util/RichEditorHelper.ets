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
import pasteboard from '@ohos.pasteboard';
import { BusinessError } from '@kit.BasicServicesKit';
import { HiLog } from '../../../../common/util/HiLog';
import { StringBuilder } from './StringBuider';

/* instrument ignore file */
const TAG = 'RichEditorHelper';

/**
 * 文本框业务辅助类
 *
 * @since 2025-01-08
 */
export class RichEditorHelper {
  /**
   * 从系统剪切板读取文本框要粘贴的内容。
   *
   * @returns 要粘贴的内容
   */
  public static async getNewContentFromSystemPaste(): Promise<string> {
    try {
      const pasteData = pasteboard.getSystemPasteboard()?.getDataSync();
      if (!pasteData) {
        HiLog.w(TAG, 'getNewContentFromSystemPaste pasteData is invalid');
        return '';
      }
      const pasteDataCount = pasteData.getRecordCount();
      HiLog.i(TAG, `getNewContentFromSystemPaste paste data count: ${pasteDataCount}`);
      const newContentBuilder = new StringBuilder();
      for (let i = 0; i < pasteDataCount; i++) {
        const pasteRecord: pasteboard.PasteDataRecord = pasteData.getRecord(i);
        if (!pasteRecord) {
          HiLog.w(TAG, `getNewContentFromSystemPaste invalid record. index: ${i}`);
          continue;
        }
        const mimeType = pasteRecord.mimeType;
        if (mimeType === pasteboard.MIMETYPE_TEXT_HTML || mimeType === pasteboard.MIMETYPE_TEXT_PLAIN) {
          newContentBuilder.append(pasteRecord.plainText ?? '');
        } else {
          HiLog.w(TAG, `getNewContentFromSystemPaste unsupoort mime type: ${mimeType}. index: ${i}`);
        }
      }
      return newContentBuilder.toString();
    } catch (error) {
      const businessError = error as BusinessError;
      HiLog.e(TAG, `getNewContentFromSystemPaste error: ${businessError?.code}`);
      return '';
    }
  }
}