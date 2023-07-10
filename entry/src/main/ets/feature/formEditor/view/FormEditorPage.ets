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
import formBindingData from '@ohos.application.formBindingData';
import formProvider from '@ohos.application.formProvider';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Constants } from '@ohos/formEditor/src/main/ets/constants/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import dataStore from '@ohos/base/src/main/ets/utils/DataStoreUtil';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import { terminateSelf } from '@ohos/base/src/main/ets/utils/AbilityUtils';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { getFetchOptions } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { SettingDialog } from '@ohos/formEditor/src/main/ets/components/SettingDialog';

const TAG = "FormEditorPage"

@Entry
@Component
struct FormEditorPage {
    @StorageLink('FASetting_FormId') formId: string = '0';
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    currentIndex: number = 0;
    isShow: boolean = false;
    arkUri: number = 0;
    fd: number = -1;
    fileAsset: MediaLib.FileAsset = null;
    displayName: string = '';
    albumId: string = '';
    @State time: number = 30;
    @State intervalTime: Resource = $r('app.string.fa_play_interval_time_30');
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

    async GetMediaData(albumId: string, index: number) {
        Log.debug(TAG, `GetMediaData start`);
        this.currentIndex = index;
        let fetchOpt = await getFetchOptions(MediaConstants.SELECT_TYPE_IMAGE, albumId, "");
        fetchOpt.order = `date_added DESC LIMIT ${index},1`;
        this.fileAsset = (await mediaModel.getAllMediaItem(albumId, fetchOpt, false)).fileAsset;
    }

    async openCurrentFd() {
        Log.info(TAG, `open fd, fileAsset is valid ${this.fileAsset != null}`);
        this.fd = (this.fileAsset != null) ? await  mediaModel.openAsset('R', this.fileAsset) : -1;
    }

    bindFormData(): any {
        Log.debug(TAG, `bindFormData start formId: ${this.formId}`);
        let image = "image_" + this.fd + "_formId_" + this.formId + "_arkUri_" + this.arkUri + "_currentUri_" + this.fileAsset.uri;
        Log.debug(TAG, `bindFormData start image: ${image}`);
        let dataObj1: any = {
            "fd": this.fd == -1 ? false : true,
            "image1": "memory://" + image,
            "albumName": this.displayName,
            "currentIndex": this.currentIndex,
            "isShow": this.isShow,
            "formImages": JSON.parse(`{ "${image}": ${this.fd} }`),
            'uri': (this.fileAsset.uri !== '') ? Constants.ACTION_URI_FORM_ABILITY : Constants.ACTION_URI_FORM_ABILITY_NONE,
            'albumId': this.albumId,
            'currentUri': this.fileAsset.uri
        };
        let dataObj = JSON.stringify(dataObj1);
        Log.info(TAG, `bindFormData, createFormBindingData dataObj2.data: ${dataObj}`);
        let obj = formBindingData.createFormBindingData(dataObj);
        Log.debug(TAG, `bindFormData, createFormBindingData obj2.data: ${JSON.stringify(obj.data)}`);
        return obj;
    }

    updateRefreshTime() {
        Log.debug(TAG, `updateRefreshTime isShow ${this.isShow}`);
        if (!this.isShow) {
            return;
        }
        formProvider.setFormNextRefreshTime(this.formId, this.time).then(() => {
            Log.info(TAG, `setFormNextRefreshTime sucessfully`);
        }).catch((err) => {
            Log.error(TAG, `init err ${err}`);
        })
    }

    terminate() {
        terminateSelf();
    }

    updateFormData(): void {
        Log.debug(TAG, `updateFormData formId: ${JSON.stringify(this.formId)}`);
        let obj3 = this.bindFormData();
        Log.debug(TAG, `updateFormData obj: ${JSON.stringify(obj3)}`);
        formProvider.updateForm(this.formId, obj3).then((data) => {
            Log.info(TAG, `updateFormData, data: ${JSON.stringify(data)}`);
            if (this.isShow) {
                formProvider.setFormNextRefreshTime(this.formId, this.time).then(() => {
                    this.terminate();
                }).catch((err) => {
                    Log.error(TAG, `init err ${err}`);
                    this.terminate();
                })
            } else {
                this.terminate();
            }
        }).catch((error) => {
            Log.error(TAG, `updateForm failed. Cause: ${JSON.stringify(error)}`);
            this.terminate();
        });
    }

    async saveData(albumName: string, albumId: string, displayName, index: number, isShow: boolean) {
        Log.debug(TAG, `saveData start! ${albumName} ${displayName} ${index}`);
        let msgDisplayName = '';
        if (displayName instanceof Object) {
            Log.debug(TAG, `saveData object ${displayName}`);
            msgDisplayName = await getResourceString(displayName);
        } else {
            msgDisplayName = displayName;
        }
        this.isShow = isShow;
        this.albumId = albumId;
        this.displayName = msgDisplayName;
        Log.debug(TAG, `saveData msgDisplayName ${msgDisplayName}`);
        await dataStore.init();
        await this.GetMediaData(albumId, index);
        await this.openCurrentFd();
        let formIdKey = 'formId_' + this.formId;
        let hasFormId = await dataStore.hasData(formIdKey);
        Log.debug(TAG, `The value of hasFormId is ${hasFormId}`);
        if (hasFormId) {
            let displayNameKey = 'displayName_' + this.formId;
            await dataStore.putData(displayNameKey, msgDisplayName);
            let albumNameKey = 'albumName_' + this.formId;
            await dataStore.putData(albumNameKey, albumName);
            let albumIdKey = 'albumId_' + this.formId;
            await dataStore.putData(albumIdKey, this.albumId);
            let currentUriKey = 'currentUri_' + this.formId;
            await dataStore.putData(currentUriKey, this.fileAsset.uri);
            let intervalTimeKey = 'intervalTime_' + this.formId;
            await dataStore.putData(intervalTimeKey, this.time);
            let currentIndexKey = 'currentIndex_' + this.formId;
            await dataStore.putData(currentIndexKey, this.currentIndex);
            let isShowKey = 'isShow_' + this.formId;
            await dataStore.putData(isShowKey, this.isShow ? 1 : 0);
            let arkUriKey = 'arkUri_' + this.formId;
            await dataStore.putData(arkUriKey, this.arkUri);
            await dataStore.flush();
            this.updateFormData();
        } else {
            terminateSelf();
        }
        Log.debug(TAG, 'saveData end!');
    }

    routerPhotos(isSelectPhoto: boolean) {
        let options = {
            uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
            params: {
                isMultiPick: false,
                isFromFa: true,
                isFromFaPhoto: isSelectPhoto
            }
        };
        router.push(options);
    }

    selectAlbum() {
        this.routerPhotos(false);
    }

    selectPhoto() {
        this.routerPhotos(true);
    }

    setPlayInterval() {
        this.settingController.open();
    }

    aboutToAppear(): void {
        Log.debug(TAG, 'aboutToAppear start!');
        this.appBroadcast.on(BroadcastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
        this.appBroadcast.on(Constants.FROM_PLAYBACK_INTERVAL, this.onChangeFunc);
        dataStore.init().then(() => {
            let intervalTimeKey = 'intervalTime';
            dataStore.getData(intervalTimeKey, this.time).then((d) => {
                this.time = d;
                this.setIntervalTime();
                AppStorage.SetOrCreate(Constants.FROM_PLAYBACK_INTERVAL, this.time);
            })
            let isShowKey = 'isShow_' + this.formId;
            dataStore.getData(isShowKey, this.isShow).then((d) => {
                this.isShow = d;
            })
            let arkUriKey = 'arkUri_' + this.formId;
            dataStore.getData(arkUriKey, this.arkUri).then((d) => {
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
        this.appBroadcast.off(BroadcastConstants.SAVE_FORM_EDITOR_DATA, null);
        this.appBroadcast.off(Constants.FROM_PLAYBACK_INTERVAL, null);
    }

    onChange(value) {
        this.time = value;
        this.setIntervalTime();
        AppStorage.SetOrCreate(Constants.FROM_PLAYBACK_INTERVAL, this.time);
        this.updateTime();
    }

    async updateTime() {
        Log.debug(TAG, `updateTime start! ${this.time}`);
        await dataStore.init();
        let intervalTimeKey = 'intervalTime';
        await dataStore.putData(intervalTimeKey, this.time);
        await dataStore.flush();
        this.updateRefreshTime();
        Log.debug(TAG, 'updateTime end!');
    }

    onPageShow() {
        broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    }

    private setIntervalTime(): void{
        if (this.time == undefined) {
            this.intervalTime = $r('app.string.fa_play_interval_time_30');
        } else if (this.time / Constants.DEFAULT_TIME == 3) {
            this.intervalTime = $r('app.string.fa_play_interval_time_90');
        } else if (this.time / Constants.DEFAULT_TIME == 2) {
            this.intervalTime = $r('app.string.fa_play_interval_time_60');
        } else {
            this.intervalTime = $r('app.string.fa_play_interval_time_30');
        }
    }

    build() {
        Column() {
            Row() {
                Image($r('app.media.ic_gallery_public_cancel'))
                    .fillColor($r('app.color.white'))
                    .width($r('app.float.FA_back_size'))
                    .height($r('app.float.FA_back_size'))
                    .margin({ left: $r('app.float.FA_back_margin_left') })
            }
            .height($r('app.float.title_default'))
            .alignItems(VerticalAlign.Center)
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
                columns: 12,
                sizeType: SizeType.Auto,
                gutter: 24,
                margin: 24
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
                                .fillColor($r('sys.color.ohos_id_color_fourth'))
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
                    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
                    .onClick(() => {
                        this.selectPhoto();
                    })
                }
                .useSizeType({
                    xs: { span: 12, offset: 0 },
                    sm: { span: 12, offset: 0 },
                    md: { span: 12, offset: 0 },
                    lg: { span: 8, offset: 2 }
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
                                .fillColor($r('sys.color.ohos_id_color_fourth'))
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
                    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
                    .onClick(() => {
                        this.selectAlbum();
                    })
                }
                .margin({ top: $r('app.float.FA_select_album_padding') })
                .useSizeType({
                    xs: { span: 12, offset: 0 },
                    sm: { span: 12, offset: 0 },
                    md: { span: 12, offset: 0 },
                    lg: { span: 8, offset: 2 }
                })

                Row() {
                    Text($r('app.string.fa_setting_text'))
                        .fontSize($r('sys.float.ohos_id_text_size_body2'))
                        .fontColor($r('app.color.FA_subTitle_text_color'))
                }
                .padding({
                    top: $r('app.float.FA_setting_padding_top'),
                    left: $r('app.float.FA_setting_padding_left'),
                    bottom: $r('app.float.FA_setting_padding_bottom')
                })
                .useSizeType({
                    xs: { span: 12, offset: 0 },
                    sm: { span: 12, offset: 0 },
                    md: { span: 12, offset: 0 },
                    lg: { span: 8, offset: 2 }
                })

                Row() {
                    Row() {
                        Text($r('app.string.fa_image_show_interval'))
                            .fontSize($r('sys.float.ohos_id_text_size_body1'))
                            .fontColor($r('app.color.black'))
                            .flexGrow(Constants.FLEX_GROW)
                            .fontWeight(FontWeight.Medium)

                        Row() {
                            Text(this.intervalTime)
                                .fontSize($r('sys.float.ohos_id_text_size_body2'))
                                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                                .margin({ right: $r('app.float.form_list_card_more_gap') })
                            Image($r('app.media.ic_gallery_form_arrow'))
                                .width($r('app.float.form_list_card_more_arrow_w'))
                                .height($r('app.float.form_list_card_more_arrow_h'))
                                .fillColor($r('sys.color.ohos_id_color_fourth'))
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
                    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
                    .onClick(() => {
                        this.setPlayInterval()
                    })
                }
                .useSizeType({
                    xs: { span: 12, offset: 0 },
                    sm: { span: 12, offset: 0 },
                    md: { span: 12, offset: 0 },
                    lg: { span: 8, offset: 2 }
                })
            }
        }
        .backgroundColor($r('app.color.FA_background_color'))
        .width('100%')
        .height('100%')
    }
}