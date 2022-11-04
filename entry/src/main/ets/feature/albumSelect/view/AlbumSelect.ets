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
import { Log } from '../../../../../../../common/base/src/main/ets/utils/Log';
import { MediaConstants } from '../../../../../../../common/base/src/main/ets/constants/MediaConstants';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import router from '@system.router';
import {
    AlbumSelectGridItemNewStyle
} from '../../../../../../../features/selectalbum/src/main/ets/components/AlbumSelectGridItemNewStyle';
import { Constants } from '../../../common/model/common/Constants';
import { Broadcast } from '../../../../../../../common/base/src/main/ets/utils/Broadcast';
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { UiUtil } from '../utils/UiUtil';
import broadcastManager from '../../../../../../../common/base/src/main/ets/manager/BroadcastManager';
import { BroadcastConstants } from '../../../../../../../common/base/src/main/ets/constants/BroadcastConstants';
import { AlbumSelectBarModel } from '../model/AlbumSelectBarModel';
import { AlbumScrollBar } from '../../../../../../../common/base/src/main/ets/components/scrollBar/AlbumScrollBar';
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';

const TAG = "AlbumSelect"

@Entry
@Component
export struct AlbumSelect {
    @State isEmpty: boolean = false;
    @State gridColumnsCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @Provide moreMenuList: Action[] = new Array<Action>();
    @Provide isHideScrollBar: boolean = true;
    @Provide('tabBarShow') isTabBarShow: boolean = false;
    private isActive = false;
    private scroller: Scroller = new Scroller();
    private barModel: AlbumSelectBarModel = new AlbumSelectBarModel()
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource()

    aboutToAppear(): void {
        startTrace('AlbumSetPageAboutToAppear');
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
            this.isHideScrollBar = (size <= (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
        });
        this.onActive();

        this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
        Log.info(TAG, `the grid count in a line is: ${this.gridColumnsCount}`);

        let param = router.getParams();
        if (param) {
            if (param.isNewAlbum) {
                AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM, true);
            } else {
                AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM, false);
            }
            let albumInfo: SimpleAlbumDataItem = param.albumInfo ? JSON.parse(param.albumInfo.toString()) : undefined
            if (albumInfo) {
                this.albumsDataSource.setBlackList([albumInfo.id, MediaConstants.ALBUM_ID_RECYCLE])
                Log.debug(TAG, `the album Id is: ${albumInfo.id}`);
            } else {
                this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_RECYCLE])
            }

            AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET, albumInfo);
        }

        this.loadAlbums()
        this.onMenuClicked = this.onMenuClicked.bind(this);
        finishTrace('AlbumSetPageAboutToAppear');
    }

    private loadAlbums() {
        this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
            this.isEmpty = isEmpty
            this.albumsDataSource.notifyDataReload()
        })
    }

    aboutToDisappear(): void {
    }

    onPageShow() {
        broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.onActive();
        this.isHideScrollBar = (this.albumsDataSource.totalCount() < (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
    }

    onPageHide() {
        this.onInActive();
    }

    onBackPress() {
        AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
        AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
        return false;
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            Log.info(TAG, 'onActive');
            this.isActive = true;
        }
    }

    // Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            Log.info(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    private onMenuClicked(action: Action): void {
        Log.debug(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                Log.info(TAG, 'clear SelectManager data');
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
                router.back();
                break;
            default:
                break;
        }
        return;
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            ActionBar({
                actionBarProp: this.barModel.createActionBar(),
                onMenuClicked: this.onMenuClicked
            })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoComponent({ title: $r('app.string.title_no_albums') })
                }
                Grid(this.scroller) {
                    LazyForEach(this.albumsDataSource, (item: AlbumDataItem) => {
                        if (item && item.index == 0) {
                            GridItem() {
                                AlbumSelectGridItemNewStyle({
                                    item: item,
                                    isBigCard: true,
                                })
                            }.columnStart(0).columnEnd(1)
                        } else if (item) {
                            GridItem() {
                                AlbumSelectGridItemNewStyle({
                                    item: item,
                                    isBigCard: false,
                                })
                            }
                        }
                    }, (item: AlbumDataItem) => item ? item.getHashCode() : JSON.stringify(item))
                }
                .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
                .padding({
                    left: $r('app.float.max_padding_start'),
                    right: $r('app.float.max_padding_end'),
                    top: $r('app.float.album_set_page_padding_top')
                })
                .columnsGap($r('app.float.album_set_grid_column_gap'))
                .rowsGap($r('app.float.album_set_grid_row_gap'))

                AlbumScrollBar({ scroller: this.scroller })
            }
        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: px2vp(this.leftBlank[1]),
            bottom: px2vp(this.leftBlank[3])
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.Push, duration: 300 }).slide(SlideEffect.Right)
          .opacity(0)
        PageTransitionEnter({ type: RouteType.Pop, duration: 1 })
          .opacity(0)
        PageTransitionExit({ type: RouteType.Push, duration: 1 })
          .opacity(0)
        PageTransitionExit({ type: RouteType.Pop, duration: 300 }).slide(SlideEffect.Right)
          .opacity(0)
    }
}
