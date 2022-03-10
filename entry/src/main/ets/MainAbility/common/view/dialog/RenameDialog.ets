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
export struct RenameDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    controller: CustomDialogController;
    @Consume renameFileName: string;
    @Consume dialogCallback: DialogCallback;
    @State isNull: boolean = false;
    private inputName: string = '';
    private logger: Logger = new Logger('RenameDialog');

    private aboutToAppear(): void {
        this.logger.info('aboutToAppear');
        this.inputName = this.renameFileName;
        this.isNull = this.inputName === '';
        if (this.inputName.length === Constants.RENAME_MAX_LENGTH) {
            UiUtil.showToast($r('app.string.Maximum_length_reached'));
        }
    }

    build() {
        Column() {
            Row() {
                Text($r('app.string.rename'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }.alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_title_height'))

            Row() {
                Column() {
                    TextInput({placeholder:'', text: this.inputName})
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                        .maxLength(Constants.RENAME_MAX_LENGTH)
                        .enterKeyType(EnterKeyType.Done)

                    .onChange((value: string) => {
                        this.logger.info(`TextInput onChange : ${value}`)
                        this.inputName = value
                        if (value.length === Constants.RENAME_MAX_LENGTH) {
                            UiUtil.showToast($r('app.string.Maximum_length_reached'));
                        }
                        this.isNull = this.inputName === '';
                    })
                }
            }.margin({
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s')})
            Stack({alignContent: Alignment.Top}) {
                Row() {
                    Button() {
                        Text($r('app.string.no'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('app.color.color_control_highlight'))
                            .width('50%')
                            .textAlign(TextAlign.Center)
                    }
                    .margin({right: $r('app.float.details_dialog_button_margin_right')})
                    .backgroundColor($r('app.color.transparent'))
                    .height($r('app.float.details_dialog_button_height'))
                    .onClick(() => {
                        this.dialogCallback && this.dialogCallback.cancelCallback();
                        this.controller.close()
                    })
                    Row() {
                        Divider().vertical(true).strokeWidth('2vp').height($r('app.float.dialog_divider_height'))
                            .color($r('sys.color.ohos_id_color_list_separator'))
                    }.height($r('app.float.details_dialog_button_height'))
                    .alignItems(VerticalAlign.Center)
                    Button() {
                        Text($r('app.string.yes'))
                            .fontSize($r('sys.float.ohos_id_text_size_button1'))
                            .fontColor($r('app.color.color_control_highlight'))
                            .width('50%')
                            .textAlign(TextAlign.Center)
                    }
                    .enabled(!this.isNull)
                    .opacity(this.isNull ? $r('app.float.disable_button_opacity') : 1)
                    .margin({right: $r('app.float.details_dialog_button_margin_left')})
                    .backgroundColor($r('app.color.transparent'))
                    .height($r('app.float.details_dialog_button_height'))
                    .onClick(() => {
                        let check = /[\\.\\\\/:*?<>\"|\[\]{}\s]/;
                        let passCheck = check.test(this.inputName)
                        if (passCheck){
                            UiUtil.showToast($r('app.string.specific_characters_not_supported'));
                            this.controller.close()
                            return
                        }
                        if (this.inputName == this.renameFileName) {
                            this.controller.close()
                            return
                        }
                        this.dialogCallback && this.dialogCallback.confirmCallback(this.inputName);
                        this.controller.close()
                    })
                }
            }.width('100%')
            .height($r('app.float.details_dialog_button_area_height'))
        }.padding({left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')})
        .alignItems(HorizontalAlign.Start)
        .borderRadius($r('app.float.dialog_border_radius'))
        .width(ScreenManager.getInstance().getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
    }
}
