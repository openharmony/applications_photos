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

import { ActionButton } from './ActionButton';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { ActionButtonInfo } from './MainMenuInfo';
import { RefreshActionMenu, ActionChangedEvent } from './RefreshMenu';
import { PhotoEditMode } from '../base/PhotoEditType';
import { Constants } from '../../../common/model/common/Constants';
import { PhotoEditorManager } from '../PhotoEditorManager';
import { Log } from '@ohos/base/src/main/ets/utils/Log';

@Component
export struct ToolBar {
    private TAG: string = 'ToolBar'
    @Consume editorManager: PhotoEditorManager;
    @Consume('selected') selectedMode: number;
    @Consume('scale') imageScale: number;
    @Consume('barSize') barScale: Resource;
    @Consume('compare') isCompare: boolean;
    @Consume broadCast: Broadcast;
    @State isImmersive: boolean = false;
    @Consume('verticalScreen') isVerticalScreen: boolean;
    @Consume screenWidth: number;
    @Consume screenHeight: number;
    @Consume mainBottomSize: number;
    @Consume titleSize: number;
    @Consume isRedo: boolean;
    @Consume isUndo: boolean;
    private menuClick: any = undefined;
    private immersiveClick: any = undefined;
    mainMenuList: Array<ActionButtonInfo> = [];
    @State @Watch('clickEvent') menuChanged: RefreshActionMenu = new RefreshActionMenu(-1, this.mainMenuList);

    clickEvent() {
        ActionChangedEvent.isActiveNotChanged(this.menuChanged);
    }

    onMenuClick(actionID: number) {
        for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
            if (actionID == this.menuChanged.menuArray[i].actionID) {
                this.selectedMode = this.menuChanged.menuArray[i].mode;
                Log.info(this.TAG, 'mainMenu onMenuClick mode = ' + this.selectedMode);
                this.menuChanged.isChanged = i;

                let canvasWidth = this.isVerticalScreen ? this.screenWidth : (this.screenHeight - this.mainBottomSize);
                switch (this.selectedMode) {
                    case PhotoEditMode.EDIT_MODE_CROP:
                        this.imageScale = this.isVerticalScreen
                            ? (this.screenHeight - this.titleSize - this.mainBottomSize)
                            : (this.screenWidth - this.titleSize);
                        this.barScale = $r('app.float.menuBar_edit');
                        this.isCompare = false;
                        break;
                    default:
                        Log.info(this.TAG, 'this.selectedMode is not toolBar');
                        break;
                }

                this.selectedMode = this.editorManager.switchMode(this.selectedMode);
                this.isRedo = this.editorManager.isRedoValid();
                this.isUndo = this.editorManager.isUndoValid();
                this.editorManager.getPhotoEditBaseInstance(this.selectedMode)
                    .setCanvasSize(canvasWidth, this.imageScale);
            }
        }
    }

    immersive(isImmersive: boolean) {
        this.isImmersive = isImmersive;
    }

    aboutToAppear() {
        this.menuClick = this.onMenuClick.bind(this);
        this.immersiveClick = this.immersive.bind(this);
        this.broadCast.on(Constants.UPDATE_MENU, this.menuClick);
        this.broadCast.on(Constants.IS_IMMERSIVE, this.immersiveClick);

        for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
            if (this.selectedMode == this.menuChanged.menuArray[i].mode) {
                Log.info(this.TAG, 'mainMenu onMenuClick mode = ' + this.selectedMode);
                this.menuChanged.isChanged = i;
            }
        }
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.UPDATE_MENU, this.menuClick);
        this.broadCast.off(Constants.IS_IMMERSIVE, this.immersiveClick);
    }

    build() {
        Flex({
            direction: this.isVerticalScreen ? FlexDirection.Row : FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            ForEach(this.menuChanged.menuArray, (item: ActionButtonInfo) => {
                ActionButton({
                    src: item.src,
                    text: item.text,
                    isActive: item.isActive,
                    actionID: item.actionID,
                    widthOfActionButton: this.isVerticalScreen
                        ? $r('app.float.edit_vertical_toolBar_size') : $r('app.float.actionButton_default'),
                    heightOfActionButton: this.isVerticalScreen
                        ? $r('app.float.actionButton_default') : $r('app.float.edit_horizontal_toolBar_size')
                })
            })
        }
        .visibility(this.isImmersive ? Visibility.Hidden : Visibility.Visible)
        .height(this.isVerticalScreen ? $r('app.float.actionButton_default') : '100%')
        .width(this.isVerticalScreen ? '100%' : $r('app.float.actionButton_default'))
        .padding(this.isVerticalScreen ? {
                                             left: $r('app.float.edit_toolBar_padding'),
                                             right: $r('app.float.edit_toolBar_padding')
                                         }
                                       : {
                                             bottom: $r('app.float.edit_toolBar_padding'),
                                             top: $r('app.float.edit_toolBar_padding')
                                         })
    }
}