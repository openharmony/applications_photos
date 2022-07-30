/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { ImageGridItemComponent } from '../../../common/view/ImageGridItemComponent'
import { TimelineDataSource } from '../model/TimelineDataSource'
import { TimelineData } from '../../../common/model/browser/photo/TimelineData'
import { TimelineTitleComponent } from './timelinetitlecomponent'
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView'
import { Logger } from '../utils/Logger'
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import { Constants } from '../../../common/model/common/Constants'
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { MenuOperationFactory } from '../../../common/interface/MenuOperationFactory'
import { BatchDeleteMenuOperation } from '../../../common/view/browserOperation/BatchDeleteMenuOperation';
import { ViewType } from '../../../common/model/browser/photo/ViewType'
import { Action } from '../../../common/view/browserOperation/Action'
import { BroadCast } from '../../../common/utils/BroadCast'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { TimelineSelectManager } from '../../../common/model/browser/SelectManager'
import { MediaItem } from '../../../common/model/browser/photo/MediaItem'
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent'
import { ScreenManager } from '../../../common/model/common/ScreenManager'
import router from '@system.router'
import { TraceControllerUtils } from '../../../common/utils/TraceControllerUtils'
import { TimelineDataSourceManager } from '../model/TimelineDataSourceManager';
import { ShareMenuOperation } from '../../../common/view/browserOperation/ShareMenuOperation';
import { CommonObserverCallback } from '../../../common/model/browser/CommonObserverCallback';
import { MediaObserver } from '../../../common/model/browser/dataObserver/MediaObserver';
import { UiUtil } from '../../../common/utils/UiUtil';
import { MediaOperationType } from '../../../common/model/common/MediaOperationType'
import { MoveMenuOperation } from '../../../common/view/browserOperation/MoveMenuOperation';
import { CopyMenuOperation } from '../../../common/view/browserOperation/CopyMenuOperation';
import { TimelineScrollBar } from './TimelineScrollBar';
import { DateUtil } from '../../../common/utils/DateUtil';
import { AlbumInfo } from '../../../common/model/browser/album/AlbumInfo';
import { TimelinePageBarModel } from '../model/TimelinePageBarModel'
import { ActionBar } from '../../../common/view/actionbar/ActionBar'

// PHOTO Page
@Component
export struct TimelinePage {
    @State isEmpty: boolean = false;
    @Provide isHideScrollBar: boolean = true;
    @StorageProp('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageProp('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @State gridRowCount: number = 0;
    @Consume isSelectedMode: boolean;
    @Provide isAllSelected: boolean = false;
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @Provide broadCast: BroadCast = TimelineDataSourceManager.getInstance().getBroadCast();
    @Consume @Watch('onIndexPageShow') isShow: boolean;
    @StorageLink('TimelinePageIndex') @Watch('onIndexChange') TimelinePageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    dataSource: TimelineDataSource;
    logger: Logger = new Logger('TimelinePage');
    mSelectManager: TimelineSelectManager = new TimelineSelectManager();
    scroller: Scroller = new Scroller();
    appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    isInCurrentTab = false; // Is it on the current tab page
    dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    isDataFreeze = false; // Is the page data frozen
    deleteMode = false; // Is delete mode
    isActive = false; // Is the page active
    @State initLoadFinish: boolean = false; // Is first patch load finished
    routerStart = false; // Is move or copy router page
    @Provide moreMenuList: Action[] = new Array<Action>();
    @State groupSelectMode: boolean[] = [];
    @Provide yearData: TimelineData[] = [];
    @Provide dateText: string = '';
    @Provide isShowBar: boolean = true;
    private barModel = new TimelinePageBarModel()

    aboutToAppear(): void {
        TraceControllerUtils.startTrace('TimelinePageAboutToAppear');
        this.logger.info('aboutToAppear');
        let self = this;
        this.dataSource = TimelineDataSourceManager.getInstance().getDataSource();
        let params = router.getParams();
        if (params != null && params.pageFrom && params.pageFrom == Constants.ENTRY_FROM.CAMERA) {
            this.dataSource.initData();
        }
        this.mSelectManager.setGroupData(this.dataSource.getGroupData());
        this.mSelectManager.setTotalCount(this.dataSource.getMediaCount());
        this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];
        this.isEmpty = !Boolean(this.dataSource.getMediaCount());
        this.initLoadFinish = Boolean(this.dataSource.getMediaCount());
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.registerCallback('updateGroupData', (newState: TimelineData[]) => {
            self.mSelectManager.updateGroupData(newState);
            self.updateYearMap();
        });
        this.dataSource.registerCallback('updateCount', (newState: number) => {
            self.logger.info(`updateCount ${newState}`);
            self.isEmpty = !Boolean(newState);
            self.isHideScrollBar = (newState <= Constants.SCROLL_BAR_VISIBLE_THRESHOLD);
            self.mSelectManager.setTotalCount(newState);
        });

        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.initGridRowCount();
        });

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
            this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
        });

        this.broadCast.on(Constants.FIRST_PATCH_LOAD_FINISH, (size: number) => {
            this.logger.info(`FIRST_PATCH_LOAD_FINISH size: ${size}`);
            this.initLoadFinish = true;
        });

        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.logger.info('aboutToAppear');
        this.mSelectManager.setPhotoDataImpl();

        this.broadCast.on(BroadCastConstants.SELECT,
            (index: number, id: string, isSelected: boolean, callback?: Function) => {
                if (self.mSelectManager.toggle(id, isSelected, index)) {
                    self.totalSelectedCount = self.mSelectManager.getSelectedCount();
                    if (!self.isSelectedMode) {
                        self.isSelectedMode = true;
                    }
                }
                callback();
            });
        this.broadCast.on(BroadCastConstants.GROUP_SELECT, (position: number) => {
            self.logger.info(`GROUP_SELECT ${position}`);
            if (self.mSelectManager.toggleGroup(self.mSelectManager.getTitleCoordinate(position))) {
                self.totalSelectedCount = self.mSelectManager.getSelectedCount();
            }
        });
        this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaItem) => {
            let targetIndex = self.dataSource.getDataIndex(item);
            if (targetIndex == Constants.NOT_FOUND) {
                self.logger.error('targetIndex is not found');
                return;
            }
            AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
            router.push({
                uri: 'feature/browser/view/photo/PhotoBrowser',
                params: {
                    position: targetIndex,
                    transition: name,
                    leftBlank: self.leftBlank,
                }
            });
        });
        this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaItem) => {
            let targetIndex = self.dataSource.getDataIndex(item);
            if (targetIndex == Constants.NOT_FOUND) {
                self.logger.error('targetIndex is not found');
                return;
            }
            self.logger.info(`JUMP_THIRD_PHOTO_BROWSER.index: ${targetIndex} transition: ${name}`);
            AppStorage.SetOrCreate(Constants.THIRD_SELECT_MANAGER, self.mSelectManager);
            AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
            router.push({
                uri: 'feature/browser/view/photo/SelectPhotoBrowser',
                params: {
                    position: targetIndex,
                    transition: name,
                }
            });
        });

        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, () => {
            this.logger.info('ON_DATA_RELOADED');
            if (this.deleteMode) {
                animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, () => {
                    this.dataSource.onDataReloaded();
                })
                this.deleteMode = false;
            } else {
                this.dataSource.onDataReloaded();
            }
        });

        this.broadCast.on(BroadCastConstants.INIT_DATE_TEXT, () => {
            let scrollMediaItem = this.dataSource.getMediaItemByPosition(0);
            this.dateText = DateUtil.getLocalizedYearAndMonth(scrollMediaItem.dateTaken);
        })

        this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
            self.logger.info(`allSelect ${newState}`);
            self.isAllSelected = newState;
            self.dataSource.forceUpdate();
        }));

        this.mSelectManager.registerCallback('updateGroupCount', this.freezeAdapter(() => {
            self.logger.info('updateGroupCount');
            self.updateGroupSelectMode();
        }));

        this.mSelectManager.registerCallback('updateCount', this.freezeAdapter((newState: number) => {
            self.logger.info(`mSelectManager updateCount ${newState}`);
            self.totalSelectedCount = newState;
            self.moreMenuList = Boolean(newState) ? [Action.MOVE, Action.COPY, Action.INFO]
                                                  : [Action.MOVE_INVALID, Action.COPY_INVALID, Action.INFO_INVALID];
        }));
        this.isInCurrentTab = true;
        this.initGridRowCount();
        this.updateGroupSelectMode();
        this.updateYearMap();
        this.onActive();
        TraceControllerUtils.finishTrace('TimelinePageAboutToAppear');
    }

    aboutToDisappear(): void {
        this.logger.info('TimelinePageAboutToDisappear');
        this.dataSource.unregisterCallback('updateGroupData');
        this.dataSource.unregisterCallback('updateCount');
        this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        this.broadCast.off(null, null)
        TimelineDataSourceManager.destroyInstance()
    }

    // Calculate the number of squares per row
    private initGridRowCount(): void {
        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
        let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        let newCount = Math.max(Constants.GRID_MIN_COUNT,
        Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        if (newCount != this.gridRowCount) {
            if (this.gridRowCount == 0) {
                this.gridRowCount = newCount;
            } else {
                this.gridRowCount = newCount;
                this.dataSource.forceUpdate();
            }
        }
        this.logger.info(`initGridRowCount contentWidth: ${contentWidth}`);
    }

    private moveOperation(albumInfo: AlbumInfo) {
        let menuContext = new MenuContext();
        this.onMoveStart = this.onMoveStart.bind(this);
        this.onMoveEnd = this.onMoveEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onMoveStart)
            .withOperationEndCallback(this.onMoveEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private copyOperation(albumInfo: AlbumInfo) {
        let menuContext = new MenuContext();
        this.onCopyStart = this.onCopyStart.bind(this);
        this.onCopyEnd = this.onCopyEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onCopyStart)
            .withOperationEndCallback(this.onCopyEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
        menuOperation.doAction();
    }

    updateGroupSelectMode() {
        if (this.groupSelectMode.length == 0) {
            this.logger.info('first updateGroupSelectMode')
            for (let i = 0; i < this.dataSource.groups.length; i++) {
                this.groupSelectMode.push(this.mSelectManager.IsGroupSelected(i));
            }
        } else {
            this.logger.info('no first updateGroupSelectMode')
            for (let i = 0; i < this.dataSource.groups.length; i++) {
                this.logger.info('update one');
                this.groupSelectMode[i] = this.mSelectManager.IsGroupSelected(i);
            }
        }
    }

    updateYearMap() {
        this.logger.info('updateYearMap');
        if (this.dataSource.groups.length == 0) {
            this.logger.error('year length is 0');
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
        this.logger.info('updateYearMap end');
    }

    onIndexChange() {
        this.logger.info(`onIndexChange ${this.TimelinePageIndex}`);
        if (this.TimelinePageIndex != Constants.INVALID) {
            this.scroller.scrollToIndex(this.dataSource.getPositionByIndex(this.TimelinePageIndex));
        }
    }

    onIndexBackPress(callback: Function): void {
        if (this.isInCurrentTab) {
            callback(this.onModeChange());
        }
    }

    private onUpdateFavorState(item: MediaItem): void {
        this.logger.debug('onUpdateFavorState favor');
        let index = this.dataSource.getIndexByMediaItem(item);
        if (index != -1) {
            let flushIndex = this.dataSource.getPositionByIndex(index);
            this.logger.debug(`onUpdateFavorState favor flushIndex ${flushIndex}`);
            this.dataSource.onDataChanged(flushIndex);
        }
    }

    onTabChanged(index: number): void {
        if (index == Constants.TIMELINE_PAGE_INDEX) {
            this.isInCurrentTab = true;
            this.onActive();
        } else {
            this.isInCurrentTab = false;
            this.onInActive();
        }
    }

    onStateReset(index: number): void {
        if (index == Constants.TIMELINE_PAGE_INDEX) {
            this.onModeChange();
        }
    }

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, actionID: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.CANCEL:
                this.onModeChange();
                break;
            case Action.SELECT_ALL:
                this.mSelectManager.selectAll(true);
                break;
            case Action.DESELECT_ALL:
                this.mSelectManager.unselectAll();
                break;
            case Action.DELETE:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(BatchDeleteMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            case Action.SHARE:
                menuContext = new MenuContext();
                menuContext.withSelectManager(this.mSelectManager);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(ShareMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            case Action.INFO:
                this.openDetailsDialog();
                break;
            case Action.MOVE:
                this.routeSelectAlbumPage(MediaOperationType.Move);
                break;
            case Action.COPY:
                this.routeSelectAlbumPage(MediaOperationType.Copy);
                break;
            default:
                break;
        }
    }

    routeSelectAlbumPage(pageType: string): void {
        router.push({
            uri: "common/view/browserOperation/MediaOperationPage",
            params: {
                pageType: pageType
            }
        });
        this.routerStart = true;
    }

    onMediaLibDataChange(changeType) {
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        this.dataSource.onChange(changeType);
    }

    async openDetailsDialog(): Promise<void> {
        if (this.totalSelectedCount == 0) {
            this.logger.error('no select error');
            return;
        } else if (this.totalSelectedCount == 1) {
            this.logger.info('totalSelectedCount is 1');
            await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
                this.logger.info(`openDetailsDialog selectItems.length: ${selectItems.length}`);
                if (selectItems.length != 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [selectItems[0], false]);
            });
        } else {
            await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
                this.logger.info(`openDetailsDialog selectItems.length: ${selectItems.length}`);
                if (selectItems.length <= 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                let size = 0;
                selectItems.forEach((item) => {
                    this.logger.info(`openDetailsDialog item.size: ${item.size}`);
                    size = size + item.size;
                })

                this.logger.info(`openDetailsDialog size: ${size}`);
                this.broadCast.emit(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG, [this.totalSelectedCount, size]);
            });
            return;
        }
    }

    onDeleteStart(): void {
        this.logger.info(`onDeleteStart`);
        this.deleteMode = true;
        this.isDataFreeze = true;
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        this.dataSource.freeze();
    }

    onDeleteEnd(): void {
        this.logger.info(`onDeleteEnd`);
        this.isDataFreeze = false;
        TraceControllerUtils.startTrace('onModeChange');
        this.onModeChange();
        TraceControllerUtils.finishTrace('onModeChange');
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
    }

    onCopyStart(): void {
        this.logger.info(`onCopyStart`);
        this.isDataFreeze = true;
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        this.dataSource.freeze();

    }

    onCopyEnd(err, count, total): void {
        this.logger.info(`onCopyEnd count: ${count}, total: ${total}`);
        this.isDataFreeze = false;
        TraceControllerUtils.startTrace('onModeChange');
        this.onModeChange();
        TraceControllerUtils.finishTrace('onModeChange');
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
        if (err) {
            UiUtil.showToast($r('app.string.copy_failed_single'));
        }
    }

    onMoveStart(): void {
        this.logger.info(`onMoveStart`);
        this.isDataFreeze = true;
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        this.dataSource.freeze();
    }

    onMoveEnd(err, count, total): void {
        this.logger.info(`onMoveEnd count: ${count}, total: ${total}`);
        this.isDataFreeze = false;
        TraceControllerUtils.startTrace('onModeChange');
        this.onModeChange();
        TraceControllerUtils.finishTrace('onModeChange');
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.unfreeze();
        this.dataSource.switchRefreshOn();
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
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
        this.logger.debug('onModeChange');
        if (this.isSelectedMode) {
            this.isSelectedMode = false;
            this.mSelectManager.onModeChange(false);
            return true;
        }
        return false;
    }

    // The callbacks after index page shows
    onIndexPageShow() {
        this.logger.info(`onIndexPageShow`)
        if (this.isShow && this.isInCurrentTab) {
            let params = router.getParams();
            if (this.routerStart && params != null && params.pageType != null) {
                this.logger.info(`MediaOperation back ${JSON.stringify(params)}`)
                switch (params.pageType) {
                    case MediaOperationType.Move:
                        this.moveOperation(JSON.parse(params.albumInfo.toString()));
                        break;
                    case MediaOperationType.Copy:
                        this.copyOperation(JSON.parse(params.albumInfo.toString()));
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
            this.logger.info('onActive');
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
            this.logger.info('onInActive');
            this.isActive = false;
            this.dataSource.onInActive();
        }
    }

    build() {
        Stack() {
            Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Start,
                alignItems: ItemAlign.Start
            }) {
                if (this.isEmpty || !this.initLoadFinish) {
                    NoPhotoIndexComponent({ index: Constants.TIMELINE_PAGE_INDEX })
                } else {
                    ActionBar({
                        actionBarProp: this.barModel.createActionBar(this.isSelectedMode, this.totalSelectedCount, this.isAllSelected),
                        onMenuClicked: this.onMenuClicked
                    })

                    Stack() {
                        Grid(this.scroller) {
                            LazyForEach(this.dataSource, (item) => {
                                if (item.viewType == ViewType.GROUP_TITLE) {
                                    GridItem() {
                                        TimelineTitleComponent({
                                            groupData: item.viewData,
                                            position: item.viewIndex,
                                            isSelected: this.groupSelectMode[item.viewIndex]
                                        })
                                    }.columnStart(0).columnEnd(this.gridRowCount - 1)
                                } else {
                                    GridItem() {
                                        ImageGridItemComponent({
                                            item: item.viewData.mediaItem,
                                            position: item.viewIndex,
                                            isSelected: this.isSelectedMode ? this.mSelectManager.isItemSelected(item.viewData.mediaItem.uri, item.viewIndex) : false,
                                            pageName: Constants.PHOTO_TRANSITION_TIMELINE
                                        })
                                    }
                                    .columnStart(item.indexInGroup % this.gridRowCount)
                                    .columnEnd(item.indexInGroup % this.gridRowCount)
                                }
                            }, item => item == null ? JSON.stringify(item) : (item.viewType == ViewType.GROUP_TITLE ? item.viewData : item.mediaItem.uri))
                        }
                        .columnsTemplate('1fr '.repeat(this.gridRowCount))
                        .columnsGap(Constants.GRID_GUTTER)
                        .rowsGap(Constants.GRID_GUTTER)
                        .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
                        .onScrollIndex((first) => {
                            this.logger.debug(`onScrollIndex index ${first}`)
                            let scrollMediaItem = this.dataSource.getMediaItemByPosition(first);
                            if (scrollMediaItem) {
                                this.dateText = DateUtil.getLocalizedYearAndMonth(scrollMediaItem.dateTaken);
                            } else {
                                this.logger.error('index out of active window');
                            }
                        })

                        Column() {
                            TimelineScrollBar({ scroller: this.scroller })
                        }
                        .position({ x: '100%', y: 0 })
                        .markAnchor({
                            x: '100%',
                            y: 0
                        })
                    }
                    .layoutWeight(1)
                    .padding({
                        bottom: this.isSidebar ? 0 : $r('app.float.album_set_tab_bar_height')
                    })
                }
            }

            ToolBar({
                isShowBar: this.isSelectedMode,
                toolMenuList: this.barModel.getMenuList(this.isSelectedMode, this.totalSelectedCount, this.isAllSelected),
                onMenuClicked: this.onMenuClicked
            })
            CustomDialogView()
        }
    }
}
