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

import {Logger} from '../../utils/Logger.ets'
import {DateUtil} from '../../../common/utils/DateUtil.ets'
import {MediaLibraryAccess} from '../../access/MediaLibraryAccess.ets';
import {ScreenManager} from '../../model/common/ScreenManager'
import {Constants} from '../../model/common/Constants.ets';

@Observed
export class MediaDetails {
    mediaType: number
    height: number
    width: number
    size: number
    path: string
    duration: number
    title: string
    dateTaken: number
    uri: string
    displayName: string
    dateModified: number
}

@CustomDialog
export struct DetailsDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];

    static readonly INTERNAL_PREFIX_NUM = 3;
    static readonly EXTERNAL_PREFIX_NUM = 2;
    sizeConvert = 1024;
    controller: CustomDialogController;
    dataTime: string;

    @Consume mediaDetails: MediaDetails;
    @Consume isDistributedAlbum: boolean;
    logger: Logger = new Logger('DetailsView');

    aboutToAppear() {
        let localizedDate = DateUtil.getLocalizedDate(this.mediaDetails.dateTaken);
        let localizedTime = DateUtil.getLocalizedTime(this.mediaDetails.dateTaken);
        this.dataTime = `${localizedDate} ${localizedTime}`;
    }

    getResolution(height: number, width: number): string {
        return `${width}x${height}`;
    }

    getTitle() {
        this.logger.info('getTitle');
        if (this.mediaDetails.title) {
            return this.mediaDetails.title;
        }
        let index = this.mediaDetails.displayName.lastIndexOf('.');
        return this.mediaDetails.displayName.substr(0, index);
    }

    getDisplayPath(): string {
        let showPath = `${this.mediaDetails.path}${this.mediaDetails.displayName}`;
        return showPath;
    }

    getSize(size: number): string {
        if (size / (this.sizeConvert * this.sizeConvert) > 1) {
            return `${(size / (this.sizeConvert * this.sizeConvert)).toFixed(2)}MB`;
        } else {
            return `${(size / this.sizeConvert).toFixed(2)}KB`;
        }
    }

    build() {
        Column() {
            Row() {
                Text($r('app.string.details'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }.alignItems(VerticalAlign.Center)
                .height($r('app.float.dialog_title_height'))

            Row() {
                Column() {
                    Text($r('app.string.title'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }

                Column() {
                    Text(this.getTitle())
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                        .maxLines(Constants.DETAILS_DIALOG_NAME_MAX_LINE)
                        .padding({ right: $r('app.float.dialog_content_margin') })
                }
            }.alignItems(VerticalAlign.Top)
                .margin({ bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            Row() {
                Column() {
                    Text($r('app.string.time'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }

                Column() {
                    Text(this.dataTime)
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
            }.margin({
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            Row() {
                Column() {
                    Text($r('app.string.size'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }

                Column() {
                    Text(`${this.getSize(this.mediaDetails.size)}`)
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
            }.margin({
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            Row() {
                Column() {
                    Text($r('app.string.resolution'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }

                Column() {
                    Text(this.getResolution(this.mediaDetails.height, this.mediaDetails.width))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
            }.margin({
                bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

            if (this.mediaDetails.mediaType == MediaLibraryAccess.MEDIA_TYPE_VIDEO && this.mediaDetails.duration > 0) {
                Row() {
                    Column() {
                        Text($r('app.string.duration'))
                            .fontSize($r('sys.float.ohos_id_text_size_body2'))
                            .fontFamily($r('app.string.id_text_font_family_regular'))
                            .fontColor($r('sys.color.ohos_id_color_text_primary'))
                    }

                    Column() {
                        Text(DateUtil.getFormattedDuration(this.mediaDetails.duration))
                            .fontSize($r('sys.float.ohos_id_text_size_body2'))
                            .fontFamily($r('app.string.id_text_font_family_regular'))
                            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                }.margin({
                    bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })
            }
            if (!this.isDistributedAlbum) {
                Row() {
                    Column() {
                        Text($r('app.string.path'))
                            .fontSize($r('sys.float.ohos_id_text_size_body2'))
                            .fontFamily($r('app.string.id_text_font_family_regular'))
                            .fontColor($r('sys.color.ohos_id_color_text_primary'))
                    }

                Column() {
                    Text(this.getDisplayPath())
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                        .maxLines(Constants.DETAILS_DIALOG_PATH_MAX_LINE)
                        .padding({ right: $r('app.float.dialog_content_margin') })
                    }
                }.alignItems(VerticalAlign.Top)
                .margin({
                  bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })
            }

            Stack({ alignContent: Alignment.Top }) {
                Button() {
                    Text($r('app.string.detail_dialog_confirm'))
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .width('100%')
                        .textAlign(TextAlign.Center)
                        .fontWeight(FontWeight.Medium)
                }
                .backgroundColor($r('app.color.transparent'))
                    .height($r('app.float.details_dialog_button_height'))
                    .onClick(() => {
                        this.controller.close()
                    })
            }.width('100%')
                .height($r('app.float.details_dialog_button_area_height'))
        }.borderRadius($r('app.float.dialog_border_radius'))
        .width(ScreenManager.getInstance().getColumnsWidth(4))
            .backgroundColor($r('app.color.white'))
            .margin({
                right: $r('app.float.dialog_content_margin'),
                left: $r('app.float.dialog_content_margin'),
                bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
            })
            .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
                .alignItems(HorizontalAlign.Start)
    }
}
