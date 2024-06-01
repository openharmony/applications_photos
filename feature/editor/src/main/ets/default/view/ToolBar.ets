/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { BroadCast, Constants, Log } from '@ohos/common';
import { ActionButtonInfo } from './MainMenuInfo';
import { ActionChangedEvent, RefreshActionMenu } from './RefreshMenu';
import { PhotoEditMode } from '../base/PhotoEditType';
import { PhotoEditorManager } from '../PhotoEditorManager';

const TAG: string = 'editor_ToolBar';

const comPonentKeyEditCrop: string = 'EditToolBarCrop';

@Component
export struct ToolBar {
  @Consume editorManager: PhotoEditorManager;
  @Consume('selected') selectedMode: number;
  @Consume('scale') imageScale: number;
  @Consume('barSize') barScale: Resource;
  @Consume('compare') isCompare: boolean;
  @Consume broadCast: BroadCast;
  @State isImmersive: boolean = false;
  @Consume('verticalScreen') isVerticalScreen: boolean;
  @Consume screenWidth: number;
  @Consume screenHeight: number;
  @Consume mainBottomSize: number;
  @Consume titleSize: number;
  @Consume isRedo: boolean;
  @Consume isUndo: boolean;
  mainMenuList: Array<ActionButtonInfo> = [
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_toolbar_crop'),

      // 加入其它按钮时改为PhotoEditMode.EDIT_MODE_CROP
      actionID: undefined,
      text: $r('app.string.crop_text'),
      isActive: true,
      componentKey: comPonentKeyEditCrop
    })
  ];
  /**
   * 2022年8月11日 @Watch('clickEvent')打包报错
   * @State @Watch('clickEvent') menuChanged: RefreshActionMenu =
   * new RefreshActionMenu(-1, this.mainMenuList);
   */
  @State menuChanged: RefreshActionMenu = new RefreshActionMenu(-1, this.mainMenuList);
  private textSize: number | Resource = $r('app.float.buttonActionTextSize_default');
  private menuClick: Function = (): void => {};
  private immersiveClick: Function = (): void => {};

  clickEvent() {
    ActionChangedEvent.isActiveNotChanged(this.menuChanged);
  }

  onMenuClick(actionID: number) {
    for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
      if (actionID == this.menuChanged.menuArray[i].actionID) {
        this.selectedMode = this.menuChanged.menuArray[i].mode;
        Log.info(TAG, 'mainMenu onMenuClick mode = ' + this.selectedMode);
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
            Log.info(TAG, 'this.selectedMode is not toolBar');
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
    this.menuClick = (actionID: number): void => this.onMenuClick(actionID);
    this.immersiveClick = (isImmersive: boolean): void => this.immersive(isImmersive);
    this.broadCast.on(Constants.UPDATE_MENU, this.menuClick);
    this.broadCast.on(Constants.IS_IMMERSIVE, this.immersiveClick);

    for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
      if (this.selectedMode == this.menuChanged.menuArray[i].mode) {
        Log.info(TAG, 'mainMenu onMenuClick mode = ' + this.selectedMode);
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
          textSize: this.textSize,
          isActive: item.isActive,
          actionID: item.actionID,
          widthOfActionButton: this.isVerticalScreen
            ? $r('app.float.edit_vertical_toolBar_size') : $r('app.float.actionButton_default'),
          heightOfActionButton: this.isVerticalScreen
            ? $r('app.float.actionButton_default') : $r('app.float.edit_horizontal_toolBar_size'),
          componentKey: item.componentKey
        })
      })
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
  }
}