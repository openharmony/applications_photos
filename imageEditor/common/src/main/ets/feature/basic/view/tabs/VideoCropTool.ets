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
import { ScaleSelection } from '../../common/view/ScaleSelection';
import { RulerBar } from '../../../../common/components/RulerBar';
import { App, BaseEditor, TabName } from '../../../../service/App';
import { Asset, CropAttr, OperationTip, } from '../../../../service/BaseEditor';
import { ButtonItem } from '../../common/view/SelectableProgressButton';
import { HiLog } from '../../../../common/util/HiLog';
import {
  ALT_RULER_END_OPT,
  ALT_RULER_START_OPT,
  AppColor,
  CROP_ROT_MIR_SIZE,
  DEVICE_FOLD_STATUS,
  FOLD_PHONE_RULER_END_OPT,
  PAD_RULER_END_OPT,
  PAD_RULER_START_OPT,
  PHONE_RULER_END_OPT,
  PHONE_RULER_START_OPT,
  SCREEN_ORIENTATION_PORTRAIT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  SCROLL_SHADOW_WIDTH,
  CropIndex,
  EPSILON,
  WINDOW_STATUS_KEY
} from '../../../../common/const';
import display from '@ohos.display';
import { UiUtil } from '../../../../common/util/UiUtil';
import { Constants } from '../../../../common/util/Constants';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { LengthMetrics } from '@kit.ArkUI';
import { accessibility } from '@kit.AccessibilityKit';
import sdk from '../../../../service/native';
import { Algorithms } from '../../../../service/model/Enum';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Extend(Image)
function myImage() {
  .width('24vp')
  .height('24vp')
  .fillColor(AppColor.white())
  .objectFit(ImageFit.Contain)
  .draggable(false)
}

@Extend(SymbolGlyph)
function iconStyle() {
  .fontSize($r('app.float.icon_size'))
  .fontColor([AppColor.white()])
  .draggable(false)
}
@Extend(SymbolGlyph)
function symIconStyle() {
  .fontSize('16vp')
  .fontColor([AppColor.white()])
  .draggable(false)
}

@Extend(Circle)
function circleBack(isChosen: number) {
  .width('48vp')
  .height('48vp')
  .fill(isChosen === 1 ? '#DBDBDB' : '#2F2F2F')
  .padding('0 160px')
  .opacity(isChosen === 2 ? 0.4 : 1)
}

@Extend(Text)
function textStyle(isChosen: number, numOfRotations: number) {
  .fontColor('#FFFFFF')
  .height('14vp')
  .fontSize('10fp')
  .maxFontScale(1)
  .margin({ top: '4vp' })
  .maxLines(1)
  .textOverflow({ overflow: isChosen && numOfRotations < 3 ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
  .opacity(isChosen === 1 ? 0.9 : 0.6)
}

@Extend(Image)
function subMenu(isChosen: number) {
  .width('24vp')
  .height('24vp')
  .fillColor(isChosen === 1 ? '#000000' : '#FFFFFF')
  .draggable(false)
}

@Extend(SymbolGlyph)
function subMenuSym(isChosen: number) {
  .fontSize($r('app.float.icon_size'))
  .fontColor([isChosen === 1 ? '#000000' : '#FFFFFF'])
  .draggable(false)
}

@Extend(Button)
function rotateFrame(isVertical: boolean) {
  .width(isVertical ? 36 : '100%')
  .height(isVertical ? '100%' : 36)
  .margin(isVertical ? { right: 12 } : {})
  .backgroundColor(AppColor.black(0))
  .flexShrink(0)
}

@Extend(Button)
function sysRotateFrame() {
  .backgroundColor(AppColor.black(0))
  .flexShrink(0)
}

@Extend(Button)
function mirrorFrame(isVertical: boolean) {
  .width(isVertical ? 36 : '100%')
  .height(isVertical ? '100%' : 36)
  .margin(isVertical ? { left: 12 } : {})
  .backgroundColor(AppColor.black(0))
  .flexShrink(0)
}

@Extend(Button)
function sysMirrorFrame() {
  .backgroundColor(AppColor.black(0)) // 穿透效果
  .flexShrink(0)
}

@Extend(Flex)
function centerStyle() {
  .flexGrow(1)
}

let ratioCropTimeFn: number;
let optimalRectUnderRatio: number;
const TAG = 'VideoCropTool';
const SMALL_VIBRATE_GAP: number = 3;
const BIG_VIBRATE_GAP: number = 15;
const FAST_SCROLL_VIBRATE_GAP: number = 12;
const NINETY_DEGREE: string='90°';

@Component
export struct VideoCropTool {
  @State @Watch('changeProgress') cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State stateClosed: boolean = false // 滑动条是否置灰
  @State stateChange: number = 0 // 滑动条状态切换
  @State isClick: boolean = false;
  @State hasBgColor: boolean = false;
  @State reset: number = 0;
  @State isTouchScroll: boolean = false;
  @State scrollWidth: number = 260;
  @State operationTip: OperationTip = App.getInstance().myEditor().operationTip;
  @State optArray: number[] = new Array(this.cropsAttr.cropTabs.length).fill(1);
  @State progressVal: number = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
  @State @Watch('stopScrolling') editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(WINDOW_STATUS_KEY) isSmallWindowMode: boolean = ScreenManager.getInstance().getSmallWindowMode();
  @StorageProp(DEVICE_FOLD_STATUS) isFold: boolean = ScreenManager.getInstance().isDeviceFold();
  @StorageProp(WIN_WIDTH_KEY) @Watch('changeScale') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('changeScale') winHeight: number = ScreenManager.getInstance().height;
  @State widthScale: number = ScreenManager.getInstance().getWidthScale();
  @State heightScale: number = ScreenManager.getInstance().getHeightScale();
  private scroller: Scroller = new Scroller();
  private fingerX: number = 0;
  private fingerY: number = 0;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;
  @State selectedState: number = 0; //0代表未选中，1代表选中且高亮
  @State isInitRulerBarData: boolean = false;
  private intelligentCorrectionStatus: boolean = UiUtil.checkAlgorithms(Algorithms.IntelligentCorrection);
  @State buttonHoverStates: boolean[] = Array(this.cropsAttr.cropTabs.length).fill(false);
  @State isRotateBtnHover: boolean = false;
  @State isMirrorBtnHover: boolean = false;
  private originDegree: number = 361;
  private IntelligentCorrectionError: number = 720;
  private moveDegree: number = 0;
  private timer: number | null = null;
  @Consume @Watch('onButtonFreezeChange') isButtonFreeze: boolean;
  // tab文本轮播次数
  @State numOfRotations: number = 0;
  @LocalStorageProp('currentLanguage') currentLanguage: string = ''; //获取当前语言
  @StorageProp('currentLanguage') language: string = '';
  // 控制文本换行
  @State fontScale: number = ScreenManager.getInstance().getFontSizeScale()
  @State allowWrap: boolean = false;
  @State fontSize: string = this.fontScale < 1.45 ? '12vp' : '17.5vp';
  private isChinese: boolean = (this.currentLanguage || this.language)?.trim().toLowerCase().startsWith('zh')

  onButtonFreezeChange() {
    HiLog.i(TAG, `isButtonFreeze change: ${this.isButtonFreeze}`);
  }

  executeIntelligentCorrection(): number {
    let intelligentDegree: number =
      sdk.Asset_getIntelligentCorrectionValue(this.editor.timeline.id, this.asset.uid);
    if (intelligentDegree === this.IntelligentCorrectionError) {
      HiLog.i(TAG, 'executeIntelligentCorrection is Failed');
      UiUtil.showToast($r('app.string.replace_face_fail'), 2000, '21.2%');
      return 1;
    }
    this.progressVal = intelligentDegree;
    HiLog.i(TAG, 'executeIntelligentCorrection intelligentDegree:' + intelligentDegree)
    let scrollValue: number = this.cropsAttr.cropTabs[CropIndex.ROTATE].value;
    HiLog.i(TAG, 'executeIntelligentCorrection scrollValue:' + scrollValue)
    let distance: number = intelligentDegree - scrollValue;
    let sign: number = distance >= 0 ? 1 : -1;
    HiLog.i(TAG, 'distance: %{public}i', distance);
    /* instrument ignore next */
    if (Math.abs(distance) <= EPSILON) {
      HiLog.i(TAG, 'No slant detected');
      UiUtil.showToast($r('app.string.no_picture_tilt_is_detected'), 2000, '21.2%');
    } else {
      HiLog.i(TAG, 'execute intelligent correction');
      this.startAnimation(distance, sign);
    }
    return 0;
  }

  startAnimation(distance: number, sign: number): void {
    // 动画过程中不记录撤销
    this.editor.isStartOperate = true;
    this.editor.startEditorOperate();
    this.cropsAttr.isClickUndoRedo = false;

    this.moveDegree = 0;
    this.originDegree = this.cropsAttr.cropTabs[CropIndex.ROTATE].value;
    let origin: number = this.originDegree;
    clearInterval(this.timer);
    this.timer = setInterval(() => this.executeAnimation(origin, distance, sign), 1);
  }

  /* instrument ignore next */
  executeAnimation(origin: number, distance: number, sign: number): void {
    let exact: number = Number(this.moveDegree.toFixed(1));
    if (Math.abs(exact) < Math.abs(distance)) {
      this.moveDegree += (0.1 * sign);
      exact = Number(this.moveDegree.toFixed(1));
      let degree: number = Number((exact + origin).toFixed(1));
      HiLog.i(TAG, 'executeAnimation distance: %{public}i', distance);
      // 智能校正实际是修改旋转值
      this.cropsAttr.cropTabs[CropIndex.ROTATE].value = degree;
      this.cropsAttr.setRotation(this.cropsAttr.cropTabs[CropIndex.INTELLIGENT].key, degree);
    } else {
      // 旋转结束后赋值
      this.cropsAttr.cropTabs[CropIndex.INTELLIGENT].value = exact;
      this.endScroller();
      this.stopAnimation();
      HiLog.i(TAG, 'stopAnimation this.cropsAttr.cropTabs[CropIndex.INTELLIGENT].value: %{public}i', exact);
    }
  }

  stopAnimation(): void {
    // instrument ignore if
    if (this.timer !== null) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  changeScale() {
    this.widthScale = ScreenManager.getInstance().getWidthScale();
    this.heightScale = ScreenManager.getInstance().getHeightScale();
    this.scrollDistance = 0;
    this.handleScroll();
  }

  aboutToAppear() {
    this.cropsAttr.switchCropPage(this.cropsAttr.cropMenuIndex);
    this.cropsAttr.isClickUndoRedo = false;
  }

  stopScrolling(): void {
    if (this.editor.isStopScrolling) {
      this.isClick = true;
      this.stateChange++
    }
  }

  changeProgress(): void {
    let isChangeProgress = (this.editor.isEdit && this.editor.isOpenInitReset) || (this.cropsAttr.isClickUndoRedo &&
      (this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].key === this.cropsAttr.redoCropItem)) &&
      this.progressVal != this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;

    HiLog.d(TAG, `changeProgress isChange=${isChangeProgress}, isReset=${this.cropsAttr.isResetCrop}, ` +
      `oldVal=${this.progressVal}, newVal=${this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value}`);

    if (isChangeProgress || this.cropsAttr.isResetCrop) {
      this.progressVal = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
      if (this.editor.isOpenInitReset) {
        this.isInitRulerBarData = true;
      }
      this.stateChange++;
      this.cropsAttr.isResetCrop = false;
    } else {
      this.cropsAttr.isClickUndoRedo = false;
    }
  }

  handleScroll(state?: ScrollState) {
    /* instrument ignore if */
    if (!this.scroller.currentOffset()) {
      return;
    }
    const scrollDistance = (
      this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0 ? true : false;
    /* instrument ignore if */
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance ? true : false;
  }

  aboutToDisappear() {
    this.cropsAttr.isScrolling = false;
    this.cropsAttr.onDisappear();
  }

  build() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
      justifyContent: FlexAlign.Center,
    }) {
      this.subCrop();
      this.subMenu();
    }
    .enabled(!this.isButtonFreeze)
    .id('petalclip_CropTool_CropTool')
  }

  @Builder
  subCrop() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      justifyContent: DeviceUtil.isPad() || !this.isFold && !this.isScreenPortrait ? FlexAlign.Center :
      FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center,
      space: {main: LengthMetrics.px(10)}
    }) {
      if (this.isScreenPortrait) { //UX要求横屏时镜像在前，旋转在后。同时需要保证TAB走焦顺序
        this.rotateBtn()
      } else {
        this.mirrorBtn();
      }
      if (this.cropsAttr.cropMenuIndex !== CropIndex.INTELLIGENT) {
        if (this.isRulerScroller()) {
          this.rulerScroller();
        } else {
          this.cropRatio();
        }
      }
      if (this.isScreenPortrait) { //UX要求横屏时镜像在前，旋转在后。同时需要保证TAB走焦顺序
        this.mirrorBtn()
      } else {
        this.rotateBtn();
      }
    }
    .width(this.isScreenPortrait ? '100%' : 56)
    .id('petalclip_CropTool_subCrop')
    .height(this.isScreenPortrait ? 56 : '100%')
    .margin({ top: this.isScreenPortrait ? 8 : 0, left: this.isScreenPortrait ? 0 : 8 })
    .padding(this.isScreenPortrait ? ((DeviceUtil.isPad() && !this.isSmallWindowMode) ||
      (!this.isFold && (Math.abs(this.widthScale - 1) < 1e-10))) ? { left: 72, right: 72 } : {
      left: ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight(),
      right: ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight(),
    } :
      {}
    )
  }

  isRulerScroller(): boolean {
    return (this.cropsAttr.cropMenuIndex === CropIndex.ROTATE ||
      this.cropsAttr.cropMenuIndex === CropIndex.HORIZONTAL ||
      this.cropsAttr.cropMenuIndex === CropIndex.VERTICAL) && !this.cropsAttr.enableRatio;
  }

  getStartOptNum() {
    // instrument ignore if
    if (DeviceUtil.isFoldable() && this.isFold) {
      return PHONE_RULER_START_OPT;
    } else if ((!DeviceUtil.isFoldable() && DeviceUtil.isPhone()) || (DeviceUtil.isPad() && !this.isScreenPortrait)) {
      return PHONE_RULER_START_OPT;
    } else if (DeviceUtil.isPad()) {
      return PAD_RULER_START_OPT;
    } else {
      return ALT_RULER_START_OPT;
    }
  }

  getEndOptNum() {
    // instrument ignore if
    if (DeviceUtil.isFoldable() && this.isFold) {
      return FOLD_PHONE_RULER_END_OPT;
    } else if ((!DeviceUtil.isFoldable() && DeviceUtil.isPhone()) || (DeviceUtil.isPad() && !this.isScreenPortrait)) {
      return PHONE_RULER_END_OPT;
    } else if (DeviceUtil.isPad()) {
      return PAD_RULER_END_OPT;
    } else {
      return ALT_RULER_END_OPT;
    }
  }

  @Builder
  rulerScroller() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
    }) {
      if (this.editor.tabIndex === TabName.TabCrop) {
        RulerBar({
          progress: this.progressVal,
          stateChange: this.stateChange,
          min: this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].min,
          max: this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].max,
          visibleWidth: this.scrollWidth,
          stateClosed: this.stateClosed,
          snappingValue: 0,
          gapVal: 1,
          showGapNum: 5,
          startOptical: this.getStartOptNum(),
          endOptical: this.getEndOptNum(),
          isSnapping: true,
          isInitData: this.isInitRulerBarData,
          onProgressChange: (val: number, isFastScroll: boolean) => {
            let scrollVal = Number(val.toFixed(1));
            let originNum = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
            this.progressVal = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
            if (Number(originNum.toFixed(1)) === scrollVal) {
              this.cropsAttr.isClickUndoRedo && (this.cropsAttr.isClickUndoRedo = false);
              this.operationTip.value = Math.round(val).toString();
              return;
            }
            if (!this.editor.isStartOperate && !this.cropsAttr.isClickUndoRedo) {
              this.editor.isStartOperate = true;
              this.editor.startEditorOperate();
              this.cropsAttr.isClickUndoRedo = false;
            }
            this.cropsAttr.isClickUndoRedo && (this.cropsAttr.isClickUndoRedo = false);
            this.scrollVibrate(scrollVal, isFastScroll);
            this.operationTip.value = Math.round(val).toString();
            /* instrument ignore if */
            if (this.cropsAttr.cropMenuIndex === CropIndex.RATIO || this.isClick) {
              // 解决刻度条惯性滑动过程中切换比例页crash
              return;
            }
            this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value = scrollVal;
            this.cropsAttr.setRotation(this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].key, scrollVal);
          },
          onTouchMovingChange: (val: boolean) => {
            this.isTouchScroll = val;
            if (val && this.editor.interrupt) {
              this.editor.setCropReactInterrupt(false);
            }
            this.editor.asset.overSizePrompt();
          },
          onStateClosedChange: (val: boolean) => {
            this.stateClosed = val;
            /* instrument ignore if */
            if (this.stateClosed === false && this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].state !== 1) {
              this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].state = 1;
            }
          },
          onScrollStart: () => {
            if (this.editor.tabIndex === TabName.TabCrop) {
              this.cropsAttr.isEnableBlur = false;
            }
            this.asset.isTouching = true;
            animateTo({
              duration: 100,
              onFinish: () => {
              }
            }, () => {
              this.operationTip.isShowNum = true;
              this.cropsAttr.isScrolling = this.isTouchScroll;
            })
          },
          onEnd: () => {
            this.endScroller();
          }
        })
      }
    }
    .onAreaChange((_: Area, newValue: Area) => {
      let width = this.isScreenPortrait ? (newValue.width as number) : (newValue.height as number);
      (width != this.scrollWidth || _.width != newValue.width) && (this.scrollWidth = width) && (this.stateChange++);
    })
    .id('petalclip_CropTool_rulerScroller')
    .accessibilityLevel('yes')
    .accessibilityText((this.cropsAttr.cropMenuIndex === 0 ||
      this.cropsAttr.cropMenuIndex - 1 >= this.cropsAttr.cropScrollerTexts.length)
      ? ''
      : this.cropsAttr.cropScrollerTexts[this.cropsAttr.cropMenuIndex - 1]?.getString(this.progressVal)
    )
    .centerStyle();
  }

  handleTabTextMarqueeStateChange = (state: MarqueeState) => {
    if (state === MarqueeState.BOUNCE) {
      this.numOfRotations++;
    }
  };

  endScroller() {
    this.editor.stopEditorOperate();
    this.editor.isStartOperate = false;
    if (this.editor.tabIndex === TabName.TabCrop) {
      this.cropsAttr.isEnableBlur = true;
    }
    this.asset.isTouching = false;
    this.progressVal = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;

    this.editor.interrupt = false;
    animateTo({
      duration: 100,
      onFinish: () => {
      }
    }, () => {
      this.operationTip.isShowNum = false;
      this.cropsAttr.isScrolling = false;
    })
    this.cropsAttr.updateIsModify();
    if (this.editor.isEdit) {
      this.editor.isShowRevert = !this.editor.isEdited();
    }
    if (accessibility.isOpenAccessibilitySync() && this.cropsAttr.cropMenuIndex > 0 &&
      this.cropsAttr.cropMenuIndex - 1 < this.cropsAttr.cropAngleAdjustmentTexts.length) {
      const text =
        this.cropsAttr.cropAngleAdjustmentTexts[this.cropsAttr.cropMenuIndex - 1]?.getString(this.progressVal) || '';
      let eventInfo: accessibility.EventInfo = ({
        type: 'announceForAccessibility',
        bundleName: 'com.ohos.photos',
        triggerAction: 'common',
        textAnnouncedForAccessibility: text
      });
      accessibility.sendAccessibilityEvent(eventInfo).then(() => {
        HiLog.i(TAG, `crop onEnd, sendAccessibilityEvent progressVal=${this.progressVal}`);
      });
    }
  }

  @Builder
  rotateBtn() {
  Button({stateEffect:false}) {
    Row() {
      Image($r('app.media.edit_rorate_left'))
        .width('16vp')
        .height('16vp')
        .draggable(false)
      Text($r('app.string.image_editor_rotate_ninety_degrees_new',NINETY_DEGREE))
        .fontSize(UiUtil.getFontSize(this.currentLanguage,this.language,this.fontScale))
        .fontColor('#E5FFFFFF') // 设置字体颜色为 #E5FFFFFF（带透明度的白色）
        .margin({ left: 4 })
        .width('calc(100% - 16vp)') // 减去图片和边距占用的宽度
        .maxFontScale(1.45)
        .maxLines(this.isChinese? 1: 2)
        .textOverflow({overflow:TextOverflow.None})
        .textAlign(TextAlign.Center)
    } // 设置 Row 容器的内边距
    .padding({
      left: 3,
      top: 5,
      bottom: 5,
      right: 7.5
    })
    // 设置 Row 内容垂直居中对齐
    .alignItems(VerticalAlign.Center)
  }
    .width(UiUtil.getWidthSize(this.currentLanguage,this.language,this.fontScale))
    .height('28vp')
    .borderRadius('56vp')
    .sysRotateFrame()
    .backgroundColor(AppColor.white(0.1)) // TODO
    .onClick(() => {
    if (this.editor.interrupt) {
    this.editor.setCropReactInterrupt();
  }
    this.editor.asset.crops().rotate90Acw();
    if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
    }
  })
  .onHover((isHover: boolean) => {
  this.isRotateBtnHover = isHover;
})
  .id('petalclip_CropTool_rotateBtn')
  .enabled(true)
  .accessibilityLevel('yes')
  .accessibilityText(UiUtil.getResourceString($r('app.string.crop_rotation_btn')))
}

  @Builder
  mirrorBtn() {
    Button({ stateEffect: false }) {
      Row() {
        SymbolGlyph($r('sys.symbol.line_arrowtriangle_2_inward')).symIconStyle()
          .width('16vp')
          .height('16vp')
          .draggable(false)
        Text($r('app.string.image_editor_mirror_image_new'))
          .fontSize(UiUtil.getFontSize(this.currentLanguage,this.language,this.fontScale))
          .fontColor('#E5FFFFFF') // 设置字体颜色为 #E5FFFFFF（带透明度的白色）
          .maxFontScale(1.45)
          .width('calc(100% - 16vp)') // 减去图片和边距占用的宽度
          .maxLines( this.isChinese? 1: 2)
          .textOverflow({overflow:TextOverflow.None})
          .textAlign(TextAlign.Center)
      }
      .padding({
        left: 6.5,
        top: 6,
        bottom: 6,
        right: 7.5
      })
      .alignItems(VerticalAlign.Center) // 对应 align-items: center
    }
    .width(UiUtil.getWidthSize(this.currentLanguage,this.language,this.fontScale))
    .height('28vp')
    .borderRadius('56vp')
    .sysMirrorFrame()
    .backgroundColor(AppColor.white(0.1))
    .onClick((): void => {
      if (this.editor.interrupt) {
        this.editor.setCropReactInterrupt();
      }
      HiLog.i(TAG, 'Click mirror');
      this.cropsAttr.setMirror(this.cropsAttr.mirrorFlag ? 0 : 1, this.cropsAttr.mirrorType);
      if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
      }
    })
    .onHover((isHover: boolean) => {
      this.isMirrorBtnHover = isHover;
    })
    .id('petalclip_CropTool_mirrorBtn')
    .enabled(true)
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.crop_mirror_btn')))
  }

  @Builder
  menuItem(item: ButtonItem, index: number) {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Circle().circleBack(this.isChosen(index, item))
        // instrument ignore if
        if (item.isSymbolGlyph) {
          SymbolGlyph(item.icon).subMenuSym(this.isChosen(index, item))
        } else {
          Image(item.icon).subMenu(this.isChosen(index, item))
        }
      }

      Text(item.text)
        .onMarqueeStateChange(this.handleTabTextMarqueeStateChange)
        .textStyle(this.isChosen(index, item), this.numOfRotations);
    }
  }

  isChosen(index: number, item: ButtonItem): number {
    return index === CropIndex.INTELLIGENT ?
    this.selectedState : (this.cropsAttr.cropMenuIndex === index ? 1 : 0);
  }

  @Builder
  subMenu() {
    Column() {
      Scroll(this.scroller) {
        Flex({
          direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
          alignItems: ItemAlign.Center,
        }) {
          Blank()
          ForEach(this.cropsAttr.cropTabs, (item: ButtonItem, index?: number) => {
            if (index !== undefined && (index !== CropIndex.INTELLIGENT || this.intelligentCorrectionStatus)) {
              Stack({ alignContent: Alignment.Center }) {
                this.menuItem(item, index);
              }
              .margin({
                start: LengthMetrics.vp(this.isScreenPortrait && index > 0 ? 2 : 0),
                top: LengthMetrics.vp(!this.isScreenPortrait && index > 0 ? 16 : 0)
              })
              .height(66)
              .width(66)
              .accessibilityText(UiUtil.getResourceString(
                this.cropTextResource(this.cropsAttr.cropMenuIndex, index, item)))
              .accessibilityRole(AccessibilityRoleType.BUTTON)
              .backgroundColor(AppColor.black(0))
              .id('cropTab_' + item.key + (this.cropsAttr.cropMenuIndex == index ? '_on' : '_off'))
              .onClick((): void => {
                let costTime = 0;
                let status = 0;
                let startTime = new Date().getTime();
                // instrument ignore if
                if (this.asset.isGestureOperate || this.asset.isTouching) {
                  HiLog.i(TAG, 'gesture operate cannot click crop submenu');
                  return
                }
                // instrument ignore if
                if (this.editor.interrupt) {
                  this.editor.setCropReactInterrupt();
                }
                this.editor.asset.overSizePrompt();
                // instrument ignore if
                if (index === undefined) {
                  HiLog.e(TAG, 'unexpected scroll index');
                  return;
                }
                // 重复点击非智能校正按钮
                // instrument ignore if
                if (index === this.cropsAttr.cropMenuIndex && index !== CropIndex.INTELLIGENT) {
                  return;
                }
                this.cropsAttr.cropMenuIndex = index;
                this.cropsAttr.enableRatio = (index === CropIndex.RATIO);
                this.cropsAttr.isScrolling = false;
                if (this.progressVal != this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value) {
                  this.progressVal = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
                  this.stateChange++;
                }
                if (index === CropIndex.INTELLIGENT) {
                  if (this.selectedState === 1) {
                    this.selectedState = 0;
                    this.cropsAttr.cropTabs[CropIndex.ROTATE].value = 0;
                    this.cropsAttr.setRotation(this.cropsAttr.cropTabs[CropIndex.INTELLIGENT].key, 0);
                  } else {
                    this.selectedState = 1;
                    status = this.executeIntelligentCorrection();
                  }
                } else {
                  this.selectedState = 0;
                }
                costTime = new Date().getTime() - startTime;
                HiLog.i(TAG, 'intelligentDegree cost total:' + costTime);
                let msg: Record<string, number | string | boolean> = {};
                msg = {
                  'cropName': item.key,
                  'strength': Math.round(this.progressVal),
                  'status': status,
                  'costTime': costTime
                };
                this.cropsAttr.switchCropPage(index);
                this.numOfRotations = 0;
              })
              .backgroundColor(this.buttonHoverStates[index] ? $r('sys.color.ohos_id_color_hover_transparent') :
              Color.Transparent)
              .borderRadius(6)
              .onHover((isHover: boolean) => {
                this.buttonHoverStates[index] = isHover;
              })
            }
          }, (item: ButtonItem) => item.key)
          Blank()
        }
        .id('petalclip_CropTool_subMenu')
        .padding({
          top: this.isScreenPortrait ? 12 : 0,
          bottom: this.isScreenPortrait ? 18 : 0,
        })
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollable(this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .onDidScroll((x: number, y: number, state: ScrollState) => {
        this.handleScroll(state);
      })
      .onScrollEdge((side: Edge) => {
        // instrument ignore if
        if (side === Edge.Start || side === Edge.Top) {
          this.isShowShadowStart = false;
        } else {
          this.isShowShadowStart = true;
        }
        // 3: Edge.End
        // instrument ignore if
        if (side === 3 || side === Edge.Bottom) {
          this.scrollDistance = (
            this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
          ) ?? 0;
          this.isShowShadowEnd = false;
        } else {
          this.isShowShadowEnd = true;
        }
      })
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
  cropRatio() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
    }) {
      ScaleSelection({
        selectValue: this.cropsAttr.scale,
        onActive: (value: number, ratio: string, index: number, key: string) => {
          clearTimeout(ratioCropTimeFn);
          clearTimeout(optimalRectUnderRatio);
          let hasSplitLine = this.editor.asset.crops().hasSplitLine;
          let interrupt = this.editor.interrupt;
          HiLog.i(TAG, `hasSplitLine: ${hasSplitLine} interrupt: ${interrupt}`);
          // instrument ignore if
          if (this.editor.interrupt) {
            this.editor.setCropReactInterrupt();
          }
          this.editor.asset.overSizePrompt();
          HiLog.i(TAG, `cropRatio value: ${value} ratio: ${ratio} index: ${index}`);

          value = value === -2 ? this.getPaveRatio() : value;
          this.cropsAttr.ratio = ratio;
          this.cropsAttr.cropMenuIndex = CropIndex.RATIO;
          this.editor.timeline.timeProgressImmersiveMode = true;
          ratioCropTimeFn = setTimeout((): void => {
            this.editor.timeline.timeProgressImmersiveMode = false;
          }, 400)

          // 首次切换到自由比例不需要调用SDK setCropRect接口，防止打断动画
          if (value == 0) {
            App.getInstance()
              .myEditor()
              .asset
              .crops()
              .clipRatio = 0;
            return;
          }

          optimalRectUnderRatio = setTimeout(() => {
            App.getInstance().myEditor().asset.calcOptimalRectUnderRatio(value, 400);
          }, hasSplitLine && interrupt ? 30 : 0)
        }
      })
    }
    .centerStyle()
    .id('petalclip_CropTool_cropRatio')
  }

  /* instrument ignore next */
  touchBtnOperate(isRotate: boolean, event: TouchEvent) {
    if (!event || this.asset.isGestureOperate || this.asset.isTouching) {
      HiLog.i(TAG, 'touchBtnOperate invalid');
      return
    }
    if (event.type == TouchType.Down) {
      this.fingerX = event.touches[0].windowX;
      this.fingerY = event.touches[0].windowY;
    }
    if (event.type === TouchType.Up) {
      if (Math.abs(event.touches[0].windowX - this.fingerX) > Constants.CROP_BTN_TOUCH_HOT_AREA ||
        Math.abs(event.touches[0].windowY - this.fingerY) > Constants.CROP_BTN_TOUCH_HOT_AREA) {
        HiLog.e(TAG, 'touch out of hot area');
        return;
      }
      if (this.editor.interrupt) {
        this.editor.setCropReactInterrupt();
      }
      if (isRotate) {
        HiLog.i(TAG, 'touchBtnOperate rotate 90');
        this.editor.asset.crops().rotate90Acw();
      } else {
        HiLog.i(TAG, 'touchBtnOperate mirror');
        this.cropsAttr.setMirror(this.cropsAttr.mirrorFlag ? 0 : 1, this.cropsAttr.mirrorType);
      }
    }
  }

  getPaveRatio(): number {
    let paveRatio: number = 1;
    try {
      let displayClass = display.getDefaultDisplaySync();
      paveRatio = this.isScreenPortrait ? displayClass.width / displayClass.height : displayClass.height /
      displayClass.width;
    } catch (err) {
      HiLog.e(TAG, 'get screen info failed');
    }
    return paveRatio;
  }

  scrollVibrate(scrollVal: number, isFastScroll: boolean) {
    let vibrateInterval: number = isFastScroll ? FAST_SCROLL_VIBRATE_GAP : SMALL_VIBRATE_GAP;
    let isVibrate: boolean =
      Math.floor(this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value / vibrateInterval) !==
      Math.floor(scrollVal / vibrateInterval);
    if (isVibrate) {
      let vibrateId: string =
        isFastScroll || (scrollVal % BIG_VIBRATE_GAP === 0) ? UiUtil.CAMERA_GEAR_SLIP_HEAVY_ID :
        UiUtil.CAMERA_GEAR_SLIP_LIGHT_ID;
      UiUtil.vibrateById(vibrateId);
    } // 旋转角度值发生变化时振动
  }

  cropTextResource(curIndex: number, index: number, buttonItem: ButtonItem): Resource {
    if (index === CropIndex.INTELLIGENT) {
      if (this.selectedState === 1) {
        return this.cropsAttr.cropTexts[index].text;
      } else {
        return buttonItem.text
      }
    }
    if (curIndex === index) {
      if (this.cropsAttr.cropTexts[index].text !== null) {
        return this.cropsAttr.cropTexts[index].text;
      }
    }
    return buttonItem.text
  }
}
