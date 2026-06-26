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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { ImageDecodeUtils } from '@ohos/common/src/main/ets/default/model/browser/photo/ImageDecodeUtils';
import lazy { image } from '@kit.ImageKit';

const TAG: string = 'common_ImageFlushItem';
const SCROLL_ANIMATION_DURATION: number = 500;

@Component
export struct ImageFlushItem {
  public static readonly KEY_UPDATE_FLUSH_ITEM: string = 'UpdateFlushItem';
  @State item: MediaItem = new MediaItem();
  @State orientation: number = 0;
  @State ratio: number = 1.0;
  @State currentUri: string = '';
  @Link broadCast: BroadCast;
  @Link @Watch('scrollingUpdate') isScrolling: boolean;
  @Link isLcdComplete: boolean;
  @State isImageFlushItemComplete: boolean = false;
  private scrollTimer: number = Number.NaN;
  @StorageLink('isHalfFold') private isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  @State private windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  @State private windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  private itemUpdatedFunc: Function = (item: MediaResult): void => this.onItemChanged(item);
  private lcdCompleteFunc: Function = (): void => this.lcdImageCompleted();
  @State imageWidth?: string = Constants.PERCENT_100;
  @State imageHeight?: string = Constants.PERCENT_100;
  @StorageLink('isHorizontal') isHorizontal: boolean =
    isOrientationHorizontal();
  @Prop isSubScreen: boolean = false;
  @State justifyWidth: boolean = true;
  private isSyncLoad: boolean = false;

  private lcdImageCompleted(): void {
    this.isLcdComplete = true;
  }

  private scrollingUpdate(): void {
    if (!this.isScrolling) {
      this.clearScrollTimer();
      this.scrollTimer = setTimeout((): void => {
        Log.info(TAG, 'scrolling finish');
        this.isLcdComplete = true;
      }, SCROLL_ANIMATION_DURATION);
    }
  }

  private clearScrollTimer(): void {
    if (!Number.isFinite(this.scrollTimer)) {
      return;
    }
    clearTimeout(this.scrollTimer);
    this.scrollTimer = Number.NaN;
  }

  aboutToAppear(): void {
    if (!this.currentUri) {
      this.isLcdComplete = true;
    } else {
      this.isLcdComplete = false;
    }
    this.broadCast.on(ImageFlushItem.KEY_UPDATE_FLUSH_ITEM, this.itemUpdatedFunc);
    this.broadCast.on(BroadCastConstants.CURRENT_LCD_LOAD_COMPLETED, this.lcdCompleteFunc);
  }

  aboutToDisappear() {
    if (this.scrollTimer) {
      this.clearScrollTimer();
    }
    this.broadCast.off(ImageFlushItem.KEY_UPDATE_FLUSH_ITEM, this.itemUpdatedFunc);
    this.broadCast.off(BroadCastConstants.CURRENT_LCD_LOAD_COMPLETED, this.lcdCompleteFunc);
  }

  /* instrument ignore next */
  private onItemChanged(item: MediaResult): void {
    if (item && item.item && item.orientation != undefined &&
      item.width != undefined && item.height != undefined && this.isScrolling) {
      this.item = item.item;
      this.orientation = item.orientation;

      this.ratio = (item.width / item.height) ?? 1.0;
      this.currentUri = this.getLCDUri(this.item.uri, this.item.path, this.item.getDateModified?.());
      Log.info(TAG, `ImageFlushItem onItemChanged ${this.item.uri}`);
    }
    if (this.checkNeedJustify()) {
      this.justifyWidth = this.needJustifyWidth();
      this.imageWidth = this.justifyWidth ? Constants.PERCENT_100 : undefined;
      this.imageHeight = !this.justifyWidth ? Constants.PERCENT_100 : undefined;
    } else {
      this.imageWidth = px2vp(this.item?.width)?.toString();
      this.imageHeight = px2vp(this.item?.height)?.toString();
    }
  }

  /* instrument ignore next */
  private getLCDUri(sourceUri: string, path: string, modifiedDate: number): string {
    return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=-1&height=-1&path=${path}`;
  }

  /* instrument ignore next */
  private isVideo(): boolean {
    return this.item?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
  }

  /**
   * 图片是否需要默认撑满
   *
   * @returns
   */
  private checkNeedJustify(): boolean {
    // 资源宽高小于窗口宽高
    let isResourceSmaller: boolean = vp2px(this.windowLayoutWidth) > this.item?.width &&
      vp2px(this.windowLayoutHeight) > this.item?.height;

    // 非pc默认撑满， pc 资源宽高任一不小于窗口，根据宽高比处理
    return !DeviceInfo.isPc() || !isResourceSmaller;
  }

  /**
   * 利用图片宽高值，计算图片在 Image 中是否应该优先宽度充满整个控件
   *
   * @returns 返回 True 如果应该宽度优先充满控件
   */
  private needJustifyWidth(): boolean {
    let maxWidth = vp2px(this.windowLayoutWidth);
    let maxHeight = vp2px(this.windowLayoutHeight);
    if (this.isHalfFold && !this.isHorizontal) {
      maxHeight = maxHeight / 2;
    }
    let justifyWidth: boolean = this.ratio >= (maxWidth / maxHeight) && !this.isSubScreen;
    if (this.isHalfFold && !this.isHorizontal) {
      justifyWidth = true;
    }
    Log.debug(TAG, `maxWidth:${maxWidth}, maxHeight:${maxHeight}, ratio:${this.ratio}, justifyWidth:${justifyWidth}`);
    return justifyWidth;
  }

  private getImageShowStringSourceByTemper(): string | undefined {
    if (this.currentUri === undefined) {
      return undefined;
    }
    let newimageShowStringSource: string = this.currentUri;
    return newimageShowStringSource;
  }

  private getVisibility(): Visibility {
    if (!this.currentUri) {
      return Visibility.None;
    }

    if (!this.isScrolling && this.isLcdComplete) {
      return Visibility.None;
    }

    if (this.isImageFlushItemComplete) {
      return Visibility.Visible;
    }

    Log.error(TAG, 'Wait for the image to complete');
    return Visibility.Hidden;
  }

  build() {
    Stack() {
      Image(this.getImageShowStringSourceByTemper())
        .dynamicRangeMode(DynamicRangeMode.HIGH)
        .focusable(true)
        .translate({ y: this.isHalfFold ? Constants.PERCENT_NEGATIVE_50 : Constants.PERCENT_0 })
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .width(DeviceInfo.isPc() ? Constants.PERCENT_100 : this.imageWidth)
        .height(DeviceInfo.isPc() ? Constants.PERCENT_100 : this.imageHeight)
        .syncLoad(this.isSyncLoad)
        .onComplete(event => {
          if (event?.loadingStatus === 1) {
            this.isImageFlushItemComplete = true
          }
        })

      if (this.isHalfFold && this.isVideo()) {
        Row() {
          Image($r('app.media.ic_camera_parabar_story_play'))
            .width($r('app.float.icon_video_size'))
            .height($r('app.float.icon_video_size'))
        }
        .translate({ y: this.windowLayoutHeight / 4 })
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .visibility(this.getVisibility())
  }
}