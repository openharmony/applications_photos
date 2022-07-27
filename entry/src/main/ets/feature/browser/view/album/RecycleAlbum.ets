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

import { Logger } from '../../utils/Logger'
import { Constants } from '../../../../common/model/common/Constants'

@Component
export struct RecycleAlbum {
    @State icHeight: number = 0;
    @Consume gridHeight: number;
    logger: Logger = new Logger('RecycleAlbum');
    gridAspectRatio = Constants.CARD_ASPECT_RATIO;

    aboutToAppear(): void {
        let numberHeight = px2vp(fp2px(Constants.TEXT_SIZE_BODY2));
        let nameHeight = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE1));
        this.icHeight = this.gridHeight - Constants.ALBUM_SET_NEW_ICON_MARGIN;
        -numberHeight - nameHeight;
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_gallery_public_delete_line'))
                    .width($r('app.float.recycle_album_cover_icon_size'))
                    .height($r('app.float.recycle_album_cover_icon_size'))
                    .fillColor($r('app.color.empty_or_recycle_album_icon'))
                    .onError((msg: {
                        componentWidth: number,
                        componentHeight: number
                    }) => {
                        this.logger.error(`image load failed and its componentWidth is: ${msg.componentWidth}`);
                        this.logger.error(`image load failed and its componentHeight is: ${msg.componentHeight}`);
                    })
                    .onComplete((msg: {
                        width: number,
                        height: number,
                        componentWidth: number,
                        componentHeight: number
                    }) => {
                        this.logger.debug(`image load successfully and its width is: ${msg.width}`);
                        this.logger.debug(`image load successfully and its height is: ${msg.height}`);
                        this.logger.debug(`image load successfully and its componentWidth is: ${msg.componentWidth}`);
                        this.logger.debug(`image load successfully and its componentHeight is: ${msg.componentHeight}`);
                    })
            }
            .height(this.icHeight)
            .width('100%')
        }
        .aspectRatio(this.gridAspectRatio)
        .backgroundColor($r('app.color.empty_or_recycle_album_back'))
        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
    }
}