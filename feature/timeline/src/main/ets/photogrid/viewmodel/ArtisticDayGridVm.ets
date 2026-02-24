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

import lazy { DayGridVm } from './DayGridVm';
import lazy { IrregularType } from '../statemanager/constants/GridDefine';


/**
 * 日宫格视图模型
 */
export class ArtisticDayGridVm extends DayGridVm {
  protected override readonly supportIrregularTypes: IrregularType[] =
    [IrregularType.PORTRAIT_SWIPER];

  public updatePortraitHeight(newHeight: number) {
    this.gridStateManager.updateIrregularTypeHeight(IrregularType.PORTRAIT_SWIPER, newHeight, this.tag);
  }
}