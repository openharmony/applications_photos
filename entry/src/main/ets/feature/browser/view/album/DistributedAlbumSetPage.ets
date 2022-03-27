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
import {Action} from '../../../../common/model/browser/operation/Action'
import {AlbumGridItemTraditionalStyle} from './AlbumGridItemTraditionalStyle.ets'
import {AlbumSetDataSource} from '../../../../common/model/browser/album/AlbumSetDataSource.ets'
import {Constants} from '../../../../common/model/common/Constants.ets'
import {DistributedAlbumSetPageActionBar} from './DistributedAlbumSetPageActionBar.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {NoPhotoIndexComponent} from '../../../../common/view/NoPhotoIndexComponent'
import {Logger} from '../../utils/Logger.ets'
import {JumpSourceToMain} from '../../../../common/model/browser/photo/JumpSourceToMain'
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import { CommonObserverCallback } from '../../../../common/model/browser/CommonObserverCallback.ets'
import { MediaObserver } from '../../../../common/model/browser/dataObserver/MediaObserver.ets'

@Entry
@Component
export struct DistributedAlbumSetPage {
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @State isEmpty: boolean = false;
    @State gridColumnsCount: number = 0;
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isAlbumSetSelectedMode: boolean = false;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();

    private dataObserver: CommonObserverCallback  = new CommonObserverCallback(this);

    title: any;
    albums : AlbumSetDataSource
    isActive: boolean = false; // Whether the page is in the foreground
    logger: Logger = new Logger('DistributedAlbumSetPage')
    scroller: Scroller = new Scroller();

    private deviceId : string = ''

    onMenuClicked(action: Action, arg: any[]) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
        switch(action) {
            case  Action.BACK:
                router.back();
                break;
            default:
                break;
        }
    }

    private aboutToAppear(): void {
        let param = router.getParams();
        if (param != null) {
            this.logger.debug(`After router.getParams, param is: ${JSON.stringify(param)}`);
            let item = JSON.parse(param.item);
            this.title = item.deviceName;
            this.albums
                = new AlbumSetDataSource(this.broadCast, {deviceId: item.networkId, deviceName: item.deviceName});

            this.deviceId = item.networkId;
        }

        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
        });

        BroadCastManager.getInstance().getBroadCast().on(BroadCastConstants.ON_REMOTE_CHANGED,
            this.onUpdateRemoteDevice.bind(this));

        MediaObserver.getInstance().registerObserver(this.dataObserver);

        this.onActive();

        let contentWidth = ScreenManager.getInstance().getWinWidth();
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        this.logger.info(`the grid count in a line is : ${this.gridColumnsCount}`);
    }

    private aboutToDisappear(): void {
        BroadCastManager.getInstance().getBroadCast().off(BroadCastConstants.ON_REMOTE_CHANGED,
            this.onUpdateRemoteDevice.bind(this));
        MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    }

    private onPageShow() {
        this.onActive();
    }

    private onPageHide() {
        this.onInActive();
    }

// Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            this.albums && this.albums.onActive();
        }
    }

// Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.albums && this.albums.onInActive();
        }
    }

    private onUpdateRemoteDevice(res, deviceId): void {
        this.logger.debug(`onUpdateRemoteDevice`);

        if (!this.isActive) {
            return;
        }

        if (deviceId != this.deviceId) {
            this.logger.debug(`other device`);
            return;
        }

        if(res == 'offline') {
            this.logger.debug(`device offline route to album main`);
            router.back({
                uri: this.isHorizontal === true ? 'product/pad/view/index' : 'product/phone/view/index',
                params:{
                    jumpSource: JumpSourceToMain.ALBUM,
                }
            })
        } else {
            this.logger.info(`ignore typy: ${res}`);
            return;
        }
    }

    onMediaLibDataChange(changeType){
        this.logger.info(`onMediaLibDataChange type: ${changeType}`);
        this.albums.onChange(changeType);
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            DistributedAlbumSetPageActionBar({
                name: this.title,
                onMenuClicked: this.onMenuClicked,
            })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoIndexComponent({index: Constants.DISTRIBUTED_ALBUM_PAGE_INDEX})
                } else {
                    Grid(this.scroller) {
                        LazyForEach(this.albums, (item) => {
                            if (this.albums.mediaSetList.indexOf(item) == 0) {
                                GridItem() {
                                    AlbumGridItemTraditionalStyle({
                                        item: item,
                                        isBigCard: true
                                    })
                                }.columnStart(0).columnEnd(1)
                            } else {
                                GridItem() {
                                    AlbumGridItemTraditionalStyle({
                                        item: item,
                                        isBigCard: false
                                    })
                                }
                            }
                        }, item => 'uri:' + item.name)
                    }
                    .backgroundColor($r('app.color.default_background_color'))
                    .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
                    .padding({
                        left: $r('app.float.max_padding_start'),
                        right: $r('app.float.max_padding_end'),
                        top: $r('app.float.album_set_page_padding_top'),
                        bottom: $r('app.float.album_set_page_padding_end')
                    })
                    .columnsGap($r('app.float.album_set_grid_column_gap'))
                    .rowsGap($r('app.float.album_set_traditional_style_grid_row_gap'))
                }
            }
        }.margin({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }
}
