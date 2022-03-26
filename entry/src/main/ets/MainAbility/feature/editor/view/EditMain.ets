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
import {Logger} from '../utils/Logger'
import {TitleBar} from './TitleBar'
import {MainMenuBar} from './MainMenuBar'
import {PhotoEditMode} from '../base/PhotoEditType'
import {BroadCast} from '../../../common/utils/BroadCast'
import {ScreenManager} from '../../../common/model/common/ScreenManager'
import {ToolBar} from './ToolBar'
import {CropImageShow} from './CropImageShow'
import {CustomDialogView} from '../../../common/view/dialog/CustomDialogView'
import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {BroadCastManager} from '../../../common/model/common/BroadCastManager'
import {PhotoEditorManager} from '../PhotoEditorManager'
import {PhotoEditCrop} from '../crop/PhotoEditCrop'
import {MediaItem} from '../../../common/model/browser/photo/MediaItem'
import {Constants} from '../../../common/model/common/Constants'
import image from '@ohos.multimedia.image'

@Entry
@Component
export struct Edit {
    private mediaItem: MediaItem = globalThis.EditorMediaItem;
    private screenManager = ScreenManager.getInstance();
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
    @Provide broadCast: BroadCast = new BroadCast();
    @Provide('verticalScreen') isVerticalScreen: boolean = !ScreenManager.getInstance().isHorizontal();
    @Provide screenWidth: number = 0;
    @Provide screenHeight: number = 0;
    @Provide cropEdit: PhotoEditCrop = undefined;
    @Provide isRedo: boolean = false;
    @Provide isUndo: boolean = false;
    @Provide isMagnifier: boolean = false;
    @Provide mainBottomSize: number = Constants.BOTTOM_TOOL_BAR_SIZE;
    @Provide titleSize: number = Constants.TOP_BAR_SIZE;
    @Provide filterBottomSize: number = Constants.FILTER_BOTTOM_TOOL_BAR_SIZE;
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @State imageScaleWidth: number = 0;
    appEventBus: BroadCast = BroadCastManager.getInstance().getBroadCast();
    private log: Logger = new Logger('EditMain');
    private defaultWidth: number = Constants.DEFAULT_WIDTH;

    private onBackPress() {
        if (this.isCropReset) {
            this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [this.discardCallback.bind(this)]);
        } else {
            router.back();
        }
    }

    discardCallback() {
        this.log.debug('discardCallback called');
    }

    aboutToAppear() {
        this.log.debug('EditMain init start');
        ScreenManager.getInstance().setSystemUi(false);
        if (this.mediaItem) {
            this.editorManager.initialize(this.mediaItem, PhotoEditMode.EDIT_MODE_CROP);
        }
        this.cropEdit = this.editorManager.getPhotoEditBaseInstance(PhotoEditMode.EDIT_MODE_CROP) as PhotoEditCrop;
        if (this.isVerticalScreen) {
            this.screenHeight = Math.ceil(this.screenManager.getWinHeight()) - (this.leftBlank[1] + this.leftBlank[3]);
            this.screenWidth = Math.ceil(this.screenManager.getWinWidth());
        } else {
            this.screenHeight = Math.ceil(this.screenManager.getWinHeight()) - (this.leftBlank[3]);
            this.screenWidth = Math.ceil(this.screenManager.getWinWidth());
        }

        if (this.screenHeight < this.screenWidth) {
            let temp = this.screenHeight;
            this.screenHeight = this.screenWidth;
            this.screenWidth = temp;
        }

        this.log.debug(`EditMain this.isVerticalScreen: ${this.isVerticalScreen},\
            leftBlank: ${JSON.stringify(this.leftBlank)}, screenSize: ${this.screenHeight},${this.screenWidth}`);
        this.imageScale = this.isVerticalScreen
            ? (this.screenHeight - this.titleSize - this.mainBottomSize) : (this.screenWidth - this.titleSize);
        this.imageScaleWidth = this.isVerticalScreen ? this.screenWidth : (this.screenHeight - this.mainBottomSize);
    }

    aboutToDisappear() {
        this.log.debug('aboutToDisappear');
        globalThis.EditorMediaItem = undefined;
        PhotoEditorManager.getInstance().clear();
        ScreenManager.getInstance().setSystemUi(true);
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
                    TitleBar({name: $r('app.string.editBar_text') })
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
                    .width(this.isVerticalScreen ? this.defaultWidth : this.barScale)

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
        .padding(this.isVerticalScreen
            ? { top: this.leftBlank[1], bottom: this.leftBlank[3] } : { bottom: this.leftBlank[3] })
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.black'))
    }
}
