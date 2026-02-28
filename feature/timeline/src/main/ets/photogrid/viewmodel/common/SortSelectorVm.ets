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

import lazy { SortRuleString } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { IrregularType } from '../../statemanager/constants/GridDefine';
import lazy { AbstractVm } from '../AbstractVm';

/**
 * 顶部排序选择器视图模型
 */
export class SortSelectorVm extends AbstractVm {
  public constructor() {
    super('SortSelectorVm');
  }

  public onSelectSortRuleChange(selected: string, sortType: string) {
    LogUtils.info(this.tag, `onSelectSortRuleChange ${selected}-${sortType}`);
    this.gridStateManager.updateGirdSort(new SortRuleString(selected, sortType));
  }

  /**
   * 按照类型更新不规则高度区域高度
   *
   * @param newHeight 新高度
   */
  public updateSortSelectorHeight(newHeight: number) {
    this.gridStateManager.updateIrregularTypeHeight(IrregularType.SORT_SELECTOR, newHeight, this.tag);
  }

  protected override doInit(param: number): void {
    super.doInit(param);
  }
}