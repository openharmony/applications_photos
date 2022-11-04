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
import { Log } from '../../../../../../../common/base/src/main/ets/utils/Log';
import { ImageGridItemComponent } from '../../../../../../../common/base/src/main/ets/components/ImageGridItemComponent';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { Broadcast } from '../../../../../../../common/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '../../../../../../../common/base/src/main/ets/constants/BroadcastConstants';
import { Constants } from '../../../common/model/common/Constants';
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent';
import screenManager from '../../../../../../../common/base/src/main/ets/manager/ScreenManager';
import { GridScrollBar } from '../../../../../../../common/base/src/main/ets/components/scrollBar/GridScrollBar';
import broadcastManager from '../../../../../../../common/base/src/main/ets/manager/BroadcastManager';
import { ThirdSelectBarModel } from '../model/ThirdSelectBarModel';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { terminateSelfWithResult } from '../../../../../../../common/base/src/main/ets/utils/AbilityUtils';
// Third Select Album Page

const TAG = "ThirdSelectPhotoGridPage"

@Entry
@Component
export struct ThirdSelectPhotoGridPage {
    @Provide selectedCount: number = 0;
    @Provide('isSelectedMode') isMultiPick: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isShow: boolean = true;
    isActive = false;
    title: any;
    @State isEmpty: boolean = false;
    @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    DEFAULT_TOAST_DURATION = 2000;
    isFromWallpaper: boolean;
    @Provide maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
    @State gridRowCount: number = 0;
    @Provide isHideScrollBar: boolean = true;
    isFromFa: boolean = false;
    scroller: Scroller = new Scroller();
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private barModel: ThirdSelectBarModel = new ThirdSelectBarModel();
    private groupDataSource: GroupItemDataSource = new GroupItemDataSource();
    private albumId: string;

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.BACK:
                router.back();
                break;
            case Action.OK:
                this.setPickResult();
                break;
            default:
                break;
        }
    }

    private initGridRowCount(): void {
        let contentWidth = screenManager.getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
    }

    aboutToAppear(): void {
        let param = router.getParams();
        if (param != null) {
            Log.info(TAG, `itemId: ${param.itemId}`);
            this.title = param.itemDisplayName;
            if (param.itemId) {
                this.groupDataSource.setAlbumId(param.itemId.toString());
                this.albumId = param.itemId.toString()
            }
            this.isMultiPick = new Boolean(param.isMultiPick).valueOf();
            this.isFromFa = new Boolean(param.isFromFa).valueOf();
            if (param.isFromWallpaper) {
                this.maxSelectCount = new Number(param.maxSelectCount).valueOf() || 0
            }
            Log.info(TAG, `ThirdSelectPhotoGridPage isMultiPick: ${this.isMultiPick},\
                isFromWallpaper: ${param.isFromWallpaper}, maxSelectCount: ${this.maxSelectCount}`);
        }
        if (this.isFromFa) {
            this.groupDataSource.setSelectType(MediaConstants.SELECT_TYPE_IMAGE)
            AppStorage.SetOrCreate(Constants.FORM_ITEM_NAME, param.itemName);
            AppStorage.SetOrCreate(Constants.FORM_ITEM_ALBUM_ID, param.itemId);
            AppStorage.SetOrCreate(Constants.FORM_ITEM_DISPLAY_NAME, param.itemDisplayName);
        }
        this.groupDataSource.reloadGroupItemData(true).then((isEmpty: boolean) => {
            this.isEmpty = isEmpty;
            this.selectedCount = this.groupDataSource.getSelectedCount();
            this.groupDataSource.notifyDataReload();
        })
        this.initGridRowCount();

        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadcastConstants.SELECT, (index: number) => this.onSelect(index));
        this.broadCast.on(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToThirdPhotoBrowser(name, item);
        })
        this.broadCast.on(Constants.ON_LOADING_FINISHED,
            (size: number) => {
                Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
                this.isEmpty = size == 0;
                Log.info(TAG, `isEmpty: ${this.isEmpty}`)
            });
        this.isActive = true;
    }

    onPageShow() {
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.isShow = true;
        this.onActive();
    }

    onPageHide() {
        this.isShow = false;
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

    private onSelect(index: number) {
        Log.info(TAG, "onSelect");
        this.selectedCount = this.groupDataSource.getSelectedCount();
    }

    private jumpToThirdPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.groupDataSource.getItems();
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            Log.warn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        router.push({
            uri: 'feature/thirdSelect/view/ThirdSelectPhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
                isFromFa: this.isFromFa,
                albumId: this.albumId,
                isMultiPick: this.isMultiPick
            }
        })
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: this.barModel.createActionBar(
                    Action.BACK,
                    this.title,
                    this.isMultiPick,
                    this.selectedCount,
                    this.maxSelectCount),
                onMenuClicked: this.onMenuClicked
            })
            if (this.isEmpty) {
                NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
            }
            Grid(this.scroller) {
                LazyForEach(this.groupDataSource, (item: MediaDataItem) => {
                    GridItem() {
                        ImageGridItemComponent({
                            mediaItem: item,
                            pageName: Constants.PHOTO_TRANSITION_ALBUM,
                            isThird: true
                        })
                    }
                }, (item: MediaDataItem) => item == null ? JSON.stringify(item) : item.getHashCode())
            }
            .columnsTemplate('1fr '.repeat(this.gridRowCount))
            .columnsGap(Constants.GRID_GUTTER)
            .rowsGap(Constants.GRID_GUTTER)
            .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
            .layoutWeight(1)

            GridScrollBar({ scroller: this.scroller });
        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: px2vp(this.leftBlank[1]),
            bottom: px2vp(this.leftBlank[3])
        })
    }

    private setPickResult(): void {
        let uriArray = this.groupDataSource.getSelectedUris()
        let abilityResult = {
            'resultCode': 0,
            'want': {
                'parameters': {
                    'select-item-list': uriArray
                }
            }
        };
        Log.info(TAG, `uri: ${uriArray}`)
        terminateSelfWithResult(abilityResult)
    }
}
