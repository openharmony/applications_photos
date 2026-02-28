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

import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { convertToMViewType } from '../../model/Constants';
import lazy { AbstractFormVm } from './AbstractFormVm';

/**
 * 抽象滚动条视图模型
 */
export class AbstractScrollerBarVm extends AbstractFormVm {
  public isShowScrollBarAsm: AttributeStateManager<boolean> = new AttributeStateManager(0, false, 'IsShowScrollBar');

  /**
   * 获取当前能否显示scrollbar
   *
   * @param callback 变化回调
   * @returns 能否显示scrollbar
   */
  public getIsShowScrollBar(callback?: StateChangeCallback<boolean>): boolean {
    if (!this.isShowScrollBarAsm) {
      return false;
    }
    return this.getState<boolean>(this.isShowScrollBarAsm, callback);
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm, (_oldState, _newState) => {
      if (this.isInCurrentForm()) {
        this.stateProxy.timeController?.startCapsuleAndSingleTitleVisibilityAnimation(_newState,
          this.gridObserverProxy.getIsImmersive(), convertToMViewType(this.gridForm));
      }
    });

    this.registerDataSourceListener({
      onDataUpdate: (count: number): void =>
      this.isShowScrollBarAsm?.updateState(count >= this.gridObserverProxy.config.scrollbarEnableCounts),
    })
    this.isShowScrollBarAsm.updateState(this.totalCount() >= this.gridObserverProxy.config.scrollbarEnableCounts);
  }
}