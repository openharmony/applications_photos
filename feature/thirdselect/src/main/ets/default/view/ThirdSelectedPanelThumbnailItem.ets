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
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';

/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectedPanelThumbnailItem';

@Component
export struct ThirdSelectedPanelThumbnailItem {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  public item: MediaItem | null = null;
  public index: number = 0;
  @LocalStorageLink('showCancel') showCancel: boolean = true;
  @Consume broadCast: BroadCast;
  public selectManager: ThirdSelectManager | null = null;
  @Prop currentUri: string = '';
  @Prop private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State selected: boolean = false;
  @State focus: boolean = false;
  public dataSource: MediaDataSource | null = null;
  @State thumbnailWidth: string | undefined = Constants.PERCENT_100;
  @State thumbnailHeight: string | undefined = Constants.PERCENT_100;
  @State ratio: number = 0;
  @State isLoadImageError: boolean = false;
  public thumbnailSize: Size | null = null;
  private panelId: string = '';
  private funcUpdateSelect: Function = (updateUri: string, select: boolean): void => {
    this.updateSelect(updateUri, select);
  };
  private isSwiperAnimate: boolean = false;
  private updateSwiperAnimate: Function = (isSwiperAnimate: boolean): void => {
    this.isSwiperAnimate = isSwiperAnimate;
  };
  private funcUpdateSelectFocus: Function = (updateUri: string): void => this.updateSelectFocus(updateUri);
  private colorTheme: CustomTheme = {}
  private userId: number = -1;
  private iconFontSize: string = '12vp';
  //是否子窗picker模式
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;

  aboutToAppear(): void {
    if (this.item !== null) {
      Log.info(TAG, `aboutToAppear this.item.uri is: ${this.item.uri}, this.currentUri is: ${this.currentUri}`);
    }
    this.focus = this.item === null ? false : this.item.uri === this.currentUri;
    if (this.broadCast) {
      this.broadCast?.on(BroadCastConstants.UPDATE_SWIPER_ANIMATION, this.updateSwiperAnimate)
      this.broadCast.on(this.panelId + BroadCastConstants.UPDATE_SELECT, this.funcUpdateSelect);
      this.broadCast.on(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, this.funcUpdateSelectFocus);
    }
    this.userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    this.initGridThumbnail();
  }

  updateSelect(updateUri: string, select: boolean): void {
    Log.info(TAG, `aboutToAppear BroadCastConstants.UPDATE_SELECT updateUri : ${updateUri}, select: ${select}`);
    if (updateUri === this.item?.uri) {
      this.selected = select;
    }
  }

  updateSelectFocus(updateUri: string): void {
    Log.info(TAG, `aboutToAppear BroadCastConstants.UPDATE_SELECT_FOCUS updateUri : ${updateUri}`);
    if (updateUri === this.item?.uri) {
      this.focus = true;
    } else {
      this.focus = false;
    }
  }

  private getPosition(item: MediaItem): number {
    if (this.dataSource === null) {
      return Constants.NOT_FOUND;
    }
    return this.dataSource.getDataIndex(item);
  }

  aboutToDisappear(): void {
    if (this.item !== null) {
      Log.debug(TAG, `aboutToDisappear this.item.uri is: ${this.item.uri}, this.currentUri is: ${this.currentUri}`);
    }
    if (this.broadCast) {
      this.broadCast?.off(BroadCastConstants.UPDATE_SWIPER_ANIMATION, this.updateSwiperAnimate)
      this.broadCast.off(this.panelId + BroadCastConstants.UPDATE_SELECT, this.funcUpdateSelect);
      this.broadCast.off(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, this.funcUpdateSelectFocus);
    }
  }

  private getActualImage(): string {
    if (this.userId < 0 || !this.item) {
      return this.item?.thumbnail ?? '';
    }
    return this.item?.thumbnail + (this.item?.thumbnail.includes('?') ? '&' : '?') + 'user=' + this.userId;
  }

  @Builder
  buildImage() {
    Image(this.getActualImage())
      .draggable(false)
      .width(DeviceInfo.isPc() ? this.thumbnailWidth : Constants.PERCENT_100)
      .height(DeviceInfo.isPc() ? this.thumbnailHeight : Constants.PERCENT_100)
      .aspectRatio(this.ratio)
      .objectFit(this.isVerdeFoldable ? ImageFit.Contain : ImageFit.Cover)
      .autoResize(false)
      .onError((event: ImageError): void => {
        this.isLoadImageError = true;
        if (this.item !== null) {
          Log.error(TAG, `thumbnail load error, path: ${this.item.thumbnail}, error: ${event.message}`);
        }
      })
      .onComplete((): void => {
        if (this.item !== null) {
          Log.debug(TAG, `Draw the image! ${this.item.uri}`);
        }
      })
      .onClick((): void => {
        this.showCancel = false;
        if (this.selectManager !== null && !this.selectManager.isPreview) {
          this.selectManager.isPreview = true;
          this.selectManager.previewSet.clear();

          ((this.selectManager.clickedSet) as Set<string>).forEach(
            (value: string) => {
              this.selectManager?.previewSet.add(value as string);
            });
        }
        if (this.item !== null) {
          Log.debug(TAG, `onClick item.uri: ${this.item.uri}, this.index: ${
          this.index}, item.displayName: ${this.item.displayName}`);
          if (this.isSwiperAnimate) {
            Log.info(TAG, 'Not allow onClick when isSwiperAnimate');
            return;
          }
        }
        if (this.dataSource) {
          this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            [
              this.showCancel,
              '',
              this.item,
              undefined,
              undefined,
              true,
            ]);
        } else {
          this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            [
              this.showCancel,
              '',
              this.item,
              undefined,
              undefined,
              true,
            ]);
        }
        this.currentUri = this.item?.uri ?? '';
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, [this.currentUri]);
      })
  }

  @Builder
  buildCancel() {
    if (this.isPickerUsedSubwindow || DeviceInfo.isTv()) {
      Stack({ alignContent: Alignment.Center }) {
        if (!DeviceInfo.isTv()) {
          Circle({
            width: px2vp(this.rsc.getNumber($r('sys.float.padding_level11'))),
            height: px2vp(this.rsc.getNumber($r('sys.float.padding_level11'))),
          })
            .fillOpacity(0.2)
            .fill(Color.Black)
        }

        SymbolGlyph(DeviceInfo.isTv() ? $r('sys.symbol.xmark_circle_fill') : $r('sys.symbol.xmark'))
          .fontColor([DeviceInfo.isTv() ? $r('sys.color.font_secondary') : $r('app.color.ohos_id_color_white_icon')])
          .opacity(1.0)
          .draggable(false)
          .width($r('app.float.picker_select_cancel_symbol_size'))
          .height($r('app.float.picker_select_cancel_symbol_size'))
          .fontSize($r('app.float.picker_select_cancel_symbol_size'))
          .accessibilityText($r('app.string.action_cancel'))
          .onClick((): void => {
            Log.info(TAG, `click cancel item ${this.item?.uri}`);
            this.broadCast.emit(BroadCastConstants.SELECT, [0, this.item?.uri ?? '', false]);
          })
      }
      .position({
        x: $r('app.float.picker_panel_subwindow_cancel_x'),
        y: $r('app.float.picker_panel_subwindow_cancel_y'),
      })
    } else {
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: '100%', height: '100%' })
          .fillOpacity(0.2)
          .fill(Color.Black)
        SymbolGlyph($r('sys.symbol.xmark'))
          .padding($r('app.float.adjust_params_bar_circle3'))
          .fontColor([$r('app.color.ohos_id_color_white_icon')])
          .opacity(1.0)
          .draggable(false)
          .height('100%')
          .width('100%')
          .fontSize(this.iconFontSize)
          .accessibilityText($r('app.string.action_cancel'))
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .onClick((): void => {
            if (this.item !== null) {
              Log.debug(TAG, `click cancel item ${this.item.uri}`);
            }
            this.broadCast.emit(BroadCastConstants.SELECT, [0, this.item?.uri ?? '', false]);
          })
      }
      .width($r('app.float.icon_size'))
      .height($r('app.float.icon_size'))
      .padding(1)
      .position({
        x: UiUtil.isMirrorMode() ? 0 : this.isVerdeFoldable ? $r('app.float.picker_panel_cancel_vde_x') : $r('app.float.picker_panel_cancel_x'),
        y: $r('app.float.picker_panel_cancel_y'),
      })
    }
  }

  @Builder
  buildMask() {
    Column()
      .aspectRatio(1)
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.item_selection_bg_color'))
      .onClick((): void => {
        if (this.item !== null) {
          Log.debug(TAG, `onClick item.uri: ${this.item.uri}, this.index: ${
          this.index}, item.displayName: ${this.item.displayName}`);
        }
        if (this.dataSource) {
          this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            [
              this.showCancel,
              '',
              this.item,
              undefined,
              undefined,
            ]);
        } else {
          this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
            [
              this.showCancel,
              '',
              this.item,
              undefined,
              undefined,
            ]);
        }
        this.currentUri = this.item?.uri ?? '';
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, [this.currentUri]);
      })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isLoadImageError) {
        Image((this.item != null && this.item?.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO)
          ? $r('app.media.alt_video_placeholder') : $r('app.media.alt_placeholder'))
          .draggable(false)
          .aspectRatio(1)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: 0,
          })
          .objectFit(ImageFit.Cover)
          .autoResize(false)
          .onAppear((): void => {
            Log.debug(TAG, 'appear the default image!');
          })
      } else {
        this.buildImage();
      }

      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.buildPickerImageMask();
      }

      // video duration
      if (this.item?.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?? false) {
        Row() {
          Text(DateUtil.getFormattedDuration(this.item?.duration ?? 0))
            .draggable(false)
            .fontSize($r('sys.float.ohos_id_text_size_caption'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('app.color.text_color_above_picture'))
            .lineHeight(12)
            .margin({
              left: $r('app.float.grid_item_text_margin_lr'),
              bottom: $r('app.float.grid_item_text_margin_bottom'),
            })
        }
        .height('100%')
        .width('100%')
        .hitTestBehavior(HitTestMode.None)
        .alignItems(VerticalAlign.Bottom)
      }

      this.buildCancel();

      if (!this.selected && !DeviceInfo.isTv()) {
        this.buildMask();
      }

      if (!DeviceInfo.isTv()) {
        Image($r('app.media.picker_border_img'))
          .draggable(false)
          .height('100%')
          .aspectRatio(1)
          .fillColor(this.colorTheme?.colors?.backgroundEmphasize ?? $r('sys.color.ohos_id_color_badge'))
          .objectFit(ImageFit.Cover)
          .autoResize(false)
          .visibility(this.focus ? Visibility.Visible : Visibility.None)
          .hitTestBehavior(HitTestMode.None)
      }
    }
    .height('100%')
    .aspectRatio(1)
  }

  @Builder
  buildPickerImageMask() {
    Column() {
      Column() {
      }
      .height('100%')
      .width('100%')
      .hitTestBehavior(HitTestMode.None)
      .linearGradient({
        direction: GradientDirection.Bottom, // 渐变方向
        colors: this.item?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
          [[$r('app.color.color_secondary'), 0.0], [Color.Transparent, 0.4],
            [Color.Transparent, 0.6], [$r('app.color.color_secondary'), 1.0]] :
          [[$r('app.color.color_secondary'), 0.0], [Color.Transparent, 0.4]]
      })
    }
    .hitTestBehavior(HitTestMode.None)
    .height('100%')
    .width('100%')
    .borderRadius($r('app.float.tv_checkbox_border_radius'))
    .border({ width: this.focus ? 1.5 : 0, color: $r('sys.color.ohos_id_color_foreground') })
  }

  initGridThumbnail() {
    if (!this.item) {
      return;
    }
    let size: Size = ImageUtil.getThumbnailSize(this.item.width, this.item.height, true);
    let thumbnailWidth = size.width;
    let thumbnailHeight = size.height;
    this.thumbnailSize = size;
    this.ratio = thumbnailWidth / thumbnailHeight;
    this.resizeGridThumbnail();
  }

  /**
   * 宫格内等比例缩略图宽高计算
   */
  resizeGridThumbnail() {
    if (!DeviceInfo.isPc()) {
      return;
    }
    const componentWidth: number = px2vp(UiUtil.getResourceNumber($r('app.float.third_selected_panel_image_height')));

    let size: Size | null = this.thumbnailSize;
    // 资源宽高均小于宫格宽高
    let isResourceSmaller: boolean = componentWidth > px2vp(size?.width) && componentWidth > px2vp(size?.height);
    if (isResourceSmaller) {
      this.thumbnailWidth = String(px2vp(size?.width));
      this.thumbnailHeight = String(px2vp(size?.height));
      return;
    }
    // 等比例处理资源
    let justifyWidth: boolean = this.ratio >= (componentWidth / componentWidth);
    if (justifyWidth) {
      this.thumbnailWidth = Constants.PERCENT_100;
      this.thumbnailHeight = undefined;
    } else {
      this.thumbnailHeight = Constants.PERCENT_100;
      this.thumbnailWidth = undefined;
    }
  }
}