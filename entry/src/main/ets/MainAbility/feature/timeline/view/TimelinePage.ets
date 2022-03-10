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

import {ImageGridItemComponent} from '../../../common/view/ImageGridItemComponent'
import {TimelineDataSource} from '../model/TimelineDataSource'
import {TimelineData} from '../../../common/model/browser/photo/TimelineData.ets'
import {TimelineTitleComponent} from '../../../common/view/TimelineTitleComponent'
import {CustomDialogView} from '../../../common/view/dialog/CustomDialogView'
import {Logger} from '../utils/Logger'
import {TimelinePageActionBar} from './TimelinePageActionBar'
import {TimelinePageToolBar} from './TimelinePageToolBar'
import {Constants} from '../../../common/model/common/Constants.ets'
import {MenuOperation} from '../../../common/model/browser/operation/MenuOperation'
import {MenuContext} from '../../../common/model/browser/operation/MenuContext'
import {MenuOperationFactory} from '../../../common/model/browser/interface/MenuOperationFactory.ets'
import {BatchDeleteMenuOperation} from '../../../common/model/browser/operation/BatchDeleteMenuOperation.ets';
import {ViewType} from '../../../common/model/browser/photo/ViewType'
import {Action} from '../../../common/model/browser/operation/Action'
import {BroadCast} from '../../../common/utils/BroadCast'
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../common/model/common/BroadCastManager'
import {TimelineSelectManager} from '../../../common/model/browser/SelectManager'
import {MediaItem} from '../../../common/model/browser/photo/MediaItem'
import {NoPhotoIndexComponent} from '../../../common/view/NoPhotoIndexComponent'
import {ScreenManager} from '../../../common/model/common/ScreenManager'
import router from '@system.router'
import {TraceControllerUtils} from '../../../common/utils/TraceControllerUtils'
import {TimelineDataSourceManager} from '../model/TimelineDataSourceManager';
import {ShareMenuOperation} from '../../../common/model/browser/operation/ShareMenuOperation.ets';

import {MediaOperationType} from '../../../common/model/common/MediaOperationType'
import {MoveMenuOperation} from '../../../common/model/browser/operation/MoveMenuOperation';
import {CopyMenuOperation} from '../../../common/model/browser/operation/CopyMenuOperation';
import {TimelineScrollBar} from './TimelineScrollBar.ets';
import {DateUtil} from '../../../common/utils/DateUtil.ets';

AppStorage.SetOrCreate('TimelinePageIndex', Constants.INVALID)

// PHOTO Page
@Component
export struct TimelinePage {
    @State isEmpty: boolean = false;
    @Provide isHideScrollBar: boolean = true;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
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

    isDataFreeze = false; // Is the page data frozen
    deleteMode = false; // Is delete mode
    isActive = false; // Is the page active
    @Provide moreMenuList: Action[] = new Array<Action>();

    @State groupSelectMode: boolean[] = [];
    @Provide yearData: TimelineData[] = [];
    @Provide dateText: string = '';
    @Provide isShowBar: boolean = true;

    private aboutToAppear(): void {
        TraceControllerUtils.startTrace('TimelinePageAboutToAppear');
        let self = this;
        this.dataSource = TimelineDataSourceManager.getInstance().getDataSource();
        this.mSelectManager.setGroupData(this.dataSource.getGroupData());
        this.mSelectManager.setTotalCount(this.dataSource.getMediaCount());
        this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];
        this.isEmpty = !Boolean(this.dataSource.getMediaCount());
        this.dataSource.registerCallback('updateGroupData', (newState: TimelineData[]) => {
            self.mSelectManager.updateGroupData(newState);
            self.updateYearMap();
        });
        this.dataSource.registerCallback('updateCount', (newState: number) => {
            self.logger.info(`updateCount ${newState}`);
            self.isHideScrollBar = (newState <= 50);
            self.mSelectManager.setTotalCount(newState);
        });

        if(AppStorage.Get('mainWindow') != null) {
            ScreenManager.getInstance().setMainWindow(AppStorage.Get('mainWindow'));
        }

        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.initGridRowCount();
        });

        this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_OPERATION_FINISHED, this.onUpdateDateSource.bind(this));
        this.appBroadCast.on(BroadCastConstants.RESET_ZERO, (pageNumber: number) => {
            if (pageNumber == Constants.TIMELINE_PAGE_INDEX) {
                this.scroller.scrollEdge(Edge.Top);
            }
        });
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
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
            self.logger.error(`targetIndex: ${targetIndex}`);
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
                animateTo({}, () => {
                    this.dataSource.onDataReloaded();
                })
                this.deleteMode = false;
            } else {
                this.dataSource.onDataReloaded();
            }
        });

        this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
            self.logger.info(`allSelect ${newState}`);
            self.isAllSelected = newState;
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

            if (self.isSelectedMode) {
                self.dataSource.forceUpdate();
            }
        }));
        this.isInCurrentTab = true;
        this.initGridRowCount();
        this.updateGroupSelectMode();
        this.updateYearMap();
        this.onActive();
        TraceControllerUtils.finishTrace('TimelinePageAboutToAppear');
    }

    private aboutToDisappear(): void {
        this.logger.debug('aboutToDisappear');
        this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_OPERATION_FINISHED, this.onUpdateDateSource.bind(this));
    }

    // Calculate the number of squares per row
    private initGridRowCount(): void {
        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
        let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT,
            Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
                + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        this.logger.info(`initGridRowCount contentWidth: ${contentWidth}`);
    }

    private moveOperation(albumName: string) {
        let menuContext = new MenuContext();
        this.onMoveStart = this.onMoveStart.bind(this);
        this.onMoveEnd = this.onMoveEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onMoveStart)
            .withOperationEndCallback(this.onMoveEnd)
            .withBroadCast(this.broadCast)
            .withAlbumName(albumName);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private copyOperation(albumName: string) {
        let menuContext = new MenuContext();
        this.onCopyStart = this.onCopyStart.bind(this);
        this.onCopyEnd = this.onCopyEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onCopyStart)
            .withOperationEndCallback(this.onCopyEnd)
            .withBroadCast(this.broadCast)
            .withAlbumName(albumName);
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
        if(this.dataSource.groups.length == 0) {
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

    private onUpdateDateSource(): void {
        this.logger.debug('onUpdateDateSource');
        this.dataSource.onChange('image');
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
                this.mSelectManager.deSelectAll();
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
            case Action.DOWNLOAD:
                this.onCopyStart = this.onCopyStart.bind(this);
                this.onCopyEnd = this.onCopyEnd.bind(this);
                menuContext
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onCopyStart)
                    .withOperationEndCallback(this.onCopyEnd)
                    .withBroadCast(this.broadCast)
                    .withAlbumName('FromOtherDevices');
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
                menuOperation.doAction();
            default:
                break;
        }
    }

    routeSelectAlbumPage(pageType: string): void {
        router.push({
            uri: "common/view/mediaOperation/MediaOperationPage",
            params: {
                pageType : pageType
            }
        });
    }

    async openDetailsDialog(): Promise<void> {
        if(this.totalSelectedCount == 0) {
            this.logger.error('no select error');
            return;
        } else if (this.totalSelectedCount == 1) {
            this.logger.info('totalSelectedCount is 1');
            await this.mSelectManager.getSelectedItems((selectItems:MediaItem[]) => {
                this.logger.info(`openDetailsDialog selectItems.length: ${selectItems.length}`);
                if (selectItems.length != 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [selectItems[0], false]);
            });
        } else {
            await this.mSelectManager.getSelectedItems((selectItems:MediaItem[]) => {
                this.logger.info(`openDetailsDialog selectItems.length: ${selectItems.length}`);
                if (selectItems.length <= 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                let size = 0;
                selectItems.forEach((item) =>{
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
        this.deleteMode = true;
        this.isDataFreeze = true;
        this.dataSource.freeze();
    }

    onDeleteEnd(uris: string[]): void {
        this.isDataFreeze = false;
        this.onModeChange();
        this.dataSource.unfreeze();
    }

    onCopyStart(): void {
        this.isDataFreeze = true;
        this.dataSource.freeze();
    }

    onCopyEnd(): void {
        this.isDataFreeze = false;
        this.onModeChange();
        this.dataSource.unfreeze();
    }

    onMoveStart(): void {
        this.isDataFreeze = true;
        this.dataSource.freeze();
    }

    onMoveEnd(): void {
        this.isDataFreeze = false;
        this.onModeChange();
        this.dataSource.unfreeze();
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
        if (this.isShow && this.isInCurrentTab) {
            this.onActive();
        } else if (!this.isShow && this.isInCurrentTab) {
            this.onInActive();
        } else {
        }
    }

    // The callback when current page is in the foreground
    onActive() {
        let params = router.getParams();
        if(params != null && params.pageType != null) {
            this.logger.info(`MediaOperation back ${JSON.stringify(params)}`)
            switch(params.pageType) {
                case MediaOperationType.Move:
                    this.moveOperation(params.albumName);
                    break;
                case MediaOperationType.Copy:
                    this.copyOperation(params.albumName);
                    break;
                default:
                    break;
            }
        }

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
        Stack(){
            Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Start,
                alignItems: ItemAlign.Start
            }) {
                TimelinePageActionBar({onMenuClicked: this.onMenuClicked});

                Stack() {
                    if (this.isEmpty) {
                        NoPhotoIndexComponent({
                            index: Constants.TIMELINE_PAGE_INDEX
                        })
                    } else {
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
                                    }.columnStart(item.indexInGroup % this.gridRowCount).columnEnd(item.indexInGroup % this.gridRowCount)
                                }
                            }, item => item == null ? JSON.stringify(item) : (item.viewType == ViewType.GROUP_TITLE ? item.viewData : item.mediaItem.uri))
                        }
                        .columnsTemplate('1fr '.repeat(this.gridRowCount))
                        .columnsGap(Constants.GRID_GUTTER)
                        .rowsGap(Constants.GRID_GUTTER)
                        .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
                        .padding({
                            bottom: this.isSidebar ? 0 : $r('app.float.album_set_tab_bar_height')
                        })
                        .onScrollIndex((first) => {
                            let index = this.dataSource.getPositionByIndex(first);
                            let dateTaken = this.dataSource.getMediaItemSafely(index).dateTaken;
                            this.dateText = DateUtil.getLocalizedYearAndMonth(dateTaken);
                        })

                        TimelineScrollBar({scroller: this.scroller})
                    }

                }
                .layoutWeight(1)


                if(this.isSelectedMode){
                    TimelinePageToolBar({
                        onMenuClicked: this.onMenuClicked
                    })
                }
            }

            CustomDialogView()
        }
    }
}
