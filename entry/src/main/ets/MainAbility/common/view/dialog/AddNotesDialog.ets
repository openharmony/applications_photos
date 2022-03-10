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
import {Logger} from '../../utils/Logger'
import {DialogCallback} from '../../model/common/DialogUtil'
import {ScreenManager} from '../../model/common/ScreenManager.ets';
import {Constants} from '../../model/common/Constants.ets';
import {UiUtil} from '../../../common/utils/UiUtil.ets';

@CustomDialog
export struct AddNotesDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    controller: CustomDialogController;
    @Consume dialogCallback: DialogCallback;
    @State isNull: boolean = false;
    private inputNote: string = '';
    private logger: Logger = new Logger("AddNotesDialog");

    private aboutToAppear(): void {
        this.logger.info('aboutToAppear');
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
                }.margin({right: $r('app.float.dialog_icon_margin_horizontal')})

                Column() {
                    TextInput({placeholder:'', text: this.inputNote})
                        .fontSize($r('sys.float.ohos_id_text_size_caption1'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                        .maxLength(Constants.ADD_NOTES_MAX_LENGTH)
                        .enterKeyType(EnterKeyType.Done)
                        .onChange((value: string) => {
                            this.logger.info(`TextInput onChange : ${value}`)
                            this.inputNote = value
                            this.isNull = this.inputNote === '';
                        })
                }.margin({right: $r('app.float.dialog_icon_margin_horizontal')})

                Column() {
                    Button() {
                        Image($r('app.media.ic_gallery_public_ok'))
                    }.height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .onClick(() => {
                        let check = /[\\.\\\\/:*?<>\"|\[\]{}\s]/;
                        let passCheck = check.test(this.inputNote)
                        if (passCheck){
                            UiUtil.showToast($r('app.string.specific_characters_not_supported'));
                            this.controller.close()
                            return
                        }
                        this.dialogCallback && this.dialogCallback.confirmCallback(this.inputNote);
                        this.controller.close()
                    })
                }
            }.margin({top: $r('sys.float.ohos_id_text_paragraph_margin_s'),
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s')})
            .height($r('app.float.dialog_add_notes_content_height'))
        }.padding({left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')})
        .height('dialog_add_notes_height').width('100%').borderRadius($r('app.float.dialog_border_radius'))
        .width(ScreenManager.getInstance().getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
    }
}
