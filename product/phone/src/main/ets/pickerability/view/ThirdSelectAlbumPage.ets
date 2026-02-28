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

import lazy { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';
import lazy { ThirdSelectPhoneAlbumBase } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhoneAlbumBase';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { getScreen, isOrientationHorizontal, } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

let storage = LocalStorage.getShared();
/* instrument ignore file */
const TAG: string = 'ThirdSelectAlbumPage';

// Third Select Album Page
@Entry(storage)
@Component
export struct ThirdSelectAlbumPage {
  @State private pageStatus: boolean = false;
  @Provide broadCast: BroadCast = new BroadCast();
  public param: SelectParams = new SelectParams();
  // todo 疑问
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();

  public async aboutToAppear() {
    // 相册显示时的处理逻辑
    Log.info(TAG, 'ThirdSelectAlbumPageAboutToAppear');
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.param = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
      this.breakpointSystem.registerOrientationChange();
    } else {
      let params = tryGetRouterParam() as SelectParams;
      if (params) {
        this.param = params;
      }
    }
  }

  aboutToDisappear() {
    // 相册消息时的处理逻辑
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.breakpointSystem.unregisterOrientationChange();
    }
  }

  onPageShow() {
    Log.info(TAG, 'onPageShow');
    this.pageStatus = true;
  }

  onPageHide() {
    Log.info(TAG, 'onPageHide');
    this.pageStatus = false;
  }

  @Builder
  PickerContents() {
    ThirdSelectPhoneAlbumBase({
      // 后续根据需求拓展
      selectParams: this.param,
      pageStatus: this.pageStatus,
    })
      .animation({
        duration: Constants.PRESS_ANIM_DURATION * 100,
        curve: Curve.FastOutSlowIn,
      })
      .borderRadius(8)
      .margin({
        left: this.isHorizontal ? 0 : getScreen()
          .getLeftSafePadding($r('sys.float.ohos_id_card_margin_start'), false),
        right: this.isHorizontal ? 0 : getScreen()
          .getRightSafePadding($r('sys.float.ohos_id_card_margin_end'), false)
      })
      .visibility(Visibility.Visible)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.PickerContents();
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .id('modalRoot')
    .onAppear((): void => {
      Log.info(TAG, 'onRootAppear');
    })
    .onAreaChange((): void => {
      Log.info(TAG, 'onRootAreaChange');
    })
    .width('100%')
  }

  // TODO 疑问
  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
  }
}
