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

import { BroadCast } from '../../utils/BroadCast';
import { Log } from '../../utils/Log';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';

const TAG: string = 'common_AlbumListCard';

@Component
export struct AlbumListCard {
  @State isEmptyAlbum: boolean = false;
  @State useAlt: boolean = false;
  @Consume broadCast: BroadCast;
  item: AlbumInfo | null = null;
  index: number = 0;
  readonly imageCenterLength: number = 28;
  private dividerMarginRight = 12;

  aboutToAppear(): void {
    Log.info(TAG, `album mediaSet ${JSON.stringify(this.item)}`);
  }

  mediaOperation() {
    if (this.broadCast != null && this.item != null) {
      this.broadCast.emit(BroadCastConstants.MEDIA_OPERATION, [this.item.albumName, this.item.uri]);
    }
  }

  showMediaRes(): Resource | undefined {
    if (this.item != null) {
      if (this.item.videoCount == 0) {
        return $r('app.plural.show_photo_num', this.item.count, this.item.count);
      } else if (this.item.videoCount == this.item.count) {
        return $r('app.plural.show_video_num', this.item.count, this.item.count);
      } else if (this.item.videoCount == 1) {
        return $r('app.plural.show_one_video_with_photo_num', this.item.count - this.item.videoCount,
          this.item.count - this.item.videoCount, this.item.videoCount);
      } else {
        return $r('app.plural.show_multi_video_with_photo_num', this.item.count - this.item.videoCount,
          this.item.count - this.item.videoCount, this.item.videoCount)
      }
    }
    return undefined;
  }

  build() {
    Column() {
      if (this.index != 0) {
        Divider()
          .vertical(false)
          .margin({ left: $r('app.float.list_card_margin_left'), right: this.dividerMarginRight })
          .color($r('sys.color.ohos_id_color_list_separator'))
      }
      Row() {
        if (this.isEmptyAlbum) {
          Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center
          }) {
            Image($r('app.media.ic_goto_photos'))
              .width(this.imageCenterLength)
              .height(this.imageCenterLength)
              .fillColor($r('app.color.empty_or_recycle_album_icon'))
          }
          .width(this.imageCenterLength * 2)
          .height(this.imageCenterLength * 2)
          .borderRadius($r('app.float.listcard_preview_image_radius'))
          .aspectRatio(1)
          .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
          .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
          .flexShrink(0)
        } else {
          Image(this.item == null ? '' : this.item.coverUri)
            .aspectRatio(1)
            .autoResize(false)
            .objectFit(ImageFit.Cover)
            .height(this.imageCenterLength * 2)
            .width(this.imageCenterLength * 2)
            .borderRadius($r('app.float.listcard_preview_image_radius'))
            .rotate({
              centerX: this.imageCenterLength,
              centerY: this.imageCenterLength,
              z: 1,
              angle: 0
            })
            .flexShrink(0)
            .onError(() => {
              Log.debug(TAG, 'this.isEmptyAlbumalbum is empty or its cover is error');
              this.isEmptyAlbum = true;
            })
        }

        Column() {
          Text(this.item == null ? '' : this.item.albumName)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.ohos_id_color_primary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({
              bottom: $r('sys.float.ohos_id_text_margin_vertical')
            })
          if (this.item != null && this.item.count != 0) {
            Text(this.showMediaRes())
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .flexShrink(1)
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: $r('app.float.crop_vertical_padding'),
          right: $r('app.float.list_card_margin')
        })
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height($r('app.float.list_card_height'))
      .onClick(() => {
        this.mediaOperation();
      })
    }
  }
}