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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { GridDragScrollBaseHelper } from '@ohos/common/src/main/ets/default/utils/GridDragScrollBaseHelper';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { TimelineScrollBarManager } from '@ohos/common/src/main/ets/default/model/common/TimelineScrollBarManager';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { TimeLineModelManager } from '@ohos/common/src/main/ets/default/view/TimeLineModelManager';
import lazy { YearMonthGroupInfo } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy display from '@ohos.display';
import lazy { AttributeUpdater } from '@kit.ArkUI';
import lazy { GridStateProxy } from '../../statemanager/GridStateProxy';
import lazy { GridScrollBarVm } from '../../viewmodel/GridScrollBarVm';
import lazy { FormIndex } from '../../statemanager/constants/GridDefine';
import lazy { GridStateObserverProxy } from '../../statemanager/GridStateObserverProxy';
import lazy { OperateStateTypeUtils } from '../../statemanager/GridOperateFsm';
import lazy {
  ReportToBigDataUtil,
  AlbumBrowsingInfo,
  BigDataConstants,
  Scenario,
  PhotoInfo
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil'
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { SwitchCalcUtils } from '../../viewmodel/utils/SwitchCalcUtils';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import { TimelineDataSourceManager } from '../../../model/TimelineDataSourceManager';

const TAG: string = 'timeline_GridScrollBarView';
const MAX_FONT_SCALE: number = 1.0;
const SCROLLBAR_EDGE_SCALE: number = 20;
const MAX_EDGE_OFFSET: number = 250;
const MAX_SCALE_OFFSET: number = 200;
const SCALE_VERTICAL_PADDING: number = 80;
const SCALE_HORIZONTAL_PADDING: number = 100;
const SCROLLBAR_EDGE_SNAP_THRESHOLD: number = 24;

/**
 * 日期胶囊
 */
interface DateCapsule {
  gap: number;
  yearTime: string;
  top?: number;
};

@Component
export struct GridScrollBarView {
  persistentId: number = 0;
  public gridForm: FormIndex = FormIndex.INVALID;
  scroller: Scroller | undefined = undefined;
  gridDragScrollHelper?: GridDragScrollBaseHelper;
  dataSourceProxy?: AlbumDataSource;
  dataSource?: AlbumDataSource | null;
  @StorageLink(Constants.FOLD_DISPLAY_MODE) private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @Consume @Watch('updateTotalNum') yearData: TimelineData[];
  @State isClickScrollBar: boolean = false;
  @Consume dateText: string;
  @Consume broadCast: BroadCast;
  @State totalNum: number = 0;
  moveStartY: number = -1; //侧边栏滚动条的开始坐标值
  moveEndY: number = -1; //侧边栏滚动条的结束坐标值
  changedNum: number = 0; //起始与结束滑动的改变值
  isMovedFlag: Boolean = false; //判定为滑动的标志
  // 宫格高度
  @State @Watch('updateBottomArr') gridHeight: number = 0;
  private currentScrollerHeight: number = 0;
  @State isOpenYearMonthDay: boolean | undefined =
    AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine();
  @State @Watch('onScrollBarTouchChange') isScrollerBarTouch: boolean = false;
  // 滚动条下限位
  @State paddingBottom: number = 0;
  @Link paddingTop: number;
  @Prop scrollBarPaddingTop: number;
  @State private gridRowCount: number = 4;
  // 滚动条左侧固定时间胶囊分布
  @State bottomArr: DateCapsule[] = [];
  @State allRowNum: number = -1;
  @Consume yearMonthData: TimelineData[];
  @State @Watch('currentOffsetChange') private currentOffset: number = 0;
  // 日视图缩略图高度
  @State imageGridItemHeight: number = 0;
  private timeTitleHeight: number = 0;
  @State newDateText: string = '';
  @Link segmentHeight: number;
  @Link @Watch('isImmersiveChange') isImmersive: boolean;
  private dateYearMonthRowMap: Map<number, string> = new Map();
  private defaultOffsetOfBigCapsule: number = 0;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  private yearGridScrollBarViewManager: TimelineScrollBarManager = new TimelineScrollBarManager();
  private yearMonthGridScrollBarViewManager: TimelineScrollBarManager = new TimelineScrollBarManager();
  private bigHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_big_height')));
  private textHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_side_text_height')));
  private paddingStart: number = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level8')));
  private timerId: number = -1;
  private intervalTime: number = 100;
  private actionBarHeight: number = 0;
  @Link isScrollByScrollBar: boolean;
  @StorageProp('yearGroupInfo') private yearGroupInfo: YearMonthGroupInfo[] = [];
  @StorageProp('yearMonthGroupInfo') private yearMonthGroupInfo: YearMonthGroupInfo[] = [];
  private readonly scrollBarElemId: string = 'GridScrollBarView';
  @State timeController: TimeController = new TimeController();
  // 选择模式底部toolbar高度
  @State isSelectedMode: boolean = false;
  @StorageLink('currentLanguage') @Watch('updateCurrentLanguage') currentLanguage: string | undefined = undefined;
  public attributeUpdater?: AttributeUpdater<CommonAttribute>;
  private capsulesTimeValue: string = '';
  private smallScrollBarWidth: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('app.float.scroll_bar_small_width')));
  private responseRegionX: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('app.float.scroll_press_all_width'))) -
    this.smallScrollBarWidth;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  private onUpdateYearFunc: Function = (yearGroupInfo: YearMonthGroupInfo[]): void =>
  this.onUpdateYearDate(yearGroupInfo);
  private onUpdateMonthFunc: Function = (yearMonthGroupInfo: YearMonthGroupInfo[]): void =>
  this.onUpdateMonthDate(yearMonthGroupInfo);
  // 宫格滚动视图模型
  private gridScrollBarVm: GridScrollBarVm | undefined;
  private isGridScrollVisible: boolean = true;
  private isStateDirty: boolean = false;
  private readonly observerProxy: GridStateObserverProxy = new GridStateObserverProxy();
  @State scrollToEdgeScaleRatio: number = 1;
  private maxGridHeight: number = 0;

  private eachRowHeight: number = this.gridForm === FormIndex.DAY ?
    this.imageGridItemHeight ?? 0 + Constants.GRID_GUTTER : this.imageGridItemHeight ?? 0;
  private gridOffsets: number = this.allRowNum * this.eachRowHeight;
  private gridAllOffset: number = this.gridOffsets - this.gridHeight + this.actionBarHeight;;
  private currentViewOffset: number = this.currentOffset;
  private scrollOffset: number = (this.currentViewOffset / this.gridAllOffset) * (this.currentScrollerHeight - this.bigHeight);
  private capsulesTime: string = '';

  /**
   * currentLanguage发生变化时候触发
   */
  private updateCurrentLanguage(): void {
    this.getYearMonthDateCapsule(this.yearMonthGroupInfo);
    this.getDateCapsule(this.yearGroupInfo);
  }

  private onScrollBarTouchChange(): void {
    this.getCapsulesTime()
    this.gridScrollBarVm?.updateScrollerBarTouchState(this.isScrollerBarTouch);
  }

  /**
   * 滚动条paddingBottom改变时需要重新计算左侧时间胶囊位置以及时间跟行数的Map
   *
   */
  private updateScrollBarPaddingBottom(): void {
    let paddingBottom: number =  this.observerProxy.displayObserverProxy.getBottomAvoidHeight();
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      paddingBottom = Constants.ToolBarHeight;
    }
    if (paddingBottom !== this.paddingBottom) {
      this.paddingBottom = paddingBottom;
      this.currentScrollerHeight = this.gridHeight - this.actionBarHeight - this.paddingBottom;
    }
  }

  /**
   * 点击宫格照片进大图时隐藏滚动条上的时间胶囊，防止进大图动效抖动
   *
   */
  private onUpdateScrollerOpacity(): void {
    this.timeController?.updateScrollerOpacity();
  }

  aboutToAppear(): void {
    this.currentLanguage = i18n.System.getSystemLanguage();
    this.updateTotalNum();
    this.countOrHeightChange();
    this.updateScrollBarPaddingBottom();
    this.isImmersiveChange();
    this.broadCast.on(BroadCastConstants.JUMP_TO_PHOTO_BROWSER, this.onUpdateScrollerOpacity);
    this.appBroadCast.on(BroadCastConstants.YEAR_UPDATE, this.onUpdateYearFunc);
    this.appBroadCast.on(BroadCastConstants.MONTH_UPDATE, this.onUpdateMonthFunc);
    this.timeController = GridStateProxy.getInstance(this.persistentId).timeController ?? new TimeController();
    this.gridScrollBarVm = new GridScrollBarVm(this.gridForm);
    this.gridScrollBarVm.init(this.persistentId);
    this.observerProxy.init(this.persistentId);
    this.observerProxy.getOperateState((_oldState, newState) => {
      this.isSelectedMode = OperateStateTypeUtils.isInSelectState(newState);
    });
    this.initCapsuleObserver();
  }

  private initCapsuleObserver(): void {
    this.observerProxy.displayObserverProxy.getGridAreaSize((_oldState, newSize) => {
      Log.info(TAG, `grid area change ${newSize.height}`);
      if (this.gridHeight !== newSize.height) {
        this.gridHeight = newSize.height;
      }
    });
    this.observerProxy.displayObserverProxy.getBottomAvoidHeight(() => this.updateScrollBarPaddingBottom());
    this.observerProxy.titleBarObserverProxy.getTitleBarHeight(() => this.updateActionBarHeight());
    this.observerProxy.gridObserverProxy.getGridImageHeight(this.gridForm, (_oldState, newState) => {
      this.imageGridItemHeight = newState;
    });

    this.observerProxy.gridObserverProxy.getGroupTitleHeight((_oldState, newState) => this.timeTitleHeight = newState);

    this.observerProxy.gridObserverProxy.getGridColumn(this.gridForm, (_oldState, newState) => {
      this.gridRowCount = newState;
      this.updateTotalNum();
    });
    this.observerProxy.gridObserverProxy.getGridHeight(this.gridForm, (_oldState, newState) => {
      this.maxGridHeight = newState;
    });
    this.observerProxy.gridObserverProxy.getScrollOffset(this.gridForm, (_oldState, newState) => {
      this.currentOffset = newState;
    });
    this.observerProxy.gridObserverProxy.getGirdVisibleState((_oldState, newState) => {
      this.isGridScrollVisible = newState;
      if (this.isGridScrollVisible && this.isStateDirty) {
        this.countOrHeightChange();
      }
    });
  }

  private updateActionBarHeight(): void {
    this.actionBarHeight = this.observerProxy.titleBarObserverProxy.getTitleBarHeight();
  }

  getCapsulesTime(){
    if (this.gridForm === FormIndex.GROUP_DAY) {
      this.capsulesTime = this.getGroupDayScrollTime(this.scrollOffset, this.currentOffset);
    } else if (this.gridForm === FormIndex.DAY) {
      this.capsulesTime = this.getDayScrollTime(this.scrollOffset, this.currentOffset);
    }
    if (this.capsulesTime) {
      this.newDateText = this.capsulesTime;
    } else {
      this.newDateText = '';
    }
  }

  /**
   * 滚动偏移量发生变化时触发-计算出当前行对应的年月
   */
  currentOffsetChange(): void {
    // 宫格可偏移的最大值
    if (this.gridForm === FormIndex.DAY) {
      this.eachRowHeight = this.imageGridItemHeight ?? 0 + Constants.GRID_GUTTER;
    } else {
      this.eachRowHeight = this.imageGridItemHeight ?? 0;
    }
    this.gridOffsets = this.allRowNum * this.eachRowHeight;
    this.gridAllOffset = this.gridOffsets - this.gridHeight + this.actionBarHeight;
    this.currentViewOffset = this.currentOffset;
    // 游标的偏移量（(宫格偏移量 / 宫格可偏移的最大值) * srcollbar可偏移的最大值） 当前计算存在一定偏差待后续优化
    this.scrollOffset = (this.currentViewOffset / this.gridAllOffset) * (this.currentScrollerHeight - this.bigHeight);
    // 总偏移量(宫格偏移量 + 年月胶囊初始偏移量 + 游标的偏移量)
    let screenHeight: number = px2vp(getScreen().getDisScreenHeight());
    let scrollToBottomHeight: number = this.isHorizontal ?
      this.bigHeight + this.paddingBottom + SCALE_HORIZONTAL_PADDING : this.bigHeight + this.paddingBottom + SCALE_VERTICAL_PADDING;
    if (this.currentOffset < 0) {
      this.scrollToEdgeScaleRatio = Math.max(this.currentOffset, - MAX_SCALE_OFFSET) / MAX_EDGE_OFFSET;
    } else if (this.currentOffset + screenHeight - scrollToBottomHeight > this.maxGridHeight){
      this.scrollToEdgeScaleRatio = Math.min(this.currentOffset + screenHeight - scrollToBottomHeight - this.maxGridHeight, MAX_SCALE_OFFSET) / MAX_EDGE_OFFSET;
    } else {
      this.scrollToEdgeScaleRatio = 1;
    }
    if (!this.isClickScrollBar){
      return ;
    }
    if (this.gridForm === FormIndex.GROUP_DAY) {
      this.capsulesTime = this.getGroupDayScrollTime(this.scrollOffset, this.currentOffset);
    } else if (this.gridForm === FormIndex.DAY) {
      this.capsulesTime = this.getDayScrollTime(this.scrollOffset, this.currentOffset);
    }
    // 只有胶囊日期变化时再打印，防止高频打印
    if (this.capsulesTimeValue !== this.capsulesTime) {
      this.capsulesTimeValue = this.capsulesTime;
      Log.info(TAG, `currentOffsetChange:${this.gridForm}, ${this.currentOffset}` +
        `, ${this.allRowNum}, ${this.defaultOffsetOfBigCapsule}` +
        `, ${this.gridHeight}, ${this.imageGridItemHeight}, ${this.capsulesTime}`);
    }
    if (this.capsulesTime) {
      this.newDateText = this.capsulesTime;
    } else {
      this.newDateText = '';
    }
  }

  /**
   * 日视图四宫格滚动条左侧对应的时间胶囊
   *
   * @param scrollOffset 当前scrollbar滚动距离
   * @param currentOffset 当前视图滚动距离
   * @returns 当前胶囊时间
   */
  getDayScrollTime(scrollOffset: number, currentOffset: number): string {
    let currentIndex = SwitchCalcUtils.calcFirstIndex(this.gridForm, this.observerProxy, currentOffset + scrollOffset);
    let maxMediaCount: number = this.dataSource?.totalCount() ?? 0;
    if (currentIndex >= maxMediaCount) {
      // 总数量求余获取最后一个图片index
      currentIndex = maxMediaCount - 1;
    }
    let groupIndex: number = this.dataSource?.getGroupIndexByDataIndex(currentIndex) as number;
    let group = this.dataSource?.getGroupData()[groupIndex];
    if (!group?.startDate) {
      Log.warn(TAG, `getDayScrollTime: empty startDate`);
      return '';
    }
    let capsulesTimeValue: string = DateUtil.getLocalizedYearAndMonth(group?.startDate ?? 0);
    Log.debug(TAG, `getDayScrollTime:${this.gridRowCount},currentIndex:${currentIndex},offset:${this.currentOffset}` +
     `,${scrollOffset}, groupIndex:${groupIndex}, ${this.currentScrollerHeight}`);
    return capsulesTimeValue;
  }

  /**
   * 日视图三宫格滚动条左侧对应的时间胶囊
   *
   * @param scrollOffset 当前scrollbar滚动距离
   * @param currentOffset 当前视图滚动距离
   * @returns 当前胶囊时间
   */
  getGroupDayScrollTime(scrollOffset: number, currentOffset: number): string {
    let currentIndex = SwitchCalcUtils.calcFirstIndex(this.gridForm, this.observerProxy, currentOffset + scrollOffset);
    let maxMediaCount: number = this.dataSource?.totalCount() ?? 0;
    if (currentIndex >= maxMediaCount) {
      // 总数量求余获取最后一个图片index
      currentIndex = maxMediaCount - 1;
    }
    let currentGroupIndex = this.dataSourceProxy?.getGroupIndexByDataIndex(currentIndex) as number;
    let currentTimeline: TimelineData | undefined = this.dataSourceProxy?.indexesToGroup(currentGroupIndex);
    if (!currentTimeline?.startDate) {
      Log.warn(TAG, `getGroupDayScrollTime: empty startDate`);
      return '';
    }
    let capsulesTimeValue: string = DateUtil.getLocalizedYearAndMonth(currentTimeline?.startDate ?? 0);
    Log.debug(TAG, `getGroupDayScrollTime:${currentIndex} ${currentGroupIndex} ${capsulesTimeValue}`);
    return capsulesTimeValue;
  }

  /**
   * 沉浸式改变-计算出当前宫格相对于年月胶囊的偏移量
   */
  isImmersiveChange() {
    if (this.isImmersive) {
      // 沉浸式
      if (this.isHorizontal) {
        // 年月胶囊偏移量 + 整个scrollbar的上margin
        this.defaultOffsetOfBigCapsule = (this.bigHeight - this.textHeight) / 2 + this.paddingStart;
      } else {
        // 年月胶囊偏移量 + 整个scrollbar的上margin + 状态栏高度
        this.defaultOffsetOfBigCapsule = (this.bigHeight - this.textHeight) /
          2 + this.paddingStart + px2vp(this.statusBarHeight);
      }
    } else {
      // 非沉浸式
      // 年月胶囊偏移量
      this.defaultOffsetOfBigCapsule = (this.bigHeight - this.textHeight) / 2;
    }
    Log.info(TAG, `defaultOffsetOfBigCapsule: ${this.defaultOffsetOfBigCapsule}-${
    this.paddingStart}-${px2vp(this.statusBarHeight)}`);
  }

  /**
   * 获取年胶囊数据分布
   * @param yearGroupInfo 年胶囊数据
   */
  getDateCapsule(yearGroupInfo: YearMonthGroupInfo[]): void {
    if (!this.isGridScrollVisible) {
      this.isStateDirty = true;
      return;
    }
    let yearDataTmp: string = JSON.stringify(yearGroupInfo);
    let marginTopTmp = (this.bigHeight - this.textHeight) / 2;
    let smallDateCapsuleHeight = px2vp(UiUtil.getResourceNumber($r('app.float.scroll_bar_side_text_height_small')));
    // 分组视图需要考虑每个分组日期标题所占行数，需要单独计算年份分布gap
    if (this.gridForm === FormIndex.GROUP_DAY) {
      let totalCount: number = this.dataSource?.totalCount() ?? 0;
      let groups: TimelineData[] = TimelineDataSourceManager.getInstance().getDataSource()?.groups;
      // let groups: TimelineData[] = this.dataSource?.getGroupData() ?? [];
      this.yearGridScrollBarViewManager.setIsGroupView(true);
      this.yearGridScrollBarViewManager.setTotalCount(totalCount);
      this.yearGridScrollBarViewManager.setGroups(groups);
      this.yearGridScrollBarViewManager.setTimeTitleHeight(this.timeTitleHeight);
      this.yearGridScrollBarViewManager.setImageGridItemHeight(this.imageGridItemHeight);
    }
    Log.info(TAG, `getDateCapsule:${this.allRowNum}-${this.gridRowCount}-${this.currentScrollerHeight}` +
      `-${marginTopTmp}-${smallDateCapsuleHeight}, gridForm:${this.gridForm} ${yearDataTmp}`);
    this.yearGridScrollBarViewManager.setParams(yearDataTmp, this.allRowNum, this.gridRowCount,
      this.currentScrollerHeight, this.bigHeight, marginTopTmp, smallDateCapsuleHeight);
    this.yearGridScrollBarViewManager.dateYearDataTask().then((res: DateCapsule[] | void): void => {
      if (res) {
        this.bottomArr = res;
        Log.info(TAG, `getDateCapsule:${JSON.stringify(this.bottomArr)}`);
      }
    })
    this.isStateDirty = false;
  }

  /**
   * 获取每行对应年月数据的map
   * @param yearMonthGroupInfo 年月胶囊数据
   */
  getYearMonthDateCapsule(yearMonthGroupInfo: YearMonthGroupInfo[]): void {
    if (!this.isGridScrollVisible) {
      this.isStateDirty = true;
      return;
    }
    let yearMonthDataTmp: string = JSON.stringify(yearMonthGroupInfo);
    Log.info(TAG, `getYearMonthDateCapsule-${this.allRowNum}-${this.gridRowCount}-${this.currentScrollerHeight}` +
      `, ${this.bigHeight}, ${yearMonthDataTmp}`);
    this.yearMonthGridScrollBarViewManager.setParams(yearMonthDataTmp, this.allRowNum,
      this.gridRowCount, this.currentScrollerHeight, this.bigHeight);
    this.yearMonthGridScrollBarViewManager.dateYearMonthDataTask().then((res: Map<number, string> | void): void => {
      if (res) {
        this.dateYearMonthRowMap = res;
      }
    })
    this.isStateDirty = false;
  }

  /**
   * 照片数量及宫格可视区域高度变化时触发
   */
  countOrHeightChange(): void {
    Log.info(TAG, 'countOrHeightChangeInit');
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
    this.timerId = setTimeout((): void => {
      Log.info(TAG, 'countOrHeightChange-setTimeout');
      this.currentScrollerHeight = this.gridHeight - this.actionBarHeight - this.paddingBottom;
      this.bottomArr = [];
      // 年胶囊数据
      this.getDateCapsule(this.yearGroupInfo);
      // 年月胶囊数据
      this.getYearMonthDateCapsule(this.yearMonthGroupInfo);
    }, this.intervalTime);
  }

  /**
   * yearData发生变化时候触发
   */
  updateTotalNum(yearGroupInfo?: YearMonthGroupInfo[]): void {
    let totalCount = 0;
    if (yearGroupInfo) {
      for (let year of yearGroupInfo) {
        totalCount = totalCount + (year.count as number);
      }
    } else {
      for (let year of this.yearGroupInfo) {
        totalCount = totalCount + (year.count as number);
      }
    }
    this.totalNum = totalCount;
    this.allRowNum = Math.ceil(totalCount / this.gridRowCount);
  }

  /**
   * 更新滚动条左侧固定时间胶囊位置
   */
  private updateBottomArr(): void {
    this.updateTotalNum();
    this.countOrHeightChange();
  }

  private getTimelineScrollerCapsulesOpacity(): number {
    if (!this.gridScrollBarVm?.getDateCapsuleEnable()) {
      return Constants.TRANSPARENT;
    }
    this.gridScrollBarVm?.onGetTimelineScrollerOpacity(this.timeController.timelineScrollerLeftCapsulesOpacity);
    return this.timeController.timelineScrollerLeftCapsulesOpacity;
  }

  private handleTouchEvent(event: TouchEvent): void {
    AppStorage.setOrCreate<boolean>('isTouchScrollBar', true);
    this.isScrollByScrollBar = true;
    if (event.type === TouchType.Down) {
      // isScrollerBarTouch为true时会显示年份胶囊，选择模式时点击滚动条附近区域会误触发滚动条显示导致年份胶囊显示
      if (!this.isSelectedMode) {
        this.isScrollerBarTouch = true;
      }
      Log.info(TAG, `handleTouchEvent scrollBar Down isSelectedMode:${this.isSelectedMode}` +
        `, isScrollerBarTouch:${this.isScrollerBarTouch}`);
      if (UiUtil.isScrollBarVisible(this.scrollBarElemId)) {
        this.isScrollerBarTouch = true;
      }
      this.gridDragScrollHelper?.handleScrollStart();
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      // 按下滚动条后不离手直接xxx幕会触发Cancel事件，此时需要更新滚动条按压标志，防止isScrollerBarTouch一直为true节点点击不响应跳转大图逻辑
      this.isScrollerBarTouch = false;
      this.gridDragScrollHelper?.handleScrollStop();
    }
    this.updateMovePosition(event);
    if (!this.dateText) {
      Log.debug(TAG, 'dateText is null');
      this.broadCast.emit(BroadCastConstants.INIT_DATE_TEXT, []);
    }
    //当前后滑动的差值大于0
    if (this.moveStartY !== -1 && this.moveEndY !== -1 && !this.isMovedFlag) {
      this.changedNum = Math.abs(this.moveStartY - this.moveEndY);
      if (this.changedNum > 0) {
        this.isMovedFlag = true;
      }
    }
    if (event.type === TouchType.Move && !this.isClickScrollBar && this.isMovedFlag) {
      Log.info(TAG, 'handleTouchEvent scrollBar first TouchType.Move');
      this.isClickScrollBar = true;
      AppStorage.setOrCreate<boolean>(Constants.SCROLL_BAR_CLICKING, this.isClickScrollBar);
      // 选择模式时手指按下滚动条时为了防止影响选择框不显示滚动条，因此拖动滚动条时需要更新变量状态跟随滚动条显示年胶囊
      if (this.isSelectedMode) {
        this.isScrollerBarTouch = true;
      }
      let scenario = ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex);
      const msg: Record<string, number | string | boolean> = {
        'browserEvent': 'scrollBarBrowse',
        'viewType': this.gridForm,
        'scenario': scenario,
      };
      if (scenario === Scenario.ALBUM_PAGE) {
        msg['subAlbumType'] = AlbumBrowsingInfo.albumSubtype;
      }
      ReportToBigDataUtil.report(BigDataConstants.SCROLL_BAR_BROWSE, msg);
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.alignGridToScrollbarEdge();
      AppStorage.setOrCreate<boolean>('isTouchScrollBar', false);
      this.isMovedFlag = false;
      this.moveStartY = -1;
      this.moveEndY = -1;
      // isClickScrollBar为false时会显示小滚动条，选择模式时点击滚动条附近区域会误触发滚动条显示导致选择框被遮挡
      if (!this.isSelectedMode || this.isClickScrollBar) {
        this.isClickScrollBar = false;
      }
      Log.info(TAG, `handleTouchEvent scrollBar Up or Cancel:${event.type}, isSelectedMode:${this.isSelectedMode}` +
        `, isClickScrollBar:${this.isClickScrollBar}`);
      AppStorage.setOrCreate<boolean>(Constants.SCROLL_BAR_CLICKING, this.isClickScrollBar);
    }
  }

  private alignGridToScrollbarEdge(): void {
    if (!this.isClickScrollBar || !this.scroller || this.currentScrollerHeight <= 0) {
      return;
    }
    const edgeThreshold: number = Math.min(SCROLLBAR_EDGE_SNAP_THRESHOLD, this.currentScrollerHeight / 10);
    const y: number = this.moveEndY;
    const h: number = this.currentScrollerHeight;
    // 仅当触点纵坐标落在滚动条有效高度内时才吸边，避免略小于 0 的坐标误触发 scrollEdge(Top)
    if (y >= 0 && y <= edgeThreshold) {
      this.scroller.scrollEdge(Edge.Top);
      Log.info(TAG, `alignGridToScrollbarEdge to top, moveEndY:${this.moveEndY}, threshold:${edgeThreshold}`);
      return;
    }
    if (y <= h && y >= h - edgeThreshold) {
      this.scroller.scrollEdge(Edge.Bottom);
      Log.info(TAG, `alignGridToScrollbarEdge to bottom, moveEndY:${this.moveEndY}, threshold:${edgeThreshold}`);
    }
  }

  private updateMovePosition(event: TouchEvent): void {
    if (this.moveStartY === -1) {
      //第一次按下时的坐标值
      if (!event.touches) {
        this.moveStartY = 0;
      } else {
        let touch = event.touches.pop();
        this.moveStartY = touch == undefined ? 0 : touch.y as number;
      }
    } else {
      //当下Touch的坐标值
      if (!event.touches) {
        this.moveEndY = 0;
      } else {
        let touch = event.touches.pop();
        this.moveEndY = touch == undefined ? 0 : touch.y as number;
      }
    }
  }

  /**
   * 监听年日期实时变化
   * @param yearGroupInfoArray 年日期数组
   */
  onUpdateYearDate(yearGroupInfoArray: YearMonthGroupInfo[]): void {
    Log.info(TAG, `onUpdateYearDate yearGroupInfo:${yearGroupInfoArray.length}`)
    this.updateTotalNum();
    // 年胶囊数据
    this.getDateCapsule(yearGroupInfoArray);
  }

  /**
   * 监听年月数据实时变化
   * @param yearGroupInfoArray 年月日期数组
   */
  onUpdateMonthDate(yearMonthGroupInfoArray: YearMonthGroupInfo[]): void {
    Log.info(TAG, `onUpdateMonthDate yearMonthGroupInfo:${yearMonthGroupInfoArray.length}`);
    // 年月胶囊数据
    this.getYearMonthDateCapsule(yearMonthGroupInfoArray);
  }

  aboutToDisappear(): void {
    this.broadCast.off(BroadCastConstants.JUMP_TO_PHOTO_BROWSER, this.onUpdateScrollerOpacity);
    this.appBroadCast.off(BroadCastConstants.YEAR_UPDATE, this.onUpdateYearFunc);
    this.appBroadCast.off(BroadCastConstants.MONTH_UPDATE, this.onUpdateMonthFunc);
    this.observerProxy.release();
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        if (this.bottomArr && this.bottomArr.length > 0) {
          ForEach(this.bottomArr, (year: DateCapsule, index?: number) => {
            Row() {
              Text(year.yearTime)
                .maxFontScale(MAX_FONT_SCALE)
                .draggable(false)
                .fontSize($r('sys.float.Body_S'))
                .fontFamily($r('app.string.id_text_font_family_medium'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .key(`GridScrollBarView_Text_${index}`)
            }
            .backgroundBlurStyle(BlurStyle.Regular, {}, {disableSystemAdaptation: true})
            .key(`GridScrollBarView_Row_${index}_${year.yearTime}`)
            .constraintSize({ minHeight: $r('app.float.scroll_bar_side_text_height_small') })
            .borderRadius($r('app.float.scroll_bar_side_text_radio'))
            .padding({
              left: $r('app.float.scroll_bar_side_text_padding_horizontal_small'),
              right: $r('app.float.scroll_bar_side_text_padding_horizontal_small'),
              top: $r('app.float.scroll_bar_side_text_padding_vertical_small'),
              bottom: $r('app.float.scroll_bar_side_text_padding_vertical_small'),
            })
            .shadow({
              radius: $r('app.float.scroll_bar_side_text_shadow_radio'),
              color: $r('app.color.scroll_bar_side_text_shadow_color'),
              offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
              offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
            })
            .margin({
              top: year.top,
              bottom: year.gap,
            })
          }, (year: DateCapsule) => `${year.yearTime}_${year.gap}_${year.top}`);
        }
      }
      .opacity(this.timeController ? this.getTimelineScrollerCapsulesOpacity() : Constants.TRANSPARENT)
      .height('100%')
      .margin({
        right: UiUtil.isMirrorMode() ? 0 : $r('app.float.scroll_bar_margin_small'),
        left: UiUtil.isMirrorMode() ? $r('app.float.scroll_bar_margin_small') : 0,
        top: $r('sys.float.padding_level8'),
        bottom: $r('sys.float.padding_level8'),
      })
      .onAppear(() => {
        LogUtils.info(TAG, `TimelineScrollerCapsules onAppear:${this.gridForm}`);
      })

      ScrollBar({
        scroller: this.scroller as Scroller, direction: ScrollBarDirection.Vertical,
        state: BarState.On,
      }) {
        Row() {
          Row() {
            if (this.newDateText) {
              Row() {
                Text(this.newDateText)
                  .draggable(false)
                  .fontSize($r('sys.float.Subtitle_L'))
                  .maxFontScale(MAX_FONT_SCALE)
                  .fontFamily($r('app.string.id_text_font_family_medium'))
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Bold)
              }
              .opacity(this.timeController ? this.getTimelineScrollerCapsulesOpacity() :
              Constants.TRANSPARENT)
              .backgroundBlurStyle(BlurStyle.Thick, {}, {disableSystemAdaptation: true})
              .constraintSize({ minHeight: $r('app.float.scroll_bar_side_text_height') })
              .borderRadius($r('app.float.scroll_bar_side_text_radio'))
              .padding({
                left: $r('app.float.scroll_bar_side_text_padding_horizontal'),
                right: $r('app.float.scroll_bar_side_text_padding_horizontal'),
                top: $r('app.float.scroll_bar_side_text_padding_vertical'),
                bottom: $r('app.float.scroll_bar_side_text_padding_vertical'),
              })
              .shadow({
                radius: $r('app.float.scroll_bar_side_text_shadow_radio'),
                color: $r('app.color.scroll_bar_side_text_shadow_color'),
                offsetX: $r('app.float.scroll_bar_side_text_shadow_offsetX'),
                offsetY: $r('app.float.scroll_bar_side_text_shadow_offsetY'),
              })
            }
            Row() {
              Image($r('app.media.scroll_press_light'))
                .draggable(false)
                .width($r('app.float.scroll_bar_big_width'))
                .height($r('app.float.scroll_bar_big_height'))
            }
            .margin({
              left: UiUtil.isMirrorMode() ? $r('app.float.scroll_bar_side_gap') : 0,
              right: UiUtil.isMirrorMode() ? 0 : $r('app.float.scroll_bar_side_gap')
            })
            .visibility(this.isClickScrollBar ? Visibility.Visible : Visibility.None)

            Row() {
              Flex({ direction: FlexDirection.Column }) {
                Blank()
                  .height(this.scrollToEdgeScaleRatio < 1 && this.scrollToEdgeScaleRatio > 0 ?
                    this.scrollToEdgeScaleRatio * SCROLLBAR_EDGE_SCALE + 'vp' : '0vp')
                Column(){
                  Image($r('app.media.scroll_light_arch'))
                    .width($r('app.float.scroll_bar_small_width'))
                    .draggable(false)
                }
                .height('16vp')
                .width('32vp')
                Column(){
                  Image($r('app.media.scroll_light_straight'))
                    .width($r('app.float.scroll_bar_small_width'))
                    .objectFit(ImageFit.Cover)
                    .draggable(false)
                }
                Column(){
                  Image($r('app.media.scroll_light_arch'))
                    .width($r('app.float.scroll_bar_small_width'))
                    .orientation(ImageRotateOrientation.DOWN)
                    .draggable(false)
                }
                .height('16vp')
                .width('32vp')
                Blank()
                  .height(this.scrollToEdgeScaleRatio < 0 ? - this.scrollToEdgeScaleRatio * SCROLLBAR_EDGE_SCALE + 'vp' : '0vp')
              }
              .width($r('app.float.scroll_bar_small_width'))
              .height($r('app.float.scroll_bar_small_height'))
            }
            .margin({
              left: UiUtil.isMirrorMode() ? $r('app.float.scroll_bar_side_margin') : 0,
              right: UiUtil.isMirrorMode() ? 0 : $r('app.float.scroll_bar_side_margin')
            })
            .visibility(this.isClickScrollBar ? Visibility.None : Visibility.Visible)
            .opacity(this.timeController ? this.timeController.timelineScrollerOpacity : Constants.TRANSPARENT)
          }
          .height($r('app.float.scroll_bar_big_height'))
          .width($r('app.float.scroll_press_all_width'))
          .justifyContent(FlexAlign.End)
        }
        .onTouch((event: TouchEvent): void => {
          this.handleTouchEvent(event);
        })
        .responseRegion([{
          x: UiUtil.isMirrorMode() ? 0 : this.responseRegionX,
          y: 0,
          width: this.smallScrollBarWidth,
          height: '100%',
        }])
      }
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        others: Array<GestureRecognizer>) => {
        if (current) {
          //判断是否为点击手势
          Log.info(TAG, 'type:' + current.getType() + 'source:' + event.source)
          if (current.getType() == GestureControl.GestureType.CLICK && event.source == SourceType.Mouse) {
            return GestureJudgeResult.REJECT;
          }
        }
        return GestureJudgeResult.CONTINUE;
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .id(this.scrollBarElemId)
      .height('100%')
      .width($r('app.float.scroll_press_all_width'))
      .responseRegion([{
        x: UiUtil.isMirrorMode() ? 0 : this.responseRegionX,
        y: 0,
        width: this.smallScrollBarWidth,
        height: '100%',
      }])
    }
    .accessibilityLevel('no-hide-descendants')
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .attributeModifier(this.attributeUpdater)
  }
}