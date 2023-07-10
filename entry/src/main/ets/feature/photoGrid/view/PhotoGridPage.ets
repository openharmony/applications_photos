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

import router from '@system.router';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import { ImageGridItemComponent } from '@ohos/base/src/main/ets/components/ImageGridItemComponent';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Constants } from '../../../common/model/common/Constants';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { BatchDeleteMenuOperation } from '@ohos/base/src/main/ets/operation/BatchDeleteMenuOperation';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { ShareMenuOperation } from '@ohos/base/src/main/ets/operation/ShareMenuOperation';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { MediaOperationType } from '@ohos/base/src/main/ets/data/MediaOperationType';
import { CopyMenuOperation } from '@ohos/base/src/main/ets/operation/CopyMenuOperation';
import { MoveMenuOperation } from '@ohos/base/src/main/ets/operation/MoveMenuOperation';
import { GridScrollBar } from '@ohos/base/src/main/ets/components/scrollBar/GridScrollBar';
import { BatchRecoverMenuOperation } from '@ohos/base/src/main/ets/operation/BatchRecoverMenuOperation';
import { ClearRecycleMenuOperation } from '@ohos/base/src/main/ets/operation/ClearRecycleMenuOperation';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import mediaObserver from '@ohos/base/src/main/ets/observer/MediaObserver';
import { CommonObserverCallback } from '@ohos/base/src/main/ets/observer/CommonObserverCallback';
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent';
import { PhotoGridBarModel } from '../model/PhotoGridBarModel';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';

const TAG = "PhotoGridPage"
// Album Page
@Entry
@Component
struct PhotoGridPage {
    @State isSelectUpperLimited: boolean = false;
    @State isHideScrollBar: boolean = true;
    @Provide @Watch('updateActionBar') isEmpty: boolean = false;
    @State gridRowCount: number = 0;
    @Provide @Watch('updateActionBar') isSelectedMode: boolean = false;
    @Provide @Watch('updateActionBar') isAllSelected: boolean = false;
    @Provide('selectedCount') @Watch('updateActionBar') totalSelectedCount: number = 0;
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isShow: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    private albumInfo: SimpleAlbumDataItem;
    title: string;
    deviceName: string;
    scroller: Scroller = new Scroller();
    isDataFreeze = false;
    isActive = false;
    isDistributedAlbum = false;
    deleteMode: boolean = false;
    deleteReady = true;
    routerStart = false;
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private barModel: PhotoGridBarModel = new PhotoGridBarModel();
    private groupDataSource: GroupItemDataSource = new GroupItemDataSource();
    private isMediaLibDataChanged: boolean = true;
    @State actionBarProp: ActionBarProp = new ActionBarProp();
    @State toolBarMenuList: Action[] = new Array<Action>();
    onWindowSizeChangeCallBack = () => this.initGridRowCount();

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(this.title, this.isSelectedMode,
                                this.totalSelectedCount, this.isAllSelected, this.isEmpty);
        this.toolBarMenuList = this.barModel.getMenuList(this.isSelectedMode, this.totalSelectedCount,
                                this.isAllSelected, this.isEmpty);
    }

    onIndexChange() {
        Log.info(TAG, `onIndexChange ${this.PhotoGridPageIndex}`)
        if (this.PhotoGridPageIndex != Constants.INVALID) {
            this.scroller.scrollToIndex(this.PhotoGridPageIndex);
        }
    }

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.BACK:
                if (AppStorage.Get(Constants.BACK_FROM_FORM_DETAIL)) {
                    this.routerAlbumSetPage();
                } else {
                    router.back();
                }
                break;
            case Action.CANCEL:
                this.onModeChange();
                break;
            case Action.SELECT_ALL:
            case Action.DESELECT_ALL:
                this.isAllSelected = !this.groupDataSource.isSelect()
                this.groupDataSource.setSelect(this.isAllSelected)
                this.onSelect()
                break;
            case Action.DELETE:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withDeletePageFromType(BroadcastConstants.DELETE_FROM_GRID)
                    .withAlbumId(this.albumInfo.id)
                    .withDataSource(this.groupDataSource)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                menuOperation = new BatchDeleteMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.SHARE:
                menuContext = new MenuContext();
                menuContext.withDataSource(this.groupDataSource);
                menuOperation = new ShareMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.INFO:
                this.openDetailsDialog();
                break;
            case Action.CLEAR_RECYCLE:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withDataSource(this.groupDataSource)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                menuOperation = new ClearRecycleMenuOperation(menuContext)
                menuOperation.doAction();
                break;
            case Action.RECOVER:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withDataSource(this.groupDataSource)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                menuOperation = new BatchRecoverMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            case Action.MOVE:
                this.routeSelectAlbumPage(MediaOperationType.Move);
                break;
            case Action.COPY:
                this.routeSelectAlbumPage(MediaOperationType.Copy);
                break;
            case Action.NEW:
                this.routeToAddMediaPage();
                break;
            case Action.DOWNLOAD:
                this.onDownloadStart = this.onDownloadStart.bind(this);
                this.onDownloadEnd = this.onDownloadEnd.bind(this);
                menuContext = new MenuContext();
                menuContext
                    .withDataSource(this.groupDataSource)
                    .withOperationStartCallback(this.onDownloadStart)
                    .withOperationEndCallback(this.onDownloadEnd)
                    .withBroadCast(this.broadCast)
                    .withRemoteDevice(this.albumInfo.deviceId);
                menuOperation = new CopyMenuOperation(menuContext);
                menuOperation.doAction();
                break;
            default:
                break;
        }
    }

    async openDetailsDialog(): Promise<void> {
        let items: MediaDataItem[] = this.groupDataSource.getSelectedItems();
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

    private routerAlbumSetPage() {
        router.replace({
            uri: this.isHorizontal === true ? 'product/pad/view/index' : 'product/phone/view/index',
            params: {
                jumpSource: JumpSourceToMain.ALBUM,
            }
        });
    }

    routeSelectAlbumPage(pageType: string): void {
        this.routerStart = true;
        router.push({
            uri: 'common/view/browserOperation/MediaOperationPage',
            params: {
                pageType: pageType,
                albumInfo: JSON.stringify(this.albumInfo)
            }
        });
    }

    private routeToAddMediaPage(): void {
        router.push({
            uri: 'feature/albumSelect/view/AlbumSelect',
            params: {
                albumInfo: JSON.stringify(this.albumInfo)
            }
        });
    }

    onCopyStart(): void {
        Log.info(TAG, `onCopyStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    onCopyEnd(err, count, total): void {
        Log.info(TAG, `onCopyEnd count: ${count}, total: ${total}`);
        this.onModeChange();
        mediaObserver.registerObserver(this.dataObserver);
        if (err) {
            getResourceString($r('app.string.copy_failed_single')).then((message: string) => {
                showToast(message);
            })
        } else {
            animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, () => this.groupDataSource.dataReload(true));
            this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
        }
    }

    onDownloadStart(): void {
        Log.info(TAG, `onDownloadStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    async onDownloadEnd(err, count, total) {
        Log.info(TAG, `onDownloadEnd count: ${count}, total: ${total}`);
        this.onModeChange();
        mediaObserver.registerObserver(this.dataObserver);
        if (err) {
            if (total > 1) {
                Log.warn(TAG, `get selectItems is error ${count}`);
                let str = await getResourceString($r('app.string.download_failed_multi'));
                let message = str.replace('%d', count.toString());
                showToast(message);
            } else {
                getResourceString($r('app.string.download_failed_single')).then((message: string) => {
                    showToast(message);
                })
            }
            ;
        } else {
            getResourceString($r('app.string.download_progress_done')).then((message: string) => {
                showToast(message);
            })
        }
    }

    onMoveStart(): void {
        Log.info(TAG, `onMoveStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    onMoveEnd(err, count, total): void {
        Log.info(TAG, `onMoveEnd count: ${count}, total: ${total}`);
        this.onModeChange();
        mediaObserver.registerObserver(this.dataObserver);
        if (err) {
            getResourceString($r('app.string.move_failed_single')).then((message: string) => {
                showToast(message);
            })
        } else {
            animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, () => this.groupDataSource.dataReload(true));
        }
    }

    onDeleteStart(): void {
        Log.info(TAG, `onDeleteStart`);
        mediaObserver.unregisterObserver(this.dataObserver);
    }

    onDeleteEnd(err): void {
        Log.info(TAG, `onDeleteEnd`);
        this.onModeChange();
        mediaObserver.registerObserver(this.dataObserver);
        animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, () => {
            this.groupDataSource.dataRemove();
            this.isEmpty = this.groupDataSource.groupDataItem.length==0 ? true : false;
            this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
        })
    }

    /**
     * Just change select mode to false
     */
    onModeChange() {
        Log.info(TAG, 'onModeChange');
        if (this.isSelectedMode) {
            this.isSelectedMode = false;
            this.groupDataSource.setSelect(false);
            this.onSelect();
        }
    }

    onPageShow() {
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.isShow = true;
        let params = router.getParams();
        if (this.routerStart && params && params.pageType && params.albumInfo) {
            Log.info(TAG, 'MediaOperation back');
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
    }

    onPageHide() {
        this.isShow = false;
        this.onInActive();
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

    private onUpdateFavorAndSelectState(item: MediaDataItem): void {
        this.onUpdateFavorState(item);
        this.onSelect();
    }

    private onUpdateFavorState(item: MediaDataItem): void {
        Log.debug(TAG, 'onUpdateFavorState favor');
        let index = this.groupDataSource.getIndexByItem(item);
        if (index != -1) {
            this.groupDataSource.notifyDataChange(index);
        }
    }

    onBackPress() {
        if (AppStorage.Get(Constants.BACK_FROM_FORM_DETAIL)) {
            this.routerAlbumSetPage();
            return true;
        }
        if (this.isSelectedMode) {
            this.onModeChange();
            return true;
        }
        return false;
    }

    private moveOperation(albumInfo: SimpleAlbumDataItem) {
        let menuContext = new MenuContext();
        this.onMoveStart = this.onMoveStart.bind(this);
        this.onMoveEnd = this.onMoveEnd.bind(this);
        menuContext.withDataSource(this.groupDataSource)
            .withOperationStartCallback(this.onMoveStart)
            .withOperationEndCallback(this.onMoveEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = new MoveMenuOperation(menuContext);
        menuOperation.doAction();
    }

    private copyOperation(albumInfo: SimpleAlbumDataItem) {
        let menuContext = new MenuContext();
        menuContext.withDataSource(this.groupDataSource)
            .withOperationStartCallback(this.onCopyStart.bind(this))
            .withOperationEndCallback(this.onCopyEnd.bind(this))
            .withBroadCast(this.broadCast)
            .withAlbumInfo(albumInfo);
        let menuOperation = new CopyMenuOperation(menuContext);
        menuOperation.doAction();
    }

    aboutToAppear(): void {
        startTrace('PhotoGridPageAboutToAppear');
        let param = router.getParams();
        if (param.item) {
            Log.debug(TAG, `After router.getParams, param is: ${JSON.stringify(param)}`);
            this.albumInfo = JSON.parse(param.item.toString()) as SimpleAlbumDataItem;
            this.title = this.albumInfo.displayName;
            this.barModel.setAlbumId(this.albumInfo.id)
            this.groupDataSource.setAlbumId(this.albumInfo.id)
            if (param.isDistributedAlbum) {
                this.isDistributedAlbum = new Boolean(param.isDistributedAlbum).valueOf();
                this.barModel.setDistributedAlbum(this.isDistributedAlbum)
                param.distributedAlbumName && (this.title = param.distributedAlbumName.toString());
                this.groupDataSource.setDeviceId(this.albumInfo.deviceId);
            }
        }
        Log.info(TAG, "reloadGroupItemData");

        this.onMenuClicked = this.onMenuClicked.bind(this);
        mediaObserver.registerObserver(this.dataObserver);

        this.broadCast.on(BroadcastConstants.SELECT, (index: number) => this.onSelect());
        this.broadCast.on(BroadcastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToPhotoBrowser(name, item);
        });

        this.broadCast.on(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToThirdPhotoBrowser(name, item);
        });
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
        });
        this.appBroadcast.on(BroadcastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorAndSelectState.bind(this));

        if (this.albumInfo.deviceId) {
            Log.info(TAG, `deviceId size: ${this.albumInfo.deviceId}`);
            this.appBroadcast.on(BroadcastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));
        }

        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);

        this.initGridRowCount();
        this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];

        this.updateActionBar();
        finishTrace('PhotoGridPageAboutToAppear');
    }

    private initGridRowCount(): void {
        let contentWidth = screenManager.getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.TIME_GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
    }

    private onUpdateRemoteDevice(res, deviceId): void {
        Log.info(TAG, `onUpdateRemoteDevice`);
        if (deviceId != this.albumInfo.deviceId || this.isActive == false) {
            Log.debug(TAG, `other device`);
            return;
        }
        if (res == Constants.DEVICE_STATE_OFFLINE) {
            Log.debug(TAG, `device offline route to album main`);
            router.back({
                uri: this.isHorizontal === true ? 'product/pad/view/index' : 'product/phone/view/index',
                params: {
                    jumpSource: JumpSourceToMain.ALBUM,
                }
            });
        } else {
            Log.warn(TAG, `res code is err ${res}`);
            return;
        }
    }

    onMediaLibDataChange(changeType) {
        Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
        this.isMediaLibDataChanged = true;
        this.loadItem();
    }

    private loadItem() {
        if (this.isActive && this.isMediaLibDataChanged) {
            this.groupDataSource.reloadGroupItemData(true).then((isEmpty) => {
                Log.info(TAG, `onMediaLibDataChange load finish`);
                this.isEmpty = isEmpty;
                this.groupDataSource.notifyDataReload();
                this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
            })
        } else if (this.isActive) {
            this.groupDataSource.dataRemove();
            this.isEmpty = this.groupDataSource.groupDataItem.length==0 ? true : false;
        }
    }

    private onSelect() {
        Log.info(TAG, "onSelect");
        this.totalSelectedCount = this.groupDataSource.getSelectedCount();
        this.isAllSelected = this.groupDataSource.isSelect();
        if (this.totalSelectedCount > 0) {
            this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];
        } else {
            this.moreMenuList = [Action.MOVE_INVALID, Action.COPY_INVALID, Action.INFO_INVALID];
        }
    }

    private jumpToPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.groupDataSource.getItems();
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            Log.warn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        let pageEntryFrom
        if (this.albumInfo && this.albumInfo.id == MediaConstants.ALBUM_ID_RECYCLE) {
            pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
        } else if (this.isDistributedAlbum) {
            pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
        } else {
            pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
        }
        router.push({
            uri: 'feature/browser/view/PhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
                albumInfo: this.albumInfo,
                pageFrom: pageEntryFrom
            }
        });
    }

    private jumpToThirdPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.groupDataSource.getItems();
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            Log.warn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        let pageEntryFrom;
        if (this.albumInfo && this.albumInfo.id == MediaConstants.ALBUM_ID_RECYCLE) {
            pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
        } else if (this.isDistributedAlbum) {
            pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
        } else {
            pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
        }
        router.push({
            uri: 'feature/browser/view/SelectPhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
                albumInfo: this.albumInfo,
                pageFrom: pageEntryFrom
            }
        });
    }

    aboutToDisappear(): void {
        Log.info(TAG, `aboutToDisappear`);
        this.broadCast.off(null, null);
        this.appBroadcast.off(BroadcastConstants.UPDATE_DATA_SOURCE, null);
        this.appBroadcast.off(BroadcastConstants.ON_REMOTE_CHANGED, null);
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
        mediaObserver.unregisterObserver(this.dataObserver);
        this.dataObserver.clearSource();
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })

            if (this.isEmpty) {
                NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
            } else {
                Stack() {
                    Grid(this.scroller) {
                        LazyForEach(this.groupDataSource, (item: LazyItem<MediaDataItem>) => {
                            GridItem() {
                                ImageGridItemComponent({
                                    lazyItem: item,
                                    mediaItem: item.get(),
                                    pageName: Constants.PHOTO_TRANSITION_ALBUM,
                                    isSelectUpperLimited: $isSelectUpperLimited
                                })
                            }
                            .aspectRatio(1)
                            .columnStart(item.get().index % this.gridRowCount)
                            .columnEnd(item.get().index % this.gridRowCount)
                        }, (item: LazyItem<MediaDataItem>) => item == null && item.get() ? JSON.stringify(item) : item.getHashCode())
                    }
                    .columnsTemplate('1fr '.repeat(this.gridRowCount))
                    .columnsGap(Constants.GRID_GUTTER)
                    .rowsGap(Constants.GRID_GUTTER)
                    .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

                    GridScrollBar({ scroller: this.scroller, isHideScrollBar: $isHideScrollBar});
                }.layoutWeight(1)
                .padding({
                    bottom: ((this.isSelectedMode || (this.albumInfo.id == MediaConstants.ALBUM_ID_RECYCLE)) && !this.isHorizontal) ? Constants.ActionBarHeight : 0
                })

            }

            CustomDialogView();
            if (this.isSelectedMode || (this.albumInfo.id == MediaConstants.ALBUM_ID_RECYCLE) && !this.isEmpty) {
                ToolBar({
                    toolMenuList: $toolBarMenuList,
                    onMenuClicked: this.onMenuClicked
                })
            }
        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: px2vp(this.leftBlank[1]),
            bottom: px2vp(this.leftBlank[3])
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 1 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 1 })
            .opacity(0)
    }
}