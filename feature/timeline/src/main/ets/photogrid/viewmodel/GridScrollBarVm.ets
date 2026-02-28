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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { AbstractFormVm } from './AbstractFormVm';

/**
 * 宫格滚动视图模型
 */
export class GridScrollBarVm extends AbstractFormVm {
  public constructor(gridForm: FormIndex) {
    super(gridForm, 'GridScrollerVm');
  }

  /**
   * 更新宫格滚动状态
   *
   * @param isScrolling 是否滚动中
   */
  public updateScrollerBarTouchState(isScrollerBarTouch: boolean): void {
    this.scrollerStateManager.getScrollerTouchAsm(this.gridForm).updateState(isScrollerBarTouch, this.tag);
  }

  public onGetTimelineScrollerOpacity(scrollerOpacity: number): void {
    this.scrollerStateManager.getCapsuleVisibleAsm(this.gridForm).updateState(scrollerOpacity === Constants.OPAQUE,
      'GetTimelineScrollerOpacityChange');
    return;
  }

  /**
   * 是否支持时间胶囊
   *
   * @returns 是否支持时间胶囊
   */
  public getDateCapsuleEnable(): boolean {
    return false;
  }
}