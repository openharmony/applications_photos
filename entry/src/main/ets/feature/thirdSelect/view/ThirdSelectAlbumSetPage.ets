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
import { logDebug, logInfo, logWarn, logError } from '@ohos/base/src/main/ets/utils/LoggerUtils';
import { ThirdAlbumGridItem } from '../../../../../../../features/third/src/main/ets/components/thirdalbumgriditem'
import { Action } from '../../../common/view/browserOperation/Action'
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp'
import { Constants } from '../../../common/model/common/Constants'
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast'
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent'
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager'
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants'
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager'
import { ThirdSelectBarModel } from '../model/ThirdSelectBarModel'
import { AlbumScrollBar } from '../../../../../../../common/base/src/main/ets/components/scrollBar/AlbumScrollBar'
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource'
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { terminateSelfWithResult } from '../../../../../../../common/base/src/main/ets/utils/AbilityUtils';

const TAG = "ThirdSelectAlbumSetPage"
// Third Select AlbumSet Page
@Entry
@Component
export struct ThirdSelectAlbumSetPage {
    @State isEmpty: boolean = false;
    @Provide selectedCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide('isSelectedMode') isMultiPick: boolean = false;
    @Provide maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    isFromWallpaper = false; // Whether the current interface is opened from the wallpaper
    type: string;
    isFromFa: boolean = false;
    @State gridRowCount: number = 3;
    isActive = false;
    @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    isFromFaPhoto: boolean = false;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private barModel: ThirdSelectBarModel = new ThirdSelectBarModel()
    private leftAction: Action = Action.BACK
    private title: string | Resource = ""
    private scroller: Scroller = new Scroller();
    @Provide isHideScrollBar: boolean = true;
    @Provide('tabBarShow') isTabBarShow: boolean = false;
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource()

    aboutToAppear(): void {
        let param = router.getParams();
        if (param != null) {
            this.isMultiPick = new Boolean(param.isMultiPick).valueOf();
            param.type && (this.type = param.type.toString());
            if (param.isFromFa != undefined || param.isFromFa != null) {
                this.isFromFa = new Boolean(param.isFromFa).valueOf();
            }
            if (param.isFromFaPhoto != undefined || param.isFromFaPhoto != null) {
                this.isFromFaPhoto = new Boolean(param.isFromFaPhoto).valueOf();
            }
            this.isFromWallpaper = new Boolean(param.isFromWallpaper).valueOf();
            if (this.isFromWallpaper) {
                this.maxSelectCount = new Number(param.remainingOfWallpapers).valueOf() || 0
            }
        }
        logInfo(TAG, `isFromFa: ${this.isFromFa} isFromFaPhoto ${this.isFromFaPhoto}`);
        if (this.isFromFa) {
            this.albumsDataSource.setSelectType(MediaConstants.SELECT_TYPE_IMAGE)
            this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_VIDEO, MediaConstants.ALBUM_ID_RECYCLE]);
        } else {
            this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_RECYCLE]);
        }
        this.loadAlbums()
        this.leftAction = this.isFromFa ? Action.BACK : Action.CANCEL
        this.title = (this.isFromFa && !this.isFromFaPhoto) ? ActionBarProp.SINGLE_SELECT_ALBUM_TITLE : ActionBarProp.SINGLE_UNSELECT_TITLE
        this.onMenuClicked = this.onMenuClicked.bind(this);
        logInfo(TAG, `isMultiPick: ${this.isMultiPick}`);
        logInfo(TAG, `type: ${this.type}`);
        logInfo(TAG, `ThirdSelectAlbumSetPage isFromWallpaper: ${this.isFromWallpaper}`);
        logInfo(TAG, `ThirdSelectAlbumSetPage maxSelectCount: ${this.maxSelectCount}`);
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            logInfo(TAG, `ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
            this.isHideScrollBar = (size <= (this.gridRowCount * Constants.NUMBER_3 - Constants.NUMBER_1));
        });

        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, () => {
            this.initGridRowCount();
        });

        this.initGridRowCount();
    }

    private loadAlbums() {
        this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
            this.isEmpty = isEmpty
            this.albumsDataSource.notifyDataReload()
        })
    }

    private initGridRowCount(): void {
        let contentWidth = screenManager.getWinWidth();
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        logInfo(TAG, `initGridRowCount gridRowCount: ${this.gridRowCount}`);
    }

    onPageShow() {
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.onActive();
    }

    onPageHide() {
        this.onInActive();
    }

    private onActive() {
        if (!this.isActive) {
            logInfo(TAG, 'onActive');
            this.isActive = true;
        }
    }

    private onInActive() {
        if (this.isActive) {
            logInfo(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    onMenuClicked(action: Action) {
        logInfo(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                logInfo(TAG, 'click cancel');
                let abilityResult = {
                    'resultCode': 0,
                    'want': {
                        'parameters': {
                            'select-item-list': ''
                        }
                    }
                };
                terminateSelfWithResult(abilityResult)
                break;
            case Action.BACK:
                router.back();
                break;
            default:
                break;
        }
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            ActionBar({
                actionBarProp: this.barModel.createActionBar(
                    this.leftAction,
                    this.title,
                    this.isMultiPick,
                    0,
                    this.maxSelectCount),
                onMenuClicked: this.onMenuClicked
            })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoComponent({ title: $r('app.string.title_no_albums') })
                }
                Grid(this.scroller) {
                    LazyForEach(this.albumsDataSource, (item: AlbumDataItem) => {
                        if (item.id != MediaConstants.ALBUM_ID_RECYCLE) {
                            if (item && item.index == 0) {
                                GridItem() {
                                    ThirdAlbumGridItem({
                                        item: item,
                                        isBigCard: true,
                                        isFromWallpaper: this.isFromWallpaper,
                                        isFromFa: this.isFromFa,
                                        isFromFaPhoto: this.isFromFaPhoto
                                    })
                                }.columnStart(0).columnEnd(1)
                            } else if (item) {
                                GridItem() {
                                    ThirdAlbumGridItem({
                                        item: item,
                                        isBigCard: false,
                                        isFromWallpaper: this.isFromWallpaper,
                                        isFromFa: this.isFromFa,
                                        isFromFaPhoto: this.isFromFaPhoto
                                    })
                                }
                            }
                        }
                    }, (item: AlbumDataItem) => item ? item.getHashCode() : JSON.stringify(item))
                }
                .columnsTemplate('1fr '.repeat(this.gridRowCount))
                .padding({
                    left: $r('app.float.max_padding_start'),
                    right: $r('app.float.max_padding_end'),
                    top: $r('app.float.album_set_page_padding_top'),
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
}