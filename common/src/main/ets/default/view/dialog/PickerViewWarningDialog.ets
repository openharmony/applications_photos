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
import lazy data_preferences from '@ohos.data.preferences';
import lazy { Log } from '../../utils/Log';
import lazy { PickerUtil } from '../../utils/PickerUtil';
import lazy { Constants } from '../../model/common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { LengthUnit, LengthMetrics } from '@kit.ArkUI';
import lazy { SubWindowUtil } from '../../utils/SubWindowUtil';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { PickerColorMode } from '@ohos.file.PhotoPickerComponent';

export type Preferences = data_preferences.Preferences;

/* instrument ignore file */
const TAG: string = 'PickerViewWarningDialog';
const CONTENT_OTHER_WIDTH: number = DeviceInfo.isTv() ? 91 : 68;
const MAX_TEXT_SCALE: number = 2;
const PICKER_ICON_MARGIN_START: number = 12;

// 星盾icon
@Component
export struct IconSecurityShield {
  private iconDraggable: boolean = false;
  private fontSize: string | number | Resource = $r('app.float.picker_view_icon_font_size');
  build() {
    // 不做明暗模式适配，所以用不了系统色
    // SymbolGlyph($r('sys.symbol.security_shield'))
    //   .draggable(this.iconDraggable)
    //   .fontSize(this.fontSize)
    //   .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
    //   // 本地新增两个系统色亮色色值
    //   .fontColor([$r('app.color.icon_primary_light'), $r('app.color.icon_emphasize_light')])
  }
}

// 带图库图标的星盾icon
@Component
export struct SecurityShieldWithGalleryIcon {
  private isTv: boolean = false;
  private iconBorderColor: ResourceColor = $r('sys.color.ohos_id_color_button_normal');
  private imgBorderColor: ResourceColor = $r('sys.color.ohos_id_color_button_normal');

  build() {
    // Stack() {
    //   Stack() {
    //     IconSecurityShield({ fontSize: this.isTv ? 29 : $r('app.float.picker_view_icon_font_size') })
    //   }
    //   .height(this.isTv ? 43 : $r('app.float.picker_view_icon_height'))
    //   .width(this.isTv ? 43 : $r('app.float.picker_view_icon_width'))
    //   .backgroundColor('#FFFFFF')
    //   .opacity(0.9)
    //   .borderColor(this.iconBorderColor)
    //   .borderRadius(this.isTv ? 6 : $r('sys.float.ohos_id_corner_radius_default_s'))
    //   .borderWidth($r('app.float.picker_view_border_width'))
    //
    //   Image($r('app.media.img_gallery_icon'))
    //     .draggable(false)
    //     .objectFit(ImageFit.Cover)
    //     .height(this.isTv ? 19 : $r('app.float.picker_view_icon_galley_image_height'))
    //     .width(this.isTv ? 19 : $r('app.float.picker_view_icon_galley_image_width'))
    //     .borderColor(this.imgBorderColor)
    //     .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
    //     .borderWidth($r('app.float.picker_view_icon_galley_border_width'))
    //     .offset({
    //       x: this.isTv ? 12 : $r('app.float.picker_view_offset_x'),
    //       y: this.isTv ? 12 : $r('app.float.picker_view_offset_y'),
    //     });
    // }
    // .height(this.isTv ? 43 : $r('app.float.picker_view_icon_height'))
    // .width(this.isTv ? 43 : $r('app.float.picker_view_icon_width'))
  }
}

@Component
export struct PickerViewWarningDialog {
  public controller?: CustomDialogController;
  private appName: string = '';
  private isFromPickerView: boolean = false;
  private color: string = '';
  private emitHidePickerViewWarningDialog?: Function;
  private uiComponentColorMode: number = PickerColorMode.AUTO;
  @State private contentWidth: number = 0;
  @State showSheet: boolean = false;
  // @State sheetType: PickerType = PickerType.GALLERY_PICKER;
  //是否子窗picker模式
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  private isTv: boolean = DeviceInfo.isTv();

  aboutToAppear(): void {
    Log.info(TAG, `PickerViewWarningDialog open appName: ${this.appName}`)
  }

  private isBigPadding(): boolean {
    return DeviceInfo.isPc() || DeviceInfo.isFoldablePhone() || this.isTv;
  }

  private getPickerWarningIconColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_button_normal_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_button_normal_dark');
    } else {
      return $r('sys.color.ohos_id_color_button_normal');
    }
  }

  private getPickerWarningIconHoverColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_warning_icon_hover_color_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_warning_icon_hover_color_dark');
    } else {
      return $r('sys.color.ohos_id_color_hover');
    }
  }

  private getPickerWarningTitleFontColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_text_primary_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_text_primary_dark');
    } else {
      return $r('sys.color.ohos_id_color_text_primary');
    }
  }

  private getPickerWarningContentFontColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_text_secondary_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_text_secondary_dark');
    } else {
      return $r('sys.color.ohos_id_color_text_secondary');
    }
  }

  private getPickerWarningLearnMoreFontColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_warning_learn_more_font_color_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_warning_learn_more_font_color_dark');
    } else {
      return $r('sys.color.font_emphasize');
    }
  }

  private getWarningBackgroundColor(): ResourceColor {
    if (this.isFromPickerView && this.color != '') {
      if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
        return $r('app.color.picker_sub_background_color_light');
      } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
        return $r('app.color.picker_sub_background_color_dark');
      } else {
        return $r('sys.color.ohos_id_color_sub_background');
      }
    } else {
      if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
        return $r('app.color.search_background_color_light');
      } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
        return $r('app.color.search_background_color_dark');
      } else {
        return $r('sys.color.comp_background_tertiary');
      }
    }
  }

  private getPickerIconSecondaryColor(): ResourceColor {
    if (this.uiComponentColorMode === PickerColorMode.LIGHT) {
      return $r('app.color.picker_color_icon_secondary_light');
    } else if (this.uiComponentColorMode === PickerColorMode.DARK) {
      return $r('app.color.picker_color_icon_secondary_dark');
    } else {
      return $r('sys.color.icon_secondary');
    }
  }

  build() {
    // Row() {
    //   Row() {
    //     this.buildIconView();
    //     // this.buildContent();
    //     if (this.showSheet) {
    //       // PickerSheet({
    //       //   curPickerKey: this.sheetType,
    //       //   appIcon: $r('app.media.img_gallery_icon'),
    //       //   onClose: () => {
    //       //     this.showSheet = false;
    //       //   },
    //       // });
    //     }
    //   }
    //   .backgroundColor(this.getWarningBackgroundColor())
    //   .width('100%')
    //   .alignItems(VerticalAlign.Top)
    //   .borderRadius(this.isTv ? $r('sys.float.corner_radius_level6') :
    //     (this.isPickerUsedSubwindow ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10')))
    //   .borderWidth(this.isTv ? 0.5 : undefined)
    //   .borderColor(this.isTv ? $r('app.color.tv_detail_textinput_border_color') : undefined)
    //   .onAreaChange((oldValue: Area, newValue: Area) => {
    //     this.contentWidth = newValue.width as number - CONTENT_OTHER_WIDTH;
    //   })
    // }
    // .padding({
    //   right: this.isPickerUsedSubwindow ? 0 :
    //     (this.isBigPadding() ? $r('app.float.picker_view_dialog_padding_right_big_screen') :
    //     $r('app.float.picker_view_dialog_padding_right')),
    //   left: this.isPickerUsedSubwindow ? 0 :
    //     (this.isBigPadding() ? $r('app.float.picker_view_dialog_padding_left_big_screen') :
    //     $r('app.float.picker_view_dialog_padding_left')),
    //   bottom: this.isPickerUsedSubwindow ? 0 : $r('app.float.picker_view_dialog_padding_bottom'),
    // })
    // .width('100%')
  }

  // @Builder
  // buildIconView() {
  //   SecurityShieldWithGalleryIcon({
  //     isTv: this.isTv,
  //     iconBorderColor: this.getPickerWarningIconColor(),
  //     imgBorderColor: this.getPickerWarningIconHoverColor()
  //   })
  //   .margin({
  //     start: {
  //       value: this.isTv ? 16 : PICKER_ICON_MARGIN_START,
  //       unit: LengthUnit.VP,
  //     }, top: {
  //       value: this.isTv ? 16 : PICKER_ICON_MARGIN_START,
  //       unit: LengthUnit.VP,
  //     }
  //   })
  // }

  // @Builder
  // buildContent() {
  //   Column() {
  //     // this.buildTitle();
  //     /* instrument ignore next */
  //     if (this.isTv) {
  //       // this.buildContentTextForTv();
  //     } else {
  //       // this.buildContentText();
  //     }
  //   }
  //   .width(this.contentWidth)
  //   .alignItems(HorizontalAlign.Start)
  //   .margin(this.isTv ?
  //   $r('app.float.tv_picker_view_dialog_margin') : $r('app.float.picker_view_dialog_margin'))
  // }

  // @Builder
  // buildCancelButtonForTv() {
  //   Button({ type: ButtonType.Circle, stateEffect: true }) {
  //     SymbolGlyph($r('sys.symbol.xmark'))
  //       .fontSize(17)
  //       .fontColor([$r('sys.color.ohos_id_color_tertiary')])
  //   }
  //   .width(32)
  //   .height(32)
  //   .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
  //   .border({ width: 0.5, color: $r('app.color.tv_icon_button_border_color') })
  //   .onClick(async (): Promise<void> => {
  //     let key = this.isFromPickerView ? Constants.ACCESSING_PICKER_VIEW_APP_LIST :
  //     Constants.ACCESSING_PICKER_APP_LIST;
  //     Log.info(TAG, `in appName: ${this.appName} close picker warning dialog, key: ${key}`);
  //     await PickerUtil.insertAppList(this.appName, key);
  //     if (this.emitHidePickerViewWarningDialog) {
  //       this.emitHidePickerViewWarningDialog();
  //     }
  //   })
  // }

  // @Builder
  // buildTitle() {
  //   Row() {
  //     Text($r('app.string.picker_warning_title'))
  //       .fontColor(this.getPickerWarningTitleFontColor())
  //       .fontSize(this.isTv ? 24 : $r('sys.float.ohos_id_text_size_body1'))
  //       .fontFamily('HarmonyHeiTi')
  //       .fontWeight(FontWeight.Medium)
  //       .textAlign(TextAlign.Start)
  //       .maxFontScale(MAX_TEXT_SCALE)
  //
  //     /* instrument ignore next */
  //     if (this.isTv) {
  //       this.buildCancelButtonForTv();
  //     } else {
  //       SymbolGlyph($r('sys.symbol.xmark'))
  //         .accessibilityText($r('app.string.disable'))
  //         .draggable(false)
  //         .fontSize($r('app.float.picker_view_dialog_image_width'))
  //         .accessibilityRole(AccessibilityRoleType.BUTTON)
  //         .onClick(async (): Promise<void> => {
  //           let key = this.isFromPickerView ? Constants.ACCESSING_PICKER_VIEW_APP_LIST :
  //           Constants.ACCESSING_PICKER_APP_LIST;
  //           Log.info(TAG, `in appName: ${this.appName} close picker warning dialog, key: ${key}`);
  //           await PickerUtil.insertAppList(this.appName, key);
  //           if (this.emitHidePickerViewWarningDialog) {
  //             this.emitHidePickerViewWarningDialog();
  //           }
  //         })
  //         .fontColor([this.getPickerIconSecondaryColor()]);
  //     }
  //   }
  //   .width('100%')
  //   .justifyContent(FlexAlign.SpaceBetween)
  // }

  // @Builder
  // buildContentText() {
  //   Text() {
  //     Span($r('app.string.picker_warning_content_more', ''))
  //     Span($r('app.string.picker_view_learn_more_title'))
  //       .fontColor(this.getPickerWarningLearnMoreFontColor())
  //       .clickStyle()
  //   }
  //   .fontColor(this.getPickerWarningContentFontColor())
  //   .fontSize($r('sys.float.ohos_id_text_size_body2'))
  //   .fontFamily('HarmonyHeiTi')
  //   .fontWeight(FontWeight.Regular)
  //   .textAlign(TextAlign.Start)
  //   .maxFontScale(MAX_TEXT_SCALE)
  //   .margin({
  //     top: $r('app.float.picker_view_dialog_content_margin_top'),
  //   })
  // }

  // @Builder
  // buildContentTextForTv() {
  //   Text($r('app.string.picker_warning_content')) {
  //   }
  //   .fontColor($r('sys.color.font_secondary'))
  //   .fontSize(19)
  //   .fontFamily('HarmonyHeiTi')
  //   .fontWeight(FontWeight.Regular)
  //   .textAlign(TextAlign.Start)
  //   .maxFontScale(MAX_TEXT_SCALE)
  //   .lineHeight(24)
  //   .margin({
  //     end: LengthMetrics.resource($r('app.float.tv_picker_view_dialog_content_margin_right')),
  //     top: LengthMetrics.resource($r('app.float.tv_picker_view_dialog_content_margin_top')),
  //   })
  //
  //   Button() {
  //     Text($r('app.string.picker_view_learn_more_title'))
  //       .fontColor($r('sys.color.font_emphasize'))
  //       .fontSize($r('sys.float.Body_L'))
  //       .lineHeight(21)
  //       .fontWeight(FontWeight.Medium)
  //   }
  //   .width(94)
  //   .height(28)
  //   .backgroundColor(Color.Transparent)
  //   .borderRadius($r('sys.float.corner_radius_level10'))
  //   .margin({
  //     start: LengthMetrics.vp(-16),
  //     bottom: LengthMetrics.vp(-5),
  //   })
  //   .clickStyle()
  // }

  // @Styles
  // clickStyle() {
  //   .onClick((): void => {
  //     Log.i(TAG, 'start to create SubWindow.');
  //     let storage: LocalStorage = LocalStorage.getShared();
  //     let session: UIExtensionContentSession | undefined =
  //       storage.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
  //     console.log('1111111111',session)
  //     if (session) {
  //       let newStorage: LocalStorage = new LocalStorage();
  //       SubWindowUtil.createSubWindow(session, SubWindowUtil.PICKER_WARNING_SUB_WINDOW_NAME, newStorage,
  //         SubWindowUtil.PICKER_WARNING_SUB_WINDOW_PATH).then(() => {
  //         Log.i(TAG, 'createSubWindow success');
  //       }).catch((err: BusinessError) => {
  //         Log.e(TAG, `createSubWindow failed code ${err?.code} and message ${err?.message}`);
  //         this.showSheet = true;
  //       });
  //     }
  //   })
  // }
}