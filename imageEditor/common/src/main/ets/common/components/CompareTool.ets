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
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { SCREEN_ORIENTATION_PORTRAIT, WIN_HEIGHT_KEY, WIN_WIDTH_KEY } from '../const';
import { DeviceUtil } from '../util/DeviceUtil';
import { ScreenManager } from '../util/ScreenManager';
import { App, BaseEditor, TabName, ScreenClass } from '../../service/App';
import { HiLog } from '../util/HiLog';
import { Asset } from '../../service/Asset';
import { AdjustAttr, MosaicAttr } from '../../service/BaseEditor';
import { UiUtil } from '../util/UiUtil';
import { accessibility } from '@kit.AccessibilityKit';
import { LengthUnit } from '@kit.ArkUI';
import { AiTabName } from '../../service/model/Enum';
import { Effects } from '../effects/Effects';

const TAG: string = 'CompareTool';
let touchUpTimeFn: number;

@Component
export struct CompareTool {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State @Watch('refreshBtnWidth') screenClass: ScreenClass = App.getInstance().screenClass;
  @State compareBtnXPosition: number = 0;
  @State compareBtnYPosition: number = 12;
  @State compareBtnLeftPosition: number | undefined = undefined;
  @State compareBtnRightPosition: number | undefined = undefined;
  @Link originalColorMode: number;
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  @State @Watch('isContrastModified') adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('refreshBtnWidth') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshBtnWidth') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshBtnWidth') winHeight: number = ScreenManager.getInstance().height;
  @State @Watch('refreshBtnWidth') isMirrorMode: boolean = UiUtil.isMirrorMode();
  @State @Watch('onTabChanged') tabChanged: TabName = App.getInstance().myEditor().tabIndex;
  private btnWidth: number = 64;
  @State private compareFlag: boolean = false;
  @State private comparePress: boolean = false;

  public async aboutToAppear() {
    this.refreshBtnWidth();
  }

  // 监听tab页切换
  onTabChanged() {
    this.refreshBtnWidth();
  }

  public async refreshBtnWidth() {
    let textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
    if (this.isScreenPortrait) {
      this.compareBtnLeftPosition = UiUtil.isMirrorMode() ? textPaddingLeftAndRight : undefined;
      this.compareBtnRightPosition = UiUtil.isMirrorMode() ? undefined : textPaddingLeftAndRight;
    } else {
      this.compareBtnRightPosition = UiUtil.isMirrorMode() ? textPaddingLeftAndRight +
      this.screenClass.avoidRight : undefined;
      this.compareBtnLeftPosition = UiUtil.isMirrorMode() ? undefined : this.screenClass.avoidLeft;
    }
  }

  build() {
    Column() {
      Row()
        .width(32)
        .height(32)
        .borderRadius(16)
        .backdropBlur(20)
        .position({
          left: 0
        });
      Row()
        .width(32)
        .height(32)
        .borderRadius(16)
        .backgroundColor('rgba(0,0,0,1)')
        .position({
          left: 0
        })
        .visualEffect(Effects.darkBlender);
      Image($r('app.media.compare_btn'))
        .width(20)
        .height(20);
    }
    .id('petalClip_VideoTrimTool_compareButton')
    .onAreaChange((_: Area, newValue: Area) => {
      this.btnWidth = newValue.width as number;
      this.refreshBtnWidth();
    })
    .align(Alignment.Center)
    .justifyContent(FlexAlign.Center)
    .onTouch((event: TouchEvent): void => {
      HiLog.w(TAG, `Compare Button Touch ${event.type}`);
      this.compareTouch(event.type);
    })
    .onKeyEvent((event: KeyEvent) => {
      if (event.keyCode === KeyCode.KEYCODE_ENTER) {
        HiLog.w(TAG, `Compare Button onKeyEvent ${event.keyCode} ${event.type}`);
        this.compareTouch(event.type === KeyType.Down ? TouchType.Down : TouchType.Up);
      }
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      // instrument ignore if
      if (event.stopPropagation === null || event.stopPropagation === undefined) {
        return;
      }
      event.stopPropagation();
      this.compareFlag = isHover;
      HiLog.i('CompareTool', 'is onHover compareFlag ' + this.compareFlag);
    })
    .onClick((): void => {
      if (accessibility.isOpenAccessibilitySync()) {
        HiLog.i(TAG, 'Accessibility enabled, screen reading mode');
      }
    })
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .accessibilityText(UiUtil.getResourceString($r('app.string.videoTool_compare_imageEdit')))
    .accessibilityDescription(UiUtil.getResourceString($r('app.string.adjust_compare_btn_desc')))
    .onMouse((event: MouseEvent) => {
      // instrument ignore if
      if (event.action === MouseAction.Press) {
        this.comparePress = true;
      }
      // instrument ignore if
      if (event.action === MouseAction.Release) {
        this.comparePress = false;
      }
      HiLog.i('CompareTool', 'is onMouse comparePress ' + this.comparePress);
    })
    .borderRadius(14)
    .backgroundColor(this.compareFlag ? (this.comparePress ? $r('sys.color.ohos_id_color_click_effect_dark') :
    $r('sys.color.ohos_id_color_hover_dark')) : '#994D4D4D')
    .margin(
      DeviceUtil.isPc() ? {} :
        (this.isScreenPortrait ? {
          start: { value: 0, unit: LengthUnit.VP },
          end: { value: this.compareBtnXPosition, unit: LengthUnit.VP },
          top: { value: 12, unit: LengthUnit.VP },
        } : {
          start: { value: this.compareBtnXPosition, unit: LengthUnit.VP },
          end: { value: 0, unit: LengthUnit.VP },
          top: { value: 12, unit: LengthUnit.VP },
        })
    )
    .position(DeviceUtil.isPc() ? { x: this.compareBtnXPosition, y: 12 } : {})
    .visibility(this.isShowCompareBtn() ? Visibility.Visible : Visibility.None)
    .borderRadius(16)
    .width(32)
    .height(32)
    .position({
      left: this.compareBtnLeftPosition,
      right: this.compareBtnRightPosition,
      top: this.compareBtnYPosition,
    })
  }

  private isShowCompareBtn(): boolean {
    return !this.editor.stylusMode && this.editor.tabIndex != TabName.TabCrop &&
    this.isContrastModified() &&
      (!this.editor.immersiveMode || DeviceUtil.isPc());
  }

  isContrastModified(): boolean {
    if (this.editor.tabIndex === TabName.TabMosaic) {
      return this.mosaicAttr.canUndo;
    }
    HiLog.i(TAG, 'isShowCompare is ' + this.editor.editCounter);
    return this.editor.editCounter > 0;
  }

  // 按对比按钮上报
  compareTouch(touchType: TouchType): void {
    HiLog.i('Compare', 'TouchEvent enter');

    // 截取、调色、滤镜原色对比
    if (this.editor.tabIndex !== TabName.TabCrop) {
      if (touchType === TouchType.Down || touchType === TouchType.Move) {
        if (this.originalColorMode === 1) {
          return;
        }
        HiLog.i('MainContent', 'setOriginalColorMode 1, event.type down');
        this.asset.textEdit().isComparing = true;
        this.asset.mosaic().setComparing(true);
        this.asset.isTouching = true;
        this.editor.asset.setOriginalColorMode(1);
        this.originalColorMode = 1;
      } else if (touchType === TouchType.Up || touchType === TouchType.Cancel) {
        HiLog.i('MainContent', 'setOriginalColorMode 0, event.type up');
        clearTimeout(touchUpTimeFn);
        this.asset.textEdit().isComparing = false;
        touchUpTimeFn = setTimeout(() => {
          // 标识延时50ms设置，避免与父组件或兄弟onTouch事件冲突
          this.asset.isTouching = false;
        }, 50)
        this.asset.mosaic().setComparing(false);
        this.editor.asset.setOriginalColorMode(0);
        this.originalColorMode = 0;
      }
    }
  }
}