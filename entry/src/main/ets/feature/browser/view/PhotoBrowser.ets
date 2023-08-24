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
import Want from '@ohos.application.Want';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Action } from '../../../common/view/browserOperation/Action';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import {
    GotoPhotosMenuOperation
} from '@ohos/browser/src/main/ets/operation/GotoPhotosMenuOperation';
import { BatchDeleteMenuOperation } from '@ohos/base/src/main/ets/operation/BatchDeleteMenuOperation';
import { BatchRecoverMenuOperation } from '@ohos/base/src/main/ets/operation/BatchRecoverMenuOperation';
import { ClearRecycleMenuOperation } from '@ohos/base/src/main/ets/operation/ClearRecycleMenuOperation';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { MoveMenuOperation } from '@ohos/base/src/main/ets/operation/MoveMenuOperation';
import { CopyMenuOperation } from '@ohos/base/src/main/ets/operation/CopyMenuOperation';
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView';
import { Constants } from '../../../common/model/common/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { Constants as PhotoConstants } from '@ohos/browser/src/main/ets/constants/Constants';
import { PhotoBrowserBg } from '@ohos/browser/src/main/ets/components/PhotoBrowserBg';
import { PhotoBrowserActionBar } from './PhotoBrowserActionBar';
import { ToolBar } from '../../../common/view/actionbar/ToolBar';
import { PhotoSwiper } from '@ohos/browser/src/main/ets/components/PhotoSwiper';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import { RenameMenuOperation } from '@ohos/browser/src/main/ets/operation/RenameMenuOperation';
import { MediaOperationType } from '@ohos/base/src/main/ets/data/MediaOperationType';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { CommonObserverCallback } from '@ohos/base/src/main/ets/observer/CommonObserverCallback';
import mediaObserver from '@ohos/base/src/main/ets/observer/MediaObserver';
import mMultimodalInputManager from '@ohos/base/src/main/ets/manager/MultimodalInputManager';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { InnerMediaDataItem } from '@ohos/browser/src/main/ets/data/InnerMediaDataItem';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { getAlbumDisplayName } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { startAbility, terminateSelf } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import mediaDataItemCache from '@ohos/base/src/main/ets/data/MediaDataItemCache';
import { PhotoEditorManager } from '../../editor/PhotoEditorManager';
// page of large photo

const TAG = "PhotoBrowser"

@Entry
@Component
struct PhotoBrowser {
    @State mOpacity: number = 1;
    @Provide browserBackgroundColor: Resource = $r('app.color.default_background_color');
    @Provide('dateTitle') photoDate: string = '';
    @Provide('timeLocationTitle') timeAndLocation: string = '';
    @Provide menuList: Array<Action> = new Array<Action>();
    @State toolMenuList: Array<Action> = new Array<Action>();
    @Provide topMenuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
    @Provide canSwipe: boolean = false;
    private timeoutId: number = 0;
    @State @Watch('currentShowChange') currentShow: boolean = true;
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
    @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
    photoBrowserTransition: string;
    @State isDataChanged:boolean = true;
    private isFromCard = false;

    // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
    @Provide('transitionIndex') currentIndex: number = 0;
    controller: SwiperController = new SwiperController();
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);

    // The global Broadcast of the application process. Event registration and destruction should be paired
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private isFromCamera = false;
    private isFromViewData = false;

    // the source of jump to the index page
    private jumpSourceToMain: number = JumpSourceToMain.None;

    // time to view the current picture
    private checkedTransition: string;

    // When clicking quickly, only run aboutToAppear for the first time
    private hasAppeared: boolean;
    private albumInfo: SimpleAlbumDataItem;
    private deviceName = '';
    private backFromCopy = false;
    private pullDownFlag: boolean = false;
    private browserDataSource: GroupItemDataSource = new GroupItemDataSource()
    private isToEdit = false;

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}, isPullingDown: ${this.isPullingDown}`);
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
                if (currentPhoto == undefined) {
                    return;
                }
                this.broadCast.emit(BroadcastConstants.SHOW_DETAIL_DIALOG, [currentPhoto, this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED]);
                return;
            case Action.SHARE:
                if (currentPhoto == undefined) {
                    return;
                }
                let want: Want = {
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
                }
                startAbility(want)
                return;
            case Action.NOT_FAVORITE:
            case Action.FAVORITE:
                if (currentPhoto == undefined) {
                    return;
                }
                currentPhoto.setFavor().then((isSuccess: boolean) => this.setFavourite(isSuccess))
                return;
            case Action.DELETE:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withItems([currentPhoto])
                    .withDeletePageFromType(BroadcastConstants.DELETE_FROM_BROWSER)
                    .withAlbumId(this.albumInfo && this.albumInfo.id)
                    .withBroadCast(this.broadCast)
                    .withOperationEndCallback(this.onDeleteEnd.bind(this))
                menuOperation = new BatchDeleteMenuOperation(menuContext);
                break;
            case Action.CLEAR_RECYCLE:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withItems([currentPhoto])
                    .withBroadCast(this.broadCast)
                    .withOperationEndCallback(this.onDeleteEnd.bind(this))
                menuOperation = new ClearRecycleMenuOperation(menuContext);
                break;
            case Action.RECOVER:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext = new MenuContext();
                this.onDeleteEnd = this.onDeleteEnd.bind(this);
                menuContext.withItems([currentPhoto])
                    .withOperationEndCallback(this.onDeleteEnd)
                    .withBroadCast(this.broadCast)
                menuOperation = new BatchRecoverMenuOperation(menuContext);
                break;
            case Action.GOTO_PHOTOS:
                menuContext.withJumpSourceToMain(this.jumpSourceToMain);
                menuOperation = new GotoPhotosMenuOperation(menuContext);
                break;
            case Action.EDIT:
                if (currentPhoto == undefined || currentPhoto.size == 0) {
                    return;
                }
                this.isToEdit = true
                globalThis.EditorMediaItem = currentPhoto;
                router.push({
                    uri: 'feature/editor/view/EditMain'
                })
                return;
            case Action.RENAME:
                if (currentPhoto == undefined) {
                    return;
                }
                menuContext.withItems([currentPhoto])
                    .withBroadCast(this.broadCast)
                    .withAlbumInfo(this.albumInfo);
                menuOperation = new RenameMenuOperation(menuContext);
                break;
            case Action.ROTATE:
                if (currentPhoto == undefined) {
                    return;
                }
                currentPhoto.setOrientation().then(() => this.setOrientation())
                return;
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

    private setFavourite(isSuccess: boolean) {
        Log.debug(TAG, 'set favor !');

        if (isSuccess) {
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                return;
            }
            if (mediaDataItemCache.hasKey(currentPhoto.uri)) {
                mediaDataItemCache.get(currentPhoto.uri).favouriteStatus = currentPhoto.favouriteStatus;
            }
            // 收藏相册进入大图，点击取消收藏会导致Item成员变少，所以要dataRemove
            if(this.albumInfo.id === MediaConstants.ALBUM_ID_FAVOR) {
                this.browserDataSource.reloadGroupItemData(false).then(() => {
                    this.operateEnd();
                });
            }
            this.updateMenu();
            this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        }
    }

    private operateEnd() {
        if (this.currentIndex == 0 || AppStorage.Get("isLeftSwiper") == 0) {
            this.broadCast.emit(BroadcastConstants.ON_DATA_RELOADED, []);
        } else {
            Log.info(TAG, `operateEnd curIndex : ` + this.currentIndex);
            this.broadCast.emit(BroadcastConstants.ON_DATA_RELOADED, []);
            this.currentIndex--;
        }
    }

    private onDeleteEnd() {
        Log.debug(TAG, `onDeleteEnd start`);
        AppStorage.SetOrCreate("isDelete", 0);
        this.operateEnd();
    }

    private setOrientation() {
        Log.debug(TAG, `setOrientation`);
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        this.browserDataSource.notifyDataChange(this.currentIndex);
        this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    }

    onToggleBars() {
        if (this.isShowBar) {
            this.hideBars();
        } else {
            this.showBars();
        }
        Log.info(TAG, `Toggle bars, isShowBar: ${this.isShowBar}`);
    }

    showBars(): void {
        if (!this.isShowBar) {
            this.isShowBar = true;
            this.browserBackgroundColor = $r('app.color.default_background_color');
            screenManager.setSystemUi(true);
        }
    }

    hideBars(): void {
        if (this.isShowBar) {
            this.isShowBar = false;
            this.browserBackgroundColor = $r('app.color.black');
            screenManager.setSystemUi(false);
        }
    }

    routeSelectAlbumPage(pageType: string): void {
        router.push({
            uri: 'common/view/browserOperation/MediaOperationPage',
            params: {
                pageType: pageType,
                albumInfo: JSON.stringify(this.albumInfo)
            }
        });
    }

    onPhotoChanged(index: number): void{
        index = Math.min(index, this.browserDataSource.totalCount() - 1);
        Log.info(TAG, `onPhotoChanged start ${index}`);
        this.currentIndex = this.isToEdit ? 0 : index;
        this.updateActionBar();
    }

    onDataSizeChanged(size: number): void {
        Log.info(TAG, `onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            if (this.pageFrom == Constants.ENTRY_FROM.CARD) {
                let menuContext: MenuContext = new MenuContext();
                menuContext.withJumpSourceToMain(this.jumpSourceToMain);
                let menuOperation = new GotoPhotosMenuOperation(menuContext);
                menuOperation.doAction();
            } else {
                this.onBackPress();
            }
        }
    }

    updateActionBar() {
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined || this.isFromViewData) {
            Log.warn(TAG, `currentPhoto is undefined:${currentPhoto == undefined} this.isFromViewData:${this.isFromViewData} `)
            return;
        }

        // PhotoItems 和 这里都会有load, 极端情况下可能产生一次无效的load
        currentPhoto.load(false).then(() => {
            this.photoDate = DateUtil.getLocalizedDate(currentPhoto.dateAdded);
            if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
                this.timeAndLocation = `${this.deviceName}/${DateUtil.getLocalizedTime(currentPhoto.dateAdded)}`;
            } else {
                this.timeAndLocation = DateUtil.getLocalizedTime(currentPhoto.dateAdded);
            }
            this.updateMenu();
        })
    }

    updateMenu(): void{
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        this.toolMenuList = [];
        this.getActionList(currentPhoto).then((list: Array<Action>) => {
            if (this.pageFrom == Constants.ENTRY_FROM.CAMERA || this.pageFrom == Constants.ENTRY_FROM.CARD) {
                this.menuList = [Action.GOTO_PHOTOS, Action.INFO];
            } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
                this.menuList = [];
            } else {
                this.menuList = [Action.INFO];
            }
            if (this.isHorizontal) {
                this.menuList = this.menuList.concat(list);
            } else {
                this.toolMenuList = list;
            }
            this.updateMoreMenu();
        })
    }

    private async getActionList(currentPhoto: MediaDataItem): Promise<Array<Action>> {
        let list: Array<Action> = new Array<Action>();
        if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
            list.push(Action.RECOVER, Action.DELETE);
        } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
            list.push(Action.SHARE, Action.DOWNLOAD);
        } else {
            let isFavor = await currentPhoto.isFavor();
            list.push(Action.SHARE,
                    isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
                    currentPhoto.mediaType == MediaLib.MediaType.IMAGE ? Action.EDIT : Action.EDIT_INVALID,
                Action.DELETE,
                Action.MORE); // TODO: delete edit
        }
        return list;
    }

    private currentShowChange() {
        this.updateMoreMenu();
    }

    private updateMoreMenu() {
        let currentPhoto = this.getCurrentPhoto();
        this.moreMenuList = [Action.MOVE, Action.COPY, Action.RENAME];
        if (currentPhoto == undefined) {
            return;
        }
        if (currentPhoto.mediaType == MediaLib.MediaType.IMAGE) {
            if (this.currentShow) {
                this.moreMenuList.push(Action.ROTATE);
            }
        }
    }

    getCurrentPhoto(): MediaDataItem {
        return this.browserDataSource.getDataByIndex(this.currentIndex);
    }

    getPhotoByIndex(index: number): MediaDataItem {
        return this.browserDataSource.getDataByIndex(index);
    }

    async onMoveEnd(err, count, total) {
        Log.debug(TAG, `onMoveEnd count: ${count}, total: ${total}`);
        if (err) {
            getResourceString($r('app.string.move_failed_single')).then((message: string) => {
                showToast(message)
            })
            return;
        }
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        currentPhoto.path = (await currentPhoto.loadFileAsset()).relativePath;
        this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    }

    onCopyEnd(err, count, total): void {
        Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
        this.dataSourceLoadFinish()
        if (err) {
            getResourceString($r('app.string.copy_failed_single')).then((message: string) => {
                showToast(message);
            })
        }
    }

    async onDownloadEnd(err, count, total) {
        Log.debug(TAG, `onDownloadEnd count: ${count}, total: ${total}`);
        if (err) {
            getResourceString($r('app.string.download_failed_single')).then((message: string) => {
                showToast(message);
            })
        } else {
            getResourceString($r('app.string.download_progress_done')).then((message: string) => {
                showToast(message);
            })
        }
    }

    onBackPress() {
        Log.info(TAG, 'onBackPress');
        this.controller.finishAnimation(this.onBackPressInner.bind(this));
        return true;
    }

    onBackPressInner(): void {
        Log.info(TAG, `onBackPressInner ${this.checkedTransition}`);
        switch (this.checkedTransition) {
            case Constants.PHOTO_TRANSITION_TIMELINE:
                Log.info(TAG, 'onBackPress TimelinePage');
                this.TimelinePageIndex = this.currentIndex; // call scrollTo
                break;
            case Constants.PHOTO_TRANSITION_ALBUM:
                Log.info(TAG, 'onBackPress PhotoGridPage');
                this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
                break;
            case Constants.PHOTO_TRANSITION_CAMERA:
                Log.info(TAG, 'onBackPress Camera');
                if (this.pageFrom == Constants.ENTRY_FROM.CARD && !this.pullDownFlag) {
                    this.routerGridPaged();
                } else {
                    if (this.pullDownFlag) {
                        this.pullDownFlag = false;
                    }
                    // Entering from the camera does not need to return to close directly
                    terminateSelf();
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
        Log.info(TAG, 'aboutToDisappear');
        screenManager.setNavigationBarColor('#00FFFFFF', '#FF000000');
        if (!this.isShowBar) {
            screenManager.setSystemUi(true);
        }
        // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
        if (!this.hasAppeared) {
            return;
        }
        mediaObserver.unregisterObserver(this.dataObserver);
        this.dataObserver.clearSource();
        mMultimodalInputManager.unregisterListener();
        this.broadCast.off(null, null);
        this.controller = undefined;
    }

    aboutToAppear(): void {
        startTrace('PhotoBrowserAboutToAppear');
        Log.info(TAG, 'photoBrowser aboutToAppear');
        AppStorage.SetOrCreate("isDelete", 0);
        AppStorage.SetOrCreate("isLeftSwiper", 0);
        screenManager.setNavigationBarColor('#FFF1F3F5', '#FF000000');
        this.hasAppeared = true;
        mMultimodalInputManager.registerListener((control: number) => {
            Log.info(TAG, `key control: ${control} index ${this.currentIndex}`);
            if (control == 0) {
                if (this.currentIndex > 0) {
                    this.onPhotoChanged(this.currentIndex - 1);
                }
            } else if (control == 1) {
                if (this.currentIndex < this.browserDataSource.totalCount() - 1) {
                    this.onPhotoChanged(this.currentIndex + 1);
                }
            } else {
                this.onBackPress();
            }
        });
        let param = router.getParams();
        if (param) {
            Log.info(TAG, `photoBrowser start with param`);
            Log.debug(TAG, `param: ${JSON.stringify(param)}`);
            if (param.pageFrom) {
                this.pageFrom = parseInt(param.pageFrom.toString());
            }
            if (this.pageFrom == Constants.ENTRY_FROM.CAMERA) {
                this.isFromCamera = true;
                this.albumInfo = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, "", "", "", "")
                this.browserDataSource.setAlbumId(this.albumInfo.id)
                this.jumpSourceToMain = JumpSourceToMain.CAMERA;
            } else if (this.pageFrom == Constants.ENTRY_FROM.VIEW_DATA) {
                this.isFromViewData = true;
            }

            if (param.albumInfo) {
                this.albumInfo = param.albumInfo as SimpleAlbumDataItem;
                this.deviceName = this.albumInfo.deviceName;
                this.browserDataSource.setAlbumId(this.albumInfo.id)
                this.browserDataSource.setDeviceId(this.albumInfo.deviceId);
            }

            let items: MediaDataItem[];
            if (param.viewData) {
                items = []
                let uriArr: string[] = String(param.viewData).split(',');
                for (let i = 0;i < uriArr.length; i++) {
                    items.push(new InnerMediaDataItem(uriArr[i], i));
                }
            } else {
                items = AppStorage.Get<MediaDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER);
            }

            if (items && !this.isFromCamera) {
                this.browserDataSource.groupDataItem = items;
                this.onPhotoChanged(new Number(param.position).valueOf() || 0);
            } else {
                this.browserDataSource.reloadGroupItemData(false).then((isEmpty: boolean) => {
                    this.onPhotoChanged(0);
                    this.browserDataSource.notifyDataReload();
                })
            }

            this.photoBrowserTransition = (this.isFromCamera || this.isFromViewData)
                ? Constants.PHOTO_TRANSITION_CAMERA : (param.transition ? param.transition.toString() : '');
        } else {
            Log.info(TAG, `photoBrowser start without param`);
            if (this.entryFromHap == Constants.ENTRY_FROM_FORM_ABILITY) {
                this.isFromCard = true;
                this.pageFrom = Constants.ENTRY_FROM.CARD;
                this.albumInfo = new SimpleAlbumDataItem(AppStorage.Get(Constants.FROM_ALBUM_ID), "", "", "", "");
            } else {
                this.pageFrom = Constants.ENTRY_FROM.CAMERA;
                this.albumInfo = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, "", "", "", "");
            }
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
            this.browserDataSource.setAlbumId(this.albumInfo.id);
            this.browserDataSource.reloadGroupItemData(false).then((isEmpty: boolean) => {
                this.isDataChanged = isEmpty;
                this.onPhotoChanged(AppStorage.Get(Constants.FROM_CURRENT_INDEX) || 0);
                this.browserDataSource.notifyDataReload()
            });
            this.isFromCamera = true;
            this.jumpSourceToMain = JumpSourceToMain.CAMERA;

            this.photoBrowserTransition = Constants.PHOTO_TRANSITION_CAMERA;
        }

        mediaObserver.registerObserver(this.dataObserver);
        this.checkedTransition = this.photoBrowserTransition;

        this.onMenuClicked = this.onMenuClicked.bind(this);

        // register event handling
        this.broadCast.on(PhotoConstants.TOGGLE_BAR, () => {
            this.onToggleBars();
        });

        this.broadCast.on(PhotoConstants.HIDE_BARS, () => {
            this.hideBars();
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_START, () => {
            Log.info(TAG, 'pulling down start');
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

        this.broadCast.on(PhotoConstants.RENAME, (result: string[]) => {
            Log.info(TAG, `rename refresh: ${result[0]}, ${result[1]}`);
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                return;
            }
            currentPhoto.title = result[0];
            currentPhoto.displayName = result[1];
            this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_START, (event) => {
            Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
            this.isPullingDown = true;
        })

        this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, () => {
            Log.info(TAG, 'pulling down cancel');
            this.isPullingDown = false;
        })

        this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, (state: boolean) => {
            Log.debug(TAG, 'current photo show state change');
            this.currentShow = state;
        });

        this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
            Log.info(TAG, `set swiper swipe ${value}`);
            this.canSwipe = value;
        });

        finishTrace('PhotoBrowserAboutToAppear');
    }

    private async dataSourceLoadFinish() {
        await this.browserDataSource.reloadGroupItemData(false);
        for(let i = 0;i < this.browserDataSource.groupDataItem.length;i++) {
           await this.browserDataSource.groupDataItem[i].load(false);
        }
        if(AppStorage.Get(Constants.EDIT_REPLACE) == 0) {
            this.isToEdit = false;
        }
        this.onPhotoChanged(this.currentIndex);
		    this.browserDataSource.notifyDataChange(this.currentIndex);
        if (this.isToEdit) {
            this.isToEdit = false;
            this.appBroadcast.emit(BroadcastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
        } else {
            this.appBroadcast.emit(BroadcastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
        }
    }

    onPageShow() {
        startTrace('PhotoBrowserOnPageShow');
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.broadCast.emit(BroadcastConstants.CHANGE_SWIPER_DURATION, [400]);
        let params = router.getParams();
        if (params != null && params.pageType != null && this.backFromCopy) {
            Log.debug(TAG, `MediaOperation back ${JSON.stringify(params)}`)
            let menuContext = new MenuContext();
            let menuOperation: MenuOperation;
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                Log.warn(TAG, 'MediaOperation currentPhoto is undefined');
                return;
            }
            switch (params.pageType) {
                case MediaOperationType.Move:
                    this.onMoveEnd = this.onMoveEnd.bind(this);
                    menuContext.withItems([currentPhoto])
                        .withBroadCast(this.broadCast)
                        .withAlbumInfo(JSON.parse(params.albumInfo ? params.albumInfo.toString() : ''))
                        .withOperationEndCallback(this.onMoveEnd);
                    menuOperation = new MoveMenuOperation(menuContext);
                    break;
                case MediaOperationType.Copy:
                    this.onCopyEnd = this.onCopyEnd.bind(this);
                    menuContext.withItems([currentPhoto])
                        .withBroadCast(this.broadCast)
                        .withAlbumInfo(JSON.parse(params.albumInfo ? params.albumInfo.toString() : ''))
                        .withOperationEndCallback(this.onCopyEnd);
                    menuOperation = new CopyMenuOperation(menuContext);
                    break;
            }
            menuOperation.doAction();
        }
        this.backFromCopy = false;
        finishTrace('PhotoBrowserOnPageShow');
    }

    private downLoad() {
        Log.info(TAG, 'downLoad run');
        let menuContext = new MenuContext();
        let menuOperation: MenuOperation;
        let currentPhoto = this.getCurrentPhoto();
        this.onDownloadEnd = this.onDownloadEnd.bind(this);
        if (currentPhoto == undefined) {
            Log.warn(TAG, 'MediaOperation currentPhoto is undefined');
            return;
        }
        menuContext.withItems([currentPhoto])
            .withBroadCast(this.broadCast)
            .withRemoteDevice(this.albumInfo.deviceId)
            .withOperationEndCallback(this.onDownloadEnd)
        menuOperation = new CopyMenuOperation(menuContext);
        menuOperation.doAction();
    }

    onPageHide() {
        this.showBars();
    }

    onMediaLibDataChange(changeType) {
        Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
        if (!PhotoEditorManager.getInstance().isSaving) {
            this.dataSourceLoadFinish();
        }
    }

    async routerGridPaged() {
        AppStorage.SetOrCreate(Constants.BACK_FROM_FORM_DETAIL, true);
        let displayName = await getAlbumDisplayName(MediaConstants.ALBUM_ID_CAMERA)
        let item: SimpleAlbumDataItem = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, displayName, "", "", "")
        Log.info(TAG, `item.displayName: ${item.displayName} item ${JSON.stringify(item)}`);
        router.replace({
            uri: 'feature/photoGrid/view/PhotoGridPage',
            params: {
                item: JSON.stringify(item)
            }
        });
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            if (!this.isDataChanged || !this.isFromCard == true) {
                PhotoSwiper({
                    dataSource: this.browserDataSource,
                    photoSwiperTransition: this.photoBrowserTransition,
                    swiperController: this.controller,
                    onPhotoChanged: this.onPhotoChanged.bind(this)
                })
            }
            if (!this.isFromViewData) {
                if (this.isShowBar) {
                    PhotoBrowserActionBar({
                        onMenuClicked: this.onMenuClicked,
                    })
                    ToolBar({
                        toolMenuList: $toolMenuList,
                        onMenuClicked: this.onMenuClicked,
                        isFromPhotoBrowser: true
                    })
                }
                CustomDialogView()
            } else {
                Column() {
                    if (this.isShowBar) {
                        PhotoBrowserActionBar({
                            onMenuClicked: (action) => this.onMenuClicked(action)
                        })
                    }
                    Text(`${this.currentIndex + 1}/${this.browserDataSource.totalCount()}`)
                        .height($r('app.float.menu_height'))
                        .fontColor($r('app.color.text_color_secondary'))
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .markAnchor({ x: '0%', y: '0%' })
                        .position({
                            x: '0%',
                            y: screenManager.getStatusBarHeight() + Constants.ActionBarHeight
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