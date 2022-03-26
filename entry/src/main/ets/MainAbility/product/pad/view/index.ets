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

import {TimelinePage} from '../../../feature/timeline/view/TimelinePage.ets'
import {AlbumSetPage} from '../../../feature/browser/view/album/AlbumSetPage.ets'
import {Logger} from '../../../common/utils/Logger'
import {TabBar} from '../../../common/view/TabBar.ets'
import {TabItem} from '../../../common/model/common/TabItem.ets'
import {JumpSourceToMain} from '../../../common/model/browser/photo/JumpSourceToMain.ets'
import {BroadCast} from '../../../common/utils/BroadCast'
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../common/model/common/BroadCastManager'
import {Constants} from '../../../common/model/common/Constants'
import {ScreenManager} from '../../../common/model/common/ScreenManager'
import {TraceControllerUtils} from '../../../common/utils/TraceControllerUtils'
import router from '@system.router'

// Tab configuration, the photo page is selected by default
let tabs: TabItem[] = [
    new TabItem($r('app.string.tab_timeline'), $r('app.media.ic_photo'), $r('app.media.ic_photo_selected'), false),
    new TabItem($r('app.string.tab_albums'), $r('app.media.ic_album'), $r('app.media.ic_album_selected'), false)
];

// Application entry
@Entry
@Component
struct IndexPage {
    @StorageLink('app_key_tabs_index') preIndex: number = Constants.TIMELINE_PAGE_INDEX;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @Provide isShow: boolean = true;
    @Provide screenHeight: number = 0.0;
    @Provide screenWidth: number = 0.0;
    @Provide isSelectedMode: boolean = false;
    @Provide isAlbumSetSelectedMode: boolean = false;
    private currentIndex: number = this.preIndex;
    private tabsController: TabsController = new TabsController();
    private logger: Logger = new Logger('IndexPage');
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private jumpSource: number;
    @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
    @StorageLink('permissionStatus') @Watch('onUpdate') permission: boolean = false;
    @State isUpdate: boolean = false;

    onUpdate() {
        this.isUpdate = !this.isUpdate;
    }

    private aboutToAppear(): void {
        TraceControllerUtils.startTrace('indexPageAppearToShow');
        ScreenManager.getInstance().initWindowMode();
        let param = router.getParams();
        this.logger.info(`param: ${JSON.stringify(param)}`);
        if (param != null) {
            this.jumpSource = param.jumpSource;
            if (this.jumpSource == JumpSourceToMain.CAMERA) {
                this.entryFromHap = Constants.ENTRY_FROM_NONE;
                this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
                this.logger.info(`Camera in, switch to Tab ${this.currentIndex}.`);
            }
        }
    }

    private onPageShow() {
        this.logger.info(`IndexPage.onPageShow entryFromHap: ${this.entryFromHap}`);
        if (this.entryFromHap == Constants.ENTRY_FROM_CAMERA) {
            let options = {
                uri: 'feature/browser/view/photo/PhotoBrowser',
                params: {
                    pageFrom: Constants.ENTRY_FROM.CAMERA
                }
            };
            router.replace(options);
        } else if (this.entryFromHap == Constants.ENTRY_FROM_SINGLE_SELECT) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: false,
                }
            };
            router.replace(options);
        } else if (this.entryFromHap == Constants.ENTRY_FROM_MULTIPLE_SELECT) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: true,
                }
            };
            router.replace(options);
        }
        setTimeout(() => {
            this.isShow = true
        }, 50);
        this.logger.error(`IndexPage.onPageShow: router.clear ${this.jumpSource}`);
        if (this.jumpSource == JumpSourceToMain.CAMERA) {
            router.clear();
        } else if (this.jumpSource == JumpSourceToMain.ALBUM) {
            router.clear();
        }
        TraceControllerUtils.finishTrace('indexPageAppearToShow');
    }

    private onPageHide() {
        setTimeout(() => {
            this.isShow = false
        }, 50);
    }

    private onBackPress() {
        let isProcessed = false;
        this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT, [function(isModeChanged: boolean) {
            isProcessed = isModeChanged;
        }.bind(this)]);
        return isProcessed;
    }

    // Reset the status of the removed tab. It is currently in the selection mode status (index is before switching)
    private resetTabState(index: number) {
        this.appBroadCast.emit(BroadCastConstants.RESET_STATE_EVENT, [index]);
    }

    // Tab page switching callback (index after switching)
    private onTabChanged(index: number) {
        this.currentIndex = index;
        this.preIndex = this.currentIndex;
        this.appBroadCast.emit(BroadCastConstants.ON_TAB_CHANGED, [index]);
    }

    build() {
        Column() {
            if (this.permission && this.entryFromHap == Constants.ENTRY_FROM_NONE) {
                Row() {
                    TabBar({
                        currentIndex: this.currentIndex,
                        tabs: tabs,
                        controller: this.tabsController,
                        isSidebar: this.isSidebar
                    })

                    Tabs({
                        barPosition: BarPosition.Start,
                        index: this.currentIndex,
                        controller: this.tabsController
                    }) {

                        TabContent() {
                            TimelinePage()
                        }

                        TabContent() {
                            AlbumSetPage()
                        }

                    }
                    .animationDuration(0)
                        .vertical(true)
                        .scrollable(false)
                        .barMode(BarMode.Fixed)
                        .barWidth(0)
                        .barHeight(0)
                        .flexGrow(1)
                        .onChange((index: number) => {
                            this.resetTabState(this.currentIndex)
                            this.onTabChanged(index);
                            this.logger.info(`Switch to Tab ${this.currentIndex}.`)
                        })
                }
                .flexGrow(1)
            }
        }
        .backgroundColor($r('app.color.default_background_color'))
            .padding({
                top: this.leftBlank[1],
                bottom: this.leftBlank[3]
            })
    }

    pageTransition() {
        PageTransitionEnter({ duration: 300 })
            .opacity(1)
        PageTransitionExit({ duration: 300 })
            .opacity(1)
    }
}