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

import lazy { Constants, SelectMediaType } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { GridAttributeUpdater, AbstractGridVc } from './AbstractGridVc';
import lazy { OperateDefine } from './constants/OperateDefine';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { AbstractDayGridVm } from '../viewmodel/AbstractDayGridVm';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { FormIndex, PullDownState } from '../statemanager/constants/GridDefine';
import lazy { GridScrollMsg } from '@ohos/common/src/main/ets/default/model/common/GridScrollMsg';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { MediaTypeChecker } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';

const REUSE_DELAY: number = 500;

/**
 * 日视图宫格属性更新器
 */
export class DayGridAttributeUpdater extends GridAttributeUpdater {
  protected override notVisible: Visibility = Visibility.Hidden;
  protected override originalBgColor: Resource = $r('sys.color.ohos_id_color_sub_background');

  /**
   * 刷新焦点控制状态
   *
   * @param focusable 是否可获焦
   */
  public updateFocusable(focusable: boolean): void {
    this.attribute?.focusable(focusable);
  }

  protected override initInstance(instance: GridAttribute): void {
    super.initInstance(instance);
    instance
      .multiSelectable(true)
      .flingSpeedLimit(OperateDefine.GRID_DAY_FLING_SPEED)
      .focusScopeId(Constants.TIMELINE_GRID, true, false)
      .tabIndex(IndexFocusOrder.PHOTO_GRID_VIEW)
      .focusScopePriority(Constants.TIMELINE_GRID, FocusPriority.PREVIOUS);
  }
}

/**
 * 抽象日视图宫格视图控制器
 */
@Observed
export abstract class AbstractDayGridVc<V extends AbstractDayGridVm, U extends DayGridAttributeUpdater>
  extends AbstractGridVc<V, U> {
  /**
   * 图片高度
   */
  @Track public imageGridItemHeight: number = 0;

  /**
   * 行尾补位
   */
  @Track public tailFillPosition: number[] = [];

  /**
   * 滚动消息
   */
  @Track public gridScrollMsg: GridScrollMsg = new GridScrollMsg(false);
  /**
   * 是否显示Sd卡片提示
   */
  @Track public isShowSdCardTip: boolean = false;

  @Track public drawnThumbnailCount: number = 0;

  @Track public isHorizontal: boolean = isOrientationHorizontal();

  @Track public selectMediaType: SelectMediaType = SelectMediaType.INVALID;

  @Track public isRefreshGrid: boolean = true;

  @Track public isBlockReuse: boolean = false;

  protected override initStates(): void {
    super.initStates();

    // 更新布局
    this.initLayout();

    // 更新自定义属性
    this.gridObserverProxy.getGridImageHeight(this.gridForm, (_old, newState) => this.imageGridItemHeight = newState);

    // 更新行尾占位
    this.registerDataSourceListener({
      onDataUpdate: (count: number): void => {
        LogUtils.info(this.tag, `onDataUpdate ${count}`);
        this.updateTailFillPosition();
      }
    });
    this.gridObserverProxy.getFillPostion(this.gridForm, () => this.updateTailFillPosition());
    this.gridObserverProxy.getGridColumn(this.gridForm, () => this.updateTailFillPosition());

    // 修改滚动状态，避免宫格自行刷新（性能问题）
    this.scrollerObserverProxy.getIsScrolling(this.gridForm, (_oldState, isScrolling) => {
      this.gridScrollMsg.isScrolling = isScrolling &&
        this.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.NONE;
    });

    this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm, (_oldState, isScrollerBarTouch) => {
      this.gridScrollMsg.isScrollerBarTouch = isScrollerBarTouch;
    });

    // 监听横竖屏切换
    this.displayObserverProxy.getIsHorizontal((_oldState, isHorizontal) => {
      if (this.isHorizontal === isHorizontal) {
        LogUtils.info(this.tag, `init IsHorizontal:${isHorizontal}`);
        return;
      }
      this.isHorizontal = isHorizontal;
      LogUtils.info(this.tag, `getIsHorizontal:${isHorizontal}`);
      if (this.displayObserverProxy.getIsGridActive() && this.displayObserverProxy.getIsGridShow()) {
        this.isRefreshGrid = !this.isRefreshGrid;
        this.isBlockReuse = true;
        setTimeout(() => {
          this.isBlockReuse = false;
        }, REUSE_DELAY);
      }
    });

    // 更新多选模式下,所选中媒体项囊括的类型,用于移动到功能
    this.selectObserverProxy.getSelectedParseResult((_oldState, newState) => {
      if (this.isInCurrentForm()) {
        this.selectMediaType = newState.get<SelectMediaType>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE) ?? SelectMediaType.INVALID;
        LogUtils.info(this.tag, `update selectMediaType to: ${this.selectMediaType}`);
      }
    })
  }

  private initLayout(): void {
    this.gridObserverProxy.getGridImageGutter(this.gridForm, (_oldState, newState) => {
      this.attributeUpdater.updateGridGutter(newState);
    });
    this.gridObserverProxy.getGridImageColumnGutter(this.gridForm, (_oldState, newState) => {
      this.attributeUpdater.updateGridColumnGutter(newState);
    });
    let gridPaddingLeftAndRight: number = this.gridObserverProxy.getGridPaddingLeftAndRight();
    this.attributeUpdater.updatePadding({
      start: LengthMetrics.vp(gridPaddingLeftAndRight),
      end: LengthMetrics.vp(gridPaddingLeftAndRight),
    });
    this.gridObserverProxy.getGridColumn(this.gridForm, (_oldState, newState) => {
      this.attributeUpdater.updateGridColumn(newState);
    });
    this.displayObserverProxy.getGridCovered((_oldState, isGridCovered) => {
      this.attributeUpdater.updateFocusable(!isGridCovered);
    });
  }

  protected updateTailFillPosition(): void {
    let totalCount: number;
    if (this.gridForm === FormIndex.GROUP_DAY) {
      // 使用最后一组分组数据
      totalCount = this.groupInfo.getGroupCount(this.groupInfo.groupSize - 1);
    } else {
      totalCount = this.viewModel?.totalCount() ?? 0;
    }
    const fillPostion = this.gridObserverProxy.getFillPostion(this.gridForm);
    const gridColumn = this.gridObserverProxy.getGridColumn(this.gridForm);
    const lastRowCount = (totalCount + fillPostion) % gridColumn;
    const tailFp = lastRowCount > 0 ? (gridColumn - lastRowCount) : 0;
    this.tailFillPosition = new Array(tailFp).fill(0).map((_: number, index: number) => index + 1);
    LogUtils.info(this.tag, `updateTailFillPosition: ${tailFp}`);
  }

  /**
   * 更新宫格布局
   *
   * @param isImmediately 是否立刻更新布局
   */
  public updateLayoutOptions(isImmediately: boolean = true): void {
  };

  /**
   * 图片和视频相册，宫格窗口显示的数据跟随索引变化
   *
   * @param placeholderIndex 当前大图显示索引位置
   */
  public onPlaceholderChanged(placeholderIndex: number): void {
  }
}