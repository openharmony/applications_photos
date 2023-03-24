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
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import type { DialogCallback } from '../../model/common/DialogUtil';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { Constants } from '../../model/common/Constants';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';

@CustomDialog
export struct NewAlbumDialog {
    private TAG: string = 'NewAlbumDialog'
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    controller: CustomDialogController;
    @Consume renameFileName: string;
    @Consume dialogCallback: DialogCallback;
    @State isNull: boolean = false;
    @State dividerColor: Resource = $r('app.color.dialog_divider_h_color_182431');
    @State dividerWidth: string = '1vp';
    private inputName: string = '';

    aboutToAppear(): void {
        Log.info(this.TAG, 'aboutToAppear');
        this.inputName = this.renameFileName;
        this.isNull = this.inputName === '';
        if (this.inputName.length === Constants.ALBUM_NAME_MAX_LENGTH) {
            getResourceString($r('app.string.Maximum_length_reached')).then((message: string) => {
                showToast(message)
            })
        }
    }

    build() {
        Column() {
            Row() {
                Text($r('app.string.album_new_album_title'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }.alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_title_height'))
            .margin({
                left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
            })

            Row() {
                Column() {
                    TextInput({ placeholder: '', text: this.inputName })
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('app.color.text_input_font_color_182431'))
                        .maxLength(Constants.ALBUM_NAME_MAX_LENGTH)
                        .enterKeyType(EnterKeyType.Done)
                        .backgroundColor($r('app.color.transparent'))
                        .onChange((value: string) => {
                            Log.info(this.TAG, `TextInput onChange : ${value}`)
                            this.inputName = value
                            if (value.length === Constants.ALBUM_NAME_MAX_LENGTH) {
                                getResourceString($r('app.string.Maximum_length_reached')).then((message: string) => {
                                    showToast(message)
                                })
                            }
                            this.isNull = this.inputName === '';
                        })
                        .margin({
                            left: $r('app.float.input_text_margin'), right: $r('app.float.input_text_margin')
                        })

                    Divider().vertical(false).strokeWidth(this.dividerWidth)
                        .color(this.dividerColor)
                        .margin({
                            left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
                        })
                }
            }.margin({
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            Stack({ alignContent: Alignment.Top }) {
                Row() {
                    Button() {
                        Text($r('app.string.dialog_cancel'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('app.color.color_control_highlight'))
                            .width('50%')
                            .fontWeight(FontWeight.Medium)
                            .textAlign(TextAlign.Center)
                    }
                    .margin({ right: $r('app.float.details_dialog_button_margin_right') })
                    .backgroundColor($r('app.color.transparent'))
                    .height($r('app.float.details_dialog_button_height'))
                    .onClick(() => {
                        this.dialogCallback && this.dialogCallback.cancelCallback();
                        this.controller.close()
                    })

                    Row() {
                        Divider()
                            .vertical(true)
                            .height($r('app.float.dialog_divider_height'))
                            .color($r('app.color.divider_vertical_color'))
                    }.height($r('app.float.details_dialog_button_height'))
                    .alignItems(VerticalAlign.Center)

                    Button() {
                        Text($r('app.string.yes'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('app.color.color_control_highlight'))
                            .width('50%')
                            .fontWeight(FontWeight.Medium)
                            .textAlign(TextAlign.Center)
                    }
                    .enabled(!this.isNull)
                    .opacity(this.isNull ? $r('app.float.disable_button_opacity') : 1)
                    .margin({ right: $r('app.float.details_dialog_button_margin_left') })
                    .backgroundColor($r('app.color.transparent'))
                    .height($r('app.float.details_dialog_button_height'))
                    .onClick(() => {
                        let check = /[\\.\\\\/:*?<>\"|\[\]{}\s]/;
                        let passCheck = check.test(this.inputName)
                        if (passCheck) {
                            getResourceString($r('app.string.specific_characters_not_supported')).then((message: string) => {
                                showToast(message)
                            })
                            return
                        }
                        this.dialogCallback && this.dialogCallback.confirmCallback(this.inputName);
                        this.controller.close()
                    })
                }
            }
            .height($r('app.float.details_dialog_button_area_height'))
            .margin({
                left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
            })
            .height($r('app.float.details_dialog_button_area_height'))
        }
        .alignItems(HorizontalAlign.Start)
        .borderRadius($r('app.float.dialog_border_radius'))
        .width(screenManager.getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_window_margin'),
            left: $r('app.float.dialog_window_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
        })
    }
}
