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
import lazy { GridConfig } from '../statemanager/config/GridConfig';
import lazy { DEFAULT_BOTTOM_AVOID_HEIGHT, DEFAULT_TOP_AVOID_HEIGHT } from '../statemanager/constants/DisplayDefine';
import lazy { FORM_SIZE, FormIndex, ShowMode } from '../statemanager/constants/GridDefine';
import lazy { FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { PreloadStateTypeUtils } from '../statemanager/GridPreloadFsm';
import lazy { PhotoGridVm } from '../viewmodel/PhotoGridVm';
import lazy { BaseAttributeUpdater, AbstractVc } from './AbstractVc';
import lazy { ViewId } from './constants/ViewDefine';
const TAG = 'PhotoGridVc'
/**
 * 宫格根组件属性更新器
 */
export class RootAttributeUpdater extends BaseAttributeUpdater {
  protected override initInstance(instance: CommonAttribute): void {
    super.initInstance(instance);
    instance
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
  }
}

/**
 * 宫格属性更新器
 */
export class GridAttributeUpdater extends BaseAttributeUpdater<RelativeContainerAttribute> {
  /**
   * 底部规避区域高度
   */
  private bottomAvoidHeight: number = DEFAULT_BOTTOM_AVOID_HEIGHT;

  /**
   * 顶部规避区域高度（标题栏高度）
   */
  private topAvoidHeight: number = DEFAULT_TOP_AVOID_HEIGHT;

  /**
   * 不规则区域对齐高度
   */
  private irregularBottom: number = 0;

  /**
   * 宫格导航线
   */
  private guideLine: Array<GuideLineStyle> = [
    {
      id: ViewId.BOTTOM_AVOID_GUIDELINE,
      direction: Axis.Horizontal,
      position: { end: this.bottomAvoidHeight },
    },
    {
      id: ViewId.TOP_AVOID_GUIDELINE,
      direction: Axis.Horizontal,
      position: { start: this.topAvoidHeight },
    },
    {
      id: ViewId.IRREGULAR_BOTTOM_GUIDELINE,
      direction: Axis.Horizontal,
      position: { start: this.irregularBottom },
    },
  ];

  /**
   * 更新底部避让区域
   *
   * @param newHeight 底部避让区域
   */
  public updateBottomAvoidHeight(newHeight: number): void {
    this.bottomAvoidHeight = newHeight;
    this.guideLine[0].position = { end: this.bottomAvoidHeight };
    this.attribute?.guideLine(this.guideLine);
  }

  /**
   * 更新底部避让区域
   *
   * @param newHeight 底部避让区域
   */
  public updateTopAvoidHeight(newHeight: number): void {
    this.topAvoidHeight = newHeight;
    this.guideLine[1].position = { start: this.topAvoidHeight };
    this.attribute?.guideLine(this.guideLine);
  }

  /**
   * 更新不规则区域对齐高度
   *
   * @param newHeight 不规则区域对齐高度
   */
  public updateIrregularBottom(newHeight: number): void {
    this.irregularBottom = newHeight;
    this.guideLine[2].position = { start: this.irregularBottom };
    this.attribute?.guideLine(this.guideLine);
  }

  /**
   * 获取不规则区域对齐高度
   */
  public getIrregularBottom(): number {
    return this.irregularBottom;
  }

  protected override initInstance(instance: RelativeContainerAttribute): void {
    super.initInstance(instance);
    instance
      .width('100%')
      .height('100%')
      .transition(TransitionEffect.opacity(0.99))
      .guideLine(this.guideLine);
  }
}

/**
 * 延时加载参数
 */
interface DelayInitParams {
  /**
   * 延时初始化条件
   *
   * @returns 是否满足
   */
  condition?: () => boolean;

  /**
   * 延时加载前执行函数
   */
  initFunc: ()=> void;

  /**
   * 延时加载完成后执行函数
   */
  loadedFunc: () => void;
}

/**
 * 宫格页日视图控制器
 */
export class PhotoGridVc extends AbstractVc<PhotoGridVm, RootAttributeUpdater> {
  /**
   * 标题栏蒙层是否初始化
   */
  @Track public isTitleBarMaskInit: boolean = false;

  /**
   * 无数据视图是否初始化
   */
  @Track public isNoDataViewInit: boolean = false;

  /**
   * 日视图是否初始化
   */
  @Track public isDayPreviewInit: boolean = false;

  /**
   * 日视图是否初始化
   */
  @Track public isDayViewInit: boolean = false;

  /**
   * 日视图是否初始化
   */
  @Track public isGroupDayPreviewInit: boolean = false;

  /**
   * 日分组视图是否初始化
   */
  @Track public isGroupDayViewInit: boolean = false;

  /**
   * 工具栏是否初始化
   */
  @Track public isToolBarInit: boolean = true;

  /**
   * 不规则区域是否初始化
   */
  @Track public isIrregularViewInit: boolean = false;

  /**
   * 是否无数据宫格
   */
  @Track public isNoDataState: boolean = false;

  /**
   * 当前宫格状态
   */
  @Track public currentForm: FormIndex = FormIndex.INVALID;

  /**
   * 宫格本体属性更新器
   */
  @Track public gridUpdater: GridAttributeUpdater = new GridAttributeUpdater();

  public constructor() {
    super(new RootAttributeUpdater(), 'PhotoGridVc', ShowMode.VISIBLE);
  }

  protected override initStates(): void {
    super.initStates();
    this.getIsWaitDataSourceManager((_oldState, isWaitDataSourceManager) => {
      if (isWaitDataSourceManager) {
        LogUtils.info(this.tag, 'isWaitDataSourceManager');
        return;
      }
      this.initInitStates();
      this.initDelayInitStates();
      this.initDisplayStates();
    });
    this.getOperateState((_oldState, newState) => {
      LogUtils.info("PhotoGridVc","getOperateState: " + newState);
      this.isNoDataState = OperateStateTypeUtils.isInNotDataState(newState);
    });
  }

  protected override doRelease(): void {
    super.doRelease();
  }

  private initInitStates(): void {
    this.isNoDataViewInit = true;
    let gridConfig: GridConfig = this.gridObserverProxy.config;
    this.isIrregularViewInit = gridConfig.isSupportHeadMsg || gridConfig.isSupportOtherIrregular;
    this.isDayViewInit = true;
    this.isGroupDayViewInit = gridConfig.isSupportGroupDay;
  }

  private initDelayInitStates(): void {

    if (this.gridObserverProxy.config.isSupportPreload &&
      PreloadStateTypeUtils.isInitOrPreloadState(this.getPreloadState())) {
      // 延时初始化标题栏蒙层
      this.delayInitTitleBarMaskView();

      // 延时初始化无数据视图
      this.delayInitNoDataView();

      // 延时初始化日视图
      this.delayInitDayView();

      // 延时初始化工具栏
      this.delayInitToolbarView();

      // 延时初始化消息头
      this.delayInitIrregularView();
    } else {
      // 此时，两个日视图可能同时加载，需要进行错峰处理
      this.delayLoadDayGrid();
    }
  }

  private initDisplayStates(): void {
    // 初始化显示状态
    this.displayObserverProxy.getIsGridShow((_oldState, isGridShow) => this.updateShowState(isGridShow, 'IsGridShow'));

    // 初始化底部避让区域
    this.displayObserverProxy.getBottomAvoidHeight((_oldState, bottomAvoidHeight) => {
      this.gridUpdater.updateBottomAvoidHeight(bottomAvoidHeight);
    });

    // 初始化顶部避让区域
    this.displayObserverProxy.getTopAvoidHeight((_oldState, topAvoidHeight) => {
      this.gridUpdater.updateTopAvoidHeight(topAvoidHeight);
    });

    // 初始化当前宫格状态
    this.getFormState((_oldState, newState) => {
      this.currentForm = this.getCurrentForm();
    });

    // 初始化消息头底部对齐高度
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.gridObserverProxy.getScrollOffset(formIndex, () => {
        if (formIndex === this.currentForm) {
          this.updateIrregularBottom();
        }
      });
      this.gridObserverProxy.getIrregularHeight(formIndex, () => {
        if (formIndex === this.currentForm) {
          this.updateIrregularBottom();
        }
      });
      this.gridObserverProxy.getIrregularCount(formIndex, () => {
        if (formIndex === this.currentForm) {
          this.updateIrregularBottom();
        }
      });
    }
    this.getFormState(() => this.updateIrregularBottom());
  }

  private updateIrregularBottom(): void {
    const gridOp = this.gridObserverProxy;
    const irregularBottom = (gridOp.getIrregularCount(this.currentForm) > 1 ? gridOp.getHeadMsgHeight() :
      gridOp.getIrregularHeight(this.currentForm)) - gridOp.getScrollOffset(this.currentForm);
    if (irregularBottom > 0 || this.gridUpdater.getIrregularBottom() > 0) {
      this.gridUpdater.updateIrregularBottom(irregularBottom);
    }
  }

  private delayInitTitleBarMaskView(): void {
    this.delayInit({
      condition: (): boolean => {
        return this.isTitleBarMaskInit;
      },
      initFunc: (): void => {
        this.isTitleBarMaskInit = false;
      },
      loadedFunc: (): void => {
        this.isTitleBarMaskInit = true;
      }
    });
  }

  private delayInitNoDataView(): void {
    this.delayInit({
      initFunc: (): void => {
        this.isNoDataViewInit = false;
      },
      loadedFunc: (): void => {
        this.isNoDataViewInit = true;
      }
    });

    this.getOperateState((_oldState, newState): void => {
      if (OperateStateTypeUtils.isInNotDataState(newState)) {
        this.isNoDataViewInit = true;
      }
    });
  }

  private delayInitDayView(): void {
    let initFromGroup: boolean =
      this.gridObserverProxy.config.isSupportGroupDay && this.gridObserverProxy.config.isLastFormIsDayGroup;
    LogUtils.info(TAG, 'initFromGroup'+this.gridObserverProxy.config.isSupportGroupDay + this.gridObserverProxy.config.isLastFormIsDayGroup);
    this.isDayPreviewInit = !initFromGroup;
    this.isGroupDayPreviewInit = initFromGroup;
    this.delayInit({
      initFunc: (): void => {
        this.isDayViewInit = false;
        this.isGroupDayViewInit = false;
      },
      loadedFunc: (): void => {
        this.isDayViewInit = true;
        this.isGroupDayViewInit = this.gridObserverProxy.config.isSupportGroupDay;
        this.delayLoadDayGrid();
      }
    });
  }

  private delayInitToolbarView(): void {
    this.delayInit({
      condition: (): boolean => {
        // 默认不在多选态时，支持延时初始化
        return !this.selectObserverProxy.config.isSupportDefaultSelect;
      },
      initFunc: (): void => {
        this.isToolBarInit = false;
      },
      loadedFunc: (): void => {
        this.isToolBarInit = true;
      }
    });
  }

  private delayInitIrregularView(): void {
    this.delayInit({
      condition: (): boolean => {
        return this.isIrregularViewInit;
      },
      initFunc: (): void => {
        this.isIrregularViewInit = false;
      },
      loadedFunc: (): void => {
        this.isIrregularViewInit = true;
      }
    });
  }

  private delayInit(delayInitParams: DelayInitParams) {
    if (!delayInitParams.condition || delayInitParams.condition()) {
      delayInitParams.initFunc();
      this.getPreloadState((oldState, newState) => {
        LogUtils.info(TAG, 'oldState+newState'+oldState+newState);
        if (!PreloadStateTypeUtils.isInLoadedOrTimeoutState(oldState) &&
          PreloadStateTypeUtils.isInLoadedOrTimeoutState(newState)) {
          delayInitParams.loadedFunc();
        }
      });
    }
  }

  private delayLoadDayGrid(): void {
    if (!this.isDayViewInit || !this.isGroupDayViewInit) {
      LogUtils.info(TAG, '!this.isDayViewInit || !this.isGroupDayViewInit'+!this.isDayViewInit + !this.isGroupDayViewInit);
      return;
    }
    this.viewModel?.openDelayLoad();
    const currentForm = this.getCurrentForm();
    this.isDayViewInit = currentForm === FormIndex.DAY;
    this.isGroupDayViewInit = currentForm === FormIndex.GROUP_DAY;
    LogUtils.info(TAG, 'currentForm'+currentForm);
    if (currentForm === FormIndex.INVALID) {
      if (this.gridObserverProxy.config.isLastFormIsDayGroup) {
        this.isGroupDayViewInit = true;
      } else {
        this.isDayViewInit = true;
      }
    }
    this.getFormState((_oldState, newState) => {
      if (FormStateTypeUtils.isInGroupDayState(newState)) {
        this.isGroupDayViewInit = true;
      } else if (FormStateTypeUtils.isInDayState(newState)) {
        this.isDayViewInit = true;
      }
    });
    this.gridObserverProxy.getDelayLoad((_oldState, newState) => {
      if (!newState) {
        this.isDayViewInit = true;
        this.isGroupDayViewInit = true;
      }
    });
    LogUtils.info(TAG, 'isDayViewInit'+this.isDayViewInit);
    LogUtils.info(TAG, 'isGroupDayViewInit'+this.isGroupDayViewInit);
  }
}