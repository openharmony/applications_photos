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
import lazy { DayScrollerBarVc } from '../viewcontroller/DayScrollerBarVc';
import lazy { DayScrollerBarVm } from '../viewmodel/DayScrollerBarVm';
import lazy  { GridScrollBarView } from './common/GridScrollBarView';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { GridDragScrollBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridDragScrollBaseHelper';
import lazy { GridScrollScene, GridScrollUtil } from '@ohos/common/src/main/ets/default/utils/GridScrollUtil';
import lazy { FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { TimelineDataSourceManager } from '../../model/TimelineDataSourceManager';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';

const TAG: string = 'DayScrollerBarView';

/**
 * 日滚动条
 */
@Component
export struct DayScrollerBarView {
  public persistentId: number = 0;
  public viewModel: DayScrollerBarVm = new DayScrollerBarVm();
  @State public controller: DayScrollerBarVc = new DayScrollerBarVc();
  @Provide broadCast: BroadCast = TimelineDataSourceManager.getInstance().getBroadCast();
  @Provide dateText: string = '';
  private dayRegularGridDragScrollHelper: GridDragScrollBaseHelper | undefined =
    GridScrollUtil.createDragScrollHelper(GridScrollScene.DAY_VIEW_REGULAR_GRID_DRAG_SCROLL);
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  @State private actionBarPaddingTop: number = 0;
  private dateTextMarginTop: number = 18;
  private scrollBarPaddingTop: number = this.actionBarPaddingTop + this.dateTextMarginTop;
  // 沉浸态
  @State selectModeBottomHeight: number = 0;
  // 按下滚动条时不执行进退沉浸式
  @State actionBarHeight: number = 56;
  @State isScrollByScrollBar: boolean = false;
  @State currentScrollBarPaddingTop: number = 0;
  // 分段式按钮 所需属性
  @State segmentHeight: number = 40;
  @State segmentWidth: number = 220;
  @State messageHeight: number = 0;
  @Provide yearData: TimelineData[] = [];
  @Provide yearMonthData: TimelineData[] = [];
  // 沉浸态 所需属性
  @State isImmersive: boolean = false;
  @State dayFirstIndex: number = 0;

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    LogUtils.info(TAG, 'aboutToAppear finish');
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.controller.release();
    this.viewModel.release();
  }

  @Builder
  buildDayScrollBar() {
    GridScrollBarView({
      persistentId: this.persistentId,
      gridForm: FormIndex.DAY,
      scroller: this.viewModel.getScroller(),
      dataSource: this.viewModel.dayDataSource,
      gridDragScrollHelper: this.dayRegularGridDragScrollHelper,
      paddingTop: $currentScrollBarPaddingTop,
      scrollBarPaddingTop: this.scrollBarPaddingTop,
      segmentHeight: $segmentHeight,
      isImmersive: $isImmersive,
      isScrollByScrollBar: $isScrollByScrollBar,
      attributeUpdater: this.controller.attributeUpdater,
    })
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      // 日胶囊
      this.buildDayScrollBar();
    }
  }
}