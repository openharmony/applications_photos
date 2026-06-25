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
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { GridScrollMsg } from '@ohos/common/src/main/ets/default/model/common/GridScrollMsg';
import lazy { GridScrollBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridScrollBaseHelper';
import lazy { GridSlideBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridSlideBaseHelper';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { convertToMViewType } from '../../model/Constants';
import lazy { FormIndex, IrregularType, PullDownState, ScrollReason } from '../statemanager/constants/GridDefine';
import lazy { SwitchMode, SwitchShowUpdateReason } from '../statemanager/constants/SwitchDefine';
import lazy { OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { FindAddressParam } from '../statemanager/TitleBarStateManager';
import lazy { AbstractFormVm } from './AbstractFormVm';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { SwitchCommonUtils } from './utils/SwitchCommonUtils';
import lazy { AlignMode, SwitchCalcUtils } from './utils/SwitchCalcUtils';
import lazy { SwitchStartUtils } from './utils/SwitchStartUtils';
import lazy { SwitchStartInfo } from '../statemanager/common/SwitchStartInfo';
import lazy { StatusBarClickEvent } from '@ohos/common/src/main/ets/default/utils/StatusBarClickEvent';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { TabbarShowController } from '@ohos/common/src/main/ets/default/model/common/TabbarShowController';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

// 触底阈值
const ENTER_REACH_END_HEIGHT: number = 0;
const EXIT_REACH_END_HEIGHT: number = 24;

/**
 * 滚动条更新结果
 */
export interface ScrollBarUpdateResult {
  totalOffset: number;
  totalLength: number;
}

/**
 * 滚动视图模型
 */
export abstract class AbstractScrollVm extends AbstractFormVm {
  protected firstIndexInGrid: number = 0;
  protected lastIndexInGrid: number = 0;
  protected gridScrollMsg: GridScrollMsg = new GridScrollMsg(false);
  protected scrollHelper?: GridScrollBaseHelper;
  protected slideHelper?: GridSlideBaseHelper;
  protected firIndexDateTaken: number = 0;
  protected currentTime: string = '0';
  private isShowScrollBar: boolean = false;
  // 消息占位区域最小高度
  private minRefreshHeight: number = 0;
  // 消息占位区域最大高度
  private maxRefreshHeight: number = 0;
  // 横竖屏切换开始时记录的宫格位置信息
  private startInfo?: SwitchStartInfo;
  private clickEvent: StatusBarClickEvent = new StatusBarClickEvent();
  // 总高度
  private totalHeight: number = 0;
  // 宫格显示区域高度
  private gridAreaHeight: number = 0;
  // onScrollBarUpdate调用时的缓存信息
  private onScrollBarUpdateCachedIndex: number = -1;
  private onScrollBarUpdateCachedOffset: number = -1;
  // 是否已经完成过加载
  private hasAppeared: boolean = false;
  // 返回顶部延时定时器
  private backToTopDelay: number = 0;
  // 绘制触发的对应帧的滚动条位置与实际用户手指的间隔
  private flushToRealOffset: number = 0;
  // 加载内容对应帧位置与绘制位置的间隔
  private loadToFlushOffset: number = 0;
  // onScrollBarUpdateInner方法是否被触发
  private scrollBarUpdateInnerTriggered: boolean = false;
  // 是否滚动条滚动中
  private isScrollerBarScrolling: boolean = false;
  // 当前屏幕首个有效地址的Item
  private firstAddressMediaItem: MediaItem | undefined;
  // tabbar沉浸式动效
  private tabbarShowController: TabbarShowController = TabbarShowController.getInstance();
  private isEdgeEffect: boolean = true;
  // 重置位置信息
  private isNeedResetSubLocalityAddress: boolean = false;

  /**
   * 触发数据预加载
   *
   * @param firstIndex 预加载的数据索引
   * @param reason 触发原因
   */
  public abstract triggerPreloadViewData(firstIndex: number, reason?: string): void;

  /**
   * 组件加载完成时触发
   */
  public onAppear(): void {
    LogUtils.debug(this.tag, 'onAppear');
    if (!this.hasAppeared) {
      this.hasAppeared = true;
      TraceUtils.finishTrace(TraceTaskType.GRID_INIT, this.gridForm);
    }
    this.scrollerObserverProxy.getInitIndexInGrid(this.gridForm,(_oldValue,newValue)=>  {
      if (newValue <= 0) {
        return;
      }
      LogUtils.info(this.tag, `init index: ${newValue}`);
      setTimeout(()=> {
        this.getScroller().scrollToIndex(newValue, false, ScrollAlign.START,
          { extraOffset: LengthMetrics.vp(-this.titleBarObserverProxy.getTitleBarHeight())});
      }, Constants.GRL_SCROLL_DELAY_TIME);
      this.scrollerStateManager.getInitIndexInGridAsm(this.gridForm).updateState(-1);
    });
    this.gridObserverProxy.getScrollOffset(this.gridForm, (_oldValue, currentOffset, reason?: string): void => {
      if (reason === ScrollReason.DEFAULT) {
        return;
      }
      const offset = this.autoUpdateHeadMsgHeight(currentOffset);
      const realOffset = Math.max(currentOffset - offset, 0);
      this.gridStateManager.getScrollOffsetManager(this.gridForm).updateState(realOffset, ScrollReason.DEFAULT);
      let layoutInfo = SwitchCommonUtils.calcLayoutIndex(this, this.gridForm, realOffset);
      this.getScroller().scrollToIndex(layoutInfo[0], false, ScrollAlign.START,
        { extraOffset: LengthMetrics.vp(realOffset - layoutInfo[1]) });
    })
    this.clickEvent.register(this.tag, () => this.backToTop());
  }

  /**
   * 组件销毁时触发
   */
  public onDisAppear(): void {
    LogUtils.debug(this.tag, 'onDisAppear');
    this.clickEvent.unRegister();
  }

  /**
   * 滑动手势触发
   */
  public onPanGesture(_event: GestureEvent): void {
    LogUtils.debug(this.tag, 'PanGesture Horizontal start');
  }

  /**
   * 触摸事件监听
   *
   * @param event 触摸事件
   */
  public onTouch(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      LogUtils.debug(this.tag, 'onTouch down');
    } else if (event.type === TouchType.Move) {
      LogUtils.debug(this.tag, 'onTouch move');
    } else if (event.type === TouchType.Up) {
      LogUtils.debug(this.tag, 'onTouch up');
      this.updateCloudSync();
    } else {
      LogUtils.debug(this.tag, 'onTouch other');
    }
  }

  /**
   * 滚动开始
   */
  public onScrollStart(): void {
    LogUtils.info(this.tag, 'onScrollStart');
    TraceUtils.startTrace(TraceTaskType.GRID_SCROLL, this.gridForm);
    this.loadToFlushOffset = 0;
    this.flushToRealOffset = 0;
    this.updateScrollState(true);
    this.isShowTimeLineScrollBar();
    if (this.gridForm === FormIndex.YEAR || this.gridForm === FormIndex.MONTH) {
      this.setDuringScroll(true);
      this.scrollHelper?.handleScrollStart();
    }
    this.stopReadyProcess();
  }

  /**
   * 每帧开始滚动时触发，事件参数传入即将发生的滚动量，事件处理函数中可根据应用场景计算实际需要的滚动量并作为事件处理函数的返回值返回，
   * Scroll将按照返回值的实际滚动量进行滚动
   *
   * @param offset 即将发生的滑动量，单位vp
   * @param state 当前滑动状态
   * @returns 返回实际滑动量
   */
  public onScrollFrameBegin(offset: number, state: ScrollState): ScrollResult {
    TraceUtils.startTrace(TraceTaskType.SCROLL_FRAME_BEGIN, this.gridForm);
    const result = this.onScrollFrameBeginInner(offset, state);
    TraceUtils.finishTrace(TraceTaskType.SCROLL_FRAME_BEGIN, this.gridForm);
    return result;
  }

  /**
   * 回调当前帧将要滚动的偏移量和当前滚动状态和滚动操作来源，其中回调的偏移量为计算得到的将要滚动的偏移量值，并非最终实际滚动偏移。
   *
   * @param offset 每帧滚动时水平方向的偏移量，Scroll中的内容向左/上滚动时偏移量为正，向右/下滚动时偏移量为负。单位vp
   * @param _state 当前滚动状态
   * @param source 当前滚动操作的来源
   * @returns 最终实际滚动偏移
   */
  public onWillScroll(offset: number, state: ScrollState, source: ScrollSource): void | ScrollResult {
    if (source === ScrollSource.EDGE_EFFECT) {
      this.isEdgeEffect = true;
    } else {
      this.isEdgeEffect = false;
    }
    TraceUtils.startTrace(TraceTaskType.WILL_SCROLL, this.gridForm);
    const result = this.onWillScrollInner(offset, state, source);
    TraceUtils.finishTrace(TraceTaskType.WILL_SCROLL, this.gridForm);
    return result;
  }

  /**
   * 在Grid每帧布局结束时触发，可通过该回调设置滚动条的位置及长度
   *
   * @param index 当前显示的网格起始位置的索引值
   * @param offset 当前显示的网格起始位置元素相对网格显示起始位置的偏移，单位vp
   * @returns 滚动条的位置及长度
   */
  public onScrollBarUpdate(index: number, offset: number): ScrollBarUpdateResult {
    TraceUtils.startTrace(TraceTaskType.SCROLL_BAR_UPDATE, this.gridForm);
    const result = this.onScrollBarUpdateInner(index, offset);
    TraceUtils.finishTrace(TraceTaskType.SCROLL_BAR_UPDATE, this.gridForm);
    return result;
  }

  /**
   * 滚动事件回调，滚动时触发
   *
   * @param scrollOffset 实际滚动距离
   * @param scrollState 滚动状态
   */
  public onDidScroll(scrollOffset: number, scrollState: ScrollState): void {
    LogUtils.debug(this.tag, `onDidScroll scrollOffset: ${scrollOffset}, scrollState: ${ScrollState[scrollState]}`);
    if (this.gridObserverProxy.getIsSupportTabbarAnimation()) {
      if (this.isInSelectMode()) {
        this.tabbarShowController.setIsShowTabbar(true);
        return;
      }
      if (this.isEdgeEffect) {
        this.tabbarShowController.setIsShowTabbar(true);
      } else if (scrollOffset > 0) {
        this.tabbarShowController.setIsShowTabbar(false);
      } else if (scrollOffset < 0) {
        this.tabbarShowController.setIsShowTabbar(true);
      }
    }
  }

  /**
   * 滚动停止回调
   */
  public onScrollStop(): void {
    LogUtils.info(this.tag, 'onScrollStop');
    this.updateCloudSync();
    this.isScrollerBarScrolling = false;
    this.updateCachedCount();
    this.updateScrollState(false);
    if (this.gridForm === FormIndex.YEAR || this.gridForm === FormIndex.MONTH) {
      this.setDuringScroll(false);
    }
    if (this.gridObserverProxy.config.isSupportHeadMsg) {
      if (this.gridObserverProxy.getHeadMsgHeight() - this.minRefreshHeight > px2vp(30)) {
        this.refreshShowAndHidden(-Number.MAX_SAFE_INTEGER);
      } else {
        this.refreshShowAndHidden(Number.MAX_SAFE_INTEGER);
      }
    }
    this.slideHelper?.handleScrollStop();
    this.startReadyProcess();
    TraceUtils.finishTrace(TraceTaskType.GRID_SCROLL, this.gridForm);
  }

  /**
   * 当前网格显示的起始位置/终止位置的item发生变化时触发
   *
   * @param firstIndexInGrid 起始位置
   * @param lastIndexInGrid 终止位置
   */
  public onScrollIndex(firstIndexInGrid: number, lastIndexInGrid: number): void {
    TraceUtils.startTrace(TraceTaskType.SCROLL_INDEX, this.gridForm);
    this.onScrollIndexInner(firstIndexInGrid, lastIndexInGrid);
    TraceUtils.finishTrace(TraceTaskType.SCROLL_INDEX, this.gridForm);
  }

  public onReachStart(): void {
    LogUtils.info(this.tag, 'onReachStart');
  }

  public onReachEnd(): void {
    LogUtils.info(this.tag, 'onReachEnd');
    this.updateSwitchHidToBottom();
  }

  /**
   * 获取对应宫格的数据源
   *
   * @returns 对应宫格的数据源
   */
  public abstract get dataSource(): AlbumDataSource;

  protected override doInit(persistentId: number): void {
    if (this.gridForm === FormIndex.DAY ||
      (this.gridObserverProxy.config.isSupportGroupDay && this.gridForm === FormIndex.GROUP_DAY)) {
      TraceUtils.startTrace(TraceTaskType.GRID_INIT, this.gridForm);
    }
    super.doInit(persistentId);

    // 初始化滚动相关辅助类
    if (!!this.scrollHelper) {
      this.scrollHelper.init(this.getScroller(), this.dataSource);
      this.displayObserverProxy.getGridAreaSize((_oldState, newState) => {
        this.scrollHelper?.setWinSize(newState.width, newState.height);
      });
    }
    if (!!this.slideHelper) {
      this.slideHelper.init(this.getScroller(), this.dataSource);
    }

    this.gridObserverProxy.getHeadMsgPullDownHeight(() => this.refreshHeadMsgHeight());
    this.titleBarObserverProxy.getTitleBarHeight(() => this.refreshHeadMsgHeight());

    this.displayObserverProxy.getLanguage((_oldState, newState) => {
      LogUtils.info(this.tag, `getLanguage:${this.firIndexDateTaken} ${this.firstIndexInGrid}`);
      // 切换语言后需要清空缓存的地址信息并重新请求地址
      if (newState) {
        this.isNeedResetSubLocalityAddress = true;
        UserFileManagerAccess.getInstance().clearAddressCache();
      }
      LogUtils.info(this.tag, `isNeedResetSubLocalLityAddress: ${this.isNeedResetSubLocalityAddress}`)
      this.updateCurrentTime(this.firstIndexInGrid);
    });

    // 当宫格列数变化时，清除索引与位置缓存
    this.gridObserverProxy.getGridColumn(this.gridForm, () => this.onScrollBarUpdateCachedIndex = -1);

    // 横竖屏切换时，触发滚动
    this.displayObserverProxy.registerEventListener({
      onPreAreaSizeChange: () => this.recordScrollInfoBeforeSizeChange(),
      onPostAreaSizeChange: () => this.updateScrollOffsetWhenSizeChange(),
      onPlaceHolderChange: (uniqueId: string, isTap: boolean) => this.onPlaceholderChange(uniqueId, isTap),
    });

    // 更新宫格缓存数量
    this.gridObserverProxy.getIsSwitching(() => this.updateCachedCount());
    this.displayObserverProxy.getIsGridResize(() => this.updateCachedCount());

    // 宫格、显示区域高度更新相关
    this.observerAndUpdateHeight();
  }

  protected override doRelease(): void {
    clearTimeout(this.backToTopDelay);
    super.doRelease();
  }

  /**
   * 每帧开始滚动时触发，事件参数传入即将发生的滚动量，事件处理函数中可根据应用场景计算实际需要的滚动量并作为事件处理函数的返回值返回，
   * Scroll将按照返回值的实际滚动量进行滚动
   *
   * @param offset 即将发生的滑动量，单位vp
   * @param state 当前滑动状态
   * @returns 返回实际滑动量
   */
  protected onScrollFrameBeginInner(offset: number, state: ScrollState): ScrollResult {
    if (!this.isCanScroll()) {
      LogUtils.debug(this.tag, `GRID_SWITCH ignor onScrollFrameBegin offset: ${offset}, state: ${ScrollState[state]}`);
      return { offsetRemain: 0 };
    }
    if (!this.gridObserverProxy.config.isSupportHeadMsg) {
      // 不支持消息头时直接返回
      return { offsetRemain: offset };
    }
    let nextScrollYOffset: number = this.gridObserverProxy.getScrollOffset(this.gridForm);
    let currentHeight: number = this.gridObserverProxy.getHeadMsgHeight();
    if (nextScrollYOffset <= 0 && currentHeight < this.maxRefreshHeight && offset < 0) {
      this.refreshShowAndHidden(offset);
      return { offsetRemain: 0 };
    }
    if (nextScrollYOffset >= 0 && currentHeight > this.minRefreshHeight && offset > 0) {
      this.refreshShowAndHidden(offset);
      return { offsetRemain: 0 };
    }
    return { offsetRemain: offset };
  }

  /**
   * 回调当前帧将要滚动的偏移量和当前滚动状态和滚动操作来源，其中回调的偏移量为计算得到的将要滚动的偏移量值，并非最终实际滚动偏移。
   *
   * @param offset 每帧滚动时水平方向的偏移量，Scroll中的内容向左/上滚动时偏移量为正，向右/下滚动时偏移量为负。单位vp
   * @param _state 当前滚动状态
   * @param source 当前滚动操作的来源
   * @returns 最终实际滚动偏移
   */
  protected onWillScrollInner(offset: number, _state: ScrollState, source: ScrollSource): void | ScrollResult {
    if (!this.isCanScroll(source)) {
      // 切换场景优先级高于滚动优先级，切换中时，仅允许来自SCROLLER的更新
      LogUtils.debug(this.tag, `GRID_SWITCH ignor onWillScroll offset: ${offset} source: ${ScrollSource[source]}`);
      return { offsetRemain: 0 };
    }
    // 日视图和日分组拖动滚动条离手后停止宫格滚动
    if (source === ScrollSource.SCROLL_BAR_FLING || this.gridScrollMsg?.isDragging) {
      return { offsetRemain: 0 };
    }

    if (source === ScrollSource.SCROLL_BAR) {
      this.isScrollerBarScrolling = true;
      this.updateCachedCount();
    }
    let targetOffset = this.gridObserverProxy.getScrollOffset(this.gridForm) + offset;
    if (targetOffset <= 0){
      this.updateScrollOffset(targetOffset);
    }
    if ((this.gridForm === FormIndex.DAY || this.gridForm === FormIndex.GROUP_DAY)
      && source !== ScrollSource.SCROLL_BAR) {
      return { offsetRemain: this.slideHelper?.handleWillScroll(offset, source) ?? offset };
    }
    if (!this.scrollHelper) {
      return { offsetRemain: offset };
    }
    this.scrollBarUpdateInnerTriggered = false;
    let scrollHelperOffset = this.scrollHelper.handleWillScroll(offset, source) ?? 0;
    if (scrollHelperOffset === 0) {
      this.flushToRealOffset += offset;
    } else {
      this.loadToFlushOffset = offset + this.flushToRealOffset;
      this.flushToRealOffset = 0;
    }
    return { offsetRemain: scrollHelperOffset ?? offset };
  }

  /**
   * 在Grid每帧布局结束时触发，可通过该回调设置滚动条的位置及长度
   *
   * @param index 当前显示的网格起始位置的索引值
   * @param offset 当前显示的网格起始位置元素相对网格显示起始位置的偏移，单位vp
   * @returns 滚动条的位置及长度
   */
  protected onScrollBarUpdateInner(index: number, offset: number): ScrollBarUpdateResult {
    const irregularHeight = this.gridObserverProxy.getIrregularHeight(this.gridForm);
    const irregularCount = this.gridObserverProxy.getIrregularCount(this.gridForm);
    let totalOffset: number = 0;
    if (index === 0) {
      totalOffset = -offset;
    } else if (index < irregularCount) {
      totalOffset = this.gridObserverProxy.getHeadMsgHeight() - offset; // HeadMsgHeight中包含了间距，故不再单独增加
    } else {
      totalOffset = irregularHeight + this.getGridOffset(index - irregularCount) - offset;
      if (!this.scrollBarUpdateInnerTriggered) {
        totalOffset += this.loadToFlushOffset;
        totalOffset += this.flushToRealOffset;
        this.scrollBarUpdateInnerTriggered = true;
      }
    }
    LogUtils.debug(this.tag,
      `onScrollBarUpdate index: ${index}, offset: ${offset}, totalOffset: ${totalOffset}, totalHeight: ${this.totalHeight}`);
    this.updateScrollOffset(totalOffset);
    return {
      totalOffset: totalOffset,
      totalLength: this.totalHeight,
    };
  }

  /**
   * 当前网格显示的起始位置/终止位置的item发生变化时触发
   *
   * @param firstIndexInGrid 起始位置
   * @param lastIndexInGrid 终止位置
   */
  protected onScrollIndexInner(firstIndexInGrid: number, lastIndexInGrid: number): void {
    this.handleIndexChange(firstIndexInGrid, lastIndexInGrid);
    this.updateSwitchHidToBottom();
  }

  /**
   * 判断能否滚动
   *
   * @param source 来源
   * @returns 能否滚动
   */
  protected isCanScroll(source?: ScrollSource): boolean {
    // 切换场景优先级高于滚动优先级，切换中时，切换开始时的宫格不再滚动，来自SCROLLER的滚动来自切换本身过程中的页面状态对齐，作为例外
    return !this.gridObserverProxy.getIsSwitching() || source === ScrollSource.SCROLLER;
  }

  protected startReadyProcess(): void {
    this.stateProxy?.dataSourceManager.startReadyProcess();
  }

  protected stopReadyProcess(): void {
    this.stateProxy?.dataSourceManager.stopReadyProcess();
  }

  protected isShowTimeLineScrollBar(): void {
    let count: number = this.totalCount();
    this.isShowScrollBar = (count > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
    LogUtils.info(this.tag, `isShowTimeLineScrollBar:${count}, ${this.isShowScrollBar}`);
  }

  /**
   * 处理grid Index变化事件
   *
   * @param firstIndexInGrid 起点index
   * @param lastIndexInGrid 终点index
   */
  protected handleIndexChange(firstIndexInGrid: number, lastIndexInGrid?: number): void {
    this.firstIndexInGrid = firstIndexInGrid;
    this.lastIndexInGrid = lastIndexInGrid === undefined ? this.lastIndexInGrid : lastIndexInGrid;
    if (this.gridForm === FormIndex.DAY) {
      // 更新日视图首个可见宫格
      this.gridStateManager.getFirstIndexManager(this.gridForm).updateState(firstIndexInGrid, this.tag);
    }
    if (this.gridStateManager.config.isSupportShowTimeInTitle) {
      this.updateCurrentTime(firstIndexInGrid);
    }
  }

  /**
   * 更新当前视图的首张可见图片时间
   *
   * @param firstThumbnailIndex 首张可见图片index
   */
  protected updateCurrentTime(firstThumbnailIndex: number): void {
    if (!this.gridStateManager.config.isSupportShowTimeInTitle) {
      return;
    }
    if (!this.isInCurrentForm()) {
      return;
    }
    this.handleUpdateCurrentTime(firstThumbnailIndex);
  }

  /**
   * 供子类实现更新标题时间逻辑，处理index转换额外操作如地点生成等
   *
   * @param firstThumbnailIndex 首张可见图片index
   */
  protected abstract handleUpdateCurrentTime(firstThumbnailIndex: number): void;

  /**
   * 设置当前视图的首张可见图片时间
   *
   * @param firIndexDateTaken 首张可见图片时间
   */
  protected setCurrentTime(firIndexDateTaken: number): void {
    if (!firIndexDateTaken) {
      this.currentTime = '';
      this.firIndexDateTaken = firIndexDateTaken;
      return;
    }
    this.firIndexDateTaken = firIndexDateTaken;
    this.handleSetCurrentTime(firIndexDateTaken);
  }

  /**
   * 供子类实现设置当前标题图片时间处理逻辑，定制格式化字符串等
   *
   * @param firIndexDateTaken 首张可见图片时间
   */
  protected abstract handleSetCurrentTime(firIndexDateTaken: number): void;

  /**
   * 开始查找地址
   *
   * @param findAddressParam 查找参数
   */
  protected startFindAddress(findAddressParam: FindAddressParam): void {
    this.titleBarStateManager.findAddressThrottle.run((findParam) => {
      this.findAddress(findParam);
    }, findAddressParam)
  }

  /**
   * 大图占位变化更新回调
   *
   * @param uniqueId 变化的item的uniqueId
   * @param isTap 是否tap, 为true时隐藏宫格
   */
  protected onPlaceholderChange(uniqueId: string, isTap: boolean): void {
  }

  /**
   * 更新宫格滚动状态
   *
   * @param isScrolling 是否滚动中
   */
  private updateScrollState(isScrolling: boolean): void {
    this.scrollerStateManager.getScrollerScrollingAsm(this.gridForm).updateState(isScrolling, this.tag);
    this.stateProxy.timeController?.startScrollerCapsuleAnimation(!isScrolling,
      this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm),
      this.gridObserverProxy.getIsImmersive(), convertToMViewType(this.gridForm));
  }

  /**
   * 获取地址详细信息
   * @param dataIndex
   * @returns subLocalityAddress
   */
  private async loadSubLocalityAddress(dataIndex: number): Promise<string> {
    try {
      return (await this.firstAddressMediaItem?.getSubLocalityStatic()) ?? '';
    } catch (e) {
      LogUtils.error(this.tag, `getSubLocalityStatic error at index ${dataIndex}: ${e?.message}`, e?.stack);
      return '';
    }
  }

  private async findAddress(findAddressParam: FindAddressParam): Promise<void> {
    if (OperateStateTypeUtils.isInSelectState(this.getOperateState())) {
      this.stateProxy.titleBarStateManager.subTitleContentAsm.updateState('');
      LogUtils.info(this.tag, `findAddress ignore, isSelectedMode`);
      return;
    }
    for (let i = 0; i < findAddressParam.columnCount; i++) {
      let dataIndex: number = findAddressParam.firstIndex + i;
      let subLocalityAddress: string = '';
      this.firstAddressMediaItem = this.dayDataSource?.getMediaItemByPosition(dataIndex);
      if (this.firstAddressMediaItem) {
        if (this.isNeedResetSubLocalityAddress) {
          this.firstAddressMediaItem.resetSubLocalityAddress();
        }
        subLocalityAddress = await this.loadSubLocalityAddress(dataIndex);
      } else {
        // 拖动滚动条时滑窗不更新，会导致获取不到对应Index的MediaItem，此时获取SimpleGridMediaItem
        LogUtils.info(this.tag, `findAddress from SimpleGridMediaItem:${dataIndex}`);
      }
      if (findAddressParam.formIndex != this.currentForm) {
        LogUtils.info(this.tag, `findAddress form change ${findAddressParam.formIndex}->${this.currentForm}`);
        return;
      }
      if (subLocalityAddress?.length > 0) {
        this.stateProxy.titleBarStateManager.subTitleContentAsm.updateState(subLocalityAddress);
        LogUtils.info(this.tag, 'findAddress subLocalityAddress is not empty');
        return;
      }
    }
    this.stateProxy.titleBarStateManager.subTitleContentAsm.updateState('');
    LogUtils.info(this.tag, `findAddress fail, ${this.dayDataSource?.getMediaItemByPosition(
      findAddressParam.firstIndex)?.uri}, ${findAddressParam.firstIndex}`);
  }

  private setDuringScroll(isScrolling: boolean): void {
  }

  protected updateCachedCount(): void {
    const isUseOriginal = !this.isScrollerBarScrolling && !this.gridObserverProxy.getIsSwitching() &&
      !this.displayObserverProxy.getIsGridResize();
    this.gridStateManager.getCachedCountManager(this.gridForm).updateState(
      isUseOriginal ? this.gridObserverProxy.getOriginalCachedCount(this.gridForm) : 0, this.tag);
  }

  private refreshShowAndHidden(curOffset: number): void {
    let tempHeight: number = this.gridObserverProxy.getHeadMsgHeight() - curOffset;
    if (tempHeight > this.maxRefreshHeight) {
      tempHeight = this.maxRefreshHeight;
    } else if (tempHeight < this.minRefreshHeight) {
      tempHeight = this.minRefreshHeight;
    }
    this.updateHeadMsgHeight(tempHeight);
  }

  private updateScrollOffset(newValue: number): void {
    if (this.gridObserverProxy.getIsSwitching()) {
      // 切换过程中，不支持宫格主动滚动
      return;
    }
    this.gridStateManager.getScrollOffsetManager(this.gridForm).updateState(newValue, ScrollReason.DEFAULT);
  }

  private updateHeadMsgHeight(headMsgHeight: number): void {
    this.gridStateManager.updateIrregularTypeHeight(IrregularType.HEAD_MSG, headMsgHeight, this.tag);
    this.gridStateManager.headMsgPullDownAsm.updateState(this.getPullDownState(headMsgHeight), this.tag);
  }

  private refreshHeadMsgHeight(): void {
    const oldMaxRefreshHeight = this.maxRefreshHeight;
    // 更新阈值
    this.minRefreshHeight = this.titleBarObserverProxy.getTitleBarHeight();
    this.maxRefreshHeight = this.minRefreshHeight + this.gridObserverProxy.getHeadMsgPullDownHeight();
    if (!this.isInCurrentForm() && this.currentForm !== FormIndex.INVALID) {
      // 非当前页不更新消息头高度
      return;
    }

    // 更新消息头高度
    const currentMsgHeight = this.gridObserverProxy.getHeadMsgHeight();
    if (currentMsgHeight <= 0 || this.currentForm === FormIndex.INVALID ||
      !this.gridObserverProxy.config.isSupportHeadMsg) {
      this.updateHeadMsgHeight(this.minRefreshHeight);
    } else if (currentMsgHeight >= oldMaxRefreshHeight) {
      // 原来是完整可见时，窗口旋转后才能完整可见，否则取消下来态
      this.updateHeadMsgHeight(this.maxRefreshHeight);
    } else {
      this.updateHeadMsgHeight(this.minRefreshHeight);
    }
  }

  private getPullDownState(headMsgHeight: number): PullDownState {
    if (headMsgHeight >= this.maxRefreshHeight) {
      return PullDownState.FULL;
    } else if (headMsgHeight <= this.minRefreshHeight) {
      return PullDownState.NONE;
    } else {
      return PullDownState.PARTIAL;
    }
  }

  private getGridOffset(gridIndex: number): number {
    if (gridIndex === this.onScrollBarUpdateCachedIndex && !DeviceInfo.isFoldable()) {
      return this.onScrollBarUpdateCachedOffset;
    }
    const calcOffset = SwitchCommonUtils.calcGridOffset(gridIndex, this, this.gridForm);
    LogUtils.debug(this.tag, `getGridOffset gridIndex: ${gridIndex}, calcOffset: ${calcOffset}`);
    this.onScrollBarUpdateCachedIndex = gridIndex;
    this.onScrollBarUpdateCachedOffset = calcOffset;
    return calcOffset;
  }

  private recordScrollInfoBeforeSizeChange(): void {
    if (!this.isInCurrentForm()) {
      return;
    }
    LogUtils.info(this.tag, 'GRID_SWITCH recordScrollInfoBeforeSizeChange');
    this.startInfo = SwitchStartUtils.buildButtonSwitchStartInfo(this);
  }

  private updateScrollOffsetWhenSizeChange(): void {
    if (!this.isInCurrentForm()) {
      return;
    }
    if (!this.startInfo) {
      LogUtils.warn(this.tag, 'updateScrollOffsetWhenSizeChange switchInfo no exist.');
      return;
    }

    // 清除补位信息
    this.gridStateManager.getFillPositionManager(this.gridForm).updateState(0, this.tag);

    // 计算滚动信息
    const scrollOffset = SwitchCalcUtils.calcScrollOffset(this.startInfo, this.gridForm, this, 0, AlignMode.TOP);

    // 更新滚动距离
    this.gridStateManager.getScrollOffsetManager(this.gridForm).updateState(scrollOffset, ScrollReason.SIZE_CHANGE);
    LogUtils.info(this.tag, `GRID_SWITCH updateScrollOffsetWhenSizeChange: ${scrollOffset}`);

    // 清除切换前信息
    this.startInfo = undefined;
  }

  private observerAndUpdateHeight(): void {
    // 宫格总高度
    this.gridObserverProxy.getIrregularHeight(this.gridForm, () => this.updateTotalHeight(true));
    this.gridObserverProxy.getGridHeight(this.gridForm, () => this.updateTotalHeight(true));
    this.gridObserverProxy.getBottomHeight(() => this.updateTotalHeight(false));

    // 显示区域高度
    this.displayObserverProxy.getGridAreaSize((_oldState, newSize) => {
      this.gridAreaHeight = newSize.height;
      this.updateSwitchHidToBottom();
    });

    // 监听显示模式
    this.switchObserverProxy.getSwitchMode(() => this.updateSwitchHidToBottom());

    // 宫格是否在前台监听
    this.displayObserverProxy.getIsGridActive(() => this.updateSwitchHidToBottom());
  }

  private updateTotalHeight(updateSwitchToBottom: boolean): void {
    this.totalHeight = this.gridObserverProxy.getIrregularHeight(this.gridForm) +
    this.gridObserverProxy.getGridHeight(this.gridForm) + this.gridObserverProxy.getBottomHeight();
    if (updateSwitchToBottom) {
      this.updateSwitchHidToBottom();
    }
  }

  private updateSwitchHidToBottom(scrollOffset?: number): void {
    if (!this.isInCurrentForm() || this.gridObserverProxy.getIsSwitching() ||
      !this.displayObserverProxy.getIsGridActive()) {
      // 非当前形态或者形态切换中时，不触发显隐变化
      return;
    }

    if (this.switchObserverProxy.getSwitchMode() !== SwitchMode.ONLY_BOTTOM_SHOW) {
      this.switchStateManager.switchHidToBottomAsm.updateState(false, SwitchShowUpdateReason.INNER_REASON);
      return;
    }

    const offset = scrollOffset ?? this.gridObserverProxy.getScrollOffset(this.gridForm);
    const isHidToBottom = this.switchObserverProxy.getSwitchIsHidToBottom();
    const leftScrollHeight = this.getLeftScrollHeight(offset);
    LogUtils.info(this.tag, `isHidToBottom: ${isHidToBottom} leftScrollHeight: ${leftScrollHeight}`);
    if (isHidToBottom && (leftScrollHeight < ENTER_REACH_END_HEIGHT)) {
      this.switchStateManager.switchHidToBottomAsm.updateState(false, SwitchShowUpdateReason.INNER_REASON);
    } else if (!isHidToBottom && (leftScrollHeight > EXIT_REACH_END_HEIGHT)) {
      this.switchStateManager.switchHidToBottomAsm.updateState(true, SwitchShowUpdateReason.INNER_REASON);
    }
  }

  private getLeftScrollHeight(scrollOffset: number): number {
    return this.gridObserverProxy.getIrregularHeight(this.gridForm) +
    this.gridObserverProxy.getGridHeight(this.gridForm) - this.gridAreaHeight - scrollOffset;
  }

  private updateCloudSync(): void {
    let isSyncing: boolean | undefined = AppStorage.get<boolean>(Constants.APP_STORAGE_KEY_IS_SYNCING);
    if (this.gridObserverProxy.config.isSupportHeadMsg && this.gridObserverProxy.getScrollOffset(this.gridForm) <= 0) {
      const msg: Record<string, number | string | boolean> = { 'time': new Date().toISOString() };
      ReportToBigDataUtil.report(BigDataConstants.TOUCH_DOWN_START_SYNC, msg);
    }
  }

  protected backToTop(): void {
    if (!this.isInCurrentForm()) {
      return;
    }
    this.triggerPreloadViewData(0, ScrollReason.STATUS_BAR);
    this.backToTopDelay = setTimeout(() => {
      if (!this.isInCurrentForm()) {
        return;
      }
      this.getScroller().scrollEdge(Edge.Top);
    }, Constants.DELAY_TENTH_SECOND);
  }

  protected autoUpdateHeadMsgHeight(scrollOffset: number): number {
    if (!this.gridObserverProxy.config.isSupportHeadMsg || scrollOffset <= 0) {
      return 0;
    }
    // 抵消距离
    const offset = this.gridObserverProxy.getHeadMsgHeight() - this.minRefreshHeight;
    if (offset > 0) {
      this.updateHeadMsgHeight(this.minRefreshHeight);
    }
    return offset;
  }
}