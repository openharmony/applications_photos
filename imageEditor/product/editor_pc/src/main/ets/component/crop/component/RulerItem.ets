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
  App,
  ButtonItem,
  CropAttr,
  BaseEditor,
  RulerBar,
  ScreenManager,
  ButtonBubble,
  HiLog
} from '@oh-image-editor/editor-common'
import { AdjustValueItem } from '@oh-image-editor/editor-common/src/main/ets/service/BaseEditor'
import { FOCUS_SCROLL } from '@oh-image-editor/editor-common/src/main/ets/common/const'
import { ButtonPopup } from '../../common/ButtonPopup'
import { KeyCode } from '@ohos.multimodalInput.keyCode'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { LengthMetrics } from '@kit.ArkUI'

const TAG = 'RulerItem';

@Extend(SymbolGlyph)
function spinnerImg(isClosed: boolean) {
  .fontSize('24vp')
  .rotate({ angle: isClosed ? '0deg' : '90deg' })
  .fontColor([$r('sys.color.ohos_id_color_text_tertiary_dark')])
  .margin({ left: 16, right: 16 })
}

@Extend(SymbolGlyph)
function symIconStyle() {
  .fontSize('20vp')
  .fontColor(['#FFFFFF'])
  .opacity(0.9)
}

@Extend(Image)
function iconImg() {
  .width(22)
  .height(22)
  .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
  .margin({ right: 8 })
}

@Extend(Button)
function btnStyle(isHover: boolean, isPress: boolean) {
  .width(32)
  .height(32)
  .borderRadius($r('sys.float.corner_radius_level8'))
  .backgroundColor(isHover ? (isPress ? '#525252' : '#484848') : 'rgba(0,0,0,0.2)')
  .padding(6)
}

@Extend(SymbolGlyph)
function iconSymbol() {
  .fontSize(22)
  .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
  .margin({ right: 8 })
}

@Extend(Text)
function rotateText() {
  .fontWeight(FontWeight.Regular)
  .fontSize($r('sys.float.Body_L'))
  .fontColor($r('sys.color.ohos_id_color_text_primary_contrary_dark'))
  .maxFontScale(1.45)
}

@Extend(Text)
function rateText() {
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary_contrary_dark'))
  .maxFontScale(1.45)
}

@Extend(Row)
function rotateTitle(isHover: boolean) {
  .width('100%')
  .height(40)
  .alignItems(VerticalAlign.Center)
  .backgroundColor(isHover ? 'rgba(255,255,255,0.05)' : Color.Transparent)
  .borderRadius(isHover ? 8 : 0)
}

@Extend(Row)
function rulerStyle() {
  .backgroundColor('rgba(0,0,0,0.2)')
  .borderRadius($r('sys.float.corner_radius_level4'))
  .width(272)
  .padding({ left: 12, right: 12 })
  .margin({ top: 8, bottom: 8 })
  .height('56')
}

@Extend(Row)
function RotateStyle() {
  .width(272)
  .margin({ top: 8, bottom: 5 })
}

@Component
export struct RulerItem {
  private timer: number = -1;
  @State @Watch('changeProgress') item: ButtonItem =
    new ButtonItem($r('app.string.crop_rotate_imageEdit'), $r('app.media.edit_menu_rotate'), false,
      'rotation', -45, 45, 1);
  @State stateChange: number = 0;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State isClick: boolean = false;
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State isTouchScroll: boolean = false;
  @State scrollWidth: number = 248;
  @State progressVal: number = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
  @State isOnHover: boolean = false;
  @State rotatePopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_rotate'), false, false, false);
  @State popupText: Resource | undefined = undefined;
  @State mirrorPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_mirror'), false, false, false);
  @State isInitRulerBarData: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  changeProgress(): void {
    let isChangeProgress: boolean = (this.item.key === this.cropsAttr.redoCropItem) &&
      (this.item.value != this.getOriginalValueByKey(this.item.key));
    if (isChangeProgress) {
      this.progressVal = this.item.value;
      this.stateChange++;
    } else {
      this.cropsAttr.isClickUndoRedo = false;
    }
    this.cropsAttr.redoCropItem = '';
  }

  aboutToAppear() {
  }

  /**
   * 根据key获取对应AdjustValueItem的originalValue属性
   *
   * @param key ButtonItem.key
   * @returns AdjustValueItem的originalValue属性，如果不存在则返回-1
   */
  private getOriginalValueByKey(key: string): number {
    let adjustValueItem: AdjustValueItem | null = this.cropsAttr.getValueByKey(key);
    if (adjustValueItem != null) {
      return adjustValueItem.originalValue;
    } else {
      return -1;
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_right')).spinnerImg(this.item.closed)

        if (this.item.isSymbolGlyph) {
          SymbolGlyph(this.item.icon).iconSymbol()
        } else {
          Image(this.item.icon).iconImg()
        }

        Text(this.item.text).rotateText()

        Blank()

        Text(Math.round(this.item.value).toString()).rateText()
          .visibility(Math.round(this.item.value) === 0 ? Visibility.Hidden : Visibility.Visible)
      }
      .rotateTitle(this.isOnHover)
      .onClick((): void => {
        this.item.closed = !this.item.closed;
        this.stateChange++;
        if (this.progressVal != this.item.value) {
          this.progressVal = this.item.value;
          this.stateChange++;
        }
        if (!this.item.closed) {
        }
        if (this.editor.isEdit) {
          this.editor.isShowRevert = !this.editor.isEdited();
        }
      })
      .onHover((isHover: boolean | undefined) => {
        if (isHover == undefined) {
          return;
        }
        this.isOnHover = isHover;
      })
      .id(`petalclip_RulerItem_${this.item.key}`)
      .stateStyles({
        focused: {
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor($r('sys.color.ohos_id_color_activated'))
          .borderRadius(8)
        },
        normal: {
          .borderWidth(0)
        },
      })


      Row() {
        RulerBar({
          item: this.item,
          progress: this.progressVal,
          stateChange: this.stateChange,
          min: this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].min,
          max: this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].max,
          visibleWidth: this.scrollWidth,
          stateClosed: false,
          snappingValue: 0,
          gapVal: 1,
          showGapNum: 5,
          startOptical: 42,
          endOptical: 50,
          isSnapping: true,
          isInitData: this.isInitRulerBarData,
          onProgressChange: (val: number, isFastScroll: boolean) => {
            let scrollVal = Number(val.toFixed(1));
            let originNum = this.item.value;
            if (Number(originNum.toFixed(1)) === scrollVal) {
              this.cropsAttr.isClickUndoRedo && (this.cropsAttr.isClickUndoRedo = false);
              return;
            }
            if (!this.editor.isStartOperate && !this.cropsAttr.isClickUndoRedo) {
              this.editor.isStartOperate = true;
              this.editor.startEditorOperate();
              this.cropsAttr.isClickUndoRedo = false;
            }
            this.cropsAttr.isClickUndoRedo && (this.cropsAttr.isClickUndoRedo = false);
            if (this.isClick) { // 解决刻度条惯性滑动过程中切换比例页crash
              return;
            }
            this.item.value = scrollVal;
            this.cropsAttr.setRotation(this.item.key, scrollVal);
          },
          onTouchMovingChange: (val: boolean) => {
            this.isTouchScroll = val;
          },
          onScrollStart: () => {
            this.cropsAttr.isEnableBlur = false;
            this.cropsAttr.hasSplitLine = true;
            this.cropsAttr.isScrolling = true;
          },
          onEnd: () => {
            this.editor.stopEditorOperate();
            this.editor.isStartOperate = false;
            this.cropsAttr.isEnableBlur = true;
            this.progressVal = this.item.value;
            this.cropsAttr.hasSplitLine = false;
            this.cropsAttr.isScrolling = false;
            this.cropsAttr.updateIsModify();
            if (this.editor.isEdit) {
              this.editor.isShowRevert = !this.editor.isEdited();
            }
          }
        }).onAreaChange((_: Area, newValue: Area) => {
          let width: number = newValue.width as number;
          (width != this.scrollWidth || _.width != newValue.width) && (this.scrollWidth = width) &&
            (this.stateChange++);
        })
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
      .rulerStyle()
      .visibility(this.item.closed ? Visibility.None : Visibility.Visible)
      .id(`petalclip_RulerBar_${this.item.key}`)
    }
  }

  @Builder
  RotateButton() {
    Button({ type: ButtonType.Normal }) {
      SymbolGlyph($r('sys.symbol.rotate_left')).symIconStyle()
    }
    .id('petalclip_CropTool_rotateBtn')
    .btnStyle(this.rotatePopup.isHover, this.rotatePopup.isPress)
    .bindPopup(this.rotatePopup.isShow, {
      builder: this.popupBuilder(),
      enableArrow: false,
      placement: Placement.BottomLeft,
      targetSpace: 8,
      mask: false,
      autoCancel: false,
      backgroundBlurStyle: BlurStyle.NONE,
    })
    .onClick((): void => {
      if (!ScreenManager.getInstance().getIsFirstFrame()) {
        return;
      }
      if (this.editor.interrupt) {
        this.editor.setCropReactInterrupt(false);
      }
      this.editor.asset.crops().rotate90Acw();
      if (this.editor.isEdit && this.editor.isSystemEditData) {
        this.editor.isShowRevert = !this.editor.editModified;
      }
      App.getInstance().myEditor().refreshThumbnail.ifRefreshThumbnail = true;
    })
    .onMouse((event: MouseEvent) => {
      if (event.action === MouseAction.Press) {
        this.rotatePopup.isPress = true;
      }
      if (event.action === MouseAction.Release) {
        this.rotatePopup.isPress = false;
      }
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      if (event.stopPropagation === null || event.stopPropagation === undefined) {
        return;
      }
      event.stopPropagation();
      this.rotatePopup.isHover = isHover;
      if (isHover) {
        this.popupText = $r('app.string.button_bubble_rotate');
        this.timer = setTimeout((): void => {
          this.rotatePopup.isShow = isHover;
        }, this.editor.hoverTime)
      } else {
        this.rotatePopup.isShow = isHover!;
        clearTimeout(this.timer);
      }
    })
  }

  @Builder
  CropTitleBar() {
    Button({ type: ButtonType.Normal }) {
      SymbolGlyph($r('sys.symbol.line_arrowtriangle_2_inward')).symIconStyle()
    }
    .bindPopup(this.mirrorPopup.isShow, {
      builder: this.popupBuilder(),
      enableArrow: false,
      placement: Placement.BottomLeft,
      targetSpace: 8,
      mask: false,
      autoCancel: false,
      backgroundBlurStyle: BlurStyle.NONE,
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      event.stopPropagation();
      this.mirrorPopup.isHover = isHover;
      if (isHover) {
        this.popupText = $r('app.string.button_bubble_mirror');
        this.timer = setTimeout((): void => {
          this.mirrorPopup.isShow = isHover;
        }, this.editor.hoverTime)
      } else {
        this.mirrorPopup.isShow = isHover!;
        clearTimeout(this.timer);
      }
    })
    .btnStyle(this.mirrorPopup.isHover, this.mirrorPopup.isPress)
    .margin({ start: LengthMetrics.vp(208) })
    .onClick((): void => {
      if (!ScreenManager.getInstance().getIsFirstFrame()) {
        return;
      }

      this.cropsAttr.setMirror(this.cropsAttr.mirrorFlag ? 0 : 1, this.cropsAttr.mirrorType);
      if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
      }
    })
    .onMouse((event: MouseEvent) => {
      if (event.action === MouseAction.Press) {
        this.mirrorPopup.isPress = true;
      }
      if (event.action === MouseAction.Release) {
        this.mirrorPopup.isPress = false;
      }
    })
    .id('petalclip_CropTab_mirrorBtn')
  }

  @Builder
  popupBuilder() {
    ButtonPopup({
      popupText: this.popupText,
    })
  }
}