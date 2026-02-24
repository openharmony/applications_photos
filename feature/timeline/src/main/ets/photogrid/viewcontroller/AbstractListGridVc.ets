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
import lazy { MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM, PullDownState } from '../statemanager/constants/GridDefine';
import lazy { AbstractGridVm } from '../viewmodel/AbstractGridVm';
import lazy { AbstractGridAttributeUpdater, AbstractGridVc } from './AbstractGridVc';
import lazy { ViewId } from './constants/ViewDefine';

/**
 * 基于List实现的宫格属性更新器
 */
export class ListGridAttributeUpdater extends AbstractGridAttributeUpdater<ListAttribute> {
  // 子组件在主轴方向的大小信息
  private childrenMainSize?: ChildrenMainSize;

  public updateChildrenMainSize(childrenMainSize: ChildrenMainSize | undefined): void {
    this.childrenMainSize = childrenMainSize;
    this.attribute?.childrenMainSize(childrenMainSize);
  }

  protected override initInstance(instance: ListAttribute): void {
    super.initInstance(instance);
    instance
      .clip(false)
      .draggable(false)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .scrollBar(BarState.Off)
      .listDirection(Axis.Vertical)
      .alignRules({
        top: { anchor: ViewId.CONTAINER, align: VerticalAlign.Top },
        bottom: { anchor: ViewId.CONTAINER, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      })
      .childrenMainSize(this.childrenMainSize);
  }

  protected override setCachedCount(instance?: ListAttribute): void {
    instance?.cachedCount(this.cachedCount);
  }
}

/**
 * 抽象基于List实现的宫格视图控制器
 */
@Observed
export abstract class AbstractListGridVc<V extends AbstractGridVm, U extends ListGridAttributeUpdater>
  extends AbstractGridVc<V, U, ListAttribute> {
  // 子组件在主轴方向的大小信息
  private childrenMainSize?: ChildrenMainSize;

  protected override initStates(): void {
    super.initStates();

    // 更新子组件在主轴方向的大小信息
    this.gridObserverProxy.getGridImageHeight(this.gridForm, () => this.updateChildrenMainSize('ImageHeightChange'));
    this.getFormState(() => {
      if (!this.isInCurrentForm()) {
        return;
      }
      this.updateChildrenMainSize('FormStateChange');
    });
    this.registerDataSourceListener({
      onDataUpdate: () => this.updateChildrenMainSize('DataSourceChange'),
    });

    if (this.gridObserverProxy.config.isSupportHeadMsg) {
      this.gridObserverProxy.getHeadMsgPullDownState((_oldState, pullDownState) => {
        if (pullDownState === PullDownState.PARTIAL) {
          // 滑动过程中，更新HeadMsg高度会有BUG，暂时使用清除ChildrenMainSize的规避手段
          this.attributeUpdater.updateChildrenMainSize(undefined);
        } else if (!this.childrenMainSize) {
          this.updateChildrenMainSize('HeadMsgHeightChange');
        } else {
          this.childrenMainSize.update(0, this.getHeadMsgHeight());
          this.attributeUpdater.updateChildrenMainSize(this.childrenMainSize);
        }
      });
    }
  }

  /**
   * 更新子组件在主轴方向的大小信息
   */
  protected updateChildrenMainSize(reason?: string): void {
    LogUtils.info(this.tag, `updateChildrenMainSize reason: ${reason}`);
    const gridOp = this.gridObserverProxy;
    const rowHeight: number = gridOp.getGridImageHeight(this.gridForm);
    if (rowHeight <= 0) {
      return;
    }
    const defaultItemSize: number = rowHeight * MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM;
    const gridColumn = gridOp.getGridColumn(this.gridForm);
    const rowCount: number = Math.ceil(this.totalCount() / gridColumn);
    const lastRowCount: number = rowCount % MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM;
    const lastRowHeight: number = lastRowCount === 0 ? defaultItemSize : lastRowCount * rowHeight;
    const lastIndex: number = Math.ceil(rowCount / MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM);
    this.childrenMainSize = new ChildrenMainSize(defaultItemSize);
    if (gridOp.getIrregularCount(this.gridForm) > 0) {
      this.childrenMainSize.update(0, this.getHeadMsgHeight());
    }
    this.childrenMainSize.update(lastIndex, lastRowHeight);
    this.childrenMainSize.update(lastIndex + 1, this.tailHeight);
    this.attributeUpdater.updateChildrenMainSize(this.childrenMainSize);
  }

  private getHeadMsgHeight(): number {
    let headMsgHeight = this.titleBarObserverProxy.getTitleBarHeight();
    if (this.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.FULL) {
      headMsgHeight += this.gridObserverProxy.getHeadMsgPullDownHeight();
    }
    return headMsgHeight;
  }
}