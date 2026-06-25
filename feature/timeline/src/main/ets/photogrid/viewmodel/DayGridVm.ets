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

import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { TimelineTool } from '../../model/static/TimelineTool';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { FindAddressParam } from '../statemanager/TitleBarStateManager';
import lazy { GridScrollScene, GridScrollUtil } from '@ohos/common/src/main/ets/default/utils/GridScrollUtil';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { AbstractDayGridVm } from './AbstractDayGridVm';
import lazy { IrregularType } from '../statemanager/constants/GridDefine';
import lazy { SwitchCommonUtils } from './utils/SwitchCommonUtils';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';

/**
 * 日宫格视图模型
 */
export class DayGridVm extends AbstractDayGridVm {
  protected override readonly supportIrregularTypes: IrregularType[] =
    [IrregularType.HEAD_MSG, IrregularType.CLOUD_SYNC_CARD, IrregularType.SORT_SELECTOR,
      IrregularType.FIXED_IRREGULAR,IrregularType.Classify_SELECTOR];

  protected override scrollHelper =
    GridScrollUtil.createDragScrollHelper(GridScrollScene.DAY_VIEW_REGULAR_GRID_DRAG_SCROLL, true);
  protected override slideHelper = GridScrollUtil.createSlideHelper(GridScrollScene.DAY_VIEW_GRID_SLIDE);
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);

  private scrollChange: boolean = true;

  public constructor() {
    super(FormIndex.DAY, 'DayGridVm');
  }

  public override get dataSource(): AlbumDataSource {
    return this.dayDataSource;
  }

  public override get dayDataSource(): AlbumDataSource {
    return super.dayDataSource;
  }

  public override triggerPreloadViewData(firstIndex: number, reason?: string): void {
    TraceControllerUtils.startTrace(`preloadDay:${reason}, idx:${firstIndex}`);
    // 切换视图前设置分批更新滑窗起始Index
    this.dayDataSource.setPreloadStartIndex(firstIndex);
    // 更新滑窗
    this.dayDataSource.updateSlidingWindow(firstIndex);
    TraceControllerUtils.finishTrace(`preloadDay:${reason}, idx:${firstIndex}`);
  }

  public setScrollChange(scrollChange: boolean): void {
    this.scrollChange = scrollChange;
  }

  public getScrollChange(): boolean {
    return this.scrollChange;
  }

  public getScrollOffsetLayoutIndex(): number[] {
    let preOffset = this.gridStateManager.getScrollOffsetManager(this.gridForm).currentState;
    const offset = this.autoUpdateHeadMsgHeight(preOffset);
    const realOffset = Math.max(preOffset - offset, 0);
    let layoutInfo = SwitchCommonUtils.calcLayoutIndex(this, this.gridForm, realOffset);
    layoutInfo[1] = realOffset - layoutInfo[1];
    return layoutInfo;
  }

  protected override onScrollIndexInner(firstIndexInGrid: number, lastIndexInGrid: number): void {
    super.onScrollIndexInner(firstIndexInGrid, lastIndexInGrid);
    this.scrollHelper?.handleScrollIndex(firstIndexInGrid, lastIndexInGrid);
  }

  protected override backToTop() {
    if (!this.isInCurrentForm()) {
      return;
    }
    this.dataSource.setPreloadStartIndex(0);
    this.getScroller().scrollEdge(Edge.Top);
  }

  protected override handleUpdateCurrentTime(firstItemIndex: number): void {
    // 将layoutIndex转为dataIndex, 默认需要减去headGridItem占的1个, 如果有云卡片需要额外减1
    const dataIndex = Math.max(firstItemIndex - (this.isShowCloudCard || this.isShowCameraCard ? 2 : 1), 0);
    let findAddressParam: FindAddressParam = {
      firstIndex: dataIndex,
      columnCount: this.gridObserverProxy.getGridColumn(),
      formIndex: this.gridForm,
    };
    this.startFindAddress(findAddressParam);
    // 冷启动后直接切换到年视图时会存在年月视图缓存获取不到导致获取日期时间戳失败问题，此时获取日视图左上第一个缩略图的时间戳
    let firstThumbnailIndex = Math.min(dataIndex, this.dayDataSource.totalCount() - 1);
    let firIndexDateTaken = this.dataSource?.getWrappedData(firstThumbnailIndex)?.mediaItem?.getDateTaken();
    if (!firIndexDateTaken) {
      firIndexDateTaken = this.dataSource?.getSimpleMediaItem(firstThumbnailIndex)?.getDateTaken();
    }
    LogUtils.info(this.tag, `updateCurrentTime index:${firstThumbnailIndex} DateTaken:${firIndexDateTaken}`);
    if (firIndexDateTaken) {
      this.setCurrentTime(firIndexDateTaken);
    }
  }

  protected override handleSetCurrentTime(firIndexDateTaken: number) {
    let dateString: string = TimelineTool.formatTimeStampToLocalizedDate(firIndexDateTaken, this.rsc);
    this.currentTime = dateString;
    this.stateProxy.titleBarStateManager.mainTitleContentAsm.updateState(dateString, 'DAY setCurrentTime');
    LogUtils.info(this.tag, `DAY setCurrentTime:${firIndexDateTaken}, ${dateString}, ${this.firIndexDateTaken}`);
    return;
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);

    this.scrollHelper?.setGridPageInfo({ gridScene: Constants.PHOTO_TRANSITION_TIMELINE });

    LogUtils.debug(this.tag, "start init DayDataSource");
    this.initObservers();
    LogUtils.debug(this.tag, "after init DayDataSource");
  }

  protected override offsetChanged(firstIndex: number, scrollChange: boolean): void {
    LogUtils.info(this.tag, `offsetChanged ${firstIndex}`);
    if (firstIndex == FormIndex.MONTH) {
      this.scrollChange = scrollChange;
    }
  }

  private initObservers(): void {
    this.gridObserverProxy.getGridSortState((oldState, newState) => {
      LogUtils.info(this.tag, `update grid sort from ${oldState} to ${newState}`);
      this.gridStateManager.updateGirdAnimState(false);
      let intervalId = setInterval((): void => {
        this.gridStateManager.updateGirdAnimState(true);
        clearInterval(intervalId);
      }, Constants.GRID_LOCK_DURATION);
      this.dataSource.notifyDirty();
    });
    this.gridObserverProxy.getGridAnimState((oldState, newState) => {
      LogUtils.info(this.tag, `update grid anim from ${oldState} to ${newState}`);
      this.needReloadAnim = newState;
    })
  }

  /**
   * 刷新右键菜单
   *
   * @param mediaItem 传入的图片信息
   */
  public updateRightClickMenuList(mediaItem?: MediaItem): void {
  }

  /**
   * 刷新LazyForEach的keyGenerator
   *
   * @param item 传入的图片信息
   * @param index 传入的图片下标
   *
   * @returns 当前图片的keyGenerator
   */
  public getGeometryTransitionId(item: ViewData, index: number): string {
    const tag: string = Constants.PHOTO_TRANSITION_TIMELINE;
    if (item === undefined) {
      return tag + index
    }
    let mediaItem = item?.mediaItem;
    if (mediaItem && mediaItem.thumbnail && mediaItem.thumbnail.length > 0 && mediaItem.getHashCode().length > 0) {
      item.refreshKey = tag + mediaItem.getHashCode() + `/${mediaItem.getDateModified() ?? 0}` +
        `/${mediaItem.thumbnailReady}`;
      return tag + mediaItem.getHashCode() +`/${mediaItem.isFavor ? 'isFavor' : 'notFavor'}`;
    } else {
      return tag + index;
    }
  }
}