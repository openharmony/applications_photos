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

import {Logger} from './Logger.ets'

export class StringUtil {
    static logger: Logger = new Logger('StringUtil');

    public static formatString(str: string, ...val: any[]): string {
        if (str == null) {
            this.logger.error('formatString input is null!')
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
            this.logger.error('formatStringForNumber input is null!');
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
            this.logger.error('connectString input is invalid!');
            return '';
        }
        let result = '';
        for (let i = 0; i < strList.length; i++) {
            if (strList[i] != '') {
                result = result + strList[i].trim() + connector;
            }
            this.logger.info(`connectString: ${i}  + ${result}`);
        }
        return result.substr(0, (result.length - connector.length));
    }
}