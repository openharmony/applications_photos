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
import { Logger } from '../../../common/utils/Logger';
import { Action } from '../../../common/view/browserOperation/Action'
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { MenuOperationFactory } from '../../../common/interface/MenuOperationFactory'
import { GotoPhotosMenuOperation } from '../operation/GotoPhotosMenuOperation'
import { DeleteMenuOperation } from '../operation/DeleteMenuOperation'
import { RecoverMenuOperation } from '../operation/RecoverMenuOperation'
import { MoveMenuOperation } from '../../../common/view/browserOperation/MoveMenuOperation'
import { CopyMenuOperation } from '../../../common/view/browserOperation/CopyMenuOperation'
import { FavoriteMenuOperation } from '../operation/FavoriteMenuOperation'
import { DateUtil } from '../../../common/utils/DateUtil'
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView'
import { Constants } from '../../../common/model/common/Constants'
import { MediaItem } from '../../../common/model/browser/photo/MediaItem'
import { PhotoDataSource } from '../../../common/model/browser/photo/PhotoDataSource'
import { BroadCast } from '../../../common/utils/BroadCast'
import { UriDataSource } from '../../../common/model/browser/photo/UriDataSource'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { Constants as PhotoConstants } from '../../../common/model/browser/photo/Constants'
import { PhotoBrowserBg } from '../../../common/view/PhotoBrowserBg'
import { PhotoBrowserActionBar } from './PhotoBrowserActionBar'
import { ToolBar } from '../../../common/view/actionbar/ToolBar'
import { PhotoSwiper } from '../../../common/view/PhotoSwiper'
import { ScreenManager } from '../../../common/model/common/ScreenManager'
import { JumpSourceToMain } from '../../../common/model/browser/photo/JumpSourceToMain'
import { RenameMenuOperation } from '../operation/RenameMenuOperation'
import { RotateMenuOperation } from '../operation/RotateMenuOperation'
import { AddNotesMenuOperation } from '../operation/AddNotesMenuOperation'
import { MediaLibraryAccess } from '../../../common/access/MediaLibraryAccess'
import { MediaOperationType } from '../../../common/model/common/MediaOperationType'
import { AlbumDefine } from '../../../common/model/browser/AlbumDefine'
import { UiUtil } from '../../../common/utils/UiUtil';
import { AlbumInfo } from '../../../common/model/browser/album/AlbumInfo';
import { CommonObserverCallback } from '../../../common/model/browser/CommonObserverCallback';
import { MediaObserver } from '../../../common/model/browser/dataObserver/MediaObserver';
import mMultimodalInputManager from '../../../common/model/common/MultimodalInputManager'
import { TraceControllerUtils } from '../../../common/utils/TraceControllerUtils'
import { PhotoBrowserHolder } from '../../../common/view/PhotoBrowserHolder';
import resourceManager from '@ohos.resourceManager';

// page of large photo
@Entry
@Component
struct PhotoBrowser {
    @State opacity: number = 1;
    @Provide backgroundColor: Resource = $r('app.color.default_background_color');
    @Provide(dateTitle) photoDate: string = '';
    @Provide(timeLocationTitle) timeAndLocation: string = '';
    @Provide menuList: Array<Action> = new Array<Action>();
    private toolMenuList: Array<Action> = new Array<Action>();
    @Provide topMenuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
    @Provide canSwipe: boolean = false;
    @State @Watch('updateMoreMenu') currentShow: boolean = true;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
    @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
    transition: string;
    albumId = '';

    // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
    @Provide(transitionIndex) currentIndex: number = 0;
    controller: SwiperController = new SwiperController();

    // logger
    private logger: Logger = new Logger('PhotoBrowser');

    // DataSource
    private dataSource: PhotoDataSource = new PhotoDataSource();
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);

    // The global BroadCast of the application process. Event registration and destruction should be paired
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private isFromCamera = false;
    private isFromViewData = false;

    // the source of jump to the index page
    private jumpSourceToMain: number = JumpSourceToMain.None;

    // time to view the current picture
    private checkedTransition: string;

    // When clicking quickly, only run aboutToAppear for the first time
    private hasAppeared: boolean;
    private albumInfo: AlbumInfo;
    private deviceName = '';
    private backFromCopy = false;
    private pullDownFlag: boolean = false;
    private entityAlbumList = new Map([
        [`${MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA}`, AlbumDefine.ALBUM_ID_CAMERA],
        [`${
        MediaLibraryAccess.getInstance()
        .PUBLIC_PATH_CAMERA}${AlbumDefine.REMOTE_ALBUM_PATH}/`, AlbumDefine.ALBUM_ID_REMOTE],
        [`${
        MediaLibraryAccess.getInstance()
        .PUBLIC_PATH_IMAGE}${AlbumDefine.SNAPSHOT_ALBUM_PATH}/`, AlbumDefine.ALBUM_ID_SNAPSHOT],
    ]);

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}, isPullingDown: ${this.isPullingDown}`);
        if (this.isPullingDown) {
            return;
        }
        let menuOperation: MenuOperation;
        let menuContext: MenuContext = new MenuContext();
        let currentPhoto = this.getCurrentPhoto();
        switch (action) {
            case Action.BACK:
                this.onBackPress();
                return;
            case Action.INFO:
                this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [currentPhoto, this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED]);
                return;
            case Action.SHARE:
                globalThis.photosAbilityContext.startAbility({
                    'action': 'com.huawei.intent.action.hwCHOOSER',
                    'parameters': {
                        'ability.want.params.INTENT': {
                            'action': 'ability.intent.SEND_DATA',
                            'type': '*/*',
                            'parameters': {
                                'ability.params.stream': currentPhoto.uri
                            }
                        }
                    }
                }).then(() => {
                    this.logger.debug('raul startAbility complete');
                }).catch((error) => {
                    this.logger.error(`raul startAbility failed, error: ${JSON.stringify(error)}`);
                })
                return;
            case Action.NOT_FAVORITE:
            case Action.FAVORITE:
                if (currentPhoto == undefined) {
                    return;
                }
                currentPhoto.isFavor = !currentPhoto.isFavor;
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(FavoriteMenuOperation, menuContext);
                this.updateMenu();
                break;
            case Action.DELETE:
                if (currentPhoto == undefined) {
                    return;
                }
                if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
                    menuContext.withAlbumId(AlbumDefine.ALBUM_ID_RECYCLE);
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(DeleteMenuOperation, menuContext);
                break;
            case Action.RECOVER:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(RecoverMenuOperation, menuContext);
                break;
            case Action.GOTO_PHOTOS:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withJumpSourceToMain(this.jumpSourceToMain);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(GotoPhotosMenuOperation, menuContext);
                break;
            case Action.EDIT:
                if (currentPhoto == undefined || currentPhoto.size == 0) {
                    return;
                }
                globalThis.EditorMediaItem = currentPhoto;
                router.push({
                    uri: 'feature/editor/view/EditMain'
                })
                return;
            case Action.RENAME:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumId(this.albumId);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(RenameMenuOperation, menuContext);
                break;
            case Action.ROTATE:
                if (currentPhoto == undefined) {
                    return;
                }
                let rotateValue = currentPhoto.orientation - Constants.DEFAULT_ROTATE_VALUE + Constants.ROTATE_AROUND;
                if (rotateValue >= Constants.ROTATE_AROUND) {
                    rotateValue = rotateValue - Constants.ROTATE_AROUND;
                }
                currentPhoto.orientation = rotateValue;
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(RotateMenuOperation, menuContext);
                break;
            case Action.ADD_NOTES:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(AddNotesMenuOperation, menuContext);
                break;
            case Action.MOVE:
                this.backFromCopy = true;
                this.routeSelectAlbumPage(MediaOperationType.Move);
                return;
            case Action.COPY:
                this.backFromCopy = true;
                this.routeSelectAlbumPage(MediaOperationType.Copy);
                return;
            case Action.DOWNLOAD:
                this.downLoad();
                return;
            default:
                return;
        }
        menuOperation.doAction();
    }

    onToggleBars() {
        if (this.isShowBar) {
            this.hideBars();
        } else {
            this.showBars();
        }
        this.logger.info(`Toggle bars, isShowBar: ${this.isShowBar}`);
    }

    showBars(): void {
        if (!this.isShowBar) {
            this.isShowBar = true;
            this.backgroundColor = $r('app.color.default_background_color');
            ScreenManager.getInstance().setSystemUi(true);
        }
    }

    hideBars(): void {
        if (this.isShowBar) {
            this.isShowBar = false;
            this.backgroundColor = $r('app.color.black');
            ScreenManager.getInstance().setSystemUi(false);
        }
    }

    routeSelectAlbumPage(pageType: string): void {
        router.push({
            uri: 'common/view/browserOperation/MediaOperationPage',
            params: {
                pageType: pageType,
                albumId: this.albumId
            }
        });
    }

    onPhotoChanged(index: number): void{
        this.logger.info('onPhotoChanged start');
        this.currentIndex = index;
        this.updateActionBar();
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            this.logger.error('onPhotoChanged, item is undefined');
        } else {
            this.logger.debug(`onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}`);
        }
        this.updatePixMapDataSource();
    }

    onDataSizeChanged(size: number): void {
        this.logger.info(`onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            if (this.pageFrom == Constants.ENTRY_FROM.CARD) {
                let menuContext: MenuContext = new MenuContext();
                menuContext.withJumpSourceToMain(this.jumpSourceToMain);
                let menuOperation = MenuOperationFactory.getInstance()
                    .createMenuOperation(GotoPhotosMenuOperation, menuContext);
                menuOperation.doAction()
            } else {
                this.onBackPress();
            }
        }
    }

    updatePixMapDataSource(): void {
        this.dataSource.updatePixMapDataSource(this.currentIndex);
    }

    updateActionBar() {
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined || this.isFromViewData) {
            return;
        }
        this.photoDate = DateUtil.getLocalizedDate(currentPhoto.dateTaken);
        if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
            this.timeAndLocation = `${this.deviceName}/${DateUtil.getLocalizedTime(currentPhoto.dateTaken)}`;
        } else {
            this.timeAndLocation = DateUtil.getLocalizedTime(currentPhoto.dateTaken);
        }
        this.updateMenu();
    }

    updateMenu(): void{
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        if (this.pageFrom == Constants.ENTRY_FROM.CAMERA || this.pageFrom == Constants.ENTRY_FROM.CARD) {
            this.menuList = [Action.GOTO_PHOTOS, Action.INFO];
        } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
            this.menuList = [];
        } else {
            this.menuList = [Action.INFO]
        }

        this.toolMenuList = [];
        this.moreMenuList = [];

        let list: Array<Action> = new Array<Action>();
        switch (this.pageFrom) {
            case Constants.ENTRY_FROM.NORMAL:
            case Constants.ENTRY_FROM.CAMERA:
                list.push(Action.SHARE, currentPhoto.isFavor
                    ? Action.FAVORITE : Action.NOT_FAVORITE, currentPhoto.mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE
                    ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
                break;
            case Constants.ENTRY_FROM.RECYCLE:
                list.push(Action.RECOVER, Action.DELETE);
                break;
            case Constants.ENTRY_FROM.DISTRIBUTED:
                list.push(Action.SHARE, Action.DOWNLOAD);
                break;
            default:
                list.push(Action.SHARE, currentPhoto.isFavor
                    ? Action.FAVORITE : Action.NOT_FAVORITE, currentPhoto.mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE
                    ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
                break;
        }

        if (this.isHorizontal) {
            this.menuList = this.menuList.concat(list);
        } else {
            this.toolMenuList = list;
        }

        if (currentPhoto.mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
            this.moreMenuList.push(Action.MOVE, Action.COPY, Action.RENAME);
            if (this.currentShow) {
                this.moreMenuList.push(Action.ROTATE);
            }
        } else {
            this.moreMenuList.push(Action.MOVE, Action.COPY, Action.RENAME);
        }

    }

    updateMoreMenu() {
        this.moreMenuList = [];
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto.mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
            this.moreMenuList.push(Action.MOVE, Action.COPY, Action.RENAME);
            if (this.currentShow) {
                this.moreMenuList.push(Action.ROTATE);
            }
        } else {
            this.moreMenuList.push(Action.MOVE, Action.COPY, Action.RENAME);
        }
    }

    getCurrentPhoto(): MediaItem {
        return this.dataSource.getRawData(this.currentIndex).data;
    }

    getPhotoByIndex(index: number): MediaItem {
        return this.dataSource.getRawData(index).data;
    }

    async onMoveEnd(err, count, total) {
        this.logger.debug(`onMoveEnd count: ${count}, total: ${total}`);
        if (err) {
            UiUtil.showToast($r('app.string.move_failed_single'));
            return;
        }
        let currentPhoto = this.getCurrentPhoto();
        let newItem = await this.dataSource.getDataById(currentPhoto.id)
        currentPhoto.path = newItem.relativePath;
        this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    }

    onCopyEnd(err, count, total): void {
        this.logger.debug(`onCopyEnd count: ${count}, total: ${total}`);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
        if (err) {
            UiUtil.showToast($r('app.string.copy_failed_single'));
        }
    }

    async onDownloadEnd(err, count, total) {
        this.logger.debug(`onDownloadEnd count: ${count}, total: ${total}`);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
        if (err) {
            UiUtil.showToast($r('app.string.download_failed_single'));
        } else {
            UiUtil.showToast($r('app.string.download_progress_done'));
        }
    }

    onBackPress() {
        this.logger.info('onBackPress');
        this.controller.finishAnimation(this.onBackPressInner.bind(this));
        return true;
    }

    onBackPressInner(): void {
        this.logger.info(`onBackPressInner ${this.checkedTransition}`);
        switch (this.checkedTransition) {
            case Constants.PHOTO_TRANSITION_TIMELINE:
                this.logger.info('onBackPress TimelinePage');
                this.TimelinePageIndex = this.currentIndex; // call scrollTo
                this.TimelinePageIndex = Constants.INVALID;
                break;
            case Constants.PHOTO_TRANSITION_ALBUM:
                this.logger.info('onBackPress PhotoGridPage');
                this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
                this.PhotoGridPageIndex = Constants.INVALID;
                break;
            case Constants.PHOTO_TRANSITION_CAMERA:
                this.logger.info('onBackPress Camera');
                if (this.pageFrom == Constants.ENTRY_FROM.CARD && !this.pullDownFlag) {
                    this.routerGridPaged();
                } else {
                    if (this.pullDownFlag) {
                        this.pullDownFlag = false;
                    }
                    // Entering from the camera does not need to return to close directly
                    globalThis.photosAbilityContext.terminateSelf();
                }
                return;
            default:
                break
        }
        router.back({
            params: {
                index: this.currentIndex
            }
        });
    }

    aboutToDisappear(): void {
        this.logger.info('aboutToDisappear');
        if (!this.isShowBar) {
            ScreenManager.getInstance().setSystemUi(true);
        }
        // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
        if (!this.hasAppeared) {
            return;
        }
        this.dataSource.release();
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
        mMultimodalInputManager.unregisterListener();
    }

    aboutToAppear(): void {
        TraceControllerUtils.startTrace('PhotoBrowserAboutToAppear');
        this.logger.info('photoBrowser aboutToAppear');
        this.hasAppeared = true;
        mMultimodalInputManager.registerListener((control: number) => {
            this.logger.info(`key control: ${control} index ${this.currentIndex}`);
            if (control == 0) {
                if (this.currentIndex > 0) {
                    this.onPhotoChanged(this.currentIndex - 1);
                }
            } else if (control == 1) {
                if (this.currentIndex < this.dataSource.totalCount() - 1) {
                    this.onPhotoChanged(this.currentIndex + 1);
                }
            } else {
                this.onBackPress();
            }
        });
        let param = router.getParams();
        if (param) {
            this.logger.info(`photoBrowser start with param`);
            this.logger.debug(`param: ${JSON.stringify(param)}`);
            if (param.pageFrom) {
                this.pageFrom = parseInt(param.pageFrom.toString());
            }
            if (param.albumInfo) {
                this.albumInfo = param.albumInfo as AlbumInfo;
                this.albumId = this.albumInfo.id;
                this.deviceName = this.albumInfo.deviceName;
            }
            if (this.pageFrom == Constants.ENTRY_FROM.CAMERA) {
                this.dataSource = new PhotoDataSource();
                this.dataSource.initData();
                this.isFromCamera = true;
                this.albumId = AlbumDefine.ALBUM_ID_CAMERA;
                this.jumpSourceToMain = JumpSourceToMain.CAMERA;
                MediaObserver.getInstance().registerObserver(this.dataObserver);
            } else if (this.pageFrom == Constants.ENTRY_FROM.CARD) {
                this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
                this.isFromCamera = true;
                param.albumId && (this.albumId = param.albumId.toString());
                this.jumpSourceToMain = JumpSourceToMain.CAMERA;
                MediaObserver.getInstance().registerObserver(this.dataObserver);
            } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
                this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
            } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
                this.albumInfo = param.albumInfo as AlbumInfo;
                this.dataSource.setDeviceId(this.albumInfo.deviceId);
                this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
            } else if (this.pageFrom == Constants.ENTRY_FROM.VIEW_DATA) {
                this.dataSource = new UriDataSource(String(param.viewData).split(','));
                this.isFromViewData = true;
                param.position && (param.position = Math.min(Number(param.position), this.dataSource.totalCount() - 1))
            } else {
                this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
            }

            this.onPhotoChanged(new Number(param.position).valueOf() || 0);
            this.transition = (this.isFromCamera || this.isFromViewData)
                ? Constants.PHOTO_TRANSITION_CAMERA : (param.transition ? param.transition.toString() : '');
        } else {
            this.logger.info(`photoBrowser start without param`);
            if (this.entryFromHap == Constants.ENTRY_FROM_FORM_ABILITY) {
                this.pageFrom = Constants.ENTRY_FROM.CARD;
                this.albumId = AppStorage.Get(Constants.FROM_ALBUM_ID);
            } else {
                this.pageFrom = Constants.ENTRY_FROM.CAMERA;
                this.albumId = AlbumDefine.ALBUM_ID_CAMERA;
            }
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
            this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
            this.isFromCamera = true;
            this.jumpSourceToMain = JumpSourceToMain.CAMERA;
            MediaObserver.getInstance().registerObserver(this.dataObserver);
            this.onPhotoChanged(AppStorage.Get(Constants.FROM_CURRENT_INDEX) || 0);
            this.transition = Constants.PHOTO_TRANSITION_CAMERA;
        }

        this.checkedTransition = this.transition

        this.onMenuClicked = this.onMenuClicked.bind(this);

        this.dataSource.setBroadCast(this.broadCast);
        this.dataSource.setBroadCastToAlbum(this.broadCast);
        // register event handling
        this.broadCast.on(PhotoConstants.TOGGLE_BAR, () => {
            this.onToggleBars();
        });

        this.broadCast.on(PhotoConstants.HIDE_BARS, () => {
            this.hideBars();
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_START, () => {
            this.logger.info('pulling down start');
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_END, () => {
            this.pullDownFlag = true;
            this.onBackPress();
        });

        this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
            this.onDataSizeChanged(size);
        });

        this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, () => {
            this.onPhotoChanged(this.currentIndex);
        });

        this.broadCast.on(PhotoConstants.SET_FAVOR, (isFavor: boolean) => {
            this.logger.debug('set favor !')
            let currentPhoto = this.getCurrentPhoto();
            if (!isFavor) {
                currentPhoto.isFavor = isFavor;
                this.updateMenu();
            } else {
                this.logger.debug('update favor !')
                this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
            }
        });

        this.broadCast.on(PhotoConstants.RENAME, (result: string[]) => {
            this.logger.info(`rename refresh: ${result[0]}, ${result[1]}`);
            let currentPhoto = this.getCurrentPhoto();
            currentPhoto.title = result[0];
            currentPhoto.displayName = result[1];
            this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        });

        this.broadCast.on(PhotoConstants.ROTATE, (result: number) => {
            this.logger.debug(`rotate finish: ${result}`);
            let currentPhoto = this.getCurrentPhoto();
            currentPhoto.orientation = result;
            let temp = currentPhoto.height;
            currentPhoto.height = currentPhoto.width;
            currentPhoto.width = temp;
            this.dataSource.onDataChanged(this.currentIndex);
            this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_START, (event) => {
            this.logger.debug(`pulling down start : ${JSON.stringify(event)}`);
            this.isPullingDown = true;
        })

        this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, () => {
            this.logger.info('pulling down cancel');
            this.isPullingDown = false;
        })

        this.broadCast.on(PhotoConstants.DELETE, () => {
            this.logger.info('delete finish now update data');
        });

        this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, (state: boolean) => {
            this.logger.debug('current photo show state change');
            this.currentShow = state;
        });

        this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
            this.logger.info(`set swiper swipe ${value}`);
            this.canSwipe = value;
        });

        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, () => {
            this.logger.debug('animate to data reloaded start with edit');
            try {
                this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [0]);
                let id: number = AppStorage.Get(BroadCastConstants.PHOTO_EDIT_SAVE_ID);
                this.logger.debug(`data reloaded start with edit by id ${id}`);
                if (id && id != -1) {
                    let newIndex = this.dataSource.getDataIndexById(id);
                    this.logger.debug(`data reloaded move to ${newIndex}`);
                    let oldIndex = this.currentIndex;
                    // TODO need swiperController swipeTo
                    while (oldIndex != newIndex) {
                        if (oldIndex > newIndex) {
                            this.controller.showPrevious();
                            oldIndex--;
                        } else {
                            this.controller.showNext();
                            oldIndex++;
                        }
                    }
                    this.onPhotoChanged(newIndex);
                }
            } catch (e) {
                this.logger.error(`ON_DATA_RELOADED_WITH_EDIT error ${e}`);
            } finally {
                this.appBroadCast.emit(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
            }
        });

        TraceControllerUtils.finishTrace('PhotoBrowserAboutToAppear');
    }

    onPageShow() {
        TraceControllerUtils.startTrace('PhotoBrowserOnPageShow');
        this.updateActionBar();
        this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
        this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [400]);
        let params = router.getParams();
        if (params != null && params.pageType != null && this.backFromCopy) {
            this.logger.debug(`MediaOperation back ${JSON.stringify(params)}`)
            let menuContext = new MenuContext();
            let menuOperation: MenuOperation;
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                this.logger.error('MediaOperation currentPhoto is undefined');
                return;
            }
            switch (params.pageType) {
                case MediaOperationType.Move:
                    this.onMoveEnd = this.onMoveEnd.bind(this);
                    menuContext.withMediaItem(currentPhoto)
                        .withBroadCast(this.broadCast)
                        .withAlbumInfo(JSON.parse(params.albumInfo ? params.albumInfo.toString() : ''))
                        .withOperationEndCallback(this.onMoveEnd);
                    menuOperation = MenuOperationFactory.getInstance()
                        .createMenuOperation(MoveMenuOperation, menuContext);
                    break;
                case MediaOperationType.Copy:
                    this.onCopyEnd = this.onCopyEnd.bind(this);
                    menuContext.withMediaItem(currentPhoto)
                        .withBroadCast(this.broadCast)
                        .withAlbumInfo(JSON.parse(params.albumInfo ? params.albumInfo.toString() : ''))
                        .withOperationEndCallback(this.onCopyEnd);
                    menuOperation = MenuOperationFactory.getInstance()
                        .createMenuOperation(CopyMenuOperation, menuContext);
                    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
                    break;
            }
            menuOperation.doAction();
        }
        this.backFromCopy = false;
        TraceControllerUtils.finishTrace('PhotoBrowserOnPageShow');
    }

    private downLoad() {
        this.logger.info('downLoad run');
        let menuContext = new MenuContext();
        let menuOperation: MenuOperation;
        let currentPhoto = this.getCurrentPhoto();
        this.onDownloadEnd = this.onDownloadEnd.bind(this);
        if (currentPhoto == undefined) {
            this.logger.error('MediaOperation currentPhoto is undefined');
            return;
        }
        menuContext
            .withMediaItem(currentPhoto)
            .withBroadCast(this.broadCast)
            .withRemoteDevice(this.albumInfo.deviceId)
            .withOperationEndCallback(this.onDownloadEnd)
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
        menuOperation.doAction();
    }

    onPageHide() {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
        this.showBars();
    }

    onMediaLibDataChange(changeType) {
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        this.dataSource.onChange(changeType);
    }

    private async getResourceString(resource: Resource) {
        try {
            this.logger.info(`getResourceString: ${JSON.stringify(resource)}`);
            let mgr: resourceManager.ResourceManager = await resourceManager.getResourceManager(globalThis.photosAbilityContext);
            if (mgr != null || mgr != undefined) {
                return await mgr.getString(resource.id);
            } else {
                this.logger.error(`getResourceManager instance is none`);
                return null;
            }
        } catch (error) {
            this.logger.error(`getResourceString error: ${error}`);
            return null;
        }
    }

    private async fixDefaultEntityAlbum(album: AlbumInfo) {
        let value = this.entityAlbumList.get(album.relativePath);
        if (value != undefined) {
            album.displayName = await this.getAlbumDisplayName(value);
            album.innerId = value;
        }
    }

    private async getAlbumDisplayName(formId) {
        this.logger.debug('getAlbumDisplayName name ' + formId)
        switch (formId) {
            case AlbumDefine.ALBUM_ID_ALL:
                return await this.getResourceString($r('app.string.album_all'));
            case AlbumDefine.ALBUM_ID_CAMERA:
                return await this.getResourceString($r('app.string.album_camera'));
            case AlbumDefine.ALBUM_ID_FAVOR:
                return await this.getResourceString($r('app.string.album_favor'));
            case AlbumDefine.ALBUM_ID_REMOTE:
                return await this.getResourceString($r('app.string.album_remote_device'));
            case AlbumDefine.ALBUM_ID_SNAPSHOT:
                return await this.getResourceString($r('app.string.album_screen_shot'));
            default:
                break;
        }
        return null;
    }

    async routerGridPaged() {
        AppStorage.SetOrCreate(Constants.BACK_FROM_FORM_DETAIL, true);
        let item: AlbumInfo = await this.getAlbumDataById(AppStorage.Get(Constants.FROM_ALBUM_ID));
        if (item == null) {
            return;
        }
        this.logger.info(`item.displayName: ${item.displayName} item ${JSON.stringify(item)}`);
        router.replace({
            uri: 'feature/photoGrid/view/PhotoGridPage',
            params: {
                item: JSON.stringify(item)
            }
        });
    }

    async getAlbumDataById(id: any, deviceId?: any) {
        this.logger.info(`getAlbumDataById id ${id}`);
        switch (id) {
            case AlbumDefine.ALBUM_ID_ALL:
            case AlbumDefine.ALBUM_ID_VIDEO:
                let file = await await MediaLibraryAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOpt(id));
                if (file.count > 0) {
                    let data = new AlbumInfo(id, '',
                        id, await this.getAlbumDisplayName(id), file.count, '', '');
                    data.coverOrientation = file.obj.orientation;
                    data.innerId = id;
                    return data;
                }
                return null;
            case AlbumDefine.ALBUM_ID_FAVOR:
                let favAlbum = await MediaLibraryAccess.getInstance()
                    .getFavoriteAlbum(AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_FAVOR));
                if (favAlbum.count > 0) {
                    let fav = new AlbumInfo(AlbumDefine.ALBUM_ID_FAVOR, '', AlbumDefine.ALBUM_ID_FAVOR,
                        await this.getAlbumDisplayName(AlbumDefine.ALBUM_ID_FAVOR), favAlbum.count, '', '');
                    fav.coverOrientation = favAlbum.file.orientation;
                    fav.innerId = fav.id;
                    return fav;
                }
                return null;
            case AlbumDefine.ALBUM_ID_RECYCLE:
                let trashAlbum = await MediaLibraryAccess.getInstance()
                    .getTrashAlbum(AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_RECYCLE));
                if (trashAlbum.count > 0) {
                    let trash = new AlbumInfo(AlbumDefine.ALBUM_ID_RECYCLE, '', AlbumDefine.ALBUM_ID_RECYCLE,
                        await this.getAlbumDisplayName(AlbumDefine.ALBUM_ID_RECYCLE), trashAlbum.count, '', '');
                    trash.coverOrientation = trashAlbum.file.orientation;
                    trash.innerId = trash.id;
                    return trash;
                }
                return null;
            default:
                let albums = await MediaLibraryAccess.getInstance()
                    .getAlbums(AlbumDefine.getAlbumFetchOpt(id, deviceId));
                if (albums && albums.length > 0) {
                    let fileResult = await albums[0].getFileAssets(AlbumDefine.getFileFetchOpt(''));
                    let count = fileResult.getCount();
                    if (count <= 0) {
                        return null;
                    }
                    let obj = await fileResult.getFirstObject();
                    this.logger.info(`albumName: ${albums[0].albumName} file count: ${count} coverUri:${obj.uri} relativePath: ${albums[0].relativePath} id: ${albums[0].albumId}`);

                    let album = new AlbumInfo(`${albums[0].albumId}`, '',
                        albums[0].albumName, albums[0].albumName, count, '', obj.relativePath);
                    album.coverOrientation = obj.orientation;
                    album.uri = albums[0].albumUri;
                    album.innerId = album.id;
                    await this.fixDefaultEntityAlbum(album);
                    fileResult.close();
                    return album;
                } else {
                    this.logger.info(`getAlbumDataById error!`);
                    return null;
                }
                break;
        }
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.dataSource,
                transition: this.transition,
                swiperController: this.controller,
                onPhotoChanged: this.onPhotoChanged.bind(this)
            })
            if (!this.isFromViewData) {
                PhotoBrowserActionBar({
                    onMenuClicked: this.onMenuClicked,
                })
                ToolBar({
                    isShowBar: $isShowBar,
                    toolMenuList: this.toolMenuList,
                    onMenuClicked: this.onMenuClicked,
                    isFromPhotoBrowser: true
                })
                PhotoBrowserHolder()
                CustomDialogView()
            } else {
                Column() {
                    PhotoBrowserActionBar({
                        onMenuClicked: (action) => this.onMenuClicked(action)
                    })
                    Text(`${this.currentIndex + 1}/${this.dataSource.totalCount()}`)
                        .height($r('app.float.menu_height'))
                        .fontColor($r('app.color.text_color_secondary'))
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .markAnchor({ x: '0%', y: '0%' })
                        .position({
                            x: '0%',
                            y: ScreenManager.getInstance().getStatusBarHeight() + Constants.ActionBarHeight
                        })
                }.alignItems(HorizontalAlign.Start)
            }
        }
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
