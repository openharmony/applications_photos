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
import {Logger} from '../../utils/Logger'
import {ImageGridItemComponent} from '../../../../common/view/ImageGridItemComponent.ets'
import {Action} from '../../../../common/model/browser/operation/Action.ets'
import {CustomDialogView} from '../../../../common/view/dialog/CustomDialogView'
import {SelectManager} from '../../../../common/model/browser/SelectManager.ets'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {Constants} from '../../../../common/model/common/Constants.ets'
import {MediaDataSource} from '../../../../common/model/browser/photo/MediaDataSource.ets'
import {MediaItem} from '../../../../common/model/browser/photo/MediaItem.ets'
import {NoPhotoComponent} from '../../../../common/view/NoPhotoComponent'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import {TraceControllerUtils} from '../../../../common/utils/TraceControllerUtils'
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager'
import {AlbumDefine} from '../../../../common/model/browser/AlbumDefine.ets'
import {AlbumSelectActionBar} from './AlbumSelectActionBar.ets'
import {MenuContext} from '../../../../common/model/browser/operation/MenuContext'
import {MenuOperationFactory} from '../../../../common/model/browser/interface/MenuOperationFactory.ets'
import {CopyMenuOperation} from '../../../../common/model/browser/operation/CopyMenuOperation.ets'
import {MoveMenuOperation} from '../../../../common/model/browser/operation/MoveMenuOperation.ets'
import {JumpSourceToMain} from '../../../../common/model/browser/photo/JumpSourceToMain.ets'

AppStorage.SetOrCreate('PhotoGridPageIndex', Constants.INVALID);

@Entry
@Component
export struct NewAlbumPage {
    @State isEmpty: boolean = false;
    @State isHideScrollBar: boolean = true;
    @State gridRowCount: number = 0;
    @Provide isSelectedMode: boolean = true;
    @Provide isAllSelected: boolean = false;
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isShow: boolean = true;
    @Provide isShowBar: boolean = true;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    @State isClickScrollBar: boolean = false;

    @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;

    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    title: string;
    private dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
    private scroller: Scroller = new Scroller();
    private isDataFreeze = false;
    private logger: Logger = new Logger('NewAlbumPage');
    private mSelectManager : SelectManager;
    private isActive = false;
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private isNewAlbum: boolean = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM);
    private targetAlbumName: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET);

    onIndexChange() {
        this.logger.info(`onIndexChange ${this.PhotoGridPageIndex}`)
        if (this.PhotoGridPageIndex != Constants.INVALID) {
            this.scroller.scrollToIndex(this.PhotoGridPageIndex);
        }
    }

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                router.back();
                break;
            case Action.OK:
                if (this.mSelectManager.getSelectedCount() == 0) {
                    this.logger.info(`onMenuClicked, action: ${action.actionID}, count = 0`);
                    break;
                }
                this.logger.info(`onMenuClicked, action: ${action.actionID} newAlbum: ${this.isNewAlbum}`);
                if (this.isNewAlbum) {
                    this.broadCast.emit(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
                        [this.moveOperation.bind(this), this.copyOperation.bind(this)]);
                } else {
                    this.copyOperation();
                }
                break;
            default:
                break;
        }
    }

    freezeAdapter(fn): Function {
        let self = this;
        return function () {
            if (self.isDataFreeze) {
                return;
            }
            let context = this;
            let args = arguments;
            fn.apply(context, args);
        }
    }

    onModeChange() {
        this.logger.info('onModeChange');
    }

    private onPageShow() {
        this.isShow = true;
        this.onActive();
    }

    private onPageHide() {
        this.isShow = false;
        this.onInActive();
    }

    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;

            this.dataSource && this.dataSource.onActive();
            if (this.isSelectedMode) {
                this.totalSelectedCount = this.mSelectManager.getSelectedCount();
                this.dataSource.forceUpdate();
            }
        }
    }

    onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.dataSource && this.dataSource.onInActive();
        }
    }
    onUpdateFavorState(item: MediaItem) {
        this.logger.debug('onUpdateFavorState');
        let index = this.dataSource.getIndexByMediaItem(item);
        if (index != -1) {
            this.dataSource.onDataChanged(index);
        }
    }

    private onBackPress() {
        return false;
    }

    onOperationStart(): void {
        this.isDataFreeze = true;
    }

    onOperationEnd(): void {
        this.isDataFreeze = false;
        if (this.isNewAlbum) {
            this.mSelectManager.onModeChange(false);
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
            AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
            let url = this.isHorizontal ? 'product/pad/view/index' : 'product/phone/view/index'
            router.replace({
                uri: url,
                params: {
                    jumpSource: JumpSourceToMain.ALBUM
                }
            })
        } else {
            router.back({
                uri: 'feature/browser/view/photoGrid/PhotoGridPage',
            });
        }
    }

    private copyOperation() {
        let menuContext = new MenuContext();
        this.onOperationStart = this.onOperationStart.bind(this);
        this.onOperationEnd = this.onOperationEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onOperationStart)
            .withOperationEndCallback(this.onOperationEnd)
            .withBroadCast(this.broadCast)
            .withAlbumName(this.targetAlbumName);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(CopyMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private moveOperation() {
        let menuContext = new MenuContext();
        this.onOperationStart = this.onOperationStart.bind(this);
        this.onOperationEnd = this.onOperationEnd.bind(this);
        menuContext
            .withSelectManager(this.mSelectManager)
            .withOperationStartCallback(this.onOperationStart)
            .withOperationEndCallback(this.onOperationEnd)
            .withBroadCast(this.broadCast)
            .withAlbumName(this.targetAlbumName);
        let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
        menuOperation.doAction();
    }

    private aboutToAppear(): void {
        TraceControllerUtils.startTrace('PhotoGridPageAboutToAppear');
        this.mSelectManager = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SELECTED);
        let param = router.getParams();
        if (param != null) {
            this.logger.info(`After router.getParams, param is: ${JSON.stringify(param)}`);
            let item = JSON.parse(param.item);
            this.title = item.displayName;
            this.dataSource.setAlbumName(item.name);
        } else {
            this.title = '';
            this.dataSource.setAlbumName(AlbumDefine.ALBUM_NAME_ALL);
        }

        let self = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.dataSource.setBroadCast(this.broadCast)
        this.mSelectManager.setPhotoDataImpl();
        this.broadCast.on(BroadCastConstants.SELECT,
            (position: number, key: string, value: boolean, callback: Function) => {
                if (self.mSelectManager.toggle(key, value)) {
                    self.logger.info('enter event process');
                    callback();
                }
            });

        this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER,
            (name: string, item: MediaItem) => {
                let targetIndex = self.dataSource.getDataIndex(item);
                self.logger.info(`jump to photo browser at index: ${targetIndex}`);
                AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
                router.push({
                    uri: 'feature/browser/view/photo/PhotoBrowser',
                    params: {
                        position: targetIndex,
                        transition: name,
                        leftBlank: self.leftBlank,
                    }
                });
            })

        this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            (name: string, item: MediaItem) => {
                let targetIndex = self.dataSource.getDataIndex(item);
                self.logger.info(`jump to photo browser, index: ${targetIndex}, transition: ${name}`);
                AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
                router.push({
                    uri: 'feature/browser/view/photo/SelectPhotoBrowser',
                    params: {
                        position: targetIndex,
                        transition: name,
                    }
                })
            })

        this.broadCast.on(Constants.ON_LOADING_FINISHED,
            (size: number) => {
                this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
                this.isEmpty = size == 0;
                this.logger.info(`isEmpty: ${this.isEmpty}`);
            });

        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED,
            () => {
                this.logger.info('ON_DATA_RELOADED');
                this.dataSource.onDataReloaded();
            });

        this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
        AppStorage.SetOrCreate(Constants.THIRD_SELECT_MANAGER, this.mSelectManager);
        this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
            self.logger.info(`allSelect ${newState}`);
            self.isAllSelected = newState;
            self.dataSource.forceUpdate();
        }));
        this.mSelectManager.registerCallback('updateCount', this.freezeAdapter((newState: number) => {
            self.logger.info(`updateSelectedCount ${newState}`);
            self.moreMenuList = [];
            self.moreMenuList.push(Boolean(newState) ? Action.INFO: Action.INFO_INVALID);
            self.totalSelectedCount = newState;
        }));
        this.dataSource.registerCallback('updateCount', (newState: number) => {
            self.logger.info(`updateTotalCount ${newState}`);
            self.isHideScrollBar = (newState <= 50);
            self.mSelectManager.setTotalCount(newState);
        })

        this.initGridRowCount();
        this.moreMenuList = [];
        this.moreMenuList.push(Action.INFO);
        TraceControllerUtils.finishTrace('PhotoGridPageAboutToAppear');
    }

    private initGridRowCount(): void {
        let contentWidth = ScreenManager.getInstance().getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        this.logger.info(`initGridRowCount contentWidth: ${contentWidth}`);
    }

    private aboutToDisappear(): void {
        this.broadCast.off(null, null);
        this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
    }

    build() {
        Column() {
            AlbumSelectActionBar({ onMenuClicked: this.onMenuClicked })
            Stack() {
                if (this.isEmpty) {
                    NoPhotoComponent({
                        title: $r('app.string.title_no_photos')
                    })
                }
                Grid(this.scroller) {
                    LazyForEach(this.dataSource, (item) => {
                        GridItem() {
                            ImageGridItemComponent({
                                item: item.mediaItem,
                                isSelected: this.mSelectManager.isItemSelected(item.mediaItem.uri),
                                pageName: Constants.PHOTO_TRANSITION_ALBUM
                            })
                        }.columnStart(item.viewIndex % this.gridRowCount).columnEnd(item.viewIndex % this.gridRowCount)
                    }, item => JSON.stringify(item))
                }
                .columnsTemplate('1fr '.repeat(this.gridRowCount))
                    .columnsGap(Constants.GRID_GUTTER)
                    .rowsGap(Constants.GRID_GUTTER)
                    .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

                ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical,
                    state: this.isHideScrollBar? BarState.Off: BarState.Auto }) {
                    Row(){
                        if (this.isClickScrollBar){
                            Image($r('app.media.scroll_press_light_hdpi'))
                                .width(40)
                                .height(69)
                                .backgroundColor(0x01000000)
                                .border({ width: 1, color: Color.White })
                                .borderRadius(25)
                        } else {
                            Image($r('app.media.scroll_light_hdpi'))
                                .width(32)
                                .height(56)
                                .backgroundColor(0x01000000)
                                .border({ width: 1, color: Color.White })
                                .borderRadius(25)
                        }
                    }
                }.width(40).height(900).backgroundColor(0x01000000)
                .position({ x:'100%', y:0 })
                .markAnchor({ x: 40, y: 0 })
                .onTouch((event: TouchEvent) => {
                    if(event.type == TouchType.Down){
                        this.isClickScrollBar = true;
                    } else if(event.type == TouchType.Down){
                        this.isClickScrollBar = false;
                    }
                })
            }.layoutWeight(1)

            CustomDialogView()
        }
        .backgroundColor($r('app.color.default_background_color'))
        .margin({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
            .opacity(1)
        PageTransitionExit({ type: RouteType.Push, duration: 300 })
            .opacity(1)
    }
}