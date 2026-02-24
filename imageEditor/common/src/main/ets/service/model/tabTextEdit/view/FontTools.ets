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

import { HiLog } from '../../../../common/util/HiLog';
import { deepCopy, TextAreaInfo } from '../model/TextAreaInfo';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';
import { Operation } from '../model/Operation';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { Constants } from '../util/Const';
import { FontColorManager, UiFontColor } from '../util/FontColor';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ResourceButtonItem } from '../../../../feature/basic/common/view/SelectableProgressButton';
import { LengthUnit, SymbolGlyphModifier } from '@kit.ArkUI';
import { i18n } from '@kit.LocalizationKit';
import { UiUtil } from '../../../../common/util/UiUtil';
import { SCREEN_ORIENTATION_PORTRAIT } from '../../../../common/const';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { AccessibilityManager } from '../../../../common/util/AccessibilityManager';

const TAG = 'FontTools';
const FONT_SIZE_SLIDE_STEP = 2.4;

@Styles
function circleSmall() {
  .position({
    x: 6,
    y: 6,
  })
  .width(12)
  .height(12)
}

@Styles
function circleMiddle() {
  .position({
    x: 2,
    y: 2,
  })
  .width(20)
  .height(20)
}

@Styles
function circleBig() {
  .width(24)
  .height(24)
}

@Extend(Menu)
function styleMenuStyle() {
  .menuItemDivider({
    color: $r('sys.color.ohos_id_color_list_separator'),
    strokeWidth: { value: 1, unit: LengthUnit.PX },
  })
  .width(224)
}

@Component
export struct FontSizeTool {
  @Prop textArea: TextAreaInfo;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  textAreaManager: TextAreaManager = TextAreaManager.getInstance();

  build() {
    Row() {
      Text('Aa')
        .fontSize(`${13}vp`)
        .fontColor($r('sys.color.icon_primary'))
        .fontFamily(Constants.DEFAULT_TEXTAREA_FONT_FAMILY)
        .fontWeight(FontWeight.Regular)
        .opacity($r('sys.float.ohos_id_alpha_content_primary'))
        .accessibilityText("缩小字体大小")

      Slider({
        value: this.textArea === undefined ? 4 : this.textArea.fontSize * 10,
        min: Constants.MIN_FONT_SIZE * 10,
        max: Constants.MAX_FONT_SIZE * 10,
        step: FONT_SIZE_SLIDE_STEP * 10,
        style: SliderStyle.InSet,
        direction: Axis.Horizontal,
        reverse: false,
      })
        .layoutWeight(1)
        .showTips(false)
        .padding({ left: 6, right: 6 })
        .onChange((value: number, mode: SliderChangeMode) => {
          // 滑动条跨度小时容易出现小数点位置误判，将所有value扩大10倍
          if (mode === SliderChangeMode.Begin || mode === SliderChangeMode.End) {
            return;
          }
          // 十倍数值发出消息，消息接收端对值除10处理
          this.currentFontSize = value / 10;
          this.textAreaManager.getTextAreaList().forEach(textArea => {
            if (textArea.editState === Constants.ONFOCUS) {
              HiLog.i(TAG, 'FontColorTool textArea.editState: %{public}s', textArea.id);
              textArea.fontSize = this.currentFontSize;
              this.isFontSizeChange = !this.isFontSizeChange;
            }
          })
        })
        .onTouch((event) => {
          if (!event) {
            return;
          }
          if (event.type == TouchType.Up) {
            HiLog.i(TAG, 'select size finished');
            this.textAreaManager.getTextAreaList().forEach(textArea => {
              if (textArea.editState === Constants.ONFOCUS) {
                HiLog.i(TAG, 'FontColorTool textArea.editState: %{public}s', textArea.id);
                // 等待LayoutManager布局完成后获取最新的布局信息
                setTimeout(() => {
                  this.isFontSizeChange = !this.isFontSizeChange;
                }, 10);
              }
            })
            let msg: Record<string, number | string | boolean> = {
              'FONT_SIZE': this.currentFontSize
            };
          }
        })

      Text('Aa')
        .fontSize(`${22}vp`)
        .fontColor($r('sys.color.icon_primary'))
        .fontFamily(Constants.DEFAULT_TEXTAREA_FONT_FAMILY)
        .fontWeight(FontWeight.Regular)
        .opacity($r('sys.float.ohos_id_alpha_content_primary'))
        .maxFontSize(1.75)
        .accessibilityText("放大字体大小")
    }
    .width('100%')
    .height('100%')
  }
}

@Component
export struct FontColorTool {
  private fontColorManager = FontColorManager.getInstance();
  @Prop textArea: TextAreaInfo;
  @Link currentFontColor: Color | string | Resource;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @StorageProp('currentColorMode') private currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = AccessibilityManager.getInstance()
    .getIsAccessibilityMode();
  undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  textAreaManager: TextAreaManager = TextAreaManager.getInstance();

  aboutToAppear(): void {
    if (!this.textArea) {
      this.textAreaManager.getTextAreaList().forEach(textArea => {
        if (textArea.editState === Constants.ONFOCUS) {
          HiLog.i(TAG, 'FontColorTool textArea.id: %{public}s', textArea.id);
          this.textArea = textArea;
        }
      })
    }
  }

  // instrument ignore next
  aboutToDisappear(): void {
    HiLog.i(TAG, 'FontColorTool aboutToDisappear with textArea.id: %{public}s', this.textArea?.id ?? 'no textarea');
  }

  /**
   * 根据字体颜色色值获取对应的颜色Name
   *
   * @param fontColor 字体颜色色值
   * @returns 颜色Name
   */
  /* instrument ignore next */
  public getFontColorName(fontColor: string): Resource {
    switch (fontColor) {
      case UiFontColor.WHITE:
        return $r('app.string.color_white_imageEdit');
      case UiFontColor.RED_DARK_OPAQUE:
        return $r('app.string.color_red_imageEdit');
      case UiFontColor.YELLOW_DARK_OPAQUE:
        return $r('app.string.yellow_imageEdit');
      case UiFontColor.GREEN_YELLOW_DARK_OPAQUE:
        return $r('app.string.color_green_imageEdit');
      case UiFontColor.INDIGO_OPAQUE:
        return $r('app.string.color_light_blue_imageEdit');
      case UiFontColor.BLUE_OPAQUE:
        return $r('app.string.color_dark_blue_imageEdit');
      case UiFontColor.MAROON_OPAQUE:
        return $r('app.string.color_light_purple_imageEdit');
      default:
        return $r('app.string.color_black_imageEdit');
    }
  }

  @Builder
  singleFontColor(fontColor: string, index: number) {
    Row() {
      if ((this.textArea === undefined ? UiFontColor.WHITE : this.textArea.fontColor) === fontColor) {
        Circle()
          .fill(fontColor)
          .circleBig()

        Circle()
          .fill(this.currentMode === 1 ? '#E8E8E8' : '#2F3034')
          .stroke(Color.Transparent)
          .circleSmall()
      } else {
        Circle()
          .fill(fontColor)
          .circleMiddle()
      }
    }
    .id(`styles_font_color_${index}`)
    .accessibilityGroup(true)
    .accessibilityText(UiUtil.getResourceString(this.getFontColorName(fontColor)) +
    UiUtil.getResourceString((this.textArea === undefined ? UiFontColor.WHITE : this.textArea.fontColor) === fontColor ?
      $r('app.string.selected_imageEdit') : null))
    .height(24)
    .width(24)
    .responseRegion(this.isAccessibilityMode ? { width: '100%', height: '100%' } : { width: '150%', height: '150%' })
    .onClick((): void => {
      this.currentFontColor = '';
      HiLog.i(TAG, `FontColorTool currentFontColor:${this.currentFontColor}`);
      this.textAreaManager.getTextAreaList().forEach(textArea => {
        if (textArea.editState === Constants.ONFOCUS) {
          HiLog.i(TAG, 'FontColorTool textArea.id: %{public}s', textArea.id);
          this.textArea = textArea;
          textArea.fontColor = fontColor;
        }
      })
      this.currentFontColor = fontColor;
      let msg: Record<string, number | string | boolean> = {
        'FONT_COLOR': this.currentFontColor
      };
      let accessibilityManager = AccessibilityManager.getInstance();
      if (accessibilityManager.getIsAccessibilityMode()) {
        accessibilityManager.sendAnnounceAccessibilityEvent(UiUtil.getResourceString($r('app.string.selected_imageEdit')));
      }
    })
  }

  build() {
    Row() {
      ForEach(this.fontColorManager.fontColorList, (fontColor: string, index: number) => {
        this.singleFontColor(fontColor, index);
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@Component
export struct FontStyleTool {
  @Link textArea: TextAreaInfo;
  @Link currentFontColor: Color | string | Resource;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @State currentFontStyle: Resource = $r('sys.symbol.character_shadow');
  @State currentTextAlign: Resource = $r('sys.symbol.text_aligncenter');
  @State isShowStyleMenu: boolean = false;
  @State isShowAlignMenu: boolean = false
  @StorageProp('currentColorMode') private currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;
  undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  public textFontDataList = [
    new ResourceButtonItem($r('sys.symbol.bold'), 'font_bold', 0),
    new ResourceButtonItem($r('sys.symbol.italic'), 'font_italic', 0),
    new ResourceButtonItem($r('sys.symbol.underline'), 'font_underline', 0),
  ]

  aboutToAppear(): void {
    if (!this.textArea) {
      this.textAreaManager.getTextAreaList().forEach(textArea => {
        if (textArea.editState === Constants.ONFOCUS) {
          HiLog.i(TAG, 'FontTool textArea.id: %{public}s', textArea.id);
          this.textArea = textArea
        }
      })
    }
    this.onLanguageChange();
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = i18n.isRTL(this.currentLanguage);
      HiLog.i(TAG, `LanguageChange : ${this.currentLanguage} , change isRTL : ${this.isRTL}`);
    }
  }

  @Builder
  textAlignMenuBuilder() {
    Menu() {
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.text_alignleft')),
        content: $r('app.string.text_align_left'),
        symbolEndIcon: this.setEndIcon(this.textArea.textAlign === TextAlign.Start),
      })
        .id(`text_editor_align_left`)
        .accessibilityLevel('yes')
        .accessibilityDescription(' ')
        .accessibilityText(UiUtil.getResourceString($r('app.string.text_align_left')) +
        UiUtil.getResourceString(this.textArea.textAlign === TextAlign.Start ? $r('app.string.selected_imageEdit') :
          $r('app.string.one_finger_to_select_imageEdit')))
        .onClick(() => {
          this.updateTextAlign(TextAlign.Start, $r('sys.symbol.text_alignleft'));
          let msg: Record<string, number | string | boolean> = {
            'TEXT_ALIGN': 'Align left'
          };
        })
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.text_aligncenter')),
        content: $r('app.string.text_align_center'),
        symbolEndIcon: this.setEndIcon(this.textArea.textAlign === TextAlign.Center),
      })
        .id(`text_editor_align_center`)
        .accessibilityLevel('yes')
        .accessibilityDescription(' ')
        .accessibilityText(UiUtil.getResourceString($r('app.string.text_align_center')) +
        UiUtil.getResourceString(this.textArea.textAlign === TextAlign.Center ? $r('app.string.selected_imageEdit') :
          $r('app.string.one_finger_to_select_imageEdit')))
        .onClick(() => {
          this.updateTextAlign(TextAlign.Center, $r('sys.symbol.text_aligncenter'));
          let msg: Record<string, number | string | boolean> = {
            'TEXT_ALIGN': 'Align center'
          };
        })
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.text_alignright')),
        content: $r('app.string.text_align_right'),
        symbolEndIcon: this.setEndIcon(this.textArea.textAlign === TextAlign.End),
      })
        .id(`text_editor_align_right`)
        .accessibilityLevel('yes')
        .accessibilityDescription(' ')
        .accessibilityText(UiUtil.getResourceString($r('app.string.text_align_right')) +
        UiUtil.getResourceString(this.textArea.textAlign === TextAlign.End ? $r('app.string.selected_imageEdit') :
          $r('app.string.one_finger_to_select_imageEdit')))
        .onClick(() => {
          this.updateTextAlign(TextAlign.End, $r('sys.symbol.text_alignright'));
          let msg: Record<string, number | string | boolean> = {
            'TEXT_ALIGN': 'Align right'
          };
        })
    }
    .styleMenuStyle()
  }

  updateTextAlign(textAlign: TextAlign, currentTextAlign: Resource) {
    this.textAreaManager.getTextAreaList().forEach(textArea => {
      if (textArea.editState === Constants.ONFOCUS) {
        HiLog.i(TAG, 'FontStyleTool textArea.id: %{public}s', textArea.id);
        textArea.textAlign = textAlign;
        this.textArea = textArea
      }
    })
    this.textArea.textAlign = textAlign
    this.currentTextAlign = currentTextAlign
    this.textArea.richEditorController.updateParagraphStyle({
      style:
      {
        textAlign: this.textArea.textAlign,
      }
    })
    //更新lastTextArea样式
    this.textAreaManager.copyStyle(this.textAreaManager.getLastTextArea(), this.textArea);
  }

  @Builder
  fontStyleMenuBuilder() {
    Menu() {
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.character_shadow')),
        content: $r('app.string.adjust_shadow_imageEdit'),
        symbolEndIcon: this.setEndIcon(this.textArea.isTextShadow),
      })
        .id(`text_editor_font_style_shadow`)
        .accessibilityLevel('yes')
        .accessibilityText(UiUtil.getResourceString($r('app.string.adjust_shadow_imageEdit')) +
        UiUtil.getResourceString(this.textArea.isTextShadow ? $r('app.string.selected_imageEdit') : null))
        .onClick(() => {
          this.changeFontStyle($r('sys.symbol.character_shadow'), true, false, false);
        })
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.character_square')),
        content: $r('app.string.background'),
        symbolEndIcon: this.setEndIcon(this.textArea.isBackground),
      })
        .id(`text_editor_font_style_background`)
        .accessibilityLevel('yes')
        .accessibilityText(UiUtil.getResourceString($r('app.string.background')) +
        UiUtil.getResourceString(this.textArea.isBackground ? $r('app.string.selected_imageEdit') : null))
        .onClick(() => {
          this.changeFontStyle($r('sys.symbol.character_square'), false, false, true);
        })
      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.character')),
        content: $r('app.string.none'),
        symbolEndIcon: this.setEndIcon(!this.textArea.isBackground && !this.textArea.isTextShadow)
      })
        .id(`text_editor_font_style_none`)
        .accessibilityLevel('yes')
        .accessibilityText(UiUtil.getResourceString($r('app.string.none')) +
        UiUtil.getResourceString(!this.textArea.isBackground && !this.textArea.isTextShadow ?
          $r('app.string.selected_imageEdit') : null))
        .onClick(() => {
          this.changeFontStyle($r('sys.symbol.character'), false, false, false);
        })
    }
    .styleMenuStyle()
  }

  private setEndIcon(needEndIcon: boolean): SymbolGlyphModifier | undefined {
    return needEndIcon ? new SymbolGlyphModifier($r('sys.symbol.checkmark')) :
      new SymbolGlyphModifier();
  }

  private changeFontStyle(resource: Resource, isTextShadow: boolean, isTextStroke: boolean, isBackground: boolean) {
    this.currentFontStyle = resource;
    this.textAreaManager.getTextAreaList().forEach(textArea => {
      if (textArea.editState === Constants.ONFOCUS) {
        HiLog.i(TAG, 'FontStyleTool textArea.id: %{public}s', textArea.id);
        textArea.isTextShadow = isTextShadow;
        textArea.isTextStroke = isTextStroke;
        textArea.isBackground = isBackground;
        this.textArea = textArea
      }
    })
    this.updateFontStyle();
  }

  //设置字体大小、颜色、加粗、斜体、下划线、阴影  ---调用时机，currentBackgroundColor改变、页面按钮点击事件
  updateFontStyle() {
    HiLog.i(TAG, `updateFontStyle textArea:${JSON.stringify(this.textArea.id)}`);
    if (!this.textArea) {
      this.textArea = this.textAreaManager.getTextAreaList().filter(item => item.editState === 1)[0];
      HiLog.i(TAG, `updateFontStyle textArea id:${JSON.stringify(this.textArea.id)}`);
    }
    this.textArea.richEditorController.deleteSpans();
    this.textArea.richEditorController.addTextSpan(this.textArea.content === '' ?
      UiUtil.getResourceString($r('app.string.edit_text_imageEdit')) : this.textArea.content, {
      style: {
        fontColor: this.textArea.getShowColor(),
        fontSize: vp2px(this.textArea.fontSize) + 'px',
        fontWeight: this.textArea.isBold ? FontWeight.Bold : FontWeight.Normal,
        fontStyle: this.textArea.isItalic ? FontStyle.Italic : FontStyle.Normal,
        //设置下划线
        decoration: {
          type: this.textArea.isUnderline ? TextDecorationType.Underline : TextDecorationType.None,
          color: this.textArea.getShowColor(),
        },
        //阴影
        textShadow: {
          radius: this.textArea.isTextShadow ? 7 : 0,
          color: 'rgba(0, 0, 0, 0.3)',
          type: ShadowType.COLOR,
        }
      },
      paragraphStyle: {
        textAlign: this.textArea.textAlign,
      }
    });
    //更新lastTextArea样式
    this.textAreaManager.copyStyle(this.textAreaManager.getLastTextArea(), this.textArea);
  }

  build() {
    Row() {
      Row() {
        SymbolGlyph($r('sys.symbol.bold'))
          .baseSymbolStyle(this.textArea?.isBold)
      }
      .height(48)
      .width('calc((100% - 11vp)* (1/5))')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor(this.textArea?.isBold ? $r('sys.color.comp_background_emphasize') :
        $r('sys.color.comp_background_tertiary'))
      .accessibilityDescription(' ')
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString($r('app.string.bold_imageEdit')) +
      UiUtil.getResourceString(this.textArea?.isBold ? $r('app.string.selected_imageEdit') :
        $r('app.string.one_finger_to_select_imageEdit')))
      .border({
        radius: {
          topLeft: this.isRTL ? 0 : 12,
          bottomLeft: this.isRTL ? 0 : 12,
          topRight: this.isRTL ? 12 : 0,
          bottomRight: this.isRTL ? 12 : 0,
        }
      })
      .id(`text_editor_font_bold`)
      .onClick(() => {
        if (this.textArea?.editState === Constants.ONFOCUS) {
          HiLog.i(TAG, `FontStyleTool isBold:${this.textArea.isBold}`);
          this.textArea.isBold = !this.textArea.isBold;
          this.updateFontStyle();
        }
        let msg: Record<string, number | string | boolean> = {
          'FONT_BOLD': this.textArea?.isBold
        };
      })

      Row() {
      }
      .height(48)
      .width(1)

      this.italicBtnBuilder()

      Row().height(48).width(1)

      this.underlineBtnBuilder()

      Row().height(48).width(8)

      this.fontStyleBtnBuilder()

      Row().height(48).width(1)

      this.textAlignBtnBuilder()

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  italicBtnBuilder() {
    Row() {
      SymbolGlyph($r('sys.symbol.italic'))
        .baseSymbolStyle(this.textArea?.isItalic)
    }
    .height(48)
    .width('calc((100% - 11vp)* (1/5))')
    .justifyContent(FlexAlign.SpaceEvenly)
    .backgroundColor(this.textArea?.isItalic ? $r('sys.color.comp_background_emphasize') :
      $r('sys.color.comp_background_tertiary'))
    .id(`text_editor_font_italic`)
    .accessibilityDescription(' ')
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.italics_imageEdit')) +
    UiUtil.getResourceString(this.textArea?.isItalic ? $r('app.string.selected_imageEdit') :
      $r('app.string.one_finger_to_select_imageEdit')))
    .onClick(() => {
      if (this.textArea?.editState === Constants.ONFOCUS) {
        HiLog.i(TAG, `FontStyleTool isItalic:${this.textArea.isItalic}`);
        this.textArea.isItalic = !this.textArea.isItalic;
        this.updateFontStyle();
      }
      let msg: Record<string, number | string | boolean> = {
        'FONT_ITALIC': this.textArea?.isItalic
      };
    })
  }

  @Builder
  underlineBtnBuilder() {
    Row() {
      SymbolGlyph($r('sys.symbol.underline'))
        .baseSymbolStyle(this.textArea?.isUnderline)
    }
    .height(48)
    .width('calc((100% - 11vp)* (1/5))')
    .justifyContent(FlexAlign.SpaceEvenly)
    .backgroundColor(this.textArea?.isUnderline ? $r('sys.color.comp_background_emphasize') :
      $r('sys.color.comp_background_tertiary'))
    .accessibilityDescription(' ')
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.underline_imageEdit')) +
    UiUtil.getResourceString(this.textArea?.isUnderline ? $r('app.string.selected_imageEdit') :
      $r('app.string.one_finger_to_select_imageEdit')))
    .border({
      radius: {
        topRight: this.isRTL ? 0 : 12,
        bottomRight: this.isRTL ? 0 : 12,
        topLeft: this.isRTL ? 12 : 0,
        bottomLeft: this.isRTL ? 12 : 0,
      }
    })
    .id(`text_editor_font_underline`)
    .onClick(() => {
      if (this.textArea?.editState === Constants.ONFOCUS) {
        HiLog.i(TAG, `FontStyleTool isUnderline:${this.textArea.isUnderline}`);
        this.textArea.isUnderline = !this.textArea.isUnderline;
        this.updateFontStyle();
      }
      let msg: Record<string, number | string | boolean> = {
        'FONT_UNDERLINE': this.textArea?.isUnderline
      };
    })
  }

  @Builder
  fontStyleBtnBuilder() {
    Row() {
      SymbolGlyph(this.currentFontStyle)
        .baseSymbolStyle(this.isShowStyleMenu)
    }
    .height(48)
    .width('calc((100% - 11vp)* (1/5))')
    .justifyContent(FlexAlign.SpaceEvenly)
    .backgroundColor(this.isShowStyleMenu ? $r('sys.color.comp_background_emphasize') :
      $r('sys.color.comp_background_tertiary'))
    .border({
      radius: {
        topLeft: this.isRTL ? 0 : 12,
        bottomLeft: this.isRTL ? 0 : 12,
        topRight: this.isRTL ? 12 : 0,
        bottomRight: this.isRTL ? 12 : 0,
      }
    })
    .accessibilityDescription(' ')
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.style_imageEdit')) +
    UiUtil.getResourceString($r('app.string.one_finger_to_toggle_imageEdit')))
    .id(`text_editor_font_style`)
    .bindMenu(this.fontStyleMenuBuilder(), {
      onAppear: (() => {
        this.isShowStyleMenu = true
      }),
      onDisappear: (() => {
        this.isShowStyleMenu = false
      }),
      placement: Placement.TopRight,
    })
  }

  @Builder
  textAlignBtnBuilder() {
    Row() {
      SymbolGlyph(this.currentTextAlign)
        .baseSymbolStyle(this.isShowAlignMenu)
    }
    .height(48)
    .width('calc((100% - 11vp)* (1/5))')
    .justifyContent(FlexAlign.SpaceEvenly)
    .backgroundColor(this.isShowAlignMenu ? $r('sys.color.comp_background_emphasize') :
      $r('sys.color.comp_background_tertiary'))
    .accessibilityDescription(' ')
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.alignment_imageEdit')) +
    UiUtil.getResourceString($r('app.string.one_finger_to_toggle_imageEdit')))
    .border({
      radius: {
        topRight: this.isRTL ? 0 : 12,
        bottomRight: this.isRTL ? 0 : 12,
        topLeft: this.isRTL ? 12 : 0,
        bottomLeft: this.isRTL ? 12 : 0,
      }
    })
    .id(`text_editor_align`)
    .bindMenu(this.textAlignMenuBuilder(), {
      onAppear: (() => {
        this.isShowAlignMenu = true
      }),
      onDisappear: (() => {
        this.isShowAlignMenu = false
      }),
      placement: Placement.TopRight,
    })
  }
}

@Extend(SymbolGlyph)
function baseSymbolStyle(isSelect: boolean) {
  .draggable(false)
  .fontSize($r('app.float.list_item_right_icon2_height'))
  .fontColor([isSelect ? UiFontColor.WHITE : $r('sys.color.icon_primary')])
  .width(24)
  .height(24)
  .margin({
    top: 12,
    bottom: 12,
  })
}
