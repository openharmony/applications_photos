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

import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { FontUtil } from '../../utils/FontUtil';

/* instrument ignore file */
const TAG: string = 'common_AlbumListCard';

@Component
export struct AlbumListCard {
  @State isEmptyAlbum: boolean = false;
  @State useAlt: boolean = false;
  public broadCast: BroadCast | null = null;
  public item: AlbumInfo | null = null;
  readonly imageCenterLength: number = 28;
  @State private listPaddingTopAndBottom: Resource | string = $r('sys.float.padding_level6');
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;

  aboutToAppear(): void {
    this.item && Log.info(TAG, `album mediaSet ${JSON.stringify(this.item)}`);
    this.currentFontSizeScaleChange();
  }

  mediaOperation(): void {
    if (this.broadCast != null && this.item != null) {
      this.broadCast.emit(BroadCastConstants.MEDIA_OPERATION, [this.item.albumName, this.item.uri]);
    }
  }

  showMediaRes(): Resource | undefined {
    if (!this.item) {
      // Should not be here as this.item checked in calling place
      return undefined;
    }
    if (this.item.videoCount === 0) {
      return $r('app.plural.show_photo_num', this.item.count, this.item.count);
    } else if (this.item.videoCount === this.item.count) {
      return $r('app.plural.show_video_num', this.item.count, this.item.count);
    }
    return $r('app.string.show_multi_video_and_photo_num',
      UiUtil.getPluralStringSync($r('app.plural.show_photo_num'),
        (this.item?.count ?? 0) - (this.item?.videoCount ?? 0)),
      UiUtil.getPluralStringSync($r('app.plural.show_video_num'), this.item?.videoCount ?? 0)
    )
  }

  build() {
    Row() {
      if (this.isEmptyAlbum) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
        }) {
          SymbolGlyph($r('sys.symbol.picture_fill'))
            .draggable(false)
            .fontSize('28vp')
            .fontColor([$r('sys.color.ohos_id_color_click_effect')])
        }
        .width(this.imageCenterLength * 2)
        .height(this.imageCenterLength * 2)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.ohos_id_color_hover'))
        .border({ radius: $r('sys.float.corner_radius_level6') })
        .flexShrink(0)
      } else {
        Image(this.item?.coverUri)
          .draggable(false)
          .aspectRatio(1)
          .autoResize(false)
          .objectFit(ImageFit.Cover)
          .height(this.imageCenterLength * 2)
          .width(this.imageCenterLength * 2)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.item?.coverOrientation ?? 0,
          })
          .border({
            width: $r('app.float.album_card_border_width'),
            color: $r('app.color.album_card_border_color'),
            radius: $r('app.float.listcard_preview_image_radius'),
          })
          .rotate({
            centerX: this.imageCenterLength,
            centerY: this.imageCenterLength,
            z: 1,
            angle: 0,
          })
          .flexShrink(0)
          .onError((event: ImageError): void => {
            let coverPath: string = this.item?.coverUri ?? '';
            Log.error(TAG, `album is empty or its cover is error, path: ${coverPath}, error: ${event.message}`);
            this.isEmptyAlbum = true;
          })
      }

      Column() {
        Text(this.item?.albumName ?? '')
          .draggable(false)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.ohos_id_color_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({
            bottom: $r('sys.float.padding_level1'),
          })
        if (this.item?.count != 0) {
          Text(this.showMediaRes())
            .draggable(false)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .flexShrink(1)
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: $r('app.float.crop_vertical_padding'),
        right: $r('app.float.list_card_margin'),
        top: this.listPaddingTopAndBottom,
        bottom: this.listPaddingTopAndBottom,
      })
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .constraintSize({ minHeight: $r('app.float.list_card_height') })
    .onClick((): void => {
      this.mediaOperation();
    })
  }

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG, `currentFontSizeScaleChange listPaddingTopAndBottom: ${this.listPaddingTopAndBottom}`);
  }
}