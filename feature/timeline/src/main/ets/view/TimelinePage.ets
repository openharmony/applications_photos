/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import Curves from '@ohos.curves';
import { MenuOperation } from '@ohos/common';
import {
  Action,
  AddMenuOperation,
  BatchDeleteMenuOperation,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  DateUtil,
  DeleteMenuOperation,
  Log,
  MediaItem,
  MediaOperationType,
  MenuContext,
  MenuOperationFactory,
  ScreenManager,
  ShareMenuOperation,
  TimelineData,
  TimelineSelectManager,
  TraceControllerUtils,
  UiUtil,
  ViewData,
  ViewType
} from '@ohos/common';
import {
  BrowserController,
  CustomDialogView,
  ImageGridItemComponent,
  NoPhotoIndexComponent,
} from '@ohos/common/CommonComponents';
import { TimelineDataSource } from '../model/TimelineDataSource';
import { TimelineTitleComponent } from './TimelineTitleComponent';
import { TimelinePageActionBar } from './TimelinePageActionBar';
import { TimelinePageToolBar } from './TimelinePageToolBar';
import router from '@ohos.router';
import { TimelineDataSourceManager } from '../model/TimelineDataSourceManager';
import { TimelineScrollBar } from './TimelineScrollBar';

const TAG: string = 'TimelinePage';
AppStorage.SetOrCreate('TimelinePageIndex', Constants.INVALID);

// PHOTO Page
@Component
export struct TimelinePage {
  @Provide isEmpty: boolean = false;
  @State isShowScrollBar: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @State gridRowCount: number = 0;
  @Consume @Watch('updateRightClickMenuList') isSelectedMode: boolean;
  @Consume('isShowSideBar') @Watch('initGridRowCount') isSidebar: boolean;
  @Provide isAllSelected: boolean = false;
  @State totalSelectedCount: number = 0;
  @Provide broadCast: BroadCast = TimelineDataSourceManager.getInstance().getBroadCast();
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  @StorageLink('TimelinePageIndex') @Watch('onIndexChange') TimelinePageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  dataSource: TimelineDataSource;
  mSelectManager: TimelineSelectManager = new TimelineSelectManager();
  scroller: Scroller = new Scroller();
  appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  isInCurrentTab = true; // Is it on the current tab page
  isDataFreeze = false; // Is the page data frozen
  deleteMode = false; // Is delete mode
  isActive = false; // Is the page active
  routerStart = false; // Is move or copy router page
  @Provide moreMenuList: Action[] = new Array<Action>();
  @Provide rightClickMenuList: Array<Action> = new Array<Action>();
  @State groupSelectMode: boolean[] = [];
  @Provide yearData: TimelineData[] = [];
  @Provide dateText: string = '';
  @Provide isShowBar: boolean = true;
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @ObjectLink browserController: BrowserController;
  @Provide hidePopup: boolean = false;
  // 选择模式下，鼠标对着未勾选项按右键弹框时，移动和复制菜单点击事件的标识位
  private isMvOrCpSeparatesItem: boolean = false;
  private mvOrCpSeparatesItem: MediaItem = null;
  onWindowSizeChangeCallBack = () => this.initGridRowCount();

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex != -1) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('TimelinePageAboutToAppear');
    Log.info(TAG, 'aboutToAppear begin');
    let self = this;
    this.dataSource = TimelineDataSourceManager.getInstance().getDataSource();
    let params: any = router.getParams();
    if (params != null && params.pageFrom && params.pageFrom == Constants.ENTRY_FROM.CAMERA) {
      this.dataSource.initData();
    }
    this.mSelectManager.setGroupData(this.dataSource.getGroupData());
    this.mSelectManager.setTotalCount(this.dataSource.getMediaCount());
    this.moreMenuList = [Action.ADD, Action.INFO];
    this.updateRightClickMenuList();
    this.dataSource.registerCallback('updateGroupData', (newState: TimelineData[]) => {
      self.mSelectManager.updateGroupData(newState);
      self.updateYearMap();
    });
    this.dataSource.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateCount ${newState}`);
      self.isEmpty = !Boolean(newState);
      self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
      self.mSelectManager.setTotalCount(newState);
    });

    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.Get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    }

    this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
    this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
    this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
    this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
    this.appBroadCast.on(BroadCastConstants.RESET_ZERO, (pageNumber: number) => {
      if (pageNumber == Constants.TIMELINE_PAGE_INDEX) {
        this.scroller.scrollEdge(Edge.Top);
      }
    });
    this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
      Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    });

    this.onMenuClicked = this.onMenuClicked.bind(this);
    this.onMenuClickedForSingleItem = this.onMenuClickedForSingleItem.bind(this);
    Log.info(TAG, 'aboutToAppear doing');
    this.mSelectManager.setPhotoDataImpl();

    this.broadCast.on(BroadCastConstants.SELECT,
      (index: number, id: string, isSelected: boolean, callback?: Function) => {
        if (self.mSelectManager.toggle(id, isSelected, index)) {
          if (!self.isSelectedMode) {
            self.isSelectedMode = true;
          }
        }
        callback();
      });
    this.broadCast.on(BroadCastConstants.GROUP_SELECT, (position: number) => {
      Log.info(TAG, `GROUP_SELECT ${position}`);
      if (self.mSelectManager.toggleGroup(self.mSelectManager.getTitleCoordinate(position))) {
        self.totalSelectedCount = self.mSelectManager.getSelectedCount();
      }
    });
    this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaItem, geometryTapIndex: number,
                                                              geometryTransitionString: string) => {
      let targetIndex = self.dataSource.getDataIndex(item);
      if (targetIndex == Constants.NOT_FOUND) {
        Log.error(TAG, 'targetIndex is not found');
        return;
      }
      AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
      if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
        this.jumpToPhotoBrowserGeometryTransition(targetIndex, name, item, geometryTapIndex, geometryTransitionString);
      } else {
        this.jumpToPhotoBrowserNormal(targetIndex, name, item);
      }
    });
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaItem,
                                                                    geometryTapIndex: number,
                                                                    geometryTransitionString: string) => {
      let targetIndex = self.dataSource.getDataIndex(item);
      if (targetIndex == Constants.NOT_FOUND) {
        Log.error(TAG, 'targetIndex is not found');
        return;
      }
      Log.info(TAG, `JUMP_THIRD_PHOTO_BROWSER.index: ${targetIndex} transition: ${name}`);
      AppStorage.SetOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, self.mSelectManager);
      AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
      if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
        this.jumpToSelectPhotoBrowserGeometryTransition(
          targetIndex, name, item, geometryTapIndex, geometryTransitionString);
      } else {
        this.jumpToSelectPhotoBrowserNormal(targetIndex, name, item);
      }
    });

    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, () => {
      Log.info(TAG, 'ON_DATA_RELOADED');
      if (this.deleteMode) {
        animateTo({
          duration: 300, // 删除动画时长
          curve: Curves.cubicBezier(0.0, 0.0, 0.2, 1.0) // 减速曲线参数
        }, () => {
          this.dataSource.onDataReloaded();
        })
        this.deleteMode = false;
      } else {
        this.dataSource.onDataReloaded();
      }
    });

    this.broadCast.on(BroadCastConstants.INIT_DATE_TEXT, () => {
      let scrollMediaItem = this.dataSource.getMediaItemByPosition(0);
      this.dateText = DateUtil.getLocalizedYearAndMonth(scrollMediaItem.getDataTaken());
    })

    this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
      Log.info(TAG, `allSelect ${newState}`);
      self.isAllSelected = newState;
      self.dataSource.forceUpdate();
    }));

    this.mSelectManager.registerCallback('updateGroupCount', this.freezeAdapter(() => {
      Log.info(TAG, 'updateGroupCount');
      self.updateGroupSelectMode();
    }));

    this.mSelectManager.registerCallback('updateCount', this.freezeAdapter((newState: number) => {
      Log.info(TAG, `mSelectManager updateCount ${newState}`);
      self.totalSelectedCount = newState;
      self.moreMenuList = Boolean(newState) ? [Action.ADD, Action.INFO]
                                            : [Action.ADD_INVALID, Action.INFO_INVALID];
    }));
    this.initGridRowCount();
    this.updateGroupSelectMode();
    this.updateYearMap();
    this.onActive();
    TraceControllerUtils.finishTrace('TimelinePageAboutToAppear');
  }

  jumpToPhotoBrowserNormal(targetIndex: number, name: string, item: MediaItem) {
    router.pushUrl({
      url: 'pages/PhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        leftBlank: this.leftBlank,
      }
    });
  }

  jumpToPhotoBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem, geometryTapIndex: number,
                                       geometryTransitionString: string) {
    this.browserController.showBrowser(geometryTapIndex, geometryTransitionString, TAG, {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
    });
  }

  jumpToSelectPhotoBrowserNormal(targetIndex: number, name: string, item: MediaItem) {
    router.pushUrl({
      url: 'pages/SelectPhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
      }
    });
  }

  jumpToSelectPhotoBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem,
                                             geometryTapIndex: number, geometryTransitionString: string) {
    this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, TAG, {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
    });
  }

  onPageShow() {
  }

  aboutToDisappear(): void {
    Log.debug(TAG, 'aboutToDisappear');
    this.broadCast.off(null, null);
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.onWindowSizeChangeCallBack = null;
    if (this.dataSource != null) {
      this.dataSource.unregisterCallback('updateGroupData');
      this.dataSource.unregisterCallback('updateCount');
    }
    if (this.appBroadCast != null) {
      this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, null);
      this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, null);
      this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, null);
      this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, null);
      this.appBroadCast.off(BroadCastConstants.RESET_ZERO, null);
    }
  }

  updateGroupSelectMode() {
    if (this.groupSelectMode.length == 0) {
      Log.info(TAG, 'first updateGroupSelectMode')
      for (let i = 0; i < this.dataSource.groups.length; i++) {
        this.groupSelectMode.push(this.mSelectManager.isGroupSelected(i));
      }
    } else {
      Log.info(TAG, 'no first updateGroupSelectMode')
      for (let i = 0; i < this.dataSource.groups.length; i++) {
        Log.info(TAG, 'update one');
        this.groupSelectMode[i] = this.mSelectManager.isGroupSelected(i);
      }
    }
  }

  updateRightClickMenuList() {
    this.rightClickMenuList = this.isSelectedMode
      ? [Action.DELETE, Action.ADD, Action.INFO]
      : [Action.MULTISELECT, Action.DELETE, Action.ADD, Action.INFO];
  }

  updateYearMap() {
    Log.info(TAG, 'updateYearMap');
    if (this.dataSource.groups.length == 0) {
      Log.error(TAG, 'year length is 0');
      return;
    }
    this.yearData = [];
    let count = this.dataSource.groups[0].count;
    let startTime = this.dataSource.groups[0].startDate;
    let endTime = this.dataSource.groups[0].startDate;
    for (let i = 1; i < this.dataSource.groups.length; i++) {
      let dateTaken = this.dataSource.groups[i].startDate;
      if (DateUtil.isTheSameYear(startTime, dateTaken)) {
        count = count + this.dataSource.groups[i].count;
        endTime = dateTaken;
      } else {
        let groupData = new TimelineData(startTime, endTime, count);
        this.yearData.push(groupData);
        count = this.dataSource.groups[i].count;
        startTime = dateTaken;
        endTime = dateTaken;
      }
    }
    let groupData = new TimelineData(startTime, endTime, count);
    this.yearData.push(groupData);
    Log.info(TAG, 'updateYearMap end');
  }

  onIndexChange() {
    Log.info(TAG, `onIndexChange ${this.TimelinePageIndex}`);
    if (this.TimelinePageIndex != Constants.INVALID) {
      this.scroller.scrollToIndex(this.dataSource.getPositionByIndex(this.TimelinePageIndex));
    }
  }

  onIndexBackPress(callback: Function): void {
    if (this.isInCurrentTab) {
      callback(this.onModeChange());
    }
  }

  onTabChanged(index: number): void {
    if (index == Constants.TIMELINE_PAGE_INDEX) {
      this.isInCurrentTab = true;
      this.onActive();
    } else {
      this.isInCurrentTab = false;
      this.onModeChange();
      this.onInActive();
    }
  }

  onStateReset(index: number): void {
    if (index == Constants.TIMELINE_PAGE_INDEX) {
      this.onModeChange();
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, actionID: ${action.actionID}`);
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    switch (action) {
      case Action.CANCEL:
        this.onModeChange();
        break;
      case Action.MULTISELECT:
        this.isSelectedMode = true;
        break;
      case Action.SELECT_ALL:
        this.mSelectManager.selectAll(true);
        break;
      case Action.DESELECT_ALL:
        this.mSelectManager.deSelectAll();
        break;
      case Action.DELETE:
        menuContext = new MenuContext();
        this.onDeleteStart = this.onDeleteStart.bind(this);
        this.onDeleteEnd = this.onDeleteEnd.bind(this);
        menuContext
          .withSelectManager(this.mSelectManager)
          .withFromSelectMode(this.isSelectedMode)
          .withOperationStartCallback(this.onDeleteStart)
          .withOperationEndCallback(this.onDeleteEnd)
          .withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(BatchDeleteMenuOperation, menuContext);
        menuOperation.doAction();
        break;
      case Action.SHARE:
        menuContext = new MenuContext();
        menuContext.withFromSelectMode(true).withSelectManager(this.mSelectManager);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(ShareMenuOperation, menuContext);
        menuOperation.doAction();
        break;
      case Action.INFO:
        this.hidePopup = true;
        this.openDetailsDialog();
        break;
      case Action.ADD:
        this.mSelectManager.getSelectedItems((selectedItems: Array<MediaItem>) => {
          Log.info(TAG, `Get selected items success, size: ${selectedItems.length}`);
          this.routeToSelectAlbumPage(MediaOperationType.Add, selectedItems);
        })
        break;
      default:
        break;
    }
  }

  routeToSelectAlbumPage(pageType: string, selectedItems: Array<MediaItem>): void {
    Log.info(TAG, 'Route to select album page');
    router.pushUrl({
      url: 'pages/MediaOperationPage',
      params: {
        pageFrom: Constants.MEDIA_OPERATION_FROM_TIMELINE,
        pageType: pageType,
        selectedItems: selectedItems
      }
    });
    this.routerStart = true;
  }

  async openDetailsDialog(): Promise<void> {
    if (this.totalSelectedCount == 0) {
      Log.error(TAG, 'no select error');
      return;
    } else if (this.totalSelectedCount == 1) {
      Log.info(TAG, 'totalSelectedCount is 1');
      await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
        Log.info(TAG, `openDetailsDialog selectItems.length: ${selectItems.length}`);
        if (selectItems.length != 1) {
          Log.error(TAG, 'get selectItems is error');
          return;
        }
        this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [selectItems[0], false]);
      });
    } else {
      await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
        Log.info(TAG, `openDetailsDialog selectItems.length: ${selectItems.length}`);
        if (selectItems.length <= 1) {
          Log.error(TAG, 'get selectItems is error');
          return;
        }
        let size = 0;
        selectItems.forEach((item) => {
          Log.info(TAG, `openDetailsDialog item.size: ${item.size}`);
          size = size + item.size;
        })

        Log.info(TAG, `openDetailsDialog size: ${size}`);
        this.broadCast.emit(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG, [this.totalSelectedCount, size]);
      });
      return;
    }
  }

  onDeleteStart(): void {
    Log.info(TAG, `onDeleteStart`);
    this.deleteMode = true;
    this.isDataFreeze = true;
    this.dataSource.unregisterTimelineObserver();
    this.dataSource.freeze();
  }

  onDeleteEnd(): void {
    Log.info(TAG, `onDeleteEnd`);
    this.isDataFreeze = false;
    this.onModeChange();
    this.dataSource.registerTimelineObserver();
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
  }

  onCopyStart(): void {
    Log.info(TAG, `onCopyStart`);
    this.isDataFreeze = true;
    this.dataSource.unregisterTimelineObserver();
    this.dataSource.freeze();

  }

  onCopyEnd(err, count, total): void {
    Log.info(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    this.isDataFreeze = false;
    this.onModeChange();
    this.dataSource.registerTimelineObserver();
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  onMoveStart(): void {
    Log.info(TAG, `onMoveStart`);
    this.isDataFreeze = true;
    this.dataSource.unregisterTimelineObserver();
    this.dataSource.freeze();
  }

  onMoveEnd(err, count, total): void {
    Log.info(TAG, `onMoveEnd count: ${count}, total: ${total}`);
    this.isDataFreeze = false;
    this.onModeChange();
    this.dataSource.registerTimelineObserver();
    this.dataSource.unfreeze();
    this.dataSource.switchRefreshOn();
    this.dataSource.onChange('image');
    if (err) {
      UiUtil.showToast($r('app.string.move_failed_single'));
    }
  }

  // If the interface is frozen, the adapter function will be executed only when the page is not frozen
  freezeAdapter(fn): Function {
    let self = this;
    return function () {
      if (self.isDataFreeze) {
        return;
      }
      let context = this;
      let args = arguments;
      fn.apply(context, args);
    }
  }

  onModeChange() {
    Log.debug(TAG, `onModeChange current mode ${this.isSelectedMode}`);
    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      this.mSelectManager.onModeChange(false);
      this.updateGroupSelectMode();
      AppStorage.Delete(Constants.PHOTO_GRID_SELECT_MANAGER);
      return true;
    }
    return false;
  }

  // The callbacks after index page shows
  onIndexPageShow() {
    Log.info(TAG, `[onIndexPageShow] isShow=${this.isShow}, isInCurrentTab=${this.isInCurrentTab}`);
    if (this.isShow && this.isInCurrentTab) {
      let params: any = router.getParams();
      if (this.routerStart && params != null && params.pageType != null) {
        Log.info(TAG, `MediaOperation back ${JSON.stringify(params)}`)
        switch (params.pageType) {
          case MediaOperationType.Add:
            this.addOperation(params.albumName, params.albumUri);
            break;
          default:
            break;
        }
      }
      this.routerStart = false;
      this.onActive();
    } else if (!this.isShow && this.isInCurrentTab) {
      this.onInActive();
    } else {
    }
  }

  // The callback when current page is in the foreground
  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;

      this.dataSource.onActive();
      if (this.isSelectedMode) {
        this.totalSelectedCount = this.mSelectManager.getSelectedCount();
        this.dataSource.forceUpdate();
      }
    }
  }

  // The callback when current page is in the background
  onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.dataSource.onInActive();
    }
  }

  getGeometryTransitionId(item: ViewData, index: number): string {
    return TAG + item.mediaItem.getHashCode() + this.mSelectManager.isItemSelected(item.mediaItem.uri, item.viewIndex);
  }

  build() {
    Stack() {
      Column() {
        if (this.isEmpty) {
          NoPhotoIndexComponent({ index: Constants.TIMELINE_PAGE_INDEX, hasBarSpace: true })
        } else {
          TimelinePageActionBar({
            onMenuClicked: this.onMenuClicked,
            totalSelectedCount: $totalSelectedCount
          });

          Stack() {
            Grid(this.scroller) {
              LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
                if (!!item) {
                  if (item.viewType == ViewType.GROUP_TITLE) {
                    GridItem() {
                      TimelineTitleComponent({
                        groupData: item.viewData,
                        mPosition: item.viewIndex,
                        isSelected: this.groupSelectMode[item.viewIndex]
                      })
                    }.columnStart(0).columnEnd(this.gridRowCount - 1)
                    .key('TimelinePage_GridItem' + index)
                  } else if (item.viewType == ViewType.ITEM) {
                    GridItem() {
                      ImageGridItemComponent({
                        dataSource: this.dataSource,
                        item: item.mediaItem,
                        mPosition: item.viewIndex,
                        isSelected: this.isSelectedMode ? this.mSelectManager.isItemSelected(item.mediaItem.uri, item.viewIndex) : false,
                        pageName: Constants.PHOTO_TRANSITION_TIMELINE,
                        onMenuClicked: this.onMenuClicked,
                        onMenuClickedForSingleItem: this.onMenuClickedForSingleItem,
                        geometryTransitionString: this.getGeometryTransitionId(item, index),
                        selectedCount: $totalSelectedCount
                      })
                    }
                    .aspectRatio(1)
                    .key('TimelinePage_GridItem' + index)
                    .zIndex(index === this.placeholderIndex ? 1 : 0)
                  }
                }
              }, (item: ViewData, index?: number) => {
                if (item == null || item == undefined) {
                  return JSON.stringify(item) + index;
                }
                if (item.viewType == ViewType.GROUP_TITLE) {
                  return JSON.stringify(item.viewData) + this.groupSelectMode[item.viewIndex];
                } else {
                  return this.getGeometryTransitionId(item, index);
                }
              })
            }
            .edgeEffect(EdgeEffect.Spring)
            .columnsTemplate('1fr '.repeat(this.gridRowCount))
            .scrollBar(BarState.Off)
            .columnsGap(Constants.GRID_GUTTER)
            .rowsGap(Constants.GRID_GUTTER)
            .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
            .onScrollIndex((first) => {
              let scrollMediaItem = this.dataSource.getMediaItemByPosition(first);
              if (scrollMediaItem?.getDataTaken()) {
                this.dateText = DateUtil.getLocalizedYearAndMonth(scrollMediaItem.getDataTaken());
                Log.debug(TAG, `scrollIndex=${first}, dateTaken=${scrollMediaItem.getDataTaken()}`);
              } else {
                Log.warn(TAG, `scrollIndex ${first} out of active window`);
              }
            })

            if (this.isShowScrollBar) {
              TimelineScrollBar({ scroller: this.scroller })
            }
          }
          .layoutWeight(1)
        }
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({
        bottom: this.isHorizontal ? 0 : $r('app.float.tab_bar_vertical_height')
      })

      if (this.isSelectedMode) {
        TimelinePageToolBar({
          onMenuClicked: this.onMenuClicked,
          totalSelectedCount: $totalSelectedCount
        })
      }
      CustomDialogView({ broadCast: $broadCast })
    }
  }

  private onMenuClickedForSingleItem(action: Action, currentPhoto: MediaItem) {
    Log.info(TAG, `single menu click, action: ${action?.actionID}, currentUri: ${currentPhoto?.uri}`);
    if (currentPhoto == undefined) {
      return;
    }
    let menuOperation: MenuOperation;
    let menuContext: MenuContext;
    switch (action) {
      case Action.DELETE:
        menuContext = new MenuContext();
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(DeleteMenuOperation, menuContext);
        menuOperation.doAction();
        break;
      case Action.ADD:
        this.isMvOrCpSeparatesItem = true;
        this.mvOrCpSeparatesItem = currentPhoto;
        this.routeToSelectAlbumPage(MediaOperationType.Add, [currentPhoto]);
        break;
      case Action.INFO:
        this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [currentPhoto, false]);
        break;
      default:
        break;
    }
  }

  // Calculate the number of squares per row
  private initGridRowCount(): void {
    let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
    let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    let newCount = Math.max(Constants.GRID_MIN_COUNT,
      Math.round(((contentWidth - Constants.NUMBER_2 * margin)
      + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
    if (newCount != this.gridRowCount) {
      this.gridRowCount = newCount;
      //            this.dataSource.forceUpdate();
    }
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
  }

  private async addOperation(albumName: string, albumUri: string) {
    let menuContext = new MenuContext();
    this.onCopyStart = this.onCopyStart.bind(this);
    this.onCopyEnd = this.onCopyEnd.bind(this);
    if (this.isMvOrCpSeparatesItem) {
      menuContext.withMediaItem(this.mvOrCpSeparatesItem);
      this.onCopyStart && this.onCopyStart();
      this.isMvOrCpSeparatesItem = false;
      this.mvOrCpSeparatesItem = null;
    } else {
      menuContext.withSelectManager(this.mSelectManager).withOperationStartCallback(this.onCopyStart);
    }
    menuContext.withOperationEndCallback(this.onCopyEnd).withBroadCast(this.broadCast)
      .withTargetAlbumName(albumName).withAlbumUri(albumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private onUpdateFavorState(item: MediaItem): void {
    Log.debug(TAG, 'onUpdateFavorState favor');
    let index = this.dataSource.getIndexByMediaItem(item);
    if (index != -1) {
      let flushIndex = this.dataSource.getPositionByIndex(index);
      Log.debug(TAG, `onUpdateFavorState favor flushIndex ${flushIndex}`);
      this.dataSource.onDataChanged(flushIndex);
    }
  }
}
