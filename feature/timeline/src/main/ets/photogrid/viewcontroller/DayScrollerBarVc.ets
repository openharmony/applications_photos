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

import lazy { FormIndex, ShowMode } from '../statemanager/constants/GridDefine';
import lazy { DayScrollerBarVm } from '../viewmodel/DayScrollerBarVm';
import lazy { AbstractScrollerBarVc, ScrollerBarAttributeUpdater } from './AbstractScrollerBarVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';

/**
 * 日滚动条视图控制器
 */
@Observed
export class DayScrollerBarVc extends AbstractScrollerBarVc<DayScrollerBarVm, ScrollerBarAttributeUpdater> {
  public dayItemHeight: number = 0;

  public constructor() {
    super(FormIndex.DAY, new ScrollerBarAttributeUpdater(ViewId.DAY_SCROLLER, ViewZIndex.DAY_SCROLLER),
      'DayScrollerBarVc', ShowMode.VISIBLE);
  }

  protected override initStates(): void {
    super.initStates();
    this.gridObserverProxy.getGridImageHeight(FormIndex.DAY, (_oldState, newState) => {
      this.dayItemHeight = newState;
    });
  }
}