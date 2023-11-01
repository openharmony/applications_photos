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

import { AlbumDefine, BigDataConstants, Constants, Log, ReportToBigDataUtil } from '@ohos/common';
import wantConstant from '@ohos.ability.wantConstant';
import { SelectParams } from '../utils/ThirdSelectConstants';
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

const TAG: string = 'thiSel_CameraGridItemComponent';

@Component
export struct CameraGridItemComponent {
  selectParams: SelectParams = SelectParams.defaultParam();
  resultUri: string = '';
  @Consume @Watch('onShow') isShow: boolean;
  updateDataFunc: Function = (): void => {};

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
  }

  build() {
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_primary'))
      .opacity($r('sys.float.ohos_id_alpha_inapptip_bg'))

      Column() {
        Image($r('app.media.ic_public_camera_grid_item'))
          .fillColor($r('sys.color.ohos_id_color_secondary'))
          .width($r('app.float.camera_icon_size'))
          .height($r('app.float.camera_icon_size'))
          .objectFit(ImageFit.Contain)
        Text(this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO
          ? $r('app.string.camera_btn_text_shooting')
          : $r('app.string.camera_btn_text_photo')
        )
          .fontSize($r('sys.float.ohos_id_text_size_body3'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontWeight(FontWeight.Regular)
          .margin({
            top: $r('app.float.photo_grid_gap')
          })
      }
      .key('PickerCamera')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .onClick((event?: ClickEvent) => {
        this.jumpCameraTakePhoto().then((result) => {
          Log.info(TAG, `resourceUri = ${JSON.stringify(result)}`);
          let want: Want | null = result.want as Want;
          if(want == null || want.parameters == null) return;
          this.resultUri = want.parameters['resourceUri'] as string;

          if (this.resultUri?.length > 0) {

            this.isShow = true;
            this.onShow();
          }
        }).catch((err: Error) => {
          Log.error(TAG, `jumpCameraTakephoto err: ${err}`);
        });
      })
    }
    .width('100%')
    .aspectRatio(1)
  }

  private onShow(): void {
    Log.info(TAG, `onShow: isShow=${this.isShow}, uri=${this.resultUri}`);
    if (this.isShow && this.resultUri?.length > 0) {
      if (this.selectParams.isMultiPick) {
        this.updateDataFunc && this.updateDataFunc(this.resultUri);
      } else {
        this.setPickResult(this.resultUri);
      }
    }
  }

  private async jumpCameraTakePhoto(): Promise<ability.AbilityResult> {
    let action = this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO
      ? wantConstant.Action.ACTION_VIDEO_CAPTURE
      : wantConstant.Action.ACTION_IMAGE_CAPTURE;
    let uri = this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO
      ? Constants.CAMERA_TYPE_VIDEO
      : Constants.CAMERA_TYPE_CAPTURE;
    interface Msg {
      action: wantConstant.Action
    }
    let msg: Msg = {
      action: action
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_CLICK_CAMERA_ID, msg);

    let supportMultiMode: boolean = (this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_ALL);
    let want: Want = {
      action: action,
      bundleName: Constants.CAMERA_BUNDLE_NAME,
      parameters: {
        uri: uri,
        supportMultiMode: supportMultiMode,
        callBundleName: this.selectParams.bundleName
      }
    };

    Log.debug(TAG, `jump camera want: ${JSON.stringify(want)}`);
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    let result = await context.startAbilityForResult(want);
    return result;
  }

  private setPickResult(uri: string): void {
    if (uri == null || uri == undefined) {
      Log.error(TAG, `no valid uri!`);
      return;
    }
    let abilityResult: ability.AbilityResult = {
      resultCode: (uri == null || uri.length <= 0) ? -1 : 0,
      want: {
        parameters: {
          'select-item-list': [uri],
        }
      }
    };
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
      Log.info(TAG, `terminateSelfWithResult abilityResult: ${abilityResult} result: ${result}`);
    });
  }
}
