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

import prompt from '@system.prompt';
import {AlbumGridItemNewStyle} from './AlbumGridItemNewStyle.ets'
import {AlbumSetDataSource} from '../../../../common/model/browser/album/AlbumSetDataSource.ets'
import {Constants} from '../../../../common/model/common/Constants.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {NoPhotoIndexComponent} from '../../../../common/view/NoPhotoIndexComponent'
import {Logger} from '../../utils/Logger.ets'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager'
import {TraceControllerUtils} from '../../../../common/utils/TraceControllerUtils'

import {AlbumSetPageActionBar} from './AlbumSetPageActionBar.ets'
import {AlbumSetPageToolBar} from './AlbumSetPageToolBar.ets'
import {TabBarForAlbumSet} from '../../../../common/view/TabBar.ets'
import {TabItemWithText} from '../../../../common/model/common/TabItem.ets'
import {OtherEquipmentAlbumGriItem} from './OtherEquipmentAlbumGriItem.ets'
import {AlbumSetSelectManager} from '../../../../common/model/browser/SelectManager.ets'
import {AlbumSetRenameMenuOperation} from '../../../../common/model/browser/operation/AlbumSetRenameMenuOperation.ets'
import {AlbumSetNewMenuOperation} from '../../../../common/model/browser/operation/AlbumSetNewMenuOperation.ets'
import {DistributedDataSource} from '../../../../common/model/browser/album/DistributedDataSource.ets'
import {MenuContext} from '../../../../common/model/browser/operation/MenuContext'
import {MenuOperation} from '../../../../common/model/browser/operation/MenuOperation'
import {MenuOperationFactory} from '../../../../common/model/browser/interface/MenuOperationFactory.ets'
import {AlbumSetDeleteMenuOperation} from '../../../../common/model/browser/operation/AlbumSetDeleteMenuOperation'
import {CustomDialogView} from '../../../../common/view/dialog/CustomDialogView.ets'
import {Action} from '../../../../common/model/browser/operation/Action'

import { AlbumSetObserverCallback } from '../../../../common/model/browser/album/AlbumSetObserverCallback.ets'
import { MediaObserver } from '../../../../common/model/browser/dataObserver/MediaObserver.ets'
import {UiUtil} from '../../../../common/utils/UiUtil.ets';

let tabs: TabItemWithText[] = [
    new TabItemWithText($r('app.string.local'), false),
    new TabItemWithText($r('app.string.other_equipment'), false)
];

// Album Set Page
@Component
export struct AlbumSetPage {
    @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;

    @Provide("selectedCount") selectedAlbumsCount: number = 0;

    @Provide isDisableDelete: boolean = false;

    @Provide isDisableRename: boolean = false;

    @State isEmpty: boolean = false;
    @Provide gridColumnsCount: number = 0;
    @Provide broadCast: BroadCast = new BroadCast();
    @Consume @Watch('onIndexPageShow') isShow: boolean;

    albums: AlbumSetDataSource= new AlbumSetDataSource(this.broadCast);
    distributed: DistributedDataSource = new DistributedDataSource(this.broadCast);
    private dataObserver: AlbumSetObserverCallback  = new AlbumSetObserverCallback(this);

    appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

    isInCurrentTab = false;

    isActive = false; // Whether the page is in the foreground

    logger: Logger = new Logger(`AlbumSetPage[${Date.now()}]`);

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

    onMenuClicked(action: Action, arg: any[]) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch(action) {
            case  Action.NEW:
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
            case  Action.CANCEL:
                this.isAlbumSetSelectedMode = false;
                break;
            case  Action.RENAME:
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
            case  Action.DELETE:
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
        this.albums.freeze();
    }

    onOperationEnd(): void {
        this.logger.debug(`onOperationEnd`);
        this.isDataFreeze = false;
        this.isAlbumSetSelectedMode = false
        this.albums.unfreeze();
    }

    private aboutToAppear(): void {
        TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
        this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        AppStorage.SetOrCreate('setSelectManagerToAnother', this.mSelectManager);
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.isEmpty = (size == 0);
        });

        this.appBroadCast.on(BroadCastConstants.RESET_ZERO, this.onResetZero.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_OPERATION_FINISHED, this.onOperationFinished.bind(this));
        this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onOperationFinished.bind(this));
        this.appBroadCast.on(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));

        this.distributed.initialize();
        this.isInCurrentTab = true;

        MediaObserver.getInstance().registerObserver(this.dataObserver);

        this.onActive();

        this.initGridRowCount();

        let self  = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadCastConstants.SELECT, function(
                key: string, value: boolean, isDisableRename: boolean, isDisableDelete: boolean, callback: Function) {
            self.mSelectManager.toolBarStateToggle(key, value, isDisableRename, isDisableDelete);
            if (self.mSelectManager.toggle(key, value)) {
                self.logger.info('enter event process');
                callback();
            }
        });

        this.mSelectManager.registerCallback("updateCount", this.freezeAdapter(function(newState: number) {
            self.logger.info(`updateSelectedCount ${newState}`);
            self.selectedAlbumsCount = newState;
        }));
        this.mSelectManager.registerCallback('updateToolBarState', this.freezeAdapter(
            function(isDisableRename: boolean, isDisableDelete: boolean) {
                self.logger.info(`updateToolBarState:\
                    isDisableRename: ${isDisableRename}, isDisableDelete: ${isDisableDelete}`);
                self.isDisableRename = isDisableRename
                self.isDisableDelete = isDisableDelete
            })
        );

        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.initGridRowCount();
        });
        TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
    }

    private aboutToDisappear(): void {
        this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onIndexBackPress.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChanged.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateReset.bind(this));
        this.appBroadCast.off(BroadCastConstants.RESET_ZERO, this.onResetZero.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_OPERATION_FINISHED, this.onOperationFinished.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));
        this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onOperationFinished.bind(this));
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    }

    // Callback when the page is show.
    onIndexPageShow() {
        if (this.isShow && this.isInCurrentTab) {
            this.onActive();
        } else if (!this.isShow && this.isInCurrentTab) {
            this.onInActive();
        } else {
        }
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
        return function() {
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

    private showNotify(){
        if (this.needNotify){
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

    onOperationFinished(changeType) {
        this.logger.info(`ON_OPERATION_FINISHED type: ${changeType}`);
        this.albums.onChange('image');
    }

    initGridRowCount(){
        this.logger.info(`get screen width is : ${ScreenManager.getInstance().getWinWidth()}`);
        this.logger.info(`get screen height is : ${ScreenManager.getInstance().getWinHeight()}`);

        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;

        let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
            / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        this.logger.info("the grid count in a line is : " + this.gridColumnsCount);

    }

    onMediaLibDataChange(changeType){
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        this.albums.onChange(changeType);
        this.distributed.onChange(changeType);
    }

    private onUpdateRemoteDevice(res, deviceId, size): void {
        this.logger.info(`onUpdateRemoteDevice size: ${size} deviceId: ${deviceId} type: ${res}`);

        if (res == 'offline') {
            this.needNotify = true;
        }

        if (size <= 0) {
            this.currentIndex = Constants.LOCAL_TAB_INDEX
            tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
            tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;

            if (this.isActive) {
                this.showNotify();
            }
        }

        this.isTabBarShow = (size > 0);
    }

    @Builder LocalAlbumSet() {
        Stack() {
            if (this.isEmpty) {
                NoPhotoIndexComponent({index: Constants.ALBUM_PAGE_INDEX})
            }
            Grid(this.scroller) {
                LazyForEach(this.albums, (item) => {
                    if (this.albums.mediaSetList.indexOf(item) == 0) {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                item: item,
                                isBigCard: true
                            })
                        }.columnStart(0).columnEnd(1)
                    } else {
                        GridItem() {
                            AlbumGridItemNewStyle({
                                item: item,
                                isBigCard: false
                            })
                        }
                    }
                }, item => 'uri:' + item.name)
            }
            .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
            .padding({
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                top: $r('app.float.album_set_page_padding_top'),
                bottom: $r('app.float.album_set_page_padding_end')
            })
            .columnsGap($r('app.float.album_set_grid_column_gap'))
            .rowsGap($r('app.float.album_set_grid_row_gap'))
        }
    }

    @Builder OtherEquipmentAlbumSet() {
        Grid(this.scroller) {
            LazyForEach(this.distributed, (item) => {
                GridItem() {
                    OtherEquipmentAlbumGriItem({item: item})
                }
            }, item => 'uri:' + item.deviceName)
        }
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_end'),
            top: $r('app.float.album_set_page_padding_top'),
            bottom: $r('app.float.album_set_page_padding_end')
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
                AlbumSetPageActionBar({onMenuClicked: this.onMenuClicked})

                TabBarForAlbumSet({
                    currentIndex: this.currentIndex,
                    tabs: tabs,
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

                if(this.isAlbumSetSelectedMode){
                    AlbumSetPageToolBar({onMenuClicked: this.onMenuClicked})
                }

            }
            CustomDialogView()
        }
    }
}
