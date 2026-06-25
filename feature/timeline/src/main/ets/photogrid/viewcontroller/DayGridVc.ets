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
import lazy { FormIndex, ShowMode, ScrollReason } from '../statemanager/constants/GridDefine';
import lazy { PreloadStateType, PreloadStateTypeUtils } from '../statemanager/GridPreloadFsm';
import lazy { DayGridVm } from '../viewmodel/DayGridVm';
import lazy { DayGridAttributeUpdater, AbstractDayGridVc } from './AbstractDayGridVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';
import lazy { DataSourceListener } from '../model/DataSourceManager';
import lazy { LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  AlbumGridSortHelper,
  AlbumGridSortRule,
  SortRuleString
} from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { curves, LengthMetrics } from '@kit.ArkUI';
import lazy { PinchAction } from '../statemanager/constants/PinchDefine';
import lazy { FormStateType } from '../statemanager/GridFormFsm';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';

/**
 * 分段按钮回调
 */
export interface DataSourceCallback {
  /**
   * 获取当前加载数据
   *
   * @param 当前加载数据
   */
  getLoadingResult: (result: LoadingResult<MediaItem>) => void;
}

/**
 * 日宫格视图控制器
 */
@Observed
export class DayGridVc extends AbstractDayGridVc<DayGridVm, DayGridAttributeUpdater> {
  /**
   * 占位数组
   */
  @Track public fillPositionArr: number[] = [];

  @Track public isShowFileSize: boolean = false;

  // 极简开关
  @Track public isMinimalism: boolean = false;

  // 是否回收宫格节点
  @Track public recycleGridItemSate: boolean = false;

  // 是否展示云同步卡片，从view层传递
  @Track public isShowCloudCard: boolean = false;
  // 是否展示相机地理位置权限
  @Track public isCameraAuthCardShow: boolean = false;

  // 数据库回调
  private dataSourceCallback?: DataSourceCallback;

  private startPinchFormState: FormStateType = FormStateType.INIT_STATE;

  /**
   * 日视图切换到月视图时候释放ImageGridItemComponent节点进复用池
   */
  public override updateRecycleGridItemSate(state: boolean): void {
    if (!AlbumUtils.useReleaseDayGrid()) {
      return;
    }
    if (this.recycleGridItemSate == true && state == false) {
      LogUtils.info(this.tag, `updateRecycleGridItemSate resume ${this.viewModel?.getScrollChange()}`);
      this.recycleGridItemSate = state;
      if (this.viewModel) {
        let layoutInfo = this.viewModel.getScrollOffsetLayoutIndex();
        if (layoutInfo) {
          this.viewModel.getScroller().scrollToIndex(layoutInfo[0], false, ScrollAlign.START,
            { extraOffset: LengthMetrics.vp(layoutInfo[1]) });
          LogUtils.info(this.tag, `updateRecycleGridItemSate change new value ${layoutInfo[0]} ${layoutInfo[1]}`);
        }
        if (this.viewModel?.getScrollChange() === false) {
          this.viewModel.setScrollChange(true);
        }
      }
    }

    if (this.recycleGridItemSate == false && state == true) {
      this.recycleGridItemSate = state;
      LogUtils.info(this.tag, `updateRecycleGridItemSate start recycle ${this.viewModel?.getScrollChange()}`);
    }
  }

  private readonly spliceDataListener: DataSourceListener = {
    onSpliceDataLoadFinish: (result: LoadingResult<MediaItem>): void => {
      let isInCurrentView: boolean = this.isInCurrentForm();
      LogUtils.info(this.tag, `spliceDataListener:${isInCurrentView} ${JSON.stringify(result)}`);
      if (isInCurrentView) {
        this.dataSourceCallback?.getLoadingResult(result);
      }
    }
  };

  public constructor(attributeUpdater?: DayGridAttributeUpdater) {
    super(FormIndex.DAY, attributeUpdater ?? new DayGridAttributeUpdater(ViewId.DAY_GRID, ViewZIndex.DAY_GRID),
      'DayGridVc', ShowMode.VISIBLE);
  }

  protected override initStates(): void {
    super.initStates();
    this.initObservers();
    this.gridScrollMsg.isShowPreview = true;
  }

  private initObservers(): void {
    // 可见性设置，同时考虑上下树和可见
    this.getPreloadState((_oldState: PreloadStateType, newState: PreloadStateType) => {
      this.isCanShow = PreloadStateTypeUtils.isInLoadedOrTimeoutState(newState);
      let isCanVisible = PreloadStateTypeUtils.isInLoadedState(newState);
      this.updateCanShowState(isCanVisible);
      if (newState === PreloadStateType.HIDDEN_STATE) {
        this.gridScrollMsg.isShowPreview = false;
      }
      LogUtils.info(this.tag, `updateShowState ${newState}, isCanShow: ${this.isShow}, isCanVisible: ${isCanVisible}`);
    });

    this.gridObserverProxy.getGridSortState((oldState, newState) => {
      LogUtils.info(this.tag, `update grid sort from ${oldState} to ${newState}`);
      this.isShowFileSize = AlbumGridSortRule.FILE_SIZE === newState.rule;
    });

    if (this.gridObserverProxy.config.isSupportMinimal) {
      this.scrollerObserverProxy.getIsScrolling(this.gridForm, (_oldValue, newValue) => {
        this.updateMinimalismState();
      });
      this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm, (_oldValue, newValue) => {
        this.updateMinimalismState();
      })
    }

    this.gridObserverProxy.getScrollOffset(this.gridForm, (_oldValue, currentOffset, reason?: string): void => {
      if (reason !== ScrollReason.SWITCH) {
        return;
      }
      LogUtils.info(this.tag, `getScrollOffset updateRecycleGridItemSate ${reason}`);
      this.viewModel?.setScrollChange(true);
      this.updateRecycleGridItemSate(false);
    })

    this.pinchObserverProxy.registerEventListener({
      onPinchStateChange: (pinchState: PinchAction) => {
        switch (pinchState) {
          case PinchAction.START:
            this.viewModel?.setScrollChange(false);
            this.startPinchFormState = this.getFormState();
            break;
          case PinchAction.END:
            let endPinchFormState = this.getFormState();
            LogUtils.info(this.tag, `PinchAction.END ${this.startPinchFormState} ${endPinchFormState}`);
            if (endPinchFormState != FormStateType.DAY_FOLLOW_HAND_STATE &&
              endPinchFormState != FormStateType.GROUP_DAY_FOLLOW_HAND_STATE) {
              this.updateRecycleGridItemSate(true);
            }
            break;
        }
      },

      onPinchWillArrive: (formIndex: FormIndex): void => {
        if (!this.isInCurrentForm() && this.viewModel && this.viewModel.getScrollChange() == false) {
          this.updateRecycleGridItemSate(false);
        }
      },

      onPreFromSwitch: (targetForm: FormIndex): void => {
        if (this.gridForm === targetForm) {
          if (this.viewModel && this.viewModel.getScrollChange() == false) {
            this.updateRecycleGridItemSate(false);
          }
        }
      },
    });
  }

  /**
   * 更新日宫格视图IrregularIndex
   */
  public override updateLayoutOptions(isImmediately: boolean = true): void {
    let msg: string[] = [`updateLayoutOptions`];
    msg.push(`isShowCloudCard:${this.isShowCloudCard}, isShowSdCardTip:${this.isShowSdCardTip}` +
      `, isCameraAuthCardShow:${this.isCameraAuthCardShow}, isSupportShowCameraCard:${this.gridObserverProxy.config.isShowCameraCard}`);
    const isShowCard: boolean = this.isShowCloudCard || this.isShowSdCardTip ||
      (this.isCameraAuthCardShow && this.gridObserverProxy.config.isShowCameraCard);
    this.gridLayoutOptions = {
      regularSize: [1, 1],
      irregularIndexes: isShowCard ? [0, 1] : [0],
    };
    msg.push(`irregularIndexes: ${this.gridLayoutOptions.irregularIndexes}`);
    LogUtils.info(this.tag, msg.join(', '));
  }

  /**
   * 注册数据库更新回调
   *
   * @param dataSourceCallback 数据库更新回调
   */
  public registerSpliceDataSourceListener(dataSourceCallback?: DataSourceCallback): void {
    if (dataSourceCallback) {
      this.dataSourceCallback = dataSourceCallback;
      this.registerDataSourceListener(this.spliceDataListener);
    } else {
      this.unRegisterDataSourceListener(this.spliceDataListener);
    }
  }

  protected override doUpdateFillPosition(fillPosition: number): void {
    this.fillPositionArr = new Array(fillPosition).fill(0).map((_: number, index: number) => index + 1);
  }

  /**
   * 更新极简宫格开关
   * @param scrollerState 滚动条状态
   */
  private updateMinimalismState(): void {
    if (this.scrollerObserverProxy.getIsScrollerTouched() && this.scrollerObserverProxy.getIsScrolling() &&
      !this.isSelectMode) {
      this.isMinimalism = true;
    } else {
      this.isMinimalism = false;
    }
    LogUtils.info(this.tag, `Whether to load the minimal grid: ${this.isMinimalism}`);
  }
}