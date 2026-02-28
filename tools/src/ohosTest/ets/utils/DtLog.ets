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

import HiLog from '@ohos.hilog';
import { Loggable } from '../../../main/utils/Log';


interface logger {
  d: (msg: string) => void,
  i: (msg: string) => void,
  w: (msg: string) => void,
  e: (msg: string) => void,
}

/* instrument ignore file */
const DOMAIN: number = 0x2025;

export abstract class DtLog {
  constructor(tag: string, prefix: string) {
    this.tag = prefix + tag;
  }

  public tag: string;
  /**
   * 重要注释推荐写入msg, 打印出来
   */
  public log: logger = {
    d: (msg: string, ...args: Loggable[]): void => {
      HiLog.debug(DOMAIN, this.tag, msg, args);
    },
    i: (msg: string, ...args: Loggable[]): void => {
      HiLog.info(DOMAIN, this.tag, msg, args);
    },
    w: (msg: string, ...args: Loggable[]): void => {
      HiLog.warn(DOMAIN, this.tag, msg, args);
    },
    e: (msg: string, ...args: Loggable[]): void => {
      HiLog.error(DOMAIN, this.tag, msg, args);
    },
  }
}
