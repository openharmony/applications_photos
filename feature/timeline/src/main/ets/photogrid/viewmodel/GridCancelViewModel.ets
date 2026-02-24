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
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { ActionViewModel } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { GridOperateFsm, OperateEventType, OperateStateType } from '../statemanager/GridOperateFsm';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { Action } from '@ohos/common/src/main/ets/default/view//browserOperation/Action';

const TAG: string = 'GridCancelViewModel';

export class GridCancelViewModel implements ActionViewModel {
  private readonly instanceId: number = 0;
  private readonly selectManager: SelectManager;

  public constructor(instanceId: number) {
    this.instanceId = instanceId;
    this.selectManager = GridStateProxy.getInstance(instanceId).selectManager;
  }

  public doAction(menuContext?: MenuContext | undefined): void {
    let operateFsm: GridOperateFsm = GridStateProxy.getInstance(this.instanceId).operateFsm;
    Log.info(TAG, `doAction ${operateFsm.currentState}`);
    if (operateFsm.currentState === OperateStateType.SELECT_STATE) {
      // 退出选择模式
      this.selectManager.deSelectAll();
      this.selectManager.onModeChange(false);
      operateFsm.submitEvent(OperateEventType.ENTER_BROWSER);
      Log.info(TAG, `doAction quit select mode`);
      if (AccessibilityUtil.isOpenTouchGuideSync()) {
        AccessibilityUtil.sendFocusAccessibilityEvent(`ActionButton_${Action.BACK.componentKey}`)
      }
      return;
    }
  }

  public release(): void {
  }
}