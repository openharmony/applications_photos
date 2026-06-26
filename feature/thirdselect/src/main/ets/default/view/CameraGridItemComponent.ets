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

import lazy ability from '@ohos.ability.ability';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy wantConstant from '@ohos.ability.wantConstant';
import lazy common from '@ohos.app.ability.common';
import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { BusinessError } from '@ohos.base';
import lazy { BUNDLE_NAMES } from '@ohos/tools/src/main/utils/Bundle';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { BundleInfoUtils } from '@ohos/common/src/main/ets/default/utils/BundleInfoUtils';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { ThirdSelectConstants } from '../utils/ThirdSelectConstants';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { PickerColorMode } from '@ohos.file.PhotoPickerComponent';

/* instrument ignore file */
const TAG: string = 'thiSel_CameraGridItemComponent';

@Component
export struct CameraGridItemComponent {
  selectParams: SelectParams = SelectParams.defaultParam();
  resultUri: string = '';
  @Consume @Watch('onShow') isShow: boolean;
  updateDataFunc: Function = (): void => {
  };
  @Link broadCast: BroadCast;
  private isForeground: boolean = true;
  private currentUri: string = '';
  @StorageLink('currentLanguage') currentLanguage: string | undefined = undefined;
  private jumpToCameraTakePhotoFun: Function = (isNeedEnter: boolean): void => {
    if (isNeedEnter) {
      this.jumpToCameraTakePhoto();
    }
  }
  private pickerOnForegroundFun: Function = (isOnForeground: boolean): void => {
    Log.info(TAG, `pickerOnForegroundFun: isOnForeground=${isOnForeground}`);
    this.isForeground = isOnForeground;
    if (this.isForeground && this.currentUri !== '') {
      this.setPickResult(this.currentUri);
      Log.info(TAG, `pickerOnForegroundFun: setPickResult=${this.currentUri}`);
    }
    this.currentUri = '';
  }
  @State private thirdSelectController: ThirdSelectGridController = new ThirdSelectGridController();

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.broadCast?.on(BroadCastConstants.JUMP_TO_CAMARA, this.jumpToCameraTakePhotoFun);
    let storage = LocalStorage.getShared();
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) &&
      !this.selectParams.isMultiPick && !this.selectParams.isFromPickerView) {
      getContext(this)?.eventHub?.on(Constants.PHOTO_PICKER_ON_FOREGROUND, this.pickerOnForegroundFun);
    }
    this.currentLanguage = i18n.System.getSystemLanguage();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast?.off(BroadCastConstants.JUMP_TO_CAMARA, this.jumpToCameraTakePhotoFun);
    let storage = LocalStorage.getShared();
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) &&
      !this.selectParams.isMultiPick && !this.selectParams.isFromPickerView) {
      getContext(this)?.eventHub?.off(Constants.PHOTO_PICKER_ON_FOREGROUND, this.pickerOnForegroundFun);
    }
  }

  private getPickerFontSecondaryColor(): ResourceColor {
    if (this.selectParams.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_font_secondary_light');
    } else if (this.selectParams.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_font_secondary_dark');
    } else {
      return $r('sys.color.font_secondary');
    }
  }

  private getPickerIconSecondaryColor(): ResourceColor {
    if (this.selectParams.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_icon_secondary_light');
    } else if (this.selectParams.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_icon_secondary_dark');
    } else {
      return $r('sys.color.icon_secondary');
    }
  }

  private getPickerCameraBackgroundColor(): ResourceColor {
    if (this.selectParams.isFromPickerView && this.selectParams.backgroundColor != '') {
      if (this.selectParams.uiComponentColorMode === PickerColorMode.LIGHT) {
        return $r('app.color.picker_sub_background_color_light');
      } else if (this.selectParams.uiComponentColorMode === PickerColorMode.DARK) {
        return $r('app.color.picker_sub_background_color_dark');
      } else {
        return $r('sys.color.ohos_id_color_sub_background');
      }
    } else if (DeviceInfo.isTv()) {
      if (this.selectParams.uiComponentColorMode === PickerColorMode.LIGHT) {
        return $r('app.color.picker_color_component_normal_light');
      } else if (this.selectParams.uiComponentColorMode === PickerColorMode.DARK) {
        return $r('app.color.picker_color_component_normal_dark');
      } else {
        return $r('sys.color.ohos_id_color_component_normal');
      }
    } else {
      if (this.selectParams.uiComponentColorMode === PickerColorMode.LIGHT) {
        return $r('app.color.picker_color_icon_primary_light');
      } else if (this.selectParams.uiComponentColorMode === PickerColorMode.DARK) {
        return $r('app.color.picker_color_icon_primary_dark');
      } else {
        return $r('sys.color.icon_primary');
      }
    }
  }

  build() {
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.getPickerCameraBackgroundColor())
      .opacity((this.selectParams.isFromPickerView && this.selectParams.backgroundColor != '') || DeviceInfo.isTv()
        ? 1
        : $r('sys.float.ohos_id_alpha_inapptip_bg'))

      Column() {
        SymbolGlyph($r('sys.symbol.camera_fill'))// ic_public_camera_grid_item
          .draggable(false)
          .fontColor([this.getPickerIconSecondaryColor()])
          .fontSize($r('app.float.camera_icon_size'))
        Text(this.selectParams.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO ?
        $r('app.string.camera_btn_text_shooting') : $r('app.string.camera_btn_text_photo')
        )
          .draggable(false)
          .fontSize(DeviceInfo.isTv() ?
            (this.currentLanguage?.includes('ug') ? $r('app.float.tv_picker_font_size_ug') :
            $r('app.float.tv_picker_font_size')) : $r('sys.float.ohos_id_text_size_body3'))
          .maxFontScale(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .textAlign(TextAlign.Center)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor(this.getPickerFontSecondaryColor())
          .fontWeight(FontWeight.Regular)
          .margin({
            top: $r('app.float.photo_grid_gap'),
          })
      }
      .key('PickerCamera')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .onClick((event: ClickEvent): void => {
      let storage = LocalStorage.getShared();
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      let isOnItemClickSet = storage?.get<boolean>('isOnItemClickedSet') ?? false;
      if (this.selectParams.isFromPickerView && isOnItemClickSet) {
        session?.sendData({ 'dataType': 'itemClick', 'itemType': 'camera' })
      } else {
        if (!this.selectParams.isMultiPick && !this.selectParams.isFromPickerView) {
          this.broadCast?.emit(Constants.UPDATE_PICKER_VISIBILITY, [true]);
        }
        this.jumpToCameraTakePhoto();
      }
    })
    .width('100%')
    .aspectRatio(1)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
  }

  private jumpToCameraTakePhoto(): void {
    this.jumpCameraTakePhoto().then((result: ability.AbilityResult) => {
      Log.info(TAG, `resourceUri = ${JSON.stringify(result)}`);
      let want: Want | null = result.want as Want;
      if (want == null || want.parameters == null) {
        return;
      }
      this.resultUri = want.parameters['resourceUri'] as string;
      if (this.resultUri?.length > 0) {
        this.isShow = true;
        this.onShow();
      } else {
        if (!this.selectParams.isMultiPick && !this.selectParams.isFromPickerView) {
          this.broadCast?.emit(Constants.UPDATE_PICKER_VISIBILITY, [false]);
        }
      }
    }).catch((err: BusinessError) => {
      Log.error(TAG, `jumpCameraTakephoto err: ${err}, code: ${err?.code}`);
    });
  }

  private onShow(): void {
    Log.info(TAG, `onShow: isShow=${this.isShow}, uri=${this.resultUri}`);
    if (this.isShow && this.resultUri?.length > 0) {
      if (this.selectParams.isMultiPick || this.selectParams.isFromPickerView) {
        this.updateDataFunc?.(this.resultUri);
      } else {
        let storage = LocalStorage.getShared();
        if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) && !this.isForeground) {
          this.currentUri = this.resultUri;
          Log.info(TAG, 'terminateSelf until back to foreground');
          return;
        }
        this.setPickResult(this.resultUri);
      }
    }
    this.resultUri = '';
  }

  private async jumpCameraTakePhoto(): Promise<ability.AbilityResult> {
    let action = this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO
      ? wantConstant.Action.ACTION_VIDEO_CAPTURE
      : wantConstant.Action.ACTION_IMAGE_CAPTURE;
    let uri = this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_VIDEO
      ? Constants.CAMERA_TYPE_VIDEO
      : Constants.CAMERA_TYPE_CAPTURE;

    interface Msg {
      action: wantConstant.Action,
      bundleName: string,
    }

    let msg: Msg = {
      action: action,
      bundleName: this.selectParams.bundleName,
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_CLICK_CAMERA_ID, msg);

    let supportMultiMode: boolean = (this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_ALL);
    let want: Want = {
      action: action,
      bundleName: BUNDLE_NAMES.camera,
      // 尝试不指定 abilityName 和 moduleName，使用隐式启动
      // abilityName: Constants.CAMERA_ABILITY_NAME,
      // moduleName: this.getDeviceCameraModuleName(),
      parameters: {
        uri: uri,
        supportMultiMode: supportMultiMode,
        callBundleName: this.selectParams.bundleName,
      }
    };

    Log.debug(TAG, `jump camera want: ${JSON.stringify(want)}`);
    let context: common.UIAbilityContext |
    undefined = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    let result = await context?.startAbilityForResult(want);
    Log.info(TAG, `jump camera resulr: ${JSON.stringify(result)}`);
    return result as ability.AbilityResult;
  }

  private getDeviceCameraModuleName() {
    return Constants.CAMERA_MODULE_NAME;
  }

  private setPickResult(uri: string): void {
    if (uri === null || uri === undefined) {
      Log.error(TAG, 'no valid uri!');
      return;
    }
    if (this.thirdSelectController.hasDelegate) {
      this.thirdSelectController.onCompletedWithUris([uri]);
    } else {
      this.thirdSelectController.onCancelled();
    }
  }
}