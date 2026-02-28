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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import { BigDataConstants,
  BigDataMsg,
  ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { display, mediaquery } from '@kit.ArkUI';
import lazy { deviceInfo } from '@kit.BasicServicesKit';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Rsc } from '@ohos/tools/src/main/global/RscString';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';
import lazy { PickerCloseButton } from './PickerCloseButton';

const TAG: string = 'thiSel_ThirdSelectPhotoPrivacyBase';
const LIST_ITEM_TITLE_SIZE: number = 16;
const LIST_ITEM_TITLE_LIN_HEIGHT: number = 19;
const LIST_ITEM_DESCRIPTION_SIZE: number = 16;
const LIST_ITEM_DESCRIPTION_LIN_HEIGHT: number = 16;

class PrivacyOptionInfo {
  public title: Resource;
  public description: Resource;
  public privacyOption: PrivacyOption;

  constructor(title: Resource, description: Resource, privacyOption: PrivacyOption) {
    this.title = title;
    this.description = description;
    this.privacyOption = privacyOption;
  }
}

enum PrivacyOption {
  Location,
  Camera,
}

/* instrument ignore file */
@Component
export struct ThirdSelectPhotoPrivacyBase {
  @Prop totalSelectedCount: number = 0;
  // @State title: Resource = $r('app.string.source_privacy_options');
  @State isRemoveLocationInfo: boolean = false;
  @State isRemoveCameraInfo: boolean = false;
  @State leftButtonOpacity: number = 0;
  @State titleOpacity: number = 0;
  @State viewBarTranslateX: string = '100%';
  @State privacyOptionsBoxHeight: Resource = $r('app.float.phone_not_fold_privacy_options_box_height');
  private privacyOptionInfoList: Array<PrivacyOptionInfo> = [];
  public tokenId: number = 0;
  public bundleName: string = '';
  public changePrivacyOptionsText: Function | undefined;
  public photoBrowserBarAnimate: Function | undefined;
  private listener: mediaquery.MediaQueryListener = this.getUIContext()
    .getMediaQuery().matchMediaSync('(orientation: landscape)');
  private isLandscapeMode: boolean = false;
  private pickerController: ThirdSelectGridController = new ThirdSelectGridController();

  private updatePrivacyOptionsBoxHeight = (foldStatus: display.FoldStatus) => {
    let isFoldable: boolean = false;
    try {
      isFoldable = display.isFoldable();
    } catch (err) {
      Log.error(TAG, `updatePrivacyOptionsBoxHeight, get isFoldable error: ${err}, code: ${err?.code}`);
    }
    if (DeviceInfo.isPhone() && (!isFoldable || foldStatus === display.FoldStatus
      .FOLD_STATUS_FOLDED || foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED ||
      foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED)) {
      if (this.isLandscapeMode) {
        this.privacyOptionsBoxHeight = $r('app.float.phone_not_fold_privacy_options_box_landscape_height');
      } else {
        this.privacyOptionsBoxHeight = $r('app.float.phone_not_fold_privacy_options_box_height');
      }
    } else {
      this.privacyOptionsBoxHeight = $r('app.float.phone_fold_and_pad_privacy_options_box_height');
    }
    Log.info(TAG, `update privacy options box height: ${this.privacyOptionsBoxHeight}, devicetype: ${deviceInfo
      .deviceType}, isFoldable: ${isFoldable}, foldStatus: ${foldStatus}`);
  }

  private changePrivacyStatus() {
    let privacyStatus = photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE;
    if (this.isRemoveLocationInfo) {
      if (this.isRemoveCameraInfo) {
        privacyStatus = photoAccessHelper.HideSensitiveType.HIDE_LOCATION_AND_SHOOTING_PARAM;
      } else {
        privacyStatus = photoAccessHelper.HideSensitiveType.HIDE_LOCATION_ONLY;
      }
    } else if (this.isRemoveCameraInfo) {
      privacyStatus = photoAccessHelper.HideSensitiveType.HIDE_SHOOTING_PARAM_ONLY;
    }
    Log.info(TAG, `changePrivacyStatus: ${privacyStatus}`);
    PhotoAccessHelperAccess.thirdSelectPrivacyMap.set(this.tokenId, privacyStatus)
  }

  private doUpdatePrivacyOptionsBoxHeight() {
    try {
      this.updatePrivacyOptionsBoxHeight(display.getFoldStatus());
      if (display.isFoldable()) {
        display.on('foldStatusChange', this.updatePrivacyOptionsBoxHeight);
      }
    } catch (err) {
      Log.error(TAG, `getFoldStatus and register foldStatusChange callback: ${err}, code: ${err?.code}`);
    }
  }

  aboutToAppear(): void {
    let initPrivacyStatus = PhotoAccessHelperAccess.getPrivacyStatusByTokenId(this.tokenId);
    this.isRemoveLocationInfo = !(initPrivacyStatus & 2);
    this.isRemoveCameraInfo = !(initPrivacyStatus & 1);
    this.initPrivacyOptionInfoList();
    let msg: BigDataMsg = {
      'selectBundleName': this.bundleName,
      'removeLocationInfo': this.isRemoveLocationInfo,
      'removeCameraInfo': this.isRemoveCameraInfo,
    }
    ReportToBigDataUtil.report(BigDataConstants.PICKER_ENTER_PRIVACY_VIEW, msg);
    this.isLandscapeMode = this.listener.matches;
    this.doUpdatePrivacyOptionsBoxHeight();
    this.listener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      Log.info(TAG, `LandscapeMode change, matches: ${mediaQueryResult.matches}`);
      this.isLandscapeMode = mediaQueryResult.matches;
      this.doUpdatePrivacyOptionsBoxHeight();
    })
  }

  aboutToDisappear(): void {
    let msg: BigDataMsg = {
      'selectBundleName': this.bundleName,
      'removeLocationInfo': this.isRemoveLocationInfo,
      'removeCameraInfo': this.isRemoveCameraInfo,
    }
    ReportToBigDataUtil.report(BigDataConstants.PICKER_EXIT_PRIVACY_VIEW, msg);
    try {
      if (display.isFoldable()) {
        display.off('foldStatusChange', this.updatePrivacyOptionsBoxHeight);
      }
    } catch (err) {
      Log.error(TAG, `unregister foldStatusChange callback: ${err}, code: ${err?.code}`);
    }
    Log.info(TAG, 'aboutToDisappear, ThirdSelectPhotoPrivacyBase');
  }

  private initPrivacyOptionInfoList() {
    this.privacyOptionInfoList.push(new PrivacyOptionInfo($r('app.string.source_remove_location_info'),
      $r('app.string.source_tagged_geographic_data'), PrivacyOption.Location));
    this.privacyOptionInfoList.push(new PrivacyOptionInfo($r('app.string.source_remove_camera_info'),
      $r('app.string.source_device_and_camera_info'), PrivacyOption.Camera));
  }

  private getIsRemoveInfo(privacyOption: PrivacyOption): boolean {
    switch (privacyOption) {
      case PrivacyOption.Location :
        return this.isRemoveLocationInfo;
      case PrivacyOption.Camera :
        return this.isRemoveCameraInfo;
      default :
        return false;
    }
  }

  private setIsRemoveInfo(privacyOptionInfo: PrivacyOptionInfo, isRemove: boolean): void {
    Log.info(TAG, `getIsRemoveInfo, privacyOptionInfo: ${privacyOptionInfo}, isRemove: ${isRemove}`);
    switch (privacyOptionInfo.privacyOption) {
      case PrivacyOption.Location :
        this.isRemoveLocationInfo = isRemove;
        break;
      case PrivacyOption.Camera :
        this.isRemoveCameraInfo = isRemove;
        break;
      default :
        break;
    }
    let msg: BigDataMsg = {
      'selectBundleName': this.bundleName,
      'removeLocationInfo': this.isRemoveLocationInfo,
      'removeCameraInfo': this.isRemoveCameraInfo,
    }
    ReportToBigDataUtil.report(BigDataConstants.PICKER_PRIVACY_OPTION_CHANGE, msg);
    this.changePrivacyStatus();
  }

  build() {
    NavDestination(){
      Column(){
        this.privacyOptionsBuilder();
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .padding({top: $r('app.float.privacy_options_nav_margin_top')})
    .title({builder: this.privacyViewBarBuilder(), height: '60vp'})
    .backgroundColor($r('sys.color.background_secondary'))
    .onBackPressed(() => {
      this.photoBrowserBarAnimate?.(false);
      this.changePrivacyOptionsText?.();
      return false;
    })
  }

  @Builder
  privacyViewBarBuilder() {
    Stack(){
      Row(){
        // this.privacyTitleBuilder();
        this.rightButtonBuilder();
      }
      .height($r('app.float.title_default'))
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .margin({
      top: $r('app.float.privacy_options_bar_margin_top_bottom'),
      bottom: $r('app.float.privacy_options_bar_margin_top_bottom')
    })
  }

  @Builder
  rightButtonBuilder() {
    PickerCloseButton({
      pickerController: this.pickerController,
      componentHeight: $r('app.float.title_default'),
    })
  }

  // @Builder
  // privacyTitleBuilder() {
  //   Row() {
  //     Text(this.title)
  //       .fontSize(AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
  //       .fontWeight(AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT)
  //       .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
  //       .textOverflow({ overflow: TextOverflow.Ellipsis })
  //       .maxFontScale(1.0)
  //       .minFontScale(1.0)
  //       .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
  //       .key('SingleTitleText')
  //   }
  //   .padding({
  //     left: $r('app.float.privacy_options_bar_title_padding_left_right'),
  //     right: $r('app.float.privacy_options_bar_title_padding_left_right'),
  //   })
  //   .height($r('app.float.privacy_options_bar_title_height'))
  //   .alignItems(VerticalAlign.Center)
  //   .justifyContent(FlexAlign.Start)
  //   .flexGrow(1)
  // }

  @Builder
  privacyOptionsBuilder(): void {
    Stack({ alignContent: Alignment.Top }) {
      List() {
        ForEach(this.privacyOptionInfoList, (item: PrivacyOptionInfo) => {
          this.privacyOptionInfoItemBuilder(item);
        })
      }
      .backgroundColor($r('sys.color.comp_background_primary'))
      .width('100%')
      .divider({
        startMargin: $r('app.float.privacy_options_list_divider_margin'),
        endMargin: $r('app.float.privacy_options_list_divider_margin'),
        strokeWidth: $r('app.float.privacy_options_list_divider_stroke_width'),
      })
      .borderRadius($r('app.float.phone_and_pad_privacy_options_common'))
      .padding({
        top: $r('app.float.privacy_options_list_padding_top_bottom'),
        bottom: $r('app.float.privacy_options_list_padding_top_bottom'),
      })
    }
    .height(this.privacyOptionsBoxHeight)
    .margin($r('app.float.phone_and_pad_privacy_options_common'))
  }

  @Builder
  privacyOptionInfoItemBuilder(item: PrivacyOptionInfo): void {
    ListItem() {
      Row() {
        Column({space: $r('app.float.privacy_options_list_item_space')}) {
          Text(item.title)
            .fontSize(LIST_ITEM_TITLE_SIZE)
            .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
            .lineHeight(LIST_ITEM_TITLE_LIN_HEIGHT)
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .width('100%')
          Text(item.description)
            .fontColor(ActionBarProp.NORMAL_SUBTITLE_TEXT_COLOR)
            .fontSize(LIST_ITEM_DESCRIPTION_SIZE)
            .lineHeight(LIST_ITEM_DESCRIPTION_LIN_HEIGHT)
            .fontFamily('HarmonyHeiTi')
            .width('100%')
        }
        .width('70%')
        .padding({top: $r('app.float.list_item_padding'), bottom: $r('app.float.list_item_padding')})
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Toggle({type: ToggleType.Switch, isOn: this.getIsRemoveInfo(item.privacyOption)})
          .accessibilityText(item.title)
          .onChange((isRemove: boolean) => {
            this.setIsRemoveInfo(item, isRemove)
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({left: $r('app.float.list_item_padding'), right: $r('app.float.list_item_padding')})
    .borderColor($r('sys.color.comp_background_primary'))
  }
}