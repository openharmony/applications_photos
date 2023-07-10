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

import { CopyMenuOperation } from '@ohos/base/src/main/ets/operation/CopyMenuOperation';
import { MoveMenuOperation } from '@ohos/base/src/main/ets/operation/MoveMenuOperation';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { Constants } from '../../../common/model/common/Constants';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { TabBarForAlbumSet } from '../../../common/view/TabBar';
import { TabItemWithText } from '../../../common/model/common/TabItem';
import { AlbumSetNewMenuOperation } from '@ohos/base/src/main/ets/operation/AlbumSetNewMenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { CommonObserverCallback } from '@ohos/base/src/main/ets/observer/CommonObserverCallback';
import mediaObserver from '@ohos/base/src/main/ets/observer/MediaObserver';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { AlbumBarModel } from '../model/AlbumBarModel';
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import {
    AlbumGridItemNewStyle
} from '@ohos/album/src/main/ets/components/AlbumGridItemNewStyle';
import {
    DistributedAlbumGriItem
} from '@ohos/album/src/main/ets/components/DistributedAlbumGriItem';
import {
    AlbumSetDeleteMenuOperation
} from '@ohos/album/src/main/ets/operation/AlbumSetDeleteMenuOperation';
import {
    AlbumSetRenameMenuOperation
} from '@ohos/album/src/main/ets/operation/AlbumSetRenameMenuOperation';
import { AlbumScrollBar } from '@ohos/base/src/main/ets/components/scrollBar/AlbumScrollBar';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { DistributedDataSource } from '@ohos/base/src/main/ets/vm/DistributedDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { PeerDataItem } from '@ohos/base/src/main/ets/data/PeerDataItem';
// Album Set Page
const TAG = "AlbumSetPage"

@Component
export struct AlbumSetPage {
    private tabs: TabItemWithText[] = [
        new TabItemWithText($r('app.string.local'), false),
        new TabItemWithText($r('app.string.other_equipment'), false)
    ];
    @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
    @Provide('selectedCount') @Watch('updateActionBar') selectedAlbumsCount: number = 0;
    @Provide isHideScrollBar: boolean = true;
    @State isEmpty: boolean = true;
    @Provide gridColumnsCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Consume @Watch('onIndexPageShow') isShow: boolean;
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    appBroadcast: Broadcast = broadcastManager.getBroadcast();
    isInCurrentTab = false;
    isActive = false; // Whether the page is in the foreground

    scroller: Scroller = new Scroller();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();

    // the switch of distributed page
    @Provide('tabBarShow') isTabBarShow: boolean = false;
    @Provide moreMenuList: Action[] = new Array<Action>();
    private tabsController: TabsController = new TabsController();
    @State currentIndex: number = Constants.LOCAL_TAB_INDEX;
    private needNotify = false;
    private barModel: AlbumBarModel = new AlbumBarModel();
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource();
    private distributedDataSource: DistributedDataSource = new DistributedDataSource();
    private isMediaLibDataChanged: boolean = true;
    onWindowSizeChangeCallBack = () => this.initGridRowCount();

    @State actionBarProp: ActionBarProp = new ActionBarProp();
    @State toolBarMenuList: Action[] = new Array<Action>();

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(
            this.isAlbumSetSelectedMode,
            this.selectedAlbumsCount,
            this.albumsDataSource.isDisableRename(),
            this.albumsDataSource.isDisableDelete(),
        );
        this.toolBarMenuList = this.barModel.getMenuList(
            this.isAlbumSetSelectedMode,
            this.selectedAlbumsCount,
            this.albumsDataSource.isDisableRename(),
            this.albumsDataSource.isDisableDelete());
    }

    onMenuClicked(action: Action, arg: any[]) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.NEW:
                menuContext = new MenuContext();
                menuContext
                    .withOperationStartCallback(this.onOperationStart.bind(this))
                    .withOperationEndCallback(this.onNewEnd.bind(this))
                    .withDataSource(this.albumsDataSource)
                    .withBroadCast(this.broadCast);
                menuOperation = new AlbumSetNewMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.CANCEL:
                this.isAlbumSetSelectedMode = false;
                break;
            case Action.RENAME:
                menuContext = new MenuContext();
                menuContext
                    .withDataSource(this.albumsDataSource)
                    .withOperationStartCallback(this.onOperationStart.bind(this))
                    .withOperationEndCallback(this.onRenameEnd.bind(this))
                    .withBroadCast(this.broadCast);
                menuOperation = new AlbumSetRenameMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.DELETE:
                menuContext = new MenuContext();
                menuContext
                    .withDataSource(this.albumsDataSource)
                    .withOperationStartCallback(this.onOperationStart.bind(this))
                    .withOperationEndCallback(this.onDeleteEnd.bind(this))
                    .withBroadCast(this.broadCast);
                menuOperation = new AlbumSetDeleteMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            default:
                break;
        }
    }

    onOperationStart(): void {
        Log.debug(TAG, `onOperationStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    private onDeleteEnd(): void {
        this.isAlbumSetSelectedMode = false;
        this.albumsDataSource.dataRemove();
        mediaObserver.registerObserver(this.dataObserver);
    }

    onNewEnd() {
        Log.debug(TAG, `onNewEnd`);
        this.isAlbumSetSelectedMode = false;
        mediaObserver.registerObserver(this.dataObserver);
    }

    onRenameEnd() {
        Log.debug(TAG, `onRenameEnd`);
        this.isAlbumSetSelectedMode = false;
        this.albumsDataSource.notifyDataReload();
        mediaObserver.registerObserver(this.dataObserver);
    }

    onOperationEnd(): void {
        Log.debug(TAG, `onOperationEnd`);
        this.isAlbumSetSelectedMode = false;
        this.isMediaLibDataChanged = true;
        this.selectedAlbumsCount = 0;
        this.loadItem();
        mediaObserver.registerObserver(this.dataObserver);
        AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    }

    aboutToAppear(): void {
        startTrace('AlbumSetPageAboutToAppear');
        Log.info(TAG, `AlbumSetPageAboutToAppear`);
        this.appBroadcast.on(BroadcastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadcast.on(BroadcastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));

        this.appBroadcast.on(BroadcastConstants.RESET_ZERO, this.onResetZero.bind(this));

        this.isInCurrentTab = true;

        mediaObserver.registerObserver(this.dataObserver);

        this.initGridRowCount();

        let self = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadcastConstants.SELECT, (index: number) => this.onSelect(index));

        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        if (this.currentIndex == Constants.LOCAL_TAB_INDEX) {
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;
        } else {
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = false;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = true;
        }
        this.distributedDataSource.reloadAlbumItemData().then((change: number) => {
            this.onUpdateRemoteDevice(change);
            this.distributedDataSource.notifyDataReload();
        })
        this.onIndexPageShow();	//TabContent uses lazy loading, call onIndexPageShow() the first time
        this.updateActionBar();
        finishTrace('AlbumSetPageAboutToAppear');
    }

    aboutToDisappear(): void {
        Log.info(TAG, `aboutToDisappear`);
        this.broadCast.off(null, null);
        this.appBroadcast.off(BroadcastConstants.BACK_PRESS_EVENT, null);
        this.appBroadcast.off(BroadcastConstants.ON_TAB_CHANGED, null);
        this.appBroadcast.off(BroadcastConstants.RESET_ZERO, null);
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
        mediaObserver.unregisterObserver(this.dataObserver);
        this.dataObserver.clearSource();
    }

    // Callback when the page is show.
    onIndexPageShow() {
        Log.info(TAG, `onIndexPageShow`);
        if (this.isShow && this.isInCurrentTab) {
            this.onActive();
            this.createAlbum();
        } else if (!this.isShow && this.isInCurrentTab) {
            this.onInActive();
        } else {
            Log.info(TAG, `other condition`);
        }
    }

    createAlbum() {
        let newAlbum = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
        if (newAlbum) {
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
            this.broadCast.emit(BroadcastConstants.SHOW_COPY_OR_MOVE_DIALOG,
                [this.moveOperation.bind(this), this.copyOperation.bind(this)]);
        }
    }

    private copyOperation() {
        let mediaItems = AppStorage.Get<MediaDataItem[]>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        let targetAlbum = AppStorage.Get<SimpleAlbumDataItem>(Constants.APP_KEY_NEW_ALBUM_TARGET);
        if (mediaItems == undefined || targetAlbum == undefined) {
            Log.warn(TAG, `mediaItems is undefined ${mediaItems == undefined} targetAlbum is undefined ${targetAlbum == undefined}`)
            return;
        }
        let menuContext = new MenuContext();
        menuContext.withItems(mediaItems)
            .withOperationStartCallback(this.onOperationStart.bind(this))
            .withOperationEndCallback(this.onOperationEnd.bind(this))
            .withBroadCast(this.broadCast)
            .withAlbumInfo(targetAlbum);
        let menuOperation = new CopyMenuOperation(menuContext);
        menuOperation.doAction();
    }

    private moveOperation() {
        let mediaItems = AppStorage.Get<MediaDataItem[]>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        let targetAlbum = AppStorage.Get<SimpleAlbumDataItem>(Constants.APP_KEY_NEW_ALBUM_TARGET);
        if (mediaItems == undefined || undefined == targetAlbum) {
            return;
        }
        let menuContext = new MenuContext();
        menuContext.withItems(mediaItems)
            .withOperationStartCallback(this.onOperationStart.bind(this))
            .withOperationEndCallback(this.onOperationEnd.bind(this))
            .withBroadCast(this.broadCast)
            .withAlbumInfo(targetAlbum);
        let menuOperation = new MoveMenuOperation(menuContext);
        menuOperation.doAction();
    }

    onModeChange() {
        Log.info(TAG, `onModeChange ${this.isAlbumSetSelectedMode}`);
        if (!this.isAlbumSetSelectedMode) {
            this.albumsDataSource.setSelect(false);
            this.selectedAlbumsCount = 0;
        }
        this.updateActionBar();
    }

    onIndexBackPress(callback: Function): void {
        if (this.isInCurrentTab) {
            if (this.isAlbumSetSelectedMode) {
                callback(true);
                this.isAlbumSetSelectedMode = false;
            } else {
                callback(false);
            }
        }
    }

    onStateReset(index: number): void {
        if (index == Constants.ALBUM_PAGE_INDEX) {
            this.isAlbumSetSelectedMode = false;
        }
    }

    onTabChanged(index: number): void {
        if (index == Constants.ALBUM_PAGE_INDEX) {
            this.isInCurrentTab = true;
            this.onActive();
        } else {
            this.isInCurrentTab = false;
            if (this.isAlbumSetSelectedMode) {
                this.isAlbumSetSelectedMode = false;
            }
            this.onInActive();
        }
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            Log.info(TAG, 'onActive');
            this.isActive = true;
            this.albumsDataSource.dataRemove();
            this.distributedDataSource.dataRemove();
            this.showNotify();
        }
        this.loadItem();
    }

    // Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            Log.info(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    private showNotify() {
        if (this.needNotify) {
            getResourceString($r('app.string.distributed_album_disconnected')).then((message: string) => {
                showToast(message);
            })
            this.needNotify = false;
        }
    }

    private onDistributedTabChanged(index: number) {
        this.currentIndex = index;
    }

    onResetZero(pageNumber: number) {
        if (pageNumber == Constants.ALBUM_PAGE_INDEX) {
            this.scroller.scrollEdge(Edge.Top);
        }
    }

    initGridRowCount() {
        Log.info(TAG, `get screen width is : ${screenManager.getWinWidth()}`);
        Log.info(TAG, `get screen height is : ${screenManager.getWinHeight()}`);

        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;

        let contentWidth = screenManager.getWinWidth() - sideBarWidth;
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        Log.info(TAG, `the grid count in a line is: ${this.gridColumnsCount}`);

    }

    onMediaLibDataChange(changeType) {
        Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
        if (changeType == MediaConstants.MEDIA_TYPE_REMOTE) {
            this.distributedDataSource.reloadAlbumItemData().then((change: number) => {
                this.onUpdateRemoteDevice(change)
                this.distributedDataSource.notifyDataReload()
            })
        } else {
            this.isMediaLibDataChanged = true;
            this.albumsDataSource.resetLoadState();
            this.loadItem();
        }
    }

    private loadItem() {
        if (this.isActive && this.isMediaLibDataChanged) {
            this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
                this.isEmpty = isEmpty;
                this.albumsDataSource.notifyDataReload();
                this.isHideScrollBar = (this.albumsDataSource.totalCount() <= (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
            })
        } else if (this.isActive) {
            this.albumsDataSource.dataRemove();
        }
    }

    private onUpdateRemoteDevice(change: number): void {
        Log.info(TAG, `onUpdateRemoteDevice`);

        if (change < 0) {
            this.needNotify = true;
        }
        let size = this.distributedDataSource.totalCount();
        Log.info(TAG, `onUpdateRemoteDevice length:${size} change: ${change}`);

        if (size <= 0) {
            this.onDistributedTabChanged(Constants.LOCAL_TAB_INDEX);
            try {
                this.tabsController.changeIndex(this.currentIndex);
            } catch (error) {
                Log.error(TAG, `change tab index failed: ${error}`);
            }
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;

            if (this.isActive) {
                this.showNotify();
            }
        }

        this.isTabBarShow = false;
    }

    private onSelect(index: number) {
        this.selectedAlbumsCount = this.albumsDataSource.getSelectedCount();
        this.albumsDataSource.notifyDataChange(index);
    }

    private loadAlbums(isForce: boolean) {
        if (isForce || this.currentIndex == Constants.LOCAL_TAB_INDEX) {
            this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
                this.isEmpty = isEmpty;
                this.albumsDataSource.notifyDataReload();
            })
        }
        if (isForce || this.currentIndex == Constants.OTHER_EQUIPMENT_TAB_INDEX) {

        }
    }

    @Builder LocalAlbumSet() {
        Stack() {
            Grid(this.scroller) {
                LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>) => {
                    if (item && item.get() && item.get().index == 0) {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                lazyItem: item,
                                item: item.get(),
                                isBigCard: true,
                            })
                        }.columnStart(0).columnEnd(1)
                    } else if (item && item.get()) {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                item: item.get(),
                                isBigCard: false,
                            })
                        }
                    }
                }, (item: LazyItem<AlbumDataItem>) => item && item.get()? item.getHashCode() : JSON.stringify(item))
            }
            .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
            .padding({
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                top: $r('app.float.album_set_page_padding_top'),
                bottom: (this.isSidebar ? $r('app.float.album_set_page_padding_end') : $r('app.float.album_set_page_padding_end_112'))
            })
            .columnsGap($r('app.float.album_set_grid_column_gap'))
            .rowsGap($r('app.float.album_set_grid_row_gap'))

            AlbumScrollBar({ scroller: this.scroller, hasSideBar: this.isSidebar })
        }
    }

    @Builder OtherEquipmentAlbumSet() {
        Stack() {
            Grid(this.scroller) {
                LazyForEach(this.distributedDataSource, (item: PeerDataItem) => {
                    GridItem() {
                        DistributedAlbumGriItem({ item: item })
                    }
                }, (item: PeerDataItem) => item ? item.getHashCode() : JSON.stringify(item))
            }
            .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
            .padding({
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                top: $r('app.float.album_set_page_padding_top'),
                bottom: (this.isSidebar ? $r('app.float.album_set_page_padding_end') : $r('app.float.album_set_page_padding_end_112'))
            })
            .columnsGap($r('app.float.album_set_grid_column_gap'))
            .rowsGap($r('app.float.album_set_grid_row_gap'))

            AlbumScrollBar({ scroller: this.scroller, hasSideBar: this.isSidebar })
        }
    }

    build() {
        Stack() {
            Column() {
                if (!this.isEmpty || this.isTabBarShow) {
                    ActionBar({
                        actionBarProp: $actionBarProp,
                        onMenuClicked: this.onMenuClicked
                    })
                    Column() {
                        if (this.isTabBarShow) {
                            TabBarForAlbumSet({
                                currentIndex: this.currentIndex,
                                tabs: this.tabs,
                                controller: this.tabsController,
                            })
                        }

                        Tabs({
                            barPosition: BarPosition.Start,
                            index: this.currentIndex,
                            controller: this.tabsController
                        }) {
                            TabContent() {
                                if (!this.isEmpty) {
                                    this.LocalAlbumSet()
                                }
                            }

                            TabContent() {
                                this.OtherEquipmentAlbumSet()
                            }
                        }
                        .animationDuration(0)
                        .vertical(false)
                        .scrollable(false)
                        .barMode(BarMode.Fixed)
                        .barWidth(0)
                        .barHeight(0)
                        .flexGrow(1)
                        .onChange((index: number) => {
                            Log.info(TAG, `Switch to Tab ${index}.`);
                            this.onDistributedTabChanged(index);
                        })
                    }
                }
                if (this.isAlbumSetSelectedMode) {
                    ToolBar({
                        toolMenuList: $toolBarMenuList,
                        onMenuClicked: this.onMenuClicked
                    })
                }

                if (this.isEmpty && !this.isTabBarShow) {
                    NoPhotoIndexComponent({ index: Constants.ALBUM_PAGE_INDEX })
                }
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)

            CustomDialogView()
        }
    }

    pageTransition() {
        PageTransitionExit({ type: RouteType.Push, duration: 1 })
          .opacity(0)
        PageTransitionEnter({ type: RouteType.Pop, duration: 1 })
          .opacity(0)
    }
}
