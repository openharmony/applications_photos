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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Constants } from '../../default/model/common/Constants';
import lazy { ReportToBigDataUtil, BigDataConstants } from '../utils/ReportToBigDataUtil';
import lazy { CameraAuthLocationManager } from '../viewmodel/CameraAuthLocationManager';
import lazy { Constants as BrowserConstants } from '../../default/model/browser/photo/Constants';

/* instrument ignore file */

const TAG: string = 'CameraAuthLocationView';

export enum CameraAuthLocationFromEnum {
  TimeLine,
  Browser
}

@Component
export struct CameraAuthLocationCardView {
  private from: CameraAuthLocationFromEnum = CameraAuthLocationFromEnum.TimeLine;
  @State isHover: boolean = false;
  @State isPressed: boolean = false;
  @State isIconHover: boolean = false;
  @State isIconPressed: boolean = false;
  @State isFocus: boolean = false;
  @Link cameraAuthCardShow: boolean;
  @Link cameraAuthorizeDialogShow: boolean;
  private marginHorizontal: Resource = DeviceInfo.isPc() ?
  $r('app.float.moving_photo_popup_margin_pc') : $r('app.float.moving_photo_popup_margin_phone_horizontal');
  private marginVertical: Resource = DeviceInfo.isPc() ?
  $r('app.float.moving_photo_popup_margin_pc') : $r('app.float.moving_photo_popup_margin_phone_vertical');
  private borderRadiusInner: Resource = DeviceInfo.isPc() ?
  $r('sys.float.corner_radius_level2') : $r('sys.float.corner_radius_level6');
  private readonly DETAIL_MAX_SCALE: number = 1.45;
  private readonly TIMELINE_MAX_SCALE: number = 1.45;

  public hideCameraAuthCard: () => void = () => {
    this.getUIContext().animateTo({
      curve: Curve.Friction,
      duration: BrowserConstants.CLOUD_SYNC_CARD_SCALE_DURATION,
    }, () => {
      this.cameraAuthCardShow = false;
    });
  };



  aboutToAppear(): void {

  }

  aboutToDisappear(): void {

  }

  private getBackgroundColor(isPressed: boolean, isHover: boolean, isFocus: boolean): Resource | Color {
    if (isPressed) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  // 点击‘x'
  private async onClickCloseTips(): Promise<void> {
    // 照片页卡片关闭时增加动效
    if (this.from === CameraAuthLocationFromEnum.TimeLine) {
      animateToImmediately({
        duration: BrowserConstants.CLOUD_SYNC_CARD_SCALE_DURATION,
        curve: Curve.Friction,
        onFinish: (): void => {
          Log.info(TAG, `onClickCloseTips finish: ${this.cameraAuthCardShow}`);
        }
      }, () => {
        Log.info(TAG, `onClickCloseTips start:${this.cameraAuthCardShow}`);
        this.cameraAuthCardShow = false;
      })
    } else {
      this.cameraAuthCardShow = false;
    }
    CameraAuthLocationManager.setCancel(getContext(this), this.from);
    this.reportBigData('cancel');
    Log.info(TAG, `onClickCloseTips:${this.from} ${this.cameraAuthCardShow}`);
  }

  // 点击'允许'
  private async onClickAllow(): Promise<void> {
    Log.info(TAG, 'onClickAllow');
    this.cameraAuthorizeDialogShow = true;
    this.reportBigData('allow');
  }

  private reportBigData(click: string): void {
    let msg: Record<string, string | number> = {
      'fromPage': this.from,
      'clickButton': click
    };
    ReportToBigDataUtil.report(BigDataConstants.AUTH_CAMERA_LOCATION, msg);
  }

  build() {
    Column() {
      Column() {
        Column() {
          Row() {
            Text($r('app.string.auth_camera_location_title'))
              .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .textAlign(TextAlign.Start)
              .flexShrink(1)
              .maxFontScale(this.from === CameraAuthLocationFromEnum.Browser ? this.DETAIL_MAX_SCALE :
                this.TIMELINE_MAX_SCALE)
              .accessibilityLevel('yes')
              .margin({
                top: $r('app.float.image_grid_item_border_width'),
              })
            Column() {
              SymbolGlyph($r('sys.symbol.xmark'))
                .accessibilityText($r('app.string.disable'))
                .accessibilityLevel('yes')
                .draggable(false)
                .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                .fontColor([$r('sys.color.ohos_id_color_text_secondary')])
                .maxFontScale(this.from === CameraAuthLocationFromEnum.Browser ? this.DETAIL_MAX_SCALE :
                  this.TIMELINE_MAX_SCALE)
                .onClick(() => this.onClickCloseTips())
            }
            .backgroundColor(this.getBackgroundColor(this.isIconPressed, this.isIconHover, this.isFocus))
            .onHover((isIconHover: boolean, event: HoverEvent) => {
              this.isIconHover = isIconHover;
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === 0) {
                this.isIconPressed = true;
              } else if (event.type === 1) {
                this.isIconPressed = false;
              }
            })
            .borderRadius(this.borderRadiusInner)
            .margin({
              left: $r('app.float.tab_bar_text_size'),
            })
            .padding($r('app.float.image_grid_item_border_width'))
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Top)
          .width('100%')
        }
        .width('100%')
        .margin({
          bottom: DeviceInfo.isPc() ? $r('app.float.image_grid_item_border_width') :
          $r('app.float.album_card_border_width'),
        })

        Column() {
          Text(this.from === CameraAuthLocationFromEnum.TimeLine ? $r('app.string.auth_camera_location_gird') :
          $r('app.string.auth_camera_location_browser'))
            .draggable(false)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .maxFontScale(this.from === CameraAuthLocationFromEnum.Browser ? this.DETAIL_MAX_SCALE :
              this.TIMELINE_MAX_SCALE)
            .width(Constants.PERCENT_100)
            .accessibilityLevel('yes')
        }
        .padding({
          right: $r('app.float.image_grid_item_border_width'),
        })
      }
      .margin({
        bottom: DeviceInfo.isPc() ? $r('app.float.pc_card_view_text_margin_bottom') : undefined,
      })
      .padding({
        left: $r('app.float.tab_bar_text_padding_horizontal'),
        right: $r('app.float.tab_bar_text_size'),
        top: $r('app.float.map_protocol_margin_top'),
      })

      Flex() {
        Column() {
          Text($r('app.string.allow'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontSize($r('sys.float.ohos_id_text_size_button2'))
            .maxFontScale(this.from === CameraAuthLocationFromEnum.Browser ? this.DETAIL_MAX_SCALE :
              this.TIMELINE_MAX_SCALE)
        }
        .accessibilityLevel('yes')
        .groupDefaultFocus(DeviceInfo.isPc() ? true : false)
        .alignItems(HorizontalAlign.Start)
        .alignSelf(ItemAlign.Start)
        .backgroundColor(this.getBackgroundColor(this.isPressed, this.isHover, this.isFocus))
        .onClick(() => this.onClickAllow())
        .onHover((isHover: boolean, event: HoverEvent) => {
          this.isHover = isHover;
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === 0) {
            this.isPressed = true;
          } else if (event.type === 1) {
            this.isPressed = false;
          }
        })
        .borderRadius(this.borderRadiusInner)
        .margin({
          left: DeviceInfo.isPc() ? $r('app.float.actionBar_margin') : undefined,
          right: $r('app.float.tab_bar_text_padding_left'),
        })
        .padding({
          left: this.marginHorizontal,
          right: this.marginHorizontal,
          top: this.marginVertical,
          bottom: this.marginVertical,
        })
      }
      .margin({
        top: $r('app.float.list_item_inner_left_right_padding'),
        left: $r('app.float.list_item_right_icon1_margin_left'),
        bottom: $r('app.float.doodle_color_circle_radius'),
      })
    }
    .margin({
      top: '16vp',
      left: '16vp',
      right: '16vp',
      bottom: this.from === CameraAuthLocationFromEnum.TimeLine ? $r('app.float.cloud_card_margin') : 0,
    })
    .alignItems(HorizontalAlign.Start)
    .borderRadius(DeviceInfo.isPc() ?
    $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }
}

@Component
export struct CameraAuthorizeDialog {
  @Link cameraAuthCardShow: boolean;
  @Link cameraAuthorizeDialogShow: boolean;
  private from: CameraAuthLocationFromEnum = CameraAuthLocationFromEnum.TimeLine;
  build() {
    Column() {
      UIExtensionComponent(
        {
          bundleName : 'com.ohos.camera',
          abilityName: 'AuthorizeExtAbility',
          parameters: {
            'ability.want.params.uiExtensionType': 'sys/commonUI'
          }
        })
        .onAppear(() => {
          Log.info(TAG, 'UIExtensionComponent onAppear');
        })
        .onError((error) => {
          Log.error(TAG, `UIExtensionComponent onError code: ${error?.code}, message: ${error?.message}`);
        })
        .onReceive((data: Record<string, Object>) => {
          let isAllow: boolean = data?.cameraLocationPermission as boolean;
          Log.info(TAG, 'UIExtensionComponent onReceive ' + isAllow);
          CameraAuthLocationManager.setCancel(getContext(this), this.from);
          this.cameraAuthCardShow = false;
          this.cameraAuthorizeDialogShow = false;
        })
        .onTerminated((data) => {
          Log.info(TAG, 'UIExtensionComponent onTerminated');
        })
        .onDisAppear(() => {
          Log.info(TAG, 'UIExtensionComponent onDisAppear');
          this.cameraAuthorizeDialogShow = false;
        })
    }
    .width(0)
    .height(0)
    .accessibilityLevel('yes')
    .alignItems(HorizontalAlign.Center)
  }
}
