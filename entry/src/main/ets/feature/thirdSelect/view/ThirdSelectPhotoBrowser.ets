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
import { Logger } from '../utils/Logger'
import { SelectUtil } from '../../../common/model/browser/photo/SelectUtil'
import { Action } from '../../../common/view/browserOperation/Action'
import { Constants } from '../../../common/model/common/Constants'
import { MediaItem } from '../../../common/model/browser/photo/MediaItem'
import { PhotoDataSource } from '../../../common/model/browser/photo/PhotoDataSource'
import { ThirdSelectManager } from '../../../common/model/browser/SelectManager'
import { ThirdSelectPhotoBrowserActionBar } from '../../../common/view/ThirdSelectPhotoBrowserActionBar'
import { PhotoBrowserBg } from '../../../common/view/PhotoBrowserBg'
import { Constants as PhotoConstants } from '../../../common/model/browser/photo/Constants'
import { BroadCast } from '../../../common/utils/BroadCast'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { PhotoSwiper } from '../../../common/view/PhotoSwiper'
import { ScreenManager } from '../../../common/model/common/ScreenManager';
import mMultimodalInputManager from '../../../common/model/common/MultimodalInputManager'

// third selection photoBrowser
@Entry
@Component
struct ThirdSelectPhotoBrowser {
    @Provide thirdSelectBackgroundColor: Resource = $r('app.color.default_background_color');
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isSelected: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
    @Provide canSwipe: boolean = true;
    selectManager: ThirdSelectManager;
    isMultiPick = true;
    thirdSelectTransition: string;
    controller: SwiperController = new SwiperController();
    @Provide('transitionIndex') currentIndex: number = 0;
    isFromFa: boolean = false;

    // position
    thirdSelectPosition: number;

    // logger
    private logger: Logger = new Logger('PhotoBrowser');

    // DataSource
    private dataSource: PhotoDataSource = new PhotoDataSource();
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

    aboutToAppear(): void {
        this.logger.info('photoBrowser aboutToAppear');
        this.thirdSelectBackgroundColor = $r('app.color.black');
        ScreenManager.getInstance().setNavigationBarColor('#FFFFFFFF')
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
        this.isFromFa = AppStorage.Get(Constants.FROM_FORM_PHOTO_EDITOR);
        this.selectManager = AppStorage.Get(Constants.THIRD_SELECT_MANAGER);
        this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
        this.isMultiPick = this.selectManager.getIsMultiPick();
        if (this.isMultiPick == true) {
            this.totalSelectedCount = this.selectManager.getSelectedCount();
        }

        let param = router.getParams();
        this.onPhotoChanged(parseInt(param.position.toString()));
        this.thirdSelectTransition = param.transition.toString();
        this.onMenuClicked = this.onMenuClicked.bind(this);

        this.dataSource.setBroadCast(this.broadCast);

        this.broadCast.on(PhotoConstants.TOGGLE_BAR, () => {
            this.onToggleBars();
        });
        this.broadCast.on(PhotoConstants.PULL_DOWN_END, () => {
            this.onBackPress();
        });

        this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
            this.onDataSizeChanged(size);
        });
        this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, () => {
            this.onPhotoChanged(this.currentIndex);
        });
        this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
            this.logger.info(`set swiper swipe ${value}`);
            this.canSwipe = value;
        });
    }

    aboutToDisappear(): void {
        ScreenManager.getInstance().setNavigationBarColor('#FF000000')
        this.broadCast.release();
        this.dataSource.release();
        mMultimodalInputManager.unregisterListener();
    }

    onToggleBars() {
    }

    onDataSizeChanged(size: number): void {
        this.logger.info(`onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            this.onBackPress();
        }
    }

    onPhotoChanged(index: number): void {
        this.currentIndex = index;
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            this.logger.error('onPhotoChanged, item is undefined');
        } else {
            this.isSelected = this.selectManager.isItemSelected(currentPhoto.uri);
            this.logger.info(`onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}`);
        }
    }

    selectStateChange() {
        this.logger.info('change selected.');
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        this.isSelected = !this.isSelected;
        if (this.isSelected) {
            this.selectManager.toggle(currentPhoto.uri, true);
        } else {
            this.selectManager.toggle(currentPhoto.uri, false);
        }
        this.totalSelectedCount = this.selectManager.getSelectedCount();
        this.logger.info(`totalSelectedCount: ${this.totalSelectedCount} after state change`);
    }

    onPageShow() {
        this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.thirdSelectTransition]);
    }

    onPageHide() {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.thirdSelectTransition]);
    }

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
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
    }

    getCurrentPhoto(): MediaItem {
        return this.dataSource.getData(this.currentIndex).data;
    }

    onBackPress() {
        router.back({ params: { index: this.currentIndex } });
        return true;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.dataSource,
                photoSwiperTransition: this.thirdSelectTransition,
                onPhotoChanged: this.onPhotoChanged.bind(this),
                swiperController: this.controller
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
            this.logger.info(`uri size: ${uriArray}`);
        } else {
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                return;
            }
            uriArray = currentPhoto.uri;
        }
        if (this.isFromFa) {
            this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
                [AppStorage.Get(Constants.FORM_ITEM_NAME), AppStorage.Get(Constants.FORM_ITEM_ALBUM_ID),
                AppStorage.Get(Constants.FORM_ITEM_DISPLAY_NAME), uriArray, false]);
            return;
        }
        let abilityResult = {
            'resultCode': 0,
            'want': {
                'parameters': {
                    'select-item-list': uriArray,
                }
            }
        };
        globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
            this.logger.info(`terminateSelfWithResult result: ${result}`);
        });
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
