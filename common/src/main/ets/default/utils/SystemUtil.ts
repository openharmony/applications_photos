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

import i18n from '@ohos.i18n';
import { Log } from './Log';

const TAG: string = 'common_SystemUtil';

export class SystemUtil {
  public static getSystemLanguage(): string {
    let systemLocale = i18n.getSystemLanguage();
    let localInfo = systemLocale.split('-')[0];
    return localInfo;
  }

  public static is24HourClock(): boolean {
    return i18n.is24HourClock();
  }
}