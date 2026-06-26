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

import lazy { AbstractScrollerBarVm } from '../viewmodel/AbstractScrollerBarVm';
import lazy { AbstractFormVc } from './AbstractFormVc';
import lazy { BaseAttributeUpdater } from './AbstractVc';
import lazy { ViewId } from './constants/ViewDefine';

/**
 * 滚动条属性更新器
 */
export class ScrollerBarAttributeUpdater extends BaseAttributeUpdater {
  protected override initInstance(instance: CommonAttribute): void {
    super.initInstance(instance);
    instance
      .clip(true)
      .draggable(false)
      .alignRules({
        top: { anchor: ViewId.TITLE_BAR, align: VerticalAlign.Bottom },
        bottom: { anchor: ViewId.BOTTOM_AVOID_GUIDELINE, align: VerticalAlign.Top },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
  }
}

/**
 * 抽象宫格滚动条视图控制器
 */
@Observed
export abstract class AbstractScrollerBarVc<V extends AbstractScrollerBarVm, U extends ScrollerBarAttributeUpdater>
  extends AbstractFormVc<V, U> {
  /**
   * 注册显隐监听，有特殊情况时可定制修改
   */
  protected override initShowState(): void {
    // 滚动条的显影直接绑定到形态状态机，避免同时出现两个滚动条
    this.getFormState(() => this.updateShow('GridFormChange'));
    this.gridObserverProxy.getIsSwitching(() => this.updateShow('IsSwitchingChange'));
    this.viewModel?.getIsShowScrollBar(() => this.updateShow('IsShowScrollBarChange'));
  }

  private updateShow(reason?: string): void {
    this.updateShowState(this.isInCurrentForm() && !this.gridObserverProxy.getIsSwitching()
      && (this.viewModel?.getIsShowScrollBar() ?? false), reason);
  }
}