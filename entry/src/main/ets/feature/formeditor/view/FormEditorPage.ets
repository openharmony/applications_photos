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

import router from '@system.router'
import { Logger } from '../utils/Logger'
import { Constants } from '../../../FormAbility/common/Constants'
import { AlbumDefine } from '../../../common/model/browser/AlbumDefine'
import { BroadCast } from '../../../common/utils/BroadCast'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { UiUtil } from '../../../common/utils/UiUtil'
import { ScreenManager } from '../../../common/model/common/ScreenManager'
import { DataStoreUtil } from '../../../common/utils/DataStoreUtil'
import formBindingData from '@ohos.application.formBindingData'
import formProvider from '@ohos.application.formProvider'
import { MediaLibraryAccess } from '../../../common/access/MediaLibraryAccess'

@CustomDialog
struct SettingDialog {
    private broadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    @StorageLink('form_playback_interval') time: number = AppStorage.Get(Constants.FROM_PLAYBACK_INTERVAL);
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
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
        .width(ScreenManager.getInstance().getColumnsWidth(Constants.NUMBER_4))
        .alignItems(HorizontalAlign.Start)
        .borderRadius($r('app.float.dialog_border_radius'))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_content_margin'),
            left: $r('app.float.dialog_content_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
        })
    }
}

@Entry
@Component
struct FormEditorPage {
    logger: Logger = new Logger('FormEditorPage');
    @StorageLink('FASetting_FormId') formId: string = '0';
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    currentIndex: number = 0;
    isShow: boolean = false;
    arkUri: number = 0;
    fd: number = -1;
    fileAsset: any = null;
    displayName: string = '';
    @State time: number = 30;
    private saveDataFunc = this.saveData.bind(this);
    private onChangeFunc = this.onChange.bind(this);
    settingController: CustomDialogController = new CustomDialogController({
        builder: SettingDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    })

    async getItems(albumId: string, startIndex?: number, count?: number, deviceId?) {
        let fetchOpt = AlbumDefine.getFileFetchOpt(albumId, deviceId, startIndex, count);
        switch (albumId) {
            case AlbumDefine.ALBUM_ID_ALL:
                let allObject = await MediaLibraryAccess.getInstance().getAllObject(fetchOpt);
                return allObject;
                break;
            default:
                return await MediaLibraryAccess.getInstance().getEntityAlbumObject(AlbumDefine.getAlbumFetchOpt(
                    albumId, deviceId), fetchOpt);
                break;
        }
    }

    async GetMediaData(albumId: string, uri: string) {
        this.logger.debug(`GetMediaData start uri: ${uri}`)
        let dataList = await this.getItems(albumId);
        if (uri != '') {
            for (let i = 0; i < dataList.length; i++) {
                let temUri = dataList[i].uri;
                if (temUri == uri) {
                    this.currentIndex = i;
                    break;
                }
            }
        } else {
            this.currentIndex = 0;
        }
        this.fileAsset = dataList[this.currentIndex];
    }

    async openCurrentFd() {
        this.fd = (this.fileAsset != null) ? await  MediaLibraryAccess.getInstance()
            .openAsset('R', this.fileAsset) : -1;
    }

    bindFormData(): any {
        this.logger.debug(`bindFormData start formId: ${this.formId}`)
        let image = "image" + this.arkUri;
        let dataObj1: any;
        if (image == "image0") {
            dataObj1 = {
                "fd": this.fd == -1 ? false : true,
                "image1": "memory://image" + this.arkUri,
                "albumName": this.displayName,
                "currentIndex": this.currentIndex,
                "isShow": this.isShow,
                "formImages": { "image0": this.fd }
            };
        } else {
            dataObj1 = {
                "fd": this.fd == -1 ? false : true,
                "image1": "memory://image" + this.arkUri,
                "albumName": this.displayName,
                "currentIndex": this.currentIndex,
                "isShow": this.isShow,
                "formImages": { "image1": this.fd }
            };
        }
        this.logger.debug(`bindFormData, createFormBindingData dataObj2.data: ${JSON.stringify(dataObj1)}`);
        let obj = formBindingData.createFormBindingData(JSON.stringify(dataObj1));
        this.logger.debug(`bindFormData, createFormBindingData obj2.data: ${JSON.stringify(obj.data)}`);
        return obj;
    }

    updateRefreshTime() {
        this.logger.debug(`updateRefreshTime isShow ${this.isShow}`);
        if (!this.isShow) {
            return;
        }
        formProvider.setFormNextRefreshTime(this.formId, this.time).then(() => {
            this.logger.info(`setFormNextRefreshTime sucessfully`);
        }).catch((err) => {
            this.logger.error(`init err ${err}`);
        })
    }

    terminate() {
        globalThis.photosAbilityContext.terminateSelf((result) => {
            this.logger.info(`terminateSelf result: ${JSON.stringify(result)}`);
        })
    }

    updateFormData(): void {
        this.logger.debug(`updateFormData formId: ${JSON.stringify(this.formId)}`);
        let obj3 = this.bindFormData();
        this.logger.debug(`updateFormData obj: ${JSON.stringify(obj3)}`);
        formProvider.updateForm(this.formId, obj3)
            .then((data) => {
                this.logger.info(`updateFormData, data: ${JSON.stringify(data)}`);
                if (this.isShow) {
                    formProvider.setFormNextRefreshTime(this.formId, this.time).then(() => {
                        this.terminate();
                    }).catch((err) => {
                        this.logger.error(`init err ${err}`);
                        this.terminate();
                    })
                } else {
                    this.terminate();
                }
            }).catch((error) => {
            this.logger.error(`updateForm failed. Cause: ${JSON.stringify(error)}`);
            this.terminate();
        });
    }

    async saveData(albumName: string, albumId: string, displayName, uri: string, isShow: boolean) {
        this.logger.debug(`saveData start! ${albumName} ${displayName} ${uri}`)
        let msgDisplayName = '';
        if (displayName instanceof Object) {
            this.logger.debug(`saveData object ${displayName}`);
            msgDisplayName = await UiUtil.getResourceString(displayName);
        } else {
            msgDisplayName = displayName;
        }
        this.isShow = isShow;
        this.displayName = msgDisplayName;
        this.logger.debug(`saveData msgDisplayName ${msgDisplayName}`);
        await DataStoreUtil.getInstance(globalThis.photosAbilityContext).init();
        await this.GetMediaData(albumId, uri);
        await this.openCurrentFd();
        let formIdKey = 'formId_' + this.formId;
        let hasFormId = await DataStoreUtil.getInstance(globalThis.photosGlobalContext).hasData(formIdKey);
        this.logger.debug(`The value of hasFormId is ${hasFormId}`);
        if (hasFormId) {
            let displayNameKey = 'displayName_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(displayNameKey, msgDisplayName);
            let albumNameKey = 'albumName_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(albumNameKey, albumName);
            let albumIdKey = 'albumId_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(albumIdKey, albumId);
            let currentUriKey = 'currentUri_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(currentUriKey, uri);
            let intervalTimeKey = 'intervalTime_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(intervalTimeKey, this.time);
            let currentIndexKey = 'currentIndex_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(currentIndexKey, this.currentIndex);
            let isShowKey = 'isShow_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(isShowKey, this.isShow ? 1 : 0);
            let arkUriKey = 'arkUri_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).putData(arkUriKey, this.arkUri);
            await DataStoreUtil.getInstance(globalThis.photosGlobalContext).flush();
            this.updateFormData();
        } else {
            globalThis.photosAbilityContext.terminateSelf((result) => {
                this.logger.info(`terminateSelf result: ${JSON.stringify(result)}`);
            })
        }
        this.logger.debug('saveData end!');
    }

    routerPhotos(routerUri: string) {
        if (routerUri == Constants.SELECT_ALBUM) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: false,
                    isFromFa: true
                }
            };
            router.push(options);
        } else if (routerUri == Constants.SELECT_PHOTO) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: false,
                    isFromFa: true,
                    isFromFaPhoto: true
                }
            };
            router.push(options);
        }
    }

    selectAlbum() {
        this.routerPhotos(Constants.SELECT_ALBUM);
    }

    selectPhoto() {
        this.routerPhotos(Constants.SELECT_PHOTO);
    }

    setPlayInterval() {
        this.settingController.open();
    }

    aboutToAppear(): void {
        this.logger.debug('aboutToAppear start!')
        this.appBroadCast.on(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
        this.appBroadCast.on(Constants.FROM_PLAYBACK_INTERVAL, this.onChangeFunc);
        DataStoreUtil.getInstance(globalThis.photosAbilityContext).init().then(() => {
            let intervalTimeKey = 'intervalTime_' + this.formId;
            DataStoreUtil.getInstance(globalThis.photosAbilityContext).getData(intervalTimeKey, this.time).then((d) => {
                this.time = d;
                AppStorage.SetOrCreate(Constants.FROM_PLAYBACK_INTERVAL, this.time);
            })
            let isShowKey = 'isShow_' + this.formId;
            DataStoreUtil.getInstance(globalThis.photosAbilityContext).getData(isShowKey, this.isShow).then((d) => {
                this.isShow = d;
            })
            let arkUriKey = 'arkUri_' + this.formId;
            DataStoreUtil.getInstance(globalThis.photosAbilityContext).getData(arkUriKey, this.arkUri).then((d) => {
                if (d == 0) {
                    d = 1;
                } else {
                    d = 0;
                }
                this.arkUri = d;
            })
        })
    }

    aboutToDisappear() {
        this.appBroadCast.off(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
        this.appBroadCast.off(Constants.FROM_PLAYBACK_INTERVAL, this.onChangeFunc);
    }

    onChange(value) {
        this.time = value;
        AppStorage.SetOrCreate(Constants.FROM_PLAYBACK_INTERVAL, this.time);
        this.updateTime()
    }

    async updateTime() {
        this.logger.debug(`updateTime start! ${this.time}`)
        await DataStoreUtil.getInstance(globalThis.photosAbilityContext).init();
        let formIdKey = 'formId_' + this.formId;
        let hasFormId = DataStoreUtil.getInstance(globalThis.photosAbilityContext).hasData(formIdKey);
        this.logger.debug(`The value of hasFormId is ${hasFormId}`);
        if (hasFormId) {
            let intervalTimeKey = 'intervalTime_' + this.formId;
            await DataStoreUtil.getInstance(globalThis.photosAbilityContext).putData(intervalTimeKey, this.time);
            await DataStoreUtil.getInstance(globalThis.photosAbilityContext).flush();
            this.updateRefreshTime();
        }
        this.logger.debug('updateTime end!');
    }

    onPageShow() {
        BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    }

    build() {
        Column() {
            Row() {
                Image($r('app.media.ic_gallery_public_back'))
                    .fillColor($r('app.color.white'))
                    .width($r('app.float.FA_back_size'))
                    .height($r('app.float.FA_back_size'))
                    .margin({ left: $r('app.float.FA_back_margin_left'), top: $r('app.float.FA_back_margin_top') })
            }
            .width('100%')
            .onClick(() => {
                this.terminate();
            })

            Column() {
                Text($r('app.string.fa_title_text'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontColor($r('app.color.FA_title_text_color'))
                    .fontWeight(FontWeight.Medium)

                Text($r('app.string.fa_subTitle_text'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline8'))
                    .margin({ top: $r('app.float.FA_subTitle_margin_top') })
                    .fontColor($r('app.color.FA_subTitle_text_color'))
            }
            .margin({ top: $r('app.float.FA_title_margin_top'), bottom: $r('app.float.FA_title_margin_bottom') })

            GridContainer({
                columns: Constants.NUMBER_12,
                sizeType: SizeType.Auto,
                gutter: Constants.NUMBER_24,
                margin: Constants.NUMBER_24
            }) {
                Row() {
                    Row() {
                        Text($r('app.string.fa_select_image_text'))
                            .fontSize($r('sys.float.ohos_id_text_size_body1'))
                            .fontColor($r('app.color.black'))
                            .flexGrow(Constants.FLEX_GROW)
                            .fontWeight(FontWeight.Medium)
                        Row() {
                            Image($r('app.media.ic_gallery_form_arrow'))
                                .width($r('app.float.form_list_card_more_arrow_w'))
                                .height($r('app.float.form_list_card_more_arrow_h'))
                        }
                    }
                    .width('100%')
                    .padding({
                        left: $r('app.float.FA_ListCard_padding_left'),
                        top: $r('app.float.FA_ListCard_padding_top'),
                        right: $r('app.float.FA_ListCard_padding_left'),
                        bottom: $r('app.float.FA_ListCard_padding_top')
                    })
                    .backgroundColor($r('app.color.white'))
                    .borderRadius($r("app.float.FA_ListCard_radius"))
                    .onClick(() => {
                        this.selectPhoto();
                    })
                }
                .useSizeType({
                    xs: { span: Constants.NUMBER_12, offset: 0 },
                    sm: { span: Constants.NUMBER_12, offset: 0 },
                    md: { span: Constants.NUMBER_12, offset: 0 },
                    lg: { span: Constants.NUMBER_8, offset: Constants.NUMBER_2 }
                })

                Row() {
                    Row() {
                        Text($r('app.string.fa_select_album_text'))
                            .fontSize($r('sys.float.ohos_id_text_size_body1'))
                            .fontColor($r('app.color.black'))
                            .flexGrow(Constants.FLEX_GROW)
                            .fontWeight(FontWeight.Medium)
                        Row() {
                            Image($r('app.media.ic_gallery_form_arrow'))
                                .width($r('app.float.form_list_card_more_arrow_w'))
                                .height($r('app.float.form_list_card_more_arrow_h'))
                        }
                    }
                    .width('100%')
                    .padding({
                        left: $r('app.float.FA_ListCard_padding_left'),
                        top: $r('app.float.FA_ListCard_padding_top'),
                        right: $r('app.float.FA_ListCard_padding_left'),
                        bottom: $r('app.float.FA_ListCard_padding_top')
                    })
                    .backgroundColor($r('app.color.white'))
                    .borderRadius($r("app.float.FA_ListCard_radius"))
                    .onClick(() => {
                        this.selectAlbum();
                    })
                }
                .margin({ top: $r('app.float.FA_select_album_padding') })
                .useSizeType({
                    xs: { span: Constants.NUMBER_12, offset: 0 },
                    sm: { span: Constants.NUMBER_12, offset: 0 },
                    md: { span: Constants.NUMBER_12, offset: 0 },
                    lg: { span: Constants.NUMBER_8, offset: Constants.NUMBER_2 }
                })

                Row() {
                    Text($r('app.string.fa_setting_text'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                }
                .padding({
                    top: $r('app.float.FA_setting_padding_top'),
                    left: $r('app.float.FA_setting_padding_left'),
                    bottom: $r('app.float.FA_setting_padding_bottom')
                })
                .useSizeType({
                    xs: { span: Constants.NUMBER_12, offset: 0 },
                    sm: { span: Constants.NUMBER_12, offset: 0 },
                    md: { span: Constants.NUMBER_12, offset: 0 },
                    lg: { span: Constants.NUMBER_8, offset: Constants.NUMBER_2 }
                })

                Row() {
                    Row() {
                        Text($r('app.string.fa_image_show_interval'))
                            .fontSize($r('sys.float.ohos_id_text_size_body1'))
                            .fontColor($r('app.color.black'))
                            .flexGrow(Constants.FLEX_GROW)
                            .fontWeight(FontWeight.Medium)

                        Row() {
                            Text(undefined == this.time ? $r('app.string.fa_play_interval_time_30')
                                                        : (Constants.NUMBER_3 == this.time / Constants.DEFAULT_TIME) ? $r('app.string.fa_play_interval_time_90')
                                                                                                                     : (Constants.NUMBER_2 == this.time / Constants.DEFAULT_TIME) ? $r('app.string.fa_play_interval_time_60')
                                                                                                                                                                                  : $r('app.string.fa_play_interval_time_30'))
                                .fontSize($r('sys.float.ohos_id_text_size_body2'))
                                .fontColor(Color.Gray)
                                .margin({ right: $r('app.float.form_list_card_more_gap') })
                            Image($r('app.media.ic_gallery_form_arrow'))
                                .width($r('app.float.form_list_card_more_arrow_w'))
                                .height($r('app.float.form_list_card_more_arrow_h'))
                        }
                    }
                    .width('100%')
                    .padding({
                        left: $r('app.float.FA_ListCard_padding_left'),
                        top: $r('app.float.FA_ListCard_padding_top'),
                        right: $r('app.float.FA_ListCard_padding_left'),
                        bottom: $r('app.float.FA_ListCard_padding_top')
                    })
                    .backgroundColor($r('app.color.white'))
                    .borderRadius($r("app.float.FA_ListCard_radius"))
                    .onClick(() => {
                        this.setPlayInterval()
                    })
                }
                .useSizeType({
                    xs: { span: Constants.NUMBER_12, offset: 0 },
                    sm: { span: Constants.NUMBER_12, offset: 0 },
                    md: { span: Constants.NUMBER_12, offset: 0 },
                    lg: { span: Constants.NUMBER_8, offset: Constants.NUMBER_2 }
                })
            }
        }
        .backgroundColor($r('app.color.FA_background_color'))
        .width('100%')
        .height('100%')
    }
}