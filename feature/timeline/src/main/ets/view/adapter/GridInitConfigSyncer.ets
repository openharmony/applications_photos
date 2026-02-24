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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DaySubType } from '@ohos/common/src/main/ets/default/model/common/DaySubType';
import lazy { ValueType } from '@ohos.data.ValuesBucket';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

const TAG: string = 'GridControllerAdapter';

/**
 * 宫格初始配置同步器
 */
export class GridInitConfigSyncer {
  // 最后日宫格形态是否为日分组
  private _isLastFormIsDayGroup: boolean = false;
  // 是否已经显示了日分组导航
  private _groupDayGuideHasDisplayed: boolean = true;

  /**
   * 最后日宫格形态是否为日分组
   *
   * @returns 最后日宫格形态是否为日分组
   */
  public get isLastFormIsDayGroup(): boolean {
    return this._isLastFormIsDayGroup;
  }

  /**
   * 是否已经显示了日分组导航
   *
   * @returns 是否已经显示了日分组导航
   */
  public get groupDayGuideHasDisplayed(): boolean {
    return this._groupDayGuideHasDisplayed;
  }

  /**
   * 初始化宫格参数
   *
   * @param initViewMode 指定宫格形态；
   * @returns
   */
  public async initGridConfig(initViewMode?: DaySubType): Promise<void> {
    try {
      Log.info(TAG, `initGridConfig begin`);
      // 记录是否已经显示提醒
      let keyDisplayed: string = Constants.DAY_GROUP_GUIDE_HAS_DISPLAY;
      // 如果guideHasDisplayed配置为true表示之前已经显示过气泡，可以确认为老用户升级场景，此时保持默认加载配置，否则默认加载三宫格
      this._groupDayGuideHasDisplayed = await DataStoreUtil.getInstance().getData<boolean>(keyDisplayed, false);
      // 第一次启动图库时默认加载三宫格，非第一次启动时按照存储的退出类型加载
      let defaultView: DaySubType = DaySubType.NORMAL;
      Log.info(TAG, `initGridConfig initViewMode: ${initViewMode}`);
      if (initViewMode === undefined) {
        if (!DeviceInfo.isPc() && !this._groupDayGuideHasDisplayed) {
          defaultView = DaySubType.GROUP;
        }
        let value: ValueType =
          await DataStoreUtil.getInstance().getData(Constants.DAY_PERSISTENT_KEY, defaultView);
        let valueNumber: number = parseInt(value.toString());
        this._isLastFormIsDayGroup = Number.isFinite(valueNumber) && valueNumber !== DaySubType.NORMAL;
      } else {
        this._isLastFormIsDayGroup = initViewMode !== DaySubType.NORMAL;
      }
      Log.info(TAG,
        `initGridConfig end:${this._isLastFormIsDayGroup} ${this._groupDayGuideHasDisplayed} ${defaultView}`);
    } catch (err) {
      Log.info(TAG, `initGridConfig error: ${err}`);
    }
  }

  /**
   * 保存最后日宫格形态是否为日分组
   *
   * @param isLastFormIsDayGroup 最后日宫格形态是否为日分组
   * @returns
   */
  public async saveIsLastFormIsDayGroup(isLastFormIsDayGroup: boolean): Promise<void> {
    try {
      Log.info(TAG, `saveIsLastFormIsDayGroup: ${isLastFormIsDayGroup}`);
      DataStoreUtil.getInstance().putData(Constants.DAY_PERSISTENT_KEY,
        isLastFormIsDayGroup ? DaySubType.GROUP : DaySubType.NORMAL);
      DataStoreUtil.getInstance().flush();
    } catch (err) {
      Log.info(TAG, `saveIsLastFormIsDayGroup error: ${err}`);
    }
  }

  /**
   * 保存是否已经显示了日分组导航
   *
   * @param groupDayGuideHasDisplayed 是否已经显示了日分组导航
   * @returns
   */
  public async saveGroupDayGuideHasDisplayed(groupDayGuideHasDisplayed: boolean): Promise<void> {
    try {
      Log.info(TAG, `saveGroupDayGuideHasDisplayed: ${groupDayGuideHasDisplayed}`);
      DataStoreUtil.getInstance().putData<boolean>(Constants.DAY_GROUP_GUIDE_HAS_DISPLAY, groupDayGuideHasDisplayed)
        .then(() => DataStoreUtil.getInstance().flush());
    } catch (err) {
      Log.info(TAG, `saveGroupDayGuideHasDisplayed error: ${err}`);
    }
  }
}