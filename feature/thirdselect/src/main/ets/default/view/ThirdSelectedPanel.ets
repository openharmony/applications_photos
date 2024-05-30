/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import {
  Action,
  BroadCast,
  BroadCastConstants,
  Constants,
  DateUtil,
  Log,
  MediaDataSource,
  MediaItem,
  ScreenManager,
  ThirdSelectManager,
  UserFileManagerAccess
} from '@ohos/common';
import { IS_HORIZONTAL, THIRD_SELECT_IS_ORIGIN, THUMBNAIL_WIDTH } from '../utils/ThirdSelectConstants';

const TAG: string = 'thiSel_ThirdSelectedPanel';

interface WidthAndHeight {
  height: number;
  width: number;
};

@Component
export struct ThirdSelectedPanel {
  onMenuClicked: Function = (): void => {};
  maxSelectCount: number = 0;
  @Provide selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  selectManager: ThirdSelectManager | null = null;
  @State itemArray: Array<MediaItem> = [];
  @StorageLink(THIRD_SELECT_IS_ORIGIN) isOriginalChecked: boolean = false;
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Consume broadCast: BroadCast;
  @Link isShowBar: boolean;
  @Prop currentUri: string = '';
  isBrowserMode: boolean = false;
  isMultiPick = true;
  mTransition: string = '';
  isFromFa: boolean = false;
  dataSource: MediaDataSource | null = null;
  private selectedScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.selectManager = AppStorage.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER) as ThirdSelectManager;
    this.onSelectedCountChanged();
  }

  onSelectedCountChanged(): void {
    this.selectedCount = this.totalSelectedCount;
    this.itemArray = this.selectManager == null ? [] : this.selectManager.getSelectItems();
    Log.debug(TAG, `call scroll to edge, current count ${this.itemArray.length} this.selectedCount is: ${this.selectedCount}`);
    this.selectedScroller.scrollEdge(Edge.End);
  }

  refreshSelectData(refresh: boolean): void {
    this.selectedCount = this.totalSelectedCount;
    this.itemArray = this.selectManager == null ? [] : this.selectManager.getSelectItems();
    Log.debug(TAG, `call scroll to edge, current count ${this.itemArray.length}`)
    this.selectedScroller.scrollEdge(Edge.End);
  }

  getThumbnailSafe(sourceUri: string, path: string, size?: WidthAndHeight): string {
    try {
      if (size) {
        if (size.width != 0 && size.height != 0) {
          return `${sourceUri}?oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
        } else {
          Log.warn(TAG, 'getThumbnailSafe with width==0 and height==0, so do not use thumbnail' + JSON.stringify(size));
          return `${sourceUri}`;
        }
      } else {
        return `${sourceUri}?oper=thumbnail&width=${THUMBNAIL_WIDTH}&height=${THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}`);
      return '';
    }
  }

  @Builder
  buildRadio() {
    if (this.isBrowserMode) {
      Image(this.isOriginalChecked ? $r('app.media.picker_radio_selected') : $r('app.media.picker_radio_unselected'))
        .key('Original')
        .width($r('app.float.icon_size'))
        .aspectRatio(1)
        .onClick((): void => this.clickOriginButton())
    } else {
      Radio({ value: '', group: this.mTransition })
        .key('Original')
        .checked(this.isOriginalChecked)
        .margin(0)
        .onClick((): void => this.clickOriginButton())
    }
  }

  @Builder
  buildTitle() {
    Stack() {
      Row() {
        Text($r('app.string.selected_photos_count', this.selectedCount, this.maxSelectCount))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor(this.selectTextColor())
          .fontWeight(FontWeight.Regular)
          .key('currentSelectCount')

        Button($r('app.string.complete'))
          .key('Complete')
          .enabled(this.isButtonEnabled() ? true : false)
          .opacity(this.isButtonEnabled() ? 1 : $r('app.float.disable_button_opacity'))
          .fontSize($r('sys.float.ohos_id_text_size_button3'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .backgroundColor(this.isBrowserMode ? $r('sys.color.ohos_id_color_activated_dark') : $r('sys.color.ohos_id_color_activated'))
          .width($r('app.float.picker_panel_button_width'))
          .height($r('app.float.picker_panel_button_height'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.onMenuClicked(Action.OK);
          })
      }
      .width('100%')
      .height($r('app.float.third_selected_panel_title_height'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('sys.float.ohos_id_max_padding_start'),
        right: $r('sys.float.ohos_id_max_padding_end')
      })

      Row() {
        this.buildRadio()
        Text($r('app.string.filter_original_text'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor(this.isBrowserMode ? $r('sys.color.ohos_id_color_text_primary_dark') : $r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Regular)
          .margin({ left: $r('app.float.third_selected_toggle_icon_margin_right') })
      }
      .align(Alignment.Center)
      .alignItems(VerticalAlign.Center)
      .visibility(this.isFromFa ? Visibility.Hidden : Visibility.Visible)
    }
  }

  @Builder
  buildThumbnailItem(item: MediaItem, index: number) {
    Stack({ alignContent: Alignment.Start }) {
      Image(item?.thumbnail)
        .height('100%')
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .autoResize(false)
        .onError(() => {
          Log.error(TAG, 'item Image error');
        })
        .onComplete(() => {
          Log.debug(TAG, `Draw the image! ${item?.uri}`);
        })
        .onClick(() => {
          this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [
            '',
            item,
          this.getPosition(item),
            'thiSel_ThirdSelectPhotoGridBase' + item?.getHashCode() + true,
            true
          ]);
        })
      // video duration
      if (item?.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        Row() {
          Text(DateUtil.getFormattedDuration(item?.duration))
            .fontSize($r('sys.float.ohos_id_text_size_caption'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('app.color.text_color_above_picture'))
            .lineHeight(12)
            .margin({
              left: $r('app.float.grid_item_text_margin_lr'),
              bottom: $r('app.float.grid_item_text_margin_bottom')
            })
        }
        .height('100%')
        .width('100%')
        .hitTestBehavior(HitTestMode.None)
        .alignItems(VerticalAlign.Bottom)
      }
      Image($r('app.media.ic_gallery_public_cancel_bg'))
        .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
        .key('ThirdSelectCancel' + item?.uri)
        .objectFit(ImageFit.Contain)
        .position({
          x: $r('app.float.picker_panel_cancel_x'),
          y: $r('app.float.picker_panel_cancel_y')
        })
        .onClick(() => {
          Log.debug(TAG, `click cancel item ${item?.uri}`);
          this.broadCast.emit(BroadCastConstants.SELECT, [0, item?.uri, false]);
        })
      Image($r('app.media.picker_border_img'))
        .height('100%')
        .aspectRatio(1)
        .fillColor($r('sys.color.ohos_id_color_focused_bg_dark'))
        .objectFit(ImageFit.Cover)
        .autoResize(false)
        .visibility(item?.uri === this.currentUri ? Visibility.Visible : Visibility.None)
        .hitTestBehavior(HitTestMode.None)
    }
    .height('100%')
    .aspectRatio(1)
  }

  @Builder
  buildThumbnailList() {
    List({ scroller: this.selectedScroller, space: 8 }) {
      ForEach(this.itemArray, (item: MediaItem, index?: number) => {
        ListItem() {
          this.buildThumbnailItem(item, index as number);
        }
        .width($r('app.float.third_selected_panel_image_height'))
        .aspectRatio(1)
        .margin({
          left: index == 0 ? $r('sys.float.ohos_id_max_padding_start') : 0,
          right: index == this.itemArray.length - 1 ? $r('sys.float.ohos_id_max_padding_end') : 0
        })
      }, (item: MediaItem) => item?.getHashCode())
    }
    .width('100%')
    .height('100%')
    .listDirection(Axis.Horizontal)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
  }

  @Builder
  buildDefault() {
    Column() {
      Text($r('app.string.select_items_to_add'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor(this.isBrowserMode ? $r('sys.color.ohos_id_color_secondary_dark') : $r('sys.color.ohos_id_color_secondary'))
        .fontWeight(FontWeight.Regular)
    }
    .width('100%')
    .height($r('app.float.third_selected_panel_empty_height'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: $r('app.float.third_selected_panel_image_padding_top'),
    })
    .padding({
      left: $r('sys.float.ohos_id_max_padding_start'),
      right: $r('sys.float.ohos_id_max_padding_end')
    })
  }

  build() {
    Column() {
      this.buildTitle()

      if (this.isMultiPick) {
        if (this.selectedCount > 0) {
          Row() {
            this.buildThumbnailList()
          }
          .width('100%')
          .padding({
            top: $r('app.float.third_selected_panel_image_padding_top'),
            bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed')
          })
        } else {
          this.buildDefault()
        }
      }
    }
    .width('100%')
    .height(this.isMultiPick ? $r('app.float.third_selected_panel_height') : $r('app.float.third_selected_panel_title_height'))
    .backgroundColor(this.isBrowserMode ? $r('sys.color.ohos_id_color_card_bg_dark') : $r('sys.color.ohos_id_color_card_bg'))
    .sharedTransition('ThirdSelectPhotoBrowserActionBar', {
      curve: Curve.Linear,
      zIndex: Constants.NUMBER_1,
      type: SharedTransitionEffectType.Static
    })
    .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
  }

  private getPosition(item: MediaItem): number {
    if (this.dataSource) {
      return this.dataSource.getDataIndex(item) + this.dataSource.getGroupCountBeforeItem(item);
    } else {
      return Constants.NOT_FOUND;
    }
  }

  private selectTextColor() {
    let normalColor = this.isBrowserMode ?
    $r('sys.color.ohos_id_color_text_primary_dark') : $r('sys.color.ohos_id_color_text_primary');
    if (!this.isHorizontal) {
      return normalColor;
    }
    let warnColor = this.isBrowserMode ?
    $r('sys.color.ohos_id_color_warning_dark') : $r('sys.color.ohos_id_color_warning');
    return this.isMultiPick && this.selectedCount >= this.maxSelectCount ? warnColor : normalColor;
  }

  private isButtonEnabled(): boolean {
    return !this.isMultiPick || this.selectedCount > 0;
  }

  private clickOriginButton(): void {
    this.isOriginalChecked = !this.isOriginalChecked;
    Log.info(TAG, `origin clicked: ${this.isOriginalChecked}`);
  }
}