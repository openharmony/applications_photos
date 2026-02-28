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

import lazy  { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { GridAutoScrollerUtil } from '@ohos/common/src/main/ets/default/utils/GridAutoScrollerUtil';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { DataSourceListener, ObserveDataSourceChanged } from '../model/DataSourceManager';
import lazy { AbstractGridVm } from './AbstractGridVm';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { FormStateTypeUtils, FormStateType, FormEventTypeUtils, FormEventType } from '../statemanager/GridFormFsm';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { IrregularGridScrollInfo } from '@ohos/common/src/main/ets/default/utils/GridScrollBaseHelper';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { PreloadEventType } from '../statemanager/GridPreloadFsm';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { AppStorageKeys } from '@ohos/common/src/main/ets/default/utils/AppStorageKeys';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ViewType } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewType';
import lazy { FrameSelectionUtil } from '@ohos/common/src/main/ets/default/utils/FrameSelectionUtil';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuGroup';
import lazy { AlbumLoadingTaskResult } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { ColdStartState } from '@ohos/common/src/main/ets/default/model/ColdStartState';
import lazy { TraceTaskType, TraceUtils } from '../model/utils/TraceUtils';
import lazy { ReloadStatusType } from '../statemanager/AlbumStateManager';
import { accessibility } from '@kit.AccessibilityKit';
import { GridShowEventType } from '../statemanager/GridShowFsm';
import { OperateEventType } from '../statemanager/GridOperateFsm';

const TAG: string = 'AbstractDayGridVm';

/* instrument ignore file */

// 延时加载时间
const DELAY_LOAD_TIME: number = 50;
// 三四宫格首次加载cachedCount值
const DAY_AND_GROUP_DAY_CACHED_COUNT: number = 8;

/**
 * 日宫格抽象视图模型
 */
export abstract class AbstractDayGridVm extends AbstractGridVm {
  // 滑动多选
  public selectManager: TimelineSelectManager = new TimelineSelectManager();

  private isSlideSelectMode: boolean = false;
  private oriSelectedCount: number = 0;
  public gridAutoScrollerUtil = new GridAutoScrollerUtil();
  private cacheSet: Set<string> = new Set<string>();
  private entryIndex: number = 0;
  private oriState: boolean = false;
  private tempIndex: number = -1;
  protected isGridScrolling: boolean = false;
  // 是否展示云同步卡片，从view层传递
  public isShowCloudCard: boolean = false;
  // 是否展示相机权限卡片
  public isShowCameraCard: boolean = false;
  // 数据监听回调
  protected dataSourceListener: DataSourceListener = {
    onDataUpdate: (count: number): void => {
      LogUtils.info(this.tag, `onDataUpdate ${count}`);
      this.selectManager.setTotalCount(count);
      if (count > 0) {
        this.stateProxy.operateFsm.submitEvent(OperateEventType.DATA_LOADED);
        this.stateProxy.formFsm.submitEvent(FormEventType.DATA_LOADED);
      } else {
        this.stateProxy.operateFsm.submitEvent(OperateEventType.DATA_CLEAR);
        this.stateProxy.formFsm.submitEvent(FormEventType.DATA_CLEAR);
      }
    },
    onDataLoadFinish: (result: LoadingResult<MediaItem>): void => {
      this.onDataLoadingFinished(result);
    }
  };
  private readonly hidePreviewFun: Function = (): void => this.hidePreview();
  protected broadCast: BroadCast = new BroadCast();
  protected dataSourceChangeCallback?: ObserveDataSourceChanged;
  protected isScrollerBarTouch: boolean = false;
  protected needReloadAnim: boolean = true;
  private delayLoadTimer: number = 0;

  public override onAppear(): void {
    super.onAppear();
    this.gridStateManager.getCachedCountManager(this.gridForm).updateState(
      DAY_AND_GROUP_DAY_CACHED_COUNT, this.tag);
    // 宫格加载完成时，通知取消延时加载，触发加载另一宫格
    if (this.gridObserverProxy.getDelayLoad() && this.gridObserverProxy.config.isSupportStaggerLoading) {
      this.delayLoadTimer = setTimeout(() => {
        if (this.gridObserverProxy.getDelayLoad()) {
          TraceUtils.finishTrace(TraceTaskType.GRID_DELAY_LOAD);
          this.gridStateManager.delayLoadAsm.updateState(false, this.tag);
        }
      }, DELAY_LOAD_TIME);
    }
  }

  /**
   * 获取页面名称
   *
   * @returns 页面名称
   */
  public get pageName(): string {
    return Constants.PHOTO_TRANSITION_TIMELINE;
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    LogUtils.debug(this.tag, "start init AbsDayDataSource");
    this.selectManager = GridStateProxy.getInstance(this.persistentId).selectManager;
    // 监听数据变化
    this.registerDataSourceListener(this.dataSourceListener);
    this.getFormState((_oldState, newState): void => {
      if (FormStateTypeUtils.isInGroupDayState(newState)) {
        this.selectManager.mIsDayGroupState = true;
      } else if (FormStateTypeUtils.isInDayState(newState)) {
        this.selectManager.mIsDayGroupState = false;
      }
      LogUtils.info(this.tag, `selectManager mIsDayGroupState change to ${this.selectManager.mIsDayGroupState}`);
    });
    this.gridObserverProxy.getGridAnimState((_oldState, newState): void => {
      LogUtils.info(this.tag, `getGridAnimState ${newState}`);
      this.needReloadAnim = newState;
    })
    this.scrollerObserverProxy.getIsScrolling(this.gridForm, (_oldState, newState) => {
      this.isGridScrolling = newState;
    });
    this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm,
      (_oldState, newState) => this.isScrollerBarTouch = newState);
    this.registerSelectListener();
    this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm, (oldState: boolean, newState: boolean) => {
      if (oldState === newState) {
        return;
      }
      let gridScrollInfo: IrregularGridScrollInfo = {
        imageGridItemHeight: this.gridObserverProxy.getGridImageHeight(this.gridForm),
        gridRowCount: this.gridObserverProxy.getGridColumn(this.gridForm),
        actionAndRefreshHeight: this.gridObserverProxy.getIrregularHeight(this.gridForm),
        timeTitleHeight: this.gridObserverProxy.getGroupTitleHeight(),
      };
      this.scrollHelper?.recordScrollInfo(gridScrollInfo);
      newState ? this.scrollHelper?.handleScrollStart() : this.scrollHelper?.handleScrollStop();
    });
    this.selectManager.setGetMediaItemFunc(
      (uris: string, itemNotifyCallback: Function): MediaItem | undefined => {
        return this.dayDataSource?.getMediaItemByUriFromAll(uris, itemNotifyCallback);
      });
    this.displayObserverProxy.getIsGridActive((_oldState, newState) => {
      Log.info(this.tag, `getIsGridActive ${_oldState} --> ${newState}`);
      if (newState) {
        this.refreshTouchGuide();
      }
    });
    this.displayObserverProxy.getLanguage((_oldState, newState) => {
      Log.info(this.tag, `getLanguage ${_oldState} --> ${newState}`);
      if (newState) {

      }
    });
    this.displayObserverProxy.getIsHorizontal((_oldState, newState) => {
      Log.info(this.tag, `getIsHorizontal ${_oldState} --> ${newState}`);
      if (this.isInCurrentForm()) {
        let size: Size = this.displayStateManager.gridAreaSizeAsm.currentState;
        if (newState === (size.height < size.width)) {
          return;
        }
        let newSize: Size = {
          width: size.height,
          height: size.width,
        }
        this.displayStateManager.gridAreaSizeAsm.updateState(newSize, this.tag);
      }
    });
    this.broadCast.on(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, this.hidePreviewFun);
    LogUtils.debug(this.tag, "after init AbsDayDataSource");
  }

  public override onScrollStart(): void {
    super.onScrollStart();
    this.updateCachedCount();
  }

  protected override doRelease() {
    this.broadCast.off(BroadCastConstants.SWITCH_GRID_HIDE_PREVIEW, this.hidePreviewFun);
    clearTimeout(this.delayLoadTimer);
    super.doRelease();
  }

  public onPanActionStart(gesturePosX: number, gesturePosY: number): void {
    if (!this.isInSelectMode()) {
      return;
    }
    this.isSlideSelectMode = true;
    this.oriSelectedCount = this.selectManager.getSelectedCount();
    this.gridAutoScrollerUtil.initIsEntryFromHotAndNotScrolled(gesturePosY);
    this.calEntryIndex(gesturePosX, gesturePosY);
  }

  public onPanActionUpdate(gesturePosX: number, gesturePosY: number): void {
    if (!this.isInSelectMode()) {
      return;
    }
    this.gridAutoScrollerUtil.autoscrollOrStop(this.getScroller(), gesturePosY);
    this.calCurrentIndexAndToggle(gesturePosX, gesturePosY);
  }

  public onPanActionEnd(): void {
    if (!this.isInSelectMode()) {
      return;
    }
    this.tempIndex = -1;
    if (DeviceInfo.isPhone()) {
      setTimeout(() => {
        this.selectManager.updateCount();
      },100);
    }
    this.gridAutoScrollerUtil.isEntryFromHotAndNotScrolled = false;
    this.getScroller().scrollBy(0, 0);
    this.isSlideSelectMode = false;
    const msg: Record<string, number | string | boolean> = {
      'behaviorType': this.oriState ? BigDataConstants.PHOTO_SLIDE_DESELECT_TYPE :
      BigDataConstants.PHOTO_SLIDE_SELECT_TYPE,
      'count': Math.abs(this.selectManager.getSelectedCount() - this.oriSelectedCount)
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_SLIDE_SELECT, msg);
  }

  /**
   * 日视图滚动index回调，调用scrollHelper回调，记录上次预加载起始索引
   *
   * @param firstIndexInGrid 宫格显示的第一个索引
   * @param lastIndexInGrid 宫格显示的最后一个索引
   */
  public onScrollIndex(firstIndexInGrid: number, lastIndexInGrid: number): void {
    super.onScrollIndex(firstIndexInGrid, lastIndexInGrid);
    if (this.scrollerObserverProxy.getIsScrollerTouched(this.gridForm)) {
      this.scrollHelper?.handleScrollIndex(firstIndexInGrid, lastIndexInGrid);
    }
    this.scrollerStateManager.getFirstIndexInGridAsm(this.gridForm).updateState(firstIndexInGrid);
    this.scrollerStateManager.getLastIndexInGridAsm(this.gridForm).updateState(lastIndexInGrid);
  }

  public needUpdateTotalSelectedCount(newState: number): boolean {
    return !this.isSlideSelectMode || newState === 0 || newState === 1 || newState === 2;
  }

  public getFirstIndexInGrid(): number {
    return this.firstIndexInGrid;
  }

  public getLastIndexInGrid(): number {
    return this.lastIndexInGrid;
  }

  /**
   * 隐藏预览视图
   */
  public hidePreview(): void {
    LogUtils.info(this.tag, 'receive hidePreview');
    this.stateProxy.preloadFsm.submitEvent(PreloadEventType.HIDE)
  }

  /**
   * 刷新界面布局
   */
  public refreshLayoutOptions(): void {
  }

  /**
   * 更新气泡显示状态
   *
   * @param isUpdateGuideState 是否更新气泡显示状态
   */
  public updateDayGuideState(isUpdateGuideState: boolean): void {
    LogUtils.info(this.tag, `updateDayGuideState:${isUpdateGuideState}`);
    this.stateProxy.switchStateManager.isUpdateGuideStateAsm.updateState(isUpdateGuideState, 'updateDayGuideState');
  }

  /**
   * 更新云同步卡片显示状态
   *
   * @param isShowCloudCard 云同步卡片显示状态
   */
  public updateCloudCardShowStatus(isShowCloudCard: boolean): void {
    this.isShowCloudCard = isShowCloudCard;
  }

  private calEntryIndex(gesturePosX: number, gesturePosY: number): void {
    this.cacheSet.clear();

    let index: number = this.firstIndexInGrid;
    let lastIndex: number = this.lastIndexInGrid;
    let gridScroller: Scroller = this.getScroller();
    try {
      for (; index <= lastIndex; index++) {
        let rect: RectResult = gridScroller.getItemRect(index);
        if (rect.y > gesturePosY) {
          break;
        }
        let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
        if (rect.x - gutter <= gesturePosX &&
          rect.x + rect.width + gutter >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gutter >= gesturePosY - Number.EPSILON) {
          break;
        }
      }
    } catch (err) {
      LogUtils.error(this.tag,
        `getItemRectErrorForEntry ${err}, this ${this}, scroller ${gridScroller}, index ${index}`);
    }
    index--;
    // 兼容顶部卡片场景
    if (this.isShowCloudCard || this.isShowCameraCard) {
      index--;
    }
    // 减去顶部补位空白格
    index = Math.max(0, index - this.gridObserverProxy.getFillPostion(this.gridForm));
    this.entryIndex = index;
    let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
    if (!tempData || !tempData.mediaItem || tempData.viewType === ViewType.GROUP_TITLE) {
      this.oriState = false;
      return;
    }
    this.oriState = this.selectManager.isItemSelected(tempData.mediaItem?.uri, index);
  }

  private calCurrentIndexAndToggle(gesturePosX: number, gesturePosY: number): void {
    let gridScroller: Scroller = this.getScroller();
    if (this.checkIsPreviousOne(gesturePosX, gesturePosY, gridScroller) || !this.dataSource) {
      return;
    }
    // 网格区域的起始位置和终止位置
    let index: number = this.firstIndexInGrid;
    let lastIndex: number = this.lastIndexInGrid;
    try {
      for (; index <= lastIndex; index++) {
        let rect: RectResult = gridScroller.getItemRect(index);
        if (rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0) {
          LogUtils.warn(this.tag,
            `getItemRectWarn currentIndex = ${index} firstIndex = ${index} lastIndex = ${lastIndex}`);
          return;
        }
        if (rect.y > gesturePosY || gesturePosY < 0) {
          if (this.entryIndex < index - 1) {
            index--;
          }
          break;
        }
        let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
        if (rect.x - gutter <= gesturePosX &&
          rect.x + rect.width + gutter >= gesturePosX - Number.EPSILON &&
          rect.y + rect.height + gutter >= gesturePosY - Number.EPSILON) {
          break;
        }
      }
    } catch (err) {
      LogUtils.error(this.tag,
        `getItemRectErrorForCurrent ${err}, this ${this}, scroller ${gridScroller}, index ${index}`);
      return;
    }
    if (index === lastIndex + 1 && this.entryIndex != lastIndex) {
      index--;
    }
    // 兼容顶部卡片场景
    if (this.isShowCloudCard || this.isShowCameraCard) {
      index--;
    }
    index--;
    // 减去顶部补位空白格
    index = Math.max(0, index - this.gridObserverProxy.getFillPostion(this.gridForm));
    this.toggleItemsWithIndex(this.entryIndex, index);
  }

  private checkIsPreviousOne(gesturePosX: number, gesturePosY: number, gridScroller: Scroller): boolean {
    try {
      let rect: RectResult | undefined = undefined;
      let offset: number = 1;
      // 兼容顶部卡片场景
      if (this.isShowCloudCard || this.isShowCameraCard) {
        offset++;
      }
      rect = gridScroller.getItemRect(this.tempIndex + offset);
      let gutter = Constants.GRID_GUTTER;
      if (rect.x - gutter <= gesturePosX && rect.y <= gesturePosY &&
        rect.x + rect.width + gutter >= gesturePosX - Number.EPSILON &&
        rect.y + rect.height + gutter >= gesturePosY - Number.EPSILON) {
        return true;
      }
    } catch (err) {
      LogUtils.error(this.tag,
        `getItemRectError ${err}, this ${this}, scroller ${gridScroller}, index ${this.tempIndex}`);
      return false;
    }
    return false;
  }

  private toggleItemsWithIndex(entryIndex: number, currentIndex: number): void {
    if (this.tempIndex === currentIndex || !this.dataSource) {
      return;
    }
    LogUtils.info(this.tag, `toggleItemsWithIndex ${entryIndex}, ${currentIndex}`);
    if (currentIndex === entryIndex) {
      this.releaseToggleWithIndex(entryIndex, this.tempIndex);
      let tempData = this.dataSource.getWrappedData(entryIndex, this.selectManager.mIsDayGroupState);
      if (tempData?.mediaItem && tempData?.viewType !== ViewType.GROUP_TITLE) {
        this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem.uri, !this.oriState, entryIndex);
      }
    } else if (currentIndex > entryIndex) {
      this.slideDown(entryIndex, currentIndex);
    } else {
      this.slideUp(entryIndex, currentIndex);
    }
    if (currentIndex === -1) {
      currentIndex = 0;
    }
    this.tempIndex = currentIndex;
  }

  private releaseToggleWithIndex(start: number, end: number): void {
    if (this.tempIndex === -1 || !this.dataSource) {
      return;
    }
    if (end < start) {
      let temp = end;
      end = start;
      start = temp;
    }
    for (let index = start; index <= end; index++) {
      let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
      if (!tempData || !tempData.mediaItem || this.isNoNeedReleaseState(tempData.mediaItem)) {
        continue;
      }
      this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem?.uri, this.oriState, index);
    }
  }

  private slideDown(entryIndex: number, currentIndex: number): void {
    Log.info(this.tag, `slideDown tempIndex=${this.tempIndex}， currentIndex=${currentIndex}`)
    if (this.tempIndex < entryIndex) {
      this.releaseToggleWithIndex(this.tempIndex, this.entryIndex - 1);
    }
    // instrument ignore else
    if (this.tempIndex < currentIndex) {
      let index: number = this.getStartIndexForSlideDown(entryIndex, this.tempIndex);
      for (; index <= currentIndex; index++) {
        let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
        if (!tempData || !tempData.mediaItem?.uri || tempData.viewType === ViewType.GROUP_TITLE) {
          continue;
        }
        if (this.selectManager.isItemSelected(tempData.mediaItem?.uri, index)
          && (this.tempIndex < entryIndex || index > this.tempIndex)) {
          this.cacheSet.add(tempData.mediaItem?.uri);
        }
        if (this.isGridScrolling && DeviceInfo.isPhoneUx()) {
          this.selectManager.toggleWithCheckOriginalStateScrolling(tempData.mediaItem?.uri, !this.oriState,
            index);
        } else {
          this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem?.uri, !this.oriState, index);
        }
      }
    } else if (this.tempIndex > currentIndex) {
      for (let index = currentIndex + 1; index <= this.tempIndex; index++) {
        let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
        if (!tempData || !tempData.mediaItem?.uri || this.isNoNeedReleaseState(tempData.mediaItem)) {
          continue;
        }
        if (this.isGridScrolling && DeviceInfo.isPhoneUx()) {
          this.selectManager.toggleWithCheckOriginalStateScrolling(tempData.mediaItem?.uri, this.oriState,
            index);
        } else {
          this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem?.uri, this.oriState, index);
        }
      }
    }
  }

  private slideUp(entryIndex: number, currentIndex: number): void {
    if (this.tempIndex > entryIndex) {
      this.releaseToggleWithIndex(this.tempIndex, this.entryIndex + 1);
    }
    if (this.tempIndex > currentIndex) {
      this.slideBackInSlideUp(entryIndex, currentIndex);
    } else if (this.tempIndex < currentIndex) {
      for (let index = currentIndex - 1; index >= this.tempIndex; index--) {
        let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
        if (!tempData || !tempData.mediaItem || this.isNoNeedReleaseState(tempData.mediaItem)) {
          continue;
        }
        if (this.isGridScrolling && DeviceInfo.isPhoneUx()) {
          this.selectManager.toggleWithCheckOriginalStateScrolling(tempData.mediaItem?.uri, this.oriState,
            index);
        } else {
          this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem?.uri, this.oriState, index);
        }
      }
    }
  }

  private isNoNeedReleaseState(mediaItem: MediaItem): boolean {
    return (this.oriState && !this.cacheSet.has(mediaItem.uri)) ||
      (!this.oriState && this.cacheSet.has(mediaItem.uri));
  }

  private getStartIndexForSlideDown(entryIndex: number, tempIndex: number): number {
    let index: number = entryIndex;
    if (this.tempIndex >= entryIndex) {
      index = this.tempIndex;
    }
    return index;
  }

  protected override onPlaceholderChange(uniqueId: string, isTap: boolean): void {
    if (this.isInCurrentForm()) {
      this.broadCast.emit(uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + this.pageName, [isTap]);
    }
  }

  private slideBackInSlideUp(entryIndex: number, currentIndex: number): void {
    let index: number = this.getStartIndexForSlideUp(entryIndex, this.tempIndex);
    for (; index >= currentIndex; index--) {
      let tempData = this.dataSource.getWrappedData(index, this.selectManager.mIsDayGroupState);
      if (!tempData || !tempData.mediaItem) {
        continue;
      }
      if (this.selectManager.isItemSelected(tempData.mediaItem?.uri, index)
        && (this.tempIndex > entryIndex || index < this.tempIndex)) {
        this.cacheSet.add(tempData.mediaItem?.uri);
      }
      if (this.isGridScrolling && DeviceInfo.isPhoneUx()) {
        this.selectManager.toggleWithCheckOriginalStateScrolling(tempData.mediaItem?.uri, !this.oriState,
          index);
      } else {
        this.selectManager.toggleWithCheckOriginalState(tempData.mediaItem?.uri, !this.oriState, index);
      }
    }
  }

  private getStartIndexForSlideUp(entryIndex: number, tempIndex: number): number {
    let index: number = entryIndex;
    if (this.tempIndex <= entryIndex) {
      index = this.tempIndex;
    }
    return index;
  }

  public setBroadCast(broadCast: BroadCast): void {
    this.broadCast = broadCast;
  }

  protected registerSelectListener(): void {
    this.selectObserverProxy.registerEventListener({
      select: (newState: number): void => {
        if (!this.isInCurrentForm()) {
          return;
        }
        LogUtils.info(this.tag, `select ${newState}, isGroup: ${this.selectManager.mIsDayGroupState}`);
        let viewData: ViewData | undefined =
          this.dataSource?.getWrappedData(newState, this.selectManager.mIsDayGroupState);
        if (viewData?.mediaItem) {
          this.broadCast.emit(viewData.mediaItem.uniqueId + BroadCastConstants.REFRESH_SELECT_DATA, []);
        }
      }
    });
  }

  public onMenuClicked(action: Action): void {
    LogUtils.info(this.tag,
      `onMenuClicked, actionID: ${ActionID[action?.actionID]}`);
    if (Action.MULTISELECT.equals(action)) {
      // 多选模式进入之前清空
      this.selectManager.deSelectAll();
      // 长按菜单进入选择模式
      this.changeSelectMode(true);
      const msg: Record<string, number | string | boolean> = {
        'IS_ENTER': 'true',
        'IS_QUIT': 'false',
        'from': 'GALLERY_GRID_LONG_PRESS_PAGE',
        'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex),
      };
      ReportToBigDataUtil.report(BigDataConstants.MULTI_SELECT_MODE, msg);
    }
  }

  public onRightMenuClicked(action: Action, mediaItem? : MediaItem): void {
  }

  /**
   * 焦点变化回调函数
   */
  public onFocused(): void {
    LogUtils.info(this.tag, 'onFocused updateGridFocused');
    this.displayStateManager.updateGridFocused(true);
  }

  /**
   * 鼠标事件回调
   */
  public onMouse(event?: MouseEvent): void {
    FrameSelectionUtil.mainViewOnMouse(event);
  }

  public override changeSelectMode(isSelectMode: boolean): void {
    // 退出选择模式时清空选择器
    if (!isSelectMode) {
      this.selectManager.deSelectAll();
    }
    this.selectManager.onModeChange(isSelectMode);
    super.changeSelectMode(isSelectMode);
  }

  public get isCloudCardSupported(): boolean {
    return this.gridStateManager.config.isCloudCardSupported &&
      !(DeviceInfo.isPc() || DeviceInfo.isTv() || DeviceInfo.isEmulator() || DeviceInfo.isPrototypeAdu() ||
      DeviceInfo.isPrototypeLdu());
  }

  public refreshTouchGuide(): void {
    AppStorage.setOrCreate<boolean>(Constants.OPEN_TOUCH_GUIDE, accessibility.isOpenTouchGuideSync());
  }

  public pause(): void {

  }

  public resume(): void {

  }

  protected onDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    this.updateCurrentTime(this.firstIndexInGrid);
    this.albumStateManager.updateReloadStatus(ReloadStatusType.RELOADING);
    let loadingResult: AlbumLoadingTaskResult = result as AlbumLoadingTaskResult;
    const oldSize: number = result.oldPageData.size;
    const newSize: number = result.newPageData.size;
    let loadStart: number = result.info.start;
    let loadEnd: number = result.info.start + result.info.count;
    Log.info(this.tag, `onDataLoadingFinished size: ${oldSize}->${newSize}, range: (${loadStart}, ${loadEnd})` +
      `, version ${result.oldPageData.version}->${result.newPageData.version}, state${loadingResult.coldStartState}`);
    if (result.oldPageData.version === result.newPageData.version &&
      loadingResult.coldStartState === ColdStartState.DONE) {
      this.refreshLayoutOptions();
      // 数据集不变场景，仅刷新加载范围的数据
      for (let i: number = loadStart; i < loadEnd; i++) {
        if (i < this.dayDataSource.activeStart || i >= this.dayDataSource.activeEnd) {
          continue;
        }
        this.dayDataSource.onDataChange(i);
      }
      this.albumStateManager.updateReloadStatus(ReloadStatusType.RELOAD_FINISH);
      return;
    }

    if (oldSize === newSize) {
      // 数量不变场景也要保证刷新，否则可能导致刷新缺失
      this.refreshLayoutOptions();
      this.dataSource.onDataReloaded();
      this.albumStateManager.updateReloadStatus(ReloadStatusType.RELOAD_FINISH);
      return;
    }

    const animateCallback = (): void => {
      if (!FormStateTypeUtils.isInFollowHandState(this.getFormState())) {
        this.refreshLayoutOptions();
        this.dataSource.onDataReloaded();
        this.albumStateManager.updateReloadStatus(ReloadStatusType.RELOAD_FINISH);
      }
      AppStorage.setOrCreate(Constants.CURRENT_TIME, new Date().getTime());
    };

    if (!this.needDoAnimate()) {
      this.dataSourceChangeCallback?.onDataSourceChanged?.(false);
      animateCallback();
      return;
    }
    this.dataSourceChangeCallback?.onDataSourceChanged?.(true);
    animateTo({
      duration: Constants.GRID_TRANSITION_DURATION, // 动画时长
      curve: Curve.Smooth, // 曲线参数
      onFinish: () => {}
    }, animateCallback);
  }

  /**
   * 注册数据源变化监听
   *
   * @param dataSourceChangeCallback 数据变化回调，更新UI
   */
  public registerDataSourceChangedListener(dataSourceChangeCallback?: ObserveDataSourceChanged): void {
    if (dataSourceChangeCallback) {
      this.dataSourceChangeCallback = dataSourceChangeCallback;
    }
  }

  private needDoAnimate(): boolean {
    // 滑动、滚动、ready任务执行时不触发动效
    return this.needReloadAnim && !this.isScrollerBarTouch && !this.isGridScrolling &&
      !UserFileManagerAccess.getInstance().isInReadyProcess();
  }

  /**
   * 查询右键菜单列表
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getRightClickMenuList(callback?: StateChangeCallback<RightClickMenuGroup[]>): RightClickMenuGroup[] {
    return [];
  }

  /**
   * 刷新右键菜单
   *
   * @param mediaItem 传入的图片信息
   */
  public updateRightClickMenuList(mediaItem?: MediaItem): void {

  }

  /**
   * 日分组整组选择状态保持
   * @param isSelected
   * @param mediaItem
   */
  public groupSelectItem(isSelected: boolean, mediaItem: MediaItem): void {

  }
}