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
import {Action} from '../../../../common/model/browser/operation/Action.ets'
import {MenuOperation} from '../../../../common/model/browser/operation/MenuOperation'
import {PhotoBrowserActionBar} from './PhotoBrowserActionBar'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager.ets';
import {Constants} from '../../../../common/model/common/Constants.ets';

@Entry
@Component
struct VideoBrowser {
    @Provide(dateTitle) photoDate: string = '';
    @Provide(timeLocationTitle) timeAndLocation: string = '';
    @Provide isShowBar: boolean = false;
    @Provide menuList: Array<Action> = new Array<Action>();
    @Provide moreMenuList: Array<Action> = new Array<Action>();
    private broadCast: BroadCast = new BroadCast();
    private myVideoController: VideoController = new VideoController();
    private logger: Logger = new Logger('VideoBrowser');
    private uri = '';
    private dateTaken = 0;
    private previewUri = null;

    private onBackPress() {
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
        let param = router.getParams();
        this.uri = param.uri;
        this.dateTaken = param.dateTaken;
        this.previewUri = param.previewUri;
        if (this.uri == undefined) {
            return;
        }
        this.logger.info(`uri is ${this.uri}`);
        if (this.previewUri) {
            this.logger.debug(`previewUri: ${JSON.stringify(this.previewUri)}`);
        } else {
            this.logger.debug('previewUri is null');
        }
        this.photoDate = DateUtil.getLocalizedDate(this.dateTaken);
        this.timeAndLocation = DateUtil.getLocalizedTime(this.dateTaken);
        this.onMenuClicked = this.onMenuClicked.bind(this);
        ScreenManager.getInstance().setSystemUi(false);
    }

    private aboutToDisappear(): void {
        ScreenManager.getInstance().setSystemUi(true);
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Video({ src: this.uri, controller: this.myVideoController, previewUri: this.previewUri })
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
                .margin({
                    bottom: Constants.ActionBarHeight
                })

            PhotoBrowserActionBar({
                onMenuClicked: this.onMenuClicked, isVideoPage: true
            })
        }
        .width('100%')
            .height('100%')
            .backgroundColor($r('app.color.black'))
    }
}

