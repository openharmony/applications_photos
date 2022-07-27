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

import router from '@system.router'
import prompt from '@system.prompt';
import { Logger } from '../../utils/Logger'
import { PhotoGridPageActionBar } from './PhotoGridPageActionBar'
import { PhotoGridPageToolBar } from './PhotoGridPageToolBar'
import { ImageGridItemComponent } from '../../../../common/view/ImageGridItemComponent'
import { Action } from '../../../../common/view/browserOperation/Action'
import { CustomDialogView } from '../../../../common/view/dialog/CustomDialogView'
import { SelectManager } from '../../../../common/model/browser/SelectManager'
import { BroadCast } from '../../../../common/utils/BroadCast'
import { BroadCastConstants } from '../../../../common/model/common/BroadCastConstants'
import { Constants } from '../../../../common/model/common/Constants'
import { MenuOperation } from '../../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../../common/view/browserOperation/MenuContext'
import { MenuOperationFactory } from '../../../../common/interface/MenuOperationFactory'
import { BatchDeleteMenuOperation } from '../../../../common/view/browserOperation/BatchDeleteMenuOperation'
import { MediaDataSource } from '../../../../common/model/browser/photo/MediaDataSource'
import { MediaItem } from '../../../../common/model/browser/photo/MediaItem'
import { ScreenManager } from '../../../../common/model/common/ScreenManager'
import { TraceControllerUtils } from '../../../../common/utils/TraceControllerUtils'
import { ShareMenuOperation } from '../../../../common/view/browserOperation/ShareMenuOperation';
import { BroadCastManager } from '../../../../common/model/common/BroadCastManager'
import { JumpSourceToMain } from '../../../../common/model/browser/photo/JumpSourceToMain'
import { UiUtil } from '../../../../common/utils/UiUtil';
import { AlbumDefine } from '../../../../common/model/browser/AlbumDefine'
import { MediaOperationType } from '../../../../common/model/common/MediaOperationType'
import { CopyMenuOperation } from '../../../../common/view/browserOperation/CopyMenuOperation';
import { MoveMenuOperation } from '../../../../common/view/browserOperation/MoveMenuOperation';
import { GridScrollBar } from '../../../../common/view/GridScrollBar';
import { BatchRecoverMenuOperation } from './BatchRecoverMenuOperation';
import { ClearRecycleMenuOperation } from './ClearRecycleMenuOperation';
import { AlbumInfo } from '../../../../common/model/browser/album/AlbumInfo';
import { MediaObserver } from '../../../../common/model/browser/dataObserver/MediaObserver';
import { CommonObserverCallback } from '../../../../common/model/browser/CommonObserverCallback';
import { NoPhotoComponent } from '../../../../common/view/NoPhotoComponent';

// Album Page
@Entry
@Component
export struct PhotoGridPage {
    @Provide isHideScrollBar: boolean = true;
    @Provide isEmpty: boolean = false;
    @State gridRowCount: number = 0;
    @Provide isSelectedMode: boolean = false;
    @Provide isAllSelected: boolean = false;
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isShow: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    albumInfo: AlbumInfo;
    title: string;
    deviceName: string;
    dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
    scroller: Scroller = new Scroller();
    isDataFreeze = false;
    logger: Logger = new Logger('PhotoGridPage');
    mSelectManager = new SelectManager();
    isActive = false;
    isDistributedAlbum = false;
    deleteMode: boolean = false;
    routerStart = false;
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

    onIndexChange() {
        this.logger.info(`onIndexChange ${this.PhotoGridPageIndex}`)
        if (this.PhotoGridPageIndex != Constants.INVALID) {
            this.scroller.scrollToIndex(this.PhotoGridPageIndex);
        }
    }

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
        let menuContext: MenuContext;
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.BACK:
                if (AppStorage.Get(Constants.BACK_FROM_FORM_DETAIL)) {
                    this.routerAblumSetPage();
                } else {
                    router.back();
                }
                break;
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
                    .withBroadCast(this.broadCast)
                    .withAlbumId(this.albumInfo.id)
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
            case Action.CLEAR_RECYCLE:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                    .withAlbumId(AlbumDefine.ALBUM_ID_RECYCLE)
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(ClearRecycleMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            case Action.RECOVER:
                menuContext = new MenuContext();
                this.onDeleteStart = this.onDeleteStart.bind(this);
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext
                    .withAlbumId(AlbumDefine.ALBUM_ID_RECYCLE)
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onDeleteStart)
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(BatchRecoverMenuOperation, menuContext);
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
                    .withSelectManager(this.mSelectManager)
                    .withOperationStartCallback(this.onDownloadStart)
                    .withOperationEndCallback(this.onDownloadEnd)
                    .withBroadCast(this.broadCast)
                    .withRemoteDevice(this.albumInfo.deviceId);
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
                menuOperation.doAction();
                break;
            default:
                break;
        }
    }

    async openDetailsDialog(): Promise<void> {
        if (this.totalSelectedCount == 0) {
            this.logger.error('no select error');
            return;
        } else if (this.totalSelectedCount == 1) {
            this.logger.info('totalSelectedCount is 1');
            await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
                if (selectItems.length != 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [selectItems[0], this.isDistributedAlbum]);
            });
        } else {
            await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
                if (selectItems.length <= 1) {
                    this.logger.error('get selectItems is error');
                    return;
                }
                let size = 0;
                selectItems.forEach((item) => {
                    size = size + item.size;
                })

                this.logger.info(`openDetailsDialog size: ${size}`);
                this.broadCast.emit(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG, [this.totalSelectedCount, size]);
            });
            return;
        }
    }

    routerAblumSetPage() {
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
                albumId: this.albumInfo.id
            }
        });
    }

    routeToAddMediaPage(): void {
        router.push({
            uri: 'feature/browser/view/album/AlbumSelect',
            params: {
                albumInfo: JSON.stringify(this.albumInfo)
            }
        });
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
        this.onModeChange();
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
        if (err) {
            UiUtil.showToast($r('app.string.copy_failed_single'));
        }
    }

    onDownloadStart(): void {
        this.logger.info(`onDownloadStart`);
        this.isDataFreeze = true;
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        this.dataSource.freeze();
    }

    async onDownloadEnd(err, count, total) {
        this.logger.info(`onDownloadEnd count: ${count}, total: ${total}`);
        this.isDataFreeze = false;
        this.onModeChange();
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
        if (err) {
            if (total > 1) {
                this.logger.error(`get selectItems is error ${count}`);
                let str = await UiUtil.getResourceString($r('app.string.download_failed_multi'));
                let naviBarHeight = ScreenManager.getInstance().getNaviBarHeight()
                let message = str.replace('%d', count.toString());
                prompt.showToast({
                    message: message,
                    duration: UiUtil.TOAST_DURATION,
                    bottom: `${64 + naviBarHeight}vp`
                });
            } else {
                UiUtil.showToast($r('app.string.download_failed_single'))
            }
            ;
        } else {
            UiUtil.showToast($r('app.string.download_progress_done'));
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
        this.onModeChange();
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.switchRefreshOn();
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
        if (err) {
            UiUtil.showToast($r('app.string.move_failed_single'));
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
        this.onModeChange();
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.onChange(Constants.MEDIA_TYPE_IMAGE);
        this.dataSource.unfreeze();
    }

    freezeAdapter(fn): Function {
        let _self = this;
        return function () {
            if (_self.isDataFreeze) {
                return;
            }
            let context = this;
            let args = arguments;
            fn.apply(context, args);
        }
    }

    onModeChange() {
        this.logger.info('onModeChange');
        this.isSelectedMode = false;
        this.mSelectManager.onModeChange(false);
    }

    onPageShow() {
        this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
        this.isShow = true
        let params = router.getParams();
        if (this.routerStart && params && params.pageType && params.albumInfo) {
            this.logger.info('MediaOperation back');
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

    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            this.dataSource && this.dataSource.onActive();
            if (this.isSelectedMode) {
                this.totalSelectedCount = this.mSelectManager.getSelectedCount();
                this.dataSource.forceUpdate();
            }
        }
    }

    onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.dataSource && this.dataSource.onInActive();
        }
    }

    private onUpdateFavorState(item: MediaItem): void {
        this.logger.debug('onUpdateFavorState');
        let index = this.dataSource.getIndexByMediaItem(item);
        if (index != -1) {
            this.dataSource.onDataChanged(index);
        }
    }

    onBackPress() {
        if (AppStorage.Get(Constants.BACK_FROM_FORM_DETAIL)) {
            this.routerAblumSetPage();
            return true;
        }
        if (this.isSelectedMode) {
            this.onModeChange();
            return true;
        }
        return false;
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

    aboutToAppear(): void {
        TraceControllerUtils.startTrace('PhotoGridPageAboutToAppear');
        let param = router.getParams();
        if (param.item) {
            this.logger.debug(`After router.getParams, param is: ${JSON.stringify(param)}`);
            this.albumInfo = JSON.parse(param.item.toString());
            this.title = this.albumInfo.displayName;
            this.dataSource.setAlbumId(this.albumInfo.id);

            if (param.isDistributedAlbum) {
                this.isDistributedAlbum = new Boolean(param.isDistributedAlbum).valueOf();
                param.distributedAlbumName && (this.title = param.distributedAlbumName.toString());
                this.dataSource.setDeviceId(this.albumInfo.deviceId);
                this.mSelectManager.setDeviceId(this.albumInfo.deviceId);
            }
        }

        let self = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.dataSource.setBroadCast(this.broadCast)
        this.mSelectManager.setPhotoDataImpl();
        this.mSelectManager.setAlbumId(this.albumInfo.id);
        MediaObserver.getInstance().registerObserver(this.dataObserver);

        this.broadCast.on(BroadCastConstants.SELECT,
            (position: number, key: string, value: boolean, callback: Function) => {
                if (self.mSelectManager.toggle(key, value)) {
                    self.logger.info('enter event process')
                    if (!self.isSelectedMode) {
                        self.isSelectedMode = true;
                    }
                    callback();
                }
            });
        this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaItem) => {
            let targetIndex = self.dataSource.getDataIndex(item);
            if (targetIndex == Constants.NOT_FOUND) {
                self.logger.error('targetIndex is not found');
                return;
            }
            self.logger.info(`jump to photo browser at index: ${targetIndex}`);
            let pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
            if (self.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
                pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
            } else if (self.isDistributedAlbum) {
                pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
            }

            AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
            router.push({
                uri: 'feature/browser/view/photo/PhotoBrowser',
                params: {
                    position: targetIndex,
                    transition: name,
                    leftBlank: self.leftBlank,
                    pageFrom: pageEntryFrom,
                    deviceName: self.deviceName,
                    albumInfo: self.albumInfo
                }
            });
        });
        this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaItem) => {
            self.logger.info('JUMP_THIRD_PHOTO_BROWSER');
            let targetIndex = self.dataSource.getDataIndex(item);
            if (targetIndex == Constants.NOT_FOUND) {
                self.logger.error('targetIndex is not found');
                return;
            }
            self.logger.info(`jump to photo browser at index: ${targetIndex} ${name}`);
            let pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
            if (self.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
                pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
            } else if (self.isDistributedAlbum) {
                pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
            }
            AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
            router.push({
                uri: 'feature/browser/view/photo/SelectPhotoBrowser',
                params: {
                    position: targetIndex,
                    transition: name,
                    pageFrom: pageEntryFrom,
                    deviceId: self.albumInfo.deviceId
                }
            });
        });
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
        });
        this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));

        if (this.albumInfo.deviceId) {
            this.logger.info(`deviceId size: ${this.albumInfo.deviceId}`);
            this.appBroadCast.on(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));
        }
        AppStorage.SetOrCreate(Constants.THIRD_SELECT_MANAGER, this.mSelectManager);
        this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
            self.logger.info(`allSelect ${newState}`);
            self.isAllSelected = newState;
            self.dataSource.forceUpdate();
        }));
        this.mSelectManager.registerCallback('updateCount', this.freezeAdapter((newState: number) => {
            self.logger.info(`updateSelectedCount ${newState}`);
            self.moreMenuList = Boolean(newState) ? [Action.MOVE, Action.COPY, Action.INFO]
                                                  : [Action.MOVE_INVALID, Action.COPY_INVALID, Action.INFO_INVALID];
            self.totalSelectedCount = newState;
        }));
        this.dataSource.registerCallback('updateCount', (newState: number) => {
            self.logger.info(`updateTotalCount ${newState}`);
            self.isHideScrollBar = (newState <= Constants.SCROLL_BAR_VISIBLE_THRESHOLD);
            self.isEmpty = !Boolean(newState)
            self.mSelectManager.setTotalCount(newState);
        })

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

        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.initGridRowCount();
        });

        this.initGridRowCount();
        this.moreMenuList = [Action.MOVE, Action.COPY, Action.INFO];
        TraceControllerUtils.finishTrace('PhotoGridPageAboutToAppear');
    }

    private initGridRowCount(): void {
        let contentWidth = ScreenManager.getInstance().getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        this.logger.info(`initGridRowCount contentWidth: ${contentWidth}`);
    }

    private onUpdateRemoteDevice(res, deviceId): void {
        this.logger.info(`onUpdateRemoteDevice`);
        if (deviceId != this.albumInfo.deviceId || this.isActive == false) {
            this.logger.debug(`other device`);
            return;
        }
        if (res == Constants.DEVICE_STATE_OFFLINE) {
            this.logger.debug(`device offline route to album main`);
            router.back({
                uri: this.isHorizontal === true ? 'product/pad/view/index' : 'product/phone/view/index',
                params: {
                    jumpSource: JumpSourceToMain.ALBUM,
                }
            });
        } else {
            this.logger.error(`res code is err ${res}`);
            return;
        }
    }

    onMediaLibDataChange(changeType) {
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        this.dataSource.onChange(changeType);
    }

    aboutToDisappear(): void {
        this.logger.info(`aboutToDisappear`);
        this.broadCast.off(null, null);
        this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
        this.appBroadCast.off(BroadCastConstants.ON_REMOTE_CHANGED, this.onUpdateRemoteDevice.bind(this));
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    }

    build() {
        Column() {
            PhotoGridPageActionBar({
                title: this.title,
                albumId: this.albumInfo.innerId,
                onMenuClicked: this.onMenuClicked,
                isRecycle: this.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE,
                isDistributedAlbum: this.isDistributedAlbum
            })

            if (this.isEmpty) {
                NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
            } else {
                Stack() {
                    Grid(this.scroller) {
                        LazyForEach(this.dataSource, (item) => {
                            GridItem() {
                                ImageGridItemComponent({
                                    item: item.mediaItem,
                                    isSelected: this.isSelectedMode ?
                                    this.mSelectManager.isItemSelected(item.mediaItem.uri) : false,
                                    pageName: Constants.PHOTO_TRANSITION_ALBUM
                                })
                            }
                            .columnStart(item.viewIndex % this.gridRowCount)
                            .columnEnd(item.viewIndex % this.gridRowCount)
                        }, item => item == null ? JSON.stringify(item) : item.mediaItem.uri)
                    }
                    .columnsTemplate('1fr '.repeat(this.gridRowCount))
                    .columnsGap(Constants.GRID_GUTTER)
                    .rowsGap(Constants.GRID_GUTTER)
                    .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

                    GridScrollBar({ scroller: this.scroller });
                }.layoutWeight(1)
                .padding({
                    bottom: ((this.isSelectedMode || (this.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE)) && !this.isHorizontal) ? Constants.ActionBarHeight : 0
                })

            }

            CustomDialogView();

            if (this.isSelectedMode || (this.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE) && !this.isEmpty) {
                PhotoGridPageToolBar({
                    onMenuClicked: this.onMenuClicked,
                    isRecycleAlbum: (this.dataSource.albumId == AlbumDefine.ALBUM_ID_RECYCLE),
                    isDistributedAlbum: this.isDistributedAlbum
                });
            }

        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 1 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 1 })
            .opacity(0)
    }
}