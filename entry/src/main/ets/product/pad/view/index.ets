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

import { TimelinePage } from '../../../feature/timeline/view/TimelinePage';
import { AlbumSetPage } from '../../../feature/album/view/AlbumSetPage';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { TabBar, DEVICE_TYPE } from '../../../common/view/TabBar';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { Constants } from '../../../common/model/common/Constants';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import router from '@system.router';

// Application entry
@Entry
@Component
struct IndexPage {
    private TAG: string = 'IndexPage'
    private preIndex: number = Constants.TIMELINE_PAGE_INDEX;
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @Provide isShow: boolean = false;
    @Provide isSelectedMode: boolean = false;
    @Provide isAlbumSetSelectedMode: boolean = false;
    private currentIndex: number = this.preIndex;
    private tabsController: TabsController = new TabsController();
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private jumpSource: number;
    @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
    @StorageLink('permissionStatus') @Watch('onUpdate') permission: boolean = false;
    @State isUpdate: boolean = false;

    onUpdate() {
        this.isUpdate = !this.isUpdate;
    }

    aboutToAppear(): void {
        startTrace('indexPageAppearToShow');
        if (AppStorage.Get(Constants.BACK_FROM_FORM_DETAIL)) {
            AppStorage.SetOrCreate(Constants.BACK_FROM_FORM_DETAIL, false);
            this.currentIndex = Constants.ALBUM_PAGE_INDEX;
        }
        let param = router.getParams();
        Log.debug(this.TAG, `param: ${JSON.stringify(param)}`);
        if (param != null) {
            this.jumpSource = new Number(param.jumpSource).valueOf() || 0;
            if (this.jumpSource == JumpSourceToMain.CAMERA) {
                this.entryFromHap = Constants.ENTRY_FROM_NONE;
                this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
                Log.info(this.TAG, `Camera in, switch to Tab ${this.currentIndex}.`);
            }
        }
    }

    onPageShow() {
        Log.info(this.TAG, `IndexPage.onPageShow entryFromHap: ${this.entryFromHap}`);
        this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        this.isShow = true;
         Log.error(this.TAG, `IndexPage.onPageShow: router.clear ${this.jumpSource}`);
        if (this.jumpSource == JumpSourceToMain.CAMERA) {
            router.clear();
        } else if (this.jumpSource == JumpSourceToMain.ALBUM) {
            router.clear();
        }
        finishTrace('indexPageAppearToShow');
    }

    onPageHide() {
        this.isShow = false;
    }

    onBackPress() {
        let isProcessed = false;
        this.appBroadcast.emit(BroadcastConstants.BACK_PRESS_EVENT, [function(isModeChanged: boolean){
            isProcessed = isModeChanged;
        }.bind(this)]);
        return isProcessed;
    }

    // Reset the status of the removed tab. It is currently in the selection mode status (index is before switching)
    private resetTabState(index: number) {
        this.appBroadcast.emit(BroadcastConstants.RESET_STATE_EVENT, [index]);
    }

    // Tab page switching callback (index after switching)
    private onTabChanged(index: number) {
        this.currentIndex = index;
        this.preIndex = this.currentIndex;
        this.appBroadcast.emit(BroadcastConstants.ON_TAB_CHANGED, [index]);
    }

    build() {
        Column() {
            if (this.entryFromHap == Constants.ENTRY_FROM_NONE) {
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
                    this.resetTabState(this.currentIndex);
                    this.onTabChanged(index);
                    Log.info(this.TAG, `Switch to Tab ${this.currentIndex}.`);
                })
                .padding({ left: this.isSidebar ? $r('app.float.tab_bar_width') : 0 })

                TabBar({
                    currentIndex: this.currentIndex,
                    controller: this.tabsController,
                    deviceType: DEVICE_TYPE.DEVICE_PAD
                })
            }
        }
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
            top: px2vp(this.leftBlank[1]),
            bottom: px2vp(this.leftBlank[3])
        })
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 1 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 1 })
            .opacity(0)
    }
}