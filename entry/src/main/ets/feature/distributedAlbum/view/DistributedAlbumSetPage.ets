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
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import {
    AlbumGridItemTraditionalStyle
} from '@ohos/distributed/src/main/ets/components/AlbumGridItemTraditionalStyle';
import { Constants } from '../../../common/model/common/Constants';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { CommonObserverCallback } from '@ohos/base/src/main/ets/observer/CommonObserverCallback';
import mediaObserver from '@ohos/base/src/main/ets/observer/MediaObserver';
import { DistributedAlbumBarModel } from '../model/DistributedAlbumBarModel';
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { PeerDataItem } from '@ohos/base/src/main/ets/data/PeerDataItem';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';

const TAG = "DistributedAlbumSetPage"

@Entry
@Component
struct DistributedAlbumSetPage {
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @State isEmpty: boolean = false;
    @State gridColumnsCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isAlbumSetSelectedMode: boolean = false;
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @Provide moreMenuList: Action[] = [];
    title: any;
    isActive: boolean = false; // Whether the page is in the foreground
    scroller: Scroller = new Scroller();
    private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
    private deviceId: string = '';
    private barModel: DistributedAlbumBarModel = new DistributedAlbumBarModel();
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource();
    private isMediaLibDataChanged: boolean = true;
    @State actionBarProp: ActionBarProp = new ActionBarProp();

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(this.title);
    }

    onMenuClicked(action: Action, arg: any[]) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.BACK:
                router.back();
                break;
            default:
                break;
        }
    }

    aboutToAppear(): void {
        let param = router.getParams();
        if (param.item) {
            Log.debug(TAG, `After router.getParams, param is: ${JSON.stringify(param)}`);
            let item = JSON.parse(param.item.toString()) as PeerDataItem;
            this.title = item.deviceName;
            this.deviceId = item.networkId;
            this.albumsDataSource.setDeviceId(item.networkId);
        } else {
            Log.warn(TAG, `param is error`);
        }

        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
        });

        broadcastManager.getBroadcast().on(BroadcastConstants.ON_REMOTE_CHANGED,
        this.onUpdateRemoteDevice.bind(this));

        mediaObserver.registerObserver(this.dataObserver);

        let contentWidth = screenManager.getWinWidth();
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        Log.info(TAG, `the grid count in a line is : ${this.gridColumnsCount}`);

        this.updateActionBar();
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
        broadcastManager.getBroadcast().off(BroadcastConstants.ON_REMOTE_CHANGED, null);
        mediaObserver.unregisterObserver(this.dataObserver);
        this.dataObserver.clearSource();
    }

    onPageShow() {
        broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.onActive();
    }

    onPageHide() {
        this.onInActive();
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            Log.info(TAG, 'onActive');
            this.isActive = true;
        }
        this.loadItem();
    }

    // Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            Log.info(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    private onUpdateRemoteDevice(res, deviceId): void {
        Log.debug(TAG, `onUpdateRemoteDevice`);

        if (!this.isActive) {
            return;
        }

        if (deviceId != this.deviceId) {
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
            })
        } else {
            Log.info(TAG, `ignore typy: ${res}`);
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
            this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
                this.isEmpty = isEmpty;
                this.albumsDataSource.notifyDataReload();
            })
        } else if (this.isActive) {
            this.albumsDataSource.dataRemove();
        }
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoIndexComponent({ index: Constants.DISTRIBUTED_ALBUM_PAGE_INDEX })
                } else {
                    Grid(this.scroller) {
                        LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>) => {
                            if (item && item.get()){
                                if (item && item.index == 0) {
                                    GridItem() {
                                        AlbumGridItemTraditionalStyle({
                                            item: item.get(),
                                            deviceName: this.title,
                                            deviceId: this.deviceId,
                                            isBigCard: true
                                        })
                                    }.columnStart(0).columnEnd(1)
                                } else {
                                    GridItem() {
                                        AlbumGridItemTraditionalStyle({
                                            item: item.get(),
                                            deviceName: this.title,
                                            deviceId: this.deviceId,
                                            isBigCard: false
                                        })
                                    }
                                }
                            }
                        }, (item: LazyItem<AlbumDataItem>) => item && item.get() ? item.getHashCode() : JSON.stringify(item))
                    }
                    .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
                    .padding({
                        left: $r('app.float.max_padding_start'),
                        right: $r('app.float.max_padding_end'),
                        top: $r('app.float.album_set_page_padding_top')
                    })
                    .columnsGap($r('app.float.album_set_grid_column_gap'))
                    .rowsGap($r('app.float.album_set_traditional_style_grid_row_gap'))
                }
            }
            .margin({
                top: px2vp(this.leftBlank[1]),
                bottom: px2vp(this.leftBlank[3])
            })
        }
        .backgroundColor($r('app.color.default_background_color'))
    }
}
