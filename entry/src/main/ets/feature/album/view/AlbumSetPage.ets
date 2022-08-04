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

import router from '@ohos.router';
import { CopyMenuOperation } from '../../../common/view/browserOperation/CopyMenuOperation';
import { MoveMenuOperation } from '../../../common/view/browserOperation/MoveMenuOperation';
import { AlbumInfo } from '../../../common/model/browser/album/AlbumInfo';
import { AlbumSetDataSource } from '../../../common/model/browser/album/AlbumSetDataSource'
import { Constants } from '../../../common/model/common/Constants'
import { ScreenManager } from '../../../common/model/common/ScreenManager'
import { BroadCast } from '../../../common/utils/BroadCast';
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { TraceControllerUtils } from '../../../common/utils/TraceControllerUtils'
import { TabBarForAlbumSet } from '../../../common/view/TabBar'
import { TabItemWithText } from '../../../common/model/common/TabItem'
import { AlbumSetSelectManager, SelectManager } from '../../../common/model/browser/SelectManager'
import { AlbumSetNewMenuOperation } from '../../../common/view/browserOperation/AlbumSetNewMenuOperation'
import { DistributedDataSource } from '../../../common/model/browser/album/DistributedDataSource'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuOperationFactory } from '../../../common/interface/MenuOperationFactory'
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView'
import { Action } from '../../../common/view/browserOperation/Action'
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { CommonObserverCallback } from '../../../common/model/browser/CommonObserverCallback'
import { MediaObserver } from '../../../common/model/browser/dataObserver/MediaObserver'
import { UiUtil } from '../../../common/utils/UiUtil'
import { Logger } from '../../../common/utils/Logger';
import { AlbumBarModel } from '../model/AlbumBarModel';
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import { AlbumGridItemNewStyle } from './AlbumGridItemNewStyle'
import { DistributedAlbumGriItem } from './DistributedAlbumGriItem'
import { AlbumSetDeleteMenuOperation } from '../operation/AlbumSetDeleteMenuOperation'
import { AlbumSetRenameMenuOperation } from '../operation/AlbumSetRenameMenuOperation'

// Album Set Page
@Component
export struct AlbumSetPage {
    private tabs: TabItemWithText[] = [
        new TabItemWithText($r('app.string.local'), false),
        new TabItemWithText($r('app.string.other_equipment'), false)
    ];
    @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
    @Provide('selectedCount') selectedAlbumsCount: number = 0;
    @Provide isDisableDelete: boolean = false;
    @Provide isDisableRename: boolean = false;
    @State isEmpty: boolean = true;
    @Provide gridColumnsCount: number = 0;
    @Provide broadCast: BroadCast = new BroadCast();
    @Consume @Watch('onIndexPageShow') isShow: boolean;
    albums: AlbumSetDataSource = new AlbumSetDataSource(this.broadCast);
    distributed: DistributedDataSource = new DistributedDataSource(this.broadCast);
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    isInCurrentTab = false;
    isActive = false; // Whether the page is in the foreground

    logger: Logger = new Logger('AlbumSetPage');
    scroller: Scroller = new Scroller();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    mSelectManager = new AlbumSetSelectManager();
    isDataFreeze: boolean = false;

    // the switch of distributed page
    @Provide isTabBarShow: boolean = false;
    @Provide moreMenuList: Action[] = new Array<Action>();
    private tabsController: TabsController = new TabsController();
    private currentIndex: number = Constants.LOCAL_TAB_INDEX;
    private needNotify = false;
    private ignoreLocalNotify = false;
    private barModel: AlbumBarModel = new AlbumBarModel()
    private toPhotoGrid: boolean = false;

    onMenuClicked(action: Action, arg: any[]) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.NEW:
                menuContext = new MenuContext();
                this.onOperationStart = this.onOperationStart.bind(this);
                this.onOperationEnd = this.onOperationEnd.bind(this);
                menuContext
                    .withOperationStartCallback(this.onOperationStart)
                    .withOperationEndCallback(this.onOperationEnd)
                    .withAlbumSetDataSource(this.albums)
                    .withBroadCast(this.broadCast);
                menuOperation
                = MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            case Action.CANCEL:
                this.isAlbumSetSelectedMode = false;
                break;
            case Action.RENAME:
                menuContext = new MenuContext();
                this.onOperationStart = this.onOperationStart.bind(this);
                this.onOperationEnd = this.onOperationEnd.bind(this);
                menuContext
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onOperationStart)
                    .withOperationEndCallback(this.onOperationEnd)
                    .withBroadCast(this.broadCast);
                menuOperation
                = MenuOperationFactory.getInstance().createMenuOperation(AlbumSetRenameMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            case Action.DELETE:
                menuContext = new MenuContext();
                this.onOperationStart = this.onOperationStart.bind(this);
                this.onOperationEnd = this.onOperationEnd.bind(this);
                menuContext
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onOperationStart)
                    .withOperationEndCallback(this.onOperationEnd)
                    .withBroadCast(this.broadCast);
                menuOperation
                = MenuOperationFactory.getInstance().createMenuOperation(AlbumSetDeleteMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            default:
                break;
        }
    }

    onOperationStart(): void {
        this.isDataFreeze = true;
        this.ignoreLocalNotify = true;
        this.albums.freeze();
    }

    onOperationEnd(): void {
        this.logger.debug(`onOperationEnd`);
        this.isDataFreeze = false;
        this.isAlbumSetSelectedMode = false
        this.ignoreLocalNotify = false;
        this.albums.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.albums.unfreeze();
        let newAlbum = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
        if (newAlbum) {
            this.toPhotoGrid = true;
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        }
    }

    aboutToAppear(): void {
        TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
        this.logger.info(`AlbumSetPageAboutToAppear`);
        this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.isEmpty = (size == 0);
            let newAlbum = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
            if (!this.isEmpty && newAlbum && this.toPhotoGrid) {
                this.toPhotoGrid = false;
                let newAlbum = AppStorage.Get<AlbumInfo>(Constants.APP_KEY_NEW_ALBUM_TARGET);
                for (let album of this.albums.mediaSetList) {
                    if (album.name == newAlbum.name
                    && album.displayName == newAlbum.displayName
                    && album.relativePath == newAlbum.relativePath) {
                        let options = {
                            url: 'feature/browser/view/photoGrid/PhotoGridPage',
                            params: {
                                item: JSON.stringify(album)
                            }
                        }
                        router.push(options);
                        break;
                    }
                }
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
            }
        });

        this.appBroadCast.on(BroadCastConstants.RESET_ZERO, this.onResetZero.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));

        this.distributed.initialize();
        this.isInCurrentTab = true;

        MediaObserver.getInstance().registerObserver(this.dataObserver);

        this.onActive();

        this.initGridRowCount();

        let self = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadCastConstants.SELECT, function (
                key: string, value: boolean, isDisableRename: boolean, isDisableDelete: boolean, callback: Function) {
            self.mSelectManager.toolBarStateToggle(key, value, isDisableRename, isDisableDelete);
            if (self.mSelectManager.toggle(key, value)) {
                self.logger.info('enter event process');
                callback();
            }
        });

        this.mSelectManager.registerCallback('updateCount', this.freezeAdapter(function (newState: number) {
            self.logger.info(`updateSelectedCount ${newState}`);
            self.selectedAlbumsCount = newState;
        }));
        this.mSelectManager.registerCallback('updateToolBarState', this.freezeAdapter(
            function (isDisableRename: boolean, isDisableDelete: boolean) {
                self.logger.info(`updateToolBarState:\
                    isDisableRename: ${isDisableRename}, isDisableDelete: ${isDisableDelete}`);
                self.isDisableRename = isDisableRename
                self.isDisableDelete = isDisableDelete
            })
        );

        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.initGridRowCount();
        });
        if (Constants.LOCAL_TAB_INDEX == this.currentIndex) {
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;
        } else {
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = false;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = true;
        }
        TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
    }

    aboutToDisappear(): void {
        this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_ZERO, this.onResetZero.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    }

    // Callback when the page is show.
    onIndexPageShow() {
        this.logger.info(`onIndexPageShow`)
        if (this.isShow && this.isInCurrentTab) {
            this.onActive();
            this.createAlbum();
        } else if (!this.isShow && this.isInCurrentTab) {
            this.onInActive();
        } else {
        }
    }

    createAlbum() {
        let newAlbum = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
        if (newAlbum) {
            this.broadCast.emit(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
                [this.moveOperation.bind(this), this.copyOperation.bind(this)]);
        }
    }

    private copyOperation() {
        let selectManager = AppStorage.Get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        let targetAlbum = AppStorage.Get<AlbumInfo>(Constants.APP_KEY_NEW_ALBUM_TARGET);
        if (undefined == selectManager || undefined == targetAlbum) {
            return;
        }
        let menuContext = new MenuContext();
        menuContext
            .withSelectManager(selectManager)
            .withOperationStartCallback(this.onOperationStart.bind(this))
            .withOperationEndCallback(this.onOperationEnd.bind(this))
            .withBroadCast(this.broadCast)
            .withAlbumInfo(targetAlbum);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private moveOperation() {
        let selectManager = AppStorage.Get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        let targetAlbum = AppStorage.Get<AlbumInfo>(Constants.APP_KEY_NEW_ALBUM_TARGET);
        if (undefined == selectManager || undefined == targetAlbum) {
            return;
        }
        let menuContext = new MenuContext();
        menuContext
            .withSelectManager(selectManager)
            .withOperationStartCallback(this.onOperationStart.bind(this))
            .withOperationEndCallback(this.onOperationEnd.bind(this))
            .withBroadCast(this.broadCast)
            .withAlbumInfo(targetAlbum);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
        menuOperation.doAction();
    }

    onModeChange() {
        this.logger.info(`onModeChange ${this.isAlbumSetSelectedMode}`);
        if (!this.isAlbumSetSelectedMode) {
            this.mSelectManager.emitCallback('updateCount', [0]);
            this.mSelectManager.onModeChange(false);
        }
    }

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
            this.onInActive();
        }
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            if (this.currentIndex == Constants.LOCAL_TAB_INDEX) {
                this.onLocalAlbumSetActive();
            } else {
                this.onLocalAlbumSetInActive();
            }

            this.showNotify();
        }
    }

    // Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.albums && this.albums.onInActive();
            this.distributed && this.distributed.onInActive();
        }
    }

    // Callback when the local albums' page is in the foreground
    onLocalAlbumSetActive() {
        if (this.currentIndex == Constants.LOCAL_TAB_INDEX) {
            this.logger.info('Local album set is on active');
            this.albums && this.albums.onActive();
            this.distributed && this.distributed.onInActive();
        }
    }

    // Callback when the local albums' page is in the background
    onLocalAlbumSetInActive() {
        if (this.currentIndex == Constants.OTHER_EQUIPMENT_TAB_INDEX) {
            this.logger.info('Local album set is on inactive');
            this.albums && this.albums.onInActive();
            this.distributed && this.distributed.onActive();
        }
    }

    private showNotify() {
        if (this.needNotify) {
            UiUtil.showToast($r('app.string.distributed_album_disconnected'));
            this.needNotify = false;
        }
    }

    private onDistributedTabChanged(index: number) {
        this.currentIndex = index;
        if (index == Constants.LOCAL_TAB_INDEX) {
            this.onLocalAlbumSetActive();
        } else {
            this.onLocalAlbumSetInActive();
        }
    }

    onResetZero(pageNumber: number) {
        if (pageNumber == Constants.ALBUM_PAGE_INDEX) {
            this.scroller.scrollEdge(Edge.Top);
        }
    }

    initGridRowCount() {
        this.logger.info(`get screen width is : ${ScreenManager.getInstance().getWinWidth()}`);
        this.logger.info(`get screen height is : ${ScreenManager.getInstance().getWinHeight()}`);

        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;

        let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        this.logger.info(`the grid count in a line is: ${this.gridColumnsCount}`);

    }

    onMediaLibDataChange(changeType) {
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        if (!this.ignoreLocalNotify) {
            this.albums.onChange(changeType);
        }
        this.distributed.onChange(changeType);
    }

    private onUpdateRemoteDevice(res, deviceId, size): void {
        this.logger.info(`onUpdateRemoteDevice size: ${size} deviceId: ${deviceId} type: ${res}`);

        if (res == Constants.DEVICE_STATE_OFFLINE) {
            this.needNotify = true;
        }

        if (size <= 0) {
            this.currentIndex = Constants.LOCAL_TAB_INDEX
            try {
                this.tabsController.changeIndex(this.currentIndex);
            } catch (error) {
                this.logger.error(`change tab index failed: ${error}`);
            }
            this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
            this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;

            if (this.isActive) {
                this.showNotify();
            }
        }

        this.isTabBarShow = (size > 0);
    }

    @Builder LocalAlbumSet() {
        Stack() {
            Grid(this.scroller) {
                LazyForEach(this.albums, (item) => {
                    if (this.albums.mediaSetList.indexOf(item) == 0) {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                item: item,
                                isBigCard: true,
                                isSelected: this.isAlbumSetSelectedMode ?
                                this.mSelectManager.isItemSelected(item.id) : false,
                            })
                        }.columnStart(0).columnEnd(1)
                    } else {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                item: item,
                                isBigCard: false,
                                isSelected: this.isAlbumSetSelectedMode ?
                                this.mSelectManager.isItemSelected(item.id) : false,
                            })
                        }
                    }
                }, item => 'uri:' + item.id)
            }
            .visibility(this.isEmpty ? Visibility.None : Visibility.Visible)
            .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
            .padding({
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                top: $r('app.float.album_set_page_padding_top'),
                bottom: this.isTabBarShow
                    ? (this.isSidebar ? $r('app.float.album_set_page_padding_end') : $r('app.float.album_set_page_padding_end_112'))
                    : (this.isSidebar ? 0 : $r('app.float.album_set_page_padding_end'))
            })
            .columnsGap($r('app.float.album_set_grid_column_gap'))
            .rowsGap($r('app.float.album_set_grid_row_gap'))
        }
    }

    @Builder OtherEquipmentAlbumSet() {
        Grid(this.scroller) {
            LazyForEach(this.distributed, (item) => {
                GridItem() {
                    DistributedAlbumGriItem({ item: item })
                }
            }, item => 'uri:' + item.networkId)
        }
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_end'),
            top: $r('app.float.album_set_page_padding_top'),
            bottom: this.isTabBarShow
                ? (this.isSidebar ? $r('app.float.album_set_page_padding_end') : $r('app.float.album_set_page_padding_end_112'))
                : (this.isSidebar ? 0 : $r('app.float.album_set_page_padding_end'))
        })
        .columnsGap($r('app.float.album_set_grid_column_gap'))
        .rowsGap($r('app.float.album_set_grid_row_gap'))
    }

    build() {
        Stack() {
            Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Start,
                alignItems: ItemAlign.Start
            }) {
                ActionBar({
                    isShowBar: !(this.isEmpty && !this.isTabBarShow),
                    actionBarProp: this.barModel.createActionBar(
                        this.isAlbumSetSelectedMode,
                        this.selectedAlbumsCount,
                        this.isDisableRename,
                        this.isDisableDelete),
                    onMenuClicked: this.onMenuClicked
                })
                Column() {
                    TabBarForAlbumSet({
                        currentIndex: this.currentIndex,
                        tabs: this.tabs,
                        controller: this.tabsController,
                    })

                    Tabs({
                        barPosition: BarPosition.Start,
                        index: this.currentIndex,
                        controller: this.tabsController
                    }) {
                        TabContent() {
                            this.LocalAlbumSet()
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
                        this.logger.info(`Switch to Tab ${index}.`);
                        this.onDistributedTabChanged(index);
                    })
                }.visibility(this.isEmpty && !this.isTabBarShow ? Visibility.None : Visibility.Visible)

                ToolBar({
                    isShowBar: $isAlbumSetSelectedMode,
                    toolMenuList: this.barModel.getMenuList(
                        this.isAlbumSetSelectedMode,
                        this.selectedAlbumsCount,
                        this.isDisableRename,
                        this.isDisableDelete),
                    onMenuClicked: this.onMenuClicked
                })

                if (this.isEmpty && !this.isTabBarShow) {
                    NoPhotoIndexComponent({ index: Constants.ALBUM_PAGE_INDEX })
                }
            }

            CustomDialogView()
        }
    }
}
