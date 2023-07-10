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
import { Action } from '../../../common/view/browserOperation/Action';
import { Constants } from '../../../common/model/common/Constants';
import { RouterConstants } from '@ohos/base/src/main/ets/constants/RouterConstants';
import { ThirdSelectPhotoBrowserActionBar } from '../../../common/view/ThirdSelectPhotoBrowserActionBar';
import { PhotoBrowserBg } from '@ohos/browser/src/main/ets/components/PhotoBrowserBg';
import { Constants as PhotoConstants } from '@ohos/browser/src/main/ets/constants/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { PhotoSwiper } from '@ohos/browser/src/main/ets/components/PhotoSwiper';
import mMultimodalInputManager from '@ohos/base/src/main/ets/manager/MultimodalInputManager';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { terminateSelfWithResult } from '@ohos/base/src/main/ets/utils/AbilityUtils';

const TAG = "SelectPhotoBrowser"
// select mode
@Entry
@Component
struct SelectPhotoBrowser {
    @Provide browserBackgroundColor: Resource = $r('app.color.default_background_color');
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isSelected: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide pageFrom: number = RouterConstants.ENTRY_FROM.NORMAL;
    @Provide canSwipe: boolean = true;
    isMultiPick = true;
    selectPhotoTransition: string;
    controller: SwiperController = new SwiperController();

    // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
    @Provide('transitionIndex') currentIndex: number = 0;

    // The global Broadcast of the application process. Event registration and destruction should be paired
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private browserDataSource: GroupItemDataSource = new GroupItemDataSource();

    aboutToAppear(): void {
        Log.info(TAG, 'photoBrowser aboutToAppear');
        screenManager.setNavigationBarColor('#FFF1F3F5', '#FF000000');
        this.browserBackgroundColor = $r('app.color.black');
        mMultimodalInputManager.registerListener((control: number) => {
            Log.info(TAG, `key control : ${control} index ${this.currentIndex}`);
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
        if (param.pageFrom) {
            this.pageFrom = new Number(param.pageFrom).valueOf() || 0;
        }
        if (this.pageFrom == RouterConstants.ENTRY_FROM.DISTRIBUTED) {
            this.browserDataSource.setDeviceId(param.deviceId ? param.deviceId.toString() : '');
        }

        if (this.isMultiPick == true) {
            this.totalSelectedCount = this.browserDataSource.getSelectedCount();
        }
        if (param.albumInfo) {
            this.browserDataSource.setAlbumId((param.albumInfo as SimpleAlbumDataItem).id);
        }

        this.browserDataSource.groupDataItem = AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER);
        this.onPhotoChanged(new Number(param.position).valueOf() || 0);
        this.isSelected = this.getCurrentPhoto().isSelect;
        this.totalSelectedCount = this.browserDataSource.getSelectedCount();
        this.selectPhotoTransition = param.transition ? param.transition.toString() : '';
        this.onMenuClicked = this.onMenuClicked.bind(this);

        // register event handling
        this.broadCast.on(PhotoConstants.TOGGLE_BAR, (event) => {
            Log.info(TAG, `TOGGLE_BAR : ${JSON.stringify(event)}`);
        });

        this.broadCast.on(PhotoConstants.PULL_DOWN_END, (event) => {
            Log.info(TAG, `PULL_DOWN_END : ${JSON.stringify(event)}`);
            this.onBackPress();
        });

        this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
            this.onDataSizeChanged(size);
        });

        this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, (size: number) => {
            // onContentChanged only the current item is updated
            Log.info(TAG, `DATA_CONTENT_CHANGED : ${size}`);
            this.onPhotoChanged(this.currentIndex);
        });

        this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
            Log.info(TAG, `set swiper swipe ${value}`);
            this.canSwipe = value;
        });
    }

    aboutToDisappear(): void {
        screenManager.setNavigationBarColor('#00FFFFFF', '#FF000000');
        this.broadCast.release();
        mMultimodalInputManager.unregisterListener();
        this.controller = undefined;
    }

    onToggleBars() {
    }

    onDataSizeChanged(size: number): void {
        Log.info(TAG, `onDataSizeChanged, size is ${size}`);
        if (size == 0) {
            this.onBackPress();
        }
    }

    onPhotoChanged(index: number): void{
        this.currentIndex = index;
        this.isSelected = this.getCurrentPhoto().isSelect;
        this.browserDataSource.notifyDataChange(index);
    }

    private selectStateChange() {
        Log.info(TAG, 'change selected');
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        currentPhoto.setSelect(!currentPhoto.isSelect);
        this.isSelected = currentPhoto.isSelect;
        this.totalSelectedCount = this.browserDataSource.getSelectedCount();
        this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
        Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change`);
    }

    onPageShow() {
        Log.info(TAG, 'onPageShow');
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    }

    onPageHide() {
        Log.info(TAG, 'onPageHide');
    }

    onMenuClicked(action: Action) {
        Log.debug(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.BACK:
                this.onBackPress();
                return;
            case Action.MATERIAL_SELECT:
            case Action.SELECTED:
                this.selectStateChange();
                return;
            case Action.OK:
                Log.info(TAG, 'click OK');
                this.setPickResult();
                break;
            default:
                break;
        }
    }

    getCurrentPhoto(): MediaDataItem {
        return this.browserDataSource.groupDataItem[this.currentIndex];
    }

    onBackPress() {
        Log.info(TAG, 'onBackPress');
        router.back({ params: { index: this.currentIndex } });
        return true;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.browserDataSource,
                photoSwiperTransition: this.selectPhotoTransition,
                onPhotoChanged: this.onPhotoChanged.bind(this),
                swiperController: this.controller
            })
            ThirdSelectPhotoBrowserActionBar({
                isMultiPick: this.isMultiPick,
                onMenuClicked: this.onMenuClicked
            }).sharedTransition("selectPhotoBrowserActionBar", {
                type: SharedTransitionEffectType.Static,
                duration: Constants.SHARE_TRANSITION_DURATION,
                zIndex: 2,
            })
        }
    }

    private setPickResult(): void {
        let uriArray: string[];
        if (this.isMultiPick) {
            uriArray = this.browserDataSource.getSelectedUris();
            Log.debug(TAG, `uri size: ${uriArray}`);
        } else {
            let currentPhoto = this.getCurrentPhoto();
            if (currentPhoto == undefined) {
                return;
            }
            uriArray = [currentPhoto.uri];
        }
        let abilityResult = {
            'resultCode': 0,
            'want': {
                'parameters': {
                    'select-item-list': uriArray
                }
            }
        };
        terminateSelfWithResult(abilityResult);
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
