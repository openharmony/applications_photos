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
import { MediaOperationType } from '@ohos/base/src/main/ets/data/MediaOperationType';
import { MediaOperationActionBar } from './MediaOperationActionBar';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { AlbumSetNewMenuOperation } from '@ohos/base/src/main/ets/operation/AlbumSetNewMenuOperation';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { AlbumListCard } from '@ohos/mediaOperation/src/main/ets/components/AlbumListCard';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { Action } from './Action';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import { CustomDialogView } from '../dialog/CustomDialogView';
import screenManager, { ColumnSize } from '@ohos/base/src/main/ets/manager/ScreenManager';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource'
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';

const TAG = "MediaOperationPage"

@Entry
@Component
struct MediaOperationPage {
    @StorageLink('screenColumns') screenColumns: number = screenManager.getScreenColumns();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @Provide pageType: string = MediaOperationType.Move;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide moreMenuList: Action[] = new Array<Action>();
    @Provide loadingFinish: boolean = false;
    @State listCardWidth: number = 0;
    isActive: boolean = false; // Whether the page is in the foreground
    sourceAlbumId: string;
    private albumInfo: SimpleAlbumDataItem;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource()
    private scroller: Scroller = new Scroller();

    aboutToAppear(): void {
        let blackList = Array.from(MediaConstants.ALBUM_DISABLE_COPY_LIST)
        let param = router.getParams();
        if (param) {
            this.pageType = param.pageType.toString();
            if (param.albumInfo) {
                this.albumInfo = JSON.parse(param.albumInfo.toString()) as SimpleAlbumDataItem;
                this.sourceAlbumId = this.albumInfo.id;
                blackList.push(this.sourceAlbumId)
                Log.info(TAG, `router getParams pageType:${this.pageType},Album:${this.sourceAlbumId}`);
            }
        }
        this.albumsDataSource.setBlackList(blackList)
        this.onActive();
        this.loadAlbums()
        this.onMenuClicked = this.onMenuClicked.bind(this);

        this.broadCast.on(BroadcastConstants.MEDIA_OPERATION, (albumInfo: SimpleAlbumDataItem, completedFunc?: Function) => {
            router.back({
                uri: '',
                params: {
                    pageType: this.pageType,
                    albumInfo: JSON.stringify(albumInfo)
                }
            });
            completedFunc && completedFunc();
        });
        this.updateListCardWidth();
    }

    private loadAlbums() {
        this.albumsDataSource.reloadAlbumListItemData().then((isEmpty: boolean) => {
            this.loadingFinish = true
            this.albumsDataSource.notifyDataReload()
        })
    }

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, actionID: ${action.actionID}`);

        switch (action) {
            case Action.CANCEL:
                router.back({
                    uri: '',
                    params: {}
                });
                break;
            case Action.NEW:
                this.createNewAlbum();
                break;
            default:
                break;
        }
    }

    createNewAlbum() {
        Log.info(TAG, 'createNewAlbum');
        let menuContext = new MenuContext();
        this.onOperationStart = this.onOperationStart.bind(this);
        this.onOperationEnd = this.onOperationEnd.bind(this);
        menuContext
            .withOperationStartCallback(this.onOperationStart)
            .withOperationEndCallback(this.onOperationEnd)
            .withDataSource(this.albumsDataSource)
            .withAlbumInfo(this.albumInfo)
            .withBroadCast(this.broadCast)
            .withJumpSourceToMain(JumpSourceToMain.ALBUM);
        let menuOperation = new AlbumSetNewMenuOperation(menuContext);
        menuOperation.doAction();
    }

    onOperationStart() {
    }

    onOperationEnd() {
    }

    updateListCardWidth(): void {
        Log.info(TAG, `updateListCardWidth start ${this.screenColumns}`);
        if (this.screenColumns == ColumnSize.COLUMN_FOUR) {
            this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_FOUR);
        } else if (this.screenColumns == ColumnSize.COLUMN_EIGHT) {
            this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_SIX);
        } else if (this.screenColumns == ColumnSize.COLUMN_TWELVE) {
            this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_EIGHT);
        } else {
            Log.warn(TAG, 'screenColumns is not init');
        }
        Log.info(TAG, `updateListCardWidth ${this.listCardWidth}`);
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            Log.info(TAG, 'onActive');
            this.isActive = true;
        }
    }

    onBackPress() {
        Log.info(TAG, 'onBackPress');
        router.back({
            uri: '',
            params: {}
        });
        return true;
    }

    aboutToDisappear(): void {
        Log.info(TAG, `aboutToDisappear`);
        this.broadCast.off(null, null);
    }

    onPageShow() {
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    }

    build() {
        Column() {
            MediaOperationActionBar({ onMenuClicked: this.onMenuClicked })
            List({ scroller: this.scroller }) {
                ListItem() {
                    Flex({
                        direction: FlexDirection.Column,
                        justifyContent: FlexAlign.Center,
                        alignItems: ItemAlign.Center
                    }) {
                        List() {
                            LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>) => {
                                ListItem() {
                                    AlbumListCard({ item: item.get() })
                                }
                            }, (item: LazyItem<AlbumDataItem>) => item == null && item.get() ? JSON.stringify(item) : item.getHashCode())
                        }
                        .divider({
                            strokeWidth: 1,
                            startMargin: $r('app.float.album_list_card_divider_margin_left')
                        })
                        .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
                        .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
                        .padding({
                            left: $r('app.float.list_card_margin'),
                            right: $r('app.float.list_card_margin')
                        })
                        .width(this.listCardWidth)
                    }.width('100%')
                }.width('100%')
            }
            .scrollBar(BarState.Auto)
            .width('100%')
            .margin({
                top: $r('app.float.album_let_page_padding_top'),
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                bottom: px2vp(this.leftBlank[3])
            })
            CustomDialogView()
        }
        .backgroundColor($r('app.color.default_background_color')) // ux: colorSubBackground
        .height('100%')
        .padding({
            top: px2vp(this.leftBlank[1]),
            bottom: px2vp(this.leftBlank[3])
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 1 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 1 })
            .opacity(0)
    }
}