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

import {BroadCast} from '../../utils/BroadCast.ets';
import {Logger} from '../../utils/Logger.ets';
import {ScreenManager} from '../../model/common/ScreenManager.ets';
import {Constants} from '../../model/common/Constants.ets';

@Observed
export class CancelParam {
    continueFunc: Function
    cancelFunc: Function
}

@CustomDialog
export struct DownloadCancelOperationDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    controller: CustomDialogController;
    @Consume broadCast: BroadCast;
    @Consume deleteProgress: number;
    @Consume cancelParam: CancelParam;
    logger: Logger = new Logger('CancelOperationDialog');

    build() {
        Column() {
            Row() {
                Text($r('app.string.download_cancel_message'))
                    .fontSize($r('sys.float.ohos_id_text_size_body1'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
                    .padding({
                        bottom: 8
                    })
                    .width('100%')
                    .textAlign(TextAlign.Center)
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')

            Flex({
                justifyContent: FlexAlign.SpaceAround,
                alignItems: ItemAlign.Center
            }) {
                Button() {
                    Text($r('app.string.download_progress_continue'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontWeight(FontWeight.Medium)
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                }
                .onClick(() => {
                    this.logger.info('click continue')
                    this.cancelParam.continueFunc();
                    this.controller.close()
                }).backgroundColor($r('app.color.transparent'))

                Divider().vertical(true)
                    .height($r('sys.float.ohos_id_text_size_body1'))
                    .color($r('sys.color.ohos_id_color_list_separator'))

                Button() {
                    Text($r('app.string.download_progress_cancel'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .fontWeight(FontWeight.Medium)
                }
                .onClick(() => {
                    this.logger.info('click cancel')
                    this.cancelParam.cancelFunc();
                    this.controller.close()
                }).backgroundColor($r('app.color.transparent'))
            }
        }
        .padding({
            left: $r('app.float.max_padding_start'),
            right: $r('app.float.max_padding_end'),
            top: $r('app.float.max_padding_start'),
        })
        .alignItems(HorizontalAlign.Center)
        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
        .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
        .borderRadius($r('app.float.dialog_border_radius'))
        .width(ScreenManager.getInstance().getColumnsWidth(4))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
    }
}
