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

import { Constants } from '../constants//Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';

@CustomDialog
export struct SettingDialog {
    private broadCast: Broadcast = broadcastManager.getBroadcast();
    @StorageLink('form_playback_interval') time: number = AppStorage.Get(Constants.FROM_PLAYBACK_INTERVAL);
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    controller: CustomDialogController;
    private settings = [
        { title: $r('app.string.fa_play_interval_time_30'), value: '30', checked: false },
        { title: $r('app.string.fa_play_interval_time_60'), value: '60', checked: false },
        { title: $r('app.string.fa_play_interval_time_90'), value: '90', checked: false }
    ];

    aboutToAppear() {
        this.settings.forEach((item) => {
            if (this.time == parseInt(item.value)) {
                item.checked = true;
            } else {
                item.checked = false;
            }
        })
    }

    build() {
        Column() {
            Row() {
                Text($r('app.string.fa_select_time'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
                    .fontWeight(FontWeight.Medium)
            }.alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_title_height'))

            List() {
                ForEach(this.settings, (item, index) => {
                    ListItem() {
                        Column() {
                            Row() {
                                Text(item.title)
                                    .fontSize($r('sys.float.ohos_id_text_size_button1'))
                                    .fontColor($r('app.color.black'))
                                    .width('50%')
                                Flex({
                                    direction: FlexDirection.Row,
                                    justifyContent: FlexAlign.End,
                                    alignItems: ItemAlign.Start
                                }) {
                                    Radio({ group: 'timeGroup', value: item.value })
                                        .checked(item.checked)
                                        .onChange((checked: boolean) => {
                                            item.checked = checked;
                                            if (checked) {
                                                this.broadCast.emit(Constants.FROM_PLAYBACK_INTERVAL, [parseInt(item.value)]);
                                                this.controller.close();
                                            }
                                        })
                                }
                                .width('50%')
                            }
                            .width('100%')

                            if (index != this.settings.length - 1) {
                                Divider().width('100%').color($r('sys.color.ohos_id_color_list_separator'))
                            }
                        }.width('100%')
                    }
                })
            }
            .margin({ bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            Button() {
                Text($r('app.string.no'))
                    .fontSize($r('sys.float.ohos_id_text_size_button1'))
                    .fontColor($r('app.color.color_control_highlight'))
                    .fontWeight(FontWeight.Medium)
                    .textAlign(TextAlign.Center)
            }
            .backgroundColor($r('app.color.transparent'))
            .height($r('app.float.details_dialog_button_height'))
            .width('100%')
            .margin({ bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })
            .onClick(() => {
                this.controller.close();
            })
        }
        .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
        .width(screenManager.getColumnsWidth(4))
        .alignItems(HorizontalAlign.Start)
        .borderRadius($r('app.float.dialog_border_radius'))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
        })
    }
}