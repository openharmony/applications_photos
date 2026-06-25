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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { SwitchType } from '../statemanager/common/SwitchStartInfo';
import lazy { FormIndex, FORM_SIZE } from '../statemanager/constants/GridDefine';
import lazy { PinchAction } from '../statemanager/constants/PinchDefine';
import lazy { FormEventType, FormEventTypeUtils } from '../statemanager/GridFormFsm';
import lazy { PinchStateUpdateParams } from '../statemanager/PinchStateManager';
import lazy { AnimationScale } from '../viewcontroller/animation/AnimationDefine';
import lazy { AbstractVm } from './AbstractVm';
import lazy { OptionType, ReportUtils } from './utils/ReportUtils';
import lazy { SwitchStartUtils } from './utils/SwitchStartUtils';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';

/**
 * 捏合参数
 */
export class PinchParams extends PinchStateUpdateParams {
  /**
   * 是否快捏
   */
  public isQuickPinch?: boolean;
}

/**
 * 宫格捏合视图模型
 */
export class GridPinchVm extends AbstractVm {
  private isShowCard: boolean = false;
  private cameraAuthCardShow: boolean = false;
  private cloudDriveStatus: boolean = true;

  constructor() {
    super('GRID_SWITCH_GridPinchVm');
  }

  protected override doInit(param: number): void {
    super.doInit(param);
    this.gridObserverProxy.getShowCloudCardState((_oldState, newState) => {
      LogUtils.info(this.tag, `getShowCloudCardState:${newState}`);
      this.isShowCard = newState;
    });
    // 更新相机地理权限提醒卡片显示状态
    this.gridObserverProxy.getCameraCardShowState((_oldState, isCameraCardShow) => {
      LogUtils.info(this.tag, `getCameraCardShowState:${this.cameraAuthCardShow} ${isCameraCardShow}`);
      this.cameraAuthCardShow = isCameraCardShow;
    });

    this.gridObserverProxy.getCloudSwitchStatue((_oldState, newState) => {
      LogUtils.info(this.tag, `getCloudSwitchStatue:${newState}`);
      this.cloudDriveStatus = newState;
    });
  }

  private submitPinchEvent(pinchParams: PinchParams): void {
    let eventType: FormEventType = FormEventType.NONE;
    switch (pinchParams.pinchAction) {
      case PinchAction.START:
        eventType = FormEventType.PINCH_START;
        // 非PC捏合开始时隐藏云同步卡片
        if (this.gridObserverProxy.config.isCloudCardSupported && this.isShowCard) {
          this.proxy.gridStateManager.updateCloudCardOpacityAsm.updateState(0, 'Hide Before Switching Starts');
        }
        if (this.gridObserverProxy.config.isShowCameraCard && this.cameraAuthCardShow) {
          this.proxy.gridStateManager.updateCameraCardOpacityAsm.updateState(0, 'Hide Before Switching Starts');
        }
        LogUtils.info(this.tag, 'submitPinchEvent START: PINCH_START.');
        break;
      case PinchAction.UPDATE:
        if (pinchParams.targetForm === undefined || pinchParams.targetForm === this.currentForm) {
          break;
        }
        eventType = FormEventTypeUtils.getPinchEventTypeFromForm(pinchParams.targetForm, true,
          pinchParams.isQuickPinch);
        LogUtils.info(this.tag, `updateState UPDATE: ${eventType}`);
        break;
      case PinchAction.END:
        eventType = FormEventTypeUtils.getPinchEventTypeFromForm(pinchParams.targetForm ?? this.currentForm, false,
          pinchParams.isQuickPinch);
        this.updateCameraCardOpacity();
        LogUtils.info(this.tag, `updateState END: ${eventType}`);
        break;
      default:
        break;
    }
    if (eventType !== FormEventType.NONE) {
      // 记录切换前形态
      let preview: FormIndex = this.currentForm;

      this.stateProxy.formFsm.submitEvent(eventType);

      // 打点
      ReportUtils.reportFormChange(preview, this.currentForm, OptionType.PINCH);
    }
  }

  protected updateCameraCardOpacity(): void {
    LogUtils.info(this.tag, `updateCameraCardOpacity cameraAuthCardShow:${this.cameraAuthCardShow} ` +
      `isShowCameraCard:${this.gridObserverProxy.config.isShowCameraCard}`);
    if (this.gridObserverProxy.config.isShowCameraCard && this.cameraAuthCardShow &&
      (this.currentForm === FormIndex.DAY || this.currentForm === FormIndex.GROUP_DAY)) {
      this.proxy.gridStateManager.updateCameraCardOpacityAsm.updateState(1, 'updateCameraCardOpacity');
    }
  }

  /**
   * 更新捏合标准系数
   *
   * @param startForm 捏合开始形态
   */
  public updatePinchStandardScales(startForm: FormIndex): void {
    const standardScales: number[] = new Array(FORM_SIZE).fill(AnimationScale.DEFAULT);
    const gridColumns: number[] = this.gridStateManager.allColumnAsm.currentState;
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      standardScales[formIndex] = this.gridStateManager.getGridColumn(startForm) / gridColumns[formIndex];
    }
    this.pinchStateManager.updateStandardScales(standardScales, 'updatePinchStandardScales');
  }
}