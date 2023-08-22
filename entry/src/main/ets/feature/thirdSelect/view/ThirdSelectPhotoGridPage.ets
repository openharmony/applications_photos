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
import { ImageGridItemComponent } from '@ohos/base/src/main/ets/components/ImageGridItemComponent';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Constants } from '../../../common/model/common/Constants';
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { GridScrollBar } from '@ohos/base/src/main/ets/components/scrollBar/GridScrollBar';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { ThirdSelectBarModel } from '../model/ThirdSelectBarModel';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { terminateSelfWithResult } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { CameraGridItemComponent } from './CameraGridItemComponent'
import { SelectUtil } from '@ohos/base/src/main/ets/utils/SelectUtil';
import { ThirdSelectedPanel } from './ThirdSelectedPanel';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
// Third Select Album Page

const TAG = "ThirdSelectPhotoGridPage"

@Entry
@Component
struct ThirdSelectPhotoGridPage {
    @Provide @Watch('updateActionBar') selectedCount: number = 0;
    @Provide('isSelectedMode') @Watch('updateActionBar') isMultiPick: boolean = false;
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
    @Provide @Watch('updateActionBar') maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
    @State gridRowCount: number = 0;
    @State isHideScrollBar: boolean = true;
    isFromFa: boolean = false;
    isFromFaPhoto: boolean = false;
    scroller: Scroller = new Scroller();
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private barModel: ThirdSelectBarModel = new ThirdSelectBarModel();
    private groupDataSource: GroupItemDataSource = new GroupItemDataSource();
    private albumId: string;
    @State actionBarProp: ActionBarProp = new ActionBarProp();
    bundleName: string = "";
    filterMediaType: number = MediaConstants.SELECT_TYPE_ALL;
    isSelectPhotoGrid: boolean = true;
    @Provide isOriginalChecked: boolean = false;
    @State isSelectUpperLimited: boolean = false;

    updateActionBar(): void {
        this.actionBarProp = this.barModel.createActionBar(this.bundleName == "" ? Action.BACK : Action.CANCEL, this.title, this.isMultiPick,
                                                    this.selectedCount, this.maxSelectCount, this.isSelectPhotoGrid);
    }

    onMenuClicked(action: Action) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.BACK:
                router.back();
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
            case Action.OK:
                this.setPickResult();
                break;
            case Action.NAVIGATION_ALBUMS:
                router.push({
                    uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                    params: {
                        isMultiPick: this.isMultiPick,
                        isFromFa: this.isFromFa,
                        isFromFaPhoto: true,
                    }
                });
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
            this.bundleName = new String(param.bundleName).valueOf();
            this.isMultiPick = new Boolean(param.isMultiPick).valueOf();
            this.isFromFa = new Boolean(param.isFromFa).valueOf();
            this.isFromFaPhoto = new Boolean(param.isFromFaPhoto).valueOf();
            if (!!param.maxSelectCount && param.maxSelectCount > 0) {
                this.maxSelectCount = new Number(param.maxSelectCount).valueOf() || 0
            }
            if (param.filterMediaType) {
                this.filterMediaType = new Number(param.filterMediaType).valueOf();
                Log.info(TAG, `filterMediaType: ${this.filterMediaType}`)
            }
        }
        if (this.isFromFa || this.isFromFaPhoto) {
            this.filterMediaType = MediaConstants.SELECT_TYPE_IMAGE;
            AppStorage.SetOrCreate(Constants.FORM_ITEM_NAME, param.itemName);
            AppStorage.SetOrCreate(Constants.FORM_ITEM_ALBUM_ID, param.itemId);
            AppStorage.SetOrCreate(Constants.FORM_ITEM_DISPLAY_NAME, param.itemDisplayName);
        }
        if(this.maxSelectCount) {
            this.filterMediaType = MediaConstants.SELECT_TYPE_IMAGE;
        }
        this.groupDataSource.setSelectType(this.filterMediaType);
        Log.info(TAG, `ThirdSelectPhotoGridPage isMultiPick: ${this.isMultiPick},\
                isFromWallpaper: ${param.isFromWallpaper}, maxSelectCount: ${this.maxSelectCount}, filterMediaType: ${this.filterMediaType}`);
        this.groupDataSource.reloadGroupItemData(true).then((isEmpty: boolean) => {
            this.isEmpty = isEmpty;
            this.selectedCount = this.groupDataSource.getSelectedCount();
            this.groupDataSource.notifyDataReload();
            this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
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

        this.updateActionBar();
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

    private async onSelect(index: number) {
        Log.info(TAG, "onSelect");
        let lastSelectedCount = this.selectedCount;
        this.selectedCount = this.groupDataSource.getSelectedCount();
        if (lastSelectedCount == this.selectedCount && this.selectedCount >= this.maxSelectCount) {
            let toastMsg = await getResourceString($r('app.string.up_to_limit_tips'));
            showToast(toastMsg);
            return;
        }
        this.isSelectUpperLimited = this.selectedCount >= this.maxSelectCount;
        this.groupDataSource.onDataUpdate(index);
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
                bundleName: this.bundleName,
                transition: name,
                isFromFa: this.isFromFa,
                albumId: this.albumId,
                isMultiPick: this.isMultiPick,
                isSelectUpperLimited: this.isSelectUpperLimited
            }
        })
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })
            if (this.isEmpty && this.isFromFa) {
                NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
            }
            Grid(this.scroller) {
                if (!this.isFromFa) {
                    GridItem() {
                        CameraGridItemComponent({
                            bundleName: this.bundleName,
                            filterMediaType: this.filterMediaType
                        })
                    }
                    .aspectRatio(1)
                }
                LazyForEach(this.groupDataSource, (item: LazyItem<MediaDataItem>) => {
                    GridItem() {
                        ImageGridItemComponent({
                            lazyItem: item,
                            mediaItem: item.get(),
                            pageName: Constants.PHOTO_TRANSITION_ALBUM,
                            isThird: true,
                            isSelectUpperLimited: $isSelectUpperLimited
                        })
                    }
		    .aspectRatio(1)
                }, (item: LazyItem<MediaDataItem>) => item == null && item.get() ? JSON.stringify(item) : item.getHashCode())
            }
            .columnsTemplate('1fr '.repeat(this.gridRowCount))
            .columnsGap(Constants.GRID_GUTTER)
            .rowsGap(Constants.GRID_GUTTER)
            .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
            .layoutWeight(1)

            if (this.isMultiPick) {
                Column() {
                    ThirdSelectedPanel({
                        onMenuClicked: this.onMenuClicked,
                        groupDataSource: this.groupDataSource
                    })
                }
                .width("100%")
                .height($r('app.float.third_selected_panel_height'))
            }

            GridScrollBar({ scroller: this.scroller, isHideScrollBar: $isHideScrollBar});
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
                    'select-item-list': uriArray,
                    'isOriginal': this.isOriginalChecked
                }
            }
        };
        Log.info(TAG, `uri: ${uriArray}`)
        let self = this;
        if (uriArray == null && uriArray == undefined) {
            globalThis.appContext.terminateSelfWithResult(abilityResult).then((result) => {
                Log.info(TAG, `terminateSelfWithResult result: ${result}`);
            });
        } else {
            SelectUtil.grantPermissionForUris(uriArray, self.bundleName);
            try {
                Log.info(TAG, `grant permission success.`);
                globalThis.appContext.terminateSelfWithResult(abilityResult).then((result) => {
                    Log.info(TAG, `terminateSelfWithResult result: ${result}`);
                });
            } catch (err) {
                Log.info(TAG, `grant permission error: ${JSON.stringify(err)}`);
            }
        }
    }
}
