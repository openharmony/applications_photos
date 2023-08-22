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
import { ThirdAlbumGridItem } from '@ohos/third/src/main/ets/components/ThirdAlbumGridItem';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { Constants } from '../../../common/model/common/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent';
import { NoPhotoIndexComponent } from '../../../common/view/NoPhotoIndexComponent';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { ThirdSelectBarModel } from '../model/ThirdSelectBarModel';
import { AlbumScrollBar } from '@ohos/base/src/main/ets/components/scrollBar/AlbumScrollBar';
import { AlbumsDataSource } from '@ohos/base/src/main/ets/vm/AlbumsDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { terminateSelfWithResult } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';

const TAG = "ThirdSelectAlbumSetPage"
// Third Select AlbumSet Page
@Entry
@Component
struct ThirdSelectAlbumSetPage {
    @State isEmpty: boolean = false;
    @Provide selectedCount: number = 0;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide('isSelectedMode') @Watch('updateActionBar') isMultiPick: boolean = false;
    @Provide @Watch('updateActionBar') maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
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
    isFromThird: boolean = false;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private barModel: ThirdSelectBarModel = new ThirdSelectBarModel();
    private leftAction: Action = Action.BACK;
    private title: string | Resource = ""
    private scroller: Scroller = new Scroller();
    @Provide isHideScrollBar: boolean = true;
    @Provide('tabBarShow') isTabBarShow: boolean = false;
    private albumsDataSource: AlbumsDataSource = new AlbumsDataSource();
    @State actionBarProp: ActionBarProp = new ActionBarProp();
    filterMediaType: number = MediaConstants.SELECT_TYPE_ALL;
    bundleName: string = "";
    isSelectPhotoGrid: boolean = false;
    onWindowSizeChangeCallBack = () => this.initGridRowCount();

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(this.leftAction, this.title,
                                            this.isMultiPick, 0, this.maxSelectCount, this.isSelectPhotoGrid);
    }

    aboutToAppear(): void {
        let param = router.getParams();
        if (param != null) {
            this.bundleName = new String(param.bundleName).valueOf();
            this.isMultiPick = new Boolean(param.isMultiPick).valueOf();
            param.type && (this.type = param.type.toString());
            if (param.isFromFa != undefined || param.isFromFa != null) {
                this.isFromFa = new Boolean(param.isFromFa).valueOf();
            }
            if (param.isFromFaPhoto != undefined || param.isFromFaPhoto != null) {
                this.isFromFaPhoto = new Boolean(param.isFromFaPhoto).valueOf();
            }
            if (param.isFromThird != undefined || param.isFromThird != null) {
                this.isFromThird = new Boolean(param.isFromThird).valueOf();
            }
            if (param.filterMediaType != undefined || param.filterMediaType != null) {
                this.filterMediaType = new Number(param.filterMediaType).valueOf();
            }
            this.isFromWallpaper = new Boolean(param.isFromWallpaper).valueOf();
            if (this.isFromWallpaper) {
                this.maxSelectCount = new Number(param.remainingOfWallpapers).valueOf() || 0
            } else if (!!param.maxSelectCount && param.maxSelectCount > 0) {
                let selectCount = new Number(param.maxSelectCount).valueOf();
                this.maxSelectCount = selectCount > Constants.LIMIT_MAX_THIRD_SELECT_COUNT
                    ? Constants.LIMIT_MAX_THIRD_SELECT_COUNT
                    : selectCount;
            }
        }
        Log.info(TAG, `isFromFa: ${this.isFromFa} isFromFaPhoto ${this.isFromFaPhoto}`);
        
        if (this.isFromFa || this.isFromFaPhoto) {
            this.albumsDataSource.setSelectType(MediaConstants.SELECT_TYPE_IMAGE)
            this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_VIDEO, MediaConstants.ALBUM_ID_RECYCLE]);
        } else {
            this.albumsDataSource.setSelectType(this.filterMediaType);
            if (this.filterMediaType == MediaConstants.SELECT_TYPE_IMAGE) {
                this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_VIDEO]);
            }
            this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_RECYCLE]);
        }
        this.loadAlbums()
        this.leftAction = this.isFromFa ? Action.BACK : Action.CANCEL
        this.title = (this.isFromFa && !this.isFromFaPhoto) ? ActionBarProp.SINGLE_SELECT_ALBUM_TITLE : ActionBarProp.SINGLE_UNSELECT_TITLE
        this.onMenuClicked = this.onMenuClicked.bind(this);
        Log.info(TAG, `isMultiPick: ${this.isMultiPick}`);
        Log.info(TAG, `type: ${this.type}`);
        Log.info(TAG, `ThirdSelectAlbumSetPage isFromWallpaper: ${this.isFromWallpaper}`);
        Log.info(TAG, `ThirdSelectAlbumSetPage maxSelectCount: ${this.maxSelectCount}`);
        Log.info(TAG, `ThirdSelectAlbumSetPage filterMediaType: ${this.filterMediaType}`);
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
            this.isHideScrollBar = (size <= (this.gridRowCount * Constants.NUMBER_3 - Constants.NUMBER_1));
        });

        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);

        this.initGridRowCount();
        this.updateActionBar();
        AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
    }

    private jumpToAllAlbumGridPage(allAlbumDataItem: AlbumDataItem) {
        router.push({
            uri: 'feature/thirdSelect/view/ThirdSelectPhotoGridPage',
            params: {
                itemCoverUri: allAlbumDataItem.uri,
                itemId: allAlbumDataItem.id,
                itemCount: allAlbumDataItem.count,
                isMultiPick: this.isMultiPick,
                isFromWallpaper: this.isFromWallpaper,
                maxSelectCount: this.maxSelectCount,
                itemDisplayName: allAlbumDataItem.displayName,
                isFromFa: this.isFromFa,
                filterMediaType: this.filterMediaType
            }
        });
    }

     private async loadAlbums() {
         let displayName = await getResourceString($r('app.string.album_all'));
         this.albumsDataSource.reloadAlbumItemData().then((isEmpty: boolean) => {
             this.isEmpty = isEmpty
             this.albumsDataSource.notifyDataReload()
            // 从三方拉起，直接跳转到所有相册
            if (this.isFromThird) {
                let allAlbumDataItem: AlbumDataItem = this.albumsDataSource.getAlbumDataItemById(MediaConstants.ALBUM_ID_ALL);
                if (allAlbumDataItem == undefined) {
                    allAlbumDataItem = new AlbumDataItem(MediaConstants.ALBUM_ID_ALL, 0, displayName, this.filterMediaType, '');
                }
                this.jumpToAllAlbumGridPage(allAlbumDataItem);
            }
        })
    }

    private initGridRowCount(): void {
        let contentWidth = screenManager.getWinWidth();
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
        / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        Log.info(TAG, `initGridRowCount gridRowCount: ${this.gridRowCount}`);
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
            Log.info(TAG, 'onActive');
            this.isActive = true;
        }
    }

    private onInActive() {
        if (this.isActive) {
            Log.info(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                Log.info(TAG, 'click cancel');
                let abilityResult = {
                    'resultCode': 0,
                    'want': {
                        'parameters': {
                            'select-item-list': []
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
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoIndexComponent({ index: Constants.ALBUM_PAGE_INDEX })
                }
                Grid(this.scroller) {
                    LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>) => {
                        if (item && item.get() && item.get().id != MediaConstants.ALBUM_ID_RECYCLE) {
                            if ( item.get().index == 0) {
                                GridItem() {
                                    ThirdAlbumGridItem({
                                        item: item.get(),
                                        isBigCard: true,
                                        isFromWallpaper: this.isFromWallpaper,
                                        isFromFa: this.isFromFa,
                                        isFromFaPhoto: this.isFromFaPhoto,
                                        filterMediaType: this.filterMediaType,
                                        bundleName: this.bundleName
                                    })
                                }.columnStart(0).columnEnd(1)
                            } else {
                                GridItem() {
                                    ThirdAlbumGridItem({
                                        item: item.get(),
                                        isBigCard: false,
                                        isFromWallpaper: this.isFromWallpaper,
                                        isFromFa: this.isFromFa,
                                        isFromFaPhoto: this.isFromFaPhoto,
                                        filterMediaType: this.filterMediaType,
                                        bundleName: this.bundleName
                                    })
                                }
                            }
                        }
                    }, (item: LazyItem<AlbumDataItem>) => item && item.get() ? item.getHashCode() : JSON.stringify(item))
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