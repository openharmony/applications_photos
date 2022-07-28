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
import { AlbumSelectGridItemNewStyle } from './AlbumSelectGridItemNewStyle'
import { AlbumSetDataSource } from '../../../../common/model/browser/album/AlbumSetDataSource'
import { Constants } from '../../../../common/model/common/Constants'
import { ScreenManager } from '../../../../common/model/common/ScreenManager'
import { BroadCast } from '../../../../common/utils/BroadCast'
import { NoPhotoComponent } from '../../../../common/view/NoPhotoComponent'
import { Logger } from '../../utils/Logger'
import { TraceControllerUtils } from '../../../../common/utils/TraceControllerUtils'
import { MediaDataSource } from '../../../../common/model/browser/photo/MediaDataSource'
import { NewAlbumPageActionBar } from './NewAlbumPageActionBar'
import { Action } from '../../../../common/view/browserOperation/Action'
import { SelectManager } from '../../../../common/model/browser/SelectManager'
import { UiUtil } from '../../utils/UiUtil'
import { AlbumDefine } from '../../../../common/model/browser/AlbumDefine';
import { AlbumInfo } from '../../../../common/model/browser/album/AlbumInfo';
import { BroadCastManager } from '../../../../common/model/common/BroadCastManager';
import { BroadCastConstants } from '../../../../common/model/common/BroadCastConstants';

@Entry
@Component
export struct AlbumSelect {
    @State isEmpty: boolean = false;
    @State gridColumnsCount: number = 0;
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide('selectedCount') totalSelectedCount: number = 0;
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @Provide moreMenuList: Action[] = new Array<Action>();
    private isActive = false;
    private logger: Logger = new Logger('AlbumSelect');
    private scroller: Scroller = new Scroller();
    private albums: AlbumSetDataSource;
    private dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
    private mSelectManager = new SelectManager();
    private albumInfo: AlbumInfo = undefined;

    aboutToAppear(): void {
        TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
        this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
            this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
            this.isEmpty = size == 0;
        });
        this.albums = new AlbumSetDataSource(this.broadCast);
        this.onActive();

        this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
        this.logger.info(`the grid count in a line is: ${this.gridColumnsCount}`);

        let param = router.getParams();
        if (param) {
            param.albumInfo && (this.albumInfo = JSON.parse(param.albumInfo.toString()));
            if (param.isNewAlbum) {
                AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM, true);
            } else {
                AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM, false);
            }
        }
        this.albums.setBlackList([this.albumInfo.id, AlbumDefine.ALBUM_ID_RECYCLE]);
        this.logger.debug(`the album Id is: ${this.albumInfo.id}`);
        this.onMenuClicked = this.onMenuClicked.bind(this);
        AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET, this.albumInfo);
        AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.mSelectManager);
        TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
    }

    aboutToDisappear(): void {
        this.albums.setBlackList([]);
    }

    onPageShow() {
        BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
        this.onActive();
    }

    onPageHide() {
        this.onInActive();
    }

    // Callback when the page is in the foreground
    onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            this.albums && this.albums.onActive();
            this.dataSource && this.dataSource.onActive();
            this.dataSource.forceUpdate();
        }
    }

    // Callback when the page is in the background
    onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.albums && this.albums.onInActive();
        }
    }

    private onMenuClicked(action: Action): void {
        this.logger.debug(`onMenuClicked, action: ${action.actionID}`);
        switch (action) {
            case Action.CANCEL:
                this.logger.info('clear SelectManager data');
                this.mSelectManager.onModeChange(false);
                AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
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
            NewAlbumPageActionBar({ onMenuClicked: this.onMenuClicked })

            Stack() {
                if (this.isEmpty) {
                    NoPhotoComponent({ title: $r('app.string.title_no_albums') })
                }
                Grid(this.scroller) {
                    LazyForEach(this.albums, (item) => {
                        if (this.albums.mediaSetList.indexOf(item) == 0) {
                            GridItem() {
                                AlbumSelectGridItemNewStyle({
                                    item: item,
                                    isBigCard: true,
                                    mSelectManager: this.mSelectManager
                                })
                            }.columnStart(0).columnEnd(1)
                        } else {
                            GridItem() {
                                AlbumSelectGridItemNewStyle({
                                    item: item,
                                    isBigCard: false,
                                    mSelectManager: this.mSelectManager
                                })
                            }
                        }
                    }, item => 'uri:' + item.id)
                }
                .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
                .padding({
                    left: $r('app.float.max_padding_start'),
                    right: $r('app.float.max_padding_end'),
                    top: $r('app.float.album_set_page_padding_top')
                })
                .columnsGap($r('app.float.album_set_grid_column_gap'))
                .rowsGap($r('app.float.album_set_grid_row_gap'))
            }
        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: this.leftBlank[1],
            bottom: this.leftBlank[3]
        })
    }
}
