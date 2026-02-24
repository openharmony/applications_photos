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

import lazy HiLog from '@ohos.hilog';
import lazy { fitWidth } from './Log';

/* instrument ignore file */
const DOMAIN: number = 0x0220;

export abstract class LogExtender {
  protected extendTag: string = '_Empty';

  protected debug(tag: string, message: string, ...args: string[]): void {
    HiLog.debug(DOMAIN, fitWidth(tag + this.extendTag), message, args);
  }

  protected info(tag: string, message: string, ...args: string[]): void {
    HiLog.info(DOMAIN, fitWidth(tag + this.extendTag), message, args);
  }

  protected warn(tag: string, message: string, ...args: string[]): void {
    HiLog.warn(DOMAIN, fitWidth(tag + this.extendTag), message, args);
  }

  protected error(tag: string, message: string, ...args: string[]): void {
    HiLog.error(DOMAIN, fitWidth(tag + this.extendTag), message, args);
  }

  protected fatal(tag: string, message: string, ...args: string[]): void {
    HiLog.fatal(DOMAIN, fitWidth(tag + this.extendTag), message, args);
  }
}
