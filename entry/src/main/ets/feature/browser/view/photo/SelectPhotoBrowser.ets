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
import {SelectUtil} from '../../../../common/model/browser/photo/SelectUtil'
import {Action} from '../../../../common/model/browser/operation/Action.ets'
import {MenuOperation} from '../../../../common/model/browser/operation/MenuOperation'
import {Constants} from '../../../../common/model/common/Constants.ets'
import {MediaItem} from '../../../../common/model/browser/photo/MediaItem'
import {PhotoDataSource} from '../../../../common/model/browser/photo/PhotoDataSource'
import {StatusBarColorMode, StatusBarColorController} from '../../../../common/model/common/StatusBarColorController';
import {ThirdSelectPhotoBrowserActionBar} from '../../../../common/view/ThirdSelectPhotoBrowserActionBar.ets'
import {SelectManager} from '../../../../common/model/browser/SelectManager.ets'
import {PhotoBrowserBg} from '../../../../common/view/PhotoBrowserBg'
import {Constants as PhotoConstants} from '../../../../common/model/browser/photo/Constants'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager'
import {PhotoSwiper} from '../../../../common/view/PhotoSwiper.ets'
import mMultimodalInputManager from '../../../../common/model/common/MultimodalInputManager.ets'

// select mode
@Entry
@Component
struct SelectPhotoBrowser {
    @Provide backgroundColor: Resource = $r('app.color.default_background_color');
    @Provide('selectedCount') totalSelectedCount: number = 0
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isSelected: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
    selectManager: SelectManager;
    isMultiPick = true;
    transition: string;
    controller: SwiperController = new SwiperController();

    // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
    @Provide(transitionIndex) currentIndex: number = 0;

    // position
    position: number;
    timelineIndex: number = -1;

    // logger
    private logger: Logger = new Logger('PhotoBrowser');

    // dataSource
    private dataSource: PhotoDataSource = new PhotoDataSource();

    // The global BroadCast of the application process. Event registration and destruction should be paired
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

    private releasePixMap(key: string) {
        this.dataSource.releaseCache(key);
    }

    private aboutToAppear(): void {
        this.logger.info('photoBrowser aboutToAppear');
        mMultimodalInputManager.registerListener((control: number) => {
            this.logger.info(`key control : ${control} index ${this.currentIndex}`);
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
        this.selectManager = AppStorage.Get(Constants.THIRD_SELECT_MANAGER);
        let param = router.getParams();
        if (param.pageFrom) {
            this.pageFrom = param.pageFrom;
        }
        if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
            this.dataSource = new PhotoDataSource('Recycle');
        } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
            this.dataSource.setDeviceId(param.deviceId);
        }

        this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
        if (this.isMultiPick == true) {
            this.totalSelectedCount = this.selectManager.getSelectedCount();
        }

        this.onPhotoChanged(param.position);
        this.transition = param.transition;
        this.onMenuClicked = this.onMenuClicked.bind(this);

        this.dataSource.setBroadCast(this.broadCast);
        // register event handling
        this.broadCast.on(PhotoConstants.TOGGLE_BAR, (event) => {
            this.logger.info(`TOGGLE_BAR : ${JSON.stringify(event)}`);
            this.onToggleBars();
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_END, (event) => {
            this.logger.info(`PULL_DOWN_END : ${JSON.stringify(event)}`);
            this.onBackPress();
        });

        this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
            this.onDataSizeChanged(size);
        });

        this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, (size: number) => {
            // onContentChanged only the current item is updated
            this.logger.info(`DATA_CONTENT_CHANGED : ${size}`);
            this.onPhotoChanged(this.currentIndex);
        });
    }

    private aboutToDisappear(): void {
        StatusBarColorController.getInstance().setMode(StatusBarColorMode.NORMAL);
    }

    onToggleBars() {
    }

    onDataSizeChanged(size: number): void {
        this.logger.info(`onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            this.onBackPress();
        }
    }

    onPhotoChanged(index: number): void{
        this.currentIndex = index;
        this.timelineIndex = this.dataSource.getPositionByIndex(index);
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            this.logger.error('onPhotoChanged, item is undefined');
        } else {
            this.isSelected = this.selectManager.isItemSelected(currentPhoto.uri, this.timelineIndex);
            this.logger.info(`onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri},\
                isSelected: ${this.isSelected}`);
        }
    }

    selectStateChange() {
        this.logger.info('change selected');
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        this.isSelected = !this.isSelected;
        if (this.selectManager.toggle(currentPhoto.uri, this.isSelected, this.timelineIndex)) {
            this.totalSelectedCount = this.selectManager.getSelectedCount();
        }
        this.logger.info(`totalSelectedCount: ${this.totalSelectedCount} after state change`)
    }

    private onPageShow() {
        this.logger.info('onPageShow');
        this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.transition]);
    }

    private onPageHide() {
        this.logger.info('onPageHide');
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.transition]);
    }

    onMenuClicked(action: Action) {
        this.logger.debug(`onMenuClicked, action: ${action.actionID}`);
        let menuOperation: MenuOperation
        switch (action) {
            case Action.BACK:
                this.onBackPress();
                return;
            case Action.MATERIAL_SELECT:
                this.logger.info('click UN_SELECTED');
                this.selectStateChange();
                return;
            case Action.SELECTED:
                this.logger.info('click SELECTED');
                this.selectStateChange();
                return;
            case Action.OK:
                this.logger.info('click OK');
                this.setPickResult();
                break;
            default:
                break;
        }
        menuOperation.doAction();
    }

    getCurrentPhoto(): MediaItem {
        return this.dataSource.getData(this.currentIndex).data;
    }

    onBackPress() {
        router.back({ params: { index: this.currentIndex } });
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.dataSource,
                transition: this.transition,
                onPhotoChanged: this.onPhotoChanged.bind(this),
                swiperController: this.controller,
                onReleasePixmap: this.releasePixMap.bind(this)
            })
            ThirdSelectPhotoBrowserActionBar({
                isMultiPick: this.isMultiPick,
                onMenuClicked: this.onMenuClicked
            })
        }
    }

    private setPickResult(): void {
        let uriArray;
        if (this.isMultiPick) {
            uriArray = SelectUtil.getUriArray(this.selectManager.clickedSet);
            this.logger.debug(`uri size: ${uriArray}`);
        } else {
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                return;
            }
            uriArray = currentPhoto.uri;
        }
        let abilityResult = {
            'resultCode': 0,
            'want': {
                'parameters': {
                    'select-item-list': uriArray
                }
            }
        };
        globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
            this.logger.info(`terminateSelfWithResult result: ${result}`);
        });
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.Push, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
