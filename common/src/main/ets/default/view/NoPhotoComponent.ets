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

import lazy { getScreen, isOrientationHorizontal, ScreenManager } from '../model/common/ScreenManager';
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from '../utils/Log';
import lazy { DeviceInfo } from '../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_NoPhotoComponent';

@Component
export struct NoPhotoComponent {
  imageUri?: Resource = $r('app.media.no_image');
  @Prop title: string | Resource = '';
  // set an initial value temporarily, later change to 0.
  @State offSetY: number = 0;
  @Prop @Watch('watchWinHeight') winHeight: number = 0;
  private isThird: boolean = false;
  private isThirdSelect: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @State bigScreen: boolean = false;
  @State lAndRMargin: number = 16;
  private isFromEmptyAlbum = false;
  private newVal: Area = {
    width: 0,
    height: 0,
    position: {},
    globalPosition: {},
  };

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
  }

  watchWinHeight() {
    Log.info(TAG, `watchIsHorizontal isHorizontal: ${this.winHeight}`)
    this.getOffSetY(this.newVal);
  }

  private getAreaScreen(newVal: Area): void {
    //判断当前区域宽度是否超过600
    this.bigScreen = newVal.width > 600;
  }

  private getOffSetY(newVal: Area): void {
    let halfImageHeight = this.bigScreen ? Constants.BIG_EMPTY_ICON_SIZE / 2 : Constants.SMALL_EMPTY_ICON_SIZE / 2;
    let statusBarH = ScreenManager.getInstance().getStatusBarHeight();
    let winH = ScreenManager.getInstance().getWinHeight();
    let winDecorHeight = ScreenManager.getInstance().getWinDecorHeight();
    if (this.isThird) {
      this.offSetY = this.winHeight / 2 -
        ((newVal.globalPosition.y as number) + (newVal.height as number) / 2) +
        ((this.isHorizontal && this.isThirdSelect &&
          (!DeviceInfo.isFoldable() && !DeviceInfo.isPcOrTablet())) ? 56 : 0);
    } else {
      if (ScreenManager.getInstance().getWinWidth() > ScreenManager.getInstance().getWinHeight()) {
        if (this.isFromEmptyAlbum && DeviceInfo.isPc()) {
          this.offSetY = (winH - winDecorHeight - statusBarH) * Constants.EMPTY_PAGE_OFFSET_BIG_RADIO -
            halfImageHeight + statusBarH - Constants.ActionBarHeight - Constants.PC_ACIONBAR_MARGIN_TOP;
          return;
        } else if (this.isFromEmptyAlbum && DeviceInfo.isFoldable()) {
          this.offSetY = (winH - statusBarH) * Constants.EMPTY_PAGE_OFFSET_RADIO - halfImageHeight + statusBarH;
          return;
        } else if (this.isFromEmptyAlbum) {
          this.offSetY = (winH - statusBarH - Constants.PHOTO_GRID_PADDING_TOP) *
          Constants.EMPTY_PAGE_OFFSET_BIG_RADIO - halfImageHeight + statusBarH;
          return;
        }
        this.offSetY = ScreenManager.getInstance()
          .getWinHeight() / 2 - ((newVal.globalPosition.y as number) + (newVal.height as number) / 2);
      } else {
        Log.info(TAG, ' getOffSetY aboutToAppear');
        if (statusBarH > Constants.ActionBarHeight) {
          statusBarH = px2vp(statusBarH);
        }
        if (this.isFromEmptyAlbum) {
          this.offSetY = (winH - statusBarH) * Constants.EMPTY_PAGE_OFFSET_RADIO - halfImageHeight + statusBarH;
          return;
        }
        this.offSetY = (winH - statusBarH) * Constants.EMPTY_PAGE_OFFSET_RADIO -
          ((newVal.position.y as number + Constants.ActionBarHeight) + halfImageHeight);
      }
    }
  }

  private getMargin(newVal: Area): void {
    this.lAndRMargin = getScreen().getMargin(newVal);
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      Scroll(){
        Column() {
          Image(this.imageUri)
            .draggable(false)
            .height(DeviceInfo.isTv() ?
            $r('app.float.tv_empty_page_picture_size') : (this.bigScreen || DeviceInfo.isPc()
                ? $r('app.float.empty_page_picture_size_large') : $r('app.float.empty_page_picture_size')))
            .width(DeviceInfo.isTv() ? $r('app.float.tv_empty_page_picture_size') : (this.bigScreen || DeviceInfo.isPc()
              ? $r('app.float.empty_page_picture_size_large') : $r('app.float.empty_page_picture_size')))
            .margin({
              bottom: DeviceInfo.isTv() ? 11 : $r('sys.float.padding_level4'),
            })
            .transition(TransitionEffect.OPACITY.animation({
              duration: 200,
              curve: Curve.Sharp
            }))
          Text(this.title)
            .draggable(false)
            .fontSize(DeviceInfo.isTv() ? 21 : $r('sys.float.Body_M'))
            .fontFamily(DeviceInfo.isTv() ? 'HarmonyHeiTi' : $r('app.string.id_text_font_family_regular'))
            .fontColor(DeviceInfo.isTv() ? $r('sys.color.font_secondary') : (this.isThird ? $r('sys.color.gray_04') :
            $r('sys.color.font_tertiary')))
            .fontWeight(DeviceInfo.isTv() ? FontWeight.Regular : undefined)
            .lineHeight(DeviceInfo.isTv() ? 25 : undefined)
            .transition(TransitionEffect.OPACITY.animation({
              duration: 200,
              curve: Curve.Sharp
            }))
        }
        .width('100%')
        .padding(DeviceInfo.isTv() ?
          { left: $r('app.float.tv_max_padding_start'), right: $r('app.float.tv_max_padding_start') } :
          { left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_start') })
        .visibility((this.isThird && this.offSetY === 0) ? Visibility.Hidden : Visibility.Visible)
        .position({ y: DeviceInfo.isTv() ? $r('app.float.tv_empty_page_picture_top_padding') : undefined })
      }

    }
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .height('100%')
    .flexShrink(1)
    .onAreaChange((oldVal: Area, newVal: Area) => {
      this.getAreaScreen(newVal);
      this.getOffSetY(this.newVal);
    })
  }
}