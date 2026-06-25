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
import { ButtonItem } from '../../common/view/SelectableProgressButton';
import { App, MediaType, BaseEditor } from '../../../../service/App';
import { AdjustAttr, Asset } from '../../../../service/BaseEditor';
import { Event } from '../../../../common/jul';
import { CustomScroll } from '../../../../common/components/CustomScroll';
import {
  ADJUST_AND_FILTER_SCROLL_DELAY,
  ADJUST_BUTTON_SIZE,
  ADJUST_TAG,
  AUTO_INDEX,
  DEVICE_FOLD_STATUS,
  FADE_INDEX,
  GRAIN_INDEX,
  SCREEN_ORIENTATION_PORTRAIT,
  SHARPNESS_INDEX,
  VIGNETTE_INDEX,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  SCROLL_SHADOW_WIDTH
} from '../../../../common/const';
import { StrengthBar } from '../../../../common/components/StrengthBar';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { ScrollerUtil } from '../../../../common/util/ScrollerUtil';
import { LengthMetrics } from '@kit.ArkUI';
import { UiUtil } from '../../../../common/util/UiUtil';
import { accessibility } from '@kit.AccessibilityKit';

let timeFn: number = -1;
/* instrument ignore file */
let TAG: string = 'VideoAdjustTool';

let opacities: number[] = [0.6, 1, 0.4];

@Component
export struct VideoAdjustTool {
  @State @Watch('changeProgress') adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State @Watch('stopScrolling') editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State onTouchState: TouchType = TouchType.Up;
  @State @Watch('onScrollOffsetChange') scrollOffsetChange: number = 0;
  @State stateChange: number = 0 // 滑动条状态切换
  @State stateClosed: boolean = false // 滑动条是否置灰
  @State hasBgColor: boolean = false;
  @State progressVal: number = this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).value;
  @State index: number = this.adjustAttr.tabs.findIndex(item => (item.state === 1 || item.state === 2)) === -1 ? 0 :
  this.adjustAttr.tabs.findIndex(item => (item.state === 1 || item.state === 2));
  @State adjustMin: number = App.getInstance()
    .myEditor()
    .asset
    .adjusts()
    .tab
    .min
  @State adjustMax: number = App.getInstance()
    .myEditor()
    .asset
    .adjusts()
    .tab
    .max
  @State isClick: boolean = false;
  @State isHighlight: boolean | undefined = !(this.adjustAttr.tab.state === 2);
  @State strengthBarVisibility: boolean = !(this.adjustAttr.tab.state === 0);
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('watchScrollDirection') isScreenPortrait: boolean = ScreenManager
    .getInstance()
    .isScreenPortrait()
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('scrollToSelected') isFold: boolean = ScreenManager.getInstance()
    .isDeviceFold()
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @State scrollDirection: ScrollDirection = this.isScreenPortrait ? ScrollDirection.Horizontal :
  ScrollDirection.Vertical
  @State autoDisabled: boolean = true;
  @State isSlide: boolean = false;
  @State isScroll: boolean = false;
  private scroller: Scroller = new Scroller();
  private itemWidthAndMarginR: number = 68;
  private isClickItem: boolean = false;
  private tipTimeFn = -1;
  private scrollTimeFn = -1;
  @State textPaddingLeftAndRight: number =
    ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight() - 9;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;

  refreshHeight() {
    this.textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight() - 9;
    this.scrollDistance = 0;
    this.handleScroll();
  }

  watchScrollDirection() {
    this.scrollDirection = this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical;
    this.scrollDistance = 0;
    this.handleScroll();
  }

  stopScrolling(): void {
    if (this.editor.isStopScrolling) {
      this.isClick = true;
      this.stateChange++
    }
  }

  scrollToSelected(): void {
    if (!this.isFold) {
      return;
    }
    clearTimeout(this.scrollTimeFn);
    this.scrollTimeFn = setTimeout((): void => {
      let index = this.adjustAttr.tabs.findIndex((item: ButtonItem) => item.key ===
      this.adjustAttr.tabs[this.index].key);
      HiLog.i(TAG, `scroll index:${index}`);
      ScrollerUtil.scrollerTo(index, this.scroller, this.isScreenPortrait,
        ADJUST_BUTTON_SIZE, ADJUST_BUTTON_SIZE);
    }, ADJUST_AND_FILTER_SCROLL_DELAY)
  }

  onScrollOffsetChange(): void {
    if (!this.isClickItem) {
      this.stateClosed = true;
    }
    this.hasBgColor = false;
  }

  getIndexByKey(key: string): number {

    return this.adjustAttr.tabs.findIndex((item: ButtonItem) => key == item.key);

  }

  aboutToAppear() {
    this.adjustAttr.isRefreshValue = false;
    if (this.adjustAttr.tab.state === 1) {
      this.editor.operationTip.setName(this.adjustAttr.tab.text);
      this.editor.operationTip.setValue(this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).value);
      this.editor.operationTip.setDisabled(this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).disabled);
      HiLog.i('VideoAdjustTool', 'aboutToAppear disabled' + this.adjustAttr.getValueByKey(this.adjustAttr.tab.key)
        .disabled);
    }
  }

  changeProgress() {
    if (this.adjustAttr.isRefreshValue) {
      if (this.adjustAttr.redoAdjustItem.match('_') && this.adjustAttr.redoAdjustItem.split('_')[0] ===
      this.adjustAttr.tab.key) {
        if (this.adjustAttr.tab.key === ADJUST_TAG) {
          this.strengthBarVisibility = !this.adjustAttr.autoValHidden;
        }
        this.isHighlight = this.adjustAttr.tab.state === 1;
      } else if (this.adjustAttr.tab.key === ADJUST_TAG) {
        this.strengthBarVisibility = !this.adjustAttr.autoValHidden;
        this.isHighlight = this.strengthBarVisibility;
      }
    }
    this.progressVal = this.adjustAttr.tab.value;
    this.adjustAttr.isRefreshValue = false;
    if (this.editor.isEdit && this.editor.isOpenInitReset && this.adjustAttr.auto.value != 0) {
      this.strengthBarVisibility = true;
      this.isHighlight = this.strengthBarVisibility;
      this.progressVal = this.adjustAttr.auto.value;
      this.adjustMin = this.adjustAttr.tab.min;
      this.adjustMax = this.adjustAttr.tab.max;
    }
    if (this.adjustAttr.isXTStyleClear) {
      this.strengthBarVisibility = false;
      this.adjustAttr.isXTStyleClear = false;
    }
    if (this.adjustAttr.isResetSelected) {
      this.strengthBarVisibility = false;
      this.adjustAttr.tabs[this.index].state = 0;
      this.adjustAttr.isResetSelected = false;
    }
  }

  build() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
    }) {
      Flex({
        direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
        alignItems: ItemAlign.Center,
      }) {
        Stack() {
          StrengthBar({
            color: this.isHighlight ? '#E6E6E6' : '#666666',
            progress: this.progressVal,
            min: this.adjustMin,
            max: this.adjustMax,
            duration: this.adjustMax - this.adjustMin,
            isSlide: $isSlide,
            isScreenPortrait: this.isScreenPortrait,
            onCurrentXChange: val => {
              if (this.isClick) {
                return;
              }
              this.adjustAttr.tabs[this.index].state = 1;
              this.adjustAttr.tabs[this.index].opacity = 1;
              this.isHighlight = this.adjustAttr.tabs[this.index].state === 1;
              let scrollVal = Number(val.toFixed(1));
              let originNum = this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).originalValue;
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
              let gapVal = this.adjustMin == 0 ? 2.5 : 5
              Math.floor(this.adjustAttr.getValueByKey(this.adjustAttr.tab.key)
                .originalValue / gapVal) != Math.floor(scrollVal / gapVal);
              this.progressVal = scrollVal;
              this.editor.operationTip.setValue(Math.round(val).toString());
              this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).originalValue = scrollVal;
              this.adjustAttr.tabs[this.index].value = scrollVal;
              if (this.index === AUTO_INDEX) {
                this.autoDisabled = false;
              }
              if (this.index !== AUTO_INDEX && this.index !== SHARPNESS_INDEX && this.index !== VIGNETTE_INDEX &&
                this.index !== FADE_INDEX && this.index !== GRAIN_INDEX) {
                this.adjustAttr.autoValHidden = true;
                this.autoDisabled = true;
              }
              this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).value = scrollVal;
              this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).disabled = true;
              this.adjustAttr?.setValue(this.adjustAttr.tab.key, scrollVal);
            },
            onEnd: () => {
              this.editor.increaseEditCounter();
              this.editor.stopEditorOperate();
              this.editor.isStartOperate = false;
              HiLog.i('haTest', 'onEnd index:' + this.index + ', state: ' + this.adjustAttr.tabs[this.index].state);

              if (accessibility.isOpenAccessibilitySync()) {
                this.sendStrengthValEvent();
              }
            }
          })
            .visibility(this.strengthBarVisibility ? Visibility.Visible : Visibility.None)
            .accessibilityText(this.adjustAttr.adjustScrollTexts[this.index]?.getResource(this.progressVal))
        }
      }
      .id('petalclip_videoAdjustTool_adjustValue')
      .width(this.isScreenPortrait ? '100%' : 56)
      .height(this.isScreenPortrait ? 56 : '100%')
      .margin({ top: this.isScreenPortrait ? 8 : 0, left: this.isScreenPortrait ? 0 : 8 })

      this.adjustType();
    }
    .id('petalclip_videoAdjustTool_adjust')
  }

  sendStrengthValEvent(): void {
    let scrollTextRes: string = this.adjustAttr.adjustScrollAngleTexts[this.index]?.getString(this.progressVal) || '';
    let eventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.photos',
      triggerAction: 'common',
      textAnnouncedForAccessibility: scrollTextRes
    });
    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      HiLog.i(TAG, `sendStrengthValEvent, progressVal=${this.progressVal}`);
    });
  }

  handleScroll(state?: ScrollState) {
    if (!this.scroller.currentOffset()) {
      return;
    }
    const scrollDistance = (
      this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0 ? true : false;
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance ? true : false;
  }

  @Builder
  adjustType() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
    }) {
      Stack({ alignContent: Alignment.Center }) {
        CustomScroll({
          tabLength: this.adjustAttr.tabs.length,
          scrollDirection: this.scrollDirection,
          marginScreen: 8,
          scroller: this.scroller,
          needMask: false,
          itemWidth: this.itemWidthAndMarginR,
          scrollItem: (() => {
            this.scrollerItem();
          }),
          scrollAppear: (() => {
            this.scrollAppear();
          }),
          scroll: ((state: ScrollState) => {
            this.scroll();
            this.handleScroll(state);
          }),
          scrollEdge: ((side) => {
            if (side === Edge.Start || side === Edge.Top) {
              this.isShowShadowStart = false;
            } else {
              this.isShowShadowStart = true;
            }
            if (side === 3 || side === Edge.Bottom) { // 3: Edge.End
              this.scrollDistance = (
                this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
              ) ?? 0;
              this.isShowShadowEnd = false;
            } else {
              this.isShowShadowEnd = true;
            }
          }),
          scrollEnd: (() => {
            this.scrollEnd();
          })
        })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.asset.isTouching = true;
              this.isScroll = true;
            }
            if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
              this.asset.isTouching = false;
              this.isScroll = false;
            }
          })
          .visibility(this.editor.immersiveMode ? Visibility.Hidden : Visibility.Visible)
          // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
          .onAreaChange((oldValue: Area, newValue: Area) => {
            this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
          })
      }
      .height('100%')
      .width('100%')
      .linearGradient({
        angle: this.isScreenPortrait ? 90 : 180,
        colors: [
          ['rgba(0, 0, 0, 0)', 0],
          ['rgba(0, 0, 0, 1)', this.isShowShadowStart ? this.shadowRate : 0],
          ['rgba(0, 0, 0, 1)', this.isShowShadowEnd ? 1 - this.shadowRate : 1],
          ['rgba(0, 0, 0, 0)', 1]]
      })
    }
    .id('petalclip_videoAdjustTool_adjustType')
    .enabled(!this.isScroll || !this.asset.isTouching)
    .width(this.isScreenPortrait ? '100%' : 96)
    .height(this.isScreenPortrait ? 96 : '100%')
  }

  @Builder
  scrollerItem() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
    }) {
      ForEach(this.adjustAttr.tabs, (item: ButtonItem, index?: number) => {
        AdjustItem({
          itemIndex: index,
          isScreenPortrait: this.isScreenPortrait,
          click: ((selectIndex: number) => {
            if (selectIndex === AUTO_INDEX) {
              this.editor.increaseEditCounter();
              this.adjustAttr.autoValHidden = false;
            }
            if (this.adjustAttr.tab.key == item.key) {
              if (this.adjustAttr.tab.value !== 0 && selectIndex !== AUTO_INDEX) {
                this.editor.increaseEditCounter();
              }

              if (selectIndex !== AUTO_INDEX) {
                HiLog.i('AdjustItem', 'strengthBarVisibility:' + this.strengthBarVisibility + ' selectIndex:' + selectIndex + 'state: ' +
                this.adjustAttr.tabs[selectIndex].state);
                this.adjustAttr.tabs[selectIndex].state = this.adjustAttr.tabs[selectIndex].state === 1 ? 2 : 1
                this.adjustAttr.barDisabled = this.adjustAttr.tabs[selectIndex].state === 2;
                if (this.index !== SHARPNESS_INDEX && this.index !== VIGNETTE_INDEX && this.index !== FADE_INDEX &&
                  this.index !== GRAIN_INDEX) {
                  this.adjustAttr.autoValHidden = true;
                  this.autoDisabled = true;
                }
                this.strengthBarVisibility = true;
              } else {
                HiLog.i('AdjustItem', 'strengthBarVisibility:' + this.strengthBarVisibility + ' selectIndex:' + selectIndex + 'state: ' +
                this.adjustAttr.tabs[selectIndex].state);
                this.adjustAttr.tabs[selectIndex].state = this.adjustAttr.tabs[selectIndex].state === 1 ? 0 : 1;
                this.strengthBarVisibility = !this.strengthBarVisibility;
                this.autoDisabled = true;
              }
              this.isHighlight = this.adjustAttr.tabs[selectIndex].state === 1;
              HiLog.i('testDisabled', 'index:' + this.index + ' selectIndex:' + selectIndex + 'state: ' +
              this.adjustAttr.tabs[selectIndex].state);
              this.adjustAttr.tabs[selectIndex].opacity = opacities[this.adjustAttr.tabs[selectIndex].state];
              this.adjustAttr.setEnable(this.adjustAttr.tabs[selectIndex].key,
                this.adjustAttr.tabs[selectIndex].state === 1, (value) => {
                  this.progressVal = value;
                })
              return;
            } else {
              this.strengthBarVisibility = true;
            }
            this.adjustAttr.barDisabled = false;
            this.adjustAttr.tabs[this.index].state = this.adjustAttr.tabs[this.index].state === 2 ? 2 : 0
            this.adjustAttr.tabs[selectIndex].state = 1;
            this.isHighlight = this.adjustAttr.tabs[selectIndex].state === 1;
            this.adjustAttr.tabs[selectIndex].opacity = 0.9;
            this.adjustAttr.autoSelected = selectIndex === 0;
            this.index = selectIndex;
            if (item.key != ADJUST_TAG || (item.key == ADJUST_TAG && this.autoDisabled)) {
              this.adjustAttr.setEnable(this.adjustAttr.tabs[this.index].key,
                this.adjustAttr.tabs[this.index].state === 1, (value) => {
                  this.progressVal = value;
                })
            }
            this.isHighlight = this.adjustAttr.tabs[this.index].state === 1;
            clearTimeout(timeFn);
            this.isClick = true;
            this.isClickItem = true;
            this.adjustAttr.tab = item;
            this.editor.startEditorOperate();
            this.editor.stopEditorOperate();
            if (this.progressVal != this.adjustAttr.tabs[selectIndex].value || this.adjustMax != item.max ||
              this.adjustMin != item.min || this.adjustAttr.tabs[this.index].key === ADJUST_TAG) {
              this.progressVal = this.adjustAttr.tabs[selectIndex].value;
              this.adjustMax = item.max;
              this.adjustMin = item.min;
              this.stateChange++;
              this.editor.operationTip.setValue(this.adjustAttr.tabs[selectIndex].value);
            }
            HiLog.i('VideoAdjustTool', 'value====:' + this.adjustAttr.tabs[selectIndex].value)
            timeFn = setTimeout((): void => {
              this.isClick = false;
              HiLog.i('VideoAdjustTool', 'selected min:' + this.adjustAttr.tab.min + ':max:' + this.adjustAttr.tab
                .max + ':value:' + this.adjustAttr.tabs[selectIndex].value + ':stateChange:' + this.stateChange)
            }, 50);
            this.stateClosed = (this.adjustAttr.tabs[selectIndex].state === 1);
            this.editor.operationTip.setName(this.adjustAttr.tab.text);
            this.editor.operationTip.setDisabled((this.adjustAttr.tabs[selectIndex].state === 1));
            this.editor.operationTip.tips = true;
            clearTimeout(this.tipTimeFn);
            this.tipTimeFn = setTimeout((): void => {
              this.editor.operationTip.tips = false;
            }, 1000)
          })
        }).animation({
          duration: 100,
          curve: Curve.EaseInOut,
        })
          .id(`videoEditor_videoAdjustTool_adjustItem_${item.key}`)
      }, (item: ButtonItem) => item.key)
    }
    .padding(this.isScreenPortrait ? {
      left: this.textPaddingLeftAndRight,
      right: this.textPaddingLeftAndRight,
      top: this.isScreenPortrait ? 12 : 0,
      bottom: this.isScreenPortrait ? 4 : 0,
    } : {})
  }

  /**
   * scroller 初始化ok
   */
  scrollAppear(): void {
    if (this.adjustAttr.tab.state !== 1) {
      this.editor.operationTip.setName('');
      return;
    }
    this.editor.operationTip.tips = true;
    clearTimeout(this.tipTimeFn);
    this.tipTimeFn = setTimeout((): void => {
      this.editor.operationTip.tips = false;
    }, 1000)
  }

  /**
   * scroller 滚动
   */
  scroll(): void {
    if (!this.scroller.currentOffset()) {
      HiLog.w('VideoAdjustTool', 'onDidScroll ignored');
      return;
    }
    this.scrollOffsetChange = this.scroller.currentOffset().xOffset;
  }

  /**
   * scroller 滚动结束
   */
  scrollEnd(): void {
    this.stateClosed = this.adjustAttr.getValueByKey(this.adjustAttr.tab.key).disabled;
    this.isClickItem = false;
    this.hasBgColor = true;
  }
}

@Component
struct AdjustItem {
  @Prop itemIndex: number = 0;
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State item: ButtonItem = this.adjustAttr.tabs[this.itemIndex];
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Prop isScreenPortrait: boolean = true;
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State isHover: boolean = false;
  public click: (selectIndex: number) => void = Event;
  @State numOfRotations: number = 0;

  adjustTextResource(buttonItem: ButtonItem, index: number): Resource {
    if (buttonItem.state === 1) {
      if (this.adjustAttr.adjustTexts[index] !== null) {
        return this.adjustAttr.adjustTexts[index].text;
      }
    }
    return buttonItem.text
  }

  handleTabTextMarqueeStateChange = (state: MarqueeState) => {
    if (state === MarqueeState.BOUNCE) {
      this.numOfRotations++;
    }
  };

  build() {
    Column() {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          Circle().circleBack(this.item.state)
          if (this.item.isSymbolGlyph) {
            SymbolGlyph(this.item.icon).subMenuSym(this.item.state)
          } else {
            Image(this.item.icon).subMenu(this.item.state)
          }
        }
        .id('petalClip_AdjustItem_' + this.item.key + '_' + (this.item.state === 1))

        Text(this.item.text)
          .textStyle(this.item.state, this.numOfRotations)
          .onMarqueeStateChange(this.handleTabTextMarqueeStateChange)
          .textAlign(TextAlign.Center)

        Row() {
          Text(this.item.value > 0 ? '+' + Math.round(this.item.value)
            .toString()
            : Math.round(this.item.value).toString())
            .height(14)
            .textAlign(TextAlign.Center)
            .adjustText(this.item.state)
            .visibility((this.item.key === ADJUST_TAG && this.adjustAttr.autoValHidden) || this.item.value === 0 ?
            Visibility.Hidden : Visibility.Visible)
            .id(`videoEditor_AdjustItem_${this.item.key}` + '_' + 'value')
        }
      }
      .id('petalClip_AdjustItem_' + this.item.key)
      .onClick((): void => {
        if (this.editor.asset.isGestureOperate || this.asset.isTouching) {
          HiLog.i(TAG, 'gesture operate cannot click adjust submenu');
          return;
        }
        this.click(this.itemIndex);
        if (this.editor.isEdit) {
          this.editor.isShowRevert = !this.editor.isEdited();
        }
        this.numOfRotations = 0;
      })
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString(this.adjustTextResource(this.item, this.itemIndex)))
      .width(66)
      .height(80)
      .focusBox({ margin: LengthMetrics.vp(-2) })
      .backgroundColor(this.isHover ? $r('sys.color.ohos_id_color_hover_transparent') : Color.Transparent)
      .borderRadius(8)
      .onHover((isHover: boolean) => {
        this.isHover = isHover;
      })

      Row() {
      }
      .visibility((!this.isScreenPortrait) ? Visibility.Visible : Visibility.None)
      .height(8)
    }

    .onVisibleAreaChange([0.0, 0.1, 0.2, 0.5, 0.7, 0.9], (isVisible: boolean, currentRatio: number) => {
      this.item.opacity = opacities[this.item.state] * currentRatio;
      if (this.item.state === 1) {
        this.item.opacity = currentRatio;
      }
    })
    .margin({
      start: LengthMetrics.vp(this.isScreenPortrait && this.itemIndex > 0 ? 2 : 0)
    })
  }
}

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
function textStyle(state: number, numOfRotations: number) {
  .fontColor(state === 1 ? $r('sys.color.ohos_id_color_text_primary_dark') :
  $r('sys.color.ohos_id_color_text_secondary_dark'))
  .height('14vp')
  .fontSize('10fp')
  .maxFontScale(1)
  .margin({ top: '4vp' })
  .maxLines(1)
  .textOverflow({ overflow: state === 1 && numOfRotations < 3 ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
  .opacity(state === 2 ? 0.4 : 1)
}

@Extend(Text)
function adjustText(state: number) {
  .width('44vp')
  .height('14vp')
  .fontColor($r('sys.color.ohos_id_color_text_secondary_dark'))
  .fontFamily('HarmonyHeiTi')
  .fontWeight(FontWeight.Regular)
  .fontSize('10vp')
  .lineHeight('13vp')
  .opacity(state === 2 ? 0.4 : 1)
}