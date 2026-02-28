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
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy common from '@ohos.app.ability.common';
import lazy { Log } from '../../../default/utils/Log';
import lazy { DataStoreUtil } from '../../../default/utils/DataStoreUtil';
import lazy { OpenLinkOptions } from '@kit.AbilityKit';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { BundleInfoUtils } from '../../../default/utils/BundleInfoUtils';
import lazy { TipsJumpUtils } from '../../../default/utils/TipsJumpUtils';
import lazy volumemanager from '@ohos.file.volumeManager';
import lazy { SdCardDataViewUtils } from '../../../default/utils/SdCardDataViewUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../default/utils/ReportToBigDataUtil';
import lazy { SystemPropertiesManager } from '../../../default/utils/SystemPropertiesManager';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';

// instrument ignore file
const TAG: string = 'SdCardDataView';
const FUN_NAME: string = 'SF-20005894_f101';
const TYPE: string = '132';
const MODULE_NAME_PHONE: string = 'phone_widget';
const PC_FILE_MANAGER_BUNDLE_NAME: string = 'com.ohos.filemanager';
const PHONE_FILE_MANAGER_BUNDLE_NAME: string = 'com.ohos.files';

@Component
export struct SdCardDataView {
  @Prop isHaveMore: boolean;
  @Prop cardShowTitle: string | Resource = '';
  @Prop cardShowSubTitle: string | Resource = '';
  @Link uris: string[];
  @State isHover: boolean = false;
  @State isPressed: boolean = false;
  @State isIconHover: boolean = false;
  @State isIconPressed: boolean = false;
  @State isFocus: boolean = false;
  @State isOtherHover: boolean = false;
  @State isOtherPressed: boolean = false;
  private marginHorizontal: Resource = DeviceInfo.isPc() ?
  $r('app.float.moving_photo_popup_margin_pc') : $r('app.float.moving_photo_popup_margin_phone_horizontal');
  private marginVertical: Resource = DeviceInfo.isPc() ?
  $r('app.float.moving_photo_popup_margin_pc') : $r('app.float.moving_photo_popup_margin_phone_vertical');
  private borderRadiusInner: Resource = DeviceInfo.isPc() ?
  $r('sys.float.corner_radius_level2') : $r('sys.float.corner_radius_level6');

  private async onClickViewFileMoreManager(): Promise<void> {
    let bundleName: string = DeviceInfo.isPc() ? PC_FILE_MANAGER_BUNDLE_NAME : PHONE_FILE_MANAGER_BUNDLE_NAME;
    let appId: string = await BundleInfoUtils.getAppIdByBundleName(bundleName);
    if (appId === undefined || appId === '') {
      UiUtil.showToast($r('app.string.external_Disk_toast'));
      return;
    }
    let link: string = 'filemanager://openDirectory';
    let openLinkOptions: OpenLinkOptions = {};
    let context = getContext(this) as common.UIAbilityContext;
    context.openLink(link, openLinkOptions, (err, result) => {
    }).then(() => {
    })
    // 多设备打点
    const msg: Record<string, number | string | boolean> = {
      'isMoreStorage': true,
    };
    ReportToBigDataUtil.report(BigDataConstants.CLICK_VIEW_FILE_MANAGER, msg);
  }

  private async onClickViewFileManager(uri: string): Promise<void> {
    let bundleName: string = DeviceInfo.isPc() ? PC_FILE_MANAGER_BUNDLE_NAME : PHONE_FILE_MANAGER_BUNDLE_NAME;
    let appId: string = await BundleInfoUtils.getAppIdByBundleName(bundleName);
    if (appId === undefined || appId === '') {
      UiUtil.showToast($r('app.string.external_Disk_toast'));
      return;
    }
    if (uri) {
      let link: string = 'filemanager://openDirectory';
      let openLinkOptions: OpenLinkOptions = {
        parameters: {
          'fileUri': 'file://docs/storage/External/' + uri
        }
      };
      let context = getContext(this) as common.UIAbilityContext;
      context.openLink(link, openLinkOptions, (err, result) => {
      }).then(() => {
      })
      // 单设备打点
      const msg: Record<string, number | string | boolean> = {
        'isMoreStorage': false,
        'uri': uri
      };
      ReportToBigDataUtil.report(BigDataConstants.CLICK_VIEW_FILE_MANAGER, msg);
    }
  }

  private async onClickViewTips(): Promise<void> {
    this.jumpToTips();
  }

  private async onClickCloseTips(): Promise<void> {
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    if (this.isHaveMore) {
      this.uris.forEach(async (uri) => {
        await dataStore.putData(uri, true);
        await dataStore.flush();
      });
      this.uris.splice(0, this.uris.length);
    } else {
      await dataStore.putData(this.uris[0], true);
      await dataStore.flush();
      this.uris = this.uris.filter(item => item !== this.uris[0]);
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      getContext()?.eventHub.emit(BroadCastConstants.EXTERNAL_STORAGE_NOT_SHOW, '');
      AppStorage.setOrCreate('shouldShowPcSdCard', false);
    }
  }

  private getBackgroundColor(isPressed: boolean, isHover: boolean, isFocus: boolean): Resource | Color {
    if (isPressed) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  private jumpToTips(): void {
    let context: common.UIAbilityContext | undefined = getContext(this) as common.UIAbilityContext;
    if (context) {
      TipsJumpUtils.jumpTips(context, FUN_NAME, TYPE, MODULE_NAME_PHONE);
    } else {
      Log.error(TAG, 'jumpToTips: context is undefined');
    }
  }

  build() {
    Column() {
      Column() {
        Column() {
          Row() {
            Text(this.cardShowTitle)
              .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .textAlign(TextAlign.Start)
              .flexShrink(1)
              .margin({
                top: $r('app.float.image_grid_item_border_width'),
              })
            Column() {
              SymbolGlyph($r('sys.symbol.xmark'))
                .accessibilityText($r('app.string.disable'))
                .draggable(false)
                .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                .fontColor([$r('sys.color.ohos_id_color_text_secondary')])
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
          Text(this.cardShowSubTitle)
            .draggable(false)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .width(Constants.PERCENT_100)
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
          Text($r('app.string.go_to_check_out'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontSize($r('sys.float.ohos_id_text_size_button2'))
        }
        .groupDefaultFocus(DeviceInfo.isPc() ? true : false)
        .alignItems(HorizontalAlign.Start)
        .alignSelf(ItemAlign.Start)
        .backgroundColor(this.getBackgroundColor(this.isPressed, this.isHover, this.isFocus))
        .onClick(() => this.isHaveMore ? this.onClickViewFileMoreManager() : this.onClickViewFileManager(this.uris[0]))
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


        Column() {
          Text($r('app.string.highlight_learn_more'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontSize($r('sys.float.ohos_id_text_size_button2'))
        }
        .backgroundColor(this.getBackgroundColor(this.isOtherPressed, this.isOtherHover, this.isFocus))
        .onClick(() => this.onClickViewTips())
        .onHover((isHover: boolean, event: HoverEvent) => {
          this.isOtherHover = isHover;
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === 0) {
            this.isOtherPressed = true;
          } else if (event.type === 1) {
            this.isOtherPressed = false;
          }
        })
        .borderRadius(this.borderRadiusInner)
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
    .padding({
      top: DeviceInfo.isPc() ? $r('app.float.pc_card_view_padding') : undefined,
      left: DeviceInfo.isPc() ? $r('app.float.pc_card_view_padding') : undefined,
      bottom: DeviceInfo.isPc() ? $r('app.float.pc_card_view_padding') : undefined,
    })
    .alignItems(HorizontalAlign.Start)
    .borderRadius(DeviceInfo.isPc() ?
    $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }
}