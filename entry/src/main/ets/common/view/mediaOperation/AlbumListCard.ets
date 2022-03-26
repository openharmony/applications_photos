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

import {BroadCast} from '../../utils/BroadCast.ets'
import {Logger} from '../../../feature/browser/utils/Logger.ets';
import {BroadCastConstants} from '../../model/common/BroadCastConstants.ets';
import {AlbumInfo} from '../../model/browser/album/AlbumInfo.ets';

@Component
export struct AlbumListCard {
    @Consume broadCast: BroadCast;
    item: AlbumInfo;
    logger: Logger = new Logger('MediaOperationPage');

    private aboutToAppear(): void {
        this.logger.info(`album mediaSet ${JSON.stringify(this.item)}`);
    }

    mediaOperation() {
        this.broadCast.emit(BroadCastConstants.MEDIA_OPERATION, [this.item.name]);
    }

    showMediaRes(): Resource {
        if (this.item.videoCount == 0) {
            return $r('app.string.show_photo_num', this.item.count);
        } else if (this.item.videoCount == this.item.count) {
            return $r('app.string.show_video_num', this.item.count);
        } else {
            return $r('app.string.show_photo_video_num', this.item.count - this.item.videoCount, this.item.videoCount);
        }
    }

    build() {
        Row() {
            Image(this.item.coverUri)
                .height($r('app.float.list_card_image_size'))
                .width($r('app.float.list_card_image_size'))
                .borderRadius($r('sys.float.ohos_id_corner_radius_default_s'))
            Column() {
                Text(this.item.displayName)
                    .fontSize($r('sys.float.ohos_id_text_size_body1'))
                    .fontColor($r('sys.color.ohos_id_color_primary'))
                    .padding({
                        bottom: $r('sys.float.ohos_id_text_margin_vertical')
                    })
                if (this.item.count != 0) {
                    Text(this.showMediaRes())
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                }
            }
            .alignItems(HorizontalAlign.Start)
            .padding({
                left: $r('app.float.crop_vertical_padding'),
            })
            Divider().vertical(false).strokeWidth(0.5)
                .color($r('sys.color.ohos_id_color_list_separator'))
                .position({x: '0%', y: '100%'})
                .margin({left: $r('app.float.album_list_card_divider_margin_left')})
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height($r('app.float.list_card_height'))
        .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
        .onClick(() => {
            this.mediaOperation();
        })
    }
}