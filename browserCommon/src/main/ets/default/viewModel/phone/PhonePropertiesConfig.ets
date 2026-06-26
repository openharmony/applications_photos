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

import lazy { PropertiesConfig } from '../base/PropertiesConfig';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
/* instrument ignore file  */
export class PhonePropertiesConfig implements PropertiesConfig {
  public remarksHeight: Length = Constants.PHOTO_EDIT_PAGE_CARD_HEIGHT;
  public remarksMargin: Length | Padding | LocalizedPadding =
    { top: Constants.PHOTO_PROPERTIES_ROW_GAP, bottom: Constants.PHOTO_PROPERTIES_ROW_GAP };
  public remarksTextInputAttr: AttributeModifier<TextInputAttribute> = new RemarksAttr();
  public titleTextInputAttr: AttributeModifier<TextInputAttribute> = new TitleAttr();
  public titleMargin: Length | Padding | LocalizedPadding | undefined = undefined;
  public dateTimeAttr: AttributeModifier<TextAttribute> = new DateTimeAttr();
  public dividerMargin: Padding | Length | LocalizedPadding = { top: $r('sys.float.ohos_id_text_paragraph_margin_xs') };
  public photoSizeAttr: AttributeModifier<TextAttribute> = new FileSizeAttr();
  public photoSuffixFontSize: string | number | Resource = Constants.PHOTO_DETAIL_TEXT_INFO_SIZE;
  public photoSuffixPadding: Padding | Length | LocalizedPadding = Constants.PHOTO_DETAIL_IMAGE_INFO_PADDING;
  public photoInfoMargin: Padding | Length | LocalizedPadding =
    { top: $r('sys.float.ohos_id_text_paragraph_margin_xs') };
  public histogramMargin: Padding | Length | LocalizedPadding =
    { top: $r('sys.float.ohos_id_text_paragraph_margin_xs') };
  public histogramWidth: Length = Constants.PERCENT_100;
  public histogramHeight: Length = Constants.HISTOGRAM_HEIGHT;
  public photoInfoAttr: AttributeModifier<ColumnAttribute> = new PhotoInfoAttr();
  public propertiesMargin: Padding | Length | LocalizedPadding =
    { left: Constants.ENTRY_FROM_HIDDEN, right: Constants.ENTRY_FROM_HIDDEN };
}

class RemarksAttr implements AttributeModifier<TextInputAttribute> {
  applyNormalAttribute(instance: TextInputAttribute): void {
    let fontSizeScale = AppStorage.get<number>('fontSizeScale') ?? 0;
    let textInputFontSize: ResourceStr = $r('sys.float.Body_L');
    if (fontSizeScale >= Constants.FONT_SCALE_LEVEL3_SIZE) {
      textInputFontSize = `${Constants.FONT_SCALE_LEVEL3_SIZE * Constants.TEXT_SIZE_SUB_TITLE2}vp`;
    }

    instance.placeholderFont({ size: textInputFontSize, weight: 'Medium', family: 'HarmonyHeiTi' })
      .padding({
        right: Constants.PHOTO_DETAIL_NOTE_PADDING_UP,
        left: Constants.PHOTO_DETAIL_NOTE_PADDING_DOWN,
      })
      .constraintSize({ minHeight: Constants.PHOTO_DETAIL_NOTE_INPUT_MIN_HEIGHT })
      .fontSize(textInputFontSize)
      .borderRadius(Constants.COLUMN_RADIUS)
      .backgroundColor($r('sys.color.comp_background_tertiary'));
  }
}

class TitleAttr implements AttributeModifier<TextInputAttribute> {
  applyNormalAttribute(instance: TextInputAttribute): void {
    let fontSizeScale = AppStorage.get<number>('fontSizeScale') ?? 0;
    let textInputFontSize: ResourceStr = $r('sys.float.Body_L');
    if (fontSizeScale >= Constants.FONT_SCALE_LEVEL3_SIZE) {
      textInputFontSize = `${Constants.FONT_SCALE_LEVEL3_SIZE * Constants.TEXT_SIZE_SUB_TITLE2}vp`;
    }

    instance.height(Constants.PHOTO_TITLE_EDIT_HEIGHT)
      .fontSize(textInputFontSize)
      .fontColor($r('sys.color.font_primary'));
  }
}

class DateTimeAttr implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontSize($r('sys.float.Caption_M'));
  }
}

class FileSizeAttr implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontSize($r('sys.float.Caption_M')).fontColor($r('sys.color.ohos_id_color_text_tertiary'));
  }
}

class PhotoInfoAttr implements AttributeModifier<ColumnAttribute> {
  applyNormalAttribute(instance: ColumnAttribute): void {
    instance.padding({
      top: Constants.COLUMN_PADDING_TOP,
      left: Constants.COLUMN_PADDING_LEFT,
      right: Constants.COLUMN_PADDING_RIGHT,
      bottom: Constants.COLUMN_PADDING_BOTTOM,
    }).backgroundColor($r('sys.color.comp_background_list_card'));
  }
}