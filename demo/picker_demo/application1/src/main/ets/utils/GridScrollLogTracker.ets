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

import lazy { Log } from '../utils/Log';

/**
 * 宫格滑动过程日志维测
 */
export class GridScrollLogTracker {
  /**
   * 打印info日志信息
   *
   * @param tag 日志tag
   * @param msg 日志信息
   */
  public info(tag: string, msg: string): void {
    Log.info(tag, msg);
  }

  /**
   * 打印warn日志信息
   *
   * @param tag 日志tag
   * @param msg 日志信息
   */
  public warn(tag: string, msg: string): void {
    Log.warn(tag, msg);
  }

  /**
   * 打印error日志信息
   *
   * @param tag 日志tag
   * @param msg 日志信息
   */
  public error(tag: string, msg: string): void {
    Log.error(tag, msg);
  }
}