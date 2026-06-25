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
import {
  AdjustAttr,
  App,
  ButtonBubble,
  ButtonItem,
  HiLog,
  MediaType,
  BaseEditor,
  ScreenManager,
  StrengthBar
} from '@oh-image-editor/editor-common';
import { ButtonPopup } from '../common/ButtonPopup';
import {
  ADJUST_TAG,
  AUTO_INDEX,
  FADE_INDEX,
  GRAIN_INDEX,
  SHARPNESS_INDEX,
  VIGNETTE_INDEX
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { FOCUS_SCROLL } from '@oh-image-editor/editor-common/src/main/ets/common/const'
import { KeyCode } from '@ohos.multimodalInput.keyCode'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';

let checkState: boolean = true;
const TAG = 'AdjustTab';

@Component
export struct AdjustTab {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State oneClickPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_oneClick_adjust_imageEdit'),
    false, false, false);
  @State popupText: Resource | undefined = undefined;
  @State isChanging: boolean = false;
  private scroller: Scroller = new Scroller();
  private timer: number = -1;

  @Builder
  popupBuilder() {
    ButtonPopup({
      popupText: this.popupText,
    })
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Flex({ direction: FlexDirection.Column }) {
          this.adjustFiller();
          Row().width('100%').height(70)
          Blank()
        }
        .padding({
          left: 16,
          right: 16,
        })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .id('petalClip_VideoTrimTool')
    .menuStyle()
  }

  @Builder
  adjustTitleBar() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Text($r('app.string.tabs_adjust_imageEdit')).titleStyle()

      Button({ type: ButtonType.Normal }) {
        SymbolGlyph($r('sys.symbol.adjustment')).adjustmentSym(this.adjustAttr.isAutoAdjustOn)
      }
      .adjustBtn(this.oneClickPopup.isShow, this.oneClickPopup.isPress)
      .bindPopup(this.oneClickPopup.isShow, {
        builder: this.popupBuilder(),
        enableArrow: false,
        placement: Placement.BottomLeft,
        autoCancel: false,
        mask: false,
        targetSpace: 8,
        backgroundBlurStyle: BlurStyle.NONE,
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        if (isHover) {
          this.popupText = $r('app.string.button_bubble_oneClick_adjust_imageEdit');
          this.timer = setTimeout((): void => {
            this.oneClickPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.oneClickPopup.isShow = !isHover;
          clearTimeout(this.timer);
        }
      })
      .onMouse((event: MouseEvent) => {
        if (event.action === MouseAction.Press) {
          this.oneClickPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.oneClickPopup.isPress = false;
        }
      })
      .onClick((): void => {
        this.adjustAttr.isAutoAdjustOn = !this.adjustAttr.isAutoAdjustOn;
        this.adjustAttr.setEnable('auto', this.adjustAttr.isAutoAdjustOn);
        if (this.editor.isEdit) {
          this.editor.isShowRevert = !this.editor.isEdited();
        }
        this.editor.refreshThumbnail.ifRefreshThumbnail = true;
      })
      .id('petalclip_AdjustTab_adjustmentBtn')

    }.height(48).width('100%')
    .id('petalclip_AdjustTab_adjustTitleBar')
    .padding({
      left: $r('app.float.right_bar_left_right_padding'),
      right: $r('app.float.right_bar_left_right_padding'),
    })
  }

  @Builder
  adjustFiller() {
    ForEach(this.adjustAttr.tabs, (item?: ButtonItem, index?: number) => {
      AdjustItem({
        itemIndex: index,
        adjustAttr: this.adjustAttr,
        isChanging: $isChanging,
      }).margin({ bottom: 2 })
    }, (item: ButtonItem) => item.key)
  }
}

@Component
export struct AdjustItem {
  @Prop itemIndex: number = 0;
  @State @Watch('changeProgress') adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State item: ButtonItem = this.adjustAttr.tabs[this.itemIndex];
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State progressVal: number = this.item.value;
  @State adjustMin: number = this.item.min;
  @State adjustMax: number = this.item.max;
  @State isOnHover: boolean = false;
  @Link isChanging: boolean;
  // 调节bar是否为滑动动作，false为点按动作
  @State isSlide: boolean = false;
  private currentProValue: number = 0;
  private firstAutoAdjust: boolean = true;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  changeProgress(): void {
    let isChangeProgress = this.adjustAttr.isRefreshValue && this.adjustAttr.redoAdjustItem == this.item.key && (this
      .progressVal != this.adjustAttr.getValueByKey(this.item.key)
      .value);
    if (isChangeProgress) {
      let index = this.adjustAttr.tabs.findIndex((item: ButtonItem) => item.key == this.item.key)
      if (index == -1) {
        HiLog.e('AdjustItem', "item key '" + this.item.key + "' not exist");
        return;
      }
      this.progressVal = this.adjustAttr.tabs[index].value;
      this.item.value = this.progressVal;
    }
    if (this.adjustAttr.isRefreshValue && this.adjustAttr.redoAdjustItem.match(this.item.key)) {
      this.adjustAttr.isRefreshValue = false;
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .spinnerImg(this.item.closed)
          .onClick((): void => {
            this.item.closed = !this.item.closed;
            if (this.editor.isEdit) {
              this.editor.isShowRevert = !this.editor.isEdited();
            }
            checkState = this.item.isCheck;
          })
          .id(`videoEditor_adjustTab_adjustItem_${this.item.key}`)

        if (this.item.isSymbolGlyph) {
          SymbolGlyph(this.item.icon).iconSymbolGlyph()
        } else {
          Image(this.item.icon).iconImg()
        }

        Text(this.item.text).adjustText(false)

        Blank()
          .margin({ right: 8 })

        Text(Math.round(this.item.value).toString()).rateText()
          .visibility(this.item.value == 0 && !this.item.isCheck ? Visibility.Hidden :
          Visibility.Visible)
        Toggle({ type: this.item.key === 'auto' ? ToggleType.Switch : ToggleType.Checkbox, isOn: this.item.isCheck })
          .margin({ right: 8 })
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .switchStyle({
            unselectedColor: $r('sys.color.icon_fourth'),
          })
          .onClick((): void => {
            this.checkStatus();
            if (this.item.value !== 0 || this.itemIndex === AUTO_INDEX) {
              this.editor.increaseEditCounter();
            }
            this.editor.refreshThumbnail.ifRefreshThumbnail = true;
            if (this.editor.isEdit) {
              this.editor.isShowRevert = !this.editor.isEdited();
            }
          })
      }
      .adjustTitle(this.isOnHover)
      .onHover((isHover: boolean | undefined) => {
        // 调节bar正在移动时，所有调节项的hover效果暂时隐藏
        if (isHover == undefined || this.isChanging) {
          return;
        }
        this.isOnHover = isHover;
      })
      .onClick((): void => {
        this.item.closed = !this.item.closed;
        if (this.editor.isEdit) {
          this.editor.isShowRevert = !this.editor.isEdited();
        }
      })
      .justifyContent(FlexAlign.Center)
      .id(`petalclip_AdjustItem_${this.item.key}`)

      Row() {
        StrengthBar({
          item: this.item,
          color: (this.adjustAttr.isAutoAdjustOn && this.item.value !== 0) ? '#E6E6E6' : this.item.isCheck ?
            '#E6E6E6' : '#666666',
          isCheck: this.item.isCheck,
          progress: this.item.value,
          min: this.adjustMin,
          max: this.adjustMax,
          barWidth: 248,
          duration: this.adjustMax - this.adjustMin,
          isSlide: $isSlide,
          onCurrentXChange: val => {
            if (this.item.key === ADJUST_TAG && this.firstAutoAdjust) {
              this.adjustAttr.setEnable('auto', true);
              this.firstAutoAdjust = false;
            }
            if (!this.isChanging) {
              this.isChanging = true;
            }
            let scrollVal = Number(val.toFixed(1));
            let originNum = this.item.value;
            if (Number(originNum.toFixed(1)) === scrollVal) {
              this.adjustAttr.isRefreshValue && (this.adjustAttr.isRefreshValue = false);
              return;
            }
            if (!this.editor.isStartOperate && !this.adjustAttr.isRefreshValue) {
              this.editor.isStartOperate = true;
              this.editor.startEditorOperate();
              this.adjustAttr.isRefreshValue = false;
            }
            this.adjustAttr.isRefreshValue && (this.adjustAttr.isRefreshValue = false);
            this.currentProValue = scrollVal;
            this.item.value = scrollVal;
            this.progressVal = Number(scrollVal);
            this.adjustAttr?.setValue(this.item.key, scrollVal, !this.item.isCheck);
            // 避免刷新集合之后，isCheck被覆盖
            this.item.isCheck = true;
            this.adjustAttr.getValueByKey(this.item.key).disabled = true;
            if (!this.item.isCheck) {
              this.item.isCheck = true;
            }
          },
          onEnd: () => {
            this.editor.increaseEditCounter();
            // 关联子项滑动后关闭一键调节
            if (this.itemIndex !== AUTO_INDEX && this.itemIndex !== SHARPNESS_INDEX && this.itemIndex !==
              VIGNETTE_INDEX && this.itemIndex !== FADE_INDEX && this.itemIndex !== GRAIN_INDEX) {
              this.adjustAttr.isAutoAdjustOn = false;
              this.adjustAttr.tabs[AUTO_INDEX].value = 0;
              this.adjustAttr.tabs[AUTO_INDEX].isCheck = false;
              this.adjustAttr.getValueByKey(this.adjustAttr.tabs[AUTO_INDEX].key).value = 0;
            }
            this.isChanging = false;
            this.editor.stopEditorOperate();
            this.editor.isStartOperate = false;
            checkState = this.item.isCheck;
          }
        })
          .align(Alignment.Center)
      }
      .onClick((): void => {
        // 这里加个空的onClick事件是为了能在按tab键切换时获焦,ArkUI提供的提供的其他属性都没用,这个方法有用且不影响业务
      })
      .onFocus((): void => {
        AppStorage.setOrCreate(FOCUS_SCROLL, this.item.key);
      })
      .onBlur(() => {
        AppStorage.setOrCreate<string>(FOCUS_SCROLL, '');
      })
      .onKeyEvent((event: KeyEvent) => {
        const arrowKeys =
          [KeyCode.KEYCODE_DPAD_UP, KeyCode.KEYCODE_DPAD_DOWN, KeyCode.KEYCODE_DPAD_LEFT, KeyCode.KEYCODE_DPAD_RIGHT];
        if (event.type === KeyType.Up) {
          if (arrowKeys.includes(event.keyCode)) {
            HiLog.i(TAG, 'keyboardShortcut arrowKeys up');
            this.appBroadCast.emit(BroadCastConstants.EDIT_VALUE_CHANGE_END, []);
          }
          return;
        }
        if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
          HiLog.i(TAG, 'keyboardShortcut ↑');
          this.appBroadCast.emit(BroadCastConstants.EDIT_VALUE_ADD, []);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
          HiLog.i(TAG, 'keyboardShortcut ↓');
          this.appBroadCast.emit(BroadCastConstants.EDIT_VALUE_SUB, []);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
          HiLog.i(TAG, 'keyboardShortcut ←');
          this.appBroadCast.emit(BroadCastConstants.EDIT_VALUE_SUB, []);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
          HiLog.i(TAG, 'keyboardShortcut →');
          this.appBroadCast.emit(BroadCastConstants.EDIT_VALUE_ADD, []);
        }
        // 上下左右按键需要用于数值的调整,这里阻止按键冒泡,不然会被用于焦点的切换
        if (arrowKeys.includes(event.keyCode)) {
          event.stopPropagation();
        }
      })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .rowStyle()
      .visibility(this.item.closed ? Visibility.None : Visibility.Visible)
      .id(`petalclip_RulerBar_${this.item.key}`)
    }
  }

  checkStatus(): void {
    this.item.isCheck = !this.item.isCheck;
    this.adjustAttr.getValueByKey(this.item.key).disabled = !this.adjustAttr.getValueByKey(this.item.key).disabled;
    checkState = this.item.isCheck;
    this.editor.isStartOperate = true;
    if (this.item.isCheck) {
      this.item.closed = false;
      this.adjustAttr.setEnable(this.item.key, true);
    } else {
      if (this.itemIndex !== AUTO_INDEX && this.itemIndex !== SHARPNESS_INDEX && this.itemIndex !== VIGNETTE_INDEX &&
        this.itemIndex !== FADE_INDEX && this.itemIndex !== GRAIN_INDEX) {
        this.adjustAttr.isAutoAdjustOn = false;
        this.adjustAttr.tabs[AUTO_INDEX].value = 0;
        this.adjustAttr.tabs[AUTO_INDEX].isCheck = false;
        this.adjustAttr.getValueByKey(this.adjustAttr.tabs[AUTO_INDEX].key).value = 0;
      }
      this.adjustAttr.setEnable(this.item.key, false);
    }
    this.editor.isStartOperate = false;
  }
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.Body_L'))
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
  .margin({ top: 19 })
}

@Extend(Button)
function adjustBtn(isHover: boolean, isPress: boolean) {
  .align(Alignment.Center)
  .width(48)
  .height(48)
  .borderRadius($r('sys.float.corner_radius_level4'))
  .backgroundColor(isHover ? (isPress ? '#525252' : '#484848') : 'rgba(0,0,0,0)')
}

@Extend(SymbolGlyph)
function adjustmentSym(isAutoAdjustOn: boolean) {
  .fontSize(24)
  .fontColor([isAutoAdjustOn ? '#5291FF' : $r('sys.color.ohos_id_color_primary_contrary')])
}

@Extend(Button)
function imageColumn() {
  .margin({ top: 14 })
  .width(32)
  .height(32)
  .borderRadius($r('sys.float.corner_radius_level4'))
}

@Extend(Column)
function menuStyle() {
  .backgroundColor('#262626')
  .justifyContent(FlexAlign.Start)
  .width($r('app.float.right_bar_width'))
  .height('100%')
}

@Extend(SymbolGlyph)
function spinnerImg(isClosed: boolean) {
  .fontSize('24vp')
  .rotate({ angle: isClosed ? '0deg' : '90deg' })
  .fontColor([$r('sys.color.ohos_id_color_text_tertiary_dark')])
  .margin({ left: 16, right: 16 })
}

@Extend(Image)
function iconImg() {
  .width(22)
  .height(22)
  .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
  .margin({ right: 8 })
}

@Extend(SymbolGlyph)
function iconSymbolGlyph() {
  .fontSize('22vp')
  .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
  .margin({ right: 8 })
}

@Extend(Text)
function adjustText(isAutoAdjust: boolean) {
  .fontWeight(FontWeight.Medium)
  .fontSize(isAutoAdjust ? 14 : $r('sys.float.Body_L'))
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary_dark'))
  .opacity(isAutoAdjust ? 0.6 : 1)
  .maxFontScale(1.45)
}

@Extend(Text)
function rateText() {
  .fontWeight(FontWeight.Regular)
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary_contrary_dark'))
}

@Extend(Row)
function adjustTitle(isHover: boolean) {
  .width('100%')
  .height(40)
  .alignItems(VerticalAlign.Center)
  .backgroundColor(isHover ? 'rgba(255,255,255,0.05)' : Color.Transparent)
  .borderRadius(isHover ? 8 : 0)
}

@Extend(Row)
function rowStyle() {
  .backgroundColor('rgba(0,0,0,0.2)')
  .borderRadius($r('sys.float.corner_radius_level4'))
  .width(272)
  .height('56')
  .margin({ top: 8, bottom: 8 })
}