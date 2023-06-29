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
  private static readonly NEW_NAME_EDIT_PREFIX: string = '_edit_';

  public static formats(formatStr?: string): string {
    let time = new Date();
    if (!formatStr) {
      return time.valueOf().toString();
    }
    let opts = {
      'MM': time.getMonth() + 1,
      'dd': time.getDate(),
      'HH': time.getHours(),
      'mm': time.getMinutes(),
      'ss': time.getSeconds()
    };

    if (/(y+)/.test(formatStr)) {
      formatStr = formatStr.replace('yyyy', time.getFullYear().toString().substr(0));
    }
    for (let f in opts) {
      if (new RegExp('(' + f + ')').test(formatStr)) {
        formatStr = formatStr.replace(f, (f.length == 1) ? opts[f] : (('00' + opts[f]).substr(
          opts[f].toString().length)));
      }
    }
    return formatStr;
  }

  public static nameByDate(isReplace: Boolean, name?: string): string {
    if (isReplace) {
      if (name) {
        let index: number = String(name).indexOf(DateUtil.NEW_NAME_EDIT_PREFIX);
        if (index >= 0) {
          return String(name).substring(0, index) + '_' + DateUtil.NEW_NAME_EDIT + DateUtil.formats();
        }
        return name.split('.')[0] + '_' + DateUtil.NEW_NAME_EDIT + DateUtil.formats();
      }
      return null;
    } else {
      return DateUtil.NEW_NAME_IMG + DateUtil.formats('yyyyMMdd_HHmmss');
    }
  }
}
