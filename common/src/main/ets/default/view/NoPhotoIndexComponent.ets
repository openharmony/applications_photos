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

import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '../model/common/ScreenManager';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { Log } from '../utils/Log';
import type { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { Constants } from '../model/common/Constants';
import lazy { i18n } from '@kit.LocalizationKit';

const IMAGE_SCREEN_RATIO = 0.8;
const IMAGE_SCREEN_RATIO_LEFT = 0.4;
const IMAGE_LEFT_PLUS_RIGHT = 96;
const IMAGE_TABBAR_HEIGHT = 40;
const ACTIONBAR_HEIGHT: number = 56;
/* instrument ignore file */
const TAG: string = 'common_NoPhotoIndexComponent';

export interface EmptyPageProp {
  illustration: Resource | string,
  title: Resource | string,
  subTitle: Resource | string,
  tips?: Resource | string,
  extraInfo?: string,
  hasBarSpace: boolean,
  tipsClickEvent?: () => void,
}

@Observed
export class NoPhotoStyler {
  public width: Length | undefined = '100%';
  public height: Length | undefined = '100%';
}

@Component
export struct NoPhotoIndexComponent {
  @StorageLink('digging_hole_camera_area') private diggingHoleCameraArea:
    DiggingHoleCameraArea = getScreen().getDiggingHoleCameraArea();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  prop: EmptyPageProp = {
    illustration: '',
    title: '',
    subTitle: '',
    hasBarSpace: false,
  };
  // set an initial value temporarily, later change to 0.
  @State imageSize: number = 0;
  @State isHorizontalImageSize: number = 0;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private reSizeFunc = (isShowSideBar: Boolean): void => this.reSizeLayout(isShowSideBar);
  @State private isShowSideBar: Boolean = true;
  private isVerdeFoldable: Boolean = false;
  @Link private subTitle: Resource | string;
  @State noPhotoStyler: NoPhotoStyler = new NoPhotoStyler();
  @Prop private isPcSdCardShow: Boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
    this.updateImageSize();
    this.appBroadCast.on(BroadCastConstants.ON_SIDEBAR_CHANGED, this.reSizeFunc);
  }

  reSizeLayout(isShowSideBar: Boolean): void {
    this.isShowSideBar = isShowSideBar;
    Log.info(TAG, `on resize layout this.isShowSideBar=${isShowSideBar}`);
    this.updateImageSize();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SIDEBAR_CHANGED, this.reSizeFunc);
  }

  updateImageSize(): void {
    let winWidth = getScreen().getWinWidth();
    let winWidthHorizontalScreenPhone = (getScreen().getWinWidth() - IMAGE_LEFT_PLUS_RIGHT) * IMAGE_SCREEN_RATIO_LEFT;
    let winHeightHorizontalScreenPhone = getScreen().getWinHeight() - IMAGE_TABBAR_HEIGHT;
    let winHeightHalf = getScreen().getWinHeight() / 2;
    this.imageSize = winWidth < winHeightHalf ? winWidth * IMAGE_SCREEN_RATIO : winHeightHalf * IMAGE_SCREEN_RATIO;
    this.isHorizontalImageSize = (winHeightHorizontalScreenPhone > winWidthHorizontalScreenPhone) ?
      (winWidthHorizontalScreenPhone * IMAGE_SCREEN_RATIO) : (winHeightHorizontalScreenPhone * IMAGE_SCREEN_RATIO);

    interface ImageSize {
      winWidth: number;
      winHeightHalf: number;
      size: number;
      extra: string | undefined;
    }

    let params: ImageSize = {
      winWidth: winWidth,
      winHeightHalf: winHeightHalf,
      size: this.imageSize,
      extra: this.prop.extraInfo,
    }
    Log.info(TAG, JSON.stringify(params));
  }

  @Builder
  buildPhotoOrAlbumIco() {
    Column() {
      Image(this.prop.illustration)
        .draggable(false)
        .width(this.isHorizontalImageSize)
        .height(this.isHorizontalImageSize)
        .key('EmptyPhotoOrAlbumIco')
        .onError((event: ImageError) => {
          Log.info(TAG, `image show error index:${this.prop.extraInfo}, error: ${event.message}`);
        })
        .onComplete((): void => {
          Log.info(TAG, `EmptyPhotoOrAlbumIco onComplete:${this.isHorizontal} ${this.isHorizontalImageSize}`);
        })
    }
    .width('40%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildEmptyPhotoOrAlbumHeadTitle() {
    Column() {
      Text(this.prop.title)
        .draggable(false)
        .fontSize(20)
        .maxFontScale(2.0)
        .fontWeight(FontWeight.Medium)
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Start)
        .lineHeight(i18n.System.getSystemLanguage() == 'bo' ? 26 : 24)
        .margin({
          bottom: 8,
        })
        .key('EmptyPhotoOrAlbumHeadTitle')
      Text(this.subTitle)
        .draggable(false)
        .fontWeight(FontWeight.Regular)
        .fontSize(14)
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)
        .margin({
          bottom: $r('sys.float.padding_level4'),
        })
        .key('EmptyPhotoOrAlbumSubTitle')
      if (this.prop.tips) {
        Text(this.prop.tips)
          .fontWeight(FontWeight.Medium)
          .draggable(false)
          .fontSize($r('sys.float.Body_M'))
          .maxFontScale(2.0)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_emphasize'))
          .textAlign(TextAlign.Start)
          .margin({
            bottom: $r('sys.float.padding_level4'),
          })
          .onClick((): void => {
            this.prop.tipsClickEvent?.();
          })
          .accessibilityRole(AccessibilityRoleType.BUTTON)
      }
    }
    .width('60%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildHorizontalTitle() {
    Column() {
      Text(this.prop.title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .fontSize($r('sys.float.Title_S'))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Start)
        .lineHeight(i18n.System.getSystemLanguage() == 'bo' ? 26 : 24)
        .margin({
          left: $r('app.float.max_padding_start'),
          right: $r('app.float.max_padding_start'),
          bottom: $r('sys.float.padding_level4'),
        })
        .key('EmptyPhotoOrAlbumHeadTitle')
      Text(this.subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .fontSize($r('sys.float.Body_M'))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)
        .margin({
          left: $r('app.float.max_padding_start'),
          right: $r('app.float.max_padding_start'),
          bottom: $r('sys.float.padding_level4'),
        })
        .key('EmptyPhotoOrAlbumSubTitle')
      if (this.prop.tips) {
        Text(this.prop.tips)
          .fontWeight(FontWeight.Medium)
          .draggable(false)
          .fontSize($r('sys.float.Body_M'))
          .maxFontScale(2.0)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_emphasize'))
          .textAlign(TextAlign.Start)
          .margin({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_start'),
            bottom: $r('sys.float.padding_level4'),
          })
          .onClick((): void => {
            this.prop.tipsClickEvent?.();
          })
          .accessibilityRole(AccessibilityRoleType.BUTTON)
      }
    }
  }

  @Builder
  buildHorizontalTabletEmpty() {
    Column() {
      Image(this.prop.illustration)
        .draggable(false)
        .width('80%')
        .margin({
          bottom: $r('app.float.image_margin_horizontal'),
        })
        .key('EmptyPhotoOrAlbumIco')
        .onError((event: ImageError) => {
          Log.info(TAG, `image show error index:${this.prop.extraInfo}, error: ${event.message}`);
        })
      this.buildHorizontalTitle();
    }
    .width('100%')
    .margin({
      top: this.prop.hasBarSpace ? $r('app.float.appbar_none_img_height') : $r('app.float.appbar_zero_height')
    })
  }

  @Builder
  buildVerticalTitle() {
    Column() {
      Text(this.prop.title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .fontSize($r('sys.float.Title_S'))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .lineHeight(i18n.System.getSystemLanguage() == 'bo' ? 26 : 24)
        .margin({
          left: $r('app.float.max_padding_start'),
          right: $r('app.float.max_padding_start'),
          bottom: $r('app.float.selected_photos_list_space'),
        })
        .key('EmptyPhotoOrAlbumHeadTitle')
      Text(this.subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .fontSize($r('sys.float.Body_M'))
        .maxFontScale(2.0)
        .textAlign(TextAlign.Center)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .margin({
          left: $r('app.float.max_padding_start'),
          right: $r('app.float.max_padding_start'),
          bottom: $r('sys.float.padding_level4'),
        })
        .key('EmptyPhotoOrAlbumSubTitle')
      if (this.prop.tips) {
        Text(this.prop.tips)
          .fontWeight(FontWeight.Medium)
          .draggable(false)
          .fontSize($r('sys.float.Body_M'))
          .maxFontScale(2.0)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_emphasize'))
          .textAlign(TextAlign.Start)
          .margin({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_start'),
            bottom: $r('sys.float.padding_level4'),
          })
          .onClick((): void => {
            this.prop.tipsClickEvent?.();
          })
          .accessibilityRole(AccessibilityRoleType.BUTTON)
      }
    }
  }

  @Builder
  buildVerticalTabletEmpty() {
    Column() {
      Image(this.prop.illustration)
        .draggable(false)
        .height(this.imageSize)
        .width(this.imageSize)
        .margin({
          bottom: $r('app.float.image_margin_horizontal'),
        })
        .key('EmptyPhotoOrAlbumIco')
        .onComplete((): void => {
          Log.info(TAG, `EmptyPhotoOrAlbumIco onComplete:${this.isHorizontal} ${JSON.stringify(this.imageSize)}`);
        })
        .onError((event: ImageError) => {
          Log.info(TAG, `image show error index:${this.prop.extraInfo}, error: ${event.message}`);
        })
      this.buildVerticalTitle();
    }
    .width('100%')
    .margin({
      top: this.prop.hasBarSpace && !this.isVerdeFoldable && !this.isPcSdCardShow ?
      $r('app.float.appbar_none_img_height') : $r('app.float.appbar_zero_height')
    })
  }

  @Builder
  buildTvEmpty() {
    Column() {
      Image($r('app.media.no_image'))
        .draggable(false)
        .height($r('app.float.tv_empty_page_picture_size'))
        .width($r('app.float.tv_empty_page_picture_size'))
        .margin({ bottom: $r('app.float.tv_empty_page_picture_bottom_padding'), })
      Text($r('app.string.no_photos_videos_head_title_album'))
        .draggable(false)
        .fontSize(21)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight(FontWeight.Regular)
        .lineHeight($r('app.float.tv_text_line_height'))
    }
    .width('100%')
    .padding({ left: $r('app.float.tv_max_padding_start'), right: $r('app.float.tv_max_padding_start'), })
    .position({ y: $r('app.float.tv_timeline_empty_page_top_padding'), })
  }

  build() {
    Row() {
      if (this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) {
        Row() {
          this.buildPhotoOrAlbumIco();
          this.buildEmptyPhotoOrAlbumHeadTitle();
        }
        .width('100%')
        .height('100%')
        .padding({
          left: 48 - this.diggingHoleCameraArea.left,
          right: 48 - this.diggingHoleCameraArea.right,
        })
        .alignItems(VerticalAlign.Center)
      } else if (DeviceInfo.isTablet() && !this.isHorizontal && this.isShowSideBar) {
        this.buildHorizontalTabletEmpty();
      } else if (DeviceInfo.isTv()) {
        this.buildTvEmpty();
      } else {
        this.buildVerticalTabletEmpty();
      }
    }
    .padding({
      left: this.isHorizontal && DeviceInfo.isPhoneUx() && this.prop.extraInfo === Constants.COMPONENT_KEY_PHOTOS ?
        this.diggingHoleCameraArea.left : 0,
      right: this.isHorizontal && DeviceInfo.isPhoneUx() && this.prop.extraInfo === Constants.COMPONENT_KEY_PHOTOS ?
        this.diggingHoleCameraArea.right : 0
    })
    .margin({
      top: !this.prop.hasBarSpace && this.isHorizontal && !DeviceInfo.isFoldable() ? -ACTIONBAR_HEIGHT : 0
    })
    .zIndex(0)
    .width(this.noPhotoStyler.width)
    .height(this.noPhotoStyler.height)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
  }
}