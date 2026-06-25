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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy common from '@ohos.app.ability.common';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { OpenLinkOptions } from '@kit.AbilityKit';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { BundleInfoUtils } from '@ohos/common/src/main/ets/default/utils/BundleInfoUtils';
import lazy { TipsJumpUtils } from '@ohos/common/src/main/ets/default/utils/TipsJumpUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy volumemanager from '@ohos.file.volumeManager';
import lazy { FixedIrregularViewVm } from '../../viewmodel/FixedIrregularViewVm';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { TRASH_HEIGHT } from '../../statemanager/constants/GridDefine';

// instrument ignore file
const TAG: string = 'SdCardDataView';
// 跳转玩机技巧对应功能页名称
const FUN_NAME: string = 'SF-20005894_f101';
// 跳转玩机技巧对应功能页类型
const TYPE: string = '132';
// 跳转PC玩机技巧对应功能页模块名
const MODULE_NAME_PC: string = 'pc_widget';
const PC_FILE_MANAGER_BUNDLE_NAME: string = 'com.ohos.filemanager';

@Component
export struct SdCardDataView {
  @State uris: string[] = [];
  @State cardShowTitle: string | Resource = '';
  @State cardShowSubTitle: string | Resource = '';
  @State isHover: boolean = false;
  @State isPressed: boolean = false;
  @State isIconHover: boolean = false;
  @State isIconPressed: boolean = false;
  @State isFocus: boolean = false;
  @State isOtherHover: boolean = false;
  @State isOtherPressed: boolean = false;
  @State isShowSdCard: boolean = false;
  @State viewModel: FixedIrregularViewVm = new FixedIrregularViewVm();

  private marginHorizontal: Resource = $r('app.float.moving_photo_popup_margin_pc');
  private marginVertical: Resource = $r('app.float.moving_photo_popup_margin_pc');
  private borderRadiusInner: Resource = $r('sys.float.corner_radius_level2');

  private async onClickViewFileManager(): Promise<void> {
    let appId: string = await BundleInfoUtils.getAppIdByBundleName(PC_FILE_MANAGER_BUNDLE_NAME);
    if (!appId) {
      UiUtil.showToast($r('app.string.external_Disk_toast'));
      return;
    }
    let path: string = '';
    const allVolumes: volumemanager.Volume[] = await volumemanager.getAllVolumes();
    /* instrument ignore next */
    if (allVolumes.length === 1) {
      if (allVolumes[0]?.path) {
        let pathList = allVolumes[0]?.path.split('/');
        path = pathList[pathList.length - 1];
      }
    }
    let link: string = 'filemanager://openDirectory';
    if (path) {
      let openLinkOptions: OpenLinkOptions = {
        parameters: {
          'fileUri': 'file://docs/storage/External/' + path
        }
      };
      let context = getContext(this) as common.UIAbilityContext;
      context.openLink(link, openLinkOptions, (err, result) => {
      }).then(() => {
      });
      // 单设备打点
      const msg: Record<string, number | string | boolean> = {
        'isMoreStorage': false,
        'uri': path,
      };
      ReportToBigDataUtil.report(BigDataConstants.CLICK_VIEW_FILE_MANAGER, msg);
    } else {
      let openLinkOptions: OpenLinkOptions = {};
      let context = getContext(this) as common.UIAbilityContext;
      context.openLink(link, openLinkOptions, (err, result) => {
      }).then(() => {
      });
      // 多设备打点
      const msg: Record<string, number | string | boolean> = {
        'isMoreStorage': true,
      };
      ReportToBigDataUtil.report(BigDataConstants.CLICK_VIEW_FILE_MANAGER, msg);
    }
  }

  private async onClickViewTips(): Promise<void> {
    this.jumpToTips();
  }

  private async onClickCloseTips(): Promise<void> {
    AppStorage.setOrCreate('shouldShowPcSdCard', false);
    getContext()?.eventHub.emit(BroadCastConstants.EXTERNAL_STORAGE_NOT_SHOW, '');
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
      TipsJumpUtils.jumpTips(context, FUN_NAME, TYPE, MODULE_NAME_PC);
    } else {
      Log.error(TAG, 'jumpToTips: context is undefined');
    }
  }

  build() {
    if (this.isShowSdCard) {
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
            bottom: $r('app.float.image_grid_item_border_width'),
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
          bottom: $r('app.float.pc_card_view_text_margin_bottom'),
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
          .groupDefaultFocus(true)
          .alignItems(HorizontalAlign.Start)
          .alignSelf(ItemAlign.Start)
          .backgroundColor(this.getBackgroundColor(this.isPressed, this.isHover, this.isFocus))
          .onClick(() => this.onClickViewFileManager())
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
            left: $r('app.float.actionBar_margin'),
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
      .onAreaChange(
        (oldVal: Area, newVal: Area) => {
          if (oldVal.height === newVal.height) {
            return;
          }
          animateTo({
            curve: Curve.Friction,
            duration: 300,
          }, () => {
            let newHeight: number = newVal.height as number + TRASH_HEIGHT;
            this.viewModel.updateMsgHeight(newHeight);
          });
        }
      )
      .padding({
        top: $r('app.float.pc_card_view_padding'),
        left: $r('app.float.pc_card_view_padding'),
        bottom: $r('app.float.pc_card_view_padding'),
      })
      .alignItems(HorizontalAlign.Start)
      .borderRadius($r('sys.float.corner_radius_level4'))
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .focusable(true)
      .focusScopeId('SdCard', true, false)
      .tabIndex(IndexFocusOrder.SD_CARD_VIEW)
    }
  }
}