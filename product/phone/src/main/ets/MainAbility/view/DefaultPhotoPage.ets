/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { getScreen, isOrientationHorizontal, } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy common from '@ohos.app.ability.common';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';

/* instrument ignore file */
const TAG: string = 'DefaultPhotoPage';

// Default Photo Page
@Entry(LocalStorage.getShared())
@Component
export struct DefaultPhotoPage {
  @Provide isPullingDown: boolean = false;
  @Provide isPullingUp: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide viewData: string = '';
  // 广播
  @State broadCast: BroadCast = new BroadCast();
  @Provide('transitionIndex') currentIndex: number = 0;
  @State private moreMenuList: Action[] = [];
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State private actionBarPaddingTop: number | Resource = 0;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State backgroundColorResource: Resource = $r('sys.color.background_secondary');
  @State isShowBar: boolean = true;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State isRunningAnimation: boolean = false;
  @Provide hidePopup: boolean = false;
  @StorageLink('isBigPhotoLeftToRightAnim') isLeftToRightAnim: boolean = false;
  @State isPullDownAndDragPhoto: boolean = false;
  @Provide albumsShow: boolean = false;
  // For AI text
  @State isDoingImageSlideAnimation: boolean = false;
  @State canRespondPanGesture: boolean = true;
  @State analyzerVisibility: Visibility = Visibility.Visible;
  @State canShowImageAnalyzer: boolean = false;
  @State isTappingAiButton: boolean = false;
  @State isTappingAiButtonChange: boolean = false;
  @State isMenuShow: boolean = false;
  @State isMenuShowStatusChange: boolean = false;
  @State hasSelectedText: boolean = false;
  @State isSelectedTextChange: boolean = false;
  @State isOnDragText: boolean = false;
  @State isInAnimateToPosition: boolean = false;
  @Provide isShowVideo: boolean = false;
  @State isScrolling: boolean = false;
  // swiper depth
  @State currentImageWidth: number = 0;
  @Provide disableSwipe: boolean = true;
  // delete
  @State currentDeleteID: string = '';
  @State videoCoverFrame: PixelMap[] = [];
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      this.backFun();
    }
  }

  private backFun(): void {

    const router: Router | undefined = AppStorage.get<Router>('router');
    Log.info(TAG, 'backFun: back to album main page');
    router?.replaceUrl({
      url: 'MainAbility/view/index',
      params: {
        jumpSource: JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER
      }
    });
  }

  aboutToAppear(): void {
    getScreen().updateSize();
    if (!this.isShowBar) {
      getScreen().setSystemUi(true);
    }
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    } else {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    }
    this.actionBarProp
      .setLeftAction(Action.BACK)
      .setMode(ActionBarMode.STANDARD_MODE);
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, (): void => {
      this.onToggleBars();
    });

    this.broadCast.on(PhotoConstants.HIDE_BARS, (): void => {
      this.hideBars();
    });
  }

  onPageShow() {
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
  }

  onPageHide() {
    Log.debug(TAG, '[onPageHide]');
  }

  onToggleBars(): void {
    if (this.isShowBar) {
      this.hideBars();
    } else {
      this.showBars();
    }
    Log.info(TAG, `Toggle bars, isShowBar: ${this.isShowBar}`);
  }

  showBars(): void {
    if (!this.isShowBar) {
      this.isShowBar = true;
      this.backgroundColorResource = $r('sys.color.background_secondary');
      getScreen().setSystemUi(true);
    }
  }

  hideBars(): void {
    if (this.isShowBar) {
      this.isShowBar = false;

      this.backgroundColorResource = $r('app.color.black');
      getScreen().setSystemUi(false);
    }
  }

  aboutToDisappear(): void {
    this.broadCast.off(undefined, undefined);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image('data:image/jpeg;base64,')
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100)
        .transition(
          TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END),
            TransitionEffect.move(TransitionEdge.START)))
        .onError((error: ImageError) => {
          console.log('YDEMO image error ' + error?.message);
        })
        .onAppear(() => {
          console.log('YDEMO image onAppear ');
        })
        .onComplete((status) => {
          console.log('YDEMO image onComplete ' + status);
        })
        .alt($r('app.media.form_default_bg'))
      Column() {
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          isNeedPlaceholder: false,
          isNavDestinationPageActionBar: true,
          moreMenuList: this.moreMenuList,
        })
      }
      .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
      .padding({
        top: this.actionBarPaddingTop,
      })
    }
    .backgroundColor(this.backgroundColorResource)
    .parallelGesture(
      GestureGroup(GestureMode.Exclusive,
        PanGesture(this.panOption)
          .onActionEnd((event: GestureEvent) => {
            if (event.offsetY > 0) {
              //下拉
              this.backFun();
            }
          }),
        TapGesture({
          count: 1,
        })
          .onAction((event: GestureEvent): void => {
            this.onToggleBars();
          })
      )
    )
  }
}
