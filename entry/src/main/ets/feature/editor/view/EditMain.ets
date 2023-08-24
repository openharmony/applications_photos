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
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { TitleBar } from './TitleBar';
import { MainMenuBar } from './MainMenuBar';
import { PhotoEditMode } from '../base/PhotoEditType';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { ToolBar } from './ToolBar';
import { CropImageShow } from './CropImageShow';
import { CustomDialogView } from '../../../common/view/dialog/CustomDialogView';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { PhotoEditorManager } from '../PhotoEditorManager';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { Constants } from '../../../common/model/common/Constants';

@Entry
@Component
struct Edit {
    private TAG: string = 'Edit'
    private mediaItem: MediaDataItem = globalThis.EditorMediaItem;
    @Provide editorManager: PhotoEditorManager = PhotoEditorManager.getInstance();
    @Provide('compare') isCompare: boolean = false;
    @Provide('angle') rotateAngle: number = 0;
    @Provide confirmToolBarText: Resource = undefined;
    @Provide isCropReset: boolean = false;
    @Provide isBigTextShow: boolean = false;
    @Provide bigText: string = '';
    @Provide('scale') imageScale: number = 0;
    @Provide('barSize') barScale: Resource = $r('app.float.menuBar_edit');
    @Provide('selected') selectedMode: number = PhotoEditMode.EDIT_MODE_CROP;
    @Provide broadCast: Broadcast = new Broadcast();
    @Provide('verticalScreen') isVerticalScreen: boolean = !screenManager.isHorizontal();
    @Provide screenWidth: number = 0;
    @Provide screenHeight: number = 0;
    @Provide cropEdit: PhotoEditCrop = undefined;
    @Provide isRedo: boolean = false;
    @Provide isUndo: boolean = false;
    @Provide isMagnifier: boolean = false;
    @Provide mainBottomSize: number = Constants.BOTTOM_TOOL_BAR_SIZE;
    @Provide titleSize: number = Constants.TOP_BAR_SIZE;
    @Provide filterBottomSize: number = Constants.FILTER_BOTTOM_TOOL_BAR_SIZE;
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @State imageScaleWidth: number = 0;
    appEventBus: Broadcast = broadcastManager.getBroadcast();
    private defaultWidth: number = Constants.DEFAULT_WIDTH;
    private isLoadFailed: boolean = false;

    onBackPress() {
        if (this.isCropReset) {
            this.broadCast.emit(BroadcastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else {
            AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 0);
            router.back();
        }
        return true;
    }

    discardCallback() {
        AppStorage.SetOrCreate(Constants.EDIT_REPLACE, 0);
        Log.debug(this.TAG, 'discardCallback called');
    }

    loadFailedCallback() {
        this.isLoadFailed = true;
    }

    aboutToAppear() {
        Log.debug(this.TAG, 'EditMain init start');
        if (this.mediaItem) {
            this.isLoadFailed = false;
            this.editorManager.initialize(
                this.mediaItem, PhotoEditMode.EDIT_MODE_CROP, this.loadFailedCallback.bind(this));
        }
        this.cropEdit = this.editorManager.getPhotoEditBaseInstance(PhotoEditMode.EDIT_MODE_CROP) as PhotoEditCrop;
        if (this.isVerticalScreen) {
            this.screenHeight = Math.ceil(screenManager.getWinHeight()) - px2vp(this.leftBlank[1] + this.leftBlank[3]);
            this.screenWidth = Math.ceil(screenManager.getWinWidth());
        } else {
            this.screenHeight = Math.ceil(screenManager.getWinHeight()) - px2vp(this.leftBlank[3]);
            this.screenWidth = Math.ceil(screenManager.getWinWidth());
        }

        if (this.screenHeight < this.screenWidth) {
            let temp = this.screenHeight;
            this.screenHeight = this.screenWidth;
            this.screenWidth = temp;
        }

        Log.debug(this.TAG, `EditMain this.isVerticalScreen: ${this.isVerticalScreen},\
            leftBlank: ${JSON.stringify(this.leftBlank)}, screenSize: ${this.screenHeight},${this.screenWidth}`);
        this.imageScale = this.isVerticalScreen
            ? (this.screenHeight - this.titleSize - this.mainBottomSize) : (this.screenWidth - this.titleSize);
        this.imageScaleWidth = this.isVerticalScreen ? this.screenWidth : (this.screenHeight - this.mainBottomSize);
        screenManager.setNavigationBarColor('#00FFFFFF', '#FFFFFFFF')
    }

    aboutToDisappear() {
        Log.debug(this.TAG, 'aboutToDisappear');
        globalThis.EditorMediaItem = undefined;
        PhotoEditorManager.getInstance().clear();
        screenManager.setNavigationBarColor('#FFF1F3F5', '#FF000000')
    }

    onPageShow() {
        this.appEventBus.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
        if (this.isLoadFailed) {
            router.back();
        }
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            Flex({
                direction: FlexDirection.Column,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center
            }) {
                Row() {
                    TitleBar({ name: $r('app.string.editBar_text') })
                }
                .height($r('app.float.title_default'))
                .width('100%')

                Flex({
                    direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row
                }) {
                    Column() {
                        if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                            ToolBar();
                        }
                    }
                    .visibility(this.isVerticalScreen ? Visibility.None : Visibility.Visible)
                    .height($r('app.float.actionButton_default'))

                    Flex({
                        direction: FlexDirection.Row,
                        alignItems: ItemAlign.Center,
                        justifyContent: FlexAlign.Center
                    }) {
                        Row() {
                            CropImageShow()
                        }
                        .visibility(this.selectedMode == PhotoEditMode.EDIT_MODE_CROP
                            ? Visibility.Visible : Visibility.None)
                    }
                    .height(this.imageScale)
                    .width(this.isVerticalScreen ? "100%" : this.imageScaleWidth)

                    Column() {
                        if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                            MainMenuBar()
                        }
                    }
                    .height(this.isVerticalScreen ? this.barScale : this.imageScale)
                    .width(this.isVerticalScreen ? "100%" : this.barScale)

                    Column() {
                        if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                            Row() {
                                ToolBar();
                            }
                            .visibility(this.isVerticalScreen ? Visibility.Visible : Visibility.None)
                        }
                    }
                    .height($r('app.float.actionButton_default'))
                }

                CustomDialogView()
            }
        }
        .padding({ bottom: px2vp(this.leftBlank[3]) })
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.black'))
    }
}
