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
import {Logger} from '../utils/Logger'
import {SelectUtil} from '../../../common/model/browser/photo/SelectUtil'
import {ImageGridItemComponent} from '../../../common/view/ImageGridItemComponent.ets'
import {Action} from '../../../common/model/browser/operation/Action.ets'
import {BroadCast} from '../../../common/utils/BroadCast'
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {Constants} from '../../../common/model/common/Constants.ets'
import {MediaDataSource} from '../../../common/model/browser/photo/MediaDataSource.ets'
import {PhotoDataImpl} from '../../../common/model/browser/photo/PhotoDataImpl.ets'
import {MediaItem} from '../../../common/model/browser/photo/MediaItem'
import {ThirdSelectManager} from '../../../common/model/browser/SelectManager.ets'
import {NoPhotoComponent} from '../../../common/view/NoPhotoComponent'
import {ScreenManager} from '../../../common/model/common/ScreenManager'
import {ThirdSelectedPageActionBar} from './ThirdSelectedPageActionBar'
import prompt from '@ohos.prompt'
import { GridScrollBar } from '../../../common/view/GridScrollBar.ets';

// Third Select Album Page
@Entry
@Component
export struct ThirdSelectPhotoGridPage {
    @Provide selectedCount: number = 0;
    @Provide('isSelectedMode') isMultiPick: boolean = false;
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    PhotoDataImpl: PhotoDataImpl;
    dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide isShow: boolean = true;
    logger: Logger = new Logger('ThirdSelectPhotoGridPage');
    selectManager: ThirdSelectManager;
    isActive = false;
    title: string;
    @State isEmpty: boolean = false;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    toastContext = '';
    DEFAULT_TOAST_DURATION = 2000;
    isFromWallpaper: boolean;
    @Provide maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
    @State gridRowCount: number = 0;
    @Provide isHideScrollBar: boolean = true;
    isFromFa: boolean = false;

    scroller: Scroller = new Scroller();

    onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
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
        let contentWidth = ScreenManager.getInstance().getWinWidth();
        let margin = 0;
        let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
        this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
        + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
        this.logger.info(`initGridRowCount contentWidth: ${contentWidth}`);
    }

    private aboutToAppear(): void {
        let param = router.getParams();
        if (param != null) {
            this.logger.info(`itemName: ${param.itemName}`);
            this.title = param.itemDisplayName;
            this.dataSource.setAlbumName(param.itemName);
            this.isMultiPick = param.isMultiPick;
            this.isFromFa = param.isFromFa;
            if (param.isFromWallpaper) {
                this.maxSelectCount = param.maxSelectCount;
            }
            this.logger.info(`ThirdSelectPhotoGridPage isMultiPick: ${this.isMultiPick},\
                isFromWallpaper: ${param.isFromWallpaper}, maxSelectCount: ${this.maxSelectCount}`);
        }
        if (this.isFromFa) {
            this.selectManager = new ThirdSelectManager();
            this.selectManager.setIsMultiPick(this.isMultiPick ? true : false);
            AppStorage.SetOrCreate(Constants.THIRD_SELECT_MANAGER, this.selectManager);
            AppStorage.SetOrCreate('from_form_photo_editor', true);
        } else {
            this.selectManager = AppStorage.Get(Constants.THIRD_SELECT_MANAGER);
            AppStorage.SetOrCreate('from_form_photo_editor', false);
        }
        this.initGridRowCount();

        let self = this;
        this.onMenuClicked = this.onMenuClicked.bind(this);
        this.dataSource.setBroadCast(this.broadCast);
        this.broadCast.on(BroadCastConstants.SELECT,
            (position: number, key: string, value: boolean, callback: Function) => {
                if (value && self.selectedCount >= self.maxSelectCount) {
                    prompt.showToast({
                        message: self.toastContext,
                        duration: self.DEFAULT_TOAST_DURATION,
                    });
                    return;
                }
                if (self.selectManager.toggle(key, value)) {
                    self.logger.info('enter event process');
                    callback();
                }
            });
        this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            (name: string, item: MediaItem) => {
                let targetIndex = self.dataSource.getDataIndex(item);
                self.logger.info(`jump to photo browser at index: ${targetIndex}, transition: ${name}`);
                AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
                router.push({
                    uri: 'feature/thirdSelect/view/ThirdSelectPhotoBrowser',
                    params: {
                        position: targetIndex,
                        transition: name,
                    }
                });
            })
        this.broadCast.on(Constants.ON_LOADING_FINISHED,
            (size: number) => {
                this.logger.info(`ON_LOADING_FINISHED size: ${size}`);
                this.isEmpty = size == 0;
                this.logger.info(`isEmpty: ${this.isEmpty}`)
            });
        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED,
            () => {
                this.logger.info('ON_DATA_RELOADED');
                this.dataSource.onDataReloaded();
            });
        this.selectManager.registerCallback('updateCount',
            (newState: number) => {
                self.logger.info(`updateSelectedCount ${newState}`);
                self.selectedCount = newState;
                self.selectManager.emitCallback('thirdSelectUpdateCount', [newState]);
            });
        this.dataSource.registerCallback('updateCount',
            (newState: number) => {
                self.logger.info(`updateTotalCount ${newState}`);
                self.isHideScrollBar = (newState <= 50);
                self.selectManager.setTotalCount(newState);
            })
        this.isActive = true;
    }

    private onPageShow() {
        this.isShow = true;
        this.onActive();
    }

    private onPageHide() {
        this.isShow = false;
        this.onInActive();
    }

    private onActive() {
        if (!this.isActive) {
            this.logger.info('onActive');
            this.isActive = true;
            this.dataSource && this.dataSource.onActive();
            if (this.isMultiPick) {
                this.dataSource.forceUpdate();
            }
        }
    }

    private onInActive() {
        if (this.isActive) {
            this.logger.info('onInActive');
            this.isActive = false;
            this.dataSource && this.dataSource.onInActive();
        }
    }

    private aboutToDisappear(): void {
        this.broadCast.off(null, null);
    }

    build() {
        Column() {
            ThirdSelectedPageActionBar({ leftAction: Action.BACK, isMultiPick: this.isMultiPick, title: this.title,
                onMenuClicked: this.onMenuClicked })
            if (this.isEmpty) {
                NoPhotoComponent({ title: $r('app.string.title_no_photos') })
            }
            Grid(this.scroller) {
                LazyForEach(this.dataSource, (item) => {
                    GridItem() {
                        ImageGridItemComponent({ item: item.mediaItem,
                            isSelected: this.selectManager.isItemSelected(item.mediaItem.uri),
                            pageName: Constants.PHOTO_TRANSITION_ALBUM,
                            isThird: true
                        })
                    }
                }, item => JSON.stringify(item))
            }
            .columnsTemplate('1fr '.repeat(this.gridRowCount))
                .columnsGap(Constants.GRID_GUTTER)
                .rowsGap(Constants.GRID_GUTTER)
                .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
                .layoutWeight(1)

            GridScrollBar({scroller: this.scroller});
        }
        .backgroundColor($r('app.color.default_background_color'))
            .margin({
                top: this.leftBlank[1],
                bottom: this.leftBlank[3]
            })
    }

    private setPickResult(): void {
        let uriArray = SelectUtil.getUriArray(this.selectManager.clickedSet)
        let abilityResult = {
            'resultCode': 0,
            'want': {
                'parameters': {
                    'select-item-list': uriArray
                }
            }
        };
        this.logger.info(`uri: ${uriArray}`)
        globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
            this.logger.info(`terminateSelfWithResult result: ${result}`);
        });
    }
}
