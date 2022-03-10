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
import {Logger} from '../../utils/Logger'
import {Action} from '../../../../common/model/browser/operation/Action.ets'
import {MenuOperation} from '../../../../common/model/browser/operation/MenuOperation'
import {MenuContext} from '../../../../common/model/browser/operation/MenuContext'
import {MenuOperationFactory} from '../../../../common/model/browser/interface/MenuOperationFactory.ets'
import {GotoPhotosMenuOperation} from '../../../../common/model/browser/operation/GotoPhotosMenuOperation'
import {DeleteMenuOperation} from '../../../../common/model/browser/operation/DeleteMenuOperation'
import {RecoverMenuOperation} from '../../../../common/model/browser/operation/RecoverMenuOperation'
import {MoveMenuOperation} from '../../../../common/model/browser/operation/MoveMenuOperation'
import {CopyMenuOperation} from '../../../../common/model/browser/operation/CopyMenuOperation'
import {FavoriteMenuOperation} from '../../../../common/model/browser/operation/FavoriteMenuOperation'
import {DateUtil} from '../../../../common/utils/DateUtil'
import {CustomDialogView} from '../../../../common/view/dialog/CustomDialogView'
import {Constants} from '../../../../common/model/common/Constants.ets'
import {MediaItem} from '../../../../common/model/browser/photo/MediaItem.ets'
import {PhotoDataSource} from '../../../../common/model/browser/photo/PhotoDataSource.ets'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager'
import {Constants as PhotoConstants} from '../../../../common/model/browser/photo/Constants'
import {PhotoBrowserBg} from '../../../../common/view/PhotoBrowserBg'
import {PhotoBrowserActionBar} from './PhotoBrowserActionBar'
import {ToolBar} from '../../../../common/view/actionbar/ToolBar'
import {PendingTask} from '../../../../common/model/browser/photo/PendingTask'
import {PendingCondition} from '../../../../common/model/browser/photo/PendingCondition'
import {PhotoSwiper} from '../../../../common/view/PhotoSwiper.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import {JumpSourceToMain} from '../../../../common/model/browser/photo/JumpSourceToMain'
import {RenameMenuOperation} from '../../../../common/model/browser/operation/RenameMenuOperation'
import {RotateMenuOperation} from '../../../../common/model/browser/operation/RotateMenuOperation'
import {AddNotesMenuOperation} from '../../../../common/model/browser/operation/AddNotesMenuOperation'
import {DetailsDialog} from '../../../../common/view/dialog/DetailsDialog.ets'
import {MediaLibraryAccess} from '../../../../common/access/MediaLibraryAccess'
import {MediaOperationType} from '../../../../common/model/common/MediaOperationType'
import {AlbumDefine} from '../../../../common/model/browser/AlbumDefine.ets'
import {UiUtil} from '../../../../common/utils/UiUtil.ets';
import mMultimodalInputManager from '../../../../common/model/common/MultimodalInputManager.ets'


// page of large photo
@Entry
@Component
struct PhotoBrowser {
    @State opacity: number = 1;
    @State isInPageTransition: boolean = true;
    @Provide backgroundColor: Resource = $r('app.color.default_background_color');
    @Provide(dateTitle) photoDate: string = '';
    @Provide(timeLocationTitle) timeAndLocation: string = '';
    @Provide menuList: Array<Action> = new Array<Action>();
    @Provide toolMenuList: Array<Action> = new Array<Action>();
    @Provide topMenuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
    @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];

    transition: string;

    albumName = '';

    // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
    @Provide(transitionIndex) currentIndex: number = 0;
    controller: SwiperController = new SwiperController();

    // logger
    private logger: Logger = new Logger('PhotoBrowser');

    // DataSource
    private dataSource: PhotoDataSource = new PhotoDataSource();

    // is in animation
    private isInAnimation = true;

    // update pending queue
    private pendingUpdateActionBar: PendingTask;

    // The global BroadCast of the application process. Event registration and destruction should be paired
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private isFromCamera = false;

    private pageFrom: number = Constants.ENTRY_FROM.NORMAL;

    // the source of jump to the index page
    private jumpSourceToMain: number = JumpSourceToMain.None;

    // time when clicks the thumbnail from the camera
    private clickThumbnailTime = 0;

    // time to view the current picture
    private viewTime = 0;
    private checkedTransition: string;

    // When clicking quickly, only run aboutToAppear for the first time
    private hasAppeared: boolean;

    private deviceId = '';
    private deviceName = '';

    private dialogController: CustomDialogController = new CustomDialogController({
        builder: DetailsDialog(),
        autoCancel: true,
        alignment: DialogAlignment.Bottom,
        offset: { dx: 0,
            dy: $r('app.float.dialog_offset_bottom')
        }
    });

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
                    this.logger.debug(`raul startAbility failed, error: ${JSON.stringify(error)}`);
                })
                return;
            case Action.NOT_FAVORITE:
            case Action.FAVORITE:
                if (currentPhoto == undefined) {
                    return;
                }
                currentPhoto.isFavor = !currentPhoto.isFavor;
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(FavoriteMenuOperation, menuContext);
                this.updateMenu();
                break;
            case Action.DELETE:
                if (currentPhoto == undefined) {
                    return;
                }
                if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
                    menuContext.withAlbumName(AlbumDefine.ALBUM_NAME_RECYCLE);
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
                break;
            case Action.RENAME:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumName(this.albumName);
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RenameMenuOperation, menuContext);
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
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RotateMenuOperation, menuContext);
                break;
            case Action.ADD_NOTES:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
                menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddNotesMenuOperation, menuContext);
                break;
            case Action.MOVE:
                this.routeSelectAlbumPage(MediaOperationType.Move);
                break;
            case Action.COPY:
                this.routeSelectAlbumPage(MediaOperationType.Copy);
                break;
            case Action.DOWNLOAD:
                this.downLoad();
            default:
                break;
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
            uri: 'common/view/mediaOperation/MediaOperationPage',
            params: {
                pageType : pageType,
                albumName : this.albumName
            }
        });
    }

    onPhotoChanged(index: number): void{
        this.logger.info('onPhotoChanged start');
        this.reportToBigDataForPhotoSlide(index);
        this.currentIndex = index;
        this.updateActionBar();
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            this.logger.error('onPhotoChanged, item is undefined');
        } else {
            this.logger.info(`onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}`);
        }
        this.updatePixMapDataSource();
    }

    onDataSizeChanged(size: number): void {
        this.logger.info(`onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            this.onBackPress();
        }
    }

    updatePixMapDataSource(): void {
        this.dataSource.updatePixMapDataSource(this.currentIndex);
    }

    updateActionBar() {
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
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
        switch (this.pageFrom){
            case Constants.ENTRY_FROM.NORMAL:
            case Constants.ENTRY_FROM.CAMERA:
                list.push(Action.SHARE, currentPhoto.isFavor
                    ? Action.FAVORITE : Action.NOT_FAVORITE, Action.EDIT, Action.DELETE, Action.MORE);
                break;
            case Constants.ENTRY_FROM.RECYCLE:
                list.push(Action.RECOVER, Action.DELETE);
                break;
            case Constants.ENTRY_FROM.DISTRIBUTED:
                list.push(Action.SHARE, Action.DOWNLOAD);
                break;
            default:
                list.push(Action.SHARE, currentPhoto.isFavor
                    ? Action.FAVORITE : Action.NOT_FAVORITE, Action.EDIT, Action.DELETE, Action.MORE);
                break;
        }

        if (this.isHorizontal) {
            this.menuList = this.menuList.concat(list);
        } else {
            this.toolMenuList = list;
        }

        if (currentPhoto.mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
            this.moreMenuList.push(Action.MOVE, Action.COPY, Action.RENAME, Action.ROTATE);
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

    onMoveEnd(): void {
        this.logger.info('move finish');
    }

    async onDownloadEnd(err, count, total) {
        this.logger.debug('onDownloadEnd');

        if(err) {
            UiUtil.showToast($r('app.string.download_failed_single'));
        } else {
            UiUtil.showToast($r('app.string.download_progress_done'));
        }
    }

    private onBackPress() {
        this.logger.info('onBackPress');
        this.controller.finishAnimation(this.onBackPressInner.bind(this));
        router.back({
            params: {
                index: this.currentIndex
            }
        });
        return true;
    }

    private onBackPressInner(): void {
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
                // Entering from the camera does not need to return to close directly
                globalThis.photosAbilityContext.terminateSelf((result) => {
                    this.logger.info(`terminateSelf result: ${JSON.stringify(result)}`);
                })
                break;
            default:
                break
        }
        router.back({
            params: {
                index: this.currentIndex
            }
        });
    }

    private aboutToDisappear(): void {
        this.logger.info('aboutToDisappear');
        if (!this.isShowBar) {
            ScreenManager.getInstance().setSystemUi(true);
        }
        // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
        if (!this.hasAppeared) {
            return;
        }
        this.dataSource.release();
        mMultimodalInputManager.unregisterListener();
    }

    private aboutToAppear(): void {
        this.logger.info('photoBrowser aboutToAppear');
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
        this.hasAppeared = true;
        let param = router.getParams();
        this.logger.info(`param: ${JSON.stringify(param)}`);
        if (param.pageFrom) {
            this.pageFrom = param.pageFrom;
        }
        if (param.albumName) {
            this.albumName = param.albumName;
        }
        if (param.deviceName) {
            this.deviceName = param.deviceName;
        }
        if (this.pageFrom == Constants.ENTRY_FROM.CAMERA) {
            this.dataSource = new PhotoDataSource();
            this.dataSource.initData();
            this.isFromCamera = true;
            this.clickThumbnailTime = param.clickThumbnailTime;
            this.albumName = AlbumDefine.ALBUM_NAME_CAMERA;
            this.jumpSourceToMain = JumpSourceToMain.CAMERA;
        } else if (this.pageFrom == Constants.ENTRY_FROM.CARD) {
            this.dataSource = new PhotoDataSource(param.albumName);
            this.dataSource.initData();
            this.isFromCamera = true;
        } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
            this.dataSource.setAlbumName('Recycle');
            this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
        } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
            this.dataSource.setDeviceId(param.deviceId);
            this.deviceId = param.deviceId;
            this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
        } else {
            this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
        }
        this.pendingUpdateActionBar = new PendingTask(<PendingCondition> {
            shouldPending: () => {
                return this.isInAnimation;
            }
        });

        this.onPhotoChanged(param.position || 0);
        this.transition = this.isFromCamera ? Constants.PHOTO_TRANSITION_CAMERA : param.transition;
        this.checkedTransition = this.transition
        if (this.transition.endsWith('ERROR')) {
            this.checkedTransition = this.transition.substr(0, this.transition.length - 5)
        }

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
            this.onBackPress();
        });

        this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
            this.onDataSizeChanged(size);
        });

        this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, () => {
            this.reportToBigDataForCameraIn();
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
            this.logger.info(`rotate finish: ${result}`);
            let currentPhoto = this.getCurrentPhoto();
            currentPhoto.orientation = result;
            let temp = currentPhoto.height;
            currentPhoto.height = currentPhoto.width;
            currentPhoto.width = temp;
            this.dataSource.onDataChanged(this.currentIndex);
            this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_START, (event) => {
            this.logger.info(`pulling down start : ${JSON.stringify(event)}`);
            this.isPullingDown = true;
        })

        this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, () => {
            this.logger.info('pulling down cancel');
            this.isPullingDown = false;
        })

        this.broadCast.on(PhotoConstants.DELETE, () => {
            this.logger.info('delete finish now update data');
            this.appBroadCast.emit(BroadCastConstants.ON_OPERATION_FINISHED, []);
        });
    }

    private onPageShow() {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
        // after onPageShow，can flush ActionBar
        this.isInAnimation = false;
        this.isInPageTransition = false;
        this.logger.error(`isInPageTransition: ${this.isInPageTransition}`);
        if (this.pendingUpdateActionBar != undefined) {
            this.pendingUpdateActionBar.flush();
        }
        this.viewTime = Date.now();

        let params = router.getParams();
        if(params != null && params.pageType != null) {
            this.logger.info(`MediaOperation back ${JSON.stringify(params)}`)
            let menuContext = new MenuContext();
            let menuOperation: MenuOperation;
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                this.logger.info('MediaOperation currentPhoto is undefined');
                return;
            }
            switch(params.pageType) {
                case MediaOperationType.Move:
                    this.onMoveEnd = this.onMoveEnd.bind(this);
                    menuContext.withMediaItem(currentPhoto)
                        .withBroadCast(this.broadCast)
                        .withAlbumName(params.albumName)
                        .withOperationEndCallback(this.onMoveEnd);
                    menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
                    break;
                case MediaOperationType.Copy:
                    menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumName(params.albumName);
                    menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
                    break;
            }
            menuOperation.doAction();
        }
    }

    private downLoad() {
        this.logger.info('downLoad run');
        let menuContext = new MenuContext();
        let menuOperation: MenuOperation;
        let currentPhoto = this.getCurrentPhoto();
        this.onDownloadEnd = this.onDownloadEnd.bind(this);
        if (currentPhoto == undefined) {
            this.logger.info('MediaOperation currentPhoto is undefined');
            return;
        }
        menuContext
            .withMediaItem(currentPhoto)
            .withBroadCast(this.broadCast)
            .withAlbumName(AlbumDefine.ALBUM_NAME_REMOTE)
            .withOperationEndCallback(this.onDownloadEnd)
            .withRemoteDevice(this.deviceId);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private onPageHide() {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    }

    private releasePixMap(key: string) {
        this.dataSource.releaseCache(key);
    }

    private reportToBigDataForPhotoSlide(index: number): void {
        if (index != this.currentIndex && this.viewTime != 0) {
            this.viewTime = Date.now();
        }
    }

    private reportToBigDataForCameraIn(): void {
        if (this.clickThumbnailTime == 0 || !this.isFromCamera) {
            return;
        }
        this.clickThumbnailTime = 0;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.dataSource,
                transition: this.transition,
                swiperController: this.controller,
                onPhotoChanged: this.onPhotoChanged.bind(this),
                isInPageTransition: $isInPageTransition,
                onReleasePixmap: this.releasePixMap.bind(this)
            })
            PhotoBrowserActionBar({
                onMenuClicked: this.onMenuClicked,
            })
            ToolBar({
                onMenuClicked: this.onMenuClicked, isFromPhotoBrowser: true
            })
            CustomDialogView()
        }
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.Push, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
