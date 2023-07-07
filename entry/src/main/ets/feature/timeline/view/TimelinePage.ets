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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { ImageGridItemComponent } from '@ohos/base/src/main/ets/components/ImageGridItemComponent';
import {
    TimelineTitleComponent
} from '@ohos/timeline/src/main/ets/components/TimelineTitleComponent';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView';
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import { Constants } from '../../../common/model/common/Constants';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { BatchDeleteMenuOperation } from '@ohos/base/src/main/ets/operation/BatchDeleteMenuOperation';
import { ViewType } from '@ohos/base/src/main/ets/data/ViewType';
import { Action } from '../../../common/view/browserOperation/Action';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import router from '@system.router';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { ShareMenuOperation } from '@ohos/base/src/main/ets/operation/ShareMenuOperation';
import { CommonObserverCallback } from '@ohos/base/src/main/ets/observer/CommonObserverCallback';
import mediaObserver from '@ohos/base/src/main/ets/observer/MediaObserver';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { MediaOperationType } from '@ohos/base/src/main/ets/data/MediaOperationType';
import { MoveMenuOperation } from '@ohos/base/src/main/ets/operation/MoveMenuOperation';
import { CopyMenuOperation } from '@ohos/base/src/main/ets/operation/CopyMenuOperation';
import { TimelineScrollBar } from '@ohos/timeline/src/main/ets/components/TimelineScrollBar';
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { TimelinePageBarModel } from '../model/TimelinePageBarModel';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import {
    TimelineItemDataSource
} from '@ohos/timeline/src/main/ets/vm/TimelineItemDataSource';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { TimelineDataItem } from '@ohos/timeline/src/main/ets/data/TimelineDataItem';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { PhotoEditorManager } from '../../editor/PhotoEditorManager';

const TAG = "TimelinePage"
// PHOTO Page
@Component
export struct TimelinePage {
    @State isSelectUpperLimited: boolean = false;
    @State isEmpty: boolean = false;
    @State isHideScrollBar: boolean = true;
    @StorageProp('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageProp('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @State gridRowCount: number = 0;
    @Consume @Watch('updateActionBar') isSelectedMode: boolean;
    @Provide @Watch('updateActionBar') isAllSelected: boolean = false;
    @Provide('selectedCount') @Watch('updateActionBar') totalSelectedCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Consume @Watch('onIndexPageShow') isShow: boolean;
    @StorageLink('TimelinePageIndex') @Watch('onIndexChange') TimelinePageIndex: number = Constants.INVALID;
    scroller: Scroller = new Scroller();
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    isInCurrentTab = false; // Is it on the current tab page
    isActive = false; // Is the page active
    @State initLoadFinish: boolean = false; // Is first patch load finished
    routerStart = false; // Is move or copy router page
    @Provide moreMenuList: Action[] = new Array<Action>();
    @Provide dateText: string = '';
    private barModel = new TimelinePageBarModel();
    private timelineDataSource: TimelineItemDataSource = new TimelineItemDataSource();
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    private isMediaLibDataChanged: boolean = true;
    @State actionBarProp: ActionBarProp = new ActionBarProp();
    @State toolBarMenuList: Action[] = new Array<Action>();
    onWindowSizeChangeCallBack = () => this.initGridRowCount();

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(this.isSelectedMode,
                                        this.totalSelectedCount, this.isAllSelected);
		this.toolBarMenuList = this.barModel.getMenuList(this.isSelectedMode,
								this.totalSelectedCount, this.isAllSelected);
    }

    aboutToAppear(): void {
        startTrace('TimelinePageAboutToAppear');
        Log.info(TAG, 'aboutToAppear');
        this.moreMenuList = [Action.MOVE_INVALID, Action.COPY_INVALID, Action.INFO_INVALID];
        mediaObserver.registerObserver(this.dataObserver);
        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);

        this.appBroadcast.on(BroadcastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadcast.on(BroadcastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadcast.on(BroadcastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadcast.on(BroadcastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorAndSelectState.bind(this));
        this.appBroadcast.on(BroadcastConstants.RESET_ZERO, (pageNumber: number) => {
            if (pageNumber == Constants.TIMELINE_PAGE_INDEX) {
                this.scroller.scrollEdge(Edge.Top);
            }
        });
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
        });
        this.broadCast.on(BroadcastConstants.SELECT, (index: number) => this.onSelect());
        this.broadCast.on(BroadcastConstants.GROUP_SELECT, () => this.onSelect());

        this.broadCast.on(BroadcastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToPhotoBrowser(name, item)
        });

        this.broadCast.on(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToThirdPhotoBrowser(name, item)
        });

        this.broadCast.on(BroadcastConstants.INIT_DATE_TEXT, () => {
            this.dateText = DateUtil.getLocalizedYearAndMonth(this.timelineDataSource.groupItem[0].dateAdded);
        })

        this.isInCurrentTab = true;
        this.initGridRowCount();
        this.onIndexPageShow();	//TabContent uses lazy loading, call onIndexPageShow() the first time
        this.updateActionBar();
        finishTrace('TimelinePageAboutToAppear');
    }

    private onSelect() {
        Log.info(TAG, "onSelect");
        this.totalSelectedCount = this.timelineDataSource.getSelectedCount();
        this.isAllSelected = this.timelineDataSource.isSelect();
        if (this.totalSelectedCount > 0) {
            this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];
        } else {
            this.moreMenuList = [Action.MOVE_INVALID, Action.COPY_INVALID, Action.INFO_INVALID];
        }
    }

    private jumpToPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.timelineDataSource.getItems()
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            Log.warn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        router.push({
            uri: 'feature/browser/view/PhotoBrowser',
            params: {
                position: targetIndex,
                transition: name
            }
        });
    }

    private jumpToThirdPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.timelineDataSource.getItems();
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            Log.warn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        router.push({
            uri: 'feature/browser/view/SelectPhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
            }
        });
    }

    aboutToDisappear(): void {
        Log.info(TAG, 'TimelinePageAboutToDisappear');
        this.appBroadcast.off(BroadcastConstants.BACK_PRESS_EVENT, null);
        this.appBroadcast.off(BroadcastConstants.ON_TAB_CHANGED, null);
        this.appBroadcast.off(BroadcastConstants.RESET_STATE_EVENT, null);
        this.appBroadcast.off(BroadcastConstants.UPDATE_DATA_SOURCE, null);
        this.appBroadcast.off(BroadcastConstants.RESET_ZERO, null);
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
        mediaObserver.unregisterObserver(this.dataObserver);
        this.dataObserver.clearSource();
        this.broadCast.off(null, null);
    }

    // Calculate the number of squares per row
    private initGridRowCount(): void {
        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
        let contentWidth = screenManager.getWinWidth() - sideBarWidth;
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.TIME_GRID_MAX_SIZE_RATIO;
        let newCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin) + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        if (newCount != this.gridRowCount) {
            if (this.gridRowCount == 0) {
                this.gridRowCount = newCount;
            } else {
                this.gridRowCount = newCount;
                this.timelineDataSource.notifyDataReload();
            }
        }
        Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
    }

    private moveOperation(albumInfo: SimpleAlbumDataItem) {
        let menuContext = new MenuContext();
        this.onMoveStart = this.onMoveStart.bind(this);
        this.onMoveEnd = this.onMoveEnd.bind(this);
        menuContext.withDataSource(this.timelineDataSource)
            .withOperationStartCallback(this.onMoveStart)
            .withOperationEndCallback(this.onMoveEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = new MoveMenuOperation(menuContext);
        menuOperation.doAction();
    }

    private copyOperation(albumInfo: SimpleAlbumDataItem) {
        let menuContext = new MenuContext();
        this.onCopyStart = this.onCopyStart.bind(this);
        this.onCopyEnd = this.onCopyEnd.bind(this);
        menuContext.withDataSource(this.timelineDataSource)
            .withOperationStartCallback(this.onCopyStart)
            .withOperationEndCallback(this.onCopyEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = new CopyMenuOperation(menuContext);
        menuOperation.doAction();
    }

    onIndexChange() {
        Log.info(TAG, `onIndexChange ${this.TimelinePageIndex}`);
        if (this.TimelinePageIndex != Constants.INVALID) {
            let rollToIndex = this.timelineDataSource.getIndexByChildIndex(this.TimelinePageIndex)
            Log.info(TAG, `onIndexChange ${this.TimelinePageIndex} roll to ${rollToIndex}`)
            this.scroller.scrollToIndex(rollToIndex);
        }
    }

    onIndexBackPress(callback: Function): void {
        if (this.isInCurrentTab) {
            callback(this.onModeChange());
        }
    }

    private onUpdateFavorAndSelectState(item: MediaDataItem): void {
       this.onUpdateFavorState(item);
        this.onSelect();
    }

    private onUpdateFavorState(item: MediaDataItem): void {
        Log.debug(TAG, 'onUpdateFavorState favor');
        let index = this.timelineDataSource.getIndexByItem(item);
        if (index != -1) {
            this.timelineDataSource.notifyDataChange(index);
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
        Log.info(TAG, `onMenuClicked, actionID: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.CANCEL:
                this.onModeChange();
                break;
            case Action.SELECT_ALL:
            case Action.DESELECT_ALL:
                this.isAllSelected = !this.timelineDataSource.isSelect()
                this.timelineDataSource.setSelect(this.isAllSelected)
                this.onSelect()
                break;
            case Action.DELETE:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withDataSource(this.timelineDataSource)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast);
                menuOperation = new BatchDeleteMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.SHARE:
                menuContext = new MenuContext();
                menuContext.withDataSource(this.timelineDataSource);
                menuOperation = new ShareMenuOperation(menuContext);
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
        Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
        if (!PhotoEditorManager.getInstance().isSaving) {
            this.isMediaLibDataChanged = true
            this.loadItem()
        }
    }

    private loadItem() {
        if (this.isActive && this.isMediaLibDataChanged) {
            this.isMediaLibDataChanged = false
            startTrace("reloadTimelineItemData")
            this.timelineDataSource.reloadTimelineItemData().then((isEmpty) => {
                finishTrace("reloadTimelineItemData");
                Log.info(TAG, `onMediaLibDataChange load finish`);
                this.initLoadFinish = true;
                this.isEmpty = isEmpty;
                this.timelineDataSource.notifyDataReload();
                this.isHideScrollBar = (this.timelineDataSource.totalCount() <= Constants.SCROLL_BAR_VISIBLE_THRESHOLD);
            })
        } else if (this.isActive) {
            this.timelineDataSource.dataRemove()
        }
    }

    async openDetailsDialog(): Promise<void> {
        let items: MediaDataItem[] = this.timelineDataSource.getSelectedItems()
        if (items.length == 0) {
            Log.warn(TAG, 'no select error');
        } else if (items.length == 1) {
            Log.info(TAG, 'totalSelectedCount is 1');
            this.broadCast.emit(BroadcastConstants.SHOW_DETAIL_DIALOG, [items[0], false]);
        } else {
            let size = 0;
            items.forEach((item) => {
                Log.debug(TAG, `openDetailsDialog item.size: ${item.size}`);
                size = size + item.size;
            })
            Log.info(TAG, `openDetailsDialog size: ${size}`);
            this.broadCast.emit(BroadcastConstants.SHOW_MULTI_SELECT_DIALOG, [items.length, size]);
        }
    }

    onDeleteStart(): void {
        Log.info(TAG, `onDeleteStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    onDeleteEnd(err): void {
        Log.info(TAG, `onDeleteEnd`);
        startTrace('onModeChange');
        this.onModeChange();
        finishTrace('onModeChange');
        mediaObserver.registerObserver(this.dataObserver);
        animateTo({
            duration: Constants.DELETE_ANIMATE_DURATION
        }, () => {
            this.timelineDataSource.dataRemove();
            this.isHideScrollBar = (this.timelineDataSource.totalCount() <= Constants.SCROLL_BAR_VISIBLE_THRESHOLD);
        })
    }

    onCopyStart(): void {
        Log.info(TAG, `onCopyStart`);
        mediaObserver.unregisterObserver(this.dataObserver);

    }

    onCopyEnd(err, count, total): void {
        Log.info(TAG, `onCopyEnd count: ${count}, total: ${total}`);
        startTrace('onModeChange');
        this.onModeChange();
        finishTrace('onModeChange');
        mediaObserver.registerObserver(this.dataObserver);
        if (err) {
            getResourceString($r('app.string.copy_failed_single')).then((message: string) => {
                showToast(message)
            })
        } else {
            animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, () => this.timelineDataSource.dataReload());
            this.isHideScrollBar = (this.timelineDataSource.totalCount() <= Constants.SCROLL_BAR_VISIBLE_THRESHOLD);
        }
    }

    onMoveStart(): void {
        Log.info(TAG, `onMoveStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    onMoveEnd(err, count, total): void {
        Log.info(TAG, `onMoveEnd count: ${count}, total: ${total}`);
        startTrace('onModeChange');
        this.onModeChange();
        finishTrace('onModeChange');
        mediaObserver.registerObserver(this.dataObserver);
        if (err) {
            getResourceString($r('app.string.move_failed_single')).then((message: string) => {
                showToast(message)
            })
        }
    }

    onModeChange() {
        Log.debug(TAG, 'onModeChange');
        if (this.isSelectedMode) {
            this.isSelectedMode = false;
            this.timelineDataSource.setSelect(false)
            this.onSelect()
            return true;
        }
        return false;
    }

    // The callbacks after index page shows
    onIndexPageShow() {
        Log.info(TAG, `onIndexPageShow`)
        if (this.isShow && this.isInCurrentTab) {
            let params = router.getParams();
            if (this.routerStart && params != null && params.pageType != null) {
                Log.info(TAG, `MediaOperation back ${JSON.stringify(params)}`)
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
            Log.info(TAG, `other condition`)
        }
    }

    // The callback when current page is in the foreground
    onActive() {
        if (!this.isActive) {
            Log.info(TAG, 'onActive');
            this.isActive = true;
        }
        this.loadItem();
    }

    // The callback when current page is in the background
    onInActive() {
        if (this.isActive) {
            Log.info(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    build() {
        Stack() {
            Column() {
                if (this.isEmpty) {
                    NoPhotoIndexComponent({ index: Constants.TIMELINE_PAGE_INDEX })
                }
                if (this.initLoadFinish && !this.isEmpty) {
                    ActionBar({
                        actionBarProp: $actionBarProp,
                        onMenuClicked: this.onMenuClicked.bind(this)
                    })

                    Stack() {
                        Grid(this.scroller) {
                            LazyForEach(this.timelineDataSource, (item: LazyItem<TimelineDataItem> | LazyItem<MediaDataItem>) => {
                                if (item && item.get() && item.get().viewType == ViewType.GROUP_TITLE) {
                                    GridItem() {
                                        TimelineTitleComponent({
                                            lazyItem: (item as LazyItem<TimelineDataItem>),
                                            timelineDataItem: (item as LazyItem<TimelineDataItem>).get()
                                        })
                                    }.columnStart(0).columnEnd(this.gridRowCount - 1)
                                } else if (item && item.get() && item.get().viewType == ViewType.ITEM) {
                                    GridItem() {
                                        ImageGridItemComponent({
                                            lazyItem: (item as LazyItem<MediaDataItem>),
                                            mediaItem: (item as LazyItem<MediaDataItem>).get(),
                                            pageName: Constants.PHOTO_TRANSITION_TIMELINE,
                                            isSelectUpperLimited: $isSelectUpperLimited
                                        })
                                    }
                                    .aspectRatio(1)
                                    .columnStart((item as LazyItem<MediaDataItem>).get().index % this.gridRowCount)
                                    .columnEnd((item as LazyItem<MediaDataItem>).get().index % this.gridRowCount)
                                }
                            }, (item) => {
                                if (item == null || item.get() == null) {
                                    return JSON.stringify(item)
                                }
                                return item.getHashCode()
                            })
                        }
                        .columnsTemplate('1fr '.repeat(this.gridRowCount))
                        .columnsGap(Constants.GRID_GUTTER)
                        .rowsGap(Constants.GRID_GUTTER)
                        .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
                        .onScrollIndex((index: number) => {
                            Log.debug(TAG, `onScrollIndex index ${index}`)
                            let item: TimelineDataItem | MediaDataItem = this.timelineDataSource.getDataByIndex(index);
                            if (item) {
                                this.dateText = DateUtil.getLocalizedYearAndMonth(item.dateAdded);
                            } else {
                                Log.warn(TAG, 'index out of active window');
                            }
                        })

                        Column() {
                            TimelineScrollBar({
                                scroller: this.scroller,
                                dataSource: this.timelineDataSource,
                                isHideScrollBar: $isHideScrollBar
                            })
                        }
                        .hitTestBehavior(HitTestMode.Transparent)
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
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)

            if (this.isSelectedMode) {
                ToolBar({
                    toolMenuList: $toolBarMenuList,
                    onMenuClicked: this.onMenuClicked.bind(this)
                })
            }
            CustomDialogView()
        }
    }
}
