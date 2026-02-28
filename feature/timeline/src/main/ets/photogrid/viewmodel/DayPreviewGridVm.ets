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

import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { TimelineTool } from '../../model/static/TimelineTool';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { AbstractPreviewGridVm } from './AbstractPreviewGridVm';
import lazy { OperateStateType, OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';

/**
 * 日预览宫格视图模型
 */
export class DayPreviewGridVm extends AbstractPreviewGridVm {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private isShowPreview: boolean = false;

  public constructor(broadCast: BroadCast) {
    super(broadCast, FormIndex.DAY, 'DayPreviewGridVm');
  }

  public override get dayDataSource(): AlbumDataSource {
    return super.dayDataSource;
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.gridObserverProxy.getShowPreview((_oldState, newState) => {
      this.isShowPreview = newState;
    });
    this.getOperateState((_oldState: OperateStateType, newState: OperateStateType) => {
      LogUtils.info(this.tag, `update mainTitleContent isShowPreview:${this.isShowPreview}`);
      // 大图返回宫格并且预加载视图还在显示时才执行更新日期标题，否则不更新日期标题，防止更新日期错位
      if (OperateStateTypeUtils.isInGridBrowseState(newState) && this.isShowPreview) {
        this.stateProxy.titleBarStateManager.mainTitleContentAsm.updateState(
          TimelineTool.formatTimeStampToLocalizedDate(
            this.dayDataSource.getMediaItemSafely(0).dateTaken, this.rsc), 'GridBrowseState');
        return;
      }
      if (OperateStateTypeUtils.isInNotDataState(newState)) {
        this.stateProxy.titleBarStateManager.mainTitleContentAsm.updateState(
          this.albumStateManager.config.albumInfo?.albumName ?? $r('app.string.tab_timeline'), 'InNotDataState');
      }
    });
  }
}