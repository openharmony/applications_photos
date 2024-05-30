/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import router from '@ohos.router';
import { MenuOperation } from '@ohos/common';
import {
  Action,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  DateUtil,
  Log,
  ScreenManager,
  TraceControllerUtils,
  UiUtil,
  WindowUtil
} from '@ohos/common';
import { PhotoBrowserActionBar } from '@ohos/browser/BrowserComponents';
import common from '@ohos.app.ability.common';

const TAG: string = 'VideoBrowser';

interface Params {
  uri: string;
  dateTaken: number;
  previewUri: string;
}

@Entry
@Component
struct VideoBrowser {
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide isShowBar: boolean = false;
  @Provide menuList: Action[] = [];
  @Provide moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;
  private broadCast: BroadCast = new BroadCast();
  private myVideoController: VideoController = new VideoController();
  private mVideoStatus: string = Constants.VIDEO_STATUS_INITIAL;
  private isNeedRecoveryStatus: boolean = false;
  private uri = '';
  private dateTaken = 0;
  private previewUri = '';

  onBackPress() {
    Log.info(TAG, 'onBackPress');
    router.back();
    return true;
  }

  aboutToAppear() {
    TraceControllerUtils.startTrace('VideoBrowserAboutToAppear');
    let param: Params = router.getParams() as Params;
    this.uri = param.uri;
    this.dateTaken = param.dateTaken;
    this.previewUri = param.previewUri;
    if (this.uri == undefined) {
      return;
    }
    Log.info(TAG, `uri is ${this.uri}`);
    if (this.previewUri) {
      Log.debug(TAG, `previewUri: ${JSON.stringify(this.previewUri)}`);
    } else {
      Log.debug(TAG, 'previewUri is null');
    }
    this.photoDate = DateUtil.getLocalizedDate(this.dateTaken);
    this.timeAndLocation = DateUtil.getLocalizedTime(this.dateTaken);
    TraceControllerUtils.finishTrace('VideoBrowserAboutToAppear');
  }

  aboutToDisappear(): void {
    this.myVideoController.stop();
  }

  onPageShow() {
    ScreenManager.getInstance().setSystemUi(false);
    this.photoDate = DateUtil.getLocalizedDate(this.dateTaken);
    this.timeAndLocation = DateUtil.getLocalizedTime(this.dateTaken);
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    if (this.mVideoStatus === Constants.VIDEO_STATUS_PAUSE && this.isNeedRecoveryStatus) {
      this.myVideoController.start();
      this.isNeedRecoveryStatus = false;
    }
  }

  onPageHide() {
    Log.info(TAG, 'onPageHide');
    if (this.mVideoStatus === Constants.VIDEO_STATUS_PLAYING) {
      this.isNeedRecoveryStatus = true;
      this.myVideoController.pause();
    }
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
          this.mVideoStatus = Constants.VIDEO_STATUS_PLAYING;
          WindowUtil.setWindowKeepScreenOn(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext, true);
        })
        .onPause(() => {
          this.mVideoStatus = Constants.VIDEO_STATUS_PAUSE;
          WindowUtil.setWindowKeepScreenOn(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext, false);
        })
        .onFinish(() => {
          this.mVideoStatus = Constants.VIDEO_STATUS_FINISH;
          this.isShowBar = true;
          WindowUtil.setWindowKeepScreenOn(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext, false);
        })
        .onError(() => {
          this.mVideoStatus = Constants.VIDEO_STATUS_ERROR;
          this.isShowBar = true;
          WindowUtil.setWindowKeepScreenOn(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext, false);
        })
        .autoPlay(true)

      PhotoBrowserActionBar({
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isVideoPage: true
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

  private onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    let menuOperation: MenuOperation;
    if (action.actionID === Action.BACK.actionID) {
      this.onBackPress();
    }
  }
}

