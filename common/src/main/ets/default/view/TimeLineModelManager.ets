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

import lazy systemParameter from '@ohos.systemparameter';
import lazy { Log } from '../utils/Log';
import lazy { StringUtil } from '../utils/StringUtil';

const TAG: string = 'TimeLineModelManager';

export class TimeLineModelManager {
  private isOpenYearMonth: boolean = false;

  private constructor() {
    const YEARMONTH_ENABLE: string = 'const.sys.photos.yearMonth.enable';
    const YEARMONTH_ON: string = 'on';
    let param: string = systemParameter.getSync(YEARMONTH_ENABLE, 'on'); // 获取配置项
    this.isOpenYearMonth = StringUtil.size(param) !== 0 && param === YEARMONTH_ON;
    Log.info(TAG, `current YearMonth enable: ${this.isOpenYearMonth}`);
  }

  public static getInstance(): TimeLineModelManager {
    if (!TimeLineModelManager.instance) {
      TimeLineModelManager.instance = new TimeLineModelManager();
    }
    return TimeLineModelManager.instance;
  }

  public static instance: TimeLineModelManager | undefined = undefined;

  public isOpenYearMonthTimeLine(): boolean {
    return this.isOpenYearMonth;
  }
}