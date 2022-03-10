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
import {MediaOperationType} from '../../model/common/MediaOperationType'
import {MediaOperationActionBar} from './MediaOperationActionBar'
import {Logger} from '../../utils/Logger'
import {BroadCast} from "../../utils/BroadCast.ets"
import { AlbumSetNewMenuOperation } from '../../model/browser/operation/AlbumSetNewMenuOperation.ets';
import { MenuOperationFactory } from '../../model/browser/interface/MenuOperationFactory.ets';
import { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource.ets';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo.ets';
import { BroadCastConstants } from '../../model/common/BroadCastConstants.ets';
import { AlbumListCard } from './AlbumListCard.ets';
import router from '@system.router';
import { MenuContext } from '../../model/browser/operation/MenuContext.ets';
import { Action } from '../../model/browser/operation/Action.ets';
import {JumpSourceToMain} from '../../../common/model/browser/photo/JumpSourceToMain.ets'
import { CustomDialogView } from '../dialog/CustomDialogView.ets';
import { AlbumDefine } from '../../model/browser/AlbumDefine.ets';
import { ScreenManager, ColumnSize } from '../../model/common/ScreenManager.ets';

@Entry
@Component
struct MediaOperationPage {
    @StorageLink('screenColumns') screenColumns: number = ScreenManager.getInstance().getScreenColumns();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @Provide pageType: string = MediaOperationType.Move;
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide moreMenuList: Action[] = new Array<Action>();
    @State listCardWidth: number = 200;
    scroller: Scroller = new Scroller();
    albums: AlbumSetDataSource;
    isActive: boolean = false; // Whether the page is in the foreground
    logger: Logger = new Logger("MediaOperationPage");
    sourceAlbumName: string;

    private aboutToAppear(): void {
        let self = this;
        this.albums = new AlbumSetDataSource(this.broadCast);

        this.onActive();
        let param = router.getParams();
        if (param) {
            this.logger.info(`router getParams ${JSON.stringify(param)}`);
            this.pageType = param.pageType;
            this.sourceAlbumName = param.albumName;
        }
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.broadCast.on(BroadCastConstants.MEDIA_OPERATION, (albumName: string, completedFunc?: Function) => {
            router.back({
                uri: '',
                params:{
                    pageType: self.pageType,
                    albumName: albumName
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

    private onBackPress() {
        this.logger.info('onBackPress');
        router.back({
            uri: '',
            params: {}
        });
        return true;
    }

    build() {
        Column(){
            MediaOperationActionBar({onMenuClicked: this.onMenuClicked})

            List({scroller: this.scroller}){
                LazyForEach(this.albums, (item:AlbumInfo) => {
                    ListItem() {
                        if(!AlbumDefine.ALBUM_DISABLE_COPY_LIST.has(item.name) && item.name != this.sourceAlbumName) {
                            AlbumListCard({item: item})
                        }
                    }
                }, item => item.name)
            }
            .backgroundColor(Color.White)
            .borderRadius($r("sys.float.ohos_id_corner_radius_default_l"))
            .margin({
                top: $r("app.float.album_let_page_padding_top"),
                left : $r("app.float.max_padding_start"),
                right : $r("app.float.max_padding_end"),
            })
            .width(this.listCardWidth)

            CustomDialogView()
        }
        .height('100%')
        .backgroundColor($r('app.color.default_background_color'))
        .margin({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }
}