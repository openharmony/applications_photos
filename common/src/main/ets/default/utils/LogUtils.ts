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

/* instrument ignore file */

import lazy hilog from '@ohos.hilog';

const BAR_WIDTH: number = 23;

/**
 * 日志工具类
 */
export class LogUtils {
  private static domain: number = 0x0220;
  private static tag: string = 'ComponentCommon';
  private static isDebugLoggable: boolean = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.DEBUG);
  private static isInfoLoggable: boolean = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.INFO);
  private static isWarnLoggable: boolean = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.WARN);
  private static isErrorLoggable: boolean = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.ERROR);
  private static isFatalLoggable: boolean = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.FATAL);

  private constructor() {
  }

  /**
   * 设置日志域信息和标签信息
   *
   * @param domain 域信息
   * @param tag 标签信息
   */
  public static setDomainTag(domain: number, tag: string): void {
    this.domain = domain;
    this.tag = tag;
    this.isDebugLoggable = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.DEBUG);
    this.isInfoLoggable = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.INFO);
    this.isWarnLoggable = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.WARN);
    this.isErrorLoggable = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.ERROR);
    this.isFatalLoggable = hilog.isLoggable(this.domain, this.tag, hilog.LogLevel.FATAL);
  }

  /**
   * 是否支持debug级别打印
   *
   * @returns 是否支持debug级别打印
   */
  public static isDebuggable(): boolean {
    return this.isDebugLoggable;
  }

  /**
   * 打印debug级别日志
   *
   * @param className 日志标签
   * @param message 日志信息
   * @param args 可选参数
   * @returns 是否可打印
   */
  public static debug(className: string, message: string, ...args: string[]): void {
    if (this.isDebugLoggable) {
      hilog.debug(this.domain, fitWidth(className), message, args);
    }
  }

  public static info(className: string, message: string, ...args: string[]): boolean {
    if (this.isInfoLoggable) {
      hilog.info(this.domain, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static warn(className: string, message: string, ...args: string[]): boolean {
    if (this.isWarnLoggable) {
      hilog.warn(this.domain, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static error(className: string, message: string, ...args: string[]): boolean {
    if (this.isErrorLoggable) {
      hilog.error(this.domain, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static fatal(className: string, message: string, ...args: string[]): boolean {
    if (this.isFatalLoggable) {
      hilog.fatal(this.domain, fitWidth(className), message, args);
      return true;
    }
    return false;
  }
}

function fitWidth(name: string): string {
  return name.substring(name.length - BAR_WIDTH);
}