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
import { HiLog } from '../../common/util/HiLog';
import { BaseEditor } from '../BaseEditor';

const TAG = 'CommonModel';

export class Message {
  public importResult: number = 0;
  public exportResult: number = 0;
  public exportProgress: number = 0;
  public duration: number = 0;
  public _cmd: string = '';
}

export class Cmd {
  private editor: BaseEditor;

  constructor(editor: BaseEditor) {
    this.editor = editor;
  }

  getFunction(key: string, message: Message): void {
    switch (key) {
      case 'exportProgress':
        this.exportProgress(message);
        break;
      case 'exportResult':
        this.exportResult(message);
        break;
      case 'importResult':
        this.importResult(message);
        break;
      default:
        HiLog.e(TAG, `callback no handler, content=${key}`);
    }
  }

  exportProgress(message: Message) {
    this.editor.exportProgressCallback?.(message.exportProgress);
  }

  /**
   * 导出结果
   *
   * @param message 0 成功 其他失败
   */
  exportResult(message: Message) {
    HiLog.i(TAG, `SDK notify export_result =${message.exportResult}`);
    this.editor.exportResultCallback?.(message.exportResult);
  }

  /**
   * 导入成功/失败回调
   *
   * @param message 0 成功,其他失败
   */
  importResult(message: Message) {
    const importResult: number = message.importResult;
    HiLog.i(TAG, `SDK notify import_result =${importResult}`);
    this.editor.importResult(importResult);
  }
}