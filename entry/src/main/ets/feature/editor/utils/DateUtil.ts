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

export class DateUtil {
    private static readonly NEW_NAME_IMG: string = 'IMG_';
    private static readonly NEW_NAME_EDIT: string = 'edit_';

    public static formats(format?: string): string {
        let time = new Date();
        if (!Boolean(format).valueOf()) {
            return time.valueOf().toString();
        }
        let opts: Map<string, number> = new Map();
        opts.set('MM', time.getMonth() + 1);
        opts.set('dd', time.getDate());
        opts.set('HH', time.getHours());
        opts.set('mm', time.getMinutes());
        opts.set('ss', time.getSeconds());

        if (/(y+)/.test(format)) {
            format = format.replace('yyyy', time.getFullYear().toString().substr(0));
        }
        for (let f of opts.keys()) {
            if (new RegExp('(' + f + ')').test(format)) {
                format = format.replace(f,
                    (f.length == 1)
                    ? opts.get(f).toString()
                    : (("00" + opts.get(f)).substr(opts.get(f).toString().length))
                );
            }
        }
        return format;
    }

    public static nameByDate(isReplace: Boolean, name?: string): string {
        if (isReplace) {
            return (!Boolean(name).valueOf()) ? null : (name.indexOf(DateUtil.NEW_NAME_EDIT) == -1 ? name.split('.')[0] + '_' + DateUtil.NEW_NAME_EDIT + DateUtil.formats() : name.split('.')[0]);
        } else {
            return DateUtil.NEW_NAME_IMG + DateUtil.formats('yyyyMMdd_HHmmss');
        }
    }
}
