/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import WantConstant from '@ohos.ability.wantConstant';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { Constants } from '../../../common/model/common/Constants';
import { GlobalContext } from '@ohos/base/src/main/ets/utils/GlobalContext';
import Want from '@ohos.application.Want';

const TAG = "CameraGridItemComponent"

// Camera entrance of the pick page
@Component
export struct CameraGridItemComponent {
  private globalThis = GlobalContext.getContext();

  bundleName: string = "";
  filterMediaType: number = MediaConstants.SELECT_TYPE_ALL;
  resultUri: string = "";
  @Consume @Watch('onShow') isShow: boolean;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
  }

  private onShow(): void {
    Log.info(TAG, 'onShow: isShow=' + this.isShow + ', uri=' + this.resultUri);
    if (this.isShow && this.resultUri?.length > 0) {
      this.setPickResult(this.resultUri);
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
  }

  build() {
    Column() {
      Image($r('app.media.ic_public_camera_grid_item'))
        .width($r('app.float.camera_icon_side'))
        .height($r('app.float.camera_icon_side'))
        .objectFit(ImageFit.Contain)
      Text($r("app.string.camera_btn_text_photo"))
        .fontSize($r('sys.float.ohos_id_text_size_body3'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('app.color.icon_secondary_color'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r("app.float.photo_grid_gap")
        })
    }
    .width("100%")
    .aspectRatio(1)
    .backgroundColor($r("app.color.recycle_album_bg_color"))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick((event: ClickEvent) => {
      this.jumpCameraTakephoto().then((result: common.AbilityResult) => {
        Log.info(TAG, 'resourceUri = ' + result?.want?.parameters?.resourceUri);
        this.resultUri = result?.want?.parameters?.resourceUri as string;
      }).catch((err) => {
        Log.error(TAG, 'jumpCameraTakephoto err: ' + err);
      });
    })
  }

  private async jumpCameraTakephoto(): Promise<common.AbilityResult> {
    // Currently, only photo pick is supported.
    let action = this.filterMediaType == MediaConstants.SELECT_TYPE_VIDEO
      ? WantConstant.Action.ACTION_IMAGE_CAPTURE
      : WantConstant.Action.ACTION_IMAGE_CAPTURE;
    let uri = this.filterMediaType == MediaConstants.SELECT_TYPE_VIDEO
      ? Constants.CAMERA_TYPE_CAPTURE
      : Constants.CAMERA_TYPE_CAPTURE;
    let want: Want = {
      action: action,
      bundleName: Constants.CAMERA_BUNDLE_NAME,
      abilityName: Constants.CAMERA_MAIN_ABILITY,
      parameters: {
        uri: uri,
        callBundleName: this.bundleName
      } as Object
    };
    Log.debug(TAG, 'jump camera want: ' + JSON.stringify(want));
    let appContext = this.globalThis.getObject("appContext") as common.UIAbilityContext;
    return await appContext.startAbilityForResult(want);
  }

  private setPickResult(uri: string): void {
    if (uri == null || uri == undefined) {
      Log.error(TAG, 'no valid uri!');
      return;
    }
    let param1: Map<string, string[]> = new Map();
    param1.set('select-item-list', [uri]);
    let abilityResult = {
        resultCode: 0,
        want: {
            parameters: Object.fromEntries(param1)
        } as Object
    };
    let appContext = this.globalThis.getObject("appContext") as common.UIAbilityContext;
    appContext.terminateSelfWithResult(abilityResult).then((result) => {
      Log.info(TAG, 'terminateSelf result: ' + result);
    });
  }
}
