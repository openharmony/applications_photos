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
import { logDebug, logInfo, logWarn, logError } from '@ohos/base/src/main/ets/utils/LoggerUtils'
import { ImageGridItemComponent } from '@ohos/base/src/main/ets/components/ImageGridItemComponent'
import { Action } from '../../../common/view/browserOperation/Action'
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView'
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast'
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants'
import { Constants } from '../../../common/model/common/Constants'
import { NoPhotoComponent } from '../../../common/view/NoPhotoComponent'
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager'
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils'
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager'
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext'
import { CopyMenuOperation } from '@ohos/base/src/main/ets/operation/CopyMenuOperation'
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain'
import { GridScrollBar } from '../../../../../../../common/base/src/main/ets/components/scrollBar/GridScrollBar';
import { NewAlbumBarModel } from '../model/NewAlbumBarModel';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource'
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';

const TAG = "NewAlbumPage"

@Entry
@Component
export struct NewAlbumPage {
    @State isEmpty: boolean = false;
    @Provide isHideScrollBar: boolean = true;
    @State gridRowCount: number = 0;
    @Provide isSelectedMode: boolean = true;
    @Provide isAllSelected: boolean = false;
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide isShow: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
    @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    private scroller: Scroller = new Scroller();
    private isActive = false;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private isNewAlbum: boolean = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM);
    private targetAlbum: SimpleAlbumDataItem = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET);
    private barModel: NewAlbumBarModel = new NewAlbumBarModel()
    private groupDataSource: GroupItemDataSource = new GroupItemDataSource()

    onIndexChange() {
        logInfo(TAG, `onIndexChange ${this.PhotoGridPageIndex}`)
        if (this.PhotoGridPageIndex != Constants.INVALID) {
            this.scroller.scrollToIndex(this.PhotoGridPageIndex);
        }
    }

    onMenuClicked(action: Action) {
        logInfo(TAG, `onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                this.groupDataSource.setSelect(false)
                router.back();
                break;
            case Action.OK:
                if (this.groupDataSource.getSelectedCount() == 0) {
                    logInfo(TAG, `onMenuClicked, action: ${action.actionID}, count = 0`);
                    break;
                }
                logInfo(TAG, `onMenuClicked, action: ${action.actionID} newAlbum: ${this.isNewAlbum}`);
                if (this.isNewAlbum) {
                    AppStorage.SetOrCreate<MediaDataItem[]>(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.groupDataSource.getSelectedItems());
                    this.groupDataSource.setSelect(false)
                    let url = this.isHorizontal ? 'product/pad/view/index' : 'product/phone/view/index'
                    router.back({
                        uri: url,
                        params: {
                            jumpSource: JumpSourceToMain.ALBUM
                        }
                    })
                } else {
                    this.copyOperation();
                }
                break;
            default:
                break;
        }
    }

    onModeChange() {
        logInfo(TAG, 'onModeChange');
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

    // The callback when current page is in the foreground
    onActive() {
        if (!this.isActive) {
            logInfo(TAG, 'onActive');
            this.isActive = true;
        }
        this.groupDataSource.dataRemove()
    }

    // The callback when current page is in the background
    onInActive() {
        if (this.isActive) {
            logInfo(TAG, 'onInActive');
            this.isActive = false;
        }
    }

    onUpdateFavorState(item: MediaDataItem) {
        logDebug(TAG, 'onUpdateFavorState');
        let index = this.groupDataSource.getIndexByItem(item);
        if (index != -1) {
            this.groupDataSource.notifyDataChange(index);
        }
    }

    onBackPress() {
        this.groupDataSource.setSelect(false)
        return false;
    }

    onOperationStart(): void {
    }

    onOperationEnd(): void {
        if (this.isNewAlbum) {
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
            let url = this.isHorizontal ? 'product/pad/view/index' : 'product/phone/view/index'
            router.back({
                uri: url,
                params: {
                    jumpSource: JumpSourceToMain.ALBUM
                }
            })
        } else {
            router.back({
                uri: 'feature/photoGrid/view/PhotoGridPage',
            });
        }
    }

    private copyOperation() {
        let menuContext = new MenuContext();
        this.onOperationStart = this.onOperationStart.bind(this);
        this.onOperationEnd = this.onOperationEnd.bind(this);
        menuContext
            .withDataSource(this.groupDataSource)
            .withOperationStartCallback(this.onOperationStart)
            .withOperationEndCallback(this.onOperationEnd)
            .withBroadCast(this.broadCast)
            .withAlbumInfo(this.targetAlbum);
        let menuOperation = new CopyMenuOperation(menuContext);
        menuOperation.doAction();
    }

    aboutToAppear(): void {
        startTrace('PhotoGridPageAboutToAppear');
        let param = router.getParams();
        if (param.item) {
            logDebug(TAG, `After router.getParams, param is: ${JSON.stringify(param)}`);
            let item = JSON.parse(param.item.toString()) as AlbumDataItem;
            this.groupDataSource.setAlbumId(item.id)
        }
        this.groupDataSource.reloadGroupItemData(true).then((isEmpty: boolean) => {
            this.isEmpty = isEmpty
            this.groupDataSource.notifyDataReload()
        })
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadcastConstants.SELECT, (index: number) => this.onSelect(index));

        this.broadCast.on(BroadcastConstants.JUMP_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToPhotoBrowser(name, item)
        })

        this.broadCast.on(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: MediaDataItem) => {
            this.jumpToThirdPhotoBrowser(name, item)
        })

        this.appBroadcast.on(BroadcastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));

        this.initGridRowCount();
        this.moreMenuList = [];
        this.moreMenuList.push(Action.INFO);
        finishTrace('PhotoGridPageAboutToAppear');
    }

    private initGridRowCount(): void {
        let contentWidth = screenManager.getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        logInfo(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
    }

    private onSelect(index: number) {
        logInfo(TAG, "onSelect")
        this.totalSelectedCount = this.groupDataSource.getSelectedCount()
        this.isAllSelected = this.groupDataSource.isSelect()
        this.groupDataSource.notifyDataChange(index)
    }

    private jumpToPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.groupDataSource.getItems()
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            logWarn(TAG, 'targetIndex is not found');
            return;
        }
        logInfo(TAG, `jump to photo browser at index: ${targetIndex}`);
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        router.push({
            uri: 'feature/browser/view/PhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
            }
        });
    }

    private jumpToThirdPhotoBrowser(name: string, item: MediaDataItem) {
        let children: MediaDataItem[] = this.groupDataSource.getItems()
        let targetIndex = children.indexOf(item);
        if (targetIndex == Constants.NOT_FOUND) {
            logWarn(TAG, 'targetIndex is not found');
            return;
        }
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, children);
        router.push({
            uri: 'feature/browser/view/SelectPhotoBrowser',
            params: {
                position: targetIndex,
                transition: name,
            }
        })
    }

    aboutToDisappear(): void {
        this.broadCast.off(null, null);
        this.appBroadcast.off(BroadcastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: this.barModel.createActionBar(),
                onMenuClicked: this.onMenuClicked
            })
            if (this.isEmpty) {
                NoPhotoComponent({
                    title: $r('app.string.no_distributed_photo_head_title_album')
                })
            } else {
                Stack() {
                    Grid(this.scroller) {
                        LazyForEach(this.groupDataSource, (item: MediaDataItem) => {
                            GridItem() {
                                ImageGridItemComponent({
                                    mediaItem: item,
                                    pageName: Constants.PHOTO_TRANSITION_ALBUM
                                })
                            }
                            .columnStart(item.index % this.gridRowCount)
                            .columnEnd(item.index % this.gridRowCount)
                        }, (item: MediaDataItem) => item == null ? JSON.stringify(item) : item.getHashCode())
                    }
                    .columnsTemplate('1fr '.repeat(this.gridRowCount))
                    .columnsGap(Constants.GRID_GUTTER)
                    .rowsGap(Constants.GRID_GUTTER)
                    .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

                    GridScrollBar({ scroller: this.scroller });
                }
                .layoutWeight(1)
            }
            CustomDialogView()
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
        PageTransitionExit({ type: RouteType.Pop, duration: 300 }).slide(SlideEffect.Right)
          .opacity(0)
    }
}