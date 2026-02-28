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
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { PreloadEventType } from '../statemanager/GridPreloadFsm';
import lazy { AbstractFormVm } from './AbstractFormVm';

/**
 * 抽象预览宫格视图模型
 */
export class AbstractPreviewGridVm extends AbstractFormVm {
  private readonly broadCast: BroadCast;
  private readonly showRawGridFun: Function = (): void => this.preloadFinish();

  public constructor(broadCast: BroadCast, gridForm: FormIndex, tag?: string) {
    super(gridForm, tag);
    this.broadCast = broadCast;
  }

  /**
   * 预加载完成
   */
  public preloadFinish(): void {
    LogUtils.info(this.tag, 'preload finish.');
    this.stateProxy.preloadFsm.submitEvent(PreloadEventType.LOAD_FINISH);
    TraceUtils.finishTrace(TraceTaskType.PREVIEW_GRID_LOAD_FINISH, this.gridForm);
  }

  /**
   * 预加载视图隐藏
   */
  public preloadViewHidden(): void {
    TraceUtils.finishTrace(TraceTaskType.PREVIEW_GRID_LIVE, this.gridForm);
  }

  protected override doInit(persistentId: number): void {
    TraceUtils.startTrace(TraceTaskType.PREVIEW_GRID_LOAD_FINISH, this.gridForm);
    TraceUtils.startTrace(TraceTaskType.PREVIEW_GRID_LIVE, this.gridForm);
    super.doInit(persistentId);
    this.broadCast.on(BroadCastConstants.SWITCH_GRID_VIEW_RAW, this.showRawGridFun);
  }

  protected override doRelease(): void {
    this.broadCast.off(BroadCastConstants.SWITCH_GRID_VIEW_RAW, this.showRawGridFun);
    super.doRelease();
  }
}