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
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ActionViewModel } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { GridOperateFsm, OperateEventType } from '../statemanager/GridOperateFsm';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';

const TAG: string = 'GridMultiSelectViewModel';

export class GridMultiSelectViewModel implements ActionViewModel {
  private readonly instanceId: number = 0;
  private readonly selectManager: SelectManager;

  public constructor(instanceId: number) {
    this.instanceId = instanceId;
    this.selectManager = GridStateProxy.getInstance(instanceId).selectManager;
  }

  public doAction(menuContext?: MenuContext | undefined): void {
    let operateFsm: GridOperateFsm = GridStateProxy.getInstance(this.instanceId).operateFsm;
    Log.info(TAG, `doAction select: ${this.selectManager.isSelectedMode()}`);
    if (!this.selectManager.isSelectedMode()) {
      this.selectManager.deSelectAll();
      // 进入选择模式
      this.selectManager.onModeChange(true);
      operateFsm.submitEvent(OperateEventType.ENTER_SELECT);
      Log.info(TAG, `doAction enter select mode`);
      const msg: Record<string, number | string | boolean> = {
        'IS_ENTER': 'true',
        'IS_QUIT': 'false',
        'from': 'CLICK_BUTTON_PAGE',
        'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),
      };
      ReportToBigDataUtil.report(BigDataConstants.MULTI_SELECT_MODE, msg);
      return;
    }

    // 选择模式下，如果全部选中，则取消全选
    if (this.selectManager.getSelectedCount() === this.selectManager.totalCount) {
      Log.info(TAG, `doAction deSelectAll`);
      this.selectManager.deSelectAll();
    } else {
      Log.info(TAG, `doAction selectAll`);
      GridStateProxy.getInstance(this.instanceId).displayStateManager.updateGridFocused(true);
      this.selectManager.selectAll(true);
    }
  }

  public release(): void {
  }
}