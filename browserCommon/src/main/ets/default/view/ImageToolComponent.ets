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
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { ImageToolInnerState } from './ImageToolInnerState';
import lazy {
  Constants as BrowserConstants,
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy {
  ImageToolConstants,
} from '@ohos/common/src/main/ets/default/model/common/ImageToolConstants';
import lazy { EventPipeline } from '@ohos/common/src/main/ets/default/model/browser/photo/EventPipeline';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

const TAG = 'ImageToolComponent'

@Component
export struct ImageToolComponent {
  @Link item: MediaItem;
  @Link imageToolInnerState: ImageToolInnerState;
  @Prop rotateValue: number = 0;
  private eventPipeline?: EventPipeline;

  /* instrument ignore next  */
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  /* instrument ignore next  */
  @StorageLink('navigationBarBottomHeight') private navigationBarBottomHeight: number =
    0;
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('isHorizontal') isHorizontal: boolean =
    isOrientationHorizontal();

  /**
   * 画中画 右侧 最外层Stack整体宽度
   * @returns
   */
  /* instrument ignore next  */
  private getImageToolWidth(): number {
    let totalHeight: number = 0;
    // right Margin
    totalHeight += this.imageToolInnerState._stackRightMargin;
    // stack Width
    totalHeight += this.imageToolInnerState._stackWidth;
    return totalHeight;
  }

  /**
   * 画中画 非右侧 最外层Stack整体高度v2
   * @returns
   */
  /* instrument ignore next */
  private getImageToolHeightV2(): number {
    let totalHeight: number = 0;
    // imagetool height
    totalHeight += this.imageToolInnerState._stackHeight;
    // imagetool margin
    totalHeight += this.getImageToolMarginBottom();
    // aibar 避让
    totalHeight += this.getOuterStackPaddingBottom();
    return totalHeight;
  }

  /* instrument ignore next */
  private getOuterStackPaddingBottom(): number {

    return this.isFullMode ? px2vp(this.navigationBarHeight) :
    px2vp(this.navigationBarBottomHeight)
  }

  /* instrument ignore next */
  private getImageToolMarginBottom(): number {
    return this.isHorizontal ? ImageToolConstants.IMAGE_TOOL_MARGIN_STATUS_HORIZONTAL :
    Constants.ToolBarHeight;
  }

  /**
   * 画中画适配双指旋转 外层Stack宽高
   * @returns
   */
  /* instrument ignore next */
  private getInnerSecPhotoWidth(): number {
    return this.rotateValue / BrowserConstants.ROTATION_NINETY % 2 === 0 ?
    this.imageToolInnerState._stackWidth : this.imageToolInnerState._stackHeight;
  }
  /* instrument ignore next */
  private getInnerSecPhotoHeight(): number {
    return this.rotateValue / BrowserConstants.ROTATION_NINETY % 2 === 0 ?
    this.imageToolInnerState._stackHeight : this.imageToolInnerState._stackWidth;
  }

  aboutToAppear(): void { }

  /**
   * photoItem 缩放或者移动，定时器清除
   */
  private innerPhotoDealTouchEvent(): void {
    // 此时隐藏状态, visibility = 1且重置定时器
    /* instrument ignore next */
    if (this.imageToolInnerState._stackVisibility === 0) {
      this.imageToolInnerState._stackVisibility = 1;
      /* instrument ignore else */
    } else {
      Log.info(TAG, `innerPic clear timeout`);
      clearTimeout(this.imageToolInnerState._pTimeout);
    }
    /* instrument ignore next */
    this.imageToolInnerState._pTimeout = setTimeout(() => {
      Log.info(TAG, `3s no use ImageTool, hide!`);
      this.imageToolInnerState._stackVisibility = 0;
    }, ImageToolConstants.IMAGE_TOOL_AUTOHIDE_DURATION);
  }

  @Builder
  buildBottomMask() {
    Column() {
      // 四部分蒙灰区域
      Row()
        .width(Constants.PERCENT_100)
        .height(this.imageToolInnerState._scrollY)
        .position({
          x: 0,
          y: 0,
        })
        .opacity(ImageToolConstants.SCROLL_BACKGROUND_OPACITY)
        .backgroundColor(Color.Black)
        .pixelRound({
          top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          end: PixelRoundCalcPolicy.NO_FORCE_ROUND
        })

      Row()
        .width(this.imageToolInnerState._scrollX)
        .height(this.imageToolInnerState._scrollHeight)
        .position({
          x: 0,
          y: this.imageToolInnerState._scrollY,
        })
        .opacity(ImageToolConstants.SCROLL_BACKGROUND_OPACITY)
        .backgroundColor(Color.Black)
        .pixelRound({
          top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          end: PixelRoundCalcPolicy.NO_FORCE_ROUND
        })

      Row()
        .width(this.imageToolInnerState._stackWidth - this.imageToolInnerState._scrollX -
        this.imageToolInnerState._scrollWidth)
        .height(this.imageToolInnerState._scrollHeight)
        .position({
          x: this.imageToolInnerState._scrollX + this.imageToolInnerState._scrollWidth,
          y: this.imageToolInnerState._scrollY,
        })
        .opacity(ImageToolConstants.SCROLL_BACKGROUND_OPACITY)
        .backgroundColor(Color.Black)
        .pixelRound({
          top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          end: PixelRoundCalcPolicy.NO_FORCE_ROUND
        })

      Row()
        .width(Constants.PERCENT_100)
        .height(this.imageToolInnerState._stackHeight - this.imageToolInnerState._scrollY -
        this.imageToolInnerState._scrollHeight)
        .position({
          x: 0,
          y: this.imageToolInnerState._scrollY + this.imageToolInnerState._scrollHeight,
        })
        .opacity(ImageToolConstants.SCROLL_BACKGROUND_OPACITY)
        .backgroundColor(Color.Black)
        .pixelRound({
          top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
          end: PixelRoundCalcPolicy.NO_FORCE_ROUND
        })
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
  }

  @Builder
  buildBottomMaskImage() {
    // 底部蒙灰图层
    Stack() {
      Image(ImageUtil.getLCDUri(this.item.uri, this.item.path, this.item.getDateModified?.()))
        .width(this.getInnerSecPhotoWidth())
        .height(this.getInnerSecPhotoHeight())
        .rotate({ angle: this.rotateValue })
        .onComplete((event?: completed) => {
          Log.info(TAG,
            `Lower ImageToolComponent onComplete, index:${this.item.uri}, componentWidth:${event?.componentWidth},
              contentHeight:${event?.componentHeight}, loadingState:${event?.loadingStatus}`);
        })
        .onError((event: ImageError) => {
          Log.error(TAG,
            `Lower ImageToolComponent load error index:${this.item.uri}, error: ${event?.message}`);
        })
        .onAttach(()=> {
          Log.info(TAG,
            `Lower ImageToolComponent onattach, index:${this.item.uri}`);
        })

      this.buildBottomMask();
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
  }

  @Builder
  buildUpperRect() {
    // 上层预览框
    Stack() {
      // 边框
      Rect()
        .fill(Color.Transparent)
        .radius(ImageToolConstants.SCROLL_TOOL_INNER_BORDER_RADIUS)
        .position({
          x: this.imageToolInnerState._scrollX,
          y: this.imageToolInnerState._scrollY,
        })
        .width(this.imageToolInnerState._scrollWidth)
        .height(this.imageToolInnerState._scrollHeight)
        .gesture(
          GestureGroup(
            GestureMode.Parallel,
            PanGesture({
              fingers: 1,
              distance: 1,
            })
              .onActionStart((event: GestureEvent) => {
                this.eventPipeline?.imageToolOnActionStart(event);
              })
              .onActionUpdate((event: GestureEvent) => {
                this.eventPipeline?.imageToolOnActionUpdate(event);
                // 小图移动，清除画中画隐藏定时器
                this.innerPhotoDealTouchEvent();
              })
              .onActionEnd((event: GestureEvent) => {
                this.eventPipeline?.imageToolOnActionEnd(event);
              })
              .onActionCancel(() => {
                this.eventPipeline?.imageToolOnActionCancel();
              })
          )
        )
        .outline({
          width: ImageToolConstants.SCROLL_OUTER_WIDTH,
          color: Color.White,
          radius: ImageToolConstants.SCROLL_TOOL_INNER_BORDER_RADIUS,
          style: OutlineStyle.SOLID,
        })
        .borderRadius(ImageToolConstants.SCROLL_TOOL_INNER_BORDER_RADIUS)
        .borderColor(ImageToolConstants.SCROLL_INNER_COLOR)
        .borderWidth(ImageToolConstants.SCROLL_INNER_WIDTH)
    }
    .width(this.imageToolInnerState._stackWidth)
    .height(this.imageToolInnerState._stackHeight)
  }

  build() {
    Stack() {
      Stack() {
        this.buildBottomMaskImage();

        this.buildUpperRect();
      }
      .width(this.imageToolInnerState._stackWidth)
      .height(this.imageToolInnerState._stackHeight)
      .onTouch(() => {
        Log.info(TAG, `touch imageToolComponent Stack, clear timeout`);
        this.innerPhotoDealTouchEvent();
      })
      .outline({
        width: ImageToolConstants.SCROLL_OUT_BORDER_WIDTH,
        color: Color.White,
        style: OutlineStyle.SOLID,
      })
      .shadow(ShadowStyle.OUTER_FLOATING_SM)
      .accessibilityLevel('yes')
    }
    .padding(!this.imageToolInnerState._isRight ? {
      left: Constants.COLUMN_MARGIN,
      right: Constants.COLUMN_MARGIN,
    } : {
      top: Constants.COLUMN_MARGIN,
      bottom: Constants.COLUMN_MARGIN,
      right: this.imageToolInnerState._stackRightMargin,
    })
    .width(!this.imageToolInnerState._isRight ?
    Constants.PERCENT_100 : this.getImageToolWidth())
    .height(!this.imageToolInnerState._isRight ?
    this.getImageToolHeightV2() : Constants.PERCENT_100)
    .markAnchor(!this.imageToolInnerState._isRight ?
      { x: Constants.PERCENT_0, y: Constants.PERCENT_100 } :
      { x: Constants.PERCENT_100, y: Constants.PERCENT_0 })
    .position(!this.imageToolInnerState._isRight ?
      { x: Constants.PERCENT_0, y: Constants.PERCENT_100 } :
      { x: Constants.PERCENT_100, y: Constants.PERCENT_0 })
    .align(!this.imageToolInnerState._isRight ?
    Alignment.Top : Alignment.Center)
    .hitTestBehavior(HitTestMode.None)
    .onAppear(() => {
      Log.info(TAG, `imageToolComponent onAppear`);
      this.imageToolInnerState._stackVisibility = 1;
      // 防止捏合进入定时器时序错误
      clearTimeout(this.imageToolInnerState._pTimeout);
      this.imageToolInnerState._pTimeout = setTimeout(() => {
        Log.info(TAG, `3s no use ImageTool, hide!`);
        this.imageToolInnerState._stackVisibility = 0;
      }, ImageToolConstants.IMAGE_TOOL_AUTOHIDE_DURATION);
      getScreen().setSystemUi(false, true, true);
    })
    .onDisAppear(() => {
      Log.info(TAG, `imageToolComponent disappear`);
      clearTimeout(this.imageToolInnerState._pTimeout);
    })
    .transition(
      TransitionEffect.OPACITY.animation(
        { duration: ImageToolConstants.IMAGE_TOOL_ANIMATION_DURATION, curve: Curve.Sharp }),
    )
    .visibility(this.imageToolInnerState._stackVisibility ?
    Visibility.Visible : Visibility.Hidden)
  }
}