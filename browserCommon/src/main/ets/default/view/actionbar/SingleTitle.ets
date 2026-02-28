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

/* instrument ignore file */

import lazy { ActionBarColorMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy measure from '@ohos.measure';
import lazy { LengthMetrics } from '@kit.ArkUI';
import type { DisplayName } from '@ohos/common/src/main/ets/default/model/common/DataTypes';

const TAG: string = 'common_SingleTitle';

/**
 * 文本框允许最大行数
 */
const MAX_LINE_COUNT: number = 2;

const MAX_LINE_COUNT_TIMELINE: number = 1;
/**
 * 标题距离左侧间距
 */
const TITLE_MARGIN_LEFT: number = 4;

const SUB_TITLE_TOP: number = 2;

/**
 * 单行标题，显示内容固定
 */
@Component
export struct SingleTitle {
  @Link @Watch('updateTitle') actionBarProp: ActionBarProp;
  @Prop dateString: string = '';
  @Prop dateTitleOpacity: number = 0;
  @Prop actionTitleOpacity: number = 1;
  public isDoubleLineTitle: boolean = this.actionBarProp.getIsLevelOneHeadTitle();
  public isTimelinePageHeadTitle: boolean = false;
  @Prop private isShowSideBar: boolean;
  /* instrument ignore next */
  @Prop private isGroupDayView: boolean = false;
  /* instrument ignore next */
  private defaultFlexRow: number = 1;
  /* instrument ignore next */
  @Prop immersiveController: ImmersiveController;
  /* instrument ignore next */
  @Prop timeController: TimeController;
  /* instrument ignore next */
  @Prop subLocalityAddress: string;
  /* instrument ignore next */
  @Prop isShowAddress: boolean = false;
  /* instrument ignore next */
  @Prop isShowDateString: boolean = false;
  @Prop isEllipsis: boolean = true;
  @State private singleTitleHeight: number = 56;
  private minHeight: number = 56;
  private dateLineHeight: number = DeviceInfo.isTv() ? 35 : 29;
  private addressLineHeight: number = 19;
  private addressOffY: number = 10;
  // 地址信息绝对定位，父组件有padding时子组件相对于内边缘偏于，posY = singleTitleHeight - addressOffY - this.paddingTop;
  @State private addressPosY: number = 32.5;
  // 通过设置顶部padding的方式保证日期换行后，第一行仍与右侧按钮居中对齐
  // paddingTop = (按钮高度 - dateLineHeight) / 2
  private paddingTop: number = DeviceInfo.isTv() ? 12 : 13.5;
  // 设置底部padding保证日期换行后地址与日期文字之间的边距不变
  private paddingBottom: number = 10;
  @StorageLink('isHorizontal') @Watch('updateTitleFontSize') private isHorizontal: boolean = false;
  @StorageLink('getFoldStatus') @Watch('updateTitleFontSize') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @Prop @Watch('updateTitleFontSize') isPageEmpty: boolean = false;
  @State private timelineTitleFontSize: Resource = this.getTimeLineTitleFontSize();
  @State private nonSystemAlbumTitleFontSize: Resource = this.getNonSysAlbumTitleFontSize();
  @Prop private actionBarHeight: Length;
  @Prop private isSelected: boolean;
  @Prop private isHiddenIfSideBar: boolean = false;
  private useOtherTitleLineHeight: boolean = true;
  private timer: number = -1;
  private firstTimer: number = -1;
  @State private isShowFullName: boolean = false;
  @State private isTextOver: boolean = false;
  @Link private titleWidth: number;
  private mainTitleTopPadding: number = 5;
  @State title: DisplayName = '';
  @State @Watch('updateTitle') titleVisibility: Visibility = Visibility.Hidden;

  aboutToAppear(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.isTimelinePageHeadTitle) {
      this.paddingBottom = 0;
    }
    Log.info(TAG, `isLevelOneHeadTitle: ${this.isDoubleLineTitle}, ` +
      `title: ${this.actionBarProp.getTitle()}, enable: ${this.immersiveController?.enable ? true : false}`);
  }

  /**
   * 时间线双行标题字体大小
   */
  private getTimeLineTitleFontSize(): Resource {
    if (this.isPageEmpty && DeviceInfo.isPhoneUx()) {
      return ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE;
    }
    // xxxxxx或者手机横屏状态
    if (DeviceInfo.isFoldable() || (DeviceInfo.isPhoneUx() && this.isHorizontal)) {
      return ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE;
    }
    if (DeviceInfo.isPc() || (DeviceInfo.isPhoneUx() && !this.isHorizontal)) {
      return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    }

    return this.actionBarProp.getIsHeadTitle()
      ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE
  }

  /**
   * 用户相册，分类相册，搜索界面使用的单行标题字体大小
   */
  private getNonSysAlbumTitleFontSize(): Resource {
    if (DeviceInfo.isPc() || DeviceInfo.isFoldablePhone() || (DeviceInfo.isPhoneUx() && !this.isHorizontal)) {
      return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    }

    return this.actionBarProp.getIsHeadTitle()
      ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE
  }

  private getTopPadding(): number | Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return 0;
    }
    return this.isTimelinePageHeadTitle ? this.paddingTop : $r('sys.float.padding_level2')
  }

  private getSingleTitleHeight(): Length {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return this.actionBarHeight;
    }
    return 'auto';
  }

  private getVisibility(): Visibility {
    if (this.isSelected || (this.isHiddenIfSideBar && this.isShowSideBar && DeviceInfo.isPc())) {
      Log.info(TAG, 'getVisibility: Hidden.');
      this.titleVisibility = Visibility.Hidden;
      return Visibility.Hidden;
    } else {
      Log.info(TAG, 'getVisibility: Visible.');
      this.titleVisibility = Visibility.Visible;
      return Visibility.Visible;
    }
  }

  /* instrument ignore next */
  private getSubTitleColor(): ResourceColor {
    if (DeviceInfo.isPc() && this.isTimelinePageHeadTitle || this.isGroupDayView) {
      return $r('sys.color.font_secondary');
    }
    if (this.immersiveController?.enable) {
      return this.immersiveController.textFontColor;
    } else {
      return ActionBarProp.NORMAL_TEXT_COLOR;
    }
  }

  private getSubTitleOpacity(): number {
    if (this.isGroupDayView) {
      return this.isShowDateString ? Constants.OPAQUE : Constants.TRANSPARENT;
    }
    return this.timeController && this.isShowAddress ? this.timeController.subLocalityAddressOpacity :
      (DeviceInfo.isPc() && this.isTimelinePageHeadTitle) ? Constants.OPAQUE : Constants.TRANSPARENT;
  }

  private getMinMainTitleSize(): number | string | Resource | undefined {
    if (!DeviceInfo.isPc()) {
      return ActionBarProp.TITLE_TEXT_SIZE;
    }
    /* instrument ignore next */
    if (this.isTimelinePageHeadTitle) {
      return undefined;
    }
    return ActionBarProp.SUB_TITLE_TEXT_SIZE;
  }

  private getFontSize(): number | string | Resource {
    Log.info(TAG, `getFontSize:${this.isTimelinePageHeadTitle} ${this.isShowDateString} ${this.isPageEmpty}`);
    return (this.isTimelinePageHeadTitle && this.isShowDateString ? this.timelineTitleFontSize :
    this.actionBarProp.getTitleFontSize());
  }

  @Builder
  mainTitle() {
    Text(this.isShowDateString ? `${this.dateString}` : this.actionBarProp.getTitle())
      .draggable(false)
      .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_title_font_size') : this.getFontSize())
      .maxLines((DeviceInfo.isPc() && this.isTimelinePageHeadTitle) ? 1 : 2)
      .maxFontScale(1.0)
      .minFontScale(1.0)
      .minFontSize(this.getMinMainTitleSize())
      .maxFontSize(DeviceInfo.isTv() ? undefined :
        (this.isTimelinePageHeadTitle && this.isShowDateString ? this.timelineTitleFontSize :
        this.actionBarProp.getTitleFontSize()))
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
      .fontWeight(DeviceInfo.isTv() ? FontWeight.Medium : FontWeight.Bold)
      .fontColor(DeviceInfo.isTv() ? $r('sys.color.font_primary') :
        ((this.immersiveController && this.immersiveController.enable) ?
        this.immersiveController.textFontColor :
          (this.actionBarProp.getColorMode() === ActionBarColorMode.TRANSPARENT) ?
          ActionBarProp.TRANSPARENT_TEXT_COLOR : ActionBarProp.NORMAL_TEXT_COLOR))
      .textOverflow({ overflow: this.isEllipsis ? TextOverflow.Ellipsis : TextOverflow.None })
      .key('mainTitle-SingleTitleText')
      .textAlign(TextAlign.Start)
      .alignSelf(ItemAlign.Start)
      .lineHeight(this.dateLineHeight)
      .fontFamily(DeviceInfo.isTv() ? 'HarmonyHeiTi' : undefined)
      .textShadow({
        radius: this.immersiveController?.enable ? this.immersiveController.textFontShadowRadius : 0,
        color: this.immersiveController?.enable ?
        this.immersiveController.textFontShadowColor : $r('app.color.transparent'),
      })
      .opacity(this.timeController ? this.timeController.singleTitleOpacity : Constants.OPAQUE)
      .height(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_text_height') : undefined)
      .margin({ top: DeviceInfo.isTv() ? this.mainTitleTopPadding : undefined })
  }

  @Builder
  subTitle() {
    Text(`${this.subLocalityAddress}`)
      .fontFamily('HarmonyHeiTi')
      .fontSize(this.actionBarProp.getSubTitleFontSize())
      .fontWeight(FontWeight.Medium)
      .fontColor(this.isGroupDayView ? $r('sys.color.font_secondary') :
        (this.immersiveController?.enable ? this.immersiveController.textFontColor : ActionBarProp.NORMAL_TEXT_COLOR))
      .maxLines((DeviceInfo.isPc() && this.isTimelinePageHeadTitle) ? MAX_LINE_COUNT_TIMELINE : MAX_LINE_COUNT)
      .maxFontScale(1.0)
      .minFontScale(1.0)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .textAlign(TextAlign.Start)
      .alignSelf(ItemAlign.Start)
      .lineHeight(this.addressLineHeight)
      .opacity(this.getSubTitleOpacity())
      .textShadow({
        radius: this.immersiveController?.enable ? this.immersiveController.textFontShadowRadius : 0,
        color: this.immersiveController?.enable ?
        this.immersiveController.textFontShadowColor : $r('app.color.transparent')
      })
      .accessibilityLevel('no')
      .position({ start: LengthMetrics.vp(0), top: LengthMetrics.vp(this.addressPosY) })
      .key('subTitle')
  }

  @Builder
  TitleBuilder() {
    if (this.isDoubleLineTitle) {
      this.buildDoubleLineTitle();
    } else {
      this.buildSingleLineTitle();
    }
  }

  @Builder
  buildDoubleLineTitle() {
    Column() {
      this.mainTitle();
      this.subTitle();
    }
    .justifyContent(DeviceInfo.isPc() ? FlexAlign.Center : FlexAlign.Start)
    .flexGrow(1)
    .constraintSize({ minHeight: this.isTimelinePageHeadTitle ? this.minHeight : 0 })
    .padding({
      top: this.getTopPadding(),
      bottom: this.isTimelinePageHeadTitle ? this.paddingBottom : $r('sys.float.padding_level2'),
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.singleTitleHeight = assert.asNumber(newValue.height) ?? 0;
      this.addressPosY = this.singleTitleHeight - this.addressOffY - this.paddingTop;
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.isTimelinePageHeadTitle) {
        this.addressPosY = this.addressPosY + this.addressOffY;
      }
      if (!DeviceInfo.isPc()) {
        this.addressPosY = this.addressPosY - 2;
      }
      Log.info(TAG, `onAreaChange: ${this.immersiveController?.isInImmersive}, ${this.singleTitleHeight}`);
    })
  }

  /**
   * 非系统相册Title Builder，如人像，分类相册
   */
  @Builder
  buildSingleLineTitle() {
    Text(this.title)
      .draggable(false)
      .fontSize(this.nonSystemAlbumTitleFontSize)
      .maxFontScale(1.0)
      .minFontScale(1.0)
      .minFontSize($r('sys.float.Body_M'))
      .maxFontSize(this.nonSystemAlbumTitleFontSize)
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
      .maxLines(2)
      .fontWeight(FontWeight.Bold)
      .fontColor((this.immersiveController?.enable) ?
      this.immersiveController.textFontColor :
        (this.actionBarProp.getColorMode() === ActionBarColorMode.TRANSPARENT) ?
        ActionBarProp.TRANSPARENT_TEXT_COLOR : ActionBarProp.NORMAL_TEXT_COLOR)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .key('SingleTitleText')// 设置值不大于0时，不限制文本行高，自适应字体大小
      .lineHeight(this.useOtherTitleLineHeight && DeviceInfo.isPc() ? this.dateLineHeight : -1)
      .opacity(this.actionTitleOpacity)
      .textAlign(TextAlign.Start)
      .wordBreak(WordBreak.BREAK_ALL)
      .textShadow({
        radius: this.immersiveController?.enable ? this.immersiveController.textFontShadowRadius : 0,
        color: this.immersiveController?.enable ?
        this.immersiveController.textFontShadowColor : $r('app.color.transparent'),
      })
      .onHover(
        /* instrument ignore next */
        (isHover: boolean): void => {
          if (!this.isTextOver) {
            return;
          }
          clearTimeout(this.timer);
          clearTimeout(this.firstTimer);
          /* instrument ignore next */
          if (isHover) {
            this.timer = setTimeout((): void => {
              this.isShowFullName = true;
            }, ActionBarVar.isFirstUnHover ? 700 : 300);
            /* instrument ignore next */
          } else {
            //是否处于提示后移开后的300ms中
            this.timer = setTimeout((): void => {
              this.isShowFullName = false;
            }, ActionBarVar.isFirstUnHover ? 300 : 0);
            ActionBarVar.isFirstUnHover = false;
            this.firstTimer = setTimeout((): void => {
              ActionBarVar.isFirstUnHover = true;
            }, 300);
          }
        })
      .bindPopup(this.isTextOver && this.isShowFullName && (this.titleVisibility === Visibility.Visible), {
        builder: this.nameTip,
        autoCancel: true,
        mask: false,
        enableArrow: false,
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.updateTextWidth(newValue);
      })
  }

  private updateTextWidth(area: Area): void {
    let textWidth: number = measure.measureText({
      textContent: this.actionBarProp.getTitle(),
      fontSize: $r('sys.float.Body_M'),
      fontWeight: FontWeight.Bold,
      fontFamily: $r('sys.string.ohos_id_text_font_family_medium'),
      wordBreak: WordBreak.BREAK_ALL,
      maxLines: 2,
    });
    if (typeof area.width === 'number') {
      this.isTextOver = px2vp(parseInt(textWidth.toString())) > area.width * 2;
    }
  }

  /* instrument ignore next */
  @Builder
  nameTip() {
    Row() {
      Text(this.actionBarProp.getTitle())
        .fontSize($r('sys.float.Body_M'))
    }
    .padding({
      left: $r('app.float.immersive_compared_tip_padding_left'),
      top: $r('app.float.immersive_compared_tip_padding_top'),
      right: $r('app.float.immersive_compared_tip_padding_left'),
      bottom: $r('app.float.immersive_compared_tip_padding_top'),
    })
    .constraintSize({
      maxWidth: 400,
    })
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Column() {
        this.TitleBuilder();
      }
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
        if (newValue?.width) {
          this.titleWidth = Number(newValue?.width);
        }
      })
    }
    .flexGrow(this.defaultFlexRow)
    .width(Constants.SINGLE_TITLE_WIDTH)
    .height(this.getSingleTitleHeight())
    .visibility(this.getVisibility())
    .key('singleTitleStack')
  }

  /* instrument ignore next */
  private updateTitleFontSize(): void {
    Log.info(TAG, `updateTitleFontSize isPageEmpty:${this.isPageEmpty} isHorizontal:${this.isHorizontal}`);
    this.timelineTitleFontSize = this.getTimeLineTitleFontSize();
    this.nonSystemAlbumTitleFontSize = this.getNonSysAlbumTitleFontSize();
  }

  /* instrument ignore next */
  private updateTitle(): void {
    if (this.titleVisibility === Visibility.Visible) {
      this.title = this.actionBarProp.getTitle();
    } else {
      this.title = '';
    }
  }
}