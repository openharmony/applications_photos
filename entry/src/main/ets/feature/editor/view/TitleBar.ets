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

import { PhotoEditMode } from '../base/PhotoEditType';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { Constants } from '../../../common/model/common/Constants';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { PhotoEditorManager } from '../PhotoEditorManager';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import router from '@system.router'
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';

@Component
export struct TitleBar {
    @Consume isRedo: boolean;
    @Consume isUndo: boolean;
    @State name: Resource = undefined;
    @Consume('selected') selectedMode: number;
    @Consume broadCast: Broadcast;
    @Consume isVerticalScreen: boolean;
    @State isImmersive: boolean = false;
    @Consume editorManager: PhotoEditorManager;
    @Consume cropEdit: PhotoEditCrop;
    private TAG: string = 'Title'
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private newImageId: number = -1;
    private immersiveClick: Function = undefined;
    private onBackAfterSaveComplete: Function = undefined;

    saveAsNewCallback() {
        Log.debug(this.TAG, 'saveAsNewCallback called');
        PhotoEditorManager.getInstance().save(false).then((id: number) => {
            this.saveImageCallback(id)
        });
    }

    replaceOriginalCallback() {
        Log.debug(this.TAG, 'replaceOriginalCallback called');
        AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 1);
        PhotoEditorManager.getInstance().save(true).then((id: number) => {
            this.saveImageCallback(id)
        });
    }

    discardCallback() {
        AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 0);
        Log.debug(this.TAG, 'discardCallback called');
    }

    saveImageCallback(id: number) {
        Log.info(this.TAG,`saveImageCallback id = ${id}`);
        if (id < 0) {
            this.broadCast.emit(BroadcastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
            getResourceString($r('app.string.edit_photo_save_fail')).then((message: string) => {
                showToast(message)
            })
            router.back();
        } else {
            this.broadCast.emit(BroadcastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
        }
    }

    backAfterSaveComplete() {
        Log.debug(this.TAG, `backAfterSaveComplete called`);
        this.broadCast.emit(BroadcastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
        router.back();
    }

    aboutToAppear() {
        this.immersiveClick = this.immersive.bind(this);
        this.broadCast.on(Constants.IS_IMMERSIVE, this.immersiveClick);
        this.onBackAfterSaveComplete = this.backAfterSaveComplete.bind(this);
        this.appBroadcast.on(BroadcastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.IS_IMMERSIVE, this.immersiveClick);
        this.appBroadcast.off(BroadcastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
    }

    immersive(isImmersive: boolean) {
        this.isImmersive = isImmersive;
    }

    onBackClicked() {
        Log.debug(this.TAG, 'back clicked');
        if (this.isRedo || this.isUndo) {
            this.broadCast.emit(BroadcastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
            this.broadCast.emit(BroadcastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else {
            AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 0);
            router.back();
        }
    }

    onSaveClicked() {
        Log.debug(this.TAG, 'save clicked');
        if (this.isRedo || this.isRedo) {
            this.broadCast.emit(BroadcastConstants.SHOW_SAVE_PHOTO_DIALOG,
                [this.saveAsNewCallback.bind(this), this.replaceOriginalCallback.bind(this)]);
        } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
            this.broadCast.emit(BroadcastConstants.SHOW_SAVE_PHOTO_DIALOG,
                [this.saveAsNewCallback.bind(this), this.replaceOriginalCallback.bind(this)]);
        } else {
            AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 1);
            router.back();
        }
    }

    build() {
        Row() {
            Column() {
                if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                    Row() {
                        Flex({
                            direction: FlexDirection.Column,
                            justifyContent: FlexAlign.Center,
                            alignItems: ItemAlign.Center
                        }) {
                            Image($r('app.media.ic_gallery_public_back'))
                                .width($r('app.float.ic_size_default'))
                                .height($r('app.float.ic_size_default'))
                                .fillColor($r('app.color.default_white_color'))
                        }
                        .height($r('app.float.buttonWithoutText'))
                        .width($r('app.float.buttonWithoutText'))
                        .margin({
                            left: $r('app.float.bottom_bar_padding'),
                            right: $r('app.float.adjust_text_margin_left')
                        })
                        .onClick(() => {
                            this.onBackClicked()
                        })

                        Row() {
                            Text(this.name)
                                .fontSize(this.isVerticalScreen ? $r('app.float.title_text_default')
                                                                : $r('app.float.title_text_default_H'))
                                .fontColor($r('app.color.default_white_color'))
                                .fontWeight(FontWeight.Bold)
                                .margin({
                                    left: $r('app.float.adjust_text_margin_bottom'),
                                    right: $r('app.float.adjust_text_margin_left')
                                })
                        }
                    }
                }
            }
            .alignItems(HorizontalAlign.Start)
            .width('50%')

            Column() {
                Row() {
                    if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                        Flex({
                            direction: FlexDirection.Column,
                            justifyContent: FlexAlign.Center,
                            alignItems: ItemAlign.Center
                        }) {
                            Image($r('app.media.ic_gallery_public_save'))
                                .width($r('app.float.ic_size_default'))
                                .height($r('app.float.ic_size_default'))
                                .fillColor($r('app.color.default_white_color'))
                        }
                        .height($r('app.float.buttonWithoutText'))
                        .width($r('app.float.buttonWithoutText'))
                        .margin({ right: $r('app.float.bottom_bar_padding') })
                        .onClick(() => {
                            this.onSaveClicked()
                        })
                    }
                }
            }
            .alignItems(HorizontalAlign.End)
            .width('50%')
        }
        .visibility(this.isImmersive ? Visibility.None : Visibility.Visible)
    }
}