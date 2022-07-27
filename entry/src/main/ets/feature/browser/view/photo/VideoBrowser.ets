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
import {DateUtil} from '../../../../common/utils/DateUtil'
import {Logger} from '../../utils/Logger'
import {Action} from '../../../../common/view/browserOperation/Action'
import {MenuOperation} from '../../../../common/view/browserOperation/MenuOperation'
import {PhotoBrowserActionBar} from './PhotoBrowserActionBar'
import {BroadCast} from '../../../../common/utils/BroadCast'
import {ScreenManager} from '../../../../common/model/common/ScreenManager';
import {BroadCastManager} from '../../../../common/model/common/BroadCastManager';
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants';
import {TraceControllerUtils} from '../../../../common/utils/TraceControllerUtils';

@Entry
@Component
struct VideoBrowser {
    @Provide('dateTitle') photoDate: string = '';
    @Provide('timeLocationTitle') timeAndLocation: string = '';
    @Provide isShowBar: boolean = false;
    @Provide menuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    private broadCast: BroadCast = new BroadCast();
    private myVideoController: VideoController = new VideoController();
    private logger: Logger = new Logger('VideoBrowser');
    private uri = '';
    private dateTaken = 0;
    private previewUri = null;

    onBackPress() {
        this.logger.info('onBackPress');
        router.back();
        return true;
    }

    private onMenuClicked(action: Action) {
        this.logger.info(`onMenuClicked, action: ${action.actionID}`);
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
        TraceControllerUtils.startTrace('VideoBrowserAboutToAppear');
        let param = router.getParams();
        param.uri && (this.uri = param.uri.toString());
        this.dateTaken = new Number(param.dateTaken).valueOf() || 0;
        this.previewUri = param.previewUri;
        if (this.uri == undefined) {
            return;
        }
        this.logger.info(`uri is ${this.uri}`);
        this.photoDate = DateUtil.getLocalizedDate(this.dateTaken);
        this.timeAndLocation = DateUtil.getLocalizedTime(this.dateTaken);
        this.onMenuClicked = this.onMenuClicked.bind(this);
        ScreenManager.getInstance().setSystemUi(false);
        TraceControllerUtils.finishTrace('VideoBrowserAboutToAppear');
    }

    aboutToDisappear(): void {
        this.myVideoController.stop();
        ScreenManager.getInstance().setSystemUi(true);
    }

    onPageShow() {
        this.photoDate = DateUtil.getLocalizedDate(this.dateTaken);
        this.timeAndLocation = DateUtil.getLocalizedTime(this.dateTaken);
        BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Video({ src: this.uri, controller: this.myVideoController})
                .controls(this.isShowBar)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                    this.isShowBar = !this.isShowBar;
                })
                .onStart(() => {
                })
                .onPause(() => {
                })
                .onFinish(() => {
                    this.isShowBar = true;
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

