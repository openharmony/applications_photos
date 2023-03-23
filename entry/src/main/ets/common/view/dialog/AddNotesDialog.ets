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
export struct AddNotesDialog {
    private TAG: string = 'AddNotesDialog'
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    controller: CustomDialogController;
    @Consume dialogCallback: DialogCallback;
    @State isNull: boolean = false;
    private inputNote: string = '';

    aboutToAppear(): void {
        Log.info(this.TAG, 'aboutToAppear');
        this.inputNote = '';
        this.isNull = this.inputNote === '';
    }

    build() {
        Column() {
            Row() {
                Column() {
                    Button() {
                        Image($r('app.media.ic_gallery_public_cancel'))
                    }.height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .onClick(() => {
                        this.dialogCallback && this.dialogCallback.cancelCallback();
                        this.controller.close()
                    })
                }.margin({ right: $r('app.float.dialog_icon_margin_horizontal') })

                Column() {
                    TextInput({ placeholder: '', text: this.inputNote })
                        .fontSize($r('sys.float.ohos_id_text_size_caption1'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('app.color.text_input_font_color_182431'))
                        .maxLength(Constants.ADD_NOTES_MAX_LENGTH)
                        .enterKeyType(EnterKeyType.Done)
                        .onChange((value: string) => {
                            Log.info(this.TAG, `TextInput onChange : ${value}`)
                            this.inputNote = value
                            this.isNull = this.inputNote === '';
                        })
                }.margin({ right: $r('app.float.dialog_icon_margin_horizontal') })

                Column() {
                    Button() {
                        Image($r('app.media.ic_gallery_public_ok'))
                    }.height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .onClick(() => {
                        let check = /[\\.\\\\/:*?<>\"|\[\]{}\s]/;
                        let passCheck = check.test(this.inputNote)
                        if (passCheck) {
                            getResourceString($r('app.string.specific_characters_not_supported'))
                                .then((message: string) => {
                                    showToast(message)
                                })
                            this.controller.close()
                            return
                        }
                        this.dialogCallback && this.dialogCallback.confirmCallback(this.inputNote);
                        this.controller.close()
                    })
                }
            }.margin({ top: $r('sys.float.ohos_id_text_paragraph_margin_s'),
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })
            .height($r('app.float.dialog_add_notes_content_height'))
        }
        .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
        .height($r('app.float.dialog_add_notes_height'))
        .width('100%')
        .borderRadius($r('app.float.dialog_border_radius'))
        .width(screenManager.getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
        })
    }
}
