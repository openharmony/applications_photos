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

import {BroadCast} from '../../../common/utils/BroadCast.ets'
import {ScreenManager} from '../../model/common/ScreenManager'
import {BroadCastConstants} from '../../model/common/BroadCastConstants'
import {Constants} from '../../model/common/Constants.ets';

@Observed
export class SaveDialogCallback {
    saveAsNewCallback: Function
    replaceOriginalCallback: Function
}

@CustomDialog
export struct SaveDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @Consume broadCast: BroadCast;
    @Consume saveDialogCallback: SaveDialogCallback;
    controller: CustomDialogController;

    build() {
        Column() {
            Text($r('app.string.save_dialog_title_text')).fontSize($r('sys.float.ohos_id_text_size_headline7'))
                .fontColor($r('sys.color.ohos_id_color_text_primary')).fontWeight(FontWeight.Bold)
                .height($r('app.float.title_default'))
            Text($r('app.string.save_dialog_context_text')).fontSize($r('sys.float.ohos_id_text_size_body1'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .margin({bottom: $r('app.float.adjust_text_padding_bottom_isVertical')})
            Flex({
                direction:FlexDirection.Column,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center,
            }) {
                Button() {
                    Text($r('app.string.save_dialog_save_text'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                        .fontWeight(FontWeight.Medium)
                }
                .height($r('app.float.default_button_size'))
                .width($r('app.float.selection_actionbar_bg_height'))
                .onClick(() => {
                    this.controller.close()
                    this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
                    this.saveDialogCallback && this.saveDialogCallback.saveAsNewCallback()
                }).backgroundColor($r('app.color.transparent'))

                Button() {
                    Text($r('app.string.save_dialog_overwrite_text'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                        .fontWeight(FontWeight.Medium)
                }
                .height($r('app.float.default_button_size'))
                .width($r('app.float.selection_actionbar_bg_height'))
                .onClick(() => {
                    this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
                    this.controller.close()
                    this.saveDialogCallback && this.saveDialogCallback.replaceOriginalCallback()
                }).backgroundColor($r('app.color.transparent'))

                Button() {
                    Text($r('app.string.save_dialog_cancel_text'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                        .fontWeight(FontWeight.Medium)
                }
                .height($r('app.float.default_button_size'))
                .width($r('app.float.selection_actionbar_bg_height'))
                .onClick(() => {
                    this.controller.close()
                }).backgroundColor($r('app.color.transparent'))
            }
            .height($r('app.float.empty_page_picture_size'))
            .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .width(ScreenManager.getInstance().getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.dialog_content_margin'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
        .padding({left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin'),
            bottom : $r('sys.float.ohos_id_corner_radius_default_m')})
    }
}
