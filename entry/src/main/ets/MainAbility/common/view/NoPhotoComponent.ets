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

import {ScreenManager} from '../model/common/ScreenManager'
import {Constants} from '../model/common/Constants.ets'
import {Logger} from '../utils/Logger.ets'

@Component
export struct NoPhotoComponent {
    title: Resource;
    logger: Logger = new Logger('NoPhotoComponent');

    // set an initial value temporarily, later change to 0.
    @State offSetY: number = Constants.EMPTY_PAGE_DEFAULT_OFFSET;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();

    private aboutToAppear(): void {
        if (this.isHorizontal) {
            // Phone landscape
            this.offSetY = (ScreenManager.getInstance().getWinHeight() -
                Constants.ActionBarHeight) / Constants.NUMBER_2 - Constants.EMPTY_PAGE_MARGIN;
        } else {
            // Phone vertical screen
            this.offSetY = ScreenManager.getInstance().getWinHeight() * Constants.EMPTY_PAGE_OFFSET_RADIO -
                Constants.ActionBarHeight - Constants.EMPTY_PAGE_MARGIN;
        }

        this.logger.info(`isHorizontal: ${this.isHorizontal}, offSetY: ${this.offSetY}`);
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Start,
            alignItems: ItemAlign.Start
        }) {
            Column() {
                Image($rawfile('no_photos.png'))
                    .height($r('app.float.empty_page_picture_size'))
                    .width($r('app.float.empty_page_picture_size'))
                    .margin({
                        bottom: $r('sys.float.ohos_id_elements_margin_vertical_m'),
                    })
                Text(this.title)
                    .fontSize($r('sys.float.ohos_id_text_size_body2'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor($r('app.color.tertiary_title_text_color'))
            }
            .width('100%')
                .offset({ x: 0, y: this.offSetY })
                .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_start') })
        }
        .width('100%')
    }
}