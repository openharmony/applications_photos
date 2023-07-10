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
import { ThirdSelectPhotoBrowserActionBar } from '../../../common/view/ThirdSelectPhotoBrowserActionBar';
import { PhotoBrowserBg } from '@ohos/browser/src/main/ets/components/PhotoBrowserBg';
import { Constants as PhotoConstants } from '@ohos/browser/src/main/ets/constants/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { PhotoSwiper } from '@ohos/browser/src/main/ets/components/PhotoSwiper';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import mMultimodalInputManager from '@ohos/base/src/main/ets/manager/MultimodalInputManager';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { terminateSelfWithResult } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import { SelectUtil } from '@ohos/base/src/main/ets/utils/SelectUtil';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
// third selection photoBrowser

const TAG = "ThirdSelectPhotoBrowser"

@Entry
@Component
struct ThirdSelectPhotoBrowser {
    @Provide browserBackgroundColor: Resource = $r('app.color.default_background_color');
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isSelected: boolean = false;
    @Provide isShowBar: boolean = true;
    @Provide isPullingDown: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
    @Provide canSwipe: boolean = true;
    isMultiPick = true;
    thirdSelectTransition: string;
    controller: SwiperController = new SwiperController();
    @Provide('transitionIndex') currentIndex: number = 0;
    isFromFa: boolean = false;
    bundleName: string = "";
    isSelectUpperLimited: boolean = false;

    // position
    thirdSelectPosition: number;
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
        let params = router.getParams();
        if (params) {
            this.onPhotoChanged(parseInt(params.position.toString()));
            this.thirdSelectTransition = params.transition.toString();
            this.isFromFa = params.isFromFa && true;
            this.browserDataSource.setSelectType(params.isFromFa ? MediaConstants.SELECT_TYPE_IMAGE : MediaConstants.SELECT_TYPE_ALL);
            this.browserDataSource.setAlbumId(params.albumId ? params.albumId.toString() : "");
            this.isMultiPick = params.isMultiPick as boolean;
            this.bundleName = params.bundleName.toString();
            this.isSelectUpperLimited = params.isSelectUpperLimited  as boolean;
        }
        this.browserDataSource.groupDataItem = AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER);
        if (this.isMultiPick == true) {
            this.totalSelectedCount = this.browserDataSource.getSelectedCount();
        }

        this.onMenuClicked = this.onMenuClicked.bind(this);

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
            Log.info(TAG, `set swiper swipe ${value}`);
            this.canSwipe = value;
        });
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
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

    onPhotoChanged(index: number): void {
        this.currentIndex = index;
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            Log.warn(TAG, 'onPhotoChanged, item is undefined');
        } else {
            this.isSelected = currentPhoto.isSelect;
            Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}`);
        }
    }

    async selectStateChange() {
        Log.info(TAG, 'change selected.');
        let currentPhoto = this.getCurrentPhoto();
        if (currentPhoto == undefined) {
            return;
        }
        if (!this.isSelectUpperLimited || currentPhoto.isSelect) {
            currentPhoto.setSelect(!currentPhoto.isSelect);
            this.isSelected = currentPhoto.isSelect;
            this.totalSelectedCount = this.browserDataSource.getSelectedCount();
        } else {
            let toastMsg = await getResourceString($r('app.string.up_to_limit_tips'));
            showToast(toastMsg);
        }
        this.broadCast.emit(BroadcastConstants.SELECT, [this.currentIndex]);
        Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change`);
    }

    onPageShow() {
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    }

    onPageHide() {
    }

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.BACK:
                this.onBackPress();
                return;
            case Action.MATERIAL_SELECT:
                Log.info(TAG, 'click UN_SELECTED');
                this.selectStateChange();
                return;
            case Action.SELECTED:
                Log.info(TAG, 'click SELECTED');
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
        return this.browserDataSource.getDataByIndex(this.currentIndex);
    }

    onBackPress() {
        router.back({ params: { index: this.currentIndex } });
        return true;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            PhotoBrowserBg()
            PhotoSwiper({
                dataSource: this.browserDataSource,
                photoSwiperTransition: this.thirdSelectTransition,
                onPhotoChanged: this.onPhotoChanged.bind(this),
                swiperController: this.controller
            })
            ThirdSelectPhotoBrowserActionBar({
                isMultiPick: this.isMultiPick,
                onMenuClicked: this.onMenuClicked
            }).sharedTransition("thirdSelectPhotoBrowserActionBar", {
                type: SharedTransitionEffectType.Static,
                duration: Constants.SHARE_TRANSITION_DURATION,
                zIndex: 2,
            })
        }
    }

    private setPickResult() {
        Log.debug(TAG, `setPickResult ${this.isFromFa}`);
        if (this.isFromFa) {
            this.appBroadcast.emit(BroadcastConstants.SAVE_FORM_EDITOR_DATA,
                [AppStorage.Get(Constants.FORM_ITEM_NAME), AppStorage.Get(Constants.FORM_ITEM_ALBUM_ID),
                AppStorage.Get(Constants.FORM_ITEM_DISPLAY_NAME), this.currentIndex, false]);
            return;
        }
        let uriArray = new Array<string>();
        if (this.isMultiPick) {
            uriArray = this.browserDataSource.getSelectedUris();
            Log.info(TAG, `uri size: ${uriArray}`);
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
                    'select-item-list': uriArray,
                }
            }
        };
        Log.info(TAG, `terminateSelfWithResult result: ${JSON.stringify(abilityResult)}`);
        SelectUtil.grantPermissionForUris(uriArray, this.bundleName);
        try {
            Log.info(TAG, `grant permission success.`);
            globalThis.appContext.terminateSelfWithResult(abilityResult).then((result) => {
                Log.info(TAG, `terminateSelf result: ${result}`);
            });
        } catch (err) {
            Log.error(TAG, `grant permission error: ${JSON.stringify(err)}`);
        };
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
        PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
            .opacity(0)
    }
}
