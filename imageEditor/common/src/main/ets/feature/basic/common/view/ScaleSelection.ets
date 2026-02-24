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
import { LengthMetrics } from '@kit.ArkUI';
import {
  AppColor,
  DEVICE_FOLD_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  SCROLL_SHADOW_WIDTH,
  ADJUST_AND_FILTER_SCROLL_DELAY
} from '../../../../common/const';
import { Event } from '../../../../common/jul';
import { App, MediaType, BaseEditor } from '../../../../service/App';
import { CropAttr } from '../../../../service/BaseEditor';
import { HiLog } from '../../../../common/util/HiLog';
import { CropScaleClass } from '../../../../service/model/CropModel';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { ScrollerUtil } from '../../../../common/util/ScrollerUtil';
import { UiUtil } from '../../../../common/util/UiUtil';

const TAG = 'ScaleSelection';

@Extend(Button)
function tabStyle(isVertical: boolean, isChecked: boolean, isHover: boolean) {
  .padding({ left: 12, right: 12 })
  .fontFamily('HarmonyHeiTi')
  .fontColor(isChecked ? $r('sys.color.font_on_primary') : $r('sys.color.comp_background_primary_contrary'))
  .fontWeight(FontWeight.Medium)
  .opacity(0.9)
  .margin({
    right: 4,
    left: 4,
    bottom: isVertical ? 0 : 9,
    top: isVertical ? 0 : 9,
  })
  .backgroundColor(isChecked ? AppColor.white(0.2) :
    isHover ? $r('sys.color.ohos_id_color_hover_transparent') : AppColor.black(0))
}

@Component
export struct ScaleSelection {
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Prop @Watch('onValueChange') selectValue: number = -1;
  public onBack: () => void = Event;
  public onActive: (value: number, ratio: string, index: number, key: string) => void = Event;
  public scroller: Scroller = new Scroller();
  @State isOnAppear: boolean = false;
  @State scaleList: CropScaleClass[] = this.cropsAttr.scaleDataList;
  @State optArray: number[] = new Array(this.scaleList.length).fill(1);
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('onValueChange') isScreenPortrait: boolean =
    ScreenManager.getInstance()
      .isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('onValueChange') isFold: boolean = ScreenManager.getInstance().isDeviceFold()
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;
  private timeFn: number = -1;
  @State scaleButtonHoverStates: boolean[] = Array(this.scaleList.length).fill(false);

  onValueChange() {
    clearTimeout(this.timeFn);
    this.timeFn = setTimeout((): void => {
      let index = this.scaleList.findIndex((item: CropScaleClass) => this.cropsAttr.scale == item.value);
      this.scrollToIndex(index);
    }, ADJUST_AND_FILTER_SCROLL_DELAY);
    this.scrollDistance = 0;
    this.handleScroll();
  }

  refreshHeight() {
    this.scrollDistance = 0;
    this.handleScroll();
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

  build() {
    Stack() {
      Scroll(this.scroller) {
        Flex({ direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column ,
        justifyContent:FlexAlign.Center,
        alignItems:ItemAlign.Center}) {
          ForEach(this.scaleList, (item: CropScaleClass, index?: number) => {
            if (index !== undefined) {
              Button() {
                Column() {
                  Text(item.text)
                    .maxFontScale(1.15)
                    .fontFamily('HarmonyHeiTi')
                    .fontWeight(FontWeight.Medium)
                    .fontSize(12)
                    .maxLines(1)
                    .textOverflow({
                      overflow: this.cropsAttr.scale === item.value ? TextOverflow.MARQUEE : TextOverflow.Ellipsis,
                    })
                }
              }
              .width('auto')
              .focusBox({ margin: new LengthMetrics(-2) })
              .controlSize(ControlSize.SMALL)
              .tabStyle(this.isScreenPortrait, this.cropsAttr.scale == item.value, this.scaleButtonHoverStates[index])
              .onClick((): void => {
                if (this.cropsAttr.scale === item.value) {
                  return
                }
                this.scrollToIndex(index)
                this.cropsAttr.scale = item.value
                this.onActive(item.value, item.ratio, item.cropIndex, item.key);
                if (this.editor.isEdit) {
                  this.editor.isShowRevert = !this.editor.isEdited();
                }
              })
              .id(`petalclip_ScaleSelection_${index}`)
              .accessibilityText(this.scaleTextString(this.cropsAttr.scale, index, item))
              .onVisibleAreaChange([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
                (isVisible: boolean, currentRatio: number) => {
                  this.optArray[index] = currentRatio;
                })
              .height(20)
              .onHover((isHover: boolean) => {
                this.scaleButtonHoverStates[index] = isHover;
              })
            }
          }, (item: CropScaleClass) => item.cropIndex.toString())
        }
      }
      .width(this.isScreenPortrait ? '100%' : 56)
      .height(this.isScreenPortrait ? 56 : '100%')
      .edgeEffect(EdgeEffect.Spring)
      .scrollable(this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarWidth(0)
      .onAppear((): void => {
        let index = this.scaleList.findIndex((item: CropScaleClass) => this.cropsAttr.scale == item.value);
        this.scrollToIndex(index);
        this.isOnAppear = true;
      })
      .onDidScroll((x: number, y: number, state: ScrollState): void => {
        if (!this.scroller.currentOffset()) {
          HiLog.w('ScaleSelection', 'onDidScroll ignored');
          return;
        }
        this.handleScroll(state);
      })
      .onScrollEdge((side: Edge) => {
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
      })
      .onScrollEnd((): void => {
        if (!this.scroller.currentOffset()) {
          HiLog.w('ScaleSelection', 'onScrollEnd ignored');
          return;
        }
      })
      .onDisAppear((): void => {
        this.isOnAppear = false;
      })

      // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
      })
    }
    .transition(TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      duration: 100, delay: 100,
    }), TransitionEffect.OPACITY.animation({ duration: 100 })))
    .id('petalclip_ScaleSelection_ScaleSelection')
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : 180,
      colors: [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowStart ? this.shadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowEnd ? 1 - this.shadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
  }

  scrollToIndex(index: number) {
    if (!this.isFold) {
      return;
    }

    if (!this.scroller.currentOffset()) {
      HiLog.w('ScaleSelection', 'scrollToIndex ignored');
      return;
    }
    ScrollerUtil.scrollerTo(index, this.scroller, this.isScreenPortrait, this.isScreenPortrait ? 56 : 40,
      this.winHeight < 350 ? 1 : 2)
  }

  scaleTextString(scaleValue: number, index: number, ratioItem: CropScaleClass): string {
    HiLog.i(TAG, `enter scaleTextString; scaleValue: ${scaleValue}`);
    if (this.cropsAttr.scaleDataList[index] === null) {
      HiLog.e(TAG, 'videoScaleText is null');
      return '';
    }
    if (scaleValue === ratioItem.value) {
      return UiUtil.getResourceString(this.cropsAttr.scaleDataText[index].text);
    }
    return UiUtil.getResourceString(this.cropsAttr.scaleDataText[index].key);
  }
}