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
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Action } from '../../../common/view/browserOperation/Action'
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { PhotoBrowserActionBar } from './PhotoBrowserActionBar';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';

@Entry
@Component
struct VideoBrowser {
    private TAG: string = 'VideoBrowser';
    @Provide('dateTitle') photoDate: string = '';
    @Provide('timeLocationTitle') timeAndLocation: string = '';
    @Provide isShowBar: boolean = false;
    @Provide menuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    private broadCast: Broadcast = new Broadcast();
    private myVideoController: VideoController = new VideoController();
    private uri = '';
    private dateAdded = 0;
    private previewUri = null;

    onBackPress() {
        Log.info(this.TAG, 'onBackPress');
        router.back();
        return true;
    }

    private onMenuClicked(action: Action) {
        Log.info(this.TAG, `onMenuClicked, action: ${action.actionID}`);
        let menuOperation: MenuOperation;
        switch (action) {
            case Action.BACK:
                this.onBackPress();
                return;
            default:
                break;
        }
        menuOperation.doAction();
    }

    aboutToAppear() {
        startTrace('VideoBrowserAboutToAppear');
        let param = router.getParams();
        param.uri && (this.uri = param.uri.toString());
        this.dateAdded = new Number(param.dateAdded).valueOf() || 0;
        this.previewUri = param.previewUri;
        if (this.uri == undefined) {
            return;
        }
        Log.info(this.TAG, `uri is ${this.uri}`);
        this.photoDate = DateUtil.getLocalizedDate(this.dateAdded);
        this.timeAndLocation = DateUtil.getLocalizedTime(this.dateAdded);
        this.onMenuClicked = this.onMenuClicked.bind(this);
        screenManager.setSystemUi(false);
        finishTrace('VideoBrowserAboutToAppear');
    }

    aboutToDisappear(): void {
        this.myVideoController.stop();
        screenManager.setSystemUi(true);
    }

    onPageShow() {
        this.photoDate = DateUtil.getLocalizedDate(this.dateAdded);
        this.timeAndLocation = DateUtil.getLocalizedTime(this.dateAdded);
        broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Video({ src: this.uri, controller: this.myVideoController })
                .controls(this.isShowBar)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                    this.isShowBar = !this.isShowBar;
                })
                .onStart(() => {
                    screenManager.setKeepScreenOn();
                })
                .onPause(() => {
                })
                .onFinish(() => {
                    this.isShowBar = true;
                    screenManager.setKeepScreenOff();
                })
                .autoPlay(true)

            PhotoBrowserActionBar({
                onMenuClicked: this.onMenuClicked, isVideoPage: true
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.black'))
    }

    pageTransition() {
        PageTransitionEnter({ type: RouteType.None, duration: 0 })
            .opacity(0)
        PageTransitionExit({ type: RouteType.None, duration: 0 })
            .opacity(0)
    }
}

