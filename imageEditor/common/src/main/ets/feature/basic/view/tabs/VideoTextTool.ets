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
import { Asset } from '../../../../service/BaseEditor';
import { App, BaseEditor } from '../../../../service/App';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { UiUtil } from '../../../../common/util/UiUtil';
import { LengthMetrics } from '@kit.ArkUI';
import { ButtonItem } from '../../common/view/SelectableProgressButton';
import { AppColor, SCREEN_ORIENTATION_PORTRAIT, SCROLL_SHADOW_WIDTH } from '../../../../common/const';
import { HiLog } from '../../../../common/util/HiLog';
import { Constants } from '../../../../service/model/tabTextEdit/util/Const';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { FontColorTool, FontSizeTool, FontStyleTool } from '../../../../service/model/tabTextEdit/view/FontTools';
import { FontStyleTitleAndClose } from '../../../../service/model/tabTextEdit/view/FontAlignTools';
import { TextAreaManager } from '../../../../service/model/tabTextEdit/viewModel/TabTextAreaManager';
import { UndoRedoManager } from '../../../../service/model/tabTextEdit/viewModel/TabUndoRedoManager';
import {
  deepCopy,
  displayOption,
  isChanged,
  TextAreaInfo
} from '../../../../service/model/tabTextEdit/model/TextAreaInfo';
import { Operation } from '../../../../service/model/tabTextEdit/model/Operation';


@Extend(Circle)
function circleBack(state: number) {
  .width('48vp')
  .height('48vp')
  .fill(state === 1 ? '#DBDBDB' : '#2F2F2F')
  .padding('0 160px')
}

@Extend(Image)
function subMenu(state: number) {
  .width('24vp')
  .height('24vp')
  .fillColor(state === 1 ? '#E5000000' : '#e5ffffff')
  .opacity(state === 2 ? 0.4 : 1)
}

@Extend(SymbolGlyph)
function subMenuSym(state: number) {
  .fontSize('24vp')
  .fontColor([state === 1 ? '#E5000000' : '#e5ffffff'])
  .opacity(state === 2 ? 0.4 : 1)
}

@Extend(Text)
function textStyle(state: number) {
  .fontColor(state === 1 ? $r('sys.color.ohos_id_color_text_primary_dark') :
  $r('sys.color.ohos_id_color_text_secondary_dark'))
  .height('14vp')
  .fontSize('10fp')
  .maxFontScale(1)
  .textOverflow({ overflow: state ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
  .maxLines(1)
  .margin({ top: '4vp' })
  .opacity(state === 2 ? 0.4 : 1)
}

const TAG = 'VideoTextTool';

@Component
export struct VideoTextTool {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State shadowRate: number = 0;
  @Link textCanUndo: boolean;
  @Link textCanRedo: boolean;
  @Link textCanClickStyle: boolean;
  @Link isShowInPopup: boolean;
  @Link isShowBorder: boolean;
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link textInputAreaHide: boolean;
  @State textArea: TextAreaInfo | undefined = undefined;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();
  private scroller: Scroller = new Scroller();
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  private preTextArea: TextAreaInfo | undefined = undefined;
  @State buttonHoverStates: boolean[] = Array(this.asset.textEdit().textTabs.length).fill(false);

  addTextBox() {
    HiLog.i(TAG, 'add text');
    /* instrument ignore if */
    if (this.textAreaManager.checkTextNumber()) {
      return;
    }
    this.textAreaManager.register(this.asset.textEdit().textRect.width, this.asset.textEdit().textRect.height,
      this.isScreenPortrait);
    this.textCanUndo = this.undoRedoManager.canUndo();
    this.textCanRedo = this.undoRedoManager.canRedo();
    this.textArea = this.textAreaManager.getEditingTextArea();
    /* instrument ignore if */
    if (this.textArea === undefined) {
      HiLog.e(TAG, 'error text status');
      return;
    }
    if (ScreenManager.getInstance().isUIExtensionEnv()) {
      setTimeout(() => {
        HiLog.i(TAG, `addTextBox focus textAreaId: ${this.textArea?.id}`);
        focusControl.requestFocus(this.textArea?.id);
      }, 200)
    } else {
      this.textInputAreaHide = !this.textInputAreaHide;
    }
  }

  cropTextResource(curIndex: number, index: number, buttonItem: ButtonItem): Resource {
    if (curIndex === index) {
      if (this.asset.textEdit().textTabs[index].text !== null) {
        return this.asset.textEdit().textTabs[index].text;
      }
    }
    return buttonItem.text;
  }

  onWillAppear = () => {
    this.textArea = TextAreaManager.getInstance().getEditingTextArea();
    /* instrument ignore if */
    if (this.textArea !== undefined) {
      displayOption(this.textArea, undefined, false);
      this.preTextArea = deepCopy(this.textArea);
    }
  }
  onWillDisAppear = () => {
    /* instrument ignore if */
    if (this.textArea !== undefined) {
      if (this.textArea.editState === 1) {
        displayOption(this.textArea, true, true);
      }
      /* instrument ignore if */
      if (this.preTextArea !== undefined && isChanged(this.preTextArea, this.textArea)) {
        const curTextArea: TextAreaInfo = deepCopy(this.textArea);
        UndoRedoManager.getInstance().push(
          new Operation(Constants.UPDATE_FONT, this.textArea.id, this.preTextArea, curTextArea));
      }
    }
  }

  build() {
    Stack() {
      Flex({
        direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
        alignItems: ItemAlign.Center,
      }) {
        this.subMenu();
      }
      .id('petalclip_TextTool_textedit')
    }
    .onClick(() => {
      HiLog.i(TAG, 'clickPage onClick');
      this.editor.isInTextArea = false;
      this.textCanClickStyle = false;
      this.isShowInPopup = false;
      this.textAreaManager.flush('');
    })
    .accessibilityLevel('no')
  }

  /* instrument ignore next */
  closeFontStyleCallback() {
    this.isShowInPopup = false;
    this.textAreaManager.getTextAreaList().forEach(textArea => {
      if (textArea.editState === 1) {
        textArea.isShownMenu = true;
        this.textCanClickStyle = true;
      }
    })
  }

  @Builder
  fontStyleTitleAndClose() {
    FontStyleTitleAndClose({
      closeFontStyleCallback: () => {
        this.closeFontStyleCallback();
      }
    })
      .width('100%')
  }

  @Builder
  divider() {
    Divider()
      .padding({ left: 16, right: 16 })
      .strokeWidth('1px')
      .width('100%')
      .color($r('sys.color.ohos_id_color_list_separator'))
  }

  @Builder
  fontStylesBuilder() {
    Column() {
      this.fontStyleTitleAndClose();
      // 字体大小
      FontSizeTool({
        currentFontSize: this.currentFontSize,
        textArea: this.textArea,
        canUndo: this.textCanUndo,
        canRedo: this.textCanRedo,
        isFontSizeChange: this.isFontSizeChange,
      })
        .width('100%')
        .height(40)
        .padding({
          left: 16,
          right: 16,
        })
        .margin({ bottom: 8 })

      // 字体颜色
      FontColorTool({
        currentFontColor: this.currentFontColor,
        textArea: this.textArea,
        canUndo: this.textCanUndo,
        canRedo: this.textCanRedo,
      })
        .width('100%')
        .height(40)
        .padding({
          left: 16,
          right: 16,
        })
        .margin({ bottom: 16 })

      //字体样式
      FontStyleTool({
        currentFontColor: this.currentFontColor,
        textArea: this.textArea,
        canUndo: this.textCanUndo,
        canRedo: this.textCanRedo,
      })
        .width('100%')
        .height(48)
        .padding({
          left: 16,
          right: 16,
        })
    }
    .margin({ bottom: 24 })
  }

  @Builder
  subMenu() {
    Stack() {
    }
    .id('petalclip_TextTool_subMenu_Stack')
    .width(this.isScreenPortrait ? '100%' : 56)
    .height(this.isScreenPortrait ? 56 : '100%')
    .margin({ top: this.isScreenPortrait ? 8 : 0, left: this.isScreenPortrait ? 0 : 8 })

    Column() {
      Scroll(this.scroller) {
        Flex({
          direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
          alignItems: ItemAlign.Center,
        }) {
          Blank()
          this.textTabsBuilder()
          Blank()
        }
        .id('petalclip_TextTool_subMenu')
        .padding({
          top: this.isScreenPortrait ? 15 : 0,
          bottom: this.isScreenPortrait ? 15 : 0,
        })
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollable(this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
      })
    }
    .height(this.isScreenPortrait ? 96 : '100%')
    .width(this.isScreenPortrait ? '100%' : 96)
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : 180,
      colors: [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowStart ? this.shadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowEnd ? 1 - this.shadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
  }

  @Builder
  textTabsBuilder() {
    ForEach(this.asset.textEdit().textTabs, (item: ButtonItem, index?: number) => {
      if (index !== undefined) {
        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Column() {
            Stack({ alignContent: Alignment.Center }) {
              Circle().circleBack(item.state)
              if (item.isSymbolGlyph) {
                SymbolGlyph(item.icon).subMenuSym(item.state)
              } else {
                Image(item.icon).subMenu(item.state)
              }
            }

            Text(item.text).textStyle(item.state)
          }
        }
        .margin({
          start: LengthMetrics.vp(this.isScreenPortrait && index > 0 ? 2 : 0),
          top: LengthMetrics.vp(!this.isScreenPortrait && index > 0 ? 16 : 0)
        })
        .height(66)
        .width(66)
        .id('textTab_' + item.key + (this.asset.textEdit().tabIndex == index ? '_on' : '_off'))
        .accessibilityText(UiUtil.getResourceString(
          this.cropTextResource(this.asset.textEdit().tabIndex, index, item)))
        .bindPopup(this.isShowBorder && this.isShowInPopup &&
          ((DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold()) || DeviceUtil.isPad() ||
          DeviceUtil.isPc()) && item.key === 'style' && this.textCanClickStyle, {
          builder: this.fontStylesBuilder(),
          popupColor: $r('sys.color.comp_background_tertiary'),
          enableArrow: true,
          autoCancel: true,
          width: 360,
          mask: false,
          placement: this.isScreenPortrait ? Placement.Top : Placement.TopRight,
          followTransformOfTarget: true,
          onStateChange: (event) => {
            // instrument ignore if
            if (event.isVisible) {
              this.isShowInPopup = true;
              this.onWillAppear();
            } else {
              this.isShowInPopup = false;
              this.onWillDisAppear();
            }
          }
        })
        .enabled(!this.textInputAreaHide && (item.key !== 'style' || this.textCanClickStyle))
        .onClick(() => this.menuBtnOnClickEvent(item.key))
        .backgroundColor(this.buttonHoverStates[index] ? $r('sys.color.ohos_id_color_hover_transparent') :
        AppColor.black(0))
        .borderRadius(8)
        .onHover((isHover: boolean) => {
          this.buttonHoverStates[index] = isHover;
        })
      }
    }, (item: ButtonItem) => item.key)
  }

  menuBtnOnClickEvent = (key: string) => {
    if (key === 'default') {
      this.isShowInPopup = false;
      this.textCanClickStyle = false;
      this.addTextBox();
      this.editor.isInTextArea = true;
    }
    if (key === 'style' && this.textCanClickStyle) {
      //textArea赋值
      this.textArea = this.textAreaManager.getEditingTextArea();
      // instrument ignore if
      if (!this.textArea) {
        HiLog.i(TAG, 'currentEdit textArea is undefined');
        return;
      }
      this.isShowInPopup = true;
      HiLog.i(TAG,
        `currentEdit textArea isShowBorder:${this.isShowBorder},isShowInPopup:${this.isShowInPopup}`)
    }
  }
}