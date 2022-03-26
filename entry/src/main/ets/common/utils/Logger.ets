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

const PHOTOS = 'Photos_'

export class Logger {
    prefix: string;

    static readonly DEBUG = 0;
    static readonly LOG = 1;
    static readonly INFO = 2;
    static readonly WARN = 3;
    static readonly ERROR = 4;

    static logLevel = Logger.INFO;

    constructor(module: string) {
        this.prefix = `${module}: `;
    }

    debug(message: string, ...args: any[]): void {
        this.logImpl(Logger.DEBUG, message, args);
    }

    log(message: string, ...args: any[]): void {
        this.logImpl(Logger.LOG, message, args);
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

    private logImpl(level, message: string, ...args: any[]) {
        if (level < Logger.logLevel) {
            return;
        }

        switch (level) {
            case Logger.DEBUG:
                console.debug(PHOTOS + this.prefix + message, args);
                break;
            case Logger.INFO:
                console.info(PHOTOS + this.prefix + message, args);
                break;
            case Logger.WARN:
                console.warn(PHOTOS + this.prefix + message, args);
                break;
            case Logger.ERROR:
                console.error(PHOTOS + this.prefix + message, args);
                break;
            case Logger.LOG:
            default:
                console.log(PHOTOS + this.prefix + message, args);
                break;
        }
    }
}
