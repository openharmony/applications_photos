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
import {DialogCallback} from '../../model/common/DialogUtil'
import { Logger } from '../../utils/Logger.ets'
import {ScreenManager} from '../../model/common/ScreenManager'
import {Constants} from '../../model/common/Constants.ets';

@CustomDialog
export struct DeleteDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @Consume dialogCallback: DialogCallback;
    @Consume dialogMessage: Resource;
    logger: Logger = new Logger('DeleteDialog');
    controller: CustomDialogController;

    aboutToAppear() {
    }

    build() {
        Column() {
            Stack({alignContent: Alignment.Center}) {
                Text(this.dialogMessage)
                    .fontSize($r('sys.float.ohos_id_text_size_body1'))
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }.width('100%')
                .margin({
                    top:$r('app.float.dialog_content_margin'),
                    bottom: $r('sys.float.ohos_id_text_paragraph_margin_s')
                })

            Stack({alignContent: Alignment.Top}) {
                Row() {
                    Button() {
                        Text($r('app.string.dialog_cancel'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('app.color.color_control_highlight'))
                            .fontWeight(FontWeight.Medium)
                            .width('50%')
                            .textAlign(TextAlign.Center)
                    }
                    .margin({
                        left: $r('app.float.details_dialog_button_margin_left'),
                        right: $r('app.float.details_dialog_button_margin_right')
                    })
                        .backgroundColor($r('app.color.transparent'))
                        .height($r('app.float.details_dialog_button_height'))
                        .onClick(() => {
                            this.logger.debug(`cancelCallback`);
                            this.controller.close();
                            this.dialogCallback && this.dialogCallback.cancelCallback();
                        })

                    Row() {
                        Divider()
                        .vertical(true)
                            .strokeWidth('2vp')
                            .height($r('app.float.dialog_divider_height'))
                            .color($r('sys.color.ohos_id_color_list_separator'))
                    }
                    .height($r('app.float.details_dialog_button_height'))
                        .alignItems(VerticalAlign.Center)
                    Button() {
                        Text($r('app.string.dialog_delete'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('sys.color.ohos_id_color_warning'))
                            .fontWeight(FontWeight.Medium)
                            .width('50%')
                            .textAlign(TextAlign.Center)
                    }
                    .margin({
                        left: $r('app.float.details_dialog_button_margin_left'),
                        right: $r('app.float.details_dialog_button_margin_right')
                    })
                        .backgroundColor($r('app.color.transparent'))
                        .height($r('app.float.details_dialog_button_height'))
                        .onClick(() => {
                            this.logger.debug(`confirmCallback`);
                            this.controller.close();
                            this.dialogCallback && this.dialogCallback.confirmCallback();
                        })
                }
            }
            .width('100%')
                .height($r('app.float.details_dialog_button_area_height'))
        }
        .borderRadius($r('app.float.dialog_border_radius'))
            .width(ScreenManager.getInstance().getColumnsWidth(4))
            .backgroundColor($r('app.color.white'))
            .margin({
                right: $r('app.float.dialog_content_margin'),
                left: $r('app.float.dialog_content_margin'),
                bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
            })
            .padding({left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')})
                .alignItems(HorizontalAlign.Start)
    }
}
