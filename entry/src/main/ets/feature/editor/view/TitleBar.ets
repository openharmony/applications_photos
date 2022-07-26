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

import {PhotoEditMode} from '../base/PhotoEditType'
import {BroadCast} from '../../../common/utils/BroadCast'
import {Constants} from '../../../common/model/common/Constants'
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../common/model/common/BroadCastManager'
import {PhotoEditorManager} from '../PhotoEditorManager'
import {PhotoEditCrop} from '../crop/PhotoEditCrop'
import {Logger} from '../utils/Logger'
import router from '@system.router'
import {UiUtil} from '../../../common/utils/UiUtil'

@Component
export struct TitleBar {
    @Consume isRedo: boolean;
    @Consume isUndo: boolean;
    @State name: Resource = undefined;
    @Consume('selected') selectedMode: number;
    @Consume broadCast: BroadCast;
    @Consume isVerticalScreen: boolean;
    @State isImmersive: boolean = false;
    @Consume editorManager: PhotoEditorManager;
    @Consume cropEdit: PhotoEditCrop;
    private log: Logger = new Logger('Title');
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private newImageId: number = -1;
    private immersiveClick: Function = undefined;
    private onBackAfterSaveComplete: Function = undefined;


    saveAsNewCallback() {
        this.log.debug('saveAsNewCallback called');
        PhotoEditorManager.getInstance().save(false, this.saveImageCallback.bind(this));
    }

    replaceOriginalCallback() {
        this.log.debug('replaceOriginalCallback called');
        PhotoEditorManager.getInstance().save(true, this.saveImageCallback.bind(this));
    }

    discardCallback() {
        this.log.debug('discardCallback called');
    }

    saveImageCallback(id: number) {
        this.log.debug(`saveImageCallback id = ${id}`);
        if (id < 0) {
            this.broadCast.emit(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
            UiUtil.showToast($r('app.string.edit_photo_save_fail'));
            router.back();
        } else {
            AppStorage.SetOrCreate(BroadCastConstants.PHOTO_EDIT_SAVE_ID, id);
            this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, Constants.PHOTO_TRANSITION_EDIT]);
        }
    }

    backAfterSaveComplete() {
        this.log.debug(`backAfterSaveComplete called`);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, Constants.PHOTO_TRANSITION_EDIT]);
        this.broadCast.emit(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
        AppStorage.SetOrCreate(BroadCastConstants.PHOTO_EDIT_SAVE_ID, -1);
        router.back();
    }

    aboutToAppear() {
        this.immersiveClick = this.immersive.bind(this);
        this.broadCast.on(Constants.IS_IMMERSIVE, this.immersiveClick);
        this.onBackAfterSaveComplete = this.backAfterSaveComplete.bind(this);
        this.appBroadCast.on(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.IS_IMMERSIVE, this.immersiveClick);
        this.appBroadCast.off(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
    }

    immersive(isImmersive : boolean) {
        this.isImmersive = isImmersive;
    }

    onBackClicked() {
        this.log.debug('back clicked');
        if (this.isRedo || this.isUndo) {
            this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
            this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else {
            router.back();
        }
    }

    onSaveClicked() {
        this.log.debug('save clicked');
        if (this.isRedo || this.isRedo) {
            this.broadCast.emit(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
                [this.saveAsNewCallback.bind(this), this.replaceOriginalCallback.bind(this)]);
        } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
            this.broadCast.emit(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
                [this.saveAsNewCallback.bind(this), this.replaceOriginalCallback.bind(this)]);
        } else {
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