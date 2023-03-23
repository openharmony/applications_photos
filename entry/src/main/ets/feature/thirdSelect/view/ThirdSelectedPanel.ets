/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Action } from '../../../common/view/browserOperation/Action';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Constants } from '../../../common/model/common/Constants';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { SelectUtil } from '@ohos/base/src/main/ets/utils/SelectUtil';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { DateUtil } from '@ohos/base/src/main/ets/utils/DateUtil';

const TAG = "ThirdSelectedPanel"
@Component
export struct ThirdSelectedPanel {
  static readonly THUMBNAIL_WIDTH = 256;

  selectedScroller: Scroller = new Scroller();
  onMenuClicked: Function;
  @Consume maxSelectCount: number;
  @Consume @Watch('onSelectedCountChanged') selectedCount: number;
  @State selectedMediaDataArray: Array<MediaDataItem> = [];
  @Consume isOriginalChecked: boolean;
  @Consume broadCast: Broadcast;
  private groupDataSource: GroupItemDataSource;

  onSelectedCountChanged() {
    this.selectedMediaDataArray = this.groupDataSource.getSelectedItems();
    this.selectedScroller.scrollEdge(Edge.End);
  }

  getThumbnailSafe(sourceUri: string, size?) {
    try{
      if (size) {
        return `${sourceUri}/thumbnail/${size.width}/${size.height}`;
      } else {
        return `${sourceUri}/thumbnail/${MediaConstants.DEFAULT_SIZE}/${MediaConstants.DEFAULT_SIZE}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}`);
      return null;
    }
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.selected_photos_count", this.selectedCount, this.maxSelectCount))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
        Row() {
          Radio({ value: "", group: "" })
            .checked(this.isOriginalChecked)
            .onClick(() => {
              this.isOriginalChecked = !this.isOriginalChecked;
            })

          Text($r("app.string.filter_original_text"))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_hint'))
            .fontWeight(FontWeight.Regular)
            .margin({ left: $r('app.float.third_selected_toggle_icon_margin_right') })
        }
        .alignItems(VerticalAlign.Center)
        .markAnchor({
          x: 0,
          y: $r('app.float.third_selected_panel_original_markAnchor')
        })
        .opacity(this.selectedCount > 0 ? 1 : $r('app.float.disable_button_opacity'))

        Text($r("app.string.complete"))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
          .fontWeight(FontWeight.Medium)
          .enabled(this.selectedCount > 0 ? true : false)
          .opacity(this.selectedCount > 0 ? 1 : $r('app.float.disable_button_opacity'))
          .onClick(() => {
            this.onMenuClicked(Action.OK);
          })
      }
      .width("100%")
      .height($r('app.float.third_selected_panel_title_height'))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Bottom)
      .padding({
        left: $r('sys.float.ohos_id_max_padding_start'),
        right: $r('sys.float.ohos_id_max_padding_end'),
        bottom: $r('app.float.third_selected_panel_image_padding_top')
      })

      if (this.selectedCount > 0) {
        Scroll(this.selectedScroller) {
          Row({ space: 8 }) {
            ForEach(this.selectedMediaDataArray, (selectedItem: MediaDataItem) => {
              Stack({ alignContent: Alignment.Start }) {
                Image(this.getThumbnailSafe(selectedItem.uri))
                  .height("100%")
                  .aspectRatio(1)
                  .objectFit(ImageFit.Cover)
                  .autoResize(false)
                  .onError(() => {
                    Log.error(TAG, 'item Image error');
                  })
                  .onComplete(() => {
                    Log.debug(TAG, `Draw the image! ${this.getThumbnailSafe(selectedItem.uri)}`);
                  })

                if (selectedItem.mediaType == MediaLib.MediaType.VIDEO) {
                  Column()
                    .position({ x: '0%', y: '50%' })
                    .height('50%')
                    .width('100%')
                    .linearGradient({
                      angle: 0,
                      colors: [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
                    })
                  Text(DateUtil.getFormattedDuration(selectedItem.duration))
                    .fontSize($r('sys.float.ohos_id_text_size_caption'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor($r('app.color.text_color_above_picture'))
                    .lineHeight($r('app.float.grid_item_text_line_height'))
                    .position({ x: '0%', y: '100%' })
                    .markAnchor({
                      x: $r('app.float.grid_item_duration_markAnchor_x'),
                      y: $r('app.float.grid_item_duration_markAnchor_y')
                    })
                    .margin({ right: $r('app.float.grid_item_duration_margin_right') })
                }

                if (selectedItem.favouriteStatus == 1) {
                  Image($r('app.media.ic_favorite_overlay'))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .objectFit(ImageFit.Contain)
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({
                      x: $r('app.float.grid_item_favor_markAnchor_x'),
                      y: $r('app.float.grid_item_favor_markAnchor_y')
                    })
                }

                Image($r('app.media.ic_gallery_public_cancel_bg'))
                  .height($r('app.float.icon_size'))
                  .width($r('app.float.icon_size'))
                  .objectFit(ImageFit.Contain)
                  .position({ x: '100%', y: '0%' })
                  .markAnchor({
                    x: $r('app.float.grid_item_favor_markAnchor_x'),
                    y: $r('app.float.grid_item_favor_markAnchor_y')
                  })
                  .onClick(() => {
                    selectedItem.setSelect(false);
                    this.broadCast.emit(BroadcastConstants.SELECT, [selectedItem.index]);
                  })
              }
              .height("100%")
              .aspectRatio(1)
            }, item => JSON.stringify(item))
          }
          .margin({
            left: $r('sys.float.ohos_id_max_padding_start'),
            right: $r('sys.float.ohos_id_max_padding_end'),
            top: $r('app.float.third_selected_panel_image_padding_top'),
            bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed')
          })
        }
        .width("100%")
        .height($r('app.float.third_selected_panel_image_height'))
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
      } else {
        Column() {
          Text($r("app.string.select_items_to_add"))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_secondary'))
            .fontWeight(FontWeight.Regular)
        }
        .width("100%")
        .height($r('app.float.third_selected_panel_image_height'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({
          left: $r('sys.float.ohos_id_max_padding_start'),
          right: $r('sys.float.ohos_id_max_padding_end')
        })
      }
    }
    .backgroundColor($r("sys.color.ohos_id_color_background"))
  }
}