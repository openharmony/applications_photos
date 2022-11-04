/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import HiLog from "@ohos.hilog";

const PHOTOS = '[PhotoApp]'

/**
 * @deprecated
 */
export class Logger {
    prefix: string;
    static readonly DOMAIN = 0x0230
    static readonly TAG: string = '[PhotoApp]'
    static readonly DEBUG = HiLog.LogLevel.DEBUG;
    static readonly INFO = HiLog.LogLevel.INFO;
    static readonly WARN = HiLog.LogLevel.WARN;
    static readonly ERROR = HiLog.LogLevel.ERROR;
    static readonly FATAL = HiLog.LogLevel.FATAL;
    static logLevel = Logger.DEBUG;

    constructor(module: string) {
        this.prefix = `[${module}] : `;
    }

    debug(message: string, ...args: any[]): void {
        this.logImpl(Logger.DEBUG, message, args);
    }

    info(message: string, ...args: any[]): void {
        this.logImpl(Logger.INFO, message, args);
    }

    warn(message: string, ...args: any[]): void {
        this.logImpl(Logger.WARN, message, args);
    }

    error(message: string, ...args: any[]): void {
        this.logImpl(Logger.ERROR, message, args);
    }

    fatal(message: string, ...args: any[]): void {
        this.logImpl(Logger.FATAL, message, args);
    }

    private logImpl(level, message: string, ...args: any[]) {
        if (level < Logger.logLevel) {
            return;
        }

        switch (level) {
            case Logger.DEBUG:
                HiLog.warn(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
            case Logger.INFO:
                HiLog.info(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
            case Logger.WARN:
                HiLog.warn(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
            case Logger.ERROR:
                HiLog.error(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
            case Logger.FATAL:
                HiLog.fatal(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
            default:
                HiLog.info(Logger.DOMAIN, Logger.TAG, this.prefix + message);
                break;
        }
    }
}
