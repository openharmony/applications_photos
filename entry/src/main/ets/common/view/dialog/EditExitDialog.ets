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

import router from '@system.router';
import {ScreenManager} from '../../model/common/ScreenManager'
import {Constants} from '../../model/common/Constants.ets';

@Observed
export class EditExitDialogCallback {
    discardCallback: Function
}

@CustomDialog
export struct EditExitDialog {
    @Consume editExitDialogCallback: EditExitDialogCallback;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    controller: CustomDialogController;

    build() {
        Column() {
            Text($r('app.string.edit_exit_dialog_context_text')).fontSize($r('sys.float.ohos_id_text_size_body1'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .margin({bottom: $r('app.float.album_set_count_margin_left')})
            Flex({
                direction:FlexDirection.Row,
                justifyContent: FlexAlign.SpaceAround,
                alignItems: ItemAlign.Center,
            }) {
                Button() {
                    Text($r('app.string.save_dialog_cancel_text'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontWeight(FontWeight.Medium)
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                }
                .height($r('app.float.default_button_size'))
                .width($r('app.float.edit_exit_button'))
                .onClick(() => {
                    this.controller.close()
                }).backgroundColor($r('app.color.transparent'))

                Divider().vertical(true)
                    .height($r('app.float.actionbar_text_icon_margin'))
                    .color($r('sys.color.ohos_id_color_list_separator'))

                Button() {
                    Text($r('app.string.edit_exit_dialog_discard_text'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontWeight(FontWeight.Medium)
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                }
                .height($r('app.float.default_button_size'))
                .width($r('app.float.edit_exit_button'))
                .onClick(() => {
                    this.editExitDialogCallback && this.editExitDialogCallback.discardCallback()
                    this.controller.close()
                    router.back()
                }).backgroundColor($r('app.color.transparent'))
            }
            .width('100%')
        }
        .width(ScreenManager.getInstance().getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.dialog_content_margin'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
        .padding({bottom: $r('app.float.dialog_content_margin'), top:$r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')})
    }
}