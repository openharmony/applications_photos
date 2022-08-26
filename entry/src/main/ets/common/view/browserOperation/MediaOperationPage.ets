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
import { MediaOperationType } from '../../model/common/MediaOperationType'
import { MediaOperationActionBar } from './MediaOperationActionBar'
import { Logger } from '../../utils/Logger'
import { BroadCast } from '../../utils/BroadCast'
import { AlbumSetNewMenuOperation } from './AlbumSetNewMenuOperation';
import { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumListCard } from './AlbumListCard';
import router from '@system.router';
import { MenuContext } from './MenuContext';
import { Action } from './Action';
import { JumpSourceToMain } from '../../../common/model/browser/photo/JumpSourceToMain'
import { CustomDialogView } from '../dialog/CustomDialogView';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { ScreenManager, ColumnSize } from '../../model/common/ScreenManager';
import { BroadCastManager } from '../../model/common/BroadCastManager';
import { Constants } from '../../model/common/Constants';

@Entry
@Component
struct MediaOperationPage {
    @StorageLink('screenColumns') screenColumns: number = ScreenManager.getInstance().getScreenColumns();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @Provide pageType: string = MediaOperationType.Move;
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide moreMenuList: Action[] = new Array<Action>();
    @Provide loadingFinish: boolean = false;
    @State listCardWidth: number = 0;
    scroller: Scroller = new Scroller();
    albums: AlbumSetDataSource;
    isActive: boolean = false; // Whether the page is in the foreground
    logger: Logger = new Logger('MediaOperationPage');
    sourceAlbumId: string;
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

    aboutToAppear(): void {
        let self = this;
        this.albums = new AlbumSetDataSource(this.broadCast, { moreInfo: true });

        this.onActive();
        let param = router.getParams();
        if (param) {
            this.logger.info(`router getParams ${JSON.stringify(param)}`);
            param.pageType && (this.pageType = param.pageType.toString());
            param.albumId && (this.sourceAlbumId = param.albumId.toString());
        }
        this.onMenuClicked = this.onMenuClicked.bind(this);

        this.broadCast.on(Constants.ON_LOADING_FINISHED, (totalCount) => {
            this.loadingFinish = true;
        });

        this.broadCast.on(BroadCastConstants.MEDIA_OPERATION, (albumInfo: AlbumInfo, completedFunc?: Function) => {
            router.back({
                uri: '',
                params: {
                    pageType: self.pageType,
                    albumInfo: JSON.stringify(albumInfo)
                }
            });
            completedFunc && completedFunc();
        });
        this.albums.updateAlbumMediaCount();
        this.updateListCardWidth();
        this.logger.info(`album mediaSet ${this.albums.mediaSetList}`);
    }

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, actionID: ${action.actionID}`);

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
        this.logger.info('createNewAlbum');
        let menuContext = new MenuContext();
        this.onOperationStart = this.onOperationStart.bind(this);
        this.onOperationEnd = this.onOperationEnd.bind(this);
        menuContext
            .withOperationStartCallback(this.onOperationStart)
            .withOperationEndCallback(this.onOperationEnd)
            .withAlbumSetDataSource(this.albums)
            .withBroadCast(this.broadCast)
            .withJumpSourceToMain(JumpSourceToMain.ALBUM);
        let menuOperation
            = MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
        menuOperation.doAction();
    }

    onOperationStart() {
    }

    onOperationEnd() {
    }

    updateListCardWidth(): void {
        this.logger.info(`updateListCardWidth start ${this.screenColumns}`);
        if (this.screenColumns == ColumnSize.COLUMN_FOUR) {
            this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_FOUR);
        } else if (this.screenColumns == ColumnSize.COLUMN_EIGHT) {
            this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_SIX);
        } else if (this.screenColumns == ColumnSize.COLUMN_TWELVE) {
            this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
        } else {
            this.logger.error('screenColumns is not init');
        }
        this.logger.info(`updateListCardWidth ${this.listCardWidth}`);
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            this.albums && this.albums.onActive();
        }
    }

    onBackPress() {
        this.logger.info('onBackPress');
        router.back({
            uri: '',
            params: {}
        });
        return true;
    }

    private isLast(info: AlbumInfo) {
        let list = [];
        for (let i = 0; i < this.albums.totalCount(); i++) {
            let item = this.albums.getData(i);
            if (!AlbumDefine.ALBUM_DISABLE_COPY_LIST.has(item.innerId) && item.innerId != this.sourceAlbumId) {
                list.push(item);
            }
        }
        return list.length == 0 || list[list.length - 1].innerId == info.innerId;
    }

    onPageShow() {
        this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    }

    build() {
        Column() {
            MediaOperationActionBar({ onMenuClicked: this.onMenuClicked })
            List({ scroller: this.scroller }) {
                ListItem() {
                    List() {
                        LazyForEach(this.albums, (item: AlbumInfo, index) => {
                            ListItem() {
                                if (!AlbumDefine.ALBUM_DISABLE_COPY_LIST.has(item.id) && item.id != this.sourceAlbumId) {
                                    Column() {
                                        AlbumListCard({ item: item })
                                        if (!this.isLast(item)) {
                                            Divider().vertical(false).strokeWidth(1)
                                                .color($r('sys.color.ohos_id_color_list_separator'))
                                                .margin({ left: $r('app.float.album_list_card_divider_margin_left') })
                                        }
                                    }
                                }
                            }
                        }, item => item.id)
                    }
                    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
                    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
                    .padding({
                        left: $r('app.float.list_card_margin'),
                        right: $r('app.float.list_card_margin')
                    })
                }
            }
            .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
            .scrollBar(BarState.Auto)
            .padding({
                left: $r('app.float.list_card_margin'),
                right: $r('app.float.list_card_margin')
            })
            .width(this.listCardWidth)
            .margin({
                top: $r('app.float.album_let_page_padding_top'),
                left: $r('app.float.max_padding_start'),
                right: $r('app.float.max_padding_end'),
                bottom: this.leftBlank[3]
            })

            CustomDialogView()
        }
        .backgroundColor($r('app.color.default_background_color')) // ux: colorSubBackground
        .height('100%')
        .padding({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 1 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 1 })
            .opacity(0)
    }
}