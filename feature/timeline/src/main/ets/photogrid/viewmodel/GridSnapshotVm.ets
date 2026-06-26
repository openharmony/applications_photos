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

import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { RestoreFpEventType, RestoreFpFsm, RestoreFpStateType } from '../statemanager/GridRestoreFpFsm';
import lazy { AbstractFormVm } from './AbstractFormVm';

/**
 * 宫格截图视图模型
 */
export class GridSnapshotVm extends AbstractFormVm {
  public constructor(gridForm: FormIndex) {
    super(gridForm, `${FormIndex[gridForm]}GridSnapshotVm`);
  }

  /**
   * 通知动效准备完成，通知的不准确，采用异步通知方式，慢一点
   */
  public async notifyAnimationPrepareComplete(): Promise<void> {
    this.restoreFsm.submitEvent(RestoreFpEventType.ANIMATION_PREPARE_COMPLETE);
  }

  /**
   * 通知动效执行完成
   */
  public notifyAnimationComplete(): void {
    this.restoreFsm.submitEvent(RestoreFpEventType.ANIMATION_COMPLETE);
  }

  protected override doInit(param: number): void {
    super.doInit(param);
    this.registerObservers();
  }

  private registerObservers(): void {
    if (!this.gridObserverProxy.getIsSupportFp(this.gridForm)) {
      return;
    }

    // 初始化状态机
    this.gridObserverProxy.getFillPostion(this.gridForm, (_oldState, fillPostion) => {
      if (fillPostion > 0) {
        this.restoreFsm.submitEvent(RestoreFpEventType.FILL_POSTION);
        return;
      }
      if (this.restoreFsm.currentState === RestoreFpStateType.INIT_STATE) {
        this.restoreFsm.submitEvent(RestoreFpEventType.CANCEL_FILL_POSTION);
        return;
      }
      if (this.isCanDoRestoreAnimation()) {
        this.restoreFsm.submitEvent(RestoreFpEventType.START_ANIMATION);
      } else {
        this.restoreFsm.submitEvent(RestoreFpEventType.CANCEL_FILL_POSTION);
      }
    });

    this.getFormState(() => this.checkCancelRestoreAnimation());
    this.gridObserverProxy.getIsImmersive(() => this.checkCancelRestoreAnimation());
    this.gridObserverProxy.getIsSwitching(() => this.checkCancelRestoreAnimation());
  }

  private isCanDoRestoreAnimation(): boolean {
    return this.isInCurrentForm() && !this.gridObserverProxy.getIsImmersive() &&
      !this.gridObserverProxy.getIsSwitching();
  }

  private checkCancelRestoreAnimation(): void {
    if (!this.isCanDoRestoreAnimation()) {
      this.restoreFsm.submitEvent(RestoreFpEventType.CANCEL_ANIMATION);
    }
  }

  private get restoreFsm(): RestoreFpFsm {
    return this.gridStateManager.getRestoreFpFsm(this.gridForm);
  }
}